-- 2026-11-16 — carrelli: note_fatturazione entra nel canone
--
-- Schema canonico, punto 7b, caso C8, decisione di Fabio del 16/11/2026. La colonna viene da gimbe ( ecommerce EBHC,
-- form di back-office _4170 ) e chiude il blocco della fatturazione del carrello, come note_evasione ha la sua: la
-- nota di un blocco resta distinta dalle note generiche ( regola trasversale C7 ).
--
-- Cosa fa: aggiunge la colonna dove manca.
--
-- Cosa NON fa ( punti 11 e 12 ): su gimbe e polmasi la colonna c'e' gia' in un'altra posizione; il riordino e il
-- travaso dei metadati note_fatturazione di gimbe nella colonna restano al punto 12.
--
-- IDEMPOTENTE.

-- | 202611161800

-- carrelli
ALTER TABLE `carrelli`
	ADD COLUMN IF NOT EXISTS `note_fatturazione` text DEFAULT NULL AFTER `fatturazione_strategia`;

-- | FINE FILE
