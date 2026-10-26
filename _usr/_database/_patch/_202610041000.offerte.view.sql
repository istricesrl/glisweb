-- 2026-10-04 — offerte_view e offerte_view_static al posto di offerte_attive_view e offerte_attive_view_static
--
-- Decisione di Fabio del 03/10/2026: la statica delle offerte comprende TUTTE le offerte, emesse e ricevute, e
-- nasce dalla sua vista offerte_view, che torna nel canone ( _090000999999.views.sql ). offerte_attive_view, tolta
-- dal canone in d975b4a15, restava solo su qualche deploy ( fra i dev, utensilerialughese ); il filtro "attive"
-- ( emittente gestito ) adesso lo applica l'elenco, _mod/_0400.documenti/_src/_inc/_macro/_offerte.commerciale.view.php.
--
-- La statica si popola qui UNA volta, per intero: e' un'installazione, e offerte_view non ha piu' nel WHERE la
-- anagrafica_check_gestita() che rendeva cara la vecchia vista. I timestamp si prendono da documenti ( o dall'ora
-- corrente se li' sono NULL ), cosi' la prima syncStaticView() trova la statica gia' in pari. Dopo, a tenerla
-- allineata sono il controller _documenti.finally.php e il task _offerte.view.static.popolazione.
--
-- Nella stessa patch ( richiesta del coordinamento, 04/10/2026, dalla verifica dei file base ):
-- - sette viste che sui DB avevano una definizione diversa dal base ( contenuti, documenti, immagini, prodotti,
--   ruoli_file, ruoli_immagini, pagamenti ): si ricreano copiate da _090000999999.views.sql, che e' il canone;
-- - la chiave unica unica_mail ( id_mailing, id_mail ) di mailing_mail, dichiarata nel base 030 ma tolta dai DB
--   dalla patch 202610023571 perche' canone-db.py non riconosceva la forma senza KEY: si rimette se manca.
--
-- IDEMPOTENTE.

-- | 202610041000

-- vuota dal 26/10/2026: ricreava una vista copiandola dal base, e la copia restava indietro quando il canone andava
-- avanti; le viste vivono solo nei file base e ai deploy arrivano con le migrazioni del canone ( 300.database.md )

-- | 202610041001

CREATE TABLE IF NOT EXISTS `offerte_view_static` (            --
  `id` bigint(20) PRIMARY KEY NOT NULL,                       --
  `id_tipologia` bigint(20) DEFAULT NULL,                     --
  `tipologia` char(255) DEFAULT NULL,                         --
  `codice` char(64) DEFAULT NULL,                             --
  `numero` char(32) DEFAULT NULL,                             --
  `sezionale` char(32) DEFAULT NULL,                          --
  `data` date DEFAULT NULL,                                   --
  `nome` char(255) DEFAULT NULL,                              --
  `id_emittente` bigint(20) DEFAULT NULL,                     --
  `emittente` varchar(320) DEFAULT NULL,                      --
  `id_destinatario` bigint(20) DEFAULT NULL,                  --
  `destinatario` varchar(320) DEFAULT NULL,                   --
  `id_mastro_provenienza` bigint(20) DEFAULT NULL,            --
  `mastro_provenienza` char(64) DEFAULT NULL,                 --
  `id_mastro_destinazione` bigint(20) DEFAULT NULL,           --
  `mastro_destinazione` char(64) DEFAULT NULL,                --
  `id_causale` bigint(20) DEFAULT NULL,                       --
  `porto` enum('franco','assegnato','-') DEFAULT NULL,        --
  `id_trasportatore` bigint(20) DEFAULT NULL,                 --
  `id_account_inserimento` bigint(20) DEFAULT NULL,           --
  `timestamp_inserimento` int(11) DEFAULT NULL,               --
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,         --
  `timestamp_aggiornamento` int(11) DEFAULT NULL,             --
  `__label__` text,                                           --
  UNIQUE KEY `codice` (`codice`),                             --
  KEY `data` (`data`)                                         --
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202610041002

REPLACE INTO `offerte_view_static` ( `id`, `id_tipologia`, `tipologia`, `codice`, `numero`, `sezionale`, `data`, `nome`, `id_emittente`, `emittente`, `id_destinatario`, `destinatario`, `id_mastro_provenienza`, `mastro_provenienza`, `id_mastro_destinazione`, `mastro_destinazione`, `id_causale`, `porto`, `id_trasportatore`, `id_account_inserimento`, `id_account_aggiornamento`, `__label__`, `timestamp_inserimento`, `timestamp_aggiornamento` )
    SELECT offerte_view.`id`, offerte_view.`id_tipologia`, offerte_view.`tipologia`, offerte_view.`codice`, offerte_view.`numero`, offerte_view.`sezionale`, offerte_view.`data`, offerte_view.`nome`, offerte_view.`id_emittente`, offerte_view.`emittente`, offerte_view.`id_destinatario`, offerte_view.`destinatario`, offerte_view.`id_mastro_provenienza`, offerte_view.`mastro_provenienza`, offerte_view.`id_mastro_destinazione`, offerte_view.`mastro_destinazione`, offerte_view.`id_causale`, offerte_view.`porto`, offerte_view.`id_trasportatore`, offerte_view.`id_account_inserimento`, offerte_view.`id_account_aggiornamento`, offerte_view.`__label__`,
        coalesce( documenti.timestamp_inserimento, unix_timestamp() ),
        coalesce( documenti.timestamp_aggiornamento, unix_timestamp() )
    FROM offerte_view
        INNER JOIN documenti ON documenti.id = offerte_view.id;

-- | 202610041003

DROP TABLE IF EXISTS `offerte_attive_view_static`;

-- | 202610041004

DROP VIEW IF EXISTS `offerte_attive_view`;

-- | 202610041010

-- vuota dal 26/10/2026: ricreava una vista copiandola dal base, e la copia restava indietro quando il canone andava
-- avanti; le viste vivono solo nei file base e ai deploy arrivano con le migrazioni del canone ( 300.database.md )

-- | 202610041011

-- vuota dal 26/10/2026: ricreava una vista copiandola dal base, e la copia restava indietro quando il canone andava
-- avanti; le viste vivono solo nei file base e ai deploy arrivano con le migrazioni del canone ( 300.database.md )

-- | 202610041012

-- vuota dal 26/10/2026: ricreava una vista copiandola dal base, e la copia restava indietro quando il canone andava
-- avanti; le viste vivono solo nei file base e ai deploy arrivano con le migrazioni del canone ( 300.database.md )

-- | 202610041013

-- vuota dal 26/10/2026: ricreava una vista copiandola dal base, e la copia restava indietro quando il canone andava
-- avanti; le viste vivono solo nei file base e ai deploy arrivano con le migrazioni del canone ( 300.database.md )

-- | 202610041014

-- vuota dal 26/10/2026: ricreava una vista copiandola dal base, e la copia restava indietro quando il canone andava
-- avanti; le viste vivono solo nei file base e ai deploy arrivano con le migrazioni del canone ( 300.database.md )

-- | 202610041015

-- vuota dal 26/10/2026: ricreava una vista copiandola dal base, e la copia restava indietro quando il canone andava
-- avanti; le viste vivono solo nei file base e ai deploy arrivano con le migrazioni del canone ( 300.database.md )

-- | 202610041016

-- vuota dal 26/10/2026: ricreava una vista copiandola dal base, e la copia restava indietro quando il canone andava
-- avanti; le viste vivono solo nei file base e ai deploy arrivano con le migrazioni del canone ( 300.database.md )

-- | 202610041020

ALTER TABLE `mailing_mail` ADD UNIQUE KEY IF NOT EXISTS `unica_mail` (`id_mailing`, `id_mail`);

-- | FINE
