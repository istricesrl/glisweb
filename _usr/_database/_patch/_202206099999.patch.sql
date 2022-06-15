--
-- PATCH
--

--| 202206099010
ALTER TABLE `progetti` DROP  KEY `indice`;

--| 202206099020
ALTER TABLE `progetti`
ADD COLUMN  `id_ranking` int(11) DEFAULT NULL AFTER `id_indirizzo`,
ADD KEY `id_ranking` (`id_ranking`),	
ADD KEY `indice` (`id`,`id_tipologia`,`id_pianificazione`,`id_cliente`,`id_indirizzo`,`id_ranking` ,`nome`,`data_accettazione`,`data_chiusura`,`data_archiviazione`),
ADD CONSTRAINT `progetti_ibfk_05_nofollow` FOREIGN KEY (`id_ranking`) REFERENCES `ranking` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--| 202206099030
CREATE OR REPLACE VIEW `progetti_view` AS
	SELECT
		progetti.id,
		progetti.id_tipologia,
		tipologie_progetti_path( tipologie_progetti.id ) AS tipologia,
		progetti.id_pianificazione,
		progetti.id_cliente,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS cliente,
		progetti.id_indirizzo,
		progetti.id_ranking,
		ranking.nome AS ranking,
		progetti.nome,
        progetti.id_sito,
		progetti.template,
		progetti.schema_html,
		progetti.tema_css,
		progetti.se_sitemap,
		progetti.se_cacheable,
		progetti.entrate_previste,
		progetti.ore_previste,
		progetti.costi_previsti,
		progetti.entrate_accettazione,
		progetti.data_accettazione,
		progetti.data_chiusura,
		progetti.entrate_totali,
		progetti.uscite_totali,
		progetti.data_archiviazione,
		group_concat( DISTINCT categorie_progetti_path( progetti_categorie.id_categoria ) SEPARATOR ' | ' ) AS categorie,
		progetti.id_account_inserimento,
		progetti.id_account_aggiornamento,
		concat_ws(
			' ',
			progetti.id,
			progetti.nome,
			' cliente ',
			coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' )
		) AS __label__
	FROM progetti
		LEFT JOIN anagrafica AS a1 ON a1.id = progetti.id_cliente
		LEFT JOIN tipologie_progetti ON tipologie_progetti.id = progetti.id_tipologia
		LEFT JOIN progetti_categorie ON progetti_categorie.id_progetto = progetti.id
		LEFT JOIN ranking ON ranking.id = progetti.id_ranking
	GROUP BY progetti.id
;

--| 202206099040
CREATE OR REPLACE VIEW `progetti_commerciale_view` AS
	SELECT
		progetti.id,
		progetti.id_tipologia,
		tipologie_progetti_path( tipologie_progetti.id ) AS tipologia,
		progetti.id_pianificazione,
		progetti.id_cliente,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS cliente,
		progetti.id_indirizzo,
		progetti.id_ranking,
		ranking.nome AS ranking,
		progetti.nome,
		progetti.entrate_previste,
		progetti.ore_previste,
		progetti.costi_previsti,
		progetti.entrate_accettazione,
		progetti.data_accettazione,
		progetti.data_chiusura,
		progetti.entrate_totali,
		progetti.uscite_totali,
		progetti.data_archiviazione,
		group_concat( DISTINCT categorie_progetti_path( progetti_categorie.id_categoria ) SEPARATOR ' | ' ) AS categorie,
		progetti.id_account_inserimento,
		progetti.id_account_aggiornamento,
		concat_ws(
			' ',
			progetti.id,
			progetti.nome,
			coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' )
		) AS __label__
	FROM progetti
		LEFT JOIN anagrafica AS a1 ON a1.id = progetti.id_cliente
		LEFT JOIN tipologie_progetti ON tipologie_progetti.id = progetti.id_tipologia
		LEFT JOIN progetti_categorie ON progetti_categorie.id_progetto = progetti.id
		LEFT JOIN ranking ON ranking.id = progetti.id_ranking
	WHERE progetti.data_accettazione IS NULL
		AND progetti.data_chiusura IS NULL
		AND progetti.data_archiviazione IS NULL
	GROUP BY progetti.id
;

--| 202206099050
CREATE OR REPLACE VIEW `progetti_commerciale_archivio_view` AS
	SELECT
		progetti.id,
		progetti.id_tipologia,
		tipologie_progetti_path( tipologie_progetti.id ) AS tipologia,
		progetti.id_pianificazione,
		progetti.id_cliente,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS cliente,
		progetti.id_indirizzo,
		progetti.id_ranking,
		ranking.nome AS ranking,
		progetti.nome,
		progetti.entrate_previste,
		progetti.ore_previste,
		progetti.costi_previsti,
		progetti.entrate_accettazione,
		progetti.data_accettazione,
		progetti.data_chiusura,
		progetti.entrate_totali,
		progetti.uscite_totali,
		progetti.data_archiviazione,
		group_concat( DISTINCT categorie_progetti_path( progetti_categorie.id_categoria ) SEPARATOR ' | ' ) AS categorie,
		progetti.id_account_inserimento,
		progetti.id_account_aggiornamento,
		concat_ws(
			' ',
			progetti.id,
			progetti.nome,
			coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' )
		) AS __label__
	FROM progetti
		LEFT JOIN anagrafica AS a1 ON a1.id = progetti.id_cliente
		LEFT JOIN tipologie_progetti ON tipologie_progetti.id = progetti.id_tipologia
		LEFT JOIN progetti_categorie ON progetti_categorie.id_progetto = progetti.id
		LEFT JOIN ranking ON ranking.id = progetti.id_ranking
	WHERE progetti.data_accettazione IS NULL
		AND progetti.data_chiusura IS NULL
		AND progetti.data_archiviazione IS NOT NULL
	GROUP BY progetti.id
;

--| 202206099060
CREATE OR REPLACE VIEW `progetti_produzione_view` AS
	SELECT
		progetti.id,
		progetti.id_tipologia,
		tipologie_progetti_path( tipologie_progetti.id ) AS tipologia,
		progetti.id_pianificazione,
		progetti.id_cliente,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS cliente,
		progetti.id_indirizzo,
		progetti.id_ranking,
		ranking.nome AS ranking,
		progetti.nome,
		progetti.entrate_previste,
		progetti.ore_previste,
		progetti.costi_previsti,
		progetti.entrate_accettazione,
		progetti.data_accettazione,
		progetti.data_chiusura,
		progetti.entrate_totali,
		progetti.uscite_totali,
		progetti.data_archiviazione,
		group_concat( DISTINCT categorie_progetti_path( progetti_categorie.id_categoria ) SEPARATOR ' | ' ) AS categorie,
		progetti.id_account_inserimento,
		progetti.id_account_aggiornamento,
		concat_ws(
			' ',
			progetti.id,
			progetti.nome,
			coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' )
		) AS __label__
	FROM progetti
		LEFT JOIN anagrafica AS a1 ON a1.id = progetti.id_cliente
		LEFT JOIN tipologie_progetti ON tipologie_progetti.id = progetti.id_tipologia
		LEFT JOIN progetti_categorie ON progetti_categorie.id_progetto = progetti.id
		LEFT JOIN ranking ON ranking.id = progetti.id_ranking
	WHERE progetti.data_accettazione IS NOT NULL
		AND progetti.data_chiusura IS NULL
		AND progetti.data_archiviazione IS NULL
	GROUP BY progetti.id
;

--| 202206099070
CREATE OR REPLACE VIEW `progetti_produzione_archivio_view` AS
	SELECT
		progetti.id,
		progetti.id_tipologia,
		tipologie_progetti_path( tipologie_progetti.id ) AS tipologia,
		progetti.id_pianificazione,
		progetti.id_cliente,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS cliente,
		progetti.id_indirizzo,
		progetti.id_ranking,
		ranking.nome AS ranking,
		progetti.nome,
		progetti.entrate_previste,
		progetti.ore_previste,
		progetti.costi_previsti,
		progetti.entrate_accettazione,
		progetti.data_accettazione,
		progetti.data_chiusura,
		progetti.entrate_totali,
		progetti.uscite_totali,
		progetti.data_archiviazione,
		group_concat( DISTINCT categorie_progetti_path( progetti_categorie.id_categoria ) SEPARATOR ' | ' ) AS categorie,
		progetti.id_account_inserimento,
		progetti.id_account_aggiornamento,
		concat_ws(
			' ',
			progetti.id,
			progetti.nome,
			coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' )
		) AS __label__
	FROM progetti
		LEFT JOIN anagrafica AS a1 ON a1.id = progetti.id_cliente
		LEFT JOIN tipologie_progetti ON tipologie_progetti.id = progetti.id_tipologia
		LEFT JOIN progetti_categorie ON progetti_categorie.id_progetto = progetti.id
		LEFT JOIN ranking ON ranking.id = progetti.id_ranking
	WHERE progetti.data_accettazione IS NOT NULL
		AND progetti.data_chiusura IS NULL
		AND progetti.data_archiviazione IS NOT NULL
	GROUP BY progetti.id
;

--| 202206099080
CREATE OR REPLACE VIEW `progetti_amministrazione_view` AS
	SELECT
		progetti.id,
		progetti.id_tipologia,
		tipologie_progetti_path( tipologie_progetti.id ) AS tipologia,
		progetti.id_pianificazione,
		progetti.id_cliente,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS cliente,
		progetti.id_indirizzo,
		progetti.id_ranking,
		ranking.nome AS ranking,
		progetti.nome,
		progetti.entrate_previste,
		progetti.ore_previste,
		progetti.costi_previsti,
		progetti.entrate_accettazione,
		progetti.data_accettazione,
		progetti.data_chiusura,
		progetti.entrate_totali,
		progetti.uscite_totali,
		progetti.data_archiviazione,
		group_concat( DISTINCT categorie_progetti_path( progetti_categorie.id_categoria ) SEPARATOR ' | ' ) AS categorie,
		progetti.id_account_inserimento,
		progetti.id_account_aggiornamento,
		concat_ws(
			' ',
			progetti.id,
			progetti.nome,
			coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' )
		) AS __label__
	FROM progetti
		LEFT JOIN anagrafica AS a1 ON a1.id = progetti.id_cliente
		LEFT JOIN tipologie_progetti ON tipologie_progetti.id = progetti.id_tipologia
		LEFT JOIN progetti_categorie ON progetti_categorie.id_progetto = progetti.id
		LEFT JOIN ranking ON ranking.id = progetti.id_ranking
	WHERE progetti.data_accettazione IS NOT NULL
		AND progetti.data_chiusura IS NOT NULL
		AND progetti.data_archiviazione IS NULL
	GROUP BY progetti.id
;

--| 202206099090
CREATE OR REPLACE VIEW `progetti_amministrazione_archivio_view` AS
	SELECT
		progetti.id,
		progetti.id_tipologia,
		tipologie_progetti_path( tipologie_progetti.id ) AS tipologia,
		progetti.id_pianificazione,
		progetti.id_cliente,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS cliente,
		progetti.id_indirizzo,
		progetti.id_ranking,
		ranking.nome AS ranking,
		progetti.nome,
		progetti.entrate_previste,
		progetti.ore_previste,
		progetti.costi_previsti,
		progetti.entrate_accettazione,
		progetti.data_accettazione,
		progetti.data_chiusura,
		progetti.entrate_totali,
		progetti.uscite_totali,
		progetti.data_archiviazione,
		group_concat( DISTINCT categorie_progetti_path( progetti_categorie.id_categoria ) SEPARATOR ' | ' ) AS categorie,
		progetti.id_account_inserimento,
		progetti.id_account_aggiornamento,
		concat_ws(
			' ',
			progetti.id,
			progetti.nome,
			coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' )
		) AS __label__
	FROM progetti
		LEFT JOIN anagrafica AS a1 ON a1.id = progetti.id_cliente
		LEFT JOIN tipologie_progetti ON tipologie_progetti.id = progetti.id_tipologia
		LEFT JOIN progetti_categorie ON progetti_categorie.id_progetto = progetti.id
		LEFT JOIN ranking ON ranking.id = progetti.id_ranking
	WHERE progetti.data_accettazione IS NOT NULL
		AND progetti.data_chiusura IS NOT NULL
		AND progetti.data_archiviazione IS NOT NULL
	GROUP BY progetti.id
;

--| 202206099100
ALTER TABLE `luoghi` DROP KEY  `indice`;

--| 202206099110
ALTER TABLE `luoghi`
ADD COLUMN   `id_edificio` int(11) DEFAULT NULL    AFTER `id_indirizzo`,
ADD COLUMN   `id_immobile` int(11) DEFAULT NULL    AFTER `id_edificio`,
ADD KEY `id_edificio` (`id_edificio`), 
ADD KEY `id_immobile` (`id_immobile`), 
ADD KEY `indice` (`id`,`id_genitore`,`id_indirizzo`, `id_edificio`, `id_immobile`,`nome`),
ADD CONSTRAINT `luoghi_ibfk_03_nofollow` FOREIGN KEY (`id_edificio`) REFERENCES `edifici` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `luoghi_ibfk_04_nofollow` FOREIGN KEY (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202206099120
CREATE OR REPLACE VIEW `luoghi_view` AS
	SELECT
		luoghi.id,
		luoghi.id_genitore,
		luoghi.id_indirizzo,
		concat_ws(
			' ',
			indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) AS indirizzo,
		luoghi.id_edificio,
		luoghi.id_immobile,		
		luoghi.nome,
		luoghi.id_account_inserimento,
		luoghi.id_account_aggiornamento,
		luoghi_path( luoghi.id ) AS __label__
	FROM luoghi
		LEFT JOIN indirizzi ON indirizzi.id = luoghi.id_indirizzo
		LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
;

--| 202206099130
ALTER TABLE prodotti DROP KEY `indice`;

--| 202206099140
ALTER TABLE prodotti
    ADD COLUMN   `id_progetto` char(32) DEFAULT NULL AFTER  `codice_produttore`,
	ADD KEY `id_progetto` (`id_progetto`),
	ADD KEY `indice` (`id`,`id_tipologia`,`id_marchio`,`id_produttore`,`nome`,`codice_produttore`, `id_progetto`),
    ADD CONSTRAINT `prodotti_ibfk_04_nofollow` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202206099150
CREATE OR REPLACE VIEW `prodotti_view` AS
	SELECT
		prodotti.id,
		prodotti.id_tipologia,
		tipologie_prodotti.nome AS tipologia,
		tipologie_prodotti.se_prodotto,
		tipologie_prodotti.se_servizio,
		prodotti.nome,
		prodotti.id_marchio,
		marchi.nome AS marchio,
		prodotti.id_produttore,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS produttore,
		prodotti.codice_produttore,
		prodotti.id_progetto,
		progetti.nome AS progetto,
		group_concat( DISTINCT categorie_prodotti_path( prodotti_categorie.id_categoria ) SEPARATOR ' | ' ) AS categorie,
		prodotti.id_sito,
		prodotti.template,
		prodotti.schema_html,
		prodotti.tema_css,
		prodotti.se_sitemap,
		prodotti.se_cacheable,
		prodotti.id_account_inserimento,
		prodotti.id_account_aggiornamento,
		concat_ws(
			' ',
			prodotti.id,
			prodotti.nome
		) AS __label__
	FROM prodotti
		LEFT JOIN tipologie_prodotti ON tipologie_prodotti.id = prodotti.id_tipologia
		LEFT JOIN marchi ON marchi.id = prodotti.id_marchio
		LEFT JOIN anagrafica AS a1 ON a1.id = prodotti.id_produttore
		LEFT JOIN prodotti_categorie ON prodotti_categorie.id_prodotto = prodotti.id
		LEFT JOIN progetti ON  progetti.id = prodotti.id_progetto
	GROUP BY prodotti.id
;

--| 202206099160
ALTER TABLE `pianificazioni` 
    ADD COLUMN `id_genitore` int(11) DEFAULT NULL AFTER id,
	ADD KEY `id_genitore` (`id_genitore`),
    ADD CONSTRAINT `pianificazioni_ibfk_00`             FOREIGN KEY (`id_genitore`) REFERENCES `pianificazioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202206099170
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `pianificazioni_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT pianificazioni_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				pianificazioni.id_genitore,
				pianificazioni.nome
			FROM pianificazioni
			WHERE pianificazioni.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 202206099180
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `pianificazioni_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT pianificazioni_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				pianificazioni.id_genitore
			FROM pianificazioni
			WHERE pianificazioni.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 202206099190
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `pianificazioni_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT pianificazioni_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				pianificazioni.id_genitore,
				pianificazioni.id
			FROM pianificazioni
			WHERE pianificazioni.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 202206099200
CREATE OR REPLACE VIEW `pianificazioni_view` AS
	SELECT
		pianificazioni.id,
		pianificazioni.id_genitore,
		pianificazioni.id_progetto,
		pianificazioni.id_todo,
		pianificazioni.id_attivita,
		pianificazioni.id_contratto,
		pianificazioni.nome,
		pianificazioni.id_periodicita,
		periodicita.nome AS periodicita,
		pianificazioni.cadenza,
		pianificazioni.se_lunedi,
		pianificazioni.se_martedi,
		pianificazioni.se_mercoledi,
		pianificazioni.se_giovedi,
		pianificazioni.se_venerdi,
		pianificazioni.se_sabato,
		pianificazioni.se_domenica,
		pianificazioni.schema_ripetizione,
		pianificazioni.data_elaborazione,
		pianificazioni.giorni_estensione,
		pianificazioni.data_fine,
		pianificazioni.entita,
		pianificazioni.model_id_luogo,
		pianificazioni.model_ora_inizio_programmazione,
		pianificazioni.model_ora_fine_programmazione,
		pianificazioni.workspace,
		pianificazioni.token,
		pianificazioni.id_account_inserimento,
		pianificazioni.id_account_aggiornamento,
		concat_ws(
			' ',
			pianificazioni.nome,
			periodicita.nome,
			pianificazioni.cadenza
		) as __label__
	FROM pianificazioni
		LEFT JOIN periodicita ON periodicita.id = pianificazioni.id_periodicita
;

--| 202206099210
CREATE TABLE IF NOT EXISTS `ruoli_documenti` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `nome` char(128) COLLATE utf8_general_ci NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_xml` int(1) DEFAULT NULL,
  `se_documenti` int(1) DEFAULT NULL,
  `se_documenti_articoli` int(1) DEFAULT NULL,
  `se_conferma` int(1) DEFAULT NULL,
  `se_consuntivo` int(1) DEFAULT NULL,
  `se_evasione` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202206099220
ALTER TABLE `ruoli_documenti`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`nome`),
	ADD KEY `id_genitore` (`id_genitore`), 
	ADD KEY `se_xml` (`se_xml`), 
	ADD KEY `se_documenti` (`se_documenti`), 
	ADD KEY `se_documenti_articoli` (`se_documenti_articoli`), 
	ADD KEY `se_conferma` (`se_conferma`), 
	ADD KEY `se_consuntivo` (`se_consuntivo`), 
	ADD KEY `se_evasione` (`se_evasione`), 
	ADD KEY `indice` (`id`,`id_genitore`,`nome`,`html_entity`,`font_awesome`,`se_xml`,`se_documenti`,`se_documenti_articoli`,`se_conferma`, `se_consuntivo`,  `se_evasione`);

--| 202206099230
ALTER TABLE `ruoli_documenti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202206099240
ALTER TABLE `ruoli_documenti`
    ADD CONSTRAINT `ruoli_documenti_ibfk_01`     FOREIGN KEY (`id_genitore`) REFERENCES `ruoli_documenti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202206099250
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_documenti_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_documenti_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_documenti.id_genitore,
				ruoli_documenti.nome
			FROM ruoli_documenti
			WHERE ruoli_documenti.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 202206099260
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_documenti_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT ruoli_documenti_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				ruoli_documenti.id_genitore
			FROM ruoli_documenti
			WHERE ruoli_documenti.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 202206099270
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_documenti_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_documenti_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_documenti.id_genitore,
				ruoli_documenti.id
			FROM ruoli_documenti
			WHERE ruoli_documenti.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 202206099280
CREATE OR REPLACE VIEW ruoli_documenti_view AS
	SELECT
		ruoli_documenti.id,
		ruoli_documenti.id_genitore,
		ruoli_documenti.nome,
		ruoli_documenti.html_entity,
		ruoli_documenti.font_awesome,
		ruoli_documenti.se_xml,
		ruoli_documenti.se_documenti,
		ruoli_documenti.se_documenti_articoli,
		ruoli_documenti.se_conferma,
		ruoli_documenti.se_consuntivo,
		ruoli_documenti.se_evasione,
	 	ruoli_documenti_path( ruoli_documenti.id ) AS __label__
	FROM ruoli_documenti
;

--| 202206099290
ALTER TABLE `relazioni_documenti`
DROP KEY `unico`;

--| 202206099300
ALTER TABLE `relazioni_documenti_articoli`
DROP KEY `unico`;

--| 202206099310
ALTER TABLE `relazioni_documenti`
	ADD COLUMN   `id_ruolo` int(11) DEFAULT NULL AFTER `id_documento_collegato`,
 	ADD KEY `id_ruolo` (`id_ruolo`), 
	ADD UNIQUE KEY `unico` (`id_documento`,`id_documento_collegato`,`id_ruolo`),
	ADD CONSTRAINT `relazioni_documenti_ibfk_03`     FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_documenti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;


--| 202206099320
ALTER TABLE `relazioni_documenti_articoli`
	ADD COLUMN   `id_ruolo` int(11) DEFAULT NULL AFTER  `id_documenti_articolo_collegato` ,
 	ADD KEY `id_ruolo` (`id_ruolo`), 
	ADD UNIQUE KEY `unico` (`id_documenti_articolo`,`id_documenti_articolo_collegato`,`id_ruolo`),
	ADD CONSTRAINT `relazioni_documenti_articoli_ibfk_03`     FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_documenti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;


--| 202206099330
CREATE OR REPLACE VIEW relazioni_documenti_articoli_view AS
	SELECT
		relazioni_documenti_articoli.id,
		relazioni_documenti_articoli.id_documenti_articolo,
		relazioni_documenti_articoli.id_documenti_articolo_collegato,
		relazioni_documenti_articoli.id_ruolo,
		ruoli_documenti.nome AS ruolo,
		concat( relazioni_documenti_articoli.id_documenti_articolo,' - ', relazioni_documenti_articoli.id_documenti_articolo_collegato, concat_ws(' ', ruoli_documenti.nome ) ) AS __label__
	FROM relazioni_documenti_articoli
		LEFT JOIN ruoli_documenti ON ruoli_documenti.id = relazioni_documenti_articoli.id_ruolo
;

--| 202206099340
CREATE OR REPLACE VIEW relazioni_documenti_view AS
	SELECT
		relazioni_documenti.id,
		relazioni_documenti.id_documento,
		relazioni_documenti.id_documento_collegato,
		relazioni_documenti.id_ruolo,
		ruoli_documenti.nome AS ruolo,
		concat( relazioni_documenti.id_documento,' - ', relazioni_documenti.id_documento_collegato, concat_ws(' ', ruoli_documenti.nome ) ) AS __label__
	FROM relazioni_documenti
		LEFT JOIN ruoli_documenti ON ruoli_documenti.id = relazioni_documenti.id_ruolo
;

--| 202206099350
REPLACE INTO `ruoli_documenti` (`id`, `id_genitore`, `nome`, `html_entity`, `font_awesome`, `se_xml`, `se_documenti`, `se_documenti_articoli`, `se_conferma`, `se_consuntivo`, `se_evasione`) VALUES
(1,	NULL,	'conferma',	NULL,	NULL,	NULL,	1,	1,	1,	NULL,	NULL),
(2,	NULL,	'consuntivo',	NULL,	NULL,	NULL,	1,	1,	NULL,	1,	NULL),
(3,	NULL,	'evasione',	NULL,	NULL,	NULL,	1,	1,	NULL,	NULL,	1);


--| 202206099355
ALTER TABLE `prodotti`
DROP CONSTRAINT `prodotti_ibfk_04_nofollow`,
DROP KEY `indice`;

--| 202206099360
ALTER TABLE `prodotti`
DROP FOREIGN KEY  `prodotti_ibfk_04_nofollow`,
DROP KEY `indice`;

--| 202206099365
ALTER TABLE `prodotti` 
	DROP COLUMN `id_progetto`,
	ADD KEY `indice` (`id`,`id_tipologia`,`id_marchio`,`id_produttore`,`nome`,`codice_produttore`);

--| 202206099370
CREATE OR REPLACE VIEW `prodotti_view` AS
	SELECT
		prodotti.id,
		prodotti.id_tipologia,
		tipologie_prodotti.nome AS tipologia,
		tipologie_prodotti.se_prodotto,
		tipologie_prodotti.se_servizio,
		prodotti.nome,
		prodotti.id_marchio,
		marchi.nome AS marchio,
		prodotti.id_produttore,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS produttore,
		prodotti.codice_produttore,
		group_concat( DISTINCT categorie_prodotti_path( prodotti_categorie.id_categoria ) SEPARATOR ' | ' ) AS categorie,
		prodotti.id_sito,
		prodotti.template,
		prodotti.schema_html,
		prodotti.tema_css,
		prodotti.se_sitemap,
		prodotti.se_cacheable,
		prodotti.id_account_inserimento,
		prodotti.id_account_aggiornamento,
		concat_ws(
			' ',
			prodotti.id,
			prodotti.nome
		) AS __label__
	FROM prodotti
		LEFT JOIN tipologie_prodotti ON tipologie_prodotti.id = prodotti.id_tipologia
		LEFT JOIN marchi ON marchi.id = prodotti.id_marchio
		LEFT JOIN anagrafica AS a1 ON a1.id = prodotti.id_produttore
		LEFT JOIN prodotti_categorie ON prodotti_categorie.id_prodotto = prodotti.id
	GROUP BY prodotti.id
;

--| 202206099380
ALTER TABLE `progetti` 
    ADD COLUMN `id_articolo` char(32) DEFAULT NULL AFTER `id_ranking`,
    ADD COLUMN `id_prodotto` char(32) DEFAULT NULL AFTER `id_articolo`,
	ADD COLUMN `id_periodo` int(11) DEFAULT NULL AFTER `id_prodotto`,
	ADD KEY `id_articolo` (`id_articolo`), 
	ADD KEY `id_prodotto` (`id_prodotto`),
	ADD KEY `id_periodo` (`id_periodo`),  
    ADD CONSTRAINT `progetti_ibfk_06_nofollow`    FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `progetti_ibfk_07_nofollow`    FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `progetti_ibfk_08_nofollow`    FOREIGN KEY (`id_periodo`) REFERENCES `periodi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202206099390
ALTER TABLE `risorse` 
    ADD COLUMN `id_articolo` char(32) DEFAULT NULL AFTER `id_testata`,
    ADD COLUMN `id_prodotto` char(32) DEFAULT NULL AFTER `id_articolo`,
	ADD KEY `id_articolo` (`id_articolo`), 
	ADD KEY `id_prodotto` (`id_prodotto`), 
    ADD CONSTRAINT `risorse_ibfk_02_nofollow`    FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `risorse_ibfk_03_nofollow`    FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202206099400
CREATE OR REPLACE VIEW `progetti_view` AS
	SELECT
		progetti.id,
		progetti.id_tipologia,
		tipologie_progetti_path( tipologie_progetti.id ) AS tipologia,
		progetti.id_pianificazione,
		progetti.id_cliente,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS cliente,
		progetti.id_indirizzo,
		progetti.id_ranking,
		ranking.nome AS ranking,
		progetti.id_articolo,
		progetti.id_prodotto,
		progetti.id_periodo,
		progetti.nome,
        progetti.id_sito,
		progetti.template,
		progetti.schema_html,
		progetti.tema_css,
		progetti.se_sitemap,
		progetti.se_cacheable,
		progetti.entrate_previste,
		progetti.ore_previste,
		progetti.costi_previsti,
		progetti.entrate_accettazione,
		progetti.data_accettazione,
		progetti.data_chiusura,
		progetti.entrate_totali,
		progetti.uscite_totali,
		progetti.data_archiviazione,
		group_concat( DISTINCT categorie_progetti_path( progetti_categorie.id_categoria ) SEPARATOR ' | ' ) AS categorie,
		progetti.id_account_inserimento,
		progetti.id_account_aggiornamento,
		concat_ws(
			' ',
			progetti.id,
			progetti.nome,
			' cliente ',
			coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' )
		) AS __label__
	FROM progetti
		LEFT JOIN anagrafica AS a1 ON a1.id = progetti.id_cliente
		LEFT JOIN tipologie_progetti ON tipologie_progetti.id = progetti.id_tipologia
		LEFT JOIN progetti_categorie ON progetti_categorie.id_progetto = progetti.id
		LEFT JOIN ranking ON ranking.id = progetti.id_ranking
	GROUP BY progetti.id
;

--| 202206099410
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
		risorse.id_articolo,
		risorse.id_prodotto,
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

--| 202206099420
ALTER TABLE `tipologie_todo` DROP KEY `indice`; 

--| 202206099430
ALTER TABLE `tipologie_todo` 
	ADD COLUMN   `se_agenda` int(1) DEFAULT NULL after `font_awesome`,
	ADD KEY `se_agenda` (`se_agenda`),
  	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`se_agenda`);

--| 202206099440
CREATE OR REPLACE VIEW `tipologie_todo_view` AS
	SELECT
		tipologie_todo.id,
		tipologie_todo.id_genitore,
		tipologie_todo.ordine,
		tipologie_todo.nome,
		tipologie_todo.html_entity,
		tipologie_todo.font_awesome,
		tipologie_todo.se_agenda,
		tipologie_todo.id_account_inserimento,
		tipologie_todo.id_account_aggiornamento,
		tipologie_todo_path( tipologie_todo.id ) AS __label__
	FROM tipologie_todo
;  

--| FINE
