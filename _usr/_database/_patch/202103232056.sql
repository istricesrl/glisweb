ALTER TABLE `articoli`
ADD CONSTRAINT `articoli_ibfk_4_nofollow` FOREIGN KEY (`id_udm`) REFERENCES `udm` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;