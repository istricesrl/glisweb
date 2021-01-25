ALTER TABLE righe_documenti_amministrativi ADD COLUMN   `id_todo` int(11) DEFAULT NULL AFTER id_task, ADD KEY `id_todo` (`id_todo`),
ADD CONSTRAINT `righe_documenti_amministrativi_ibfk_17` FOREIGN KEY (`id_todo`) REFERENCES `todo` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

