ALTER TABLE `anagrafica_condizioni_pagamento`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unico` (`id_anagrafica`,`id_condizione`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_condizione` (`id_condizione`);