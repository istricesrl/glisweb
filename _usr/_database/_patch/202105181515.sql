ALTER TABLE `todo_articoli`
ADD CONSTRAINT `todo_articoli_ibfk_1` FOREIGN KEY (`id_todo`) REFERENCES `todo` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `todo_articoli_ibfk_2` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;