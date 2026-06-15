<?php

namespace App\Models;

use CodeIgniter\Model;

class ApprovedControlModel extends Model
{
    protected $table = 'control_number'; // Primary table for this model
    protected $primaryKey = 'control_number_id';
    protected $allowedFields = ['control_number', 'act_design_id', 'user_id'];

    /**
     * Fetches approved control numbers along with their associated activity design details
     * for a given user.
     *
     * @param int $userId The ID of the user.
     * @return array An array of objects containing control number and activity design details.
     */
    public function getApprovedControlsWithActivityDetails(int $userId = null): array
    {
        $builder = $this->select('control_number.control_number, 
                                  control_number.act_design_id,
                                  archived_activity_designs.activity_title,
                                  archived_activity_designs.start_date,
                                  archived_activity_designs.end_date,
                                  archived_activity_designs.start_time,
                                  archived_activity_designs.end_time,
                                  COALESCE(venues.venue_name, archived_activity_designs.venue) as venue')
                        ->join('archived_activity_designs', 'archived_activity_designs.original_act_design_id = control_number.act_design_id', 'inner')
                        ->join('venues', 'venues.venue_id = archived_activity_designs.venue_id', 'left');

        if ($userId !== null) {
            $builder->where('control_number.user_id', $userId);
        }

        return $builder->findAll();
    }
}