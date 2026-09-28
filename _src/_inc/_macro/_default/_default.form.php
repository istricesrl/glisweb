<?php

    /**
     *
     *
     *
     * TODO documentare
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
                $h1 = trim( mysqlSelectLabel( $cf['mysql']['connection'], $ct['form']['table'], getStaticViewExtension( $cf['memcache']['connection'], $cf['mysql']['connection'], $ct['form']['table'] ), $_REQUEST[ $ct['form']['table'] ]['id'] ) ?? '' );
                if( ! empty( $h1 ) ) {
                    $ct['page']['parents']['h1'][ max( array_keys( $ct['page']['parents']['h1'] ) ) ][ LINGUA_CORRENTE ] = $h1;
                }
            }

            /**
             * IL RITORNO A PIU' LIVELLI, COME SULLA LINEA VECCHIA ( portato il 2026-09-28 ).
             *
             * I quattro blocchi qui sotto sono gli stessi di _src/_inc/_macro/_default.form.php,
             * nello stesso ordine, e la spiegazione lunga di ciascuno sta li': qui se ne tiene solo
             * il perche' in una riga. Fino a oggi questa coppia registrava un solo backurl calcolato
             * sul genitore, senza catena, e non calcolava page.__sottooggetto__, che i template di
             * _tpl/_athena leggono gia' per scegliere fra dischetti e pallini.
             */

            // da una linguetta si torna alla scheda, non all'elenco ( fix 2026-09-14 )
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

            // si e' in un sotto-oggetto se il ritorno punta a un oggetto che non e' la scheda di questo record ( fix 2026-09-16 )
            $ct['page']['__sottooggetto__'] = false;

            if( ! empty( $_REQUEST['__backurl__'] ) ) {

                $urlRitorno = ( isset( $_SESSION['backurls'][ $_REQUEST['__backurl__'] ] ) )
                            ? preg_replace( '/[?&]__backurl__=[^&]*/', '', $_SESSION['backurls'][ $_REQUEST['__backurl__'] ] )
                            : '';

                $ct['page']['__sottooggetto__'] = ( strpos( $urlRitorno, '[id]=' ) !== false
                                                    && $urlRitorno !== $backSchedaUrl );

            }

            // l'indirizzo di ritorno di questa pagina, registrato DOPO le linguette perche' la catena non si fermi al primo gradino
            $backurl = $ct['page']['parents']['path'][ max( array_keys( $ct['page']['parents']['path'] ) ) ][ LINGUA_CORRENTE ] . '&' . $ct['form']['table'] . '[__method__]=get';
            $backmd5 = backurlRegistra( $backurl );
            $ct['page']['backurl'][ LINGUA_CORRENTE ] = $backmd5;

            // l'ultima briciola di pane si porta dietro anche il backurl ( fix 2026-09-14 )
            if( ! empty( $_REQUEST['__backurl__'] ) ) {
                $ct['page']['parents']['path'][ max( array_keys( $ct['page']['parents']['path'] ) ) ][ LINGUA_CORRENTE ] .= '&__backurl__=' . $_REQUEST['__backurl__'];
            }

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
                    'idx' => ( ( isset( $_REQUEST[ $ct['form']['table'] ]['metadati'] ) ) ? count( $_REQUEST[ $ct['form']['table'] ]['metadati'] ) : $sidx++ ),
                    'nome' => $metadato 
                );
        
                // ricerca metadato per sconto secondo corso
                if( isset( $_REQUEST[ $ct['form']['table'] ]['metadati'] ) ) {
                    foreach( $_REQUEST[ $ct['form']['table'] ]['metadati'] as $k => $m ) {
                        if( $m['nome'] == $metadato ) {
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
