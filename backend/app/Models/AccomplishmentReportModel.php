<?php

namespace App\Models;

use CodeIgniter\Model;

class AccomplishmentReportModel extends Model
{
    protected $table      = 'accomplishment_report';
    protected $primaryKey = 'id';

    protected $allowedFields = [
        'control_number',
        'act_design_id',
        'activity_title',
        'start_date',
        'end_date',
        'start_time',
        'end_time',
        'venue',
        'attendees',
        'male',
        'female',
        'rating',
        'attachment',
        'user_id',
        'status',
        'remarks',
        'assessment_date'
    ];
}