ALTER TABLE `obiettivi_anagrafica`
ADD CONSTRAINT `obiettivi_anagrafica_ibfk_1` FOREIGN KEY (`id_obiettivo`) REFERENCES `obiettivi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
