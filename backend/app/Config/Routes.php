<?php

use CodeIgniter\Router\RouteCollection;

/**
 * @var RouteCollection $routes
 */
$routes->get('/', 'Home::index');

$routes->group('api', function($routes) {

    // ----------------------------------------------------------------
    // AUTH ROUTES (existing)
    // ----------------------------------------------------------------
    $routes->post('login', 'AuthController::login');
    $routes->post('register', 'AuthController::register');
    $routes->get('logout', 'AuthController::logout');

    // CORS preflight routes (existing)
    $routes->options('login', 'AuthController::handleOptions');
    $routes->options('register', 'AuthController::handleOptions');
    $routes->options('logout', 'AuthController::handleOptions');
    $routes->get('office_units', 'AuthController::getOffices');
    $routes->post('add_office', 'AuthController::addOffice');
    $routes->options('office_units', 'AuthController::handleOptions');
    $routes->options('add_office', 'AuthController::handleOptions');

    // ----------------------------------------------------------------
    // CLOUDFLARE R2 STORAGE ROUTE (existing)
    // ----------------------------------------------------------------
    $routes->post('storage/ticket', 'StorageController::getUploadTicket');
    $routes->options('storage/ticket', 'AuthController::handleOptions');

    // ----------------------------------------------------------------
    // ACTIVITY DESIGN ROUTES (new)
    // ----------------------------------------------------------------
    $routes->options('submit-activity-design', 'ActivityDesignController::submitDesign');
    $routes->post('submit-activity-design', 'ActivityDesignController::submitDesign');

    $routes->options('activity-designs', 'ActivityDesignController::index');
    $routes->get('activity-designs', 'ActivityDesignController::index');

    $routes->options('activity-design/(:num)', 'ActivityDesignController::show/$1');
    $routes->get('activity-design/(:num)', 'ActivityDesignController::show/$1');

    // User-specific designs list
    $routes->options('activity-designs/(:num)', 'ActivityDesignController::getUserDesigns/$1');
    $routes->get('activity-designs/(:num)', 'ActivityDesignController::getUserDesigns/$1');

    // Update/revision
    $routes->options('update-design/(:num)', 'ActivityDesignController::updateDesign/$1');
    $routes->post('update-design/(:num)', 'ActivityDesignController::updateDesign/$1');

    // In app/Config/Routes.php
    $routes->get('get-venues', 'ActivityDesignController::getVenues');
    $routes->get('get-control-numbers/(:num)', 'ActivityDesignController::getControlNumbers/$1');

    // ----------------------------------------------------------------
    // ACCOMPLISHMENT REPORT ROUTES (new)
    // ----------------------------------------------------------------
    $routes->options('submit-activity-report', 'AccomplishmentReportController::submitReport');
    $routes->post('submit-activity-report', 'AccomplishmentReportController::submitReport');

    $routes->options('activity-reports', 'AccomplishmentReportController::index');
    $routes->get('activity-reports', 'AccomplishmentReportController::index');

    $routes->options('activity-report/(:num)', 'AccomplishmentReportController::show/$1');
    $routes->get('activity-report/(:num)', 'AccomplishmentReportController::show/$1');

    // User-specific reports list
    $routes->options('activity-reports/(:num)', 'AccomplishmentReportController::getUserReports/$1');
    $routes->get('activity-reports/(:num)', 'AccomplishmentReportController::getUserReports/$1');

    // Update/revision
    $routes->options('update-report/(:num)', 'AccomplishmentReportController::updateReport/$1');
    $routes->post('update-report/(:num)', 'AccomplishmentReportController::updateReport/$1');

    // ----------------------------------------------------------------
    // APPROVED CONTROL NUMBERS (new)
    // ----------------------------------------------------------------
    $routes->options('approved-controls/(:num)', 'AuthController::handleOptions');
    $routes->get('approved-controls/(:num)', 'ApprovedControlsController::index/$1');

    // ----------------------------------------------------------------
    // ARCHIVE ROUTES (new)
    // ----------------------------------------------------------------
    $routes->options('archives', 'ArchiveController::index');
    $routes->get('archives', 'ArchiveController::index');
    $routes->post('archive-design/(:num)', 'ArchiveController::archiveDesign/$1');
    $routes->post('archive-report/(:num)', 'ArchiveController::archiveReport/$1');

    // ----------------------------------------------------------------
    // ADMIN TRACKING ROUTES (new)
    // ----------------------------------------------------------------
    $routes->get('admin/twg-submissions', 'ActivityDesignController::getTWGSubmissions');

    // ----------------------------------------------------------------
    // APPROVAL ROUTES (auto-archives on approval)
    // ----------------------------------------------------------------
    $routes->options('approve-design/(:num)', 'AuthController::handleOptions');
    $routes->post('approve-design/(:num)', 'ActivityDesignController::approveDesign/$1');

    $routes->options('approve-report/(:num)', 'AuthController::handleOptions');
    $routes->post('approve-report/(:num)', 'AccomplishmentReportController::approveReport/$1');

    // ----------------------------------------------------------------
    // REVISION ROUTES
    // ----------------------------------------------------------------
    $routes->options('revision-design/(:num)', 'AuthController::handleOptions');
    $routes->post('revision-design/(:num)', 'ActivityDesignController::revisionDesign/$1');

    $routes->options('revision-report/(:num)', 'AuthController::handleOptions');
    $routes->post('revision-report/(:num)', 'AccomplishmentReportController::revisionReport/$1');

    // ----------------------------------------------------------------
    // FILE SERVING ROUTES (serve PDFs from writable/uploads)
    // ----------------------------------------------------------------
    $routes->get('files/drafts/(:segment)', 'FileController::serveDraft/$1');
    $routes->get('files/archived/(:segment)', 'FileController::serveArchived/$1');
});