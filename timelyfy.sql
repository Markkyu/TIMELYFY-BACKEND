-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 07, 2025 at 06:39 AM
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
-- Database: `timelyfy`
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
    
    SELECT college_code INTO v_college_code 
    FROM colleges 
    WHERE college_id = p_college_id;
    
    WHILE id_class_group < 4 DO
        SET @group_id = CONCAT(v_college_code, id_class_group + 1);
        SET id_increment_day = 0;
        SET id_increment_slot = 0;
        
        WHILE id_increment_day < 5 DO
            INSERT INTO class_schedules(class_id, slot_day, slot_time, slot_course)
            VALUES (@group_id, id_increment_day, id_increment_slot, 0);
            
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
    DECLARE id_increment_slot INT DEFAULT 0;
    DECLARE id_increment_day INT DEFAULT 0;

    WHILE id_increment_day < 5 DO
        INSERT INTO room_schedules(room_id, room_name, slot_day, slot_time, slot_course)
        VALUES(p_room_id, p_room_name, id_increment_day, id_increment_slot, '0');

        SET id_increment_slot = id_increment_slot + 1;

        IF id_increment_slot = 27 THEN
            SET id_increment_day = id_increment_day + 1;
            SET id_increment_slot = 0;
        END IF;
    END WHILE;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `generateTeacherSchedule` (IN `new_teacher_id` INT)   BEGIN
    DECLARE id_increment_slot INT DEFAULT 0;
    DECLARE id_increment_day INT DEFAULT 0;

    WHILE id_increment_day < 5 DO
        INSERT INTO teacher_schedules(teacher_id, slot_day, slot_time, slot_course)
        VALUES(new_teacher_id, id_increment_day, id_increment_slot, 0);

        SET id_increment_slot = id_increment_slot + 1;

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

--
-- Dumping data for table `class_schedules`
--

INSERT INTO `class_schedules` (`class_surr_id`, `class_id`, `slot_day`, `slot_time`, `slot_course`, `college_id`) VALUES
(1, 'BSCS1', 0, 0, 'CS_NSTP101', NULL),
(2, 'BSCS1', 0, 1, 'CS_NSTP101', NULL),
(3, 'BSCS1', 0, 2, '0', NULL),
(4, 'BSCS1', 0, 3, '0', NULL),
(5, 'BSCS1', 0, 4, '0', NULL),
(6, 'BSCS1', 0, 5, '0', NULL),
(7, 'BSCS1', 0, 6, '0', NULL),
(8, 'BSCS1', 0, 7, '0', NULL),
(9, 'BSCS1', 0, 8, '0', NULL),
(10, 'BSCS1', 0, 9, '0', NULL),
(11, 'BSCS1', 0, 10, '0', NULL),
(12, 'BSCS1', 0, 11, '0', NULL),
(13, 'BSCS1', 0, 12, '0', NULL),
(14, 'BSCS1', 0, 13, '0', NULL),
(15, 'BSCS1', 0, 14, '0', NULL),
(16, 'BSCS1', 0, 15, '0', NULL),
(17, 'BSCS1', 0, 16, '0', NULL),
(18, 'BSCS1', 0, 17, '0', NULL),
(19, 'BSCS1', 0, 18, '0', NULL),
(20, 'BSCS1', 0, 19, '0', NULL),
(21, 'BSCS1', 0, 20, '0', NULL),
(22, 'BSCS1', 0, 21, '0', NULL),
(23, 'BSCS1', 0, 22, '0', NULL),
(24, 'BSCS1', 0, 23, '0', NULL),
(25, 'BSCS1', 0, 24, '0', NULL),
(26, 'BSCS1', 0, 25, '0', NULL),
(27, 'BSCS1', 0, 26, '0', NULL),
(28, 'BSCS1', 1, 0, '0', NULL),
(29, 'BSCS1', 1, 1, '0', NULL),
(30, 'BSCS1', 1, 2, '0', NULL),
(31, 'BSCS1', 1, 3, '0', NULL),
(32, 'BSCS1', 1, 4, '0', NULL),
(33, 'BSCS1', 1, 5, '0', NULL),
(34, 'BSCS1', 1, 6, '0', NULL),
(35, 'BSCS1', 1, 7, '0', NULL),
(36, 'BSCS1', 1, 8, '0', NULL),
(37, 'BSCS1', 1, 9, '0', NULL),
(38, 'BSCS1', 1, 10, '0', NULL),
(39, 'BSCS1', 1, 11, '0', NULL),
(40, 'BSCS1', 1, 12, '0', NULL),
(41, 'BSCS1', 1, 13, '0', NULL),
(42, 'BSCS1', 1, 14, '0', NULL),
(43, 'BSCS1', 1, 15, '0', NULL),
(44, 'BSCS1', 1, 16, '0', NULL),
(45, 'BSCS1', 1, 17, '0', NULL),
(46, 'BSCS1', 1, 18, '0', NULL),
(47, 'BSCS1', 1, 19, '0', NULL),
(48, 'BSCS1', 1, 20, '0', NULL),
(49, 'BSCS1', 1, 21, '0', NULL),
(50, 'BSCS1', 1, 22, '0', NULL),
(51, 'BSCS1', 1, 23, '0', NULL),
(52, 'BSCS1', 1, 24, '0', NULL),
(53, 'BSCS1', 1, 25, '0', NULL),
(54, 'BSCS1', 1, 26, '0', NULL),
(55, 'BSCS1', 2, 0, 'CS_NSTP101', NULL),
(56, 'BSCS1', 2, 1, 'CS_NSTP101', NULL),
(57, 'BSCS1', 2, 2, '0', NULL),
(58, 'BSCS1', 2, 3, '0', NULL),
(59, 'BSCS1', 2, 4, '0', NULL),
(60, 'BSCS1', 2, 5, '0', NULL),
(61, 'BSCS1', 2, 6, '0', NULL),
(62, 'BSCS1', 2, 7, '0', NULL),
(63, 'BSCS1', 2, 8, '0', NULL),
(64, 'BSCS1', 2, 9, '0', NULL),
(65, 'BSCS1', 2, 10, '0', NULL),
(66, 'BSCS1', 2, 11, '0', NULL),
(67, 'BSCS1', 2, 12, '0', NULL),
(68, 'BSCS1', 2, 13, '0', NULL),
(69, 'BSCS1', 2, 14, '0', NULL),
(70, 'BSCS1', 2, 15, '0', NULL),
(71, 'BSCS1', 2, 16, '0', NULL),
(72, 'BSCS1', 2, 17, '0', NULL),
(73, 'BSCS1', 2, 18, '0', NULL),
(74, 'BSCS1', 2, 19, '0', NULL),
(75, 'BSCS1', 2, 20, '0', NULL),
(76, 'BSCS1', 2, 21, '0', NULL),
(77, 'BSCS1', 2, 22, '0', NULL),
(78, 'BSCS1', 2, 23, '0', NULL),
(79, 'BSCS1', 2, 24, '0', NULL),
(80, 'BSCS1', 2, 25, '0', NULL),
(81, 'BSCS1', 2, 26, '0', NULL),
(82, 'BSCS1', 3, 0, '0', NULL),
(83, 'BSCS1', 3, 1, '0', NULL),
(84, 'BSCS1', 3, 2, '0', NULL),
(85, 'BSCS1', 3, 3, '0', NULL),
(86, 'BSCS1', 3, 4, '0', NULL),
(87, 'BSCS1', 3, 5, '0', NULL),
(88, 'BSCS1', 3, 6, '0', NULL),
(89, 'BSCS1', 3, 7, '0', NULL),
(90, 'BSCS1', 3, 8, '0', NULL),
(91, 'BSCS1', 3, 9, '0', NULL),
(92, 'BSCS1', 3, 10, '0', NULL),
(93, 'BSCS1', 3, 11, '0', NULL),
(94, 'BSCS1', 3, 12, '0', NULL),
(95, 'BSCS1', 3, 13, '0', NULL),
(96, 'BSCS1', 3, 14, '0', NULL),
(97, 'BSCS1', 3, 15, '0', NULL),
(98, 'BSCS1', 3, 16, '0', NULL),
(99, 'BSCS1', 3, 17, '0', NULL),
(100, 'BSCS1', 3, 18, '0', NULL),
(101, 'BSCS1', 3, 19, '0', NULL),
(102, 'BSCS1', 3, 20, '0', NULL),
(103, 'BSCS1', 3, 21, '0', NULL),
(104, 'BSCS1', 3, 22, '0', NULL),
(105, 'BSCS1', 3, 23, '0', NULL),
(106, 'BSCS1', 3, 24, '0', NULL),
(107, 'BSCS1', 3, 25, '0', NULL),
(108, 'BSCS1', 3, 26, '0', NULL),
(109, 'BSCS1', 4, 0, 'CS_NSTP101', NULL),
(110, 'BSCS1', 4, 1, 'CS_NSTP101', NULL),
(111, 'BSCS1', 4, 2, '0', NULL),
(112, 'BSCS1', 4, 3, '0', NULL),
(113, 'BSCS1', 4, 4, '0', NULL),
(114, 'BSCS1', 4, 5, '0', NULL),
(115, 'BSCS1', 4, 6, '0', NULL),
(116, 'BSCS1', 4, 7, '0', NULL),
(117, 'BSCS1', 4, 8, '0', NULL),
(118, 'BSCS1', 4, 9, '0', NULL),
(119, 'BSCS1', 4, 10, '0', NULL),
(120, 'BSCS1', 4, 11, '0', NULL),
(121, 'BSCS1', 4, 12, '0', NULL),
(122, 'BSCS1', 4, 13, '0', NULL),
(123, 'BSCS1', 4, 14, '0', NULL),
(124, 'BSCS1', 4, 15, '0', NULL),
(125, 'BSCS1', 4, 16, '0', NULL),
(126, 'BSCS1', 4, 17, '0', NULL),
(127, 'BSCS1', 4, 18, '0', NULL),
(128, 'BSCS1', 4, 19, '0', NULL),
(129, 'BSCS1', 4, 20, '0', NULL),
(130, 'BSCS1', 4, 21, '0', NULL),
(131, 'BSCS1', 4, 22, '0', NULL),
(132, 'BSCS1', 4, 23, '0', NULL),
(133, 'BSCS1', 4, 24, '0', NULL),
(134, 'BSCS1', 4, 25, '0', NULL),
(135, 'BSCS1', 4, 26, '0', NULL),
(136, 'BSCS2', 0, 0, '0', NULL),
(137, 'BSCS2', 0, 1, '0', NULL),
(138, 'BSCS2', 0, 2, '0', NULL),
(139, 'BSCS2', 0, 3, '0', NULL),
(140, 'BSCS2', 0, 4, '0', NULL),
(141, 'BSCS2', 0, 5, '0', NULL),
(142, 'BSCS2', 0, 6, '0', NULL),
(143, 'BSCS2', 0, 7, '0', NULL),
(144, 'BSCS2', 0, 8, '0', NULL),
(145, 'BSCS2', 0, 9, '0', NULL),
(146, 'BSCS2', 0, 10, '0', NULL),
(147, 'BSCS2', 0, 11, '0', NULL),
(148, 'BSCS2', 0, 12, '0', NULL),
(149, 'BSCS2', 0, 13, '0', NULL),
(150, 'BSCS2', 0, 14, '0', NULL),
(151, 'BSCS2', 0, 15, '0', NULL),
(152, 'BSCS2', 0, 16, '0', NULL),
(153, 'BSCS2', 0, 17, '0', NULL),
(154, 'BSCS2', 0, 18, '0', NULL),
(155, 'BSCS2', 0, 19, '0', NULL),
(156, 'BSCS2', 0, 20, '0', NULL),
(157, 'BSCS2', 0, 21, '0', NULL),
(158, 'BSCS2', 0, 22, '0', NULL),
(159, 'BSCS2', 0, 23, '0', NULL),
(160, 'BSCS2', 0, 24, '0', NULL),
(161, 'BSCS2', 0, 25, '0', NULL),
(162, 'BSCS2', 0, 26, '0', NULL),
(163, 'BSCS2', 1, 0, '0', NULL),
(164, 'BSCS2', 1, 1, '0', NULL),
(165, 'BSCS2', 1, 2, '0', NULL),
(166, 'BSCS2', 1, 3, '0', NULL),
(167, 'BSCS2', 1, 4, '0', NULL),
(168, 'BSCS2', 1, 5, '0', NULL),
(169, 'BSCS2', 1, 6, '0', NULL),
(170, 'BSCS2', 1, 7, '0', NULL),
(171, 'BSCS2', 1, 8, '0', NULL),
(172, 'BSCS2', 1, 9, '0', NULL),
(173, 'BSCS2', 1, 10, '0', NULL),
(174, 'BSCS2', 1, 11, '0', NULL),
(175, 'BSCS2', 1, 12, '0', NULL),
(176, 'BSCS2', 1, 13, '0', NULL),
(177, 'BSCS2', 1, 14, '0', NULL),
(178, 'BSCS2', 1, 15, '0', NULL),
(179, 'BSCS2', 1, 16, '0', NULL),
(180, 'BSCS2', 1, 17, '0', NULL),
(181, 'BSCS2', 1, 18, '0', NULL),
(182, 'BSCS2', 1, 19, '0', NULL),
(183, 'BSCS2', 1, 20, '0', NULL),
(184, 'BSCS2', 1, 21, '0', NULL),
(185, 'BSCS2', 1, 22, '0', NULL),
(186, 'BSCS2', 1, 23, '0', NULL),
(187, 'BSCS2', 1, 24, '0', NULL),
(188, 'BSCS2', 1, 25, '0', NULL),
(189, 'BSCS2', 1, 26, '0', NULL),
(190, 'BSCS2', 2, 0, '0', NULL),
(191, 'BSCS2', 2, 1, '0', NULL),
(192, 'BSCS2', 2, 2, '0', NULL),
(193, 'BSCS2', 2, 3, '0', NULL),
(194, 'BSCS2', 2, 4, '0', NULL),
(195, 'BSCS2', 2, 5, '0', NULL),
(196, 'BSCS2', 2, 6, '0', NULL),
(197, 'BSCS2', 2, 7, '0', NULL),
(198, 'BSCS2', 2, 8, '0', NULL),
(199, 'BSCS2', 2, 9, '0', NULL),
(200, 'BSCS2', 2, 10, '0', NULL),
(201, 'BSCS2', 2, 11, '0', NULL),
(202, 'BSCS2', 2, 12, '0', NULL),
(203, 'BSCS2', 2, 13, '0', NULL),
(204, 'BSCS2', 2, 14, '0', NULL),
(205, 'BSCS2', 2, 15, '0', NULL),
(206, 'BSCS2', 2, 16, '0', NULL),
(207, 'BSCS2', 2, 17, '0', NULL),
(208, 'BSCS2', 2, 18, '0', NULL),
(209, 'BSCS2', 2, 19, '0', NULL),
(210, 'BSCS2', 2, 20, '0', NULL),
(211, 'BSCS2', 2, 21, '0', NULL),
(212, 'BSCS2', 2, 22, '0', NULL),
(213, 'BSCS2', 2, 23, '0', NULL),
(214, 'BSCS2', 2, 24, '0', NULL),
(215, 'BSCS2', 2, 25, '0', NULL),
(216, 'BSCS2', 2, 26, '0', NULL),
(217, 'BSCS2', 3, 0, '0', NULL),
(218, 'BSCS2', 3, 1, '0', NULL),
(219, 'BSCS2', 3, 2, '0', NULL),
(220, 'BSCS2', 3, 3, '0', NULL),
(221, 'BSCS2', 3, 4, '0', NULL),
(222, 'BSCS2', 3, 5, '0', NULL),
(223, 'BSCS2', 3, 6, '0', NULL),
(224, 'BSCS2', 3, 7, '0', NULL),
(225, 'BSCS2', 3, 8, '0', NULL),
(226, 'BSCS2', 3, 9, '0', NULL),
(227, 'BSCS2', 3, 10, '0', NULL),
(228, 'BSCS2', 3, 11, '0', NULL),
(229, 'BSCS2', 3, 12, '0', NULL),
(230, 'BSCS2', 3, 13, '0', NULL),
(231, 'BSCS2', 3, 14, '0', NULL),
(232, 'BSCS2', 3, 15, '0', NULL),
(233, 'BSCS2', 3, 16, '0', NULL),
(234, 'BSCS2', 3, 17, '0', NULL),
(235, 'BSCS2', 3, 18, '0', NULL),
(236, 'BSCS2', 3, 19, '0', NULL),
(237, 'BSCS2', 3, 20, '0', NULL),
(238, 'BSCS2', 3, 21, '0', NULL),
(239, 'BSCS2', 3, 22, '0', NULL),
(240, 'BSCS2', 3, 23, '0', NULL),
(241, 'BSCS2', 3, 24, '0', NULL),
(242, 'BSCS2', 3, 25, '0', NULL),
(243, 'BSCS2', 3, 26, '0', NULL),
(244, 'BSCS2', 4, 0, '0', NULL),
(245, 'BSCS2', 4, 1, '0', NULL),
(246, 'BSCS2', 4, 2, '0', NULL),
(247, 'BSCS2', 4, 3, '0', NULL),
(248, 'BSCS2', 4, 4, '0', NULL),
(249, 'BSCS2', 4, 5, '0', NULL),
(250, 'BSCS2', 4, 6, '0', NULL),
(251, 'BSCS2', 4, 7, '0', NULL),
(252, 'BSCS2', 4, 8, '0', NULL),
(253, 'BSCS2', 4, 9, '0', NULL),
(254, 'BSCS2', 4, 10, '0', NULL),
(255, 'BSCS2', 4, 11, '0', NULL),
(256, 'BSCS2', 4, 12, '0', NULL),
(257, 'BSCS2', 4, 13, '0', NULL),
(258, 'BSCS2', 4, 14, '0', NULL),
(259, 'BSCS2', 4, 15, '0', NULL),
(260, 'BSCS2', 4, 16, '0', NULL),
(261, 'BSCS2', 4, 17, '0', NULL),
(262, 'BSCS2', 4, 18, '0', NULL),
(263, 'BSCS2', 4, 19, '0', NULL),
(264, 'BSCS2', 4, 20, '0', NULL),
(265, 'BSCS2', 4, 21, '0', NULL),
(266, 'BSCS2', 4, 22, '0', NULL),
(267, 'BSCS2', 4, 23, '0', NULL),
(268, 'BSCS2', 4, 24, '0', NULL),
(269, 'BSCS2', 4, 25, '0', NULL),
(270, 'BSCS2', 4, 26, '0', NULL),
(271, 'BSCS3', 0, 0, '0', NULL),
(272, 'BSCS3', 0, 1, '0', NULL),
(273, 'BSCS3', 0, 2, '0', NULL),
(274, 'BSCS3', 0, 3, '0', NULL),
(275, 'BSCS3', 0, 4, '0', NULL),
(276, 'BSCS3', 0, 5, '0', NULL),
(277, 'BSCS3', 0, 6, '0', NULL),
(278, 'BSCS3', 0, 7, '0', NULL),
(279, 'BSCS3', 0, 8, '0', NULL),
(280, 'BSCS3', 0, 9, '0', NULL),
(281, 'BSCS3', 0, 10, '0', NULL),
(282, 'BSCS3', 0, 11, '0', NULL),
(283, 'BSCS3', 0, 12, '0', NULL),
(284, 'BSCS3', 0, 13, '0', NULL),
(285, 'BSCS3', 0, 14, '0', NULL),
(286, 'BSCS3', 0, 15, '0', NULL),
(287, 'BSCS3', 0, 16, '0', NULL),
(288, 'BSCS3', 0, 17, '0', NULL),
(289, 'BSCS3', 0, 18, '0', NULL),
(290, 'BSCS3', 0, 19, '0', NULL),
(291, 'BSCS3', 0, 20, '0', NULL),
(292, 'BSCS3', 0, 21, '0', NULL),
(293, 'BSCS3', 0, 22, '0', NULL),
(294, 'BSCS3', 0, 23, '0', NULL),
(295, 'BSCS3', 0, 24, '0', NULL),
(296, 'BSCS3', 0, 25, '0', NULL),
(297, 'BSCS3', 0, 26, '0', NULL),
(298, 'BSCS3', 1, 0, '0', NULL),
(299, 'BSCS3', 1, 1, '0', NULL),
(300, 'BSCS3', 1, 2, '0', NULL),
(301, 'BSCS3', 1, 3, '0', NULL),
(302, 'BSCS3', 1, 4, '0', NULL),
(303, 'BSCS3', 1, 5, '0', NULL),
(304, 'BSCS3', 1, 6, '0', NULL),
(305, 'BSCS3', 1, 7, '0', NULL),
(306, 'BSCS3', 1, 8, '0', NULL),
(307, 'BSCS3', 1, 9, '0', NULL),
(308, 'BSCS3', 1, 10, '0', NULL),
(309, 'BSCS3', 1, 11, '0', NULL),
(310, 'BSCS3', 1, 12, '0', NULL),
(311, 'BSCS3', 1, 13, '0', NULL),
(312, 'BSCS3', 1, 14, '0', NULL),
(313, 'BSCS3', 1, 15, '0', NULL),
(314, 'BSCS3', 1, 16, '0', NULL),
(315, 'BSCS3', 1, 17, '0', NULL),
(316, 'BSCS3', 1, 18, '0', NULL),
(317, 'BSCS3', 1, 19, '0', NULL),
(318, 'BSCS3', 1, 20, '0', NULL),
(319, 'BSCS3', 1, 21, '0', NULL),
(320, 'BSCS3', 1, 22, '0', NULL),
(321, 'BSCS3', 1, 23, '0', NULL),
(322, 'BSCS3', 1, 24, '0', NULL),
(323, 'BSCS3', 1, 25, '0', NULL),
(324, 'BSCS3', 1, 26, '0', NULL),
(325, 'BSCS3', 2, 0, '0', NULL),
(326, 'BSCS3', 2, 1, '0', NULL),
(327, 'BSCS3', 2, 2, '0', NULL),
(328, 'BSCS3', 2, 3, '0', NULL),
(329, 'BSCS3', 2, 4, '0', NULL),
(330, 'BSCS3', 2, 5, '0', NULL),
(331, 'BSCS3', 2, 6, '0', NULL),
(332, 'BSCS3', 2, 7, '0', NULL),
(333, 'BSCS3', 2, 8, '0', NULL),
(334, 'BSCS3', 2, 9, '0', NULL),
(335, 'BSCS3', 2, 10, '0', NULL),
(336, 'BSCS3', 2, 11, '0', NULL),
(337, 'BSCS3', 2, 12, '0', NULL),
(338, 'BSCS3', 2, 13, '0', NULL),
(339, 'BSCS3', 2, 14, '0', NULL),
(340, 'BSCS3', 2, 15, '0', NULL),
(341, 'BSCS3', 2, 16, '0', NULL),
(342, 'BSCS3', 2, 17, '0', NULL),
(343, 'BSCS3', 2, 18, '0', NULL),
(344, 'BSCS3', 2, 19, '0', NULL),
(345, 'BSCS3', 2, 20, '0', NULL),
(346, 'BSCS3', 2, 21, '0', NULL),
(347, 'BSCS3', 2, 22, '0', NULL),
(348, 'BSCS3', 2, 23, '0', NULL),
(349, 'BSCS3', 2, 24, '0', NULL),
(350, 'BSCS3', 2, 25, '0', NULL),
(351, 'BSCS3', 2, 26, '0', NULL),
(352, 'BSCS3', 3, 0, '0', NULL),
(353, 'BSCS3', 3, 1, '0', NULL),
(354, 'BSCS3', 3, 2, '0', NULL),
(355, 'BSCS3', 3, 3, '0', NULL),
(356, 'BSCS3', 3, 4, '0', NULL),
(357, 'BSCS3', 3, 5, '0', NULL),
(358, 'BSCS3', 3, 6, '0', NULL),
(359, 'BSCS3', 3, 7, '0', NULL),
(360, 'BSCS3', 3, 8, '0', NULL),
(361, 'BSCS3', 3, 9, '0', NULL),
(362, 'BSCS3', 3, 10, '0', NULL),
(363, 'BSCS3', 3, 11, '0', NULL),
(364, 'BSCS3', 3, 12, '0', NULL),
(365, 'BSCS3', 3, 13, '0', NULL),
(366, 'BSCS3', 3, 14, '0', NULL),
(367, 'BSCS3', 3, 15, '0', NULL),
(368, 'BSCS3', 3, 16, '0', NULL),
(369, 'BSCS3', 3, 17, '0', NULL),
(370, 'BSCS3', 3, 18, '0', NULL),
(371, 'BSCS3', 3, 19, '0', NULL),
(372, 'BSCS3', 3, 20, '0', NULL),
(373, 'BSCS3', 3, 21, '0', NULL),
(374, 'BSCS3', 3, 22, '0', NULL),
(375, 'BSCS3', 3, 23, '0', NULL),
(376, 'BSCS3', 3, 24, '0', NULL),
(377, 'BSCS3', 3, 25, '0', NULL),
(378, 'BSCS3', 3, 26, '0', NULL),
(379, 'BSCS3', 4, 0, '0', NULL),
(380, 'BSCS3', 4, 1, '0', NULL),
(381, 'BSCS3', 4, 2, '0', NULL),
(382, 'BSCS3', 4, 3, '0', NULL),
(383, 'BSCS3', 4, 4, '0', NULL),
(384, 'BSCS3', 4, 5, '0', NULL),
(385, 'BSCS3', 4, 6, '0', NULL),
(386, 'BSCS3', 4, 7, '0', NULL),
(387, 'BSCS3', 4, 8, '0', NULL),
(388, 'BSCS3', 4, 9, '0', NULL),
(389, 'BSCS3', 4, 10, '0', NULL),
(390, 'BSCS3', 4, 11, '0', NULL),
(391, 'BSCS3', 4, 12, '0', NULL),
(392, 'BSCS3', 4, 13, '0', NULL),
(393, 'BSCS3', 4, 14, '0', NULL),
(394, 'BSCS3', 4, 15, '0', NULL),
(395, 'BSCS3', 4, 16, '0', NULL),
(396, 'BSCS3', 4, 17, '0', NULL),
(397, 'BSCS3', 4, 18, '0', NULL),
(398, 'BSCS3', 4, 19, '0', NULL),
(399, 'BSCS3', 4, 20, '0', NULL),
(400, 'BSCS3', 4, 21, '0', NULL),
(401, 'BSCS3', 4, 22, '0', NULL),
(402, 'BSCS3', 4, 23, '0', NULL),
(403, 'BSCS3', 4, 24, '0', NULL),
(404, 'BSCS3', 4, 25, '0', NULL),
(405, 'BSCS3', 4, 26, '0', NULL),
(406, 'BSCS4', 0, 0, '0', NULL),
(407, 'BSCS4', 0, 1, '0', NULL),
(408, 'BSCS4', 0, 2, '0', NULL),
(409, 'BSCS4', 0, 3, '0', NULL),
(410, 'BSCS4', 0, 4, '0', NULL),
(411, 'BSCS4', 0, 5, '0', NULL),
(412, 'BSCS4', 0, 6, '0', NULL),
(413, 'BSCS4', 0, 7, '0', NULL),
(414, 'BSCS4', 0, 8, '0', NULL),
(415, 'BSCS4', 0, 9, '0', NULL),
(416, 'BSCS4', 0, 10, '0', NULL),
(417, 'BSCS4', 0, 11, '0', NULL),
(418, 'BSCS4', 0, 12, '0', NULL),
(419, 'BSCS4', 0, 13, '0', NULL),
(420, 'BSCS4', 0, 14, '0', NULL),
(421, 'BSCS4', 0, 15, '0', NULL),
(422, 'BSCS4', 0, 16, '0', NULL),
(423, 'BSCS4', 0, 17, '0', NULL),
(424, 'BSCS4', 0, 18, '0', NULL),
(425, 'BSCS4', 0, 19, '0', NULL),
(426, 'BSCS4', 0, 20, '0', NULL),
(427, 'BSCS4', 0, 21, '0', NULL),
(428, 'BSCS4', 0, 22, '0', NULL),
(429, 'BSCS4', 0, 23, '0', NULL),
(430, 'BSCS4', 0, 24, '0', NULL),
(431, 'BSCS4', 0, 25, '0', NULL),
(432, 'BSCS4', 0, 26, '0', NULL),
(433, 'BSCS4', 1, 0, '0', NULL),
(434, 'BSCS4', 1, 1, '0', NULL),
(435, 'BSCS4', 1, 2, '0', NULL),
(436, 'BSCS4', 1, 3, '0', NULL),
(437, 'BSCS4', 1, 4, '0', NULL),
(438, 'BSCS4', 1, 5, '0', NULL),
(439, 'BSCS4', 1, 6, '0', NULL),
(440, 'BSCS4', 1, 7, '0', NULL),
(441, 'BSCS4', 1, 8, '0', NULL),
(442, 'BSCS4', 1, 9, '0', NULL),
(443, 'BSCS4', 1, 10, '0', NULL),
(444, 'BSCS4', 1, 11, '0', NULL),
(445, 'BSCS4', 1, 12, '0', NULL),
(446, 'BSCS4', 1, 13, '0', NULL),
(447, 'BSCS4', 1, 14, '0', NULL),
(448, 'BSCS4', 1, 15, '0', NULL),
(449, 'BSCS4', 1, 16, '0', NULL),
(450, 'BSCS4', 1, 17, '0', NULL),
(451, 'BSCS4', 1, 18, '0', NULL),
(452, 'BSCS4', 1, 19, '0', NULL),
(453, 'BSCS4', 1, 20, '0', NULL),
(454, 'BSCS4', 1, 21, '0', NULL),
(455, 'BSCS4', 1, 22, '0', NULL),
(456, 'BSCS4', 1, 23, '0', NULL),
(457, 'BSCS4', 1, 24, '0', NULL),
(458, 'BSCS4', 1, 25, '0', NULL),
(459, 'BSCS4', 1, 26, '0', NULL),
(460, 'BSCS4', 2, 0, '0', NULL),
(461, 'BSCS4', 2, 1, '0', NULL),
(462, 'BSCS4', 2, 2, '0', NULL),
(463, 'BSCS4', 2, 3, '0', NULL),
(464, 'BSCS4', 2, 4, '0', NULL),
(465, 'BSCS4', 2, 5, '0', NULL),
(466, 'BSCS4', 2, 6, '0', NULL),
(467, 'BSCS4', 2, 7, '0', NULL),
(468, 'BSCS4', 2, 8, '0', NULL),
(469, 'BSCS4', 2, 9, '0', NULL),
(470, 'BSCS4', 2, 10, '0', NULL),
(471, 'BSCS4', 2, 11, '0', NULL),
(472, 'BSCS4', 2, 12, '0', NULL),
(473, 'BSCS4', 2, 13, '0', NULL),
(474, 'BSCS4', 2, 14, '0', NULL),
(475, 'BSCS4', 2, 15, '0', NULL),
(476, 'BSCS4', 2, 16, '0', NULL),
(477, 'BSCS4', 2, 17, '0', NULL),
(478, 'BSCS4', 2, 18, '0', NULL),
(479, 'BSCS4', 2, 19, '0', NULL),
(480, 'BSCS4', 2, 20, '0', NULL),
(481, 'BSCS4', 2, 21, '0', NULL),
(482, 'BSCS4', 2, 22, '0', NULL),
(483, 'BSCS4', 2, 23, '0', NULL),
(484, 'BSCS4', 2, 24, '0', NULL),
(485, 'BSCS4', 2, 25, '0', NULL),
(486, 'BSCS4', 2, 26, '0', NULL),
(487, 'BSCS4', 3, 0, '0', NULL),
(488, 'BSCS4', 3, 1, '0', NULL),
(489, 'BSCS4', 3, 2, '0', NULL),
(490, 'BSCS4', 3, 3, '0', NULL),
(491, 'BSCS4', 3, 4, '0', NULL),
(492, 'BSCS4', 3, 5, '0', NULL),
(493, 'BSCS4', 3, 6, '0', NULL),
(494, 'BSCS4', 3, 7, '0', NULL),
(495, 'BSCS4', 3, 8, '0', NULL),
(496, 'BSCS4', 3, 9, '0', NULL),
(497, 'BSCS4', 3, 10, '0', NULL),
(498, 'BSCS4', 3, 11, '0', NULL),
(499, 'BSCS4', 3, 12, '0', NULL),
(500, 'BSCS4', 3, 13, '0', NULL),
(501, 'BSCS4', 3, 14, '0', NULL),
(502, 'BSCS4', 3, 15, '0', NULL),
(503, 'BSCS4', 3, 16, '0', NULL),
(504, 'BSCS4', 3, 17, '0', NULL),
(505, 'BSCS4', 3, 18, '0', NULL),
(506, 'BSCS4', 3, 19, '0', NULL),
(507, 'BSCS4', 3, 20, '0', NULL),
(508, 'BSCS4', 3, 21, '0', NULL),
(509, 'BSCS4', 3, 22, '0', NULL),
(510, 'BSCS4', 3, 23, '0', NULL),
(511, 'BSCS4', 3, 24, '0', NULL),
(512, 'BSCS4', 3, 25, '0', NULL),
(513, 'BSCS4', 3, 26, '0', NULL),
(514, 'BSCS4', 4, 0, '0', NULL),
(515, 'BSCS4', 4, 1, '0', NULL),
(516, 'BSCS4', 4, 2, '0', NULL),
(517, 'BSCS4', 4, 3, '0', NULL),
(518, 'BSCS4', 4, 4, '0', NULL),
(519, 'BSCS4', 4, 5, '0', NULL),
(520, 'BSCS4', 4, 6, '0', NULL),
(521, 'BSCS4', 4, 7, '0', NULL),
(522, 'BSCS4', 4, 8, '0', NULL),
(523, 'BSCS4', 4, 9, '0', NULL),
(524, 'BSCS4', 4, 10, '0', NULL),
(525, 'BSCS4', 4, 11, '0', NULL),
(526, 'BSCS4', 4, 12, '0', NULL),
(527, 'BSCS4', 4, 13, '0', NULL),
(528, 'BSCS4', 4, 14, '0', NULL),
(529, 'BSCS4', 4, 15, '0', NULL),
(530, 'BSCS4', 4, 16, '0', NULL),
(531, 'BSCS4', 4, 17, '0', NULL),
(532, 'BSCS4', 4, 18, '0', NULL),
(533, 'BSCS4', 4, 19, '0', NULL),
(534, 'BSCS4', 4, 20, '0', NULL),
(535, 'BSCS4', 4, 21, '0', NULL),
(536, 'BSCS4', 4, 22, '0', NULL),
(537, 'BSCS4', 4, 23, '0', NULL),
(538, 'BSCS4', 4, 24, '0', NULL),
(539, 'BSCS4', 4, 25, '0', NULL),
(540, 'BSCS4', 4, 26, '0', NULL);

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
-- Dumping data for table `colleges`
--

INSERT INTO `colleges` (`college_id`, `college_name`, `college_major`, `college_code`, `created_by`) VALUES
(1, 'Computer Science', '', 'BSCS', 0);

--
-- Triggers `colleges`
--
DELIMITER $$
CREATE TRIGGER `after_college_insert` AFTER INSERT ON `colleges` FOR EACH ROW BEGIN
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

--
-- Dumping data for table `courses`
--

INSERT INTO `courses` (`course_surrogate_id`, `course_id`, `course_code`, `course_name`, `hours_week`, `course_year`, `course_college`, `semester`, `assigned_teacher`, `assigned_room`, `is_plotted`, `is_special`, `created_by`) VALUES
(1, 'CS_NSTP101', 'NSTP101', 'Civic Welfare Training Service 1', 3, 1, 1, 1, 1, 1, 1, 0, 1),
(2, 'CS_NSTP102', 'NSTP102', 'Civic Welfare Training Service 2', 3, 2, 1, 1, 1, 1, 0, 0, 1),
(3, 'CS_123123', '123123', '123123', 3, 1, 1, 1, 1, 1, 0, 0, 2);

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
(1, 1, 1, 'super_user');

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
(1, 'Markkyu', '$2b$10$Yd/10k2Vt3CL4zIE8M4X3uNL6eu79noaSz2xgLgPP7efv6GTPXJZG', 'admin', '', '', '2025-11-07', 'no'),
(2, 'user', '$2b$10$PQ96rFmlqhobK4uvIWi2t.gnhoY2SZXGD2/cKooEhhyrU12ZKNQIG', 'user', '', '', '2025-11-07', 'no'),
(3, 'master', '$2b$10$UUEpINrRgbyw1HLx4Zm1e.He6nbfdXgQrclWLO.qf.wOayUU9oyAa', 'master_scheduler', '', '', '2025-11-07', 'no'),
(4, 'super', '$2b$10$dj.igbJV4Rjd0Elg1zDxdOArhJGq40fvt4Zgc0Uk5K0XC/dK4TYYu', 'super_user', '', '', '2025-11-07', 'no'),
(5, 'Lolo', '$2b$10$kpmGIiZWLjSXQnnXKmc8Q.nEqIxwP79fWimUtCqnpjNKD7Zt4q5Aq', 'admin', '', '', '2025-11-07', 'no');

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
(1, 'WLE 103'),
(2, 'ComLab1'),
(3, 'ComLab2'),
(4, 'ComLab3');

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
(1, 1, 'WLE 103', 0, 0, 'CS_NSTP101'),
(2, 1, 'WLE 103', 0, 1, 'CS_NSTP101'),
(3, 1, 'WLE 103', 0, 2, '0'),
(4, 1, 'WLE 103', 0, 3, '0'),
(5, 1, 'WLE 103', 0, 4, '0'),
(6, 1, 'WLE 103', 0, 5, '0'),
(7, 1, 'WLE 103', 0, 6, '0'),
(8, 1, 'WLE 103', 0, 7, '0'),
(9, 1, 'WLE 103', 0, 8, '0'),
(10, 1, 'WLE 103', 0, 9, '0'),
(11, 1, 'WLE 103', 0, 10, '0'),
(12, 1, 'WLE 103', 0, 11, '0'),
(13, 1, 'WLE 103', 0, 12, '0'),
(14, 1, 'WLE 103', 0, 13, '0'),
(15, 1, 'WLE 103', 0, 14, '0'),
(16, 1, 'WLE 103', 0, 15, '0'),
(17, 1, 'WLE 103', 0, 16, '0'),
(18, 1, 'WLE 103', 0, 17, '0'),
(19, 1, 'WLE 103', 0, 18, '0'),
(20, 1, 'WLE 103', 0, 19, '0'),
(21, 1, 'WLE 103', 0, 20, '0'),
(22, 1, 'WLE 103', 0, 21, '0'),
(23, 1, 'WLE 103', 0, 22, '0'),
(24, 1, 'WLE 103', 0, 23, '0'),
(25, 1, 'WLE 103', 0, 24, '0'),
(26, 1, 'WLE 103', 0, 25, '0'),
(27, 1, 'WLE 103', 0, 26, '0'),
(28, 1, 'WLE 103', 1, 0, '0'),
(29, 1, 'WLE 103', 1, 1, '0'),
(30, 1, 'WLE 103', 1, 2, '0'),
(31, 1, 'WLE 103', 1, 3, '0'),
(32, 1, 'WLE 103', 1, 4, '0'),
(33, 1, 'WLE 103', 1, 5, '0'),
(34, 1, 'WLE 103', 1, 6, '0'),
(35, 1, 'WLE 103', 1, 7, '0'),
(36, 1, 'WLE 103', 1, 8, '0'),
(37, 1, 'WLE 103', 1, 9, '0'),
(38, 1, 'WLE 103', 1, 10, '0'),
(39, 1, 'WLE 103', 1, 11, '0'),
(40, 1, 'WLE 103', 1, 12, '0'),
(41, 1, 'WLE 103', 1, 13, '0'),
(42, 1, 'WLE 103', 1, 14, '0'),
(43, 1, 'WLE 103', 1, 15, '0'),
(44, 1, 'WLE 103', 1, 16, '0'),
(45, 1, 'WLE 103', 1, 17, '0'),
(46, 1, 'WLE 103', 1, 18, '0'),
(47, 1, 'WLE 103', 1, 19, '0'),
(48, 1, 'WLE 103', 1, 20, '0'),
(49, 1, 'WLE 103', 1, 21, '0'),
(50, 1, 'WLE 103', 1, 22, '0'),
(51, 1, 'WLE 103', 1, 23, '0'),
(52, 1, 'WLE 103', 1, 24, '0'),
(53, 1, 'WLE 103', 1, 25, '0'),
(54, 1, 'WLE 103', 1, 26, '0'),
(55, 1, 'WLE 103', 2, 0, 'CS_NSTP101'),
(56, 1, 'WLE 103', 2, 1, 'CS_NSTP101'),
(57, 1, 'WLE 103', 2, 2, '0'),
(58, 1, 'WLE 103', 2, 3, '0'),
(59, 1, 'WLE 103', 2, 4, '0'),
(60, 1, 'WLE 103', 2, 5, '0'),
(61, 1, 'WLE 103', 2, 6, '0'),
(62, 1, 'WLE 103', 2, 7, '0'),
(63, 1, 'WLE 103', 2, 8, '0'),
(64, 1, 'WLE 103', 2, 9, '0'),
(65, 1, 'WLE 103', 2, 10, '0'),
(66, 1, 'WLE 103', 2, 11, '0'),
(67, 1, 'WLE 103', 2, 12, '0'),
(68, 1, 'WLE 103', 2, 13, '0'),
(69, 1, 'WLE 103', 2, 14, '0'),
(70, 1, 'WLE 103', 2, 15, '0'),
(71, 1, 'WLE 103', 2, 16, '0'),
(72, 1, 'WLE 103', 2, 17, '0'),
(73, 1, 'WLE 103', 2, 18, '0'),
(74, 1, 'WLE 103', 2, 19, '0'),
(75, 1, 'WLE 103', 2, 20, '0'),
(76, 1, 'WLE 103', 2, 21, '0'),
(77, 1, 'WLE 103', 2, 22, '0'),
(78, 1, 'WLE 103', 2, 23, '0'),
(79, 1, 'WLE 103', 2, 24, '0'),
(80, 1, 'WLE 103', 2, 25, '0'),
(81, 1, 'WLE 103', 2, 26, '0'),
(82, 1, 'WLE 103', 3, 0, '0'),
(83, 1, 'WLE 103', 3, 1, '0'),
(84, 1, 'WLE 103', 3, 2, '0'),
(85, 1, 'WLE 103', 3, 3, '0'),
(86, 1, 'WLE 103', 3, 4, '0'),
(87, 1, 'WLE 103', 3, 5, '0'),
(88, 1, 'WLE 103', 3, 6, '0'),
(89, 1, 'WLE 103', 3, 7, '0'),
(90, 1, 'WLE 103', 3, 8, '0'),
(91, 1, 'WLE 103', 3, 9, '0'),
(92, 1, 'WLE 103', 3, 10, '0'),
(93, 1, 'WLE 103', 3, 11, '0'),
(94, 1, 'WLE 103', 3, 12, '0'),
(95, 1, 'WLE 103', 3, 13, '0'),
(96, 1, 'WLE 103', 3, 14, '0'),
(97, 1, 'WLE 103', 3, 15, '0'),
(98, 1, 'WLE 103', 3, 16, '0'),
(99, 1, 'WLE 103', 3, 17, '0'),
(100, 1, 'WLE 103', 3, 18, '0'),
(101, 1, 'WLE 103', 3, 19, '0'),
(102, 1, 'WLE 103', 3, 20, '0'),
(103, 1, 'WLE 103', 3, 21, '0'),
(104, 1, 'WLE 103', 3, 22, '0'),
(105, 1, 'WLE 103', 3, 23, '0'),
(106, 1, 'WLE 103', 3, 24, '0'),
(107, 1, 'WLE 103', 3, 25, '0'),
(108, 1, 'WLE 103', 3, 26, '0'),
(109, 1, 'WLE 103', 4, 0, 'CS_NSTP101'),
(110, 1, 'WLE 103', 4, 1, 'CS_NSTP101'),
(111, 1, 'WLE 103', 4, 2, '0'),
(112, 1, 'WLE 103', 4, 3, '0'),
(113, 1, 'WLE 103', 4, 4, '0'),
(114, 1, 'WLE 103', 4, 5, '0'),
(115, 1, 'WLE 103', 4, 6, '0'),
(116, 1, 'WLE 103', 4, 7, '0'),
(117, 1, 'WLE 103', 4, 8, '0'),
(118, 1, 'WLE 103', 4, 9, '0'),
(119, 1, 'WLE 103', 4, 10, '0'),
(120, 1, 'WLE 103', 4, 11, '0'),
(121, 1, 'WLE 103', 4, 12, '0'),
(122, 1, 'WLE 103', 4, 13, '0'),
(123, 1, 'WLE 103', 4, 14, '0'),
(124, 1, 'WLE 103', 4, 15, '0'),
(125, 1, 'WLE 103', 4, 16, '0'),
(126, 1, 'WLE 103', 4, 17, '0'),
(127, 1, 'WLE 103', 4, 18, '0'),
(128, 1, 'WLE 103', 4, 19, '0'),
(129, 1, 'WLE 103', 4, 20, '0'),
(130, 1, 'WLE 103', 4, 21, '0'),
(131, 1, 'WLE 103', 4, 22, '0'),
(132, 1, 'WLE 103', 4, 23, '0'),
(133, 1, 'WLE 103', 4, 24, '0'),
(134, 1, 'WLE 103', 4, 25, '0'),
(135, 1, 'WLE 103', 4, 26, '0'),
(136, 2, 'ComLab1', 0, 0, '0'),
(137, 2, 'ComLab1', 0, 1, '0'),
(138, 2, 'ComLab1', 0, 2, '0'),
(139, 2, 'ComLab1', 0, 3, '0'),
(140, 2, 'ComLab1', 0, 4, '0'),
(141, 2, 'ComLab1', 0, 5, '0'),
(142, 2, 'ComLab1', 0, 6, '0'),
(143, 2, 'ComLab1', 0, 7, '0'),
(144, 2, 'ComLab1', 0, 8, '0'),
(145, 2, 'ComLab1', 0, 9, '0'),
(146, 2, 'ComLab1', 0, 10, '0'),
(147, 2, 'ComLab1', 0, 11, '0'),
(148, 2, 'ComLab1', 0, 12, '0'),
(149, 2, 'ComLab1', 0, 13, '0'),
(150, 2, 'ComLab1', 0, 14, '0'),
(151, 2, 'ComLab1', 0, 15, '0'),
(152, 2, 'ComLab1', 0, 16, '0'),
(153, 2, 'ComLab1', 0, 17, '0'),
(154, 2, 'ComLab1', 0, 18, '0'),
(155, 2, 'ComLab1', 0, 19, '0'),
(156, 2, 'ComLab1', 0, 20, '0'),
(157, 2, 'ComLab1', 0, 21, '0'),
(158, 2, 'ComLab1', 0, 22, '0'),
(159, 2, 'ComLab1', 0, 23, '0'),
(160, 2, 'ComLab1', 0, 24, '0'),
(161, 2, 'ComLab1', 0, 25, '0'),
(162, 2, 'ComLab1', 0, 26, '0'),
(163, 2, 'ComLab1', 1, 0, '0'),
(164, 2, 'ComLab1', 1, 1, '0'),
(165, 2, 'ComLab1', 1, 2, '0'),
(166, 2, 'ComLab1', 1, 3, '0'),
(167, 2, 'ComLab1', 1, 4, '0'),
(168, 2, 'ComLab1', 1, 5, '0'),
(169, 2, 'ComLab1', 1, 6, '0'),
(170, 2, 'ComLab1', 1, 7, '0'),
(171, 2, 'ComLab1', 1, 8, '0'),
(172, 2, 'ComLab1', 1, 9, '0'),
(173, 2, 'ComLab1', 1, 10, '0'),
(174, 2, 'ComLab1', 1, 11, '0'),
(175, 2, 'ComLab1', 1, 12, '0'),
(176, 2, 'ComLab1', 1, 13, '0'),
(177, 2, 'ComLab1', 1, 14, '0'),
(178, 2, 'ComLab1', 1, 15, '0'),
(179, 2, 'ComLab1', 1, 16, '0'),
(180, 2, 'ComLab1', 1, 17, '0'),
(181, 2, 'ComLab1', 1, 18, '0'),
(182, 2, 'ComLab1', 1, 19, '0'),
(183, 2, 'ComLab1', 1, 20, '0'),
(184, 2, 'ComLab1', 1, 21, '0'),
(185, 2, 'ComLab1', 1, 22, '0'),
(186, 2, 'ComLab1', 1, 23, '0'),
(187, 2, 'ComLab1', 1, 24, '0'),
(188, 2, 'ComLab1', 1, 25, '0'),
(189, 2, 'ComLab1', 1, 26, '0'),
(190, 2, 'ComLab1', 2, 0, '0'),
(191, 2, 'ComLab1', 2, 1, '0'),
(192, 2, 'ComLab1', 2, 2, '0'),
(193, 2, 'ComLab1', 2, 3, '0'),
(194, 2, 'ComLab1', 2, 4, '0'),
(195, 2, 'ComLab1', 2, 5, '0'),
(196, 2, 'ComLab1', 2, 6, '0'),
(197, 2, 'ComLab1', 2, 7, '0'),
(198, 2, 'ComLab1', 2, 8, '0'),
(199, 2, 'ComLab1', 2, 9, '0'),
(200, 2, 'ComLab1', 2, 10, '0'),
(201, 2, 'ComLab1', 2, 11, '0'),
(202, 2, 'ComLab1', 2, 12, '0'),
(203, 2, 'ComLab1', 2, 13, '0'),
(204, 2, 'ComLab1', 2, 14, '0'),
(205, 2, 'ComLab1', 2, 15, '0'),
(206, 2, 'ComLab1', 2, 16, '0'),
(207, 2, 'ComLab1', 2, 17, '0'),
(208, 2, 'ComLab1', 2, 18, '0'),
(209, 2, 'ComLab1', 2, 19, '0'),
(210, 2, 'ComLab1', 2, 20, '0'),
(211, 2, 'ComLab1', 2, 21, '0'),
(212, 2, 'ComLab1', 2, 22, '0'),
(213, 2, 'ComLab1', 2, 23, '0'),
(214, 2, 'ComLab1', 2, 24, '0'),
(215, 2, 'ComLab1', 2, 25, '0'),
(216, 2, 'ComLab1', 2, 26, '0'),
(217, 2, 'ComLab1', 3, 0, '0'),
(218, 2, 'ComLab1', 3, 1, '0'),
(219, 2, 'ComLab1', 3, 2, '0'),
(220, 2, 'ComLab1', 3, 3, '0'),
(221, 2, 'ComLab1', 3, 4, '0'),
(222, 2, 'ComLab1', 3, 5, '0'),
(223, 2, 'ComLab1', 3, 6, '0'),
(224, 2, 'ComLab1', 3, 7, '0'),
(225, 2, 'ComLab1', 3, 8, '0'),
(226, 2, 'ComLab1', 3, 9, '0'),
(227, 2, 'ComLab1', 3, 10, '0'),
(228, 2, 'ComLab1', 3, 11, '0'),
(229, 2, 'ComLab1', 3, 12, '0'),
(230, 2, 'ComLab1', 3, 13, '0'),
(231, 2, 'ComLab1', 3, 14, '0'),
(232, 2, 'ComLab1', 3, 15, '0'),
(233, 2, 'ComLab1', 3, 16, '0'),
(234, 2, 'ComLab1', 3, 17, '0'),
(235, 2, 'ComLab1', 3, 18, '0'),
(236, 2, 'ComLab1', 3, 19, '0'),
(237, 2, 'ComLab1', 3, 20, '0'),
(238, 2, 'ComLab1', 3, 21, '0'),
(239, 2, 'ComLab1', 3, 22, '0'),
(240, 2, 'ComLab1', 3, 23, '0'),
(241, 2, 'ComLab1', 3, 24, '0'),
(242, 2, 'ComLab1', 3, 25, '0'),
(243, 2, 'ComLab1', 3, 26, '0'),
(244, 2, 'ComLab1', 4, 0, '0'),
(245, 2, 'ComLab1', 4, 1, '0'),
(246, 2, 'ComLab1', 4, 2, '0'),
(247, 2, 'ComLab1', 4, 3, '0'),
(248, 2, 'ComLab1', 4, 4, '0'),
(249, 2, 'ComLab1', 4, 5, '0'),
(250, 2, 'ComLab1', 4, 6, '0'),
(251, 2, 'ComLab1', 4, 7, '0'),
(252, 2, 'ComLab1', 4, 8, '0'),
(253, 2, 'ComLab1', 4, 9, '0'),
(254, 2, 'ComLab1', 4, 10, '0'),
(255, 2, 'ComLab1', 4, 11, '0'),
(256, 2, 'ComLab1', 4, 12, '0'),
(257, 2, 'ComLab1', 4, 13, '0'),
(258, 2, 'ComLab1', 4, 14, '0'),
(259, 2, 'ComLab1', 4, 15, '0'),
(260, 2, 'ComLab1', 4, 16, '0'),
(261, 2, 'ComLab1', 4, 17, '0'),
(262, 2, 'ComLab1', 4, 18, '0'),
(263, 2, 'ComLab1', 4, 19, '0'),
(264, 2, 'ComLab1', 4, 20, '0'),
(265, 2, 'ComLab1', 4, 21, '0'),
(266, 2, 'ComLab1', 4, 22, '0'),
(267, 2, 'ComLab1', 4, 23, '0'),
(268, 2, 'ComLab1', 4, 24, '0'),
(269, 2, 'ComLab1', 4, 25, '0'),
(270, 2, 'ComLab1', 4, 26, '0'),
(271, 3, 'ComLab2', 0, 0, '0'),
(272, 3, 'ComLab2', 0, 1, '0'),
(273, 3, 'ComLab2', 0, 2, '0'),
(274, 3, 'ComLab2', 0, 3, '0'),
(275, 3, 'ComLab2', 0, 4, '0'),
(276, 3, 'ComLab2', 0, 5, '0'),
(277, 3, 'ComLab2', 0, 6, '0'),
(278, 3, 'ComLab2', 0, 7, '0'),
(279, 3, 'ComLab2', 0, 8, '0'),
(280, 3, 'ComLab2', 0, 9, '0'),
(281, 3, 'ComLab2', 0, 10, '0'),
(282, 3, 'ComLab2', 0, 11, '0'),
(283, 3, 'ComLab2', 0, 12, '0'),
(284, 3, 'ComLab2', 0, 13, '0'),
(285, 3, 'ComLab2', 0, 14, '0'),
(286, 3, 'ComLab2', 0, 15, '0'),
(287, 3, 'ComLab2', 0, 16, '0'),
(288, 3, 'ComLab2', 0, 17, '0'),
(289, 3, 'ComLab2', 0, 18, '0'),
(290, 3, 'ComLab2', 0, 19, '0'),
(291, 3, 'ComLab2', 0, 20, '0'),
(292, 3, 'ComLab2', 0, 21, '0'),
(293, 3, 'ComLab2', 0, 22, '0'),
(294, 3, 'ComLab2', 0, 23, '0'),
(295, 3, 'ComLab2', 0, 24, '0'),
(296, 3, 'ComLab2', 0, 25, '0'),
(297, 3, 'ComLab2', 0, 26, '0'),
(298, 3, 'ComLab2', 1, 0, '0'),
(299, 3, 'ComLab2', 1, 1, '0'),
(300, 3, 'ComLab2', 1, 2, '0'),
(301, 3, 'ComLab2', 1, 3, '0'),
(302, 3, 'ComLab2', 1, 4, '0'),
(303, 3, 'ComLab2', 1, 5, '0'),
(304, 3, 'ComLab2', 1, 6, '0'),
(305, 3, 'ComLab2', 1, 7, '0'),
(306, 3, 'ComLab2', 1, 8, '0'),
(307, 3, 'ComLab2', 1, 9, '0'),
(308, 3, 'ComLab2', 1, 10, '0'),
(309, 3, 'ComLab2', 1, 11, '0'),
(310, 3, 'ComLab2', 1, 12, '0'),
(311, 3, 'ComLab2', 1, 13, '0'),
(312, 3, 'ComLab2', 1, 14, '0'),
(313, 3, 'ComLab2', 1, 15, '0'),
(314, 3, 'ComLab2', 1, 16, '0'),
(315, 3, 'ComLab2', 1, 17, '0'),
(316, 3, 'ComLab2', 1, 18, '0'),
(317, 3, 'ComLab2', 1, 19, '0'),
(318, 3, 'ComLab2', 1, 20, '0'),
(319, 3, 'ComLab2', 1, 21, '0'),
(320, 3, 'ComLab2', 1, 22, '0'),
(321, 3, 'ComLab2', 1, 23, '0'),
(322, 3, 'ComLab2', 1, 24, '0'),
(323, 3, 'ComLab2', 1, 25, '0'),
(324, 3, 'ComLab2', 1, 26, '0'),
(325, 3, 'ComLab2', 2, 0, '0'),
(326, 3, 'ComLab2', 2, 1, '0'),
(327, 3, 'ComLab2', 2, 2, '0'),
(328, 3, 'ComLab2', 2, 3, '0'),
(329, 3, 'ComLab2', 2, 4, '0'),
(330, 3, 'ComLab2', 2, 5, '0'),
(331, 3, 'ComLab2', 2, 6, '0'),
(332, 3, 'ComLab2', 2, 7, '0'),
(333, 3, 'ComLab2', 2, 8, '0'),
(334, 3, 'ComLab2', 2, 9, '0'),
(335, 3, 'ComLab2', 2, 10, '0'),
(336, 3, 'ComLab2', 2, 11, '0'),
(337, 3, 'ComLab2', 2, 12, '0'),
(338, 3, 'ComLab2', 2, 13, '0'),
(339, 3, 'ComLab2', 2, 14, '0'),
(340, 3, 'ComLab2', 2, 15, '0'),
(341, 3, 'ComLab2', 2, 16, '0'),
(342, 3, 'ComLab2', 2, 17, '0'),
(343, 3, 'ComLab2', 2, 18, '0'),
(344, 3, 'ComLab2', 2, 19, '0'),
(345, 3, 'ComLab2', 2, 20, '0'),
(346, 3, 'ComLab2', 2, 21, '0'),
(347, 3, 'ComLab2', 2, 22, '0'),
(348, 3, 'ComLab2', 2, 23, '0'),
(349, 3, 'ComLab2', 2, 24, '0'),
(350, 3, 'ComLab2', 2, 25, '0'),
(351, 3, 'ComLab2', 2, 26, '0'),
(352, 3, 'ComLab2', 3, 0, '0'),
(353, 3, 'ComLab2', 3, 1, '0'),
(354, 3, 'ComLab2', 3, 2, '0'),
(355, 3, 'ComLab2', 3, 3, '0'),
(356, 3, 'ComLab2', 3, 4, '0'),
(357, 3, 'ComLab2', 3, 5, '0'),
(358, 3, 'ComLab2', 3, 6, '0'),
(359, 3, 'ComLab2', 3, 7, '0'),
(360, 3, 'ComLab2', 3, 8, '0'),
(361, 3, 'ComLab2', 3, 9, '0'),
(362, 3, 'ComLab2', 3, 10, '0'),
(363, 3, 'ComLab2', 3, 11, '0'),
(364, 3, 'ComLab2', 3, 12, '0'),
(365, 3, 'ComLab2', 3, 13, '0'),
(366, 3, 'ComLab2', 3, 14, '0'),
(367, 3, 'ComLab2', 3, 15, '0'),
(368, 3, 'ComLab2', 3, 16, '0'),
(369, 3, 'ComLab2', 3, 17, '0'),
(370, 3, 'ComLab2', 3, 18, '0'),
(371, 3, 'ComLab2', 3, 19, '0'),
(372, 3, 'ComLab2', 3, 20, '0'),
(373, 3, 'ComLab2', 3, 21, '0'),
(374, 3, 'ComLab2', 3, 22, '0'),
(375, 3, 'ComLab2', 3, 23, '0'),
(376, 3, 'ComLab2', 3, 24, '0'),
(377, 3, 'ComLab2', 3, 25, '0'),
(378, 3, 'ComLab2', 3, 26, '0'),
(379, 3, 'ComLab2', 4, 0, '0'),
(380, 3, 'ComLab2', 4, 1, '0'),
(381, 3, 'ComLab2', 4, 2, '0'),
(382, 3, 'ComLab2', 4, 3, '0'),
(383, 3, 'ComLab2', 4, 4, '0'),
(384, 3, 'ComLab2', 4, 5, '0'),
(385, 3, 'ComLab2', 4, 6, '0'),
(386, 3, 'ComLab2', 4, 7, '0'),
(387, 3, 'ComLab2', 4, 8, '0'),
(388, 3, 'ComLab2', 4, 9, '0'),
(389, 3, 'ComLab2', 4, 10, '0'),
(390, 3, 'ComLab2', 4, 11, '0'),
(391, 3, 'ComLab2', 4, 12, '0'),
(392, 3, 'ComLab2', 4, 13, '0'),
(393, 3, 'ComLab2', 4, 14, '0'),
(394, 3, 'ComLab2', 4, 15, '0'),
(395, 3, 'ComLab2', 4, 16, '0'),
(396, 3, 'ComLab2', 4, 17, '0'),
(397, 3, 'ComLab2', 4, 18, '0'),
(398, 3, 'ComLab2', 4, 19, '0'),
(399, 3, 'ComLab2', 4, 20, '0'),
(400, 3, 'ComLab2', 4, 21, '0'),
(401, 3, 'ComLab2', 4, 22, '0'),
(402, 3, 'ComLab2', 4, 23, '0'),
(403, 3, 'ComLab2', 4, 24, '0'),
(404, 3, 'ComLab2', 4, 25, '0'),
(405, 3, 'ComLab2', 4, 26, '0'),
(406, 4, 'ComLab3', 0, 0, '0'),
(407, 4, 'ComLab3', 0, 1, '0'),
(408, 4, 'ComLab3', 0, 2, '0'),
(409, 4, 'ComLab3', 0, 3, '0'),
(410, 4, 'ComLab3', 0, 4, '0'),
(411, 4, 'ComLab3', 0, 5, '0'),
(412, 4, 'ComLab3', 0, 6, '0'),
(413, 4, 'ComLab3', 0, 7, '0'),
(414, 4, 'ComLab3', 0, 8, '0'),
(415, 4, 'ComLab3', 0, 9, '0'),
(416, 4, 'ComLab3', 0, 10, '0'),
(417, 4, 'ComLab3', 0, 11, '0'),
(418, 4, 'ComLab3', 0, 12, '0'),
(419, 4, 'ComLab3', 0, 13, '0'),
(420, 4, 'ComLab3', 0, 14, '0'),
(421, 4, 'ComLab3', 0, 15, '0'),
(422, 4, 'ComLab3', 0, 16, '0'),
(423, 4, 'ComLab3', 0, 17, '0'),
(424, 4, 'ComLab3', 0, 18, '0'),
(425, 4, 'ComLab3', 0, 19, '0'),
(426, 4, 'ComLab3', 0, 20, '0'),
(427, 4, 'ComLab3', 0, 21, '0'),
(428, 4, 'ComLab3', 0, 22, '0'),
(429, 4, 'ComLab3', 0, 23, '0'),
(430, 4, 'ComLab3', 0, 24, '0'),
(431, 4, 'ComLab3', 0, 25, '0'),
(432, 4, 'ComLab3', 0, 26, '0'),
(433, 4, 'ComLab3', 1, 0, '0'),
(434, 4, 'ComLab3', 1, 1, '0'),
(435, 4, 'ComLab3', 1, 2, '0'),
(436, 4, 'ComLab3', 1, 3, '0'),
(437, 4, 'ComLab3', 1, 4, '0'),
(438, 4, 'ComLab3', 1, 5, '0'),
(439, 4, 'ComLab3', 1, 6, '0'),
(440, 4, 'ComLab3', 1, 7, '0'),
(441, 4, 'ComLab3', 1, 8, '0'),
(442, 4, 'ComLab3', 1, 9, '0'),
(443, 4, 'ComLab3', 1, 10, '0'),
(444, 4, 'ComLab3', 1, 11, '0'),
(445, 4, 'ComLab3', 1, 12, '0'),
(446, 4, 'ComLab3', 1, 13, '0'),
(447, 4, 'ComLab3', 1, 14, '0'),
(448, 4, 'ComLab3', 1, 15, '0'),
(449, 4, 'ComLab3', 1, 16, '0'),
(450, 4, 'ComLab3', 1, 17, '0'),
(451, 4, 'ComLab3', 1, 18, '0'),
(452, 4, 'ComLab3', 1, 19, '0'),
(453, 4, 'ComLab3', 1, 20, '0'),
(454, 4, 'ComLab3', 1, 21, '0'),
(455, 4, 'ComLab3', 1, 22, '0'),
(456, 4, 'ComLab3', 1, 23, '0'),
(457, 4, 'ComLab3', 1, 24, '0'),
(458, 4, 'ComLab3', 1, 25, '0'),
(459, 4, 'ComLab3', 1, 26, '0'),
(460, 4, 'ComLab3', 2, 0, '0'),
(461, 4, 'ComLab3', 2, 1, '0'),
(462, 4, 'ComLab3', 2, 2, '0'),
(463, 4, 'ComLab3', 2, 3, '0'),
(464, 4, 'ComLab3', 2, 4, '0'),
(465, 4, 'ComLab3', 2, 5, '0'),
(466, 4, 'ComLab3', 2, 6, '0'),
(467, 4, 'ComLab3', 2, 7, '0'),
(468, 4, 'ComLab3', 2, 8, '0'),
(469, 4, 'ComLab3', 2, 9, '0'),
(470, 4, 'ComLab3', 2, 10, '0'),
(471, 4, 'ComLab3', 2, 11, '0'),
(472, 4, 'ComLab3', 2, 12, '0'),
(473, 4, 'ComLab3', 2, 13, '0'),
(474, 4, 'ComLab3', 2, 14, '0'),
(475, 4, 'ComLab3', 2, 15, '0'),
(476, 4, 'ComLab3', 2, 16, '0'),
(477, 4, 'ComLab3', 2, 17, '0'),
(478, 4, 'ComLab3', 2, 18, '0'),
(479, 4, 'ComLab3', 2, 19, '0'),
(480, 4, 'ComLab3', 2, 20, '0'),
(481, 4, 'ComLab3', 2, 21, '0'),
(482, 4, 'ComLab3', 2, 22, '0'),
(483, 4, 'ComLab3', 2, 23, '0'),
(484, 4, 'ComLab3', 2, 24, '0'),
(485, 4, 'ComLab3', 2, 25, '0'),
(486, 4, 'ComLab3', 2, 26, '0'),
(487, 4, 'ComLab3', 3, 0, '0'),
(488, 4, 'ComLab3', 3, 1, '0'),
(489, 4, 'ComLab3', 3, 2, '0'),
(490, 4, 'ComLab3', 3, 3, '0'),
(491, 4, 'ComLab3', 3, 4, '0'),
(492, 4, 'ComLab3', 3, 5, '0'),
(493, 4, 'ComLab3', 3, 6, '0'),
(494, 4, 'ComLab3', 3, 7, '0'),
(495, 4, 'ComLab3', 3, 8, '0'),
(496, 4, 'ComLab3', 3, 9, '0'),
(497, 4, 'ComLab3', 3, 10, '0'),
(498, 4, 'ComLab3', 3, 11, '0'),
(499, 4, 'ComLab3', 3, 12, '0'),
(500, 4, 'ComLab3', 3, 13, '0'),
(501, 4, 'ComLab3', 3, 14, '0'),
(502, 4, 'ComLab3', 3, 15, '0'),
(503, 4, 'ComLab3', 3, 16, '0'),
(504, 4, 'ComLab3', 3, 17, '0'),
(505, 4, 'ComLab3', 3, 18, '0'),
(506, 4, 'ComLab3', 3, 19, '0'),
(507, 4, 'ComLab3', 3, 20, '0'),
(508, 4, 'ComLab3', 3, 21, '0'),
(509, 4, 'ComLab3', 3, 22, '0'),
(510, 4, 'ComLab3', 3, 23, '0'),
(511, 4, 'ComLab3', 3, 24, '0'),
(512, 4, 'ComLab3', 3, 25, '0'),
(513, 4, 'ComLab3', 3, 26, '0'),
(514, 4, 'ComLab3', 4, 0, '0'),
(515, 4, 'ComLab3', 4, 1, '0'),
(516, 4, 'ComLab3', 4, 2, '0'),
(517, 4, 'ComLab3', 4, 3, '0'),
(518, 4, 'ComLab3', 4, 4, '0'),
(519, 4, 'ComLab3', 4, 5, '0'),
(520, 4, 'ComLab3', 4, 6, '0'),
(521, 4, 'ComLab3', 4, 7, '0'),
(522, 4, 'ComLab3', 4, 8, '0'),
(523, 4, 'ComLab3', 4, 9, '0'),
(524, 4, 'ComLab3', 4, 10, '0'),
(525, 4, 'ComLab3', 4, 11, '0'),
(526, 4, 'ComLab3', 4, 12, '0'),
(527, 4, 'ComLab3', 4, 13, '0'),
(528, 4, 'ComLab3', 4, 14, '0'),
(529, 4, 'ComLab3', 4, 15, '0'),
(530, 4, 'ComLab3', 4, 16, '0'),
(531, 4, 'ComLab3', 4, 17, '0'),
(532, 4, 'ComLab3', 4, 18, '0'),
(533, 4, 'ComLab3', 4, 19, '0'),
(534, 4, 'ComLab3', 4, 20, '0'),
(535, 4, 'ComLab3', 4, 21, '0'),
(536, 4, 'ComLab3', 4, 22, '0'),
(537, 4, 'ComLab3', 4, 23, '0'),
(538, 4, 'ComLab3', 4, 24, '0'),
(539, 4, 'ComLab3', 4, 25, '0'),
(540, 4, 'ComLab3', 4, 26, '0');

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
(1, 'Aldwin', 'Ilumin', NULL, 'full'),
(2, 'Wishiel', 'Ilumin', NULL, 'full'),
(3, 'Noelyn', 'Sebua', NULL, 'full'),
(4, 'Karen', 'Hermosa', NULL, 'full');

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
(1, 1, 0, 0, 'CS_NSTP101'),
(2, 1, 0, 1, 'CS_NSTP101'),
(3, 1, 0, 2, '0'),
(4, 1, 0, 3, '0'),
(5, 1, 0, 4, '0'),
(6, 1, 0, 5, '0'),
(7, 1, 0, 6, '0'),
(8, 1, 0, 7, '0'),
(9, 1, 0, 8, '0'),
(10, 1, 0, 9, '0'),
(11, 1, 0, 10, '0'),
(12, 1, 0, 11, '0'),
(13, 1, 0, 12, '0'),
(14, 1, 0, 13, '0'),
(15, 1, 0, 14, '0'),
(16, 1, 0, 15, '0'),
(17, 1, 0, 16, '0'),
(18, 1, 0, 17, '0'),
(19, 1, 0, 18, '0'),
(20, 1, 0, 19, '0'),
(21, 1, 0, 20, '0'),
(22, 1, 0, 21, '0'),
(23, 1, 0, 22, '0'),
(24, 1, 0, 23, '0'),
(25, 1, 0, 24, '0'),
(26, 1, 0, 25, '0'),
(27, 1, 0, 26, '0'),
(28, 1, 1, 0, '0'),
(29, 1, 1, 1, '0'),
(30, 1, 1, 2, '0'),
(31, 1, 1, 3, '0'),
(32, 1, 1, 4, '0'),
(33, 1, 1, 5, '0'),
(34, 1, 1, 6, '0'),
(35, 1, 1, 7, '0'),
(36, 1, 1, 8, '0'),
(37, 1, 1, 9, '0'),
(38, 1, 1, 10, '0'),
(39, 1, 1, 11, '0'),
(40, 1, 1, 12, '0'),
(41, 1, 1, 13, '0'),
(42, 1, 1, 14, '0'),
(43, 1, 1, 15, '0'),
(44, 1, 1, 16, '0'),
(45, 1, 1, 17, '0'),
(46, 1, 1, 18, '0'),
(47, 1, 1, 19, '0'),
(48, 1, 1, 20, '0'),
(49, 1, 1, 21, '0'),
(50, 1, 1, 22, '0'),
(51, 1, 1, 23, '0'),
(52, 1, 1, 24, '0'),
(53, 1, 1, 25, '0'),
(54, 1, 1, 26, '0'),
(55, 1, 2, 0, 'CS_NSTP101'),
(56, 1, 2, 1, 'CS_NSTP101'),
(57, 1, 2, 2, '0'),
(58, 1, 2, 3, '0'),
(59, 1, 2, 4, '0'),
(60, 1, 2, 5, '0'),
(61, 1, 2, 6, '0'),
(62, 1, 2, 7, '0'),
(63, 1, 2, 8, '0'),
(64, 1, 2, 9, '0'),
(65, 1, 2, 10, '0'),
(66, 1, 2, 11, '0'),
(67, 1, 2, 12, '0'),
(68, 1, 2, 13, '0'),
(69, 1, 2, 14, '0'),
(70, 1, 2, 15, '0'),
(71, 1, 2, 16, '0'),
(72, 1, 2, 17, '0'),
(73, 1, 2, 18, '0'),
(74, 1, 2, 19, '0'),
(75, 1, 2, 20, '0'),
(76, 1, 2, 21, '0'),
(77, 1, 2, 22, '0'),
(78, 1, 2, 23, '0'),
(79, 1, 2, 24, '0'),
(80, 1, 2, 25, '0'),
(81, 1, 2, 26, '0'),
(82, 1, 3, 0, '0'),
(83, 1, 3, 1, '0'),
(84, 1, 3, 2, '0'),
(85, 1, 3, 3, '0'),
(86, 1, 3, 4, '0'),
(87, 1, 3, 5, '0'),
(88, 1, 3, 6, '0'),
(89, 1, 3, 7, '0'),
(90, 1, 3, 8, '0'),
(91, 1, 3, 9, '0'),
(92, 1, 3, 10, '0'),
(93, 1, 3, 11, '0'),
(94, 1, 3, 12, '0'),
(95, 1, 3, 13, '0'),
(96, 1, 3, 14, '0'),
(97, 1, 3, 15, '0'),
(98, 1, 3, 16, '0'),
(99, 1, 3, 17, '0'),
(100, 1, 3, 18, '0'),
(101, 1, 3, 19, '0'),
(102, 1, 3, 20, '0'),
(103, 1, 3, 21, '0'),
(104, 1, 3, 22, '0'),
(105, 1, 3, 23, '0'),
(106, 1, 3, 24, '0'),
(107, 1, 3, 25, '0'),
(108, 1, 3, 26, '0'),
(109, 1, 4, 0, 'CS_NSTP101'),
(110, 1, 4, 1, 'CS_NSTP101'),
(111, 1, 4, 2, '0'),
(112, 1, 4, 3, '0'),
(113, 1, 4, 4, '0'),
(114, 1, 4, 5, '0'),
(115, 1, 4, 6, '0'),
(116, 1, 4, 7, '0'),
(117, 1, 4, 8, '0'),
(118, 1, 4, 9, '0'),
(119, 1, 4, 10, '0'),
(120, 1, 4, 11, '0'),
(121, 1, 4, 12, '0'),
(122, 1, 4, 13, '0'),
(123, 1, 4, 14, '0'),
(124, 1, 4, 15, '0'),
(125, 1, 4, 16, '0'),
(126, 1, 4, 17, '0'),
(127, 1, 4, 18, '0'),
(128, 1, 4, 19, '0'),
(129, 1, 4, 20, '0'),
(130, 1, 4, 21, '0'),
(131, 1, 4, 22, '0'),
(132, 1, 4, 23, '0'),
(133, 1, 4, 24, '0'),
(134, 1, 4, 25, '0'),
(135, 1, 4, 26, '0'),
(136, 2, 0, 0, '0'),
(137, 2, 0, 1, '0'),
(138, 2, 0, 2, '0'),
(139, 2, 0, 3, '0'),
(140, 2, 0, 4, '0'),
(141, 2, 0, 5, '0'),
(142, 2, 0, 6, '0'),
(143, 2, 0, 7, '0'),
(144, 2, 0, 8, '0'),
(145, 2, 0, 9, '0'),
(146, 2, 0, 10, '0'),
(147, 2, 0, 11, '0'),
(148, 2, 0, 12, '0'),
(149, 2, 0, 13, '0'),
(150, 2, 0, 14, '0'),
(151, 2, 0, 15, '0'),
(152, 2, 0, 16, '0'),
(153, 2, 0, 17, '0'),
(154, 2, 0, 18, '0'),
(155, 2, 0, 19, '0'),
(156, 2, 0, 20, '0'),
(157, 2, 0, 21, '0'),
(158, 2, 0, 22, '0'),
(159, 2, 0, 23, '0'),
(160, 2, 0, 24, '0'),
(161, 2, 0, 25, '0'),
(162, 2, 0, 26, '0'),
(163, 2, 1, 0, '0'),
(164, 2, 1, 1, '0'),
(165, 2, 1, 2, '0'),
(166, 2, 1, 3, '0'),
(167, 2, 1, 4, '0'),
(168, 2, 1, 5, '0'),
(169, 2, 1, 6, '0'),
(170, 2, 1, 7, '0'),
(171, 2, 1, 8, '0'),
(172, 2, 1, 9, '0'),
(173, 2, 1, 10, '0'),
(174, 2, 1, 11, '0'),
(175, 2, 1, 12, '0'),
(176, 2, 1, 13, '0'),
(177, 2, 1, 14, '0'),
(178, 2, 1, 15, '0'),
(179, 2, 1, 16, '0'),
(180, 2, 1, 17, '0'),
(181, 2, 1, 18, '0'),
(182, 2, 1, 19, '0'),
(183, 2, 1, 20, '0'),
(184, 2, 1, 21, '0'),
(185, 2, 1, 22, '0'),
(186, 2, 1, 23, '0'),
(187, 2, 1, 24, '0'),
(188, 2, 1, 25, '0'),
(189, 2, 1, 26, '0'),
(190, 2, 2, 0, '0'),
(191, 2, 2, 1, '0'),
(192, 2, 2, 2, '0'),
(193, 2, 2, 3, '0'),
(194, 2, 2, 4, '0'),
(195, 2, 2, 5, '0'),
(196, 2, 2, 6, '0'),
(197, 2, 2, 7, '0'),
(198, 2, 2, 8, '0'),
(199, 2, 2, 9, '0'),
(200, 2, 2, 10, '0'),
(201, 2, 2, 11, '0'),
(202, 2, 2, 12, '0'),
(203, 2, 2, 13, '0'),
(204, 2, 2, 14, '0'),
(205, 2, 2, 15, '0'),
(206, 2, 2, 16, '0'),
(207, 2, 2, 17, '0'),
(208, 2, 2, 18, '0'),
(209, 2, 2, 19, '0'),
(210, 2, 2, 20, '0'),
(211, 2, 2, 21, '0'),
(212, 2, 2, 22, '0'),
(213, 2, 2, 23, '0'),
(214, 2, 2, 24, '0'),
(215, 2, 2, 25, '0'),
(216, 2, 2, 26, '0'),
(217, 2, 3, 0, '0'),
(218, 2, 3, 1, '0'),
(219, 2, 3, 2, '0'),
(220, 2, 3, 3, '0'),
(221, 2, 3, 4, '0'),
(222, 2, 3, 5, '0'),
(223, 2, 3, 6, '0'),
(224, 2, 3, 7, '0'),
(225, 2, 3, 8, '0'),
(226, 2, 3, 9, '0'),
(227, 2, 3, 10, '0'),
(228, 2, 3, 11, '0'),
(229, 2, 3, 12, '0'),
(230, 2, 3, 13, '0'),
(231, 2, 3, 14, '0'),
(232, 2, 3, 15, '0'),
(233, 2, 3, 16, '0'),
(234, 2, 3, 17, '0'),
(235, 2, 3, 18, '0'),
(236, 2, 3, 19, '0'),
(237, 2, 3, 20, '0'),
(238, 2, 3, 21, '0'),
(239, 2, 3, 22, '0'),
(240, 2, 3, 23, '0'),
(241, 2, 3, 24, '0'),
(242, 2, 3, 25, '0'),
(243, 2, 3, 26, '0'),
(244, 2, 4, 0, '0'),
(245, 2, 4, 1, '0'),
(246, 2, 4, 2, '0'),
(247, 2, 4, 3, '0'),
(248, 2, 4, 4, '0'),
(249, 2, 4, 5, '0'),
(250, 2, 4, 6, '0'),
(251, 2, 4, 7, '0'),
(252, 2, 4, 8, '0'),
(253, 2, 4, 9, '0'),
(254, 2, 4, 10, '0'),
(255, 2, 4, 11, '0'),
(256, 2, 4, 12, '0'),
(257, 2, 4, 13, '0'),
(258, 2, 4, 14, '0'),
(259, 2, 4, 15, '0'),
(260, 2, 4, 16, '0'),
(261, 2, 4, 17, '0'),
(262, 2, 4, 18, '0'),
(263, 2, 4, 19, '0'),
(264, 2, 4, 20, '0'),
(265, 2, 4, 21, '0'),
(266, 2, 4, 22, '0'),
(267, 2, 4, 23, '0'),
(268, 2, 4, 24, '0'),
(269, 2, 4, 25, '0'),
(270, 2, 4, 26, '0'),
(271, 3, 0, 0, '0'),
(272, 3, 0, 1, '0'),
(273, 3, 0, 2, '0'),
(274, 3, 0, 3, '0'),
(275, 3, 0, 4, '0'),
(276, 3, 0, 5, '0'),
(277, 3, 0, 6, '0'),
(278, 3, 0, 7, '0'),
(279, 3, 0, 8, '0'),
(280, 3, 0, 9, '0'),
(281, 3, 0, 10, '0'),
(282, 3, 0, 11, '0'),
(283, 3, 0, 12, '0'),
(284, 3, 0, 13, '0'),
(285, 3, 0, 14, '0'),
(286, 3, 0, 15, '0'),
(287, 3, 0, 16, '0'),
(288, 3, 0, 17, '0'),
(289, 3, 0, 18, '0'),
(290, 3, 0, 19, '0'),
(291, 3, 0, 20, '0'),
(292, 3, 0, 21, '0'),
(293, 3, 0, 22, '0'),
(294, 3, 0, 23, '0'),
(295, 3, 0, 24, '0'),
(296, 3, 0, 25, '0'),
(297, 3, 0, 26, '0'),
(298, 3, 1, 0, '0'),
(299, 3, 1, 1, '0'),
(300, 3, 1, 2, '0'),
(301, 3, 1, 3, '0'),
(302, 3, 1, 4, '0'),
(303, 3, 1, 5, '0'),
(304, 3, 1, 6, '0'),
(305, 3, 1, 7, '0'),
(306, 3, 1, 8, '0'),
(307, 3, 1, 9, '0'),
(308, 3, 1, 10, '0'),
(309, 3, 1, 11, '0'),
(310, 3, 1, 12, '0'),
(311, 3, 1, 13, '0'),
(312, 3, 1, 14, '0'),
(313, 3, 1, 15, '0'),
(314, 3, 1, 16, '0'),
(315, 3, 1, 17, '0'),
(316, 3, 1, 18, '0'),
(317, 3, 1, 19, '0'),
(318, 3, 1, 20, '0'),
(319, 3, 1, 21, '0'),
(320, 3, 1, 22, '0'),
(321, 3, 1, 23, '0'),
(322, 3, 1, 24, '0'),
(323, 3, 1, 25, '0'),
(324, 3, 1, 26, '0'),
(325, 3, 2, 0, '0'),
(326, 3, 2, 1, '0'),
(327, 3, 2, 2, '0'),
(328, 3, 2, 3, '0'),
(329, 3, 2, 4, '0'),
(330, 3, 2, 5, '0'),
(331, 3, 2, 6, '0'),
(332, 3, 2, 7, '0'),
(333, 3, 2, 8, '0'),
(334, 3, 2, 9, '0'),
(335, 3, 2, 10, '0'),
(336, 3, 2, 11, '0'),
(337, 3, 2, 12, '0'),
(338, 3, 2, 13, '0'),
(339, 3, 2, 14, '0'),
(340, 3, 2, 15, '0'),
(341, 3, 2, 16, '0'),
(342, 3, 2, 17, '0'),
(343, 3, 2, 18, '0'),
(344, 3, 2, 19, '0'),
(345, 3, 2, 20, '0'),
(346, 3, 2, 21, '0'),
(347, 3, 2, 22, '0'),
(348, 3, 2, 23, '0'),
(349, 3, 2, 24, '0'),
(350, 3, 2, 25, '0'),
(351, 3, 2, 26, '0'),
(352, 3, 3, 0, '0'),
(353, 3, 3, 1, '0'),
(354, 3, 3, 2, '0'),
(355, 3, 3, 3, '0'),
(356, 3, 3, 4, '0'),
(357, 3, 3, 5, '0'),
(358, 3, 3, 6, '0'),
(359, 3, 3, 7, '0'),
(360, 3, 3, 8, '0'),
(361, 3, 3, 9, '0'),
(362, 3, 3, 10, '0'),
(363, 3, 3, 11, '0'),
(364, 3, 3, 12, '0'),
(365, 3, 3, 13, '0'),
(366, 3, 3, 14, '0'),
(367, 3, 3, 15, '0'),
(368, 3, 3, 16, '0'),
(369, 3, 3, 17, '0'),
(370, 3, 3, 18, '0'),
(371, 3, 3, 19, '0'),
(372, 3, 3, 20, '0'),
(373, 3, 3, 21, '0'),
(374, 3, 3, 22, '0'),
(375, 3, 3, 23, '0'),
(376, 3, 3, 24, '0'),
(377, 3, 3, 25, '0'),
(378, 3, 3, 26, '0'),
(379, 3, 4, 0, '0'),
(380, 3, 4, 1, '0'),
(381, 3, 4, 2, '0'),
(382, 3, 4, 3, '0'),
(383, 3, 4, 4, '0'),
(384, 3, 4, 5, '0'),
(385, 3, 4, 6, '0'),
(386, 3, 4, 7, '0'),
(387, 3, 4, 8, '0'),
(388, 3, 4, 9, '0'),
(389, 3, 4, 10, '0'),
(390, 3, 4, 11, '0'),
(391, 3, 4, 12, '0'),
(392, 3, 4, 13, '0'),
(393, 3, 4, 14, '0'),
(394, 3, 4, 15, '0'),
(395, 3, 4, 16, '0'),
(396, 3, 4, 17, '0'),
(397, 3, 4, 18, '0'),
(398, 3, 4, 19, '0'),
(399, 3, 4, 20, '0'),
(400, 3, 4, 21, '0'),
(401, 3, 4, 22, '0'),
(402, 3, 4, 23, '0'),
(403, 3, 4, 24, '0'),
(404, 3, 4, 25, '0'),
(405, 3, 4, 26, '0'),
(406, 4, 0, 0, '0'),
(407, 4, 0, 1, '0'),
(408, 4, 0, 2, '0'),
(409, 4, 0, 3, '0'),
(410, 4, 0, 4, '0'),
(411, 4, 0, 5, '0'),
(412, 4, 0, 6, '0'),
(413, 4, 0, 7, '0'),
(414, 4, 0, 8, '0'),
(415, 4, 0, 9, '0'),
(416, 4, 0, 10, '0'),
(417, 4, 0, 11, '0'),
(418, 4, 0, 12, '0'),
(419, 4, 0, 13, '0'),
(420, 4, 0, 14, '0'),
(421, 4, 0, 15, '0'),
(422, 4, 0, 16, '0'),
(423, 4, 0, 17, '0'),
(424, 4, 0, 18, '0'),
(425, 4, 0, 19, '0'),
(426, 4, 0, 20, '0'),
(427, 4, 0, 21, '0'),
(428, 4, 0, 22, '0'),
(429, 4, 0, 23, '0'),
(430, 4, 0, 24, '0'),
(431, 4, 0, 25, '0'),
(432, 4, 0, 26, '0'),
(433, 4, 1, 0, '0'),
(434, 4, 1, 1, '0'),
(435, 4, 1, 2, '0'),
(436, 4, 1, 3, '0'),
(437, 4, 1, 4, '0'),
(438, 4, 1, 5, '0'),
(439, 4, 1, 6, '0'),
(440, 4, 1, 7, '0'),
(441, 4, 1, 8, '0'),
(442, 4, 1, 9, '0'),
(443, 4, 1, 10, '0'),
(444, 4, 1, 11, '0'),
(445, 4, 1, 12, '0'),
(446, 4, 1, 13, '0'),
(447, 4, 1, 14, '0'),
(448, 4, 1, 15, '0'),
(449, 4, 1, 16, '0'),
(450, 4, 1, 17, '0'),
(451, 4, 1, 18, '0'),
(452, 4, 1, 19, '0'),
(453, 4, 1, 20, '0'),
(454, 4, 1, 21, '0'),
(455, 4, 1, 22, '0'),
(456, 4, 1, 23, '0'),
(457, 4, 1, 24, '0'),
(458, 4, 1, 25, '0'),
(459, 4, 1, 26, '0'),
(460, 4, 2, 0, '0'),
(461, 4, 2, 1, '0'),
(462, 4, 2, 2, '0'),
(463, 4, 2, 3, '0'),
(464, 4, 2, 4, '0'),
(465, 4, 2, 5, '0'),
(466, 4, 2, 6, '0'),
(467, 4, 2, 7, '0'),
(468, 4, 2, 8, '0'),
(469, 4, 2, 9, '0'),
(470, 4, 2, 10, '0'),
(471, 4, 2, 11, '0'),
(472, 4, 2, 12, '0'),
(473, 4, 2, 13, '0'),
(474, 4, 2, 14, '0'),
(475, 4, 2, 15, '0'),
(476, 4, 2, 16, '0'),
(477, 4, 2, 17, '0'),
(478, 4, 2, 18, '0'),
(479, 4, 2, 19, '0'),
(480, 4, 2, 20, '0'),
(481, 4, 2, 21, '0'),
(482, 4, 2, 22, '0'),
(483, 4, 2, 23, '0'),
(484, 4, 2, 24, '0'),
(485, 4, 2, 25, '0'),
(486, 4, 2, 26, '0'),
(487, 4, 3, 0, '0'),
(488, 4, 3, 1, '0'),
(489, 4, 3, 2, '0'),
(490, 4, 3, 3, '0'),
(491, 4, 3, 4, '0'),
(492, 4, 3, 5, '0'),
(493, 4, 3, 6, '0'),
(494, 4, 3, 7, '0'),
(495, 4, 3, 8, '0'),
(496, 4, 3, 9, '0'),
(497, 4, 3, 10, '0'),
(498, 4, 3, 11, '0'),
(499, 4, 3, 12, '0'),
(500, 4, 3, 13, '0'),
(501, 4, 3, 14, '0'),
(502, 4, 3, 15, '0'),
(503, 4, 3, 16, '0'),
(504, 4, 3, 17, '0'),
(505, 4, 3, 18, '0'),
(506, 4, 3, 19, '0'),
(507, 4, 3, 20, '0'),
(508, 4, 3, 21, '0'),
(509, 4, 3, 22, '0'),
(510, 4, 3, 23, '0'),
(511, 4, 3, 24, '0'),
(512, 4, 3, 25, '0'),
(513, 4, 3, 26, '0'),
(514, 4, 4, 0, '0'),
(515, 4, 4, 1, '0'),
(516, 4, 4, 2, '0'),
(517, 4, 4, 3, '0'),
(518, 4, 4, 4, '0'),
(519, 4, 4, 5, '0'),
(520, 4, 4, 6, '0'),
(521, 4, 4, 7, '0'),
(522, 4, 4, 8, '0'),
(523, 4, 4, 9, '0'),
(524, 4, 4, 10, '0'),
(525, 4, 4, 11, '0'),
(526, 4, 4, 12, '0'),
(527, 4, 4, 13, '0'),
(528, 4, 4, 14, '0'),
(529, 4, 4, 15, '0'),
(530, 4, 4, 16, '0'),
(531, 4, 4, 17, '0'),
(532, 4, 4, 18, '0'),
(533, 4, 4, 19, '0'),
(534, 4, 4, 20, '0'),
(535, 4, 4, 21, '0'),
(536, 4, 4, 22, '0'),
(537, 4, 4, 23, '0'),
(538, 4, 4, 24, '0'),
(539, 4, 4, 25, '0'),
(540, 4, 4, 26, '0');

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
(1, 2, 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `class_schedules`
--
ALTER TABLE `class_schedules`
  ADD PRIMARY KEY (`class_surr_id`),
  ADD KEY `fk_delete_college_schedules` (`college_id`);

--
-- Indexes for table `colleges`
--
ALTER TABLE `colleges`
  ADD PRIMARY KEY (`college_id`),
  ADD UNIQUE KEY `college_code` (`college_code`);

--
-- Indexes for table `courses`
--
ALTER TABLE `courses`
  ADD PRIMARY KEY (`course_surrogate_id`),
  ADD KEY `fk_course_user_delete` (`created_by`),
  ADD KEY `fk_delete_assigRoom_null` (`assigned_room`),
  ADD KEY `fk_delete_assigTeach_null` (`assigned_teacher`),
  ADD KEY `fk_delete_course_on_college` (`course_college`);

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
  ADD KEY `fk_delete_room_schedules` (`room_id`);

--
-- Indexes for table `teachers`
--
ALTER TABLE `teachers`
  ADD PRIMARY KEY (`teacher_id`);

--
-- Indexes for table `teacher_schedules`
--
ALTER TABLE `teacher_schedules`
  ADD PRIMARY KEY (`teacher_schedule_id`),
  ADD KEY `fk_delete_teacher_schedules` (`teacher_id`);

--
-- Indexes for table `user_programs`
--
ALTER TABLE `user_programs`
  ADD PRIMARY KEY (`user_program_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `class_schedules`
--
ALTER TABLE `class_schedules`
  MODIFY `class_surr_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=541;

--
-- AUTO_INCREMENT for table `colleges`
--
ALTER TABLE `colleges`
  MODIFY `college_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `courses`
--
ALTER TABLE `courses`
  MODIFY `course_surrogate_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `rooms`
--
ALTER TABLE `rooms`
  MODIFY `room_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `room_schedules`
--
ALTER TABLE `room_schedules`
  MODIFY `room_schedule_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=541;

--
-- AUTO_INCREMENT for table `teachers`
--
ALTER TABLE `teachers`
  MODIFY `teacher_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `teacher_schedules`
--
ALTER TABLE `teacher_schedules`
  MODIFY `teacher_schedule_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=541;

--
-- AUTO_INCREMENT for table `user_programs`
--
ALTER TABLE `user_programs`
  MODIFY `user_program_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `class_schedules`
--
ALTER TABLE `class_schedules`
  ADD CONSTRAINT `fk_delete_college_schedules` FOREIGN KEY (`college_id`) REFERENCES `colleges` (`college_id`) ON DELETE CASCADE;

--
-- Constraints for table `courses`
--
ALTER TABLE `courses`
  ADD CONSTRAINT `fk_course_user_delete` FOREIGN KEY (`created_by`) REFERENCES `profiles` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_delete_assigRoom_null` FOREIGN KEY (`assigned_room`) REFERENCES `rooms` (`room_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_delete_assigTeach_null` FOREIGN KEY (`assigned_teacher`) REFERENCES `teachers` (`teacher_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_delete_course_on_college` FOREIGN KEY (`course_college`) REFERENCES `colleges` (`college_id`) ON DELETE CASCADE;

--
-- Constraints for table `room_schedules`
--
ALTER TABLE `room_schedules`
  ADD CONSTRAINT `fk_delete_room_schedules` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`room_id`) ON DELETE CASCADE;

--
-- Constraints for table `teacher_schedules`
--
ALTER TABLE `teacher_schedules`
  ADD CONSTRAINT `fk_delete_teacher_schedules` FOREIGN KEY (`teacher_id`) REFERENCES `teachers` (`teacher_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
