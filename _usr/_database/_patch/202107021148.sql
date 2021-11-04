ALTER TABLE `cartellini`
ADD CONSTRAINT `cartellini_ibfk_2_nofollow` FOREIGN KEY (`id_tipologia_inps`) REFERENCES `tipologie_attivita_inps` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `cartellini_ibfk_1_nofollow` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
