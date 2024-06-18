--
-- INDICI
-- questo file contiene le query per la creazione degli indici delle tabelle
--
-- CRITERI DI VERIFICA
-- una definizione di indici può dirsi verificata se:
-- - non si riferisce a tabelle deprecate e non contiene colonne deprecate
-- - riporta prima le definizioni di chiavi primarie, poi le uniche, poi gli indici generali
-- - le chiavi uniche sono nominate con il prefisso unica_ (la prima si chiama semplicemente unica)
-- - nella parte degli indici generali, riporta per primi gli indici che si riferiscono a chiavi esterne (identificate dal prefisso id_)
-- - nella parte degli indici generali, le colonne appaiono nell'ordine in cui compaiono nella tabella
-- - nella parte degli indici generali, le colonne indicizzate appaiono nello stesso ordine in cui appaiono nella tabella
-- - nella parte degli indici generali, dopo le colonne relative a chiavi esterne appaiono le colonne di flag (identificate dal prefisso se_)
-- - la parte degli indidi si chiude con gli indici multicolonna, nominati con il prefisso indice_ (il primo si chiama semplicemente indice)
-- - ogni indice è sono correttamente documentato, in ordine, nel relativo file dox
-- - la chiave primaria, se intera, è dichiarata AUTO_INCREMENT
--

-- | 030000000100

-- account
-- tipologia: tabella gestita
-- verifica: 2021-05-20 13:59 Fabio Mosti
ALTER TABLE `account`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`username`),
	ADD KEY `id_anagrafica` (`id_anagrafica`),
	ADD KEY `id_mail` (`id_mail`),
	ADD KEY `id_affiliazione` (`id_affiliazione`),
	ADD KEY `id_url` (`id_url`),
	ADD KEY `se_attivo` (`se_attivo`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`, `id_anagrafica`, `username`, `id_mail`, `id_affiliazione`, `password`, `se_attivo`, `token`),
	ADD KEY `indice_token` (`id`,`token`);

-- | 030000000101

-- account
-- tipologia: tabella gestita
ALTER TABLE `account` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000000200

-- account_gruppi
-- tipologia: tabella gestita
-- verifica: 2021-05-20 15:56 Fabio Mosti
ALTER TABLE `account_gruppi`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_account`,`id_gruppo`),
	ADD KEY `id_account` (`id_account`),
	ADD KEY `id_gruppo` (`id_gruppo`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_account`,`id_gruppo`,`ordine`);

-- | 030000000201

-- account_gruppi
-- tipologia: tabella gestita
ALTER TABLE `account_gruppi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000000300

-- account_gruppi_attribuzione
-- tipologia: tabella gestita
-- verifica: 2021-05-20 17:05 Fabio Mosti
ALTER TABLE `account_gruppi_attribuzione`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_account`,`id_gruppo`,`entita`), 
	ADD KEY `id_account` (`id_account`), 
	ADD KEY `id_gruppo` (`id_gruppo`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`id_account`,`id_gruppo`,`ordine`,`entita`);

-- | 030000000301

-- account_gruppi_attribuzione
-- tipologia: tabella gestita
ALTER TABLE `account_gruppi_attribuzione` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000000400

-- anagrafica
-- tipologia: tabella gestita
-- verifica: 2021-05-20 17:05 Fabio Mosti
ALTER TABLE `anagrafica`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`codice`),
	ADD UNIQUE KEY `unica_persone` (`nome`,`cognome`,`codice_fiscale`),
	ADD UNIQUE KEY `unica_professionisti` (`nome`,`cognome`,`partita_iva`,`codice_fiscale`),
	ADD UNIQUE KEY `unica_aziende` (`denominazione`,`partita_iva`,`codice_fiscale`),
	ADD KEY `id_tipologia` (`id_tipologia`),
	ADD KEY `id_badge` (`id_badge`),
	ADD KEY `id_pec_sdi` (`id_pec_sdi`),
	ADD KEY `codice_archivium` (`codice_archivium`),
	ADD KEY `partita_iva` (`partita_iva`),
	ADD KEY `codice_fiscale` (`codice_fiscale`),
	ADD KEY `id_regime` (`id_regime`),
	ADD KEY `id_stato_nascita` (`id_stato_nascita`),
	ADD KEY `id_comune_nascita` (`id_comune_nascita`),
	ADD KEY `id_ranking` (`id_ranking`),	
	ADD KEY `id_agente` (`id_agente`),
	ADD KEY `id_responsabile_operativo` (`id_responsabile_operativo`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `se_importata` (`se_importata`),
	ADD KEY `se_stampa_privacy` (`se_stampa_privacy`),
	ADD KEY `data_archiviazione` (`data_archiviazione`),
	ADD KEY `indice` (`id`,`codice`,`nome`,`cognome`,`id_tipologia`,`denominazione`,`se_stampa_privacy`,`codice_fiscale`,`partita_iva`),
	ADD KEY `indice_riferimento` (`id`,`riferimento`),
	ADD KEY `indice_archiviazione` (`id`,`data_archiviazione`);

-- | 030000000401

-- anagrafica
-- tipologia: tabella gestita
ALTER TABLE `anagrafica` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;	

-- | 030000000500

-- anagrafica_categorie
-- tipologia: tabella gestita
-- verifica: 2021-05-20 19:01 Fabio Mosti
ALTER TABLE `anagrafica_categorie`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_anagrafica`,`id_categoria`),
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_categoria` (`id_categoria`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_anagrafica`,`id_categoria`,`ordine`);

-- | 030000000501

-- anagrafica_categorie
-- tipologia: tabella gestita
ALTER TABLE `anagrafica_categorie` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000000600

-- anagrafica_certificazioni
-- tipologia: tabella gestita
-- verifica: 2022-02-03 11:12 Chiara GDL
ALTER TABLE `anagrafica_certificazioni`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_anagrafica`,`id_certificazione`, `codice`),
	ADD KEY `id_certificazione` (`id_certificazione`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_emittente` (`id_emittente`), 
	ADD KEY `nome` (`nome`), 
	ADD KEY `codice` (`codice`), 
	ADD KEY `data_emissione` (`data_emissione`), 
	ADD KEY `data_scadenza` (`data_scadenza`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_anagrafica`,`id_certificazione`,`codice`, `id_emittente`, `nome`, `data_emissione`, `data_scadenza`);

-- | 030000000601

-- anagrafica_certificazioni
-- tipologia: tabella gestita	
ALTER TABLE `anagrafica_certificazioni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000000700

-- anagrafica_cittadinanze
-- tipologia: tabella gestita
-- verifica: 2021-05-20 21:26 Fabio Mosti
ALTER TABLE `anagrafica_cittadinanze`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_anagrafica`,`id_stato`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_stato` (`id_stato`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_anagrafica`,`id_stato`,`ordine`,`data_inizio`,`data_fine`);

-- | 030000000701

-- anagrafica_cittadinanze
-- tipologia: tabella gestita
ALTER TABLE `anagrafica_cittadinanze` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000000800

-- anagrafica_consensi
-- tipologia: tabella gestita
-- verifica: 2022-08-23 11:12 Chiara GDL
ALTER TABLE `anagrafica_consensi`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_anagrafica`, `id_consenso`), 
	ADD KEY `id_account` (`id_account`),
	ADD KEY `id_anagrafica` (`id_anagrafica`),
	ADD KEY `id_consenso` (`id_consenso`),
	ADD KEY `se_prestato` (`se_prestato`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`, `id_account`,`id_anagrafica`, `id_consenso`, `se_prestato` );

-- | 030000000801

-- anagrafica_consensi
-- tipologia: tabella gestita
ALTER TABLE `anagrafica_consensi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000000900

-- anagrafica_indirizzi
-- tipologia: tabella gestita
-- verifica: 2021-05-21 16:34 Fabio Mosti
ALTER TABLE `anagrafica_indirizzi`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `codice` (`codice`),
	ADD UNIQUE KEY `unica` (`id_anagrafica`,`id_indirizzo`), 
	ADD UNIQUE KEY `id_anagrafica_indirizzo` (`id_anagrafica`, `indirizzo`),
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_indirizzo` (`id_indirizzo`), 
	ADD KEY `id_ruolo` (`id_ruolo`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_anagrafica`,`id_indirizzo`,`id_ruolo`);

-- | 030000000901

-- anagrafica_indirizzi
-- tipologia: tabella gestita
ALTER TABLE `anagrafica_indirizzi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000000920

-- anagrafica_organizzazioni
ALTER TABLE `anagrafica_organizzazioni`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_anagrafica`,`id_organizzazione`,`id_ruolo`),
	ADD KEY `id_anagrafica` (`id_anagrafica`),
	ADD KEY `id_organizzazione` (`id_organizzazione`),
	ADD KEY `id_ruolo` (`id_ruolo`);

-- | 030000000921

-- anagrafica_organizzazioni
ALTER TABLE `anagrafica_organizzazioni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000000940

-- anagrafica_progetti
ALTER TABLE `anagrafica_progetti`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_anagrafica`,`id_progetto`,`id_ruolo`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_progetto` (`id_progetto`), 
	ADD KEY `id_ruolo` (`id_ruolo`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `se_attesa` (`se_attesa`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_anagrafica`,`id_progetto`,`id_ruolo`,`ordine`);

-- | 030000000941

-- anagrafica_progetti
ALTER TABLE `anagrafica_progetti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000001200

-- anagrafica_settori
-- tipologia: tabella gestita
-- verifica: 2021-05-23 15:28 Fabio Mosti
ALTER TABLE `anagrafica_settori`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_anagrafica`,`id_settore`),
	ADD KEY `id_anagrafica` (`id_anagrafica`),
	ADD KEY `id_settore` (`id_settore`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_anagrafica`,`id_settore`,`ordine`);

-- | 030000001201

-- anagrafica_settori
-- tipologia: tabella gestita
ALTER TABLE `anagrafica_settori` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000001250

-- annunci
ALTER TABLE `annunci`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_tipologia` (`id_tipologia`),
	ADD KEY `nome` (`nome`),
	ADD KEY `id_categoria_prodotti` (`id_categoria_prodotti`),
	ADD KEY `id_prodotto` (`id_prodotto`),
	ADD KEY `id_articolo` (`id_articolo`),
	ADD KEY `id_udm` (`id_udm`),
	ADD KEY `id_sito` (`id_sito`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);

-- | 030000001251

-- annunci
ALTER TABLE `annunci` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000001270

-- annunci_categorie
ALTER TABLE `annunci_categorie`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_annuncio` (`id_annuncio`),
	ADD KEY `id_categoria` (`id_categoria`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);

-- | 030000001271

-- annunci_categorie
ALTER TABLE `annunci_categorie` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000001300

-- articoli
-- tipologia: tabella gestita
-- verifica: 2021-05-25 11:23 Fabio Mosti
ALTER TABLE `articoli`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_prodotto` (`id_prodotto`), 
	ADD KEY `id_reparto` (`id_reparto`),
	ADD KEY `id_taglia` (`id_taglia`), 
    ADD KEY `id_colore` (`id_colore`), 
	ADD KEY `id_periodicita` (`id_periodicita`), 
	ADD KEY `id_tipologia_rinnovo` (`id_tipologia_rinnovo`), 
	ADD KEY `id_udm_dimensioni` (`id_udm_dimensioni`),
	ADD KEY `id_udm_peso` (`id_udm_peso`),
	ADD KEY `id_udm_volume` (`id_udm_volume`),
	ADD KEY `id_udm_capacita`(`id_udm_capacita`),
	ADD KEY `id_udm_durata`(`id_udm_durata`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`ordine`,`ean`,`isbn`,`id_prodotto`,`id_reparto`,`id_taglia`,`id_colore`),
	ADD KEY `indice_dimensioni` (`id`,`ordine`,`ean`,`isbn`,`id_prodotto`,`id_reparto`,`larghezza`,`lunghezza`,`altezza`,`peso`,`volume`,`capacita`);

-- | 030000001600

-- articoli_caratteristiche
-- tipologia: tabella gestita
-- verifica: 2021-05-25 12:11 Fabio Mosti
ALTER TABLE `articoli_caratteristiche`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_articolo`,`id_caratteristica`), 
	ADD KEY `id_articolo` (`id_articolo`),
	ADD KEY `id_caratteristica` (`id_caratteristica`),
	ADD KEY `indice` (`id`,`id_articolo`,`id_caratteristica`,`ordine`,`valore` (255),`se_assente` );

-- | 030000001601

-- articoli_caratteristiche
-- tipologia: tabella gestita
ALTER TABLE `articoli_caratteristiche` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000001700

-- asset
ALTER TABLE `asset`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_tipologia`,`codice`), 
	ADD KEY `id_tipologia` (`id_tipologia`),
	ADD KEY `codice` (`codice`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` ( `id`,`id_tipologia`,`codice` );

-- | 030000001701

-- asset
ALTER TABLE `asset` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000001800

-- attivita
-- tipologia: tabella gestita
-- verifica: 2021-05-27 15:07 Fabio Mosti
ALTER TABLE `attivita`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica_codice_archivium` (`codice_archivium`), 
	ADD UNIQUE KEY `codice` (`codice`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `id_tipologia` (`id_tipologia`),
	ADD KEY `id_cliente` (`id_cliente`),
	ADD KEY `id_contatto` (`id_contatto`),
	ADD KEY `id_indirizzo` (`id_indirizzo`), 
	ADD KEY `id_luogo` (`id_luogo`), 
	ADD KEY `id_oggetto` (`id_oggetto`), 
	ADD KEY `id_anagrafica_programmazione` (`id_anagrafica_programmazione`),
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_asset` (`id_asset`), 
	ADD KEY `id_mailing` (`id_mailing`), 
	ADD KEY `id_mail` (`id_mail`), 
	ADD KEY `id_documento` (`id_documento`), 
	ADD KEY `id_corrispondenza` (`id_corrispondenza`), 
	ADD KEY `id_pagamento` (`id_pagamento`), 
	ADD KEY `id_progetto` (`id_progetto`), 
	ADD KEY `id_contratto` (`id_contratto`), 
	ADD KEY `id_matricola` (`id_matricola`),
	ADD KEY `id_todo` (`id_todo`),
	ADD KEY `id_mastro_provenienza` (`id_mastro_provenienza`), 
	ADD KEY `id_mastro_destinazione` (`id_mastro_destinazione`), 
	ADD KEY `id_immobile` (`id_immobile`),
	ADD KEY `codice_archivium` (`codice_archivium`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `indice` (`id`,`id_tipologia`,`id_anagrafica`,`id_cliente`,`id_contatto`,`id_progetto`,`id_todo`),
	ADD KEY `indice_scadenza` (`id`,`id_tipologia`,`id_anagrafica`,`id_cliente`,`id_progetto`,`id_todo`,`data_scadenza`,`ora_scadenza`),
	ADD KEY `indice_programmazione` (`id`,`id_tipologia`,`id_anagrafica`,`id_cliente`,`id_progetto`,`id_todo`,`data_programmazione`,`ora_inizio_programmazione`,`ora_fine_programmazione`),
	ADD KEY `indice_attivita` (`id`,`id_tipologia`,`id_anagrafica`,`id_cliente`,`id_progetto`,`id_todo`,`data_attivita`,`ora_inizio`,`ora_fine`),
	ADD KEY `indice_mastri` (`id`,`id_tipologia`,`id_mastro_provenienza`,`id_mastro_destinazione`),
	ADD KEY `indice_sostituti` (`id`,`id_tipologia`,`id_anagrafica`,`id_cliente`,`id_progetto`,`id_todo`,`timestamp_calcolo_sostituti`),
	ADD KEY `indice_token` (`id`,`token`);

-- | 030000001801

-- attivita
-- tipologia: tabella gestita
ALTER TABLE `attivita` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000002100

-- audio
-- tipologia: tabella gestita
-- verifica: 2021-05-28 16:04 Fabio Mosti
ALTER TABLE `audio`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`path`), 
	ADD UNIQUE KEY `unica_codice_embed` (`codice_embed`), 
	ADD KEY `id_lingua` (`id_lingua`), 
	ADD KEY `id_ruolo` (`id_ruolo`), 
	ADD KEY `id_embed` (`id_embed`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_pagina` (`id_pagina`), 
	ADD KEY `id_file` (`id_file`), 
	ADD KEY `id_risorsa` (`id_risorsa`), 
	ADD KEY `id_prodotto` (`id_prodotto`), 
	ADD KEY `id_articolo` (`id_articolo`), 
	ADD KEY `id_categoria_prodotti` (`id_categoria_prodotti`), 
	ADD KEY `id_notizia` (`id_notizia`), 
	ADD KEY `id_annuncio` (`id_annuncio`),
	ADD KEY `id_categoria_notizie` (`id_categoria_notizie`),
	ADD KEY `id_progetto` (`id_progetto`),
	ADD KEY `id_categoria_progetti` (`id_categoria_progetti`),
	ADD KEY `id_indirizzo` (`id_indirizzo`), 
	ADD KEY `id_edificio` (`id_edificio`), 
	ADD KEY `id_immobile` (`id_immobile`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`id_ruolo`,`id_lingua`,`ordine`,`path`,`codice_embed`,`id_embed`),
	ADD KEY `indice_anagrafica` (`id`,`id_ruolo`,`id_lingua`,`ordine`,`path`,`codice_embed`,`id_embed`,`id_anagrafica`),
	ADD KEY `indice_pagine` (`id`,`id_ruolo`,`id_lingua`,`ordine`,`path`,`codice_embed`,`id_embed`,`id_pagina`,`id_file`,`id_risorsa`);

-- | 030000002101

-- audio
-- tipologia: tabella gestita
ALTER TABLE `audio` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000002250

-- badge
-- tipologia: tabella gestita
ALTER TABLE `badge`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`rfid`), 
	ADD UNIQUE KEY `codice` (`id_tipologia`, `codice`), 
	ADD KEY `id_tipologia` (`id_tipologia`), 
	ADD KEY `id_contratto` (`id_contratto`), 
	ADD KEY `nome` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`, `id_tipologia`, `id_contratto`, `codice`, `rfid`,`nome`);

-- | 030000002251

-- badge
-- tipologia: tabella gestita
ALTER TABLE `badge` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000002300

-- banner
-- tipologia: tabella gestita
-- verifica: 2022-07-20 17:22 Chiara GDL
ALTER TABLE `banner`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_tipologia` (`id_tipologia`), 
	ADD KEY `id_sito` (`id_sito`), 
	ADD KEY `ordine` (`ordine`), 
	ADD KEY `nome` (`nome`),
	ADD KEY `id_inserzionista` (`id_inserzionista`),
	ADD KEY `altezza_modulo` (`altezza_modulo`),	
	ADD KEY `larghezza_modulo` (`larghezza_modulo`),
	ADD KEY `token` (`token`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`, `id_tipologia`, `id_sito`, `ordine`,`nome`, `id_inserzionista`,`altezza_modulo`,`larghezza_modulo`, `token`);

-- | 030000002301

-- banner
-- tipologia: tabella gestita
ALTER TABLE `banner` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000002400

-- banner_azioni
-- tipologia: tabella gestita
-- verifica: 2022-07-21 10:22 Chiara GDL
ALTER TABLE `banner_azioni`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_banner` (`id_banner`), 
	ADD KEY `id_pagina` (`id_pagina`),
	ADD KEY `azione` (`azione`),
	ADD KEY `timestamp_azione` (`timestamp_azione`),
	ADD KEY `token` (`token`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_pagina`,`id_banner`,`azione`,`timestamp_azione`,`token`);

-- | 030000002401

-- banner_azioni
-- tipologia: tabella gestita
ALTER TABLE `banner_azioni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000002500

-- banner_pagine
-- tipologia: tabella gestita
-- verifica: 2022-07-21 10:22 Chiara GDL
ALTER TABLE `banner_pagine`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_pagina`,`id_banner`), 
	ADD KEY `id_banner` (`id_banner`), 
	ADD KEY `id_pagina` (`id_pagina`),
	ADD KEY `se_presente` (`se_presente`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_pagina`,`id_banner`,`se_presente`);

-- | 030000002501

-- banner_pagine
-- tipologia: tabella gestita
ALTER TABLE `banner_pagine` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000002600

-- banner_zone
-- tipologia: tabella gestita
-- verifica: 2022-08-04 10:22 Chiara GDL
ALTER TABLE `banner_zone`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_zona`,`id_banner`), 
	ADD KEY `id_banner` (`id_banner`), 
	ADD KEY `id_zona` (`id_zona`),
	ADD KEY `se_presente` (`se_presente`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_zona`,`id_banner`,`se_presente`);

-- | 030000002601

-- banner_zone
-- tipologia: tabella gestita
ALTER TABLE `banner_zone` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000002700

-- campagne
ALTER TABLE `campagne` 
	ADD PRIMARY KEY (`id`),
	ADD KEY `nome` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);
	
-- | 030000002701

-- campagne
ALTER TABLE `campagne` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;


-- | 030000002900

-- caratteristiche
-- tipologia: tabella gestita
-- verifica: 2021-05-28 18:27 Fabio Mosti
ALTER TABLE `caratteristiche`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`nome`,`se_categorie_prodotti`,`se_prodotto`,`se_articolo`);

-- | 030000002901

-- caratteristiche
-- tipologia: tabella gestita
ALTER TABLE `caratteristiche` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000003000

-- carrelli
-- tipologia: tabella gestita
-- verifica: 2022-07-12 14:45 Chiara GDL
ALTER TABLE `carrelli`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`codice`),
	ADD UNIQUE KEY `session` (`session`), 
	ADD KEY `id_listino` (`id_listino`),
	ADD KEY `destinatario_id_tipologia_anagrafica` (`destinatario_id_tipologia_anagrafica`),
	ADD KEY `destinatario_id_anagrafica` (`destinatario_id_anagrafica`),
	ADD KEY `destinatario_id_account` (`destinatario_id_account`),
	ADD KEY `destinatario_id_comune` (`destinatario_id_comune`),
	ADD KEY `destinatario_id_stato` (`destinatario_id_stato`),
	ADD KEY `destinatario_id_comune_nascita` (`destinatario_id_comune_nascita`),
	ADD KEY `destinatario_id_provincia_nascita` (`destinatario_id_provincia_nascita`),
	ADD KEY `destinatario_id_stato_nascita` (`destinatario_id_stato_nascita`),
	ADD KEY `intestazione_id_tipologia_anagrafica` (`intestazione_id_tipologia_anagrafica`),
	ADD KEY `intestazione_id_anagrafica` (`intestazione_id_anagrafica`),
	ADD KEY `intestazione_id_account` (`intestazione_id_account`),
	ADD KEY `intestazione_id_comune` (`intestazione_id_comune`),
	ADD KEY `intestazione_id_provincia` (`intestazione_id_provincia`),
	ADD KEY `intestazione_id_stato` (`intestazione_id_stato`),
	ADD KEY `intestazione_id_comune_nascita` (`intestazione_id_comune_nascita`),
	ADD KEY `intestazione_id_provincia_nascita` (`intestazione_id_provincia_nascita`),
	ADD KEY `intestazione_id_stato_nascita` (`intestazione_id_stato_nascita`),
	ADD KEY `nome` (`nome`),
	ADD KEY `ordine_pagamento` ( `ordine_pagamento` ),
	ADD KEY `utm_id` ( `utm_id` ),
	ADD KEY `utm_source` ( `utm_source` ),
	ADD KEY `utm_medium` ( `utm_medium` ),
	ADD KEY `utm_campaign` ( `utm_campaign` ),
	ADD KEY `utm_term` ( `utm_term` ),
	ADD KEY `utm_content` ( `utm_content` ),
	ADD KEY `spam_score` ( `spam_score` ),
	ADD KEY `spam_check` ( `spam_check` ),
	ADD KEY `id_reseller` ( `id_reseller` ),
	ADD KEY `id_affiliato` ( `id_affiliato` ),
	ADD KEY `id_affiliazione` ( `id_affiliazione` ),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_listino`,`prezzo_netto_totale`,`prezzo_lordo_totale`,`sconto_percentuale`,`sconto_valore`,`prezzo_netto_finale`,`prezzo_lordo_finale`,`provider_checkout`,`timestamp_checkout`,`provider_pagamento`,`timestamp_pagamento`,`codice_pagamento`,`status_pagamento`,`importo_pagamento`,`intestazione_id_anagrafica`);

-- | 030000003001

-- carrelli
-- tipologia: tabella gestita
ALTER TABLE `carrelli` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000003050

-- carrelli_articoli
-- tipologia: tabella gestita
-- verifica: 2022-07-12 14:45 Chiara GDL
ALTER TABLE `carrelli_articoli`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_carrello`,`id_articolo`,`destinatario_id_anagrafica`),
	ADD KEY `id_carrello` (`id_carrello`),  
	ADD KEY `id_articolo` (`id_articolo`),  
	ADD KEY `destinatario_id_anagrafica` (`destinatario_id_anagrafica`),
	ADD KEY `id_rinnovo` (`id_rinnovo`),
	ADD KEY `id_iva` (`id_iva`),
	ADD KEY `id_pagamento` (`id_pagamento`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`, `id_carrello`, `id_articolo`, `id_iva`, `prezzo_netto_unitario`, `prezzo_lordo_unitario`,`quantita`, `prezzo_netto_totale`,  `prezzo_lordo_totale`, `sconto_percentuale`, `sconto_valore`, `prezzo_netto_finale`,  `prezzo_lordo_finale`);

-- | 030000003051

-- carrelli_articoli
-- tipologia: tabella gestita
ALTER TABLE `carrelli_articoli` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000003060

-- carrelli_consensi
-- tipologia: tabella gestita
-- verifica: 2022-08-23 11:12 Chiara GDL
ALTER TABLE `carrelli_consensi`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_carrello`, `id_consenso`), 
	ADD KEY `id_account` (`id_account`),
	ADD KEY `id_anagrafica` (`id_anagrafica`),
	ADD KEY `id_carrello` (`id_carrello`),
	ADD KEY `id_consenso` (`id_consenso`),
	ADD KEY `se_prestato` (`se_prestato`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`, `id_account`, `id_anagrafica`, `id_carrello`, `id_consenso`, `se_prestato` );

-- | 030000003061

-- carrelli_consensi
-- tipologia: tabella gestita
ALTER TABLE `carrelli_consensi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000003070

-- carrelli_documenti
-- tipologia: tabella gestita
-- verifica: 2022-08-22 11:45 Chiara GDL
ALTER TABLE `carrelli_documenti`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_carrello`,`id_documento`),
	ADD KEY `id_carrello` (`id_carrello`),  
	ADD KEY `id_documento` (`id_documento`),  
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`, `id_carrello`,  `id_documento`, `id_account_inserimento`, `id_account_aggiornamento` );

-- | 030000003071

-- carrelli_documenti
-- tipologia: tabella gestita
ALTER TABLE `carrelli_documenti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000003100

-- categorie_anagrafica
-- tipologia: tabella assistita
-- verifica: 2021-05-28 19:56 Fabio Mosti
-- NOTA: riordinare i flag in ordine alfabetico
ALTER TABLE `categorie_anagrafica`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD UNIQUE KEY `codice` (`codice`),
	ADD KEY `id_genitore` (`id_genitore`), 
	ADD KEY `se_lead` (`se_lead`), 
	ADD KEY `se_prospect` (`se_prospect`), 
	ADD KEY `se_cliente` (`se_cliente`), 
	ADD KEY `se_fornitore` (`se_fornitore`), 
	ADD KEY `se_produttore` (`se_produttore`), 
	ADD KEY `se_collaboratore` (`se_collaboratore`), 
	ADD KEY `se_interno` (`se_interno`), 
	ADD KEY `se_esterno` (`se_esterno`), 
	ADD KEY `se_commerciale` (`se_commerciale`), 
	ADD KEY `se_concorrente` (`se_concorrente`), 
	ADD KEY `se_gestita` (`se_gestita`), 
	ADD KEY `se_amministrazione` (`se_amministrazione`), 
	ADD KEY `se_notizie` (`se_notizie`), 
	ADD KEY `se_corriere` (`se_corriere`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`se_lead`,`se_prospect`,`se_cliente`,`se_fornitore`,`se_produttore`,`se_collaboratore`,`se_interno`,`se_esterno`,`se_commerciale`,`se_concorrente`,`se_gestita`,`se_amministrazione`);

-- | 030000003101

-- categorie_anagrafica
-- tipologia: tabella assistita
ALTER TABLE `categorie_anagrafica` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000003300

-- categorie_annunci
ALTER TABLE `categorie_annunci`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD UNIQUE KEY `codice` (`codice`),
	ADD KEY `id_genitore` (`id_genitore`), 
	ADD KEY `id_sito` (`id_sito`), 
	ADD KEY `id_pagina` (`id_pagina`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`id_sito`,`id_pagina`);

-- | 030000003301

-- categorie_annunci
ALTER TABLE `categorie_annunci` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;


-- | 030000003700

-- categorie_notizie
-- tipologia: tabella gestita
-- verifica: 2021-06-01 18:28 Fabio Mosti
ALTER TABLE `categorie_notizie`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD UNIQUE KEY `codice` (`codice`),
	ADD KEY `id_genitore` (`id_genitore`), 
	ADD KEY `id_sito` (`id_sito`), 
	ADD KEY `id_pagina` (`id_pagina`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`id_sito`,`id_pagina`);

-- | 030000003701

-- categorie_notizie
-- tipologia: tabella gestita
ALTER TABLE `categorie_notizie` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000003900

-- categorie_prodotti
-- tipologia: tabella gestita
-- verifica: 2021-06-01 19:48 Fabio Mosti
ALTER TABLE `categorie_prodotti`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD UNIQUE KEY `codice` (`codice`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `id_sito` (`id_sito`), 
	ADD KEY `id_pagina` (`id_pagina`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`id_sito`,`id_pagina`);

-- | 030000003901

-- categorie_prodotti
-- tipologia: tabella gestita
ALTER TABLE `categorie_prodotti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000004300

-- categorie_progetti
-- tipologia: tabella gestita
-- verifica: 2021-06-02 20:10 Fabio Mosti
ALTER TABLE `categorie_progetti`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD UNIQUE KEY `codice` (`codice`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `se_sitemap` (`se_sitemap`),
	ADD KEY `se_cacheable` (`se_cacheable`),
	ADD KEY `id_sito` (`id_sito`),
	ADD KEY `id_pagina` (`id_pagina`),
	ADD KEY `se_ordinario`(`se_ordinario`),
	ADD KEY `se_straordinario`(`se_straordinario`),
	ADD KEY `se_disciplina`(`se_disciplina`),
	ADD KEY `se_classe`(`se_classe`),	
	ADD KEY `se_fascia` (`se_fascia`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`, `id_sito`);

-- | 030000004301

-- categorie_progetti
-- tipologia: tabella gestita
ALTER TABLE `categorie_progetti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000004500

-- categorie_risorse
-- tipologia: tabella gestita
-- verifica: 2021-06-02 20:10 Fabio Mosti
ALTER TABLE `categorie_risorse`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD UNIQUE KEY `codice` (`codice`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `id_sito` (`id_sito`),
	ADD KEY `id_pagina` (`id_pagina`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`id_pagina`);

-- | 030000004501

-- categorie_risorse
-- tipologia: tabella gestita
ALTER TABLE `categorie_risorse` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000004600

-- causali
-- tipologia: tabella gestita
-- verifica: 2022-05-04 20:04 Chiara GDL
ALTER TABLE `causali`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`nome`),
	ADD KEY `nome` (`nome`),
	ADD KEY `se_trasporto` (`se_trasporto`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`nome`,`se_trasporto`);

-- | 030000004601

-- causali
-- tipologia: tabella gestita
ALTER TABLE `causali` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000004700

-- certificazioni
-- tipologia: tabella assistita
-- verifica: 2022-02-03 11:12 Chiara GDL
ALTER TABLE `certificazioni`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`nome`); 

-- | 030000004701

-- certificazioni
-- tipologia: tabella assistita
ALTER TABLE `certificazioni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT; 

-- | 030000004800

-- chiavi
-- tipologia: tabella di supporto
-- verifica: 2021-11-15 11:58 Chiara GDL
ALTER TABLE `chiavi`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_licenza`,`codice`),
	ADD UNIQUE KEY `codice` (`codice`),
	ADD KEY `seriale` (`seriale`),
	ADD KEY `id_licenza` (`id_licenza`),
	ADD KEY `id_tipologia` (`id_tipologia`),
	ADD KEY `indice` (`id`,`codice`, `seriale`,`nome`,`id_licenza`, `id_tipologia`);

-- | 030000004801

-- chiavi
-- tipologia: tabella di supporto
ALTER TABLE `chiavi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000005000

-- classi_energetiche
-- tipologia: tabella standard
-- verifica: 2022-04-28 22:22 Chiara GDL
ALTER TABLE `classi_energetiche`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `nome` (`nome`);

-- | 030000005001

-- classi_energetiche
-- tipologia: tabella standard
ALTER TABLE `classi_energetiche` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000005050

-- colli
-- tipologia: tabella standard
-- verifica: 2022-05-04 22:22 Chiara GDL
ALTER TABLE `colli`
 	ADD PRIMARY KEY (`id`), 
 	ADD KEY `id_documento` (`id_documento`), 
	ADD KEY `id_udm_dimensioni` (`id_udm_dimensioni`),
	ADD KEY `id_udm_peso` (`id_udm_peso`),
	ADD KEY `id_udm_volume` (`id_udm_volume`),
 	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
 	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`ordine`,`codice`,`id_documento`),
	ADD KEY `indice_dimensioni` (`id`,`ordine`,`codice`,`id_documento`,`larghezza`,`lunghezza`,`altezza`,`peso`,`volume`);


-- | 030000005051

-- colli
-- tipologia: tabella standard
ALTER TABLE `colli` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000005100

-- colori
-- tipologia: tabella di supporto
-- verifica: 2021-06-02 22:27 Fabio Mosti
ALTER TABLE `colori`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica_hex` (`nome`,`hex`),
	ADD UNIQUE KEY `unica_rgb` (`nome`,`r`,`g`,`b`),
	ADD UNIQUE KEY `unica_ral` (`nome`,`ral`),
	ADD UNIQUE KEY `unica_pantone` (`nome`,`pantone`),
	ADD UNIQUE KEY `unica_cmyk` (`nome`,`c`,`m`,`y`,`k`),
	ADD UNIQUE KEY `unica` (`nome`, `id_genitore`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `indice` (`id`, `nome`,`id_genitore`,`hex`,`r`,`g`,`b`),
	ADD KEY `indice_ral` (`id`, `nome`,`id_genitore`,`ral`),
	ADD KEY `indice_pantone` (`id`, `nome`,`id_genitore`,`pantone`),
	ADD KEY `indice_cmyk` (`id`, `nome`,`id_genitore`,`c`,`m`,`y`,`k`);

-- | 030000005101

-- colori
-- tipologia: tabella di supporto
ALTER TABLE `colori` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000005300

-- comuni
-- tipologia: tabella di supporto
-- verifica: 2021-06-03 19:58 Fabio Mosti
ALTER TABLE `comuni`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica_istat` (`codice_istat`),
	ADD UNIQUE KEY `unica_catasto` (`codice_catasto`),
	ADD KEY `id_provincia` (`id_provincia`),
	ADD KEY `indice` (`id`,`id_provincia`, `nome`,`codice_istat`,`codice_catasto`);

-- | 030000005301

-- comuni
-- tipologia: tabella di supporto
ALTER TABLE `comuni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000006000

-- condizioni
-- tipologia: tabella standard
-- verifica: 2022-04-28 16:12 Chiara GDL
ALTER TABLE `condizioni`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unico` (`nome`),
	ADD KEY `nome` (`nome`),
	ADD KEY `se_catalogo` (`se_catalogo`),
	ADD KEY `se_immobili` (`se_immobili`);
	

-- | 030000006001

-- condizioni
-- tipologia: tabella standard
ALTER TABLE `condizioni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000006200

-- condizioni_pagamento
-- tipologia: tabella standard
-- verifica: 2022-01-17 16:12 Chiara GDL
ALTER TABLE `condizioni_pagamento`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unico` (`codice`,`nome`),
	ADD KEY `codice` (`codice`),
	ADD KEY `nome` (`nome`);

-- | 030000006201

-- condizioni_pagamento
-- tipologia: tabella standard
ALTER TABLE `condizioni_pagamento` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000006400

-- consensi
-- tipologia: tabella gestita
-- verifica: 2022-08-23 11:12 Chiara GDL
ALTER TABLE `consensi`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `nome` (`nome`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`nome`,`id_account_inserimento`,`id_account_aggiornamento`);

-- | 030000006500

-- consensi_moduli
-- tipologia: tabella assistita
-- verifica: 2022-08-23 11:12 Chiara GDL
ALTER TABLE `consensi_moduli`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_consenso`, `id_lingua`, `modulo`), 
	ADD KEY `id_lingua` (`id_lingua`),
	ADD KEY `id_consenso` (`id_consenso`),
	ADD KEY `modulo` (`modulo`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `azione` (`azione`),
	ADD KEY `nome` (`nome`),
	ADD KEY `informativa` (`informativa`),
	ADD KEY `pagina` (`pagina`),
	ADD KEY `se_richiesto` (`se_richiesto`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`, `id_consenso`, `id_lingua`, `modulo`,`nome`,`ordine`,`azione`, `informativa`, `pagina`, `se_richiesto` );

-- | 030000006501

-- consensi_moduli
-- tipologia: tabella assistita
ALTER TABLE `consensi_moduli` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000006700

-- contatti
-- tipologia: tabella gestita
-- verifica: 2021-06-03 21:52 Fabio Mosti
ALTER TABLE `contatti`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_tipologia` (`id_tipologia`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_inviante` (`id_inviante`),
	ADD KEY `id_ranking` (`id_ranking`),	
	ADD KEY `utm_id` ( `utm_id` ),
	ADD KEY `utm_source` ( `utm_source` ),
	ADD KEY `utm_medium` ( `utm_medium` ),
	ADD KEY `utm_campaign` ( `utm_campaign` ),
	ADD KEY `utm_term` ( `utm_term` ),
	ADD KEY `utm_content` ( `utm_content` ),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `timestamp_contatto` (`timestamp_contatto`), 
	ADD KEY `indice` (`id`, `id_tipologia`, `id_anagrafica`,`id_inviante`,`id_ranking`,`nome`,`timestamp_contatto`);

-- | 030000006701

-- contatti
-- tipologia: tabella gestita
ALTER TABLE `contatti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000006900

-- contenuti
-- tipologia: tabella gestita
-- verifica: 2021-06-07 17:36 Fabio Mosti
ALTER TABLE `contenuti`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica_anagrafica` (`id_lingua`,`id_anagrafica`), 
	ADD UNIQUE KEY `unica_prodotto` (`id_lingua`,`id_prodotto`), 
	ADD UNIQUE KEY `unica_articolo` (`id_lingua`,`id_articolo`), 
	ADD UNIQUE KEY `unica_categoria_prodotti` (`id_lingua`,`id_categoria_prodotti`), 
	ADD UNIQUE KEY `unica_caratteristica` (`id_lingua`,`id_caratteristica`), 
	ADD UNIQUE KEY `unica_marchio` (`id_lingua`,`id_marchio`), 
	ADD UNIQUE KEY `unica_file` (`id_lingua`,`id_file`), 
	ADD UNIQUE KEY `unica_immagine` (`id_lingua`,`id_immagine`), 
	ADD UNIQUE KEY `unica_video` (`id_lingua`,`id_video`), 
	ADD UNIQUE KEY `unica_audio` (`id_lingua`,`id_audio`), 
	ADD UNIQUE KEY `unica_risorsa` (`id_lingua`,`id_risorsa`), 
	ADD UNIQUE KEY `unica_categoria_risorse` (`id_lingua`,`id_categoria_risorse`), 
	ADD UNIQUE KEY `unica_pagina` (`id_lingua`,`id_pagina`), 
	ADD UNIQUE KEY `unica_popup` (`id_lingua`,`id_popup`), 
	ADD UNIQUE KEY `unica_indirizzo` (`id_lingua`,`id_indirizzo`), 
	ADD UNIQUE KEY `unica_notizia` (`id_lingua`,`id_notizia`), 
	ADD UNIQUE KEY `unica_categoria_notizie` (`id_lingua`,`id_categoria_notizie`), 
	ADD UNIQUE KEY `unica_template` (`id_lingua`,`id_template`), 
	ADD UNIQUE KEY `unica_colore` (`id_lingua`,`id_colore`),
	ADD UNIQUE KEY `unica_banner` (`id_lingua`,`id_banner`), 
	ADD KEY `id_lingua` (`id_lingua`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_prodotto` (`id_prodotto`), 
	ADD KEY `id_articolo` (`id_articolo`), 
	ADD KEY `id_categoria_prodotti` (`id_categoria_prodotti`), 
	ADD KEY `id_caratteristica` (`id_caratteristica`), 
	ADD KEY `id_marchio` (`id_marchio`), 
	ADD KEY `id_file` (`id_file`), 
	ADD KEY `id_immagine` (`id_immagine`), 
	ADD KEY `id_video` (`id_video`), 
	ADD KEY `id_audio` (`id_audio`), 
	ADD KEY `id_risorsa` (`id_risorsa`),
	ADD KEY `id_categoria_risorse` (`id_categoria_risorse`),
	ADD KEY `id_pagina` (`id_pagina`), 
	ADD KEY `id_popup` (`id_popup`), 
	ADD KEY `id_indirizzo` (`id_indirizzo`), 
	ADD KEY `id_edificio` (`id_edificio`), 
	ADD KEY `id_immobile` (`id_immobile`), 	
	ADD KEY `id_notizia` (`id_notizia`), 
	ADD KEY `id_annuncio` (`id_annuncio`),
	ADD KEY `id_categoria_notizie` (`id_categoria_notizie`),
	ADD KEY `id_template` (`id_template`), 
	ADD KEY `id_mailing` (`id_mailing`),
	ADD KEY `id_colore` (`id_colore`), 
	ADD KEY `id_progetto` (`id_progetto`),
	ADD KEY `id_categoria_progetti` (`id_categoria_progetti`),
	ADD KEY `id_banner` (`id_banner`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_lingua`),
	ADD KEY `indice_anagrafica` (`id`,`id_lingua`,`id_anagrafica`),
	ADD KEY `indice_prodotti` (`id`,`id_lingua`,`id_prodotto`,`id_articolo`,`id_categoria_prodotti`,`id_marchio`),
	ADD KEY `indice_immagini` (`id`,`id_lingua`,`id_immagine`),
	ADD KEY `indice_file` (`id`,`id_lingua`,`id_file`),
	ADD KEY `indice_risorse` (`id`,`id_lingua`,`id_risorsa`,`id_categoria_risorse`),
	ADD KEY `indice_pagine` (`id`,`id_lingua`,`id_pagina`,`id_popup`),
	ADD KEY `indice_notizie` (`id`,`id_lingua`,`id_notizia`,`id_categoria_notizie`),
	ADD KEY `indice_video` (`id`,`id_lingua`,`id_video`),
	ADD KEY `indice_audio` (`id`,`id_lingua`,`id_audio`),
	ADD KEY `indice_template` (`id`,`id_lingua`,`id_template`),
	ADD KEY `indice_colore` (`id`,`id_lingua`,`id_colore`);

-- | 030000006901

-- contenuti
-- tipologia: tabella gestita
ALTER TABLE `contenuti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000007100

-- continenti
-- tipologia: tabella standard
-- verifica: 2021-06-09 11:27 Fabio Mosti
ALTER TABLE `continenti`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`nome`),
	ADD KEY `indice` (`id`,`codice`,`nome`);

-- | 030000007101

-- continenti
-- tipologia: tabella di supporto
ALTER TABLE `continenti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000007200

-- contratti
-- tipologia: tabella gestita
-- verifica: 2022-02-21 11:50 Chiara GDL
ALTER TABLE `contratti`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `codice` ( `codice` ),
	ADD KEY `id_tipologia` (`id_tipologia`),
	ADD KEY `id_progetto` (`id_progetto`),
	ADD KEY `id_categoria_progetti` (`id_progetto`),
	ADD KEY `id_badge` (`id_badge`),
	ADD KEY `id_immobile` (`id_immobile`),
	ADD KEY `codice_affiliazione` ( `codice_affiliazione` ),
	ADD KEY `indice` ( `id_tipologia`, `codice`, `codice_affiliazione`, `nome`, `id_progetto`, `id_immobile`);

-- | 030000007201

-- contratti
-- tipologia: tabella gestita
ALTER TABLE `contratti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000007300

-- contratti_anagrafica
-- tipologia: tabella gestita
-- verifica: 2022-02-21 11:50 Chiara GDL
ALTER TABLE `contratti_anagrafica`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_contratto`,`id_anagrafica`,`id_ruolo`), 
	ADD KEY `id_contratto` (`id_contratto`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_ruolo` (`id_ruolo`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_contratto`,`id_anagrafica`,`id_ruolo`,`ordine`);

-- | 030000007301

-- contratti_anagrafica
-- tipologia: tabella gestita
ALTER TABLE `contratti_anagrafica` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000007400

-- contratti_progetti
ALTER TABLE `contratti_progetti`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_contratto`, `id_progetto`, `id_ruolo`),
	ADD KEY `id_contratto` (`id_contratto`),
	ADD KEY `id_progetto` (`id_progetto`),
	ADD KEY `id_ruolo` (`id_ruolo`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `id_account_archiviazione` (`id_account_archiviazione`),
	ADD KEY `indice` (`id`, `id_contratto`, `id_progetto`, `id_ruolo`, `ordine`);

-- | 030000007401

-- contratti_progetti
ALTER TABLE `contratti_progetti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000007500

-- conversazioni
-- tipologia: tabella gestita
-- verifica: 2022-08-31 11:50 Chiara GDL
ALTER TABLE `conversazioni`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_annuncio` (`id_annuncio`),
	ADD KEY `nome` (`nome`),
	ADD KEY `id_articolo` (`id_articolo`),
	ADD KEY `timestamp_apertura` (`timestamp_apertura`),
	ADD KEY `timestamp_chiusura` (`timestamp_chiusura`),
	ADD KEY `indice` (`id`,`nome`,`timestamp_chiusura`,`timestamp_apertura`);

-- | 030000007501

-- conversazioni
-- tipologia: tabella gestita
ALTER TABLE `conversazioni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000007600

-- conversazioni_account
-- tipologia: tabella gestita
-- verifica: 2022-08-31 11:50 Chiara GDL
ALTER TABLE `conversazioni_account`
 	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_conversazione`,`id_account`),
	ADD KEY `id_conversazione` (`id_conversazione`),
	ADD KEY `id_account` (`id_account`),
 	ADD KEY `timestamp_lettura` (`timestamp_lettura`), 
	ADD KEY `timestamp_entrata` (`timestamp_entrata`), 
 	ADD KEY `timestamp_uscita` (`timestamp_uscita`), 
	ADD KEY `indice` (`id`,`id_conversazione`,`id_account`,`timestamp_lettura`,`timestamp_entrata`, `timestamp_uscita`);
	
-- | 030000007601

-- conversazioni_account
-- tipologia: tabella gestita
ALTER TABLE `conversazioni_account` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000007800

-- corrispondenza
ALTER TABLE `corrispondenza`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_tipologia`,`id_peso`,`id_formato`,`id_mittente`,`id_organizzazione_mittente`,`id_commesso`),
	ADD KEY `id_tipologia` (`id_tipologia`),
	ADD KEY `id_peso` (`id_peso`),
	ADD KEY `id_formato` (`id_formato`),
	ADD KEY `id_mittente` (`id_mittente`),
	ADD KEY `id_organizzazione_mittente` (`id_organizzazione_mittente`),
	ADD KEY `id_commesso` (`id_commesso`),
	ADD KEY `nome` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);

-- | 030000007801

-- corrispondenza
ALTER TABLE `corrispondenza` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000008000

-- coupon
-- tipologia: tabella gestita
-- verifica: 2021-06-29 15:50 Fabio Mosti
ALTER TABLE `coupon`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`nome`,`timestamp_inizio`,`timestamp_fine`,`sconto_percentuale`,`sconto_fisso`,`se_multiuso`,`se_globale`);

-- | 030000008200

-- coupon_categorie_prodotti
-- tipologia: tabella gestita
-- verifica: 2021-06-29 16:06 Fabio Mosti
ALTER TABLE `coupon_categorie_prodotti`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_coupon`,`id_categoria`),
	ADD KEY `id_coupon` (`id_coupon`), 
	ADD KEY `id_categoria` (`id_categoria`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_coupon`,`id_categoria`,`ordine`);

-- | 030000008201
 
-- coupon_categorie_prodotti
-- tipologia: tabella gestita
ALTER TABLE `coupon_categorie_prodotti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000008400
 
-- coupon_listini
-- tipologia: tabella gestita
-- verifica: 2021-06-29 16:47 Fabio Mosti
ALTER TABLE `coupon_listini`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_coupon`,`id_listino`),
	ADD KEY `id_coupon` (`id_coupon`), 
	ADD KEY `id_listino` (`id_listino`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_coupon`,`id_listino`,`ordine`);

-- | 030000008401

-- coupon_listini
-- tipologia: tabella gestita
ALTER TABLE `coupon_listini` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000008600

-- coupon_marchi
-- tipologia: tabella gestita
-- verifica: 2021-06-29 16:47 Fabio Mosti
ALTER TABLE `coupon_marchi`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_coupon`,`id_marchio`),
	ADD KEY `id_coupon` (`id_coupon`), 
	ADD KEY `id_marchio` (`id_marchio`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_coupon`,`id_marchio`,`ordine`);

-- | 030000008601

-- coupon_marchi
-- tipologia: tabella gestita
ALTER TABLE `coupon_marchi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000008800

-- coupon_prodotti
-- tipologia: tabella gestita
-- verifica: 2021-06-29 16:57 Fabio Mosti
ALTER TABLE `coupon_prodotti`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_coupon`,`id_prodotto`),
	ADD KEY `id_coupon` (`id_coupon`), 
	ADD KEY `id_prodotto` (`id_prodotto`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_coupon`,`id_prodotto`,`ordine`);

-- | 030000008801

-- coupon_prodotti
-- tipologia: tabella gestita
ALTER TABLE `coupon_prodotti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000008900

-- crediti
-- tipologia: tabella gestita
-- verifica: 2022-07-15 11:56 Chiara GDL
ALTER TABLE `crediti`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_documenti_articolo`,`data`,`id_account_emittente`,`id_account_destinatario`, `quantita`),
	ADD KEY `id_documenti_articolo` (`id_documenti_articolo`), 
	ADD KEY `id_account_emittente` (`id_account_emittente`), 
	ADD KEY `id_account_destinatario` (`id_account_destinatario`), 
	ADD KEY `id_mastro_provenienza` (`id_mastro_provenienza`), 
	ADD KEY `id_mastro_destinazione` (`id_mastro_destinazione`), 
    ADD KEY `id_pianificazione` (`id_pianificazione`),
	ADD KEY `data` (`data`), 
	ADD KEY `quantita` (`quantita`), 
	ADD KEY `nome` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`id_documenti_articolo`,`data`,`id_account_emittente`,`id_account_destinatario`,`id_mastro_provenienza`,`id_mastro_destinazione`,`id_pianificazione`,  `quantita`,  `nome`);

-- | 030000008901

-- crediti
-- tipologia: tabella gestita
ALTER TABLE `crediti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000009000

-- disponibilita
-- tipologia: tabella standard
-- verifica: 2022-04-28 16:12 Chiara GDL
ALTER TABLE `disponibilita`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unico` (`nome`),
	ADD KEY `nome` (`nome`),
	ADD KEY `se_catalogo` (`se_catalogo`),
	ADD KEY `se_immobili` (`se_immobili`);
	
-- | 030000009001

-- disponibilita
-- tipologia: tabella standard
ALTER TABLE `disponibilita` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000009800

-- documenti
-- tipologia: tabella gestita
-- verifica: 2021-09-03 17:09 Fabio Mosti
ALTER TABLE `documenti`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_tipologia`,`numero`,`sezionale`),
	ADD UNIQUE KEY `codice` (`codice`),
	ADD UNIQUE KEY `unica_codice_archivium` (`codice_archivium`),
	ADD UNIQUE KEY `unica_codice_sdi` (`codice_sdi`),
	ADD KEY `id_tipologia` (`id_tipologia`), 
	ADD KEY `id_emittente` (`id_emittente`), 
	ADD KEY `id_sede_emittente` (`id_sede_emittente`), 
	ADD KEY `id_destinatario` (`id_destinatario`), 
	ADD KEY `id_sede_destinatario` (`id_sede_destinatario`), 
	ADD KEY `id_condizione_pagamento` (`id_condizione_pagamento`),
	ADD KEY `id_coupon` (`id_coupon`),
	ADD KEY `id_mastro_provenienza` (`id_mastro_provenienza`), 
	ADD KEY `id_mastro_destinazione` (`id_mastro_destinazione`), 
	ADD KEY `id_immobile` (`id_immobile`),
	ADD KEY `cig` (`cig`),
	ADD KEY `cup` (`cup`),
	ADD KEY `id_causale` (`id_causale`),
	ADD KEY `id_trasportatore` (`id_trasportatore`),
	ADD KEY `porto` (`porto`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_tipologia`,`numero`,`sezionale`,`data`,`id_emittente`,`id_sede_emittente`,`id_destinatario`,`id_sede_destinatario`,`id_coupon`);

-- | 030000009801

-- documenti
-- tipologia: tabella gestita
ALTER TABLE `documenti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000010000

-- documenti_articoli
-- tipologia: tabella gestita
-- verifica: 2021-09-10 11:57 Fabio Mosti
ALTER TABLE `documenti_articoli`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `codice` (`codice`),
	ADD UNIQUE KEY `unico_codice` (`codice`,`id_tipologia`),
	ADD KEY `id_genitore` (`id_genitore`), 
	ADD KEY `id_tipologia` (`id_tipologia`), 
	ADD KEY `id_documento` (`id_documento`), 
	ADD KEY `id_emittente` (`id_emittente`), 
	ADD KEY `id_destinatario` (`id_destinatario`), 
	ADD KEY `id_reparto` (`id_reparto`),
	ADD KEY `id_progetto` (`id_progetto`), 
	ADD KEY `id_todo` (`id_todo`), 
	ADD KEY `id_attivita` (`id_attivita`), 
	ADD KEY `id_articolo` (`id_articolo`), 
	ADD KEY `id_prodotto` (`id_prodotto`), 
	ADD KEY `id_mastro_provenienza` (`id_mastro_provenienza`), 
	ADD KEY `id_mastro_destinazione` (`id_mastro_destinazione`), 
	ADD KEY `id_udm` (`id_udm`), 
	ADD KEY `id_listino` (`id_listino`), 
	ADD KEY `id_matricola` (`id_matricola`), 
	ADD KEY `id_rinnovo` (`id_rinnovo`), 
	ADD KEY `id_collo` (`id_collo`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `data` (`data`), 
	ADD KEY `quantita` (`quantita`), 
	ADD KEY `costo_netto_totale` (`costo_netto_totale`),
	ADD KEY `importo_netto_totale` (`importo_netto_totale`),
	ADD KEY `importo_lordo_totale` (`importo_lordo_totale`),
	ADD KEY `indice` (`id`,`id_genitore`,`id_tipologia`,`ordine`,`id_documento`,`data`,`id_emittente`,`id_destinatario`,`id_reparto`,`id_progetto`,`id_todo`,`id_attivita`,`id_articolo`,`id_mastro_provenienza`,`id_mastro_destinazione`),
	ADD KEY `indice_progetto_quantita` (`id`,`id_genitore`,`id_tipologia`,`ordine`,`id_documento`,`data`,`id_emittente`,`id_destinatario`,`id_reparto`,`id_progetto`,`id_articolo`,`id_mastro_provenienza`,`id_mastro_destinazione`,`id_udm`,`quantita`),
	ADD KEY `indice_progetto_valore` (`id`,`id_genitore`,`id_tipologia`,`ordine`,`id_documento`,`data`,`id_emittente`,`id_destinatario`,`id_reparto`,`id_progetto`,`id_articolo`,`id_mastro_provenienza`,`id_mastro_destinazione`,`id_listino`,`importo_netto_totale`,`id_matricola`),
	ADD KEY `indice_todo_quantita` (`id`,`id_genitore`,`id_tipologia`,`ordine`,`id_documento`,`data`,`id_emittente`,`id_destinatario`,`id_reparto`,`id_todo`,`id_articolo`,`id_mastro_provenienza`,`id_mastro_destinazione`,`id_udm`,`quantita`),
	ADD KEY `indice_todo_valore` (`id`,`id_genitore`,`id_tipologia`,`ordine`,`id_documento`,`data`,`id_emittente`,`id_destinatario`,`id_reparto`,`id_todo`,`id_articolo`,`id_mastro_provenienza`,`id_mastro_destinazione`,`id_listino`,`importo_netto_totale`,`id_matricola`),
	ADD KEY `indice_attivita_quantita` (`id`,`id_genitore`,`id_tipologia`,`ordine`,`id_documento`,`data`,`id_emittente`,`id_destinatario`,`id_reparto`,`id_attivita`,`id_articolo`,`id_mastro_provenienza`,`id_mastro_destinazione`,`id_udm`,`quantita`),
	ADD KEY `indice_attivita_valore` (`id`,`id_genitore`,`id_tipologia`,`ordine`,`id_documento`,`data`,`id_emittente`,`id_destinatario`,`id_reparto`,`id_attivita`,`id_articolo`,`id_mastro_provenienza`,`id_mastro_destinazione`,`id_listino`,`importo_netto_totale`,`id_matricola`);

-- | 030000010001

-- documenti_articoli
-- tipologia: tabella gestita
ALTER TABLE `documenti_articoli` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000012000

-- edifici
-- tipologia: tabella gestita
-- verifica: 2022-04-27 16:56 Chiara GDL
ALTER TABLE `edifici`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `codice` (`codice`),
	ADD KEY `id_tipologia` (`id_tipologia`),
	ADD KEY `id_indirizzo` (`id_indirizzo`),
	ADD KEY `nome` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`, `id_tipologia`, `id_indirizzo`, `nome`, `codice`);

-- | 030000012001

-- edifici
-- tipologia: tabella gestita
ALTER TABLE `edifici`  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000012050

-- edifici_caratteristiche
-- tipologia: tabella gestita
-- verifica: 2022-04-27 16:56 Chiara GDL
ALTER TABLE `edifici_caratteristiche`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_edificio`,`id_caratteristica`), 
	ADD KEY `id_edificio` (`id_edificio`),
	ADD KEY `id_caratteristica` (`id_caratteristica`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `se_presente` (`se_presente`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_edificio`,`id_caratteristica`,`ordine`);

-- | 030000012051

-- edifici_caratteristiche
-- tipologia: tabella gestita
ALTER TABLE `edifici_caratteristiche` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000012800

-- embed
-- tipologia: tabella standard
-- verifica: 2021-09-10 11:57 Fabio Mosti
ALTER TABLE `embed`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `nome` (`nome`), 
	ADD KEY `indice` (`id`,`nome`,`se_audio`,`se_video`);

-- | 030000012801

-- embed
-- tipologia: tabella standard
ALTER TABLE `embed` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000015000

-- file
-- tipologia: tabella gestita
-- verifica: 2021-09-10 16:22 Fabio Mosti
ALTER TABLE `file`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica_anagrafica` (`id_anagrafica`,`id_ruolo`,`path`), 
	ADD UNIQUE KEY `unica_prodotto` (`id_prodotto`,`id_ruolo`,`path`), 
	ADD UNIQUE KEY `unica_articolo` (`id_articolo`,`id_ruolo`,`path`), 
	ADD UNIQUE KEY `unica_categoria_prodotti` (`id_categoria_prodotti`,`id_ruolo`,`path`), 
	ADD UNIQUE KEY `unica_todo` (`id_todo`,`id_ruolo`,`path`), 
	ADD UNIQUE KEY `unica_pagina` (`id_pagina`,`id_ruolo`,`path`), 
	ADD UNIQUE KEY `unica_template` (`id_template`,`id_ruolo`,`path`), 
	ADD UNIQUE KEY `unica_notizia` (`id_notizia`,`id_ruolo`,`path`), 
	ADD UNIQUE KEY `unica_categoria_notizie` (`id_categoria_notizie`,`id_ruolo`,`path`), 
	ADD UNIQUE KEY `unica_risorsa` (`id_risorsa`,`id_ruolo`,`path`), 
	ADD UNIQUE KEY `unica_categoria_risorse` (`id_categoria_risorse`,`id_ruolo`,`path`), 
	ADD UNIQUE KEY `unica_mailing` (`id_mailing`,`id_ruolo`,`path`), 
	ADD UNIQUE KEY `unica_mail_out` (`id_mail_out`,`id_ruolo`,`path`), 	
	ADD UNIQUE KEY `unica_mail_sent` (`id_mail_sent`,`id_ruolo`,`path`), 	
	ADD UNIQUE KEY `unica_progetto` (`id_progetto`,`id_ruolo`,`path`),
	ADD UNIQUE KEY `unica_categoria_progetti` (`id_categoria_progetti`,`id_ruolo`,`path`), 	
	ADD UNIQUE KEY `unica_documento` (`id_documento`,`id_ruolo`,`path`), 	
	ADD UNIQUE KEY `unica_indirizzo` (`id_indirizzo`,`id_ruolo`,`path`), 	
	ADD UNIQUE KEY `unica_edificio` (`id_edificio`,`id_ruolo`,`path`), 	
	ADD UNIQUE KEY `unica_immobile` (`id_immobile`,`id_ruolo`,`path`), 	
	ADD UNIQUE KEY `unica_contratto` (`id_contratto`,`id_ruolo`,`path`), 	
	ADD UNIQUE KEY `unica_valutazione` (`id_valutazione`,`id_ruolo`,`path`), 	
	ADD UNIQUE KEY `unica_rinnovo` (`id_rinnovo`,`id_ruolo`,`path`), 	
	ADD UNIQUE KEY `unica_anagrafica_certificazioni` (`id_anagrafica_certificazioni`,`id_ruolo`,`path`), 	
	ADD UNIQUE KEY `unica_valutazione_certificazioni` (`id_valutazione_certificazioni`,`id_ruolo`,`path`), 
	ADD UNIQUE KEY `unica_licenza` (`id_licenza`,`id_ruolo`,`path`),
	ADD KEY `id_ruolo` (`id_ruolo`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_prodotto` (`id_prodotto`), 
	ADD KEY `id_articolo` (`id_articolo`), 
	ADD KEY `id_categoria_prodotti` (`id_categoria_prodotti`), 
	ADD KEY `id_todo` (`id_todo`), 
	ADD KEY `id_pagina` (`id_pagina`), 
	ADD KEY `id_template` (`id_template`), 
	ADD KEY `id_mailing` (`id_mailing`),
	ADD KEY `id_notizia` (`id_notizia`),
	ADD KEY `id_categoria_notizie` (`id_categoria_notizie`), 
	ADD KEY `id_annuncio` (`id_annuncio`),
	ADD KEY `id_categoria_annunci` (`id_categoria_annunci`), 
	ADD KEY `id_risorsa` (`id_risorsa`),
	ADD KEY `id_categoria_risorse` (`id_categoria_risorse`), 
	ADD KEY `id_lingua` (`id_lingua`), 
	ADD KEY `id_mail_out` (`id_mail_out`), 
	ADD KEY `id_mail_sent` (`id_mail_sent`), 
	ADD KEY `id_progetto` (`id_progetto`),
	ADD KEY `id_categoria_progetti` (`id_categoria_progetti`),
	ADD KEY `id_documento` (`id_documento`),
	ADD KEY `id_indirizzo` (`id_indirizzo`), 
	ADD KEY `id_edificio` (`id_edificio`), 
	ADD KEY `id_immobile` (`id_immobile`),
	ADD KEY `id_contratto` (`id_contratto`), 
	ADD KEY `id_valutazione` (`id_valutazione`), 
	ADD KEY `id_rinnovo` (`id_rinnovo`),
	ADD KEY `id_anagrafica_certificazioni` (`id_anagrafica_certificazioni`),
	ADD KEY `id_valutazione_certificazioni` (`id_valutazione_certificazioni`),
	ADD KEY `id_licenza` (`id_licenza`),
	ADD KEY `id_attivita` (`id_attivita`),
	ADD KEY `path` (`path`), 
	ADD KEY `url` (`url`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`id_ruolo`,`id_lingua`,`path`,`url`);

-- | 030000015001

-- file
-- tipologia: tabella gestita
ALTER TABLE `file` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000015050

-- formati_tipologie_corrispondenza
ALTER TABLE `formati_tipologie_corrispondenza`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_tipologia` (`id_tipologia`),
  	ADD KEY `id_tipologia_2` (`id_tipologia`);

-- | 030000015051

-- formati_tipologie_corrispondenza
ALTER TABLE `formati_tipologie_corrispondenza` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000015100

-- funnel
ALTER TABLE `funnel`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`nome`), 
	ADD KEY `nome` (`nome`), 
	ADD KEY `indice` (`id`,`nome`);

-- | 030000015101

-- funnel
-- tipologia: tabella gestita
ALTER TABLE `funnel` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000015150

-- giorni
ALTER TABLE `giorni` 
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`nome`), 
	ADD KEY `nome` (`nome`), 
	ADD KEY `indice` (`id`,`nome`);

-- | 030000015151

-- giorni
ALTER TABLE `giorni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000015200

-- gruppi
-- tipologia: tabella gestita
-- verifica: 2021-09-10 18:21 Fabio Mosti
ALTER TABLE `gruppi`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `nome` (`nome`),
	ADD KEY `id_genitore` (`id_genitore`), 
	ADD KEY `id_organizzazione` (`id_organizzazione`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`id_genitore`,`id_organizzazione`,`nome`);

-- | 030000015201

-- gruppi
-- tipologia: tabella gestita
ALTER TABLE `gruppi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000015400

-- iban
-- tipologia: tabella gestita
-- verifica: 2021-09-22 11:55 Fabio Mosti
ALTER TABLE `iban`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`id_anagrafica`,`iban`);

-- | 030000015401

-- iban
-- tipologia: tabella gestita
ALTER TABLE `iban` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000015600

-- immagini
-- tipologia: tabella gestita
-- verifica: 2021-09-22 12:21 Fabio Mosti
ALTER TABLE `immagini`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica_anagrafica` (`id_anagrafica`,`id_ruolo`,`id_lingua`,`path`), 
	ADD UNIQUE KEY `unica_pagina` (`id_pagina`,`id_ruolo`,`id_lingua`,`path`), 
	ADD UNIQUE KEY `unica_file` (`id_file`,`id_ruolo`,`id_lingua`,`path`), 
	ADD UNIQUE KEY `unica_prodotto` (`id_prodotto`,`id_ruolo`,`id_lingua`,`path`), 
	ADD UNIQUE KEY `unica_articolo` (`id_articolo`,`id_ruolo`,`id_lingua`,`path`), 
	ADD UNIQUE KEY `unica_categoria_prodotti` (`id_categoria_prodotti`,`id_ruolo`,`id_lingua`,`path`), 
	ADD UNIQUE KEY `unica_risorse` (`id_risorsa`,`id_ruolo`,`id_lingua`,`path`), 
	ADD UNIQUE KEY `unica_categoria_risorse` (`id_categoria_risorse`,`id_ruolo`,`id_lingua`,`path`), 
	ADD UNIQUE KEY `unica_notizie` (`id_notizia`,`id_ruolo`,`id_lingua`,`path`), 
	ADD UNIQUE KEY `unica_categoria_notizie` (`id_categoria_notizie`,`id_ruolo`,`id_lingua`,`path`), 
	ADD UNIQUE KEY `unica_indirizzi` (`id_indirizzo`,`id_ruolo`,`id_lingua`,`path`), 
	ADD UNIQUE KEY `unica_banner` (`id_banner`,`id_ruolo`,`id_lingua`,`path`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_pagina` (`id_pagina`), 
	ADD KEY `id_file` (`id_file`), 
	ADD KEY `id_prodotto` (`id_prodotto`), 
	ADD KEY `id_articolo` (`id_articolo`), 
	ADD KEY `id_categoria_prodotti` (`id_categoria_prodotti`), 
	ADD KEY `id_risorsa` (`id_risorsa`),
	ADD KEY `id_categoria_risorse` (`id_categoria_risorse`), 
	ADD KEY `id_notizia` (`id_notizia`), 
	ADD KEY `id_categoria_notizie` (`id_categoria_notizie`), 
	ADD KEY `id_annuncio` (`id_annuncio`),
	ADD KEY `id_categoria_annunci` (`id_categoria_annunci`), 
	ADD KEY `id_indirizzo` (`id_indirizzo`), 
	ADD KEY `id_edificio` (`id_edificio`), 
	ADD KEY `id_immobile` (`id_immobile`),
	ADD KEY `id_contratto` (`id_contratto`), 
	ADD KEY `id_valutazione` (`id_valutazione`), 
	ADD KEY `id_rinnovo` (`id_rinnovo`), 
	ADD KEY `id_lingua` (`id_lingua`), 
	ADD KEY `id_ruolo` (`id_ruolo`), 
	ADD KEY `id_progetto` (`id_progetto`),
	ADD KEY `id_categoria_progetti` (`id_categoria_progetti`),
	ADD KEY `id_banner` (`id_banner`), 
	ADD KEY `path` (`path`), 
	ADD KEY `path_alternativo` (`path_alternativo`), 
	ADD KEY `token` (`token`), 
	ADD KEY `timestamp_scalamento` (`timestamp_scalamento`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`id_lingua`,`id_ruolo`,`ordine`,`path`,`path_alternativo`,`token`,`timestamp_scalamento`),
	ADD KEY `indice_anagrafica` (`id`,`id_anagrafica`,`id_lingua`,`id_ruolo`,`ordine`,`path`,`path_alternativo`,`token`,`timestamp_scalamento`),
	ADD KEY `indice_pagine` (`id`,`id_pagina`,`id_lingua`,`id_ruolo`,`ordine`,`path`,`path_alternativo`,`token`,`timestamp_scalamento`),
	ADD KEY `indice_file` (`id`,`id_file`,`id_lingua`,`id_ruolo`,`ordine`,`path`,`path_alternativo`,`token`,`timestamp_scalamento`),
	ADD KEY `indice_prodotti` (`id`,`id_prodotto`,`id_lingua`,`id_ruolo`,`ordine`,`path`,`path_alternativo`,`token`,`timestamp_scalamento`),
	ADD KEY `indice_articoli` (`id`,`id_articolo`,`id_lingua`,`id_ruolo`,`ordine`,`path`,`path_alternativo`,`token`,`timestamp_scalamento`),
	ADD KEY `indice_categorie_prodotti` (`id`,`id_categoria_prodotti`,`id_lingua`,`id_ruolo`,`ordine`,`path`,`path_alternativo`,`token`,`timestamp_scalamento`),
	ADD KEY `indice_risorse` (`id`,`id_risorsa`,`id_lingua`,`id_ruolo`,`ordine`,`path`,`path_alternativo`,`token`,`timestamp_scalamento`),
	ADD KEY `indice_categorie_risorse` (`id`,`id_categoria_risorse`,`id_lingua`,`id_ruolo`,`ordine`,`path`,`path_alternativo`,`token`,`timestamp_scalamento`),
	ADD KEY `indice_notizie` (`id`,`id_notizia`,`id_lingua`,`id_ruolo`,`ordine`,`path`,`path_alternativo`,`token`,`timestamp_scalamento`),
	ADD KEY `indice_categorie_notizie` (`id`,`id_categoria_notizie`,`id_lingua`,`id_ruolo`,`ordine`,`path`,`path_alternativo`,`token`,`timestamp_scalamento`),
	ADD KEY `indice_indirizzi` (`id`,`id_indirizzo`,`id_lingua`,`id_ruolo`,`ordine`,`path`,`path_alternativo`,`token`,`timestamp_scalamento`);

-- | 030000015601

-- immagini
-- tipologia: tabella gestita
ALTER TABLE `immagini` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000015700

-- immobili
-- tipologia: tabella gestita
-- verifica: 2022-04-27 12:20 Chiara GDL
ALTER TABLE `immobili`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_tipologia`,`id_edificio`, `scala`,  `piano`, `interno`, `nome`),
	ADD UNIQUE KEY `codice` (`codice`),
	ADD KEY `id_tipologia` (`id_tipologia`),
	ADD KEY `id_edificio` (`id_edificio`),
	ADD KEY `nome` (`nome`),
	ADD KEY `scala` (`scala`),
	ADD KEY `piano` (`piano`),
	ADD KEY `interno` (`interno`),
	ADD KEY `catasto_foglio` (`catasto_foglio`),
	ADD KEY `catasto_particella` (`catasto_particella`),
	ADD KEY `catasto_sub` (`catasto_sub`),
	ADD KEY `catasto_categoria` (`catasto_categoria`),
	ADD KEY `catasto_classe` (`catasto_classe`),
	ADD KEY `catasto_consistenza` (`catasto_consistenza`),
	ADD KEY `catasto_superficie` (`catasto_superficie`),
	ADD KEY `catasto_rendita` (`catasto_rendita`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);

-- | 030000015701

-- immobili
-- tipologia: tabella gestita
ALTER TABLE `immobili`  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000015710

-- immobili_anagrafica
-- tipologia: tabella gestita
-- verifica: 2022-04-28 12:20 Chiara GDL
ALTER TABLE `immobili_anagrafica`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_immobile`,`id_anagrafica`,`id_ruolo`), 
	ADD KEY `id_immobile` (`id_immobile`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_ruolo` (`id_ruolo`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_immobile`,`id_anagrafica`,`id_ruolo`,`ordine`);

-- | 030000015711

-- immobili_anagrafica
-- tipologia: tabella gestita
ALTER TABLE `immobili_anagrafica` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000015750

-- immobili_caratteristiche
-- tipologia: tabella gestita
-- verifica: 2022-04-28 12:20 Chiara GDL
ALTER TABLE `immobili_caratteristiche`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_immobile`,`id_caratteristica`), 
	ADD KEY `id_immobile` (`id_immobile`),
	ADD KEY `id_caratteristica` (`id_caratteristica`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `se_presente` (`se_presente`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_immobile`,`id_caratteristica`,`ordine`);

-- | 030000015751

-- immobili_caratteristiche
-- tipologia: tabella gestita
ALTER TABLE `immobili_caratteristiche` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000015800

-- indirizzi
-- tipologia: tabella gestita
-- verifica: 2021-09-23 16:08 Fabio Mosti
ALTER TABLE `indirizzi`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_comune`,`indirizzo`,`civico`,`cap`),
	ADD KEY `id_tipologia` (`id_tipologia`), 
	ADD KEY `id_comune` (`id_comune`), 
	ADD KEY `timestamp_geolocalizzazione` (`timestamp_geolocalizzazione`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`id_comune`,`indirizzo`,`civico`,`cap`,`timestamp_geolocalizzazione`);

-- | 030000015801

-- indirizzi
-- tipologia: tabella gestita
ALTER TABLE `indirizzi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000015850

-- indirizzi_caratteristiche
-- tipologia: tabella gestita
-- verifica: 2022-05-03 15:21 Chiara GDL
ALTER TABLE `indirizzi_caratteristiche`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_indirizzo`,`id_caratteristica`), 
	ADD KEY `id_indirizzo` (`id_indirizzo`),
	ADD KEY `id_caratteristica` (`id_caratteristica`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `se_presente` (`se_presente`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_indirizzo`,`id_caratteristica`,`ordine`);

-- | 030000015851

-- indirizzi_caratteristiche
-- tipologia: tabella gestita
ALTER TABLE `indirizzi_caratteristiche` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000016000

-- iva
-- tipologia: tabella di supporto
-- verifica: 2021-09-23 16:53 Fabio Mosti
ALTER TABLE `iva`
	ADD PRIMARY KEY (`id`),
	ADD KEY `aliquota` (`aliquota`),
	ADD KEY `timestamp_archiviazione` (`timestamp_archiviazione`),
	ADD KEY `indice` (`id`,`aliquota`,`nome`,`codice`,`timestamp_archiviazione`);

-- | 030000016001

-- iva
-- tipologia: tabella di supporto
ALTER TABLE `iva` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000016200

-- job
-- tipologia: tabella gestita
-- verifica: 2021-09-24 16:24 Fabio Mosti
ALTER TABLE `job`
	ADD PRIMARY KEY (`id`),
	ADD KEY `token` (`token`),
	ADD KEY `timestamp_apertura` (`timestamp_apertura`),
	ADD KEY `timestamp_esecuzione` (`timestamp_esecuzione`),
	ADD KEY `timestamp_completamento` (`timestamp_completamento`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`nome`,`job`,`totale`,`corrente`,`iterazioni`,`delay`,`token`,`timestamp_apertura`,`timestamp_esecuzione`,`timestamp_completamento`);

-- | 030000016201

-- job
-- tipologia: tabella gestita
ALTER TABLE `job` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000016600

-- licenze
-- tipologia: tabella gestita
-- verifica: 2021-11-15 12:41 Fabio Mosti
ALTER TABLE `licenze`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `codice` (`codice`),
	ADD KEY `id_anagrafica` (`id_anagrafica`),
	ADD KEY `id_tipologia` (`id_tipologia`),
	ADD KEY `nome` (`nome`),
	ADD KEY `giorni_validita` (`giorni_validita`),
	ADD KEY `giorni_rinnovo` (`giorni_rinnovo`),
	ADD KEY `timestamp_distribuzione` (`timestamp_distribuzione`),
	ADD KEY `timestamp_inizio` (`timestamp_inizio`),
	ADD KEY `timestamp_fine` (`timestamp_fine`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id_anagrafica`,`id_tipologia`,`id_rivenditore`,`codice`,`postazioni`,`nome`,`giorni_validita`,`giorni_rinnovo`,`timestamp_distribuzione`,`timestamp_inizio`,`timestamp_fine`);

-- | 030000016601

-- licenze
-- tipologia: tabella standard
ALTER TABLE `licenze` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000016700

-- licenze_software
-- tipologia: tabella gestita
-- verifica: 2021-11-16 15:30 Chiara GDL
ALTER TABLE `licenze_software`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_licenza`,`id_software`),
	ADD KEY `id_licenza` (`id_licenza`), 
	ADD KEY `id_software` (`id_software`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_licenza`,`id_software`,`ordine`);

-- | 030000016701

-- licenze_software
-- tipologia: tabella gestita
ALTER TABLE `licenze_software` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000016800

-- lingue
-- tipologia: tabella di supporto
-- verifica: 2021-09-24 17:45 Fabio Mosti
ALTER TABLE `lingue`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica_nome` (`nome`),
	ADD UNIQUE KEY `unica_iso6391alpha2` (`iso6391alpha2`),
	ADD UNIQUE KEY `unica_iso6393alpha3` (`iso6393alpha3`),
	ADD UNIQUE KEY `unica_ietf` (`ietf`),
	ADD KEY `indice` (`id`,`nome`,`iso6391alpha2`,`iso6393alpha3`,`ietf`);

-- | 030000016801

-- lingue
-- tipologia: tabella di supporto
ALTER TABLE `lingue` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000017000

-- liste
-- tipolgia: tabella gestita
-- verifica: 2022-02-07 15:47 Chiara GDL
ALTER TABLE `liste`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`nome`);
	
-- | 030000017001

-- liste
-- tipolgia: tabella gestita
ALTER TABLE `liste` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000017100

-- liste_mail
-- tipolgia: tabella gestita
-- verifica: 2022-02-07 15:47 Chiara GDL
ALTER TABLE `liste_mail`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_lista`,`id_mail`),
	ADD KEY `id_lista` (`id_lista`),
	ADD KEY `id_mail` (`id_mail`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);
	
-- | 030000017101

-- liste_mail
-- tipolgia: tabella gestita
ALTER TABLE `liste_mail` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000017200

-- listini
-- tipologia: tabella assistita
-- verifica: 2021-09-24 17:53 Fabio Mosti
ALTER TABLE `listini`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_valuta`,`nome`),
	ADD KEY `id_valuta` (`id_valuta`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_valuta`,`nome`);

-- | 030000017201

-- listini
-- tipologia: tabella assistita
ALTER TABLE `listini` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000017400

-- listini_clienti
-- tipologia: tabella gestita
-- verifica: 2021-09-24 18:15 Fabio Mosti
ALTER TABLE `listini_clienti`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_listino`,`id_cliente`),
	ADD KEY `id_listino` (`id_listino`),
	ADD KEY `id_cliente` (`id_cliente`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_listino`,`id_cliente`,`ordine`);

-- | 030000017401

-- listini_clienti
-- tipologia: tabella gestita
ALTER TABLE `listini_clienti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000018000

-- luoghi
-- tipologia: tabella gestita
-- verifica: 2021-09-24 18:41 Fabio Mosti
ALTER TABLE `luoghi`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `id_indirizzo` (`id_indirizzo`),
	ADD KEY `id_tipologia` (`id_tipologia`),
	ADD KEY `id_edificio` (`id_edificio`), 
	ADD KEY `id_immobile` (`id_immobile`), 
	ADD KEY `url` (`url`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_genitore`,`id_indirizzo`,  `id_tipologia`,`id_edificio`, `id_immobile`,`nome`);

-- | 030000018001

-- luoghi
-- tipologia: tabella gestita
ALTER TABLE `luoghi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000018200

-- macro
-- tipologia: tabella gestita
-- verifica: 2021-09-24 19:32 Fabio Mosti
ALTER TABLE `macro`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica_pagina` (`id_pagina`,`macro`), 
	ADD UNIQUE KEY `unica_prodotto` (`id_prodotto`,`macro`), 
	ADD UNIQUE KEY `unica_articolo` (`id_articolo`,`macro`), 
	ADD UNIQUE KEY `unica_categoria_prodotti` (`id_categoria_prodotti`,`macro`), 
	ADD UNIQUE KEY `unica_notizia` (`id_notizia`,`macro`), 
	ADD UNIQUE KEY `unica_categoria_notizie` (`id_categoria_notizie`,`macro`), 
	ADD UNIQUE KEY `unica_risorsa` (`id_risorsa`,`macro`), 
	ADD UNIQUE KEY `unica_categoria_risorse` (`id_categoria_risorse`,`macro`), 
	ADD UNIQUE KEY `unica_progetto` (`id_progetto`,`macro`), 
	ADD UNIQUE KEY `unica_categoria_progetti` (`id_categoria_progetti`,`macro`), 
	ADD KEY `id_pagina` (`id_pagina`),
	ADD KEY `id_prodotto` (`id_prodotto`),
	ADD KEY `id_articolo` (`id_articolo`),
	ADD KEY `id_categoria_prodotti` (`id_categoria_prodotti`),
	ADD KEY `id_progetto` (`id_progetto`),
	ADD KEY `id_categoria_progetti` (`id_categoria_progetti`),
	ADD KEY `indice` (`id`,`ordine`,`macro`),
	ADD KEY `indice_pagine` (`id`,`id_pagina`,`ordine`,`macro`),
	ADD KEY `indice_prodotti` (`id`,`id_prodotto`,`ordine`,`macro`),
	ADD KEY `indice_articoli` (`id`,`id_articolo`,`ordine`,`macro`),
	ADD KEY `indice_categorie_prodotti` (`id`,`id_categoria_prodotti`,`ordine`,`macro`),
	ADD KEY `indice_notizie` (`id`,`id_notizia`,`ordine`,`macro`),
	ADD KEY `indice_categorie_notizie` (`id`,`id_categoria_notizie`,`ordine`,`macro`),
	ADD KEY `indice_risorse` (`id`,`id_risorsa`,`ordine`,`macro`),
	ADD KEY `indice_categorie_risorse` (`id`,`id_categoria_risorse`,`ordine`,`macro`);

-- | 030000018201

-- macro
-- tipologia: tabella gestita
ALTER TABLE `macro` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000018600

-- mail
-- tipologia: tabella gestita
-- verifica: 2021-09-27 18:33 Fabio Mosti
ALTER TABLE `mail`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_anagrafica`,`indirizzo`),
	ADD KEY `id_ruolo` (`id_ruolo`),
	ADD KEY `id_anagrafica` (`id_anagrafica`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`id_anagrafica`,`indirizzo`,`se_notifiche`,`se_pec`);

-- | 030000018601

-- mail
-- tipologia: tabella gestita
ALTER TABLE `mail` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000018800

-- mail_out
-- tipolgia: tabella gestita
-- verifica: 2021-09-28 15:29 Fabio Mosti
ALTER TABLE `mail_out`
	ADD PRIMARY KEY (`id`), 
  	ADD UNIQUE KEY `unica` (`id_mail`,`id_mailing`),
	ADD KEY `id_mail` (`id_mail`), 
	ADD KEY `id_mailing` (`id_mailing`), 
	ADD KEY `timestamp_composizione` (`timestamp_composizione`), 
	ADD KEY `timestamp_invio` (`timestamp_invio`), 
	ADD KEY `token` (`token`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 	
	ADD KEY `indice` (`id`,`id_mail`,`id_mailing`,`timestamp_composizione`,`timestamp_invio`,`token`,`tentativi`);

-- | 030000018801

-- mail_out
-- tipolgia: tabella gestita
ALTER TABLE `mail_out` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000018900

-- mail_sent
-- tipolgia: tabella gestita
-- verifica: 2021-09-28 16:21 Fabio Mosti
ALTER TABLE `mail_sent`
	ADD PRIMARY KEY (`id`), 
  	ADD UNIQUE KEY `unica` (`id_mail`,`id_mailing`),
	ADD KEY `id_mail` (`id_mail`), 
	ADD KEY `id_mailing` (`id_mailing`), 
	ADD KEY `timestamp_composizione` (`timestamp_composizione`), 
	ADD KEY `timestamp_invio` (`timestamp_invio`), 
	ADD KEY `token` (`token`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 	
	ADD KEY `indice` (`id`,`id_mail`,`id_mailing`,`timestamp_composizione`,`timestamp_invio`,`token`,`tentativi`);

-- | 030000018901

-- mail_sent
-- tipolgia: tabella gestita
ALTER TABLE `mail_sent` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000019000

-- mailing
-- tipolgia: tabella gestita
-- verifica: 2022-02-07 15:47 Chiara GDL
ALTER TABLE `mailing`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`nome`);

-- | 030000019001

-- mailing
-- tipolgia: tabella gestita
ALTER TABLE `mailing` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000019050

-- mailing_liste
-- tipolgia: tabella gestita
-- verifica: 2022-02-07 15:47 Chiara GDL
ALTER TABLE `mailing_liste`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_lista`,`id_mailing`),
	ADD KEY `id_mailing` (`id_mailing`),
	ADD KEY `id_lista` (`id_lista`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);

-- | 030000019051

-- mailing_liste
-- tipolgia: tabella gestita
ALTER TABLE `mailing_liste` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000019100

-- mailing_mail
-- tipolgia: tabella gestita
-- verifica: 2022-02-07 15:47 Chiara GDL
ALTER TABLE `mailing_mail`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE `unica_mail` (`id_mailing`, `id_mail`),
	ADD KEY `id_mailing` (`id_mailing`),
	ADD KEY `id_mail`(`id_mail`),
	ADD KEY `id_mail_out` (`id_mail_out`),
	ADD KEY `token` (`token`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_mailing`, `id_mail`, `id_mail_out`, `token` );
	
-- | 030000019101

-- mailing_mail
-- tipolgia: tabella gestita	
ALTER TABLE `mailing_mail` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;	

-- | 030000020200

-- marchi
-- tipologia: tabella gestita
-- verifica: 2021-09-28 16:51 Fabio Mosti
ALTER TABLE `marchi`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`nome`);

-- | 030000020201

-- marchi
-- tipologia: tabella gestita
ALTER TABLE `marchi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000020600

-- mastri
-- tipologia: tabella gestita
-- verifica: 2021-09-29 11:33 Fabio Mosti
ALTER TABLE `mastri`
 	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
 	ADD KEY `id_tipologia` (`id_tipologia`),
	ADD KEY `id_anagrafica_indirizzi` (`id_anagrafica_indirizzi`),
	ADD KEY `id_anagrafica` (`id_anagrafica`),
	ADD KEY `id_account` (`id_account`),
	ADD KEY `id_progetto` (`id_progetto`),
 	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
 	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`id_genitore`,`id_tipologia`,`nome`);

-- | 030000020601

-- mastri
-- tipologia: tabella gestita
ALTER TABLE `mastri` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000021000

-- matricole
-- tipologia: tabella gestita
-- verifica: 2021-12-28 16:20 Chiara GDL
ALTER TABLE `matricole`
 	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica_scadenza` (`id_articolo`,`data_scadenza`),
  	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
  	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  	ADD KEY `matricola` (`matricola`),
  	ADD KEY `id_marchio` (`id_marchio`),
  	ADD KEY `id_produttore` (`id_produttore`),
	ADD KEY `id_articolo` (`id_articolo` ),
  	ADD KEY `indice` (`id`,`id_marchio`,`id_produttore`,`matricola`,`nome`);

-- | 030000021001
ALTER TABLE `matricole` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000021600

-- menu
-- tipologia: tabella gestita
-- verifica: 2021-10-01 09:32 Fabio Mosti
ALTER TABLE `menu`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_lingua`,`id_pagina`,`menu`,`nome`,`ancora`), 
 	ADD UNIQUE KEY `unica_categoria_prodotti` (`id_lingua`,`id_categoria_prodotti`,`menu`,`nome`,`ancora`), 
 	ADD UNIQUE KEY `unica_categoria_notizie` (`id_lingua`,`id_categoria_notizie`,`menu`,`nome`,`ancora`), 
 	ADD UNIQUE KEY `unica_categoria_risorse` (`id_lingua`,`id_categoria_risorse`,`menu`,`nome`,`ancora`), 
	ADD UNIQUE KEY `unica_categoria_progetti` (`id_lingua`,`id_categoria_progetti`,`menu`,`nome`,`ancora`), 
	ADD KEY `id_lingua` (`id_lingua`),
	ADD KEY `id_pagina` (`id_pagina`), 
 	ADD KEY `id_categoria_prodotti` (`id_categoria_prodotti`), 
 	ADD KEY `id_categoria_notizie` (`id_categoria_notizie`), 
	ADD KEY `id_categoria_annunci` (`id_categoria_annunci`), 
 	ADD KEY `id_categoria_risorse` (`id_categoria_risorse`), 
	ADD KEY `id_categoria_progetti` (`id_categoria_progetti`),
	ADD KEY `indice` (`id`,`id_lingua`,`id_pagina`,`ordine`,`menu`,`nome`,`target`,`sottopagine`),
	ADD KEY `indice_categorie_prodotti` (`id`,`id_lingua`,`id_categoria_prodotti`,`menu`,`nome`),
	ADD KEY `indice_categorie_notizie` (`id`,`id_lingua`,`id_categoria_notizie`,`menu`,`nome`),
	ADD KEY `indice_categorie_risorse` (`id`,`id_lingua`,`id_categoria_risorse`,`menu`,`nome`);

-- | 030000021601

-- menu
-- tipologia: tabella gestita
ALTER TABLE `menu` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000021700

-- messaggi
-- tipologia: tabella gestita
-- verifica: 2022-04-26 17:32 Chiara GDL
ALTER TABLE `messaggi`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_conversazione` (`id_conversazione`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_conversazione`,`timestamp_invio`,`timestamp_lettura`);

-- | 030000021701

-- messaggi
-- tipologia: tabella gestita
ALTER TABLE `messaggi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000021750

-- messaggi_account
ALTER TABLE `messaggi_account`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_messaggio` (`id_messaggio`), 
	ADD KEY `id_account` (`id_account`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_messaggio`,`id_account`,`timestamp_lettura`);

-- | 030000021751

-- messaggi_account
-- tipologia: tabella gestita
ALTER TABLE `messaggi_account` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000021800

-- metadati
-- tipologia: tabella gestita
-- verifica: 2021-10-01 10:12 Fabio Mosti
ALTER TABLE `metadati`
 	ADD PRIMARY KEY (`id`), 
 	ADD UNIQUE KEY `unica_anagrafica` (`id_lingua`,`id_anagrafica`,`nome`), 
 	ADD UNIQUE KEY `unica_account` (`id_lingua`,`id_account`,`nome`), 
 	ADD UNIQUE KEY `unica_pagina` (`id_lingua`,`id_pagina`,`nome`), 
 	ADD UNIQUE KEY `unica_prodotto` (`id_lingua`,`id_prodotto`,`nome`), 
 	ADD UNIQUE KEY `unica_articolo` (`id_lingua`,`id_articolo`,`nome`), 
 	ADD UNIQUE KEY `unica_categoria_prodotti` (`id_lingua`,`id_categoria_prodotti`,`nome`), 
 	ADD UNIQUE KEY `unica_notizia` (`id_lingua`,`id_notizia`,`nome`), 
 	ADD UNIQUE KEY `unica_categoria_notizie` (`id_lingua`,`id_categoria_notizie`,`nome`), 
 	ADD UNIQUE KEY `unica_risorsa` (`id_lingua`,`id_risorsa`,`nome`), 
 	ADD UNIQUE KEY `unica_categoria_risorse` (`id_lingua`,`id_categoria_risorse`,`nome`), 
 	ADD UNIQUE KEY `unica_immagine` (`id_lingua`,`id_immagine`,`nome`), 
 	ADD UNIQUE KEY `unica_video` (`id_lingua`,`id_video`,`nome`), 
 	ADD UNIQUE KEY `unica_audio` (`id_lingua`,`id_audio`,`nome`), 
 	ADD UNIQUE KEY `unica_file` (`id_lingua`,`id_file`,`nome`), 
	ADD UNIQUE KEY `unica_progetto` (`id_lingua`,`id_progetto`,`nome`), 
 	ADD UNIQUE KEY `unica_categoria_progetto` (`id_lingua`,`id_categoria_progetti`,`nome`), 
 	ADD UNIQUE KEY `unica_indirizzo` (`id_lingua`,`id_indirizzo`,`nome`), 
 	ADD UNIQUE KEY `unica_edificio` (`id_lingua`,`id_edificio`,`nome`), 
 	ADD UNIQUE KEY `unica_immobile` (`id_lingua`,`id_immobile`,`nome`), 
 	ADD UNIQUE KEY `unica_contratto` (`id_lingua`,`id_contratto`,`nome`), 
 	ADD UNIQUE KEY `unica_rinnovo` (`id_lingua`,`id_rinnovo`,`nome`), 
 	ADD UNIQUE KEY `unica_tipologia_attivita` (`id_lingua`,`id_tipologia_attivita`,`nome`), 
	ADD UNIQUE KEY `unica_banner` (`id_lingua`,`id_banner`,`nome`), 
	ADD UNIQUE KEY `unica_pianificazione` (`id_lingua`,`id_pianificazione`,`nome`),
	ADD UNIQUE KEY `unica_tipologia_todo` (`id_lingua`,`id_tipologia_todo`,`nome`),
 	ADD UNIQUE KEY `unica_tipologia_contratti` (`id_lingua`,`id_tipologia_contratti`,`nome`), 
	ADD UNIQUE KEY `unica_carrello` (`id_lingua`,`id_carrello`,`nome`), 
 	ADD KEY `id_lingua` (`id_lingua`), 
 	ADD KEY `id_anagrafica` (`id_anagrafica`), 
 	ADD KEY `id_account` (`id_account`), 
 	ADD KEY `id_pagina` (`id_pagina`), 
 	ADD KEY `id_prodotto` (`id_prodotto`), 
 	ADD KEY `id_articolo` (`id_articolo`), 
 	ADD KEY `id_categoria_prodotti` (`id_categoria_prodotti`), 
 	ADD KEY `id_notizia` (`id_notizia`), 
	ADD KEY `id_annuncio` (`id_annuncio`),
 	ADD KEY `id_categoria_notizie` (`id_categoria_notizie`), 
	ADD KEY `id_categoria_annunci` (`id_categoria_annunci`), 
 	ADD KEY `id_risorsa` (`id_risorsa`),
 	ADD KEY `id_categoria_risorse` (`id_categoria_risorse`), 
 	ADD KEY `id_immagine` (`id_immagine`), 
 	ADD KEY `id_video` (`id_video`), 
 	ADD KEY `id_audio` (`id_audio`), 
 	ADD KEY `id_file` (`id_file`), 
	ADD KEY `id_documento` (`id_documento`), 
	ADD KEY `id_documenti_articoli` (`id_documenti_articoli`), 
	ADD KEY `id_progetto` (`id_progetto`),
	ADD KEY `id_categoria_progetti` (`id_categoria_progetti`),
	ADD KEY `id_indirizzo` (`id_indirizzo`), 
	ADD KEY `id_edificio` (`id_edificio`), 
	ADD KEY `id_immobile` (`id_immobile`),
	ADD KEY `id_contratto` (`id_contratto`), 
	ADD KEY `id_valutazione` (`id_valutazione`), 
	ADD KEY `id_rinnovo` (`id_rinnovo`), 
	ADD KEY `id_attivita` (`id_attivita`), 
	ADD KEY `id_tipologia_attivita` (`id_tipologia_attivita`), 
	ADD KEY `id_banner` (`id_banner`), 
	ADD KEY `id_pianificazione` (`id_pianificazione`), 
	ADD KEY `id_todo` (`id_todo`), 
	ADD KEY `id_tipologia_todo` (`id_tipologia_todo`),
	ADD KEY `id_tipologia_contratti` (`id_tipologia_contratti`), 
	ADD KEY `id_carrello` (`id_carrello`),
	ADD KEY `indice` (`id`,`id_lingua`,`nome`,`testo` (255));

-- | 030000021801

-- metadati
-- tipologia: tabella gestita
ALTER TABLE `metadati` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000021900

-- modalita_pagamento
-- tipologia: tabella standard
-- verifica: 2022-01-18 12:06 Chiara GDL
ALTER TABLE `modalita_pagamento`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `nome` (`nome`,`codice`),
	ADD KEY `indice` (`id`,`nome`,`provider`,`codice`);

-- | 030000021901

-- modalita_pagamento
-- tipologia: tabella standard
ALTER TABLE `modalita_pagamento` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000022000

-- notizie
-- tipologia: tabella gestita
-- verifica: 2021-10-01 12:07 Fabio Mosti
ALTER TABLE `notizie`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_tipologia` (`id_tipologia`),
	ADD KEY `id_sito` (`id_sito`),
	ADD KEY `se_sitemap` (`se_sitemap`),
	ADD KEY `se_cacheable` (`se_cacheable`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`id_tipologia`,`nome`, `id_sito`);

-- | 030000022001

-- notizie
-- tipologia: tabella gestita
ALTER TABLE `notizie` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000022200

-- notizie_categorie
-- tipologia: tabella gestita
-- verifica: 2021-10-01 12:07 Fabio Mosti
ALTER TABLE `notizie_categorie`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_notizia`,`id_categoria`),
	ADD KEY `id_notizia` (`id_notizia`), 
	ADD KEY `id_annuncio` (`id_annuncio`),
	ADD KEY `id_categoria` (`id_categoria`), 
	ADD KEY `ordine` (`ordine`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`id_notizia`,`id_categoria`,`ordine`);

-- | 030000022201

-- notizie_categorie
-- tipologia: tabella gestita
ALTER TABLE `notizie_categorie` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000022300

-- orari
ALTER TABLE `orari`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_tipologia_contratti` (`id_tipologia_contratti`), 
	ADD KEY `id_periodicita` (`id_periodicita`), 
	ADD KEY `id_giorno` (`id_giorno`), 
	ADD KEY `ora_inizio` (`ora_inizio`),
	ADD KEY `ora_fine` (`ora_fine`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`id_tipologia_contratti`,`id_periodicita`,`id_giorno`,`ora_inizio`,`ora_fine`);

-- | 030000022301

-- orari
ALTER TABLE `orari` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000022800

-- organizzazioni
-- tipologia: tabella gestita
-- verifica: 2021-05-23 14:39 Fabio Mosti
ALTER TABLE `organizzazioni`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_genitore`,`id_anagrafica`,`id_ruolo`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `id_anagrafica` (`id_anagrafica`),
	ADD KEY `id_ruolo` (`id_ruolo`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`id_anagrafica`,`id_ruolo`);

-- | 030000022801

-- organizzazioni
-- tipologia: tabella gestita
ALTER TABLE `organizzazioni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000023100

-- pagamenti
-- tipologia: tabella gestita
-- verifica: 2021-11-12 16:00 Chiara GDL
ALTER TABLE `pagamenti`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_documento`,`data_scadenza`,`nome`),
	ADD KEY `id_tipologia` (`id_tipologia`), 
	ADD KEY `id_modalita_pagamento` (`id_modalita_pagamento`),
	ADD KEY `ordine` (`ordine`), 
	ADD KEY `id_documento` (`id_documento`), 
	ADD KEY `id_carrelli_articoli` (`id_carrelli_articoli`), 
	ADD KEY `id_creditore` (`id_creditore`), 
	ADD KEY `id_debitore` (`id_debitore`), 
	ADD KEY `id_mastro_provenienza` (`id_mastro_provenienza`), 
	ADD KEY `id_mastro_destinazione` (`id_mastro_destinazione`), 
	ADD KEY `id_iban` (`id_iban`), 
	ADD KEY `id_listino` (`id_listino`), 
	ADD KEY `timestamp_pagamento` (`timestamp_pagamento`), 
	ADD KEY `data_scadenza` (`data_scadenza`), 
	ADD KEY `importo_lordo_totale` (`importo_lordo_totale`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`id_tipologia`,`ordine`,`id_documento`,`timestamp_pagamento`,`id_mastro_provenienza`,`id_mastro_destinazione`,`id_listino`,`id_iban`,`importo_lordo_totale`);

-- | 030000023101

-- pagamenti
-- tipologia: tabella gestita
ALTER TABLE `pagamenti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000023200

-- pagine
-- tipologia: tabella gestita
-- verifica: 2021-10-04 11:31 Fabio Mosti
ALTER TABLE `pagine`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`nome`, `id_genitore`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `id_sito` (`id_sito`),
	ADD KEY `nome` (`nome`),
	ADD KEY `id_contenuti` (`id_contenuti`),
	ADD KEY `se_sitemap` (`se_sitemap`),
	ADD KEY `se_cacheable` (`se_cacheable`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_genitore`,`id_sito`,`nome`,`template`,`schema_html`,`tema_css`,`se_sitemap`,`se_cacheable`,`id_contenuti`);

-- | 030000023201

-- pagine
-- tipologia: tabella gestita
ALTER TABLE `pagine` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000023500

-- periodi
-- tipologia: tabella di supporto
-- verifica: 2022-05-24 12:57 Chiara GDL
ALTER TABLE `periodi`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` ( `data_inizio`, `data_fine`, `id_contratto`, `nome`, `id_genitore`),
	ADD	KEY `id_genitore` (`id_genitore`),
	ADD	KEY `id_tipologia` (`id_tipologia`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` ( `id`, `id_genitore`, `data_inizio`, `data_fine`, `nome`,`id_tipologia`);

-- | 030000023501

-- periodi
-- tipologia: tabella di supporto
ALTER TABLE `periodi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000023600

-- periodicita
-- tipologia: tabella di supporto
-- verifica: 2021-10-05 17:57 Fabio Mosti
ALTER TABLE `periodicita`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`nome`), 
	ADD KEY `giorni` (`giorni`), 
	ADD KEY `nome` (`nome`), 
	ADD KEY `indice` (`id`,`nome`);

-- | 030000023601

-- periodicita
-- tipologia: tabella gestita
ALTER TABLE `periodicita` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000023700

-- pesi_tipologie_corrispondenza
ALTER TABLE `pesi_tipologie_corrispondenza`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_tipologia` (`id_tipologia`);

-- | 030000023701

-- pesi_tipologie_corrispondenza
ALTER TABLE `pesi_tipologie_corrispondenza` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000023800

-- pianificazioni
-- tipologia: tabella gestita
-- verifica: 2021-10-05 17:57 Fabio Mosti
ALTER TABLE `pianificazioni`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `id_progetto` (`id_progetto`), 
	ADD KEY `id_todo` (`id_todo`), 
	ADD KEY `id_attivita` (`id_attivita`), 
	ADD KEY `id_contratto` (`id_contratto`),
	ADD KEY `id_periodicita` (`id_periodicita`),
	ADD KEY `nome` (`nome`), 
	ADD KEY `token` (`token`), 
	ADD KEY `data_fine` (`data_fine`),
	ADD KEY `data_inizio` (`data_inizio`),
	ADD KEY `data_elaborazione` (`data_elaborazione`),
	ADD KEY `timestamp_elaborazione` (`timestamp_elaborazione`),
	ADD KEY `entita` (`entita`),
	ADD KEY `model_id_luogo` (`model_id_luogo`),
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
	ADD KEY `model_data_scadenza`  (`model_data_scadenza`),
	ADD KEY `indice` (`id`,`nome`,`id_periodicita`,`cadenza`,`se_lunedi`,`se_martedi`,`se_mercoledi`,`se_giovedi`,`se_venerdi`,`se_sabato`,`se_domenica`,`schema_ripetizione`,`data_elaborazione`,`giorni_estensione`,`data_fine`,`token`);

-- | 030000023801

-- pianificazioni
-- tipologia: tabella gestita
ALTER TABLE `pianificazioni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000024000

-- popup
-- tipologia: tabella gestita
-- verifica: 2021-10-04 16:14 Fabio Mosti
ALTER TABLE `popup`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_tipologia` (`id_tipologia`), 
	ADD KEY `id_sito` (`id_sito`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_tipologia`,`id_sito`,`nome`,`html_id`,`html_class`,`html_class_attivazione`,`n_scroll`,`n_secondi`,`template`,`schema_html`,`se_ovunque`);

-- | 030000024001

-- popup
-- tipologia: tabella gestita
ALTER TABLE `popup` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000024200

-- popup_pagine
-- tipologia: tabella gestita
-- verifica: 2021-10-04 16:53 Fabio Mosti
ALTER TABLE `popup_pagine`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_pagina`,`id_popup`), 
	ADD KEY `id_popup` (`id_popup`), 
	ADD KEY `id_pagina` (`id_pagina`),
	ADD KEY `se_presente` (`se_presente`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_pagina`,`id_popup`,`se_presente`);

-- | 030000024201

-- popup_pagine
-- tipologia: tabella gestita
ALTER TABLE `popup_pagine` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000025000

-- prezzi
-- tipologia: tabella gestita
-- verifica: 2021-10-04 16:53 Fabio Mosti
ALTER TABLE `prezzi`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica_prodotto` (`id_prodotto`,`fascia`,`id_listino`,`id_iva`), 
	ADD UNIQUE KEY `unica_articolo` (`id_articolo`,`fascia`,`id_listino`,`id_iva`), 
	ADD KEY `id_prodotto` (`id_prodotto`), 
	ADD KEY `id_articolo` (`id_articolo`), 
	ADD KEY `id_listino` (`id_listino`),
	ADD KEY `id_iva` (`id_iva`),
	ADD KEY `prezzo` (`prezzo`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_prodotto`,`id_articolo`,`prezzo`,`id_listino`,`id_iva`),
	ADD KEY `indice_prodotti` (`id`,`id_prodotto`,`prezzo`,`id_listino`,`id_iva`),
	ADD KEY `indice_articoli` (`id`,`id_articolo`,`prezzo`,`id_listino`,`id_iva`);

-- | 030000025001

-- prezzi
-- tipologia: tabella gestita
ALTER TABLE `prezzi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000025500

-- istruzioni
ALTER TABLE `istruzioni`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id`,`id_tipologia`,`nome`),
	ADD KEY `id_tipologia` (`id_tipologia`),
	ADD KEY `id_prodotto` (`id_prodotto`),
	ADD KEY `id_articolo` (`id_articolo`),
	ADD KEY `nome` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice_prodotti` (`id`,`id_tipologia`,`id_prodotto`,`nome`),
	ADD KEY `indice_articoli` (`id`,`id_tipologia`,`id_articolo`,`nome`);

-- | 030000025501

-- istruzioni
ALTER TABLE `istruzioni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000025560

-- istruzioni_tipologie_attivita
ALTER TABLE `istruzioni_tipologie_attivita`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_istruzione`,`id_tipologia_attivita`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `id_istruzione` (`id_istruzione`),
	ADD KEY `id_tipologia_attivita` (`id_tipologia_attivita`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_istruzione`,`id_tipologia_attivita`);

-- | 030000025561

-- istruzioni_tipologie_attivita
ALTER TABLE `istruzioni_tipologie_attivita` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000026000

-- prodotti
-- tipologia: tabella gestita
-- verifica: 2021-10-04 18:50 Fabio Mosti
ALTER TABLE `prodotti`
	ADD PRIMARY KEY (`id`), 	
	ADD KEY `id_tipologia` (`id_tipologia`), 	
	ADD KEY `id_marchio` (`id_marchio`), 	
	ADD KEY `id_produttore` (`id_produttore`), 	
	ADD KEY `nome` (`nome`), 	
	ADD KEY `codice_produttore` (`codice_produttore`), 	
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `id_sito` (`id_sito`),
	ADD KEY `se_sitemap` (`se_sitemap`),
	ADD KEY `se_cacheable` (`se_cacheable`),
	ADD KEY `indice` (`id`,`id_tipologia`,`id_marchio`,`id_produttore`,`nome`,`codice_produttore`);

-- | 030000026200

-- prodotti_caratteristiche
-- tipologia: tabella gestita
-- verifica: 2021-10-04 19:26 Fabio Mosti
ALTER TABLE `prodotti_caratteristiche`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_prodotto`,`id_caratteristica`), 
	ADD KEY `id_prodotto` (`id_prodotto`),
	ADD KEY `id_caratteristica` (`id_caratteristica`),
	ADD KEY `id_lingua` (`id_lingua`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_prodotto`,`id_caratteristica`,`id_lingua`,`ordine`);

-- | 030000026201

-- prodotti_caratteristiche
-- tipologia: tabella gestita
ALTER TABLE `prodotti_caratteristiche` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000026400

-- prodotti_categorie
-- tipologia: tabella gestita
-- verifica: 2021-10-04 19:06 Fabio Mosti
ALTER TABLE `prodotti_categorie`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_prodotto`,`id_categoria`), 
	ADD KEY `id_prodotto` (`id_prodotto`), 
	ADD KEY `id_categoria` (`id_categoria`), 
	ADD KEY `id_ruolo` (`id_ruolo`),
	ADD KEY `ordine` (`ordine`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_prodotto`,`id_categoria`,`id_ruolo`,`ordine`);

-- | 030000026401

-- prodotti_categorie
-- tipologia: tabella gestita
ALTER TABLE `prodotti_categorie` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000027000

-- progetti
-- tipologia: tabella gestita
-- verifica: 2021-10-08 13:54 Fabio Mosti
ALTER TABLE `progetti`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_tipologia` (`id_tipologia`), 
	ADD KEY `id_pianificazione` (`id_pianificazione`),
	ADD KEY `id_cliente` (`id_cliente`), 
	ADD KEY `id_indirizzo` (`id_indirizzo`), 
	ADD KEY `id_ranking` (`id_ranking`),
	ADD KEY `id_articolo` (`id_articolo`), 
	ADD KEY `id_prodotto` (`id_prodotto`), 
	ADD KEY `id_periodo` (`id_periodo`),  	
	ADD KEY `nome` (`nome`), 
	ADD KEY `id_sito` (`id_sito`),
	ADD KEY `se_sitemap` (`se_sitemap`),
	ADD KEY `se_cacheable` (`se_cacheable`),
	ADD KEY `data_accettazione` (`data_accettazione`),
	ADD KEY `data_apertura` (`data_apertura`),
	ADD KEY `data_chiusura` (`data_chiusura`),
	ADD KEY `data_archiviazione` (`data_archiviazione`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_tipologia`,`id_pianificazione`,`id_cliente`,`id_indirizzo`,`id_ranking` ,`nome`,`data_accettazione`,`data_apertura`,`data_chiusura`,`data_archiviazione`);

-- | 030000027200

-- progetti_anagrafica
-- tipologia: tabella gestita
-- verifica: 2021-10-08 15:00 Fabio Mosti
ALTER TABLE `progetti_anagrafica`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_progetto`,`id_anagrafica`,`id_ruolo`), 
	ADD KEY `id_progetto` (`id_progetto`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_ruolo` (`id_ruolo`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `se_sostituto` (`se_sostituto`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_progetto`,`id_anagrafica`,`id_ruolo`,`ordine`);

-- | 030000027201

-- progetti_anagrafica
-- tipologia: tabella gestita
ALTER TABLE `progetti_anagrafica` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000027300

-- progetti_articoli
-- tipologia: tabella gestita
-- verifica: 2021-04-14 14:58 Chiara GDL
ALTER TABLE `progetti_articoli`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_progetto`,`id_articolo`, `id_ruolo`),
	ADD KEY `id_ruolo` (`id_ruolo`), 
	ADD KEY `id_progetto` (`id_progetto`),
	ADD KEY `id_articolo` (`id_articolo`),	
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_progetto`,`id_articolo`, `id_ruolo`,`ordine`);
	
-- | 030000027301

-- progetti_articoli
-- tipologia: tabella gestita
ALTER TABLE `progetti_articoli` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000027400

-- progetti_categorie
-- tipologia: tabella gestita
-- verifica: 2021-10-08 15:00 Fabio Mosti
ALTER TABLE `progetti_categorie`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_progetto`,`id_categoria`), 
	ADD KEY `id_progetto` (`id_progetto`), 
	ADD KEY `id_categoria` (`id_categoria`), 
	ADD KEY `ordine` (`ordine`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_progetto`,`id_categoria`,`ordine`);

-- | 030000027401

-- progetti_categorie
-- tipologia: tabella gestita
ALTER TABLE `progetti_categorie` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000027600

-- progetti_certificazioni
-- tipologia: tabella gestita
-- verifica: 2022-02-03 11:12 Chiara GDL
ALTER TABLE `progetti_certificazioni`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_progetto`,`id_certificazione`), 
	ADD KEY `id_progetto` (`id_progetto`), 
	ADD KEY `id_certificazione` (`id_certificazione`), 
	ADD KEY `ordine` (`ordine`),
	ADD KEY `se_richiesta` (`se_richiesta`),
	ADD KEY `nome` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_progetto`,`id_certificazione`,`ordine`,`nome`);

-- | 030000027601

-- progetti_certificazioni
-- tipologia: tabella gestita
ALTER TABLE `progetti_certificazioni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000027800

-- progetti_matricole
-- tipologia: tabella gestita
-- verifica: 2021-10-08 15:00 Fabio Mosti
ALTER TABLE `progetti_matricole`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_progetto`,`id_matricola`,`id_ruolo`), 
	ADD KEY `id_progetto` (`id_progetto`), 
	ADD KEY `id_matricola` (`id_matricola`), 
	ADD KEY `id_ruolo` (`id_ruolo`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_progetto`,`id_matricola`,`ordine`,`id_ruolo`);

-- | 030000027801

-- progetti_matricole
-- tipologia: tabella gestita
ALTER TABLE `progetti_matricole` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000028000

-- provincie
-- tipologia: tabella di supporto
-- verifica: 2021-10-08 16:23 Fabio Mosti
ALTER TABLE `provincie`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_regione`,`nome`),
	ADD UNIQUE KEY `unica_sigla` (`sigla`),
	ADD UNIQUE KEY `unica_codice_istat` (`codice_istat`),
	ADD KEY `id_regione` (`id_regione`),
	ADD KEY `nome` (`nome`),
	ADD KEY `codice_istat` (`codice_istat`),
	ADD KEY `indice` (`id`,`id_regione`,`nome`,`sigla`,`codice_istat`);

-- | 030000028001

-- provincie
-- tipologia: tabella di supporto
ALTER TABLE `provincie` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000028400

-- pubblicazioni
-- tipologia: tabella gestita
-- verifica: 2021-10-08 16:40 Fabio Mosti
ALTER TABLE `pubblicazioni`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_tipologia` (`id_tipologia`), 
	ADD KEY `id_pagina` (`id_pagina`), 
	ADD KEY `id_popup` (`id_popup`), 
	ADD KEY `id_prodotto` (`id_prodotto`),
	ADD KEY `id_articolo` (`id_articolo`),
	ADD KEY `id_categoria_prodotti` (`id_categoria_prodotti`), 
	ADD KEY `id_notizia` (`id_notizia`),
	ADD KEY `id_categoria_notizie` (`id_categoria_notizie`), 
	ADD KEY `id_categoria_annunci` (`id_categoria_annunci`), 
	ADD KEY `id_risorsa` (`id_risorsa`),
	ADD KEY `id_categoria_risorse` (`id_categoria_risorse`), 
	ADD KEY `id_progetto` (`id_progetto`),
	ADD KEY `id_categoria_progetti` (`id_categoria_progetti`),
	ADD KEY `id_banner` (`id_banner`),
	ADD KEY `timestamp_inizio` (`timestamp_inizio`), 
	ADD KEY `timestamp_fine` (`timestamp_fine`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_tipologia`,`ordine`,`id_prodotto`,`id_articolo`,`id_categoria_prodotti`,`id_notizia`,`id_categoria_notizie`,`id_pagina`,`id_popup`,`timestamp_inizio`,`timestamp_fine`);

-- | 030000028401

-- pubblicazioni
-- tipologia: tabella gestita
ALTER TABLE `pubblicazioni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000028600

-- ranking
-- tipologia: tabella assistita
-- verifica: 2021-10-11 17:48 Fabio Mosti
ALTER TABLE `ranking`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`nome`),
	ADD KEY `nome` (`nome`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `se_fornitore` (`se_fornitore`),
	ADD KEY `se_cliente` (`se_cliente`),
	ADD KEY `se_progetti` (`se_progetti`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`nome`,`ordine`,  `se_cliente`, `se_fornitore`,`se_progetti`);

-- | 030000028601

-- ranking
-- tipologia: tabella assistita
-- verifica: 2021-10-11 17:48 Fabio Mosti
ALTER TABLE `ranking` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000029400

-- redirect
-- tipologia: tabella gestita
-- verifica: 2021-10-09 14:43 Fabio Mosti
ALTER TABLE `redirect`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_sito`,`sorgente`),
	ADD KEY `id_sito` (`id_sito`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`codice_stato_http`,`sorgente`,`destinazione`);

-- | 030000029401

-- redirect
-- tipologia: tabella gestita
ALTER TABLE `redirect` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000029800

-- regimi
-- tipologia: tabella di supporto
-- verifica: 2021-10-09 15:04 Fabio Mosti
ALTER TABLE `regimi`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`nome`),
	ADD KEY `indice` (`id`,`nome`,`codice`); 

-- | 030000029801

-- regimi
-- tipologia: tabella di supporto
ALTER TABLE `regimi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000030200

-- regioni
-- tipologia: tabella standard
-- verifica: 2021-10-09 15:24 Fabio Mosti
ALTER TABLE `regioni`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`codice_istat`),
	ADD UNIQUE KEY `unica_nome` (`id_stato`,`nome`),
	ADD KEY `id_stato` (`id_stato`),
	ADD KEY `indice` (`id`,`id_stato`,`nome`,`codice_istat`);

-- | 030000030201

-- regioni
-- tipologia: tabella standard
ALTER TABLE `regioni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000030300

-- relazioni_anagrafica
-- tipologia: tabella relazione
-- verifica: 2022-02-03 11:12 Chiara GDL
ALTER TABLE `relazioni_anagrafica`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unico` (`id_anagrafica`,`id_anagrafica_collegata`, `id_ruolo`),
	ADD KEY `id_ruolo` (`id_ruolo`),
	ADD KEY `id_anagrafica` (`id_anagrafica`),
	ADD KEY `id_anagrafica_collegata` (`id_anagrafica_collegata`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);
	
-- | 030000030301

-- relazioni_anagrafica
-- tipologia: tabella relazione
ALTER TABLE `relazioni_anagrafica` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000030350

-- relazioni_categorie_progetti
-- tipologia: tabella relazione
-- verifica: 2022-02-03 11:12 Chiara GDL
ALTER TABLE `relazioni_categorie_progetti`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unico` (`id_categoria`,`id_ruolo`, `id_categoria_collegata`),
	ADD KEY `id_ruolo` (`id_ruolo`),
	ADD KEY `id_categoria` (`id_categoria`),
	ADD KEY `id_categoria_collegata` (`id_categoria_collegata`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);
	
-- | 030000030351

-- relazioni_anagrafica
-- tipologia: tabella relazione
ALTER TABLE `relazioni_categorie_progetti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000030400

-- relazioni_documenti
-- tipologia: tabella relazione
-- verifica: 2022-01-17 16:12 Chiara GDL
ALTER TABLE `relazioni_documenti`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unico` (`id_documento`,`id_documento_collegato`,`id_ruolo`),
	ADD KEY `id_documento` (`id_documento`),
	ADD KEY `id_documento_collegato` (`id_documento_collegato`),
	ADD KEY `id_ruolo` (`id_ruolo`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);
	
-- | 030000030401

-- relazioni_documenti
-- tipologia: tabella relazione
ALTER TABLE `relazioni_documenti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000030410

-- relazioni_documenti_articoli
-- tipologia: tabella relazione
-- verifica: 2022-01-17 16:12 Chiara GDL
ALTER TABLE `relazioni_documenti_articoli`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unico` (`id_documenti_articolo`,`id_documenti_articolo_collegato`,`id_ruolo`),
	ADD KEY `id_documenti_articolo` (`id_documenti_articolo`),
	ADD KEY `id_documenti_articolo_collegato` (`id_documenti_articolo_collegato`),
	ADD KEY `id_ruolo` (`id_ruolo`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);

-- | 030000030411

-- relazioni_documenti_articoli
-- tipologia: tabella relazione
ALTER TABLE `relazioni_documenti_articoli` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000030440

-- relazioni_pagamenti
-- tipologia: tabella relazione
-- verifica: 2022-01-17 16:12 Chiara GDL
ALTER TABLE `relazioni_pagamenti`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unico` (`id_pagamento`,`id_pagamento_collegato`),
	ADD KEY `id_pagamento` (`id_pagamento`),
	ADD KEY `id_pagamento_collegato` (`id_pagamento_collegato`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);	
-- | 030000030441

-- relazioni_pagamenti
-- tipologia: tabella relazione
ALTER TABLE `relazioni_pagamenti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000030470

-- relazioni_prodotti
ALTER TABLE `relazioni_prodotti`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unico` (`id_prodotto`,`id_prodotto_collegato`,`id_ruolo`),
	ADD KEY `id_prodotto` (`id_prodotto`),
	ADD KEY `id_ruolo` (`id_ruolo`),
	ADD KEY `id_prodotto_collegato` (`id_prodotto_collegato`),
	ADD KEY `id_articolo_collegato` (`id_articolo_collegato`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);

-- | 030000030471

-- relazioni_prodotti
ALTER TABLE `relazioni_prodotti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;


-- | 030000030490

-- relazioni_progetti
-- tipologia: tabella relazione
-- verifica: 2022-01-17 16:12 Chiara GDL
ALTER TABLE `relazioni_progetti`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unico` (`id_progetto`,`id_progetto_collegato`,`id_ruolo`),
	ADD KEY `id_ruolo` (`id_ruolo`),
	ADD KEY `id_progetto` (`id_progetto`),
	ADD KEY `id_progetto_collegato` (`id_progetto_collegato`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);

-- | 030000030491

-- relazioni_progetti
-- tipologia: tabella relazione
ALTER TABLE `relazioni_progetti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000030500

-- relazioni_software
-- tipologia: tabella relazione
-- verifica: 2022-01-17 16:12 Chiara GDL
ALTER TABLE `relazioni_software`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unico` (`id_software`,`id_software_collegato`),
	ADD KEY `id_software` (`id_software`),
	ADD KEY `id_software_collegato` (`id_software_collegato`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);
	
-- | 030000030501

-- relazioni_software
-- tipologia: tabella relazione
ALTER TABLE `relazioni_software` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000030800

-- reparti
-- tipologia: tabella assistita
-- verifica: 2021-10-09 15:36 Fabio Mosti
ALTER TABLE `reparti` 
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_iva` (`id_iva`), 
	ADD KEY `id_settore` (`id_settore`), 
	ADD KEY `nome` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`id_iva`,`id_settore`,`nome`);

-- | 030000030801

-- reparti
-- tipologia: tabella gestita
ALTER TABLE `reparti`MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000031500

-- rinnovi
-- tipologia: tabella gestita
-- verifica: 2022-02-21 12:59 Chiara GDL
ALTER TABLE `rinnovi`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica_codice` (`codice`),
	ADD UNIQUE KEY `unica_contratto` (`id_contratto`, `id_tipologia_contratto`, `codice`, `data_inizio`, `data_fine`),
	ADD UNIQUE KEY `unica_progetto` (`id_progetto`, `codice`, `data_inizio`, `data_fine`),
	ADD	KEY `id_tipologia` (`id_tipologia`),
	ADD	KEY `id_periodicita` (`id_periodicita`),
	ADD	KEY `id_contratto` (`id_contratto`),
	ADD KEY `id_licenza` (`id_licenza`),
	ADD KEY `id_progetto` (`id_progetto`),
	ADD KEY `id_tipologia_contratto` (`id_tipologia_contratto`),
	ADD KEY `id_categoria_progetti` (`id_categoria_progetti`),
	ADD KEY `indice` ( `id_contratto`, `id_tipologia`, `id_licenza`, `id_progetto`, `id_categoria_progetti`, `data_inizio`, `data_fine`, `codice`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);

-- | 030000031501

-- rinnovi
-- tipologia: tabella gestita
ALTER TABLE `rinnovi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;


-- | 030000031550

-- rinnovi_documenti_articoli
-- tipologia: tabella gestita
-- verifica: 2022-03-08 15:59 Chiara GDL
ALTER TABLE `rinnovi_documenti_articoli`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unico` (`id_documenti_articolo`,`id_rinnovo`),
	ADD KEY `id_rinnovo` (`id_rinnovo`),
	ADD KEY `id_documenti_articolo` (`id_documenti_articolo`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);
	
-- | 030000031551

-- rinnovi_documenti_articoli
-- tipologia: tabella gestita
ALTER TABLE `rinnovi_documenti_articoli` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000032000

-- risorse
-- tipologia: tabella gestita
-- verifica: 2021-10-09 16:08 Fabio Mosti
ALTER TABLE `risorse`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_tipologia` (`id_tipologia`),
	ADD KEY `id_testata` (`id_testata`),
	ADD KEY `id_articolo` (`id_articolo`), 
	ADD KEY `id_prodotto` (`id_prodotto`), 
	ADD KEY `id_sito` (`id_sito`),
	ADD KEY `se_sitemap` (`se_sitemap`),
	ADD KEY `se_cacheable` (`se_cacheable`),
	ADD KEY `giorno_pubblicazione` (`giorno_pubblicazione`),
	ADD KEY `mese_pubblicazione` (`mese_pubblicazione`),
	ADD KEY `anno_pubblicazione` (`anno_pubblicazione`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_tipologia`,`codice`,`nome`,`id_testata`,`giorno_pubblicazione`,`mese_pubblicazione`,`anno_pubblicazione`);

-- | 030000032001

-- risorse
-- tipologia: tabella gestita
ALTER TABLE `risorse` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;	

-- | 030000032100

-- risorse_account
-- tipologia: tabella di supporto
-- verifica: 2022-08-02 12:07 Chiara GDL
ALTER TABLE `risorse_account`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_risorsa`,`id_account`),
	ADD KEY `id_account` (`id_account`),
	ADD KEY `id_risorsa` (`id_risorsa`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_risorsa`,`id_account`,`ordine`);

-- | 030000032101

-- risorse_account
-- tipologia: tabella di supporto
ALTER TABLE `risorse_account` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000032200

-- risorse_anagrafica
-- tipologia: tabella di supporto
-- verifica: 2021-10-09 16:08 Fabio Mosti
ALTER TABLE `risorse_anagrafica`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_risorsa`,`id_anagrafica`,`id_ruolo`),
	ADD KEY `id_anagrafica` (`id_anagrafica`),
	ADD KEY `id_risorsa` (`id_risorsa`),
	ADD KEY `id_ruolo` (`id_ruolo`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_risorsa`,`id_anagrafica`,`id_ruolo`,`ordine`);

-- | 030000032201

-- risorse_anagrafica
-- tipologia: tabella di supporto
ALTER TABLE `risorse_anagrafica` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000032400

-- risorse_categorie
-- tipologia: tabella di supporto
-- verifica: 2021-10-09 17:48 Fabio Mosti
ALTER TABLE `risorse_categorie`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_risorsa` (`id_risorsa`),
	ADD KEY `id_categoria` (`id_categoria`), 
	ADD KEY `ordine` (`ordine`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_risorsa`,`id_categoria`,`ordine`);

-- | 030000032401

-- risorse_categorie
-- tipologia: tabella di supporto
ALTER TABLE `risorse_categorie` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000034000

-- ruoli_anagrafica
-- tipologia: tabella standard
-- verifica: 2021-10-09 18:11 Fabio Mosti
ALTER TABLE `ruoli_anagrafica`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`nome`, `id_genitore`),
	ADD KEY `id_genitore` (`id_genitore`), 
	ADD KEY `se_didattica` (`se_didattica`),
	ADD KEY `se_produzione` (`se_produzione`),
	ADD KEY `se_organizzazioni` (`se_organizzazioni`), 
	ADD KEY `se_risorse` (`se_risorse`), 
	ADD KEY `se_progetti` (`se_progetti`), 
	ADD KEY `se_immobili` (`se_immobili`),
	ADD KEY `se_contratti` (`se_contratti`),
	ADD KEY `indice` (`id`,`id_genitore`,`nome`,`se_organizzazioni`,`se_risorse`,`se_progetti`, `se_immobili`, `se_contratti`);

-- | 030000034001

-- ruoli_anagrafica
-- tipologia: tabella standard
ALTER TABLE `ruoli_anagrafica` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000034100

-- ruoli_articoli
-- tipologia: tabella standard
-- verifica: 2021-10-09 18:11 Fabio Mosti
ALTER TABLE `ruoli_articoli`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`nome`, `id_genitore`),
	ADD KEY `id_genitore` (`id_genitore`), 
	ADD KEY `se_progetti` (`se_progetti`),
	ADD KEY `se_risorse` (`se_risorse`),
	ADD KEY `se_acquisto` (`se_acquisto`),
	ADD KEY `se_rinnovo` (`se_rinnovo`),
	ADD KEY `indice` (`id`,`id_genitore`,`nome`,`se_progetti`,`se_risorse`,`se_acquisto`, `se_rinnovo`);

-- | 030000034101

-- ruoli_articoli
-- tipologia: tabella standard
ALTER TABLE `ruoli_articoli` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000034200

-- ruoli_audio
-- tipologia: tabella standard
-- verifica: 2021-10-09 18:28 Fabio Mosti
ALTER TABLE `ruoli_audio`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`nome`, `id_genitore`),
	ADD KEY `id_genitore` (`id_genitore`), 
	ADD KEY `se_anagrafica` (`se_anagrafica`), 
	ADD KEY `se_pagine` (`se_pagine`), 
	ADD KEY `se_prodotti` (`se_prodotti`), 
	ADD KEY `se_articoli` (`se_articoli`), 
	ADD KEY `se_categorie_prodotti` (`se_categorie_prodotti`), 
	ADD KEY `se_notizie` (`se_notizie`), 
	ADD KEY `se_categorie_notizie` (`se_categorie_notizie`), 
	ADD KEY `se_risorse` (`se_risorse`), 
	ADD KEY `se_categorie_risorse` (`se_categorie_risorse`), 
	ADD KEY `se_immobili` (`se_immobili`),
	ADD KEY `indice` (`id`,`id_genitore`,`nome`,`html_entity`,`font_awesome`,`se_anagrafica`,`se_pagine`,`se_prodotti`,`se_articoli`,`se_categorie_prodotti`,`se_notizie`,`se_categorie_notizie`,`se_risorse`,`se_categorie_risorse`);

-- | 030000034201

-- ruoli_audio
-- tipologia: tabella standard
ALTER TABLE `ruoli_audio` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000034250

-- ruoli_categorie_progetti
-- tipologia: tabella standard
-- verifica: 2021-10-09 18:28 Fabio Mosti
ALTER TABLE `ruoli_categorie_progetti`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`nome`, `id_genitore`),
	ADD KEY `id_genitore` (`id_genitore`), 
	ADD KEY `se_recuperi` (`se_recuperi`), 
	ADD KEY `indice` (`id`,`nome`,`html_entity`,`font_awesome`,`se_recuperi`);

-- | 030000034251

-- ruoli_categorie_progetti
-- tipologia: tabella standard
ALTER TABLE `ruoli_categorie_progetti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000034300

-- ruoli_documenti
-- tipologia: tabella standard
-- verifica: 2022-06-09 16:21 Chiara GDL
ALTER TABLE `ruoli_documenti`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`nome`, `id_genitore`),
	ADD KEY `id_genitore` (`id_genitore`), 
	ADD KEY `se_xml` (`se_xml`), 
	ADD KEY `se_documenti` (`se_documenti`), 
	ADD KEY `se_documenti_articoli` (`se_documenti_articoli`), 
	ADD KEY `se_conferma` (`se_conferma`), 
	ADD KEY `se_consuntivo` (`se_consuntivo`), 
	ADD KEY `se_evasione` (`se_evasione`), 
	ADD KEY `indice` (`id`,`id_genitore`,`nome`,`html_entity`,`font_awesome`,`se_xml`,`se_documenti`,`se_documenti_articoli`,`se_conferma`, `se_consuntivo`,  `se_evasione`);

-- | 030000034301

-- ruoli_documenti
-- tipologia: tabella standard
ALTER TABLE `ruoli_documenti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000034400

-- ruoli_file
-- tipologia: tabella standard
-- verifica: 2021-10-11 18:14 Fabio Mosti
ALTER TABLE `ruoli_file`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`nome`, `id_genitore`),
	ADD KEY `id_genitore` (`id_genitore`), 
	ADD KEY `se_anagrafica` (`se_anagrafica`), 
	ADD KEY `se_pagine` (`se_pagine`), 
	ADD KEY `se_template` (`se_template`), 
	ADD KEY `se_prodotti` (`se_prodotti`), 
	ADD KEY `se_articoli` (`se_articoli`), 
	ADD KEY `se_categorie_prodotti` (`se_categorie_prodotti`), 
	ADD KEY `se_notizie` (`se_notizie`), 
	ADD KEY `se_categorie_notizie` (`se_categorie_notizie`), 
	ADD KEY `se_risorse` (`se_risorse`), 
	ADD KEY `se_categorie_risorse` (`se_categorie_risorse`), 
	ADD KEY `se_mail` (`se_mail`), 
	ADD KEY `se_immobili` (`se_immobili`),
	ADD KEY `se_documenti` (`se_documenti`),
	ADD KEY `indice` (`id`,`id_genitore`,`nome`,`html_entity`,`font_awesome`,`se_anagrafica`,`se_pagine`,`se_template`,`se_prodotti`,`se_articoli`,`se_categorie_prodotti`,`se_notizie`,`se_categorie_notizie`,`se_risorse`,`se_categorie_risorse`);

-- | 030000034401

-- ruoli_file
-- tipologia: tabella standard
ALTER TABLE `ruoli_file` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000034600

-- ruoli_immagini
-- tipologia: tabella standard
-- verifica: 2021-10-11 18:47 Fabio Mosti
ALTER TABLE `ruoli_immagini`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`nome`, `id_genitore`),
	ADD KEY `id_genitore` (`id_genitore`), 
	ADD KEY `ordine_scalamento` (`ordine_scalamento`), 
	ADD KEY `se_anagrafica` (`se_anagrafica`), 
	ADD KEY `se_pagine` (`se_pagine`), 
	ADD KEY `se_prodotti` (`se_prodotti`), 
	ADD KEY `se_articoli` (`se_articoli`), 
	ADD KEY `se_categorie_prodotti` (`se_categorie_prodotti`), 
	ADD KEY `se_notizie` (`se_notizie`), 
	ADD KEY `se_categorie_notizie` (`se_categorie_notizie`), 
	ADD KEY `se_risorse` (`se_risorse`), 
	ADD KEY `se_categorie_risorse` (`se_categorie_risorse`),
	ADD KEY `se_immobili` (`se_immobili`), 
	ADD KEY `indice` (`id`,`id_genitore`,`ordine_scalamento`,`nome`,`html_entity`,`font_awesome`,`se_anagrafica`,`se_pagine`,`se_prodotti`,`se_articoli`,`se_categorie_prodotti`,`se_notizie`,`se_categorie_notizie`,`se_risorse`,`se_categorie_risorse`);

-- | 030000034601

-- ruoli_immagini
-- tipologia: tabella standard
ALTER TABLE `ruoli_immagini` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000034800

-- ruoli_indirizzi
-- tipologia: tabella standard
-- verifica: 2021-10-12 10:46 Fabio Mosti
ALTER TABLE `ruoli_indirizzi`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`nome`, `id_genitore`),
	ADD KEY `id_genitore` (`id_genitore`), 
	ADD KEY `se_sede_legale` (`se_sede_legale`), 
	ADD KEY `se_sede_operativa` (`se_sede_operativa`), 
	ADD KEY `se_residenza` (`se_residenza`), 
	ADD KEY `se_domicilio` (`se_domicilio`), 
	ADD KEY `indice` (`id`,`id_genitore`,`nome`, `html_entity`, `font_awesome`, `se_sede_legale`, `se_sede_operativa`, `se_residenza`, `se_domicilio`);

-- | 030000034801

-- ruoli_indirizzi
-- tipologia: tabella standard
ALTER TABLE `ruoli_indirizzi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000034850

-- ruoli_mail
ALTER TABLE `ruoli_mail`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`nome`, `id_genitore`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `indice` (`id`,`id_genitore`,`nome`);

-- | 030000034851

-- ruoli_mail
ALTER TABLE `ruoli_mail` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000034900

-- ruoli_matricole
-- tipologia: tabella standard
-- verifica: 2021-10-12 10:46 Fabio Mosti
ALTER TABLE `ruoli_matricole`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`nome`, `id_genitore`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `indice` (`id`,`id_genitore`,`nome`, `html_entity`, `font_awesome`);

-- | 030000034901

-- ruoli_matricole
-- tipologia: tabella standard
ALTER TABLE `ruoli_matricole` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000035000

-- ruoli_prodotti
-- tipologia: tabella standard
-- verifica: 2021-10-12 10:46 Fabio Mosti
ALTER TABLE `ruoli_prodotti`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`nome`, `id_genitore`),
	ADD KEY `id_genitore` (`id_genitore`), 
	ADD KEY `indice` (`id`,`id_genitore`,`nome`);

-- | 030000035001

-- ruoli_prodotti
-- tipologia: tabella standard
ALTER TABLE `ruoli_prodotti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000035100

-- ruoli_progetti
-- tipologia: tabella standard
-- verifica: 2022-04-20 10:45 chiara GDL
ALTER TABLE `ruoli_progetti`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`nome`, `id_genitore`),
	ADD KEY `se_sottoprogetto` (`se_sottoprogetto`),
	ADD KEY `se_proseguimento` (`se_proseguimento`),
	ADD KEY `se_sostituto` (`se_sostituto`), 
	ADD KEY `se_attesa` (`se_attesa`), 
	ADD KEY `indice` (`id`,`nome`,`se_sottoprogetto`,`se_proseguimento`,`se_sostituto`,`se_attesa`);

-- | 030000035101

-- ruoli_progetti
-- tipologia: tabella standard
ALTER TABLE `ruoli_progetti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000035200

-- ruoli_video
-- tipologia: tabella standard
-- verifica: 2021-10-11 18:47 Fabio Mosti
ALTER TABLE `ruoli_video`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`nome`, `id_genitore`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `se_anagrafica` (`se_anagrafica`), 
	ADD KEY `se_pagine` (`se_pagine`), 
	ADD KEY `se_prodotti` (`se_prodotti`), 
	ADD KEY `se_articoli` (`se_articoli`), 
	ADD KEY `se_categorie_prodotti` (`se_categorie_prodotti`), 
	ADD KEY `se_notizie` (`se_notizie`), 
	ADD KEY `se_categorie_notizie` (`se_categorie_notizie`), 
	ADD KEY `se_risorse` (`se_risorse`), 
	ADD KEY `se_categorie_risorse` (`se_categorie_risorse`), 
	ADD KEY `se_immobili` (`se_immobili`),
	ADD KEY `indice` (`id`,`id_genitore`,`nome`,`html_entity`,`font_awesome`,`se_anagrafica`,`se_pagine`,`se_prodotti`,`se_articoli`,`se_categorie_prodotti`,`se_notizie`,`se_categorie_notizie`,`se_risorse`,`se_categorie_risorse`);

-- | 030000035201

-- ruoli_video
-- tipologia: tabella standard
ALTER TABLE `ruoli_video` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000037000

-- settori
-- tipologia: tabella di supporto
-- verifica: 2021-10-11 10:53 Fabio Mosti
ALTER TABLE `settori`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`ateco`), 
	ADD KEY `id_genitore` (`id_genitore`), 
	ADD KEY `nome` (`nome`), 
	ADD KEY `ateco` (`ateco`), 
	ADD KEY `indice` (`id`,`id_genitore`,`nome`,`soprannome`,`ateco`);

-- | 030000037001

-- settori
-- tipologia: tabella di supporto
ALTER TABLE `settori` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000041000

-- sms_out
-- tipolgia: tabella gestita
-- verifica: 2021-10-12 11:58 Fabio Mosti
ALTER TABLE `sms_out`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_telefono` (`id_telefono`), 
	ADD KEY `timestamp_composizione` (`timestamp_composizione`), 
	ADD KEY `timestamp_invio` (`timestamp_invio`), 
	ADD KEY `token` (`token`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 	
	ADD KEY `indice` (`id`,`id_telefono`,`timestamp_composizione`,`timestamp_invio`,`token`,`tentativi`);

-- | 030000041001

-- sms_out
-- tipologia: tabella di supporto
ALTER TABLE `sms_out` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000041200

-- sms_sent
-- tipolgia: tabella gestita
-- verifica: 2021-10-12 11:58 Fabio Mosti
ALTER TABLE `sms_sent`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_telefono` (`id_telefono`), 
	ADD KEY `timestamp_composizione` (`timestamp_composizione`), 
	ADD KEY `timestamp_invio` (`timestamp_invio`), 
	ADD KEY `token` (`token`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 	
	ADD KEY `indice` (`id`,`id_telefono`,`timestamp_composizione`,`timestamp_invio`,`token`,`tentativi`);

-- | 030000041400

-- software
-- tipologia: tabella gestita
-- verifica: 2021-11-16 10:39 Chiara GDL
ALTER TABLE `software`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD UNIQUE KEY `codice` (`codice`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `id_articolo` (`id_articolo`),
	ADD KEY `json` (`json` (255)), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_genitore`,`id_articolo`,`nome`,`json` (255));

-- | 030000041401

-- software
-- tipologia: tabella di gestita
ALTER TABLE `software` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000042000

-- stati
-- tipologia: tabella standard
-- verifica: 2021-10-12 15:08 Fabio Mosti
ALTER TABLE `stati`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`codice_istat`),
	ADD UNIQUE KEY `unica_iso31661alpha2` (`iso31661alpha2`),
	ADD UNIQUE KEY `unica_iso31661alpha3` (`iso31661alpha3`),
	ADD KEY `id_continente` (`id_continente`),
	ADD KEY `indice` (`id`,`id_continente`,`nome`,`iso31661alpha2`,`iso31661alpha3`,`codice_istat`);

-- | 030000042001

-- stati
-- tipologia: tabella standard
ALTER TABLE `stati` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000042200

-- stati_lingue
-- tipologia: tabella standard
-- verifica: 2021-10-12 15:42 Fabio Mosti
ALTER TABLE `stati_lingue`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_stato`,`id_lingua`),
	ADD KEY `id_stato` (`id_stato`),
	ADD KEY `id_lingua` (`id_lingua`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `indice` (`id`,`id_stato`,`id_lingua`,`ordine`);

-- | 030000042201

-- stati_lingue
-- tipologia: tabella standard
ALTER TABLE `stati_lingue` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000042500

-- step
ALTER TABLE `step`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_funnel`,`nome`),
	ADD KEY `id_funnel` (`id_funnel`),
	ADD KEY `nome` (`nome`),
	ADD KEY `indice` (`id`,`id_funnel`,`ordine`,`nome`);

-- | 030000042501

-- step
-- tipologia: tabella standard
ALTER TABLE `step` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000043000

-- task
-- tipologia: tabella gestita
-- verifica: 2021-10-12 15:42 Fabio Mosti
ALTER TABLE `task`
	ADD PRIMARY KEY (`id`),
	ADD KEY `minuto` (`minuto`),
	ADD KEY `ora` (`ora`),
	ADD KEY `giorno_del_mese` (`giorno_del_mese`),
	ADD KEY `mese` (`mese`),
	ADD KEY `giorno_della_settimana` (`giorno_della_settimana`),
	ADD KEY `settimana` (`settimana`),
	ADD KEY `task` (`task`),
	ADD KEY `iterazioni` (`iterazioni`),
	ADD KEY `delay` (`delay`),
	ADD KEY `token` (`token`),
	ADD KEY `timestamp_esecuzione` (`timestamp_esecuzione`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`minuto`,`ora`,`giorno_del_mese`,`mese`,`giorno_della_settimana`,`settimana`,`task`,`iterazioni`,`delay`,`token`,`timestamp_esecuzione`);

-- | 030000043001

-- task
-- tipologia: tabella gestita
ALTER TABLE `task` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000043600

-- telefoni
-- tipologia: tabella gestita
-- verifica: 2021-10-15 10:46 Fabio Mosti
ALTER TABLE `telefoni`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_anagrafica`,`numero`),
	ADD KEY `id_anagrafica` (`id_anagrafica`),
	ADD KEY `id_tipologia` (`id_tipologia`),
	ADD KEY `numero` (`numero`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id_anagrafica`,`id_tipologia`,`numero`,`se_notifiche`);

-- | 030000043601

-- telefoni
-- tipologia: tabella gestita
ALTER TABLE `telefoni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000044000

-- template
-- tipologia: tabella gestita
-- verifica: 2021-10-15 12:36 Fabio Mosti
ALTER TABLE `template`
	ADD PRIMARY KEY (`id`),
  	ADD UNIQUE KEY `unica` (`ruolo`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  	ADD KEY `indice` (`ruolo`,`nome`,`tipo`,`latenza_invio`, `se_mail`,`se_sms`);

-- | 030000044001

-- template
-- tipologia: tabella gestita
ALTER TABLE `template` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000045000

-- testate
-- tipologia: tabella gestita
-- verifica: 2021-09-10 11:57 Fabio Mosti
ALTER TABLE `testate`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `nome` (`nome`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`nome`);

-- | 030000045001

-- testate
-- tipologia: tabella gestita
ALTER TABLE `testate` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000050000

-- tipologie_anagrafica
-- tipologia: tabella assistita
-- verifica: 2021-10-15 16:17 Fabio Mosti
ALTER TABLE `tipologie_anagrafica`
	ADD PRIMARY KEY (`id`),
  	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `nome` (`nome`),
	ADD KEY `se_persona_fisica` (`se_persona_fisica`),
	ADD KEY `se_persona_giuridica` (`se_persona_giuridica`),
	ADD KEY `se_pubblica_amministrazione` (`se_pubblica_amministrazione`),
	ADD KEY `se_ecommerce` (`se_ecommerce`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`,`se_persona_fisica`, `se_persona_giuridica`,`se_pubblica_amministrazione`);

-- | 030000050001

-- tipologie_anagrafica
-- tipologia: tabella assistita
ALTER TABLE `tipologie_anagrafica` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000050100

-- tipologie_annunci
ALTER TABLE `tipologie_annunci`
	ADD PRIMARY KEY (`id`),
  	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `nome` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`);

-- | 030000050101

-- tipologie_annunci
ALTER TABLE `tipologie_annunci` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000050200

-- tipologie_asset
ALTER TABLE `tipologie_asset`
	ADD PRIMARY KEY (`id`),
  	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `nome` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`);

-- | 030000050201

-- tipologie_asset
ALTER TABLE `tipologie_asset` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000050400

-- tipologie_attivita
-- tipologia: tabella assistita
-- verifica: 2021-10-15 16:17 Fabio Mosti
ALTER TABLE `tipologie_attivita`
	ADD PRIMARY KEY (`id`),
  	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD UNIQUE KEY `codice` (`codice`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `nome` (`nome`),
	ADD KEY `se_anagrafica` (`se_anagrafica`),
	ADD KEY `se_agenda` (`se_agenda`),
	ADD KEY `se_sistema` (`se_sistema`),
	ADD KEY `se_stampa` (`se_stampa`),
	ADD KEY `se_corsi` (`se_corsi`),
	ADD KEY `se_accesso` (`se_accesso`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`,`se_anagrafica`,`se_agenda`,`se_sistema`);

-- | 030000050401

-- tipologie_attivita
-- tipologia: tabella assistita
ALTER TABLE `tipologie_attivita` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000050450

-- tipologie_badge
-- tipologia: tabella assistita
ALTER TABLE `tipologie_badge`
	ADD PRIMARY KEY (`id`),
  	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `nome` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`);

-- | 030000050451

-- tipologie_badge
-- tipologia: tabella assistita
ALTER TABLE `tipologie_badge` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000050500

-- tipologie_banner
-- tipologia: tabella assistita
-- verifica: 2022-07-20 17:22 Chiara GDL
ALTER TABLE `tipologie_banner`
	ADD PRIMARY KEY (`id`),
  	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `nome` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`);

-- | 030000050501

-- tipologie_banner
-- tipologia: tabella assistita
ALTER TABLE `tipologie_banner` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000050600

-- tipologie_chiavi
-- tipologia: tabella assistita
-- verifica: 2021-11-15 11:07 Chiara GDL
ALTER TABLE `tipologie_chiavi`
	ADD PRIMARY KEY (`id`),
  	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `nome` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`);

-- | 030000050601

-- tipologie_chiavi
-- tipologia: tabella assistita
ALTER TABLE `tipologie_chiavi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000050800

-- tipologie_contatti
-- tipologia: tabella assistita
-- verifica: 2021-10-15 16:17 Fabio Mosti
ALTER TABLE `tipologie_contatti`
	ADD PRIMARY KEY (`id`),
  	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `nome` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`);

-- | 030000050801

-- tipologie_contatti
-- tipologia: tabella assistita
ALTER TABLE `tipologie_contatti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000050900

-- tipologie_contratti
-- tipologia: tabella gestita
-- verifica: 2022-02-21 11:47 Chiara GDL
ALTER TABLE `tipologie_contratti` 
	ADD PRIMARY KEY (`id`),
  	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
  	ADD KEY `ordine` (`ordine`),
  	ADD KEY `nome` (`nome`),
	ADD KEY `id_prodotto` (`id_prodotto`),
	ADD KEY `id_progetto` (`id_progetto`),
	ADD KEY `id_categoria_progetti` (`id_categoria_progetti`),
  	ADD KEY `se_tesseramento`(`se_tesseramento`),
  	ADD KEY `se_abbonamento`(`se_abbonamento`),
  	ADD KEY `se_iscrizione`(`se_iscrizione`),
  	ADD KEY `se_immobili`(`se_immobili`),
  	ADD KEY `se_acquisto`(`se_acquisto`),
  	ADD KEY `se_locazione`(`se_locazione`),
	ADD KEY `se_libero` (`se_libero`),
  	ADD KEY `se_prenotazione`(`se_prenotazione`),
  	ADD KEY `se_scalare`(`se_scalare`),
	ADD KEY `se_affiliazione`(`se_affiliazione`),
	ADD KEY `se_online`(`se_online`),
  	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
  	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  	ADD KEY `indice` (`id`, `ordine`, `nome`, `html_entity`, `font_awesome`, `se_iscrizione`, `se_tesseramento`, `se_abbonamento`, `se_immobili`, `se_acquisto`, `se_locazione`, `se_affiliazione`);

-- | 030000050901

-- tipologie_contratti
-- tipologia: tabella gestita
ALTER TABLE `tipologie_contratti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000051000

-- tipologie_corrispondenza
ALTER TABLE `tipologie_corrispondenza`
	ADD PRIMARY KEY (`id`),
  	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `nome` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  	ADD KEY `indice` (`id`,`id_genitore`,`nome`);

-- | 030000051001

-- tipologie_corrispondenza
ALTER TABLE `tipologie_corrispondenza` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000052600

-- tipologie_documenti
-- tipologia: tabella assistita
-- verifica: 2021-10-15 16:17 Fabio Mosti
ALTER TABLE `tipologie_documenti`
	ADD PRIMARY KEY (`id`),
  	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `nome` (`nome`),
	ADD KEY `sigla` (`sigla`),
	ADD KEY `numerazione`(`numerazione`),
	ADD KEY `se_fattura` (`se_fattura`),
	ADD KEY `se_nota_credito` (`se_nota_credito`),
	ADD KEY `se_nota_debito` (`se_nota_debito`),
	ADD KEY `se_trasporto` (`se_trasporto`),
	ADD KEY `se_pro_forma` (`se_pro_forma`),
	ADD KEY `se_offerta` (`se_offerta`),
	ADD KEY `se_ordine` (`se_ordine`),
	ADD KEY `se_ricevuta` (`se_ricevuta`),
	ADD KEY `se_ecommerce` (`se_ecommerce`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`,`se_fattura`,`se_nota_credito`,`se_nota_debito`,`se_trasporto`,`se_pro_forma`,`se_offerta`,`se_ordine`,`se_ricevuta`);

-- | 030000052601

-- tipologie_documenti
-- tipologia: tabella assistita
ALTER TABLE `tipologie_documenti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000052800

-- tipologie_edifici
-- tipologia: tabella di supporto
-- verifica: 2022-04-27 17:00 Chiara GDL
ALTER TABLE `tipologie_edifici`
	ADD PRIMARY KEY (`id`),
  	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `nome` (`nome`),
  	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
  	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`);

-- | 030000052801

-- tipologie_edifici
-- tipologia: tabella di supporto
ALTER TABLE `tipologie_edifici` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000052900

-- tipologie_immobili
-- tipologia: tabella di supporto
-- verifica: 2022-04-27 17:00 Chiara GDL
ALTER TABLE `tipologie_immobili`
	ADD PRIMARY KEY (`id`),
  	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `nome` (`nome`),
	ADD KEY  `se_residenziale` (`se_residenziale`),
  	ADD KEY `se_industriale` (`se_industriale`),
  	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
  	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`, `se_residenziale`, `se_industriale`);

-- | 030000052901

-- tipologie_immobili
-- tipologia: tabella di supporto
ALTER TABLE `tipologie_immobili` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000053000

-- tipologie_indirizzi
-- tipologia: tabella assistita
-- verifica: 2021-10-15 16:17 Fabio Mosti
ALTER TABLE `tipologie_indirizzi`
	ADD PRIMARY KEY (`id`),
  	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `nome` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`);

-- | 030000053001

-- tipologie_indirizzi
-- tipologia: tabella assistita
ALTER TABLE `tipologie_indirizzi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000053100

-- tipologie_istruzioni
ALTER TABLE `tipologie_istruzioni`
	ADD PRIMARY KEY (`id`),
  	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `nome` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`);

-- | 030000053101

-- tipologie_istruzioni
ALTER TABLE `tipologie_istruzioni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000053200

-- tipologie_licenze
-- tipologia: tabella assistita
-- verifica: 2021-11-15 11:07 Chiara GDL
ALTER TABLE `tipologie_licenze`
	ADD PRIMARY KEY (`id`),
  	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `nome` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`);

-- | 030000053201

-- tipologie_licenze
-- tipologia: tabella assistita
ALTER TABLE `tipologie_licenze` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000053300

-- tipologie_luoghi
-- tipologia: tabella assistita
-- verifica: 2022-02-21 15:30 Chiara GDL
ALTER TABLE `tipologie_luoghi`
	ADD PRIMARY KEY (`id`),
  	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `nome` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`);

-- | 030000053301

-- tipologie_luoghi
-- tipologia: tabella gestita
ALTER TABLE `tipologie_luoghi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000053400

-- tipologie_mastri
-- tipologia: tabella assistita
-- verifica: 2021-10-15 16:17 Fabio Mosti
ALTER TABLE `tipologie_mastri`
	ADD PRIMARY KEY (`id`),
  	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `nome` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`);

-- | 030000053401

-- tipologie_mastri
-- tipologia: tabella assistita
ALTER TABLE `tipologie_mastri` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000053800

-- tipologie_notizie
-- tipologia: tabella assistita
-- verifica: 2021-10-15 16:17 Fabio Mosti
ALTER TABLE `tipologie_notizie`
	ADD PRIMARY KEY (`id`),
  	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `nome` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`);

-- | 030000053801

-- tipologie_notizie
-- tipologia: tabella assistita
ALTER TABLE `tipologie_notizie` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000054000

-- tipologie_pagamenti
-- tipologia: tabella assistita
-- verifica: 2021-11-15 11:07 Chiara GDL
ALTER TABLE `tipologie_pagamenti`
	ADD PRIMARY KEY (`id`),
  	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `nome` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`);

-- | 030000054001

-- tipologie_pagamenti
-- tipologia: tabella assistita
ALTER TABLE `tipologie_pagamenti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000054100

-- tipologie_periodi
-- tipologia: tabella gestita
-- verifica: 2022-05-24 11:00 Chiara GDL
ALTER TABLE `tipologie_periodi`
	ADD PRIMARY KEY (`id`),
  	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `nome` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`);

-- | 030000054101

-- tipologie_periodi
-- tipologia: tabella gestita
ALTER TABLE `tipologie_periodi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000054200

-- tipologie_popup
-- tipologia: tabella assistita
-- verifica: 2021-10-15 16:17 Fabio Mosti
ALTER TABLE `tipologie_popup`
	ADD PRIMARY KEY (`id`),
  	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `nome` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`);

-- | 030000054201

-- tipologie_popup
-- tipologia: tabella assistita
ALTER TABLE `tipologie_popup` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000054600

-- tipologie_prodotti
-- tipologia: tabella assistita
-- verifica: 2021-10-15 16:17 Fabio Mosti
ALTER TABLE `tipologie_prodotti`
	ADD PRIMARY KEY (`id`),
  	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `nome` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`se_colori`,`se_taglie`,`se_dimensioni`,`se_imballo`,`se_spedizione`,`se_trasporto`,`se_prodotto`,`se_servizio`);

-- | 030000054601

-- tipologie_prodotti
-- tipologia: tabella assistita
ALTER TABLE `tipologie_prodotti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000055000

-- tipologie_progetti
-- tipologia: tabella assistita
-- verifica: 2021-10-15 16:17 Fabio Mosti
ALTER TABLE `tipologie_progetti`
	ADD PRIMARY KEY (`id`),
  	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `nome` (`nome`),
	ADD KEY `se_contratto` (`se_contratto`),
  	ADD KEY `se_pacchetto` (`se_pacchetto`),
    ADD KEY `se_progetto` (`se_progetto`),
    ADD KEY `se_consuntivo` (`se_consuntivo`),
    ADD KEY `se_forfait` (`se_forfait`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`);

-- | 030000055001

-- tipologie_progetti
-- tipologia: tabella assistita
ALTER TABLE `tipologie_progetti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000055400

-- tipologie_pubblicazioni
-- tipologia: tabella assistita
-- verifica: 2021-10-15 16:17 Fabio Mosti
ALTER TABLE `tipologie_pubblicazioni`
	ADD PRIMARY KEY (`id`),
  	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `nome` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`se_bozza`,`se_pubblicato`,`se_evidenza`);

-- | 030000055401

-- tipologie_pubblicazioni
-- tipologia: tabella assistita
ALTER TABLE `tipologie_pubblicazioni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000055700

-- tipologie_rinnovi
-- tipologia: tabella di supporto
-- verifica: 2022-04-29 17:45 Chiara GDL
ALTER TABLE `tipologie_rinnovi`
	ADD PRIMARY KEY (`id`),
  	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `nome` (`nome`),
	ADD KEY `se_tesseramenti` (`se_tesseramenti`),
  	ADD KEY `se_iscrizioni` (`se_iscrizioni`),
  	ADD KEY `se_abbonamenti` (`se_abbonamenti`),
  	ADD KEY `se_licenze` (`se_licenze`),
  	ADD KEY `se_contratti` (`se_contratti`),
  	ADD KEY `se_progetti`(`se_progetti`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`, `se_tesseramenti`,`se_iscrizioni`, `se_abbonamenti`, `se_licenze`, `se_contratti`, `se_progetti`);

-- | 030000055701

-- tipologie_rinnovi
-- tipologia: tabella di supporto
ALTER TABLE `tipologie_rinnovi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000055800

-- tipologie_risorse
-- tipologia: tabella assistita
-- verifica: 2021-10-15 16:17 Fabio Mosti
ALTER TABLE `tipologie_risorse`
	ADD PRIMARY KEY (`id`),
  	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `nome` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`);

-- | 030000055801

-- tipologie_risorse
-- tipologia: tabella assistita
ALTER TABLE `tipologie_risorse` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000056200

-- tipologie_telefoni
-- tipologia: tabella standard
-- verifica: 2021-10-15 16:17 Fabio Mosti
ALTER TABLE `tipologie_telefoni`
	ADD PRIMARY KEY (`id`),
  	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `nome` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`);

-- | 030000056201

-- tipologie_telefoni
-- tipologia: tabella assistita
ALTER TABLE `tipologie_telefoni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000056600

-- tipologie_todo
-- tipologia: tabella assistita
-- verifica: 2021-10-15 16:17 Fabio Mosti
ALTER TABLE `tipologie_todo`
	ADD PRIMARY KEY (`id`),
  	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `nome` (`nome`),
	ADD KEY `se_agenda` (`se_agenda`),
	ADD KEY `se_ticket` (`se_ticket`),
	ADD KEY `se_commerciale` (`se_commerciale`),
	ADD KEY `se_produzione` (`se_produzione`),
	ADD KEY `se_amministrazione` (`se_amministrazione`),
	ADD KEY `se_corsi` (`se_corsi`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`se_agenda`,`se_ticket`,`se_commerciale`,`se_produzione`,`se_amministrazione`);

-- | 030000056601

-- tipologie_todo
-- tipologia: tabella assistita
ALTER TABLE `tipologie_todo` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000056800

-- tipologie_url
-- tipologia: tabella assistita
-- verifica: 2021-11-09 12:45 Chiara GDL
ALTER TABLE `tipologie_url`
	ADD PRIMARY KEY (`id`),
  	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `nome` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`);

-- | 030000056801

-- tipologie_url
-- tipologia: tabella assistita
ALTER TABLE `tipologie_url` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000056900

-- tipologie_zone
-- tipologia: tabella gestita
-- verifica: 2022-06-16 16:40 Chiara GDL
ALTER TABLE `tipologie_zone`
	ADD PRIMARY KEY (`id`),
  	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `nome` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`);

-- | 030000056901

-- tipologie_zone
-- tipologia: tabella gestita
ALTER TABLE `tipologie_zone` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000060000

-- todo
-- tipologia: tabella gestita
-- verifica: 2021-10-15 16:17 Fabio Mosti
ALTER TABLE `todo`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`codice`),
	ADD KEY `id_tipologia` (`id_tipologia`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_cliente` (`id_cliente`), 
	ADD KEY `id_indirizzo` (`id_indirizzo`), 
	ADD KEY `id_luogo` (`id_luogo`), 
	ADD KEY `id_contatto` (`id_contatto`), 
	ADD KEY `id_progetto` (`id_progetto`), 
	ADD KEY `id_documento` (`id_documento`), 
	ADD KEY `id_documenti_articoli` (`id_documenti_articoli`), 
	ADD KEY `id_istruzione` (`id_istruzione`), 
	ADD KEY `id_pianificazione` (`id_pianificazione`), 
	ADD KEY `id_immobile` (`id_immobile`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`id_tipologia`,`id_anagrafica`,`id_cliente`,`id_indirizzo`,`id_luogo`,`data_scadenza`,`ora_scadenza`,`data_programmazione`,`ora_inizio_programmazione`,`ora_fine_programmazione`,`anno_programmazione`,`settimana_programmazione`,`data_chiusura`,`id_contatto`,`id_progetto`),
	ADD KEY `indice_pianificazione` (`id`,`id_tipologia`,`id_anagrafica`,`id_cliente`,`id_indirizzo`,`id_luogo`,`data_programmazione`,`ora_inizio_programmazione`,`ora_fine_programmazione`,`anno_programmazione`,`settimana_programmazione`,`id_contatto`,`id_progetto`,`id_pianificazione`),
	ADD KEY `indice_archiviazione` (`id`,`id_tipologia`,`id_anagrafica`,`id_cliente`,`id_indirizzo`,`id_luogo`,`data_programmazione`,`ora_inizio_programmazione`,`ora_fine_programmazione`,`anno_programmazione`,`settimana_programmazione`,`id_contatto`,`id_progetto`,`id_pianificazione`,`data_archiviazione`); 

-- | 030000060001

-- todo
-- tipologia: tabella gestita
ALTER TABLE `todo` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000060100

-- todo_matricole
-- tipologia: tabella gestita
-- verifica: 2022-04-27 15:00 Chiara GDL
ALTER TABLE `todo_matricole`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_todo`,`id_matricola`,`id_ruolo`), 
	ADD KEY `id_todo` (`id_todo`), 
	ADD KEY `id_matricola` (`id_matricola`), 
	ADD KEY `id_ruolo` (`id_ruolo`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_todo`,`id_matricola`,`ordine`,`id_ruolo`);

-- | 030000060101

-- todo_matricole
-- tipologia: tabella gestita
ALTER TABLE `todo_matricole` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000062000

-- udm
-- tipologia: tabella standard
-- verifica: 2021-10-19 13:02 Fabio Mosti
ALTER TABLE `udm`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_base`,`sigla`),
	ADD KEY `id_base` (`id_base`),
	ADD KEY `se_volume`(`se_volume`),
	ADD KEY `se_peso`(`se_peso`),
	ADD KEY `se_tempo`(`se_tempo`),
	ADD KEY `se_lunghezza`(`se_lunghezza`),
	ADD KEY `se_quantita`(`se_quantita`),
 	ADD KEY `se_area` (`se_area`),
	ADD KEY `indice` (`id`,`id_base`,`conversione`,`nome`,`sigla`,`se_tempo`,`se_lunghezza`,`se_volume`,`se_quantita`);

-- | 030000062001

-- udm
-- tipologia: tabella di supporto
ALTER TABLE `udm` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000062600

-- url
-- tipologia: tabella gestita
-- verifica: 2021-10-15 16:17 Fabio Mosti
ALTER TABLE `url`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_tipologia`,`id_anagrafica`,`url`),
	ADD KEY `id_tipologia` (`id_tipologia`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `url` (`url`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`id_tipologia`,`id_anagrafica`,`url`); 

-- | 030000062601

-- url
-- tipologia: tabella di supporto
ALTER TABLE `url` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000062900

-- valutazioni
-- tipologia: tabella gestita
-- verifica: 2022-04-28 Chiara GDL
ALTER TABLE `valutazioni`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_anagrafica`,`id_immobile`,`timestamp_valutazione`),
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_matricola` (`id_matricola`), 
	ADD KEY `id_immobile` (`id_immobile`), 
	ADD KEY `id_condizione` (`id_condizione`), 
	ADD KEY `id_disponibilita` (`id_disponibilita`), 
	ADD KEY `id_classe_energetica` (`id_classe_energetica`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`id_matricola`,`id_anagrafica`,`id_immobile`, `id_condizione`, `id_disponibilita`, `id_classe_energetica`); 

-- | 030000062901

-- valutazioni
-- tipologia: tabella gestita
ALTER TABLE `valutazioni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000062950

-- valutazioni_certificazioni
-- tipologia: tabella gestita
-- verifica: 2022-05-23 Chiara GDL
ALTER TABLE `valutazioni_certificazioni`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_valutazione`,`id_certificazione`, `codice`),
	ADD KEY `id_certificazione` (`id_certificazione`), 
	ADD KEY `id_valutazione` (`id_valutazione`), 
	ADD KEY `id_emittente` (`id_emittente`), 
	ADD KEY `nome` (`nome`), 
	ADD KEY `codice` (`codice`),
	ADD KEY `data_emissione` (`data_emissione`), 
	ADD KEY `data_scadenza` (`data_scadenza`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_valutazione`,`id_certificazione`,`codice`, `id_emittente`, `nome`, `data_emissione`, `data_scadenza`);

-- | 030000062951

-- valutazioni_certificazioni
-- tipologia: tabella gestita
ALTER TABLE `valutazioni_certificazioni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000063000

-- valute
-- tipologia: tabella di supporto
-- verifica: 2021-10-19 13:21 Fabio Mosti
ALTER TABLE `valute`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`iso4217`),
	ADD KEY `indice` (`id`,`iso4217`,`html_entity`,`utf8`);

-- | 030000063001

-- valute
-- tipologia: tabella di supporto
ALTER TABLE `valute` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000065000

-- video
-- tipologia: tabella gestita
-- verifica: 2021-10-19 15:31 Fabio Mosti
ALTER TABLE `video`
 	ADD PRIMARY KEY (`id`), 
 	ADD UNIQUE KEY `unica_anagrafica` (`id_anagrafica`,`id_ruolo`,`id_lingua`,`path`), 
 	ADD UNIQUE KEY `unica_pagina` (`id_pagina`,`id_ruolo`,`id_lingua`,`path`), 
 	ADD UNIQUE KEY `unica_file` (`id_file`,`id_ruolo`,`id_lingua`,`path`), 
 	ADD UNIQUE KEY `unica_prodotto` (`id_prodotto`,`id_ruolo`,`id_lingua`,`path`), 
 	ADD UNIQUE KEY `unica_articolo` (`id_articolo`,`id_ruolo`,`id_lingua`,`path`), 
 	ADD UNIQUE KEY `unica_categoria_prodotti` (`id_categoria_prodotti`,`id_ruolo`,`id_lingua`,`path`), 
 	ADD UNIQUE KEY `unica_risorse` (`id_risorsa`,`id_ruolo`,`id_lingua`,`path`), 
 	ADD UNIQUE KEY `unica_categoria_risorse` (`id_categoria_risorse`,`id_ruolo`,`id_lingua`,`path`), 
 	ADD UNIQUE KEY `unica_notizie` (`id_notizia`,`id_ruolo`,`id_lingua`,`path`), 
 	ADD UNIQUE KEY `unica_categoria_notizie` (`id_categoria_notizie`,`id_ruolo`,`id_lingua`,`path`), 
 	ADD KEY `id_anagrafica` (`id_anagrafica`), 
 	ADD KEY `id_pagina` (`id_pagina`), 
 	ADD KEY `id_file` (`id_file`), 
 	ADD KEY `id_prodotto` (`id_prodotto`), 
 	ADD KEY `id_articolo` (`id_articolo`), 
 	ADD KEY `id_categoria_prodotti` (`id_categoria_prodotti`), 
 	ADD KEY `id_risorsa` (`id_risorsa`), 
 	ADD KEY `id_categoria_risorse` (`id_categoria_risorse`), 
 	ADD KEY `id_notizia` (`id_notizia`), 
	ADD KEY `id_annuncio` (`id_annuncio`),
 	ADD KEY `id_categoria_notizie` (`id_categoria_notizie`),
	ADD KEY `id_categoria_annunci` (`id_categoria_annunci`), 
 	ADD KEY `id_lingua` (`id_lingua`), 
 	ADD KEY `id_ruolo` (`id_ruolo`), 
	ADD KEY `id_progetto` (`id_progetto`),
	ADD KEY `id_categoria_progetti` (`id_categoria_progetti`),
	ADD KEY `id_indirizzo` (`id_indirizzo`), 
	ADD KEY `id_edificio` (`id_edificio`), 
	ADD KEY `id_immobile` (`id_immobile`),
	ADD KEY `id_valutazione` (`id_valutazione`), 
 	ADD KEY `id_embed` (`id_embed`), 
 	ADD KEY `path` (`path`), 
 	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
 	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_lingua`,`id_ruolo`,`path`,`id_embed`,`codice_embed`,`embed_custom`,`target`,`orientamento`,`ratio`,`nome`,`ordine`),
	ADD KEY `indice_anagrafica` (`id`,`id_anagrafica`,`id_lingua`,`id_ruolo`,`path`,`id_embed`,`codice_embed`,`embed_custom`,`target`,`orientamento`,`ratio`,`nome`,`ordine`),
	ADD KEY `indice_pagine` (`id`,`id_pagina`,`id_lingua`,`id_ruolo`,`path`,`id_embed`,`codice_embed`,`embed_custom`,`target`,`orientamento`,`ratio`,`nome`,`ordine`),
	ADD KEY `indice_file` (`id`,`id_file`,`id_lingua`,`id_ruolo`,`path`,`id_embed`,`codice_embed`,`embed_custom`,`target`,`orientamento`,`ratio`,`nome`,`ordine`),
	ADD KEY `indice_prodotti` (`id`,`id_prodotto`,`id_lingua`,`id_ruolo`,`path`,`id_embed`,`codice_embed`,`embed_custom`,`target`,`orientamento`,`ratio`,`nome`,`ordine`),
	ADD KEY `indice_articoli` (`id`,`id_articolo`,`id_lingua`,`id_ruolo`,`path`,`id_embed`,`codice_embed`,`embed_custom`,`target`,`orientamento`,`ratio`,`nome`,`ordine`),
	ADD KEY `indice_categorie_prodotti` (`id`,`id_categoria_prodotti`,`id_lingua`,`id_ruolo`,`path`,`id_embed`,`codice_embed`,`embed_custom`,`target`,`orientamento`,`ratio`,`nome`,`ordine`),
	ADD KEY `indice_risorse` (`id`,`id_risorsa`,`id_lingua`,`id_ruolo`,`path`,`id_embed`,`codice_embed`,`embed_custom`,`target`,`orientamento`,`ratio`,`nome`,`ordine`),
	ADD KEY `indice_categorie_risorse` (`id`,`id_categoria_risorse`,`id_lingua`,`id_ruolo`,`path`,`id_embed`,`codice_embed`,`embed_custom`,`target`,`orientamento`,`ratio`,`nome`,`ordine`),
	ADD KEY `indice_notizie` (`id`,`id_notizia`,`id_lingua`,`id_ruolo`,`path`,`id_embed`,`codice_embed`,`embed_custom`,`target`,`orientamento`,`ratio`,`nome`,`ordine`),
	ADD KEY `indice_categorie_notizie` (`id`,`id_categoria_notizie`,`id_lingua`,`id_ruolo`,`path`,`id_embed`,`codice_embed`,`embed_custom`,`target`,`orientamento`,`ratio`,`nome`,`ordine`);

-- | 030000065001

-- video
-- tipologia: tabella gestita
ALTER TABLE `video` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000100000

-- zone
-- tipologia: tabella gestita
-- verifica: 2022-06-16 13:16 Chiara GDL
ALTER TABLE `zone`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`nome`, `id_genitore`),
    ADD KEY `id_tipologia` (`id_tipologia`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `indice` (`id`,`id_genitore`,`nome`, `id_tipologia`);
    
-- | 030000100001

-- zone
-- tipologia: tabella gestita
ALTER TABLE `zone` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000100100

-- zone_cap
-- tipologia: tabella gestita
-- verifica: 2022-06-16 13:16 Chiara GDL
ALTER TABLE `zone_cap`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_zona`,`cap`), 
	ADD KEY `id_zona` (`id_zona`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`ordine`, `id_zona`,`cap`);

-- | 030000100101

-- zone_cap
-- tipologia: tabella gestita
ALTER TABLE `zone_cap` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000100200

-- zone_indirizzi
-- tipologia: tabella gestita
-- verifica: 2022-06-16 13:16 Chiara GDL
ALTER TABLE `zone_indirizzi`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_zona`,`id_indirizzo`), 
	ADD KEY `id_indirizzo` (`id_indirizzo`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `ordine` (`ordine`),	
	ADD KEY `indice` (`id`,`ordine`, `id_zona`,`id_indirizzo`);

-- | 030000100201

-- zone_indirizzi
-- tipologia: tabella gestita
ALTER TABLE `zone_indirizzi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000100300

-- zone_provincie
-- tipologia: tabella gestita
-- verifica: 2022-06-16 13:16 Chiara GDL
ALTER TABLE `zone_provincie`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_zona`,`id_provincia`), 
	ADD KEY `id_provincia` (`id_provincia`), 
	ADD KEY `ordine` (`ordine`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),	
	ADD KEY `indice` (`id`,`id_zona`,`id_provincia`,`ordine`);

-- | 030000100301

-- zone_provincie
-- tipologia: tabella gestita
ALTER TABLE `zone_provincie` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000100400

-- zone_stati
-- tipologia: tabella gestita
-- verifica: 2022-06-16 13:16 Chiara GDL
ALTER TABLE `zone_stati`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_zona`,`id_stato`), 
	ADD KEY `ordine` (`ordine`),	
	ADD KEY `id_stato` (`id_stato`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),	
	ADD KEY `indice` (`id`,`id_zona`,`id_stato`,`ordine`);

-- | 030000100401

-- zone_stati
-- tipologia: tabella gestita
ALTER TABLE `zone_stati` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | FINE FILE
