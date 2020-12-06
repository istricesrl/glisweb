CREATE OR REPLACE VIEW `costi_contratti_view` AS
	SELECT
	costi_contratti.*,
	tipologie_costi_contratti.nome AS __label__
	FROM costi_contratti
	LEFT JOIN tipologie_costi_contratti ON tipologie_costi_contratti.id = costi_contratti.id_tipologia
	ORDER BY __label__
;