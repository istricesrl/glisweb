ALTER TABLE `immagini` ADD `id_anagrafica_certificazioni` INT NULL DEFAULT NULL AFTER `id_lingua`, ADD KEY `id_anagrafica_certificazioni` (`id_anagrafica_certificazioni`) ;
