-- 2026-11-03 — viste dell'anagrafica al canone: le relazioni dell'anagrafica, consensi dei moduli, url
--
-- Ordine di WEB03 del 03/11/2026, via Fabio; secondo gruppo dopo _202611031600.viste.geografia.sql, stesso criterio.
-- Le viste vive sono rimaste indietro rispetto al file base _090000999999.views.sql perche' i loro blocchi stanno sotto
-- il livello di patch dei database esistenti: mancano p.es. ordine e i nomi di anagrafica_categorie_view, ateco di anagrafica_settori_view, i dati del consenso di
-- consensi_moduli_view, username e password di url_view, note di immobili_anagrafica_view e progetti_anagrafica_view.
-- Su ognuno dei dieci database dei deploy letti da web03 la vista viva ha solo colonne del canone e il SELECT del canone
-- gira con LIMIT 0 ( viste-esatte.py, var/20261103-viste-ritardo/ di glisweb ): la patch aggiunge colonne e non ne toglie.
-- Nessuna query, standard o dei progetti, mette queste viste in JOIN con le colonne nuove non qualificate ( join.py ).
--
-- Fuori da questo gruppo, anche se in ritardo su crmeurosnodi: anagrafica_view. bernispa e utensilerialughese la
-- ridefiniscono di proposito con patch loro ( __label__, colonne delle statiche ), con le stesse colonne del canone:
-- rifarla dal file base con un id piu' alto gli toglierebbe la personalizzazione. Va portata al canone deploy per
-- deploy, o promuovendo prima a monte quello che i progetti hanno fatto meglio. Il suo blocco, 202611031700, e' stato
-- tolto il 03/11 prima che la patch fosse applicata fuori da glisweb.
--
-- Un blocco per vista, con la definizione del file base copiata com'e'.
--
-- IDEMPOTENTE: CREATE OR REPLACE VIEW.

-- | 202611031701

-- anagrafica_categorie_view
CREATE OR REPLACE VIEW anagrafica_categorie_view AS           --
	SELECT                                                    --
		anagrafica_categorie.id,                              --
		anagrafica_categorie.ordine,                          --
		anagrafica_categorie.id_anagrafica,                   --
		coalesce(                                         	  --
			a1.denominazione,                             	  --
			concat( a1.cognome, ' ', a1.nome ),           	  --
			''                                            	  --
		) AS anagrafica,                                      --
		anagrafica_categorie.id_categoria,                    --
		categorie_anagrafica_path(                        	  --
			anagrafica_categorie.id_categoria             	  --
		) AS categoria,                                       --
		anagrafica_categorie.id_account_inserimento,          --
		anagrafica_categorie.id_account_aggiornamento,        --
		concat(                                               --
			coalesce(                                         --
                a1.denominazione,                             --
                concat( a1.cognome, ' ', a1.nome ),           --
                ''                                            --
            ),                                                --
			' / ',                                            --
			categorie_anagrafica_path(                        --
                anagrafica_categorie.id_categoria             --
            )                                                 --
		) AS __label__                                        -- etichetta per le tendine e le liste
	FROM anagrafica_categorie                                 --
		LEFT JOIN anagrafica AS a1                            --
            ON a1.id = anagrafica_categorie.id_anagrafica     --
;

-- | 202611031702

-- anagrafica_certificazioni_view
CREATE OR REPLACE VIEW `anagrafica_certificazioni_view` AS
	SELECT
		anagrafica_certificazioni.id,
		anagrafica_certificazioni.id_anagrafica,
		coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ) AS anagrafica,
		anagrafica_certificazioni.id_certificazione,
		certificazioni.nome AS certificazione,
		anagrafica_certificazioni.id_emittente,
		coalesce( emittente.denominazione , concat( emittente.cognome, ' ', emittente.nome ), '' ) AS emittente,
		anagrafica_certificazioni.nome,
		anagrafica_certificazioni.codice,
		anagrafica_certificazioni.data_emissione,
		anagrafica_certificazioni.data_scadenza,
		from_unixtime( anagrafica_certificazioni.timestamp_inserimento, '%Y-%m-%d %H:%i' ) AS data_ora_inserimento,
		concat(
			coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ),
			' / ',
			certificazioni.nome,
			' - ',
			anagrafica_certificazioni.codice
		) AS __label__
	FROM anagrafica_certificazioni
		INNER JOIN anagrafica ON anagrafica.id = anagrafica_certificazioni.id_anagrafica
		LEFT JOIN anagrafica AS emittente ON emittente.id = anagrafica_certificazioni.id_emittente
		LEFT JOIN certificazioni ON certificazioni.id = anagrafica_certificazioni.id_certificazione		
;

-- | 202611031703

-- anagrafica_consensi_view
CREATE OR REPLACE VIEW `anagrafica_consensi_view` AS
	SELECT
		anagrafica_consensi.id,
		anagrafica_consensi.id_account,
		anagrafica_consensi.id_anagrafica,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		anagrafica_consensi.id_mail,
		mail.indirizzo AS mail,
		anagrafica_consensi.id_consenso,
		anagrafica_consensi.se_prestato,
		anagrafica_consensi.timestamp_consenso,
		anagrafica_consensi.id_account_inserimento,
		anagrafica_consensi.id_account_aggiornamento,
		concat( 'consenso per ', anagrafica_consensi.id_consenso, ' di ', coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), mail.indirizzo, '' ) ) AS __label__
	FROM anagrafica_consensi
		LEFT JOIN anagrafica AS a1 ON a1.id = anagrafica_consensi.id_anagrafica
		LEFT JOIN mail ON mail.id = anagrafica_consensi.id_mail
;

-- | 202611031704

-- anagrafica_settori_view
CREATE OR REPLACE VIEW `anagrafica_settori_view` AS
	SELECT
		anagrafica_settori.id,
		anagrafica_settori.id_anagrafica,
		anagrafica_settori.id_settore,
		settori.ateco,
		settori.nome AS settore,
		anagrafica_settori.ordine,
		anagrafica_settori.id_account_inserimento,
		anagrafica_settori.id_account_aggiornamento,
		concat(
			coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ),
			' / ',
			concat_ws( ' ', settori.ateco, coalesce( settori.soprannome, settori.nome ) )
		) AS __label__
	FROM anagrafica_settori
		LEFT JOIN anagrafica ON anagrafica.id = anagrafica_settori.id_anagrafica
		LEFT JOIN settori ON settori.id = anagrafica_settori.id_settore
;

-- | 202611031705

-- consensi_moduli_view
CREATE OR REPLACE VIEW `consensi_moduli_view` AS
	SELECT
		consensi_moduli.id,
		consensi_moduli.ordine,
		consensi_moduli.nome,
		consensi_moduli.id_lingua,
		lingue.ietf AS lingua,
		consensi_moduli.id_consenso,
		consensi.codice AS codice_consenso,
		consensi.nome AS consenso,
		consensi_moduli.modulo,
		consensi_moduli.azione,
		consensi_moduli.informativa,
		consensi_moduli.pagina,
		consensi_moduli.note,
		consensi_moduli.se_richiesto,
		consensi_moduli.id_account_inserimento,
		consensi_moduli.id_account_aggiornamento,
		concat_ws( ' ', consensi_moduli.modulo, lingue.ietf, consensi.nome ) AS __label__
	FROM consensi_moduli
		LEFT JOIN consensi ON consensi.id = consensi_moduli.id_consenso
		LEFT JOIN lingue ON lingue.id = consensi_moduli.id_lingua
;

-- | 202611031706

-- url_view
CREATE OR REPLACE VIEW url_view AS                            --
	SELECT                                                    --
		url.id,                                               --
		url.id_tipologia,                                     --
		tipologie_url.nome AS tipologia,                      -- nome della tipologia
		url.id_anagrafica,                                    --
		coalesce(                                             --
            a1.denominazione,                                 --
            concat( a1.cognome, ' ', a1.nome ),               --
            ''                                                --
        ) AS anagrafica,                                      -- denominazione o cognome e nome dell'anagrafica
		url.url,                                              --
		url.nome,                                             --
		url.username,                                         --
		url.password,                                         --
		url.id_account_inserimento,                           --
		url.id_account_aggiornamento,                         --
		concat_ws(                                            --
			' ',                                              --
			url.url,                                          --
			tipologie_url.nome,                               --
			coalesce(                                         --
                a1.denominazione,                             --
                concat( a1.cognome, ' ', a1.nome ),           --
                ''                                            --
            )                                                 --
		) AS __label__                                        -- etichetta per le tendine e le liste
	FROM url                                                  --
		LEFT JOIN anagrafica AS a1                            --
            ON a1.id = url.id_anagrafica                      --
		LEFT JOIN tipologie_url                               --
            ON tipologie_url.id = url.id_tipologia            --
;

-- | 202611031707

-- immobili_anagrafica_view
CREATE OR REPLACE VIEW `immobili_anagrafica_view` AS
	SELECT
		immobili_anagrafica.id,
		immobili_anagrafica.ordine,
		immobili_anagrafica.id_immobile,
		immobili_anagrafica.id_anagrafica,
		coalesce( anagrafica.denominazione, concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ) AS anagrafica,
		immobili_anagrafica.id_ruolo,
		ruoli_anagrafica.nome AS ruolo,
		immobili_anagrafica.note,
		immobili_anagrafica.id_account_inserimento,
		immobili_anagrafica.id_account_aggiornamento,
		concat_ws(
			' / ',
			immobili_anagrafica.id_immobile,
			coalesce( anagrafica.denominazione, concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ),
			ruoli_anagrafica.nome
		) AS __label__
	FROM immobili_anagrafica
		LEFT JOIN anagrafica ON anagrafica.id = immobili_anagrafica.id_anagrafica
		LEFT JOIN ruoli_anagrafica ON ruoli_anagrafica.id = immobili_anagrafica.id_ruolo
;

-- | 202611031708

-- progetti_anagrafica_view
CREATE OR REPLACE VIEW progetti_anagrafica_view AS
	SELECT
		progetti_anagrafica.id,
		progetti_anagrafica.ordine,
		progetti_anagrafica.id_progetto,
		progetti.nome AS progetto,
		progetti_anagrafica.id_anagrafica,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		progetti_anagrafica.id_ruolo,
		ruoli_anagrafica.nome as ruolo,
		progetti_anagrafica.note,
		progetti_anagrafica.se_sostituto,
		progetti_anagrafica.id_account_inserimento,
		progetti_anagrafica.id_account_aggiornamento,
 		concat_ws(
			' ',
			progetti.nome,
			coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ),
			ruoli_anagrafica.nome
		) AS __label__
	FROM progetti_anagrafica
		LEFT JOIN progetti ON progetti.id = progetti_anagrafica.id_progetto
		LEFT JOIN anagrafica AS a1 ON a1.id = progetti_anagrafica.id_anagrafica
		LEFT JOIN ruoli_anagrafica ON ruoli_anagrafica.id = progetti_anagrafica.id_ruolo
;

-- | FINE
