CREATE OR REPLACE VIEW `tipologie_attivita_inps_view` AS
	SELECT
	tipologie_attivita_inps.*,
	CONCAT( 
		if( tipologie_attivita_inps.codice IS NOT NULL, CONCAT( tipologie_attivita_inps.codice, ' - '), "" ),
		tipologie_attivita_inps.nome 
	) AS __label__
	FROM tipologie_attivita_inps
	ORDER BY __label__
;
