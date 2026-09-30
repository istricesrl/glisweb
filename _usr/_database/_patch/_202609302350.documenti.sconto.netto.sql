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
-- SELECT finale le conta.

-- | 202609302350

UPDATE `documenti_articoli`
	INNER JOIN `reparti` ON `reparti`.`id` = `documenti_articoli`.`id_reparto`
	INNER JOIN `iva` ON `iva`.`id` = `reparti`.`id_iva`
	SET `documenti_articoli`.`sconto_valore` = round( `documenti_articoli`.`sconto_valore` / ( 1 + `iva`.`aliquota` / 100 ), 2 )
	WHERE `documenti_articoli`.`sconto_valore` > 0
	AND `iva`.`aliquota` > 0
	AND `documenti_articoli`.`importo_lordo_totale` IS NOT NULL
	AND `documenti_articoli`.`importo_lordo_finale` IS NOT NULL
	AND abs( `documenti_articoli`.`importo_lordo_totale` - `documenti_articoli`.`sconto_valore` - `documenti_articoli`.`importo_lordo_finale` ) < 0.01;

-- | 202609302351

-- righe scontate che la patch non ha potuto riconoscere: vanno guardate a mano
SELECT concat( count(*), ' righe scontate senza importo_lordo_totale o importo_lordo_finale: lo sconto e\' rimasto com\'era, verificare se e\' lordo' ) AS nota
	FROM `documenti_articoli`
	WHERE `sconto_valore` > 0 AND ( `importo_lordo_totale` IS NULL OR `importo_lordo_finale` IS NULL );

-- | FINE FILE
