ALTER TABLE `todo` ADD CONSTRAINT `todo_ibfk_3_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_todo`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;