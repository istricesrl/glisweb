ALTER TABLE `obiettivi_tracking`
ADD CONSTRAINT `obiettivi_tracking_ibfk_2` FOREIGN KEY (`id_tracking`) REFERENCES `codici_tracking` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `obiettivi_tracking_ibfk_1` FOREIGN KEY (`id_obiettivo`) REFERENCES `obiettivi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;