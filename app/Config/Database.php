<?php

namespace Config;

use CodeIgniter\Database\Config;

/**
 * Database Configuration
 */
class Database extends Config
{
    public string $filesPath = APPPATH . 'Database' . DIRECTORY_SEPARATOR;
    public string $defaultGroup = 'default';

    // --------------------------------------------------------------------------
    // LOCAL XAMPP DEFAULTS (Offline Development)
    // --------------------------------------------------------------------------
    public array $default = [
        'DSN'      => '', 
        'hostname' => '127.0.0.1',
        'username' => 'root',
        'password' => '',
        'database' => 'gad_submission_system',
        'DBDriver' => 'MySQLi',
        'DBPrefix' => '',
        'pConnect' => false,
        'DBDebug'  => true,
        'charset'  => 'utf8mb4',
        'DBCollat' => 'utf8mb4_general_ci',
        'swapPre'  => '',
        'encrypt'  => false,    // LOCAL ENCRYPTION OFF
        'compress' => false,
        'strictOn' => false,
        'failover' => [],
        'port'     => 3306,    
    ];

    // --------------------------------------------------------------------------
    // TESTING DEFAULTS (For automated PHPUnit testing)
    // --------------------------------------------------------------------------
    public array $tests = [
        'DSN'         => '',
        'hostname'    => '127.0.0.1',
        'username'    => '',
        'password'    => '',
        'database'    => ':memory:',
        'DBDriver'    => 'SQLite3',
        'DBPrefix'    => 'db_',
        'pConnect'    => false,
        'DBDebug'     => true,
        'charset'     => 'utf8',
        'DBCollat'    => 'utf8_general_ci',
        'swapPre'     => '',
        'encrypt'     => false,
        'compress'    => false,
        'strictOn'    => false,
        'failover'    => [],
        'port'        => 3306,
        'foreignKeys' => true,
        'busyTimeout' => 1000,
    ];

    public function __construct()
    {
        parent::__construct();

        // --------------------------------------------------------------------------
        // CLOUD OVERRIDE LOGIC (Render Deployment)
        // --------------------------------------------------------------------------
        
        // 1. Check if we are in the cloud by looking for Render's DB_DSN variable
        $dsnString = getenv('DB_DSN') ?: '';

        // 2. If the string exists, we are on Render! Overwrite the local defaults.
        if (!empty($dsnString)) {
            $parsed = parse_url($dsnString);

            if ($parsed) {
                $this->default['hostname'] = $parsed['host'] ?? '';
                $this->default['username'] = $parsed['user'] ?? '';
                $this->default['password'] = $parsed['pass'] ?? '';
                
                // Remove the leading slash from the database name
                $this->default['database'] = ltrim($parsed['path'] ?? '', '/');
                
                // Set the cloud port
                $this->default['port']     = isset($parsed['port']) ? (int) $parsed['port'] : 26685;
                
                // TURN ENCRYPTION BACK ON FOR CLOUD DATABASE!
                $this->default['encrypt']  = ['ssl_verify' => false]; 
            }
        }

        // Apply test group if running test suites
        if (ENVIRONMENT === 'testing') {
            $this->defaultGroup = 'tests';
        }
    }
}