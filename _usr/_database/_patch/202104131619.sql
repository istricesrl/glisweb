ALTER TABLE `mastri` ADD CONSTRAINT `mastri_ibfk_1_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account`(`id`) ON DELETE SET NULL ON UPDATE SET NULL; 