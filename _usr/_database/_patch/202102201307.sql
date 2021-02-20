CREATE OR REPLACE VIEW `pianificazioni_view` AS
SELECT pianificazioni.*,
	concat( pianificazioni.id, ' ', pianificazioni.entita, ' ', pianificazioni.nome ) as __label__
FROM pianificazioni
LEFT JOIN contratti_view ON pianificazioni.id_contratto = contratti_view.id
LEFT JOIN progetti_view ON pianificazioni.id_progetto = progetti_view.id
ORDER BY __label__
;