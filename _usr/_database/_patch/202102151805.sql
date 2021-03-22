ALTER TABLE `pianificazioni` 
ADD `se_lunedi` INT(1) NULL DEFAULT NULL AFTER `cadenza`, 
ADD `se_martedi` INT(1) NULL DEFAULT NULL AFTER `se_lunedi`, 
ADD `se_mercoledi` INT(1) NULL DEFAULT NULL AFTER `se_martedi`, 
ADD `se_giovedi` INT(1) NULL DEFAULT NULL AFTER `se_mercoledi`, 
ADD `se_venerdi` INT(1) NULL DEFAULT NULL AFTER `se_giovedi`, 
ADD `se_sabato` INT(1) NULL DEFAULT NULL AFTER `se_venerdi`, 
ADD `se_domenica` INT(1) NULL DEFAULT NULL AFTER `se_sabato`
;