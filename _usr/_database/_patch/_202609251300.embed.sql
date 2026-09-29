-- 2026-09-25 — audio.id_embed e video.id_embed diventano l'enum embed
--
-- Contesto: id_embed era la chiave esterna verso la tabella standard embed ( 1 = HTML5, 2 = Vimeo,
-- 3 = YouTube, gli unici tre valori che abbia mai avuto ), che il riallineamento del 02/03/2026
-- ( commit d975b4a15 ) ha tolto dai file di base insieme a embed_view. Da allora i form usano un
-- elenco fisso e le macro Twig confrontano il numero con 2 e 3: una tabella di tre righe che nessuno
-- modifica e' un enum, e cosi' si dichiara nello schema, come orientamento, sesso e porto.
--
-- IL NOME. La colonna si chiama embed e non piu' id_embed perche' nello schema il prefisso id_ vuol
-- dire "chiave esterna verso la tabella che segue", e una tabella embed non c'e' piu'. Le altre colonne
-- enum hanno il nome della cosa che descrivono ( orientamento, sesso, porto, esigibilita ), e embed e'
-- anche il nome che la colonna aveva gia' in audio_view prima di marzo ( embed.nome AS embed ).
--
-- I VALORI sono in minuscolo, come quelli a parole di porto ( 'franco', 'assegnato' ): 'html5',
-- 'vimeo' e 'youtube'. La conversione e' 1 -> html5, 2 -> vimeo, 3 -> youtube, dai dati standard della
-- tabella embed ( _050000999999.data.sql prima di d975b4a15 ).
--
-- IDEMPOTENZA. La colonna nuova arriva con ADD COLUMN IF NOT EXISTS; la conversione, e la rimozione
-- delle chiavi esterne che un deploy installato prima di marzo ha ancora su id_embed, sono dentro un
-- PREPARE guardato da information_schema, come in _202609151510.sedi.inline.backfill.sql: dove id_embed
-- non c'e' piu' ( patch gia' girata, o schema nuovo ) non fanno niente e lo dicono. L'UPDATE tocca solo
-- le righe con embed ancora vuoto, quindi non sovrascrive mai un valore gia' convertito. La tabella
-- embed e la sua vista si tolgono con IF EXISTS, dopo che nessuna chiave esterna punta piu' a loro.
-- ADD COLUMN IF NOT EXISTS e DROP COLUMN IF EXISTS sono di MariaDB, come nelle altre patch del 2026.

-- | 202609251300

-- audio, la colonna nuova
ALTER TABLE `audio`
	ADD COLUMN IF NOT EXISTS `embed` enum('html5','vimeo','youtube') DEFAULT NULL AFTER `path`;

-- | 202609251301

-- audio, conversione dei valori di id_embed
SET @embed = IF(
    EXISTS (
        SELECT 1 FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = database()
          AND TABLE_NAME   = 'audio'
          AND COLUMN_NAME  = 'id_embed'
    ),
    "UPDATE audio SET embed = CASE id_embed WHEN 1 THEN 'html5' WHEN 2 THEN 'vimeo' WHEN 3 THEN 'youtube' END
WHERE embed IS NULL AND id_embed IS NOT NULL",
    "SELECT 'audio non ha id_embed: niente da convertire' AS nota"
);

-- | 202609251302

-- si prepara
PREPARE embed FROM @embed;

-- | 202609251303

-- si esegue
EXECUTE embed;

-- | 202609251304

-- e si libera
DEALLOCATE PREPARE embed;

-- | 202609251305

-- audio, le chiavi esterne rimaste su id_embed ( audio_ibfk_03_nofollow sui deploy di prima di marzo )
SET @embed = (
    SELECT IFNULL(
        CONCAT( 'ALTER TABLE `audio` ', GROUP_CONCAT( CONCAT( 'DROP FOREIGN KEY `', CONSTRAINT_NAME, '`' ) SEPARATOR ', ' ) ),
        "SELECT 'audio non ha chiavi esterne su id_embed' AS nota"
    )
    FROM information_schema.KEY_COLUMN_USAGE
    WHERE TABLE_SCHEMA = database()
      AND TABLE_NAME   = 'audio'
      AND COLUMN_NAME  = 'id_embed'
      AND REFERENCED_TABLE_NAME IS NOT NULL
);

-- | 202609251306

-- si prepara
PREPARE embed FROM @embed;

-- | 202609251307

-- si esegue
EXECUTE embed;

-- | 202609251308

-- e si libera
DEALLOCATE PREPARE embed;

-- | 202609251309

-- audio, via la colonna vecchia ( il suo indice se ne va con lei )
ALTER TABLE `audio`
	DROP COLUMN IF EXISTS `id_embed`;

-- | 202609251310

-- video, la colonna nuova
ALTER TABLE `video`
	ADD COLUMN IF NOT EXISTS `embed` enum('html5','vimeo','youtube') DEFAULT NULL AFTER `path`;

-- | 202609251311

-- video, conversione dei valori di id_embed
SET @embed = IF(
    EXISTS (
        SELECT 1 FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = database()
          AND TABLE_NAME   = 'video'
          AND COLUMN_NAME  = 'id_embed'
    ),
    "UPDATE video SET embed = CASE id_embed WHEN 1 THEN 'html5' WHEN 2 THEN 'vimeo' WHEN 3 THEN 'youtube' END
WHERE embed IS NULL AND id_embed IS NOT NULL",
    "SELECT 'video non ha id_embed: niente da convertire' AS nota"
);

-- | 202609251312

-- si prepara
PREPARE embed FROM @embed;

-- | 202609251313

-- si esegue
EXECUTE embed;

-- | 202609251314

-- e si libera
DEALLOCATE PREPARE embed;

-- | 202609251315

-- video, le chiavi esterne rimaste su id_embed ( video_ibfk_15_nofollow sui deploy di prima di marzo )
SET @embed = (
    SELECT IFNULL(
        CONCAT( 'ALTER TABLE `video` ', GROUP_CONCAT( CONCAT( 'DROP FOREIGN KEY `', CONSTRAINT_NAME, '`' ) SEPARATOR ', ' ) ),
        "SELECT 'video non ha chiavi esterne su id_embed' AS nota"
    )
    FROM information_schema.KEY_COLUMN_USAGE
    WHERE TABLE_SCHEMA = database()
      AND TABLE_NAME   = 'video'
      AND COLUMN_NAME  = 'id_embed'
      AND REFERENCED_TABLE_NAME IS NOT NULL
);

-- | 202609251316

-- si prepara
PREPARE embed FROM @embed;

-- | 202609251317

-- si esegue
EXECUTE embed;

-- | 202609251318

-- e si libera
DEALLOCATE PREPARE embed;

-- | 202609251319

-- video, via la colonna vecchia ( il suo indice se ne va con lei )
ALTER TABLE `video`
	DROP COLUMN IF EXISTS `id_embed`;

-- | 202609251320

-- la tabella embed e la sua vista, dove un deploy di prima di marzo le ha ancora
DROP VIEW IF EXISTS `embed_view`;

-- | 202609251321

DROP TABLE IF EXISTS `embed`;

-- | 202609251330

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
		audio.embed,
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

-- | 202609251331

-- video_view
CREATE OR REPLACE VIEW `video_view` AS
	SELECT
		video.id,
		video.id_anagrafica,
		video.id_pagina,
		video.id_file,
		video.id_prodotto,
		video.id_articolo,
		video.id_categoria_prodotti,
		video.id_marchio,
		video.id_risorsa,
		video.id_categoria_risorse,
		video.id_notizia,
		video.id_annuncio,
		video.id_categoria_notizie,
		video.id_categoria_annunci,
		video.id_lingua,
		lingue.nome AS lingua,
		video.id_ruolo,
		video.id_progetto,
		video.id_categoria_progetti,
		video.id_indirizzo,
		video.id_edificio,
		video.id_immobile,
		video.id_valutazione,
		ruoli_video.nome AS ruolo,
		video.ordine,
		video.nome,
		video.path,
		video.embed,
		video.codice_embed,
		video.embed_custom,
		video.target,
		video.orientamento,
		video.ratio,
		video.note,
		video.id_account_inserimento,
		video.id_account_aggiornamento,
		concat(
			ruoli_video.nome,
			' # ',
			video.ordine,
			' / ',
			video.nome
		) AS __label__
	FROM video
		LEFT JOIN lingue ON lingue.id = video.id_lingua
		LEFT JOIN ruoli_video ON ruoli_video.id = video.id_ruolo
;

-- | FINE FILE
