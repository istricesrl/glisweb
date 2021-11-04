ALTER TABLE `pianificazioni` 
ADD `id_todo` INT(11) NULL DEFAULT NULL AFTER `id_progetto`, 
ADD `id_turno` INT(11) NULL DEFAULT NULL AFTER `id_todo`, 
ADD `periodicita` INT NOT NULL AFTER `id_turno`, 
ADD `cadenza` INT NULL DEFAULT NULL AFTER `periodicita`, 
ADD `giorni_settimana` CHAR(32) NULL DEFAULT NULL AFTER `cadenza`, 
ADD `ripetizione_mese` INT NULL DEFAULT NULL AFTER `giorni_settimana`, 
ADD `ripetizione_anno` INT NULL DEFAULT NULL AFTER `ripetizione_mese`, 
ADD `giorni_rinnovo` INT NULL DEFAULT NULL AFTER `data_ultimo_oggetto`
;