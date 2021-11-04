CREATE OR REPLACE VIEW turni_view AS
SELECT
turni.*,
CONCAT( 
	id_contratto, ' - ',
	tipologie_contratti.nome,
	' - ', 
	coalesce(
		collaboratori.soprannome,
		collaboratori.denominazione,
		concat_ws(' ', coalesce(collaboratori.cognome, ''),
		coalesce(collaboratori.nome, '') ),		''
	)
) as contratto,
CONCAT(
	'turno ' ,
	turni.turno, 
	' - ', 'contratto ', turni.id_contratto, ' - ', 
	COALESCE(
		collaboratori.soprannome,
		collaboratori.denominazione,
		concat_ws(' ', coalesce(collaboratori.cognome, ''),
		COALESCE(collaboratori.nome, '') )
	)
) AS __label__
FROM turni 
LEFT JOIN contratti ON turni.id_contratto = contratti.id
LEFT JOIN anagrafica AS collaboratori ON contratti.id_anagrafica = collaboratori.id
LEFT JOIN tipologie_contratti ON contratti.id_tipologia = tipologie_contratti.id
ORDER BY data_inizio DESC, __label__
;