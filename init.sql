/*
SQLyog Community v9.30 
MySQL - 5.5.16 : Database - slidehub
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
/*Table structure for table `comment` */

CREATE TABLE `comment` (
  `idcomment` int(11) NOT NULL AUTO_INCREMENT,
  `idnote` int(11) NOT NULL,
  `iduser` int(11) NOT NULL,
  `content` text NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`idcomment`),
  KEY `fk_comment_note1` (`idnote`),
  KEY `fk_comment_user2` (`iduser`),
  CONSTRAINT `fk_comment_note1` FOREIGN KEY (`idnote`) REFERENCES `note` (`idnote`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_comment_user2` FOREIGN KEY (`iduser`) REFERENCES `user` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `comment` */

/*Table structure for table `comment_has_external_link` */

CREATE TABLE `comment_has_external_link` (
  `idcomment` int(11) NOT NULL,
  `idexternal_link` int(11) NOT NULL,
  PRIMARY KEY (`idcomment`,`idexternal_link`),
  KEY `fk_comment_has_external_link_external_link2` (`idexternal_link`),
  KEY `fk_comment_has_external_link_comment2` (`idcomment`),
  CONSTRAINT `fk_comment_has_external_link_comment2` FOREIGN KEY (`idcomment`) REFERENCES `comment` (`idcomment`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_comment_has_external_link_external_link2` FOREIGN KEY (`idexternal_link`) REFERENCES `external_link` (`idexternal_link`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `comment_has_external_link` */

/*Table structure for table `external_link` */

CREATE TABLE `external_link` (
  `idexternal_link` int(11) NOT NULL AUTO_INCREMENT,
  `url` text NOT NULL,
  `title` text,
  PRIMARY KEY (`idexternal_link`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `external_link` */

/*Table structure for table `note` */

CREATE TABLE `note` (
  `idnote` int(11) NOT NULL AUTO_INCREMENT,
  `idslide` int(11) NOT NULL,
  `iduser` int(11) NOT NULL,
  `content` text NOT NULL,
  `slide_x` int(11) DEFAULT NULL,
  `slide_y` int(11) DEFAULT NULL,
  `type` varchar(45) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`idnote`),
  KEY `fk_comment_slide1` (`idslide`),
  KEY `fk_comment_user1` (`iduser`),
  CONSTRAINT `fk_comment_slide1` FOREIGN KEY (`idslide`) REFERENCES `slide` (`idslide`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_comment_user1` FOREIGN KEY (`iduser`) REFERENCES `user` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

/*Data for the table `note` */

insert  into `note`(`idnote`,`idslide`,`iduser`,`content`,`slide_x`,`slide_y`,`type`,`timestamp`) values (1,1,1,'testcomment',NULL,NULL,'std','2012-11-01 13:56:12');

/*Table structure for table `note_has_external_link` */

CREATE TABLE `note_has_external_link` (
  `idnote` int(11) NOT NULL,
  `idexternal_link` int(11) NOT NULL,
  PRIMARY KEY (`idnote`,`idexternal_link`),
  KEY `fk_comment_has_external_link_external_link1` (`idexternal_link`),
  KEY `fk_comment_has_external_link_comment1` (`idnote`),
  CONSTRAINT `fk_comment_has_external_link_comment1` FOREIGN KEY (`idnote`) REFERENCES `note` (`idnote`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_comment_has_external_link_external_link1` FOREIGN KEY (`idexternal_link`) REFERENCES `external_link` (`idexternal_link`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `note_has_external_link` */

/*Table structure for table `presentation` */

CREATE TABLE `presentation` (
  `idpresentation` int(11) NOT NULL AUTO_INCREMENT,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `title` varchar(255) NOT NULL,
  `filename` varchar(255) NOT NULL,
  PRIMARY KEY (`idpresentation`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Data for the table `presentation` */

insert  into `presentation`(`idpresentation`,`timestamp`,`title`,`filename`) values (1,'2012-10-09 23:44:39','Bachelorarbeit von Stefan Csizmazia','ba_0728096');

/*Table structure for table `slide` */

CREATE TABLE `slide` (
  `idslide` int(11) NOT NULL AUTO_INCREMENT,
  `idpresentation` int(11) NOT NULL,
  `title` text,
  `page_number` int(11) NOT NULL,
  PRIMARY KEY (`idslide`),
  KEY `fk_slide_presentation` (`idpresentation`),
  CONSTRAINT `fk_slide_presentation` FOREIGN KEY (`idpresentation`) REFERENCES `presentation` (`idpresentation`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Data for the table `slide` */

insert  into `slide`(`idslide`,`idpresentation`,`title`,`page_number`) values (1,1,'was auch immer',1);

/*Table structure for table `user` */

CREATE TABLE `user` (
  `iduser` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  PRIMARY KEY (`iduser`),
  UNIQUE KEY `username_UNIQUE` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;

/*Data for the table `user` */

insert  into `user`(`iduser`,`username`,`email`) values (1,'testuser','test@mailinator.com');

/*Table structure for table `vote` */

CREATE TABLE `vote` (
  `iduser` int(11) NOT NULL,
  `idnote` int(11) NOT NULL,
  `vote` tinyint(4) NOT NULL,
  PRIMARY KEY (`iduser`,`idnote`),
  KEY `fk_user_has_comment_comment1` (`idnote`),
  KEY `fk_user_has_comment_user1` (`iduser`),
  CONSTRAINT `fk_user_has_comment_comment1` FOREIGN KEY (`idnote`) REFERENCES `note` (`idnote`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_has_comment_user1` FOREIGN KEY (`iduser`) REFERENCES `user` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `vote` */

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
