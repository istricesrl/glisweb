ALTER TABLE `todo` ADD CONSTRAINT `todo_ibfk_16_nofollow` FOREIGN KEY (`id_mastro_attivita_default`) REFERENCES `mastri`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;