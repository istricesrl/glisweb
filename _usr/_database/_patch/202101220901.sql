CREATE OR REPLACE VIEW `pianificazioni_view` AS
SELECT pianificazioni.*,
	concat( id, ' ', entita, ' ', nome ) as __label__
FROM pianificazioni
ORDER BY __label__
;