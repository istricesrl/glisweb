
-- TIPOLOGIE
-- questo file contiene le query per la creazione delle tabelle delle tipologie,
-- che non hanno interdipendenze

--| 000000000101

-- tabella standard
CREATE TABLE IF NOT EXISTS `tipologie_anagrafica` (
`id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `nome` char(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000000000102

-- indici
ALTER TABLE `tipologie_anagrafica`
 ADD PRIMARY KEY (`id`),
 ADD KEY `id_genitore` (`id_genitore`);

--| 000000000103

-- auto increment
ALTER TABLE `tipologie_anagrafica` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000000000104

-- limiti
ALTER TABLE `tipologie_anagrafica`
  ADD CONSTRAINT `tipologie_anagrafica_ibfk_1_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 000000000105

-- dati standard
INSERT INTO `tipologie_anagrafica` (`id`, `id_genitore`, `nome`) VALUES
  (1, NULL, 'sig.'),
  (2, NULL, 'sig.ra')
ON DUPLICATE KEY UPDATE
	id_genitore = VALUES( id_genitore ),
	nome = VALUES( nome );

--| FINE FILE
