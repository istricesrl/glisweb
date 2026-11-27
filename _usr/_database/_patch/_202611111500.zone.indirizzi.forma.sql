-- 2026-11-11 — zone_indirizzi: le zone di un indirizzo, nella forma della relazione
--
-- Schema canonico, punto 6, riga 240, decisione di Fabio del 11/11/2026 ( opzione A ): zone_indirizzi dice a quali zone
-- appartiene un indirizzo ( attribuzione dei clienti agli agenti, spedizioni ), una per ambito, ed e' una relazione di zone.
--
-- Cosa fa: toglie la KEY id_zona ( coperta dalla UNIQUE unica, che comincia con la stessa colonna e serve anche alla FK ),
-- ricrea la vista con l'indirizzo per esteso e il percorso della zona.
--
-- Cosa NON fa: non tocca i dati ( la tabella e' vuota su tutti i DB letti l'11/11 ) ne' le FK.
--
-- IDEMPOTENTE.

-- | 202611111500

-- zone_indirizzi: via la KEY doppia
ALTER TABLE `zone_indirizzi`
	DROP INDEX IF EXISTS `id_zona`;

-- | 202611111501

-- zone_indirizzi_view
CREATE OR REPLACE VIEW zone_indirizzi_view AS
	SELECT
		zone_indirizzi.id,
		zone_indirizzi.ordine,
		zone_indirizzi.id_zona,
		zone_path( zone_indirizzi.id_zona ) AS zona,
		zone_indirizzi.id_indirizzo,
		concat_ws(
			' ',
			tipologie_indirizzi.nome,
			indirizzi.indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) AS indirizzo,
		zone_indirizzi.id_account_inserimento,
		zone_indirizzi.id_account_aggiornamento,
		concat_ws(
			' - ',
			concat_ws(
				' ',
				tipologie_indirizzi.nome,
				indirizzi.indirizzo,
				indirizzi.civico,
				indirizzi.cap,
				indirizzi.localita,
				comuni.nome,
				provincie.sigla
			),
			zone_path( zone_indirizzi.id_zona )
		) AS __label__
	FROM zone_indirizzi
		LEFT JOIN indirizzi ON indirizzi.id = zone_indirizzi.id_indirizzo
		LEFT JOIN tipologie_indirizzi ON tipologie_indirizzi.id = indirizzi.id_tipologia
		LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
;

-- | FINE
