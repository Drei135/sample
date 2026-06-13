<?php

namespace App\Controllers;

use App\Models\AccomplishmentReportModel;
use App\Libraries\FileStorage;

class AccomplishmentReportController extends BaseController
{
    public function submitReport()
    {
        $accomplishmentReportModel = new AccomplishmentReportModel();

        // Validation rules aligned with frontend FormData field names (underscores)
        $rules = [
            "activity_title" => "required",
            "control_number" => "required",
            "start_date"     => "required",
            "end_date"       => "required",
            "start_time"     => "required",
            "end_time"       => "required",
            "venue"          => "required",
            "attendees"      => "required|integer",
            "male"           => "required|integer",
            "female"         => "required|integer",
            "rating"         => "required|numeric",
            "user_id"        => "required",
            "attachment"     => "uploaded[attachment]|max_size[attachment,10240]|ext_in[attachment,pdf]",
        ];

        if (!$this->validate($rules)) {
            return $this->response->setJSON([
                "success" => false,
                "errors"  => $this->validator->getErrors()
            ])->setStatusCode(422);
        }

        try {
            // Save uploaded PDF to writable/uploads/drafts/
            $file = $this->request->getFile('attachment');
            $fileName = FileStorage::saveToDrafts($file);

            $db = \Config\Database::connect();
            $controlRecord = $db->table('control_number')
                                ->where('control_number', $this->request->getPost("control_number"))
                                ->get()->getRowArray();
            $actDesignId = $controlRecord ? $controlRecord['act_design_id'] : null;

            $data = [
                "activity_title" => $this->request->getPost("activity_title"),
                "control_number" => $this->request->getPost("control_number"),
                "act_design_id"  => $actDesignId,
                "start_date"     => $this->request->getPost("start_date"),
                "end_date"       => $this->request->getPost("end_date"),
                "start_time"     => $this->request->getPost("start_time"),
                "end_time"       => $this->request->getPost("end_time"),
                "venue"          => $this->request->getPost("venue"),
                "attendees"      => $this->request->getPost("attendees"),
                "male"           => $this->request->getPost("male"),
                "female"         => $this->request->getPost("female"),
                "rating"         => $this->request->getPost("rating"),
                "user_id"        => $this->request->getPost("user_id"),
                "attachment"     => $fileName,
                "status"         => "Pending",
            ];

            if (empty($data['user_id'])) {
                throw new \Exception("User ID is missing. Please log in again.");
            }

            if ($accomplishmentReportModel->insert($data)) {
                return $this->response->setJSON([
                    "success" => true,
                    "message" => "Data saved successfully"
                ]);
            }

            return $this->response->setJSON([
                "success" => false,
                "message" => "Failed to save data into database.",
                "errors"  => $accomplishmentReportModel->errors()
            ])->setStatusCode(500);

        } catch (\Exception $e) {
            return $this->response->setJSON([
                "success" => false,
                "message" => "Server Error: " . $e->getMessage()
            ])->setStatusCode(500);
        }
    }

    public function index()
    {
        $db = \Config\Database::connect();

        $active = $db->table('accomplishment_report as ar')
            ->select('ar.id, ar.status, cn.control_number as control, ar.activity_title as title, DATE(ar.created_at) as date, users.username as office, users.full_name as submitter_name, ad.form_type as formLabel')
            ->join('users', 'users.id = ar.user_id', 'left')
            ->join('control_number as cn', 'cn.control_number = ar.control_number', 'left')
            ->join('archived_activity_designs as ad', 'ad.original_act_design_id = cn.act_design_id', 'left')
            ->get()->getResultArray();

        $archived = $db->table('archived_accomplishment_reports as aar')
            ->select('aar.original_report_id as id, aar.status, cn.control_number as control, aar.activity_title as title, DATE(aar.created_at) as date, users.username as office, users.full_name as submitter_name, ad.form_type as formLabel')
            ->join('users', 'users.id = aar.user_id', 'left')
            ->join('control_number as cn', 'cn.control_number = aar.control_number', 'left')
            ->join('archived_activity_designs as ad', 'ad.original_act_design_id = cn.act_design_id', 'left')
            ->get()->getResultArray();

        $reports = array_merge($active, $archived);
        usort($reports, function($a, $b) {
            return $b['id'] <=> $a['id'];
        });

        return $this->response->setJSON([
            'success' => true,
            'data'    => $reports
        ]);
    }

    public function show($id = null)
    {
        if (!$id) {
            return $this->response->setJSON(['success' => false, 'message' => 'Report ID required'])->setStatusCode(400);
        }

        $accomplishmentReportModel = new AccomplishmentReportModel();
        $report = $accomplishmentReportModel
            ->select('accomplishment_report.*, control_number.control_number as control, DATE(accomplishment_report.created_at) as date, users.username as office, users.full_name as submitter_name, activity_design.form_type as formLabel')
            ->join('users', 'users.id = accomplishment_report.user_id', 'left')
            ->join('control_number', 'control_number.control_number = accomplishment_report.control_number', 'left')
            ->join('activity_design', 'activity_design.act_design_id = control_number.act_design_id', 'left')
            ->where('accomplishment_report.id', $id)
            ->first();

        if (!$report) {
            $db = \Config\Database::connect();
            $report = $db->table('archived_accomplishment_reports as aar')
                ->select('aar.*, aar.original_report_id as id, aar.activity_title as title, DATE(aar.created_at) as date, users.username as office, users.full_name as submitter_name, aar.control_number as control')
                ->join('users', 'users.id = aar.user_id', 'left')
                ->where('aar.original_report_id', $id)
                ->get()->getRowArray();

            if (!$report) {
                return $this->response->setJSON(['success' => false, 'message' => 'Report not found'])->setStatusCode(404);
            }
            $report['is_archived'] = true;
        } else {
            $report['is_archived'] = false;
        }

        return $this->response->setJSON(['success' => true, 'data' => $report]);
    }

    public function getUserReports($userId = null)
    {
        if (!$userId) {
            return $this->response->setJSON(['success' => false, 'message' => 'User ID required'])->setStatusCode(400);
        }

        $db = \Config\Database::connect();

        $active = $db->table('accomplishment_report as ar')
            ->select('ar.id, ar.status, cn.control_number as control, ar.activity_title as title, DATE(ar.created_at) as date, users.username as office, users.full_name as submitter_name, ad.form_type as formLabel')
            ->join('users', 'users.id = ar.user_id', 'left')
            ->join('control_number as cn', 'cn.control_number = ar.control_number', 'left')
            ->join('archived_activity_designs as ad', 'ad.original_act_design_id = cn.act_design_id', 'left')
            ->where('ar.user_id', $userId)
            ->get()->getResultArray();

        $archived = $db->table('archived_accomplishment_reports as aar')
            ->select('aar.original_report_id as id, aar.status, cn.control_number as control, aar.activity_title as title, DATE(aar.created_at) as date, users.username as office, users.full_name as submitter_name, ad.form_type as formLabel')
            ->join('users', 'users.id = aar.user_id', 'left')
            ->join('control_number as cn', 'cn.control_number = aar.control_number', 'left')
            ->join('archived_activity_designs as ad', 'ad.original_act_design_id = cn.act_design_id', 'left')
            ->where('aar.user_id', $userId)
            ->get()->getResultArray();

        $reports = array_merge($active, $archived);
        usort($reports, function($a, $b) {
            return $b['id'] <=> $a['id'];
        });

        return $this->response->setJSON([
            'success' => true,
            'data'    => $reports
        ]);
    }

    public function getArchivedReports()
    {
        $accomplishmentReportModel = new AccomplishmentReportModel();

        $reports = $accomplishmentReportModel
            ->select('accomplishment_report.*, control_number.control_number as control, accomplishment_report.activity_title as title, DATE(accomplishment_report.created_at) as date, users.username as office, users.full_name as submitter_name, activity_design.form_type as formLabel')
            ->join('users', 'users.id = accomplishment_report.user_id', 'left')
            ->join('control_number', 'control_number.control_number = accomplishment_report.control_number', 'left')
            ->join('activity_design', 'activity_design.act_design_id = control_number.act_design_id', 'left')
            ->whereIn('accomplishment_report.status', ['Verified', 'Cancelled'])
            ->orderBy('accomplishment_report.id', 'DESC')
            ->findAll();

        return $this->response->setJSON([
            'success' => true,
            'data'    => $reports
        ]);
    }

    public function updateReport($id)
    {
        $model = new AccomplishmentReportModel();

        $report = $model->find($id);
        if (!$report) {
            return $this->response->setJSON([
                'success' => false,
                'message' => "Accomplishment report record #$id not found."
            ])->setStatusCode(404);
        }

        // Collect only the fields sent in the request
        $data = [
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
            'status'         => $this->request->getPost('status') ?? 'Pending',
        ];

        // Remove null/empty values so we only update provided fields
        $updateData = array_filter($data, function($value) {
            return $value !== null && $value !== '';
        });

        // Handle new file upload (if any) — saves to drafts, removes old draft
        $file = $this->request->getFile('attachment');
        if ($file && $file->isValid() && !$file->hasMoved()) {
            if (!empty($report['attachment'])) {
                FileStorage::deleteFromDrafts($report['attachment']);
            }
            $newName = FileStorage::saveToDrafts($file);
            $updateData['attachment'] = $newName;
        }

        try {
            if ($model->update($id, $updateData)) {
                return $this->response->setJSON([
                    'success' => true,
                    'message' => 'Accomplishment Report updated and resubmitted successfully.'
                ]);
            } else {
                return $this->response->setJSON([
                    'success' => false,
                    'message' => 'Database update failed.',
                    'errors'  => $model->errors()
                ])->setStatusCode(400);
            }
        } catch (\Exception $e) {
            return $this->response->setJSON([
                'success' => false,
                'message' => 'An error occurred: ' . $e->getMessage()
            ])->setStatusCode(500);
        }
    }

    /**
     * Approve (Verify) an Accomplishment Report:
     *  1. Updates status to 'Verified'
     *  2. Inserts into archived_accomplishment_reports table
     *  3. Deletes from active accomplishment_report table
     *  4. Moves the PDF from drafts → archived
     */
    public function approveReport($id = null)
    {
        if (!$id) {
            return $this->response->setJSON(['success' => false, 'message' => 'Report ID required'])->setStatusCode(400);
        }

        $body    = $this->request->getJSON(true) ?? $this->request->getPost();
        $remarks = $body['remarks'] ?? '';

        $db = \Config\Database::connect();
        $db->transStart();

        $item = $db->table('accomplishment_report')->where('id', $id)->get()->getRowArray();
        if (!$item) {
            return $this->response->setJSON(['success' => false, 'message' => 'Report not found'])->setStatusCode(404);
        }

        // Insert into archived_accomplishment_reports
        $archiveData = [
            'original_report_id' => $item['id'],
            'control_number'     => $item['control_number'],
            'act_design_id'      => $item['act_design_id'] ?? null,
            'activity_title'     => $item['activity_title'],
            'start_date'         => $item['start_date'],
            'end_date'           => $item['end_date'],
            'start_time'         => $item['start_time'],
            'end_time'           => $item['end_time'],
            'venue'              => $item['venue'],
            'attendees'          => $item['attendees'],
            'male'               => $item['male'],
            'female'             => $item['female'],
            'rating'             => $item['rating'],
            'attachment'         => $item['attachment'],
            'user_id'            => $item['user_id'],
            'status'             => 'Verified',
            'remarks'            => $remarks,
        ];
        $db->table('archived_accomplishment_reports')->insert($archiveData);

        // Delete from active table
        $db->table('accomplishment_report')->where('id', $id)->delete();

        $db->transComplete();

        if ($db->transStatus() === false) {
            return $this->response->setJSON(['success' => false, 'message' => 'Failed to verify and archive report'])->setStatusCode(500);
        }

        // Move PDF from drafts → archived (outside transaction)
        FileStorage::moveToArchived($item['attachment']);

        return $this->response->setJSON([
            'success' => true,
            'message' => 'Accomplishment Report verified and archived successfully.'
        ]);
    }

    public function revisionReport($id = null)
    {
        if (!$id) {
            return $this->response->setJSON(['success' => false, 'message' => 'Report ID required'])->setStatusCode(400);
        }

        $body = $this->request->getJSON(true) ?? $this->request->getPost();
        $remarks = $body['remarks'] ?? '';
        $deadline = $body['deadline'] ?? null;

        $db = \Config\Database::connect();
        
        // Update status and remarks for the accomplishment report
        $db->table('accomplishment_report')->where('id', $id)->update([
            'status'  => 'Revision',
            'remarks' => $remarks
        ]);

        return $this->response->setJSON([
            'success' => true,
            'message' => 'Sent for revision successfully'
        ]);
    }
}