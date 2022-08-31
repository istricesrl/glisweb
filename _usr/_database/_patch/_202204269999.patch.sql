--
-- PATCH
--

--| 202208310060
ALTER TABLE udm
ADD COLUMN `se_area` int(1) DEFAULT NULL AFTER se_quantita,
ADD KEY `se_area` (`se_area`);

--| 202208310070
REPLACE INTO `udm` (`id`, `id_base`, `conversione`, `nome`, `sigla`, `note`, `se_lunghezza`, `se_volume`, `se_massa`, `se_tempo`, `se_quantita`, `se_area`) VALUES
(1,	NULL,	NULL,	'pezzi',	'pz.',	'unità di misura usata genericamente per misurare le quantità',	NULL,	NULL,	NULL,	NULL,	1,	NULL),
(2,	NULL,	1,	'millimetro',	'mm',	'https://it.wikipedia.org/wiki/Metro',	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	2,	10,	'centimetro',	'cm',	'https://it.wikipedia.org/wiki/Metro',	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(4,	2,	100,	'decimetro',	'dm',	'https://it.wikipedia.org/wiki/Metro',	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(5,	2,	1000,	'metro',	'm',	'https://it.wikipedia.org/wiki/Metro',	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(6,	2,	10000,	'decametro',	'dam',	'https://it.wikipedia.org/wiki/Metro',	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(7,	2,	100000,	'ettometro',	'hm',	'https://it.wikipedia.org/wiki/Metro',	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(8,	2,	1000000,	'kilometro',	'km',	'https://it.wikipedia.org/wiki/Metro',	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(9,	NULL,	1,	'milligrammo',	'mg',	'https://it.wikipedia.org/wiki/Chilogrammo',	NULL,	NULL,	1,	NULL,	NULL,	NULL),
(10,	9,	10,	'centigrammo',	'cg',	'https://it.wikipedia.org/wiki/Chilogrammo',	NULL,	NULL,	1,	NULL,	NULL,	NULL),
(11,	9,	100,	'decigrammo',	'dg',	'https://it.wikipedia.org/wiki/Chilogrammo',	NULL,	NULL,	1,	NULL,	NULL,	NULL),
(12,	9,	1000,	'grammo',	'gr',	'https://it.wikipedia.org/wiki/Chilogrammo',	NULL,	NULL,	1,	NULL,	NULL,	NULL),
(13,	9,	10000,	'decagrammo',	'dag',	'https://it.wikipedia.org/wiki/Chilogrammo',	NULL,	NULL,	1,	NULL,	NULL,	NULL),
(14,	9,	100000,	'ettogrammo',	'hg',	'https://it.wikipedia.org/wiki/Chilogrammo',	NULL,	NULL,	1,	NULL,	NULL,	NULL),
(15,	9,	1000000,	'kilogrammo',	'kg',	'https://it.wikipedia.org/wiki/Chilogrammo',	NULL,	NULL,	1,	NULL,	NULL,	NULL),
(16,	NULL,	1,	'millilitro',	'ml',	'https://it.wikipedia.org/wiki/Litro',	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(17,	16,	10,	'centilitro',	'cl',	'https://it.wikipedia.org/wiki/Litro',	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(18,	16,	100,	'decilitro',	'dl',	'https://it.wikipedia.org/wiki/Litro',	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(19,	16,	1000,	'litro',	'l',	'https://it.wikipedia.org/wiki/Litro',	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(20,	16,	10000,	'decalitro',	'dal',	'https://it.wikipedia.org/wiki/Litro',	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(21,	16,	100000,	'ettolitro',	'hl',	'https://it.wikipedia.org/wiki/Litro',	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(22,	16,	1000000,	'kilolitro',	'kl',	'https://it.wikipedia.org/wiki/Litro',	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(23,	NULL,	1,	'secondo',	's',	'https://it.wikipedia.org/wiki/Secondo',	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(24,	23,	60,	'minuto',	'min',	'https://it.wikipedia.org/wiki/Minuto',	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(25,	23,	3600,	'ora',	'h',	'https://it.wikipedia.org/wiki/Ora',	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(26,	23,	86400,	'giorno',	'd',	'https://it.wikipedia.org/wiki/Giorno',	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(27,	9,	100000000,	'quintale',	'q',	'https://it.wikipedia.org/wiki/Quintale',	NULL,	NULL,	1,	NULL,	NULL,	NULL),
(28,	9,	1000000000,	'tonnellata',	't',	'https://it.wikipedia.org/wiki/Tonnellata',	NULL,	NULL,	1,	NULL,	NULL,	NULL),
(29,	NULL,	1,	'millimetro quadrato',	'mm²',	'https://it.wikipedia.org/wiki/Metro_quadrato',	1,	NULL,	NULL,	NULL,	NULL,	1),
(30,	29,	100,	'centimetro quadrato',	'cm²',	'https://it.wikipedia.org/wiki/Metro_quadrato',	1,	NULL,	NULL,	NULL,	NULL,	1),
(31,	29,	10000,	'decimetro quadrato',	'dm²',	'https://it.wikipedia.org/wiki/Metro_quadrato',	1,	NULL,	NULL,	NULL,	NULL,	1),
(32,	29,	1000000,	'metro quadrato',	'm²',	'https://it.wikipedia.org/wiki/Metro_quadrato',	1,	NULL,	NULL,	NULL,	NULL,	1),
(33,	29,	100000000,	'decametro quadrato',	'dam²',	'https://it.wikipedia.org/wiki/Metro_quadrato',	1,	NULL,	NULL,	NULL,	NULL,	1),
(34,	29,	10000000000,	'ettometro quadrato',	'hm²',	'https://it.wikipedia.org/wiki/Metro_quadrato',	1,	NULL,	NULL,	NULL,	NULL,	1),
(35,	29,	1000000000000,	'kilometro quadrato',	'km²',	'https://it.wikipedia.org/wiki/Metro_quadrato',	1,	NULL,	NULL,	NULL,	NULL,	1),
(36,	29,	1000000,	'centiara',	'ca',	'https://it.wikipedia.org/wiki/Centiara',	1,	NULL,	NULL,	NULL,	NULL,	1),
(37,	29,	100000000,	'ara',	'a',	'https://it.wikipedia.org/wiki/Ara_(unità_di_misura)',	1,	NULL,	NULL,	NULL,	NULL,	1),
(38,	29,	10000000000,	'ettaro',	'ha',	'https://it.wikipedia.org/wiki/Ettaro',	1,	NULL,	NULL,	NULL,	NULL,	1)
ON DUPLICATE KEY UPDATE
	id_base = VALUES( id_base ),
	conversione = VALUES( conversione ),
	nome = VALUES(nome),
	sigla = VALUES(sigla),
	note = VALUES(note),
	se_lunghezza = VALUES( se_lunghezza ),
	se_volume = VALUES(se_volume),
	se_massa = VALUES(se_massa),
	se_tempo = VALUES(se_tempo),
	se_quantita = VALUES(se_quantita),
	se_area = VALUES(se_area);

--| 202208310080
CREATE OR REPLACE VIEW udm_view AS
	SELECT
		udm.id,
		coalesce( udm.id_base, udm.id ) AS id_base,
		coalesce( udm.conversione, 1 ) AS conversione,
		udm.nome,
		udm.sigla,
		udm.se_lunghezza,
		udm.se_volume,
		udm.se_massa,
		udm.se_tempo,
		udm.se_quantita,
		udm.se_area,
		udm.sigla AS __label__
	FROM udm
;

--| 202208310090
CREATE OR REPLACE VIEW `risorse_view` AS
	SELECT
		risorse.id, 
		risorse.id_tipologia,
		tipologie_risorse.nome AS tipologia,
		risorse.codice, 
		risorse.nome,
		risorse.id_testata, 
		testate.nome AS testata,
		risorse.giorno_pubblicazione,
		risorse.mese_pubblicazione,
		risorse.anno_pubblicazione,
		group_concat( DISTINCT categorie_risorse_path( categorie_risorse.id ) SEPARATOR ' | ' ) AS categorie,
		risorse.id_account_inserimento,
		risorse.id_account_aggiornamento,
		concat_ws(
			' ',
			risorse.codice,
			risorse.nome
		) AS __label__
	FROM risorse
		LEFT JOIN tipologie_risorse ON tipologie_risorse.id = risorse.id_tipologia
		LEFT JOIN testate ON testate.id = risorse.id_testata
		LEFT JOIN risorse_categorie ON risorse_categorie.id_risorsa = risorse.id
		LEFT JOIN categorie_risorse ON categorie_risorse.id = risorse_categorie.id_categoria
	GROUP BY risorse.id
;

--| 202208310100
alter table tipologie_prodotti
change `se_peso`  `se_massa` tinyint(1) DEFAULT NULL;

--| 202208310110
CREATE OR REPLACE VIEW `tipologie_prodotti_view` AS
	SELECT
		tipologie_prodotti.id,
		tipologie_prodotti.id_genitore,
		tipologie_prodotti.ordine,
		tipologie_prodotti.nome,
		tipologie_prodotti.html_entity,
		tipologie_prodotti.font_awesome,
		tipologie_prodotti.se_colori,
		tipologie_prodotti.se_taglie,
		tipologie_prodotti.se_dimensioni,
		tipologie_prodotti.se_imballo,
		tipologie_prodotti.se_spedizione,
		tipologie_prodotti.se_trasporto,
		tipologie_prodotti.se_prodotto,
		tipologie_prodotti.se_servizio,
		tipologie_prodotti.se_volume,
		tipologie_prodotti.se_capacita,
		tipologie_prodotti.se_massa,
		tipologie_prodotti.id_account_inserimento,
		tipologie_prodotti.id_account_aggiornamento,
		tipologie_prodotti_path( tipologie_prodotti.id ) AS __label__
	FROM tipologie_prodotti
;

--| 202208310120
CREATE TABLE IF NOT EXISTS `progetti_certificazioni` (
  `id` int NOT NULL,
  `id_progetto` char(32) NOT NULL,
  `id_certificazione` int DEFAULT NULL,
  `nome` char(1) DEFAULT NULL,
  `note` text,
  `se_richiesta` int(1) DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL
) ENGINE=InnoDB;

--| 202208310130
ALTER TABLE `progetti_certificazioni`
ADD COLUMN   `ordine` int(11) DEFAULT NULL AFTER `id_certificazione`;

--| 202208310140
ALTER TABLE `progetti_certificazioni`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_progetto`,`id_certificazione`), 
	ADD KEY `id_progetto` (`id_progetto`), 
	ADD KEY `id_certificazione` (`id_certificazione`), 
	ADD KEY `ordine` (`ordine`),
	ADD KEY `se_richiesta` (`se_richiesta`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_progetto`,`id_certificazione`,`ordine`);

--| 202208310150
ALTER TABLE `progetti_certificazioni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202208310160
ALTER TABLE `progetti_certificazioni`
    ADD CONSTRAINT `progetti_certificazioni_ibfk_01`             FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `progetti_certificazioni_ibfk_02_nofollow`    FOREIGN KEY (`id_certificazione`) REFERENCES `certificazioni` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `progetti_certificazioni_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `progetti_certificazioni_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202208310170
CREATE OR REPLACE VIEW progetti_certificazioni_view AS
	SELECT
		progetti_certificazioni.id,
		progetti_certificazioni.id_progetto,
		progetti.nome AS progetto,
		progetti_certificazioni.id_certificazione,
		certificazioni.nome AS certificazione,
		progetti_certificazioni.ordine,
		progetti_certificazioni.se_richiesta,
		progetti_certificazioni.id_account_inserimento,
		progetti_certificazioni.id_account_aggiornamento,
 		concat_ws(
			' ',
			progetti.nome,
			'/',
			certificazioni.nome 
		) AS __label__
	FROM progetti_certificazioni
		LEFT JOIN progetti ON progetti.id = progetti_certificazioni.id_progetto
		LEFT JOIN certificazioni ON certificazioni.id = progetti_certificazioni.id_certificazione
;

--| 202208310180
CREATE TABLE IF NOT EXISTS `todo_matricole` (
  `id` int(11) NOT NULL,
  `id_todo` int(11) NOT NULL,
  `id_matricola` int(11) NOT NULL,
  `id_ruolo` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` int(11) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` int(11) DEFAULT NULL	
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202208310190
ALTER TABLE `todo_matricole`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_todo`,`id_matricola`,`id_ruolo`), 
	ADD KEY `id_todo` (`id_todo`), 
	ADD KEY `id_matricola` (`id_matricola`), 
	ADD KEY `id_ruolo` (`id_ruolo`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_todo`,`id_matricola`,`ordine`,`id_ruolo`);

--| 202208310200
ALTER TABLE `todo_matricole` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202208310210
ALTER TABLE `todo_matricole`
    ADD CONSTRAINT `todo_matricole_ibfk_01`             FOREIGN KEY (`id_todo`) REFERENCES `todo` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `todo_matricole_ibfk_02_nofollow`    FOREIGN KEY (`id_matricola`) REFERENCES `matricole` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `todo_matricole_ibfk_03_nofollow`    FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_matricole` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `todo_matricole_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `todo_matricole_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202208310220
CREATE OR REPLACE VIEW todo_matricole_view AS
	SELECT
		todo_matricole.id,
		todo_matricole.id_todo,
		todo.nome AS todo,
		todo_matricole.id_matricola,
		matricole.matricola AS matricola,
		todo_matricole.id_ruolo,
		ruoli_matricole_path( todo_matricole.id_ruolo ) AS ruolo,
		todo_matricole.ordine,
		todo_matricole.id_account_inserimento,
		todo_matricole.id_account_aggiornamento,
 		concat_ws(
			' ',
			todo.nome,
			matricole.matricola
		) AS __label__
	FROM todo_matricole
		LEFT JOIN todo ON todo.id = todo_matricole.id_todo
		LEFT JOIN matricole ON matricole.id = todo_matricole.id_matricola
;

--| 202208310300
CREATE TABLE IF NOT EXISTS `conversazioni` (
  `id` int(11) NOT NULL,
  `nome` char(64) DEFAULT NULL,
  `note` text,
  `timestamp_apertura` int(11) DEFAULT NULL,
  `timestamp_chiusura` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202208310310
ALTER TABLE `conversazioni`
	ADD PRIMARY KEY (`id`),
	ADD KEY `nome` (`nome`),
	ADD KEY `timestamp_apertura` (`timestamp_apertura`),
	ADD KEY `timestamp_chiusura` (`timestamp_chiusura`),
	ADD KEY `indice` (`id`,`nome`,`timestamp_chiusura`,`timestamp_apertura`);

--| 202208310320
ALTER TABLE `conversazioni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202208310330
CREATE OR REPLACE VIEW conversazioni_view AS
	SELECT
		conversazioni.id,
		conversazioni.nome,
		conversazioni.timestamp_apertura,
		conversazioni.timestamp_chiusura,
		conversazioni.nome AS __label__
	FROM
		conversazioni
;

--| 202208310340
CREATE TABLE IF NOT EXISTS `conversazioni_account` (
  `id` int(11) NOT NULL,
  `id_conversazione` int(11) NOT NULL,
  `id_account` int(11) DEFAULT NULL,
  `timestamp_entrata` int(11) DEFAULT NULL,
  `timestamp_uscita` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202208310350
ALTER TABLE `conversazioni_account`
 	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_conversazione`,`id_account`),
	ADD KEY `id_conversazione` (`id_conversazione`),
	ADD KEY `id_account` (`id_account`),
 	ADD KEY `timestamp_entrata` (`timestamp_entrata`), 
 	ADD KEY `timestamp_uscita` (`timestamp_uscita`), 
	ADD KEY `indice` (`id`,`id_conversazione`,`id_account`,`timestamp_entrata`, `timestamp_uscita`);

--| 202208310360
ALTER TABLE `conversazioni_account` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202208310370
ALTER TABLE `conversazioni_account`
    ADD CONSTRAINT `conversazioni_account_ibfk_01_nofollow`    FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `conversazioni_account_ibfk_02_nofollow`    FOREIGN KEY (`id_conversazione`) REFERENCES `conversazioni` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202208310380
CREATE OR REPLACE VIEW conversazioni_account_view AS
	SELECT
		conversazioni_account.id,
		conversazioni_account.id_conversazione,
		conversazioni_account.id_account,
		conversazioni_account.timestamp_entrata,
		conversazioni_account.timestamp_uscita,
		concat( conversazioni_account.id_conversazione, ' - ', conversazioni_account.id_account) AS __label__
	FROM
		conversazioni_account
;

--| 202208310390
CREATE TABLE IF NOT EXISTS `messaggi` (
  `id` int(11) NOT NULL,
  `id_conversazione` int(11) DEFAULT NULL,
  `testo` text,
  `timestamp_invio` int DEFAULT NULL,
  `timestamp_lettura` int DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB;

--| 202208310400
ALTER TABLE `messaggi`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_conversazione` (`id_conversazione`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_conversazione`,`timestamp_invio`,`timestamp_lettura`);

--| 202208310410
ALTER TABLE `messaggi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202208310420
ALTER TABLE `messaggi` 
  ADD CONSTRAINT `messaggi_ibfk_01_nofollow` FOREIGN KEY (`id_conversazione`) REFERENCES `conversazioni` (`id`),
  ADD CONSTRAINT `messaggi_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  ADD CONSTRAINT `messaggi_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202208310430
CREATE OR REPLACE VIEW `messaggi_view` AS
	SELECT
		messaggi.id,
		messaggi.id_conversazione,
		messaggi.timestamp_invio,
		messaggi.timestamp_lettura,
		messaggi.id_account_inserimento,
		messaggi.id_account_aggiornamento,
		concat( 'messaggio #', messaggi.id )AS __label__
	FROM messaggi
;

--| 202208310440
ALTER TABLE  immagini
  CHANGE `nome` `nome` char(255) DEFAULT NULL;
  
-- FINE