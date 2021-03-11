ALTER TABLE `risorse_anagrafica` ADD CONSTRAINT `risorse_anagrafica_ibfk_1` FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
