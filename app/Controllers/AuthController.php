<?php

namespace App\Controllers;

use App\Models\UserModel;
use CodeIgniter\RESTful\ResourceController;

class AuthController extends ResourceController
{
    protected $format = 'json';

    public function login()
    {
        // Handle JSON or Form-data
        $data = $this->request->getJSON(true) ?: $this->request->getPost();

        $rules = [
            'identity' => 'required',
            'password' => 'required'
        ];

        if (!$this->validateData($data, $rules)) {
            return $this->fail($this->validator->getErrors());
        }

        $identity = trim($data['identity']);
        $password = $data['password'];

        log_message('error', "LOGIN ATTEMPT: Identity=[$identity]");

        $userModel = new UserModel();
        $user = $userModel->findByIdentity($identity);

        if (!$user) {
            return $this->failUnauthorized("User not found for identity: $identity");
        }

        if (!password_verify($password, $user['password'])) {
            // Debug: Check if it's a legacy MD5 or something (unlikely but let's check)
            if (md5($password) === $user['password']) {
                 return $this->failUnauthorized('Legacy MD5 password detected. Please reset your password.');
            }
            return $this->failUnauthorized("Password verification failed for user: " . $user['username']);
        }

        log_message('error', "LOGIN SUCCESS: User [" . $user['username'] . "] authenticated.");

        // In a real app, you'd generate a JWT here. 
        // For this demo, we'll just return user info.
        return $this->respond([
            'status' => 200,
            'message' => 'Login successful',
            'user' => [
                'id' => $user['id'],
                'username' => $user['username'],
                'role' => $user['role']
            ]
        ]);
    }

    public function register()
    {
        $data = $this->request->getJSON(true) ?: $this->request->getPost();

        $rules = [
            'fullname' => 'required',
            'department' => 'required',
            'email' => 'required|valid_email',
            'password' => 'required|min_length[6]',
            'confirm_password' => 'required|matches[password]'
        ];

        if (!$this->validateData($data, $rules)) {
            return $this->fail($this->validator->getErrors());
        }

        $email = $data['email'];
        $username = strtolower(str_replace(' ', '_', explode('@', $email)[0]));
        
        $userModel = new UserModel();
        
        // Check if user exists
        if ($userModel->findByIdentity($email)) {
            return $this->failResourceExists('A user with that email or username already exists');
        }

        // Map department input (could be ID or string)
        $db = \Config\Database::connect();
        $departmentInput = $data['department'];
        $officeId = null;

        if (is_numeric($departmentInput)) {
            $officeId = (int) $departmentInput;
        } else {
            $office = $db->table('office_units')->where('office_name', $departmentInput)->get()->getRowArray();
            if ($office) {
                $officeId = $office['office_id'];
            } else {
                $db->table('office_units')->insert(['office_name' => $departmentInput]);
                $officeId = $db->insertID();
            }
        }

        // Map user_role from frontend to actual database role
        $role = 'college'; // Default
        if (isset($data['user_role'])) {
            switch ($data['user_role']) {
                case 'Director': $role = 'admin'; break;
                case 'Staff': $role = 'gad_staff'; break;
                case 'TWG':
                case 'Non-TWG':
                default:
                    $role = 'college'; break;
            }
        }

        $userData = [
            'username' => $username,
            'email' => $email,
            'password' => password_hash($data['password'], PASSWORD_DEFAULT),
            'role' => $role,
            'full_name' => $data['fullname'],
            'student_id' => $data['university_id'] ?? null,
            'office_id' => $officeId
        ];

        if ($userModel->insert($userData)) {
            return $this->respondCreated(['message' => 'Account created successfully. Please log in.']);
        }

        return $this->fail('Unable to create account. Please try again later.');
    }

    public function logout()
    {
        return $this->respond(['message' => 'Logout successful']);
    }

    public function handleOptions()
    {
        return $this->respond(['status' => 200]);
    }

    public function getOffices() {
        $db = \Config\Database::connect();
        // The frontend expects unit_id and unit_name, but our DB has office_id and office_name
        $offices = $db->table('office_units')->get()->getResultArray();
        $mappedOffices = array_map(function($o) {
            return [
                'unit_id' => $o['office_id'],
                'unit_name' => $o['office_name']
            ];
        }, $offices);
        return $this->respond($mappedOffices);
    }

    public function addOffice() {
        $data = $this->request->getJSON(true);
        $db = \Config\Database::connect();
        $db->table('office_units')->insert(['office_name' => $data['unit_name']]);
        return $this->respondCreated(['new_id' => $db->insertID()]);
    }
}
