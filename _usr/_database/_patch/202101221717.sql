ALTER TABLE `attivita` ADD CONSTRAINT `attivita_ibfk_6_nofollow` FOREIGN KEY (`id_pratica`) REFERENCES `pratiche`(`id`) ON DELETE SET NULL ON UPDATE SET NULL;
