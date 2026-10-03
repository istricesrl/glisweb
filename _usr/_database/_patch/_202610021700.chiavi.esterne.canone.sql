-- 2026-10-02 — tutte le chiavi esterne del canone, dopo la conversione dei tipi
--
-- Contesto: _202609301100.chiavi.esterne.sql ha portato ai deploy le chiavi esterne dei file di base, ma ha dovuto
-- saltare con "tipi diversi" quelle fra una tabella con id int(11) e una con id bigint(20), che sui deploy erano la
-- maggioranza delle tabelle vecchie contro quelle nuove; e, girata una volta, non ripassa. _202610021500.tipi.canonici.sql
-- ha tolto la causa portando tutto a bigint(20). Nello stesso giro i file di base hanno ricevuto 216 vincoli che non
-- avevano ( le chiavi 98 e 99 di 66 tabelle, 12 id_genitore, 8 tipologie, una cinquantina di riferimenti ), tutti
-- _nofollow perché aggiungere un vincolo non cambi quello che una scheda carica; carrelli_documenti e crediti avevano
-- 98 e 99 scambiate.
--
-- COSA FA. Riprende la lista di TUTTI i vincoli di _060000999999.constraints.sql ( 1.264; quelli delle tabelle di ACL
-- sono dentro la CREATE e i deploy li hanno ) e la passa alla stessa procedura di _202609301100.chiavi.esterne.sql, con
-- le stesse garanzie: un vincolo si aggiunge solo se sulla colonna non ce n'è già uno, se tabella, colonna e
-- riferimento esistono, se i tipi coincidono e se non ci sono righe orfane; altrimenti non fa niente e lo scrive in
-- @chiavi_canone_note. I vincoli presenti si contano come "presente" e non si toccano.
--
-- Poi scambia 98 e 99 dove sono ancora scambiate ( carrelli_documenti, crediti ) e dà a zone_indirizzi.id_zona e
-- zone_stati.id_zona l'indice col nome della colonna, che il canone vuole e che non avevano ( la colonna era servita
-- dalla chiave unica ).
--
-- Va applicata DOPO _202610021500.tipi.canonici.sql e _202610021600.coda.standard.sql: la prima rende i tipi uguali,
-- la seconda crea le colonne id_account_* a cui vanno le chiavi 98 e 99.
--
-- IDEMPOTENTE: una seconda esecuzione trova tutto "presente".

-- | 202610021700

-- la lista di lavoro: una riga per vincolo, con l'esito che la procedura scrive accanto
CREATE TABLE IF NOT EXISTS `__patch_chiavi_canone__` (
  `tabella` char(64) NOT NULL,
  `vincolo` char(64) NOT NULL,
  `colonna` char(64) NOT NULL,
  `riferimento` char(64) NOT NULL,
  `cancellazione` char(16) NOT NULL,
  `aggiornamento` char(16) NOT NULL,
  `condizione` char(128) DEFAULT NULL,
  `vecchio_nome` varchar(64) DEFAULT NULL,
  `vecchia_cancellazione` char(16) DEFAULT NULL,
  `vecchio_aggiornamento` char(16) DEFAULT NULL,
  `esito` char(255) DEFAULT NULL,
  PRIMARY KEY (`tabella`,`vincolo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- | 202610021701

-- i vincoli del canone, parte 1 di 13
INSERT IGNORE INTO `__patch_chiavi_canone__` ( `tabella`, `vincolo`, `colonna`, `riferimento`, `cancellazione`, `aggiornamento`, `condizione` ) VALUES
( 'account', 'account_ibfk_01_nofollow', 'id_anagrafica', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'account', 'account_ibfk_02_nofollow', 'id_mail', 'mail', 'SET NULL', 'SET NULL', NULL ),
( 'account', 'account_ibfk_03_nofollow', 'id_affiliazione', 'contratti', 'SET NULL', 'SET NULL', NULL ),
( 'account', 'account_ibfk_04', 'id_url', 'url', 'SET NULL', 'SET NULL', NULL ),
( 'account', 'account_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'account', 'account_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'account_gruppi', 'account_gruppi_ibfk_01', 'id_account', 'account', 'CASCADE', 'CASCADE', NULL ),
( 'account_gruppi', 'account_gruppi_ibfk_02_nofollow', 'id_gruppo', 'gruppi', 'CASCADE', 'CASCADE', NULL ),
( 'account_gruppi', 'account_gruppi_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'account_gruppi', 'account_gruppi_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'account_gruppi_attribuzione', 'account_gruppi_attribuzione_ibfk_01', 'id_account', 'account', 'CASCADE', 'CASCADE', NULL ),
( 'account_gruppi_attribuzione', 'account_gruppi_attribuzione_ibfk_02_nofollow', 'id_gruppo', 'gruppi', 'CASCADE', 'CASCADE', NULL ),
( 'account_gruppi_attribuzione', 'account_gruppi_attribuzione_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'account_gruppi_attribuzione', 'account_gruppi_attribuzione_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'anagrafica', 'anagrafica_ibfk_01_nofollow', 'id_tipologia', 'tipologie_anagrafica', 'NO ACTION', 'CASCADE', NULL ),
( 'anagrafica', 'anagrafica_ibfk_02_nofollow', 'id_badge', 'badge', 'SET NULL', 'SET NULL', NULL ),
( 'anagrafica', 'anagrafica_ibfk_03_nofollow', 'id_pec_sdi', 'mail', 'SET NULL', 'SET NULL', NULL ),
( 'anagrafica', 'anagrafica_ibfk_04_nofollow', 'id_regime', 'regimi', 'SET NULL', 'SET NULL', NULL ),
( 'anagrafica', 'anagrafica_ibfk_07_nofollow', 'id_ranking', 'ranking', 'SET NULL', 'SET NULL', NULL ),
( 'anagrafica', 'anagrafica_ibfk_08_nofollow', 'id_agente', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'anagrafica', 'anagrafica_ibfk_09_nofollow', 'id_responsabile_operativo', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'anagrafica', 'anagrafica_ibfk_10_nofollow', 'id_rappresentante_fiscale', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'anagrafica', 'anagrafica_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'anagrafica', 'anagrafica_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'anagrafica_categorie', 'anagrafica_categorie_ibfk_01', 'id_anagrafica', 'anagrafica', 'CASCADE', 'CASCADE', NULL ),
( 'anagrafica_categorie', 'anagrafica_categorie_ibfk_02_nofollow', 'id_categoria', 'categorie_anagrafica', 'CASCADE', 'CASCADE', NULL ),
( 'anagrafica_categorie', 'anagrafica_categorie_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'anagrafica_categorie', 'anagrafica_categorie_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'anagrafica_certificazioni', 'anagrafica_certificazioni_ibfk_01', 'id_anagrafica', 'anagrafica', 'CASCADE', 'CASCADE', NULL ),
( 'anagrafica_certificazioni', 'anagrafica_certificazioni_ibfk_02_nofollow', 'id_certificazione', 'certificazioni', 'CASCADE', 'CASCADE', NULL ),
( 'anagrafica_certificazioni', 'anagrafica_certificazioni_ibfk_03_nofollow', 'id_emittente', 'anagrafica', 'CASCADE', 'CASCADE', NULL ),
( 'anagrafica_certificazioni', 'anagrafica_certificazioni_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'anagrafica_certificazioni', 'anagrafica_certificazioni_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'anagrafica_cittadinanze', 'anagrafica_cittadinanze_ibfk_01', 'id_anagrafica', 'anagrafica', 'CASCADE', 'CASCADE', NULL ),
( 'anagrafica_cittadinanze', 'anagrafica_cittadinanze_ibfk_02_nofollow', 'id_stato', 'stati', 'SET NULL', 'SET NULL', NULL ),
( 'anagrafica_cittadinanze', 'anagrafica_cittadinanze_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'anagrafica_cittadinanze', 'anagrafica_cittadinanze_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'anagrafica_consensi', 'anagrafica_consensi_ibfk_01_nofollow', 'id_account', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'anagrafica_consensi', 'anagrafica_consensi_ibfk_02', 'id_anagrafica', 'anagrafica', 'CASCADE', 'CASCADE', NULL ),
( 'anagrafica_consensi', 'anagrafica_consensi_ibfk_03_nofollow', 'id_consenso', 'consensi', 'CASCADE', 'CASCADE', NULL ),
( 'anagrafica_consensi', 'anagrafica_consensi_ibfk_04', 'id_mail', 'mail', 'CASCADE', 'CASCADE', NULL ),
( 'anagrafica_consensi', 'anagrafica_consensi_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'anagrafica_consensi', 'anagrafica_consensi_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'anagrafica_indirizzi', 'anagrafica_indirizzi_ibfk_01', 'id_anagrafica', 'anagrafica', 'CASCADE', 'CASCADE', NULL ),
( 'anagrafica_indirizzi', 'anagrafica_indirizzi_ibfk_02_nofollow', 'id_indirizzo', 'indirizzi', 'CASCADE', 'CASCADE', NULL ),
( 'anagrafica_indirizzi', 'anagrafica_indirizzi_ibfk_03_nofollow', 'id_ruolo', 'ruoli_indirizzi', 'NO ACTION', 'CASCADE', NULL ),
( 'anagrafica_indirizzi', 'anagrafica_indirizzi_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'anagrafica_indirizzi', 'anagrafica_indirizzi_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'anagrafica_indirizzi', 'anagrafica_indirizzi_ibfk_04_nofollow', 'id_tipologia', 'tipologie_indirizzi', 'NO ACTION', 'CASCADE', NULL ),
( 'anagrafica_progetti', 'anagrafica_progetti_ibfk_01', 'id_anagrafica', 'anagrafica', 'CASCADE', 'CASCADE', NULL ),
( 'anagrafica_progetti', 'anagrafica_progetti_ibfk_02_nofollow', 'id_progetto', 'progetti', 'CASCADE', 'CASCADE', NULL ),
( 'anagrafica_progetti', 'anagrafica_progetti_ibfk_03_nofollow', 'id_ruolo', 'ruoli_progetti', 'NO ACTION', 'CASCADE', NULL ),
( 'anagrafica_progetti', 'anagrafica_progetti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'anagrafica_progetti', 'anagrafica_progetti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'anagrafica_progetti', 'anagrafica_progetti_ibfk_04_nofollow', 'id_todo', 'todo', 'SET NULL', 'SET NULL', NULL ),
( 'anagrafica_progetti', 'anagrafica_progetti_ibfk_05_nofollow', 'id_account_archiviazione', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'anagrafica_settori', 'anagrafica_settori_ibfk_01', 'id_anagrafica', 'anagrafica', 'CASCADE', 'CASCADE', NULL ),
( 'anagrafica_settori', 'anagrafica_settori_ibfk_02_nofollow', 'id_settore', 'settori', 'CASCADE', 'CASCADE', NULL ),
( 'anagrafica_settori', 'anagrafica_settori_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'anagrafica_settori', 'anagrafica_settori_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'annunci', 'annunci_ibfk_01_nofollow', 'id_tipologia', 'tipologie_annunci', 'NO ACTION', 'CASCADE', NULL ),
( 'annunci', 'annunci_ibfk_02_nofollow', 'id_categoria_prodotti', 'categorie_prodotti', 'SET NULL', 'SET NULL', NULL ),
( 'annunci', 'annunci_ibfk_03_nofollow', 'id_prodotto', 'prodotti', 'SET NULL', 'SET NULL', NULL ),
( 'annunci', 'annunci_ibfk_04_nofollow', 'id_articolo', 'articoli', 'CASCADE', 'CASCADE', NULL ),
( 'annunci', 'annunci_ibfk_05_nofollow', 'id_udm', 'udm', 'SET NULL', 'SET NULL', NULL ),
( 'annunci', 'annunci_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'annunci', 'annunci_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'annunci_categorie', 'annunci_categorie_ibfk_01_nofollow', 'id_annuncio', 'annunci', 'CASCADE', 'CASCADE', NULL ),
( 'annunci_categorie', 'annunci_categorie_ibfk_02_nofollow', 'id_categoria', 'categorie_annunci', 'SET NULL', 'SET NULL', NULL ),
( 'annunci_categorie', 'annunci_categorie_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'annunci_categorie', 'annunci_categorie_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'articoli', 'articoli_ibfk_01_nofollow', 'id_prodotto', 'prodotti', 'SET NULL', 'SET NULL', NULL ),
( 'articoli', 'articoli_ibfk_02_nofollow', 'id_reparto', 'reparti', 'SET NULL', 'SET NULL', NULL ),
( 'articoli', 'articoli_ibfk_03_nofollow', 'id_colore', 'colori', 'SET NULL', 'SET NULL', NULL ),
( 'articoli', 'articoli_ibfk_04_nofollow', 'id_periodicita', 'periodicita', 'SET NULL', 'SET NULL', NULL ),
( 'articoli', 'articoli_ibfk_05_nofollow', 'id_tipologia_rinnovo', 'tipologie_rinnovi', 'NO ACTION', 'CASCADE', NULL ),
( 'articoli', 'articoli_ibfk_06_nofollow', 'id_udm_dimensioni', 'udm', 'SET NULL', 'SET NULL', NULL ),
( 'articoli', 'articoli_ibfk_07_nofollow', 'id_udm_peso', 'udm', 'SET NULL', 'SET NULL', NULL ),
( 'articoli', 'articoli_ibfk_08_nofollow', 'id_udm_volume', 'udm', 'SET NULL', 'SET NULL', NULL ),
( 'articoli', 'articoli_ibfk_09_nofollow', 'id_udm_capacita', 'udm', 'SET NULL', 'SET NULL', NULL ),
( 'articoli', 'articoli_ibfk_10_nofollow', 'id_udm_durata', 'udm', 'SET NULL', 'SET NULL', NULL ),
( 'articoli', 'articoli_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'articoli', 'articoli_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'articoli', 'articoli_ibfk_11_nofollow', 'id_taglia', 'taglie', 'SET NULL', 'SET NULL', NULL ),
( 'articoli_caratteristiche', 'articoli_caratteristiche_ibfk_01', 'id_articolo', 'articoli', 'CASCADE', 'CASCADE', NULL ),
( 'articoli_caratteristiche', 'articoli_caratteristiche_ibfk_02_nofollow', 'id_caratteristica', 'caratteristiche', 'CASCADE', 'CASCADE', NULL ),
( 'articoli_caratteristiche', 'articoli_caratteristiche_ibfk_03_nofollow', 'id_lingua', 'lingue', 'SET NULL', 'SET NULL', NULL ),
( 'articoli_caratteristiche', 'articoli_caratteristiche_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'articoli_caratteristiche', 'articoli_caratteristiche_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'asset', 'asset_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'asset', 'asset_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'attivita', 'attivita_ibfk_01_nofollow', 'id_genitore', 'attivita', 'NO ACTION', 'CASCADE', NULL ),
( 'attivita', 'attivita_ibfk_02_nofollow', 'id_tipologia', 'tipologie_attivita', 'NO ACTION', 'CASCADE', NULL ),
( 'attivita', 'attivita_ibfk_03_nofollow', 'id_cliente', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'attivita', 'attivita_ibfk_04_nofollow', 'id_indirizzo', 'indirizzi', 'SET NULL', 'SET NULL', NULL ),
( 'attivita', 'attivita_ibfk_05_nofollow', 'id_luogo', 'luoghi', 'SET NULL', 'SET NULL', NULL ),
( 'attivita', 'attivita_ibfk_06_nofollow', 'id_oggetto', 'asset', 'SET NULL', 'SET NULL', NULL ),
( 'attivita', 'attivita_ibfk_07_nofollow', 'id_anagrafica_programmazione', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'attivita', 'attivita_ibfk_08_nofollow', 'id_anagrafica', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'attivita', 'attivita_ibfk_09_nofollow', 'id_asset', 'asset', 'SET NULL', 'SET NULL', NULL );

-- | 202610021702

-- i vincoli del canone, parte 2 di 13
INSERT IGNORE INTO `__patch_chiavi_canone__` ( `tabella`, `vincolo`, `colonna`, `riferimento`, `cancellazione`, `aggiornamento`, `condizione` ) VALUES
( 'attivita', 'attivita_ibfk_10_nofollow', 'id_mailing', 'mailing', 'SET NULL', 'SET NULL', NULL ),
( 'attivita', 'attivita_ibfk_11_nofollow', 'id_mail', 'mail', 'SET NULL', 'SET NULL', NULL ),
( 'attivita', 'attivita_ibfk_12_nofollow', 'id_documento', 'documenti', 'SET NULL', 'SET NULL', NULL ),
( 'attivita', 'attivita_ibfk_13_nofollow', 'id_corrispondenza', 'corrispondenza', 'SET NULL', 'SET NULL', NULL ),
( 'attivita', 'attivita_ibfk_14_nofollow', 'id_pagamento', 'pagamenti', 'SET NULL', 'SET NULL', NULL ),
( 'attivita', 'attivita_ibfk_15_nofollow', 'id_progetto', 'progetti', 'SET NULL', 'SET NULL', NULL ),
( 'attivita', 'attivita_ibfk_16_nofollow', 'id_contratto', 'contratti', 'SET NULL', 'SET NULL', NULL ),
( 'attivita', 'attivita_ibfk_17_nofollow', 'id_todo', 'todo', 'SET NULL', 'SET NULL', NULL ),
( 'attivita', 'attivita_ibfk_18_nofollow', 'id_mastro_provenienza', 'mastri', 'SET NULL', 'SET NULL', NULL ),
( 'attivita', 'attivita_ibfk_19_nofollow', 'id_mastro_destinazione', 'mastri', 'SET NULL', 'SET NULL', NULL ),
( 'attivita', 'attivita_ibfk_20_nofollow', 'id_matricola', 'matricole', 'SET NULL', 'SET NULL', NULL ),
( 'attivita', 'attivita_ibfk_21_nofollow', 'id_immobile', 'immobili', 'SET NULL', 'SET NULL', NULL ),
( 'attivita', 'attivita_ibfk_22_nofollow', 'id_pianificazione', 'pianificazioni', 'SET NULL', 'SET NULL', NULL ),
( 'attivita', 'attivita_ibfk_23_nofollow', 'id_contatto', 'contatti', 'SET NULL', 'SET NULL', NULL ),
( 'attivita', 'attivita_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'attivita', 'attivita_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'attivita', 'attivita_ibfk_24_nofollow', 'id_messaggio', 'messaggi', 'SET NULL', 'SET NULL', NULL ),
( 'attivita', 'attivita_ibfk_25_nofollow', 'id_account', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'attivita', 'attivita_ibfk_26_nofollow', 'id_step', 'step', 'SET NULL', 'SET NULL', NULL ),
( 'attivita', 'attivita_ibfk_27_nofollow', 'id_account_archiviazione', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'audio', 'audio_ibfk_01', 'id_anagrafica', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'audio', 'audio_ibfk_02', 'id_pagina', 'pagine', 'SET NULL', 'SET NULL', NULL ),
( 'audio', 'audio_ibfk_03', 'id_file', 'file', 'SET NULL', 'SET NULL', NULL ),
( 'audio', 'audio_ibfk_04', 'id_prodotto', 'prodotti', 'SET NULL', 'SET NULL', NULL ),
( 'audio', 'audio_ibfk_05', 'id_articolo', 'articoli', 'SET NULL', 'SET NULL', NULL ),
( 'audio', 'audio_ibfk_06', 'id_categoria_prodotti', 'categorie_prodotti', 'SET NULL', 'SET NULL', NULL ),
( 'audio', 'audio_ibfk_07', 'id_risorsa', 'risorse', 'SET NULL', 'SET NULL', NULL ),
( 'audio', 'audio_ibfk_09', 'id_notizia', 'notizie', 'SET NULL', 'SET NULL', NULL ),
( 'audio', 'audio_ibfk_10', 'id_categoria_notizie', 'categorie_notizie', 'SET NULL', 'SET NULL', NULL ),
( 'audio', 'audio_ibfk_11', 'id_annuncio', 'annunci', 'SET NULL', 'SET NULL', NULL ),
( 'audio', 'audio_ibfk_12', 'id_categoria_annunci', 'categorie_annunci', 'SET NULL', 'SET NULL', NULL ),
( 'audio', 'audio_ibfk_13_nofollow', 'id_lingua', 'lingue', 'SET NULL', 'SET NULL', NULL ),
( 'audio', 'audio_ibfk_14_nofollow', 'id_ruolo', 'ruoli_audio', 'NO ACTION', 'CASCADE', NULL ),
( 'audio', 'audio_ibfk_16', 'id_progetto', 'progetti', 'SET NULL', 'SET NULL', NULL ),
( 'audio', 'audio_ibfk_17', 'id_categoria_progetti', 'categorie_progetti', 'SET NULL', 'SET NULL', NULL ),
( 'audio', 'audio_ibfk_18', 'id_indirizzo', 'indirizzi', 'SET NULL', 'SET NULL', NULL ),
( 'audio', 'audio_ibfk_19', 'id_edificio', 'edifici', 'SET NULL', 'SET NULL', NULL ),
( 'audio', 'audio_ibfk_20', 'id_immobile', 'immobili', 'SET NULL', 'SET NULL', NULL ),
( 'audio', 'audio_ibfk_22', 'id_marchio', 'marchi', 'SET NULL', 'SET NULL', NULL ),
( 'audio', 'audio_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'audio', 'audio_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'badge', 'badge_ibfk_01_nofollow', 'id_tipologia', 'tipologie_badge', 'NO ACTION', 'CASCADE', NULL ),
( 'badge', 'badge_ibfk_02', 'id_contratto', 'contratti', 'SET NULL', 'SET NULL', NULL ),
( 'badge', 'badge_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'badge', 'badge_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'banner', 'banner_ibfk_01_nofollow', 'id_tipologia', 'tipologie_banner', 'NO ACTION', 'CASCADE', NULL ),
( 'banner', 'banner_ibfk_02_nofollow', 'id_inserzionista', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'banner', 'banner_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'banner', 'banner_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'banner_azioni', 'banner_azioni_ibfk_01', 'id_banner', 'banner', 'SET NULL', 'SET NULL', NULL ),
( 'banner_azioni', 'banner_azioni_ibfk_02_nofollow', 'id_pagina', 'pagine', 'SET NULL', 'SET NULL', NULL ),
( 'banner_azioni', 'banner_azioni_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'banner_azioni', 'banner_azioni_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'banner_pagine', 'banner_pagine_ibfk_01', 'id_banner', 'banner', 'CASCADE', 'CASCADE', NULL ),
( 'banner_pagine', 'banner_pagine_ibfk_02_nofollow', 'id_pagina', 'pagine', 'CASCADE', 'CASCADE', NULL ),
( 'banner_pagine', 'banner_pagine_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'banner_pagine', 'banner_pagine_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'banner_zone', 'banner_zone_ibfk_01', 'id_banner', 'banner', 'CASCADE', 'CASCADE', NULL ),
( 'banner_zone', 'banner_zone_ibfk_02_nofollow', 'id_zona', 'zone', 'CASCADE', 'CASCADE', NULL ),
( 'banner_zone', 'banner_zone_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'banner_zone', 'banner_zone_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'campagne', 'campagne_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'campagne', 'campagne_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'caratteristiche', 'caratteristiche_ibfk_01_nofollow', 'id_genitore', 'caratteristiche', 'NO ACTION', 'CASCADE', NULL ),
( 'caratteristiche', 'caratteristiche_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'caratteristiche', 'caratteristiche_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli', 'carrelli_ibfk_01', 'destinatario_id_anagrafica', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli', 'carrelli_ibfk_08', 'intestazione_id_anagrafica', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli', 'carrelli_ibfk_15_nofollow', 'id_listino', 'listini', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli', 'carrelli_ibfk_16_nofollow', 'id_documento', 'documenti', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli', 'carrelli_ibfk_17_nofollow', 'id_coupon', 'coupon', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli', 'carrelli_ibfk_18_nofollow', 'id_campagna', 'campagne', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli', 'carrelli_ibfk_19_nofollow', 'id_reseller', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli', 'carrelli_ibfk_20_nofollow', 'id_affiliato', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli', 'carrelli_ibfk_21_nofollow', 'intestazione_id_account', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli', 'carrelli_ibfk_22_nofollow', 'destinatario_id_account', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli', 'carrelli_ibfk_23_nofollow', 'fatturazione_id_tipologia_documento', 'tipologie_documenti', 'NO ACTION', 'CASCADE', NULL ),
( 'carrelli', 'carrelli_ibfk_25_nofollow', 'intestazione_id_tipologia_anagrafica', 'tipologie_anagrafica', 'NO ACTION', 'CASCADE', NULL ),
( 'carrelli', 'carrelli_ibfk_26_nofollow', 'destinatario_id_tipologia_anagrafica', 'tipologie_anagrafica', 'NO ACTION', 'CASCADE', NULL ),
( 'carrelli', 'carrelli_ibfk_27_nofollow', 'id_affiliazione', 'contratti', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli', 'carrelli_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli', 'carrelli_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli', 'carrelli_ibfk_28_nofollow', 'id_zona', 'zone', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli', 'carrelli_ibfk_29_nofollow', 'id_account_evasione', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli_articoli', 'carrelli_articoli_ibfk_01', 'id_carrello', 'carrelli', 'CASCADE', 'CASCADE', NULL ),
( 'carrelli_articoli', 'carrelli_articoli_ibfk_02_nofollow', 'id_articolo', 'articoli', 'CASCADE', 'CASCADE', NULL ),
( 'carrelli_articoli', 'carrelli_articoli_ibfk_03_nofollow', 'id_iva', 'iva', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli_articoli', 'carrelli_articoli_ibfk_04_nofollow', 'id_pagamento', 'pagamenti', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli_articoli', 'carrelli_articoli_ibfk_05', 'destinatario_id_anagrafica', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli_articoli', 'carrelli_articoli_ibfk_12_nofollow', 'id_rinnovo', 'rinnovi', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli_articoli', 'carrelli_articoli_ibfk_13_nofollow', 'id_coupon', 'coupon', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli_articoli', 'carrelli_articoli_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli_articoli', 'carrelli_articoli_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli_articoli', 'carrelli_articoli_ibfk_14_nofollow', 'id_listino', 'listini', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli_articoli', 'carrelli_articoli_ibfk_15_nofollow', 'id_mastro_provenienza', 'mastri', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli_articoli', 'carrelli_articoli_ibfk_16_nofollow', 'id_account_evasione', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli_consensi', 'carrelli_consensi_ibfk_01_nofollow', 'id_account', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli_consensi', 'carrelli_consensi_ibfk_02_nofollow', 'id_anagrafica', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli_consensi', 'carrelli_consensi_ibfk_03', 'id_carrello', 'carrelli', 'CASCADE', 'CASCADE', NULL ),
( 'carrelli_consensi', 'carrelli_consensi_ibfk_04_nofollow', 'id_consenso', 'consensi', 'CASCADE', 'CASCADE', NULL );

-- | 202610021703

-- i vincoli del canone, parte 3 di 13
INSERT IGNORE INTO `__patch_chiavi_canone__` ( `tabella`, `vincolo`, `colonna`, `riferimento`, `cancellazione`, `aggiornamento`, `condizione` ) VALUES
( 'carrelli_consensi', 'carrelli_consensi_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli_consensi', 'carrelli_consensi_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'distinta', 'distinta_ibfk_01', 'id_articolo', 'articoli', 'CASCADE', 'CASCADE', NULL ),
( 'distinta', 'distinta_ibfk_02_nofollow', 'id_componente', 'articoli', 'CASCADE', 'CASCADE', NULL ),
( 'distinta', 'distinta_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'distinta', 'distinta_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli_documenti', 'carrelli_documenti_ibfk_01', 'id_carrello', 'carrelli', 'CASCADE', 'CASCADE', NULL ),
( 'carrelli_documenti', 'carrelli_documenti_ibfk_02_nofollow', 'id_documento', 'documenti', 'CASCADE', 'CASCADE', NULL ),
( 'carrelli_documenti', 'carrelli_documenti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli_documenti', 'carrelli_documenti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'casse_previdenziali', 'casse_previdenziali_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'casse_previdenziali', 'casse_previdenziali_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'categorie_anagrafica', 'categorie_anagrafica_ibfk_01_nofollow', 'id_genitore', 'categorie_anagrafica', 'NO ACTION', 'CASCADE', NULL ),
( 'categorie_anagrafica', 'categorie_anagrafica_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'categorie_anagrafica', 'categorie_anagrafica_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'categorie_annunci', 'categorie_annunci_ibfk_01_nofollow', 'id_genitore', 'categorie_annunci', 'NO ACTION', 'CASCADE', NULL ),
( 'categorie_annunci', 'categorie_annunci_ibfk_02_nofollow', 'id_pagina', 'pagine', 'SET NULL', 'SET NULL', NULL ),
( 'categorie_annunci', 'categorie_annunci_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'categorie_annunci', 'categorie_annunci_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'categorie_notizie', 'categorie_notizie_ibfk_01_nofollow', 'id_genitore', 'categorie_notizie', 'NO ACTION', 'CASCADE', NULL ),
( 'categorie_notizie', 'categorie_notizie_ibfk_02_nofollow', 'id_pagina', 'pagine', 'SET NULL', 'SET NULL', NULL ),
( 'categorie_notizie', 'categorie_notizie_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'categorie_notizie', 'categorie_notizie_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'categorie_prodotti', 'categorie_prodotti_ibfk_01_nofollow', 'id_genitore', 'categorie_prodotti', 'NO ACTION', 'CASCADE', NULL ),
( 'categorie_prodotti', 'categorie_prodotti_ibfk_02_nofollow', 'id_pagina', 'pagine', 'SET NULL', 'SET NULL', NULL ),
( 'categorie_prodotti', 'categorie_prodotti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'categorie_prodotti', 'categorie_prodotti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'categorie_progetti', 'categorie_progetti_ibfk_01_nofollow', 'id_genitore', 'categorie_progetti', 'NO ACTION', 'CASCADE', NULL ),
( 'categorie_progetti', 'categorie_progetti_ibfk_02_nofollow', 'id_pagina', 'pagine', 'SET NULL', 'SET NULL', NULL ),
( 'categorie_progetti', 'categorie_progetti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'categorie_progetti', 'categorie_progetti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'categorie_risorse', 'categorie_risorse_ibfk_01_nofollow', 'id_genitore', 'categorie_risorse', 'NO ACTION', 'CASCADE', NULL ),
( 'categorie_risorse', 'categorie_risorse_ibfk_02_nofollow', 'id_pagina', 'pagine', 'SET NULL', 'SET NULL', NULL ),
( 'categorie_risorse', 'categorie_risorse_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'categorie_risorse', 'categorie_risorse_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'causali', 'causali_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'causali', 'causali_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'certificazioni', 'certificazioni_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'certificazioni', 'certificazioni_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'chiavi', 'chiavi_ibfk_01_nofollow', 'id_licenza', 'licenze', 'SET NULL', 'SET NULL', NULL ),
( 'chiavi', 'chiavi_ibfk_02_nofollow', 'id_tipologia', 'tipologie_chiavi', 'NO ACTION', 'CASCADE', NULL ),
( 'chiavi', 'chiavi_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'chiavi', 'chiavi_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'classi_energetiche', 'classi_energetiche_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'classi_energetiche', 'classi_energetiche_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'colli', 'colli_ibfk_01_nofollow', 'id_documento', 'documenti', 'SET NULL', 'SET NULL', NULL ),
( 'colli', 'colli_ibfk_02_nofollow', 'id_udm_dimensioni', 'udm', 'SET NULL', 'SET NULL', NULL ),
( 'colli', 'colli_ibfk_03_nofollow', 'id_udm_peso', 'udm', 'SET NULL', 'SET NULL', NULL ),
( 'colli', 'colli_ibfk_04_nofollow', 'id_udm_volume', 'udm', 'SET NULL', 'SET NULL', NULL ),
( 'colli', 'colli_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'colli', 'colli_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'colli', 'colli_ibfk_05_nofollow', 'id_genitore', 'colli', 'NO ACTION', 'CASCADE', NULL ),
( 'colli', 'colli_ibfk_06_nofollow', 'id_tipologia', 'tipologie_colli', 'NO ACTION', 'CASCADE', NULL ),
( 'colli', 'colli_ibfk_07_nofollow', 'id_mittente', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'colli', 'colli_ibfk_08_nofollow', 'id_destinatario', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'colli', 'colli_ibfk_09_nofollow', 'id_anagrafica', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'colli', 'colli_ibfk_10_nofollow', 'id_mastro', 'mastri', 'SET NULL', 'SET NULL', NULL ),
( 'colori', 'colori_ibfk_01_nofollow', 'id_genitore', 'colori', 'NO ACTION', 'CASCADE', NULL ),
( 'colori', 'colori_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'colori', 'colori_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'comuni', 'comuni_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'comuni', 'comuni_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'condizioni_pagamento', 'condizioni_pagamento_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'condizioni_pagamento', 'condizioni_pagamento_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'condizioni', 'condizioni_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'condizioni', 'condizioni_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'consensi', 'consensi_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'consensi', 'consensi_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'consensi_moduli', 'consensi_moduli_ibfk_01_nofollow', 'id_lingua', 'lingue', 'SET NULL', 'SET NULL', NULL ),
( 'consensi_moduli', 'consensi_moduli_ibfk_02_nofollow', 'id_consenso', 'consensi', 'SET NULL', 'SET NULL', NULL ),
( 'consensi_moduli', 'consensi_moduli_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'consensi_moduli', 'consensi_moduli_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'consensi_contatti', 'consensi_contatti_ibfk_01_nofollow', 'id_consenso', 'consensi', 'CASCADE', 'CASCADE', NULL ),
( 'consensi_contatti', 'consensi_contatti_ibfk_02_nofollow', 'id_contatto', 'contatti', 'CASCADE', 'CASCADE', NULL ),
( 'consensi_contatti', 'consensi_contatti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'consensi_contatti', 'consensi_contatti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'contatti', 'contatti_ibfk_01_nofollow', 'id_tipologia', 'tipologie_contatti', 'NO ACTION', 'CASCADE', NULL ),
( 'contatti', 'contatti_ibfk_02_nofollow', 'id_anagrafica', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'contatti', 'contatti_ibfk_03_nofollow', 'id_inviante', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'contatti', 'contatti_ibfk_04_nofollow', 'id_ranking', 'ranking', 'SET NULL', 'SET NULL', NULL ),
( 'contatti', 'contatti_ibfk_05_nofollow', 'id_campagna', 'campagne', 'SET NULL', 'SET NULL', NULL ),
( 'contatti', 'contatti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'contatti', 'contatti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_01_nofollow', 'id_lingua', 'lingue', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_02', 'id_anagrafica', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_03', 'id_prodotto', 'prodotti', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_04', 'id_articolo', 'articoli', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_05', 'id_categoria_prodotti', 'categorie_prodotti', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_06', 'id_caratteristica', 'caratteristiche', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_07', 'id_marchio', 'marchi', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_08', 'id_file', 'file', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_09', 'id_immagine', 'immagini', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_10', 'id_video', 'video', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_11', 'id_audio', 'audio', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_12', 'id_risorsa', 'risorse', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_13', 'id_categoria_risorse', 'categorie_risorse', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_14', 'id_pagina', 'pagine', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_15', 'id_popup', 'popup', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_16', 'id_indirizzo', 'indirizzi', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_17', 'id_notizia', 'notizie', 'SET NULL', 'SET NULL', NULL );

-- | 202610021704

-- i vincoli del canone, parte 4 di 13
INSERT IGNORE INTO `__patch_chiavi_canone__` ( `tabella`, `vincolo`, `colonna`, `riferimento`, `cancellazione`, `aggiornamento`, `condizione` ) VALUES
( 'contenuti', 'contenuti_ibfk_18', 'id_annuncio', 'annunci', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_19', 'id_categoria_notizie', 'categorie_notizie', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_20', 'id_categoria_annunci', 'categorie_annunci', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_21', 'id_template', 'template', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_22', 'id_mailing', 'mailing', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_23', 'id_colore', 'colori', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_24', 'id_progetto', 'progetti', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_25', 'id_categoria_progetti', 'categorie_progetti', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_26', 'id_edificio', 'edifici', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_27', 'id_immobile', 'immobili', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_28', 'id_banner', 'banner', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'continenti', 'continenti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'continenti', 'continenti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'contratti', 'contratti_ibfk_01_nofollow', 'id_tipologia', 'tipologie_contratti', 'NO ACTION', 'CASCADE', NULL ),
( 'contratti', 'contratti_ibfk_04_nofollow', 'id_progetto', 'progetti', 'SET NULL', 'SET NULL', NULL ),
( 'contratti', 'contratti_ibfk_05_nofollow', 'id_categoria_progetti', 'categorie_progetti', 'SET NULL', 'SET NULL', NULL ),
( 'contratti', 'contratti_ibfk_06_nofollow', 'id_immobile', 'immobili', 'SET NULL', 'SET NULL', NULL ),
( 'contratti', 'contratti_ibfk_07_nofollow', 'id_badge', 'badge', 'SET NULL', 'SET NULL', NULL ),
( 'contratti', 'contratti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'contratti', 'contratti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'contratti_anagrafica', 'contratti_anagrafica_ibfk_01', 'id_contratto', 'contratti', 'CASCADE', 'CASCADE', NULL ),
( 'contratti_anagrafica', 'contratti_anagrafica_ibfk_02_nofollow', 'id_anagrafica', 'anagrafica', 'CASCADE', 'CASCADE', NULL ),
( 'contratti_anagrafica', 'contratti_anagrafica_ibfk_03_nofollow', 'id_ruolo', 'ruoli_anagrafica', 'NO ACTION', 'CASCADE', NULL ),
( 'contratti_anagrafica', 'contratti_anagrafica_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'contratti_anagrafica', 'contratti_anagrafica_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'contratti_progetti', 'contratti_progetti_ibfk_01', 'id_contratto', 'contratti', 'CASCADE', 'CASCADE', NULL ),
( 'contratti_progetti', 'contratti_progetti_ibfk_02_nofollow', 'id_progetto', 'progetti', 'CASCADE', 'CASCADE', NULL ),
( 'contratti_progetti', 'contratti_progetti_ibfk_03_nofollow', 'id_ruolo', 'ruoli_anagrafica', 'NO ACTION', 'CASCADE', NULL ),
( 'contratti_progetti', 'contratti_progetti_ibfk_97_nofollow', 'id_account_archiviazione', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'contratti_progetti', 'contratti_progetti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'contratti_progetti', 'contratti_progetti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'conversazioni', 'conversazioni_ibfk_01_nofollow', 'id_annuncio', 'annunci', 'SET NULL', 'SET NULL', NULL ),
( 'conversazioni', 'conversazioni_ibfk_02_nofollow', 'id_articolo', 'articoli', 'CASCADE', 'CASCADE', NULL ),
( 'conversazioni', 'conversazioni_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'conversazioni', 'conversazioni_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'conversazioni_account', 'conversazioni_account_ibfk_01_nofollow', 'id_account', 'account', 'CASCADE', 'CASCADE', NULL ),
( 'conversazioni_account', 'conversazioni_account_ibfk_02_nofollow', 'id_conversazione', 'conversazioni', 'CASCADE', 'CASCADE', NULL ),
( 'conversazioni_account', 'conversazioni_account_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'conversazioni_account', 'conversazioni_account_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'corrispondenza', 'corrispondenza_ibfk_01_nofollow', 'id_tipologia', 'tipologie_corrispondenza', 'NO ACTION', 'CASCADE', NULL ),
( 'corrispondenza', 'corrispondenza_ibfk_02_nofollow', 'id_peso', 'pesi_tipologie_corrispondenza', 'SET NULL', 'SET NULL', NULL ),
( 'corrispondenza', 'corrispondenza_ibfk_04_nofollow', 'id_mittente', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'corrispondenza', 'corrispondenza_ibfk_05_nofollow', 'id_organizzazione_mittente', 'organizzazioni', 'SET NULL', 'SET NULL', NULL ),
( 'corrispondenza', 'corrispondenza_ibfk_06_nofollow', 'id_commesso', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'corrispondenza', 'corrispondenza_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'corrispondenza', 'corrispondenza_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'corrispondenza', 'corrispondenza_ibfk_07_nofollow', 'id_distinta', 'distinta', 'SET NULL', 'SET NULL', NULL ),
( 'costi_contratti', 'costi_contratti_ibfk_01', 'id_contratto', 'contratti', 'CASCADE', 'CASCADE', NULL ),
( 'costi_contratti', 'costi_contratti_ibfk_02_nofollow', 'id_tipologia', 'tipologie_attivita_inps', 'NO ACTION', 'CASCADE', NULL ),
( 'costi_contratti', 'costi_contratti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'costi_contratti', 'costi_contratti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'coupon', 'coupon_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'coupon', 'coupon_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'coupon', 'coupon_ibfk_01_nofollow', 'id_anagrafica', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'coupon_articoli', 'coupon_articoli_ibfk_01_nofollow', 'id_coupon', 'coupon', 'CASCADE', 'CASCADE', NULL ),
( 'coupon_articoli', 'coupon_articoli_ibfk_02_nofollow', 'id_articolo', 'articoli', 'CASCADE', 'CASCADE', NULL ),
( 'coupon_articoli', 'coupon_articoli_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'coupon_articoli', 'coupon_articoli_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'coupon_categorie_prodotti', 'coupon_categorie_prodotti_ibfk_01', 'id_coupon', 'coupon', 'CASCADE', 'CASCADE', NULL ),
( 'coupon_categorie_prodotti', 'coupon_categorie_prodotti_ibfk_02_nofollow', 'id_categoria', 'categorie_prodotti', 'CASCADE', 'CASCADE', NULL ),
( 'coupon_categorie_prodotti', 'coupon_categorie_prodotti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'coupon_categorie_prodotti', 'coupon_categorie_prodotti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'coupon_listini', 'coupon_listini_ibfk_01', 'id_coupon', 'coupon', 'CASCADE', 'CASCADE', NULL ),
( 'coupon_listini', 'coupon_listini_ibfk_02_nofollow', 'id_listino', 'listini', 'CASCADE', 'CASCADE', NULL ),
( 'coupon_listini', 'coupon_listini_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'coupon_listini', 'coupon_listini_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'coupon_marchi', 'coupon_marchi_ibfk_01', 'id_coupon', 'coupon', 'CASCADE', 'CASCADE', NULL ),
( 'coupon_marchi', 'coupon_marchi_ibfk_02_nofollow', 'id_marchio', 'marchi', 'CASCADE', 'CASCADE', NULL ),
( 'coupon_marchi', 'coupon_marchi_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'coupon_marchi', 'coupon_marchi_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'coupon_prodotti', 'coupon_prodotti_ibfk_01', 'id_coupon', 'coupon', 'CASCADE', 'CASCADE', NULL ),
( 'coupon_prodotti', 'coupon_prodotti_ibfk_02_nofollow', 'id_prodotto', 'prodotti', 'CASCADE', 'CASCADE', NULL ),
( 'coupon_prodotti', 'coupon_prodotti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'coupon_prodotti', 'coupon_prodotti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'crediti', 'crediti_ibfk_03_nofollow', 'id_documenti_articolo', 'documenti_articoli', 'CASCADE', 'CASCADE', NULL ),
( 'crediti', 'crediti_ibfk_04_nofollow', 'id_account_emittente', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'crediti', 'crediti_ibfk_05_nofollow', 'id_account_destinatario', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'crediti', 'crediti_ibfk_06_nofollow', 'id_mastro_provenienza', 'mastri', 'SET NULL', 'SET NULL', NULL ),
( 'crediti', 'crediti_ibfk_07_nofollow', 'id_mastro_destinazione', 'mastri', 'SET NULL', 'SET NULL', NULL ),
( 'crediti', 'crediti_ibfk_08_nofollow', 'id_pianificazione', 'pianificazioni', 'SET NULL', 'SET NULL', NULL ),
( 'crediti', 'crediti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'crediti', 'crediti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'dichiarazioni_intento', 'dichiarazioni_intento_ibfk_01', 'id_anagrafica', 'anagrafica', 'CASCADE', 'CASCADE', NULL ),
( 'dichiarazioni_intento', 'dichiarazioni_intento_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'dichiarazioni_intento', 'dichiarazioni_intento_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'disponibilita', 'disponibilita_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'disponibilita', 'disponibilita_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'documenti', 'documenti_ibfk_01_nofollow', 'id_tipologia', 'tipologie_documenti', 'NO ACTION', 'CASCADE', NULL ),
( 'documenti', 'documenti_ibfk_02_nofollow', 'id_emittente', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'documenti', 'documenti_ibfk_03_nofollow', 'id_sede_emittente', 'anagrafica_indirizzi', 'SET NULL', 'SET NULL', 'anagrafica_indirizzi.id_comune' ),
( 'documenti', 'documenti_ibfk_04_nofollow', 'id_destinatario', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'documenti', 'documenti_ibfk_05_nofollow', 'id_sede_destinatario', 'anagrafica_indirizzi', 'SET NULL', 'SET NULL', 'anagrafica_indirizzi.id_comune' ),
( 'documenti', 'documenti_ibfk_06_nofollow', 'id_coupon', 'coupon', 'SET NULL', 'SET NULL', NULL ),
( 'documenti', 'documenti_ibfk_07_nofollow', 'id_condizione_pagamento', 'condizioni_pagamento', 'SET NULL', 'SET NULL', NULL ),
( 'documenti', 'documenti_ibfk_08_nofollow', 'id_mastro_provenienza', 'mastri', 'SET NULL', 'SET NULL', NULL ),
( 'documenti', 'documenti_ibfk_09_nofollow', 'id_mastro_destinazione', 'mastri', 'SET NULL', 'SET NULL', NULL ),
( 'documenti', 'documenti_ibfk_10_nofollow', 'id_causale', 'causali', 'SET NULL', 'SET NULL', NULL ),
( 'documenti', 'documenti_ibfk_11_nofollow', 'id_trasportatore', 'anagrafica', 'SET NULL', 'SET NULL', NULL );

-- | 202610021705

-- i vincoli del canone, parte 5 di 13
INSERT IGNORE INTO `__patch_chiavi_canone__` ( `tabella`, `vincolo`, `colonna`, `riferimento`, `cancellazione`, `aggiornamento`, `condizione` ) VALUES
( 'documenti', 'documenti_ibfk_12_nofollow', 'id_immobile', 'immobili', 'SET NULL', 'SET NULL', NULL ),
( 'documenti', 'documenti_ibfk_13_nofollow', 'id_pianificazione', 'pianificazioni', 'SET NULL', 'SET NULL', NULL ),
( 'documenti', 'documenti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'documenti', 'documenti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'documenti', 'documenti_ibfk_14_nofollow', 'id_referente_emittente', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'documenti', 'documenti_ibfk_15_nofollow', 'id_destinatario_spedizione', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'documenti', 'documenti_ibfk_16_nofollow', 'id_sede_destinatario_spedizione', 'anagrafica_indirizzi', 'SET NULL', 'SET NULL', 'anagrafica_indirizzi.id_comune' ),
( 'documenti', 'documenti_ibfk_17_nofollow', 'id_carrello', 'carrelli', 'SET NULL', 'SET NULL', NULL ),
( 'documenti', 'documenti_ibfk_18_nofollow', 'id_progetto', 'progetti', 'SET NULL', 'SET NULL', NULL ),
( 'documenti_articoli', 'documenti_articoli_ibfk_01_nofollow', 'id_genitore', 'documenti_articoli', 'NO ACTION', 'CASCADE', NULL ),
( 'documenti_articoli', 'documenti_articoli_ibfk_02_nofollow', 'id_tipologia', 'tipologie_documenti', 'NO ACTION', 'CASCADE', NULL ),
( 'documenti_articoli', 'documenti_articoli_ibfk_03_nofollow', 'id_documento', 'documenti', 'SET NULL', 'SET NULL', NULL ),
( 'documenti_articoli', 'documenti_articoli_ibfk_04_nofollow', 'id_emittente', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'documenti_articoli', 'documenti_articoli_ibfk_05_nofollow', 'id_destinatario', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'documenti_articoli', 'documenti_articoli_ibfk_06_nofollow', 'id_reparto', 'reparti', 'SET NULL', 'SET NULL', NULL ),
( 'documenti_articoli', 'documenti_articoli_ibfk_07_nofollow', 'id_progetto', 'progetti', 'SET NULL', 'SET NULL', NULL ),
( 'documenti_articoli', 'documenti_articoli_ibfk_08_nofollow', 'id_todo', 'todo', 'SET NULL', 'SET NULL', NULL ),
( 'documenti_articoli', 'documenti_articoli_ibfk_09_nofollow', 'id_attivita', 'attivita', 'SET NULL', 'SET NULL', NULL ),
( 'documenti_articoli', 'documenti_articoli_ibfk_10_nofollow', 'id_articolo', 'articoli', 'SET NULL', 'SET NULL', NULL ),
( 'documenti_articoli', 'documenti_articoli_ibfk_11_nofollow', 'id_mastro_provenienza', 'mastri', 'SET NULL', 'SET NULL', NULL ),
( 'documenti_articoli', 'documenti_articoli_ibfk_12_nofollow', 'id_mastro_destinazione', 'mastri', 'SET NULL', 'SET NULL', NULL ),
( 'documenti_articoli', 'documenti_articoli_ibfk_13_nofollow', 'id_udm', 'udm', 'SET NULL', 'SET NULL', NULL ),
( 'documenti_articoli', 'documenti_articoli_ibfk_14_nofollow', 'id_listino', 'listini', 'SET NULL', 'SET NULL', NULL ),
( 'documenti_articoli', 'documenti_articoli_ibfk_15_nofollow', 'id_matricola', 'matricole', 'SET NULL', 'SET NULL', NULL ),
( 'documenti_articoli', 'documenti_articoli_ibfk_16_nofollow', 'id_rinnovo', 'rinnovi', 'SET NULL', 'SET NULL', NULL ),
( 'documenti_articoli', 'documenti_articoli_ibfk_17_nofollow', 'id_collo', 'colli', 'SET NULL', 'SET NULL', NULL ),
( 'documenti_articoli', 'documenti_articoli_ibfk_18_nofollow', 'id_prodotto', 'prodotti', 'SET NULL', 'SET NULL', NULL ),
( 'documenti_articoli', 'documenti_articoli_ibfk_19_nofollow', 'id_pianificazione', 'pianificazioni', 'SET NULL', 'SET NULL', NULL ),
( 'documenti_articoli', 'documenti_articoli_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'documenti_articoli', 'documenti_articoli_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'documenti_articoli', 'documenti_articoli_ibfk_20_nofollow', 'id_tipologia_documento', 'tipologie_documenti', 'NO ACTION', 'CASCADE', NULL ),
( 'documenti_articoli', 'documenti_articoli_ibfk_21_nofollow', 'id_carrelli_articoli', 'carrelli_articoli', 'SET NULL', 'SET NULL', NULL ),
( 'documenti_casse_previdenziali', 'documenti_casse_previdenziali_ibfk_01', 'id_documento', 'documenti', 'CASCADE', 'CASCADE', NULL ),
( 'documenti_casse_previdenziali', 'documenti_casse_previdenziali_ibfk_02_nofollow', 'id_cassa_previdenziale', 'casse_previdenziali', 'NO ACTION', 'CASCADE', NULL ),
( 'documenti_casse_previdenziali', 'documenti_casse_previdenziali_ibfk_03_nofollow', 'id_iva', 'iva', 'SET NULL', 'SET NULL', NULL ),
( 'documenti_casse_previdenziali', 'documenti_casse_previdenziali_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'documenti_casse_previdenziali', 'documenti_casse_previdenziali_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'documenti_ritenute', 'documenti_ritenute_ibfk_01', 'id_documento', 'documenti', 'CASCADE', 'CASCADE', NULL ),
( 'documenti_ritenute', 'documenti_ritenute_ibfk_02_nofollow', 'id_ritenuta', 'ritenute', 'NO ACTION', 'CASCADE', NULL ),
( 'documenti_ritenute', 'documenti_ritenute_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'documenti_ritenute', 'documenti_ritenute_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'edifici', 'edifici_ibfk_01_nofollow', 'id_tipologia', 'tipologie_edifici', 'NO ACTION', 'CASCADE', NULL ),
( 'edifici', 'edifici_ibfk_02_nofollow', 'id_indirizzo', 'indirizzi', 'SET NULL', 'SET NULL', NULL ),
( 'edifici', 'edifici_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'edifici', 'edifici_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'edifici_caratteristiche', 'edifici_caratteristiche_ibfk_01', 'id_edificio', 'edifici', 'CASCADE', 'CASCADE', NULL ),
( 'edifici_caratteristiche', 'edifici_caratteristiche_ibfk_02_nofollow', 'id_caratteristica', 'caratteristiche', 'CASCADE', 'CASCADE', NULL ),
( 'edifici_caratteristiche', 'edifici_caratteristiche_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'edifici_caratteristiche', 'edifici_caratteristiche_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_01_nofollow', 'id_ruolo', 'ruoli_file', 'NO ACTION', 'CASCADE', NULL ),
( 'file', 'file_ibfk_02', 'id_anagrafica', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_03', 'id_prodotto', 'prodotti', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_04', 'id_articolo', 'articoli', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_05', 'id_categoria_prodotti', 'categorie_prodotti', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_06', 'id_todo', 'todo', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_07', 'id_pagina', 'pagine', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_08', 'id_template', 'template', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_09', 'id_mailing', 'mailing', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_10', 'id_notizia', 'notizie', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_11', 'id_annuncio', 'annunci', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_12', 'id_categoria_notizie', 'categorie_notizie', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_13', 'id_categoria_annunci', 'categorie_annunci', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_14', 'id_risorsa', 'risorse', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_15', 'id_categoria_risorse', 'categorie_risorse', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_16_nofollow', 'id_lingua', 'lingue', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_17', 'id_mail_out', 'mail_out', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_18', 'id_mail_sent', 'mail_sent', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_19', 'id_progetto', 'progetti', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_20', 'id_categoria_progetti', 'categorie_progetti', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_21', 'id_documento', 'documenti', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_22', 'id_indirizzo', 'indirizzi', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_23', 'id_edificio', 'edifici', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_24', 'id_immobile', 'immobili', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_25', 'id_contratto', 'contratti', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_26', 'id_valutazione', 'valutazioni', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_27', 'id_rinnovo', 'rinnovi', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_28', 'id_anagrafica_certificazioni', 'anagrafica_certificazioni', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_29', 'id_valutazione_certificazioni', 'valutazioni_certificazioni', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_30', 'id_licenza', 'licenze', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_31', 'id_attivita', 'attivita', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_32', 'id_marchio', 'marchi', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'giorni', 'giorni_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'giorni', 'giorni_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'gruppi', 'gruppi_ibfk_01_nofollow', 'id_genitore', 'gruppi', 'NO ACTION', 'CASCADE', NULL ),
( 'gruppi', 'gruppi_ibfk_02', 'id_organizzazione', 'organizzazioni', 'SET NULL', 'SET NULL', NULL ),
( 'gruppi', 'gruppi_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'gruppi', 'gruppi_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'iban', 'iban_ibfk_01', 'id_anagrafica', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'iban', 'iban_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'iban', 'iban_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'immagini', 'immagini_ibfk_01', 'id_anagrafica', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'immagini', 'immagini_ibfk_02', 'id_pagina', 'pagine', 'SET NULL', 'SET NULL', NULL ),
( 'immagini', 'immagini_ibfk_03', 'id_file', 'file', 'SET NULL', 'SET NULL', NULL ),
( 'immagini', 'immagini_ibfk_04', 'id_prodotto', 'prodotti', 'SET NULL', 'SET NULL', NULL ),
( 'immagini', 'immagini_ibfk_05', 'id_articolo', 'articoli', 'SET NULL', 'SET NULL', NULL ),
( 'immagini', 'immagini_ibfk_06', 'id_categoria_prodotti', 'categorie_prodotti', 'SET NULL', 'SET NULL', NULL ),
( 'immagini', 'immagini_ibfk_07', 'id_risorsa', 'risorse', 'SET NULL', 'SET NULL', NULL ),
( 'immagini', 'immagini_ibfk_08', 'id_categoria_risorse', 'categorie_risorse', 'SET NULL', 'SET NULL', NULL );

-- | 202610021706

-- i vincoli del canone, parte 6 di 13
INSERT IGNORE INTO `__patch_chiavi_canone__` ( `tabella`, `vincolo`, `colonna`, `riferimento`, `cancellazione`, `aggiornamento`, `condizione` ) VALUES
( 'immagini', 'immagini_ibfk_09', 'id_notizia', 'notizie', 'SET NULL', 'SET NULL', NULL ),
( 'immagini', 'immagini_ibfk_10', 'id_annuncio', 'annunci', 'SET NULL', 'SET NULL', NULL ),
( 'immagini', 'immagini_ibfk_11', 'id_categoria_notizie', 'categorie_notizie', 'SET NULL', 'SET NULL', NULL ),
( 'immagini', 'immagini_ibfk_12', 'id_categoria_annunci', 'categorie_annunci', 'SET NULL', 'SET NULL', NULL ),
( 'immagini', 'immagini_ibfk_13', 'id_indirizzo', 'indirizzi', 'SET NULL', 'SET NULL', NULL ),
( 'immagini', 'immagini_ibfk_14_nofollow', 'id_lingua', 'lingue', 'SET NULL', 'SET NULL', NULL ),
( 'immagini', 'immagini_ibfk_15_nofollow', 'id_ruolo', 'ruoli_immagini', 'NO ACTION', 'CASCADE', NULL ),
( 'immagini', 'immagini_ibfk_16', 'id_progetto', 'progetti', 'SET NULL', 'SET NULL', NULL ),
( 'immagini', 'immagini_ibfk_17', 'id_categoria_progetti', 'categorie_progetti', 'SET NULL', 'SET NULL', NULL ),
( 'immagini', 'immagini_ibfk_18', 'id_edificio', 'edifici', 'SET NULL', 'SET NULL', NULL ),
( 'immagini', 'immagini_ibfk_19', 'id_immobile', 'immobili', 'SET NULL', 'SET NULL', NULL ),
( 'immagini', 'immagini_ibfk_20', 'id_contratto', 'contratti', 'SET NULL', 'SET NULL', NULL ),
( 'immagini', 'immagini_ibfk_21', 'id_valutazione', 'valutazioni', 'SET NULL', 'SET NULL', NULL ),
( 'immagini', 'immagini_ibfk_22', 'id_rinnovo', 'rinnovi', 'SET NULL', 'SET NULL', NULL ),
( 'immagini', 'immagini_ibfk_23', 'id_banner', 'banner', 'SET NULL', 'SET NULL', NULL ),
( 'immagini', 'immagini_ibfk_24', 'id_marchio', 'marchi', 'SET NULL', 'SET NULL', NULL ),
( 'immagini', 'immagini_ibfk_25', 'id_video', 'video', 'SET NULL', 'SET NULL', NULL ),
( 'immagini', 'immagini_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'immagini', 'immagini_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'immagini', 'immagini_ibfk_26_nofollow', 'id_contatto', 'contatti', 'SET NULL', 'SET NULL', NULL ),
( 'immobili', 'immobili_ibfk_01_nofollow', 'id_tipologia', 'tipologie_immobili', 'NO ACTION', 'CASCADE', NULL ),
( 'immobili', 'immobili_ibfk_02_nofollow', 'id_edificio', 'edifici', 'SET NULL', 'SET NULL', NULL ),
( 'immobili', 'immobili_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'immobili', 'immobili_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'immobili_anagrafica', 'immobili_anagrafica_ibfk_01', 'id_immobile', 'immobili', 'CASCADE', 'CASCADE', NULL ),
( 'immobili_anagrafica', 'immobili_anagrafica_ibfk_02_nofollow', 'id_anagrafica', 'anagrafica', 'CASCADE', 'CASCADE', NULL ),
( 'immobili_anagrafica', 'immobili_anagrafica_ibfk_03_nofollow', 'id_ruolo', 'ruoli_anagrafica', 'NO ACTION', 'CASCADE', NULL ),
( 'immobili_anagrafica', 'immobili_anagrafica_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'immobili_anagrafica', 'immobili_anagrafica_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'immobili_caratteristiche', 'immobili_caratteristiche_ibfk_01', 'id_immobile', 'immobili', 'CASCADE', 'CASCADE', NULL ),
( 'immobili_caratteristiche', 'immobili_caratteristiche_ibfk_02_nofollow', 'id_caratteristica', 'caratteristiche', 'CASCADE', 'CASCADE', NULL ),
( 'immobili_caratteristiche', 'immobili_caratteristiche_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'immobili_caratteristiche', 'immobili_caratteristiche_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'indirizzi', 'indirizzi_ibfk_01_nofollow', 'id_tipologia', 'tipologie_indirizzi', 'NO ACTION', 'CASCADE', NULL ),
( 'indirizzi', 'indirizzi_ibfk_03_nofollow', 'id_zona', 'zone', 'SET NULL', 'SET NULL', NULL ),
( 'indirizzi', 'indirizzi_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'indirizzi', 'indirizzi_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'indirizzi_caratteristiche', 'indirizzi_caratteristiche_ibfk_01', 'id_indirizzo', 'indirizzi', 'CASCADE', 'CASCADE', NULL ),
( 'indirizzi_caratteristiche', 'indirizzi_caratteristiche_ibfk_02_nofollow', 'id_caratteristica', 'caratteristiche', 'CASCADE', 'CASCADE', NULL ),
( 'indirizzi_caratteristiche', 'indirizzi_caratteristiche_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'indirizzi_caratteristiche', 'indirizzi_caratteristiche_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'iva', 'iva_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'iva', 'iva_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'job', 'job_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'job', 'job_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'licenze', 'licenze_ibfk_01_nofollow', 'id_tipologia', 'tipologie_licenze', 'NO ACTION', 'CASCADE', NULL ),
( 'licenze', 'licenze_ibfk_02_nofollow', 'id_anagrafica', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'licenze', 'licenze_ibfk_03_nofollow', 'id_rivenditore', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'licenze', 'licenze_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'licenze', 'licenze_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'licenze_software', 'licenze_software_ibfk_01', 'id_licenza', 'licenze', 'CASCADE', 'CASCADE', NULL ),
( 'licenze_software', 'licenze_software_ibfk_02', 'id_software', 'software', 'CASCADE', 'CASCADE', NULL ),
( 'licenze_software', 'licenze_software_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'licenze_software', 'licenze_software_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'lingue', 'lingue_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'lingue', 'lingue_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'liste', 'liste_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'liste', 'liste_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'liste_mail', 'liste_mail_ibfk_01_nofollow', 'id_lista', 'liste', 'CASCADE', 'CASCADE', NULL ),
( 'liste_mail', 'liste_mail_ibfk_02', 'id_mail', 'mail', 'CASCADE', 'CASCADE', NULL ),
( 'liste_mail', 'liste_mail_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'liste_mail', 'liste_mail_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'listini', 'listini_ibfk_01_nofollow', 'id_valuta', 'valute', 'SET NULL', 'SET NULL', NULL ),
( 'listini', 'listini_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'listini', 'listini_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'listini', 'listini_ibfk_02_nofollow', 'id_genitore', 'listini', 'NO ACTION', 'CASCADE', NULL ),
( 'listini', 'listini_ibfk_03_nofollow', 'id_tipologia', 'tipologie_listini', 'NO ACTION', 'CASCADE', NULL ),
( 'listini', 'listini_ibfk_04_nofollow', 'id_emittente', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'listini_clienti', 'listini_clienti_ibfk_01_nofollow', 'id_listino', 'listini', 'CASCADE', 'CASCADE', NULL ),
( 'listini_clienti', 'listini_clienti_ibfk_02_nofollow', 'id_cliente', 'anagrafica', 'CASCADE', 'CASCADE', NULL ),
( 'listini_clienti', 'listini_clienti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'listini_clienti', 'listini_clienti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'listini_zone', 'listini_zone_ibfk_01_nofollow', 'id_listino', 'listini', 'CASCADE', 'CASCADE', NULL ),
( 'listini_zone', 'listini_zone_ibfk_02_nofollow', 'id_zona', 'zone', 'CASCADE', 'CASCADE', NULL ),
( 'listini_zone', 'listini_zone_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'listini_zone', 'listini_zone_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'luoghi', 'luoghi_ibfk_01_nofollow', 'id_genitore', 'luoghi', 'NO ACTION', 'CASCADE', NULL ),
( 'luoghi', 'luoghi_ibfk_02_nofollow', 'id_indirizzo', 'indirizzi', 'SET NULL', 'SET NULL', NULL ),
( 'luoghi', 'luoghi_ibfk_03_nofollow', 'id_edificio', 'edifici', 'SET NULL', 'SET NULL', NULL ),
( 'luoghi', 'luoghi_ibfk_04_nofollow', 'id_immobile', 'immobili', 'SET NULL', 'SET NULL', NULL ),
( 'luoghi', 'luoghi_ibfk_05_nofollow', 'id_tipologia', 'tipologie_luoghi', 'NO ACTION', 'CASCADE', NULL ),
( 'luoghi', 'luoghi_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'luoghi', 'luoghi_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'macro', 'macro_ibfk_01', 'id_pagina', 'pagine', 'SET NULL', 'SET NULL', NULL ),
( 'macro', 'macro_ibfk_02', 'id_prodotto', 'prodotti', 'SET NULL', 'SET NULL', NULL ),
( 'macro', 'macro_ibfk_03', 'id_articolo', 'articoli', 'SET NULL', 'SET NULL', NULL ),
( 'macro', 'macro_ibfk_04', 'id_categoria_prodotti', 'categorie_prodotti', 'SET NULL', 'SET NULL', NULL ),
( 'macro', 'macro_ibfk_05', 'id_notizia', 'notizie', 'SET NULL', 'SET NULL', NULL ),
( 'macro', 'macro_ibfk_06', 'id_annuncio', 'annunci', 'SET NULL', 'SET NULL', NULL ),
( 'macro', 'macro_ibfk_07', 'id_categoria_notizie', 'categorie_notizie', 'SET NULL', 'SET NULL', NULL ),
( 'macro', 'macro_ibfk_08', 'id_categoria_annunci', 'categorie_annunci', 'SET NULL', 'SET NULL', NULL ),
( 'macro', 'macro_ibfk_09', 'id_risorsa', 'risorse', 'SET NULL', 'SET NULL', NULL ),
( 'macro', 'macro_ibfk_10', 'id_categoria_risorse', 'categorie_risorse', 'SET NULL', 'SET NULL', NULL ),
( 'macro', 'macro_ibfk_11', 'id_progetto', 'progetti', 'SET NULL', 'SET NULL', NULL ),
( 'macro', 'macro_ibfk_12', 'id_categoria_progetti', 'categorie_progetti', 'SET NULL', 'SET NULL', NULL ),
( 'macro', 'macro_ibfk_13', 'id_pianificazione', 'pianificazioni', 'SET NULL', 'SET NULL', NULL ),
( 'macro', 'macro_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'macro', 'macro_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'mail', 'mail_ibfk_01_nofollow', 'id_ruolo', 'ruoli_mail', 'NO ACTION', 'CASCADE', NULL ),
( 'mail_out', 'mail_out_ibfk_01_nofollow', 'id_mail', 'mail', 'SET NULL', 'SET NULL', NULL );

-- | 202610021707

-- i vincoli del canone, parte 7 di 13
INSERT IGNORE INTO `__patch_chiavi_canone__` ( `tabella`, `vincolo`, `colonna`, `riferimento`, `cancellazione`, `aggiornamento`, `condizione` ) VALUES
( 'mail_out', 'mail_out_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'mail_out', 'mail_out_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'mail_out', 'mail_out_ibfk_02_nofollow', 'id_mailing', 'mailing', 'SET NULL', 'SET NULL', NULL ),
( 'mail_sent', 'mail_sent_ibfk_01_nofollow', 'id_mail', 'mail', 'SET NULL', 'SET NULL', NULL ),
( 'mail_sent', 'mail_sent_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'mail_sent', 'mail_sent_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'mail_sent', 'mail_sent_ibfk_02_nofollow', 'id_mailing', 'mailing', 'SET NULL', 'SET NULL', NULL ),
( 'mail_status', 'mail_status_ibfk_01_nofollow', 'id_tipologia', 'tipologie_mail_status', 'NO ACTION', 'CASCADE', NULL ),
( 'mail_status', 'mail_status_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'mail_status', 'mail_status_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'mailing', 'mailing_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'mailing', 'mailing_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'mailing_liste', 'mailing_liste_ibfk_01_nofollow', 'id_lista', 'liste', 'CASCADE', 'CASCADE', NULL ),
( 'mailing_liste', 'mailing_liste_ibfk_02', 'id_mailing', 'mailing', 'CASCADE', 'CASCADE', NULL ),
( 'mailing_liste', 'mailing_liste_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'mailing_liste', 'mailing_liste_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'mailing_mail', 'mailing_mail_ibfk_01_nofollow', 'id_mailing', 'mailing', 'CASCADE', 'CASCADE', NULL ),
( 'mailing_mail', 'mailing_mail_ibfk_02_nofollow', 'id_mail', 'mail', 'CASCADE', 'CASCADE', NULL ),
( 'mailing_mail', 'mailing_mail_ibfk_03_nofollow', 'id_mail_out', 'mail_out', 'SET NULL', 'SET NULL', NULL ),
( 'mailing_mail', 'mailing_mail_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'mailing_mail', 'mailing_mail_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'marchi', 'marchi_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'marchi', 'marchi_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'marchi', 'marchi_ibfk_01_nofollow', 'id_produttore', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'mastri', 'mastri_ibfk_01_nofollow', 'id_genitore', 'mastri', 'NO ACTION', 'CASCADE', NULL ),
( 'mastri', 'mastri_ibfk_02_nofollow', 'id_tipologia', 'tipologie_mastri', 'NO ACTION', 'CASCADE', NULL ),
( 'mastri', 'mastri_ibfk_03_nofollow', 'id_anagrafica_indirizzi', 'anagrafica_indirizzi', 'SET NULL', 'SET NULL', NULL ),
( 'mastri', 'mastri_ibfk_04_nofollow', 'id_anagrafica', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'mastri', 'mastri_ibfk_05_nofollow', 'id_account', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'mastri', 'mastri_ibfk_06_nofollow', 'id_progetto', 'progetti', 'SET NULL', 'SET NULL', NULL ),
( 'mastri', 'mastri_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'mastri', 'mastri_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'mastri_articoli', 'mastri_articoli_ibfk_01_nofollow', 'id_mastro', 'mastri', 'CASCADE', 'CASCADE', NULL ),
( 'mastri_articoli', 'mastri_articoli_ibfk_02_nofollow', 'id_articolo', 'articoli', 'CASCADE', 'CASCADE', NULL ),
( 'mastri_articoli', 'mastri_articoli_ibfk_03_nofollow', 'id_udm', 'udm', 'SET NULL', 'SET NULL', NULL ),
( 'mastri_articoli', 'mastri_articoli_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'mastri_articoli', 'mastri_articoli_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'mastri_tipologie_veicoli', 'mastri_tipologie_veicoli_ibfk_01_nofollow', 'id_mastro', 'mastri', 'CASCADE', 'CASCADE', NULL ),
( 'mastri_tipologie_veicoli', 'mastri_tipologie_veicoli_ibfk_02_nofollow', 'id_tipologia', 'tipologie_veicoli', 'CASCADE', 'CASCADE', NULL ),
( 'mastri_tipologie_veicoli', 'mastri_tipologie_veicoli_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'mastri_tipologie_veicoli', 'mastri_tipologie_veicoli_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'matricole', 'matricole_ibfk_01_nofollow', 'id_marchio', 'marchi', 'SET NULL', 'SET NULL', NULL ),
( 'matricole', 'matricole_ibfk_02_nofollow', 'id_produttore', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'matricole', 'matricole_ibfk_03_nofollow', 'id_articolo', 'articoli', 'SET NULL', 'SET NULL', NULL ),
( 'matricole', 'matricole_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'matricole', 'matricole_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'menu', 'menu_ibfk_01_nofollow', 'id_lingua', 'lingue', 'SET NULL', 'SET NULL', NULL ),
( 'menu', 'menu_ibfk_02', 'id_pagina', 'pagine', 'SET NULL', 'SET NULL', NULL ),
( 'menu', 'menu_ibfk_03', 'id_categoria_prodotti', 'categorie_prodotti', 'SET NULL', 'SET NULL', NULL ),
( 'menu', 'menu_ibfk_04', 'id_categoria_notizie', 'categorie_notizie', 'SET NULL', 'SET NULL', NULL ),
( 'menu', 'menu_ibfk_05', 'id_categoria_risorse', 'categorie_risorse', 'SET NULL', 'SET NULL', NULL ),
( 'menu', 'menu_ibfk_06', 'id_categoria_progetti', 'categorie_progetti', 'SET NULL', 'SET NULL', NULL ),
( 'menu', 'menu_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'menu', 'menu_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'menu', 'menu_ibfk_07_nofollow', 'id_categoria_annunci', 'categorie_annunci', 'SET NULL', 'SET NULL', NULL ),
( 'messaggi', 'messaggi_ibfk_01_nofollow', 'id_conversazione', 'conversazioni', 'SET NULL', 'SET NULL', NULL ),
( 'messaggi', 'messaggi_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'messaggi', 'messaggi_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_01_nofollow', 'id_lingua', 'lingue', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_02', 'id_pagina', 'pagine', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_03', 'id_categoria_prodotti', 'categorie_prodotti', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_04', 'id_categoria_notizie', 'categorie_notizie', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_05', 'id_categoria_risorse', 'categorie_risorse', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_06', 'id_categoria_progetti', 'categorie_progetti', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_07', 'id_notizia', 'notizie', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_08', 'id_articolo', 'articoli', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_09', 'id_anagrafica', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_10', 'id_account', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_11', 'id_prodotto', 'prodotti', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_12', 'id_annuncio', 'annunci', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_13', 'id_categoria_annunci', 'categorie_annunci', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_14', 'id_risorsa', 'risorse', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_15', 'id_immagine', 'immagini', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_16', 'id_video', 'video', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_17', 'id_audio', 'audio', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_18', 'id_file', 'file', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_19', 'id_documento', 'documenti', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_20', 'id_documenti_articoli', 'documenti_articoli', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_21', 'id_progetto', 'progetti', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_22', 'id_indirizzo', 'indirizzi', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_23', 'id_edificio', 'edifici', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_24', 'id_immobile', 'immobili', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_25', 'id_contratto', 'contratti', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_26', 'id_valutazione', 'valutazioni', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_27', 'id_rinnovo', 'rinnovi', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_28', 'id_attivita', 'attivita', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_29', 'id_tipologia_attivita', 'tipologie_attivita', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_30', 'id_banner', 'banner', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_31', 'id_pianificazione', 'pianificazioni', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_32', 'id_todo', 'todo', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_33', 'id_tipologia_todo', 'tipologie_todo', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_34', 'id_tipologia_contratti', 'tipologie_contratti', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_35', 'id_carrello', 'carrelli', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_36', 'id_tipologia_corrispondenza', 'tipologie_corrispondenza', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_37', 'id_peso_tipologie_corrispondenza', 'pesi_tipologie_corrispondenza', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'metadati_articoli', 'metadati_articoli_ibfk_01_nofollow', 'id_lingua', 'lingue', 'SET NULL', 'SET NULL', NULL ),
( 'metadati_articoli', 'metadati_articoli_ibfk_02', 'id_articolo', 'articoli', 'SET NULL', 'SET NULL', NULL ),
( 'metadati_articoli', 'metadati_articoli_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL );

-- | 202610021708

-- i vincoli del canone, parte 8 di 13
INSERT IGNORE INTO `__patch_chiavi_canone__` ( `tabella`, `vincolo`, `colonna`, `riferimento`, `cancellazione`, `aggiornamento`, `condizione` ) VALUES
( 'metadati_articoli', 'metadati_articoli_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'metadati_prodotti', 'metadati_prodotti_ibfk_01_nofollow', 'id_lingua', 'lingue', 'SET NULL', 'SET NULL', NULL ),
( 'metadati_prodotti', 'metadati_prodotti_ibfk_02', 'id_prodotto', 'prodotti', 'SET NULL', 'SET NULL', NULL ),
( 'metadati_prodotti', 'metadati_prodotti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'metadati_prodotti', 'metadati_prodotti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'modalita_pagamento', 'modalita_pagamento_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'modalita_pagamento', 'modalita_pagamento_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'modalita_spedizione', 'modalita_spedizione_ibfk_01_nofollow', 'id_tipologia', 'tipologie_spedizioni', 'NO ACTION', 'CASCADE', NULL ),
( 'modalita_spedizione', 'modalita_spedizione_ibfk_02', 'id_zona', 'zone', 'SET NULL', 'SET NULL', NULL ),
( 'modalita_spedizione', 'modalita_spedizione_ibfk_03', 'id_categoria_prodotti', 'categorie_prodotti', 'SET NULL', 'SET NULL', NULL ),
( 'modalita_spedizione', 'modalita_spedizione_ibfk_04', 'id_prodotto', 'prodotti', 'SET NULL', 'SET NULL', NULL ),
( 'modalita_spedizione', 'modalita_spedizione_ibfk_05', 'id_articolo', 'articoli', 'SET NULL', 'SET NULL', NULL ),
( 'modalita_spedizione', 'modalita_spedizione_ibfk_06', 'id_valuta', 'valute', 'SET NULL', 'SET NULL', NULL ),
( 'modalita_spedizione', 'modalita_spedizione_ibfk_07', 'id_iva', 'iva', 'SET NULL', 'SET NULL', NULL ),
( 'modalita_spedizione', 'modalita_spedizione_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'modalita_spedizione', 'modalita_spedizione_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'notizie', 'notizie_ibfk_01_nofollow', 'id_tipologia', 'tipologie_notizie', 'NO ACTION', 'CASCADE', NULL ),
( 'notizie', 'notizie_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'notizie', 'notizie_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'notizie_anagrafica', 'notizie_anagrafica_ibfk_01_nofollow', 'id_notizia', 'notizie', 'CASCADE', 'CASCADE', NULL ),
( 'notizie_anagrafica', 'notizie_anagrafica_ibfk_02_nofollow', 'id_anagrafica', 'anagrafica', 'CASCADE', 'CASCADE', NULL ),
( 'notizie_anagrafica', 'notizie_anagrafica_ibfk_03_nofollow', 'id_ruolo', 'ruoli_anagrafica', 'NO ACTION', 'CASCADE', NULL ),
( 'notizie_anagrafica', 'notizie_anagrafica_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'notizie_anagrafica', 'notizie_anagrafica_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'notizie_categorie', 'notizie_categorie_ibfk_01', 'id_notizia', 'notizie', 'CASCADE', 'CASCADE', NULL ),
( 'notizie_categorie', 'notizie_categorie_ibfk_02_nofollow', 'id_categoria', 'categorie_notizie', 'CASCADE', 'CASCADE', NULL ),
( 'notizie_categorie', 'notizie_categorie_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'notizie_categorie', 'notizie_categorie_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'notizie_categorie', 'notizie_categorie_ibfk_03_nofollow', 'id_annuncio', 'annunci', 'SET NULL', 'SET NULL', NULL ),
( 'orari', 'orari_ibfk_01', 'id_tipologia_contratti', 'tipologie_contratti', 'CASCADE', 'CASCADE', NULL ),
( 'orari', 'orari_ibfk_02', 'id_periodicita', 'periodicita', 'SET NULL', 'SET NULL', NULL ),
( 'orari', 'orari_ibfk_03_nofollow', 'id_giorno', 'giorni', 'SET NULL', 'SET NULL', NULL ),
( 'orari', 'orari_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'orari', 'orari_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'orari_contratti', 'orari_contratti_ibfk_01', 'id_contratto', 'contratti', 'CASCADE', 'CASCADE', NULL ),
( 'orari_contratti', 'orari_contratti_ibfk_02_nofollow', 'id_costo', 'costi_contratti', 'CASCADE', 'CASCADE', NULL ),
( 'orari_contratti', 'orari_contratti_ibfk_03_nofollow', 'id_giorno', 'giorni', 'SET NULL', 'SET NULL', NULL ),
( 'orari_contratti', 'orari_contratti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'orari_contratti', 'orari_contratti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'organizzazioni', 'organizzazioni_ibfk_01_nofollow', 'id_genitore', 'organizzazioni', 'NO ACTION', 'CASCADE', NULL ),
( 'organizzazioni', 'organizzazioni_ibfk_02', 'id_anagrafica', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'organizzazioni', 'organizzazioni_ibfk_03_nofollow', 'id_ruolo', 'ruoli_anagrafica', 'NO ACTION', 'CASCADE', NULL ),
( 'organizzazioni', 'organizzazioni_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'organizzazioni', 'organizzazioni_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'pagamenti', 'pagamenti_ibfk_01_nofollow', 'id_tipologia', 'tipologie_pagamenti', 'NO ACTION', 'CASCADE', NULL ),
( 'pagamenti', 'pagamenti_ibfk_02', 'id_documento', 'documenti', 'SET NULL', 'SET NULL', NULL ),
( 'pagamenti', 'pagamenti_ibfk_03_nofollow', 'id_carrelli_articoli', 'carrelli_articoli', 'SET NULL', 'SET NULL', NULL ),
( 'pagamenti', 'pagamenti_ibfk_04_nofollow', 'id_creditore', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'pagamenti', 'pagamenti_ibfk_05_nofollow', 'id_debitore', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'pagamenti', 'pagamenti_ibfk_06_nofollow', 'id_mastro_provenienza', 'mastri', 'SET NULL', 'SET NULL', NULL ),
( 'pagamenti', 'pagamenti_ibfk_07_nofollow', 'id_mastro_destinazione', 'mastri', 'SET NULL', 'SET NULL', NULL ),
( 'pagamenti', 'pagamenti_ibfk_08_nofollow', 'id_iban', 'iban', 'SET NULL', 'SET NULL', NULL ),
( 'pagamenti', 'pagamenti_ibfk_09_nofollow', 'id_listino', 'listini', 'SET NULL', 'SET NULL', NULL ),
( 'pagamenti', 'pagamenti_ibfk_10_nofollow', 'id_modalita_pagamento', 'modalita_pagamento', 'SET NULL', 'SET NULL', NULL ),
( 'pagamenti', 'pagamenti_ibfk_11_nofollow', 'id_pianificazione', 'pianificazioni', 'SET NULL', 'SET NULL', NULL ),
( 'pagamenti', 'pagamenti_ibfk_12_nofollow', 'id_coupon', 'coupon', 'SET NULL', 'SET NULL', NULL ),
( 'pagamenti', 'pagamenti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'pagamenti', 'pagamenti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'pagamenti', 'pagamenti_ibfk_13_nofollow', 'id_rinnovo', 'rinnovi', 'SET NULL', 'SET NULL', NULL ),
( 'pagamenti', 'pagamenti_ibfk_14_nofollow', 'id_carrello', 'carrelli', 'SET NULL', 'SET NULL', NULL ),
( 'pagine', 'pagine_ibfk_01_nofollow', 'id_genitore', 'pagine', 'NO ACTION', 'CASCADE', NULL ),
( 'pagine', 'pagine_ibfk_02_nofollow', 'id_contenuti', 'contenuti', 'SET NULL', 'SET NULL', NULL ),
( 'pagine', 'pagine_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'pagine', 'pagine_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'periodi', 'periodi_ibfk_01_nofollow', 'id_genitore', 'periodi', 'NO ACTION', 'CASCADE', NULL ),
( 'periodi', 'periodi_ibfk_02_nofollow', 'id_tipologia', 'tipologie_periodi', 'NO ACTION', 'CASCADE', NULL ),
( 'periodi', 'periodi_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'periodi', 'periodi_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'periodi', 'periodi_ibfk_03_nofollow', 'id_contratto', 'contratti', 'SET NULL', 'SET NULL', NULL ),
( 'pianificazioni', 'pianificazioni_ibfk_00', 'id_genitore', 'pianificazioni', 'NO ACTION', 'CASCADE', NULL ),
( 'pianificazioni', 'pianificazioni_ibfk_01', 'id_progetto', 'progetti', 'SET NULL', 'SET NULL', NULL ),
( 'pianificazioni', 'pianificazioni_ibfk_02', 'id_todo', 'todo', 'SET NULL', 'SET NULL', NULL ),
( 'pianificazioni', 'pianificazioni_ibfk_03', 'id_attivita', 'attivita', 'SET NULL', 'SET NULL', NULL ),
( 'pianificazioni', 'pianificazioni_ibfk_04_nofollow', 'id_periodicita', 'periodicita', 'SET NULL', 'SET NULL', NULL ),
( 'pianificazioni', 'pianificazioni_ibfk_05', 'id_contratto', 'contratti', 'SET NULL', 'SET NULL', NULL ),
( 'pianificazioni', 'pianificazioni_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'pianificazioni', 'pianificazioni_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'pianificazioni', 'pianificazioni_ibfk_06_nofollow', 'id_anagrafica', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'periodicita', 'periodicita_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'periodicita', 'periodicita_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'pesi_tipologie_corrispondenza', 'pesi_tipologie_corrispondenza_ibfk_01_nofollow', 'id_tipologia', 'tipologie_corrispondenza', 'NO ACTION', 'CASCADE', NULL ),
( 'pesi_tipologie_corrispondenza', 'pesi_tipologie_corrispondenza_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'pesi_tipologie_corrispondenza', 'pesi_tipologie_corrispondenza_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'popup', 'popup_ibfk_01_nofollow', 'id_tipologia', 'tipologie_popup', 'NO ACTION', 'CASCADE', NULL ),
( 'popup', 'popup_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'popup', 'popup_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'popup_pagine', 'popup_pagine_ibfk_01', 'id_popup', 'popup', 'CASCADE', 'CASCADE', NULL ),
( 'popup_pagine', 'popup_pagine_ibfk_02_nofollow', 'id_pagina', 'pagine', 'CASCADE', 'CASCADE', NULL ),
( 'popup_pagine', 'popup_pagine_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'popup_pagine', 'popup_pagine_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'prezzi', 'prezzi_ibfk_01', 'id_prodotto', 'prodotti', 'CASCADE', 'CASCADE', NULL ),
( 'prezzi', 'prezzi_ibfk_02', 'id_articolo', 'articoli', 'CASCADE', 'CASCADE', NULL ),
( 'prezzi', 'prezzi_ibfk_03_nofollow', 'id_listino', 'listini', 'NO ACTION', 'CASCADE', NULL ),
( 'prezzi', 'prezzi_ibfk_04_nofollow', 'id_iva', 'iva', 'NO ACTION', 'CASCADE', NULL ),
( 'prezzi', 'prezzi_ibfk_05_nofollow', 'id_reparto', 'reparti', 'NO ACTION', 'CASCADE', NULL ),
( 'prezzi', 'prezzi_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'prezzi', 'prezzi_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'istruzioni', 'istruzioni_ibfk_02', 'id_prodotto', 'prodotti', 'SET NULL', 'SET NULL', NULL ),
( 'istruzioni', 'istruzioni_ibfk_03', 'id_articolo', 'articoli', 'CASCADE', 'CASCADE', NULL ),
( 'istruzioni', 'istruzioni_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL );

-- | 202610021709

-- i vincoli del canone, parte 9 di 13
INSERT IGNORE INTO `__patch_chiavi_canone__` ( `tabella`, `vincolo`, `colonna`, `riferimento`, `cancellazione`, `aggiornamento`, `condizione` ) VALUES
( 'istruzioni', 'istruzioni_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'prodotti', 'prodotti_ibfk_01', 'id_marchio', 'marchi', 'CASCADE', 'CASCADE', NULL ),
( 'prodotti', 'prodotti_ibfk_03_nofollow', 'id_produttore', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'prodotti', 'prodotti_ibfk_04_nofollow', 'id_tipologia', 'tipologie_prodotti', 'NO ACTION', 'CASCADE', NULL ),
( 'prodotti', 'prodotti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'prodotti', 'prodotti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'prodotti', 'prodotti_ibfk_05_nofollow', 'id_pagina', 'pagine', 'SET NULL', 'SET NULL', NULL ),
( 'prodotti_caratteristiche', 'prodotti_caratteristiche_ibfk_01', 'id_prodotto', 'prodotti', 'CASCADE', 'CASCADE', NULL ),
( 'prodotti_caratteristiche', 'prodotti_caratteristiche_ibfk_02_nofollow', 'id_caratteristica', 'caratteristiche', 'CASCADE', 'CASCADE', NULL ),
( 'prodotti_caratteristiche', 'prodotti_caratteristiche_ibfk_03_nofollow', 'id_lingua', 'lingue', 'SET NULL', 'SET NULL', NULL ),
( 'prodotti_caratteristiche', 'prodotti_caratteristiche_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'prodotti_caratteristiche', 'prodotti_caratteristiche_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'prodotti_categorie', 'prodotti_categorie_ibfk_01', 'id_prodotto', 'prodotti', 'CASCADE', 'CASCADE', NULL ),
( 'prodotti_categorie', 'prodotti_categorie_ibfk_02_nofollow', 'id_categoria', 'categorie_prodotti', 'CASCADE', 'CASCADE', NULL ),
( 'prodotti_categorie', 'prodotti_categorie_ibfk_03_nofollow', 'id_ruolo', 'ruoli_prodotti', 'NO ACTION', 'CASCADE', NULL ),
( 'prodotti_categorie', 'prodotti_categorie_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'prodotti_categorie', 'prodotti_categorie_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'progetti', 'progetti_ibfk_01_nofollow', 'id_tipologia', 'tipologie_progetti', 'NO ACTION', 'CASCADE', NULL ),
( 'progetti', 'progetti_ibfk_02_nofollow', 'id_pianificazione', 'pianificazioni', 'SET NULL', 'SET NULL', NULL ),
( 'progetti', 'progetti_ibfk_03_nofollow', 'id_cliente', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'progetti', 'progetti_ibfk_04_nofollow', 'id_indirizzo', 'indirizzi', 'SET NULL', 'SET NULL', NULL ),
( 'progetti', 'progetti_ibfk_05_nofollow', 'id_ranking', 'ranking', 'SET NULL', 'SET NULL', NULL ),
( 'progetti', 'progetti_ibfk_06_nofollow', 'id_articolo', 'articoli', 'SET NULL', 'SET NULL', NULL ),
( 'progetti', 'progetti_ibfk_07_nofollow', 'id_prodotto', 'prodotti', 'SET NULL', 'SET NULL', NULL ),
( 'progetti', 'progetti_ibfk_08_nofollow', 'id_periodo', 'periodi', 'SET NULL', 'SET NULL', NULL ),
( 'progetti', 'progetti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'progetti', 'progetti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'progetti', 'progetti_ibfk_09_nofollow', 'id_pagina', 'pagine', 'SET NULL', 'SET NULL', NULL ),
( 'progetti', 'progetti_ibfk_10_nofollow', 'id_periodicita_prevista', 'periodicita', 'SET NULL', 'SET NULL', NULL ),
( 'progetti', 'progetti_ibfk_11_nofollow', 'id_periodicita_accettazione', 'periodicita', 'SET NULL', 'SET NULL', NULL ),
( 'progetti_anagrafica', 'progetti_anagrafica_ibfk_01', 'id_progetto', 'progetti', 'CASCADE', 'CASCADE', NULL ),
( 'progetti_anagrafica', 'progetti_anagrafica_ibfk_02_nofollow', 'id_anagrafica', 'anagrafica', 'CASCADE', 'CASCADE', NULL ),
( 'progetti_anagrafica', 'progetti_anagrafica_ibfk_03_nofollow', 'id_ruolo', 'ruoli_anagrafica', 'NO ACTION', 'CASCADE', NULL ),
( 'progetti_anagrafica', 'progetti_anagrafica_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'progetti_anagrafica', 'progetti_anagrafica_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'progetti_articoli', 'progetti_articoli_ibfk_01', 'id_progetto', 'progetti', 'CASCADE', 'CASCADE', NULL ),
( 'progetti_articoli', 'progetti_articoli_ibfk_02', 'id_articolo', 'articoli', 'CASCADE', 'CASCADE', NULL ),
( 'progetti_articoli', 'progetti_articoli_ibfk_03_nofollow', 'id_ruolo', 'ruoli_articoli', 'NO ACTION', 'CASCADE', NULL ),
( 'progetti_articoli', 'progetti_articoli_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'progetti_articoli', 'progetti_articoli_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'progetti_categorie', 'progetti_categorie_ibfk_01', 'id_progetto', 'progetti', 'CASCADE', 'CASCADE', NULL ),
( 'progetti_categorie', 'progetti_categorie_ibfk_02_nofollow', 'id_categoria', 'categorie_progetti', 'CASCADE', 'CASCADE', NULL ),
( 'progetti_categorie', 'progetti_categorie_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'progetti_categorie', 'progetti_categorie_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'progetti_certificazioni', 'progetti_certificazioni_ibfk_01', 'id_progetto', 'progetti', 'CASCADE', 'CASCADE', NULL ),
( 'progetti_certificazioni', 'progetti_certificazioni_ibfk_02_nofollow', 'id_certificazione', 'certificazioni', 'CASCADE', 'CASCADE', NULL ),
( 'progetti_certificazioni', 'progetti_certificazioni_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'progetti_certificazioni', 'progetti_certificazioni_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'progetti_matricole', 'progetti_matricole_ibfk_01', 'id_progetto', 'progetti', 'CASCADE', 'CASCADE', NULL ),
( 'progetti_matricole', 'progetti_matricole_ibfk_02_nofollow', 'id_matricola', 'matricole', 'CASCADE', 'CASCADE', NULL ),
( 'progetti_matricole', 'progetti_matricole_ibfk_03_nofollow', 'id_ruolo', 'ruoli_matricole', 'NO ACTION', 'CASCADE', NULL ),
( 'progetti_matricole', 'progetti_matricole_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'progetti_matricole', 'progetti_matricole_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'provincie', 'provincie_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'provincie', 'provincie_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'pubblicazioni', 'pubblicazioni_ibfk_01_nofollow', 'id_tipologia', 'tipologie_pubblicazioni', 'NO ACTION', 'CASCADE', NULL ),
( 'pubblicazioni', 'pubblicazioni_ibfk_02', 'id_pagina', 'pagine', 'SET NULL', 'SET NULL', NULL ),
( 'pubblicazioni', 'pubblicazioni_ibfk_03', 'id_popup', 'popup', 'SET NULL', 'SET NULL', NULL ),
( 'pubblicazioni', 'pubblicazioni_ibfk_04', 'id_prodotto', 'prodotti', 'SET NULL', 'SET NULL', NULL ),
( 'pubblicazioni', 'pubblicazioni_ibfk_05', 'id_articolo', 'articoli', 'SET NULL', 'SET NULL', NULL ),
( 'pubblicazioni', 'pubblicazioni_ibfk_06', 'id_categoria_prodotti', 'categorie_prodotti', 'SET NULL', 'SET NULL', NULL ),
( 'pubblicazioni', 'pubblicazioni_ibfk_07', 'id_notizia', 'notizie', 'SET NULL', 'SET NULL', NULL ),
( 'pubblicazioni', 'pubblicazioni_ibfk_08', 'id_annuncio', 'annunci', 'SET NULL', 'SET NULL', NULL ),
( 'pubblicazioni', 'pubblicazioni_ibfk_09', 'id_categoria_notizie', 'categorie_notizie', 'SET NULL', 'SET NULL', NULL ),
( 'pubblicazioni', 'pubblicazioni_ibfk_10', 'id_categoria_annunci', 'categorie_annunci', 'SET NULL', 'SET NULL', NULL ),
( 'pubblicazioni', 'pubblicazioni_ibfk_11', 'id_risorsa', 'risorse', 'SET NULL', 'SET NULL', NULL ),
( 'pubblicazioni', 'pubblicazioni_ibfk_12', 'id_categoria_risorse', 'categorie_risorse', 'SET NULL', 'SET NULL', NULL ),
( 'pubblicazioni', 'pubblicazioni_ibfk_13', 'id_progetto', 'progetti', 'SET NULL', 'SET NULL', NULL ),
( 'pubblicazioni', 'pubblicazioni_ibfk_14', 'id_categoria_progetti', 'categorie_progetti', 'SET NULL', 'SET NULL', NULL ),
( 'pubblicazioni', 'pubblicazioni_ibfk_15', 'id_banner', 'banner', 'SET NULL', 'SET NULL', NULL ),
( 'pubblicazioni', 'pubblicazioni_ibfk_16', 'id_marchio', 'marchi', 'SET NULL', 'SET NULL', NULL ),
( 'pubblicazioni', 'pubblicazioni_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'pubblicazioni', 'pubblicazioni_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'ranking', 'ranking_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'ranking', 'ranking_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'recensioni', 'recensioni_ibfk_01_nofollow', 'id_lingua', 'lingue', 'SET NULL', 'SET NULL', NULL ),
( 'recensioni', 'recensioni_ibfk_02_nofollow', 'id_categoria_prodotti', 'categorie_prodotti', 'SET NULL', 'SET NULL', NULL ),
( 'recensioni', 'recensioni_ibfk_03_nofollow', 'id_prodotto', 'prodotti', 'SET NULL', 'SET NULL', NULL ),
( 'recensioni', 'recensioni_ibfk_04_nofollow', 'id_articolo', 'articoli', 'SET NULL', 'SET NULL', NULL ),
( 'recensioni', 'recensioni_ibfk_05_nofollow', 'id_risorsa', 'risorse', 'SET NULL', 'SET NULL', NULL ),
( 'recensioni', 'recensioni_ibfk_06_nofollow', 'id_categoria_notizie', 'categorie_notizie', 'SET NULL', 'SET NULL', NULL ),
( 'recensioni', 'recensioni_ibfk_07_nofollow', 'id_notizia', 'notizie', 'SET NULL', 'SET NULL', NULL ),
( 'recensioni', 'recensioni_ibfk_08_nofollow', 'id_pagina', 'pagine', 'SET NULL', 'SET NULL', NULL ),
( 'recensioni', 'recensioni_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'recensioni', 'recensioni_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'redirect', 'redirect_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'redirect', 'redirect_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'redirect_azioni', 'redirect_azioni_ibfk_01_nofollow', 'id_redirect', 'redirect', 'CASCADE', 'CASCADE', NULL ),
( 'redirect_azioni', 'redirect_azioni_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'redirect_azioni', 'redirect_azioni_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'regimi', 'regimi_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'regimi', 'regimi_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'regioni', 'regioni_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'regioni', 'regioni_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'relazioni_anagrafica', 'relazioni_anagrafica_ibfk_01', 'id_anagrafica', 'anagrafica', 'CASCADE', 'CASCADE', NULL ),
( 'relazioni_anagrafica', 'relazioni_anagrafica_ibfk_02', 'id_anagrafica_collegata', 'anagrafica', 'CASCADE', 'CASCADE', NULL ),
( 'relazioni_anagrafica', 'relazioni_anagrafica_ibfk_03_nofollow', 'id_ruolo', 'ruoli_anagrafica', 'NO ACTION', 'CASCADE', NULL ),
( 'relazioni_anagrafica', 'relazioni_anagrafica_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'relazioni_anagrafica', 'relazioni_anagrafica_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'relazioni_articoli', 'relazioni_articoli_ibfk_01', 'id_articolo', 'articoli', 'CASCADE', 'CASCADE', NULL );

-- | 202610021710

-- i vincoli del canone, parte 10 di 13
INSERT IGNORE INTO `__patch_chiavi_canone__` ( `tabella`, `vincolo`, `colonna`, `riferimento`, `cancellazione`, `aggiornamento`, `condizione` ) VALUES
( 'relazioni_articoli', 'relazioni_articoli_ibfk_02_nofollow', 'id_articolo_collegato', 'articoli', 'CASCADE', 'CASCADE', NULL ),
( 'relazioni_articoli', 'relazioni_articoli_ibfk_03_nofollow', 'id_ruolo', 'ruoli_articoli', 'NO ACTION', 'CASCADE', NULL ),
( 'relazioni_articoli', 'relazioni_articoli_ibfk_04', 'id_prodotto_collegato', 'prodotti', 'SET NULL', 'SET NULL', NULL ),
( 'relazioni_articoli', 'relazioni_articoli_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'relazioni_articoli', 'relazioni_articoli_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'relazioni_categorie_progetti', 'relazioni_categorie_progetti_ibfk_01', 'id_categoria', 'categorie_progetti', 'CASCADE', 'CASCADE', NULL ),
( 'relazioni_categorie_progetti', 'relazioni_categorie_progetti_ibfk_02', 'id_categoria_collegata', 'categorie_progetti', 'CASCADE', 'CASCADE', NULL ),
( 'relazioni_categorie_progetti', 'relazioni_categorie_progetti_ibfk_03_nofollow', 'id_ruolo', 'ruoli_progetti', 'NO ACTION', 'CASCADE', NULL ),
( 'relazioni_categorie_progetti', 'relazioni_categorie_progetti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'relazioni_categorie_progetti', 'relazioni_categorie_progetti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'relazioni_documenti', 'relazioni_documenti_ibfk_01', 'id_documento', 'documenti', 'CASCADE', 'CASCADE', NULL ),
( 'relazioni_documenti', 'relazioni_documenti_ibfk_02', 'id_documento_collegato', 'documenti', 'CASCADE', 'CASCADE', NULL ),
( 'relazioni_documenti', 'relazioni_documenti_ibfk_03_nofollow', 'id_ruolo', 'ruoli_documenti', 'NO ACTION', 'CASCADE', NULL ),
( 'relazioni_documenti', 'relazioni_documenti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'relazioni_documenti', 'relazioni_documenti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'relazioni_documenti_articoli', 'relazioni_documenti_articoli_ibfk_01', 'id_documenti_articolo', 'documenti_articoli', 'CASCADE', 'CASCADE', NULL ),
( 'relazioni_documenti_articoli', 'relazioni_documenti_articoli_ibfk_02', 'id_documenti_articolo_collegato', 'documenti_articoli', 'CASCADE', 'CASCADE', NULL ),
( 'relazioni_documenti_articoli', 'relazioni_documenti_articoli_ibfk_03_nofollow', 'id_ruolo', 'ruoli_documenti', 'NO ACTION', 'CASCADE', NULL ),
( 'relazioni_documenti_articoli', 'relazioni_documenti_articoli_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'relazioni_documenti_articoli', 'relazioni_documenti_articoli_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'relazioni_pagamenti', 'relazioni_pagamenti_ibfk_01', 'id_pagamento', 'pagamenti', 'CASCADE', 'CASCADE', NULL ),
( 'relazioni_pagamenti', 'relazioni_pagamenti_ibfk_02', 'id_pagamento_collegato', 'pagamenti', 'CASCADE', 'CASCADE', NULL ),
( 'relazioni_pagamenti', 'relazioni_pagamenti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'relazioni_pagamenti', 'relazioni_pagamenti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'relazioni_prodotti', 'relazioni_prodotti_ibfk_01', 'id_prodotto', 'prodotti', 'CASCADE', 'CASCADE', NULL ),
( 'relazioni_prodotti', 'relazioni_prodotti_ibfk_02', 'id_prodotto_collegato', 'prodotti', 'CASCADE', 'CASCADE', NULL ),
( 'relazioni_prodotti', 'relazioni_prodotti_ibfk_03_nofollow', 'id_ruolo', 'ruoli_prodotti', 'NO ACTION', 'CASCADE', NULL ),
( 'relazioni_prodotti', 'relazioni_prodotti_ibfk_04_nofollow', 'id_articolo_collegato', 'articoli', 'NO ACTION', 'CASCADE', NULL ),
( 'relazioni_prodotti', 'relazioni_prodotti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'relazioni_prodotti', 'relazioni_prodotti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'relazioni_progetti', 'relazioni_progetti_ibfk_01', 'id_progetto', 'progetti', 'CASCADE', 'CASCADE', NULL ),
( 'relazioni_progetti', 'relazioni_progetti_ibfk_02', 'id_progetto_collegato', 'progetti', 'CASCADE', 'CASCADE', NULL ),
( 'relazioni_progetti', 'relazioni_progetti_ibfk_03_nofollow', 'id_ruolo', 'ruoli_progetti', 'NO ACTION', 'CASCADE', NULL ),
( 'relazioni_progetti', 'relazioni_progetti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'relazioni_progetti', 'relazioni_progetti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'relazioni_software', 'relazioni_software_ibfk_01', 'id_software', 'software', 'CASCADE', 'CASCADE', NULL ),
( 'relazioni_software', 'relazioni_software_ibfk_02', 'id_software_collegato', 'software', 'CASCADE', 'CASCADE', NULL ),
( 'relazioni_software', 'relazioni_software_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'relazioni_software', 'relazioni_software_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'reparti', 'reparti_ibfk_01_nofollow', 'id_iva', 'iva', 'SET NULL', 'SET NULL', NULL ),
( 'reparti', 'reparti_ibfk_02_nofollow', 'id_settore', 'settori', 'SET NULL', 'SET NULL', NULL ),
( 'reparti', 'reparti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'reparti', 'reparti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'rinnovi', 'rinnovi_ibfk_01', 'id_contratto', 'contratti', 'SET NULL', 'SET NULL', NULL ),
( 'rinnovi', 'rinnovi_ibfk_02', 'id_licenza', 'licenze', 'SET NULL', 'SET NULL', NULL ),
( 'rinnovi', 'rinnovi_ibfk_03', 'id_progetto', 'progetti', 'SET NULL', 'SET NULL', NULL ),
( 'rinnovi', 'rinnovi_ibfk_04_nofollow', 'id_tipologia_contratto', 'tipologie_contratti', 'NO ACTION', 'CASCADE', NULL ),
( 'rinnovi', 'rinnovi_ibfk_05_nofollow', 'id_categoria_progetti', 'categorie_progetti', 'SET NULL', 'SET NULL', NULL ),
( 'rinnovi', 'rinnovi_ibfk_06_nofollow', 'id_tipologia', 'tipologie_rinnovi', 'NO ACTION', 'CASCADE', NULL ),
( 'rinnovi', 'rinnovi_ibfk_07_nofollow', 'id_periodicita', 'periodicita', 'SET NULL', 'SET NULL', NULL ),
( 'rinnovi', 'rinnovi_ibfk_08_nofollow', 'id_pianificazione', 'pianificazioni', 'SET NULL', 'SET NULL', NULL ),
( 'rinnovi', 'rinnovi_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'rinnovi', 'rinnovi_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'rinnovi_documenti_articoli', 'rinnovi_documenti_articoli_ibfk_01', 'id_rinnovo', 'rinnovi', 'CASCADE', 'CASCADE', NULL ),
( 'rinnovi_documenti_articoli', 'rinnovi_documenti_articoli_ibfk_02', 'id_documenti_articolo', 'documenti_articoli', 'CASCADE', 'CASCADE', NULL ),
( 'rinnovi_documenti_articoli', 'rinnovi_documenti_articoli_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'rinnovi_documenti_articoli', 'rinnovi_documenti_articoli_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'risorse', 'risorse_ibfk_01_nofollow', 'id_tipologia', 'tipologie_risorse', 'NO ACTION', 'CASCADE', NULL ),
( 'risorse', 'risorse_ibfk_02_nofollow', 'id_articolo', 'articoli', 'CASCADE', 'CASCADE', NULL ),
( 'risorse', 'risorse_ibfk_03_nofollow', 'id_prodotto', 'prodotti', 'SET NULL', 'SET NULL', NULL ),
( 'risorse', 'risorse_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'risorse', 'risorse_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'risorse', 'risorse_ibfk_04_nofollow', 'id_testata', 'testate', 'SET NULL', 'SET NULL', NULL ),
( 'risorse_account', 'risorse_account_ibfk_01', 'id_risorsa', 'risorse', 'CASCADE', 'CASCADE', NULL ),
( 'risorse_account', 'risorse_account_ibfk_02_nofollow', 'id_account', 'account', 'CASCADE', 'CASCADE', NULL ),
( 'risorse_account', 'risorse_account_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'risorse_account', 'risorse_account_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'risorse_anagrafica', 'risorse_anagrafica_ibfk_01', 'id_risorsa', 'risorse', 'CASCADE', 'CASCADE', NULL ),
( 'risorse_anagrafica', 'risorse_anagrafica_ibfk_02_nofollow', 'id_anagrafica', 'anagrafica', 'CASCADE', 'CASCADE', NULL ),
( 'risorse_anagrafica', 'risorse_anagrafica_ibfk_03_nofollow', 'id_ruolo', 'ruoli_anagrafica', 'NO ACTION', 'CASCADE', NULL ),
( 'risorse_anagrafica', 'risorse_anagrafica_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'risorse_anagrafica', 'risorse_anagrafica_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'risorse_categorie', 'risorse_categorie_ibfk_01', 'id_risorsa', 'risorse', 'CASCADE', 'CASCADE', NULL ),
( 'risorse_categorie', 'risorse_categorie_ibfk_02_nofollow', 'id_categoria', 'categorie_risorse', 'CASCADE', 'CASCADE', NULL ),
( 'risorse_categorie', 'risorse_categorie_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'risorse_categorie', 'risorse_categorie_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'ritenute', 'ritenute_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'ritenute', 'ritenute_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'ruoli_anagrafica', 'ruoli_anagrafica_ibfk_01_nofollow', 'id_genitore', 'ruoli_anagrafica', 'NO ACTION', 'CASCADE', NULL ),
( 'ruoli_anagrafica', 'ruoli_anagrafica_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'ruoli_anagrafica', 'ruoli_anagrafica_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'ruoli_articoli', 'ruoli_articoli_ibfk_01_nofollow', 'id_genitore', 'ruoli_articoli', 'NO ACTION', 'CASCADE', NULL ),
( 'ruoli_articoli', 'ruoli_articoli_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'ruoli_articoli', 'ruoli_articoli_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'ruoli_audio', 'ruoli_audio_ibfk_01_nofollow', 'id_genitore', 'ruoli_audio', 'NO ACTION', 'CASCADE', NULL ),
( 'ruoli_audio', 'ruoli_audio_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'ruoli_audio', 'ruoli_audio_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'ruoli_categorie_progetti', 'ruoli_categorie_progetti_ibfk_01_nofollow', 'id_genitore', 'ruoli_categorie_progetti', 'NO ACTION', 'CASCADE', NULL ),
( 'ruoli_categorie_progetti', 'ruoli_categorie_progetti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'ruoli_categorie_progetti', 'ruoli_categorie_progetti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'ruoli_documenti', 'ruoli_documenti_ibfk_01_nofollow', 'id_genitore', 'ruoli_documenti', 'NO ACTION', 'CASCADE', NULL ),
( 'ruoli_documenti', 'ruoli_documenti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'ruoli_documenti', 'ruoli_documenti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'ruoli_file', 'ruoli_file_ibfk_01_nofollow', 'id_genitore', 'ruoli_file', 'NO ACTION', 'CASCADE', NULL ),
( 'ruoli_file', 'ruoli_file_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'ruoli_file', 'ruoli_file_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'ruoli_immagini', 'ruoli_immagini_ibfk_01_nofollow', 'id_genitore', 'ruoli_immagini', 'NO ACTION', 'CASCADE', NULL ),
( 'ruoli_immagini', 'ruoli_immagini_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'ruoli_immagini', 'ruoli_immagini_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'ruoli_indirizzi', 'ruoli_indirizzi_ibfk_01_nofollow', 'id_genitore', 'ruoli_indirizzi', 'NO ACTION', 'CASCADE', NULL );

-- | 202610021711

-- i vincoli del canone, parte 11 di 13
INSERT IGNORE INTO `__patch_chiavi_canone__` ( `tabella`, `vincolo`, `colonna`, `riferimento`, `cancellazione`, `aggiornamento`, `condizione` ) VALUES
( 'ruoli_indirizzi', 'ruoli_indirizzi_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'ruoli_indirizzi', 'ruoli_indirizzi_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'ruoli_mail', 'ruoli_mail_ibfk_01_nofollow', 'id_genitore', 'ruoli_mail', 'NO ACTION', 'CASCADE', NULL ),
( 'ruoli_mail', 'ruoli_mail_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'ruoli_mail', 'ruoli_mail_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'ruoli_mastri', 'ruoli_mastri_ibfk_01_nofollow', 'id_genitore', 'ruoli_mastri', 'NO ACTION', 'CASCADE', NULL ),
( 'ruoli_mastri', 'ruoli_mastri_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'ruoli_mastri', 'ruoli_mastri_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'ruoli_matricole', 'ruoli_matricole_ibfk_01_nofollow', 'id_genitore', 'ruoli_matricole', 'NO ACTION', 'CASCADE', NULL ),
( 'ruoli_matricole', 'ruoli_matricole_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'ruoli_matricole', 'ruoli_matricole_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'ruoli_prodotti', 'ruoli_prodotti_ibfk_01_nofollow', 'id_genitore', 'ruoli_prodotti', 'NO ACTION', 'CASCADE', NULL ),
( 'ruoli_prodotti', 'ruoli_prodotti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'ruoli_prodotti', 'ruoli_prodotti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'ruoli_progetti', 'ruoli_progetti_ibfk_01_nofollow', 'id_genitore', 'ruoli_progetti', 'NO ACTION', 'CASCADE', NULL ),
( 'ruoli_progetti', 'ruoli_progetti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'ruoli_progetti', 'ruoli_progetti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'ruoli_video', 'ruoli_video_ibfk_01_nofollow', 'id_genitore', 'ruoli_video', 'NO ACTION', 'CASCADE', NULL ),
( 'ruoli_video', 'ruoli_video_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'ruoli_video', 'ruoli_video_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'sconti', 'sconti_ibfk_01_nofollow', 'id_tipologia', 'tipologie_sconti', 'NO ACTION', 'CASCADE', NULL ),
( 'sconti', 'sconti_ibfk_02', 'id_valuta', 'valute', 'SET NULL', 'SET NULL', NULL ),
( 'sconti', 'sconti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'sconti', 'sconti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'sconti_articoli', 'sconti_articoli_ibfk_01', 'id_sconto', 'sconti', 'CASCADE', 'CASCADE', NULL ),
( 'sconti_articoli', 'sconti_articoli_ibfk_02', 'id_articolo', 'articoli', 'CASCADE', 'CASCADE', NULL ),
( 'sconti_articoli', 'sconti_articoli_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'sconti_articoli', 'sconti_articoli_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'sconti_listini', 'sconti_listini_ibfk_01', 'id_sconto', 'sconti', 'CASCADE', 'CASCADE', NULL ),
( 'sconti_listini', 'sconti_listini_ibfk_02', 'id_listino', 'listini', 'CASCADE', 'CASCADE', NULL ),
( 'sconti_listini', 'sconti_listini_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'sconti_listini', 'sconti_listini_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'settori', 'settori_ibfk_01_nofollow', 'id_genitore', 'settori', 'NO ACTION', 'CASCADE', NULL ),
( 'settori', 'settori_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'settori', 'settori_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'sms_out', 'sms_out_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'sms_out', 'sms_out_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'sms_sent', 'sms_sent_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'sms_sent', 'sms_sent_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'software', 'software_ibfk_01_nofollow', 'id_genitore', 'software', 'NO ACTION', 'CASCADE', NULL ),
( 'software', 'software_ibfk_02_nofollow', 'id_articolo', 'articoli', 'CASCADE', 'CASCADE', NULL ),
( 'software', 'software_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'software', 'software_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'stati', 'stati_ibfk_01_nofollow', 'id_continente', 'continenti', 'SET NULL', 'SET NULL', NULL ),
( 'stati', 'stati_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'stati', 'stati_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'stati_lingue', 'stati_lingue_ibfk_02_nofollow', 'id_lingua', 'lingue', 'CASCADE', 'CASCADE', NULL ),
( 'stati_lingue', 'stati_lingue_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'stati_lingue', 'stati_lingue_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'step', 'step_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'step', 'step_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'task', 'task_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'task', 'task_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'telefoni', 'telefoni_ibfk_01', 'id_anagrafica', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'telefoni', 'telefoni_ibfk_02_nofollow', 'id_tipologia', 'tipologie_telefoni', 'NO ACTION', 'CASCADE', NULL ),
( 'telefoni', 'telefoni_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'telefoni', 'telefoni_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'template', 'template_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'template', 'template_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'testate', 'testate_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'testate', 'testate_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_anagrafica', 'tipologie_anagrafica_ibfk_01_nofollow', 'id_genitore', 'tipologie_anagrafica', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_anagrafica', 'tipologie_anagrafica_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_anagrafica', 'tipologie_anagrafica_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_annunci', 'tipologie_annunci_ibfk_01_nofollow', 'id_genitore', 'tipologie_annunci', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_annunci', 'tipologie_annunci_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_annunci', 'tipologie_annunci_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_attivita', 'tipologie_attivita_ibfk_01_nofollow', 'id_genitore', 'tipologie_attivita', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_attivita', 'tipologie_attivita_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_attivita', 'tipologie_attivita_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_attivita_inps', 'tipologie_attivita_inps_ibfk_01_nofollow', 'id_genitore', 'tipologie_attivita_inps', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_attivita_inps', 'tipologie_attivita_inps_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_attivita_inps', 'tipologie_attivita_inps_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_badge', 'tipologie_badge_ibfk_01_nofollow', 'id_genitore', 'tipologie_badge', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_badge', 'tipologie_badge_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_badge', 'tipologie_badge_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_banner', 'tipologie_banner_ibfk_01_nofollow', 'id_genitore', 'tipologie_banner', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_banner', 'tipologie_banner_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_banner', 'tipologie_banner_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_chiavi', 'tipologie_chiavi_ibfk_01_nofollow', 'id_genitore', 'tipologie_chiavi', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_chiavi', 'tipologie_chiavi_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_chiavi', 'tipologie_chiavi_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_colli', 'tipologie_colli_ibfk_01_nofollow', 'id_genitore', 'tipologie_colli', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_colli', 'tipologie_colli_ibfk_02_nofollow', 'id_udm_dimensioni', 'udm', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_colli', 'tipologie_colli_ibfk_03_nofollow', 'id_udm_peso', 'udm', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_colli', 'tipologie_colli_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_colli', 'tipologie_colli_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_contatti', 'tipologie_contatti_ibfk_01_nofollow', 'id_genitore', 'tipologie_contatti', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_contatti', 'tipologie_contatti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_contatti', 'tipologie_contatti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_contratti', 'tipologie_contratti_ibfk_01_nofollow', 'id_genitore', 'tipologie_contratti', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_contratti', 'tipologie_contratti_ibfk_02_nofollow', 'id_prodotto', 'prodotti', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_contratti', 'tipologie_contratti_ibfk_03_nofollow', 'id_progetto', 'progetti', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_contratti', 'tipologie_contratti_ibfk_04_nofollow', 'id_categoria_progetti', 'categorie_progetti', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_contratti', 'tipologie_contratti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_contratti', 'tipologie_contratti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_corrispondenza', 'tipologie_corrispondenza_ibfk_01_nofollow', 'id_genitore', 'tipologie_corrispondenza', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_corrispondenza', 'tipologie_corrispondenza_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_corrispondenza', 'tipologie_corrispondenza_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_documenti', 'tipologie_documenti_ibfk_01_nofollow', 'id_genitore', 'tipologie_documenti', 'NO ACTION', 'CASCADE', NULL );

-- | 202610021712

-- i vincoli del canone, parte 12 di 13
INSERT IGNORE INTO `__patch_chiavi_canone__` ( `tabella`, `vincolo`, `colonna`, `riferimento`, `cancellazione`, `aggiornamento`, `condizione` ) VALUES
( 'tipologie_documenti', 'tipologie_documenti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_documenti', 'tipologie_documenti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_documenti_articoli', 'tipologie_documenti_articoli_ibfk_01_nofollow', 'id_genitore', 'tipologie_documenti_articoli', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_documenti_articoli', 'tipologie_documenti_articoli_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_documenti_articoli', 'tipologie_documenti_articoli_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_edifici', 'tipologie_edifici_ibfk_01_nofollow', 'id_genitore', 'tipologie_edifici', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_edifici', 'tipologie_edifici_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_edifici', 'tipologie_edifici_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_immobili', 'tipologie_immobili_ibfk_01_nofollow', 'id_genitore', 'tipologie_immobili', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_immobili', 'tipologie_immobili_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_immobili', 'tipologie_immobili_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_indirizzi', 'tipologie_indirizzi_ibfk_01_nofollow', 'id_genitore', 'tipologie_indirizzi', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_indirizzi', 'tipologie_indirizzi_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_indirizzi', 'tipologie_indirizzi_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_licenze', 'tipologie_licenze_ibfk_01_nofollow', 'id_genitore', 'tipologie_licenze', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_licenze', 'tipologie_licenze_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_licenze', 'tipologie_licenze_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_luoghi', 'tipologie_luoghi_ibfk_01_nofollow', 'id_genitore', 'tipologie_luoghi', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_luoghi', 'tipologie_luoghi_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_luoghi', 'tipologie_luoghi_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_mastri', 'tipologie_mastri_ibfk_01_nofollow', 'id_genitore', 'tipologie_mastri', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_mastri', 'tipologie_mastri_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_mastri', 'tipologie_mastri_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_listini', 'tipologie_listini_ibfk_01_nofollow', 'id_genitore', 'tipologie_listini', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_listini', 'tipologie_listini_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_listini', 'tipologie_listini_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_mail_status', 'tipologie_mail_status_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_mail_status', 'tipologie_mail_status_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_notizie', 'tipologie_notizie_ibfk_01_nofollow', 'id_genitore', 'tipologie_notizie', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_notizie', 'tipologie_notizie_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_notizie', 'tipologie_notizie_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_pagamenti', 'tipologie_pagamenti_ibfk_01_nofollow', 'id_genitore', 'tipologie_pagamenti', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_pagamenti', 'tipologie_pagamenti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_pagamenti', 'tipologie_pagamenti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_periodi', 'tipologie_periodi_ibfk_01_nofollow', 'id_genitore', 'tipologie_periodi', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_periodi', 'tipologie_periodi_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_periodi', 'tipologie_periodi_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_popup', 'tipologie_popup_ibfk_01_nofollow', 'id_genitore', 'tipologie_popup', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_popup', 'tipologie_popup_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_popup', 'tipologie_popup_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_prodotti', 'tipologie_prodotti_ibfk_01_nofollow', 'id_genitore', 'tipologie_prodotti', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_prodotti', 'tipologie_prodotti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_prodotti', 'tipologie_prodotti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_progetti', 'tipologie_progetti_ibfk_01_nofollow', 'id_genitore', 'tipologie_progetti', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_progetti', 'tipologie_progetti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_progetti', 'tipologie_progetti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_pubblicazioni', 'tipologie_pubblicazioni_ibfk_01_nofollow', 'id_genitore', 'tipologie_pubblicazioni', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_pubblicazioni', 'tipologie_pubblicazioni_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_pubblicazioni', 'tipologie_pubblicazioni_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_rinnovi', 'tipologie_rinnovi_ibfk_01_nofollow', 'id_genitore', 'tipologie_rinnovi', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_rinnovi', 'tipologie_rinnovi_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_rinnovi', 'tipologie_rinnovi_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_sconti', 'tipologie_sconti_ibfk_01_nofollow', 'id_genitore', 'tipologie_sconti', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_sconti', 'tipologie_sconti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_sconti', 'tipologie_sconti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_spedizioni', 'tipologie_spedizioni_ibfk_01_nofollow', 'id_genitore', 'tipologie_spedizioni', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_spedizioni', 'tipologie_spedizioni_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_spedizioni', 'tipologie_spedizioni_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_risorse', 'tipologie_risorse_ibfk_01_nofollow', 'id_genitore', 'tipologie_risorse', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_risorse', 'tipologie_risorse_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_risorse', 'tipologie_risorse_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_telefoni', 'tipologie_telefoni_ibfk_01_nofollow', 'id_genitore', 'tipologie_telefoni', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_telefoni', 'tipologie_telefoni_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_telefoni', 'tipologie_telefoni_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_todo', 'tipologie_todo_ibfk_01_nofollow', 'id_genitore', 'tipologie_todo', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_todo', 'tipologie_todo_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_todo', 'tipologie_todo_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_url', 'tipologie_url_ibfk_01_nofollow', 'id_genitore', 'tipologie_url', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_url', 'tipologie_url_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_url', 'tipologie_url_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_zone', 'tipologie_zone_ibfk_01_nofollow', 'id_genitore', 'tipologie_zone', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_zone', 'tipologie_zone_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_zone', 'tipologie_zone_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_veicoli', 'tipologie_veicoli_ibfk_01_nofollow', 'id_genitore', 'tipologie_veicoli', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_veicoli', 'tipologie_veicoli_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_veicoli', 'tipologie_veicoli_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'todo', 'todo_ibfk_01_nofollow', 'id_tipologia', 'tipologie_todo', 'NO ACTION', 'CASCADE', NULL ),
( 'todo', 'todo_ibfk_02_nofollow', 'id_anagrafica', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'todo', 'todo_ibfk_03_nofollow', 'id_cliente', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'todo', 'todo_ibfk_04_nofollow', 'id_indirizzo', 'indirizzi', 'SET NULL', 'SET NULL', NULL ),
( 'todo', 'todo_ibfk_05_nofollow', 'id_luogo', 'luoghi', 'SET NULL', 'SET NULL', NULL ),
( 'todo', 'todo_ibfk_06_nofollow', 'id_contatto', 'contatti', 'SET NULL', 'SET NULL', NULL ),
( 'todo', 'todo_ibfk_07_nofollow', 'id_progetto', 'progetti', 'SET NULL', 'SET NULL', NULL ),
( 'todo', 'todo_ibfk_08_nofollow', 'id_documento', 'documenti', 'SET NULL', 'SET NULL', NULL ),
( 'todo', 'todo_ibfk_09_nofollow', 'id_documenti_articoli', 'documenti_articoli', 'SET NULL', 'SET NULL', NULL ),
( 'todo', 'todo_ibfk_10_nofollow', 'id_istruzione', 'istruzioni', 'SET NULL', 'SET NULL', NULL ),
( 'todo', 'todo_ibfk_11_nofollow', 'id_pianificazione', 'pianificazioni', 'SET NULL', 'SET NULL', NULL ),
( 'todo', 'todo_ibfk_12_nofollow', 'id_immobile', 'immobili', 'SET NULL', 'SET NULL', NULL ),
( 'todo', 'todo_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'todo', 'todo_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'todo_matricole', 'todo_matricole_ibfk_01', 'id_todo', 'todo', 'CASCADE', 'CASCADE', NULL ),
( 'todo_matricole', 'todo_matricole_ibfk_02_nofollow', 'id_matricola', 'matricole', 'CASCADE', 'CASCADE', NULL ),
( 'todo_matricole', 'todo_matricole_ibfk_03_nofollow', 'id_ruolo', 'ruoli_matricole', 'NO ACTION', 'CASCADE', NULL ),
( 'todo_matricole', 'todo_matricole_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'todo_matricole', 'todo_matricole_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'udm', 'udm_ibfk_01_nofollow', 'id_base', 'udm', 'SET NULL', 'SET NULL', NULL ),
( 'udm', 'udm_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'udm', 'udm_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'url', 'url_ibfk_01_nofollow', 'id_tipologia', 'tipologie_url', 'NO ACTION', 'CASCADE', NULL ),
( 'url', 'url_ibfk_02', 'id_anagrafica', 'anagrafica', 'CASCADE', 'CASCADE', NULL );

-- | 202610021713

-- i vincoli del canone, parte 13 di 13
INSERT IGNORE INTO `__patch_chiavi_canone__` ( `tabella`, `vincolo`, `colonna`, `riferimento`, `cancellazione`, `aggiornamento`, `condizione` ) VALUES
( 'url', 'url_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'url', 'url_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'valutazioni', 'valutazioni_ibfk_01_nofollow', 'id_anagrafica', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'valutazioni', 'valutazioni_ibfk_02_nofollow', 'id_matricola', 'matricole', 'SET NULL', 'SET NULL', NULL ),
( 'valutazioni', 'valutazioni_ibfk_03_nofollow', 'id_immobile', 'immobili', 'SET NULL', 'SET NULL', NULL ),
( 'valutazioni', 'valutazioni_ibfk_04_nofollow', 'id_condizione', 'condizioni', 'SET NULL', 'SET NULL', NULL ),
( 'valutazioni', 'valutazioni_ibfk_05_nofollow', 'id_disponibilita', 'disponibilita', 'SET NULL', 'SET NULL', NULL ),
( 'valutazioni', 'valutazioni_ibfk_06_nofollow', 'id_classe_energetica', 'classi_energetiche', 'SET NULL', 'SET NULL', NULL ),
( 'valutazioni', 'valutazioni_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'valutazioni', 'valutazioni_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'valutazioni_certificazioni', 'valutazioni_certificazioni_ibfk_01', 'id_valutazione', 'valutazioni', 'CASCADE', 'CASCADE', NULL ),
( 'valutazioni_certificazioni', 'valutazioni_certificazioni_ibfk_02_nofollow', 'id_certificazione', 'certificazioni', 'CASCADE', 'CASCADE', NULL ),
( 'valutazioni_certificazioni', 'valutazioni_certificazioni_ibfk_03_nofollow', 'id_emittente', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'valutazioni_certificazioni', 'valutazioni_certificazioni_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'valutazioni_certificazioni', 'valutazioni_certificazioni_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'valute', 'valute_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'valute', 'valute_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'taglie', 'taglie_ibfk_01_nofollow', 'id_tipologia_prodotti', 'tipologie_prodotti', 'SET NULL', 'SET NULL', NULL ),
( 'taglie', 'taglie_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'taglie', 'taglie_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'veicoli', 'veicoli_ibfk_01_nofollow', 'id_tipologia', 'tipologie_veicoli', 'NO ACTION', 'CASCADE', NULL ),
( 'veicoli', 'veicoli_ibfk_02_nofollow', 'id_costruttore', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'veicoli', 'veicoli_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'veicoli', 'veicoli_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'video', 'video_ibfk_01', 'id_anagrafica', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'video', 'video_ibfk_02', 'id_pagina', 'pagine', 'SET NULL', 'SET NULL', NULL ),
( 'video', 'video_ibfk_03', 'id_file', 'file', 'SET NULL', 'SET NULL', NULL ),
( 'video', 'video_ibfk_04', 'id_prodotto', 'prodotti', 'SET NULL', 'SET NULL', NULL ),
( 'video', 'video_ibfk_05', 'id_articolo', 'articoli', 'SET NULL', 'SET NULL', NULL ),
( 'video', 'video_ibfk_06', 'id_categoria_prodotti', 'categorie_prodotti', 'SET NULL', 'SET NULL', NULL ),
( 'video', 'video_ibfk_07', 'id_risorsa', 'risorse', 'SET NULL', 'SET NULL', NULL ),
( 'video', 'video_ibfk_08', 'id_categoria_risorse', 'categorie_risorse', 'SET NULL', 'SET NULL', NULL ),
( 'video', 'video_ibfk_09', 'id_notizia', 'notizie', 'SET NULL', 'SET NULL', NULL ),
( 'video', 'video_ibfk_10', 'id_categoria_notizie', 'categorie_notizie', 'SET NULL', 'SET NULL', NULL ),
( 'video', 'video_ibfk_11', 'id_annuncio', 'annunci', 'SET NULL', 'SET NULL', NULL ),
( 'video', 'video_ibfk_12', 'id_categoria_annunci', 'categorie_annunci', 'SET NULL', 'SET NULL', NULL ),
( 'video', 'video_ibfk_13_nofollow', 'id_lingua', 'lingue', 'SET NULL', 'SET NULL', NULL ),
( 'video', 'video_ibfk_14_nofollow', 'id_ruolo', 'ruoli_video', 'NO ACTION', 'CASCADE', NULL ),
( 'video', 'video_ibfk_16', 'id_progetto', 'progetti', 'SET NULL', 'SET NULL', NULL ),
( 'video', 'video_ibfk_17', 'id_categoria_progetti', 'categorie_progetti', 'SET NULL', 'SET NULL', NULL ),
( 'video', 'video_ibfk_18', 'id_indirizzo', 'indirizzi', 'SET NULL', 'SET NULL', NULL ),
( 'video', 'video_ibfk_19', 'id_edificio', 'edifici', 'SET NULL', 'SET NULL', NULL ),
( 'video', 'video_ibfk_20', 'id_immobile', 'immobili', 'SET NULL', 'SET NULL', NULL ),
( 'video', 'video_ibfk_21', 'id_valutazione', 'valutazioni', 'SET NULL', 'SET NULL', NULL ),
( 'video', 'video_ibfk_22', 'id_marchio', 'marchi', 'SET NULL', 'SET NULL', NULL ),
( 'video', 'video_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'video', 'video_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'zone', 'zone_ibfk_01_nofollow', 'id_genitore', 'zone', 'NO ACTION', 'CASCADE', NULL ),
( 'zone', 'zone_ibfk_02_nofollow', 'id_tipologia', 'tipologie_zone', 'NO ACTION', 'CASCADE', NULL ),
( 'zone', 'zone_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'zone', 'zone_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'zone_cap', 'zone_cap_ibfk_01', 'id_zona', 'zone', 'CASCADE', 'CASCADE', NULL ),
( 'zone_cap', 'zone_cap_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'zone_cap', 'zone_cap_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'zone_indirizzi', 'zone_indirizzi_ibfk_01', 'id_zona', 'zone', 'CASCADE', 'CASCADE', NULL ),
( 'zone_indirizzi', 'zone_indirizzi_ibfk_02', 'id_indirizzo', 'indirizzi', 'CASCADE', 'CASCADE', NULL ),
( 'zone_indirizzi', 'zone_indirizzi_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'zone_indirizzi', 'zone_indirizzi_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'zone_stati', 'zone_stati_ibfk_01', 'id_zona', 'zone', 'CASCADE', 'CASCADE', NULL ),
( 'zone_stati', 'zone_stati_ibfk_02_nofollow', 'id_stato', 'stati', 'CASCADE', 'CASCADE', NULL ),
( 'zone_stati', 'zone_stati_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'zone_stati', 'zone_stati_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'test', 'test_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'test', 'test_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL );

-- | 202610021714

-- la procedura che scorre la lista e aggiunge i vincoli che si possono aggiungere ( la stessa di _202609301100 )
CREATE OR REPLACE PROCEDURE `__patch_chiavi_canone__`()
BEGIN

    DECLARE fine INT DEFAULT 0;
    DECLARE errore INT DEFAULT 0;
    DECLARE messaggio TEXT DEFAULT NULL;
    DECLARE v_tabella, v_vincolo, v_colonna, v_riferimento CHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci;
    DECLARE v_cancellazione, v_aggiornamento CHAR(16) CHARACTER SET utf8 COLLATE utf8_general_ci;
    DECLARE v_condizione CHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci;
    DECLARE v_tipo_figlia, v_tipo_padre, v_nullabile CHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci;
    DECLARE v_esito CHAR(255) CHARACTER SET utf8 COLLATE utf8_general_ci;
    DECLARE v_indice TEXT DEFAULT NULL;
    DECLARE v_vecchio_nome VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci;
    DECLARE v_vecchia_cancellazione, v_vecchio_aggiornamento CHAR(16) CHARACTER SET utf8 COLLATE utf8_general_ci;
    DECLARE v_da_correggere VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci;

    DECLARE lista CURSOR FOR
        SELECT `tabella`, `vincolo`, `colonna`, `riferimento`, `cancellazione`, `aggiornamento`, `condizione`,
            `vecchio_nome`, `vecchia_cancellazione`, `vecchio_aggiornamento`
        FROM `__patch_chiavi_canone__`
        WHERE `esito` IS NULL
        ORDER BY `tabella`, `vincolo`;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fine = 1;

    SET @chiavi_canone_controlli = @@foreign_key_checks;
    SET @chiavi_canone_aggiunte = 0;
    SET @chiavi_canone_corrette = 0;
    SET @chiavi_canone_note = NULL;

    OPEN lista;

    ciclo: LOOP

        FETCH lista INTO v_tabella, v_vincolo, v_colonna, v_riferimento, v_cancellazione, v_aggiornamento, v_condizione,
            v_vecchio_nome, v_vecchia_cancellazione, v_vecchio_aggiornamento;
        IF fine = 1 THEN
            LEAVE ciclo;
        END IF;

        SET v_esito = NULL, v_tipo_figlia = NULL, v_tipo_padre = NULL, v_nullabile = NULL, v_indice = NULL, v_da_correggere = NULL;

        -- i vincoli da correggere: si correggono solo se sul deploy sono ancora esattamente quelli di prima
        IF v_vecchio_nome IS NOT NULL THEN
            SELECT k.CONSTRAINT_NAME INTO v_da_correggere
                FROM information_schema.KEY_COLUMN_USAGE AS k
                INNER JOIN information_schema.REFERENTIAL_CONSTRAINTS AS r
                    ON r.CONSTRAINT_SCHEMA = k.CONSTRAINT_SCHEMA AND r.CONSTRAINT_NAME = k.CONSTRAINT_NAME AND r.TABLE_NAME = k.TABLE_NAME
                WHERE k.TABLE_SCHEMA = database() AND k.TABLE_NAME = v_tabella AND k.COLUMN_NAME = v_colonna
                  AND k.REFERENCED_TABLE_NAME = v_riferimento
                  AND BINARY k.CONSTRAINT_NAME = BINARY v_vecchio_nome
                  AND r.DELETE_RULE = v_vecchia_cancellazione AND r.UPDATE_RULE = v_vecchio_aggiornamento
                LIMIT 1;
        END IF;

        SELECT COLUMN_TYPE, IS_NULLABLE INTO v_tipo_figlia, v_nullabile
            FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = database() AND TABLE_NAME = v_tabella AND COLUMN_NAME = v_colonna
            LIMIT 1;

        SELECT COLUMN_TYPE INTO v_tipo_padre
            FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = database() AND TABLE_NAME = v_riferimento AND COLUMN_NAME = 'id'
            LIMIT 1;

        -- fine si alza anche quando una delle due SELECT qui sopra non trova niente
        SET fine = 0;

        IF v_da_correggere IS NOT NULL THEN
            BEGIN
                DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
                    BEGIN
                        GET DIAGNOSTICS CONDITION 1 messaggio = MESSAGE_TEXT;
                        SET errore = 1;
                    END;
                SET errore = 0;
                SET foreign_key_checks = 0;
                SET @chiavi_canone_sql = CONCAT( 'ALTER TABLE `', v_tabella, '` DROP FOREIGN KEY `', v_da_correggere, '`' );
                PREPARE togli FROM @chiavi_canone_sql;
                EXECUTE togli;
                DEALLOCATE PREPARE togli;
                IF errore = 0 THEN
                    SET @chiavi_canone_sql = CONCAT(
                        'ALTER TABLE `', v_tabella, '` ADD CONSTRAINT `', v_vincolo, '` FOREIGN KEY (`', v_colonna, '`) ',
                        'REFERENCES `', v_riferimento, '` (`id`) ON DELETE ', v_cancellazione, ' ON UPDATE ', v_aggiornamento
                    );
                    PREPARE metti FROM @chiavi_canone_sql;
                    EXECUTE metti;
                    DEALLOCATE PREPARE metti;
                    IF errore = 1 THEN
                        -- se la nuova non entra si rimette la vecchia, cosi' la colonna non resta senza vincolo
                        SET @chiavi_canone_sql = CONCAT(
                            'ALTER TABLE `', v_tabella, '` ADD CONSTRAINT `', v_da_correggere, '` FOREIGN KEY (`', v_colonna, '`) ',
                            'REFERENCES `', v_riferimento, '` (`id`) ON DELETE ', v_vecchia_cancellazione, ' ON UPDATE ', v_vecchio_aggiornamento
                        );
                        PREPARE metti FROM @chiavi_canone_sql;
                        EXECUTE metti;
                        DEALLOCATE PREPARE metti;
                        SET v_esito = LEFT( CONCAT( 'correzione fallita, rimesso il vincolo di prima: ', messaggio ), 255 );
                    ELSE
                        SET v_esito = 'corretto', @chiavi_canone_corrette = @chiavi_canone_corrette + 1;
                    END IF;
                ELSE
                    SET v_esito = LEFT( CONCAT( 'correzione fallita: ', messaggio ), 255 );
                END IF;
                SET foreign_key_checks = @chiavi_canone_controlli;
            END;
        ELSEIF v_tipo_figlia IS NULL THEN
            SET v_esito = CONCAT( 'non esiste ', v_tabella, '.', v_colonna );
        ELSEIF v_tipo_padre IS NULL THEN
            SET v_esito = CONCAT( 'non esiste ', v_riferimento, '.id' );
        ELSEIF EXISTS (
            SELECT 1 FROM information_schema.KEY_COLUMN_USAGE
            WHERE TABLE_SCHEMA = database() AND TABLE_NAME = v_tabella AND COLUMN_NAME = v_colonna
              AND REFERENCED_TABLE_NAME IS NOT NULL
        ) THEN
            SET v_esito = 'presente';
        ELSEIF v_condizione IS NOT NULL AND NOT EXISTS (
            SELECT 1 FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = database()
              AND TABLE_NAME = SUBSTRING_INDEX( v_condizione, '.', 1 )
              AND COLUMN_NAME = SUBSTRING_INDEX( v_condizione, '.', -1 )
        ) THEN
            SET v_esito = CONCAT( 'manca ', v_condizione, ', da cui il vincolo dipende' );
        ELSEIF EXISTS (
            SELECT 1 FROM information_schema.TABLE_CONSTRAINTS
            WHERE CONSTRAINT_SCHEMA = database() AND CONSTRAINT_NAME = v_vincolo
        ) THEN
            SET v_esito = 'il nome e'' gia'' usato da un altro vincolo';
        ELSEIF NOT EXISTS (
            SELECT 1 FROM information_schema.STATISTICS
            WHERE TABLE_SCHEMA = database() AND TABLE_NAME = v_riferimento AND COLUMN_NAME = 'id'
              AND SEQ_IN_INDEX = 1 AND NON_UNIQUE = 0
        ) THEN
            SET v_esito = CONCAT( v_riferimento, '.id non e'' una chiave' );
        ELSEIF v_tipo_figlia <> v_tipo_padre THEN
            SET v_esito = CONCAT( 'tipi diversi, ', v_tabella, '.', v_colonna, ' ', v_tipo_figlia, ' e ', v_riferimento, '.id ', v_tipo_padre );
        ELSEIF v_cancellazione = 'SET NULL' AND v_nullabile = 'NO' THEN
            SET v_esito = CONCAT( v_tabella, '.', v_colonna, ' e'' NOT NULL e il vincolo e'' ON DELETE SET NULL' );
        END IF;

        -- righe orfane
        IF v_esito IS NULL THEN
            BEGIN
                DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
                    BEGIN
                        GET DIAGNOSTICS CONDITION 1 messaggio = MESSAGE_TEXT;
                        SET errore = 1;
                    END;
                SET errore = 0, @chiavi_canone_orfani = NULL;
                SET @chiavi_canone_sql = CONCAT(
                    'SELECT count(*) INTO @chiavi_canone_orfani FROM `', v_tabella, '` AS figlie ',
                    'LEFT JOIN `', v_riferimento, '` AS padri ON padri.id = figlie.`', v_colonna, '` ',
                    'WHERE figlie.`', v_colonna, '` IS NOT NULL AND padri.id IS NULL'
                );
                PREPARE controllo FROM @chiavi_canone_sql;
                EXECUTE controllo;
                DEALLOCATE PREPARE controllo;
                IF errore = 1 THEN
                    SET v_esito = LEFT( CONCAT( 'controllo delle righe orfane fallito: ', messaggio ), 255 );
                ELSEIF @chiavi_canone_orfani > 0 THEN
                    SET v_esito = CONCAT( @chiavi_canone_orfani, ' righe di ', v_tabella, ' con un ', v_colonna, ' che non esiste in ', v_riferimento );
                END IF;
            END;
        END IF;

        -- il vincolo, con il suo indice se la colonna non ne ha uno
        IF v_esito IS NULL THEN
            IF NOT EXISTS (
                SELECT 1 FROM information_schema.STATISTICS
                WHERE TABLE_SCHEMA = database() AND TABLE_NAME = v_tabella AND COLUMN_NAME = v_colonna AND SEQ_IN_INDEX = 1
            ) AND NOT EXISTS (
                SELECT 1 FROM information_schema.STATISTICS
                WHERE TABLE_SCHEMA = database() AND TABLE_NAME = v_tabella AND INDEX_NAME = v_colonna
            ) THEN
                SET v_indice = CONCAT( 'ADD KEY `', v_colonna, '` (`', v_colonna, '`), ' );
            END IF;
            BEGIN
                DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
                    BEGIN
                        GET DIAGNOSTICS CONDITION 1 messaggio = MESSAGE_TEXT;
                        SET errore = 1;
                    END;
                SET errore = 0;
                SET @chiavi_canone_sql = CONCAT(
                    'ALTER TABLE `', v_tabella, '` ', IFNULL( v_indice, '' ),
                    'ADD CONSTRAINT `', v_vincolo, '` FOREIGN KEY (`', v_colonna, '`) REFERENCES `', v_riferimento, '` (`id`) ',
                    'ON DELETE ', v_cancellazione, ' ON UPDATE ', v_aggiornamento
                );
                SET foreign_key_checks = 0;
                PREPARE aggiunta FROM @chiavi_canone_sql;
                EXECUTE aggiunta;
                DEALLOCATE PREPARE aggiunta;
                SET foreign_key_checks = @chiavi_canone_controlli;
                IF errore = 1 THEN
                    SET v_esito = LEFT( CONCAT( 'ALTER TABLE fallita: ', messaggio ), 255 );
                ELSE
                    SET v_esito = 'aggiunto', @chiavi_canone_aggiunte = @chiavi_canone_aggiunte + 1;
                END IF;
            END;
        END IF;

        UPDATE `__patch_chiavi_canone__` SET `esito` = v_esito
            WHERE `tabella` = v_tabella AND `vincolo` = v_vincolo;

        IF v_esito NOT IN ( 'presente', 'aggiunto', 'corretto' ) THEN
            SET @chiavi_canone_note = CONCAT_WS( '\n', @chiavi_canone_note, CONCAT( v_vincolo, ': ', v_esito ) );
        END IF;

    END LOOP;

    CLOSE lista;

    SET foreign_key_checks = @chiavi_canone_controlli;

END;

-- | 202610021715

-- si esegue
CALL `__patch_chiavi_canone__`();

-- | 202610021716

-- quello che non e' stato aggiunto, e perche': lo legge chi applica la patch a mano
SELECT @chiavi_canone_aggiunte AS aggiunte, @chiavi_canone_corrette AS corrette, @chiavi_canone_note AS nota;

-- | 202610021717

-- 98 e 99 scambiate e indici con il nome della colonna: solo dove la situazione è ancora quella di prima
CREATE OR REPLACE PROCEDURE `__patch_chiavi_canone_ritocchi__`()
BEGIN

    DECLARE v_tabella CHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci;
    DECLARE v_i INT DEFAULT 1;

    SET @chiavi_canone_controlli = @@foreign_key_checks;

    WHILE v_i <= 2 DO
        SET v_tabella = ELT( v_i, 'carrelli_documenti', 'crediti' );
        IF EXISTS (
            SELECT 1 FROM information_schema.KEY_COLUMN_USAGE
            WHERE TABLE_SCHEMA = database() AND TABLE_NAME = v_tabella
              AND CONSTRAINT_NAME = CONCAT( v_tabella, '_ibfk_98_nofollow' ) AND COLUMN_NAME = 'id_account_aggiornamento'
        ) AND EXISTS (
            SELECT 1 FROM information_schema.KEY_COLUMN_USAGE
            WHERE TABLE_SCHEMA = database() AND TABLE_NAME = v_tabella
              AND CONSTRAINT_NAME = CONCAT( v_tabella, '_ibfk_99_nofollow' ) AND COLUMN_NAME = 'id_account_inserimento'
        ) THEN
            SET foreign_key_checks = 0;
            SET @chiavi_canone_sql = CONCAT( 'ALTER TABLE `', v_tabella, '` DROP FOREIGN KEY `', v_tabella, '_ibfk_98_nofollow`, ',
                'DROP FOREIGN KEY `', v_tabella, '_ibfk_99_nofollow`' );
            PREPARE togli FROM @chiavi_canone_sql; EXECUTE togli; DEALLOCATE PREPARE togli;
            SET @chiavi_canone_sql = CONCAT( 'ALTER TABLE `', v_tabella, '` ',
                'ADD CONSTRAINT `', v_tabella, '_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL, ',
                'ADD CONSTRAINT `', v_tabella, '_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL' );
            PREPARE metti FROM @chiavi_canone_sql; EXECUTE metti; DEALLOCATE PREPARE metti;
            SET foreign_key_checks = @chiavi_canone_controlli;
            SET @chiavi_canone_corrette = IFNULL( @chiavi_canone_corrette, 0 ) + 2;
        END IF;
        SET v_i = v_i + 1;
    END WHILE;

    SET v_i = 1;
    WHILE v_i <= 2 DO
        SET v_tabella = ELT( v_i, 'zone_indirizzi', 'zone_stati' );
        -- la guardia sull'indice sta qui e non nell'ALTER: MySQL non conosce ADD KEY IF NOT EXISTS, e in una stringa passata
        -- a PREPARE il traduttore non la vede ( 1064 sulla copia della PROD di gimbe, 03/10/2026 )
        IF EXISTS (
            SELECT 1 FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = database() AND TABLE_NAME = v_tabella AND COLUMN_NAME = 'id_zona'
        ) AND NOT EXISTS (
            SELECT 1 FROM information_schema.STATISTICS
            WHERE TABLE_SCHEMA = database() AND TABLE_NAME = v_tabella AND INDEX_NAME = 'id_zona'
        ) THEN
            SET @chiavi_canone_sql = CONCAT( 'ALTER TABLE `', v_tabella, '` ADD KEY `id_zona` (`id_zona`)' );
            PREPARE indice FROM @chiavi_canone_sql; EXECUTE indice; DEALLOCATE PREPARE indice;
        END IF;
        SET v_i = v_i + 1;
    END WHILE;

END;

-- | 202610021718

CALL `__patch_chiavi_canone_ritocchi__`();

-- | 202610021719

-- si liberano le procedure
DROP PROCEDURE IF EXISTS `__patch_chiavi_canone_ritocchi__`;

-- | 202610021720

DROP PROCEDURE IF EXISTS `__patch_chiavi_canone__`;

-- | 202610021721

-- e la lista di lavoro
DROP TABLE IF EXISTS `__patch_chiavi_canone__`;

-- | FINE
