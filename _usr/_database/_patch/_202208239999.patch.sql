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
		consensi.nome AS __label__
	FROM consensi
;

--| 202208230100
REPLACE INTO `consensi` (`id`, `nome`, `note`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
('PRIVACY_POLICY',	'la privacy e cookie policy del sito',	NULL,	NULL,	NULL,	NULL,	NULL),
('EVASIONE_ORDINE',	"evasione dell\'ordine",	NULL,	NULL,	NULL,	NULL,	NULL),
('INVIO_COMUNICAZIONI_MARKETING',	'invio di comunicazioni commerciali',	NULL,	NULL,	NULL,	NULL,	NULL);

--| FINE