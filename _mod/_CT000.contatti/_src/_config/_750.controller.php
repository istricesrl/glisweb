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
     * TODO come gestisco il caso "se il modulo è inviato dal sito italiano mando una mail a tizio, se dal sito in inglese a caio?"
     * TODO come gestisco il caso "se l'utente ha inserito nel modulo come lingua il xxx mando la mail a tizio, altrimenti la mando a caio?"
     * TODO come gestisco il caso "invio una mail all'admin in italiano e all'utente nella sua lingua?"
     *
     * TODO documentare
     *
     */

    // debug
	// print_r( $_REQUEST );

    /**
     * ciclo principale di gestione dei moduli contatti
     * ================================================
     * 
     * 
     * 
     */

    // se esistono moduli __ct__
	if( isset( $_REQUEST['__ct__'] ) && is_array( $_REQUEST['__ct__'] ) ) {

        // ciclo sui moduli __ct__
        foreach( $_REQUEST['__ct__'] as $k => &$v ) {

            // se il modulo è definito
            if( isset( $cf['contatti'][ $k ] ) ) {

                // log
                logger( 'blocco contatti ricevuto per ' . $k, 'contatti' );

                // verifica anti spam
                reCaptchaVerifyFormV3( $v, $cf['google']['profile']['recaptcha']['keys']['private'] ?? false );

                // se lo spam test è superato
                if( $v['__spam__']['check'] == true ) {

                    // integrazione dati
                    $v['__modulo__'] = $k;
                    $v['__sito__']['id'] = $cf['site']['id'];
                    $v['__sito__']['url'] = $cf['site']['url'];
                    $v['__sito__']['label'] = $cf['site']['__label__'];
                    $v['__timestamp_contatto__'] = time();
                    $v['__status__'] = 'OK';

                    // salvo la riga sulla tabella contatti
                    $v['__id_contatto__'] = mysqlInsertRow(
                        $cf['mysql']['connection'],
                        array(
                            'id_tipologia' => 4,
                            'id_sito' => $v['__sito__']['id'],
                            'utm_id' => $cf['session']['utm']['utm_id'] ?? NULL,
                            'utm_source' => $cf['session']['utm']['utm_source'] ?? NULL,
                            'utm_medium' => $cf['session']['utm']['utm_medium'] ?? NULL,
                            'utm_campaign' => $cf['session']['utm']['utm_campaign'] ?? NULL,
                            'utm_term' => $cf['session']['utm']['utm_term'] ?? NULL,
                            'utm_content' => $cf['session']['utm']['utm_content'] ?? NULL,
                            'nome' => 'contatto ricevuto da form web il ' . date( 'd/m/Y H:i:s', time() ),
                            'modulo' => $v['__modulo__'],
                            'yaml' => yaml_emit( $v ),
                            'timestamp_contatto' => $v['__timestamp_contatto__'],
                            'timestamp_inserimento' => time(),
                        ),
                        'contatti'
                    );

                    // attivo la controller del modulo se è specificata
                    if( isset( $cf['contatti'][ $k ]['controller'] ) ) {

                        // se esiste la controller custom
                        if( file_exists( path2custom( DIR_BASE . $cf['contatti'][ $k ]['controller'] ) ) ) {

                            // la includo
                            require path2custom( DIR_BASE . $cf['contatti'][ $k ]['controller'] );

                            // log
                            logger( 'inclusa controller custom per modulo contatti ' . $k . ': ' . path2custom( DIR_BASE . $cf['contatti'][ $k ]['controller'] ), 'contatti' );

                        } elseif( file_exists( DIR_BASE . $cf['contatti'][ $k ]['controller'] ) ) {

                            // la includo
                            require DIR_BASE . $cf['contatti'][ $k ]['controller'];

                            // log
                            logger( 'inclusa controller standard per modulo contatti ' . $k . ': ' . DIR_BASE . $cf['contatti'][ $k ]['controller'], 'contatti' );

                        } else {

                            // log
                            logger( 'controller per modulo contatti ' . $k . ' specificata ma non trovata: ' . DIR_BASE . $cf['contatti'][ $k ]['controller'], 'contatti', LOG_ERR );

                        }

                    } else {

                        // log
                        logger( 'nessuna controller specificata per modulo contatti ' . $k, 'contatti' );

                    }

                } else {

                    // integrazione dati
                    $v['__status__'] = 'SPAM';

                    // log
                    logger( 'blocco contatti identificato come SPAM (' . $v['__spam__']['score'] . ') per modulo ' . $k, 'contatti', LOG_WARNING );

                }

                // debug
                // print_r( $v );

            } else {

                // log
                logger( 'blocco contatti ricevuto per modulo NON DEFINITO ' . $k, 'contatti', LOG_ERR );

            }

        }
        
    }

    // debug
    // print_r( $_REQUEST );
