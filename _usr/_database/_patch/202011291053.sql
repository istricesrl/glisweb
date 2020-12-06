ALTER TABLE `anagrafica_modalita_pagamento`
ADD CONSTRAINT `anagrafica_modalita_pagamento_ibfk_2` FOREIGN KEY (`id_modalita`) REFERENCES `modalita_pagamento` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `anagrafica_modalita_pagamento_ibfk_1` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;