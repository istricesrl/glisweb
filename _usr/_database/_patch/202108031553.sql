CREATE OR REPLACE VIEW contatti_view AS
    SELECT
	contatti.*,
	tipologie_contatti.nome AS tipologia,
	coalesce(
	anagrafica.soprannome,
	anagrafica.denominazione,
	concat_ws(' ', coalesce(anagrafica.cognome, ''),
	coalesce(anagrafica.nome, '') ),
	''
	) AS anagrafica,
	coalesce(
	segnalatore.soprannome,
	segnalatore.denominazione,
	concat_ws(' ', coalesce(segnalatore.cognome, ''),
	coalesce(segnalatore.nome, '') ),
	''
	) AS segnalatore,
	campagne.nome AS campagna,
	contatti.json AS __label__
    FROM contatti
    LEFT JOIN campagne ON campagne.id = contatti.id_campagna
    LEFT JOIN tipologie_contatti ON tipologie_contatti.id = contatti.id_tipologia
    LEFT JOIN anagrafica ON anagrafica.id = contatti.id_anagrafica
    LEFT JOIN anagrafica AS segnalatore ON segnalatore.id = contatti.id_segnalatore
    ORDER BY data_contatto DESC, ora_contatto DESC, __label__
;