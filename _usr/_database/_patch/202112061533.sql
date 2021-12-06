ALTER TABLE `cartellini` 
ADD CONSTRAINT `cartellini_ibfk_3_nofollow` FOREIGN KEY (`id_account_approvazione`) REFERENCES `account`(`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `cartellini_ibfk_4_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account`(`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `cartellini_ibfk_5_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account`(`id`) ON DELETE SET NULL ON UPDATE SET NULL;