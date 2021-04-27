ALTER TABLE `obiettivi_tracking` ADD CONSTRAINT `obiettivi_tracking_ibfk_1` FOREIGN KEY (`id_obiettivo`) REFERENCES `obiettivi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
