--
-- PATCH
--

--| 202208230010
ALTER TABLE `tipologie_documenti`
	ADD   `se_ecommerce` int(1) DEFAULT NULL AFTER `se_ricevuta`,
    ADD KEY `se_fattura` (`se_fattura`),
	ADD KEY `se_nota_credito` (`se_nota_credito`),
	ADD KEY `se_trasporto` (`se_trasporto`),
	ADD KEY `se_pro_forma` (`se_pro_forma`),
	ADD KEY `se_offerta` (`se_offerta`),
	ADD KEY `se_ordine` (`se_ordine`),
	ADD KEY `se_ricevuta` (`se_ricevuta`),
	ADD KEY `se_ecommerce` (`se_ecommerce`);

--| 202208230020
CREATE OR REPLACE VIEW `tipologie_documenti_view` AS
	SELECT
		tipologie_documenti.id,
		tipologie_documenti.id_genitore,
		tipologie_documenti.ordine,
		tipologie_documenti.codice,
		tipologie_documenti.numerazione,
		tipologie_documenti.nome,
		tipologie_documenti.sigla,
		tipologie_documenti.html_entity,
		tipologie_documenti.font_awesome,
		tipologie_documenti.se_fattura,
		tipologie_documenti.se_nota_credito,
		tipologie_documenti.se_trasporto,
		tipologie_documenti.se_pro_forma,
		tipologie_documenti.se_offerta,
		tipologie_documenti.se_ordine,
		tipologie_documenti.se_ricevuta,
		tipologie_documenti.se_ecommerce,
		tipologie_documenti.id_account_inserimento,
		tipologie_documenti.id_account_aggiornamento,
		tipologie_documenti_path( tipologie_documenti.id ) AS __label__
	FROM tipologie_documenti
;

--| 202208230030
INSERT INTO `tipologie_documenti` (`id`, `id_genitore`, `ordine`, `codice`, `numerazione`, `nome`, `sigla`, `html_entity`, `font_awesome`, `se_fattura`, `se_nota_credito`, `se_trasporto`, `se_pro_forma`, `se_offerta`, `se_ordine`, `se_ricevuta`, `se_ecommerce`, `stampa_xml`, `stampa_pdf`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'TD01',	'F',	'fattura',	'fatt.',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	'TD01',	'F',	'fattura accompagnatoria',	'fatt. acc.',	NULL,	NULL,	1,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	NULL,	NULL,	'TD04',	'F',	'nota di credito',	'n. di credito',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(4,	NULL,	NULL,	NULL,	'T',	'documento di trasporto',	'DDT',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(5,	NULL,	NULL,	NULL,	'P',	'pro forma',	'profroma',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(6,	NULL,	NULL,	NULL,	'O',	'offerta',	'off.',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(7,	NULL,	NULL,	NULL,	'E',	'ordine',	'ord.',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(8,	NULL,	NULL,	NULL,	'R',	'ricevuta',	'ric.',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(9,	NULL,	NULL,	NULL,	'S',	'scontrino',	'scontr.',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(10,	NULL,	NULL,	NULL,	'G',	'documento di ritiro',	'doc. di ritiro',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(11,	NULL,	NULL,	NULL,	'H',	'documento di consegna',	'doc. di consegna',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(12,	NULL,	NULL,	NULL,	'I',	'documento di reso',	'doc. di reso',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL) 
ON DUPLICATE KEY UPDATE
	id_genitore = VALUES( id_genitore ),
	ordine = VALUES( ordine ),
	nome = VALUES(nome),
    sigla = VALUES(sigla),
	html_entity = VALUES(html_entity),
	font_awesome = VALUES(font_awesome),
	codice = VALUES( codice ),
	numerazione = VALUES(numerazione),
	se_fattura = VALUES(se_fattura),
	se_nota_credito = VALUES(se_nota_credito),
	se_trasporto = VALUES(se_trasporto),
	se_pro_forma = VALUES(se_pro_forma),
	se_offerta = VALUES(se_offerta),
	se_ordine = VALUES(se_ordine),
	se_ricevuta= VALUES(se_ricevuta),
	se_ecommerce= VALUES(se_ecommerce);

--| 202208230040
ALTER TABLE `testate`
	CHANGE `nome` `nome`  char(128) DEFAULT NULL,
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);

--| 202208230050
CREATE TABLE IF NOT EXISTS `consensi` (
  `id` char(64) NOT NULL,
  `nome` char(255) DEFAULT NULL,
  `note` text,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202208230060
ALTER TABLE `consensi`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `nome` (`nome`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`nome`,`id_account_inserimento`,`id_account_aggiornamento`);

--| 202208230080
ALTER TABLE `consensi`
    ADD CONSTRAINT `consensi_ibfk_98_nofollow`       FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `consensi_ibfk_99_nofollow`       FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;
    
--| 202208230090
CREATE OR REPLACE VIEW `consensi_view` AS
	SELECT
		consensi.id,
		consensi.nome,
		consensi.id_account_inserimento,
		consensi.id_account_aggiornamento,
		consensi.nome AS __label__
	FROM consensi
;

--| 202208230100
REPLACE INTO `consensi` (`id`, `nome`, `note`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
('PRIVACY_POLICY',	'la privacy e cookie policy del sito',	NULL,	NULL,	NULL,	NULL,	NULL),
('EVASIONE_ORDINE',	"evasione dell\'ordine",	NULL,	NULL,	NULL,	NULL,	NULL),
('INVIO_COMUNICAZIONI_MARKETING',	'invio di comunicazioni commerciali',	NULL,	NULL,	NULL,	NULL,	NULL);

--| 202208230110
CREATE TABLE `consensi_moduli` (
  `id` int(11) NOT NULL,
  `id_lingua` int(11) DEFAULT NULL,
  `id_consenso` char(64) DEFAULT NULL,
  `modulo` char(32) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `azione` char(32) DEFAULT NULL,
  `nome` char(128) DEFAULT NULL,
  `informativa` char(128) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `pagina` char(32) DEFAULT NULL,
  `se_richiesto` int(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202208230120
ALTER TABLE `consensi_moduli`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_consenso`, `id_lingua`, `modulo`), 
	ADD KEY `id_lingua` (`id_lingua`),
	ADD KEY `id_consenso` (`id_consenso`),
	ADD KEY `modulo` (`modulo`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `azione` (`azione`),
	ADD KEY `nome` (`nome`),
	ADD KEY `informativa` (`informativa`),
	ADD KEY `pagina` (`pagina`),
	ADD KEY `se_richiesto` (`se_richiesto`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`, `id_consenso`, `id_lingua`, `modulo`,`nome`,`ordine`,`azione`, `informativa`, `pagina`, `se_richiesto` );

--| 202208230130
ALTER TABLE `consensi_moduli` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202208230140
ALTER TABLE `consensi_moduli`
    ADD CONSTRAINT `consensi_moduli_ibfk_01_nofollow`       FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `consensi_moduli_ibfk_02_nofollow`       FOREIGN KEY (`id_consenso`) REFERENCES `consensi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `consensi_moduli_ibfk_98_nofollow`       FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `consensi_moduli_ibfk_99_nofollow`       FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;
    
--| 202208230150
CREATE OR REPLACE VIEW `consensi_moduli_view` AS
	SELECT
		consensi_moduli.id,
		consensi_moduli.id_lingua,
		consensi_moduli.id_consenso,
		consensi_moduli.modulo,
		consensi_moduli.ordine,
		consensi_moduli.azione,
		consensi_moduli.nome,
		consensi_moduli.informativa,
		consensi_moduli.pagina,
		consensi_moduli.se_richiesto,
		consensi_moduli.id_account_inserimento,
		consensi_moduli.id_account_aggiornamento,
		concat( 'consenso ', consensi_moduli.id_consenso, ' per modulo ', consensi_moduli.modulo ) AS __label__
	FROM consensi_moduli
;

--| 202208230160
REPLACE INTO `consensi_moduli` (`id`, `id_lingua`, `id_consenso`, `modulo`, `ordine`, `azione`, `nome`, `informativa`, `note`, `pagina`, `se_richiesto`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	1,	'PRIVACY_POLICY',	'ecommerce',	10,	'letto_e_accetto',	'la privacy e cookie policy del sito',	NULL,	NULL,	'privacy',	1,	NULL,	NULL,	NULL,	NULL),
(2,	1,	'EVASIONE_ORDINE',	'ecommerce',	20,	'autorizzo',	"il trattamento dei miei dati per l\'evasione del mio ordine",	"evasione dell\'ordine",	NULL,	'',	1,	NULL,	NULL,	NULL,	NULL),
(3,	1,	'INVIO_COMUNICAZIONI_MARKETING',	'ecommerce',	30,	'autorizzo',	"il trattamento dei miei dati per l\'invio di comunicazioni commerciali",	'invio di comunicazioni commerciali',	NULL,	'',	NULL,	NULL,	NULL,	NULL,	NULL);

--| 202208230170
CREATE TABLE `anagrafica_consensi` (
  `id` int(11) NOT NULL,
  `id_account` int(11) DEFAULT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_consenso` char(64) DEFAULT NULL,
  `se_prestato` int(1) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `timestamp_consenso` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202208230180
ALTER TABLE `anagrafica_consensi`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_anagrafica`, `id_consenso`), 
	ADD KEY `id_account` (`id_account`),
	ADD KEY `id_anagrafica` (`id_anagrafica`),
	ADD KEY `id_consenso` (`id_consenso`),
	ADD KEY `se_prestato` (`se_prestato`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`, `id_account`,`id_anagrafica`, `id_consenso`, `se_prestato` );

--| 202208230190
ALTER TABLE `anagrafica_consensi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202208230200
ALTER TABLE `anagrafica_consensi`
    ADD CONSTRAINT `anagrafica_consensi_ibfk_01_nofollow`	FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `anagrafica_consensi_ibfk_02`  			FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_consensi_ibfk_03_nofollow`  FOREIGN KEY (`id_consenso`) REFERENCES `consensi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
	ADD CONSTRAINT `anagrafica_consensi_ibfk_98_nofollow`  FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `anagrafica_consensi_ibfk_99_nofollow`  FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202208230210
CREATE OR REPLACE VIEW `anagrafica_consensi_view` AS
	SELECT
		anagrafica_consensi.id,
		anagrafica_consensi.id_account,
		anagrafica_consensi.id_anagrafica,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		anagrafica_consensi.id_consenso,
		anagrafica_consensi.se_prestato,
		anagrafica_consensi.timestamp_consenso,
		anagrafica_consensi.id_account_inserimento,
		anagrafica_consensi.id_account_aggiornamento,
		concat( 'consenso per ', anagrafica_consensi.id_consenso, ' di ', coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) ) AS __label__
	FROM anagrafica_consensi
		LEFT JOIN anagrafica AS a1 ON a1.id = anagrafica_consensi.id_anagrafica
;

--| 202208230220
CREATE TABLE `carrelli_consensi` (
  `id` int(11) NOT NULL,
  `id_account` int(11) DEFAULT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_carrello` int(11) DEFAULT NULL,
  `id_consenso` char(64) DEFAULT NULL,
  `se_prestato` int(1) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `timestamp_consenso` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202208230230
ALTER TABLE `carrelli_consensi`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_carrello`, `id_consenso`), 
	ADD KEY `id_account` (`id_account`),
	ADD KEY `id_anagrafica` (`id_anagrafica`),
	ADD KEY `id_carrello` (`id_carrello`),
	ADD KEY `id_consenso` (`id_consenso`),
	ADD KEY `se_prestato` (`se_prestato`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`, `id_account`, `id_anagrafica`, `id_carrello`, `id_consenso`, `se_prestato` );

--| 202208230240
ALTER TABLE `carrelli_consensi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202208230250
ALTER TABLE `carrelli_consensi`
    ADD CONSTRAINT `carrelli_consensi_ibfk_01_nofollow`	FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `carrelli_consensi_ibfk_02_nofollow`  FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `carrelli_consensi_ibfk_03`  		FOREIGN KEY (`id_carrello`) REFERENCES `carrelli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `carrelli_consensi_ibfk_04_nofollow`  FOREIGN KEY (`id_consenso`) REFERENCES `consensi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
	ADD CONSTRAINT `carrelli_consensi_ibfk_98_nofollow`  FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `carrelli_consensi_ibfk_99_nofollow`  FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202208230260
CREATE OR REPLACE VIEW `carrelli_consensi_view` AS
	SELECT
		carrelli_consensi.id,
		carrelli_consensi.id_account,
		carrelli_consensi.id_anagrafica,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		carrelli_consensi.id_carrello,
		carrelli_consensi.id_consenso,
		carrelli_consensi.se_prestato,
		carrelli_consensi.timestamp_consenso,
		carrelli_consensi.id_account_inserimento,
		carrelli_consensi.id_account_aggiornamento,
		concat( 'consenso per ', carrelli_consensi.id_consenso, ' callerro #', carrelli_consensi.id_carrello) AS __label__
	FROM carrelli_consensi
		LEFT JOIN anagrafica AS a1 ON a1.id = carrelli_consensi.id_anagrafica;

--| 202208230270
ALTER TABLE `metadati`
DROP CONSTRAINT `metadati_ibfk_03`,
DROP CONSTRAINT `metadati_ibfk_04`,
DROP CONSTRAINT `metadati_ibfk_05`,
DROP CONSTRAINT `metadati_ibfk_06`,
DROP CONSTRAINT `metadati_ibfk_07`,
DROP CONSTRAINT `metadati_ibfk_08`,
DROP CONSTRAINT `metadati_ibfk_09`,
DROP CONSTRAINT `metadati_ibfk_10`,
DROP CONSTRAINT `metadati_ibfk_11`,
DROP CONSTRAINT `metadati_ibfk_12`,
DROP CONSTRAINT `metadati_ibfk_13`,
DROP CONSTRAINT `metadati_ibfk_14`,
DROP CONSTRAINT `metadati_ibfk_15`,
DROP CONSTRAINT `metadati_ibfk_16`,
DROP CONSTRAINT `metadati_ibfk_17`,
DROP CONSTRAINT `metadati_ibfk_18`,
DROP CONSTRAINT `metadati_ibfk_19`,
DROP CONSTRAINT `metadati_ibfk_20`,
DROP CONSTRAINT `metadati_ibfk_21`,
DROP CONSTRAINT `metadati_ibfk_22`,
DROP CONSTRAINT `metadati_ibfk_23`,
DROP CONSTRAINT `metadati_ibfk_24`,
DROP CONSTRAINT `metadati_ibfk_25`;

--| 202208230280
ALTER TABLE `metadati`
DROP FOREIGN KEY `metadati_ibfk_03`,
DROP FOREIGN KEY `metadati_ibfk_04`,
DROP FOREIGN KEY `metadati_ibfk_05`,
DROP FOREIGN KEY `metadati_ibfk_06`,
DROP FOREIGN KEY `metadati_ibfk_07`,
DROP FOREIGN KEY `metadati_ibfk_08`,
DROP FOREIGN KEY `metadati_ibfk_09`,
DROP FOREIGN KEY `metadati_ibfk_10`,
DROP FOREIGN KEY `metadati_ibfk_11`,
DROP FOREIGN KEY `metadati_ibfk_12`,
DROP FOREIGN KEY `metadati_ibfk_13`,
DROP FOREIGN KEY `metadati_ibfk_14`,
DROP FOREIGN KEY `metadati_ibfk_15`,
DROP FOREIGN KEY `metadati_ibfk_16`,
DROP FOREIGN KEY `metadati_ibfk_17`,
DROP FOREIGN KEY `metadati_ibfk_18`,
DROP FOREIGN KEY `metadati_ibfk_19`,
DROP FOREIGN KEY `metadati_ibfk_20`,
DROP FOREIGN KEY `metadati_ibfk_21`,
DROP FOREIGN KEY `metadati_ibfk_22`,
DROP FOREIGN KEY `metadati_ibfk_23`,
DROP FOREIGN KEY `metadati_ibfk_24`,
DROP FOREIGN KEY `metadati_ibfk_25`;

--| 202208230290
ALTER TABLE `metadati`
	ADD COLUMN   `id_account` int(11) DEFAULT NULL AFTER `id_anagrafica`,
	ADD KEY `id_account` (`id_account`), 
	ADD UNIQUE KEY `unica_account` (`id_lingua`,`id_account`,`nome`);
    ADD CONSTRAINT `metadati_ibfk_03`           FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `metadati_ibfk_04`           FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `metadati_ibfk_05`           FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `metadati_ibfk_06`           FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `metadati_ibfk_07`           FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `metadati_ibfk_08`           FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `metadati_ibfk_09`           FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `metadati_ibfk_10`           FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `metadati_ibfk_11`           FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `metadati_ibfk_12`           FOREIGN KEY (`id_immagine`) REFERENCES `immagini` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `metadati_ibfk_13`           FOREIGN KEY (`id_video`) REFERENCES `video` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `metadati_ibfk_14`           FOREIGN KEY (`id_audio`) REFERENCES `audio` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `metadati_ibfk_15`           FOREIGN KEY (`id_file`) REFERENCES `file` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `metadati_ibfk_16`           FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `metadati_ibfk_17`           FOREIGN KEY (`id_categoria_progetti`) REFERENCES `categorie_progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `metadati_ibfk_18`           FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `metadati_ibfk_19`           FOREIGN KEY (`id_edificio`) REFERENCES `edifici` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `metadati_ibfk_20`           FOREIGN KEY (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `metadati_ibfk_21`           FOREIGN KEY (`id_contratto`) REFERENCES `contratti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `metadati_ibfk_22`           FOREIGN KEY (`id_valutazione`) REFERENCES `valutazioni` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `metadati_ibfk_23`           FOREIGN KEY (`id_rinnovo`) REFERENCES `rinnovi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `metadati_ibfk_24`           FOREIGN KEY (`id_tipologia_attivita`) REFERENCES `tipologie_attivita` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `metadati_ibfk_25`           FOREIGN KEY (`id_banner`) REFERENCES `banner` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `metadati_ibfk_26`           FOREIGN KEY (`id_pianificazione`) REFERENCES `pianificazioni` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202208230300
CREATE OR REPLACE VIEW `metadati_view` AS
	SELECT
		metadati.id,
		metadati.id_lingua,
		lingue.ietf,
		metadati.id_anagrafica,
		metadati.id_account,
		metadati.id_pagina,
		metadati.id_prodotto,
		metadati.id_articolo,
		metadati.id_categoria_prodotti,
		metadati.id_notizia,
		metadati.id_categoria_notizie,
		metadati.id_risorsa,
		metadati.id_categoria_risorse,
		metadati.id_immagine,
		metadati.id_video,
		metadati.id_audio,
		metadati.id_file,
		metadati.id_progetto,
		metadati.id_categoria_progetti,
		metadati.id_indirizzo,
		metadati.id_edificio,
		metadati.id_immobile,
		metadati.id_contratto,
        metadati.id_valutazione,
        metadati.id_rinnovo,
        metadati.id_tipologia_attivita,
		metadati.id_banner,
		metadati.id_pianificazione,
		metadati.id_account_inserimento,
		metadati.id_account_aggiornamento,
		concat(
			metadati.nome,
			':',
			metadati.testo
		) AS __label__
	FROM metadati
		LEFT JOIN lingue ON lingue.id = metadati.id_lingua
;

--| 202208230310
CREATE OR REPLACE VIEW `__report_giacenza_crediti__` AS
SELECT
  movimenti.id,
  movimenti.id_mastro,
  movimenti.id_account,
  movimenti.nome,
  sum( movimenti.carico ) AS carico,
  sum( movimenti.scarico ) AS scarico,
  format( coalesce( ( sum( movimenti.carico ) - sum( movimenti.scarico ) ), 0 ), 2,'es_ES' ) AS totale,
  concat_ws(
      ' ',
      movimenti.nome ,
      'giacenza',
      FORMAT(coalesce( ( sum( movimenti.carico ) - sum( movimenti.scarico ) ), 0 ), 2,'es_ES'),
      'pz'
		) AS __label__
FROM (
SELECT
  mastri.id,
  mastri.id AS id_mastro,
  mastri.id_account,
  mastri_path( mastri.id ) AS nome,
  crediti.data,
  coalesce( crediti.quantita, 0 ) AS carico,
  0 AS scarico
FROM mastri
  LEFT JOIN crediti ON crediti.id_mastro_destinazione = mastri.id OR mastri_path_check( crediti.id_mastro_destinazione, mastri.id ) = 1
  WHERE crediti.quantita IS NOT NULL
UNION
SELECT
  mastri.id,
  mastri.id AS id_mastro,
  mastri.id_account,
  mastri_path( mastri.id ) AS nome,
  crediti.data,
  0 AS carico,
  coalesce( crediti.quantita, 0 ) AS scarico
FROM mastri
LEFT JOIN crediti ON crediti.id_mastro_provenienza = mastri.id OR mastri_path_check( crediti.id_mastro_provenienza, mastri.id ) = 1
  WHERE crediti.quantita IS NOT NULL
) AS movimenti
GROUP BY movimenti.id, movimenti.id_mastro, movimenti.id_account, movimenti.nome;

--| 202208230320
CREATE OR REPLACE VIEW `__report_movimenti_crediti__` AS
SELECT
  id,
  nome,
  id_account,
  data,
  id_crediti,
  carico,
  scarico
FROM (
SELECT
  mastri.id,
  mastri.nome,
  mastri.id_account,
  crediti.data,
  crediti.id AS id_crediti,
  coalesce( crediti.quantita, 0 ) AS carico,
  0 AS scarico
FROM mastri
  LEFT JOIN crediti ON crediti.id_mastro_destinazione = mastri.id OR mastri_path_check( crediti.id_mastro_destinazione, mastri.id ) = 1
  WHERE crediti.quantita IS NOT NULL
UNION
SELECT
  mastri.id,
  mastri.nome,
  mastri.id_account,
  crediti.data,
  crediti.id AS id_crediti,
  0 AS carico,
  coalesce( crediti.quantita, 0 ) AS scarico
FROM mastri
  LEFT JOIN crediti ON crediti.id_mastro_provenienza = mastri.id OR mastri_path_check( crediti.id_mastro_provenienza, mastri.id ) = 1
  WHERE crediti.quantita IS NOT NULL
) AS movimenti;

--| FINE