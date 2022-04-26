--
-- PATCH
--

--| 202204220010
CREATE TABLE IF NOT EXISTS `causali` (
  `id` int(11) NOT NULL,
  `nome` char(64) NOT NULL,
  `se_trasporto` int(1) DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202204220020
ALTER TABLE `causali`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `nome` (`nome`),
	ADD KEY `se_trasporto` (`se_trasporto`), 
	ADD UNIQUE KEY `unica` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
 	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`nome`,`se_trasporto`);

--| 202204220030
ALTER TABLE `causali` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202204220035
ALTER TABLE `causali`
    ADD CONSTRAINT `causali_ibfk_98_nofollow`  FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `causali_ibfk_99_nofollow`  FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202204220040
ALTER TABLE documenti 
ADD COLUMN `id_causale` int(11) DEFAULT NULL  AFTER `id_mastro_destinazione`,
ADD COLUMN `id_trasportatore` int(11) DEFAULT NULL  AFTER `id_causale`,
ADD COLUMN   `porto` enum('franco','assegnato','-') DEFAULT NULL AFTER `id_trasportatore`,
ADD KEY `id_causale` (`id_causale`),
ADD KEY `id_trasportatore` (`id_trasportatore`),
ADD KEY `porto` (`porto`),
ADD CONSTRAINT `documenti_ibfk_10_nofollow` FOREIGN KEY (`id_causale`) REFERENCES `causali` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `documenti_ibfk_11_nofollow` FOREIGN KEY (`id_trasportatore`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--| 202204220050
CREATE TABLE `colli` (
  `id` int(11) NOT NULL,
  `id_documento` int(11) DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `larghezza` decimal(7,2) DEFAULT NULL,
  `lunghezza` decimal(7,2) DEFAULT NULL,
  `altezza` decimal(7,2) DEFAULT NULL,
  `id_udm_dimensioni` int DEFAULT NULL,
  `peso` decimal(7,2) DEFAULT NULL,
  `id_udm_peso` int DEFAULT NULL,
  `volume` decimal(7,2) DEFAULT NULL,
  `id_udm_volume` int DEFAULT NULL,
  `nome` char(128) DEFAULT NULL,
  `note` text,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL
) ENGINE=InnoDB;

--| 202204220060
ALTER TABLE `colli`
 	ADD PRIMARY KEY (`id`), 
 	ADD KEY `id_documento` (`id_documento`), 
	ADD KEY `id_udm_dimensioni` (`id_udm_dimensioni`),
	ADD KEY `id_udm_peso` (`id_udm_peso`),
	ADD KEY `id_udm_volume` (`id_udm_volume`),
 	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
 	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`ordine`,`codice`,`id_documento`),
	ADD KEY `indice_dimensioni` (`id`,`ordine`,`codice`,`id_documento`,`larghezza`,`lunghezza`,`altezza`,`peso`,`volume`);

--| 202204220070
ALTER TABLE `colli` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202204220080
ALTER TABLE `colli`
    ADD CONSTRAINT `colli_ibfk_01_nofollow` FOREIGN KEY (`id_documento`) REFERENCES `documenti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `colli_ibfk_02_nofollow` FOREIGN KEY (`id_udm_dimensioni`) REFERENCES `udm` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `colli_ibfk_03_nofollow` FOREIGN KEY (`id_udm_peso`) REFERENCES `udm` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `colli_ibfk_04_nofollow` FOREIGN KEY (`id_udm_volume`) REFERENCES `udm` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
	ADD CONSTRAINT `colli_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `colli_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;


--| 202204220090
ALTER TABLE documenti_articoli 
ADD COLUMN `id_collo` int(11) DEFAULT NULL  AFTER `id_matricola`,
ADD KEY `id_collo` (`id_collo`),
ADD CONSTRAINT `documenti_articoli_ibfk_16_nofollow`    FOREIGN KEY (`id_collo`) REFERENCES `colli` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--| 202204220100
ALTER TABLE categorie_anagrafica 
ADD COLUMN `se_corriere` int(1) DEFAULT NULL  AFTER se_notizie,
ADD KEY `se_corriere` (`se_corriere`);

--| 202204220110
INSERT INTO `categorie_anagrafica` (`id_genitore`, `ordine`, `nome`, `note`, `se_lead`, `se_prospect`, `se_cliente`, `se_fornitore`, `se_produttore`, `se_collaboratore`, `se_interno`, `se_esterno`, `se_concorrente`, `se_gestita`, `se_amministrazione`, `se_produzione`, `se_commerciale`, `se_notizie`, `se_corriere`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`)
VALUES (NULL, NULL, 'corriere', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, NULL);

--| 202204220120
ALTER TABLE ranking DROP KEY indice;

--| 202204220130
ALTER TABLE ranking 
ADD COLUMN `se_cliente` int(1) DEFAULT NULL  AFTER ordine,
ADD KEY `se_cliente` (`se_cliente`),
ADD COLUMN `se_fornitore` int(1) DEFAULT NULL  AFTER se_cliente,
ADD KEY `se_fornitore` (`se_fornitore`),
ADD KEY `indice` (`id`,`nome`,`ordine`,  `se_cliente`, `se_fornitore`);

--| 202204220140
CREATE OR REPLACE VIEW `documenti_view` AS
    SELECT
		documenti.id,
		documenti.id_tipologia,
		tipologie_documenti.nome AS tipologia,
		documenti.numero,
		documenti.sezionale,
		documenti.data,
		documenti.nome,
		documenti.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		documenti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		documenti.id_condizione_pagamento,
		condizioni_pagamento.codice AS condizione_pagamento,
		documenti.esigibilita, 
		documenti.codice_archivium,
    	documenti.codice_sdi,
		documenti.cig,
		documenti.cup,
		documenti.riferimento,
    	documenti.timestamp_invio,
    	documenti.progressivo_invio,
		documenti.id_coupon,
		documenti.id_mastro_provenienza,
		m1.nome AS mastro_provenienza,
		documenti.id_mastro_destinazione,
		m2.nome AS mastro_destinazione,
		documenti.id_causale,
		documenti.porto,
		documenti.id_trasportatore,
		documenti.timestamp_chiusura,
		from_unixtime( documenti.timestamp_chiusura, '%Y-%m-%d %H:%i' ) AS data_ora_chiusura,
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
		LEFT JOIN mastri AS m1 ON m1.id = documenti.id_mastro_provenienza
		LEFT JOIN mastri AS m2 ON m2.id = documenti.id_mastro_destinazione
;

--| 202204220150
CREATE OR REPLACE VIEW `ddt_view` AS
    SELECT
		documenti.id,
		documenti.id_tipologia,
		tipologie_documenti.nome AS tipologia,
		documenti.numero,
		documenti.sezionale,
		documenti.data,
		documenti.nome,
		documenti.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		documenti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		documenti.id_mastro_provenienza,
		m1.nome AS mastro_provenienza,
		documenti.id_mastro_destinazione,
		m2.nome AS mastro_destinazione,
		documenti.id_causale,
		documenti.porto,
		documenti.id_trasportatore,
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
    FROM documenti
		LEFT JOIN anagrafica AS a1 ON a1.id = documenti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = documenti.id_destinatario
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
		LEFT JOIN mastri AS m1 ON m1.id = documenti.id_mastro_provenienza
		LEFT JOIN mastri AS m2 ON m2.id = documenti.id_mastro_destinazione
   	WHERE tipologie_documenti.se_trasporto IS NOT NULL
;

--| 202204220160
CREATE OR REPLACE VIEW `ddt_attivi_view` AS
    SELECT
		documenti.id,
		documenti.id_tipologia,
		tipologie_documenti.nome AS tipologia,
		documenti.numero,
		documenti.sezionale,
		documenti.data,
		documenti.nome,
		documenti.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		documenti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		documenti.id_mastro_provenienza,
		m1.nome AS mastro_provenienza,
		documenti.id_mastro_destinazione,
		m2.nome AS mastro_destinazione,
		documenti.id_causale,
		documenti.porto,
		documenti.id_trasportatore,
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
    FROM documenti
		LEFT JOIN anagrafica AS a1 ON a1.id = documenti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = documenti.id_destinatario
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
		LEFT JOIN mastri AS m1 ON m1.id = documenti.id_mastro_provenienza
		LEFT JOIN mastri AS m2 ON m2.id = documenti.id_mastro_destinazione
   	WHERE tipologie_documenti.se_trasporto IS NOT NULL
	   AND anagrafica_check_gestita( a1.id ) IS NOT NULL
;

--| 202204220170
CREATE OR REPLACE VIEW `ddt_passivi_view` AS
    SELECT
		documenti.id,
		documenti.id_tipologia,
		tipologie_documenti.nome AS tipologia,
		documenti.numero,
		documenti.sezionale,
		documenti.data,
		documenti.nome,
		documenti.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		documenti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		documenti.id_mastro_provenienza,
		m1.nome AS mastro_provenienza,
		documenti.id_mastro_destinazione,
		m2.nome AS mastro_destinazione,
		documenti.id_causale,
		documenti.porto,
		documenti.id_trasportatore,
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
    FROM documenti
		LEFT JOIN anagrafica AS a1 ON a1.id = documenti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = documenti.id_destinatario
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
		LEFT JOIN mastri AS m1 ON m1.id = documenti.id_mastro_provenienza
		LEFT JOIN mastri AS m2 ON m2.id = documenti.id_mastro_destinazione
   	WHERE tipologie_documenti.se_trasporto IS NOT NULL
	   AND anagrafica_check_gestita( a2.id ) IS NOT NULL
;

--| 202204220180
CREATE OR REPLACE VIEW `documenti_articoli_view` AS
    SELECT
		documenti_articoli.id,
		documenti_articoli.id_genitore,
		documenti_articoli.id_tipologia,
		tipologie_documenti.nome AS tipologia,
		documenti_articoli.ordine,
		documenti_articoli.id_documento,
        concat(
			tipologie_documenti.nome,
			' ',
			documenti.numero,
			'/',
			year( documenti.data ),
			' del ',
			documenti.data
		) AS documento,
		documenti_articoli.data,
		documenti_articoli.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		documenti_articoli.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		documenti_articoli.id_reparto,
		documenti_articoli.id_progetto,
		documenti_articoli.id_todo,
		documenti_articoli.id_attivita,
		documenti_articoli.id_articolo,
		concat_ws( ' ', prodotti.nome, articoli.nome ) AS articolo,
		documenti_articoli.id_mastro_provenienza,
		mastri_path( m1.id ) AS mastro_provenienza,
		documenti_articoli.id_mastro_destinazione,
		mastri_path( m2.id ) AS mastro_destinazione,
		documenti_articoli.id_udm,
		documenti_articoli.quantita,
		documenti_articoli.id_listino,
		listini.id_valuta,
		valute.utf8 AS valuta,
		documenti_articoli.importo_netto_totale,
		documenti_articoli.sconto_percentuale,
		documenti_articoli.sconto_valore,
		documenti_articoli.id_matricola,
		concat( 'MAT.',lpad(matricole.id, 15, '0') ) AS matricola,
		documenti_articoli.id_collo,
		matricole.data_scadenza,
		documenti_articoli.nome,
		documenti_articoli.id_account_inserimento,
		documenti_articoli.id_account_aggiornamento,
		concat(
			documenti_articoli.data,
			' / ',
			tipologie_documenti.nome,
			' / ',
			documenti_articoli.quantita,
			' x ',
			documenti_articoli.id_articolo,
			' / ',
			documenti_articoli.nome,
			' / ',
			documenti_articoli.importo_netto_totale,
			' ',
			valute.utf8
		) AS __label__
	FROM
		documenti_articoli
        LEFT JOIN documenti ON documenti.id = documenti_articoli.id_documento
		LEFT JOIN anagrafica AS a1 ON a1.id = documenti_articoli.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = documenti_articoli.id_destinatario
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti_articoli.id_tipologia
		LEFT JOIN listini ON listini.id = documenti_articoli.id_listino
		LEFT JOIN valute ON valute.id = listini.id_valuta
		LEFT JOIN mastri AS m1 ON m1.id = documenti_articoli.id_mastro_provenienza
		LEFT JOIN mastri AS m2 ON m2.id = documenti_articoli.id_mastro_destinazione
		LEFT JOIN matricole ON matricole.id = documenti_articoli.id_matricola
		LEFT JOIN articoli ON articoli.id = documenti_articoli.id_articolo
		LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
;

--| 202204220190
CREATE OR REPLACE VIEW categorie_anagrafica_view AS
	SELECT
		categorie_anagrafica.id,
		categorie_anagrafica.id_genitore,
		categorie_anagrafica.ordine,
		categorie_anagrafica.nome,
		categorie_anagrafica.se_prospect,
		categorie_anagrafica.se_lead,
		categorie_anagrafica.se_cliente,
		categorie_anagrafica.se_fornitore,
		categorie_anagrafica.se_produttore,
		categorie_anagrafica.se_collaboratore,
		categorie_anagrafica.se_interno,
		categorie_anagrafica.se_esterno,
		categorie_anagrafica.se_concorrente,
		categorie_anagrafica.se_gestita,
		categorie_anagrafica.se_amministrazione,
		categorie_anagrafica.se_produzione,
		categorie_anagrafica.se_commerciale,
		categorie_anagrafica.se_notizie,
		categorie_anagrafica.se_corriere,
		count( c1.id ) AS figli,
		count( anagrafica_categorie.id ) AS membri,
		categorie_anagrafica.id_account_inserimento,
		categorie_anagrafica.id_account_aggiornamento,
	 	categorie_anagrafica_path( categorie_anagrafica.id ) AS __label__
	FROM categorie_anagrafica
		LEFT JOIN categorie_anagrafica AS c1 ON c1.id_genitore = categorie_anagrafica.id
		LEFT JOIN anagrafica_categorie ON anagrafica_categorie.id_categoria = categorie_anagrafica.id
	GROUP BY categorie_anagrafica.id
;

--| 202204220200
CREATE OR REPLACE VIEW `ranking_view` AS
    SELECT
		ranking.id,
		ranking.nome,
		ranking.ordine,
		ranking.se_cliente,
		ranking.se_fornitore,
		ranking.id_account_inserimento,
		ranking.id_account_aggiornamento,
		ranking.nome AS __label__
    FROM ranking
;

--| 202204220210
CREATE OR REPLACE VIEW colli_view AS
	SELECT
		colli.id,
		colli.id_documento,
		colli.ordine,
		colli.codice,
		colli.larghezza,
		colli.lunghezza,
		colli.altezza,
		colli.id_udm_dimensioni,
		colli.peso,
		colli.id_udm_peso,
		colli.volume,
		colli.id_udm_volume,
		colli.nome,
		colli.id_account_inserimento,
		colli.id_account_aggiornamento,
		colli.nome AS __label__
	FROM colli
	;

--| 202204220220
CREATE OR REPLACE VIEW causali_view AS
	SELECT
		causali.id,
		causali.nome,
		causali.se_trasporto,
		causali.id_account_inserimento,
		causali.id_account_aggiornamento,
	 	causali.nome AS __label__
	FROM causali
;

-- FINE