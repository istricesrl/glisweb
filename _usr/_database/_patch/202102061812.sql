ALTER TABLE `pubblicazione` ADD `id_categoria_prodotti` INT NULL DEFAULT NULL AFTER `id_pagina`, ADD INDEX (`id_categoria_prodotti`) ;
