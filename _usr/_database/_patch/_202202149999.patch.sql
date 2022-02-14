--
-- PATCH
--

--| 202202140010
ALTER TABLE `contenuti` 
ADD `id_progetto`char(32) DEFAULT NULL AFTER `id_colore`,
ADD `id_categoria_progetti` INT(11) DEFAULT NULL AFTER `id_progetto`,
ADD KEY `id_progetto` (`id_progetto`),
ADD KEY `id_categoria_progetti` (`id_categoria_progetti`),
ADD CONSTRAINT `contenuti_ibfk_23`                  FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `contenuti_ibfk_24`                  FOREIGN KEY (`id_categoria_progetti`) REFERENCES `categorie_progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202202140020
ALTER TABLE `metadati` 
ADD `id_progetto` char(32) DEFAULT NULL AFTER `id_file`,
ADD `id_categoria_progetti` INT(11) DEFAULT NULL AFTER `id_progetto`,
ADD KEY `id_progetto` (`id_progetto`),
ADD KEY `id_categoria_progetti` (`id_categoria_progetti`),
ADD CONSTRAINT `metadati_ibfk_15` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `metadati_ibfk_16` FOREIGN KEY (`id_categoria_progetti`) REFERENCES `categorie_progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202202140030
ALTER TABLE `immagini` 
ADD `id_progetto` char(32) DEFAULT NULL AFTER `id_ruolo`,
ADD `id_categoria_progetti` INT(11) DEFAULT NULL AFTER `id_progetto`,
ADD KEY `id_progetto` (`id_progetto`),
ADD KEY `id_categoria_progetti` (`id_categoria_progetti`),
ADD CONSTRAINT `immagini_ibfk_14` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `immagini_ibfk_15` FOREIGN KEY (`id_categoria_progetti`) REFERENCES `categorie_progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| FINE