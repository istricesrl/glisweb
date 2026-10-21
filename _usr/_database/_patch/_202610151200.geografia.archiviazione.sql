-- 2026-10-15 — colonne di archiviazione su stati, regioni, provincie e comuni
--
-- Lo schema standard ( _010000999999.tables.sql ) da' a ogni tabella della geografia id_successore,
-- data_archiviazione e note_archiviazione, con indici, la chiave esterna <tabella>_ibfk_02_nofollow verso se'
-- stessa e comuni_view che espone data_archiviazione e id_successore; mancava la patch incrementale che le
-- portasse su un database gia' installato. Senza queste colonne un comune soppresso ( Bazzano, Crespellano,
-- Porretta Terme... ) non si puo' marcare come tale, resta proposto nelle tendine accanto al comune che l'ha
-- assorbito, e il restrict { 'data_archiviazione': { 'NL': 1 } } della tendina comuni della modale indirizzo
-- di athena da' errore 1054.
--
-- Nata su polmasi il 14/10 ( usr/database/patch/_202610141500 ), promossa il 15/10 con un id nuovo, maggiore
-- dell'ultimo standard.
--
-- Un ALTER per marcatore, come in _202610121100.
--
-- IDEMPOTENTE: IF NOT EXISTS su colonne, indici e chiavi esterne ( MariaDB 10.3 ).

-- | 202610151200

ALTER TABLE `stati`
	ADD COLUMN IF NOT EXISTS `id_successore` bigint(20) DEFAULT NULL AFTER `id_continente`,
	ADD COLUMN IF NOT EXISTS `data_archiviazione` date DEFAULT NULL AFTER `codice_istat`,
	ADD COLUMN IF NOT EXISTS `note_archiviazione` text DEFAULT NULL AFTER `data_archiviazione`,
	ADD KEY IF NOT EXISTS `id_successore` (`id_successore`),
	ADD KEY IF NOT EXISTS `data_archiviazione` (`data_archiviazione`);

-- | 202610151201

ALTER TABLE `stati` ADD CONSTRAINT `stati_ibfk_02_nofollow` FOREIGN KEY IF NOT EXISTS (`id_successore`) REFERENCES `stati` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202610151202

ALTER TABLE `regioni`
	ADD COLUMN IF NOT EXISTS `id_successore` bigint(20) DEFAULT NULL AFTER `id_stato`,
	ADD COLUMN IF NOT EXISTS `data_archiviazione` date DEFAULT NULL AFTER `note`,
	ADD COLUMN IF NOT EXISTS `note_archiviazione` text DEFAULT NULL AFTER `data_archiviazione`,
	ADD KEY IF NOT EXISTS `id_successore` (`id_successore`),
	ADD KEY IF NOT EXISTS `data_archiviazione` (`data_archiviazione`);

-- | 202610151203

ALTER TABLE `regioni` ADD CONSTRAINT `regioni_ibfk_02_nofollow` FOREIGN KEY IF NOT EXISTS (`id_successore`) REFERENCES `regioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202610151204

ALTER TABLE `provincie`
	ADD COLUMN IF NOT EXISTS `id_successore` bigint(20) DEFAULT NULL AFTER `id_regione`,
	ADD COLUMN IF NOT EXISTS `data_archiviazione` date DEFAULT NULL AFTER `note`,
	ADD COLUMN IF NOT EXISTS `note_archiviazione` text DEFAULT NULL AFTER `data_archiviazione`,
	ADD KEY IF NOT EXISTS `id_successore` (`id_successore`),
	ADD KEY IF NOT EXISTS `data_archiviazione` (`data_archiviazione`);

-- | 202610151205

ALTER TABLE `provincie` ADD CONSTRAINT `provincie_ibfk_02_nofollow` FOREIGN KEY IF NOT EXISTS (`id_successore`) REFERENCES `provincie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202610151206

ALTER TABLE `comuni`
	ADD COLUMN IF NOT EXISTS `id_successore` bigint(20) DEFAULT NULL AFTER `id_provincia`,
	ADD COLUMN IF NOT EXISTS `data_archiviazione` date DEFAULT NULL AFTER `note`,
	ADD COLUMN IF NOT EXISTS `note_archiviazione` text DEFAULT NULL AFTER `data_archiviazione`,
	ADD KEY IF NOT EXISTS `id_successore` (`id_successore`),
	ADD KEY IF NOT EXISTS `data_archiviazione` (`data_archiviazione`);

-- | 202610151207

ALTER TABLE `comuni` ADD CONSTRAINT `comuni_ibfk_02_nofollow` FOREIGN KEY IF NOT EXISTS (`id_successore`) REFERENCES `comuni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202610151208

-- comuni_view, come in _090000999999.views.sql
CREATE OR REPLACE VIEW `comuni_view` AS
	SELECT
		comuni.id,
		comuni.id_provincia,
		provincie.nome AS provincia,
		provincie.sigla AS sigla_provincia,
		provincie.id_regione,
		regioni.nome AS regione,
		regioni.id_stato,
		stati.nome AS stato,
		comuni.nome,
		comuni.codice_istat,
		comuni.codice_catasto,
		comuni.data_archiviazione,
		comuni.id_successore,
		concat(
			comuni.nome, ' ',
			coalesce(
				concat( '(', provincie.sigla, ') '),
				' '
			),
			stati.nome
		) AS __label__
	FROM comuni
		INNER JOIN provincie
			ON provincie.id = comuni.id_provincia
		INNER JOIN regioni
			ON regioni.id = provincie.id_regione
		INNER JOIN stati
			ON stati.id = regioni.id_stato
;

-- | FINE
