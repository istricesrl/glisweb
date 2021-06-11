ALTER TABLE `attivita_categorie`
ADD CONSTRAINT `attivita_categorie_ibfk_3_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `attivita_categorie_ibfk_1` FOREIGN KEY (`id_attivita`) REFERENCES `attivita` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `attivita_categorie_ibfk_1_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `attivita_categorie_ibfk_2_nofollow` FOREIGN KEY (`id_categoria`) REFERENCES `categorie_attivita` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;