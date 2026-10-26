-- 2026-10-26 — escono progetti.timestamp_aggiornamento_report_corsi e todo.timestamp_aggiornamento_report_corsi
--
-- Decisione di Fabio del 26/10/2026: le due colonne sono fuori canone. Erano il rotore dei task di popolazione dei
-- report dei corsi di _0920.corsi, che dal commit 885722cd1 scelgono le righe confrontando i timestamp e lasciano al
-- ricalcolo notturno i valori che cambiano con la data. Le avevano solo i database di polmasi ( dev e prod ): i valori
-- sono salvati in var/20261026-timestamp-aggiornamento-report-corsi/ del wrapper di glisweb.
--
-- polmasi ha tolto la scrittura della colonna dal suo task custom il 26/10/2026 ( 70b7ae3, 195cb6f ). Sulla produzione di
-- polmasi la patch va applicata solo col deploy su stable di un framework che contiene 885722cd1: prima, il task
-- standard vecchio che gira li' usa ancora la colonna.
--
-- IDEMPOTENTE: DROP COLUMN IF EXISTS ( MariaDB 10.3 ).

-- | 202610261500

ALTER TABLE `progetti` DROP COLUMN IF EXISTS `timestamp_aggiornamento_report_corsi`;

-- | 202610261501

ALTER TABLE `todo` DROP COLUMN IF EXISTS `timestamp_aggiornamento_report_corsi`;

-- | FINE
