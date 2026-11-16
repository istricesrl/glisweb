<?php

    /**
     * file di esempio per la funzione fillStaticViews()
     *
     * Crea nel database del deploy una tabella di prova con cinque righe, la sua vista e la sua statica vuota, più una
     * statica orfana senza tabella base, e mostra l'esito della popolazione a lotti di due righe: la prima popolata
     * con tutte e cinque le righe, la seconda saltata col suo motivo. Alla fine cancella tutto.
     *
     * @file
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // connessione e tabelle di prova
    $c = $cf['mysql']['connection'];
    $t = 'test_e2e_statica';
    $o = 'test_e2e_orfana';

    // pulizia preventiva
    mysqlQuery( $c, 'DROP VIEW IF EXISTS `' . $t . '_view`' );
    mysqlQuery( $c, 'DROP TABLE IF EXISTS `' . $t . '`, `' . $t . '_view_static`, `' . $o . '_view_static`' );

    // tabella, vista e statica vuota
    mysqlQuery( $c, 'CREATE TABLE `' . $t . '` ( `id` bigint(20) PRIMARY KEY NOT NULL, `nome` char(32) DEFAULT NULL ) ENGINE=InnoDB DEFAULT CHARSET=utf8' );
    mysqlQuery( $c, 'CREATE VIEW `' . $t . '_view` AS SELECT id, nome FROM `' . $t . '`' );
    mysqlQuery( $c, 'CREATE TABLE `' . $t . '_view_static` ( `id` bigint(20) PRIMARY KEY NOT NULL, `nome` char(32) DEFAULT NULL ) ENGINE=InnoDB DEFAULT CHARSET=utf8' );
    mysqlQuery( $c, 'INSERT INTO `' . $t . '` ( id, nome ) VALUES ( 1, "uno" ), ( 2, "due" ), ( 3, "tre" ), ( 4, "quattro" ), ( 5, "cinque" )' );

    // statica senza tabella base
    mysqlQuery( $c, 'CREATE TABLE `' . $o . '_view_static` ( `id` bigint(20) PRIMARY KEY NOT NULL ) ENGINE=InnoDB DEFAULT CHARSET=utf8' );

    // popolazione a lotti di due righe, solo delle statiche di prova
    $r = fillStaticViews( $c, 2, array( $t, $o ) );

    echo 'popolata: ' . $t . '_view_static ' . ( isset( $r['popolate'][ $t . '_view_static' ] ) ? $r['popolate'][ $t . '_view_static' ] : 'no' ) . ' righe' . PHP_EOL;
    echo 'saltata: ' . $o . '_view_static ' . ( isset( $r['saltate'][ $o . '_view_static' ] ) ? $r['saltate'][ $o . '_view_static' ] : 'no' ) . PHP_EOL;
    echo 'errori: ' . count( $r['errori'] ) . PHP_EOL;

    // una statica con righe non si tocca
    $r = fillStaticViews( $c, 2, array( $t, $o ) );
    echo 'secondo giro popolate: ' . count( $r['popolate'] ) . PHP_EOL;

    // pulizia
    mysqlQuery( $c, 'DROP VIEW IF EXISTS `' . $t . '_view`' );
    mysqlQuery( $c, 'DROP TABLE IF EXISTS `' . $t . '`, `' . $t . '_view_static`, `' . $o . '_view_static`' );
