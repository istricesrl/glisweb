ALTER TABLE `anagrafica_modalita_pagamento`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unico` (`id_anagrafica`,`id_modalita`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), ADD KEY `id_modalita` (`id_modalita`);
