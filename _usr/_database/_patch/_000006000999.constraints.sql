--
-- LIMITI
-- questo file contiene le query per l'inserimento dei limiti nelle tabelle
--
-- CRITERI DI VERIFICA
-- una definizione di constraint si può dire verificata se:
-- - non si riferisce a tabelle deprecate e non contiene colonne deprecate né punta a tabelle o colonne deprecate
-- - le colonne vengono nominate nello stesso ordine in cui appaiono nella tabella
-- - tutte le colonne della tabella che rappresentano una chiave esterna sono nominate
-- - il comportamento di ogni constraint (SET NULL / NO ACTION / CASCADE) è stato verificato e approvato
-- - i nomi dei constraint sono numerati in maniera ascendente e univoca
-- - i nomi dei constraint contengono il suffisso _nofollow a meno che non sia strettamente necessario ometterlo
-- - ogni constraint è correttamente documentato con il giusto nome, in ordine, nel relativo file dox
--

--| 000006000100

-- account
-- tipologia: tabella gestita
-- verifica: 2021-05-20 14:31 Fabio Mosti
ALTER TABLE `account`
    ADD CONSTRAINT `account_ibfk_01_nofollow` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `account_ibfk_02_nofollow` FOREIGN KEY (`id_mail`) REFERENCES `mail` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
    ADD CONSTRAINT `account_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
    ADD CONSTRAINT `account_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--| 000006000200

-- account_gruppi
-- tipologia: tabella gestita
-- verifica: 2021-05-20 16:07 Fabio Mosti
ALTER TABLE `account_gruppi`
    ADD CONSTRAINT `account_gruppi_ibfk_01`             FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `account_gruppi_ibfk_02_nofollow`    FOREIGN KEY (`id_gruppo`) REFERENCES `gruppi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 000006000300

-- account_gruppi_attribuzione
-- tipologia: tabella gestita
-- verifica: 2021-05-20 17:11 Fabio Mosti
ALTER TABLE `account_gruppi_attribuzione`
    ADD CONSTRAINT `account_gruppi_attribuzione_ibfk_01`            FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `account_gruppi_attribuzione_ibfk_02_nofollow`   FOREIGN KEY (`id_gruppo`) REFERENCES `gruppi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 000006000400

-- anagrafica
-- tipologia: tabella gestita
-- verifica: 2021-05-20 19:33 Fabio Mosti
ALTER TABLE `anagrafica`	
    ADD CONSTRAINT `anagrafica_ibfk_01_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,	
    ADD CONSTRAINT `anagrafica_ibfk_02_nofollow` FOREIGN KEY (`id_pec_sdi`) REFERENCES `mail` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,	
    ADD CONSTRAINT `anagrafica_ibfk_03_nofollow` FOREIGN KEY (`id_regime_fiscale`) REFERENCES `regimi_fiscali` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,	
    ADD CONSTRAINT `anagrafica_ibfk_04_nofollow` FOREIGN KEY (`id_stato_nascita`) REFERENCES `stati` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,	
    ADD CONSTRAINT `anagrafica_ibfk_05_nofollow` FOREIGN KEY (`id_comune_nascita`) REFERENCES `comuni` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;	
    ADD CONSTRAINT `anagrafica_ibfk_06_nofollow` FOREIGN KEY (`id_tipologia_crm`) REFERENCES `tipologie_crm` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,	
    ADD CONSTRAINT `anagrafica_ibfk_07_nofollow` FOREIGN KEY (`id_agente`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,	
    ADD CONSTRAINT `anagrafica_ibfk_08_nofollow` FOREIGN KEY (`id_responsabile_operativo`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,	
    ADD CONSTRAINT `anagrafica_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,	
    ADD CONSTRAINT `anagrafica_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,	

--| 000006000500

-- anagrafica_categorie
-- tipologia: tabella gestita
-- verifica: 2021-05-20 19:33 Fabio Mosti
ALTER TABLE `anagrafica_categorie`
    ADD CONSTRAINT `anagrafica_categorie_ibfk_01`           FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_categorie_ibfk_02_nofollow`  FOREIGN KEY (`id_categoria`) REFERENCES `categorie_anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `anagrafica_categorie_ibfk_98_nofollow`  FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `anagrafica_categorie_ibfk_99_nofollow`  FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 000006000600

-- anagrafica_categorie_diritto
-- tipologia: tabella gestita
-- verifica: 2021-05-20 19:35 Fabio Mosti
ALTER TABLE `anagrafica_categorie_diritto`
    ADD CONSTRAINT `anagrafica_categorie_diritto_ibfk_01`           FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_categorie_diritto_ibfk_02_nofollow`  FOREIGN KEY (`id_diritto`) REFERENCES `categorie_diritto` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;


--| 000006000700

-- anagrafica_cittadinanze
-- tipologia: tabella gestita
-- verifica: 2021-05-20 21:27 Fabio Mosti
ALTER TABLE `anagrafica_cittadinanze`
    ADD CONSTRAINT `anagrafica_cittadinanze_ibfk_01`            FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_cittadinanze_ibfk_02_nofollow`   FOREIGN KEY (`id_stato`) REFERENCES `stati` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--| 000006000800

-- anagrafica_condizioni_pagamento
-- tipologia: tabella gestita
-- verifica: 2021-05-20 22:01 Fabio Mosti
ALTER TABLE `anagrafica_condizioni_pagamento`
    ADD CONSTRAINT `anagrafica_condizioni_pagamento_ibfk_01`            FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_condizioni_pagamento_ibfk_02_nofollow`   FOREIGN KEY (`id_condizione`) REFERENCES `condizioni_pagamento` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 000006000900

-- anagrafica_indirizzi
-- tipologia: tabella gestita
-- verifica: 2021-05-21 16:36 Fabio Mosti
ALTER TABLE `anagrafica_indirizzi`
    ADD CONSTRAINT `anagrafica_indirizzi_ibfk_01_nofollow`  FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_indirizzi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `anagrafica_indirizzi_ibfk_02`           FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_indirizzi_ibfk_03_nofollow`  FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--| 000006001000

-- anagrafica_modalita_pagamento
-- tipologia: tabella gestita
-- verifica: 2021-05-23 14:43 Fabio Mosti
ALTER TABLE `anagrafica_modalita_pagamento`
    ADD CONSTRAINT `anagrafica_modalita_pagamento_ibfk_01` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_modalita_pagamento_ibfk_02` FOREIGN KEY (`id_modalita`) REFERENCES `modalita_pagamento` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 000006001100

-- anagrafica_ruoli
-- tipologia: tabella gestita
-- verifica: 2021-05-23 14:43 Fabio Mosti
ALTER TABLE `anagrafica_ruoli`
    ADD CONSTRAINT `anagrafica_ruoli_ibfk_01_nofollow`  FOREIGN KEY (`id_genitore`) REFERENCES `anagrafica_ruoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_ruoli_ibfk_02`           FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_ruoli_ibfk_03_nofollow`  FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--| 000006001200

-- anagrafica_settori
-- tipologia: tabella gestita
-- verifica: 2021-05-23 15:31 Fabio Mosti
ALTER TABLE `anagrafica_settori`
    ADD CONSTRAINT `anagrafica_settori_ibfk_01`             FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE.
    ADD CONSTRAINT `anagrafica_settori_ibfk_02_nofollow`    FOREIGN KEY (`id_settore`) REFERENCES `settori` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--| 000006001300

-- articoli
-- tipologia: tabella gestita
-- verifica: 2021-05-25 10:47 Fabio Mosti
ALTER TABLE `articoli`
    ADD CONSTRAINT `articoli_ibfk_01_nofollow` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `articoli_ibfk_02_nofollow` FOREIGN KEY (`id_reparto`) REFERENCES `reparti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `articoli_ibfk_03_nofollow` FOREIGN KEY (`id_taglia`) REFERENCES `taglie` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `articoli_ibfk_04_nofollow` FOREIGN KEY (`id_colore`) REFERENCES `colori` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `articoli_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `articoli_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 000006001600

-- articoli_caratteristiche
-- tipologia: tabella gestita
-- verifica: 2021-05-25 12:05 Fabio Mosti
ALTER TABLE `articoli_caratteristiche`
    ADD CONSTRAINT `articoli_caratteristiche_ibfk_01`           FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `articoli_caratteristiche_ibfk_02_nofollow`  FOREIGN KEY (`id_caratteristica`) REFERENCES `caratteristiche_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 000006001700

-- articoli_correlati
-- tipologia: tabella gestita
-- verifica: 2021-05-25 18:18 Fabio Mosti
ALTER TABLE `articoli_correlati`
    ADD CONSTRAINT `articoli_correlati_ibfk_01` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_correlazioni_articoli` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `articoli_correlati_ibfk_02` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `articoli_correlati_ibfk_03` FOREIGN KEY (`id_prodotto_correlato`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `articoli_correlati_ibfk_04` FOREIGN KEY (`id_articolo_correlato`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 000006001800

-- attivita
-- tipologia: tabella gestita
-- verifica: 2021-05-27 15:31 Fabio Mosti
ALTER TABLE `attivita`
    ADD CONSTRAINT `attivita_ibfk_01_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_attivita` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `attivita_ibfk_02_nofollow` FOREIGN KEY (`id_tipologia_inps`) REFERENCES `tipologie_attivita_inps` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `attivita_ibfk_03_nofollow` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `attivita_ibfk_04_nofollow` FOREIGN KEY (`id_cliente`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `attivita_ibfk_05_nofollow` FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `attivita_ibfk_06_nofollow` FOREIGN KEY (`id_luogo`) REFERENCES `luoghi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `attivita_ibfk_07_nofollow` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `attivita_ibfk_08_nofollow` FOREIGN KEY (`id_todo`) REFERENCES `todo` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `attivita_ibfk_09_nofollow` FOREIGN KEY (`id_campagna`) REFERENCES `campagne` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `attivita_ibfk_10_nofollow` FOREIGN KEY (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `attivita_ibfk_11_nofollow` FOREIGN KEY (`id_richiesta`) REFERENCES `richieste_immobili` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `attivita_ibfk_12_nofollow` FOREIGN KEY (`id_todo_articoli`) REFERENCES `todo_articoli` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `attivita_ibfk_13_nofollow` FOREIGN KEY (`id_mastro_provenienza`) REFERENCES `mastri` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `attivita_ibfk_14_nofollow` FOREIGN KEY (`id_mastro_destinazione`) REFERENCES `mastri` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `attivita_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `attivita_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 000006002100

-- audio
-- tipologia: tabella gestita
-- verifica: 2021-05-28 16:18 Fabio Mosti
ALTER TABLE `audio`
    ADD CONSTRAINT `audio_ibfk_01_nofollow` FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `audio_ibfk_02_nofollow` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_audio` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `audio_ibfk_03_nofollow` FOREIGN KEY (`id_tipologia_embed`) REFERENCES `tipologie_embed` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `audio_ibfk_04`          FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `audio_ibfk_05`          FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `audio_ibfk_06`          FOREIGN KEY (`id_file`) REFERENCES `file` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `audio_ibfk_07`          FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `audio_ibfk_08`          FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `audio_ibfk_09`          FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `audio_ibfk_10`          FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `audio_ibfk_11`          FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `audio_ibfk_12`          FOREIGN KEY (`id_evento`) REFERENCES `eventi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `audio_ibfk_13`          FOREIGN KEY (`id_categoria_eventi`) REFERENCES `categorie_eventi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `audio_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `audio_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| FINE FILE
