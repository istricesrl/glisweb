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

--| 202112230040
ALTER TABLE `contenuti`
ADD `mittente_numero` char(128) COLLATE 'utf8_general_ci' NULL AFTER `mittente_nome`,
ADD `destinatario_numero` char(128) COLLATE 'utf8_general_ci' NULL AFTER `destinatario_nome`;

--| FINE FILE
