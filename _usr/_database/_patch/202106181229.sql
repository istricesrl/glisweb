ALTER TABLE `certificazioni`
ADD CONSTRAINT `certificazioni_ibfk_3_nofollow` FOREIGN KEY (`id_emittente`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `certificazioni_ibfk_1_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_certificazioni` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `certificazioni_ibfk_2_nofollow` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
