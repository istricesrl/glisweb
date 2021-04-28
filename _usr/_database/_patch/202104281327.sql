CREATE OR REPLACE VIEW `pianificazioni_view` AS
SELECT pianificazioni.*,
	concat( pianificazioni.id, ' ', pianificazioni.entita, ' ', pianificazioni.nome ) as __label__
FROM pianificazioni
ORDER BY __label__
;