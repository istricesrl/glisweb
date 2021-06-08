ALTER TABLE `progetti_categorie`
ADD CONSTRAINT `progetti_categorie_ibfk_3_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `progetti_categorie_ibfk_1` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `progetti_categorie_ibfk_1_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `progetti_categorie_ibfk_2_nofollow` FOREIGN KEY (`id_categoria`) REFERENCES `categorie_progetti` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;