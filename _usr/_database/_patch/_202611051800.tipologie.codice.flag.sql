-- 2026-11-05 — tipologie_*: codice in tutte, e i flag del lotto 3
--
-- Schema canonico, punto 6, righe 191-227, decisioni di Fabio del 05/11/2026: "bisogna a tendere evitare
-- assolutamente di avere degli id di tipologia cablati nel codice". Il codice sceglie una classe di tipologie con un
-- flag se_* e una tipologia precisa col codice, mai con l'id; per questo codice char(32) UNIQUE entra in tutte le
-- tipologie, e i flag delle tredici tipologie del lotto 3 sono stati decisi uno per uno.
--
-- Cosa fa:
-- - aggiunge codice, dopo ordine, alle tipologie che non l'hanno, con la UNIQUE KEY codice; su tipologie_periodi la
--   KEY codice diventa UNIQUE;
-- - sulle tredici del lotto 3 allarga nome a char(255), toglie la KEY nome e le KEY sui singoli flag e ricrea indice
--   coi flag; rinomina tipologie_immobili.se_industriale in se_commerciale; aggiunge tipologie_todo.se_risorse_umane
--   e se_logistica, tipologie_corrispondenza.ordine, html_entity e font_awesome, la coda di audit di tipologie_zone
--   ( diventata assistita ) con le sue chiavi esterne;
-- - valorizza codice sulle righe che il 050 carica, riconoscendole da id E nome, e solo dove codice e' ancora vuoto;
-- - accende se_corsi sui rami dei corsi ( attivita 18 e figlie, todo 6 e figlie ), se_straordinaria sulla todo 18
--   lezione di prova, se_risorse_umane sulla 16 e se_logistica sulla 20, con la stessa regola.
--
-- Cosa NON fa: non toglie colonne. tipologie_attivita.se_cartellini e se_accesso, tipologie_prodotti.se_spedizione e
-- se_trasporto, tipologie_corrispondenza.se_pesata e tipologie_annunci.sigla escono dal canone ma restano sui database
-- fino al punto 12; nessuna vista le legge piu'.
--
-- IDEMPOTENTE: colonne e chiavi con IF ( NOT ) EXISTS, indice e codice si tolgono e si ricreano, gli UPDATE toccano solo
-- righe con codice o flag ancora vuoti; UPDATE IGNORE salta la riga il cui codice e' gia' usato da un'altra.

-- | 202611051800

-- tipologie_attivita: codice, nome a char(255), indice coi flag
ALTER TABLE `tipologie_attivita`
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL AFTER `ordine`,
	MODIFY `nome` char(255) DEFAULT NULL AFTER `codice`,
	ADD COLUMN IF NOT EXISTS `se_corsi` tinyint(1) DEFAULT NULL AFTER `se_stampa`,
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `se_anagrafica`,
	DROP INDEX IF EXISTS `se_agenda`,
	DROP INDEX IF EXISTS `se_sistema`,
	DROP INDEX IF EXISTS `se_stampa`,
	DROP INDEX IF EXISTS `se_corsi`,
	DROP INDEX IF EXISTS `se_accesso`,
	DROP INDEX IF EXISTS `codice`,
	ADD UNIQUE KEY `codice` (`codice`),
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`,`se_anagrafica`,`se_agenda`,`se_sistema`,`se_stampa`,`se_corsi`);

-- | 202611051801

-- tipologie_corrispondenza: codice, nome a char(255), indice coi flag
ALTER TABLE `tipologie_corrispondenza`
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL AFTER `id_genitore`,
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL AFTER `ordine`,
	MODIFY `nome` char(255) DEFAULT NULL AFTER `codice`,
	ADD COLUMN IF NOT EXISTS `html_entity` char(8) DEFAULT NULL AFTER `nome`,
	ADD COLUMN IF NOT EXISTS `font_awesome` char(16) DEFAULT NULL AFTER `html_entity`,
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `codice`,
	ADD UNIQUE KEY `codice` (`codice`),
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`,`se_massivo`,`se_corrispondenza`,`se_atto`,`se_ricevuta_ritorno`);

-- | 202611051802

-- tipologie_documenti_articoli: codice, nome a char(255), indice coi flag
ALTER TABLE `tipologie_documenti_articoli`
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL AFTER `ordine`,
	MODIFY `nome` char(255) DEFAULT NULL AFTER `codice`,
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `sigla`,
	DROP INDEX IF EXISTS `se_raggruppamento`,
	DROP INDEX IF EXISTS `se_somma`,
	DROP INDEX IF EXISTS `se_alternativa`,
	DROP INDEX IF EXISTS `se_dettaglio`,
	DROP INDEX IF EXISTS `se_evasione`,
	DROP INDEX IF EXISTS `codice`,
	ADD UNIQUE KEY `codice` (`codice`),
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`sigla`,`html_entity`,`font_awesome`,`se_raggruppamento`,`se_somma`,`se_alternativa`,`se_dettaglio`,`se_evasione`);

-- | 202611051803

-- tipologie_immobili: codice, nome a char(255), indice coi flag
ALTER TABLE `tipologie_immobili`
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL AFTER `ordine`,
	MODIFY `nome` char(255) DEFAULT NULL AFTER `codice`,
	CHANGE COLUMN IF EXISTS `se_industriale` `se_commerciale` tinyint(1) DEFAULT NULL AFTER `se_residenziale`,
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `se_residenziale`,
	DROP INDEX IF EXISTS `se_industriale`,
	DROP INDEX IF EXISTS `codice`,
	ADD UNIQUE KEY `codice` (`codice`),
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`,`se_residenziale`,`se_commerciale`);

-- | 202611051804

-- tipologie_mastri: codice, nome a char(255), indice coi flag
ALTER TABLE `tipologie_mastri`
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL AFTER `ordine`,
	MODIFY `nome` char(255) DEFAULT NULL AFTER `codice`,
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `codice`,
	ADD UNIQUE KEY `codice` (`codice`),
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`,`se_magazzino`,`se_conto`,`se_registro`,`se_credito`);

-- | 202611051805

-- tipologie_periodi: codice, nome a char(255), indice coi flag
ALTER TABLE `tipologie_periodi`
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL AFTER `ordine`,
	MODIFY `nome` char(255) DEFAULT NULL AFTER `codice`,
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `codice`,
	ADD UNIQUE KEY `codice` (`codice`),
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`,`se_corsi`,`se_tesseramenti`,`se_abbonamenti`);

-- | 202611051806

-- tipologie_prodotti: codice, nome a char(255), indice coi flag
ALTER TABLE `tipologie_prodotti`
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL AFTER `ordine`,
	MODIFY `nome` char(255) DEFAULT NULL AFTER `codice`,
	DROP INDEX IF EXISTS `codice`,
	ADD UNIQUE KEY `codice` (`codice`),
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`se_colori`,`se_taglie`,`se_periodicita`,`se_tipologia_rinnovo`,`se_dimensioni`,`se_volume`,`se_capacita`,`se_peso`,`se_imballo`,`se_prodotto`,`se_servizio`);

-- | 202611051807

-- tipologie_progetti: codice, nome a char(255), indice coi flag
ALTER TABLE `tipologie_progetti`
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL AFTER `ordine`,
	MODIFY `nome` char(255) DEFAULT NULL AFTER `codice`,
	DROP INDEX IF EXISTS `codice`,
	ADD UNIQUE KEY `codice` (`codice`),
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`,`se_produzione`,`se_contratto`,`se_pacchetto`,`se_progetto`,`se_consuntivo`,`se_forfait`,`se_didattica`);

-- | 202611051808

-- tipologie_pubblicazioni: codice, nome a char(255), indice coi flag
ALTER TABLE `tipologie_pubblicazioni`
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL AFTER `ordine`,
	MODIFY `nome` char(255) DEFAULT NULL AFTER `codice`,
	DROP INDEX IF EXISTS `codice`,
	ADD UNIQUE KEY `codice` (`codice`),
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`,`se_bozza`,`se_pubblicato`,`se_evidenza`,`se_anteprima`);

-- | 202611051809

-- tipologie_rinnovi: codice, nome a char(255), indice coi flag
ALTER TABLE `tipologie_rinnovi`
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL AFTER `ordine`,
	MODIFY `nome` char(255) DEFAULT NULL AFTER `codice`,
	DROP INDEX IF EXISTS `codice`,
	ADD UNIQUE KEY `codice` (`codice`),
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`,`se_tesseramenti`,`se_iscrizioni`,`se_abbonamenti`,`se_licenze`,`se_contratti`,`se_progetti`);

-- | 202611051810

-- tipologie_todo: codice, nome a char(255), indice coi flag
ALTER TABLE `tipologie_todo`
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL AFTER `ordine`,
	MODIFY `nome` char(255) DEFAULT NULL AFTER `codice`,
	ADD COLUMN IF NOT EXISTS `se_risorse_umane` tinyint(1) DEFAULT NULL AFTER `se_amministrazione`,
	ADD COLUMN IF NOT EXISTS `se_logistica` tinyint(1) DEFAULT NULL AFTER `se_risorse_umane`,
	ADD COLUMN IF NOT EXISTS `se_corsi` tinyint(1) DEFAULT NULL AFTER `se_logistica`,
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `se_agenda`,
	DROP INDEX IF EXISTS `se_ticket`,
	DROP INDEX IF EXISTS `se_commerciale`,
	DROP INDEX IF EXISTS `se_produzione`,
	DROP INDEX IF EXISTS `se_amministrazione`,
	DROP INDEX IF EXISTS `se_corsi`,
	DROP INDEX IF EXISTS `codice`,
	ADD UNIQUE KEY `codice` (`codice`),
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`,`se_agenda`,`se_ticket`,`se_ordinaria`,`se_straordinaria`,`se_commerciale`,`se_produzione`,`se_amministrazione`,`se_risorse_umane`,`se_logistica`,`se_corsi`);

-- | 202611051811

-- tipologie_zone: codice, nome a char(255), indice coi flag
ALTER TABLE `tipologie_zone`
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL AFTER `ordine`,
	MODIFY `nome` char(255) DEFAULT NULL AFTER `codice`,
	ADD COLUMN IF NOT EXISTS `id_account_inserimento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_inserimento` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_aggiornamento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_aggiornamento` int(11) DEFAULT NULL,
	ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`),
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `codice`,
	ADD UNIQUE KEY `codice` (`codice`),
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`,`se_ecommerce`,`se_commerciale`,`se_immobiliare`);

-- | 202611051812

-- tipologie_zone: le chiavi esterne della coda di audit
ALTER TABLE `tipologie_zone`
	ADD CONSTRAINT `tipologie_zone_ibfk_98_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `tipologie_zone_ibfk_99_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611051813

-- tipologie_annunci: codice, nome a char(255), indice coi flag
ALTER TABLE `tipologie_annunci`
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL AFTER `ordine`,
	MODIFY `nome` char(255) DEFAULT NULL AFTER `codice`,
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `codice`,
	ADD UNIQUE KEY `codice` (`codice`),
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`);

-- | 202611051814

-- tipologie_asset: codice
ALTER TABLE `tipologie_asset`
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL AFTER `ordine`,
	ADD UNIQUE KEY IF NOT EXISTS `codice` (`codice`);

-- | 202611051815

-- tipologie_badge: codice
ALTER TABLE `tipologie_badge`
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL AFTER `ordine`,
	ADD UNIQUE KEY IF NOT EXISTS `codice` (`codice`);

-- | 202611051816

-- tipologie_banner: codice
ALTER TABLE `tipologie_banner`
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL AFTER `ordine`,
	ADD UNIQUE KEY IF NOT EXISTS `codice` (`codice`);

-- | 202611051817

-- tipologie_campagne: codice
ALTER TABLE `tipologie_campagne`
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL AFTER `ordine`,
	ADD UNIQUE KEY IF NOT EXISTS `codice` (`codice`);

-- | 202611051818

-- tipologie_chiavi: codice
ALTER TABLE `tipologie_chiavi`
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL AFTER `ordine`,
	ADD UNIQUE KEY IF NOT EXISTS `codice` (`codice`);

-- | 202611051819

-- tipologie_contatti: codice
ALTER TABLE `tipologie_contatti`
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL AFTER `ordine`,
	ADD UNIQUE KEY IF NOT EXISTS `codice` (`codice`);

-- | 202611051820

-- tipologie_edifici: codice
ALTER TABLE `tipologie_edifici`
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL AFTER `ordine`,
	ADD UNIQUE KEY IF NOT EXISTS `codice` (`codice`);

-- | 202611051821

-- tipologie_indirizzi: codice
ALTER TABLE `tipologie_indirizzi`
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL AFTER `ordine`,
	ADD UNIQUE KEY IF NOT EXISTS `codice` (`codice`);

-- | 202611051822

-- tipologie_licenze: codice
ALTER TABLE `tipologie_licenze`
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL AFTER `ordine`,
	ADD UNIQUE KEY IF NOT EXISTS `codice` (`codice`);

-- | 202611051823

-- tipologie_listini: codice
ALTER TABLE `tipologie_listini`
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL AFTER `ordine`,
	ADD UNIQUE KEY IF NOT EXISTS `codice` (`codice`);

-- | 202611051824

-- tipologie_luoghi: codice
ALTER TABLE `tipologie_luoghi`
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL AFTER `ordine`,
	ADD UNIQUE KEY IF NOT EXISTS `codice` (`codice`);

-- | 202611051825

-- tipologie_notizie: codice
ALTER TABLE `tipologie_notizie`
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL AFTER `ordine`,
	ADD UNIQUE KEY IF NOT EXISTS `codice` (`codice`);

-- | 202611051826

-- tipologie_pagamenti: codice
ALTER TABLE `tipologie_pagamenti`
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL AFTER `ordine`,
	ADD UNIQUE KEY IF NOT EXISTS `codice` (`codice`);

-- | 202611051827

-- tipologie_popup: codice
ALTER TABLE `tipologie_popup`
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL AFTER `ordine`,
	ADD UNIQUE KEY IF NOT EXISTS `codice` (`codice`);

-- | 202611051828

-- tipologie_risorse: codice
ALTER TABLE `tipologie_risorse`
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL AFTER `ordine`,
	ADD UNIQUE KEY IF NOT EXISTS `codice` (`codice`);

-- | 202611051829

-- tipologie_spedizioni: codice
ALTER TABLE `tipologie_spedizioni`
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL AFTER `ordine`,
	ADD UNIQUE KEY IF NOT EXISTS `codice` (`codice`);

-- | 202611051830

-- tipologie_telefoni: codice
ALTER TABLE `tipologie_telefoni`
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL AFTER `ordine`,
	ADD UNIQUE KEY IF NOT EXISTS `codice` (`codice`);

-- | 202611051831

-- tipologie_url: codice
ALTER TABLE `tipologie_url`
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL AFTER `ordine`,
	ADD UNIQUE KEY IF NOT EXISTS `codice` (`codice`);

-- | 202611051832

-- tipologie_vani: codice
ALTER TABLE `tipologie_vani`
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL AFTER `ordine`,
	ADD UNIQUE KEY IF NOT EXISTS `codice` (`codice`);

-- | 202611051833

-- tipologie_veicoli: codice
ALTER TABLE `tipologie_veicoli`
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL AFTER `ordine`,
	ADD UNIQUE KEY IF NOT EXISTS `codice` (`codice`);

-- | 202611051834

-- tipologie_attivita: codice sulle righe del 050
UPDATE IGNORE `tipologie_attivita` JOIN (
		SELECT 1 AS id, 'lavoro' AS nome, 'LAVORO' AS codice
		UNION ALL SELECT 2 AS id, 'ferie' AS nome, 'FERIE' AS codice
		UNION ALL SELECT 3 AS id, 'permessi' AS nome, 'PERMESSI' AS codice
		UNION ALL SELECT 4 AS id, 'malattie' AS nome, 'MALATTIE' AS codice
		UNION ALL SELECT 5 AS id, 'SDI' AS nome, 'SDI' AS codice
		UNION ALL SELECT 6 AS id, 'ricevuta di consegna' AS nome, 'RC' AS codice
		UNION ALL SELECT 7 AS id, 'mancata consegna' AS nome, 'MC' AS codice
		UNION ALL SELECT 8 AS id, 'notifica di scarto' AS nome, 'NS' AS codice
		UNION ALL SELECT 9 AS id, 'presa in carico con impossibilità di recapito' AS nome, 'AT' AS codice
		UNION ALL SELECT 10 AS id, 'decorrenza termini' AS nome, 'DT' AS codice
		UNION ALL SELECT 11 AS id, 'esito committente' AS nome, 'EC' AS codice
		UNION ALL SELECT 12 AS id, 'notifica di esito' AS nome, 'NE' AS codice
		UNION ALL SELECT 13 AS id, 'notifica di metadati per fattura passiva' AS nome, 'MT' AS codice
		UNION ALL SELECT 14 AS id, 'produzione' AS nome, 'PRODUZIONE' AS codice
		UNION ALL SELECT 15 AS id, 'frequenza' AS nome, 'FREQUENZA' AS codice
		UNION ALL SELECT 16 AS id, 'commerciale' AS nome, 'COMMERCIALE' AS codice
		UNION ALL SELECT 17 AS id, 'amministrazione' AS nome, 'AMMINISTRAZIONE' AS codice
		UNION ALL SELECT 18 AS id, 'didattica' AS nome, 'DIDATTICA' AS codice
		UNION ALL SELECT 19 AS id, 'assenza' AS nome, 'ASSENZA' AS codice
		UNION ALL SELECT 20 AS id, 'carico ore' AS nome, 'CARICO_ORE' AS codice
		UNION ALL SELECT 21 AS id, 'promemoria scadenze' AS nome, 'PROMEMORIA_SCADENZE' AS codice
		UNION ALL SELECT 22 AS id, 'stampe' AS nome, 'STAMPE' AS codice
		UNION ALL SELECT 23 AS id, 'stampa PDF' AS nome, 'STAMPA_PDF' AS codice
		UNION ALL SELECT 24 AS id, 'stampa XML' AS nome, 'STAMPA_XML' AS codice
		UNION ALL SELECT 25 AS id, 'sollecito insoluti' AS nome, 'SOLLECITO_INSOLUTI' AS codice
		UNION ALL SELECT 26 AS id, 'invio proposta commerciale' AS nome, 'INVIO_PROPOSTA_COMMERCIALE' AS codice
		UNION ALL SELECT 27 AS id, 'invio' AS nome, 'INVIO' AS codice
		UNION ALL SELECT 28 AS id, 'invio via e-mail' AS nome, 'INVIO_VIA_E_MAIL' AS codice
		UNION ALL SELECT 29 AS id, 'invio via PEC' AS nome, 'INVIO_VIA_PEC' AS codice
		UNION ALL SELECT 30 AS id, 'docenza' AS nome, 'DOCENZA' AS codice
		UNION ALL SELECT 31 AS id, 'co-docenza' AS nome, 'CO_DOCENZA' AS codice
		UNION ALL SELECT 32 AS id, 'recupero frequenza' AS nome, 'RECUPERO_FREQUENZA' AS codice
		UNION ALL SELECT 33 AS id, 'frequenza di prova' AS nome, 'FREQUENZA_DI_PROVA' AS codice
		UNION ALL SELECT 34 AS id, 'mailing' AS nome, 'MAILING' AS codice
		UNION ALL SELECT 35 AS id, 'apertura mail' AS nome, 'APERTURA_MAIL' AS codice
		UNION ALL SELECT 36 AS id, 'invio report' AS nome, 'INVIO_REPORT' AS codice
		UNION ALL SELECT 37 AS id, 'accesso' AS nome, 'ACCESSO' AS codice
		UNION ALL SELECT 38 AS id, 'riuscito' AS nome, 'ACCESSO_RIUSCITO' AS codice
		UNION ALL SELECT 39 AS id, 'fallito' AS nome, 'ACCESSO_FALLITO' AS codice
		UNION ALL SELECT 40 AS id, 'lista di attesa' AS nome, 'LISTA_DI_ATTESA' AS codice
		UNION ALL SELECT 41 AS id, 'chat' AS nome, 'CHAT' AS codice
		UNION ALL SELECT 42 AS id, 'lettura' AS nome, 'CHAT_LETTURA' AS codice
		UNION ALL SELECT 43 AS id, 'download file' AS nome, 'DOWNLOAD_FILE' AS codice
		UNION ALL SELECT 44 AS id, 'banner' AS nome, 'BANNER' AS codice
		UNION ALL SELECT 45 AS id, 'visualizzazione' AS nome, 'BANNER_VISUALIZZAZIONE' AS codice
		UNION ALL SELECT 46 AS id, 'click' AS nome, 'BANNER_CLICK' AS codice
		UNION ALL SELECT 47 AS id, 'redirect' AS nome, 'REDIRECT' AS codice
	) AS c050 ON c050.id = `tipologie_attivita`.id AND c050.nome = `tipologie_attivita`.nome
	SET `tipologie_attivita`.codice = c050.codice
	WHERE `tipologie_attivita`.codice IS NULL;

-- | 202611051835

-- tipologie_corrispondenza: codice sulle righe del 050
UPDATE IGNORE `tipologie_corrispondenza` JOIN (
		SELECT 1 AS id, 'Posta Prioritaria PRO' AS nome, 'POSTA_PRIORITARIA_PRO' AS codice
		UNION ALL SELECT 2 AS id, 'Raccomandate PRO / RACCOMANDATA MARKET - NO ATT.' AS nome, 'RACCOMANDATA_PRO' AS codice
		UNION ALL SELECT 3 AS id, 'Atti giudiziari' AS nome, 'ATTI_GIUDIZIARI' AS codice
		UNION ALL SELECT 4 AS id, 'Assicurate retail / ASSICURATA MARKET' AS nome, 'ASSICURATA_RETAIL' AS codice
		UNION ALL SELECT 5 AS id, 'Pieghi di libri MAAF' AS nome, 'PIEGHI_DI_LIBRI_MAAF' AS codice
		UNION ALL SELECT 6 AS id, 'Pieghi di libri' AS nome, 'PIEGHI_DI_LIBRI' AS codice
		UNION ALL SELECT 7 AS id, 'Raccomandate A/R / RACCOMANDATA MARKET CON ATTESTAZIONE DI CONSEGNA' AS nome, 'RACCOMANDATA_AR' AS codice
		UNION ALL SELECT 8 AS id, 'Corrispondenza estera' AS nome, 'CORRISPONDENZA_ESTERA' AS codice
		UNION ALL SELECT 9 AS id, 'Assicurate estere' AS nome, 'ASSICURATE_ESTERE' AS codice
		UNION ALL SELECT 10 AS id, 'Raccomandate estere' AS nome, 'RACCOMANDATE_ESTERE' AS codice
		UNION ALL SELECT 11 AS id, 'Posta 1 PRO' AS nome, 'POSTA_1_PRO' AS codice
		UNION ALL SELECT 12 AS id, 'Posta 4 PRO / POSTA CONTEST 4 (ORDINARIA)' AS nome, 'POSTA_4_PRO' AS codice
		UNION ALL SELECT 13 AS id, 'Posta Priority Internazionale' AS nome, 'POSTA_PRIORITY_INTERNAZIONALE' AS codice
		UNION ALL SELECT 14 AS id, 'Posta Mail Internazionale' AS nome, 'POSTA_MAIL_INTERNAZIONALE' AS codice
		UNION ALL SELECT 15 AS id, 'Posta Raccomandata internazionale' AS nome, 'RACCOMANDATA_INTERNAZIONALE' AS codice
		UNION ALL SELECT 16 AS id, 'MINI BOX (ORDINARIA ESTERO) ZONA 1' AS nome, 'MINI_BOX_ORDINARIA_ESTERO_ZONA_1' AS codice
		UNION ALL SELECT 17 AS id, 'MINI BOX (ORDINARIA ESTERO) ZONA 2' AS nome, 'MINI_BOX_ORDINARIA_ESTERO_ZONA_2' AS codice
		UNION ALL SELECT 18 AS id, 'MINI BOX (ORDINARIA ESTERO) ZONA 3' AS nome, 'MINI_BOX_ORDINARIA_ESTERO_ZONA_3' AS codice
		UNION ALL SELECT 52 AS id, 'accesso atti' AS nome, 'ACCESSO_ATTI' AS codice
		UNION ALL SELECT 53 AS id, 'accesso atti - contratto cimiteriale' AS nome, 'ACCESSO_ATTI_CIMITERIALE' AS codice
		UNION ALL SELECT 54 AS id, 'accesso atti - edilizia' AS nome, 'ACCESSO_ATTI_EDILIZIA' AS codice
		UNION ALL SELECT 55 AS id, 'accesso atti - polizia' AS nome, 'ACCESSO_ATTI_POLIZIA' AS codice
		UNION ALL SELECT 56 AS id, 'atto Corte d''Appello' AS nome, 'ATTO_CORTE_D_APPELLO' AS codice
		UNION ALL SELECT 57 AS id, 'autorizzazione' AS nome, 'AUTORIZZAZIONE' AS codice
		UNION ALL SELECT 58 AS id, 'autorizzazione - ambiente' AS nome, 'AUTORIZZAZIONE_AMBIENTE' AS codice
		UNION ALL SELECT 59 AS id, 'autorizzazione - edilizia' AS nome, 'AUTORIZZAZIONE_EDILIZIA' AS codice
		UNION ALL SELECT 60 AS id, 'attestazione - idoneità dell''alloggio' AS nome, 'ATTESTAZIONE_IDONEITA_ALLOGGIO' AS codice
		UNION ALL SELECT 61 AS id, 'autorizzazione - occupazione suolo' AS nome, 'AUTORIZZAZIONE_OCCUPAZIONE_SUOLO' AS codice
		UNION ALL SELECT 62 AS id, 'assenti (Art. 140) - cartelle esattoriali' AS nome, 'ASSENTI_ART_140_CARTELLE' AS codice
		UNION ALL SELECT 63 AS id, 'irreperibili (Art. 60) - EQUITALIA (vecchi)' AS nome, 'IRREPERIBILI_ART_60_EQUITALIA' AS codice
		UNION ALL SELECT 64 AS id, 'certificato destinazione urbanistica' AS nome, 'CERTIFICATO_DEST_URBANISTICA' AS codice
		UNION ALL SELECT 65 AS id, 'atti notificati (Art. 140)' AS nome, 'ATTI_NOTIFICATI_ART_140' AS codice
		UNION ALL SELECT 66 AS id, 'ATTI SPORTELLO EDILIZIA' AS nome, 'ATTI_SPORTELLO_EDILIZIA' AS codice
		UNION ALL SELECT 67 AS id, 'Irreperibili (Art.143) - atti amministrativi' AS nome, 'IRREPERIBILI_ART_143' AS codice
		UNION ALL SELECT 68 AS id, 'irreperibili (Art. 60) - AGENZIA ENTRATE' AS nome, 'IRREPERIBILI_ART_60_ENTRATE' AS codice
		UNION ALL SELECT 69 AS id, 'attestazione - regolarità soggiorno' AS nome, 'ATTESTAZIONE_SOGGIORNO' AS codice
		UNION ALL SELECT 70 AS id, 'assenti (Art. 140) - AGENZIA ENTRATE' AS nome, 'ASSENTI_ART_140_ENTRATE' AS codice
		UNION ALL SELECT 71 AS id, 'irreperibili (Art. 60) - cartelle esattoriali' AS nome, 'IRREPERIBILI_ART_60_CARTELLE' AS codice
	) AS c050 ON c050.id = `tipologie_corrispondenza`.id AND c050.nome = `tipologie_corrispondenza`.nome
	SET `tipologie_corrispondenza`.codice = c050.codice
	WHERE `tipologie_corrispondenza`.codice IS NULL;

-- | 202611051836

-- tipologie_documenti_articoli: codice sulle righe del 050
UPDATE IGNORE `tipologie_documenti_articoli` JOIN (
		SELECT 1 AS id, 'raggruppamento a sommare' AS nome, 'RAGGRUPPAMENTO_A_SOMMARE' AS codice
		UNION ALL SELECT 2 AS id, 'raggruppamento in alternativa' AS nome, 'RAGGRUPPAMENTO_IN_ALTERNATIVA' AS codice
		UNION ALL SELECT 5 AS id, 'dettaglio' AS nome, 'DETTAGLIO' AS codice
		UNION ALL SELECT 6 AS id, 'evasione' AS nome, 'EVASIONE' AS codice
	) AS c050 ON c050.id = `tipologie_documenti_articoli`.id AND c050.nome = `tipologie_documenti_articoli`.nome
	SET `tipologie_documenti_articoli`.codice = c050.codice
	WHERE `tipologie_documenti_articoli`.codice IS NULL;

-- | 202611051837

-- tipologie_immobili: codice sulle righe del 050
UPDATE IGNORE `tipologie_immobili` JOIN (
		SELECT 1 AS id, 'appartamento' AS nome, 'APPARTAMENTO' AS codice
		UNION ALL SELECT 3 AS id, 'abitazione' AS nome, 'ABITAZIONE' AS codice
		UNION ALL SELECT 6 AS id, 'garage' AS nome, 'GARAGE' AS codice
		UNION ALL SELECT 7 AS id, 'magazzino' AS nome, 'MAGAZZINO' AS codice
		UNION ALL SELECT 8 AS id, 'ufficio' AS nome, 'UFFICIO' AS codice
		UNION ALL SELECT 9 AS id, 'negozio' AS nome, 'NEGOZIO' AS codice
	) AS c050 ON c050.id = `tipologie_immobili`.id AND c050.nome = `tipologie_immobili`.nome
	SET `tipologie_immobili`.codice = c050.codice
	WHERE `tipologie_immobili`.codice IS NULL;

-- | 202611051838

-- tipologie_mastri: codice sulle righe del 050
UPDATE IGNORE `tipologie_mastri` JOIN (
		SELECT 1 AS id, 'magazzino' AS nome, 'MAGAZZINO' AS codice
		UNION ALL SELECT 2 AS id, 'conto' AS nome, 'CONTO' AS codice
		UNION ALL SELECT 3 AS id, 'registro ore' AS nome, 'REGISTRO_ORE' AS codice
		UNION ALL SELECT 4 AS id, 'crediti' AS nome, 'CREDITI' AS codice
	) AS c050 ON c050.id = `tipologie_mastri`.id AND c050.nome = `tipologie_mastri`.nome
	SET `tipologie_mastri`.codice = c050.codice
	WHERE `tipologie_mastri`.codice IS NULL;

-- | 202611051839

-- tipologie_periodi: codice sulle righe del 050
UPDATE IGNORE `tipologie_periodi` JOIN (
		SELECT 1 AS id, 'feste' AS nome, 'FESTE' AS codice
		UNION ALL SELECT 2 AS id, 'ferie' AS nome, 'FERIE' AS codice
		UNION ALL SELECT 3 AS id, 'lavoro' AS nome, 'LAVORO' AS codice
		UNION ALL SELECT 4 AS id, 'anno sportivo' AS nome, 'ANNO_SPORTIVO' AS codice
		UNION ALL SELECT 5 AS id, 'sospensione' AS nome, 'SOSPENSIONE' AS codice
	) AS c050 ON c050.id = `tipologie_periodi`.id AND c050.nome = `tipologie_periodi`.nome
	SET `tipologie_periodi`.codice = c050.codice
	WHERE `tipologie_periodi`.codice IS NULL;

-- | 202611051840

-- tipologie_prodotti: codice sulle righe del 050
UPDATE IGNORE `tipologie_prodotti` JOIN (
		SELECT 1 AS id, 'prodotto' AS nome, 'PRODOTTO' AS codice
		UNION ALL SELECT 2 AS id, 'servizio' AS nome, 'SERVIZIO' AS codice
		UNION ALL SELECT 3 AS id, 'alimentare (peso)' AS nome, 'ALIMENTARE_PESO' AS codice
		UNION ALL SELECT 4 AS id, 'alimentare (volume)' AS nome, 'ALIMENTARE_VOLUME' AS codice
		UNION ALL SELECT 5 AS id, 'alimentare (pezzo)' AS nome, 'ALIMENTARE_PEZZO' AS codice
		UNION ALL SELECT 6 AS id, 'didattica' AS nome, 'DIDATTICA' AS codice
		UNION ALL SELECT 7 AS id, 'iscrizione' AS nome, 'ISCRIZIONE' AS codice
		UNION ALL SELECT 8 AS id, 'contratto' AS nome, 'CONTRATTO' AS codice
		UNION ALL SELECT 9 AS id, 'tesseramento' AS nome, 'TESSERAMENTO' AS codice
		UNION ALL SELECT 10 AS id, 'abbonamento' AS nome, 'ABBONAMENTO' AS codice
		UNION ALL SELECT 11 AS id, 'abbigliamento' AS nome, 'ABBIGLIAMENTO' AS codice
		UNION ALL SELECT 12 AS id, 'maglieria' AS nome, 'MAGLIERIA' AS codice
		UNION ALL SELECT 13 AS id, 'caschi' AS nome, 'CASCHI' AS codice
		UNION ALL SELECT 14 AS id, 'intimo' AS nome, 'INTIMO' AS codice
		UNION ALL SELECT 15 AS id, 'calzature' AS nome, 'CALZATURE' AS codice
		UNION ALL SELECT 16 AS id, 'meccanica (dimensioni e peso)' AS nome, 'MECCANICA_DIMENSIONI_E_PESO' AS codice
	) AS c050 ON c050.id = `tipologie_prodotti`.id AND c050.nome = `tipologie_prodotti`.nome
	SET `tipologie_prodotti`.codice = c050.codice
	WHERE `tipologie_prodotti`.codice IS NULL;

-- | 202611051841

-- tipologie_progetti: codice sulle righe del 050
UPDATE IGNORE `tipologie_progetti` JOIN (
		SELECT 1 AS id, 'contratto' AS nome, 'CONTRATTO' AS codice
		UNION ALL SELECT 2 AS id, 'pacchetto' AS nome, 'PACCHETTO' AS codice
		UNION ALL SELECT 3 AS id, 'progetto' AS nome, 'PROGETTO' AS codice
		UNION ALL SELECT 4 AS id, 'consuntivo' AS nome, 'CONSUNTIVO' AS codice
		UNION ALL SELECT 5 AS id, 'forfait' AS nome, 'FORFAIT' AS codice
		UNION ALL SELECT 6 AS id, 'corso' AS nome, 'CORSO' AS codice
	) AS c050 ON c050.id = `tipologie_progetti`.id AND c050.nome = `tipologie_progetti`.nome
	SET `tipologie_progetti`.codice = c050.codice
	WHERE `tipologie_progetti`.codice IS NULL;

-- | 202611051842

-- tipologie_pubblicazioni: codice sulle righe del 050
UPDATE IGNORE `tipologie_pubblicazioni` JOIN (
		SELECT 1 AS id, 'bozza' AS nome, 'BOZZA' AS codice
		UNION ALL SELECT 2 AS id, 'pubblicato' AS nome, 'PUBBLICATO' AS codice
		UNION ALL SELECT 3 AS id, 'in evidenza' AS nome, 'IN_EVIDENZA' AS codice
		UNION ALL SELECT 4 AS id, 'anteprima' AS nome, 'ANTEPRIMA' AS codice
	) AS c050 ON c050.id = `tipologie_pubblicazioni`.id AND c050.nome = `tipologie_pubblicazioni`.nome
	SET `tipologie_pubblicazioni`.codice = c050.codice
	WHERE `tipologie_pubblicazioni`.codice IS NULL;

-- | 202611051843

-- tipologie_rinnovi: codice sulle righe del 050
UPDATE IGNORE `tipologie_rinnovi` JOIN (
		SELECT 1 AS id, 'ordinario' AS nome, 'ORDINARIO' AS codice
		UNION ALL SELECT 2 AS id, 'straordinario' AS nome, 'STRAORDINARIO' AS codice
		UNION ALL SELECT 3 AS id, 'ridotto' AS nome, 'RIDOTTO' AS codice
	) AS c050 ON c050.id = `tipologie_rinnovi`.id AND c050.nome = `tipologie_rinnovi`.nome
	SET `tipologie_rinnovi`.codice = c050.codice
	WHERE `tipologie_rinnovi`.codice IS NULL;

-- | 202611051844

-- tipologie_todo: codice sulle righe del 050
UPDATE IGNORE `tipologie_todo` JOIN (
		SELECT 1 AS id, 'produzione' AS nome, 'PRODUZIONE' AS codice
		UNION ALL SELECT 2 AS id, 'commerciale' AS nome, 'COMMERCIALE' AS codice
		UNION ALL SELECT 3 AS id, 'amministrazione' AS nome, 'AMMINISTRAZIONE' AS codice
		UNION ALL SELECT 4 AS id, 'sviluppo' AS nome, 'SVILUPPO' AS codice
		UNION ALL SELECT 5 AS id, 'assistenza' AS nome, 'ASSISTENZA' AS codice
		UNION ALL SELECT 6 AS id, 'formazione' AS nome, 'FORMAZIONE' AS codice
		UNION ALL SELECT 7 AS id, 'consulenza' AS nome, 'CONSULENZA' AS codice
		UNION ALL SELECT 8 AS id, 'fornitura' AS nome, 'FORNITURA' AS codice
		UNION ALL SELECT 9 AS id, 'ticket' AS nome, 'TICKET' AS codice
		UNION ALL SELECT 10 AS id, 'ricerca clienti' AS nome, 'RICERCA_CLIENTI' AS codice
		UNION ALL SELECT 11 AS id, 'customer care' AS nome, 'CUSTOMER_CARE' AS codice
		UNION ALL SELECT 12 AS id, 'preventivazione' AS nome, 'PREVENTIVAZIONE' AS codice
		UNION ALL SELECT 14 AS id, 'recupero lezione' AS nome, 'RECUPERO_LEZIONE' AS codice
		UNION ALL SELECT 15 AS id, 'lezione' AS nome, 'LEZIONE' AS codice
		UNION ALL SELECT 16 AS id, 'risorse umane' AS nome, 'RISORSE_UMANE' AS codice
		UNION ALL SELECT 17 AS id, 'lezione annullata' AS nome, 'LEZIONE_ANNULLATA' AS codice
		UNION ALL SELECT 18 AS id, 'lezione di prova' AS nome, 'LEZIONE_DI_PROVA' AS codice
		UNION ALL SELECT 19 AS id, 'open day' AS nome, 'OPEN_DAY' AS codice
		UNION ALL SELECT 20 AS id, 'logistica' AS nome, 'LOGISTICA' AS codice
	) AS c050 ON c050.id = `tipologie_todo`.id AND c050.nome = `tipologie_todo`.nome
	SET `tipologie_todo`.codice = c050.codice
	WHERE `tipologie_todo`.codice IS NULL;

-- | 202611051845

-- tipologie_zone: codice sulle righe del 050
UPDATE IGNORE `tipologie_zone` JOIN (
		SELECT 1 AS id, 'e-commerce' AS nome, 'E_COMMERCE' AS codice
		UNION ALL SELECT 2 AS id, 'commerciale' AS nome, 'COMMERCIALE' AS codice
		UNION ALL SELECT 3 AS id, 'immobiliare' AS nome, 'IMMOBILIARE' AS codice
	) AS c050 ON c050.id = `tipologie_zone`.id AND c050.nome = `tipologie_zone`.nome
	SET `tipologie_zone`.codice = c050.codice
	WHERE `tipologie_zone`.codice IS NULL;

-- | 202611051846

-- tipologie_badge: codice sulle righe del 050
UPDATE IGNORE `tipologie_badge` JOIN (
		SELECT 1 AS id, 'tesserini' AS nome, 'TESSERINI' AS codice
		UNION ALL SELECT 2 AS id, 'token di accesso' AS nome, 'TOKEN_DI_ACCESSO' AS codice
		UNION ALL SELECT 3 AS id, 'RFID' AS nome, 'RFID' AS codice
		UNION ALL SELECT 4 AS id, 'chiavette' AS nome, 'CHIAVETTE' AS codice
		UNION ALL SELECT 5 AS id, 'braccialetti' AS nome, 'BRACCIALETTI' AS codice
		UNION ALL SELECT 6 AS id, 'etichette' AS nome, 'ETICHETTE' AS codice
		UNION ALL SELECT 7 AS id, 'NFC' AS nome, 'NFC' AS codice
		UNION ALL SELECT 8 AS id, 'adesivi' AS nome, 'ADESIVI' AS codice
		UNION ALL SELECT 9 AS id, 'telecomandi' AS nome, 'TELECOMANDI' AS codice
	) AS c050 ON c050.id = `tipologie_badge`.id AND c050.nome = `tipologie_badge`.nome
	SET `tipologie_badge`.codice = c050.codice
	WHERE `tipologie_badge`.codice IS NULL;

-- | 202611051847

-- tipologie_contatti: codice sulle righe del 050
UPDATE IGNORE `tipologie_contatti` JOIN (
		SELECT 1 AS id, 'di persona' AS nome, 'DI_PERSONA' AS codice
		UNION ALL SELECT 2 AS id, 'telefono' AS nome, 'TELEFONO' AS codice
		UNION ALL SELECT 3 AS id, 'mail' AS nome, 'MAIL' AS codice
		UNION ALL SELECT 4 AS id, 'form web' AS nome, 'FORM_WEB' AS codice
		UNION ALL SELECT 5 AS id, 'chat' AS nome, 'CHAT' AS codice
	) AS c050 ON c050.id = `tipologie_contatti`.id AND c050.nome = `tipologie_contatti`.nome
	SET `tipologie_contatti`.codice = c050.codice
	WHERE `tipologie_contatti`.codice IS NULL;

-- | 202611051848

-- tipologie_edifici: codice sulle righe del 050
UPDATE IGNORE `tipologie_edifici` JOIN (
		SELECT 1 AS id, 'palazzo' AS nome, 'PALAZZO' AS codice
		UNION ALL SELECT 2 AS id, 'palazzo storico' AS nome, 'PALAZZO_STORICO' AS codice
		UNION ALL SELECT 3 AS id, 'palazzina' AS nome, 'PALAZZINA' AS codice
		UNION ALL SELECT 4 AS id, 'complesso' AS nome, 'COMPLESSO' AS codice
		UNION ALL SELECT 5 AS id, 'residence' AS nome, 'RESIDENCE' AS codice
		UNION ALL SELECT 6 AS id, 'edificio indipendente' AS nome, 'EDIFICIO_INDIPENDENTE' AS codice
	) AS c050 ON c050.id = `tipologie_edifici`.id AND c050.nome = `tipologie_edifici`.nome
	SET `tipologie_edifici`.codice = c050.codice
	WHERE `tipologie_edifici`.codice IS NULL;

-- | 202611051849

-- tipologie_indirizzi: codice sulle righe del 050
UPDATE IGNORE `tipologie_indirizzi` JOIN (
		SELECT 1 AS id, 'calle' AS nome, 'CALLE' AS codice
		UNION ALL SELECT 2 AS id, 'campiello' AS nome, 'CAMPIELLO' AS codice
		UNION ALL SELECT 3 AS id, 'campo' AS nome, 'CAMPO' AS codice
		UNION ALL SELECT 4 AS id, 'carraia' AS nome, 'CARRAIA' AS codice
		UNION ALL SELECT 5 AS id, 'carrarone' AS nome, 'CARRARONE' AS codice
		UNION ALL SELECT 6 AS id, 'chiasso' AS nome, 'CHIASSO' AS codice
		UNION ALL SELECT 7 AS id, 'circondario' AS nome, 'CIRCONDARIO' AS codice
		UNION ALL SELECT 8 AS id, 'circonvallazione' AS nome, 'CIRCONVALLAZIONE' AS codice
		UNION ALL SELECT 9 AS id, 'contrà' AS nome, 'CONTRA' AS codice
		UNION ALL SELECT 10 AS id, 'contrada' AS nome, 'CONTRADA' AS codice
		UNION ALL SELECT 11 AS id, 'corso' AS nome, 'CORSO' AS codice
		UNION ALL SELECT 12 AS id, 'diga' AS nome, 'DIGA' AS codice
		UNION ALL SELECT 13 AS id, 'discesa' AS nome, 'DISCESA' AS codice
		UNION ALL SELECT 14 AS id, 'frazione' AS nome, 'FRAZIONE' AS codice
		UNION ALL SELECT 15 AS id, 'giardino' AS nome, 'GIARDINO' AS codice
		UNION ALL SELECT 16 AS id, 'largo' AS nome, 'LARGO' AS codice
		UNION ALL SELECT 17 AS id, 'località' AS nome, 'LOCALITA' AS codice
		UNION ALL SELECT 18 AS id, 'lungoargine' AS nome, 'LUNGOARGINE' AS codice
		UNION ALL SELECT 19 AS id, 'lungolago' AS nome, 'LUNGOLAGO' AS codice
		UNION ALL SELECT 20 AS id, 'lungomare' AS nome, 'LUNGOMARE' AS codice
		UNION ALL SELECT 21 AS id, 'maso' AS nome, 'MASO' AS codice
		UNION ALL SELECT 22 AS id, 'parallela' AS nome, 'PARALLELA' AS codice
		UNION ALL SELECT 23 AS id, 'passeggiata' AS nome, 'PASSEGGIATA' AS codice
		UNION ALL SELECT 24 AS id, 'piazza' AS nome, 'PIAZZA' AS codice
		UNION ALL SELECT 25 AS id, 'piazzale' AS nome, 'PIAZZALE' AS codice
		UNION ALL SELECT 26 AS id, 'piazzetta' AS nome, 'PIAZZETTA' AS codice
		UNION ALL SELECT 27 AS id, 'rotonda' AS nome, 'ROTONDA' AS codice
		UNION ALL SELECT 28 AS id, 'salita' AS nome, 'SALITA' AS codice
		UNION ALL SELECT 29 AS id, 'strada' AS nome, 'STRADA' AS codice
		UNION ALL SELECT 30 AS id, 'stradella' AS nome, 'STRADELLA' AS codice
		UNION ALL SELECT 31 AS id, 'stradello' AS nome, 'STRADELLO' AS codice
		UNION ALL SELECT 32 AS id, 'traversa' AS nome, 'TRAVERSA' AS codice
		UNION ALL SELECT 33 AS id, 'via' AS nome, 'VIA' AS codice
		UNION ALL SELECT 34 AS id, 'viale' AS nome, 'VIALE' AS codice
		UNION ALL SELECT 35 AS id, 'vico' AS nome, 'VICO' AS codice
		UNION ALL SELECT 36 AS id, 'vicoletto' AS nome, 'VICOLETTO' AS codice
		UNION ALL SELECT 37 AS id, 'vicolo' AS nome, 'VICOLO' AS codice
		UNION ALL SELECT 38 AS id, 'vietta' AS nome, 'VIETTA' AS codice
		UNION ALL SELECT 39 AS id, 'viottolo' AS nome, 'VIOTTOLO' AS codice
		UNION ALL SELECT 40 AS id, 'viuzza' AS nome, 'VIUZZA' AS codice
		UNION ALL SELECT 41 AS id, 'viuzzo' AS nome, 'VIUZZO' AS codice
	) AS c050 ON c050.id = `tipologie_indirizzi`.id AND c050.nome = `tipologie_indirizzi`.nome
	SET `tipologie_indirizzi`.codice = c050.codice
	WHERE `tipologie_indirizzi`.codice IS NULL;

-- | 202611051850

-- tipologie_listini: codice sulle righe del 050
UPDATE IGNORE `tipologie_listini` JOIN (
		SELECT 1 AS id, 'STANDARD' AS nome, 'STANDARD' AS codice
	) AS c050 ON c050.id = `tipologie_listini`.id AND c050.nome = `tipologie_listini`.nome
	SET `tipologie_listini`.codice = c050.codice
	WHERE `tipologie_listini`.codice IS NULL;

-- | 202611051851

-- tipologie_luoghi: codice sulle righe del 050
UPDATE IGNORE `tipologie_luoghi` JOIN (
		SELECT 1 AS id, 'teatro' AS nome, 'TEATRO' AS codice
		UNION ALL SELECT 2 AS id, 'palestra' AS nome, 'PALESTRA' AS codice
		UNION ALL SELECT 3 AS id, 'piscina' AS nome, 'PISCINA' AS codice
		UNION ALL SELECT 4 AS id, 'sala' AS nome, 'SALA' AS codice
		UNION ALL SELECT 5 AS id, 'aula' AS nome, 'AULA' AS codice
		UNION ALL SELECT 6 AS id, 'online' AS nome, 'ONLINE' AS codice
	) AS c050 ON c050.id = `tipologie_luoghi`.id AND c050.nome = `tipologie_luoghi`.nome
	SET `tipologie_luoghi`.codice = c050.codice
	WHERE `tipologie_luoghi`.codice IS NULL;

-- | 202611051852

-- tipologie_notizie: codice sulle righe del 050
UPDATE IGNORE `tipologie_notizie` JOIN (
		SELECT 1 AS id, 'notizia' AS nome, 'NOTIZIA' AS codice
		UNION ALL SELECT 2 AS id, 'blog post' AS nome, 'BLOG_POST' AS codice
		UNION ALL SELECT 3 AS id, 'articolo' AS nome, 'ARTICOLO' AS codice
	) AS c050 ON c050.id = `tipologie_notizie`.id AND c050.nome = `tipologie_notizie`.nome
	SET `tipologie_notizie`.codice = c050.codice
	WHERE `tipologie_notizie`.codice IS NULL;

-- | 202611051853

-- tipologie_pagamenti: codice sulle righe del 050
UPDATE IGNORE `tipologie_pagamenti` JOIN (
		SELECT 1 AS id, 'acconto' AS nome, 'ACCONTO' AS codice
		UNION ALL SELECT 2 AS id, 'saldo' AS nome, 'SALDO' AS codice
		UNION ALL SELECT 3 AS id, 'soluzione unica' AS nome, 'SOLUZIONE_UNICA' AS codice
	) AS c050 ON c050.id = `tipologie_pagamenti`.id AND c050.nome = `tipologie_pagamenti`.nome
	SET `tipologie_pagamenti`.codice = c050.codice
	WHERE `tipologie_pagamenti`.codice IS NULL;

-- | 202611051854

-- tipologie_popup: codice sulle righe del 050
UPDATE IGNORE `tipologie_popup` JOIN (
		SELECT 1 AS id, 'all''apertura della pagina' AS nome, 'ALL_APERTURA_DELLA_PAGINA' AS codice
		UNION ALL SELECT 2 AS id, 'alla chiusura della pagina' AS nome, 'ALLA_CHIUSURA_DELLA_PAGINA' AS codice
		UNION ALL SELECT 3 AS id, 'dopo secondi' AS nome, 'DOPO_SECONDI' AS codice
		UNION ALL SELECT 4 AS id, 'dopo scroll' AS nome, 'DOPO_SCROLL' AS codice
	) AS c050 ON c050.id = `tipologie_popup`.id AND c050.nome = `tipologie_popup`.nome
	SET `tipologie_popup`.codice = c050.codice
	WHERE `tipologie_popup`.codice IS NULL;

-- | 202611051855

-- tipologie_risorse: codice sulle righe del 050
UPDATE IGNORE `tipologie_risorse` JOIN (
		SELECT 1 AS id, 'corso' AS nome, 'CORSO' AS codice
	) AS c050 ON c050.id = `tipologie_risorse`.id AND c050.nome = `tipologie_risorse`.nome
	SET `tipologie_risorse`.codice = c050.codice
	WHERE `tipologie_risorse`.codice IS NULL;

-- | 202611051856

-- tipologie_telefoni: codice sulle righe del 050
UPDATE IGNORE `tipologie_telefoni` JOIN (
		SELECT 1 AS id, 'telefono' AS nome, 'TELEFONO' AS codice
		UNION ALL SELECT 2 AS id, 'mobile' AS nome, 'MOBILE' AS codice
		UNION ALL SELECT 3 AS id, 'fax' AS nome, 'FAX' AS codice
		UNION ALL SELECT 4 AS id, 'telefono/fax' AS nome, 'TELEFONO_FAX' AS codice
	) AS c050 ON c050.id = `tipologie_telefoni`.id AND c050.nome = `tipologie_telefoni`.nome
	SET `tipologie_telefoni`.codice = c050.codice
	WHERE `tipologie_telefoni`.codice IS NULL;

-- | 202611051857

-- tipologie_url: codice sulle righe del 050
UPDATE IGNORE `tipologie_url` JOIN (
		SELECT 1 AS id, 'web' AS nome, 'WEB' AS codice
		UNION ALL SELECT 2 AS id, 'social' AS nome, 'SOCIAL' AS codice
		UNION ALL SELECT 3 AS id, 'servizi' AS nome, 'SERVIZI' AS codice
		UNION ALL SELECT 4 AS id, 'sito' AS nome, 'SITO' AS codice
		UNION ALL SELECT 5 AS id, 'portale' AS nome, 'PORTALE' AS codice
		UNION ALL SELECT 6 AS id, 'e-commerce' AS nome, 'E_COMMERCE' AS codice
		UNION ALL SELECT 7 AS id, 'blog' AS nome, 'BLOG' AS codice
		UNION ALL SELECT 8 AS id, 'landing page' AS nome, 'LANDING_PAGE' AS codice
		UNION ALL SELECT 9 AS id, 'LinkedIn' AS nome, 'LINKEDIN' AS codice
		UNION ALL SELECT 10 AS id, 'Facebook' AS nome, 'FACEBOOK' AS codice
		UNION ALL SELECT 11 AS id, 'Twitter / X' AS nome, 'TWITTER_X' AS codice
		UNION ALL SELECT 12 AS id, 'Instagram' AS nome, 'INSTAGRAM' AS codice
		UNION ALL SELECT 13 AS id, 'YouTube' AS nome, 'YOUTUBE' AS codice
		UNION ALL SELECT 14 AS id, 'TikTok' AS nome, 'TIKTOK' AS codice
		UNION ALL SELECT 15 AS id, 'FTP' AS nome, 'FTP' AS codice
	) AS c050 ON c050.id = `tipologie_url`.id AND c050.nome = `tipologie_url`.nome
	SET `tipologie_url`.codice = c050.codice
	WHERE `tipologie_url`.codice IS NULL;

-- | 202611051858

-- tipologie_attivita: se_corsi sulle righe del 050
UPDATE `tipologie_attivita` SET `se_corsi` = 1
	WHERE `se_corsi` IS NULL AND ( id, nome ) IN ( ( 18, 'didattica' ), ( 15, 'frequenza' ), ( 19, 'assenza' ), ( 30, 'docenza' ), ( 31, 'co-docenza' ), ( 32, 'recupero frequenza' ), ( 33, 'frequenza di prova' ), ( 40, 'lista di attesa' ) );

-- | 202611051859

-- tipologie_todo: se_corsi sulle righe del 050
UPDATE `tipologie_todo` SET `se_corsi` = 1
	WHERE `se_corsi` IS NULL AND ( id, nome ) IN ( ( 6, 'formazione' ), ( 14, 'recupero lezione' ), ( 15, 'lezione' ), ( 17, 'lezione annullata' ), ( 18, 'lezione di prova' ), ( 19, 'open day' ) );

-- | 202611051900

-- tipologie_todo: se_straordinaria sulle righe del 050
UPDATE `tipologie_todo` SET `se_straordinaria` = 1
	WHERE `se_straordinaria` IS NULL AND ( id, nome ) IN ( ( 18, 'lezione di prova' ) );

-- | 202611051901

-- tipologie_todo: se_risorse_umane sulle righe del 050
UPDATE `tipologie_todo` SET `se_risorse_umane` = 1
	WHERE `se_risorse_umane` IS NULL AND ( id, nome ) IN ( ( 16, 'risorse umane' ) );

-- | 202611051902

-- tipologie_todo: se_logistica sulle righe del 050
UPDATE `tipologie_todo` SET `se_logistica` = 1
	WHERE `se_logistica` IS NULL AND ( id, nome ) IN ( ( 20, 'logistica' ) );

-- | FINE
