--
-- 2026-11-05 — ACL delle entita' pubblicate: le tabelle __acl_<entita>__ che mancavano
--
-- Decisione di Fabio del 05/11/2026, portata da GLISWEB ( analisi in glisweb, var/20261105-prestazioni-310-pages/analisi.md
-- par. 4b ): aggiungiGruppi() ( _src/_lib/_mysql.utils.php ) e' chiamata dai _310.pages.php di notizie, annunci, risorse,
-- progetti, catalogo e prodotti senza la tabella, quindi legge il default __acl_pagine__ e la notizia 5 prende i gruppi
-- della pagina 5. Le tabelle che mancano si creano nella forma di __acl_pagine__; i chiamanti passeranno la loro.
--
-- Cosa fa: crea undici tabelle di ACL, con indici e chiavi esterne dentro la CREATE come le altre ( 300.database.md,
-- "tabelle di ACL" ): annunci, articoli, categorie_annunci, categorie_notizie, categorie_prodotti, categorie_progetti,
-- categorie_risorse, notizie, prodotti, progetti, risorse.
--
-- Cosa NON fa: non sposta le righe di __acl_pagine__ ( quelle con un id_entita di notizie o prodotti sono permessi di
-- pagine e restano li' ); non tocca le chiamate.
--
-- IDEMPOTENTE: CREATE TABLE IF NOT EXISTS.

-- | 202611051700

-- __acl_annunci__: i permessi sugli annunci per gruppo e per account
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

-- | 202611051701

-- __acl_articoli__: i permessi sugli articoli per gruppo e per account
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

-- | 202611051702

-- __acl_categorie_annunci__: i permessi sulle categorie degli annunci per gruppo e per account
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

-- | 202611051703

-- __acl_categorie_notizie__: i permessi sulle categorie delle notizie per gruppo e per account
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

-- | 202611051704

-- __acl_categorie_prodotti__: i permessi sulle categorie dei prodotti per gruppo e per account
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

-- | 202611051705

-- __acl_categorie_progetti__: i permessi sulle categorie dei progetti per gruppo e per account
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

-- | 202611051706

-- __acl_categorie_risorse__: i permessi sulle categorie delle risorse per gruppo e per account
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

-- | 202611051707

-- __acl_notizie__: i permessi sulle notizie per gruppo e per account
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

-- | 202611051708

-- __acl_prodotti__: i permessi sui prodotti per gruppo e per account
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

-- | 202611051709

-- __acl_progetti__: i permessi sui progetti per gruppo e per account
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

-- | 202611051710

-- __acl_risorse__: i permessi sulle risorse per gruppo e per account
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

-- | FINE
