--
-- INDICI
-- questo file contiene le query per la creazione degli indici delle tabelle
-- 
-- TODO documentare
--

-- | 030000000100

-- account
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
ALTER TABLE `account` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000000120

-- account_gruppi
ALTER TABLE `account_gruppi`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_account`,`id_gruppo`),
	ADD KEY `id_account` (`id_account`),
	ADD KEY `id_gruppo` (`id_gruppo`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_account`,`id_gruppo`,`ordine`);

-- | 030000000121

-- account_gruppi
ALTER TABLE `account_gruppi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000000130

-- account_gruppi_attribuzione
ALTER TABLE `account_gruppi_attribuzione`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_account`,`id_gruppo`,`entita`), 
	ADD KEY `id_account` (`id_account`), 
	ADD KEY `id_gruppo` (`id_gruppo`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`id_account`,`id_gruppo`,`ordine`,`entita`);

-- | 030000000131

-- account_gruppi_attribuzione
ALTER TABLE `account_gruppi_attribuzione` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000000400

-- anagrafica
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
ALTER TABLE `anagrafica` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;	

-- | 030000000500

-- anagrafica_categorie
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
ALTER TABLE `anagrafica_categorie` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000000900

-- anagrafica_indirizzi
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
ALTER TABLE `anagrafica_indirizzi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000001300

-- articoli
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
	ADD KEY `id_udm_capacita` (`id_udm_capacita`),
	ADD KEY `id_udm_durata` (`id_udm_durata`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);

-- | 030000001301

-- articoli
ALTER TABLE `articoli` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;


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
ALTER TABLE `attivita` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000002900

-- caratteristiche
ALTER TABLE `caratteristiche`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);

-- | 030000002901

-- caratteristiche
ALTER TABLE `caratteristiche` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000003050

-- carrelli_articoli
ALTER TABLE `carrelli_articoli`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_carrello` (`id_carrello`),
	ADD KEY `id_articolo` (`id_articolo`),
	ADD KEY `id_listino` (`id_listino`),
	ADD KEY `id_iva` (`id_iva`),
	ADD KEY `id_pagamento` (`id_pagamento`),
	ADD KEY `id_rinnovo` (`id_rinnovo`),
	ADD KEY `id_mastro_provenienza` (`id_mastro_provenienza`),
	ADD KEY `id_coupon` (`id_coupon`),
	ADD KEY `id_account_evasione` (`id_account_evasione`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);

-- | 030000003051

-- carrelli_articoli
ALTER TABLE `carrelli_articoli` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000003100

-- categorie_anagrafica
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
ALTER TABLE `categorie_anagrafica` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000003700

-- categorie-notizie
ALTER TABLE `categorie_notizie`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_genitore` (`id_genitore`), 
	ADD KEY `id_sito` (`id_sito`), 
	ADD KEY `id_pagina` (`id_pagina`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`); 

-- | 030000003701

-- categorie-notizie
ALTER TABLE `categorie_notizie` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000003900

-- categorie_prodotti
ALTER TABLE `categorie_prodotti`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_genitore` (`id_genitore`), 
	ADD KEY `id_sito` (`id_sito`), 
	ADD KEY `id_pagina` (`id_pagina`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);

-- | 030000003901

-- categorie_prodotti
ALTER TABLE `categorie_prodotti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000004300

-- categorie_progetti
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
ALTER TABLE `categorie_progetti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000005050

-- colli
ALTER TABLE `colli`
	ADD PRIMARY KEY (`id`),
    ADD KEY `id_documento` (`id_documento`),	
    ADD KEY `id_udm_dimensioni` (`id_udm_dimensioni`),	
    ADD KEY `id_udm_peso` (`id_udm_peso`),	
    ADD KEY `id_udm_volume` (`id_udm_volume`),	
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);

-- | 030000005051

-- colli
ALTER TABLE `colli` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000005300

-- comuni
ALTER TABLE `comuni`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica_istat` (`codice_istat`),
	ADD UNIQUE KEY `unica_catasto` (`codice_catasto`),
	ADD KEY `id_provincia` (`id_provincia`),
	ADD KEY `indice` (`id`,`id_provincia`, `nome`,`codice_istat`,`codice_catasto`);

-- | 030000005301

-- comuni
ALTER TABLE `comuni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000006000

-- condizioni_pagamento
ALTER TABLE `condizioni_pagamento`
	ADD PRIMARY KEY (`id`);

-- | 030000006001

-- condizioni_pagamento
ALTER TABLE `condizioni_pagamento` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000006400

-- consensi
ALTER TABLE `consensi`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `nome` (`nome`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`nome`,`id_account_inserimento`,`id_account_aggiornamento`);

-- | 030000006500

-- consensi_moduli
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
ALTER TABLE `consensi_moduli` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000006700

-- contatti
ALTER TABLE `contatti`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_tipologia` (`id_tipologia`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_inviante` (`id_inviante`),
	ADD KEY `id_ranking` (`id_ranking`),	
	ADD KEY `id_sito` (`id_sito`),	
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
ALTER TABLE `contatti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000006900

-- contenuti
ALTER TABLE `contenuti`
	ADD PRIMARY KEY (`id`), 
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
	ADD KEY `id_categoria_annunci` (`id_categoria_annunci`),
	ADD KEY `id_template` (`id_template`),
	ADD KEY `id_mailing` (`id_mailing`),
	ADD KEY `id_colore` (`id_colore`),
	ADD KEY `id_progetto` (`id_progetto`),
	ADD KEY `id_categoria_progetti` (`id_categoria_progetti`),
	ADD KEY `id_banner` (`id_banner`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);

-- | 030000006901

-- contenuti
ALTER TABLE `contenuti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;


-- | 030000007100

-- continenti
ALTER TABLE `continenti`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`nome`),
	ADD KEY `indice` (`id`,`codice`,`nome`);

-- | 030000007101

-- continenti
ALTER TABLE `continenti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000007200

-- contratti
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
ALTER TABLE `contratti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000007800

-- corrispondenza
ALTER TABLE `corrispondenza`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_tipologia`,`id_peso`,`id_formato`,`id_mittente`,`id_organizzazione_mittente`,`id_commesso`),
	ADD UNIQUE KEY `codice` ( `codice` ),
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
ALTER TABLE `coupon`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_anagrafica` (`id_anagrafica`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);

-- | 030000008001

-- coupon
ALTER TABLE `coupon` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000009800

-- documenti
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
ALTER TABLE `documenti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000010000

-- documenti_articoli
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
	ADD KEY `importo_lordo_finale` (`importo_lordo_finale`),
	ADD KEY `indice` (`id`,`id_genitore`,`id_tipologia`,`ordine`,`id_documento`,`data`,`id_emittente`,`id_destinatario`,`id_reparto`,`id_progetto`,`id_todo`,`id_attivita`,`id_articolo`,`id_mastro_provenienza`,`id_mastro_destinazione`),
	ADD KEY `indice_progetto_quantita` (`id`,`id_genitore`,`id_tipologia`,`ordine`,`id_documento`,`data`,`id_emittente`,`id_destinatario`,`id_reparto`,`id_progetto`,`id_articolo`,`id_mastro_provenienza`,`id_mastro_destinazione`,`id_udm`,`quantita`),
	ADD KEY `indice_progetto_valore` (`id`,`id_genitore`,`id_tipologia`,`ordine`,`id_documento`,`data`,`id_emittente`,`id_destinatario`,`id_reparto`,`id_progetto`,`id_articolo`,`id_mastro_provenienza`,`id_mastro_destinazione`,`id_listino`,`importo_netto_totale`,`id_matricola`),
	ADD KEY `indice_todo_quantita` (`id`,`id_genitore`,`id_tipologia`,`ordine`,`id_documento`,`data`,`id_emittente`,`id_destinatario`,`id_reparto`,`id_todo`,`id_articolo`,`id_mastro_provenienza`,`id_mastro_destinazione`,`id_udm`,`quantita`),
	ADD KEY `indice_todo_valore` (`id`,`id_genitore`,`id_tipologia`,`ordine`,`id_documento`,`data`,`id_emittente`,`id_destinatario`,`id_reparto`,`id_todo`,`id_articolo`,`id_mastro_provenienza`,`id_mastro_destinazione`,`id_listino`,`importo_netto_totale`,`id_matricola`),
	ADD KEY `indice_attivita_quantita` (`id`,`id_genitore`,`id_tipologia`,`ordine`,`id_documento`,`data`,`id_emittente`,`id_destinatario`,`id_reparto`,`id_attivita`,`id_articolo`,`id_mastro_provenienza`,`id_mastro_destinazione`,`id_udm`,`quantita`),
	ADD KEY `indice_attivita_valore` (`id`,`id_genitore`,`id_tipologia`,`ordine`,`id_documento`,`data`,`id_emittente`,`id_destinatario`,`id_reparto`,`id_attivita`,`id_articolo`,`id_mastro_provenienza`,`id_mastro_destinazione`,`id_listino`,`importo_netto_totale`,`id_matricola`);

-- | 030000010001

-- documenti_articoli
ALTER TABLE `documenti_articoli` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000015000

-- file
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
ALTER TABLE `file` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000015200

-- gruppi
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
ALTER TABLE `gruppi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000015400

-- iban
ALTER TABLE `iban`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`); 

-- | 030000015401

-- iban
ALTER TABLE `iban` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000015600

-- immagini
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
ALTER TABLE `immagini` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000015800

-- indirizzi
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
ALTER TABLE `indirizzi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000016200

-- job
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
ALTER TABLE `job` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000016800

-- lingue
ALTER TABLE `lingue`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica_nome` (`nome`),
	ADD UNIQUE KEY `unica_iso6391alpha2` (`iso6391alpha2`),
	ADD UNIQUE KEY `unica_iso6393alpha3` (`iso6393alpha3`),
	ADD UNIQUE KEY `unica_ietf` (`ietf`),
	ADD KEY `indice` (`id`,`nome`,`iso6391alpha2`,`iso6393alpha3`,`ietf`);

-- | 030000016801

-- lingue
ALTER TABLE `lingue` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000017200

-- listini
ALTER TABLE `listini`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_genitore` (`id_genitore`), 
	ADD KEY `id_tipologia` (`id_tipologia`), 
	ADD KEY `id_valuta` (`id_valuta`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`); 

-- | 030000017201

-- listini
ALTER TABLE `listini` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000018200

-- macro
ALTER TABLE `macro`
	ADD PRIMARY KEY (`id`),
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
	ADD KEY `id_progetto` (`id_progetto`),
	ADD KEY `id_categoria_progetti` (`id_categoria_progetti`),
	ADD KEY `id_pianificazione` (`id_pianificazione`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);

-- | 030000018201

-- macro
ALTER TABLE `macro` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000018600

-- mail
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
ALTER TABLE `mail` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000018800

-- mail_out
ALTER TABLE `mail_out`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_mail` (`id_mail`),
	ADD KEY `id_mailing` (`id_mailing`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`); 

-- | 030000018801

-- mail_out
ALTER TABLE `mail_out` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000018900

-- mail_sent
ALTER TABLE `mail_sent`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_mail` (`id_mail`),
	ADD KEY `id_mailing` (`id_mailing`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);

-- | 030000018901

-- mail_sent
ALTER TABLE `mail_sent` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000020200

-- marchi
ALTER TABLE `marchi`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_produttore` (`id_produttore`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);

-- | 030000020201

-- marchi
ALTER TABLE `marchi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000020600

-- mastri
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
ALTER TABLE `mastri` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000021000

-- matricole
ALTER TABLE `matricole`
 	ADD PRIMARY KEY (`id`),
	ADD KEY `id_marchio` (`id_marchio`),
	ADD KEY `id_produttore` (`id_produttore`),
	ADD KEY `id_articolo` (`id_articolo`),
 	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
 	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);

-- | 030000021001

-- matricole
ALTER TABLE `matricole` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000021600

-- menu
ALTER TABLE `menu`
 	ADD PRIMARY KEY (`id`),
	ADD KEY `id_lingua` (`id_lingua`),
	ADD KEY `id_pagina` (`id_pagina`),
	ADD KEY `id_categoria_prodotti` (`id_categoria_prodotti`),
	ADD KEY `id_categoria_notizie` (`id_categoria_notizie`),
	ADD KEY `id_categoria_annunci` (`id_categoria_annunci`),
	ADD KEY `id_categoria_risorse` (`id_categoria_risorse`),
	ADD KEY `id_categoria_progetti` (`id_categoria_progetti`),
 	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
 	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);

-- | 030000021601

-- menu
ALTER TABLE `menu` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000021800

-- metadati
ALTER TABLE `metadati`
 	ADD PRIMARY KEY (`id`),
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
	ADD KEY `id_tipologia_corrispondenza` (`id_tipologia_corrispondenza`),
	ADD KEY `id_peso_tipologie_corrispondenza` (`id_peso_tipologie_corrispondenza`),
	ADD KEY `id_stato` (`id_stato`),
 	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
 	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);

-- | 030000021801

-- metadati
ALTER TABLE `metadati` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000021900

-- modalita_pagamento
ALTER TABLE `modalita_pagamento`
 	ADD PRIMARY KEY (`id`);

-- | 030000021901

-- modalita_pagamento
ALTER TABLE `modalita_pagamento` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000022000

-- notizie
ALTER TABLE `notizie`
 	ADD PRIMARY KEY (`id`),
	ADD KEY `id_tipologia` (`id_tipologia`),
	ADD KEY `id_sito` (`id_sito`),
 	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
 	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);

-- | 030000022001

-- notizie
ALTER TABLE `notizie` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000022200

-- notizie_categorie
ALTER TABLE `notizie_categorie`
 	ADD PRIMARY KEY (`id`),
	ADD KEY `id_notizia` (`id_notizia`),
	ADD KEY `id_annuncio` (`id_annuncio`),
	ADD KEY `id_categoria` (`id_categoria`),
 	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
 	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);

-- | 030000022201

-- notizie_categorie
ALTER TABLE `notizie_categorie` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000022800

-- organizzazioni
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
ALTER TABLE `organizzazioni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000023100

-- pagamenti
ALTER TABLE `pagamenti`
 	ADD PRIMARY KEY (`id`),
	ADD KEY `id_tipologia` (`id_tipologia`),
	ADD KEY `id_modalita_pagamento` (`id_modalita_pagamento`),
	ADD KEY `id_documento` (`id_documento`),
	ADD KEY `id_rinnovo` (`id_rinnovo`),
	ADD KEY `id_carrelli_articoli` (`id_carrelli_articoli`),
	ADD KEY `id_creditore` (`id_creditore`),
	ADD KEY `id_debitore` (`id_debitore`),
	ADD KEY `id_mastro_provenienza` (`id_mastro_provenienza`),
	ADD KEY `id_mastro_destinazione` (`id_mastro_destinazione`),
	ADD KEY `id_iban` (`id_iban`),
	ADD KEY `id_coupon` (`id_coupon`),
	ADD KEY `id_listino` (`id_listino`),
	ADD KEY `id_pianificazione` (`id_pianificazione`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);

-- | 030000023101

-- pagamenti
ALTER TABLE `pagamenti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000023200

-- pagine
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
ALTER TABLE `pagine` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000023600

-- periodicita
ALTER TABLE `periodicita`
	ADD PRIMARY KEY (`id`);

-- | 030000023601

-- periodicita
ALTER TABLE `periodicita` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000025000

-- prezzi
ALTER TABLE `prezzi`
 	ADD PRIMARY KEY (`id`),
	ADD KEY `id_prodotto` (`id_prodotto`),
	ADD KEY `id_articolo` (`id_articolo`),
	ADD KEY `id_listino` (`id_listino`),
	ADD KEY `id_iva` (`id_iva`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);

-- | 030000025001

-- prezzi
ALTER TABLE `prezzi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000026000

-- prodotti
ALTER TABLE `prodotti`
 	ADD PRIMARY KEY (`id`),
	ADD KEY `id_tipologia` (`id_tipologia`),
	ADD KEY `id_sito` (`id_sito`),
	ADD KEY `id_pagina` (`id_pagina`),
	ADD KEY `id_marchio` (`id_marchio`),
	ADD KEY `id_produttore` (`id_produttore`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);

-- | 030000026001

-- prodotti
ALTER TABLE `prodotti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000026400

-- prodotti_categorie
ALTER TABLE `prodotti_categorie`
 	ADD PRIMARY KEY (`id`),
	ADD KEY `id_prodotto` (`id_prodotto`),
	ADD KEY `id_categoria` (`id_categoria`),
	ADD KEY `id_ruolo` (`id_ruolo`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);

-- | 030000026401

-- prodotti_categorie
ALTER TABLE `prodotti_categorie` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000027000

-- progetti
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

-- | 030000027001

-- progetti
ALTER TABLE `progetti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000027400

-- progetti_categorie
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
ALTER TABLE `progetti_categorie` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000028000

-- provincie
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
ALTER TABLE `provincie` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000028400

-- pubblicazioni
ALTER TABLE `pubblicazioni`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_tipologia` (`id_tipologia`),
	ADD KEY `id_pagina` (`id_pagina`),
	ADD KEY `id_popup` (`id_popup`),
	ADD KEY `id_prodotto` (`id_prodotto`),
	ADD KEY `id_articolo` (`id_articolo`),
	ADD KEY `id_categoria_prodotti` (`id_categoria_prodotti`),
	ADD KEY `id_notizia` (`id_notizia`),
	ADD KEY `id_annuncio` (`id_annuncio`),
	ADD KEY `id_categoria_notizie` (`id_categoria_notizie`),
	ADD KEY `id_categoria_annunci` (`id_categoria_annunci`),
	ADD KEY `id_risorsa` (`id_risorsa`),
	ADD KEY `id_categoria_risorse` (`id_categoria_risorse`),
	ADD KEY `id_progetto` (`id_progetto`),
	ADD KEY `id_categoria_progetti` (`id_categoria_progetti`),
	ADD KEY `id_banner` (`id_banner`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);
	
-- | 030000028401

-- pubblicazioni
ALTER TABLE `pubblicazioni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000028600

-- ranking
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
ALTER TABLE `ranking` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000028900

-- recensioni
ALTER TABLE `recensioni`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_lingua` (`id_lingua`),
	ADD KEY `id_categoria_prodotti` (`id_categoria_prodotti`),
	ADD KEY `id_prodotto` (`id_prodotto`),
	ADD KEY `id_articolo` (`id_articolo`),
	ADD KEY `id_risorsa` (`id_risorsa`),
	ADD KEY `id_categoria_notizie` (`id_categoria_notizie`),
	ADD KEY `id_notizia` (`id_notizia`),
	ADD KEY `id_pagina` (`id_pagina`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);

-- | 030000028901

-- recensioni
ALTER TABLE `recensioni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000029400

-- redirect
ALTER TABLE `redirect`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_sito`,`sorgente`),
	ADD KEY `id_sito` (`id_sito`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`codice_stato_http`,`sorgente`,`destinazione`);

-- | 030000029401

-- redirect
ALTER TABLE `redirect` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000029800

-- regimi
ALTER TABLE `regimi`
	ADD PRIMARY KEY (`id`);

-- | 030000029801

-- regimi
ALTER TABLE `regimi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000030200

-- regioni
ALTER TABLE `regioni`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`codice_istat`),
	ADD UNIQUE KEY `unica_nome` (`id_stato`,`nome`),
	ADD KEY `id_stato` (`id_stato`),
	ADD KEY `indice` (`id`,`id_stato`,`nome`,`codice_istat`);

-- | 030000030201

-- regioni
ALTER TABLE `regioni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000030400

-- relazioni_documenti
ALTER TABLE `relazioni_documenti`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_documento` (`id_documento`),
	ADD KEY `id_documento_collegato` (`id_documento_collegato`),
	ADD KEY `id_ruolo` (`id_ruolo`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);

-- | 030000030401

-- relazioni_documenti
ALTER TABLE `relazioni_documenti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000034300

-- ruoli_documenti
ALTER TABLE `ruoli_documenti`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_genitore` (`id_genitore`);

-- | 030000034301

-- ruoli_documenti
ALTER TABLE `ruoli_documenti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000034400

-- ruoli_file
ALTER TABLE `ruoli_file`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_genitore` (`id_genitore`);

-- | 030000034401

-- ruoli_file
ALTER TABLE `ruoli_file` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000034600

-- ruoli_immagini
ALTER TABLE `ruoli_immagini`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_genitore` (`id_genitore`);

-- | 030000034601

-- ruoli_immagini
ALTER TABLE `ruoli_immagini` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000034800

-- ruoli_indirizzi
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

-- | 030000035200

-- ruoli_video
ALTER TABLE `ruoli_video`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_genitore` (`id_genitore`);

-- | 030000035201

-- ruoli_video
ALTER TABLE `ruoli_video` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000037000

-- settori
ALTER TABLE `settori`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_genitore` (`id_genitore`);

-- | 030000037001

-- settori
ALTER TABLE `settori` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000042000

-- stati
ALTER TABLE `stati`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`codice_istat`),
	ADD UNIQUE KEY `unica_iso31661alpha2` (`iso31661alpha2`),
	ADD UNIQUE KEY `unica_iso31661alpha3` (`iso31661alpha3`),
	ADD KEY `id_continente` (`id_continente`),
	ADD KEY `indice` (`id`,`id_continente`,`nome`,`iso31661alpha2`,`iso31661alpha3`,`codice_istat`);

-- | 030000042001

-- stati
ALTER TABLE `stati` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

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
ALTER TABLE `step` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000043000

-- task
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
ALTER TABLE `task` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000043600

-- telefoni
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
ALTER TABLE `telefoni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000044000

-- template
ALTER TABLE `template`
	ADD PRIMARY KEY (`id`),
  	ADD UNIQUE KEY `unica` (`ruolo`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  	ADD KEY `indice` (`ruolo`,`nome`,`tipo`,`latenza_invio`, `se_mail`,`se_sms`);

-- | 030000044001

-- template
ALTER TABLE `template` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000050000

-- tipologie_anagrafica
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
ALTER TABLE `tipologie_anagrafica` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000050400

-- tipologie_attivita
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
ALTER TABLE `tipologie_attivita` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000050800

-- tipologie_contatti
ALTER TABLE `tipologie_contatti`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);

-- | 030000050801

-- tipologie_contatti
ALTER TABLE `tipologie_contatti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000050900

-- tipologie_contratti
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
ALTER TABLE `tipologie_documenti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000053000

-- tipologie_indirizzi
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
ALTER TABLE `tipologie_indirizzi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000053800

-- tipologie_notizie
ALTER TABLE `tipologie_notizie`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);

-- | 030000053801

-- tipologie_notizie
ALTER TABLE `tipologie_notizie` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000054000

-- tipologie_pagamenti
ALTER TABLE `tipologie_pagamenti`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);

-- | 030000054001

-- tipologie_pagamenti
ALTER TABLE `tipologie_pagamenti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000054600

-- tipologie_prodotti
ALTER TABLE `tipologie_prodotti`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);

-- | 030000054601

-- tipologie_prodotti
ALTER TABLE `tipologie_prodotti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000055000

-- tipologie_progetti
ALTER TABLE `tipologie_progetti`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);

-- | 030000055001

-- tipologie_progetti
ALTER TABLE `tipologie_progetti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000055400

-- tipologie_pubblicazioni
ALTER TABLE `tipologie_pubblicazioni`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);

-- | 030000055401

-- tipologie_pubblicazioni
ALTER TABLE `tipologie_pubblicazioni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000055700

-- tipologie_rinnovi
ALTER TABLE `tipologie_rinnovi`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);

-- | 030000055701

-- tipologie_rinnovi
ALTER TABLE `tipologie_rinnovi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000056200

-- tipologie_telefoni
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
ALTER TABLE `tipologie_telefoni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000056600

-- tipologie_todo
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
ALTER TABLE `tipologie_todo` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000056800

-- tipologie_url
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
ALTER TABLE `tipologie_url` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000060000

-- todo
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
ALTER TABLE `todo` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000062000

-- udm
ALTER TABLE `udm`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_base` (`id_base`); 

-- | 030000062001

-- udm
ALTER TABLE `udm` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000062600

-- url
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
ALTER TABLE `url` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000063000

-- valute
ALTER TABLE `valute`
	ADD PRIMARY KEY (`id`);

-- | 030000063001

-- valute
ALTER TABLE `valute` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000065000

-- video
ALTER TABLE `video`
	ADD PRIMARY KEY (`id`),
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
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);

-- | 030000065001

-- video
ALTER TABLE `video` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | 030000999000

-- test
ALTER TABLE `test`
	ADD PRIMARY KEY (`id`);

-- | 030000999001

-- test
ALTER TABLE `test` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- | FINE FILE
