CREATE OR REPLACE VIEW `costi_contratti_view` AS
	SELECT
	costi_contratti.*,
	CONCAT( 
		if( tipologie_attivita_inps.codice IS NOT NULL, CONCAT( tipologie_attivita_inps.codice, ' - '), "" ),
		tipologie_attivita_inps.nome 
	) AS __label__
	FROM costi_contratti
	LEFT JOIN tipologie_attivita_inps ON tipologie_attivita_inps.id = costi_contratti.id_tipologia
	ORDER BY __label__
;