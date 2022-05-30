--
-- PATCH
--

--| 202205300010
ALTER TABLE `prodotti`
CHANGE `id_tipologia` `id_tipologia` int(11) NULL AFTER `id`;


--| 202205300020
CREATE OR REPLACE VIEW relazioni_documenti_view AS
	SELECT
	relazioni_documenti.id,
	relazioni_documenti.id_documento,
	relazioni_documenti.id_documento_collegato,
	concat( relazioni_documenti.id_documento,' - ', relazioni_documenti.id_documento_collegato) AS __label__
	FROM relazioni_documenti
;

--| 202205300030
CREATE OR REPLACE VIEW relazioni_documenti_articoli_view AS
	SELECT
	relazioni_documenti_articoli.id,
	relazioni_documenti_articoli.id_documenti_articolo,
	relazioni_documenti_articoli.id_documenti_articolo_collegato,
	concat( relazioni_documenti_articoli.id_documenti_articolo,' - ', relazioni_documenti_articoli.id_documenti_articolo_collegato) AS __label__
	FROM relazioni_documenti_articoli
;

--| 202205300040
CREATE OR REPLACE VIEW relazioni_pagamenti_view AS
	SELECT
	relazioni_pagamenti.id,
	relazioni_pagamenti.id_pagamento,
	relazioni_pagamenti.id_pagamento_collegato,
	concat( relazioni_pagamenti.id_pagamento,' - ', relazioni_pagamenti.id_pagamento_collegato) AS __label__
	FROM relazioni_pagamenti
;

--| 202205300050
CREATE OR REPLACE VIEW relazioni_software_view AS
	SELECT
	relazioni_software.id,
	relazioni_software.id_software,
	relazioni_software.id_software_collegato,
	concat( relazioni_software.id_software,' - ', relazioni_software.id_software_collegato) AS __label__
	FROM relazioni_software
;
--| FINE