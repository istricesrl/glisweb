-- 2026-11-11 — rinnovi: la forma canonica, la parte che non tocca dati ne' FK
--
-- Schema canonico, punto 6, riga 244, decisione di Fabio del 11/11/2026 ( opzione B, con se_automatico che resta: e' il
-- tacito rinnovo pattuito nel contratto ): rinnovi perde id_tipologia_contratto, mai scritta in nessun albero.
--
-- Cosa fa: toglie unica_contratto e unica_progetto ( contenevano codice, gia' UNIQUE da solo, e non proteggevano niente ),
-- rifa' la KEY indice, ricrea la vista con tutte le colonne e un __label__ senza il ruolo 29 cablato.
--
-- Cosa NON fa ( punto 12 ): il riordino delle colonne, il DROP di id_tipologia_contratto con rinnovi_ibfk_04_nofollow e la
-- sua KEY, il DROP / ADD delle FK rinumerate ( contratto, progetto e licenza a CASCADE ), le colonne fuori canone di polmasi.
--
-- IDEMPOTENTE.

-- | 202611111900

-- rinnovi: indici
ALTER TABLE `rinnovi`
	DROP INDEX IF EXISTS `unica_contratto`,
	DROP INDEX IF EXISTS `unica_progetto`,
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `indice` (`id`,`id_tipologia`,`codice`,`id_progetto`,`id_contratto`,`id_categoria_progetti`,`id_licenza`,`data_inizio`,`data_fine`,`se_automatico`);

-- | 202611111901

-- rinnovi_view
-- tipologia: tabella gestita
-- verifica: 2026-11-11 punto 6, riga 244
CREATE OR REPLACE VIEW `rinnovi_view` AS
	SELECT
		rinnovi.id,
		rinnovi.id_tipologia,
		tipologie_rinnovi.nome AS tipologia,
		rinnovi.codice,
		rinnovi.id_periodicita,
		periodicita.nome AS periodicita,
		rinnovi.id_progetto,
		progetti.nome AS progetto,
		rinnovi.id_contratto,
		contratti.nome AS contratto,
		rinnovi.id_pianificazione,
		rinnovi.id_categoria_progetti,
		categorie_progetti_path( rinnovi.id_categoria_progetti ) AS categoria_progetti,
		rinnovi.id_licenza,
		licenze.nome AS licenza,
		licenze.codice AS codice_licenza,
		rinnovi.data_inizio,
		rinnovi.data_fine,
		rinnovi.note,
		rinnovi.se_automatico,
		rinnovi.id_account_inserimento,
		rinnovi.id_account_aggiornamento,
		concat_ws(
			' ',
			'rinnovo',
			rinnovi.id,
			coalesce( contratti.nome, progetti.nome, licenze.nome ),
			'dal',
			rinnovi.data_inizio,
			'al',
			rinnovi.data_fine
		) AS __label__
	FROM rinnovi
		LEFT JOIN tipologie_rinnovi ON tipologie_rinnovi.id = rinnovi.id_tipologia
		LEFT JOIN periodicita ON periodicita.id = rinnovi.id_periodicita
		LEFT JOIN contratti ON contratti.id = rinnovi.id_contratto
		LEFT JOIN progetti ON progetti.id = coalesce( rinnovi.id_progetto, contratti.id_progetto )
		LEFT JOIN licenze ON licenze.id = rinnovi.id_licenza
;

-- | FINE
