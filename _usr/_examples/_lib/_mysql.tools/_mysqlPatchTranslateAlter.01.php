<?php

    /**
     * file di esempio per la funzione mysqlPatchTranslateAlter()
     *
     * Usa il database del deploy in sola lettura: traduce per MySQL tre ALTER con MODIFY / CHANGE COLUMN IF EXISTS, su una
     * colonna che c'è ( la clausola resta senza IF ) e su una che non c'è ( la clausola si toglie, con la nota ). Non
     * esegue niente.
     *
     * @file
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // connessione del deploy
    $c = $cf['mysql']['connection'];

    // colonna che c'è
    $n = array();
    var_dump( mysqlPatchTranslateAlter( $c, 'ALTER TABLE `account` MODIFY COLUMN IF EXISTS `username` char(255) DEFAULT NULL;', $n ) );
    var_dump( mysqlPatchTranslateAlter( $c, 'ALTER TABLE `account` CHANGE IF EXISTS `username` `username` char(255) DEFAULT NULL;', $n ) );

    // colonna che non c'è
    var_dump( mysqlPatchTranslateAlter( $c, 'ALTER TABLE `account` MODIFY IF EXISTS `colonna_inesistente` int(11) DEFAULT NULL;', $n ) );

    // note
    echo implode( PHP_EOL, $n ) . PHP_EOL;
