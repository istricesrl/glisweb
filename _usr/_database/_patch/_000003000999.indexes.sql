--
-- INDICI
-- questo file contiene le query per la creazione degli indici delle tabelle
--
-- NOTE
--
--

--| 000003000001

-- account
-- tipologia: tabella gestita
ALTER TABLE `account`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`username`),
	ADD KEY `id_anagrafica` (`id_anagrafica`),
	ADD KEY `id_mail` (`id_mail`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `se_attivo` (`se_attivo`),
	ADD KEY `token` (`token`),
	ADD KEY `indice` (`id`,`id_anagrafica`,`username`,`password`,`se_attivo`,`token`);
ALTER TABLE `account` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000002

-- account_gruppi
-- tipologia: tabella gestita
ALTER TABLE `account_gruppi`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_account`,`id_gruppo`),
	ADD KEY `id_account` (`id_account`),
	ADD KEY `id_gruppo` (`id_gruppo`),
	ADD KEY `indice` (`id`,`id_account`,`id_gruppo`);
ALTER TABLE `account_gruppi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000003

-- account_gruppi_attribuzione
-- tipologia: tabella gestita
ALTER TABLE `account_gruppi_attribuzione`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_account`,`id_gruppo`,`entita`), 
	ADD KEY `id_account` (`id_account`), 
	ADD KEY `id_gruppo` (`id_gruppo`);
ALTER TABLE `account_gruppi_attribuzione` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000004

-- anagrafica
-- tipologia: tabella gestita
ALTER TABLE `anagrafica`	
	ADD PRIMARY KEY (`id`), 	
	ADD UNIQUE KEY `unica` (`codice`), 	
	ADD UNIQUE KEY `unica_persone` (`nome`,`cognome`,`codice_fiscale`), 	
	ADD UNIQUE KEY `unica_aziende` (`denominazione`,`partita_iva`,`codice_fiscale`), 	
	ADD KEY `id_tipologia` (`id_tipologia`),
	ADD KEY `id_tipologia_crm` (`id_tipologia_crm`), 	
	ADD KEY `id_agente` (`id_agente`), 	
	ADD KEY `id_pec_sdi` (`id_pec_sdi`), 	
	ADD KEY `id_regime_fiscale` (`id_regime_fiscale`), 	
	ADD KEY `id_orientamento_sessuale` (`id_orientamento_sessuale`), 	
	ADD KEY `id_stato_nascita` (`id_stato_nascita`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 	
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `se_importata` (`se_importata`),
	ADD KEY `se_stampa_privacy` (`se_stampa_privacy`),
	ADD KEY `riferimento` (`riferimento`),
	ADD KEY `indice` (`id`,`nome`,`cognome`,`denominazione`);
ALTER TABLE `anagrafica` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;	

--| 000003000005

-- anagrafica_categorie
-- tipologia: tabella gestita
ALTER TABLE `anagrafica_categorie`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_anagrafica`,`id_categoria`), 
	ADD KEY `id_categoria` (`id_categoria`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_anagrafica`,`id_categoria`);
ALTER TABLE `anagrafica_categorie` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000006

-- anagrafica_categorie_diritto
-- tipologia: tabella gestita
ALTER TABLE `anagrafica_categorie_diritto`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unico` (`id_anagrafica`,`id_diritto`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_diritto` (`id_diritto`)
	ADD KEY `indice` (`id`,`id_anagrafica`,`id_diritto`);
ALTER TABLE `anagrafica_categorie_diritto` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000007

-- anagrafica_cittadinanze
-- tipologia: tabella gestita
ALTER TABLE `anagrafica_cittadinanze`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unico` (`id_anagrafica`,`id_stato`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_stato` (`id_stato`),
	ADD KEY `indice` (`id`,`id_anagrafica`,`id_stato`);
ALTER TABLE `anagrafica_cittadinanze` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000008

-- anagrafica_condizioni_pagamento
-- tipologia: tabella gestita
ALTER TABLE `anagrafica_condizioni_pagamento`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unico` (`id_anagrafica`,`id_condizione`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_condizione` (`id_condizione`),
	ADD KEY `indice` (`id`,`id_anagrafica`,`id_condizione`);
ALTER TABLE `anagrafica_condizioni_pagamento` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000009

-- anagrafica_indirizzi
-- tipologia: tabella gestita
ALTER TABLE `anagrafica_indirizzi`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unico` (`id_anagrafica`,`id_indirizzo`,`id_tipologia`), 
	ADD KEY `id_indirizzo` (`id_indirizzo`), 
	ADD KEY `id_tipologia` (`id_tipologia`),
	ADD KEY `indice` (`id`,`id_anagrafica`,`id_indirizzo`,`id_tipologia`);
ALTER TABLE `anagrafica_indirizzi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000010

-- anagrafica_modalita_pagamento
-- tipologia: tabella gestita
ALTER TABLE `anagrafica_modalita_pagamento`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unico` (`id_anagrafica`,`id_modalita_pagamento`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_modalita_pagamento` (`id_modalita_pagamento`),
	ADD KEY `indice` (`id`,`id_anagrafica`,`id_modalita_pagamento`);
ALTER TABLE `anagrafica_modalita_pagamento` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000011

-- anagrafica_provenienze
-- tipologia: tabella gestita
ALTER TABLE `anagrafica_provenienze`
 	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unico` (`id_anagrafica`,`id_provenienza`), 
	ADD KEY `id_provenienza` (`id_provenienza`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`),
	ADD KEY `indice` (`id`,`id_anagrafica`,`id_provenienza`);
ALTER TABLE `anagrafica_provenienze` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000012

-- anagrafica_ruoli
-- tipologia: tabella gestita
ALTER TABLE `anagrafica_ruoli`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `id_anagrafica` (`id_anagrafica`,`id_ruolo`),
	ADD UNIQUE KEY `id_genitore_unico` (`id_genitore`,`id_anagrafica`),
	ADD KEY `id_ruolo` (`id_ruolo`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `indice` (`id`,`id_anagrafica`,`id_ruolo`);
ALTER TABLE `anagrafica_ruoli` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000013

-- anagrafica_servizi_contatto
-- tipologia: tabella gestita
ALTER TABLE `anagrafica_servizi_contatto`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unico` (`id_anagrafica`,`id_servizio_contatto`), 
	ADD KEY `id_servizio_contatto` (`id_servizio_contatto`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`),
	ADD KEY `indice` (`id`,`id_anagrafica`,`id_servizio_contatto`);
ALTER TABLE `anagrafica_servizi_contatto`MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000014

-- anagrafica_settori
-- tipologia: tabella gestita
ALTER TABLE `anagrafica_settori`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `id_anagrafica` (`id_anagrafica`,`id_settore`), 
	ADD KEY `id_settore` (`id_settore`);
	ADD KEY `indice` (`id`,`id_anagrafica`,`id_settore`),
ALTER TABLE `anagrafica_settori` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000015

-- articoli
-- tipologia: tabella gestita
ALTER TABLE `articoli`
 	ADD PRIMARY KEY (`id`), 
 	ADD KEY `id_prodotto` (`id_prodotto`), 
 	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
 	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
 	ADD KEY `id_taglia` (`id_taglia`), 
 	ADD KEY `id_colore` (`id_colore`), 
 	ADD KEY `ordine` (`ordine`), 
 	ADD KEY `id_udm` (`id_udm`), 
	ADD KEY `id_reparto` (`id_reparto`),
	ADD KEY `indice` (`id`,`id_prodotto`,`id_taglia`,`id_colore`,`ordine`,`id_reparto`);

--| 000003000016

-- articoli_caratteristiche
-- tipologia: tabella gestita
ALTER TABLE `articoli_caratteristiche`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `id_articolo` (`id_articolo`,`id_caratteristica`), 
	ADD KEY `ordine` (`ordine`), 
	ADD KEY `id_caratteristica` (`id_caratteristica`),
	ADD KEY `indice` (`id`,`id_articolo`,`id_caratteristica`,`ordine`);
ALTER TABLE `articoli_caratteristiche` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000017

-- assicurazioni_montaggio
-- tipologia: tabella gestita
ALTER TABLE `assicurazioni_montaggio`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `nome` (`nome`),
	ADD KEY `indice` (`id`,`nome`,`suggerimento`);
ALTER TABLE `assicurazioni_montaggio` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000018

-- assicurazioni_montaggio_prezzi
-- tipologia: tabella gestita
ALTER TABLE `assicurazioni_montaggio_prezzi`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_tipologia` (`id_assicurazione`),
	ADD KEY `id_zona` (`id_zona`),
	ADD KEY `id_categoria_prodotti` (`id_categoria_prodotti`),
	ADD KEY `id_listino` (`id_listino`),
	ADD KEY `id_valuta` (`id_valuta`),
	ADD KEY `id_iva` (`id_iva`),
	ADD KEY `indice` (`id`,`id_assicurazione`,`id_zona`,`id_categoria_prodotti`,`id_listino`);
ALTER TABLE `assicurazioni_montaggio_prezzi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000019

-- assicurazioni_trasporto
-- tipologia: tabella gestita
ALTER TABLE `assicurazioni_trasporto`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `nome` (`nome`),
	ADD KEY `indice` (`id`,`nome`,`suggerimento`);
ALTER TABLE `assicurazioni_trasporto` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000020

-- assicurazioni_trasporto_prezzi
-- tipologia: tabella gestita
ALTER TABLE `assicurazioni_trasporto_prezzi`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_tipologia` (`id_assicurazione`),
	ADD KEY `id_zona` (`id_zona`),
	ADD KEY `id_categoria_prodotti` (`id_categoria_prodotti`),
	ADD KEY `id_listino` (`id_listino`),
	ADD KEY `id_valuta` (`id_valuta`),
	ADD KEY `id_iva` (`id_iva`);
	ADD KEY `indice` (`id`,`id_assicurazione`,`id_zona`,`id_categoria_prodotti`,`id_listino`);
ALTER TABLE `assicurazioni_trasporto_prezzi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000021

-- attivita
-- tipologia: tabella gestita
ALTER TABLE `attivita`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_progetto` (`id_progetto`), 
	ADD KEY `id_task` (`id_task`), 
	ADD KEY `id_tipologia` (`id_tipologia`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_mandante` (`id_mandante`), 
	ADD KEY `id_categoria_prodotti` (`id_categoria_prodotti`), 
	ADD KEY `id_cliente` (`id_cliente`), 
	ADD KEY `id_incrocio_immobile` (`id_incrocio_immobile`), 
	ADD KEY `id_esito` (`id_esito`), 
	ADD KEY `id_immobile` (`id_immobile`), 
	ADD KEY `id_pratica` (`id_pratica`),
	ADD KEY `id_incarico` (`id_incarico`), 
	ADD KEY `id_richiesta` (`id_richiesta`), 
	ADD KEY `id_campagna` (`id_campagna`), 
	ADD KEY `id_tipologia_soddisfazione` (`id_tipologia_soddisfazione`), 
	ADD KEY `id_tipologia_interesse` (`id_tipologia_interesse`), 
	ADD KEY `id_account_editor` (`id_account_editor`), 
	ADD KEY `id_luogo` (`id_luogo`), 
	ADD KEY `id_tipologia_inps` (`id_tipologia_inps`), 
	ADD KEY `id_todo` (`id_todo`), 
	ADD KEY `id_indirizzo` (`id_indirizzo`), 
	ADD KEY `token` (`token`), 
	ADD KEY `id_mastro_provenienza` (`id_mastro_provenienza`), 
	ADD KEY `id_mastro_destinazione` (`id_mastro_destinazione`), 
	ADD KEY `id_todo_articoli` (`id_todo_articoli`),
	ADD KEY `indice` (`id`,`id_progetto`,`id_zona`,`id_task`,`id_mandante`,`id_cliente`,`id_immobile`, `id_pratica`,`id_luogo`,`id_tipologia_inps`,`id_todo`,`id_indirizzo`,`token`);
ALTER TABLE `attivita` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000022

-- attivita_anagrafica
-- tipologia: tabella gestita
ALTER TABLE `attivita_anagrafica`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_attivita` (`id_attivita`),
	ADD KEY `id_anagrafica` (`id_anagrafica`),
	ADD KEY `indice` (`id`,`id_attivita`,`id_anagrafica`);
ALTER TABLE `attivita_anagrafica` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000023

-- attivita_categorie
-- tipologia: tabella gestita
ALTER TABLE `attivita_categorie`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unico` (`id_attivita`,`id_categoria`), 
	ADD KEY `id_categoria` (`id_categoria`), 
	ADD KEY `indice` (`id`,`id_attivita`,`id_categoria`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `id_attivita` (`id_attivita`),
	ADD KEY `indice` (`id`,`id_attivita`,`id_categoria`);
ALTER TABLE `attivita_categorie` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000024

-- audio
-- tipologia: tabella gestita
ALTER TABLE `audio`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `codice_embed` (`codice_embed`), 
	ADD UNIQUE KEY `path` (`path`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `id_pagina` (`id_pagina`), 
	ADD KEY `id_prodotto` (`id_prodotto`), 
	ADD KEY `id_categoria_prodotti` (`id_categoria_prodotti`), 
	ADD KEY `id_ruolo` (`id_ruolo`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_evento` (`id_evento`), 
	ADD KEY `id_file` (`id_file`), 
	ADD KEY `id_tipologia_embed` (`id_tipologia_embed`), 
	ADD KEY `id_categoria_eventi` (`id_categoria_eventi`), 
	ADD KEY `id_risorsa` (`id_risorsa`), 
	ADD KEY `id_lingua` (`id_lingua`), 
	ADD KEY `id_notizia` (`id_notizia`), 
	ADD KEY `id_categoria_notizie` (`id_categoria_notizie`);
	ADD KEY `indice` (`id`,`codice_embed`,`id_prodotto`,`id_prodotto`,`id_ruolo`,`id_evento`,`id_file`);
ALTER TABLE `audio` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| FINE FILE
