<?php

    /**
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
     * TODO qui documentare l'intera organizzazione della privacy nel framework
     *
     * TODO documentare
     *
     *
     */

    /**
     * integrazione dei consensi dal database
     * ======================================
     * 
     * 
     */

    // consensi dei moduli per la lingua corrente, col codice del consenso
    // NOTA consensi_moduli.id_consenso è l'id della riga di consensi, mentre i form e $cf['privacy']['moduli'][...]['consensi']
    // usano il codice ( PRIVACY_POLICY, ... ), per cui si passa da consensi; sui deploy di prima di marzo l'id è il codice, e
    // _202609301700.consensi.sql lo copia in consensi.codice
    $consensi = mysqlCachedQuery(
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT consensi_moduli.*, consensi.codice FROM consensi_moduli '.
        'INNER JOIN consensi ON consensi.id = consensi_moduli.id_consenso '.
        'WHERE consensi_moduli.id_lingua = ? '.
        'ORDER BY consensi_moduli.ordine, consensi_moduli.id',
        array( array( 's' => $cf['localization']['language']['id'] ) )
    );

    // debug
    // die( print_r( $consensi, true ) );
    // die( print_r( $cf['privacy']['moduli'], true ) );

    // aggiungo le richieste di consenso ai moduli
    // TODO questa cosa andrebbe 1) spostata negli specifici moduli (contatti, ecommerce, registrazione) inoltre
    // i consensi andrebbero inseriti direttamente sotto ogni modulo
    if( is_array( $consensi ) ) {
        foreach( $consensi as $consenso ) {

            // aggiungo la richiesta al modulo
            $cf['privacy']['moduli'][ $consenso['modulo'] ]['consensi'][ $consenso['codice'] ] = array(
                'informativa' => array( $cf['localization']['language']['ietf'] => $consenso['informativa'] ),
                'label' => array( $cf['localization']['language']['ietf'] => $consenso['nome'] ),
                'action' => $consenso['azione'],
                'page' => $consenso['pagina'],
                'required' => $consenso['se_richiesto'],
                'ordine' => $consenso['ordine']
            );
    
        }
    }

    // debug
    // die( print_r( $cf['privacy']['moduli'], true ) );
