CREATE OR REPLACE VIEW turni_view AS
SELECT
turni.*,
coalesce(
		anagrafica.soprannome,
		anagrafica.denominazione,
		concat_ws(' ', coalesce(anagrafica.cognome, ''),
		coalesce(anagrafica.nome, '') ),
		''
	) as anagrafica,
concat( 
	coalesce(
		anagrafica.soprannome,
		anagrafica.denominazione,
		concat_ws(' ', coalesce(anagrafica.cognome, ''),
		coalesce(anagrafica.nome, '') ),		''
	),
	' | ', 
	'turno ' ,
	turni.turno, 
	IF( turni.id_contratto IS NULL, '', CONCAT( ' | ', 'contratto ', turni.id_contratto ) )
) AS __label__
FROM turni 
INNER JOIN anagrafica ON turni.id_anagrafica = anagrafica.id
LEFT JOIN contratti ON turni.id_contratto = contratti.id
ORDER BY __label__	





