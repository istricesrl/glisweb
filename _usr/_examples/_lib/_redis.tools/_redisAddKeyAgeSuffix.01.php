<?php

    /**
     * file di esempio per la funzione openFile()
     * 
     * 
     * 
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // definisco una chiave di test
    $v = 'TEST';

    // scrivo la chiave con il suffisso '_AGE'
    var_dump( redisAddKeyAgeSuffix( $v ) );
