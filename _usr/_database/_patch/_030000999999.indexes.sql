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

--| 030000000100

-- account
-- tipologia: tabella gestita
-- verifica: 2021-05-20 13:59 Fabio Mosti
ALTER TABLE `account`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`username`),
	ADD KEY `id_anagrafica` (`id_anagrafica`),
	ADD KEY `id_mail` (`id_mail`),
	ADD KEY `se_attivo` (`se_attivo`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_anagrafica`,`username`,`id_mail`,`password`,`se_attivo`,`token`),
	ADD KEY `indice_token` (`id`,`token`);

--| 030000000101

-- account
-- tipologia: tabella gestita
ALTER TABLE `account` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000200

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

--| 030000000201

-- account_gruppi
-- tipologia: tabella gestita
ALTER TABLE `account_gruppi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000300

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

--| 030000000301

-- account_gruppi_attribuzione
-- tipologia: tabella gestita
ALTER TABLE `account_gruppi_attribuzione` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000400

-- anagrafica
-- tipologia: tabella gestita
-- verifica: 2021-05-20 17:05 Fabio Mosti
ALTER TABLE `anagrafica`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`codice`),
	ADD UNIQUE KEY `unica_persone` (`nome`,`cognome`,`codice_fiscale`),
	ADD UNIQUE KEY `unica_aziende` (`denominazione`,`partita_iva`,`codice_fiscale`),
	ADD KEY `id_tipologia` (`id_tipologia`),
	ADD KEY `id_pec_sdi` (`id_pec_sdi`),
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

--| 030000000401

-- anagrafica
-- tipologia: tabella gestita
ALTER TABLE `anagrafica` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;	

--| 030000000500

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

--| 030000000501

-- anagrafica_categorie
-- tipologia: tabella gestita
ALTER TABLE `anagrafica_categorie` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000700

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

--| 030000000701

-- anagrafica_cittadinanze
-- tipologia: tabella gestita
ALTER TABLE `anagrafica_cittadinanze` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000900

-- anagrafica_indirizzi
-- tipologia: tabella gestita
-- verifica: 2021-05-21 16:34 Fabio Mosti
ALTER TABLE `anagrafica_indirizzi`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_anagrafica`,`id_indirizzo`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_indirizzo` (`id_indirizzo`), 
	ADD KEY `id_ruolo` (`id_ruolo`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_anagrafica`,`id_indirizzo`,`id_ruolo`);

--| 030000000901

-- anagrafica_indirizzi
-- tipologia: tabella gestita
ALTER TABLE `anagrafica_indirizzi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000001200

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

--| 030000001201

-- anagrafica_settori
-- tipologia: tabella gestita
ALTER TABLE `anagrafica_settori` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000001300

-- articoli
-- tipologia: tabella gestita
-- verifica: 2021-05-25 11:23 Fabio Mosti
ALTER TABLE `articoli`
 	ADD PRIMARY KEY (`id`), 
 	ADD KEY `id_prodotto` (`id_prodotto`), 
	ADD KEY `id_reparto` (`id_reparto`),
 	ADD KEY `id_taglia` (`id_taglia`), 
 	ADD KEY `id_colore` (`id_colore`), 
 	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
 	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`ordine`,`ean`,`isbn`,`id_prodotto`,`id_reparto`,`id_taglia`,`id_colore`),
	ADD KEY `indice_dimensioni` (`id`,`ordine`,`ean`,`isbn`,`id_prodotto`,`id_reparto`,`larghezza`,`lunghezza`,`altezza`,`peso`,`volume`,`capacita`);

--| 030000001600

-- articoli_caratteristiche
-- tipologia: tabella gestita
-- verifica: 2021-05-25 12:11 Fabio Mosti
ALTER TABLE `articoli_caratteristiche`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_articolo`,`id_caratteristica`), 
	ADD KEY `id_articolo` (`id_articolo`),
	ADD KEY `id_caratteristica` (`id_caratteristica`),
	ADD KEY `indice` (`id`,`id_articolo`,`id_caratteristica`,`ordine`,`valore`,`se_assente` );

--| 030000001601

-- articoli_caratteristiche
-- tipologia: tabella gestita
ALTER TABLE `articoli_caratteristiche` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000001800

-- attivita
-- tipologia: tabella gestita
-- verifica: 2021-05-27 15:07 Fabio Mosti
ALTER TABLE `attivita`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_tipologia` (`id_tipologia`),
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_cliente` (`id_cliente`), 
	ADD KEY `id_indirizzo` (`id_indirizzo`), 
	ADD KEY `id_luogo` (`id_luogo`), 
	ADD KEY `id_progetto` (`id_progetto`), 
	ADD KEY `id_todo` (`id_todo`),
	ADD KEY `id_mastro_provenienza` (`id_mastro_provenienza`), 
	ADD KEY `id_mastro_destinazione` (`id_mastro_destinazione`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `indice` (`id`,`id_tipologia`,`id_anagrafica`,`id_cliente`,`id_progetto`,`id_todo`),
	ADD KEY `indice_scadenza` (`id`,`id_tipologia`,`id_anagrafica`,`id_cliente`,`id_progetto`,`id_todo`,`data_scadenza`,`ora_scadenza`),
	ADD KEY `indice_programmazione` (`id`,`id_tipologia`,`id_anagrafica`,`id_cliente`,`id_progetto`,`id_todo`,`data_programmazione`,`ora_inizio_programmazione`,`ora_fine_programmazione`),
	ADD KEY `indice_attivita` (`id`,`id_tipologia`,`id_anagrafica`,`id_cliente`,`id_progetto`,`id_todo`,`data_attivita`,`ora_inizio`,`ora_fine`),
	ADD KEY `indice_mastri` (`id`,`id_tipologia`,`id_mastro_provenienza`,`id_mastro_destinazione`),
	ADD KEY `indice_sostituti` (`id`,`id_tipologia`,`id_anagrafica`,`id_cliente`,`id_progetto`,`id_todo`,`timestamp_calcolo_sostituti`),
	ADD KEY `indice_token` (`id`,`token`);

--| 030000001801

-- attivita
-- tipologia: tabella gestita
ALTER TABLE `attivita` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000002100

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
	ADD KEY `id_categoria_notizie` (`id_categoria_notizie`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`id_ruolo`,`id_lingua`,`ordine`,`path`,`codice_embed`,`id_embed`),
	ADD KEY `indice_anagrafica` (`id`,`id_ruolo`,`id_lingua`,`ordine`,`path`,`codice_embed`,`id_embed`,`id_anagrafica`),
	ADD KEY `indice_pagine` (`id`,`id_ruolo`,`id_lingua`,`ordine`,`path`,`codice_embed`,`id_embed`,`id_pagina`,`id_file`,`id_risorsa`);

--| 030000002101

-- audio
-- tipologia: tabella gestita
ALTER TABLE `audio` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000002900

-- caratteristiche_prodotti
-- tipologia: tabella gestita
-- verifica: 2021-05-28 18:27 Fabio Mosti
ALTER TABLE `caratteristiche_prodotti`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`nome`,`se_categoria`,`se_prodotto`,`se_articolo`);

--| 030000002901

-- caratteristiche_prodotti
-- tipologia: tabella gestita
ALTER TABLE `caratteristiche_prodotti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000003100

-- categorie_anagrafica
-- tipologia: tabella assistita
-- verifica: 2021-05-28 19:56 Fabio Mosti
-- NOTA: riordinare i flag in ordine alfabetico
ALTER TABLE `categorie_anagrafica`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`), 
	ADD KEY `se_lead` (`se_lead`), 
	ADD KEY `se_prospect` (`se_prospect`), 
	ADD KEY `se_cliente` (`se_cliente`), 
	ADD KEY `se_fornitore` (`se_fornitore`), 
	ADD KEY `se_produttore` (`se_produttore`), 
	ADD KEY `se_collaboratore` (`se_collaboratore`), 
	ADD KEY `se_interno` (`se_interno`), 
	ADD KEY `se_esterno` (`se_esterno`), 
	ADD KEY `se_agente` (`se_agente`), 
	ADD KEY `se_concorrente` (`se_concorrente`), 
	ADD KEY `se_azienda_gestita` (`se_azienda_gestita`), 
	ADD KEY `se_amministrazione` (`se_amministrazione`), 
	ADD KEY `se_notizie` (`se_notizie`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`se_lead`,`se_prospect`,`se_cliente`,`se_fornitore`,`se_produttore`,`se_collaboratore`,`se_interno`,`se_esterno`,`se_agente`,`se_concorrente`,`se_azienda_gestita`,`se_amministrazione`);

--| 030000003101

-- categorie_anagrafica
-- tipologia: tabella assistita
ALTER TABLE `categorie_anagrafica` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000003700

-- categorie_notizie
-- tipologia: tabella gestita
-- verifica: 2021-06-01 18:28 Fabio Mosti
ALTER TABLE `categorie_notizie`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`), 
	ADD KEY `id_sito` (`id_sito`), 
	ADD KEY `id_pagina` (`id_pagina`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`id_sito`,`id_pagina`);

--| 030000003701

-- categorie_notizie
-- tipologia: tabella gestita
ALTER TABLE `categorie_notizie` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000003900

-- categorie_prodotti
-- tipologia: tabella gestita
-- verifica: 2021-06-01 19:48 Fabio Mosti
ALTER TABLE `categorie_prodotti`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `id_sito` (`id_sito`), 
	ADD KEY `id_pagina` (`id_pagina`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`id_sito`,`id_pagina`);

--| 030000003901

-- categorie_prodotti
-- tipologia: tabella gestita
ALTER TABLE `categorie_prodotti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000004300

-- categorie_progetti
-- tipologia: tabella gestita
-- verifica: 2021-06-02 20:10 Fabio Mosti
ALTER TABLE `categorie_progetti`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`);

--| 030000004301

-- categorie_progetti
-- tipologia: tabella gestita
ALTER TABLE `categorie_progetti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000004500

-- categorie_risorse
-- tipologia: tabella gestita
-- verifica: 2021-06-02 20:10 Fabio Mosti
ALTER TABLE `categorie_risorse`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `id_pagina` (`id_pagina`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`id_pagina`);

--| 030000004501

-- categorie_risorse
-- tipologia: tabella gestita
ALTER TABLE `categorie_risorse` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000004800

-- chiavi
-- tipologia: tabella di supporto
-- verifica: 2021-11-15 11:58 Chiara GDL
ALTER TABLE `chiavi`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_licenza`,`codice`),
	ADD KEY `codice` (`codice`),
	ADD KEY `seriale` (`seriale`),
	ADD KEY `id_licenza` (`id_licenza`),
	ADD KEY `id_tipologia` (`id_tipologia`),
	ADD KEY `indice` (`id`,`codice`, `seriale`,`nome`,`id_licenza`, `id_tipologia`);

--| 030000004801

-- chiavi
-- tipologia: tabella di supporto
ALTER TABLE `chiavi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000005100

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
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `indice` (`id`, `nome`,`id_genitore`,`hex`,`r`,`g`,`b`),
	ADD KEY `indice_ral` (`id`, `nome`,`id_genitore`,`ral`),
	ADD KEY `indice_pantone` (`id`, `nome`,`id_genitore`,`pantone`),
	ADD KEY `indice_cmyk` (`id`, `nome`,`id_genitore`,`c`,`m`,`y`,`k`);

--| 030000005101

-- colori
-- tipologia: tabella di supporto
ALTER TABLE `colori` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000005300

-- comuni
-- tipologia: tabella di supporto
-- verifica: 2021-06-03 19:58 Fabio Mosti
ALTER TABLE `comuni`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica_istat` (`codice_istat`),
	ADD UNIQUE KEY `unica_catasto` (`codice_catasto`),
	ADD KEY `id_provincia` (`id_provincia`),
	ADD KEY `indice` (`id`,`id_provincia`, `nome`,`codice_istat`,`codice_catasto`);

--| 030000005301

-- comuni
-- tipologia: tabella di supporto
ALTER TABLE `comuni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000006700

-- contatti
-- tipologia: tabella gestita
-- verifica: 2021-06-03 21:52 Fabio Mosti
ALTER TABLE `contatti`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_tipologia` (`id_tipologia`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_inviante` (`id_inviante`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `timestamp_contatto` (`timestamp_contatto`), 
	ADD KEY `indice` (`id`, `id_tipologia`, `id_anagrafica`,`id_inviante`,`nome`,`timestamp_contatto`);

--| 030000006701

-- contatti
-- tipologia: tabella gestita
ALTER TABLE `contatti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000006900

-- contenuti
-- tipologia: tabella gestita
-- verifica: 2021-06-07 17:36 Fabio Mosti
ALTER TABLE `contenuti`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica_anagrafica` (`id_lingua`,`id_anagrafica`), 
	ADD UNIQUE KEY `unica_prodotto` (`id_lingua`,`id_prodotto`), 
	ADD UNIQUE KEY `unica_articolo` (`id_lingua`,`id_articolo`), 
	ADD UNIQUE KEY `unica_categoria_prodotti` (`id_lingua`,`id_categoria_prodotti`), 
	ADD UNIQUE KEY `unica_caratteristica_prodotti` (`id_lingua`,`id_caratteristica_prodotti`), 
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
	ADD KEY `id_lingua` (`id_lingua`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_prodotto` (`id_prodotto`), 
	ADD KEY `id_articolo` (`id_articolo`), 
	ADD KEY `id_categoria_prodotti` (`id_categoria_prodotti`), 
	ADD KEY `id_caratteristica_prodotti` (`id_caratteristica_prodotti`), 
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
	ADD KEY `id_notizia` (`id_notizia`), 
	ADD KEY `id_categoria_notizie` (`id_categoria_notizie`),
	ADD KEY `id_template` (`id_template`), 
	ADD KEY `id_colore` (`id_colore`), 
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

--| 030000006901

-- contenuti
-- tipologia: tabella gestita
ALTER TABLE `contenuti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000007100

-- continenti
-- tipologia: tabella di supporto
-- verifica: 2021-06-09 11:27 Fabio Mosti
ALTER TABLE `continenti`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`nome`),
	ADD KEY `indice` (`id`,`codice`,`nome`);

--| 030000007101

-- continenti
-- tipologia: tabella di supporto
ALTER TABLE `continenti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000008000

-- coupon
-- tipologia: tabella gestita
-- verifica: 2021-06-29 15:50 Fabio Mosti
ALTER TABLE `coupon`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`nome`,`timestamp_inizio`,`timestamp_fine`,`sconto_percentuale`,`sconto_fisso`,`se_multiuso`,`se_globale`);
 
--| 030000008200
 
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

--| 030000008201
 
-- coupon_categorie_prodotti
-- tipologia: tabella gestita
ALTER TABLE `coupon_categorie_prodotti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000008400
 
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

--| 030000008401

-- coupon_listini
-- tipologia: tabella gestita
ALTER TABLE `coupon_listini` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
 
--| 030000008600

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

--| 030000008601

-- coupon_marchi
-- tipologia: tabella gestita
ALTER TABLE `coupon_marchi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000008800

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

--| 030000008801

-- coupon_prodotti
-- tipologia: tabella gestita
ALTER TABLE `coupon_prodotti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000009800

-- documenti
-- tipologia: tabella gestita
-- verifica: 2021-09-03 17:09 Fabio Mosti
ALTER TABLE `documenti`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_tipologia` (`id_tipologia`), 
	ADD KEY `id_emittente` (`id_emittente`), 
	ADD KEY `id_sede_emittente` (`id_sede_emittente`), 
	ADD KEY `id_destinatario` (`id_destinatario`), 
	ADD KEY `id_sede_destinatario` (`id_sede_destinatario`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_tipologia`,`numero`,`data`,`id_emittente`,`id_sede_emittente`,`id_destinatario`,`id_sede_destinatario`);

--| 030000009801

-- documenti
-- tipologia: tabella gestita
ALTER TABLE `documenti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000010000

-- documenti_articoli
-- tipologia: tabella gestita
-- verifica: 2021-09-10 11:57 Fabio Mosti
ALTER TABLE `documenti_articoli`
	ADD PRIMARY KEY (`id`), 
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
	ADD KEY `id_mastro_provenienza` (`id_mastro_provenienza`), 
	ADD KEY `id_mastro_destinazione` (`id_mastro_destinazione`), 
	ADD KEY `id_udm` (`id_udm`), 
	ADD KEY `id_listino` (`id_listino`), 
	ADD KEY `id_iva` (`id_iva`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `data` (`data`), 
	ADD KEY `quantita` (`quantita`), 
	ADD KEY `importo_netto_totale` (`importo_netto_totale`),
	ADD KEY `indice` (`id`,`id_genitore`,`id_tipologia`,`ordine`,`id_documento`,`data`,`id_emittente`,`id_destinatario`,`id_reparto`,`id_progetto`,`id_todo`,`id_attivita`,`id_articolo`,`id_mastro_provenienza`,`id_mastro_destinazione`),
	ADD KEY `indice_progetto_quantita` (`id`,`id_genitore`,`id_tipologia`,`ordine`,`id_documento`,`data`,`id_emittente`,`id_destinatario`,`id_reparto`,`id_progetto`,`id_articolo`,`id_mastro_provenienza`,`id_mastro_destinazione`,`id_udm`,`quantita`),
	ADD KEY `indice_progetto_valore` (`id`,`id_genitore`,`id_tipologia`,`ordine`,`id_documento`,`data`,`id_emittente`,`id_destinatario`,`id_reparto`,`id_progetto`,`id_articolo`,`id_mastro_provenienza`,`id_mastro_destinazione`,`id_listino`,`importo_netto_totale`,`id_iva`),
	ADD KEY `indice_todo_quantita` (`id`,`id_genitore`,`id_tipologia`,`ordine`,`id_documento`,`data`,`id_emittente`,`id_destinatario`,`id_reparto`,`id_todo`,`id_articolo`,`id_mastro_provenienza`,`id_mastro_destinazione`,`id_udm`,`quantita`),
	ADD KEY `indice_todo_valore` (`id`,`id_genitore`,`id_tipologia`,`ordine`,`id_documento`,`data`,`id_emittente`,`id_destinatario`,`id_reparto`,`id_todo`,`id_articolo`,`id_mastro_provenienza`,`id_mastro_destinazione`,`id_listino`,`importo_netto_totale`,`id_iva`),
	ADD KEY `indice_attivita_quantita` (`id`,`id_genitore`,`id_tipologia`,`ordine`,`id_documento`,`data`,`id_emittente`,`id_destinatario`,`id_reparto`,`id_attivita`,`id_articolo`,`id_mastro_provenienza`,`id_mastro_destinazione`,`id_udm`,`quantita`),
	ADD KEY `indice_attivita_valore` (`id`,`id_genitore`,`id_tipologia`,`ordine`,`id_documento`,`data`,`id_emittente`,`id_destinatario`,`id_reparto`,`id_attivita`,`id_articolo`,`id_mastro_provenienza`,`id_mastro_destinazione`,`id_listino`,`importo_netto_totale`,`id_iva`);

--| 030000010001

-- documenti_articoli
-- tipologia: tabella gestita
ALTER TABLE `documenti_articoli` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000012800

-- embed
-- tipologia: tabella standard
-- verifica: 2021-09-10 11:57 Fabio Mosti
ALTER TABLE `embed`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `nome` (`nome`), 
	ADD KEY `indice` (`id`,`nome`,`se_audio`,`se_video`);

--| 030000012801

-- embed
-- tipologia: tabella standard
ALTER TABLE `embed` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000015000
 
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
	ADD KEY `id_ruolo` (`id_ruolo`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_prodotto` (`id_prodotto`), 
	ADD KEY `id_articolo` (`id_articolo`), 
	ADD KEY `id_categoria_prodotti` (`id_categoria_prodotti`), 
	ADD KEY `id_todo` (`id_todo`), 
	ADD KEY `id_pagina` (`id_pagina`), 
	ADD KEY `id_template` (`id_template`), 
	ADD KEY `id_notizia` (`id_notizia`), 
	ADD KEY `id_categoria_notizie` (`id_categoria_notizie`), 
	ADD KEY `id_risorsa` (`id_risorsa`),
	ADD KEY `id_categoria_risorse` (`id_categoria_risorse`), 
	ADD KEY `id_lingua` (`id_lingua`), 
	ADD KEY `id_mail_out` (`id_mail_out`), 
	ADD KEY `id_mail_sent` (`id_mail_sent`), 
	ADD KEY `path` (`path`), 
	ADD KEY `url` (`url`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`id_ruolo`,`id_lingua`,`path`,`url`),
	ADD KEY `indice_anagrafica` (`id`,`id_ruolo`,`id_anagrafica`,`id_lingua`,`path`,`url`),
	ADD KEY `indice_prodotti` (`id`,`id_ruolo`,`id_prodotto`,`id_lingua`,`path`,`url`),
	ADD KEY `indice_articoli` (`id`,`id_ruolo`,`id_articolo`,`id_lingua`,`path`,`url`),
	ADD KEY `indice_categorie_prodotti` (`id`,`id_ruolo`,`id_categoria_prodotti`,`id_lingua`,`path`,`url`),
	ADD KEY `indice_todo` (`id`,`id_ruolo`,`id_todo`,`id_lingua`,`path`,`url`),
	ADD KEY `indice_pagine` (`id`,`id_ruolo`,`id_pagina`,`id_lingua`,`path`,`url`),
	ADD KEY `indice_template` (`id`,`id_ruolo`,`id_template`,`id_lingua`,`path`,`url`),
	ADD KEY `indice_notizie` (`id`,`id_ruolo`,`id_notizia`,`id_lingua`,`path`,`url`),
	ADD KEY `indice_categorie_notizie` (`id`,`id_ruolo`,`id_categoria_notizie`,`id_lingua`,`path`,`url`),
	ADD KEY `indice_risorse` (`id`,`id_ruolo`,`id_risorsa`,`id_lingua`,`path`,`url`),
	ADD KEY `indice_categorie_risorse` (`id`,`id_ruolo`,`id_categoria_risorse`,`id_lingua`,`path`,`url`);

--| 030000015001

-- file
-- tipologia: tabella gestita
ALTER TABLE `file` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
 
--| 030000015200
 
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

--| 030000015201
 
-- gruppi
-- tipologia: tabella gestita
ALTER TABLE `gruppi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000015400

-- iban
-- tipologia: tabella gestita
-- verifica: 2021-09-22 11:55 Fabio Mosti
ALTER TABLE `iban`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`id_anagrafica`,`iban`);

--| 030000015401

-- iban
-- tipologia: tabella gestita
ALTER TABLE `iban` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000015600

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
 	ADD KEY `id_indirizzo` (`id_indirizzo`), 
 	ADD KEY `id_lingua` (`id_lingua`), 
 	ADD KEY `id_ruolo` (`id_ruolo`), 
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

--| 030000015601

-- immagini
-- tipologia: tabella gestita
ALTER TABLE `immagini` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000015800

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

--| 030000015801

-- indirizzi
-- tipologia: tabella gestita
ALTER TABLE `indirizzi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000016000

-- iva
-- tipologia: tabella di supporto
-- verifica: 2021-09-23 16:53 Fabio Mosti
ALTER TABLE `iva`
	ADD PRIMARY KEY (`id`),
	ADD KEY `aliquota` (`aliquota`),
	ADD KEY `timestamp_archiviazione` (`timestamp_archiviazione`),
	ADD KEY `indice` (`id`,`aliquota`,`nome`,`codice`,`timestamp_archiviazione`);

--| 030000016001

-- iva
-- tipologia: tabella di supporto
ALTER TABLE `iva` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000016200

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

--| 030000016201

-- job
-- tipologia: tabella gestita
ALTER TABLE `job` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000016600

-- licenze
-- tipologia: tabella standard
-- verifica: 2021-11-15 12:41 Fabio Mosti
ALTER TABLE `licenze`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_anagrafica` (`id_anagrafica`),
	ADD KEY `id_tipologia` (`id_tipologia`),
	ADD KEY `codice` (`codice`),
	ADD KEY `nome` (`nome`),
	ADD KEY `giorni_validita` (`giorni_validita`),
	ADD KEY `giorni_rinnovo` (`giorni_rinnovo`),
	ADD KEY `timestamp_distribuzione` (`timestamp_distribuzione`),
	ADD KEY `timestamp_inizio` (`timestamp_inizio`),
	ADD KEY `timestamp_fine` (`timestamp_fine`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id_anagrafica`,`id_tipologia`,`id_rivenditore`,`codice`,`postazioni`,`nome`,`giorni_validita`,`giorni_rinnovo`,`timestamp_distribuzione`,`timestamp_inizio`,`timestamp_fine`);

--| 030000016601

-- licenze
-- tipologia: tabella standard
ALTER TABLE `licenze` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000016700

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

--| 030000016701

-- licenze_software
-- tipologia: tabella gestita
ALTER TABLE `licenze_software` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000016800

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

--| 030000016801

-- lingue
-- tipologia: tabella di supporto
ALTER TABLE `lingue` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000017200

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

--| 030000017201

-- listini
-- tipologia: tabella assistita
ALTER TABLE `listini` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000017400

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

--| 030000017401

-- listini_clienti
-- tipologia: tabella gestita
ALTER TABLE `listini_clienti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000018000

-- luoghi
-- tipologia: tabella gestita
-- verifica: 2021-09-24 18:41 Fabio Mosti
ALTER TABLE `luoghi`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `id_indirizzo` (`id_indirizzo`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_genitore`,`id_indirizzo`,`nome`);

--| 030000018001

-- luoghi
-- tipologia: tabella gestita
ALTER TABLE `luoghi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000018200

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
	ADD KEY `id_pagina` (`id_pagina`),
	ADD KEY `id_prodotto` (`id_prodotto`),
	ADD KEY `id_articolo` (`id_articolo`),
	ADD KEY `id_categoria_prodotti` (`id_categoria_prodotti`),
	ADD KEY `indice` (`id`,`ordine`,`macro`),
	ADD KEY `indice_pagine` (`id`,`id_pagina`,`ordine`,`macro`),
	ADD KEY `indice_prodotti` (`id`,`id_prodotto`,`ordine`,`macro`),
	ADD KEY `indice_articoli` (`id`,`id_articolo`,`ordine`,`macro`),
	ADD KEY `indice_categorie_prodotti` (`id`,`id_categoria_prodotti`,`ordine`,`macro`),
	ADD KEY `indice_notizie` (`id`,`id_notizia`,`ordine`,`macro`),
	ADD KEY `indice_categorie_notizie` (`id`,`id_categoria_notizie`,`ordine`,`macro`),
	ADD KEY `indice_risorse` (`id`,`id_risorsa`,`ordine`,`macro`),
	ADD KEY `indice_categorie_risorse` (`id`,`id_categoria_risorse`,`ordine`,`macro`);

--| 030000018201

-- macro
-- tipologia: tabella gestita
ALTER TABLE `macro` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000018600

-- mail
-- tipologia: tabella gestita
-- verifica: 2021-09-27 18:33 Fabio Mosti
ALTER TABLE `mail`
  	ADD PRIMARY KEY (`id`),
  	ADD UNIQUE KEY `unica` (`id_anagrafica`,`indirizzo`),
  	ADD KEY `id_anagrafica` (`id_anagrafica`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`id_anagrafica`,`indirizzo`,`se_notifiche`,`se_pec`);

--| 030000018601

-- mail
-- tipologia: tabella gestita
ALTER TABLE `mail` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000018800

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

--| 030000018801

-- mail_out
-- tipolgia: tabella gestita
ALTER TABLE `mail_out` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000018900

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

--| 030000020200

-- marchi
-- tipologia: tabella gestita
-- verifica: 2021-09-28 16:51 Fabio Mosti
ALTER TABLE `marchi`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`nome`);

--| 030000020201

-- marchi
-- tipologia: tabella gestita
ALTER TABLE `marchi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000020600

-- mastri
-- tipologia: tabella gestita
-- verifica: 2021-09-29 11:33 Fabio Mosti
ALTER TABLE `mastri`
 	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
 	ADD KEY `id_tipologia` (`id_tipologia`),
 	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
 	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`id_genitore`,`id_tipologia`,`nome`);

--| 030000020601

-- mastri
-- tipologia: tabella gestita
ALTER TABLE `mastri` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000021600

-- menu
-- tipologia: tabella gestita
-- verifica: 2021-10-01 09:32 Fabio Mosti
ALTER TABLE `menu`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_lingua`,`id_pagina`,`menu`), 
 	ADD UNIQUE KEY `unica_categoria_prodotti` (`id_lingua`,`id_categoria_prodotti`,`menu`), 
 	ADD UNIQUE KEY `unica_categoria_notizie` (`id_lingua`,`id_categoria_notizie`,`menu`), 
 	ADD UNIQUE KEY `unica_categoria_risorse` (`id_lingua`,`id_categoria_risorse`,`menu`), 
	ADD KEY `id_lingua` (`id_lingua`),
	ADD KEY `id_pagina` (`id_pagina`), 
 	ADD KEY `id_categoria_prodotti` (`id_categoria_prodotti`), 
 	ADD KEY `id_categoria_notizie` (`id_categoria_notizie`), 
 	ADD KEY `id_categoria_risorse` (`id_categoria_risorse`), 
	ADD KEY `indice` (`id`,`id_lingua`,`id_pagina`,`ordine`,`menu`,`nome`,`target`,`sottopagine`),
	ADD KEY `indice_categorie_prodotti` (`id`,`id_lingua`,`id_categoria_prodotti`,`menu`,`nome`),
	ADD KEY `indice_categorie_notizie` (`id`,`id_lingua`,`id_categoria_notizie`,`menu`,`nome`),
	ADD KEY `indice_categorie_risorse` (`id`,`id_lingua`,`id_categoria_risorse`,`menu`,`nome`);

--| 030000021601

-- menu
-- tipologia: tabella gestita
ALTER TABLE `menu` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000021800

-- metadati
-- tipologia: tabella gestita
-- verifica: 2021-10-01 10:12 Fabio Mosti
ALTER TABLE `metadati`
 	ADD PRIMARY KEY (`id`), 
 	ADD UNIQUE KEY `unica_anagrafica` (`id_lingua`,`id_anagrafica`,`nome`), 
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
 	ADD KEY `id_lingua` (`id_lingua`), 
 	ADD KEY `id_anagrafica` (`id_anagrafica`), 
 	ADD KEY `id_pagina` (`id_pagina`), 
 	ADD KEY `id_prodotto` (`id_prodotto`), 
 	ADD KEY `id_articolo` (`id_articolo`), 
 	ADD KEY `id_categoria_prodotti` (`id_categoria_prodotti`), 
 	ADD KEY `id_notizia` (`id_notizia`), 
 	ADD KEY `id_categoria_notizie` (`id_categoria_notizie`), 
 	ADD KEY `id_risorsa` (`id_risorsa`),
 	ADD KEY `id_categoria_risorse` (`id_categoria_risorse`), 
 	ADD KEY `id_immagine` (`id_immagine`), 
 	ADD KEY `id_video` (`id_video`), 
 	ADD KEY `id_audio` (`id_audio`), 
 	ADD KEY `id_file` (`id_file`), 
	ADD KEY `indice` (`id`,`id_lingua`,`nome`,`testo`(255)),
	ADD KEY `indice_anagrafica` (`id`,`id_lingua`,`id_anagrafica`,`nome`,`testo`(255)),
	ADD KEY `indice_pagina` (`id`,`id_lingua`,`id_pagina`,`nome`,`testo`(255)),
	ADD KEY `indice_prodotti` (`id`,`id_lingua`,`id_prodotto`,`nome`,`testo`(255)),
	ADD KEY `indice_articoli` (`id`,`id_lingua`,`id_articolo`,`nome`,`testo`(255)),
	ADD KEY `indice_categorie_prodotti` (`id`,`id_lingua`,`id_categoria_prodotti`,`nome`,`testo`(255)),
	ADD KEY `indice_notizie` (`id`,`id_lingua`,`id_notizia`,`nome`,`testo`(255)),
	ADD KEY `indice_categoria_notizie` (`id`,`id_lingua`,`id_categoria_notizie`,`nome`,`testo`(255)),
	ADD KEY `indice_risorse` (`id`,`id_lingua`,`id_risorsa`,`nome`,`testo`(255)),
	ADD KEY `indice_categorie_risorse` (`id`,`id_lingua`,`id_categoria_risorse`,`nome`,`testo`(255)),
	ADD KEY `indice_immagini` (`id`,`id_lingua`,`id_immagine`,`nome`,`testo`(255)),
	ADD KEY `indice_video` (`id`,`id_lingua`,`id_video`,`nome`,`testo`(255)),
	ADD KEY `indice_audio` (`id`,`id_lingua`,`id_audio`,`nome`,`testo`(255)),
	ADD KEY `indice_file` (`id`,`id_lingua`,`id_file`,`nome`,`testo`(255));

--| 030000021801

-- metadati
-- tipologia: tabella gestita
ALTER TABLE `metadati` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000022000

-- notizie
-- tipologia: tabella gestita
-- verifica: 2021-10-01 12:07 Fabio Mosti
ALTER TABLE `notizie`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_tipologia` (`id_tipologia`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`id_tipologia`,`nome`);

--| 030000022001

-- notizie
-- tipologia: tabella gestita
ALTER TABLE `notizie` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000022200

-- notizie_categorie
-- tipologia: tabella gestita
-- verifica: 2021-10-01 12:07 Fabio Mosti
ALTER TABLE `notizie_categorie`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_notizia`,`id_categoria`),
	ADD KEY `id_notizia` (`id_notizia`), 
	ADD KEY `id_categoria` (`id_categoria`), 
	ADD KEY `ordine` (`ordine`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`id_notizia`,`id_categoria`,`ordine`);

--| 030000022201

-- notizie_categorie
-- tipologia: tabella gestita
ALTER TABLE `notizie_categorie` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000022800

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

--| 030000022801

-- organizzazioni
-- tipologia: tabella gestita
ALTER TABLE `organizzazioni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000023100

-- pagamenti
-- tipologia: tabella gestita
-- verifica: 2021-11-12 16:00 Chiara GDL
ALTER TABLE `pagamenti`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_tipologia` (`id_tipologia`), 
	ADD KEY `ordine` (`ordine`), 
	ADD KEY `id_documento` (`id_documento`), 
	ADD KEY `id_mastro_provenienza` (`id_mastro_provenienza`), 
	ADD KEY `id_mastro_destinazione` (`id_mastro_destinazione`), 
	ADD KEY `id_iban` (`id_iban`), 
	ADD KEY `id_listino` (`id_listino`), 
	ADD KEY `id_iva` (`id_iva`), 
	ADD KEY `timestamp_pagamento` (`timestamp_pagamento`), 
	ADD KEY `importo_netto_totale` (`importo_netto_totale`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`id_tipologia`,`ordine`,`id_documento`,`timestamp_pagamento`,`id_mastro_provenienza`,`id_mastro_destinazione`,`id_listino`,`id_iban`,`importo_netto_totale`,`id_iva`);

--| 030000023101

-- pagamenti
-- tipologia: tabella gestita
ALTER TABLE `pagamenti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000023200

-- pagine
-- tipologia: tabella gestita
-- verifica: 2021-10-04 11:31 Fabio Mosti
ALTER TABLE `pagine`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `id_sito` (`id_sito`),
	ADD KEY `nome` (`nome`),
	ADD KEY `id_contenuti` (`id_contenuti`),
	ADD KEY `se_sitemap` (`se_sitemap`),
	ADD KEY `se_cacheable` (`se_cacheable`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_genitore`,`id_sito`,`nome`,`template`,`schema_html`,`tema_css`,`se_sitemap`,`se_cacheable`,`id_contenuti`);

--| 030000023201

-- pagine
-- tipologia: tabella gestita
ALTER TABLE `pagine` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000023600

-- periodicita
-- tipologia: tabella di supporto
-- verifica: 2021-10-05 17:57 Fabio Mosti
ALTER TABLE `periodicita`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`nome`), 
	ADD KEY `nome` (`nome`), 
	ADD KEY `indice` (`id`,`nome`);

--| 030000023601

-- pianificazioni
-- tipologia: tabella gestita
ALTER TABLE `periodicita` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000023800

-- pianificazioni
-- tipologia: tabella gestita
-- verifica: 2021-10-05 17:57 Fabio Mosti
ALTER TABLE `pianificazioni`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica_progetto` (`id_progetto`), 
	ADD UNIQUE KEY `unica_todo` (`id_todo`), 
	ADD UNIQUE KEY `unica_attivita` (`id_attivita`), 
	ADD KEY `id_periodicita` (`id_periodicita`),
	ADD KEY `nome` (`nome`), 
	ADD KEY `token` (`token`), 
	ADD KEY `data_fine` (`data_fine`),
	ADD KEY `data_elaborazione` (`data_elaborazione`),
	ADD KEY `indice` (`id`,`nome`,`id_periodicita`,`cadenza`,`se_lunedi`,`se_martedi`,`se_mercoledi`,`se_giovedi`,`se_venerdi`,`se_sabato`,`se_domenica`,`schema_ripetizione`,`data_elaborazione`,`giorni_estensione`,`data_fine`,`token`),
	ADD KEY `indice_progetto` (`id`,`id_progetto`,`id_periodicita`,`cadenza`,`se_lunedi`,`se_martedi`,`se_mercoledi`,`se_giovedi`,`se_venerdi`,`se_sabato`,`se_domenica`,`schema_ripetizione`,`data_elaborazione`,`giorni_estensione`,`data_fine`,`token`),
	ADD KEY `indice_todo` (`id`,`id_todo`,`id_periodicita`,`cadenza`,`se_lunedi`,`se_martedi`,`se_mercoledi`,`se_giovedi`,`se_venerdi`,`se_sabato`,`se_domenica`,`schema_ripetizione`,`data_elaborazione`,`giorni_estensione`,`data_fine`,`token`),
	ADD KEY `indice_attivita` (`id`,`id_attivita`,`id_periodicita`,`cadenza`,`se_lunedi`,`se_martedi`,`se_mercoledi`,`se_giovedi`,`se_venerdi`,`se_sabato`,`se_domenica`,`schema_ripetizione`,`data_elaborazione`,`giorni_estensione`,`data_fine`,`token`);

--| 030000023801

-- pianificazioni
-- tipologia: tabella gestita
ALTER TABLE `pianificazioni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000024000

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

--| 030000024001

-- popup
-- tipologia: tabella gestita
ALTER TABLE `popup` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000024200

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

--| 030000024201

-- popup_pagine
-- tipologia: tabella gestita
ALTER TABLE `popup_pagine` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000025000

-- prezzi
-- tipologia: tabella gestita
-- verifica: 2021-10-04 16:53 Fabio Mosti
ALTER TABLE `prezzi`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica_prodotto` (`id_prodotto`,`id_listino`,`id_iva`), 
	ADD UNIQUE KEY `unica_articolo` (`id_articolo`,`id_listino`,`id_iva`), 
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

--| 030000025001

-- prezzi
-- tipologia: tabella gestita
ALTER TABLE `prezzi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000026000

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
	ADD KEY `indice` (`id`,`id_tipologia`,`id_marchio`,`id_produttore`,`nome`,`codice_produttore`);

--| 030000026200

-- prodotti_caratteristiche
-- tipologia: tabella gestita
-- verifica: 2021-10-04 19:26 Fabio Mosti
ALTER TABLE `prodotti_caratteristiche`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_prodotto`,`id_caratteristica`), 
	ADD KEY `id_prodotto` (`id_prodotto`),
	ADD KEY `id_caratteristica` (`id_caratteristica`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_prodotto`,`id_caratteristica`,`ordine`);

--| 030000026201

-- prodotti_caratteristiche
-- tipologia: tabella gestita
ALTER TABLE `prodotti_caratteristiche` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000026400

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

--| 030000026401

-- prodotti_categorie
-- tipologia: tabella gestita
ALTER TABLE `prodotti_categorie` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000027000

-- progetti
-- tipologia: tabella gestita
-- verifica: 2021-10-08 13:54 Fabio Mosti
ALTER TABLE `progetti`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_tipologia` (`id_tipologia`), 
	ADD KEY `id_pianificazione` (`id_pianificazione`),
	ADD KEY `id_cliente` (`id_cliente`), 
	ADD KEY `id_indirizzo` (`id_indirizzo`), 
	ADD KEY `nome` (`nome`), 
	ADD KEY `data_accettazione` (`data_accettazione`),
	ADD KEY `data_chiusura` (`data_chiusura`),
	ADD KEY `data_archiviazione` (`data_archiviazione`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_tipologia`,`id_pianificazione`,`id_cliente`,`id_indirizzo`,`nome`,`data_accettazione`,`data_chiusura`,`data_archiviazione`);

--| 030000027200

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
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_progetto`,`id_anagrafica`,`id_ruolo`,`ordine`);

--| 030000027201

-- progetti_anagrafica
-- tipologia: tabella gestita
ALTER TABLE `progetti_anagrafica` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000027400

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

--| 030000027401

-- progetti_anagrafica
-- tipologia: tabella gestita
ALTER TABLE `progetti_categorie` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000028000

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

--| 030000028001

-- provincie
-- tipologia: tabella di supporto
ALTER TABLE `provincie` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000028400

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
	ADD KEY `id_risorsa` (`id_risorsa`),
	ADD KEY `id_categoria_risorse` (`id_categoria_risorse`), 
	ADD KEY `timestamp_inizio` (`timestamp_inizio`), 
	ADD KEY `timestamp_fine` (`timestamp_fine`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_tipologia`,`ordine`,`id_prodotto`,`id_articolo`,`id_categoria_prodotti`,`id_notizia`,`id_categoria_notizie`,`id_pagina`,`id_popup`,`timestamp_inizio`,`timestamp_fine`);

--| 030000028401

-- pubblicazioni
-- tipologia: tabella gestita
ALTER TABLE `pubblicazioni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000028600

-- ranking
-- tipologia: tabella assistita
-- verifica: 2021-10-11 17:48 Fabio Mosti
ALTER TABLE `ranking`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`nome`),
	ADD KEY `nome` (`nome`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`nome`,`ordine`);

--| 030000028601

-- ranking
-- tipologia: tabella assistita
-- verifica: 2021-10-11 17:48 Fabio Mosti
ALTER TABLE `ranking` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000029400

-- redirect
-- tipologia: tabella gestita
-- verifica: 2021-10-09 14:43 Fabio Mosti
ALTER TABLE `redirect`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_sito`,`sorgente`),
	ADD KEY `id_sito` (`id_sito`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`codice`,`sorgente`,`destinazione`); 

--| 030000029401

-- redirect
-- tipologia: tabella gestita
ALTER TABLE `redirect` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000029800

-- regimi
-- tipologia: tabella di supporto
-- verifica: 2021-10-09 15:04 Fabio Mosti
ALTER TABLE `regimi`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`nome`),
	ADD KEY `indice` (`id`,`nome`,`codice`); 

--| 030000029801

-- regimi
-- tipologia: tabella di supporto
ALTER TABLE `regimi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000030200

-- regioni
-- tipologia: tabella standard
-- verifica: 2021-10-09 15:24 Fabio Mosti
ALTER TABLE `regioni`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`codice_istat`),
	ADD KEY `id_stato` (`id_stato`),
	ADD KEY `indice` (`id`,`id_stato`,`nome`,`codice_istat`);

--| 030000030201

-- regioni
-- tipologia: tabella standard
ALTER TABLE `regioni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000030800

-- reparti
-- tipologia: tabella gestita
-- verifica: 2021-10-09 15:36 Fabio Mosti
ALTER TABLE `reparti` 
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_iva` (`id_iva`), 
	ADD KEY `id_settore` (`id_settore`), 
	ADD KEY `nome` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`id_iva`,`id_settore`,`nome`);

--| 030000030801

-- reparti
-- tipologia: tabella gestita
ALTER TABLE `reparti`MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000032000

-- risorse
-- tipologia: tabella gestita
-- verifica: 2021-10-09 16:08 Fabio Mosti
ALTER TABLE `risorse`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_tipologia` (`id_tipologia`),
	ADD KEY `id_testata` (`id_testata`),
	ADD KEY `giorno_pubblicazione` (`giorno_pubblicazione`),
	ADD KEY `mese_pubblicazione` (`mese_pubblicazione`),
	ADD KEY `anno_pubblicazione` (`anno_pubblicazione`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_tipologia`,`codice`,`nome`,`id_testata`,`giorno_pubblicazione`,`mese_pubblicazione`,`anno_pubblicazione`);

--| 030000032001

-- risorse
-- tipologia: tabella gestita
ALTER TABLE `risorse` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;	

--| 030000032200

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

--| 030000032201

-- risorse_anagrafica
-- tipologia: tabella di supporto
ALTER TABLE `risorse_anagrafica` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000032400

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

--| 030000032401

-- risorse_categorie
-- tipologia: tabella di supporto
ALTER TABLE `risorse_categorie` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000034000

-- ruoli_anagrafica
-- tipologia: tabella di supporto
-- verifica: 2021-10-09 18:11 Fabio Mosti
ALTER TABLE `ruoli_anagrafica`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`nome`),
	ADD KEY `id_genitore` (`id_genitore`), 
	ADD KEY `se_organizzazioni` (`se_organizzazioni`), 
	ADD KEY `se_risorse` (`se_risorse`), 
	ADD KEY `se_progetti` (`se_progetti`), 
	ADD KEY `indice` (`id`,`id_genitore`,`nome`,`se_organizzazioni`,`se_risorse`,`se_progetti`);

--| 030000034001

-- ruoli_anagrafica
-- tipologia: tabella di supporto
ALTER TABLE `ruoli_anagrafica` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000034200

-- ruoli_audio
-- tipologia: tabella di supporto
-- verifica: 2021-10-09 18:28 Fabio Mosti
ALTER TABLE `ruoli_audio`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`nome`),
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
	ADD KEY `indice` (`id`,`id_genitore`,`nome`,`html_entity`,`font_awesome`,`se_anagrafica`,`se_pagine`,`se_prodotti`,`se_articoli`,`se_categorie_prodotti`,`se_notizie`,`se_categorie_notizie`,`se_risorse`,`se_categorie_risorse`);

--| 030000034201

-- ruoli_audio
-- tipologia: tabella di supporto
ALTER TABLE `ruoli_audio` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000034400

-- ruoli_file
-- tipologia: tabella di supporto
-- verifica: 2021-10-11 18:14 Fabio Mosti
ALTER TABLE `ruoli_file`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`nome`),
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
	ADD KEY `indice` (`id`,`id_genitore`,`nome`,`html_entity`,`font_awesome`,`se_anagrafica`,`se_pagine`,`se_template`,`se_prodotti`,`se_articoli`,`se_categorie_prodotti`,`se_notizie`,`se_categorie_notizie`,`se_risorse`,`se_categorie_risorse`, `se_mail`);

--| 030000034401

-- ruoli_file
-- tipologia: tabella di supporto
ALTER TABLE `ruoli_file` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000034600

-- ruoli_immagini
-- tipologia: tabella di supporto
-- verifica: 2021-10-11 18:47 Fabio Mosti
ALTER TABLE `ruoli_immagini`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`nome`),
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
	ADD KEY `indice` (`id`,`id_genitore`,`ordine_scalamento`,`nome`,`html_entity`,`font_awesome`,`se_anagrafica`,`se_pagine`,`se_prodotti`,`se_articoli`,`se_categorie_prodotti`,`se_notizie`,`se_categorie_notizie`,`se_risorse`,`se_categorie_risorse`);

--| 030000034601

-- ruoli_immagini
-- tipologia: tabella di supporto
ALTER TABLE `ruoli_immagini` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000034800

-- ruoli_indirizzi
-- tipologia: tabella standard
-- verifica: 2021-10-12 10:46 Fabio Mosti
ALTER TABLE `ruoli_indirizzi`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`nome`),
	ADD KEY `id_genitore` (`id_genitore`), 
	ADD KEY `se_sede_legale` (`se_sede_legale`), 
	ADD KEY `se_sede_operativa` (`se_sede_operativa`), 
	ADD KEY `se_residenza` (`se_residenza`), 
	ADD KEY `se_domicilio` (`se_domicilio`), 
	ADD KEY `indice` (`id`,`id_genitore`,`nome`, `html_entity`, `font_awesome`, `se_sede_legale`, `se_sede_operativa`, `se_residenza`, `se_domicilio`);

--| 030000034801

-- ruoli_indirizzi
-- tipologia: tabella standard
ALTER TABLE `ruoli_indirizzi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000035000

-- ruoli_prodotti
-- tipologia: tabella di supporto
-- verifica: 2021-10-12 10:46 Fabio Mosti
ALTER TABLE `ruoli_prodotti`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`nome`),
	ADD KEY `id_genitore` (`id_genitore`), 
	ADD KEY `indice` (`id`,`id_genitore`,`nome`);

--| 030000035001

-- ruoli_prodotti
-- tipologia: tabella di supporto
ALTER TABLE `ruoli_prodotti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000035200

-- ruoli_video
-- tipologia: tabella di supporto
-- verifica: 2021-10-11 18:47 Fabio Mosti
ALTER TABLE `ruoli_video`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`nome`),
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
	ADD KEY `indice` (`id`,`id_genitore`,`nome`,`html_entity`,`font_awesome`,`se_anagrafica`,`se_pagine`,`se_prodotti`,`se_articoli`,`se_categorie_prodotti`,`se_notizie`,`se_categorie_notizie`,`se_risorse`,`se_categorie_risorse`);

--| 030000035201

-- ruoli_video
-- tipologia: tabella di supporto
ALTER TABLE `ruoli_video` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000037000

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

--| 030000037001

-- settori
-- tipologia: tabella di supporto
ALTER TABLE `settori` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000041000

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

--| 030000041001

-- sms_out
-- tipologia: tabella di supporto
ALTER TABLE `sms_out` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000041200

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

--| 030000041400

-- software
-- tipologia: tabella gestita
-- verifica: 2021-11-16 10:39 Chiara GDL
ALTER TABLE `software`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `id_articolo` (`id_articolo`),
	ADD KEY `json` (`json`(255) ),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_genitore`,`id_articolo`,`nome`,`json`(255));

--| 030000041401

-- software
-- tipologia: tabella di gestita
ALTER TABLE `software` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000042000

-- stati
-- tipologia: tabella di supporto
-- verifica: 2021-10-12 15:08 Fabio Mosti
ALTER TABLE `stati`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`codice_istat`),
	ADD UNIQUE KEY `unica_iso31661alpha2` (`iso31661alpha2`),
	ADD UNIQUE KEY `unica_iso31661alpha3` (`iso31661alpha3`),
	ADD KEY `id_continente` (`id_continente`),
	ADD KEY `indice` (`id`,`id_continente`,`nome`,`iso31661alpha2`,`iso31661alpha3`,`codice_istat`);

--| 030000042001

-- stati
-- tipologia: tabella di supporto
ALTER TABLE `stati` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000042200

-- stati_lingue
-- tipologia: tabella di supporto
-- verifica: 2021-10-12 15:42 Fabio Mosti
ALTER TABLE `stati_lingue`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_stato`,`id_lingua`),
	ADD KEY `id_stato` (`id_stato`),
	ADD KEY `id_lingua` (`id_lingua`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `indice` (`id`,`id_stato`,`id_lingua`,`ordine`);

--| 030000042201

-- stati_lingue
-- tipologia: tabella di supporto
ALTER TABLE `stati_lingue` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000043000

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

--| 030000043001

-- task
-- tipologia: tabella gestita
ALTER TABLE `task` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000043600

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

--| 030000043601

-- telefoni
-- tipologia: tabella gestita
ALTER TABLE `telefoni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000044000

-- template
-- tipologia: tabella gestita
-- verifica: 2021-10-15 12:36 Fabio Mosti
ALTER TABLE `template`
	ADD PRIMARY KEY (`id`),
  	ADD UNIQUE KEY `unica` (`ruolo`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  	ADD KEY `indice` (`ruolo`,`nome`,`tipo`,`latenza_invio`, `se_mail`,`se_sms`);

--| 030000044001

-- template
-- tipologia: tabella gestita
ALTER TABLE `template` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000045000

-- testate
-- tipologia: tabella gestita
-- verifica: 2021-09-10 11:57 Fabio Mosti
ALTER TABLE `testate`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `nome` (`nome`), 
	ADD KEY `indice` (`id`,`nome`);

--| 030000045001

-- testate
-- tipologia: tabella gestita
ALTER TABLE `testate` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000050000

-- tipologie_anagrafica
-- tipologia: tabella assistita
-- verifica: 2021-10-15 16:17 Fabio Mosti
ALTER TABLE `tipologie_anagrafica`
	ADD PRIMARY KEY (`id`),
  	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `nome` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`,`se_persona_fisica`);

--| 030000050001

-- tipologie_anagrafica
-- tipologia: tabella assistita
ALTER TABLE `tipologie_anagrafica` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000050400

-- tipologie_attivita
-- tipologia: tabella assistita
-- verifica: 2021-10-15 16:17 Fabio Mosti
ALTER TABLE `tipologie_attivita`
	ADD PRIMARY KEY (`id`),
  	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `nome` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`,`se_anagrafica`,`se_agenda`);

--| 030000050401

-- tipologie_attivita
-- tipologia: tabella assistita
ALTER TABLE `tipologie_attivita` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000050600

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

--| 030000050601

-- tipologie_chiavi
-- tipologia: tabella assistita
ALTER TABLE `tipologie_chiavi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000050800

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

--| 030000050801

-- tipologie_contatti
-- tipologia: tabella assistita
ALTER TABLE `tipologie_contatti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000052600

-- tipologie_documenti
-- tipologia: tabella assistita
-- verifica: 2021-10-15 16:17 Fabio Mosti
ALTER TABLE `tipologie_documenti`
	ADD PRIMARY KEY (`id`),
  	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `nome` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`,`se_fattura`,`se_nota_credito`,`se_trasporto`,`se_pro_forma`,`se_offerta`,`se_ordine`,`se_ricevuta`);

--| 030000052601

-- tipologie_documenti
-- tipologia: tabella assistita
ALTER TABLE `tipologie_documenti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000053000

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

--| 030000053001

-- tipologie_indirizzi
-- tipologia: tabella assistita
ALTER TABLE `tipologie_indirizzi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000053200

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

--| 030000053201

-- tipologie_licenze
-- tipologia: tabella assistita
ALTER TABLE `tipologie_licenze` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000053400

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

--| 030000053401

-- tipologie_mastri
-- tipologia: tabella assistita
ALTER TABLE `tipologie_mastri` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000053800

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

--| 030000053801

-- tipologie_notizie
-- tipologia: tabella assistita
ALTER TABLE `tipologie_notizie` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000054000

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

--| 030000054001

-- tipologie_pagamenti
-- tipologia: tabella assistita
ALTER TABLE `tipologie_pagamenti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000054200

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

--| 030000054201

-- tipologie_popup
-- tipologia: tabella assistita
ALTER TABLE `tipologie_popup` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000054600

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

--| 030000054601

-- tipologie_prodotti
-- tipologia: tabella assistita
ALTER TABLE `tipologie_prodotti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000055000

-- tipologie_progetti
-- tipologia: tabella assistita
-- verifica: 2021-10-15 16:17 Fabio Mosti
ALTER TABLE `tipologie_progetti`
	ADD PRIMARY KEY (`id`),
  	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `nome` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`);

--| 030000055001

-- tipologie_progetti
-- tipologia: tabella assistita
ALTER TABLE `tipologie_progetti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000055400

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

--| 030000055401

-- tipologie_pubblicazioni
-- tipologia: tabella assistita
ALTER TABLE `tipologie_pubblicazioni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000055800

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

--| 030000055801

-- tipologie_risorse
-- tipologia: tabella assistita
ALTER TABLE `tipologie_risorse` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000056200

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

--| 030000056201

-- tipologie_telefoni
-- tipologia: tabella assistita
ALTER TABLE `tipologie_telefoni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000056600

-- tipologie_todo
-- tipologia: tabella assistita
-- verifica: 2021-10-15 16:17 Fabio Mosti
ALTER TABLE `tipologie_todo`
	ADD PRIMARY KEY (`id`),
  	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `nome` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`);

--| 030000056601

-- tipologie_todo
-- tipologia: tabella assistita
ALTER TABLE `tipologie_todo` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000056800

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

--| 030000056801

-- tipologie_url
-- tipologia: tabella assistita
ALTER TABLE `tipologie_url` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000060000

-- todo
-- tipologia: tabella gestita
-- verifica: 2021-10-15 16:17 Fabio Mosti
ALTER TABLE `todo`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_tipologia` (`id_tipologia`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_cliente` (`id_cliente`), 
	ADD KEY `id_indirizzo` (`id_indirizzo`), 
	ADD KEY `id_luogo` (`id_luogo`), 
	ADD KEY `id_contatto` (`id_contatto`), 
	ADD KEY `id_progetto` (`id_progetto`), 
	ADD KEY `id_pianificazione` (`id_pianificazione`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`id_tipologia`,`id_anagrafica`,`id_cliente`,`id_indirizzo`,`id_luogo`,`data_scadenza`,`ora_scadenza`,`data_programmazione`,`ora_inizio_programmazione`,`ora_fine_programmazione`,`anno_programmazione`,`settimana_programmazione`,`data_chiusura`,`id_contatto`,`id_progetto`),
	ADD KEY `indice_pianificazione` (`id`,`id_tipologia`,`id_anagrafica`,`id_cliente`,`id_indirizzo`,`id_luogo`,`data_programmazione`,`ora_inizio_programmazione`,`ora_fine_programmazione`,`anno_programmazione`,`settimana_programmazione`,`id_contatto`,`id_progetto`,`id_pianificazione`),
	ADD KEY `indice_archiviazione` (`id`,`id_tipologia`,`id_anagrafica`,`id_cliente`,`id_indirizzo`,`id_luogo`,`data_programmazione`,`ora_inizio_programmazione`,`ora_fine_programmazione`,`anno_programmazione`,`settimana_programmazione`,`id_contatto`,`id_progetto`,`id_pianificazione`,`data_archiviazione`); 

--| 030000060001

-- todo
-- tipologia: tabella gestita
ALTER TABLE `todo` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000062000

-- udm
-- tipologia: tabella di supporto
-- verifica: 2021-10-19 13:02 Fabio Mosti
ALTER TABLE `udm`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_genitore`,`sigla`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `indice` (`id`,`id_genitore`,`conversione`,`nome`,`sigla`,`se_lunghezza`,`se_peso`,`se_quantita`);

--| 030000062001

-- udm
-- tipologia: tabella di supporto
ALTER TABLE `udm` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000062600

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

--| 030000062601

-- url
-- tipologia: tabella di supporto
ALTER TABLE `url` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000063000

-- valute
-- tipologia: tabella di supporto
-- verifica: 2021-10-19 13:21 Fabio Mosti
ALTER TABLE `valute`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`iso4217`),
	ADD KEY `indice` (`id`,`iso4217`,`html_entity`,`utf8`);

--| 030000063001

-- valute
-- tipologia: tabella di supporto
ALTER TABLE `valute` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000065000

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
 	ADD KEY `id_categoria_notizie` (`id_categoria_notizie`), 
 	ADD KEY `id_lingua` (`id_lingua`), 
 	ADD KEY `id_ruolo` (`id_ruolo`), 
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

--| 030000065001

-- video
-- tipologia: tabella gestita
ALTER TABLE `video` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| FINE FILE
