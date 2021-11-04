ALTER TABLE `file` ADD CONSTRAINT `file_ibfk_18` FOREIGN KEY (`id_certificazione`) REFERENCES `certificazioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;
