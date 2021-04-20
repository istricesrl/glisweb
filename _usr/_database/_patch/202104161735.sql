ALTER TABLE `obiettivi_tipologie_progetti`
ADD CONSTRAINT `obiettivi_tipologie_progetti_ibfk_1` FOREIGN KEY (`id_obiettivo`) REFERENCES `obiettivi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
