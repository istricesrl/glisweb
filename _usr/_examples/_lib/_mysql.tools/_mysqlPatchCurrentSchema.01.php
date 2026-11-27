<?php

    /**
     * file di esempio per la funzione mysqlPatchCurrentSchema()
     *
     * Legge il livello del canone dichiarato in _etc/_current.schema: dodici cifre, o '000000000000' se il framework
     * non dichiara un canone.
     *
     * @file
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // livello del canone
    var_dump( mysqlPatchCurrentSchema( DIR_BASE ) );

    // una cartella senza _etc/_current.schema non dichiara un canone
    var_dump( mysqlPatchCurrentSchema( DIR_BASE . 'var/' ) );
