--
-- PATCH
--

--| 202201170010
CREATE TABLE IF NOT EXISTS `relazioni_progetti` (
`id` char(32) NOT NULL,
  `id_progetto` int(11) DEFAULT NULL,
  `id_progetto_collegato` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202201170020
ALTER TABLE `relazioni_progetti`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_progetto` (`id_progetto`),
	ADD KEY `id_progetto_collegato` (`id_progetto_collegato`),
	ADD UNIQUE KEY `unico` (`id_progetto`,`id_progetto_collegato`);

--| 202201170030
ALTER TABLE `relazioni_progetti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202201170040
ALTER TABLE `relazioni_progetti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202201170050
ALTER TABLE `relazioni_progetti`
ADD CONSTRAINT `relazioni_progetti_ibfk_01` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `relazioni_progetti_ibfk_02` FOREIGN KEY (`id_progetto_collegato`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202201170060
CREATE OR REPLACE VIEW relazioni_progetti_view AS
	SELECT
	relazioni_progetti.id_progetto,
	relazioni_progetti.id_progetto_collegato,
	concat( relazioni_progetti.id_progetto,' - ', relazioni_progetti.id_progetto_collegato) AS __label__
	FROM relazioni_progetti
	ORDER BY __label__
;

--| 202201170070
CREATE TABLE IF NOT EXISTS `relazioni_software` (
`id` int(11) NOT NULL,
  `id_software` int(11) DEFAULT NULL,
  `id_software_collegato` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202201170080
ALTER TABLE `relazioni_software`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_software` (`id_software`),
	ADD KEY `id_software_collegato` (`id_software_collegato`),
	ADD UNIQUE KEY `unico` (`id_software`,`id_software_collegato`);

--| 202201170090
ALTER TABLE `relazioni_software` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202201170100
ALTER TABLE `relazioni_software`
ADD CONSTRAINT `relazioni_software_ibfk_01` FOREIGN KEY (`id_software`) REFERENCES `software` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `relazioni_software_ibfk_02` FOREIGN KEY (`id_software_collegato`) REFERENCES `software` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202201170110
CREATE OR REPLACE VIEW relazioni_software_view AS
	SELECT
	relazioni_software.id_software,
	relazioni_software.id_software_collegato,
	concat( relazioni_software.id_software,' - ', relazioni_software.id_software_collegato) AS __label__
	FROM relazioni_software
	ORDER BY __label__
;

--| FINE FILE