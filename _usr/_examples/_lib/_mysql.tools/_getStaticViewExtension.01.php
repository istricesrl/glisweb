<?php

    /**
     * file di esempio per la funzione getStaticViewExtension()
     *
     * Crea nel database del deploy una tabella di prova e la sua statica, e mostra il suffisso nei tre stati che
     * contano: statica e tabella vuote, statica vuota accanto a una tabella con righe ( non ancora popolata: si legge
     * la vista ), statica popolata. Alla fine cancella tutte e due. Senza memcache, per non leggere esiti vecchi.
     *
     * @file
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // connessione e tabelle di prova
    $c = $cf['mysql']['connection'];
    $t = 'test_e2e_statica';
    mysqlQuery( $c, 'DROP TABLE IF EXISTS `' . $t . '`, `' . $t . '_view_static`' );
    mysqlQuery( $c, 'CREATE TABLE `' . $t . '` ( `id` bigint(20) PRIMARY KEY NOT NULL ) ENGINE=InnoDB DEFAULT CHARSET=utf8' );

    // senza statica
    echo 'senza statica: ' . '[' . getStaticViewExtension( NULL, $c, $t ) . ']' . PHP_EOL;

    // statica e tabella vuote
    mysqlQuery( $c, 'CREATE TABLE `' . $t . '_view_static` ( `id` bigint(20) PRIMARY KEY NOT NULL ) ENGINE=InnoDB DEFAULT CHARSET=utf8' );
    echo 'tutte e due vuote: ' . '[' . getStaticViewExtension( NULL, $c, $t ) . ']' . PHP_EOL;

    // statica vuota, tabella con righe
    mysqlQuery( $c, 'INSERT INTO `' . $t . '` ( id ) VALUES ( 1 )' );
    echo 'statica non popolata: ' . '[' . getStaticViewExtension( NULL, $c, $t ) . ']' . PHP_EOL;

    // statica popolata
    mysqlQuery( $c, 'INSERT INTO `' . $t . '_view_static` ( id ) VALUES ( 1 )' );
    echo 'statica popolata: ' . '[' . getStaticViewExtension( NULL, $c, $t ) . ']' . PHP_EOL;

    // pulizia
    mysqlQuery( $c, 'DROP TABLE IF EXISTS `' . $t . '`, `' . $t . '_view_static`' );
