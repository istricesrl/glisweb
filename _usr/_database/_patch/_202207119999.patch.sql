--
-- PATCH
--

--| 202207110030
CREATE OR REPLACE VIEW `periodicita_view` AS
	SELECT
		periodicita.id,
		periodicita.nome,
		periodicita.nome AS __label__
	FROM periodicita
;
--| FINE