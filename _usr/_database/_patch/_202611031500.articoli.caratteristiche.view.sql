-- 2026-11-03 — articoli_caratteristiche_view al canone su tutti i deploy
--
-- Ordine di WEB03 del 03/11/2026, via Fabio. Il blocco della vista nel file base _090000999999.views.sql sta
-- sotto il livello di patch dei database esistenti, quindi la vista viva e' rimasta quella vecchia ( id,
-- id_articolo, id_caratteristica, ordine, valore, se_assente, __label__ ), senza il nome della caratteristica: su
-- utensilerialughese il 03/11 la stampa dei cartellini grandi e' morta con 1054 Unknown column 'caratteristica'.
-- Verificato il 03/11 sui database raggiungibili da web03: la vista vecchia sta su glisweb, glisdev, bernispa,
-- crmeurosnodi, crmtrb, crmfia, gimbe e polmasi ( DEV e PROD ), quella al canone su csicasalecchio e
-- utensilerialughese ( patch di progetto 202611031300 ); le colonne lette ci sono in tutte le tabelle vive, e
-- nessuna vista viva ha colonne che qui non ci sono, quindi non si perde niente.
--
-- 202611031500: rifa' la vista come nel file base.
--
-- IDEMPOTENTE: CREATE OR REPLACE VIEW; dove la patch di progetto 202611031300 c'e' gia' stata non cambia niente.

-- | 202611031500

CREATE OR REPLACE VIEW `articoli_caratteristiche_view` AS
	SELECT
		articoli_caratteristiche.id,
		articoli_caratteristiche.ordine,
		articoli_caratteristiche.id_articolo,
		articoli_caratteristiche.id_caratteristica,
		articoli_caratteristiche.id_lingua,
		caratteristiche.nome AS caratteristica,
		articoli_caratteristiche.valore,
		articoli_caratteristiche.note,
		articoli_caratteristiche.se_assente,
		articoli_caratteristiche.id_account_inserimento,
		articoli_caratteristiche.id_account_aggiornamento,
		concat(
			articoli_caratteristiche.id_articolo,
			' / ',
			caratteristiche.nome
		) AS __label__
	FROM articoli_caratteristiche
		LEFT JOIN caratteristiche ON caratteristiche.id = articoli_caratteristiche.id_caratteristica
;

-- | FINE
