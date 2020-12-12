-- vista tipologie_costi_contratti_view
CREATE OR REPLACE VIEW `tipologie_costi_contratti_view` AS
	SELECT
	tipologie_costi_contratti.*,
	tipologie_costi_contratti.nome AS __label__
	FROM tipologie_costi_contratti
	ORDER BY __label__
;