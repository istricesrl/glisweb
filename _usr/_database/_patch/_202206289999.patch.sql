-- 
-- PATCH
--

--| 202206280015
ALTER TABLE pianificazioni
 ADD COLUMN `model_id_anagrafica` int(11) DEFAULT NULL AFTER `entita`,
 ADD COLUMN `model_id_anagrafica_programmazione` int(11) DEFAULT  NULL AFTER `model_id_anagrafica`,
 ADD COLUMN `model_id_articolo` char(32) DEFAULT  NULL AFTER `model_id_anagrafica_programmazione`,
 ADD COLUMN `model_id_attivita` int(11) DEFAULT  NULL AFTER `model_id_articolo`,
 ADD COLUMN `model_id_causale` int(11) DEFAULT  NULL AFTER `model_id_attivita`,
 ADD COLUMN `model_id_cliente` int(11) DEFAULT  NULL AFTER `model_id_causale`,
 ADD COLUMN `model_id_collo` int(11) DEFAULT  NULL AFTER `model_id_cliente`,
 ADD COLUMN `model_id_condizione_pagamento` int(11) DEFAULT  NULL AFTER `model_id_collo`,
 ADD COLUMN `model_id_contatto` int(11) DEFAULT  NULL AFTER `model_id_condizione_pagamento`,
 ADD COLUMN `model_id_coupon` char(32) DEFAULT  NULL AFTER `model_id_contatto`,
 ADD COLUMN `model_id_destinatario` int(11) DEFAULT  NULL AFTER `model_id_coupon`,
 ADD COLUMN `model_id_documento` int(11) DEFAULT  NULL AFTER `model_id_destinatario`, 
 ADD COLUMN `model_id_emittente` int(11) DEFAULT  NULL AFTER `model_id_documento`,
 ADD COLUMN `model_id_genitore` int(11) DEFAULT  NULL AFTER `model_id_emittente`,
 ADD COLUMN `model_id_iban` int(11) DEFAULT  NULL AFTER `model_id_genitore`,
 ADD COLUMN `model_id_indirizzo` int(11) DEFAULT  NULL AFTER `model_id_iban`,
 ADD COLUMN `model_id_immobile` int(11) DEFAULT  NULL AFTER `model_id_indirizzo`,
 ADD COLUMN `model_id_licenza` int(11) DEFAULT  NULL AFTER `model_id_immobile`,
 ADD COLUMN `model_id_listino` int(11) DEFAULT  NULL AFTER `model_id_licenza`,
 ADD COLUMN `model_id_mastro_destinazione` int(11) DEFAULT NULL AFTER model_id_luogo,
 ADD COLUMN `model_id_mastro_provenienza` int(11) DEFAULT  NULL AFTER `model_id_mastro_destinazione`,
 ADD COLUMN `model_id_matricola` int(11) DEFAULT  NULL AFTER `model_id_mastro_provenienza`,
 ADD COLUMN `model_id_modalita_pagamento` int(11) DEFAULT  NULL AFTER `model_id_matricola`,
 ADD COLUMN `model_id_prodotto` char(32) DEFAULT  NULL AFTER `model_id_modalita_pagamento`,
 ADD COLUMN `model_id_progetto` char(32) DEFAULT  NULL AFTER `model_id_prodotto`,
 ADD COLUMN `model_id_reparto` int(11) DEFAULT  NULL AFTER `model_id_progetto`,
 ADD COLUMN `model_id_sede_destinatario` int(11) DEFAULT  NULL AFTER `model_id_reparto`,
 ADD COLUMN `model_id_sede_emittente` int(11) DEFAULT  NULL AFTER `model_id_sede_destinatario`,
 ADD COLUMN `model_id_tipologia` int(11) DEFAULT  NULL AFTER `model_id_sede_emittente`,
 ADD COLUMN `model_id_todo` int(11) DEFAULT  NULL AFTER `model_id_tipologia`,
 ADD COLUMN `model_id_trasportatore` int(11) DEFAULT  NULL AFTER `model_id_todo`,
 ADD COLUMN `model_id_udm` int(11) DEFAULT  NULL AFTER `model_id_trasportatore`,
 ADD COLUMN `model_anno_programmazione` year(4) DEFAULT  NULL AFTER `model_id_udm`,
 ADD COLUMN `model_codice` char(64) DEFAULT  NULL AFTER `model_anno_programmazione`,
 ADD COLUMN `model_data` date DEFAULT  NULL AFTER `model_codice`,
 ADD COLUMN `model_data_fine` date DEFAULT  NULL AFTER `model_data`,
 ADD COLUMN `model_data_inizio` date DEFAULT  NULL AFTER `model_data_fine`,
 ADD COLUMN `model_data_programmazione` date DEFAULT  NULL AFTER `model_data_inizio`,
 ADD COLUMN `model_esigibilita`	enum('I','D','S') DEFAULT  NULL AFTER `model_data_programmazione`,      
 ADD COLUMN `model_importo_netto_totale` decimal(9,2) DEFAULT  NULL AFTER `model_esigibilita`,
 ADD COLUMN `model_nome` char(255) DEFAULT  NULL AFTER `model_importo_netto_totale`,
 ADD COLUMN `model_note` text DEFAULT  NULL AFTER `model_nome`,
 ADD COLUMN `model_note_programmazione` text AFTER `model_note`,
 ADD COLUMN `model_numero` char(32) DEFAULT  NULL AFTER `model_note_programmazione`,
 ADD COLUMN `model_ore_programmazione` decimal(5,2) DEFAULT NULL AFTER model_ora_fine_programmazione,
 ADD COLUMN `model_porto` enum('franco','assegnato','-') DEFAULT  NULL AFTER `model_ore_programmazione`,
 ADD COLUMN `model_quantita` decimal(9,2) DEFAULT  NULL AFTER `model_porto`,
 ADD COLUMN `model_riferimento` char(255) DEFAULT  NULL AFTER `model_quantita`, 
 ADD COLUMN `model_sconto_percentuale` decimal(9,2) DEFAULT  NULL AFTER `model_riferimento`,
 ADD COLUMN `model_sconto_valore` decimal(9,2) DEFAULT  NULL AFTER `model_sconto_percentuale`,
 ADD COLUMN `model_se_automatico` int(1) DEFAULT  NULL AFTER `model_sconto_valore`,
 ADD COLUMN `model_sezionale` char(32) DEFAULT  NULL AFTER `model_se_automatico`,
 ADD COLUMN `model_settimana_programmazione` int(11) DEFAULT  NULL AFTER `model_sezionale`,
 ADD COLUMN `model_specifiche` char(255) DEFAULT  NULL AFTER `model_settimana_programmazione`,
 ADD COLUMN `model_timestamp_scadenza` int(11) DEFAULT  NULL AFTER `model_specifiche`;


--| 202206280020
ALTER TABLE pianificazioni
 ADD KEY `model_id_anagrafica`  (`model_id_anagrafica`),
 ADD KEY `model_id_anagrafica_programmazione`  (`model_id_anagrafica_programmazione`),
 ADD KEY `model_id_articolo`  (`model_id_articolo`),
 ADD KEY `model_id_attivita`  (`model_id_attivita`),
 ADD KEY `model_id_cliente`  (`model_id_cliente`),
 ADD KEY `model_id_condizione_pagamento`  (`model_id_condizione_pagamento`),
 ADD KEY `model_id_contatto`  (`model_id_contatto`),
 ADD KEY `model_id_coupon`  (`model_id_coupon`),
 ADD KEY `model_id_destinatario`  (`model_id_destinatario`),
 ADD KEY `model_id_documento`  (`model_id_documento`), 
 ADD KEY `model_id_emittente`  (`model_id_emittente`),
 ADD KEY `model_id_genitore`  (`model_id_genitore`),
 ADD KEY `model_id_iban`  (`model_id_iban`),
 ADD KEY `model_id_indirizzo`  (`model_id_indirizzo`),
 ADD KEY `model_id_immobile`  (`model_id_immobile`),
 ADD KEY `model_id_licenza`  (`model_id_licenza`),
 ADD KEY `model_id_listino`  (`model_id_listino`),
 ADD KEY `model_id_mastro_destinazione`  (`model_id_mastro_destinazione`),
 ADD KEY `model_id_mastro_provenienza`  (`model_id_mastro_provenienza`),
 ADD KEY `model_id_matricola`  (`model_id_matricola`),
 ADD KEY `model_id_modalita_pagamento`  (`model_id_modalita_pagamento`),
 ADD KEY `model_id_prodotto`  (`model_id_prodotto`),
 ADD KEY `model_id_progetto`  (`model_id_progetto`),
 ADD KEY `model_id_reparto`  (`model_id_reparto`),
 ADD KEY `model_id_tipologia`  (`model_id_tipologia`),
 ADD KEY `model_id_todo`  (`model_id_todo`),
 ADD KEY `model_id_trasportatore`  (`model_id_trasportatore`),
 ADD KEY `model_id_udm`  (`model_id_udm`),
 ADD KEY `model_anno_programmazione`  (`model_anno_programmazione`),
 ADD KEY `model_codice`  (`model_codice`),
 ADD KEY `model_data`  (`model_data`),
 ADD KEY `model_data_fine`  (`model_data_fine`),
 ADD KEY `model_data_inizio`  (`model_data_inizio`),
 ADD KEY `model_data_programmazione`  (`model_data_programmazione`),
 ADD KEY `model_importo_netto_totale`  (`model_importo_netto_totale`),
 ADD KEY `model_nome`  (`model_nome`),
 ADD KEY `model_ore_programmazione` (`model_ore_programmazione`),
 ADD KEY `model_quantita`  (`model_quantita`),
 ADD KEY `model_sconto_percentuale`  (`model_sconto_percentuale`),
 ADD KEY `model_sconto_valore`  (`model_sconto_valore`),
 ADD KEY `model_se_automatico`  (`model_se_automatico`),
 ADD KEY `model_sezionale`  (`model_sezionale`),
 ADD KEY `model_settimana_programmazione`  (`model_settimana_programmazione`),
 ADD KEY  `model_timestamp_scadenza`  (`model_timestamp_scadenza`);

--| 202206280031
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
		pianificazioni.model_id_anagrafica,
		pianificazioni.model_id_anagrafica_programmazione,
		pianificazioni.model_id_articolo,
		pianificazioni.model_id_attivita,
		pianificazioni.model_id_causale,
		pianificazioni.model_id_cliente,
		pianificazioni.model_id_collo,
		pianificazioni.model_id_condizione_pagamento,
		pianificazioni.model_id_contatto,
		pianificazioni.model_id_coupon,
		pianificazioni.model_id_destinatario,
		pianificazioni.model_id_documento, 
		pianificazioni.model_id_emittente,
		pianificazioni.model_id_genitore,
		pianificazioni.model_id_iban,
		pianificazioni.model_id_indirizzo,
		pianificazioni.model_id_immobile,
		pianificazioni.model_id_licenza,
		pianificazioni.model_id_listino,
		pianificazioni.model_id_mastro_destinazione,
		pianificazioni.model_id_mastro_provenienza,
		pianificazioni.model_id_matricola,
		pianificazioni.model_id_modalita_pagamento,
		pianificazioni.model_id_prodotto,
		pianificazioni.model_id_progetto,
		pianificazioni.model_id_reparto,
		pianificazioni.model_id_sede_destinatario,
		pianificazioni.model_id_sede_emittente,
		pianificazioni.model_id_tipologia,
		pianificazioni.model_id_todo,
		pianificazioni.model_id_trasportatore,
		pianificazioni.model_id_udm,
		pianificazioni.model_anno_programmazione,
		pianificazioni.model_codice,
		pianificazioni.model_data,
		pianificazioni.model_data_fine,
		pianificazioni.model_data_inizio,
		pianificazioni.model_data_programmazione,
		pianificazioni.model_esigibilita,      
		pianificazioni.model_importo_netto_totale,
		pianificazioni.model_nome,
		pianificazioni.model_note,
		pianificazioni.model_note_programmazione,
		pianificazioni.model_numero,
		pianificazioni.model_ore_programmazione,
		pianificazioni.model_porto,
		pianificazioni.model_quantita,
		pianificazioni.model_riferimento, 
		pianificazioni.model_sconto_percentuale,
		pianificazioni.model_sconto_valore,
		pianificazioni.model_se_automatico,
		pianificazioni.model_sezionale,
		pianificazioni.model_settimana_programmazione,
		pianificazioni.model_specifiche,
		pianificazioni.model_timestamp_scadenza,
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

--| 202206280040
ALTER TABLE `documenti`
	ADD COLUMN `id_pianificazione` int(11) DEFAULT NULL AFTER `id_immobile`,
	ADD KEY  `id_pianificazione`  (`id_pianificazione`),
    	ADD CONSTRAINT `documenti_ibfk_13_nofollow` FOREIGN KEY (`id_pianificazione`) REFERENCES `pianificazioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202206280050
ALTER TABLE `documenti_articoli`
	ADD COLUMN `id_pianificazione` int(11) DEFAULT NULL AFTER `note`,
	ADD KEY  `id_pianificazione`  (`id_pianificazione`),
    	ADD CONSTRAINT `documenti_articoli_ibfk_18_nofollow` FOREIGN KEY (`id_pianificazione`) REFERENCES `pianificazioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202206280060
ALTER TABLE `rinnovi`
	ADD COLUMN `id_pianificazione` int(11) DEFAULT NULL AFTER `id_progetto`,
	ADD KEY  `id_pianificazione`  (`id_pianificazione`),
	ADD CONSTRAINT `rinnovi_ibfk_05_nofollow` FOREIGN KEY (`id_pianificazione`) REFERENCES `pianificazioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;
	    
--| 202206280070
ALTER TABLE `attivita`
	ADD COLUMN `id_pianificazione` int(11) DEFAULT NULL AFTER `id_immobile`,
	ADD KEY  `id_pianificazione`  (`id_pianificazione`),
	ADD CONSTRAINT `attivita_ibfk_14_nofollow` FOREIGN KEY (`id_pianificazione`) REFERENCES `pianificazioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202206280080
ALTER TABLE `pagamenti`
	ADD COLUMN `id_pianificazione` int(11) DEFAULT NULL AFTER `id_listino`,
	ADD KEY  `id_pianificazione`  (`id_pianificazione`),
	ADD CONSTRAINT `pagamenti_ibfk_09_nofollow` FOREIGN KEY (`id_pianificazione`) REFERENCES `pianificazioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;
	    
--| 202206280090
ALTER TABLE `macro`
	ADD COLUMN `id_pianificazione` int(11) DEFAULT NULL AFTER `id_categoria_progetti`,
	ADD KEY  `id_pianificazione`  (`id_pianificazione`),
	ADD CONSTRAINT `macro_ibfk_11` FOREIGN KEY (`id_pianificazione`) REFERENCES `pianificazioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202206280100
CREATE OR REPLACE VIEW `documenti_view` AS
    SELECT
		documenti.id,
		documenti.id_tipologia,
		tipologie_documenti.nome AS tipologia,
		documenti.numero,
		documenti.sezionale,
		documenti.data,
		documenti.nome,
		documenti.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		documenti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		documenti.id_condizione_pagamento,
		condizioni_pagamento.codice AS condizione_pagamento,
		documenti.esigibilita, 
		documenti.codice_archivium,
    	documenti.codice_sdi,
		documenti.cig,
		documenti.cup,
		documenti.riferimento,
    	documenti.timestamp_invio,
    	documenti.progressivo_invio,
		documenti.id_coupon,
		documenti.id_mastro_provenienza,
		m1.nome AS mastro_provenienza,
		documenti.id_mastro_destinazione,
		m2.nome AS mastro_destinazione,
		documenti.porto,
		documenti.id_causale,
		documenti.id_trasportatore,
		documenti.id_immobile,
		documenti.id_pianificazione,
		documenti.timestamp_chiusura,
		from_unixtime( documenti.timestamp_chiusura, '%Y-%m-%d %H:%i' ) AS data_ora_chiusura,
		documenti.id_account_inserimento,
		documenti.id_account_aggiornamento,
		concat(
			tipologie_documenti.sigla,
			' ',
			documenti.numero,
			'/',
			year( documenti.data ),
			' del ',
			documenti.data,
			' per ',
			coalesce(
				a2.denominazione,
				concat(
					a2.cognome,
					' ',
					a2.nome
				),
				''
			)
		) AS __label__
    FROM
		documenti
		LEFT JOIN anagrafica AS a1 ON a1.id = documenti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = documenti.id_destinatario
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
		LEFT JOIN condizioni_pagamento ON condizioni_pagamento.id = documenti.id_condizione_pagamento
		LEFT JOIN mastri AS m1 ON m1.id = documenti.id_mastro_provenienza
		LEFT JOIN mastri AS m2 ON m2.id = documenti.id_mastro_destinazione
;

--| 202206280110
CREATE OR REPLACE VIEW `documenti_articoli_view` AS
    SELECT
		documenti_articoli.id,
		documenti_articoli.id_genitore,
		documenti_articoli.id_tipologia,
		tipologie_documenti.nome AS tipologia,
		documenti_articoli.ordine,
		documenti_articoli.id_documento,
        concat(
			tipologie_documenti.sigla,
			' ',
			documenti.numero,
			'/',
			year( documenti.data ),
			' del ',
			documenti.data
		) AS documento,
		documenti_articoli.data,
		documenti_articoli.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		documenti_articoli.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		documenti_articoli.id_reparto,
		documenti_articoli.id_progetto,
		documenti_articoli.id_todo,
		documenti_articoli.id_attivita,
		documenti_articoli.id_articolo,
		udm_riga.sigla AS udm,
				concat_ws(
			' ',
			articoli.id,
			'/',
			prodotti.nome,
			articoli.nome,
			coalesce(
				concat(
					articoli.larghezza, 'x', articoli.lunghezza, 'x', articoli.altezza,
					' ',
					udm_dimensioni.sigla
				),
				concat(
					articoli.peso,
					' ',
					udm_peso.sigla
				),
				concat(
					articoli.volume,
					' ',
					udm_volume.sigla
				),
				concat(
					articoli.capacita,
					' ',
					udm_capacita.sigla
				),
				concat(
					articoli.durata,
					' ',
					udm_durata.sigla
				),
				''
			)
		) AS articolo,
		documenti_articoli.id_prodotto,
		IF( documenti_articoli.id_articolo IS NOT NULL ,prodotti.nome, p.nome ) AS prodotto,
		documenti_articoli.id_mastro_provenienza,
		mastri_path( m1.id ) AS mastro_provenienza,
		documenti_articoli.id_mastro_destinazione,
		mastri_path( m2.id ) AS mastro_destinazione,
		documenti_articoli.id_udm,
		documenti_articoli.quantita,
		documenti_articoli.id_listino,		
		documenti_articoli.id_pianificazione,
		listini.id_valuta,
		valute.utf8 AS valuta,
		documenti_articoli.importo_netto_totale,
		documenti_articoli.sconto_percentuale,
		documenti_articoli.sconto_valore,
		documenti_articoli.id_matricola,
		matricole.matricola AS matricola,
		documenti_articoli.id_collo,
		matricole.data_scadenza,
		documenti_articoli.nome,
		documenti_articoli.id_account_inserimento,
		documenti_articoli.id_account_aggiornamento,
		concat(
			documenti_articoli.data,
			' / ',
			tipologie_documenti.sigla,
			' / ',
			documenti_articoli.quantita,
			' x ',
			documenti_articoli.id_articolo,
			' / ',
			documenti_articoli.nome,
			' / ',
			documenti_articoli.importo_netto_totale,
			' ',
			valute.utf8
		) AS __label__
	FROM
		documenti_articoli
        LEFT JOIN documenti ON documenti.id = documenti_articoli.id_documento
		LEFT JOIN anagrafica AS a1 ON a1.id = documenti_articoli.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = documenti_articoli.id_destinatario
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti_articoli.id_tipologia
		LEFT JOIN listini ON listini.id = documenti_articoli.id_listino
		LEFT JOIN valute ON valute.id = listini.id_valuta
		LEFT JOIN mastri AS m1 ON m1.id = documenti_articoli.id_mastro_provenienza
		LEFT JOIN mastri AS m2 ON m2.id = documenti_articoli.id_mastro_destinazione
		LEFT JOIN matricole ON matricole.id = documenti_articoli.id_matricola
		LEFT JOIN articoli ON articoli.id = documenti_articoli.id_articolo
		LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
		LEFT JOIN prodotti AS p ON p.id = documenti_articoli.id_prodotto
		LEFT JOIN udm AS udm_dimensioni ON udm_dimensioni.id = articoli.id_udm_dimensioni
		LEFT JOIN udm AS udm_peso ON udm_peso.id = articoli.id_udm_peso
		LEFT JOIN udm AS udm_volume ON udm_volume.id = articoli.id_udm_volume
		LEFT JOIN udm AS udm_capacita ON udm_capacita.id = articoli.id_udm_capacita
		LEFT JOIN udm AS udm_durata ON udm_durata.id = articoli.id_udm_durata
		LEFT JOIN udm AS udm_riga ON udm_riga.id = documenti_articoli.id_udm
;

--| 202206280120
CREATE OR REPLACE VIEW `rinnovi_view` AS
	SELECT
		rinnovi.id,
		rinnovi.id_tipologia,
		tipologie_rinnovi.nome AS tipologia,
		rinnovi.id_contratto,
		contratti.nome AS contratto,
		rinnovi.id_licenza,
		licenze.nome AS licenza,
		rinnovi.id_progetto,
		progetti.nome AS progetto,
		rinnovi.data_inizio,
		rinnovi.data_fine,
		rinnovi.codice,
		rinnovi.id_pianificazione,
		rinnovi.id_account_inserimento,
		rinnovi.id_account_aggiornamento,
		concat('rinnovo ', rinnovi.id, ' dal ',CONCAT_WS('-',rinnovi.data_inizio),' al ',CONCAT_WS('-',rinnovi.data_fine)) AS __label__
	FROM rinnovi
		LEFT JOIN tipologie_rinnovi ON tipologie_rinnovi.id = rinnovi.id_tipologia
		LEFT JOIN contratti ON contratti.id = rinnovi.id_contratto 
		LEFT JOIN licenze ON licenze.id = rinnovi.id_licenza 
		LEFT JOIN progetti ON progetti.id = rinnovi.id_progetto
	;

--| 202206280130
ALTER TABLE `attivita_view_static`
	ADD COLUMN `id_pianificazione` int(11) DEFAULT NULL AFTER `id_immobile`;

--| 202206280140
CREATE OR REPLACE VIEW `attivita_view` AS
	SELECT	
		attivita.id,
		attivita.id_tipologia,
		tipologie_attivita.nome AS tipologia,
		attivita.id_cliente,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS cliente,
		attivita.id_indirizzo,
		indirizzi.indirizzo AS indirizzo,
		attivita.id_luogo,
		luoghi_path( attivita.id_luogo ) AS luogo,
		attivita.data_scadenza,
		attivita.ora_scadenza,
		attivita.data_programmazione,
		attivita.ora_inizio_programmazione,
		attivita.ora_fine_programmazione,
		attivita.id_anagrafica_programmazione,
		coalesce( a3.denominazione , concat( a3.cognome, ' ', a3.nome ), '' ) AS anagrafica_programmazione,
		attivita.ore_programmazione,
		attivita.data_attivita,
		day( data_attivita ) as giorno_attivita,
		month( data_attivita ) as mese_attivita,
		year( data_attivita ) as anno_attivita,
		attivita.ora_inizio,
		attivita.latitudine_ora_inizio,
		attivita.longitudine_ora_inizio,
		attivita.ora_fine,
		attivita.latitudine_ora_fine,
		attivita.longitudine_ora_fine,
		attivita.id_anagrafica,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		attivita.ore,
		attivita.nome,
		attivita.id_documento,
		concat(
			tipologie_documenti.sigla,
			' ',
			documenti.numero,
			'/',
			documenti.sezionale,
			' del ',
			documenti.data
		) AS documento,
		attivita.id_progetto,
		progetti.nome AS progetto,
		attivita.id_matricola,
        attivita.id_immobile,
		attivita.id_pianificazione,
		attivita.id_todo,
		todo.nome AS todo,
		attivita.id_mastro_provenienza,
		m1.nome AS mastro_provenienza,
		attivita.id_mastro_destinazione,
		m2.nome AS mastro_destinazione,
		attivita.codice_archivium,
		attivita.token,
		attivita.id_account_inserimento,
		attivita.id_account_aggiornamento,
		concat(
			attivita.nome,
			' / ',
			attivita.ore,
			' / ',
			coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' )
		) AS __label__
	FROM attivita
		LEFT JOIN tipologie_attivita ON tipologie_attivita.id = attivita.id_tipologia
		LEFT JOIN anagrafica AS a1 ON a1.id = attivita.id_anagrafica
		LEFT JOIN anagrafica AS a2 ON a2.id = attivita.id_cliente
		LEFT JOIN anagrafica AS a3 ON a3.id = attivita.id_anagrafica_programmazione
		LEFT JOIN progetti_categorie ON progetti_categorie.id_progetto = attivita.id_progetto
		LEFT JOIN categorie_progetti ON categorie_progetti.id = progetti_categorie.id_categoria
		LEFT JOIN progetti ON progetti.id = attivita.id_progetto
		LEFT JOIN todo ON todo.id = attivita.id_todo
		LEFT JOIN indirizzi ON indirizzi.id = attivita.id_indirizzo
		LEFT JOIN mastri AS m1 ON m1.id = attivita.id_mastro_provenienza
		LEFT JOIN mastri AS m2 ON m2.id = attivita.id_mastro_destinazione
		LEFT JOIN documenti ON documenti.id = attivita.id_documento
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
;

--| 202206280150
TRUNCATE `attivita_view_static`;

--| 202206280160
INSERT INTO `attivita_view_static` SELECT * FROM attivita_view;

--| 202206280170
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
			tipologie_documenti.sigla,
			' ',
			documenti.numero,
			'/',
			year( documenti.data ),
			' del ',
			documenti.data
		) AS documento,
		tipologie_documenti.id AS id_tipologia_documento,
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
		pagamenti.id_pianificazione,
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

--| 202206280180
CREATE OR REPLACE VIEW `macro_view` AS
	SELECT
		macro.id,
		macro.id_pagina,
		macro.id_prodotto,
		macro.id_articolo,
		macro.id_categoria_prodotti,
		macro.id_notizia,
		macro.id_categoria_notizie,
		macro.id_risorsa,
		macro.id_categoria_risorse,
		macro.id_progetto,
		macro.id_categoria_progetti,
		macro.id_pianificazione,
		macro.ordine,
		macro.macro,
		macro.macro AS __label__
	FROM macro
;

--| 202206280190
ALTER TABLE pianificazioni
 ADD COLUMN data_ultimo_oggetto  date DEFAULT NULL AFTER data_elaborazione;
 
--| 202206280200
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
        pianificazioni.data_ultimo_oggetto,
		pianificazioni.giorni_estensione,
		pianificazioni.data_fine,
		pianificazioni.entita,
		pianificazioni.model_id_anagrafica,
		pianificazioni.model_id_anagrafica_programmazione,
		pianificazioni.model_id_articolo,
		pianificazioni.model_id_attivita,
		pianificazioni.model_id_causale,
		pianificazioni.model_id_cliente,
		pianificazioni.model_id_collo,
		pianificazioni.model_id_condizione_pagamento,
		pianificazioni.model_id_contatto,
		pianificazioni.model_id_coupon,
		pianificazioni.model_id_destinatario,
		pianificazioni.model_id_documento, 
		pianificazioni.model_id_emittente,
		pianificazioni.model_id_genitore,
		pianificazioni.model_id_iban,
		pianificazioni.model_id_indirizzo,
		pianificazioni.model_id_immobile,
		pianificazioni.model_id_licenza,
		pianificazioni.model_id_listino,
		pianificazioni.model_id_mastro_destinazione,
		pianificazioni.model_id_mastro_provenienza,
		pianificazioni.model_id_matricola,
		pianificazioni.model_id_modalita_pagamento,
		pianificazioni.model_id_prodotto,
		pianificazioni.model_id_progetto,
		pianificazioni.model_id_reparto,
		pianificazioni.model_id_sede_destinatario,
		pianificazioni.model_id_sede_emittente,
		pianificazioni.model_id_tipologia,
		pianificazioni.model_id_todo,
		pianificazioni.model_id_trasportatore,
		pianificazioni.model_id_udm,
		pianificazioni.model_anno_programmazione,
		pianificazioni.model_codice,
		pianificazioni.model_data,
		pianificazioni.model_data_fine,
		pianificazioni.model_data_inizio,
		pianificazioni.model_data_programmazione,
		pianificazioni.model_esigibilita,      
		pianificazioni.model_importo_netto_totale,
		pianificazioni.model_nome,
		pianificazioni.model_note,
		pianificazioni.model_note_programmazione,
		pianificazioni.model_numero,
		pianificazioni.model_ore_programmazione,
		pianificazioni.model_porto,
		pianificazioni.model_quantita,
		pianificazioni.model_riferimento, 
		pianificazioni.model_sconto_percentuale,
		pianificazioni.model_sconto_valore,
		pianificazioni.model_se_automatico,
		pianificazioni.model_sezionale,
		pianificazioni.model_settimana_programmazione,
		pianificazioni.model_specifiche,
		pianificazioni.model_timestamp_scadenza,
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

--| FINE