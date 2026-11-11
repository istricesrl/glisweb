--
-- 2026-11-11 — veicoli: i veicoli diventano asset, le loro tipologie un ramo di tipologie_asset
--
-- Schema canonico, punto 6, riga 236, decisione di Fabio dell'11/11/2026: veicoli confluisce in asset, come le macchine
-- di V150, e il modulo VE000.veicoli lavora sulla vista virtuale veicoli_view ( gli asset la cui tipologia sta in un
-- ramo con se_veicoli sulla radice ). Asset prende quello che i veicoli avevano in più ( produttore, modello, targa,
-- archiviazione ), tipologie_asset il flag di classe, e nasce mastri_tipologie_asset al posto di mastri_tipologie_veicoli.
--
-- Cosa fa:
-- - asset: riordina le colonne sull'ordine master ( codice e nome in testa ), allarga nome a char(255), aggiunge
--   id_produttore, modello, targa, data_archiviazione e note_archiviazione, le loro chiavi ( UNIQUE targa ) e la chiave
--   esterna verso il produttore;
-- - tipologie_asset: aggiunge se_veicoli e lo mette in indice;
-- - crea mastri_tipologie_asset, vuota, con chiavi e chiavi esterne;
-- - copia le righe di tipologie_veicoli in tipologie_asset con gli stessi id e se_veicoli acceso, una passata per
--   livello dell'albero, e quelle di veicoli in asset con gli stessi id ( id_costruttore in id_produttore, descrizione
--   in note ). Misura dell'11/11: le uniche righe sono su bernispa ( 6 tipologie, 6 muletti di prova ), dove asset e
--   tipologie_asset sono vuote; una riga il cui id è già preso non si copia.
--
-- Cosa NON fa: non tocca veicoli, tipologie_veicoli e mastri_tipologie_veicoli, che i moduli legacy di glisweb leggono
-- ancora ( 0400.documenti, 0500.mastri ) e che escono al punto 12, col travaso delle righe di mastri_tipologie_veicoli
-- ( 2.246 su bernispa ) e il DROP. Le viste stanno nei file base.
--
-- IDEMPOTENTE.
--

-- | 202611111200

-- asset: codice e nome in testa, nome char(255)
ALTER TABLE `asset`
	MODIFY `codice` char(32) DEFAULT NULL AFTER `id_tipologia`,
	MODIFY `nome` char(255) DEFAULT NULL AFTER `codice`,
	MODIFY `id_condizione` bigint(20) DEFAULT NULL AFTER `nome`;

-- | 202611111201

-- asset: produttore, modello e targa dopo la condizione
ALTER TABLE `asset`
	ADD COLUMN IF NOT EXISTS `id_produttore` bigint(20) DEFAULT NULL AFTER `id_condizione`;
ALTER TABLE `asset`
	ADD COLUMN IF NOT EXISTS `modello` char(255) DEFAULT NULL AFTER `id_produttore`;
ALTER TABLE `asset`
	ADD COLUMN IF NOT EXISTS `targa` char(16) DEFAULT NULL AFTER `modello`;

-- | 202611111202

-- asset: archiviazione dopo le note
ALTER TABLE `asset`
	ADD COLUMN IF NOT EXISTS `data_archiviazione` date DEFAULT NULL AFTER `note`;
ALTER TABLE `asset`
	ADD COLUMN IF NOT EXISTS `note_archiviazione` text DEFAULT NULL AFTER `data_archiviazione`;

-- | 202611111203

-- asset: chiavi
ALTER TABLE `asset`
	DROP INDEX IF EXISTS `indice`;
ALTER TABLE `asset`
	ADD UNIQUE KEY IF NOT EXISTS `targa` (`targa`),
	ADD KEY IF NOT EXISTS `id_produttore` (`id_produttore`),
	ADD KEY IF NOT EXISTS `data_archiviazione` (`data_archiviazione`),
	ADD KEY `indice` (`id`,`id_genitore`,`id_tipologia`,`codice`,`targa`,`data_archiviazione`);

-- | 202611111204

-- asset: chiave esterna verso il produttore
ALTER TABLE `asset`
	ADD CONSTRAINT `asset_ibfk_04_nofollow` FOREIGN KEY IF NOT EXISTS (`id_produttore`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611111205

-- tipologie_asset: il flag di classe dei veicoli
ALTER TABLE `tipologie_asset`
	ADD COLUMN IF NOT EXISTS `se_veicoli` tinyint(1) DEFAULT NULL AFTER `font_awesome`;
ALTER TABLE `tipologie_asset`
	DROP INDEX IF EXISTS `indice`;
ALTER TABLE `tipologie_asset`
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`,`se_veicoli`);

-- | 202611111206

-- mastri_tipologie_asset: la tabella, vuota
CREATE TABLE IF NOT EXISTS `mastri_tipologie_asset` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ordine` int(11) DEFAULT NULL,
  `id_mastro` bigint(20) DEFAULT NULL,
  `id_tipologia` bigint(20) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_mastro`,`id_tipologia`),
  KEY `ordine` (`ordine`),
  KEY `id_mastro` (`id_mastro`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`ordine`,`id_mastro`,`id_tipologia`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202611111207

-- mastri_tipologie_asset: chiavi esterne
ALTER TABLE `mastri_tipologie_asset`
	ADD CONSTRAINT `mastri_tipologie_asset_ibfk_01` FOREIGN KEY IF NOT EXISTS (`id_mastro`) REFERENCES `mastri` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `mastri_tipologie_asset_ibfk_02_nofollow` FOREIGN KEY IF NOT EXISTS (`id_tipologia`) REFERENCES `tipologie_asset` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `mastri_tipologie_asset_ibfk_98_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `mastri_tipologie_asset_ibfk_99_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611111208

-- tipologie_asset: le tipologie di veicolo, con gli stessi id e il flag di classe; una passata per livello dell'albero,
-- perché il genitore deve esserci prima del figlio ( FK su id_genitore ), cinque livelli bastano
INSERT INTO `tipologie_asset` ( `id`, `id_genitore`, `ordine`, `codice`, `nome`, `html_entity`, `font_awesome`, `se_veicoli`,
		`id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento` )
	SELECT tv.id, tv.id_genitore, tv.ordine, tv.codice, tv.nome, tv.html_entity, tv.font_awesome, 1,
		tv.id_account_inserimento, tv.timestamp_inserimento, tv.id_account_aggiornamento, tv.timestamp_aggiornamento
	FROM `tipologie_veicoli` AS tv
	WHERE tv.id NOT IN ( SELECT id FROM `tipologie_asset` )
		AND ( tv.id_genitore IS NULL OR tv.id_genitore IN ( SELECT id FROM `tipologie_asset` ) );
INSERT INTO `tipologie_asset` ( `id`, `id_genitore`, `ordine`, `codice`, `nome`, `html_entity`, `font_awesome`, `se_veicoli`,
		`id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento` )
	SELECT tv.id, tv.id_genitore, tv.ordine, tv.codice, tv.nome, tv.html_entity, tv.font_awesome, 1,
		tv.id_account_inserimento, tv.timestamp_inserimento, tv.id_account_aggiornamento, tv.timestamp_aggiornamento
	FROM `tipologie_veicoli` AS tv
	WHERE tv.id NOT IN ( SELECT id FROM `tipologie_asset` )
		AND ( tv.id_genitore IS NULL OR tv.id_genitore IN ( SELECT id FROM `tipologie_asset` ) );
INSERT INTO `tipologie_asset` ( `id`, `id_genitore`, `ordine`, `codice`, `nome`, `html_entity`, `font_awesome`, `se_veicoli`,
		`id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento` )
	SELECT tv.id, tv.id_genitore, tv.ordine, tv.codice, tv.nome, tv.html_entity, tv.font_awesome, 1,
		tv.id_account_inserimento, tv.timestamp_inserimento, tv.id_account_aggiornamento, tv.timestamp_aggiornamento
	FROM `tipologie_veicoli` AS tv
	WHERE tv.id NOT IN ( SELECT id FROM `tipologie_asset` )
		AND ( tv.id_genitore IS NULL OR tv.id_genitore IN ( SELECT id FROM `tipologie_asset` ) );
INSERT INTO `tipologie_asset` ( `id`, `id_genitore`, `ordine`, `codice`, `nome`, `html_entity`, `font_awesome`, `se_veicoli`,
		`id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento` )
	SELECT tv.id, tv.id_genitore, tv.ordine, tv.codice, tv.nome, tv.html_entity, tv.font_awesome, 1,
		tv.id_account_inserimento, tv.timestamp_inserimento, tv.id_account_aggiornamento, tv.timestamp_aggiornamento
	FROM `tipologie_veicoli` AS tv
	WHERE tv.id NOT IN ( SELECT id FROM `tipologie_asset` )
		AND ( tv.id_genitore IS NULL OR tv.id_genitore IN ( SELECT id FROM `tipologie_asset` ) );
INSERT INTO `tipologie_asset` ( `id`, `id_genitore`, `ordine`, `codice`, `nome`, `html_entity`, `font_awesome`, `se_veicoli`,
		`id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento` )
	SELECT tv.id, tv.id_genitore, tv.ordine, tv.codice, tv.nome, tv.html_entity, tv.font_awesome, 1,
		tv.id_account_inserimento, tv.timestamp_inserimento, tv.id_account_aggiornamento, tv.timestamp_aggiornamento
	FROM `tipologie_veicoli` AS tv
	WHERE tv.id NOT IN ( SELECT id FROM `tipologie_asset` )
		AND ( tv.id_genitore IS NULL OR tv.id_genitore IN ( SELECT id FROM `tipologie_asset` ) );

-- | 202611111209

-- asset: i veicoli, con gli stessi id; quelli senza tipologia, o con una tipologia che non è passata, restano in veicoli:
-- un asset senza tipologia non sarebbe un veicolo, e si guardano a mano al punto 12
INSERT INTO `asset` ( `id`, `id_tipologia`, `nome`, `id_produttore`, `modello`, `targa`, `note`,
		`data_archiviazione`, `note_archiviazione`,
		`id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento` )
	SELECT v.id, v.id_tipologia, v.nome, v.id_costruttore, v.modello, v.targa, v.descrizione,
		v.data_archiviazione, v.note_archiviazione,
		v.id_account_inserimento, v.timestamp_inserimento, v.id_account_aggiornamento, v.timestamp_aggiornamento
	FROM `veicoli` AS v
	WHERE v.id NOT IN ( SELECT id FROM `asset` )
		AND v.id_tipologia IN ( SELECT id FROM `tipologie_asset` WHERE se_veicoli = 1 );

-- | FINE
