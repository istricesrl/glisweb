CREATE OR REPLACE VIEW `popup_view` AS
	SELECT
	popup.*,
	tipologie_pubblicazione.nome AS tipologia_pubblicazione,
	tipologie_popup.nome AS tipologia,
	popup.nome AS __label__
	FROM popup
	LEFT JOIN tipologie_popup ON tipologie_popup.id = popup.id_tipologia
	LEFT JOIN tipologie_pubblicazione ON tipologie_pubblicazione.id = popup.id_tipologia_pubblicazione
	ORDER BY __label__
;