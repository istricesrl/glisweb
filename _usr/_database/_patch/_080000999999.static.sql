--
-- VISTE STATICHE
-- questo file contiene le query per la creazione delle tabelle per le view statiche
--
-- CRITERI DI VERIFICA
-- una definizione di view statica si può dire verificata se:
-- - le colonne rispecchiano esattamente in ordine le colonne della relativa view
--

--| 080000000400

-- tabella anagrafica_view_static
-- tipologia: tabella gestita
-- verifica: 2021-05-20 18:47 Fabio Mosti
CREATE TABLE IF NOT EXISTS `anagrafica_view_static` (
  `id` int(11) NOT NULL,
  `tipologia` char(32) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `riferimento` char(32) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `cognome` char(255) DEFAULT NULL,
  `denominazione` char(255) DEFAULT NULL,
  `soprannome` char(128) DEFAULT NULL,
  `sesso` char(1) NOT NULL DEFAULT '-',
  `codice_fiscale` char(32) DEFAULT NULL,
  `partita_iva` char(32) DEFAULT NULL,
  `ranking` char(128) DEFAULT NULL,
  `recapiti` text,
  `se_prospect` int(1) DEFAULT NULL,
  `se_lead` int(1) DEFAULT NULL,
  `se_cliente` int(1) DEFAULT NULL,
  `se_fornitore` int(1) DEFAULT NULL,
  `se_produttore` int(1) DEFAULT NULL,
  `se_collaboratore` int(1) DEFAULT NULL,
  `se_interno` int(1) DEFAULT NULL,
  `se_esterno` int(1) DEFAULT NULL,
  `se_agente` int(1) DEFAULT NULL,
  `se_concorrente` int(1) DEFAULT NULL,
  `se_gestita` int(1) DEFAULT NULL,
  `se_amministrazione` int(1) DEFAULT NULL,
  `se_notizie` int(1) DEFAULT NULL,
  `categorie` text,
  `telefoni` text,
  `mail` text,
  `data_archiviazione` date DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `__label__` char(255) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--| FINE FILE
