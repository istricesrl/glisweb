-- 2026-11-24 — attivita_asset: AUTO_INCREMENT su id
--
-- Nel file base degli indici il blocco 030000001901 ( MODIFY `id` ... AUTO_INCREMENT di attivita_asset ) stava dopo
-- il 030000002000: mysqlPatchRead() applica solo i blocchi sopra il livello raggiunto, quindi su ogni database
-- costruito da zero il blocco si saltava in silenzio e attivita_asset.id restava senza AUTO_INCREMENT ( segnalato da
-- eurosnodi il 24/11/2026 ). Il blocco ora sta al suo posto, e il test staticoPatchCest::fileBaseInOrdineCrescente
-- impedisce che succeda di nuovo; questa patch porta la correzione ai database gia' costruiti.
--
-- Cosa fa: rimette AUTO_INCREMENT su `attivita_asset`.`id`.
--
-- Cosa NON fa: non tocca i dati.
--
-- IDEMPOTENTE.

-- | 202611242000

-- attivita_asset
ALTER TABLE `attivita_asset` MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

-- | FINE FILE
