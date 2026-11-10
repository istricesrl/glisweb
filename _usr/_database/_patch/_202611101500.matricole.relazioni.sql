-- 2026-11-10 — matricole: le relazioni con attivita' e todo nella forma di progetti_matricole
--
-- Schema canonico, punto 6, riga 229, decisione di Fabio del 10/11/2026: un progetto, un'attivita' o una todo possono
-- riguardare una o piu' matricole. todo_matricole prende la forma di progetti_matricole ( ordine dopo id, note dopo le
-- chiavi, indice riordinato ), nasce la gemella attivita_matricole e ruoli_matricole prende il flag se_attivita, acceso
-- come nel 050 sui due ruoli del framework ( attrezzatura e prodotto ). attivita.id_matricola resta: e' il pezzo su cui
-- si svolge l'attivita', come attivita.id_asset accanto ad attivita_asset.
--
-- Cosa fa: crea attivita_matricole con indici e chiavi esterne; aggiunge todo_matricole.note e riordina ordine; ricrea
-- l'indice composto di todo_matricole; aggiunge ruoli_matricole.se_attivita e lo accende sulle righe 1 e 2 riconosciute
-- da id e nome. Le viste stanno nel file base.
--
-- Cosa NON fa: non tocca le chiavi esterne di todo_matricole, gia' a canone, e non sposta righe ( todo_matricole e'
-- vuota su tutti i database letti ).
--
-- IDEMPOTENTE.

-- | 202611101500

-- attivita_matricole: i pezzi con matricola che hanno un ruolo in un'attivita'
CREATE TABLE IF NOT EXISTS `attivita_matricole` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ordine` int(11) DEFAULT NULL,
  `id_attivita` bigint(20) DEFAULT NULL,
  `id_matricola` bigint(20) DEFAULT NULL,
  `id_ruolo` bigint(20) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_attivita`,`id_matricola`,`id_ruolo`),
  KEY `id_attivita` (`id_attivita`),
  KEY `id_matricola` (`id_matricola`),
  KEY `id_ruolo` (`id_ruolo`),
  KEY `ordine` (`ordine`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`ordine`,`id_attivita`,`id_matricola`,`id_ruolo`),
  CONSTRAINT `attivita_matricole_ibfk_01` FOREIGN KEY (`id_attivita`) REFERENCES `attivita` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `attivita_matricole_ibfk_02_nofollow` FOREIGN KEY (`id_matricola`) REFERENCES `matricole` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `attivita_matricole_ibfk_03_nofollow` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_matricole` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `attivita_matricole_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `attivita_matricole_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202611101501

-- todo_matricole: note dopo le chiavi, ordine dopo id, indice composto riordinato
ALTER TABLE `todo_matricole`
	ADD COLUMN IF NOT EXISTS `note` text DEFAULT NULL AFTER `id_ruolo`,
	MODIFY `ordine` int(11) DEFAULT NULL AFTER `id`,
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `indice` (`id`,`ordine`,`id_todo`,`id_matricola`,`id_ruolo`);

-- | 202611101502

-- ruoli_matricole: il flag dei ruoli proponibili in attivita_matricole
ALTER TABLE `ruoli_matricole`
	ADD COLUMN IF NOT EXISTS `se_attivita` tinyint(1) DEFAULT NULL AFTER `font_awesome`;

-- | 202611101503

-- ruoli_matricole: attrezzatura e prodotto proponibili anche nelle attivita', come nel 050
UPDATE `ruoli_matricole` SET `se_attivita` = 1
	WHERE ( ( `id` = 1 AND `nome` = 'attrezzatura' ) OR ( `id` = 2 AND `nome` = 'prodotto' ) ) AND `se_attivita` IS NULL;

-- | FINE
