-- CCS Event Hub database backup
-- Database: event_hub
-- Created:  2026-11-11 20:20:49

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO';

-- ----------------------------
-- Table: events
-- ----------------------------
DROP TABLE IF EXISTS `events`;
CREATE TABLE `events` (
  `id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `event_date` date NOT NULL,
  `event_time` time NOT NULL,
  `location` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `capacity` int NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'upcoming',
  `finished_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `events` (`id`, `title`, `category`, `event_date`, `event_time`, `location`, `capacity`, `description`, `status`, `finished_at`, `created_at`) VALUES
('ev898306f923', 'CCS Night', 'Party', '2026-10-10', '22:00:00', 'AC', 100, 'asdadsad', 'upcoming', NULL, '2026-11-02 05:46:07'),
('evcedd5d1b63', '✨ 𝐀 𝐂𝐄𝐋𝐄𝐁𝐑𝐀𝐓𝐈𝐎𝐍 𝐓𝐎 𝐑𝐄𝐌𝐄𝐌𝐁𝐄𝐑 | 𝐂𝐂𝐒 𝐓𝐄𝐀𝐂𝐇𝐄𝐑’𝐒 𝐃𝐀𝐘 𝟐𝟎𝟐𝟔 💜🧡', 'Party', '2026-11-30', '09:00:00', 'Lspu CCS Quadrangle', 1000, 'Reliving the wonderful moments of our CCS Teacher’s Day Celebration 2026! From the joyful smiles and shared laughter to the heartfelt expressions of gratitude, every moment made this celebration truly memorable.\nAs we look back on this special day, we celebrate not only the dedication and passion of our teachers but also the lasting impact they make in shaping our knowledge, inspiring our dreams, and guiding us toward a brighter future.\nTo our dear CCS educators, thank you for being an essential part of our journey. Here’s to the memories we shared and the countless lives you continue to inspire! 🎉\n𝙎𝙖𝙡𝙪𝙙𝙤 𝙨𝙖 𝙢𝙜𝙖 𝙜𝙪𝙧𝙤𝙣𝙜 𝙝𝙪𝙢𝙪𝙝𝙪𝙗𝙤𝙜 𝙨𝙖 𝙖𝙢𝙞𝙣𝙜 𝙠𝙞𝙣𝙖𝙗𝙪𝙠𝙖𝙨𝙖𝙣. 💜', 'upcoming', NULL, '2026-11-08 15:22:16'),
('eve7a072fdc3', '𝗣𝗔𝗥𝗘𝗡𝗧𝗦 𝗔𝗡𝗗 𝗦𝗧𝗨𝗗𝗘𝗡𝗧𝗦 𝗢𝗥𝗜𝗘𝗡𝗧𝗔𝗧𝗜𝗢𝗡', 'Orientation', '2026-11-27', '10:00:00', 'Lspu CCS Quadrangle', 500, 'As we prepare for the opening of 𝗔𝗰𝗮𝗱𝗲𝗺𝗶𝗰 𝗬𝗲𝗮𝗿 𝟮𝟬𝟮𝟲–𝟮𝟬𝟮𝟳, the 𝗖𝗼𝗹𝗹𝗲𝗴𝗲 𝗼𝗳 𝗖𝗼𝗺𝗽𝘂𝘁𝗲𝗿 𝗦𝘁𝘂𝗱𝗶𝗲𝘀 (𝗖𝗖𝗦) invites all incoming students and their parents to attend the 𝗙𝗮𝗰𝗲-𝘁𝗼-𝗙𝗮𝗰𝗲 𝗣𝗮𝗿𝗲𝗻𝘁𝘀 𝗮𝗻𝗱 𝗦𝘁𝘂𝗱𝗲𝗻𝘁𝘀 𝗢𝗿𝗶𝗲𝗻𝘁𝗮𝘁𝗶𝗼𝗻.\n\nThe orientation will provide important information about school policies, student services, academic responsibilities, and opportunities available to our students.\nWe encourage all CCS students and parents to attend and be properly guided as we begin a new academic year together. \nWelcome to CCS, future Ka-Codekadas! 🐉💜', 'upcoming', NULL, '2026-11-08 15:28:27');

-- ----------------------------
-- Table: notifications
-- ----------------------------
DROP TABLE IF EXISTS `notifications`;
CREATE TABLE `notifications` (
  `id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `event_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_notifications_user_created` (`user_id`,`created_at`,`id`),
  KEY `idx_notifications_user_read` (`user_id`,`is_read`),
  KEY `idx_notifications_reminder` (`user_id`,`event_id`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `notifications` (`id`, `user_id`, `event_id`, `type`, `message`, `is_read`, `created_at`) VALUES
('n0b52f9b2db8911f1', 'usr91f2876c7120', 'eve7a072fdc3', 'event_created', 'New event: "𝗣𝗔𝗥𝗘𝗡𝗧𝗦 𝗔𝗡𝗗 𝗦𝗧𝗨𝗗𝗘𝗡𝗧𝗦 𝗢𝗥𝗜𝗘𝗡𝗧𝗔𝗧𝗜𝗢𝗡" on 2026-11-27 at Lspu CCS Quadrangle.', 0, '2026-11-08 15:28:27'),
('n0b53020adb8911f1', 'usr487951cce4e7', 'eve7a072fdc3', 'event_created', 'New event: "𝗣𝗔𝗥𝗘𝗡𝗧𝗦 𝗔𝗡𝗗 𝗦𝗧𝗨𝗗𝗘𝗡𝗧𝗦 𝗢𝗥𝗜𝗘𝗡𝗧𝗔𝗧𝗜𝗢𝗡" on 2026-11-27 at Lspu CCS Quadrangle.', 0, '2026-11-08 15:28:27'),
('n2e41e16bdb8811f1', 'usr91f2876c7120', 'evcedd5d1b63', 'event_created', 'New event: "✨ 𝐀 𝐂𝐄𝐋𝐄𝐁𝐑𝐀𝐓𝐈𝐎𝐍 𝐓𝐎 𝐑𝐄𝐌𝐄𝐌𝐁𝐄𝐑 | 𝐂𝐂𝐒 𝐓𝐄𝐀𝐂𝐇𝐄𝐑’𝐒 𝐃𝐀𝐘 𝟐𝟎𝟐𝟔 💜🧡" on 2026-11-30 at Lspu CCS Quadrangle.', 0, '2026-11-08 15:22:16'),
('n2e42106fdb8811f1', 'usr487951cce4e7', 'evcedd5d1b63', 'event_created', 'New event: "✨ 𝐀 𝐂𝐄𝐋𝐄𝐁𝐑𝐀𝐓𝐈𝐎𝐍 𝐓𝐎 𝐑𝐄𝐌𝐄𝐌𝐁𝐄𝐑 | 𝐂𝐂𝐒 𝐓𝐄𝐀𝐂𝐇𝐄𝐑’𝐒 𝐃𝐀𝐘 𝟐𝟎𝟐𝟔 💜🧡" on 2026-11-30 at Lspu CCS Quadrangle.', 0, '2026-11-08 15:22:16'),
('n73b6babef0524d1d', 'usr487951cce4e7', 'evcedd5d1b63', 'registration', 'You are registered for "✨ 𝐀 𝐂𝐄𝐋𝐄𝐁𝐑𝐀𝐓𝐈𝐎𝐍 𝐓𝐎 𝐑𝐄𝐌𝐄𝐌𝐁𝐄𝐑 | 𝐂𝐂𝐒 𝐓𝐄𝐀𝐂𝐇𝐄𝐑’𝐒 𝐃𝐀𝐘 𝟐𝟎𝟐𝟔 💜🧡" on 2026-11-30.', 0, '2026-11-08 15:39:44');

-- ----------------------------
-- Table: registrations
-- ----------------------------
DROP TABLE IF EXISTS `registrations`;
CREATE TABLE `registrations` (
  `id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `event_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `student_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(254) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `course` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `section` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `year_level` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `attending` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `quantity` int DEFAULT '1',
  `attendance_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'registered',
  `registered_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `event_id` (`event_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `registrations_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE,
  CONSTRAINT `registrations_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `registrations` (`id`, `event_id`, `user_id`, `student_id`, `name`, `email`, `course`, `section`, `year_level`, `attending`, `quantity`, `attendance_status`, `registered_at`) VALUES
('regdb3832206b', 'evcedd5d1b63', 'usr487951cce4e7', '0125-0174', 'Abigail Odevilas', 'odevilasa5@gmail.com', 'BSCS', 'A', '2nd Year', 'yes', 1, 'attended', '2026-11-08 15:39:44');

-- ----------------------------
-- Table: users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `student_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(254) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `course` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `section` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `year_level` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `student_id` (`student_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `users` (`id`, `student_id`, `name`, `email`, `password_hash`, `created_at`, `course`, `section`, `year_level`) VALUES
('usr487951cce4e7', '0125-0174', 'Abigail Odevilas', 'odevilasa5@gmail.com', 'scrypt:32768:8:1$o5nUwuu0CVhmspjH$ef4c91fcf6272f05915b9fc933c78dec3fc2f93f82a2585d6a907bf99a919edf9f16b348e49afb971bdad167b6845715ebc562be8ba588c153c90d3cf68254e5', '2026-11-08 13:36:22', 'BSCS', 'A', '2nd Year'),
('usr91f2876c7120', '0124-1097', 'Jewel Ramos', 'cattojeymagda@gmail.com', 'scrypt:32768:8:1$fq2aBuZrWKAQZsWv$da30c31eb5b4734b27abec5e9bb10bd2cc68f6570f6c934812013c1f4264528988adaeb5791009f47783e073a3ce5ef779f9759420b33890f90d78c30ea6f502', '2026-11-01 11:08:08', '', '', '');

SET FOREIGN_KEY_CHECKS=1;
