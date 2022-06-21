--
-- PATCH
-- 

--| 202206160010
CREATE OR REPLACE VIEW `__report_movimenti_magazzini__` AS
SELECT
  id,
  nome,
  articolo,
  id_articolo,
  matricola,
  data_scadenza,
  data,
  id_tipologia,
  tipologia,
  numero,
  id_riga,
  carico,
  scarico
FROM (
SELECT
  mastri.id,
  mastri.nome,
  concat_ws(
			' ',
			prodotti.nome,
			articoli.nome,
			coalesce(
				concat(
					articoli.larghezza, 'x', articoli.lunghezza, 'x', articoli.altezza,
          ' ',
					udm_dimensioni.sigla
				),
				concat(
					articoli.peso,
          ' ',
					udm_peso.sigla
				),
				concat(
					articoli.volume,
          ' ',
					udm_volume.sigla
				),
				concat(
					articoli.capacita,
          ' ',
					udm_capacita.sigla
				),
				concat(
					articoli.durata,
          ' ',
					udm_durata.sigla
				),
				''
			)
		)AS articolo,
  articoli.id AS id_articolo,
  matricole.matricola,
  matricole.data_scadenza,
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
  LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
  LEFT JOIN documenti ON documenti.id = documenti_articoli.id_documento
  LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
  LEFT JOIN matricole ON matricole.id = documenti_articoli.id_matricola
  LEFT JOIN udm AS udm_dimensioni ON udm_dimensioni.id = articoli.id_udm_dimensioni
		LEFT JOIN udm AS udm_peso ON udm_peso.id = articoli.id_udm_peso
		LEFT JOIN udm AS udm_volume ON udm_volume.id = articoli.id_udm_volume
		LEFT JOIN udm AS udm_capacita ON udm_capacita.id = articoli.id_udm_capacita
		LEFT JOIN udm AS udm_durata ON udm_durata.id = articoli.id_udm_durata
  WHERE documenti_articoli.quantita IS NOT NULL
UNION
SELECT
  mastri.id,
  mastri.nome,
  concat_ws(
			' ',
			prodotti.nome,
			articoli.nome,
			coalesce(
				concat(
					articoli.larghezza, 'x', articoli.lunghezza, 'x', articoli.altezza,
          ' ',
					udm_dimensioni.sigla
				),
				concat(
					articoli.peso,
          ' ',
					udm_peso.sigla
				),
				concat(
					articoli.volume,
          ' ',
					udm_volume.sigla
				),
				concat(
					articoli.capacita,
          ' ',
					udm_capacita.sigla
				),
				concat(
					articoli.durata,
          ' ',
					udm_durata.sigla
				),
				''
			)
		) AS articolo,
  articoli.id AS id_articolo,
  matricole.matricola,
  matricole.data_scadenza,
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
  LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
  LEFT JOIN documenti ON documenti.id = documenti_articoli.id_documento
  LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
  LEFT JOIN matricole ON matricole.id = documenti_articoli.id_matricola
  LEFT JOIN udm AS udm_dimensioni ON udm_dimensioni.id = articoli.id_udm_dimensioni
		LEFT JOIN udm AS udm_peso ON udm_peso.id = articoli.id_udm_peso
		LEFT JOIN udm AS udm_volume ON udm_volume.id = articoli.id_udm_volume
		LEFT JOIN udm AS udm_capacita ON udm_capacita.id = articoli.id_udm_capacita
		LEFT JOIN udm AS udm_durata ON udm_durata.id = articoli.id_udm_durata
  WHERE documenti_articoli.quantita IS NOT NULL
) AS movimenti;

--| 202206160020
ALTER TABLE tipologie_documenti
    ADD COLUMN   `sigla` char(16) DEFAULT NULL AFTER  `nome`,
	ADD KEY `sigla` (`sigla`);

--| 202206160030
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
		tipologie_documenti.id_account_inserimento,
		tipologie_documenti.id_account_aggiornamento,
		tipologie_documenti_path( tipologie_documenti.id ) AS __label__
	FROM tipologie_documenti
;

--| 202206160040
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
			tipologie_documenti.sigla,
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

--| 202206160050
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
			tipologie_documenti.sigla,
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

--| 202206160060
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
			tipologie_documenti.sigla,
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

--| 202206160070
CREATE OR REPLACE VIEW `attivita_view` AS
	SELECT	
		attivita.id,
		attivita.id_tipologia,
		tipologie_attivita.nome AS tipologia,
		attivita.id_cliente,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS cliente,
		attivita.id_indirizzo,
		indirizzi.indirizzo AS indirizzo,
		attivita.id_luogo,
		luoghi_path( attivita.id_luogo ) AS luogo,
		attivita.data_scadenza,
		attivita.ora_scadenza,
		attivita.data_programmazione,
		attivita.ora_inizio_programmazione,
		attivita.ora_fine_programmazione,
		attivita.id_anagrafica_programmazione,
		coalesce( a3.denominazione , concat( a3.cognome, ' ', a3.nome ), '' ) AS anagrafica_programmazione,
		attivita.ore_programmazione,
		attivita.data_attivita,
		day( data_attivita ) as giorno_attivita,
		month( data_attivita ) as mese_attivita,
		year( data_attivita ) as anno_attivita,
		attivita.ora_inizio,
		attivita.latitudine_ora_inizio,
		attivita.longitudine_ora_inizio,
		attivita.ora_fine,
		attivita.latitudine_ora_fine,
		attivita.longitudine_ora_fine,
		attivita.id_anagrafica,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		attivita.ore,
		attivita.nome,
		attivita.id_documento,
		concat(
			tipologie_documenti.sigla,
			' ',
			documenti.numero,
			'/',
			documenti.sezionale,
			' del ',
			documenti.data
		) AS documento,
		attivita.id_progetto,
		progetti.nome AS progetto,
		attivita.id_matricola,
        attivita.id_immobile,
		attivita.id_todo,
		todo.nome AS todo,
		attivita.id_mastro_provenienza,
		m1.nome AS mastro_provenienza,
		attivita.id_mastro_destinazione,
		m2.nome AS mastro_destinazione,
		attivita.codice_archivium,
		attivita.token,
		attivita.id_account_inserimento,
		attivita.id_account_aggiornamento,
		concat(
			attivita.nome,
			' / ',
			attivita.ore,
			' / ',
			coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' )
		) AS __label__
	FROM attivita
		LEFT JOIN tipologie_attivita ON tipologie_attivita.id = attivita.id_tipologia
		LEFT JOIN anagrafica AS a1 ON a1.id = attivita.id_anagrafica
		LEFT JOIN anagrafica AS a2 ON a2.id = attivita.id_cliente
		LEFT JOIN anagrafica AS a3 ON a3.id = attivita.id_anagrafica_programmazione
		LEFT JOIN progetti_categorie ON progetti_categorie.id_progetto = attivita.id_progetto
		LEFT JOIN categorie_progetti ON categorie_progetti.id = progetti_categorie.id_categoria
		LEFT JOIN progetti ON progetti.id = attivita.id_progetto
		LEFT JOIN todo ON todo.id = attivita.id_todo
		LEFT JOIN indirizzi ON indirizzi.id = attivita.id_indirizzo
		LEFT JOIN mastri AS m1 ON m1.id = attivita.id_mastro_provenienza
		LEFT JOIN mastri AS m2 ON m2.id = attivita.id_mastro_destinazione
		LEFT JOIN documenti ON documenti.id = attivita.id_documento
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
;

--| 202206160080
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
		documenti.porto,
		documenti.id_causale,
		documenti.id_trasportatore,
		documenti.id_immobile,
		documenti.timestamp_chiusura,
		from_unixtime( documenti.timestamp_chiusura, '%Y-%m-%d %H:%i' ) AS data_ora_chiusura,
		documenti.id_account_inserimento,
		documenti.id_account_aggiornamento,
		concat(
			tipologie_documenti.sigla,
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

--| 202206160090
CREATE OR REPLACE VIEW `documenti_articoli_view` AS
    SELECT
		documenti_articoli.id,
		documenti_articoli.id_genitore,
		documenti_articoli.id_tipologia,
		tipologie_documenti.nome AS tipologia,
		documenti_articoli.ordine,
		documenti_articoli.id_documento,
        concat(
			tipologie_documenti.sigla,
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
		udm_riga.sigla AS udm,
				concat_ws(
			' ',
			articoli.id,
			'/',
			prodotti.nome,
			articoli.nome,
			coalesce(
				concat(
					articoli.larghezza, 'x', articoli.lunghezza, 'x', articoli.altezza,
					' ',
					udm_dimensioni.sigla
				),
				concat(
					articoli.peso,
					' ',
					udm_peso.sigla
				),
				concat(
					articoli.volume,
					' ',
					udm_volume.sigla
				),
				concat(
					articoli.capacita,
					' ',
					udm_capacita.sigla
				),
				concat(
					articoli.durata,
					' ',
					udm_durata.sigla
				),
				''
			)
		) AS articolo,
		documenti_articoli.id_prodotto,
		IF( documenti_articoli.id_articolo IS NOT NULL ,prodotti.nome, p.nome ) AS prodotto,
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
		matricole.matricola AS matricola,
		documenti_articoli.id_collo,
		matricole.data_scadenza,
		documenti_articoli.nome,
		documenti_articoli.id_account_inserimento,
		documenti_articoli.id_account_aggiornamento,
		concat(
			documenti_articoli.data,
			' / ',
			tipologie_documenti.sigla,
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
		LEFT JOIN prodotti AS p ON p.id = documenti_articoli.id_prodotto
		LEFT JOIN udm AS udm_dimensioni ON udm_dimensioni.id = articoli.id_udm_dimensioni
		LEFT JOIN udm AS udm_peso ON udm_peso.id = articoli.id_udm_peso
		LEFT JOIN udm AS udm_volume ON udm_volume.id = articoli.id_udm_volume
		LEFT JOIN udm AS udm_capacita ON udm_capacita.id = articoli.id_udm_capacita
		LEFT JOIN udm AS udm_durata ON udm_durata.id = articoli.id_udm_durata
		LEFT JOIN udm AS udm_riga ON udm_riga.id = documenti_articoli.id_udm
;

--| 202206160100
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
		coalesce(
			a1.soprannome,
			a1.denominazione,
			concat_ws(' ', coalesce(a1.cognome, ''),
			coalesce(a1.nome, '') ),
			''
		) AS emittente,
		documenti.id_destinatario,
		coalesce(
			a2.soprannome,
			a2.denominazione,
			concat_ws(' ', coalesce(a2.cognome, ''),
			coalesce(a2.nome, '') ),
			''
		) AS destinatario,
		documenti.id_condizione_pagamento,
		condizioni_pagamento.codice AS condizione_pagamento,
		documenti.codice_archivium,
    	documenti.codice_sdi,
		documenti.cig,
		documenti.cup,
		documenti.riferimento,
    	documenti.timestamp_invio,
    	documenti.progressivo_invio,
		documenti.id_coupon,
		documenti.timestamp_chiusura,
		from_unixtime( documenti.timestamp_chiusura, '%Y-%m-%d %H:%i' ) AS data_ora_chiusura,
		documenti.id_account_inserimento,
		documenti.id_account_aggiornamento,
		concat(
			tipologie_documenti.sigla,
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
   	WHERE tipologie_documenti.se_fattura IS NOT NULL
;

--| 202206160110
CREATE OR REPLACE VIEW `fatture_attive_view` AS
    SELECT
		documenti.id,
		documenti.id_tipologia,
		tipologie_documenti.nome AS tipologia,
		documenti.numero,
		documenti.sezionale,
		documenti.data,
		documenti.nome,
		documenti.id_emittente,
		documenti.cig,
		documenti.cup,
		documenti.riferimento,
		coalesce(
			a1.soprannome,
			a1.denominazione,
			concat_ws(' ', coalesce(a1.cognome, ''),
			coalesce(a1.nome, '') ),
			''
		) AS emittente,
		documenti.id_destinatario,
		coalesce(
			a2.soprannome,
			a2.denominazione,
			concat_ws(' ', coalesce(a2.cognome, ''),
			coalesce(a2.nome, '') ),
			''
		) AS destinatario,
		documenti.id_account_inserimento,
		documenti.id_account_aggiornamento,
		documenti.timestamp_chiusura,
		concat(
			tipologie_documenti.sigla,
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
   	WHERE tipologie_documenti.se_fattura IS NOT NULL
	   AND anagrafica_check_gestita( a1.id ) IS NOT NULL
;

--| 202206160120
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
		documenti.cig,
		documenti.cup,
		documenti.riferimento,
				coalesce(
			a1.soprannome,
			a1.denominazione,
			concat_ws(' ', coalesce(a1.cognome, ''),
			coalesce(a1.nome, '') ),
			''
		) AS emittente,
		documenti.id_destinatario,
		coalesce(
			a2.soprannome,
			a2.denominazione,
			concat_ws(' ', coalesce(a2.cognome, ''),
			coalesce(a2.nome, '') ),
			''
		) AS destinatario,
		documenti.id_account_inserimento,
		documenti.id_account_aggiornamento,
		documenti.timestamp_chiusura,
		concat(
			tipologie_documenti.sigla,
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
   	WHERE tipologie_documenti.se_fattura IS NOT NULL
	   AND anagrafica_check_gestita( a2.id ) IS NOT NULL
;

--| 202206160130
CREATE OR REPLACE VIEW `note_credito_view` AS
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
			tipologie_documenti.sigla,
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
   WHERE tipologie_documenti.id = 3
;

--| 202206160140
CREATE OR REPLACE VIEW `ordini_view` AS
    SELECT
		documenti.id,
		documenti.id_tipologia,
		tipologie_documenti.nome AS tipologia,
		documenti.numero,
		documenti.sezionale,
		documenti.data,
		documenti.nome,
		documenti.id_emittente,
		coalesce(
			a1.soprannome,
			a1.denominazione,
			concat_ws(' ', coalesce(a1.cognome, ''),
			coalesce(a1.nome, '') ),
			''
		) AS emittente,
		documenti.id_destinatario,
		coalesce(
			a2.soprannome,
			a2.denominazione,
			concat_ws(' ', coalesce(a2.cognome, ''),
			coalesce(a2.nome, '') ),
			''
		) AS destinatario,
		documenti.id_condizione_pagamento,
		condizioni_pagamento.codice AS condizione_pagamento,
		documenti.codice_archivium,
    	documenti.codice_sdi,
		documenti.cig,
		documenti.cup,
		documenti.riferimento,
    	documenti.timestamp_invio,
    	documenti.progressivo_invio,
		documenti.id_coupon,
		documenti.timestamp_chiusura,
		from_unixtime( documenti.timestamp_chiusura, '%Y-%m-%d %H:%i' ) AS data_ora_chiusura,
		documenti.id_account_inserimento,
		documenti.id_account_aggiornamento,
		concat(
			tipologie_documenti.sigla,
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
   	WHERE tipologie_documenti.se_ordine IS NOT NULL
;

--| 202206160150
CREATE OR REPLACE VIEW `ordini_attivi_view` AS
    SELECT
		documenti.id,
		documenti.id_tipologia,
		tipologie_documenti.nome AS tipologia,
		documenti.numero,
		documenti.sezionale,
		documenti.data,
		documenti.nome,
		documenti.id_emittente,
		documenti.cig,
		documenti.cup,
		documenti.riferimento,
		coalesce(
			a1.soprannome,
			a1.denominazione,
			concat_ws(' ', coalesce(a1.cognome, ''),
			coalesce(a1.nome, '') ),
			''
		) AS emittente,
		documenti.id_destinatario,
		coalesce(
			a2.soprannome,
			a2.denominazione,
			concat_ws(' ', coalesce(a2.cognome, ''),
			coalesce(a2.nome, '') ),
			''
		) AS destinatario,
		documenti.id_account_inserimento,
		documenti.id_account_aggiornamento,
		documenti.timestamp_chiusura,
		concat(
			tipologie_documenti.sigla,
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
   	WHERE tipologie_documenti.se_ordine IS NOT NULL
	   AND anagrafica_check_gestita( a1.id ) IS NOT NULL
;

--| 202206160160
CREATE OR REPLACE VIEW `ordini_passivi_view` AS
    SELECT
		documenti.id,
		documenti.id_tipologia,
		tipologie_documenti.nome AS tipologia,
		documenti.numero,
		documenti.sezionale,
		documenti.data,
		documenti.nome,
		documenti.id_emittente,
		documenti.cig,
		documenti.cup,
		documenti.riferimento,
				coalesce(
			a1.soprannome,
			a1.denominazione,
			concat_ws(' ', coalesce(a1.cognome, ''),
			coalesce(a1.nome, '') ),
			''
		) AS emittente,
		documenti.id_destinatario,
		coalesce(
			a2.soprannome,
			a2.denominazione,
			concat_ws(' ', coalesce(a2.cognome, ''),
			coalesce(a2.nome, '') ),
			''
		) AS destinatario,
		documenti.id_account_inserimento,
		documenti.id_account_aggiornamento,
		documenti.timestamp_chiusura,
		concat(
			tipologie_documenti.sigla,
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
   	WHERE tipologie_documenti.se_ordine IS NOT NULL
	   AND anagrafica_check_gestita( a2.id ) IS NOT NULL
;

--| 202206160170
CREATE OR REPLACE VIEW `pagamenti_view` AS
	SELECT
		pagamenti.id,
		pagamenti.id_tipologia,
		pagamenti.id_modalita_pagamento,
		concat(modalita_pagamento.codice, ' - ' ,modalita_pagamento.nome) AS modalita_pagamento,
		tipologie_pagamenti.nome AS tipologia,
		pagamenti.ordine,
		pagamenti.nome,
		pagamenti.note,
		pagamenti.note_pagamento,
		pagamenti.id_documento,
        concat(
			tipologie_documenti.sigla,
			' ',
			documenti.numero,
			'/',
			year( documenti.data ),
			' del ',
			documenti.data
		) AS documento,
		pagamenti.id_mastro_provenienza,
		m1.nome AS mastro_provenienza,
		pagamenti.id_mastro_destinazione,
		m2.nome AS mastro_destinazione,
		documenti.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		documenti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		pagamenti.id_iban,
		iban.iban AS iban,
		pagamenti.importo_netto_totale,
		pagamenti.id_iva,
		iva.nome AS iva,
		pagamenti.id_listino,
		listini.nome AS listino,
		pagamenti.timestamp_scadenza,
		from_unixtime( pagamenti.timestamp_scadenza, '%Y-%m-%d' ) AS data_ora_scadenza,
		pagamenti.timestamp_pagamento,
		from_unixtime( pagamenti.timestamp_pagamento, '%Y-%m-%d' ) AS data_ora_pagamento,
		pagamenti.id_account_inserimento,
		pagamenti.id_account_aggiornamento,
		pagamenti.nome AS __label__
	FROM pagamenti
		LEFT JOIN tipologie_pagamenti ON tipologie_pagamenti.id = pagamenti.id_tipologia
		LEFT JOIN mastri AS m1 ON m1.id = pagamenti.id_mastro_provenienza
		LEFT JOIN mastri AS m2 ON m2.id = pagamenti.id_mastro_destinazione
		LEFT JOIN iva ON iva.id = pagamenti.id_iva
		LEFT JOIN listini ON listini.id = pagamenti.id_listino
		LEFT JOIN modalita_pagamento ON modalita_pagamento.id = pagamenti.id_modalita_pagamento
		LEFT JOIN documenti ON documenti.id = pagamenti.id_documento
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
		LEFT JOIN anagrafica AS a1 ON a1.id = documenti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = documenti.id_destinatario
		LEFT JOIN iban ON iban.id = pagamenti.id_iban
	WHERE
		tipologie_documenti.se_fattura = 1
		OR
		tipologie_documenti.se_nota_credito = 1
		OR
		tipologie_documenti.se_ricevuta = 1
		OR
		tipologie_documenti.se_pro_forma = 1
;

--| 202206160180
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
		from_unixtime( documenti.timestamp_chiusura, '%Y-%m-%d %H:%i' ) AS data_ora_chiusura,
		documenti.id_account_inserimento,
		documenti.id_account_aggiornamento,
		concat(
			tipologie_documenti.sigla,
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

--| 202206160190
CREATE OR REPLACE VIEW `righe_fatture_view` AS
       SELECT
		documenti_articoli.id,
		documenti_articoli.id_genitore,
		documenti_articoli.id_tipologia,
		tipologie_documenti.nome AS tipologia,
		documenti_articoli.ordine,
		documenti_articoli.id_documento,
        concat(
			tipologie_documenti.sigla,
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
		documenti_articoli.id_mastro_provenienza,
		m1.nome AS mastro_provenienza,
		documenti_articoli.id_mastro_destinazione,
		m2.nome AS mastro_destinazione,
		documenti_articoli.id_udm,
		documenti_articoli.quantita,
		documenti_articoli.id_listino,
		listini.id_valuta,
		valute.utf8 AS valuta,
		documenti_articoli.importo_netto_totale,
		documenti_articoli.sconto_percentuale,
		documenti_articoli.sconto_valore,
		documenti_articoli.id_matricola,
		matricole.matricola AS matricola,
		documenti_articoli.nome,
		documenti_articoli.id_account_inserimento,
		documenti_articoli.id_account_aggiornamento,
		concat(
			documenti_articoli.data,
			' / ',
			tipologie_documenti.sigla,
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
		WHERE tipologie_documenti.id = 1
;

--| 202206160200
CREATE OR REPLACE VIEW `righe_fatture_passive_view` AS
       SELECT
		documenti_articoli.id,
		documenti_articoli.id_genitore,
		documenti_articoli.id_tipologia,
		tipologie_documenti.nome AS tipologia,
		documenti_articoli.ordine,
		documenti_articoli.id_documento,
        concat(
			tipologie_documenti.sigla,
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
		documenti_articoli.id_mastro_provenienza,
		m1.nome AS mastro_provenienza,
		documenti_articoli.id_mastro_destinazione,
		m2.nome AS mastro_destinazione,
		documenti_articoli.id_udm,
		documenti_articoli.quantita,
		documenti_articoli.id_listino,
		listini.id_valuta,
		valute.utf8 AS valuta,
		documenti_articoli.importo_netto_totale,
		documenti_articoli.sconto_percentuale,
		documenti_articoli.sconto_valore,
		documenti_articoli.id_matricola,
		matricole.matricola AS matricola,
		documenti_articoli.nome,
		documenti_articoli.id_account_inserimento,
		documenti_articoli.id_account_aggiornamento,
		concat(
			documenti_articoli.data,
			' / ',
			tipologie_documenti.sigla,
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
		WHERE tipologie_documenti.id = 11
;

--| 202206160210
CREATE OR REPLACE VIEW `righe_proforma_view` AS
        SELECT
		documenti_articoli.id,
		documenti_articoli.id_genitore,
		documenti_articoli.id_tipologia,
		tipologie_documenti.nome AS tipologia,
		documenti_articoli.ordine,
		documenti_articoli.id_documento,
        concat(
			tipologie_documenti.sigla,
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
		documenti_articoli.id_mastro_provenienza,
		m1.nome AS mastro_provenienza,
		documenti_articoli.id_mastro_destinazione,
		m2.nome AS mastro_destinazione,
		documenti_articoli.id_udm,
		documenti_articoli.quantita,
		documenti_articoli.id_listino,
		listini.id_valuta,
		valute.utf8 AS valuta,
		documenti_articoli.importo_netto_totale,
		documenti_articoli.sconto_percentuale,
		documenti_articoli.sconto_valore,
		documenti_articoli.id_matricola,
		matricole.matricola AS matricola,
		documenti_articoli.nome,
		documenti_articoli.id_account_inserimento,
		documenti_articoli.id_account_aggiornamento,
		concat(
			documenti_articoli.data,
			' / ',
			tipologie_documenti.sigla,
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
		WHERE tipologie_documenti.se_pro_forma = 1
;

--| 202206160220
INSERT INTO `tipologie_documenti` (`id`, `id_genitore`, `ordine`, `codice`, `numerazione`, `nome`, `sigla`,`html_entity`, `font_awesome`, `se_fattura`, `se_nota_credito`, `se_trasporto`, `se_pro_forma`, `se_offerta`, `se_ordine`, `se_ricevuta`, `stampa_xml`, `stampa_pdf`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'TD01',	'F',	'fattura',	'fatt.', NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	'TD01',	'F',	'fattura accompagnatoria', 'fatt. acc.',	NULL,	NULL,	1,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	NULL,	NULL,	'TD04',	'F',	'nota di credito',	'n. di credito', NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(4,	NULL,	NULL,	NULL,	'T',	'documento di trasporto', 'DDT',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(5,	NULL,	NULL,	NULL,	'P',	'pro forma',	'profroma',NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(6,	NULL,	NULL,	NULL,	'O',	'offerta',	'off.', NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(7,	NULL,	NULL,	NULL,	'E',	'ordine', 'ord.',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(8,	NULL,	NULL,	NULL,	'R',	'ricevuta',	'ric.',NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(9,	NULL,	NULL,	NULL,	'S',	'scontrino',	'scontr.',NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(10,	NULL,	NULL,	NULL,	'G',	'documento di ritiro',	'doc. di ritiro', NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(11,	NULL,	NULL,	NULL,	'H',	'documento di consegna', 'doc. di consegna',NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(12,	NULL,	NULL,	NULL,	'I',	'documento di reso', 'doc. di reso',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL)
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
	se_ricevuta= VALUES(se_ricevuta);

--| 202206160221
CREATE TABLE IF NOT EXISTS `tipologie_zone` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202206160222
ALTER TABLE `tipologie_zone`
	ADD PRIMARY KEY (`id`),
  	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `nome` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`);

--| 202206160223
ALTER TABLE `tipologie_zone` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202206160224
ALTER TABLE `tipologie_zone`
    ADD CONSTRAINT `tipologie_zone_ibfk_01_nofollow`            FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_zone` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_zone_ibfk_98_nofollow`            FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_zone_ibfk_99_nofollow`            FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202206160225
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_zone_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_zone_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_zone.id_genitore,
				tipologie_zone.nome
			FROM tipologie_zone
			WHERE tipologie_zone.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 202206160226
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_zone_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 int( 11 ) -> l'id dell'oggetto da cercare nel path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_zone_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_zone.id_genitore
			FROM tipologie_zone
			WHERE tipologie_zone.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 202206160227
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_zone_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_zone_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_zone.id_genitore,
				tipologie_zone.id
			FROM tipologie_zone
			WHERE tipologie_zone.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 202206160228
CREATE OR REPLACE VIEW `tipologie_zone_view` AS
	SELECT
		tipologie_zone.id,
		tipologie_zone.id_genitore,
		tipologie_zone.ordine,
		tipologie_zone.nome,
		tipologie_zone.html_entity,
		tipologie_zone.font_awesome,
		tipologie_zone.id_account_inserimento,
		tipologie_zone.id_account_aggiornamento,
		tipologie_zone_path( tipologie_zone.id ) AS __label__
	FROM tipologie_zone
;

--| 202206160230
CREATE TABLE IF NOT EXISTS `zone` (
`id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
    `id_tipologia` int(11) DEFAULT NULL,
  `nome` char(64) NOT NULL,
    `note` text,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202206160240
CREATE TABLE IF NOT EXISTS `zone_cap` (
`id` int(11) NOT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_zona` int(11) NOT NULL,
  `cap` char(8) NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202206160250
CREATE TABLE IF NOT EXISTS `zone_indirizzi` (
`id` int(11) NOT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_zona` int(11) NOT NULL,
  `id_indirizzo` int(11) NOT NULL,  
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202206160260
CREATE TABLE IF NOT EXISTS `zone_provincie` (
`id` int(11) NOT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_zona` int(11) NOT NULL,
  `id_provincia` int(11) NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202206160270
CREATE TABLE IF NOT EXISTS `zone_stati` (
`id` int(11) NOT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_zona` int(11) NOT NULL,
  `id_stato` int(11) NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202206160280
ALTER TABLE `zone`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `nome` (`nome`),
    ADD KEY `id_tipologia` (`id_tipologia`), 
	ADD KEY `indice` (`id`,`id_genitore`,`nome`, `id_tipologia`),
    ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `id_genitore` (`id_genitore`);

--| 202206160290
ALTER TABLE `zone` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202206160300
ALTER TABLE `zone_cap`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_zona` (`id_zona`),
	ADD UNIQUE KEY `unica` (`id_zona`,`cap`),
    ADD KEY `ordine` (`ordine`),	
    	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`ordine`, `id_zona`,`cap`)

--| 202206160310
ALTER TABLE `zone_cap` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202206160320
ALTER TABLE `zone_indirizzi`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_zona`,`id_indirizzo`), 
	ADD KEY `id_indirizzo` (`id_indirizzo`), 
	ADD KEY `ordine` (`ordine`),	
    	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`ordine`, `id_zona`,`id_indirizzo`);

--| 202206160330
ALTER TABLE `zone_indirizzi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202206160340

ALTER TABLE `zone_provincie`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_zona`,`id_provincia`), 
	ADD KEY `id_provincia` (`id_provincia`), 
	ADD KEY `ordine` (`ordine`),	
    	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_zona`,`id_provincia`,`ordine`);

--| 202206160350
ALTER TABLE `zone_provincie` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202206160360
ALTER TABLE `zone_stati`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_zona`,`id_stato`), 
	ADD KEY `ordine` (`ordine`),	
	ADD KEY `id_stato` (`id_stato`),
    ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),	
	ADD KEY `indice` (`id`,`id_zona`,`id_stato`,`ordine`);

--| 202206160370
ALTER TABLE `zone_stati` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202206160380
ALTER TABLE `zone`
    ADD CONSTRAINT `zone_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `zone` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `zone_ibfk_02_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_zone` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `zone_ibfk_98_nofollow`   FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `zone_ibfk_99_nofollow`   FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202206160390
ALTER TABLE `zone_cap`
	ADD CONSTRAINT `zone_cap_ibfk_01` FOREIGN KEY (`id_zona`) REFERENCES `zone` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
 	ADD CONSTRAINT `zone_cap_ibfk_98_nofollow`   FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `zone_cap_ibfk_99_nofollow`   FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;
    
--| 202206160400
ALTER TABLE `zone_indirizzi`
    ADD CONSTRAINT `zone_indirizzi_ibfk_01` FOREIGN KEY (`id_zona`) REFERENCES `zone` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `zone_indirizzi_ibfk_02` FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `zone_indirizzi_ibfk_98_nofollow`   FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `zone_indirizzi_ibfk_99_nofollow`   FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202206160410
ALTER TABLE `zone_provincie`
    ADD CONSTRAINT `zone_provincie_ibfk_01` FOREIGN KEY (`id_zona`) REFERENCES `zone` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `zone_provincie_ibfk_02_nofollow` FOREIGN KEY (`id_provincia`) REFERENCES `provincie` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `zone_provincie_ibfk_98_nofollow`   FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `zone_provincie_ibfk_99_nofollow`   FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;
   
--| 202206160420
ALTER TABLE `zone_stati`
    ADD CONSTRAINT `zone_stati_ibfk_01` FOREIGN KEY (`id_zona`) REFERENCES `zone` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `zone_stati_ibfk_02_nofollow` FOREIGN KEY (`id_stato`) REFERENCES `stati` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `zone_stati_ibfk_98_nofollow`   FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `zone_stati_ibfk_99_nofollow`   FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202206160430
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `zone_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT zone_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				zone.id_genitore,
				zone.nome
			FROM zone
			WHERE zone.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 202206160440
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `zone_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 int( 11 ) -> l'id dell'oggetto da cercare nel path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT zone_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				zone.id_genitore
			FROM zone
			WHERE zone.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 202206160450
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `zone_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT zone_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				zone.id_genitore,
				zone.id
			FROM zone
			WHERE zone.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 202206160460
CREATE OR REPLACE VIEW zone_view AS
	SELECT
		zone.id,
		zone.id_genitore,
		zone.id_tipologia,
		tipologie_zone.nome AS tipologia,
		zone.nome,
		zone.id_account_inserimento,
		zone.id_account_aggiornamento,
		zone_path( zone.id ) AS __label__
	FROM zone
		LEFT JOIN tipologie_zone ON tipologie_zone.id = zone.id_tipologia
;

--| 202206160473
CREATE OR REPLACE VIEW zone_cap_view AS
	SELECT
		zone_cap.id,
		zone_cap.cap,
		zone_cap.id_zona,
		zone_cap.ordine,
		zone_cap.id_account_inserimento,
		zone_cap.id_account_aggiornamento,
		concat(zone_cap.cap, ' - ', zone_cap.id_zona) AS __label__
	FROM zone_cap
;

--| 202206160480
CREATE OR REPLACE VIEW zone_indirizzi_view AS
	SELECT
		zone_indirizzi.id,
		zone_indirizzi.id_indirizzo,
		zone_indirizzi.id_zona,
		zone_indirizzi.ordine,
		zone_indirizzi.id_account_inserimento,
		zone_indirizzi.id_account_aggiornamento,
		concat(zone_indirizzi.id_indirizzo, ' - ', zone_indirizzi.id_zona) AS __label__
	FROM zone_indirizzi
; 

--| 202206160490
CREATE OR REPLACE VIEW zone_provincie_view AS
	SELECT
		zone_provincie.id,
		zone_provincie.id_provincia,
		zone_provincie.id_zona,
		zone_provincie.ordine,
		zone_provincie.id_account_inserimento,
		zone_provincie.id_account_aggiornamento,
		concat(zone_provincie.id_provincia, ' - ', zone_provincie.id_zona) AS __label__
	FROM zone_provincie
; 

--| 202206160500
CREATE OR REPLACE VIEW zone_stati_view AS
	SELECT
		zone_stati.id,
		zone_stati.id_stato,
		zone_stati.id_zona,
		zone_stati.ordine,
		zone_stati.id_account_inserimento,
		zone_stati.id_account_aggiornamento,
		concat(zone_stati.id_stato, ' - ', zone_stati.id_zona) AS __label__
	FROM zone_stati
; 

--| 202206160510
UPDATE `tipologie_documenti` SET `se_ordine` = '1' WHERE `id` = '7';

--| 202206160520
--| 202206160530
--| 202206160540


--| FINE