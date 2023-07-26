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
                $v['sito'] = $cf['site']['url'];

            // se esiste una configurazione specifica
                $cnf = ( isset( $cf['contatti'][ $k ] ) ) ? $cf['contatti'][ $k ] : $cf['contatti']['default'];

            // verifico la challenge reCAPTCHA
                if( isset( $v['__recaptcha_token__'] ) && isset( $cf['google']['profile']['recaptcha']['keys']['private'] ) ) {

                    // registro il valore di bot
                    $bot = reCaptchaVerifyV3( $v['__recaptcha_token__'], $cf['google']['profile']['recaptcha']['keys']['private'] );

                    // integrazione dei dati
                    $v['spam'] = $bot;

                    // pulisco il modulo
                    unset( $v['__recaptcha_token__'] );

                    // punteggio di spam
                    $spamCheck = ( $bot > 0.1 ) ? true : false;

                } elseif( ! isset( $v['__recaptcha_token__'] ) && isset( $cf['google']['profile']['recaptcha']['keys']['private'] ) ) {

                    // integrazione dei dati
                    $v['spam'] = 'token non ricevuto';

                    // punteggio di spam
                    $spamCheck = false;

                } else {

                    // integrazione dei dati
                    $v['spam'] = 'n/a';

                    // punteggio di spam
                    $spamCheck = true;

                }

            // verifico se è stato superato il check antispam
                if( $spamCheck == true ) {

                    // verifico se la configurazione prevede l'inclusione di una o più macro
                        if( isset( $cnf['controller'] ) ) {

                            // log
                                logWrite( 'controller trovate per il blocco ' . $k . ': ' . implode(', ', $cnf['controller'] ), 'contatti' );

                            // includo le controller
                                foreach( $cnf['controller'] as $macro ) {
                                    $macro = DIR_BASE . '_mod/_0300.contatti/_src/_inc/_macro/' . $macro;
                                    $macroLocal = path2custom( $macro );
                                    if( file_exists( $macroLocal ) ) {
                                        require $macroLocal;
                                    } elseif( file_exists( $macro ) ) {
                                        require $macro;
                                    }
                                }

                        }

                    // debug
                        // print_r( $cnf );

                    // verifico se la configurazione prevede il salvataggio nel database
                        if( isset( $cnf['backend'] ) ) {

                            // TODO
                            // if( isset( $_SESSION['utm'] ) && ! empty( $_SESSION['utm'][ $field ] ) ) { ... }

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

                                // TODO salvare i log della privacy in spool in modo che non vengano svuotati con gli altri log

                                // TODO salvare il consenso nella tabella contatti_consensi

                            }

                        }

                        // verifico se va registrata una hit di Analytics
                        if( isset( $cnf['analytics'] ) ) {

                        // registrazione della hit
                            if( isset( $cf['google']['profile']['analytics']['ua'] ) ) {
                                analyticsEventHit(
                                    $cf['google']['profile']['analytics']['ua'],
                                    $cnf['analytics']['categoria'],
                                    $cnf['analytics']['azione'],
                                    $cnf['analytics']['label']
                                );
                            }

                        }

                        // verifico se la configurazione prevede l'invio di un messaggio su Slack
                        if( isset( $cnf['slack']['webhook'] ) ) {

                            // TODO templatizzare i messaggi Slack come le mail

                            // composizione del messaggio
                            $m = 'nuovo modulo ricevuto: ' . $k . PHP_EOL;
                            foreach( array_diff_key( $_REQUEST['__contatti__'][ $k ], array( 'modulo' => NULL ) ) as $ks => $vs ) {
                                $m .= $ks . ': ' . $vs . PHP_EOL;
                            }

                            // invio del messaggio
                            slackTxtMsg(
                                $cf['slack']['profile']['webhooks'][ $cnf['slack']['webhook'] ],
                                $m
                            );

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

                                // TODO
                                    // verificare che il template sia ben formato, tipicamente verificare
                                    // che abbia il from settato (vedi dev/_mod/_0300.contatti/_src/_config/_500.mail.php)
                                    // altrimenti la queueMailFromTemplate() potrebbe comportarsi in modo erratico
                                    // nota questo controllo andrebbe comunque implementato anche nella queueMailFromTemplate()

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
