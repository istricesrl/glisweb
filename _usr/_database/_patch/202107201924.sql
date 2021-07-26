ALTER TABLE `todo_view_static` ADD `se_attivita_bloccate` INT(1) DEFAULT '1' AFTER `categorie_progetto`, ADD KEY `se_attivita_bloccate` (`se_attivita_bloccate`) ;
