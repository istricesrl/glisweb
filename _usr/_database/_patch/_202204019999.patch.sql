--
-- PATCH
--

--| 202204010010
ALTER TABLE `ruoli_anagrafica` 
ADD `se_produzione` INT(1) NULL DEFAULT NULL AFTER `font_awesome`, 
ADD `se_didattica` INT(1) NULL DEFAULT NULL AFTER `se_produzione`,
ADD KEY `se_didattica` (`se_didattica`),
ADD KEY `se_produzione` (`se_produzione`);

--| 202204010020
ALTER TABLE `tipologie_progetti` 
ADD `se_produzione` INT(1) NULL DEFAULT NULL AFTER `font_awesome`, 
ADD `se_didattica` int(1) NULL DEFAULT NULL AFTER `se_produzione`,
ADD KEY `se_didattica` (`se_didattica`),
ADD KEY `se_produzione` (`se_produzione`);

--| 202204010030
INSERT INTO `tipologie_progetti` (`id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`, `se_produzione`, `se_contratto`, `se_pacchetto`, `se_progetto`, `se_consuntivo`, `se_forfait`,  `se_didattica`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'contratto',	'',	'',	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	'pacchetto',	'',	'',	1,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	NULL,	NULL,	'progetto',	'',	'',	1,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(4,	NULL,	NULL,	'consuntivo',	'',	'',	1,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(5,	NULL,	NULL,	'forfait',	'',	'',	1,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(6,	NULL,	NULL,	'corso',	'',	'',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL)
ON DUPLICATE KEY UPDATE
	id_genitore = VALUES( id_genitore ),
	ordine = VALUES( ordine ),
	nome = VALUES(nome),
	html_entity = VALUES(html_entity),
	font_awesome = VALUES(font_awesome),
	se_produzione = VALUES(se_produzione),
	se_contratto = VALUES(se_contratto),
	se_pacchetto = VALUES(se_pacchetto),
	se_progetto = VALUES(se_progetto),
	se_consuntivo = VALUES(se_consuntivo),
	se_forfait = VALUES(se_forfait),
	se_didattica = VALUES(se_didattica);

--| 202204010040
INSERT INTO `tipologie_anagrafica` (`id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`, `se_persona_fisica`, `se_persona_giuridica`, `se_pubblica_amministrazione`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(6,	NULL,	NULL,	'pubblica amministrazione',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL);


--| FINE FILE

