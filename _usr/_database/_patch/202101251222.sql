ALTER TABLE attivita ADD COLUMN   `id_todo` int(11) DEFAULT NULL AFTER id_task, ADD KEY `id_todo` (`id_todo`),
ADD CONSTRAINT `attivita_ibfk_17_nofollow` FOREIGN KEY (`id_todo`) REFERENCES `todo` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION ;