CREATE OR REPLACE VIEW anagrafica_view AS
    SELECT anagrafica.*,
    group_concat( DISTINCT pec.indirizzo ) AS pec_sdi,
    group_concat( DISTINCT indirizzi_view.sigla_stato ) AS sigla_stato,
    group_concat( DISTINCT stati.nome SEPARATOR ' | ' ) AS cittadinanze,
    max( categorie_anagrafica.se_collaboratore ) AS se_collaboratore,
    max( categorie_anagrafica.se_dipendente ) AS se_dipendente,
    max( categorie_anagrafica.se_interinale ) AS se_interinale,
    max( categorie_anagrafica.se_cliente ) AS se_cliente,
    max( categorie_anagrafica.se_lead ) AS se_lead,
    max( categorie_anagrafica.se_prospect ) AS se_prospect,
    max( categorie_anagrafica.se_mandante ) AS se_mandante,
    max( categorie_anagrafica.se_fornitore ) AS se_fornitore,
    max( categorie_anagrafica.se_produttore ) AS se_produttore,
    max( categorie_anagrafica.se_agente ) AS se_agente,
    max( categorie_anagrafica.se_interno ) AS se_interno,
    max( categorie_anagrafica.se_esterno ) AS se_esterno,
    max( categorie_anagrafica.se_amministrazione ) AS se_amministrazione,
    max( categorie_anagrafica.se_azienda_gestita ) AS se_azienda_gestita,
    max( categorie_anagrafica.se_concorrente ) AS se_concorrente,
    max( categorie_anagrafica.se_tutor ) AS se_tutor,
    max( categorie_anagrafica.se_classe ) AS se_classe,
    max( categorie_anagrafica.se_docente ) AS se_docente,
    max( categorie_anagrafica.se_allievo ) AS se_allievo,
    max( categorie_anagrafica.se_agenzia_interinale ) AS se_agenzia_interinale,
    max( categorie_anagrafica.se_referente ) AS se_referente,
    coalesce(
	anagrafica.soprannome,
	anagrafica.denominazione,
	concat_ws(' ', coalesce(anagrafica.cognome, ''),
	coalesce(anagrafica.nome, '') ),
	''
    ) AS __label__,
    coalesce(
	anagrafica.denominazione,
	concat_ws(' ', coalesce(anagrafica.cognome, ''),
	coalesce(anagrafica.nome, '') ),
	''
    ) AS denominazione_fiscale,
    d.nome AS diritto,
    coalesce( aAgente.soprannome, aAgente.denominazione , concat( aAgente.cognome, ' ', aAgente.nome ), '' ) AS agente,
    group_concat( DISTINCT categorie_anagrafica_path( categorie_anagrafica.id ) SEPARATOR ' | ' ) AS categorie,
    group_concat( DISTINCT telefoni.numero SEPARATOR ' | ' ) AS telefoni,
    group_concat( DISTINCT mail.indirizzo SEPARATOR ' | ' ) AS mail,
    group_concat( DISTINCT categorie_diritto.nome SEPARATOR ' | ' ) AS specialita,
    group_concat( DISTINCT provincie.sigla SEPARATOR ' | ' ) AS provincia,
    group_concat( DISTINCT regimi_fiscali.codice ) AS codice_regime_fiscale,
    group_concat( DISTINCT __acl_anagrafica__.id_gruppo SEPARATOR ' | ' ) AS gruppo
    FROM anagrafica
    LEFT JOIN anagrafica_categorie ON anagrafica_categorie.id_anagrafica = anagrafica.id
    LEFT JOIN categorie_anagrafica ON categorie_anagrafica.id = anagrafica_categorie.id_categoria
    LEFT JOIN telefoni ON telefoni.id_anagrafica = anagrafica.id
    LEFT JOIN mail ON mail.id_anagrafica = anagrafica.id
    LEFT JOIN regimi_fiscali ON regimi_fiscali.id = anagrafica.id_regime_fiscale
    LEFT JOIN mail AS pec ON ( pec.id = anagrafica.id_pec_sdi AND mail.se_pec = 1 )
    LEFT JOIN anagrafica AS aAgente ON aAgente.id = anagrafica.id_agente
    LEFT JOIN indirizzi_view ON ( indirizzi_view.id_anagrafica = anagrafica.id AND indirizzi_view.se_sede = 1 )
    LEFT JOIN provincie ON provincie.id = indirizzi_view.id_provincia
    LEFT JOIN anagrafica_categorie_diritto ON anagrafica_categorie_diritto.id_anagrafica = anagrafica.id
    LEFT JOIN categorie_diritto ON categorie_diritto.id = anagrafica_categorie_diritto.id_diritto 
    LEFT JOIN categorie_diritto AS d ON d.id = anagrafica.id_diritto 
    LEFT JOIN anagrafica_cittadinanze ON anagrafica_cittadinanze.id_anagrafica = anagrafica.id
    LEFT JOIN stati ON stati.id = anagrafica_cittadinanze.id_stato
    LEFT JOIN __acl_anagrafica__ ON __acl_anagrafica__.id_entita = anagrafica.id
    WHERE anagrafica.data_cessazione IS NULL
    GROUP BY anagrafica.id
    ORDER BY __label__
;
