ALTER TABLE `todo` ADD CONSTRAINT `todo_ibfk_15_nofollow` FOREIGN KEY (`id_pianificazione`) REFERENCES `pianificazioni`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
