ALTER TABLE `anagrafica_provenienze`
ADD CONSTRAINT `anagrafica_provenienze_ibfk_1` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `anagrafica_provenienze_ibfk_2` FOREIGN KEY (`id_provenienza`) REFERENCES `provenienze_contatti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;