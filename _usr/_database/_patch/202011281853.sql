ALTER TABLE `costi_contratti` ADD `id_tipologia` INT NOT NULL AFTER `id_contratto`, ADD INDEX (`id_tipologia`) ;