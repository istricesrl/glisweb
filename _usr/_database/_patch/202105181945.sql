ALTER TABLE `attivita` 
ADD `id_mastro_provenienza` INT NULL DEFAULT NULL , 
ADD `id_mastro_destinazione` INT NULL DEFAULT NULL , 
ADD `id_todo_articoli` INT NULL DEFAULT NULL,
ADD KEY `id_mastro_provenienza` (`id_mastro_provenienza`),
ADD KEY `id_mastro_destinazione` (`id_mastro_destinazione`),
ADD KEY `id_todo_articoli` (`id_todo_articoli`) ;