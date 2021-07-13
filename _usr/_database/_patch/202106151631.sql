ALTER TABLE `codici_tracking`
ADD CONSTRAINT `codici_tracking_ibfk_3_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `codici_tracking_ibfk_1_nofollow` FOREIGN KEY (`id_campagna`) REFERENCES `campagne` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `codici_tracking_ibfk_2_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;