-- 2026-11-11 — zone_cap: i CAP di una zona, nella forma della secondaria
--
-- Schema canonico, punto 6, riga 239, decisione di Fabio del 11/11/2026 ( opzione A ): zone_cap dice quali CAP fanno
-- parte di una zona ( attribuzione dei clienti agli agenti, spedizioni ), ed e' una secondaria di zone.
--
-- Cosa fa: allarga cap a char(11) come indirizzi.cap, toglie la KEY id_zona ( coperta dalla UNIQUE unica, che comincia
-- con la stessa colonna e serve anche alla FK ), ricrea la vista col percorso della zona.
--
-- Cosa NON fa: non tocca i dati ( la tabella e' vuota su tutti i DB letti l'11/11 ) ne' le FK.
--
-- IDEMPOTENTE.

-- | 202611111400

-- zone_cap: CAP largo quanto quello degli indirizzi, via la KEY doppia
ALTER TABLE `zone_cap`
	MODIFY `cap` char(11) DEFAULT NULL,
	DROP INDEX IF EXISTS `id_zona`;

-- | 202611111401

-- zone_cap_view
CREATE OR REPLACE VIEW zone_cap_view AS
	SELECT
		zone_cap.id,
		zone_cap.ordine,
		zone_cap.id_zona,
		zone_path( zone_cap.id_zona ) AS zona,
		zone_cap.cap,
		zone_cap.id_account_inserimento,
		zone_cap.id_account_aggiornamento,
		concat( zone_cap.cap, ' - ', zone_path( zone_cap.id_zona ) ) AS __label__
	FROM zone_cap
;
