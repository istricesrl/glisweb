--
-- PATCH
--

--| 202112230010
ALTER TABLE `__acl_anagrafica__` CHANGE `id_gruppo` `id_gruppo` int NULL AFTER `id_entita`,
ADD UNIQUE KEY `unica_account` (`id_entita`,`id_account`);

--| 202112230020
ALTER TABLE `__acl_attivita__` CHANGE `id_gruppo` `id_gruppo` int NULL AFTER `id_entita`,
ADD UNIQUE KEY `unica_account` (`id_entita`,`id_account`);

--| 202112230030
ALTER TABLE `__acl_pagine__` CHANGE `id_gruppo` `id_gruppo` int NULL AFTER `id_entita`,
ADD UNIQUE KEY `unica_account` (`id_entita`,`id_account`);

--| FINE FILE
