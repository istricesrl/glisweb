CREATE OR REPLACE VIEW categorie_prodotti_view AS
    SELECT
	categorie_prodotti.*,
	tipologie_pubblicazione.se_pubblicato,
	tipologie_pubblicazione.nome AS pubblicazione,
	count( prodotti_categorie.id ) AS numero_prodotti,
	categorie_prodotti_path( categorie_prodotti.id ) AS __label__
    FROM categorie_prodotti
    LEFT JOIN tipologie_pubblicazione ON tipologie_pubblicazione.id = categorie_prodotti.id_tipologia_pubblicazione
    LEFT JOIN prodotti_categorie ON prodotti_categorie.id_categoria = categorie_prodotti.id
    GROUP BY categorie_prodotti.id
    ORDER BY __label__
;