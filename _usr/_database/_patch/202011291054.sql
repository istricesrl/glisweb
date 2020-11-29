DROP TABLE IF EXISTS `anagrafica_modalita_pagamento_view`;
CREATE OR REPLACE VIEW `anagrafica_modalita_pagamento_view` AS
	SELECT
	anagrafica_modalita_pagamento.*,
	anagrafica_modalita_pagamento.id AS __label__
	FROM anagrafica_modalita_pagamento
;