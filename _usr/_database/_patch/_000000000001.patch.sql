
-- QUERY INIZIALI
-- questo file contiene le query tecniche per l'avvio del sistema di patch

--| 000000000001

ALTER TABLE `mysql_patch`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id` (`id`,`timestamp_esecuzione`) USING BTREE;

--| FINE FILE
