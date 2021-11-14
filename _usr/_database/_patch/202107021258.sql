ALTER TABLE `fasce_orari_contratti`
ADD CONSTRAINT `fasce_orari_contratti_ibfk_1` FOREIGN KEY (`id_contratto`) REFERENCES `contratti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `fasce_orari_contratti_ibfk_1_nofollow` FOREIGN KEY (`id_tipologia_inps`) REFERENCES `tipologie_attivita_inps` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
