--
-- ACL
-- questo file contiene le query per la creazione delle tabelle di ACL
--

-- | 040000000400

-- __acl_anagrafica__
-- tipologia: tabella gestita
-- verifica: 2021-05-28 17:39 Fabio Mosti
CREATE TABLE IF NOT EXISTS `__acl_anagrafica__` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_entita` bigint(20) NOT NULL,
  `id_gruppo` bigint(20) DEFAULT NULL,
  `id_account` bigint(20) DEFAULT NULL,
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

-- | 040000001250

-- __acl_annunci__
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: contiene i permessi sugli annunci per gruppo e per account
CREATE TABLE IF NOT EXISTS `__acl_annunci__` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_entita` bigint(20) NOT NULL,
  `id_gruppo` bigint(20) DEFAULT NULL,
  `id_account` bigint(20) DEFAULT NULL,
  `permesso` char(8) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_entita`,`id_gruppo`),
  KEY `id_gruppo` (`id_gruppo`),
  KEY `id_entita` (`id_entita`),
  KEY `id_account` (`id_account`),
  CONSTRAINT `__acl_annunci___ibfk_01_nofollow` FOREIGN KEY (`id_entita`) REFERENCES `annunci` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `__acl_annunci___ibfk_02_nofollow` FOREIGN KEY (`id_gruppo`) REFERENCES `gruppi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `__acl_annunci___ibfk_03_nofollow` FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- | 040000001300

-- __acl_articoli__
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: contiene i permessi sugli articoli per gruppo e per account
CREATE TABLE IF NOT EXISTS `__acl_articoli__` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_entita` bigint(20) NOT NULL,
  `id_gruppo` bigint(20) DEFAULT NULL,
  `id_account` bigint(20) DEFAULT NULL,
  `permesso` char(8) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_entita`,`id_gruppo`),
  KEY `id_gruppo` (`id_gruppo`),
  KEY `id_entita` (`id_entita`),
  KEY `id_account` (`id_account`),
  CONSTRAINT `__acl_articoli___ibfk_01_nofollow` FOREIGN KEY (`id_entita`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `__acl_articoli___ibfk_02_nofollow` FOREIGN KEY (`id_gruppo`) REFERENCES `gruppi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `__acl_articoli___ibfk_03_nofollow` FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- | 040000001800

-- __acl_attivita__
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: contiene i permessi sulle attivita per gruppo e per account
-- verifica: 2021-05-28 17:45 Fabio Mosti
CREATE TABLE IF NOT EXISTS `__acl_attivita__` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_entita` bigint(20) NOT NULL,
  `id_gruppo` bigint(20) DEFAULT NULL,
  `id_account` bigint(20) DEFAULT NULL,
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

-- | 040000003300

-- __acl_categorie_annunci__
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: contiene i permessi sulle categorie degli annunci per gruppo e per account
CREATE TABLE IF NOT EXISTS `__acl_categorie_annunci__` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_entita` bigint(20) NOT NULL,
  `id_gruppo` bigint(20) DEFAULT NULL,
  `id_account` bigint(20) DEFAULT NULL,
  `permesso` char(8) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_entita`,`id_gruppo`),
  KEY `id_gruppo` (`id_gruppo`),
  KEY `id_entita` (`id_entita`),
  KEY `id_account` (`id_account`),
  CONSTRAINT `__acl_categorie_annunci___ibfk_01_nofollow` FOREIGN KEY (`id_entita`) REFERENCES `categorie_annunci` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `__acl_categorie_annunci___ibfk_02_nofollow` FOREIGN KEY (`id_gruppo`) REFERENCES `gruppi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `__acl_categorie_annunci___ibfk_03_nofollow` FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- | 040000003700

-- __acl_categorie_notizie__
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: contiene i permessi sulle categorie delle notizie per gruppo e per account
CREATE TABLE IF NOT EXISTS `__acl_categorie_notizie__` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_entita` bigint(20) NOT NULL,
  `id_gruppo` bigint(20) DEFAULT NULL,
  `id_account` bigint(20) DEFAULT NULL,
  `permesso` char(8) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_entita`,`id_gruppo`),
  KEY `id_gruppo` (`id_gruppo`),
  KEY `id_entita` (`id_entita`),
  KEY `id_account` (`id_account`),
  CONSTRAINT `__acl_categorie_notizie___ibfk_01_nofollow` FOREIGN KEY (`id_entita`) REFERENCES `categorie_notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `__acl_categorie_notizie___ibfk_02_nofollow` FOREIGN KEY (`id_gruppo`) REFERENCES `gruppi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `__acl_categorie_notizie___ibfk_03_nofollow` FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- | 040000003900

-- __acl_categorie_prodotti__
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: contiene i permessi sulle categorie dei prodotti per gruppo e per account
CREATE TABLE IF NOT EXISTS `__acl_categorie_prodotti__` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_entita` bigint(20) NOT NULL,
  `id_gruppo` bigint(20) DEFAULT NULL,
  `id_account` bigint(20) DEFAULT NULL,
  `permesso` char(8) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_entita`,`id_gruppo`),
  KEY `id_gruppo` (`id_gruppo`),
  KEY `id_entita` (`id_entita`),
  KEY `id_account` (`id_account`),
  CONSTRAINT `__acl_categorie_prodotti___ibfk_01_nofollow` FOREIGN KEY (`id_entita`) REFERENCES `categorie_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `__acl_categorie_prodotti___ibfk_02_nofollow` FOREIGN KEY (`id_gruppo`) REFERENCES `gruppi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `__acl_categorie_prodotti___ibfk_03_nofollow` FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- | 040000004300

-- __acl_categorie_progetti__
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: contiene i permessi sulle categorie dei progetti per gruppo e per account
CREATE TABLE IF NOT EXISTS `__acl_categorie_progetti__` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_entita` bigint(20) NOT NULL,
  `id_gruppo` bigint(20) DEFAULT NULL,
  `id_account` bigint(20) DEFAULT NULL,
  `permesso` char(8) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_entita`,`id_gruppo`),
  KEY `id_gruppo` (`id_gruppo`),
  KEY `id_entita` (`id_entita`),
  KEY `id_account` (`id_account`),
  CONSTRAINT `__acl_categorie_progetti___ibfk_01_nofollow` FOREIGN KEY (`id_entita`) REFERENCES `categorie_progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `__acl_categorie_progetti___ibfk_02_nofollow` FOREIGN KEY (`id_gruppo`) REFERENCES `gruppi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `__acl_categorie_progetti___ibfk_03_nofollow` FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- | 040000004500

-- __acl_categorie_risorse__
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: contiene i permessi sulle categorie delle risorse per gruppo e per account
CREATE TABLE IF NOT EXISTS `__acl_categorie_risorse__` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_entita` bigint(20) NOT NULL,
  `id_gruppo` bigint(20) DEFAULT NULL,
  `id_account` bigint(20) DEFAULT NULL,
  `permesso` char(8) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_entita`,`id_gruppo`),
  KEY `id_gruppo` (`id_gruppo`),
  KEY `id_entita` (`id_entita`),
  KEY `id_account` (`id_account`),
  CONSTRAINT `__acl_categorie_risorse___ibfk_01_nofollow` FOREIGN KEY (`id_entita`) REFERENCES `categorie_risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `__acl_categorie_risorse___ibfk_02_nofollow` FOREIGN KEY (`id_gruppo`) REFERENCES `gruppi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `__acl_categorie_risorse___ibfk_03_nofollow` FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- | 040000022000

-- __acl_notizie__
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: contiene i permessi sulle notizie per gruppo e per account
CREATE TABLE IF NOT EXISTS `__acl_notizie__` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_entita` bigint(20) NOT NULL,
  `id_gruppo` bigint(20) DEFAULT NULL,
  `id_account` bigint(20) DEFAULT NULL,
  `permesso` char(8) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_entita`,`id_gruppo`),
  KEY `id_gruppo` (`id_gruppo`),
  KEY `id_entita` (`id_entita`),
  KEY `id_account` (`id_account`),
  CONSTRAINT `__acl_notizie___ibfk_01_nofollow` FOREIGN KEY (`id_entita`) REFERENCES `notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `__acl_notizie___ibfk_02_nofollow` FOREIGN KEY (`id_gruppo`) REFERENCES `gruppi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `__acl_notizie___ibfk_03_nofollow` FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- | 040000023200

-- __acl_pagine__
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: contiene i permessi sulle pagine per gruppo e per account
-- verifica: 2021-05-28 17:45 Fabio Mosti
CREATE TABLE IF NOT EXISTS `__acl_pagine__` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_entita` bigint(20) NOT NULL,
  `id_gruppo` bigint(20) DEFAULT NULL,
  `id_account` bigint(20) DEFAULT NULL,
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

-- | 040000026000

-- __acl_prodotti__
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: contiene i permessi sui prodotti per gruppo e per account
CREATE TABLE IF NOT EXISTS `__acl_prodotti__` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_entita` bigint(20) NOT NULL,
  `id_gruppo` bigint(20) DEFAULT NULL,
  `id_account` bigint(20) DEFAULT NULL,
  `permesso` char(8) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_entita`,`id_gruppo`),
  KEY `id_gruppo` (`id_gruppo`),
  KEY `id_entita` (`id_entita`),
  KEY `id_account` (`id_account`),
  CONSTRAINT `__acl_prodotti___ibfk_01_nofollow` FOREIGN KEY (`id_entita`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `__acl_prodotti___ibfk_02_nofollow` FOREIGN KEY (`id_gruppo`) REFERENCES `gruppi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `__acl_prodotti___ibfk_03_nofollow` FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- | 040000027000

-- __acl_progetti__
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: contiene i permessi sui progetti per gruppo e per account
CREATE TABLE IF NOT EXISTS `__acl_progetti__` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_entita` bigint(20) NOT NULL,
  `id_gruppo` bigint(20) DEFAULT NULL,
  `id_account` bigint(20) DEFAULT NULL,
  `permesso` char(8) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_entita`,`id_gruppo`),
  KEY `id_gruppo` (`id_gruppo`),
  KEY `id_entita` (`id_entita`),
  KEY `id_account` (`id_account`),
  CONSTRAINT `__acl_progetti___ibfk_01_nofollow` FOREIGN KEY (`id_entita`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `__acl_progetti___ibfk_02_nofollow` FOREIGN KEY (`id_gruppo`) REFERENCES `gruppi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `__acl_progetti___ibfk_03_nofollow` FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- | 040000032000

-- __acl_risorse__
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: contiene i permessi sulle risorse per gruppo e per account
CREATE TABLE IF NOT EXISTS `__acl_risorse__` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_entita` bigint(20) NOT NULL,
  `id_gruppo` bigint(20) DEFAULT NULL,
  `id_account` bigint(20) DEFAULT NULL,
  `permesso` char(8) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_entita`,`id_gruppo`),
  KEY `id_gruppo` (`id_gruppo`),
  KEY `id_entita` (`id_entita`),
  KEY `id_account` (`id_account`),
  CONSTRAINT `__acl_risorse___ibfk_01_nofollow` FOREIGN KEY (`id_entita`) REFERENCES `risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `__acl_risorse___ibfk_02_nofollow` FOREIGN KEY (`id_gruppo`) REFERENCES `gruppi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `__acl_risorse___ibfk_03_nofollow` FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- | FINE FILE
