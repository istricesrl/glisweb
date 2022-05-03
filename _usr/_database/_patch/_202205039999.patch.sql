--
-- PATCH
--

--| 202205030010
ALTER TABLE `progetti_certificazioni` 
    ADD COLUMN `ordine` int(11) DEFAULT NULL AFTER  `id_certificazione`,
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_progetto`,`id_certificazione`), 
	ADD KEY `id_progetto` (`id_progetto`), 
	ADD KEY `id_certificazione` (`id_certificazione`), 
	ADD KEY `ordine` (`ordine`),
	ADD KEY `nome` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_progetto`,`id_certificazione`,`ordine`,`nome`);

--| 202205030020
ALTER TABLE `progetti_certificazioni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202205030030
ALTER TABLE `progetti_certificazioni`
    ADD CONSTRAINT `progetti_certificazioni_ibfk_01`             FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `progetti_certificazioni_ibfk_02_nofollow`    FOREIGN KEY (`id_certificazionE`) REFERENCES `certificazioni` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `progetti_certificazioni_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `progetti_certificazioni_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202205030040
CREATE OR REPLACE VIEW progetti_certificazioni_view AS
	SELECT
		progetti_certificazioni.id,
		progetti_certificazioni.id_progetto,
		progetti.nome AS progetto,
		progetti_certificazioni.id_certificazione,
		certificazioni.nome AS certificazione,
		progetti_certificazioni.ordine,
		progetti_certificazioni.nome,
		progetti_certificazioni.se_richiesta,
		progetti_certificazioni.id_account_inserimento,
		progetti_certificazioni.id_account_aggiornamento,
 		concat_ws(
			' ',
			progetti.nome,
			certificazioni.nome
		) AS __label__
	FROM progetti_certificazioni
		LEFT JOIN progetti ON progetti.id = progetti_certificazioni.id_progetto
		LEFT JOIN certificazioni ON certificazioni.id = progetti_certificazioni.id_certificazione
;


--| 202205030050
ALTER TABLE `categorie_progetti` 
  ADD COLUMN `se_fascia` int(1) DEFAULT NULL AFTER `se_classe`, 
  ADD KEY `se_fascia` (`se_fascia`);

--| 202205030060
CREATE OR REPLACE VIEW categorie_progetti_view AS
	SELECT
		categorie_progetti.id,
		categorie_progetti.id_genitore,
		categorie_progetti.ordine,
		categorie_progetti.nome,
		categorie_progetti.template,
		categorie_progetti.schema_html,
		categorie_progetti.tema_css,
		categorie_progetti.se_sitemap,
		categorie_progetti.se_cacheable,
		categorie_progetti.id_sito,
		categorie_progetti.id_pagina,
		categorie_progetti.se_straordinario,
		categorie_progetti.se_ordinario,
		categorie_progetti.se_materia,
		categorie_progetti.se_classe,
		categorie_progetti.se_fascia,
		count( c1.id ) AS figli,
		count( progetti_categorie.id ) AS membri,
		categorie_progetti.id_account_inserimento,
		categorie_progetti.id_account_aggiornamento,
		categorie_progetti_path( categorie_progetti.id ) AS __label__
	FROM categorie_progetti
		LEFT JOIN categorie_progetti AS c1 ON c1.id_genitore = categorie_progetti.id
		LEFT JOIN progetti_categorie ON progetti_categorie.id_categoria = categorie_progetti.id
	GROUP BY categorie_progetti.id
;

--| 202205030100
CREATE OR REPLACE VIEW `__report_iscritti_corsi__` AS
SELECT
	anagrafica.id AS id_anagrafica,
	coalesce(anagrafica.soprannome,anagrafica.denominazione, concat_ws(' ', coalesce(anagrafica.cognome, ''),coalesce(anagrafica.nome, '') ),'') AS anagrafica,
	contratti.id_progetto,
	rinnovi.data_inizio,
	rinnovi.data_fine,
	rinnovi.id_contratto
FROM anagrafica
INNER JOIN contratti_anagrafica ON contratti_anagrafica.id_anagrafica = anagrafica.id	
INNER JOIN contratti ON contratti.id = contratti_anagrafica.id_contratto 
LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
INNER JOIN rinnovi ON rinnovi.id_contratto = contratti.id
INNER JOIN progetti ON progetti.id = contratti.id_progetto
WHERE tipologie_contratti.se_iscrizione = 1  
UNION
SELECT
	anagrafica.id AS id_anagrafica,
	coalesce(anagrafica.soprannome,anagrafica.denominazione, concat_ws(' ', coalesce(anagrafica.cognome, ''),coalesce(anagrafica.nome, '') ),'') AS anagrafica,
	relazioni_progetti.id_progetto_collegato AS id_progetto,
	rinnovi.data_inizio,
	rinnovi.data_fine,
	rinnovi.id_contratto
FROM anagrafica
INNER JOIN contratti_anagrafica ON contratti_anagrafica.id_anagrafica = anagrafica.id	
INNER JOIN contratti ON contratti.id = contratti_anagrafica.id_contratto 
LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
INNER JOIN rinnovi ON rinnovi.id_contratto = contratti.id
INNER JOIN relazioni_progetti ON relazioni_progetti.id_progetto = contratti.id_progetto
INNER JOIN ruoli_progetti ON ruoli_progetti.id = relazioni_progetti.id_ruolo
WHERE tipologie_contratti.se_iscrizione = 1 AND ruoli_progetti.se_sottoprogetto = 1;

--| FINE FILE
