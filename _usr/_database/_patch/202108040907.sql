ALTER TABLE `audio` ADD UNIQUE KEY `pagina_unico_embed` (`id_pagina`,`codice_embed`), ADD UNIQUE KEY `pagina_unico_path` (`id_pagina`,`path`);
