ALTER TABLE `anagrafica_certificazioni`
ADD CONSTRAINT `anagrafica_certificazioni_ibfk_2_nofollow` FOREIGN KEY (`id_emittente`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `anagrafica_certificazioni_ibfk_1_nofollow` FOREIGN KEY (`id_certificazione`) REFERENCES `certificazioni` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `anagrafica_certificazioni_ibfk_1` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
