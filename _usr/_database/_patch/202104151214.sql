ALTER TABLE `fasi_strategie` ADD CONSTRAINT `fasi_strategie_ibfk_1` FOREIGN KEY (`id_strategia`) REFERENCES `strategie` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
