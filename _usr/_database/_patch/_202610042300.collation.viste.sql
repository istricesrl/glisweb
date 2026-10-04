-- 2026-10-04 — viste e __patch__ in utf8_general_ci
--
-- Decisione di Fabio del 04/10/2026: il canone e' tutto utf8_general_ci, anche le colonne delle viste. Una vista prende
-- charset e collation della sessione che la crea per le colonne fatte solo di letterali, numeri o funzioni su date
-- ( i __label__ con concat_ws, i group_concat di id, le date formattate ): il framework si connette in utf8mb4
-- ( _src/_config/_125.mysql.php ), quindi le viste create dal task delle patch avevano quelle colonne in
-- utf8mb4_general_ci. Il censimento del 04/10/2026 sui deploy di web03 ne ha trovate 51, 17 delle quali in viste del
-- canone: sono le viste che questa patch ricrea, copiate da _090000999999.views.sql e _100000999999.reports.sql.
--
-- Da questa patch mysqlPatchApply() esegue le patch con SET NAMES utf8 COLLATE utf8_general_ci e poi rimette la
-- connessione com'era, quindi le viste future nascono gia' nel canone; il primo blocco lo fa anche qui, per gli
-- applicatori che non lo fanno ancora. coupon_view.id_aree era latin1_swedish_ci anche cosi' ( group_concat di soli
-- numeri, senza letterali ): nel canone adesso ha un convert() esplicito.
--
-- __patch__.patch era utf8_unicode_ci: la creavano cosi' mysqlPatchApply() e patch-db.py, ora utf8_general_ci.
--
-- IDEMPOTENTE.

-- | 202610042300

SET NAMES utf8 COLLATE utf8_general_ci;

-- | 202610042301

ALTER TABLE `__patch__` CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;

-- | 202610042302

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

-- | 202610042303

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

-- | 202610042304

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

-- | 202610042305

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

-- | 202610042306

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

-- | 202610042307

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

-- | 202610042308

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

-- | 202610042309

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

-- | 202610042310

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

-- | 202610042311

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

-- | 202610042312

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

-- | 202610042313

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

-- | 202610042314

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

-- | 202610042315

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

-- | 202610042316

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

-- | 202610042317

-- __report_utilizzi_coupon__
-- ripristinato il 2026-09-30 dalla versione di prima del 02/03/2026: gli utilizzi di un coupon nei carrelli e nei
-- pagamenti, letto dalla scheda utilizzi e dal rimborso del modulo 4140.coupon
CREATE OR REPLACE VIEW `__report_utilizzi_coupon__` AS
    SELECT
        coupon.id,
        'carrelli' AS tipo,
        concat ( 'carrello #', carrelli.id ) AS riferimento,
        from_unixtime( carrelli.timestamp_pagamento, "%Y-%m-%d" ) AS data_pagamento,
        carrelli_articoli.id AS id_carrelli_articoli,
        NULL AS id_pagamento,
        coalesce( carrelli_articoli.prezzo_lordo_totale, 0 ) AS importo_lordo_totale,
        coalesce( carrelli_articoli.coupon_valore, 0 ) AS coupon_valore,
        coalesce( carrelli_articoli.prezzo_lordo_finale, 0 ) AS importo_lordo_finale
    FROM coupon
        INNER JOIN carrelli_articoli ON carrelli_articoli.id_coupon = coupon.id
        INNER JOIN carrelli ON carrelli.id = carrelli_articoli.id_carrello

    UNION

    SELECT
        coupon.id,
        'pagamenti' AS tipo,
        concat ( 'documento n. ', documenti.numero, '/', documenti.sezionale, ' del ', documenti.data ) AS riferimento,
        from_unixtime( pagamenti.timestamp_pagamento, "%Y-%m-%d" ) AS data_pagamento,
        NULL AS id_carrelli_articoli,
        pagamenti.id AS id_pagamento,
        coalesce( pagamenti.importo_lordo_totale, 0 ) AS importo_lordo_totale,
        coalesce( pagamenti.coupon_valore, 0 ) AS coupon_valore,
        coalesce( pagamenti.importo_lordo_finale, 0 ) AS importo_lordo_finale
    FROM coupon
        INNER JOIN pagamenti ON pagamenti.id_coupon = coupon.id
        INNER JOIN documenti ON documenti.id = pagamenti.id_documento
;

-- | FINE
