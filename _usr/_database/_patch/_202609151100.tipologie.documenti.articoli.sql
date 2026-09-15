-- 2026-09-15 — la tipologia della RIGA di un documento diventa una cosa diversa dalla tipologia
-- del DOCUMENTO che la contiene.
--
-- Contesto: documenti_articoli.id_tipologia aveva la chiave esterna verso tipologie_documenti,
-- cioe' conteneva offerta / fattura / DDT — la tipologia del documento, ripetuta sulla riga. Il
-- commento nei file base diceva pero' "chiave esterna per la tipologia di articolo", e la tendina
-- delle form leggeva la chiave 'tipologie_documenti_articoli' popolandola da tipologie_documenti_view:
-- il campo proponeva quindi le tipologie di documento, obbligatorie e precompilate con quella del
-- documento stesso. Su Lughese ha prodotto dieci righe marcate con la tipologia del loro stesso
-- documento e nient'altro, su cinquantamila.
--
-- Questa patch separa le due cose:
--  - id_tipologia_documento prende il posto ( e il contenuto ) della vecchia id_tipologia;
--  - id_tipologia resta il nome della tipologia della RIGA e punta alla nuova
--    tipologie_documenti_articoli, che marca i raggruppamenti, le righe che sommano e quelle
--    in alternativa.
--
-- IDEMPOTENZA. La patch deve poter girare anche dove la migrazione e' gia' stata fatta a mano
-- ( utensilerialughese, 14/09/2026 ), quindi non usa CHANGE COLUMN: su un deploy gia' migrato
-- rinominerebbe la colonna NUOVA, che li' si chiama di nuovo id_tipologia. Usa invece
-- ADD COLUMN IF NOT EXISTS piu' due UPDATE che si riconoscono da soli, e lo svuotamento della
-- vecchia colonna e' ancorato a `id_tipologia = id_tipologia_documento`, cioe' tocca solo le
-- righe che questa stessa patch ha appena copiato. Dove la tipologia della riga e' gia' in uso
-- non viene toccata.
--
-- COSTO. La ricostruzione degli indici compositi ( sette, piu' l'unicita' sul codice ) riscrive
-- gli indici di documenti_articoli: su una tabella da 50.000 righe sono secondi, su un deploy
-- molto grosso va messa in conto. Senza, gli indici resterebbero appesi alla colonna che adesso
-- significa un'altra cosa e i report per tipologia di documento perderebbero l'indice.

-- | 202609151100

-- la tabella delle tipologie di riga
CREATE TABLE IF NOT EXISTS `tipologie_documenti_articoli` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_genitore` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `sigla` char(16) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_raggruppamento` tinyint(1) DEFAULT NULL,
  `se_somma` tinyint(1) DEFAULT NULL,
  `se_alternativa` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609151101

-- indici della tabella nuova
ALTER TABLE `tipologie_documenti_articoli`
	ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_genitore`,`nome`),
	ADD KEY IF NOT EXISTS `id_genitore` (`id_genitore`),
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	ADD KEY IF NOT EXISTS `nome` (`nome`),
	ADD KEY IF NOT EXISTS `sigla` (`sigla`),
	ADD KEY IF NOT EXISTS `se_raggruppamento` (`se_raggruppamento`),
	ADD KEY IF NOT EXISTS `se_somma` (`se_somma`),
	ADD KEY IF NOT EXISTS `se_alternativa` (`se_alternativa`),
	ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`id_genitore`,`ordine`,`nome`,`sigla`,`se_raggruppamento`,`se_somma`,`se_alternativa`);

-- | 202609151102

-- l'auto increment NON si mette qui con un MODIFY, ed e' scritto perche' non sembri una
-- dimenticanza: sta nella CREATE TABLE qui sopra.
--
-- Il MODIFY c'era, ed e' fallito il 15/09/2026 applicando su utensilerialughese:
--   ERROR 1833 Cannot change column 'id': used in a foreign key constraint
--   'documenti_articoli_ibfk_20_nofollow'
-- Li' la tabella esisteva gia' — la migrazione era stata fatta a mano — con `id` int( 11 ) e con
-- la chiave esterna da documenti_articoli gia' in piedi: il tipo di una colonna referenziata non
-- si cambia. Su un database di prova senza chiavi esterne il MODIFY passava, ed e' il motivo per
-- cui provare una patch solo su un database pulito non basta.
--
-- Nei file di base la separazione resta, perche' li' l'ordine e' un altro: gli indici ( 03 )
-- girano prima dei vincoli ( 06 ) e quando il MODIFY passa di chiavi esterne non ce n'e' ancora.

-- | 202609151103

-- le due tipologie di riga che il framework usa da se'
INSERT IGNORE INTO `tipologie_documenti_articoli` (`id`, `id_genitore`, `ordine`, `nome`, `sigla`, `html_entity`, `font_awesome`, `se_raggruppamento`, `se_somma`, `se_alternativa`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	1,	'raggruppamento a sommare',	'somma',	NULL,	NULL,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	2,	'raggruppamento in alternativa',	'alt.',	NULL,	NULL,	1,	NULL,	1,	NULL,	NULL,	NULL,	NULL);

-- | 202609151110

-- la colonna che prende il posto della vecchia id_tipologia
ALTER TABLE `documenti_articoli` ADD COLUMN IF NOT EXISTS `id_tipologia_documento` bigint(20) DEFAULT NULL AFTER `id_tipologia`;

-- | 202609151111

-- il contenuto della vecchia colonna trasloca; dove la nuova e' gia' piena non si tocca niente
UPDATE `documenti_articoli`
	SET `id_tipologia_documento` = `id_tipologia`
	WHERE `id_tipologia_documento` IS NULL
	  AND `id_tipologia` IS NOT NULL;

-- | 202609151112

-- la vecchia colonna si svuota SOLO dove contiene quello che si e' appena copiato: e' la guardia
-- che rende innocua questa patch sui deploy dove la tipologia della riga e' gia' in uso
UPDATE `documenti_articoli`
	SET `id_tipologia` = NULL
	WHERE `id_tipologia` IS NOT NULL
	  AND `id_tipologia` = `id_tipologia_documento`;

-- | 202609151120

-- gli indici compositi seguono la tipologia del documento, che e' quello che descrivevano
ALTER TABLE `documenti_articoli`
	DROP INDEX IF EXISTS `unico_codice`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `indice_progetto_quantita`,
	DROP INDEX IF EXISTS `indice_progetto_valore`,
	DROP INDEX IF EXISTS `indice_todo_quantita`,
	DROP INDEX IF EXISTS `indice_todo_valore`,
	DROP INDEX IF EXISTS `indice_attivita_quantita`,
	DROP INDEX IF EXISTS `indice_attivita_valore`;

-- | 202609151121

-- e si ricostruiscono sulla colonna giusta, piu' la chiave semplice sulla tipologia della riga
ALTER TABLE `documenti_articoli`
	ADD KEY IF NOT EXISTS `id_tipologia_documento` (`id_tipologia_documento`),
	ADD KEY IF NOT EXISTS `id_tipologia` (`id_tipologia`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`id_genitore`,`id_tipologia_documento`,`ordine`,`id_documento`,`data`,`id_emittente`,`id_destinatario`,`id_reparto`,`id_progetto`,`id_todo`,`id_attivita`,`id_articolo`,`id_mastro_provenienza`,`id_mastro_destinazione`),
	ADD KEY IF NOT EXISTS `indice_progetto_quantita` (`id`,`id_genitore`,`id_tipologia_documento`,`ordine`,`id_documento`,`data`,`id_emittente`,`id_destinatario`,`id_reparto`,`id_progetto`,`id_articolo`,`id_mastro_provenienza`,`id_mastro_destinazione`,`id_udm`,`quantita`),
	ADD KEY IF NOT EXISTS `indice_progetto_valore` (`id`,`id_genitore`,`id_tipologia_documento`,`ordine`,`id_documento`,`data`,`id_emittente`,`id_destinatario`,`id_reparto`,`id_progetto`,`id_articolo`,`id_mastro_provenienza`,`id_mastro_destinazione`,`id_listino`,`importo_netto_totale`,`id_matricola`),
	ADD KEY IF NOT EXISTS `indice_todo_quantita` (`id`,`id_genitore`,`id_tipologia_documento`,`ordine`,`id_documento`,`data`,`id_emittente`,`id_destinatario`,`id_reparto`,`id_todo`,`id_articolo`,`id_mastro_provenienza`,`id_mastro_destinazione`,`id_udm`,`quantita`),
	ADD KEY IF NOT EXISTS `indice_todo_valore` (`id`,`id_genitore`,`id_tipologia_documento`,`ordine`,`id_documento`,`data`,`id_emittente`,`id_destinatario`,`id_reparto`,`id_todo`,`id_articolo`,`id_mastro_provenienza`,`id_mastro_destinazione`,`id_listino`,`importo_netto_totale`,`id_matricola`),
	ADD KEY IF NOT EXISTS `indice_attivita_quantita` (`id`,`id_genitore`,`id_tipologia_documento`,`ordine`,`id_documento`,`data`,`id_emittente`,`id_destinatario`,`id_reparto`,`id_attivita`,`id_articolo`,`id_mastro_provenienza`,`id_mastro_destinazione`,`id_udm`,`quantita`),
	ADD KEY IF NOT EXISTS `indice_attivita_valore` (`id`,`id_genitore`,`id_tipologia_documento`,`ordine`,`id_documento`,`data`,`id_emittente`,`id_destinatario`,`id_reparto`,`id_attivita`,`id_articolo`,`id_mastro_provenienza`,`id_mastro_destinazione`,`id_listino`,`importo_netto_totale`,`id_matricola`);

-- | 202609151130

-- tipologie_documenti_articoli_path
DROP FUNCTION IF EXISTS `tipologie_documenti_articoli_path`;

-- | 202609151131

-- tipologie_documenti_articoli_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_documenti_articoli_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_documenti_articoli_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_documenti_articoli.id_genitore,
				tipologie_documenti_articoli.nome
			FROM tipologie_documenti_articoli
			WHERE tipologie_documenti_articoli.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

-- | 202609151132

-- tipologie_documenti_articoli_path_check
DROP FUNCTION IF EXISTS `tipologie_documenti_articoli_path_check`;

-- | 202609151133

-- tipologie_documenti_articoli_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_documenti_articoli_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT tipologie_documenti_articoli_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_documenti_articoli.id_genitore
			FROM tipologie_documenti_articoli
			WHERE tipologie_documenti_articoli.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

-- | 202609151134

-- tipologie_documenti_articoli_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_documenti_articoli_path_find_ancestor`;

-- | 202609151135

-- tipologie_documenti_articoli_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_documenti_articoli_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_documenti_articoli_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_documenti_articoli.id_genitore,
				tipologie_documenti_articoli.id
			FROM tipologie_documenti_articoli
			WHERE tipologie_documenti_articoli.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

-- | 202609151140

-- la vista della tabella nuova
CREATE OR REPLACE VIEW `tipologie_documenti_articoli_view` AS
	SELECT
		tipologie_documenti_articoli.id,
		tipologie_documenti_articoli.id_genitore,
		tipologie_documenti_articoli.ordine,
		tipologie_documenti_articoli.nome,
		tipologie_documenti_articoli.sigla,
		tipologie_documenti_articoli.html_entity,
		tipologie_documenti_articoli.font_awesome,
		tipologie_documenti_articoli.se_raggruppamento,
		tipologie_documenti_articoli.se_somma,
		tipologie_documenti_articoli.se_alternativa,
		tipologie_documenti_articoli.id_account_inserimento,
		tipologie_documenti_articoli.id_account_aggiornamento,
		tipologie_documenti_articoli_path( tipologie_documenti_articoli.id ) AS __label__
	FROM tipologie_documenti_articoli
;

-- | 202609151141

-- documenti_articoli_view NON si ricrea qui, e nemmeno l'unicita' sul codice: le fa entrambe
-- _202609151200, dopo aver allineato le colonne di documenti_articoli.
--
-- Il motivo, misurato il 15/09/2026 su tutti e cinque i deploy: la vista dei file base legge 34
-- colonne di documenti_articoli e tre deploy su cinque non le hanno tutte ( a crmfia ne mancano
-- 3, a gimbe 4, a polmasi 1 ), e l'unicita' `unico_codice` vuole la colonna `codice`, che gimbe
-- non ha. Tenendole qui la migrazione si fermava a meta': e' successo davvero su crmfia, che e'
-- rimasto con lo schema migrato e la vista vecchia, cioe' con la tipologia vuota a video su
-- 6.106 righe.
--
-- Separarle serve a questo: la migrazione dello schema passa ovunque, e quello che dipende da
-- colonne che un deploy potrebbe non avere sta in una patch successiva, che le aggiunge prima
-- di usarle.

-- | 202609151142

-- todo_view NON si ricrea qui, di proposito.
--
-- Nei file base la todo_view fa il join su documenti_articoli ed e' stata adeguata alla colonna
-- rinominata, ma quella versione sui deploy non e' mai arrivata: li' la vista e' una copia molto
-- piu' vecchia che documenti_articoli non lo nomina nemmeno, quindi la rinomina non la rompe e
-- non c'e' niente da sistemare. Ricrearla qui la romperebbe davvero: la versione dei file base
-- legge la tabella `istruzioni`, che su questi deploy non esiste ( verificato il 15/09/2026 su
-- utensilerialughese e crmfia ), e il task delle patch si ferma al primo errore lasciando indietro
-- tutte le patch successive.
--
-- Portare a monte `istruzioni` e la todo_view nuova e' un lavoro a se', che va fatto con la sua
-- patch: e' un disallineamento fra file base e deploy che esisteva gia' prima di questa migrazione.

-- | FINE
