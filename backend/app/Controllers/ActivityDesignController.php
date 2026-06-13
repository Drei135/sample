<?php

namespace App\Controllers;

use App\Models\ActivityDesignModel;

class ActivityDesignController extends BaseController
{
    public function submitDesign()
    {
        $activityDesignModel = new ActivityDesignModel();

        $rules = [
            "form-type"           => "required",
            "activity-title"      => "required",
            "start-date"          => "required",
            "end-date"            => "required",
            "start-time"          => "required",
            "end-time"            => "required",
            "venue-name"          => "required",
            "target-participants" => "required|numeric",
            "budgetary-requirements" => "required",
            "proposed-budget"     => "required|numeric",
            "user_id"             => "required",
            "attachment"         => "uploaded[attachment]|max_size[attachment,10240]|ext_in[attachment,pdf]",
        ];

        $messages = [
            "form-type" => ["required" => "Form type is required"],
            "activity-title" => ["required" => "Activity title is required"],
            "start-date" => ["required" => "Start date is required"],
            "end-date" => ["required" => "End date is required"],
            "start-time" => ["required" => "Start time is required"],
            "end-time" => ["required" => "End time is required"],
            "venue-name" => ["required" => "Venue is required"],
            "target-participants" => [
                "required" => "Target participants is required",
                "numeric"  => "Target participants must be a number",
            ],
            "budgetary-requirements" => ["required" => "Budgetary requirements are required"],
            "proposed-budget" => [
                "required" => "Proposed budget is required",
                "numeric"  => "Proposed budget must be a numeric value",
            ],
            "user_id" => ["required" => "User identification is missing"],
            "attachment" => [
                "required" => "Design file is required",
                "uploaded" => "Design file was not uploaded correctly",
                "max_size" => "Design file size exceeds the 10MB limit",
                "ext_in" => "Design file must be a PDF",
            ],
        ];

        if (!$this->validate($rules, $messages)) {
            // FIX 2: Return errors as a JSON object, not a view
            return $this->response->setJSON([
                "success" => false,
                "errors"  => $this->validator->getErrors()
            ])->setStatusCode(422);
        }

        try {
            $db = \Config\Database::connect();
            $db->transStart(); // Start transaction

            // FIX 3: Process and store physical upload file appropriately
            $file = $this->request->getFile('attachment');
            $fileName = '';

            if ($file && $file->isValid() && !$file->hasMoved()) {
                $fileName = $file->getRandomName();
                $uploadPath = FCPATH . 'uploads';

                if (!is_dir($uploadPath)) {
                    mkdir($uploadPath, 0777, true);
                }
                
                $file->move($uploadPath, $fileName);
            }

            /**
             * RESOLVE VENUE LOGIC:
             * If venue-id is missing (User chose 'Other'), we check if the venue exists in the database.
             * If it doesn't exist, we insert it into the 'venues' table.
             */
            $venueId = $this->request->getPost("venue-id");
            $venueName = $this->request->getPost("venue-name");
            if (empty($venueId) && !empty($venueName)) {
                $vTable = $db->table('venues');
                $existing = $vTable->where('venue_name', $venueName)->get()->getRowArray();
                if ($existing) { 
                    $venueId = $existing['venue_id'];
                } else {
                    $vTable->insert(['venue_name' => $venueName]);
                    $venueId = $db->insertID();
                }
            }

            $data = [
                "form_type"           => $this->request->getPost("form-type"),
                "activity_title"      => $this->request->getPost("activity-title"),
                "start_date"          => $this->request->getPost("start-date"),
                "end_date"            => $this->request->getPost("end-date"),
                "start_time"          => $this->request->getPost("start-time"),
                "end_time"            => $this->request->getPost("end-time"),
                "venue_id"            => $venueId,
                "venue"               => $venueName,
                "target_participants" => $this->request->getPost("target-participants"),
                "proposed_budget"     => $this->request->getPost("proposed-budget"),
                "user_id"             => $this->request->getPost("user_id"),
                "attachment"          => $fileName,
                "status"              => "Pending",
            ];

            if (empty($data['user_id'])) {
                throw new \Exception("User ID is missing. Please log in again.");
            }

            $insertId = $activityDesignModel->insert($data);
            
            if ($insertId) {
                // Handle Budget Items
                $budgetItems = json_decode($this->request->getPost("budgetary-requirements"), true);
                if (!empty($budgetItems)) {
                    $budgetData = ['act_design_id' => $insertId];
                    $mapping = [
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
                        if (isset($mapping[$item['name']])) {
                            $budgetData[$mapping[$item['name']]] = $item['total'] ?: 0;
                        }
                    }
                    $db->table('activity_budget_items')->insert($budgetData);
                }

                $db->transComplete();
                if ($db->transStatus() === true) {
                    return $this->response->setJSON(["success" => true, "message" => "Data saved successfully"]);
                }
            }

            // If insertion fails (e.g. model validation), return specific errors
            return $this->response->setJSON([
                "success" => false,
                "message" => "Failed to save data into database.",
                "errors"  => $activityDesignModel->errors()
            ])->setStatusCode(500);

        } catch (\Exception $e) {
            // Catch database or file system exceptions to provide a clear error message
            return $this->response->setJSON([
                "success" => false,
                "message" => "Server Error: " . $e->getMessage()
            ])->setStatusCode(500);
        }
    }

    public function index()
    {
        $activityDesignModel = new ActivityDesignModel();

        // Fetch all activity designs joined with control numbers and user office details
        $designs = $activityDesignModel
            ->select('activity_design.*, abi.*, control_number.control_number as control, users.username as office, users.username as username, activity_design.activity_title as title, activity_design.form_type as formLabel, activity_design.start_date as date, COALESCE(venues.venue_name, activity_design.venue) as venue')
            ->join('users', 'users.id = activity_design.user_id', 'left')
            ->join('venues', 'venues.venue_id = activity_design.venue_id', 'left')
            ->join('activity_budget_items abi', 'abi.act_design_id = activity_design.act_design_id', 'left')
            ->join('control_number', 'control_number.act_design_id = activity_design.act_design_id', 'left')
            ->orderBy('activity_design.act_design_id', 'DESC')
            ->findAll();

        return $this->response->setJSON([
            'success' => true,
            'data'    => $designs
        ]);
    }


    public function getUserDesigns($userId = null)
    {
        if (!$userId) {
            return $this->response->setJSON(['success' => false, 'message' => 'User ID required'])->setStatusCode(400);
        }

        $activityDesignModel = new ActivityDesignModel();
        $designs = $activityDesignModel
                                       ->select('activity_design.*, abi.*, control_number.control_number as control, users.username as office, users.username as username, activity_design.activity_title as title, activity_design.form_type as formLabel, activity_design.start_date as date, COALESCE(venues.venue_name, activity_design.venue) as venue')
                                       ->join('users', 'users.id = activity_design.user_id', 'left')
                                       ->join('venues', 'venues.venue_id = activity_design.venue_id', 'left')
                                       ->join('activity_budget_items abi', 'abi.act_design_id = activity_design.act_design_id', 'left')
                                       ->join('control_number', 'control_number.act_design_id = activity_design.act_design_id', 'left')
                                       ->where('activity_design.user_id', $userId)
                                       ->orderBy('activity_design.act_design_id', 'DESC')
                                       ->findAll();

        return $this->response->setJSON([
            'success' => true,
            'data'    => $designs
        ]);
    }

    public function show($id = null)
    {
        if (!$id) {
            return $this->response->setJSON(['success' => false, 'message' => 'Design ID required'])->setStatusCode(400);
        }

        $activityDesignModel = new ActivityDesignModel();
        $design = $activityDesignModel
            ->select('activity_design.*, abi.*, control_number.control_number as control, users.username as office, users.username as username, activity_design.start_date as date, COALESCE(venues.venue_name, activity_design.venue) as venue')
            ->join('users', 'users.id = activity_design.user_id', 'left')
            ->join('venues', 'venues.venue_id = activity_design.venue_id', 'left')
            ->join('activity_budget_items abi', 'abi.act_design_id = activity_design.act_design_id', 'left')
            ->join('control_number', 'control_number.act_design_id = activity_design.act_design_id', 'left')
            ->where('activity_design.act_design_id', $id)
            ->first();

        if (!$design) {
            // Try searching in archive fallback
            $db = \Config\Database::connect();
            $design = $db->table('archived_activity_designs as aad')
                ->select('aad.*, aad.original_act_design_id as act_design_id, aad.activity_title as title, aad.form_type as formLabel, users.username as office, users.username as username, aad.start_date as date, COALESCE(v.venue_name, aad.venue) as venue')
                ->join('users', 'users.id = aad.user_id', 'left')
                ->join('control_number as cn', 'cn.act_design_id = aad.original_act_design_id', 'left')
                ->join('venues as v', 'v.venue_id = aad.venue_id', 'left')
                ->select('COALESCE(cn.control_number, "N/A") as control')
                ->where('aad.original_act_design_id', $id)
                ->get()->getRowArray();

            if (!$design) {
                return $this->response->setJSON(['success' => false, 'message' => 'Activity design not found'])->setStatusCode(404);
            }
        }

        return $this->response->setJSON(['success' => true, 'data' => $design]);
    }

    public function getTWGSubmissions()
    {
        $db = \Config\Database::connect();
        
        // Fetch users (excluding admin) and use subqueries to count submissions per user
        $users = $db->table('users')
            ->select('id, username, role')
            ->select('(SELECT COUNT(*) FROM activity_design WHERE activity_design.user_id = users.id) as activity_designs_count')
            ->select('(SELECT COUNT(*) FROM accomplishment_report WHERE accomplishment_report.user_id = users.id) as accomplishment_reports_count')
            ->where('role !=', 'admin')
            ->orderBy('id', 'ASC')
            ->get()
            ->getResultArray();

        $totalDesigns = 0;
        $totalReports = 0;
        
        // Cast counts to integers and calculate totals
        foreach ($users as &$u) {
            $u['activity_designs_count'] = (int)$u['activity_designs_count'];
            $u['accomplishment_reports_count'] = (int)$u['accomplishment_reports_count'];
            $u['total_submissions'] = $u['activity_designs_count'] + $u['accomplishment_reports_count'];
            
            $totalDesigns += $u['activity_designs_count'];
            $totalReports += $u['accomplishment_reports_count'];
        }

        return $this->response->setJSON([
            'success' => true,
            'data'    => $users,
            'meta'    => [
                'total' => count($users),
                'total_designs' => $totalDesigns,
                'total_reports' => $totalReports,
                'last_page' => 1
            ]
        ]);
    }

    public function getArchivedDesigns()
    {
        $activityDesignModel = new ActivityDesignModel();

        $designs = $activityDesignModel
            ->select('activity_design.*, control_number.control_number as control, users.username as office, users.username as username, activity_design.activity_title as title, activity_design.form_type as formLabel, activity_design.start_date as date, COALESCE(venues.venue_name, activity_design.venue) as venue')
            ->join('users', 'users.id = activity_design.user_id', 'left')
            ->join('venues', 'venues.venue_id = activity_design.venue_id', 'left')
            ->join('control_number', 'control_number.act_design_id = activity_design.act_design_id', 'left')
            ->whereIn('activity_design.status', ['Approved', 'Cancelled'])
            ->orderBy('activity_design.act_design_id', 'DESC')
            ->findAll();

        return $this->response->setJSON([
            'success' => true,
            'data'    => $designs
        ]);
    }

    public function updateDesign($id)
    {
        $model = new ActivityDesignModel(); 
        
        $design = $model->find($id);
        if (!$design) {
            return $this->response->setJSON([
                'success' => false,
                'message' => "Activity design record #$id not found."
            ])->setStatusCode(404);
        }

        $db = \Config\Database::connect();
        $venueId = $this->request->getPost("venue-id");
        $venueName = $this->request->getPost("venue-name");

        // Handle venue resolution for updates
        if (empty($venueId) && !empty($venueName)) {
            $vTable = $db->table('venues');
            $existing = $vTable->where('venue_name', $venueName)->get()->getRowArray();
            if ($existing) { 
                $venueId = $existing['venue_id'];
            } else {
                $vTable->insert(['venue_name' => $venueName]);
                $venueId = $db->insertID();
            }
        }

        $data = [
            'activity_title'      => $this->request->getPost('activity-title'),
            'form_type'           => $this->request->getPost('form-type'),
            'start_date'          => $this->request->getPost('start-date'),
            'end_date'            => $this->request->getPost('end-date'),
            'start_time'          => $this->request->getPost('start-time'),
            'end_time'            => $this->request->getPost('end-time'),
            'venue_id'            => $venueId,
            'venue'               => $venueName,
            'proposed_budget'     => $this->request->getPost('proposed-budget'),
            'target_participants' => $this->request->getPost('target-participants'),
            'status'              => $this->request->getPost('status') ?? 'Pending', 
        ];

        $updateData = array_filter($data, function($value) {
            return $value !== null && $value !== '';
        });

        $file = $this->request->getFile('attachment');
        if ($file && $file->isValid() && !$file->hasMoved()) {

            $newName = $file->getRandomName();
            $file->move(FCPATH . 'uploads', $newName);
            $updateData['attachment'] = $newName;
        }

        try {
            $db->transStart();
            if ($model->update($id, $updateData)) {
                // Handle Budget Items update (Delete old, insert new)
                $budgetItems = json_decode($this->request->getPost("budgetary-requirements"), true);
                if (!empty($budgetItems)) {
                    $db->table('activity_budget_items')->where('act_design_id', $id)->delete();
                    
                    $budgetData = ['act_design_id' => $id];
                    $mapping = [
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
                        if (isset($mapping[$item['name']])) {
                            $budgetData[$mapping[$item['name']]] = $item['total'] ?: 0;
                        }
                    }
                    $db->table('activity_budget_items')->insert($budgetData);
                }
                
                $db->transComplete();
                return $this->response->setJSON([
                    'success' => true,
                    'message' => 'Activity Design updated and resubmitted successfully.'
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

    public function getVenues()
    {
        $db = \Config\Database::connect();
        $venues = $db->table('venues')->orderBy('venue_name', 'ASC')->get()->getResultArray();

        return $this->response->setJSON([
            'success' => true,
            'data'    => $venues
        ]);
    }

    /**
     * Approves an Activity Design:
     * 1. Updates the status to 'Approved'
     * 2. Moves the record to the archived_activity_designs table
     * 3. Assigns/Updates the control number
     * 4. Clears the record from the active activity_design table
     */
    public function approveDesign($id = null)
    {
        if (!$id) {
            return $this->response->setJSON(['success' => false, 'message' => 'Design ID required'])->setStatusCode(400);
        }

        $db = \Config\Database::connect();
        $db->transStart();

        // Fetch the active record
        $item = $db->table('activity_design')->where('act_design_id', $id)->get()->getRowArray();
        if (!$item) {
            return $this->response->setJSON(['success' => false, 'message' => 'Design not found'])->setStatusCode(404);
        }

        $controlNum = $this->request->getPost('control');
        $assessmentDate = $this->request->getPost('assessment-date');
        $deadline = $this->request->getPost('accomplishment-deadline');
        $remarks = $this->request->getPost('remarks');

        // 1. Insert into archived_activity_designs
        $archiveData = [
            'original_act_design_id' => $item['act_design_id'],
            'activity_title'         => $item['activity_title'],
            'start_date'             => $item['start_date'],
            'end_date'               => $item['end_date'],
            'start_time'             => $item['start_time'],
            'end_time'               => $item['end_time'],
            'status'                 => 'Approved',
            'remarks'                => $remarks,
            'assessment_date'        => $assessmentDate,
            'accomplishment_deadline' => $deadline,
            'attachment'             => $item['attachment'],
            'user_id'                => $item['user_id'],
            'venue'                  => $item['venue'],
            'venue_id'               => $item['venue_id'],
            'target_participants'    => $item['target_participants'],
            'proposed_budget'        => $item['proposed_budget'],
            'form_type'              => $item['form_type']
        ];
        $db->table('archived_activity_designs')->insert($archiveData);

        // 2. Link Control Number
        $db->table('control_number')->where('act_design_id', $id)->delete();
        $db->table('control_number')->insert([
            'control_number' => $controlNum,
            'act_design_id'  => $id,
            'user_id'        => $item['user_id']
        ]);

        // 3. Delete from active table
        $db->table('activity_design')->where('act_design_id', $id)->delete();

        $db->transComplete();
        return $this->response->setJSON(['success' => true, 'message' => 'Design approved and archived.']);
    }

    /**
     * Handles the revision request for an Activity Design.
     * Updates status, remarks, and ensures the control number is linked.
     */
    public function revisionDesign($id = null)
    {
        if (!$id) {
            return $this->response->setJSON(['success' => false, 'message' => 'Design ID required'])->setStatusCode(400);
        }

        $model = new ActivityDesignModel();
        $db = \Config\Database::connect();

        $remarks = $this->request->getPost('remarks');
        $controlNum = $this->request->getPost('control');
        $status = $this->request->getPost('status') ?? 'Revision';

        try {
            $db->transStart();

            // 1. Update the main activity design record using Query Builder to ensure remarks are saved
            $db->table('activity_design')->where('act_design_id', $id)->update([
                'status'  => $status,
                'remarks' => $remarks
            ]);

            // 2. Handle the Control Number (Required per request)
            if (!empty($controlNum)) {
                $controlTable = $db->table('control_number');
                $existingControl = $controlTable->where('act_design_id', $id)->get()->getRow();

                if ($existingControl) {
                    $controlTable->where('act_design_id', $id)->update(['control_number' => $controlNum]);
                } else {
                    $design = $model->find($id);
                    $controlTable->insert([
                        'control_number' => $controlNum,
                        'act_design_id'  => $id,
                        'user_id'        => $design['user_id']
                    ]);
                }
            }

            $db->transComplete();

            if ($db->transStatus() === false) {
                throw new \Exception("Database transaction failed.");
            }

            return $this->response->setJSON([
                'success' => true,
                'message' => 'The design has been returned to the submitter for revision.'
            ]);

        } catch (\Exception $e) {
            return $this->response->setJSON([
                'success' => false,
                'message' => 'Server Error: ' . $e->getMessage()
            ])->setStatusCode(500);
        }
    }
}