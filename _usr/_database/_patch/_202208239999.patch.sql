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
--| 202208230230
--| 202208230240
--| 202208230250
--| 202208230260
--| 202208230270
--| 202208230280
--| 202208230290
--| 202208230300

--| FINE