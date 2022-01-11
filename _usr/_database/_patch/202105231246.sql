CREATE TABLE IF NOT EXISTS `todo_view_static` (
	`id` int(11) NOT NULL,
	`data_ora_apertura` varchar(21) DEFAULT NULL,
	`data_ora_pianificazione` varchar(21) DEFAULT NULL,
	`id_cliente` int(11) DEFAULT NULL,
	`cliente` varchar(320) DEFAULT NULL,
	`id_progetto` char(32) DEFAULT NULL,
	`progetto` char(255) DEFAULT NULL,
	`crm` char(32) DEFAULT NULL,
	`id_tipologia` int(11) DEFAULT NULL,
	`tipologia` char(64) DEFAULT NULL,
	`id_mastro_attivita_default` INT(11) DEFAULT NULL,
	`mastro_attivita_default` char(64) DEFAULT NULL,
	`id_priorita` int(11) DEFAULT NULL,
	`priorita` char(32) DEFAULT NULL,
	`nome` char(255) NOT NULL,
	`id_luogo` int(11) DEFAULT NULL,
	`id_indirizzo` int(11) DEFAULT NULL,
	`ore_previste` decimal(5,2) DEFAULT NULL,
	`data_programmazione` date DEFAULT NULL,
	`ora_inizio_programmazione` time DEFAULT NULL,
	`ora_fine_programmazione` time DEFAULT NULL,
	`anno_programmazione` year(4) DEFAULT NULL,
	`settimana_programmazione` int(11) DEFAULT NULL,
	`data_scadenza` date DEFAULT NULL,
	`ora_scadenza` time DEFAULT NULL,
	`id_pianificazione` int(11) DEFAULT NULL,
	`timestamp_pianificazione` int(11) DEFAULT NULL,
	`pianificazione` char(255) DEFAULT NULL,
	`ore_lavorate` decimal(27,2) DEFAULT NULL,
	`ore_residue` decimal(28,2) DEFAULT NULL,
	`id_responsabile` int(11) DEFAULT NULL, 
	`responsabile` varchar(320) DEFAULT NULL,
	`testo` text, 
	`id_account_inserimento` int(11) DEFAULT NULL,  
	`avanzamento` decimal(36,6) DEFAULT NULL,
	`progresso` varchar(40) DEFAULT NULL,
	`timestamp_completamento` int(11) DEFAULT NULL,   
	`timestamp_inserimento` int(11) DEFAULT NULL,   
	`timestamp_revisione` int(11) DEFAULT NULL,  
	`data_ora_completamento` varchar(21) DEFAULT NULL,
	`completato` int(1) DEFAULT NULL,
	`categorie_progetto` text,
	`__label__` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
