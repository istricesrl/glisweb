-- 2026-09-17 — le due tabelle di report del sottoscorta.
--
-- Contesto: il sottoscorta arriva a monte dal deploy bernispa, dove e' nato fra l'8 e il 16/09/2026.
-- Il motore e' _mod/_0500.mastri/_src/_api/_task/_rifornimenti.da.sottoscorta.php, che gira due
-- volte al giorno, riscrive per intero queste due tabelle e genera le missioni di rifornimento; la
-- scheda che le mostra e' logistica.sottoscorta.view, nel modulo _5000.logistica.
--
-- Sono tabelle __report_*__: materializzate, riscritte per intero a ogni giro, mai aggiornate riga
-- per riga da un utente. Fino a ieri le tabelle di questa famiglia non stavano nei patch standard e
-- vivevano solo nei database dei progetti che le usavano ( e' il caso di
-- __report_giacenza_magazzini__, che ancora oggi nasce fuori di qui ). Qui si e' scelto di
-- dichiararle, perche' la scheda che le legge e' standard: senza la tabella la scheda non ha niente
-- da leggere, e il disallineamento fra codice e schema tornerebbe a essere invisibile.
--
-- La scheda non compare dove il progetto non ha dichiarato l'automazione ( la guardia e' in
-- _mod/_5000.logistica/_src/_inc/_pages/_logistica.it-IT.php, su
-- $cf['automazioni']['profile']['sottoscorta'] ), quindi su un deploy che non usa il sottoscorta
-- queste due tabelle restano vuote e non le legge nessuno.
--
-- COSA NON C'E' QUI, di proposito:
--  - la deduplicazione di mastri_articoli e la UNIQUE ( id_mastro, id_articolo ): su bernispa la
--    migrazione 2026091602 cancella le righe doppie prima di poter creare l'indice, e una DELETE
--    su una tabella di esercizio non si porta a monte dentro un patch che gira dappertutto. Chi
--    vuole l'indice se lo fa a mano dopo aver guardato i suoi doppioni;
--  - le unita' di misura SC / PC / RS / AS / FF, che sono il confezionamento di SAM: dato di
--    progetto, non dello standard.
--
-- IDEMPOTENTE ( CREATE TABLE IF NOT EXISTS, ADD COLUMN IF NOT EXISTS ). MariaDB 10.3.

-- la soglia si dichiara nell'unita' del magazzino ( "12 scatole" ) e il task la converte
-- nell'unita' inventariale per confrontarla con la giacenza: serve sapere in quale unita' e'
-- stata scritta, altrimenti chi ha scritto 12 si rilegge 2.400 senza un appiglio.
ALTER TABLE `mastri_articoli`
	ADD COLUMN IF NOT EXISTS `id_udm` bigint(20) DEFAULT NULL AFTER `scorta_massima`,
	ADD KEY IF NOT EXISTS `id_udm` (`id_udm`);

-- le segnalazioni, e le ubicazioni sorvegliate che invece sono a posto: se_allarme distingue le
-- une dalle altre, e la scheda si apre sulle sole in allarme
CREATE TABLE IF NOT EXISTS `__report_sottoscorta__` (

	-- chiave sintetica <id_mastro>|<id_articolo>, come __report_giacenza_magazzini__
	`id` varchar(56) NOT NULL,

	-- l'articolo e dove e' andato sottoscorta
	`id_articolo` char(32) DEFAULT NULL,
	`articolo` varchar(331) DEFAULT NULL,
	`id_mastro` bigint(20) DEFAULT NULL,
	`collocazione` char(64) DEFAULT NULL,

	-- i numeri della segnalazione, nell'unita' inventariale e come sono stati dichiarati
	`giacenza` decimal(21,2) DEFAULT NULL,
	`scorta_minima` decimal(21,2) DEFAULT NULL,
	`scorta_minima_dichiarata` decimal(21,2) DEFAULT NULL COMMENT 'la soglia come l''ha scritta il magazzino, nell''unita'' di udm',
	`scorta_massima` decimal(21,2) DEFAULT NULL,
	`scorta_massima_dichiarata` decimal(21,2) DEFAULT NULL,
	`udm` char(32) DEFAULT NULL COMMENT 'nome dell''unita'' in cui e'' dichiarata la soglia; NULL = unita'' inventariale',
	`mancante` decimal(21,2) DEFAULT NULL COMMENT 'quanto serve per tornare a scorta massima',

	-- da dove si rifornisce
	`id_mastro_bulk` bigint(20) DEFAULT NULL,
	`bulk` char(64) DEFAULT NULL,
	`giacenza_bulk` decimal(21,2) DEFAULT NULL,
	`quantita_richiesta` decimal(21,2) DEFAULT NULL COMMENT 'il mancante, limitato a quello che il bulk ha davvero',

	-- che cosa ne e' stato
	`id_missione` bigint(20) DEFAULT NULL,
	`missione` char(32) DEFAULT NULL,
	`esito` char(32) DEFAULT NULL COMMENT 'rifornita | non rifornibile',
	`se_allarme` tinyint(1) DEFAULT NULL COMMENT '1 = giacenza sotto la soglia adesso; 0 = ubicazione sorvegliata e a posto',
	`motivo` text DEFAULT NULL,

	`timestamp_aggiornamento` int(11) DEFAULT NULL,
	`__label__` mediumtext DEFAULT NULL,

	PRIMARY KEY (`id`),
	KEY `id_articolo` (`id_articolo`),
	KEY `id_mastro` (`id_mastro`),
	KEY `esito` (`esito`),
	KEY `se_allarme` (`se_allarme`),
	KEY `timestamp_aggiornamento` (`timestamp_aggiornamento`)

) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- le soglie che non si sanno convertire: stanno in una tabella loro e non in una riga a parte del
-- report, perche' non sono segnalazioni ( non hanno giacenza, ne' mancante, ne' esito ) e
-- mescolarle gonfierebbe il conteggio dei sottoscorta. Il task le svuota e le riscrive a ogni giro
-- come l'altra.
CREATE TABLE IF NOT EXISTS `__report_scorte_non_valutabili__` (
	`id` varchar(56) NOT NULL,
	`id_articolo` char(32) DEFAULT NULL,
	`articolo` varchar(331) DEFAULT NULL,
	`id_mastro` bigint(20) DEFAULT NULL,
	`collocazione` char(64) DEFAULT NULL,
	`scorta_minima` decimal(21,2) DEFAULT NULL COMMENT 'come dichiarata: qui non c''e'' niente da convertire',
	`scorta_massima` decimal(21,2) DEFAULT NULL,
	`udm` char(32) DEFAULT NULL,
	`motivo` text DEFAULT NULL,
	`timestamp_aggiornamento` int(11) DEFAULT NULL,
	`__label__` mediumtext DEFAULT NULL,
	PRIMARY KEY (`id`),
	KEY `id_articolo` (`id_articolo`),
	KEY `id_mastro` (`id_mastro`),
	KEY `timestamp_aggiornamento` (`timestamp_aggiornamento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- | FINE
