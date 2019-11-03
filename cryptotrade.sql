-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 30, 2019 at 03:38 AM
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
('ben', 8, 10021.8);

-- --------------------------------------------------------

--
-- Table structure for table `competitions`
--

CREATE TABLE `competitions` (
  `id` int(11) NOT NULL,
  `description` varchar(300) DEFAULT NULL,
  `startTimestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  `endTimestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  `startAmount` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '{   "ADA": 0,   "ATOM": 0,   "BAT": 0,   "BCHABC": 0,   "BNB": 0,   "BTC": 0,   "BTT": 0,   "DASH": 0,   "EOS": 0,   "ETC": 0,   "ETH": 0,   "LINK": 0,   "LTC": 0,   "MATIC": 0,   "NEO": 0,   "ONT": 0,   "TRX": 0,   "USD": 10000.00,   "XLM": 0,   "XRP": 0 }'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `competitions`
--

INSERT INTO `competitions` (`id`, `description`, `startTimestamp`, `endTimestamp`, `startAmount`) VALUES
(8, 'comp1', '2019-10-27 07:00:00', '2019-11-27 08:00:00', '{\"ADA\": 0, \"ATOM\": 0, \"BAT\": 0, \"BCHABC\": 0, \"BNB\": 0, \"BTC\": 0, \"BTT\": 0, \"DASH\": 0, \"EOS\": 0, \"ETC\": 0, \"ETH\": 0, \"LINK\": 0, \"LTC\": 0, \"MATIC\": 0, \"NEO\": 0, \"ONT\": 0, \"TRX\": 0, \"USD\": 15000.99, \"XLM\": 0, \"XRP\": 0}');

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
(291, 'ben', 'BTC', 10, 9339.08, 1, 8, '2019-10-30 02:14:48'),
(292, 'ben', 'LTC', 1, 60.43, 1, 8, '2019-10-30 02:14:55'),
(293, 'ben', 'LTC', -100, 60.47, 1, 8, '2019-10-30 02:15:35'),
(294, 'ben', 'LTC', 100, 60.51, 1, 8, '2019-10-30 02:34:55'),
(295, 'ben', 'LTC', -150, 60.55, 1, 8, '2019-10-30 02:35:23'),
(296, 'ben', 'LTC', 300, 60.54, 1, 8, '2019-10-30 02:35:35'),
(297, 'ben', 'BTC', -10, 9339.69, 1, 8, '2019-10-30 02:36:06'),
(298, 'ben', 'LTC', -151, 60.66, 1, 8, '2019-10-30 02:36:08');

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
  MODIFY `id` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=299;

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

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getCurrentComp`() RETURNS int(11)
    NO SQL
return (SELECT id from competitions
 WHERE endTimestamp > CURRENT_TIMESTAMP
 AND startTimestamp < CURRENT_TIMESTAMP
 LIMIT 1)$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `createComp`(IN `startTimestamp` TIMESTAMP, IN `endTimestamp` TIMESTAMP, IN `description` VARCHAR(300), IN `startAmount` DOUBLE)
    NO SQL
BEGIN
SET @SQL = CONCAT("INSERT INTO competitions (description, startTimestamp, endTimestamp) VALUES ('", description, "'", ",", "'", startTimestamp, "'", ",", "'", endTimestamp, "')");

PREPARE stmt FROM @SQL;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;


SET @SQL2 = CONCAT("UPDATE competitions SET startAmount = JSON_SET(startAmount,'$.USD',", startAmount, ") WHERE id = (SELECT LAST_INSERT_ID(id) from competitions ORDER BY id DESC LIMIT 1)");

PREPARE stmt FROM @SQL2;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;



END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateBalance`(IN `userID` VARCHAR(50), IN `pl` FLOAT, IN `competitionID` INT)
    NO SQL
BEGIN
SET @SQL = CONCAT("UPDATE balances SET USD = (SELECT USD FROM balances WHERE userID = '", userID, "') + ", pl, " WHERE userID = '", userID, "' AND competitionID = ", competitionID, ";");

PREPARE stmt FROM @SQL;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
END$$
DELIMITER ;
