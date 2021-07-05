ALTER TABLE `progetti` 
ADD `id_mastro_magazzino_lavoro_default` INT NULL DEFAULT NULL AFTER `id_mastro_attivita_default`, 
ADD `id_mastro_magazzino_vendita_default` INT NULL DEFAULT NULL AFTER `id_mastro_magazzino_lavoro_default`, 
ADD INDEX (`id_mastro_magazzino_lavoro_default`), 
ADD INDEX (`id_mastro_magazzino_vendita_default`) ;