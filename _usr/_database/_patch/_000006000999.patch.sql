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

--| FINE FILE
