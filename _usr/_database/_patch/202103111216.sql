ALTER TABLE `documenti`
ADD CONSTRAINT `documenti_ibfk_7_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `documenti_ibfk_1_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_documenti` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `documenti_ibfk_2_nofollow` FOREIGN KEY (`id_destinatario`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `documenti_ibfk_3_nofollow` FOREIGN KEY (`id_sede_destinatario`) REFERENCES `indirizzi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `documenti_ibfk_4_nofollow` FOREIGN KEY (`id_emittente`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `documenti_ibfk_5_nofollow` FOREIGN KEY (`id_sede_emittente`) REFERENCES `indirizzi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `documenti_ibfk_6_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;