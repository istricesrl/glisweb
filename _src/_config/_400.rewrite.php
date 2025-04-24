<?php

    /**
     * estrazione della pagina corrente dall'URL
     *
     * introduzione
     * ============
     * Il framework è in grado di individuare la pagina corrente richiesta dall'utente tramite
     * HTTP interpretando l'URL corrente, come si è già accennato in _300.pages.php. Vediamo
     * ora nel dettaglio questo meccanismo e vediamo come può essere esteso dai moduli per
     * creare pagine "virtuali" corrispondenti ad esempio a criteri di ricerca.
     *
     * meccanismo base
     * ---------------
     * In questo file, fatti salvi alcuni casi limite, i vari componenti del percorso vengono
     * prelevati dall'array $_REQUEST['__rp__'] e analizzati per capire se fanno parte
     * dell'albero dei contenuti. Si ricordi che l'array $_REQUEST['__rp__'] può essere ottenuto
     * dal parametro $_REQUEST['__rw__'] se la richiesta viene fatta tramite l'API _pages.php.
     *
     * Per fare questo, la stringa prelevata dall'URL viene confrontata con l'indice delle
     * pagine presente in $cf['contents']['index'] tenendo conto della lingua corrente; per
     * gestire gli inevitabili casi di omonimia la ricerca nell'indice viene integrata con un
     * controllo sul genitore, fatto tramite l'array $cf['contents']['pages']; se il controllo
     * sul genitore è positivo, allora il frammento di URL è identificato e si passa al
     * successivo, finché tutti non sono stati identificati o finché non se ne incontra uno
     * che è impossibile identificare.
     *
     * In questo modo l'ultimo frammento identificato è la pagina corrente, oppure se non
     * è possibile completare l'identificazione la pagina corrente rimane "not found"; questo
     * è molto importante in quanto se non è stato possibile identificare la pagina tramite
     * il ciclo principale allora entrano in gioco i cicli specifici dei moduli, che possono
     * tentare un'identificazione basata su criteri diversi (vedi più avanti).
     *
     * richiesta esplicita di una pagina
     * ---------------------------------
     *
     *
     *
     *
     *
     *
     * accesso implicito alla home page
     * --------------------------------
     *
     *
     *
     *
     *
     *
     * estensione del meccanismo di analisi dell'URL
     * ---------------------------------------------
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
     *
     *
     *
     *
     * one-char parameter debug
     * ========================
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
     * TODO partire dalla pagina di errore 404 anziché da NULL, in modo che se nessuna pagina viene trovata si finisce sulla 404
     * TODO nell'implementare la partenza dalla pagina 404 tenere presente le pagine di gestione degli errori da .htaccess perché i due meccanismi si devono integrare
     * TODO documentare
     *
     *
     */

    // debug
    // print_r( $cf['localization']['language'] );
    // print_r( $cf['contents']['shortcuts'] );
    // var_dump( $_SERVER['REQUEST_URI'] );
    // print_r( $cf['site']['home'] );
    // print_r( array_keys( $cf['contents']['pages'] ) );

    // default
    $cf['parser']['parent']     = NULL;
    $cf['parser']['page']       = NULL;
    $cf['parser']['lingua']     = $cf['localization']['language']['ietf'];

    /*
     * @todo perché si parte dalla pagina NULL? il default dovrebbe essere la 404, se uno cerca una
     * pagina che non esiste è corretto che approdi sulla pagina "non trovato"; oppure vogliamo rendere
     * la pagina NULL "non trovato"?
     */

    /**
     * NOTA
     * la possibilità di specificare p consente di simulare una pagina su un'altra a fini di test
     * 
     */

    // forzatura della pagina corrente per one-char parameter debug
    if( isset( $_REQUEST['p'] ) && ! empty( isset( $_REQUEST['p'] ) ) ) {
        $_REQUEST['__pg__'] = $_REQUEST['p'];
    }

    // verifico se la pagina corrente è indicata esplicitamente tramite $_REQUEST['__pg__']
    if( empty( $_REQUEST['__pg__'] ) ) {

        /*
         * TODO il meccanismo delle shortcut non è obsoleto o comunque ridondante rispetto ai redirect?
         * è possibile unire i due meccanismi?
         */

        // log
        logger( 'nessuna pagina richiesta esplicitamente', 'rewrite' );

        // verifico se la pagina corrente non è una shortcut
        if( ! array_key_exists( strtok( $_SERVER['REQUEST_URI'], '?' ), $cf['contents']['shortcuts'] ) ) {

            // verifico che la pagina corrente non sia già settata
            if( empty( $cf['contents']['page'] ) && ! empty( $_SERVER['REDIRECT_URL'] ) ) {

                // controllo che la lingua sia settata
                if( ! empty( LINGUA_CORRENTE ) ) {

                    // log
                    logger( 'parsing di: ' . $_SERVER['REDIRECT_URL'], 'rewrite' );

                    // verifico se l'URL contiene dei nomi di pagina
                    if( isset( $_REQUEST['__rp__'] ) && is_array( $_REQUEST['__rp__'] ) && count( $_REQUEST['__rp__'] ) > 0 ) {

                        // pulisco l'array degli step dalle cartelle del path base
                        $_REQUEST['__rp__'] = array_diff( $_REQUEST['__rp__'], explode( '/', $cf['site']['root'] ) );

                        // scorro gli elementi pagina trovati nell'URL
                        foreach( $_REQUEST['__rp__'] as $cf['parser']['step'] ) {

                            // se la pagina non viene trovata, devo restituire un errore 404
                            // TODO questa cosa non è implementata
                            $cf['parser']['page'] = NULL;

                            // log
                            logger( 'cerco: ' . $cf['parser']['step'], 'rewrite' );

                            // verifico se l'elemento corrente è presente nell'indice delle pagine rewritate
                            if( array_key_exists( $cf['parser']['step'], $cf['contents']['index'][ LINGUA_CORRENTE ] ) ) {

                                // esamino le pagine presenti nell'indice per vedere se ce n'e' una che ha lo stesso genitore di quella corrente
                                foreach( $cf['contents']['index'][ LINGUA_CORRENTE ][ $cf['parser']['step'] ] as $cf['parser']['candidate'] ) {

                                    // se la pagina attualmente controllata ha lo stesso id genitore della pagina step, allora e' lei
                                    if(
                                        $cf['contents']['pages'][ $cf['parser']['candidate'] ]['parent']['id'] == $cf['parser']['parent'] 
                                        ||
                                        empty( $cf['contents']['pages'][ $cf['parser']['candidate'] ]['parent']['title'][ $cf['parser']['lingua'] ] )
                                    ) {

                                        // la pagina trovata diventa la nuova pagina corrente
                                        $cf['parser']['page'] = $cf['parser']['candidate'];

                                        // scendo di un livello nell'analisi dell'albero: la pagina trovata diventa il nuovo genitore
                                        $cf['parser']['parent'] = $cf['parser']['candidate'];

                                    }

                                }

                            } else {

                                // log
                                logger( $cf['parser']['step'] . ' non trovato in contents/index/' . LINGUA_CORRENTE, 'rewrite' );

                            }

                        }

                    } else {

                        // se non è stata trovata alcuna pagina, torno a NULL
                        $cf['parser']['page'] = NULL;

                        // log
                        logger( 'nessuna pagina ricavata da URL' , 'rewrite' );

                    }

                } else {

                    // se non è stata trovata alcuna pagina, torno a NULL
                    $cf['parser']['page'] = NULL;

                    // log
                    logger( 'impossibile fare il parsing di URL senza lingua impostata', 'rewrite' );

                }

            } elseif( in_array( $cf['site']['home'], array_keys( $cf['contents']['pages'] ) ) ) {

                // se non è stata richiesta nessuna pagina in particolare, allora vuol dire che sono nella home page
                $cf['parser']['page'] = $cf['site']['home'];

                // log
                logger( 'accesso implicito alla home page', 'rewrite' );

            } else {

                // se non è stata trovata alcuna pagina, torno a NULL
                // TODO vedi sopra per il discorso NULL/404
                $cf['parser']['page'] = NULL;

                // log
                logger( 'nessuna pagina trovata', 'rewrite' );

            }

        } else {

            // se la pagina corrente è una shortcut
            $cf['parser']['page'] = $cf['contents']['shortcuts'][ strtok( $_SERVER['REQUEST_URI'], '?' ) ];

            // log
            logger( 'pagina richiesta tramite shortcut: ' . $cf['parser']['page'], 'rewrite' );

        }

    } else {

        // se e' stata richiesta espressamente una pagina, utilizzo quella
        $cf['parser']['page'] = $_REQUEST['__pg__'];

        // log
        logger( 'pagina richiesta esplicitamente: ' . $cf['parser']['page'], 'rewrite' );

    }

    // debug
    // print_r( $cf['contents']['index'] );
