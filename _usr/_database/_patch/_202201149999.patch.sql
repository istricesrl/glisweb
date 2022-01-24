--
-- PATCH
--

--| 202201140005
CREATE TABLE IF NOT EXISTS `condizioni_pagamento` (
`id` int(11) NOT NULL,
  `codice` char(5) NOT NULL,
  `nome` char(128) DEFAULT NULL,
  `note` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202201140010
ALTER TABLE `condizioni_pagamento`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `codice` (`codice`),
	ADD KEY `nome` (`nome`),
	ADD UNIQUE KEY `unico` (`codice`,`nome`);

--| 202201140015
ALTER TABLE `condizioni_pagamento` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202201140020
REPLACE INTO `condizioni_pagamento` (`id`, `codice`, `nome`) VALUES
(1,	    'TP01',	'pagamento a rate'),
(2,	    'TP02',	'pagamento completo'),
(3,	    'TP03',	    'anticipo');

--| 202201140030
CREATE OR REPLACE VIEW condizioni_pagamento_view AS
	SELECT
		condizioni_pagamento.id,
		condizioni_pagamento.codice,
		condizioni_pagamento.nome,
		condizioni_pagamento.note,
		concat( condizioni_pagamento.codice, ' - ', condizioni_pagamento.nome) AS __label__
	FROM
		condizioni_pagamento
;

--| 202201140040
CREATE OR REPLACE VIEW `proforma_view` AS
    SELECT
		documenti.id,
		documenti.id_tipologia,
		tipologie_documenti.nome AS tipologia,
		documenti.numero,
		documenti.data,
		documenti.nome,
		documenti.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		documenti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		documenti.id_account_inserimento,
		documenti.id_account_aggiornamento,
		concat(
			documenti.numero,
			'/',
			year( documenti.data ),
			' del ',
			documenti.data,
			' per ',
			coalesce(
				a2.denominazione,
				concat(
					a2.cognome,
					' ',
					a2.nome
				),
				''
			)
		) AS __label__
    FROM
		documenti
		LEFT JOIN anagrafica AS a1 ON a1.id = documenti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = documenti.id_destinatario
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
   WHERE documenti.id_tipologia = 5
;


--| 202201140045
ALTER TABLE `documenti`
ADD `id_condizione_pagamento` int NULL AFTER `id_sede_destinatario`, ADD KEY `id_condizione_pagamento` (`id_condizione_pagamento`);

--| 202201140050
ALTER TABLE `documenti`
    ADD CONSTRAINT `documenti_ibfk_07_nofollow` FOREIGN KEY (`id_condizione_pagamento`) REFERENCES `condizioni_pagamento` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--| 202201140060
CREATE OR REPLACE VIEW `documenti_view` AS
    SELECT
		documenti.id,
		documenti.id_tipologia,
		tipologie_documenti.nome AS tipologia,
		documenti.numero,
		documenti.sezionale,
		documenti.codice_sdi,
		documenti.codice_archivium,
		documenti.progressivo_invio,
		documenti.data,
		documenti.nome,
		documenti.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		documenti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		documenti.id_condizione_pagamento,
		condizioni_pagamento.codice AS condizioni_pagamento,
    	documenti.timestamp_invio,
		documenti.id_coupon,
		documenti.id_account_inserimento,
		documenti.id_account_aggiornamento,
		concat(
			tipologie_documenti.nome,
			' ',
			documenti.numero,
			'/',
			year( documenti.data ),
			' del ',
			documenti.data,
			' per ',
			coalesce(
				a2.denominazione,
				concat(
					a2.cognome,
					' ',
					a2.nome
				),
				''
			)
		) AS __label__
    FROM
		documenti
		LEFT JOIN anagrafica AS a1 ON a1.id = documenti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = documenti.id_destinatario
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
		LEFT JOIN condizioni_pagamento ON condizioni_pagamento.id = documenti.id_condizione_pagamento
;

--| 202201140070
CREATE OR REPLACE VIEW `fatture_view` AS
        SELECT
		documenti.id,
		documenti.id_tipologia,
		tipologie_documenti.nome AS tipologia,
		documenti.numero,
		documenti.sezionale,
		documenti.codice_sdi,
		documenti.codice_archivium,
		documenti.progressivo_invio,
		documenti.data,
		documenti.nome,
		documenti.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		documenti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		documenti.id_condizione_pagamento,
		condizioni_pagamento.codice AS condizioni_pagamento,
    	documenti.timestamp_invio,
		documenti.id_coupon,
		documenti.id_account_inserimento,
		documenti.id_account_aggiornamento,
		concat(
			tipologie_documenti.nome,
			' ',
			documenti.numero,
			'/',
			year( documenti.data ),
			' del ',
			documenti.data,
			' per ',
			coalesce(
				a2.denominazione,
				concat(
					a2.cognome,
					' ',
					a2.nome
				),
				''
			)
		) AS __label__
    FROM
		documenti
		LEFT JOIN anagrafica AS a1 ON a1.id = documenti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = documenti.id_destinatario
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
		LEFT JOIN condizioni_pagamento ON condizioni_pagamento.id = documenti.id_condizione_pagamento
   WHERE documenti.id_tipologia = 1
;

--| 202201140080
CREATE OR REPLACE VIEW `pagamenti_view` AS
	SELECT
		pagamenti.id,
		pagamenti.id_tipologia,
		tipologie_pagamenti.nome AS tipologia,
		pagamenti.ordine,
		pagamenti.nome,
		pagamenti.note,
		pagamenti.note_pagamento,
		pagamenti.id_documento,
		pagamenti.id_mastro_provenienza,
		m1.nome AS mastro_provenienza,
		pagamenti.id_mastro_destinazione,
		m2.nome AS mastro_destinazione,
		pagamenti.id_iban,
		pagamenti.importo_netto_totale,
		pagamenti.id_iva,
		iva.nome AS iva,
		pagamenti.id_listino,
		listini.nome AS listino,
		pagamenti.timestamp_pagamento,
		pagamenti.id_account_inserimento,
		pagamenti.id_account_aggiornamento,
		concat(
			'documento ',
			documenti.numero,
			'/',
			year( documenti.data ),
			' del ',
			documenti.data) AS documento,
		pagamenti.nome AS __label__
	FROM pagamenti
		LEFT JOIN tipologie_pagamenti ON tipologie_pagamenti.id = pagamenti.id_tipologia
		LEFT JOIN mastri AS m1 ON m1.id = pagamenti.id_mastro_provenienza
		LEFT JOIN mastri AS m2 ON m2.id = pagamenti.id_mastro_destinazione
		LEFT JOIN iva ON iva.id = pagamenti.id_iva
		LEFT JOIN listini ON listini.id = pagamenti.id_listino
		LEFT JOIN documenti ON documenti.id = pagamenti.id_documento
;

--| 202201140090
CREATE TABLE IF NOT EXISTS `modalita_pagamento` (
`id` int(11) NOT NULL,
  `nome` char(255) NOT NULL,
  `provider` char(64) DEFAULT NULL,
  `codice` char(8) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202201140100
ALTER TABLE `modalita_pagamento`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `nome` (`nome`,`codice`),
	ADD KEY `indice` (`id`,`nome`,`provider`,`codice`);

--| 202201140110
ALTER TABLE `modalita_pagamento` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202201140120
REPLACE INTO `modalita_pagamento` (`id`, `codice`, `nome`) VALUES
(1,	    'MP01',	'contanti'),
(2,	    'MP02',	'assegno'),
(3,	    'MP03',	    'assegno circolare'),
(4,	    'MP04',	    'contanti presso tesoreria'),
(5,	    'MP05',	'bonifico'),
(6,	    'MP06',	'vaglia cambiario'),
(7,	    'MP07',	'bollettino bancario'),
(8,	    'MP08',	'carta di credito'),
(9,	    'MP09',	'RID'),
(10,	    'MP10',	'RID utenze'),
(11,	    'MP11',	'RID veloce'),
(12,	    'MP12',	'RIBA'),
(13,	    'MP13',	'MAV'),
(14,	    'MP14',	'quietanza erario stato'),
(15,	    'MP15',	'giroconto su conti di contabilità speciale'),
(16,	    'MP16',	'domiciliazione bancaria'),
(17,	    'MP17',	'domiciliazione postale'),
(18,	    'MP18', 'bollettino di c/c postale'),
(19, 'MP19', 'SEPA Direct Debit' ),
(20, 'MP20', 'SEPA Direct Debit CORE' ),
(21, 'MP21', 'SEPA Direct Debit B2B' ),
(22, 'MP22', 'Trattenuta su somme già riscosse' ),
(23,  'MP08', 'bancomat' ),
(24, 'MP08', 'paypal' )
;

--| 202201140130
CREATE OR REPLACE VIEW `modalita_pagamento_view` AS
	SELECT
	modalita_pagamento.id,
	modalita_pagamento.nome,
	modalita_pagamento.codice,
	modalita_pagamento.provider,
	concat( modalita_pagamento.codice,' - ', modalita_pagamento.nome) AS __label__
	FROM modalita_pagamento
	ORDER BY __label__
;

--| 202201140140
ALTER TABLE `pagamenti`
ADD `id_modalita_pagamento` int NULL AFTER `id_tipologia`,
ADD KEY `id_modalita_pagamento` (`id_modalita_pagamento`),
ADD CONSTRAINT `pagamenti_ibfk_08_nofollow` FOREIGN KEY (`id_modalita_pagamento`) REFERENCES `modalita_pagamento` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--| FINE FILE
