<?php

namespace App\Controllers;

use App\Libraries\FileStorage;

/**
 * FileController — serves files either locally or via Cloudflare R2 redirect.
 *
 * Routes:
 *   GET api/files/drafts/{filename}
 *   GET api/files/archived/{filename}
 */
class FileController extends BaseController
{
    public function serveDraft(string $filename)
    {
        if (FileStorage::isCloud()) {
            return $this->response->redirect(FileStorage::getCloudDraftUrl(basename($filename)));
        }
        return $this->serveFile(FileStorage::draftsPath(), $filename);
    }

    public function serveArchived(string $filename)
    {
        if (FileStorage::isCloud()) {
            return $this->response->redirect(FileStorage::getCloudArchivedUrl(basename($filename)));
        }
        return $this->serveFile(FileStorage::archivedPath(), $filename);
    }

    private function serveFile(string $directory, string $filename)
    {
        // Sanitize filename — no path traversal
        $filename = basename($filename);
        $filepath = $directory . DIRECTORY_SEPARATOR . $filename;

        if (!file_exists($filepath)) {
            return $this->response
                ->setStatusCode(404)
                ->setJSON(['success' => false, 'message' => 'File not found']);
        }

        $mime = mime_content_type($filepath) ?: 'application/octet-stream';

        return $this->response
            ->setHeader('Content-Type', $mime)
            ->setHeader('Content-Disposition', 'inline; filename="' . $filename . '"')
            ->setHeader('Cache-Control', 'private, max-age=3600')
            ->setBody(file_get_contents($filepath));
    }
}
