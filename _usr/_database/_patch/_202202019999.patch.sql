--
-- PATCH
--

--| 202202010010
ALTER TABLE documenti
ADD esigibilita	enum('I','D','S') NULL DEFAULT NULL AFTER id_condizione_pagamento,
ADD note_cliente text NULL DEFAULT NULL AFTER note;

--| 202202010020
ALTER TABLE `documenti`
CHANGE `id_tipologia` `id_tipologia` int NULL AFTER `id`,
CHANGE `numero` `numero` int NULL AFTER `id_tipologia`,
CHANGE `data` `data` date NULL AFTER `sezionale`,
CHANGE `id_emittente` `id_emittente` int NULL AFTER `nome`,
CHANGE `id_destinatario` `id_destinatario` int NULL AFTER `id_sede_emittente`;

--| 202202010030
ALTER TABLE `categorie_anagrafica`
CHANGE `se_concorrente` `se_concorrente` int NULL AFTER `se_esterno`,
CHANGE `se_gestita` `se_gestita` int NULL AFTER `se_concorrente`,
CHANGE `se_agente` `se_commerciale` int NULL AFTER `se_gestita`;

--| 202202010040
CREATE OR REPLACE VIEW categorie_anagrafica_view AS
	SELECT
		categorie_anagrafica.id,
		categorie_anagrafica.id_genitore,
		categorie_anagrafica.ordine,
		categorie_anagrafica.nome,
		categorie_anagrafica.se_prospect,
		categorie_anagrafica.se_lead,
		categorie_anagrafica.se_cliente,
		categorie_anagrafica.se_fornitore,
		categorie_anagrafica.se_produttore,
		categorie_anagrafica.se_collaboratore,
		categorie_anagrafica.se_interno,
		categorie_anagrafica.se_esterno,
		categorie_anagrafica.se_concorrente,
		categorie_anagrafica.se_gestita,
		categorie_anagrafica.se_amministrazione,
		categorie_anagrafica.se_produzione,
		categorie_anagrafica.se_commerciale,
		categorie_anagrafica.se_notizie,
		count( c1.id ) AS figli,
		count( anagrafica_categorie.id ) AS membri,
		categorie_anagrafica.id_account_inserimento,
		categorie_anagrafica.id_account_aggiornamento,
	 	categorie_anagrafica_path( categorie_anagrafica.id ) AS __label__
	FROM categorie_anagrafica
		LEFT JOIN categorie_anagrafica AS c1 ON c1.id_genitore = categorie_anagrafica.id
		LEFT JOIN anagrafica_categorie ON anagrafica_categorie.id_categoria = categorie_anagrafica.id
	GROUP BY categorie_anagrafica.id
;

--| 202202010050
CREATE TABLE `tipologie_contratti` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ordine` int DEFAULT NULL,
  `nome` char(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`nome`),
  KEY `ordine` (`ordine`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`ordine`,`nome`,`html_entity`,`font_awesome`),
  CONSTRAINT `tipologie_contratti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_contratti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB;

--| 202202010090
ALTER TABLE anagrafica ADD `note_amministrative` text NULL AFTER `note_collaborazione`;

--| 202202010100
CREATE TABLE IF NOT EXISTS `relazioni_anagrafica` (
`id` int(11) NOT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_ruolo` int(11) DEFAULT NULL,
  `id_anagrafica_collegata` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202202010110
ALTER TABLE `relazioni_anagrafica`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_ruolo` (`id_ruolo`),
	ADD KEY `id_anagrafica` (`id_anagrafica`),
	ADD KEY `id_anagrafica_collegata` (`id_anagrafica_collegata`),
	ADD UNIQUE KEY `unico` (`id_anagrafica`,`id_anagrafica_collegata`, `id_ruolo`);

--| 202202010120
ALTER TABLE `relazioni_anagrafica`
ADD CONSTRAINT `relazioni_anagrafica_ibfk_01` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `relazioni_anagrafica_ibfk_02` FOREIGN KEY (`id_anagrafica_collegata`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202202010130
ALTER TABLE ruoli_anagrafica ADD `se_relazioni` int(1) NULL AFTER `se_organizzazioni`;

--| 202202010140
CREATE OR REPLACE VIEW ruoli_anagrafica_view AS
	SELECT
		ruoli_anagrafica.id,
		ruoli_anagrafica.id_genitore,
		ruoli_anagrafica.nome,
		ruoli_anagrafica.se_organizzazioni,
		ruoli_anagrafica.se_relazioni,
		ruoli_anagrafica.se_risorse,
		ruoli_anagrafica.se_progetti,
	 	ruoli_anagrafica_path( ruoli_anagrafica.id ) AS __label__
	FROM ruoli_anagrafica
;

--| 202202010150
INSERT INTO `ruoli_anagrafica` (`id`, `id_genitore`, `nome`, `html_entity`, `font_awesome`, `se_organizzazioni`, `se_relazioni`, `se_risorse`, `se_progetti`) VALUES
(1,	NULL,	'titolare',	NULL,	NULL,	1,	NULL,	NULL,	NULL),
(2,	NULL,	'amministratore',	NULL,	NULL,	1,	NULL,	NULL,	NULL),
(3,	NULL,	'socio',	NULL,	NULL,	1,	NULL,	NULL,	NULL),
(4,	NULL,	'dipendente',	NULL,	NULL,	1,	NULL,	NULL,	NULL),
(5,	NULL,	'direttore',	NULL,	NULL,	1,	NULL,	NULL,	NULL),
(6,	NULL,	'presidente',	NULL,	NULL,	1,	NULL,	NULL,	NULL),
(7,	NULL,	'tesoriere',	NULL,	NULL,	1,	NULL,	NULL,	NULL),
(8,	NULL,	'coordinatore',	NULL,	NULL,	1,	NULL,	NULL,	1),
(9,	NULL,	'vicepresidente',	NULL,	NULL,	1,	NULL,	NULL,	NULL),
(10,	NULL,	'vicedirettore',	NULL,	NULL,	1,	NULL,	NULL,	NULL),
(11,	NULL,	'segretario',	NULL,	NULL,	1,	NULL,	NULL,	NULL),
(12,	NULL,	'responsabile amministrativo',	NULL,	NULL,	1,	NULL,	NULL,	NULL),
(13,	NULL,	'responsabile acquisti',	NULL,	NULL,	1,	NULL,	NULL,	NULL),
(14,	NULL,	'responsabile operativo',	NULL,	NULL,	1,	NULL,	NULL,	NULL),
(15,	NULL,	'operatore',	NULL,	NULL,	NULL,	NULL,	NULL,	1),
(16,	NULL,	'responsabile',	NULL,	NULL,	NULL,	NULL,	NULL,	1),
(17,	NULL,	'assistente',	NULL,	NULL,	1,	NULL,	NULL,	1),
(18,	NULL,	'autore',	NULL,	NULL,	NULL,	NULL,	1,	NULL),
(19,	NULL,	'genitore',	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(20,	NULL,	'fratello',	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(21,	NULL,	'tutore',	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(22,	NULL,	'coniuge',	NULL,	NULL,	NULL,	1,	NULL,	NULL)
ON DUPLICATE KEY UPDATE
	nome = VALUES( nome ),
	se_organizzazioni = VALUES( se_organizzazioni ),
	se_relazioni = VALUES( se_relazioni ),
	se_risorse = VALUES( se_risorse ),
	se_progetti = VALUES( se_progetti ),
	id_genitore = VALUES( id_genitore )
;





--| FINE