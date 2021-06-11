ALTER TABLE `categorie_attivita`
ADD CONSTRAINT `categorie_attivita_ibfk_1_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `categorie_attivita` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `categorie_attivita_ibfk_2_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `categorie_attivita_ibfk_3_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;