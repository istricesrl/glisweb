-- 2026-11-11 — zone_stati: gli stati di una zona, nella forma della relazione
--
-- Schema canonico, punto 6, riga 241, decisione di Fabio del 11/11/2026 ( opzione A ): zone_stati dice quali stati fanno
-- parte di una zona ( spedizioni all'estero, listini per paese ), uno per ambito, ed e' una relazione di zone.
--
-- Cosa fa: toglie la KEY id_zona ( coperta dalla UNIQUE unica, che comincia con la stessa colonna e serve anche alla FK ),
-- rifa' la KEY indice nell'ordine delle colonne, ricrea la vista col nome dello stato e il percorso della zona.
--
-- Cosa NON fa: non tocca i dati ( la tabella e' vuota su tutti i DB letti l'11/11 ) ne' le FK.
--
-- IDEMPOTENTE.

-- | 202611111600

-- zone_stati: via la KEY doppia, indice nell'ordine delle colonne
ALTER TABLE `zone_stati`
	DROP INDEX IF EXISTS `id_zona`,
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `indice` (`id`,`ordine`, `id_zona`,`id_stato`);

-- | 202611111601

-- zone_stati_view
CREATE OR REPLACE VIEW zone_stati_view AS
	SELECT
		zone_stati.id,
		zone_stati.ordine,
		zone_stati.id_zona,
		zone_path( zone_stati.id_zona ) AS zona,
		zone_stati.id_stato,
		stati.nome AS stato,
		zone_stati.id_account_inserimento,
		zone_stati.id_account_aggiornamento,
		concat( stati.nome, ' - ', zone_path( zone_stati.id_zona ) ) AS __label__
	FROM zone_stati
		LEFT JOIN stati ON stati.id = zone_stati.id_stato
;

-- | FINE
