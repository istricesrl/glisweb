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

--| 000006000001

-- account
-- tipologia: tabella gestita
-- verifica: 2021-05-20 14:31 Fabio Mosti
ALTER TABLE `account`
    ADD CONSTRAINT `account_ibfk_01_nofollow` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `account_ibfk_02_nofollow` FOREIGN KEY (`id_mail`) REFERENCES `mail` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
    ADD CONSTRAINT `account_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
    ADD CONSTRAINT `account_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--| 000006000002

-- account_gruppi
-- tipologia: tabella gestita
-- verifica: 2021-05-20 16:07 Fabio Mosti
ALTER TABLE `account_gruppi`
    ADD CONSTRAINT `account_gruppi_ibfk_01` FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `account_gruppi_ibfk_02_nofollow` FOREIGN KEY (`id_gruppo`) REFERENCES `gruppi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 000006000003

-- account_gruppi_attribuzione
-- tipologia: tabella gestita
-- verifica: 2021-05-20 17:11 Fabio Mosti
ALTER TABLE `account_gruppi_attribuzione`
    ADD CONSTRAINT `account_gruppi_attribuzione_ibfk_01` FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `account_gruppi_attribuzione_ibfk_02_nofollow` FOREIGN KEY (`id_gruppo`) REFERENCES `gruppi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 000006000004

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

--| 000006000005

-- anagrafica_categorie
-- tipologia: tabella gestita
-- verifica: 2021-05-20 19:33 Fabio Mosti
ALTER TABLE `anagrafica_categorie`
    ADD CONSTRAINT `anagrafica_categorie_ibfk_01` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_categorie_ibfk_02_nofollow` FOREIGN KEY (`id_categoria`) REFERENCES `categorie_anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `anagrafica_categorie_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `anagrafica_categorie_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 000006000006

-- anagrafica_categorie_diritto
-- tipologia: tabella gestita
-- verifica: 2021-05-20 19:35 Fabio Mosti
ALTER TABLE `anagrafica_categorie_diritto`
    ADD CONSTRAINT `anagrafica_categorie_diritto_ibfk_01` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_categorie_diritto_ibfk_02_nofollow` FOREIGN KEY (`id_diritto`) REFERENCES `categorie_diritto` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;


--| 000006000007

-- anagrafica_cittadinanze
-- tipologia: tabella gestita
-- verifica: 2021-05-20 21:27 Fabio Mosti
ALTER TABLE `anagrafica_cittadinanze`
    ADD CONSTRAINT `anagrafica_cittadinanze_ibfk_01` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_cittadinanze_ibfk_02_nofollow` FOREIGN KEY (`id_stato`) REFERENCES `stati` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--| 000006000008

-- anagrafica_condizioni_pagamento
-- tipologia: tabella gestita
-- verifica: 2021-05-20 22:01 Fabio Mosti
ALTER TABLE `anagrafica_condizioni_pagamento`
    ADD CONSTRAINT `anagrafica_condizioni_pagamento_ibfk_01` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_condizioni_pagamento_ibfk_02_nofollow` FOREIGN KEY (`id_condizione`) REFERENCES `condizioni_pagamento` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 000006000008

-- anagrafica_indirizzi
-- tipologia: tabella gestita
-- verifica: 2021-05-21 16:36 Fabio Mosti
ALTER TABLE `anagrafica_indirizzi`
    ADD CONSTRAINT `anagrafica_indirizzi_ibfk_01` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_indirizzi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `anagrafica_indirizzi_ibfk_02` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_indirizzi_ibfk_03` FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--| 000006000009

-- anagrafica_modalita_pagamento
-- tipologia: tabella gestita
ALTER TABLE `anagrafica_modalita_pagamento`
    ADD CONSTRAINT `anagrafica_modalita_pagamento_ibfk_01` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_modalita_pagamento_ibfk_02` FOREIGN KEY (`id_modalita`) REFERENCES `modalita_pagamento` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| FINE FILE
