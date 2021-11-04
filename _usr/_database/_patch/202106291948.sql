ALTER TABLE `pianificazioni` ADD CONSTRAINT `pianificazioni_ibfk_3` FOREIGN KEY (`id_todo`) REFERENCES `todo`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
