-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 23, 2024 at 03:47 AM
-- Server version: 10.4.22-MariaDB
-- PHP Version: 8.1.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `revision_scheduler`
--

-- --------------------------------------------------------

--
-- Table structure for table `blocked_website`
--

CREATE TABLE `blocked_website` (
  `URL` varchar(255) NOT NULL,
  `user_ID` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `friendship`
--

CREATE TABLE `friendship` (
  `friendship_ID` int(10) NOT NULL,
  `user_ID` int(10) NOT NULL,
  `friend_ID` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `quiz`
--

CREATE TABLE `quiz` (
  `quiz_ID` int(10) NOT NULL,
  `user_ID` int(10) NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `quiz`
--

INSERT INTO `quiz` (`quiz_ID`, `user_ID`, `name`) VALUES
(1, 6, 'test'),
(8, 6, 'test2'),
(9, 6, 'test3');

-- --------------------------------------------------------

--
-- Table structure for table `quiz_option`
--

CREATE TABLE `quiz_option` (
  `quiz_option_ID` int(10) NOT NULL,
  `quiz_question_ID` int(10) NOT NULL,
  `text` varchar(255) NOT NULL,
  `correct_option` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `quiz_option`
--

INSERT INTO `quiz_option` (`quiz_option_ID`, `quiz_question_ID`, `text`, `correct_option`) VALUES
(1, 1, 'yes', 1),
(2, 1, 'no', 0),
(3, 1, 'maybe', 0),
(4, 1, 'yesn\'t', 0),
(5, 2, 'woohoo', 1),
(6, 2, 'wahey', 0),
(7, 2, 'hurray', 0),
(8, 2, 'yahoo', 0),
(9, 3, 'a wombat!', 0),
(10, 3, 'jigglypuff', 0),
(11, 3, 'something', 0),
(12, 3, 'friend', 1),
(13, 4, 'you rock', 0),
(14, 4, 'nice job', 0),
(15, 4, 'Awesome', 0),
(16, 4, 'No problem', 1),
(17, 5, 'consciousness', 0),
(18, 5, 'sixth', 0),
(19, 5, 'dimension', 0),
(20, 5, 'woah', 1),
(21, 6, 'our own decree', 0),
(22, 6, 'all of those', 0),
(23, 6, 'infernos', 0),
(24, 6, 'something', 1);

-- --------------------------------------------------------

--
-- Table structure for table `quiz_question`
--

CREATE TABLE `quiz_question` (
  `quiz_question_ID` int(10) NOT NULL,
  `quiz_ID` int(10) NOT NULL,
  `description` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `quiz_question`
--

INSERT INTO `quiz_question` (`quiz_question_ID`, `quiz_ID`, `description`) VALUES
(1, 1, 'can you see this?'),
(2, 1, 'second'),
(3, 8, 'what are you?'),
(4, 8, '2nd'),
(5, 9, 'wait a minute'),
(6, 9, 'nothing gets in the way');

-- --------------------------------------------------------

--
-- Table structure for table `task`
--

CREATE TABLE `task` (
  `task_ID` int(10) NOT NULL,
  `assigner_ID` int(10) NOT NULL,
  `assignee_ID` int(10) NOT NULL,
  `task_name` varchar(255) NOT NULL,
  `due_date` date NOT NULL,
  `task_type` varchar(255) NOT NULL,
  `completion_status` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `task`
--

INSERT INTO `task` (`task_ID`, `assigner_ID`, `assignee_ID`, `task_name`, `due_date`, `task_type`, `completion_status`) VALUES
(7, 1, 1, 'hexakill', '2024-04-06', 'task', 'complete'),
(11, 1, 1, 'mayday', '2024-05-01', 'task', 'complete'),
(12, 1, 1, 'merchant', '2024-03-01', 'task', 'complete'),
(18, 1, 1, 'soda pop frequency', '2024-04-03', 'task', 'complete'),
(20, 1, 1, 'go', '2024-04-04', 'task', 'incomplete'),
(40, 2, 2, 'two', '2024-04-02', 'task', 'incomplete'),
(41, 2, 2, 'eight', '2024-04-08', 'task', 'complete'),
(42, 2, 2, 'ten', '2024-04-10', 'task', 'complete'),
(43, 2, 2, 'sixteen', '2024-04-16', 'task', 'incomplete'),
(45, 2, 2, 'bait', '2024-04-08', 'task', 'incomplete'),
(46, 2, 2, 'fun', '2024-03-01', 'task', 'incomplete'),
(47, 2, 2, 'line', '2024-03-09', 'task', 'incomplete'),
(48, 2, 2, 'phiphteen', '2024-03-15', 'task', 'incomplete'),
(49, 2, 2, 'heaven', '2024-03-07', 'task', 'incomplete'),
(50, 2, 2, 'leevrage', '2024-03-07', 'task', 'complete'),
(51, 2, 2, 'doodoo', '2024-05-01', 'task', 'incomplete'),
(52, 2, 2, 'zine', '2024-05-09', 'task', 'complete'),
(53, 2, 2, 'devin', '2024-05-07', 'task', 'incomplete'),
(55, 6, 6, 'test6', '2024-04-17', 'task', 'incomplete'),
(56, 6, 6, 'oggy', '2024-04-10', 'task', 'complete'),
(58, 1, 1, 'sneaky driver', '2024-04-05', 'task', 'incomplete'),
(59, 6, 6, 'nine', '2024-04-09', 'task', 'incomplete'),
(60, 6, 6, 'eight', '2024-04-08', 'task', 'incomplete'),
(61, 6, 6, 'seven', '2024-04-07', 'task', 'incomplete'),
(62, 6, 6, 'six', '2024-04-06', 'task', 'incomplete'),
(63, 6, 6, 'five', '2024-04-05', 'task', 'complete'),
(64, 6, 6, 'eleven', '2024-04-11', 'task', 'incomplete'),
(65, 6, 6, 'delve', '2024-04-12', 'task', 'incomplete'),
(67, 6, 6, 'kevin', '2024-04-11', 'task', 'incomplete'),
(68, 6, 6, 'thirteen', '2024-04-13', 'task', 'complete'),
(69, 6, 6, 'fourteen', '2024-04-14', 'task', 'complete'),
(70, 6, 6, 'wan', '2024-03-01', 'task', 'incomplete'),
(72, 6, 6, 'boo', '2024-03-02', 'task', 'incomplete'),
(73, 6, 6, 'four bore', '2024-05-04', 'task', 'complete'),
(77, 6, 6, 'Fighters', '2024-04-20', 'task', 'incomplete'),
(81, 6, 6, 'test3', '2024-04-28', 'quiz', 'complete'),
(82, 6, 6, 'test', '2024-04-27', 'quiz', 'complete'),
(84, 6, 6, 'Ayyy', '2024-04-18', 'task', 'incomplete');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `user_ID` int(10) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`user_ID`, `email`, `password`) VALUES
(1, 'abc@example.com', 'b'),
(2, 'west@example.com', 'c'),
(4, 'testy@example.com', 'TestPassword0.'),
(6, 'q', 'w');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `blocked_website`
--
ALTER TABLE `blocked_website`
  ADD PRIMARY KEY (`URL`),
  ADD KEY `user_ID` (`user_ID`);

--
-- Indexes for table `friendship`
--
ALTER TABLE `friendship`
  ADD PRIMARY KEY (`friendship_ID`),
  ADD KEY `user_ID` (`user_ID`),
  ADD KEY `friend_ID` (`friend_ID`);

--
-- Indexes for table `quiz`
--
ALTER TABLE `quiz`
  ADD PRIMARY KEY (`quiz_ID`),
  ADD KEY `user_ID` (`user_ID`);

--
-- Indexes for table `quiz_option`
--
ALTER TABLE `quiz_option`
  ADD PRIMARY KEY (`quiz_option_ID`),
  ADD KEY `quiz_question_ID` (`quiz_question_ID`);

--
-- Indexes for table `quiz_question`
--
ALTER TABLE `quiz_question`
  ADD PRIMARY KEY (`quiz_question_ID`),
  ADD KEY `quiz_ID` (`quiz_ID`);

--
-- Indexes for table `task`
--
ALTER TABLE `task`
  ADD PRIMARY KEY (`task_ID`),
  ADD KEY `assigner_ID` (`assigner_ID`),
  ADD KEY `assignee_ID` (`assignee_ID`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`user_ID`),
  ADD UNIQUE KEY `user_ID` (`user_ID`,`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `friendship`
--
ALTER TABLE `friendship`
  MODIFY `friendship_ID` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `quiz`
--
ALTER TABLE `quiz`
  MODIFY `quiz_ID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `quiz_option`
--
ALTER TABLE `quiz_option`
  MODIFY `quiz_option_ID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `quiz_question`
--
ALTER TABLE `quiz_question`
  MODIFY `quiz_question_ID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `task`
--
ALTER TABLE `task`
  MODIFY `task_ID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=85;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `user_ID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `blocked_website`
--
ALTER TABLE `blocked_website`
  ADD CONSTRAINT `blocked_website_ibfk_1` FOREIGN KEY (`user_ID`) REFERENCES `user` (`user_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `friendship`
--
ALTER TABLE `friendship`
  ADD CONSTRAINT `friendship_ibfk_1` FOREIGN KEY (`user_ID`) REFERENCES `user` (`user_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `friendship_ibfk_2` FOREIGN KEY (`friend_ID`) REFERENCES `user` (`user_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `quiz`
--
ALTER TABLE `quiz`
  ADD CONSTRAINT `quiz_ibfk_1` FOREIGN KEY (`user_ID`) REFERENCES `user` (`user_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `quiz_option`
--
ALTER TABLE `quiz_option`
  ADD CONSTRAINT `quiz_option_ibfk_1` FOREIGN KEY (`quiz_question_ID`) REFERENCES `quiz_question` (`quiz_question_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `quiz_question`
--
ALTER TABLE `quiz_question`
  ADD CONSTRAINT `quiz_question_ibfk_1` FOREIGN KEY (`quiz_ID`) REFERENCES `quiz` (`quiz_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `task`
--
ALTER TABLE `task`
  ADD CONSTRAINT `task_ibfk_1` FOREIGN KEY (`assigner_ID`) REFERENCES `user` (`user_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `task_ibfk_2` FOREIGN KEY (`assignee_ID`) REFERENCES `user` (`user_ID`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
