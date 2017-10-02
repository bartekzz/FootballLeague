# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 127.0.01 (MySQL 5.7.18)
# Database: league
# Generation Time: 2017-10-02 22:14:05 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table coach
# ------------------------------------------------------------

DROP TABLE IF EXISTS `coach`;

CREATE TABLE `coach` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fname` varchar(255) NOT NULL,
  `lname` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `name` (`fname`,`lname`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

LOCK TABLES `coach` WRITE;
/*!40000 ALTER TABLE `coach` DISABLE KEYS */;

INSERT INTO `coach` (`id`, `fname`, `lname`)
VALUES
	(4,'Ernesto','Valverde'),
	(1,'Fabio','Capello'),
	(2,'Jose','Mourinho'),
	(3,'Jurgen','Klopp'),
	(5,'Zinedine','Zidane');

/*!40000 ALTER TABLE `coach` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table game
# ------------------------------------------------------------

DROP TABLE IF EXISTS `game`;

CREATE TABLE `game` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` date NOT NULL,
  `stadium_id` int(11) NOT NULL,
  `team1_id` int(11) NOT NULL,
  `team2_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `date` (`date`,`stadium_id`,`team1_id`,`team2_id`),
  KEY `stadium_id` (`stadium_id`),
  KEY `team1_id` (`team1_id`),
  KEY `team2_id` (`team2_id`),
  CONSTRAINT `game_ibfk_6` FOREIGN KEY (`team2_id`) REFERENCES `team` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8;

LOCK TABLES `game` WRITE;
/*!40000 ALTER TABLE `game` DISABLE KEYS */;

INSERT INTO `game` (`id`, `date`, `stadium_id`, `team1_id`, `team2_id`)
VALUES
	(1,'2016-01-05',1,1,2),
	(2,'2016-01-06',2,2,1),
	(3,'2016-01-07',1,1,2),
	(4,'2016-01-08',2,2,1),
	(5,'2016-01-09',1,1,2),
	(7,'2016-01-10',1,1,2),
	(6,'2016-01-10',2,2,1),
	(8,'2016-01-11',2,2,1),
	(24,'2016-01-11',2,3,1),
	(9,'2016-01-11',2,5,1);

/*!40000 ALTER TABLE `game` ENABLE KEYS */;
UNLOCK TABLES;

DELIMITER ;;
/*!50003 SET SESSION SQL_MODE="ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION" */;;
/*!50003 CREATE */ /*!50017 DEFINER=`root`@`localhost` */ /*!50003 TRIGGER `game_insert` AFTER INSERT ON `game` FOR EACH ROW BEGIN 
UPDATE league.goals_per_game set goals_per_game.avg_goals = (SELECT COUNT(goal.gtime) FROM goal) / (SELECT COUNT(game.id) FROM game);
END */;;
/*!50003 SET SESSION SQL_MODE="ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION" */;;
/*!50003 CREATE */ /*!50017 DEFINER=`root`@`localhost` */ /*!50003 TRIGGER `game_update` AFTER UPDATE ON `game` FOR EACH ROW BEGIN 
UPDATE league.goals_per_game set goals_per_game.avg_goals = (SELECT COUNT(goal.gtime) FROM goal) / (SELECT COUNT(game.id) FROM game);
END */;;
/*!50003 SET SESSION SQL_MODE="ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION" */;;
/*!50003 CREATE */ /*!50017 DEFINER=`root`@`localhost` */ /*!50003 TRIGGER `game_delete` AFTER DELETE ON `game` FOR EACH ROW BEGIN 
UPDATE league.goals_per_game set goals_per_game.avg_goals = (SELECT COUNT(goal.gtime) FROM goal) / (SELECT COUNT(game.id) FROM game);
END */;;
DELIMITER ;
/*!50003 SET SESSION SQL_MODE=@OLD_SQL_MODE */;


# Dump of table goal
# ------------------------------------------------------------

DROP TABLE IF EXISTS `goal`;

CREATE TABLE `goal` (
  `gtime` int(11) NOT NULL,
  `game_id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  PRIMARY KEY (`gtime`,`game_id`),
  KEY `game_id` (`game_id`),
  KEY `player_id` (`player_id`),
  CONSTRAINT `goal_ibfk_3` FOREIGN KEY (`game_id`) REFERENCES `game` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `goal_ibfk_4` FOREIGN KEY (`player_id`) REFERENCES `player` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `goal` WRITE;
/*!40000 ALTER TABLE `goal` DISABLE KEYS */;

INSERT INTO `goal` (`gtime`, `game_id`, `player_id`)
VALUES
	(13,1,1),
	(17,1,1),
	(18,1,1),
	(77,1,1),
	(80,1,1),
	(88,1,1),
	(91,1,1),
	(92,1,1),
	(12,1,2),
	(93,1,4);

/*!40000 ALTER TABLE `goal` ENABLE KEYS */;
UNLOCK TABLES;

DELIMITER ;;
/*!50003 SET SESSION SQL_MODE="ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION" */;;
/*!50003 CREATE */ /*!50017 DEFINER=`root`@`localhost` */ /*!50003 TRIGGER `goal_insert` AFTER INSERT ON `goal` FOR EACH ROW BEGIN 
UPDATE league.goals_per_game set goals_per_game.avg_goals = (SELECT COUNT(goal.gtime) FROM goal) / (SELECT COUNT(game.id) FROM game);
END */;;
/*!50003 SET SESSION SQL_MODE="ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION" */;;
/*!50003 CREATE */ /*!50017 DEFINER=`root`@`localhost` */ /*!50003 TRIGGER `goal_update` AFTER UPDATE ON `goal` FOR EACH ROW BEGIN 
UPDATE league.goals_per_game set goals_per_game.avg_goals = (SELECT COUNT(goal.gtime) FROM goal) / (SELECT COUNT(game.id) FROM game);
END */;;
/*!50003 SET SESSION SQL_MODE="ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION" */;;
/*!50003 CREATE */ /*!50017 DEFINER=`root`@`localhost` */ /*!50003 TRIGGER `goal_delete` AFTER DELETE ON `goal` FOR EACH ROW BEGIN 
UPDATE league.goals_per_game set goals_per_game.avg_goals = (SELECT COUNT(goal.gtime) FROM goal) / (SELECT COUNT(game.id) FROM game);
END */;;
DELIMITER ;
/*!50003 SET SESSION SQL_MODE=@OLD_SQL_MODE */;


# Dump of table goals_per_game
# ------------------------------------------------------------

DROP TABLE IF EXISTS `goals_per_game`;

CREATE TABLE `goals_per_game` (
  `avg_goals` double(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `goals_per_game` WRITE;
/*!40000 ALTER TABLE `goals_per_game` DISABLE KEYS */;

INSERT INTO `goals_per_game` (`avg_goals`)
VALUES
	(1.00);

/*!40000 ALTER TABLE `goals_per_game` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table player
# ------------------------------------------------------------

DROP TABLE IF EXISTS `player`;

CREATE TABLE `player` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fname` varchar(255) NOT NULL,
  `lname` varchar(255) NOT NULL,
  `position_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`fname`,`lname`),
  KEY `position_id` (`position_id`),
  CONSTRAINT `player_ibfk_2` FOREIGN KEY (`position_id`) REFERENCES `position` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;

LOCK TABLES `player` WRITE;
/*!40000 ALTER TABLE `player` DISABLE KEYS */;

INSERT INTO `player` (`id`, `fname`, `lname`, `position_id`)
VALUES
	(1,'Zlatan','Ibrahimovic',1),
	(2,'Lionel','Messi',1),
	(4,'Cristiano','Ronaldo',1),
	(5,'Sergio','Ramos',3),
	(15,'Bartek','Szkurlat',2);

/*!40000 ALTER TABLE `player` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table position
# ------------------------------------------------------------

DROP TABLE IF EXISTS `position`;

CREATE TABLE `position` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `type` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

LOCK TABLES `position` WRITE;
/*!40000 ALTER TABLE `position` DISABLE KEYS */;

INSERT INTO `position` (`id`, `type`)
VALUES
	(3,'defender'),
	(1,'forward'),
	(4,'goalkeeper'),
	(2,'midfielder');

/*!40000 ALTER TABLE `position` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table stadium
# ------------------------------------------------------------

DROP TABLE IF EXISTS `stadium`;

CREATE TABLE `stadium` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

LOCK TABLES `stadium` WRITE;
/*!40000 ALTER TABLE `stadium` DISABLE KEYS */;

INSERT INTO `stadium` (`id`, `name`)
VALUES
	(2,'Anfield'),
	(1,'Old Trafford');

/*!40000 ALTER TABLE `stadium` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table team
# ------------------------------------------------------------

DROP TABLE IF EXISTS `team`;

CREATE TABLE `team` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `coach_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `coach_id` (`coach_id`),
  CONSTRAINT `team_ibfk_2` FOREIGN KEY (`coach_id`) REFERENCES `coach` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

LOCK TABLES `team` WRITE;
/*!40000 ALTER TABLE `team` DISABLE KEYS */;

INSERT INTO `team` (`id`, `name`, `coach_id`)
VALUES
	(1,'Manchester United',2),
	(2,'Liverpool',3),
	(3,'Barcelona FC',4),
	(5,'Real Madrid',5);

/*!40000 ALTER TABLE `team` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table transfer
# ------------------------------------------------------------

DROP TABLE IF EXISTS `transfer`;

CREATE TABLE `transfer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `player_id` int(11) NOT NULL,
  `team_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `player_id` (`player_id`),
  KEY `team_id` (`team_id`),
  CONSTRAINT `transfer_ibfk_3` FOREIGN KEY (`player_id`) REFERENCES `player` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `transfer_ibfk_4` FOREIGN KEY (`team_id`) REFERENCES `team` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

LOCK TABLES `transfer` WRITE;
/*!40000 ALTER TABLE `transfer` DISABLE KEYS */;

INSERT INTO `transfer` (`id`, `start_date`, `end_date`, `player_id`, `team_id`)
VALUES
	(1,'2016-01-01','2018-12-31',1,1),
	(3,'2016-01-02','2020-12-31',2,3),
	(5,'2016-01-03','2019-12-31',4,5),
	(8,'2017-10-01','2017-12-31',1,2);

/*!40000 ALTER TABLE `transfer` ENABLE KEYS */;
UNLOCK TABLES;



--
-- Dumping routines (PROCEDURE) for database 'league'
--
DELIMITER ;;

# Dump of PROCEDURE avgGoals
# ------------------------------------------------------------

/*!50003 DROP PROCEDURE IF EXISTS `avgGoals` */;;
/*!50003 SET SESSION SQL_MODE="ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION"*/;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `avgGoals`()
    MODIFIES SQL DATA
BEGIN
	UPDATE league.goals_per_game set goals_per_game.avg_goals = (SELECT COUNT(goal.gtime) FROM goal) / (SELECT COUNT(game.id) FROM game);
END */;;

/*!50003 SET SESSION SQL_MODE=@OLD_SQL_MODE */;;
# Dump of PROCEDURE createPlayer
# ------------------------------------------------------------

/*!50003 DROP PROCEDURE IF EXISTS `createPlayer` */;;
/*!50003 SET SESSION SQL_MODE="ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION"*/;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `createPlayer`(IN fname VARCHAR(255), IN lname VARCHAR(255), IN position INT)
    MODIFIES SQL DATA
proc_label:BEGIN
	IF position > 4 AND position < 1 THEN
		LEAVE proc_label;
    ELSE
		INSERT INTO player (fname, lname, position_id) VALUES (fname, lname, position);
	END IF;
END */;;

/*!50003 SET SESSION SQL_MODE=@OLD_SQL_MODE */;;
# Dump of PROCEDURE deletePlayer
# ------------------------------------------------------------

/*!50003 DROP PROCEDURE IF EXISTS `deletePlayer` */;;
/*!50003 SET SESSION SQL_MODE="ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION"*/;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `deletePlayer`(IN in_lname VARCHAR(255))
    MODIFIES SQL DATA
BEGIN
	DELETE FROM player WHERE lname LIKE (in_lname);
END */;;

/*!50003 SET SESSION SQL_MODE=@OLD_SQL_MODE */;;
# Dump of PROCEDURE playerStats
# ------------------------------------------------------------

/*!50003 DROP PROCEDURE IF EXISTS `playerStats` */;;
/*!50003 SET SESSION SQL_MODE="ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION"*/;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `playerStats`(IN playerName VARCHAR(255),
OUT o_fname VARCHAR(255), OUT o_lname VARCHAR(255), OUT o_goals INT, OUT o_team VARCHAR(255))
    READS SQL DATA
BEGIN
	SELECT fname as 'first name', lname as 'last name', COUNT(gtime) as goals, team.name as team
	INTO o_fname, o_lname, o_goals, o_team
	FROM player
 JOIN goal ON player.id=goal.player_id 
 JOIN transfer ON player.id=transfer.player_id
 JOIN team ON team.id=transfer.team_id
 WHERE fname LIKE CONCAT('%',playerName,'%') OR lname LIKE CONCAT('%',playerName,'%')
 GROUP BY fname, lname, team.name;
END */;;

/*!50003 SET SESSION SQL_MODE=@OLD_SQL_MODE */;;
# Dump of PROCEDURE showPlayers
# ------------------------------------------------------------

/*!50003 DROP PROCEDURE IF EXISTS `showPlayers` */;;
/*!50003 SET SESSION SQL_MODE="ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION"*/;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `showPlayers`(OUT o_fname VARCHAR(255), OUT o_lname VARCHAR(255))
    READS SQL DATA
BEGIN
	SELECT fname as 'first name', lname as 'last name'
	INTO o_fname, o_lname
	FROM player ORDER BY lname asc;
END */;;

/*!50003 SET SESSION SQL_MODE=@OLD_SQL_MODE */;;
# Dump of PROCEDURE showPlayersInPosition
# ------------------------------------------------------------

/*!50003 DROP PROCEDURE IF EXISTS `showPlayersInPosition` */;;
/*!50003 SET SESSION SQL_MODE="ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION"*/;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `showPlayersInPosition`(IN position VARCHAR(255))
    READS SQL DATA
BEGIN
	SELECT fname as 'first name', lname as 'last name', position.type as position FROM player
 JOIN position ON player.position_id=position.id
 WHERE position.type LIKE (position)
 ORDER BY lname asc;
END */;;

/*!50003 SET SESSION SQL_MODE=@OLD_SQL_MODE */;;
# Dump of PROCEDURE showPositionCategories
# ------------------------------------------------------------

/*!50003 DROP PROCEDURE IF EXISTS `showPositionCategories` */;;
/*!50003 SET SESSION SQL_MODE="ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION"*/;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `showPositionCategories`()
    READS SQL DATA
BEGIN
	SELECT type as positions FROM position ORDER BY id asc;
END */;;

/*!50003 SET SESSION SQL_MODE=@OLD_SQL_MODE */;;
# Dump of PROCEDURE updatePlayer
# ------------------------------------------------------------

/*!50003 DROP PROCEDURE IF EXISTS `updatePlayer` */;;
/*!50003 SET SESSION SQL_MODE="ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION"*/;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `updatePlayer`(IN in_lname VARCHAR(255), IN position INT)
    MODIFIES SQL DATA
proc_label:BEGIN
	IF position > 4 AND position < 1 THEN
		LEAVE proc_label;
    ELSE
		UPDATE player SET position_id = position WHERE lname LIKE (in_lname);
	END IF;
END */;;

/*!50003 SET SESSION SQL_MODE=@OLD_SQL_MODE */;;
DELIMITER ;

/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
