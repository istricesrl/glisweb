ALTER TABLE `attivita_view_static` 
ADD `se_ordinario` INT(1) NULL DEFAULT NULL AFTER `note_interne`, 
ADD `se_straordinario` INT(1) NULL DEFAULT NULL AFTER `se_ordinario`, 
ADD KEY `se_ordinario` (`se_ordinario`),
ADD KEY `se_straordinario` (`se_straordinario`) ;
