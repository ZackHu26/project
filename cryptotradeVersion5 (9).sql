-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 02, 2019 at 07:33 AM
-- Server version: 10.4.6-MariaDB-log
-- PHP Version: 7.1.31

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `cryptotrade`
--
CREATE DATABASE IF NOT EXISTS `cryptotrade` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `cryptotrade`;

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateBalance` (IN `userID` VARCHAR(50), IN `pl` FLOAT, IN `competitionID` INT)  NO SQL
BEGIN
SET @SQL = CONCAT("UPDATE balances SET USD = (SELECT USD FROM balances WHERE userID = '", userID, "') + ", pl, " WHERE userID = '", userID, "' AND competitionID = ", competitionID, ";");

PREPARE stmt FROM @SQL;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `getCurrentComp` () RETURNS INT(11) NO SQL
return (SELECT id from competitions
 WHERE endTimestamp > CURRENT_TIMESTAMP
 AND startTimestamp < CURRENT_TIMESTAMP
 LIMIT 1)$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `balances`
--

CREATE TABLE `balances` (
  `userID` varchar(20) CHARACTER SET latin1 NOT NULL,
  `competitionID` int(11) NOT NULL,
  `USD` float NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `balances`
--

INSERT INTO `balances` (`userID`, `competitionID`, `USD`) VALUES
('ben', 8, 7986.62);

-- --------------------------------------------------------

--
-- Table structure for table `competitions`
--

CREATE TABLE `competitions` (
  `id` int(11) NOT NULL,
  `description` varchar(300) DEFAULT NULL,
  `startTimestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  `endTimestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  `startAmount` float NOT NULL DEFAULT 10000
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `competitions`
--

INSERT INTO `competitions` (`id`, `description`, `startTimestamp`, `endTimestamp`, `startAmount`) VALUES
(8, 'comp1', '2019-10-27 07:00:00', '2019-11-27 08:00:00', 0);

-- --------------------------------------------------------

--
-- Stand-in structure for view `positions`
-- (See below for the actual view)
--
CREATE TABLE `positions` (
`userID` varchar(20)
,`symbol` varchar(10)
,`amount` double
,`avgPrice` double
,`competitionID` int(11)
,`balance` float
);

-- --------------------------------------------------------

--
-- Table structure for table `trades`
--

CREATE TABLE `trades` (
  `id` int(20) NOT NULL,
  `userID` varchar(20) NOT NULL,
  `symbol` varchar(10) NOT NULL,
  `amount` double NOT NULL,
  `price` double NOT NULL,
  `isClosed` tinyint(1) NOT NULL DEFAULT 0,
  `competitionID` int(11) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `trades`
--

INSERT INTO `trades` (`id`, `userID`, `symbol`, `amount`, `price`, `isClosed`, `competitionID`, `timestamp`) VALUES
(305, 'ben', 'BTC', 1, 9304.68, 1, 8, '2019-10-30 03:11:57'),
(306, 'ben', 'BTC', -1, 9301.24, 1, 8, '2019-10-30 03:12:08'),
(307, 'ben', 'BTC', 1, 9311.16, 1, 8, '2019-10-30 03:13:30'),
(308, 'ben', 'BTC', -1, 9312.59, 1, 8, '2019-10-30 03:13:42'),
(309, 'ben', 'BTC', 1, 9292.39, 1, 8, '2019-10-30 03:17:20'),
(310, 'ben', 'BTC', -1, 9291.37, 1, 8, '2019-10-30 03:17:26'),
(311, 'ben', 'BTC', 10, 9293.19, 1, 8, '2019-10-30 03:17:59'),
(312, 'ben', 'BTC', -10, 9301.23, 1, 8, '2019-10-30 03:20:08'),
(313, 'ben', 'BTC', 1, 9300.23, 1, 8, '2019-10-30 03:20:35'),
(314, 'ben', 'BTC', 1, 9295.47, 1, 8, '2019-10-30 03:20:39'),
(315, 'ben', 'BTC', 1, 9297, 1, 8, '2019-10-30 03:20:45'),
(316, 'ben', 'BTC', -1, 9288.17, 1, 8, '2019-10-30 03:20:58'),
(317, 'ben', 'BTC', -10, 9292.82, 1, 8, '2019-10-30 03:21:43'),
(318, 'ben', 'BTC', 15, 9310.45, 1, 8, '2019-10-30 03:33:02'),
(319, 'ben', 'ETH', 100, 190.7, 1, 8, '2019-10-30 03:33:37'),
(320, 'ben', 'BTC', -7, 9108.1, 1, 8, '2019-11-01 00:43:39'),
(321, 'ben', 'ETH', -100, 181.61, 1, 8, '2019-11-01 00:44:27'),
(322, 'ben', 'BTC', 1, 9119.37, 1, 8, '2019-11-01 00:47:02'),
(323, 'ben', 'BTC', 1, 9116.77, 1, 8, '2019-11-01 00:47:13'),
(324, 'ben', 'BTC', -2, 9124.9, 1, 8, '2019-11-01 01:01:58'),
(325, 'ben', 'BTC', 1, 9124.49, 1, 8, '2019-11-01 01:02:11'),
(326, 'ben', 'BTC', 1, 9124.5, 1, 8, '2019-11-01 01:02:16'),
(327, 'ben', 'ETC', 234, 4.8115, 1, 8, '2019-11-01 01:02:37'),
(328, 'ben', 'BTC', -2, 9125.48, 1, 8, '2019-11-01 01:02:56'),
(329, 'ben', 'ETC', -234, 4.8115, 1, 8, '2019-11-01 01:03:01'),
(330, 'ben', 'BNB', 30, 19.9217, 1, 8, '2019-11-01 01:03:18'),
(331, 'ben', 'LINK', 12, 2.7784, 1, 8, '2019-11-01 01:03:28'),
(332, 'ben', 'NEO', 12, 10.433, 1, 8, '2019-11-01 01:12:26'),
(333, 'ben', 'BNB', -30, 19.9727, 1, 8, '2019-11-01 01:12:47'),
(334, 'ben', 'BTC', 1, 9138.68, 1, 8, '2019-11-01 01:14:13'),
(335, 'ben', 'BTC', -1, 9129.35, 1, 8, '2019-11-01 01:20:40'),
(336, 'ben', 'BTC', 1, 9122.5, 1, 8, '2019-11-01 01:22:26'),
(337, 'ben', 'BTC', -1, 9124.98, 1, 8, '2019-11-01 01:22:38'),
(338, 'ben', 'NEO', -12, 10.387, 1, 8, '2019-11-01 01:22:45'),
(339, 'ben', 'BTC', 0.1, 9112.01, 1, 8, '2019-11-01 01:28:31'),
(340, 'ben', 'BTC', 0.1, 9114.32, 1, 8, '2019-11-01 01:28:47'),
(341, 'ben', 'BTC', 0.3, 9113.34, 1, 8, '2019-11-01 01:29:03'),
(342, 'ben', 'BTC', 0.1, 9112.39, 1, 8, '2019-11-01 01:29:37'),
(343, 'ben', 'BTC', 0.1, 9117.44, 1, 8, '2019-11-01 01:29:58'),
(344, 'ben', 'BTC', 0.1, 9116.31, 1, 8, '2019-11-01 01:30:19'),
(345, 'ben', 'BTC', -1, 9116.73, 1, 8, '2019-11-01 01:30:30'),
(346, 'ben', 'LTC', -1, 58.07, 1, 8, '2019-11-01 01:30:43'),
(347, 'ben', 'BTC', 0.0010002, 9116.23, 1, 8, '2019-11-01 01:30:51'),
(348, 'ben', 'BTC', 0.1989998, 9117.78, 1, 8, '2019-11-01 01:31:05'),
(349, 'ben', 'BTC', -1, 9117.21, 1, 8, '2019-11-01 01:32:43'),
(350, 'ben', 'BTC', 5, 9116.56, 1, 8, '2019-11-01 01:33:17'),
(351, 'ben', 'BTC', -3, 9116.26, 1, 8, '2019-11-01 01:33:46'),
(352, 'ben', 'BTC', -2, 9111.11, 1, 8, '2019-11-01 01:34:35'),
(353, 'ben', 'BTC', 2, 9113.12, 1, 8, '2019-11-01 01:36:01'),
(354, 'ben', 'BTC', -1, 9113.71, 1, 8, '2019-11-01 01:36:06'),
(355, 'ben', 'LINK', -12, 2.755, 1, 8, '2019-11-01 01:38:16'),
(356, 'ben', 'LTC', 1, 58.03, 1, 8, '2019-11-01 01:39:24'),
(357, 'ben', 'TRX', 1299, 0.01989, 1, 8, '2019-11-01 01:39:32'),
(358, 'ben', 'XRP', -3420, 0.29305, 1, 8, '2019-11-01 01:39:38'),
(359, 'ben', 'TRX', -1299, 0.01987, 1, 8, '2019-11-01 01:39:44'),
(360, 'ben', 'XRP', 3410, 0.29304, 1, 8, '2019-11-01 01:39:58'),
(361, 'ben', 'XRP', 3410, 0.29304, 1, 8, '2019-11-01 01:39:58'),
(362, 'ben', 'XRP', -3400, 0.29304, 1, 8, '2019-11-01 01:40:03'),
(363, 'ben', 'BTC', -1, 9113.59, 1, 8, '2019-11-01 01:43:54'),
(364, 'ben', 'BNB', 123, 19.9439, 1, 8, '2019-11-01 01:43:58'),
(365, 'ben', 'XRP', 123123, 0.29316, 1, 8, '2019-11-01 01:44:06'),
(366, 'ben', 'BTC', 1, 9116.94, 1, 8, '2019-11-01 01:44:21'),
(367, 'ben', 'XRP', -123123, 0.2931, 1, 8, '2019-11-01 01:45:49'),
(368, 'ben', 'BTC', -1, 9107.58, 1, 8, '2019-11-01 01:46:48'),
(369, 'ben', 'BTC', 1, 9106.35, 1, 8, '2019-11-01 01:46:58'),
(370, 'ben', 'BTC', -1, 9099.25, 1, 8, '2019-11-01 01:49:59'),
(371, 'ben', 'BTC', 1, 9099.27, 1, 8, '2019-11-01 01:50:05'),
(372, 'ben', 'BTC', -1, 9107.06, 1, 8, '2019-11-01 01:50:39'),
(373, 'ben', 'BTC', 1, 9105.18, 1, 8, '2019-11-01 01:50:44'),
(374, 'ben', 'BTC', 0.231, 9099.24, 1, 8, '2019-11-01 01:50:54'),
(375, 'ben', 'BNB', -123, 19.8776, 1, 8, '2019-11-01 01:50:59'),
(376, 'ben', 'BTC', -0.231, 9110.52, 1, 8, '2019-11-01 01:54:07'),
(377, 'ben', 'BTC', 8, 9108.27, 1, 8, '2019-11-01 01:55:35'),
(378, 'ben', 'XRP', 1020, 0.29189, 1, 8, '2019-11-01 02:35:07'),
(379, 'ben', 'BTC', -4, 9077.63, 1, 8, '2019-11-01 02:35:29'),
(380, 'ben', 'TRX', 100000, 0.01965, 1, 8, '2019-11-01 02:35:40'),
(381, 'ben', 'XRP', -1020, 0.29205, 1, 8, '2019-11-01 02:41:21'),
(382, 'ben', 'LINK', 1230, 2.7295, 1, 8, '2019-11-01 03:30:21'),
(383, 'ben', 'ETH', 2, 180.4, 1, 8, '2019-11-01 03:30:28'),
(384, 'ben', 'LINK', -1230, 2.734, 1, 8, '2019-11-01 03:46:31'),
(385, 'ben', 'TRX', -100000, 0.01945, 1, 8, '2019-11-01 03:58:23'),
(386, 'ben', 'BTC', -4, 9060.49, 1, 8, '2019-11-01 04:00:26'),
(387, 'ben', 'BTC', 7, 9055, 1, 8, '2019-11-01 04:01:13'),
(388, 'ben', 'BTC', 0.1, 9048.66, 1, 8, '2019-11-01 04:04:30'),
(389, 'ben', 'BTC', 0.0010001, 9048.66, 1, 8, '2019-11-01 04:05:00'),
(390, 'ben', 'BTC', 0.1, 9061.79, 1, 8, '2019-11-01 04:07:28'),
(391, 'ben', 'BTC', -7.2010001, 9062.59, 1, 8, '2019-11-01 04:08:01'),
(392, 'ben', 'XRP', 2100, 0.29138, 1, 8, '2019-11-01 04:08:17'),
(393, 'ben', 'XRP', -2100, 0.29084, 1, 8, '2019-11-01 04:10:02'),
(394, 'ben', 'ETH', -2, 180.2, 1, 8, '2019-11-01 04:10:42'),
(395, 'ben', 'BTC', 1, 9052.59, 1, 8, '2019-11-01 04:12:13'),
(396, 'ben', 'BTC', 1, 9051.38, 1, 8, '2019-11-01 04:12:14'),
(397, 'ben', 'BTC', -2, 9053.23, 1, 8, '2019-11-01 04:12:21'),
(398, 'ben', 'BTC', 1, 9054.51, 1, 8, '2019-11-01 04:12:49'),
(399, 'ben', 'NEO', 143, 10.565, 1, 8, '2019-11-01 04:13:00'),
(400, 'ben', 'NEO', -143, 10.586, 1, 8, '2019-11-01 04:13:12'),
(401, 'ben', 'NEO', 90, 10.581, 1, 8, '2019-11-01 04:14:59'),
(402, 'ben', 'NEO', -90, 10.541, 1, 8, '2019-11-01 04:15:43'),
(403, 'ben', 'BTC', -1, 9064.88, 1, 8, '2019-11-01 04:16:33'),
(404, 'ben', 'EOS', 12, 3.2225, 1, 8, '2019-11-01 04:16:53'),
(405, 'ben', 'BTC', 3, 9070.12, 1, 8, '2019-11-01 04:18:24'),
(406, 'ben', 'BTC', -3, 9070.31, 1, 8, '2019-11-01 04:18:36'),
(407, 'ben', 'BTC', 1, 9076.21, 1, 8, '2019-11-01 04:19:10'),
(408, 'ben', 'BTC', -1, 9071.79, 1, 8, '2019-11-01 04:20:59'),
(409, 'ben', 'BTC', 1, 9074.36, 1, 8, '2019-11-01 04:21:32'),
(410, 'ben', 'BTC', -1, 9074.52, 1, 8, '2019-11-01 04:22:16'),
(411, 'ben', 'BTC', 1, 9070.5, 1, 8, '2019-11-01 04:22:48'),
(412, 'ben', 'BTC', -1, 9072.94, 1, 8, '2019-11-01 04:24:29'),
(413, 'ben', 'LTC', 12, 57.72, 1, 8, '2019-11-01 04:24:38'),
(414, 'ben', 'BTC', 5, 9072.12, 1, 8, '2019-11-01 04:26:34'),
(415, 'ben', 'EOS', -12, 3.2192, 1, 8, '2019-11-01 04:35:36'),
(416, 'ben', 'LTC', -12, 57.7, 1, 8, '2019-11-01 04:38:27'),
(417, 'ben', 'BTC', 1, 9075.23, 1, 8, '2019-11-01 04:40:07'),
(418, 'ben', 'BTC', 1, 9080, 1, 8, '2019-11-01 04:40:45'),
(419, 'ben', 'BTC', -2, 9085.26, 1, 8, '2019-11-01 04:42:39'),
(420, 'ben', 'BTC', 2, 9084.16, 1, 8, '2019-11-01 04:43:05'),
(421, 'ben', 'ETH', 3, 180.91, 1, 8, '2019-11-01 04:43:23'),
(422, 'ben', 'ETH', -3, 180.91, 1, 8, '2019-11-01 04:44:05'),
(423, 'ben', 'BTC', -5, 9093.4, 1, 8, '2019-11-01 04:46:03'),
(424, 'ben', 'BTC', 3, 9090.79, 1, 8, '2019-11-01 04:46:51'),
(425, 'ben', 'BTC', -1, 9098.01, 1, 8, '2019-11-01 04:47:58'),
(426, 'ben', 'EOS', 5000, 3.2267, 1, 8, '2019-11-01 04:48:23'),
(427, 'ben', 'BTC', -4, 9093.92, 1, 8, '2019-11-01 04:49:37'),
(428, 'ben', 'EOS', 7, 3.2296, 1, 8, '2019-11-01 04:50:29'),
(429, 'ben', 'EOS', 6, 3.2267, 1, 8, '2019-11-01 04:50:36'),
(430, 'ben', 'EOS', 5, 3.2267, 1, 8, '2019-11-01 04:50:41'),
(431, 'ben', 'EOS', 3, 3.2267, 1, 8, '2019-11-01 04:50:44'),
(432, 'ben', 'BTC', 5, 9082.4, 1, 8, '2019-11-01 04:50:55'),
(433, 'ben', 'BTC', -5, 9082.43, 1, 8, '2019-11-01 04:54:25'),
(434, 'ben', 'ETH', 300, 180.77, 1, 8, '2019-11-01 04:54:37'),
(435, 'ben', 'EOS', -5021, 3.2255, 1, 8, '2019-11-01 04:56:05'),
(436, 'ben', 'BTC', 1, 9107.03, 1, 8, '2019-11-01 05:26:15'),
(437, 'ben', 'BTC', -1, 9072.29, 1, 8, '2019-11-01 06:09:32'),
(438, 'ben', 'BTC', 1, 9102.68, 1, 8, '2019-11-01 06:18:53'),
(439, 'ben', 'ETH', -300, 181.39, 1, 8, '2019-11-01 06:19:06'),
(440, 'ben', 'ETH', 123, 181.41, 1, 8, '2019-11-01 06:19:49'),
(441, 'ben', 'ETH', -123, 181.35, 1, 8, '2019-11-01 06:20:05'),
(442, 'ben', 'ETH', 23, 181.21, 1, 8, '2019-11-01 06:22:57'),
(443, 'ben', 'BTC', -1, 9093.6, 1, 8, '2019-11-01 06:23:16'),
(444, 'ben', 'BTC', 1, 9090.46, 1, 8, '2019-11-01 06:24:47'),
(445, 'ben', 'BTC', -1, 9093.47, 1, 8, '2019-11-01 06:25:48'),
(446, 'ben', 'BTC', 2, 9090.99, 1, 8, '2019-11-01 06:26:17'),
(447, 'ben', 'TRX', 3490, 0.01961, 1, 8, '2019-11-01 06:26:34'),
(448, 'ben', 'TRX', -3490, 0.01963, 1, 8, '2019-11-01 06:26:52'),
(449, 'ben', 'TRX', 213, 0.0196, 1, 8, '2019-11-01 06:27:04'),
(450, 'ben', 'TRX', -213, 0.01964, 1, 8, '2019-11-01 06:27:58'),
(451, 'ben', 'TRX', 32049, 0.01965, 1, 8, '2019-11-01 06:28:10'),
(452, 'ben', 'XRP', 0.1, 0.29317, 1, 8, '2019-11-02 00:51:33'),
(453, 'ben', 'XRP', -0.1, 0.29318, 1, 8, '2019-11-02 00:52:17'),
(454, 'ben', 'TRX', -32049, 0.01978, 1, 8, '2019-11-02 00:52:23'),
(455, 'ben', 'ETH', -23, 183.16, 1, 8, '2019-11-02 00:55:23'),
(456, 'ben', 'BTC', 1, 9244.7, 1, 8, '2019-11-02 00:57:31'),
(457, 'ben', 'BTC', -3, 9242.72, 1, 8, '2019-11-02 00:58:41'),
(458, 'ben', 'BTC', 7, 9243.92, 1, 8, '2019-11-02 01:00:19'),
(459, 'ben', 'ETH', 50, 183.07, 0, 8, '2019-11-02 01:01:06'),
(460, 'ben', 'ETH', 25, 183.08, 0, 8, '2019-11-02 01:01:28'),
(461, 'ben', 'BTC', -7, 9250.86, 1, 8, '2019-11-02 01:25:59'),
(462, 'ben', 'BTC', 1, 9255.08, 0, 8, '2019-11-02 01:26:56'),
(463, 'ben', 'BTC', 1, 9250.58, 0, 8, '2019-11-02 01:40:26'),
(464, 'ben', 'BTC', 1, 9234.36, 0, 8, '2019-11-02 01:48:25'),
(465, 'ben', 'BTC', 1, 9240.03, 0, 8, '2019-11-02 02:01:58'),
(466, 'ben', 'EOS', 2000, 3.3472, 1, 8, '2019-11-02 04:49:42'),
(467, 'ben', 'EOS', -2000, 3.3498, 1, 8, '2019-11-02 04:50:26'),
(468, 'ben', 'BTC', 1, 9220, 0, 8, '2019-11-02 05:47:52'),
(469, 'ben', 'BTC', -1, 9222.58, 0, 8, '2019-11-02 05:48:48'),
(470, 'ben', 'BTC', 1, 9214.54, 0, 8, '2019-11-02 06:17:13'),
(471, 'ben', 'BTC', 1, 9218, 0, 8, '2019-11-02 06:17:20');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` varchar(20) NOT NULL,
  `hash` varchar(64) NOT NULL,
  `salt` varchar(8) NOT NULL,
  `isAdmin` tinyint(4) NOT NULL DEFAULT 0,
  `email` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  `isDisabled` tinyint(1) NOT NULL DEFAULT 1,
  `competitionID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `hash`, `salt`, `isAdmin`, `email`, `name`, `isDisabled`, `competitionID`) VALUES
('ben', '', '', 0, '', '', 1, 8);

--
-- Triggers `users`
--
DELIMITER $$
CREATE TRIGGER `join_comp` AFTER UPDATE ON `users` FOR EACH ROW IF EXISTS (SELECT NEW.competitionID FROM users
       WHERE NEW.competitionID = (SELECT id FROM competitions
                                 WHERE startTimestamp > CURRENT_TIMESTAMP
                             	AND NOT EXISTS (SELECT id FROM competitions
                                                            WHERE startTimestamp < CURRENT_TIMESTAMP
                                                            AND endTimestamp > CURRENT_TIMESTAMP)))
THEN
INSERT INTO balances (userID,competitionID,symbol) VALUES (NEW.id, NEW.competitionID,(SELECT startAmount FROM competitions
                                                     WHERE startTimestamp > CURRENT_TIMESTAMP
                             						AND NOT EXISTS (SELECT id FROM competitions
                                                     WHERE startTimestamp < CURRENT_TIMESTAMP
                                                     AND endTimestamp > CURRENT_TIMESTAMP)));
END IF
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure for view `positions`
--
DROP TABLE IF EXISTS `positions`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `positions`  AS  select `trades`.`userID` AS `userID`,`trades`.`symbol` AS `symbol`,sum(`trades`.`amount`) AS `amount`,sum(`trades`.`amount` * `trades`.`price`) / sum(`trades`.`amount`) AS `avgPrice`,`trades`.`competitionID` AS `competitionID`,`balances`.`USD` AS `balance` from (`trades` join `balances`) where `trades`.`userID` = `balances`.`userID` and `trades`.`competitionID` = `balances`.`competitionID` and `trades`.`isClosed` = 0 group by `trades`.`symbol`,`trades`.`userID`,`trades`.`competitionID` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `balances`
--
ALTER TABLE `balances`
  ADD PRIMARY KEY (`userID`,`competitionID`),
  ADD KEY `users.id_fk` (`userID`),
  ADD KEY `competitionID` (`competitionID`);

--
-- Indexes for table `competitions`
--
ALTER TABLE `competitions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `trades`
--
ALTER TABLE `trades`
  ADD PRIMARY KEY (`id`),
  ADD KEY `userID` (`userID`,`competitionID`),
  ADD KEY `competition.id_fk2` (`competitionID`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `competitions`
--
ALTER TABLE `competitions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `trades`
--
ALTER TABLE `trades`
  MODIFY `id` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=472;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `balances`
--
ALTER TABLE `balances`
  ADD CONSTRAINT `balances_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `competition.id_fk3` FOREIGN KEY (`competitionID`) REFERENCES `competitions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `trades`
--
ALTER TABLE `trades`
  ADD CONSTRAINT `trades_ibfk_1` FOREIGN KEY (`competitionID`) REFERENCES `competitions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `trades_ibfk_2` FOREIGN KEY (`userID`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
