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

-- | FINE FILE
