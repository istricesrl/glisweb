-- 2026-10-02 — residui del canone, 4 di 4: le viste che mancano
--
-- Le viste dei file di base che su glisdev mancavano e che nessuna patch crea: iva_view, veicoli_view e
-- __report_iscrizioni_anagrafica__ non sono in nessuna patch, le altre stavano in patch che glisdev non ha mai
-- girato per intero. CREATE VIEW IF NOT EXISTS: dove un progetto ha la sua versione, resta la sua. Copiate da
-- _090000999999.views.sql e _100000999999.reports.sql.
--
-- Una vista cita colonne del canone: un database a cui ne manca una si ferma con 1054, e la cura e' aggiungere la
-- colonna ( _202610023000.residui.colonne.sql lo fa ), non toccare la vista. IDEMPOTENTE.

-- | 202610023300

-- colli_view
CREATE VIEW IF NOT EXISTS `colli_view` AS
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

-- | 202610023301

-- iva_view
CREATE VIEW IF NOT EXISTS iva_view AS
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

-- | 202610023302

-- mastri_tipologie_veicoli_view
CREATE VIEW IF NOT EXISTS `mastri_tipologie_veicoli_view` AS
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

-- | 202610023303

-- notizie_anagrafica_view
CREATE VIEW IF NOT EXISTS `notizie_anagrafica_view` AS
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

-- | 202610023304

-- prezzi_view
CREATE VIEW IF NOT EXISTS `prezzi_view` AS
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

-- | 202610023305

-- tipologie_colli_view
CREATE VIEW IF NOT EXISTS `tipologie_colli_view` AS
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

-- | 202610023306

-- tipologie_veicoli_view
CREATE VIEW IF NOT EXISTS `tipologie_veicoli_view` AS                --
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

-- | 202610023307

-- veicoli_view
CREATE VIEW IF NOT EXISTS veicoli_view AS
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

-- | 202610023308

-- __report_iscrizioni_anagrafica__
CREATE VIEW IF NOT EXISTS __report_iscrizioni_anagrafica__ AS
    SELECT
        contratti.id AS id,
        contratti.id_tipologia AS id_tipologia,
        contratti_anagrafica.id_anagrafica AS id_anagrafica,
        tipologie_contratti.nome AS tipologia,
        tipologie_contratti.se_abbonamento AS se_abbonamento,
        tipologie_contratti.se_iscrizione AS se_iscrizione,
        tipologie_contratti.se_tesseramento AS se_tesseramento,
        tipologie_contratti.se_immobili AS se_immobili,
        tipologie_contratti.se_acquisto AS se_acquisto,
        tipologie_contratti.se_locazione AS se_locazione,
        rinnovi.id AS id_rinnovo,
        rinnovi.id_tipologia AS id_tipologia_rinnovo,
        tipologie_rinnovi.nome AS tipologia_rinnovo,
        contratti.id AS id_contratto,
        contratti.nome AS contratto,
        contratti.codice AS tessera,
        rinnovi.id_licenza AS id_licenza,
        licenze.nome AS licenza,
        coalesce( rinnovi.id_progetto, contratti.id_progetto ) AS id_progetto,
        progetti.nome AS progetto,
        max( categorie_progetti.id ) AS id_disciplina_progetto,
        max( categorie_progetti.nome ) AS disciplina_progetto,
        m1.testo AS non_applicare_sconti,
        rinnovi.data_inizio AS data_inizio,
        rinnovi.data_fine AS data_fine,
        rinnovi.codice AS codice,
        rinnovi.id_pianificazione AS id_pianificazione,
        rinnovi.id_account_inserimento AS id_account_inserimento,
        rinnovi.id_account_aggiornamento AS id_account_aggiornamento,
        concat( 'rinnovo ', rinnovi.id, ' dal ', concat_ws( '-', rinnovi.data_inizio ), ' al ', concat_ws( '-', rinnovi.data_fine ) ) AS __label__
    FROM
        contratti
        LEFT JOIN rinnovi ON rinnovi.id_contratto = contratti.id
        LEFT JOIN tipologie_rinnovi ON tipologie_rinnovi.id = rinnovi.id_tipologia
        LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
        LEFT JOIN contratti_anagrafica ON contratti_anagrafica.id_contratto = contratti.id
        LEFT JOIN licenze ON licenze.id = rinnovi.id_licenza
        LEFT JOIN progetti ON progetti.id = coalesce( rinnovi.id_progetto, contratti.id_progetto )
        LEFT JOIN progetti_categorie ON progetti_categorie.id_progetto = progetti.id
        LEFT JOIN categorie_progetti ON categorie_progetti.id = progetti_categorie.id_categoria AND categorie_progetti.se_disciplina = 1
        LEFT JOIN metadati m1 ON m1.id_progetto = progetti.id AND m1.nome = 'non_applicare_sconti'
    WHERE
        tipologie_contratti.se_iscrizione IS NOT NULL
    GROUP BY
        contratti.id, contratti_anagrafica.id_anagrafica, rinnovi.id, progetti.id
;

-- | FINE
