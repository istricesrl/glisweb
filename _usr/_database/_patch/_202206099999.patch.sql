--
-- PATCH
--

--| 202206090010
CREATE TABLE IF NOT EXISTS `recensioni` (
`id` int(11) NOT NULL,
  `id_lingua` int(11) NOT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `id_risorsa` int(11) NULL DEFAULT NULL,
  `id_pagina` int(11) NULL DEFAULT NULL,
  `autore` char(128) NULL DEFAULT NULL,
  `valutazione` int(11) NULL DEFAULT NULL,
  `titolo` char(255) NULL DEFAULT NULL,
  `testo` text,
  `se_approvata` tinyint(1) NULL DEFAULT NULL,
  `id_account_inserimento` int(11) NULL DEFAULT NULL,
  `timestamp_inserimento` int(11) NULL DEFAULT NULL,
  `id_account_aggiornamento` int(11) NULL DEFAULT NULL,
  `timestamp_aggiornamento` int(11) NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202206090020
ALTER TABLE `recensioni`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_lingua` (`id_lingua`),
	ADD KEY `id_prodotto` (`id_prodotto`),
	ADD KEY `id_articolo` (`id_articolo`),
	ADD KEY `id_risorsa` (`id_risorsa`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_lingua`,`id_prodotto`,`id_articolo`, `id_risorsa` ,`autore`,`valutazione`,`se_approvata`),
	ADD KEY `id_pagina` (`id_pagina`);

--| 202206090030
ALTER TABLE `recensioni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202206090040
ALTER TABLE `recensioni`
ADD CONSTRAINT `recensioni_ibfk_01` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `recensioni_ibfk_02_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `recensioni_ibfk_03_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `recensioni_ibfk_04_nofollow` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `recensioni_ibfk_05_nofollow` FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `recensioni_ibfk_06_nofollow` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `recensioni_ibfk_07_nofollow` FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
;

--| 202206090050
CREATE OR REPLACE VIEW recensioni_view AS
    SELECT
    	recensioni.id,
	recensioni.id_lingua ,
	recensioni.id_prodotto,
	prodotti.nome AS prodotto,
	recensioni.id_articolo,
	concat_ws( ' ', p2.nome, articoli.nome ) AS articolo,
	recensioni.id_risorsa,
	risorse.nome AS risorsa,
	recensioni.id_pagina,
	recensioni.autore,
	recensioni.valutazione,
	recensioni.titolo ,
	recensioni.se_approvata,
	recensioni.id_account_inserimento ,
	recensioni.id_account_aggiornamento ,
	from_unixtime( recensioni.timestamp_inserimento, '%Y-%m-%d %H:%i' ) AS data_ora_recensione,
	concat_ws( '|', recensioni.autore, recensioni.titolo ) AS __label__
    FROM recensioni
    	LEFT JOIN articoli ON articoli.id = recensioni.id_articolo
    	LEFT JOIN prodotti AS p2 ON p2.id = articoli.id_prodotto
	LEFT JOIN prodotti ON prodotti.id = recensioni.id_prodotto
	LEFT JOIN risorse ON risorse.id = recensioni.id_risorsa
;

--| FINE