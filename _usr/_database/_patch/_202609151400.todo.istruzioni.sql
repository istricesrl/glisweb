-- 2026-09-15 — todo_view e todo_view_static: si portano ai deploy le cose che i file di base
-- dichiarano da tempo e che non sono mai arrivate.
--
-- COSA MANCAVA, misurato il 15/09/2026 su tutti e cinque i deploy:
--
--   oggetto                      lughese  bernispa  crmfia  gimbe  polmasi
--   tabella istruzioni           MANCA    si        MANCA   MANCA  si
--   todo.id_documento            MANCA    si        MANCA   MANCA  si
--   todo.id_documenti_articoli   MANCA    si        MANCA   MANCA  si
--   todo.id_istruzione           MANCA    si        MANCA   MANCA  si
--   todo.codice                  si       si        si      MANCA  si
--   vista taglie_view            si       si        si      MANCA  si
--   vista periodicita_view       si       si        si      MANCA  si
--   todo_view_static, colonne    32       40        34      30     40
--
-- PERCHE' MANCAVANO. Due cause diverse, che si sommavano.
--
-- La prima: il task esegue le patch di un file nell'ordine in cui le trova, e alza il patch level
-- a ogni patch eseguita. I marcatori pero' non erano crescenti — i blocchi aggiunti in coda ai
-- file avevano numeri 999xxx e stavano PRIMA di blocchi numerati piu' bassi — e ogni numero fuori
-- ordine bruciava tutto quello che seguiva. Diciannove patch dei file di base non venivano mai
-- eseguite: la tabella `taglie`, gli indici di carrelli, rinnovi, contratti_anagrafica, licenze e
-- istruzioni, le tre funzioni ruoli_indirizzi_path*, taglie_view e periodicita_view. In piu',
-- quattro file avevano SQL dopo l'ultimo marcatore, che il task legge e butta via: fra quello
-- c'era la CREATE di todo_view_static. Sistemato oggi nei file di base, rimettendo i blocchi in
-- ordine crescente e chiudendo ogni file con `-- | FINE FILE`.
--
-- La seconda, che spiega perche' su tre deploy manca `istruzioni` e su due no: quei tre sono stati
-- installati prima che la tabella entrasse nei file di base, e ai deploy gia' installati i file di
-- base non arrivano mai — ci arrivano solo le patch incrementali, che per questa roba nessuno ha
-- mai scritto. E' questa patch.
--
-- SULLA STATICA. todo_view_static e' la materializzazione di todo_view e refreshStaticView() ci
-- scrive dentro copiando le sole colonne che le due hanno in comune, con un LOG_WARNING per le
-- altre: una statica corta non rompe niente, semplicemente non riporta le colonne nuove. Qui si
-- allinea e si ripopola. Il ripopolamento e' l'unica parte non istantanea, ma i tre deploy da
-- allineare hanno `todo` VUOTA ( lughese 0, crmfia 0, gimbe 0 ): dove ci sono righe davvero
-- — polmasi, 127.588 — la statica era gia' a 40 colonne e non c'e' niente da rifare.

-- | 202609151400

-- la tabella delle istruzioni di lavorazione, che todo_view cita
CREATE TABLE IF NOT EXISTS `istruzioni` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,                                    -- chiave primaria
  `id_tipologia` bigint(20) DEFAULT NULL,                      -- chiave esterna per la tipologia
  `id_prodotto` char(32) DEFAULT NULL,                         -- chiave esterna per il prodotto
  `id_articolo` char(32) DEFAULT NULL,                         -- chiave esterna per l'articolo
  `nome` char(128) DEFAULT NULL,                               -- nome dell'istruzione
  `id_account_inserimento` bigint(20) DEFAULT NULL,            -- chiave esterna per l'account che ha inserito
  `timestamp_inserimento` int(11) DEFAULT NULL,                -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,          -- chiave esterna per l'account che ha aggiornato
  `timestamp_aggiornamento` int(11) DEFAULT NULL,              -- timestamp di aggiornamento
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
-- | 202609151401

-- gli indici di istruzioni, anche loro mai arrivati
ALTER TABLE `istruzioni`
	ADD KEY IF NOT EXISTS `id_tipologia` (`id_tipologia`),
	ADD KEY IF NOT EXISTS `id_prodotto` (`id_prodotto`),
	ADD KEY IF NOT EXISTS `id_articolo` (`id_articolo`);
-- | 202609151402

-- le colonne di todo che la vista legge
ALTER TABLE `todo`
	ADD COLUMN IF NOT EXISTS `anno_programmazione` year(4) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `data_archiviazione` date DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `data_chiusura` date DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `data_programmazione` date DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `data_scadenza` date DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_aggiornamento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_inserimento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_anagrafica` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_cliente` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_contatto` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_documenti_articoli` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_documento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_immobile` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_indirizzo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_istruzione` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_luogo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_pianificazione` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_progetto` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_tipologia` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `nome` char(255) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `ora_fine_programmazione` time DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `ora_inizio_programmazione` time DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `ora_scadenza` time DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `ore_programmazione` decimal(5,2) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `settimana_programmazione` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_apertura` int(11) DEFAULT NULL;

-- | 202609151403

-- la tabella taglie, che taglie_view usa: e' una di quelle che non venivano mai create, perche'
-- nei file di base stava dopo un marcatore fuori ordine. Sui cinque deploy c'e' ( ci e' arrivata
-- per altre vie ), ma su un'installazione fatta dai file non c'era: verificato il 15/09/2026 su
-- com_istricesrl_glistest_dev, dove questa patch e' morta proprio qui. Una patch che ricrea una
-- vista deve garantirsi le tabelle che la vista legge.
CREATE TABLE IF NOT EXISTS `taglie` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,                                     -- chiave primaria
  `id_tipologia_prodotti` bigint(20) DEFAULT NULL,              -- chiave esterna per la tipologia di prodotto
  `nome` char(64) DEFAULT NULL,                                 -- nome della taglia
  `sesso` enum('M','F','-') DEFAULT NULL,                       -- sesso a cui la taglia si riferisce
  `taglia_internazionale` char(8) DEFAULT NULL,                 -- corrispondenza internazionale
  `circonferenza_testa_min` int(11) DEFAULT NULL,               -- per i capi che si misurano sulla testa
  `circonferenza_testa_max` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609151404

-- le colonne di taglie che la vista legge. Su gimbe la tabella c'e' ma e' una versione vecchia
-- senza `nome`, e taglie_view muore con "Unknown column 'taglie.nome'": e' la terza volta oggi che
-- una vista dei file di base chiede a un deploy una colonna che non ha, e la regola ormai e'
-- chiara — prima si allinea quello che la vista legge, poi la si crea.
ALTER TABLE `taglie`
	ADD COLUMN IF NOT EXISTS `id_tipologia_prodotti` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `nome` char(64) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `sesso` enum('M','F','-') DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `taglia_internazionale` char(8) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `circonferenza_testa_min` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `circonferenza_testa_max` int(11) DEFAULT NULL;

-- | 202609151405

-- taglie_view, saltata nei file di base perche' il marcatore che la precede era fuori ordine
CREATE OR REPLACE VIEW `taglie_view` AS
	SELECT
		taglie.id,
		taglie.nome AS __label__
	FROM taglie
;
-- | 202609151406

-- e le colonne di periodicita, per lo stesso motivo: a gimbe manca `giorni`
ALTER TABLE `periodicita`
	ADD COLUMN IF NOT EXISTS `nome` char(255) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `giorni` int(11) DEFAULT NULL;

-- | 202609151407

-- periodicita_view, stessa storia
CREATE OR REPLACE VIEW `periodicita_view` AS
	SELECT
		periodicita.id,
		periodicita.nome,
		periodicita.giorni,
		periodicita.nome AS __label__
	FROM periodicita
;
-- | 202609151408

-- e adesso todo_view, che tutte queste cose le usa
CREATE OR REPLACE VIEW `todo_view` AS select `todo`.`id` AS `id`,`todo`.`id_tipologia` AS `id_tipologia`,`tipologie_todo`.`nome` AS `tipologia`,`todo`.`codice` AS `codice`,`tipologie_todo`.`se_agenda` AS `se_agenda`,`todo`.`id_anagrafica` AS `id_anagrafica`,coalesce(`a1`.`denominazione`,concat(`a1`.`cognome`,' ',`a1`.`nome`),'') AS `anagrafica`,`todo`.`id_cliente` AS `id_cliente`,coalesce(`a2`.`denominazione`,concat(`a2`.`cognome`,' ',`a2`.`nome`),'') AS `cliente`,`todo`.`id_indirizzo` AS `id_indirizzo`,concat_ws(' ',`indirizzi`.`indirizzo`,`indirizzi`.`civico`,`indirizzi`.`cap`,`indirizzi`.`localita`,`comuni`.`nome`,`provincie`.`sigla`) AS `indirizzo`,`todo`.`id_luogo` AS `id_luogo`,`luoghi_path`(`todo`.`id_luogo`) AS `luogo`,`todo`.`timestamp_apertura` AS `timestamp_apertura`,`todo`.`data_scadenza` AS `data_scadenza`,`todo`.`ora_scadenza` AS `ora_scadenza`,`todo`.`data_programmazione` AS `data_programmazione`,`todo`.`ora_inizio_programmazione` AS `ora_inizio_programmazione`,`todo`.`ora_fine_programmazione` AS `ora_fine_programmazione`,`todo`.`anno_programmazione` AS `anno_programmazione`,`todo`.`settimana_programmazione` AS `settimana_programmazione`,`todo`.`ore_programmazione` AS `ore_programmazione`,`todo`.`data_chiusura` AS `data_chiusura`,`todo`.`nome` AS `nome`,`todo`.`id_contatto` AS `id_contatto`,`todo`.`id_progetto` AS `id_progetto`,`progetti`.`nome` AS `progetto`,group_concat(distinct if(`d`.`id`,`categorie_progetti_path`(`d`.`id`),NULL) separator ' | ') AS `discipline`,`todo`.`id_documento` AS `id_documento`,concat(`tipologie_documenti`.`sigla`,' ',concat_ws('/',`documenti`.`numero`,`documenti`.`sezionale`),' del ',`documenti`.`data`) AS `documento`,`todo`.`id_documenti_articoli` AS `id_documenti_articoli`,concat(`documenti_articoli`.`data`,' / ',`tipologie_documenti`.`sigla`,' / ',`documenti_articoli`.`quantita`,' x ',`documenti_articoli`.`id_articolo`) AS `documenti_articoli`,`todo`.`id_istruzione` AS `id_istruzione`,concat(`istruzioni`.`id_tipologia`,coalesce(`istruzioni`.`id_prodotto`,`istruzioni`.`id_articolo`),`istruzioni`.`nome`) AS `istruzione`,`todo`.`id_pianificazione` AS `id_pianificazione`,`todo`.`id_immobile` AS `id_immobile`,`todo`.`data_archiviazione` AS `data_archiviazione`,`todo`.`id_account_inserimento` AS `id_account_inserimento`,`todo`.`id_account_aggiornamento` AS `id_account_aggiornamento`,concat(`todo`.`nome`,coalesce(concat(' per ',`a2`.`denominazione`,concat(`a2`.`cognome`,' ',`a2`.`nome`)),''),coalesce(concat(' su ',`todo`.`id_progetto`,' ',`progetti`.`nome`),'')) AS `__label__` from ((((((((((((((`todo` left join `anagrafica` `a1` on(`a1`.`id` = `todo`.`id_anagrafica`)) left join `anagrafica` `a2` on(`a2`.`id` = `todo`.`id_cliente`)) left join `indirizzi` on(`indirizzi`.`id` = `todo`.`id_indirizzo`)) left join `comuni` on(`comuni`.`id` = `indirizzi`.`id_comune`)) left join `provincie` on(`provincie`.`id` = `comuni`.`id_provincia`)) left join `tipologie_todo` on(`tipologie_todo`.`id` = `todo`.`id_tipologia`)) left join `progetti` on(`progetti`.`id` = `todo`.`id_progetto`)) left join `progetti_categorie` on(`progetti_categorie`.`id_progetto` = `progetti`.`id`)) left join `categorie_progetti` `d` on(`d`.`id` = `progetti_categorie`.`id_categoria` and `d`.`se_disciplina` = 1)) left join `documenti` on(`documenti`.`id` = `todo`.`id_documento`)) left join `tipologie_documenti` on(`tipologie_documenti`.`id` = `documenti`.`id_tipologia`)) left join `documenti_articoli` on(`documenti_articoli`.`id` = `todo`.`id_documenti_articoli`)) left join `tipologie_documenti` `tipologie_documenti_articoli` on(`tipologie_documenti_articoli`.`id` = `documenti_articoli`.`id_tipologia_documento`)) left join `istruzioni` on(`istruzioni`.`id` = `todo`.`id_istruzione`)) group by `todo`.`id`;
-- | 202609151409

-- la statica, dove non c'e'. E' l'oggetto che il problema dei marcatori aveva colpito nel modo
-- piu' silenzioso: nei file di base la sua CREATE sta dopo l'ultimo marcatore di
-- _080000999999.static.sql, quindi un'installazione da zero non la creava e nessuno lo diceva.
-- Sui cinque deploy c'e'; su com_istricesrl_glistest_dev no, ed e' li' che si e' vista.
CREATE TABLE IF NOT EXISTS `todo_view_static` (
  `id` bigint(20) NOT NULL,
  `id_tipologia` bigint(20) DEFAULT NULL,
  `tipologia` char(64) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `se_agenda` tinyint(1) DEFAULT NULL,
  `id_anagrafica` bigint(20) DEFAULT NULL,
  `anagrafica` char(255) DEFAULT NULL,
  `id_cliente` bigint(20) DEFAULT NULL,
  `cliente` char(255) DEFAULT NULL,
  `id_indirizzo` bigint(20) DEFAULT NULL,
  `indirizzo` char(255) DEFAULT NULL,
  `id_luogo` bigint(20) DEFAULT NULL,
  `luogo` char(255) DEFAULT NULL,
  `timestamp_apertura` int(11) DEFAULT NULL,
  `data_scadenza` date DEFAULT NULL,
  `ora_scadenza` time DEFAULT NULL,
  `data_programmazione` date DEFAULT NULL,
  `ora_inizio_programmazione` time DEFAULT NULL,
  `ora_fine_programmazione` time DEFAULT NULL,
  `anno_programmazione` int(4) DEFAULT NULL,
  `settimana_programmazione` int(4) DEFAULT NULL,
  `ore_programmazione` decimal(5,2) DEFAULT NULL,
  `data_chiusura` char(21) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `id_contatto` bigint(20) DEFAULT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `progetto` char(255) DEFAULT NULL,
  `discipline` char(255) DEFAULT NULL,
  `id_documento` bigint(20) DEFAULT NULL,
  `documento` char(255) DEFAULT NULL,
  `id_documenti_articoli` bigint(20) DEFAULT NULL,
  `documenti_articoli` char(255) DEFAULT NULL,
  `id_istruzione` bigint(20) DEFAULT NULL,
  `istruzione` char(255) DEFAULT NULL,
  `id_pianificazione` bigint(20) DEFAULT NULL,
  `id_immobile` bigint(20) DEFAULT NULL,
  `data_archiviazione` char(32) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `__label__` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609151410

-- la statica allineata alla vista: stesse colonne, perche' refreshStaticView() copia le comuni
ALTER TABLE `todo_view_static`
	ADD COLUMN IF NOT EXISTS `id_tipologia` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `tipologia` char(64) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_agenda` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_anagrafica` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `anagrafica` char(255) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_cliente` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `cliente` char(255) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_indirizzo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `indirizzo` char(255) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_luogo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `luogo` char(255) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_apertura` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `data_scadenza` date DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `ora_scadenza` time DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `data_programmazione` date DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `ora_inizio_programmazione` time DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `ora_fine_programmazione` time DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `anno_programmazione` int(4) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `settimana_programmazione` int(4) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `ore_programmazione` decimal(5,2) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `data_chiusura` char(21) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `nome` char(255) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_contatto` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_progetto` char(32) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `progetto` char(255) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `discipline` char(255) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_documento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `documento` char(255) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_documenti_articoli` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `documenti_articoli` char(255) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_istruzione` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `istruzione` char(255) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_pianificazione` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_immobile` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `data_archiviazione` char(32) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_inserimento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_aggiornamento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `__label__` text DEFAULT NULL;

-- | 202609151411

-- e ripopolata, con lo stesso REPLACE che usa refreshStaticView()
REPLACE INTO `todo_view_static` ( `id`, `id_tipologia`, `tipologia`, `codice`, `se_agenda`, `id_anagrafica`, `anagrafica`, `id_cliente`, `cliente`, `id_indirizzo`, `indirizzo`, `id_luogo`, `luogo`, `timestamp_apertura`, `data_scadenza`, `ora_scadenza`, `data_programmazione`, `ora_inizio_programmazione`, `ora_fine_programmazione`, `anno_programmazione`, `settimana_programmazione`, `ore_programmazione`, `data_chiusura`, `nome`, `id_contatto`, `id_progetto`, `progetto`, `discipline`, `id_documento`, `documento`, `id_documenti_articoli`, `documenti_articoli`, `id_istruzione`, `istruzione`, `id_pianificazione`, `id_immobile`, `data_archiviazione`, `id_account_inserimento`, `id_account_aggiornamento`, `__label__` ) SELECT `id`, `id_tipologia`, `tipologia`, `codice`, `se_agenda`, `id_anagrafica`, `anagrafica`, `id_cliente`, `cliente`, `id_indirizzo`, `indirizzo`, `id_luogo`, `luogo`, `timestamp_apertura`, `data_scadenza`, `ora_scadenza`, `data_programmazione`, `ora_inizio_programmazione`, `ora_fine_programmazione`, `anno_programmazione`, `settimana_programmazione`, `ore_programmazione`, `data_chiusura`, `nome`, `id_contatto`, `id_progetto`, `progetto`, `discipline`, `id_documento`, `documento`, `id_documenti_articoli`, `documenti_articoli`, `id_istruzione`, `istruzione`, `id_pianificazione`, `id_immobile`, `data_archiviazione`, `id_account_inserimento`, `id_account_aggiornamento`, `__label__` FROM `todo_view`;

-- | FINE FILE
