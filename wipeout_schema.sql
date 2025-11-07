-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 07, 2025 at 05:13 AM
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
  MODIFY `college_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=78;

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
