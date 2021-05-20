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
	ADD KEY `indice` (`id`,`id_anagrafica`,`username`,`id_mail`,`password`,`se_attivo`,`token`);
ALTER TABLE `account` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000002

-- account_gruppi
-- tipologia: tabella gestita
ALTER TABLE `account_gruppi`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_account`,`id_gruppo`),
	ADD KEY `id_account` (`id_account`),
	ADD KEY `id_gruppo` (`id_gruppo`),
	ADD KEY `indice` (`id`,`id_account`,`id_gruppo`,`se_amministratore`);
ALTER TABLE `account_gruppi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000003

-- account_gruppi_attribuzione
-- tipologia: tabella gestita
ALTER TABLE `account_gruppi_attribuzione`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_account`,`id_gruppo`,`entita`), 
	ADD KEY `id_account` (`id_account`), 
	ADD KEY `id_gruppo` (`id_gruppo`),
	ADD KEY `indice` (`id`,`id_account`,`id_gruppo`,`entita`);
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
	ADD KEY `indice` (`id`,`codice`,`nome`,`cognome`,`id_tipologia`,`denominazione`,`se_importata`,`se_stampa_privacy`,`codice_fiscale`,`partita_iva`,`id_agente`,`id_responsabile_operativo`);
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
	ADD UNIQUE KEY `unica` (`id_anagrafica`,`id_diritto`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_diritto` (`id_diritto`),
	ADD KEY `indice` (`id`,`id_anagrafica`,`id_diritto`);
ALTER TABLE `anagrafica_categorie_diritto` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000007

-- anagrafica_cittadinanze
-- tipologia: tabella gestita
ALTER TABLE `anagrafica_cittadinanze`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_anagrafica`,`id_stato`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_stato` (`id_stato`),
	ADD KEY `indice` (`id`,`id_anagrafica`,`id_stato`);
ALTER TABLE `anagrafica_cittadinanze` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000008

-- anagrafica_condizioni_pagamento
-- tipologia: tabella gestita
ALTER TABLE `anagrafica_condizioni_pagamento`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_anagrafica`,`id_condizione`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_condizione` (`id_condizione`),
	ADD KEY `indice` (`id`,`id_anagrafica`,`id_condizione`);
ALTER TABLE `anagrafica_condizioni_pagamento` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000009

-- anagrafica_indirizzi
-- tipologia: tabella gestita
ALTER TABLE `anagrafica_indirizzi`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_anagrafica`,`id_indirizzo`,`id_tipologia`), 
	ADD KEY `id_indirizzo` (`id_indirizzo`), 
	ADD KEY `id_tipologia` (`id_tipologia`),
	ADD KEY `indice` (`id`,`id_anagrafica`,`id_tipologia`);
ALTER TABLE `anagrafica_indirizzi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000010

-- anagrafica_modalita_pagamento
-- tipologia: tabella gestita
ALTER TABLE `anagrafica_modalita_pagamento`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_anagrafica`,`id_modalita_pagamento`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_modalita_pagamento` (`id_modalita_pagamento`),
	ADD KEY `indice` (`id`,`id_anagrafica`,`id_modalita_pagamento`);
ALTER TABLE `anagrafica_modalita_pagamento` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000011

-- anagrafica_provenienze
-- tipologia: tabella gestita
ALTER TABLE `anagrafica_provenienze`
 	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_anagrafica`,`id_provenienza`), 
	ADD KEY `id_provenienza` (`id_provenienza`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`),
	ADD KEY `indice` (`id`,`id_anagrafica`,`id_provenienza`,`id_tipologia`);
ALTER TABLE `anagrafica_provenienze` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000012

-- anagrafica_ruoli
-- tipologia: tabella gestita
ALTER TABLE `anagrafica_ruoli`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `id_anagrafica` (`id_anagrafica`,`id_ruolo`),
	ADD UNIQUE KEY `unica_id_genitore` (`id_genitore`,`id_anagrafica`),
	ADD KEY `id_ruolo` (`id_ruolo`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `indice` (`id`,`id_anagrafica`,`id_ruolo`,`id_genitore`);
ALTER TABLE `anagrafica_ruoli` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000013

-- anagrafica_servizi_contatto
-- tipologia: tabella gestita
ALTER TABLE `anagrafica_servizi_contatto`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_anagrafica`,`id_servizio_contatto`), 
	ADD KEY `id_servizio_contatto` (`id_servizio_contatto`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`),
	ADD KEY `indice` (`id`,`id_anagrafica`,`id_servizio_contatto`);
ALTER TABLE `anagrafica_servizi_contatto`MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000014

-- anagrafica_settori
-- tipologia: tabella gestita
ALTER TABLE `anagrafica_settori`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `id_anagrafica` (`id_anagrafica`,`id_settori`), 
	ADD KEY `id_settori` (`id_settori`),
	ADD KEY `indice` (`id`,`id_anagrafica`,`id_settori`);
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
	ADD KEY `indice` (`id`,`id_prodotto`,`id_taglia`,`id_colore`,`ordine`,`id_reparto`, `se_disponibile`);

--| 000003000016

-- articoli_caratteristiche
-- tipologia: tabella gestita
ALTER TABLE `articoli_caratteristiche`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `id_articolo` (`id_articolo`,`id_caratteristica`), 
	ADD KEY `ordine` (`ordine`), 
	ADD KEY `id_caratteristica` (`id_caratteristica`),
	ADD KEY `indice` (`id`,`id_articolo`,`ordine`,`id_caratteristica`,`se_assente` );
ALTER TABLE `articoli_caratteristiche` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000017

-- assicurazioni_montaggio
-- tipologia: tabella gestita
ALTER TABLE `assicurazioni_montaggio`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `nome` (`nome`),
	ADD KEY `indice` (`id`,`nome`);
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
	ADD KEY `indice` (`id`,`nome`);
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
	ADD KEY `indice` (`id`,`id_progetto`,`id_task`,`id_mandante`,`id_cliente`,`id_immobile`, `id_pratica`,`id_tipologia_inps`,`id_todo`,`id_indirizzo`,`token`,`id_campagna`, `referente`, `luogo`, `id_attivita_completamento`);
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
	ADD UNIQUE KEY `unica` (`id_attivita`,`id_categoria`), 
	ADD KEY `id_attivita` (`id_attivita`),
	ADD KEY `id_categoria` (`id_categoria`), 
	ADD KEY `indice` (`id`,`id_attivita`,`id_categoria`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
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
	ADD KEY `id_categoria_notizie` (`id_categoria_notizie`),
	ADD KEY `indice` (`id`,`codice_embed`,`id_prodotto`,`id_ruolo`,`id_evento`,`id_file`, `id_categoria_prodotti`);
ALTER TABLE `audio` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000025

-- campagne
-- tipologia: tabella gestita
ALTER TABLE `campagne`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `nome` (`nome`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `id_account_chiusura` (`id_account_chiusura`),
	ADD KEY `indice` (`id`,`nome`,`id_account_chiusura`);
ALTER TABLE `campagne` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000026

-- caratteristiche_articoli
-- tipologia: tabella gestita
ALTER TABLE `caratteristiche_articoli`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `nome` (`nome`),
	ADD KEY `indice` (`id`,`nome`);
ALTER TABLE `caratteristiche_articoli` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000027

-- caratteristiche_immobili
-- tipologia: tabella di supporto
ALTER TABLE `caratteristiche_immobili`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `id` (`id`,`nome`),
	ADD KEY `indice` (`id`,`nome`);
ALTER TABLE `caratteristiche_immobili` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000028

-- carrelli
-- tipologia: tabella gestita
ALTER TABLE `carrelli`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `session` (`session`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `id_listino` (`id_listino`), 
	ADD KEY `id_tipologia_consegna` (`id_tipologia_consegna`), 
	ADD KEY `id_tipologia_assicurazione_spedizione` (`id_assicurazione_trasporto`), 
	ADD KEY `id_tipologia_assicurazione_montaggio` (`id_assicurazione_montaggio`), 
	ADD KEY `id_garanzia` (`id_garanzia`), 
	ADD KEY `id_modalita_pagamento` (`id_modalita_pagamento`), 
	ADD KEY `intestazione_id_provincia` (`intestazione_id_provincia`), 
	ADD KEY `intestazione_id_anagrafica` (`intestazione_id_anagrafica`),
	ADD KEY `spedizione_id_provincia` (`spedizione_id_provincia`), 
	ADD KEY `spedizione_id_stato` (`spedizione_id_stato`), 
	ADD KEY `intestazione_id_stato` (`intestazione_id_stato`), 
	ADD KEY `id_zona` (`id_zona`), 
	ADD KEY `id_tipologia_documento_carrello` (`id_tipologia_documento_carrello`),
	ADD KEY `id_modalita_spedizione` (`id_modalita_spedizione`),
	ADD KEY `indice` (`id`,`session`,`id_listino`,`id_tipologia_consegna`,`id_garanzia`,`id_modalita_pagamento`,`id_zona`,`id_tipologia_documento_carrello`);
ALTER TABLE `carrelli` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=14;

--| 000003000029

-- carrelli_articoli
-- tipologia: tabella gestita
ALTER TABLE `carrelli_articoli`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica_articolo` (`id_carrello`,`id_articolo`), 
	ADD KEY `id_carrello` (`id_carrello`), 
	ADD KEY `id_articolo` (`id_articolo`), 
	ADD KEY `id_tipologia_spedizione` (`id_modalita_spedizione`), 
	ADD KEY `id_iva` (`id_iva`), 
	ADD KEY `id_ingombro` (`id_ingombro`), 
	ADD KEY `id_categoria` (`id_categoria`),
	ADD KEY `indice` (`id`,`id_carrello`,`id_articolo`,`id_categoria`);
ALTER TABLE `carrelli_articoli` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000030

-- categorie_anagrafica
-- tipologia: tabella assistita
ALTER TABLE `categorie_anagrafica`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_genitore` (`id_genitore`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `se_rassegna_stampa` (`se_rassegna_stampa`), 
	ADD KEY `se_agente` (`se_agente`), 
	ADD KEY `se_mandante` (`se_mandante`), 
	ADD KEY `se_fornitore` (`se_fornitore`), 
	ADD KEY `se_collaboratore` (`se_collaboratore`), 
	ADD KEY `se_interno` (`se_interno`), 
	ADD KEY `se_esterno` (`se_esterno`), 
	ADD KEY `se_concorrente` (`se_concorrente`), 
	ADD KEY `se_interinale` (`se_interinale`), 
	ADD KEY `se_agenzia_interinale` (`se_agenzia_interinale`), 
	ADD KEY `se_dipendente` (`se_dipendente`),
	ADD KEY `se_referente` (`se_referente`),
	ADD KEY `se_sostituto` (`se_sostituto`),
	ADD KEY `se_squadra` (`se_squadra`),
	ADD KEY `indice` (`id`,`id_genitore`,`nome`,`se_rassegna_stampa`,`se_agente`,`se_mandante`,`se_fornitore`,`se_collaboratore`,`se_interno`,`se_esterno`,`se_concorrente`,`se_interinale`,`se_agenzia_interinale`,`se_dipendente`,`se_referente`,`se_sostituto`,`se_squadra`, `se_azienda_gestita`, `se_amministrazione`, `se_prospect`, `se_lead`, `se_docente`,`se_tutor`,`se_classe`,`se_allievo`,`se_sostituto`);
ALTER TABLE `categorie_anagrafica` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000031

-- categorie_attivita
-- tipologia: tabella gestita
ALTER TABLE `categorie_attivita`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_genitore` (`id_genitore`), 
	ADD KEY `indice` (`id`,`id_genitore`,`nome`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_genitore`,`nome`);
ALTER TABLE `categorie_attivita` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000032

-- categorie_diritto
-- tipologia: tabella di supporto
ALTER TABLE `categorie_diritto`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `nome` (`nome`), 
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `indice` (`id`,`id_genitore`,`nome`);
ALTER TABLE `categorie_diritto` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=7;

--| 000003000033

-- categorie_eventi
-- tipologia: tabella gestita
ALTER TABLE `categorie_eventi`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_genitore` (`id_genitore`), 
	ADD KEY `id_pagina` (`id_pagina`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `id_tipologia_pubblicazione` (`id_tipologia_pubblicazione`),
	ADD KEY `indice` (`id`,`id_genitore`,`id_pagina`, `ordine`, `nome`);
ALTER TABLE `categorie_eventi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;

--| 000003000034

-- categorie_notizie
-- tipologia: tabella gestita
ALTER TABLE `categorie_notizie`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_genitore` (`id_genitore`), 
	ADD KEY `id_pagina` (`id_pagina`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `id_tipologia_pubblicazione` (`id_tipologia_pubblicazione`),
	ADD KEY `indice` (`id`,`id_genitore`,`id_pagina`, `nome`, `ordine`);
ALTER TABLE `categorie_notizie` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000035

-- categorie_prodotti
-- tipologia: tabella gestita
ALTER TABLE `categorie_prodotti`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `id_pagina` (`id_pagina`),
	ADD KEY `id_tipologia_pubblicazione` (`id_tipologia_pubblicazione`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_genitore`,`id_pagina`, `nome`, `ordine`);
ALTER TABLE `categorie_prodotti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000036

-- categorie_prodotti_caratteristiche
-- tipologia: tabella gestita
ALTER TABLE `categorie_prodotti_caratteristiche`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `id_categoria` (`id_categoria`,`id_caratteristica`), 
	ADD KEY `ordine` (`ordine`), 
	ADD KEY `id_caratteristica` (`id_caratteristica`),
	ADD KEY `indice` (`id`,`id_categoria`,`id_caratteristica`,`ordine`, `se_assente`, `se_visibile`);
ALTER TABLE `categorie_prodotti_caratteristiche` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000037

-- categorie_progetti
-- tipologia: tabella gestita
ALTER TABLE `categorie_progetti`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_genitore` (`id_genitore`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_genitore`, `nome`);
ALTER TABLE `categorie_progetti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000038

-- categorie_risorse
-- tipologia: tabella gestita
ALTER TABLE `categorie_risorse`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_genitore` (`id_genitore`), 
	ADD KEY `id_pagina` (`id_pagina`),
	ADD KEY `indice` (`id`,`id_genitore`, `nome`, `ordine`);
ALTER TABLE `categorie_risorse` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000039

-- classi_energetiche_immobili
-- tipologia: tabella di supporto
ALTER TABLE `classi_energetiche_immobili`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `nome` (`nome`),
	ADD KEY `indice` (`id`, `nome`, `id_colore`);
ALTER TABLE `classi_energetiche_immobili` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000040

-- colori
-- tipologia: tabella di supporto
ALTER TABLE `colori`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `nome` (`nome`),
	ADD KEY `indice` (`id`, `nome`);
ALTER TABLE `colori` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000041

-- comuni
-- tipologia: tabella di supporto
ALTER TABLE `comuni`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `codice_istat` (`codice_istat`),
	ADD UNIQUE KEY `codice_catasto` (`codice_catasto`),
	ADD KEY `id_provincia` (`id_provincia`),
	ADD KEY `indice` (`id`,`codice_istat`,`id_provincia`, `nome`, `codice_catasto`);
ALTER TABLE `comuni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000042

-- condizioni_immobili
-- tipologia: tabella di supporto
ALTER TABLE `condizioni_immobili`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `nome` (`nome`),
	ADD KEY `indice` (`id`,`nome`);
ALTER TABLE `condizioni_immobili` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000043

-- condizioni_pagamento
-- tipologia: tabella gestita
ALTER TABLE `condizioni_pagamento`
	ADD PRIMARY KEY (`id`),
	ADD KEY `indice` (`id`,`nome`);
ALTER TABLE `condizioni_pagamento` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000044

-- contatti
-- tipologia: tabella gestita
ALTER TABLE `contatti`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_tipologia` (`id_tipologia`), 
	ADD KEY `id_segnalatore` (`id_segnalatore`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_coount_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`nome`, `id_tipologia`, `id_anagrafica`,`id_segnalatore`);
ALTER TABLE `contatti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000045

-- contenuti
-- tipologia: tabella gestita
ALTER TABLE `contenuti`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica_id_prodotto` (`id_prodotto`,`id_lingua`), 
	ADD UNIQUE KEY `unica_id_categoria_prodotti` (`id_categoria_prodotti`,`id_lingua`), 
	ADD UNIQUE KEY `unica_id_eventi` (`id_evento`,`id_lingua`), 
	ADD UNIQUE KEY `unica_id_categoria_eventi` (`id_categoria_eventi`,`id_lingua`), 
	ADD UNIQUE KEY `unica_id_immagine` (`id_immagine`,`id_lingua`), 
	ADD UNIQUE KEY `unica_id_file` (`id_file`,`id_lingua`), 
	ADD UNIQUE KEY `unica_id_pagina` (`id_pagina`,`id_lingua`), 
	ADD UNIQUE KEY `unica_id_rassegna_stampa` (`id_rassegna_stampa`,`id_lingua`), 
	ADD UNIQUE KEY `unica_id_video` (`id_video`,`id_lingua`), 
	ADD UNIQUE KEY `unica_id_audio` (`id_audio`,`id_lingua`), 
	ADD UNIQUE KEY `unica_id_articolo` (`id_articolo`,`id_lingua`), 
	ADD UNIQUE KEY `unica_id_marchio` (`id_marchio`,`id_lingua`), 
	ADD UNIQUE KEY `unica_d_caratteristica_prodotti` (`id_caratteristica_prodotti`,`id_lingua`), 
	ADD KEY `id_prodotto` (`id_prodotto`), 
	ADD KEY `id_categoria_prodotti` (`id_categoria_prodotti`), 
	ADD KEY `id_evento` (`id_evento`), 
	ADD KEY `id_categoria_eventi` (`id_categoria_eventi`), 
	ADD KEY `id_data` (`id_data`),
	ADD KEY `id_lingua` (`id_lingua`), 
	ADD KEY `id_pagina` (`id_pagina`), 
	ADD KEY `id_rassegna_stampa` (`id_rassegna_stampa`), 
	ADD KEY `id_immagine` (`id_immagine`), 
	ADD KEY `id_video` (`id_video`), 
	ADD KEY `id_audio` (`id_audio`), 
	ADD KEY `id_file` (`id_file`), 
	ADD KEY `id_template_mail` (`id_template_mail`), 
	ADD KEY `id_mailing` (`id_mailing`), 
	ADD KEY `id_notizia` (`id_notizia`), 
	ADD KEY `id_categoria_notizie` (`id_categoria_notizie`), 
	ADD KEY `id_articolo` (`id_articolo`), 
	ADD KEY `id_immobile` (`id_immobile`), 
	ADD KEY `id_indirizzo` (`id_indirizzo`), 
	ADD KEY `id_zona` (`id_zona`), 
	ADD KEY `id_incarico` (`id_incarico`), 
	ADD KEY `id_colore` (`id_colore`), 
	ADD KEY `id_caratteristica_prodotti` (`id_caratteristica_prodotti`), 
	ADD KEY `id_popup` (`id_popup`), 
	ADD KEY `id_marchio` (`id_marchio`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_risorsa` (`id_risorsa`),
	ADD KEY `id_categoria_risorse` (`id_categoria_risorse`),
	ADD KEY `indice` (`id`,`id_prodotto`,`id_articolo`,`id_marchio`,`id_file`,`id_lingua`,`id_categoria_prodotti`,`id_pagina_unico`,`id_rassegna_stampa_unico`, `id_video_unico`, `id_audio_unico`,`id_articolo_unico`, `id_marchio_unico`,`id_caratteristica_prodotti_unico` );
ALTER TABLE `contenuti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000046

-- continenti
-- tipologia: tabella di supporto
ALTER TABLE `continenti`
	ADD PRIMARY KEY (`id`),
	ADD KEY (`codice`),
	ADD KEY (`nome`),
	ADD KEY `indice` (`id`,`codice`,`nome`);
ALTER TABLE `continenti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000047

-- contratti`
-- tipologia: tabella gestita
ALTER TABLE `contratti`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_tipologia` (`id_tipologia`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_agenzia` (`id_agenzia`),
	ADD KEY `id_tipologia_qualifica` (`id_tipologia_qualifica`), 
	ADD KEY `id_tipologia_durata` (`id_tipologia_durata`), 
	ADD KEY `id_tipologia_orario` (`id_tipologia_orario`),
	ADD KEY `indice` (`id`,`id_tipologia`,`id_anagrafica`,`id_agenzia`, `livello`, `data_inizio_rapporto`, `data_fine_rapporto`);
ALTER TABLE `contratti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000048

-- costi_contratti`
-- tipologia: tabella gestita
ALTER TABLE `costi_contratti`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_contratto` (`id_contratto`),
	ADD UNIQUE KEY `unica` (`id_contratto`,`id_tipologia`),
	ADD KEY `indice` (`id`,`id_tipologia`,`id_contratto`,`costo_orario`);
ALTER TABLE `costi_contratti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000049

-- coupon
-- tipologia: tabella gestita
ALTER TABLE `coupon`
 ADD PRIMARY KEY (`id`),
 ADD KEY `indice` (`id`,`nome`,`se_multiuso`,`se_globale`);
 
 --| 000003000050
 
 -- coupon_categorie_prodotti
-- tipologia: tabella gestita
ALTER TABLE `coupon_categorie_prodotti`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_coupon` (`id_coupon`), 
	ADD KEY `id_categoria_prodotti` (`id_categoria_prodotti`),
	ADD KEY `indice` (`id`,`id_coupon`,`id_categoria_prodotti`);
ALTER TABLE `coupon_categorie_prodotti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

 --| 000003000051
 
 -- coupon_listini
-- tipologia: tabella gestita
ALTER TABLE `coupon_listini`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_coupon` (`id_coupon`), 
	ADD KEY `id_listino` (`id_listino`),
	ADD KEY `indice` (`id`,`id_coupon`,`id_listino`);
ALTER TABLE `coupon_listini` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
 
--| 000003000052

-- coupon_marchi
-- tipologia: tabella gestita
ALTER TABLE `coupon_marchi`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_coupon` (`id_coupon`), 
	ADD KEY `id_marchio` (`id_marchio`),
	ADD KEY `indice` (`id`,`id_coupon`,`id_marchio`);
ALTER TABLE `coupon_marchi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000053

-- coupon_prodotti
-- tipologia: tabella gestita
ALTER TABLE `coupon_prodotti`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_coupon` (`id_coupon`), 
	ADD KEY `id_prodotto` (`id_prodotto`),
	ADD KEY `indice` (`id`,`id_coupon`,`id_prodotto`);
ALTER TABLE `coupon_prodotti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000054

-- coupon_stagioni
-- tipologia: tabella gestita
ALTER TABLE `coupon_stagioni`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_coupon` (`id_coupon`), 
	ADD KEY `id_stagione` (`id_stagione`),
	ADD KEY `indice` (`id`,`id_coupon`,`id_stagione`);
ALTER TABLE `coupon_stagioni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000055

-- cron
-- tipologia: tabella gestita
ALTER TABLE `cron`
 	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`minuto`,`ora`,`giorno_del_mese`,`mese`,`giorno_della_settimana`,`settimana`,`task`,`iterazioni`,`timestamp_esecuzione`);
ALTER TABLE `cron` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000056

-- cron_log
-- tipologia: tabella gestita
ALTER TABLE `cron_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_cron` (`id_cron`),
  ADD KEY `indice` (`id`,`id_cron`,`timestamp_esecuzione`);
ALTER TABLE `cron_log` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000057

-- date
-- tipologia: tabella gestita
ALTER TABLE `date`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_evento` (`id_evento`), 
	ADD KEY `id_luogo` (`id_luogo`), 
	ADD KEY `id_tipologia` (`id_tipologia`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `id_notizia` (`id_notizia`), 
	ADD KEY `id_tipologia_pubblicazione` (`id_tipologia_pubblicazione`),
	ADD KEY `indice` (`id`,`id_evento`,`id_tipologia`,`id_notizia`,`timestamp_inizio`,`timestamp_fine`);
ALTER TABLE `date` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000058

-- disponibilita_immobili
-- tipologia: tabella di supporto
ALTER TABLE `disponibilita_immobili`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `nome` (`nome`),
	ADD KEY `indice` (`id`,`nome`,`se_disponibile`);
ALTER TABLE `disponibilita_immobili` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000059

-- documenti_amministrativi
-- tipologia: tabella gestita
ALTER TABLE `documenti_amministrativi`
 ADD PRIMARY KEY (`id`), 
 ADD UNIQUE KEY `codice_univoco_unico` (`id_emittente`,`progressivo_invio`), 
 ADD KEY `id_emittente` (`id_emittente`), 
 ADD KEY `id_cliente` (`id_cliente`), 
 ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
 ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
 ADD KEY `id_tipologia` (`id_tipologia`), 
 ADD KEY `id_sede_emittente` (`id_sede_emittente`), 
 ADD KEY `id_sede_cliente` (`id_sede_cliente`), 
 ADD KEY `id_fornitore` (`id_fornitore`), 
 ADD KEY `id_referente_emittente` (`id_referente_emittente`), 
 ADD KEY `id_referente_cliente` (`id_referente_cliente`), 
 ADD KEY `id_agente_emittente` (`id_agente_emittente`), 
 ADD KEY `id_esigibilita` (`id_esigibilita`),
 ADD KEY `indice` (`id`,`id_emittente`,`progressivo_invio`,`id_cliente`,`id_tipologia`,`id_fornitore`);
ALTER TABLE `documenti_amministrativi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000060

 -- documenti
-- tipologia: tabella gestita
ALTER TABLE `documenti`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_tipologia` (`id_tipologia`), 
	ADD KEY `id_destinatario` (`id_destinatario`), 
	ADD KEY `id_sede_destinatario` (`id_sede_destinatario`), 
	ADD KEY `id_emittente` (`id_emittente`), 
	ADD KEY `id_sede_emittente` (`id_sede_emittente`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_tipologia`,`id_destinatario`,`id_sede_destinatario`,`id_emittente`,`id_sede_emittente`);
ALTER TABLE `documenti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000061

-- documenti_articoli
-- tipologia: tabella gestita
ALTER TABLE `documenti_articoli`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_tipologia` (`id_tipologia`), 
	ADD KEY `id_documento` (`id_documento`), 
	ADD KEY `id_emittente` (`id_emittente`), 
	ADD KEY `id_genitore` (`id_genitore`), 
	ADD KEY `id_progetto` (`id_progetto`), 
	ADD KEY `id_todo` (`id_todo`), 
	ADD KEY `id_attivita` (`id_attivita`), 
	ADD KEY `id_articolo` (`id_articolo`), 
	ADD KEY `id_udm` (`id_udm`), 
	ADD KEY `id_listino` (`id_listino`), 
	ADD KEY `id_valuta` (`id_valuta`), 
	ADD KEY `id_modalita_pagamento` (`id_modalita_pagamento`), 
	ADD KEY `id_iva` (`id_iva`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `id_destinatario` (`id_destinatario`), 
	ADD KEY `id_mastro_provenienza` (`id_mastro_provenienza`), 
	ADD KEY `id_mastro_destinazione` (`id_mastro_destinazione`), 
	ADD KEY `id_reparto` (`id_reparto`),
	ADD KEY `indice` (`id`,`id_tipologia`,`id_documento`,`id_emittente`,`id_genitore`,`id_progetto`,`id_attivita`,`id_articolo`,`id_listino`,`id_modalita_pagamento`,`id_destinatario`,`id_reparto`);
ALTER TABLE `documenti_articoli` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000062

-- esigibilita_iva
-- tipologia: tabella di supporto
ALTER TABLE `esigibilita_iva`
 ADD PRIMARY KEY (`id`),
 ADD KEY `indice` (`id`,`nome`,`codice`);
 
 --| 000003000063
 
 -- esiti_attivita
-- tipologia: tabella di supporto
ALTER TABLE `esiti_attivita`
	ADD PRIMARY KEY (`id`),
	ADD KEY `indice` (`id`,`nome`,`se_positivo`,`se_richiede_azione`);
ALTER TABLE `esiti_attivita` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

 --| 000003000064
 
-- esiti_incarichi_immobili
-- tipologia: tabella di supporto
ALTER TABLE `esiti_incarichi_immobili`
	ADD PRIMARY KEY (`id`),
	ADD KEY `indice` (`id`,`nome`,`se_positivo`);
ALTER TABLE `esiti_incarichi_immobili` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

 --| 000003000065
 
 -- esiti_incroci_immobili
-- tipologia: tabella di supporto
ALTER TABLE `esiti_incroci_immobili`
 	ADD PRIMARY KEY (`id`),
	ADD KEY `indice` (`id`,`nome`,`se_positivo`);
ALTER TABLE `esiti_incroci_immobili` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

 --| 000003000066

-- esiti_notizie_immobili
-- tipologia: tabella di supporto
ALTER TABLE `esiti_notizie_immobili`
	ADD PRIMARY KEY (`id`),
	ADD KEY `indice` (`id`,`nome`,`se_positivo`);
ALTER TABLE `esiti_notizie_immobili` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

 --| 000003000067
 
-- esiti_pratiche
-- tipologia: tabella di supporto
ALTER TABLE `esiti_pratiche`
	ADD PRIMARY KEY (`id`),
	ADD KEY `indice` (`id`,`nome`,`se_positivo`);
ALTER TABLE `esiti_pratiche` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
 
 --| 000003000068
 
-- esiti_richieste_immobili
-- tipologia: tabella di supporto
ALTER TABLE `esiti_richieste_immobili`
 ADD PRIMARY KEY (`id`),
 ADD KEY `indice` (`id`,`nome`,`se_positivo`);
ALTER TABLE `esiti_richieste_immobili` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
 
 --| 000003000069
 
-- eventi
-- tipologia: tabella gestita
ALTER TABLE `eventi`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_tipologia`,`nome`,`se_repertorio`);
ALTER TABLE `eventi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

 --| 000003000070
 
 -- eventi_anagrafica
-- tipologia: tabella gestita
ALTER TABLE `eventi_anagrafica`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_evento` (`id_evento`),
	ADD KEY `id_ruolo` (`id_ruolo`),
	ADD KEY `id_anagrafica` (`id_anagrafica`),
	ADD KEY `indice` (`id`,`nome`,`id_evento`,`id_ruolo`,`id_anagrafica`,`ordine`);
ALTER TABLE `eventi_anagrafica` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

 --| 000003000071
 
-- eventi_categorie
-- tipologia: tabella gestita
ALTER TABLE `eventi_categorie`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `id_evento` (`id_evento`,`id_categoria`),
	ADD KEY `id_categoria` (`id_categoria`),
	ADD KEY `indice` (`id`,`id_evento`,`id_categoria`),
	ADD KEY `id_tipologia_pubblicazione` (`id_tipologia_pubblicazione`),
	ADD KEY `indice` (`id`,`id_evento`,`id_categoria`,`ordine`);
ALTER TABLE `eventi_categorie` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

 --| 000003000072
 
-- fatturati
-- tipologia: tabella gestita
ALTER TABLE `fatturati`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `fatturato_unica` (`id_cliente`,`id_mandante`,`mese`,`anno`), 
	ADD KEY `id_emittente` (`id_emittente`),
	ADD KEY `indice` (`id`,id_cliente`,`id_mandante`,`mese`,`anno`,`id_emittente`,`id_agente`);
ALTER TABLE `fatturati` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
-- NOTA: riguardo l'indice fatturato_unico valutare l'ipotesi di sostituirlo con un controllo (NOT NULL) sull'importo fatturato

 --| 000003000073
 
-- file
-- tipologia: tabella gestita
ALTER TABLE `file`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `prodotto_unico` (`id_prodotto`,`id_ruolo`,`path`), 
	ADD UNIQUE KEY `categoria_prodotti_unico` (`id_categoria_prodotti`,`id_ruolo`,`path`), 
	ADD UNIQUE KEY `anagrafica_unico` (`id_anagrafica`,`id_ruolo`,`path`), 
	ADD UNIQUE KEY `pagina_unico` (`id_pagina`,`id_ruolo`,`path`), 
	ADD UNIQUE KEY `task_unico` (`id_task`,`id_ruolo`,`path`), 
	ADD UNIQUE KEY `rassegna_stampa_unico` (`id_rassegna_stampa`,`id_ruolo`,`path`), 
	ADD UNIQUE KEY `evento_unico` (`id_evento`,`id_ruolo`,`path`), 
	ADD UNIQUE KEY `categoria_eventi_unico` (`id_categoria_eventi`,`id_ruolo`,`path`), 
	ADD UNIQUE KEY `pratica_unico` (`id_pratica`,`id_ruolo`,`path`), 
	ADD KEY `path` (`path`), 
	ADD KEY `id_task` (`id_task`), 
	ADD KEY `indice` (`id`,`id_task`,`nome`,`path`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_prodotto` (`id_prodotto`), 
	ADD KEY `id_categoria_prodotti` (`id_categoria_prodotti`), 
	ADD KEY `id_rassegna_stampa` (`id_rassegna_stampa`), 
	ADD KEY `id_evento` (`id_evento`), 
	ADD KEY `id_categoria_eventi` (`id_categoria_eventi`), 
	ADD KEY `id_pagina` (`id_pagina`), 
	ADD KEY `id_ruolo` (`id_ruolo`), 
	ADD KEY `id_template_mail` (`id_template_mail`), 
	ADD KEY `id_lingua` (`id_lingua`), 
	ADD KEY `id_mailing` (`id_mailing`), 
	ADD KEY `id_notizia` (`id_notizia`), 
	ADD KEY `id_categoria_notizie` (`id_categoria_notizie`), 
	ADD KEY `id_pratica` (`id_pratica`), 
	ADD KEY `id_todo` (`id_todo`), 
	ADD KEY `id_categoria_risorse` (`id_categoria_risorse`), 
	ADD KEY `id_risorsa` (`id_risorsa`),
	ADD KEY `indice` (`id`,`id_prodotto`,`id_evento`,`id_categoria_eventi`,`id_pratica`,`id_ruolo`,`path`,`id_categoria_prodotti`,`id_anagrafica`,`id_pagina`,`id_task`,`id_rassegna_stampa`,`id_categoria_risorse`);
ALTER TABLE `file` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
 
 --| 000003000074
 
-- garanzie_carrelli
-- tipologia: tabella gestita
ALTER TABLE `garanzie_carrelli`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `nome` (`nome`),
	ADD KEY `indice` (`id`,`nome`,`suggerimento`);
ALTER TABLE `garanzie_carrelli` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

 --| 000003000075
 
-- garanzie_carrelli_prezzi
-- tipologia: tabella gestita
ALTER TABLE `garanzie_carrelli_prezzi`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_tipologia` (`id_garanzia`),
	ADD KEY `id_zona` (`id_zona`),
	ADD KEY `id_categoria_prodotti` (`id_categoria_prodotti`),
	ADD KEY `id_listino` (`id_listino`),
	ADD KEY `id_valuta` (`id_valuta`),
	ADD KEY `id_iva` (`id_iva`),
	ADD KEY `indice` (`id`,`id_garanzia`,`id_zona`,`id_categoria_prodotti`,`id_listino`,`id_valuta`,`id_iva`);
ALTER TABLE `garanzie_carrelli_prezzi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

 --| 000003000076
 
-- gruppi
-- tipologia: tabella gestita
ALTER TABLE `gruppi`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `nome` (`nome`), 
	ADD KEY `indice` (`id`,`nome`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `id_genitore` (`id_genitore`), 
	ADD KEY `id_struttura` (`id_struttura`),
	ADD KEY `indice` (`id`,`nome`,`id_genitore`,`id_struttura`);
ALTER TABLE `gruppi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

 --| 000003000077

-- iban
-- tipologia: tabella gestita
ALTER TABLE `iban`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`),
	ADD KEY `indice` (`id`,`id_anagrafica`,`iban`);
ALTER TABLE `iban` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

 --| 000003000078
 
-- immagini
-- tipologia: tabella gestita
ALTER TABLE `immagini`
 	ADD PRIMARY KEY (`id`), 
 	ADD UNIQUE KEY `anagrafica_unica` (`id_anagrafica`,`id_ruolo`,`path`), 
 	ADD UNIQUE KEY `pagina_unica` (`id_pagina`,`id_ruolo`,`path`), 
 	ADD UNIQUE KEY `file_unica` (`id_file`,`id_ruolo`,`path`), 
 	ADD UNIQUE KEY `prodotto_unica` (`id_prodotto`,`id_ruolo`,`path`), 
 	ADD UNIQUE KEY `categoria_prodotti_unica` (`id_categoria_prodotti`,`id_ruolo`,`path`), 
 	ADD UNIQUE KEY `evento_unico` (`id_eventa`,`id_ruolo`,`path`), 
 	ADD UNIQUE KEY `categoria_eventi_unica` (`id_categoria_eventi`,`id_ruolo`,`path`), 
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

 --| 000003000079
 
-- immagini_anagrafica
-- tipologia: tabella gestita
ALTER TABLE `immagini_anagrafica`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_anagrafica` (`id_anagrafica`),
	ADD KEY `id_ruolo` (`id_ruolo`), 
	ADD KEY `id_rassegna_stampa` (`id_immagine`),
	ADD KEY `indice` (`id`,`id_anagrafica`,`id_ruolo`,`id_immagine`);
ALTER TABLE `immagini_anagrafica` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
 
  --| 000003000080
  
-- immobili_caratteristiche
-- tipologia: tabella gestita
ALTER TABLE `immobili_caratteristiche`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_immobile`,`id_caratteristica`), 
	ADD KEY `id_immobile` (`id_immobile`), 
	ADD KEY `id_caratteristica` (`id_caratteristica`),
	ADD KEY `indice` (`id`,`id_immobile`,`id_caratteristica`);
ALTER TABLE `immobili_caratteristiche` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

  --| 000003000081
  
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

  --| 000003000082

-- incroci_immobili
-- tipologia: tabella gestita
ALTER TABLE `incroci_immobili`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unico` (`id_incarico`,`id_richiesta`), 
	ADD KEY `id_incarico` (`id_incarico`), 
	ADD KEY `id_richiesta` (`id_richiesta`), 
	ADD KEY `id_esito` (`id_esito`),
	ADD KEY `indice` (`id`,`id_incarico`,`id_richiesta`);
ALTER TABLE `incroci_immobili` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

  --| 000003000083

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

  --| 000003000084
  
  -- indirizzi_caratteristiche
-- tipologia: tabella gestita
ALTER TABLE `indirizzi_caratteristiche`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_indirizzo`,`id_caratteristica`), 
	ADD KEY `id_indirizzo` (`id_indirizzo`), 
	ADD KEY `id_caratteristica` (`id_caratteristica`),
	ADD KEY `indice` (`id`,`id_indirizzo`,`id_caratteristica`);
ALTER TABLE `indirizzi_caratteristiche` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=4;

--| 000003000085

-- ingombri
-- tipologia: tabella gestita
ALTER TABLE `ingombri`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `nome` (`nome`),
	ADD KEY `min` (`min`),
	ADD KEY `max` (`max`),
	ADD KEY `indice` (`id`,`nome`,`min`,`max`);
ALTER TABLE `ingombri` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000086

-- iva
-- tipologia: tabella di supporto
ALTER TABLE `iva`
	ADD PRIMARY KEY (`id`),
	ADD KEY `aliquota` (`aliquota`),
	ADD KEY `indice` (`id`,`aliquota`,`nome`,`codice`);
ALTER TABLE `iva` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000087

-- job
-- tipologia: tabella gestita
ALTER TABLE `job`
	ADD PRIMARY KEY (`id`),
	ADD KEY `indice` (`id`,`nome`,`timestamp_apertura`,`corrente`,`delay`,`workspace`,`timestamp_esecuzione`,`timestamp_completamento`);
ALTER TABLE `job` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000088

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

--| 000003000089

-- liste_mailing
-- tipologia: tabella gestita
ALTER TABLE `liste_mailing`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `nome` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`nome`);
ALTER TABLE `liste_mailing` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000090

-- listini
-- tipologia: tabella assistita
ALTER TABLE `listini`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `nome` (`nome`),
	ADD KEY `id_valuta` (`id_valuta`),
	ADD KEY `indice` (`id`,`nome`,`id_valuta`);
ALTER TABLE `listini` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000091

-- listini_clienti
-- tipologia: tabella gestita
ALTER TABLE `listini_clienti`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_listino` (`id_listino`,`id_cliente`),
	ADD KEY `id_cliente` (`id_cliente`),
	ADD KEY `indice` (`id`,`id_listino`,`id_cliente`);
ALTER TABLE `listini_clienti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000092

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

--| 000003000093

-- macro
-- tipologia: tabella gestita
ALTER TABLE `macro`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `id_pagina` (`id_pagina`,`macro`), 
	ADD KEY `id_gruppo` (`macro`),
	ADD KEY `indice` (`id`,`id_pagina`,`macro`);
ALTER TABLE `macro` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000094

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

--| 000003000095

-- mail_liste_mailing
-- tipolgia: tabella gestita
ALTER TABLE `mail_liste_mailing`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `id_mail` (`id_mail`,`id_lista`),
	ADD KEY `id_lista` (`id_lista`),
	ADD KEY `indice` (`id`,`id_mail`,`id_lista`);
ALTER TABLE `mail_liste_mailing` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000096

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

--| 000003000097

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

--| 000003000098

-- mailing
-- tipologia: tabella gestita
ALTER TABLE `mailing`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `id_job` (`id_job`),
	ADD KEY `indice` (`id`,`nome`,`timestamp_invio`,`id_job`);
ALTER TABLE `mailing` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000099

-- mailing_liste
-- tipologia: tabella gestita
ALTER TABLE `mailing_liste`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `id_mailing` (`id_mailing`,`id_lista`),
	ADD KEY `id_lista` (`id_lista`),
	ADD KEY `indice` (`id`,`id_mailing`,`id_lista`);
ALTER TABLE `mailing_liste` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000100

-- mailing_mail
-- tipologia: tabella gestita
ALTER TABLE `mailing_mail`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `id_mail` (`id_mail`,`id_mailing`),
	ADD KEY `id_mail_coda` (`id_mail_coda`),
	ADD KEY `id_mailing` (`id_mailing`),
	ADD KEY `indice` (`id`,`id_mail`,`id_mailing`,id_mail_coda`);
ALTER TABLE `mailing_mail` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000101

-- mastri
-- tipologia: tabella gestita
ALTER TABLE `mastri`
 	ADD PRIMARY KEY (`id`), 
 	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
 	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
 	ADD KEY `id_tipologia` (`id_tipologia`),
	ADD KEY `indice` (`id`,`nome`,`id_tipologia`,`se_commerciale`,`se_produzione`,se_amministrazione`);
ALTER TABLE `mastri` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000102

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

--| 000003000103

-- matricole
-- tipologia: tabella gestita
ALTER TABLE `matricole`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`nome`,`id_account_inserimento`);
ALTER TABLE `matricole` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000104

ALTER TABLE `menu`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica_id_pagina` (`id_pagina`,`id_lingua`,`menu`), 
	ADD KEY `id_pagina` (`id_pagina`), 
	ADD KEY `id_lingua` (`id_lingua`),
	ADD KEY `indice` (`id`,`id_pagina`,`id_lingua`,`menu`,`nome`);
ALTER TABLE `menu` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000105

-- metadati
-- tipologia: tabella gestita
ALTER TABLE `metadati`
 	ADD PRIMARY KEY (`id`), 
 	ADD UNIQUE KEY `prodotto_unico` (`id_prodotto`,`nome`), 
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

--| 000003000106

-- modalita_consegna
-- tipologia: tabella gestita
ALTER TABLE `modalita_consegna`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `nome` (`nome`),
	ADD KEY `indice` (`id`,`nome`,`suggerimento`);
ALTER TABLE `modalita_consegna` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000107

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

--| 000003000108

-- modalita_pagamento
-- tipologia: tabella gestita
ALTER TABLE `modalita_pagamento`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `nome` (`nome`),
	ADD KEY `indice` (`id`,`nome`,`suggerimento`,`ordine`,`percentuale_acconto`,`se_contanti`,`codice`);
ALTER TABLE `modalita_pagamento` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000109

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

--| 000003000110

-- modalita_spedizione
-- tipologia: tabella gestita
ALTER TABLE `modalita_spedizione`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `nome` (`nome`),
	ADD KEY `indice` (`id`,`nome`);
ALTER TABLE `modalita_spedizione` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000111

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



-
-| FINE FILE
