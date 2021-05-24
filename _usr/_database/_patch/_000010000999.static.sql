--
-- VISTE STATICHE
-- questo file contiene le query per la creazione delle tabelle per le view statiche
--
-- CRITERI DI VERIFICA
-- una definizione di view statica si può dire verificata se:
-- - le colonne rispecchiano esattamente in ordine le colonne della relativa view
--

--| 000010000400

-- tabella anagrafica_view_static
-- tipologia: tabella gestita
-- verifica: 2021-05-20 18:47 Fabio Mosti
CREATE TABLE IF NOT EXISTS `anagrafica_view_static` (
  `id` int(11) NOT NULL,
  `codice` char(32) DEFAULT NULL,
  `riferimento` char(32) DEFAULT NULL,
  `tipologia` char(32) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `cognome` char(255) DEFAULT NULL,
  `denominazione` char(255) DEFAULT NULL,
  `soprannome` char(128) DEFAULT NULL,
  `sesso` char(1) NOT NULL DEFAULT '-',
  `codice_fiscale` char(32) DEFAULT NULL,
  `partita_iva` char(32) DEFAULT NULL,
  `tipologia_crm` char(128) DEFAULT NULL,
  `recapiti` text,
  `se_collaboratore` int(1) DEFAULT NULL,
  `se_dipendente` int(1) DEFAULT NULL,
  `se_interinale` int(1) DEFAULT NULL,
  `se_cliente` int(1) DEFAULT NULL,
  `se_lead` int(1) DEFAULT NULL,
  `se_prospect` int(1) DEFAULT NULL,
  `se_mandante` int(1) DEFAULT NULL,
  `se_fornitore` int(1) DEFAULT NULL,
  `se_produttore` int(1) DEFAULT NULL,
  `se_agente` int(1) DEFAULT NULL,
  `se_interno` int(1) DEFAULT NULL,
  `se_esterno` int(1) DEFAULT NULL,
  `se_amministrazione` int(1) DEFAULT NULL,
  `se_produzione` int(1) DEFAULT NULL,
  `se_azienda_gestita` int(1) DEFAULT NULL,
  `se_concorrente` int(1) DEFAULT NULL,
  `se_tutor` int(1) DEFAULT NULL,
  `se_classe` int(1) DEFAULT NULL,
  `se_docente` int(1) DEFAULT NULL,
  `se_allievo` int(1) DEFAULT NULL,
  `se_agenzia_interinale` int(1) DEFAULT NULL,
  `se_referente` int(1) DEFAULT NULL,
  `se_sostituto` int(1) DEFAULT NULL,
  `se_squadra` int(1) DEFAULT NULL,
  `categorie` text,
  `telefoni` text,
  `mail` text,
  `__label__` char(255) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--| FINE FILE
