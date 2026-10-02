-- 2026-09-30 — colonne, tabelle e viste che il codice usa e lo schema non aveva piu'
--
-- Contesto: il codice del framework e dei moduli legge oggetti che i file di base non creano piu', e che su un
-- deploy installato dopo il riallineamento del 02/03/2026 mancano: le query muoiono con un 1054 o un 1146.
-- Sono stati cercati nei file di base di prima di marzo e piu' indietro nella storia, e rimessi nella forma in cui
-- c'erano, portata a bigint:
--
-- - contatti.id_campagna e campagne.testo, campagne_view.n_contatti, contatti_view.id_campagna e .campagna
--   ( moduli _2400.campagne, _0300.contatti, _6500.casse ), dallo schema del 2021;
-- - indirizzi.id_zona ( _src/_api/_task/_indirizzi.geocode.php, la sotto scheda degli indirizzi ), dallo schema
--   del 2021;
-- - attesa_view ( modulo _0635.attesa ), dai file di base di prima di marzo;
-- - tipologie_attivita_inps, costi_contratti, orari_contratti e le loro viste ( moduli _0600.contratti,
--   _1000.produzione, _0920.corsi ), dallo schema del 2021 ( _usr/_database/mysql.schema.sql, 0e99bca51 ).
--
-- Le chiavi esterne di queste colonne e tabelle le porta _202609301100.chiavi.esterne.sql, che viene dopo.
--
-- COSA FA, E COSA NO. Colonne e tabelle si aggiungono con ADD COLUMN IF NOT EXISTS e CREATE TABLE IF NOT EXISTS,
-- con chiave primaria, indici e AUTO_INCREMENT dentro la CREATE: dove ci sono gia', anche nella forma del 2021 con
-- id int( 11 ), non si toccano. contatti.id_campagna e indirizzi.id_zona nascono dello stesso tipo dell'id della
-- tabella a cui puntano ( int( 11 ) sui deploy di prima di marzo ), perche' la chiave esterna si possa mettere. Le viste si rifanno con CREATE OR REPLACE dentro una procedura che, se la vista
-- non si puo' creare perche' sul deploy manca qualcosa da cui dipende, lascia com'e' quella che c'era e lo scrive
-- in @colonne_tabelle_viste_note, che il blocco dopo l'ultima vista restituisce a chi applica la patch a mano.
-- ⚠ Le viste che si ripristinano perche' mancano ( attesa_view, costi_contratti_view, orari_contratti_view,
-- tipologie_attivita_inps_view ) si creano SOLO se non ci sono: un deploy che le ha gia', magari estese con colonne
-- sue, le tiene com'erano. Fix 2026-10-02: la prima versione le rifaceva sempre, e su polmasi ha tolto da attesa_view
-- le colonne del progetto ( note, disciplina, mail, telefoni ): la griglia della lista di attesa e' rimasta vuota.
-- campagne_view e contatti_view invece si rifanno sempre, perche' lo scopo e' proprio aggiungere loro colonne. La
-- procedura, e non un PREPARE, perche' il task delle patch esegue i blocchi con mysqlQuery(), che non conosce
-- PREPARE ed EXECUTE ( vedi _202609301100.chiavi.esterne.sql ); non restituisce righe, perche' una CALL che
-- restituisce un risultato lascerebbe la connessione fuori sincrono per la scrittura su __patch__.
--
-- Non si rimettono, perche' non c'e' nessuna versione da recuperare: tipologie_annunci_view ( il modulo _3200.annunci
-- la legge dal 2024, ma nessun file di schema l'ha mai creata ) e certificazioni_archiviati_view ( tolta nel 2021 con
-- 202108301209.sql: leggeva certificazioni.id_anagrafica, id_emittente e data_scadenza, colonne che oggi stanno in
-- anagrafica_certificazioni, e tipologie_certificazioni, che non esiste piu' ).
--
-- IDEMPOTENTE.

-- | 202609300900

-- la procedura che prova un'istruzione e, se fallisce, lo annota invece di fermare il task
CREATE OR REPLACE PROCEDURE `__patch_colonne_tabelle_viste__`( IN istruzione LONGTEXT, IN oggetto VARCHAR(64) )
BEGIN

    DECLARE messaggio TEXT DEFAULT NULL;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1 messaggio = MESSAGE_TEXT;
        END;

    SET @colonne_tabelle_viste_sql = istruzione;
    PREPARE prova FROM @colonne_tabelle_viste_sql;
    IF messaggio IS NULL THEN
        EXECUTE prova;
        DEALLOCATE PREPARE prova;
    END IF;

    IF messaggio IS NOT NULL THEN
        SET @colonne_tabelle_viste_note = CONCAT_WS( '\n', @colonne_tabelle_viste_note, CONCAT( oggetto, ': ', messaggio ) );
    END IF;

END;

-- | 202609300901

-- contatti.id_campagna, dello stesso tipo di campagne.id ( bigint, o int sui deploy di prima di marzo )
CALL `__patch_colonne_tabelle_viste__`( CONCAT(
    'ALTER TABLE `contatti` ADD COLUMN IF NOT EXISTS `id_campagna` ',
    ( SELECT COLUMN_TYPE FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'campagne' AND COLUMN_NAME = 'id' ),
    ' DEFAULT NULL, ADD KEY IF NOT EXISTS `id_campagna` (`id_campagna`)'
), 'contatti.id_campagna' );

-- | 202609300902

-- indirizzi.id_zona, dello stesso tipo di zone.id
CALL `__patch_colonne_tabelle_viste__`( CONCAT(
    'ALTER TABLE `indirizzi` ADD COLUMN IF NOT EXISTS `id_zona` ',
    ( SELECT COLUMN_TYPE FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'zone' AND COLUMN_NAME = 'id' ),
    ' DEFAULT NULL, ADD KEY IF NOT EXISTS `id_zona` (`id_zona`)'
), 'indirizzi.id_zona' );

-- | 202609300903

-- campagne.testo
ALTER TABLE `campagne`
    ADD COLUMN IF NOT EXISTS `testo` text DEFAULT NULL;

-- | 202609300904

-- tipologie_attivita_inps
CREATE TABLE IF NOT EXISTS `tipologie_attivita_inps` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_genitore` bigint(20) DEFAULT NULL,
  `nome` char(255) NOT NULL,
  `codice` char(32) DEFAULT NULL,
  `se_quadratura` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_genitore`,`nome`),
  UNIQUE KEY `codice` (`codice`),
  KEY `id_genitore` (`id_genitore`),
  KEY `se_quadratura` (`se_quadratura`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609300905

-- costi_contratti
CREATE TABLE IF NOT EXISTS `costi_contratti` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_contratto` bigint(20) NOT NULL,
  `id_tipologia` bigint(20) NOT NULL,
  `note` text DEFAULT NULL,
  `costo_orario` decimal(16,5) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_contratto`,`id_tipologia`),
  KEY `id_contratto` (`id_contratto`),
  KEY `id_tipologia` (`id_tipologia`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609300906

-- orari_contratti
CREATE TABLE IF NOT EXISTS `orari_contratti` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_contratto` bigint(20) NOT NULL,
  `turno` int(11) DEFAULT '1',
  `id_giorno` bigint(20) NOT NULL,
  `ora_inizio` time DEFAULT NULL,
  `ora_fine` time DEFAULT NULL,
  `id_costo` bigint(20) NOT NULL,
  `se_lavoro` int(1) DEFAULT '1',
  `se_disponibile` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico_lavoro` (`id_contratto`,`turno`,`id_giorno`,`ora_inizio`,`ora_fine`,`se_lavoro`),
  UNIQUE KEY `unico_disponibile` (`id_contratto`,`turno`,`id_giorno`,`ora_inizio`,`ora_fine`,`se_disponibile`),
  KEY `id_contratto` (`id_contratto`),
  KEY `id_giorno` (`id_giorno`),
  KEY `id_costo` (`id_costo`),
  KEY `se_lavoro` (`se_lavoro`),
  KEY `se_disponibile` (`se_disponibile`),
  KEY `turno` (`turno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609300907

-- campagne_view
CALL `__patch_colonne_tabelle_viste__`( '
CREATE OR REPLACE VIEW `campagne_view` AS
	SELECT
		campagne.id,
		campagne.nome,
		campagne.testo,
		( SELECT count( contatti.id ) FROM contatti WHERE contatti.id_campagna = campagne.id ) AS n_contatti,
		campagne.id_account_inserimento,
		campagne.id_account_aggiornamento,
		campagne.nome AS __label__
	FROM campagne
', 'campagne_view' );

-- | 202609300908

-- contatti_view
CALL `__patch_colonne_tabelle_viste__`( '
CREATE OR REPLACE VIEW contatti_view AS
	SELECT
		contatti.id,
		contatti.id_tipologia,
		tipologie_contatti.nome AS tipologia,
		contatti.id_anagrafica,
		coalesce( a1.denominazione , concat( a1.cognome, '' '', a1.nome ), '''' ) AS anagrafica,
		contatti.id_inviante,
		coalesce( a2.denominazione , concat( a2.cognome, '' '', a2.nome ), '''' ) AS inviante,
		contatti.id_ranking,
		ranking.nome AS ranking,
		contatti.id_campagna,
		campagne.nome AS campagna,
		contatti.id_sito,
		contatti.utm_id,
		contatti.utm_source,
		contatti.utm_medium,
		contatti.utm_campaign,
		contatti.utm_term,
		contatti.utm_content,
		contatti.nome,
		contatti.modulo,
		contatti.data_archiviazione,
		contatti.timestamp_contatto,
		from_unixtime( contatti.timestamp_contatto, ''%Y-%m-%d %H:%i'' ) AS data_ora_contatto,
		contatti.id_account_inserimento,
		contatti.id_account_aggiornamento,
		concat(
			tipologie_contatti.nome,
			'' / '',
			contatti.nome
		) AS __label__
	FROM contatti
		LEFT JOIN tipologie_contatti ON tipologie_contatti.id = contatti.id_tipologia
		LEFT JOIN anagrafica AS a1 ON a1.id = contatti.id_anagrafica
		LEFT JOIN anagrafica AS a2 ON a2.id = contatti.id_inviante
		LEFT JOIN ranking ON ranking.id = contatti.id_ranking
		LEFT JOIN campagne ON campagne.id = contatti.id_campagna
', 'contatti_view' );

-- | 202609300909

-- attesa_view
CALL `__patch_colonne_tabelle_viste__`( IF(
    EXISTS( SELECT 1 FROM information_schema.VIEWS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'attesa_view' ),
    'DO 0',
'
CREATE OR REPLACE VIEW attesa_view AS
	SELECT
		anagrafica_progetti.id,
		anagrafica_progetti.id_anagrafica,
		coalesce( a1.denominazione, concat( a1.cognome, '' '', a1.nome ), '''' ) AS anagrafica,
		anagrafica_progetti.id_progetto,
		progetti.nome AS progetto,
		todo.data_programmazione AS data_lezione,
		todo.ora_inizio_programmazione AS ora_lezione,
		anagrafica_progetti.id_ruolo,
		ruoli_progetti.nome as ruolo,
		anagrafica_progetti.ordine,
		anagrafica_progetti.se_attesa,
		from_unixtime( anagrafica_progetti.timestamp_inserimento, ''%Y-%m-%d %H:%i'' ) AS data_ora_inserimento,
		anagrafica_progetti.id_account_inserimento,
		anagrafica_progetti.id_account_aggiornamento,
		concat_ws(
			'' '',
			progetti.nome,
			coalesce( a1.denominazione, concat( a1.cognome, '' '', a1.nome ), '''' ),
			ruoli_progetti.nome
		) AS __label__
	FROM anagrafica_progetti
		LEFT JOIN anagrafica AS a1 ON a1.id = anagrafica_progetti.id_anagrafica
		LEFT JOIN progetti ON progetti.id = anagrafica_progetti.id_progetto
		LEFT JOIN ruoli_progetti ON ruoli_progetti.id = anagrafica_progetti.id_ruolo
		LEFT JOIN todo ON todo.id = anagrafica_progetti.id_todo
	WHERE anagrafica_progetti.se_attesa IS NOT NULL
' ), 'attesa_view' );

-- | 202609300910

-- costi_contratti_view
CALL `__patch_colonne_tabelle_viste__`( IF(
    EXISTS( SELECT 1 FROM information_schema.VIEWS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'costi_contratti_view' ),
    'DO 0',
'
CREATE OR REPLACE VIEW `costi_contratti_view` AS
	SELECT
		costi_contratti.id,
		costi_contratti.id_contratto,
		costi_contratti.id_tipologia,
		costi_contratti.note,
		costi_contratti.costo_orario,
		concat(
			if( tipologie_attivita_inps.codice IS NOT NULL, concat( tipologie_attivita_inps.codice, '' - '' ), '''' ),
			tipologie_attivita_inps.nome
		) AS __label__
	FROM costi_contratti
		LEFT JOIN tipologie_attivita_inps ON tipologie_attivita_inps.id = costi_contratti.id_tipologia
' ), 'costi_contratti_view' );

-- | 202609300911

-- orari_contratti_view
CALL `__patch_colonne_tabelle_viste__`( IF(
    EXISTS( SELECT 1 FROM information_schema.VIEWS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'orari_contratti_view' ),
    'DO 0',
'
CREATE OR REPLACE VIEW `orari_contratti_view` AS
	SELECT
		orari_contratti.id,
		orari_contratti.id_contratto,
		orari_contratti.turno,
		orari_contratti.id_giorno,
		orari_contratti.ora_inizio,
		orari_contratti.ora_fine,
		orari_contratti.id_costo,
		orari_contratti.se_lavoro,
		orari_contratti.se_disponibile,
		concat(
			''turno '', orari_contratti.turno, '' '',
			orari_contratti.id_giorno, '' '',
			orari_contratti.ora_inizio, '' '',
			orari_contratti.ora_fine
		) AS __label__
	FROM orari_contratti
' ), 'orari_contratti_view' );

-- | 202609300912

-- tipologie_attivita_inps_view
CALL `__patch_colonne_tabelle_viste__`( IF(
    EXISTS( SELECT 1 FROM information_schema.VIEWS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'tipologie_attivita_inps_view' ),
    'DO 0',
'
CREATE OR REPLACE VIEW `tipologie_attivita_inps_view` AS
	SELECT
		tipologie_attivita_inps.id,
		tipologie_attivita_inps.id_genitore,
		tipologie_attivita_inps.nome,
		tipologie_attivita_inps.codice,
		tipologie_attivita_inps.se_quadratura,
		concat(
			if( tipologie_attivita_inps.codice IS NOT NULL, concat( tipologie_attivita_inps.codice, '' - '' ), '''' ),
			tipologie_attivita_inps.nome
		) AS __label__
	FROM tipologie_attivita_inps
' ), 'tipologie_attivita_inps_view' );

-- | 202609300913

-- quello che non si e' potuto fare, e perche': lo legge chi applica la patch a mano
SELECT @colonne_tabelle_viste_note AS nota;

-- | 202609300914

-- si libera la procedura
DROP PROCEDURE IF EXISTS `__patch_colonne_tabelle_viste__`;

-- | FINE FILE
