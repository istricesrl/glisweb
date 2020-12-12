ALTER TABLE `audio` ADD `id_lingua` INT NULL DEFAULT NULL AFTER `id_categoria_eventi`, ADD INDEX (`id_lingua`) ;
