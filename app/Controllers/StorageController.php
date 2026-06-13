<?php

namespace App\Controllers;

use CodeIgniter\RESTful\ResourceController;
use Aws\S3\S3Client;

class StorageController extends ResourceController
{
    public function getUploadTicket()
    {
        // 1. Get the requested filename from the frontend
        $filename = $this->request->getVar('filename');
        if (!$filename) {
            return $this->fail('Filename is required');
        }

        // 2. Initialize the S3 Client using the Render environment variables
        $s3 = new S3Client([
            'version'     => 'latest',
            'region'      => 'auto', // Cloudflare always uses 'auto'
            'endpoint'    => getenv('R2_ENDPOINT'),
            'credentials' => [
                'key'    => getenv('R2_ACCESS_KEY'),
                'secret' => getenv('R2_SECRET_KEY'),
            ],
        ]);

        $bucket = getenv('R2_BUCKET');
        
        // 3. Clean the filename and create a unique path to prevent overwriting
        $cleanName = preg_replace('/[^a-zA-Z0-9_.-]/', '_', $filename);
        $objectKey = 'uploads/' . time() . '_' . $cleanName;

        // 4. Build the command for Cloudflare R2
        $cmd = $s3->getCommand('PutObject', [
            'Bucket' => $bucket,
            'Key'    => $objectKey
        ]);

        // 5. Generate a Pre-signed URL valid for 15 minutes
        $request = $s3->createPresignedRequest($cmd, '+15 minutes');

        // 6. Return the ticket and the storage path back to the frontend
        return $this->respond([
            'upload_url' => (string) $request->getUri(),
            'file_path'  => $objectKey
        ]);
    }
}