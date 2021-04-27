CREATE TABLE IF NOT EXISTS `__acl_anagrafica__` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_entita` int(11) NOT NULL,
  `id_gruppo` int(11) NOT NULL,
  `permesso` char(8) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_entita` (`id_entita`,`id_gruppo`),
  KEY `id_gruppo` (`id_gruppo`),
  KEY `id_entita_2` (`id_entita`),
  CONSTRAINT `__acl_anagrafica___ibfk_1_nofollow` FOREIGN KEY (`id_entita`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `__acl_anagrafica___ibfk_2_nofollow` FOREIGN KEY (`id_gruppo`) REFERENCES `gruppi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
