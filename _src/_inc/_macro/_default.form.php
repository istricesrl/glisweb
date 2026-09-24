<?php

    /**
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // se ho una tabella
    if( ! empty( $ct['form']['table'] ) ) {

        // pagina di destinazione
        $ct['form']['action'] = ( isset( $ct['form']['action'] ) ) ? $ct['form']['action'] : $ct['page']['url'][ LINGUA_CORRENTE ];

        // metodo da utilizzare
        $ct['form']['method'] = ( isset( $ct['form']['method'] ) ) ? $ct['form']['method'] : ( ( empty( $_REQUEST[ $ct['form']['table'] ]['id'] ) ) ? 'post' : 'update' );

        // attività svolta
        $ct['form']['activity'] = ( isset( $ct['form']['activity'] ) ) ? $ct['form']['activity'] : ( ( empty( $_REQUEST[ $ct['form']['table'] ]['id'] ) ) ? 'inserimento' : 'aggiornamento' );

        // se è presente un id, sostituisco il titolo della pagina corrente con la __label__ dell'oggetto
        if( isset( $ct['form']['table'] ) && isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) && ! empty( $_REQUEST[ $ct['form']['table'] ]['id'] ) ) {
            $ct['page']['query'][ LINGUA_CORRENTE ] = '?' . $ct['form']['table'] . '[id]=' . $_REQUEST[ $ct['form']['table'] ]['id'];
            $ct['page']['parents']['path'][ max( array_keys( $ct['page']['parents']['path'] ) ) ][ LINGUA_CORRENTE ] .= $ct['page']['query'][ LINGUA_CORRENTE ];
            if( ! isset( $ct['form']['__filesystem_mode__'] ) ) {
                $ct['page']['parents']['h1'][ max( array_keys( $ct['page']['parents']['h1'] ) ) ][ LINGUA_CORRENTE ] = mysqlSelectLabel( $cf['mysql']['connection'], $ct['form']['table'], getStaticViewExtension( $cf['memcache']['connection'], $cf['mysql']['connection'], $ct['form']['table'] ), $_REQUEST[ $ct['form']['table'] ]['id'] );
            }
            /**
             * DA UNA LINGUETTA SI TORNA ALLA SCHEDA, NON ALL'ELENCO ( fix 2026-09-14 ).
             *
             * Segnalato da Montanari il 10/09/2026: "se sei dentro ad un preventivo e vuoi tornare
             * indietro al livello precedente, ti rimanda all'inizio della sezione dove sei entrato
             * ... e devi rifare diversi passaggi".
             *
             * Le linguette di una scheda ( righe, stampe, invio, strumenti, ... ) sono pagine a se'
             * e nell'albero hanno come genitore l'ELENCO, non la scheda: e' una scelta strutturale
             * e non si tocca, perche' in glisweb il percorso di una pagina E' la catena degli slug
             * dei suoi genitori ( _320.pages.php ), quindi cambiare il parent rinomina la pagina e
             * manda in 404 tutti i suoi indirizzi. Provato, il 14/09, e rimesso a posto.
             *
             * Quando pero' non c'e' nessun backurl, i pulsanti di ritorno ripiegano proprio sul
             * genitore, cioe' sull'elenco: da "righe del preventivo 12" si finiva sull'elenco di
             * tutti i preventivi, e per tornare alle righe servivano tre passaggi.
             *
             * Qui si registra in sessione il backurl che manca: la PRIMA linguetta della scheda,
             * con l'id del record. Non e' un parametro nuovo — e' la stessa convenzione
             * <tabella>[id] che la barra delle linguette usa gia' per i propri link — e non tocca
             * ne' l'albero delle pagine ne' gli indirizzi.
             *
             * Si scrive in $_REQUEST['__backurl__'] perche' e' quello che i template leggono
             * ( `request.__backurl__` ) e che la barra delle linguette propaga da sola passando da
             * una linguetta all'altra. Solo se non ce n'e' gia' uno: un backurl arrivato da chi ci
             * ha aperti descrive un percorso piu' preciso di questo e ha la precedenza.
             *
             * La prima linguetta e' esclusa: li' il livello precedente e' davvero l'elenco.
             */
            $backSchedaUrl = '';

            if( isset( $ct['page']['etc']['tabs'] )
                && is_array( $ct['page']['etc']['tabs'] )
                && count( $ct['page']['etc']['tabs'] ) > 1 ) {

                $primaLinguetta = reset( $ct['page']['etc']['tabs'] );

                if( $primaLinguetta != $ct['page']['id'] && ! empty( $ct['pages'][ $primaLinguetta ]['path'][ LINGUA_CORRENTE ] ) ) {

                    $backSchedaUrl = $ct['pages'][ $primaLinguetta ]['path'][ LINGUA_CORRENTE ]
                                   . '?' . $ct['form']['table'] . '[id]=' . $_REQUEST[ $ct['form']['table'] ]['id']
                                   . '&' . $ct['form']['table'] . '[__method__]=get';

                    if( empty( $_REQUEST['__backurl__'] ) ) {
                        $_REQUEST['__backurl__'] = backurlRegistra( $backSchedaUrl );
                    }

                }

            }

            /**
             * DISCHETTI O PALLINI: LA FORMA DELL'ICONA DICE A CHE LIVELLO SI E' ( fix 2026-09-16 ).
             *
             * Regola, da Fabio il 16/09/2026: se si arriva da una VISTA si e' al primo livello e si
             * vedono i DISCHETTI; se da dentro un oggetto se ne apre un altro — una sotto-vista, la
             * matitina o il piu' accanto a una tendina — si vedono i PALLINI, e la forma tonda e'
             * proprio il segnale che avvisa l'utente di essere dentro un sotto-oggetto.
             *
             * I template sceglievano la barra guardando `request.__backurl__`, che pero' vuol dire
             * un'altra cosa: "qualcuno mi ha aperto da qualche parte". Finche' il backurl ce
             * l'avevano solo i sotto-oggetti le due cose coincidevano; da quando il blocco qui
             * sopra lo INVENTA per le linguette ( fix Montanari del 14/09 ) non coincidono piu', e
             * ogni linguetta che non sia la prima ha perso i dischetti: segnalato da Sara Colciago
             * il 16/09 sulla sorgente delle pagine, "non compare piu' il tasto di salvataggio".
             * Una linguetta non e' un sotto-oggetto: e' lo stesso oggetto di primo livello.
             *
             * Si e' dentro un sotto-oggetto quando l'indirizzo di ritorno punta a un OGGETTO
             * ( contiene `[id]=` ) che non e' la scheda di questo stesso record. Un ritorno a una
             * vista non ha id, e quindi resta primo livello; il ritorno che le linguette si
             * inventano e' la scheda di se stessi, e quindi non conta.
             *
             * Va dopo il blocco delle linguette perche' quello e' chi il backurl lo inventa.
             */
            $ct['page']['__sottooggetto__'] = false;

            if( ! empty( $_REQUEST['__backurl__'] ) ) {

                $urlRitorno = ( isset( $_SESSION['backurls'][ $_REQUEST['__backurl__'] ] ) )
                            ? preg_replace( '/[?&]__backurl__=[^&]*/', '', $_SESSION['backurls'][ $_REQUEST['__backurl__'] ] )
                            : '';

                $ct['page']['__sottooggetto__'] = ( strpos( $urlRitorno, '[id]=' ) !== false
                                                    && $urlRitorno !== $backSchedaUrl );

            }

            /**
             * L'INDIRIZZO DI RITORNO DI QUESTA PAGINA
             *
             * Spostato qui sotto il blocco delle linguette il 15/09/2026, e non e' un riordino
             * estetico: quel blocco e' chi il `__backurl__` lo INVENTA quando non c'e', e
             * backurlRegistra() ci attacca il livello da cui si arriva. Registrando prima, il
             * cammino si fermava al primo gradino — che e' il difetto del punto 15.
             *
             * La spiegazione lunga sta su backurlRegistra(), in _src/_lib/_menu.utils.php.
             */
            $backurl = $ct['page']['parents']['path'][ max( array_keys( $ct['page']['parents']['path'] ) ) ][ LINGUA_CORRENTE ] . '&' . $ct['form']['table'] . '[__method__]=get';
            $backmd5 = backurlRegistra( $backurl );
            $ct['page']['backurl'][ LINGUA_CORRENTE ] = $backmd5;

            /**
             * L'ULTIMA BRICIOLA DI PANE SI PORTA DIETRO ANCHE IL BACKURL ( fix 2026-09-14 ).
             *
             * Segnalato da Montanari il 14/09/2026: "il torna indietro da una sotto-entita' a
             * volte non funziona". Il "a volte" e' questo.
             *
             * Le linguette di una scheda propagano il backurl da sole ( _navigation.html ), le
             * briciole di pane no: la riga qui sopra decora l'ultima briciola con il solo
             * `<tabella>[id]=<id>`, cioe' con l'indirizzo della pagina corrente ma senza il punto
             * da cui ci si e' arrivati. Cliccare la briciola della pagina in cui si e' gia' — cosa
             * che si fa per ricaricare, o tornando indietro col browser — ricarica quindi la stessa
             * scheda SENZA backurl, e da quel momento il pulsante di ritorno ripiega sul genitore:
             * dalla riga di un preventivo si finisce sull'elenco di tutti i preventivi invece che
             * sulle righe di quello aperto. Misurato il 14/09 sulla riga 50305 del preventivo 12733.
             *
             * Si decora SOLO l'ultima briciola, che e' la pagina corrente. Le briciole di sopra
             * sono un "sali di un livello" e un backurl li' riporterebbe l'utente in basso, cioe'
             * esattamente da dove e' appena salito.
             *
             * Va dopo il blocco qui sopra perche' e' quello che, sulle linguette, il backurl lo
             * inventa quando non c'e'; e va dopo il calcolo di $backurl / $backmd5, che descrivono
             * un'altra cosa ( l'indirizzo DI questa scheda, quello che le selectBox passano alle
             * schede che aprono ) e non vanno toccati.
             */
            if( ! empty( $_REQUEST['__backurl__'] ) ) {
                $ct['page']['parents']['path'][ max( array_keys( $ct['page']['parents']['path'] ) ) ][ LINGUA_CORRENTE ] .= '&__backurl__=' . $_REQUEST['__backurl__'];
            }
    #		echo 'backurl('.$backmd5.')='.$backurl;
    #	} elseif( isset( $ct['form']['table'] ) && ! empty( $ct['form']['table'] ) ) {
        } else {
            $ct['page']['__sottooggetto__'] = false;
            $backurl = $ct['page']['parents']['path'][ max( array_keys( $ct['page']['parents']['path'] ) ) ][ LINGUA_CORRENTE ];
            $backmd5 = backurlRegistra( $backurl );
            $ct['page']['backurl'][ LINGUA_CORRENTE ] = $backmd5;
            if( isset( $ct['form']['table'] ) ) {
                $ct['page']['etc']['tabs'] = array( $ct['page']['id'] );
            }
        }

        // timer
        timerCheck( $cf['speed'], '-> fine logiche di gestione di default' );

        // metadati
        if( isset( $ct['etc']['metadati'] ) ) {

            $sidx = time();

            foreach( $ct['etc']['metadati'] as $metadato => $dettagli ) {

                // metadato di default per sconto secondo corso
                $ct['etc']['sub'][ $metadato ] = array(
                    // 'idx' => ( ( isset( $_REQUEST[ $ct['form']['table'] ]['metadati'] ) ) ? count( $_REQUEST[ $ct['form']['table'] ]['metadati'] ) + 1 : $sidx++ ),
                    'idx' => $sidx++,
                    'nome' => $metadato 
                );
        
                // ricerca metadato per sconto secondo corso
                if( isset( $_REQUEST[ $ct['form']['table'] ]['metadati'] ) ) {
                    foreach( $_REQUEST[ $ct['form']['table'] ]['metadati'] as $k => $m ) {
                        if( isset( $m['nome'] ) && $m['nome'] == $metadato ) {
                            $ct['etc']['sub'][ $metadato ] = $m;
                            $ct['etc']['sub'][ $metadato ]['idx'] = $k;
                        }
                    }
                }
        
            }
        }

    }

    // timer
	timerCheck( $cf['speed'], '-> fine logiche di gestione metadati modulo' );

    // debug
	// print_r( $ct['page'] );
    // die( print_r( $ct['etc']['metadati'], true ) );
    // die( print_r( $ct['etc']['sub'], true ) );
