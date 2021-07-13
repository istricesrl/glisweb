CREATE OR REPLACE VIEW contatti_view AS
    SELECT
	contatti.*,
	contatti.json AS __label__
    FROM contatti
    ORDER BY __label__
;