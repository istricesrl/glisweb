-- 2026-11-05 — task: archiviazione per spegnere un task, indici del motore comune
--
-- Schema canonico, punto 6, riga 187, decisione di Fabio del 05/11/2026 ( opzione B ): un task si spegne archiviandolo
-- e non cancellandolo, perche' le righe standard del file di dati, cancellate, tornerebbero col giro successivo. Oggi
-- l'unico modo e' un orario irraggiungibile ( bernispa spegne le righe 1-3 con minuto = 99 ). Le KEY su iterazioni e
-- delay escono come in job: sono parametri della passata, non filtri.
--
-- Cosa fa: aggiunge data_archiviazione e note_archiviazione dopo task, toglie le KEY iterazioni e delay, aggiunge la
-- KEY data_archiviazione e ricrea indice. La vista task_view sta nel file base.
--
-- Cosa NON fa: non tocca i dati ( il passaggio di bernispa da minuto = 99 all'archiviazione si fa al punto 12 dello
-- schema canonico, insieme a _cron.php che salta i task archiviati: finche' il cron non le legge, le due colonne non
-- spengono niente ).
--
-- IDEMPOTENTE.

-- | 202611051030

-- task: colonne di archiviazione
ALTER TABLE `task`
	ADD COLUMN IF NOT EXISTS `data_archiviazione` date DEFAULT NULL AFTER `task`,
	ADD COLUMN IF NOT EXISTS `note_archiviazione` text DEFAULT NULL AFTER `data_archiviazione`;

-- | 202611051031

-- task: indici nella forma del canone
ALTER TABLE `task`
	DROP INDEX IF EXISTS `iterazioni`,
	DROP INDEX IF EXISTS `delay`,
	DROP INDEX IF EXISTS `data_archiviazione`,
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `data_archiviazione` (`data_archiviazione`),
	ADD KEY `indice` (`id`,`minuto`,`ora`,`giorno_del_mese`,`mese`,`giorno_della_settimana`,`settimana`,`task`,`data_archiviazione`,`token`,`timestamp_esecuzione`);

-- | FINE
