ALTER TABLE `__report_sostituzioni_attivita__` ADD `se_scartato` INT(1) NULL DEFAULT NULL , ADD `se_convocato` INT(1) NULL DEFAULT NULL, ADD INDEX `se_scartato` (`se_scartato`), ADD INDEX `se_convocato` (`se_convocato`);