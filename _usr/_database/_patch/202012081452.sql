ALTER TABLE `menu` ADD PRIMARY KEY (`id`), ADD UNIQUE KEY `id_pagina_unico` (`id_pagina`,`id_lingua`,`menu`), ADD KEY `id_pagina` (`id_pagina`), ADD KEY `id_lingua` (`id_lingua`);
