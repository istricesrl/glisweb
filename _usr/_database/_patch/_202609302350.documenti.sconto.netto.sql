-- 2026-09-30 — lo sconto di riga dei documenti diventa netto
--
-- COSA SI VEDEVA. documenti_articoli.sconto_valore era uno sconto sul lordo: la maschera della riga e il checkout dei
-- corsi lo toglievano da importo_lordo_totale per avere importo_lordo_finale, e basta. La fattura elettronica e il PDF
-- partono da importo_netto_totale, per cui una riga scontata usciva a prezzo pieno, mentre il pagamento era scontato.
--
-- COSA FA. Da oggi sconto_valore e' lo sconto sull'imponibile dell'intera riga, e generaContenutiDocumento() lo toglie da
-- importo_netto_totale ( nella fattura elettronica diventa ScontoMaggiorazione ). Questa patch riporta al netto gli sconti
-- gia' registrati, dividendoli per ( 1 + aliquota del reparto della riga ); importo_lordo_finale non cambia.
--
-- IDEMPOTENTE. Si convertono solo le righe in cui lo sconto e' ancora lordo, cioe' quelle in cui importo_lordo_finale e'
-- importo_lordo_totale meno sconto_valore ( al centesimo ): dopo la conversione l'uguaglianza non vale piu', e una seconda
-- esecuzione non le tocca. Le righe scontate senza i due importi lordi non si possono riconoscere e restano come sono: la
-- procedura le conta in @documenti_sconto_note.

-- | 202609302350

-- la conversione, solo se documenti_articoli ha i due importi lordi: sui deploy che non hanno importo_lordo_finale ( p.es.
-- gimbe ) non c'e' niente da riconoscere. Le righe che non si possono riconoscere si contano in @documenti_sconto_note
CREATE OR REPLACE PROCEDURE `__patch_documenti_sconto_netto__`()
BEGIN

	IF EXISTS ( SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'documenti_articoli' AND COLUMN_NAME = 'importo_lordo_finale' )
	AND EXISTS ( SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'documenti_articoli' AND COLUMN_NAME = 'importo_lordo_totale' ) THEN

		UPDATE `documenti_articoli`
			INNER JOIN `reparti` ON `reparti`.`id` = `documenti_articoli`.`id_reparto`
			INNER JOIN `iva` ON `iva`.`id` = `reparti`.`id_iva`
			SET `documenti_articoli`.`sconto_valore` = round( `documenti_articoli`.`sconto_valore` / ( 1 + `iva`.`aliquota` / 100 ), 2 )
			WHERE `documenti_articoli`.`sconto_valore` > 0
			AND `iva`.`aliquota` > 0
			AND `documenti_articoli`.`importo_lordo_totale` IS NOT NULL
			AND `documenti_articoli`.`importo_lordo_finale` IS NOT NULL
			AND abs( `documenti_articoli`.`importo_lordo_totale` - `documenti_articoli`.`sconto_valore` - `documenti_articoli`.`importo_lordo_finale` ) < 0.01;

		-- righe scontate che la patch non ha potuto riconoscere: vanno guardate a mano
		SELECT concat( count(*), ' righe scontate senza importo_lordo_totale o importo_lordo_finale: lo sconto e\' rimasto com\'era, verificare se e\' lordo' )
			INTO @documenti_sconto_note
			FROM `documenti_articoli`
			WHERE `sconto_valore` > 0 AND ( `importo_lordo_totale` IS NULL OR `importo_lordo_finale` IS NULL );

	ELSE

		SET @documenti_sconto_note = 'documenti_articoli non ha importo_lordo_totale e importo_lordo_finale: niente da fare';

	END IF;

END;

-- | 202609302351

CALL `__patch_documenti_sconto_netto__`();

-- | 202609302352

DROP PROCEDURE IF EXISTS `__patch_documenti_sconto_netto__`;

-- | FINE FILE
