<?php

    /**
     * configurazione dinamica della localizzazione
     * 
     * in questo file vengono unite le informazioni sulla localizzazione presenti in $cf con quelle presenti sul database
     * 
     * introduzione
     * ============
     * 
     * 
     * 
     * $cf['localization']['index']
     * ----------------------------
     * Per le entità prelevate dal database, occorre spesso una tabella di trascodifica che consenta di risalire all'ID
     * dell'oggetto nel framework partendo dall'ID dello stesso oggetto nel database e viceversa. Per questo molte factory
     * del framework prevedono una chiave 'index' che svolge esattamente questo compito.
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     */

    // indice degli ID delle lingue
    $cf['localization']['index'] = array();

    // se ho una connessione al database
    if( ! empty( $cf['mysql']['connection'] ) ) {

        // ciclo sulle lingue
        foreach( $cf['localization']['languages'] as $k => $v ) {

            // recupero i dettagli sulla lingua dal database
            $c = mysqlSelectCachedRow(
                $cf['memcache']['connection'],
                $cf['mysql']['connection'],
                'SELECT * FROM lingue_view WHERE ietf = ?',
                array( array( 's' => $cf['localization']['languages'][ $k ]['ietf'] ) )
            );

            // se ho trovato la lingua nel database
            if( is_array( $c ) ) {

                // aggiorno i dettagli della lingua all'array delle lingue
                $cf['localization']['languages'][ $k ] = array_replace_recursive( $cf['localization']['languages'][ $k ], $c );

                // aggiorno l'indice delle lingue
                $cf['localization']['index'][ $c['id'] ] = $v['ietf'];

            }

        }

    }

    /*
     * TODO ha senso questa cosa, visto che poi più avanti $_SESSION viene azzerato?
     * TODO dov'è che viene usata $_SESSION['__view__']['__lang__'] e perché?
     * 
     * dov'è che viene azzerata la $_SESSION? la variabile $_SESSION['__view__']['__lang__']
     * arriva fino allo schema di gestione dei testi
     * 

    // linguaggio gestito di default
    if( empty( $_SESSION['__view__']['__lang__'] ) && ! empty( $cf['localization']['language']['id'] ) ) {
        $_SESSION['__view__']['__lang__'] = $cf['localization']['language']['id'];
        $_SESSION['__view__']['__ietf__'] = $cf['localization']['language']['ietf'];
    }

    */

    // debug
    // print_r( $cf['localization'] );
    // print_r( $cf['localization']['languages'] );
    // print_r( $cf['localization']['language'] );
    // echo 'OUTPUT';
    // die();
