-- 2026-11-12 — i diritti di riga stile Linux e pubblicazioni_gruppi
--
-- Schema canonico, punto 6, righe 248-250 ( sottopunto 6h ), decisioni di Fabio del 12/11/2026: ogni tabella principale
-- che e' un dato di lavoro ( 38, la lista A della scheda ) porta l'account e il gruppo proprietari della riga e tre
-- diritti, del proprietario, del gruppo e degli altri account col permesso sulla tabella, su una scala nessuno /
-- lettura / scrittura / completo; la scala e' definita nel codice ( $cf['auth']['rights'] ) e la tabella standard
-- diritti la rispecchia per nome, come gruppi con $cf['auth']['groups']. La visibilita' sul sito di una pubblicazione
-- passa a pubblicazioni_gruppi ( nessuna riga = per tutti ).
--
-- Cosa fa: crea diritti con le quattro righe e diritti_view, crea pubblicazioni_gruppi e la sua vista; sulle 38 tabelle
-- aggiunge id_account_proprietario, id_gruppo_proprietario, id_diritto_proprietario, id_diritto_gruppo e
-- id_diritto_altri con le KEY e le FK 92-96; aggiunge le stesse colonne, allo stesso posto della vista, alle statiche di
-- anagrafica, articoli, attivita, documenti e todo; ricrea le 38 viste.
--
-- Cosa NON fa: il riordino delle colonne sulle tabelle ( le nuove finiscono in coda, punto 12 ); il DROP delle tabelle
-- __acl_<entita>__ ( restano per i moduli legacy di glisweb ); il codice che legge e scrive i diritti ( TODO.md ).
--
-- IDEMPOTENTE.

-- | 202611121200

-- diritti: la scala dei diritti di riga
CREATE TABLE IF NOT EXISTS `diritti` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`nome` char(255) DEFAULT NULL,
	PRIMARY KEY (`id`),
	UNIQUE KEY `unica` (`nome`),
	KEY `indice` (`id`,`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202611121201

-- diritti: i quattro livelli, coi nomi di $cf['auth']['rights']
INSERT IGNORE INTO `diritti` (`id`, `nome`) VALUES
(1,		'nessuno'),
(2,		'lettura'),
(3,		'scrittura'),
(4,		'completo');

-- | 202611121202

-- diritti_view
CREATE OR REPLACE VIEW `diritti_view` AS
	SELECT
		diritti.id,
		diritti.nome,
		diritti.nome AS __label__
	FROM diritti
;

-- | 202611121203

-- pubblicazioni_gruppi: i gruppi a cui e' riservata una pubblicazione
CREATE TABLE IF NOT EXISTS `pubblicazioni_gruppi` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`ordine` int(11) DEFAULT NULL,
	`id_pubblicazione` bigint(20) DEFAULT NULL,
	`id_gruppo` bigint(20) DEFAULT NULL,
	`id_account_inserimento` bigint(20) DEFAULT NULL,
	`timestamp_inserimento` int(11) DEFAULT NULL,
	`id_account_aggiornamento` bigint(20) DEFAULT NULL,
	`timestamp_aggiornamento` int(11) DEFAULT NULL,
	PRIMARY KEY (`id`),
	UNIQUE KEY `unica` (`id_pubblicazione`,`id_gruppo`),
	KEY `id_pubblicazione` (`id_pubblicazione`),
	KEY `id_gruppo` (`id_gruppo`),
	KEY `ordine` (`ordine`),
	KEY `id_account_inserimento` (`id_account_inserimento`),
	KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	KEY `indice` (`id`,`ordine`,`id_pubblicazione`,`id_gruppo`),
	CONSTRAINT `pubblicazioni_gruppi_ibfk_01` FOREIGN KEY (`id_pubblicazione`) REFERENCES `pubblicazioni` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT `pubblicazioni_gruppi_ibfk_02_nofollow` FOREIGN KEY (`id_gruppo`) REFERENCES `gruppi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT `pubblicazioni_gruppi_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	CONSTRAINT `pubblicazioni_gruppi_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202611121204

-- pubblicazioni_gruppi_view
CREATE OR REPLACE VIEW `pubblicazioni_gruppi_view` AS
	SELECT
		pubblicazioni_gruppi.id,
		pubblicazioni_gruppi.ordine,
		pubblicazioni_gruppi.id_pubblicazione,
		pubblicazioni_gruppi.id_gruppo,
		gruppi_path( pubblicazioni_gruppi.id_gruppo ) AS gruppo,
		pubblicazioni_gruppi.id_account_inserimento,
		pubblicazioni_gruppi.id_account_aggiornamento,
		concat_ws(
			' / ',
			pubblicazioni_gruppi.id_pubblicazione,
			gruppi_path( pubblicazioni_gruppi.id_gruppo )
		) AS __label__
	FROM pubblicazioni_gruppi
;

-- | 202611121205

-- anagrafica: proprietario, gruppo e diritti di riga
ALTER TABLE `anagrafica`
	ADD COLUMN IF NOT EXISTS `id_account_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_gruppo_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_gruppo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_altri` bigint(20) DEFAULT NULL,
	ADD INDEX IF NOT EXISTS `id_account_proprietario` (`id_account_proprietario`),
	ADD INDEX IF NOT EXISTS `id_gruppo_proprietario` (`id_gruppo_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_proprietario` (`id_diritto_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_gruppo` (`id_diritto_gruppo`),
	ADD INDEX IF NOT EXISTS `id_diritto_altri` (`id_diritto_altri`),
	ADD CONSTRAINT `anagrafica_ibfk_92_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_proprietario`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `anagrafica_ibfk_93_nofollow` FOREIGN KEY IF NOT EXISTS (`id_gruppo_proprietario`) REFERENCES `gruppi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `anagrafica_ibfk_94_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_proprietario`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `anagrafica_ibfk_95_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_gruppo`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `anagrafica_ibfk_96_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_altri`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611121206

-- attivita: proprietario, gruppo e diritti di riga
ALTER TABLE `attivita`
	ADD COLUMN IF NOT EXISTS `id_account_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_gruppo_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_gruppo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_altri` bigint(20) DEFAULT NULL,
	ADD INDEX IF NOT EXISTS `id_account_proprietario` (`id_account_proprietario`),
	ADD INDEX IF NOT EXISTS `id_gruppo_proprietario` (`id_gruppo_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_proprietario` (`id_diritto_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_gruppo` (`id_diritto_gruppo`),
	ADD INDEX IF NOT EXISTS `id_diritto_altri` (`id_diritto_altri`),
	ADD CONSTRAINT `attivita_ibfk_92_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_proprietario`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `attivita_ibfk_93_nofollow` FOREIGN KEY IF NOT EXISTS (`id_gruppo_proprietario`) REFERENCES `gruppi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `attivita_ibfk_94_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_proprietario`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `attivita_ibfk_95_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_gruppo`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `attivita_ibfk_96_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_altri`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611121207

-- todo: proprietario, gruppo e diritti di riga
ALTER TABLE `todo`
	ADD COLUMN IF NOT EXISTS `id_account_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_gruppo_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_gruppo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_altri` bigint(20) DEFAULT NULL,
	ADD INDEX IF NOT EXISTS `id_account_proprietario` (`id_account_proprietario`),
	ADD INDEX IF NOT EXISTS `id_gruppo_proprietario` (`id_gruppo_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_proprietario` (`id_diritto_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_gruppo` (`id_diritto_gruppo`),
	ADD INDEX IF NOT EXISTS `id_diritto_altri` (`id_diritto_altri`),
	ADD CONSTRAINT `todo_ibfk_92_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_proprietario`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `todo_ibfk_93_nofollow` FOREIGN KEY IF NOT EXISTS (`id_gruppo_proprietario`) REFERENCES `gruppi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `todo_ibfk_94_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_proprietario`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `todo_ibfk_95_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_gruppo`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `todo_ibfk_96_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_altri`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611121208

-- progetti: proprietario, gruppo e diritti di riga
ALTER TABLE `progetti`
	ADD COLUMN IF NOT EXISTS `id_account_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_gruppo_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_gruppo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_altri` bigint(20) DEFAULT NULL,
	ADD INDEX IF NOT EXISTS `id_account_proprietario` (`id_account_proprietario`),
	ADD INDEX IF NOT EXISTS `id_gruppo_proprietario` (`id_gruppo_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_proprietario` (`id_diritto_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_gruppo` (`id_diritto_gruppo`),
	ADD INDEX IF NOT EXISTS `id_diritto_altri` (`id_diritto_altri`),
	ADD CONSTRAINT `progetti_ibfk_92_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_proprietario`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `progetti_ibfk_93_nofollow` FOREIGN KEY IF NOT EXISTS (`id_gruppo_proprietario`) REFERENCES `gruppi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `progetti_ibfk_94_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_proprietario`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `progetti_ibfk_95_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_gruppo`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `progetti_ibfk_96_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_altri`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611121209

-- contratti: proprietario, gruppo e diritti di riga
ALTER TABLE `contratti`
	ADD COLUMN IF NOT EXISTS `id_account_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_gruppo_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_gruppo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_altri` bigint(20) DEFAULT NULL,
	ADD INDEX IF NOT EXISTS `id_account_proprietario` (`id_account_proprietario`),
	ADD INDEX IF NOT EXISTS `id_gruppo_proprietario` (`id_gruppo_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_proprietario` (`id_diritto_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_gruppo` (`id_diritto_gruppo`),
	ADD INDEX IF NOT EXISTS `id_diritto_altri` (`id_diritto_altri`),
	ADD CONSTRAINT `contratti_ibfk_92_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_proprietario`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `contratti_ibfk_93_nofollow` FOREIGN KEY IF NOT EXISTS (`id_gruppo_proprietario`) REFERENCES `gruppi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `contratti_ibfk_94_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_proprietario`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `contratti_ibfk_95_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_gruppo`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `contratti_ibfk_96_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_altri`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611121210

-- documenti: proprietario, gruppo e diritti di riga
ALTER TABLE `documenti`
	ADD COLUMN IF NOT EXISTS `id_account_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_gruppo_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_gruppo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_altri` bigint(20) DEFAULT NULL,
	ADD INDEX IF NOT EXISTS `id_account_proprietario` (`id_account_proprietario`),
	ADD INDEX IF NOT EXISTS `id_gruppo_proprietario` (`id_gruppo_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_proprietario` (`id_diritto_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_gruppo` (`id_diritto_gruppo`),
	ADD INDEX IF NOT EXISTS `id_diritto_altri` (`id_diritto_altri`),
	ADD CONSTRAINT `documenti_ibfk_92_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_proprietario`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `documenti_ibfk_93_nofollow` FOREIGN KEY IF NOT EXISTS (`id_gruppo_proprietario`) REFERENCES `gruppi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `documenti_ibfk_94_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_proprietario`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `documenti_ibfk_95_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_gruppo`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `documenti_ibfk_96_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_altri`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611121211

-- pagamenti: proprietario, gruppo e diritti di riga
ALTER TABLE `pagamenti`
	ADD COLUMN IF NOT EXISTS `id_account_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_gruppo_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_gruppo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_altri` bigint(20) DEFAULT NULL,
	ADD INDEX IF NOT EXISTS `id_account_proprietario` (`id_account_proprietario`),
	ADD INDEX IF NOT EXISTS `id_gruppo_proprietario` (`id_gruppo_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_proprietario` (`id_diritto_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_gruppo` (`id_diritto_gruppo`),
	ADD INDEX IF NOT EXISTS `id_diritto_altri` (`id_diritto_altri`),
	ADD CONSTRAINT `pagamenti_ibfk_92_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_proprietario`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `pagamenti_ibfk_93_nofollow` FOREIGN KEY IF NOT EXISTS (`id_gruppo_proprietario`) REFERENCES `gruppi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `pagamenti_ibfk_94_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_proprietario`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `pagamenti_ibfk_95_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_gruppo`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `pagamenti_ibfk_96_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_altri`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611121212

-- crediti: proprietario, gruppo e diritti di riga
ALTER TABLE `crediti`
	ADD COLUMN IF NOT EXISTS `id_account_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_gruppo_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_gruppo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_altri` bigint(20) DEFAULT NULL,
	ADD INDEX IF NOT EXISTS `id_account_proprietario` (`id_account_proprietario`),
	ADD INDEX IF NOT EXISTS `id_gruppo_proprietario` (`id_gruppo_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_proprietario` (`id_diritto_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_gruppo` (`id_diritto_gruppo`),
	ADD INDEX IF NOT EXISTS `id_diritto_altri` (`id_diritto_altri`),
	ADD CONSTRAINT `crediti_ibfk_92_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_proprietario`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `crediti_ibfk_93_nofollow` FOREIGN KEY IF NOT EXISTS (`id_gruppo_proprietario`) REFERENCES `gruppi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `crediti_ibfk_94_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_proprietario`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `crediti_ibfk_95_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_gruppo`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `crediti_ibfk_96_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_altri`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611121213

-- conversazioni: proprietario, gruppo e diritti di riga
ALTER TABLE `conversazioni`
	ADD COLUMN IF NOT EXISTS `id_account_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_gruppo_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_gruppo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_altri` bigint(20) DEFAULT NULL,
	ADD INDEX IF NOT EXISTS `id_account_proprietario` (`id_account_proprietario`),
	ADD INDEX IF NOT EXISTS `id_gruppo_proprietario` (`id_gruppo_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_proprietario` (`id_diritto_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_gruppo` (`id_diritto_gruppo`),
	ADD INDEX IF NOT EXISTS `id_diritto_altri` (`id_diritto_altri`),
	ADD CONSTRAINT `conversazioni_ibfk_92_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_proprietario`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `conversazioni_ibfk_93_nofollow` FOREIGN KEY IF NOT EXISTS (`id_gruppo_proprietario`) REFERENCES `gruppi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `conversazioni_ibfk_94_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_proprietario`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `conversazioni_ibfk_95_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_gruppo`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `conversazioni_ibfk_96_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_altri`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611121214

-- contatti: proprietario, gruppo e diritti di riga
ALTER TABLE `contatti`
	ADD COLUMN IF NOT EXISTS `id_account_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_gruppo_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_gruppo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_altri` bigint(20) DEFAULT NULL,
	ADD INDEX IF NOT EXISTS `id_account_proprietario` (`id_account_proprietario`),
	ADD INDEX IF NOT EXISTS `id_gruppo_proprietario` (`id_gruppo_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_proprietario` (`id_diritto_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_gruppo` (`id_diritto_gruppo`),
	ADD INDEX IF NOT EXISTS `id_diritto_altri` (`id_diritto_altri`),
	ADD CONSTRAINT `contatti_ibfk_92_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_proprietario`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `contatti_ibfk_93_nofollow` FOREIGN KEY IF NOT EXISTS (`id_gruppo_proprietario`) REFERENCES `gruppi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `contatti_ibfk_94_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_proprietario`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `contatti_ibfk_95_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_gruppo`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `contatti_ibfk_96_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_altri`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611121215

-- corrispondenza: proprietario, gruppo e diritti di riga
ALTER TABLE `corrispondenza`
	ADD COLUMN IF NOT EXISTS `id_account_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_gruppo_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_gruppo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_altri` bigint(20) DEFAULT NULL,
	ADD INDEX IF NOT EXISTS `id_account_proprietario` (`id_account_proprietario`),
	ADD INDEX IF NOT EXISTS `id_gruppo_proprietario` (`id_gruppo_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_proprietario` (`id_diritto_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_gruppo` (`id_diritto_gruppo`),
	ADD INDEX IF NOT EXISTS `id_diritto_altri` (`id_diritto_altri`),
	ADD CONSTRAINT `corrispondenza_ibfk_92_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_proprietario`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `corrispondenza_ibfk_93_nofollow` FOREIGN KEY IF NOT EXISTS (`id_gruppo_proprietario`) REFERENCES `gruppi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `corrispondenza_ibfk_94_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_proprietario`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `corrispondenza_ibfk_95_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_gruppo`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `corrispondenza_ibfk_96_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_altri`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611121216

-- campagne: proprietario, gruppo e diritti di riga
ALTER TABLE `campagne`
	ADD COLUMN IF NOT EXISTS `id_account_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_gruppo_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_gruppo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_altri` bigint(20) DEFAULT NULL,
	ADD INDEX IF NOT EXISTS `id_account_proprietario` (`id_account_proprietario`),
	ADD INDEX IF NOT EXISTS `id_gruppo_proprietario` (`id_gruppo_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_proprietario` (`id_diritto_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_gruppo` (`id_diritto_gruppo`),
	ADD INDEX IF NOT EXISTS `id_diritto_altri` (`id_diritto_altri`),
	ADD CONSTRAINT `campagne_ibfk_92_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_proprietario`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `campagne_ibfk_93_nofollow` FOREIGN KEY IF NOT EXISTS (`id_gruppo_proprietario`) REFERENCES `gruppi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `campagne_ibfk_94_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_proprietario`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `campagne_ibfk_95_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_gruppo`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `campagne_ibfk_96_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_altri`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611121217

-- funnel: proprietario, gruppo e diritti di riga
ALTER TABLE `funnel`
	ADD COLUMN IF NOT EXISTS `id_account_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_gruppo_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_gruppo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_altri` bigint(20) DEFAULT NULL,
	ADD INDEX IF NOT EXISTS `id_account_proprietario` (`id_account_proprietario`),
	ADD INDEX IF NOT EXISTS `id_gruppo_proprietario` (`id_gruppo_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_proprietario` (`id_diritto_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_gruppo` (`id_diritto_gruppo`),
	ADD INDEX IF NOT EXISTS `id_diritto_altri` (`id_diritto_altri`),
	ADD CONSTRAINT `funnel_ibfk_92_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_proprietario`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `funnel_ibfk_93_nofollow` FOREIGN KEY IF NOT EXISTS (`id_gruppo_proprietario`) REFERENCES `gruppi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `funnel_ibfk_94_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_proprietario`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `funnel_ibfk_95_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_gruppo`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `funnel_ibfk_96_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_altri`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611121218

-- mailing: proprietario, gruppo e diritti di riga
ALTER TABLE `mailing`
	ADD COLUMN IF NOT EXISTS `id_account_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_gruppo_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_gruppo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_altri` bigint(20) DEFAULT NULL,
	ADD INDEX IF NOT EXISTS `id_account_proprietario` (`id_account_proprietario`),
	ADD INDEX IF NOT EXISTS `id_gruppo_proprietario` (`id_gruppo_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_proprietario` (`id_diritto_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_gruppo` (`id_diritto_gruppo`),
	ADD INDEX IF NOT EXISTS `id_diritto_altri` (`id_diritto_altri`),
	ADD CONSTRAINT `mailing_ibfk_92_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_proprietario`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `mailing_ibfk_93_nofollow` FOREIGN KEY IF NOT EXISTS (`id_gruppo_proprietario`) REFERENCES `gruppi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `mailing_ibfk_94_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_proprietario`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `mailing_ibfk_95_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_gruppo`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `mailing_ibfk_96_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_altri`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611121219

-- liste: proprietario, gruppo e diritti di riga
ALTER TABLE `liste`
	ADD COLUMN IF NOT EXISTS `id_account_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_gruppo_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_gruppo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_altri` bigint(20) DEFAULT NULL,
	ADD INDEX IF NOT EXISTS `id_account_proprietario` (`id_account_proprietario`),
	ADD INDEX IF NOT EXISTS `id_gruppo_proprietario` (`id_gruppo_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_proprietario` (`id_diritto_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_gruppo` (`id_diritto_gruppo`),
	ADD INDEX IF NOT EXISTS `id_diritto_altri` (`id_diritto_altri`),
	ADD CONSTRAINT `liste_ibfk_92_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_proprietario`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `liste_ibfk_93_nofollow` FOREIGN KEY IF NOT EXISTS (`id_gruppo_proprietario`) REFERENCES `gruppi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `liste_ibfk_94_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_proprietario`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `liste_ibfk_95_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_gruppo`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `liste_ibfk_96_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_altri`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611121220

-- valutazioni: proprietario, gruppo e diritti di riga
ALTER TABLE `valutazioni`
	ADD COLUMN IF NOT EXISTS `id_account_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_gruppo_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_gruppo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_altri` bigint(20) DEFAULT NULL,
	ADD INDEX IF NOT EXISTS `id_account_proprietario` (`id_account_proprietario`),
	ADD INDEX IF NOT EXISTS `id_gruppo_proprietario` (`id_gruppo_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_proprietario` (`id_diritto_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_gruppo` (`id_diritto_gruppo`),
	ADD INDEX IF NOT EXISTS `id_diritto_altri` (`id_diritto_altri`),
	ADD CONSTRAINT `valutazioni_ibfk_92_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_proprietario`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `valutazioni_ibfk_93_nofollow` FOREIGN KEY IF NOT EXISTS (`id_gruppo_proprietario`) REFERENCES `gruppi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `valutazioni_ibfk_94_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_proprietario`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `valutazioni_ibfk_95_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_gruppo`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `valutazioni_ibfk_96_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_altri`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611121221

-- pianificazioni: proprietario, gruppo e diritti di riga
ALTER TABLE `pianificazioni`
	ADD COLUMN IF NOT EXISTS `id_account_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_gruppo_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_gruppo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_altri` bigint(20) DEFAULT NULL,
	ADD INDEX IF NOT EXISTS `id_account_proprietario` (`id_account_proprietario`),
	ADD INDEX IF NOT EXISTS `id_gruppo_proprietario` (`id_gruppo_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_proprietario` (`id_diritto_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_gruppo` (`id_diritto_gruppo`),
	ADD INDEX IF NOT EXISTS `id_diritto_altri` (`id_diritto_altri`),
	ADD CONSTRAINT `pianificazioni_ibfk_92_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_proprietario`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `pianificazioni_ibfk_93_nofollow` FOREIGN KEY IF NOT EXISTS (`id_gruppo_proprietario`) REFERENCES `gruppi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `pianificazioni_ibfk_94_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_proprietario`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `pianificazioni_ibfk_95_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_gruppo`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `pianificazioni_ibfk_96_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_altri`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611121222

-- mastri: proprietario, gruppo e diritti di riga
ALTER TABLE `mastri`
	ADD COLUMN IF NOT EXISTS `id_account_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_gruppo_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_gruppo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_altri` bigint(20) DEFAULT NULL,
	ADD INDEX IF NOT EXISTS `id_account_proprietario` (`id_account_proprietario`),
	ADD INDEX IF NOT EXISTS `id_gruppo_proprietario` (`id_gruppo_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_proprietario` (`id_diritto_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_gruppo` (`id_diritto_gruppo`),
	ADD INDEX IF NOT EXISTS `id_diritto_altri` (`id_diritto_altri`),
	ADD CONSTRAINT `mastri_ibfk_92_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_proprietario`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `mastri_ibfk_93_nofollow` FOREIGN KEY IF NOT EXISTS (`id_gruppo_proprietario`) REFERENCES `gruppi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `mastri_ibfk_94_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_proprietario`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `mastri_ibfk_95_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_gruppo`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `mastri_ibfk_96_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_altri`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611121223

-- asset: proprietario, gruppo e diritti di riga
ALTER TABLE `asset`
	ADD COLUMN IF NOT EXISTS `id_account_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_gruppo_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_gruppo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_altri` bigint(20) DEFAULT NULL,
	ADD INDEX IF NOT EXISTS `id_account_proprietario` (`id_account_proprietario`),
	ADD INDEX IF NOT EXISTS `id_gruppo_proprietario` (`id_gruppo_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_proprietario` (`id_diritto_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_gruppo` (`id_diritto_gruppo`),
	ADD INDEX IF NOT EXISTS `id_diritto_altri` (`id_diritto_altri`),
	ADD CONSTRAINT `asset_ibfk_92_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_proprietario`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `asset_ibfk_93_nofollow` FOREIGN KEY IF NOT EXISTS (`id_gruppo_proprietario`) REFERENCES `gruppi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `asset_ibfk_94_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_proprietario`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `asset_ibfk_95_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_gruppo`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `asset_ibfk_96_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_altri`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611121224

-- matricole: proprietario, gruppo e diritti di riga
ALTER TABLE `matricole`
	ADD COLUMN IF NOT EXISTS `id_account_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_gruppo_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_gruppo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_altri` bigint(20) DEFAULT NULL,
	ADD INDEX IF NOT EXISTS `id_account_proprietario` (`id_account_proprietario`),
	ADD INDEX IF NOT EXISTS `id_gruppo_proprietario` (`id_gruppo_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_proprietario` (`id_diritto_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_gruppo` (`id_diritto_gruppo`),
	ADD INDEX IF NOT EXISTS `id_diritto_altri` (`id_diritto_altri`),
	ADD CONSTRAINT `matricole_ibfk_92_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_proprietario`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `matricole_ibfk_93_nofollow` FOREIGN KEY IF NOT EXISTS (`id_gruppo_proprietario`) REFERENCES `gruppi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `matricole_ibfk_94_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_proprietario`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `matricole_ibfk_95_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_gruppo`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `matricole_ibfk_96_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_altri`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611121225

-- lotti: proprietario, gruppo e diritti di riga
ALTER TABLE `lotti`
	ADD COLUMN IF NOT EXISTS `id_account_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_gruppo_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_gruppo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_altri` bigint(20) DEFAULT NULL,
	ADD INDEX IF NOT EXISTS `id_account_proprietario` (`id_account_proprietario`),
	ADD INDEX IF NOT EXISTS `id_gruppo_proprietario` (`id_gruppo_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_proprietario` (`id_diritto_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_gruppo` (`id_diritto_gruppo`),
	ADD INDEX IF NOT EXISTS `id_diritto_altri` (`id_diritto_altri`),
	ADD CONSTRAINT `lotti_ibfk_92_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_proprietario`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `lotti_ibfk_93_nofollow` FOREIGN KEY IF NOT EXISTS (`id_gruppo_proprietario`) REFERENCES `gruppi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `lotti_ibfk_94_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_proprietario`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `lotti_ibfk_95_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_gruppo`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `lotti_ibfk_96_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_altri`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611121226

-- licenze: proprietario, gruppo e diritti di riga
ALTER TABLE `licenze`
	ADD COLUMN IF NOT EXISTS `id_account_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_gruppo_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_gruppo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_altri` bigint(20) DEFAULT NULL,
	ADD INDEX IF NOT EXISTS `id_account_proprietario` (`id_account_proprietario`),
	ADD INDEX IF NOT EXISTS `id_gruppo_proprietario` (`id_gruppo_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_proprietario` (`id_diritto_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_gruppo` (`id_diritto_gruppo`),
	ADD INDEX IF NOT EXISTS `id_diritto_altri` (`id_diritto_altri`),
	ADD CONSTRAINT `licenze_ibfk_92_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_proprietario`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `licenze_ibfk_93_nofollow` FOREIGN KEY IF NOT EXISTS (`id_gruppo_proprietario`) REFERENCES `gruppi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `licenze_ibfk_94_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_proprietario`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `licenze_ibfk_95_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_gruppo`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `licenze_ibfk_96_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_altri`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611121227

-- software: proprietario, gruppo e diritti di riga
ALTER TABLE `software`
	ADD COLUMN IF NOT EXISTS `id_account_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_gruppo_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_gruppo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_altri` bigint(20) DEFAULT NULL,
	ADD INDEX IF NOT EXISTS `id_account_proprietario` (`id_account_proprietario`),
	ADD INDEX IF NOT EXISTS `id_gruppo_proprietario` (`id_gruppo_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_proprietario` (`id_diritto_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_gruppo` (`id_diritto_gruppo`),
	ADD INDEX IF NOT EXISTS `id_diritto_altri` (`id_diritto_altri`),
	ADD CONSTRAINT `software_ibfk_92_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_proprietario`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `software_ibfk_93_nofollow` FOREIGN KEY IF NOT EXISTS (`id_gruppo_proprietario`) REFERENCES `gruppi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `software_ibfk_94_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_proprietario`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `software_ibfk_95_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_gruppo`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `software_ibfk_96_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_altri`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611121228

-- chiavi: proprietario, gruppo e diritti di riga
ALTER TABLE `chiavi`
	ADD COLUMN IF NOT EXISTS `id_account_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_gruppo_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_gruppo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_altri` bigint(20) DEFAULT NULL,
	ADD INDEX IF NOT EXISTS `id_account_proprietario` (`id_account_proprietario`),
	ADD INDEX IF NOT EXISTS `id_gruppo_proprietario` (`id_gruppo_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_proprietario` (`id_diritto_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_gruppo` (`id_diritto_gruppo`),
	ADD INDEX IF NOT EXISTS `id_diritto_altri` (`id_diritto_altri`),
	ADD CONSTRAINT `chiavi_ibfk_92_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_proprietario`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `chiavi_ibfk_93_nofollow` FOREIGN KEY IF NOT EXISTS (`id_gruppo_proprietario`) REFERENCES `gruppi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `chiavi_ibfk_94_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_proprietario`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `chiavi_ibfk_95_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_gruppo`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `chiavi_ibfk_96_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_altri`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611121229

-- badge: proprietario, gruppo e diritti di riga
ALTER TABLE `badge`
	ADD COLUMN IF NOT EXISTS `id_account_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_gruppo_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_gruppo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_altri` bigint(20) DEFAULT NULL,
	ADD INDEX IF NOT EXISTS `id_account_proprietario` (`id_account_proprietario`),
	ADD INDEX IF NOT EXISTS `id_gruppo_proprietario` (`id_gruppo_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_proprietario` (`id_diritto_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_gruppo` (`id_diritto_gruppo`),
	ADD INDEX IF NOT EXISTS `id_diritto_altri` (`id_diritto_altri`),
	ADD CONSTRAINT `badge_ibfk_92_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_proprietario`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `badge_ibfk_93_nofollow` FOREIGN KEY IF NOT EXISTS (`id_gruppo_proprietario`) REFERENCES `gruppi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `badge_ibfk_94_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_proprietario`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `badge_ibfk_95_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_gruppo`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `badge_ibfk_96_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_altri`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611121230

-- organizzazioni: proprietario, gruppo e diritti di riga
ALTER TABLE `organizzazioni`
	ADD COLUMN IF NOT EXISTS `id_account_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_gruppo_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_gruppo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_altri` bigint(20) DEFAULT NULL,
	ADD INDEX IF NOT EXISTS `id_account_proprietario` (`id_account_proprietario`),
	ADD INDEX IF NOT EXISTS `id_gruppo_proprietario` (`id_gruppo_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_proprietario` (`id_diritto_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_gruppo` (`id_diritto_gruppo`),
	ADD INDEX IF NOT EXISTS `id_diritto_altri` (`id_diritto_altri`),
	ADD CONSTRAINT `organizzazioni_ibfk_92_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_proprietario`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `organizzazioni_ibfk_93_nofollow` FOREIGN KEY IF NOT EXISTS (`id_gruppo_proprietario`) REFERENCES `gruppi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `organizzazioni_ibfk_94_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_proprietario`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `organizzazioni_ibfk_95_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_gruppo`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `organizzazioni_ibfk_96_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_altri`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611121231

-- immobili: proprietario, gruppo e diritti di riga
ALTER TABLE `immobili`
	ADD COLUMN IF NOT EXISTS `id_account_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_gruppo_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_gruppo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_altri` bigint(20) DEFAULT NULL,
	ADD INDEX IF NOT EXISTS `id_account_proprietario` (`id_account_proprietario`),
	ADD INDEX IF NOT EXISTS `id_gruppo_proprietario` (`id_gruppo_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_proprietario` (`id_diritto_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_gruppo` (`id_diritto_gruppo`),
	ADD INDEX IF NOT EXISTS `id_diritto_altri` (`id_diritto_altri`),
	ADD CONSTRAINT `immobili_ibfk_92_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_proprietario`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `immobili_ibfk_93_nofollow` FOREIGN KEY IF NOT EXISTS (`id_gruppo_proprietario`) REFERENCES `gruppi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `immobili_ibfk_94_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_proprietario`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `immobili_ibfk_95_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_gruppo`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `immobili_ibfk_96_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_altri`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611121232

-- edifici: proprietario, gruppo e diritti di riga
ALTER TABLE `edifici`
	ADD COLUMN IF NOT EXISTS `id_account_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_gruppo_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_gruppo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_altri` bigint(20) DEFAULT NULL,
	ADD INDEX IF NOT EXISTS `id_account_proprietario` (`id_account_proprietario`),
	ADD INDEX IF NOT EXISTS `id_gruppo_proprietario` (`id_gruppo_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_proprietario` (`id_diritto_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_gruppo` (`id_diritto_gruppo`),
	ADD INDEX IF NOT EXISTS `id_diritto_altri` (`id_diritto_altri`),
	ADD CONSTRAINT `edifici_ibfk_92_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_proprietario`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `edifici_ibfk_93_nofollow` FOREIGN KEY IF NOT EXISTS (`id_gruppo_proprietario`) REFERENCES `gruppi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `edifici_ibfk_94_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_proprietario`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `edifici_ibfk_95_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_gruppo`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `edifici_ibfk_96_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_altri`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611121233

-- vani: proprietario, gruppo e diritti di riga
ALTER TABLE `vani`
	ADD COLUMN IF NOT EXISTS `id_account_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_gruppo_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_gruppo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_altri` bigint(20) DEFAULT NULL,
	ADD INDEX IF NOT EXISTS `id_account_proprietario` (`id_account_proprietario`),
	ADD INDEX IF NOT EXISTS `id_gruppo_proprietario` (`id_gruppo_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_proprietario` (`id_diritto_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_gruppo` (`id_diritto_gruppo`),
	ADD INDEX IF NOT EXISTS `id_diritto_altri` (`id_diritto_altri`),
	ADD CONSTRAINT `vani_ibfk_92_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_proprietario`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `vani_ibfk_93_nofollow` FOREIGN KEY IF NOT EXISTS (`id_gruppo_proprietario`) REFERENCES `gruppi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `vani_ibfk_94_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_proprietario`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `vani_ibfk_95_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_gruppo`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `vani_ibfk_96_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_altri`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611121234

-- indirizzi: proprietario, gruppo e diritti di riga
ALTER TABLE `indirizzi`
	ADD COLUMN IF NOT EXISTS `id_account_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_gruppo_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_gruppo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_altri` bigint(20) DEFAULT NULL,
	ADD INDEX IF NOT EXISTS `id_account_proprietario` (`id_account_proprietario`),
	ADD INDEX IF NOT EXISTS `id_gruppo_proprietario` (`id_gruppo_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_proprietario` (`id_diritto_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_gruppo` (`id_diritto_gruppo`),
	ADD INDEX IF NOT EXISTS `id_diritto_altri` (`id_diritto_altri`),
	ADD CONSTRAINT `indirizzi_ibfk_92_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_proprietario`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `indirizzi_ibfk_93_nofollow` FOREIGN KEY IF NOT EXISTS (`id_gruppo_proprietario`) REFERENCES `gruppi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `indirizzi_ibfk_94_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_proprietario`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `indirizzi_ibfk_95_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_gruppo`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `indirizzi_ibfk_96_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_altri`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611121235

-- luoghi: proprietario, gruppo e diritti di riga
ALTER TABLE `luoghi`
	ADD COLUMN IF NOT EXISTS `id_account_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_gruppo_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_gruppo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_altri` bigint(20) DEFAULT NULL,
	ADD INDEX IF NOT EXISTS `id_account_proprietario` (`id_account_proprietario`),
	ADD INDEX IF NOT EXISTS `id_gruppo_proprietario` (`id_gruppo_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_proprietario` (`id_diritto_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_gruppo` (`id_diritto_gruppo`),
	ADD INDEX IF NOT EXISTS `id_diritto_altri` (`id_diritto_altri`),
	ADD CONSTRAINT `luoghi_ibfk_92_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_proprietario`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `luoghi_ibfk_93_nofollow` FOREIGN KEY IF NOT EXISTS (`id_gruppo_proprietario`) REFERENCES `gruppi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `luoghi_ibfk_94_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_proprietario`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `luoghi_ibfk_95_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_gruppo`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `luoghi_ibfk_96_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_altri`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611121236

-- pagine: proprietario, gruppo e diritti di riga
ALTER TABLE `pagine`
	ADD COLUMN IF NOT EXISTS `id_account_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_gruppo_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_gruppo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_altri` bigint(20) DEFAULT NULL,
	ADD INDEX IF NOT EXISTS `id_account_proprietario` (`id_account_proprietario`),
	ADD INDEX IF NOT EXISTS `id_gruppo_proprietario` (`id_gruppo_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_proprietario` (`id_diritto_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_gruppo` (`id_diritto_gruppo`),
	ADD INDEX IF NOT EXISTS `id_diritto_altri` (`id_diritto_altri`),
	ADD CONSTRAINT `pagine_ibfk_92_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_proprietario`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `pagine_ibfk_93_nofollow` FOREIGN KEY IF NOT EXISTS (`id_gruppo_proprietario`) REFERENCES `gruppi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `pagine_ibfk_94_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_proprietario`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `pagine_ibfk_95_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_gruppo`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `pagine_ibfk_96_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_altri`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611121237

-- prodotti: proprietario, gruppo e diritti di riga
ALTER TABLE `prodotti`
	ADD COLUMN IF NOT EXISTS `id_account_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_gruppo_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_gruppo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_altri` bigint(20) DEFAULT NULL,
	ADD INDEX IF NOT EXISTS `id_account_proprietario` (`id_account_proprietario`),
	ADD INDEX IF NOT EXISTS `id_gruppo_proprietario` (`id_gruppo_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_proprietario` (`id_diritto_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_gruppo` (`id_diritto_gruppo`),
	ADD INDEX IF NOT EXISTS `id_diritto_altri` (`id_diritto_altri`),
	ADD CONSTRAINT `prodotti_ibfk_92_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_proprietario`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `prodotti_ibfk_93_nofollow` FOREIGN KEY IF NOT EXISTS (`id_gruppo_proprietario`) REFERENCES `gruppi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `prodotti_ibfk_94_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_proprietario`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `prodotti_ibfk_95_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_gruppo`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `prodotti_ibfk_96_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_altri`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611121238

-- articoli: proprietario, gruppo e diritti di riga
ALTER TABLE `articoli`
	ADD COLUMN IF NOT EXISTS `id_account_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_gruppo_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_gruppo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_altri` bigint(20) DEFAULT NULL,
	ADD INDEX IF NOT EXISTS `id_account_proprietario` (`id_account_proprietario`),
	ADD INDEX IF NOT EXISTS `id_gruppo_proprietario` (`id_gruppo_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_proprietario` (`id_diritto_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_gruppo` (`id_diritto_gruppo`),
	ADD INDEX IF NOT EXISTS `id_diritto_altri` (`id_diritto_altri`),
	ADD CONSTRAINT `articoli_ibfk_92_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_proprietario`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `articoli_ibfk_93_nofollow` FOREIGN KEY IF NOT EXISTS (`id_gruppo_proprietario`) REFERENCES `gruppi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `articoli_ibfk_94_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_proprietario`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `articoli_ibfk_95_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_gruppo`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `articoli_ibfk_96_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_altri`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611121239

-- marchi: proprietario, gruppo e diritti di riga
ALTER TABLE `marchi`
	ADD COLUMN IF NOT EXISTS `id_account_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_gruppo_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_gruppo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_altri` bigint(20) DEFAULT NULL,
	ADD INDEX IF NOT EXISTS `id_account_proprietario` (`id_account_proprietario`),
	ADD INDEX IF NOT EXISTS `id_gruppo_proprietario` (`id_gruppo_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_proprietario` (`id_diritto_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_gruppo` (`id_diritto_gruppo`),
	ADD INDEX IF NOT EXISTS `id_diritto_altri` (`id_diritto_altri`),
	ADD CONSTRAINT `marchi_ibfk_92_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_proprietario`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `marchi_ibfk_93_nofollow` FOREIGN KEY IF NOT EXISTS (`id_gruppo_proprietario`) REFERENCES `gruppi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `marchi_ibfk_94_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_proprietario`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `marchi_ibfk_95_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_gruppo`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `marchi_ibfk_96_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_altri`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611121240

-- notizie: proprietario, gruppo e diritti di riga
ALTER TABLE `notizie`
	ADD COLUMN IF NOT EXISTS `id_account_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_gruppo_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_gruppo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_altri` bigint(20) DEFAULT NULL,
	ADD INDEX IF NOT EXISTS `id_account_proprietario` (`id_account_proprietario`),
	ADD INDEX IF NOT EXISTS `id_gruppo_proprietario` (`id_gruppo_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_proprietario` (`id_diritto_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_gruppo` (`id_diritto_gruppo`),
	ADD INDEX IF NOT EXISTS `id_diritto_altri` (`id_diritto_altri`),
	ADD CONSTRAINT `notizie_ibfk_92_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_proprietario`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `notizie_ibfk_93_nofollow` FOREIGN KEY IF NOT EXISTS (`id_gruppo_proprietario`) REFERENCES `gruppi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `notizie_ibfk_94_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_proprietario`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `notizie_ibfk_95_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_gruppo`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `notizie_ibfk_96_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_altri`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611121241

-- annunci: proprietario, gruppo e diritti di riga
ALTER TABLE `annunci`
	ADD COLUMN IF NOT EXISTS `id_account_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_gruppo_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_gruppo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_altri` bigint(20) DEFAULT NULL,
	ADD INDEX IF NOT EXISTS `id_account_proprietario` (`id_account_proprietario`),
	ADD INDEX IF NOT EXISTS `id_gruppo_proprietario` (`id_gruppo_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_proprietario` (`id_diritto_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_gruppo` (`id_diritto_gruppo`),
	ADD INDEX IF NOT EXISTS `id_diritto_altri` (`id_diritto_altri`),
	ADD CONSTRAINT `annunci_ibfk_92_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_proprietario`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `annunci_ibfk_93_nofollow` FOREIGN KEY IF NOT EXISTS (`id_gruppo_proprietario`) REFERENCES `gruppi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `annunci_ibfk_94_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_proprietario`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `annunci_ibfk_95_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_gruppo`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `annunci_ibfk_96_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_altri`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611121242

-- risorse: proprietario, gruppo e diritti di riga
ALTER TABLE `risorse`
	ADD COLUMN IF NOT EXISTS `id_account_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_gruppo_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_proprietario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_gruppo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_diritto_altri` bigint(20) DEFAULT NULL,
	ADD INDEX IF NOT EXISTS `id_account_proprietario` (`id_account_proprietario`),
	ADD INDEX IF NOT EXISTS `id_gruppo_proprietario` (`id_gruppo_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_proprietario` (`id_diritto_proprietario`),
	ADD INDEX IF NOT EXISTS `id_diritto_gruppo` (`id_diritto_gruppo`),
	ADD INDEX IF NOT EXISTS `id_diritto_altri` (`id_diritto_altri`),
	ADD CONSTRAINT `risorse_ibfk_92_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_proprietario`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `risorse_ibfk_93_nofollow` FOREIGN KEY IF NOT EXISTS (`id_gruppo_proprietario`) REFERENCES `gruppi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `risorse_ibfk_94_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_proprietario`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `risorse_ibfk_95_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_gruppo`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `risorse_ibfk_96_nofollow` FOREIGN KEY IF NOT EXISTS (`id_diritto_altri`) REFERENCES `diritti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611121243

-- anagrafica_view_static: le colonne nuove della vista, allo stesso posto
ALTER TABLE `anagrafica_view_static`
	ADD COLUMN IF NOT EXISTS `id_account_proprietario` bigint(20) DEFAULT NULL AFTER `data_archiviazione`,
	ADD COLUMN IF NOT EXISTS `id_gruppo_proprietario` bigint(20) DEFAULT NULL AFTER `id_account_proprietario`,
	ADD COLUMN IF NOT EXISTS `id_diritto_proprietario` bigint(20) DEFAULT NULL AFTER `id_gruppo_proprietario`,
	ADD COLUMN IF NOT EXISTS `id_diritto_gruppo` bigint(20) DEFAULT NULL AFTER `id_diritto_proprietario`,
	ADD COLUMN IF NOT EXISTS `id_diritto_altri` bigint(20) DEFAULT NULL AFTER `id_diritto_gruppo`;

-- | 202611121244

-- articoli_view_static: le colonne nuove della vista, allo stesso posto; prima le colonne del canone che la statica
-- potesse non avere ancora, ciascuna dopo la sua precedente, perche' il posto lo chiede REPLACE ... SELECT * ( 12/11:
-- glistest non aveva note_archiviazione e l'AFTER si fermava ); dove ci sono gia', IF NOT EXISTS non fa niente
ALTER TABLE `articoli_view_static`
	ADD COLUMN IF NOT EXISTS `id_tipologia_pubblicazione` bigint(20) DEFAULT NULL FIRST,
	ADD COLUMN IF NOT EXISTS `pubblicazione` char(32) DEFAULT NULL AFTER `id_tipologia_pubblicazione`,
	ADD COLUMN IF NOT EXISTS `tipologia_listino` char(64) DEFAULT NULL AFTER `pubblicazione`,
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL AFTER `id`,
	ADD COLUMN IF NOT EXISTS `id_prodotto` bigint(20) DEFAULT NULL AFTER `codice`,
	ADD COLUMN IF NOT EXISTS `prodotto` char(255) DEFAULT NULL AFTER `id_prodotto`,
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL AFTER `prodotto`,
	ADD COLUMN IF NOT EXISTS `ean` char(32) DEFAULT NULL AFTER `ordine`,
	ADD COLUMN IF NOT EXISTS `isbn` char(32) DEFAULT NULL AFTER `ean`,
	ADD COLUMN IF NOT EXISTS `codice_produttore` char(64) DEFAULT NULL AFTER `isbn`,
	ADD COLUMN IF NOT EXISTS `id_reparto` bigint(20) DEFAULT NULL AFTER `codice_produttore`,
	ADD COLUMN IF NOT EXISTS `id_taglia` bigint(20) DEFAULT NULL AFTER `id_reparto`,
	ADD COLUMN IF NOT EXISTS `id_colore` bigint(20) DEFAULT NULL AFTER `id_taglia`,
	ADD COLUMN IF NOT EXISTS `id_periodicita` bigint(20) DEFAULT NULL AFTER `id_colore`,
	ADD COLUMN IF NOT EXISTS `periodicita` char(32) DEFAULT NULL AFTER `id_periodicita`,
	ADD COLUMN IF NOT EXISTS `id_tipologia_rinnovo` bigint(20) DEFAULT NULL AFTER `periodicita`,
	ADD COLUMN IF NOT EXISTS `tipologia_rinnovo` char(32) DEFAULT NULL AFTER `id_tipologia_rinnovo`,
	ADD COLUMN IF NOT EXISTS `larghezza` decimal(12,5) DEFAULT NULL AFTER `tipologia_rinnovo`,
	ADD COLUMN IF NOT EXISTS `lunghezza` decimal(12,5) DEFAULT NULL AFTER `larghezza`,
	ADD COLUMN IF NOT EXISTS `altezza` decimal(12,5) DEFAULT NULL AFTER `lunghezza`,
	ADD COLUMN IF NOT EXISTS `id_udm_dimensioni` bigint(20) DEFAULT NULL AFTER `altezza`,
	ADD COLUMN IF NOT EXISTS `udm_dimensioni` char(32) DEFAULT NULL AFTER `id_udm_dimensioni`,
	ADD COLUMN IF NOT EXISTS `peso` decimal(12,5) DEFAULT NULL AFTER `udm_dimensioni`,
	ADD COLUMN IF NOT EXISTS `id_udm_peso` bigint(20) DEFAULT NULL AFTER `peso`,
	ADD COLUMN IF NOT EXISTS `udm_peso` char(32) DEFAULT NULL AFTER `id_udm_peso`,
	ADD COLUMN IF NOT EXISTS `volume` decimal(12,5) DEFAULT NULL AFTER `udm_peso`,
	ADD COLUMN IF NOT EXISTS `id_udm_volume` bigint(20) DEFAULT NULL AFTER `volume`,
	ADD COLUMN IF NOT EXISTS `udm_volume` char(32) DEFAULT NULL AFTER `id_udm_volume`,
	ADD COLUMN IF NOT EXISTS `capacita` decimal(12,5) DEFAULT NULL AFTER `udm_volume`,
	ADD COLUMN IF NOT EXISTS `id_udm_capacita` bigint(20) DEFAULT NULL AFTER `capacita`,
	ADD COLUMN IF NOT EXISTS `udm_capacita` char(32) DEFAULT NULL AFTER `id_udm_capacita`,
	ADD COLUMN IF NOT EXISTS `durata` decimal(12,5) DEFAULT NULL AFTER `udm_capacita`,
	ADD COLUMN IF NOT EXISTS `id_udm_durata` bigint(20) DEFAULT NULL AFTER `durata`,
	ADD COLUMN IF NOT EXISTS `udm_durata` char(32) DEFAULT NULL AFTER `id_udm_durata`,
	ADD COLUMN IF NOT EXISTS `nome` varchar(512) DEFAULT NULL AFTER `udm_durata`,
	ADD COLUMN IF NOT EXISTS `note` text AFTER `nome`,
	ADD COLUMN IF NOT EXISTS `note_codifica` text AFTER `note`,
	ADD COLUMN IF NOT EXISTS `id_categorie` char(255) DEFAULT NULL AFTER `note_codifica`,
	ADD COLUMN IF NOT EXISTS `categorie` char(255) DEFAULT NULL AFTER `id_categorie`,
	ADD COLUMN IF NOT EXISTS `prezzi` text DEFAULT NULL AFTER `categorie`,
	ADD COLUMN IF NOT EXISTS `data_archiviazione` date DEFAULT NULL AFTER `prezzi`,
	ADD COLUMN IF NOT EXISTS `note_archiviazione` text AFTER `data_archiviazione`,
	ADD COLUMN IF NOT EXISTS `id_account_proprietario` bigint(20) DEFAULT NULL AFTER `note_archiviazione`,
	ADD COLUMN IF NOT EXISTS `id_gruppo_proprietario` bigint(20) DEFAULT NULL AFTER `id_account_proprietario`,
	ADD COLUMN IF NOT EXISTS `id_diritto_proprietario` bigint(20) DEFAULT NULL AFTER `id_gruppo_proprietario`,
	ADD COLUMN IF NOT EXISTS `id_diritto_gruppo` bigint(20) DEFAULT NULL AFTER `id_diritto_proprietario`,
	ADD COLUMN IF NOT EXISTS `id_diritto_altri` bigint(20) DEFAULT NULL AFTER `id_diritto_gruppo`,
	ADD COLUMN IF NOT EXISTS `id_account_inserimento` bigint(20) DEFAULT NULL AFTER `id_diritto_altri`,
	ADD COLUMN IF NOT EXISTS `timestamp_inserimento` int(11) DEFAULT NULL AFTER `id_account_inserimento`,
	ADD COLUMN IF NOT EXISTS `id_account_aggiornamento` bigint(20) DEFAULT NULL AFTER `timestamp_inserimento`,
	ADD COLUMN IF NOT EXISTS `timestamp_aggiornamento` int(11) DEFAULT NULL AFTER `id_account_aggiornamento`,
	ADD COLUMN IF NOT EXISTS `__label__` text AFTER `timestamp_aggiornamento`;

-- | 202611121245

-- attivita_view_static: le colonne nuove della vista, allo stesso posto; prima le colonne del canone che la statica
-- potesse non avere ancora, ciascuna dopo la sua precedente, perche' il posto lo chiede REPLACE ... SELECT * ( 12/11:
-- glistest non aveva note_archiviazione e l'AFTER si fermava ); dove ci sono gia', IF NOT EXISTS non fa niente
ALTER TABLE `attivita_view_static`
	ADD COLUMN IF NOT EXISTS `id_tipologia` bigint(20) DEFAULT NULL AFTER `id`,
	ADD COLUMN IF NOT EXISTS `tipologia` char(64) DEFAULT NULL AFTER `id_tipologia`,
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL AFTER `tipologia`,
	ADD COLUMN IF NOT EXISTS `id_cliente` bigint(20) DEFAULT NULL AFTER `codice`,
	ADD COLUMN IF NOT EXISTS `codice_cliente` char(64) DEFAULT NULL AFTER `id_cliente`,
	ADD COLUMN IF NOT EXISTS `cliente` char(255) DEFAULT NULL AFTER `codice_cliente`,
	ADD COLUMN IF NOT EXISTS `id_contatto` bigint(20) DEFAULT NULL AFTER `cliente`,
	ADD COLUMN IF NOT EXISTS `contatto` char(255) DEFAULT NULL AFTER `id_contatto`,
	ADD COLUMN IF NOT EXISTS `id_indirizzo` bigint(20) DEFAULT NULL AFTER `contatto`,
	ADD COLUMN IF NOT EXISTS `indirizzo` text AFTER `id_indirizzo`,
	ADD COLUMN IF NOT EXISTS `id_luogo` bigint(20) DEFAULT NULL AFTER `indirizzo`,
	ADD COLUMN IF NOT EXISTS `luogo` char(255) DEFAULT NULL AFTER `id_luogo`,
	ADD COLUMN IF NOT EXISTS `id_messaggio` bigint(20) DEFAULT NULL AFTER `luogo`,
	ADD COLUMN IF NOT EXISTS `id_asset` bigint(20) DEFAULT NULL AFTER `id_messaggio`,
	ADD COLUMN IF NOT EXISTS `asset` char(255) DEFAULT NULL AFTER `id_asset`,
	ADD COLUMN IF NOT EXISTS `data_riferimento` date DEFAULT NULL AFTER `asset`,
	ADD COLUMN IF NOT EXISTS `ora_inizio_riferimento` time DEFAULT NULL AFTER `data_riferimento`,
	ADD COLUMN IF NOT EXISTS `ora_fine_riferimento` time DEFAULT NULL AFTER `ora_inizio_riferimento`,
	ADD COLUMN IF NOT EXISTS `anagrafica_riferimento` char(255) DEFAULT NULL AFTER `ora_fine_riferimento`,
	ADD COLUMN IF NOT EXISTS `data_scadenza` date DEFAULT NULL AFTER `anagrafica_riferimento`,
	ADD COLUMN IF NOT EXISTS `ora_scadenza` time DEFAULT NULL AFTER `data_scadenza`,
	ADD COLUMN IF NOT EXISTS `data_programmazione` date DEFAULT NULL AFTER `ora_scadenza`,
	ADD COLUMN IF NOT EXISTS `ora_inizio_programmazione` time DEFAULT NULL AFTER `data_programmazione`,
	ADD COLUMN IF NOT EXISTS `ora_fine_programmazione` time DEFAULT NULL AFTER `ora_inizio_programmazione`,
	ADD COLUMN IF NOT EXISTS `id_anagrafica_programmazione` bigint(20) DEFAULT NULL AFTER `ora_fine_programmazione`,
	ADD COLUMN IF NOT EXISTS `anagrafica_programmazione` char(255) DEFAULT NULL AFTER `id_anagrafica_programmazione`,
	ADD COLUMN IF NOT EXISTS `ore_programmazione` decimal(5,2) DEFAULT NULL AFTER `anagrafica_programmazione`,
	ADD COLUMN IF NOT EXISTS `se_confermata` tinyint(1) DEFAULT NULL AFTER `ore_programmazione`,
	ADD COLUMN IF NOT EXISTS `data_attivita` date DEFAULT NULL AFTER `se_confermata`,
	ADD COLUMN IF NOT EXISTS `giorno_attivita` int(2) DEFAULT NULL AFTER `data_attivita`,
	ADD COLUMN IF NOT EXISTS `mese_attivita` int(2) DEFAULT NULL AFTER `giorno_attivita`,
	ADD COLUMN IF NOT EXISTS `anno_attivita` int(4) DEFAULT NULL AFTER `mese_attivita`,
	ADD COLUMN IF NOT EXISTS `ora_inizio` time DEFAULT NULL AFTER `anno_attivita`,
	ADD COLUMN IF NOT EXISTS `latitudine_ora_inizio` decimal(11,7) DEFAULT NULL AFTER `ora_inizio`,
	ADD COLUMN IF NOT EXISTS `longitudine_ora_inizio` decimal(11,7) DEFAULT NULL AFTER `latitudine_ora_inizio`,
	ADD COLUMN IF NOT EXISTS `data_fine` date DEFAULT NULL AFTER `longitudine_ora_inizio`,
	ADD COLUMN IF NOT EXISTS `ora_fine` time DEFAULT NULL AFTER `data_fine`,
	ADD COLUMN IF NOT EXISTS `latitudine_ora_fine` decimal(11,7) DEFAULT NULL AFTER `ora_fine`,
	ADD COLUMN IF NOT EXISTS `longitudine_ora_fine` decimal(11,7) DEFAULT NULL AFTER `latitudine_ora_fine`,
	ADD COLUMN IF NOT EXISTS `id_anagrafica` bigint(20) DEFAULT NULL AFTER `longitudine_ora_fine`,
	ADD COLUMN IF NOT EXISTS `anagrafica` char(255) DEFAULT NULL AFTER `id_anagrafica`,
	ADD COLUMN IF NOT EXISTS `id_account` bigint(20) DEFAULT NULL AFTER `anagrafica`,
	ADD COLUMN IF NOT EXISTS `ore` decimal(5,2) DEFAULT NULL AFTER `id_account`,
	ADD COLUMN IF NOT EXISTS `id_articolo` bigint(20) DEFAULT NULL AFTER `ore`,
	ADD COLUMN IF NOT EXISTS `quantita_prevista` decimal(9,2) DEFAULT NULL AFTER `id_articolo`,
	ADD COLUMN IF NOT EXISTS `nome` char(255) DEFAULT NULL AFTER `quantita_prevista`,
	ADD COLUMN IF NOT EXISTS `id_documento` bigint(20) DEFAULT NULL AFTER `nome`,
	ADD COLUMN IF NOT EXISTS `documento` char(255) DEFAULT NULL AFTER `id_documento`,
	ADD COLUMN IF NOT EXISTS `id_corrispondenza` bigint(20) DEFAULT NULL AFTER `documento`,
	ADD COLUMN IF NOT EXISTS `corrispondenza` char(255) DEFAULT NULL AFTER `id_corrispondenza`,
	ADD COLUMN IF NOT EXISTS `id_progetto` bigint(20) DEFAULT NULL AFTER `corrispondenza`,
	ADD COLUMN IF NOT EXISTS `progetto` char(255) DEFAULT NULL AFTER `id_progetto`,
	ADD COLUMN IF NOT EXISTS `id_contratto` bigint(20) DEFAULT NULL AFTER `progetto`,
	ADD COLUMN IF NOT EXISTS `contratto` char(255) DEFAULT NULL AFTER `id_contratto`,
	ADD COLUMN IF NOT EXISTS `discipline` char(255) DEFAULT NULL AFTER `contratto`,
	ADD COLUMN IF NOT EXISTS `id_matricola` bigint(20) DEFAULT NULL AFTER `discipline`,
	ADD COLUMN IF NOT EXISTS `id_immobile` bigint(20) DEFAULT NULL AFTER `id_matricola`,
	ADD COLUMN IF NOT EXISTS `id_step` bigint(20) DEFAULT NULL AFTER `id_immobile`,
	ADD COLUMN IF NOT EXISTS `step` char(255) DEFAULT NULL AFTER `id_step`,
	ADD COLUMN IF NOT EXISTS `id_pianificazione` bigint(20) DEFAULT NULL AFTER `step`,
	ADD COLUMN IF NOT EXISTS `id_todo` bigint(20) DEFAULT NULL AFTER `id_pianificazione`,
	ADD COLUMN IF NOT EXISTS `todo` char(255) DEFAULT NULL AFTER `id_todo`,
	ADD COLUMN IF NOT EXISTS `id_mastro_provenienza` bigint(20) DEFAULT NULL AFTER `todo`,
	ADD COLUMN IF NOT EXISTS `mastro_provenienza` char(64) DEFAULT NULL AFTER `id_mastro_provenienza`,
	ADD COLUMN IF NOT EXISTS `id_mastro_destinazione` bigint(20) DEFAULT NULL AFTER `mastro_provenienza`,
	ADD COLUMN IF NOT EXISTS `mastro_destinazione` char(64) DEFAULT NULL AFTER `id_mastro_destinazione`,
	ADD COLUMN IF NOT EXISTS `codice_archivium` char(32) DEFAULT NULL AFTER `mastro_destinazione`,
	ADD COLUMN IF NOT EXISTS `token` char(128) DEFAULT NULL AFTER `codice_archivium`,
	ADD COLUMN IF NOT EXISTS `id_account_proprietario` bigint(20) DEFAULT NULL AFTER `token`,
	ADD COLUMN IF NOT EXISTS `id_gruppo_proprietario` bigint(20) DEFAULT NULL AFTER `id_account_proprietario`,
	ADD COLUMN IF NOT EXISTS `id_diritto_proprietario` bigint(20) DEFAULT NULL AFTER `id_gruppo_proprietario`,
	ADD COLUMN IF NOT EXISTS `id_diritto_gruppo` bigint(20) DEFAULT NULL AFTER `id_diritto_proprietario`,
	ADD COLUMN IF NOT EXISTS `id_diritto_altri` bigint(20) DEFAULT NULL AFTER `id_diritto_gruppo`,
	ADD COLUMN IF NOT EXISTS `id_account_inserimento` bigint(20) DEFAULT NULL AFTER `id_diritto_altri`,
	ADD COLUMN IF NOT EXISTS `timestamp_inserimento` int(11) DEFAULT NULL AFTER `id_account_inserimento`,
	ADD COLUMN IF NOT EXISTS `id_account_aggiornamento` bigint(20) DEFAULT NULL AFTER `timestamp_inserimento`,
	ADD COLUMN IF NOT EXISTS `timestamp_aggiornamento` int(11) DEFAULT NULL AFTER `id_account_aggiornamento`,
	ADD COLUMN IF NOT EXISTS `data_archiviazione` date DEFAULT NULL AFTER `timestamp_aggiornamento`,
	ADD COLUMN IF NOT EXISTS `__label__` text AFTER `data_archiviazione`;

-- | 202611121246

-- documenti_view_static: le colonne nuove della vista, allo stesso posto; prima le colonne del canone che la statica
-- potesse non avere ancora, ciascuna dopo la sua precedente, perche' il posto lo chiede REPLACE ... SELECT * ( 12/11:
-- glistest non aveva note_archiviazione e l'AFTER si fermava ); dove ci sono gia', IF NOT EXISTS non fa niente
ALTER TABLE `documenti_view_static`
	ADD COLUMN IF NOT EXISTS `id_tipologia` bigint(20) DEFAULT NULL AFTER `id`,
	ADD COLUMN IF NOT EXISTS `tipologia` char(255) DEFAULT NULL AFTER `id_tipologia`,
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL AFTER `tipologia`,
	ADD COLUMN IF NOT EXISTS `numero` char(32) DEFAULT NULL AFTER `codice`,
	ADD COLUMN IF NOT EXISTS `sezionale` char(32) DEFAULT NULL AFTER `numero`,
	ADD COLUMN IF NOT EXISTS `numero_sezionale` varchar(65) DEFAULT NULL AFTER `sezionale`,
	ADD COLUMN IF NOT EXISTS `data` date DEFAULT NULL AFTER `numero_sezionale`,
	ADD COLUMN IF NOT EXISTS `nome` char(255) DEFAULT NULL AFTER `data`,
	ADD COLUMN IF NOT EXISTS `id_emittente` bigint(20) DEFAULT NULL AFTER `nome`,
	ADD COLUMN IF NOT EXISTS `emittente` varchar(320) DEFAULT NULL AFTER `id_emittente`,
	ADD COLUMN IF NOT EXISTS `id_referente_emittente` bigint(20) DEFAULT NULL AFTER `emittente`,
	ADD COLUMN IF NOT EXISTS `id_sede_emittente` bigint(20) DEFAULT NULL AFTER `id_referente_emittente`,
	ADD COLUMN IF NOT EXISTS `id_destinatario` bigint(20) DEFAULT NULL AFTER `id_sede_emittente`,
	ADD COLUMN IF NOT EXISTS `destinatario` varchar(320) DEFAULT NULL AFTER `id_destinatario`,
	ADD COLUMN IF NOT EXISTS `id_sede_destinatario` bigint(20) DEFAULT NULL AFTER `destinatario`,
	ADD COLUMN IF NOT EXISTS `id_destinatario_spedizione` bigint(20) DEFAULT NULL AFTER `id_sede_destinatario`,
	ADD COLUMN IF NOT EXISTS `destinatario_spedizione` varchar(320) DEFAULT NULL AFTER `id_destinatario_spedizione`,
	ADD COLUMN IF NOT EXISTS `id_sede_destinatario_spedizione` bigint(20) DEFAULT NULL AFTER `destinatario_spedizione`,
	ADD COLUMN IF NOT EXISTS `id_condizione_pagamento` bigint(20) DEFAULT NULL AFTER `id_sede_destinatario_spedizione`,
	ADD COLUMN IF NOT EXISTS `condizione_pagamento` char(32) DEFAULT NULL AFTER `id_condizione_pagamento`,
	ADD COLUMN IF NOT EXISTS `esigibilita` enum('I','D','S') DEFAULT NULL AFTER `condizione_pagamento`,
	ADD COLUMN IF NOT EXISTS `cig` char(16) DEFAULT NULL AFTER `esigibilita`,
	ADD COLUMN IF NOT EXISTS `cup` char(16) DEFAULT NULL AFTER `cig`,
	ADD COLUMN IF NOT EXISTS `riferimento` char(255) DEFAULT NULL AFTER `cup`,
	ADD COLUMN IF NOT EXISTS `totale_lordo_finale` decimal(16,2) DEFAULT NULL AFTER `riferimento`,
	ADD COLUMN IF NOT EXISTS `totale_coupon` decimal(16,2) DEFAULT NULL AFTER `totale_lordo_finale`,
	ADD COLUMN IF NOT EXISTS `codice_sdi` char(64) DEFAULT NULL AFTER `totale_coupon`,
	ADD COLUMN IF NOT EXISTS `codice_archivium` char(64) DEFAULT NULL AFTER `codice_sdi`,
	ADD COLUMN IF NOT EXISTS `progressivo_invio` char(5) DEFAULT NULL AFTER `codice_archivium`,
	ADD COLUMN IF NOT EXISTS `timestamp_invio` int(11) DEFAULT NULL AFTER `progressivo_invio`,
	ADD COLUMN IF NOT EXISTS `data_consegna` date DEFAULT NULL AFTER `timestamp_invio`,
	ADD COLUMN IF NOT EXISTS `id_coupon` bigint(20) DEFAULT NULL AFTER `data_consegna`,
	ADD COLUMN IF NOT EXISTS `id_carrello` bigint(20) DEFAULT NULL AFTER `id_coupon`,
	ADD COLUMN IF NOT EXISTS `id_carrelli_articoli` bigint(20) DEFAULT NULL AFTER `id_carrello`,
	ADD COLUMN IF NOT EXISTS `id_mastro_provenienza` bigint(20) DEFAULT NULL AFTER `id_carrelli_articoli`,
	ADD COLUMN IF NOT EXISTS `mastro_provenienza` char(64) DEFAULT NULL AFTER `id_mastro_provenienza`,
	ADD COLUMN IF NOT EXISTS `id_mastro_destinazione` bigint(20) DEFAULT NULL AFTER `mastro_provenienza`,
	ADD COLUMN IF NOT EXISTS `mastro_destinazione` char(64) DEFAULT NULL AFTER `id_mastro_destinazione`,
	ADD COLUMN IF NOT EXISTS `id_causale` bigint(20) DEFAULT NULL AFTER `mastro_destinazione`,
	ADD COLUMN IF NOT EXISTS `id_trasportatore` bigint(20) DEFAULT NULL AFTER `id_causale`,
	ADD COLUMN IF NOT EXISTS `porto` enum('franco','assegnato','-') DEFAULT NULL AFTER `id_trasportatore`,
	ADD COLUMN IF NOT EXISTS `id_pianificazione` bigint(20) DEFAULT NULL AFTER `porto`,
	ADD COLUMN IF NOT EXISTS `id_progetto` bigint(20) DEFAULT NULL AFTER `id_pianificazione`,
	ADD COLUMN IF NOT EXISTS `documenti_antecedenti` text AFTER `id_progetto`,
	ADD COLUMN IF NOT EXISTS `documenti_successivi` text AFTER `documenti_antecedenti`,
	ADD COLUMN IF NOT EXISTS `timestamp_chiusura` int(11) DEFAULT NULL AFTER `documenti_successivi`,
	ADD COLUMN IF NOT EXISTS `data_ora_chiusura` char(16) DEFAULT NULL AFTER `timestamp_chiusura`,
	ADD COLUMN IF NOT EXISTS `id_account_archiviazione` bigint(20) DEFAULT NULL AFTER `data_ora_chiusura`,
	ADD COLUMN IF NOT EXISTS `data_archiviazione` date DEFAULT NULL AFTER `id_account_archiviazione`,
	ADD COLUMN IF NOT EXISTS `id_account_proprietario` bigint(20) DEFAULT NULL AFTER `data_archiviazione`,
	ADD COLUMN IF NOT EXISTS `id_gruppo_proprietario` bigint(20) DEFAULT NULL AFTER `id_account_proprietario`,
	ADD COLUMN IF NOT EXISTS `id_diritto_proprietario` bigint(20) DEFAULT NULL AFTER `id_gruppo_proprietario`,
	ADD COLUMN IF NOT EXISTS `id_diritto_gruppo` bigint(20) DEFAULT NULL AFTER `id_diritto_proprietario`,
	ADD COLUMN IF NOT EXISTS `id_diritto_altri` bigint(20) DEFAULT NULL AFTER `id_diritto_gruppo`,
	ADD COLUMN IF NOT EXISTS `id_account_inserimento` bigint(20) DEFAULT NULL AFTER `id_diritto_altri`,
	ADD COLUMN IF NOT EXISTS `timestamp_inserimento` int(11) DEFAULT NULL AFTER `id_account_inserimento`,
	ADD COLUMN IF NOT EXISTS `id_account_aggiornamento` bigint(20) DEFAULT NULL AFTER `timestamp_inserimento`,
	ADD COLUMN IF NOT EXISTS `timestamp_aggiornamento` int(11) DEFAULT NULL AFTER `id_account_aggiornamento`,
	ADD COLUMN IF NOT EXISTS `__label__` text AFTER `timestamp_aggiornamento`;

-- | 202611121247

-- todo_view_static: le colonne nuove della vista, allo stesso posto; prima le colonne del canone che la statica
-- potesse non avere ancora, ciascuna dopo la sua precedente, perche' il posto lo chiede REPLACE ... SELECT * ( 12/11:
-- glistest non aveva note_archiviazione e l'AFTER si fermava ); dove ci sono gia', IF NOT EXISTS non fa niente
ALTER TABLE `todo_view_static`
	ADD COLUMN IF NOT EXISTS `id_tipologia` bigint(20) DEFAULT NULL AFTER `id`,
	ADD COLUMN IF NOT EXISTS `tipologia` char(64) DEFAULT NULL AFTER `id_tipologia`,
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL AFTER `tipologia`,
	ADD COLUMN IF NOT EXISTS `se_agenda` tinyint(1) DEFAULT NULL AFTER `codice`,
	ADD COLUMN IF NOT EXISTS `id_anagrafica` bigint(20) DEFAULT NULL AFTER `se_agenda`,
	ADD COLUMN IF NOT EXISTS `anagrafica` char(255) DEFAULT NULL AFTER `id_anagrafica`,
	ADD COLUMN IF NOT EXISTS `id_cliente` bigint(20) DEFAULT NULL AFTER `anagrafica`,
	ADD COLUMN IF NOT EXISTS `cliente` char(255) DEFAULT NULL AFTER `id_cliente`,
	ADD COLUMN IF NOT EXISTS `id_indirizzo` bigint(20) DEFAULT NULL AFTER `cliente`,
	ADD COLUMN IF NOT EXISTS `indirizzo` char(255) DEFAULT NULL AFTER `id_indirizzo`,
	ADD COLUMN IF NOT EXISTS `id_luogo` bigint(20) DEFAULT NULL AFTER `indirizzo`,
	ADD COLUMN IF NOT EXISTS `luogo` char(255) DEFAULT NULL AFTER `id_luogo`,
	ADD COLUMN IF NOT EXISTS `timestamp_apertura` int(11) DEFAULT NULL AFTER `luogo`,
	ADD COLUMN IF NOT EXISTS `data_scadenza` date DEFAULT NULL AFTER `timestamp_apertura`,
	ADD COLUMN IF NOT EXISTS `ora_scadenza` time DEFAULT NULL AFTER `data_scadenza`,
	ADD COLUMN IF NOT EXISTS `data_programmazione` date DEFAULT NULL AFTER `ora_scadenza`,
	ADD COLUMN IF NOT EXISTS `ora_inizio_programmazione` time DEFAULT NULL AFTER `data_programmazione`,
	ADD COLUMN IF NOT EXISTS `ora_fine_programmazione` time DEFAULT NULL AFTER `ora_inizio_programmazione`,
	ADD COLUMN IF NOT EXISTS `anno_programmazione` year(4) DEFAULT NULL AFTER `ora_fine_programmazione`,
	ADD COLUMN IF NOT EXISTS `settimana_programmazione` int(11) DEFAULT NULL AFTER `anno_programmazione`,
	ADD COLUMN IF NOT EXISTS `ore_programmazione` decimal(5,2) DEFAULT NULL AFTER `settimana_programmazione`,
	ADD COLUMN IF NOT EXISTS `data_chiusura` date DEFAULT NULL AFTER `ore_programmazione`,
	ADD COLUMN IF NOT EXISTS `nome` char(255) DEFAULT NULL AFTER `data_chiusura`,
	ADD COLUMN IF NOT EXISTS `id_contatto` bigint(20) DEFAULT NULL AFTER `nome`,
	ADD COLUMN IF NOT EXISTS `id_progetto` bigint(20) DEFAULT NULL AFTER `id_contatto`,
	ADD COLUMN IF NOT EXISTS `progetto` char(255) DEFAULT NULL AFTER `id_progetto`,
	ADD COLUMN IF NOT EXISTS `discipline` char(255) DEFAULT NULL AFTER `progetto`,
	ADD COLUMN IF NOT EXISTS `id_documento` bigint(20) DEFAULT NULL AFTER `discipline`,
	ADD COLUMN IF NOT EXISTS `documento` char(255) DEFAULT NULL AFTER `id_documento`,
	ADD COLUMN IF NOT EXISTS `id_documenti_articoli` bigint(20) DEFAULT NULL AFTER `documento`,
	ADD COLUMN IF NOT EXISTS `documenti_articoli` char(255) DEFAULT NULL AFTER `id_documenti_articoli`,
	ADD COLUMN IF NOT EXISTS `id_istruzione` bigint(20) DEFAULT NULL AFTER `documenti_articoli`,
	ADD COLUMN IF NOT EXISTS `istruzione` char(255) DEFAULT NULL AFTER `id_istruzione`,
	ADD COLUMN IF NOT EXISTS `id_pianificazione` bigint(20) DEFAULT NULL AFTER `istruzione`,
	ADD COLUMN IF NOT EXISTS `id_immobile` bigint(20) DEFAULT NULL AFTER `id_pianificazione`,
	ADD COLUMN IF NOT EXISTS `data_archiviazione` date DEFAULT NULL AFTER `id_immobile`,
	ADD COLUMN IF NOT EXISTS `id_account_proprietario` bigint(20) DEFAULT NULL AFTER `data_archiviazione`,
	ADD COLUMN IF NOT EXISTS `id_gruppo_proprietario` bigint(20) DEFAULT NULL AFTER `id_account_proprietario`,
	ADD COLUMN IF NOT EXISTS `id_diritto_proprietario` bigint(20) DEFAULT NULL AFTER `id_gruppo_proprietario`,
	ADD COLUMN IF NOT EXISTS `id_diritto_gruppo` bigint(20) DEFAULT NULL AFTER `id_diritto_proprietario`,
	ADD COLUMN IF NOT EXISTS `id_diritto_altri` bigint(20) DEFAULT NULL AFTER `id_diritto_gruppo`,
	ADD COLUMN IF NOT EXISTS `id_account_inserimento` bigint(20) DEFAULT NULL AFTER `id_diritto_altri`,
	ADD COLUMN IF NOT EXISTS `timestamp_inserimento` int(11) DEFAULT NULL AFTER `id_account_inserimento`,
	ADD COLUMN IF NOT EXISTS `id_account_aggiornamento` bigint(20) DEFAULT NULL AFTER `timestamp_inserimento`,
	ADD COLUMN IF NOT EXISTS `timestamp_aggiornamento` int(11) DEFAULT NULL AFTER `id_account_aggiornamento`,
	ADD COLUMN IF NOT EXISTS `__label__` text DEFAULT NULL AFTER `timestamp_aggiornamento`;

-- | 202611121248

-- anagrafica_view
CREATE OR REPLACE VIEW `anagrafica_view` AS
	SELECT
		`anagrafica`.`id` AS `id`,
		`anagrafica`.`id_tipologia` AS `id_tipologia`,
		`tipologie_anagrafica`.`nome` AS `tipologia`,
		`anagrafica`.`codice` AS `codice`,
		`anagrafica`.`riferimento` AS `riferimento`,
		`anagrafica`.`nome` AS `nome`,
		`anagrafica`.`cognome` AS `cognome`,
		`anagrafica`.`denominazione` AS `denominazione`,
		`anagrafica`.`soprannome` AS `soprannome`,
		`anagrafica`.`sesso` AS `sesso`,
		`anagrafica`.`codice_fiscale` AS `codice_fiscale`,
		`anagrafica`.`partita_iva` AS `partita_iva`,
		`anagrafica`.`id_ranking` AS `id_ranking`,
		`ranking`.`nome` AS `ranking`,
		`anagrafica`.`recapiti` AS `recapiti`,
		NULL AS `id_stato`,
		NULL AS `id_provincia`,
		max(`categorie_anagrafica`.`se_prospect`) AS `se_prospect`,
		max(`categorie_anagrafica`.`se_lead`) AS `se_lead`,
		max(`categorie_anagrafica`.`se_cliente`) AS `se_cliente`,
		max(`categorie_anagrafica`.`se_fornitore`) AS `se_fornitore`,
		max(`categorie_anagrafica`.`se_produttore`) AS `se_produttore`,
		max(`categorie_anagrafica`.`se_collaboratore`) AS `se_collaboratore`,
		max(`categorie_anagrafica`.`se_interno`) AS `se_interno`,
		max(`categorie_anagrafica`.`se_esterno`) AS `se_esterno`,
		max(`categorie_anagrafica`.`se_commerciale`) AS `se_commerciale`,
		max(`categorie_anagrafica`.`se_concorrente`) AS `se_concorrente`,
		max(`categorie_anagrafica`.`se_gestita`) AS `se_gestita`,
		max(`categorie_anagrafica`.`se_amministrazione`) AS `se_amministrazione`,
		max(`categorie_anagrafica`.`se_notizie`) AS `se_notizie`,
		group_concat(distinct `categorie_anagrafica_path`(`categorie_anagrafica`.`id`) separator ' | ') AS `categorie`,
		group_concat(distinct `telefoni`.`numero` separator ' | ') AS `telefoni`,
		group_concat(distinct `mail`.`indirizzo` separator ' | ') AS `mail`,
		`anagrafica`.`anno_nascita` AS `anno_nascita`,
		`anagrafica`.`mese_nascita` AS `mese_nascita`,
		`anagrafica`.`giorno_nascita` AS `giorno_nascita`,
		concat_ws('-',`anagrafica`.`anno_nascita`,lpad(`anagrafica`.`mese_nascita`,2,'0'),lpad(`anagrafica`.`giorno_nascita`,2,'0')) AS `data_nascita`,
		`anagrafica`.`id_comune_nascita` AS `id_comune_nascita`,
		`anagrafica`.`data_archiviazione` AS `data_archiviazione`,
		`anagrafica`.`id_account_proprietario` AS `id_account_proprietario`,
		`anagrafica`.`id_gruppo_proprietario` AS `id_gruppo_proprietario`,
		`anagrafica`.`id_diritto_proprietario` AS `id_diritto_proprietario`,
		`anagrafica`.`id_diritto_gruppo` AS `id_diritto_gruppo`,
		`anagrafica`.`id_diritto_altri` AS `id_diritto_altri`,
		`anagrafica`.`id_account_inserimento` AS `id_account_inserimento`,
		`anagrafica`.`timestamp_inserimento` AS `timestamp_inserimento`,
		`anagrafica`.`id_account_aggiornamento` AS `id_account_aggiornamento`,
		`anagrafica`.`timestamp_aggiornamento` AS `timestamp_aggiornamento`,
		concat_ws(' ',`anagrafica`.`codice`,coalesce(`anagrafica`.`soprannome`,`anagrafica`.`denominazione`,concat_ws(' ',coalesce(`anagrafica`.`cognome`,''),coalesce(`anagrafica`.`nome`,'')),'')) AS `__label__`
	FROM
		((((((`anagrafica`
		left join `tipologie_anagrafica` on(`tipologie_anagrafica`.`id` = `anagrafica`.`id_tipologia`))
		left join `ranking` on(`ranking`.`id` = `anagrafica`.`id_ranking`))
		left join `anagrafica_categorie` on(`anagrafica_categorie`.`id_anagrafica` = `anagrafica`.`id`))
		left join `categorie_anagrafica` on(`categorie_anagrafica`.`id` = `anagrafica_categorie`.`id_categoria`))
		left join `telefoni` on(`telefoni`.`id_anagrafica` = `anagrafica`.`id`))
		left join `mail` on(`mail`.`id_anagrafica` = `anagrafica`.`id`))
		group by `anagrafica`.`id`
;

-- | 202611121249

-- attivita_view
CREATE OR REPLACE VIEW `attivita_view` AS                     --
	SELECT	                                                  --
		attivita.id,                                          --
		attivita.id_tipologia,                                --
		tipologie_attivita.nome AS tipologia,                 -- nome della tipologia
		attivita.codice,                                      --
		attivita.id_cliente,                                  --
		a2.codice AS codice_cliente,                          -- codice del cliente
		coalesce(                                             --
            a2.denominazione,                                 --
            concat(                                           --
                a2.cognome, ' ', a2.nome                      --
            ), ''                                             --
        ) AS cliente,                                         -- denominazione o cognome e nome del cliente
		attivita.id_contatto,                                 --
		c1.nome AS contatto,                                  -- nome del contatto
		attivita.id_indirizzo,                                --
		indirizzi.indirizzo AS indirizzo,                     -- indirizzo
		attivita.id_luogo,                                    --
		luoghi_path(                                          --
            coalesce(                                         --
                attivita.id_luogo, todo.id_luogo              --
            )                                                 --
        ) AS luogo,                                           -- percorso del luogo
		attivita.id_messaggio,                                --
		attivita.id_asset,                                    --
		concat( asset.id, ' ', asset.nome ) AS asset,         -- id e nome dell'asset su cui si svolge l'attività
        coalesce(                                             --
            attivita.data_attivita,                           --
            attivita.data_programmazione                      --
        ) AS data_riferimento,                                -- data di riferimento per ordinamento
		coalesce(                                             --
            attivita.ora_inizio,                              --
            attivita.ora_inizio_programmazione                --
        ) AS ora_inizio_riferimento,                          -- ora di inizio di riferimento
		coalesce(                                             --
            attivita.ora_fine,                                --
            attivita.ora_fine_programmazione                  --
        ) AS ora_fine_riferimento,                            -- ora di fine di riferimento
		coalesce(                                             --
            a1.denominazione,                                 --
            concat(                                           --
                a1.cognome, ' ', a1.nome                      --
            ),                                                --
            a3.denominazione,                                 --
            concat(                                           --
                a3.cognome, ' ', a3.nome                      --
            ),                                                --
            ''                                                --
        ) AS anagrafica_riferimento,                          -- denominazione o cognome e nome dell'anagrafica di programmazione o di esecuzione
		attivita.data_scadenza,                               --
		attivita.ora_scadenza,                                --
		attivita.data_programmazione,                         --
		attivita.ora_inizio_programmazione,                   --
		attivita.ora_fine_programmazione,                     --
		attivita.id_anagrafica_programmazione,                --
		coalesce(                                             --
            a3.denominazione,                                 --
            concat(                                           --
                a3.cognome, ' ', a3.nome                      --
            ),                                                --
            ''                                                --
        ) AS anagrafica_programmazione,                       -- denominazione o cognome e nome dell'anagrafica di programmazione
		attivita.ore_programmazione,                          --
		attivita.se_confermata,                               --
		attivita.data_attivita,                               --
		day( data_attivita ) as giorno_attivita,              -- giorno di attivita
		month( data_attivita ) as mese_attivita,              -- mese di attivita
		year( data_attivita ) as anno_attivita,               -- anno di attivita
		attivita.ora_inizio,                                  --
		attivita.latitudine_ora_inizio,                       --
		attivita.longitudine_ora_inizio,                      --
		attivita.data_fine,                                   --
		attivita.ora_fine,                                    --
		attivita.latitudine_ora_fine,                         --
		attivita.longitudine_ora_fine,                        --
		attivita.id_anagrafica,                               --
		coalesce(                                             --
            a1.denominazione,                                 --
            concat( a1.cognome, ' ', a1.nome ),               --
            ''                                                --
        ) AS anagrafica,                                      -- denominazione o cognome e nome dell'anagrafica
		attivita.id_account,                                  --
		attivita.ore,                                         --
        da.id_articolo,                                       -- id dell'articolo previsto
        da.quantita AS quantita_prevista,                     -- quantità prevista
		attivita.nome,                                        --
		attivita.id_documento,                                --
		concat(                                               --
			td.sigla,                                         --
			' ',                                              --
			documenti.numero,                                 --
			'/',                                              --
			documenti.sezionale,                              --
			' del ',                                          --
			documenti.data                                    --
		) AS documento,                                       -- tipologia, numero, sezionale e data del documento
		attivita.id_corrispondenza,                           --
		concat_ws(                                            --
            ' ',                                              --
            'da',                                             --
            coalesce(                                         --
                a4.denominazione,                             --
                concat( a4.cognome, ' ', a4.nome ),           --
                ''                                            --
            ),                                                --
            concat(                                           --
                '(',                                          --
                organizzazioni_path(                          --
                    cr.id_organizzazione_mittente             --
                ),                                            --   
                ')'                                           --
            ),                                                --
            tipologie_corrispondenza_path(                    --
                cr.id_tipologia                               --
            ),                                                --
            'per',                                            --
            coalesce(                                         --
                cr.destinatario_denominazione,                --
                concat(                                       --
                    cr.destinatario_cognome,                  --
                    ' ',                                      --
                    cr.destinatario_nome                      --
                ),                                            --
                ''                                            --
            )                                                 --
        ) AS corrispondenza,                                  -- descrizione della corrispondenza
		attivita.id_progetto,                                 --
		progetti.nome AS progetto,                            -- nome del progetto
		attivita.id_contratto,                                --
		concat_ws(                                            --
            ' ',                                              --
            tc.nome,                                          --
            c.nome                                            --
        ) AS contratto,                                       -- tipologia e nome del contratto
		group_concat(                                         --
            DISTINCT                                          --
            if(                                               --
                d.id,                                         --
                categorie_progetti_path( d.id ),              --
                null                                          --
            )                                                 --
            SEPARATOR ' | '                                   --
        ) AS discipline,                                      -- elenco delle discipline del progetto separate da |
		attivita.id_matricola,                                --
        attivita.id_immobile,                                 --
        attivita.id_step,                                     --
        step.nome AS step,                                    -- nome dello step
		attivita.id_pianificazione,                           --
		attivita.id_todo,                                     --
		todo.nome AS todo,                                    -- nome del todo
		attivita.id_mastro_provenienza,                       --
		m1.nome AS mastro_provenienza,                        --
		attivita.id_mastro_destinazione,                      --
		m2.nome AS mastro_destinazione,                       --
		attivita.codice_archivium,                            --
		attivita.token,                                       --
		attivita.id_account_proprietario,                     --
		attivita.id_gruppo_proprietario,                      --
		attivita.id_diritto_proprietario,                     --
		attivita.id_diritto_gruppo,                           --
		attivita.id_diritto_altri,                            --
		attivita.id_account_inserimento,                      --
		attivita.timestamp_inserimento,                       --
		attivita.id_account_aggiornamento,                    --
		attivita.timestamp_aggiornamento,                     --
		attivita.data_archiviazione,                          --
		concat(                                               --
			attivita.nome,                                    --
			' / ',                                            --
			attivita.ore,                                     --
			' / ',                                            --
			coalesce(                                         --
                a1.denominazione,                             --
                concat(                                       --
                    a1.cognome,                               --
                    ' ',                                      --
                    a1.nome                                   --
                ),                                            --
                ''                                            --
            )                                                 --
		) AS __label__                                        -- etichetta per le tendine e le liste
	FROM attivita                                             --
		LEFT JOIN tipologie_attivita                          --
            ON tipologie_attivita.id = attivita.id_tipologia  --
		LEFT JOIN anagrafica AS a1                            --
            ON a1.id = attivita.id_anagrafica                 --
		LEFT JOIN anagrafica AS a2                            --
            ON a2.id = attivita.id_cliente                    --
		LEFT JOIN anagrafica AS a3                            --
            ON a3.id = attivita.id_anagrafica_programmazione  --
		LEFT JOIN anagrafica AS a4                            --
            ON a4.id = attivita.id_corrispondenza             --
		LEFT JOIN contatti AS c1                              --
            ON c1.id = attivita.id_contatto                   --
		LEFT JOIN todo                                        --
            ON todo.id = attivita.id_todo                     --
		LEFT JOIN step                                        --
            ON step.id = attivita.id_step                     --
		LEFT JOIN progetti_categorie AS pc                    --
            ON pc.id_progetto = attivita.id_progetto          --
		LEFT JOIN progetti                                    --
            ON progetti.id = coalesce(                        --
                attivita.id_progetto,                         --
                todo.id_progetto                              --
            )                                                 --
		LEFT JOIN categorie_progetti                          --
            ON categorie_progetti.id = pc.id_categoria        --
		LEFT JOIN categorie_progetti AS d                     --
            ON d.id = pc.id_categoria                         --
                AND d.se_disciplina = 1                       --
		LEFT JOIN indirizzi                                   --
            ON indirizzi.id = attivita.id_indirizzo           --
		LEFT JOIN mastri AS m1                                --
            ON m1.id = attivita.id_mastro_provenienza         --
		LEFT JOIN mastri AS m2                                --
            ON m2.id = attivita.id_mastro_destinazione        --
		LEFT JOIN documenti                                   --
            ON documenti.id = attivita.id_documento           --
		LEFT JOIN tipologie_documenti AS td                   --
            ON td.id = documenti.id_tipologia                 --
		LEFT JOIN contratti AS c                              --
            ON c.id = attivita.id_contratto                   --
		LEFT JOIN tipologie_contratti AS tc                   --
            ON tc.id = c.id_tipologia                         --
		LEFT JOIN corrispondenza AS cr                        --
            ON cr.id = attivita.id_corrispondenza             --
		LEFT JOIN organizzazioni AS o                         --
            ON o.id = cr.id_organizzazione_mittente           --
		LEFT JOIN tipologie_corrispondenza AS tc2             --
            ON tc2.id = cr.id_tipologia                       --
		LEFT JOIN asset                                       --
            ON asset.id = attivita.id_asset                   --
		LEFT JOIN documenti_articoli AS da                    --
            ON da.id = todo.id_documenti_articoli             --
	GROUP BY attivita.id                                      --
;

-- | 202611121250

-- todo_view
CREATE OR REPLACE VIEW `todo_view` AS select `todo`.`id` AS `id`,`todo`.`id_tipologia` AS `id_tipologia`,`tipologie_todo`.`nome` AS `tipologia`,`tipologie_todo`.`se_agenda` AS `se_agenda`,`todo`.`codice` AS `codice`,`todo`.`nome` AS `nome`,`todo`.`id_anagrafica` AS `id_anagrafica`,coalesce(`a1`.`denominazione`,concat(`a1`.`cognome`,' ',`a1`.`nome`),'') AS `anagrafica`,`todo`.`id_cliente` AS `id_cliente`,coalesce(`a2`.`denominazione`,concat(`a2`.`cognome`,' ',`a2`.`nome`),'') AS `cliente`,`todo`.`id_contatto` AS `id_contatto`,`todo`.`id_indirizzo` AS `id_indirizzo`,concat_ws(' ',`indirizzi`.`indirizzo`,`indirizzi`.`civico`,`indirizzi`.`cap`,`indirizzi`.`localita`,`comuni`.`nome`,`provincie`.`sigla`) AS `indirizzo`,`todo`.`id_luogo` AS `id_luogo`,`luoghi_path`(`todo`.`id_luogo`) AS `luogo`,`todo`.`id_progetto` AS `id_progetto`,`progetti`.`nome` AS `progetto`,group_concat(distinct if(`d`.`id`,`categorie_progetti_path`(`d`.`id`),NULL) separator ' | ') AS `discipline`,`todo`.`id_pianificazione` AS `id_pianificazione`,`todo`.`id_immobile` AS `id_immobile`,`todo`.`id_documento` AS `id_documento`,concat(`tipologie_documenti`.`sigla`,' ',concat_ws('/',`documenti`.`numero`,`documenti`.`sezionale`),' del ',`documenti`.`data`) AS `documento`,`todo`.`id_documenti_articoli` AS `id_documenti_articoli`,if(`documenti_articoli`.`id` is null,NULL,concat_ws(' / ',coalesce(`documenti_articoli`.`data`,`documenti_righe`.`data`),`tipologie_documenti_articoli`.`sigla`,concat(`documenti_articoli`.`quantita`,' x ',`documenti_articoli`.`id_articolo`))) AS `documenti_articoli`,`todo`.`id_istruzione` AS `id_istruzione`,concat(`istruzioni`.`id_tipologia`,coalesce(`istruzioni`.`id_prodotto`,`istruzioni`.`id_articolo`),`istruzioni`.`nome`) AS `istruzione`,`todo`.`timestamp_apertura` AS `timestamp_apertura`,`todo`.`data_scadenza` AS `data_scadenza`,`todo`.`ora_scadenza` AS `ora_scadenza`,`todo`.`data_programmazione` AS `data_programmazione`,`todo`.`ora_inizio_programmazione` AS `ora_inizio_programmazione`,`todo`.`ora_fine_programmazione` AS `ora_fine_programmazione`,`todo`.`anno_programmazione` AS `anno_programmazione`,`todo`.`settimana_programmazione` AS `settimana_programmazione`,`todo`.`ore_programmazione` AS `ore_programmazione`,`todo`.`data_chiusura` AS `data_chiusura`,`todo`.`data_archiviazione` AS `data_archiviazione`,`todo`.`id_account_proprietario` AS `id_account_proprietario`,`todo`.`id_gruppo_proprietario` AS `id_gruppo_proprietario`,`todo`.`id_diritto_proprietario` AS `id_diritto_proprietario`,`todo`.`id_diritto_gruppo` AS `id_diritto_gruppo`,`todo`.`id_diritto_altri` AS `id_diritto_altri`,`todo`.`id_account_inserimento` AS `id_account_inserimento`,`todo`.`id_account_aggiornamento` AS `id_account_aggiornamento`,concat(coalesce(`todo`.`nome`,`tipologie_todo`.`nome`),coalesce(concat(' per ',coalesce(`a2`.`denominazione`,concat(`a2`.`cognome`,' ',`a2`.`nome`))),''),coalesce(concat(' su ',`todo`.`id_progetto`,' ',`progetti`.`nome`),'')) AS `__label__` from (((((((((((((((`todo` left join `anagrafica` `a1` on(`a1`.`id` = `todo`.`id_anagrafica`)) left join `anagrafica` `a2` on(`a2`.`id` = `todo`.`id_cliente`)) left join `indirizzi` on(`indirizzi`.`id` = `todo`.`id_indirizzo`)) left join `comuni` on(`comuni`.`id` = `indirizzi`.`id_comune`)) left join `provincie` on(`provincie`.`id` = `comuni`.`id_provincia`)) left join `tipologie_todo` on(`tipologie_todo`.`id` = `todo`.`id_tipologia`)) left join `progetti` on(`progetti`.`id` = `todo`.`id_progetto`)) left join `progetti_categorie` on(`progetti_categorie`.`id_progetto` = `progetti`.`id`)) left join `categorie_progetti` `d` on(`d`.`id` = `progetti_categorie`.`id_categoria` and `d`.`se_disciplina` = 1)) left join `documenti` on(`documenti`.`id` = `todo`.`id_documento`)) left join `tipologie_documenti` on(`tipologie_documenti`.`id` = `documenti`.`id_tipologia`)) left join `documenti_articoli` on(`documenti_articoli`.`id` = `todo`.`id_documenti_articoli`)) left join `documenti` `documenti_righe` on(`documenti_righe`.`id` = `documenti_articoli`.`id_documento`)) left join `tipologie_documenti` `tipologie_documenti_articoli` on(`tipologie_documenti_articoli`.`id` = coalesce(`documenti_articoli`.`id_tipologia_documento`,`documenti_righe`.`id_tipologia`))) left join `istruzioni` on(`istruzioni`.`id` = `todo`.`id_istruzione`)) group by `todo`.`id`
;

-- | 202611121251

-- progetti_view
CREATE OR REPLACE VIEW `progetti_view` AS
	SELECT
		progetti.id,
		progetti.id_tipologia,
		tipologie_progetti_path( tipologie_progetti.id ) AS tipologia,
		progetti.codice,
		progetti.nome,
		a1.id_ranking,
		ranking.nome AS ranking,
		progetti.id_prodotto,
		progetti.id_articolo,
		progetti.id_periodo,
		progetti.id_cliente,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS cliente,
		progetti.id_indirizzo,
		progetti.id_pianificazione,
		progetti.note,
		progetti.entrate_previste,
		progetti.ore_previste,
		progetti.uscite_previste,
		progetti.id_periodicita_prevista,
		progetti.data_accettazione,
		progetti.entrate_accettazione,
		progetti.id_periodicita_accettazione,
		progetti.data_apertura,
		progetti.data_consegna,
		progetti.data_chiusura,
		progetti.entrate_totali,
		progetti.ore_totali,
		progetti.uscite_totali,
		-- SOTTOQUERY E NON JOIN PIU' GROUP BY: vedi la nota in articoli_view ( 22/10/2026, come prodotti_view )
		coalesce( ( SELECT group_concat( DISTINCT categorie_progetti_path( pc.id_categoria ) SEPARATOR ' | ' )
			FROM progetti_categorie AS pc
		   WHERE pc.id_progetto = progetti.id
		), '' ) AS categorie,
		progetti.template,
		progetti.schema_html,
		progetti.tema_css,
		progetti.se_sitemap,
		progetti.se_cacheable,
		progetti.id_sito,
		progetti.id_pagina,
		progetti.data_archiviazione,
		progetti.id_account_proprietario,
		progetti.id_gruppo_proprietario,
		progetti.id_diritto_proprietario,
		progetti.id_diritto_gruppo,
		progetti.id_diritto_altri,
		progetti.id_account_inserimento,
		progetti.id_account_aggiornamento,
		concat_ws(
			' ',
			progetti.codice,
			progetti.nome,
			coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' )
		) AS __label__
	FROM progetti
		LEFT JOIN tipologie_progetti ON tipologie_progetti.id = progetti.id_tipologia
		LEFT JOIN anagrafica AS a1 ON a1.id = progetti.id_cliente
		LEFT JOIN ranking ON ranking.id = a1.id_ranking
;

-- | 202611121252

-- contratti_view
CREATE OR REPLACE VIEW `contratti_view` AS
	SELECT
		contratti.id,
		contratti.id_tipologia,
		tipologie_contratti.nome AS tipologia,
		contratti.codice,
		contratti.nome,
		contratti.id_immobile,
		concat_ws(
			' ',
			tipologie_immobili.nome, 
			coalesce(
			concat('scala ', immobili.scala), 
			''
			), 
			coalesce(
			concat('piano ', immobili.piano), 
			''
			), 
			coalesce(
			concat('int. ', immobili.interno), 
			''
			),
			tipologie_edifici.nome,
			edifici.nome,
			tipologie_indirizzi.nome,
			indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) AS immobile,
		contratti.id_progetto,
		progetti.nome AS progetto,
		contratti.id_account_archiviazione,
		contratti.data_archiviazione,
		contratti.id_account_proprietario,
		contratti.id_gruppo_proprietario,
		contratti.id_diritto_proprietario,
		contratti.id_diritto_gruppo,
		contratti.id_diritto_altri,
		contratti.id_account_inserimento,
		contratti.id_account_aggiornamento,
        coalesce( min(rinnovi.data_inizio), '-' ) AS data_inizio,
        coalesce( max(rinnovi.data_fine), '-' ) AS data_fine,
		group_concat( DISTINCT coalesce( proponente.denominazione , concat( proponente.cognome, ' ', proponente.nome ) )  SEPARATOR ', ' ) AS proponenti,
		group_concat( DISTINCT contraente.id SEPARATOR ', ' ) AS id_contraenti,
		group_concat( DISTINCT contraente.codice  SEPARATOR ', ' ) AS codici_contraenti,
		group_concat( DISTINCT coalesce( contraente.denominazione , concat( contraente.cognome, ' ', contraente.nome ) )  SEPARATOR ', ' ) AS contraenti,
		group_concat( DISTINCT licenze.codice SEPARATOR ', ' ) AS licenze,
		max( licenze.postazioni ) AS postazioni,
		group_concat( DISTINCT tipologie_licenze.nome SEPARATOR ', ' ) AS tipologia_licenza,
		group_concat( DISTINCT concat_ws( ' ', licenze.codice, tipologie_licenze.nome, licenze.nome ) SEPARATOR ' | ' ) AS dettagli_licenze,
		concat_ws( 
			' ', 
			tipologie_contratti.nome, 
			contratti.nome, 
			progetti.nome,
			concat( 'dal ', coalesce( date_format( min(rinnovi.data_inizio), '%d/%m/%Y' ), '-' ) ),
			concat( 'al ', coalesce( date_format( max(rinnovi.data_fine), '%d/%m/%Y' ), '-' ) ),
			group_concat( 
				DISTINCT coalesce( contraente.denominazione , concat( contraente.cognome, ' ', contraente.nome ), NULL )  SEPARATOR ', ' 
			) 
		) AS __label__
	FROM contratti
        LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
        LEFT JOIN progetti ON progetti.id = contratti.id_progetto
		LEFT JOIN immobili ON immobili.id = contratti.id_immobile
		LEFT JOIN tipologie_immobili ON tipologie_immobili.id = immobili.id_tipologia
		LEFT JOIN edifici ON edifici.id = immobili.id_edificio
		LEFT JOIN tipologie_edifici ON tipologie_edifici.id = edifici.id_tipologia
		LEFT JOIN indirizzi ON indirizzi.id = edifici.id_indirizzo
		LEFT JOIN tipologie_indirizzi ON tipologie_indirizzi.id = indirizzi.id_tipologia
		LEFT JOIN zone_indirizzi ON zone_indirizzi.id_indirizzo = indirizzi.id 
		LEFT JOIN zone ON zone.id = zone_indirizzi.id_zona
		LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
		LEFT JOIN ruoli_anagrafica AS ruoli_proponenti ON ruoli_proponenti.se_proponente IS NOT NULL
		LEFT JOIN contratti_anagrafica AS proponenti ON proponenti.id_contratto = contratti.id AND proponenti.id_ruolo = ruoli_proponenti.id
		LEFT JOIN anagrafica AS proponente ON proponente.id = proponenti.id_anagrafica 
		LEFT JOIN ruoli_anagrafica AS ruoli_contraenti ON ruoli_contraenti.se_contraente IS NOT NULL
		LEFT JOIN contratti_anagrafica AS contraenti ON contraenti.id_contratto = contratti.id AND contraenti.id_ruolo = ruoli_contraenti.id
		LEFT JOIN anagrafica AS contraente ON contraente.id = contraenti.id_anagrafica
        LEFT JOIN rinnovi ON rinnovi.id_contratto = contratti.id
		LEFT JOIN licenze ON licenze.id = rinnovi.id_licenza
		LEFT JOIN tipologie_licenze ON tipologie_licenze.id = licenze.id_tipologia
	GROUP BY contratti.id, licenze.codice
;

-- | 202611121253

-- documenti_view
CREATE OR REPLACE VIEW `documenti_view` AS
    SELECT
		documenti.id,
		documenti.id_tipologia,
		tipologie_documenti.nome AS tipologia,
		documenti.codice,
		documenti.numero,
		documenti.sezionale,
		concat_ws(
			'/',
			documenti.numero,
			documenti.sezionale
		) AS numero_sezionale,
		documenti.data,
		documenti.nome,
		documenti.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		documenti.id_referente_emittente,
		documenti.id_sede_emittente,
		documenti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		documenti.id_sede_destinatario,
		documenti.id_destinatario_spedizione,
		coalesce( a3.denominazione , concat( a3.cognome, ' ', a3.nome ), '' ) AS destinatario_spedizione,
		documenti.id_sede_destinatario_spedizione,
		documenti.id_condizione_pagamento,
		condizioni_pagamento.codice AS condizione_pagamento,
		documenti.esigibilita,
		documenti.cig,
		documenti.cup,
		documenti.riferimento,
		-- Il totale di un documento e' quello che vale la prestazione, non i soli contanti.
		--
		-- Fix 2026-09-08. `importo_lordo_finale` e' la sola parte pagata in denaro: una ricevuta
		-- saldata per intero con un coupon ci metteva dentro ZERO. E non in modo coerente, perche'
		-- il ripiego su `importo_lordo_totale` scattava solo con NULL e mai con `0.00`, che i vari
		-- flussi di checkout scrivono uno per uno: due ricevute della stessa tornata finivano cosi'
		-- a dichiarare l'importo in due modi diversi ( segreteria Polisportiva Masi, 08/09/2026 ).
		--
		-- Il coupon e' un modo di pagare, non uno sconto sul dovuto: va sommato al contante. E'
		-- la stessa somma che la stampa della ricevuta usa da sempre come totale pagato
		-- ( coupon_valore + importo_lordo_finale ). Il ripiego sul nominale resta per il solo caso
		-- in cui non si sa ne' quanto e' stato incassato ne' quanto coperto dal buono: la rata
		-- pianificata e non ancora saldata.
		--
		-- NOTA per chi tocchera' questa vista: la `sum()` sta dentro un GROUP BY che ha in JOIN
		-- anche `relazioni_documenti` ( r1/r2 ), quindi su un documento con N pagamenti e M
		-- documenti collegati il totale risulta moltiplicato per M. Difetto reale ma indipendente
		-- da questo, e non verificabile qui: su questo deploy `relazioni_documenti` e' vuota.
		sum(
			CASE WHEN pagamenti.importo_lordo_finale IS NULL AND pagamenti.coupon_valore IS NULL
			     THEN coalesce( pagamenti.importo_lordo_totale, 0 )
			     ELSE coalesce( pagamenti.importo_lordo_finale, 0 ) + coalesce( pagamenti.coupon_valore, 0 )
			END
		) AS totale_lordo_finale,
		sum( coalesce( pagamenti.coupon_valore, 0 ) ) AS totale_coupon,
		documenti.codice_sdi,
		documenti.codice_archivium,
		documenti.progressivo_invio,
		documenti.timestamp_invio,
		documenti.data_consegna,
		documenti.id_coupon,
		documenti.id_carrello,
		documenti.id_carrelli_articoli,
		documenti.id_mastro_provenienza,
		m1.nome AS mastro_provenienza,
		documenti.id_mastro_destinazione,
		m2.nome AS mastro_destinazione,
		documenti.id_causale,
		documenti.id_trasportatore,
		documenti.porto,
		documenti.id_pianificazione,
		documenti.id_progetto,
		group_concat( DISTINCT d1.codice SEPARATOR ' | ' ) AS documenti_antecedenti,
		group_concat( DISTINCT d2.codice SEPARATOR ' | ' ) AS documenti_successivi,
		documenti.timestamp_chiusura,
		from_unixtime( documenti.timestamp_chiusura, '%Y-%m-%d %H:%i' ) AS data_ora_chiusura,
		documenti.id_account_archiviazione,
		documenti.data_archiviazione,
		documenti.id_account_proprietario,
		documenti.id_gruppo_proprietario,
		documenti.id_diritto_proprietario,
		documenti.id_diritto_gruppo,
		documenti.id_diritto_altri,
		documenti.id_account_inserimento,
		documenti.id_account_aggiornamento,
		concat_ws(
			' ',
			tipologie_documenti.sigla,
			concat_ws(
				'/',
				documenti.numero,
				documenti.sezionale
			),
			concat( 'del ', documenti.data ),
			concat(
				'per ',
				coalesce(
					a2.denominazione,
					concat(
						a2.cognome,
						' ',
						a2.nome
					),
					''
				)
			)
		) AS __label__
    FROM
		documenti
		LEFT JOIN anagrafica AS a1 ON a1.id = documenti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = documenti.id_destinatario
		LEFT JOIN anagrafica AS a3 ON a3.id = documenti.id_destinatario_spedizione
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
		LEFT JOIN condizioni_pagamento ON condizioni_pagamento.id = documenti.id_condizione_pagamento
		LEFT JOIN mastri AS m1 ON m1.id = documenti.id_mastro_provenienza
		LEFT JOIN mastri AS m2 ON m2.id = documenti.id_mastro_destinazione
		LEFT JOIN pagamenti ON pagamenti.id_documento = documenti.id
		LEFT JOIN relazioni_documenti AS r1 ON r1.id_documento = documenti.id
		LEFT JOIN documenti AS d1 ON d1.id = r1.id_documento_collegato
		LEFT JOIN relazioni_documenti AS r2 ON r2.id_documento_collegato = documenti.id
		LEFT JOIN documenti AS d2 ON d2.id = r2.id_documento
	GROUP BY
		documenti.id
;

-- | 202611121254

-- pagamenti_view
CREATE OR REPLACE VIEW `pagamenti_view` AS
	SELECT
		pagamenti.id,
		coalesce( pagamenti.id_tipologia, documenti.id_tipologia ) AS id_tipologia,
		pagamenti.codice,
		pagamenti.id_modalita_pagamento,
		concat(modalita_pagamento.codice_sdi, ' - ' ,modalita_pagamento.nome) AS modalita_pagamento,
		tipologie_pagamenti.nome AS tipologia,
		pagamenti.ordine,
		pagamenti.nome,
		pagamenti.note,
		pagamenti.note_pagamento,
		coalesce( pagamenti.id_documento, carrelli.id_documento, documenti_articoli.id_documento ) AS id_documento,
		pagamenti.id_carrello,
		pagamenti.id_carrelli_articoli,
        concat(
			tipologie_documenti.sigla,
			' ',
			documenti.numero,
			'/',
			year( documenti.data ),
			' del ',
			documenti.data
		) AS documento,
		tipologie_documenti.id AS id_tipologia_documento,
		group_concat( DISTINCT carrelli_articoli.id_articolo SEPARATOR '|' ) AS id_articoli,
		group_concat( DISTINCT COALESCE( categorie_progetti.id, cp_disc.id ) SEPARATOR '|' ) AS id_categorie_progetti,
		group_concat( DISTINCT COALESCE( categorie_progetti.nome, cp_disc.nome ) SEPARATOR '|' ) AS categorie_progetti,
		group_concat( DISTINCT COALESCE( categorie_progetti_path_find_ancestor( categorie_progetti.id ), categorie_progetti_path_find_ancestor( cp_disc.id ) ) ) AS id_aree,
		group_concat( DISTINCT COALESCE( aree.nome, aree_abb.nome ) ) AS aree,
		group_concat( DISTINCT concat( pagamenti.id_coupon, ':', pagamenti.coupon_valore ) SEPARATOR '|' ) AS dettagli_coupon,
		pagamenti.id_mastro_provenienza,
		m1.nome AS mastro_provenienza,
		pagamenti.id_mastro_destinazione,
		m2.nome AS mastro_destinazione,
		coalesce( documenti.id_emittente, pagamenti.id_creditore ) AS id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		coalesce( documenti.id_destinatario, pagamenti.id_debitore ) AS id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		pagamenti.id_iban,
		iban.iban AS iban,
		pagamenti.importo_lordo_totale,
		pagamenti.id_coupon,
		pagamenti.coupon_valore,
		pagamenti.importo_lordo_finale,
		pagamenti.id_listino,
		listini.nome AS listino,
		pagamenti.id_pianificazione,
		pagamenti.data_scadenza,
		day( pagamenti.data_scadenza ) as giorno_scadenza,
		month( pagamenti.data_scadenza ) as mese_scadenza,
		year( pagamenti.data_scadenza ) as anno_scadenza,
        documenti.data_archiviazione,
		pagamenti.timestamp_pagamento,
		from_unixtime( pagamenti.timestamp_pagamento, '%Y-%m-%d' ) AS data_ora_pagamento,
		day( from_unixtime( pagamenti.timestamp_pagamento, '%Y-%m-%d' ) ) as giorno_pagamento,
		month( from_unixtime( pagamenti.timestamp_pagamento, '%Y-%m-%d' ) ) as mese_pagamento,
		year( from_unixtime( pagamenti.timestamp_pagamento, '%Y-%m-%d' ) ) as anno_pagamento,
		pagamenti.id_account_proprietario,
		pagamenti.id_gruppo_proprietario,
		pagamenti.id_diritto_proprietario,
		pagamenti.id_diritto_gruppo,
		pagamenti.id_diritto_altri,
		pagamenti.id_account_inserimento,
		pagamenti.id_account_aggiornamento,
		pagamenti.nome AS __label__
	FROM pagamenti
		LEFT JOIN tipologie_pagamenti ON tipologie_pagamenti.id = pagamenti.id_tipologia
		LEFT JOIN mastri AS m1 ON m1.id = pagamenti.id_mastro_provenienza
		LEFT JOIN mastri AS m2 ON m2.id = pagamenti.id_mastro_destinazione
		LEFT JOIN listini ON listini.id = pagamenti.id_listino
		LEFT JOIN modalita_pagamento ON modalita_pagamento.id = pagamenti.id_modalita_pagamento
		LEFT JOIN carrelli_articoli ON carrelli_articoli.id = pagamenti.id_carrelli_articoli
		LEFT JOIN carrelli ON carrelli.id = pagamenti.id_carrello
		LEFT JOIN documenti_articoli ON documenti_articoli.id_carrelli_articoli = carrelli_articoli.id
		LEFT JOIN documenti ON documenti.id = coalesce( pagamenti.id_documento, carrelli.id_documento, documenti_articoli.id_documento )
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
		LEFT JOIN anagrafica AS a1 ON a1.id = coalesce( documenti.id_emittente, pagamenti.id_creditore )
		LEFT JOIN anagrafica AS a2 ON a2.id = coalesce( documenti.id_destinatario, pagamenti.id_debitore )
		LEFT JOIN iban ON iban.id = pagamenti.id_iban
		LEFT JOIN coupon ON coupon.id = pagamenti.id_coupon
		LEFT JOIN contratti ON contratti.id = coupon.causale_id_contratto
		-- LEFT JOIN progetti ON progetti.id = contratti.id_progetto
		LEFT JOIN articoli ON articoli.id = carrelli_articoli.id_articolo
		LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
		LEFT JOIN progetti ON IF( prodotti.id IS NOT NULL, progetti.id_prodotto = prodotti.id, progetti.id = contratti.id_progetto )
		LEFT JOIN progetti_categorie ON progetti_categorie.id_progetto = progetti.id
		LEFT JOIN categorie_progetti ON ( categorie_progetti.id = progetti_categorie.id_categoria AND categorie_progetti.se_disciplina = 1 )
		LEFT JOIN categorie_progetti AS aree ON aree.id = categorie_progetti_path_find_ancestor( categorie_progetti.id )
		LEFT JOIN tipologie_contratti AS tc_abb ON tc_abb.id_prodotto = prodotti.id AND tc_abb.se_abbonamento = 1
		-- la disciplina dell'abbonamento è memorizzata come metadati 'abbonamento|discipline' (multi-valore), non su tipologie_contratti.id_categoria_progetti
		LEFT JOIN metadati AS m_abb_disc ON m_abb_disc.id_tipologia_contratti = tc_abb.id AND m_abb_disc.nome = 'abbonamento|discipline'
		LEFT JOIN categorie_progetti AS cp_disc ON cp_disc.id = CAST( m_abb_disc.testo AS UNSIGNED ) AND cp_disc.se_disciplina = 1
		LEFT JOIN categorie_progetti AS aree_abb ON aree_abb.id = categorie_progetti_path_find_ancestor( cp_disc.id )
--	WHERE
--		tipologie_documenti.se_fattura = 1
--		OR
--		tipologie_documenti.se_nota_credito = 1
--		OR
--		tipologie_documenti.se_ricevuta = 1
--		OR
--		tipologie_documenti.se_pro_forma = 1
	GROUP BY pagamenti.id
;

-- | 202611121255

-- crediti_view
CREATE OR REPLACE VIEW `crediti_view` AS
	SELECT
		crediti.id,
		crediti.nome,
		crediti.id_pianificazione,
		crediti.id_documenti_articolo,
		concat(
			tipologie_documenti.sigla,
			' ',
			documenti.numero,
			'/',
			year( documenti.data ),
			' del ',
			documenti.data,
			' ',
			documenti_articoli.id_articolo
		) AS riga_documento,
		crediti.id_account_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS account_emittente,
		crediti.id_account_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS account_destinatario,
		crediti.id_mastro_provenienza,
		mastri_path( m1.id ) AS mastro_provenienza,
		crediti.id_mastro_destinazione,
		mastri_path( m2.id ) AS mastro_destinazione,
		crediti.quantita,
		crediti.note,
		crediti.data,
		crediti.id_account_proprietario,
		crediti.id_gruppo_proprietario,
		crediti.id_diritto_proprietario,
		crediti.id_diritto_gruppo,
		crediti.id_diritto_altri,
		crediti.id_account_inserimento,
		crediti.id_account_aggiornamento,
		concat(
			crediti.data,
			' / ',
			tipologie_documenti.sigla,
			' / ',
			crediti.quantita,
			' x ',
			documenti_articoli.id_articolo,
			' / ',
			crediti.nome
		) AS __label__
	FROM crediti
		LEFT JOIN documenti_articoli ON documenti_articoli.id = crediti.id_documenti_articolo
		LEFT JOIN documenti ON documenti.id = documenti_articoli.id_documento
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
		LEFT JOIN account AS acc1 ON acc1.id = crediti.id_account_emittente
		LEFT JOIN anagrafica AS a1 ON a1.id = acc1.id_anagrafica
		LEFT JOIN account AS acc2 ON acc2.id = crediti.id_account_destinatario
		LEFT JOIN anagrafica AS a2 ON a2.id = acc2.id_anagrafica
		LEFT JOIN mastri AS m1 ON m1.id = crediti.id_mastro_provenienza
		LEFT JOIN mastri AS m2 ON m2.id = crediti.id_mastro_destinazione
;

-- | 202611121256

-- conversazioni_view
CREATE OR REPLACE VIEW conversazioni_view AS
	SELECT
		conversazioni.id,
		conversazioni.codice,
		conversazioni.nome,
		conversazioni.id_annuncio,
		conversazioni.note,
		conversazioni.timestamp_apertura,
		conversazioni.timestamp_chiusura,
		conversazioni.id_account_proprietario,
		conversazioni.id_gruppo_proprietario,
		conversazioni.id_diritto_proprietario,
		conversazioni.id_diritto_gruppo,
		conversazioni.id_diritto_altri,
		conversazioni.id_account_inserimento,
		conversazioni.timestamp_inserimento,
		conversazioni.id_account_aggiornamento,
		conversazioni.timestamp_aggiornamento,
		conversazioni.nome AS __label__
	FROM
		conversazioni
;

-- | 202611121257

-- contatti_view
CREATE OR REPLACE VIEW contatti_view AS
	SELECT
		contatti.id,
		contatti.id_tipologia,
		tipologie_contatti.nome AS tipologia,
		contatti.nome,
		contatti.id_anagrafica,
		coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ) AS anagrafica,
		contatti.id_campagna,
		campagne.nome AS campagna,
		contatti.id_sito,
		contatti.utm_id,
		contatti.utm_source,
		contatti.utm_medium,
		contatti.utm_campaign,
		contatti.utm_term,
		contatti.utm_content,
		contatti.modulo,
		contatti.timestamp_contatto,
		from_unixtime( contatti.timestamp_contatto, '%Y-%m-%d %H:%i' ) AS data_ora_contatto,
		contatti.id_account_archiviazione,
		contatti.data_archiviazione,
		contatti.id_account_proprietario,
		contatti.id_gruppo_proprietario,
		contatti.id_diritto_proprietario,
		contatti.id_diritto_gruppo,
		contatti.id_diritto_altri,
		contatti.id_account_inserimento,
		contatti.id_account_aggiornamento,
		concat(
			tipologie_contatti.nome,
			' / ',
			contatti.nome
		) AS __label__
	FROM contatti
		LEFT JOIN tipologie_contatti ON tipologie_contatti.id = contatti.id_tipologia
		LEFT JOIN anagrafica ON anagrafica.id = contatti.id_anagrafica
		LEFT JOIN campagne ON campagne.id = contatti.id_campagna
;

-- | 202611121258

-- corrispondenza_view
CREATE OR REPLACE VIEW `corrispondenza_view` AS
	SELECT
		corrispondenza.id,
		corrispondenza.id_tipologia,
		tipologie_corrispondenza_path( corrispondenza.id_tipologia ) AS tipologia,
		corrispondenza.codice,
		corrispondenza.nome,
		corrispondenza.id_mittente,
		coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ) AS mittente,
		corrispondenza.id_organizzazione_mittente,
		organizzazioni_path( corrispondenza.id_organizzazione_mittente ) AS organizzazione_mittente,
		corrispondenza.id_commesso,
		coalesce( commessi.denominazione , concat( commessi.cognome, ' ', commessi.nome ), '' ) AS commesso,
		corrispondenza.destinatario_id_anagrafica,
		coalesce( corrispondenza.destinatario_denominazione , concat( corrispondenza.destinatario_cognome, ' ', corrispondenza.destinatario_nome ), '' ) AS destinatario,
		coalesce(
			concat( corrispondenza.destinatario_indirizzo, ' ', corrispondenza.destinatario_civico, ', ', corrispondenza.destinatario_cap, ' ', coalesce( corrispondenza.destinatario_citta, '' ), comuni.nome, ' ', provincie.sigla ),
			concat( comuni.nome, ' ', provincie.sigla ),
			concat_ws( ' ', corrispondenza.destinatario_cap, stati.nome ),
			''
		) AS destinazione,
		corrispondenza.id_formato,
		formati_tipologie_corrispondenza.nome AS formato,
		corrispondenza.id_peso,
		pesi_tipologie_corrispondenza.nome AS peso_tipologia,
		corrispondenza.peso,
		corrispondenza.id_udm_peso,
		corrispondenza.quantita,
		corrispondenza.id_distinta_spedizione,
		corrispondenza.timestamp_consegna,
		corrispondenza.timestamp_elaborazione,
		corrispondenza.timestamp_gestione,
		corrispondenza.id_account_proprietario,
		corrispondenza.id_gruppo_proprietario,
		corrispondenza.id_diritto_proprietario,
		corrispondenza.id_diritto_gruppo,
		corrispondenza.id_diritto_altri,
		corrispondenza.id_account_inserimento,
		corrispondenza.timestamp_inserimento,
		corrispondenza.id_account_aggiornamento,
		corrispondenza.timestamp_aggiornamento,
		concat_ws(
			' ',
			'da',
			coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ),
			concat( '(', organizzazioni_path( corrispondenza.id_organizzazione_mittente ), ')' ),
			tipologie_corrispondenza_path( corrispondenza.id_tipologia ),
			'per',
			coalesce( corrispondenza.destinatario_denominazione , concat( corrispondenza.destinatario_cognome, ' ', corrispondenza.destinatario_nome ), '' )
		) AS __label__
	FROM corrispondenza
		INNER JOIN tipologie_corrispondenza ON tipologie_corrispondenza.id = corrispondenza.id_tipologia
		LEFT JOIN formati_tipologie_corrispondenza ON formati_tipologie_corrispondenza.id = corrispondenza.id_formato
		LEFT JOIN pesi_tipologie_corrispondenza ON pesi_tipologie_corrispondenza.id = corrispondenza.id_peso
		LEFT JOIN anagrafica ON anagrafica.id = corrispondenza.id_mittente
		LEFT JOIN anagrafica AS commessi ON commessi.id = corrispondenza.id_commesso
		LEFT JOIN comuni ON comuni.id = corrispondenza.destinatario_id_comune
		LEFT JOIN provincie ON provincie.id = coalesce( corrispondenza.destinatario_id_provincia, comuni.id_provincia )
		LEFT JOIN stati ON stati.id = corrispondenza.destinatario_id_stato
	WHERE tipologie_corrispondenza.se_corrispondenza = 1
;

-- | 202611121259

-- campagne_view
CREATE OR REPLACE VIEW `campagne_view` AS
	SELECT
		campagne.id,
		campagne.id_genitore,
		campagne.id_tipologia,
		tipologie_campagne_path( campagne.id_tipologia ) AS tipologia,
		campagne.ordine,
		campagne.codice,
		campagne.nome,
		campagne.id_valuta,
		valute.iso4217 AS valuta,
		campagne.testo,
		campagne.note,
		campagne.budget,
		campagne.utm_id,
		campagne.utm_source,
		campagne.utm_medium,
		campagne.utm_campaign,
		campagne.utm_term,
		campagne.utm_content,
		campagne.data_inizio,
		campagne.data_fine,
		( SELECT count( contatti.id ) FROM contatti WHERE contatti.id_campagna = campagne.id ) AS n_contatti,
		( SELECT count( carrelli.id ) FROM carrelli WHERE carrelli.id_campagna = campagne.id ) AS n_carrelli,
		campagne.id_account_proprietario,
		campagne.id_gruppo_proprietario,
		campagne.id_diritto_proprietario,
		campagne.id_diritto_gruppo,
		campagne.id_diritto_altri,
		campagne.id_account_inserimento,
		campagne.id_account_aggiornamento,
		campagne_path( campagne.id ) AS __label__
	FROM campagne
		LEFT JOIN valute ON valute.id = campagne.id_valuta
;

-- | 202611121260

-- funnel_view
CREATE OR REPLACE VIEW funnel_view AS
	SELECT
		funnel.id,
		funnel.nome,
		funnel.id_campagna,
		campagne.nome AS campagna,
		funnel.note,
		funnel.id_account_proprietario,
		funnel.id_gruppo_proprietario,
		funnel.id_diritto_proprietario,
		funnel.id_diritto_gruppo,
		funnel.id_diritto_altri,
		funnel.id_account_inserimento,
		funnel.id_account_aggiornamento,
		funnel.nome AS __label__
	FROM funnel
		LEFT JOIN campagne ON campagne.id = funnel.id_campagna
;

-- | 202611121261

-- mailing_view
CREATE OR REPLACE VIEW `mailing_view` AS
	SELECT
		mailing.id,
		mailing.nome,
		mailing.note,
		mailing.timestamp_invio,
		from_unixtime( mailing.timestamp_invio, '%Y-%m-%d %H:%i' ) AS data_ora_invio,
		mailing.id_account_proprietario,
		mailing.id_gruppo_proprietario,
		mailing.id_diritto_proprietario,
		mailing.id_diritto_gruppo,
		mailing.id_diritto_altri,
		mailing.id_account_inserimento,
		mailing.id_account_aggiornamento,
		mailing.nome AS __label__
	FROM mailing
;

-- | 202611121262

-- liste_view
CREATE OR REPLACE VIEW liste_view AS                          --
  SELECT                                                      --
    liste.id,                                                 --
    liste.codice,                                             --
    liste.nome,                                               --
    liste.note,                                               --
    liste.id_account_proprietario,                            --
    liste.id_gruppo_proprietario,                             --
    liste.id_diritto_proprietario,                            --
    liste.id_diritto_gruppo,                                  --
    liste.id_diritto_altri,                                   --
    liste.nome AS __label__                                   -- etichetta per le tendine e le liste
  FROM liste                                                  --
  ;

-- | 202611121263

-- valutazioni_view
CREATE OR REPLACE VIEW `valutazioni_view` AS
	SELECT
		valutazioni.id,
		valutazioni.id_immobile,
		concat_ws(
			' ',
			tipologie_immobili.nome,
			concat( 'scala ', immobili.scala ),
			concat( 'piano ', immobili.piano ),
			concat( 'int. ', immobili.interno ),
			tipologie_edifici.nome,
			edifici.nome,
			tipologie_indirizzi.nome,
			indirizzi.indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) AS immobile,
		valutazioni.id_matricola,
		matricole.matricola AS matricola,
		valutazioni.id_anagrafica,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		valutazioni.id_valutatore,
		coalesce( a2.denominazione, concat( a2.cognome, ' ', a2.nome ), '' ) AS valutatore,
		valutazioni.id_condizione,
		condizioni.nome AS condizione,
		valutazioni.id_disponibilita,
		disponibilita.nome AS disponibilita,
		valutazioni.id_classe_energetica,
		classi_energetiche.nome AS classe_energetica,
		valutazioni.id_valuta,
		valute.iso4217 AS valuta,
		valutazioni.importo,
		valutazioni.mq_commerciali,
		valutazioni.mq_calpestabili,
		valutazioni.note,
		valutazioni.timestamp_valutazione,
		valutazioni.id_account_proprietario,
		valutazioni.id_gruppo_proprietario,
		valutazioni.id_diritto_proprietario,
		valutazioni.id_diritto_gruppo,
		valutazioni.id_diritto_altri,
		valutazioni.id_account_inserimento,
		valutazioni.id_account_aggiornamento,
		concat_ws(
			' ',
			'valutazione',
			coalesce(
				nullif( concat_ws(
					' ',
					tipologie_immobili.nome,
					concat( 'scala ', immobili.scala ),
					concat( 'piano ', immobili.piano ),
					concat( 'int. ', immobili.interno ),
					tipologie_edifici.nome,
					edifici.nome,
					tipologie_indirizzi.nome,
					indirizzi.indirizzo,
					indirizzi.civico,
					indirizzi.cap,
					indirizzi.localita,
					comuni.nome,
					provincie.sigla
				), '' ),
				matricole.matricola,
				nullif( coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ) ), '' )
			),
			from_unixtime( valutazioni.timestamp_valutazione, '%Y-%m-%d' )
		) AS __label__
	FROM valutazioni
		LEFT JOIN immobili ON immobili.id = valutazioni.id_immobile
		LEFT JOIN tipologie_immobili ON tipologie_immobili.id = immobili.id_tipologia
		LEFT JOIN edifici ON edifici.id = immobili.id_edificio
		LEFT JOIN tipologie_edifici ON tipologie_edifici.id = edifici.id_tipologia
		LEFT JOIN indirizzi ON indirizzi.id = edifici.id_indirizzo
		LEFT JOIN tipologie_indirizzi ON tipologie_indirizzi.id = indirizzi.id_tipologia
		LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
		LEFT JOIN matricole ON matricole.id = valutazioni.id_matricola
		LEFT JOIN anagrafica AS a1 ON a1.id = valutazioni.id_anagrafica
		LEFT JOIN anagrafica AS a2 ON a2.id = valutazioni.id_valutatore
		LEFT JOIN condizioni ON condizioni.id = valutazioni.id_condizione
		LEFT JOIN disponibilita ON disponibilita.id = valutazioni.id_disponibilita
		LEFT JOIN classi_energetiche ON classi_energetiche.id = valutazioni.id_classe_energetica
		LEFT JOIN valute ON valute.id = valutazioni.id_valuta
;

-- | 202611121264

-- pianificazioni_view
CREATE OR REPLACE VIEW `pianificazioni_view` AS
	SELECT
		pianificazioni.id,
		pianificazioni.id_genitore,
		pianificazioni.id_progetto,
		pianificazioni.id_todo,
		pianificazioni.id_attivita,
		pianificazioni.id_contratto,
		pianificazioni.id_anagrafica,
		pianificazioni.nome,
		pianificazioni.note,
		pianificazioni.id_periodicita,
		periodicita.nome AS periodicita,
		pianificazioni.cadenza,
		pianificazioni.se_lunedi,
		pianificazioni.se_martedi,
		pianificazioni.se_mercoledi,
		pianificazioni.se_giovedi,
		pianificazioni.se_venerdi,
		pianificazioni.se_sabato,
		pianificazioni.se_domenica,
		pianificazioni.schema_ripetizione,
		pianificazioni.data_avvio,
		pianificazioni.data_inizio,
		pianificazioni.data_elaborazione,
		pianificazioni.timestamp_elaborazione,
		from_unixtime( pianificazioni.timestamp_elaborazione, '%Y-%m-%d %H:%i' ) AS data_ora_elaborazione,
		pianificazioni.data_ultimo_oggetto,
		pianificazioni.giorni_elaborazione,
		pianificazioni.giorni_estensione,
		pianificazioni.data_fine,
		pianificazioni.entita,
		pianificazioni.model_id_anagrafica,
		pianificazioni.model_id_anagrafica_programmazione,
		pianificazioni.model_id_articolo,
		pianificazioni.model_id_attivita,
		pianificazioni.model_id_causale,
		pianificazioni.model_id_cliente,
		pianificazioni.model_id_collo,
		pianificazioni.model_id_condizione_pagamento,
		pianificazioni.model_id_contatto,
		pianificazioni.model_id_coupon,
		pianificazioni.model_id_destinatario,
		pianificazioni.model_id_documento,
		pianificazioni.model_id_emittente,
		pianificazioni.model_id_genitore,
		pianificazioni.model_id_iban,
		pianificazioni.model_id_indirizzo,
		pianificazioni.model_id_immobile,
		pianificazioni.model_id_licenza,
		pianificazioni.model_id_listino,
		pianificazioni.model_id_luogo,
		pianificazioni.model_id_mastro_destinazione,
		pianificazioni.model_id_mastro_provenienza,
		pianificazioni.model_id_matricola,
		pianificazioni.model_id_modalita_pagamento,
		pianificazioni.model_id_prodotto,
		pianificazioni.model_id_progetto,
		pianificazioni.model_id_reparto,
		pianificazioni.model_id_sede_destinatario,
		pianificazioni.model_id_sede_emittente,
		pianificazioni.model_id_tipologia,
		pianificazioni.model_id_todo,
		pianificazioni.model_id_trasportatore,
		pianificazioni.model_id_udm,
		pianificazioni.model_anno_programmazione,
		pianificazioni.model_codice,
		pianificazioni.model_data,
		pianificazioni.model_data_fine,
		pianificazioni.model_data_inizio,
		pianificazioni.model_data_programmazione,
		pianificazioni.model_esigibilita,
		pianificazioni.model_importo_netto_totale,
		pianificazioni.model_importo_lordo_totale,
		pianificazioni.model_importo_lordo_finale,
		pianificazioni.model_nome,
		pianificazioni.model_note,
		pianificazioni.model_note_cliente,
		pianificazioni.model_note_programmazione,
		pianificazioni.model_numero,
		pianificazioni.model_ora_inizio_programmazione,
		pianificazioni.model_ora_fine_programmazione,
		pianificazioni.model_ore_programmazione,
		pianificazioni.model_porto,
		pianificazioni.model_quantita,
		pianificazioni.model_riferimento,
		pianificazioni.model_sconto_percentuale,
		pianificazioni.model_sconto_valore,
		pianificazioni.model_se_automatico,
		pianificazioni.model_sezionale,
		pianificazioni.model_settimana_programmazione,
		pianificazioni.model_specifiche,
		pianificazioni.model_data_scadenza,
		pianificazioni.offset_giorni,
		pianificazioni.offset_fine_mese,
		pianificazioni.iterazioni,
		pianificazioni.delay,
		pianificazioni.token,
		pianificazioni.id_account_proprietario,
		pianificazioni.id_gruppo_proprietario,
		pianificazioni.id_diritto_proprietario,
		pianificazioni.id_diritto_gruppo,
		pianificazioni.id_diritto_altri,
		pianificazioni.id_account_inserimento,
		pianificazioni.id_account_aggiornamento,
		concat_ws(
			' ',
			pianificazioni.nome,
			periodicita.nome,
			pianificazioni.cadenza
		) AS __label__
	FROM pianificazioni
		LEFT JOIN periodicita ON periodicita.id = pianificazioni.id_periodicita
;

-- | 202611121265

-- mastri_view
CREATE OR REPLACE VIEW `mastri_view` AS
	SELECT
		mastri.id,
		mastri.id_genitore,
		mastri.id_tipologia,
		tipologie_mastri.nome AS tipologia,
		mastri.codice,
		mastri.nome,
		coalesce( mastri.id_anagrafica, anagrafica_indirizzi.id_anagrafica ) AS id_anagrafica,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), a2.denominazione, concat( a2.cognome, ' ', a2.nome ), '' ) AS anagrafica,
		mastri.id_account,
		account.username AS account,
		mastri.id_progetto,
		progetti.nome AS progetto,
		mastri.id_anagrafica_indirizzi,
		coalesce( mastri.id_indirizzo, anagrafica_indirizzi.id_indirizzo ) AS id_indirizzo,
		concat_ws(
			' ',
			tipologie_indirizzi.nome,
			indirizzi.indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) AS indirizzo,
		mastri.id_edificio,
		mastri.id_immobile,
		mastri.id_vano,
		mastri.prefisso_modula,
		mastri.codice_modula,
		tipologie_mastri.se_magazzino,
		tipologie_mastri.se_conto,
		tipologie_mastri.se_registro,
		tipologie_mastri.se_credito,
		mastri.data_archiviazione,
		mastri.id_account_proprietario,
		mastri.id_gruppo_proprietario,
		mastri.id_diritto_proprietario,
		mastri.id_diritto_gruppo,
		mastri.id_diritto_altri,
		mastri.id_account_inserimento,
		mastri.id_account_aggiornamento,
		concat_ws( ' ', mastri.codice, mastri_path( mastri.id ) ) AS __label__
	FROM mastri
		LEFT JOIN tipologie_mastri ON tipologie_mastri.id = mastri.id_tipologia
		LEFT JOIN anagrafica_indirizzi ON anagrafica_indirizzi.id = mastri.id_anagrafica_indirizzi
		LEFT JOIN anagrafica AS a1 ON a1.id = anagrafica_indirizzi.id_anagrafica
		LEFT JOIN anagrafica AS a2 ON a2.id = mastri.id_anagrafica
		LEFT JOIN account ON account.id = mastri.id_account
		LEFT JOIN progetti ON progetti.id = mastri.id_progetto
		LEFT JOIN indirizzi ON indirizzi.id = coalesce( mastri.id_indirizzo, anagrafica_indirizzi.id_indirizzo )
		LEFT JOIN tipologie_indirizzi ON tipologie_indirizzi.id = indirizzi.id_tipologia
		LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
;

-- | 202611121266

-- asset_view
CREATE OR REPLACE VIEW `asset_view` AS
	SELECT
		asset.id,
		asset.id_genitore,
		asset.id_tipologia,
		tipologie_asset_path( asset.id_tipologia ) AS tipologia,
		asset.codice,
		asset.nome,
		asset.id_condizione,
		condizioni.nome AS condizione,
		asset.id_produttore,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS produttore,
		asset.modello,
		asset.targa,
		asset.hostname,
		asset.ip_address,
		asset.cespite,
		asset.note,
		asset.data_archiviazione,
		asset.note_archiviazione,
		asset.id_account_proprietario,
		asset.id_gruppo_proprietario,
		asset.id_diritto_proprietario,
		asset.id_diritto_gruppo,
		asset.id_diritto_altri,
		asset.id_account_inserimento,
		asset.timestamp_inserimento,
		asset.id_account_aggiornamento,
		asset.timestamp_aggiornamento,
		concat_ws( ' ', concat( '#', asset.codice ), asset_path( asset.id ) ) AS __label__
	FROM asset
		LEFT JOIN condizioni ON condizioni.id = asset.id_condizione
		LEFT JOIN anagrafica AS a1 ON a1.id = asset.id_produttore
;

-- | 202611121267

-- matricole_view
CREATE OR REPLACE VIEW `matricole_view` AS
	SELECT
		matricole.id,
		matricole.matricola,
		matricole.nome,
		matricole.id_articolo,
		concat_ws(
			' ',
			articoli.id,
			prodotti.nome,
			articoli.nome,
			coalesce(
				concat(
					articoli.larghezza, 'x', articoli.lunghezza, 'x', articoli.altezza,
					udm_dimensioni.sigla
				),
				concat(
					articoli.peso,
					udm_peso.sigla
				),
				concat(
					articoli.volume,
					udm_volume.sigla
				),
				concat(
					articoli.capacita,
					udm_capacita.sigla
				),
				concat(
					articoli.durata,
					udm_durata.sigla
				),
				''
			)
		) AS articolo,
		matricole.id_lotto,
		lotti.codice AS lotto,
		matricole.id_marchio,
		marchi.nome AS marchio,
		matricole.id_produttore,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS produttore,
		matricole.id_condizione,
		condizioni.nome AS condizione,
		matricole.note,
		matricole.data_scadenza,
		matricole.id_account_proprietario,
		matricole.id_gruppo_proprietario,
		matricole.id_diritto_proprietario,
		matricole.id_diritto_gruppo,
		matricole.id_diritto_altri,
		matricole.id_account_inserimento,
		matricole.id_account_aggiornamento,
		concat_ws(
			' ',
			matricole.matricola,
			'/',
			articoli.id,
			'/',
			prodotti.nome,
			articoli.nome,
			coalesce(
				concat(
					articoli.larghezza, 'x', articoli.lunghezza, 'x', articoli.altezza,
					udm_dimensioni.sigla
				),
				concat(
					articoli.peso,
					udm_peso.sigla
				),
				concat(
					articoli.volume,
					udm_volume.sigla
				),
				concat(
					articoli.capacita,
					udm_capacita.sigla
				),
				concat(
					articoli.durata,
					udm_durata.sigla
				),
				''
			),
			concat( 'scad. ', matricole.data_scadenza )
		) AS __label__
	FROM matricole
		LEFT JOIN articoli ON articoli.id = matricole.id_articolo
		LEFT JOIN udm AS udm_dimensioni ON udm_dimensioni.id = articoli.id_udm_dimensioni
		LEFT JOIN udm AS udm_peso ON udm_peso.id = articoli.id_udm_peso
		LEFT JOIN udm AS udm_volume ON udm_volume.id = articoli.id_udm_volume
		LEFT JOIN udm AS udm_capacita ON udm_capacita.id = articoli.id_udm_capacita
		LEFT JOIN udm AS udm_durata ON udm_durata.id = articoli.id_udm_durata
		LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
		LEFT JOIN lotti ON lotti.id = matricole.id_lotto
		LEFT JOIN marchi ON marchi.id = matricole.id_marchio
		LEFT JOIN anagrafica AS a1 ON a1.id = matricole.id_produttore
		LEFT JOIN condizioni ON condizioni.id = matricole.id_condizione
;

-- | 202611121268

-- lotti_view
CREATE OR REPLACE VIEW `lotti_view` AS
	SELECT
		lotti.id,
		lotti.codice,
		lotti.nome,
		lotti.id_articolo,
		concat_ws(
			' ',
			articoli.id,
			prodotti.nome,
			articoli.nome,
			coalesce(
				concat(
					articoli.larghezza, 'x', articoli.lunghezza, 'x', articoli.altezza,
					udm_dimensioni.sigla
				),
				concat(
					articoli.peso,
					udm_peso.sigla
				),
				concat(
					articoli.volume,
					udm_volume.sigla
				),
				concat(
					articoli.capacita,
					udm_capacita.sigla
				),
				concat(
					articoli.durata,
					udm_durata.sigla
				),
				''
			)
		) AS articolo,
		lotti.id_produttore,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS produttore,
		lotti.note,
		lotti.data_produzione,
		lotti.data_scadenza,
		lotti.id_account_proprietario,
		lotti.id_gruppo_proprietario,
		lotti.id_diritto_proprietario,
		lotti.id_diritto_gruppo,
		lotti.id_diritto_altri,
		lotti.id_account_inserimento,
		lotti.id_account_aggiornamento,
		concat_ws(
			' ',
			lotti.codice,
			'/',
			articoli.id,
			'/',
			prodotti.nome,
			articoli.nome,
			concat( 'scad. ', lotti.data_scadenza )
		) AS __label__
	FROM lotti
		LEFT JOIN articoli ON articoli.id = lotti.id_articolo
		LEFT JOIN udm AS udm_dimensioni ON udm_dimensioni.id = articoli.id_udm_dimensioni
		LEFT JOIN udm AS udm_peso ON udm_peso.id = articoli.id_udm_peso
		LEFT JOIN udm AS udm_volume ON udm_volume.id = articoli.id_udm_volume
		LEFT JOIN udm AS udm_capacita ON udm_capacita.id = articoli.id_udm_capacita
		LEFT JOIN udm AS udm_durata ON udm_durata.id = articoli.id_udm_durata
		LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
		LEFT JOIN anagrafica AS a1 ON a1.id = lotti.id_produttore
;

-- | 202611121269

-- licenze_view
CREATE OR REPLACE VIEW `licenze_view` AS
	SELECT
		licenze.id,
		licenze.id_tipologia,
		tipologie_licenze.nome AS tipologia,
		tipologie_licenze.giorni_validita,
		tipologie_licenze.giorni_rinnovo,
		licenze.codice,
		licenze.nome,
		coalesce( licenze.id_anagrafica, min( contratti_anagrafica.id_anagrafica ) ) AS id_anagrafica,
		group_concat( DISTINCT coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) SEPARATOR ', ' ) AS anagrafica,
		licenze.id_rivenditore,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS rivenditore,
		licenze.postazioni,
		licenze.testo,
		licenze.note,
		licenze.timestamp_distribuzione,
		min( rinnovi.data_inizio ) AS data_inizio,
		max( rinnovi.data_fine ) AS data_fine,
		max( rinnovi.id_contratto ) AS id_contratto,
		group_concat( DISTINCT tipologie_contratti.nome SEPARATOR ', ' ) AS tipologia_contratto,
		group_concat( DISTINCT concat_ws( '§', software.codice, software.nome ) SEPARATOR ' | ' ) AS software,
		licenze.id_account_proprietario,
		licenze.id_gruppo_proprietario,
		licenze.id_diritto_proprietario,
		licenze.id_diritto_gruppo,
		licenze.id_diritto_altri,
		licenze.id_account_inserimento,
		licenze.timestamp_inserimento,
		licenze.id_account_aggiornamento,
		licenze.timestamp_aggiornamento,
		concat_ws( ' ', coalesce( nullif( licenze.codice, '' ), nullif( licenze.nome, '' ), licenze.id ), tipologie_licenze.nome ) AS __label__
	FROM licenze
		LEFT JOIN tipologie_licenze ON tipologie_licenze.id = licenze.id_tipologia
		LEFT JOIN rinnovi ON rinnovi.id_licenza = licenze.id
		LEFT JOIN licenze_software ON licenze_software.id_licenza = licenze.id
		LEFT JOIN software ON software.id = licenze_software.id_software
		LEFT JOIN contratti ON contratti.id = rinnovi.id_contratto
		LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
		LEFT JOIN contratti_anagrafica ON contratti_anagrafica.id_contratto = contratti.id
			AND contratti_anagrafica.id_ruolo IN ( SELECT id FROM ruoli_anagrafica WHERE se_contraente = 1 )
		LEFT JOIN anagrafica AS a1 ON a1.id = coalesce( licenze.id_anagrafica, contratti_anagrafica.id_anagrafica )
		LEFT JOIN anagrafica AS a2 ON a2.id = licenze.id_rivenditore
	GROUP BY licenze.id
;

-- | 202611121270

-- software_view
CREATE OR REPLACE VIEW software_view AS                                                  --
  SELECT                                                                                 --
    software.id,                                                                         --
    software.id_genitore,                                                                --
    software.codice,                                                                     --
    software.nome,                                                                       --
    software.id_prodotto,                                                                --
    prodotti.nome AS prodotto,                                                           -- nome del prodotto
    software.id_articolo,                                                                --
    concat_ws( ' - ', p2.nome, articoli.nome ) AS articolo,                              -- prodotto e articolo
    software.json,                                                                       --
    software.note,                                                                       --
    software.id_account_proprietario,                                                    --
    software.id_gruppo_proprietario,                                                     --
    software.id_diritto_proprietario,                                                    --
    software.id_diritto_gruppo,                                                          --
    software.id_diritto_altri,                                                           --
    software.id_account_inserimento,                                                     --
    software.id_account_aggiornamento,                                                   --
    concat_ws(                                                                           --
      ' ',                                                                               --
      software.codice,                                                                   --
      software_path( software.id )                                                       --
    ) AS __label__                                                                       -- etichetta per le tendine e le liste
  FROM software                                                                          --
    LEFT JOIN prodotti ON prodotti.id = software.id_prodotto                             --
    LEFT JOIN articoli ON articoli.id = software.id_articolo                             --
    LEFT JOIN prodotti AS p2 ON p2.id = articoli.id_prodotto                             --
;

-- | 202611121271

-- chiavi_view
CREATE OR REPLACE VIEW chiavi_view AS
	SELECT
		chiavi.id,
		chiavi.id_tipologia,
		tipologie_chiavi.nome AS tipologia,
		chiavi.codice,
		chiavi.nome,
		chiavi.id_licenza,
		licenze.nome AS licenza,
		chiavi.seriale,
		chiavi.id_account_proprietario,
		chiavi.id_gruppo_proprietario,
		chiavi.id_diritto_proprietario,
		chiavi.id_diritto_gruppo,
		chiavi.id_diritto_altri,
		chiavi.id_account_inserimento,
		chiavi.id_account_aggiornamento,
		chiavi.nome AS __label__
	FROM chiavi
		LEFT JOIN tipologie_chiavi ON tipologie_chiavi.id = chiavi.id_tipologia
		LEFT JOIN licenze ON licenze.id = chiavi.id_licenza
;

-- | 202611121272

-- badge_view
CREATE OR REPLACE VIEW `badge_view` AS
	SELECT
		badge.id,
		badge.id_tipologia,
		tipologie_badge.nome AS tipologia,
		badge.codice,
		badge.nome,
		badge.id_anagrafica,
		concat_ws(
			' ',
			anagrafica.codice,
			coalesce(
				anagrafica.soprannome,
				anagrafica.denominazione,
				concat_ws(' ', coalesce( anagrafica.cognome, ''),
				coalesce( anagrafica.nome, '') ),
				''
			)
		) AS anagrafica,
		badge.id_contratto,
		contratti.nome AS contratto,
		badge.rfid,
		badge.note,
		badge.id_account_proprietario,
		badge.id_gruppo_proprietario,
		badge.id_diritto_proprietario,
		badge.id_diritto_gruppo,
		badge.id_diritto_altri,
		badge.id_account_inserimento,
		badge.id_account_aggiornamento,
		concat_ws(
			' | ',
			lpad( badge.id, 8, 0),
			coalesce( badge.codice, badge.rfid, badge.nome ),
			if(
				badge.id_anagrafica IS NULL,
				'NON ASSEGNATO',
				concat_ws(
					' ',
					anagrafica.codice,
					coalesce(
						anagrafica.soprannome,
						anagrafica.denominazione,
						concat_ws(' ', coalesce( anagrafica.cognome, ''),
						coalesce( anagrafica.nome, '') ),
						''
					)
				)
			)
		) AS __label__
	FROM badge
		LEFT JOIN tipologie_badge ON tipologie_badge.id = badge.id_tipologia
		LEFT JOIN anagrafica ON anagrafica.id = badge.id_anagrafica
		LEFT JOIN contratti ON contratti.id = badge.id_contratto
;

-- | 202611121273

-- organizzazioni_view
CREATE OR REPLACE VIEW `organizzazioni_view` AS
	SELECT
		organizzazioni.id,
		organizzazioni.id_genitore,
		organizzazioni.ordine,
		organizzazioni.nome,
		organizzazioni.id_anagrafica,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		organizzazioni.note,
		organizzazioni.id_account_proprietario,
		organizzazioni.id_gruppo_proprietario,
		organizzazioni.id_diritto_proprietario,
		organizzazioni.id_diritto_gruppo,
		organizzazioni.id_diritto_altri,
		organizzazioni.id_account_inserimento,
		organizzazioni.id_account_aggiornamento,
		organizzazioni_path( organizzazioni.id ) AS __label__
	FROM organizzazioni
		LEFT JOIN anagrafica AS a1 ON a1.id = organizzazioni.id_anagrafica
;

-- | 202611121274

-- immobili_view
CREATE OR REPLACE VIEW immobili_view AS
	SELECT
		immobili.id,
		immobili.id_tipologia,
		tipologie_immobili.nome AS tipologia,
		immobili.codice,
		immobili.nome,
		immobili.id_edificio,
		edifici.id_indirizzo,
		concat_ws(
			' ',
			tipologie_indirizzi.nome,
			indirizzi.indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) AS indirizzo,
		immobili.scala,
		immobili.piano,
		immobili.interno,
		immobili.campanello,
		immobili.catasto_foglio,
		immobili.catasto_particella,
		immobili.catasto_sub,
		immobili.catasto_categoria,
		immobili.catasto_classe,
		immobili.catasto_consistenza,
		immobili.catasto_superficie,
		immobili.catasto_rendita,
		(
			SELECT group_concat( zone_path( zone_indirizzi.id_zona ) SEPARATOR ' | ' )
			FROM zone_indirizzi
			WHERE zone_indirizzi.id_indirizzo = indirizzi.id
		) AS zone,
		immobili.id_account_proprietario,
		immobili.id_gruppo_proprietario,
		immobili.id_diritto_proprietario,
		immobili.id_diritto_gruppo,
		immobili.id_diritto_altri,
		immobili.id_account_inserimento,
		immobili.id_account_aggiornamento,
		concat_ws(
			' ',
			tipologie_immobili.nome,
			coalesce( concat( 'scala ', immobili.scala ), '' ),
			coalesce( concat( 'piano ', immobili.piano ), '' ),
			coalesce( concat( 'int. ', immobili.interno ), '' ),
			tipologie_edifici.nome,
			edifici.nome,
			tipologie_indirizzi.nome,
			indirizzi.indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) AS __label__
	FROM immobili
		LEFT JOIN tipologie_immobili ON tipologie_immobili.id = immobili.id_tipologia
		LEFT JOIN edifici ON edifici.id = immobili.id_edificio
		LEFT JOIN tipologie_edifici ON tipologie_edifici.id = edifici.id_tipologia
		LEFT JOIN indirizzi ON indirizzi.id = edifici.id_indirizzo
		LEFT JOIN tipologie_indirizzi ON tipologie_indirizzi.id = indirizzi.id_tipologia
		LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
;

-- | 202611121275

-- edifici_view
CREATE OR REPLACE VIEW edifici_view AS
	SELECT
		edifici.id,
		edifici.id_genitore,
		edifici.id_tipologia,
		tipologie_edifici.nome AS tipologia,
		edifici.codice,
		edifici.nome,
		edifici.id_indirizzo,
		concat_ws(
			' ',
			tipologie_indirizzi.nome,
			indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) AS indirizzo,
		edifici.piani,
		edifici.id_account_proprietario,
		edifici.id_gruppo_proprietario,
		edifici.id_diritto_proprietario,
		edifici.id_diritto_gruppo,
		edifici.id_diritto_altri,
		edifici.id_account_inserimento,
		edifici.id_account_aggiornamento,
		concat_ws(
			' ',
			tipologie_edifici.nome,
			edifici_path( edifici.id ),
			tipologie_indirizzi.nome,
			indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) AS __label__
	FROM edifici
		LEFT JOIN tipologie_edifici ON tipologie_edifici.id = edifici.id_tipologia
		LEFT JOIN indirizzi ON indirizzi.id = edifici.id_indirizzo
		LEFT JOIN tipologie_indirizzi ON tipologie_indirizzi.id = indirizzi.id_tipologia
		LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
		LEFT JOIN regioni ON regioni.id = provincie.id_regione
		LEFT JOIN stati ON stati.id = regioni.id_stato
;

-- | 202611121276

-- vani_view
CREATE OR REPLACE VIEW vani_view AS
	SELECT
		vani.id,
		vani.id_tipologia,
		tipologie_vani.nome AS tipologia,
		vani.codice,
		vani.nome,
		vani.id_immobile,
		concat_ws(
			' ',
			tipologie_immobili.nome,
			immobili.codice,
			immobili.nome,
			coalesce( concat( 'scala ', immobili.scala ), '' ),
			coalesce( concat( 'piano ', immobili.piano ), '' ),
			coalesce( concat( 'int. ', immobili.interno ), '' ),
			edifici.nome
		) AS immobile,
		vani.superficie,
		vani.id_account_proprietario,
		vani.id_gruppo_proprietario,
		vani.id_diritto_proprietario,
		vani.id_diritto_gruppo,
		vani.id_diritto_altri,
		vani.id_account_inserimento,
		vani.id_account_aggiornamento,
		concat_ws(
			' ',
			tipologie_vani.nome,
			vani.nome,
			'/',
			tipologie_immobili.nome,
			immobili.codice,
			immobili.nome,
			edifici.nome
		) AS __label__
	FROM vani
		LEFT JOIN tipologie_vani ON tipologie_vani.id = vani.id_tipologia
		LEFT JOIN immobili ON immobili.id = vani.id_immobile
		LEFT JOIN tipologie_immobili ON tipologie_immobili.id = immobili.id_tipologia
		LEFT JOIN edifici ON edifici.id = immobili.id_edificio
;

-- | 202611121277

-- indirizzi_view
CREATE OR REPLACE VIEW indirizzi_view AS
	SELECT
		indirizzi.id,
		indirizzi.id_tipologia,
		tipologie_indirizzi.nome AS tipologia,
		indirizzi.id_comune,
		comuni.nome AS comune,
		comuni.id_provincia,
		provincie.nome AS provincia,
		provincie.id_regione,
		regioni.nome AS regione,
		regioni.id_stato,
		stati.nome AS stato,
		indirizzi.localita,
		indirizzi.indirizzo,
		indirizzi.civico,
		indirizzi.cap,
		indirizzi.latitudine,
		indirizzi.longitudine,
		indirizzi.token,
		indirizzi.timestamp_geolocalizzazione,
		indirizzi.id_zona,
		indirizzi.id_account_proprietario,
		indirizzi.id_gruppo_proprietario,
		indirizzi.id_diritto_proprietario,
		indirizzi.id_diritto_gruppo,
		indirizzi.id_diritto_altri,
		indirizzi.id_account_inserimento,
		indirizzi.id_account_aggiornamento,
		concat_ws(
			' ',
			tipologie_indirizzi.nome,
			indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) AS __label__
	FROM indirizzi
		LEFT JOIN tipologie_indirizzi ON tipologie_indirizzi.id = indirizzi.id_tipologia
		LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
		LEFT JOIN regioni ON regioni.id = provincie.id_regione
		LEFT JOIN stati ON stati.id = regioni.id_stato
;

-- | 202611121278

-- luoghi_view
CREATE OR REPLACE VIEW `luoghi_view` AS
	SELECT
		luoghi.id,
		luoghi.id_genitore,
		luoghi.id_tipologia,
		tipologie_luoghi_path( luoghi.id_tipologia ) AS tipologia,
		luoghi.nome,
		luoghi.id_indirizzo,
		concat_ws(
			' ',
			tipologie_indirizzi.nome,
			indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) AS indirizzo,
		luoghi.id_edificio,
		luoghi.id_immobile,
		luoghi.id_vano,
		luoghi.url,
		luoghi.id_account_proprietario,
		luoghi.id_gruppo_proprietario,
		luoghi.id_diritto_proprietario,
		luoghi.id_diritto_gruppo,
		luoghi.id_diritto_altri,
		luoghi.id_account_inserimento,
		luoghi.id_account_aggiornamento,
		luoghi_path( luoghi.id ) AS __label__
	FROM luoghi
		LEFT JOIN indirizzi ON indirizzi.id = luoghi.id_indirizzo
		LEFT JOIN tipologie_indirizzi ON tipologie_indirizzi.id = indirizzi.id_tipologia
		LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
;

-- | 202611121279

-- pagine_view
CREATE OR REPLACE VIEW pagine_view AS
	SELECT
		pagine.id,
		pagine.id_genitore,
		pagine.ordine,
		pagine.codice,
		pagine.nome,
		pagine.note,
		pagine.id_pagina_contenuti,
		pagine.template,
		pagine.schema_html,
		pagine.tema_css,
		pagine.se_sitemap,
		pagine.se_cacheable,
		pagine.id_sito,
		pagine.data_archiviazione,
		count( p1.id ) AS figli,
		pagine.id_account_proprietario,
		pagine.id_gruppo_proprietario,
		pagine.id_diritto_proprietario,
		pagine.id_diritto_gruppo,
		pagine.id_diritto_altri,
		pagine.id_account_inserimento,
		pagine.id_account_aggiornamento,
		pagine_path( pagine.id ) AS __label__
	FROM pagine
		LEFT JOIN pagine AS p1 ON p1.id_genitore = pagine.id
	GROUP BY pagine.id
;

-- | 202611121280

-- prodotti_view
CREATE OR REPLACE VIEW `prodotti_view` AS
	SELECT
		-- PUBBLICAZIONE: SOTTOQUERY, NON JOIN ( 22/10/2026 )
		--
		-- prima era una LEFT JOIN su pubblicazioni: un prodotto con piu' pubblicazioni usciva una volta per
		-- pubblicazione ( su utensilerialughese cinque righe doppie ). Si prende la prima pubblicazione del
		-- prodotto, come in articoli_view, la prima nell'ordine.
		( SELECT pp.id_tipologia FROM pubblicazioni AS pp WHERE pp.id_prodotto = prodotti.id ORDER BY pp.ordine IS NULL, pp.ordine, pp.id LIMIT 1 ) AS id_tipologia_pubblicazione,
		( SELECT tp.nome FROM tipologie_pubblicazioni AS tp WHERE tp.id = (
				SELECT pp.id_tipologia FROM pubblicazioni AS pp WHERE pp.id_prodotto = prodotti.id ORDER BY pp.ordine IS NULL, pp.ordine, pp.id LIMIT 1
			) ) AS pubblicazione,
		prodotti.id,
		prodotti.id_tipologia,
		tipologie_prodotti.nome AS tipologia,
		tipologie_prodotti.se_prodotto,
		tipologie_prodotti.se_servizio,
		prodotti.codice,
		prodotti.nome,
		prodotti.id_marchio,
		marchi.nome AS marchio,
		prodotti.id_produttore,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS produttore,
		prodotti.codice_produttore,
		prodotti.note,
		prodotti.note_codifica,
		-- SOTTOQUERY E NON JOIN PIU' GROUP BY: vedi la nota in articoli_view. Misurato
		-- l'08/09/2026: SELECT * ... WHERE id = ? da 0,81 secondi a 0,011, un elenco di venti
		-- righe da 0,74 a 0,017.
		coalesce( ( SELECT group_concat( DISTINCT categorie_prodotti_path( pc.id_categoria ) SEPARATOR ' | ' )
			FROM prodotti_categorie AS pc
		   WHERE pc.id_prodotto = prodotti.id
		), '' ) AS categorie,
		prodotti.template,
		prodotti.schema_html,
		prodotti.tema_css,
		prodotti.se_sitemap,
		prodotti.se_cacheable,
		prodotti.id_sito,
		prodotti.id_pagina,
		prodotti.data_archiviazione,
		prodotti.id_account_proprietario,
		prodotti.id_gruppo_proprietario,
		prodotti.id_diritto_proprietario,
		prodotti.id_diritto_gruppo,
		prodotti.id_diritto_altri,
		prodotti.id_account_inserimento,
		prodotti.id_account_aggiornamento,
		concat_ws(
			' ',
			prodotti.codice,
			prodotti.nome
		) AS __label__
	FROM prodotti
		LEFT JOIN tipologie_prodotti ON tipologie_prodotti.id = prodotti.id_tipologia
		LEFT JOIN marchi ON marchi.id = prodotti.id_marchio
		LEFT JOIN anagrafica AS a1 ON a1.id = prodotti.id_produttore
;

-- | 202611121281

-- articoli_view
CREATE OR REPLACE VIEW `articoli_view` AS
	SELECT
		-- PUBBLICAZIONE: SOTTOQUERY, NON JOIN ( 2026-10-04 )
		--
		-- prima erano due LEFT JOIN su pubblicazioni ( dell'articolo e del prodotto ): un articolo con
		-- piu' pubblicazioni usciva una volta per pubblicazione, e su glisweb la vista dava 7.920 righe
		-- per 132 articoli. La statica, che ha id come chiave primaria, non si riusciva piu' a
		-- riempire. Si prende la prima pubblicazione dell'articolo, se no la prima del prodotto; la prima e' quella
		-- che viene prima nell'ordine ( punto 6e ), su qualunque sito.
		coalesce(
			( SELECT pa.id_tipologia FROM pubblicazioni AS pa WHERE pa.id_articolo = articoli.id ORDER BY pa.ordine IS NULL, pa.ordine, pa.id LIMIT 1 ),
			( SELECT pp.id_tipologia FROM pubblicazioni AS pp WHERE pp.id_prodotto = articoli.id_prodotto ORDER BY pp.ordine IS NULL, pp.ordine, pp.id LIMIT 1 )
		) AS id_tipologia_pubblicazione,
		( SELECT tp.nome FROM tipologie_pubblicazioni AS tp WHERE tp.id = coalesce(
				( SELECT pa.id_tipologia FROM pubblicazioni AS pa WHERE pa.id_articolo = articoli.id ORDER BY pa.ordine IS NULL, pa.ordine, pa.id LIMIT 1 ),
				( SELECT pp.id_tipologia FROM pubblicazioni AS pp WHERE pp.id_prodotto = articoli.id_prodotto ORDER BY pp.ordine IS NULL, pp.ordine, pp.id LIMIT 1 )
			) ) AS pubblicazione,
		-- TIPOLOGIA DI VOCE A LISTINO: SOTTOQUERY, NON JOIN
		--
		-- prima erano tre LEFT JOIN su articoli_caratteristiche piu' un max( CASE ... ) sotto il
		-- GROUP BY. Funziona, ma moltiplica le righe per le caratteristiche di ogni articolo, e
		-- quando quella tabella si riempie la vista non si regge piu': l'08/09/2026, con le 7.580
		-- righe arrivate dalla migrazione del catalogo, la vista e' passata da meno di un secondo
		-- a cinque. La sottoquery scalare da' lo stesso valore e non tocca la cardinalita'
		( SELECT tipo_voce.nome
			FROM articoli_caratteristiche AS ac_tipo
			INNER JOIN caratteristiche_prodotti AS tipo_voce ON tipo_voce.id = ac_tipo.id_caratteristica
			INNER JOIN caratteristiche_prodotti AS radice_tipo ON radice_tipo.id = tipo_voce.id_genitore
			WHERE ac_tipo.id_articolo = articoli.id
			AND radice_tipo.nome = 'TIPO DI VOCE A LISTINO'
			LIMIT 1
		) AS tipologia_listino,
		articoli.id,
		articoli.codice,
		articoli.id_prodotto,
		prodotti.nome AS prodotto,
		articoli.ordine,
		articoli.ean,
		articoli.isbn,
		articoli.codice_produttore,
		articoli.id_reparto,
		articoli.id_taglia,
		articoli.id_colore,
		articoli.id_periodicita,
		periodicita.nome AS periodicita,
		articoli.id_tipologia_rinnovo,
		tipologie_rinnovi.nome AS tipologia_rinnovo,
		articoli.larghezza,
		articoli.lunghezza,
		articoli.altezza,
		articoli.id_udm_dimensioni,
		udm_dimensioni.sigla AS udm_dimensioni,
		articoli.peso,
		articoli.id_udm_peso,
		udm_peso.sigla AS udm_peso,
		articoli.volume,
		articoli.id_udm_volume,
		udm_volume.sigla AS udm_volume,
		articoli.capacita,
		articoli.id_udm_capacita,
		udm_capacita.sigla AS udm_capacita,
		articoli.durata,
		articoli.id_udm_durata,
		udm_durata.sigla AS udm_durata,
		concat_ws(
			' ',
			prodotti.nome,
			nullif( articoli.nome, prodotti.nome ),
			coalesce(
				concat(
					concat_ws( 'x', articoli.larghezza, articoli.lunghezza, articoli.altezza ),
					udm_dimensioni.sigla
				),
				concat(
					articoli.peso,
					udm_peso.sigla
				),
				concat(
					articoli.volume,
					udm_volume.sigla
				),
				concat(
					articoli.capacita,
					udm_capacita.sigla
				),
				concat(
					articoli.durata,
					udm_durata.sigla
				),
				''
			)
		) AS nome,
		articoli.note,
		articoli.note_codifica,
		-- CATEGORIE E PREZZI: SOTTOQUERY, NON JOIN PIU' GROUP BY
		--
		-- stessa ragione della sottoquery di tipologia_listino qui sopra, ma il guasto era peggiore:
		-- il GROUP BY impedisce all'ottimizzatore di spingere dentro la vista una condizione
		-- espressa con un SEGNAPOSTO, e il framework interroga sempre con statement preparati.
		-- Misurato l'08/09/2026: SELECT * ... WHERE id = ? passava da 2,36 secondi a 0,032, e un
		-- elenco di venti righe da 2,76 a 0,26 - perche' categorie_prodotti_path(), che e' una
		-- funzione ricorsiva, adesso viene chiamata solo per le righe che si mostrano davvero e
		-- non per tutte quelle della vista.
		--
		-- il coalesce a stringa vuota NON e' pignoleria: con la LEFT JOIN un articolo senza
		-- categorie dava '' e non NULL, perche' categorie_prodotti_path( NULL ) torna '' e il
		-- group_concat trovava comunque una riga. id_categorie invece resta NULL come prima.
		( SELECT group_concat( DISTINCT pc.id_categoria SEPARATOR ' | ' )
			FROM prodotti_categorie AS pc
			WHERE pc.id_prodotto = articoli.id_prodotto
		) AS id_categorie,
		coalesce( ( SELECT group_concat( DISTINCT categorie_prodotti_path( pc.id_categoria ) SEPARATOR ' | ' )
			FROM prodotti_categorie AS pc
			WHERE pc.id_prodotto = articoli.id_prodotto
		), '' ) AS categorie,
		coalesce( ( SELECT group_concat( DISTINCT concat_ws( ' ', l.nome, v.iso4217, format( p.prezzo, 2, 'it_IT' ) ) SEPARATOR ' | ' )
			FROM prezzi AS p
			LEFT JOIN listini AS l ON l.id = p.id_listino
			LEFT JOIN valute AS v ON v.id = l.id_valuta
			WHERE p.id_articolo = articoli.id
		), '' ) AS prezzi,
		coalesce( articoli.data_archiviazione, prodotti.data_archiviazione ) AS data_archiviazione,
		articoli.note_archiviazione,
		articoli.id_account_proprietario,                     --
		articoli.id_gruppo_proprietario,                      --
		articoli.id_diritto_proprietario,                     --
		articoli.id_diritto_gruppo,                           --
		articoli.id_diritto_altri,                            --
		articoli.id_account_inserimento,                      --
		articoli.timestamp_inserimento,                       --
		articoli.id_account_aggiornamento,                    --
		articoli.timestamp_aggiornamento,                     --
		concat_ws(
			' ',
			articoli.ean,
			articoli.codice,
			'/',
			prodotti.nome,
			nullif( articoli.nome, prodotti.nome ),
			coalesce(
				concat(
					articoli.larghezza, 'x', articoli.lunghezza, 'x', articoli.altezza,
					udm_dimensioni.sigla
				),
				concat(
					articoli.peso,
					udm_peso.sigla
				),
				concat(
					articoli.volume,
					udm_volume.sigla
				),
				concat(
					articoli.capacita,
					udm_capacita.sigla
				),
				concat(
					articoli.durata,
					udm_durata.sigla
				),
				''
			)
		) AS __label__
	FROM articoli
		LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
		LEFT JOIN udm AS udm_dimensioni ON udm_dimensioni.id = articoli.id_udm_dimensioni
		LEFT JOIN udm AS udm_peso ON udm_peso.id = articoli.id_udm_peso
		LEFT JOIN udm AS udm_volume ON udm_volume.id = articoli.id_udm_volume
		LEFT JOIN udm AS udm_capacita ON udm_capacita.id = articoli.id_udm_capacita
		LEFT JOIN udm AS udm_durata ON udm_durata.id = articoli.id_udm_durata
		LEFT JOIN periodicita ON periodicita.id = articoli.id_periodicita
		LEFT JOIN tipologie_rinnovi ON tipologie_rinnovi.id = articoli.id_tipologia_rinnovo
;

-- | 202611121282

-- marchi_view
CREATE OR REPLACE VIEW `marchi_view` AS
	SELECT
		marchi.id,
		marchi.nome,
		marchi.id_produttore,
		produttori.denominazione AS produttore,
		marchi.note,
		marchi.template,
		marchi.schema_html,
		marchi.tema_css,
		marchi.se_sitemap,
		marchi.se_cacheable,
		marchi.id_sito,
		marchi.id_pagina,
		marchi.data_archiviazione,
		marchi.id_account_proprietario,
		marchi.id_gruppo_proprietario,
		marchi.id_diritto_proprietario,
		marchi.id_diritto_gruppo,
		marchi.id_diritto_altri,
		marchi.id_account_inserimento,
		marchi.id_account_aggiornamento,
		marchi.nome AS __label__
	FROM marchi
		LEFT JOIN anagrafica AS produttori ON produttori.id = marchi.id_produttore
;

-- | 202611121283

-- notizie_view
CREATE OR REPLACE VIEW `notizie_view` AS
	SELECT
		notizie.id,
		notizie.id_tipologia,
		tipologie_notizie.nome AS tipologia,
		notizie.nome,
		group_concat( categorie_notizie.nome SEPARATOR '|' ) AS categorie,
		notizie.note,
		notizie.template,
		notizie.schema_html,
		notizie.tema_css,
		notizie.se_sitemap,
		notizie.se_cacheable,
		notizie.id_sito,
		notizie.id_pagina,
		notizie.data_archiviazione,
		notizie.id_account_proprietario,
		notizie.id_gruppo_proprietario,
		notizie.id_diritto_proprietario,
		notizie.id_diritto_gruppo,
		notizie.id_diritto_altri,
		notizie.id_account_inserimento,
		notizie.id_account_aggiornamento,
		notizie.nome AS __label__
	FROM notizie
		LEFT JOIN tipologie_notizie ON tipologie_notizie.id = notizie.id_tipologia
		LEFT JOIN notizie_categorie ON notizie_categorie.id_notizia = notizie.id
		LEFT JOIN categorie_notizie ON categorie_notizie.id = notizie_categorie.id_categoria
	GROUP BY notizie.id
;

-- | 202611121284

-- annunci_view
CREATE OR REPLACE VIEW `annunci_view` AS
	SELECT
		annunci.id,
		annunci.id_tipologia,
		-- tipologie_annunci.nome AS tipologia, ...
		annunci.nome,
		group_concat( categorie_annunci.nome SEPARATOR '|' ) AS categorie,
		annunci.id_account_proprietario,
		annunci.id_gruppo_proprietario,
		annunci.id_diritto_proprietario,
		annunci.id_diritto_gruppo,
		annunci.id_diritto_altri,
		annunci.id_account_inserimento,
		annunci.id_account_aggiornamento,
		annunci.nome AS __label__
	FROM annunci
		-- LEFT JOIN tipologie_annunci ON tipologie_annunci.id = annunci.id_tipologia
		LEFT JOIN annunci_categorie ON annunci_categorie.id_annuncio = annunci.id
		LEFT JOIN categorie_annunci ON categorie_annunci.id = annunci_categorie.id_categoria
	GROUP BY annunci.id
;

-- | 202611121285

-- risorse_view
CREATE OR REPLACE VIEW `risorse_view` AS
	SELECT
		risorse.id,
		risorse.id_tipologia,
		tipologie_risorse.nome AS tipologia,
		risorse.codice,
		risorse.nome,
		risorse.id_prodotto,
		risorse.id_articolo,
		risorse.id_testata,
		testate.nome AS testata,
		group_concat( DISTINCT categorie_risorse_path( categorie_risorse.id ) SEPARATOR ' | ' ) AS categorie,
		risorse.note,
		risorse.giorno_pubblicazione,
		risorse.mese_pubblicazione,
		risorse.anno_pubblicazione,
		risorse.template,
		risorse.schema_html,
		risorse.tema_css,
		risorse.se_sitemap,
		risorse.se_cacheable,
		risorse.id_sito,
		risorse.id_pagina,
		risorse.data_archiviazione,
		risorse.id_account_proprietario,
		risorse.id_gruppo_proprietario,
		risorse.id_diritto_proprietario,
		risorse.id_diritto_gruppo,
		risorse.id_diritto_altri,
		risorse.id_account_inserimento,
		risorse.id_account_aggiornamento,
		concat_ws(
			' ',
			risorse.codice,
			risorse.nome
		) AS __label__
	FROM risorse
		LEFT JOIN tipologie_risorse ON tipologie_risorse.id = risorse.id_tipologia
		LEFT JOIN testate ON testate.id = risorse.id_testata
		LEFT JOIN risorse_categorie ON risorse_categorie.id_risorsa = risorse.id
		LEFT JOIN categorie_risorse ON categorie_risorse.id = risorse_categorie.id_categoria
	GROUP BY risorse.id
;

-- | FINE
