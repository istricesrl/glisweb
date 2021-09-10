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
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `se_attivo` (`se_attivo`),
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
	ADD KEY `indice` (`id`,`id_account`,`id_gruppo`);

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
	ADD KEY `indice` (`id`,`id_account`,`id_gruppo`,`entita`);

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
	ADD KEY `id_regime_fiscale` (`id_regime_fiscale`),
	ADD KEY `id_stato_nascita` (`id_stato_nascita`),
	ADD KEY `id_comune_nascita` (`id_comune_nascita`),
	ADD KEY `id_tipologia_crm` (`id_tipologia_crm`),	
	ADD KEY `id_agente` (`id_agente`),
	ADD KEY `id_responsabile_operativo` (`id_responsabile_operativo`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `se_importata` (`se_importata`),
	ADD KEY `se_stampa_privacy` (`se_stampa_privacy`),
	ADD KEY `indice` (`id`,`codice`,`nome`,`cognome`,`id_tipologia`,`denominazione`,`se_stampa_privacy`,`codice_fiscale`,`partita_iva`),
	ADD KEY `indice_riferimento` (`id`,`riferimento`);

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
	ADD KEY `indice` (`id`,`id_anagrafica`,`id_categoria`);

--| 030000000501

-- anagrafica_categorie
-- tipologia: tabella gestita
ALTER TABLE `anagrafica_categorie` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000600

-- anagrafica_categorie_diritto
-- tipologia: tabella gestita
-- verifica: 2021-05-20 19:33 Fabio Mosti
ALTER TABLE `anagrafica_categorie_diritto`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_anagrafica`,`id_diritto`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_diritto` (`id_diritto`),
	ADD KEY `se_specialita` (`se_specialita`),
	ADD KEY `indice` (`id`,`id_anagrafica`,`id_diritto`,`se_specialita`);

--| 030000000601

-- anagrafica_categorie_diritto
-- tipologia: tabella gestita
ALTER TABLE `anagrafica_categorie_diritto` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000700

-- anagrafica_cittadinanze
-- tipologia: tabella gestita
-- verifica: 2021-05-20 21:26 Fabio Mosti
ALTER TABLE `anagrafica_cittadinanze`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_anagrafica`,`id_stato`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_stato` (`id_stato`),
	ADD KEY `indice` (`id`,`id_anagrafica`,`id_stato`,`data_inizio`,`data_fine`);

--| 030000000701

-- anagrafica_cittadinanze
-- tipologia: tabella gestita
ALTER TABLE `anagrafica_cittadinanze` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000800

-- anagrafica_condizioni_pagamento
-- tipologia: tabella gestita
-- verifica: 2021-05-20 21:59 Fabio Mosti
ALTER TABLE `anagrafica_condizioni_pagamento`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_anagrafica`,`id_condizione`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_condizione` (`id_condizione`),
	ADD KEY `indice` (`id`,`id_anagrafica`,`id_condizione`);

--| 030000000801

-- anagrafica_condizioni_pagamento
-- tipologia: tabella gestita
ALTER TABLE `anagrafica_condizioni_pagamento` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000900

-- anagrafica_indirizzi
-- tipologia: tabella gestita
-- verifica: 2021-05-21 16:34 Fabio Mosti
ALTER TABLE `anagrafica_indirizzi`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_anagrafica`,`id_indirizzo`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_tipologia` (`id_tipologia`),
	ADD KEY `id_indirizzo` (`id_indirizzo`), 
	ADD KEY `indice` (`id`,`id_anagrafica`,`id_indirizzo`,`id_tipologia`);

--| 030000000901

-- anagrafica_indirizzi
-- tipologia: tabella gestita
ALTER TABLE `anagrafica_indirizzi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000001000

-- anagrafica_modalita_pagamento
-- tipologia: tabella gestita
-- verifica: 2021-05-22 16:23 Fabio Mosti
ALTER TABLE `anagrafica_modalita_pagamento`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_anagrafica`,`id_modalita`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_modalita` (`id_modalita`),
	ADD KEY `indice` (`id`,`id_anagrafica`,`id_modalita`);

--| 030000001001

-- anagrafica_modalita_pagamento
-- tipologia: tabella gestita
ALTER TABLE `anagrafica_modalita_pagamento` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000001100

-- anagrafica_ruoli
-- tipologia: tabella gestita
-- verifica: 2021-05-23 14:39 Fabio Mosti
ALTER TABLE `anagrafica_ruoli`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_genitore`,`id_anagrafica`,`id_ruolo`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_ruolo` (`id_ruolo`),
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`id_anagrafica`,`id_ruolo`);

--| 030000001101

-- anagrafica_ruoli
-- tipologia: tabella gestita
ALTER TABLE `anagrafica_ruoli` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000001200

-- anagrafica_settori
-- tipologia: tabella gestita
-- verifica: 2021-05-23 15:28 Fabio Mosti
ALTER TABLE `anagrafica_settori`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_anagrafica`,`id_settore`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_settore` (`id_settore`),
	ADD KEY `indice` (`id`,`id_anagrafica`,`id_settore`);

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
	ADD KEY `id_tipologia_inps` (`id_tipologia_inps`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_cliente` (`id_cliente`), 
	ADD KEY `id_indirizzo` (`id_indirizzo`), 
	ADD KEY `id_luogo` (`id_luogo`), 
	ADD KEY `id_progetto` (`id_progetto`), 
	ADD KEY `id_todo` (`id_todo`), 
	ADD KEY `id_campagna` (`id_campagna`), 
	ADD KEY `id_immobile` (`id_immobile`), 
	ADD KEY `id_richiesta` (`id_richiesta`), 
	ADD KEY `id_todo_articoli` (`id_todo_articoli`),
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
	ADD KEY `id_tipologia_embed` (`id_tipologia_embed`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_pagina` (`id_pagina`), 
	ADD KEY `id_file` (`id_file`), 
	ADD KEY `id_risorsa` (`id_risorsa`), 
	ADD KEY `id_prodotto` (`id_prodotto`), 
	ADD KEY `id_categoria_prodotti` (`id_categoria_prodotti`), 
	ADD KEY `id_notizia` (`id_notizia`), 
	ADD KEY `id_categoria_notizie` (`id_categoria_notizie`),
	ADD KEY `id_evento` (`id_evento`), 
	ADD KEY `id_categoria_eventi` (`id_categoria_eventi`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`id_ruolo`,`id_lingua`,`ordine`,`path`,`codice_embed`,`id_tipologia_embed`),
	ADD KEY `indice_anagrafica` (`id`,`id_ruolo`,`id_lingua`,`ordine`,`path`,`codice_embed`,`id_tipologia_embed`,`id_anagrafica`),
	ADD KEY `indice_pagine` (`id`,`id_ruolo`,`id_lingua`,`ordine`,`path`,`codice_embed`,`id_tipologia_embed`,`id_pagina`,`id_file`,`id_risorsa`);

--| 030000002101

-- audio
-- tipologia: tabella gestita
ALTER TABLE `audio` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000002500

-- campagne
-- tipologia: tabella gestita
-- verifica: 2021-05-28 17:50 Fabio Mosti
ALTER TABLE `campagne`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `nome` (`nome`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`nome`,`timestamp_apertura`,`timestamp_chiusura`);

--| 030000002501

-- campagne
-- tipologia: tabella gestita
ALTER TABLE `campagne` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000002700

-- caratteristiche_immobili
-- tipologia: tabella di supporto
-- verifica: 2021-05-28 18:27 Fabio Mosti
ALTER TABLE `caratteristiche_immobili`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_tipologia`,`nome`),
	ADD KEY `id_tipologia` (`id_tipologia`), 
	ADD KEY `indice` (`id`,`id_tipologia`,`nome`,`se_indirizzo`,`se_immobile`);

--| 030000002701

-- caratteristiche_immobili
-- tipologia: tabella di supporto
ALTER TABLE `caratteristiche_immobili` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000002900

-- caratteristiche_prodotti
-- tipologia: tabella gestita
-- verifica: 2021-05-28 18:27 Fabio Mosti
ALTER TABLE `caratteristiche_prodotti`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_tipologia`,`nome`),
	ADD KEY `id_tipologia` (`id_tipologia`), 
	ADD KEY `indice` (`id`,`id_tipologia`,`nome`,`se_categoria`,`se_prodotto`,`se_articolo`);

--| 030000002901

-- caratteristiche_prodotti
-- tipologia: tabella gestita
ALTER TABLE `caratteristiche_prodotti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000003100

-- categorie_anagrafica
-- tipologia: tabella assistita
-- verifica: 2021-05-28 19:56 Fabio Mosti
ALTER TABLE `categorie_anagrafica`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `se_lead` (`se_lead`), 
	ADD KEY `se_prospect` (`se_prospect`), 
	ADD KEY `se_cliente` (`se_cliente`), 
	ADD KEY `se_mandante` (`se_mandante`), 
	ADD KEY `se_fornitore` (`se_fornitore`), 
	ADD KEY `se_produttore` (`se_produttore`), 
	ADD KEY `se_collaboratore` (`se_collaboratore`), 
	ADD KEY `se_dipendente` (`se_dipendente`),
	ADD KEY `se_interinale` (`se_interinale`), 
	ADD KEY `se_interno` (`se_interno`), 
	ADD KEY `se_esterno` (`se_esterno`), 
	ADD KEY `se_agente` (`se_agente`), 
	ADD KEY `se_concorrente` (`se_concorrente`), 
	ADD KEY `se_rassegna_stampa` (`se_rassegna_stampa`), 
	ADD KEY `se_azienda_gestita` (`se_azienda_gestita`), 
	ADD KEY `se_amministrazione` (`se_amministrazione`), 
	ADD KEY `se_notizie` (`se_notizie`), 
	ADD KEY `se_docente` (`se_docente`), 
	ADD KEY `se_tutor` (`se_tutor`), 
	ADD KEY `se_classe` (`se_classe`), 
	ADD KEY `se_allievo` (`se_allievo`), 
	ADD KEY `se_agenzia_interinale` (`se_agenzia_interinale`), 
	ADD KEY `se_referente` (`se_referente`),
	ADD KEY `se_sostituto` (`se_sostituto`),
	ADD KEY `se_squadra` (`se_squadra`),
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`se_rassegna_stampa`,`se_agente`,`se_mandante`,`se_fornitore`,`se_collaboratore`,`se_interno`,`se_esterno`,`se_concorrente`,`se_interinale`,`se_agenzia_interinale`,`se_dipendente`,`se_referente`,`se_sostituto`,`se_squadra`, `se_azienda_gestita`, `se_amministrazione`, `se_prospect`, `se_lead`, `se_docente`,`se_tutor`,`se_classe`,`se_allievo`,`se_sostituto`);

--| 030000003101

-- categorie_anagrafica
-- tipologia: tabella assistita
ALTER TABLE `categorie_anagrafica` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000003300

-- categorie_diritto
-- tipologia: tabella di supporto
-- verifica: 2021-06-01 10:44 Fabio Mosti
ALTER TABLE `categorie_diritto`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `id_pagina` (`id_pagina`), 
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`id_pagina`);

--| 030000003301

-- categorie_diritto
-- tipologia: tabella di supporto
ALTER TABLE `categorie_diritto` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000003500

-- categorie_eventi
-- tipologia: tabella gestita
-- verifica: 2021-06-01 17:37 Fabio Mosti
ALTER TABLE `categorie_eventi`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`), 
	ADD KEY `id_pagina` (`id_pagina`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`id_pagina`);

--| 030000003501

-- categorie_eventi
-- tipologia: tabella gestita
ALTER TABLE `categorie_eventi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;

--| 030000003700

-- categorie_notizie
-- tipologia: tabella gestita
-- verifica: 2021-06-01 18:28 Fabio Mosti
ALTER TABLE `categorie_notizie`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`), 
	ADD KEY `id_pagina` (`id_pagina`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`id_pagina`);

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
	ADD KEY `id_pagina` (`id_pagina`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`id_pagina`);

--| 030000003901

-- categorie_prodotti
-- tipologia: tabella gestita
ALTER TABLE `categorie_prodotti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000004100

-- categorie_prodotti_caratteristiche
-- tipologia: tabella gestita
-- verifica: 2021-06-02 19:14 Fabio Mosti
ALTER TABLE `categorie_prodotti_caratteristiche`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_categoria`,`id_caratteristica`), 
	ADD KEY `id_categoria` (`id_categoria`),
	ADD KEY `id_caratteristica` (`id_caratteristica`),
	ADD KEY `indice` (`id`,`id_categoria`,`id_caratteristica`,`ordine`, `se_assente`, `se_visibile`);

--| 030000004101

-- categorie_prodotti_caratteristiche
-- tipologia: tabella gestita
ALTER TABLE `categorie_prodotti_caratteristiche` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

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
	ADD KEY `se_ordinario` (`se_ordinario`), 
	ADD KEY `se_straordinario` (`se_straordinario`), 
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`se_ordinario`,`se_straordinario`);

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

--| 030000004700

-- classi_energetiche
-- tipologia: tabella di supporto
-- verifica: 2021-06-02 20:38 Fabio Mosti
ALTER TABLE `classi_energetiche`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_colore` (`id_colore`),
	ADD KEY `se_immobili` (`se_immobili`), 
	ADD KEY `se_prodotti` (`se_prodotti`), 
	ADD KEY `indice` (`id`, `nome`, `id_colore`, `se_immobili`, `se_prodotti`);

--| 030000004701

-- classi_energetiche
-- tipologia: tabella di supporto
ALTER TABLE `classi_energetiche` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

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
	ADD KEY `id_campagna` (`id_campagna`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_inviante` (`id_inviante`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `timestamp_contatto` (`timestamp_contatto`), 
	ADD KEY `indice` (`id`, `id_tipologia`, `id_campagna`, `id_anagrafica`,`id_inviante`,`nome`,`timestamp_contatto`);

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
	ADD UNIQUE KEY `unica_immobile` (`id_lingua`,`id_immobile`), 
	ADD UNIQUE KEY `unica_indirizzo` (`id_lingua`,`id_indirizzo`), 
	ADD UNIQUE KEY `unica_zona` (`id_lingua`,`id_zona`), 
	ADD UNIQUE KEY `unica_rassegna_stampa` (`id_lingua`,`id_rassegna_stampa`),
	ADD UNIQUE KEY `unica_evento` (`id_lingua`,`id_evento`), 
	ADD UNIQUE KEY `unica_categoria_eventi` (`id_lingua`,`id_categoria_eventi`), 
	ADD UNIQUE KEY `unica_notizia` (`id_lingua`,`id_notizia`), 
	ADD UNIQUE KEY `unica_categoria_notizie` (`id_lingua`,`id_categoria_notizie`), 
	ADD UNIQUE KEY `unica_data` (`id_lingua`,`id_data`), 
	ADD UNIQUE KEY `unica_template_mail` (`id_lingua`,`id_template_mail`), 
	ADD UNIQUE KEY `unica_mailing` (`id_lingua`,`id_mailing`), 
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
	ADD KEY `id_immobile` (`id_immobile`), 
	ADD KEY `id_indirizzo` (`id_indirizzo`), 
	ADD KEY `id_zona` (`id_zona`), 
	ADD KEY `id_rassegna_stampa` (`id_rassegna_stampa`), 
	ADD KEY `id_evento` (`id_evento`), 
	ADD KEY `id_categoria_eventi` (`id_categoria_eventi`), 
	ADD KEY `id_notizia` (`id_notizia`), 
	ADD KEY `id_categoria_notizie` (`id_categoria_notizie`), 
	ADD KEY `id_data` (`id_data`),
	ADD KEY `id_template_mail` (`id_template_mail`), 
	ADD KEY `id_mailing` (`id_mailing`), 
	ADD KEY `id_colore` (`id_colore`), 
	ADD KEY `indice` (`id`,`id_lingua`),
	ADD KEY `indice_anagrafica` (`id`,`id_lingua`,`id_anagrafica`),
	ADD KEY `indice_prodotti` (`id`,`id_lingua`,`id_prodotto`,`id_articolo`,`id_categoria_prodotti`,`id_marchio`),
	ADD KEY `indice_immagini` (`id`,`id_lingua`,`id_immagine`),
	ADD KEY `indice_file` (`id`,`id_lingua`,`id_file`),
	ADD KEY `indice_risorse` (`id`,`id_lingua`,`id_risorsa`,`id_categoria_risorse`),
	ADD KEY `indice_pagine` (`id`,`id_lingua`,`id_pagina`,`id_popup`),
	ADD KEY `indice_immobili` (`id`,`id_lingua`,`id_immobile`,`id_indirizzo`,`id_zona`),
	ADD KEY `indice_rassegna_stampa` (`id`,`id_lingua`,`id_rassegna_stampa`,`id_categoria_rassegna_stampa`),
	ADD KEY `indice_eventi` (`id`,`id_lingua`,`id_evento`,`id_categoria_eventi`),
	ADD KEY `indice_notizie` (`id`,`id_lingua`,`id_notizie`,`id_categoria_notizie`),
	ADD KEY `indice_video` (`id`,`id_lingua`,`id_video`),
	ADD KEY `indice_audio` (`id`,`id_lingua`,`id_audio`),
	ADD KEY `indice_data` (`id`,`id_lingua`,`id_data`),
	ADD KEY `indice_template_mail` (`id`,`id_lingua`,`id_template_mail`),
	ADD KEY `indice_mailing` (`id`,`id_lingua`,`id_mailing`),
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

--| 030000007600

-- contratti
-- tipologia: tabella gestita
-- verifica: 2021-06-09 12:47 Fabio Mosti
ALTER TABLE `contratti`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_tipologia` (`id_tipologia`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_azienda` (`id_azienda`),
	ADD KEY `id_agenzia` (`id_agenzia`),
	ADD KEY `id_livello` (`id_livello`), 
	ADD KEY `id_qualifica` (`id_qualifica`), 
	ADD KEY `id_tipologia_durata` (`id_tipologia_durata`), 
	ADD KEY `id_tipologia_orario` (`id_tipologia_orario`),
	ADD KEY `indice` (`id`,`id_tipologia`,`id_anagrafica`,`id_azienda`,`id_agenzia`, `data_stipula`, `data_inizio`, `data_fine`, `data_inizio_rapporto`, `data_fine_rapporto`, `id_livello`, `id_qualifica`, `id_tipologia_durata`, `id_tipologia_orario`);

--| 030000007601

-- contratti
-- tipologia: tabella gestita
ALTER TABLE `contratti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000007700

-- correlazioni_articoli
-- tipologia: tabella gestita
-- verifica: 2021-05-26 11:59 Fabio Mosti
ALTER TABLE `correlazioni_articoli`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica_prodotto` (`id_tipologia`,`id_articolo`,`id_prodotto_correlato`), 
	ADD UNIQUE KEY `unica_articolo` (`id_tipologia`,`id_articolo`,`id_articolo_correlato`), 
	ADD KEY `id_tipologia` (`id_tipologia`),
	ADD KEY `id_articolo` (`id_articolo`),
	ADD KEY `id_prodotto_correlato` (`id_prodotto_correlato`),
	ADD KEY `id_articolo_correlato` (`id_articolo_correlato`),
	ADD KEY `indice` (`id`,`id_tipologia`,`id_articolo`,`id_prodotto_correlato`,`id_prodotto_correlato`,`ordine`,`se_upselling`,`se_crosselling` );

--| 030000007701

-- correlazioni_articoli
-- tipologia: tabella gestita
ALTER TABLE `correlazioni_articoli` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000007800

-- costi_contratti
-- tipologia: tabella gestita
-- verifica: 2021-06-09 12:47 Fabio Mosti
ALTER TABLE `costi_contratti`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_contratto`,`id_tipologia_inps_attivita`),
	ADD KEY `id_contratto` (`id_contratto`),
	ADD KEY `id_tipologia_inps_attivita` (`id_tipologia_inps_attivita`),
	ADD KEY `indice` (`id`,`id_contratto`,`id_tipologia_inps_attivita`,`costo_orario`);

--| 030000007801

-- costi_contratti
-- tipologia: tabella gestita
ALTER TABLE `costi_contratti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000008000

-- coupon
-- tipologia: tabella gestita
-- verifica: 2021-06-29 15:50 Fabio Mosti
ALTER TABLE `coupon`
	ADD PRIMARY KEY (`id`),
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
	ADD KEY `indice` (`id`,`id_coupon`,`id_categoria`);

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
	ADD KEY `indice` (`id`,`id_coupon`,`id_listino`);

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
	ADD KEY `indice` (`id`,`id_coupon`,`id_marchio`);

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
	ADD KEY `indice` (`id`,`id_coupon`,`id_prodotto`);

--| 030000008801

-- coupon_prodotti
-- tipologia: tabella gestita
ALTER TABLE `coupon_prodotti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000009000

-- coupon_stagioni
-- tipologia: tabella gestita
-- verifica: 2021-06-29 17:02 Fabio Mosti
ALTER TABLE `coupon_stagioni`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_coupon`,`id_stagione`),
	ADD KEY `id_coupon` (`id_coupon`), 
	ADD KEY `id_stagione` (`id_stagione`),
	ADD KEY `indice` (`id`,`id_coupon`,`id_stagione`);

--| 030000009001

-- coupon_stagioni
-- tipologia: tabella gestita
ALTER TABLE `coupon_stagioni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000009200

-- cron
-- tipologia: tabella assistita
-- verifica: 2021-06-30 11:53 Fabio Mosti
ALTER TABLE `cron`
 	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`minuto`,`ora`,`giorno_del_mese`,`mese`,`giorno_della_settimana`,`settimana`,`task`,`iterazioni`,`delay`,`token`,`timestamp_esecuzione`);

--| 030000009201

-- cron
-- tipologia: tabella assistita
ALTER TABLE `cron` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000009400

-- date
-- tipologia: tabella gestita
-- verifica: 2021-09-03 17:09 Fabio Mosti
ALTER TABLE `date`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_tipologia` (`id_tipologia`), 
	ADD KEY `id_evento` (`id_evento`), 
	ADD KEY `id_luogo` (`id_luogo`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`id_tipologia`,`id_evento`,`id_luogo`,`timestamp_inizio`,`timestamp_fine`);

--| 030000009401

-- date
-- tipologia: tabella gestita
ALTER TABLE `date` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

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
	ADD KEY `id_valuta` (`id_valuta`), 
	ADD KEY `id_iva` (`id_iva`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `data` (`data`), 
	ADD KEY `quantita` (`quantita`), 
	ADD KEY `importo_netto_totale` (`importo_netto_totale`), 
	ADD KEY `indice` (`id`,`id_genitore`,`id_tipologia`,`ordine`,`id_documento`,`data`,`id_emittente`,`id_destinatario`,`id_reparto`,`id_progetto`,`id_todo`,`id_attivita`,`id_articolo`,`id_mastro_provenienza`,`id_mastro_destinazione`,`id_udm`,`quantita`,`id_listino`,`id_valuta`,`importo_netto_totale`,`id_iva`);

--| 030000010001

-- documenti_articoli
-- tipologia: tabella gestita
ALTER TABLE `documenti_articoli` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

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
	ADD UNIQUE KEY `unica_template_mail` (`id_template_mail`,`id_ruolo`,`path`), 
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
	ADD KEY `id_template_mail` (`id_template_mail`), 
	ADD KEY `id_notizia` (`id_notizia`), 
	ADD KEY `id_categoria_notizie` (`id_categoria_notizie`), 
	ADD KEY `id_risorsa` (`id_risorsa`),
	ADD KEY `id_categoria_risorse` (`id_categoria_risorse`), 
	ADD KEY `id_lingua` (`id_lingua`), 
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
	ADD KEY `indice_template_mail` (`id`,`id_ruolo`,`id_template_mail`,`id_lingua`,`path`,`url`),
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
	ADD KEY `id_struttura` (`id_struttura`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`id_genitore`,`id_struttura`,`nome`);

--| 030000015201
 
-- gruppi
-- tipologia: tabella gestita
ALTER TABLE `gruppi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000077

-- iban
-- tipologia: tabella gestita
ALTER TABLE `iban`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`),
	ADD KEY `indice` (`id`,`id_anagrafica`,`iban`);
ALTER TABLE `iban` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000078
 
-- immagini
-- tipologia: tabella gestita
ALTER TABLE `immagini`
 	ADD PRIMARY KEY (`id`), 
 	ADD UNIQUE KEY `unica_anagrafica` (`id_anagrafica`,`id_ruolo`,`path`), 
 	ADD UNIQUE KEY `unica_pagina` (`id_pagina`,`id_ruolo`,`path`), 
 	ADD UNIQUE KEY `unica_file` (`id_file`,`id_ruolo`,`path`), 
 	ADD UNIQUE KEY `unica_prodotto` (`id_prodotto`,`id_ruolo`,`path`), 
 	ADD UNIQUE KEY `categoria_prodotti_unica` (`id_categoria_prodotti`,`id_ruolo`,`path`), 
 	ADD UNIQUE KEY `unica_evento` (`id_eventa`,`id_ruolo`,`path`), 
 	ADD UNIQUE KEY `unica_categoria_eventi` (`id_categoria_eventi`,`id_ruolo`,`path`), 
 	ADD KEY `path` (`path`), 
 	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
 	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
 	ADD KEY `id_pagina` (`id_pagina`), 
 	ADD KEY `id_file` (`id_file`), 
 	ADD KEY `id_prodotto` (`id_prodotto`), 
 	ADD KEY `id_categoria_prodotti` (`id_categoria_prodotti`), 
 	ADD KEY `id_evento` (`id_evento`), 
 	ADD KEY `id_ruolo` (`id_ruolo`), 
 	ADD KEY `id_anagrafica` (`id_anagrafica`), 
 	ADD KEY `id_categoria_eventi` (`id_categoria_eventi`), 
 	ADD KEY `id_notizia` (`id_notizia`), 
 	ADD KEY `id_categoria_notizie` (`id_categoria_notizie`), 
 	ADD KEY `id_indirizzo` (`id_indirizzo`), 
 	ADD KEY `id_immobile` (`id_immobile`), 
 	ADD KEY `id_zona` (`id_zona`), 
 	ADD KEY `id_articolo` (`id_articolo`), 
 	ADD KEY `id_testata` (`id_testata`), 
 	ADD KEY `id_lingua` (`id_lingua`), 
 	ADD KEY `id_categoria_risorse` (`id_categoria_risorse`), 
 	ADD KEY `id_risorsa` (`id_risorsa`),
	ADD KEY `indice` (`id`,`path`,`nome`,`ordine`,`token`,`id_ruolo`,`id_file`,`ordine`,`anno`,`id_anagrafica`,`id_pagina`,`id_notizia`,`id_prodotto`,`id_categoria_prodotti`,`id_evento`,`id_categoria_eventi`);
ALTER TABLE `immagini` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000079
 
-- immagini_anagrafica
-- tipologia: tabella gestita
ALTER TABLE `immagini_anagrafica`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_anagrafica` (`id_anagrafica`),
	ADD KEY `id_ruolo` (`id_ruolo`), 
	ADD KEY `id_rassegna_stampa` (`id_immagine`),
	ADD KEY `indice` (`id`,`id_anagrafica`,`id_ruolo`,`id_immagine`);
ALTER TABLE `immagini_anagrafica` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
 
--| 030000000080
  
-- immobili_caratteristiche
-- tipologia: tabella gestita
ALTER TABLE `immobili_caratteristiche`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_immobile`,`id_caratteristica`), 
	ADD KEY `id_immobile` (`id_immobile`), 
	ADD KEY `id_caratteristica` (`id_caratteristica`),
	ADD KEY `indice` (`id`,`id_immobile`,`id_caratteristica`);
ALTER TABLE `immobili_caratteristiche` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000081
  
-- incarichi_immobili
-- tipologia: tabella gestita
ALTER TABLE `incarichi_immobili`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `id` (`id`), 
	ADD UNIQUE KEY `incarico_unico` (`id_immobile`,`id_agenzia`,`data_inizio`), 
	ADD KEY `id_agenzia` (`id_agenzia`), 
	ADD KEY `id_immobile` (`id_immobile`), 
	ADD KEY `id_tipologia` (`id_tipologia`), 
	ADD KEY `id_cliente` (`id_cliente`), 
	ADD KEY `id_esito` (`id_esito_incarico`), 
	ADD KEY `id_agente` (`id_agente`), 
	ADD KEY `id_esito_incarico` (`id_esito_incarico`), 
	ADD KEY `id_esito_notizia` (`id_esito_notizia`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `id_account_editor` (`id_account_editor`),
	ADD KEY `indice` (`id`,`id_immobile`,`id_agenzia`,`data_inizio`,`id_tipologia`,`id_cliente`);
ALTER TABLE `incarichi_immobili` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000082

-- incroci_immobili
-- tipologia: tabella gestita
ALTER TABLE `incroci_immobili`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_incarico`,`id_richiesta`), 
	ADD KEY `id_incarico` (`id_incarico`), 
	ADD KEY `id_richiesta` (`id_richiesta`), 
	ADD KEY `id_esito` (`id_esito`),
	ADD KEY `indice` (`id`,`id_incarico`,`id_richiesta`);
ALTER TABLE `incroci_immobili` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000083

-- indirizzi
-- tipologia: tabella gestita
ALTER TABLE `indirizzi`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`indirizzo`,`civico`,`cap`,`id_comune`),
	ADD KEY `id_comune` (`id_comune`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_tipologia` (`id_tipologia`), 
	ADD KEY `id_zona` (`id_zona`), 
	ADD KEY `id_tipologia_edificio` (`id_tipologia_edificio`), 
	ADD KEY `id_condizione` (`id_condizione`), 
	ADD KEY `id_agente` (`id_agente`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `id_account_editor` (`id_account_editor`),
	ADD KEY `indice` (`id`,`indirizzo`,`civico`,`cap`,`id_comune`,`id_tipologia`,`id_agente`);
ALTER TABLE `indirizzi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000084
  
-- indirizzi_caratteristiche
-- tipologia: tabella gestita
ALTER TABLE `indirizzi_caratteristiche`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_indirizzo`,`id_caratteristica`), 
	ADD KEY `id_indirizzo` (`id_indirizzo`), 
	ADD KEY `id_caratteristica` (`id_caratteristica`),
	ADD KEY `indice` (`id`,`id_indirizzo`,`id_caratteristica`);
ALTER TABLE `indirizzi_caratteristiche` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=4;

--| 030000000085

-- ingombri
-- tipologia: tabella gestita
ALTER TABLE `ingombri`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `nome` (`nome`),
	ADD KEY `min` (`min`),
	ADD KEY `max` (`max`),
	ADD KEY `indice` (`id`,`nome`,`min`,`max`);
ALTER TABLE `ingombri` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000086

-- iva
-- tipologia: tabella di supporto
ALTER TABLE `iva`
	ADD PRIMARY KEY (`id`),
	ADD KEY `aliquota` (`aliquota`),
	ADD KEY `indice` (`id`,`aliquota`,`nome`,`codice`);
ALTER TABLE `iva` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000087

-- job
-- tipologia: tabella gestita
ALTER TABLE `job`
	ADD PRIMARY KEY (`id`),
	ADD KEY `indice` (`id`,`nome`,`timestamp_apertura`,`corrente`,`delay`,`workspace`,`timestamp_esecuzione`,`timestamp_completamento`);
ALTER TABLE `job` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000088

-- lingue
-- tipologia: tabella di supporto
ALTER TABLE `lingue`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `nome` (`nome`),
	ADD UNIQUE KEY `iso6391alpha2` (`iso6391alpha2`),
	ADD UNIQUE KEY `iso6393alpha3` (`iso6393alpha3`),
	ADD UNIQUE KEY `ietf` (`ietf`),
	ADD KEY `indice` (`id`,`nome`,`note`,`ietf`);
ALTER TABLE `lingue` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000089

-- liste_mailing
-- tipologia: tabella gestita
ALTER TABLE `liste_mailing`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `nome` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`nome`);
ALTER TABLE `liste_mailing` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000090

-- listini
-- tipologia: tabella assistita
ALTER TABLE `listini`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `nome` (`nome`),
	ADD KEY `id_valuta` (`id_valuta`),
	ADD KEY `indice` (`id`,`nome`,`id_valuta`);
ALTER TABLE `listini` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000091

-- listini_clienti
-- tipologia: tabella gestita
ALTER TABLE `listini_clienti`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_listino` (`id_listino`,`id_cliente`),
	ADD KEY `id_cliente` (`id_cliente`),
	ADD KEY `indice` (`id`,`id_listino`,`id_cliente`);
ALTER TABLE `listini_clienti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000092

-- luoghi
-- tipologia: tabella gestita
ALTER TABLE `luoghi`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_genitore`,`nome`);
ALTER TABLE `luoghi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000093

-- macro
-- tipologia: tabella gestita
ALTER TABLE `macro`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `id_pagina` (`id_pagina`,`macro`), 
	ADD KEY `id_gruppo` (`macro`),
	ADD KEY `indice` (`id`,`id_pagina`,`macro`);
ALTER TABLE `macro` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000094

-- mail
-- tipologia: tabella gestita
ALTER TABLE `mail`
  	ADD PRIMARY KEY (`id`),
  	ADD UNIQUE KEY `unica` (`id_anagrafica`,`indirizzo`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
  	ADD KEY `id_anagrafica` (`id_anagrafica`),
	ADD KEY `indice` (`id`,`id_anagrafica`,`indirizzo`,`se_notifiche`,`se_pec`);
ALTER TABLE `mail` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000095

-- mail_liste_mailing
-- tipolgia: tabella gestita
ALTER TABLE `mail_liste_mailing`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `id_mail` (`id_mail`,`id_lista`),
	ADD KEY `id_lista` (`id_lista`),
	ADD KEY `indice` (`id`,`id_mail`,`id_lista`);
ALTER TABLE `mail_liste_mailing` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000096

-- mail_out
-- tipolgia: tabella gestita
ALTER TABLE `mail_out`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `timestamp_composizione` (`timestamp_composizione`), 
	ADD KEY `timestamp_invio` (`timestamp_invio`), 
	ADD KEY `id_newsletter` (`id_newsletter`), 
	ADD KEY `id_email` (`id_email`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 	
	ADD KEY `token` (`token`),
	ADD KEY `indice` (`id`,`timestamp_composizione`,`timestamp_invio`,`id_newsletter`,`id_email`,`oggetto`,`allegati`,`token`);
ALTER TABLE `mail_out` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000097

-- mail_sent
-- tipolgia: tabella gestita
ALTER TABLE `mail_sent`
	ADD PRIMARY KEY (`id`),
	ADD KEY `timestamp_composizione` (`timestamp_composizione`),
	ADD KEY `timestamp_invio` (`timestamp_invio`),
	ADD KEY `id_newsletter` (`id_newsletter`),
	ADD KEY `id_email` (`id_email`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `token` (`token`),
	ADD KEY `indice` (`id`,`timestamp_composizione`,`timestamp_invio`,`id_newsletter`,`id_email`,`oggetto`,`allegati`,`token`);

--| 030000000098

-- mailing
-- tipologia: tabella gestita
ALTER TABLE `mailing`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `id_job` (`id_job`),
	ADD KEY `indice` (`id`,`nome`,`timestamp_invio`,`id_job`);
ALTER TABLE `mailing` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000099

-- mailing_liste
-- tipologia: tabella gestita
ALTER TABLE `mailing_liste`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `id_mailing` (`id_mailing`,`id_lista`),
	ADD KEY `id_lista` (`id_lista`),
	ADD KEY `indice` (`id`,`id_mailing`,`id_lista`);
ALTER TABLE `mailing_liste` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000100

-- mailing_mail
-- tipologia: tabella gestita
ALTER TABLE `mailing_mail`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `id_mail` (`id_mail`,`id_mailing`),
	ADD KEY `id_mail_coda` (`id_mail_coda`),
	ADD KEY `id_mailing` (`id_mailing`),
	ADD KEY `indice` (`id`,`id_mail`,`id_mailing`,id_mail_coda`);
ALTER TABLE `mailing_mail` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000101

-- mastri
-- tipologia: tabella gestita
ALTER TABLE `mastri`
 	ADD PRIMARY KEY (`id`), 
 	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
 	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
 	ADD KEY `id_tipologia` (`id_tipologia`),
	ADD KEY `indice` (`id`,`nome`,`id_tipologia`,`se_commerciale`,`se_produzione`,se_amministrazione`);
ALTER TABLE `mastri` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000102

-- marchi
-- tipologia: tabella gestita
ALTER TABLE `marchi`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `nome` (`nome`),
	ADD UNIQUE KEY `indice` (`id`,`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`nome`);
ALTER TABLE `marchi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000103

-- matricole
-- tipologia: tabella gestita
ALTER TABLE `matricole`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`nome`,`id_account_inserimento`);
ALTER TABLE `matricole` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000104

ALTER TABLE `menu`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica_id_pagina` (`id_pagina`,`id_lingua`,`menu`), 
	ADD KEY `id_pagina` (`id_pagina`), 
	ADD KEY `id_lingua` (`id_lingua`),
	ADD KEY `indice` (`id`,`id_pagina`,`id_lingua`,`menu`,`nome`);
ALTER TABLE `menu` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000105

-- metadati
-- tipologia: tabella gestita
ALTER TABLE `metadati`
 	ADD PRIMARY KEY (`id`), 
 	ADD UNIQUE KEY `unica_prodotto` (`id_prodotto`,`nome`), 
 	ADD KEY `id_anagrafica` (`id_anagrafica`), 
 	ADD KEY `id_prodotto` (`id_prodotto`), 
 	ADD KEY `id_categoria_prodotti` (`id_categoria_prodotti`), 
 	ADD KEY `id_immagine` (`id_immagine`), 
 	ADD KEY `id_file` (`id_file`), 
 	ADD KEY `id_pagina` (`id_pagina`), 
 	ADD KEY `id_evento` (`id_evento`), 
 	ADD KEY `id_categoria_eventi` (`id_categoria_eventi`), 
 	ADD KEY `id_lingua` (`id_lingua`), 
 	ADD KEY `id_mailing` (`id_mailing`), 
 	ADD KEY `id_notizia` (`id_notizia`), 
 	ADD KEY `id_categoria_notizie` (`id_categoria_notizie`), 
 	ADD KEY `id_articolo` (`id_articolo`), 
 	ADD KEY `id_video` (`id_video`), 
 	ADD KEY `id_categoria_risorse` (`id_categoria_risorse`), 
 	ADD KEY `id_risorsa` (`id_risorsa`),
	ADD KEY `indice` (`id`,`id_prodotto`,`nome`,`id_anagrafica`,`id_file`,`id_articolo`,`id_anagrafica`,`id_file`);
ALTER TABLE `metadati` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000106

-- modalita_consegna
-- tipologia: tabella gestita
ALTER TABLE `modalita_consegna`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `nome` (`nome`),
	ADD KEY `indice` (`id`,`nome`,`suggerimento`);
ALTER TABLE `modalita_consegna` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000107

-- modalita_consegna_prezzi
-- tipologia: tabella gestita
ALTER TABLE `modalita_consegna_prezzi`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_tipologia` (`id_modalita`),
	ADD KEY `id_zona` (`id_zona`),
	ADD KEY `id_categoria_prodotti` (`id_categoria_prodotti`),
	ADD KEY `id_listino` (`id_listino`),
	ADD KEY `id_valuta` (`id_valuta`),
	ADD KEY `id_iva` (`id_iva`),
	ADD KEY `indice` (`id`,`id_modalita`,`id_zona`,`id_categoria_prodotti`,`id_listino`);
ALTER TABLE `modalita_consegna_prezzi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000108

-- modalita_pagamento
-- tipologia: tabella gestita
ALTER TABLE `modalita_pagamento`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `nome` (`nome`),
	ADD KEY `indice` (`id`,`nome`,`suggerimento`,`ordine`,`percentuale_acconto`,`se_contanti`,`codice`);
ALTER TABLE `modalita_pagamento` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000109

-- modalita_pagamento_prezzi
-- tipologia: tabella gestita
ALTER TABLE `modalita_pagamento_prezzi`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_tipologia` (`id_modalita`),
	ADD KEY `id_zona` (`id_zona`),
	ADD KEY `id_categoria_prodotti` (`id_categoria_prodotti`),
	ADD KEY `id_listino` (`id_listino`),
	ADD KEY `id_valuta` (`id_valuta`),
	ADD KEY `id_iva` (`id_iva`),
	ADD KEY `indice` (`id`,`id_modalita`,`id_zona`,`id_categoria_prodotti`,`id_listino`,`prezzo`);
ALTER TABLE `modalita_pagamento_prezzi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000110

-- modalita_spedizione
-- tipologia: tabella gestita
ALTER TABLE `modalita_spedizione`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `nome` (`nome`),
	ADD KEY `indice` (`id`,`nome`);
ALTER TABLE `modalita_spedizione` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000111

-- modalita_spedizione_prezzi
-- tipologia: tabella gestita
ALTER TABLE `modalita_spedizione_prezzi`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_modalita` (`id_modalita`),
	ADD KEY `id_zona` (`id_zona`),
	ADD KEY `id_categoria_prodotti` (`id_categoria_prodotti`),
	ADD KEY `id_prodotto` (`id_prodotto`),
	ADD KEY `id_listino` (`id_listino`),
	ADD KEY `id_valuta` (`id_valuta`),
	ADD KEY `id_iva` (`id_iva`),
	ADD KEY `indice` (`id`,`id_modalita`,`id_zona`,`id_categoria_prodotti`,`id_prodotto`,`id_listino`,`id_valuta`,`id_iva`);
ALTER TABLE `modalita_spedizione_prezzi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000112

-- motivazioni_tari_anagrafica
-- tipologia: tabella di supporto
ALTER TABLE `motivazioni_tari_anagrafica`
 	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica_motivazione` (`id_tari_anagrafica`,`id_motivazione`), 
	ADD KEY `id_tari_anagrafica` (`id_tari_anagrafica`), 
	ADD KEY `id_motivazione` (`id_motivazione`),
	ADD KEY `indice` (`id`,`id_tari_anagrafica`,`id_motivazione`,`riga_provenienza`,`riga`);
ALTER TABLE `motivazioni_tari_anagrafica` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000113

-- notizie
-- tipologia: tabella gestita
ALTER TABLE `notizie`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `id_tipologia` (`id_tipologia`),
	ADD KEY `indice` (`id`,`nome`,id_sito`,`id_tipologia`);
ALTER TABLE `notizie` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000114

-- notizie_categorie
-- tipologia: tabella gestita
ALTER TABLE `notizie_categorie`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `id_evento` (`id_notizia`,`id_categoria`),
	ADD KEY `id_categoria` (`id_categoria`), 
	ADD KEY `indice` (`id`,`id_tipologia`,`id_notizia`,`id_categoria`);
ALTER TABLE `notizie_categorie` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000115

-- notizie_categorie_prodotti
-- tipologia: tabella gestita
ALTER TABLE `notizie_categorie_prodotti`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `id_notizia` (`id_notizia`), 
	ADD KEY `id_categoria_prodotti` (`id_categoria_prodotti`),
	ADD KEY `indice` (`id`,`id_notizia`,`id_categoria_prodotti`);
ALTER TABLE `notizie_categorie_prodotti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000116

-- notizie_immobili
-- tipologia: tabella gestita
ALTER TABLE `notizie_immobili`
 	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_immobile` (`id_immobile`), 
	ADD KEY `id_agenzia` (`id_agenzia`), 
	ADD KEY `id_agente` (`id_agente`), 
	ADD KEY `data_alert` (`data_alert`), 
	ADD KEY `id_esito` (`id_esito`),
	ADD KEY `indice` (`id`,`id_immobile`,`id_agenzia`,`id_agente`,`data_alert`,`id_esito`);
ALTER TABLE `notizie_immobili` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000117

-- notizie_prodotti
-- tipologia: tabella gestita
ALTER TABLE `notizie_prodotti`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_notizia` (`id_notizia`), 
	ADD KEY `id_prodotto` (`id_prodotto`),
	ADD KEY `indice` (`id`,`id_notizia`,`id_prodotto`);
ALTER TABLE `notizie_prodotti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000118

-- orari_contratti
-- tipologia: tabella gestita
ALTER TABLE `orari_contratti`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica_lavoro` (`id_contratto`,`turno`,`id_giorno`,`ora_inizio`,`ora_fine`,`se_lavoro`), 
	ADD UNIQUE KEY `unica_disponibile` (`id_contratto`,`turno`,`id_giorno`,`ora_inizio`,`ora_fine`,`se_disponibile`),
	ADD KEY `id_contratto` (`id_contratto`),
	ADD KEY `turno` (`turno`), 
	ADD KEY `id_costo` (`id_costo`),
	ADD KEY `se_lavoro` (`se_lavoro`),
	ADD KEY `se_disponibile` (`se_disponibile`),
	ADD KEY `indice` (`id`,`id_contratto`,`turno`,`id_giorno`,`ora_inizio`,`ora_fine`,`se_disponibile`,`se_lavoro`);
ALTER TABLE `orari_contratti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000119

-- orientamenti_sessuali
-- tipologia: tabella di supporto
ALTER TABLE `orientamenti_sessuali`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `nome` (`nome`),
	ADD KEY `indice` (`id`,`nome`);
ALTER TABLE `orientamenti_sessuali` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000120

-- pagine
-- tipologia: tabella gestita
ALTER TABLE `pagine`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `id_tipologia_pubblicazione` (`id_tipologia_pubblicazione`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_genitore`,`id_tipologia_pubblicazione`,`nome`,`se_sitemap`,`se_cacheable`);
ALTER TABLE `pagine` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000121

-- pagine_gruppi
-- tipologia: tabella gestita
ALTER TABLE `pagine_gruppi`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_pagina` (`id_pagina`), 
	ADD KEY `id_gruppo` (`id_gruppo`),
	ADD KEY `indice` (`id`,`id_pagina`,`id_gruppo`);
ALTER TABLE `pagine_gruppi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000122

-- patrocini_pratiche
-- tipologia: tabella gestita
ALTER TABLE `patrocini_pratiche`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_pratica` (`id_pratica`),
	ADD KEY `indice` (`id`,`id_pratica`,`nome`,`se_liquidato`,`se_fatturato`);
ALTER TABLE `patrocini_pratiche` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000123

-- periodi_variazioni_attivita
-- tipologia: tabella gestita
ALTER TABLE `periodi_variazioni_attivita`
 ADD PRIMARY KEY (`id`), 
 ADD UNIQUE KEY `unica` (`id_variazione`,`data_inizio`,`data_fine`,`ora_inizio`,`ora_fine`), 
 ADD KEY `id_variazione` (`id_variazione`),
 ADD KEY `indice` (`id`,`id_variazione`,`data_inizio`,`data_fine`,`ora_inizio`,`ora_fine`);
 ALTER TABLE `periodi_variazioni_attivita`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000124

-- pianificazioni
-- tipologia: tabella gestita
ALTER TABLE `pianificazioni`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `id_turno` (`id_turno`), 
	ADD UNIQUE KEY `id_todo` (`id_todo`), 
	ADD UNIQUE KEY `id_progetto` (`id_progetto`), 
	ADD KEY `nome` (`nome`), 
	ADD KEY `token` (`token`), 
	ADD KEY `timestamp_estensione` (`timestamp_estensione`), 
	ADD KEY `timestamp_popolazione` (`timestamp_popolazione`),
	ADD KEY `data_fine` (`data_fine`),
	ADD KEY `data_ultimo_oggetto` (`data_ultimo_oggetto`),
	ADD KEY `indice` (`id`,`id_turno`,`id_todo`,`id_progetto`,`token`,`timestamp_estensione`,`timestamp_popolazione`,`data_ultimo_oggetto`,`data_fine`,`se_lunedi`,`se_martedi`,`se_mercoledi`,`se_giovedi`,`se_venerdi`,`se_sabato`,`se_domenica`);
ALTER TABLE `pianificazioni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000125

-- popup
-- tipologia: tabella gestita
ALTER TABLE `popup`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_tipologia` (`id_tipologia`), 
	ADD KEY `id_tipologia_pubblicazione` (`id_tipologia_pubblicazione`),
	ADD KEY `indice` (`id`,`nome`,`id_tipologia`,`id_tipologia_pubblicazione`,`se_ovunque`,`timestamp_inserimento`,`timestamp_aggiornamento`);
ALTER TABLE `popup` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000126

-- popup_pagine
-- tipologia: tabella gestita
ALTER TABLE `popup_pagine`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_pagina`,`id_popup`), 
	ADD KEY `id_popup` (`id_popup`), 
	ADD KEY `id_pagina` (`id_pagina`),
	ADD KEY `indice` (`id`,`id_pagina`,`id_popup`,`se_presente`);
ALTER TABLE `popup_pagine` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000127

-- pratiche
-- tipologia: tabella gestita
ALTER TABLE `pratiche`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`numero`,`data_apertura`,`id_sede_apertura`),
	ADD KEY `numero` (`numero`), 
	ADD KEY `id_provenienza` (`id_provenienza`), 
	ADD KEY `id_sede_apertura` (`id_sede_apertura`), 
	ADD KEY `id_tipologia` (`id_tipologia`), 
	ADD KEY `id_categoria_diritto` (`id_categoria_diritto`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `id_account_chiusura` (`id_account_chiusura`), 
	ADD KEY `id_esito` (`id_esito`), 
	ADD KEY `id_esito_2` (`id_esito`), 
	ADD KEY `id_account_editor` (`id_account_editor`),
	ADD KEY `indice` (`id`,`numero`,`data_apertura`,`id_sede_apertura`,`id_provenienza`,`id_sede_apertura`,`id_tipologia`,`id_categoria_diritto`,`id_account_inserimento`,`id_account_aggiornamento`,`id_account_chiusura`,`esito`,`se_importata`);
ALTER TABLE `pratiche` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000128

-- pratiche_assistiti
-- tipologia: tabella gestita
ALTER TABLE `pratiche_assistiti`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_anagrafica`,`id_pratica`), 
	ADD KEY `id_pratica` (`id_pratica`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`),
	ADD KEY `indice` (`id`,`id_anagrafica`,`id_pratica`);
ALTER TABLE `pratiche_assistiti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000129

-- pratiche_avvocati
-- tipologia: tabella gestita
ALTER TABLE `pratiche_avvocati`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_anagrafica`,`id_pratica`) 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_pratica` (`id_pratica`),
	ADD KEY `indice` (`id`,`id_anagrafica`,`id_pratica`,`se_responsabile`);
ALTER TABLE `pratiche_avvocati` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000130

-- pratiche_servizi_contatto
-- tipologia: tabella gestita
ALTER TABLE `pratiche_servizi_contatto`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_pratica`,`id_servizio_contatto`), 
	ADD KEY `id_servizio_contatto` (`id_servizio_contatto`), 
	ADD KEY `id_pratica` (`id_pratica`),
	ADD KEY `indice` (`id`,`id_pratica`,`id_servizio_contatto`);
ALTER TABLE `pratiche_servizi_contatto` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;


--| 030000000131

-- prezzi
-- tipologia: tabella gestita
ALTER TABLE `prezzi`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica_prodotto` (`id_prodotto`,`id_listino`,`id_iva`,`id_valuta`) USING BTREE, 
	ADD UNIQUE KEY `unica_articolo` (`id_articolo`,`id_listino`,`id_iva`,`id_valuta`) USING BTREE, 
	ADD KEY `id_prodotto` (`id_prodotto`), 
	ADD KEY `id_iva` (`id_iva`), 
	ADD KEY `id_valuta` (`id_valuta`),  
	ADD KEY `id_udm` (`id_udm`), 
	ADD KEY `id_articolo` (`id_articolo`), 
	ADD KEY `id_listino` (`id_listino`),
	ADD KEY `indice` (`id`,`id_articolo`,id_prodotto`,`id_listino`,`id_iva`,`id_valuta`);
ALTER TABLE `prezzi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000132

-- priorita
-- tipologia: tabella di supporto
ALTER TABLE `priorita`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `nome` (`nome`),
	ADD KEY `indice` (`id`,`nome`,`ordine`);
ALTER TABLE `priorita` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000133

-- prodotti
-- tipologia: tabella gestita
	ALTER TABLE `prodotti`	
	ADD PRIMARY KEY (`id`), 	
	ADD KEY `id_tipologia` (`id_tipologia`), 	
	ADD KEY `id_udm` (`id_udm`), 	
	ADD KEY `id_ingombro` (`id_ingombro`), 	
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 	
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 	
	ADD KEY `id_tipologia_pubblicazione` (`id_tipologia_pubblicazione`), 	
	ADD KEY `id_produttore` (`id_produttore`), 	
	ADD KEY `id_marchio` (`id_marchio`), 	
	ADD KEY `id_fornitore` (`id_fornitore`),	
	ADD KEY `ordine` (`ordine`),
	ADD KEY `indice` (`id`,`nome`,`id_tipologia`,`ordine`,`id_fornitore`,`id_marchio`,`id_fornitore`,`se_disponibile`,`se_importata`);

--| 030000000134

-- prodotti_categorie
-- tipologia: tabella gestita
ALTER TABLE `prodotti_categorie`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `id_prodotto` (`id_prodotto`,`id_categoria`), 
	ADD KEY `id_categoria` (`id_categoria`), 
	ADD KEY `ordine` (`ordine`), 
	ADD KEY `se_principale` (`se_principale`), 
	ADD KEY `id_ruolo` (`id_ruolo`),
	ADD KEY `indice` (`id`,`id_prodotto`,`id_categoria`,`ordine`,`se_principale`,`id_ruolo`);
ALTER TABLE `prodotti_categorie` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 030000000135

-- prodotti_caratteristiche
-- tipologia: tabella gestita
ALTER TABLE `prodotti_caratteristiche`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `id_prodotto` (`id_prodotto`,`id_caratteristica`), 
	ADD KEY `ordine` (`ordine`), 
	ADD KEY `id_caratteristica` (`id_caratteristica`),
	ADD KEY `indice` (`id`,`id_prodotto`,`id_caratteristica`,`ordine`,`se_non_presente`);
ALTER TABLE `prodotti_caratteristiche` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-
-| FINE FILE
