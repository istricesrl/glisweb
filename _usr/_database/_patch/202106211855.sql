ALTER TABLE `file` ADD `data_emissione` DATE NULL DEFAULT NULL AFTER `id_certificazione`, ADD KEY `data_emissione` (`data_emissione`) ;
