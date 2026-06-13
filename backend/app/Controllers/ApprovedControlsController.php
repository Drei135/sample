<?php

namespace App\Controllers;

use App\Models\ApprovedControlModel;
use CodeIgniter\API\ResponseTrait;
use CodeIgniter\Controller;

class ApprovedControlsController extends Controller
{
    use ResponseTrait;

    /**
     * Get approved control numbers and their associated activity design details for a specific user.
     *
     * @param int $userId The ID of the user.
     * @return \CodeIgniter\HTTP\ResponseInterface
     */
    public function index(int $userId)
    {
        $model = new ApprovedControlModel();
        $controls = $model->getApprovedControlsWithActivityDetails($userId);

        return $this->respond([
            'success' => true,
            'message' => 'Approved control numbers fetched successfully.',
            'data'    => $controls,
        ]);
    }
}