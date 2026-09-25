-- 2026-09-25 — torna la tabella pianificazioni, con la vista, le funzioni pianificazioni_path* e i dati di periodicita
--
-- Contesto: la tabella stava nei file di base fino al riallineamento del 02/03/2026 ( commit d975b4a15,
-- "riallineamento da Gimbe e Glisdev" ), che ha riscritto i file _0?0000999999.*.sql e l'ha persa per
-- strada insieme a pianificazioni_view, alle tre funzioni pianificazioni_path* e alle righe di
-- periodicita. Nessuna patch l'ha mai tolta di proposito: le colonne id_pianificazione di attivita,
-- documenti, documenti_articoli, macro, metadati, pagamenti, progetti, rinnovi e todo sono rimaste, e il
-- modulo _0100.pianificazioni continua a leggerla e scriverla. Un database installato dopo marzo non la
-- ha, e su quel database il modulo fallisce alla prima query.
--
-- COME E' FATTA. La definizione viene dalla versione precedente a d975b4a15 ( quella verificata il
-- 2021-10-05 ), con le chiavi portate a bigint( 20 ) come le tabelle a cui puntano: anche id_progetto,
-- model_id_articolo, model_id_prodotto e model_id_progetto, che erano char( 32 ) quando gli id di
-- progetti, articoli e prodotti erano codici; model_id_coupon resta char( 32 ) perche' coupon.id lo e'
-- ancora. I file di base sono stati aggiornati nello stesso giro, con i numeri di blocco che la tabella
-- aveva prima ( 023800, e 023600 per i vincoli ); le righe di periodicita stanno nel blocco 050000023600.
-- Gli id 1-8 di periodicita non sono arbitrari: creazionePianificazione() in _src/_lib/_cron.utils.php
-- ci fa sopra uno switch ( 1 giornaliera, 2 settimanale, 3 mensile, 8 annuale ).
--
-- IDEMPOTENZA. Un deploy installato prima di marzo ha ancora la tabella, nella forma del 2021 o in
-- quella ancora precedente ( con id_turno, periodicita, ripetizione_mese, giorni_rinnovo ): la CREATE
-- non fa niente, e le colonne che mancano arrivano con ADD COLUMN IF NOT EXISTS, cosi' che la vista si
-- possa creare in ogni caso. Le colonne vecchie che la tabella di oggi non ha restano dove sono. Le
-- INSERT di periodicita sono IGNORE, funzioni e vista si ricreano.
--
-- COSA NON C'E' QUI, di proposito: le chiavi esterne. Stanno nei file di base, ma non si portano ai
-- deploy esistenti per lo stesso motivo di _202609251000.audio.sql: dove la tabella vecchia c'e' ancora
-- le colonne sono int( 11 ) e non combaciano con le chiavi primarie bigint( 20 ), e il task si ferma al
-- primo errore lasciando indietro tutte le patch successive.
--
-- PORTABILITA'. Chiave primaria, AUTO_INCREMENT e indici sono dichiarati INLINE nella CREATE, per il
-- motivo spiegato in _202609231600.mail.status.sql; ADD COLUMN IF NOT EXISTS e' di MariaDB, come in
-- _202609151300.documenti.articoli.colonne.sql.

-- | 202609251400

-- pianificazioni
CREATE TABLE IF NOT EXISTS `pianificazioni` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_genitore` bigint(20) DEFAULT NULL,
  `id_progetto` bigint(20) DEFAULT NULL,
  `id_todo` bigint(20) DEFAULT NULL,
  `id_attivita` bigint(20) DEFAULT NULL,
  `id_contratto` bigint(20) DEFAULT NULL,
  `id_anagrafica` bigint(20) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_periodicita` bigint(20) DEFAULT NULL,
  `cadenza` int(11) DEFAULT NULL,
  `se_lunedi` tinyint(1) DEFAULT NULL,
  `se_martedi` tinyint(1) DEFAULT NULL,
  `se_mercoledi` tinyint(1) DEFAULT NULL,
  `se_giovedi` tinyint(1) DEFAULT NULL,
  `se_venerdi` tinyint(1) DEFAULT NULL,
  `se_sabato` tinyint(1) DEFAULT NULL,
  `se_domenica` tinyint(1) DEFAULT NULL,
  `schema_ripetizione` int(11) DEFAULT NULL,
  `data_avvio` date DEFAULT NULL,
  `data_inizio` date DEFAULT NULL,
  `data_elaborazione` date DEFAULT NULL,
  `timestamp_elaborazione` int(11) DEFAULT NULL,
  `data_ultimo_oggetto` date DEFAULT NULL,
  `giorni_elaborazione` int(11) DEFAULT NULL,
  `giorni_estensione` int(11) DEFAULT NULL,
  `data_fine` date DEFAULT NULL,
  `entita` enum('todo','attivita','rinnovi','documenti','documenti_articoli','pagamenti') DEFAULT NULL,
  `model_id_anagrafica` bigint(20) DEFAULT NULL,
  `model_id_anagrafica_programmazione` bigint(20) DEFAULT NULL,
  `model_id_articolo` bigint(20) DEFAULT NULL,
  `model_id_attivita` bigint(20) DEFAULT NULL,
  `model_id_causale` bigint(20) DEFAULT NULL,
  `model_id_cliente` bigint(20) DEFAULT NULL,
  `model_id_collo` bigint(20) DEFAULT NULL,
  `model_id_condizione_pagamento` bigint(20) DEFAULT NULL,
  `model_id_contatto` bigint(20) DEFAULT NULL,
  `model_id_coupon` char(32) DEFAULT NULL,
  `model_id_destinatario` bigint(20) DEFAULT NULL,
  `model_id_documento` bigint(20) DEFAULT NULL,
  `model_id_emittente` bigint(20) DEFAULT NULL,
  `model_id_genitore` bigint(20) DEFAULT NULL,
  `model_id_iban` bigint(20) DEFAULT NULL,
  `model_id_indirizzo` bigint(20) DEFAULT NULL,
  `model_id_immobile` bigint(20) DEFAULT NULL,
  `model_id_licenza` bigint(20) DEFAULT NULL,
  `model_id_listino` bigint(20) DEFAULT NULL,
  `model_id_luogo` bigint(20) DEFAULT NULL,
  `model_id_mastro_destinazione` bigint(20) DEFAULT NULL,
  `model_id_mastro_provenienza` bigint(20) DEFAULT NULL,
  `model_id_matricola` bigint(20) DEFAULT NULL,
  `model_id_modalita_pagamento` bigint(20) DEFAULT NULL,
  `model_id_prodotto` bigint(20) DEFAULT NULL,
  `model_id_progetto` bigint(20) DEFAULT NULL,
  `model_id_reparto` bigint(20) DEFAULT NULL,
  `model_id_sede_destinatario` bigint(20) DEFAULT NULL,
  `model_id_sede_emittente` bigint(20) DEFAULT NULL,
  `model_id_tipologia` bigint(20) DEFAULT NULL,
  `model_id_todo` bigint(20) DEFAULT NULL,
  `model_id_trasportatore` bigint(20) DEFAULT NULL,
  `model_id_udm` bigint(20) DEFAULT NULL,
  `model_anno_programmazione` year(4) DEFAULT NULL,
  `model_codice` char(64) DEFAULT NULL,
  `model_data` date DEFAULT NULL,
  `model_data_fine` date DEFAULT NULL,
  `model_data_inizio` date DEFAULT NULL,
  `model_data_programmazione` date DEFAULT NULL,
  `model_esigibilita` enum('I','D','S') DEFAULT NULL,
  `model_importo_netto_totale` char(32) DEFAULT NULL,
  `model_importo_lordo_totale` char(32) DEFAULT NULL,
  `model_importo_lordo_finale` char(32) DEFAULT NULL,
  `model_nome` char(255) DEFAULT NULL,
  `model_note` text DEFAULT NULL,
  `model_note_cliente` text DEFAULT NULL,
  `model_note_programmazione` text DEFAULT NULL,
  `model_numero` char(32) DEFAULT NULL,
  `model_ora_inizio_programmazione` time DEFAULT NULL,
  `model_ora_fine_programmazione` time DEFAULT NULL,
  `model_ore_programmazione` decimal(5,2) DEFAULT NULL,
  `model_porto` enum('franco','assegnato','-') DEFAULT NULL,
  `model_quantita` decimal(9,2) DEFAULT NULL,
  `model_riferimento` char(255) DEFAULT NULL,
  `model_sconto_percentuale` decimal(9,2) DEFAULT NULL,
  `model_sconto_valore` decimal(9,2) DEFAULT NULL,
  `model_se_automatico` int(1) DEFAULT NULL,
  `model_sezionale` char(32) DEFAULT NULL,
  `model_settimana_programmazione` int(11) DEFAULT NULL,
  `model_specifiche` char(255) DEFAULT NULL,
  `model_data_scadenza` date DEFAULT NULL,
  `model_timestamp_scadenza` int(11) DEFAULT NULL,
  `offset_giorni` int(11) DEFAULT NULL,
  `offset_fine_mese` int(1) DEFAULT NULL,
  `workspace` longtext DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_genitore` (`id_genitore`),
  KEY `id_progetto` (`id_progetto`),
  KEY `id_todo` (`id_todo`),
  KEY `id_attivita` (`id_attivita`),
  KEY `id_contratto` (`id_contratto`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_periodicita` (`id_periodicita`),
  KEY `nome` (`nome`),
  KEY `token` (`token`),
  KEY `data_fine` (`data_fine`),
  KEY `data_inizio` (`data_inizio`),
  KEY `data_elaborazione` (`data_elaborazione`),
  KEY `timestamp_elaborazione` (`timestamp_elaborazione`),
  KEY `entita` (`entita`),
  KEY `model_id_luogo` (`model_id_luogo`),
  KEY `model_id_anagrafica` (`model_id_anagrafica`),
  KEY `model_id_anagrafica_programmazione` (`model_id_anagrafica_programmazione`),
  KEY `model_id_articolo` (`model_id_articolo`),
  KEY `model_id_attivita` (`model_id_attivita`),
  KEY `model_id_cliente` (`model_id_cliente`),
  KEY `model_id_condizione_pagamento` (`model_id_condizione_pagamento`),
  KEY `model_id_contatto` (`model_id_contatto`),
  KEY `model_id_coupon` (`model_id_coupon`),
  KEY `model_id_destinatario` (`model_id_destinatario`),
  KEY `model_id_documento` (`model_id_documento`),
  KEY `model_id_emittente` (`model_id_emittente`),
  KEY `model_id_genitore` (`model_id_genitore`),
  KEY `model_id_iban` (`model_id_iban`),
  KEY `model_id_indirizzo` (`model_id_indirizzo`),
  KEY `model_id_immobile` (`model_id_immobile`),
  KEY `model_id_licenza` (`model_id_licenza`),
  KEY `model_id_listino` (`model_id_listino`),
  KEY `model_id_mastro_destinazione` (`model_id_mastro_destinazione`),
  KEY `model_id_mastro_provenienza` (`model_id_mastro_provenienza`),
  KEY `model_id_matricola` (`model_id_matricola`),
  KEY `model_id_modalita_pagamento` (`model_id_modalita_pagamento`),
  KEY `model_id_prodotto` (`model_id_prodotto`),
  KEY `model_id_progetto` (`model_id_progetto`),
  KEY `model_id_reparto` (`model_id_reparto`),
  KEY `model_id_tipologia` (`model_id_tipologia`),
  KEY `model_id_todo` (`model_id_todo`),
  KEY `model_id_trasportatore` (`model_id_trasportatore`),
  KEY `model_id_udm` (`model_id_udm`),
  KEY `model_anno_programmazione` (`model_anno_programmazione`),
  KEY `model_codice` (`model_codice`),
  KEY `model_data` (`model_data`),
  KEY `model_data_fine` (`model_data_fine`),
  KEY `model_data_inizio` (`model_data_inizio`),
  KEY `model_data_programmazione` (`model_data_programmazione`),
  KEY `model_importo_netto_totale` (`model_importo_netto_totale`),
  KEY `model_nome` (`model_nome`),
  KEY `model_ore_programmazione` (`model_ore_programmazione`),
  KEY `model_quantita` (`model_quantita`),
  KEY `model_sconto_percentuale` (`model_sconto_percentuale`),
  KEY `model_sconto_valore` (`model_sconto_valore`),
  KEY `model_se_automatico` (`model_se_automatico`),
  KEY `model_sezionale` (`model_sezionale`),
  KEY `model_settimana_programmazione` (`model_settimana_programmazione`),
  KEY `model_data_scadenza` (`model_data_scadenza`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`nome`,`id_periodicita`,`cadenza`,`se_lunedi`,`se_martedi`,`se_mercoledi`,`se_giovedi`,`se_venerdi`,`se_sabato`,`se_domenica`,`schema_ripetizione`,`data_elaborazione`,`giorni_estensione`,`data_fine`,`token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609251401

-- le colonne che una tabella vecchia potrebbe non avere, per i deploy installati prima di marzo
ALTER TABLE `pianificazioni`
	ADD COLUMN IF NOT EXISTS `id_genitore` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_progetto` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_todo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_attivita` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_contratto` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_anagrafica` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `nome` char(255) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `note` text DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_periodicita` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `cadenza` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_lunedi` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_martedi` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_mercoledi` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_giovedi` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_venerdi` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_sabato` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_domenica` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `schema_ripetizione` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `data_avvio` date DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `data_inizio` date DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `data_elaborazione` date DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_elaborazione` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `data_ultimo_oggetto` date DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `giorni_elaborazione` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `giorni_estensione` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `data_fine` date DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `entita` enum('todo','attivita','rinnovi','documenti','documenti_articoli','pagamenti') DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_id_anagrafica` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_id_anagrafica_programmazione` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_id_articolo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_id_attivita` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_id_causale` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_id_cliente` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_id_collo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_id_condizione_pagamento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_id_contatto` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_id_coupon` char(32) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_id_destinatario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_id_documento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_id_emittente` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_id_genitore` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_id_iban` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_id_indirizzo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_id_immobile` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_id_licenza` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_id_listino` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_id_luogo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_id_mastro_destinazione` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_id_mastro_provenienza` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_id_matricola` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_id_modalita_pagamento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_id_prodotto` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_id_progetto` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_id_reparto` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_id_sede_destinatario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_id_sede_emittente` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_id_tipologia` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_id_todo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_id_trasportatore` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_id_udm` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_anno_programmazione` year(4) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_codice` char(64) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_data` date DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_data_fine` date DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_data_inizio` date DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_data_programmazione` date DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_esigibilita` enum('I','D','S') DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_importo_netto_totale` char(32) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_importo_lordo_totale` char(32) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_importo_lordo_finale` char(32) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_nome` char(255) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_note` text DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_note_cliente` text DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_note_programmazione` text DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_numero` char(32) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_ora_inizio_programmazione` time DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_ora_fine_programmazione` time DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_ore_programmazione` decimal(5,2) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_porto` enum('franco','assegnato','-') DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_quantita` decimal(9,2) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_riferimento` char(255) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_sconto_percentuale` decimal(9,2) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_sconto_valore` decimal(9,2) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_se_automatico` int(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_sezionale` char(32) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_settimana_programmazione` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_specifiche` char(255) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_data_scadenza` date DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `model_timestamp_scadenza` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `offset_giorni` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `offset_fine_mese` int(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `workspace` longtext DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `token` char(128) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_inserimento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_inserimento` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_aggiornamento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_aggiornamento` int(11) DEFAULT NULL;

-- | 202609251402

-- periodicita
INSERT IGNORE INTO `periodicita` (`id`, `nome`, `giorni`) VALUES
(1,	'giornaliera',	1),
(2,	'settimanale',	7),
(3,	'mensile',	30),
(4,	'bimestrale',	60),
(5,	'trimestrale',	90),
(6,	'quadrimestrale',	120),
(7,	'semestrale',	180),
(8,	'annuale',	365);

-- | 202609251410

-- pianificazioni_path
DROP FUNCTION IF EXISTS `pianificazioni_path`;

-- | 202609251411

-- pianificazioni_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `pianificazioni_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT pianificazioni_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				pianificazioni.id_genitore,
				pianificazioni.nome
			FROM pianificazioni
			WHERE pianificazioni.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

-- | 202609251412

-- pianificazioni_path_check
DROP FUNCTION IF EXISTS `pianificazioni_path_check`;

-- | 202609251413

-- pianificazioni_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `pianificazioni_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 int( 11 ) -> l'id dell'oggetto da cercare nel path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT pianificazioni_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				pianificazioni.id_genitore
			FROM pianificazioni
			WHERE pianificazioni.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

-- | 202609251414

-- pianificazioni_path_find_ancestor
DROP FUNCTION IF EXISTS `pianificazioni_path_find_ancestor`;

-- | 202609251415

-- pianificazioni_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `pianificazioni_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT pianificazioni_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				pianificazioni.id_genitore,
				pianificazioni.id
			FROM pianificazioni
			WHERE pianificazioni.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

-- | 202609251420

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
		pianificazioni.model_timestamp_scadenza,
		pianificazioni.offset_giorni,
		pianificazioni.offset_fine_mese,
		pianificazioni.workspace,
		pianificazioni.token,
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

-- | FINE FILE
