ALTER TABLE `progetti_anagrafica`
ADD CONSTRAINT `progetti_anagrafica_ibfk_1` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `progetti_anagrafica_ibfk_1_nofollow` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `progetti_anagrafica_ibfk_2` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;