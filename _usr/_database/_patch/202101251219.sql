ALTER TABLE `todo`
ADD COLUMN  `id_tipologia` int(11) DEFAULT NULL,
ADD COLUMN   `id_priorita` int(11) DEFAULT NULL,
ADD COLUMN   `id_anagrafica` int(11) DEFAULT NULL,
ADD COLUMN   `id_cliente` int(11) DEFAULT NULL,
ADD COLUMN   `id_progetto` char(32) DEFAULT NULL,
ADD COLUMN   `id_luogo` int(11) DEFAULT NULL,
ADD COLUMN  `testo` text,
ADD COLUMN   `ore_previste` decimal(3,1) DEFAULT NULL,
ADD COLUMN  `testo_ore_previste` text,
ADD COLUMN  `anno_previsto` year(4) DEFAULT NULL,
ADD COLUMN  `settimana_prevista` int(11) DEFAULT NULL,
ADD COLUMN `testo_pianificazione` text,
ADD COLUMN   `id_responsabile` int(11) DEFAULT NULL,
ADD COLUMN   `timestamp_apertura` int(11) DEFAULT NULL,
ADD COLUMN   `timestamp_pianificazione` int(11) DEFAULT NULL,
ADD COLUMN   `data_scadenza` date DEFAULT NULL,
ADD COLUMN   `timestamp_revisione` int(11) DEFAULT NULL,
ADD COLUMN   `note_revisione` text,
ADD COLUMN   `timestamp_completamento` int(11) DEFAULT NULL,
ADD COLUMN   `testo_completamento` text,
ADD COLUMN   `id_account_inserimento` int(11) DEFAULT NULL,
ADD COLUMN   `timestamp_inserimento` int(11) NOT NULL,
ADD COLUMN   `id_account_aggiornamento` int(11) DEFAULT NULL,
ADD COLUMN   `timestamp_aggiornamento` int(11) DEFAULT NULL;