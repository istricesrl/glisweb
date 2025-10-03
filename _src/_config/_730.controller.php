<?php

    /**
     * inclusione dei parser di pagina
     * 
     * 
     * introduzione
     * ============
     * 
     * 
     * 
     * 
     * esempi di utilizzo
     * ------------------
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * TODO documentare
     * 
     */

    /**
     * inclusione dei parser di pagina
     * ===============================
     * 
     * 
     * 
     */

    // ...
    if( isset( $ct['page']['parser'] ) ) {

        // ...
        foreach( $ct['page']['parser'] as $parser ) {

            // TODO includere la versione custom se esiste
            require $parser;

        }

    }

    /**
     * debug del runlevel
     * ==================
     * 
     * 
     */

    // print_r( $ct['page']);
