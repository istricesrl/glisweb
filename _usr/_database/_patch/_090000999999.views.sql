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

-- | 090000001300

-- articoli_view
CREATE OR REPLACE VIEW `articoli_view` AS
	SELECT
		articoli.id,
		articoli.codice,
		articoli.id_prodotto,
        prodotti.nome AS prodotto,
		articoli.ordine,
		articoli.ean,
		articoli.isbn,
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
			articoli.nome,
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
		group_concat( DISTINCT prodotti_categorie.id_categoria SEPARATOR ' | ' ) AS id_categorie,
		group_concat( DISTINCT categorie_prodotti_path( prodotti_categorie.id_categoria ) SEPARATOR ' | ' ) AS categorie,
		group_concat( DISTINCT concat_ws( ' ', listini.nome, valute.iso4217, format( prezzi.prezzo, 2, 'it_IT' ) ) SEPARATOR ' | ' ) AS prezzi,
        coalesce( articoli.data_archiviazione, prodotti.data_archiviazione ) AS data_archiviazione,
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
		) AS __label__
	FROM articoli
		LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
		LEFT JOIN udm AS udm_dimensioni ON udm_dimensioni.id = articoli.id_udm_dimensioni
		LEFT JOIN udm AS udm_peso ON udm_peso.id = articoli.id_udm_peso
		LEFT JOIN udm AS udm_volume ON udm_volume.id = articoli.id_udm_volume
		LEFT JOIN udm AS udm_capacita ON udm_capacita.id = articoli.id_udm_capacita
		LEFT JOIN udm AS udm_durata ON udm_durata.id = articoli.id_udm_durata
		LEFT JOIN prodotti_categorie ON prodotti_categorie.id_prodotto = articoli.id_prodotto
		LEFT JOIN prezzi ON prezzi.id_articolo = articoli.id
		LEFT JOIN listini ON listini.id = prezzi.id_listino
		LEFT JOIN valute ON valute.id = listini.id_valuta
		LEFT JOIN periodicita ON periodicita.id = articoli.id_periodicita
		LEFT JOIN tipologie_rinnovi ON tipologie_rinnovi.id = articoli.id_tipologia_rinnovo
	GROUP BY articoli.id
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

-- | 090000002900

-- caratteristiche_view
CREATE OR REPLACE VIEW `caratteristiche_view` AS
	SELECT
		caratteristiche.id,
		caratteristiche.id_genitore,
		caratteristiche.nome,
		caratteristiche.html_entity,
		caratteristiche.font_awesome,
		caratteristiche.se_immobili,
		caratteristiche.se_categorie_prodotti,
		caratteristiche.se_prodotto,
		caratteristiche.se_articolo,
		caratteristiche.id_account_inserimento,
		caratteristiche.id_account_aggiornamento,
		caratteristiche_path(
            caratteristiche.id
        ) AS __label__
	FROM caratteristiche
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

-- | 090000006400

-- consensi_anagrafica_view
CREATE OR REPLACE VIEW `consensi_anagrafica_view` AS            --
  SELECT                                                      --
	consensi_anagrafica.id,                                       --
    consensi_anagrafica.id_consenso,                              --
	consensi.nome AS consenso,                                            --
	consensi_anagrafica.id_anagrafica,                              --
	concat_ws(
		' ',
		anagrafica.nome,
		anagrafica.cognome,
		anagrafica.denominazione
	) AS anagrafica,                              --
    consensi_anagrafica.modulo,                                   --
    consensi_anagrafica.valore,                                   --
    consensi_anagrafica.id_account_inserimento,                   --
	consensi_anagrafica.timestamp_inserimento,
	from_unixtime( consensi_anagrafica.timestamp_inserimento, '%Y-%m-%d %H:%i' ) AS data_ora_inserimento,
	consensi_anagrafica.id_account_aggiornamento,                 --
    concat(                                                   --
      'consenso ',                                            --
      consensi.nome,                            --
      ' per modulo ',                                         --
      consensi_anagrafica.modulo                                  --
    ) AS __label__                                            -- etichetta per le tendine e le liste
  FROM consensi_anagrafica                                        --
    INNER JOIN consensi ON consensi.id = consensi_anagrafica.id_consenso	--
	INNER JOIN anagrafica ON anagrafica.id = consensi_anagrafica.id_anagrafica	--
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
		sum( coalesce( pagamenti.importo_lordo_finale, pagamenti.importo_lordo_totale, 0 ) ) AS totale_lordo_finale,
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
		LEFT JOIN mastri AS m1 ON m1.id = documenti.id_mastro_provenienzagggggggggggg
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
		coalesce( documenti_articoli.id_tipologia, documenti.id_tipologia ) AS id_tipologia,
		tipologie_documenti.nome AS tipologia,
		documenti_articoli.ordine,
		documenti_articoli.id_documento,
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
        sum( coalesce( sotto_righe.quantita, 0 ) ) AS sotto_righe_quantita,
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
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = coalesce( documenti_articoli.id_tipologia, documenti.id_tipologia )
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
        LEFT JOIN documenti_articoli AS sotto_righe ON sotto_righe.id_genitore = documenti_articoli.id
    GROUP BY
        documenti_articoli.id
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
			ruoli_file.nome,
			' # ',
			file.ordine,
			' / ',
			file.nome,
			' / ',
			coalesce(
				file.path,
				file.url
			)
		) AS __label__
	FROM file
		LEFT JOIN ruoli_file ON ruoli_file.id = file.id_ruolo
		LEFT JOIN lingue ON lingue.id = file.id_lingua
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

-- | 090000017200

-- listini_view
CREATE OR REPLACE VIEW `listini_view` AS
	SELECT
		listini.id,
		listini.id_valuta,
		valute.iso4217 AS valuta,
		listini.nome,
		listini.id_account_inserimento,
		listini.id_account_aggiornamento,
		concat(
			listini.nome,
			' ',
			valute.iso4217
		) AS __label__
	FROM listini
		LEFT JOIN valute ON valute.id = listini.id_valuta
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
			mail_out.oggetto
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

-- | 090000020800

-- mastri_tipologie_veicoli_view
CREATE OR REPLACE VIEW `mastri_tipologie_veicoli_view` AS
    SELECT
        mastri_tipologie_veicoli.id,
        mastri_tipologie_veicoli.id_mastro,
        mastri_path( mastri_tipologie_veicoli.id_mastro ) AS mastro,
        mastri_tipologie_veicoli.id_tipologia,
        veicoli.targa AS veicolo,
        mastri_tipologie_veicoli.id_account_inserimento,
        mastri_tipologie_veicoli.id_account_aggiornamento,
        concat_ws(
            ' / ',
            mastri_path( mastri_tipologie_veicoli.id_mastro ),
            veicoli.targa
        ) AS __label__
    FROM mastri_tipologie_veicoli
    LEFT JOIN veicoli ON veicoli.id = mastri_tipologie_veicoli.id_tipologia
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
		pagamenti.id_documento,
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
		group_concat( DISTINCT categorie_progetti.id SEPARATOR '|' ) AS id_categorie_progetti,
		group_concat( DISTINCT categorie_progetti.nome SEPARATOR '|' ) AS categorie_progetti,
		group_concat( DISTINCT categorie_progetti_path_find_ancestor( categorie_progetti.id ) ) AS id_aree,
		group_concat( DISTINCT aree.nome ) AS aree,
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
		LEFT JOIN documenti ON documenti.id = pagamenti.id_documento
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
		LEFT JOIN anagrafica AS a1 ON a1.id = coalesce( documenti.id_emittente, pagamenti.id_creditore )
		LEFT JOIN anagrafica AS a2 ON a2.id = coalesce( documenti.id_destinatario, pagamenti.id_debitore )
		LEFT JOIN iban ON iban.id = pagamenti.id_iban
		LEFT JOIN coupon ON coupon.id = pagamenti.id_coupon
		LEFT JOIN contratti ON contratti.id = coupon.causale_id_contratto
		-- LEFT JOIN progetti ON progetti.id = contratti.id_progetto
		LEFT JOIN carrelli_articoli ON carrelli_articoli.id = pagamenti.id_carrelli_articoli
		LEFT JOIN articoli ON articoli.id = carrelli_articoli.id_articolo
		LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
		LEFT JOIN progetti ON IF( prodotti.id IS NOT NULL, progetti.id_prodotto = prodotti.id, progetti.id = contratti.id_progetto )
		LEFT JOIN progetti_categorie ON progetti_categorie.id_progetto = progetti.id
		LEFT JOIN categorie_progetti ON ( categorie_progetti.id = progetti_categorie.id_categoria AND categorie_progetti.se_disciplina = 1 )
		LEFT JOIN categorie_progetti AS aree ON aree.id = categorie_progetti_path_find_ancestor( categorie_progetti.id )
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
;															  --

-- | 090000026000

-- prodotti_view
CREATE OR REPLACE VIEW `prodotti_view` AS
	SELECT
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
		group_concat( DISTINCT categorie_prodotti_path( prodotti_categorie.id_categoria ) SEPARATOR ' | ' ) AS categorie,
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
		LEFT JOIN prodotti_categorie ON prodotti_categorie.id_prodotto = prodotti.id
	GROUP BY prodotti.id
;

-- | 090000027001

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
	 	ruoli_anagrafica_path( ruoli_anagrafica.id ) AS __label__
	FROM ruoli_anagrafica
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
		ruoli_immagini.se_notizie,                              --
		ruoli_immagini.se_categorie_notizie,                    --
		ruoli_immagini.se_risorse,                              --
		ruoli_immagini.se_categorie_risorse,                    --
		ruoli_immagini.se_immobili,                             --
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
		ruoli_video.se_notizie,
		ruoli_video.se_categorie_notizie,
		ruoli_video.se_risorse,
		ruoli_video.se_categorie_risorse,
		ruoli_video.se_immobili,
	 	ruoli_video_path( ruoli_video.id ) AS __label__
	FROM ruoli_video
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
		video.id_embed,
		video.codice_embed,
		video.embed_custom,
		video.target,
		video.orientamento,
		video.ratio,
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

-- | FINE FILE
