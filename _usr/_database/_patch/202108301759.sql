ALTER TABLE `todo` ADD CONSTRAINT `todo_ibfk_17_nofollow` FOREIGN KEY (`id_anagrafica_feedback`) REFERENCES `anagrafica`(`id`) ON DELETE SET NULL ON UPDATE SET NULL;
