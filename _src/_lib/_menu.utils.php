<?php

    /**
     * libreria per la costruzione dei menu e degli elementi di navigazione
     * 
     * Questa libreria contiene le funzioni che costruiscono, a partire dall'albero delle pagine, i menu, le briciole di
     * pane, il selettore della lingua e gli indirizzi di ritorno delle pagine.
     * 
     * introduzione
     * ============
     * Le pagine del sito sono dichiarate in $cf['contents']['pages'] e organizzate in un albero in $cf['contents']['tree'],
     * costruiti dai runlevel _src/_config/_300.pages.php e _src/_config/_320.pages.php; ogni pagina può comparire in uno o
     * più menu tramite la chiave menu, e conosce il proprio percorso dalla radice nella chiave parents. L'API delle
     * pagine _src/_api/_pages.php, prima di passare la pagina al template, chiama buildMenu() per ogni menu dichiarato dal
     * template, buildBreadcrumbs() per le briciole di pane e buildFlags() per il selettore della lingua, e mette il
     * risultato in $ct['page']['template']. backurlRegistra() è invece usata dalle macro di default delle viste e dei form
     * del back-end (_src/_inc/_macro/_default.view.php e _src/_inc/_macro/_default.form.php) per costruire la freccia di
     * ritorno.
     * 
     * costanti
     * ========
     * Questa libreria non definisce costanti; buildMenu() usa SHOW_ALWAYS, definita in _src/_config.php.
     * 
     * funzioni
     * ========
     * Le funzioni di questa libreria sono divise in gruppi in base al lavoro che svolgono; nei paragrafi successivi le analizzeremo nel dettaglio.
     * 
     * funzioni per i menu
     * -------------------
     * Le funzioni in questo gruppo servono per costruire i menu del sito.
     * 
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * menuLocation()                   | sceglie, per ogni lingua, dove porta una voce di menu
     * buildMenu()                      | costruisce un menu a partire dall'albero delle pagine
     * 
     * funzioni per gli altri elementi di navigazione
     * ----------------------------------------------
     * Le funzioni in questo gruppo servono per costruire gli elementi di navigazione diversi dai menu.
     * 
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * buildBreadcrumbs()               | costruisce le briciole di pane di una pagina
     * buildFlags()                     | costruisce le voci del selettore della lingua di una pagina
     * backurlRegistra()                | registra l'indirizzo di ritorno di questa pagina, e ci attacca quello da cui si arriva
     * 
     * dipendenze
     * ==========
     * Questa libreria ha alcune dipendenze che devono essere soddisfatte per funzionare correttamente. In particolare
     * sono richieste le seguenti funzioni:
     * 
     * funzione                         | libreria di appartenenza
     * ---------------------------------|---------------------------------------------------------------
     * logWrite()                       | _src/_lib/_log.utils.php
     * 
     * changelog
     * =========
     * Questa sezione riporta la storia delle modifiche più significative apportate alla libreria.
     *
     * data             | autore               | descrizione
     * -----------------|----------------------|---------------------------------------------------------------
     * 2026-09-24       | Fabio Mosti          | documentazione
     * 
     * licenza
     * =======
     * Questa libreria fa parte del progetto GlisWeb (https://github.com/istricesrl/glisweb) ed è distribuita
     * sotto licenza Open Source. Fare riferimento alla pagina GitHub del progetto per i dettagli.
     * 
     */

    /**
     * FUNZIONI PER I MENU
     */

    /**
     * sceglie, per ogni lingua, dove porta una voce di menu
     *
     * Una pagina con 'forced' valorizzato punta fuori dal sito, e la voce deve usare l'URL
     * dichiarato invece del percorso interno. Ma 'forced' e' un array PER LINGUA come 'title' e
     * 'rewrited': puo' esserci in italiano e non in inglese. Percio' la scelta si fa lingua per
     * lingua, e le lingue senza 'forced' continuano a usare il proprio percorso interno.
     *
     * @param   array       $pagina     la definizione della pagina
     *
     * @return  array                   percorsi o URL, per lingua
     *
     */
    function menuLocation( $pagina ) {

        $location = ( isset( $pagina['path'] ) ) ? (array) $pagina['path'] : array();

        if( empty( $pagina['forced'] ) ) {
            return $location;
        }

        foreach( (array) $pagina['forced'] as $lk => $url ) {

            if( ! empty( $url ) ) {
                $location[ $lk ] = $url;
            }

        }

        return $location;

    }

    /**
     * costruisce un menu a partire dall'albero delle pagine
     * 
     * Questa funzione percorre un livello dell'albero delle pagine e restituisce le voci del menu $menu per quel livello,
     * scendendo ricorsivamente nei sottolivelli quando serve. Una pagina può avere più voci nello stesso menu
     * ($pages[ $k ]['menu'][ $menu ] è un array di voci), e ogni voce viene inclusa se:
     * 
     * - ha un'etichetta, oppure la pagina ha figli e fa parte del percorso della pagina attiva (sono le voci vuote che
     *   _src/_config/_320.pages.php crea nei genitori per annidarvi le sottovoci);
     * - l'utente può vederla, cioè la pagina non ha gruppi in auth.groups, oppure l'utente appartiene ad almeno uno di
     *   quei gruppi, oppure la voce ha visualizza uguale a SHOW_ALWAYS.
     * 
     * Ogni voce è un array con le chiavi label, ancora, location (per lingua, calcolata con menuLocation()), target,
     * active (la pagina è quella attiva), current (la pagina fa parte del percorso della pagina attiva) e, se c'è un
     * sottomenu, content. Il sottomenu viene costruito se la pagina ha figli e, o fa parte del percorso della pagina
     * attiva e la voce non ha subpages uguale a 'NEVER_SHOW', o la voce ha subpages uguale a 'ALWAYS_SHOW'. Le voci
     * sono ordinate in modo naturale per chiave, e la chiave è priority|id della pagina|indice della voce, per cui
     * l'ordine è dato dalla priorità e a parità di priorità dall'id. Se $tree non è un array la funzione restituisce un
     * array vuoto; tutti i passaggi vengono scritti nel log menu.
     * 
     * Se $active è NULL (il default), o è una pagina che non esiste in $pages o non ha il percorso in parents.id, nessuna
     * voce risulta nel percorso della pagina attiva: vengono incluse solo le voci con etichetta, nessuna è current e i
     * sottomenu vengono costruiti solo per le voci con subpages uguale a 'ALWAYS_SHOW'.
     *
     * NB: fino al 2026-09-24 in quel caso in_array() riceveva NULL e PHP andava in errore alla prima voce inclusa.
     *
     * @param       string      $menu       il nome del menu da costruire
     * @param       array       $tree       il livello dell'albero delle pagine da elaborare, nella forma id => figli
     * @param       array       $pages      le pagine del sito, di solito $cf['contents']['pages']
     * @param       string      $active     l'id della pagina attiva (default NULL)
     * 
     * @return      array                   le voci del menu, ordinate
     * 
     */
    function buildMenu( $menu, $tree, $pages, $active = NULL ) {

    // debug
        // echo print_r( $pages, true );
        // echo print_r( $tree, true );
        // echo 'menu -> ' . $menu . PHP_EOL;

    // array del menu
        $nav = array();

    // percorso della pagina attiva ( vuoto se la pagina attiva non è data o non è nota )
        $path = ( isset( $pages[ $active ]['parents']['id'] ) ) ? (array) $pages[ $active ]['parents']['id'] : array();

    // log
        logWrite( 'elaboro il menu ' . $menu, 'menu' );

    // verifico che il livello richiesto dell'albero sia popolato
        if( is_array( $tree ) ) {

        // log
            logWrite( 'voci da elaborare per il menu ' . $menu . ': ' . count( $tree ), 'menu' );

        // costruisco le voci di menù per questo livello
            foreach( $tree as $k => $v ) {

            // log
                logWrite( 'elaboro la pagina ' . $k . ' per il menu ' . $menu, 'menu' );

            // debug
                // echo 'page -> ' . $k . PHP_EOL;
                // echo print_r( $pages[ $k ], true );

            // se la pagina compare nel menu...
                if( isset( $pages[ $k ]['menu'][ $menu ] ) ) {

foreach( $pages[ $k ]['menu'][ $menu ] as $ak => $mv ) {

                // se la pagina ha un'etichetta per il menu... oppure?
                    if( ! empty( $mv['label'] ) || ( count( $v ) > 0 && in_array( $k, $path ) ) ) {

                    // se l'utente può visualizzare la pagina
                    // TODO trovare un modo per visualizzare nel menu con un'opzione anche le pagine per cui è richiesto poi il login
                    // TODO if( getPagePermission( $k ) )
                        if( ! isset( $pages[ $k ]['auth']['groups'] ) || ( isset( $_SESSION['account']['gruppi'] ) && count( array_intersect( $pages[ $k ]['auth']['groups'], $_SESSION['account']['gruppi'] ) ) > 0 ) || ( isset( $mv['visualizza'] ) && $mv['visualizza'] == SHOW_ALWAYS ) ) {

                        // debug
                            // echo print_r( $mv, true );
                            // echo print_r( $mv['label'], true );
                            // echo $k . '/' . $active . PHP_EOL;
                            // print_r( $pages[ $k ]['parents']['id'] );
                            // echo  $k . '/' . $mv['priority'] . PHP_EOL;
                            // print_r( $pages[ $k ]['url'] );

                        // costruisco la chiave per l'ordinamento
                            $key = ( $mv['priority'] ?? 0 ) . '|' . $k . '|' . $ak;

                        // log
                            if( empty( $mv['label'] ) ) {
                            logWrite( 'voce vuota: ' . $k . ' -> ' . $menu . ': ' . $key, 'menu', LOG_ERR );
                            }

                        // costruisco la voce corrente
                        $nav[ $key ] = array(
                            'label' => $mv['label']
                            ,
                            'ancora' => ( isset( $mv['ancora'] ) ) ? $mv['ancora'] : NULL
                            ,
                            // la scelta fra URL forzato e percorso interno si fa PER LINGUA: una
                            // pagina puo' avere 'forced' in italiano e non in inglese, e prima la
                            // decisione era per pagina, quindi le lingue senza 'forced' finivano a
                            // prendere l'URL assoluto invece del percorso relativo
                            'location' => menuLocation( $pages[ $k ] )
                            ,
                            'target' => ( ( isset( $mv['target'] ) && ! empty( $mv['target'] ) ) ? $mv['target'] : NULL ) 
                            ,
                            'active' => ( $k == $active ) ? true : false
                            ,
                            'current' => ( in_array( $k, $path ) ) ? true : false
                            );

                        // log
                            logWrite( $k . ' -> ' . $menu . ': ' . $key, 'menu' );

                        // debug
                            // echo $mv['subpages'] . PHP_EOL;

                        // contenuto del sottomenù
                            if(
                            count( $v ) > 0
                            && (
                                (
                                in_array( $k, $path )
                                && (
                                    ! isset( $mv['subpages'] )
                                    ||
                                    $mv['subpages'] != 'NEVER_SHOW'
                                )
                                )
                                ||
                                (
                                isset( $mv['subpages'] )
                                &&
                                $mv['subpages'] == 'ALWAYS_SHOW'
                                )
                            )
                            ) {
                            logWrite( 'vado in ricorsione per ' . $k . ' -> ' . $menu, 'menu' );
                            $nav[ $key ]['content'] = buildMenu( $menu, $v, $pages, $active );
                            }

                        } else {

                        // log
                            logWrite( 'permessi insufficienti per visualizzare la pagina ' . $k . ' nel menu ' . $menu, 'menu' );

                        }

                    } else {

                    // log
                        logWrite( 'la pagina ' . $k . ' non ha label nel menu ' . $menu . ' e non fa parte del path della pagina attiva', 'menu' );

                    }

                }

                } else {

                // log
                    logWrite( 'la pagina ' . $k . ' non appartiene al menu ' . $menu, 'menu' );

                }

            }

        } else {

        // log
            logWrite( 'albero malformato (non è un array)', 'menu' );

        }

    // riordino l'array
        ksort( $nav, SORT_NATURAL );

    // debug
        // print_r( $nav );

    // restituisco il risultato
        return $nav;

    }

    /**
     * FUNZIONI PER GLI ALTRI ELEMENTI DI NAVIGAZIONE
     */

    /**
     * costruisce le briciole di pane di una pagina
     * 
     * Questa funzione restituisce una voce per ogni pagina del percorso dalla radice alla pagina data, compresa la pagina
     * stessa, leggendo gli array paralleli id, path e h1 della chiave parents della pagina; la radice (id vuoto) viene
     * saltata. Ogni voce è un array con le chiavi location (il percorso della pagina, per lingua), label (l'h1 della
     * pagina) e active (true per la pagina $active). Se la pagina non ha l'array parents restituisce un array vuoto.
     * 
     * @param       array       $page       la pagina di cui costruire le briciole di pane
     * @param       string      $active     l'id della pagina attiva
     * 
     * @return      array                   le briciole di pane, dalla radice alla pagina
     * 
     */
    function buildBreadcrumbs( $page, $active ) {

    // array del menu
        $nav = array();

    // verifico che la pagina possieda un array dei parents
        if( is_array( $page['parents'] ) ) {

        // costruisco le briciole di pane
            foreach( $page['parents']['id'] as $k => $v ) {

            // se la pagina non è la radice
                if( ! empty( $v ) ) {

                // costruisco la briciola
                    $nav[] = array(
                    'location' => $page['parents']['path'][ $k ],
                    'label' => $page['parents']['h1'][ $k ],
                    'active' => ( $v == $active ) ? true : false
                    );

                }

            }

        }

    // restituisco il risultato
        return $nav;

    }

    /**
     * costruisce le voci del selettore della lingua di una pagina
     * 
     * Questa funzione restituisce una voce per ogni lingua in cui la pagina ha un percorso (chiave path, indicizzata per
     * codice IETF come it-IT); ogni voce è un array con le chiavi location (il percorso della pagina in quella lingua),
     * country (la parte del codice dopo il trattino, in minuscolo, da usare per la bandiera) e active (true per la
     * lingua $lang). Se la pagina non ha l'array path restituisce un array vuoto e scrive nel log localization.
     * 
     * Se il codice della lingua non contiene il trattino ("it") country è il codice intero, in minuscolo.
     *
     * NB: fino al 2026-09-24 in quel caso strpos() restituiva false e country diventava il codice senza il primo
     * carattere ("it" diventava "t").
     *
     * @param       array       $page       la pagina di cui costruire il selettore della lingua
     * @param       string      $lang       il codice IETF della lingua corrente
     * 
     * @return      array                   le voci del selettore della lingua
     * 
     */
    function buildFlags( $page, $lang ) {

    // array del menu
        $nav = array();

    // verifico che la pagina possieda un array dei parents
        if( isset( $page['path'] ) && is_array( $page['path'] ) ) {

        // costruisco le bandiere per la selezione della lingua
            foreach( $page['path'] as $k => $v ) {

            // costruisco la bandiera
                $nav[] = array(
                'location' => $page['path'][ $k ],
                'country' => strtolower( ( strpos( $k, '-' ) !== false ) ? substr( $k, strpos( $k, '-' ) + 1 ) : $k ),
                'active' => ( $k == $lang ) ? true : false
                );

            }

        // log
            logWrite( 'generate ' . count( $nav ) . ' bandiere per il cambio lingua', 'localization' );

        } else {

        // log
            logWrite( 'impossibile generare le bandiere per il cambio lingua', 'localization' );

        }

    // restituisco il risultato
        return $nav;

    }

    /**
     * registra l'indirizzo di ritorno di questa pagina, e ci attacca quello da cui si arriva
     *
     * IL RITORNO A PIU' LIVELLI, ovvero come mai fino al 14/09/2026 il "torna indietro" ne teneva
     * uno solo.
     *
     * Il meccanismo del framework: ogni pagina registra in `$_SESSION['backurls']` il PROPRIO
     * indirizzo sotto un token md5, e passa quel token a chi apre ( `__backurl__` nella URL ). Chi
     * riceve il token disegna la freccia di ritorno verso `backurls[ token ]`. Funziona, ma di un
     * livello solo: l'indirizzo che si registra e' la pagina NUDA, senza il `__backurl__` che la
     * pagina stessa aveva ricevuto. Tornando indietro ci si ritrova quindi su una pagina senza
     * ritorno, e da li' la freccia ripiega sul genitore — che e' esattamente la segnalazione di
     * Montanari: *"ti rimanda all'inizio della sezione dove sei entrato e devi rifare diversi
     * passaggi"*.
     *
     * La correzione e' registrare l'indirizzo CON il proprio `__backurl__` attaccato. Da li' in poi
     * il cammino si srotola da solo, un livello per click, fino in cima.
     *
     * PERCHE' NON UNA PILA. La strada ovvia sarebbe stata un array in sessione con push e pop. E'
     * peggio, per tre motivi che si pagano subito:
     *
     *  - una pila e' UNA SOLA per sessione, e il back-end si usa con piu' schede aperte. Due schede
     *    su due preventivi diversi si pesterebbero i piedi a ogni click;
     *  - il pulsante "indietro" del browser e i preferiti non toccano la pila, che resterebbe ferma
     *    a descrivere un cammino che l'utente non sta piu' facendo;
     *  - una pila va svuotata, e non esiste un momento buono per farlo. Una cronologia che non si
     *    svuota mai riporta l'utente in posti che non esistono piu'.
     *
     * Il cammino invece vive nelle URL, che e' dove l'utente lo sta gia' costruendo: ogni scheda
     * aperta ha il suo, il tasto indietro del browser lo rispetta, e non c'e' niente da svuotare.
     * La sessione resta quello che era, una cache di indirizzi.
     *
     * DUE GUARDIE, ed entrambe servono:
     *
     *  - non si annida una pagina dentro se stessa. Le linguette di una scheda si passano il
     *    backurl a vicenda e la briciola di pane dell'ultimo livello rimanda alla pagina corrente:
     *    senza questa guardia la freccia rimbalzerebbe fra due pagine invece di salire;
     *  - la mappa degli indirizzi non ha mai avuto un limite e cresceva per tutta la sessione. Con i
     *    cammini annidati i token sono piu' d'uno per pagina, quindi adesso se ne tiene solo la coda.
     *    Perdere un token vecchio non rompe niente: quella freccia ripiega sul genitore, cioe' torna
     *    a comportarsi come prima del 14/09.
     *
     * @param   string      $url        l'indirizzo di questa pagina, gia' completo dei suoi parametri
     *
     * @return  string                  il token md5 con cui la pagina si fa richiamare
     *
     */
    function backurlRegistra( $url ) {

        global $cf;

    // quanti indirizzi si tengono in sessione
        $massimi = ( isset( $cf['navigation']['backurls']['massimi'] ) ) ? (int) $cf['navigation']['backurls']['massimi'] : 200;

    // il livello da cui si arriva, se c'e' e se non e' gia' attaccato
        if( ! empty( $_REQUEST['__backurl__'] )
            && isset( $_SESSION['backurls'][ $_REQUEST['__backurl__'] ] )
            && strpos( $url, '__backurl__=' ) === false ) {

        // l'indirizzo del livello precedente, senza il suo di ritorno
            $precedente = preg_replace( '/[?&]__backurl__=[^&]*/', '', $_SESSION['backurls'][ $_REQUEST['__backurl__'] ] );

        // non si annida una pagina dentro se stessa
            if( $precedente !== $url ) {
                $url .= ( ( strpos( $url, '?' ) === false ) ? '?' : '&' ) . '__backurl__=' . $_REQUEST['__backurl__'];
            }

        }

    // registro
        $token = md5( $url );
        $_SESSION['backurls'][ $token ] = $url;

    // poto la coda
        if( count( $_SESSION['backurls'] ) > $massimi ) {
            $_SESSION['backurls'] = array_slice( $_SESSION['backurls'], - $massimi, NULL, true );
        }

    // restituisco il risultato
        return $token;

    }
