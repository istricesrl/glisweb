ALTER TABLE `obiettivi_articoli`
ADD CONSTRAINT `obiettivi_articoli_ibfk_2` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `obiettivi_articoli_ibfk_1` FOREIGN KEY (`id_obiettivo`) REFERENCES `obiettivi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;