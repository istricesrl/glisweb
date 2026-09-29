-- 2026-09-30 — i dati dei blocchi della fattura elettronica che il gestionale non raccoglieva
--
-- Contesto: _mod/_0400.documenti/_src/_api/_print/_fattura.xml.php non scriveva i blocchi DatiRitenuta,
-- DatiBollo, DatiCassaPrevidenziale, DatiFattureCollegate e DatiDDT delle specifiche tecniche 1.9 ( schema
-- Schema_VFPR12_v1.2.3.xsd, invariato nelle 1.9.1 ), perche' il database non aveva dove tenerne i dati. Dal
-- 2026-09-30 li scrive, e questa patch porta ai deploy esistenti quello che i file di base hanno gia':
--  - documenti.se_bollo_virtuale e documenti.importo_bollo, per DatiBollo;
--  - documenti_articoli.se_ritenuta, l'elemento Ritenuta della riga;
--  - le tabelle standard ritenute ( TipoRitenuta, RT01 - RT06 ) e casse_previdenziali ( TipoCassa, TC01 - TC22 ),
--    con i codici e le descrizioni della rappresentazione tabellare delle specifiche 1.9;
--  - le tabelle di relazione documenti_ritenute e documenti_casse_previdenziali, una riga per ogni blocco DatiRitenuta
--    e DatiCassaPrevidenziale del documento, con le viste e le chiavi esterne del canone ( capitolo 300 );
--  - i ruoli dei documenti 'fattura collegata' e 'DDT collegato', con se_xml: una relazione con uno di questi ruoli
--    finisce nella fattura elettronica, in DatiFattureCollegate o in DatiDDT secondo la tipologia del documento
--    collegato;
--  - l'archiviazione delle aliquote 35, 57 e 58 ( timestamp_archiviazione ): 57 e 58 hanno la natura generica N6, che
--    lo SDI scarta dal 2021 con l'errore 00445, e la 35 ( art. 71, San Marino ) ha N3.6 invece di N3.3, la natura che
--    le specifiche danno alle cessioni verso San Marino e che ha la riga 60 portata da _202609291300.fatturapa.codici.sql.
--    Le righe restano, perche' i documenti gia' emessi le citano, ma le tendine dei documenti non le propongono piu'.
--    Si archiviano solo se hanno ancora i valori dei dati di base: una riga cambiata dal deploy non si tocca.
--
-- GUARDIE. Le colonne si aggiungono con ADD COLUMN IF NOT EXISTS dentro un PREPARE guardato da information_schema,
-- come in _202609301600.code.marcatura.sql: se la colonna dopo cui vanno non c'e', il passo non fa niente e lo dice.
-- Le tabelle nascono con CREATE TABLE IF NOT EXISTS, con chiave primaria e indici dentro la CREATE come in
-- _202609291900.tabelle.riallineamento.sql; le righe standard con INSERT IGNORE sugli id, i ruoli senza id e solo se
-- il nome non c'e' ( come le tipologie TD28 e TD29 di _202609291300.fatturapa.codici.sql, perche' un deploy puo'
-- avere ruoli suoi con gli id successivi ). Le chiavi esterne passano da una procedura ricalcata su quella di
-- _202609301730.chiavi.esterne.nofollow.sql, che ne aggiunge una solo se sulla colonna non ce n'e' gia' una, i tipi
-- coincidono e non ci sono righe orfane, e altrimenti scrive il motivo in @fatturapa_note. La patch si puo' rieseguire.

-- | 202609301800

-- documenti, le colonne del bollo
SET @fatturapa = IF(
    EXISTS (
        SELECT 1 FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'documenti' AND COLUMN_NAME = 'esigibilita'
    ),
    "ALTER TABLE `documenti` ADD COLUMN IF NOT EXISTS `se_bollo_virtuale` tinyint(1) DEFAULT NULL AFTER `esigibilita`, ADD COLUMN IF NOT EXISTS `importo_bollo` decimal(16,2) DEFAULT NULL AFTER `se_bollo_virtuale`",
    "SELECT 'documenti non esiste o non ha la colonna esigibilita: niente da fare' AS nota"
);

-- | 202609301801

PREPARE fatturapa FROM @fatturapa;

-- | 202609301802

EXECUTE fatturapa;

-- | 202609301803

DEALLOCATE PREPARE fatturapa;

-- | 202609301804

-- documenti_articoli, la colonna della ritenuta
SET @fatturapa = IF(
    EXISTS (
        SELECT 1 FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'documenti_articoli' AND COLUMN_NAME = 'importo_lordo_finale'
    ),
    "ALTER TABLE `documenti_articoli` ADD COLUMN IF NOT EXISTS `se_ritenuta` tinyint(1) DEFAULT NULL AFTER `importo_lordo_finale`",
    "SELECT 'documenti_articoli non esiste o non ha la colonna importo_lordo_finale: niente da fare' AS nota"
);

-- | 202609301805

PREPARE fatturapa FROM @fatturapa;

-- | 202609301806

EXECUTE fatturapa;

-- | 202609301807

DEALLOCATE PREPARE fatturapa;

-- | 202609301808

-- casse_previdenziali
CREATE TABLE IF NOT EXISTS `casse_previdenziali` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `codice` char(32) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `codice` (`codice`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609301809

-- ritenute
CREATE TABLE IF NOT EXISTS `ritenute` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `codice` char(32) DEFAULT NULL,
  `nome` char(128) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `codice` (`codice`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609301810

-- documenti_casse_previdenziali
CREATE TABLE IF NOT EXISTS `documenti_casse_previdenziali` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_documento` bigint(20) DEFAULT NULL,
  `id_cassa_previdenziale` bigint(20) DEFAULT NULL,
  `aliquota` decimal(5,2) DEFAULT NULL,
  `imponibile` decimal(16,2) DEFAULT NULL,
  `importo` decimal(16,2) DEFAULT NULL,
  `id_iva` bigint(20) DEFAULT NULL,
  `se_ritenuta` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_documento`,`id_cassa_previdenziale`),
  KEY `id_documento` (`id_documento`),
  KEY `id_cassa_previdenziale` (`id_cassa_previdenziale`),
  KEY `id_iva` (`id_iva`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609301811

-- documenti_ritenute
CREATE TABLE IF NOT EXISTS `documenti_ritenute` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_documento` bigint(20) DEFAULT NULL,
  `id_ritenuta` bigint(20) DEFAULT NULL,
  `aliquota` decimal(5,2) DEFAULT NULL,
  `causale_pagamento` char(2) DEFAULT NULL,
  `importo` decimal(16,2) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_documento`,`id_ritenuta`),
  KEY `id_documento` (`id_documento`),
  KEY `id_ritenuta` (`id_ritenuta`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609301812

-- casse_previdenziali, i codici TipoCassa
INSERT IGNORE INTO `casse_previdenziali` (`id`, `codice`, `nome`) VALUES
(1,		'TC01',		'Cassa nazionale previdenza e assistenza avvocati e procuratori legali'),
(2,		'TC02',		'Cassa previdenza dottori commercialisti'),
(3,		'TC03',		'Cassa previdenza e assistenza geometri'),
(4,		'TC04',		'Cassa nazionale previdenza e assistenza ingegneri e architetti liberi professionisti'),
(5,		'TC05',		'Cassa nazionale del notariato'),
(6,		'TC06',		'Cassa nazionale previdenza e assistenza ragionieri e periti commerciali'),
(7,		'TC07',		'Ente nazionale assistenza agenti e rappresentanti di commercio (ENASARCO)'),
(8,		'TC08',		'Ente nazionale previdenza e assistenza consulenti del lavoro (ENPACL)'),
(9,		'TC09',		'Ente nazionale previdenza e assistenza medici (ENPAM)'),
(10,	'TC10',		'Ente nazionale previdenza e assistenza farmacisti (ENPAF)'),
(11,	'TC11',		'Ente nazionale previdenza e assistenza veterinari (ENPAV)'),
(12,	'TC12',		'Ente nazionale previdenza e assistenza impiegati dell\'agricoltura (ENPAIA)'),
(13,	'TC13',		'Fondo previdenza impiegati imprese di spedizione e agenzie marittime'),
(14,	'TC14',		'Istituto nazionale previdenza giornalisti italiani (INPGI)'),
(15,	'TC15',		'Opera nazionale assistenza orfani sanitari italiani (ONAOSI)'),
(16,	'TC16',		'Cassa autonoma assistenza integrativa giornalisti italiani (CASAGIT)'),
(17,	'TC17',		'Ente previdenza periti industriali e periti industriali laureati (EPPI)'),
(18,	'TC18',		'Ente previdenza e assistenza pluricategoriale (EPAP)'),
(19,	'TC19',		'Ente nazionale previdenza e assistenza biologi (ENPAB)'),
(20,	'TC20',		'Ente nazionale previdenza e assistenza professione infermieristica (ENPAPI)'),
(21,	'TC21',		'Ente nazionale previdenza e assistenza psicologi (ENPAP)'),
(22,	'TC22',		'INPS');

-- | 202609301813

-- ritenute, i codici TipoRitenuta
INSERT IGNORE INTO `ritenute` (`id`, `codice`, `nome`) VALUES
(1,		'RT01',		'ritenuta persone fisiche'),
(2,		'RT02',		'ritenuta persone giuridiche'),
(3,		'RT03',		'contributo INPS'),
(4,		'RT04',		'contributo ENASARCO'),
(5,		'RT05',		'contributo ENPAM'),
(6,		'RT06',		'altro contributo previdenziale');

-- | 202609301814

-- ruoli_documenti, la fattura collegata ( DatiFattureCollegate )
INSERT INTO `ruoli_documenti` ( `nome`, `se_xml`, `se_documenti`, `se_documenti_articoli`, `se_relazioni` )
	SELECT 'fattura collegata', 1, 1, 1, 1 FROM DUAL
	WHERE NOT EXISTS ( SELECT 1 FROM `ruoli_documenti` WHERE `nome` = 'fattura collegata' );

-- | 202609301815

-- ruoli_documenti, il documento di trasporto collegato ( DatiDDT )
INSERT INTO `ruoli_documenti` ( `nome`, `se_xml`, `se_documenti`, `se_documenti_articoli`, `se_relazioni` )
	SELECT 'DDT collegato', 1, 1, 1, 1 FROM DUAL
	WHERE NOT EXISTS ( SELECT 1 FROM `ruoli_documenti` WHERE `nome` = 'DDT collegato' );

-- | 202609301816

-- casse_previdenziali_view
CREATE OR REPLACE VIEW casse_previdenziali_view AS
	SELECT
		casse_previdenziali.id,
		casse_previdenziali.codice,
		casse_previdenziali.nome,
		concat( casse_previdenziali.codice, ' - ', casse_previdenziali.nome ) AS __label__
	FROM casse_previdenziali
;

-- | 202609301817

-- ritenute_view
CREATE OR REPLACE VIEW ritenute_view AS
	SELECT
		ritenute.id,
		ritenute.codice,
		ritenute.nome,
		concat( ritenute.codice, ' - ', ritenute.nome ) AS __label__
	FROM ritenute
;

-- | 202609301818

-- documenti_casse_previdenziali_view
CREATE OR REPLACE VIEW documenti_casse_previdenziali_view AS
	SELECT
		documenti_casse_previdenziali.id,
		documenti_casse_previdenziali.id_documento,
		documenti_casse_previdenziali.id_cassa_previdenziale,
		casse_previdenziali.codice AS cassa_previdenziale,
		documenti_casse_previdenziali.aliquota,
		documenti_casse_previdenziali.imponibile,
		documenti_casse_previdenziali.importo,
		documenti_casse_previdenziali.id_iva,
		iva.nome AS iva,
		documenti_casse_previdenziali.se_ritenuta,
		documenti_casse_previdenziali.id_account_inserimento,
		documenti_casse_previdenziali.id_account_aggiornamento,
		concat_ws( ' ', casse_previdenziali.codice, concat( documenti_casse_previdenziali.aliquota, '%' ) ) AS __label__
	FROM documenti_casse_previdenziali
		LEFT JOIN casse_previdenziali ON casse_previdenziali.id = documenti_casse_previdenziali.id_cassa_previdenziale
		LEFT JOIN iva ON iva.id = documenti_casse_previdenziali.id_iva
;

-- | 202609301819

-- documenti_ritenute_view
CREATE OR REPLACE VIEW documenti_ritenute_view AS
	SELECT
		documenti_ritenute.id,
		documenti_ritenute.id_documento,
		documenti_ritenute.id_ritenuta,
		ritenute.codice AS ritenuta,
		documenti_ritenute.aliquota,
		documenti_ritenute.causale_pagamento,
		documenti_ritenute.importo,
		documenti_ritenute.id_account_inserimento,
		documenti_ritenute.id_account_aggiornamento,
		concat_ws( ' ', ritenute.codice, concat( documenti_ritenute.aliquota, '%' ), documenti_ritenute.causale_pagamento ) AS __label__
	FROM documenti_ritenute
		LEFT JOIN ritenute ON ritenute.id = documenti_ritenute.id_ritenuta
;

-- | 202609301820

-- la procedura che aggiunge una chiave esterna dei file di base, se si puo'
CREATE OR REPLACE PROCEDURE `__patch_fatturapa__`( IN tabella VARCHAR(64), IN vincolo VARCHAR(64), IN colonna VARCHAR(64), IN riferimento VARCHAR(64), IN cancellazione VARCHAR(16), IN aggiornamento VARCHAR(16) )
BEGIN

    DECLARE messaggio TEXT DEFAULT NULL;
    DECLARE v_tipo_figlia, v_tipo_padre, v_nullabile VARCHAR(64) DEFAULT NULL;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1 messaggio = MESSAGE_TEXT;
        END;

    SELECT COLUMN_TYPE, IS_NULLABLE INTO v_tipo_figlia, v_nullabile
        FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = tabella AND COLUMN_NAME = colonna
        LIMIT 1;

    SELECT COLUMN_TYPE INTO v_tipo_padre
        FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = riferimento AND COLUMN_NAME = 'id'
        LIMIT 1;

    SET @fatturapa_orfani = 0;
    SET @fatturapa_controlli = @@foreign_key_checks;

    IF v_tipo_figlia IS NULL THEN
        SET messaggio = CONCAT( 'non esiste ', tabella, '.', colonna );
    ELSEIF v_tipo_padre IS NULL THEN
        SET messaggio = CONCAT( 'non esiste ', riferimento, '.id' );
    ELSEIF EXISTS (
        SELECT 1 FROM information_schema.KEY_COLUMN_USAGE
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = tabella AND COLUMN_NAME = colonna
          AND REFERENCED_TABLE_NAME IS NOT NULL
    ) THEN
        -- c'e' gia' una chiave esterna sulla colonna, con qualunque nome: non si tocca
        SET messaggio = NULL;
    ELSEIF EXISTS (
        SELECT 1 FROM information_schema.TABLE_CONSTRAINTS
        WHERE CONSTRAINT_SCHEMA = database() AND CONSTRAINT_NAME = vincolo
    ) THEN
        SET messaggio = 'il nome e'' gia'' usato da un altro vincolo';
    ELSEIF NOT EXISTS (
        SELECT 1 FROM information_schema.STATISTICS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = riferimento AND COLUMN_NAME = 'id'
          AND SEQ_IN_INDEX = 1 AND NON_UNIQUE = 0
    ) THEN
        SET messaggio = CONCAT( riferimento, '.id non e'' una chiave' );
    ELSEIF v_tipo_figlia <> v_tipo_padre THEN
        SET messaggio = CONCAT( 'tipi diversi, ', tabella, '.', colonna, ' ', v_tipo_figlia, ' e ', riferimento, '.id ', v_tipo_padre );
    ELSEIF cancellazione = 'SET NULL' AND v_nullabile = 'NO' THEN
        SET messaggio = CONCAT( tabella, '.', colonna, ' e'' NOT NULL e il vincolo e'' ON DELETE SET NULL' );
    ELSE
        SET @fatturapa_sql = CONCAT(
            'SELECT count(*) INTO @fatturapa_orfani FROM `', tabella, '` AS figlie ',
            'LEFT JOIN `', riferimento, '` AS padri ON padri.id = figlie.`', colonna, '` ',
            'WHERE figlie.`', colonna, '` IS NOT NULL AND padri.id IS NULL'
        );
        PREPARE controllo FROM @fatturapa_sql;
        EXECUTE controllo;
        DEALLOCATE PREPARE controllo;
        IF messaggio IS NULL AND @fatturapa_orfani > 0 THEN
            SET messaggio = CONCAT( @fatturapa_orfani, ' righe di ', tabella, ' con un ', colonna, ' che non esiste in ', riferimento );
        ELSEIF messaggio IS NULL THEN
            SET foreign_key_checks = 0;
            SET @fatturapa_sql = CONCAT(
                'ALTER TABLE `', tabella, '` ADD CONSTRAINT `', vincolo, '` FOREIGN KEY (`', colonna, '`) ',
                'REFERENCES `', riferimento, '` (`id`) ON DELETE ', cancellazione, ' ON UPDATE ', aggiornamento
            );
            PREPARE aggiunta FROM @fatturapa_sql;
            EXECUTE aggiunta;
            DEALLOCATE PREPARE aggiunta;
            SET foreign_key_checks = @fatturapa_controlli;
        END IF;
    END IF;

    IF messaggio IS NOT NULL THEN
        SET @fatturapa_note = CONCAT_WS( '\n', @fatturapa_note, CONCAT( vincolo, ': ', messaggio ) );
    END IF;

END;

-- | 202609301821

-- documenti_casse_previdenziali.id_documento -> documenti: i contributi fanno parte della scheda del documento
CALL `__patch_fatturapa__`( 'documenti_casse_previdenziali', 'documenti_casse_previdenziali_ibfk_01', 'id_documento', 'documenti', 'CASCADE', 'CASCADE' );

-- | 202609301822

-- documenti_casse_previdenziali.id_cassa_previdenziale -> casse_previdenziali
CALL `__patch_fatturapa__`( 'documenti_casse_previdenziali', 'documenti_casse_previdenziali_ibfk_02_nofollow', 'id_cassa_previdenziale', 'casse_previdenziali', 'NO ACTION', 'CASCADE' );

-- | 202609301823

-- documenti_casse_previdenziali.id_iva -> iva
CALL `__patch_fatturapa__`( 'documenti_casse_previdenziali', 'documenti_casse_previdenziali_ibfk_03_nofollow', 'id_iva', 'iva', 'SET NULL', 'SET NULL' );

-- | 202609301824

-- documenti_casse_previdenziali.id_account_inserimento
CALL `__patch_fatturapa__`( 'documenti_casse_previdenziali', 'documenti_casse_previdenziali_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL' );

-- | 202609301825

-- documenti_casse_previdenziali.id_account_aggiornamento
CALL `__patch_fatturapa__`( 'documenti_casse_previdenziali', 'documenti_casse_previdenziali_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL' );

-- | 202609301826

-- documenti_ritenute.id_documento -> documenti: le ritenute fanno parte della scheda del documento
CALL `__patch_fatturapa__`( 'documenti_ritenute', 'documenti_ritenute_ibfk_01', 'id_documento', 'documenti', 'CASCADE', 'CASCADE' );

-- | 202609301827

-- documenti_ritenute.id_ritenuta -> ritenute
CALL `__patch_fatturapa__`( 'documenti_ritenute', 'documenti_ritenute_ibfk_02_nofollow', 'id_ritenuta', 'ritenute', 'NO ACTION', 'CASCADE' );

-- | 202609301828

-- documenti_ritenute.id_account_inserimento
CALL `__patch_fatturapa__`( 'documenti_ritenute', 'documenti_ritenute_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL' );

-- | 202609301829

-- documenti_ritenute.id_account_aggiornamento
CALL `__patch_fatturapa__`( 'documenti_ritenute', 'documenti_ritenute_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL' );

-- | 202609301830

-- quello che non si e' potuto fare, e perche': lo legge chi applica la patch a mano
SELECT @fatturapa_note AS nota;

-- | 202609301831

-- si libera la procedura
DROP PROCEDURE IF EXISTS `__patch_fatturapa__`;

-- | 202609301832

-- iva, l'art. 71 con la natura N3.6: la sostituisce la riga 60 ( N3.3, cessioni verso San Marino )
UPDATE `iva` SET `timestamp_archiviazione` = unix_timestamp()
	WHERE `id` = 35 AND `codice` = 'N3.6' AND `nome` = 'non imponibile ex art. 71 d.P.R. 633/1972'
	AND `timestamp_archiviazione` IS NULL;

-- | 202609301833

-- iva, il reverse charge con la natura generica N6: lo sostituiscono le righe da 61 a 69 ( N6.1 - N6.9 )
UPDATE `iva` SET `timestamp_archiviazione` = unix_timestamp()
	WHERE ( ( `id` = 57 AND `nome` = 'regime ex art. 17 c. 6 d.P.R. 633/1972 (rev. charge)' )
		OR ( `id` = 58 AND `nome` = 'regime ex art. 17 cc. 7 e 8 d.P.R. 633/1972 (rev. charge)' ) )
	AND `codice` = 'N6' AND `timestamp_archiviazione` IS NULL;

-- | FINE FILE
