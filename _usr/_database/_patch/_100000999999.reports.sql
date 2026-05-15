--
-- REPORT
-- questo file contiene le query per la creazione dei report
--

-- | 100000020550

-- __report_immagini_scalate__
CREATE OR REPLACE VIEW __report_immagini_scalate__ AS
    SELECT
        sum(
        if( 
            ( timestamp_scalamento IS NOT NULL OR timestamp_scalamento >= timestamp_aggiornamento )
            AND timestamp_aggiornamento IS NOT NULL, 1, 0) 
        ) AS scalate,
        sum(
        if(
            timestamp_scalamento IS NULL OR timestamp_scalamento < timestamp_aggiornamento OR timestamp_aggiornamento IS NULL, 1, 0)
        ) AS da_scalare,
        count(
            immagini.id
        ) AS totali
    FROM
        immagini
;

-- __report_iscrizioni_anagrafica__
-- NOTA: il JOIN su categorie_progetti filtra `se_disciplina = 1` (NON `IS NOT NULL`):
-- se_disciplina e' un tinyint 0/1/NULL, quindi `IS NOT NULL` non filtra le sole
-- discipline e fa risolvere il corso a una categoria "non disciplina" arbitraria.
-- id_disciplina_progetto / disciplina_progetto usano max() perche' il LEFT JOIN su
-- progetti_categorie produce comunque una riga per ogni categoria del progetto
-- (anche non-disciplina): max() scarta i NULL e tiene la sola foglia-disciplina.
CREATE OR REPLACE VIEW __report_iscrizioni_anagrafica__ AS
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

-- | FINE FILE
