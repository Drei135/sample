<?php

namespace App\Models;

use CodeIgniter\Model;

class AccomplishmentReportModel extends Model // No change needed here, class name is correct
{
	protected $DBGroup              = 'default';
	protected $table                = 'accomplishment_report';
	protected $primaryKey           = 'id';
	protected $useAutoIncrement     = true;
	protected $insertID             = 0;
	protected $returnType           = 'array';
	protected $useSoftDelete        = false;
	protected $protectFields        = true;

    protected $allowedFields = [
        "activity_title",
        "control_number",
        "act_design_id",
        "start_date",
        "end_date",
        "start_time",
        "end_time",
        "venue",
        "attendees",
        "male",
        "female",
        "rating",
        "attachment",
        "user_id",
        "status"
    ];

	// Dates
	protected $useTimestamps        = false;
	protected $dateFormat           = 'datetime';
	protected $createdField         = 'created_at';
	protected $updatedField         = 'updated_at';
	protected $deletedField         = 'deleted_at';

	// Validation
	protected $validationRules      = [];
	protected $validationMessages   = [];
	protected $skipValidation       = false;
	protected $cleanValidationRules = true;

	// Callbacks
	protected $allowCallbacks       = true;
	protected $beforeInsert         = [];
	protected $afterInsert          = [];
	protected $beforeUpdate         = [];
	protected $afterUpdate          = [];
	protected $beforeFind           = [];
	protected $afterFind            = [];
	protected $beforeDelete         = [];
	protected $afterDelete          = [];
}