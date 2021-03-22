CREATE OR REPLACE VIEW `patrocini_pratiche_view` AS
    SELECT
    patrocini_pratiche.*,
    concat(coalesce(sede.nome, sede.denominazione),'/',pratiche.numero,'/', YEAR(pratiche.data_apertura)) AS pratica,
    concat( 'patrocinio della pratica ',
	 concat(coalesce(sede.nome, sede.denominazione),'/',pratiche.numero,'/', YEAR(pratiche.data_apertura)), ' ',
	patrocini_pratiche.numero, ' | ', 
	IF(patrocini_pratiche.se_liquidato, 
	    IF( patrocini_pratiche.data_liquidazione, concat(' liquidato in data ', patrocini_pratiche.data_liquidazione), 'liquidato'),
	     ' non liquidato' ), ' | ',
	IF( patrocini_pratiche.se_fatturato, 'fatturato', 'non fatturato' )
    ) AS __label__
    FROM patrocini_pratiche
    LEFT JOIN pratiche ON patrocini_pratiche.id_pratica = pratiche.id
    LEFT JOIN anagrafica AS sede ON sede.id = pratiche.id_sede_apertura
    ORDER BY __label__
;