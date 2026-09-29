-- 2026-09-30 — le patch con PREPARE, rieseguite
--
-- Contesto: fino al 29/09/2026 mysqlQuery() ( _src/_lib/_mysql.tools.php ) non riconosceva PREPARE, EXECUTE e
-- DEALLOCATE: li scriveva nel log come comando sconosciuto e restituiva false senza errore, e
-- _src/_api/_task/_mysql.patch.php registrava il blocco in __patch__ come eseguito. Le operazioni che le patch
-- mettono dentro un PREPARE guardato da information_schema, cioe' proprio quelle che dipendono dallo schema,
-- sui deploy aggiornati dal task non sono mai state fatte. I file interessati:
--
--   _202609151510.sedi.inline.backfill.sql, _202609251300.embed.sql, _202609251500.pianificazioni.genitore.sql,
--   _202609291400.report.sottoscorta.sql, _202609291500.chiavi.primarie.sql,
--   _202609291600.tabelle.fuori.base.sql, _202609291900.tabelle.riallineamento.sql
--
-- mysqlQuery() adesso li esegue; qui si ripetono, nell'ordine originale, tutti i gruppi SET / PREPARE / EXECUTE /
-- DEALLOCATE di quei file. Sono idempotenti per costruzione: ogni guardia rilegge lo schema e, dove l'operazione
-- e' gia' stata fatta ( sui deploy aggiornati a mano, o da _database.rebuild.check.sh che usa mysqli
-- direttamente ), non fa niente e lo dice.
--
-- I marcatori saltano i minuti oltre il 59 perche' restino orari validi.

-- | 202609300100

-- da _202609151510.sedi.inline.backfill.sql ( 202609151510 )
-- il backfill vero e proprio
SET @backfill = IF(
    EXISTS (
        SELECT 1 FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = database()
          AND TABLE_NAME   = 'anagrafica_indirizzi'
          AND COLUMN_NAME  = 'id_comune'
    ),
    "UPDATE anagrafica_indirizzi ai
JOIN indirizzi i ON i.id = ai.id_indirizzo
SET ai.id_comune = COALESCE( ai.id_comune, i.id_comune ),
    ai.indirizzo = COALESCE( NULLIF( ai.indirizzo, '' ), i.indirizzo ),
    ai.civico    = COALESCE( NULLIF( ai.civico, '' ), i.civico ),
    ai.cap       = COALESCE( NULLIF( ai.cap, '' ), i.cap ),
    ai.localita  = COALESCE( NULLIF( ai.localita, '' ), i.localita )
WHERE ai.id_indirizzo IS NOT NULL
  AND ( ai.id_comune IS NULL OR ai.indirizzo IS NULL OR ai.indirizzo = '' )
  AND NOT EXISTS (
      SELECT 1 FROM ( SELECT id, id_anagrafica, indirizzo FROM anagrafica_indirizzi ) x
      WHERE x.id_anagrafica = ai.id_anagrafica
        AND x.id <> ai.id
        AND x.indirizzo = COALESCE( NULLIF( ai.indirizzo, '' ), i.indirizzo )
  )",
    "SELECT 'anagrafica_indirizzi non ha id_comune: schema precedente al 2026-07-10, niente da backfillare' AS nota"
);

-- | 202609300101

-- da _202609151510.sedi.inline.backfill.sql
-- si prepara
PREPARE backfill FROM @backfill;

-- | 202609300102

-- da _202609151510.sedi.inline.backfill.sql
-- si esegue
EXECUTE backfill;

-- | 202609300103

-- da _202609151510.sedi.inline.backfill.sql
-- e si libera
DEALLOCATE PREPARE backfill;

-- | 202609300104

-- da _202609251300.embed.sql ( 202609251301 )
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

-- | 202609300105

-- da _202609251300.embed.sql
-- si prepara
PREPARE embed FROM @embed;

-- | 202609300106

-- da _202609251300.embed.sql
-- si esegue
EXECUTE embed;

-- | 202609300107

-- da _202609251300.embed.sql
-- e si libera
DEALLOCATE PREPARE embed;

-- | 202609300108

-- da _202609251300.embed.sql ( 202609251305 )
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

-- | 202609300109

-- da _202609251300.embed.sql
-- si prepara
PREPARE embed FROM @embed;

-- | 202609300110

-- da _202609251300.embed.sql
-- si esegue
EXECUTE embed;

-- | 202609300111

-- da _202609251300.embed.sql
-- e si libera
DEALLOCATE PREPARE embed;

-- | 202609300112

-- da _202609251300.embed.sql ( 202609251311 )
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

-- | 202609300113

-- da _202609251300.embed.sql
-- si prepara
PREPARE embed FROM @embed;

-- | 202609300114

-- da _202609251300.embed.sql
-- si esegue
EXECUTE embed;

-- | 202609300115

-- da _202609251300.embed.sql
-- e si libera
DEALLOCATE PREPARE embed;

-- | 202609300116

-- da _202609251300.embed.sql ( 202609251315 )
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

-- | 202609300117

-- da _202609251300.embed.sql
-- si prepara
PREPARE embed FROM @embed;

-- | 202609300118

-- da _202609251300.embed.sql
-- si esegue
EXECUTE embed;

-- | 202609300119

-- da _202609251300.embed.sql
-- e si libera
DEALLOCATE PREPARE embed;

-- | 202609300120

-- da _202609251500.pianificazioni.genitore.sql ( 202609251500 )
-- la chiave, se manca e se si puo' aggiungere
SET @genitore = IF(
    EXISTS (
        SELECT 1 FROM information_schema.KEY_COLUMN_USAGE
        WHERE TABLE_SCHEMA = database()
          AND TABLE_NAME   = 'pianificazioni'
          AND COLUMN_NAME  = 'id_genitore'
          AND REFERENCED_TABLE_NAME IS NOT NULL
    ),
    "SELECT 'pianificazioni ha gia'' una chiave esterna su id_genitore' AS nota",
    IF(
        (
            SELECT COLUMN_TYPE FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'pianificazioni' AND COLUMN_NAME = 'id_genitore'
        ) <=> (
            SELECT COLUMN_TYPE FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'pianificazioni' AND COLUMN_NAME = 'id'
        )
        AND EXISTS (
            SELECT 1 FROM information_schema.KEY_COLUMN_USAGE
            WHERE TABLE_SCHEMA    = database()
              AND TABLE_NAME      = 'pianificazioni'
              AND COLUMN_NAME     = 'id'
              AND CONSTRAINT_NAME = 'PRIMARY'
        ),
        IF(
            EXISTS (
                SELECT 1 FROM pianificazioni AS figlie
                LEFT JOIN pianificazioni AS genitori ON genitori.id = figlie.id_genitore
                WHERE figlie.id_genitore IS NOT NULL AND genitori.id IS NULL
            ),
            "SELECT 'pianificazioni ha righe con un id_genitore che non esiste: chiave non aggiunta' AS nota",
            "ALTER TABLE `pianificazioni`
    ADD CONSTRAINT `pianificazioni_ibfk_00` FOREIGN KEY (`id_genitore`) REFERENCES `pianificazioni` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE"
        ),
        "SELECT 'pianificazioni.id_genitore e pianificazioni.id hanno tipi diversi, o id non e'' la chiave primaria: chiave non aggiunta' AS nota"
    )
);

-- | 202609300121

-- da _202609251500.pianificazioni.genitore.sql
-- si prepara
PREPARE genitore FROM @genitore;

-- | 202609300122

-- da _202609251500.pianificazioni.genitore.sql
-- si esegue
EXECUTE genitore;

-- | 202609300123

-- da _202609251500.pianificazioni.genitore.sql
-- e si libera
DEALLOCATE PREPARE genitore;

-- | 202609300124

-- da _202609291400.report.sottoscorta.sql ( 202609291400 )
-- la soglia si dichiara nell'unita' del magazzino ( "12 scatole" ) e il task la converte
-- nell'unita' inventariale per confrontarla con la giacenza: serve sapere in quale unita' e'
-- stata scritta, altrimenti chi ha scritto 12 si rilegge 2.400 senza un appiglio.
--
-- L'ALTER E' DENTRO UN PREPARE, come in _202609151510.sedi.inline.backfill.sql: i file di base oggi
-- non creano mastri_articoli ( la tabella e' uscita dai file di base nel riallineamento del
-- 02/03/2026 ) e dove manca, o manca la colonna scorta_massima dopo cui id_udm si aggiunge, un ALTER
-- statico fermerebbe il task e ogni patch successiva. Li' la patch non fa niente e lo dice.
SET @sottoscorta = IF(
    EXISTS (
        SELECT 1 FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = database()
          AND TABLE_NAME   = 'mastri_articoli'
          AND COLUMN_NAME  = 'scorta_massima'
    ),
    "ALTER TABLE `mastri_articoli`
	ADD COLUMN IF NOT EXISTS `id_udm` bigint(20) DEFAULT NULL AFTER `scorta_massima`,
	ADD KEY IF NOT EXISTS `id_udm` (`id_udm`)",
    "SELECT 'mastri_articoli non ha scorta_massima: niente id_udm da aggiungere' AS nota"
);

-- | 202609300125

-- da _202609291400.report.sottoscorta.sql
-- si prepara
PREPARE sottoscorta FROM @sottoscorta;

-- | 202609300126

-- da _202609291400.report.sottoscorta.sql
-- si esegue
EXECUTE sottoscorta;

-- | 202609300127

-- da _202609291400.report.sottoscorta.sql
-- si libera
DEALLOCATE PREPARE sottoscorta;

-- | 202609300128

-- da _202609291500.chiavi.primarie.sql ( 202609291500 )
-- mastri_articoli, i doppioni
SET @chiavi = IF(
    EXISTS (
        SELECT 1 FROM information_schema.TABLES
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'mastri_articoli'
    ) AND NOT EXISTS (
        SELECT 1 FROM information_schema.TABLE_CONSTRAINTS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'mastri_articoli' AND CONSTRAINT_TYPE = 'PRIMARY KEY'
    ),
    "SELECT count(*) - count( DISTINCT `id` ) INTO @doppioni FROM `mastri_articoli`",
    "SELECT 0 INTO @doppioni"
);

-- | 202609300129

-- da _202609291500.chiavi.primarie.sql
PREPARE chiavi FROM @chiavi;

-- | 202609300130

-- da _202609291500.chiavi.primarie.sql
EXECUTE chiavi;

-- | 202609300131

-- da _202609291500.chiavi.primarie.sql
DEALLOCATE PREPARE chiavi;

-- | 202609300132

-- da _202609291500.chiavi.primarie.sql ( 202609291504 )
-- mastri_articoli, la chiave
SET @chiavi = IF(
    EXISTS (
        SELECT 1 FROM information_schema.TABLES
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'mastri_articoli'
    ) AND NOT EXISTS (
        SELECT 1 FROM information_schema.TABLE_CONSTRAINTS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'mastri_articoli' AND CONSTRAINT_TYPE = 'PRIMARY KEY'
    ) AND @doppioni = 0,
    "ALTER TABLE `mastri_articoli` ADD PRIMARY KEY (`id`), ADD KEY IF NOT EXISTS `id_mastro` (`id_mastro`), ADD KEY IF NOT EXISTS `id_articolo` (`id_articolo`), ADD KEY IF NOT EXISTS `id_ruolo` (`id_ruolo`), ADD KEY IF NOT EXISTS `id_udm` (`id_udm`), ADD KEY IF NOT EXISTS `ordine` (`ordine`), ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`), ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`), MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT",
    IF( @doppioni > 0,
        "SELECT 'mastri_articoli ha id o coppie ripetuti: chiave primaria non aggiunta, i doppioni vanno risolti a mano' AS nota",
        "SELECT 'mastri_articoli ha la chiave primaria o non esiste: niente da fare' AS nota" )
);

-- | 202609300133

-- da _202609291500.chiavi.primarie.sql
PREPARE chiavi FROM @chiavi;

-- | 202609300134

-- da _202609291500.chiavi.primarie.sql
EXECUTE chiavi;

-- | 202609300135

-- da _202609291500.chiavi.primarie.sql
DEALLOCATE PREPARE chiavi;

-- | 202609300136

-- da _202609291500.chiavi.primarie.sql ( 202609291508 )
-- mastri_tipologie_veicoli, i doppioni
SET @chiavi = IF(
    EXISTS (
        SELECT 1 FROM information_schema.TABLES
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'mastri_tipologie_veicoli'
    ) AND NOT EXISTS (
        SELECT 1 FROM information_schema.TABLE_CONSTRAINTS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'mastri_tipologie_veicoli' AND CONSTRAINT_TYPE = 'PRIMARY KEY'
    ),
    "SELECT ( SELECT count(*) - count( DISTINCT `id` ) FROM `mastri_tipologie_veicoli` ) + ( SELECT count(*) FROM ( SELECT 1 FROM `mastri_tipologie_veicoli` WHERE `id_mastro` IS NOT NULL AND `id_tipologia` IS NOT NULL GROUP BY `id_mastro`, `id_tipologia` HAVING count(*) > 1 ) AS d ) INTO @doppioni",
    "SELECT 0 INTO @doppioni"
);

-- | 202609300137

-- da _202609291500.chiavi.primarie.sql
PREPARE chiavi FROM @chiavi;

-- | 202609300138

-- da _202609291500.chiavi.primarie.sql
EXECUTE chiavi;

-- | 202609300139

-- da _202609291500.chiavi.primarie.sql
DEALLOCATE PREPARE chiavi;

-- | 202609300140

-- da _202609291500.chiavi.primarie.sql ( 202609291512 )
-- mastri_tipologie_veicoli, la chiave
SET @chiavi = IF(
    EXISTS (
        SELECT 1 FROM information_schema.TABLES
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'mastri_tipologie_veicoli'
    ) AND NOT EXISTS (
        SELECT 1 FROM information_schema.TABLE_CONSTRAINTS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'mastri_tipologie_veicoli' AND CONSTRAINT_TYPE = 'PRIMARY KEY'
    ) AND @doppioni = 0,
    "ALTER TABLE `mastri_tipologie_veicoli` ADD PRIMARY KEY (`id`), ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_mastro`,`id_tipologia`), ADD KEY IF NOT EXISTS `id_mastro` (`id_mastro`), ADD KEY IF NOT EXISTS `id_tipologia` (`id_tipologia`), ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`), ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`), MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT",
    IF( @doppioni > 0,
        "SELECT 'mastri_tipologie_veicoli ha id o coppie ripetuti: chiave primaria non aggiunta, i doppioni vanno risolti a mano' AS nota",
        "SELECT 'mastri_tipologie_veicoli ha la chiave primaria o non esiste: niente da fare' AS nota" )
);

-- | 202609300141

-- da _202609291500.chiavi.primarie.sql
PREPARE chiavi FROM @chiavi;

-- | 202609300142

-- da _202609291500.chiavi.primarie.sql
EXECUTE chiavi;

-- | 202609300143

-- da _202609291500.chiavi.primarie.sql
DEALLOCATE PREPARE chiavi;

-- | 202609300144

-- da _202609291500.chiavi.primarie.sql ( 202609291516 )
-- tipologie_colli, i doppioni
SET @chiavi = IF(
    EXISTS (
        SELECT 1 FROM information_schema.TABLES
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'tipologie_colli'
    ) AND NOT EXISTS (
        SELECT 1 FROM information_schema.TABLE_CONSTRAINTS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'tipologie_colli' AND CONSTRAINT_TYPE = 'PRIMARY KEY'
    ),
    "SELECT ( SELECT count(*) - count( DISTINCT `id` ) FROM `tipologie_colli` ) + ( SELECT count(*) FROM ( SELECT 1 FROM `tipologie_colli` WHERE `id_genitore` IS NOT NULL AND `nome` IS NOT NULL GROUP BY `id_genitore`, `nome` HAVING count(*) > 1 ) AS d ) INTO @doppioni",
    "SELECT 0 INTO @doppioni"
);

-- | 202609300145

-- da _202609291500.chiavi.primarie.sql
PREPARE chiavi FROM @chiavi;

-- | 202609300146

-- da _202609291500.chiavi.primarie.sql
EXECUTE chiavi;

-- | 202609300147

-- da _202609291500.chiavi.primarie.sql
DEALLOCATE PREPARE chiavi;

-- | 202609300148

-- da _202609291500.chiavi.primarie.sql ( 202609291520 )
-- tipologie_colli, la chiave
SET @chiavi = IF(
    EXISTS (
        SELECT 1 FROM information_schema.TABLES
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'tipologie_colli'
    ) AND NOT EXISTS (
        SELECT 1 FROM information_schema.TABLE_CONSTRAINTS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'tipologie_colli' AND CONSTRAINT_TYPE = 'PRIMARY KEY'
    ) AND @doppioni = 0,
    "ALTER TABLE `tipologie_colli` ADD PRIMARY KEY (`id`), ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_genitore`,`nome`), ADD KEY IF NOT EXISTS `id_genitore` (`id_genitore`), ADD KEY IF NOT EXISTS `ordine` (`ordine`), ADD KEY IF NOT EXISTS `nome` (`nome`), ADD KEY IF NOT EXISTS `sigla` (`sigla`), ADD KEY IF NOT EXISTS `id_udm_dimensioni` (`id_udm_dimensioni`), ADD KEY IF NOT EXISTS `id_udm_peso` (`id_udm_peso`), ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`), ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`), MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT",
    IF( @doppioni > 0,
        "SELECT 'tipologie_colli ha id o coppie ripetuti: chiave primaria non aggiunta, i doppioni vanno risolti a mano' AS nota",
        "SELECT 'tipologie_colli ha la chiave primaria o non esiste: niente da fare' AS nota" )
);

-- | 202609300149

-- da _202609291500.chiavi.primarie.sql
PREPARE chiavi FROM @chiavi;

-- | 202609300150

-- da _202609291500.chiavi.primarie.sql
EXECUTE chiavi;

-- | 202609300151

-- da _202609291500.chiavi.primarie.sql
DEALLOCATE PREPARE chiavi;

-- | 202609300152

-- da _202609291500.chiavi.primarie.sql ( 202609291524 )
-- tipologie_listini, i doppioni
SET @chiavi = IF(
    EXISTS (
        SELECT 1 FROM information_schema.TABLES
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'tipologie_listini'
    ) AND NOT EXISTS (
        SELECT 1 FROM information_schema.TABLE_CONSTRAINTS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'tipologie_listini' AND CONSTRAINT_TYPE = 'PRIMARY KEY'
    ),
    "SELECT ( SELECT count(*) - count( DISTINCT `id` ) FROM `tipologie_listini` ) + ( SELECT count(*) FROM ( SELECT 1 FROM `tipologie_listini` WHERE `id_genitore` IS NOT NULL AND `nome` IS NOT NULL GROUP BY `id_genitore`, `nome` HAVING count(*) > 1 ) AS d ) INTO @doppioni",
    "SELECT 0 INTO @doppioni"
);

-- | 202609300153

-- da _202609291500.chiavi.primarie.sql
PREPARE chiavi FROM @chiavi;

-- | 202609300154

-- da _202609291500.chiavi.primarie.sql
EXECUTE chiavi;

-- | 202609300155

-- da _202609291500.chiavi.primarie.sql
DEALLOCATE PREPARE chiavi;

-- | 202609300156

-- da _202609291500.chiavi.primarie.sql ( 202609291528 )
-- tipologie_listini, la chiave
SET @chiavi = IF(
    EXISTS (
        SELECT 1 FROM information_schema.TABLES
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'tipologie_listini'
    ) AND NOT EXISTS (
        SELECT 1 FROM information_schema.TABLE_CONSTRAINTS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'tipologie_listini' AND CONSTRAINT_TYPE = 'PRIMARY KEY'
    ) AND @doppioni = 0,
    "ALTER TABLE `tipologie_listini` ADD PRIMARY KEY (`id`), ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_genitore`,`nome`), ADD KEY IF NOT EXISTS `id_genitore` (`id_genitore`), ADD KEY IF NOT EXISTS `ordine` (`ordine`), ADD KEY IF NOT EXISTS `nome` (`nome`), ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`), ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`), MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT",
    IF( @doppioni > 0,
        "SELECT 'tipologie_listini ha id o coppie ripetuti: chiave primaria non aggiunta, i doppioni vanno risolti a mano' AS nota",
        "SELECT 'tipologie_listini ha la chiave primaria o non esiste: niente da fare' AS nota" )
);

-- | 202609300157

-- da _202609291500.chiavi.primarie.sql
PREPARE chiavi FROM @chiavi;

-- | 202609300158

-- da _202609291500.chiavi.primarie.sql
EXECUTE chiavi;

-- | 202609300159

-- da _202609291500.chiavi.primarie.sql
DEALLOCATE PREPARE chiavi;

-- | 202609300200

-- da _202609291500.chiavi.primarie.sql ( 202609291532 )
-- tipologie_veicoli, i doppioni
SET @chiavi = IF(
    EXISTS (
        SELECT 1 FROM information_schema.TABLES
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'tipologie_veicoli'
    ) AND NOT EXISTS (
        SELECT 1 FROM information_schema.TABLE_CONSTRAINTS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'tipologie_veicoli' AND CONSTRAINT_TYPE = 'PRIMARY KEY'
    ),
    "SELECT ( SELECT count(*) - count( DISTINCT `id` ) FROM `tipologie_veicoli` ) + ( SELECT count(*) FROM ( SELECT 1 FROM `tipologie_veicoli` WHERE `id_genitore` IS NOT NULL AND `nome` IS NOT NULL GROUP BY `id_genitore`, `nome` HAVING count(*) > 1 ) AS d ) INTO @doppioni",
    "SELECT 0 INTO @doppioni"
);

-- | 202609300201

-- da _202609291500.chiavi.primarie.sql
PREPARE chiavi FROM @chiavi;

-- | 202609300202

-- da _202609291500.chiavi.primarie.sql
EXECUTE chiavi;

-- | 202609300203

-- da _202609291500.chiavi.primarie.sql
DEALLOCATE PREPARE chiavi;

-- | 202609300204

-- da _202609291500.chiavi.primarie.sql ( 202609291536 )
-- tipologie_veicoli, la chiave
SET @chiavi = IF(
    EXISTS (
        SELECT 1 FROM information_schema.TABLES
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'tipologie_veicoli'
    ) AND NOT EXISTS (
        SELECT 1 FROM information_schema.TABLE_CONSTRAINTS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'tipologie_veicoli' AND CONSTRAINT_TYPE = 'PRIMARY KEY'
    ) AND @doppioni = 0,
    "ALTER TABLE `tipologie_veicoli` ADD PRIMARY KEY (`id`), ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_genitore`,`nome`), ADD KEY IF NOT EXISTS `id_genitore` (`id_genitore`), ADD KEY IF NOT EXISTS `ordine` (`ordine`), ADD KEY IF NOT EXISTS `nome` (`nome`), ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`), ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`), MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT",
    IF( @doppioni > 0,
        "SELECT 'tipologie_veicoli ha id o coppie ripetuti: chiave primaria non aggiunta, i doppioni vanno risolti a mano' AS nota",
        "SELECT 'tipologie_veicoli ha la chiave primaria o non esiste: niente da fare' AS nota" )
);

-- | 202609300205

-- da _202609291500.chiavi.primarie.sql
PREPARE chiavi FROM @chiavi;

-- | 202609300206

-- da _202609291500.chiavi.primarie.sql
EXECUTE chiavi;

-- | 202609300207

-- da _202609291500.chiavi.primarie.sql
DEALLOCATE PREPARE chiavi;

-- | 202609300208

-- da _202609291500.chiavi.primarie.sql ( 202609291540 )
-- veicoli, i doppioni
SET @chiavi = IF(
    EXISTS (
        SELECT 1 FROM information_schema.TABLES
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'veicoli'
    ) AND NOT EXISTS (
        SELECT 1 FROM information_schema.TABLE_CONSTRAINTS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'veicoli' AND CONSTRAINT_TYPE = 'PRIMARY KEY'
    ),
    "SELECT count(*) - count( DISTINCT `id` ) INTO @doppioni FROM `veicoli`",
    "SELECT 0 INTO @doppioni"
);

-- | 202609300209

-- da _202609291500.chiavi.primarie.sql
PREPARE chiavi FROM @chiavi;

-- | 202609300210

-- da _202609291500.chiavi.primarie.sql
EXECUTE chiavi;

-- | 202609300211

-- da _202609291500.chiavi.primarie.sql
DEALLOCATE PREPARE chiavi;

-- | 202609300212

-- da _202609291500.chiavi.primarie.sql ( 202609291544 )
-- veicoli, la chiave
SET @chiavi = IF(
    EXISTS (
        SELECT 1 FROM information_schema.TABLES
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'veicoli'
    ) AND NOT EXISTS (
        SELECT 1 FROM information_schema.TABLE_CONSTRAINTS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'veicoli' AND CONSTRAINT_TYPE = 'PRIMARY KEY'
    ) AND @doppioni = 0,
    "ALTER TABLE `veicoli` ADD PRIMARY KEY (`id`), ADD KEY IF NOT EXISTS `id_tipologia` (`id_tipologia`), ADD KEY IF NOT EXISTS `id_costruttore` (`id_costruttore`), ADD KEY IF NOT EXISTS `targa` (`targa`), ADD KEY IF NOT EXISTS `nome` (`nome`), ADD KEY IF NOT EXISTS `data_archiviazione` (`data_archiviazione`), ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`), ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`), MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT",
    IF( @doppioni > 0,
        "SELECT 'veicoli ha id o coppie ripetuti: chiave primaria non aggiunta, i doppioni vanno risolti a mano' AS nota",
        "SELECT 'veicoli ha la chiave primaria o non esiste: niente da fare' AS nota" )
);

-- | 202609300213

-- da _202609291500.chiavi.primarie.sql
PREPARE chiavi FROM @chiavi;

-- | 202609300214

-- da _202609291500.chiavi.primarie.sql
EXECUTE chiavi;

-- | 202609300215

-- da _202609291500.chiavi.primarie.sql
DEALLOCATE PREPARE chiavi;

-- | 202609300216

-- da _202609291500.chiavi.primarie.sql ( 202609291548 )
-- todo_view_static, si svuota se non ha la chiave
SET @chiavi = IF(
    EXISTS (
        SELECT 1 FROM information_schema.TABLES
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'todo_view_static'
    ) AND NOT EXISTS (
        SELECT 1 FROM information_schema.TABLE_CONSTRAINTS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'todo_view_static' AND CONSTRAINT_TYPE = 'PRIMARY KEY'
    ),
    "DELETE FROM `todo_view_static`",
    "SELECT 'todo_view_static ha la chiave primaria o non esiste: niente da fare' AS nota"
);

-- | 202609300217

-- da _202609291500.chiavi.primarie.sql
PREPARE chiavi FROM @chiavi;

-- | 202609300218

-- da _202609291500.chiavi.primarie.sql
EXECUTE chiavi;

-- | 202609300219

-- da _202609291500.chiavi.primarie.sql
DEALLOCATE PREPARE chiavi;

-- | 202609300220

-- da _202609291500.chiavi.primarie.sql ( 202609291552 )
-- todo_view_static, la chiave
SET @chiavi = IF(
    EXISTS (
        SELECT 1 FROM information_schema.TABLES
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'todo_view_static'
    ) AND NOT EXISTS (
        SELECT 1 FROM information_schema.TABLE_CONSTRAINTS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'todo_view_static' AND CONSTRAINT_TYPE = 'PRIMARY KEY'
    ),
    "ALTER TABLE `todo_view_static` ADD PRIMARY KEY (`id`)",
    "SELECT 'todo_view_static ha la chiave primaria o non esiste: niente da fare' AS nota"
);

-- | 202609300221

-- da _202609291500.chiavi.primarie.sql
PREPARE chiavi FROM @chiavi;

-- | 202609300222

-- da _202609291500.chiavi.primarie.sql
EXECUTE chiavi;

-- | 202609300223

-- da _202609291500.chiavi.primarie.sql
DEALLOCATE PREPARE chiavi;

-- | 202609300224

-- da _202609291600.tabelle.fuori.base.sql ( 202609291613 )
-- distinta, i doppioni
SET @chiavi = IF(
    EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'distinta' ) AND NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'distinta' AND CONSTRAINT_TYPE = 'PRIMARY KEY' ),
    "SELECT ( SELECT count(*) - count( DISTINCT `id` ) FROM `distinta` ) + ( SELECT count(*) FROM ( SELECT 1 FROM `distinta` WHERE `id_articolo` IS NOT NULL AND `id_componente` IS NOT NULL GROUP BY `id_articolo`, `id_componente` HAVING count(*) > 1 ) AS d ) INTO @doppioni",
    "SELECT 0 INTO @doppioni"
);

-- | 202609300225

-- da _202609291600.tabelle.fuori.base.sql
PREPARE chiavi FROM @chiavi;

-- | 202609300226

-- da _202609291600.tabelle.fuori.base.sql
EXECUTE chiavi;

-- | 202609300227

-- da _202609291600.tabelle.fuori.base.sql
DEALLOCATE PREPARE chiavi;

-- | 202609300228

-- da _202609291600.tabelle.fuori.base.sql ( 202609291617 )
-- distinta, la chiave
SET @chiavi = IF(
    EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'distinta' ) AND NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'distinta' AND CONSTRAINT_TYPE = 'PRIMARY KEY' ) AND @doppioni = 0,
    "ALTER TABLE `distinta` ADD PRIMARY KEY (`id`), ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_articolo`,`id_componente`), ADD KEY IF NOT EXISTS `id_articolo` (`id_articolo`), ADD KEY IF NOT EXISTS `id_componente` (`id_componente`), ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`), ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`)",
    IF( @doppioni > 0,
        "SELECT 'distinta ha id o chiavi uniche ripetuti: chiave primaria non aggiunta, i doppioni vanno risolti a mano' AS nota",
        "SELECT 'distinta ha la chiave primaria o non esiste: niente da fare' AS nota" )
);

-- | 202609300229

-- da _202609291600.tabelle.fuori.base.sql
PREPARE chiavi FROM @chiavi;

-- | 202609300230

-- da _202609291600.tabelle.fuori.base.sql
EXECUTE chiavi;

-- | 202609300231

-- da _202609291600.tabelle.fuori.base.sql
DEALLOCATE PREPARE chiavi;

-- | 202609300232

-- da _202609291600.tabelle.fuori.base.sql ( 202609291621 )
-- listini_zone, i doppioni
SET @chiavi = IF(
    EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'listini_zone' ) AND NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'listini_zone' AND CONSTRAINT_TYPE = 'PRIMARY KEY' ),
    "SELECT ( SELECT count(*) - count( DISTINCT `id` ) FROM `listini_zone` ) + ( SELECT count(*) FROM ( SELECT 1 FROM `listini_zone` WHERE `id_listino` IS NOT NULL AND `id_zona` IS NOT NULL GROUP BY `id_listino`, `id_zona` HAVING count(*) > 1 ) AS d ) INTO @doppioni",
    "SELECT 0 INTO @doppioni"
);

-- | 202609300233

-- da _202609291600.tabelle.fuori.base.sql
PREPARE chiavi FROM @chiavi;

-- | 202609300234

-- da _202609291600.tabelle.fuori.base.sql
EXECUTE chiavi;

-- | 202609300235

-- da _202609291600.tabelle.fuori.base.sql
DEALLOCATE PREPARE chiavi;

-- | 202609300236

-- da _202609291600.tabelle.fuori.base.sql ( 202609291625 )
-- listini_zone, la chiave
SET @chiavi = IF(
    EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'listini_zone' ) AND NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'listini_zone' AND CONSTRAINT_TYPE = 'PRIMARY KEY' ) AND @doppioni = 0,
    "ALTER TABLE `listini_zone` ADD PRIMARY KEY (`id`), ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_listino`,`id_zona`), ADD KEY IF NOT EXISTS `id_listino` (`id_listino`), ADD KEY IF NOT EXISTS `id_zona` (`id_zona`), ADD KEY IF NOT EXISTS `ordine` (`ordine`), ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`), ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`), MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT",
    IF( @doppioni > 0,
        "SELECT 'listini_zone ha id o chiavi uniche ripetuti: chiave primaria non aggiunta, i doppioni vanno risolti a mano' AS nota",
        "SELECT 'listini_zone ha la chiave primaria o non esiste: niente da fare' AS nota" )
);

-- | 202609300237

-- da _202609291600.tabelle.fuori.base.sql
PREPARE chiavi FROM @chiavi;

-- | 202609300238

-- da _202609291600.tabelle.fuori.base.sql
EXECUTE chiavi;

-- | 202609300239

-- da _202609291600.tabelle.fuori.base.sql
DEALLOCATE PREPARE chiavi;

-- | 202609300240

-- da _202609291600.tabelle.fuori.base.sql ( 202609291629 )
-- modalita_spedizione, i doppioni
SET @chiavi = IF(
    EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'modalita_spedizione' ) AND NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'modalita_spedizione' AND CONSTRAINT_TYPE = 'PRIMARY KEY' ),
    "SELECT ( SELECT count(*) - count( DISTINCT `id` ) FROM `modalita_spedizione` ) + ( SELECT count(*) FROM ( SELECT 1 FROM `modalita_spedizione` WHERE `id_tipologia` IS NOT NULL AND `id_zona` IS NOT NULL AND `id_prodotto` IS NOT NULL AND `id_articolo` IS NOT NULL GROUP BY `id_tipologia`, `id_zona`, `id_prodotto`, `id_articolo` HAVING count(*) > 1 ) AS d ) INTO @doppioni",
    "SELECT 0 INTO @doppioni"
);

-- | 202609300241

-- da _202609291600.tabelle.fuori.base.sql
PREPARE chiavi FROM @chiavi;

-- | 202609300242

-- da _202609291600.tabelle.fuori.base.sql
EXECUTE chiavi;

-- | 202609300243

-- da _202609291600.tabelle.fuori.base.sql
DEALLOCATE PREPARE chiavi;

-- | 202609300244

-- da _202609291600.tabelle.fuori.base.sql ( 202609291633 )
-- modalita_spedizione, la chiave
SET @chiavi = IF(
    EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'modalita_spedizione' ) AND NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'modalita_spedizione' AND CONSTRAINT_TYPE = 'PRIMARY KEY' ) AND @doppioni = 0,
    "ALTER TABLE `modalita_spedizione` ADD PRIMARY KEY (`id`), ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_tipologia`,`id_zona`,`id_prodotto`,`id_articolo`), ADD KEY IF NOT EXISTS `id_tipologia` (`id_tipologia`), ADD KEY IF NOT EXISTS `id_zona` (`id_zona`), ADD KEY IF NOT EXISTS `id_categoria_prodotti` (`id_categoria_prodotti`), ADD KEY IF NOT EXISTS `id_prodotto` (`id_prodotto`), ADD KEY IF NOT EXISTS `id_articolo` (`id_articolo`), ADD KEY IF NOT EXISTS `lotto_spedizione` (`lotto_spedizione`), ADD KEY IF NOT EXISTS `importo_netto` (`importo_netto`), ADD KEY IF NOT EXISTS `id_valuta` (`id_valuta`), ADD KEY IF NOT EXISTS `id_iva` (`id_iva`), ADD KEY IF NOT EXISTS `giorni_spedizione` (`giorni_spedizione`), ADD KEY IF NOT EXISTS `giorni_consegna` (`giorni_consegna`), ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`), ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`), MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT",
    IF( @doppioni > 0,
        "SELECT 'modalita_spedizione ha id o chiavi uniche ripetuti: chiave primaria non aggiunta, i doppioni vanno risolti a mano' AS nota",
        "SELECT 'modalita_spedizione ha la chiave primaria o non esiste: niente da fare' AS nota" )
);

-- | 202609300245

-- da _202609291600.tabelle.fuori.base.sql
PREPARE chiavi FROM @chiavi;

-- | 202609300246

-- da _202609291600.tabelle.fuori.base.sql
EXECUTE chiavi;

-- | 202609300247

-- da _202609291600.tabelle.fuori.base.sql
DEALLOCATE PREPARE chiavi;

-- | 202609300248

-- da _202609291600.tabelle.fuori.base.sql ( 202609291637 )
-- relazioni_prodotti, i doppioni
SET @chiavi = IF(
    EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'relazioni_prodotti' ) AND NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'relazioni_prodotti' AND CONSTRAINT_TYPE = 'PRIMARY KEY' ),
    "SELECT ( SELECT count(*) - count( DISTINCT `id` ) FROM `relazioni_prodotti` ) + ( SELECT count(*) FROM ( SELECT 1 FROM `relazioni_prodotti` WHERE `id_prodotto` IS NOT NULL AND `id_prodotto_collegato` IS NOT NULL AND `id_ruolo` IS NOT NULL GROUP BY `id_prodotto`, `id_prodotto_collegato`, `id_ruolo` HAVING count(*) > 1 ) AS d ) INTO @doppioni",
    "SELECT 0 INTO @doppioni"
);

-- | 202609300249

-- da _202609291600.tabelle.fuori.base.sql
PREPARE chiavi FROM @chiavi;

-- | 202609300250

-- da _202609291600.tabelle.fuori.base.sql
EXECUTE chiavi;

-- | 202609300251

-- da _202609291600.tabelle.fuori.base.sql
DEALLOCATE PREPARE chiavi;

-- | 202609300252

-- da _202609291600.tabelle.fuori.base.sql ( 202609291641 )
-- relazioni_prodotti, la chiave
SET @chiavi = IF(
    EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'relazioni_prodotti' ) AND NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'relazioni_prodotti' AND CONSTRAINT_TYPE = 'PRIMARY KEY' ) AND @doppioni = 0,
    "ALTER TABLE `relazioni_prodotti` ADD PRIMARY KEY (`id`), ADD UNIQUE KEY IF NOT EXISTS `unico` (`id_prodotto`,`id_prodotto_collegato`,`id_ruolo`), ADD KEY IF NOT EXISTS `id_prodotto` (`id_prodotto`), ADD KEY IF NOT EXISTS `id_ruolo` (`id_ruolo`), ADD KEY IF NOT EXISTS `id_prodotto_collegato` (`id_prodotto_collegato`), ADD KEY IF NOT EXISTS `id_articolo_collegato` (`id_articolo_collegato`), ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`), ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`), MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT",
    IF( @doppioni > 0,
        "SELECT 'relazioni_prodotti ha id o chiavi uniche ripetuti: chiave primaria non aggiunta, i doppioni vanno risolti a mano' AS nota",
        "SELECT 'relazioni_prodotti ha la chiave primaria o non esiste: niente da fare' AS nota" )
);

-- | 202609300253

-- da _202609291600.tabelle.fuori.base.sql
PREPARE chiavi FROM @chiavi;

-- | 202609300254

-- da _202609291600.tabelle.fuori.base.sql
EXECUTE chiavi;

-- | 202609300255

-- da _202609291600.tabelle.fuori.base.sql
DEALLOCATE PREPARE chiavi;

-- | 202609300256

-- da _202609291600.tabelle.fuori.base.sql ( 202609291645 )
-- ruoli_mastri, i doppioni
SET @chiavi = IF(
    EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'ruoli_mastri' ) AND NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'ruoli_mastri' AND CONSTRAINT_TYPE = 'PRIMARY KEY' ),
    "SELECT ( SELECT count(*) - count( DISTINCT `id` ) FROM `ruoli_mastri` ) + ( SELECT count(*) FROM ( SELECT 1 FROM `ruoli_mastri` WHERE `nome` IS NOT NULL AND `id_genitore` IS NOT NULL GROUP BY `nome`, `id_genitore` HAVING count(*) > 1 ) AS d ) INTO @doppioni",
    "SELECT 0 INTO @doppioni"
);

-- | 202609300257

-- da _202609291600.tabelle.fuori.base.sql
PREPARE chiavi FROM @chiavi;

-- | 202609300258

-- da _202609291600.tabelle.fuori.base.sql
EXECUTE chiavi;

-- | 202609300259

-- da _202609291600.tabelle.fuori.base.sql
DEALLOCATE PREPARE chiavi;

-- | 202609300300

-- da _202609291600.tabelle.fuori.base.sql ( 202609291649 )
-- ruoli_mastri, la chiave
SET @chiavi = IF(
    EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'ruoli_mastri' ) AND NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'ruoli_mastri' AND CONSTRAINT_TYPE = 'PRIMARY KEY' ) AND @doppioni = 0,
    "ALTER TABLE `ruoli_mastri` ADD PRIMARY KEY (`id`), ADD UNIQUE KEY IF NOT EXISTS `unica` (`nome`,`id_genitore`), ADD KEY IF NOT EXISTS `id_genitore` (`id_genitore`), ADD KEY IF NOT EXISTS `indice` (`id`,`id_genitore`,`nome`), MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT",
    IF( @doppioni > 0,
        "SELECT 'ruoli_mastri ha id o chiavi uniche ripetuti: chiave primaria non aggiunta, i doppioni vanno risolti a mano' AS nota",
        "SELECT 'ruoli_mastri ha la chiave primaria o non esiste: niente da fare' AS nota" )
);

-- | 202609300301

-- da _202609291600.tabelle.fuori.base.sql
PREPARE chiavi FROM @chiavi;

-- | 202609300302

-- da _202609291600.tabelle.fuori.base.sql
EXECUTE chiavi;

-- | 202609300303

-- da _202609291600.tabelle.fuori.base.sql
DEALLOCATE PREPARE chiavi;

-- | 202609300304

-- da _202609291600.tabelle.fuori.base.sql ( 202609291653 )
-- sconti, i doppioni
SET @chiavi = IF(
    EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'sconti' ) AND NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'sconti' AND CONSTRAINT_TYPE = 'PRIMARY KEY' ),
    "SELECT ( SELECT count(*) - count( DISTINCT `id` ) FROM `sconti` ) + ( SELECT count(*) FROM ( SELECT 1 FROM `sconti` WHERE `id_tipologia` IS NOT NULL AND `nome` IS NOT NULL GROUP BY `id_tipologia`, `nome` HAVING count(*) > 1 ) AS d ) INTO @doppioni",
    "SELECT 0 INTO @doppioni"
);

-- | 202609300305

-- da _202609291600.tabelle.fuori.base.sql
PREPARE chiavi FROM @chiavi;

-- | 202609300306

-- da _202609291600.tabelle.fuori.base.sql
EXECUTE chiavi;

-- | 202609300307

-- da _202609291600.tabelle.fuori.base.sql
DEALLOCATE PREPARE chiavi;

-- | 202609300308

-- da _202609291600.tabelle.fuori.base.sql ( 202609291657 )
-- sconti, la chiave
SET @chiavi = IF(
    EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'sconti' ) AND NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'sconti' AND CONSTRAINT_TYPE = 'PRIMARY KEY' ) AND @doppioni = 0,
    "ALTER TABLE `sconti` ADD PRIMARY KEY (`id`), ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_tipologia`,`nome`), ADD KEY IF NOT EXISTS `id_tipologia` (`id_tipologia`), ADD KEY IF NOT EXISTS `nome` (`nome`), ADD KEY IF NOT EXISTS `id_valuta` (`id_valuta`), ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`), ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`), ADD KEY IF NOT EXISTS `indice` (`id`,`id_tipologia`,`nome`,`sconto_percentuale`,`sconto_fisso`,`qta_min`,`id_valuta`,`timestamp_inizio`,`timestamp_fine`), MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT",
    IF( @doppioni > 0,
        "SELECT 'sconti ha id o chiavi uniche ripetuti: chiave primaria non aggiunta, i doppioni vanno risolti a mano' AS nota",
        "SELECT 'sconti ha la chiave primaria o non esiste: niente da fare' AS nota" )
);

-- | 202609300309

-- da _202609291600.tabelle.fuori.base.sql
PREPARE chiavi FROM @chiavi;

-- | 202609300310

-- da _202609291600.tabelle.fuori.base.sql
EXECUTE chiavi;

-- | 202609300311

-- da _202609291600.tabelle.fuori.base.sql
DEALLOCATE PREPARE chiavi;

-- | 202609300312

-- da _202609291600.tabelle.fuori.base.sql ( 202609291701 )
-- sconti_articoli, i doppioni
SET @chiavi = IF(
    EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'sconti_articoli' ) AND NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'sconti_articoli' AND CONSTRAINT_TYPE = 'PRIMARY KEY' ),
    "SELECT ( SELECT count(*) - count( DISTINCT `id` ) FROM `sconti_articoli` ) + ( SELECT count(*) FROM ( SELECT 1 FROM `sconti_articoli` WHERE `id_sconto` IS NOT NULL AND `id_articolo` IS NOT NULL GROUP BY `id_sconto`, `id_articolo` HAVING count(*) > 1 ) AS d ) INTO @doppioni",
    "SELECT 0 INTO @doppioni"
);

-- | 202609300313

-- da _202609291600.tabelle.fuori.base.sql
PREPARE chiavi FROM @chiavi;

-- | 202609300314

-- da _202609291600.tabelle.fuori.base.sql
EXECUTE chiavi;

-- | 202609300315

-- da _202609291600.tabelle.fuori.base.sql
DEALLOCATE PREPARE chiavi;

-- | 202609300316

-- da _202609291600.tabelle.fuori.base.sql ( 202609291705 )
-- sconti_articoli, la chiave
SET @chiavi = IF(
    EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'sconti_articoli' ) AND NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'sconti_articoli' AND CONSTRAINT_TYPE = 'PRIMARY KEY' ) AND @doppioni = 0,
    "ALTER TABLE `sconti_articoli` ADD PRIMARY KEY (`id`), ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_sconto`,`id_articolo`), ADD KEY IF NOT EXISTS `id_sconto` (`id_sconto`), ADD KEY IF NOT EXISTS `id_articolo` (`id_articolo`), ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`), ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`), ADD KEY IF NOT EXISTS `indice` (`id`,`id_sconto`,`id_articolo`), MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT",
    IF( @doppioni > 0,
        "SELECT 'sconti_articoli ha id o chiavi uniche ripetuti: chiave primaria non aggiunta, i doppioni vanno risolti a mano' AS nota",
        "SELECT 'sconti_articoli ha la chiave primaria o non esiste: niente da fare' AS nota" )
);

-- | 202609300317

-- da _202609291600.tabelle.fuori.base.sql
PREPARE chiavi FROM @chiavi;

-- | 202609300318

-- da _202609291600.tabelle.fuori.base.sql
EXECUTE chiavi;

-- | 202609300319

-- da _202609291600.tabelle.fuori.base.sql
DEALLOCATE PREPARE chiavi;

-- | 202609300320

-- da _202609291600.tabelle.fuori.base.sql ( 202609291709 )
-- sconti_listini, i doppioni
SET @chiavi = IF(
    EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'sconti_listini' ) AND NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'sconti_listini' AND CONSTRAINT_TYPE = 'PRIMARY KEY' ),
    "SELECT ( SELECT count(*) - count( DISTINCT `id` ) FROM `sconti_listini` ) + ( SELECT count(*) FROM ( SELECT 1 FROM `sconti_listini` WHERE `id_sconto` IS NOT NULL AND `id_listino` IS NOT NULL GROUP BY `id_sconto`, `id_listino` HAVING count(*) > 1 ) AS d ) INTO @doppioni",
    "SELECT 0 INTO @doppioni"
);

-- | 202609300321

-- da _202609291600.tabelle.fuori.base.sql
PREPARE chiavi FROM @chiavi;

-- | 202609300322

-- da _202609291600.tabelle.fuori.base.sql
EXECUTE chiavi;

-- | 202609300323

-- da _202609291600.tabelle.fuori.base.sql
DEALLOCATE PREPARE chiavi;

-- | 202609300324

-- da _202609291600.tabelle.fuori.base.sql ( 202609291713 )
-- sconti_listini, la chiave
SET @chiavi = IF(
    EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'sconti_listini' ) AND NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'sconti_listini' AND CONSTRAINT_TYPE = 'PRIMARY KEY' ) AND @doppioni = 0,
    "ALTER TABLE `sconti_listini` ADD PRIMARY KEY (`id`), ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_sconto`,`id_listino`), ADD KEY IF NOT EXISTS `id_sconto` (`id_sconto`), ADD KEY IF NOT EXISTS `id_listino` (`id_listino`), ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`), ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`), ADD KEY IF NOT EXISTS `indice` (`id`,`id_sconto`,`id_listino`), MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT",
    IF( @doppioni > 0,
        "SELECT 'sconti_listini ha id o chiavi uniche ripetuti: chiave primaria non aggiunta, i doppioni vanno risolti a mano' AS nota",
        "SELECT 'sconti_listini ha la chiave primaria o non esiste: niente da fare' AS nota" )
);

-- | 202609300325

-- da _202609291600.tabelle.fuori.base.sql
PREPARE chiavi FROM @chiavi;

-- | 202609300326

-- da _202609291600.tabelle.fuori.base.sql
EXECUTE chiavi;

-- | 202609300327

-- da _202609291600.tabelle.fuori.base.sql
DEALLOCATE PREPARE chiavi;

-- | 202609300328

-- da _202609291600.tabelle.fuori.base.sql ( 202609291717 )
-- tipologie_sconti, i doppioni
SET @chiavi = IF(
    EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'tipologie_sconti' ) AND NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'tipologie_sconti' AND CONSTRAINT_TYPE = 'PRIMARY KEY' ),
    "SELECT ( SELECT count(*) - count( DISTINCT `id` ) FROM `tipologie_sconti` ) + ( SELECT count(*) FROM ( SELECT 1 FROM `tipologie_sconti` WHERE `id_genitore` IS NOT NULL AND `nome` IS NOT NULL GROUP BY `id_genitore`, `nome` HAVING count(*) > 1 ) AS d ) INTO @doppioni",
    "SELECT 0 INTO @doppioni"
);

-- | 202609300329

-- da _202609291600.tabelle.fuori.base.sql
PREPARE chiavi FROM @chiavi;

-- | 202609300330

-- da _202609291600.tabelle.fuori.base.sql
EXECUTE chiavi;

-- | 202609300331

-- da _202609291600.tabelle.fuori.base.sql
DEALLOCATE PREPARE chiavi;

-- | 202609300332

-- da _202609291600.tabelle.fuori.base.sql ( 202609291721 )
-- tipologie_sconti, la chiave
SET @chiavi = IF(
    EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'tipologie_sconti' ) AND NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'tipologie_sconti' AND CONSTRAINT_TYPE = 'PRIMARY KEY' ) AND @doppioni = 0,
    "ALTER TABLE `tipologie_sconti` ADD PRIMARY KEY (`id`), ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_genitore`,`nome`), ADD KEY IF NOT EXISTS `id_genitore` (`id_genitore`), ADD KEY IF NOT EXISTS `nome` (`nome`), ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`), ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`), ADD KEY IF NOT EXISTS `indice` (`id`,`id_genitore`,`nome`), MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT",
    IF( @doppioni > 0,
        "SELECT 'tipologie_sconti ha id o chiavi uniche ripetuti: chiave primaria non aggiunta, i doppioni vanno risolti a mano' AS nota",
        "SELECT 'tipologie_sconti ha la chiave primaria o non esiste: niente da fare' AS nota" )
);

-- | 202609300333

-- da _202609291600.tabelle.fuori.base.sql
PREPARE chiavi FROM @chiavi;

-- | 202609300334

-- da _202609291600.tabelle.fuori.base.sql
EXECUTE chiavi;

-- | 202609300335

-- da _202609291600.tabelle.fuori.base.sql
DEALLOCATE PREPARE chiavi;

-- | 202609300336

-- da _202609291600.tabelle.fuori.base.sql ( 202609291725 )
-- tipologie_zone, i doppioni
SET @chiavi = IF(
    EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'tipologie_zone' ) AND NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'tipologie_zone' AND CONSTRAINT_TYPE = 'PRIMARY KEY' ),
    "SELECT ( SELECT count(*) - count( DISTINCT `id` ) FROM `tipologie_zone` ) + ( SELECT count(*) FROM ( SELECT 1 FROM `tipologie_zone` WHERE `id_genitore` IS NOT NULL AND `nome` IS NOT NULL GROUP BY `id_genitore`, `nome` HAVING count(*) > 1 ) AS d ) INTO @doppioni",
    "SELECT 0 INTO @doppioni"
);

-- | 202609300337

-- da _202609291600.tabelle.fuori.base.sql
PREPARE chiavi FROM @chiavi;

-- | 202609300338

-- da _202609291600.tabelle.fuori.base.sql
EXECUTE chiavi;

-- | 202609300339

-- da _202609291600.tabelle.fuori.base.sql
DEALLOCATE PREPARE chiavi;

-- | 202609300340

-- da _202609291600.tabelle.fuori.base.sql ( 202609291729 )
-- tipologie_zone, la chiave
SET @chiavi = IF(
    EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'tipologie_zone' ) AND NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'tipologie_zone' AND CONSTRAINT_TYPE = 'PRIMARY KEY' ) AND @doppioni = 0,
    "ALTER TABLE `tipologie_zone` ADD PRIMARY KEY (`id`), ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_genitore`,`nome`), ADD KEY IF NOT EXISTS `id_genitore` (`id_genitore`), ADD KEY IF NOT EXISTS `ordine` (`ordine`), ADD KEY IF NOT EXISTS `nome` (`nome`), ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`), ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`), ADD KEY IF NOT EXISTS `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`), MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT",
    IF( @doppioni > 0,
        "SELECT 'tipologie_zone ha id o chiavi uniche ripetuti: chiave primaria non aggiunta, i doppioni vanno risolti a mano' AS nota",
        "SELECT 'tipologie_zone ha la chiave primaria o non esiste: niente da fare' AS nota" )
);

-- | 202609300341

-- da _202609291600.tabelle.fuori.base.sql
PREPARE chiavi FROM @chiavi;

-- | 202609300342

-- da _202609291600.tabelle.fuori.base.sql
EXECUTE chiavi;

-- | 202609300343

-- da _202609291600.tabelle.fuori.base.sql
DEALLOCATE PREPARE chiavi;

-- | 202609300344

-- da _202609291600.tabelle.fuori.base.sql ( 202609291733 )
-- zone, i doppioni
SET @chiavi = IF(
    EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'zone' ) AND NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'zone' AND CONSTRAINT_TYPE = 'PRIMARY KEY' ),
    "SELECT ( SELECT count(*) - count( DISTINCT `id` ) FROM `zone` ) + ( SELECT count(*) FROM ( SELECT 1 FROM `zone` WHERE `nome` IS NOT NULL AND `id_genitore` IS NOT NULL GROUP BY `nome`, `id_genitore` HAVING count(*) > 1 ) AS d ) INTO @doppioni",
    "SELECT 0 INTO @doppioni"
);

-- | 202609300345

-- da _202609291600.tabelle.fuori.base.sql
PREPARE chiavi FROM @chiavi;

-- | 202609300346

-- da _202609291600.tabelle.fuori.base.sql
EXECUTE chiavi;

-- | 202609300347

-- da _202609291600.tabelle.fuori.base.sql
DEALLOCATE PREPARE chiavi;

-- | 202609300348

-- da _202609291600.tabelle.fuori.base.sql ( 202609291737 )
-- zone, la chiave
SET @chiavi = IF(
    EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'zone' ) AND NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'zone' AND CONSTRAINT_TYPE = 'PRIMARY KEY' ) AND @doppioni = 0,
    "ALTER TABLE `zone` ADD PRIMARY KEY (`id`), ADD UNIQUE KEY IF NOT EXISTS `unica` (`nome`, `id_genitore`), ADD KEY IF NOT EXISTS `id_tipologia` (`id_tipologia`), ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`), ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`), ADD KEY IF NOT EXISTS `id_genitore` (`id_genitore`), ADD KEY IF NOT EXISTS `indice` (`id`,`id_genitore`,`nome`, `id_tipologia`), MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT",
    IF( @doppioni > 0,
        "SELECT 'zone ha id o chiavi uniche ripetuti: chiave primaria non aggiunta, i doppioni vanno risolti a mano' AS nota",
        "SELECT 'zone ha la chiave primaria o non esiste: niente da fare' AS nota" )
);

-- | 202609300349

-- da _202609291600.tabelle.fuori.base.sql
PREPARE chiavi FROM @chiavi;

-- | 202609300350

-- da _202609291600.tabelle.fuori.base.sql
EXECUTE chiavi;

-- | 202609300351

-- da _202609291600.tabelle.fuori.base.sql
DEALLOCATE PREPARE chiavi;

-- | 202609300352

-- da _202609291900.tabelle.riallineamento.sql ( 202609292038 )
-- redirect_azioni, i doppioni
SET @chiavi = IF( EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'redirect_azioni' ) AND NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'redirect_azioni' AND CONSTRAINT_TYPE = 'PRIMARY KEY' ), "SELECT count(*) - count( DISTINCT `id` ) INTO @doppioni FROM `redirect_azioni`", "SELECT 0 INTO @doppioni" );

-- | 202609300353

-- da _202609291900.tabelle.riallineamento.sql
PREPARE chiavi FROM @chiavi;

-- | 202609300354

-- da _202609291900.tabelle.riallineamento.sql
EXECUTE chiavi;

-- | 202609300355

-- da _202609291900.tabelle.riallineamento.sql
DEALLOCATE PREPARE chiavi;

-- | 202609300356

-- da _202609291900.tabelle.riallineamento.sql ( 202609292042 )
-- redirect_azioni, la chiave
SET @chiavi = IF(
    EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'redirect_azioni' ) AND NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'redirect_azioni' AND CONSTRAINT_TYPE = 'PRIMARY KEY' ) AND @doppioni = 0,
    "ALTER TABLE `redirect_azioni` ADD PRIMARY KEY (`id`), ADD KEY IF NOT EXISTS `id_redirect` (`id_redirect`), ADD KEY IF NOT EXISTS `azione` (`azione`), ADD KEY IF NOT EXISTS `timestamp_azione` (`timestamp_azione`), ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`), ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`), MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT",
    IF( @doppioni > 0,
        "SELECT 'redirect_azioni ha id ripetuti: chiave primaria non aggiunta, i doppioni vanno risolti a mano' AS nota",
        "SELECT 'redirect_azioni ha la chiave primaria o non esiste: niente da fare' AS nota" )
);

-- | 202609300357

-- da _202609291900.tabelle.riallineamento.sql
PREPARE chiavi FROM @chiavi;

-- | 202609300358

-- da _202609291900.tabelle.riallineamento.sql
EXECUTE chiavi;

-- | 202609300359

-- da _202609291900.tabelle.riallineamento.sql
DEALLOCATE PREPARE chiavi;

-- | FINE FILE
