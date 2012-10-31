CREATE TABLE `user` (
  `iduser` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  PRIMARY KEY (`iduser`),
  UNIQUE KEY `username_UNIQUE` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `presentation` (
  `idpresentation` int(11) NOT NULL AUTO_INCREMENT,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `title` varchar(255) NOT NULL,
  `filename` varchar(255) NOT NULL,
  PRIMARY KEY (`idpresentation`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;


insert  into `presentation`(`idpresentation`,`timestamp`,`title`,`filename`) values (1,'2012-10-09 23:44:39','Bachelorarbeit von Stefan Csizmazia','ba_0728096');



CREATE TABLE `slide` (
  `idslide` int(11) NOT NULL AUTO_INCREMENT,
  `idpresentation` int(11) NOT NULL,
  `title` text,
  `page_number` int(11) NOT NULL,
  PRIMARY KEY (`idslide`),
  KEY `fk_slide_presentation` (`idpresentation`),
  CONSTRAINT `fk_slide_presentation` FOREIGN KEY (`idpresentation`) REFERENCES `presentation` (`idpresentation`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


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

CREATE TABLE `external_link` (
  `idexternal_link` int(11) NOT NULL AUTO_INCREMENT,
  `url` text NOT NULL,
  `title` text,
  PRIMARY KEY (`idexternal_link`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `comment_has_external_link` (
  `idcomment` int(11) NOT NULL,
  `idexternal_link` int(11) NOT NULL,
  PRIMARY KEY (`idcomment`,`idexternal_link`),
  KEY `fk_comment_has_external_link_external_link2` (`idexternal_link`),
  KEY `fk_comment_has_external_link_comment2` (`idcomment`),
  CONSTRAINT `fk_comment_has_external_link_comment2` FOREIGN KEY (`idcomment`) REFERENCES `comment` (`idcomment`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_comment_has_external_link_external_link2` FOREIGN KEY (`idexternal_link`) REFERENCES `external_link` (`idexternal_link`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `note_has_external_link` (
  `idnote` int(11) NOT NULL,
  `idexternal_link` int(11) NOT NULL,
  PRIMARY KEY (`idnote`,`idexternal_link`),
  KEY `fk_comment_has_external_link_external_link1` (`idexternal_link`),
  KEY `fk_comment_has_external_link_comment1` (`idnote`),
  CONSTRAINT `fk_comment_has_external_link_comment1` FOREIGN KEY (`idnote`) REFERENCES `note` (`idnote`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_comment_has_external_link_external_link1` FOREIGN KEY (`idexternal_link`) REFERENCES `external_link` (`idexternal_link`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



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

