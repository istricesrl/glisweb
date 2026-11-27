<?php

    /**
     * file di esempio per la funzione diskAddKeyAgeSuffix()
     *
     * aggiunge il suffisso _AGE alla chiave
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // definisco una chiave di test
    $v = 'TEST';

    // scrivo la chiave con il suffisso '_AGE'
    var_dump( diskAddKeyAgeSuffix( $v ) );
