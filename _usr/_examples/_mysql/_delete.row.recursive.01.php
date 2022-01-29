<?php

    /**
     * test delle cache
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // inclusione del framework
	require '../../../_src/_config.php';

    // output
	echo '<pre style="font-family: monospace;">';
    echo 'esempio cancellazione ricorsiva' . PHP_EOL;

    /*

        CREATE TABLE `livello_uno` (
        `id` int(11) NOT NULL,
        `nome` char(32) NOT NULL
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

        CREATE TABLE `livello_due` (
        `id` int(11) NOT NULL,
        `id_uno` int(11) NOT NULL,
        `nome` char(32) NOT NULL
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

        CREATE TABLE `livello_tre` (
        `id` int(11) NOT NULL,
        `id_due` int(11) DEFAULT NULL,
        `nome` char(32) NOT NULL
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

        INSERT INTO `livello_uno` (`id`, `nome`) VALUES
        (1, 'prova uno / uno'),
        (2, 'prova uno / due');

        INSERT INTO `livello_due` (`id`, `id_uno`, `nome`) VALUES
        (1, 1, 'prova due / uno / uno'),
        (2, 1, 'prova due / due / uno'),
        (3, 2, 'prova due / uno / due'),
        (4, 2, 'prova due / due / due');

        INSERT INTO `livello_tre` (`id`, `id_due`, `nome`) VALUES
        (1, 1, 'prova tre / uno sticazzi'),
        (2, 1, 'altra prova'),
        (3, 2, 'record inutile'),
        (4, 2, 'record a caso'),
        (5, 3, 'record che resta null'),
        (6, 4, 'non so più cosa scrivere');

        ALTER TABLE `livello_due`
        ADD PRIMARY KEY (`id`),
        ADD KEY `id_uno` (`id_uno`);

        ALTER TABLE `livello_tre`
        ADD PRIMARY KEY (`id`),
        ADD KEY `id_due` (`id_due`);

        ALTER TABLE `livello_uno`
        ADD PRIMARY KEY (`id`);

        ALTER TABLE `livello_due`
        MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

        ALTER TABLE `livello_tre`
        MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

        ALTER TABLE `livello_uno`
        MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

        ALTER TABLE `livello_due`
        ADD CONSTRAINT `livello_due_ibfk_1` FOREIGN KEY (`id_uno`) REFERENCES `livello_uno` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

        ALTER TABLE `livello_tre`
        ADD CONSTRAINT `livello_tre_ibfk_1` FOREIGN KEY (`id_due`) REFERENCES `livello_due` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

    */

    // cancellazione
    mysqlDeleteRowRecursive(
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'livello_uno',
        2
    );

    // output
    echo '</pre>';
