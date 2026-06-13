<?php

namespace App\Libraries;

use Aws\S3\S3Client;

/**
 * FileStorage — centralizes all file storage logic.
 *
 * Supports both Local and Cloudflare R2 storage depending on the environment.
 * If running on 'development' it uses writable/uploads/.
 * If running on 'production' it uses Cloudflare R2 bucket.
 */
class FileStorage
{
    /**
     * Checks whether to use Cloud Storage based on the environment.
     */
    public static function isCloud(): bool
    {
        return env('CI_ENVIRONMENT') === 'production' || env('USE_CLOUD_STORAGE') === true || env('USE_CLOUD_STORAGE') === 'true';
    }

    private static function getClient(): S3Client
    {
        return new S3Client([
            'version'     => 'latest',
            'region'      => 'auto',
            'endpoint'    => env('R2_ENDPOINT'),
            'credentials' => [
                'key'    => env('R2_ACCESS_KEY'),
                'secret' => env('R2_SECRET_KEY'),
            ],
        ]);
    }

    private static function getBucket(): string
    {
        return env('R2_BUCKET') ?: 'gad-ams';
    }

    /** Absolute path to the drafts directory (Local) */
    public static function draftsPath(): string
    {
        $path = WRITEPATH . 'uploads' . DIRECTORY_SEPARATOR . 'drafts';
        if (!is_dir($path)) {
            mkdir($path, 0777, true);
        }
        return $path;
    }

    /** Absolute path to the archived directory (Local) */
    public static function archivedPath(): string
    {
        $path = WRITEPATH . 'uploads' . DIRECTORY_SEPARATOR . 'archived';
        if (!is_dir($path)) {
            mkdir($path, 0777, true);
        }
        return $path;
    }

    /**
     * Save an uploaded file to the drafts folder.
     */
    public static function saveToDrafts($file): string
    {
        if (!$file || !$file->isValid() || $file->hasMoved()) {
            return '';
        }
        
        $name = $file->getRandomName();

        if (self::isCloud()) {
            try {
                $s3 = self::getClient();
                $s3->putObject([
                    'Bucket'      => self::getBucket(),
                    'Key'         => 'drafts/' . $name,
                    'SourceFile'  => $file->getTempName(),
                    'ContentType' => $file->getMimeType()
                ]);
            } catch (\Exception $e) {
                log_message('error', 'R2 Upload Failed: ' . $e->getMessage());
                return '';
            }
        } else {
            // Local fallback
            $file->move(self::draftsPath(), $name);
        }
        
        return $name;
    }

    /**
     * Move a file from drafts → archived.
     */
    public static function moveToArchived(string $fileName): bool
    {
        if (empty($fileName)) return true;

        if (self::isCloud()) {
            $s3 = self::getClient();
            $bucket = self::getBucket();
            try {
                if ($s3->doesObjectExist($bucket, 'drafts/' . $fileName)) {
                    $s3->copyObject([
                        'Bucket'     => $bucket,
                        'Key'        => 'archived/' . $fileName,
                        'CopySource' => "{$bucket}/drafts/{$fileName}"
                    ]);
                    $s3->deleteObject([
                        'Bucket' => $bucket,
                        'Key'    => 'drafts/' . $fileName
                    ]);
                }
                return true;
            } catch (\Exception $e) {
                log_message('error', 'R2 Move Failed: ' . $e->getMessage());
                return true;
            }
        } else {
            // Local fallback
            $src = self::draftsPath() . DIRECTORY_SEPARATOR . $fileName;
            $dst = self::archivedPath() . DIRECTORY_SEPARATOR . $fileName;
            if (file_exists($src)) return rename($src, $dst);
            return true;
        }
    }

    /**
     * Delete a file from drafts.
     */
    public static function deleteFromDrafts(string $fileName): void
    {
        if (empty($fileName)) return;
        
        if (self::isCloud()) {
            try {
                self::getClient()->deleteObject([
                    'Bucket' => self::getBucket(),
                    'Key'    => 'drafts/' . $fileName
                ]);
            } catch (\Exception $e) {
                log_message('error', 'R2 Delete Failed: ' . $e->getMessage());
            }
        } else {
            // Local fallback
            $path = self::draftsPath() . DIRECTORY_SEPARATOR . $fileName;
            if (file_exists($path)) unlink($path);
        }
    }

    /**
     * Generate a Pre-signed URL for a draft file (Cloud only).
     */
    public static function getCloudDraftUrl(string $fileName): string
    {
        return self::getPresignedUrl('drafts/' . $fileName);
    }

    /**
     * Generate a Pre-signed URL for an archived file (Cloud only).
     */
    public static function getCloudArchivedUrl(string $fileName): string
    {
        return self::getPresignedUrl('archived/' . $fileName);
    }

    private static function getPresignedUrl(string $key): string
    {
        $s3 = self::getClient();
        $cmd = $s3->getCommand('GetObject', [
            'Bucket'                     => self::getBucket(),
            'Key'                        => $key,
            'ResponseContentDisposition' => 'inline'
        ]);
        
        $request = $s3->createPresignedRequest($cmd, '+60 minutes');
        return (string) $request->getUri();
    }
}
