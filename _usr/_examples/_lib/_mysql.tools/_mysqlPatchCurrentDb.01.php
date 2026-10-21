<?php

    /**
     * file di esempio per la funzione mysqlPatchCurrentDb()
     *
     * Legge il livello del canone dichiarato in _etc/_current.db: dodici cifre, o '000000000000' se il framework
     * non dichiara un canone.
     *
     * @file
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // livello del canone
    var_dump( mysqlPatchCurrentDb( DIR_BASE ) );

    // una cartella senza _etc/_current.db non dichiara un canone
    var_dump( mysqlPatchCurrentDb( DIR_BASE . 'var/' ) );
