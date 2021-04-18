--| 000000000001

ALTER TABLE `mysql_patch`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id` (`id`,`timestamp_esecuzione`) USING BTREE;

--| FINE FILE
