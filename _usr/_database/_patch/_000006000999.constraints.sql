--
-- LIMITI
-- questo file contiene le query per l'inserimento dei limiti nelle tabelle
--

--| 000006000001

-- account
-- tipologia: tabella gestita
ALTER TABLE `account`
    ADD CONSTRAINT `account_ibfk_1_nofollow` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `account_ibfk_2_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `account_ibfk_3_nofollow` FOREIGN KEY (`id_mail`) REFERENCES `mail` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `account_ibfk_4_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 000006000002

-- account_gruppi
-- tipologia: tabella gestita
ALTER TABLE `account_gruppi`
    ADD CONSTRAINT `account_gruppi_ibfk_1` FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `account_gruppi_ibfk_2_nofollow` FOREIGN KEY (`id_gruppo`) REFERENCES `gruppi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 000006000003

-- account_gruppi_attribuzione
-- tipologia: tabella gestita
ALTER TABLE `account_gruppi_attribuzione`
    ADD CONSTRAINT `account_gruppi_attribuzione_ibfk_1` FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `account_gruppi_attribuzione_ibfk_2_nofollow` FOREIGN KEY (`id_gruppo`) REFERENCES `gruppi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--| 000006000004

-- anagrafica
-- tipologia: tabella gestita
ALTER TABLE `anagrafica`	
    ADD CONSTRAINT `anagrafica_ibfk_1_nofollow` FOREIGN KEY (`id_orientamento_sessuale`) REFERENCES `orientamenti_sessuali` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,	
    ADD CONSTRAINT `anagrafica_ibfk_2_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,	
    ADD CONSTRAINT `anagrafica_ibfk_3_nofollow` FOREIGN KEY (`id_stato_nascita`) REFERENCES `stati` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,	
    ADD CONSTRAINT `anagrafica_ibfk_4_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,	
    ADD CONSTRAINT `anagrafica_ibfk_5_nofollow` FOREIGN KEY (`id_tipologia_crm`) REFERENCES `tipologie_crm` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,	
    ADD CONSTRAINT `anagrafica_ibfk_6_nofollow` FOREIGN KEY (`id_pec_sdi`) REFERENCES `mail` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,	
    ADD CONSTRAINT `anagrafica_ibfk_7_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,	
    ADD CONSTRAINT `anagrafica_ibfk_8_nofollow` FOREIGN KEY (`id_agente`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,	
    ADD CONSTRAINT `anagrafica_ibfk_9_nofollow` FOREIGN KEY (`id_regime_fiscale`) REFERENCES `regimi_fiscali` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,	
    ADD CONSTRAINT `anagrafica_ibfk_10_nofollow` FOREIGN KEY (`comune_nascita`) REFERENCES `comuni` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;	

--| 000006000005

-- anagrafica_categorie
-- tipologia: tabella gestita
ALTER TABLE `anagrafica_categorie`
    ADD CONSTRAINT `anagrafica_categorie_ibfk_1` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_categorie_ibfk_2_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `anagrafica_categorie_ibfk_3_nofollow` FOREIGN KEY (`id_categoria`) REFERENCES `categorie_anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `anagrafica_categorie_ibfk_4_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| FINE FILE
