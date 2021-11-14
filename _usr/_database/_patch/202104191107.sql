ALTER TABLE `sostituzioni_attivita` 
ADD `data_scarto` DATE NULL DEFAULT NULL AFTER `data_rifiuto`,
ADD KEY `data_scarto` (`data_scarto`);