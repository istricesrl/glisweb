--
-- PATCH
--

--| 202202030005
CREATE TABLE `certificazioni` (
  `id` int NOT NULL,
  `nome` char(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL
) ENGINE=InnoDB;

--| 202202030010
ALTER TABLE `anagrafica`
ADD `codice_archivium` char(16) DEFAULT NULL COLLATE 'utf8_general_ci' NULL AFTER `id_pec_sdi`,
ADD KEY `codice_archivium` (`codice_archivium`);

--| 202202030020
CREATE OR REPLACE VIEW `__report_giacenza_magazzini__` AS
SELECT
  id,
  nome,
  id_articolo,
  articolo,
  id_matricola,
  matricola,
  sum( carico ) AS carico,
  sum( scarico ) AS scarico,
  coalesce( ( sum( carico ) - sum( scarico ) ), 0 ) AS totale
FROM (
SELECT
  mastri.id,
  mastri.nome,
  articoli.id AS id_articolo,
  articoli.nome AS articolo,
  matricole.id AS id_matricola,
  matricole.matricola,
  documenti.data,
  documenti.id_tipologia,
  tipologie_documenti.nome AS tipologia,
  concat( documenti.numero, '/', documenti.sezionale ) AS numero,
  documenti_articoli.id AS id_riga,
  coalesce( documenti_articoli.quantita, 0 ) AS carico,
  0 AS scarico
FROM mastri
  LEFT JOIN documenti_articoli
    ON documenti_articoli.id_mastro_destinazione = mastri.id
      OR mastri_path_check( documenti_articoli.id_mastro_destinazione, mastri.id ) = 1
  LEFT JOIN articoli ON articoli.id = documenti_articoli.id_articolo
  LEFT JOIN documenti ON documenti.id = documenti_articoli.id_documento
  LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
  LEFT JOIN matricole ON matricole.id = documenti_articoli.id_matricola
UNION
SELECT
  mastri.id,
  mastri.nome,
  articoli.id AS id_articolo,
  articoli.nome AS articolo,
  matricole.id AS id_matricola,
  matricole.matricola,
  documenti.data,
  documenti.id_tipologia,
  tipologie_documenti.nome AS tipologia,
  concat( documenti.numero, '/', documenti.sezionale ) AS numero,
  documenti_articoli.id AS id_riga,
  0 AS carico,
  coalesce( documenti_articoli.quantita, 0 ) AS scarico
FROM mastri
  LEFT JOIN documenti_articoli
    ON documenti_articoli.id_mastro_provenienza = mastri.id
      OR mastri_path_check( documenti_articoli.id_mastro_provenienza, mastri.id ) = 1
  LEFT JOIN articoli ON articoli.id = documenti_articoli.id_articolo
  LEFT JOIN documenti ON documenti.id = documenti_articoli.id_documento
  LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
  LEFT JOIN matricole ON matricole.id = documenti_articoli.id_matricola
) AS movimenti
GROUP BY id, nome, id_articolo, articolo, id_matricola, matricola;

--| 202202030030
ALTER TABLE `menu` ADD `ancora` CHAR(64) NULL DEFAULT NULL AFTER `target`;

--| 202202030060
CREATE OR REPLACE VIEW `menu_view` AS
    SELECT
		menu.id,
		menu.id_lingua,
		menu.id_pagina,
		menu.id_categoria_prodotti,
		menu.id_categoria_notizie,
		menu.id_categoria_risorse,
		menu.ordine,
		menu.menu,
		menu.nome,
		menu.target,
		menu.ancora,
		menu.sottopagine,
		menu.id_account_inserimento,
		menu.id_account_aggiornamento,
		concat_ws(
			' / ',
			menu.menu,
			menu.ordine,
			lingue.ietf,
			menu.nome
		) AS __label__
    FROM menu
		INNER JOIN lingue ON lingue.id = menu.id_lingua
;

--| 202202030070
ALTER TABLE `relazioni_anagrafica` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202202030080
CREATE OR REPLACE VIEW relazioni_anagrafica_view AS
	SELECT
	relazioni_anagrafica.id_anagrafica,
	relazioni_anagrafica.id_anagrafica_collegata,
	concat( relazioni_anagrafica.id_anagrafica,' - ', relazioni_anagrafica.id_anagrafica_collegata) AS __label__
	FROM relazioni_anagrafica
	ORDER BY __label__
;

--| 202202030090
ALTER TABLE `certificazioni`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`nome`),
	ADD KEY `indice` (`id`,`nome`); 

--| 202202030100
ALTER TABLE `certificazioni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT; 

--| 202202030105
ALTER TABLE `certificazioni`
    ADD CONSTRAINT `certificazioni_ibfk_98_nofollow`  FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `certificazioni_ibfk_99_nofollow`  FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202202030110
CREATE OR REPLACE VIEW certificazioni_view AS
	SELECT
		certificazioni.id,
		certificazioni.nome,
	 	certificazioni.nome AS __label__
	FROM certificazioni
;

--| 202202030120
INSERT INTO `certificazioni` (`id`, `nome`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	"carta d\'identità",	NULL,	NULL,	NULL,	NULL),
(2,	'passaporto',	NULL,	NULL,	NULL,	NULL),
(3,	'patente di guida',	NULL,	NULL,	NULL,	NULL),
(4,	'certificato medico agonistico',	NULL,	NULL,	NULL,	NULL),
(5,	'certificato medico sportivo',	NULL,	NULL,	NULL,	NULL);

--| 202202030130
CREATE TABLE `anagrafica_certificazioni` (
  `id` int NOT NULL,
  `id_certificazione` int DEFAULT NULL,
  `id_anagrafica` int DEFAULT NULL,
  `id_emittente` int DEFAULT NULL,
  `nome` char(1) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `data_emissione` date DEFAULT NULL,
  `data_scadenza` date DEFAULT NULL,
  `note` text,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL
) ENGINE=InnoDB;

--| 202202030140
ALTER TABLE `anagrafica_certificazioni`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_certificazione` (`id_certificazione`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_emittente` (`id_emittente`), 
	ADD KEY `nome` (`nome`), 
	ADD KEY `codice` (`codice`), 
	ADD KEY `data_emissione` (`data_emissione`), 
	ADD KEY `data_scadenza` (`data_scadenza`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD UNIQUE KEY `unica` (`id_anagrafica`,`id_certificazione`, `codice`),
	ADD KEY `indice` (`id`,`id_anagrafica`,`id_certificazione`,`codice`, `id_emittente`, `nome`, `data_emissione`, `data_scadenza`);

--| 202202030150
ALTER TABLE `anagrafica_certificazioni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202202030160
ALTER TABLE `anagrafica_certificazioni`
    ADD CONSTRAINT `anagrafica_certificazioni_ibfk_01`               FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_certificazioni_ibfk_02_nofollow`      FOREIGN KEY (`id_certificazione`) REFERENCES `certificazioni` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `anagrafica_certificazioni_ibfk_03_nofollow`      FOREIGN KEY (`id_emittente`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `anagrafica_certificazioni_ibfk_98_nofollow`      FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `anagrafica_certificazioni_ibfk_99_nofollow`      FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202202030170
DROP TABLE IF EXISTS `anagrafica_certificazioni_view`;

--| 202202030180
CREATE OR REPLACE VIEW `anagrafica_certificazioni_view` AS
	SELECT
		anagrafica_certificazioni.id,
		anagrafica_certificazioni.id_certificazione,
		certificazioni.nome AS certificazione,
		anagrafica_certificazioni.id_anagrafica,
		coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ) AS anagrafica,
		anagrafica_certificazioni.id_emittente,
		coalesce( emittente.denominazione , concat( emittente.cognome, ' ', emittente.nome ), '' ) AS emittente,
		anagrafica_certificazioni.nome,
		anagrafica_certificazioni.codice,
		anagrafica_certificazioni.data_emissione,
		anagrafica_certificazioni.data_scadenza,
		concat(
			coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ),
			' / ',
			certificazioni.nome,
			' - ',
			anagrafica_certificazioni.codice
		) AS __label__
	FROM anagrafica_certificazioni
		INNER JOIN anagrafica ON anagrafica.id = anagrafica_certificazioni.id_anagrafica
		INNER JOIN anagrafica AS emittente ON emittente.id = anagrafica_certificazioni.id_emittente
		INNER JOIN certificazioni ON certificazioni.id = anagrafica_certificazioni.id_certificazione		
;

--| FINE