-- ============================================================
-- Migration: Add new columns to archive tables
-- Run this against your gad_submission_system database
-- ============================================================

-- archived_activity_designs: add assessment metadata
ALTER TABLE `archived_activity_designs`
  ADD COLUMN `assessment_date`         date         NULL AFTER `form_type`,
  ADD COLUMN `accomplishment_deadline` date         NULL AFTER `assessment_date`,
  ADD COLUMN `remarks`                 text         NULL AFTER `accomplishment_deadline`;

-- archived_accomplishment_reports: add reviewer remarks
ALTER TABLE `archived_accomplishment_reports`
  ADD COLUMN `assessment_date` date NULL AFTER `status`,
  ADD COLUMN `remarks`         text NULL AFTER `assessment_date`;

-- activity_design: add assessment_date for revision tracking
ALTER TABLE `activity_design`
  ADD COLUMN `assessment_date` date NULL AFTER `form_type`;

-- accomplishment_report: add assessment_date for revision tracking
ALTER TABLE `accomplishment_report`
  ADD COLUMN `assessment_date` date NULL AFTER `status`;
