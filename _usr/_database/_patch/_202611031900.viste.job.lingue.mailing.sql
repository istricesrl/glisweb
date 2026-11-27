-- 2026-11-03 — job_view, lingue_view e mailing_view al canone
--
-- Ordine di WEB03 del 03/11/2026, via Fabio. I blocchi delle viste nel file base _090000999999.views.sql stanno sotto
-- il livello di patch dei database esistenti, quindi le viste vive sono rimaste a versioni vecchie: mancano proiezione e
-- velocita di job_view ( crmeurosnodi ), note di lingue_view, note e data_ora_invio di mailing_view.
--
-- Sono le sole tre viste, sulle 37 esaminate il 03/11, che passano il criterio della definizione intera: su ogni
-- database dei deploy che seguono develop, dev e stable, la VIEW_DEFINITION viva differisce dal canone SOLO per colonne
-- mancanti, con espressioni comuni e FROM identici, il SELECT del canone gira, e nessun progetto le ridefinisce in
-- usr/database/ ( definizioni.py in var/20261103-viste-ritardo/ di glisweb, piu' la verifica dei soldati sui database
-- che glisweb non raggiunge ). Le altre 34, e le patch 202611031500-1800 ritirate quel giorno, restano in analisi.
-- Il consumatore di lingue_view in gimbe ( src/config/420.pages.php ) legge id e ietf, che restano.
--
-- Un blocco per vista, con la definizione del file base copiata com'e'.
--
-- IDEMPOTENTE: CREATE OR REPLACE VIEW.

-- | 202611031900

-- job_view
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

-- | 202611031901

-- lingue_view
CREATE OR REPLACE VIEW lingue_view AS                         --
  SELECT                                                      --
    lingue.id,                                                --
    lingue.nome,                                              --
    lingue.note,                                              --
    lingue.iso6391alpha2,                                     --
    lingue.iso6393alpha3,                                     --
    lingue.ietf,                                              --
    lingue.nome AS __label__                                  -- etichetta per le tendine e le liste
  FROM lingue                                                 --
  ;

-- | 202611031902

-- mailing_view
CREATE OR REPLACE VIEW `mailing_view` AS
	SELECT
		mailing.id,
		mailing.nome,
		mailing.note,
		mailing.timestamp_invio,
		from_unixtime( mailing.timestamp_invio, '%Y-%m-%d %H:%i' ) AS data_ora_invio,
		mailing.id_account_inserimento,
		mailing.id_account_aggiornamento,
		mailing.nome AS __label__
	FROM mailing
;

-- | FINE
