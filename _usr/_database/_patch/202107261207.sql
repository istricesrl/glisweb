CREATE OR REPLACE VIEW `certificazioni_view` AS
SELECT certificazioni.*,
	tipologie_certificazioni.nome as tipologia,
	concat(
		certificazioni.id, ' ',
		tipologie_certificazioni.nome, 
		' ', 
		certificazioni.nome
	) as __label__
FROM certificazioni 
LEFT JOIN tipologie_certificazioni ON certificazioni.id_tipologia = tipologie_certificazioni.id
ORDER BY __label__
;
