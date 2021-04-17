ALTER TABLE `variazioni_attivita`
ADD CONSTRAINT `variazioni_attivita_ibfk_3_nofollow` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `variazioni_attivita_ibfk_1_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_variazioni_attivita` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `variazioni_attivita_ibfk_2_nofollow` FOREIGN KEY (`id_tipologia_inps`) REFERENCES `tipologie_attivita_inps` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;