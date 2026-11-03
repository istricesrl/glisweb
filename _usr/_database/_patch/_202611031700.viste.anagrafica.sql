-- 2026-11-03 — viste dell'anagrafica al canone: anagrafica, le sue relazioni, consensi dei moduli, url
--
-- Ordine di WEB03 del 03/11/2026, via Fabio; secondo gruppo dopo _202611031600.viste.geografia.sql, stesso criterio.
-- Le viste vive sono rimaste indietro rispetto al file base _090000999999.views.sql perche' i loro blocchi stanno sotto
-- il livello di patch dei database esistenti: mancano p.es. id_tipologia e id_ranking di anagrafica_view ( crmeurosnodi ),
-- ordine e i nomi di anagrafica_categorie_view, ateco di anagrafica_settori_view, i dati del consenso di
-- consensi_moduli_view, username e password di url_view, note di immobili_anagrafica_view e progetti_anagrafica_view.
-- Su ognuno dei dieci database dei deploy letti da web03 la vista viva ha solo colonne del canone e il SELECT del canone
-- gira con LIMIT 0 ( viste-esatte.py, var/20261103-viste-ritardo/ di glisweb ): la patch aggiunge colonne e non ne toglie.
-- Nessuna query, standard o dei progetti, mette queste viste in JOIN con le colonne nuove non qualificate ( join.py ).
-- anagrafica_view ha la statica anagrafica_view_static: refreshStaticView() copia solo le colonne comuni, quindi le
-- colonne nuove nella vista non la rompono.
--
-- Un blocco per vista, con la definizione del file base copiata com'e'.
--
-- IDEMPOTENTE: CREATE OR REPLACE VIEW.

-- | 202611031700

-- anagrafica_view
CREATE OR REPLACE VIEW `anagrafica_view` AS
	SELECT
		`anagrafica`.`id` AS `id`,
		`anagrafica`.`id_tipologia` AS `id_tipologia`,
		`tipologie_anagrafica`.`nome` AS `tipologia`,
		`anagrafica`.`codice` AS `codice`,
		`anagrafica`.`riferimento` AS `riferimento`,
		`anagrafica`.`nome` AS `nome`,
		`anagrafica`.`cognome` AS `cognome`,
		`anagrafica`.`denominazione` AS `denominazione`,
		`anagrafica`.`soprannome` AS `soprannome`,
		`anagrafica`.`sesso` AS `sesso`,
		`anagrafica`.`codice_fiscale` AS `codice_fiscale`,
		`anagrafica`.`partita_iva` AS `partita_iva`,
		`anagrafica`.`id_ranking` AS `id_ranking`,
		`ranking`.`nome` AS `ranking`,
		`anagrafica`.`recapiti` AS `recapiti`,
		NULL AS `id_stato`,
		NULL AS `id_provincia`,
		max(`categorie_anagrafica`.`se_prospect`) AS `se_prospect`,
		max(`categorie_anagrafica`.`se_lead`) AS `se_lead`,
		max(`categorie_anagrafica`.`se_cliente`) AS `se_cliente`,
		max(`categorie_anagrafica`.`se_fornitore`) AS `se_fornitore`,
		max(`categorie_anagrafica`.`se_produttore`) AS `se_produttore`,
		max(`categorie_anagrafica`.`se_collaboratore`) AS `se_collaboratore`,
		max(`categorie_anagrafica`.`se_interno`) AS `se_interno`,
		max(`categorie_anagrafica`.`se_esterno`) AS `se_esterno`,
		max(`categorie_anagrafica`.`se_commerciale`) AS `se_commerciale`,
		max(`categorie_anagrafica`.`se_concorrente`) AS `se_concorrente`,
		max(`categorie_anagrafica`.`se_gestita`) AS `se_gestita`,
		max(`categorie_anagrafica`.`se_amministrazione`) AS `se_amministrazione`,
		max(`categorie_anagrafica`.`se_notizie`) AS `se_notizie`,
		group_concat(distinct `categorie_anagrafica_path`(`categorie_anagrafica`.`id`) separator ' | ') AS `categorie`,
		group_concat(distinct `telefoni`.`numero` separator ' | ') AS `telefoni`,
		group_concat(distinct `mail`.`indirizzo` separator ' | ') AS `mail`,
		`anagrafica`.`anno_nascita` AS `anno_nascita`,
		`anagrafica`.`mese_nascita` AS `mese_nascita`,
		`anagrafica`.`giorno_nascita` AS `giorno_nascita`,
		concat_ws('-',`anagrafica`.`anno_nascita`,lpad(`anagrafica`.`mese_nascita`,2,'0'),lpad(`anagrafica`.`giorno_nascita`,2,'0')) AS `data_nascita`,
		`anagrafica`.`id_comune_nascita` AS `id_comune_nascita`,
		`anagrafica`.`data_archiviazione` AS `data_archiviazione`,
		`anagrafica`.`id_account_inserimento` AS `id_account_inserimento`,
		`anagrafica`.`timestamp_inserimento` AS `timestamp_inserimento`,
		`anagrafica`.`id_account_aggiornamento` AS `id_account_aggiornamento`,
		`anagrafica`.`timestamp_aggiornamento` AS `timestamp_aggiornamento`,
		concat_ws(' ',`anagrafica`.`codice`,coalesce(`anagrafica`.`soprannome`,`anagrafica`.`denominazione`,concat_ws(' ',coalesce(`anagrafica`.`cognome`,''),coalesce(`anagrafica`.`nome`,'')),'')) AS `__label__`
	FROM
		((((((`anagrafica`
		left join `tipologie_anagrafica` on(`tipologie_anagrafica`.`id` = `anagrafica`.`id_tipologia`))
		left join `ranking` on(`ranking`.`id` = `anagrafica`.`id_ranking`))
		left join `anagrafica_categorie` on(`anagrafica_categorie`.`id_anagrafica` = `anagrafica`.`id`))
		left join `categorie_anagrafica` on(`categorie_anagrafica`.`id` = `anagrafica_categorie`.`id_categoria`))
		left join `telefoni` on(`telefoni`.`id_anagrafica` = `anagrafica`.`id`))
		left join `mail` on(`mail`.`id_anagrafica` = `anagrafica`.`id`))
		group by `anagrafica`.`id`
;

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
