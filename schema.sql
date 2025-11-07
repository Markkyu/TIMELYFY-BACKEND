-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 07, 2025 at 05:10 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `timelyfydb`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_class_schedules` (IN `p_college_id` INT)   BEGIN
    DECLARE id_increment_slot INT DEFAULT 0;
    DECLARE id_increment_day INT DEFAULT 0;
    DECLARE id_class_group INT DEFAULT 0;
    DECLARE v_college_code VARCHAR(20);
    
    -- Get the college code
    SELECT college_code INTO v_college_code 
    FROM colleges 
    WHERE college_id = p_college_id;
    
    WHILE id_class_group < 4 DO
        
        -- Create class_group_id like: BSCS-Y1, BSCS-Y2, etc.
        SET @group_id = CONCAT(v_college_code, id_class_group + 1);
        
        SET id_increment_day = 0;
        SET id_increment_slot = 0;
        
        WHILE id_increment_day < 5 DO
            INSERT INTO class_schedules(
                class_id,
                slot_day,
                slot_time,
                slot_course
            )
            VALUES (
                @group_id,
                id_increment_day,
                id_increment_slot,
                0
            );
            
            SET id_increment_slot = id_increment_slot + 1;
            IF id_increment_slot = 27 THEN
                SET id_increment_day = id_increment_day + 1;
                SET id_increment_slot = 0;
            END IF;
        END WHILE;
        
        SET id_class_group = id_class_group + 1;
    END WHILE;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `generateRoomSchedule` (IN `p_room_id` VARCHAR(50), IN `p_room_name` VARCHAR(100))   BEGIN
    DECLARE id_increment_slot INT DEFAULT 0; -- start from 1 (7:00 AM)
    DECLARE id_increment_day INT DEFAULT 0;  -- 0 = Monday

    -- Loop through 5 days (Monday to Friday)
    WHILE id_increment_day < 5 DO
        INSERT INTO `room_schedules`
            (`room_id`, `room_name`, `slot_day`, `slot_time`, `slot_course`)
        VALUES
            (p_room_id, p_room_name, id_increment_day, id_increment_slot, '0');

        -- Move to next time slot
        SET id_increment_slot = id_increment_slot + 1;

        -- If time slot reaches end of day (8:30 PM), move to next day
        IF id_increment_slot = 27 THEN
            SET id_increment_day = id_increment_day + 1;
            SET id_increment_slot = 0;
        END IF;
    END WHILE;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `generateTeacherSchedule` (IN `new_teacher_id` INT)   BEGIN
    DECLARE id_increment_slot INT DEFAULT 0;  -- start at 0 (7:00 AM)
    DECLARE id_increment_day INT DEFAULT 0;   -- 0 = Monday

    -- Loop through 5 days (Monday to Friday)
    WHILE id_increment_day < 5 DO
        INSERT INTO teacher_schedules (
            teacher_id,
            slot_day,
            slot_time,
            slot_course
        )
        VALUES (
            new_teacher_id,
            id_increment_day,
            id_increment_slot,
            0
        );

        -- Move to next time slot
        SET id_increment_slot = id_increment_slot + 1;

        -- If time slot reaches end of day (8:30 PM), move to next day
        IF id_increment_slot = 27 THEN
            SET id_increment_day = id_increment_day + 1;
            SET id_increment_slot = 0;
        END IF;
    END WHILE;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `class_schedules`
--

CREATE TABLE `class_schedules` (
  `class_surr_id` int(11) NOT NULL,
  `class_id` text NOT NULL,
  `slot_day` int(11) NOT NULL,
  `slot_time` int(11) NOT NULL,
  `slot_course` text NOT NULL,
  `college_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `colleges`
--

CREATE TABLE `colleges` (
  `college_id` int(11) NOT NULL,
  `college_name` text NOT NULL,
  `college_major` varchar(50) NOT NULL,
  `college_code` varchar(20) DEFAULT NULL,
  `created_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `colleges`
--
DELIMITER $$
CREATE TRIGGER `after_college_insert` AFTER INSERT ON `colleges` FOR EACH ROW BEGIN
    -- Call the procedure to create schedules for the new college
    CALL create_class_schedules(NEW.college_id);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `courses`
--

CREATE TABLE `courses` (
  `course_surrogate_id` int(11) NOT NULL,
  `course_id` varchar(22) NOT NULL,
  `course_code` varchar(10) NOT NULL,
  `course_name` text NOT NULL,
  `hours_week` int(11) NOT NULL,
  `course_year` int(11) NOT NULL,
  `course_college` int(11) NOT NULL,
  `semester` int(11) NOT NULL,
  `assigned_teacher` int(11) DEFAULT NULL,
  `assigned_room` int(11) DEFAULT NULL,
  `is_plotted` tinyint(1) NOT NULL DEFAULT 0,
  `is_special` tinyint(1) NOT NULL DEFAULT 0,
  `created_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `merge_courses`
--

CREATE TABLE `merge_courses` (
  `merge_id` int(11) NOT NULL,
  `merge_college_code` varchar(30) NOT NULL,
  `merge_course` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `phase_control`
--

CREATE TABLE `phase_control` (
  `phase_id` int(11) NOT NULL,
  `phase_year` int(11) NOT NULL,
  `phase_sem` int(11) NOT NULL,
  `phase_supervisor` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `phase_control`
--

INSERT INTO `phase_control` (`phase_id`, `phase_year`, `phase_sem`, `phase_supervisor`) VALUES
(1, 1, 1, 'master_scheduler');

-- --------------------------------------------------------

--
-- Table structure for table `profiles`
--

CREATE TABLE `profiles` (
  `id` int(11) NOT NULL,
  `username` text NOT NULL,
  `password` text NOT NULL DEFAULT 'user',
  `role` enum('admin','master_scheduler','super_user','user') NOT NULL DEFAULT 'user',
  `email` varchar(50) NOT NULL,
  `full_name` varchar(50) NOT NULL,
  `created_at` date NOT NULL DEFAULT current_timestamp(),
  `change_password` enum('no','pending','approved') DEFAULT 'no'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `profiles`
--

INSERT INTO `profiles` (`id`, `username`, `password`, `role`, `email`, `full_name`, `created_at`, `change_password`) VALUES
(5, 'vernie', '$2b$10$UoiheGdo88pDsM.jI41.mOXRaVwk8CEXoPk5LcXQtrjVm77xPaMs6', 'master_scheduler', '', '', '2025-10-18', 'no'),
(6, 'admin', '$2b$10$TTIgNemUoQtSon1OOtRs4OfFlBlq3HpuTUtrB8CqecQtdJUBlZYxi', 'admin', '', '', '2025-10-18', 'approved'),
(11, 'master', '$2b$10$Gkur1F5DsOW1ntmw4RdOAetMcpajTfqywejILZJ0kcstlIQUjbqu2', 'master_scheduler', '', '', '2025-10-20', 'no'),
(23, 'user', '$2b$10$SKi0fRlv1cBOYTHGqK8zMus3VgkydPAWwKR.UfZkK/GF4ZZK2f6ai', 'user', '', '', '2025-11-06', 'no'),
(24, 'super', '$2b$10$hPgl3wbvB66vXvMmSlCzwe8hKWGPGB//xMGg1yrQgORQxsPjN/pEG', 'super_user', '', '', '2025-11-07', 'no'),
(25, 'Markkyu', '$2b$10$Yd/10k2Vt3CL4zIE8M4X3uNL6eu79noaSz2xgLgPP7efv6GTPXJZG', 'admin', '', '', '2025-11-07', 'no'),
(26, '123123123', '$2b$10$3iA73MBc/lWpnLnodikkPOmhvedin30r5Dicq/zM8gxqJhSEHgFLi', 'user', '', '', '2025-11-07', 'no');

-- --------------------------------------------------------

--
-- Table structure for table `rooms`
--

CREATE TABLE `rooms` (
  `room_id` int(11) NOT NULL,
  `room_name` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `rooms`
--

INSERT INTO `rooms` (`room_id`, `room_name`) VALUES
(9, 'Engineering Room'),
(10, 'WLE 101'),
(16, 'ComLab 1'),
(17, 'ComLab 2'),
(18, 'ComLab 3'),
(19, 'GYM');

--
-- Triggers `rooms`
--
DELIMITER $$
CREATE TRIGGER `after_room_insert` AFTER INSERT ON `rooms` FOR EACH ROW BEGIN
    CALL generateRoomSchedule(NEW.room_id, NEW.room_name);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `room_schedules`
--

CREATE TABLE `room_schedules` (
  `room_schedule_id` int(11) NOT NULL,
  `room_id` int(11) NOT NULL,
  `room_name` varchar(100) NOT NULL,
  `slot_day` int(11) NOT NULL,
  `slot_time` int(11) NOT NULL,
  `slot_course` varchar(100) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `room_schedules`
--

INSERT INTO `room_schedules` (`room_schedule_id`, `room_id`, `room_name`, `slot_day`, `slot_time`, `slot_course`) VALUES
(943, 9, 'Engineering Room', 0, 0, '0'),
(944, 9, 'Engineering Room', 0, 1, '0'),
(945, 9, 'Engineering Room', 0, 2, '0'),
(946, 9, 'Engineering Room', 0, 3, '0'),
(947, 9, 'Engineering Room', 0, 4, '0'),
(948, 9, 'Engineering Room', 0, 5, '0'),
(949, 9, 'Engineering Room', 0, 6, '0'),
(950, 9, 'Engineering Room', 0, 7, '0'),
(951, 9, 'Engineering Room', 0, 8, '0'),
(952, 9, 'Engineering Room', 0, 9, '0'),
(953, 9, 'Engineering Room', 0, 10, '0'),
(954, 9, 'Engineering Room', 0, 11, '0'),
(955, 9, 'Engineering Room', 0, 12, '0'),
(956, 9, 'Engineering Room', 0, 13, '0'),
(957, 9, 'Engineering Room', 0, 14, '0'),
(958, 9, 'Engineering Room', 0, 15, '0'),
(959, 9, 'Engineering Room', 0, 16, '0'),
(960, 9, 'Engineering Room', 0, 17, '0'),
(961, 9, 'Engineering Room', 0, 18, '0'),
(962, 9, 'Engineering Room', 0, 19, '0'),
(963, 9, 'Engineering Room', 0, 20, '0'),
(964, 9, 'Engineering Room', 0, 21, '0'),
(965, 9, 'Engineering Room', 0, 22, '0'),
(966, 9, 'Engineering Room', 0, 23, '0'),
(967, 9, 'Engineering Room', 0, 24, '0'),
(968, 9, 'Engineering Room', 0, 25, '0'),
(969, 9, 'Engineering Room', 0, 26, '0'),
(970, 9, 'Engineering Room', 1, 0, '0'),
(971, 9, 'Engineering Room', 1, 1, '0'),
(972, 9, 'Engineering Room', 1, 2, '0'),
(973, 9, 'Engineering Room', 1, 3, '0'),
(974, 9, 'Engineering Room', 1, 4, '0'),
(975, 9, 'Engineering Room', 1, 5, '0'),
(976, 9, 'Engineering Room', 1, 6, '0'),
(977, 9, 'Engineering Room', 1, 7, '0'),
(978, 9, 'Engineering Room', 1, 8, '0'),
(979, 9, 'Engineering Room', 1, 9, '0'),
(980, 9, 'Engineering Room', 1, 10, '0'),
(981, 9, 'Engineering Room', 1, 11, '0'),
(982, 9, 'Engineering Room', 1, 12, '0'),
(983, 9, 'Engineering Room', 1, 13, '0'),
(984, 9, 'Engineering Room', 1, 14, '0'),
(985, 9, 'Engineering Room', 1, 15, '0'),
(986, 9, 'Engineering Room', 1, 16, '0'),
(987, 9, 'Engineering Room', 1, 17, '0'),
(988, 9, 'Engineering Room', 1, 18, '0'),
(989, 9, 'Engineering Room', 1, 19, '0'),
(990, 9, 'Engineering Room', 1, 20, '0'),
(991, 9, 'Engineering Room', 1, 21, '0'),
(992, 9, 'Engineering Room', 1, 22, '0'),
(993, 9, 'Engineering Room', 1, 23, '0'),
(994, 9, 'Engineering Room', 1, 24, '0'),
(995, 9, 'Engineering Room', 1, 25, '0'),
(996, 9, 'Engineering Room', 1, 26, '0'),
(997, 9, 'Engineering Room', 2, 0, '0'),
(998, 9, 'Engineering Room', 2, 1, '0'),
(999, 9, 'Engineering Room', 2, 2, '0'),
(1000, 9, 'Engineering Room', 2, 3, '0'),
(1001, 9, 'Engineering Room', 2, 4, '0'),
(1002, 9, 'Engineering Room', 2, 5, '0'),
(1003, 9, 'Engineering Room', 2, 6, '0'),
(1004, 9, 'Engineering Room', 2, 7, '0'),
(1005, 9, 'Engineering Room', 2, 8, '0'),
(1006, 9, 'Engineering Room', 2, 9, '0'),
(1007, 9, 'Engineering Room', 2, 10, '0'),
(1008, 9, 'Engineering Room', 2, 11, '0'),
(1009, 9, 'Engineering Room', 2, 12, '0'),
(1010, 9, 'Engineering Room', 2, 13, '0'),
(1011, 9, 'Engineering Room', 2, 14, '0'),
(1012, 9, 'Engineering Room', 2, 15, '0'),
(1013, 9, 'Engineering Room', 2, 16, '0'),
(1014, 9, 'Engineering Room', 2, 17, '0'),
(1015, 9, 'Engineering Room', 2, 18, '0'),
(1016, 9, 'Engineering Room', 2, 19, '0'),
(1017, 9, 'Engineering Room', 2, 20, '0'),
(1018, 9, 'Engineering Room', 2, 21, '0'),
(1019, 9, 'Engineering Room', 2, 22, '0'),
(1020, 9, 'Engineering Room', 2, 23, '0'),
(1021, 9, 'Engineering Room', 2, 24, '0'),
(1022, 9, 'Engineering Room', 2, 25, '0'),
(1023, 9, 'Engineering Room', 2, 26, '0'),
(1024, 9, 'Engineering Room', 3, 0, '0'),
(1025, 9, 'Engineering Room', 3, 1, '0'),
(1026, 9, 'Engineering Room', 3, 2, '0'),
(1027, 9, 'Engineering Room', 3, 3, '0'),
(1028, 9, 'Engineering Room', 3, 4, '0'),
(1029, 9, 'Engineering Room', 3, 5, '0'),
(1030, 9, 'Engineering Room', 3, 6, '0'),
(1031, 9, 'Engineering Room', 3, 7, '0'),
(1032, 9, 'Engineering Room', 3, 8, '0'),
(1033, 9, 'Engineering Room', 3, 9, '0'),
(1034, 9, 'Engineering Room', 3, 10, '0'),
(1035, 9, 'Engineering Room', 3, 11, '0'),
(1036, 9, 'Engineering Room', 3, 12, '0'),
(1037, 9, 'Engineering Room', 3, 13, '0'),
(1038, 9, 'Engineering Room', 3, 14, '0'),
(1039, 9, 'Engineering Room', 3, 15, '0'),
(1040, 9, 'Engineering Room', 3, 16, '0'),
(1041, 9, 'Engineering Room', 3, 17, '0'),
(1042, 9, 'Engineering Room', 3, 18, '0'),
(1043, 9, 'Engineering Room', 3, 19, '0'),
(1044, 9, 'Engineering Room', 3, 20, '0'),
(1045, 9, 'Engineering Room', 3, 21, '0'),
(1046, 9, 'Engineering Room', 3, 22, '0'),
(1047, 9, 'Engineering Room', 3, 23, '0'),
(1048, 9, 'Engineering Room', 3, 24, '0'),
(1049, 9, 'Engineering Room', 3, 25, '0'),
(1050, 9, 'Engineering Room', 3, 26, '0'),
(1051, 9, 'Engineering Room', 4, 0, '0'),
(1052, 9, 'Engineering Room', 4, 1, '0'),
(1053, 9, 'Engineering Room', 4, 2, '0'),
(1054, 9, 'Engineering Room', 4, 3, '0'),
(1055, 9, 'Engineering Room', 4, 4, '0'),
(1056, 9, 'Engineering Room', 4, 5, '0'),
(1057, 9, 'Engineering Room', 4, 6, '0'),
(1058, 9, 'Engineering Room', 4, 7, '0'),
(1059, 9, 'Engineering Room', 4, 8, '0'),
(1060, 9, 'Engineering Room', 4, 9, '0'),
(1061, 9, 'Engineering Room', 4, 10, '0'),
(1062, 9, 'Engineering Room', 4, 11, '0'),
(1063, 9, 'Engineering Room', 4, 12, '0'),
(1064, 9, 'Engineering Room', 4, 13, '0'),
(1065, 9, 'Engineering Room', 4, 14, '0'),
(1066, 9, 'Engineering Room', 4, 15, '0'),
(1067, 9, 'Engineering Room', 4, 16, '0'),
(1068, 9, 'Engineering Room', 4, 17, '0'),
(1069, 9, 'Engineering Room', 4, 18, '0'),
(1070, 9, 'Engineering Room', 4, 19, '0'),
(1071, 9, 'Engineering Room', 4, 20, '0'),
(1072, 9, 'Engineering Room', 4, 21, '0'),
(1073, 9, 'Engineering Room', 4, 22, '0'),
(1074, 9, 'Engineering Room', 4, 23, '0'),
(1075, 9, 'Engineering Room', 4, 24, '0'),
(1076, 9, 'Engineering Room', 4, 25, '0'),
(1077, 9, 'Engineering Room', 4, 26, '0'),
(1078, 10, 'WLE 101', 0, 0, '0'),
(1079, 10, 'WLE 101', 0, 1, '0'),
(1080, 10, 'WLE 101', 0, 2, '0'),
(1081, 10, 'WLE 101', 0, 3, '0'),
(1082, 10, 'WLE 101', 0, 4, '0'),
(1083, 10, 'WLE 101', 0, 5, '0'),
(1084, 10, 'WLE 101', 0, 6, '0'),
(1085, 10, 'WLE 101', 0, 7, '0'),
(1086, 10, 'WLE 101', 0, 8, '0'),
(1087, 10, 'WLE 101', 0, 9, '0'),
(1088, 10, 'WLE 101', 0, 10, '0'),
(1089, 10, 'WLE 101', 0, 11, '0'),
(1090, 10, 'WLE 101', 0, 12, '0'),
(1091, 10, 'WLE 101', 0, 13, '0'),
(1092, 10, 'WLE 101', 0, 14, '0'),
(1093, 10, 'WLE 101', 0, 15, '0'),
(1094, 10, 'WLE 101', 0, 16, '0'),
(1095, 10, 'WLE 101', 0, 17, '0'),
(1096, 10, 'WLE 101', 0, 18, '0'),
(1097, 10, 'WLE 101', 0, 19, '0'),
(1098, 10, 'WLE 101', 0, 20, '0'),
(1099, 10, 'WLE 101', 0, 21, '0'),
(1100, 10, 'WLE 101', 0, 22, '0'),
(1101, 10, 'WLE 101', 0, 23, '0'),
(1102, 10, 'WLE 101', 0, 24, '0'),
(1103, 10, 'WLE 101', 0, 25, '0'),
(1104, 10, 'WLE 101', 0, 26, '0'),
(1105, 10, 'WLE 101', 1, 0, '0'),
(1106, 10, 'WLE 101', 1, 1, '0'),
(1107, 10, 'WLE 101', 1, 2, '0'),
(1108, 10, 'WLE 101', 1, 3, '0'),
(1109, 10, 'WLE 101', 1, 4, '0'),
(1110, 10, 'WLE 101', 1, 5, '0'),
(1111, 10, 'WLE 101', 1, 6, '0'),
(1112, 10, 'WLE 101', 1, 7, '0'),
(1113, 10, 'WLE 101', 1, 8, '0'),
(1114, 10, 'WLE 101', 1, 9, '0'),
(1115, 10, 'WLE 101', 1, 10, '0'),
(1116, 10, 'WLE 101', 1, 11, '0'),
(1117, 10, 'WLE 101', 1, 12, '0'),
(1118, 10, 'WLE 101', 1, 13, '0'),
(1119, 10, 'WLE 101', 1, 14, '0'),
(1120, 10, 'WLE 101', 1, 15, '0'),
(1121, 10, 'WLE 101', 1, 16, '0'),
(1122, 10, 'WLE 101', 1, 17, '0'),
(1123, 10, 'WLE 101', 1, 18, '0'),
(1124, 10, 'WLE 101', 1, 19, '0'),
(1125, 10, 'WLE 101', 1, 20, '0'),
(1126, 10, 'WLE 101', 1, 21, '0'),
(1127, 10, 'WLE 101', 1, 22, '0'),
(1128, 10, 'WLE 101', 1, 23, '0'),
(1129, 10, 'WLE 101', 1, 24, '0'),
(1130, 10, 'WLE 101', 1, 25, '0'),
(1131, 10, 'WLE 101', 1, 26, '0'),
(1132, 10, 'WLE 101', 2, 0, '0'),
(1133, 10, 'WLE 101', 2, 1, '0'),
(1134, 10, 'WLE 101', 2, 2, '0'),
(1135, 10, 'WLE 101', 2, 3, '0'),
(1136, 10, 'WLE 101', 2, 4, '0'),
(1137, 10, 'WLE 101', 2, 5, '0'),
(1138, 10, 'WLE 101', 2, 6, '0'),
(1139, 10, 'WLE 101', 2, 7, '0'),
(1140, 10, 'WLE 101', 2, 8, '0'),
(1141, 10, 'WLE 101', 2, 9, '0'),
(1142, 10, 'WLE 101', 2, 10, '0'),
(1143, 10, 'WLE 101', 2, 11, '0'),
(1144, 10, 'WLE 101', 2, 12, '0'),
(1145, 10, 'WLE 101', 2, 13, '0'),
(1146, 10, 'WLE 101', 2, 14, '0'),
(1147, 10, 'WLE 101', 2, 15, '0'),
(1148, 10, 'WLE 101', 2, 16, '0'),
(1149, 10, 'WLE 101', 2, 17, '0'),
(1150, 10, 'WLE 101', 2, 18, '0'),
(1151, 10, 'WLE 101', 2, 19, '0'),
(1152, 10, 'WLE 101', 2, 20, '0'),
(1153, 10, 'WLE 101', 2, 21, '0'),
(1154, 10, 'WLE 101', 2, 22, '0'),
(1155, 10, 'WLE 101', 2, 23, '0'),
(1156, 10, 'WLE 101', 2, 24, '0'),
(1157, 10, 'WLE 101', 2, 25, '0'),
(1158, 10, 'WLE 101', 2, 26, '0'),
(1159, 10, 'WLE 101', 3, 0, '0'),
(1160, 10, 'WLE 101', 3, 1, '0'),
(1161, 10, 'WLE 101', 3, 2, '0'),
(1162, 10, 'WLE 101', 3, 3, '0'),
(1163, 10, 'WLE 101', 3, 4, '0'),
(1164, 10, 'WLE 101', 3, 5, '0'),
(1165, 10, 'WLE 101', 3, 6, '0'),
(1166, 10, 'WLE 101', 3, 7, '0'),
(1167, 10, 'WLE 101', 3, 8, '0'),
(1168, 10, 'WLE 101', 3, 9, '0'),
(1169, 10, 'WLE 101', 3, 10, '0'),
(1170, 10, 'WLE 101', 3, 11, '0'),
(1171, 10, 'WLE 101', 3, 12, '0'),
(1172, 10, 'WLE 101', 3, 13, '0'),
(1173, 10, 'WLE 101', 3, 14, '0'),
(1174, 10, 'WLE 101', 3, 15, '0'),
(1175, 10, 'WLE 101', 3, 16, '0'),
(1176, 10, 'WLE 101', 3, 17, '0'),
(1177, 10, 'WLE 101', 3, 18, '0'),
(1178, 10, 'WLE 101', 3, 19, '0'),
(1179, 10, 'WLE 101', 3, 20, '0'),
(1180, 10, 'WLE 101', 3, 21, '0'),
(1181, 10, 'WLE 101', 3, 22, '0'),
(1182, 10, 'WLE 101', 3, 23, '0'),
(1183, 10, 'WLE 101', 3, 24, '0'),
(1184, 10, 'WLE 101', 3, 25, '0'),
(1185, 10, 'WLE 101', 3, 26, '0'),
(1186, 10, 'WLE 101', 4, 0, '0'),
(1187, 10, 'WLE 101', 4, 1, '0'),
(1188, 10, 'WLE 101', 4, 2, '0'),
(1189, 10, 'WLE 101', 4, 3, '0'),
(1190, 10, 'WLE 101', 4, 4, '0'),
(1191, 10, 'WLE 101', 4, 5, '0'),
(1192, 10, 'WLE 101', 4, 6, '0'),
(1193, 10, 'WLE 101', 4, 7, '0'),
(1194, 10, 'WLE 101', 4, 8, '0'),
(1195, 10, 'WLE 101', 4, 9, '0'),
(1196, 10, 'WLE 101', 4, 10, '0'),
(1197, 10, 'WLE 101', 4, 11, '0'),
(1198, 10, 'WLE 101', 4, 12, '0'),
(1199, 10, 'WLE 101', 4, 13, '0'),
(1200, 10, 'WLE 101', 4, 14, '0'),
(1201, 10, 'WLE 101', 4, 15, '0'),
(1202, 10, 'WLE 101', 4, 16, '0'),
(1203, 10, 'WLE 101', 4, 17, '0'),
(1204, 10, 'WLE 101', 4, 18, '0'),
(1205, 10, 'WLE 101', 4, 19, '0'),
(1206, 10, 'WLE 101', 4, 20, '0'),
(1207, 10, 'WLE 101', 4, 21, '0'),
(1208, 10, 'WLE 101', 4, 22, '0'),
(1209, 10, 'WLE 101', 4, 23, '0'),
(1210, 10, 'WLE 101', 4, 24, '0'),
(1211, 10, 'WLE 101', 4, 25, '0'),
(1212, 10, 'WLE 101', 4, 26, '0'),
(1888, 16, 'ComLab 1', 0, 0, '0'),
(1889, 16, 'ComLab 1', 0, 1, '0'),
(1890, 16, 'ComLab 1', 0, 2, '0'),
(1891, 16, 'ComLab 1', 0, 3, '0'),
(1892, 16, 'ComLab 1', 0, 4, '0'),
(1893, 16, 'ComLab 1', 0, 5, '0'),
(1894, 16, 'ComLab 1', 0, 6, '0'),
(1895, 16, 'ComLab 1', 0, 7, '0'),
(1896, 16, 'ComLab 1', 0, 8, '0'),
(1897, 16, 'ComLab 1', 0, 9, '0'),
(1898, 16, 'ComLab 1', 0, 10, '0'),
(1899, 16, 'ComLab 1', 0, 11, '0'),
(1900, 16, 'ComLab 1', 0, 12, '0'),
(1901, 16, 'ComLab 1', 0, 13, '0'),
(1902, 16, 'ComLab 1', 0, 14, '0'),
(1903, 16, 'ComLab 1', 0, 15, '0'),
(1904, 16, 'ComLab 1', 0, 16, '0'),
(1905, 16, 'ComLab 1', 0, 17, '0'),
(1906, 16, 'ComLab 1', 0, 18, '0'),
(1907, 16, 'ComLab 1', 0, 19, '0'),
(1908, 16, 'ComLab 1', 0, 20, '0'),
(1909, 16, 'ComLab 1', 0, 21, '0'),
(1910, 16, 'ComLab 1', 0, 22, '0'),
(1911, 16, 'ComLab 1', 0, 23, '0'),
(1912, 16, 'ComLab 1', 0, 24, '0'),
(1913, 16, 'ComLab 1', 0, 25, '0'),
(1914, 16, 'ComLab 1', 0, 26, '0'),
(1915, 16, 'ComLab 1', 1, 0, '0'),
(1916, 16, 'ComLab 1', 1, 1, '0'),
(1917, 16, 'ComLab 1', 1, 2, '0'),
(1918, 16, 'ComLab 1', 1, 3, '0'),
(1919, 16, 'ComLab 1', 1, 4, '0'),
(1920, 16, 'ComLab 1', 1, 5, '0'),
(1921, 16, 'ComLab 1', 1, 6, '0'),
(1922, 16, 'ComLab 1', 1, 7, '0'),
(1923, 16, 'ComLab 1', 1, 8, '0'),
(1924, 16, 'ComLab 1', 1, 9, '0'),
(1925, 16, 'ComLab 1', 1, 10, '0'),
(1926, 16, 'ComLab 1', 1, 11, '0'),
(1927, 16, 'ComLab 1', 1, 12, '0'),
(1928, 16, 'ComLab 1', 1, 13, '0'),
(1929, 16, 'ComLab 1', 1, 14, '0'),
(1930, 16, 'ComLab 1', 1, 15, '0'),
(1931, 16, 'ComLab 1', 1, 16, '0'),
(1932, 16, 'ComLab 1', 1, 17, '0'),
(1933, 16, 'ComLab 1', 1, 18, '0'),
(1934, 16, 'ComLab 1', 1, 19, '0'),
(1935, 16, 'ComLab 1', 1, 20, '0'),
(1936, 16, 'ComLab 1', 1, 21, '0'),
(1937, 16, 'ComLab 1', 1, 22, '0'),
(1938, 16, 'ComLab 1', 1, 23, '0'),
(1939, 16, 'ComLab 1', 1, 24, '0'),
(1940, 16, 'ComLab 1', 1, 25, '0'),
(1941, 16, 'ComLab 1', 1, 26, '0'),
(1942, 16, 'ComLab 1', 2, 0, '0'),
(1943, 16, 'ComLab 1', 2, 1, '0'),
(1944, 16, 'ComLab 1', 2, 2, '0'),
(1945, 16, 'ComLab 1', 2, 3, '0'),
(1946, 16, 'ComLab 1', 2, 4, '0'),
(1947, 16, 'ComLab 1', 2, 5, '0'),
(1948, 16, 'ComLab 1', 2, 6, '0'),
(1949, 16, 'ComLab 1', 2, 7, '0'),
(1950, 16, 'ComLab 1', 2, 8, '0'),
(1951, 16, 'ComLab 1', 2, 9, '0'),
(1952, 16, 'ComLab 1', 2, 10, '0'),
(1953, 16, 'ComLab 1', 2, 11, '0'),
(1954, 16, 'ComLab 1', 2, 12, '0'),
(1955, 16, 'ComLab 1', 2, 13, '0'),
(1956, 16, 'ComLab 1', 2, 14, '0'),
(1957, 16, 'ComLab 1', 2, 15, '0'),
(1958, 16, 'ComLab 1', 2, 16, '0'),
(1959, 16, 'ComLab 1', 2, 17, '0'),
(1960, 16, 'ComLab 1', 2, 18, '0'),
(1961, 16, 'ComLab 1', 2, 19, '0'),
(1962, 16, 'ComLab 1', 2, 20, '0'),
(1963, 16, 'ComLab 1', 2, 21, '0'),
(1964, 16, 'ComLab 1', 2, 22, '0'),
(1965, 16, 'ComLab 1', 2, 23, '0'),
(1966, 16, 'ComLab 1', 2, 24, '0'),
(1967, 16, 'ComLab 1', 2, 25, '0'),
(1968, 16, 'ComLab 1', 2, 26, '0'),
(1969, 16, 'ComLab 1', 3, 0, '0'),
(1970, 16, 'ComLab 1', 3, 1, '0'),
(1971, 16, 'ComLab 1', 3, 2, '0'),
(1972, 16, 'ComLab 1', 3, 3, '0'),
(1973, 16, 'ComLab 1', 3, 4, '0'),
(1974, 16, 'ComLab 1', 3, 5, '0'),
(1975, 16, 'ComLab 1', 3, 6, '0'),
(1976, 16, 'ComLab 1', 3, 7, '0'),
(1977, 16, 'ComLab 1', 3, 8, '0'),
(1978, 16, 'ComLab 1', 3, 9, '0'),
(1979, 16, 'ComLab 1', 3, 10, '0'),
(1980, 16, 'ComLab 1', 3, 11, '0'),
(1981, 16, 'ComLab 1', 3, 12, '0'),
(1982, 16, 'ComLab 1', 3, 13, '0'),
(1983, 16, 'ComLab 1', 3, 14, '0'),
(1984, 16, 'ComLab 1', 3, 15, '0'),
(1985, 16, 'ComLab 1', 3, 16, '0'),
(1986, 16, 'ComLab 1', 3, 17, '0'),
(1987, 16, 'ComLab 1', 3, 18, '0'),
(1988, 16, 'ComLab 1', 3, 19, '0'),
(1989, 16, 'ComLab 1', 3, 20, '0'),
(1990, 16, 'ComLab 1', 3, 21, '0'),
(1991, 16, 'ComLab 1', 3, 22, '0'),
(1992, 16, 'ComLab 1', 3, 23, '0'),
(1993, 16, 'ComLab 1', 3, 24, '0'),
(1994, 16, 'ComLab 1', 3, 25, '0'),
(1995, 16, 'ComLab 1', 3, 26, '0'),
(1996, 16, 'ComLab 1', 4, 0, '0'),
(1997, 16, 'ComLab 1', 4, 1, '0'),
(1998, 16, 'ComLab 1', 4, 2, '0'),
(1999, 16, 'ComLab 1', 4, 3, '0'),
(2000, 16, 'ComLab 1', 4, 4, '0'),
(2001, 16, 'ComLab 1', 4, 5, '0'),
(2002, 16, 'ComLab 1', 4, 6, '0'),
(2003, 16, 'ComLab 1', 4, 7, '0'),
(2004, 16, 'ComLab 1', 4, 8, '0'),
(2005, 16, 'ComLab 1', 4, 9, '0'),
(2006, 16, 'ComLab 1', 4, 10, '0'),
(2007, 16, 'ComLab 1', 4, 11, '0'),
(2008, 16, 'ComLab 1', 4, 12, '0'),
(2009, 16, 'ComLab 1', 4, 13, '0'),
(2010, 16, 'ComLab 1', 4, 14, '0'),
(2011, 16, 'ComLab 1', 4, 15, '0'),
(2012, 16, 'ComLab 1', 4, 16, '0'),
(2013, 16, 'ComLab 1', 4, 17, '0'),
(2014, 16, 'ComLab 1', 4, 18, '0'),
(2015, 16, 'ComLab 1', 4, 19, '0'),
(2016, 16, 'ComLab 1', 4, 20, '0'),
(2017, 16, 'ComLab 1', 4, 21, '0'),
(2018, 16, 'ComLab 1', 4, 22, '0'),
(2019, 16, 'ComLab 1', 4, 23, '0'),
(2020, 16, 'ComLab 1', 4, 24, '0'),
(2021, 16, 'ComLab 1', 4, 25, '0'),
(2022, 16, 'ComLab 1', 4, 26, '0'),
(2023, 17, 'ComLab 2', 0, 0, '0'),
(2024, 17, 'ComLab 2', 0, 1, '0'),
(2025, 17, 'ComLab 2', 0, 2, '0'),
(2026, 17, 'ComLab 2', 0, 3, '0'),
(2027, 17, 'ComLab 2', 0, 4, '0'),
(2028, 17, 'ComLab 2', 0, 5, '0'),
(2029, 17, 'ComLab 2', 0, 6, '0'),
(2030, 17, 'ComLab 2', 0, 7, '0'),
(2031, 17, 'ComLab 2', 0, 8, '0'),
(2032, 17, 'ComLab 2', 0, 9, '0'),
(2033, 17, 'ComLab 2', 0, 10, '0'),
(2034, 17, 'ComLab 2', 0, 11, '0'),
(2035, 17, 'ComLab 2', 0, 12, '0'),
(2036, 17, 'ComLab 2', 0, 13, '0'),
(2037, 17, 'ComLab 2', 0, 14, '0'),
(2038, 17, 'ComLab 2', 0, 15, '0'),
(2039, 17, 'ComLab 2', 0, 16, '0'),
(2040, 17, 'ComLab 2', 0, 17, '0'),
(2041, 17, 'ComLab 2', 0, 18, '0'),
(2042, 17, 'ComLab 2', 0, 19, '0'),
(2043, 17, 'ComLab 2', 0, 20, '0'),
(2044, 17, 'ComLab 2', 0, 21, '0'),
(2045, 17, 'ComLab 2', 0, 22, '0'),
(2046, 17, 'ComLab 2', 0, 23, '0'),
(2047, 17, 'ComLab 2', 0, 24, '0'),
(2048, 17, 'ComLab 2', 0, 25, '0'),
(2049, 17, 'ComLab 2', 0, 26, '0'),
(2050, 17, 'ComLab 2', 1, 0, '0'),
(2051, 17, 'ComLab 2', 1, 1, '0'),
(2052, 17, 'ComLab 2', 1, 2, '0'),
(2053, 17, 'ComLab 2', 1, 3, '0'),
(2054, 17, 'ComLab 2', 1, 4, '0'),
(2055, 17, 'ComLab 2', 1, 5, '0'),
(2056, 17, 'ComLab 2', 1, 6, '0'),
(2057, 17, 'ComLab 2', 1, 7, '0'),
(2058, 17, 'ComLab 2', 1, 8, '0'),
(2059, 17, 'ComLab 2', 1, 9, '0'),
(2060, 17, 'ComLab 2', 1, 10, '0'),
(2061, 17, 'ComLab 2', 1, 11, '0'),
(2062, 17, 'ComLab 2', 1, 12, '0'),
(2063, 17, 'ComLab 2', 1, 13, '0'),
(2064, 17, 'ComLab 2', 1, 14, '0'),
(2065, 17, 'ComLab 2', 1, 15, '0'),
(2066, 17, 'ComLab 2', 1, 16, '0'),
(2067, 17, 'ComLab 2', 1, 17, '0'),
(2068, 17, 'ComLab 2', 1, 18, '0'),
(2069, 17, 'ComLab 2', 1, 19, '0'),
(2070, 17, 'ComLab 2', 1, 20, '0'),
(2071, 17, 'ComLab 2', 1, 21, '0'),
(2072, 17, 'ComLab 2', 1, 22, '0'),
(2073, 17, 'ComLab 2', 1, 23, '0'),
(2074, 17, 'ComLab 2', 1, 24, '0'),
(2075, 17, 'ComLab 2', 1, 25, '0'),
(2076, 17, 'ComLab 2', 1, 26, '0'),
(2077, 17, 'ComLab 2', 2, 0, '0'),
(2078, 17, 'ComLab 2', 2, 1, '0'),
(2079, 17, 'ComLab 2', 2, 2, '0'),
(2080, 17, 'ComLab 2', 2, 3, '0'),
(2081, 17, 'ComLab 2', 2, 4, '0'),
(2082, 17, 'ComLab 2', 2, 5, '0'),
(2083, 17, 'ComLab 2', 2, 6, '0'),
(2084, 17, 'ComLab 2', 2, 7, '0'),
(2085, 17, 'ComLab 2', 2, 8, '0'),
(2086, 17, 'ComLab 2', 2, 9, '0'),
(2087, 17, 'ComLab 2', 2, 10, '0'),
(2088, 17, 'ComLab 2', 2, 11, '0'),
(2089, 17, 'ComLab 2', 2, 12, '0'),
(2090, 17, 'ComLab 2', 2, 13, '0'),
(2091, 17, 'ComLab 2', 2, 14, '0'),
(2092, 17, 'ComLab 2', 2, 15, '0'),
(2093, 17, 'ComLab 2', 2, 16, '0'),
(2094, 17, 'ComLab 2', 2, 17, '0'),
(2095, 17, 'ComLab 2', 2, 18, '0'),
(2096, 17, 'ComLab 2', 2, 19, '0'),
(2097, 17, 'ComLab 2', 2, 20, '0'),
(2098, 17, 'ComLab 2', 2, 21, '0'),
(2099, 17, 'ComLab 2', 2, 22, '0'),
(2100, 17, 'ComLab 2', 2, 23, '0'),
(2101, 17, 'ComLab 2', 2, 24, '0'),
(2102, 17, 'ComLab 2', 2, 25, '0'),
(2103, 17, 'ComLab 2', 2, 26, '0'),
(2104, 17, 'ComLab 2', 3, 0, '0'),
(2105, 17, 'ComLab 2', 3, 1, '0'),
(2106, 17, 'ComLab 2', 3, 2, '0'),
(2107, 17, 'ComLab 2', 3, 3, '0'),
(2108, 17, 'ComLab 2', 3, 4, '0'),
(2109, 17, 'ComLab 2', 3, 5, '0'),
(2110, 17, 'ComLab 2', 3, 6, '0'),
(2111, 17, 'ComLab 2', 3, 7, '0'),
(2112, 17, 'ComLab 2', 3, 8, '0'),
(2113, 17, 'ComLab 2', 3, 9, '0'),
(2114, 17, 'ComLab 2', 3, 10, '0'),
(2115, 17, 'ComLab 2', 3, 11, '0'),
(2116, 17, 'ComLab 2', 3, 12, '0'),
(2117, 17, 'ComLab 2', 3, 13, '0'),
(2118, 17, 'ComLab 2', 3, 14, '0'),
(2119, 17, 'ComLab 2', 3, 15, '0'),
(2120, 17, 'ComLab 2', 3, 16, '0'),
(2121, 17, 'ComLab 2', 3, 17, '0'),
(2122, 17, 'ComLab 2', 3, 18, '0'),
(2123, 17, 'ComLab 2', 3, 19, '0'),
(2124, 17, 'ComLab 2', 3, 20, '0'),
(2125, 17, 'ComLab 2', 3, 21, '0'),
(2126, 17, 'ComLab 2', 3, 22, '0'),
(2127, 17, 'ComLab 2', 3, 23, '0'),
(2128, 17, 'ComLab 2', 3, 24, '0'),
(2129, 17, 'ComLab 2', 3, 25, '0'),
(2130, 17, 'ComLab 2', 3, 26, '0'),
(2131, 17, 'ComLab 2', 4, 0, '0'),
(2132, 17, 'ComLab 2', 4, 1, '0'),
(2133, 17, 'ComLab 2', 4, 2, '0'),
(2134, 17, 'ComLab 2', 4, 3, '0'),
(2135, 17, 'ComLab 2', 4, 4, '0'),
(2136, 17, 'ComLab 2', 4, 5, '0'),
(2137, 17, 'ComLab 2', 4, 6, '0'),
(2138, 17, 'ComLab 2', 4, 7, '0'),
(2139, 17, 'ComLab 2', 4, 8, '0'),
(2140, 17, 'ComLab 2', 4, 9, '0'),
(2141, 17, 'ComLab 2', 4, 10, '0'),
(2142, 17, 'ComLab 2', 4, 11, '0'),
(2143, 17, 'ComLab 2', 4, 12, '0'),
(2144, 17, 'ComLab 2', 4, 13, '0'),
(2145, 17, 'ComLab 2', 4, 14, '0'),
(2146, 17, 'ComLab 2', 4, 15, '0'),
(2147, 17, 'ComLab 2', 4, 16, '0'),
(2148, 17, 'ComLab 2', 4, 17, '0'),
(2149, 17, 'ComLab 2', 4, 18, '0'),
(2150, 17, 'ComLab 2', 4, 19, '0'),
(2151, 17, 'ComLab 2', 4, 20, '0'),
(2152, 17, 'ComLab 2', 4, 21, '0'),
(2153, 17, 'ComLab 2', 4, 22, '0'),
(2154, 17, 'ComLab 2', 4, 23, '0'),
(2155, 17, 'ComLab 2', 4, 24, '0'),
(2156, 17, 'ComLab 2', 4, 25, '0'),
(2157, 17, 'ComLab 2', 4, 26, '0'),
(2158, 18, 'ComLab 3', 0, 0, '0'),
(2159, 18, 'ComLab 3', 0, 1, '0'),
(2160, 18, 'ComLab 3', 0, 2, '0'),
(2161, 18, 'ComLab 3', 0, 3, '0'),
(2162, 18, 'ComLab 3', 0, 4, '0'),
(2163, 18, 'ComLab 3', 0, 5, '0'),
(2164, 18, 'ComLab 3', 0, 6, '0'),
(2165, 18, 'ComLab 3', 0, 7, '0'),
(2166, 18, 'ComLab 3', 0, 8, '0'),
(2167, 18, 'ComLab 3', 0, 9, '0'),
(2168, 18, 'ComLab 3', 0, 10, '0'),
(2169, 18, 'ComLab 3', 0, 11, '0'),
(2170, 18, 'ComLab 3', 0, 12, '0'),
(2171, 18, 'ComLab 3', 0, 13, '0'),
(2172, 18, 'ComLab 3', 0, 14, '0'),
(2173, 18, 'ComLab 3', 0, 15, '0'),
(2174, 18, 'ComLab 3', 0, 16, '0'),
(2175, 18, 'ComLab 3', 0, 17, '0'),
(2176, 18, 'ComLab 3', 0, 18, '0'),
(2177, 18, 'ComLab 3', 0, 19, '0'),
(2178, 18, 'ComLab 3', 0, 20, '0'),
(2179, 18, 'ComLab 3', 0, 21, '0'),
(2180, 18, 'ComLab 3', 0, 22, '0'),
(2181, 18, 'ComLab 3', 0, 23, '0'),
(2182, 18, 'ComLab 3', 0, 24, '0'),
(2183, 18, 'ComLab 3', 0, 25, '0'),
(2184, 18, 'ComLab 3', 0, 26, '0'),
(2185, 18, 'ComLab 3', 1, 0, '0'),
(2186, 18, 'ComLab 3', 1, 1, '0'),
(2187, 18, 'ComLab 3', 1, 2, '0'),
(2188, 18, 'ComLab 3', 1, 3, '0'),
(2189, 18, 'ComLab 3', 1, 4, '0'),
(2190, 18, 'ComLab 3', 1, 5, '0'),
(2191, 18, 'ComLab 3', 1, 6, '0'),
(2192, 18, 'ComLab 3', 1, 7, '0'),
(2193, 18, 'ComLab 3', 1, 8, '0'),
(2194, 18, 'ComLab 3', 1, 9, '0'),
(2195, 18, 'ComLab 3', 1, 10, '0'),
(2196, 18, 'ComLab 3', 1, 11, '0'),
(2197, 18, 'ComLab 3', 1, 12, '0'),
(2198, 18, 'ComLab 3', 1, 13, '0'),
(2199, 18, 'ComLab 3', 1, 14, '0'),
(2200, 18, 'ComLab 3', 1, 15, '0'),
(2201, 18, 'ComLab 3', 1, 16, '0'),
(2202, 18, 'ComLab 3', 1, 17, '0'),
(2203, 18, 'ComLab 3', 1, 18, '0'),
(2204, 18, 'ComLab 3', 1, 19, '0'),
(2205, 18, 'ComLab 3', 1, 20, '0'),
(2206, 18, 'ComLab 3', 1, 21, '0'),
(2207, 18, 'ComLab 3', 1, 22, '0'),
(2208, 18, 'ComLab 3', 1, 23, '0'),
(2209, 18, 'ComLab 3', 1, 24, '0'),
(2210, 18, 'ComLab 3', 1, 25, '0'),
(2211, 18, 'ComLab 3', 1, 26, '0'),
(2212, 18, 'ComLab 3', 2, 0, '0'),
(2213, 18, 'ComLab 3', 2, 1, '0'),
(2214, 18, 'ComLab 3', 2, 2, '0'),
(2215, 18, 'ComLab 3', 2, 3, '0'),
(2216, 18, 'ComLab 3', 2, 4, '0'),
(2217, 18, 'ComLab 3', 2, 5, '0'),
(2218, 18, 'ComLab 3', 2, 6, '0'),
(2219, 18, 'ComLab 3', 2, 7, '0'),
(2220, 18, 'ComLab 3', 2, 8, '0'),
(2221, 18, 'ComLab 3', 2, 9, '0'),
(2222, 18, 'ComLab 3', 2, 10, '0'),
(2223, 18, 'ComLab 3', 2, 11, '0'),
(2224, 18, 'ComLab 3', 2, 12, '0'),
(2225, 18, 'ComLab 3', 2, 13, '0'),
(2226, 18, 'ComLab 3', 2, 14, '0'),
(2227, 18, 'ComLab 3', 2, 15, '0'),
(2228, 18, 'ComLab 3', 2, 16, '0'),
(2229, 18, 'ComLab 3', 2, 17, '0'),
(2230, 18, 'ComLab 3', 2, 18, '0'),
(2231, 18, 'ComLab 3', 2, 19, '0'),
(2232, 18, 'ComLab 3', 2, 20, '0'),
(2233, 18, 'ComLab 3', 2, 21, '0'),
(2234, 18, 'ComLab 3', 2, 22, '0'),
(2235, 18, 'ComLab 3', 2, 23, '0'),
(2236, 18, 'ComLab 3', 2, 24, '0'),
(2237, 18, 'ComLab 3', 2, 25, '0'),
(2238, 18, 'ComLab 3', 2, 26, '0'),
(2239, 18, 'ComLab 3', 3, 0, '0'),
(2240, 18, 'ComLab 3', 3, 1, '0'),
(2241, 18, 'ComLab 3', 3, 2, '0'),
(2242, 18, 'ComLab 3', 3, 3, '0'),
(2243, 18, 'ComLab 3', 3, 4, '0'),
(2244, 18, 'ComLab 3', 3, 5, '0'),
(2245, 18, 'ComLab 3', 3, 6, '0'),
(2246, 18, 'ComLab 3', 3, 7, '0'),
(2247, 18, 'ComLab 3', 3, 8, '0'),
(2248, 18, 'ComLab 3', 3, 9, '0'),
(2249, 18, 'ComLab 3', 3, 10, '0'),
(2250, 18, 'ComLab 3', 3, 11, '0'),
(2251, 18, 'ComLab 3', 3, 12, '0'),
(2252, 18, 'ComLab 3', 3, 13, '0'),
(2253, 18, 'ComLab 3', 3, 14, '0'),
(2254, 18, 'ComLab 3', 3, 15, '0'),
(2255, 18, 'ComLab 3', 3, 16, '0'),
(2256, 18, 'ComLab 3', 3, 17, '0'),
(2257, 18, 'ComLab 3', 3, 18, '0'),
(2258, 18, 'ComLab 3', 3, 19, '0'),
(2259, 18, 'ComLab 3', 3, 20, '0'),
(2260, 18, 'ComLab 3', 3, 21, '0'),
(2261, 18, 'ComLab 3', 3, 22, '0'),
(2262, 18, 'ComLab 3', 3, 23, '0'),
(2263, 18, 'ComLab 3', 3, 24, '0'),
(2264, 18, 'ComLab 3', 3, 25, '0'),
(2265, 18, 'ComLab 3', 3, 26, '0'),
(2266, 18, 'ComLab 3', 4, 0, '0'),
(2267, 18, 'ComLab 3', 4, 1, '0'),
(2268, 18, 'ComLab 3', 4, 2, '0'),
(2269, 18, 'ComLab 3', 4, 3, '0'),
(2270, 18, 'ComLab 3', 4, 4, '0'),
(2271, 18, 'ComLab 3', 4, 5, '0'),
(2272, 18, 'ComLab 3', 4, 6, '0'),
(2273, 18, 'ComLab 3', 4, 7, '0'),
(2274, 18, 'ComLab 3', 4, 8, '0'),
(2275, 18, 'ComLab 3', 4, 9, '0'),
(2276, 18, 'ComLab 3', 4, 10, '0'),
(2277, 18, 'ComLab 3', 4, 11, '0'),
(2278, 18, 'ComLab 3', 4, 12, '0'),
(2279, 18, 'ComLab 3', 4, 13, '0'),
(2280, 18, 'ComLab 3', 4, 14, '0'),
(2281, 18, 'ComLab 3', 4, 15, '0'),
(2282, 18, 'ComLab 3', 4, 16, '0'),
(2283, 18, 'ComLab 3', 4, 17, '0'),
(2284, 18, 'ComLab 3', 4, 18, '0'),
(2285, 18, 'ComLab 3', 4, 19, '0'),
(2286, 18, 'ComLab 3', 4, 20, '0'),
(2287, 18, 'ComLab 3', 4, 21, '0'),
(2288, 18, 'ComLab 3', 4, 22, '0'),
(2289, 18, 'ComLab 3', 4, 23, '0'),
(2290, 18, 'ComLab 3', 4, 24, '0'),
(2291, 18, 'ComLab 3', 4, 25, '0'),
(2292, 18, 'ComLab 3', 4, 26, '0'),
(2293, 19, 'GYM', 0, 0, '0'),
(2294, 19, 'GYM', 0, 1, '0'),
(2295, 19, 'GYM', 0, 2, '0'),
(2296, 19, 'GYM', 0, 3, '0'),
(2297, 19, 'GYM', 0, 4, '0'),
(2298, 19, 'GYM', 0, 5, '0'),
(2299, 19, 'GYM', 0, 6, '0'),
(2300, 19, 'GYM', 0, 7, '0'),
(2301, 19, 'GYM', 0, 8, '0'),
(2302, 19, 'GYM', 0, 9, '0'),
(2303, 19, 'GYM', 0, 10, '0'),
(2304, 19, 'GYM', 0, 11, '0'),
(2305, 19, 'GYM', 0, 12, '0'),
(2306, 19, 'GYM', 0, 13, '0'),
(2307, 19, 'GYM', 0, 14, '0'),
(2308, 19, 'GYM', 0, 15, '0'),
(2309, 19, 'GYM', 0, 16, '0'),
(2310, 19, 'GYM', 0, 17, '0'),
(2311, 19, 'GYM', 0, 18, '0'),
(2312, 19, 'GYM', 0, 19, '0'),
(2313, 19, 'GYM', 0, 20, '0'),
(2314, 19, 'GYM', 0, 21, '0'),
(2315, 19, 'GYM', 0, 22, '0'),
(2316, 19, 'GYM', 0, 23, '0'),
(2317, 19, 'GYM', 0, 24, '0'),
(2318, 19, 'GYM', 0, 25, '0'),
(2319, 19, 'GYM', 0, 26, '0'),
(2320, 19, 'GYM', 1, 0, '0'),
(2321, 19, 'GYM', 1, 1, '0'),
(2322, 19, 'GYM', 1, 2, '0'),
(2323, 19, 'GYM', 1, 3, '0'),
(2324, 19, 'GYM', 1, 4, '0'),
(2325, 19, 'GYM', 1, 5, '0'),
(2326, 19, 'GYM', 1, 6, '0'),
(2327, 19, 'GYM', 1, 7, '0'),
(2328, 19, 'GYM', 1, 8, '0'),
(2329, 19, 'GYM', 1, 9, '0'),
(2330, 19, 'GYM', 1, 10, '0'),
(2331, 19, 'GYM', 1, 11, '0'),
(2332, 19, 'GYM', 1, 12, '0'),
(2333, 19, 'GYM', 1, 13, '0'),
(2334, 19, 'GYM', 1, 14, '0'),
(2335, 19, 'GYM', 1, 15, '0'),
(2336, 19, 'GYM', 1, 16, '0'),
(2337, 19, 'GYM', 1, 17, '0'),
(2338, 19, 'GYM', 1, 18, '0'),
(2339, 19, 'GYM', 1, 19, '0'),
(2340, 19, 'GYM', 1, 20, '0'),
(2341, 19, 'GYM', 1, 21, '0'),
(2342, 19, 'GYM', 1, 22, '0'),
(2343, 19, 'GYM', 1, 23, '0'),
(2344, 19, 'GYM', 1, 24, '0'),
(2345, 19, 'GYM', 1, 25, '0'),
(2346, 19, 'GYM', 1, 26, '0'),
(2347, 19, 'GYM', 2, 0, '0'),
(2348, 19, 'GYM', 2, 1, '0'),
(2349, 19, 'GYM', 2, 2, '0'),
(2350, 19, 'GYM', 2, 3, '0'),
(2351, 19, 'GYM', 2, 4, '0'),
(2352, 19, 'GYM', 2, 5, '0'),
(2353, 19, 'GYM', 2, 6, '0'),
(2354, 19, 'GYM', 2, 7, '0'),
(2355, 19, 'GYM', 2, 8, '0'),
(2356, 19, 'GYM', 2, 9, '0'),
(2357, 19, 'GYM', 2, 10, '0'),
(2358, 19, 'GYM', 2, 11, '0'),
(2359, 19, 'GYM', 2, 12, '0'),
(2360, 19, 'GYM', 2, 13, '0'),
(2361, 19, 'GYM', 2, 14, '0'),
(2362, 19, 'GYM', 2, 15, '0'),
(2363, 19, 'GYM', 2, 16, '0'),
(2364, 19, 'GYM', 2, 17, '0'),
(2365, 19, 'GYM', 2, 18, '0'),
(2366, 19, 'GYM', 2, 19, '0'),
(2367, 19, 'GYM', 2, 20, '0'),
(2368, 19, 'GYM', 2, 21, '0'),
(2369, 19, 'GYM', 2, 22, '0'),
(2370, 19, 'GYM', 2, 23, '0'),
(2371, 19, 'GYM', 2, 24, '0'),
(2372, 19, 'GYM', 2, 25, '0'),
(2373, 19, 'GYM', 2, 26, '0'),
(2374, 19, 'GYM', 3, 0, '0'),
(2375, 19, 'GYM', 3, 1, '0'),
(2376, 19, 'GYM', 3, 2, '0'),
(2377, 19, 'GYM', 3, 3, '0'),
(2378, 19, 'GYM', 3, 4, '0'),
(2379, 19, 'GYM', 3, 5, '0'),
(2380, 19, 'GYM', 3, 6, '0'),
(2381, 19, 'GYM', 3, 7, '0'),
(2382, 19, 'GYM', 3, 8, '0'),
(2383, 19, 'GYM', 3, 9, '0'),
(2384, 19, 'GYM', 3, 10, '0'),
(2385, 19, 'GYM', 3, 11, '0'),
(2386, 19, 'GYM', 3, 12, '0'),
(2387, 19, 'GYM', 3, 13, '0'),
(2388, 19, 'GYM', 3, 14, '0'),
(2389, 19, 'GYM', 3, 15, '0'),
(2390, 19, 'GYM', 3, 16, '0'),
(2391, 19, 'GYM', 3, 17, '0'),
(2392, 19, 'GYM', 3, 18, '0'),
(2393, 19, 'GYM', 3, 19, '0'),
(2394, 19, 'GYM', 3, 20, '0'),
(2395, 19, 'GYM', 3, 21, '0'),
(2396, 19, 'GYM', 3, 22, '0'),
(2397, 19, 'GYM', 3, 23, '0'),
(2398, 19, 'GYM', 3, 24, '0'),
(2399, 19, 'GYM', 3, 25, '0'),
(2400, 19, 'GYM', 3, 26, '0'),
(2401, 19, 'GYM', 4, 0, '0'),
(2402, 19, 'GYM', 4, 1, '0'),
(2403, 19, 'GYM', 4, 2, '0'),
(2404, 19, 'GYM', 4, 3, '0'),
(2405, 19, 'GYM', 4, 4, '0'),
(2406, 19, 'GYM', 4, 5, '0'),
(2407, 19, 'GYM', 4, 6, '0'),
(2408, 19, 'GYM', 4, 7, '0'),
(2409, 19, 'GYM', 4, 8, '0'),
(2410, 19, 'GYM', 4, 9, '0'),
(2411, 19, 'GYM', 4, 10, '0'),
(2412, 19, 'GYM', 4, 11, '0'),
(2413, 19, 'GYM', 4, 12, '0'),
(2414, 19, 'GYM', 4, 13, '0'),
(2415, 19, 'GYM', 4, 14, '0'),
(2416, 19, 'GYM', 4, 15, '0'),
(2417, 19, 'GYM', 4, 16, '0'),
(2418, 19, 'GYM', 4, 17, '0'),
(2419, 19, 'GYM', 4, 18, '0'),
(2420, 19, 'GYM', 4, 19, '0'),
(2421, 19, 'GYM', 4, 20, '0'),
(2422, 19, 'GYM', 4, 21, '0'),
(2423, 19, 'GYM', 4, 22, '0'),
(2424, 19, 'GYM', 4, 23, '0'),
(2425, 19, 'GYM', 4, 24, '0'),
(2426, 19, 'GYM', 4, 25, '0'),
(2427, 19, 'GYM', 4, 26, '0');

-- --------------------------------------------------------

--
-- Table structure for table `teachers`
--

CREATE TABLE `teachers` (
  `teacher_id` int(11) NOT NULL,
  `first_name` text NOT NULL,
  `last_name` text NOT NULL,
  `department` int(11) DEFAULT NULL,
  `teacher_availability` enum('full','custom') NOT NULL DEFAULT 'full'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `teachers`
--

INSERT INTO `teachers` (`teacher_id`, `first_name`, `last_name`, `department`, `teacher_availability`) VALUES
(61, 'Aldwin', 'Ilumin', NULL, 'full'),
(62, 'Wishiel', 'Ilumin', NULL, 'full'),
(63, 'Karen', 'Hermosa', NULL, 'full'),
(64, 'Noelyn', 'Sebua', NULL, 'full'),
(65, 'Vernie', 'Mercado', NULL, 'full'),
(66, 'Virgilio', 'Abarquez', NULL, 'full');

--
-- Triggers `teachers`
--
DELIMITER $$
CREATE TRIGGER `after_teacher_insert` AFTER INSERT ON `teachers` FOR EACH ROW BEGIN
    CALL generateTeacherSchedule(NEW.teacher_id);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `teacher_schedules`
--

CREATE TABLE `teacher_schedules` (
  `teacher_schedule_id` int(11) NOT NULL,
  `teacher_id` int(11) NOT NULL,
  `slot_day` int(11) NOT NULL,
  `slot_time` int(11) NOT NULL,
  `slot_course` varchar(255) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `teacher_schedules`
--

INSERT INTO `teacher_schedules` (`teacher_schedule_id`, `teacher_id`, `slot_day`, `slot_time`, `slot_course`) VALUES
(3651, 61, 0, 0, '0'),
(3652, 61, 0, 1, '0'),
(3653, 61, 0, 2, '0'),
(3654, 61, 0, 3, '0'),
(3655, 61, 0, 4, '0'),
(3656, 61, 0, 5, '0'),
(3657, 61, 0, 6, '0'),
(3658, 61, 0, 7, '0'),
(3659, 61, 0, 8, '0'),
(3660, 61, 0, 9, '0'),
(3661, 61, 0, 10, '0'),
(3662, 61, 0, 11, '0'),
(3663, 61, 0, 12, '0'),
(3664, 61, 0, 13, '0'),
(3665, 61, 0, 14, '0'),
(3666, 61, 0, 15, '0'),
(3667, 61, 0, 16, '0'),
(3668, 61, 0, 17, '0'),
(3669, 61, 0, 18, '0'),
(3670, 61, 0, 19, '0'),
(3671, 61, 0, 20, '0'),
(3672, 61, 0, 21, '0'),
(3673, 61, 0, 22, '0'),
(3674, 61, 0, 23, '0'),
(3675, 61, 0, 24, '0'),
(3676, 61, 0, 25, '0'),
(3677, 61, 0, 26, '0'),
(3678, 61, 1, 0, '0'),
(3679, 61, 1, 1, '0'),
(3680, 61, 1, 2, '0'),
(3681, 61, 1, 3, '0'),
(3682, 61, 1, 4, '0'),
(3683, 61, 1, 5, '0'),
(3684, 61, 1, 6, '0'),
(3685, 61, 1, 7, '0'),
(3686, 61, 1, 8, '0'),
(3687, 61, 1, 9, '0'),
(3688, 61, 1, 10, '0'),
(3689, 61, 1, 11, '0'),
(3690, 61, 1, 12, '0'),
(3691, 61, 1, 13, '0'),
(3692, 61, 1, 14, '0'),
(3693, 61, 1, 15, '0'),
(3694, 61, 1, 16, '0'),
(3695, 61, 1, 17, '0'),
(3696, 61, 1, 18, '0'),
(3697, 61, 1, 19, '0'),
(3698, 61, 1, 20, '0'),
(3699, 61, 1, 21, '0'),
(3700, 61, 1, 22, '0'),
(3701, 61, 1, 23, '0'),
(3702, 61, 1, 24, '0'),
(3703, 61, 1, 25, '0'),
(3704, 61, 1, 26, '0'),
(3705, 61, 2, 0, '0'),
(3706, 61, 2, 1, '0'),
(3707, 61, 2, 2, '0'),
(3708, 61, 2, 3, '0'),
(3709, 61, 2, 4, '0'),
(3710, 61, 2, 5, '0'),
(3711, 61, 2, 6, '0'),
(3712, 61, 2, 7, '0'),
(3713, 61, 2, 8, '0'),
(3714, 61, 2, 9, '0'),
(3715, 61, 2, 10, '0'),
(3716, 61, 2, 11, '0'),
(3717, 61, 2, 12, '0'),
(3718, 61, 2, 13, '0'),
(3719, 61, 2, 14, '0'),
(3720, 61, 2, 15, '0'),
(3721, 61, 2, 16, '0'),
(3722, 61, 2, 17, '0'),
(3723, 61, 2, 18, '0'),
(3724, 61, 2, 19, '0'),
(3725, 61, 2, 20, '0'),
(3726, 61, 2, 21, '0'),
(3727, 61, 2, 22, '0'),
(3728, 61, 2, 23, '0'),
(3729, 61, 2, 24, '0'),
(3730, 61, 2, 25, '0'),
(3731, 61, 2, 26, '0'),
(3732, 61, 3, 0, '0'),
(3733, 61, 3, 1, '0'),
(3734, 61, 3, 2, '0'),
(3735, 61, 3, 3, '0'),
(3736, 61, 3, 4, '0'),
(3737, 61, 3, 5, '0'),
(3738, 61, 3, 6, '0'),
(3739, 61, 3, 7, '0'),
(3740, 61, 3, 8, '0'),
(3741, 61, 3, 9, '0'),
(3742, 61, 3, 10, '0'),
(3743, 61, 3, 11, '0'),
(3744, 61, 3, 12, '0'),
(3745, 61, 3, 13, '0'),
(3746, 61, 3, 14, '0'),
(3747, 61, 3, 15, '0'),
(3748, 61, 3, 16, '0'),
(3749, 61, 3, 17, '0'),
(3750, 61, 3, 18, '0'),
(3751, 61, 3, 19, '0'),
(3752, 61, 3, 20, '0'),
(3753, 61, 3, 21, '0'),
(3754, 61, 3, 22, '0'),
(3755, 61, 3, 23, '0'),
(3756, 61, 3, 24, '0'),
(3757, 61, 3, 25, '0'),
(3758, 61, 3, 26, '0'),
(3759, 61, 4, 0, '0'),
(3760, 61, 4, 1, '0'),
(3761, 61, 4, 2, '0'),
(3762, 61, 4, 3, '0'),
(3763, 61, 4, 4, '0'),
(3764, 61, 4, 5, '0'),
(3765, 61, 4, 6, '0'),
(3766, 61, 4, 7, '0'),
(3767, 61, 4, 8, '0'),
(3768, 61, 4, 9, '0'),
(3769, 61, 4, 10, '0'),
(3770, 61, 4, 11, '0'),
(3771, 61, 4, 12, '0'),
(3772, 61, 4, 13, '0'),
(3773, 61, 4, 14, '0'),
(3774, 61, 4, 15, '0'),
(3775, 61, 4, 16, '0'),
(3776, 61, 4, 17, '0'),
(3777, 61, 4, 18, '0'),
(3778, 61, 4, 19, '0'),
(3779, 61, 4, 20, '0'),
(3780, 61, 4, 21, '0'),
(3781, 61, 4, 22, '0'),
(3782, 61, 4, 23, '0'),
(3783, 61, 4, 24, '0'),
(3784, 61, 4, 25, '0'),
(3785, 61, 4, 26, '0'),
(3786, 62, 0, 0, '0'),
(3787, 62, 0, 1, '0'),
(3788, 62, 0, 2, '0'),
(3789, 62, 0, 3, '0'),
(3790, 62, 0, 4, '0'),
(3791, 62, 0, 5, '0'),
(3792, 62, 0, 6, '0'),
(3793, 62, 0, 7, '0'),
(3794, 62, 0, 8, '0'),
(3795, 62, 0, 9, '0'),
(3796, 62, 0, 10, '0'),
(3797, 62, 0, 11, '0'),
(3798, 62, 0, 12, '0'),
(3799, 62, 0, 13, '0'),
(3800, 62, 0, 14, '0'),
(3801, 62, 0, 15, '0'),
(3802, 62, 0, 16, '0'),
(3803, 62, 0, 17, '0'),
(3804, 62, 0, 18, '0'),
(3805, 62, 0, 19, '0'),
(3806, 62, 0, 20, '0'),
(3807, 62, 0, 21, '0'),
(3808, 62, 0, 22, '0'),
(3809, 62, 0, 23, '0'),
(3810, 62, 0, 24, '0'),
(3811, 62, 0, 25, '0'),
(3812, 62, 0, 26, '0'),
(3813, 62, 1, 0, '0'),
(3814, 62, 1, 1, '0'),
(3815, 62, 1, 2, '0'),
(3816, 62, 1, 3, '0'),
(3817, 62, 1, 4, '0'),
(3818, 62, 1, 5, '0'),
(3819, 62, 1, 6, '0'),
(3820, 62, 1, 7, '0'),
(3821, 62, 1, 8, '0'),
(3822, 62, 1, 9, '0'),
(3823, 62, 1, 10, '0'),
(3824, 62, 1, 11, '0'),
(3825, 62, 1, 12, '0'),
(3826, 62, 1, 13, '0'),
(3827, 62, 1, 14, '0'),
(3828, 62, 1, 15, '0'),
(3829, 62, 1, 16, '0'),
(3830, 62, 1, 17, '0'),
(3831, 62, 1, 18, '0'),
(3832, 62, 1, 19, '0'),
(3833, 62, 1, 20, '0'),
(3834, 62, 1, 21, '0'),
(3835, 62, 1, 22, '0'),
(3836, 62, 1, 23, '0'),
(3837, 62, 1, 24, '0'),
(3838, 62, 1, 25, '0'),
(3839, 62, 1, 26, '0'),
(3840, 62, 2, 0, '0'),
(3841, 62, 2, 1, '0'),
(3842, 62, 2, 2, '0'),
(3843, 62, 2, 3, '0'),
(3844, 62, 2, 4, '0'),
(3845, 62, 2, 5, '0'),
(3846, 62, 2, 6, '0'),
(3847, 62, 2, 7, '0'),
(3848, 62, 2, 8, '0'),
(3849, 62, 2, 9, '0'),
(3850, 62, 2, 10, '0'),
(3851, 62, 2, 11, '0'),
(3852, 62, 2, 12, '0'),
(3853, 62, 2, 13, '0'),
(3854, 62, 2, 14, '0'),
(3855, 62, 2, 15, '0'),
(3856, 62, 2, 16, '0'),
(3857, 62, 2, 17, '0'),
(3858, 62, 2, 18, '0'),
(3859, 62, 2, 19, '0'),
(3860, 62, 2, 20, '0'),
(3861, 62, 2, 21, '0'),
(3862, 62, 2, 22, '0'),
(3863, 62, 2, 23, '0'),
(3864, 62, 2, 24, '0'),
(3865, 62, 2, 25, '0'),
(3866, 62, 2, 26, '0'),
(3867, 62, 3, 0, '0'),
(3868, 62, 3, 1, '0'),
(3869, 62, 3, 2, '0'),
(3870, 62, 3, 3, '0'),
(3871, 62, 3, 4, '0'),
(3872, 62, 3, 5, '0'),
(3873, 62, 3, 6, '0'),
(3874, 62, 3, 7, '0'),
(3875, 62, 3, 8, '0'),
(3876, 62, 3, 9, '0'),
(3877, 62, 3, 10, '0'),
(3878, 62, 3, 11, '0'),
(3879, 62, 3, 12, '0'),
(3880, 62, 3, 13, '0'),
(3881, 62, 3, 14, '0'),
(3882, 62, 3, 15, '0'),
(3883, 62, 3, 16, '0'),
(3884, 62, 3, 17, '0'),
(3885, 62, 3, 18, '0'),
(3886, 62, 3, 19, '0'),
(3887, 62, 3, 20, '0'),
(3888, 62, 3, 21, '0'),
(3889, 62, 3, 22, '0'),
(3890, 62, 3, 23, '0'),
(3891, 62, 3, 24, '0'),
(3892, 62, 3, 25, '0'),
(3893, 62, 3, 26, '0'),
(3894, 62, 4, 0, '0'),
(3895, 62, 4, 1, '0'),
(3896, 62, 4, 2, '0'),
(3897, 62, 4, 3, '0'),
(3898, 62, 4, 4, '0'),
(3899, 62, 4, 5, '0'),
(3900, 62, 4, 6, '0'),
(3901, 62, 4, 7, '0'),
(3902, 62, 4, 8, '0'),
(3903, 62, 4, 9, '0'),
(3904, 62, 4, 10, '0'),
(3905, 62, 4, 11, '0'),
(3906, 62, 4, 12, '0'),
(3907, 62, 4, 13, '0'),
(3908, 62, 4, 14, '0'),
(3909, 62, 4, 15, '0'),
(3910, 62, 4, 16, '0'),
(3911, 62, 4, 17, '0'),
(3912, 62, 4, 18, '0'),
(3913, 62, 4, 19, '0'),
(3914, 62, 4, 20, '0'),
(3915, 62, 4, 21, '0'),
(3916, 62, 4, 22, '0'),
(3917, 62, 4, 23, '0'),
(3918, 62, 4, 24, '0'),
(3919, 62, 4, 25, '0'),
(3920, 62, 4, 26, '0'),
(3921, 63, 0, 0, '0'),
(3922, 63, 0, 1, '0'),
(3923, 63, 0, 2, '0'),
(3924, 63, 0, 3, '0'),
(3925, 63, 0, 4, '0'),
(3926, 63, 0, 5, '0'),
(3927, 63, 0, 6, '0'),
(3928, 63, 0, 7, '0'),
(3929, 63, 0, 8, '0'),
(3930, 63, 0, 9, '0'),
(3931, 63, 0, 10, '0'),
(3932, 63, 0, 11, '0'),
(3933, 63, 0, 12, '0'),
(3934, 63, 0, 13, '0'),
(3935, 63, 0, 14, '0'),
(3936, 63, 0, 15, '0'),
(3937, 63, 0, 16, '0'),
(3938, 63, 0, 17, '0'),
(3939, 63, 0, 18, '0'),
(3940, 63, 0, 19, '0'),
(3941, 63, 0, 20, '0'),
(3942, 63, 0, 21, '0'),
(3943, 63, 0, 22, '0'),
(3944, 63, 0, 23, '0'),
(3945, 63, 0, 24, '0'),
(3946, 63, 0, 25, '0'),
(3947, 63, 0, 26, '0'),
(3948, 63, 1, 0, '0'),
(3949, 63, 1, 1, '0'),
(3950, 63, 1, 2, '0'),
(3951, 63, 1, 3, '0'),
(3952, 63, 1, 4, '0'),
(3953, 63, 1, 5, '0'),
(3954, 63, 1, 6, '0'),
(3955, 63, 1, 7, '0'),
(3956, 63, 1, 8, '0'),
(3957, 63, 1, 9, '0'),
(3958, 63, 1, 10, '0'),
(3959, 63, 1, 11, '0'),
(3960, 63, 1, 12, '0'),
(3961, 63, 1, 13, '0'),
(3962, 63, 1, 14, '0'),
(3963, 63, 1, 15, '0'),
(3964, 63, 1, 16, '0'),
(3965, 63, 1, 17, '0'),
(3966, 63, 1, 18, '0'),
(3967, 63, 1, 19, '0'),
(3968, 63, 1, 20, '0'),
(3969, 63, 1, 21, '0'),
(3970, 63, 1, 22, '0'),
(3971, 63, 1, 23, '0'),
(3972, 63, 1, 24, '0'),
(3973, 63, 1, 25, '0'),
(3974, 63, 1, 26, '0'),
(3975, 63, 2, 0, '0'),
(3976, 63, 2, 1, '0'),
(3977, 63, 2, 2, '0'),
(3978, 63, 2, 3, '0'),
(3979, 63, 2, 4, '0'),
(3980, 63, 2, 5, '0'),
(3981, 63, 2, 6, '0'),
(3982, 63, 2, 7, '0'),
(3983, 63, 2, 8, '0'),
(3984, 63, 2, 9, '0'),
(3985, 63, 2, 10, '0'),
(3986, 63, 2, 11, '0'),
(3987, 63, 2, 12, '0'),
(3988, 63, 2, 13, '0'),
(3989, 63, 2, 14, '0'),
(3990, 63, 2, 15, '0'),
(3991, 63, 2, 16, '0'),
(3992, 63, 2, 17, '0'),
(3993, 63, 2, 18, '0'),
(3994, 63, 2, 19, '0'),
(3995, 63, 2, 20, '0'),
(3996, 63, 2, 21, '0'),
(3997, 63, 2, 22, '0'),
(3998, 63, 2, 23, '0'),
(3999, 63, 2, 24, '0'),
(4000, 63, 2, 25, '0'),
(4001, 63, 2, 26, '0'),
(4002, 63, 3, 0, '0'),
(4003, 63, 3, 1, '0'),
(4004, 63, 3, 2, '0'),
(4005, 63, 3, 3, '0'),
(4006, 63, 3, 4, '0'),
(4007, 63, 3, 5, '0'),
(4008, 63, 3, 6, '0'),
(4009, 63, 3, 7, '0'),
(4010, 63, 3, 8, '0'),
(4011, 63, 3, 9, '0'),
(4012, 63, 3, 10, '0'),
(4013, 63, 3, 11, '0'),
(4014, 63, 3, 12, '0'),
(4015, 63, 3, 13, '0'),
(4016, 63, 3, 14, '0'),
(4017, 63, 3, 15, '0'),
(4018, 63, 3, 16, '0'),
(4019, 63, 3, 17, '0'),
(4020, 63, 3, 18, '0'),
(4021, 63, 3, 19, '0'),
(4022, 63, 3, 20, '0'),
(4023, 63, 3, 21, '0'),
(4024, 63, 3, 22, '0'),
(4025, 63, 3, 23, '0'),
(4026, 63, 3, 24, '0'),
(4027, 63, 3, 25, '0'),
(4028, 63, 3, 26, '0'),
(4029, 63, 4, 0, '0'),
(4030, 63, 4, 1, '0'),
(4031, 63, 4, 2, '0'),
(4032, 63, 4, 3, '0'),
(4033, 63, 4, 4, '0'),
(4034, 63, 4, 5, '0'),
(4035, 63, 4, 6, '0'),
(4036, 63, 4, 7, '0'),
(4037, 63, 4, 8, '0'),
(4038, 63, 4, 9, '0'),
(4039, 63, 4, 10, '0'),
(4040, 63, 4, 11, '0'),
(4041, 63, 4, 12, '0'),
(4042, 63, 4, 13, '0'),
(4043, 63, 4, 14, '0'),
(4044, 63, 4, 15, '0'),
(4045, 63, 4, 16, '0'),
(4046, 63, 4, 17, '0'),
(4047, 63, 4, 18, '0'),
(4048, 63, 4, 19, '0'),
(4049, 63, 4, 20, '0'),
(4050, 63, 4, 21, '0'),
(4051, 63, 4, 22, '0'),
(4052, 63, 4, 23, '0'),
(4053, 63, 4, 24, '0'),
(4054, 63, 4, 25, '0'),
(4055, 63, 4, 26, '0'),
(4056, 64, 0, 0, '0'),
(4057, 64, 0, 1, '0'),
(4058, 64, 0, 2, '0'),
(4059, 64, 0, 3, '0'),
(4060, 64, 0, 4, '0'),
(4061, 64, 0, 5, '0'),
(4062, 64, 0, 6, '0'),
(4063, 64, 0, 7, '0'),
(4064, 64, 0, 8, '0'),
(4065, 64, 0, 9, '0'),
(4066, 64, 0, 10, '0'),
(4067, 64, 0, 11, '0'),
(4068, 64, 0, 12, '0'),
(4069, 64, 0, 13, '0'),
(4070, 64, 0, 14, '0'),
(4071, 64, 0, 15, '0'),
(4072, 64, 0, 16, '0'),
(4073, 64, 0, 17, '0'),
(4074, 64, 0, 18, '0'),
(4075, 64, 0, 19, '0'),
(4076, 64, 0, 20, '0'),
(4077, 64, 0, 21, '0'),
(4078, 64, 0, 22, '0'),
(4079, 64, 0, 23, '0'),
(4080, 64, 0, 24, '0'),
(4081, 64, 0, 25, '0'),
(4082, 64, 0, 26, '0'),
(4083, 64, 1, 0, '0'),
(4084, 64, 1, 1, '0'),
(4085, 64, 1, 2, '0'),
(4086, 64, 1, 3, '0'),
(4087, 64, 1, 4, '0'),
(4088, 64, 1, 5, '0'),
(4089, 64, 1, 6, '0'),
(4090, 64, 1, 7, '0'),
(4091, 64, 1, 8, '0'),
(4092, 64, 1, 9, '0'),
(4093, 64, 1, 10, '0'),
(4094, 64, 1, 11, '0'),
(4095, 64, 1, 12, '0'),
(4096, 64, 1, 13, '0'),
(4097, 64, 1, 14, '0'),
(4098, 64, 1, 15, '0'),
(4099, 64, 1, 16, '0'),
(4100, 64, 1, 17, '0'),
(4101, 64, 1, 18, '0'),
(4102, 64, 1, 19, '0'),
(4103, 64, 1, 20, '0'),
(4104, 64, 1, 21, '0'),
(4105, 64, 1, 22, '0'),
(4106, 64, 1, 23, '0'),
(4107, 64, 1, 24, '0'),
(4108, 64, 1, 25, '0'),
(4109, 64, 1, 26, '0'),
(4110, 64, 2, 0, '0'),
(4111, 64, 2, 1, '0'),
(4112, 64, 2, 2, '0'),
(4113, 64, 2, 3, '0'),
(4114, 64, 2, 4, '0'),
(4115, 64, 2, 5, '0'),
(4116, 64, 2, 6, '0'),
(4117, 64, 2, 7, '0'),
(4118, 64, 2, 8, '0'),
(4119, 64, 2, 9, '0'),
(4120, 64, 2, 10, '0'),
(4121, 64, 2, 11, '0'),
(4122, 64, 2, 12, '0'),
(4123, 64, 2, 13, '0'),
(4124, 64, 2, 14, '0'),
(4125, 64, 2, 15, '0'),
(4126, 64, 2, 16, '0'),
(4127, 64, 2, 17, '0'),
(4128, 64, 2, 18, '0'),
(4129, 64, 2, 19, '0'),
(4130, 64, 2, 20, '0'),
(4131, 64, 2, 21, '0'),
(4132, 64, 2, 22, '0'),
(4133, 64, 2, 23, '0'),
(4134, 64, 2, 24, '0'),
(4135, 64, 2, 25, '0'),
(4136, 64, 2, 26, '0'),
(4137, 64, 3, 0, '0'),
(4138, 64, 3, 1, '0'),
(4139, 64, 3, 2, '0'),
(4140, 64, 3, 3, '0'),
(4141, 64, 3, 4, '0'),
(4142, 64, 3, 5, '0'),
(4143, 64, 3, 6, '0'),
(4144, 64, 3, 7, '0'),
(4145, 64, 3, 8, '0'),
(4146, 64, 3, 9, '0'),
(4147, 64, 3, 10, '0'),
(4148, 64, 3, 11, '0'),
(4149, 64, 3, 12, '0'),
(4150, 64, 3, 13, '0'),
(4151, 64, 3, 14, '0'),
(4152, 64, 3, 15, '0'),
(4153, 64, 3, 16, '0'),
(4154, 64, 3, 17, '0'),
(4155, 64, 3, 18, '0'),
(4156, 64, 3, 19, '0'),
(4157, 64, 3, 20, '0'),
(4158, 64, 3, 21, '0'),
(4159, 64, 3, 22, '0'),
(4160, 64, 3, 23, '0'),
(4161, 64, 3, 24, '0'),
(4162, 64, 3, 25, '0'),
(4163, 64, 3, 26, '0'),
(4164, 64, 4, 0, '0'),
(4165, 64, 4, 1, '0'),
(4166, 64, 4, 2, '0'),
(4167, 64, 4, 3, '0'),
(4168, 64, 4, 4, '0'),
(4169, 64, 4, 5, '0'),
(4170, 64, 4, 6, '0'),
(4171, 64, 4, 7, '0'),
(4172, 64, 4, 8, '0'),
(4173, 64, 4, 9, '0'),
(4174, 64, 4, 10, '0'),
(4175, 64, 4, 11, '0'),
(4176, 64, 4, 12, '0'),
(4177, 64, 4, 13, '0'),
(4178, 64, 4, 14, '0'),
(4179, 64, 4, 15, '0'),
(4180, 64, 4, 16, '0'),
(4181, 64, 4, 17, '0'),
(4182, 64, 4, 18, '0'),
(4183, 64, 4, 19, '0'),
(4184, 64, 4, 20, '0'),
(4185, 64, 4, 21, '0'),
(4186, 64, 4, 22, '0'),
(4187, 64, 4, 23, '0'),
(4188, 64, 4, 24, '0'),
(4189, 64, 4, 25, '0'),
(4190, 64, 4, 26, '0'),
(4191, 65, 0, 0, '0'),
(4192, 65, 0, 1, '0'),
(4193, 65, 0, 2, '0'),
(4194, 65, 0, 3, '0'),
(4195, 65, 0, 4, '0'),
(4196, 65, 0, 5, '0'),
(4197, 65, 0, 6, '0'),
(4198, 65, 0, 7, '0'),
(4199, 65, 0, 8, '0'),
(4200, 65, 0, 9, '0'),
(4201, 65, 0, 10, '0'),
(4202, 65, 0, 11, '0'),
(4203, 65, 0, 12, '0'),
(4204, 65, 0, 13, '0'),
(4205, 65, 0, 14, '0'),
(4206, 65, 0, 15, '0'),
(4207, 65, 0, 16, '0'),
(4208, 65, 0, 17, '0'),
(4209, 65, 0, 18, '0'),
(4210, 65, 0, 19, '0'),
(4211, 65, 0, 20, '0'),
(4212, 65, 0, 21, '0'),
(4213, 65, 0, 22, '0'),
(4214, 65, 0, 23, '0'),
(4215, 65, 0, 24, '0'),
(4216, 65, 0, 25, '0'),
(4217, 65, 0, 26, '0'),
(4218, 65, 1, 0, '0'),
(4219, 65, 1, 1, '0'),
(4220, 65, 1, 2, '0'),
(4221, 65, 1, 3, '0'),
(4222, 65, 1, 4, '0'),
(4223, 65, 1, 5, '0'),
(4224, 65, 1, 6, '0'),
(4225, 65, 1, 7, '0'),
(4226, 65, 1, 8, '0'),
(4227, 65, 1, 9, '0'),
(4228, 65, 1, 10, '0'),
(4229, 65, 1, 11, '0'),
(4230, 65, 1, 12, '0'),
(4231, 65, 1, 13, '0'),
(4232, 65, 1, 14, '0'),
(4233, 65, 1, 15, '0'),
(4234, 65, 1, 16, '0'),
(4235, 65, 1, 17, '0'),
(4236, 65, 1, 18, '0'),
(4237, 65, 1, 19, '0'),
(4238, 65, 1, 20, '0'),
(4239, 65, 1, 21, '0'),
(4240, 65, 1, 22, '0'),
(4241, 65, 1, 23, '0'),
(4242, 65, 1, 24, '0'),
(4243, 65, 1, 25, '0'),
(4244, 65, 1, 26, '0'),
(4245, 65, 2, 0, '0'),
(4246, 65, 2, 1, '0'),
(4247, 65, 2, 2, '0'),
(4248, 65, 2, 3, '0'),
(4249, 65, 2, 4, '0'),
(4250, 65, 2, 5, '0'),
(4251, 65, 2, 6, '0'),
(4252, 65, 2, 7, '0'),
(4253, 65, 2, 8, '0'),
(4254, 65, 2, 9, '0'),
(4255, 65, 2, 10, '0'),
(4256, 65, 2, 11, '0'),
(4257, 65, 2, 12, '0'),
(4258, 65, 2, 13, '0'),
(4259, 65, 2, 14, '0'),
(4260, 65, 2, 15, '0'),
(4261, 65, 2, 16, '0'),
(4262, 65, 2, 17, '0'),
(4263, 65, 2, 18, '0'),
(4264, 65, 2, 19, '0'),
(4265, 65, 2, 20, '0'),
(4266, 65, 2, 21, '0'),
(4267, 65, 2, 22, '0'),
(4268, 65, 2, 23, '0'),
(4269, 65, 2, 24, '0'),
(4270, 65, 2, 25, '0'),
(4271, 65, 2, 26, '0'),
(4272, 65, 3, 0, '0'),
(4273, 65, 3, 1, '0'),
(4274, 65, 3, 2, '0'),
(4275, 65, 3, 3, '0'),
(4276, 65, 3, 4, '0'),
(4277, 65, 3, 5, '0'),
(4278, 65, 3, 6, '0'),
(4279, 65, 3, 7, '0'),
(4280, 65, 3, 8, '0'),
(4281, 65, 3, 9, '0'),
(4282, 65, 3, 10, '0'),
(4283, 65, 3, 11, '0'),
(4284, 65, 3, 12, '0'),
(4285, 65, 3, 13, '0'),
(4286, 65, 3, 14, '0'),
(4287, 65, 3, 15, '0'),
(4288, 65, 3, 16, '0'),
(4289, 65, 3, 17, '0'),
(4290, 65, 3, 18, '0'),
(4291, 65, 3, 19, '0'),
(4292, 65, 3, 20, '0'),
(4293, 65, 3, 21, '0'),
(4294, 65, 3, 22, '0'),
(4295, 65, 3, 23, '0'),
(4296, 65, 3, 24, '0'),
(4297, 65, 3, 25, '0'),
(4298, 65, 3, 26, '0'),
(4299, 65, 4, 0, '0'),
(4300, 65, 4, 1, '0'),
(4301, 65, 4, 2, '0'),
(4302, 65, 4, 3, '0'),
(4303, 65, 4, 4, '0'),
(4304, 65, 4, 5, '0'),
(4305, 65, 4, 6, '0'),
(4306, 65, 4, 7, '0'),
(4307, 65, 4, 8, '0'),
(4308, 65, 4, 9, '0'),
(4309, 65, 4, 10, '0'),
(4310, 65, 4, 11, '0'),
(4311, 65, 4, 12, '0'),
(4312, 65, 4, 13, '0'),
(4313, 65, 4, 14, '0'),
(4314, 65, 4, 15, '0'),
(4315, 65, 4, 16, '0'),
(4316, 65, 4, 17, '0'),
(4317, 65, 4, 18, '0'),
(4318, 65, 4, 19, '0'),
(4319, 65, 4, 20, '0'),
(4320, 65, 4, 21, '0'),
(4321, 65, 4, 22, '0'),
(4322, 65, 4, 23, '0'),
(4323, 65, 4, 24, '0'),
(4324, 65, 4, 25, '0'),
(4325, 65, 4, 26, '0'),
(4326, 66, 0, 0, '0'),
(4327, 66, 0, 1, '0'),
(4328, 66, 0, 2, '0'),
(4329, 66, 0, 3, '0'),
(4330, 66, 0, 4, '0'),
(4331, 66, 0, 5, '0'),
(4332, 66, 0, 6, '0'),
(4333, 66, 0, 7, '0'),
(4334, 66, 0, 8, '0'),
(4335, 66, 0, 9, '0'),
(4336, 66, 0, 10, '0'),
(4337, 66, 0, 11, '0'),
(4338, 66, 0, 12, '0'),
(4339, 66, 0, 13, '0'),
(4340, 66, 0, 14, '0'),
(4341, 66, 0, 15, '0'),
(4342, 66, 0, 16, '0'),
(4343, 66, 0, 17, '0'),
(4344, 66, 0, 18, '0'),
(4345, 66, 0, 19, '0'),
(4346, 66, 0, 20, '0'),
(4347, 66, 0, 21, '0'),
(4348, 66, 0, 22, '0'),
(4349, 66, 0, 23, '0'),
(4350, 66, 0, 24, '0'),
(4351, 66, 0, 25, '0'),
(4352, 66, 0, 26, '0'),
(4353, 66, 1, 0, '0'),
(4354, 66, 1, 1, '0'),
(4355, 66, 1, 2, '0'),
(4356, 66, 1, 3, '0'),
(4357, 66, 1, 4, '0'),
(4358, 66, 1, 5, '0'),
(4359, 66, 1, 6, '0'),
(4360, 66, 1, 7, '0'),
(4361, 66, 1, 8, '0'),
(4362, 66, 1, 9, '0'),
(4363, 66, 1, 10, '0'),
(4364, 66, 1, 11, '0'),
(4365, 66, 1, 12, '0'),
(4366, 66, 1, 13, '0'),
(4367, 66, 1, 14, '0'),
(4368, 66, 1, 15, '0'),
(4369, 66, 1, 16, '0'),
(4370, 66, 1, 17, '0'),
(4371, 66, 1, 18, '0'),
(4372, 66, 1, 19, '0'),
(4373, 66, 1, 20, '0'),
(4374, 66, 1, 21, '0'),
(4375, 66, 1, 22, '0'),
(4376, 66, 1, 23, '0'),
(4377, 66, 1, 24, '0'),
(4378, 66, 1, 25, '0'),
(4379, 66, 1, 26, '0'),
(4380, 66, 2, 0, '0'),
(4381, 66, 2, 1, '0'),
(4382, 66, 2, 2, '0'),
(4383, 66, 2, 3, '0'),
(4384, 66, 2, 4, '0'),
(4385, 66, 2, 5, '0'),
(4386, 66, 2, 6, '0'),
(4387, 66, 2, 7, '0'),
(4388, 66, 2, 8, '0'),
(4389, 66, 2, 9, '0'),
(4390, 66, 2, 10, '0'),
(4391, 66, 2, 11, '0'),
(4392, 66, 2, 12, '0'),
(4393, 66, 2, 13, '0'),
(4394, 66, 2, 14, '0'),
(4395, 66, 2, 15, '0'),
(4396, 66, 2, 16, '0'),
(4397, 66, 2, 17, '0'),
(4398, 66, 2, 18, '0'),
(4399, 66, 2, 19, '0'),
(4400, 66, 2, 20, '0'),
(4401, 66, 2, 21, '0'),
(4402, 66, 2, 22, '0'),
(4403, 66, 2, 23, '0'),
(4404, 66, 2, 24, '0'),
(4405, 66, 2, 25, '0'),
(4406, 66, 2, 26, '0'),
(4407, 66, 3, 0, '0'),
(4408, 66, 3, 1, '0'),
(4409, 66, 3, 2, '0'),
(4410, 66, 3, 3, '0'),
(4411, 66, 3, 4, '0'),
(4412, 66, 3, 5, '0'),
(4413, 66, 3, 6, '0'),
(4414, 66, 3, 7, '0'),
(4415, 66, 3, 8, '0'),
(4416, 66, 3, 9, '0'),
(4417, 66, 3, 10, '0'),
(4418, 66, 3, 11, '0'),
(4419, 66, 3, 12, '0'),
(4420, 66, 3, 13, '0'),
(4421, 66, 3, 14, '0'),
(4422, 66, 3, 15, '0'),
(4423, 66, 3, 16, '0'),
(4424, 66, 3, 17, '0'),
(4425, 66, 3, 18, '0'),
(4426, 66, 3, 19, '0'),
(4427, 66, 3, 20, '0'),
(4428, 66, 3, 21, '0'),
(4429, 66, 3, 22, '0'),
(4430, 66, 3, 23, '0'),
(4431, 66, 3, 24, '0'),
(4432, 66, 3, 25, '0'),
(4433, 66, 3, 26, '0'),
(4434, 66, 4, 0, '0'),
(4435, 66, 4, 1, '0'),
(4436, 66, 4, 2, '0'),
(4437, 66, 4, 3, '0'),
(4438, 66, 4, 4, '0'),
(4439, 66, 4, 5, '0'),
(4440, 66, 4, 6, '0'),
(4441, 66, 4, 7, '0'),
(4442, 66, 4, 8, '0'),
(4443, 66, 4, 9, '0'),
(4444, 66, 4, 10, '0'),
(4445, 66, 4, 11, '0'),
(4446, 66, 4, 12, '0'),
(4447, 66, 4, 13, '0'),
(4448, 66, 4, 14, '0'),
(4449, 66, 4, 15, '0'),
(4450, 66, 4, 16, '0'),
(4451, 66, 4, 17, '0'),
(4452, 66, 4, 18, '0'),
(4453, 66, 4, 19, '0'),
(4454, 66, 4, 20, '0'),
(4455, 66, 4, 21, '0'),
(4456, 66, 4, 22, '0'),
(4457, 66, 4, 23, '0'),
(4458, 66, 4, 24, '0'),
(4459, 66, 4, 25, '0'),
(4460, 66, 4, 26, '0');

-- --------------------------------------------------------

--
-- Table structure for table `user_programs`
--

CREATE TABLE `user_programs` (
  `user_program_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `program_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_programs`
--

INSERT INTO `user_programs` (`user_program_id`, `user_id`, `program_id`) VALUES
(14, 23, 68),
(16, 23, 9);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `class_schedules`
--
ALTER TABLE `class_schedules`
  ADD PRIMARY KEY (`class_surr_id`),
  ADD KEY `fk_class_college_delete` (`college_id`);

--
-- Indexes for table `colleges`
--
ALTER TABLE `colleges`
  ADD PRIMARY KEY (`college_id`),
  ADD UNIQUE KEY `college_code` (`college_code`),
  ADD UNIQUE KEY `UC_College` (`college_name`,`college_major`) USING HASH;

--
-- Indexes for table `courses`
--
ALTER TABLE `courses`
  ADD PRIMARY KEY (`course_surrogate_id`),
  ADD UNIQUE KEY `course_id` (`course_id`),
  ADD KEY `fk_course_creator` (`created_by`);

--
-- Indexes for table `merge_courses`
--
ALTER TABLE `merge_courses`
  ADD PRIMARY KEY (`merge_id`);

--
-- Indexes for table `phase_control`
--
ALTER TABLE `phase_control`
  ADD PRIMARY KEY (`phase_id`);

--
-- Indexes for table `profiles`
--
ALTER TABLE `profiles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `rooms`
--
ALTER TABLE `rooms`
  ADD PRIMARY KEY (`room_id`);

--
-- Indexes for table `room_schedules`
--
ALTER TABLE `room_schedules`
  ADD PRIMARY KEY (`room_schedule_id`),
  ADD KEY `room_id` (`room_id`);

--
-- Indexes for table `teachers`
--
ALTER TABLE `teachers`
  ADD PRIMARY KEY (`teacher_id`),
  ADD UNIQUE KEY `first_name` (`first_name`,`last_name`) USING HASH;

--
-- Indexes for table `teacher_schedules`
--
ALTER TABLE `teacher_schedules`
  ADD PRIMARY KEY (`teacher_schedule_id`);

--
-- Indexes for table `user_programs`
--
ALTER TABLE `user_programs`
  ADD PRIMARY KEY (`user_program_id`),
  ADD KEY `fk_user` (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `class_schedules`
--
ALTER TABLE `class_schedules`
  MODIFY `class_surr_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3781;

--
-- AUTO_INCREMENT for table `colleges`
--
ALTER TABLE `colleges`
  MODIFY `college_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=77;

--
-- AUTO_INCREMENT for table `courses`
--
ALTER TABLE `courses`
  MODIFY `course_surrogate_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15216;

--
-- AUTO_INCREMENT for table `merge_courses`
--
ALTER TABLE `merge_courses`
  MODIFY `merge_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `phase_control`
--
ALTER TABLE `phase_control`
  MODIFY `phase_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `profiles`
--
ALTER TABLE `profiles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `rooms`
--
ALTER TABLE `rooms`
  MODIFY `room_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `room_schedules`
--
ALTER TABLE `room_schedules`
  MODIFY `room_schedule_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2428;

--
-- AUTO_INCREMENT for table `teachers`
--
ALTER TABLE `teachers`
  MODIFY `teacher_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=67;

--
-- AUTO_INCREMENT for table `teacher_schedules`
--
ALTER TABLE `teacher_schedules`
  MODIFY `teacher_schedule_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4461;

--
-- AUTO_INCREMENT for table `user_programs`
--
ALTER TABLE `user_programs`
  MODIFY `user_program_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `class_schedules`
--
ALTER TABLE `class_schedules`
  ADD CONSTRAINT `fk_class_college_delete` FOREIGN KEY (`college_id`) REFERENCES `colleges` (`college_id`) ON DELETE CASCADE;

--
-- Constraints for table `colleges`
--
ALTER TABLE `colleges`
  ADD CONSTRAINT `fk_college_created_by_delete` FOREIGN KEY (`created_by`) REFERENCES `profiles` (`id`);

--
-- Constraints for table `courses`
--
ALTER TABLE `courses`
  ADD CONSTRAINT `fk_course_creator` FOREIGN KEY (`created_by`) REFERENCES `profiles` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_delete_course_on_college` FOREIGN KEY (`course_college`) REFERENCES `colleges` (`college_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_set_null_delete_teacher` FOREIGN KEY (`assigned_teacher`) REFERENCES `teachers` (`teacher_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_subject_room_delete` FOREIGN KEY (`assigned_room`) REFERENCES `rooms` (`room_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_subject_teacher_delete` FOREIGN KEY (`assigned_teacher`) REFERENCES `teachers` (`teacher_id`) ON DELETE SET NULL;

--
-- Constraints for table `room_schedules`
--
ALTER TABLE `room_schedules`
  ADD CONSTRAINT `fk_room_schedules_rooms` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`room_id`) ON DELETE CASCADE;

--
-- Constraints for table `teacher_schedules`
--
ALTER TABLE `teacher_schedules`
  ADD CONSTRAINT `fk_teacher_schedules_teachers` FOREIGN KEY (`teacher_id`) REFERENCES `teachers` (`teacher_id`) ON DELETE CASCADE;

--
-- Constraints for table `user_programs`
--
ALTER TABLE `user_programs`
  ADD CONSTRAINT `fk_college` FOREIGN KEY (`program_id`) REFERENCES `colleges` (`college_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_college_program` FOREIGN KEY (`program_id`) REFERENCES `colleges` (`college_id`),
  ADD CONSTRAINT `fk_user` FOREIGN KEY (`user_id`) REFERENCES `profiles` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_user_program` FOREIGN KEY (`user_id`) REFERENCES `profiles` (`id`),
  ADD CONSTRAINT `user_programs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `profiles` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_programs_ibfk_2` FOREIGN KEY (`program_id`) REFERENCES `colleges` (`college_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
