ALTER TABLE `todo_view_static` ADD `categorie` VARCHAR(255) NULL DEFAULT NULL AFTER `completato`, ADD KEY `categorie` (`categorie`) ;
