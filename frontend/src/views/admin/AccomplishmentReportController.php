<?php

namespace App\Controllers;

use App\Models\AccomplishmentReportModel;
use CodeIgniter\API\ResponseTrait;

class AccomplishmentReportController extends BaseController
{
    use ResponseTrait;

    public function submitReport()
    {
        $db = \Config\Database::connect();
        $reportModel = new AccomplishmentReportModel();

        try {
            $db->transStart();

            // 1. Handle Multiple File Uploads
            $attachments = $this->request->getFileMultiple('attachment');
            $fileNames = [];
            
            if ($attachments) {
                foreach ($attachments as $file) {
                    if ($file->isValid() && !$file->hasMoved()) {
                        $newName = $file->getRandomName();
                        $file->move(FCPATH . 'uploads', $newName);
                        $fileNames[] = $newName;
                    }
                }
            }

            // 2. Prepare Main Report Data
            $reportData = [
                'control_number' => $this->request->getPost('control_number'),
                'act_design_id'  => $this->request->getPost('act_design_id'),
                'activity_title' => $this->request->getPost('activity_title'),
                'start_date'     => $this->request->getPost('start_date'),
                'end_date'       => $this->request->getPost('end_date'),
                'start_time'     => $this->request->getPost('start_time'),
                'end_time'       => $this->request->getPost('end_time'),
                'venue'          => $this->request->getPost('venue'),
                'attendees'      => $this->request->getPost('attendees'),
                'male'           => $this->request->getPost('male'),
                'female'         => $this->request->getPost('female'),
                'rating'         => $this->request->getPost('rating'),
                'user_id'        => $this->request->getPost('user_id'),
                'attachment'     => json_encode($fileNames), // Store list of files as JSON
                'status'         => 'Pending'
            ];

            $reportId = $reportModel->insert($reportData);

            if (!$reportId) {
                throw new \Exception("Failed to insert main report.");
            }

            // 3. Handle Actual Budget Items
            $budgetItems = json_decode($this->request->getPost('budget_items'), true);
            if (!empty($budgetItems)) {
                $budgetData = ['accomplishment_report_id' => $reportId];
                $budgetMapping = [
                    'Meals and Snacks (AM/PM)' => 'meals_and_snacks',
                    'Function Room/Venue'      => 'function_room_venue',
                    'Accommodation'            => 'accommodation',
                    'Equipment Rental'         => 'equipment_rental',
                    'Professional Fee/Honoria' => 'professional_fee_honoria',
                    'Token/s'                  => 'tokens',
                    'Materials and Supplies'   => 'materials_and_supplies',
                    'Transportation'           => 'transportation'
                ];

                foreach ($budgetItems as $item) {
                    if (isset($budgetMapping[$item['name']])) {
                        $budgetData[$budgetMapping[$item['name']]] = $item['total'] ?: 0;
                    }
                }
                $db->table('accomplishment_budget_items')->insert($budgetData);
            }

            // 4. Handle Evaluation Results
            $evaluationItems = json_decode($this->request->getPost('evaluation_items'), true);
            if (!empty($evaluationItems)) {
                $evalData = ['accomplishment_report_id' => $reportId];
                $evalMapping = [
                    'Time Management'                   => 'time_management',
                    'Orderliness and Program Flow'      => 'orderliness_and_program_flow',
                    'Appropriateness of the Venue'      => 'appropriateness_of_venue',
                    'Sound System and Hall Preparation' => 'sound_system_and_hall_preparation',
                    'Restroom/s'                        => 'restrooms',
                    'Food and Drinks'                   => 'food_and_drinks'
                ];

                foreach ($evaluationItems as $item) {
                    if (isset($evalMapping[$item['area']])) {
                        $evalData[$evalMapping[$item['area']]] = $item['rating'] ?: 0;
                    }
                }
                $db->table('accomplishment_evaluation_results')->insert($evalData);
            }

            $db->transComplete();

            if ($db->transStatus() === false) {
                return $this->fail('Transaction failed.');
            }

            return $this->respondCreated([
                'success' => true,
                'message' => 'Accomplishment report submitted successfully.'
            ]);

        } catch (\Exception $e) {
            $db->transRollback();
            return $this->fail($e->getMessage());
        }
    }

    public function index()
    {
        $db = \Config\Database::connect();

        $reports = $db->table('accomplishment_report as ar')
            ->select('ar.id, ar.user_id, ar.act_design_id, ar.control_number as control, ar.activity_title as title, ar.start_date as date, ar.status, u.username as office, u.username as username, u.email, ad.form_type as formLabel')            ->join('users u', 'u.id = ar.user_id', 'left')
            ->join('activity_design ad', 'ad.act_design_id = ar.act_design_id', 'left')
            ->orderBy('ar.created_at', 'DESC')
            ->get()->getResultArray();

        // Fallback for form_type if activity_design is archived
        // This ensures that even if the original activity design is moved to archive,
        // the form_type can still be retrieved for the accomplishment report.
        foreach ($reports as &$report) {
            if (empty($report['formLabel']) && !empty($report['act_design_id'])) {
                $archive = $db->table('archived_activity_designs')
                    ->select('form_type')
                    ->where('original_act_design_id', $report['act_design_id'])
                    ->get()
                    ->getRowArray();
                
                if ($archive) {
                    $report['formLabel'] = $archive['form_type'];
                }
            }
        }

        return $this->response->setJSON(['success' => true, 'data' => $reports]);
    }

    public function getUserReports($userId = null)
    {
        $model = new AccomplishmentReportModel();
        $reports = $model->select('accomplishment_report.*, accomplishment_report.activity_title as title, accomplishment_report.control_number as control, accomplishment_report.start_date as date')
                         ->where('user_id', $userId)
                         ->orderBy('created_at', 'DESC')
                         ->findAll();

        return $this->respond(['success' => true, 'data' => $reports]);
    }

    public function show($id = null)
    {
        $db = \Config\Database::connect();
        
        // Perform JOINS to get data from related tables, including the user and the original design's form type
        $report = $db->table('accomplishment_report as ar')
            ->select('ar.*, abi.*, aer.*, u.username, u.email, u.username as office, ad.form_type')
            ->join('users u', 'u.id = ar.user_id', 'left')
            // Join the actual budget items table
            ->join('accomplishment_budget_items abi', 'abi.accomplishment_report_id = ar.id', 'left')
            // Join the evaluation results table
            ->join('accomplishment_evaluation_results aer', 'aer.accomplishment_report_id = ar.id', 'left')
            // Join activity design to get form_type
            ->join('activity_design ad', 'ad.act_design_id = ar.act_design_id', 'left')
            ->where('ar.id', $id)
            ->get()
            ->getRowArray();

        // Fallback: If form_type is empty (design might be archived), check archived_activity_designs
        if ($report && empty($report['form_type'])) {
            $archive = $db->table('archived_activity_designs')
                ->select('form_type')
                ->where('original_act_design_id', $report['act_design_id'])
                ->get()
                ->getRowArray();
            
            if ($archive) {
                $report['form_type'] = $archive['form_type'];
            }
        }

        if (!$report) {
            return $this->response->setJSON(['success' => false, 'message' => 'Report not found'])->setStatusCode(404);
        }

        return $this->response->setJSON(['success' => true, 'data' => $report]);
    }

    public function verifyReport($id = null)
    {
        $reportModel = new AccomplishmentReportModel();
        
        $data = [
            'status'          => 'Verified',
            'assessment_date' => $this->request->getPost('assessment_date'),
            'remarks'         => $this->request->getPost('remarks'),
        ];

        if ($reportModel->update($id, $data)) {
            return $this->respond(['success' => true, 'message' => 'Report verified successfully.']);
        }

        return $this->fail('Failed to verify report.');
    }

    public function revisionReport($id = null)
    {
        $reportModel = new AccomplishmentReportModel();
        
        $data = [
            'status'          => 'Revision',
            'assessment_date' => $this->request->getPost('assessment_date'),
            'remarks'         => $this->request->getPost('remarks'),
        ];

        if ($reportModel->update($id, $data)) {
            return $this->respond(['success' => true, 'message' => 'Revision requested successfully.']);
        }

        return $this->fail('Failed to request revision.');
    }
}