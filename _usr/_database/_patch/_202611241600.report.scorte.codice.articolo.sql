-- 2026-11-24 — report delle scorte: il codice dell'articolo accanto all'id
--
-- Il framework lavora con gli id, ma all'operatore va mostrato il codice: l'id di un articolo non coincide col suo
-- codice e non dice niente a chi lo legge. Il task _mod/_0500.mastri/_src/_api/_task/_rifornimenti.da.sottoscorta.php
-- scrive ora anche articoli.codice nei due report, e la vista del sottoscorta, le etichette e la mail lo espongono al
-- posto dell'id.
--
-- Cosa fa: aggiunge `codice_articolo` ( char(32), come articoli.codice ) con il suo indice a __report_sottoscorta__ e a
-- __report_scorte_non_valutabili__.
--
-- Cosa NON fa: non popola le righe esistenti; il task riscrive i due report a ogni giro, quindi il codice compare dal
-- giro successivo.
--
-- IDEMPOTENTE.

-- | 202611241600

-- __report_sottoscorta__
ALTER TABLE `__report_sottoscorta__`
	ADD COLUMN IF NOT EXISTS `codice_articolo` char(32) DEFAULT NULL AFTER `id_articolo`,
	ADD KEY IF NOT EXISTS `codice_articolo` (`codice_articolo`);

-- | 202611241601

-- __report_scorte_non_valutabili__
ALTER TABLE `__report_scorte_non_valutabili__`
	ADD COLUMN IF NOT EXISTS `codice_articolo` char(32) DEFAULT NULL AFTER `id_articolo`,
	ADD KEY IF NOT EXISTS `codice_articolo` (`codice_articolo`);

-- | FINE FILE
