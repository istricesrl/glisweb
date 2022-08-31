--
-- PATCH
-- 

--| 202206200010
ALTER TABLE `anagrafica_indirizzi` 
  CHANGE `id_indirizzo` `id_indirizzo` int(11) DEFAULT NULL,
  ADD COLUMN`indirizzo` char(255) DEFAULT NULL AFTER `interno`;

--| 202206200020
CREATE OR REPLACE VIEW anagrafica_indirizzi_view AS
	SELECT
		anagrafica_indirizzi.id,
		anagrafica_indirizzi.id_anagrafica,
		anagrafica_indirizzi.id_indirizzo,
		IF( anagrafica_indirizzi.id_indirizzo IS NOT NULL , concat(indirizzi.indirizzo,' ',comuni.nome,' ',provincie.sigla), anagrafica_indirizzi.indirizzo) AS indirizzo,
		anagrafica_indirizzi.id_ruolo,
		ruoli_indirizzi.nome AS ruolo,
		anagrafica_indirizzi.id_account_inserimento,
		anagrafica_indirizzi.id_account_aggiornamento,
		IF( anagrafica_indirizzi.id_indirizzo IS NOT NULL ,
		concat(
			coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ),
			' / ',
			tipologie_indirizzi.nome,
			' ',
			indirizzi.indirizzo,
			' ',
			indirizzi.civico,
			' ',
			comuni.nome,
			' ',
			provincie.sigla
		),
		concat(
			coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ),
			' / ',
			tipologie_indirizzi.nome,
			' ',
			anagrafica_indirizzi.indirizzo
		) )AS __label__
	FROM anagrafica_indirizzi
		INNER JOIN anagrafica ON anagrafica.id = anagrafica_indirizzi.id_anagrafica
		LEFT JOIN ruoli_indirizzi ON ruoli_indirizzi.id = anagrafica_indirizzi.id_ruolo
		LEFT JOIN indirizzi ON indirizzi.id = anagrafica_indirizzi.id_indirizzo
		LEFT JOIN tipologie_indirizzi ON tipologie_indirizzi.id = indirizzi.id_tipologia
		LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
;

--| 202206200040
ALTER TABLE `immobili` 
  ADD COLUMN `catasto_foglio` char(255) DEFAULT NULL AFTER `campanello`,
  ADD COLUMN  `catasto_particella` char(255) DEFAULT NULL AFTER `catasto_foglio`,
  ADD COLUMN  `catasto_sub` char(255) DEFAULT NULL AFTER `catasto_particella`,
  ADD COLUMN  `catasto_categoria` char(255) DEFAULT NULL AFTER `catasto_sub`,
  ADD COLUMN  `catasto_classe` char(255) DEFAULT NULL AFTER `catasto_categoria`,
  ADD COLUMN  `catasto_consistenza` char(255) DEFAULT NULL AFTER `catasto_classe`,
  ADD COLUMN   `catasto_superficie` char(255) DEFAULT NULL AFTER `catasto_consistenza`,
  ADD COLUMN  `catasto_rendita` char(255) DEFAULT NULL AFTER `catasto_superficie`,
  ADD KEY  `catasto_foglio` (`catasto_foglio`),
  ADD KEY  `catasto_particella` (`catasto_particella`),
  ADD KEY  `catasto_sub` (`catasto_sub`),
  ADD KEY  `catasto_categoria` (`catasto_categoria`),
  ADD KEY  `catasto_classe` (`catasto_classe`),
  ADD KEY  `catasto_consistenza` (`catasto_consistenza`),
  ADD KEY  `catasto_superficie` (`catasto_superficie`),
  ADD KEY  `catasto_rendita` (`catasto_rendita`);

--| 202206200052
CREATE OR REPLACE VIEW immobili_view AS
	SELECT
		immobili.id,
		immobili.id_tipologia,
		tipologie_immobili.nome AS tipologia,
		immobili.id_edificio,
		immobili.nome,
		immobili.codice,
		edifici.id_indirizzo,
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
		immobili.scala,
		immobili.piano,
		immobili.interno,
		immobili.campanello,
		immobili.catasto_foglio,
		immobili.catasto_particella,
		immobili.catasto_sub,
		immobili.catasto_categoria,
		immobili.catasto_classe,
		immobili.catasto_consistenza,
		immobili.catasto_superficie,
		immobili.catasto_rendita,
		immobili.id_account_inserimento,
		immobili.id_account_aggiornamento,
		MAX(rinnovi.data_inizio) AS data_inizio,
        MAX(rinnovi.data_fine) AS data_fine,
		group_concat( DISTINCT coalesce( proponente.denominazione , concat( proponente.cognome, ' ', proponente.nome ), '' )  SEPARATOR ', ' ) AS proponenti,
		group_concat( DISTINCT coalesce( contraente.denominazione , concat( contraente.cognome, ' ', contraente.nome ), '' )  SEPARATOR ', ' ) AS contraenti,
		group_concat( DISTINCT zone_path( zone.id ) SEPARATOR ' | ' ) AS zone,
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
		) AS __label__
	FROM immobili
		LEFT JOIN tipologie_immobili ON tipologie_immobili.id = immobili.id_tipologia
		LEFT JOIN edifici ON edifici.id = immobili.id_edificio
		LEFT JOIN tipologie_edifici ON tipologie_edifici.id = edifici.id_tipologia
		LEFT JOIN indirizzi ON indirizzi.id = edifici.id_indirizzo
		LEFT JOIN tipologie_indirizzi ON tipologie_indirizzi.id = indirizzi.id_tipologia
		LEFT JOIN zone_indirizzi ON zone_indirizzi.id_indirizzo = indirizzi.id 
		LEFT JOIN zone ON zone.id = zone_indirizzi.id_zona
		LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
		LEFT JOIN regioni ON regioni.id = provincie.id_regione
		LEFT JOIN stati ON stati.id = regioni.id_stato	
		LEFT JOIN contratti ON contratti.id_immobile = immobili.id
		LEFT JOIN contratti_anagrafica ON contratti_anagrafica.id_contratto = contratti.id AND contratti_anagrafica.id_ruolo = 27
		LEFT JOIN anagrafica AS proponente ON proponente.id = contratti_anagrafica.id_anagrafica 
		LEFT JOIN contratti_anagrafica AS c_a ON c_a.id_contratto = contratti.id AND c_a.id_ruolo = 28
		LEFT JOIN anagrafica AS contraente ON contraente.id = c_a.id_anagrafica
        LEFT JOIN rinnovi ON rinnovi.id_contratto = contratti.id  AND ( rinnovi.data_inizio IS NULL OR rinnovi.data_inizio <= CURRENT_DATE() ) AND (rinnovi.data_fine IS NULL OR rinnovi.data_fine >= CURRENT_DATE() )
	GROUP BY immobili.id, contratti.id, contratti_anagrafica.id_contratto
;

--| 202206200060
ALTER TABLE `documenti_articoli` CHANGE `importo_netto_totale` `importo_netto_totale` DECIMAL(16,2) NOT NULL;

--| FINE