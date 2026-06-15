-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 15, 2026 at 05:03 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.5.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `gad_submission_system`
--

-- --------------------------------------------------------

--
-- Table structure for table `accomplishment_budget_items`
--

CREATE TABLE `accomplishment_budget_items` (
  `item_id` int(11) NOT NULL,
  `accomplishment_report_id` int(11) NOT NULL,
  `meals_and_snacks` decimal(15,2) DEFAULT 0.00,
  `function_room_venue` decimal(15,2) DEFAULT 0.00,
  `accommodation` decimal(15,2) DEFAULT 0.00,
  `equipment_rental` decimal(15,2) DEFAULT 0.00,
  `professional_fee_honoria` decimal(15,2) DEFAULT 0.00,
  `tokens` decimal(15,2) DEFAULT 0.00,
  `materials_and_supplies` decimal(15,2) DEFAULT 0.00,
  `transportation` decimal(15,2) DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `accomplishment_evaluation_results`
--

CREATE TABLE `accomplishment_evaluation_results` (
  `evaluation_id` int(11) NOT NULL,
  `accomplishment_report_id` int(11) NOT NULL,
  `time_management` decimal(4,2) DEFAULT 0.00,
  `orderliness_and_program_flow` decimal(4,2) DEFAULT 0.00,
  `appropriateness_of_venue` decimal(4,2) DEFAULT 0.00,
  `sound_system_and_hall_preparation` decimal(4,2) DEFAULT 0.00,
  `restrooms` decimal(4,2) DEFAULT 0.00,
  `food_and_drinks` decimal(4,2) DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `accomplishment_report`
--

CREATE TABLE `accomplishment_report` (
  `id` int(11) NOT NULL,
  `control_number` varchar(50) NOT NULL,
  `act_design_id` int(11) DEFAULT NULL,
  `activity_title` text NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `venue` varchar(255) NOT NULL,
  `attendees` int(11) NOT NULL,
  `male` int(11) NOT NULL,
  `female` int(11) NOT NULL,
  `rating` int(11) NOT NULL,
  `attachment` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `status` varchar(20) DEFAULT 'Pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `remarks` text DEFAULT NULL,
  `assessment_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `activity_budget_items`
--

CREATE TABLE `activity_budget_items` (
  `item_id` int(11) NOT NULL,
  `act_design_id` int(11) NOT NULL,
  `meals_and_snacks` decimal(15,2) DEFAULT 0.00,
  `function_room_venue` decimal(15,2) DEFAULT 0.00,
  `accommodation` decimal(15,2) DEFAULT 0.00,
  `equipment_rental` decimal(15,2) DEFAULT 0.00,
  `professional_fee_honoria` decimal(15,2) DEFAULT 0.00,
  `tokens` decimal(15,2) DEFAULT 0.00,
  `materials_and_supplies` decimal(15,2) DEFAULT 0.00,
  `transportation` decimal(15,2) DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `activity_budget_items`
--

INSERT INTO `activity_budget_items` (`item_id`, `act_design_id`, `meals_and_snacks`, `function_room_venue`, `accommodation`, `equipment_rental`, `professional_fee_honoria`, `tokens`, `materials_and_supplies`, `transportation`) VALUES
(3, 3, 2.00, 51.00, 94.00, 10.00, 2.00, 1.00, 75.00, 25.00);

-- --------------------------------------------------------

--
-- Table structure for table `activity_design`
--

CREATE TABLE `activity_design` (
  `act_design_id` int(11) NOT NULL,
  `activity_title` varchar(255) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `attachment` varchar(500) DEFAULT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `gpb_id` int(11) DEFAULT NULL,
  `venue` varchar(255) DEFAULT NULL,
  `venue_id` int(11) DEFAULT NULL,
  `target_participants` int(11) DEFAULT NULL,
  `proposed_budget` int(8) DEFAULT NULL,
  `form_type` varchar(255) NOT NULL,
  `remarks` text DEFAULT NULL,
  `assessment_date` date DEFAULT NULL,
  `accomplishment_deadline` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `activity_design`
--

INSERT INTO `activity_design` (`act_design_id`, `activity_title`, `start_date`, `end_date`, `start_time`, `end_time`, `status`, `attachment`, `user_id`, `gpb_id`, `venue`, `venue_id`, `target_participants`, `proposed_budget`, `form_type`, `remarks`, `assessment_date`, `accomplishment_deadline`) VALUES
(3, 'In aliquam ut est fa', '2026-06-24', '2026-06-24', '01:00:00', '02:03:00', 'Pending', '1781495038_6f67cd7beec61388b262.pdf', 7, NULL, 'Dimas Hall, IHFSA', NULL, 2, 260, 'extension', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `archived_accomplishment_reports`
--

CREATE TABLE `archived_accomplishment_reports` (
  `archive_id` int(11) NOT NULL,
  `original_report_id` int(11) NOT NULL,
  `control_number` varchar(50) NOT NULL,
  `act_design_id` int(11) DEFAULT NULL,
  `activity_title` text NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `venue` varchar(255) NOT NULL,
  `attendees` int(11) NOT NULL,
  `male` int(11) NOT NULL,
  `female` int(11) NOT NULL,
  `rating` int(11) NOT NULL,
  `attachment` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `status` varchar(20) DEFAULT 'Completed',
  `remarks` text DEFAULT NULL,
  `assessment_date` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `archived_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `archived_accomplishment_reports`
--

INSERT INTO `archived_accomplishment_reports` (`archive_id`, `original_report_id`, `control_number`, `act_design_id`, `activity_title`, `start_date`, `end_date`, `start_time`, `end_time`, `venue`, `attendees`, `male`, `female`, `rating`, `attachment`, `user_id`, `status`, `remarks`, `assessment_date`, `created_at`, `archived_at`) VALUES
(1, 1, '2026-0602', NULL, 'Dolorem aut similiqu', '2026-06-17', '2026-06-18', '05:03:00', '14:43:00', 'RSDC Executive Hall', 16, 13, 3, 2, '[\"1781494875_70a94f7bfcfbf7a78399.pdf\",\"1781494875_76c8a2ca01af27815c59.pdf\",\"1781494875_75971509360d1eefe96b.pdf\"]', 47, 'Completed', '', '2026-06-15', '2026-06-15 03:42:15', '2026-06-15 03:42:15'),
(2, 2, '2026-0601', NULL, 'Principal Web Strategist', '2026-06-16', '2026-06-16', '16:29:00', '10:09:00', 'CTE DSG Hall', 147, 76, 71, 4, '[\"1781494976_43dcb1b2b754a41a3f70.pdf\",\"1781494976_b9fda38d06b540f39cbe.pdf\"]', 7, 'Completed', '', '2026-06-15', '2026-06-15 03:43:15', '2026-06-15 03:43:15');

-- --------------------------------------------------------

--
-- Table structure for table `archived_activity_designs`
--

CREATE TABLE `archived_activity_designs` (
  `archive_id` int(11) NOT NULL,
  `original_act_design_id` int(11) NOT NULL,
  `activity_title` varchar(255) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `status` varchar(50) DEFAULT 'Approved',
  `attachment` varchar(500) DEFAULT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `gpb_id` int(11) DEFAULT NULL,
  `venue` varchar(255) DEFAULT NULL,
  `venue_id` int(11) DEFAULT NULL,
  `target_participants` int(11) DEFAULT NULL,
  `proposed_budget` int(8) DEFAULT NULL,
  `form_type` varchar(255) NOT NULL,
  `assessment_date` date DEFAULT NULL,
  `accomplishment_deadline` date DEFAULT NULL,
  `remarks` text DEFAULT NULL,
  `archived_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `archived_activity_designs`
--

INSERT INTO `archived_activity_designs` (`archive_id`, `original_act_design_id`, `activity_title`, `start_date`, `end_date`, `start_time`, `end_time`, `status`, `attachment`, `user_id`, `gpb_id`, `venue`, `venue_id`, `target_participants`, `proposed_budget`, `form_type`, `assessment_date`, `accomplishment_deadline`, `remarks`, `archived_at`) VALUES
(1, 1, 'Principal Web Strategist', '2026-06-16', '2026-06-16', '16:29:00', '10:09:00', 'Approved', '1781447618_e9140e32fae93cec9d25.pdf', 7, NULL, 'CTE DSG Hall', NULL, 406, 2421, 'employee', '2026-06-14', '2026-06-30', '', '2026-06-14 14:34:11'),
(2, 2, 'Dolorem aut similiqu', '2026-06-17', '2026-06-18', '05:03:00', '14:43:00', 'Approved', '1781493306_04237de9b5dd9b67176e.pdf', 47, NULL, 'RSDC Executive Hall', NULL, 47, 386, 'inset', '2026-06-15', '2026-06-24', '', '2026-06-15 03:39:39');

-- --------------------------------------------------------

--
-- Table structure for table `control_number`
--

CREATE TABLE `control_number` (
  `control_number_id` int(11) NOT NULL,
  `control_number` varchar(50) DEFAULT NULL,
  `act_design_id` int(11) DEFAULT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `control_number`
--

INSERT INTO `control_number` (`control_number_id`, `control_number`, `act_design_id`, `user_id`) VALUES
(1, '2026-0601', 1, 7),
(2, '2026-0602', 2, 47);

-- --------------------------------------------------------

--
-- Table structure for table `gad_plan_budget`
--

CREATE TABLE `gad_plan_budget` (
  `gpb_id` int(11) NOT NULL,
  `gender_issue_mandate` varchar(255) DEFAULT NULL,
  `cause_of_gender_issue` text DEFAULT NULL,
  `gad_result_objective` text DEFAULT NULL,
  `relevant_org_mfo_pap` text DEFAULT NULL,
  `gad_activity` varchar(255) DEFAULT NULL,
  `performance_indicators_targets` text DEFAULT NULL,
  `gad_budget` decimal(15,2) DEFAULT NULL,
  `budget_breakdown` text DEFAULT NULL,
  `source_of_budget` varchar(100) DEFAULT NULL,
  `responsible_unit_office` varchar(100) NOT NULL,
  `form_type` enum('client-focused activity','organization-focused activity','attributed program') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `gad_plan_budget`
--

INSERT INTO `gad_plan_budget` (`gpb_id`, `gender_issue_mandate`, `cause_of_gender_issue`, `gad_result_objective`, `relevant_org_mfo_pap`, `gad_activity`, `performance_indicators_targets`, `gad_budget`, `budget_breakdown`, `source_of_budget`, `responsible_unit_office`, `form_type`) VALUES
(1, 'Republic Act No. 10931, Universal Access to Quality Tertiary Education Act Section 8 on Affirmative Action Program; CHED Memorandum Orders on GAD Mainstreaming in Higher Education Institutions (HEIs)', 'Extraordinary life situations due to disasters, calamities, and socio-cultural discrimination', 'To promote equitable access and participation of both women and men from GIDAs in tertiary education through gender-responsive implementation of the Affirmative Action Agenda.', 'MFO: Higher Education Program', 'Implementation of Affirmative Action Agenda', 'Number of served disadvantaged students - 100% disadvantaged students', 700000.00, 'PS Attribution 500,000.00 Supplies and Materials 200,000.00', 'GAA GAA', 'OSS', 'client-focused activity'),
(2, 'Republic Act No. 10931, Universal Access to Quality Tertiary Education Act Section 8 on Affirmative Action Program; CHED Memorandum Orders on GAD Mainstreaming in Higher Education Institutions (HEIs)', 'High tuition and miscellaneous fees, compounded by socio-cultural expectations for women to prioritize domestic roles over education', 'To promote gender equality in access to tertiary education by eliminating financial barriers for both male and female students.', 'MFO: Higher Education Program', 'Provision of free tuition fee under RA 10931 to eligible male and female students of the university', 'Percentage of qualified students granted free tuition - 100% of qualified students granted free tuition.', 131100000.00, 'Tuition Fee 131,100,000.00', 'GAA', 'OSS, OUR, UHS', 'client-focused activity'),
(3, 'CHED Memorandum Order No. 01 series 2015', 'Limited activities to increase awareness of men and women students to GAD-related information (1st year students, transferees)', 'To increase the students level of awareness and appreciation on GAD', 'MFO: Higher Education Program', 'Conduct GAD orientation/ forum/ seminar to BSU 1st year/ transferees students (face to face/ online: 14 colleges)', 'No. of students oriented on GAD - 4,000 students oriented on GAD (F:2750 M:1250)', 453363.26, 'Meals and Snack 318,800.00 Supplies and Materials 10,000.00 PS Attribution 124,563.26', 'GAA GAA GAA', 'OSS, GAD Office, 3 Campuses (La Trinidad, Bokod & Buguias Campus)', 'client-focused activity'),
(4, 'CHED Memorandum Order No. 01 series 2015', 'Student leaders have limited understanding on GAD in the University', 'To empower student leaders regarding GAD responsive leadership (La Trinidad Campus, Bokod Campus and Buguias Campus)', 'MFO: Higher Education Program', 'Continuous conduct of GAD responsive leadership training for student', 'No. of training conducted to increase GAD awareness and responsiveness of students leaders - 2 training (Female:200 Male:100) (La Trinidad Campus, Bokod Campus and Buguias Campus)', 150000.00, 'Supplies and Materials 30,000.00 Snack 20,000.00 PS Attribution 100,000.00', 'GAA GAA GAA', 'OSS', 'client-focused activity'),
(5, 'Part VII of CHED Memorandum Order Number 1, series 2015 on Gender-Responsive Research and Extension Program', 'Presence of gender inequality, poverty and GAD-related concerns in the community', 'To sustain GAD-related extension activities delivering technology transfer, Livelihood Program, Technical Assistance, and Advocacy to community partners to help promote gender equality, poverty reduction and sustainable developmen', 'MFO: Extension Services- Research Services- Advance Education ServicesHigher Education Services', 'Conduct of Extension project/ activities to partner organizational/ communities as component of Gender Responsive Extension Program (GREP) to partner organization/ communities', 'No. of extension activities conducted within the year - 24 Extension program/project/ activities conducted within the year (Female:560 Male: 500)', 3500000.00, 'Seminar Package/Meals & Snacks/ Fuel for Transportation/ Vehicle Rental/ Other Professional Services 2,500,000.00 PS Attribution 1,000,000.00', 'GAA GAA', 'Research and Extension, various offices/ colleges in the University/ external campuses', 'client-focused activity'),
(6, 'Limited access of PWDs to gender-responsive programs and services/DBM-DSWD Joint Circular No. 2003-01 provides guidelines for the implementation of Section 29 of the General Appropriations Act (GAA), requiring government agencies to set aside at least 1% ', 'Limited access of PWDs to gender-responsive programs and services', 'Improved access of PWDs to gender-responsive, inclusive, and empowering programs and services.', 'MFO: Research Services- Extension Services-Advance Education ServicesHigher Education Services', 'Awareness of women PWDs who benefited from the program', 'Number of women PWDs who benefited from the program - FM No. of GAD program/project/ activityprovided for PWD - At least 1 program/project/ activity', 350000.00, 'PS Attribution 100,000.00 Supplies & Materials/ Meals & Snacks 250,000.00', 'GAA GAA', 'HRMO, OSS', 'client-focused activity'),
(7, 'Lack of senior citizens access to gender-responsive programs and services/DBM-DSWD Joint Circular No. 2003-01 provides guidelines for the implementation of Section 29 of the General Appropriations Act (GAA), requiring government agencies to set aside at l', 'Absence of sustainable and gender-responsive university programs for senior citizens', 'Improved access of senior citizensto gender-responsive, inclusive, and empowering programs and services', 'MFO: Research Services- Extension Services- Advance Education ServicesHigher Education Services', 'Program: BSU Kalinga for women Senior Citizens', 'Number of Programs provided for Senior Citizens - At least 1 program for BSU Number of women senior citizens who benefited from the program - F21 M23', 250000.00, 'Supplies & Materials/ Meals & Snacks 250,000.00', 'GAA', 'GAD Office, Colleges, External Campuses', 'client-focused activity'),
(8, 'Low number of women\'s participation in sports/MCW-IRR Section 14 Develop, establish and strengthen programs for the participation of women in competitive and non-competitive sports as means to achieve excellence, promote physical and social well-being', 'Minimal attendance of female students to competitive and non-competitive sports', 'To increase female students level of participation and awareness on Gender in Sports', 'MFO: Higher Education Program', 'Participate in sports activities targeted for female students', 'No. of sports activities supported through allocation of budget for sports and socio- cultural activities/ E-sports (i.e. Annual Women\'s Martial Arts Festival- 2 sports activities (Female:20)', 160000.00, 'Registration & Travelling Expenses 80,000.00 Meals and Snacks 60,000.00 PS Attribution 20,000.00', 'GAA GAA GAA', 'CHK', 'client-focused activity'),
(9, 'Programs on Awards and Incentives for Service Excellence (PRAISE under CSC Res.No.010112 and CSC MC No.1,s. 2001); Memo Circular No.2011-01 (Guidelines for the Creation, Strengthening and Institutionalization of GAD Focal Point System: Roles and Responsib', 'Low recognition/ appreciation on the Gender Mainstreaming in BSU', 'Strengthen Gender Mainstreaming through recognition of GAD implementation in the University', 'MFO: Research Services-Extension Services- Advance Education ServicesHigher Education Services', 'Provide recognition and award to GAD implementer and other GAD-related award (GAD implementer for students and employees, GAD Advocate Award)', 'No. of award will be provided through BSU-PRAISE- At least 1 GAD Advocate award will be provided through BSU-PRAISE', 205000.00, 'Incentive GAD Advocate Award 5,000.00 PS Attribution 200,000.00', 'GAA GAA', 'HRDO, HRMO, BSU-PRAISE Committee, GAD Office', 'organization-focused activity'),
(10, 'Limited application of GAD Mainstreaming (GM) in Instruction, Research, Extension and Production/Magna Carta of Women (RA 9710)', 'Low awareness among personnel in the University about GAD mainstreaming', 'To enhance GAD mainstreaming in Administration, Academic, Research and Extension, Production', 'MFO: Research Services- Extension Services- Advance Education ServicesHigher Education Services', 'Conduct GAD related Gender Mainstreaming capability building and competency acquisition', 'No. of training/workshop/ seminars conducted - 25 training/ workshop/ seminars/ Learning and Development (F:1500 M: 1000)', 4000000.00, 'Seminar Package/Meals & Snacks/ Fuel for Transportation/ Vehicle Rental/ Professional Services (La Trinidad Bokod and Buguias Campus) 3,500,000.00 PS Attribution 500,000.00', 'GAA GAA', 'GAD Office, HRDO, Research and Extension, OQAA, All Colleges with External Campuses', 'organization-focused activity'),
(11, 'Magna Carta of Women IRR Section 37 Gender Mainstreaming as a Strategy for Implementing the Magna Carta of Women', 'Productivity of employees affected due to filial obligations, affecting promotion of women to higher positions or from participating in capability enhancement sessions', 'Inadequate support services to personnel and students with children', 'MFO: Research ServicesExtension Services Advance Education ServicesHigher Education Services', 'Operationalize of BSU College of Nursing Reproductive Health Care Center', 'No. of maintained Reproductive Health Care Center- 1 maintained BSU CN Reproductive Health Care Center', 120000.00, 'Supplies and Materials 20,000.00 PS Attribution 100,000.00', 'GAA GAA', 'College of Nursing', 'organization-focused activity'),
(12, 'Executive Order No. 340 s. 1997 Directing National Government Agencies and Government-Owned and-Controlled Corporations to provide Day Care Services for their Employee\'s Children under five years of age', 'Problems of parents and students related to child care', 'Ensure opportunities of personnel and students to have access on agency care services to children to avoid absenteeism', 'MFO: Research ServicesExtension Services Advance Education ServicesHigher Education Services', 'Maintenance of Child Minding Center for working parents in ensuring that they have a safe place to leave their child while they are at their work places', 'No. of established child minding center- Fully maintained new established and existing child minding centers at BSU La Trinidad,Bokod Campus and Buguias Campus', 230000.00, 'Supplies and Materials 130,000.00 PS Attribution 100,000.00', 'GAA GAA', 'GAD Office, External Campuses', 'organization-focused activity'),
(13, 'Magna Carta of Women (RA 9710)', 'Low integration of gender mainstreaming of BSU', 'To strengthen the GAD integration in the operations of BSU', 'MFO: Research ServicesExtension Services Advance Education ServicesHigher Education Services', 'Create a Monitoring Team to conduct monitoring and evaluation of the utilization/ outcome of GAD PAPs and ensure effectiveness of the GAD PAPs', 'No. of monitoring and assessment meetings with reports conducted4 monitoring and assessment meetings with reports conducted', 330000.00, 'Supplies and Materials 10,000.00 PS Attribution 320,000.00', 'GAA GAA', 'GAD Office', 'organization-focused activity'),
(14, 'Magna Carta of Women IRR Section 37 C. Creation and/or Strengthening of the GAD Focal Points (GFPs)', 'Low level of capacity of GFPS to develop and implement GAD programs and activities due to new members', 'Capacitated GFPS members in order to implement GAD PAP\'s and advance GAD Mainstreaming (GM) in the University', 'MFO: Research ServicesExtension Services Advance Education ServicesHigher Education Services', 'for GFPS/Secretariat: GMEF/HGDG/GPB/GAD Agenda/GAD Deepening Session and TOT among other related trainings and capacity building activities (Regional/ National GAD-related trainings/ seminars/ forum/workshop)', 'No. training/ seminars/ workshop attendance for each GFPS-members on GAD related updates and mandates- At least 1 Training/ seminar/ workshop attendance for each GFPS-members on GAD related updates and mandates (Female: 31, Male: 15)', 896000.00, 'GFPS TWG PAPs 396,000.00 PS Attribution 500,000.00', 'GAA GAA', 'GAD Office', 'organization-focused activity'),
(15, 'Section 37-C2 Rule VI of the Magna Carta of Women\'s IRR on duties and function of the GAD Focal Point System/Magna Carta of Women (RA 9710)', 'Compliance to provisions regarding regular monitoring of gender mainstreaming efforts', 'To ensure operations of GAD Office as well as monitor and evaluate GM efforts of the University', 'MFO: Research ServicesExtension Services Advance Education ServicesHigher Education Services', 'Regular coordination and meetings of GAD-GFPS (Execom, GFPS- TWG members and external campus TWG members) and emergency meeting when necessary', 'No. of reports on regular meetings per campus conducted will be available at the end of the year - At least 6 reports on regular meetings conducted will be available at the end of the year, RGADC quarterly meeting/s', 211720.00, 'Meals & Snack 111,720.00 PS Attribution 100,000.00', 'GAA GAA', 'GAD Office', 'organization-focused activity'),
(16, 'Duties and function of the GAD Focal Point System/CHED Memo 2015-1', 'No plantilla personnel assigned to plan, implement and monitor GAD PAPs on a full-time basis', 'To ensure operations of GAD Office as well as monitor and evaluate GM efforts of the University', 'MFO: Research ServicesExtension Services Advance Education ServicesHigher Education Services', 'Engage support staff to assist in the implementation of GFPS PPA\'s and Gender Mainstreaming in the university through rehiring of GAD staff and Student Assistant', 'Salary of GAD Staff: Casual No. of rehired personnel (casual) and student assistant -At least two (2) staff renewed/rehired (Casual) and at least one (3) Student Assistant/ SPES per semester', 550000.00, 'Salary of GAD Staff and SPES/ Student Assistant 550,000.00', 'GAA', 'GAD Office', 'organization-focused activity'),
(17, 'Low level of Awareness on Gender Mainstreaming (GM) in Instruction, Research, Extension and\nProduction among newly hired personnel/Magna of Women (RA 9710), CHED Memo 2015-1', 'Lack of regular orientation and refresher training on gender sensitivity and GAD mandates', 'To enhance awareness and understanding of gender concepts, GAD mandates, and gender-responsive work practices among newly hired and current personnel', 'MFO: Conduct Gender Sensitivity Training (GST) for newly hired and current personnel (continuing activity)', 'Conduct Gender Sensitivity Training (GST) for newly hired and current personnel (continuing activity)', 'No. of training conducted for newly hired personnel and refresher trainings for current personnel - 1 training conducted for at least 100% of newly hired personnel and 3 refresher trainings for current personnel', 421728.32, 'Meals & Snack 167,200.00 Token 4,000.00 Professional Fee 144,528.32 Supplies and Materials 6,000.00 PS Attribution 100,000.00', 'GAA GAA GAA GAA GAA', 'GAD Office', 'organization-focused activity'),
(18, 'Part V, Rule II, Section 4 of CHED Memorandum Order No. 1 Series of 2015/CHED Memo 2015-1', 'Limited number of GAD library and related learning materials across various discipline', 'To increase the provision of adequate and accessible library and related learning materials across various disciplines and educational levels', 'MFO: Research ServicesExtension Services Advance Education ServicesHigher Education Services', 'Provision of knowledge products (books magazine, multi-media) for adequate and accessible library and related learning materials in support to gender-responsive Curriculum Programs', 'No. of procured library and learning materials- 200 books', 2600000.00, 'Books and Instructional Materials 2,500,000.00 PS Attribution 100,000.00', 'GAA GAA', 'ULIS', 'organization-focused activity'),
(19, 'Development and Dissemination of Gender and Development (GAD) Information, Education, and Communication (IEC) Materials', 'Presence of Gender Based Violence (GBV) issues/reports/cases in the university', 'Institutionalize GAD mechanisms in the University and sustain awareness campaigns on sexual harassment and gender-based violence', 'MFO: Research ServicesExtension Services Advance Education ServicesHigher Education Services', 'Development and Dissemination of Gender and Development (GAD) Information, Education, and Communication (IEC) Materials', 'No. of Communication and IEC materials/knowledge products - Official Publication of BSU with GAD articles, pictures as a medium for employees, clients, students partners to disseminate programs, achievement and advocacies, Maintained GAD Bulletin board - At least 8 GAD Bulletin board ,Sector-specific knowledge products on GAD generated and designed to be downloadable via BSU website - At least 2', 296000.00, 'Shamag 96,000.00 PS Attribution 100,000.00 Supplies and Materials 100,000.00', 'GAA GAA GAA', 'UPAO, GAD Office', 'organization-focused activity'),
(20, 'Institutionalizing GAD database and Sex-Disaggregated Database/Magna Carta of Women (RA 9710), Section 36 on Sex-Disaggregated Database', 'Minimal awareness and appreciation on the relevance of the centralized Sex-Disaggregated database', 'To establish a centralized GAD-related database of the University', 'MFO: Research ServicesExtension Services Advance Education ServicesHigher Education Services', 'Updating of Sex-Disaggregated Data (SDD) and other data related to personnel/students/clients GAD-related database for gender analysis and report preparation', 'No. of well-organized and maintained GAD database for easy reference and access 1 GAD databaseEstablishment of GAD-Database system per college/unit.', 1100000.00, 'PS Attribution 100,000.00 Maintenance of SDD/ Internet connection 1,000,000.00', 'GAA GAA', 'ICT, GAD Office', 'organization-focused activity'),
(21, 'Magna Carta for women, Chapter IV: Section 10 and RA 10121, Section 2 & 9', 'Limited resources of the DSWD and LGU to provide for students who are transient residents and limited appreciation on women\'s role in nation building among employees and students, especially new ones', 'To ensure that disaster assistance provided to distressed students are gender-responsive', 'MFO: MFO: Research ServicesMFO: Extension Services MFO: Advance Education ServicesMFO: Higher Education Services', 'Provision of gender-responsive services to employees and students who experienced crisis/ disaster (e.g. Distribution of hygiene kits for both women and men)', 'No. of pax of the most affected employees/ students during crises - 1,000 employees/students', 211200.00, 'Crisis pack: Php,200/ pack X 1,000.00 pax 200,000.00 PS TWG Members 10,000.00', 'GAA GAA', 'GAD Office, HDRO, NSTP, various offices/ all colleges in the University', 'organization-focused activity'),
(22, 'Compliance to Section 18 of MCW RA 9710:Special Leave Benefits for Women RA 8187: Paternity Leave Section 8 of RA 8972:Solo Parents Welfare Act of 2000 Section 43 of RA 9262: Anti-Violence Against Women and Their Children Act of 2004)', 'Employees may require special leaves due to parental obligations, health concerns and other circumstances that may require the need thereof', 'Enhanced support services for employees in need of special leaves', 'MFO: MFO: Research ServicesMFO: Extension Services MFO: Advance Education ServicesMFO: Higher Education Services', 'Provision of gender leaves and conduct of Seminar on Gender Related Leaves for Newly Hired Employees', 'No. of Maternity, Paternity, Solo parent, gynecological, VAWC leave of employees who will avail and 1 Seminar conducted (M:20 F:50)- All (100%) Maternity, Paternity, Solo parent, gynecological, VAWC leave of employees who will avail and 1 Seminar conducted (M:20 F:50)', 1000000.00, 'PS Attribution 1,000,000.00', 'GAA', 'HRMO, CBOO, various offices/ colleges in the University', 'organization-focused activity'),
(23, 'Compliance to Proclamation 227 on the observance of Women\'s Role in History Month and Proclamation 1172, s. 2006 on the 18-Day Campaign to End Violence Against Women (VAW)', 'The need to highlight women\'s rights, their role in national development/ nation building and need to provide platform to invoke protection of women\'s rights against VAW, gender-based violence, Safe Spaces Act (RA No. 11313) and concerns that affect women and men', 'To strengthen awareness of BSU students/ employees on women\'s rights and their role in national development and nation building', 'MFO: Research ServicesExtension Services Advance Education ServicesHigher Education Services', 'Participation to18-Day Campaign to end VAW and Women\'s Month Celebration/ activities and programs organized by PCW and other agency/ies', 'No. of activities conducted per campus - At least one (1) activity conducted per campus', 450001.00, 'At least one (1) activity conducted per campus 250,000.00 PS Attribution 200,000.00', 'GAA GAA', 'GAD Office, various offices/ colleges in the University/ external campus', 'organization-focused activity'),
(24, 'Productivity of employees affected due to filial obligations, affecting promotion of women to higher positions or from participating in capability enhancement sessions/Magna Carta of Women IRR Section 37 Gender Mainstreaming as a Strategy for Implementing', 'Inadequate support services for personnel/students with young children and breastfeeding mothers (affecting productivity, especially among women non implementation of RA 10028)', 'Inadequate support services to personnel and students with children', 'MFO: Research ServicesExtension Services Advance Education ServicesHigher Education Services', 'Establishment/ maintenance of breastfeeding station established in the preceding years', 'Fully maintained Lactation rooms - 100% fully maintained lactation rooms at BSU La Trinidad, Bokod and BuguiasCampus', 220000.00, 'Supplies and Materials 50,000.00 PS Attribution 170,000.00', 'GAA GAA', 'GAD Office, External Campuses', 'organization-focused activity'),
(25, 'Low level of employees understanding of gender issues/ concept to promote gender equality and a gender-responsive work environment./RA 9710 (Magna Carta of Women), PCWNEDADBM Joint Circular 2012-01, and CSC MC No. 12 s. 2005, the University shall conduct ', 'Lack of regular gender-related capacity-building activities and insufficient integration of gender sensitivity in employee development programs', 'To enhance the gender awareness and sensitivity of BSU employees, enabling them to recognize and eliminate gender bias and stereotyping, and to foster a gender-responsive and equitable workplace', 'MFO: Research ServicesExtension Services Advance Education ServicesHigher Education Services', 'Conduct of gender sensitivity orientations for BSU Personnel (continuing activity)', 'No. of training conducted for BSU personnel -At least 3 training to be conducted', 253796.24, 'Supplies and Materials 10,000.00 Meals & Snack/ Professional Fee 233,796.24 PS 10,000.00', 'GAA GAA GAA', 'GAD Office', 'organization-focused activity'),
(26, 'Establishment of Gender-Responsive Curricular Programs/Part V of CMO 01, s. 2015/ CHED Memo 2015-1', 'Limited subject for GAD Integration of Gender-Responsive Instruction and Curriculum Developmen', 'Integration of gender mainstreaming in curriculum/ subjects in all levels', 'MFO: Research ServicesExtension Services Advance Education ServicesHigher Education Services', 'Preparation of syllabi and classroom teaching integrating gender perspective', 'Number of faculty members integrated Gender perspective in the syllabus - 567 permanent and 125 COS females and males faculty integrating and development of gender-sensitive learning materials', 58295539.71, 'PS 567 Teaching employees and COS 51,294,972.71 Teaching Overload 7,000,000.00', 'GAA GAA', 'GAD Office, GFPS-TWG members, all colleges', 'organization-focused activity'),
(27, 'Need to sustain a functional and gender-responsive GAD Focal Point System (GFPS) and GAD Office to ensure the effective mainstreaming of gender perspective in BSU academic, research, extension, and administrative programs/Section 37-C2 of the Magna Carta ', 'Sustained operations of the existing GAD Office-Provision of administrative, logistical, and financial support for the day-to-day functioning of the GAD Office maintenance of GAD database and documentation systems coordination of GFPS and GAD-related activities across colleges and units.', 'To ensure the continuous and efficient operation of a functional, gender-responsive GAD Office that leads, monitors, and evaluates GAD mainstreaming efforts in the university.', 'MFO: Research ServicesExtension Services Advance Education ServicesHigher Education Services', 'Sustaining Gender Mainstreaming and Institutional Support in the University', 'Fully maintained GAD Office - 100% fully maintained GAD office', 8052420.09, 'PS on Procurement Process 30,992.09 PS Attribution: Execom & TWG members 7,219,424.00 Supplies Equipment and Materials 300,000.00 PS of GAD Director(50%) 501,954.00', 'GAA GAA GAA GAA', 'GAD Office', 'organization-focused activity'),
(28, '', '', '', '', 'Transportation Equipment Outlay', '', 12285000.00, '', 'GAA', 'TASU, PMO, SPMO', 'attributed program'),
(29, '', '', '', '', 'Repair and Maintenance Office Building and other Structures', '', 6402000.00, '', 'GAA', 'PU, PMO, SPMO', 'attributed program'),
(30, '', '', '', '', 'Bamboo Industry Development for Environment Conservation and Countryside', '', 3750000.00, '', 'GAA', 'PU, PMO, SPMO', 'attributed program'),
(31, '', '', '', '', 'Benguet State University Student Information and Accounting System (SIAS)', '', 5000000.00, '', 'GAA', 'ICT, PMO', 'attributed program');

-- --------------------------------------------------------

--
-- Table structure for table `gpb_budget_breakdown`
--

CREATE TABLE `gpb_budget_breakdown` (
  `breakdown_id` int(11) NOT NULL,
  `gpb_id` int(11) NOT NULL,
  `category` varchar(255) DEFAULT NULL,
  `amount` decimal(15,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `gpb_budget_breakdown`
--
DELIMITER $$
CREATE TRIGGER `trg_sync_budget` AFTER INSERT ON `gpb_budget_breakdown` FOR EACH ROW BEGIN
    UPDATE gad_plan_budget
    SET budget_breakdown = (
        SELECT GROUP_CONCAT(CONCAT(category, ': ', amount) SEPARATOR ', ')
        FROM gpb_budget_breakdown
        WHERE gpb_id = NEW.gpb_id
    )
    WHERE gpb_id = NEW.gpb_id;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_sync_budget_delete` AFTER DELETE ON `gpb_budget_breakdown` FOR EACH ROW BEGIN
    UPDATE gad_plan_budget
    SET budget_breakdown = (
        SELECT GROUP_CONCAT(CONCAT(category, ': ', amount) SEPARATOR ', ')
        FROM gpb_budget_breakdown
        WHERE gpb_id = OLD.gpb_id
    )
    WHERE gpb_id = OLD.gpb_id;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_sync_budget_update` AFTER UPDATE ON `gpb_budget_breakdown` FOR EACH ROW BEGIN
    UPDATE gad_plan_budget
    SET budget_breakdown = (
        SELECT GROUP_CONCAT(CONCAT(category, ': ', amount) SEPARATOR ', ')
        FROM gpb_budget_breakdown
        WHERE gpb_id = NEW.gpb_id
    )
    WHERE gpb_id = NEW.gpb_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `gpb_offices_map`
--

CREATE TABLE `gpb_offices_map` (
  `gpb_id` int(11) NOT NULL,
  `office_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `gpb_offices_map`
--
DELIMITER $$
CREATE TRIGGER `trg_sync_offices` AFTER INSERT ON `gpb_offices_map` FOR EACH ROW BEGIN
    UPDATE gad_plan_budget
    SET responsible_unit_office = (
        SELECT GROUP_CONCAT(o.office_name SEPARATOR ', ')
        FROM office_units o
        JOIN gpb_offices_map gom ON o.office_id = gom.office_id
        WHERE gom.gpb_id = NEW.gpb_id
    )
    WHERE gpb_id = NEW.gpb_id;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_sync_offices_delete` AFTER DELETE ON `gpb_offices_map` FOR EACH ROW BEGIN
    UPDATE gad_plan_budget
    SET responsible_unit_office = (
        SELECT GROUP_CONCAT(o.office_name SEPARATOR ', ')
        FROM office_units o
        JOIN gpb_offices_map gom ON o.office_id = gom.office_id
        WHERE gom.gpb_id = OLD.gpb_id
    )
    WHERE gpb_id = OLD.gpb_id;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_sync_offices_update` AFTER UPDATE ON `gpb_offices_map` FOR EACH ROW BEGIN
    UPDATE gad_plan_budget
    SET responsible_unit_office = (
        SELECT GROUP_CONCAT(o.office_name SEPARATOR ', ')
        FROM office_units o
        JOIN gpb_offices_map gom ON o.office_id = gom.office_id
        WHERE gom.gpb_id = NEW.gpb_id
    )
    WHERE gpb_id = NEW.gpb_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `mandate`
--

CREATE TABLE `mandate` (
  `mandate_id` int(11) NOT NULL,
  `mandate_name` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `gpb_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `office_units`
--

CREATE TABLE `office_units` (
  `office_id` int(11) NOT NULL,
  `office_name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `office_units`
--

INSERT INTO `office_units` (`office_id`, `office_name`) VALUES
(25, 'Accounting Office'),
(28, 'Bokod Focal Person, University Health Services'),
(23, 'BSU Office of Student Services'),
(14, 'Budget Office'),
(31, 'Budget Office Buguias Campus'),
(29, 'Buguias Focal Person, College of Agriculture'),
(2, 'College of Agriculture'),
(8, 'College of Applied Techonology BSU Bokod Campus'),
(36, 'College of Arts and Humanities'),
(45, 'College of Education BSU Bokod Campus'),
(21, 'College of Engineering'),
(46, 'College of Forestry'),
(39, 'College of Home Economics and Technology'),
(26, 'College of Human Kenetics'),
(32, 'College of Information Sciences'),
(17, 'College of Natural Sciences'),
(42, 'College of Numeracy and Applied Sciences'),
(22, 'College of Nursing'),
(18, 'College of Public Administration and Governance'),
(7, 'College of Social Science'),
(37, 'College of Teacher Education'),
(11, 'College of Veterinary Medicine'),
(12, 'Compensarion, Benefits and Other Obligations'),
(6, 'Disaster Risk Reduction Management'),
(47, 'gad.staff'),
(1, 'Gender And Development'),
(20, 'General Services Office'),
(27, 'Horticulture'),
(38, 'Human Resource and Management Office'),
(4, 'Human Resources and Management Office BSU Bokod Campus'),
(30, 'Human Resources Development Office'),
(19, 'Information and Communications Technolgy'),
(5, 'International Relations Office'),
(43, 'Northern Philippines Root Crops Research  & Training Center'),
(15, 'Office for Quality Assurance and Accreditation'),
(35, 'Office of Student Services'),
(44, 'Open University'),
(34, 'Procurement Management Office'),
(33, 'Procurement Management Office BSU Bokod Campus'),
(13, 'Records Office and Archives'),
(3, 'Registrar\'s Office BSU Buguias Campus'),
(40, 'Supply Property Management Office'),
(9, 'University Business Affairs Office'),
(16, 'University Health Services BSU Buguias Campus'),
(10, 'University Library and Information Service BSU Buguias Campus'),
(41, 'University Library and Information Services'),
(24, 'University Public Affairs Office');

-- --------------------------------------------------------

--
-- Table structure for table `system_logs`
--

CREATE TABLE `system_logs` (
  `log_id` bigint(20) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `action_type` varchar(100) DEFAULT NULL,
  `target_table` varchar(50) DEFAULT NULL,
  `target_id` int(11) DEFAULT NULL,
  `log_timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `username` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `role` varchar(255) DEFAULT NULL,
  `full_name` varchar(255) DEFAULT NULL,
  `student_id` varchar(255) DEFAULT NULL,
  `office_id` int(11) DEFAULT NULL,
  `year_level` varchar(255) DEFAULT NULL,
  `user_acronym` varchar(255) DEFAULT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `email_verified_at`, `password`, `role`, `full_name`, `student_id`, `office_id`, `year_level`, `user_acronym`, `remember_token`, `deleted_at`, `created_at`, `updated_at`) VALUES
(1, 'Gender And Development', 'gad.office@bsu.edu.ph', NULL, '$2y$12$TUG4cubrDNdHbOd2q6WsdOAyxxwwCW71UuPE9AEnIIyg.BQeueFW.', 'admin', NULL, NULL, 1, NULL, 'GAD', NULL, NULL, '2026-05-25 11:58:10', '2026-05-25 11:58:10'),
(2, 'College of Agriculture', 'ca@bsu.edu.ph', NULL, '$2y$12$CNLb7UPOnZpF2yZRY0lwSeykT0VWruAa6R753JUJR3bGr2OCvUyei', 'college', NULL, NULL, 2, NULL, 'CA', NULL, NULL, '2026-05-25 11:58:10', '2026-05-25 11:58:10'),
(3, 'Registrar\'s Office BSU Buguias Campus', 'buguias.registrar@bsu.edu.ph', NULL, '$2y$12$eui0gKkIcPjUUBiMFy3jC.CbSSpdnjQawQccHsHAHmcOZIuKK4Y9m', 'college', NULL, NULL, 3, NULL, 'Buguias-RO', NULL, NULL, '2026-05-25 11:58:10', '2026-06-14 10:20:48'),
(4, 'Human Resources and Management Office BSU Bokod Campus', 'bokod.hrmo@bsu.edu.ph', NULL, '$2y$12$eui0gKkIcPjUUBiMFy3jC.CbSSpdnjQawQccHsHAHmcOZIuKK4Y9m', 'college', NULL, NULL, 4, NULL, NULL, 'Bokod-HRMO', NULL, '2026-05-25 11:58:10', '2026-06-14 10:20:48'),
(5, 'International Relations Office', 'iro@bsu.edu.ph', NULL, '$2y$12$eui0gKkIcPjUUBiMFy3jC.CbSSpdnjQawQccHsHAHmcOZIuKK4Y9m', 'college', NULL, NULL, 5, NULL, 'IRO', NULL, NULL, '2026-05-25 11:58:10', '2026-06-14 10:24:28'),
(6, 'Disaster Risk Reduction Management', 'drrm@bsu.edu.ph', NULL, '$2y$12$eui0gKkIcPjUUBiMFy3jC.CbSSpdnjQawQccHsHAHmcOZIuKK4Y9m', 'college', NULL, NULL, 6, NULL, 'DRRM', NULL, NULL, '2026-05-25 11:58:10', '2026-06-14 10:24:28'),
(7, 'College of Social Science', 'css@bsu.edu.ph', NULL, '$2y$12$eui0gKkIcPjUUBiMFy3jC.CbSSpdnjQawQccHsHAHmcOZIuKK4Y9m', 'college', NULL, NULL, 7, NULL, 'CSS', NULL, NULL, '2026-05-25 11:58:10', '2026-06-14 10:24:28'),
(8, 'College of Applied Techonology BSU Bokod Campus', 'bokod.cat@bsu.edu.ph', NULL, '$2y$12$eui0gKkIcPjUUBiMFy3jC.CbSSpdnjQawQccHsHAHmcOZIuKK4Y9m', 'college', NULL, NULL, 8, NULL, 'Bokod-CAT', NULL, NULL, '2026-05-25 11:58:10', '2026-06-14 10:24:28'),
(9, 'University Business Affairs Office', 'ubao@bsu.edu.ph', NULL, '$2y$12$eui0gKkIcPjUUBiMFy3jC.CbSSpdnjQawQccHsHAHmcOZIuKK4Y9m', 'college', NULL, NULL, 9, NULL, 'UBAO', NULL, NULL, '2026-05-25 11:58:10', '2026-06-14 10:24:28'),
(10, 'University Library and Information Service BSU Buguias Campus', 'ulis.buguias@bsu.edu.ph', NULL, '$2y$12$eui0gKkIcPjUUBiMFy3jC.CbSSpdnjQawQccHsHAHmcOZIuKK4Y9m', 'college', NULL, NULL, 10, NULL, 'Buguias-ULIS', NULL, NULL, '2026-05-25 11:58:10', '2026-06-14 10:24:28'),
(11, 'College of Veterinary Medicine', 'vm@bsu.edu.ph', NULL, '$2y$12$eui0gKkIcPjUUBiMFy3jC.CbSSpdnjQawQccHsHAHmcOZIuKK4Y9m', 'college', NULL, NULL, 11, NULL, 'CVM', NULL, NULL, '2026-05-25 11:58:10', '2026-06-14 10:24:28'),
(12, 'Compensarion, Benefits and Other Obligations', 'cboo@bsu.edu.ph', NULL, '$2y$12$eui0gKkIcPjUUBiMFy3jC.CbSSpdnjQawQccHsHAHmcOZIuKK4Y9m', 'college', NULL, NULL, 12, NULL, 'CBOO', NULL, NULL, '2026-05-25 11:58:10', '2026-06-14 10:24:28'),
(13, 'Records Office and Archives', 'roa@bsu.edu.ph', NULL, '$2y$12$eui0gKkIcPjUUBiMFy3jC.CbSSpdnjQawQccHsHAHmcOZIuKK4Y9m', 'college', NULL, NULL, 13, NULL, 'ROA', NULL, NULL, '2026-05-25 11:58:10', '2026-06-14 10:24:28'),
(14, 'Budget Office', 'bo@bsu.edu.ph', NULL, '$2y$12$eui0gKkIcPjUUBiMFy3jC.CbSSpdnjQawQccHsHAHmcOZIuKK4Y9m', 'college', NULL, NULL, 14, NULL, NULL, 'BO', NULL, '2026-05-25 11:58:10', '2026-06-14 10:24:28'),
(15, 'Office for Quality Assurance and Accreditation', 'oqaa@bsu.edu.ph', NULL, '$2y$12$eui0gKkIcPjUUBiMFy3jC.CbSSpdnjQawQccHsHAHmcOZIuKK4Y9m', 'college', NULL, NULL, 15, NULL, 'OQAA', NULL, NULL, '2026-05-25 11:58:10', '2026-06-14 10:24:28'),
(16, 'University Health Services BSU Buguias Campus', 'buguias.uhs@bsu.edu.ph', NULL, '$2y$12$eui0gKkIcPjUUBiMFy3jC.CbSSpdnjQawQccHsHAHmcOZIuKK4Y9m', 'college', NULL, NULL, 16, NULL, 'Buguias-UHS', NULL, NULL, '2026-05-25 11:58:10', '2026-06-14 10:24:28'),
(17, 'College of Natural Sciences', 'cns@bsu.edu.ph', NULL, '$2y$12$eui0gKkIcPjUUBiMFy3jC.CbSSpdnjQawQccHsHAHmcOZIuKK4Y9m', 'college', NULL, NULL, 17, NULL, NULL, 'CNS', NULL, '2026-05-25 11:58:10', '2026-06-14 10:24:28'),
(18, 'College of Public Administration and Governance', 'cpag@bsu.edu.ph', NULL, '$2y$12$eui0gKkIcPjUUBiMFy3jC.CbSSpdnjQawQccHsHAHmcOZIuKK4Y9m', 'college', NULL, NULL, 18, NULL, 'CPAG', NULL, NULL, '2026-05-25 11:58:10', '2026-06-14 10:24:28'),
(19, 'Information and Communications Technolgy', 'ict@bsu.edu.ph', NULL, '$2y$12$eui0gKkIcPjUUBiMFy3jC.CbSSpdnjQawQccHsHAHmcOZIuKK4Y9m', 'college', NULL, NULL, 19, NULL, 'ICT', NULL, NULL, '2026-05-25 11:58:10', '2026-06-14 10:24:28'),
(20, 'General Services Office', 'gso@bsu.edu.ph', NULL, '$2y$12$eui0gKkIcPjUUBiMFy3jC.CbSSpdnjQawQccHsHAHmcOZIuKK4Y9m', 'college', NULL, NULL, 20, NULL, 'GSO', NULL, NULL, '2026-05-25 11:58:10', '2026-06-14 10:24:28'),
(21, 'College of Engineering', 'ce@bsu.edu.ph', NULL, '$2y$12$eui0gKkIcPjUUBiMFy3jC.CbSSpdnjQawQccHsHAHmcOZIuKK4Y9m', 'college', NULL, NULL, 21, NULL, 'CE', NULL, NULL, '2026-05-25 11:58:10', '2026-06-14 10:24:28'),
(22, 'College of Nursing', 'cn@bsu.edu.ph', NULL, '$2y$12$eui0gKkIcPjUUBiMFy3jC.CbSSpdnjQawQccHsHAHmcOZIuKK4Y9m', 'college', NULL, NULL, 22, NULL, 'CN', NULL, NULL, '2026-05-25 11:58:10', '2026-06-14 10:24:28'),
(23, 'BSU Office of Student Services', 'oss@bsu.edu.ph', NULL, '$2y$12$eui0gKkIcPjUUBiMFy3jC.CbSSpdnjQawQccHsHAHmcOZIuKK4Y9m', 'college', NULL, NULL, 23, NULL, 'OSS', NULL, NULL, '2026-05-25 11:58:10', '2026-06-14 10:24:28'),
(24, 'University Public Affairs Office', 'upao@bsu.edu.ph', NULL, '$2y$12$eui0gKkIcPjUUBiMFy3jC.CbSSpdnjQawQccHsHAHmcOZIuKK4Y9m', 'college', NULL, NULL, 24, NULL, 'UPAO', NULL, NULL, '2026-05-25 11:58:10', '2026-06-14 10:24:28'),
(25, 'Accounting Office', 'ao@bsu.edu.ph', NULL, '$2y$12$eui0gKkIcPjUUBiMFy3jC.CbSSpdnjQawQccHsHAHmcOZIuKK4Y9m', 'college', NULL, NULL, 25, NULL, 'AO', NULL, NULL, '2026-05-25 11:58:10', '2026-06-14 10:24:28'),
(26, 'College of Human Kenetics', 'chk@bsu.edu.ph', NULL, '$2y$12$eui0gKkIcPjUUBiMFy3jC.CbSSpdnjQawQccHsHAHmcOZIuKK4Y9m', 'college', NULL, NULL, 26, NULL, 'CHK', NULL, NULL, '2026-05-25 11:58:10', '2026-06-14 10:24:28'),
(27, 'Horticulture', 'h@bsu.edu.ph', NULL, '$2y$12$eui0gKkIcPjUUBiMFy3jC.CbSSpdnjQawQccHsHAHmcOZIuKK4Y9m', 'college', NULL, NULL, 27, NULL, 'Horticulture', NULL, NULL, '2026-05-25 11:58:10', '2026-06-14 10:24:28'),
(28, 'Bokod Focal Person, University Health Services', 'bokod.uhs@bsu.edu.ph', NULL, '$2y$12$eui0gKkIcPjUUBiMFy3jC.CbSSpdnjQawQccHsHAHmcOZIuKK4Y9m', 'college', NULL, NULL, 28, NULL, 'Bokod-FC,UHS', NULL, NULL, '2026-05-25 11:58:10', '2026-06-14 10:24:28'),
(29, 'Buguias Focal Person, College of Agriculture', 'buguias.ca@bsu.edu.ph', NULL, '$2y$12$eui0gKkIcPjUUBiMFy3jC.CbSSpdnjQawQccHsHAHmcOZIuKK4Y9m', 'college', NULL, NULL, 29, NULL, 'Buguias-FC,CA', NULL, NULL, '2026-05-25 11:58:10', '2026-06-14 10:24:28'),
(30, 'Human Resources Development Office', 'hrdo@bsu.edu.ph', NULL, '$2y$12$eui0gKkIcPjUUBiMFy3jC.CbSSpdnjQawQccHsHAHmcOZIuKK4Y9m', 'college', NULL, NULL, 30, NULL, 'HRDO', NULL, NULL, '2026-05-25 11:58:10', '2026-06-14 10:24:28'),
(31, 'Budget Office Buguias Campus', 'buguias.bo@bsu.edu.ph', NULL, '$2y$12$eui0gKkIcPjUUBiMFy3jC.CbSSpdnjQawQccHsHAHmcOZIuKK4Y9m', 'college', NULL, NULL, 31, NULL, 'Buguias-BO', NULL, NULL, '2026-05-25 11:58:10', '2026-06-14 10:24:28'),
(32, 'College of Information Sciences', 'cis@bsu.edu.ph', NULL, '$2y$12$eui0gKkIcPjUUBiMFy3jC.CbSSpdnjQawQccHsHAHmcOZIuKK4Y9m', 'college', NULL, NULL, 32, NULL, 'CIS', NULL, NULL, '2026-05-25 11:58:10', '2026-06-14 10:24:28'),
(33, 'Procurement Management Office BSU Bokod Campus', 'bokod.pmo@bsu.edu.ph', NULL, '$2y$12$eui0gKkIcPjUUBiMFy3jC.CbSSpdnjQawQccHsHAHmcOZIuKK4Y9m', 'college', NULL, NULL, 33, NULL, 'Bokod-PMO', NULL, NULL, '2026-05-25 11:58:10', '2026-06-14 10:24:28'),
(34, 'Procurement Management Office', 'pmo@bsu.edu.ph', NULL, '$2y$12$eui0gKkIcPjUUBiMFy3jC.CbSSpdnjQawQccHsHAHmcOZIuKK4Y9m', 'college', NULL, NULL, 34, NULL, 'PMO', NULL, NULL, '2026-05-25 11:58:10', '2026-06-14 10:24:28'),
(35, 'Office of Student Services', 'oss.2@bsu.edu.ph', NULL, '$2y$12$eui0gKkIcPjUUBiMFy3jC.CbSSpdnjQawQccHsHAHmcOZIuKK4Y9m', 'college', NULL, NULL, 35, NULL, 'OSS', NULL, NULL, '2026-05-25 11:58:10', '2026-06-14 10:24:28'),
(36, 'College of Arts and Humanities', 'cah@bsu.edu.ph', NULL, '$2y$12$eui0gKkIcPjUUBiMFy3jC.CbSSpdnjQawQccHsHAHmcOZIuKK4Y9m', 'college', NULL, NULL, 36, NULL, 'CAH', NULL, NULL, '2026-05-25 11:58:10', '2026-06-14 10:24:28'),
(37, 'College of Teacher Education', 'cte@bsu.edu.ph', NULL, '$2y$12$eui0gKkIcPjUUBiMFy3jC.CbSSpdnjQawQccHsHAHmcOZIuKK4Y9m', 'college', NULL, NULL, 37, NULL, 'CTE', NULL, NULL, '2026-05-25 11:58:10', '2026-06-14 10:24:28'),
(38, 'Human Resource and Management Office', 'hrmo@bsu.edu.ph', NULL, '$2y$12$eui0gKkIcPjUUBiMFy3jC.CbSSpdnjQawQccHsHAHmcOZIuKK4Y9m', 'college', NULL, NULL, 38, NULL, 'HRMO', NULL, NULL, '2026-05-25 11:58:10', '2026-06-14 10:24:28'),
(39, 'College of Home Economics and Technology', 'chet@bsu.edu.ph', NULL, '$2y$12$eui0gKkIcPjUUBiMFy3jC.CbSSpdnjQawQccHsHAHmcOZIuKK4Y9m', 'college', NULL, NULL, 39, NULL, 'CHET', NULL, NULL, '2026-05-25 11:58:10', '2026-06-14 10:24:28'),
(40, 'Supply Property Management Office', 'spmo@bsu.edu.ph', NULL, '$2y$12$eui0gKkIcPjUUBiMFy3jC.CbSSpdnjQawQccHsHAHmcOZIuKK4Y9m', 'college', NULL, NULL, 40, NULL, 'SPMO', NULL, NULL, '2026-05-25 11:58:10', '2026-06-14 10:24:28'),
(41, 'University Library and Information Services', 'ulis@bsu.edu.ph', NULL, '$2y$12$eui0gKkIcPjUUBiMFy3jC.CbSSpdnjQawQccHsHAHmcOZIuKK4Y9m', 'college', NULL, NULL, 41, NULL, 'ULIS', NULL, NULL, '2026-05-25 11:58:10', '2026-06-14 10:24:28'),
(42, 'College of Numeracy and Applied Sciences', 'cnas@bsu.edu.ph', NULL, '$2y$12$eui0gKkIcPjUUBiMFy3jC.CbSSpdnjQawQccHsHAHmcOZIuKK4Y9m', 'college', NULL, NULL, 42, NULL, 'CNAS', NULL, NULL, '2026-05-25 11:58:10', '2026-06-14 10:24:28'),
(43, 'Northern Philippines Root Crops Research  & Training Center', 'nprcrtc@bsu.edu.ph', NULL, '$2y$12$eui0gKkIcPjUUBiMFy3jC.CbSSpdnjQawQccHsHAHmcOZIuKK4Y9m', 'college', NULL, NULL, 43, NULL, 'NPRCRTC', NULL, NULL, '2026-05-25 11:58:10', '2026-06-14 10:24:28'),
(44, 'Open University', 'ou@bsu.edu.ph', NULL, '$2y$12$eui0gKkIcPjUUBiMFy3jC.CbSSpdnjQawQccHsHAHmcOZIuKK4Y9m', 'college', NULL, NULL, 44, NULL, 'OU', NULL, NULL, '2026-05-25 11:58:10', '2026-06-14 10:24:28'),
(45, 'College of Education BSU Bokod Campus', 'bokod.ce@bsu.edu.ph', NULL, '$2y$12$eui0gKkIcPjUUBiMFy3jC.CbSSpdnjQawQccHsHAHmcOZIuKK4Y9m', 'college', NULL, NULL, 45, NULL, 'Bokod-CE', NULL, NULL, '2026-05-25 11:58:10', '2026-06-14 10:24:28'),
(46, 'College of Forestry', 'cf@bsu.edu.ph', NULL, '$2y$12$eui0gKkIcPjUUBiMFy3jC.CbSSpdnjQawQccHsHAHmcOZIuKK4Y9m', 'college', NULL, NULL, 46, NULL, 'CF', NULL, NULL, '2026-05-25 11:58:10', '2026-06-14 10:24:28'),
(47, 'gad.staff', 'gad.staff@bsu.edu.ph', NULL, '$2y$12$fbD/jvk.znEQnBmKq4.ebOojmijHJO/zU7.P7Tzo.zV3FgvP8PzNe', 'gad_staff', 'GAD Staff User', NULL, 47, NULL, 'GAD-STAFF', NULL, NULL, '2026-03-26 15:53:56', '2026-06-05 02:30:59');

-- --------------------------------------------------------

--
-- Table structure for table `user_profiles`
--

CREATE TABLE `user_profiles` (
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `middle_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) NOT NULL,
  `user_role` enum('Director','Staff','TWG','Non-TWG') DEFAULT NULL,
  `office_unit_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `venues`
--

CREATE TABLE `venues` (
  `venue_id` int(11) NOT NULL,
  `venue_name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `venues`
--

INSERT INTO `venues` (`venue_id`, `venue_name`) VALUES
(2, 'BSU Covered Court'),
(1, 'BSU Gymnasium'),
(12, 'Carnation Hall'),
(10, 'CHET Hall'),
(11, 'CHK Function Hall'),
(9, 'CTE DSG Hall'),
(16, 'Dimas Hall, IHFSA'),
(13, 'Everlasting Hall'),
(7, 'Gladiola Center'),
(15, 'Igorota Hall'),
(5, 'International Dorm Hall'),
(6, 'IRO Hall'),
(18, 'Main Auditorium'),
(17, 'OSS Social Hall'),
(3, 'RDC Hall'),
(8, 'RSDC Executive Hall'),
(14, 'Solibao Hall'),
(4, 'VP AdFin Hall');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accomplishment_budget_items`
--
ALTER TABLE `accomplishment_budget_items`
  ADD PRIMARY KEY (`item_id`),
  ADD KEY `fk_accomplishment_budget_report` (`accomplishment_report_id`);

--
-- Indexes for table `accomplishment_evaluation_results`
--
ALTER TABLE `accomplishment_evaluation_results`
  ADD PRIMARY KEY (`evaluation_id`),
  ADD KEY `fk_accomplishment_evaluation_report` (`accomplishment_report_id`);

--
-- Indexes for table `accomplishment_report`
--
ALTER TABLE `accomplishment_report`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_report_user` (`user_id`),
  ADD KEY `idx_ar_control_number` (`control_number`);

--
-- Indexes for table `activity_budget_items`
--
ALTER TABLE `activity_budget_items`
  ADD PRIMARY KEY (`item_id`),
  ADD KEY `fk_budget_item_design` (`act_design_id`);

--
-- Indexes for table `activity_design`
--
ALTER TABLE `activity_design`
  ADD PRIMARY KEY (`act_design_id`),
  ADD KEY `fk_activity_user` (`user_id`),
  ADD KEY `fk_activity_gpb` (`gpb_id`),
  ADD KEY `fk_design_venue` (`venue_id`);

--
-- Indexes for table `archived_accomplishment_reports`
--
ALTER TABLE `archived_accomplishment_reports`
  ADD PRIMARY KEY (`archive_id`),
  ADD KEY `idx_aar_control_number` (`control_number`);

--
-- Indexes for table `archived_activity_designs`
--
ALTER TABLE `archived_activity_designs`
  ADD PRIMARY KEY (`archive_id`);

--
-- Indexes for table `control_number`
--
ALTER TABLE `control_number`
  ADD PRIMARY KEY (`control_number_id`),
  ADD UNIQUE KEY `control_number` (`control_number`),
  ADD UNIQUE KEY `uk_control_number` (`control_number`),
  ADD KEY `fk_control_activity` (`act_design_id`),
  ADD KEY `fk_control_user` (`user_id`);

--
-- Indexes for table `gad_plan_budget`
--
ALTER TABLE `gad_plan_budget`
  ADD PRIMARY KEY (`gpb_id`);

--
-- Indexes for table `gpb_budget_breakdown`
--
ALTER TABLE `gpb_budget_breakdown`
  ADD PRIMARY KEY (`breakdown_id`),
  ADD KEY `gpb_id` (`gpb_id`);

--
-- Indexes for table `gpb_offices_map`
--
ALTER TABLE `gpb_offices_map`
  ADD PRIMARY KEY (`gpb_id`,`office_id`),
  ADD KEY `office_id` (`office_id`);

--
-- Indexes for table `mandate`
--
ALTER TABLE `mandate`
  ADD PRIMARY KEY (`mandate_id`),
  ADD KEY `fk_mandate_gpb` (`gpb_id`);

--
-- Indexes for table `office_units`
--
ALTER TABLE `office_units`
  ADD PRIMARY KEY (`office_id`),
  ADD UNIQUE KEY `office_name` (`office_name`);

--
-- Indexes for table `system_logs`
--
ALTER TABLE `system_logs`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `idx_logs_user` (`user_id`),
  ADD KEY `idx_logs_action` (`action_type`),
  ADD KEY `idx_logs_time` (`log_timestamp`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_users_office_id` (`office_id`);

--
-- Indexes for table `user_profiles`
--
ALTER TABLE `user_profiles`
  ADD PRIMARY KEY (`user_id`);

--
-- Indexes for table `venues`
--
ALTER TABLE `venues`
  ADD PRIMARY KEY (`venue_id`),
  ADD UNIQUE KEY `uk_venue_name` (`venue_name`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `accomplishment_budget_items`
--
ALTER TABLE `accomplishment_budget_items`
  MODIFY `item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `accomplishment_evaluation_results`
--
ALTER TABLE `accomplishment_evaluation_results`
  MODIFY `evaluation_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `accomplishment_report`
--
ALTER TABLE `accomplishment_report`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `activity_budget_items`
--
ALTER TABLE `activity_budget_items`
  MODIFY `item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `activity_design`
--
ALTER TABLE `activity_design`
  MODIFY `act_design_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `archived_accomplishment_reports`
--
ALTER TABLE `archived_accomplishment_reports`
  MODIFY `archive_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `archived_activity_designs`
--
ALTER TABLE `archived_activity_designs`
  MODIFY `archive_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `control_number`
--
ALTER TABLE `control_number`
  MODIFY `control_number_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `gad_plan_budget`
--
ALTER TABLE `gad_plan_budget`
  MODIFY `gpb_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT for table `gpb_budget_breakdown`
--
ALTER TABLE `gpb_budget_breakdown`
  MODIFY `breakdown_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `mandate`
--
ALTER TABLE `mandate`
  MODIFY `mandate_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `office_units`
--
ALTER TABLE `office_units`
  MODIFY `office_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT for table `system_logs`
--
ALTER TABLE `system_logs`
  MODIFY `log_id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT for table `venues`
--
ALTER TABLE `venues`
  MODIFY `venue_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `accomplishment_budget_items`
--
ALTER TABLE `accomplishment_budget_items`
  ADD CONSTRAINT `fk_accomplishment_budget_report` FOREIGN KEY (`accomplishment_report_id`) REFERENCES `accomplishment_report` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `accomplishment_evaluation_results`
--
ALTER TABLE `accomplishment_evaluation_results`
  ADD CONSTRAINT `fk_accomplishment_evaluation_report` FOREIGN KEY (`accomplishment_report_id`) REFERENCES `accomplishment_report` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `accomplishment_report`
--
ALTER TABLE `accomplishment_report`
  ADD CONSTRAINT `fk_ar_control_number` FOREIGN KEY (`control_number`) REFERENCES `control_number` (`control_number`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_report_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `activity_budget_items`
--
ALTER TABLE `activity_budget_items`
  ADD CONSTRAINT `fk_budget_item_design` FOREIGN KEY (`act_design_id`) REFERENCES `activity_design` (`act_design_id`) ON DELETE CASCADE;

--
-- Constraints for table `activity_design`
--
ALTER TABLE `activity_design`
  ADD CONSTRAINT `fk_activity_gpb` FOREIGN KEY (`gpb_id`) REFERENCES `gad_plan_budget` (`gpb_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_activity_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_design_venue` FOREIGN KEY (`venue_id`) REFERENCES `venues` (`venue_id`) ON DELETE SET NULL;

--
-- Constraints for table `archived_accomplishment_reports`
--
ALTER TABLE `archived_accomplishment_reports`
  ADD CONSTRAINT `fk_aar_control_number` FOREIGN KEY (`control_number`) REFERENCES `control_number` (`control_number`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `control_number`
--
ALTER TABLE `control_number`
  ADD CONSTRAINT `fk_control_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `gpb_budget_breakdown`
--
ALTER TABLE `gpb_budget_breakdown`
  ADD CONSTRAINT `gpb_budget_breakdown_ibfk_1` FOREIGN KEY (`gpb_id`) REFERENCES `gad_plan_budget` (`gpb_id`) ON DELETE CASCADE;

--
-- Constraints for table `gpb_offices_map`
--
ALTER TABLE `gpb_offices_map`
  ADD CONSTRAINT `gpb_offices_map_ibfk_1` FOREIGN KEY (`gpb_id`) REFERENCES `gad_plan_budget` (`gpb_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `gpb_offices_map_ibfk_2` FOREIGN KEY (`office_id`) REFERENCES `office_units` (`office_id`) ON DELETE CASCADE;

--
-- Constraints for table `mandate`
--
ALTER TABLE `mandate`
  ADD CONSTRAINT `fk_mandate_gpb` FOREIGN KEY (`gpb_id`) REFERENCES `gad_plan_budget` (`gpb_id`) ON DELETE SET NULL;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_users_office_id` FOREIGN KEY (`office_id`) REFERENCES `office_units` (`office_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `user_profiles`
--
ALTER TABLE `user_profiles`
  ADD CONSTRAINT `fk_user_profiles_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
