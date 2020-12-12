ALTER TABLE `metadati` ADD FOREIGN KEY (`id_video`) REFERENCES `__test__`.`video`(`id`) ON DELETE SET NULL ON UPDATE SET NULL;
