--
-- VISTE
-- =====
-- questo file contiene le query per la creazione delle viste
-- 
-- TODO documentare
--

-- | 090000000100

-- account_view
CREATE OR REPLACE VIEW account_view AS                        --
	SELECT                                                    --
		account.id,                                           --
		account.id_anagrafica,                                --
		coalesce(                                             --
            anagrafica.denominazione,                         --
            concat(                                           --
                anagrafica.cognome, ' ', anagrafica.nome      --
            ), NULL                                           --
        ) AS anagrafica,                                      -- denominazione o cognome e nome dell'anagrafica
		account.id_mail,                                      --
		mail.indirizzo AS mail,                               -- indirizzo email
		account.id_affiliazione,                              --
		contratti.codice_affiliazione,                        -- codice affiliazione
		account.username,                                     --
		account.password,                                     --
		account.se_attivo,                                    --
		account.token,                                        --
		account.timestamp_login,                              --
		account.timestamp_cambio_password,                    --
		group_concat(                                         --
            gruppi.nome ORDER BY gruppi.id SEPARATOR '|'      --
        ) AS gruppi,                                          -- nomi dei gruppi separati da |
		concat(                                               --
            '|', group_concat(                                --
                gruppi.id ORDER BY gruppi.id SEPARATOR '|'    --
            ), '|'                                            --
        ) AS id_gruppi,                                       -- id dei gruppi separati da | e racchiusi tra |
		group_concat(                                         --
			DISTINCT                                          --
			concat(                                           --
                aga.entita,                                   --
                '#',                                          --
                aga.id_gruppo                                 --
            )                                                 --
			ORDER BY                                          --
                aga.entita,                                   --
                aga.id_gruppo                                 --
			SEPARATOR '|'                                     --
        ) AS id_gruppi_attribuzione,                          -- entita#id_gruppo separati da |
		account.id_account_inserimento,                       --
		account.id_account_aggiornamento,                     --
		account.username AS __label__                         -- etichetta per le tendine e le liste
	FROM account                                              --
		LEFT JOIN anagrafica                                  --
            ON anagrafica.id = account.id_anagrafica          --
		LEFT JOIN mail                                        --
            ON mail.id = account.id_mail                      --
		LEFT JOIN contratti                                   --
            ON contratti.id = account.id_affiliazione         --
		LEFT JOIN account_gruppi                              --
            ON account_gruppi.id_account = account.id         --
		LEFT JOIN account_gruppi_attribuzione AS aga          --
            ON aga.id_account = account.id                    --
		LEFT JOIN gruppi                                      --
            ON gruppi.id = account_gruppi.id_gruppo           --
	GROUP BY account.id                                       --
;                                                             --

-- | 090000000200

-- account_gruppi_view
CREATE OR REPLACE VIEW account_gruppi_view AS                 --
	SELECT                                                    --
		account_gruppi.id,                                    --
		account_gruppi.id_account,                            --
		account.username AS account,                          -- username dell'account
		account_gruppi.id_gruppo,                             --
		gruppi.nome AS gruppo,                                -- nome del gruppo
		account_gruppi.ordine,                                --
		account_gruppi.se_amministratore,                     --
		account_gruppi.id_account_inserimento,                --
		account_gruppi.id_account_aggiornamento,              --
		concat(                                               --
			account.username,                                 --
			' / ',                                            --
			gruppi.nome                                       --
		) AS __label__                                        -- etichetta per le tendine e le liste
	FROM account_gruppi                                       --
		LEFT JOIN account                                     --
            ON account.id = account_gruppi.id_account         --
		LEFT JOIN gruppi                                      --
            ON gruppi.id = account_gruppi.id_gruppo           --
;                                                             --

-- | 090000000300

-- account_gruppi_attribuzione_view
CREATE OR REPLACE VIEW account_gruppi_attribuzione_view AS
	SELECT
		aga.id,
		aga.id_account,
		aga.id_gruppo,
		aga.ordine,
		aga.entita,
		aga.id_account_inserimento,
		aga.id_account_aggiornamento,
		concat(
			account.username,
			' / ',
			gruppi.nome,
			' / ',
			aga.entita
		) AS __label__
	FROM account_gruppi_attribuzione AS aga
		LEFT JOIN account 
			ON account.id = aga.id_account
		LEFT JOIN gruppi 
			ON gruppi.id = aga.id_gruppo
;

-- | 090000000500

-- anagrafica_categorie_view
CREATE OR REPLACE VIEW anagrafica_categorie_view AS           --
	SELECT                                                    --
		anagrafica_categorie.id,                              --
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
;                                                             --

-- | 090000000601

-- anagrafica_certificazioni_view
-- tipologia: tabella gestita
-- verifica: 2022-02-03 11:12 Chiara GDL
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

-- | 090000000701

-- anagrafica_cittadinanze_view
-- tipologia: tabella gestita
-- verifica: 2021-05-20 21:47 Fabio Mosti
CREATE OR REPLACE VIEW `anagrafica_cittadinanze_view` AS
	SELECT
		anagrafica_cittadinanze.id,
		anagrafica_cittadinanze.id_anagrafica,
		anagrafica_cittadinanze.id_stato,
		anagrafica_cittadinanze.data_inizio,
		anagrafica_cittadinanze.data_fine,
		anagrafica_cittadinanze.id_account_inserimento,
		anagrafica_cittadinanze.id_account_aggiornamento,
		concat(
			coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ),
			' / ',
			stati.nome
		) AS __label__
	FROM anagrafica_cittadinanze
		INNER JOIN anagrafica ON anagrafica.id = anagrafica_cittadinanze.id_anagrafica
		INNER JOIN stati ON stati.id = anagrafica_cittadinanze.id_stato
;

-- | 090000000801

-- anagrafica_consensi_view
-- tipologia: tabella gestita
-- verifica: 2022-08-23 11:12 Chiara GDL
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

-- | 090000000900

-- anagrafica_indirizzi_view
CREATE OR REPLACE VIEW anagrafica_indirizzi_view AS           --
	SELECT                                                    --
		anagrafica_indirizzi.id,                              --
		anagrafica_indirizzi.id_anagrafica,                   --
		coalesce(                                             --
            a1.denominazione,                                 --
            concat(                                           --
                a1.cognome, ' ', a1.nome                      --
            ),                                                --
            ''                                                --
        ) AS anagrafica,                                      -- denominazione o cognome e nome dell'anagrafica
        a1.codice AS codice_anagrafica,                       -- codice dell'anagrafica
		anagrafica_indirizzi.id_indirizzo,                    --
		anagrafica_indirizzi.id_ruolo,                        --
		ri1.nome AS ruolo,                                    -- nome del ruolo dell'indirizzo
        anagrafica_indirizzi.interno,                         --
        anagrafica_indirizzi.indirizzo,                       --
        anagrafica_indirizzi.civico,                          --
        anagrafica_indirizzi.id_comune,                       --
        comuni.nome AS comune,                                -- nome del comune
        comuni.id_provincia AS id_provincia,                  -- chiave esterna per la provincia
        provincie.sigla AS sigla_provincia,                   -- sigla della provincia
        provincie.nome AS provincia,                          -- nome della provincia
        provincie.codice_istat AS codice_istat_provincia,     -- codice ISTAT della provincia
        comuni.codice_istat AS codice_istat_comune,           -- codice ISTAT del comune
        anagrafica_indirizzi.localita,                        --
        anagrafica_indirizzi.cap,                             --
        concat_ws(                                            --
            ' ',                                              --
            tipologie_indirizzi_path(                         --
                anagrafica_indirizzi.id_tipologia             --
            ),                                                -- tipologia dell'indirizzo
            anagrafica_indirizzi.indirizzo,                   --
            anagrafica_indirizzi.civico,                      --
            anagrafica_indirizzi.cap,                         --
            comuni.nome,                                      --
            provincie.sigla                                   --
        ) AS indirizzo_completo,                              -- indirizzo completo
        anagrafica_indirizzi.latitudine,                      --
        anagrafica_indirizzi.longitudine,                     --
        anagrafica_indirizzi.timestamp_geolocalizzazione,     --
        from_unixtime(                                        --
            anagrafica_indirizzi.timestamp_geolocalizzazione, --
            '%Y-%m-%d %H:%i'                                  --
        ) AS data_ora_geolocalizzazione,                      -- data e ora dell'ultima geolocalizzazione
		anagrafica_indirizzi.timestamp_elaborazione,          --
        from_unixtime(                                        --
            anagrafica_indirizzi.timestamp_elaborazione,      --
            '%Y-%m-%d %H:%i'                                  --
        ) AS data_ora_elaborazione,                           -- data e ora dell'ultima elaborazione
		anagrafica_indirizzi.id_account_inserimento,          --
		anagrafica_indirizzi.id_account_aggiornamento,        --
        concat(                                               --
            coalesce(                                         --
                a1.denominazione,                             --
                concat( a1.cognome, ' ', a1.nome ),           --
                ''                                            --
            ),                                                --
            ' - ',                                            --
            concat_ws(                                        --
                ' ',                                          --
                ri1.nome,                                     --
                anagrafica_indirizzi.indirizzo,               --
                anagrafica_indirizzi.civico,                  --
                comuni.nome,                                  --
                provincie.sigla,                              --
                anagrafica_indirizzi.cap                      --
            )                                                 --
        ) AS __label__                                        -- etichetta per le tendine e le liste
    FROM anagrafica_indirizzi                                 --
		INNER JOIN anagrafica AS a1                           --
            ON a1.id = anagrafica_indirizzi.id_anagrafica     --
		LEFT JOIN anagrafica_categorie AS ac1                 --
            ON ac1.id_anagrafica = a1.id                      --
		LEFT JOIN categorie_anagrafica AS ca1                 --
            ON ca1.id = ac1.id_categoria                      --
		LEFT JOIN ruoli_indirizzi AS ri1                      --
            ON ri1.id = anagrafica_indirizzi.id_ruolo         --
		LEFT JOIN tipologie_indirizzi AS ti1                  --
            ON ti1.id = anagrafica_indirizzi.id_tipologia     --
		LEFT JOIN comuni                                      --
            ON comuni.id = anagrafica_indirizzi.id_comune     --
		LEFT JOIN provincie                                   --
            ON provincie.id = comuni.id_provincia             --
    GROUP BY anagrafica_indirizzi.id                          --
;                                                             --

-- | 090000000941

-- anagrafica_progetti_view
CREATE OR REPLACE VIEW anagrafica_progetti_view AS
	SELECT
		anagrafica_progetti.id,
		anagrafica_progetti.id_anagrafica,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		anagrafica_progetti.id_progetto,
		progetti.nome AS progetto,
		anagrafica_progetti.id_ruolo,
		ruoli_progetti.nome as ruolo,
		anagrafica_progetti.ordine,
		anagrafica_progetti.se_attesa,
		anagrafica_progetti.id_account_inserimento,
		anagrafica_progetti.id_account_aggiornamento,
 		concat_ws(
			' ',
			progetti.nome,
			coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ),
			ruoli_progetti.nome
		) AS __label__
	FROM anagrafica_progetti
		LEFT JOIN anagrafica AS a1 ON a1.id = anagrafica_progetti.id_anagrafica
		LEFT JOIN progetti ON progetti.id = anagrafica_progetti.id_progetto
		LEFT JOIN ruoli_progetti ON ruoli_progetti.id = anagrafica_progetti.id_ruolo
;

-- | 090000000961

-- attesa_view
-- le righe di anagrafica_progetti in lista di attesa ( se_attesa ), per il modulo _0635.attesa;
-- ripristinata il 2026-09-30 dalla versione di prima del 02/03/2026
CREATE OR REPLACE VIEW attesa_view AS
	SELECT
		anagrafica_progetti.id,
		anagrafica_progetti.id_anagrafica,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		anagrafica_progetti.id_progetto,
		progetti.nome AS progetto,
		todo.data_programmazione AS data_lezione,
		todo.ora_inizio_programmazione AS ora_lezione,
		anagrafica_progetti.id_ruolo,
		ruoli_progetti.nome as ruolo,
		anagrafica_progetti.ordine,
		anagrafica_progetti.se_attesa,
		from_unixtime( anagrafica_progetti.timestamp_inserimento, '%Y-%m-%d %H:%i' ) AS data_ora_inserimento,
		anagrafica_progetti.id_account_inserimento,
		anagrafica_progetti.id_account_aggiornamento,
		concat_ws(
			' ',
			progetti.nome,
			coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ),
			ruoli_progetti.nome
		) AS __label__
	FROM anagrafica_progetti
		LEFT JOIN anagrafica AS a1 ON a1.id = anagrafica_progetti.id_anagrafica
		LEFT JOIN progetti ON progetti.id = anagrafica_progetti.id_progetto
		LEFT JOIN ruoli_progetti ON ruoli_progetti.id = anagrafica_progetti.id_ruolo
		LEFT JOIN todo ON todo.id = anagrafica_progetti.id_todo
	WHERE anagrafica_progetti.se_attesa IS NOT NULL
;

-- | 090000001000

-- anagrafica_view
-- estratta dal database e dichiarata qui il 2026-08-28: non era mai stata nei patch,
-- mentre anagrafica_view_static lo era gia'. E' quell'asimmetria ad aver permesso
-- alle due di divergere, rompendo la REPLACE che tiene allineata la statica.
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

-- | 090000001201

-- anagrafica_settori_view
-- tipologia: tabella gestita
-- verifica: 2021-05-23 15:35 Fabio Mosti
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
			concat_ws( ' ', settori.ateco, settori.nome )
		) AS __label__
	FROM anagrafica_settori
		LEFT JOIN anagrafica ON anagrafica.id = anagrafica_settori.id_anagrafica
		LEFT JOIN settori ON settori.id = anagrafica_settori.id_settore
;

-- il settore si etichetta con codice ATECO e nome, come in settori_view; il percorso completo ( settori_path ) è
-- troppo lungo per un'etichetta

-- | 090000001251

-- annunci_view
-- tipologia: tabella gestita
-- verifica: 2021-10-01 10:49 Fabio Mosti
CREATE OR REPLACE VIEW `annunci_view` AS
	SELECT
		annunci.id,
		annunci.id_tipologia,
		-- tipologie_annunci.nome AS tipologia, ...
		annunci.nome,
		group_concat( categorie_annunci.nome SEPARATOR '|' ) AS categorie,
		annunci.id_account_inserimento,
		annunci.id_account_aggiornamento,
		annunci.nome AS __label__
	FROM annunci
		-- LEFT JOIN tipologie_annunci ON tipologie_annunci.id = annunci.id_tipologia
		LEFT JOIN annunci_categorie ON annunci_categorie.id_annuncio = annunci.id
		LEFT JOIN categorie_annunci ON categorie_annunci.id = annunci_categorie.id_categoria
	GROUP BY annunci.id
;

-- | 090000001255

-- caratteristiche_prodotti
--
-- vista di compatibilita': fino al 01/10/2026 caratteristiche_prodotti era la tabella dell'albero dei prodotti, ora
-- l'albero sta in caratteristiche e questa vista lo espone con i nomi di colonna di allora, cosi' il codice dei
-- progetti che la legge o ci scrive ( anche con INSERT ... ON DUPLICATE KEY UPDATE ) continua a funzionare. Sta qui e
-- non accanto a caratteristiche_view perche' articoli_view, subito sotto, la usa
CREATE OR REPLACE VIEW `caratteristiche_prodotti` AS
	SELECT
		caratteristiche.id,
		caratteristiche.id_genitore,
		caratteristiche.nome,
		caratteristiche.font_awesome,
		caratteristiche.html_entity,
		caratteristiche.se_categorie_prodotti AS se_categoria,
		caratteristiche.se_prodotti AS se_prodotto,
		caratteristiche.se_articoli AS se_articolo,
		caratteristiche.id_account_inserimento,
		caratteristiche.timestamp_inserimento,
		caratteristiche.id_account_aggiornamento,
		caratteristiche.timestamp_aggiornamento
	FROM caratteristiche
;

-- | 090000001261

-- annunci_categorie_view
-- tipologia: tabella gestita
-- verifica: 2021-10-01 12:39 Fabio Mosti
CREATE OR REPLACE VIEW `annunci_categorie_view` AS
	SELECT
		annunci_categorie.id,
		annunci_categorie.id_annuncio,
		annunci.nome AS annuncio,
		annunci_categorie.id_categoria,
		categorie_annunci_path( annunci_categorie.id_categoria ) AS categoria,
		annunci_categorie.ordine,
		annunci_categorie.id_account_inserimento,
		annunci_categorie.id_account_aggiornamento,
		concat(
			annunci.nome,
			' / ',
			categorie_annunci_path( annunci_categorie.id_categoria )
		) AS __label__
	FROM annunci_categorie
		LEFT JOIN annunci ON annunci.id = annunci_categorie.id_annuncio
;

-- | 090000001300

-- articoli_view
CREATE OR REPLACE VIEW `articoli_view` AS
	SELECT
		-- PUBBLICAZIONE: SOTTOQUERY, NON JOIN ( 2026-10-04 )
		--
		-- prima erano due LEFT JOIN su pubblicazioni ( dell'articolo e del prodotto ): un articolo con
		-- piu' pubblicazioni usciva una volta per pubblicazione, e su glisweb la vista dava 7.920 righe
		-- per 132 articoli. La statica, che ha id come chiave primaria, non si riusciva piu' a
		-- riempire. Si prende la prima pubblicazione dell'articolo, se no la prima del prodotto.
		coalesce(
			( SELECT pa.id_tipologia FROM pubblicazioni AS pa WHERE pa.id_articolo = articoli.id ORDER BY pa.id LIMIT 1 ),
			( SELECT pp.id_tipologia FROM pubblicazioni AS pp WHERE pp.id_prodotto = articoli.id_prodotto ORDER BY pp.id LIMIT 1 )
		) AS id_tipologia_pubblicazione,
		( SELECT tp.nome FROM tipologie_pubblicazioni AS tp WHERE tp.id = coalesce(
				( SELECT pa.id_tipologia FROM pubblicazioni AS pa WHERE pa.id_articolo = articoli.id ORDER BY pa.id LIMIT 1 ),
				( SELECT pp.id_tipologia FROM pubblicazioni AS pp WHERE pp.id_prodotto = articoli.id_prodotto ORDER BY pp.id LIMIT 1 )
			) ) AS pubblicazione,
		-- TIPOLOGIA DI VOCE A LISTINO: SOTTOQUERY, NON JOIN
		--
		-- prima erano tre LEFT JOIN su articoli_caratteristiche piu' un max( CASE ... ) sotto il
		-- GROUP BY. Funziona, ma moltiplica le righe per le caratteristiche di ogni articolo, e
		-- quando quella tabella si riempie la vista non si regge piu': l'08/09/2026, con le 7.580
		-- righe arrivate dalla migrazione del catalogo, la vista e' passata da meno di un secondo
		-- a cinque. La sottoquery scalare da' lo stesso valore e non tocca la cardinalita'
		( SELECT tipo_voce.nome
			FROM articoli_caratteristiche AS ac_tipo
			INNER JOIN caratteristiche_prodotti AS tipo_voce ON tipo_voce.id = ac_tipo.id_caratteristica
			INNER JOIN caratteristiche_prodotti AS radice_tipo ON radice_tipo.id = tipo_voce.id_genitore
			WHERE ac_tipo.id_articolo = articoli.id
			AND radice_tipo.nome = 'TIPO DI VOCE A LISTINO'
			LIMIT 1
		) AS tipologia_listino,
		articoli.id,
		articoli.codice,
		articoli.id_prodotto,
		prodotti.nome AS prodotto,
		articoli.ordine,
		articoli.ean,
		articoli.isbn,
		articoli.codice_produttore,
		articoli.id_reparto,
		articoli.id_taglia,
		articoli.id_colore,
		articoli.id_periodicita,
		periodicita.nome AS periodicita,
		articoli.id_tipologia_rinnovo,
		tipologie_rinnovi.nome AS tipologia_rinnovo,
		articoli.larghezza,
		articoli.lunghezza,
		articoli.altezza,
		articoli.id_udm_dimensioni,
		udm_dimensioni.sigla AS udm_dimensioni,
		articoli.peso,
		articoli.id_udm_peso,
		udm_peso.sigla AS udm_peso,
		articoli.volume,
		articoli.id_udm_volume,
		udm_volume.sigla AS udm_volume,
		articoli.capacita,
		articoli.id_udm_capacita,
		udm_capacita.sigla AS udm_capacita,
		articoli.durata,
		articoli.id_udm_durata,
		udm_durata.sigla AS udm_durata,
		concat_ws(
			' ',
			prodotti.nome,
			nullif( articoli.nome, prodotti.nome ),
			coalesce(
				concat(
					concat_ws( 'x', articoli.larghezza, articoli.lunghezza, articoli.altezza ),
					udm_dimensioni.sigla
				),
				concat(
					articoli.peso,
					udm_peso.sigla
				),
				concat(
					articoli.volume,
					udm_volume.sigla
				),
				concat(
					articoli.capacita,
					udm_capacita.sigla
				),
				concat(
					articoli.durata,
					udm_durata.sigla
				),
				''
			)
		) AS nome,
		articoli.note,
		articoli.note_codifica,
		-- CATEGORIE E PREZZI: SOTTOQUERY, NON JOIN PIU' GROUP BY
		--
		-- stessa ragione della sottoquery di tipologia_listino qui sopra, ma il guasto era peggiore:
		-- il GROUP BY impedisce all'ottimizzatore di spingere dentro la vista una condizione
		-- espressa con un SEGNAPOSTO, e il framework interroga sempre con statement preparati.
		-- Misurato l'08/09/2026: SELECT * ... WHERE id = ? passava da 2,36 secondi a 0,032, e un
		-- elenco di venti righe da 2,76 a 0,26 - perche' categorie_prodotti_path(), che e' una
		-- funzione ricorsiva, adesso viene chiamata solo per le righe che si mostrano davvero e
		-- non per tutte quelle della vista.
		--
		-- il coalesce a stringa vuota NON e' pignoleria: con la LEFT JOIN un articolo senza
		-- categorie dava '' e non NULL, perche' categorie_prodotti_path( NULL ) torna '' e il
		-- group_concat trovava comunque una riga. id_categorie invece resta NULL come prima.
		( SELECT group_concat( DISTINCT pc.id_categoria SEPARATOR ' | ' )
			FROM prodotti_categorie AS pc
			WHERE pc.id_prodotto = articoli.id_prodotto
		) AS id_categorie,
		coalesce( ( SELECT group_concat( DISTINCT categorie_prodotti_path( pc.id_categoria ) SEPARATOR ' | ' )
			FROM prodotti_categorie AS pc
			WHERE pc.id_prodotto = articoli.id_prodotto
		), '' ) AS categorie,
		coalesce( ( SELECT group_concat( DISTINCT concat_ws( ' ', l.nome, v.iso4217, format( p.prezzo, 2, 'it_IT' ) ) SEPARATOR ' | ' )
			FROM prezzi AS p
			LEFT JOIN listini AS l ON l.id = p.id_listino
			LEFT JOIN valute AS v ON v.id = l.id_valuta
			WHERE p.id_articolo = articoli.id
		), '' ) AS prezzi,
		coalesce( articoli.data_archiviazione, prodotti.data_archiviazione ) AS data_archiviazione,
		articoli.note_archiviazione,
		articoli.id_account_inserimento,                      --
		articoli.timestamp_inserimento,                       --
		articoli.id_account_aggiornamento,                    --
		articoli.timestamp_aggiornamento,                     --
		concat_ws(
			' ',
			articoli.ean,
			articoli.codice,
			'/',
			prodotti.nome,
			nullif( articoli.nome, prodotti.nome ),
			coalesce(
				concat(
					articoli.larghezza, 'x', articoli.lunghezza, 'x', articoli.altezza,
					udm_dimensioni.sigla
				),
				concat(
					articoli.peso,
					udm_peso.sigla
				),
				concat(
					articoli.volume,
					udm_volume.sigla
				),
				concat(
					articoli.capacita,
					udm_capacita.sigla
				),
				concat(
					articoli.durata,
					udm_durata.sigla
				),
				''
			)
		) AS __label__
	FROM articoli
		LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
		LEFT JOIN udm AS udm_dimensioni ON udm_dimensioni.id = articoli.id_udm_dimensioni
		LEFT JOIN udm AS udm_peso ON udm_peso.id = articoli.id_udm_peso
		LEFT JOIN udm AS udm_volume ON udm_volume.id = articoli.id_udm_volume
		LEFT JOIN udm AS udm_capacita ON udm_capacita.id = articoli.id_udm_capacita
		LEFT JOIN udm AS udm_durata ON udm_durata.id = articoli.id_udm_durata
		LEFT JOIN periodicita ON periodicita.id = articoli.id_periodicita
		LEFT JOIN tipologie_rinnovi ON tipologie_rinnovi.id = articoli.id_tipologia_rinnovo
;

-- | 090000001601

-- articoli_caratteristiche_view
-- tipologia: tabella gestita
-- verifica: 2021-05-26 12:01 Fabio Mosti
CREATE OR REPLACE VIEW `articoli_caratteristiche_view` AS
	SELECT
		articoli_caratteristiche.id,
		articoli_caratteristiche.ordine,
		articoli_caratteristiche.id_articolo,
		articoli_caratteristiche.id_caratteristica,
		articoli_caratteristiche.id_lingua,
		caratteristiche.nome AS caratteristica,
		articoli_caratteristiche.valore,
		articoli_caratteristiche.note,
		articoli_caratteristiche.se_assente,
		articoli_caratteristiche.id_account_inserimento,
		articoli_caratteristiche.id_account_aggiornamento,
		concat(
			articoli_caratteristiche.id_articolo,
			' / ',
			caratteristiche.nome
		) AS __label__
	FROM articoli_caratteristiche
		LEFT JOIN caratteristiche ON caratteristiche.id = articoli_caratteristiche.id_caratteristica
;

-- | 090000001701

-- asset_view
CREATE OR REPLACE VIEW `asset_view` AS
	SELECT
		asset.id,
		asset.id_tipologia,
		asset.codice,
		asset.nome,
        asset.hostname,
        asset.ip_address,
		asset.cespite,
		asset.note,
		asset.id_account_inserimento,
		asset.timestamp_inserimento,
		asset.id_account_aggiornamento,
		asset.timestamp_aggiornamento,
		concat_ws( ' ', concat( '#', asset.codice ), asset.nome ) AS __label__
	FROM asset
;

-- | 090000001800

-- attivita_view
CREATE OR REPLACE VIEW `attivita_view` AS                     --
	SELECT	                                                  --
		attivita.id,                                          --
		attivita.id_tipologia,                                --
		tipologie_attivita.nome AS tipologia,                 -- nome della tipologia
		attivita.codice,                                      --
		attivita.id_cliente,                                  --
		a2.codice AS codice_cliente,                          -- codice del cliente
		coalesce(                                             --
            a2.denominazione,                                 --
            concat(                                           --
                a2.cognome, ' ', a2.nome                      --
            ), ''                                             --
        ) AS cliente,                                         -- denominazione o cognome e nome del cliente
		attivita.id_contatto,                                 --
		c1.nome AS contatto,                                  -- nome del contatto
		attivita.id_indirizzo,                                --
		indirizzi.indirizzo AS indirizzo,                     -- indirizzo
		attivita.id_luogo,                                    --
		luoghi_path(                                          --
            coalesce(                                         --
                attivita.id_luogo, todo.id_luogo              --
            )                                                 --
        ) AS luogo,                                           -- percorso del luogo
		attivita.id_messaggio,                                --
		attivita.id_oggetto,                                  --
		concat( asset1.id, ' ', asset1.nome ) AS oggetto,     -- id e nome dell'oggetto
        coalesce(                                             --
            attivita.data_attivita,                           --
            attivita.data_programmazione                      --
        ) AS data_riferimento,                                -- data di riferimento per ordinamento
		coalesce(                                             --
            attivita.ora_inizio,                              --
            attivita.ora_inizio_programmazione                --
        ) AS ora_inizio_riferimento,                          -- ora di inizio di riferimento
		coalesce(                                             --
            attivita.ora_fine,                                --
            attivita.ora_fine_programmazione                  --
        ) AS ora_fine_riferimento,                            -- ora di fine di riferimento
		coalesce(                                             --
            a1.denominazione,                                 --
            concat(                                           --
                a1.cognome, ' ', a1.nome                      --
            ),                                                --
            a3.denominazione,                                 --
            concat(                                           --
                a3.cognome, ' ', a3.nome                      --
            ),                                                --
            ''                                                --
        ) AS anagrafica_riferimento,                          -- denominazione o cognome e nome dell'anagrafica di programmazione o di esecuzione
		attivita.data_scadenza,                               --
		attivita.ora_scadenza,                                --
		attivita.data_programmazione,                         --
		attivita.ora_inizio_programmazione,                   --
		attivita.ora_fine_programmazione,                     --
		attivita.id_anagrafica_programmazione,                --
		coalesce(                                             --
            a3.denominazione,                                 --
            concat(                                           --
                a3.cognome, ' ', a3.nome                      --
            ),                                                --
            ''                                                --
        ) AS anagrafica_programmazione,                       -- denominazione o cognome e nome dell'anagrafica di programmazione
		attivita.ore_programmazione,                          --
		attivita.se_confermata,                               --
		attivita.data_attivita,                               --
		day( data_attivita ) as giorno_attivita,              -- giorno di attivita
		month( data_attivita ) as mese_attivita,              -- mese di attivita
		year( data_attivita ) as anno_attivita,               -- anno di attivita
		attivita.ora_inizio,                                  --
		attivita.latitudine_ora_inizio,                       --
		attivita.longitudine_ora_inizio,                      --
		attivita.data_fine,                                   --
		attivita.ora_fine,                                    --
		attivita.latitudine_ora_fine,                         --
		attivita.longitudine_ora_fine,                        --
		attivita.id_anagrafica,                               --
		coalesce(                                             --
            a1.denominazione,                                 --
            concat( a1.cognome, ' ', a1.nome ),               --
            ''                                                --
        ) AS anagrafica,                                      -- denominazione o cognome e nome dell'anagrafica
		attivita.id_account,                                  --
		attivita.id_asset,                                    --
		concat( asset2.id, ' ', asset2.nome ) AS asset,       -- id e nome dell'asset
		attivita.ore,                                         --
        da.id_articolo,                                       -- id dell'articolo previsto
        da.quantita AS quantita_prevista,                     -- quantità prevista
		attivita.nome,                                        --
		attivita.id_documento,                                --
		concat(                                               --
			td.sigla,                                         --
			' ',                                              --
			documenti.numero,                                 --
			'/',                                              --
			documenti.sezionale,                              --
			' del ',                                          --
			documenti.data                                    --
		) AS documento,                                       -- tipologia, numero, sezionale e data del documento
		attivita.id_corrispondenza,                           --
		concat_ws(                                            --
            ' ',                                              --
            'da',                                             --
            coalesce(                                         --
                a4.denominazione,                             --
                concat( a4.cognome, ' ', a4.nome ),           --
                ''                                            --
            ),                                                --
            concat(                                           --
                '(',                                          --
                organizzazioni_path(                          --
                    cr.id_organizzazione_mittente             --
                ),                                            --   
                ')'                                           --
            ),                                                --
            tipologie_corrispondenza_path(                    --
                cr.id_tipologia                               --
            ),                                                --
            'per',                                            --
            coalesce(                                         --
                cr.destinatario_denominazione,                --
                concat(                                       --
                    cr.destinatario_cognome,                  --
                    ' ',                                      --
                    cr.destinatario_nome                      --
                ),                                            --
                ''                                            --
            )                                                 --
        ) AS corrispondenza,                                  -- descrizione della corrispondenza
		attivita.id_progetto,                                 --
		progetti.nome AS progetto,                            -- nome del progetto
		attivita.id_contratto,                                --
		concat_ws(                                            --
            ' ',                                              --
            tc.nome,                                          --
            c.nome                                            --
        ) AS contratto,                                       -- tipologia e nome del contratto
		group_concat(                                         --
            DISTINCT                                          --
            if(                                               --
                d.id,                                         --
                categorie_progetti_path( d.id ),              --
                null                                          --
            )                                                 --
            SEPARATOR ' | '                                   --
        ) AS discipline,                                      -- elenco delle discipline del progetto separate da |
		attivita.id_matricola,                                --
        attivita.id_immobile,                                 --
        attivita.id_step,                                     --
        step.nome AS step,                                    -- nome dello step
		attivita.id_pianificazione,                           --
		attivita.id_todo,                                     --
		todo.nome AS todo,                                    -- nome del todo
		attivita.id_mastro_provenienza,                       --
		m1.nome AS mastro_provenienza,                        --
		attivita.id_mastro_destinazione,                      --
		m2.nome AS mastro_destinazione,                       --
		attivita.codice_archivium,                            --
		attivita.token,                                       --
		attivita.id_account_inserimento,                      --
		attivita.timestamp_inserimento,                       --
		attivita.id_account_aggiornamento,                    --
		attivita.timestamp_aggiornamento,                     --
		attivita.data_archiviazione,                          --
		concat(                                               --
			attivita.nome,                                    --
			' / ',                                            --
			attivita.ore,                                     --
			' / ',                                            --
			coalesce(                                         --
                a1.denominazione,                             --
                concat(                                       --
                    a1.cognome,                               --
                    ' ',                                      --
                    a1.nome                                   --
                ),                                            --
                ''                                            --
            )                                                 --
		) AS __label__                                        -- etichetta per le tendine e le liste
	FROM attivita                                             --
		LEFT JOIN tipologie_attivita                          --
            ON tipologie_attivita.id = attivita.id_tipologia  --
		LEFT JOIN anagrafica AS a1                            --
            ON a1.id = attivita.id_anagrafica                 --
		LEFT JOIN anagrafica AS a2                            --
            ON a2.id = attivita.id_cliente                    --
		LEFT JOIN anagrafica AS a3                            --
            ON a3.id = attivita.id_anagrafica_programmazione  --
		LEFT JOIN anagrafica AS a4                            --
            ON a4.id = attivita.id_corrispondenza             --
		LEFT JOIN contatti AS c1                              --
            ON c1.id = attivita.id_contatto                   --
		LEFT JOIN todo                                        --
            ON todo.id = attivita.id_todo                     --
		LEFT JOIN step                                        --
            ON step.id = attivita.id_step                     --
		LEFT JOIN progetti_categorie AS pc                    --
            ON pc.id_progetto = attivita.id_progetto          --
		LEFT JOIN progetti                                    --
            ON progetti.id = coalesce(                        --
                attivita.id_progetto,                         --
                todo.id_progetto                              --
            )                                                 --
		LEFT JOIN categorie_progetti                          --
            ON categorie_progetti.id = pc.id_categoria        --
		LEFT JOIN categorie_progetti AS d                     --
            ON d.id = pc.id_categoria                         --
                AND d.se_disciplina = 1                       --
		LEFT JOIN indirizzi                                   --
            ON indirizzi.id = attivita.id_indirizzo           --
		LEFT JOIN mastri AS m1                                --
            ON m1.id = attivita.id_mastro_provenienza         --
		LEFT JOIN mastri AS m2                                --
            ON m2.id = attivita.id_mastro_destinazione        --
		LEFT JOIN documenti                                   --
            ON documenti.id = attivita.id_documento           --
		LEFT JOIN tipologie_documenti AS td                   --
            ON td.id = documenti.id_tipologia                 --
		LEFT JOIN contratti AS c                              --
            ON c.id = attivita.id_contratto                   --
		LEFT JOIN tipologie_contratti AS tc                   --
            ON tc.id = c.id_tipologia                         --
		LEFT JOIN corrispondenza AS cr                        --
            ON cr.id = attivita.id_corrispondenza             --
		LEFT JOIN organizzazioni AS o                         --
            ON o.id = cr.id_organizzazione_mittente           --
		LEFT JOIN tipologie_corrispondenza AS tc2             --
            ON tc2.id = cr.id_tipologia                       --
		LEFT JOIN asset AS asset1                             --
            ON asset1.id = attivita.id_asset                  --
		LEFT JOIN asset AS asset2                             --
            ON asset2.id = attivita.id_asset                  --
        LEFT JOIN documenti_articoli AS da                    --
            ON da.id = todo.id_documenti_articoli             --
	GROUP BY attivita.id                                      --
;                                                             --

-- | 090000002100

-- audio_view
CREATE OR REPLACE VIEW `audio_view` AS
	SELECT
		audio.id,
		audio.id_anagrafica,
		audio.id_pagina,
		audio.id_file,
		audio.id_prodotto,
		audio.id_articolo,
		audio.id_categoria_prodotti,
		audio.id_marchio,
		audio.id_risorsa,
		audio.id_categoria_risorse,
		audio.id_notizia,
		audio.id_annuncio,
		audio.id_categoria_notizie,
		audio.id_categoria_annunci,
		audio.id_lingua,
		lingue.nome AS lingua,
		audio.id_ruolo,
		audio.id_progetto,
		audio.id_categoria_progetti,
		audio.id_indirizzo,
		audio.id_edificio,
		audio.id_immobile,
		audio.id_valutazione,
		ruoli_audio.nome AS ruolo,
		audio.ordine,
		audio.nome,
		audio.path,
		audio.embed,
		audio.codice_embed,
		audio.embed_custom,
		audio.target,
		audio.note,
		audio.id_account_inserimento,
		audio.id_account_aggiornamento,
		concat(
			ruoli_audio.nome,
			' # ',
			audio.ordine,
			' / ',
			audio.nome
		) AS __label__
	FROM audio
		LEFT JOIN lingue ON lingue.id = audio.id_lingua
		LEFT JOIN ruoli_audio ON ruoli_audio.id = audio.id_ruolo
;

-- | 090000002251

-- badge_view
-- tipologia: tabella gestita
CREATE OR REPLACE VIEW badge_view AS
	SELECT
		badge.id,
		badge.nome,
		badge.codice,
		badge.rfid,
		concat_ws(
			' ',
			anagrafica.codice,
			coalesce(
				anagrafica.soprannome,
				anagrafica.denominazione,
				concat_ws(' ', coalesce( anagrafica.cognome, ''),
				coalesce( anagrafica.nome, '') ),
				''
			)
		) AS anagrafica,
		concat_ws( 
			' | ', 
			lpad( badge.id, 8, 0),
			coalesce( badge.codice, badge.rfid, badge.nome ),
			concat_ws(
				' ',
				anagrafica.codice,
				coalesce(
					anagrafica.soprannome,
					anagrafica.denominazione,
					concat_ws(' ', coalesce( anagrafica.cognome, ''),
					coalesce( anagrafica.nome, '') ),
					'NON ASSEGNATO'
				)
			)
		) AS __label__
	FROM badge
	LEFT JOIN anagrafica ON anagrafica.id_badge = badge.id
;

-- | 090000002301

-- banner_view
-- tipologia: tabella gestita
-- verifica: 2022-07-20 17:22 Chiara GDL
CREATE OR REPLACE VIEW `banner_view` AS
	SELECT
		banner.id,
		banner.id_tipologia,
		tipologie_banner_path( banner.id_tipologia ) AS tipologia,
		banner.id_sito,
		banner.ordine,
		banner.nome,
		banner.id_inserzionista,
		coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ) AS inserzionista,
		banner.altezza_modulo,
		banner.larghezza_modulo,
		banner.token,
		banner.id_account_inserimento,
		banner.id_account_aggiornamento,
		concat( banner.nome, ' ', banner.altezza_modulo, 'x', banner.larghezza_modulo ) AS __label__
	FROM banner
		LEFT JOIN anagrafica ON anagrafica.id = banner.id_inserzionista
	;

-- | 090000002401

-- banner_azioni
-- tipologia: tabella gestita
-- verifica: 2022-07-21 10:22 Chiara GDL
CREATE OR REPLACE VIEW `banner_azioni_view` AS
	SELECT
		banner_azioni.id,
		banner_azioni.id_banner,
		banner_azioni.id_pagina,
		banner_azioni.azione,
		banner_azioni.timestamp_azione,
		banner_azioni.token,
		banner_azioni.id_account_inserimento,
		banner_azioni.id_account_aggiornamento,
		concat(
			banner_azioni.azione,
			' di ',
			banner.nome
		) AS __label__
	FROM banner_azioni
		LEFT JOIN banner ON banner.id = banner_azioni.id_banner
;

-- | 090000002501

-- banner_pagine_view
-- tipologia: tabella gestita
-- verifica: 2022-07-21 10:22 Chiara GDL
CREATE OR REPLACE VIEW `banner_pagine_view` AS
	SELECT
		banner_pagine.id,
		banner_pagine.id_banner,
		banner_pagine.id_pagina,
		banner_pagine.se_presente,
		banner_pagine.id_account_inserimento,
		banner_pagine.id_account_aggiornamento,
		concat(
			banner.nome,
			' / ',
			pagine_path( banner_pagine.id_pagina ),
			' / ',
			coalesce( banner_pagine.se_presente, 0 )
		) AS __label__
	FROM banner_pagine
		LEFT JOIN banner ON banner.id = banner_pagine.id_banner
;

-- | 090000002601

-- banner_zone_view
-- tipologia: tabella gestita
-- verifica: 2022-08-04 10:22 Chiara GDL
CREATE OR REPLACE VIEW `banner_zone_view` AS
	SELECT
		banner_zone.id,
		banner_zone.id_banner,
		banner_zone.id_zona,
		banner_zone.se_presente,
		banner_zone.id_account_inserimento,
		banner_zone.id_account_aggiornamento,
		concat(
			banner.nome,
			' / ',
			zone_path( banner_zone.id_zona ),
			' / ',
			coalesce( banner_zone.se_presente, 0 )
		) AS __label__
	FROM banner_zone
		LEFT JOIN banner ON banner.id = banner_zone.id_banner
;

-- | 090000002701

-- campagne_view
CREATE OR REPLACE VIEW `campagne_view` AS
	SELECT
		campagne.id,
		campagne.nome,
		campagne.testo,
		( SELECT count( contatti.id ) FROM contatti WHERE contatti.id_campagna = campagne.id ) AS n_contatti,
		campagne.id_account_inserimento,
		campagne.id_account_aggiornamento,
		campagne.nome AS __label__
	FROM campagne
;

-- | 090000002900

-- caratteristiche_view
CREATE OR REPLACE VIEW `caratteristiche_view` AS
	SELECT
		caratteristiche.id,
		caratteristiche.id_genitore,
		caratteristiche.nome,
		caratteristiche.html_entity,
		caratteristiche.font_awesome,
		caratteristiche.se_prodotti,
		caratteristiche.se_articoli,
		caratteristiche.se_immobili,
		caratteristiche.se_edifici,
		caratteristiche.se_indirizzi,
		caratteristiche.se_categorie_prodotti,
		caratteristiche.id_account_inserimento,
		caratteristiche.id_account_aggiornamento,
		caratteristiche_path(
            caratteristiche.id
        ) AS __label__
	FROM caratteristiche
;

-- | 090000003001

-- caratteristiche_prodotti_view
--
-- l'albero delle caratteristiche con i nomi di colonna di caratteristiche_prodotti; l'etichetta e' il PERCORSO, come
-- per tutte le viste ad albero: senza il gruppo davanti, in un elenco "Attacco mandrino" compare quattro volte
-- identico e non si sa quale scegliere
CREATE OR REPLACE VIEW `caratteristiche_prodotti_view` AS
	SELECT
		caratteristiche.id,
		caratteristiche.id_genitore,
		caratteristiche.nome,
		caratteristiche.html_entity,
		caratteristiche.font_awesome,
		caratteristiche.se_categorie_prodotti AS se_categoria,
		caratteristiche.se_prodotti AS se_prodotto,
		caratteristiche.se_articoli AS se_articolo,
		caratteristiche.id_account_inserimento,
		caratteristiche.id_account_aggiornamento,
		caratteristiche_path(
            caratteristiche.id
        ) AS __label__
	FROM caratteristiche
;

-- | 090000003002

-- carrelli_view
-- tipologia: tabella gestita
-- verifica: 2022-07-12 14:45 Chiara GDL
CREATE OR REPLACE VIEW `carrelli_view` AS
	SELECT
	carrelli.id,
	carrelli.session,
	carrelli.id_sito,
	coalesce( carrelli.intestazione_nome, carrelli.destinatario_nome ) AS cliente_nome,
	coalesce( carrelli.intestazione_cognome, carrelli.destinatario_cognome ) AS cliente_cognome,
	coalesce( carrelli.intestazione_denominazione, carrelli.destinatario_denominazione ) AS cliente_denominazione,
    coalesce( carrelli.intestazione_mail, carrelli.destinatario_mail ) AS cliente_mail,
    coalesce( carrelli.intestazione_mobile, carrelli.destinatario_mobile ) AS cliente_mobile,
	carrelli.destinatario_nome,
	carrelli.destinatario_cognome,
	carrelli.destinatario_denominazione,
    carrelli.destinatario_id_tipologia_anagrafica,
	carrelli.destinatario_id_anagrafica,
	carrelli.destinatario_id_account,
	carrelli.destinatario_indirizzo,
	carrelli.destinatario_cap,
	carrelli.destinatario_citta,
	carrelli.destinatario_id_comune,
	carrelli.destinatario_id_provincia,
	carrelli.destinatario_id_stato,
	carrelli.destinatario_id_comune_nascita,
	carrelli.destinatario_giorno_nascita,
	carrelli.destinatario_mese_nascita,
	carrelli.destinatario_anno_nascita,
	carrelli.destinatario_id_provincia_nascita,
	carrelli.destinatario_id_stato_nascita,
	carrelli.destinatario_telefono,
	carrelli.destinatario_mobile,
	carrelli.destinatario_fax,
	carrelli.destinatario_mail,
	carrelli.destinatario_codice_fiscale,
	carrelli.destinatario_partita_iva,
	coalesce( concat( carrelli.destinatario_nome, ' ', carrelli.destinatario_cognome ), carrelli.destinatario_denominazione ) AS destinatario,
	carrelli.intestazione_nome,
	carrelli.intestazione_cognome,
	carrelli.intestazione_denominazione,
    carrelli.intestazione_id_tipologia_anagrafica,
	carrelli.intestazione_id_anagrafica,
	carrelli.intestazione_id_account,
	carrelli.intestazione_indirizzo,
	carrelli.intestazione_cap,
	carrelli.intestazione_citta,
	carrelli.intestazione_id_provincia,
	carrelli.intestazione_id_stato,
	carrelli.intestazione_id_comune_nascita,
	carrelli.intestazione_giorno_nascita,
	carrelli.intestazione_mese_nascita,
	carrelli.intestazione_anno_nascita,
	carrelli.intestazione_id_provincia_nascita,
	carrelli.intestazione_id_stato_nascita,
	carrelli.intestazione_telefono,
	carrelli.intestazione_mobile,
	carrelli.intestazione_fax,
	carrelli.intestazione_mail,
	carrelli.intestazione_codice_fiscale,
	carrelli.intestazione_partita_iva,
	carrelli.intestazione_sdi,
	carrelli.intestazione_pec,
	coalesce( concat( carrelli.intestazione_nome, ' ', carrelli.intestazione_cognome ), carrelli.intestazione_denominazione ) AS intestazione,
	carrelli.id_listino,
    carrelli.fatturazione_id_tipologia_documento,
    carrelli.fatturazione_sezionale,
    carrelli.fatturazione_strategia,
	carrelli.prezzo_netto_totale,
	carrelli.prezzo_lordo_totale,
	carrelli.sconto_percentuale,
	carrelli.sconto_valore,
	carrelli.prezzo_netto_finale,
	carrelli.prezzo_lordo_finale,
	from_unixtime( carrelli.timestamp_inserimento, '%Y-%m-%d %H:%i' ) AS data_ora_inserimento,
	carrelli.provider_checkout,
	carrelli.timestamp_checkout,
	from_unixtime( carrelli.timestamp_checkout, '%Y-%m-%d %H:%i' ) AS data_ora_checkout,
	carrelli.provider_pagamento,
	carrelli.timestamp_pagamento,
	from_unixtime( carrelli.timestamp_pagamento, '%Y-%m-%d %H:%i' ) AS data_ora_pagamento,
	carrelli.codice_pagamento,
    carrelli.ordine_pagamento,
	carrelli.status_pagamento,
	carrelli.importo_pagamento,
	from_unixtime( carrelli.timestamp_evasione, '%Y-%m-%d %H:%i' ) AS data_ora_evasione,
    carrelli.utm_id,
    carrelli.utm_source,
    carrelli.utm_medium,
    carrelli.utm_campaign,
    carrelli.utm_term,
    carrelli.utm_content,
	carrelli.id_campagna,
	carrelli.spam_score,
	carrelli.spam_check,
    carrelli.id_reseller,
    carrelli.id_affiliato,
	carrelli.id_affiliazione,
	carrelli.id_account_evasione,
	carrelli.timestamp_evasione,
	carrelli.id_account_inserimento,
	carrelli.timestamp_inserimento,
	carrelli.id_account_aggiornamento,
	carrelli.timestamp_aggiornamento,
	carrelli.id AS __label__
FROM carrelli;

-- | 090000003051

-- carrelli_articoli_view
-- tipologia: tabella gestita
-- verifica: 2022-07-12 14:45 Chiara GDL
CREATE OR REPLACE VIEW `carrelli_articoli_view` AS
	SELECT
		carrelli_articoli.id,
		carrelli_articoli.id_carrello,
		carrelli_articoli.id_articolo,
		carrelli_articoli.id_iva,
		carrelli_articoli.id_pagamento,
		carrelli_articoli.destinatario_nome,
		carrelli_articoli.destinatario_cognome,
		carrelli_articoli.destinatario_denominazione,
		carrelli_articoli.destinatario_id_tipologia_anagrafica,
		carrelli_articoli.destinatario_id_anagrafica,
		carrelli_articoli.destinatario_id_account,
		carrelli_articoli.destinatario_indirizzo,
		carrelli_articoli.destinatario_cap,
		carrelli_articoli.destinatario_citta,
		carrelli_articoli.destinatario_id_comune,
		carrelli_articoli.destinatario_id_provincia,
		carrelli_articoli.destinatario_id_stato,
		carrelli_articoli.destinatario_id_comune_nascita,
		carrelli_articoli.destinatario_giorno_nascita,
		carrelli_articoli.destinatario_mese_nascita,
		carrelli_articoli.destinatario_anno_nascita,
		carrelli_articoli.destinatario_id_provincia_nascita,
		carrelli_articoli.destinatario_id_stato_nascita,
		carrelli_articoli.destinatario_telefono,
		carrelli_articoli.destinatario_mobile,
		carrelli_articoli.destinatario_fax,
		carrelli_articoli.destinatario_mail,
		carrelli_articoli.destinatario_codice_fiscale,
		carrelli_articoli.destinatario_partita_iva,
		carrelli_articoli.prezzo_netto_unitario,
		carrelli_articoli.prezzo_lordo_unitario,
		carrelli_articoli.quantita,
		carrelli_articoli.prezzo_netto_totale,
		carrelli_articoli.prezzo_lordo_totale,
		carrelli_articoli.sconto_percentuale,
		carrelli_articoli.sconto_valore,
		carrelli_articoli.prezzo_netto_finale,
		carrelli_articoli.prezzo_lordo_finale,
		carrelli_articoli.id_account_inserimento,
		carrelli_articoli.id_account_aggiornamento,
		concat_ws(
			' / ',
			carrelli_articoli.id_carrello,
			carrelli_articoli.id_articolo
		) AS __label__
	FROM carrelli_articoli;

-- | 090000003061

-- carrelli_consensi_view
-- tipologia: tabella gestita
-- verifica: 2022-08-23 11:12 Chiara GDL
CREATE OR REPLACE VIEW `carrelli_consensi_view` AS
	SELECT
		carrelli_consensi.id,
		carrelli_consensi.id_account,
		carrelli_consensi.id_anagrafica,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		carrelli_consensi.id_carrello,
		carrelli_consensi.id_consenso,
		carrelli_consensi.se_prestato,
		carrelli_consensi.timestamp_consenso,
		carrelli_consensi.id_account_inserimento,
		carrelli_consensi.id_account_aggiornamento,
		concat( 'consenso per ', carrelli_consensi.id_consenso, ' callerro #', carrelli_consensi.id_carrello) AS __label__
	FROM carrelli_consensi
		LEFT JOIN anagrafica AS a1 ON a1.id = carrelli_consensi.id_anagrafica;

-- | 090000003071

-- carrelli_documenti_view
-- tipologia: tabella gestita
-- verifica: 2022-08-22 11:45 Chiara GDL
CREATE OR REPLACE VIEW carrelli_documenti_view AS
	SELECT
		carrelli_documenti.id,
		carrelli_documenti.id_carrello,
		carrelli_documenti.id_documento,
		carrelli_documenti.id_account_inserimento,
		carrelli_documenti.id_account_aggiornamento,
		concat_ws(
			' / ',
			carrelli_documenti.id_carrello,
			carrelli_documenti.id_documento
		) AS __label__
	FROM carrelli_documenti
;

-- | 090000003081

-- casse_previdenziali_view
-- tipologia: tabella standard
CREATE OR REPLACE VIEW casse_previdenziali_view AS
	SELECT
		casse_previdenziali.id,
		casse_previdenziali.codice,
		casse_previdenziali.nome,
		concat( casse_previdenziali.codice, ' - ', casse_previdenziali.nome ) AS __label__
	FROM casse_previdenziali
;

-- | 090000003100

-- categorie_anagrafica_view
CREATE OR REPLACE VIEW categorie_anagrafica_view AS           --
	SELECT                                                    --
		categorie_anagrafica.id,                              --
		categorie_anagrafica.id_genitore,                     --
		categorie_anagrafica.ordine,                          --
		categorie_anagrafica.nome,                            --
		categorie_anagrafica.se_prospect,                     --
		categorie_anagrafica.se_lead,                         --
		categorie_anagrafica.se_cliente,                      --
		categorie_anagrafica.se_fornitore,                    --
		categorie_anagrafica.se_produttore,                   --
		categorie_anagrafica.se_collaboratore,                --
		categorie_anagrafica.se_interno,                      --
		categorie_anagrafica.se_esterno,                      --
		categorie_anagrafica.se_concorrente,                  --
		categorie_anagrafica.se_gestita,                      --
		categorie_anagrafica.se_amministrazione,              --
		categorie_anagrafica.se_produzione,                   --
		categorie_anagrafica.se_commerciale,                  --
		categorie_anagrafica.se_notizie,                      --
		categorie_anagrafica.se_corriere,                     --
		count( c1.id ) AS figli,                              -- conteggio dei figli
		count( ac.id ) AS membri,                             -- conteggio dei membri
		categorie_anagrafica.id_account_inserimento,          --
		categorie_anagrafica.id_account_aggiornamento,        --
	 	categorie_anagrafica_path(                            --
            categorie_anagrafica.id ) AS __label__            -- etichetta per le tendine e le liste
	FROM categorie_anagrafica                                 --
		LEFT JOIN categorie_anagrafica AS c1                  --
            ON c1.id_genitore = categorie_anagrafica.id       --
		LEFT JOIN anagrafica_categorie AS ac                  --
            ON ac.id_categoria = categorie_anagrafica.id      --
	GROUP BY categorie_anagrafica.id                          --
;                                                             --

-- | 090000003301

-- categorie_annunci
CREATE OR REPLACE VIEW categorie_annunci_view AS
	SELECT
		categorie_annunci.id,
		categorie_annunci.id_genitore,
		categorie_annunci.ordine,
		categorie_annunci.nome,
		categorie_annunci.template,
		categorie_annunci.schema_html,
		categorie_annunci.tema_css,
		categorie_annunci.se_sitemap,
		categorie_annunci.se_cacheable,
		categorie_annunci.id_sito,
		categorie_annunci.id_pagina,
		count( c1.id ) AS figli,
		count( annunci_categorie.id ) AS membri,
		categorie_annunci.id_account_inserimento,
		categorie_annunci.id_account_aggiornamento,
		categorie_annunci_path( categorie_annunci.id ) AS __label__
	FROM categorie_annunci
		LEFT JOIN categorie_annunci AS c1 ON c1.id_genitore = categorie_annunci.id
		LEFT JOIN annunci_categorie ON annunci_categorie.id_categoria = categorie_annunci.id
	GROUP BY categorie_annunci.id
;

-- | 090000003700

-- categorie_notizie_view
CREATE OR REPLACE VIEW categorie_notizie_view AS
	SELECT
		categorie_notizie.id,
		categorie_notizie.id_genitore,
		categorie_notizie.ordine,
		categorie_notizie.nome,
		categorie_notizie.template,
		categorie_notizie.schema_html,
		categorie_notizie.tema_css,
		categorie_notizie.se_sitemap,
		categorie_notizie.se_cacheable,
		categorie_notizie.id_sito,
		categorie_notizie.id_pagina,
        categorie_notizie.data_archiviazione,
		count( c1.id ) AS figli,
		count( notizie_categorie.id ) AS membri,
		categorie_notizie.id_account_inserimento,
		categorie_notizie.id_account_aggiornamento,
		categorie_notizie_path( categorie_notizie.id ) AS __label__
	FROM categorie_notizie
		LEFT JOIN categorie_notizie AS c1 ON c1.id_genitore = categorie_notizie.id
		LEFT JOIN notizie_categorie ON notizie_categorie.id_categoria = categorie_notizie.id
	GROUP BY categorie_notizie.id
;

-- | 090000003900

-- categorie_prodotti_view
CREATE OR REPLACE VIEW categorie_prodotti_view AS
	SELECT
		categorie_prodotti.id,
		categorie_prodotti.id_genitore,
		categorie_prodotti.codice,
		categorie_prodotti.ordine,
		categorie_prodotti.nome,
		categorie_prodotti.template,
		categorie_prodotti.schema_html,
		categorie_prodotti.tema_css,
		categorie_prodotti.se_sitemap,
		categorie_prodotti.se_cacheable,
		categorie_prodotti.id_sito,
		categorie_prodotti.id_pagina,
		count( c1.id ) AS figli,
		count( prodotti_categorie.id ) AS membri,
		categorie_prodotti.data_archiviazione,
		categorie_prodotti.id_account_inserimento,
		categorie_prodotti.id_account_aggiornamento,
		categorie_prodotti_path( categorie_prodotti.id ) AS __label__
	FROM categorie_prodotti
		LEFT JOIN categorie_prodotti AS c1 ON c1.id_genitore = categorie_prodotti.id
		LEFT JOIN prodotti_categorie ON prodotti_categorie.id_categoria = categorie_prodotti.id
	GROUP BY categorie_prodotti.id
;

-- | 090000004301

-- categorie_progetti_view
-- tipologia: tabella assistita
-- verifica: 2021-06-01 20:02 Fabio Mosti
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
		categorie_progetti.se_disciplina,
		categorie_progetti.se_classe,
		categorie_progetti.se_fascia,
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

-- | 090000004501

-- categorie_risorse_view
-- tipologia: tabella assistita
-- verifica: 2021-06-01 20:25 Fabio Mosti
CREATE OR REPLACE VIEW categorie_risorse_view AS
	SELECT
		categorie_risorse.id,
		categorie_risorse.id_genitore,
		categorie_risorse.ordine,
		categorie_risorse.nome,
		categorie_risorse.template,
		categorie_risorse.schema_html,
		categorie_risorse.tema_css,
		categorie_risorse.se_sitemap,
		categorie_risorse.se_cacheable,
		categorie_risorse.id_sito,
		categorie_risorse.id_pagina,
		count( c1.id ) AS figli,
		count( risorse_categorie.id ) AS membri,
		categorie_risorse.id_account_inserimento,
		categorie_risorse.id_account_aggiornamento,
		categorie_risorse_path( categorie_risorse.id ) AS __label__
	FROM categorie_risorse
		LEFT JOIN categorie_risorse AS c1 ON c1.id_genitore = categorie_risorse.id
		LEFT JOIN risorse_categorie ON risorse_categorie.id_categoria = categorie_risorse.id
	GROUP BY categorie_risorse.id
;

-- | 090000004601

-- causali_view
-- tipologia: tabella gestita
-- verifica: 2022-04-26 11:12 Chiara GDL
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

-- | 090000004701
-- certificazioni_view
-- tipologia: tabella assistita
-- verifica: 2022-02-03 11:12 Chiara GDL
CREATE OR REPLACE VIEW certificazioni_view AS
	SELECT
		certificazioni.id,
		certificazioni.nome,
		certificazioni.se_identificazione,
		certificazioni.se_medico,
		certificazioni.se_sportivo,
		certificazioni.se_agonistico,
		certificazioni.se_immobili,
	 	certificazioni.nome AS __label__
	FROM certificazioni
;

-- | 090000004801

-- chiavi_view
-- tipologia: tabella gestita
-- verifica: 2021-11-15 12:29 Chiara GDL
CREATE OR REPLACE VIEW chiavi_view AS
	SELECT
		chiavi.id,
		chiavi.id_licenza,
		licenze.nome AS licenza,
        chiavi.id_tipologia,
        tipologie_chiavi.nome AS tipologia,
		chiavi.codice,
		chiavi.seriale,
		chiavi.nome,
		chiavi.id_account_inserimento,
		chiavi.id_account_aggiornamento,
		chiavi.nome AS __label__
	FROM chiavi
		LEFT JOIN licenze ON licenze.id = chiavi.id_licenza
        LEFT JOIN tipologie_chiavi ON tipologie_chiavi.id = chiavi.id_tipologia
;

-- | 090000005001

-- classi_energetiche_view
-- tipologia: tabella standard
-- verifica: 2022-04-28 22:22 Chiara GDL
CREATE OR REPLACE VIEW classi_energetiche_view AS
	SELECT
		classi_energetiche.id,
		classi_energetiche.nome,
		classi_energetiche.ep_min,
		classi_energetiche.ep_max,
		classi_energetiche.rgb,
		classi_energetiche.nome AS __label__
	FROM classi_energetiche
;

-- | 090000005101

-- colori_view
-- tipologia: tabella di supporto
-- verifica: 2021-06-03 15:05 Fabio Mosti
CREATE OR REPLACE VIEW colori_view AS
	SELECT
		colori.id,
		colori.id_genitore,
		colori.nome,
		colori.hex,
		colori.r,
		colori.g,
		colori.b,
		colori.ral,
		colori.pantone,
		colori.c,
		colori.m,
		colori.y,
		colori.k,
		colori_path( colori.id ) AS __label__
	FROM colori
;

-- | 090000005300

-- comuni_view
CREATE OR REPLACE VIEW comuni_view AS                         --
	SELECT                                                    --
		comuni.id,                                            --
		comuni.id_provincia,                                  --
		provincie.nome AS provincia,                          --
		provincie.sigla AS sigla_provincia,                   --
		provincie.id_regione,                                 --
		regioni.nome AS regione,                              --
		regioni.id_stato,                                     --
		stati.nome AS stato,                                  --
		comuni.nome,                                          --
		comuni.codice_istat,                                  --
		comuni.codice_catasto,                                --
		concat(                                               --
			comuni.nome, ' ',                                 --
			coalesce(                                         --
                concat( '(', provincie.sigla, ') '),          --
                ' '                                           --
            ),                                                --
			stati.nome                                        --
		) AS __label__                                        -- etichetta per le tendine e le liste
	FROM comuni                                               --
		INNER JOIN provincie                                  --
            ON provincie.id = comuni.id_provincia             --
		INNER JOIN regioni                                    --
            ON regioni.id = provincie.id_regione              --
		INNER JOIN stati                                      --
            ON stati.id = regioni.id_stato                    --
;                                                             --

-- | 090000006000

-- condizioni_pagamento_view
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

-- | 090000006001

-- condizioni_view
-- tipologia: tabella standard
-- verifica: 2022-04-28 16:12 Chiara GDL
CREATE OR REPLACE VIEW condizioni_view AS
	SELECT
		condizioni.id,
		condizioni.nome,
		condizioni.se_immobili,
		condizioni.se_catalogo,
		condizioni.nome AS __label__
	FROM
		condizioni
;

-- | 090000006200

-- consensi_view
CREATE OR REPLACE VIEW `consensi_view` AS                     --   
  SELECT                                                      --  
    consensi.id,                                              --
    consensi.nome,                                            --
    consensi.id_account_inserimento,                          --
    consensi.id_account_aggiornamento,                        --    
    consensi.nome AS __label__                                -- etichetta per le tendine e le liste
  FROM consensi                                               --
;                                                             --

-- | 090000006300

-- consensi_moduli
CREATE OR REPLACE VIEW `consensi_moduli_view` AS              --
  SELECT                                                      --
    consensi_moduli.id,                                       --
    consensi_moduli.id_lingua,                                --
    consensi_moduli.id_consenso,                              --
    consensi_moduli.modulo,                                   --
    consensi_moduli.ordine,                                   --
    consensi_moduli.azione,                                   --
    consensi_moduli.nome,                                     --
    consensi_moduli.informativa,                              --
    consensi_moduli.pagina,                                   --
    consensi_moduli.se_richiesto,                             --
    consensi_moduli.id_account_inserimento,                   --
    consensi_moduli.id_account_aggiornamento,                 --
    concat(                                                   --
      'consenso ',                                            --
      consensi_moduli.id_consenso,                            --
      ' per modulo ',                                         --
      consensi_moduli.modulo                                  --
    ) AS __label__                                            -- etichetta per le tendine e le liste
  FROM consensi_moduli                                        --
;                                                             --

-- | 090000006500

-- consensi_contatti_view
CREATE OR REPLACE VIEW `consensi_contatti_view` AS            --
  SELECT                                                      --
	consensi_contatti.id,                                       --
    consensi_contatti.id_consenso,                              --
	consensi.nome AS consenso,                                            --
	consensi_contatti.id_contatto,                              --
    consensi_contatti.modulo,                                   --
	consensi_contatti.valore,
    consensi_contatti.id_account_inserimento,                   --
    consensi_contatti.id_account_aggiornamento,                 --
    concat(                                                   --
      'consenso ',                                            --
      consensi.nome,                            --
      ' per modulo ',                                         --
      consensi_contatti.modulo                                  --
    ) AS __label__                                            -- etichetta per le tendine e le liste
  FROM consensi_contatti                                        --
    INNER JOIN consensi ON consensi.id = consensi_contatti.id_consenso	--
;                                                             --

-- | 090000006700

-- contatti_view
CREATE OR REPLACE VIEW contatti_view AS
	SELECT
		contatti.id,
		contatti.id_tipologia,
		tipologie_contatti.nome AS tipologia,
		contatti.id_anagrafica,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		contatti.id_inviante,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS inviante,
		contatti.id_ranking,
		ranking.nome AS ranking,
		contatti.id_campagna,
		campagne.nome AS campagna,
		contatti.id_sito,
        contatti.utm_id,
        contatti.utm_source,
        contatti.utm_medium,
        contatti.utm_campaign,
        contatti.utm_term,
        contatti.utm_content,
		contatti.nome,
		contatti.modulo,
        contatti.data_archiviazione,
		contatti.timestamp_contatto,
		from_unixtime( contatti.timestamp_contatto, '%Y-%m-%d %H:%i' ) AS data_ora_contatto,
		contatti.id_account_inserimento,
		contatti.id_account_aggiornamento,
		concat(
			tipologie_contatti.nome,
			' / ',
			contatti.nome
		) AS __label__
	FROM contatti
		LEFT JOIN tipologie_contatti ON tipologie_contatti.id = contatti.id_tipologia
		LEFT JOIN anagrafica AS a1 ON a1.id = contatti.id_anagrafica
		LEFT JOIN anagrafica AS a2 ON a2.id = contatti.id_inviante
		LEFT JOIN ranking ON ranking.id = contatti.id_ranking
		LEFT JOIN campagne ON campagne.id = contatti.id_campagna
;

-- | 090000006900

-- contenuti_view
CREATE OR REPLACE VIEW contenuti_view AS                        --
	SELECT                                                      --
		contenuti.id,                                           --
		contenuti.id_lingua,                                    --
		contenuti.id_anagrafica,                                --
		contenuti.id_prodotto,                                  --
		contenuti.id_articolo,                                  --
		contenuti.id_categoria_prodotti,                        --
		contenuti.id_caratteristica,                            --
		contenuti.id_marchio,                                   --
		contenuti.id_file,                                      --
		contenuti.id_immagine,                                  --
		contenuti.id_video,                                     --
		contenuti.id_audio,                                     --
		contenuti.id_risorsa,                                   --
		contenuti.id_categoria_risorse,                         --
		contenuti.id_pagina,                                    --
		contenuti.id_popup,                                     --
		contenuti.id_indirizzo,                                 --
		contenuti.id_edificio,                                  --
		contenuti.id_immobile,                                  --
		contenuti.id_notizia,                                   --
		contenuti.id_annuncio,                                  --
		contenuti.id_categoria_notizie,                         --
		contenuti.id_categoria_annunci,                         --
		contenuti.id_template,                                  --
		contenuti.id_colore,                                    --
		contenuti.id_progetto,                                  --
		contenuti.id_categoria_progetti,                        --
		contenuti.id_banner,                                    --
		contenuti.title,                                        --
		contenuti.h1,                                           --
		contenuti.robots,                                       --
		contenuti.id_account_inserimento,                       --
		contenuti.id_account_aggiornamento,                     --
		concat(                                                 --
			contenuti.h1,                                       --
			' / ',                                              --
			lingue.nome                                         --
		) AS __label__                                          -- etichetta per le tendine e le liste
	FROM contenuti                                              --
		INNER JOIN lingue                                       --
            ON lingue.id = contenuti.id_lingua                  --
;                                                               --

-- | 090000007101

-- continenti_view
-- tipologia: tabella di supporto
CREATE OR REPLACE VIEW continenti_view AS
	SELECT
		continenti.id,
		continenti.codice,
		continenti.nome,
		continenti.nome AS __label__
	FROM continenti
;

-- | 090000007200

-- contratti_view
-- tipologia: tabella gestita
-- verifica: 2022-02-21 11:50 Chiara GDL
CREATE OR REPLACE VIEW `contratti_view` AS
	SELECT
		contratti.id,
		contratti.id_tipologia,
        tipologie_contratti.nome AS tipologia,
		contratti.codice,
		contratti.codice_affiliazione,
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
		contratti.id_progetto,
		progetti.nome AS progetto,
		contratti.id_categoria_progetti,
		categorie_progetti_path( contratti.id_categoria_progetti ) AS categoria_progetti,
		contratti.id_badge,
		badge.codice AS badge,
		contratti.nome,
		contratti.id_account_inserimento,
		contratti.id_account_aggiornamento,
        coalesce( min(rinnovi.data_inizio), '-' ) AS data_inizio,
        coalesce( max(rinnovi.data_fine), '-' ) AS data_fine,
		group_concat( DISTINCT coalesce( proponente.denominazione , concat( proponente.cognome, ' ', proponente.nome ) )  SEPARATOR ', ' ) AS proponenti,
		group_concat( DISTINCT contraente.id SEPARATOR ', ' ) AS id_contraenti,
		group_concat( DISTINCT contraente.codice  SEPARATOR ', ' ) AS codici_contraenti,
		group_concat( DISTINCT coalesce( contraente.denominazione , concat( contraente.cognome, ' ', contraente.nome ) )  SEPARATOR ', ' ) AS contraenti,
		group_concat( DISTINCT licenze.codice SEPARATOR ', ' ) AS licenze,
		max( licenze.postazioni ) AS postazioni,
		group_concat( DISTINCT tipologie_licenze.nome SEPARATOR ', ' ) AS tipologia_licenza,
		group_concat( DISTINCT concat_ws( ' ', licenze.codice, tipologie_licenze.nome, licenze.nome ) SEPARATOR ' | ' ) AS dettagli_licenze,
		concat_ws( 
			' ', 
			tipologie_contratti.nome, 
			contratti.nome, 
			progetti.nome,
			concat( 'dal ', coalesce( date_format( min(rinnovi.data_inizio), '%d/%m/%Y' ), '-' ) ),
			concat( 'al ', coalesce( date_format( max(rinnovi.data_fine), '%d/%m/%Y' ), '-' ) ),
			group_concat( 
				DISTINCT coalesce( contraente.denominazione , concat( contraente.cognome, ' ', contraente.nome ), NULL )  SEPARATOR ', ' 
			) 
		) AS __label__
	FROM contratti
        LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
        LEFT JOIN progetti ON progetti.id = contratti.id_progetto
		LEFT JOIN badge ON badge.id = contratti.id_badge
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
		LEFT JOIN ruoli_anagrafica AS ruoli_proponenti ON ruoli_proponenti.se_proponente IS NOT NULL
		LEFT JOIN contratti_anagrafica AS proponenti ON proponenti.id_contratto = contratti.id AND proponenti.id_ruolo = ruoli_proponenti.id
		LEFT JOIN anagrafica AS proponente ON proponente.id = proponenti.id_anagrafica 
		LEFT JOIN ruoli_anagrafica AS ruoli_contraenti ON ruoli_contraenti.se_contraente IS NOT NULL
		LEFT JOIN contratti_anagrafica AS contraenti ON contraenti.id_contratto = contratti.id AND contraenti.id_ruolo = ruoli_contraenti.id
		LEFT JOIN anagrafica AS contraente ON contraente.id = contraenti.id_anagrafica
        LEFT JOIN rinnovi ON rinnovi.id_contratto = contratti.id
		LEFT JOIN licenze ON licenze.id = rinnovi.id_licenza
		LEFT JOIN tipologie_licenze ON tipologie_licenze.id = licenze.id_tipologia
	GROUP BY contratti.id, licenze.codice
;

-- | 090000007301

-- contratti_anagrafica_view
-- tipologia: tabella gestita
-- verifica: 2022-02-21 11:50 Chiara GDL
CREATE OR REPLACE VIEW contratti_anagrafica_view AS 
	SELECT 
		contratti_anagrafica.id,
		contratti_anagrafica.id_contratto,
		contratti.codice,
		contratti_anagrafica.id_anagrafica,
		coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ) AS anagrafica,
		contratti_anagrafica.id_ruolo,
		ruoli_anagrafica.nome AS ruolo,
		contratti_anagrafica.ordine,
		contratti_anagrafica.id_account_inserimento ,
		contratti_anagrafica.id_account_aggiornamento ,
		tipologie_contratti.se_abbonamento,
		tipologie_contratti.se_iscrizione,
		tipologie_contratti.se_tesseramento,
		tipologie_contratti.se_immobili,
		tipologie_contratti.se_acquisto,
		tipologie_contratti.se_locazione,
		ruoli_anagrafica.se_proponente,
		ruoli_anagrafica.se_contraente,
		tipologie_contratti.id AS id_tipologia,
		tipologie_contratti.nome AS tipologia,
		contratti.nome,
		contratti.id_progetto,
		progetti.nome AS progetto,
		min( rinnovi.data_inizio ) AS data_inizio,
		max( rinnovi.data_fine ) AS data_fine,
		concat( 'contratto ', contratti.nome, ' - ', coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ), ' ruolo ', ruoli_anagrafica.nome  ) AS __label__
	FROM contratti_anagrafica
		LEFT JOIN contratti ON contratti.id = contratti_anagrafica.id_contratto
		LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
		LEFT JOIN ruoli_anagrafica ON ruoli_anagrafica.id = contratti_anagrafica.id_ruolo
		LEFT JOIN anagrafica ON anagrafica.id = contratti_anagrafica.id_anagrafica
		LEFT JOIN rinnovi ON rinnovi.id_contratto = contratti.id
		LEFT JOIN progetti ON progetti.id = contratti.id_progetto
	GROUP BY contratti.id, anagrafica.id
;

-- | 090000007401

-- contratti_progetti_view
-- tipologia: tabella gestita
-- verifica: 2022-02-21 11:50 Chiara GDL
CREATE OR REPLACE VIEW contratti_progetti_view AS 
	SELECT 
		contratti_progetti.id,
		contratti_progetti.id_contratto,
		contratti.codice,
		contratti_progetti.id_progetto,
		coalesce( progetti.nome, '' ) AS progetto,
		contratti_progetti.id_ruolo,
		ruoli_progetti.nome AS ruolo,
		contratti_progetti.ordine,
		contratti_progetti.id_account_inserimento,
		contratti_progetti.id_account_aggiornamento,
		contratti_progetti.id_account_archiviazione,
		tipologie_contratti.se_abbonamento,
		tipologie_contratti.se_iscrizione,
		tipologie_contratti.se_tesseramento,
		tipologie_contratti.se_immobili,
		tipologie_contratti.se_acquisto,
		tipologie_contratti.se_locazione,
		tipologie_contratti.se_libero,
		tipologie_contratti.se_prenotazione,
		tipologie_contratti.se_scalare,
		tipologie_contratti.se_affiliazione,
		tipologie_contratti.nome AS tipologia,
		min( rinnovi.data_inizio ) AS data_inizio,
		max( rinnovi.data_fine ) AS data_fine,
		concat( 'contratto ', contratti.nome, ' - ', coalesce( progetti.nome, '' ), ' ruolo ', ruoli_progetti.nome  ) AS __label__
	FROM contratti_progetti
		LEFT JOIN contratti ON contratti.id = contratti_progetti.id_contratto
		LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
		LEFT JOIN ruoli_progetti ON ruoli_progetti.id = contratti_progetti.id_ruolo
		LEFT JOIN progetti ON progetti.id = contratti_progetti.id_progetto
		LEFT JOIN rinnovi ON rinnovi.id_contratto = contratti.id
	GROUP BY contratti.id, progetti.id
;

-- | 090000007501

-- conversazioni_view
-- tipologia: tabella gestita
-- verifica: 2022-08-31 11:50 Chiara GDL
CREATE OR REPLACE VIEW conversazioni_view AS
	SELECT
		conversazioni.id,
		conversazioni.id_annuncio,
		conversazioni.codice,
		conversazioni.nome,
		conversazioni.id_articolo,
		conversazioni.quantita,
		conversazioni.note,
		conversazioni.timestamp_apertura,
		conversazioni.timestamp_chiusura,
		conversazioni.id_account_inserimento,
		conversazioni.timestamp_inserimento,
		conversazioni.id_account_aggiornamento,
		conversazioni.timestamp_aggiornamento,
		conversazioni.nome AS __label__
	FROM
		conversazioni
;

-- | 090000007601

-- conversazioni_account_view
-- tipologia: tabella gestita
-- verifica: 2022-08-31 11:50 Chiara GDL
CREATE OR REPLACE VIEW conversazioni_account_view AS
	SELECT
		conversazioni_account.id,
		conversazioni_account.id_conversazione,
		conversazioni_account.id_account,
		conversazioni_account.id_ruolo,
		conversazioni_account.timestamp_lettura,
		conversazioni_account.timestamp_entrata,
		conversazioni_account.timestamp_uscita,
		conversazioni_account.id_account_inserimento,
		conversazioni_account.timestamp_inserimento,
		conversazioni_account.id_account_aggiornamento,
		conversazioni_account.timestamp_aggiornamento,
		concat( conversazioni_account.id_conversazione, ' - ', conversazioni_account.id_account) AS __label__
	FROM
		conversazioni_account
;

-- | 090000007801

-- corrispondenza_view
CREATE OR REPLACE VIEW corrispondenza_view AS 
	SELECT 
		corrispondenza.id,
		corrispondenza.id_distinta,
		corrispondenza.id_tipologia,
		tipologie_corrispondenza_path( corrispondenza.id_tipologia ) AS tipologia,
		corrispondenza.id_peso,
		pesi_tipologie_corrispondenza.nome AS peso_tipologia,
		tipologie_corrispondenza.se_pesata,
		corrispondenza.peso,
		corrispondenza.id_formato,
		corrispondenza.quantita,
		corrispondenza.id_mittente,
		coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ) AS mittente,
		corrispondenza.id_organizzazione_mittente,
		organizzazioni_path( corrispondenza.id_organizzazione_mittente ) AS organizzazione_mittente,
		corrispondenza.id_commesso,
		coalesce( commessi.denominazione , concat( commessi.cognome, ' ', commessi.nome ), '' ) AS commesso,
		corrispondenza.nome,
		coalesce( corrispondenza.destinatario_denominazione , concat( corrispondenza.destinatario_cognome, ' ', corrispondenza.destinatario_nome ), '' ) AS destinatario,
		coalesce(
			concat( corrispondenza.destinatario_indirizzo, ' ', corrispondenza.destinatario_civico, ', ', corrispondenza.destinatario_cap, ' ', coalesce( corrispondenza.destinatario_citta, '' ), comuni.nome, ' ', provincie.sigla ),
			concat( comuni.nome, ' ', provincie.sigla ),
			concat_ws( ' ', corrispondenza.destinatario_cap, stati.nome ),
			''
		) AS destinazione,
		corrispondenza.timestamp_elaborazione,
		corrispondenza.timestamp_gestione,
		corrispondenza.id_account_inserimento,
		corrispondenza.timestamp_inserimento,
		corrispondenza.id_account_aggiornamento,
		corrispondenza.timestamp_aggiornamento,
		concat_ws(
            ' ',
            'da',
            coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ),
            concat( '(', organizzazioni_path( corrispondenza.id_organizzazione_mittente ), ')' ),
            tipologie_corrispondenza_path( corrispondenza.id_tipologia ),
            'per',
            coalesce( corrispondenza.destinatario_denominazione , concat( corrispondenza.destinatario_cognome, ' ', corrispondenza.destinatario_nome ), '' )
        ) AS __label__
	FROM corrispondenza
        INNER JOIN tipologie_corrispondenza ON tipologie_corrispondenza.id = corrispondenza.id_tipologia
		LEFT JOIN pesi_tipologie_corrispondenza ON pesi_tipologie_corrispondenza.id = corrispondenza.id_peso
		LEFT JOIN anagrafica ON anagrafica.id = corrispondenza.id_mittente
		LEFT JOIN anagrafica AS commessi ON anagrafica.id = corrispondenza.id_commesso
		LEFT JOIN comuni ON comuni.id = corrispondenza.destinatario_id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
		LEFT JOIN stati ON stati.id = corrispondenza.destinatario_id_stato
    WHERE tipologie_corrispondenza.se_corrispondenza = 1
	GROUP BY corrispondenza.id
;

-- | 090000007901

-- costi_contratti_view
-- ripristinata il 2026-09-30 dallo schema del 2021 ( _usr/_database/mysql.schema.sql, 0e99bca51 )
CREATE OR REPLACE VIEW `costi_contratti_view` AS
	SELECT
		costi_contratti.id,
		costi_contratti.id_contratto,
		costi_contratti.id_tipologia,
		costi_contratti.note,
		costi_contratti.costo_orario,
		concat(
			if( tipologie_attivita_inps.codice IS NOT NULL, concat( tipologie_attivita_inps.codice, ' - ' ), '' ),
			tipologie_attivita_inps.nome
		) AS __label__
	FROM costi_contratti
		LEFT JOIN tipologie_attivita_inps ON tipologie_attivita_inps.id = costi_contratti.id_tipologia
;

-- | 090000008001

-- coupon_view
-- ripristinata il 2026-09-30 dalla versione di prima del 02/03/2026, con il codice che il cliente digita
CREATE OR REPLACE VIEW `coupon_view` AS
	SELECT
		coupon.id,
		coupon.codice,
		coupon.nome,
		coupon.id_anagrafica,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		coupon.timestamp_inizio,
		from_unixtime( coupon.timestamp_inizio, '%Y-%m-%d' ) AS data_ora_inizio,
		coupon.timestamp_fine,
		from_unixtime( coupon.timestamp_fine, '%Y-%m-%d' ) AS data_ora_fine,
		coupon.sconto_percentuale,
		coupon.sconto_fisso,
		coupon.se_multiuso,
		coupon.se_globale,
		coupon.se_vincolato,
		coupon.causale,
		coupon.causale_id_contratto,
		group_concat( DISTINCT categorie_progetti.id SEPARATOR '|' ) AS id_categorie_progetti,
		group_concat( DISTINCT categorie_progetti.nome SEPARATOR '|' ) AS categorie_progetti,
		-- group_concat di soli numeri, senza un letterale che dia il charset: su MariaDB 10.3 usciva latin1_swedish_ci
		convert( group_concat( DISTINCT categorie_progetti_path_find_ancestor( categorie_progetti.id ) ) USING utf8 ) COLLATE utf8_general_ci AS id_aree,
		group_concat( DISTINCT aree.nome ) AS aree,
		coupon.id_account_inserimento,
		coupon.timestamp_inserimento,
		coupon.id_account_aggiornamento,
		coupon.timestamp_aggiornamento,
		concat_ws( ' ', coupon.codice, coupon.nome ) AS __label__
	FROM coupon
		LEFT JOIN anagrafica AS a1 ON a1.id = coupon.id_anagrafica
		LEFT JOIN contratti ON contratti.id = coupon.causale_id_contratto
		LEFT JOIN progetti ON progetti.id = contratti.id_progetto
		LEFT JOIN progetti_categorie ON progetti_categorie.id_progetto = progetti.id
		LEFT JOIN categorie_progetti ON ( categorie_progetti.id = progetti_categorie.id_categoria AND categorie_progetti.se_disciplina = 1 )
		LEFT JOIN categorie_progetti AS aree ON aree.id = categorie_progetti_path_find_ancestor( categorie_progetti.id )
	GROUP BY coupon.id
;

-- | 090000008101

-- coupon_articoli_view
-- tipologia: tabella gestita
-- verifica: 2021-06-29 17:00 Fabio Mosti
CREATE OR REPLACE VIEW `coupon_articoli_view` AS
	SELECT
		coupon_articoli.id,
		coupon_articoli.id_coupon,
		coupon_articoli.id_articolo,
		concat_ws( ' ', prodotti.nome, articoli.nome ) AS articolo,
		coupon_articoli.ordine,
		coupon_articoli.id_account_inserimento,
		coupon_articoli.id_account_aggiornamento,
		CONCAT(
			coupon.nome,
			' / ',
			concat_ws( ' ', prodotti.nome, articoli.nome )
		) AS __label__
	FROM coupon_articoli
		LEFT JOIN coupon ON coupon.id = coupon_articoli.id_coupon
		LEFT JOIN articoli ON articoli.id = coupon_articoli.id_articolo
		LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
;

-- | 090000008201

-- coupon_categorie_prodotti_view
-- tipologia: tabella gestita
-- verifica: 2021-06-29 16:12 Fabio Mosti
CREATE OR REPLACE VIEW `coupon_categorie_prodotti_view` AS
	SELECT
		coupon_categorie_prodotti.id,
		coupon_categorie_prodotti.id_coupon,
		coupon_categorie_prodotti.id_categoria,
		categorie_prodotti.nome AS categoria,
		coupon_categorie_prodotti.ordine,
		coupon_categorie_prodotti.id_account_inserimento,
		coupon_categorie_prodotti.id_account_aggiornamento,
		CONCAT(
			coupon.nome,
			' / ',
			categorie_prodotti.nome
		) AS __label__
	FROM coupon_categorie_prodotti
		LEFT JOIN coupon ON coupon_categorie_prodotti.id_coupon = coupon.id
		LEFT JOIN categorie_prodotti ON categorie_prodotti.id = coupon_categorie_prodotti.id_categoria
;

-- | 090000008401

-- coupon_listini_view
-- tipologia: tabella gestita
-- verifica: 2021-06-29 16:40 Fabio Mosti
CREATE OR REPLACE VIEW `coupon_listini_view` AS
	SELECT
		coupon_listini.id,
		coupon_listini.id_coupon,
		coupon_listini.id_listino,
		listini.nome AS listino,
		coupon_listini.ordine,
		coupon_listini.id_account_inserimento,
		coupon_listini.id_account_aggiornamento,
		CONCAT(
			coupon.nome,
			' / ',
			listini.nome
		) AS __label__
	FROM coupon_listini
		LEFT JOIN coupon ON coupon.id = coupon_listini.id_coupon
		LEFT JOIN listini ON listini.id = coupon_listini.id_listino
;

-- | 090000008601

-- coupon_marchi_view
-- tipologia: tabella gestita
-- verifica: 2021-06-29 16:40 Fabio Mosti
CREATE OR REPLACE VIEW `coupon_marchi_view` AS
	SELECT
		coupon_marchi.id,
		coupon_marchi.id_coupon,
		coupon_marchi.id_marchio,
		marchi.nome AS marchio,
		coupon_marchi.ordine,
		coupon_marchi.id_account_inserimento,
		coupon_marchi.id_account_aggiornamento,
		CONCAT(
			coupon.nome,
			' / ',
			marchi.nome
		) AS __label__
	FROM coupon_marchi
		LEFT JOIN coupon ON coupon.id = coupon_marchi.id_coupon
		LEFT JOIN marchi ON marchi.id = coupon_marchi.id_marchio
;

-- | 090000008801

-- coupon_prodotti_view
-- tipologia: tabella gestita
-- verifica: 2021-06-29 17:00 Fabio Mosti
CREATE OR REPLACE VIEW `coupon_prodotti_view` AS
	SELECT
		coupon_prodotti.id,
		coupon_prodotti.id_coupon,
		coupon_prodotti.id_prodotto,
		prodotti.nome AS prodotto,
		coupon_prodotti.ordine,
		coupon_prodotti.id_account_inserimento,
		coupon_prodotti.id_account_aggiornamento,
		CONCAT(
			coupon.nome,
			' / ',
			prodotti.nome
		) AS __label__
	FROM coupon_prodotti
		LEFT JOIN coupon ON coupon.id = coupon_prodotti.id_coupon
		LEFT JOIN prodotti ON prodotti.id = coupon_prodotti.id_prodotto
;

-- | 090000008901

-- crediti_view
-- tipologia: tabella gestita
-- verifica: 2022-07-15 11:56 Chiara GDL
CREATE OR REPLACE VIEW `crediti_view` AS
    SELECT
		crediti.id,
		crediti.id_documenti_articolo,
        concat(
			tipologie_documenti.sigla,
			' ',
			documenti.numero,
			'/',
			year( documenti.data ),
			' del ',
			documenti.data,
			' ',
			documenti_articoli.id_articolo
		) AS riga_documento,
		crediti.data,
		crediti.id_account_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS account_emittente,
		crediti.id_account_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS account_destinatario,
		crediti.id_mastro_provenienza,
		mastri_path( m1.id ) AS mastro_provenienza,
		crediti.id_mastro_destinazione,
		mastri_path( m2.id ) AS mastro_destinazione,
		crediti.quantita,
		crediti.id_pianificazione,
		crediti.nome,
		crediti.id_account_inserimento,
		crediti.id_account_aggiornamento,
		concat(
			crediti.data,
			' / ',
			tipologie_documenti.sigla,
			' / ',
			crediti.quantita,
			' x ',
			documenti_articoli.id_articolo,
			' / ',
			crediti.nome
		) AS __label__
	FROM
		crediti
		LEFT JOIN documenti_articoli ON documenti_articoli.id = crediti.id_documenti_articolo
        LEFT JOIN mastri AS m1 ON m1.id = crediti.id_mastro_provenienza
		LEFT JOIN mastri AS m2 ON m2.id = crediti.id_mastro_destinazione
		LEFT JOIN documenti ON documenti.id = documenti_articoli.id_documento
        LEFT JOIN account AS acc1 ON acc1.id = m1.id_account
		LEFT JOIN anagrafica AS a1 ON a1.id = acc1.id_anagrafica
		LEFT JOIN account AS acc2 ON acc2.id = m2.id_account
		LEFT JOIN anagrafica AS a2 ON a2.id = acc2.id_anagrafica
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
;

-- | 090000008950

-- dichiarazioni_intento_view
CREATE OR REPLACE VIEW `dichiarazioni_intento_view` AS
	SELECT
		dichiarazioni_intento.id,
		dichiarazioni_intento.id_anagrafica,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		dichiarazioni_intento.protocollo,
		dichiarazioni_intento.data_protocollo,
		dichiarazioni_intento.anno,
		dichiarazioni_intento.data_inizio,
		dichiarazioni_intento.data_fine,
		dichiarazioni_intento.importo,
		dichiarazioni_intento.id_account_inserimento,
		dichiarazioni_intento.id_account_aggiornamento,
		concat_ws( ' ', dichiarazioni_intento.protocollo, 'del', dichiarazioni_intento.data_protocollo ) AS __label__
	FROM dichiarazioni_intento
		LEFT JOIN anagrafica AS a1 ON a1.id = dichiarazioni_intento.id_anagrafica
;

-- | 090000009001

-- disponibilita_view
-- tipologia: tabella standard
-- verifica: 2022-04-28 16:12 Chiara GDL
CREATE OR REPLACE VIEW disponibilita_view AS
	SELECT
		disponibilita.id,
		disponibilita.nome,
		disponibilita.se_immobili,
		disponibilita.se_catalogo,
		disponibilita.nome AS __label__
	FROM
		disponibilita
;

-- | 090000009002

-- distinta_view
CREATE OR REPLACE VIEW `distinta_view` AS
	SELECT
		distinta.id,
		distinta.id_articolo,
		concat_ws( ' ', p1.nome, a1.nome ) AS articolo,
		distinta.id_componente,
		concat_ws( ' ', p2.nome, a2.nome ) AS componente,
		distinta.quantita,
		distinta.id_account_inserimento,
		distinta.id_account_aggiornamento,
		concat_ws(
			' / ',
			concat_ws( ' ', p1.nome, a1.nome ),
			concat_ws( ' ', p2.nome, a2.nome )
		) AS __label__
	FROM distinta
		LEFT JOIN articoli AS a1 ON a1.id = distinta.id_articolo
		LEFT JOIN prodotti AS p1 ON p1.id = a1.id_prodotto
		LEFT JOIN articoli AS a2 ON a2.id = distinta.id_componente
		LEFT JOIN prodotti AS p2 ON p2.id = a2.id_prodotto
;

-- | 090000009750

-- colli_view
CREATE OR REPLACE VIEW `colli_view` AS
	SELECT
		colli.id,
		colli.id_documento,
		colli.ordine,
		colli.codice,
		colli.raggruppamento,
		colli.larghezza,
		colli.lunghezza,
		colli.altezza,
		colli.id_udm_dimensioni,
		colli.peso,
		colli.id_udm_peso,
		colli.volume,
		colli.id_udm_volume,
		colli.nome,
		colli.id_mastro,
		mastri_path( colli.id_mastro ) AS mastro,
		colli.id_anagrafica,
		a2.denominazione AS anagrafica,
		GROUP_CONCAT( DISTINCT anagrafica.denominazione SEPARATOR '|' ) AS destinatari,
		colli.id_account_inserimento,
		colli.id_account_aggiornamento,
		colli.timestamp_chiusura,
		IF( colli.timestamp_chiusura IS NOT NULL AND colli.timestamp_chiusura > 0,
			'<i class="fa fa-check text-success"></i>', '' ) AS chiuso,    -- indicatore collo chiuso
		CONCAT_WS( ' ', colli.codice, tipologie_colli_path( colli.id_tipologia ), colli.nome ) AS __label__
	FROM colli
		LEFT JOIN documenti_articoli ON documenti_articoli.id_collo = colli.id
		LEFT JOIN documenti ON documenti.id = documenti_articoli.id_packing_list
		LEFT JOIN anagrafica ON anagrafica.id = documenti.id_destinatario
		LEFT JOIN anagrafica a2 ON a2.id = colli.id_anagrafica
	GROUP BY colli.id
;

-- | 090000009800

-- documenti_view
CREATE OR REPLACE VIEW `documenti_view` AS
    SELECT
		documenti.id,
		documenti.id_tipologia,
		tipologie_documenti.nome AS tipologia,
		documenti.codice,
		documenti.numero,
		documenti.sezionale,
        concat_ws(
            '/',
            documenti.numero,
            documenti.sezionale
        ) AS numero_sezionale,
		documenti.data,
		documenti.nome,
		documenti.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		documenti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		documenti.id_destinatario_spedizione,
		coalesce( a3.denominazione , concat( a3.cognome, ' ', a3.nome ), '' ) AS destinatario_spedizione,
		documenti.id_condizione_pagamento,
		condizioni_pagamento.codice AS condizione_pagamento,
		documenti.esigibilita, 
		-- Il totale di un documento e' quello che vale la prestazione, non i soli contanti.
		--
		-- Fix 2026-09-08. `importo_lordo_finale` e' la sola parte pagata in denaro: una ricevuta
		-- saldata per intero con un coupon ci metteva dentro ZERO. E non in modo coerente, perche'
		-- il ripiego su `importo_lordo_totale` scattava solo con NULL e mai con `0.00`, che i vari
		-- flussi di checkout scrivono uno per uno: due ricevute della stessa tornata finivano cosi'
		-- a dichiarare l'importo in due modi diversi ( segreteria Polisportiva Masi, 08/09/2026 ).
		--
		-- Il coupon e' un modo di pagare, non uno sconto sul dovuto: va sommato al contante. E'
		-- la stessa somma che la stampa della ricevuta usa da sempre come totale pagato
		-- ( coupon_valore + importo_lordo_finale ). Il ripiego sul nominale resta per il solo caso
		-- in cui non si sa ne' quanto e' stato incassato ne' quanto coperto dal buono: la rata
		-- pianificata e non ancora saldata.
		--
		-- NOTA per chi tocchera' questa vista: la `sum()` sta dentro un GROUP BY che ha in JOIN
		-- anche `relazioni_documenti` ( r1/r2 ), quindi su un documento con N pagamenti e M
		-- documenti collegati il totale risulta moltiplicato per M. Difetto reale ma indipendente
		-- da questo, e non verificabile qui: su questo deploy `relazioni_documenti` e' vuota.
		sum(
			CASE WHEN pagamenti.importo_lordo_finale IS NULL AND pagamenti.coupon_valore IS NULL
			     THEN coalesce( pagamenti.importo_lordo_totale, 0 )
			     ELSE coalesce( pagamenti.importo_lordo_finale, 0 ) + coalesce( pagamenti.coupon_valore, 0 )
			END
		) AS totale_lordo_finale,
		sum( coalesce( pagamenti.coupon_valore, 0 ) ) AS totale_coupon,
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
        group_concat( DISTINCT d1.codice SEPARATOR ' | ' ) AS documenti_antecedenti,
        group_concat( DISTINCT d2.codice SEPARATOR ' | ' ) AS documenti_successivi,
		documenti.porto,
		documenti.id_causale,
		documenti.id_trasportatore,
		documenti.id_immobile,
		documenti.id_pianificazione,
		documenti.data_consegna,
		documenti.timestamp_chiusura,
		documenti.data_archiviazione,
		from_unixtime( documenti.timestamp_chiusura, '%Y-%m-%d %H:%i' ) AS data_ora_chiusura,
		documenti.id_account_inserimento,
		documenti.id_account_aggiornamento,
		concat(
			tipologie_documenti.sigla,
			' ',
            concat_ws(
                '/',
                documenti.numero,
                documenti.sezionale
            ),
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
        LEFT JOIN anagrafica AS a3 ON a3.id = documenti.id_destinatario_spedizione
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
		LEFT JOIN condizioni_pagamento ON condizioni_pagamento.id = documenti.id_condizione_pagamento
		LEFT JOIN mastri AS m1 ON m1.id = documenti.id_mastro_provenienza
		LEFT JOIN mastri AS m2 ON m2.id = documenti.id_mastro_destinazione
		LEFT JOIN pagamenti ON pagamenti.id_documento = documenti.id
        LEFT JOIN relazioni_documenti AS r1 ON r1.id_documento = documenti.id
        LEFT JOIN documenti AS d1 ON d1.id = r1.id_documento_collegato
        LEFT JOIN relazioni_documenti AS r2 ON r2.id_documento_collegato = documenti.id
        LEFT JOIN documenti AS d2 ON d2.id = r2.id_documento
	GROUP BY
		documenti.id
;

-- | 090000010000

-- documenti_articoli_view
CREATE OR REPLACE VIEW `documenti_articoli_view` AS
    SELECT
		documenti_articoli.id,
		documenti_articoli.id_genitore,
        documenti_articoli.codice,
		coalesce( documenti_articoli.id_tipologia_documento, documenti.id_tipologia ) AS id_tipologia,
		tipologie_documenti.nome AS tipologia,
		documenti_articoli.id_tipologia AS id_tipologia_riga,
		tipologie_documenti_articoli.nome AS tipologia_riga,
		documenti_articoli.ordine,
		documenti_articoli.id_documento,
		documenti.codice AS codice_documento,
        concat(
			tipologie_documenti.sigla,
			' ',
			documenti.numero,
			'/',
			documenti.sezionale,
			' del ',
			documenti.data
		) AS documento,
		coalesce( documenti_articoli.data, documenti.data ) AS data,
		documenti_articoli.id_packing_list,
		documenti_articoli.id_missione,
		coalesce( documenti_articoli.id_emittente, documenti.id_emittente ) AS id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		coalesce( documenti_articoli.id_destinatario, documenti.id_destinatario ) AS id_destinatario,
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
			nullif( articoli.nome, prodotti.nome ),
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
        -- LA QUANTITA' DELLE SOTTO RIGHE: SOTTOQUERY, NON JOIN PIU' GROUP BY
        --
        -- era una LEFT JOIN su se stessa piu' un sum() sotto GROUP BY, ed e' l'unica ragione per
        -- cui questa vista aveva un GROUP BY. Costava carissimo, ma solo dove non si vedeva: con
        -- un valore letterale nel WHERE l'ottimizzatore spinge la condizione dentro la vista e
        -- legge una riga sola, con un SEGNAPOSTO non ci riesce e materializza tutte le righe
        -- passando per venti join. Il framework interroga SEMPRE con statement preparati, quindi
        -- pagava sempre il prezzo pieno.
        --
        -- Misurato l'08/09/2026 su 50.213 righe: SELECT * ... WHERE id = ? passa da 11,1 secondi a
        -- 0,012, e la tendina delle righe genitore da 9,0 a 0,17. Le due versioni danno righe
        -- identiche, verificate una per una.
        ( SELECT coalesce( sum( sotto_righe.quantita ), 0 )
            FROM documenti_articoli AS sotto_righe
           WHERE sotto_righe.id_genitore = documenti_articoli.id
        ) AS sotto_righe_quantita,
		documenti_articoli.id_listino,		
		documenti_articoli.id_pianificazione,
		listini.id_valuta,
		valute.utf8 AS valuta,
		documenti_articoli.importo_netto_totale,
		documenti_articoli.sconto_percentuale,
		documenti_articoli.sconto_valore,
		documenti_articoli.id_matricola,
		matricole.matricola AS matricola,
		documenti_articoli.id_rinnovo,
		documenti_articoli.id_collo,
		colli.codice AS codice_collo,
		colli.nome AS nome_collo,
        colli.ordine AS ordine_collo,
		matricole.data_scadenza,
		documenti_articoli.nome,
		documenti_articoli.data_consegna,
        documenti.data_archiviazione,
		documenti_articoli.id_account_inserimento,
		documenti_articoli.id_account_aggiornamento,
		concat_ws(
            ' / ',
			coalesce( documenti_articoli.data, documenti.data, NULL ),
			coalesce( tipologie_documenti.sigla, NULL ),
            concat(
			    coalesce( documenti.numero, NULL ),
                '/',
                coalesce( documenti.sezionale, NULL )
            ),
            concat(
                coalesce( documenti_articoli.quantita, 0 ),
                ' x ',
                coalesce( documenti_articoli.id_articolo, '' )
            ),
			coalesce( documenti_articoli.nome, NULL ),
            concat(
                coalesce( documenti_articoli.importo_netto_totale, NULL ),
                ' ',
                coalesce( valute.utf8, '' )
            )
		) AS __label__
	FROM
		documenti_articoli
        LEFT JOIN documenti ON documenti.id = documenti_articoli.id_documento
		LEFT JOIN anagrafica AS a1 ON a1.id = coalesce( documenti_articoli.id_emittente, documenti.id_emittente )
		LEFT JOIN anagrafica AS a2 ON a2.id = coalesce( documenti_articoli.id_destinatario, documenti.id_destinatario )
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = coalesce( documenti_articoli.id_tipologia_documento, documenti.id_tipologia )
		LEFT JOIN listini ON listini.id = documenti_articoli.id_listino
		LEFT JOIN valute ON valute.id = listini.id_valuta
		LEFT JOIN mastri AS m1 ON m1.id = documenti_articoli.id_mastro_provenienza
		LEFT JOIN mastri AS m2 ON m2.id = documenti_articoli.id_mastro_destinazione
		LEFT JOIN matricole ON matricole.id = documenti_articoli.id_matricola
		LEFT JOIN articoli ON articoli.id = documenti_articoli.id_articolo
		LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
		LEFT JOIN prodotti AS p ON p.id = documenti_articoli.id_prodotto
		LEFT JOIN colli ON colli.id = documenti_articoli.id_collo
		LEFT JOIN udm AS udm_dimensioni ON udm_dimensioni.id = articoli.id_udm_dimensioni
		LEFT JOIN udm AS udm_peso ON udm_peso.id = articoli.id_udm_peso
		LEFT JOIN udm AS udm_volume ON udm_volume.id = articoli.id_udm_volume
		LEFT JOIN udm AS udm_capacita ON udm_capacita.id = articoli.id_udm_capacita
		LEFT JOIN udm AS udm_durata ON udm_durata.id = articoli.id_udm_durata
		LEFT JOIN udm AS udm_riga ON udm_riga.id = documenti_articoli.id_udm
		LEFT JOIN tipologie_documenti_articoli ON tipologie_documenti_articoli.id = documenti_articoli.id_tipologia
;

-- | 090000010051

-- documenti_casse_previdenziali_view
-- tipologia: tabella gestita
CREATE OR REPLACE VIEW documenti_casse_previdenziali_view AS
	SELECT
		documenti_casse_previdenziali.id,
		documenti_casse_previdenziali.id_documento,
		documenti_casse_previdenziali.id_cassa_previdenziale,
		casse_previdenziali.codice AS cassa_previdenziale,
		documenti_casse_previdenziali.aliquota,
		documenti_casse_previdenziali.imponibile,
		documenti_casse_previdenziali.importo,
		documenti_casse_previdenziali.id_iva,
		iva.nome AS iva,
		documenti_casse_previdenziali.se_ritenuta,
		documenti_casse_previdenziali.id_account_inserimento,
		documenti_casse_previdenziali.id_account_aggiornamento,
		concat_ws( ' ', casse_previdenziali.codice, concat( documenti_casse_previdenziali.aliquota, '%' ) ) AS __label__
	FROM documenti_casse_previdenziali
		LEFT JOIN casse_previdenziali ON casse_previdenziali.id = documenti_casse_previdenziali.id_cassa_previdenziale
		LEFT JOIN iva ON iva.id = documenti_casse_previdenziali.id_iva
;

-- | 090000010101

-- documenti_ritenute_view
-- tipologia: tabella gestita
CREATE OR REPLACE VIEW documenti_ritenute_view AS
	SELECT
		documenti_ritenute.id,
		documenti_ritenute.id_documento,
		documenti_ritenute.id_ritenuta,
		ritenute.codice AS ritenuta,
		documenti_ritenute.aliquota,
		documenti_ritenute.causale_pagamento,
		documenti_ritenute.importo,
		documenti_ritenute.id_account_inserimento,
		documenti_ritenute.id_account_aggiornamento,
		concat_ws( ' ', ritenute.codice, concat( documenti_ritenute.aliquota, '%' ), documenti_ritenute.causale_pagamento ) AS __label__
	FROM documenti_ritenute
		LEFT JOIN ritenute ON ritenute.id = documenti_ritenute.id_ritenuta
;

-- | 090000012001

-- edifici
-- tipologia: tabella gestita
-- verifica: 2022-04-27 16:56 Chiara GDL
CREATE OR REPLACE VIEW edifici_view AS
	SELECT
		edifici.id,
		edifici.id_tipologia,
		tipologie_edifici.nome AS tipologia,
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
		edifici.codice,
		edifici.nome,
		edifici.piani,
		edifici.id_account_inserimento,
		edifici.id_account_aggiornamento,
		concat_ws(
			' ',
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
	FROM edifici
		LEFT JOIN tipologie_edifici ON tipologie_edifici.id = edifici.id_tipologia
		LEFT JOIN indirizzi ON indirizzi.id = edifici.id_indirizzo
		LEFT JOIN tipologie_indirizzi ON tipologie_indirizzi.id = indirizzi.id_tipologia
		LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
		LEFT JOIN regioni ON regioni.id = provincie.id_regione
		LEFT JOIN stati ON stati.id = regioni.id_stato
;

-- | 090000012051

-- edifici_caratteristiche_view
-- tipologia: tabella gestita
-- verifica: 2022-04-27 16:56 Chiara GDL
CREATE OR REPLACE VIEW `edifici_caratteristiche_view` AS
	SELECT
		edifici_caratteristiche.id,
		edifici_caratteristiche.id_edificio,
		edifici_caratteristiche.id_caratteristica,
		caratteristiche.nome AS caratteristica,
		edifici_caratteristiche.ordine,
		edifici_caratteristiche.se_presente,
		edifici_caratteristiche.id_account_inserimento,
		edifici_caratteristiche.id_account_aggiornamento,
		concat(
			edifici_caratteristiche.id_edificio,
			' / ',
			caratteristiche.nome
		) AS __label__
	FROM edifici_caratteristiche
		LEFT JOIN caratteristiche ON caratteristiche.id = edifici_caratteristiche.id_caratteristica
;

-- | 090000015000

-- file_view
CREATE OR REPLACE VIEW `file_view` AS
	SELECT
		file.id,
		file.ordine,
		file.id_ruolo,
		ruoli_file.nome AS ruolo,
		file.id_anagrafica,
		file.id_prodotto,
		file.id_articolo,
		file.id_categoria_prodotti,
		file.id_marchio,
		file.id_todo,
		file.id_pagina,
		file.id_template,
		file.id_notizia,
		file.id_annuncio,
		file.id_categoria_notizie,
		file.id_categoria_annunci,
		file.id_risorsa,
		file.id_categoria_risorse,
		file.id_mail_out,                    
		file.id_mail_sent, 
		file.id_progetto,
		file.id_categoria_progetti,
		file.id_documento,
		file.id_indirizzo,
		file.id_edificio,
		file.id_immobile,
		file.id_contratto,
        file.id_valutazione,
        file.id_rinnovo,
		file.id_anagrafica_certificazioni,
		file.id_valutazione_certificazioni,
		file.id_licenza,
		file.id_lingua,
		lingue.iso6393alpha3 AS lingua,
		file.id_attivita,
		file.path,
		file.url,
		file.nome,
		file.id_account_inserimento,
		file.id_account_aggiornamento,
		concat(
			coalesce(ruoli_file.nome, 'nessun ruolo'),
			' # ',
			coalesce(file.ordine, '§'),
			' / ',
			coalesce(file.nome, 'nessun nome'),
			' / ',
			coalesce(
				file.path,
				file.url,
				'nessun path'
			)
		) AS __label__
	FROM file
		LEFT JOIN ruoli_file ON ruoli_file.id = file.id_ruolo
		LEFT JOIN lingue ON lingue.id = file.id_lingua
;

-- | 090000015150

-- giorni
CREATE OR REPLACE VIEW `giorni_view` AS
	SELECT
		giorni.id,
		giorni.nome,
		giorni.nome AS __label__
	FROM giorni
;

-- | 090000015200

-- gruppi_view
CREATE OR REPLACE VIEW `gruppi_view` AS
	SELECT
		gruppi.id,
		gruppi.id_genitore,
		gruppi.id_organizzazione,
		gruppi.nome,
		gruppi.id_account_inserimento,
		gruppi.id_account_aggiornamento,
		gruppi_path( gruppi.id ) AS __label__
	FROM gruppi
;

-- | 090000015400

-- iban_view
CREATE OR REPLACE VIEW `iban_view` AS
	SELECT
		iban.id,
		iban.id_anagrafica,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		iban.intestazione,
		iban.iban,
		iban.id_account_inserimento,
		iban.id_account_aggiornamento,
		concat_ws(
			' ',
			iban.iban,
			iban.intestazione,
			coalesce(
				a1.denominazione,
				concat(
					a1.cognome,
					' ',
					a1.nome
				)
			)
		) AS __label__
	FROM iban
		LEFT JOIN anagrafica AS a1 ON a1.id = iban.id_anagrafica
;

-- | 090000015600

-- immagini_view
CREATE OR REPLACE VIEW `immagini_view` AS                       --
	SELECT                                                      --
		immagini.id,                                            --
		immagini.id_anagrafica,                                 --
		immagini.id_pagina,                                     --
		immagini.id_file,                                       --
		immagini.id_prodotto,                                   --
		immagini.id_articolo,                                   --
		immagini.id_categoria_prodotti,                         --
		immagini.id_marchio,                         --
		immagini.id_risorsa,                                    --
		immagini.id_categoria_risorse,                          --
		immagini.id_notizia,                                    --
		immagini.id_annuncio,                                   --
		immagini.id_categoria_notizie,                          --
		immagini.id_categoria_annunci,                          --
		immagini.id_progetto,                                   --
		immagini.id_categoria_progetti,                         --
		immagini.id_indirizzo,                                  --
		immagini.id_edificio,                                   --
		immagini.id_immobile,                                   --
		immagini.id_contratto,                                  --
        immagini.id_valutazione,                                --
		immagini.id_banner,                                     --
        immagini.id_rinnovo,                                    --
        immagini.id_video,                                    --
		immagini.id_lingua,                                     --
		lingue.nome AS lingua,                                  --
		immagini.id_ruolo,                                      --
		ruoli_immagini.nome AS ruolo,                           --
		immagini.ordine,                                        --
		immagini.orientamento,                                  --
		immagini.taglio,                                        --
		immagini.nome,                                          --
		immagini.path,                                          --
		immagini.path_alternativo,                              --
		immagini.token,                                         --
		immagini.timestamp_scalamento,                          --
		immagini.id_account_inserimento,                        --
		immagini.id_account_aggiornamento,                      --
		concat(                                                 --
			ruoli_immagini.nome,                                --
			' # ',                                              --
			immagini.ordine,                                    --
			' / ',                                              --
			immagini.nome,                                      --
			' / ',                                              --
			immagini.path                                       --
		) AS __label__                                          -- etichetta per le tendine e le liste
	FROM immagini                                               --
		LEFT JOIN lingue                                        --
            ON lingue.id = immagini.id_lingua                   --
		LEFT JOIN ruoli_immagini                                --
            ON ruoli_immagini.id = immagini.id_ruolo            --
;                                                               --

-- | 090000015701

-- immobili_view
-- tipologia: tabella gestita
-- verifica: 2022-04-27 12:20 Chiara GDL
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

-- | 090000015711

-- immobili_anagrafica_view
-- tipologia: tabella gestita
-- verifica: 2022-04-28 12:20 Chiara GDL
CREATE OR REPLACE VIEW  immobili_anagrafica_view AS 
	SELECT 
		immobili_anagrafica.id,
		immobili_anagrafica.id_immobile,
		immobili_anagrafica.id_anagrafica,
		coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ) AS anagrafica,
		immobili_anagrafica.id_ruolo,
		ruoli_anagrafica.nome AS ruolo,
		immobili_anagrafica.ordine,
		immobili_anagrafica.id_account_inserimento ,
		immobili_anagrafica.id_account_aggiornamento ,
		concat( 'immobile ', immobili_anagrafica.id_immobile, ' - ', coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ), ' ruolo ', ruoli_anagrafica.nome  ) AS __label__
	FROM immobili_anagrafica
		LEFT JOIN ruoli_anagrafica ON ruoli_anagrafica.id = immobili_anagrafica.id_ruolo
		LEFT JOIN anagrafica ON anagrafica.id = immobili_anagrafica.id_anagrafica;

-- | 090000015751

-- immobili_caratteristiche_view
-- tipologia: tabella gestita
-- verifica: 2022-04-28 12:20 Chiara GDL
CREATE OR REPLACE VIEW `immobili_caratteristiche_view` AS
	SELECT
		immobili_caratteristiche.id,
		immobili_caratteristiche.id_immobile,
		immobili_caratteristiche.id_caratteristica,
		caratteristiche.nome AS caratteristica,
		immobili_caratteristiche.ordine,
		immobili_caratteristiche.se_presente,
		immobili_caratteristiche.id_account_inserimento,
		immobili_caratteristiche.id_account_aggiornamento,
		concat(
			immobili_caratteristiche.id_immobile,
			' / ',
			caratteristiche.nome
		) AS __label__
	FROM immobili_caratteristiche
		LEFT JOIN caratteristiche ON caratteristiche.id = immobili_caratteristiche.id_caratteristica
;

-- | 090000015801

-- indirizzi_view
-- tipologia: tabella gestita
-- verifica: 2021-09-23 16:08 Fabio Mosti
CREATE OR REPLACE VIEW indirizzi_view AS
	SELECT
		indirizzi.id,
		indirizzi.id_tipologia,
		tipologie_indirizzi.nome AS tipologia,
		indirizzi.id_comune,
		comuni.nome AS comune,
		comuni.id_provincia,
		provincie.nome AS provincia,
		provincie.id_regione,
		regioni.nome AS regione,
		regioni.id_stato,
		stati.nome AS stato,
		indirizzi.localita,
		indirizzi.indirizzo,
		indirizzi.civico,
		indirizzi.cap,
		indirizzi.latitudine,
		indirizzi.longitudine,
		indirizzi.token,
		indirizzi.timestamp_geolocalizzazione,
		indirizzi.id_account_inserimento,
		indirizzi.id_account_aggiornamento,
		concat_ws(
			' ',
			tipologie_indirizzi.nome,
			indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) AS __label__
	FROM indirizzi
		LEFT JOIN tipologie_indirizzi ON tipologie_indirizzi.id = indirizzi.id_tipologia
		LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
		LEFT JOIN regioni ON regioni.id = provincie.id_regione
		LEFT JOIN stati ON stati.id = regioni.id_stato
;

-- | 090000015851

-- indirizzi_caratteristiche_view
-- tipologia: tabella gestita
-- verifica: 2022-05-03 15:21 Chiara GDL
CREATE OR REPLACE VIEW `indirizzi_caratteristiche_view` AS
	SELECT
		indirizzi_caratteristiche.id,
		indirizzi_caratteristiche.id_indirizzo,
		indirizzi_caratteristiche.id_caratteristica,
		caratteristiche.nome AS caratteristica,
		indirizzi_caratteristiche.ordine,
		indirizzi_caratteristiche.se_presente,
		indirizzi_caratteristiche.id_account_inserimento,
		indirizzi_caratteristiche.id_account_aggiornamento,
		concat(
			indirizzi_caratteristiche.id_indirizzo,
			' / ',
			caratteristiche.nome
		) AS __label__
	FROM indirizzi_caratteristiche
		LEFT JOIN caratteristiche ON caratteristiche.id = indirizzi_caratteristiche.id_caratteristica
;

-- | 090000016000

-- iva_view
CREATE OR REPLACE VIEW iva_view AS
	SELECT
		iva.id,
		iva.aliquota,
		iva.nome,
		iva.codice,
		iva.timestamp_archiviazione,
		iva.nome AS __label__
	FROM
		iva
;

-- | 090000016201

-- job_view
-- tipologia: tabella gestita
-- verifica: 2021-09-24 17:19 Fabio Mosti
CREATE OR REPLACE VIEW job_view AS
	SELECT
		job.id,
		job.nome,
		job.job,
		job.totale,
		job.corrente,
		job.iterazioni,
		job.delay,
		job.token,
		job.se_foreground,
		job.timestamp_apertura,
        -- concat( ( ( unix_timestamp() - job.timestamp_apertura ) / job.corrente ), 's' ) AS velocita,
        -- from_unixtime( ceil( unix_timestamp() + ( ( ( unix_timestamp() - job.timestamp_apertura ) / job.corrente ) * ( job.totale - job.corrente ) ) ), '%Y-%m-%d %H:%i' ) AS proiezione,
        concat( ( ( coalesce( job.timestamp_esecuzione, unix_timestamp() ) - job.timestamp_apertura ) / job.corrente ), 's' ) AS velocita,
        from_unixtime( ceil( coalesce( job.timestamp_esecuzione, unix_timestamp() ) + ( ( ( coalesce( job.timestamp_esecuzione, unix_timestamp() ) - job.timestamp_apertura ) / job.corrente ) * ( job.totale - job.corrente ) ) ), '%Y-%m-%d %H:%i' ) AS proiezione,
		from_unixtime( job.timestamp_apertura, '%Y-%m-%d %H:%i' ) AS data_ora_apertura,
		job.timestamp_esecuzione,
		from_unixtime( job.timestamp_esecuzione, '%Y-%m-%d %H:%i' ) AS data_ora_esecuzione,
		job.timestamp_completamento,
		from_unixtime( job.timestamp_completamento, '%Y-%m-%d %H:%i' ) AS data_ora_completamento,
		job.id_account_inserimento,
		job.id_account_aggiornamento,
		job.nome AS __label__
	FROM job
;

-- | 090000016601

-- licenze_view
-- tipologia: tabella gestita
-- verifica: 2021-11-15 12:44 Chiara GDL
-- TODO i dati sul contratto vanno recuperati in maniera più precisa
-- NOTA il campo id_anagrafica nelle licenze è lì perché la licenza potrebbe avere un intestatario diverso dal contratto
CREATE OR REPLACE VIEW licenze_view AS
	SELECT
		licenze.id,                         
    	licenze.id_tipologia,                
		tipologie_licenze.nome AS tipologia,               
		licenze.id_anagrafica,
		group_concat( DISTINCT coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) ) AS anagrafica,
		licenze.id_rivenditore,              
		group_concat( DISTINCT coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) ) AS rivenditore,
		licenze.codice,                      
		licenze.postazioni,                  
		licenze.nome,                        
		licenze.note,                        
		licenze.testo,                       
		licenze.giorni_validita,             
		licenze.giorni_rinnovo,
		min( rinnovi.data_inizio ) AS data_inizio,
		max( rinnovi.data_fine ) AS data_fine,
		max( rinnovi.id_contratto ) AS id_contratto,
		group_concat( DISTINCT tipologie_contratti.nome SEPARATOR ', ' ) AS tipologia_contratto,
		group_concat( DISTINCT concat_ws( '§', software.codice, software.nome ) SEPARATOR ' | ' ) AS software,
		licenze.timestamp_distribuzione,     
		licenze.timestamp_inizio,            
		licenze.timestamp_fine,              
		licenze.id_account_inserimento,      
		licenze.id_account_aggiornamento,    
		licenze.nome AS __label__
	FROM licenze
		LEFT JOIN tipologie_licenze ON tipologie_licenze.id = licenze.id_tipologia
		LEFT JOIN rinnovi ON rinnovi.id_licenza = licenze.id
		LEFT JOIN licenze_software ON licenze_software.id_licenza = licenze.id
		LEFT JOIN software ON software.id = licenze_software.id_software
		LEFT JOIN contratti ON contratti.id = rinnovi.id_contratto
		LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
		LEFT JOIN contratti_anagrafica ON ( contratti_anagrafica.id_contratto = contratti.id AND contratti_anagrafica.id_ruolo IN ( 32 ) )
		LEFT JOIN anagrafica AS a1 ON a1.id = coalesce( licenze.id_anagrafica, contratti_anagrafica.id_anagrafica )
		LEFT JOIN anagrafica AS a2 ON a2.id = licenze.id_rivenditore
	GROUP BY licenze.id
;

-- | 090000016701

-- licenze_software_view
-- tipologia: tabella gestita
-- verifica: 2021-11-16 15:30 Chiara GDL
CREATE OR REPLACE VIEW licenze_software_view AS
	SELECT
		licenze_software.id,
		licenze_software.id_licenza,
		licenze_software.id_software,
		licenze_software.id_account_inserimento,
		licenze_software.id_account_aggiornamento,
		concat( licenze.nome, ' | ', software.nome ) AS __label__
	FROM licenze_software
		LEFT JOIN software ON software.id = licenze_software.id_software
		LEFT JOIN licenze ON licenze.id = licenze_software.id_licenza
;

-- | 090000016800

-- lingue_view
CREATE OR REPLACE VIEW lingue_view AS                         --
  SELECT                                                      --
    lingue.id,                                                --
    lingue.nome,                                              --
    lingue.iso6391alpha2,                                     --
    lingue.iso6393alpha3,                                     --
    lingue.ietf,                                              --
    lingue.nome AS __label__                                  -- etichetta per le tendine e le liste
  FROM lingue                                                 --
  ;                                                           --

-- | 090000017001

-- liste_view
-- tipolgia: tabella gestita
-- verifica: 2022-02-07 15:47 Chiara GDL
CREATE OR REPLACE VIEW `liste_view` AS
	SELECT
	liste.id,
	liste.nome,
	liste.nome AS __label__
	FROM liste
;

-- | 090000017101

-- liste_mail_view
-- tipolgia: tabella gestita
-- verifica: 2022-02-07 15:47 Chiara GDL
CREATE OR REPLACE VIEW `liste_mail_view` AS
	SELECT
	liste_mail.id,
	liste_mail.id_lista,
	liste.nome AS lista,
	liste_mail.id_mail,
	mail.indirizzo AS mail,
	mail.id_anagrafica,
	coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
	a1.nome AS anagrafica_nome,
	a1.cognome AS anagrafica_cognome,
	a1.denominazione AS anagrafica_denominazione,
	a1.codice_fiscale AS anagrafica_codice_fiscale,
	a1.codice AS anagrafica_codice,
	concat( liste_mail.id_lista, liste_mail.id_mail ) AS __label__
	FROM liste_mail
	INNER JOIN liste ON liste.id = liste_mail.id_lista
	INNER JOIN mail ON mail.id = liste_mail.id_mail
	LEFT JOIN anagrafica AS a1 ON a1.id = mail.id_anagrafica
;

-- | 090000017200

-- listini_view
CREATE OR REPLACE VIEW `listini_view` AS
	SELECT
		listini.id,
		listini.id_valuta,
		listini.id_tipologia,
		tipologie_listini_path( listini.id_tipologia ) AS tipologia,
		valute.iso4217 AS valuta,
		listini.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		listini.nome,
		listini.data_archiviazione,
		listini.id_account_inserimento,
		listini.id_account_aggiornamento,
		concat(
			listini.nome,
			' ',
			valute.iso4217
		) AS __label__
	FROM listini
		LEFT JOIN valute ON valute.id = listini.id_valuta
		LEFT JOIN anagrafica AS a1 ON a1.id = listini.id_emittente
;

-- | 090000017401

-- listini_clienti_view
-- tipologia: tabella gestita
-- verifica: 2021-09-24 18:20 Fabio Mosti
CREATE OR REPLACE VIEW `listini_clienti_view` AS
	SELECT
		listini_clienti.id,
		listini_clienti.id_listino,
		concat( listini.nome, ' ', valute.iso4217 ) AS listino,
		listini_clienti.id_cliente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS cliente,
		listini_clienti.ordine,
		listini_clienti.id_account_inserimento,
		listini_clienti.id_account_aggiornamento,
		concat(
			listini.nome,
			' ',
			valute.iso4217,
			' / ',
			coalesce(
				a1.denominazione,
				concat(
					a1.cognome,
					' ',
					a1.nome
				), ''
			)
		) AS __label__
	FROM listini_clienti
		LEFT JOIN listini ON listini.id = listini_clienti.id_listino
		LEFT JOIN valute ON valute.id = listini.id_valuta
		LEFT JOIN anagrafica AS a1 ON a1.id = listini_clienti.id_cliente
;

-- | 090000017491

-- listini_zone_view
-- tipologia: tabella gestita
-- verifica: 2021-09-24 18:20 Fabio Mosti
CREATE OR REPLACE VIEW `listini_zone_view` AS
	SELECT
		listini_zone.id,
		listini_zone.id_listino,
		concat( listini.nome, ' ', valute.iso4217 ) AS listino,
		listini_zone.id_zona,
		zone.nome AS zona,
		listini_zone.ordine,
		listini_zone.id_account_inserimento,
		listini_zone.id_account_aggiornamento,
		concat(
			listini.nome,
			' ',
			valute.iso4217,
			' / ',
			zone.nome
		) AS __label__
	FROM listini_zone
		LEFT JOIN listini ON listini.id = listini_zone.id_listino
		LEFT JOIN valute ON valute.id = listini.id_valuta
		LEFT JOIN zone ON zone.id = listini_zone.id_zona
;

-- | 090000018001

-- luoghi_view
-- tipologia: tabella gestita
-- verifica: 2021-09-24 18:49 Fabio Mosti
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

-- | 090000018200

-- macro_view
-- tipologia: tabella gestita
-- verifica: 2021-09-24 19:40 Fabio Mosti
CREATE OR REPLACE VIEW `macro_view` AS
	SELECT
		macro.id,
		macro.id_pagina,
		macro.id_prodotto,
		macro.id_articolo,
		macro.id_categoria_prodotti,
		macro.id_notizia,
		macro.id_annuncio,
		macro.id_categoria_notizie,
		macro.id_categoria_annunci,
		macro.id_risorsa,
		macro.id_categoria_risorse,
		macro.id_progetto,
		macro.id_categoria_progetti,
		macro.id_pianificazione,
		macro.ordine,
		macro.macro,
		macro.macro AS __label__
	FROM macro
;

-- | 090000018600

-- mail_view
CREATE OR REPLACE VIEW `mail_view` AS                         --
	SELECT                                                    --
		mail.id,                                              --
		mail.id_anagrafica,                                   --
		coalesce(                                             --
            a1.denominazione,                                 --
            concat( a1.cognome, ' ', a1.nome ), ''            --
        ) AS anagrafica,                                      -- denominazione o cognome e nome dell'anagrafica
		mail.indirizzo,                                       --
		mail.se_notifiche,                                    --
		mail.se_pec,                                          --
		mail.server,                                          --
		mail.id_account_inserimento,                          --
		mail.id_account_aggiornamento,                        --
		concat(                                               --
			coalesce(                                         --
                a1.denominazione,                             --
                concat( a1.cognome, ' ', a1.nome ), ''        --
            ),                                                --
			' ',                                              --
			mail.indirizzo                                    --
		) AS __label__                                        -- etichetta per le tendine e le liste
	FROM mail                                                 --
		LEFT JOIN anagrafica AS a1                            --
            ON a1.id = mail.id_anagrafica                     --
;                                                             --

-- | 090000018800

-- mail_out_view
CREATE OR REPLACE VIEW `mail_out_view` AS
	SELECT
		mail_out.id,
		mail_out.id_mail,
		mail_out.id_mailing,
		mail_out.ordine,
		mail_out.timestamp_composizione,
		mail_out.mittente,
		mail_out.destinatari,
		mail_out.destinatari_cc,
		mail_out.destinatari_bcc,
		mail_out.oggetto,
		mail_out.allegati,
		mail_out.headers,
		mail_out.server,
		mail_out.host,
		mail_out.port,
		mail_out.user,
		mail_out.password,
		mail_out.token,
		mail_out.tentativi,
		mail_out.timestamp_invio,
		from_unixtime( mail_out.timestamp_invio, '%Y-%m-%d' ) AS data_ora_invio,
		mail_out.id_account_inserimento,
		mail_out.id_account_aggiornamento,
		concat(
			mail_out.id,
			' / ',
			mail_out.oggetto,
			if( mail_out.token = 'TROPPI_TENTATIVI', concat( ' ( ferma dopo ', mail_out.tentativi, ' tentativi )' ), '' )
		) AS __label__
	FROM mail_out
;

-- | 090000018900

-- mail_sent_view
CREATE OR REPLACE VIEW `mail_sent_view` AS
	SELECT
		mail_sent.id,
		mail_sent.id_mail,
		mail_sent.id_mailing,
		mail_sent.ordine,
		mail_sent.timestamp_composizione,
		mail_sent.mittente,
		mail_sent.destinatari,
		mail_sent.destinatari_cc,
		mail_sent.destinatari_bcc,
		mail_sent.oggetto,
		mail_sent.allegati,
		mail_sent.headers,
		mail_sent.server,
		mail_sent.host,
		mail_sent.port,
		mail_sent.user,
		mail_sent.password,
		mail_sent.token,
		mail_sent.tentativi,
		mail_sent.timestamp_invio,
		from_unixtime( mail_sent.timestamp_invio, '%Y-%m-%d' ) AS data_ora_invio,
		mail_sent.id_account_inserimento,
		mail_sent.id_account_aggiornamento,
		concat(
			mail_sent.id,
			' / ',
			mail_sent.oggetto
		) AS __label__
	FROM mail_sent
;

-- | 090000018901

-- mail_status_view
CREATE OR REPLACE VIEW `mail_status_view` AS
	SELECT
		mail_status.id,
		mail_status.indirizzo,
		mail_status.dominio,
		mail_status.id_tipologia,
		tipologie_mail_status.nome AS tipologia,
		mail_status.stato,
		mail_status.motivo,
		mail_status.punteggio,
		mail_status.se_accept_all,
		mail_status.se_ruolo,
		mail_status.se_temporanea,
		mail_status.se_gratuita,
		mail_status.tentativi,
		mail_status.id_account_inserimento,
		mail_status.id_account_aggiornamento,
		concat_ws(
			' ',
			mail_status.indirizzo,
			tipologie_mail_status.nome
		) AS __label__
	FROM mail_status
		LEFT JOIN tipologie_mail_status ON tipologie_mail_status.id = mail_status.id_tipologia
;

-- | 090000019001

-- mailing_view
-- tipolgia: tabella gestita
-- verifica: 2022-02-07 15:47 Chiara GDL
CREATE OR REPLACE VIEW `mailing_view` AS
	SELECT
	mailing.id,
	mailing.nome,
	mailing.timestamp_invio,
	mailing.id_account_inserimento,
	mailing.id_account_aggiornamento,
	mailing.nome AS __label__
	FROM mailing
;

-- | 090000019051

-- mailing_liste_view
-- tipolgia: tabella gestita
-- verifica: 2022-02-07 15:47 Chiara GDL
CREATE OR REPLACE VIEW `mailing_liste_view` AS
	SELECT
	mailing_liste.id,
	mailing_liste.id_lista,
	mailing_liste.id_mailing,
	concat( mailing_liste.id_lista, mailing_liste.id_mailing ) AS __label__
	FROM mailing_liste
;

-- | 090000019101

-- mailing_mail_view
-- tipolgia: tabella gestita
-- verifica: 2022-02-07 15:47 Chiara GDL
CREATE OR REPLACE VIEW `mailing_mail_view` AS
	SELECT
		mailing_mail.id,
		mailing_mail.id_mailing,
		mailing.nome AS mailing,
		mailing_mail.id_mail,
		mail.indirizzo AS mail,
		mail.id_anagrafica,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		mailing_mail.id_mail_out,
		mailing_mail.timestamp_generazione,
		from_unixtime( mailing_mail.timestamp_generazione, '%Y-%m-%d' ) AS data_ora_generazione,
		mailing_mail.timestamp_invio,
		from_unixtime( mailing_mail.timestamp_invio, '%Y-%m-%d' ) AS data_ora_invio,
		concat(mailing_mail.id_mailing  , " | ", mailing_mail.id_mail , " | ", mailing_mail.id_mail_out) AS __label__
	FROM mailing_mail
		INNER JOIN mailing ON mailing.id = mailing_mail.id_mailing
		INNER JOIN mail ON mail.id = mailing_mail.id_mail
		LEFT JOIN anagrafica AS a1 ON a1.id = mail.id_anagrafica
;

-- | 090000020200

-- marchi_view
CREATE OR REPLACE VIEW `marchi_view` AS
	SELECT
		marchi.id,
		marchi.id_produttore,
		produttori.denominazione AS produttore,
		marchi.nome,
		marchi.data_archiviazione,
		marchi.nome AS __label__
	FROM marchi
	LEFT JOIN anagrafica AS produttori ON produttori.id = marchi.id_produttore
;

-- | 090000020601

-- mastri_view
-- tipologia: tabella gestita
-- verifica: 2021-09-29 11:43 Fabio Mosti
CREATE OR REPLACE VIEW `mastri_view` AS
	SELECT
		mastri.id,
		mastri.id_tipologia,
		tipologie_mastri.nome AS tipologia,
        mastri.codice,
		mastri.id_anagrafica_indirizzi,
		concat_ws(
			' ',
			tipologie_indirizzi.nome,
			indirizzi.indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) AS indirizzo,
		coalesce( mastri.id_anagrafica, anagrafica_indirizzi.id_anagrafica ) AS id_anagrafica,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), a2.denominazione, concat( a2.cognome, ' ', a2.nome ), '' ) AS anagrafica,
		mastri.id_account,
		account.username AS account,
		mastri.id_progetto,
		progetti.nome AS progetto,
		mastri.nome,
		tipologie_mastri.se_magazzino,
		tipologie_mastri.se_conto,
		tipologie_mastri.se_registro,
		concat_ws( ' ', mastri.codice, mastri_path( mastri.id ) ) AS __label__
	FROM mastri
		LEFT JOIN tipologie_mastri ON tipologie_mastri.id = mastri.id_tipologia
		LEFT JOIN anagrafica_indirizzi ON anagrafica_indirizzi.id = mastri.id_anagrafica_indirizzi
		LEFT JOIN anagrafica AS a1 ON a1.id = anagrafica_indirizzi.id_anagrafica
		LEFT JOIN anagrafica AS a2 ON a2.id = mastri.id_anagrafica
		LEFT JOIN account ON account.id = mastri.id_account
		LEFT JOIN progetti ON progetti.id = mastri.id_progetto
		LEFT JOIN indirizzi ON indirizzi.id = anagrafica_indirizzi.id_indirizzo
		LEFT JOIN tipologie_indirizzi ON tipologie_indirizzi.id = indirizzi.id_tipologia
		LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
;

-- | 090000020602

-- mastri_articoli_view
CREATE OR REPLACE VIEW `mastri_articoli_view` AS
	SELECT
		mastri_articoli.id,
		mastri_articoli.ordine,
		mastri_articoli.codice,
		mastri_articoli.id_mastro,
		mastri_path( mastri_articoli.id_mastro ) AS mastro,
		mastri_articoli.id_articolo,
		concat_ws( ' ', prodotti.nome, articoli.nome ) AS articolo,
		mastri_articoli.scorta_minima,
		mastri_articoli.scorta_massima,
		mastri_articoli.id_udm,
		udm.sigla AS udm,
		mastri_articoli.id_account_inserimento,
		mastri_articoli.id_account_aggiornamento,
		concat_ws(
			' / ',
			mastri_path( mastri_articoli.id_mastro ),
			concat_ws( ' ', prodotti.nome, articoli.nome )
		) AS __label__
	FROM mastri_articoli
		LEFT JOIN articoli ON articoli.id = mastri_articoli.id_articolo
		LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
		LEFT JOIN udm ON udm.id = mastri_articoli.id_udm
;

-- | 090000020800

-- mastri_tipologie_veicoli_view
-- la tabella associa a un mastro una TIPOLOGIA di veicolo, non un veicolo: il join era su
-- `veicoli` e faceva combaciare l'id_tipologia con un id di veicolo, restituendo una targa a
-- caso o NULL ( e la maschera, che riempie la tendina da tipologie_veicoli, scriveva altro )
-- la colonna `tipologie` porta su OGNI riga l'elenco completo delle tipologie associate a quel
-- mastro, separate da virgola: serve agli elenchi, dove interessa sapere con che mezzi si arriva
-- a una collocazione senza doverne leggere le righe una per una. La grana della vista resta
-- quella della tabella ( una riga per associazione, GROUP BY sulla chiave primaria ) perche' il
-- controller standard fa SELECT * FROM <tabella>_view WHERE id = ? per caricare il record
CREATE OR REPLACE VIEW `mastri_tipologie_veicoli_view` AS
    SELECT
        mastri_tipologie_veicoli.id,
        mastri_tipologie_veicoli.id_mastro,
        mastri_path( mastri_tipologie_veicoli.id_mastro ) AS mastro,
        mastri_tipologie_veicoli.id_tipologia,
        tipologie_veicoli_path( mastri_tipologie_veicoli.id_tipologia ) AS tipologia,
        group_concat(
            DISTINCT tipologie_veicoli_path( altre.id_tipologia )
            ORDER BY tipologie_veicoli_path( altre.id_tipologia )
            SEPARATOR ', '
        ) AS tipologie,
        mastri_tipologie_veicoli.id_account_inserimento,
        mastri_tipologie_veicoli.id_account_aggiornamento,
        concat_ws(
            ' / ',
            mastri_path( mastri_tipologie_veicoli.id_mastro ),
            group_concat(
                DISTINCT tipologie_veicoli_path( altre.id_tipologia )
                ORDER BY tipologie_veicoli_path( altre.id_tipologia )
                SEPARATOR ', '
            )
        ) AS __label__
    FROM mastri_tipologie_veicoli
    LEFT JOIN mastri_tipologie_veicoli AS altre ON altre.id_mastro = mastri_tipologie_veicoli.id_mastro
    GROUP BY mastri_tipologie_veicoli.id
;

-- | 090000021001

-- matricole_view
-- tipologia: tabella gestita
-- verifica: 2021-12-28 16:20 Chiara GDL
CREATE OR REPLACE VIEW `matricole_view` AS
	SELECT
		matricole.id,
		matricole.id_produttore,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS produttore,
		matricole.id_marchio,
		marchi.nome AS marchio,
		matricole.id_articolo,
		concat_ws(
			' ',
			articoli.id,
			prodotti.nome,
			articoli.nome,
			coalesce(
				concat(
					articoli.larghezza, 'x', articoli.lunghezza, 'x', articoli.altezza,
					udm_dimensioni.sigla
				),
				concat(
					articoli.peso,
					udm_peso.sigla
				),
				concat(
					articoli.volume,
					udm_volume.sigla
				),
				concat(
					articoli.capacita,
					udm_capacita.sigla
				),
				concat(
					articoli.durata,
					udm_durata.sigla
				),
				''
			)
		) AS articolo,
		matricole.matricola,
		matricole.data_scadenza,
		matricole.nome,
		concat_ws(
			' ',
			matricole.matricola,
			'/',
			articoli.id,
			'/',
			prodotti.nome,
			articoli.nome,
			coalesce(
				concat(
					articoli.larghezza, 'x', articoli.lunghezza, 'x', articoli.altezza,
					udm_dimensioni.sigla
				),
				concat(
					articoli.peso,
					udm_peso.sigla
				),
				concat(
					articoli.volume,
					udm_volume.sigla
				),
				concat(
					articoli.capacita,
					udm_capacita.sigla
				),
				concat(
					articoli.durata,
					udm_durata.sigla
				),
				''
			),
			concat( 'scad. ', matricole.data_scadenza )
		) AS __label__
	FROM matricole
		LEFT JOIN anagrafica AS a1 ON a1.id = matricole.id_produttore
		LEFT JOIN marchi ON marchi.id = matricole.id_marchio
		LEFT JOIN articoli ON articoli.id = id_articolo
		LEFT JOIN udm AS udm_dimensioni ON udm_dimensioni.id = articoli.id_udm_dimensioni
		LEFT JOIN udm AS udm_peso ON udm_peso.id = articoli.id_udm_peso
		LEFT JOIN udm AS udm_volume ON udm_volume.id = articoli.id_udm_volume
		LEFT JOIN udm AS udm_capacita ON udm_capacita.id = articoli.id_udm_capacita
		LEFT JOIN udm AS udm_durata ON udm_durata.id = articoli.id_udm_durata
		LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
;

-- | 090000021600

-- menu_view
CREATE OR REPLACE VIEW `menu_view` AS                           --
    SELECT                                                      --
		menu.id,                                                --
		pagine.id_sito,                                    		--
		menu.id_lingua,                                         --
		menu.id_pagina,                                         --
		menu.id_categoria_prodotti,                             --
		menu.id_categoria_notizie,                              --
		menu.id_categoria_annunci,                              --
		menu.id_categoria_risorse,                              --
		menu.id_categoria_progetti,                             --
		menu.ordine,                                            --
		menu.menu,                                              --
		menu.nome,                                              --
		menu.target,                                            --
		menu.ancora,                                            --
		menu.sottopagine,                                       --
		menu.id_account_inserimento,                            --
		menu.id_account_aggiornamento,                          --
		concat_ws(                                              --
			' / ',                                              --
			menu.menu,                                          --
			menu.ordine,                                        --
			lingue.ietf,                                        --
			menu.nome                                           --
		) AS __label__                                          -- etichetta per le tendine e le liste
    FROM menu                                                   --
		INNER JOIN lingue                                       --
            ON lingue.id = menu.id_lingua                       --
		LEFT JOIN pagine ON pagine.id = menu.id_pagina         	--
;                                                               --

-- | 090000021701

-- messaggi_view
-- tipologia: tabella gestita
-- verifica: 2022-04-26 17:32 Chiara GDL
CREATE OR REPLACE VIEW `messaggi_view` AS
	SELECT
		messaggi.id,
		messaggi.id_conversazione,
		messaggi.testo,
		messaggi.timestamp_invio,
		messaggi.timestamp_lettura,
		messaggi.id_account_inserimento,
		messaggi.timestamp_inserimento,
		messaggi.id_account_aggiornamento,
		messaggi.timestamp_aggiornamento,
		concat( 'messaggio #', messaggi.id )AS __label__
	FROM messaggi
;

-- | 090000021800

-- metadati_view
CREATE OR REPLACE VIEW `metadati_view` AS
	SELECT
		metadati.id,
		metadati.id_lingua,
		lingue.ietf,
		metadati.id_anagrafica,
		metadati.id_account,
		metadati.id_pagina,
		metadati.id_prodotto,
		metadati.id_articolo,
		metadati.id_categoria_prodotti,
		metadati.id_notizia,
		metadati.id_annuncio,
		metadati.id_categoria_notizie,
		metadati.id_categoria_annunci,
		metadati.id_risorsa,
		metadati.id_categoria_risorse,
		metadati.id_immagine,
		metadati.id_video,
		metadati.id_audio,
		metadati.id_file,
		metadati.id_documento,
		metadati.id_documenti_articoli,
		metadati.id_progetto,
		metadati.id_categoria_progetti,
		metadati.id_indirizzo,
		metadati.id_edificio,
		metadati.id_immobile,
		metadati.id_contratto,
        metadati.id_valutazione,
        metadati.id_rinnovo,
        metadati.id_tipologia_attivita,
		metadati.id_banner,
		metadati.id_pianificazione,
		metadati.id_tipologia_todo,
		metadati.id_tipologia_contratti,
		metadati.id_account_inserimento,
		metadati.id_account_aggiornamento,
		metadati.nome,
		metadati.testo,
		concat(
			metadati.nome,
			':',
			metadati.testo
		) AS __label__
	FROM metadati
		LEFT JOIN lingue ON lingue.id = metadati.id_lingua
;

-- | 090000021801

-- metadati_articoli_view
CREATE OR REPLACE VIEW `metadati_articoli_view` AS
	SELECT
		metadati_articoli.id,
		metadati_articoli.id_lingua,
		lingue.nome AS lingua,
		metadati_articoli.id_articolo,
		concat_ws( ' ', prodotti.nome, articoli.nome ) AS articolo,
		metadati_articoli.nome,
		metadati_articoli.id_account_inserimento,
		metadati_articoli.id_account_aggiornamento,
		concat_ws(
			' / ',
			concat_ws( ' ', prodotti.nome, articoli.nome ),
			metadati_articoli.nome
		) AS __label__
	FROM metadati_articoli
		LEFT JOIN lingue ON lingue.id = metadati_articoli.id_lingua
		LEFT JOIN articoli ON articoli.id = metadati_articoli.id_articolo
		LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
;

-- | 090000021802

-- metadati_prodotti_view
CREATE OR REPLACE VIEW `metadati_prodotti_view` AS
	SELECT
		metadati_prodotti.id,
		metadati_prodotti.id_lingua,
		lingue.nome AS lingua,
		metadati_prodotti.id_prodotto,
		prodotti.nome AS prodotto,
		metadati_prodotti.nome,
		metadati_prodotti.id_account_inserimento,
		metadati_prodotti.id_account_aggiornamento,
		concat_ws(
			' / ',
			prodotti.nome,
			metadati_prodotti.nome
		) AS __label__
	FROM metadati_prodotti
		LEFT JOIN lingue ON lingue.id = metadati_prodotti.id_lingua
		LEFT JOIN prodotti ON prodotti.id = metadati_prodotti.id_prodotto
;

-- | 090000021900

-- modalita_pagamento
CREATE OR REPLACE VIEW `modalita_pagamento_view` AS
    SELECT
    modalita_pagamento.id,
    modalita_pagamento.nome,
    modalita_pagamento.codice,
    modalita_pagamento.provider,
    concat( modalita_pagamento.codice,' - ', modalita_pagamento.nome) AS __label__
    FROM modalita_pagamento
;

-- | 090000021951

-- modalita_spedizione
CREATE OR REPLACE VIEW `modalita_spedizione_view` AS
	SELECT
		modalita_spedizione.id,
		modalita_spedizione.id_tipologia,
		modalita_spedizione.id_zona,
		zone.nome AS zona,
		modalita_spedizione.id_categoria_prodotti,
		modalita_spedizione.id_prodotto,
		modalita_spedizione.id_articolo,
		modalita_spedizione.lotto_spedizione,
		modalita_spedizione.importo_netto,
		modalita_spedizione.id_valuta,
		valute.utf8 AS valuta,
		modalita_spedizione.id_iva,
		iva.nome AS iva,
		modalita_spedizione.giorni_spedizione,
		modalita_spedizione.giorni_consegna,
		concat( zone.nome, ' - ', coalesce( prodotti.codice, articoli.codice, modalita_spedizione.id_prodotto, modalita_spedizione.id_articolo ) ) AS __label__
	FROM modalita_spedizione
		LEFT JOIN prodotti ON prodotti.id = modalita_spedizione.id_prodotto
		LEFT JOIN articoli ON articoli.id = modalita_spedizione.id_articolo
		LEFT JOIN zone ON zone.id = modalita_spedizione.id_zona
		LEFT JOIN iva ON iva.id = modalita_spedizione.id_iva
		LEFT JOIN valute ON valute.id = modalita_spedizione.id_valuta
;

-- | 090000022000

-- notizie_view
CREATE OR REPLACE VIEW `notizie_view` AS
	SELECT
		notizie.id,
		notizie.id_tipologia,
		tipologie_notizie.nome AS tipologia,
		notizie.nome,
		group_concat( categorie_notizie.nome SEPARATOR '|' ) AS categorie,
        notizie.data_archiviazione,
		notizie.id_account_inserimento,
		notizie.id_account_aggiornamento,
		notizie.nome AS __label__
	FROM notizie
		LEFT JOIN tipologie_notizie ON tipologie_notizie.id = notizie.id_tipologia
		LEFT JOIN notizie_categorie ON notizie_categorie.id_notizia = notizie.id
		LEFT JOIN categorie_notizie ON categorie_notizie.id = notizie_categorie.id_categoria
	GROUP BY notizie.id
;

-- | 090000022100

-- notizie_anagrafica_view
CREATE OR REPLACE VIEW `notizie_anagrafica_view` AS
	SELECT
		notizie_anagrafica.id,
		notizie_anagrafica.id_notizia,
		notizie.nome AS notizia,
		notizie_anagrafica.id_anagrafica,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		notizie_anagrafica.id_ruolo,
		ruoli_anagrafica.nome AS ruolo,
		notizie_anagrafica.ordine,
		notizie_anagrafica.id_account_inserimento,
		notizie_anagrafica.id_account_aggiornamento,
		concat(                                               --
			coalesce(                                         --
                a1.denominazione,                             --
                concat( a1.cognome, ' ', a1.nome ),           --
                ''                                            --
            ),                                                --
			' / ',                                            --
			notizie.nome                                 --
		) AS __label__         
	FROM notizie_anagrafica
		LEFT JOIN notizie ON notizie.id = notizie_anagrafica.id_notizia
		LEFT JOIN anagrafica AS a1 ON a1.id = notizie_anagrafica.id_anagrafica
		LEFT JOIN ruoli_anagrafica ON ruoli_anagrafica.id = notizie_anagrafica.id_ruolo
	GROUP BY notizie_anagrafica.id
;

-- | 090000022201

-- notizie_categorie_view
CREATE OR REPLACE VIEW `notizie_categorie_view` AS
	SELECT
		notizie_categorie.id,
		notizie_categorie.id_notizia,
		notizie.nome AS notizia,
		notizie_categorie.id_categoria,
		categorie_notizie_path( notizie_categorie.id_categoria ) AS categoria,
		notizie_categorie.ordine,
		notizie_categorie.id_account_inserimento,
		notizie_categorie.id_account_aggiornamento,
		concat(
			notizie.nome,
			' / ',
			categorie_notizie_path( notizie_categorie.id_categoria )
		) AS __label__
	FROM notizie_categorie
		LEFT JOIN notizie ON notizie.id = notizie_categorie.id_notizia
;

-- | 090000022250

-- offerte_view
-- tutte le offerte, emesse e ricevute ( decisione di Fabio, 03/10/2026 ); ricavata il 2026-10-04 dalla vecchia
-- offerte_attive_view ( tolta dal canone in d975b4a15 ) togliendo il filtro sull'emittente gestito, che adesso
-- applica l'elenco ( _offerte.commerciale.view.php ); materializzata in offerte_view_static
CREATE OR REPLACE VIEW `offerte_view` AS
    SELECT
		documenti.id,
		documenti.id_tipologia,
		tipologie_documenti.nome AS tipologia,
		documenti.codice,
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
			documenti.nome,
			' ',
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
   	WHERE tipologie_documenti.se_offerta IS NOT NULL
;

-- | 090000022301

-- orari_view
CREATE OR REPLACE VIEW `orari_view` AS
	SELECT
		orari.id,
		orari.nome,
		orari.id_tipologia_contratti,
		orari.id_periodicita,
		orari.id_giorno,
		orari.ora_inizio,
		orari.ora_fine,
		orari.nome AS __label__
	FROM orari
;

-- | 090000022401

-- orari_contratti_view
-- ripristinata il 2026-09-30 dallo schema del 2021 ( _usr/_database/mysql.schema.sql, 0e99bca51 )
CREATE OR REPLACE VIEW `orari_contratti_view` AS
	SELECT
		orari_contratti.id,
		orari_contratti.id_contratto,
		orari_contratti.turno,
		orari_contratti.id_giorno,
		orari_contratti.ora_inizio,
		orari_contratti.ora_fine,
		orari_contratti.id_costo,
		orari_contratti.se_lavoro,
		orari_contratti.se_disponibile,
		concat(
			'turno ', orari_contratti.turno, ' ',
			orari_contratti.id_giorno, ' ',
			orari_contratti.ora_inizio, ' ',
			orari_contratti.ora_fine
		) AS __label__
	FROM orari_contratti
;

-- | 090000022801

-- organizzazioni_view
-- tipologia: tabella gestita
-- verifica: 2021-10-01 13:10 Fabio Mosti
CREATE OR REPLACE VIEW `organizzazioni_view` AS
	SELECT
		organizzazioni.id,
		organizzazioni.id_genitore,
		organizzazioni.ordine,
		organizzazioni.id_anagrafica,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		organizzazioni.id_ruolo,
		ruoli_anagrafica.nome AS ruolo,
		organizzazioni.id_account_inserimento,
		organizzazioni.id_account_aggiornamento,
		concat_ws(
			' ',
			organizzazioni_path( organizzazioni.id ),
			ruoli_anagrafica.nome,
			coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' )
		) AS __label__
	FROM organizzazioni
		LEFT JOIN anagrafica AS a1 ON a1.id = organizzazioni.id_anagrafica
		LEFT JOIN ruoli_anagrafica ON ruoli_anagrafica.id = organizzazioni.id_ruolo
;

-- | 090000023100

-- pagamenti_view
CREATE OR REPLACE VIEW `pagamenti_view` AS
	SELECT
		pagamenti.id,
		coalesce( pagamenti.id_tipologia, documenti.id_tipologia ) AS id_tipologia,
		pagamenti.codice,
		pagamenti.id_modalita_pagamento,
		concat(modalita_pagamento.codice, ' - ' ,modalita_pagamento.nome) AS modalita_pagamento,
		tipologie_pagamenti.nome AS tipologia,
		pagamenti.ordine,
		pagamenti.nome,
		pagamenti.note,
		pagamenti.note_pagamento,
		coalesce( pagamenti.id_documento, carrelli.id_documento, documenti_articoli.id_documento ) AS id_documento,
		pagamenti.id_carrello,
		pagamenti.id_carrelli_articoli,
        concat(
			tipologie_documenti.sigla,
			' ',
			documenti.numero,
			'/',
			year( documenti.data ),
			' del ',
			documenti.data
		) AS documento,
		tipologie_documenti.id AS id_tipologia_documento,
		group_concat( DISTINCT carrelli_articoli.id_articolo SEPARATOR '|' ) AS id_articoli,
		group_concat( DISTINCT COALESCE( categorie_progetti.id, cp_disc.id ) SEPARATOR '|' ) AS id_categorie_progetti,
		group_concat( DISTINCT COALESCE( categorie_progetti.nome, cp_disc.nome ) SEPARATOR '|' ) AS categorie_progetti,
		group_concat( DISTINCT COALESCE( categorie_progetti_path_find_ancestor( categorie_progetti.id ), categorie_progetti_path_find_ancestor( cp_disc.id ) ) ) AS id_aree,
		group_concat( DISTINCT COALESCE( aree.nome, aree_abb.nome ) ) AS aree,
		group_concat( DISTINCT concat( pagamenti.id_coupon, ':', pagamenti.coupon_valore ) SEPARATOR '|' ) AS dettagli_coupon,
		pagamenti.id_mastro_provenienza,
		m1.nome AS mastro_provenienza,
		pagamenti.id_mastro_destinazione,
		m2.nome AS mastro_destinazione,
		coalesce( documenti.id_emittente, pagamenti.id_creditore ) AS id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		coalesce( documenti.id_destinatario, pagamenti.id_debitore ) AS id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		pagamenti.id_iban,
		iban.iban AS iban,
		pagamenti.importo_lordo_totale,
		pagamenti.id_coupon,
		pagamenti.coupon_valore,
		pagamenti.importo_lordo_finale,
		pagamenti.id_listino,
		listini.nome AS listino,
		pagamenti.id_pianificazione,
		pagamenti.data_scadenza,
		day( pagamenti.data_scadenza ) as giorno_scadenza,
		month( pagamenti.data_scadenza ) as mese_scadenza,
		year( pagamenti.data_scadenza ) as anno_scadenza,
        documenti.data_archiviazione,
		pagamenti.timestamp_pagamento,
		from_unixtime( pagamenti.timestamp_pagamento, '%Y-%m-%d' ) AS data_ora_pagamento,
		day( from_unixtime( pagamenti.timestamp_pagamento, '%Y-%m-%d' ) ) as giorno_pagamento,
		month( from_unixtime( pagamenti.timestamp_pagamento, '%Y-%m-%d' ) ) as mese_pagamento,
		year( from_unixtime( pagamenti.timestamp_pagamento, '%Y-%m-%d' ) ) as anno_pagamento,
		pagamenti.id_account_inserimento,
		pagamenti.id_account_aggiornamento,
		pagamenti.nome AS __label__
	FROM pagamenti
		LEFT JOIN tipologie_pagamenti ON tipologie_pagamenti.id = pagamenti.id_tipologia
		LEFT JOIN mastri AS m1 ON m1.id = pagamenti.id_mastro_provenienza
		LEFT JOIN mastri AS m2 ON m2.id = pagamenti.id_mastro_destinazione
		LEFT JOIN listini ON listini.id = pagamenti.id_listino
		LEFT JOIN modalita_pagamento ON modalita_pagamento.id = pagamenti.id_modalita_pagamento
		LEFT JOIN carrelli_articoli ON carrelli_articoli.id = pagamenti.id_carrelli_articoli
		LEFT JOIN carrelli ON carrelli.id = pagamenti.id_carrello
		LEFT JOIN documenti_articoli ON documenti_articoli.id_carrelli_articoli = carrelli_articoli.id
		LEFT JOIN documenti ON documenti.id = coalesce( pagamenti.id_documento, carrelli.id_documento, documenti_articoli.id_documento )
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
		LEFT JOIN anagrafica AS a1 ON a1.id = coalesce( documenti.id_emittente, pagamenti.id_creditore )
		LEFT JOIN anagrafica AS a2 ON a2.id = coalesce( documenti.id_destinatario, pagamenti.id_debitore )
		LEFT JOIN iban ON iban.id = pagamenti.id_iban
		LEFT JOIN coupon ON coupon.id = pagamenti.id_coupon
		LEFT JOIN contratti ON contratti.id = coupon.causale_id_contratto
		-- LEFT JOIN progetti ON progetti.id = contratti.id_progetto
		LEFT JOIN articoli ON articoli.id = carrelli_articoli.id_articolo
		LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
		LEFT JOIN progetti ON IF( prodotti.id IS NOT NULL, progetti.id_prodotto = prodotti.id, progetti.id = contratti.id_progetto )
		LEFT JOIN progetti_categorie ON progetti_categorie.id_progetto = progetti.id
		LEFT JOIN categorie_progetti ON ( categorie_progetti.id = progetti_categorie.id_categoria AND categorie_progetti.se_disciplina = 1 )
		LEFT JOIN categorie_progetti AS aree ON aree.id = categorie_progetti_path_find_ancestor( categorie_progetti.id )
		LEFT JOIN tipologie_contratti AS tc_abb ON tc_abb.id_prodotto = prodotti.id AND tc_abb.se_abbonamento = 1
		-- la disciplina dell'abbonamento è memorizzata come metadati 'abbonamento|discipline' (multi-valore), non su tipologie_contratti.id_categoria_progetti
		LEFT JOIN metadati AS m_abb_disc ON m_abb_disc.id_tipologia_contratti = tc_abb.id AND m_abb_disc.nome = 'abbonamento|discipline'
		LEFT JOIN categorie_progetti AS cp_disc ON cp_disc.id = CAST( m_abb_disc.testo AS UNSIGNED ) AND cp_disc.se_disciplina = 1
		LEFT JOIN categorie_progetti AS aree_abb ON aree_abb.id = categorie_progetti_path_find_ancestor( cp_disc.id )
--	WHERE
--		tipologie_documenti.se_fattura = 1
--		OR
--		tipologie_documenti.se_nota_credito = 1
--		OR
--		tipologie_documenti.se_ricevuta = 1
--		OR
--		tipologie_documenti.se_pro_forma = 1
	GROUP BY pagamenti.id
;

-- | 090000023200

-- pagine_view
CREATE OR REPLACE VIEW `pagine_view` AS						  --
	SELECT													  --
		pagine.id,							  				  --
		pagine.id_genitore,								  	  --
		pagine.id_sito,									  	  --
		pagine.nome,										  --
		pagine.template,									  --
		pagine.schema_html,								  	  --
		pagine.tema_css,									  --
		pagine.id_contenuti,							  	  --
		pagine.se_sitemap,								  	  --
		pagine.se_cacheable,							  	  --
		pagine.data_archiviazione,                            --
		pagine.id_account_inserimento,					  	  --
		pagine.id_account_aggiornamento,					  --
		pagine_path( pagine.id ) AS __label__			  	  -- etichetta per le tendine e le liste
	FROM pagine										  		  --
;

-- | 090000023501

-- periodi_view
-- tipologia: tabella di supporto
-- verifica: 2022-05-24 12:57 Chiara GDL
CREATE OR REPLACE VIEW `periodi_view` AS
	SELECT
		periodi.id,
		periodi.id_genitore,
		periodi.id_tipologia,
		periodi.id_contratto,
		tipologie_periodi_path( periodi.id_tipologia ) AS tipologia,
		periodi.data_inizio,
		periodi.data_fine,
		periodi.id_account_inserimento,
		periodi.id_account_aggiornamento,
		concat( periodi.nome, ' dal ',CONCAT_WS('-',periodi.data_inizio),' al ',CONCAT_WS('-',periodi.data_fine)) AS __label__
	FROM periodi;

-- | 090000023701

-- pesi_tipologie_corrispondenza_view
CREATE OR REPLACE VIEW `pesi_tipologie_corrispondenza_view` AS
	SELECT
		pesi_tipologie_corrispondenza.id,
		pesi_tipologie_corrispondenza.id_tipologia,
		tipologie_corrispondenza_path( pesi_tipologie_corrispondenza.id_tipologia ) AS tipologia,
		pesi_tipologie_corrispondenza.nome,
		pesi_tipologie_corrispondenza.grammi_min,
		pesi_tipologie_corrispondenza.grammi_max,
		concat_ws(
			' ',
			tipologie_corrispondenza_path( pesi_tipologie_corrispondenza.id_tipologia ),
			pesi_tipologie_corrispondenza.nome,
			'da',
			pesi_tipologie_corrispondenza.grammi_min,
			'a',
			pesi_tipologie_corrispondenza.grammi_max
		) AS __label__
	FROM pesi_tipologie_corrispondenza
;

-- | 090000023800

-- pianificazioni_view
CREATE OR REPLACE VIEW `pianificazioni_view` AS
	SELECT
		pianificazioni.id,
		pianificazioni.id_genitore,
		pianificazioni.id_progetto,
		pianificazioni.id_todo,
		pianificazioni.id_attivita,
		pianificazioni.id_contratto,
		pianificazioni.id_anagrafica,
		pianificazioni.nome,
		pianificazioni.note,
		pianificazioni.id_periodicita,
		periodicita.nome AS periodicita,
		pianificazioni.cadenza,
		pianificazioni.se_lunedi,
		pianificazioni.se_martedi,
		pianificazioni.se_mercoledi,
		pianificazioni.se_giovedi,
		pianificazioni.se_venerdi,
		pianificazioni.se_sabato,
		pianificazioni.se_domenica,
		pianificazioni.schema_ripetizione,
		pianificazioni.data_avvio,
		pianificazioni.data_inizio,
		pianificazioni.data_elaborazione,
		pianificazioni.timestamp_elaborazione,
		from_unixtime( pianificazioni.timestamp_elaborazione, '%Y-%m-%d %H:%i' ) AS data_ora_elaborazione,
		pianificazioni.data_ultimo_oggetto,
		pianificazioni.giorni_elaborazione,
		pianificazioni.giorni_estensione,
		pianificazioni.data_fine,
		pianificazioni.entita,
		pianificazioni.model_id_anagrafica,
		pianificazioni.model_id_anagrafica_programmazione,
		pianificazioni.model_id_articolo,
		pianificazioni.model_id_attivita,
		pianificazioni.model_id_causale,
		pianificazioni.model_id_cliente,
		pianificazioni.model_id_collo,
		pianificazioni.model_id_condizione_pagamento,
		pianificazioni.model_id_contatto,
		pianificazioni.model_id_coupon,
		pianificazioni.model_id_destinatario,
		pianificazioni.model_id_documento,
		pianificazioni.model_id_emittente,
		pianificazioni.model_id_genitore,
		pianificazioni.model_id_iban,
		pianificazioni.model_id_indirizzo,
		pianificazioni.model_id_immobile,
		pianificazioni.model_id_licenza,
		pianificazioni.model_id_listino,
		pianificazioni.model_id_luogo,
		pianificazioni.model_id_mastro_destinazione,
		pianificazioni.model_id_mastro_provenienza,
		pianificazioni.model_id_matricola,
		pianificazioni.model_id_modalita_pagamento,
		pianificazioni.model_id_prodotto,
		pianificazioni.model_id_progetto,
		pianificazioni.model_id_reparto,
		pianificazioni.model_id_sede_destinatario,
		pianificazioni.model_id_sede_emittente,
		pianificazioni.model_id_tipologia,
		pianificazioni.model_id_todo,
		pianificazioni.model_id_trasportatore,
		pianificazioni.model_id_udm,
		pianificazioni.model_anno_programmazione,
		pianificazioni.model_codice,
		pianificazioni.model_data,
		pianificazioni.model_data_fine,
		pianificazioni.model_data_inizio,
		pianificazioni.model_data_programmazione,
		pianificazioni.model_esigibilita,
		pianificazioni.model_importo_netto_totale,
		pianificazioni.model_importo_lordo_totale,
		pianificazioni.model_importo_lordo_finale,
		pianificazioni.model_nome,
		pianificazioni.model_note,
		pianificazioni.model_note_cliente,
		pianificazioni.model_note_programmazione,
		pianificazioni.model_numero,
		pianificazioni.model_ora_inizio_programmazione,
		pianificazioni.model_ora_fine_programmazione,
		pianificazioni.model_ore_programmazione,
		pianificazioni.model_porto,
		pianificazioni.model_quantita,
		pianificazioni.model_riferimento,
		pianificazioni.model_sconto_percentuale,
		pianificazioni.model_sconto_valore,
		pianificazioni.model_se_automatico,
		pianificazioni.model_sezionale,
		pianificazioni.model_settimana_programmazione,
		pianificazioni.model_specifiche,
		pianificazioni.model_data_scadenza,
		pianificazioni.model_timestamp_scadenza,
		pianificazioni.offset_giorni,
		pianificazioni.offset_fine_mese,
		pianificazioni.workspace,
		pianificazioni.token,
		pianificazioni.id_account_inserimento,
		pianificazioni.id_account_aggiornamento,
		concat_ws(
			' ',
			pianificazioni.nome,
			periodicita.nome,
			pianificazioni.cadenza
		) AS __label__
	FROM pianificazioni
		LEFT JOIN periodicita ON periodicita.id = pianificazioni.id_periodicita
;

-- | 090000024001

-- popup_view
-- tipologia: tabella gestita
-- verifica: 2021-10-04 17:02 Fabio Mosti
CREATE OR REPLACE VIEW `popup_view` AS
	SELECT
		popup.id,
		popup.id_tipologia,
		tipologie_popup.nome AS tipologia,
		popup.id_sito,
		popup.nome,
		popup.html_id,
		popup.html_class,
		popup.html_class_attivazione,
		popup.n_scroll,
		popup.n_secondi,
		popup.template,
		popup.schema_html,
		popup.se_ovunque,
		popup.id_account_inserimento,
		popup.id_account_aggiornamento,
		popup.nome AS __label__
	FROM popup
		LEFT JOIN tipologie_popup ON tipologie_popup.id = popup.id_tipologia
;

-- | 090000024201

-- popup_pagine_view
-- tipologia: tabella gestita
-- verifica: 2021-10-04 17:02 Fabio Mosti
CREATE OR REPLACE VIEW `popup_pagine_view` AS
	SELECT
		popup_pagine.id,
		popup_pagine.id_popup,
		popup_pagine.id_pagina,
		popup_pagine.se_presente,
		popup_pagine.id_account_inserimento,
		popup_pagine.id_account_aggiornamento,
		concat(
			popup.nome,
			' / ',
			pagine_path( popup_pagine.id_pagina ),
			' / ',
			coalesce( popup_pagine.se_presente, 0 )
		) AS __label__
	FROM popup_pagine
		LEFT JOIN popup ON popup.id = popup_pagine.id_popup
;

-- | 090000025000

-- prezzi_view
CREATE OR REPLACE VIEW `prezzi_view` AS
	SELECT
		prezzi.id,
		prezzi.id_prodotto,
		prodotti.nome AS prodotto,
		prezzi.id_articolo,
		articoli.nome AS articolo,
		prezzi.fascia,
		prezzi.qta_min,
		prezzi.qta_max,
		prezzi.sconto_articoli,
		prezzi.prefisso,
		prezzi.prezzo,
		prezzi.suffisso,
		prezzi.provvigione_percentuale,
		prezzi.provvigione_fissa,
		prezzi.id_reparto,
		reparti.nome AS reparto,
		prezzi.id_listino,
		listini.nome AS listino,
		valute.utf8 AS valuta,
		prezzi.id_iva,
		iva.nome AS iva,
        prezzi.data_inizio,
        prezzi.data_fine,
		prezzi.id_account_inserimento,
		prezzi.id_account_aggiornamento,
		concat_ws(
			' ',
			listini.nome,
			prodotti.nome,
			articoli.nome,
			prezzi.prefisso,
			prezzi.prezzo,
			prezzi.suffisso,
			iva.nome
		) AS __label__
	FROM prezzi
		LEFT JOIN prodotti ON prodotti.id = prezzi.id_prodotto
		LEFT JOIN articoli ON articoli.id = prezzi.id_articolo
		LEFT JOIN reparti ON reparti.id = prezzi.id_reparto
		LEFT JOIN listini ON listini.id = prezzi.id_listino
		LEFT JOIN valute ON valute.id = listini.id_valuta
		LEFT JOIN iva ON iva.id = prezzi.id_iva
	GROUP BY prezzi.id
;															  --

-- | 090000025501

-- istruzioni_view
CREATE OR REPLACE VIEW `istruzioni_view` AS
	SELECT
		istruzioni.id,
		istruzioni.id_tipologia,
		istruzioni.id_prodotto,
		prodotti.nome AS prodotto,
		istruzioni.id_articolo,
		articoli.nome AS articolo,
		istruzioni.nome,
		istruzioni.id_account_inserimento,
		istruzioni.id_account_aggiornamento,
		concat_ws(
			' / ',
			coalesce( prodotti.nome, articoli.nome ),
			istruzioni.nome
		) AS __label__
	FROM istruzioni
		LEFT JOIN prodotti ON prodotti.id = istruzioni.id_prodotto
		LEFT JOIN articoli ON articoli.id = istruzioni.id_articolo
;

-- | 090000026000

-- prodotti_view
CREATE OR REPLACE VIEW `prodotti_view` AS
	SELECT
		pubblicazioni.id_tipologia AS id_tipologia_pubblicazione,
		tipologie_pubblicazioni.nome AS pubblicazione,
		prodotti.id,
		prodotti.codice,
		prodotti.id_tipologia,
		tipologie_prodotti.nome AS tipologia,
		tipologie_prodotti.se_prodotto,
		tipologie_prodotti.se_servizio,
		prodotti.nome,
		prodotti.id_marchio,
		marchi.nome AS marchio,
		prodotti.id_produttore,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS produttore,
		prodotti.codice_produttore,
		-- SOTTOQUERY E NON JOIN PIU' GROUP BY: vedi la nota in articoli_view. Misurato
		-- l'08/09/2026: SELECT * ... WHERE id = ? da 0,81 secondi a 0,011, un elenco di venti
		-- righe da 0,74 a 0,017.
		coalesce( ( SELECT group_concat( DISTINCT categorie_prodotti_path( pc.id_categoria ) SEPARATOR ' | ' )
			FROM prodotti_categorie AS pc
		   WHERE pc.id_prodotto = prodotti.id
		), '' ) AS categorie,
		prodotti.id_sito,
		prodotti.template,
		prodotti.schema_html,
		prodotti.tema_css,
		prodotti.se_sitemap,
		prodotti.se_cacheable,
        prodotti.data_archiviazione,
		prodotti.id_account_inserimento,
		prodotti.id_account_aggiornamento,
		concat_ws(
			' ',
			prodotti.codice,
			prodotti.nome
		) AS __label__
	FROM prodotti
		LEFT JOIN tipologie_prodotti ON tipologie_prodotti.id = prodotti.id_tipologia
		LEFT JOIN marchi ON marchi.id = prodotti.id_marchio
		LEFT JOIN anagrafica AS a1 ON a1.id = prodotti.id_produttore
		LEFT JOIN pubblicazioni ON pubblicazioni.id_prodotto = prodotti.id
		LEFT JOIN tipologie_pubblicazioni ON tipologie_pubblicazioni.id = pubblicazioni.id_tipologia

;

-- | 090000026201

-- prodotti_caratteristiche_view
-- tipologia: tabella gestita
-- verifica: 2021-10-04 19:40 Fabio Mosti
CREATE OR REPLACE VIEW `prodotti_caratteristiche_view` AS
	SELECT
		prodotti_caratteristiche.id,
		prodotti_caratteristiche.id_prodotto,
		prodotti_caratteristiche.id_caratteristica,
		prodotti_caratteristiche.id_lingua,
		caratteristiche.nome AS caratteristica,
		prodotti_caratteristiche.valore AS valore,
		prodotti_caratteristiche.ordine,
		prodotti_caratteristiche.id_account_inserimento,
		prodotti_caratteristiche.id_account_aggiornamento,
		concat(
			prodotti_caratteristiche.id_prodotto,
			' / ',
			caratteristiche.nome
		) AS __label__
	FROM prodotti_caratteristiche
		LEFT JOIN caratteristiche ON caratteristiche.id = prodotti_caratteristiche.id_caratteristica
;

-- | 090000026400

-- prodotti_categorie_view
CREATE OR REPLACE VIEW `prodotti_categorie_view` AS
	SELECT
		prodotti_categorie.id,
		prodotti_categorie.id_prodotto,
		prodotti.nome AS prodotto,
		prodotti_categorie.id_categoria,
		categorie_prodotti_path( prodotti_categorie.id_categoria ) AS categoria,
		prodotti_categorie.id_ruolo,
		ruoli_prodotti.nome AS ruolo,
		prodotti_categorie.ordine,
		prodotti_categorie.id_account_inserimento,
		prodotti_categorie.id_account_aggiornamento,
		concat_ws(
			' ',
			prodotti_categorie.id_prodotto,
			ruoli_prodotti.nome,
			categorie_prodotti_path( prodotti_categorie.id_categoria )
		) AS __label__
	FROM prodotti_categorie
		LEFT JOIN ruoli_prodotti ON ruoli_prodotti.id = prodotti_categorie.id_ruolo
		LEFT JOIN prodotti ON prodotti.id = prodotti_categorie.id_prodotto
;

-- | 090000027000

-- progetti_view
CREATE OR REPLACE VIEW `progetti_view` AS
	SELECT
		progetti.id,
		progetti.codice,
		progetti.id_tipologia,
		tipologie_progetti_path( tipologie_progetti.id ) AS tipologia,
		progetti.id_pianificazione,
		progetti.id_cliente,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS cliente,
		progetti.id_indirizzo,
		progetti.id_ranking,
		ranking.nome AS ranking,
		progetti.id_articolo,
		progetti.id_prodotto,
		progetti.id_periodo,
		progetti.nome,
		progetti.data_consegna,
		progetti.template,
		progetti.schema_html,
		progetti.tema_css,
		progetti.se_sitemap,
		progetti.se_cacheable,
        progetti.id_sito,
        progetti.id_pagina,
		progetti.data_apertura,
		progetti.entrate_previste,
		progetti.ore_previste,
		progetti.costi_previsti,
		progetti.entrate_accettazione,
		progetti.data_accettazione,
		progetti.data_chiusura,
		progetti.entrate_totali,
		progetti.uscite_totali,
		progetti.data_archiviazione,
		group_concat( DISTINCT categorie_progetti_path( progetti_categorie.id_categoria ) SEPARATOR ' | ' ) AS categorie,
		progetti.id_account_inserimento,
		progetti.id_account_aggiornamento,
		concat_ws(
			' ',
			progetti.codice,
			progetti.nome,
			coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' )
		) AS __label__
	FROM progetti
		LEFT JOIN anagrafica AS a1 ON a1.id = progetti.id_cliente
		LEFT JOIN tipologie_progetti ON tipologie_progetti.id = progetti.id_tipologia
		LEFT JOIN progetti_categorie ON progetti_categorie.id_progetto = progetti.id
		LEFT JOIN ranking ON ranking.id = progetti.id_ranking
	GROUP BY progetti.id
;

-- | 090000027201

-- progetti_anagrafica_view
-- tipologia: tabella gestita
-- verifica: 2021-10-08 15:07 Fabio Mosti
CREATE OR REPLACE VIEW progetti_anagrafica_view AS
	SELECT
		progetti_anagrafica.id,
		progetti_anagrafica.id_progetto,
		progetti.nome AS progetto,
		progetti_anagrafica.id_anagrafica,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		progetti_anagrafica.id_ruolo,
		ruoli_anagrafica.nome as ruolo,
		progetti_anagrafica.ordine,
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

-- | 090000027301

-- progetti_articoli_view
-- tipologia: tabella gestita
-- verifica: 2021-04-14 14:58 Chiara GDL
CREATE OR REPLACE VIEW `progetti_articoli_view` AS
	SELECT
		progetti_articoli.id,
		progetti_articoli.id_progetto,
		progetti.nome AS progetto,
		progetti_articoli.id_articolo,
		concat_ws( ' ', prodotti.nome, articoli.nome ) AS articolo,
		progetti_articoli.id_ruolo,
		progetti_articoli.ordine,
		progetti_articoli.id_account_inserimento,
		progetti_articoli.id_account_aggiornamento,
		concat_ws(
			' ',
			progetti.nome,
			concat_ws( ' ', prodotti.nome, articoli.nome ),
			ruoli_articoli.nome
		) AS __label__
	FROM progetti_articoli
		LEFT JOIN ruoli_articoli ON ruoli_articoli.id = progetti_articoli.id_ruolo
		LEFT JOIN progetti ON progetti.id = progetti_articoli.id_progetto
		LEFT JOIN articoli ON articoli.id = progetti_articoli.id_articolo
		LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto;

-- | 090000027401

-- progetti_categorie_view
-- tipologia: tabella gestita
-- verifica: 2021-10-08 15:07 Fabio Mosti
CREATE OR REPLACE VIEW progetti_categorie_view AS
	SELECT
		progetti_categorie.id,
		progetti_categorie.id_progetto,
		progetti.nome AS progetto,
		progetti_categorie.id_categoria,
		categorie_progetti_path( progetti_categorie.id_categoria ) AS categoria,
		progetti_categorie.ordine,
		progetti_categorie.id_account_inserimento,
		progetti_categorie.id_account_aggiornamento,
 		concat_ws(
			' ',
			progetti.nome,
			categorie_progetti_path( progetti_categorie.id_categoria )
		) AS __label__
	FROM progetti_categorie
		LEFT JOIN progetti ON progetti.id = progetti_categorie.id_progetto
;

-- | 090000027601

-- progetti_certificazioni_view
-- tipologia: tabella gestita
-- verifica: 2022-02-03 11:12 Chiara GDL
CREATE OR REPLACE VIEW progetti_certificazioni_view AS
	SELECT
		progetti_certificazioni.id,
		progetti_certificazioni.id_progetto,
		progetti.nome AS progetto,
		progetti_certificazioni.id_certificazione,
		certificazioni.nome AS certificazione,
		progetti_certificazioni.ordine,
		progetti_certificazioni.nome,
		progetti_certificazioni.se_richiesta,
		progetti_certificazioni.id_account_inserimento,
		progetti_certificazioni.id_account_aggiornamento,
 		concat_ws(
			' ',
			progetti.nome,
			'/',
			certificazioni.nome 
		) AS __label__
	FROM progetti_certificazioni
		LEFT JOIN progetti ON progetti.id = progetti_certificazioni.id_progetto
		LEFT JOIN certificazioni ON certificazioni.id = progetti_certificazioni.id_certificazione
;

-- | 090000027801

-- progetti_matricole_view
-- tipologia: tabella gestita
-- verifica: 2021-10-08 15:07 Fabio Mosti
CREATE OR REPLACE VIEW progetti_matricole_view AS
	SELECT
		progetti_matricole.id,
		progetti_matricole.id_progetto,
		progetti.nome AS progetto,
		progetti_matricole.id_matricola,
		matricole.matricola AS matricola,
		progetti_matricole.id_ruolo,
		ruoli_matricole_path( progetti_matricole.id_ruolo ) AS ruolo,
		progetti_matricole.ordine,
		progetti_matricole.id_account_inserimento,
		progetti_matricole.id_account_aggiornamento,
 		concat_ws(
			' ',
			progetti.nome,
			matricole.matricola
		) AS __label__
	FROM progetti_matricole
		LEFT JOIN progetti ON progetti.id = progetti_matricole.id_progetto
		LEFT JOIN matricole ON matricole.id = progetti_matricole.id_matricola
;

-- | 090000028000

-- provincie_view
CREATE OR REPLACE VIEW provincie_view AS                      --
	SELECT                                                    --
		provincie.id,                                         --
		provincie.id_regione,                                 --
		regioni.nome AS regione,                              --
		regioni.id_stato,                                     --
		stati.nome AS stato,                                  --
		provincie.nome,                                       --
		provincie.sigla,                                      --
		provincie.codice_istat,                               --
		concat_ws(                                            --
			' ',                                              --
			provincie.nome,                                   --
			concat( '(', provincie.sigla, ')' ),              --
			stati.nome                                        --
		) AS __label__                                        -- etichetta per le tendine e le liste
	FROM provincie                                            --
		INNER JOIN regioni                                    --
            ON regioni.id = provincie.id_regione              --
		INNER JOIN stati                                      --
            ON stati.id = regioni.id_stato                    --
;                                                             --

-- | 090000028400

-- pubblicazioni_view
CREATE OR REPLACE VIEW `pubblicazioni_view` AS                  --
    SELECT                                                      --
		pubblicazioni.id,                                       --
		pubblicazioni.id_tipologia,                             --
		tp.nome AS tipologia,                                   --
		pubblicazioni.ordine,                                   --
		pubblicazioni.id_prodotto,                              --
		pubblicazioni.id_articolo,                              --
		pubblicazioni.id_categoria_prodotti,                    --
		pubblicazioni.id_notizia,                               --
		pubblicazioni.id_categoria_notizie,                     --
		pubblicazioni.id_categoria_annunci,                     --
		pubblicazioni.id_pagina,                                --
		pubblicazioni.id_popup,                                 --
		pubblicazioni.id_risorsa,                               --
		pubblicazioni.id_categoria_risorse,                     --
		pubblicazioni.id_progetto,                              --
		pubblicazioni.id_categoria_progetti,                    --
		pubblicazioni.id_banner,                                --
		pubblicazioni.id_marchio,                               --
		pubblicazioni.timestamp_inizio,                         --
		pubblicazioni.timestamp_fine,                           --
		concat_ws(                                              --
			' ',                                                --
			tp.nome,                                            --
			pubblicazioni.timestamp_inizio,                     --
			pubblicazioni.timestamp_fine                        --
		) AS __label__                                          -- etichetta per le tendine e le liste
    FROM pubblicazioni                                          --
		LEFT JOIN tipologie_pubblicazioni AS tp                 --
            ON tp.id = pubblicazioni.id_tipologia               --
;                                                               --

-- | 090000028600

-- ranking_view
CREATE OR REPLACE VIEW `ranking_view` AS
    SELECT
		ranking.id,
		ranking.nome,
		ranking.ordine,
		ranking.se_fornitore,
		ranking.se_cliente,
		ranking.se_progetti,
		ranking.id_account_inserimento,
		ranking.id_account_aggiornamento,
		ranking.nome AS __label__
    FROM ranking
;

-- | 090000028901

CREATE OR REPLACE VIEW `recensioni_view` AS
    SELECT
		recensioni.id,
		recensioni.id_lingua,
		recensioni.id_prodotto,
		recensioni.id_articolo,
		recensioni.id_risorsa,
		recensioni.id_pagina,
		recensioni.data,
		recensioni.autore,
		recensioni.valutazione,
		recensioni.titolo,
		recensioni.se_approvata,
		recensioni.id_account_inserimento,
		recensioni.id_account_aggiornamento,
		concat_ws(
			' / ',
			recensioni.autore,
			recensioni.titolo
		) AS __label__
	FROM recensioni
;

-- | 090000029000

-- redirect_view
CREATE OR REPLACE VIEW redirect_view AS                       --
  SELECT                                                      --
    redirect.id,                                              --
    redirect.id_sito,                                         --
    redirect.codice_stato_http,                               --
    redirect.sorgente,                                        --
    redirect.destinazione,                                    --
    redirect.se_query_string,                                 --
    redirect.id_account_inserimento,                          --
    redirect.id_account_aggiornamento,                        --
    concat_ws(                                                --
      ' ',                                                    --
      redirect.sorgente,                                      --
      redirect.codice_stato_http,                             --
      redirect.destinazione                                   --
    ) AS __label__                                            -- etichetta per le tendine e le liste
  FROM redirect                                               --
;                                                             --

-- | 090000029001

-- redirect_azioni_view
CREATE OR REPLACE VIEW `redirect_azioni_view` AS
	SELECT
		redirect_azioni.id,
		redirect_azioni.id_redirect,
		redirect.sorgente AS redirect,
		redirect_azioni.referral,
		redirect_azioni.azione,
		redirect_azioni.id_account_inserimento,
		redirect_azioni.id_account_aggiornamento,
		concat_ws(
			' ',
			redirect.sorgente,
			redirect_azioni.azione
		) AS __label__
	FROM redirect_azioni
		LEFT JOIN redirect ON redirect.id = redirect_azioni.id_redirect
;

-- | 090000029800

-- regimi_view
CREATE OR REPLACE VIEW regimi_view AS
	SELECT
		regimi.id,
		regimi.nome,
		regimi.codice,
		concat_ws(
			' ',
			regimi.nome,
			regimi.codice
		) AS __label__
	FROM regimi
;

-- | 090000030201

-- regioni_view
-- tipologia: tabella di supporto
-- verifica: 2021-10-09 15:40 Fabio Mosti
CREATE OR REPLACE VIEW regioni_view AS
	SELECT
		regioni.id,
		regioni.id_stato,
		stati.nome AS stato,
		regioni.nome,
		regioni.codice_istat,
		concat_ws(
			' ',
			regioni.nome,
			stati.nome
		) AS __label__
	FROM regioni
		LEFT JOIN stati ON stati.id = regioni.id_stato
;

-- | 090000030300

-- relazioni_anagrafica_view
CREATE OR REPLACE VIEW relazioni_anagrafica_view AS
	SELECT
	relazioni_anagrafica.id,
	relazioni_anagrafica.id_ruolo,
	relazioni_anagrafica.id_anagrafica,
	relazioni_anagrafica.id_anagrafica_collegata,
	concat( 
        relazioni_anagrafica.id_anagrafica,
        ' - ',
        relazioni_anagrafica.id_anagrafica_collegata
    ) AS __label__
	FROM relazioni_anagrafica
;

-- | 090000030321

-- relazioni_articoli_view
CREATE OR REPLACE VIEW `relazioni_articoli_view` AS
	SELECT 
		relazioni_articoli.id,
		relazioni_articoli.id_articolo,
		relazioni_articoli.id_ruolo,
		relazioni_articoli.id_prodotto_collegato,
		relazioni_articoli.id_articolo_collegato,
		concat_ws( ' - ', coalesce( a1.codice, a1.id ), coalesce( a2.codice, p2.codice, a2.id, p2.id ) ) AS __label__
	FROM relazioni_articoli
		LEFT JOIN articoli AS a1 ON a1.id = relazioni_articoli.id_articolo
		LEFT JOIN articoli AS a2 ON a2.id = relazioni_articoli.id_articolo_collegato
		LEFT JOIN prodotti AS p2 ON p2.id = relazioni_articoli.id_prodotto_collegato
;

-- | 090000030351

-- relazioni_categorie_progetti_view
-- tipologia: tabella gestita
-- verifica: 2022-01-17 16:12 Chiara GDL
CREATE OR REPLACE VIEW relazioni_categorie_progetti_view AS
	SELECT
	relazioni_categorie_progetti.id,
	relazioni_categorie_progetti.id_ruolo,
	relazioni_categorie_progetti.id_categoria,
	relazioni_categorie_progetti.id_categoria_collegata,
	concat( relazioni_categorie_progetti.id_categoria,' - ', relazioni_categorie_progetti.id_categoria_collegata ) AS __label__
	FROM relazioni_categorie_progetti
;

-- | 090000030400

-- relazioni_documenti_view
CREATE OR REPLACE VIEW relazioni_documenti_view AS
	SELECT
		relazioni_documenti.id,
		relazioni_documenti.id_documento,
		relazioni_documenti.id_documento_collegato,
		relazioni_documenti.id_ruolo,
		ruoli_documenti.nome AS ruolo,
		concat( relazioni_documenti.id_documento,' - ', relazioni_documenti.id_documento_collegato, concat_ws(' ', ruoli_documenti.nome ) ) AS __label__
	FROM relazioni_documenti
		LEFT JOIN ruoli_documenti ON ruoli_documenti.id = relazioni_documenti.id_ruolo
;

-- | 090000030411

-- relazioni_documenti_articoli_view
-- tipologia: tabella gestita
-- verifica: 2022-01-17 16:12 Chiara GDL
CREATE OR REPLACE VIEW relazioni_documenti_articoli_view AS
	SELECT
		relazioni_documenti_articoli.id,
		relazioni_documenti_articoli.id_documenti_articolo,
		relazioni_documenti_articoli.id_documenti_articolo_collegato,
		relazioni_documenti_articoli.id_ruolo,
		ruoli_documenti.nome AS ruolo,
		concat( relazioni_documenti_articoli.id_documenti_articolo,' - ', relazioni_documenti_articoli.id_documenti_articolo_collegato, concat_ws(' ', ruoli_documenti.nome ) ) AS __label__
	FROM relazioni_documenti_articoli
		LEFT JOIN ruoli_documenti ON ruoli_documenti.id = relazioni_documenti_articoli.id_ruolo
;

-- | 090000030441

-- relazioni_pagamenti_view
-- tipologia: tabella gestita
-- verifica: 2022-01-17 16:12 Chiara GDL
CREATE OR REPLACE VIEW relazioni_pagamenti_view AS
	SELECT
	relazioni_pagamenti.id,
	relazioni_pagamenti.id_pagamento,
	relazioni_pagamenti.id_pagamento_collegato,
	concat( relazioni_pagamenti.id_pagamento,' - ', relazioni_pagamenti.id_pagamento_collegato) AS __label__
	FROM relazioni_pagamenti
;

-- | 090000030470

-- relazioni_prodotti_view
CREATE OR REPLACE VIEW `relazioni_prodotti_view` AS
	SELECT 
		relazioni_prodotti.id,
		relazioni_prodotti.id_prodotto,
		relazioni_prodotti.id_ruolo,
		relazioni_prodotti.id_prodotto_collegato,
		relazioni_prodotti.id_articolo_collegato,
		concat_ws( ' - ', coalesce( p1.codice, p1.id ), coalesce( p2.codice, a2.codice, p2.id, a2.id ) ) AS __label__
	FROM relazioni_prodotti
		LEFT JOIN prodotti AS p1 ON p1.id = relazioni_prodotti.id_prodotto
		LEFT JOIN prodotti AS p2 ON p2.id = relazioni_prodotti.id_prodotto_collegato
		LEFT JOIN articoli AS a2 ON a2.id = relazioni_prodotti.id_articolo_collegato
;

-- | 090000030491

-- relazioni_progetti_view
-- tipologia: tabella gestita
-- verifica: 2022-01-17 16:12 Chiara GDL
CREATE OR REPLACE VIEW relazioni_progetti_view AS
	SELECT
	relazioni_progetti.id,
	relazioni_progetti.id_progetto,
	relazioni_progetti.id_progetto_collegato,
	relazioni_progetti.id_ruolo,
	ruoli_progetti.nome AS ruolo,
	concat( relazioni_progetti.id_progetto,' - ', relazioni_progetti.id_progetto_collegato) AS __label__
	FROM relazioni_progetti
	LEFT JOIN ruoli_progetti ON ruoli_progetti.id = relazioni_progetti.id_ruolo
;

-- | 090000030501

-- relazioni_software_view
-- tipologia: tabella gestita
-- verifica: 2022-01-17 16:12 Chiara GDL
CREATE OR REPLACE VIEW relazioni_software_view AS
	SELECT
	relazioni_software.id,
	relazioni_software.id_software,
	relazioni_software.id_software_collegato,
	concat( relazioni_software.id_software,' - ', relazioni_software.id_software_collegato) AS __label__
	FROM relazioni_software
;

-- | 090000030800

-- reparti_view
CREATE OR REPLACE VIEW reparti_view AS
	SELECT
		reparti.id,
		reparti.id_iva,
		iva.aliquota AS iva,
		reparti.id_settore,
		settori_path( reparti.id_settore ) AS settore,
		reparti.nome,
		reparti.id_account_inserimento,
		reparti.id_account_aggiornamento,
		reparti.nome AS __label__
	FROM reparti
		LEFT JOIN iva ON iva.id = reparti.id_iva
;

-- | 090000031501

-- rinnovi_view
-- tipologia: tabella gestita
-- verifica: 2022-02-21 12:59 Chiara GDL
CREATE OR REPLACE VIEW `rinnovi_view` AS
	SELECT
		rinnovi.id,
		rinnovi.id_tipologia,
		tipologie_rinnovi.nome AS tipologia,
		rinnovi.id_contratto,
		contratti.nome AS contratto,
		rinnovi.id_licenza,
		licenze.nome AS licenza,
		licenze.codice AS codice_licenza,
		rinnovi.id_progetto,
		progetti.nome AS progetto,
		rinnovi.id_categoria_progetti,
		categorie_progetti_path( rinnovi.id_categoria_progetti ) AS categoria_progetti,
		rinnovi.data_inizio,
		rinnovi.data_fine,
		rinnovi.codice,
		rinnovi.id_pianificazione,
		rinnovi.id_account_inserimento,
		rinnovi.id_account_aggiornamento,
		concat_ws(
			' ',
			'rinnovo',
			rinnovi.id,
			progetti.nome,
			'dal',
			rinnovi.data_inizio,
			'al',
			rinnovi.data_fine,
			coalesce( 
				anagrafica.denominazione,
				concat( anagrafica.cognome, ' ', anagrafica.nome )
			)
		) AS __label__
	FROM rinnovi
		LEFT JOIN tipologie_rinnovi ON tipologie_rinnovi.id = rinnovi.id_tipologia
		LEFT JOIN contratti ON contratti.id = rinnovi.id_contratto 
		LEFT JOIN contratti_anagrafica ON contratti_anagrafica.id_contratto = contratti.id AND contratti_anagrafica.id_ruolo = 29
		LEFT JOIN anagrafica ON anagrafica.id = contratti_anagrafica.id_anagrafica
		LEFT JOIN licenze ON licenze.id = rinnovi.id_licenza 
		LEFT JOIN progetti ON progetti.id = coalesce( rinnovi.id_progetto, contratti.id_progetto )
	GROUP BY rinnovi.id
	;

-- | 090000031551

-- rinnovi_documenti_articoli_view
-- tipologia: tabella gestita
-- verifica: 2022-03-08 15:59 Chiara GDL
CREATE OR REPLACE VIEW rinnovi_documenti_articoli_view AS
	SELECT
	rinnovi_documenti_articoli.id_documenti_articolo,
	rinnovi_documenti_articoli.id_rinnovo,
	concat( rinnovi_documenti_articoli.id_rinnovo ,' - ', rinnovi_documenti_articoli.id_documenti_articolo) AS __label__
	FROM rinnovi_documenti_articoli
;

-- | 090000032001

-- risorse_view
-- tipologia: tabella gestita
-- verifica: 2021-10-09 16:02 Fabio Mosti
CREATE OR REPLACE VIEW `risorse_view` AS
	SELECT
		risorse.id, 
		risorse.id_tipologia,
		tipologie_risorse.nome AS tipologia,
		risorse.codice, 
		risorse.nome,
		risorse.template,
		risorse.schema_html,
		risorse.tema_css,
		risorse.se_sitemap,
		risorse.se_cacheable,
		risorse.id_sito,
		risorse.id_testata, 
		testate.nome AS testata,
		risorse.id_articolo,
		risorse.id_prodotto,
		risorse.giorno_pubblicazione,
		risorse.mese_pubblicazione,
		risorse.anno_pubblicazione,
		group_concat( DISTINCT categorie_risorse_path( categorie_risorse.id ) SEPARATOR ' | ' ) AS categorie,
		risorse.id_account_inserimento,
		risorse.id_account_aggiornamento,
		concat_ws(
			' ',
			risorse.codice,
			risorse.nome
		) AS __label__
	FROM risorse
		LEFT JOIN tipologie_risorse ON tipologie_risorse.id = risorse.id_tipologia
		LEFT JOIN testate ON testate.id = risorse.id_testata
		LEFT JOIN risorse_categorie ON risorse_categorie.id_risorsa = risorse.id
		LEFT JOIN categorie_risorse ON categorie_risorse.id = risorse_categorie.id_categoria
	GROUP BY risorse.id
;

-- | 090000032101

-- risorse_account
-- tipologia: tabella di supporto
-- verifica: 2022-08-02 12:07 Chiara GDL
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

-- | 090000032201

-- risorse_anagrafica_view
-- tipologia: tabella gestita
-- verifica: 2021-10-09 16:18 Fabio Mosti
CREATE OR REPLACE VIEW `risorse_anagrafica_view` AS
	SELECT
		risorse_anagrafica.id,
		risorse_anagrafica.id_risorsa,
		risorse.nome AS risorsa,
		risorse_anagrafica.id_anagrafica,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		risorse_anagrafica.id_ruolo,
		ruoli_anagrafica_path( risorse_anagrafica.id_ruolo ) AS ruolo,
		risorse_anagrafica.ordine,
		risorse_anagrafica.id_account_inserimento,
		risorse_anagrafica.id_account_aggiornamento,
		concat_ws(
			' ',
			risorse.nome,
			ruoli_anagrafica_path( risorse_anagrafica.id_ruolo ),
			coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' )
		) AS __label__
	FROM risorse_anagrafica
		LEFT JOIN risorse ON risorse.id = risorse_anagrafica.id_risorsa
		LEFT JOIN anagrafica AS a1 ON a1.id = risorse_anagrafica.id_anagrafica
;

-- | 090000032401

-- risorse_categorie_view
-- tipologia: tabella di supporto
-- verifica: 2021-10-09 18:03 Fabio Mosti
CREATE OR REPLACE VIEW `risorse_categorie_view` AS
	SELECT
		risorse_categorie.id,
		risorse_categorie.id_risorsa,
		risorse.nome AS risorsa,
		risorse_categorie.id_categoria,
		categorie_risorse_path( risorse_categorie.id_categoria ),
		risorse_categorie.id_account_inserimento,
		risorse_categorie.id_account_aggiornamento,
		concat_ws(
			' ',
			risorse.nome,
			categorie_risorse_path( risorse_categorie.id_categoria )
		) AS __label__
	FROM risorse_categorie
		LEFT JOIN risorse ON risorse.id = risorse_categorie.id_risorsa
;

-- | 090000033001

-- ritenute_view
-- tipologia: tabella standard
CREATE OR REPLACE VIEW ritenute_view AS
	SELECT
		ritenute.id,
		ritenute.codice,
		ritenute.nome,
		concat( ritenute.codice, ' - ', ritenute.nome ) AS __label__
	FROM ritenute
;

-- | 090000034001

-- ruoli_anagrafica_view
CREATE OR REPLACE VIEW ruoli_anagrafica_view AS
	SELECT
		ruoli_anagrafica.id,
		ruoli_anagrafica.id_genitore,
		ruoli_anagrafica.nome,
		ruoli_anagrafica.se_produzione,
		ruoli_anagrafica.se_didattica,
		ruoli_anagrafica.se_organizzazioni,
		ruoli_anagrafica.se_relazioni,
		ruoli_anagrafica.se_notizie,
		ruoli_anagrafica.se_risorse,
		ruoli_anagrafica.se_progetti,
		ruoli_anagrafica.se_immobili,
		ruoli_anagrafica.se_contratti,
		ruoli_anagrafica.se_proponente,
		ruoli_anagrafica.se_contraente,
		ruoli_anagrafica.id_account_inserimento,
		ruoli_anagrafica.id_account_aggiornamento,
	 	ruoli_anagrafica_path( ruoli_anagrafica.id ) AS __label__
	FROM ruoli_anagrafica
;

-- | 090000034101

-- ruoli_articoli_view
-- tipologia: tabella di supporto
-- verifica: 2021-10-09 18:17 Fabio Mosti
CREATE OR REPLACE VIEW ruoli_articoli_view AS
	SELECT
		ruoli_articoli.id,
		ruoli_articoli.id_genitore,
		ruoli_articoli.nome,
		ruoli_articoli.html_entity,
		ruoli_articoli.font_awesome,
		ruoli_articoli.se_progetti,
		ruoli_articoli.se_risorse,
		ruoli_articoli.se_acquisto,
        ruoli_articoli.se_rinnovo,
	 	ruoli_articoli_path( ruoli_articoli.id ) AS __label__
	FROM ruoli_articoli
;

-- | 090000034200

-- ruoli_audio_view
CREATE OR REPLACE VIEW ruoli_audio_view AS
	SELECT
		ruoli_audio.id,
		ruoli_audio.id_genitore,
		ruoli_audio.nome,
		ruoli_audio.html_entity,
		ruoli_audio.font_awesome,
		ruoli_audio.se_anagrafica,
		ruoli_audio.se_pagine,
		ruoli_audio.se_prodotti,
		ruoli_audio.se_articoli,
		ruoli_audio.se_categorie_prodotti,
		ruoli_audio.se_marchi,
		ruoli_audio.se_notizie,
		ruoli_audio.se_categorie_notizie,
		ruoli_audio.se_annunci,
		ruoli_audio.se_categorie_annunci,
		ruoli_audio.se_risorse,
		ruoli_audio.se_categorie_risorse,
		ruoli_audio.se_immobili,
	 	ruoli_audio_path( ruoli_audio.id ) AS __label__
	FROM ruoli_audio
;

-- | 090000034251

-- ruoli_categorie_progetti_view
-- tipologia: tabella di supporto
-- verifica: 2021-10-09 18:41 Fabio Mosti
CREATE OR REPLACE VIEW ruoli_categorie_progetti_view AS
	SELECT
		ruoli_categorie_progetti.id,
		ruoli_categorie_progetti.id_genitore,
		ruoli_categorie_progetti.nome,
		ruoli_categorie_progetti.html_entity,
		ruoli_categorie_progetti.font_awesome,
		ruoli_categorie_progetti.se_recuperi,
	 	ruoli_categorie_progetti_path( ruoli_categorie_progetti.id ) AS __label__
	FROM ruoli_categorie_progetti
;

-- | 090000034300

-- ruoli_documenti_view
CREATE OR REPLACE VIEW ruoli_documenti_view AS
	SELECT
		ruoli_documenti.id,
		ruoli_documenti.id_genitore,
		ruoli_documenti.nome,
		ruoli_documenti.html_entity,
		ruoli_documenti.font_awesome,
		ruoli_documenti.se_xml,
		ruoli_documenti.se_documenti,
		ruoli_documenti.se_documenti_articoli,
		ruoli_documenti.se_relazioni,
		ruoli_documenti.se_conferma,
		ruoli_documenti.se_consuntivo,
		ruoli_documenti.se_evasione,
	 	ruoli_documenti_path( ruoli_documenti.id ) AS __label__
	FROM ruoli_documenti
;

-- | 090000034401

-- ruoli_file_view
CREATE OR REPLACE VIEW ruoli_file_view AS
	SELECT
		ruoli_file.id,
		ruoli_file.id_genitore,
		ruoli_file.nome,
		ruoli_file.html_entity,
		ruoli_file.font_awesome,
		ruoli_file.se_anagrafica,
		ruoli_file.se_pagine,
		ruoli_file.se_prodotti,
		ruoli_file.se_articoli,
		ruoli_file.se_categorie_prodotti,
		ruoli_file.se_marchi,
		ruoli_file.se_notizie,
		ruoli_file.se_categorie_notizie,
		ruoli_file.se_risorse,
		ruoli_file.se_categorie_risorse,
		ruoli_file.se_mail,
		ruoli_file.se_immobili,
		ruoli_file.se_documenti,
	 	ruoli_file_path( ruoli_file.id ) AS __label__
	FROM ruoli_file
;

-- | 090000034600

-- ruoli_immagini_view
-- tipologia: tabella di supporto
CREATE OR REPLACE VIEW ruoli_immagini_view AS                   --
	SELECT                                                      --
		ruoli_immagini.id,                                      --
		ruoli_immagini.id_genitore,                             --
		ruoli_immagini.ordine_scalamento,                       --
		ruoli_immagini.nome,                                    --
		ruoli_immagini.html_entity,                             --
		ruoli_immagini.font_awesome,                            --
		ruoli_immagini.se_anagrafica,                           --
		ruoli_immagini.se_pagine,                               --
		ruoli_immagini.se_prodotti,                             --
		ruoli_immagini.se_articoli,                             --
		ruoli_immagini.se_categorie_prodotti,                   --
		ruoli_immagini.se_marchi,                   --
		ruoli_immagini.se_notizie,                              --
		ruoli_immagini.se_categorie_notizie,                    --
		ruoli_immagini.se_risorse,                              --
		ruoli_immagini.se_categorie_risorse,                    --
		ruoli_immagini.se_immobili,                             --
		ruoli_immagini.se_file,                             --
		ruoli_immagini.se_video,                             --
	 	ruoli_immagini_path(                                    --
            ruoli_immagini.id ) AS __label__                    -- etichetta per le tendine e le liste
	FROM ruoli_immagini                                         --
;

-- | 090000034800

-- ruoli_indirizzi_view
CREATE OR REPLACE VIEW ruoli_indirizzi_view AS				  --
	SELECT													  --
		ruoli_indirizzi.id,					  				  --
		ruoli_indirizzi.id_genitore,			  			  --
		ruoli_indirizzi.nome,							  	  --
    	ruoli_indirizzi.html_entity,				  		  --
    	ruoli_indirizzi.font_awesome,		  		  		  --
    	ruoli_indirizzi.se_sede_legale,	  		  			  --
    	ruoli_indirizzi.se_sede_operativa,	  		  		  --
    	ruoli_indirizzi.se_residenza,	  		  			  --
    	ruoli_indirizzi.se_domicilio,			  		  	  --
	 	ruoli_indirizzi_path(								  --
			ruoli_indirizzi.id ) AS __label__			  	  -- etichetta per le tendine e le liste
	FROM ruoli_indirizzi									  --
;                                                             --

-- | 090000034801

-- ruoli_mail_view
CREATE OR REPLACE VIEW `ruoli_mail_view` AS
	SELECT
		ruoli_mail.id,
		ruoli_mail.id_genitore,
		ruoli_mail.nome,
		ruoli_mail.html_entity,
		ruoli_mail.font_awesome,
		ruoli_mail.se_xml,
		ruoli_mail.se_commerciale,
		ruoli_mail.se_produzione,
		ruoli_mail.se_amministrazione,
		ruoli_mail.se_acquisti,
		ruoli_mail.se_ordini,
		ruoli_mail.se_helpdesk,
		ruoli_mail.id_account_inserimento,
		ruoli_mail.id_account_aggiornamento,
		ruoli_mail_path( ruoli_mail.id ) AS __label__
	FROM ruoli_mail
;

-- | 090000034871

-- ruoli_mastri_view
-- tipologia: tabella di supporto
-- verifica: 2021-10-12 11:23 Fabio Mosti
CREATE OR REPLACE VIEW ruoli_mastri_view AS
	SELECT
		ruoli_mastri.id,
		ruoli_mastri.id_genitore,
		ruoli_mastri.nome,
    	ruoli_mastri.html_entity,
    	ruoli_mastri.font_awesome,
	 	ruoli_mastri_path( ruoli_mastri.id ) AS __label__
	FROM ruoli_mastri
;

-- | 090000034901

-- ruoli_matricole_view
-- tipologia: tabella di supporto
-- verifica: 2021-10-12 11:23 Fabio Mosti
CREATE OR REPLACE VIEW ruoli_matricole_view AS
	SELECT
		ruoli_matricole.id,
		ruoli_matricole.id_genitore,
		ruoli_matricole.nome,
    	ruoli_matricole.html_entity,
    	ruoli_matricole.font_awesome,
	 	ruoli_matricole_path( ruoli_matricole.id ) AS __label__
	FROM ruoli_matricole
;

-- | 090000035000

-- ruoli_prodotti_view
CREATE OR REPLACE VIEW ruoli_prodotti_view AS
	SELECT
		ruoli_prodotti.id,
		ruoli_prodotti.id_genitore,
		ruoli_prodotti.nome,
	 	ruoli_prodotti_path( ruoli_prodotti.id ) AS __label__
	FROM ruoli_prodotti
;

-- | 090000035101

-- ruoli_progetti
-- tipologia: tabella di supporto
-- verifica: 2022-04-20 10:45 chiara GDL
CREATE OR REPLACE VIEW ruoli_progetti_view AS
	SELECT
		ruoli_progetti.id,
		ruoli_progetti.nome,
		ruoli_progetti.html_entity,
		ruoli_progetti.font_awesome,
		ruoli_progetti.se_sottoprogetto,
		ruoli_progetti.se_proseguimento,
		ruoli_progetti.se_sostituto,
		ruoli_progetti.se_attesa,
	 	ruoli_progetti.nome AS __label__
	FROM ruoli_progetti
;

-- | 090000035200

-- ruoli_video_view
CREATE OR REPLACE VIEW ruoli_video_view AS
	SELECT
		ruoli_video.id,
		ruoli_video.id_genitore,
		ruoli_video.nome,
		ruoli_video.html_entity,
		ruoli_video.font_awesome,
		ruoli_video.se_anagrafica,
		ruoli_video.se_pagine,
		ruoli_video.se_prodotti,
		ruoli_video.se_articoli,
		ruoli_video.se_categorie_prodotti,
		ruoli_video.se_marchi,
		ruoli_video.se_notizie,
		ruoli_video.se_categorie_notizie,
		ruoli_video.se_annunci,
		ruoli_video.se_categorie_annunci,
		ruoli_video.se_risorse,
		ruoli_video.se_categorie_risorse,
		ruoli_video.se_immobili,
	 	ruoli_video_path( ruoli_video.id ) AS __label__
	FROM ruoli_video
;

-- | 090000036001

-- sconti_view
CREATE OR REPLACE VIEW `sconti_view` AS
	SELECT
	sconti.id,
	sconti.nome,
	sconti.timestamp_inizio,
	from_unixtime( sconti.timestamp_inizio, '%Y-%m-%d' ) AS data_ora_inizio,
	sconti.timestamp_fine,
	from_unixtime( sconti.timestamp_fine, '%Y-%m-%d' ) AS data_ora_fine,
	concat_ws( ' ', sconti.id, sconti.nome ) AS __label__
	FROM sconti
;

-- | 090000036201

-- sconti_articoli_view
CREATE OR REPLACE VIEW `sconti_articoli_view` AS
	SELECT
		sconti_articoli.id,
		sconti_articoli.id_sconto,
		sconti.nome AS sconto,
		sconti_articoli.id_articolo,
		articoli.id_prodotto,
		concat_ws( ' ', prodotti.nome, articoli.nome ) AS articolo,
		concat_ws( ' ', sconti.nome, coalesce( articoli.codice, articoli.id ) ) AS __label__
	FROM sconti_articoli
		LEFT JOIN sconti ON sconti.id = sconti_articoli.id_sconto
		LEFT JOIN articoli ON articoli.id = sconti_articoli.id_articolo
		LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
;

-- | 090000036401

-- sconti_listini_view
CREATE OR REPLACE VIEW `sconti_listini_view` AS
	SELECT
		sconti_listini.id,
		sconti_listini.id_sconto,
		sconti.nome AS sconto,
		sconti_listini.id_listino,
		listini.nome AS listino,	
		concat_ws( ' ', sconti.nome, listini.nome ) AS __label__
	FROM sconti_listini
		LEFT JOIN sconti ON sconti.id = sconti_listini.id_sconto
		LEFT JOIN listini ON listini.id = sconti_listini.id_listino
;

-- | 090000037000

-- settori_view
CREATE OR REPLACE VIEW settori_view AS
	SELECT
		settori.id,
		settori.id_genitore,
		settori.nome,
		settori.soprannome,
		settori.ateco,
	 	concat( settori.ateco, ' ', settori.nome ) AS __label__
	FROM settori
;

-- | 090000041000

-- sms_out_view
CREATE OR REPLACE VIEW `sms_out_view` AS
	SELECT
		sms_out.id,
		sms_out.id_telefono,
		sms_out.ordine,
		sms_out.timestamp_composizione,
		sms_out.mittente,
		sms_out.destinatari,
		sms_out.corpo,
		sms_out.server,
		sms_out.host,
		sms_out.port,
		sms_out.user,
		sms_out.password,
		sms_out.token,
		sms_out.tentativi,
		sms_out.timestamp_invio,
		from_unixtime( sms_out.timestamp_invio, '%Y-%m-%d' ) AS data_ora_invio,
		sms_out.id_account_inserimento,
		sms_out.id_account_aggiornamento,
		concat(
			sms_out.id,
			' / ',
			sms_out.corpo,
			if( sms_out.token = 'TROPPI_TENTATIVI', concat( ' ( fermo dopo ', sms_out.tentativi, ' tentativi )' ), '' )
		) AS __label__
	FROM sms_out
;

-- | 090000041200

-- sms_sent_view
CREATE OR REPLACE VIEW `sms_sent_view` AS
	SELECT
		sms_sent.id,
		sms_sent.id_telefono,
		sms_sent.ordine,
		sms_sent.timestamp_composizione,
		sms_sent.mittente,
		sms_sent.destinatari,
		sms_sent.corpo,
		sms_sent.server,
		sms_sent.host,
		sms_sent.port,
		sms_sent.user,
		sms_sent.password,
		sms_sent.token,
		sms_sent.tentativi,
		sms_sent.timestamp_invio,
		from_unixtime( sms_sent.timestamp_invio, '%Y-%m-%d' ) AS data_ora_invio,
		sms_sent.id_account_inserimento,
		sms_sent.id_account_aggiornamento,
		concat(
			sms_sent.id,
			' / ',
			sms_sent.corpo
		) AS __label__
	FROM sms_sent
;

-- | 090000041401

-- software_view
-- tipologia: tabella gestita
-- verifica: 2021-11-16 10:39 Chiara GDL 
CREATE OR REPLACE VIEW software_view AS
    SELECT
		software.id,
		software.id_genitore,
		software.id_articolo,
		software.codice,
		concat(prodotti.nome, ' - ',articoli.nome) AS articolo,
		software.json,
		software.nome,
		software.note,
		software.id_account_inserimento,
		software.id_account_aggiornamento,
	 	software_path( software.id ) AS __label__
	FROM software
		LEFT JOIN articoli ON software.id_articolo = articoli.id
		LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
;

-- | 090000042000

-- stati_view
CREATE OR REPLACE VIEW stati_view AS                          --
    SELECT                                                    --
		stati.id,                                             --
		stati.id_continente,                                  --
		continenti.nome AS continente,                        -- nome del continente
		stati.nome,                                           --
		stati.iso31661alpha2,                                 --
		stati.iso31661alpha3,                                 --
		stati.codice_istat,                                   --
		stati.data_archiviazione,                             --
		concat_ws(                                            --
			' ',                                              --
			continenti.nome,                                  --
			stati.nome                                        --
		) AS __label__                                        -- etichetta per le tendine e le liste
    FROM stati                                                --
    	LEFT JOIN continenti                                  --
            ON continenti.id = stati.id_continente            --
;                                                             --

-- | 090000042201

-- stati_lingue_view
-- tipologia: tabella di supporto
-- verifica: 2021-10-12 15:33 Fabio Mosti
CREATE OR REPLACE VIEW stati_lingue_view AS
    SELECT
		stati_lingue.id,
		stati_lingue.id_stato,
		stati.nome AS stato,
		stati_lingue.id_lingua,
		lingue.nome AS lingua,
		stati_lingue.ordine,
		concat_ws(
			' ',
			stati.nome,
			lingue.nome
		) AS __label__
    FROM stati_lingue
    	LEFT JOIN stati ON stati.id = stati_lingue.id_stato
    	LEFT JOIN lingue ON lingue.id = stati_lingue.id_lingua
;

-- | 090000042501

-- step_view
CREATE OR REPLACE VIEW step_view AS
	SELECT
		step.id,
		step.id_funnel,
		step.ordine,
		step.nome,
		step.id_account_inserimento,
		step.id_account_aggiornamento,
		concat_ws(
			' / ',
			step.nome
		) AS __label__
	FROM step
	ORDER BY step.id_funnel, step.ordine
;

-- | 090000043001

-- task_view
-- tipologia: tabella assistita
-- verifica: 2021-06-30 11:57 Fabio Mosti
CREATE OR REPLACE VIEW task_view AS
	SELECT
		task.id,
		task.minuto,
		task.ora,
		task.giorno_del_mese,
		task.mese,
		task.giorno_della_settimana,
		task.settimana,
		task.task,
		task.iterazioni,
		task.delay,
		task.token,
		task.timestamp_esecuzione,
		from_unixtime( task.timestamp_esecuzione, '%Y-%m-%d %H:%i' ) AS data_ora_esecuzione,
		task.id_account_inserimento,
		task.id_account_aggiornamento,
		CONCAT(
			' / ',
			coalesce( task.minuto, '*' ),
			' / ',
			coalesce( task.ora, '*' ),
			' / ',
			coalesce( task.giorno_del_mese, '*' ),
			' / ',
			coalesce( task.mese, '*' ),
			' / ',
			coalesce( task.giorno_della_settimana, '*' ),
			' / ',
			coalesce( task.settimana, '*' ),
			' / ',
			task.task
		) AS __label__
	FROM task
;

-- | 090000043600

-- telefoni_view
CREATE OR REPLACE VIEW telefoni_view AS                       --
	SELECT                                                    --
		telefoni.id,                                          --
		telefoni.id_anagrafica,                               --
		coalesce(                                             --
            a1.denominazione,                                 --
            concat(                                           --
                a1.cognome, ' ', a1.nome                      --
            ),                                                --
            ''                                                --
        ) AS anagrafica,                                      -- denominazione o cognome e nome dell'anagrafica
		telefoni.id_tipologia,                                --
		t1.nome AS tipologia,                                 -- nome della tipologia
		telefoni.numero,                                      --
		telefoni.se_notifiche,                                --
		telefoni.id_account_inserimento,                      --
		telefoni.id_account_aggiornamento,                    --
		concat_ws(                                            --
			' ',                                              --
			coalesce(                                         --
                a1.denominazione,                             --
                concat( a1.cognome, ' ', a1.nome ),           --
                ''                                            --
            ),                                                --
			t1.nome,                                          --
			telefoni.numero                                   --
		) AS __label__                                        -- etichetta per le tendine e le liste
	FROM telefoni                                             --
		LEFT JOIN anagrafica AS a1                            --
            ON a1.id = telefoni.id_anagrafica                 --
		LEFT JOIN tipologie_telefoni AS t1                    --
            ON t1.id = telefoni.id_tipologia                  --
;                                                             --

-- | 090000044001

-- template_view
CREATE OR REPLACE VIEW `template_view` AS
	SELECT
		template.id,
		template.ruolo,
		template.nome,
		template.tipo,
		template.note,
		template.latenza_invio,
		template.se_mail,
		template.se_sms,
		template.id_account_inserimento,
		template.id_account_aggiornamento,
		template.ruolo AS __label__
	FROM template
;

-- | 090000045001

-- testate_view
-- tipologia: tabella gestita
-- verifica: 2021-09-10 16:54 Fabio Mosti
CREATE OR REPLACE VIEW `testate_view` AS
	SELECT
		testate.id,
		testate.nome,
		testate.nome AS __label__
	FROM testate
;

-- | 090000050000

-- tipologie_anagrafica_view
CREATE OR REPLACE VIEW `tipologie_anagrafica_view` AS         --
	SELECT                                                    --
		tipologie_anagrafica.id,                              --
		tipologie_anagrafica.id_genitore,                     --
		tipologie_anagrafica.ordine,                          --
		tipologie_anagrafica.nome,                            --
		tipologie_anagrafica.html_entity,                     --
		tipologie_anagrafica.font_awesome,                    --
		tipologie_anagrafica.se_persona_fisica,               --
        tipologie_anagrafica.se_persona_giuridica,            --
        tipologie_anagrafica.se_pubblica_amministrazione,     --
        tipologie_anagrafica.se_ecommerce,                    --
		tipologie_anagrafica.id_account_inserimento,          --
		tipologie_anagrafica.id_account_aggiornamento,        --
		tipologie_anagrafica_path(                            --
            tipologie_anagrafica.id ) AS __label__            -- etichetta per le tendine e le liste
	FROM tipologie_anagrafica                                 --
;                                                             --

-- | 090000050001

-- tipologie_annunci_view
CREATE OR REPLACE VIEW `tipologie_annunci_view` AS
	SELECT
		tipologie_annunci.id,
		tipologie_annunci.id_genitore,
		tipologie_annunci.ordine,
		tipologie_annunci.nome,
		tipologie_annunci.sigla,
		tipologie_annunci.html_entity,
		tipologie_annunci.font_awesome,
		tipologie_annunci.id_account_inserimento,
		tipologie_annunci.id_account_aggiornamento,
		tipologie_annunci_path( tipologie_annunci.id ) AS __label__
	FROM tipologie_annunci
;

-- | 090000050400

-- tipologie_attivita_view
CREATE OR REPLACE VIEW `tipologie_attivita_view` AS           --
	SELECT                                                    --
		tipologie_attivita.id,                                --
		tipologie_attivita.id_genitore,                       --
		tipologie_attivita.ordine,                            --
		tipologie_attivita.codice,                            --
		tipologie_attivita.nome,                              --
		tipologie_attivita.html_entity,                       --
		tipologie_attivita.font_awesome,                      --
		tipologie_attivita.se_anagrafica,                     --
		tipologie_attivita.se_agenda,                         --
		tipologie_attivita.se_sistema,                        --
		tipologie_attivita.se_stampa,                         --
		tipologie_attivita.se_cartellini,                     --
		tipologie_attivita.se_corsi,                          --
		tipologie_attivita.se_accesso,                        --
		tipologie_attivita.id_account_inserimento,            --
		tipologie_attivita.id_account_aggiornamento,          --
		tipologie_attivita_path(                              --
            tipologie_attivita.id ) AS __label__              -- etichetta per le tendine e le liste
	FROM tipologie_attivita                                   --
;                                                             --

-- | 090000050431

-- tipologie_attivita_inps_view
-- ripristinata il 2026-09-30 dallo schema del 2021 ( _usr/_database/mysql.schema.sql, 0e99bca51 )
CREATE OR REPLACE VIEW `tipologie_attivita_inps_view` AS
	SELECT
		tipologie_attivita_inps.id,
		tipologie_attivita_inps.id_genitore,
		tipologie_attivita_inps.nome,
		tipologie_attivita_inps.codice,
		tipologie_attivita_inps.se_quadratura,
		concat(
			if( tipologie_attivita_inps.codice IS NOT NULL, concat( tipologie_attivita_inps.codice, ' - ' ), '' ),
			tipologie_attivita_inps.nome
		) AS __label__
	FROM tipologie_attivita_inps
;

-- | 090000050451

-- tipologie_badge_view
-- tipologia: tabella assistita
CREATE OR REPLACE VIEW `tipologie_badge_view` AS
	SELECT
		tipologie_badge.id,
		tipologie_badge.id_genitore,
		tipologie_badge.ordine,
		tipologie_badge.nome,
		tipologie_badge.html_entity,
		tipologie_badge.font_awesome,
		tipologie_badge.id_account_inserimento,
		tipologie_badge.id_account_aggiornamento,
		tipologie_badge.nome AS __label__
	FROM tipologie_badge
;

-- | 090000050501

-- tipologie_banner_view
-- tipologia: tabella assistita
-- verifica: 2022-07-20 17:22 Chiara GDL
CREATE OR REPLACE VIEW `tipologie_banner_view` AS
	SELECT
		tipologie_banner.id,
		tipologie_banner.id_genitore,
		tipologie_banner.ordine,
		tipologie_banner.nome,
		tipologie_banner.html_entity,
		tipologie_banner.font_awesome,
		tipologie_banner.id_account_inserimento,
		tipologie_banner.id_account_aggiornamento,
		tipologie_banner_path( tipologie_banner.id ) AS __label__
	FROM tipologie_banner
;

-- | 090000050601

-- tipologie_chiavi_view
-- tipologia: tabella assistita
-- verifica: 2021-11-15 11:29 Chiara GDL
CREATE OR REPLACE VIEW `tipologie_chiavi_view` AS
	SELECT
		tipologie_chiavi.id,
		tipologie_chiavi.id_genitore,
		tipologie_chiavi.ordine,
		tipologie_chiavi.nome,
		tipologie_chiavi.html_entity,
		tipologie_chiavi.font_awesome,
		tipologie_chiavi.id_account_inserimento,
		tipologie_chiavi.id_account_aggiornamento,
		tipologie_chiavi_path( tipologie_chiavi.id ) AS __label__
	FROM tipologie_chiavi
;

-- | 090000050700

-- tipologie_colli_view
CREATE OR REPLACE VIEW `tipologie_colli_view` AS
	SELECT
		tipologie_colli.id,
		tipologie_colli.id_genitore,
		tipologie_colli.ordine,
		tipologie_colli.nome,
		tipologie_colli.html_entity,
		tipologie_colli.font_awesome,
		tipologie_colli.id_account_inserimento,
		tipologie_colli.id_account_aggiornamento,
		tipologie_colli_path( tipologie_colli.id ) AS __label__
	FROM tipologie_colli
;

-- | 090000050800

-- tipologie_contatti_view
CREATE OR REPLACE VIEW `tipologie_contatti_view` AS
	SELECT
		tipologie_contatti.id,
		tipologie_contatti.id_genitore,
		tipologie_contatti.ordine,
		tipologie_contatti.nome,
		tipologie_contatti.html_entity,
		tipologie_contatti.font_awesome,
		tipologie_contatti.id_account_inserimento,
		tipologie_contatti.id_account_aggiornamento,
		tipologie_contatti_path( tipologie_contatti.id ) AS __label__
	FROM tipologie_contatti
;

-- | 090000050901

-- tipologie_contratti_view
-- tipologia: tabella gestita
-- verifica: 2022-02-21 11:47 Chiara GDL
CREATE OR REPLACE VIEW `tipologie_contratti_view` AS
	SELECT
		tipologie_contratti.id,
		tipologie_contratti.id_genitore,
		tipologie_contratti.ordine,
		tipologie_contratti.nome,
		tipologie_contratti.id_prodotto,
		tipologie_contratti.id_progetto,
		tipologie_contratti.id_categoria_progetti,
		tipologie_contratti.html_entity,
		tipologie_contratti.font_awesome,
		tipologie_contratti.se_abbonamento,
		tipologie_contratti.se_iscrizione,
		tipologie_contratti.se_tesseramento,
		tipologie_contratti.se_immobili,
		tipologie_contratti.se_acquisto,
		tipologie_contratti.se_locazione,
		tipologie_contratti.se_libero,
		tipologie_contratti.se_prenotazione,
		tipologie_contratti.se_scalare,
		tipologie_contratti.se_affiliazione,
		tipologie_contratti.se_online,
		tipologie_contratti.id_account_inserimento,
		tipologie_contratti.id_account_aggiornamento,
		tipologie_contratti_path( tipologie_contratti.id ) AS __label__
	FROM tipologie_contratti
;

-- | 090000051001

-- tipologie_corrispondenza_view
CREATE OR REPLACE VIEW `tipologie_corrispondenza_view` AS
	SELECT
		tipologie_corrispondenza.id,
		tipologie_corrispondenza.id_genitore,
		tipologie_corrispondenza.nome,
		tipologie_corrispondenza.se_massivo,
		tipologie_corrispondenza.se_corrispondenza,
		tipologie_corrispondenza.se_atto,
		tipologie_corrispondenza.se_ricevuta_ritorno,
		tipologie_corrispondenza.id_account_inserimento,
		tipologie_corrispondenza.id_account_aggiornamento,
		tipologie_corrispondenza_path( tipologie_corrispondenza.id ) AS __label__
	FROM tipologie_corrispondenza
;

-- | 090000052600

-- tipologie_documenti_view
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
		tipologie_documenti.se_nota_debito,
		tipologie_documenti.se_trasporto,
		tipologie_documenti.se_pro_forma,
		tipologie_documenti.se_offerta,
		tipologie_documenti.se_ordine,
		tipologie_documenti.se_missione,
		tipologie_documenti.se_ricevuta,
		tipologie_documenti.se_ecommerce,
		tipologie_documenti.id_account_inserimento,
		tipologie_documenti.id_account_aggiornamento,
		tipologie_documenti_path( tipologie_documenti.id ) AS __label__
	FROM tipologie_documenti
;

-- | 090000052700

-- tipologie_documenti_articoli_view
CREATE OR REPLACE VIEW `tipologie_documenti_articoli_view` AS
	SELECT
		tipologie_documenti_articoli.id,
		tipologie_documenti_articoli.id_genitore,
		tipologie_documenti_articoli.ordine,
		tipologie_documenti_articoli.nome,
		tipologie_documenti_articoli.sigla,
		tipologie_documenti_articoli.html_entity,
		tipologie_documenti_articoli.font_awesome,
		tipologie_documenti_articoli.se_raggruppamento,
		tipologie_documenti_articoli.se_somma,
		tipologie_documenti_articoli.se_alternativa,
		tipologie_documenti_articoli.id_account_inserimento,
		tipologie_documenti_articoli.id_account_aggiornamento,
		tipologie_documenti_articoli_path( tipologie_documenti_articoli.id ) AS __label__
	FROM tipologie_documenti_articoli
;

-- | 090000052801

-- tipologie_edifici_view
-- tipologia: tabella di supporto
-- verifica: 2022-04-27 17:00 Chiara GDL
CREATE OR REPLACE VIEW tipologie_edifici_view AS
	SELECT
	tipologie_edifici.id,
	tipologie_edifici.id_genitore,
	tipologie_edifici.ordine,
	tipologie_edifici.nome,
	tipologie_edifici.html_entity,
	tipologie_edifici.font_awesome,
	tipologie_edifici.id_account_inserimento,
	tipologie_edifici.id_account_aggiornamento,
	tipologie_edifici_path( tipologie_edifici.id )  AS __label__
	FROM tipologie_edifici
	;

-- | 090000052901

-- tipologie_immobili_view
-- tipologia: tabella di supporto
-- verifica: 2022-04-27 17:00 Chiara GDL
CREATE OR REPLACE VIEW tipologie_immobili_view AS
	SELECT
	tipologie_immobili.id,
	tipologie_immobili.id_genitore,
	tipologie_immobili.ordine,
	tipologie_immobili.nome,
	tipologie_immobili.html_entity,
	tipologie_immobili.font_awesome,
	tipologie_immobili.se_residenziale ,
	tipologie_immobili.se_industriale ,
	tipologie_immobili.id_account_inserimento,
	tipologie_immobili.id_account_aggiornamento,
	tipologie_immobili_path( tipologie_immobili.id )  AS __label__
	FROM tipologie_immobili
	;

-- | 090000053000

-- tipologie_indirizzi_view
CREATE OR REPLACE VIEW `tipologie_indirizzi_view` AS          --
	SELECT                                                    --
		tipologie_indirizzi.id,                               --
		tipologie_indirizzi.id_genitore,                      --
		tipologie_indirizzi.ordine,                           --
		tipologie_indirizzi.nome,                             --
		tipologie_indirizzi.html_entity,                      --
		tipologie_indirizzi.font_awesome,                     --
		tipologie_indirizzi.id_account_inserimento,           --
		tipologie_indirizzi.id_account_aggiornamento,         --
		tipologie_indirizzi_path(                             --
            tipologie_indirizzi.id                            --
        ) AS __label__                                        -- etichetta per le tendine e le liste
	FROM tipologie_indirizzi                                  --
;                                                             --

-- | 090000053201

-- tipologie_licenze_view
-- tipologia: tabella assistita
-- verifica: 2021-11-15 11:29 Chiara GDL
CREATE OR REPLACE VIEW `tipologie_licenze_view` AS
	SELECT
		tipologie_licenze.id,
		tipologie_licenze.id_genitore,
		tipologie_licenze.ordine,
		tipologie_licenze.nome,
		tipologie_licenze.html_entity,
		tipologie_licenze.font_awesome,
		tipologie_licenze.id_account_inserimento,
		tipologie_licenze.id_account_aggiornamento,
		tipologie_licenze_path( tipologie_licenze.id ) AS __label__
	FROM tipologie_licenze
;

-- | 090000053301

-- tipologie_luoghi_view
-- tipologia: tabella gestita
-- verifica: 2022-02-21 15:30 Chiara GDL
CREATE OR REPLACE VIEW `tipologie_luoghi_view` AS
	SELECT
		tipologie_luoghi.id,
		tipologie_luoghi.id_genitore,
		tipologie_luoghi.ordine,
		tipologie_luoghi.nome,
		tipologie_luoghi.html_entity,
		tipologie_luoghi.font_awesome,
		tipologie_luoghi.id_account_inserimento,
		tipologie_luoghi.id_account_aggiornamento,
		tipologie_luoghi_path( tipologie_luoghi.id ) AS __label__
	FROM tipologie_luoghi
;

-- | 090000053302

-- tipologie_mail_status_view
CREATE OR REPLACE VIEW `tipologie_mail_status_view` AS
	SELECT
		tipologie_mail_status.id,
		tipologie_mail_status.ordine,
		tipologie_mail_status.codice,
		tipologie_mail_status.nome,
		tipologie_mail_status.se_recapitabile,
		tipologie_mail_status.se_sistema,
		tipologie_mail_status.id_account_inserimento,
		tipologie_mail_status.id_account_aggiornamento,
		tipologie_mail_status.nome AS __label__
	FROM tipologie_mail_status
;

-- | 090000053401

-- tipologie_mastri_view
-- tipologia: tabella assistita
-- verifica: 2021-10-19 13:11 Fabio Mosti
CREATE OR REPLACE VIEW `tipologie_mastri_view` AS
	SELECT
		tipologie_mastri.id,
		tipologie_mastri.id_genitore,
		tipologie_mastri.ordine,
		tipologie_mastri.nome,
		tipologie_mastri.html_entity,
		tipologie_mastri.font_awesome,
		tipologie_mastri.se_magazzino,
		tipologie_mastri.se_conto,
		tipologie_mastri.se_registro,
		tipologie_mastri.se_credito,
		tipologie_mastri.id_account_inserimento,
		tipologie_mastri.id_account_aggiornamento,
		tipologie_mastri_path( tipologie_mastri.id ) AS __label__
	FROM tipologie_mastri
;

-- | 090000053600

-- tipologie_listini_view
CREATE OR REPLACE VIEW `tipologie_listini_view` AS
	SELECT
		tipologie_listini.id,
		tipologie_listini.id_genitore,
		tipologie_listini.ordine,
		tipologie_listini.nome,
		tipologie_listini.html_entity,
		tipologie_listini.font_awesome,
		tipologie_listini.id_account_inserimento,
		tipologie_listini.id_account_aggiornamento,
		tipologie_listini_path( tipologie_listini.id ) AS __label__
	FROM tipologie_listini
;

-- | 090000053800

-- tipologie_notizie_view
CREATE OR REPLACE VIEW `tipologie_notizie_view` AS
	SELECT
		tipologie_notizie.id,
		tipologie_notizie.id_genitore,
		tipologie_notizie.ordine,
		tipologie_notizie.nome,
		tipologie_notizie.html_entity,
		tipologie_notizie.font_awesome,
		tipologie_notizie.id_account_inserimento,
		tipologie_notizie.id_account_aggiornamento,
		tipologie_notizie_path( tipologie_notizie.id ) AS __label__
	FROM tipologie_notizie
;

-- | 090000054001

-- tipologie_pagamenti_view
-- tipologia: tabella assistita
-- verifica: 2021-11-15 11:29 Chiara GDL
CREATE OR REPLACE VIEW `tipologie_pagamenti_view` AS
	SELECT
		tipologie_pagamenti.id,
		tipologie_pagamenti.id_genitore,
		tipologie_pagamenti.ordine,
		tipologie_pagamenti.nome,
		tipologie_pagamenti.html_entity,
		tipologie_pagamenti.font_awesome,
		tipologie_pagamenti.id_account_inserimento,
		tipologie_pagamenti.id_account_aggiornamento,
		tipologie_pagamenti_path( tipologie_pagamenti.id ) AS __label__
	FROM tipologie_pagamenti
;

-- | 090000054101

-- tipologie_periodi_view
-- tipologia: tabella gestita
-- verifica: 2022-05-24 11:00 Chiara GDL
CREATE OR REPLACE VIEW `tipologie_periodi_view` AS
	SELECT
		tipologie_periodi.id,
		tipologie_periodi.id_genitore,
		tipologie_periodi.ordine,
		tipologie_periodi.codice,
		tipologie_periodi.nome,
		tipologie_periodi.html_entity,
		tipologie_periodi.font_awesome,
		tipologie_periodi.se_corsi,
		tipologie_periodi.se_tesseramenti,
		tipologie_periodi.se_abbonamenti,
		tipologie_periodi.id_account_inserimento,
		tipologie_periodi.id_account_aggiornamento,
		tipologie_periodi_path( tipologie_periodi.id ) AS __label__
	FROM tipologie_periodi
;

-- | 090000054201

-- tipologie_popup_view
-- tipologia: tabella assistita
-- verifica: 2021-10-19 13:11 Fabio Mosti
CREATE OR REPLACE VIEW `tipologie_popup_view` AS
	SELECT
		tipologie_popup.id,
		tipologie_popup.id_genitore,
		tipologie_popup.ordine,
		tipologie_popup.nome,
		tipologie_popup.html_entity,
		tipologie_popup.font_awesome,
		tipologie_popup.id_account_inserimento,
		tipologie_popup.id_account_aggiornamento,
		tipologie_popup_path( tipologie_popup.id ) AS __label__
	FROM tipologie_popup
;

-- | 090000054601

-- tipologie_prodotti_view
CREATE OR REPLACE VIEW `tipologie_prodotti_view` AS
	SELECT
		tipologie_prodotti.id,
		tipologie_prodotti.id_genitore,
		tipologie_prodotti.ordine,
		tipologie_prodotti.nome,
		tipologie_prodotti.html_entity,
		tipologie_prodotti.font_awesome,
		tipologie_prodotti.se_colori,
		tipologie_prodotti.se_taglie,
		tipologie_prodotti.se_dimensioni,
		tipologie_prodotti.se_imballo,
		tipologie_prodotti.se_spedizione,
		tipologie_prodotti.se_trasporto,
		tipologie_prodotti.se_prodotto,
		tipologie_prodotti.se_servizio,
		tipologie_prodotti.se_volume,
		tipologie_prodotti.se_capacita,
		tipologie_prodotti.se_peso,
		tipologie_prodotti.id_account_inserimento,
		tipologie_prodotti.id_account_aggiornamento,
		tipologie_prodotti_path( tipologie_prodotti.id ) AS __label__
	FROM tipologie_prodotti
;

-- | 090000055001

-- tipologie_progetti_view
CREATE OR REPLACE VIEW `tipologie_progetti_view` AS
	SELECT
		tipologie_progetti.id,
		tipologie_progetti.id_genitore,
		tipologie_progetti.ordine,
		tipologie_progetti.nome,
		tipologie_progetti.html_entity,
		tipologie_progetti.font_awesome,
		tipologie_progetti.se_produzione,
		tipologie_progetti.se_contratto,
		tipologie_progetti.se_pacchetto,
		tipologie_progetti.se_progetto,
		tipologie_progetti.se_consuntivo,
		tipologie_progetti.se_forfait,
		tipologie_progetti.se_didattica,
		tipologie_progetti.id_account_inserimento,
		tipologie_progetti.id_account_aggiornamento,
		tipologie_progetti_path( tipologie_progetti.id ) AS __label__
	FROM tipologie_progetti
;

-- | 090000055400

-- tipologie_pubblicazioni_view
CREATE OR REPLACE VIEW `tipologie_pubblicazioni_view` AS        --
	SELECT                                                      --
		tipologie_pubblicazioni.id,                             --
		tipologie_pubblicazioni.id_genitore,                    --
		tipologie_pubblicazioni.ordine,                         --
		tipologie_pubblicazioni.nome,                           --
		tipologie_pubblicazioni.html_entity,                    --
		tipologie_pubblicazioni.font_awesome,                   --
		tipologie_pubblicazioni.id_account_inserimento,         --
		tipologie_pubblicazioni.id_account_aggiornamento,       --
		tipologie_pubblicazioni_path(                           --
            tipologie_pubblicazioni.id                          --
        ) AS __label__                                          -- etichetta per le tendine e le liste
	FROM tipologie_pubblicazioni                                --
;                                                               --

-- | 090000055701

-- tipologie_rinnovi_view
-- tipologia: tabella di supporto
-- verifica: 2022-04-29 17:45 Chiara GDL
CREATE OR REPLACE VIEW `tipologie_rinnovi_view` AS
	SELECT
		tipologie_rinnovi.id,
		tipologie_rinnovi.id_genitore,
		tipologie_rinnovi.ordine,
		tipologie_rinnovi.nome,
		tipologie_rinnovi.html_entity,
		tipologie_rinnovi.font_awesome,
		tipologie_rinnovi.se_tesseramenti, 
		tipologie_rinnovi.se_iscrizioni, 
		tipologie_rinnovi.se_abbonamenti,
		tipologie_rinnovi.se_licenze, 
		tipologie_rinnovi.se_contratti,
		tipologie_rinnovi.se_progetti,
		tipologie_rinnovi.id_account_inserimento,
		tipologie_rinnovi.id_account_aggiornamento,
		tipologie_rinnovi_path( tipologie_rinnovi.id ) AS __label__
	FROM tipologie_rinnovi
;

-- | 090000055801

-- tipologie_risorse_view
-- tipologia: tabella assistita
-- verifica: 2021-10-19 13:11 Fabio Mosti
CREATE OR REPLACE VIEW `tipologie_risorse_view` AS
	SELECT
		tipologie_risorse.id,
		tipologie_risorse.id_genitore,
		tipologie_risorse.ordine,
		tipologie_risorse.nome,
		tipologie_risorse.html_entity,
		tipologie_risorse.font_awesome,
		tipologie_risorse.id_account_inserimento,
		tipologie_risorse.id_account_aggiornamento,
		tipologie_risorse_path( tipologie_risorse.id ) AS __label__
	FROM tipologie_risorse
;

-- | 090000055901

-- tipologie_sconti_view
CREATE OR REPLACE VIEW `tipologie_sconti_view` AS
	SELECT
		tipologie_sconti.id,
		tipologie_sconti.nome,
		tipologie_sconti.nome AS __label__
	FROM tipologie_sconti
;

-- | 090000056001

-- tipologie_spedizioni_view
CREATE OR REPLACE VIEW `tipologie_spedizioni_view` AS
	SELECT
		tipologie_spedizioni.id,
		tipologie_spedizioni.id_genitore,
		tipologie_spedizioni.ordine,
		tipologie_spedizioni.nome,
		tipologie_spedizioni.html_entity,
		tipologie_spedizioni.font_awesome,
		tipologie_spedizioni.id_account_inserimento,
		tipologie_spedizioni.id_account_aggiornamento,
		tipologie_spedizioni_path( tipologie_spedizioni.id ) AS __label__
	FROM tipologie_spedizioni
;

-- | 090000056200

-- tipologie_telefoni_view
CREATE OR REPLACE VIEW `tipologie_telefoni_view` AS           --
	SELECT                                                    --
		tipologie_telefoni.id,                                --
		tipologie_telefoni.id_genitore,                       --
		tipologie_telefoni.ordine,                            --
		tipologie_telefoni.nome,                              --
		tipologie_telefoni.html_entity,                       --
		tipologie_telefoni.font_awesome,                      --
		tipologie_telefoni.id_account_inserimento,            --
		tipologie_telefoni.id_account_aggiornamento,          --
		tipologie_telefoni_path(                              --
            tipologie_telefoni.id ) AS __label__              -- etichetta per le tendine e le liste
	FROM tipologie_telefoni                                   --
;                                                             --

-- | 090000056601

-- tipologie_todo_view
-- tipologia: tabella assistita
-- verifica: 2021-10-19 13:12 Fabio Mosti
CREATE OR REPLACE VIEW `tipologie_todo_view` AS
	SELECT
		tipologie_todo.id,
		tipologie_todo.id_genitore,
		tipologie_todo.ordine,
		tipologie_todo.nome,
		tipologie_todo.html_entity,
		tipologie_todo.font_awesome,
		tipologie_todo.se_agenda,
		tipologie_todo.se_ticket,
		tipologie_todo.se_commerciale,
		tipologie_todo.se_produzione,
		tipologie_todo.se_amministrazione,
		tipologie_todo.id_account_inserimento,
		tipologie_todo.id_account_aggiornamento,
		tipologie_todo_path( tipologie_todo.id ) AS __label__
	FROM tipologie_todo
;

-- | 090000056800

-- tipologie_url_view
CREATE OR REPLACE VIEW `tipologie_url_view` AS                --
	SELECT                                                    --
		tipologie_url.id,                                     --
		tipologie_url.id_genitore,                            --
		tipologie_url.ordine,                                 --
		tipologie_url.nome,                                   --
		tipologie_url.html_entity,                            --
		tipologie_url.font_awesome,                           --
		tipologie_url.id_account_inserimento,                 --
		tipologie_url.id_account_aggiornamento,               --
		tipologie_url_path( tipologie_url.id ) AS __label__   -- etichetta per le tendine e le liste
	FROM tipologie_url                                        --
;                                                             --

-- | 090000056900

-- tipologie_veicoli_view
CREATE OR REPLACE VIEW `tipologie_veicoli_view` AS                --
	SELECT                                                    --
		tipologie_veicoli.id,                                     --
		tipologie_veicoli.id_genitore,                            --
		tipologie_veicoli.ordine,                                 --
		tipologie_veicoli.nome,                                   --
		tipologie_veicoli.html_entity,                            --
		tipologie_veicoli.font_awesome,                           --
		tipologie_veicoli.id_account_inserimento,                 --
		tipologie_veicoli.id_account_aggiornamento,               --
		tipologie_veicoli_path( tipologie_veicoli.id ) AS __label__   -- etichetta per le tendine e le liste
	FROM tipologie_veicoli                                        --
;                                                             --

-- | 090000056951

-- tipologie_zone
-- tipologia: tabella gestita
-- verifica: 2022-06-16 16:40 Chiara GDL
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

-- | 090000060101

-- todo_matricole_view
-- tipologia: tabella gestita
-- verifica: 2022-04-27 15:07 Chiara GDL
CREATE OR REPLACE VIEW todo_matricole_view AS
	SELECT
		todo_matricole.id,
		todo_matricole.id_todo,
		todo.nome AS todo,
		todo_matricole.id_matricola,
		matricole.matricola AS matricola,
		todo_matricole.id_ruolo,
		ruoli_matricole_path( todo_matricole.id_ruolo ) AS ruolo,
		todo_matricole.ordine,
		todo_matricole.id_account_inserimento,
		todo_matricole.id_account_aggiornamento,
 		concat_ws(
			' ',
			todo.nome,
			matricole.matricola
		) AS __label__
	FROM todo_matricole
		LEFT JOIN todo ON todo.id = todo_matricole.id_todo
		LEFT JOIN matricole ON matricole.id = todo_matricole.id_matricola
;

-- | 090000062000

-- udm_view
CREATE OR REPLACE VIEW udm_view AS
	SELECT
		udm.id,
		coalesce( udm.id_base, udm.id ) AS id_base,
		coalesce( udm.conversione, 1 ) AS conversione,
		udm.nome,
		udm.sigla,
		udm.se_lunghezza,
		udm.se_volume,
		udm.se_peso,
		udm.se_tempo,
		udm.se_quantita,
		udm.se_area,
		udm.sigla AS __label__
	FROM udm
;

-- | 090000062600

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
;                                                             --

-- | 090000062901

-- valutazioni_view
-- tipologia: tabella gestita
-- verifica: 2022-04-28 Chiara GDL
CREATE OR REPLACE VIEW valutazioni_view AS
	SELECT
		valutazioni.id,
		valutazioni.id_anagrafica,
		coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ) AS anagrafica,
		valutazioni.id_matricola,
		matricole.matricola AS matricola,
		valutazioni.id_immobile,
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
		valutazioni.mq_commerciali,
		valutazioni.mq_calpestabili,
		valutazioni.id_condizione,
		condizioni.nome AS condizione,
		valutazioni.id_disponibilita,
		disponibilita.nome AS disponibilita,
		valutazioni.id_classe_energetica,
		classi_energetiche.nome AS classe_energetica,
		valutazioni.timestamp_valutazione,
		valutazioni.id_account_inserimento,
		valutazioni.id_account_aggiornamento,
		concat('valutazione ', 	concat_ws(
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
		) ) AS __label__
	FROM valutazioni
		LEFT JOIN anagrafica ON anagrafica.id = valutazioni.id_anagrafica
		LEFT JOIN matricole ON matricole.id = valutazioni.id_matricola
		LEFT JOIN immobili ON immobili.id = valutazioni.id_immobile
		LEFT JOIN condizioni ON condizioni.id = valutazioni.id_condizione
		LEFT JOIN disponibilita ON disponibilita.id = valutazioni.id_disponibilita
		LEFT JOIN classi_energetiche ON classi_energetiche.id = valutazioni.id_classe_energetica
		LEFT JOIN tipologie_immobili ON tipologie_immobili.id = immobili.id_tipologia
		LEFT JOIN edifici ON edifici.id = immobili.id_edificio
		LEFT JOIN tipologie_edifici ON tipologie_edifici.id = edifici.id_tipologia
		LEFT JOIN indirizzi ON indirizzi.id = edifici.id_indirizzo
		LEFT JOIN tipologie_indirizzi ON tipologie_indirizzi.id = indirizzi.id_tipologia
		LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
		LEFT JOIN regioni ON regioni.id = provincie.id_regione
		LEFT JOIN stati ON stati.id = regioni.id_stato;

-- | 090000062951

-- valutazioni_certificazioni_view
-- tipologia: tabella gestita
-- verifica: 2022-05-23 Chiara GDL
CREATE OR REPLACE VIEW `valutazioni_certificazioni_view` AS
	SELECT
		valutazioni_certificazioni.id,
		valutazioni_certificazioni.id_valutazione,
		valutazioni_certificazioni.id_certificazione,
		certificazioni.nome AS certificazione,
		valutazioni_certificazioni.id_emittente,
		coalesce( emittente.denominazione , concat( emittente.cognome, ' ', emittente.nome ), '' ) AS emittente,
		valutazioni_certificazioni.nome,
		valutazioni_certificazioni.codice,
		valutazioni_certificazioni.data_emissione,
		valutazioni_certificazioni.data_scadenza,
		concat(
			valutazioni_certificazioni.id_valutazione, ' ',
			certificazioni.nome,
			' - ',
			valutazioni_certificazioni.codice
		) AS __label__
	FROM valutazioni_certificazioni
		LEFT JOIN anagrafica AS emittente ON emittente.id = valutazioni_certificazioni.id_emittente
		INNER JOIN certificazioni ON certificazioni.id = valutazioni_certificazioni.id_certificazione		
;

-- | 090000063000

-- valute_view
CREATE OR REPLACE VIEW `valute_view` AS
	SELECT
		valute.id,
		valute.iso4217,
		valute.html_entity,
		valute.utf8,
		valute.iso4217 AS __label__
	FROM valute
;

-- | 090000063500

-- taglie_view
CREATE OR REPLACE VIEW `taglie_view` AS
	SELECT
		taglie.id,
		taglie.nome AS __label__
	FROM taglie
;

-- | 090000063600

-- periodicita_view
--
-- la TABELLA periodicita era gia' in queste patch, la VISTA no, e il framework la usa in otto
-- macro diverse ( articoli, contratti, pianificazioni, corsi, tesseramenti, abbonamenti, progetti ),
-- tre delle quali ordinano per giorni. Aggiunta l'08/09/2026.
CREATE OR REPLACE VIEW `periodicita_view` AS
	SELECT
		periodicita.id,
		periodicita.nome,
		periodicita.giorni,
		periodicita.nome AS __label__
	FROM periodicita
;
-- | 090000064000

-- veicoli_view
CREATE OR REPLACE VIEW veicoli_view AS
    SELECT
        veicoli.id,
        veicoli.id_tipologia,
        tipologie_veicoli_path( veicoli.id_tipologia ) AS tipologia,
        veicoli.id_costruttore,
        coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS produttore,
        veicoli.modello,
        veicoli.targa,
        veicoli.data_archiviazione,
        veicoli.id_account_inserimento,
        veicoli.id_account_aggiornamento,
        concat_ws(
            ' - ',
            coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ) ),
            veicoli.nome,
            veicoli.modello,
            veicoli.targa
        ) AS __label__
    FROM veicoli
        LEFT JOIN anagrafica AS a1 ON a1.id = veicoli.id_costruttore
;

-- | 090000065000

-- video_view
CREATE OR REPLACE VIEW `video_view` AS
	SELECT
		video.id,
		video.id_anagrafica,
		video.id_pagina,
		video.id_file,
		video.id_prodotto,
		video.id_articolo,
		video.id_categoria_prodotti,
		video.id_marchio,
		video.id_risorsa,
		video.id_categoria_risorse,
		video.id_notizia,
		video.id_annuncio,
		video.id_categoria_notizie,
		video.id_categoria_annunci,
		video.id_lingua,
		lingue.nome AS lingua,
		video.id_ruolo,
		video.id_progetto,
		video.id_categoria_progetti,
		video.id_indirizzo,
		video.id_edificio,
		video.id_immobile,
        video.id_valutazione,
		ruoli_video.nome AS ruolo,
		video.ordine,
		video.nome,
		video.path,
		video.embed,
		video.codice_embed,
		video.embed_custom,
		video.target,
		video.orientamento,
		video.ratio,
		video.note,
		video.id_account_inserimento,
		video.id_account_aggiornamento,
		concat(
			ruoli_video.nome,
			' # ',
			video.ordine,
			' / ',
			video.nome
		) AS __label__
	FROM video
		LEFT JOIN lingue ON lingue.id = video.id_lingua
		LEFT JOIN ruoli_video ON ruoli_video.id = video.id_ruolo
;

-- | 090000100001

-- zone_view
-- tipologia: tabella gestita
-- verifica: 2022-06-16 13:16 Chiara GDL
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

-- | 090000100101

-- zone_cap_view
-- tipologia: tabella gestita
-- verifica: 2022-06-16 13:16 Chiara GDL
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

-- | 090000100201

-- zone_indirizzi_view
-- tipologia: tabella gestita
-- verifica: 2022-06-16 13:16 Chiara GDL
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

-- | 090000100401

-- zone_stati_view
-- tipologia: tabella gestita
-- verifica: 2022-06-16 13:16 Chiara GDL
CREATE OR REPLACE VIEW zone_stati_view AS
	SELECT
		zone_stati.id,
		zone_stati.id_stato,
		stati.nome AS stato,
		zone_stati.id_zona,
		zone.nome AS zona,
		zone_stati.ordine,
		zone_stati.id_account_inserimento,
		zone_stati.id_account_aggiornamento,
		concat(zone_stati.id_stato, ' - ', zone_stati.id_zona) AS __label__
	FROM zone_stati
		LEFT JOIN stati ON stati.id = zone_stati.id_stato
		LEFT JOIN zone ON zone.id = zone_stati.id_zona
;

-- | 090000999000

-- test_view
CREATE OR REPLACE VIEW test_view AS                           --
  SELECT                                                      --
    test.id,                                                  --
    test.codice,                                              --
    test.nome,                                                --
    concat_ws(                                                --
      ' ',                                                    --
      test.codice,                                            --
      test.nome                                               --
    ) AS __label__                                            -- etichetta per le tendine e le liste
  FROM test                                                   --
;                                                             --

-- | 090000999200

-- __report_evasione_ordini__
-- Stato di avanzamento delle consegne, un DDT per riga: data, cliente e stato ricavato
-- dall'ultima attivita' collegata al documento. Grana: il documento.
-- NB: esiste anche __report_evasione_righe_ordini__, che risponde a una domanda diversa
-- ( di questo ordine cosa manca ) con grana di riga. I due nomi si somigliano perche' fino
-- al 2026-09-01 erano lo stesso nome su database diversi, con due definizioni incompatibili.
CREATE OR REPLACE VIEW `__report_evasione_ordini__` AS with a as (select `attivita`.`id_documento` AS `id_documento`,`attivita`.`id_tipologia` AS `id_tipologia`,row_number() over ( partition by `attivita`.`id_documento` order by `attivita`.`data_attivita` desc) AS `rank` from `attivita`)select `documenti`.`data` AS `data`,`anagrafica`.`codice` AS `codice`,concat_ws(' ',`anagrafica`.`nome`,`anagrafica`.`cognome`,`anagrafica`.`denominazione`) AS `cliente`,coalesce(`tipologie_attivita`.`nome`,'ancora da iniziare') AS `stato` from (((`documenti` join `anagrafica` on(`anagrafica`.`id` = `documenti`.`id_destinatario`)) left join `a` on(`a`.`id_documento` = `documenti`.`id` and `a`.`rank` = 1)) left join `tipologie_attivita` on(`tipologie_attivita`.`id` = `a`.`id_tipologia`)) where `documenti`.`id_tipologia` = 4 group by `documenti`.`id`
;

-- | 090000999201

-- __report_evasione_righe_ordini__
-- Evasione riga per riga: quanto e' stato ordinato, quanto evaso, quanto resta, con l'unita'
-- di misura. Grana: la riga d'ordine.
CREATE OR REPLACE VIEW `__report_evasione_righe_ordini__` AS select `ordine`.`id_documento` AS `id_documento`,`ordine`.`id_ordine` AS `id_ordine`,`ordine`.`codice_prodotto` AS `codice_prodotto`,`ordine`.`prodotto` AS `prodotto`,sum(`ordine`.`quantita_ordinata` / `udm`.`conversione`) AS `quantita_ordinata`,sum(`ordine`.`quantita_evasa` / `udm`.`conversione`) AS `quantita_evasa`,sum(`ordine`.`quantita_ordinata` / `udm`.`conversione`) - sum(`ordine`.`quantita_evasa` / `udm`.`conversione`) AS `quantita_da_evadere`,`udm`.`sigla` AS `udm` from ((select `relazioni_documenti`.`id_documento` AS `id_documento`,`documenti`.`id` AS `id_ordine`,coalesce(`documenti_articoli`.`id_prodotto`,`articoli`.`id_prodotto`) AS `codice_prodotto`,`prodotti`.`nome` AS `prodotto`,`documenti_articoli`.`id_articolo` AS `codice_articolo`,coalesce(`documenti_articoli`.`quantita` * `udm`.`conversione`,0) AS `quantita_ordinata`,0 AS `quantita_evasa`,`udm_base`.`sigla` AS `udm_base`,`udm`.`id` AS `id_udm` from (((((((`documenti` left join `relazioni_documenti` on(`relazioni_documenti`.`id_documento_collegato` = `documenti`.`id`)) left join `tipologie_documenti` on(`tipologie_documenti`.`id` = `documenti`.`id_tipologia`)) left join `documenti_articoli` on(`documenti_articoli`.`id_documento` = `documenti`.`id`)) left join `articoli` on(`articoli`.`id` = `documenti_articoli`.`id_articolo`)) left join `prodotti` on(`prodotti`.`id` = coalesce(`documenti_articoli`.`id_prodotto`,`articoli`.`id_prodotto`))) left join `udm` on(`udm`.`id` = `documenti_articoli`.`id_udm`)) left join `udm` `udm_base` on(`udm_base`.`id` = `udm`.`id_base`)) where `tipologie_documenti`.`se_ordine` is not null having `codice_prodotto` is not null union select `relazioni_documenti`.`id_documento` AS `id_documento`,`relazioni_documenti`.`id_documento_collegato` AS `id_ordine`,coalesce(`documenti_articoli`.`id_prodotto`,`articoli`.`id_prodotto`) AS `codice_prodotto`,`prodotti`.`nome` AS `prodotto`,`documenti_articoli`.`id_articolo` AS `codice_articolo`,0 AS `quantita_ordinata`,coalesce(`articoli`.`peso` * `udm`.`conversione` * `documenti_articoli`.`quantita`,0) AS `quantita_evasa`,`udm_base`.`sigla` AS `udm_base`,`udm`.`id` AS `id_udm` from (((((((`documenti` join `relazioni_documenti` on(`relazioni_documenti`.`id_documento` = `documenti`.`id`)) left join `tipologie_documenti` on(`tipologie_documenti`.`id` = `documenti`.`id_tipologia`)) left join `documenti_articoli` on(`documenti_articoli`.`id_documento` = `documenti`.`id`)) left join `articoli` on(`articoli`.`id` = `documenti_articoli`.`id_articolo`)) left join `prodotti` on(`prodotti`.`id` = coalesce(`documenti_articoli`.`id_prodotto`,`articoli`.`id_prodotto`))) left join `udm` on(`udm`.`id` = `articoli`.`id_udm_peso`)) left join `udm` `udm_base` on(`udm_base`.`id` = `udm`.`id_base`)) where `tipologie_documenti`.`se_trasporto` is not null having `codice_prodotto` is not null) `ordine` left join `udm` on(`udm`.`id` = (select coalesce(max(`documenti_articoli`.`id_udm`),max(`articoli`.`id_udm_peso`)) from (`documenti_articoli` left join `articoli` on(`articoli`.`id` = `ordine`.`codice_articolo`)) where `documenti_articoli`.`id_documento` in (`ordine`.`id_documento`,`ordine`.`id_ordine`) and (`documenti_articoli`.`id_prodotto` = `ordine`.`codice_prodotto` or `articoli`.`id` = `ordine`.`codice_articolo`)))) group by `ordine`.`id_documento`,`ordine`.`id_ordine`,`ordine`.`codice_prodotto`,`ordine`.`prodotto`,`udm`.`conversione`,`udm`.`sigla`
;

-- | 090000999210

-- todo_view
-- Le sei colonne che vengono da `istruzioni` ( id_documento .. istruzione ) erano il motivo per
-- cui questa vista aveva 40 colonne su connor e 34 altrove: vedi 2026090105.
CREATE OR REPLACE VIEW `todo_view` AS select `todo`.`id` AS `id`,`todo`.`id_tipologia` AS `id_tipologia`,`tipologie_todo`.`nome` AS `tipologia`,`todo`.`codice` AS `codice`,`tipologie_todo`.`se_agenda` AS `se_agenda`,`todo`.`id_anagrafica` AS `id_anagrafica`,coalesce(`a1`.`denominazione`,concat(`a1`.`cognome`,' ',`a1`.`nome`),'') AS `anagrafica`,`todo`.`id_cliente` AS `id_cliente`,coalesce(`a2`.`denominazione`,concat(`a2`.`cognome`,' ',`a2`.`nome`),'') AS `cliente`,`todo`.`id_indirizzo` AS `id_indirizzo`,concat_ws(' ',`indirizzi`.`indirizzo`,`indirizzi`.`civico`,`indirizzi`.`cap`,`indirizzi`.`localita`,`comuni`.`nome`,`provincie`.`sigla`) AS `indirizzo`,`todo`.`id_luogo` AS `id_luogo`,`luoghi_path`(`todo`.`id_luogo`) AS `luogo`,`todo`.`timestamp_apertura` AS `timestamp_apertura`,`todo`.`data_scadenza` AS `data_scadenza`,`todo`.`ora_scadenza` AS `ora_scadenza`,`todo`.`data_programmazione` AS `data_programmazione`,`todo`.`ora_inizio_programmazione` AS `ora_inizio_programmazione`,`todo`.`ora_fine_programmazione` AS `ora_fine_programmazione`,`todo`.`anno_programmazione` AS `anno_programmazione`,`todo`.`settimana_programmazione` AS `settimana_programmazione`,`todo`.`ore_programmazione` AS `ore_programmazione`,`todo`.`data_chiusura` AS `data_chiusura`,`todo`.`nome` AS `nome`,`todo`.`id_contatto` AS `id_contatto`,`todo`.`id_progetto` AS `id_progetto`,`progetti`.`nome` AS `progetto`,group_concat(distinct if(`d`.`id`,`categorie_progetti_path`(`d`.`id`),NULL) separator ' | ') AS `discipline`,`todo`.`id_documento` AS `id_documento`,concat(`tipologie_documenti`.`sigla`,' ',concat_ws('/',`documenti`.`numero`,`documenti`.`sezionale`),' del ',`documenti`.`data`) AS `documento`,`todo`.`id_documenti_articoli` AS `id_documenti_articoli`,concat(`documenti_articoli`.`data`,' / ',`tipologie_documenti`.`sigla`,' / ',`documenti_articoli`.`quantita`,' x ',`documenti_articoli`.`id_articolo`) AS `documenti_articoli`,`todo`.`id_istruzione` AS `id_istruzione`,concat(`istruzioni`.`id_tipologia`,coalesce(`istruzioni`.`id_prodotto`,`istruzioni`.`id_articolo`),`istruzioni`.`nome`) AS `istruzione`,`todo`.`id_pianificazione` AS `id_pianificazione`,`todo`.`id_immobile` AS `id_immobile`,`todo`.`data_archiviazione` AS `data_archiviazione`,`todo`.`id_account_inserimento` AS `id_account_inserimento`,`todo`.`id_account_aggiornamento` AS `id_account_aggiornamento`,concat(`todo`.`nome`,coalesce(concat(' per ',`a2`.`denominazione`,concat(`a2`.`cognome`,' ',`a2`.`nome`)),''),coalesce(concat(' su ',`todo`.`id_progetto`,' ',`progetti`.`nome`),'')) AS `__label__` from ((((((((((((((`todo` left join `anagrafica` `a1` on(`a1`.`id` = `todo`.`id_anagrafica`)) left join `anagrafica` `a2` on(`a2`.`id` = `todo`.`id_cliente`)) left join `indirizzi` on(`indirizzi`.`id` = `todo`.`id_indirizzo`)) left join `comuni` on(`comuni`.`id` = `indirizzi`.`id_comune`)) left join `provincie` on(`provincie`.`id` = `comuni`.`id_provincia`)) left join `tipologie_todo` on(`tipologie_todo`.`id` = `todo`.`id_tipologia`)) left join `progetti` on(`progetti`.`id` = `todo`.`id_progetto`)) left join `progetti_categorie` on(`progetti_categorie`.`id_progetto` = `progetti`.`id`)) left join `categorie_progetti` `d` on(`d`.`id` = `progetti_categorie`.`id_categoria` and `d`.`se_disciplina` = 1)) left join `documenti` on(`documenti`.`id` = `todo`.`id_documento`)) left join `tipologie_documenti` on(`tipologie_documenti`.`id` = `documenti`.`id_tipologia`)) left join `documenti_articoli` on(`documenti_articoli`.`id` = `todo`.`id_documenti_articoli`)) left join `tipologie_documenti` `tipologie_documenti_articoli` on(`tipologie_documenti_articoli`.`id` = `documenti_articoli`.`id_tipologia_documento`)) left join `istruzioni` on(`istruzioni`.`id` = `todo`.`id_istruzione`)) group by `todo`.`id`
;

-- | FINE FILE
