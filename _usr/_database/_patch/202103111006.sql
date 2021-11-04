CREATE OR REPLACE VIEW `risorse_view` AS
    SELECT
    risorse.id, 
    risorse.codice, 
    risorse.id_testata, 
    risorse.id_tipologia,
    risorse.id_categoria,
    risorse.data_pubblicazione,
    testate.nome AS testata, 
    contenuti.id_lingua, 
    contenuti.title AS titolo,
    group_concat( DISTINCT coalesce(
	anagrafica.soprannome,
	anagrafica.denominazione,
	concat_ws(' ', coalesce(anagrafica.cognome, ''),
	coalesce(anagrafica.nome, '') ),
	''
    ) SEPARATOR ' | ' ) AS autori, 
    risorse.codice AS __label__
    FROM risorse
    LEFT JOIN risorse_anagrafica ON risorse_anagrafica.id_risorsa = risorse.id
    LEFT JOIN anagrafica ON anagrafica.id = risorse_anagrafica.id_anagrafica
    LEFT JOIN testate ON testate.id = risorse.id_testata
    LEFT JOIN contenuti ON contenuti.id_risorsa = risorse.id
    WHERE id_lingua = 1
    GROUP BY risorse.id
    ORDER BY __label__
;