-- 2026-10-01 — carrelli.costo_spedizione_netto e costo_spedizione_lordo: la spedizione calcolata sull'ordine
--
-- COSA SI VEDEVA. La spedizione si calcolava solo per articolo ( carrelli_articoli.costo_spedizione_* ), mentre molti
-- ecommerce la fanno pagare una volta per ordine. Con $cf['ecommerce']['spedizione'] = 'ordine' il controller del
-- carrello calcola il costo una volta sola, dalla modalita_spedizione della zona senza articolo, prodotto o categoria,
-- e lo scrive su carrelli: servono le due colonne.
--
-- COSA FA. Aggiunge le due colonne, vuote, dopo sconto_valore.
--
-- IDEMPOTENTE.

-- | 202610011840

ALTER TABLE `carrelli`
    ADD COLUMN IF NOT EXISTS `costo_spedizione_netto` decimal(16,5) DEFAULT NULL AFTER `sconto_valore`,
    ADD COLUMN IF NOT EXISTS `costo_spedizione_lordo` decimal(16,5) DEFAULT NULL AFTER `costo_spedizione_netto`;

-- | FINE FILE
