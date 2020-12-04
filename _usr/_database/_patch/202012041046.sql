ALTER TABLE `anagrafica_servizi_contatto`
ADD CONSTRAINT `anagrafica_servizi_contatto_ibfk_1` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `anagrafica_servizi_contatto_ibfk_2` FOREIGN KEY (`id_servizio_contatto`) REFERENCES `provenienze_contatti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
