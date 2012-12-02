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

/*Table structure for table `user` */

CREATE TABLE `user` (
  `iduser` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `salt` varchar(255) NOT NULL,
  PRIMARY KEY (`iduser`),
  UNIQUE KEY `username_UNIQUE` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Data for the table `user` */

insert  into `user`(`iduser`,`username`,`email`, `password`) values (1,'testuser','test@test.com', 'ee26b0dd4af7e749aa1a8ee3c10ae9923f618980772e473f8819a5d4940e0db27ac185f8a0e1d5f84f88bc887fd67b143732c304cc5fa9ad8e6f57f50028a8ff');

/*Table structure for table `note` */

CREATE TABLE `note` (
  `idnote` int(11) NOT NULL AUTO_INCREMENT,
  `idpresentation` int(11) NOT NULL,
  `iduser` int(11) NOT NULL,
  `content` text NOT NULL,
  `slide_no` int(10) unsigned NOT NULL,
  `slide_x` int(11) DEFAULT NULL,
  `slide_y` int(11) DEFAULT NULL,
  `type` varchar(45) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`idnote`),
  KEY `fk_comment_user1` (`iduser`),
  KEY `fk_note_presentation1` (`idpresentation`),
  CONSTRAINT `fk_comment_user1` FOREIGN KEY (`iduser`) REFERENCES `user` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_note_presentation1` FOREIGN KEY (`idpresentation`) REFERENCES `presentation` (`idpresentation`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Data for the table `note` */

insert  into `note`(`idnote`,`idpresentation`,`iduser`,`content`,`slide_no`,`slide_x`,`slide_y`,`type`,`timestamp`) values (1,1,1,'lorem ipsum',1,NULL,NULL,'std','2012-11-01 21:15:42');


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

/*Table structure for table `external_link` */

CREATE TABLE `external_link` (
  `idexternal_link` int(11) NOT NULL AUTO_INCREMENT,
  `url` text NOT NULL,
  `title` text,
  PRIMARY KEY (`idexternal_link`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `external_link` */

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

/*Table structure for table `vote` */

CREATE TABLE `vote` (
  `iduser` int(11) NOT NULL,
  `idnote` int(11) NOT NULL,
  `vote` tinyint(4) NOT NULL,
  PRIMARY KEY (`iduser`,`idnote`),
  KEY `fk_user_has_comment_comment1` (`idnote`),
  KEY `fk_user_has_comment_user1` (`iduser`),
  CONSTRAINT `fk_user_has_comment_user1` FOREIGN KEY (`iduser`) REFERENCES `user` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_has_comment_comment1` FOREIGN KEY (`idnote`) REFERENCES `note` (`idnote`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `vote` */
