ALTER TABLE `listini_gruppi`
ADD CONSTRAINT `listini_gruppi_ibfk_1` FOREIGN KEY (`id_listino`) REFERENCES `listini` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `listini_gruppi_ibfk_2` FOREIGN KEY (`id_gruppo`) REFERENCES `gruppi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
