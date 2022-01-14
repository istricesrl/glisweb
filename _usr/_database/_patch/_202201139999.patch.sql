--
-- PATCH
--

--| 202201130005
CREATE TABLE IF NOT EXISTS `relazioni_documenti` (
`id` int(11) NOT NULL,
  `id_documento` int(11) DEFAULT NULL,
  `id_documento_collegato` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202201130010
ALTER TABLE `relazioni_documenti`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_documento` (`id_documento`),
	ADD KEY `id_documento_collegato` (`id_documento_collegato`),
	ADD UNIQUE KEY `unico` (`id_documento`,`id_documento_collegato`);

--| 202201130015
ALTER TABLE `relazioni_documenti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202201130020
ALTER TABLE `relazioni_documenti`
ADD CONSTRAINT `relazioni_documenti_ibfk_01` FOREIGN KEY (`id_documento`) REFERENCES `documenti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `relazioni_documenti_ibfk_02` FOREIGN KEY (`id_documento_collegato`) REFERENCES `documenti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202201130030
CREATE OR REPLACE VIEW relazioni_documenti_view AS
	SELECT
	relazioni_documenti.id_documento,
	relazioni_documenti.id_documento_collegato,
	concat( relazioni_documenti.id_documento,' - ', relazioni_documenti.id_documento_collegato) AS __label__
	FROM relazioni_documenti
	ORDER BY __label__
;

--| 202201130040
CREATE TABLE IF NOT EXISTS `relazioni_documenti_articoli` (
`id` int(11) NOT NULL,
  `id_documenti_articolo` int(11) DEFAULT NULL,
  `id_documenti_articolo_collegato` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202201130050
ALTER TABLE `relazioni_documenti_articoli`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_documenti_articolo` (`id_documenti_articolo`),
	ADD KEY `id_documenti_articolo_collegato` (`id_documenti_articolo_collegato`),
	ADD UNIQUE KEY `unico` (`id_documenti_articolo`,`id_documenti_articolo_collegato`);

--| 202201130055
ALTER TABLE `relazioni_documenti_articoli` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202201130060
ALTER TABLE `relazioni_documenti_articoli`
ADD CONSTRAINT `relazioni_documenti_articoli_ibfk_01` FOREIGN KEY (`id_documenti_articolo`) REFERENCES `documenti_articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `relazioni_documenti_articoli_ibfk_02` FOREIGN KEY (`id_documenti_articolo_collegato`) REFERENCES `documenti_articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202201130070
CREATE OR REPLACE VIEW relazioni_documenti_articoli_view AS
	SELECT
	relazioni_documenti_articoli.id_documenti_articolo,
	relazioni_documenti_articoli.id_documenti_articolo_collegato,
	concat( relazioni_documenti_articoli.id_documenti_articolo,' - ', relazioni_documenti_articoli.id_documenti_articolo_collegato) AS __label__
	FROM relazioni_documenti_articoli
	ORDER BY __label__
;

--| 202201130080
CREATE TABLE IF NOT EXISTS `relazioni_pagamenti` (
`id` int(11) NOT NULL,
  `id_pagamento` int(11) DEFAULT NULL,
  `id_pagamento_collegato` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202201130090
ALTER TABLE `relazioni_pagamenti`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_pagamento` (`id_pagamento`),
	ADD KEY `id_pagamento_collegato` (`id_pagamento_collegato`),
	ADD UNIQUE KEY `unico` (`id_pagamento`,`id_pagamento_collegato`);

--| 202201130095
ALTER TABLE `relazioni_pagamenti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202201130100
ALTER TABLE `relazioni_pagamenti`
ADD CONSTRAINT `relazioni_pagamenti_ibfk_01` FOREIGN KEY (`id_pagamento`) REFERENCES `pagamenti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `relazioni_pagamenti_ibfk_02` FOREIGN KEY (`id_pagamento_collegato`) REFERENCES `pagamenti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202201130110
CREATE OR REPLACE VIEW relazioni_pagamenti_view AS
	SELECT
	relazioni_pagamenti.id_pagamento,
	relazioni_pagamenti.id_pagamento_collegato,
	concat( relazioni_pagamenti.id_pagamento,' - ', relazioni_pagamenti.id_pagamento_collegato) AS __label__
	FROM relazioni_pagamenti
	ORDER BY __label__
;

--| FINE FILE
