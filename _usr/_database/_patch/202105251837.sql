ALTER TABLE `pianificazioni` ADD `data_inizio_pulizia` DATE NULL DEFAULT NULL AFTER `data_ultimo_oggetto`, ADD KEY `data_inizio_pulizia` (`data_inizio_pulizia`) ;