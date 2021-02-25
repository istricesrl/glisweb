ALTER TABLE `pianificazioni`
ADD CONSTRAINT `pianificazioni_ibfk_3` FOREIGN KEY (`id_todo`) REFERENCES `todo` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `pianificazioni_ibfk_4` FOREIGN KEY (`id_turno`) REFERENCES `turni` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;