<?php

namespace App\Controllers;

use CodeIgniter\RESTful\ResourceController;

class ArchiveController extends ResourceController
{
    protected $format = 'json';

    /**
     * Fetch all records from the archive table
     */
    public function index()
    {
        $db = \Config\Database::connect();

        // Fetch Archived Designs
        $designs = $db->table('archived_activity_designs as aad')
            ->select('aad.*, aad.original_act_design_id as original_id, "design" as type, aad.activity_title as title, aad.form_type as form_label, users.username as office, aad.start_date as date, aad.archived_at as dateRaw')
            ->join('users', 'users.id = aad.user_id', 'left')
            // Try to get control number if it still exists in source control_number table
            ->join('control_number as cn', 'cn.act_design_id = aad.original_act_design_id', 'left')
            ->select('COALESCE(cn.control_number, "N/A") as control')
            ->get()->getResultArray();
            
        // Fetch Archived Reports
        $reports = $db->table('archived_accomplishment_reports as aar')
            ->select('aar.*, aar.original_report_id as original_id, "report" as type, aar.activity_title as title, "N/A" as form_label, users.username as office, aar.start_date as date, aar.control_number as control, aar.archived_at as dateRaw')
            ->join('users', 'users.id = aar.user_id', 'left')
            ->get()->getResultArray();

        $all = array_merge($designs, $reports);
        
        // Sort by archived_at desc
        usort($all, function($a, $b) {
            return strtotime($b['archived_at']) - strtotime($a['archived_at']);
        });

        return $this->respond([
            'success' => true,
            'data'    => $all
        ]);
    }

    /**
     * Move an Activity Design to Archive (Physical move)
     */
    public function archiveDesign($id = null)
    {
        $db = \Config\Database::connect();
        $db->transStart();

        $item = $db->table('activity_design')->where('act_design_id', $id)->get()->getRowArray();

        if (!$item) return $this->failNotFound('Design not found');

        $body = $this->request->getJSON(true) ?? $this->request->getPost();
        $remarks = $body['remarks'] ?? '';

        // 2. Prepare Archive record
        $archiveData = [
            'original_act_design_id' => $item['act_design_id'],
            'activity_title'         => $item['activity_title'],
            'start_date'             => $item['start_date'],
            'end_date'               => $item['end_date'],
            'start_time'             => $item['start_time'],
            'end_time'               => $item['end_time'],
            'status'                 => 'Cancelled',
            'remarks'                => $remarks,
            'attachment'             => $item['attachment'],
            'user_id'                => $item['user_id'],
            'gpb_id'                 => $item['gpb_id'] ?? null,
            'venue'                  => $item['venue'],
            'venue_id'               => $item['venue_id'],
            'target_participants'    => $item['target_participants'],
            'budgetary_requirements' => $item['budgetary_requirements'],
            'proposed_budget'        => $item['proposed_budget'],
            'form_type'              => $item['form_type']
        ];

        // 3. Insert and Delete
        $db->table('archived_activity_designs')->insert($archiveData);
        $db->table('activity_design')->where('act_design_id', $id)->delete();

        $db->transComplete();

        if ($db->transStatus() === false) {
            return $this->failServerError('Failed to move design to archive');
        }

        return $this->respond(['success' => true, 'message' => 'Activity Design archived and cleared from active list']);
    }

    /**
     * Move an Accomplishment Report to Archive (Physical move)
     */
    public function archiveReport($id = null)
    {
        $db = \Config\Database::connect();
        $db->transStart();

        $item = $db->table('accomplishment_report')->where('id', $id)->get()->getRowArray();

        if (!$item) return $this->failNotFound('Report not found');

        $archiveData = [
            'original_report_id' => $item['id'],
            'control_number'     => $item['control_number'],
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
            'status'             => 'Verified'
        ];

        $db->table('archived_accomplishment_reports')->insert($archiveData);
        $db->table('accomplishment_report')->where('id', $id)->delete();

        $db->transComplete();
        if ($db->transStatus() === false) {
            return $this->failServerError('Failed to move report to archive');
        }
        return $this->respond(['success' => true, 'message' => 'Accomplishment Report archived and cleared']);
    }
}