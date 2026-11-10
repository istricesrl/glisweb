-- 2026-11-10 — todo: indici composti nella forma del canone
--
-- Schema canonico, punto 6, riga 228, decisione di Fabio del 10/11/2026 ( opzione B ): todo prende la forma di
-- attivita. Gli indici composti seguono i blocchi della tabella come in attivita: indice ( testa e chiusura ),
-- indice_scadenza, indice_programmazione ( con anno e settimana, per il backlog e gli sprint ) e indice_archiviazione;
-- indice_pianificazione, che esisteva solo qui, esce.
--
-- Cosa fa: toglie e ricrea i quattro composti. Le KEY sulle singole colonne non cambiano. La vista todo_view sta nel
-- file base.
--
-- Cosa NON fa: non toglie note_pianificazione, che esce dal canone ma si toglie al punto 12 dello schema canonico
-- ( nessuna rimozione prima che l'analisi sia chiusa ), e non rinumera le chiavi esterne: sui deploy la numerazione
-- _ibfk_NN e' cambiata spesso, i vincoli si riallineano per colonna e tabella riferita al punto 12.
--
-- IDEMPOTENTE.

-- | 202611101400

-- todo: indici composti
ALTER TABLE `todo`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `indice_scadenza`,
	DROP INDEX IF EXISTS `indice_programmazione`,
	DROP INDEX IF EXISTS `indice_pianificazione`,
	DROP INDEX IF EXISTS `indice_archiviazione`,
	ADD KEY `indice` (`id`,`id_tipologia`,`id_anagrafica`,`id_cliente`,`id_contatto`,`id_luogo`,`id_progetto`,`id_pianificazione`,`data_chiusura`),
	ADD KEY `indice_scadenza` (`id`,`id_tipologia`,`id_anagrafica`,`id_cliente`,`id_progetto`,`data_scadenza`,`ora_scadenza`),
	ADD KEY `indice_programmazione` (`id`,`id_tipologia`,`id_anagrafica`,`id_cliente`,`id_luogo`,`id_progetto`,`data_programmazione`,`ora_inizio_programmazione`,`ora_fine_programmazione`,`anno_programmazione`,`settimana_programmazione`),
	ADD KEY `indice_archiviazione` (`id`,`id_tipologia`,`id_anagrafica`,`id_cliente`,`id_progetto`,`data_archiviazione`);

-- | FINE
