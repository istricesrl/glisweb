CREATE OR REPLACE VIEW `pratiche_all_view` AS
    SELECT
    pratiche.*,
    if(pratiche.se_importata = 1, 1, 0) AS importata,
    if(pratiche.data_chiusura, 1, 0) AS se_chiusa,
    pratiche_avvocati.id_anagrafica AS id_responsabile,
    avvocati.id_anagrafica AS id_volontario,
    group_concat( DISTINCT     coalesce(
	volontari.soprannome,
	volontari.denominazione,
	concat_ws(' ', coalesce(volontari.cognome, ''),
	coalesce(volontari.nome, '') ),
	''	) SEPARATOR ' | ' ) AS lista_volontari,
    group_concat( DISTINCT     coalesce(
	assistiti.soprannome,
	assistiti.denominazione,
	concat_ws(' ', coalesce(assistiti.cognome, ''),
	coalesce(assistiti.nome, '') ),
	''	) SEPARATOR ' | ' ) AS lista_assistiti,
    coalesce(
	anagrafica.soprannome,
	anagrafica.denominazione,
	concat_ws(' ', coalesce(anagrafica.cognome, ''),
	coalesce(anagrafica.nome, '') ),
	''
    ) AS responsabile,    
    concat(coalesce(sede.nome, sede.denominazione),'/',pratiche.numero,'/', YEAR(pratiche.data_apertura)) AS __short_label__,
    categorie_diritto_view.__label__ AS diritto,
    tipologie_pratiche_view.__label__ AS tipologia,
    esiti_pratiche.nome AS esito,
    concat('pratica n° ',pratiche.numero,' aperta in sede ', coalesce(
	

	sede.denominazione,
	concat_ws(' ', coalesce(sede.cognome, ''),
	coalesce(sede.nome, '') ),
	''
    )) AS __label__
    FROM pratiche
    LEFT JOIN pratiche_avvocati ON pratiche_avvocati.id_pratica = pratiche.id AND pratiche_avvocati.se_responsabile = 1
    LEFT JOIN pratiche_assistiti ON pratiche_assistiti.id_pratica = pratiche.id 
    LEFT JOIN pratiche_avvocati AS avvocati ON avvocati.id_pratica = pratiche.id
    LEFT JOIN anagrafica ON anagrafica.id = pratiche_avvocati.id_anagrafica
    LEFT JOIN anagrafica AS sede ON sede.id = pratiche.id_sede_apertura
    LEFT JOIN anagrafica AS assistiti ON assistiti.id = pratiche_assistiti.id_anagrafica
    LEFT JOIN anagrafica AS volontari ON volontari.id = avvocati.id_anagrafica
    LEFT JOIN categorie_diritto_view ON categorie_diritto_view.id = pratiche.id_categoria_diritto
    LEFT JOIN tipologie_pratiche_view ON tipologie_pratiche_view.id = pratiche.id_tipologia
    LEFT JOIN esiti_pratiche ON esiti_pratiche.id = pratiche.id_esito
    GROUP BY pratiche.id
    ORDER BY Year(data_apertura) DESC,LENGTH(numero), numero
;
