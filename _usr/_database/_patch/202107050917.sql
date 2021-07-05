CREATE OR REPLACE VIEW `fasce_orarie_contratti_view` AS
	SELECT
	fasce_orarie_contratti.*,
	tipologie_attivita_inps.nome as tipologia_inps,
	concat_ws(
		' - ',
		concat( 'turno ', turno ),
		concat( 'giorno ', id_giorno ),
		ora_inizio,
		ora_fine,
		tipologie_attivita_inps.nome 
	) AS __label__
	FROM fasce_orarie_contratti
	LEFT JOIN contratti ON contratti.id = fasce_orarie_contratti.id_contratto
	LEFT JOIN tipologie_attivita_inps ON tipologie_attivita_inps.id = fasce_orarie_contratti.id_tipologia_inps
	ORDER BY __label__
;
