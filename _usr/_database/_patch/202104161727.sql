ALTER TABLE `obiettivi_tipologie_attivita`
ADD CONSTRAINT `obiettivi_tipologie_attivita_ibfk_1` FOREIGN KEY (`id_obiettivo`) REFERENCES `obiettivi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
