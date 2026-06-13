<?php

namespace App\Models;

use CodeIgniter\Model;

class UserModel extends Model
{
    protected $table            = 'users';
    protected $primaryKey       = 'id';
    protected $useAutoIncrement = true;
    protected $returnType       = 'array';
    protected $useSoftDeletes   = false;
    protected $protectFields    = true;
    protected $allowedFields    = ['username', 'email', 'password', 'role', 'full_name', 'student_id', 'office_id', 'user_acronym'];

    // Dates
    protected $useTimestamps = false;

    /**
     * Find user by username or email
     */
    public function findByIdentity(string $identity)
    {
        return $this->where('username', $identity)
                    ->orWhere('email', $identity)
                    ->orWhere('user_acronym', $identity)
                    ->orWhere('student_id', $identity)
                    ->first();
    }
}
