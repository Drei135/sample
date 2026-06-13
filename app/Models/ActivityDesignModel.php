<?php

namespace App\Models;

use CodeIgniter\Model;

class ActivityDesignModel extends Model // No change needed here, class name is correct
{
	protected $DBGroup              = 'default';
	protected $table                = 'activity_design'; 
	protected $primaryKey           = 'act_design_id';
	protected $useAutoIncrement     = true;
	protected $insertID             = 0;
	protected $returnType           = 'array';
	protected $useSoftDelete        = false;
	protected $protectFields        = true;

    protected $allowedFields = [
        "form_type",
        "activity_title",
        "start_date",
        "end_date",
        "start_time",
        "end_time",
        "venue",
        "target_participants",
        "proposed_budget",
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