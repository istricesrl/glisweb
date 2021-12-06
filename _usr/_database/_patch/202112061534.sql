CREATE OR REPLACE VIEW cartellini_view AS

    SELECT

    cartellini.*,

    tipologie_attivita_inps.nome as tipologia_inps,

    coalesce(

	anagrafica.soprannome,

	anagrafica.denominazione,

	concat_ws(' ', coalesce(anagrafica.nome, ''),

	coalesce(anagrafica.cognome, '') ),

	''

    ) AS anagrafica,

    concat_ws(

	' - ',

	coalesce(

	    anagrafica.soprannome,

	    anagrafica.denominazione,

	    concat_ws(' ', coalesce(anagrafica.nome, ''),

	    coalesce(anagrafica.cognome, '') ),

	    ''

	),

	cartellini.data_attivita,

	tipologie_attivita_inps.nome

    ) AS __label__

    FROM cartellini

    LEFT JOIN anagrafica ON anagrafica.id = cartellini.id_anagrafica

    LEFT JOIN tipologie_attivita_inps ON tipologie_attivita_inps.id = cartellini.id_tipologia_inps

    ORDER BY __label__

;