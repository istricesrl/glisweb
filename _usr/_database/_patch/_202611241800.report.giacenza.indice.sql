-- 2026-11-24 — report di giacenza dei magazzini: indice composto su articolo, mastro e matricola
--
-- Le letture di __report_giacenza_magazzini__ filtrano per articolo e mastro, e per matricola dove c'è: con i soli
-- indici semplici MariaDB ne sceglie uno e scorre il resto. Su bernispa l'indice composto, creato a mano su DEV, ha
-- portato la query da 56 a 14 ms ( bernispa, voce 46 ).
--
-- Cosa fa: aggiunge `indice_articolo_mastro` ( `id_articolo`, `id_mastro`, `id_matricola` ), lo stesso del CREATE di
-- _100000999999.reports.sql; dove c'è già, creato a mano con lo stesso nome, non fa niente.
--
-- IDEMPOTENTE.

-- | 202611241800

-- __report_giacenza_magazzini__
ALTER TABLE `__report_giacenza_magazzini__`
	ADD KEY IF NOT EXISTS `indice_articolo_mastro` (`id_articolo`,`id_mastro`,`id_matricola`);

-- | FINE FILE
