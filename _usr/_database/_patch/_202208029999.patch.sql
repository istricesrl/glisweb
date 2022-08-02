--
-- PATCH
--

--| 202208020010
ALTER TABLE `contratti`
DROP CONSTRAINT `contratti_ibfk_02_nofollow`;

--| 202208020020
ALTER TABLE `contratti`
DROP FOREIGN KEY  `contratti_ibfk_03_nofollow`

--| 202208020030
ALTER TABLE `contratti`
DROP KEY `id_emittente`,
DROP KEY `id_destinatario`,
DROP KEY `indice`;

--| 202208020040
ALTER TABLE `contratti` 
	DROP COLUMN `id_emittente`,
	DROP COLUMN `id_destinatario`,
	ADD KEY `indice` ( `id_tipologia`, `codice`, `nome`, `id_progetto`, `id_immobile`);

--| 202208020050
CREATE TABLE IF NOT EXISTS `risorse_account` (
  `id` int(11) NOT NULL,
  `id_risorsa` int(11) NOT NULL,
  `id_account` int(11) NOT NULL,
  `ordine` int(11) DEFAULT NULL,
  `note` text,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` int(11) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` int(11) DEFAULT NULL	
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202208020060
ALTER TABLE `risorse_account`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_risorsa`,`id_account`),
	ADD KEY `id_account` (`id_account`),
	ADD KEY `id_risorsa` (`id_risorsa`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_risorsa`,`id_account`,`ordine`);

--| 202208020070
ALTER TABLE `risorse_account` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202208020080
ALTER TABLE `risorse_account`
    ADD CONSTRAINT `risorse_account_ibfk_01`             FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `risorse_account_ibfk_02_nofollow`    FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `risorse_account_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `risorse_account_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202208020100
CREATE OR REPLACE VIEW `risorse_account_view` AS
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

--| 202208020120
ALTER TABLE `menu`
    ADD `id_categoria_progetti` INT(11) DEFAULT NULL AFTER `id_categoria_risorse`,
    ADD KEY `id_categoria_progetti` (`id_categoria_progetti`),
    ADD UNIQUE KEY `unica_categoria_progetti` (`id_lingua`,`id_categoria_progetti`,`menu`), 
    ADD CONSTRAINT `menu_ibfk_06`               FOREIGN KEY (`id_categoria_progetti`) REFERENCES `categorie_progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202208020130
CREATE OR REPLACE VIEW `menu_view` AS
    SELECT
		menu.id,
		menu.id_lingua,
		menu.id_pagina,
		menu.id_categoria_prodotti,
		menu.id_categoria_notizie,
		menu.id_categoria_risorse,
		menu.id_categoria_progetti,
		menu.ordine,
		menu.menu,
		menu.nome,
		menu.target,
		menu.ancora,
		menu.sottopagine,
		menu.id_account_inserimento,
		menu.id_account_aggiornamento,
		concat_ws(
			' / ',
			menu.menu,
			menu.ordine,
			lingue.ietf,
			menu.nome
		) AS __label__
    FROM menu
		INNER JOIN lingue ON lingue.id = menu.id_lingua
;

--| 202208020140
ALTER TABLE `luoghi`
    ADD `url` char(255) DEFAULT NULL AFTER `id_immobile`,
    ADD KEY `url` (`url`);

--| 202208020150
CREATE OR REPLACE VIEW `luoghi_view` AS
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

--| FINE