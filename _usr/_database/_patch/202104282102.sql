ALTER TABLE `tipologie_todo` ADD `se_scalare` INT(1) NULL DEFAULT NULL AFTER `se_chiamata`, ADD `se_commessa` INT(1) NULL DEFAULT NULL AFTER `se_scalare`, ADD `se_forfait` INT(1) NULL DEFAULT NULL AFTER `se_commessa`;