--
-- 2026-10-29 — __report_corsi__ e __report_lezioni_corsi__ ai database installati prima del 26/10
--
-- Il 26/10/2026 le due tabelle sono tornate nel file base _100000999999.reports.sql ( marcatori 100000007801 e
-- 100000060300 ), ma un database gia' installato ha un livello di patch piu' alto di quei marcatori e non le riceve:
-- i task di popolazione di _0920.corsi non avevano dove scrivere e i loro test si saltavano. Qui si creano con la
-- stessa struttura del file base; dove ci sono gia' non succede niente.
--
-- IDEMPOTENTE: CREATE TABLE IF NOT EXISTS.

-- | 202610291300

CREATE TABLE IF NOT EXISTS `__report_corsi__` (
  `id` char(255) NOT NULL,
  `id_periodo` bigint(20) DEFAULT NULL,
  `periodo` char(255) DEFAULT NULL,
  `tipologia` char(255) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `fasce` char(255) DEFAULT NULL,
  `discipline` char(255) DEFAULT NULL,
  `livelli` char(255) DEFAULT NULL,
  `giorni_orari_luoghi` text DEFAULT NULL,
  `dettagli` text DEFAULT NULL,
  `posti_disponibili` char(255) DEFAULT NULL,
  `lista_attesa` char(255) DEFAULT NULL,
  `stato` char(255) DEFAULT NULL,
  `data_accettazione` date DEFAULT NULL,
  `data_chiusura` date DEFAULT NULL,
  `prezzi` char(255) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  `__label__` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `nome` (`nome`),
  KEY `timestamp_inserimento` (`timestamp_inserimento`),
  KEY `timestamp_aggiornamento` (`timestamp_aggiornamento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202610291301

CREATE TABLE IF NOT EXISTS `__report_lezioni_corsi__` (
  `id` char(255) NOT NULL,
  `id_tipologia` bigint(20) DEFAULT NULL,
  `tipologia` char(255) DEFAULT NULL,
  `codice` char(255) DEFAULT NULL,
  `se_agenda` int(1) DEFAULT NULL,
  `id_anagrafica` bigint(20) DEFAULT NULL,
  `anagrafica` char(255) DEFAULT NULL,
  `id_cliente` bigint(20) DEFAULT NULL,
  `cliente` char(255) DEFAULT NULL,
  `id_indirizzo` bigint(20) DEFAULT NULL,
  `indirizzo` char(255) DEFAULT NULL,
  `id_luogo` bigint(20) DEFAULT NULL,
  `luogo` char(255) DEFAULT NULL,
  `docenti` char(255) DEFAULT NULL,
  `numero_alunni` int(11) DEFAULT NULL,
  `numero_posti` int(11) DEFAULT NULL,
  `numero_alunni_in_attesa` int(11) DEFAULT NULL,
  `timestamp_apertura` int(11) DEFAULT NULL,
  `data_scadenza` char(255) DEFAULT NULL,
  `ora_scadenza` char(255) DEFAULT NULL,
  `data_programmazione` char(255) DEFAULT NULL,
  `id_giorno_programmazione` bigint(20) DEFAULT NULL,
  `ora_inizio_programmazione` char(255) DEFAULT NULL,
  `ora_fine_programmazione` char(255) DEFAULT NULL,
  `anno_programmazione` char(255) DEFAULT NULL,
  `settimana_programmazione` char(255) DEFAULT NULL,
  `ore_programmazione` char(255) DEFAULT NULL,
  `note_programmazione` text DEFAULT NULL,
  `data_chiusura` char(255) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `posti_disponibili` char(32) DEFAULT NULL,
  `se_prova` int(1) DEFAULT NULL,
  `se_prenotabile_online` int(1) DEFAULT NULL,
  `posti_prova` int(11) DEFAULT NULL,
  `id_contatto` bigint(20) DEFAULT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `corso` char(255) DEFAULT NULL,
  `discipline` char(255) DEFAULT NULL,
  `id_disciplina` bigint(20) DEFAULT NULL,
  `tipologie_abbonamenti` char(255) DEFAULT NULL,
  `id_pianificazione` bigint(20) DEFAULT NULL,
  `id_immobile` bigint(20) DEFAULT NULL,
  `data_archiviazione` char(255) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  `__label__` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `nome` (`nome`),
  KEY `timestamp_aggiornamento` (`timestamp_aggiornamento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | FINE
