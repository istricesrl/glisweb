-- 2026-09-30 — il limite di tentativi nelle code di mail e SMS, nell'etichetta delle viste
--
-- Contesto: da oggi i task di invio ( _src/_api/_task/_mail.queue.send.php, _sms.queue.send.php e le loro copie
-- nei moduli MA000.mail e SM000.sms ) non riprovano piu' una mail o un SMS che ha fallito
-- $cf['mail']['tentativi_massimi'] ( o $cf['sms']['tentativi_massimi'] ) volte, default 10: la riga resta in coda
-- con il token dedicato TROPPI_TENTATIVI, come quelle bloccate con COPIA_FALLITA, e la fa ripartire solo l'invio
-- forzato dalla scheda. Perche' si riconosca nella scheda ( il titolo e' la __label__ della vista ) e nelle tendine,
-- l'etichetta di mail_out_view e di sms_out_view dice che la riga e' ferma e dopo quanti tentativi.
--
-- COSA FA. Rifa' mail_out_view e sms_out_view con CREATE OR REPLACE, identiche a quelle dei file di base
-- ( _090000999999.views.sql, aggiornato nello stesso giro ) e a quella di _202609291000.sms.sql tranne che per la
-- __label__. Le tabelle non cambiano: token e tentativi ci sono gia'.
--
-- GUARDIE. Le viste si rifanno dentro una procedura, come in _202609300900.colonne.tabelle.viste.sql: se su un
-- deploy la vista non si puo' creare perche' alla tabella manca una colonna, resta quella che c'era e il motivo
-- finisce in @code_tentativi_note, che il blocco dopo l'ultima vista restituisce a chi applica la patch a mano.
--
-- IDEMPOTENTE.

-- | 202609302100

-- la procedura che prova un'istruzione e, se fallisce, lo annota invece di fermare il task
CREATE OR REPLACE PROCEDURE `__patch_code_tentativi__`( IN istruzione LONGTEXT, IN oggetto VARCHAR(64) )
BEGIN

    DECLARE messaggio TEXT DEFAULT NULL;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1 messaggio = MESSAGE_TEXT;
        END;

    SET @code_tentativi_sql = istruzione;
    PREPARE prova FROM @code_tentativi_sql;
    IF messaggio IS NULL THEN
        EXECUTE prova;
        DEALLOCATE PREPARE prova;
    END IF;

    IF messaggio IS NOT NULL THEN
        SET @code_tentativi_note = CONCAT_WS( '\n', @code_tentativi_note, CONCAT( oggetto, ': ', messaggio ) );
    END IF;

END;

-- | 202609302101

-- mail_out_view
CALL `__patch_code_tentativi__`( '
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
		from_unixtime( mail_out.timestamp_invio, ''%Y-%m-%d'' ) AS data_ora_invio,
		mail_out.id_account_inserimento,
		mail_out.id_account_aggiornamento,
		concat(
			mail_out.id,
			'' / '',
			mail_out.oggetto,
			if( mail_out.token = ''TROPPI_TENTATIVI'', concat( '' ( ferma dopo '', mail_out.tentativi, '' tentativi )'' ), '''' )
		) AS __label__
	FROM mail_out
', 'mail_out_view' );

-- | 202609302102

-- sms_out_view
CALL `__patch_code_tentativi__`( '
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
		from_unixtime( sms_out.timestamp_invio, ''%Y-%m-%d'' ) AS data_ora_invio,
		sms_out.id_account_inserimento,
		sms_out.id_account_aggiornamento,
		concat(
			sms_out.id,
			'' / '',
			sms_out.corpo,
			if( sms_out.token = ''TROPPI_TENTATIVI'', concat( '' ( fermo dopo '', sms_out.tentativi, '' tentativi )'' ), '''' )
		) AS __label__
	FROM sms_out
', 'sms_out_view' );

-- | 202609302103

-- quello che non si e' potuto fare, e perche': lo legge chi applica la patch a mano
SELECT @code_tentativi_note AS nota;

-- | 202609302104

-- si libera la procedura
DROP PROCEDURE IF EXISTS `__patch_code_tentativi__`;

-- | FINE FILE
