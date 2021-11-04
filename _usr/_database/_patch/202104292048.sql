ALTER TABLE `todo_categorie`
ADD CONSTRAINT `todo_categorie_ibfk_3_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `todo_categorie_ibfk_1` FOREIGN KEY (`id_todo`) REFERENCES `todo` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `todo_categorie_ibfk_1_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `todo_categorie_ibfk_2_nofollow` FOREIGN KEY (`id_categoria`) REFERENCES `categorie_attivita` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;