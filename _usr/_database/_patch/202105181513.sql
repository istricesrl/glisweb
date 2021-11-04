ALTER TABLE `todo_articoli`
 ADD PRIMARY KEY (`id`), ADD UNIQUE KEY `unico` (`id_todo`,`id_articolo`), ADD KEY `id_todo` (`id_todo`), ADD KEY `id_articolo` (`id_articolo`);