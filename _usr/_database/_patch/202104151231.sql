ALTER TABLE `obiettivi`
ADD CONSTRAINT `obiettivi_ibfk_1_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `obiettivi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `obiettivi_ibfk_2` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_obiettivi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `obiettivi_ibfk_3` FOREIGN KEY (`id_fase_strategia`) REFERENCES `fasi_strategie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;