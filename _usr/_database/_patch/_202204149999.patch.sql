--
-- PATCH
--

--| 202204140010
CREATE TABLE IF NOT EXISTS `ruoli_articoli` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `nome` char(128) COLLATE utf8_general_ci NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_progetti`int(1) DEFAULT NULL,
  `se_risorse` int(1) DEFAULT NULL,
  `se_acquisto` int(1) DEFAULT NULL,
  `se_rinnovo` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202204140020
ALTER TABLE `ruoli_articoli`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`nome`),
	ADD KEY `id_genitore` (`id_genitore`), 
	ADD KEY `se_progetti` (`se_progetti`),
	ADD KEY `se_risorse` (`se_risorse`),
	ADD KEY `se_acquisto` (`se_acquisto`),
	ADD KEY `se_rinnovo` (`se_rinnovo`),
	ADD KEY `indice` (`id`,`id_genitore`,`nome`,`se_progetti`,`se_risorse`,`se_acquisto`, `se_rinnovo`);

--| 202204140030
ALTER TABLE `ruoli_articoli` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202204140040
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_articoli_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_articoli_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_articoli.id_genitore,
				ruoli_articoli.nome
			FROM ruoli_articoli
			WHERE ruoli_articoli.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 202204140050
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_articoli_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 int( 11 ) -> l'id dell'oggetto da cercare nel path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_articoli_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				ruoli_articoli.id_genitore
			FROM ruoli_articoli
			WHERE ruoli_articoli.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 202204140055
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_articoli_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_articoli_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_articoli.id_genitore,
				ruoli_articoli.id
			FROM ruoli_articoli
			WHERE ruoli_articoli.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 202204140060
DROP TABLE IF EXISTS `ruoli_articoli_view`;

--| 202204140090
CREATE OR REPLACE VIEW ruoli_articoli_view AS
	SELECT
		ruoli_articoli.id,
		ruoli_articoli.id_genitore,
		ruoli_articoli.nome,
		ruoli_articoli.html_entity,
		ruoli_articoli.font_awesome,
		ruoli_articoli.se_progetti,
		ruoli_articoli.se_risorse,
		ruoli_articoli.se_acquisto,
        ruoli_articoli.se_rinnovo,
	 	ruoli_articoli_path( ruoli_articoli.id ) AS __label__
	FROM ruoli_articoli
;

--| 202204140100
ALTER TABLE `ruoli_articoli`
    ADD CONSTRAINT `ruoli_articoli_ibfk_01`   FOREIGN KEY (`id_genitore`) REFERENCES `ruoli_articoli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202204140110
CREATE TABLE IF NOT EXISTS `progetti_articoli` (
  `id` int(11) NOT NULL,
  `id_progetto` char(32) NOT NULL,
  `id_articolo` char(32) NOT NULL,
  `id_ruolo` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` int(11) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` int(11) DEFAULT NULL	
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202204140120
ALTER TABLE `progetti_articoli`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_progetto`,`id_articolo`, `id_ruolo`),
	ADD KEY `id_ruolo` (`id_ruolo`), 
	ADD KEY `id_progetto` (`id_progetto`),
	ADD KEY `id_articolo` (`id_articolo`),	
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_progetto`,`id_articolo`, `id_ruolo`,`ordine`);

--| 202204140130
ALTER TABLE `progetti_articoli` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202204140140
ALTER TABLE `progetti_articoli`
    ADD CONSTRAINT `progetti_articoli_ibfk_01` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `progetti_articoli_ibfk_02` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `progetti_articoli_ibfk_03_nofollow` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `progetti_articoli_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `progetti_articoli_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202204140150
CREATE OR REPLACE VIEW `progetti_articoli_view` AS
	SELECT
		progetti_articoli.id,
		progetti_articoli.id_progetto,
		progetti.nome AS progetto,
		progetti_articoli.id_articolo,
		concat_ws( ' ', prodotti.nome, articoli.nome ) AS articolo,
		progetti_articoli.id_ruolo,
		progetti_articoli.ordine,
		progetti_articoli.id_account_inserimento,
		progetti_articoli.id_account_aggiornamento,
		concat_ws(
			' ',
			progetti.nome,
			concat_ws( ' ', prodotti.nome, articoli.nome ),
			ruoli_articoli.nome
		) AS __label__
	FROM progetti_articoli
		LEFT JOIN ruoli_articoli ON ruoli_articoli.id = progetti_articoli.id_ruolo
		LEFT JOIN progetti ON progetti.id = progetti_articoli.id_progetto
		LEFT JOIN articoli ON articoli.id = progetti_articoli.id_articolo
		LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto;

--| 202204140160
CREATE TABLE IF NOT EXISTS `recensioni` (
`id` int(11) NOT NULL,
  `id_lingua` int(11) NOT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `id_risorsa` int(11) NULL DEFAULT NULL,
  `id_pagina` int(11) NULL DEFAULT NULL,
  `autore` char(128) NULL NULL,
  `valutazione` int(11) NULL NULL,
  `titolo` char(255) NULL DEFAULT NULL,
  `testo` text,
  `se_approvata` tinyint(1) NULL DEFAULT NULL,
  `id_account_inserimento` int(11) NULL DEFAULT NULL,
  `timestamp_inserimento` int(11) NULL DEFAULT NULL,
  `id_account_aggiornamento` int(11) NULL DEFAULT NULL,
  `timestamp_aggiornamento` int(11) NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202204140170
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

--| 202204140180
ALTER TABLE `recensioni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202204140190
ALTER TABLE `recensioni`
ADD CONSTRAINT `recensioni_ibfk_01` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `recensioni_ibfk_02_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `recensioni_ibfk_03_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `recensioni_ibfk_04_nofollow` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `recensioni_ibfk_05_nofollow` FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `recensioni_ibfk_06_nofollow` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `recensioni_ibfk_07_nofollow` FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
;

--| 202204140200
CREATE OR REPLACE VIEW recensioni_view AS
    SELECT
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

--| 202204140210
ALTER TABLE `risorse`
ADD `id_sito` INT NULL DEFAULT NULL AFTER `note`,
ADD `template` CHAR(255) NULL DEFAULT NULL AFTER `id_sito`,
ADD `schema_html` CHAR(128) NULL DEFAULT NULL AFTER `template`,
ADD `tema_css` CHAR(32) NULL DEFAULT NULL AFTER `schema_html`,
ADD `se_sitemap` INT(1) NULL DEFAULT NULL AFTER `tema_css`,
ADD `se_cacheable` INT(1) NULL DEFAULT NULL AFTER `se_sitemap`,
ADD KEY `id_sito` (`id_sito`),
ADD KEY `se_sitemap` (`se_sitemap`),
ADD KEY `se_cacheable` (`se_cacheable`);

--| 202204140220
CREATE OR REPLACE VIEW `risorse_view` AS
	SELECT
		risorse.id, 
		risorse.id_tipologia,
		tipologie_risorse.nome AS tipologia,
		risorse.codice, 
		risorse.nome,
		risorse.template,
		risorse.schema_html,
		risorse.tema_css,
		risorse.se_sitemap,
		risorse.se_cacheable,
		risorse.id_sito,
		risorse.id_testata, 
		testate.nome AS testata,
		risorse.giorno_pubblicazione,
		risorse.mese_pubblicazione,
		risorse.anno_pubblicazione,
		risorse.id_account_inserimento,
		risorse.id_account_aggiornamento,
		concat_ws(
			' ',
			risorse.codice,
			risorse.nome
		) AS __label__
	FROM risorse
		LEFT JOIN tipologie_risorse ON tipologie_risorse.id = risorse.id_tipologia
		LEFT JOIN testate ON testate.id = risorse.id_testata
;

--| FINE FILE

