-- phpMyAdmin SQL Dump
-- version 4.9.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Sep 05, 2020 at 09:24 PM
-- Server version: 10.4.10-MariaDB
-- PHP Version: 7.3.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `concordant`
--

-- --------------------------------------------------------

--
-- Table structure for table `grievance`
--

DROP TABLE IF EXISTS `grievance`;
CREATE TABLE IF NOT EXISTS `grievance` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `treaty_id` int(11) NOT NULL,
  `organization_id` int(11) NOT NULL,
  `creator_user_id` int(11) NOT NULL,
  `create_date` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `creator_user_id` (`creator_user_id`),
  KEY `organization_id` (`organization_id`),
  KEY `treaty_id` (`treaty_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `grievance`
--

INSERT INTO `grievance` (`id`, `title`, `description`, `treaty_id`, `organization_id`, `creator_user_id`, `create_date`) VALUES
(1, 'being sexist', 'guys are jerks sometimes', 2, 6, 1, '2020-09-30 00:00:00'),
(2, 'women complaining', 'lalala', 2, 5, 1, '2020-09-16 00:00:00'),
(3, 'shooting schools', 'stop the killing ', 1, 1, 1, '2020-09-15 00:00:00'),
(4, 'protesting police violence', 'and burning stuff', 1, 2, 1, '2020-09-09 00:00:00'),
(5, 'being against trump', 'its not nice', 1, 2, 1, '2020-09-21 00:00:00'),
(8, 'being too cool', 'Watch how the DreamFactory API Platform automatically generates REST APIs for MS SQL Server and gets your backend sorted quickly and easily. Walk through by Jason Gilmore, DreamFactory\'s CTO and author of Easy Laravel.', 1, 2, 2, '2020-09-16 00:00:00'),
(9, 'asdf adsfasdf', 'Master difficult programming concepts in few minutes. I try to explain difficult concepts like Java concurrency in simple to understand manner. Explore videos on topics like Spring Boot, Cloud Foundry, Java 8 and more. I am happy to clarify your doubts. Ask me anything in the comments. Also happy to take requests for new videos. Master difficult programming concepts in few minutes. I try to explain difficult concepts like Java concurrency in simple to understand manner. Explore videos on topics like Spring Boot, Cloud Foundry, Java 8 and more. I am happy to clarify your doubts. Ask me anything in the comments. Also happy to take requests for new videos. ', 1, 2, 1, '2020-09-14 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `grievance_comment`
--

DROP TABLE IF EXISTS `grievance_comment`;
CREATE TABLE IF NOT EXISTS `grievance_comment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` text NOT NULL,
  `creator_user_id` int(11) NOT NULL,
  `grievance_id` int(11) NOT NULL,
  `create_date` datetime NOT NULL,
  `media_url` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `creator_user_id` (`creator_user_id`),
  KEY `grievance_id` (`grievance_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `grievance_comment`
--

INSERT INTO `grievance_comment` (`id`, `text`, `creator_user_id`, `grievance_id`, `create_date`, `media_url`) VALUES
(1, 'bullshit u shoot schools', 1, 3, '2020-08-10 00:00:00', 'https://www.youtube.com/watch?v=q8QESv_t2Lk&ab_channel=LasseBurholt'),
(2, 'fef ef ef', 2, 3, '2020-09-05 16:03:01', '');

-- --------------------------------------------------------

--
-- Table structure for table `offer`
--

DROP TABLE IF EXISTS `offer`;
CREATE TABLE IF NOT EXISTS `offer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `treaty_id` int(11) NOT NULL,
  `organization_id` int(11) NOT NULL,
  `creator_user_id` int(11) NOT NULL,
  `create_date` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `creator_user_id` (`creator_user_id`),
  KEY `organization_id` (`organization_id`),
  KEY `treaty_id` (`treaty_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `offer`
--

INSERT INTO `offer` (`id`, `title`, `description`, `treaty_id`, `organization_id`, `creator_user_id`, `create_date`) VALUES
(1, 'grow pot', 'funky skunky shit', 1, 1, 2, '2020-09-17 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `offer_comment`
--

DROP TABLE IF EXISTS `offer_comment`;
CREATE TABLE IF NOT EXISTS `offer_comment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` text NOT NULL,
  `creator_user_id` int(11) NOT NULL,
  `offer_id` int(11) NOT NULL,
  `create_date` datetime NOT NULL,
  `media_url` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `offer_id` (`offer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `organization`
--

DROP TABLE IF EXISTS `organization`;
CREATE TABLE IF NOT EXISTS `organization` (
  `name` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `avatar_url` varchar(200) NOT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `creator_user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `creator_user_id` (`creator_user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `organization`
--

INSERT INTO `organization` (`name`, `description`, `avatar_url`, `id`, `creator_user_id`) VALUES
('liberals', 'lefties bros and gals', 'https://images.unsplash.com/photo-1599046275743-0bad6f894738?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80', 1, 1),
('conservatives', 'right wingers', 'https://images.unsplash.com/photo-1566315364780-c1789668ca6e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=996&q=80', 2, 1),
('Men', 'dude yo', 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80', 5, 1),
('Women', 'ladies night', 'https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1350&q=80', 6, 1);

-- --------------------------------------------------------

--
-- Table structure for table `treaty`
--

DROP TABLE IF EXISTS `treaty`;
CREATE TABLE IF NOT EXISTS `treaty` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `creator_user_id` int(11) NOT NULL,
  `organization_a_id` int(11) NOT NULL,
  `organization_b_id` int(11) NOT NULL,
  `avatar_url` varchar(128) NOT NULL,
  `status` varchar(12) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `creator_user_id` (`creator_user_id`),
  KEY `organization_a_id` (`organization_a_id`),
  KEY `organization_b_id` (`organization_b_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `treaty`
--

INSERT INTO `treaty` (`id`, `name`, `description`, `creator_user_id`, `organization_a_id`, `organization_b_id`, `avatar_url`, `status`) VALUES
(1, 'American politics', 'chill libs and cons', 1, 1, 2, 'https://images.unsplash.com/photo-1460342892743-8889b6be3a99?ixlib=rb-1.2.1&auto=format&fit=crop&w=1346&q=80', 'pending'),
(2, 'Men and Women', 'ladies and dudes okay', 1, 5, 6, '', 'pending');

-- --------------------------------------------------------

--
-- Table structure for table `treaty_comment`
--

DROP TABLE IF EXISTS `treaty_comment`;
CREATE TABLE IF NOT EXISTS `treaty_comment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` text NOT NULL,
  `creator_user_id` int(11) NOT NULL,
  `treaty_id` int(11) NOT NULL,
  `create_date` datetime NOT NULL,
  `media_url` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `creator_user_id` (`creator_user_id`),
  KEY `treaty_id` (`treaty_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
CREATE TABLE IF NOT EXISTS `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `name` varchar(100) NOT NULL,
  `biography` text NOT NULL,
  `password` char(32) NOT NULL,
  `type_id` int(11) NOT NULL,
  `create_date` datetime NOT NULL,
  `location` varchar(255) NOT NULL,
  `avatar_url` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `email`, `name`, `biography`, `password`, `type_id`, `create_date`, `location`, `avatar_url`) VALUES
(1, 'admin@concordant.io', 'Bob Baloney', 'Handsome man with hairy chest', '123456', 0, '2020-09-01 18:51:45', 'Houston', 'https://images.unsplash.com/photo-1540464148-e306e5543db4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=648&q=80'),
(2, 'nick@ni.net', 'Nick', 'afe aff  aef', '123', 0, '2020-09-01 18:51:45', 'Austin', 'https://images.unsplash.com/photo-1452857297128-d9c29adba80b?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1267&q=80');

-- --------------------------------------------------------

--
-- Table structure for table `user_to_organization`
--

DROP TABLE IF EXISTS `user_to_organization`;
CREATE TABLE IF NOT EXISTS `user_to_organization` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `creator_user_id` int(11) NOT NULL,
  `organization_id` int(11) NOT NULL,
  `create_date` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `creator_user_id` (`creator_user_id`),
  KEY `organization_id` (`organization_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `vote`
--

DROP TABLE IF EXISTS `vote`;
CREATE TABLE IF NOT EXISTS `vote` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `creator_user_id` int(11) NOT NULL,
  `treaty_id` int(11) NOT NULL,
  `vote_type` tinyint(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `creator_user_id` (`creator_user_id`),
  KEY `treaty_id` (`treaty_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `vote`
--

INSERT INTO `vote` (`id`, `creator_user_id`, `treaty_id`, `vote_type`) VALUES
(1, 2, 1, 0),
(2, 1, 1, 1),
(3, 1, 2, 1);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `grievance`
--
ALTER TABLE `grievance`
  ADD CONSTRAINT `grievance_ibfk_1` FOREIGN KEY (`creator_user_id`) REFERENCES `user` (`id`),
  ADD CONSTRAINT `grievance_ibfk_2` FOREIGN KEY (`organization_id`) REFERENCES `organization` (`id`),
  ADD CONSTRAINT `grievance_ibfk_3` FOREIGN KEY (`treaty_id`) REFERENCES `treaty` (`id`);

--
-- Constraints for table `grievance_comment`
--
ALTER TABLE `grievance_comment`
  ADD CONSTRAINT `grievance_comment_ibfk_1` FOREIGN KEY (`creator_user_id`) REFERENCES `user` (`id`),
  ADD CONSTRAINT `grievance_comment_ibfk_2` FOREIGN KEY (`grievance_id`) REFERENCES `grievance` (`id`);

--
-- Constraints for table `offer`
--
ALTER TABLE `offer`
  ADD CONSTRAINT `offer_ibfk_1` FOREIGN KEY (`creator_user_id`) REFERENCES `user` (`id`),
  ADD CONSTRAINT `offer_ibfk_2` FOREIGN KEY (`organization_id`) REFERENCES `organization` (`id`),
  ADD CONSTRAINT `offer_ibfk_3` FOREIGN KEY (`treaty_id`) REFERENCES `treaty` (`id`);

--
-- Constraints for table `offer_comment`
--
ALTER TABLE `offer_comment`
  ADD CONSTRAINT `offer_comment_ibfk_1` FOREIGN KEY (`offer_id`) REFERENCES `offer` (`id`);

--
-- Constraints for table `organization`
--
ALTER TABLE `organization`
  ADD CONSTRAINT `organization_ibfk_1` FOREIGN KEY (`creator_user_id`) REFERENCES `user` (`id`);

--
-- Constraints for table `treaty`
--
ALTER TABLE `treaty`
  ADD CONSTRAINT `treaty_ibfk_1` FOREIGN KEY (`creator_user_id`) REFERENCES `user` (`id`),
  ADD CONSTRAINT `treaty_ibfk_2` FOREIGN KEY (`organization_a_id`) REFERENCES `organization` (`id`),
  ADD CONSTRAINT `treaty_ibfk_3` FOREIGN KEY (`organization_b_id`) REFERENCES `organization` (`id`);

--
-- Constraints for table `treaty_comment`
--
ALTER TABLE `treaty_comment`
  ADD CONSTRAINT `treaty_comment_ibfk_1` FOREIGN KEY (`creator_user_id`) REFERENCES `user` (`id`),
  ADD CONSTRAINT `treaty_comment_ibfk_2` FOREIGN KEY (`treaty_id`) REFERENCES `treaty` (`id`);

--
-- Constraints for table `user_to_organization`
--
ALTER TABLE `user_to_organization`
  ADD CONSTRAINT `user_to_organization_ibfk_1` FOREIGN KEY (`creator_user_id`) REFERENCES `user` (`id`),
  ADD CONSTRAINT `user_to_organization_ibfk_2` FOREIGN KEY (`organization_id`) REFERENCES `organization` (`id`);

--
-- Constraints for table `vote`
--
ALTER TABLE `vote`
  ADD CONSTRAINT `vote_ibfk_1` FOREIGN KEY (`creator_user_id`) REFERENCES `user` (`id`),
  ADD CONSTRAINT `vote_ibfk_2` FOREIGN KEY (`treaty_id`) REFERENCES `treaty` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
