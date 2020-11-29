ALTER TABLE `anagrafica_condizioni_pagamento`
ADD CONSTRAINT `anagrafica_condizioni_pagamento_ibfk_2` FOREIGN KEY (`id_condizione`) REFERENCES `condizioni_pagamento` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `anagrafica_condizioni_pagamento_ibfk_1` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;