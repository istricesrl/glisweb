-- 2026-10-01 — colonne con il tipo sbagliato
--
-- COSA SI VEDEVA. anagrafica_certificazioni.nome e valutazioni_certificazioni.nome erano char(1): le maschere chiedono un
-- nome, e ne restava la prima lettera. modalita_spedizione.importo_netto era int(11), e il costo di spedizione perdeva i
-- decimali.
--
-- valute_view, che le maschere dei listini e delle modalita' di spedizione usano per la tendina della valuta, non era
-- dichiarata da nessuna parte: la tendina usciva vuota.
--
-- COSA FA. Porta i due nomi a char(255), come gli altri nomi, e importo_netto a decimal(16,2), come gli altri importi;
-- crea valute_view.
--
-- IDEMPOTENTE. Sono MODIFY verso il tipo finale e una CREATE OR REPLACE VIEW: alla seconda esecuzione non cambiano niente.

-- | 202610010010

ALTER TABLE `anagrafica_certificazioni` MODIFY `nome` char(255) DEFAULT NULL;

-- | 202610010011

ALTER TABLE `valutazioni_certificazioni` MODIFY `nome` char(255) DEFAULT NULL;

-- | 202610010012

ALTER TABLE `modalita_spedizione` MODIFY `importo_netto` decimal(16,2) DEFAULT NULL;

-- | 202610010013

CREATE OR REPLACE VIEW `valute_view` AS
	SELECT
		valute.id,
		valute.iso4217,
		valute.html_entity,
		valute.utf8,
		valute.iso4217 AS __label__
	FROM valute
;

-- | FINE FILE
