-- 2026-09-29 — le tabelle uscite dai file di base nel riallineamento del 02/03/2026
--
-- Contesto: il riallineamento d975b4a15 ha tolto dai file di base un centinaio di tabelle che il codice del
-- framework e dei moduli della linea nuova continuava a usare ( immobili, certificazioni, risorse, mailing,
-- annunci, banner, popup, coupon, periodi, orari, luoghi, conversazioni e le loro tabelle di relazione e di
-- tipologia ), con i loro indici, vincoli, funzioni *_path, viste e dati standard. I file di base le hanno di
-- nuovo, nelle forme di prima di marzo portate a bigint e al modello di marzo ( articoli, prodotti,
-- progetti, coupon e consensi con id numerico ); qui le si porta ai deploy che non le hanno.
--
-- COSA FA, E COSA NO. I deploy installati prima di marzo hanno gia' tabelle, funzioni e viste, e per loro
-- questa patch non fa niente: le tabelle si creano con CREATE TABLE IF NOT EXISTS, con chiave primaria e
-- indici dentro la CREATE; funzioni e viste con IF NOT EXISTS, perche' una vista rifatta sopra una tabella
-- di forma diversa fermerebbe il task. Le chiavi esterne restano nei soli file di base: sui deploy vecchi ci
-- sono, e dove le tabelle nascono adesso le porta il prossimo confronto con _database.rebuild.check.sh.
-- redirect_azioni, che una chiave primaria non l'ha mai avuta, la riceve con la guardia sui doppioni di
-- _202609291500.chiavi.primarie.sql.
--
-- I marcatori saltano i minuti oltre il 59 perche' restino orari validi.
--
-- IDEMPOTENTE.

-- | 202609291900

-- anagrafica_certificazioni
CREATE TABLE IF NOT EXISTS `anagrafica_certificazioni` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_anagrafica` bigint(20) DEFAULT NULL,
  `id_certificazione` bigint(20) DEFAULT NULL,
  `id_emittente` bigint(20) DEFAULT NULL,
  `nome` char(1) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `data_emissione` date DEFAULT NULL,
  `data_scadenza` date DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_anagrafica`,`id_certificazione`, `codice`),
  KEY `id_certificazione` (`id_certificazione`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_emittente` (`id_emittente`),
  KEY `nome` (`nome`),
  KEY `codice` (`codice`),
  KEY `data_emissione` (`data_emissione`),
  KEY `data_scadenza` (`data_scadenza`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_anagrafica`,`id_certificazione`,`codice`, `id_emittente`, `nome`, `data_emissione`, `data_scadenza`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291901

-- anagrafica_cittadinanze
CREATE TABLE IF NOT EXISTS `anagrafica_cittadinanze` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_anagrafica` bigint(20) DEFAULT NULL,
  `id_stato` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `data_inizio` date DEFAULT NULL,
  `data_fine` date DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_anagrafica`,`id_stato`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_stato` (`id_stato`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_anagrafica`,`id_stato`,`ordine`,`data_inizio`,`data_fine`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291902

-- anagrafica_consensi
CREATE TABLE IF NOT EXISTS `anagrafica_consensi` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_account` bigint(20) DEFAULT NULL,
  `id_anagrafica` bigint(20) DEFAULT NULL,
  `id_consenso` bigint(20) DEFAULT NULL,
  `se_prestato` tinyint(1) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `timestamp_consenso` int(11) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_anagrafica`, `id_consenso`),
  KEY `id_account` (`id_account`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_consenso` (`id_consenso`),
  KEY `se_prestato` (`se_prestato`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`, `id_account`,`id_anagrafica`, `id_consenso`, `se_prestato` )
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291903

-- anagrafica_progetti
CREATE TABLE IF NOT EXISTS `anagrafica_progetti` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_anagrafica` bigint(20) DEFAULT NULL,
  `id_progetto` bigint(20) DEFAULT NULL,
  `id_todo` bigint(20) DEFAULT NULL,
  `id_ruolo` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `se_attesa` tinyint(1) DEFAULT NULL,
  `se_sostituto` tinyint(1) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` bigint(20) DEFAULT NULL,	
  `note_inserimento` text NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `note_aggiornamento` text NULL,
  `timestamp_archiviazione` int(11) DEFAULT NULL,
  `id_account_archiviazione` bigint(20) DEFAULT NULL,
  `note_archiviazione` text NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_anagrafica`,`id_progetto`,`id_ruolo`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_progetto` (`id_progetto`),
  KEY `id_ruolo` (`id_ruolo`),
  KEY `ordine` (`ordine`),
  KEY `se_attesa` (`se_attesa`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_anagrafica`,`id_progetto`,`id_ruolo`,`ordine`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291904

-- anagrafica_settori
CREATE TABLE IF NOT EXISTS `anagrafica_settori` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_anagrafica` bigint(20) DEFAULT NULL,
  `id_settore` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_anagrafica`,`id_settore`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_settore` (`id_settore`),
  KEY `ordine` (`ordine`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_anagrafica`,`id_settore`,`ordine`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291905

-- annunci
CREATE TABLE IF NOT EXISTS `annunci` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_tipologia` bigint(20) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `testo` text DEFAULT NULL,
  `id_categoria_prodotti` bigint(20) DEFAULT NULL,
  `id_prodotto` bigint(20) DEFAULT NULL,
  `id_articolo` bigint(20) DEFAULT NULL,
  `quantita` decimal(9,2) DEFAULT NULL,
  `id_udm` bigint(20) DEFAULT NULL,
  `data_inizio_validita` date DEFAULT NULL,
  `ora_inizio_validita` time DEFAULT NULL,
  `note_inizio_validita` text DEFAULT NULL,
  `data_fine_validita` date DEFAULT NULL,
  `ora_fine_validita` time DEFAULT NULL,
  `note_fine_validita` text DEFAULT NULL,
  `note` text DEFAULT NULL,
  `template` char(255) DEFAULT NULL,
  `schema_html` char(128) DEFAULT NULL,
  `tema_css` char(128) DEFAULT NULL,
  `se_sitemap` tinyint(1) DEFAULT NULL,
  `se_cacheable` tinyint(1) DEFAULT NULL,
  `id_sito` bigint(20) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `nome` (`nome`),
  KEY `id_categoria_prodotti` (`id_categoria_prodotti`),
  KEY `id_prodotto` (`id_prodotto`),
  KEY `id_articolo` (`id_articolo`),
  KEY `id_udm` (`id_udm`),
  KEY `id_sito` (`id_sito`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291906

-- annunci_categorie
CREATE TABLE IF NOT EXISTS `annunci_categorie` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_annuncio` bigint(20) DEFAULT NULL,
  `id_categoria` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_annuncio` (`id_annuncio`),
  KEY `id_categoria` (`id_categoria`),
  KEY `ordine` (`ordine`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291907

-- badge
CREATE TABLE IF NOT EXISTS `badge` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_tipologia` bigint(20) DEFAULT NULL,
  `id_contratto` bigint(20) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `rfid` char(32) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `note` text NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`rfid`),
  UNIQUE KEY `codice` (`id_tipologia`, `codice`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_contratto` (`id_contratto`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`, `id_tipologia`, `id_contratto`, `codice`, `rfid`,`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291908

-- banner
CREATE TABLE IF NOT EXISTS `banner` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_tipologia` bigint(20) DEFAULT NULL,
  `id_sito` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `id_inserzionista` bigint(20) DEFAULT NULL,
  `altezza_modulo` int(11) DEFAULT NULL,
  `larghezza_modulo` int(11) DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` bigint(20) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_sito` (`id_sito`),
  KEY `ordine` (`ordine`),
  KEY `nome` (`nome`),
  KEY `id_inserzionista` (`id_inserzionista`),
  KEY `altezza_modulo` (`altezza_modulo`),
  KEY `larghezza_modulo` (`larghezza_modulo`),
  KEY `token` (`token`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`, `id_tipologia`, `id_sito`, `ordine`,`nome`, `id_inserzionista`,`altezza_modulo`,`larghezza_modulo`, `token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291909

-- banner_azioni
CREATE TABLE IF NOT EXISTS `banner_azioni` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_pagina` bigint(20) DEFAULT NULL,
  `id_banner` bigint(20) DEFAULT NULL,
  `azione` enum('visualizzazione','click') DEFAULT NULL,
  `timestamp_azione` int(11) DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_banner` (`id_banner`),
  KEY `id_pagina` (`id_pagina`),
  KEY `azione` (`azione`),
  KEY `timestamp_azione` (`timestamp_azione`),
  KEY `token` (`token`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_pagina`,`id_banner`,`azione`,`timestamp_azione`,`token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291910

-- banner_pagine
CREATE TABLE IF NOT EXISTS `banner_pagine` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_pagina` bigint(20) DEFAULT NULL,
  `id_banner` bigint(20) DEFAULT NULL,
  `se_presente` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_pagina`,`id_banner`),
  KEY `id_banner` (`id_banner`),
  KEY `id_pagina` (`id_pagina`),
  KEY `se_presente` (`se_presente`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_pagina`,`id_banner`,`se_presente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291911

-- banner_zone
CREATE TABLE IF NOT EXISTS `banner_zone` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_zona` bigint(20) DEFAULT NULL,
  `id_banner` bigint(20) DEFAULT NULL,
  `se_presente` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_zona`,`id_banner`),
  KEY `id_banner` (`id_banner`),
  KEY `id_zona` (`id_zona`),
  KEY `se_presente` (`se_presente`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_zona`,`id_banner`,`se_presente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291912

-- campagne
CREATE TABLE IF NOT EXISTS `campagne` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `nome` char(128) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291913

-- carrelli_consensi
CREATE TABLE IF NOT EXISTS `carrelli_consensi` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_account` bigint(20) DEFAULT NULL,
  `id_anagrafica` bigint(20) DEFAULT NULL,
  `id_carrello` bigint(20) DEFAULT NULL,
  `id_consenso` bigint(20) DEFAULT NULL,
  `se_prestato` tinyint(1) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `timestamp_consenso` int(11) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_carrello`, `id_consenso`),
  KEY `id_account` (`id_account`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_carrello` (`id_carrello`),
  KEY `id_consenso` (`id_consenso`),
  KEY `se_prestato` (`se_prestato`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`, `id_account`, `id_anagrafica`, `id_carrello`, `id_consenso`, `se_prestato` )
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291914

-- carrelli_documenti
CREATE TABLE IF NOT EXISTS `carrelli_documenti` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_carrello` bigint(20) DEFAULT NULL,
  `id_documento` bigint(20) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_carrello`,`id_documento`),
  KEY `id_carrello` (`id_carrello`),
  KEY `id_documento` (`id_documento`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`, `id_carrello`,  `id_documento`, `id_account_inserimento`, `id_account_aggiornamento` )
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291915

-- categorie_annunci
CREATE TABLE IF NOT EXISTS `categorie_annunci` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_genitore` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `template` char(255) DEFAULT NULL,
  `schema_html` char(128) DEFAULT NULL,
  `tema_css` char(128) DEFAULT NULL,
  `se_sitemap` tinyint(1) DEFAULT NULL,
  `se_cacheable` tinyint(1) DEFAULT NULL,
  `id_sito` bigint(20) DEFAULT NULL,
  `id_pagina` bigint(20) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  UNIQUE KEY `codice` (`codice`),
  KEY `id_genitore` (`id_genitore`),
  KEY `id_sito` (`id_sito`),
  KEY `id_pagina` (`id_pagina`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`id_sito`,`id_pagina`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291916

-- categorie_risorse
CREATE TABLE IF NOT EXISTS `categorie_risorse` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_genitore` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `template` char(255) DEFAULT NULL,
  `schema_html` char(128) DEFAULT NULL,
  `tema_css` char(128) DEFAULT NULL,
  `se_sitemap` tinyint(1) DEFAULT NULL,
  `se_cacheable` tinyint(1) DEFAULT NULL,
  `id_sito` bigint(20) DEFAULT NULL,
  `id_pagina` bigint(20) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  UNIQUE KEY `codice` (`codice`),
  KEY `id_genitore` (`id_genitore`),
  KEY `id_sito` (`id_sito`),
  KEY `id_pagina` (`id_pagina`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`id_pagina`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291917

-- causali
CREATE TABLE IF NOT EXISTS `causali` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `nome` char(64) NOT NULL,
  `se_trasporto` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`nome`),
  KEY `nome` (`nome`),
  KEY `se_trasporto` (`se_trasporto`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`nome`,`se_trasporto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291918

-- certificazioni
CREATE TABLE IF NOT EXISTS `certificazioni` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `nome` char(255) DEFAULT NULL,
  `se_identificazione` tinyint(1) DEFAULT NULL,
  `se_medico` tinyint(1) DEFAULT NULL,
  `se_sportivo` tinyint(1) DEFAULT NULL,
  `se_agonistico` tinyint(1) DEFAULT NULL,
  `se_immobili` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291919

-- chiavi
CREATE TABLE IF NOT EXISTS `chiavi` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_licenza` bigint(20) DEFAULT NULL,
  `id_tipologia` bigint(20) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `seriale` char(32) DEFAULT NULL,
  `nome` char(32) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_licenza`,`codice`),
  UNIQUE KEY `codice` (`codice`),
  KEY `seriale` (`seriale`),
  KEY `id_licenza` (`id_licenza`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `indice` (`id`,`codice`, `seriale`,`nome`,`id_licenza`, `id_tipologia`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291920

-- classi_energetiche
CREATE TABLE IF NOT EXISTS `classi_energetiche` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `nome` char(8) DEFAULT NULL,
  `ep_min` int(11) DEFAULT NULL,
  `ep_max` int(11) DEFAULT NULL,
  `rgb` char(8) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291921

-- colori
CREATE TABLE IF NOT EXISTS `colori` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_genitore` bigint(20) DEFAULT NULL,
  `nome` char(16) DEFAULT NULL,
  `hex` char(8) DEFAULT NULL,
  `r` int(3) DEFAULT NULL,
  `g` int(3) DEFAULT NULL,
  `b` int(3) DEFAULT NULL,
  `ral` char(16) DEFAULT NULL,
  `pantone` char(8) DEFAULT NULL,
  `c` decimal(5,2) DEFAULT NULL,
  `m` decimal(5,2) DEFAULT NULL,
  `y` decimal(5,2) DEFAULT NULL,
  `k` decimal(5,2) DEFAULT NULL,
  `css` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica_hex` (`nome`,`hex`),
  UNIQUE KEY `unica_rgb` (`nome`,`r`,`g`,`b`),
  UNIQUE KEY `unica_ral` (`nome`,`ral`),
  UNIQUE KEY `unica_pantone` (`nome`,`pantone`),
  UNIQUE KEY `unica_cmyk` (`nome`,`c`,`m`,`y`,`k`),
  UNIQUE KEY `unica` (`nome`, `id_genitore`),
  KEY `id_genitore` (`id_genitore`),
  KEY `indice` (`id`, `nome`,`id_genitore`,`hex`,`r`,`g`,`b`),
  KEY `indice_ral` (`id`, `nome`,`id_genitore`,`ral`),
  KEY `indice_pantone` (`id`, `nome`,`id_genitore`,`pantone`),
  KEY `indice_cmyk` (`id`, `nome`,`id_genitore`,`c`,`m`,`y`,`k`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291922

-- condizioni
CREATE TABLE IF NOT EXISTS `condizioni` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `nome` char(32) DEFAULT NULL,
  `se_catalogo` tinyint(1) DEFAULT NULL,
  `se_immobili` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`nome`),
  KEY `nome` (`nome`),
  KEY `se_catalogo` (`se_catalogo`),
  KEY `se_immobili` (`se_immobili`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291923

-- contratti_progetti
CREATE TABLE IF NOT EXISTS `contratti_progetti` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_contratto` bigint(20) DEFAULT NULL,
  `id_progetto` bigint(20) DEFAULT NULL,
  `id_ruolo` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` bigint(20) DEFAULT NULL,	
  `note_inserimento` text NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `note_aggiornamento` text NULL,
  `timestamp_archiviazione` int(11) DEFAULT NULL,
  `id_account_archiviazione` bigint(20) DEFAULT NULL,
  `note_archiviazione` text NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_contratto`, `id_progetto`, `id_ruolo`),
  KEY `id_contratto` (`id_contratto`),
  KEY `id_progetto` (`id_progetto`),
  KEY `id_ruolo` (`id_ruolo`),
  KEY `ordine` (`ordine`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `id_account_archiviazione` (`id_account_archiviazione`),
  KEY `indice` (`id`, `id_contratto`, `id_progetto`, `id_ruolo`, `ordine`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291924

-- conversazioni
CREATE TABLE IF NOT EXISTS `conversazioni` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_annuncio` bigint(20) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `id_articolo` bigint(20) DEFAULT NULL,
  `quantita` int(11) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `timestamp_apertura` int(11) DEFAULT NULL,
  `timestamp_chiusura` int(11) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_annuncio` (`id_annuncio`),
  KEY `nome` (`nome`),
  KEY `id_articolo` (`id_articolo`),
  KEY `timestamp_apertura` (`timestamp_apertura`),
  KEY `timestamp_chiusura` (`timestamp_chiusura`),
  KEY `indice` (`id`,`nome`,`timestamp_chiusura`,`timestamp_apertura`)
);

-- | 202609291925

-- conversazioni_account
CREATE TABLE IF NOT EXISTS `conversazioni_account` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_conversazione` bigint(20) DEFAULT NULL,
  `id_account` bigint(20) DEFAULT NULL,
  `id_ruolo` bigint(20) DEFAULT NULL,
  `timestamp_lettura` int(11) DEFAULT NULL,
  `timestamp_entrata` int(11) DEFAULT NULL,
  `timestamp_uscita` int(11) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_conversazione`,`id_account`),
  KEY `id_conversazione` (`id_conversazione`),
  KEY `id_account` (`id_account`),
  KEY `timestamp_lettura` (`timestamp_lettura`),
  KEY `timestamp_entrata` (`timestamp_entrata`),
  KEY `timestamp_uscita` (`timestamp_uscita`),
  KEY `indice` (`id`,`id_conversazione`,`id_account`,`timestamp_lettura`,`timestamp_entrata`, `timestamp_uscita`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291926

-- coupon_articoli
CREATE TABLE IF NOT EXISTS `coupon_articoli` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_coupon` bigint(20) NOT NULL,
  `id_articolo` bigint(20) NOT NULL,
  `ordine` int(11) DEFAULT NULL,
  `gruppo_alternative` char(32) NOT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_coupon`,`id_articolo`),
  KEY `id_coupon` (`id_coupon`),
  KEY `id_articolo` (`id_articolo`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_coupon`,`id_articolo`,`ordine`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291927

-- coupon_categorie_prodotti
CREATE TABLE IF NOT EXISTS `coupon_categorie_prodotti` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_coupon` bigint(20) NOT NULL,
  `id_categoria` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_coupon`,`id_categoria`),
  KEY `id_coupon` (`id_coupon`),
  KEY `id_categoria` (`id_categoria`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_coupon`,`id_categoria`,`ordine`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291928

-- coupon_listini
CREATE TABLE IF NOT EXISTS `coupon_listini` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_coupon` bigint(20) NOT NULL,
  `id_listino` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_coupon`,`id_listino`),
  KEY `id_coupon` (`id_coupon`),
  KEY `id_listino` (`id_listino`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_coupon`,`id_listino`,`ordine`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291929

-- coupon_marchi
CREATE TABLE IF NOT EXISTS `coupon_marchi` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_coupon` bigint(20) NOT NULL,
  `id_marchio` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_coupon`,`id_marchio`),
  KEY `id_coupon` (`id_coupon`),
  KEY `id_marchio` (`id_marchio`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_coupon`,`id_marchio`,`ordine`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291930

-- coupon_prodotti
CREATE TABLE IF NOT EXISTS `coupon_prodotti` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_coupon` bigint(20) NOT NULL,
  `id_prodotto` bigint(20) NOT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_coupon`,`id_prodotto`),
  KEY `id_coupon` (`id_coupon`),
  KEY `id_prodotto` (`id_prodotto`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_coupon`,`id_prodotto`,`ordine`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291931

-- crediti
CREATE TABLE IF NOT EXISTS `crediti` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_documenti_articolo` bigint(20) DEFAULT NULL,
  `id_mastro_provenienza` bigint(20) DEFAULT NULL,
  `id_mastro_destinazione` bigint(20) DEFAULT NULL,
  `id_account_destinatario` bigint(20) DEFAULT NULL,
  `id_account_emittente` bigint(20) DEFAULT NULL,
  `id_pianificazione` bigint(20) DEFAULT NULL,
  `data` date DEFAULT NULL,
  `quantita` decimal(9,2) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_documenti_articolo`,`data`,`id_account_emittente`,`id_account_destinatario`, `quantita`),
  KEY `id_documenti_articolo` (`id_documenti_articolo`),
  KEY `id_account_emittente` (`id_account_emittente`),
  KEY `id_account_destinatario` (`id_account_destinatario`),
  KEY `id_mastro_provenienza` (`id_mastro_provenienza`),
  KEY `id_mastro_destinazione` (`id_mastro_destinazione`),
  KEY `id_pianificazione` (`id_pianificazione`),
  KEY `data` (`data`),
  KEY `quantita` (`quantita`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_documenti_articolo`,`data`,`id_account_emittente`,`id_account_destinatario`,`id_mastro_provenienza`,`id_mastro_destinazione`,`id_pianificazione`,  `quantita`,  `nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291932

-- disponibilita
CREATE TABLE IF NOT EXISTS `disponibilita` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `nome` char(32) DEFAULT NULL,
  `se_catalogo` tinyint(1) DEFAULT NULL,
  `se_immobili` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`nome`),
  KEY `nome` (`nome`),
  KEY `se_catalogo` (`se_catalogo`),
  KEY `se_immobili` (`se_immobili`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291933

-- edifici
CREATE TABLE IF NOT EXISTS `edifici` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_tipologia` bigint(20) DEFAULT NULL,
  `id_indirizzo` bigint(20) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `nome` char(128) DEFAULT NULL,
  `piani` int(11) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `codice` (`codice`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_indirizzo` (`id_indirizzo`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`, `id_tipologia`, `id_indirizzo`, `nome`, `codice`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291934

-- edifici_caratteristiche
CREATE TABLE IF NOT EXISTS `edifici_caratteristiche` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_edificio` bigint(20) DEFAULT NULL,
  `id_caratteristica` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `se_presente` tinyint(1) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` bigint(20) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_edificio`,`id_caratteristica`),
  KEY `id_edificio` (`id_edificio`),
  KEY `id_caratteristica` (`id_caratteristica`),
  KEY `ordine` (`ordine`),
  KEY `se_presente` (`se_presente`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_edificio`,`id_caratteristica`,`ordine`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291935

-- giorni
CREATE TABLE IF NOT EXISTS `giorni` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `nome` char(12) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`nome`),
  KEY `nome` (`nome`),
  KEY `indice` (`id`,`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291936

-- immobili
CREATE TABLE IF NOT EXISTS `immobili` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_tipologia` bigint(20) DEFAULT NULL,
  `id_edificio` bigint(20) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `nome` char(32) DEFAULT NULL,
  `scala` char(32) DEFAULT NULL,
  `piano` char(64) DEFAULT NULL,
  `interno` char(8) DEFAULT NULL,
  `campanello` char(128) DEFAULT NULL,
  `catasto_foglio` char(255) DEFAULT NULL,
  `catasto_particella` char(255) DEFAULT NULL,
  `catasto_sub` char(255) DEFAULT NULL,
  `catasto_categoria` char(255) DEFAULT NULL,
  `catasto_classe` char(255) DEFAULT NULL,
  `catasto_consistenza` char(255) DEFAULT NULL,
  `catasto_superficie` char(255) DEFAULT NULL,
  `catasto_rendita` char(255) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_tipologia`,`id_edificio`, `scala`,  `piano`, `interno`, `nome`),
  UNIQUE KEY `codice` (`codice`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_edificio` (`id_edificio`),
  KEY `nome` (`nome`),
  KEY `scala` (`scala`),
  KEY `piano` (`piano`),
  KEY `interno` (`interno`),
  KEY `catasto_foglio` (`catasto_foglio`),
  KEY `catasto_particella` (`catasto_particella`),
  KEY `catasto_sub` (`catasto_sub`),
  KEY `catasto_categoria` (`catasto_categoria`),
  KEY `catasto_classe` (`catasto_classe`),
  KEY `catasto_consistenza` (`catasto_consistenza`),
  KEY `catasto_superficie` (`catasto_superficie`),
  KEY `catasto_rendita` (`catasto_rendita`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291937

-- immobili_anagrafica
CREATE TABLE IF NOT EXISTS `immobili_anagrafica` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_immobile` bigint(20) DEFAULT NULL,
  `id_anagrafica` bigint(20) DEFAULT NULL,
  `id_ruolo` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` bigint(20) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_immobile`,`id_anagrafica`,`id_ruolo`),
  KEY `id_immobile` (`id_immobile`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_ruolo` (`id_ruolo`),
  KEY `ordine` (`ordine`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_immobile`,`id_anagrafica`,`id_ruolo`,`ordine`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291938

-- immobili_caratteristiche
CREATE TABLE IF NOT EXISTS `immobili_caratteristiche` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_immobile` bigint(20) DEFAULT NULL,
  `id_caratteristica` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `se_presente` tinyint(1) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` bigint(20) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_immobile`,`id_caratteristica`),
  KEY `id_immobile` (`id_immobile`),
  KEY `id_caratteristica` (`id_caratteristica`),
  KEY `ordine` (`ordine`),
  KEY `se_presente` (`se_presente`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_immobile`,`id_caratteristica`,`ordine`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291939

-- indirizzi_caratteristiche
CREATE TABLE IF NOT EXISTS `indirizzi_caratteristiche` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_indirizzo` bigint(20) DEFAULT NULL,
  `id_caratteristica` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `se_presente` tinyint(1) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` bigint(20) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_indirizzo`,`id_caratteristica`),
  KEY `id_indirizzo` (`id_indirizzo`),
  KEY `id_caratteristica` (`id_caratteristica`),
  KEY `ordine` (`ordine`),
  KEY `se_presente` (`se_presente`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_indirizzo`,`id_caratteristica`,`ordine`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291940

-- licenze_software
CREATE TABLE IF NOT EXISTS `licenze_software` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_licenza` bigint(20) DEFAULT NULL,
  `id_software` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_licenza`,`id_software`),
  KEY `id_licenza` (`id_licenza`),
  KEY `id_software` (`id_software`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_licenza`,`id_software`,`ordine`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291941

-- liste
CREATE TABLE IF NOT EXISTS `liste` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `nome` char(255) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291942

-- liste_mail
CREATE TABLE IF NOT EXISTS `liste_mail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_lista` bigint(20) DEFAULT NULL,
  `id_mail` bigint(20) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_lista`,`id_mail`),
  KEY `id_lista` (`id_lista`),
  KEY `id_mail` (`id_mail`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291943

-- listini_clienti
CREATE TABLE IF NOT EXISTS `listini_clienti` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_listino` bigint(20) DEFAULT NULL,
  `id_cliente` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_listino`,`id_cliente`),
  KEY `id_listino` (`id_listino`),
  KEY `id_cliente` (`id_cliente`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_listino`,`id_cliente`,`ordine`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291944

-- luoghi
CREATE TABLE IF NOT EXISTS `luoghi` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_genitore` bigint(20) DEFAULT NULL,
  `id_indirizzo` bigint(20) DEFAULT NULL,
  `id_tipologia` bigint(20) DEFAULT NULL,
  `id_edificio` bigint(20) DEFAULT NULL,
  `id_immobile` bigint(20) DEFAULT NULL,
  `url` char(255) DEFAULT NULL, 
  `nome` char(255) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `id_indirizzo` (`id_indirizzo`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_edificio` (`id_edificio`),
  KEY `id_immobile` (`id_immobile`),
  KEY `url` (`url`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`id_indirizzo`,  `id_tipologia`,`id_edificio`, `id_immobile`,`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291945

-- mailing
CREATE TABLE IF NOT EXISTS `mailing` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `nome` char(255) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `promemoria_id_tipologia` int(11) DEFAULT NULL,
  `promemoria_id_anagrafica_programmazione` int(11) DEFAULT NULL,
  `promemoria_nome` char(255) DEFAULT NULL,
  `promemoria_giorni_programmazione` int(11) DEFAULT NULL,
  `promemoria_note_programmazione` text DEFAULT NULL,
  `timestamp_invio` int(11) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291946

-- mailing_liste
CREATE TABLE IF NOT EXISTS `mailing_liste` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_mailing` bigint(20) DEFAULT NULL,
  `id_lista` bigint(20) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_lista`,`id_mailing`),
  KEY `id_mailing` (`id_mailing`),
  KEY `id_lista` (`id_lista`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291947

-- mailing_mail
CREATE TABLE IF NOT EXISTS `mailing_mail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_mailing` bigint(20) DEFAULT NULL,
  `id_mail` bigint(20) DEFAULT NULL,
  `id_mail_out` bigint(20) DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
  `timestamp_generazione` int(11) DEFAULT NULL,
  `timestamp_invio` int(11) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE `unica_mail` (`id_mailing`, `id_mail`),
  KEY `id_mailing` (`id_mailing`),
  KEY `id_mail`(`id_mail`),
  KEY `id_mail_out` (`id_mail_out`),
  KEY `token` (`token`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_mailing`, `id_mail`, `id_mail_out`, `token` )
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291948

-- messaggi
CREATE TABLE IF NOT EXISTS `messaggi` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_conversazione` bigint(20) DEFAULT NULL,
  `testo` text DEFAULT NULL,
  `timestamp_invio` int(11) DEFAULT NULL,
  `timestamp_lettura` int(11) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_conversazione` (`id_conversazione`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_conversazione`,`timestamp_invio`,`timestamp_lettura`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291949

-- metadati_articoli
CREATE TABLE IF NOT EXISTS `metadati_articoli` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_lingua` bigint(20) DEFAULT NULL,
  `id_articolo` bigint(20) DEFAULT NULL,
  `nome` char(128) DEFAULT NULL,
  `testo` text DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica_articolo` (`id_lingua`,`id_articolo`,`nome`),
  KEY `id_lingua` (`id_lingua`),
  KEY `id_articolo` (`id_articolo`),
  KEY `indice` (`id`,`id_lingua`,`id_articolo`,`nome`,`testo` (255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291950

-- metadati_prodotti
CREATE TABLE IF NOT EXISTS `metadati_prodotti` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_lingua` bigint(20) DEFAULT NULL,
  `id_prodotto` bigint(20) DEFAULT NULL,
  `nome` char(128) DEFAULT NULL,
  `testo` text DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica_prodotto` (`id_lingua`,`id_prodotto`,`nome`),
  KEY `id_lingua` (`id_lingua`),
  KEY `id_prodotto` (`id_prodotto`),
  KEY `indice` (`id`,`id_lingua`,`id_prodotto`,`nome`,`testo` (255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291951

-- orari
CREATE TABLE IF NOT EXISTS `orari` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `nome` char(128) DEFAULT NULL,
  `id_tipologia_contratti` bigint(20) DEFAULT NULL,
  `id_periodicita` bigint(20) DEFAULT NULL,
  `id_giorno` bigint(20) DEFAULT NULL,
  `ora_inizio` time NULL,
  `ora_fine` time NULL,
  `note` text NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_tipologia_contratti` (`id_tipologia_contratti`),
  KEY `id_periodicita` (`id_periodicita`),
  KEY `id_giorno` (`id_giorno`),
  KEY `ora_inizio` (`ora_inizio`),
  KEY `ora_fine` (`ora_fine`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_tipologia_contratti`,`id_periodicita`,`id_giorno`,`ora_inizio`,`ora_fine`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291952

-- periodi
CREATE TABLE IF NOT EXISTS `periodi` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_genitore` bigint(20) DEFAULT NULL,
  `id_tipologia` bigint(20) DEFAULT NULL,
  `id_contratto` bigint(20) DEFAULT NULL,
  `data_inizio` date DEFAULT NULL,
  `data_fine` date DEFAULT NULL,
  `nome` char(128) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` ( `data_inizio`, `data_fine`, `id_contratto`, `nome`, `id_genitore`),
  KEY `id_genitore` (`id_genitore`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` ( `id`, `id_genitore`, `data_inizio`, `data_fine`, `nome`,`id_tipologia`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291953

-- pesi_tipologie_corrispondenza
CREATE TABLE IF NOT EXISTS `pesi_tipologie_corrispondenza` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_tipologia` bigint(20) DEFAULT NULL,
  `nome` varchar(128) DEFAULT NULL,
  `grammi_min` decimal(8,2) DEFAULT NULL,
  `grammi_max` decimal(8,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_tipologia` (`id_tipologia`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291954

-- popup
CREATE TABLE IF NOT EXISTS `popup` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_tipologia` bigint(20) DEFAULT NULL,
  `id_sito` bigint(20) DEFAULT NULL,
  `nome` char(128) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `html_id` char(128) DEFAULT NULL,
  `html_class` char(128) DEFAULT NULL,
  `html_class_attivazione` char(128) DEFAULT NULL,
  `n_scroll` int(11) DEFAULT NULL,
  `n_secondi` int(11) DEFAULT NULL,
  `template` char(128) DEFAULT NULL,
  `schema_html` char(128) DEFAULT NULL,
  `se_ovunque` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_sito` (`id_sito`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_tipologia`,`id_sito`,`nome`,`html_id`,`html_class`,`html_class_attivazione`,`n_scroll`,`n_secondi`,`template`,`schema_html`,`se_ovunque`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291955

-- popup_pagine
CREATE TABLE IF NOT EXISTS `popup_pagine` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_pagina` bigint(20) DEFAULT NULL,
  `id_popup` bigint(20) DEFAULT NULL,
  `se_presente` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_pagina`,`id_popup`),
  KEY `id_popup` (`id_popup`),
  KEY `id_pagina` (`id_pagina`),
  KEY `se_presente` (`se_presente`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_pagina`,`id_popup`,`se_presente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291956

-- progetti_anagrafica
CREATE TABLE IF NOT EXISTS `progetti_anagrafica` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_progetto` bigint(20) DEFAULT NULL,
  `id_anagrafica` bigint(20) DEFAULT NULL,
  `id_ruolo` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `se_sostituto` tinyint(1) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` bigint(20) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_progetto`,`id_anagrafica`,`id_ruolo`),
  KEY `id_progetto` (`id_progetto`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_ruolo` (`id_ruolo`),
  KEY `ordine` (`ordine`),
  KEY `se_sostituto` (`se_sostituto`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_progetto`,`id_anagrafica`,`id_ruolo`,`ordine`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291957

-- progetti_articoli
CREATE TABLE IF NOT EXISTS `progetti_articoli` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_progetto` bigint(20) DEFAULT NULL,
  `id_articolo` bigint(20) DEFAULT NULL,
  `id_ruolo` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` bigint(20) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_progetto`,`id_articolo`, `id_ruolo`),
  KEY `id_ruolo` (`id_ruolo`),
  KEY `id_progetto` (`id_progetto`),
  KEY `id_articolo` (`id_articolo`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_progetto`,`id_articolo`, `id_ruolo`,`ordine`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291958

-- progetti_certificazioni
CREATE TABLE IF NOT EXISTS `progetti_certificazioni` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_progetto` bigint(20) DEFAULT NULL,
  `id_certificazione` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(1) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `se_richiesta` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_progetto`,`id_certificazione`),
  KEY `id_progetto` (`id_progetto`),
  KEY `id_certificazione` (`id_certificazione`),
  KEY `ordine` (`ordine`),
  KEY `se_richiesta` (`se_richiesta`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_progetto`,`id_certificazione`,`ordine`,`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291959

-- progetti_matricole
CREATE TABLE IF NOT EXISTS `progetti_matricole` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_progetto` bigint(20) DEFAULT NULL,
  `id_matricola` bigint(20) DEFAULT NULL,
  `id_ruolo` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` bigint(20) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_progetto`,`id_matricola`,`id_ruolo`),
  KEY `id_progetto` (`id_progetto`),
  KEY `id_matricola` (`id_matricola`),
  KEY `id_ruolo` (`id_ruolo`),
  KEY `ordine` (`ordine`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_progetto`,`id_matricola`,`ordine`,`id_ruolo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609292000

-- redirect_azioni
CREATE TABLE IF NOT EXISTS `redirect_azioni` (
  `id` bigint(20) NOT NULL ,
  `id_redirect` bigint(20) DEFAULT NULL,
  `referral` text DEFAULT NULL,
  `azione` enum('redirect') DEFAULT NULL,
  `timestamp_azione` int(11) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609292001

-- relazioni_articoli
CREATE TABLE IF NOT EXISTS `relazioni_articoli` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_articolo` bigint(20) DEFAULT NULL,
  `id_ruolo` bigint(20) DEFAULT NULL,
  `id_prodotto_collegato` bigint(20) DEFAULT NULL,
  `id_articolo_collegato` bigint(20) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_articolo`,`id_ruolo`, `id_prodotto_collegato`),
  KEY `id_articolo` (`id_articolo`),
  KEY `id_ruolo` (`id_ruolo`),
  KEY `id_prodotto_collegato` (`id_prodotto_collegato`),
  KEY `id_articolo_collegato` (`id_articolo_collegato`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`)
);

-- | 202609292002

-- relazioni_categorie_progetti
CREATE TABLE IF NOT EXISTS `relazioni_categorie_progetti` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_categoria` bigint(20) DEFAULT NULL,
  `id_ruolo` bigint(20) DEFAULT NULL,
  `id_categoria_collegata` bigint(20) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_categoria`,`id_ruolo`, `id_categoria_collegata`),
  KEY `id_ruolo` (`id_ruolo`),
  KEY `id_categoria` (`id_categoria`),
  KEY `id_categoria_collegata` (`id_categoria_collegata`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609292003

-- relazioni_documenti_articoli
CREATE TABLE IF NOT EXISTS `relazioni_documenti_articoli` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_documenti_articolo` bigint(20) DEFAULT NULL,
  `id_documenti_articolo_collegato` bigint(20) DEFAULT NULL,
  `id_ruolo` bigint(20) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_documenti_articolo`,`id_documenti_articolo_collegato`,`id_ruolo`),
  KEY `id_documenti_articolo` (`id_documenti_articolo`),
  KEY `id_documenti_articolo_collegato` (`id_documenti_articolo_collegato`),
  KEY `id_ruolo` (`id_ruolo`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609292004

-- relazioni_pagamenti
CREATE TABLE IF NOT EXISTS `relazioni_pagamenti` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_pagamento` bigint(20) DEFAULT NULL,
  `id_pagamento_collegato` bigint(20) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_pagamento`,`id_pagamento_collegato`),
  KEY `id_pagamento` (`id_pagamento`),
  KEY `id_pagamento_collegato` (`id_pagamento_collegato`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609292005

-- relazioni_progetti
CREATE TABLE IF NOT EXISTS `relazioni_progetti` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_progetto` bigint(20) DEFAULT NULL,
  `id_ruolo` bigint(20) DEFAULT NULL,
  `id_progetto_collegato` bigint(20) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_progetto`,`id_progetto_collegato`,`id_ruolo`),
  KEY `id_ruolo` (`id_ruolo`),
  KEY `id_progetto` (`id_progetto`),
  KEY `id_progetto_collegato` (`id_progetto_collegato`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609292006

-- relazioni_software
CREATE TABLE IF NOT EXISTS `relazioni_software` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_software` bigint(20) DEFAULT NULL,
  `id_software_collegato` bigint(20) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_software`,`id_software_collegato`),
  KEY `id_software` (`id_software`),
  KEY `id_software_collegato` (`id_software_collegato`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609292007

-- rinnovi_documenti_articoli
CREATE TABLE IF NOT EXISTS `rinnovi_documenti_articoli` (
`id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_rinnovo` bigint(20) DEFAULT NULL,
  `id_documenti_articolo` bigint(20) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_documenti_articolo`,`id_rinnovo`),
  KEY `id_rinnovo` (`id_rinnovo`),
  KEY `id_documenti_articolo` (`id_documenti_articolo`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609292008

-- risorse
CREATE TABLE IF NOT EXISTS `risorse` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_tipologia` bigint(20) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `template` char(255) DEFAULT NULL,
  `schema_html` char(128) DEFAULT NULL,
  `tema_css` char(128) DEFAULT NULL,
  `se_sitemap` tinyint(1) DEFAULT NULL,
  `se_cacheable` tinyint(1) DEFAULT NULL,
  `id_sito` bigint(20) DEFAULT NULL,
  `id_testata` bigint(20) DEFAULT NULL,
  `id_articolo` bigint(20) DEFAULT NULL,
  `id_prodotto` bigint(20) DEFAULT NULL,
  `giorno_pubblicazione` int(2) DEFAULT NULL,
  `mese_pubblicazione` int(2) DEFAULT NULL,
  `anno_pubblicazione` int(4) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_testata` (`id_testata`),
  KEY `id_articolo` (`id_articolo`),
  KEY `id_prodotto` (`id_prodotto`),
  KEY `id_sito` (`id_sito`),
  KEY `se_sitemap` (`se_sitemap`),
  KEY `se_cacheable` (`se_cacheable`),
  KEY `giorno_pubblicazione` (`giorno_pubblicazione`),
  KEY `mese_pubblicazione` (`mese_pubblicazione`),
  KEY `anno_pubblicazione` (`anno_pubblicazione`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_tipologia`,`codice`,`nome`,`id_testata`,`giorno_pubblicazione`,`mese_pubblicazione`,`anno_pubblicazione`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609292009

-- risorse_account
CREATE TABLE IF NOT EXISTS `risorse_account` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_risorsa` bigint(20) DEFAULT NULL,
  `id_account` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` bigint(20) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_risorsa`,`id_account`),
  KEY `id_account` (`id_account`),
  KEY `id_risorsa` (`id_risorsa`),
  KEY `ordine` (`ordine`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_risorsa`,`id_account`,`ordine`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609292010

-- risorse_anagrafica
CREATE TABLE IF NOT EXISTS `risorse_anagrafica` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_risorsa` bigint(20) DEFAULT NULL,
  `id_anagrafica` bigint(20) DEFAULT NULL,
  `id_ruolo` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` bigint(20) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_risorsa`,`id_anagrafica`,`id_ruolo`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_risorsa` (`id_risorsa`),
  KEY `id_ruolo` (`id_ruolo`),
  KEY `ordine` (`ordine`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_risorsa`,`id_anagrafica`,`id_ruolo`,`ordine`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609292011

-- risorse_categorie
CREATE TABLE IF NOT EXISTS `risorse_categorie` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_risorsa` bigint(20) DEFAULT NULL,
  `id_categoria` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` bigint(20) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_risorsa` (`id_risorsa`),
  KEY `id_categoria` (`id_categoria`),
  KEY `ordine` (`ordine`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_risorsa`,`id_categoria`,`ordine`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609292012

-- ruoli_articoli
CREATE TABLE IF NOT EXISTS `ruoli_articoli` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_genitore` bigint(20) DEFAULT NULL,
  `nome` char(128) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_progetti` tinyint(1) DEFAULT NULL,
  `se_risorse` tinyint(1) DEFAULT NULL,
  `se_acquisto` tinyint(1) DEFAULT NULL,
  `se_rinnovo` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`nome`, `id_genitore`),
  KEY `id_genitore` (`id_genitore`),
  KEY `se_progetti` (`se_progetti`),
  KEY `se_risorse` (`se_risorse`),
  KEY `se_acquisto` (`se_acquisto`),
  KEY `se_rinnovo` (`se_rinnovo`),
  KEY `indice` (`id`,`id_genitore`,`nome`,`se_progetti`,`se_risorse`,`se_acquisto`, `se_rinnovo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609292013

-- ruoli_categorie_progetti
CREATE TABLE IF NOT EXISTS `ruoli_categorie_progetti` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_genitore` bigint(20) DEFAULT NULL,
  `nome` char(32) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_recuperi` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`nome`, `id_genitore`),
  KEY `id_genitore` (`id_genitore`),
  KEY `se_recuperi` (`se_recuperi`),
  KEY `indice` (`id`,`nome`,`html_entity`,`font_awesome`,`se_recuperi`)
);

-- | 202609292014

-- ruoli_matricole
CREATE TABLE IF NOT EXISTS `ruoli_matricole` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_genitore` bigint(20) DEFAULT NULL,
  `nome` char(32) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`nome`, `id_genitore`),
  KEY `id_genitore` (`id_genitore`),
  KEY `indice` (`id`,`id_genitore`,`nome`, `html_entity`, `font_awesome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609292015

-- ruoli_progetti
CREATE TABLE IF NOT EXISTS `ruoli_progetti` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_genitore` bigint(20) NOT NULL,
  `nome` char(128) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_sottoprogetto` tinyint(1) DEFAULT NULL,
  `se_proseguimento` tinyint(1) DEFAULT NULL,
  `se_sostituto` tinyint(1) DEFAULT NULL,
  `se_attesa` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`nome`, `id_genitore`),
  KEY `se_sottoprogetto` (`se_sottoprogetto`),
  KEY `se_proseguimento` (`se_proseguimento`),
  KEY `se_sostituto` (`se_sostituto`),
  KEY `se_attesa` (`se_attesa`),
  KEY `indice` (`id`,`nome`,`se_sottoprogetto`,`se_proseguimento`,`se_sostituto`,`se_attesa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609292016

-- software
CREATE TABLE IF NOT EXISTS `software` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_genitore` bigint(20) DEFAULT NULL,
  `id_articolo` bigint(20) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `json` text DEFAULT NULL, 
  `nome` char(128) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  UNIQUE KEY `codice` (`codice`),
  KEY `id_genitore` (`id_genitore`),
  KEY `id_articolo` (`id_articolo`),
  KEY `json` (`json` (255)),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`id_articolo`,`nome`,`json` (255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609292017

-- stati_lingue
CREATE TABLE IF NOT EXISTS `stati_lingue` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_stato` bigint(20) DEFAULT NULL,
  `id_lingua` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_stato`,`id_lingua`),
  KEY `id_stato` (`id_stato`),
  KEY `id_lingua` (`id_lingua`),
  KEY `ordine` (`ordine`),
  KEY `indice` (`id`,`id_stato`,`id_lingua`,`ordine`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609292018

-- testate
CREATE TABLE IF NOT EXISTS `testate` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `nome` char(128) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609292019

-- tipologie_annunci
CREATE TABLE IF NOT EXISTS `tipologie_annunci` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_genitore` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `sigla` char(32) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `ordine` (`ordine`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609292020

-- tipologie_badge
CREATE TABLE IF NOT EXISTS `tipologie_badge` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_genitore` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `ordine` (`ordine`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609292021

-- tipologie_banner
CREATE TABLE IF NOT EXISTS `tipologie_banner` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_genitore` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `ordine` (`ordine`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609292022

-- tipologie_chiavi
CREATE TABLE IF NOT EXISTS `tipologie_chiavi` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_genitore` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(32) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `ordine` (`ordine`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609292023

-- tipologie_edifici
CREATE TABLE IF NOT EXISTS `tipologie_edifici` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_genitore` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(32) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `ordine` (`ordine`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609292024

-- tipologie_immobili
CREATE TABLE IF NOT EXISTS `tipologie_immobili` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_genitore` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(32) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_residenziale` tinyint(1) DEFAULT NULL,
  `se_industriale` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `ordine` (`ordine`),
  KEY `nome` (`nome`),
  KEY  `se_residenziale` (`se_residenziale`),
  KEY `se_industriale` (`se_industriale`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`, `se_residenziale`, `se_industriale`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609292025

-- tipologie_licenze
CREATE TABLE IF NOT EXISTS `tipologie_licenze` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_genitore` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(32) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `ordine` (`ordine`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609292026

-- tipologie_luoghi
CREATE TABLE IF NOT EXISTS `tipologie_luoghi` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_genitore` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `ordine` (`ordine`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609292027

-- tipologie_mastri
CREATE TABLE IF NOT EXISTS `tipologie_mastri` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_genitore` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_magazzino` tinyint(1) DEFAULT NULL,
  `se_conto` tinyint(1) DEFAULT NULL,
  `se_registro` tinyint(1) DEFAULT NULL,
  `se_credito` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `ordine` (`ordine`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609292028

-- tipologie_periodi
CREATE TABLE IF NOT EXISTS `tipologie_periodi` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_genitore` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_corsi` tinyint(1) DEFAULT NULL,
  `se_tesseramenti` tinyint(1) DEFAULT NULL,
  `se_abbonamenti` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `ordine` (`ordine`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609292029

-- tipologie_popup
CREATE TABLE IF NOT EXISTS `tipologie_popup` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_genitore` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `ordine` (`ordine`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609292030

-- tipologie_risorse
CREATE TABLE IF NOT EXISTS `tipologie_risorse` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_genitore` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `ordine` (`ordine`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609292031

-- tipologie_spedizioni
CREATE TABLE IF NOT EXISTS `tipologie_spedizioni` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_genitore` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `ordine` (`ordine`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609292032

-- todo_matricole
CREATE TABLE IF NOT EXISTS `todo_matricole` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_todo` bigint(20) DEFAULT NULL,
  `id_matricola` bigint(20) DEFAULT NULL,
  `id_ruolo` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` bigint(20) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_todo`,`id_matricola`,`id_ruolo`),
  KEY `id_todo` (`id_todo`),
  KEY `id_matricola` (`id_matricola`),
  KEY `id_ruolo` (`id_ruolo`),
  KEY `ordine` (`ordine`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_todo`,`id_matricola`,`ordine`,`id_ruolo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609292033

-- valutazioni
CREATE TABLE IF NOT EXISTS `valutazioni` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_anagrafica` bigint(20) DEFAULT NULL,
  `id_matricola` bigint(20) DEFAULT NULL,
  `id_immobile` bigint(20) DEFAULT NULL,
  `mq_commerciali` decimal(15,2) DEFAULT NULL,
  `mq_calpestabili` decimal(15,2) DEFAULT NULL,
  `id_condizione` bigint(20) DEFAULT NULL,
  `id_disponibilita` bigint(20) DEFAULT NULL,
  `id_classe_energetica` bigint(20) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `timestamp_valutazione` int(11) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_anagrafica`,`id_immobile`,`timestamp_valutazione`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_matricola` (`id_matricola`),
  KEY `id_immobile` (`id_immobile`),
  KEY `id_condizione` (`id_condizione`),
  KEY `id_disponibilita` (`id_disponibilita`),
  KEY `id_classe_energetica` (`id_classe_energetica`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_matricola`,`id_anagrafica`,`id_immobile`, `id_condizione`, `id_disponibilita`, `id_classe_energetica`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609292034

-- valutazioni_certificazioni
CREATE TABLE IF NOT EXISTS `valutazioni_certificazioni` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_valutazione` bigint(20) DEFAULT NULL,
  `id_certificazione` bigint(20) DEFAULT NULL,
  `id_emittente` bigint(20) DEFAULT NULL,
  `nome` char(1) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `data_emissione` date DEFAULT NULL,
  `data_scadenza` date DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_valutazione`,`id_certificazione`, `codice`),
  KEY `id_certificazione` (`id_certificazione`),
  KEY `id_valutazione` (`id_valutazione`),
  KEY `id_emittente` (`id_emittente`),
  KEY `nome` (`nome`),
  KEY `codice` (`codice`),
  KEY `data_emissione` (`data_emissione`),
  KEY `data_scadenza` (`data_scadenza`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_valutazione`,`id_certificazione`,`codice`, `id_emittente`, `nome`, `data_emissione`, `data_scadenza`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609292035

-- zone_cap
CREATE TABLE IF NOT EXISTS `zone_cap` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ordine` int(11) DEFAULT NULL,
  `id_zona` bigint(20) DEFAULT NULL,
  `cap` char(8) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_zona`,`cap`),
  KEY `id_zona` (`id_zona`),
  KEY `ordine` (`ordine`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`ordine`, `id_zona`,`cap`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609292036

-- zone_indirizzi
CREATE TABLE IF NOT EXISTS `zone_indirizzi` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ordine` int(11) DEFAULT NULL,
  `id_zona` bigint(20) DEFAULT NULL,
  `id_indirizzo` bigint(20) DEFAULT NULL,  
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_zona`,`id_indirizzo`),
  KEY `id_indirizzo` (`id_indirizzo`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `ordine` (`ordine`),
  KEY `indice` (`id`,`ordine`, `id_zona`,`id_indirizzo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609292037

-- zone_stati
CREATE TABLE IF NOT EXISTS `zone_stati` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ordine` int(11) DEFAULT NULL,
  `id_zona` bigint(20) DEFAULT NULL,
  `id_stato` bigint(20) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_zona`,`id_stato`),
  KEY `ordine` (`ordine`),
  KEY `id_stato` (`id_stato`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_zona`,`id_stato`,`ordine`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609292038

-- redirect_azioni, i doppioni
SET @chiavi = IF( EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'redirect_azioni' ) AND NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'redirect_azioni' AND CONSTRAINT_TYPE = 'PRIMARY KEY' ), "SELECT count(*) - count( DISTINCT `id` ) INTO @doppioni FROM `redirect_azioni`", "SELECT 0 INTO @doppioni" );

-- | 202609292039

PREPARE chiavi FROM @chiavi;

-- | 202609292040

EXECUTE chiavi;

-- | 202609292041

DEALLOCATE PREPARE chiavi;

-- | 202609292042

-- redirect_azioni, la chiave
SET @chiavi = IF(
    EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'redirect_azioni' ) AND NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'redirect_azioni' AND CONSTRAINT_TYPE = 'PRIMARY KEY' ) AND @doppioni = 0,
    "ALTER TABLE `redirect_azioni` ADD PRIMARY KEY (`id`), ADD KEY IF NOT EXISTS `id_redirect` (`id_redirect`), ADD KEY IF NOT EXISTS `azione` (`azione`), ADD KEY IF NOT EXISTS `timestamp_azione` (`timestamp_azione`), ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`), ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`), MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT",
    IF( @doppioni > 0,
        "SELECT 'redirect_azioni ha id ripetuti: chiave primaria non aggiunta, i doppioni vanno risolti a mano' AS nota",
        "SELECT 'redirect_azioni ha la chiave primaria o non esiste: niente da fare' AS nota" )
);

-- | 202609292043

PREPARE chiavi FROM @chiavi;

-- | 202609292044

EXECUTE chiavi;

-- | 202609292045

DEALLOCATE PREPARE chiavi;

-- | 202609292046

-- categorie_annunci_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `categorie_annunci_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				categorie_annunci.id_genitore,
				categorie_annunci.nome
			FROM categorie_annunci
			WHERE categorie_annunci.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

-- | 202609292047

-- categorie_annunci_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `categorie_annunci_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				categorie_annunci.id_genitore
			FROM categorie_annunci
			WHERE categorie_annunci.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

-- | 202609292048

-- categorie_annunci_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `categorie_annunci_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				categorie_annunci.id_genitore,
				categorie_annunci.id
			FROM categorie_annunci
			WHERE categorie_annunci.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

-- | 202609292049

-- categorie_risorse_path
-- verifica: 2021-06-02 20:22 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `categorie_risorse_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				categorie_risorse.id_genitore,
				categorie_risorse.nome
			FROM categorie_risorse
			WHERE categorie_risorse.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

-- | 202609292050

-- categorie_risorse_path_check
-- verifica: 2021-06-02 20:22 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `categorie_risorse_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				categorie_risorse.id_genitore
			FROM categorie_risorse
			WHERE categorie_risorse.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

-- | 202609292051

-- categorie_risorse_path_find_ancestor
-- verifica: 2021-06-02 19:56 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `categorie_risorse_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				categorie_risorse.id_genitore,
				categorie_risorse.id
			FROM categorie_risorse
			WHERE categorie_risorse.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

-- | 202609292052

-- colori_path
-- verifica: 2021-06-03 15:19 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `colori_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				colori.id_genitore,
				colori.nome
			FROM colori
			WHERE colori.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

-- | 202609292053

-- colori_path_check
-- verifica: 2021-06-03 15:25 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `colori_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				colori.id_genitore
			FROM colori
			WHERE colori.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

-- | 202609292054

-- colori_path_find_ancestor
-- verifica: 2021-06-02 19:56 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `colori_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				colori.id_genitore,
				colori.id
			FROM colori
			WHERE colori.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

-- | 202609292055

-- ruoli_articoli_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `ruoli_articoli_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_articoli.id_genitore,
				ruoli_articoli.nome
			FROM ruoli_articoli
			WHERE ruoli_articoli.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

-- | 202609292056

-- ruoli_articoli_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `ruoli_articoli_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				ruoli_articoli.id_genitore
			FROM ruoli_articoli
			WHERE ruoli_articoli.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

-- | 202609292057

-- ruoli_articoli_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `ruoli_articoli_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_articoli.id_genitore,
				ruoli_articoli.id
			FROM ruoli_articoli
			WHERE ruoli_articoli.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

-- | 202609292058

-- ruoli_categorie_progetti_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `ruoli_categorie_progetti_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_categorie_progetti.id_genitore,
				ruoli_categorie_progetti.nome
			FROM ruoli_categorie_progetti
			WHERE ruoli_categorie_progetti.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

-- | 202609292059

-- ruoli_categorie_progetti_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `ruoli_categorie_progetti_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				ruoli_categorie_progetti.id_genitore
			FROM ruoli_categorie_progetti
			WHERE ruoli_categorie_progetti.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

-- | 202609292100

-- ruoli_categorie_progetti_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `ruoli_categorie_progetti_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_categorie_progetti.id_genitore,
				ruoli_categorie_progetti.id
			FROM ruoli_categorie_progetti
			WHERE ruoli_categorie_progetti.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

-- | 202609292101

-- ruoli_matricole_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `ruoli_matricole_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_matricole.id_genitore,
				ruoli_matricole.nome
			FROM ruoli_matricole
			WHERE ruoli_matricole.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

-- | 202609292102

-- ruoli_matricole_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `ruoli_matricole_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				ruoli_matricole.id_genitore
			FROM ruoli_matricole
			WHERE ruoli_matricole.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

-- | 202609292103

-- ruoli_matricole_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `ruoli_matricole_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_matricole.id_genitore,
				ruoli_matricole.id
			FROM ruoli_matricole
			WHERE ruoli_matricole.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

-- | 202609292104

-- software_path
-- verifica: 2021-11-16 10:39 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `software_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				software.id_genitore,
				software.nome
			FROM software
			WHERE software.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

-- | 202609292105

-- software_path_check
-- verifica: 2021-11-16 10:39 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `software_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				software.id_genitore
			FROM software
			WHERE software.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

-- | 202609292106

-- software_path_find_ancestor
-- verifica: 2021-11-16 10:39 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `software_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				software.id_genitore,
				software.id
			FROM software
			WHERE software.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

-- | 202609292107

-- tipologie_banner_path
-- verifica: 2021-11-15 11:29 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_banner_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_banner.id_genitore,
				tipologie_banner.nome
			FROM tipologie_banner
			WHERE tipologie_banner.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

-- | 202609292108

-- tipologie_banner_path_check
-- verifica: 2021-11-15 11:29 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_banner_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_banner.id_genitore
			FROM tipologie_banner
			WHERE tipologie_banner.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

-- | 202609292109

-- tipologie_banner_path_find_ancestor
-- verifica: 2021-11-15 11:29 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_banner_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_banner.id_genitore,
				tipologie_banner.id
			FROM tipologie_banner
			WHERE tipologie_banner.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

-- | 202609292110

-- tipologie_chiavi_path
-- verifica: 2021-11-15 11:29 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_chiavi_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_chiavi.id_genitore,
				tipologie_chiavi.nome
			FROM tipologie_chiavi
			WHERE tipologie_chiavi.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

-- | 202609292111

-- tipologie_chiavi_path_check
-- verifica: 2021-11-15 11:29 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_chiavi_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_chiavi.id_genitore
			FROM tipologie_chiavi
			WHERE tipologie_chiavi.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

-- | 202609292112

-- tipologie_edifici_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_edifici_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_edifici.id_genitore,
				tipologie_edifici.nome
			FROM tipologie_edifici
			WHERE tipologie_edifici.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

-- | 202609292113

-- tipologie_edifici_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_edifici_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_edifici.id_genitore
			FROM tipologie_edifici
			WHERE tipologie_edifici.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

-- | 202609292114

-- tipologie_edifici_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_edifici_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_edifici.id_genitore,
				tipologie_edifici.id
			FROM tipologie_edifici
			WHERE tipologie_edifici.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

-- | 202609292115

-- tipologie_immobili_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_immobili_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_immobili.id_genitore,
				tipologie_immobili.nome
			FROM tipologie_immobili
			WHERE tipologie_immobili.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

-- | 202609292116

-- tipologie_immobili_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_immobili_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_immobili.id_genitore
			FROM tipologie_immobili
			WHERE tipologie_immobili.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

-- | 202609292117

-- tipologie_immobili_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_immobili_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_immobili.id_genitore,
				tipologie_immobili.id
			FROM tipologie_immobili
			WHERE tipologie_immobili.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

-- | 202609292118

-- tipologie_licenze_path
-- verifica: 2021-11-15 11:29 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_licenze_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_licenze.id_genitore,
				tipologie_licenze.nome
			FROM tipologie_licenze
			WHERE tipologie_licenze.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

-- | 202609292119

-- tipologie_licenze_path_check
-- verifica: 2021-11-15 11:29 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_licenze_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_licenze.id_genitore
			FROM tipologie_licenze
			WHERE tipologie_licenze.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

-- | 202609292120

-- tipologie_licenze_path_find_ancestor
-- verifica: 2021-11-15 11:29 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_licenze_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_licenze.id_genitore,
				tipologie_licenze.id
			FROM tipologie_licenze
			WHERE tipologie_licenze.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

-- | 202609292121

-- tipologie_luoghi_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_luoghi_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_luoghi.id_genitore,
				tipologie_luoghi.nome
			FROM tipologie_luoghi
			WHERE tipologie_luoghi.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

-- | 202609292122

-- tipologie_luoghi_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_luoghi_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_luoghi.id_genitore
			FROM tipologie_luoghi
			WHERE tipologie_luoghi.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

-- | 202609292123

-- tipologie_luoghi_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_luoghi_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_luoghi.id_genitore,
				tipologie_luoghi.id
			FROM tipologie_luoghi
			WHERE tipologie_luoghi.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

-- | 202609292124

-- tipologie_mastri_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_mastri_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_mastri.id_genitore,
				tipologie_mastri.nome
			FROM tipologie_mastri
			WHERE tipologie_mastri.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

-- | 202609292125

-- tipologie_mastri_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_mastri_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_mastri.id_genitore
			FROM tipologie_mastri
			WHERE tipologie_mastri.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

-- | 202609292126

-- tipologie_mastri_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_mastri_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_mastri.id_genitore,
				tipologie_mastri.id
			FROM tipologie_mastri
			WHERE tipologie_mastri.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

-- | 202609292127

-- tipologie_periodi_path
-- verifica: 2021-11-15 11:29 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_periodi_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_periodi.id_genitore,
				tipologie_periodi.nome
			FROM tipologie_periodi
			WHERE tipologie_periodi.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

-- | 202609292128

-- tipologie_periodi_path_check
-- verifica: 2021-11-15 11:29 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_periodi_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_periodi.id_genitore
			FROM tipologie_periodi
			WHERE tipologie_periodi.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

-- | 202609292129

-- tipologie_periodi_path_find_ancestor
-- verifica: 2021-11-15 11:29 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_periodi_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_periodi.id_genitore,
				tipologie_periodi.id
			FROM tipologie_periodi
			WHERE tipologie_periodi.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

-- | 202609292130

-- tipologie_popup_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_popup_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_popup.id_genitore,
				tipologie_popup.nome
			FROM tipologie_popup
			WHERE tipologie_popup.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

-- | 202609292131

-- tipologie_popup_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_popup_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_popup.id_genitore
			FROM tipologie_popup
			WHERE tipologie_popup.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

-- | 202609292132

-- tipologie_popup_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_popup_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_popup.id_genitore,
				tipologie_popup.id
			FROM tipologie_popup
			WHERE tipologie_popup.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

-- | 202609292133

-- tipologie_risorse_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_risorse_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_risorse.id_genitore,
				tipologie_risorse.nome
			FROM tipologie_risorse
			WHERE tipologie_risorse.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

-- | 202609292134

-- tipologie_risorse_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_risorse_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_risorse.id_genitore
			FROM tipologie_risorse
			WHERE tipologie_risorse.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

-- | 202609292135

-- tipologie_risorse_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_risorse_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_risorse.id_genitore,
				tipologie_risorse.id
			FROM tipologie_risorse
			WHERE tipologie_risorse.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

-- | 202609292136

-- tipologie_spedizioni_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_spedizioni_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_spedizioni.id_genitore,
				tipologie_spedizioni.nome
			FROM tipologie_spedizioni
			WHERE tipologie_spedizioni.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

-- | 202609292137

-- tipologie_spedizioni_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_spedizioni_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_spedizioni.id_genitore
			FROM tipologie_spedizioni
			WHERE tipologie_spedizioni.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

-- | 202609292138

-- tipologie_spedizioni_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_spedizioni_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_spedizioni.id_genitore,
				tipologie_spedizioni.id
			FROM tipologie_spedizioni
			WHERE tipologie_spedizioni.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

-- | 202609292139

-- anagrafica_certificazioni_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS `anagrafica_certificazioni_view` AS
	SELECT
		anagrafica_certificazioni.id,
		anagrafica_certificazioni.id_anagrafica,
		coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ) AS anagrafica,
		anagrafica_certificazioni.id_certificazione,
		certificazioni.nome AS certificazione,
		anagrafica_certificazioni.id_emittente,
		coalesce( emittente.denominazione , concat( emittente.cognome, ' ', emittente.nome ), '' ) AS emittente,
		anagrafica_certificazioni.nome,
		anagrafica_certificazioni.codice,
		anagrafica_certificazioni.data_emissione,
		anagrafica_certificazioni.data_scadenza,
		from_unixtime( anagrafica_certificazioni.timestamp_inserimento, '%Y-%m-%d %H:%i' ) AS data_ora_inserimento,
		concat(
			coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ),
			' / ',
			certificazioni.nome,
			' - ',
			anagrafica_certificazioni.codice
		) AS __label__
	FROM anagrafica_certificazioni
		INNER JOIN anagrafica ON anagrafica.id = anagrafica_certificazioni.id_anagrafica
		LEFT JOIN anagrafica AS emittente ON emittente.id = anagrafica_certificazioni.id_emittente
		LEFT JOIN certificazioni ON certificazioni.id = anagrafica_certificazioni.id_certificazione		
;

-- | 202609292140

-- anagrafica_cittadinanze_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS `anagrafica_cittadinanze_view` AS
	SELECT
		anagrafica_cittadinanze.id,
		anagrafica_cittadinanze.id_anagrafica,
		anagrafica_cittadinanze.id_stato,
		anagrafica_cittadinanze.data_inizio,
		anagrafica_cittadinanze.data_fine,
		anagrafica_cittadinanze.id_account_inserimento,
		anagrafica_cittadinanze.id_account_aggiornamento,
		concat(
			coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ),
			' / ',
			stati.nome
		) AS __label__
	FROM anagrafica_cittadinanze
		INNER JOIN anagrafica ON anagrafica.id = anagrafica_cittadinanze.id_anagrafica
		INNER JOIN stati ON stati.id = anagrafica_cittadinanze.id_stato
;

-- | 202609292141

-- anagrafica_consensi_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS `anagrafica_consensi_view` AS
	SELECT
		anagrafica_consensi.id,
		anagrafica_consensi.id_account,
		anagrafica_consensi.id_anagrafica,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		anagrafica_consensi.id_consenso,
		anagrafica_consensi.se_prestato,
		anagrafica_consensi.timestamp_consenso,
		anagrafica_consensi.id_account_inserimento,
		anagrafica_consensi.id_account_aggiornamento,
		concat( 'consenso per ', anagrafica_consensi.id_consenso, ' di ', coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) ) AS __label__
	FROM anagrafica_consensi
		LEFT JOIN anagrafica AS a1 ON a1.id = anagrafica_consensi.id_anagrafica
;

-- | 202609292142

-- anagrafica_progetti_view
CREATE VIEW IF NOT EXISTS anagrafica_progetti_view AS
	SELECT
		anagrafica_progetti.id,
		anagrafica_progetti.id_anagrafica,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		anagrafica_progetti.id_progetto,
		progetti.nome AS progetto,
		anagrafica_progetti.id_ruolo,
		ruoli_progetti.nome as ruolo,
		anagrafica_progetti.ordine,
		anagrafica_progetti.se_attesa,
		anagrafica_progetti.id_account_inserimento,
		anagrafica_progetti.id_account_aggiornamento,
 		concat_ws(
			' ',
			progetti.nome,
			coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ),
			ruoli_progetti.nome
		) AS __label__
	FROM anagrafica_progetti
		LEFT JOIN anagrafica AS a1 ON a1.id = anagrafica_progetti.id_anagrafica
		LEFT JOIN progetti ON progetti.id = anagrafica_progetti.id_progetto
		LEFT JOIN ruoli_progetti ON ruoli_progetti.id = anagrafica_progetti.id_ruolo
;

-- | 202609292143

-- anagrafica_settori_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS `anagrafica_settori_view` AS
	SELECT
		anagrafica_settori.id,
		anagrafica_settori.id_anagrafica,
		anagrafica_settori.id_settore,
		settori.nome AS settore,
		anagrafica_settori.ordine,
		anagrafica_settori.id_account_inserimento,
		anagrafica_settori.id_account_aggiornamento,
		concat(
			coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ),
			' / ',
			settori.nome
		) AS __label__
	FROM anagrafica_settori
		LEFT JOIN anagrafica ON anagrafica.id = anagrafica_settori.id_anagrafica
		LEFT JOIN settori ON settori.id = anagrafica_settori.id_settore
;

-- | 202609292144

-- annunci_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS `annunci_view` AS
	SELECT
		annunci.id,
		annunci.id_tipologia,
		annunci.nome,
		group_concat( categorie_annunci.nome SEPARATOR '|' ) AS categorie,
		annunci.id_account_inserimento,
		annunci.id_account_aggiornamento,
		annunci.nome AS __label__
	FROM annunci
		LEFT JOIN annunci_categorie ON annunci_categorie.id_annuncio = annunci.id
		LEFT JOIN categorie_annunci ON categorie_annunci.id = annunci_categorie.id_categoria
	GROUP BY annunci.id
;

-- | 202609292145

-- annunci_categorie_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS `annunci_categorie_view` AS
	SELECT
		annunci_categorie.id,
		annunci_categorie.id_annuncio,
		annunci.nome AS annuncio,
		annunci_categorie.id_categoria,
		categorie_annunci_path( annunci_categorie.id_categoria ) AS categoria,
		annunci_categorie.ordine,
		annunci_categorie.id_account_inserimento,
		annunci_categorie.id_account_aggiornamento,
		concat(
			annunci.nome,
			' / ',
			categorie_annunci_path( annunci_categorie.id_categoria )
		) AS __label__
	FROM annunci_categorie
		LEFT JOIN annunci ON annunci.id = annunci_categorie.id_annuncio
;

-- | 202609292146

-- badge_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS badge_view AS
	SELECT
		badge.id,
		badge.nome,
		badge.codice,
		badge.rfid,
		concat_ws(
			' ',
			anagrafica.codice,
			coalesce(
				anagrafica.soprannome,
				anagrafica.denominazione,
				concat_ws(' ', coalesce( anagrafica.cognome, ''),
				coalesce( anagrafica.nome, '') ),
				''
			)
		) AS anagrafica,
		concat_ws( 
			' | ', 
			lpad( badge.id, 8, 0),
			coalesce( badge.codice, badge.rfid, badge.nome ),
			concat_ws(
				' ',
				anagrafica.codice,
				coalesce(
					anagrafica.soprannome,
					anagrafica.denominazione,
					concat_ws(' ', coalesce( anagrafica.cognome, ''),
					coalesce( anagrafica.nome, '') ),
					'NON ASSEGNATO'
				)
			)
		) AS __label__
	FROM badge
	LEFT JOIN anagrafica ON anagrafica.id_badge = badge.id
;

-- | 202609292147

-- banner_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS `banner_view` AS
	SELECT
		banner.id,
		banner.id_tipologia,
		tipologie_banner_path( banner.id_tipologia ) AS tipologia,
		banner.id_sito,
		banner.ordine,
		banner.nome,
		banner.id_inserzionista,
		coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ) AS inserzionista,
		banner.altezza_modulo,
		banner.larghezza_modulo,
		banner.token,
		banner.id_account_inserimento,
		banner.id_account_aggiornamento,
		concat( banner.nome, ' ', banner.altezza_modulo, 'x', banner.larghezza_modulo ) AS __label__
	FROM banner
		LEFT JOIN anagrafica ON anagrafica.id = banner.id_inserzionista
	;

-- | 202609292148

-- banner_azioni
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS `banner_azioni_view` AS
	SELECT
		banner_azioni.id,
		banner_azioni.id_banner,
		banner_azioni.id_pagina,
		banner_azioni.azione,
		banner_azioni.timestamp_azione,
		banner_azioni.token,
		banner_azioni.id_account_inserimento,
		banner_azioni.id_account_aggiornamento,
		concat(
			banner_azioni.azione,
			' di ',
			banner.nome
		) AS __label__
	FROM banner_azioni
		LEFT JOIN banner ON banner.id = banner_azioni.id_banner
;

-- | 202609292149

-- banner_pagine_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS `banner_pagine_view` AS
	SELECT
		banner_pagine.id,
		banner_pagine.id_banner,
		banner_pagine.id_pagina,
		banner_pagine.se_presente,
		banner_pagine.id_account_inserimento,
		banner_pagine.id_account_aggiornamento,
		concat(
			banner.nome,
			' / ',
			pagine_path( banner_pagine.id_pagina ),
			' / ',
			coalesce( banner_pagine.se_presente, 0 )
		) AS __label__
	FROM banner_pagine
		LEFT JOIN banner ON banner.id = banner_pagine.id_banner
;

-- | 202609292150

-- banner_zone_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS `banner_zone_view` AS
	SELECT
		banner_zone.id,
		banner_zone.id_banner,
		banner_zone.id_zona,
		banner_zone.se_presente,
		banner_zone.id_account_inserimento,
		banner_zone.id_account_aggiornamento,
		concat(
			banner.nome,
			' / ',
			zone_path( banner_zone.id_zona ),
			' / ',
			coalesce( banner_zone.se_presente, 0 )
		) AS __label__
	FROM banner_zone
		LEFT JOIN banner ON banner.id = banner_zone.id_banner
;

-- | 202609292151

-- campagne_view
CREATE VIEW IF NOT EXISTS `campagne_view` AS
	SELECT
		campagne.id,
		campagne.nome,
		campagne.id_account_inserimento,
		campagne.id_account_aggiornamento,
		campagne.nome AS __label__
	FROM campagne
;

-- | 202609292152

-- carrelli_consensi_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS `carrelli_consensi_view` AS
	SELECT
		carrelli_consensi.id,
		carrelli_consensi.id_account,
		carrelli_consensi.id_anagrafica,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		carrelli_consensi.id_carrello,
		carrelli_consensi.id_consenso,
		carrelli_consensi.se_prestato,
		carrelli_consensi.timestamp_consenso,
		carrelli_consensi.id_account_inserimento,
		carrelli_consensi.id_account_aggiornamento,
		concat( 'consenso per ', carrelli_consensi.id_consenso, ' callerro #', carrelli_consensi.id_carrello) AS __label__
	FROM carrelli_consensi
		LEFT JOIN anagrafica AS a1 ON a1.id = carrelli_consensi.id_anagrafica;

-- | 202609292153

-- carrelli_documenti_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS carrelli_documenti_view AS
	SELECT
		carrelli_documenti.id,
		carrelli_documenti.id_carrello,
		carrelli_documenti.id_documento,
		carrelli_documenti.id_account_inserimento,
		carrelli_documenti.id_account_aggiornamento
	FROM carrelli_documenti;

-- | 202609292154

-- categorie_annunci
CREATE VIEW IF NOT EXISTS categorie_annunci_view AS
	SELECT
		categorie_annunci.id,
		categorie_annunci.id_genitore,
		categorie_annunci.ordine,
		categorie_annunci.nome,
		categorie_annunci.template,
		categorie_annunci.schema_html,
		categorie_annunci.tema_css,
		categorie_annunci.se_sitemap,
		categorie_annunci.se_cacheable,
		categorie_annunci.id_sito,
		categorie_annunci.id_pagina,
		count( c1.id ) AS figli,
		count( annunci_categorie.id ) AS membri,
		categorie_annunci.id_account_inserimento,
		categorie_annunci.id_account_aggiornamento,
		categorie_annunci_path( categorie_annunci.id ) AS __label__
	FROM categorie_annunci
		LEFT JOIN categorie_annunci AS c1 ON c1.id_genitore = categorie_annunci.id
		LEFT JOIN annunci_categorie ON annunci_categorie.id_categoria = categorie_annunci.id
	GROUP BY categorie_annunci.id
;

-- | 202609292155

-- categorie_risorse_view
-- tipologia: tabella assistita
CREATE VIEW IF NOT EXISTS categorie_risorse_view AS
	SELECT
		categorie_risorse.id,
		categorie_risorse.id_genitore,
		categorie_risorse.ordine,
		categorie_risorse.nome,
		categorie_risorse.template,
		categorie_risorse.schema_html,
		categorie_risorse.tema_css,
		categorie_risorse.se_sitemap,
		categorie_risorse.se_cacheable,
		categorie_risorse.id_sito,
		categorie_risorse.id_pagina,
		count( c1.id ) AS figli,
		count( risorse_categorie.id ) AS membri,
		categorie_risorse.id_account_inserimento,
		categorie_risorse.id_account_aggiornamento,
		categorie_risorse_path( categorie_risorse.id ) AS __label__
	FROM categorie_risorse
		LEFT JOIN categorie_risorse AS c1 ON c1.id_genitore = categorie_risorse.id
		LEFT JOIN risorse_categorie ON risorse_categorie.id_categoria = categorie_risorse.id
	GROUP BY categorie_risorse.id
;

-- | 202609292156

-- causali_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS causali_view AS
	SELECT
		causali.id,
		causali.nome,
		causali.se_trasporto,
		causali.id_account_inserimento,
		causali.id_account_aggiornamento,
	 	causali.nome AS __label__
	FROM causali
;

-- | 202609292157

-- certificazioni_view
-- tipologia: tabella assistita
-- verifica: 2022-02-03 11:12 Chiara GDL
CREATE VIEW IF NOT EXISTS certificazioni_view AS
	SELECT
		certificazioni.id,
		certificazioni.nome,
		certificazioni.se_identificazione,
		certificazioni.se_medico,
		certificazioni.se_sportivo,
		certificazioni.se_agonistico,
		certificazioni.se_immobili,
	 	certificazioni.nome AS __label__
	FROM certificazioni
;

-- | 202609292158

-- chiavi_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS chiavi_view AS
	SELECT
		chiavi.id,
		chiavi.id_licenza,
		licenze.nome AS licenza,
        chiavi.id_tipologia,
        tipologie_chiavi.nome AS tipologia,
		chiavi.codice,
		chiavi.seriale,
		chiavi.nome,
		chiavi.id_account_inserimento,
		chiavi.id_account_aggiornamento,
		chiavi.nome AS __label__
	FROM chiavi
		LEFT JOIN licenze ON licenze.id = chiavi.id_licenza
        LEFT JOIN tipologie_chiavi ON tipologie_chiavi.id = chiavi.id_tipologia
;

-- | 202609292159

-- classi_energetiche_view
-- tipologia: tabella standard
CREATE VIEW IF NOT EXISTS classi_energetiche_view AS
	SELECT
		classi_energetiche.id,
		classi_energetiche.nome,
		classi_energetiche.ep_min,
		classi_energetiche.ep_max,
		classi_energetiche.rgb,
		classi_energetiche.nome AS __label__
	FROM classi_energetiche
;

-- | 202609292200

-- colori_view
-- tipologia: tabella di supporto
CREATE VIEW IF NOT EXISTS colori_view AS
	SELECT
		colori.id,
		colori.id_genitore,
		colori.nome,
		colori.hex,
		colori.r,
		colori.g,
		colori.b,
		colori.ral,
		colori.pantone,
		colori.c,
		colori.m,
		colori.y,
		colori.k,
		colori_path( colori.id ) AS __label__
	FROM colori
;

-- | 202609292201

-- condizioni_view
-- tipologia: tabella standard
CREATE VIEW IF NOT EXISTS condizioni_view AS
	SELECT
		condizioni.id,
		condizioni.nome,
		condizioni.se_immobili,
		condizioni.se_catalogo,
		condizioni.nome AS __label__
	FROM
		condizioni
;

-- | 202609292202

-- contratti_progetti_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS contratti_progetti_view AS 
	SELECT 
		contratti_progetti.id,
		contratti_progetti.id_contratto,
		contratti.codice,
		contratti_progetti.id_progetto,
		coalesce( progetti.nome, '' ) AS progetto,
		contratti_progetti.id_ruolo,
		ruoli_progetti.nome AS ruolo,
		contratti_progetti.ordine,
		contratti_progetti.id_account_inserimento,
		contratti_progetti.id_account_aggiornamento,
		contratti_progetti.id_account_archiviazione,
		tipologie_contratti.se_abbonamento,
		tipologie_contratti.se_iscrizione,
		tipologie_contratti.se_tesseramento,
		tipologie_contratti.se_immobili,
		tipologie_contratti.se_acquisto,
		tipologie_contratti.se_locazione,
		tipologie_contratti.se_libero,
		tipologie_contratti.se_prenotazione,
		tipologie_contratti.se_scalare,
		tipologie_contratti.se_affiliazione,
		tipologie_contratti.nome AS tipologia,
		min( rinnovi.data_inizio ) AS data_inizio,
		max( rinnovi.data_fine ) AS data_fine,
		concat( 'contratto ', contratti.nome, ' - ', coalesce( progetti.nome, '' ), ' ruolo ', ruoli_progetti.nome  ) AS __label__
	FROM contratti_progetti
		LEFT JOIN contratti ON contratti.id = contratti_progetti.id_contratto
		LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
		LEFT JOIN ruoli_progetti ON ruoli_progetti.id = contratti_progetti.id_ruolo
		LEFT JOIN progetti ON progetti.id = contratti_progetti.id_progetto
		LEFT JOIN rinnovi ON rinnovi.id_contratto = contratti.id
	GROUP BY contratti.id, progetti.id
;

-- | 202609292203

-- conversazioni_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS conversazioni_view AS
	SELECT
		conversazioni.id,
		conversazioni.id_annuncio,
		conversazioni.codice,
		conversazioni.nome,
		conversazioni.id_articolo,
		conversazioni.quantita,
		conversazioni.note,
		conversazioni.timestamp_apertura,
		conversazioni.timestamp_chiusura,
		conversazioni.id_account_inserimento,
		conversazioni.timestamp_inserimento,
		conversazioni.id_account_aggiornamento,
		conversazioni.timestamp_aggiornamento,
		conversazioni.nome AS __label__
	FROM
		conversazioni
;

-- | 202609292204

-- conversazioni_account_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS conversazioni_account_view AS
	SELECT
		conversazioni_account.id,
		conversazioni_account.id_conversazione,
		conversazioni_account.id_account,
		conversazioni_account.id_ruolo,
		conversazioni_account.timestamp_lettura,
		conversazioni_account.timestamp_entrata,
		conversazioni_account.timestamp_uscita,
		conversazioni_account.id_account_inserimento,
		conversazioni_account.timestamp_inserimento,
		conversazioni_account.id_account_aggiornamento,
		conversazioni_account.timestamp_aggiornamento,
		concat( conversazioni_account.id_conversazione, ' - ', conversazioni_account.id_account) AS __label__
	FROM
		conversazioni_account
;

-- | 202609292205

-- coupon_articoli_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS `coupon_articoli_view` AS
	SELECT
		coupon_articoli.id,
		coupon_articoli.id_coupon,
		coupon_articoli.id_articolo,
		concat_ws( ' ', prodotti.nome, articoli.nome ) AS articolo,
		coupon_articoli.ordine,
		coupon_articoli.id_account_inserimento,
		coupon_articoli.id_account_aggiornamento,
		CONCAT(
			coupon.nome,
			' / ',
			concat_ws( ' ', prodotti.nome, articoli.nome )
		) AS __label__
	FROM coupon_articoli
		LEFT JOIN coupon ON coupon.id = coupon_articoli.id_coupon
		LEFT JOIN articoli ON articoli.id = coupon_articoli.id_articolo
		LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
;

-- | 202609292206

-- coupon_categorie_prodotti_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS `coupon_categorie_prodotti_view` AS
	SELECT
		coupon_categorie_prodotti.id,
		coupon_categorie_prodotti.id_coupon,
		coupon_categorie_prodotti.id_categoria,
		categorie_prodotti.nome AS categoria,
		coupon_categorie_prodotti.ordine,
		coupon_categorie_prodotti.id_account_inserimento,
		coupon_categorie_prodotti.id_account_aggiornamento,
		CONCAT(
			coupon.nome,
			' / ',
			categorie_prodotti.nome
		) AS __label__
	FROM coupon_categorie_prodotti
		LEFT JOIN coupon ON coupon_categorie_prodotti.id_coupon = coupon.id
		LEFT JOIN categorie_prodotti ON categorie_prodotti.id = coupon_categorie_prodotti.id_categoria
;

-- | 202609292207

-- coupon_listini_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS `coupon_listini_view` AS
	SELECT
		coupon_listini.id,
		coupon_listini.id_coupon,
		coupon_listini.id_listino,
		listini.nome AS listino,
		coupon_listini.ordine,
		coupon_listini.id_account_inserimento,
		coupon_listini.id_account_aggiornamento,
		CONCAT(
			coupon.nome,
			' / ',
			listini.nome
		) AS __label__
	FROM coupon_listini
		LEFT JOIN coupon ON coupon.id = coupon_listini.id_coupon
		LEFT JOIN listini ON listini.id = coupon_listini.id_listino
;

-- | 202609292208

-- coupon_marchi_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS `coupon_marchi_view` AS
	SELECT
		coupon_marchi.id,
		coupon_marchi.id_coupon,
		coupon_marchi.id_marchio,
		marchi.nome AS marchio,
		coupon_marchi.ordine,
		coupon_marchi.id_account_inserimento,
		coupon_marchi.id_account_aggiornamento,
		CONCAT(
			coupon.nome,
			' / ',
			marchi.nome
		) AS __label__
	FROM coupon_marchi
		LEFT JOIN coupon ON coupon.id = coupon_marchi.id_coupon
		LEFT JOIN marchi ON marchi.id = coupon_marchi.id_marchio
;

-- | 202609292209

-- coupon_prodotti_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS `coupon_prodotti_view` AS
	SELECT
		coupon_prodotti.id,
		coupon_prodotti.id_coupon,
		coupon_prodotti.id_prodotto,
		prodotti.nome AS prodotto,
		coupon_prodotti.ordine,
		coupon_prodotti.id_account_inserimento,
		coupon_prodotti.id_account_aggiornamento,
		CONCAT(
			coupon.nome,
			' / ',
			prodotti.nome
		) AS __label__
	FROM coupon_prodotti
		LEFT JOIN coupon ON coupon.id = coupon_prodotti.id_coupon
		LEFT JOIN prodotti ON prodotti.id = coupon_prodotti.id_prodotto
;

-- | 202609292210

-- crediti_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS `crediti_view` AS
    SELECT
		crediti.id,
		crediti.id_documenti_articolo,
        concat(
			tipologie_documenti.sigla,
			' ',
			documenti.numero,
			'/',
			year( documenti.data ),
			' del ',
			documenti.data,
			' ',
			documenti_articoli.id_articolo
		) AS riga_documento,
		crediti.data,
		crediti.id_account_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS account_emittente,
		crediti.id_account_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS account_destinatario,
		crediti.id_mastro_provenienza,
		mastri_path( m1.id ) AS mastro_provenienza,
		crediti.id_mastro_destinazione,
		mastri_path( m2.id ) AS mastro_destinazione,
		crediti.quantita,
		crediti.id_pianificazione,
		crediti.nome,
		crediti.id_account_inserimento,
		crediti.id_account_aggiornamento,
		concat(
			crediti.data,
			' / ',
			tipologie_documenti.sigla,
			' / ',
			crediti.quantita,
			' x ',
			documenti_articoli.id_articolo,
			' / ',
			crediti.nome
		) AS __label__
	FROM
		crediti
		LEFT JOIN documenti_articoli ON documenti_articoli.id = crediti.id_documenti_articolo
        LEFT JOIN mastri AS m1 ON m1.id = crediti.id_mastro_provenienza
		LEFT JOIN mastri AS m2 ON m2.id = crediti.id_mastro_destinazione
		LEFT JOIN documenti ON documenti.id = documenti_articoli.id_documento
        LEFT JOIN account AS acc1 ON acc1.id = m1.id_account
		LEFT JOIN anagrafica AS a1 ON a1.id = acc1.id_anagrafica
		LEFT JOIN account AS acc2 ON acc2.id = m2.id_account
		LEFT JOIN anagrafica AS a2 ON a2.id = acc2.id_anagrafica
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
;

-- | 202609292211

-- disponibilita_view
-- tipologia: tabella standard
CREATE VIEW IF NOT EXISTS disponibilita_view AS
	SELECT
		disponibilita.id,
		disponibilita.nome,
		disponibilita.se_immobili,
		disponibilita.se_catalogo,
		disponibilita.nome AS __label__
	FROM
		disponibilita
;

-- | 202609292212

-- edifici
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS edifici_view AS
	SELECT
		edifici.id,
		edifici.id_tipologia,
		tipologie_edifici.nome AS tipologia,
		edifici.id_indirizzo,
		concat_ws(
			' ',
			tipologie_indirizzi.nome,
			indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) AS indirizzo,
		edifici.codice,
		edifici.nome,
		edifici.piani,
		edifici.id_account_inserimento,
		edifici.id_account_aggiornamento,
		concat_ws(
			' ',
			tipologie_edifici.nome,
			edifici.nome,
			tipologie_indirizzi.nome,
			indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) AS __label__
	FROM edifici
		LEFT JOIN tipologie_edifici ON tipologie_edifici.id = edifici.id_tipologia
		LEFT JOIN indirizzi ON indirizzi.id = edifici.id_indirizzo
		LEFT JOIN tipologie_indirizzi ON tipologie_indirizzi.id = indirizzi.id_tipologia
		LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
		LEFT JOIN regioni ON regioni.id = provincie.id_regione
		LEFT JOIN stati ON stati.id = regioni.id_stato
;

-- | 202609292213

-- edifici_caratteristiche_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS `edifici_caratteristiche_view` AS
	SELECT
		edifici_caratteristiche.id,
		edifici_caratteristiche.id_edificio,
		edifici_caratteristiche.id_caratteristica,
		caratteristiche.nome AS caratteristica,
		edifici_caratteristiche.ordine,
		edifici_caratteristiche.se_presente,
		edifici_caratteristiche.id_account_inserimento,
		edifici_caratteristiche.id_account_aggiornamento,
		concat(
			edifici_caratteristiche.id_edificio,
			' / ',
			caratteristiche.nome
		) AS __label__
	FROM edifici_caratteristiche
		LEFT JOIN caratteristiche ON caratteristiche.id = edifici_caratteristiche.id_caratteristica
;

-- | 202609292214

-- giorni
CREATE VIEW IF NOT EXISTS `giorni_view` AS
	SELECT
		giorni.id,
		giorni.nome,
		giorni.nome AS __label__
	FROM giorni
;

-- | 202609292215

-- immobili_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS immobili_view AS
	SELECT
		immobili.id,
		immobili.id_tipologia,
		tipologie_immobili.nome AS tipologia,
		immobili.id_edificio,
		immobili.nome,
		immobili.codice,
		edifici.id_indirizzo,
		concat_ws(
			' ',
			tipologie_indirizzi.nome,
			indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) AS indirizzo,
		immobili.scala,
		immobili.piano,
		immobili.interno,
		immobili.campanello,
		immobili.catasto_foglio,
		immobili.catasto_particella,
		immobili.catasto_sub,
		immobili.catasto_categoria,
		immobili.catasto_classe,
		immobili.catasto_consistenza,
		immobili.catasto_superficie,
		immobili.catasto_rendita,
		immobili.id_account_inserimento,
		immobili.id_account_aggiornamento,
		MAX(rinnovi.data_inizio) AS data_inizio,
        MAX(rinnovi.data_fine) AS data_fine,
		group_concat( DISTINCT coalesce( proponente.denominazione , concat( proponente.cognome, ' ', proponente.nome ), '' )  SEPARATOR ', ' ) AS proponenti,
		group_concat( DISTINCT coalesce( contraente.denominazione , concat( contraente.cognome, ' ', contraente.nome ), '' )  SEPARATOR ', ' ) AS contraenti,
		group_concat( DISTINCT zone_path( zone.id ) SEPARATOR ' | ' ) AS zone,
		concat_ws(
			' ',
			tipologie_immobili.nome, 
			coalesce(
			concat('scala ', immobili.scala), 
			''
			), 
			coalesce(
			concat('piano ', immobili.piano), 
			''
			), 
			coalesce(
			concat('int. ', immobili.interno), 
			''
			),
			tipologie_edifici.nome,
			edifici.nome,
			tipologie_indirizzi.nome,
			indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) AS __label__
	FROM immobili
		LEFT JOIN tipologie_immobili ON tipologie_immobili.id = immobili.id_tipologia
		LEFT JOIN edifici ON edifici.id = immobili.id_edificio
		LEFT JOIN tipologie_edifici ON tipologie_edifici.id = edifici.id_tipologia
		LEFT JOIN indirizzi ON indirizzi.id = edifici.id_indirizzo
		LEFT JOIN tipologie_indirizzi ON tipologie_indirizzi.id = indirizzi.id_tipologia
		LEFT JOIN zone_indirizzi ON zone_indirizzi.id_indirizzo = indirizzi.id 
		LEFT JOIN zone ON zone.id = zone_indirizzi.id_zona
		LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
		LEFT JOIN regioni ON regioni.id = provincie.id_regione
		LEFT JOIN stati ON stati.id = regioni.id_stato	
		LEFT JOIN contratti ON contratti.id_immobile = immobili.id
		LEFT JOIN contratti_anagrafica ON contratti_anagrafica.id_contratto = contratti.id AND contratti_anagrafica.id_ruolo = 27
		LEFT JOIN anagrafica AS proponente ON proponente.id = contratti_anagrafica.id_anagrafica 
		LEFT JOIN contratti_anagrafica AS c_a ON c_a.id_contratto = contratti.id AND c_a.id_ruolo = 28
		LEFT JOIN anagrafica AS contraente ON contraente.id = c_a.id_anagrafica
        LEFT JOIN rinnovi ON rinnovi.id_contratto = contratti.id  AND ( rinnovi.data_inizio IS NULL OR rinnovi.data_inizio <= CURRENT_DATE() ) AND (rinnovi.data_fine IS NULL OR rinnovi.data_fine >= CURRENT_DATE() )
	GROUP BY immobili.id, contratti.id, contratti_anagrafica.id_contratto
;

-- | 202609292216

-- immobili_caratteristiche_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS `immobili_caratteristiche_view` AS
	SELECT
		immobili_caratteristiche.id,
		immobili_caratteristiche.id_immobile,
		immobili_caratteristiche.id_caratteristica,
		caratteristiche.nome AS caratteristica,
		immobili_caratteristiche.ordine,
		immobili_caratteristiche.se_presente,
		immobili_caratteristiche.id_account_inserimento,
		immobili_caratteristiche.id_account_aggiornamento,
		concat(
			immobili_caratteristiche.id_immobile,
			' / ',
			caratteristiche.nome
		) AS __label__
	FROM immobili_caratteristiche
		LEFT JOIN caratteristiche ON caratteristiche.id = immobili_caratteristiche.id_caratteristica
;

-- | 202609292217

-- indirizzi_caratteristiche_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS `indirizzi_caratteristiche_view` AS
	SELECT
		indirizzi_caratteristiche.id,
		indirizzi_caratteristiche.id_indirizzo,
		indirizzi_caratteristiche.id_caratteristica,
		caratteristiche.nome AS caratteristica,
		indirizzi_caratteristiche.ordine,
		indirizzi_caratteristiche.se_presente,
		indirizzi_caratteristiche.id_account_inserimento,
		indirizzi_caratteristiche.id_account_aggiornamento,
		concat(
			indirizzi_caratteristiche.id_indirizzo,
			' / ',
			caratteristiche.nome
		) AS __label__
	FROM indirizzi_caratteristiche
		LEFT JOIN caratteristiche ON caratteristiche.id = indirizzi_caratteristiche.id_caratteristica
;

-- | 202609292218

-- licenze_software_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS licenze_software_view AS
	SELECT
		licenze_software.id,
		licenze_software.id_licenza,
		licenze_software.id_software,
		licenze_software.id_account_inserimento,
		licenze_software.id_account_aggiornamento,
		concat( licenze.nome, ' | ', software.nome ) AS __label__
	FROM licenze_software
		LEFT JOIN software ON software.id = licenze_software.id_software
		LEFT JOIN licenze ON licenze.id = licenze_software.id_licenza
;

-- | 202609292219

-- liste_view
-- tipolgia: tabella gestita
CREATE VIEW IF NOT EXISTS `liste_view` AS
	SELECT
	liste.id,
	liste.nome,
	liste.nome AS __label__
	FROM liste
;

-- | 202609292220

-- liste_mail_view
-- tipolgia: tabella gestita
CREATE VIEW IF NOT EXISTS `liste_mail_view` AS
	SELECT
	liste_mail.id,
	liste_mail.id_lista,
	liste.nome AS lista,
	liste_mail.id_mail,
	mail.indirizzo AS mail,
	mail.id_anagrafica,
	coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
	a1.nome AS anagrafica_nome,
	a1.cognome AS anagrafica_cognome,
	a1.denominazione AS anagrafica_denominazione,
	a1.codice_fiscale AS anagrafica_codice_fiscale,
	a1.codice AS anagrafica_codice,
	concat( liste_mail.id_lista, liste_mail.id_mail ) AS __label__
	FROM liste_mail
	INNER JOIN liste ON liste.id = liste_mail.id_lista
	INNER JOIN mail ON mail.id = liste_mail.id_mail
	LEFT JOIN anagrafica AS a1 ON a1.id = mail.id_anagrafica
;

-- | 202609292221

-- listini_clienti_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS `listini_clienti_view` AS
	SELECT
		listini_clienti.id,
		listini_clienti.id_listino,
		concat( listini.nome, ' ', valute.iso4217 ) AS listino,
		listini_clienti.id_cliente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS cliente,
		listini_clienti.ordine,
		listini_clienti.id_account_inserimento,
		listini_clienti.id_account_aggiornamento,
		concat(
			listini.nome,
			' ',
			valute.iso4217,
			' / ',
			coalesce(
				a1.denominazione,
				concat(
					a1.cognome,
					' ',
					a1.nome
				), ''
			)
		) AS __label__
	FROM listini_clienti
		LEFT JOIN listini ON listini.id = listini_clienti.id_listino
		LEFT JOIN valute ON valute.id = listini.id_valuta
		LEFT JOIN anagrafica AS a1 ON a1.id = listini_clienti.id_cliente
;

-- | 202609292222

-- luoghi_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS `luoghi_view` AS
	SELECT
		luoghi.id,
		luoghi.id_genitore,
		luoghi.id_indirizzo,
		concat_ws(
			' ',
			indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) AS indirizzo,
		luoghi.id_tipologia,
		tipologie_luoghi_path( luoghi.id_tipologia ) AS tipologia,
		luoghi.id_edificio,
		luoghi.id_immobile,	
		luoghi.url,	
		luoghi.nome,
		luoghi.id_account_inserimento,
		luoghi.id_account_aggiornamento,
		luoghi_path( luoghi.id ) AS __label__
	FROM luoghi
		LEFT JOIN indirizzi ON indirizzi.id = luoghi.id_indirizzo
		LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
;

-- | 202609292223

-- mailing_view
-- tipolgia: tabella gestita
CREATE VIEW IF NOT EXISTS `mailing_view` AS
	SELECT
	mailing.id,
	mailing.nome,
	mailing.timestamp_invio,
	mailing.id_account_inserimento,
	mailing.id_account_aggiornamento,
	mailing.nome AS __label__
	FROM mailing
;

-- | 202609292224

-- mailing_liste_view
-- tipolgia: tabella gestita
CREATE VIEW IF NOT EXISTS `mailing_liste_view` AS
	SELECT
	mailing_liste.id,
	mailing_liste.id_lista,
	mailing_liste.id_mailing,
	concat( mailing_liste.id_lista, mailing_liste.id_mailing ) AS __label__
	FROM mailing_liste
;

-- | 202609292225

-- mailing_mail_view
-- tipolgia: tabella gestita
CREATE VIEW IF NOT EXISTS `mailing_mail_view` AS
	SELECT
		mailing_mail.id,
		mailing_mail.id_mailing,
		mailing.nome AS mailing,
		mailing_mail.id_mail,
		mail.indirizzo AS mail,
		mail.id_anagrafica,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		mailing_mail.id_mail_out,
		mailing_mail.timestamp_generazione,
		from_unixtime( mailing_mail.timestamp_generazione, '%Y-%m-%d' ) AS data_ora_generazione,
		mailing_mail.timestamp_invio,
		from_unixtime( mailing_mail.timestamp_invio, '%Y-%m-%d' ) AS data_ora_invio,
		concat(mailing_mail.id_mailing  , " | ", mailing_mail.id_mail , " | ", mailing_mail.id_mail_out) AS __label__
	FROM mailing_mail
		INNER JOIN mailing ON mailing.id = mailing_mail.id_mailing
		INNER JOIN mail ON mail.id = mailing_mail.id_mail
		LEFT JOIN anagrafica AS a1 ON a1.id = mail.id_anagrafica
;

-- | 202609292226

-- messaggi_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS `messaggi_view` AS
	SELECT
		messaggi.id,
		messaggi.id_conversazione,
		messaggi.testo,
		messaggi.timestamp_invio,
		messaggi.timestamp_lettura,
		messaggi.id_account_inserimento,
		messaggi.timestamp_inserimento,
		messaggi.id_account_aggiornamento,
		messaggi.timestamp_aggiornamento,
		concat( 'messaggio #', messaggi.id )AS __label__
	FROM messaggi
;

-- | 202609292227

-- orari_view
CREATE VIEW IF NOT EXISTS `orari_view` AS
	SELECT
		orari.id,
		orari.nome,
		orari.id_tipologia_contratti,
		orari.id_periodicita,
		orari.id_giorno,
		orari.ora_inizio,
		orari.ora_fine,
		orari.nome AS __label__
	FROM orari
;

-- | 202609292228

-- periodi_view
-- tipologia: tabella di supporto
CREATE VIEW IF NOT EXISTS `periodi_view` AS
	SELECT
		periodi.id,
		periodi.id_genitore,
		periodi.id_tipologia,
		periodi.id_contratto,
		tipologie_periodi_path( periodi.id_tipologia ) AS tipologia,
		periodi.data_inizio,
		periodi.data_fine,
		periodi.id_account_inserimento,
		periodi.id_account_aggiornamento,
		concat( periodi.nome, ' dal ',CONCAT_WS('-',periodi.data_inizio),' al ',CONCAT_WS('-',periodi.data_fine)) AS __label__
	FROM periodi;

-- | 202609292229

-- pesi_tipologie_corrispondenza_view
CREATE VIEW IF NOT EXISTS `pesi_tipologie_corrispondenza_view` AS
	SELECT
		pesi_tipologie_corrispondenza.id,
		pesi_tipologie_corrispondenza.id_tipologia,
		tipologie_corrispondenza_path( pesi_tipologie_corrispondenza.id_tipologia ) AS tipologia,
		pesi_tipologie_corrispondenza.nome,
		pesi_tipologie_corrispondenza.grammi_min,
		pesi_tipologie_corrispondenza.grammi_max,
		concat_ws(
			' ',
			tipologie_corrispondenza_path( pesi_tipologie_corrispondenza.id_tipologia ),
			pesi_tipologie_corrispondenza.nome,
			'da',
			pesi_tipologie_corrispondenza.grammi_min,
			'a',
			pesi_tipologie_corrispondenza.grammi_max
		) AS __label__
	FROM pesi_tipologie_corrispondenza
;

-- | 202609292230

-- popup_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS `popup_view` AS
	SELECT
		popup.id,
		popup.id_tipologia,
		tipologie_popup.nome AS tipologia,
		popup.id_sito,
		popup.nome,
		popup.html_id,
		popup.html_class,
		popup.html_class_attivazione,
		popup.n_scroll,
		popup.n_secondi,
		popup.template,
		popup.schema_html,
		popup.se_ovunque,
		popup.id_account_inserimento,
		popup.id_account_aggiornamento,
		popup.nome AS __label__
	FROM popup
		LEFT JOIN tipologie_popup ON tipologie_popup.id = popup.id_tipologia
;

-- | 202609292231

-- popup_pagine_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS `popup_pagine_view` AS
	SELECT
		popup_pagine.id,
		popup_pagine.id_popup,
		popup_pagine.id_pagina,
		popup_pagine.se_presente,
		popup_pagine.id_account_inserimento,
		popup_pagine.id_account_aggiornamento,
		concat(
			popup.nome,
			' / ',
			pagine_path( popup_pagine.id_pagina ),
			' / ',
			coalesce( popup_pagine.se_presente, 0 )
		) AS __label__
	FROM popup_pagine
		LEFT JOIN popup ON popup.id = popup_pagine.id_popup
;

-- | 202609292232

-- progetti_anagrafica_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS progetti_anagrafica_view AS
	SELECT
		progetti_anagrafica.id,
		progetti_anagrafica.id_progetto,
		progetti.nome AS progetto,
		progetti_anagrafica.id_anagrafica,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		progetti_anagrafica.id_ruolo,
		ruoli_anagrafica.nome as ruolo,
		progetti_anagrafica.ordine,
		progetti_anagrafica.se_sostituto,
		progetti_anagrafica.id_account_inserimento,
		progetti_anagrafica.id_account_aggiornamento,
 		concat_ws(
			' ',
			progetti.nome,
			coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ),
			ruoli_anagrafica.nome
		) AS __label__
	FROM progetti_anagrafica
		LEFT JOIN progetti ON progetti.id = progetti_anagrafica.id_progetto
		LEFT JOIN anagrafica AS a1 ON a1.id = progetti_anagrafica.id_anagrafica
		LEFT JOIN ruoli_anagrafica ON ruoli_anagrafica.id = progetti_anagrafica.id_ruolo
;

-- | 202609292233

-- progetti_articoli_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS `progetti_articoli_view` AS
	SELECT
		progetti_articoli.id,
		progetti_articoli.id_progetto,
		progetti.nome AS progetto,
		progetti_articoli.id_articolo,
		concat_ws( ' ', prodotti.nome, articoli.nome ) AS articolo,
		progetti_articoli.id_ruolo,
		progetti_articoli.ordine,
		progetti_articoli.id_account_inserimento,
		progetti_articoli.id_account_aggiornamento,
		concat_ws(
			' ',
			progetti.nome,
			concat_ws( ' ', prodotti.nome, articoli.nome ),
			ruoli_articoli.nome
		) AS __label__
	FROM progetti_articoli
		LEFT JOIN ruoli_articoli ON ruoli_articoli.id = progetti_articoli.id_ruolo
		LEFT JOIN progetti ON progetti.id = progetti_articoli.id_progetto
		LEFT JOIN articoli ON articoli.id = progetti_articoli.id_articolo
		LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto;

-- | 202609292234

-- progetti_certificazioni_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS progetti_certificazioni_view AS
	SELECT
		progetti_certificazioni.id,
		progetti_certificazioni.id_progetto,
		progetti.nome AS progetto,
		progetti_certificazioni.id_certificazione,
		certificazioni.nome AS certificazione,
		progetti_certificazioni.ordine,
		progetti_certificazioni.nome,
		progetti_certificazioni.se_richiesta,
		progetti_certificazioni.id_account_inserimento,
		progetti_certificazioni.id_account_aggiornamento,
 		concat_ws(
			' ',
			progetti.nome,
			'/',
			certificazioni.nome 
		) AS __label__
	FROM progetti_certificazioni
		LEFT JOIN progetti ON progetti.id = progetti_certificazioni.id_progetto
		LEFT JOIN certificazioni ON certificazioni.id = progetti_certificazioni.id_certificazione
;

-- | 202609292235

-- progetti_matricole_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS progetti_matricole_view AS
	SELECT
		progetti_matricole.id,
		progetti_matricole.id_progetto,
		progetti.nome AS progetto,
		progetti_matricole.id_matricola,
		matricole.matricola AS matricola,
		progetti_matricole.id_ruolo,
		ruoli_matricole_path( progetti_matricole.id_ruolo ) AS ruolo,
		progetti_matricole.ordine,
		progetti_matricole.id_account_inserimento,
		progetti_matricole.id_account_aggiornamento,
 		concat_ws(
			' ',
			progetti.nome,
			matricole.matricola
		) AS __label__
	FROM progetti_matricole
		LEFT JOIN progetti ON progetti.id = progetti_matricole.id_progetto
		LEFT JOIN matricole ON matricole.id = progetti_matricole.id_matricola
;

-- | 202609292236

-- relazioni_articoli_view
CREATE VIEW IF NOT EXISTS `relazioni_articoli_view` AS
	SELECT 
		relazioni_articoli.id,
		relazioni_articoli.id_articolo,
		relazioni_articoli.id_ruolo,
		relazioni_articoli.id_prodotto_collegato,
		relazioni_articoli.id_articolo_collegato,
		concat( relazioni_articoli.id_articolo,' - ', relazioni_articoli.id_articolo_collegato) AS __label__
	FROM relazioni_articoli
;

-- | 202609292237

-- relazioni_categorie_progetti_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS relazioni_categorie_progetti_view AS
	SELECT
	relazioni_categorie_progetti.id,
	relazioni_categorie_progetti.id_ruolo,
	relazioni_categorie_progetti.id_categoria,
	relazioni_categorie_progetti.id_categoria_collegata,
	concat( relazioni_categorie_progetti.id_categoria,' - ', relazioni_categorie_progetti.id_categoria_collegata ) AS __label__
	FROM relazioni_categorie_progetti
;

-- | 202609292238

-- relazioni_documenti_articoli_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS relazioni_documenti_articoli_view AS
	SELECT
		relazioni_documenti_articoli.id,
		relazioni_documenti_articoli.id_documenti_articolo,
		relazioni_documenti_articoli.id_documenti_articolo_collegato,
		relazioni_documenti_articoli.id_ruolo,
		ruoli_documenti.nome AS ruolo,
		concat( relazioni_documenti_articoli.id_documenti_articolo,' - ', relazioni_documenti_articoli.id_documenti_articolo_collegato, concat_ws(' ', ruoli_documenti.nome ) ) AS __label__
	FROM relazioni_documenti_articoli
		LEFT JOIN ruoli_documenti ON ruoli_documenti.id = relazioni_documenti_articoli.id_ruolo
;

-- | 202609292239

-- relazioni_pagamenti_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS relazioni_pagamenti_view AS
	SELECT
	relazioni_pagamenti.id,
	relazioni_pagamenti.id_pagamento,
	relazioni_pagamenti.id_pagamento_collegato,
	concat( relazioni_pagamenti.id_pagamento,' - ', relazioni_pagamenti.id_pagamento_collegato) AS __label__
	FROM relazioni_pagamenti
;

-- | 202609292240

-- relazioni_progetti_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS relazioni_progetti_view AS
	SELECT
	relazioni_progetti.id,
	relazioni_progetti.id_progetto,
	relazioni_progetti.id_progetto_collegato,
	relazioni_progetti.id_ruolo,
	ruoli_progetti.nome AS ruolo,
	concat( relazioni_progetti.id_progetto,' - ', relazioni_progetti.id_progetto_collegato) AS __label__
	FROM relazioni_progetti
	LEFT JOIN ruoli_progetti ON ruoli_progetti.id = relazioni_progetti.id_ruolo
;

-- | 202609292241

-- relazioni_software_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS relazioni_software_view AS
	SELECT
	relazioni_software.id,
	relazioni_software.id_software,
	relazioni_software.id_software_collegato,
	concat( relazioni_software.id_software,' - ', relazioni_software.id_software_collegato) AS __label__
	FROM relazioni_software
;

-- | 202609292242

-- rinnovi_documenti_articoli_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS rinnovi_documenti_articoli_view AS
	SELECT
	rinnovi_documenti_articoli.id_documenti_articolo,
	rinnovi_documenti_articoli.id_rinnovo,
	concat( rinnovi_documenti_articoli.id_rinnovo ,' - ', rinnovi_documenti_articoli.id_documenti_articolo) AS __label__
	FROM rinnovi_documenti_articoli
;

-- | 202609292243

-- risorse_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS `risorse_view` AS
	SELECT
		risorse.id, 
		risorse.id_tipologia,
		tipologie_risorse.nome AS tipologia,
		risorse.codice, 
		risorse.nome,
		risorse.template,
		risorse.schema_html,
		risorse.tema_css,
		risorse.se_sitemap,
		risorse.se_cacheable,
		risorse.id_sito,
		risorse.id_testata, 
		testate.nome AS testata,
		risorse.id_articolo,
		risorse.id_prodotto,
		risorse.giorno_pubblicazione,
		risorse.mese_pubblicazione,
		risorse.anno_pubblicazione,
		group_concat( DISTINCT categorie_risorse_path( categorie_risorse.id ) SEPARATOR ' | ' ) AS categorie,
		risorse.id_account_inserimento,
		risorse.id_account_aggiornamento,
		concat_ws(
			' ',
			risorse.codice,
			risorse.nome
		) AS __label__
	FROM risorse
		LEFT JOIN tipologie_risorse ON tipologie_risorse.id = risorse.id_tipologia
		LEFT JOIN testate ON testate.id = risorse.id_testata
		LEFT JOIN risorse_categorie ON risorse_categorie.id_risorsa = risorse.id
		LEFT JOIN categorie_risorse ON categorie_risorse.id = risorse_categorie.id_categoria
	GROUP BY risorse.id
;

-- | 202609292244

-- risorse_account
-- tipologia: tabella di supporto
CREATE VIEW IF NOT EXISTS `risorse_account_view` AS
	SELECT
		risorse_account.id,
		risorse_account.id_risorsa,
		risorse.nome AS risorsa,
		risorse_account.id_account,
		risorse_account.ordine,
		risorse_account.id_account_inserimento,
		risorse_account.id_account_aggiornamento,
		risorse.nome AS __label__
	FROM risorse_account
		LEFT JOIN risorse ON risorse.id = risorse_account.id_risorsa
;

-- | 202609292245

-- risorse_anagrafica_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS `risorse_anagrafica_view` AS
	SELECT
		risorse_anagrafica.id,
		risorse_anagrafica.id_risorsa,
		risorse.nome AS risorsa,
		risorse_anagrafica.id_anagrafica,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		risorse_anagrafica.id_ruolo,
		ruoli_anagrafica_path( risorse_anagrafica.id_ruolo ) AS ruolo,
		risorse_anagrafica.ordine,
		risorse_anagrafica.id_account_inserimento,
		risorse_anagrafica.id_account_aggiornamento,
		concat_ws(
			' ',
			risorse.nome,
			ruoli_anagrafica_path( risorse_anagrafica.id_ruolo ),
			coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' )
		) AS __label__
	FROM risorse_anagrafica
		LEFT JOIN risorse ON risorse.id = risorse_anagrafica.id_risorsa
		LEFT JOIN anagrafica AS a1 ON a1.id = risorse_anagrafica.id_anagrafica
;

-- | 202609292246

-- risorse_categorie_view
-- tipologia: tabella di supporto
CREATE VIEW IF NOT EXISTS `risorse_categorie_view` AS
	SELECT
		risorse_categorie.id,
		risorse_categorie.id_risorsa,
		risorse.nome AS risorsa,
		risorse_categorie.id_categoria,
		categorie_risorse_path( risorse_categorie.id_categoria ),
		risorse_categorie.id_account_inserimento,
		risorse_categorie.id_account_aggiornamento,
		concat_ws(
			' ',
			risorse.nome,
			categorie_risorse_path( risorse_categorie.id_categoria )
		) AS __label__
	FROM risorse_categorie
		LEFT JOIN risorse ON risorse.id = risorse_categorie.id_risorsa
;

-- | 202609292247

-- ruoli_articoli_view
-- tipologia: tabella di supporto
CREATE VIEW IF NOT EXISTS ruoli_articoli_view AS
	SELECT
		ruoli_articoli.id,
		ruoli_articoli.id_genitore,
		ruoli_articoli.nome,
		ruoli_articoli.html_entity,
		ruoli_articoli.font_awesome,
		ruoli_articoli.se_progetti,
		ruoli_articoli.se_risorse,
		ruoli_articoli.se_acquisto,
        ruoli_articoli.se_rinnovo,
	 	ruoli_articoli_path( ruoli_articoli.id ) AS __label__
	FROM ruoli_articoli
;

-- | 202609292248

-- ruoli_categorie_progetti_view
-- tipologia: tabella di supporto
CREATE VIEW IF NOT EXISTS ruoli_categorie_progetti_view AS
	SELECT
		ruoli_categorie_progetti.id,
		ruoli_categorie_progetti.id_genitore,
		ruoli_categorie_progetti.nome,
		ruoli_categorie_progetti.html_entity,
		ruoli_categorie_progetti.font_awesome,
		ruoli_categorie_progetti.se_recuperi,
	 	ruoli_categorie_progetti_path( ruoli_categorie_progetti.id ) AS __label__
	FROM ruoli_categorie_progetti
;

-- | 202609292249

-- ruoli_matricole_view
-- tipologia: tabella di supporto
CREATE VIEW IF NOT EXISTS ruoli_matricole_view AS
	SELECT
		ruoli_matricole.id,
		ruoli_matricole.id_genitore,
		ruoli_matricole.nome,
    	ruoli_matricole.html_entity,
    	ruoli_matricole.font_awesome,
	 	ruoli_matricole_path( ruoli_matricole.id ) AS __label__
	FROM ruoli_matricole
;

-- | 202609292250

-- ruoli_progetti
-- tipologia: tabella di supporto
CREATE VIEW IF NOT EXISTS ruoli_progetti_view AS
	SELECT
		ruoli_progetti.id,
		ruoli_progetti.nome,
		ruoli_progetti.html_entity,
		ruoli_progetti.font_awesome,
		ruoli_progetti.se_sottoprogetto,
		ruoli_progetti.se_proseguimento,
		ruoli_progetti.se_sostituto,
		ruoli_progetti.se_attesa,
	 	ruoli_progetti.nome AS __label__
	FROM ruoli_progetti
;

-- | 202609292251

-- software_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS software_view AS
    SELECT
		software.id,
		software.id_genitore,
		software.id_articolo,
		software.codice,
		concat(prodotti.nome, ' - ',articoli.nome) AS articolo,
		software.json,
		software.nome,
		software.note,
		software.id_account_inserimento,
		software.id_account_aggiornamento,
	 	software_path( software.id ) AS __label__
	FROM software
		LEFT JOIN articoli ON software.id_articolo = articoli.id
		LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
;

-- | 202609292252

-- stati_lingue_view
-- tipologia: tabella di supporto
CREATE VIEW IF NOT EXISTS stati_lingue_view AS
    SELECT
		stati_lingue.id,
		stati_lingue.id_stato,
		stati.nome AS stato,
		stati_lingue.id_lingua,
		lingue.nome AS lingua,
		stati_lingue.ordine,
		concat_ws(
			' ',
			stati.nome,
			lingue.nome
		) AS __label__
    FROM stati_lingue
    	LEFT JOIN stati ON stati.id = stati_lingue.id_stato
    	LEFT JOIN lingue ON lingue.id = stati_lingue.id_lingua
;

-- | 202609292253

-- testate_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS `testate_view` AS
	SELECT
		testate.id,
		testate.nome,
		testate.nome AS __label__
	FROM testate
;

-- | 202609292254

-- tipologie_badge_view
-- tipologia: tabella assistita
CREATE VIEW IF NOT EXISTS `tipologie_badge_view` AS
	SELECT
		tipologie_badge.id,
		tipologie_badge.id_genitore,
		tipologie_badge.ordine,
		tipologie_badge.nome,
		tipologie_badge.html_entity,
		tipologie_badge.font_awesome,
		tipologie_badge.id_account_inserimento,
		tipologie_badge.id_account_aggiornamento,
		tipologie_badge.nome AS __label__
	FROM tipologie_badge
;

-- | 202609292255

-- tipologie_banner_view
-- tipologia: tabella assistita
CREATE VIEW IF NOT EXISTS `tipologie_banner_view` AS
	SELECT
		tipologie_banner.id,
		tipologie_banner.id_genitore,
		tipologie_banner.ordine,
		tipologie_banner.nome,
		tipologie_banner.html_entity,
		tipologie_banner.font_awesome,
		tipologie_banner.id_account_inserimento,
		tipologie_banner.id_account_aggiornamento,
		tipologie_banner_path( tipologie_banner.id ) AS __label__
	FROM tipologie_banner
;

-- | 202609292256

-- tipologie_chiavi_view
-- tipologia: tabella assistita
CREATE VIEW IF NOT EXISTS `tipologie_chiavi_view` AS
	SELECT
		tipologie_chiavi.id,
		tipologie_chiavi.id_genitore,
		tipologie_chiavi.ordine,
		tipologie_chiavi.nome,
		tipologie_chiavi.html_entity,
		tipologie_chiavi.font_awesome,
		tipologie_chiavi.id_account_inserimento,
		tipologie_chiavi.id_account_aggiornamento,
		tipologie_chiavi_path( tipologie_chiavi.id ) AS __label__
	FROM tipologie_chiavi
;

-- | 202609292257

-- tipologie_edifici_view
-- tipologia: tabella di supporto
CREATE VIEW IF NOT EXISTS tipologie_edifici_view AS
	SELECT
	tipologie_edifici.id,
	tipologie_edifici.id_genitore,
	tipologie_edifici.ordine,
	tipologie_edifici.nome,
	tipologie_edifici.html_entity,
	tipologie_edifici.font_awesome,
	tipologie_edifici.id_account_inserimento,
	tipologie_edifici.id_account_aggiornamento,
	tipologie_edifici_path( tipologie_edifici.id )  AS __label__
	FROM tipologie_edifici
	;

-- | 202609292258

-- tipologie_immobili_view
-- tipologia: tabella di supporto
CREATE VIEW IF NOT EXISTS tipologie_immobili_view AS
	SELECT
	tipologie_immobili.id,
	tipologie_immobili.id_genitore,
	tipologie_immobili.ordine,
	tipologie_immobili.nome,
	tipologie_immobili.html_entity,
	tipologie_immobili.font_awesome,
	tipologie_immobili.se_residenziale ,
	tipologie_immobili.se_industriale ,
	tipologie_immobili.id_account_inserimento,
	tipologie_immobili.id_account_aggiornamento,
	tipologie_immobili_path( tipologie_immobili.id )  AS __label__
	FROM tipologie_immobili
	;

-- | 202609292259

-- tipologie_licenze_view
-- tipologia: tabella assistita
CREATE VIEW IF NOT EXISTS `tipologie_licenze_view` AS
	SELECT
		tipologie_licenze.id,
		tipologie_licenze.id_genitore,
		tipologie_licenze.ordine,
		tipologie_licenze.nome,
		tipologie_licenze.html_entity,
		tipologie_licenze.font_awesome,
		tipologie_licenze.id_account_inserimento,
		tipologie_licenze.id_account_aggiornamento,
		tipologie_licenze_path( tipologie_licenze.id ) AS __label__
	FROM tipologie_licenze
;

-- | 202609292300

-- tipologie_luoghi_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS `tipologie_luoghi_view` AS
	SELECT
		tipologie_luoghi.id,
		tipologie_luoghi.id_genitore,
		tipologie_luoghi.ordine,
		tipologie_luoghi.nome,
		tipologie_luoghi.html_entity,
		tipologie_luoghi.font_awesome,
		tipologie_luoghi.id_account_inserimento,
		tipologie_luoghi.id_account_aggiornamento,
		tipologie_luoghi_path( tipologie_luoghi.id ) AS __label__
	FROM tipologie_luoghi
;

-- | 202609292301

-- tipologie_mastri_view
-- tipologia: tabella assistita
CREATE VIEW IF NOT EXISTS `tipologie_mastri_view` AS
	SELECT
		tipologie_mastri.id,
		tipologie_mastri.id_genitore,
		tipologie_mastri.ordine,
		tipologie_mastri.nome,
		tipologie_mastri.html_entity,
		tipologie_mastri.font_awesome,
		tipologie_mastri.se_magazzino,
		tipologie_mastri.se_conto,
		tipologie_mastri.se_registro,
		tipologie_mastri.se_credito,
		tipologie_mastri.id_account_inserimento,
		tipologie_mastri.id_account_aggiornamento,
		tipologie_mastri_path( tipologie_mastri.id ) AS __label__
	FROM tipologie_mastri
;

-- | 202609292302

-- tipologie_periodi_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS `tipologie_periodi_view` AS
	SELECT
		tipologie_periodi.id,
		tipologie_periodi.id_genitore,
		tipologie_periodi.ordine,
		tipologie_periodi.codice,
		tipologie_periodi.nome,
		tipologie_periodi.html_entity,
		tipologie_periodi.font_awesome,
		tipologie_periodi.se_corsi,
		tipologie_periodi.se_tesseramenti,
		tipologie_periodi.se_abbonamenti,
		tipologie_periodi.id_account_inserimento,
		tipologie_periodi.id_account_aggiornamento,
		tipologie_periodi_path( tipologie_periodi.id ) AS __label__
	FROM tipologie_periodi
;

-- | 202609292303

-- tipologie_popup_view
-- tipologia: tabella assistita
CREATE VIEW IF NOT EXISTS `tipologie_popup_view` AS
	SELECT
		tipologie_popup.id,
		tipologie_popup.id_genitore,
		tipologie_popup.ordine,
		tipologie_popup.nome,
		tipologie_popup.html_entity,
		tipologie_popup.font_awesome,
		tipologie_popup.id_account_inserimento,
		tipologie_popup.id_account_aggiornamento,
		tipologie_popup_path( tipologie_popup.id ) AS __label__
	FROM tipologie_popup
;

-- | 202609292304

-- tipologie_risorse_view
-- tipologia: tabella assistita
CREATE VIEW IF NOT EXISTS `tipologie_risorse_view` AS
	SELECT
		tipologie_risorse.id,
		tipologie_risorse.id_genitore,
		tipologie_risorse.ordine,
		tipologie_risorse.nome,
		tipologie_risorse.html_entity,
		tipologie_risorse.font_awesome,
		tipologie_risorse.id_account_inserimento,
		tipologie_risorse.id_account_aggiornamento,
		tipologie_risorse_path( tipologie_risorse.id ) AS __label__
	FROM tipologie_risorse
;

-- | 202609292305

-- tipologie_spedizioni_view
CREATE VIEW IF NOT EXISTS `tipologie_spedizioni_view` AS
	SELECT
		tipologie_spedizioni.id,
		tipologie_spedizioni.id_genitore,
		tipologie_spedizioni.ordine,
		tipologie_spedizioni.nome,
		tipologie_spedizioni.html_entity,
		tipologie_spedizioni.font_awesome,
		tipologie_spedizioni.id_account_inserimento,
		tipologie_spedizioni.id_account_aggiornamento,
		tipologie_spedizioni_path( tipologie_spedizioni.id ) AS __label__
	FROM tipologie_spedizioni
;

-- | 202609292306

-- todo_matricole_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS todo_matricole_view AS
	SELECT
		todo_matricole.id,
		todo_matricole.id_todo,
		todo.nome AS todo,
		todo_matricole.id_matricola,
		matricole.matricola AS matricola,
		todo_matricole.id_ruolo,
		ruoli_matricole_path( todo_matricole.id_ruolo ) AS ruolo,
		todo_matricole.ordine,
		todo_matricole.id_account_inserimento,
		todo_matricole.id_account_aggiornamento,
 		concat_ws(
			' ',
			todo.nome,
			matricole.matricola
		) AS __label__
	FROM todo_matricole
		LEFT JOIN todo ON todo.id = todo_matricole.id_todo
		LEFT JOIN matricole ON matricole.id = todo_matricole.id_matricola
;

-- | 202609292307

-- valutazioni_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS valutazioni_view AS
	SELECT
		valutazioni.id,
		valutazioni.id_anagrafica,
		coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ) AS anagrafica,
		valutazioni.id_matricola,
		matricole.matricola AS matricola,
		valutazioni.id_immobile,
		concat_ws(
			' ',
			tipologie_immobili.nome, 
			coalesce(
			concat('scala ', immobili.scala), 
			''
			), 
			coalesce(
			concat('piano ', immobili.piano), 
			''
			), 
			coalesce(
			concat('int. ', immobili.interno), 
			''
			),
			tipologie_edifici.nome,
			edifici.nome,
			tipologie_indirizzi.nome,
			indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) AS immobile,
		valutazioni.mq_commerciali,
		valutazioni.mq_calpestabili,
		valutazioni.id_condizione,
		condizioni.nome AS condizione,
		valutazioni.id_disponibilita,
		disponibilita.nome AS disponibilita,
		valutazioni.id_classe_energetica,
		classi_energetiche.nome AS classe_energetica,
		valutazioni.timestamp_valutazione,
		valutazioni.id_account_inserimento,
		valutazioni.id_account_aggiornamento,
		concat('valutazione ', 	concat_ws(
			' ',
			tipologie_immobili.nome, 
			coalesce(
			concat('scala ', immobili.scala), 
			''
			), 
			coalesce(
			concat('piano ', immobili.piano), 
			''
			), 
			coalesce(
			concat('int. ', immobili.interno), 
			''
			),
			tipologie_edifici.nome,
			edifici.nome,
			tipologie_indirizzi.nome,
			indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) ) AS __label__
	FROM valutazioni
		LEFT JOIN anagrafica ON anagrafica.id = valutazioni.id_anagrafica
		LEFT JOIN matricole ON matricole.id = valutazioni.id_matricola
		LEFT JOIN immobili ON immobili.id = valutazioni.id_immobile
		LEFT JOIN condizioni ON condizioni.id = valutazioni.id_condizione
		LEFT JOIN disponibilita ON disponibilita.id = valutazioni.id_disponibilita
		LEFT JOIN classi_energetiche ON classi_energetiche.id = valutazioni.id_classe_energetica
		LEFT JOIN tipologie_immobili ON tipologie_immobili.id = immobili.id_tipologia
		LEFT JOIN edifici ON edifici.id = immobili.id_edificio
		LEFT JOIN tipologie_edifici ON tipologie_edifici.id = edifici.id_tipologia
		LEFT JOIN indirizzi ON indirizzi.id = edifici.id_indirizzo
		LEFT JOIN tipologie_indirizzi ON tipologie_indirizzi.id = indirizzi.id_tipologia
		LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
		LEFT JOIN regioni ON regioni.id = provincie.id_regione
		LEFT JOIN stati ON stati.id = regioni.id_stato;

-- | 202609292308

-- valutazioni_certificazioni_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS `valutazioni_certificazioni_view` AS
	SELECT
		valutazioni_certificazioni.id,
		valutazioni_certificazioni.id_valutazione,
		valutazioni_certificazioni.id_certificazione,
		certificazioni.nome AS certificazione,
		valutazioni_certificazioni.id_emittente,
		coalesce( emittente.denominazione , concat( emittente.cognome, ' ', emittente.nome ), '' ) AS emittente,
		valutazioni_certificazioni.nome,
		valutazioni_certificazioni.codice,
		valutazioni_certificazioni.data_emissione,
		valutazioni_certificazioni.data_scadenza,
		concat(
			valutazioni_certificazioni.id_valutazione, ' ',
			certificazioni.nome,
			' - ',
			valutazioni_certificazioni.codice
		) AS __label__
	FROM valutazioni_certificazioni
		LEFT JOIN anagrafica AS emittente ON emittente.id = valutazioni_certificazioni.id_emittente
		INNER JOIN certificazioni ON certificazioni.id = valutazioni_certificazioni.id_certificazione		
;

-- | 202609292309

-- zone_cap_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS zone_cap_view AS
	SELECT
		zone_cap.id,
		zone_cap.cap,
		zone_cap.id_zona,
		zone_cap.ordine,
		zone_cap.id_account_inserimento,
		zone_cap.id_account_aggiornamento,
		concat(zone_cap.cap, ' - ', zone_cap.id_zona) AS __label__
	FROM zone_cap
;

-- | 202609292310

-- zone_indirizzi_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS zone_indirizzi_view AS
	SELECT
		zone_indirizzi.id,
		zone_indirizzi.id_indirizzo,
		zone_indirizzi.id_zona,
		zone_indirizzi.ordine,
		zone_indirizzi.id_account_inserimento,
		zone_indirizzi.id_account_aggiornamento,
		concat(zone_indirizzi.id_indirizzo, ' - ', zone_indirizzi.id_zona) AS __label__
	FROM zone_indirizzi
;

-- | 202609292311

-- zone_stati_view
-- tipologia: tabella gestita
CREATE VIEW IF NOT EXISTS zone_stati_view AS
	SELECT
		zone_stati.id,
		zone_stati.id_stato,
		stati.nome AS stato,
		zone_stati.id_zona,
		zone.nome AS zona,
		zone_stati.ordine,
		zone_stati.id_account_inserimento,
		zone_stati.id_account_aggiornamento,
		concat(zone_stati.id_stato, ' - ', zone_stati.id_zona) AS __label__
	FROM zone_stati
		LEFT JOIN stati ON stati.id = zone_stati.id_stato
		LEFT JOIN zone ON zone.id = zone_stati.id_zona
;

-- | FINE FILE
