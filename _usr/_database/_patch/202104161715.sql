ALTER TABLE `obiettivi_prodotti`
ADD CONSTRAINT `obiettivi_prodotti_ibfk_1` FOREIGN KEY (`id_obiettivo`) REFERENCES `obiettivi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
