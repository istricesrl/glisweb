CREATE OR REPLACE VIEW condizioni_pagamento_view AS
	SELECT condizioni_pagamento.*,
	condizioni_pagamento.nome AS __label__
	FROM condizioni_pagamento
	ORDER BY __label__;