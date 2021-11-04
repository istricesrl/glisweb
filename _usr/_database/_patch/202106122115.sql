CREATE OR REPLACE VIEW `contratti_completa_view` AS
SELECT contratti.*,
	coalesce(
		anagrafica.soprannome,
		anagrafica.denominazione,
		concat_ws(' ', coalesce(anagrafica.cognome, ''),
		coalesce(anagrafica.nome, '') ),
		''
	) AS anagrafica,
	coalesce(
		agenzie.soprannome,
		agenzie.denominazione,
		concat_ws(' ', coalesce(agenzie.cognome, ''),
		coalesce(agenzie.nome, '') ),
		''
	) AS agenzia,
	tipologie_contratti.nome as tipologia,
	tipologie_qualifiche_inps.nome as tipologia_qualifica,
	tipologie_durate_inps.nome as tipologia_durata,
	tipologie_orari_inps.nome as tipologia_orario,
	count( attivita.id ) as proroghe,
	concat(
		contratti.id, ' ',
		tipologie_contratti.nome, 
		' ', 
		coalesce(
			anagrafica.soprannome,
			anagrafica.denominazione,
			concat_ws(' ', coalesce(anagrafica.cognome, ''),coalesce(anagrafica.nome, '') ),
			''
		)
	) as __label__
FROM contratti 
LEFT JOIN anagrafica ON contratti.id_anagrafica = anagrafica.id
LEFT JOIN anagrafica as agenzie ON contratti.id_agenzia = agenzie.id
LEFT JOIN tipologie_contratti ON contratti.id_tipologia = tipologie_contratti.id
LEFT JOIN tipologie_qualifiche_inps ON contratti.id_tipologia_qualifica = tipologie_qualifiche_inps.id
LEFT JOIN tipologie_durate_inps ON contratti.id_tipologia_durata = tipologie_durate_inps.id
LEFT JOIN tipologie_orari_inps ON contratti.id_tipologia_orario = tipologie_orari_inps.id
LEFT JOIN attivita ON attivita.id_contratto = contratti.id
GROUP BY contratti.id
ORDER BY contratti.data_inizio DESC, __label__
;
