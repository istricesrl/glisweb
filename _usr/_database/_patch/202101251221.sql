ALTER TABLE `todo`
ADD CONSTRAINT `todo_ibfk_1` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `todo_ibfk_1_nofollow` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `todo_ibfk_2_nofollow` FOREIGN KEY (`id_priorita`) REFERENCES `priorita` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `todo_ibfk_3_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_task` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `todo_ibfk_4_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `todo_ibfk_5_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `todo_ibfk_6_nofollow` FOREIGN KEY (`id_responsabile`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `todo_ibfk_7_nofollow` FOREIGN KEY (`id_cliente`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `todo_ibfk_8_nofollow` FOREIGN KEY (`id_luogo`) REFERENCES `luoghi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;