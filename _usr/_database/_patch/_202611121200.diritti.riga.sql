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
-- anagrafica, articoli, attivita, documenti e todo; ricrea le 38 viste, tranne le 17 che chiamano funzioni di
-- _070000999999.procedures.sql, che restano al ricaricamento dei file base ( 24/11, vedi la 202611121259 ).
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
-- spostata alla 202611121287 ( 24/11 ): qui la procedura delle statiche su un deploy poteva non esserci ancora ( www2 di bernispa:
-- prima 1146 sulla statica mancante, poi 1305 sulla procedura ); un blocco di soli commenti non si applica e non si registra

-- | 202611121244

-- articoli_view_static: le colonne nuove della vista, allo stesso posto; prima le colonne del canone che la statica
-- potesse non avere ancora, ciascuna dopo la sua precedente, perche' il posto lo chiede REPLACE ... SELECT * ( 12/11:
-- glistest non aveva note_archiviazione e l'AFTER si fermava ); dove ci sono gia', IF NOT EXISTS non fa niente
-- spostata alla 202611121288 ( 24/11 ): qui la procedura delle statiche su un deploy poteva non esserci ancora ( www2 di bernispa:
-- prima 1146 sulla statica mancante, poi 1305 sulla procedura ); un blocco di soli commenti non si applica e non si registra

-- | 202611121245

-- attivita_view_static: le colonne nuove della vista, allo stesso posto; prima le colonne del canone che la statica
-- potesse non avere ancora, ciascuna dopo la sua precedente, perche' il posto lo chiede REPLACE ... SELECT * ( 12/11:
-- glistest non aveva note_archiviazione e l'AFTER si fermava ); dove ci sono gia', IF NOT EXISTS non fa niente
-- spostata alla 202611121289 ( 24/11 ): qui la procedura delle statiche su un deploy poteva non esserci ancora ( www2 di bernispa:
-- prima 1146 sulla statica mancante, poi 1305 sulla procedura ); un blocco di soli commenti non si applica e non si registra

-- | 202611121246

-- documenti_view_static: le colonne nuove della vista, allo stesso posto; prima le colonne del canone che la statica
-- potesse non avere ancora, ciascuna dopo la sua precedente, perche' il posto lo chiede REPLACE ... SELECT * ( 12/11:
-- glistest non aveva note_archiviazione e l'AFTER si fermava ); dove ci sono gia', IF NOT EXISTS non fa niente
-- spostata alla 202611121290 ( 24/11 ): qui la procedura delle statiche su un deploy poteva non esserci ancora ( www2 di bernispa:
-- prima 1146 sulla statica mancante, poi 1305 sulla procedura ); un blocco di soli commenti non si applica e non si registra

-- | 202611121247

-- todo_view_static: le colonne nuove della vista, allo stesso posto; prima le colonne del canone che la statica
-- potesse non avere ancora, ciascuna dopo la sua precedente, perche' il posto lo chiede REPLACE ... SELECT * ( 12/11:
-- glistest non aveva note_archiviazione e l'AFTER si fermava ); dove ci sono gia', IF NOT EXISTS non fa niente
-- spostata alla 202611121291 ( 24/11 ): qui la procedura delle statiche su un deploy poteva non esserci ancora ( www2 di bernispa:
-- prima 1146 sulla statica mancante, poi 1305 sulla procedura ); un blocco di soli commenti non si applica e non si registra

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
-- spostata al ricaricamento dei file base ( 24/11 ): la vista chiama funzioni di _070000999999.procedures.sql, che su
-- un deploy potevano non esserci ancora ( www2 di bernispa: 1305 su tipologie_campagne_path nella 1259 ); mysqlPatchReload
-- ricarica prima le procedure e poi _090000999999.views.sql, che ha la stessa vista; un blocco di soli commenti non si
-- applica e non si registra

-- | 202611121250

-- todo_view
CREATE OR REPLACE VIEW `todo_view` AS select `todo`.`id` AS `id`,`todo`.`id_tipologia` AS `id_tipologia`,`tipologie_todo`.`nome` AS `tipologia`,`tipologie_todo`.`se_agenda` AS `se_agenda`,`todo`.`codice` AS `codice`,`todo`.`nome` AS `nome`,`todo`.`id_anagrafica` AS `id_anagrafica`,coalesce(`a1`.`denominazione`,concat(`a1`.`cognome`,' ',`a1`.`nome`),'') AS `anagrafica`,`todo`.`id_cliente` AS `id_cliente`,coalesce(`a2`.`denominazione`,concat(`a2`.`cognome`,' ',`a2`.`nome`),'') AS `cliente`,`todo`.`id_contatto` AS `id_contatto`,`todo`.`id_indirizzo` AS `id_indirizzo`,concat_ws(' ',`indirizzi`.`indirizzo`,`indirizzi`.`civico`,`indirizzi`.`cap`,`indirizzi`.`localita`,`comuni`.`nome`,`provincie`.`sigla`) AS `indirizzo`,`todo`.`id_luogo` AS `id_luogo`,`luoghi_path`(`todo`.`id_luogo`) AS `luogo`,`todo`.`id_progetto` AS `id_progetto`,`progetti`.`nome` AS `progetto`,group_concat(distinct if(`d`.`id`,`categorie_progetti_path`(`d`.`id`),NULL) separator ' | ') AS `discipline`,`todo`.`id_pianificazione` AS `id_pianificazione`,`todo`.`id_immobile` AS `id_immobile`,`todo`.`id_documento` AS `id_documento`,concat(`tipologie_documenti`.`sigla`,' ',concat_ws('/',`documenti`.`numero`,`documenti`.`sezionale`),' del ',`documenti`.`data`) AS `documento`,`todo`.`id_documenti_articoli` AS `id_documenti_articoli`,if(`documenti_articoli`.`id` is null,NULL,concat_ws(' / ',coalesce(`documenti_articoli`.`data`,`documenti_righe`.`data`),`tipologie_documenti_articoli`.`sigla`,concat(`documenti_articoli`.`quantita`,' x ',`documenti_articoli`.`id_articolo`))) AS `documenti_articoli`,`todo`.`id_istruzione` AS `id_istruzione`,concat(`istruzioni`.`id_tipologia`,coalesce(`istruzioni`.`id_prodotto`,`istruzioni`.`id_articolo`),`istruzioni`.`nome`) AS `istruzione`,`todo`.`timestamp_apertura` AS `timestamp_apertura`,`todo`.`data_scadenza` AS `data_scadenza`,`todo`.`ora_scadenza` AS `ora_scadenza`,`todo`.`data_programmazione` AS `data_programmazione`,`todo`.`ora_inizio_programmazione` AS `ora_inizio_programmazione`,`todo`.`ora_fine_programmazione` AS `ora_fine_programmazione`,`todo`.`anno_programmazione` AS `anno_programmazione`,`todo`.`settimana_programmazione` AS `settimana_programmazione`,`todo`.`ore_programmazione` AS `ore_programmazione`,`todo`.`data_chiusura` AS `data_chiusura`,`todo`.`data_archiviazione` AS `data_archiviazione`,`todo`.`id_account_proprietario` AS `id_account_proprietario`,`todo`.`id_gruppo_proprietario` AS `id_gruppo_proprietario`,`todo`.`id_diritto_proprietario` AS `id_diritto_proprietario`,`todo`.`id_diritto_gruppo` AS `id_diritto_gruppo`,`todo`.`id_diritto_altri` AS `id_diritto_altri`,`todo`.`id_account_inserimento` AS `id_account_inserimento`,`todo`.`id_account_aggiornamento` AS `id_account_aggiornamento`,concat(coalesce(`todo`.`nome`,`tipologie_todo`.`nome`),coalesce(concat(' per ',coalesce(`a2`.`denominazione`,concat(`a2`.`cognome`,' ',`a2`.`nome`))),''),coalesce(concat(' su ',`todo`.`id_progetto`,' ',`progetti`.`nome`),'')) AS `__label__` from (((((((((((((((`todo` left join `anagrafica` `a1` on(`a1`.`id` = `todo`.`id_anagrafica`)) left join `anagrafica` `a2` on(`a2`.`id` = `todo`.`id_cliente`)) left join `indirizzi` on(`indirizzi`.`id` = `todo`.`id_indirizzo`)) left join `comuni` on(`comuni`.`id` = `indirizzi`.`id_comune`)) left join `provincie` on(`provincie`.`id` = `comuni`.`id_provincia`)) left join `tipologie_todo` on(`tipologie_todo`.`id` = `todo`.`id_tipologia`)) left join `progetti` on(`progetti`.`id` = `todo`.`id_progetto`)) left join `progetti_categorie` on(`progetti_categorie`.`id_progetto` = `progetti`.`id`)) left join `categorie_progetti` `d` on(`d`.`id` = `progetti_categorie`.`id_categoria` and `d`.`se_disciplina` = 1)) left join `documenti` on(`documenti`.`id` = `todo`.`id_documento`)) left join `tipologie_documenti` on(`tipologie_documenti`.`id` = `documenti`.`id_tipologia`)) left join `documenti_articoli` on(`documenti_articoli`.`id` = `todo`.`id_documenti_articoli`)) left join `documenti` `documenti_righe` on(`documenti_righe`.`id` = `documenti_articoli`.`id_documento`)) left join `tipologie_documenti` `tipologie_documenti_articoli` on(`tipologie_documenti_articoli`.`id` = coalesce(`documenti_articoli`.`id_tipologia_documento`,`documenti_righe`.`id_tipologia`))) left join `istruzioni` on(`istruzioni`.`id` = `todo`.`id_istruzione`)) group by `todo`.`id`
;

-- | 202611121251

-- progetti_view
-- spostata al ricaricamento dei file base ( 24/11 ): la vista chiama funzioni di _070000999999.procedures.sql, che su
-- un deploy potevano non esserci ancora ( www2 di bernispa: 1305 su tipologie_campagne_path nella 1259 ); mysqlPatchReload
-- ricarica prima le procedure e poi _090000999999.views.sql, che ha la stessa vista; un blocco di soli commenti non si
-- applica e non si registra

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
--	WHERE
--		tipologie_documenti.se_fattura = 1
--		OR
--		tipologie_documenti.se_nota_credito = 1
--		OR
--		tipologie_documenti.se_ricevuta = 1
--		OR
--		tipologie_documenti.se_pro_forma = 1
-- spostata al ricaricamento dei file base ( 24/11 ): la vista chiama funzioni di _070000999999.procedures.sql, che su
-- un deploy potevano non esserci ancora ( www2 di bernispa: 1305 su tipologie_campagne_path nella 1259 ); mysqlPatchReload
-- ricarica prima le procedure e poi _090000999999.views.sql, che ha la stessa vista; un blocco di soli commenti non si
-- applica e non si registra

-- | 202611121255

-- crediti_view
-- spostata al ricaricamento dei file base ( 24/11 ): la vista chiama funzioni di _070000999999.procedures.sql, che su
-- un deploy potevano non esserci ancora ( www2 di bernispa: 1305 su tipologie_campagne_path nella 1259 ); mysqlPatchReload
-- ricarica prima le procedure e poi _090000999999.views.sql, che ha la stessa vista; un blocco di soli commenti non si
-- applica e non si registra

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
-- spostata al ricaricamento dei file base ( 24/11 ): la vista chiama funzioni di _070000999999.procedures.sql, che su
-- un deploy potevano non esserci ancora ( www2 di bernispa: 1305 su tipologie_campagne_path nella 1259 ); mysqlPatchReload
-- ricarica prima le procedure e poi _090000999999.views.sql, che ha la stessa vista; un blocco di soli commenti non si
-- applica e non si registra

-- | 202611121259

-- campagne_view
-- spostata al ricaricamento dei file base ( 24/11 ): la vista chiama funzioni di _070000999999.procedures.sql, che su
-- un deploy potevano non esserci ancora ( www2 di bernispa: 1305 su tipologie_campagne_path nella 1259 ); mysqlPatchReload
-- ricarica prima le procedure e poi _090000999999.views.sql, che ha la stessa vista; un blocco di soli commenti non si
-- applica e non si registra

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
-- spostata al ricaricamento dei file base ( 24/11 ): la vista chiama funzioni di _070000999999.procedures.sql, che su
-- un deploy potevano non esserci ancora ( www2 di bernispa: 1305 su tipologie_campagne_path nella 1259 ); mysqlPatchReload
-- ricarica prima le procedure e poi _090000999999.views.sql, che ha la stessa vista; un blocco di soli commenti non si
-- applica e non si registra

-- | 202611121266

-- asset_view
-- spostata al ricaricamento dei file base ( 24/11 ): la vista chiama funzioni di _070000999999.procedures.sql, che su
-- un deploy potevano non esserci ancora ( www2 di bernispa: 1305 su tipologie_campagne_path nella 1259 ); mysqlPatchReload
-- ricarica prima le procedure e poi _090000999999.views.sql, che ha la stessa vista; un blocco di soli commenti non si
-- applica e non si registra

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
-- spostata al ricaricamento dei file base ( 24/11 ): la vista chiama funzioni di _070000999999.procedures.sql, che su
-- un deploy potevano non esserci ancora ( www2 di bernispa: 1305 su tipologie_campagne_path nella 1259 ); mysqlPatchReload
-- ricarica prima le procedure e poi _090000999999.views.sql, che ha la stessa vista; un blocco di soli commenti non si
-- applica e non si registra

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
-- spostata al ricaricamento dei file base ( 24/11 ): la vista chiama funzioni di _070000999999.procedures.sql, che su
-- un deploy potevano non esserci ancora ( www2 di bernispa: 1305 su tipologie_campagne_path nella 1259 ); mysqlPatchReload
-- ricarica prima le procedure e poi _090000999999.views.sql, che ha la stessa vista; un blocco di soli commenti non si
-- applica e non si registra

-- | 202611121274

-- immobili_view
-- spostata al ricaricamento dei file base ( 24/11 ): la vista chiama funzioni di _070000999999.procedures.sql, che su
-- un deploy potevano non esserci ancora ( www2 di bernispa: 1305 su tipologie_campagne_path nella 1259 ); mysqlPatchReload
-- ricarica prima le procedure e poi _090000999999.views.sql, che ha la stessa vista; un blocco di soli commenti non si
-- applica e non si registra

-- | 202611121275

-- edifici_view
-- spostata al ricaricamento dei file base ( 24/11 ): la vista chiama funzioni di _070000999999.procedures.sql, che su
-- un deploy potevano non esserci ancora ( www2 di bernispa: 1305 su tipologie_campagne_path nella 1259 ); mysqlPatchReload
-- ricarica prima le procedure e poi _090000999999.views.sql, che ha la stessa vista; un blocco di soli commenti non si
-- applica e non si registra

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
-- spostata al ricaricamento dei file base ( 24/11 ): la vista chiama funzioni di _070000999999.procedures.sql, che su
-- un deploy potevano non esserci ancora ( www2 di bernispa: 1305 su tipologie_campagne_path nella 1259 ); mysqlPatchReload
-- ricarica prima le procedure e poi _090000999999.views.sql, che ha la stessa vista; un blocco di soli commenti non si
-- applica e non si registra

-- | 202611121279

-- pagine_view
-- spostata al ricaricamento dei file base ( 24/11 ): la vista chiama funzioni di _070000999999.procedures.sql, che su
-- un deploy potevano non esserci ancora ( www2 di bernispa: 1305 su tipologie_campagne_path nella 1259 ); mysqlPatchReload
-- ricarica prima le procedure e poi _090000999999.views.sql, che ha la stessa vista; un blocco di soli commenti non si
-- applica e non si registra

-- | 202611121280

-- prodotti_view
-- spostata al ricaricamento dei file base ( 24/11 ): la vista chiama funzioni di _070000999999.procedures.sql, che su
-- un deploy potevano non esserci ancora ( www2 di bernispa: 1305 su tipologie_campagne_path nella 1259 ); mysqlPatchReload
-- ricarica prima le procedure e poi _090000999999.views.sql, che ha la stessa vista; un blocco di soli commenti non si
-- applica e non si registra

-- | 202611121281

-- articoli_view
-- spostata al ricaricamento dei file base ( 24/11 ): la vista chiama funzioni di _070000999999.procedures.sql, che su
-- un deploy potevano non esserci ancora ( www2 di bernispa: 1305 su tipologie_campagne_path nella 1259 ); mysqlPatchReload
-- ricarica prima le procedure e poi _090000999999.views.sql, che ha la stessa vista; un blocco di soli commenti non si
-- applica e non si registra

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
-- spostata al ricaricamento dei file base ( 24/11 ): la vista chiama funzioni di _070000999999.procedures.sql, che su
-- un deploy potevano non esserci ancora ( www2 di bernispa: 1305 su tipologie_campagne_path nella 1259 ); mysqlPatchReload
-- ricarica prima le procedure e poi _090000999999.views.sql, che ha la stessa vista; un blocco di soli commenti non si
-- applica e non si registra

-- | 202611121286

-- le statiche delle 1287-1291 passano dalla procedura, che qui si crea: la 202610041000 non c'e' sui database nati dai
-- file base, che non la contengono ( 24/11: www2 di bernispa si fermava con 1305 )
-- la procedura che, se la statica c'e', prova un'istruzione e, se fallisce, lo annota invece di fermare la coda
CREATE OR REPLACE PROCEDURE `__patch_statiche_forma__`( IN tabella VARCHAR(64), IN istruzione LONGTEXT )
BEGIN

    DECLARE messaggio TEXT DEFAULT NULL;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1 messaggio = MESSAGE_TEXT;
        END;

    IF EXISTS ( SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = tabella ) THEN

        SET @statiche_forma_sql = istruzione;
        PREPARE prova FROM @statiche_forma_sql;
        IF messaggio IS NULL THEN
            EXECUTE prova;
            DEALLOCATE PREPARE prova;
        END IF;

        IF messaggio IS NOT NULL THEN
            SET @statiche_forma_note = CONCAT_WS( '\n', @statiche_forma_note, CONCAT( tabella, ': ', messaggio ) );
        END IF;

    END IF;

END;

-- | 202611121287

-- anagrafica_view_static: le colonne nuove della vista, allo stesso posto
-- la statica passa dalla procedura delle statiche, creata qui sopra nella 202611121286: dove su un deploy non c'e' si salta
CALL `__patch_statiche_forma__`( 'anagrafica_view_static', 'ALTER TABLE `anagrafica_view_static`
	ADD COLUMN IF NOT EXISTS `id_account_proprietario` bigint(20) DEFAULT NULL AFTER `data_archiviazione`,
	ADD COLUMN IF NOT EXISTS `id_gruppo_proprietario` bigint(20) DEFAULT NULL AFTER `id_account_proprietario`,
	ADD COLUMN IF NOT EXISTS `id_diritto_proprietario` bigint(20) DEFAULT NULL AFTER `id_gruppo_proprietario`,
	ADD COLUMN IF NOT EXISTS `id_diritto_gruppo` bigint(20) DEFAULT NULL AFTER `id_diritto_proprietario`,
	ADD COLUMN IF NOT EXISTS `id_diritto_altri` bigint(20) DEFAULT NULL AFTER `id_diritto_gruppo`' );

-- | 202611121288

-- articoli_view_static: le colonne nuove della vista, allo stesso posto; prima le colonne del canone che la statica
-- potesse non avere ancora, ciascuna dopo la sua precedente, perche' il posto lo chiede REPLACE ... SELECT * ( 12/11:
-- glistest non aveva note_archiviazione e l'AFTER si fermava ); dove ci sono gia', IF NOT EXISTS non fa niente
-- la statica passa dalla procedura delle statiche, creata qui sopra nella 202611121286: dove su un deploy non c'e' si salta
CALL `__patch_statiche_forma__`( 'articoli_view_static', 'ALTER TABLE `articoli_view_static`
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
	ADD COLUMN IF NOT EXISTS `__label__` text AFTER `timestamp_aggiornamento`' );

-- | 202611121289

-- attivita_view_static: le colonne nuove della vista, allo stesso posto; prima le colonne del canone che la statica
-- potesse non avere ancora, ciascuna dopo la sua precedente, perche' il posto lo chiede REPLACE ... SELECT * ( 12/11:
-- glistest non aveva note_archiviazione e l'AFTER si fermava ); dove ci sono gia', IF NOT EXISTS non fa niente
-- la statica passa dalla procedura delle statiche, creata qui sopra nella 202611121286: dove su un deploy non c'e' si salta
CALL `__patch_statiche_forma__`( 'attivita_view_static', 'ALTER TABLE `attivita_view_static`
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
	ADD COLUMN IF NOT EXISTS `__label__` text AFTER `data_archiviazione`' );

-- | 202611121290

-- documenti_view_static: le colonne nuove della vista, allo stesso posto; prima le colonne del canone che la statica
-- potesse non avere ancora, ciascuna dopo la sua precedente, perche' il posto lo chiede REPLACE ... SELECT * ( 12/11:
-- glistest non aveva note_archiviazione e l'AFTER si fermava ); dove ci sono gia', IF NOT EXISTS non fa niente
-- la statica passa dalla procedura delle statiche, creata qui sopra nella 202611121286: dove su un deploy non c'e' si salta
CALL `__patch_statiche_forma__`( 'documenti_view_static', 'ALTER TABLE `documenti_view_static`
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
	ADD COLUMN IF NOT EXISTS `esigibilita` enum(\'I\',\'D\',\'S\') DEFAULT NULL AFTER `condizione_pagamento`,
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
	ADD COLUMN IF NOT EXISTS `porto` enum(\'franco\',\'assegnato\',\'-\') DEFAULT NULL AFTER `id_trasportatore`,
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
	ADD COLUMN IF NOT EXISTS `__label__` text AFTER `timestamp_aggiornamento`' );

-- | 202611121291

-- todo_view_static: le colonne nuove della vista, allo stesso posto; prima le colonne del canone che la statica
-- potesse non avere ancora, ciascuna dopo la sua precedente, perche' il posto lo chiede REPLACE ... SELECT * ( 12/11:
-- glistest non aveva note_archiviazione e l'AFTER si fermava ); dove ci sono gia', IF NOT EXISTS non fa niente
-- la statica passa dalla procedura delle statiche, creata qui sopra nella 202611121286: dove su un deploy non c'e' si salta
CALL `__patch_statiche_forma__`( 'todo_view_static', 'ALTER TABLE `todo_view_static`
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
	ADD COLUMN IF NOT EXISTS `__label__` text DEFAULT NULL AFTER `timestamp_aggiornamento`' );

-- | FINE
