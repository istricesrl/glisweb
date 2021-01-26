ALTER TABLE `contratti` 
ADD `id_tipologia_qualifica` CHAR(32) NULL DEFAULT NULL AFTER `livello`, 
ADD `id_tipologia_durata` CHAR(32) NULL DEFAULT NULL AFTER `id_tipologia_qualifica`, 
ADD `id_tipologia_orario` CHAR(32) NULL DEFAULT NULL AFTER `id_tipologia_durata`, 
ADD INDEX (`id_tipologia_qualifica`),
ADD INDEX (`id_tipologia_durata`),
ADD INDEX (`id_tipologia_orario`) ;