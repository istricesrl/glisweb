CREATE OR REPLACE VIEW ruoli_anagrafica_view AS
    SELECT
	ruoli_anagrafica.*,
        ruoli_anagrafica_path( ruoli_anagrafica.id ) AS __label__
    FROM ruoli_anagrafica
    ORDER BY __label__
;