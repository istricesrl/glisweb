--
-- PATCH
--

--| 202204190010
CREATE OR REPLACE VIEW `contratti_view` AS
	SELECT
		contratti.id,
		contratti.id_tipologia,
        tipologie_contratti.nome AS tipologia,
		contratti.id_emittente,
		coalesce(a1.soprannome,a1.denominazione, concat_ws(' ', coalesce(a1.cognome, ''),coalesce(a1.nome, '') ),'') AS emittente,
		contratti.id_destinatario,
		coalesce(a2.soprannome,a2.denominazione, concat_ws(' ', coalesce(a2.cognome, ''),coalesce(a2.nome, '') ),'') AS destinatario,
		contratti.id_progetto,
		progetti.nome AS progetto,
		contratti.nome,
		contratti.id_account_inserimento,
		contratti.id_account_aggiornamento,
		concat( contratti.nome , ' - ', tipologie_contratti.nome )AS __label__
	FROM contratti
        LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
        LEFT JOIN anagrafica AS a1 ON a1.id = contratti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = contratti.id_destinatario
        LEFT JOIN progetti ON progetti.id = contratti.id_progetto
;

-- FINE