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
     * @todo come gestisco il caso "se il modulo è inviato dal sito italiano mando una mail a tizio, se dal sito in inglese a caio?"
     * @todo come gestisco il caso "se l'utente ha inserito nel modulo come lingua il xxx mando la mail a tizio, altrimenti la mando a caio?"
     * @todo come gestisco il caso "invio una mail all'admin in italiano e all'utente nella sua lingua?"
     *
     * @file
     *
     */

    // debug
	// die( print_r( $v, true ) );
	// print_r( $_REQUEST );

    // se esistono moduli __contatti__
	if( isset( $_REQUEST['__contatti__'] ) && is_array( $_REQUEST['__contatti__'] ) ) {

        // ciclo sui moduli __contatti__
        foreach( $_REQUEST['__contatti__'] as $k => &$v ) {

            // log
                logWrite( 'blocco contatti ricevuto per ' . $k, 'contatti' );

            // debug
                // print_r( $v );

            // integrazione dati
                $v['modulo'] = $k;

            // se esiste una configurazione specifica
                $cnf = ( isset( $cf['contatti'][ $k ] ) ) ? $cf['contatti'][ $k ] : $cf['contatti']['default'];

            // verifico se la configurazione prevede l'inclusione di una o più macro
                if( isset( $cnf['controller'] ) ) {

                    // log
                        logWrite( 'controller trovate per il blocco ' . $k . ': ' . implode(', ', $cnf['controller'] ), 'contatti' );

                    // includo le controller
                        foreach( $cnf['controller'] as $macro ) {
                            require DIR_BASE . $macro;
                        }

                }

            // debug
                // print_r( $cnf );

            // verifico se la configurazione prevede il salvataggio nel database
                if( isset( $cnf['backend'] ) ) {

                    // salvataggio del blocco dati nel database
                        $idCnt = mysqlQuery( $cf['mysql']['connection'], 'INSERT INTO contatti ( nome, json, timestamp_inserimento ) VALUES ( ?, ?, ? )',
                        array( array( 's' => $k ), array( 's' => json_encode( $v ) ), array( 's' => time() ) )
                        );

                    // TODO prevedere la possibilità di mappare campi del modulo su colonne del database anziché salvare tutto il mappazzone nel campo json

                }

                // registro i consensi
                if( isset( $_REQUEST['__consensi__']['__contatti__'][ $k ] ) ) {

                    // per ogni consenso...
                    foreach( $_REQUEST['__consensi__']['__contatti__'][ $k ] as $ck => $cv ) {

                        // timestamp del consenso
                        $timestamp = time();

                        // contenuto del consenso
                        $contenuto = 'il ' . date( 'd/m/Y', $timestamp ) . ' alle ' . date( 'H:i:s', $timestamp ) . ' è stato prestato il consenso per ' . $ck . ' tramite il modulo __contatti__.' . $k;

                        // se è stato salvato un contatto nel database
                        if( isset( $idCnt ) && ! empty( $idCnt ) ) {
                            $contenuto .= ' per il contatto #' . $idCnt;
                        }

                        // log
                        logWrite( $contenuto, 'privacy', LOG_CRIT );

                        // TODO salvare il consenso nella tabella contatti_consensi

                    }

                }

            // verifico se va registrata una hit di Analytics
                if( isset( $cnf['analytics'] ) ) {

                // registrazione della hit
                    if( isset( $cf['google']['analytics']['profile']['ua'] ) ) {
                        analyticsEventHit(
                            $cf['google']['analytics']['profile']['ua'],
                            $cnf['analytics']['categoria'],
                            $cnf['analytics']['azione'],
                            $cnf['analytics']['label']
                        );
                    }

                }

            // verifico se la configurazione prevede l'invio di una mail
                if( isset( $cnf['mail'] ) ) {

                    // ciclo per ogni email da mandare
                        foreach( $cnf['mail'] as $conf ) {

                            // debug
                                // print_r( $conf );

                            // log
                                logWrite( 'template mail trovato per il blocco ' . $k, 'contatti' );

                            // inizializzazioni
                                $key = $dst = NULL;

                            // lingua della mail
                                if( ! isset( $conf['language'] ) ) {
                                    if( isset( $v['ietf'] ) ) {
                                        $conf['language'] = $v['ietf'];
                                    } else {
                                        $conf['language'] = $cf['localization']['language']['ietf'];
                                    }
                                }

                            // retrocompatibilità per le configurazioni con template incorporato
                                if( is_array( $conf['template'] ) ) {
                                    $template = $conf['template'];
                                } else {
                                    $template = $cf['mail']['tpl'][ $conf['template'] ];
                                }

                            // filtro i dati che non devono essere passati al template
                                if( isset( $conf['exclude'] ) ) {
                                    $dati = array_diff_key( $v, array_combine( $conf['exclude'], $conf['exclude'] ) );
                                } else {
                                    $dati = $v;
                                }

                            // debug
                                // print_r( $template );

                            // accodamento
                                queueMailFromTemplate(
                                    $cf['mysql']['connection'],
                                    $template,
                                    array( 'dt' => $dati, 'ct' => $ct ),
                                    strtotime( '+1 minutes' ),
                                    $conf['destinatari'],
                                    $conf['language']
                                );

                        }

                }

            // esito dell’operazione
                $v['__status__'] = 'OK';

	    }

    }

    // scollego $v
	unset( $v );

    // debug
	// die();
	// print_r( $_REQUEST );
