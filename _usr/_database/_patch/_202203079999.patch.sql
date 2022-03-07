--
-- PATCH
--

--| 202203070010
ALTER TABLE `anagrafica_view_static` ADD `data_nascita` char(32) COLLATE 'utf8_general_ci' NULL AFTER `mail`;

--| 202203070020
TRUNCATE anagrafica_view_static;

--| 202203070030
CREATE OR REPLACE VIEW anagrafica_view AS
	SELECT
		anagrafica.id,
		tipologie_anagrafica.nome AS tipologia,
		anagrafica.codice,
		anagrafica.riferimento,
		anagrafica.nome,
		anagrafica.cognome,
		anagrafica.denominazione,
		anagrafica.soprannome,
		anagrafica.sesso,
		anagrafica.codice_fiscale,
		anagrafica.partita_iva,
		ranking.nome AS ranking,
		anagrafica.recapiti,
		max( categorie_anagrafica.se_prospect ) AS se_prospect,
		max( categorie_anagrafica.se_lead ) AS se_lead,
		max( categorie_anagrafica.se_cliente ) AS se_cliente,
		max( categorie_anagrafica.se_fornitore ) AS se_fornitore,
		max( categorie_anagrafica.se_produttore ) AS se_produttore,
		max( categorie_anagrafica.se_collaboratore ) AS se_collaboratore,
		max( categorie_anagrafica.se_interno ) AS se_interno,
		max( categorie_anagrafica.se_esterno ) AS se_esterno,
		max( categorie_anagrafica.se_commerciale ) AS se_commerciale,
		max( categorie_anagrafica.se_concorrente ) AS se_concorrente,
		max( categorie_anagrafica.se_gestita ) AS se_gestita,
		max( categorie_anagrafica.se_amministrazione ) AS se_amministrazione,
		max( categorie_anagrafica.se_notizie ) AS se_notizie,
		group_concat( DISTINCT categorie_anagrafica_path( categorie_anagrafica.id ) SEPARATOR ' | ' ) AS categorie,
		group_concat( DISTINCT telefoni.numero SEPARATOR ' | ' ) AS telefoni,
		group_concat( DISTINCT mail.indirizzo SEPARATOR ' | ' ) AS mail,
		concat_ws( '-', anagrafica.anno_nascita, anagrafica.mese_nascita, anagrafica.giorno_nascita ) AS data_nascita,
		anagrafica.data_archiviazione,
		anagrafica.id_account_inserimento,
		anagrafica.id_account_aggiornamento,
		coalesce(
			anagrafica.soprannome,
			anagrafica.denominazione,
			concat_ws(' ', coalesce(anagrafica.cognome, ''),
			coalesce(anagrafica.nome, '') ),
			''
		) AS __label__
	FROM anagrafica
		LEFT JOIN tipologie_anagrafica ON tipologie_anagrafica.id = anagrafica.id_tipologia
		LEFT JOIN ranking ON ranking.id = anagrafica.id_ranking
		LEFT JOIN anagrafica_categorie ON anagrafica_categorie.id_anagrafica = anagrafica.id
		LEFT JOIN categorie_anagrafica ON categorie_anagrafica.id = anagrafica_categorie.id_categoria
		LEFT JOIN telefoni ON telefoni.id_anagrafica = anagrafica.id
		LEFT JOIN mail ON mail.id_anagrafica = anagrafica.id
	GROUP BY anagrafica.id
;

--| 202203070040
INSERT INTO anagrafica_view_static SELECT * FROM anagrafica_view;

--| FINE