-- 2026-09-25 — tornano le tabelle audio e ruoli_audio, gemelle di video e ruoli_video
--
-- Contesto: le due tabelle stavano nei file di base fino al riallineamento del 02/03/2026
-- ( commit d975b4a15, "riallineamento da Gimbe e Glisdev" ), che ha riscritto i file
-- _0?0000999999.*.sql e le ha perse per strada insieme a audio_view, ruoli_audio_view e alle tre
-- funzioni ruoli_audio_path*. Nessuna patch le ha mai tolte di proposito: il resto del framework
-- ha continuato a usarle. contenuti.id_audio e metadati.id_audio ci sono ancora, aggiungiAudio()
-- in _src/_lib/_mysql.utils.php le legge, e sedici form dei moduli ( *.form.audio ) scrivono in
-- audio e popolano la tendina dei ruoli da ruoli_audio_view. Un database installato dopo marzo
-- non le ha, e su quel database tutte queste cose falliscono.
--
-- COME SONO FATTE. Le definizioni vengono dalla versione precedente a d975b4a15, portate alla
-- forma che video e ruoli_video hanno oggi: bigint( 20 ) invece di int( 11 ), le colonne di
-- collegamento che video ha guadagnato nel frattempo ( id_marchio, id_categoria_risorse,
-- id_valutazione ), la colonna note e il flag se_marchi sui ruoli. orientamento e ratio di video
-- non ci sono, perche' per un audio non vogliono dire niente. I file di base sono stati aggiornati
-- nello stesso giro, con i numeri di blocco che le due tabelle avevano prima ( 002100 e 034200 ).
--
-- IDEMPOTENZA. Un deploy installato prima di marzo le tabelle le ha ancora, nella forma vecchia:
-- le CREATE non fanno niente, e le colonne nuove arrivano con ADD COLUMN IF NOT EXISTS. Le INSERT
-- dei ruoli sono IGNORE, funzioni e viste si ricreano.
--
-- COSA NON C'E' QUI, di proposito: le chiavi esterne. Stanno nei file di base, come quelle di
-- video, ma non si portano ai deploy esistenti: dove la tabella vecchia c'e' ancora i vincoli
-- audio_ibfk_* esistono gia' con una numerazione diversa ( audio_ibfk_03 era id_anagrafica, oggi
-- e' id_file ) e con colonne int( 11 ) che non combaciano con le chiavi primarie bigint( 20 ), e
-- il task si ferma al primo errore lasciando indietro tutte le patch successive. E' la stessa
-- scelta delle ultime patch che hanno aggiunto tabelle ( _202609151100, _202609231600 ).
--
-- PORTABILITA'. Chiave primaria, AUTO_INCREMENT e indici sono dichiarati INLINE nelle CREATE, per
-- il motivo spiegato in _202609231600.mail.status.sql; ADD COLUMN IF NOT EXISTS e ADD KEY IF NOT
-- EXISTS sono di MariaDB, come in _202609151300.documenti.articoli.colonne.sql.

-- | 202609251000

-- audio
CREATE TABLE IF NOT EXISTS `audio` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_anagrafica` bigint(20) DEFAULT NULL,
  `id_pagina` bigint(20) DEFAULT NULL,
  `id_file` bigint(20) DEFAULT NULL,
  `id_prodotto` bigint(20) DEFAULT NULL,
  `id_articolo` bigint(20) DEFAULT NULL,
  `id_categoria_prodotti` bigint(20) DEFAULT NULL,
  `id_marchio` bigint(20) DEFAULT NULL,
  `id_risorsa` bigint(20) DEFAULT NULL,
  `id_categoria_risorse` bigint(20) DEFAULT NULL,
  `id_notizia` bigint(20) DEFAULT NULL,
  `id_annuncio` bigint(20) DEFAULT NULL,
  `id_categoria_notizie` bigint(20) DEFAULT NULL,
  `id_categoria_annunci` bigint(20) DEFAULT NULL,
  `id_lingua` bigint(20) DEFAULT NULL,
  `id_ruolo` bigint(20) DEFAULT NULL,
  `id_progetto` bigint(20) DEFAULT NULL,
  `id_categoria_progetti` bigint(20) DEFAULT NULL,
  `id_indirizzo` bigint(20) DEFAULT NULL,
  `id_edificio` bigint(20) DEFAULT NULL,
  `id_immobile` bigint(20) DEFAULT NULL,
  `id_valutazione` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `path` char(255) DEFAULT NULL,
  `id_embed` bigint(20) DEFAULT NULL,
  `codice_embed` char(128) DEFAULT NULL,
  `embed_custom` char(128) DEFAULT NULL,
  `target` char(255) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_pagina` (`id_pagina`),
  KEY `id_file` (`id_file`),
  KEY `id_prodotto` (`id_prodotto`),
  KEY `id_articolo` (`id_articolo`),
  KEY `id_categoria_prodotti` (`id_categoria_prodotti`),
  KEY `id_marchio` (`id_marchio`),
  KEY `id_risorsa` (`id_risorsa`),
  KEY `id_categoria_risorse` (`id_categoria_risorse`),
  KEY `id_notizia` (`id_notizia`),
  KEY `id_annuncio` (`id_annuncio`),
  KEY `id_categoria_notizie` (`id_categoria_notizie`),
  KEY `id_categoria_annunci` (`id_categoria_annunci`),
  KEY `id_lingua` (`id_lingua`),
  KEY `id_ruolo` (`id_ruolo`),
  KEY `id_progetto` (`id_progetto`),
  KEY `id_categoria_progetti` (`id_categoria_progetti`),
  KEY `id_indirizzo` (`id_indirizzo`),
  KEY `id_edificio` (`id_edificio`),
  KEY `id_immobile` (`id_immobile`),
  KEY `id_valutazione` (`id_valutazione`),
  KEY `id_embed` (`id_embed`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609251001

-- le colonne che la tabella vecchia non aveva, per i deploy installati prima di marzo
ALTER TABLE `audio`
	ADD COLUMN IF NOT EXISTS `id_marchio` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_categoria_risorse` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_valutazione` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `note` text DEFAULT NULL,
	ADD KEY IF NOT EXISTS `id_marchio` (`id_marchio`),
	ADD KEY IF NOT EXISTS `id_categoria_risorse` (`id_categoria_risorse`),
	ADD KEY IF NOT EXISTS `id_valutazione` (`id_valutazione`);

-- | 202609251002

-- ruoli_audio
CREATE TABLE IF NOT EXISTS `ruoli_audio` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_genitore` bigint(20) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_anagrafica` tinyint(1) DEFAULT NULL,
  `se_pagine` tinyint(1) DEFAULT NULL,
  `se_prodotti` tinyint(1) DEFAULT NULL,
  `se_articoli` tinyint(1) DEFAULT NULL,
  `se_categorie_prodotti` tinyint(1) DEFAULT NULL,
  `se_marchi` tinyint(1) DEFAULT NULL,
  `se_notizie` tinyint(1) DEFAULT NULL,
  `se_categorie_notizie` tinyint(1) DEFAULT NULL,
  `se_risorse` tinyint(1) DEFAULT NULL,
  `se_categorie_risorse` tinyint(1) DEFAULT NULL,
  `se_immobili` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_genitore` (`id_genitore`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609251003

-- il flag che la tabella vecchia non aveva
ALTER TABLE `ruoli_audio`
	ADD COLUMN IF NOT EXISTS `se_marchi` tinyint(1) DEFAULT NULL AFTER `se_categorie_prodotti`;

-- | 202609251004

-- ruoli_audio
INSERT IGNORE INTO `ruoli_audio` (`id`, `id_genitore`, `nome`, `html_entity`, `font_awesome`, `se_anagrafica`, `se_pagine`, `se_prodotti`, `se_articoli`, `se_categorie_prodotti`, `se_notizie`, `se_categorie_notizie`, `se_risorse`, `se_categorie_risorse`, `se_immobili`) VALUES
(1,	NULL,	'audio',	NULL,	NULL,	1,	1,	1,	1,	1,	NULL,	NULL,	NULL,	NULL,	1),
(2,	NULL,	'commento',	NULL,	NULL,	NULL,	1,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	1);

-- | 202609251010

-- ruoli_audio_path
DROP FUNCTION IF EXISTS `ruoli_audio_path`;

-- | 202609251011

-- ruoli_audio_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_audio_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_audio_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_audio.id_genitore,
				ruoli_audio.nome
			FROM ruoli_audio
			WHERE ruoli_audio.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

-- | 202609251012

-- ruoli_audio_path_check
DROP FUNCTION IF EXISTS `ruoli_audio_path_check`;

-- | 202609251013

-- ruoli_audio_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_audio_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT ruoli_audio_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				ruoli_audio.id_genitore
			FROM ruoli_audio
			WHERE ruoli_audio.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

-- | 202609251014

-- ruoli_audio_path_find_ancestor
DROP FUNCTION IF EXISTS `ruoli_audio_path_find_ancestor`;

-- | 202609251015

-- ruoli_audio_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_audio_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_audio_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_audio.id_genitore,
				ruoli_audio.id
			FROM ruoli_audio
			WHERE ruoli_audio.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

-- | 202609251020

-- ruoli_audio_view
CREATE OR REPLACE VIEW ruoli_audio_view AS
	SELECT
		ruoli_audio.id,
		ruoli_audio.id_genitore,
		ruoli_audio.nome,
		ruoli_audio.html_entity,
		ruoli_audio.font_awesome,
		ruoli_audio.se_anagrafica,
		ruoli_audio.se_pagine,
		ruoli_audio.se_prodotti,
		ruoli_audio.se_articoli,
		ruoli_audio.se_categorie_prodotti,
		ruoli_audio.se_marchi,
		ruoli_audio.se_notizie,
		ruoli_audio.se_categorie_notizie,
		ruoli_audio.se_risorse,
		ruoli_audio.se_categorie_risorse,
		ruoli_audio.se_immobili,
	 	ruoli_audio_path( ruoli_audio.id ) AS __label__
	FROM ruoli_audio
;

-- | 202609251021

-- audio_view
CREATE OR REPLACE VIEW `audio_view` AS
	SELECT
		audio.id,
		audio.id_anagrafica,
		audio.id_pagina,
		audio.id_file,
		audio.id_prodotto,
		audio.id_articolo,
		audio.id_categoria_prodotti,
		audio.id_marchio,
		audio.id_risorsa,
		audio.id_categoria_risorse,
		audio.id_notizia,
		audio.id_annuncio,
		audio.id_categoria_notizie,
		audio.id_categoria_annunci,
		audio.id_lingua,
		lingue.nome AS lingua,
		audio.id_ruolo,
		audio.id_progetto,
		audio.id_categoria_progetti,
		audio.id_indirizzo,
		audio.id_edificio,
		audio.id_immobile,
		audio.id_valutazione,
		ruoli_audio.nome AS ruolo,
		audio.ordine,
		audio.nome,
		audio.path,
		audio.id_embed,
		audio.codice_embed,
		audio.embed_custom,
		audio.target,
		audio.note,
		audio.id_account_inserimento,
		audio.id_account_aggiornamento,
		concat(
			ruoli_audio.nome,
			' # ',
			audio.ordine,
			' / ',
			audio.nome
		) AS __label__
	FROM audio
		LEFT JOIN lingue ON lingue.id = audio.id_lingua
		LEFT JOIN ruoli_audio ON ruoli_audio.id = audio.id_ruolo
;

-- | FINE FILE
