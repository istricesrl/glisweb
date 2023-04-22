--
-- ACL
-- questo file contiene le query per la creazione delle tabelle di ACL
--

-- | 040000000400

-- __acl_anagrafica__
-- tipologia: tabella gestita
-- verifica: 2021-05-28 17:39 Fabio Mosti
CREATE TABLE IF NOT EXISTS`__acl_anagrafica__` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_entita` int(11) NOT NULL,
  `id_gruppo` int(11) DEFAULT NULL,
  `id_account` int(11) DEFAULT NULL,
  `permesso` char(8) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_entita`,`id_gruppo`),
  KEY `id_gruppo` (`id_gruppo`),
  KEY `id_entita` (`id_entita`),
  KEY `id_account` (`id_account`),
  CONSTRAINT `__acl_anagrafica___ibfk_01_nofollow` FOREIGN KEY (`id_entita`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `__acl_anagrafica___ibfk_02_nofollow` FOREIGN KEY (`id_gruppo`) REFERENCES `gruppi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `__acl_anagrafica___ibfk_03_nofollow` FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 040000001800

-- __acl_attivita__
-- tipologia: tabella gestita
-- verifica: 2021-05-28 17:45 Fabio Mosti
CREATE TABLE IF NOT EXISTS `__acl_attivita__` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_entita` int(11) NOT NULL,
  `id_gruppo` int(11) DEFAULT NULL,
  `id_account` int(11) DEFAULT NULL,
  `permesso` char(8) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_entita`,`id_gruppo`),
  KEY `id_gruppo` (`id_gruppo`),
  KEY `id_entita` (`id_entita`),
  KEY `id_account` (`id_account`),
  CONSTRAINT `__acl_attivita___ibfk_01_nofollow` FOREIGN KEY (`id_entita`) REFERENCES `attivita` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `__acl_attivita___ibfk_02_nofollow` FOREIGN KEY (`id_gruppo`) REFERENCES `gruppi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `__acl_attivita___ibfk_03_nofollow` FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 040000023200

-- __acl_pagine__
-- tipologia: tabella gestita
-- verifica: 2021-05-28 17:45 Fabio Mosti
CREATE TABLE IF NOT EXISTS `__acl_pagine__` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_entita` int(11) NOT NULL,
  `id_gruppo` int(11) DEFAULT NULL,
  `id_account` int(11) DEFAULT NULL,
  `permesso` char(8) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_entita`,`id_gruppo`),
  KEY `id_gruppo` (`id_gruppo`),
  KEY `id_entita` (`id_entita`),
  KEY `id_account` (`id_account`),
  CONSTRAINT `__acl_pagine___ibfk_01_nofollow` FOREIGN KEY (`id_entita`) REFERENCES `pagine` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `__acl_pagine___ibfk_02_nofollow` FOREIGN KEY (`id_gruppo`) REFERENCES `gruppi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `__acl_pagine___ibfk_03_nofollow` FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | FINE FILE
