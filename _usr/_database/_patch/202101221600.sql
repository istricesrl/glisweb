CREATE TABLE IF NOT EXISTS `__acl_attivita__` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_entita` int(11) NOT NULL,
  `id_gruppo` int(11) NOT NULL,
  `permesso` char(8) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_entita` (`id_entita`,`id_gruppo`),
  KEY `id_gruppo` (`id_gruppo`),
  CONSTRAINT `__acl_attivita___ibfk_1` FOREIGN KEY (`id_entita`) REFERENCES `attivita` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `__acl_attivita___ibfk_2` FOREIGN KEY (`id_gruppo`) REFERENCES `gruppi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;