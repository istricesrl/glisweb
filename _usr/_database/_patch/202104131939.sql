ALTER TABLE `__acl_anagrafica__` ADD CONSTRAINT `__acl_anagrafica___ibfk_3_nofollow` FOREIGN KEY (`id_account`) REFERENCES `account`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;