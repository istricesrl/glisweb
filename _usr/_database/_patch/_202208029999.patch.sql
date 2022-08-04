--
-- PATCH
--

--| 202208020010
ALTER TABLE `contratti`
DROP CONSTRAINT `contratti_ibfk_02_nofollow`;

--| 202208020020
ALTER TABLE `contratti`
DROP FOREIGN KEY  `contratti_ibfk_03_nofollow`

--| 202208020030
ALTER TABLE `contratti`
DROP KEY `id_emittente`,
DROP KEY `id_destinatario`,
DROP KEY `indice`;

--| 202208020040
ALTER TABLE `contratti` 
	DROP COLUMN `id_emittente`,
	DROP COLUMN `id_destinatario`,
	ADD KEY `indice` ( `id_tipologia`, `codice`, `nome`, `id_progetto`, `id_immobile`);

--| 202208020050
CREATE TABLE IF NOT EXISTS `risorse_account` (
  `id` int(11) NOT NULL,
  `id_risorsa` int(11) NOT NULL,
  `id_account` int(11) NOT NULL,
  `ordine` int(11) DEFAULT NULL,
  `note` text,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` int(11) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` int(11) DEFAULT NULL	
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202208020060
ALTER TABLE `risorse_account`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_risorsa`,`id_account`),
	ADD KEY `id_account` (`id_account`),
	ADD KEY `id_risorsa` (`id_risorsa`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_risorsa`,`id_account`,`ordine`);

--| 202208020070
ALTER TABLE `risorse_account` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202208020080
ALTER TABLE `risorse_account`
    ADD CONSTRAINT `risorse_account_ibfk_01`             FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `risorse_account_ibfk_02_nofollow`    FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `risorse_account_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `risorse_account_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202208020100
CREATE OR REPLACE VIEW `risorse_account_view` AS
	SELECT
		risorse_account.id,
		risorse_account.id_risorsa,
		risorse.nome AS risorsa,
		risorse_account.id_account,
		risorse_account.ordine,
		risorse_account.id_account_inserimento,
		risorse_account.id_account_aggiornamento,
		risorse.nome AS __label__
	FROM risorse_account
		LEFT JOIN risorse ON risorse.id = risorse_account.id_risorsa
;

--| 202208020120
ALTER TABLE `menu`
    ADD `id_categoria_progetti` INT(11) DEFAULT NULL AFTER `id_categoria_risorse`,
    ADD KEY `id_categoria_progetti` (`id_categoria_progetti`),
    ADD UNIQUE KEY `unica_categoria_progetti` (`id_lingua`,`id_categoria_progetti`,`menu`), 
    ADD CONSTRAINT `menu_ibfk_06`               FOREIGN KEY (`id_categoria_progetti`) REFERENCES `categorie_progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202208020130
CREATE OR REPLACE VIEW `menu_view` AS
    SELECT
		menu.id,
		menu.id_lingua,
		menu.id_pagina,
		menu.id_categoria_prodotti,
		menu.id_categoria_notizie,
		menu.id_categoria_risorse,
		menu.id_categoria_progetti,
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

--| 202208020140
ALTER TABLE `luoghi`
    ADD `url` char(255) DEFAULT NULL AFTER `id_immobile`,
    ADD KEY `url` (`url`);

--| 202208020150
CREATE OR REPLACE VIEW `luoghi_view` AS
	SELECT
		luoghi.id,
		luoghi.id_genitore,
		luoghi.id_indirizzo,
		concat_ws(
			' ',
			indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) AS indirizzo,
		luoghi.id_tipologia,
		tipologie_luoghi_path( luoghi.id_tipologia ) AS tipologia,
		luoghi.id_edificio,
		luoghi.id_immobile,	
		luoghi.url,	
		luoghi.nome,
		luoghi.id_account_inserimento,
		luoghi.id_account_aggiornamento,
		luoghi_path( luoghi.id ) AS __label__
	FROM luoghi
		LEFT JOIN indirizzi ON indirizzi.id = luoghi.id_indirizzo
		LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
;

--| 202208020160
INSERT INTO `ruoli_anagrafica` (`id`, `id_genitore`, `nome`, `html_entity`, `font_awesome`, `se_produzione`, `se_didattica`, `se_organizzazioni`, `se_relazioni`, `se_risorse`, `se_progetti`, `se_immobili`, `se_contratti`) VALUES
(1,	NULL,	'titolare',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	'amministratore',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	NULL,	'socio',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(4,	NULL,	'dipendente',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(5,	NULL,	'direttore',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(6,	NULL,	'presidente',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(7,	NULL,	'tesoriere',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(8,	NULL,	'coordinatore',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	1,	NULL,	NULL),
(9,	NULL,	'vicepresidente',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(10,	NULL,	'vicedirettore',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(11,	NULL,	'segretario',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(12,	NULL,	'responsabile amministrativo',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(13,	NULL,	'responsabile acquisti',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(14,	NULL,	'responsabile operativo',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(15,	NULL,	'operatore',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(16,	NULL,	'responsabile',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	1,	NULL,	NULL),
(17,	NULL,	'assistente',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	1,	NULL,	NULL),
(18,	NULL,	'autore',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL),
(19,	NULL,	'genitore',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(20,	NULL,	'fratello',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(21,	NULL,	'tutore',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(22,	NULL,	'coniuge',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(23,	NULL,	'collega',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(24,	NULL,	'docente',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(25,	NULL,	'istruttore',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(26,	NULL,	'proprietario',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL),
(27,	NULL,	'proponente',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1),
(28,	NULL,	'conduttore',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1),
(29,	NULL,	'iscritto',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(30,	NULL,	'istituto',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL)
ON DUPLICATE KEY UPDATE
	id_genitore = VALUES( id_genitore ),
	nome = VALUES(nome),
	html_entity = VALUES(html_entity),
	font_awesome = VALUES(font_awesome),
	se_organizzazioni = VALUES(se_organizzazioni),
	se_relazioni = VALUES(se_relazioni),
	se_risorse = VALUES(se_risorse),
	se_progetti = VALUES(se_progetti),
	se_didattica = VALUES(se_didattica),
	se_immobili = VALUES(se_immobili),
	se_contratti = VALUES(se_contratti);

--| 202208020170
CREATE OR REPLACE VIEW `abbonamenti_view` AS
	SELECT
		contratti.id,
		contratti.id_tipologia,
        tipologie_contratti.nome AS tipologia,
		group_concat( DISTINCT coalesce( istituto.denominazione , concat( istituto.cognome, ' ', istituto.nome ), '' )  SEPARATOR ', ' ) AS istituti,
		group_concat( DISTINCT coalesce( iscritto.denominazione , concat( iscritto.cognome, ' ', iscritto.nome ), '' )  SEPARATOR ', ' ) AS iscritti,
		contratti.id_progetto,
		progetti.nome AS progetto,
		contratti.codice,
		contratti.nome,
        MIN(rinnovi.data_inizio) AS data_inizio,
        MAX(rinnovi.data_fine) AS data_fine,
		contratti.id_account_inserimento,
		contratti.id_account_aggiornamento,
		concat( contratti.nome , ' - ', tipologie_contratti.nome )AS __label__
	FROM contratti
        LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
		LEFT JOIN contratti_anagrafica ON contratti_anagrafica.id_contratto = contratti.id AND contratti_anagrafica.id_ruolo = 30
		LEFT JOIN anagrafica AS istituto ON istituto.id = contratti_anagrafica.id_anagrafica 
		LEFT JOIN contratti_anagrafica AS c_a ON c_a.id_contratto = contratti.id AND c_a.id_ruolo = 29
		LEFT JOIN anagrafica AS iscritto ON iscritto.id = c_a.id_anagrafica
        LEFT JOIN progetti ON progetti.id = contratti.id_progetto
        LEFT JOIN rinnovi ON rinnovi.id_contratto = contratti.id
    WHERE tipologie_contratti.se_abbonamento = 1
    GROUP BY contratti.id, tipologie_contratti.nome
;

--| 202208020180
CREATE OR REPLACE VIEW `abbonamenti_attivi_view` AS
	SELECT
		contratti.id,
		contratti.id_tipologia,
        tipologie_contratti.nome AS tipologia,
		group_concat( DISTINCT coalesce( istituto.denominazione , concat( istituto.cognome, ' ', istituto.nome ), '' )  SEPARATOR ', ' ) AS istituti,
		group_concat( DISTINCT coalesce( iscritto.denominazione , concat( iscritto.cognome, ' ', iscritto.nome ), '' )  SEPARATOR ', ' ) AS iscritti,
		contratti.id_progetto,
		progetti.nome AS progetto,
		contratti.codice,
		contratti.nome,
        MAX(rinnovi.data_inizio) AS data_inizio,
        MAX(rinnovi.data_fine) AS data_fine,
		contratti.id_account_inserimento,
		contratti.id_account_aggiornamento,
		concat( contratti.nome , ' - ', tipologie_contratti.nome )AS __label__
	FROM contratti
        LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
		LEFT JOIN contratti_anagrafica ON contratti_anagrafica.id_contratto = contratti.id AND contratti_anagrafica.id_ruolo = 30
		LEFT JOIN anagrafica AS istituto ON istituto.id = contratti_anagrafica.id_anagrafica 
		LEFT JOIN contratti_anagrafica AS c_a ON c_a.id_contratto = contratti.id AND c_a.id_ruolo = 29
		LEFT JOIN anagrafica AS iscritto ON iscritto.id = c_a.id_anagrafica
        LEFT JOIN progetti ON progetti.id = contratti.id_progetto
        LEFT JOIN rinnovi ON rinnovi.id_contratto = contratti.id
    WHERE tipologie_contratti.se_abbonamento = 1 AND ( rinnovi.data_inizio IS NULL OR rinnovi.data_inizio <= CURRENT_DATE() ) AND (rinnovi.data_fine IS NULL OR rinnovi.data_fine >= CURRENT_DATE() )
    GROUP BY contratti.id
;

--| 202208020190
CREATE OR REPLACE VIEW `abbonamenti_archiviati_view` AS
	SELECT
		contratti.id,
		contratti.id_tipologia,
        tipologie_contratti.nome AS tipologia,
		group_concat( DISTINCT coalesce( istituto.denominazione , concat( istituto.cognome, ' ', istituto.nome ), '' )  SEPARATOR ', ' ) AS istituti,
		group_concat( DISTINCT coalesce( iscritto.denominazione , concat( iscritto.cognome, ' ', iscritto.nome ), '' )  SEPARATOR ', ' ) AS iscritti,
		contratti.id_progetto,
		progetti.nome AS progetto,
		contratti.codice,
		contratti.nome,
        MIN(rinnovi.data_inizio) AS data_inizio,
        MAX(rinnovi.data_fine) AS data_fine,
		contratti.id_account_inserimento,
		contratti.id_account_aggiornamento,
		concat( contratti.nome , ' - ', tipologie_contratti.nome )AS __label__
	FROM contratti
        LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
        LEFT JOIN contratti_anagrafica ON contratti_anagrafica.id_contratto = contratti.id AND contratti_anagrafica.id_ruolo = 30
		LEFT JOIN anagrafica AS istituto ON istituto.id = contratti_anagrafica.id_anagrafica 
		LEFT JOIN contratti_anagrafica AS c_a ON c_a.id_contratto = contratti.id AND c_a.id_ruolo = 29
		LEFT JOIN anagrafica AS iscritto ON iscritto.id = c_a.id_anagrafica
        LEFT JOIN progetti ON progetti.id = contratti.id_progetto
        LEFT JOIN rinnovi ON rinnovi.id_contratto = contratti.id
    WHERE tipologie_contratti.se_abbonamento = 1 AND ( rinnovi.data_inizio IS NULL OR rinnovi.data_inizio >= CURRENT_DATE() ) AND  rinnovi.data_fine < CURRENT_DATE() 
    GROUP BY contratti.id
;

--| 202208020200
CREATE OR REPLACE VIEW `contratti_attivi_view` AS
	SELECT
		contratti.id,
		contratti.id_tipologia,
        tipologie_contratti.nome AS tipologia,
		contratti.id_progetto,
		progetti.nome AS progetto,
		contratti.id_immobile,
		concat_ws(
			' ',
			tipologie_immobili.nome, 
			coalesce(
			concat('scala ', immobili.scala), 
			''
			), 
			coalesce(
			concat('piano ', immobili.piano), 
			''
			), 
			coalesce(
			concat('int. ', immobili.interno), 
			''
			),
			tipologie_edifici.nome,
			edifici.nome,
			tipologie_indirizzi.nome,
			indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) AS immobile,
		contratti.codice,
		contratti.nome,
		contratti.id_account_inserimento,
		contratti.id_account_aggiornamento,
        MIN(rinnovi.data_inizio) AS data_inizio,
        MAX(rinnovi.data_fine) AS data_fine,
		group_concat( DISTINCT coalesce( proponente.denominazione , concat( proponente.cognome, ' ', proponente.nome ), '' )  SEPARATOR ', ' ) AS proponenti,
		group_concat( DISTINCT coalesce( contraente.denominazione , concat( contraente.cognome, ' ', contraente.nome ), '' )  SEPARATOR ', ' ) AS contraenti,
		concat( contratti.nome , ' - ', tipologie_contratti.nome )AS __label__
	FROM contratti
        LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
        LEFT JOIN progetti ON progetti.id = contratti.id_progetto
		LEFT JOIN immobili ON immobili.id = contratti.id_immobile
		LEFT JOIN tipologie_immobili ON tipologie_immobili.id = immobili.id_tipologia
		LEFT JOIN edifici ON edifici.id = immobili.id_edificio
		LEFT JOIN tipologie_edifici ON tipologie_edifici.id = edifici.id_tipologia
		LEFT JOIN indirizzi ON indirizzi.id = edifici.id_indirizzo
		LEFT JOIN tipologie_indirizzi ON tipologie_indirizzi.id = indirizzi.id_tipologia
		LEFT JOIN zone_indirizzi ON zone_indirizzi.id_indirizzo = indirizzi.id 
		LEFT JOIN zone ON zone.id = zone_indirizzi.id_zona
		LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
		LEFT JOIN contratti_anagrafica ON contratti_anagrafica.id_contratto = contratti.id AND contratti_anagrafica.id_ruolo = 27
		LEFT JOIN anagrafica AS proponente ON proponente.id = contratti_anagrafica.id_anagrafica 
		LEFT JOIN contratti_anagrafica AS c_a ON c_a.id_contratto = contratti.id AND c_a.id_ruolo = 28
		LEFT JOIN anagrafica AS contraente ON contraente.id = c_a.id_anagrafica
        LEFT JOIN rinnovi ON rinnovi.id_contratto = contratti.id
		WHERE ( rinnovi.data_inizio IS NULL OR rinnovi.data_inizio <= CURRENT_DATE() ) AND (rinnovi.data_fine IS NULL OR rinnovi.data_fine >= CURRENT_DATE() )
	GROUP BY contratti.id, contratti_anagrafica.id_contratto, tipologie_contratti.nome
;

--| 202208020210
CREATE OR REPLACE VIEW  contratti_anagrafica_view AS 
	SELECT 
		contratti_anagrafica.id,
		contratti_anagrafica.id_contratto,
		contratti_anagrafica.id_anagrafica,
		coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ) AS anagrafica,
		contratti_anagrafica.id_ruolo,
		ruoli_anagrafica.nome AS ruolo,
		contratti_anagrafica.ordine,
		contratti.codice,
		contratti_anagrafica.id_account_inserimento ,
		contratti_anagrafica.id_account_aggiornamento ,
		tipologie_contratti.nome AS tipologia,
		tipologie_contratti.se_abbonamento,
		tipologie_contratti.se_iscrizione,
		tipologie_contratti.se_tesseramento,
		tipologie_contratti.se_immobili,
		tipologie_contratti.se_acquisto,
		tipologie_contratti.se_locazione,
		concat( 'contratto ', contratti.nome, ' - ', coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ), ' ruolo ', ruoli_anagrafica.nome  ) AS __label__
	FROM contratti_anagrafica
		LEFT JOIN contratti ON contratti.id = contratti_anagrafica.id_contratto
		LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
		LEFT JOIN ruoli_anagrafica ON ruoli_anagrafica.id = contratti_anagrafica.id_ruolo
		LEFT JOIN anagrafica ON anagrafica.id = contratti_anagrafica.id_anagrafica;

--| 202208020220
CREATE OR REPLACE VIEW `contratti_archiviati_view` AS
	SELECT
		contratti.id,
		contratti.id_tipologia,
        tipologie_contratti.nome AS tipologia,
		contratti.id_progetto,
		progetti.nome AS progetto,
		contratti.id_immobile,
		concat_ws(
			' ',
			tipologie_immobili.nome, 
			coalesce(
			concat('scala ', immobili.scala), 
			''
			), 
			coalesce(
			concat('piano ', immobili.piano), 
			''
			), 
			coalesce(
			concat('int. ', immobili.interno), 
			''
			),
			tipologie_edifici.nome,
			edifici.nome,
			tipologie_indirizzi.nome,
			indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) AS immobile,
		contratti.codice,
		contratti.nome,
		contratti.id_account_inserimento,
		contratti.id_account_aggiornamento,
        MIN(rinnovi.data_inizio) AS data_inizio,
        MAX(rinnovi.data_fine) AS data_fine,
		group_concat( DISTINCT coalesce( proponente.denominazione , concat( proponente.cognome, ' ', proponente.nome ), '' )  SEPARATOR ', ' ) AS proponenti,
		group_concat( DISTINCT coalesce( contraente.denominazione , concat( contraente.cognome, ' ', contraente.nome ), '' )  SEPARATOR ', ' ) AS contraenti,
		concat( contratti.nome , ' - ', tipologie_contratti.nome )AS __label__
	FROM contratti
        LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
        LEFT JOIN progetti ON progetti.id = contratti.id_progetto
		LEFT JOIN immobili ON immobili.id = contratti.id_immobile
		LEFT JOIN tipologie_immobili ON tipologie_immobili.id = immobili.id_tipologia
		LEFT JOIN edifici ON edifici.id = immobili.id_edificio
		LEFT JOIN tipologie_edifici ON tipologie_edifici.id = edifici.id_tipologia
		LEFT JOIN indirizzi ON indirizzi.id = edifici.id_indirizzo
		LEFT JOIN tipologie_indirizzi ON tipologie_indirizzi.id = indirizzi.id_tipologia
		LEFT JOIN zone_indirizzi ON zone_indirizzi.id_indirizzo = indirizzi.id 
		LEFT JOIN zone ON zone.id = zone_indirizzi.id_zona
		LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
		LEFT JOIN contratti_anagrafica ON contratti_anagrafica.id_contratto = contratti.id AND contratti_anagrafica.id_ruolo = 27
		LEFT JOIN anagrafica AS proponente ON proponente.id = contratti_anagrafica.id_anagrafica 
		LEFT JOIN contratti_anagrafica AS c_a ON c_a.id_contratto = contratti.id AND c_a.id_ruolo = 28
		LEFT JOIN anagrafica AS contraente ON contraente.id = c_a.id_anagrafica
        LEFT JOIN rinnovi ON rinnovi.id_contratto = contratti.id 
    WHERE ( rinnovi.data_inizio IS NULL OR rinnovi.data_inizio >= CURRENT_DATE() ) AND  rinnovi.data_fine < CURRENT_DATE() 
    GROUP BY contratti.id
;

--| 202208020230
CREATE OR REPLACE VIEW `iscrizioni_view` AS
	SELECT
		contratti.id,
		contratti.id_tipologia,
        tipologie_contratti.nome AS tipologia,
		group_concat( DISTINCT coalesce( istituto.denominazione , concat( istituto.cognome, ' ', istituto.nome ), '' )  SEPARATOR ', ' ) AS istituti,
		group_concat( DISTINCT coalesce( iscritto.denominazione , concat( iscritto.cognome, ' ', iscritto.nome ), '' )  SEPARATOR ', ' ) AS iscritti,
		group_concat( DISTINCT if( f.id, categorie_progetti_path( f.id ), null ) SEPARATOR ' | ' ) AS fasce,
		group_concat( DISTINCT if( d.id, categorie_progetti_path( d.id ), null ) SEPARATOR ' | ' ) AS discipline,
		group_concat( DISTINCT if( l.id, categorie_progetti_path( l.id ), null ) SEPARATOR ' | ' ) AS livelli,
		contratti.id_progetto,
		progetti.nome AS progetto,
		contratti.codice,
		contratti.nome,
        MIN(rinnovi.data_inizio) AS data_inizio,
        MAX(rinnovi.data_fine) AS data_fine,
		contratti.id_account_inserimento,
		contratti.id_account_aggiornamento,
		concat( contratti.nome , ' - ', tipologie_contratti.nome )AS __label__
	FROM contratti
        LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
		LEFT JOIN contratti_anagrafica ON contratti_anagrafica.id_contratto = contratti.id AND contratti_anagrafica.id_ruolo = 30
		LEFT JOIN anagrafica AS istituto ON istituto.id = contratti_anagrafica.id_anagrafica 
		LEFT JOIN contratti_anagrafica AS c_a ON c_a.id_contratto = contratti.id AND c_a.id_ruolo = 29
		LEFT JOIN anagrafica AS iscritto ON iscritto.id = c_a.id_anagrafica
        LEFT JOIN progetti ON progetti.id = contratti.id_progetto
		LEFT JOIN progetti_categorie ON progetti_categorie.id_progetto = progetti.id
		LEFT JOIN categorie_progetti AS f ON f.id = progetti_categorie.id_categoria AND f.se_fascia = 1
		LEFT JOIN categorie_progetti AS d ON d.id = progetti_categorie.id_categoria AND d.se_disciplina = 1		
		LEFT JOIN categorie_progetti AS l ON l.id = progetti_categorie.id_categoria AND l.se_classe = 1
		LEFT JOIN rinnovi ON rinnovi.id_contratto = contratti.id
    WHERE tipologie_contratti.se_iscrizione = 1
	GROUP BY contratti.id
;

--| 202208020240
CREATE OR REPLACE VIEW `iscrizioni_attivi_view` AS
	SELECT
		contratti.id,
		contratti.id_tipologia,
        tipologie_contratti.nome AS tipologia,
		group_concat( DISTINCT coalesce( istituto.denominazione , concat( istituto.cognome, ' ', istituto.nome ), '' )  SEPARATOR ', ' ) AS istituti,
		group_concat( DISTINCT coalesce( iscritto.denominazione , concat( iscritto.cognome, ' ', iscritto.nome ), '' )  SEPARATOR ', ' ) AS iscritti,
		contratti.id_progetto,
		progetti.nome AS progetto,
		contratti.codice,
		contratti.nome,
        MIN(rinnovi.data_inizio) AS data_inizio,
        MAX(rinnovi.data_fine) AS data_fine,
		contratti.id_account_inserimento,
		contratti.id_account_aggiornamento,
		concat( contratti.nome , ' - ', tipologie_contratti.nome )AS __label__
	FROM contratti
        LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
		LEFT JOIN contratti_anagrafica ON contratti_anagrafica.id_contratto = contratti.id AND contratti_anagrafica.id_ruolo = 30
		LEFT JOIN anagrafica AS istituto ON istituto.id = contratti_anagrafica.id_anagrafica 
		LEFT JOIN contratti_anagrafica AS c_a ON c_a.id_contratto = contratti.id AND c_a.id_ruolo = 29
		LEFT JOIN anagrafica AS iscritto ON iscritto.id = c_a.id_anagrafica
        LEFT JOIN progetti ON progetti.id = contratti.id_progetto
        LEFT JOIN rinnovi ON rinnovi.id_contratto = contratti.id 
    WHERE tipologie_contratti.se_iscrizione = 1 AND ( rinnovi.data_inizio IS NULL OR rinnovi.data_inizio <= CURRENT_DATE() ) AND (rinnovi.data_fine IS NULL OR rinnovi.data_fine >= CURRENT_DATE() )
    GROUP BY contratti.id
;

--| 202208020250
CREATE OR REPLACE VIEW `iscrizioni_archiviati_view` AS
	SELECT
		contratti.id,
		contratti.id_tipologia,
        tipologie_contratti.nome AS tipologia,
		group_concat( DISTINCT coalesce( istituto.denominazione , concat( istituto.cognome, ' ', istituto.nome ), '' )  SEPARATOR ', ' ) AS istituti,
		group_concat( DISTINCT coalesce( iscritto.denominazione , concat( iscritto.cognome, ' ', iscritto.nome ), '' )  SEPARATOR ', ' ) AS iscritti,
		contratti.id_progetto,
		progetti.nome AS progetto,
		contratti.codice,
		contratti.nome,
        MIN(rinnovi.data_inizio) AS data_inizio,
        MAX(rinnovi.data_fine) AS data_fine,
		contratti.id_account_inserimento,
		contratti.id_account_aggiornamento,
		concat( contratti.nome , ' - ', tipologie_contratti.nome )AS __label__
	FROM contratti
        LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
		LEFT JOIN contratti_anagrafica ON contratti_anagrafica.id_contratto = contratti.id AND contratti_anagrafica.id_ruolo = 30
		LEFT JOIN anagrafica AS istituto ON istituto.id = contratti_anagrafica.id_anagrafica 
		LEFT JOIN contratti_anagrafica AS c_a ON c_a.id_contratto = contratti.id AND c_a.id_ruolo = 29
		LEFT JOIN anagrafica AS iscritto ON iscritto.id = c_a.id_anagrafica
        LEFT JOIN progetti ON progetti.id = contratti.id_progetto
        LEFT JOIN rinnovi ON rinnovi.id_contratto = contratti.id 
    WHERE tipologie_contratti.se_iscrizione = 1 AND ( rinnovi.data_inizio IS NULL OR rinnovi.data_inizio >= CURRENT_DATE() ) AND  rinnovi.data_fine < CURRENT_DATE() 
    GROUP BY contratti.id
;

--| 202208020260
CREATE OR REPLACE VIEW `tesseramenti_view` AS
	SELECT
		contratti.id,
		contratti.id_tipologia,
        tipologie_contratti.nome AS tipologia,
		group_concat( DISTINCT coalesce( istituto.denominazione , concat( istituto.cognome, ' ', istituto.nome ), '' )  SEPARATOR ', ' ) AS istituti,
		group_concat( DISTINCT coalesce( iscritto.denominazione , concat( iscritto.cognome, ' ', iscritto.nome ), '' )  SEPARATOR ', ' ) AS iscritti,
		contratti.id_progetto,
		progetti.nome AS progetto,
		contratti.codice,
		contratti.nome,
        MIN(rinnovi.data_inizio) AS data_inizio,
        MAX(rinnovi.data_fine) AS data_fine,
		contratti.id_account_inserimento,
		contratti.id_account_aggiornamento,
		concat( contratti.nome , ' - ', tipologie_contratti.nome ) AS __label__
	FROM contratti
        LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
		LEFT JOIN contratti_anagrafica ON contratti_anagrafica.id_contratto = contratti.id AND contratti_anagrafica.id_ruolo = 30
		LEFT JOIN anagrafica AS istituto ON istituto.id = contratti_anagrafica.id_anagrafica 
		LEFT JOIN contratti_anagrafica AS c_a ON c_a.id_contratto = contratti.id AND c_a.id_ruolo = 29
		LEFT JOIN anagrafica AS iscritto ON iscritto.id = c_a.id_anagrafica
        LEFT JOIN progetti ON progetti.id = contratti.id_progetto
        LEFT JOIN rinnovi ON rinnovi.id_contratto = contratti.id 
    WHERE tipologie_contratti.se_tesseramento = 1
    GROUP BY contratti.id
;

--| 202208020270
CREATE OR REPLACE VIEW `tesseramenti_attivi_view` AS
		SELECT
		contratti.id,
		contratti.id_tipologia,
        tipologie_contratti.nome AS tipologia,
		group_concat( DISTINCT coalesce( istituto.denominazione , concat( istituto.cognome, ' ', istituto.nome ), '' )  SEPARATOR ', ' ) AS istituti,
		group_concat( DISTINCT coalesce( iscritto.denominazione , concat( iscritto.cognome, ' ', iscritto.nome ), '' )  SEPARATOR ', ' ) AS iscritti,
		contratti.id_progetto,
		progetti.nome AS progetto,
		contratti.codice,
		contratti.nome,
        MIN(rinnovi.data_inizio) AS data_inizio,
        MAX(rinnovi.data_fine) AS data_fine,
		contratti.id_account_inserimento,
		contratti.id_account_aggiornamento,
		concat( contratti.nome , ' - ', tipologie_contratti.nome ) AS __label__
	FROM contratti
        LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
		LEFT JOIN contratti_anagrafica ON contratti_anagrafica.id_contratto = contratti.id AND contratti_anagrafica.id_ruolo = 30
		LEFT JOIN anagrafica AS istituto ON istituto.id = contratti_anagrafica.id_anagrafica 
		LEFT JOIN contratti_anagrafica AS c_a ON c_a.id_contratto = contratti.id AND c_a.id_ruolo = 29
		LEFT JOIN anagrafica AS iscritto ON iscritto.id = c_a.id_anagrafica
        LEFT JOIN progetti ON progetti.id = contratti.id_progetto
        LEFT JOIN rinnovi ON rinnovi.id_contratto = contratti.id 
    WHERE tipologie_contratti.se_tesseramento = 1 AND ( rinnovi.data_inizio IS NULL OR rinnovi.data_inizio <= CURRENT_DATE() ) AND (rinnovi.data_fine IS NULL OR rinnovi.data_fine >= CURRENT_DATE() )
    GROUP BY contratti.id
;

--| 202208020280
CREATE OR REPLACE VIEW `tesseramenti_archiviati_view` AS
			SELECT
		contratti.id,
		contratti.id_tipologia,
        tipologie_contratti.nome AS tipologia,
		group_concat( DISTINCT coalesce( istituto.denominazione , concat( istituto.cognome, ' ', istituto.nome ), '' )  SEPARATOR ', ' ) AS istituti,
		group_concat( DISTINCT coalesce( iscritto.denominazione , concat( iscritto.cognome, ' ', iscritto.nome ), '' )  SEPARATOR ', ' ) AS iscritti,
		contratti.id_progetto,
		progetti.nome AS progetto,
		contratti.codice,
		contratti.nome,
        MIN(rinnovi.data_inizio) AS data_inizio,
        MAX(rinnovi.data_fine) AS data_fine,
		contratti.id_account_inserimento,
		contratti.id_account_aggiornamento,
		concat( contratti.nome , ' - ', tipologie_contratti.nome ) AS __label__
	FROM contratti
        LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
		LEFT JOIN contratti_anagrafica ON contratti_anagrafica.id_contratto = contratti.id AND contratti_anagrafica.id_ruolo = 30
		LEFT JOIN anagrafica AS istituto ON istituto.id = contratti_anagrafica.id_anagrafica 
		LEFT JOIN contratti_anagrafica AS c_a ON c_a.id_contratto = contratti.id AND c_a.id_ruolo = 29
		LEFT JOIN anagrafica AS iscritto ON iscritto.id = c_a.id_anagrafica
        LEFT JOIN progetti ON progetti.id = contratti.id_progetto
        LEFT JOIN rinnovi ON rinnovi.id_contratto = contratti.id 
    WHERE tipologie_contratti.se_tesseramento = 1 AND ( rinnovi.data_inizio IS NULL OR rinnovi.data_inizio >= CURRENT_DATE() ) AND  rinnovi.data_fine < CURRENT_DATE() 
    GROUP BY contratti.id
;

--| 202208020290
INSERT IGNORE INTO `tipologie_attivita` (`id`, `id_genitore`, `ordine`, `codice`, `nome`, `html_entity`, `font_awesome`, `se_anagrafica`, `se_agenda`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(15,	1,	NULL,	NULL,	'frequenza',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL);

--| FINE