-- 2026-09-23 — cache dei verdetti di verifica degli indirizzi mail ( Emailable )
--
-- Contesto: i form pubblici validano gli indirizzi con Emailable sul blur del campo. Fino a oggi lo
-- faceva il browser, con la chiave scritta nel JavaScript della pagina, e il verdetto si perdeva:
-- lo stesso indirizzo verificato su due form si pagava due volte, e il sito non sapeva niente di
-- quello che aveva gia' verificato. Da oggi la verifica passa da _src/_api/_emailable.verifica.php,
-- che risponde da questa cache e altrimenti chiede a Emailable e ci scrive il verdetto.
--
-- Le due tabelle nascono sul deploy gimbe.istricesrl.it ( 02/09/2026, per le esportazioni in
-- blocco ) e passano qui nello standard: gli id di tipologie_mail_status sono quelli della scala
-- Rating A+/A/B/D/F che usano i gestionali di mailing, e vanno tenuti fissi perche' la traduzione
-- da Emailable ( emailableState2status() ) e' cablata su di loro.
--
-- IDEMPOTENZA. Dove le tabelle esistono gia' le CREATE non fanno niente e le INSERT IGNORE nemmeno.
--
-- PORTABILITA'. Chiave primaria, AUTO_INCREMENT e indici sono dichiarati INLINE nelle CREATE e non
-- aggiunti dopo con ALTER come nei file base: su MySQL 8.4 con sql_generate_invisible_primary_key
-- una tabella nata senza PK ne riceve una invisibile, e l'ALTER ADD PRIMARY KEY successivo fallisce
-- ( errno 1068 ). Cosi' la patch gira uguale su MariaDB e su MySQL.

-- | 202609231600

-- tipologie_mail_status
-- tipologia: tabella standard
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene gli stati di verifica degli indirizzi mail
--
-- questa tabella contiene la scala degli stati di verifica di un indirizzo mail ( Rating A+/A/B/D/F
-- piu' gli stati dei servizi di mailing ); se_recapitabile codifica la regola del framework per cui
-- si boccia solo sulla prova esplicita di non recapitabilita'
--
CREATE TABLE IF NOT EXISTS `tipologie_mail_status` (          --
  `id` bigint(20) NOT NULL AUTO_INCREMENT,                    -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                              -- ordine di visualizzazione
  `codice` char(32) DEFAULT NULL,                             -- codice della tipologia
  `nome` char(64) DEFAULT NULL,                               -- nome della tipologia
  `note` text DEFAULT NULL,                                   -- descrizione estesa della tipologia
  `se_recapitabile` tinyint(1) DEFAULT NULL,                  -- flag che indica se a un indirizzo in questo stato si puo' spedire
  `se_sistema` tinyint(1) DEFAULT NULL,                       -- flag che indica se la tipologia e' una tipologia di sistema
  `id_account_inserimento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha inserito la tipologia
  `timestamp_inserimento` int(11) DEFAULT NULL,               -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,         -- chiave esterna per l'account che ha aggiornato la tipologia
  `timestamp_aggiornamento` int(11) DEFAULT NULL,             -- timestamp di aggiornamento
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`codice`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`codice`,`nome`,`se_recapitabile`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 202609231601

-- mail_status
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene i verdetti di verifica degli indirizzi mail
--
-- questa tabella e' la cache dei verdetti di verifica degli indirizzi mail ( Emailable ), chiavata
-- sull'indirizzo e non sull'anagrafica: lo stesso indirizzo ha un verdetto solo, chiunque lo usi,
-- e una verifica si paga una volta per tutta la durata della cache; la scrivono e la leggono le
-- funzioni di _src/_lib/_emailable.utils.php
--
CREATE TABLE IF NOT EXISTS `mail_status` (                    --
  `id` bigint(20) NOT NULL AUTO_INCREMENT,                    -- chiave primaria
  `indirizzo` char(128) DEFAULT NULL,                         -- indirizzo mail verificato, normalizzato in minuscolo (chiave logica)
  `dominio` char(128) DEFAULT NULL,                           -- dominio dell'indirizzo, per le statistiche per dominio
  `id_tipologia` bigint(20) DEFAULT NULL,                     -- chiave esterna per lo stato dell'indirizzo (tipologie_mail_status)
  `stato` char(32) DEFAULT NULL,                              -- stato grezzo restituito dal servizio di verifica (state)
  `motivo` char(64) DEFAULT NULL,                             -- motivo grezzo restituito dal servizio di verifica (reason)
  `punteggio` int(11) DEFAULT NULL,                           -- punteggio restituito dal servizio di verifica (score, da 0 a 100)
  `se_accept_all` tinyint(1) DEFAULT NULL,                    -- flag che indica se il server accetta qualunque indirizzo
  `se_ruolo` tinyint(1) DEFAULT NULL,                         -- flag che indica se e' un indirizzo di ruolo (info@, ufficio@)
  `se_temporanea` tinyint(1) DEFAULT NULL,                    -- flag che indica se e' una casella usa e getta
  `se_gratuita` tinyint(1) DEFAULT NULL,                      -- flag che indica se e' una casella su dominio gratuito
  `note` text DEFAULT NULL,                                   -- note sulla verifica
  `tentativi` int(11) DEFAULT 0,                              -- numero di verifiche tentate sull'indirizzo
  `timestamp_verifica` int(11) DEFAULT NULL,                  -- timestamp dell'ultima verifica andata a buon fine, regola la scadenza della cache
  `id_account_inserimento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,               -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,         -- chiave esterna per l'account che ha aggiornato la riga
  `timestamp_aggiornamento` int(11) DEFAULT NULL,             -- timestamp di aggiornamento
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`indirizzo`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `dominio` (`dominio`),
  KEY `timestamp_verifica` (`timestamp_verifica`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`indirizzo`,`id_tipologia`,`timestamp_verifica`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 202609231602

-- tipologie_mail_status
INSERT IGNORE INTO `tipologie_mail_status` (`id`, `ordine`, `codice`, `nome`, `note`, `se_recapitabile`, `se_sistema`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	1,	'Rating A+',	'Deliverable +',	'Engagement Activity These emails are deliverable and have a history of clicks or opens. These addresses are always safe to send to!',	1,	1,	NULL,	NULL,	NULL,	NULL),
(2,	2,	'Rating A',	'Deliverable',	'These emails are deliverable. These addresses are always safe to send to!',	1,	1,	NULL,	NULL,	NULL,	NULL),
(3,	3,	'Rating B',	'Accepts All',	'These emails have been deemed as "Accepts All", meaning the server will accept all mail and may bounce it back to sender. We do not recommend sending to the "Accept All" category. All emails with a grade of B should be segmented (until later confirmed valid).',	1,	1,	NULL,	NULL,	NULL,	NULL),
(4,	4,	'Rating D',	'Indeterminate',	'In checking for an email, we were not able to do anything. We do not recommend sending to the "Indeterminate" category. All emails with a grade of D should be segmented off your list.',	1,	1,	NULL,	NULL,	NULL,	NULL),
(5,	5,	'Rating F',	'Undeliverable',	'The emails given a grade of F have been deemed as undeliverable and invalid. Do not send mail to these addresses.',	0,	1,	NULL,	NULL,	NULL,	NULL),
(8,	6,	'Cleaned',	'Puliti da MailChimp / Hard Bounce',	'-',	0,	1,	NULL,	NULL,	NULL,	NULL),
(9,	7,	'Blacklisted',	'Cancellati su MChimp / Blacklisted',	'-',	0,	1,	NULL,	NULL,	NULL,	NULL),
(10,	8,	'Non importabile',	'-',	'-',	0,	1,	NULL,	NULL,	NULL,	NULL),
(20,	9,	'OK',	'-',	'-',	1,	1,	NULL,	NULL,	NULL,	NULL);

-- | FINE FILE
