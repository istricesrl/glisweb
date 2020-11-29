CREATE OR REPLACE VIEW `anagrafica_condizioni_pagamento_view` AS
	SELECT
	anagrafica_condizioni_pagamento.*,
	anagrafica_condizioni_pagamento.id AS __label__
	FROM anagrafica_condizioni_pagamento
;