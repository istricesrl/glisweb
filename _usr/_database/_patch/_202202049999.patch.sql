--
-- PATCH
--

--| 202202040005
ALTER TABLE `macro` CHANGE `macro` `macro` CHAR(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL;

--| 202202040010
ALTER TABLE `notizie` 
ADD `id_sito` INT NULL DEFAULT NULL AFTER `note`, 
ADD `template` CHAR(255) NULL DEFAULT NULL AFTER `id_sito`, 
ADD `schema_html` CHAR(128) NULL DEFAULT NULL AFTER `template`, 
ADD `tema_css` CHAR(32) NULL DEFAULT NULL AFTER `schema_html`, 
ADD `se_sitemap` INT(1) NULL DEFAULT NULL AFTER `tema_css`, 
ADD `se_cacheable` INT(1) NULL DEFAULT NULL AFTER `se_sitemap`,
ADD KEY `id_sito` (`id_sito`),
ADD KEY `se_sitemap` (`se_sitemap`),
ADD KEY `se_cacheable` (`se_cacheable`);

--| 202202040020
ALTER TABLE `notizie` DROP INDEX `indice`;

--| 202202040030
ALTER TABLE `notizie` ADD KEY `indice` (`id`,`id_tipologia`,`nome`, `id_sito`);

--| 202202040040
INSERT INTO `ruoli_immagini` (`id`, `id_genitore`, `ordine_scalamento`, `nome`, `html_entity`, `font_awesome`, `se_anagrafica`, `se_pagine`, `se_prodotti`, `se_articoli`, `se_categorie_prodotti`, `se_notizie`, `se_categorie_notizie`, `se_risorse`, `se_categorie_risorse`) VALUES
(1, NULL, 900, 'immagine', NULL, NULL, 1, 1, 1, 1, 1, 1, 1, 1, 1),
(2, NULL, 300, 'intestazione',NULL, NULL, 1, 1, 1, 1, 1, 1, 1, 1, 1),
(3, NULL, 900, 'sfondo', NULL, NULL, 1, 1, 1, 1, 1, 1, 1, 1, 1),
(4, NULL, 600, 'gallery', NULL, NULL, 1, 1, 1, 1, 1, 1, 1, 1, 1),
(5, NULL, 600, 'jumbotron', NULL, NULL, 1, 1, 1, 1, 1, 1, 1, 1, 1),
(6, NULL, 100, 'avatar', NULL, NULL, 1, 1, 1, 1, 1, 1, 1, 1, 1),
(7, NULL, 300, 'logo', NULL, NULL, 1, 1, 1, 1, 1, 1, 1, 1, 1),
(8, NULL, 200, 'carousel', NULL, NULL, 1, 1, 1, 1, 1, 1, 1, 1, 1) ON DUPLICATE KEY UPDATE
	nome = VALUES( nome ),
	se_anagrafica = VALUES( se_anagrafica ),
	se_pagine = VALUES( se_pagine ),
	se_prodotti = VALUES( se_prodotti ),
	se_articoli = VALUES( se_articoli ),
	se_categorie_prodotti = VALUES( se_categorie_prodotti ),
	se_notizie = VALUES( se_notizie ),
	se_categorie_notizie = VALUES( se_categorie_notizie ),
	se_risorse = VALUES( se_risorse ),
	se_categorie_risorse = VALUES( se_categorie_risorse )
;

--| 202202040050
INSERT IGNORE INTO `tipologie_pubblicazioni` (`id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`, `se_bozza`, `se_pubblicato`, `se_evidenza`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(3,	NULL,	NULL,	'in evidenza',	    NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL);

--| 202202040060
ALTER TABLE `categorie_progetti` 
ADD `template` CHAR(255) NULL DEFAULT NULL AFTER `note`, 
ADD `schema_html` CHAR(128) NULL DEFAULT NULL AFTER `template`, 
ADD `tema_css` CHAR(32) NULL DEFAULT NULL AFTER `schema_html`, 
ADD `se_sitemap` INT(1) NULL DEFAULT NULL AFTER `tema_css`, 
ADD `se_cacheable` INT(1) NULL DEFAULT NULL AFTER `se_sitemap`,
ADD `id_sito` INT NULL DEFAULT NULL AFTER `se_cacheable`, 
ADD `id_pagina` INT NULL DEFAULT NULL AFTER `id_sito`, 
ADD KEY `se_sitemap` (`se_sitemap`),
ADD KEY `se_cacheable` (`se_cacheable`),
ADD KEY `id_sito` (`id_sito`),
ADD KEY `id_pagina` (`id_pagina`),
ADD CONSTRAINT `categorie_progetti_ibfk_02` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
;

--| 202202040070
ALTER TABLE `categorie_progetti` DROP INDEX `indice`;

--| 202202040080
ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`, `id_sito`);

--| 202202040090
CREATE OR REPLACE VIEW categorie_progetti_view AS
	SELECT
		categorie_progetti.id,
		categorie_progetti.id_genitore,
		categorie_progetti.ordine,
		categorie_progetti.nome,
		categorie_progetti.template,
		categorie_progetti.schema_html,
		categorie_progetti.tema_css,
		categorie_progetti.se_sitemap,
		categorie_progetti.se_cacheable,
		categorie_progetti.id_sito,
		categorie_progetti.id_pagina,
		categorie_progetti.se_straordinario,
		categorie_progetti.se_ordinario,
		count( c1.id ) AS figli,
		count( progetti_categorie.id ) AS membri,
		categorie_progetti.id_account_inserimento,
		categorie_progetti.id_account_aggiornamento,
		categorie_progetti_path( categorie_progetti.id ) AS __label__
	FROM categorie_progetti
		LEFT JOIN categorie_progetti AS c1 ON c1.id_genitore = categorie_progetti.id
		LEFT JOIN progetti_categorie ON progetti_categorie.id_categoria = categorie_progetti.id
	GROUP BY categorie_progetti.id
;

--| 202202040100
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
    	documenti.timestamp_invio,
    	documenti.progressivo_invio,
		documenti.id_coupon,
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
;

--| 202202040110
CREATE OR REPLACE VIEW `fatture_view` AS
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
    	documenti.timestamp_invio,
    	documenti.progressivo_invio,
		documenti.id_coupon,
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
   WHERE tipologie_documenti.id = 1
;

--| 202202040120
CREATE OR REPLACE VIEW `fatture_passive_view` AS
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
		documenti.esigibilita, 
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
   WHERE documenti.id_tipologia = 11
;

--| 202202040130
CREATE OR REPLACE VIEW `proforma_view` AS
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
		documenti.timestamp_chiusura,
        documenti.esigibilita, 
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
   WHERE tipologie_documenti.se_pro_forma = 1
;

--| 202202040140
ALTER TABLE `matricole` 
ADD `data_scadenza` date DEFAULT NULL AFTER `matricola`,
ADD `id_articolo` char(32) DEFAULT NULL AFTER `id_produttore`,
ADD KEY `id_articolo` (`id_articolo` )
;

--| 202202040145
ALTER TABLE `matricole`
ADD CONSTRAINT `matricole_ibfk_03_nofollow` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202202040150
CREATE OR REPLACE VIEW `matricole_view` AS
	SELECT
		matricole.id,
		matricole.id_produttore,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS produttore,
		matricole.id_marchio,
		marchi.nome AS marchio,
		matricole.id_articolo,
		concat_ws( ' ',  articoli.id, prodotti.nome, articoli.nome ) AS articolo,
		matricole.matricola,
		matricole.data_scadenza,
		matricole.nome,
		concat( 'MAT.',lpad(matricole.id, 15, '0') ) AS __label__
	FROM matricole
		LEFT JOIN anagrafica AS a1 ON a1.id = matricole.id_produttore
		LEFT JOIN marchi ON marchi.id = matricole.id_marchio
		LEFT JOIN articoli ON articoli.id = id_articolo
		LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto 
;

--| 202202041800
ALTER TABLE `ranking` 
ADD `note` text DEFAULT NULL AFTER nome;

--| 202202041801
ALTER TABLE `documenti` 
 	ADD `id_mastro_provenienza` int(11) DEFAULT NULL AFTER `id_coupon`,
 	ADD `id_mastro_destinazione` int(11) DEFAULT NULL AFTER `id_mastro_provenienza`,
 	ADD KEY `id_mastro_provenienza` (`id_mastro_provenienza`), 
	ADD KEY `id_mastro_destinazione` (`id_mastro_destinazione`), 
	ADD CONSTRAINT `documenti_ibfk_08_nofollow` FOREIGN KEY (`id_mastro_provenienza`) REFERENCES `mastri` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `documenti_ibfk_09_nofollow` FOREIGN KEY (`id_mastro_destinazione`) REFERENCES `mastri` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--| 202202041802
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
    	documenti.timestamp_invio,
    	documenti.progressivo_invio,
		documenti.id_coupon,
		documenti.id_mastro_provenienza,
		m1.nome AS mastro_provenienza,
		documenti.id_mastro_destinazione,
		m2.nome AS mastro_destinazione,
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

--| 202202041804
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
		LEFT JOIN mastri AS m1 ON m1.id = documenti.id_mastro_provenienza
		LEFT JOIN mastri AS m2 ON m2.id = documenti.id_mastro_destinazione
   WHERE documenti.id_tipologia = 4
;

--| 202202041805
ALTER TABLE `mastri` 
ADD `id_anagrafica_indirizzi` INT(11) DEFAULT NULL AFTER `id_tipologia`,
ADD KEY `id_anagrafica_indirizzi` (`id_anagrafica_indirizzi`),
ADD CONSTRAINT `mastri_ibfk_03_nofollow`    FOREIGN KEY (`id_anagrafica_indirizzi`) REFERENCES `anagrafica_indirizzi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
;

--| 202202041806
CREATE OR REPLACE VIEW `mastri_view` AS
	SELECT
		mastri.id,
		mastri.id_tipologia,
		tipologie_mastri.nome AS tipologia,
		mastri.id_anagrafica_indirizzi,
		concat_ws(
			' ',
			tipologie_indirizzi.nome,
			indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) AS indirizzo,
		mastri.nome,
		tipologie_mastri.se_magazzino,
		tipologie_mastri.se_conto,
		tipologie_mastri.se_registro,
		mastri_path( mastri.id ) AS __label__
	FROM mastri
		LEFT JOIN tipologie_mastri ON tipologie_mastri.id = mastri.id_tipologia
		LEFT JOIN anagrafica_indirizzi ON anagrafica_indirizzi.id = mastri.id_anagrafica_indirizzi
		LEFT JOIN indirizzi ON indirizzi.id = anagrafica_indirizzi.id_indirizzo
		LEFT JOIN tipologie_indirizzi ON tipologie_indirizzi.id = indirizzi.id_tipologia
		LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
;

--| 202202041807
ALTER TABLE tipologie_attivita
ADD codice char(8) default null after ordine,
ADD KEY `codice` (`codice`);

--| 202202041808
CREATE OR REPLACE VIEW `tipologie_attivita_view` AS
	SELECT
		tipologie_attivita.id,
		tipologie_attivita.id_genitore,
		tipologie_attivita.ordine,
		tipologie_attivita.codice,
		tipologie_attivita.nome,
		tipologie_attivita.html_entity,
		tipologie_attivita.font_awesome,
		tipologie_attivita.se_anagrafica,
		tipologie_attivita.se_agenda,
		tipologie_attivita.id_account_inserimento,
		tipologie_attivita.id_account_aggiornamento,
		tipologie_attivita_path( tipologie_attivita.id ) AS __label__
	FROM tipologie_attivita
;

--| 202202041809
ALTER TABLE `documenti_articoli`
CHANGE `data` `data` date NULL AFTER `id_documento`;

--| FINE