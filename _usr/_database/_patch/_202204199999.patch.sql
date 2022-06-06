--
-- PATCH
--

--| 202204190010
CREATE OR REPLACE VIEW `contratti_view` AS
	SELECT
		contratti.id,
		contratti.id_tipologia,
        tipologie_contratti.nome AS tipologia,
		contratti.id_emittente,
		coalesce(a1.soprannome,a1.denominazione, concat_ws(' ', coalesce(a1.cognome, ''),coalesce(a1.nome, '') ),'') AS emittente,
		contratti.id_destinatario,
		coalesce(a2.soprannome,a2.denominazione, concat_ws(' ', coalesce(a2.cognome, ''),coalesce(a2.nome, '') ),'') AS destinatario,
		contratti.id_progetto,
		progetti.nome AS progetto,
		contratti.nome,
		contratti.id_account_inserimento,
		contratti.id_account_aggiornamento,
		concat( contratti.nome , ' - ', tipologie_contratti.nome )AS __label__
	FROM contratti
        LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
        LEFT JOIN anagrafica AS a1 ON a1.id = contratti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = contratti.id_destinatario
        LEFT JOIN progetti ON progetti.id = contratti.id_progetto
;

--| 202204190020
CREATE OR REPLACE VIEW `__report_iscritti_corsi__` AS
SELECT
	anagrafica.id AS id_anagrafica,
	coalesce(anagrafica.soprannome,anagrafica.denominazione, concat_ws(' ', coalesce(anagrafica.cognome, ''),coalesce(anagrafica.nome, '') ),'') AS anagrafica,
	contratti.id_progetto,
	rinnovi.data_inizio,
	rinnovi.data_fine,
	rinnovi.id_contratto
FROM anagrafica	
INNER JOIN contratti ON contratti.id_destinatario = anagrafica.id
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
INNER JOIN contratti ON contratti.id_destinatario = anagrafica.id
LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
INNER JOIN rinnovi ON rinnovi.id_contratto = contratti.id
INNER JOIN relazioni_progetti ON relazioni_progetti.id_progetto = contratti.id_progetto
WHERE tipologie_contratti.se_iscrizione = 1;

--| 202204190060
CREATE TABLE IF NOT EXISTS `ruoli_progetti` (
  `id` int(11) NOT NULL,
  `nome` char(128) COLLATE utf8_general_ci NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_sottoprogetto`int(1) DEFAULT NULL,
  `se_proseguimento` int(1) DEFAULT NULL,
  `se_sostituto` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202204190070
ALTER TABLE `ruoli_progetti`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`nome`),
	ADD KEY `se_sottoprogetto` (`se_sottoprogetto`),
	ADD KEY `se_proseguimento` (`se_proseguimento`),
	ADD KEY `se_sostituto` (`se_sostituto`), 
	ADD KEY `indice` (`id`,`nome`,`se_sottoprogetto`,`se_proseguimento`,`se_sostituto`);

--| 202204190080
ALTER TABLE `ruoli_progetti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202204190090
REPLACE INTO `ruoli_progetti` (`id`, `nome`, `se_sottoprogetto`, `se_proseguimento`, `se_sostituto`) VALUES
(1,	    'proseguimento',	    NULL,	    1,	    NULL),
(2,	    'bundle',	    1,	NULL,	    NULL);

--| 202204190100
CREATE OR REPLACE VIEW ruoli_progetti_view AS
	SELECT
		ruoli_progetti.id,
		ruoli_progetti.nome,
		ruoli_progetti.html_entity,
		ruoli_progetti.font_awesome,
		ruoli_progetti.se_sottoprogetto,
		ruoli_progetti.se_proseguimento,
		ruoli_progetti.se_sostituto,
	 	ruoli_progetti.nome AS __label__
	FROM ruoli_progetti
;

--| 202204190110
ALTER TABLE relazioni_progetti DROP KEY  `unico` ;

--| 202204190120
ALTER TABLE relazioni_progetti
	ADD COLUMN 	`id_ruolo` int(11) DEFAULT NULL AFTER id_progetto,
	ADD KEY `id_ruolo` (`id_ruolo`),
	ADD UNIQUE KEY `unico` (`id_progetto`,`id_progetto_collegato`,`id_ruolo`),ADD CONSTRAINT `relazioni_progetti_ibfk_03_nofollow` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202204190130
CREATE OR REPLACE VIEW relazioni_progetti_view AS
	SELECT
	relazioni_progetti.id,
	relazioni_progetti.id_progetto,
	relazioni_progetti.id_progetto_collegato,
	relazioni_progetti.id_ruolo,
	ruoli_progetti.nome AS ruolo,
	concat( relazioni_progetti.id_progetto,' - ', relazioni_progetti.id_progetto_collegato) AS __label__
	FROM relazioni_progetti
	LEFT JOIN ruoli_progetti ON ruoli_progetti.id = relazioni_progetti.id_ruolo
;

--| 202204190140
ALTER TABLE relazioni_anagrafica DROP KEY  `unico` ;

--| 202204190150
ALTER TABLE relazioni_anagrafica
	ADD COLUMN 	`id_ruolo` int(11) DEFAULT NULL AFTER id_anagrafica,
	ADD KEY `id_ruolo` (`id_ruolo`),
	ADD UNIQUE KEY `unico` (`id_anagrafica`,`id_anagrafica_collegata`,`id_ruolo`),
	ADD CONSTRAINT `relazioni_anagrafica_ibfk_03_nofollow` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202204190160
CREATE OR REPLACE VIEW relazioni_anagrafica_view AS
	SELECT
	relazioni_anagrafica.id,
	relazioni_anagrafica.id_ruolo,
	ruoli_anagrafica.nome AS ruolo,
	relazioni_anagrafica.id_anagrafica,
	relazioni_anagrafica.id_anagrafica_collegata,
	concat( relazioni_anagrafica.id_anagrafica,' - ', relazioni_anagrafica.id_anagrafica_collegata) AS __label__
	FROM relazioni_anagrafica
	LEFT JOIN ruoli_anagrafica ON ruoli_anagrafica.id = relazioni_anagrafica.id_ruolo
;

--| 202204190170
CREATE OR REPLACE VIEW `__report_iscritti_corsi__` AS
SELECT
	anagrafica.id AS id_anagrafica,
	coalesce(anagrafica.soprannome,anagrafica.denominazione, concat_ws(' ', coalesce(anagrafica.cognome, ''),coalesce(anagrafica.nome, '') ),'') AS anagrafica,
	contratti.id_progetto,
	rinnovi.data_inizio,
	rinnovi.data_fine,
	rinnovi.id_contratto
FROM anagrafica	
INNER JOIN contratti ON contratti.id_destinatario = anagrafica.id
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
INNER JOIN contratti ON contratti.id_destinatario = anagrafica.id
LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
INNER JOIN rinnovi ON rinnovi.id_contratto = contratti.id
INNER JOIN relazioni_progetti ON relazioni_progetti.id_progetto = contratti.id_progetto
INNER JOIN ruoli_progetti ON ruoli_progetti.id = relazioni_progetti.id_ruolo
WHERE tipologie_contratti.se_iscrizione = 1 AND ruoli_progetti.se_sottoprogetto = 1;

--| 202204190180
CREATE OR REPLACE VIEW `pagamenti_view` AS
	SELECT
		pagamenti.id,
		pagamenti.id_tipologia,
		pagamenti.id_modalita_pagamento,
		concat(modalita_pagamento.codice, ' - ' ,modalita_pagamento.nome) AS modalita_pagamento,
		tipologie_pagamenti.nome AS tipologia,
		pagamenti.ordine,
		pagamenti.nome,
		pagamenti.note,
		pagamenti.note_pagamento,
		pagamenti.id_documento,
        concat(
			tipologie_documenti.nome,
			' ',
			documenti.numero,
			'/',
			year( documenti.data ),
			' del ',
			documenti.data
		) AS documento,
		pagamenti.id_mastro_provenienza,
		m1.nome AS mastro_provenienza,
		pagamenti.id_mastro_destinazione,
		m2.nome AS mastro_destinazione,
		documenti.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		documenti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		pagamenti.id_iban,
		iban.iban AS iban,
		pagamenti.importo_netto_totale,
		pagamenti.id_iva,
		iva.nome AS iva,
		pagamenti.id_listino,
		listini.nome AS listino,
		pagamenti.timestamp_scadenza,
		from_unixtime( pagamenti.timestamp_scadenza, '%Y-%m-%d' ) AS data_ora_scadenza,
		pagamenti.timestamp_pagamento,
		from_unixtime( pagamenti.timestamp_pagamento, '%Y-%m-%d' ) AS data_ora_pagamento,
		pagamenti.id_account_inserimento,
		pagamenti.id_account_aggiornamento,
		pagamenti.nome AS __label__
	FROM pagamenti
		LEFT JOIN tipologie_pagamenti ON tipologie_pagamenti.id = pagamenti.id_tipologia
		LEFT JOIN mastri AS m1 ON m1.id = pagamenti.id_mastro_provenienza
		LEFT JOIN mastri AS m2 ON m2.id = pagamenti.id_mastro_destinazione
		LEFT JOIN iva ON iva.id = pagamenti.id_iva
		LEFT JOIN listini ON listini.id = pagamenti.id_listino
		LEFT JOIN modalita_pagamento ON modalita_pagamento.id = pagamenti.id_modalita_pagamento
		LEFT JOIN documenti ON documenti.id = pagamenti.id_documento
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
		LEFT JOIN anagrafica AS a1 ON a1.id = documenti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = documenti.id_destinatario
		LEFT JOIN iban ON iban.id = pagamenti.id_iban
	WHERE
		tipologie_documenti.se_fattura = 1
		OR
		tipologie_documenti.se_nota_credito = 1
		OR
		tipologie_documenti.se_ricevuta = 1
		OR
		tipologie_documenti.se_pro_forma = 1
;

--| FINE FILE

