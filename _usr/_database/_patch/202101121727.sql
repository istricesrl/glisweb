CREATE OR REPLACE VIEW stati_view AS
    SELECT
	stati.*,
	continenti_view.__label__ AS continente,
	COALESCE(		
	concat(stati.nome," (cessato il ",from_unixtime( stati.data_cessazione, '%d/%m/%Y' ),")"), 
	stati.nome
	)AS __label__
    FROM stati
    LEFT JOIN continenti_view ON continenti_view.id = stati.id_continente
    ORDER BY  __label__
;
