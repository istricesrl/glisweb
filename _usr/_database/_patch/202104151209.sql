ALTER TABLE `strategie` ADD CONSTRAINT `strategie_ibfk_1` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_obiettivi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
