<?php

    /**
     * API della struttura per glisweb-cli
     *
     * restituisce in JSON, per l'utente autenticato, l'account e l'albero del menu di amministrazione
     * con le pagine che l'utente puo' vedere; si chiama con l'header gliswebAuthKey ottenuto da api/login
     *
     * va installata come _src/_api/_cli.php: la regola generica dell'.htaccess la serve su api/cli
     *
     * TODO aggiungere per ogni pagina schede ( etc.tabs ), template.schema e macro della vista
     *
     */

    // inclusione del framework
    if( ! defined( 'INCLUDE_SUBDIR' ) ) {
        require '../_config.php';
    } else {
        require INCLUDE_SUBDIR . '_config.php';
    }

    // costruisce l'albero completo del menu, con gli stessi filtri di buildMenu() ma senza fermarsi al percorso attivo
    function cliMenu( $menu, $tree, $pages ) {

        // ...
        $nav = array();

        // ...
        foreach( (array) $tree as $k => $v ) {

            // la pagina non sta in questo menu
            if( ! isset( $pages[ $k ]['menu'][ $menu ] ) ) {
                continue;
            }

            // stessi controlli di permesso di buildMenu()
            $permesso = ! isset( $pages[ $k ]['auth']['groups'] )
                || ( isset( $_SESSION['account']['gruppi'] ) && count( array_intersect( $pages[ $k ]['auth']['groups'], $_SESSION['account']['gruppi'] ) ) > 0 );

            // ...
            foreach( $pages[ $k ]['menu'][ $menu ] as $mv ) {

                // le voci senza etichetta non si mostrano, ma i figli si
                $figli = ( is_array( $v ) && count( $v ) > 0 ) ? cliMenu( $menu, $v, $pages ) : array();

                if( ! $permesso && ! ( isset( $mv['visualizza'] ) && $mv['visualizza'] == SHOW_ALWAYS ) ) {
                    continue;
                }

                if( empty( $mv['label'] ) && empty( $figli ) ) {
                    continue;
                }

                $nav[] = array(
                    'id'       => $k,
                    'label'    => $mv['label'] ?? NULL,
                    'priority' => $mv['priority'] ?? 0,
                    'title'    => $pages[ $k ]['title'] ?? NULL,
                    'location' => menuLocation( $pages[ $k ] ),
                    'schema'   => $pages[ $k ]['template']['schema'] ?? NULL,
                    'content'  => $figli
                );

            }

        }

        // ordine per priorita', come nel menu web
        usort( $nav, function( $a, $b ) { return strnatcmp( (string) $a['priority'], (string) $b['priority'] ); } );

        // ...
        return $nav;

    }

    // richiesta del client, in POST JSON ( vedi sotto )
    $cliInput = json_decode( (string) file_get_contents( 'php://input' ), true );

    // la chiave di api/login vale un'ora dall'ultimo uso, non dal login: a ogni chiamata autenticata si riscrive
    // su Redis con un'ora piena, cosi' la sessione scade solo dopo un'ora di inattivita' vera del client
    // NOTA stesso formato e stesso prefisso di _210.auth.php, che la legge
    if( isset( $_SESSION['account']['username'] ) && isset( $httpHeaders['gliswebAuthKey'] )
        && preg_match( '/^[0-9a-f]{32}$/', $httpHeaders['gliswebAuthKey'] ) && ! empty( $cf['redis']['connection'] ) ) {
        redisWrite( $cf['redis']['connection'], 'apikey.' . $httpHeaders['gliswebAuthKey'], $_SESSION['account']['username'], 3600 );
    }

    // senza login non si risponde; buildJson() non termina lo script, quindi le risposte stanno in rami alternativi
    if( ! isset( $_SESSION['account']['username'] ) ) {

        // risposta
        http_response_code( 401 );
        $reply = array( 'err' => 'login richiesto', 'status' => 'KO' );

    } elseif( ! empty( $cliInput['rinnova'] ) ) {

        // solo per tenere viva la chiave mentre si lavora: niente menu, risposta corta
        $reply = array( 'status' => 'OK', 'rinnovato' => true );

    } else {

        // risposta, con l'account filtrato come in _user.php
        $reply = array(
            'status'  => 'OK',
            'version' => ( file_exists( DIR_BASE . '_etc/_current.version' ) ) ? trim( file_get_contents( DIR_BASE . '_etc/_current.version' ) ) : NULL,
            'account' => array_diff_key( $_SESSION['account'], array( 'permissions' => '', 'privilegi' => '', 'password' => '' ) ),
            'menu'    => array( 'admin' => cliMenu( 'admin', $cf['contents']['tree'][ NULL ], $cf['contents']['pages'] ) )
        );

    }

    // richiesta di una pagina: POST JSON {"pagina": "<id>", "__view__": {...}}, per un form anche
    // "record": {"tabella": "<entita'>", "id": <id>} ( senza id: form vuoto, d'inserimento ) e, per salvare,
    // "salva": {"<campo>": "<valore>", ...} con i campi del form, come li manda il form web; "elimina": true
    // cancella il record ( con l'id di "record" )
    if( $reply['status'] === 'OK' && empty( $cliInput['rinnova'] ) && ! empty( $cliInput['pagina'] ) ) {
        $reply = cliPagina( (string) $cliInput['pagina'], $cliInput['__view__'] ?? array(), $cliInput['record'] ?? array(), $cliInput['salva'] ?? NULL, ! empty( $cliInput['elimina'] ) );
    }

    // ricerca per le tendine con 'source': {'api': '<tabella>'} ( comune, agente... ), come la combobox del form
    // web: "cerca": {"tabella": "comuni", "q": "bol"} da' le voci col testo nell'etichetta, {"tabella": ..., "id": 5}
    // l'etichetta di un id gia' scelto
    if( $reply['status'] === 'OK' && empty( $cliInput['rinnova'] ) && ! empty( $cliInput['cerca'] ) ) {
        $reply = cliCerca( (array) $cliInput['cerca'] );
    }

    // output
    buildJson( $reply );

    /**
     * cerca in <tabella>_view per id o per testo nell'__label__; il nome della tabella si ripulisce e la vista
     * deve esistere, cosi' da qui si legge solo una vista del framework, mai una query qualsiasi
     */
    function cliCerca( $c ) {

        global $cf;

        $t = preg_replace( '/[^a-z0-9_]/', '', (string) ( $c['tabella'] ?? '' ) );
        $vista = $t . '_view';
        $esiste = ( $t === '' ) ? 0 : mysqlSelectValue( $cf['mysql']['connection'],
            'SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ?',
            array( array( 's' => $vista ) ) );
        if( empty( $esiste ) ) {
            return array( 'status' => 'KO', 'err' => 'nessuna vista per ' . $t );
        }

        if( isset( $c['id'] ) ) {
            $voci = mysqlQuery( $cf['mysql']['connection'],
                'SELECT id, __label__ FROM ' . $vista . ' WHERE id = ?', array( array( 's' => (int) $c['id'] ) ) );
        } else {
            $q = trim( (string) ( $c['q'] ?? '' ) );
            if( mb_strlen( $q ) < 2 ) {
                return array( 'status' => 'KO', 'err' => 'servono almeno due caratteri' );
            }
            $voci = mysqlQuery( $cf['mysql']['connection'],
                'SELECT id, __label__ FROM ' . $vista . ' WHERE __label__ LIKE ? ORDER BY __label__ NOT LIKE ?, __label__ LIMIT 30',
                array( array( 's' => '%' . $q . '%' ), array( 's' => $q . '%' ) ) );
        }

        return array( 'status' => 'OK', 'cerca' => array( 'tabella' => $t, 'voci' => ( is_array( $voci ) ) ? $voci : array() ) );

    }

    /**
     * esegue le macro di una pagina vista e ne restituisce le righe, come le prepara _default.view.php;
     * per un form ( *.form.twig ) legge prima il record con controller() in GET, come fa _750.controller.php
     * con ?<tabella>[id]=<id>&<tabella>[__method__]=get, e restituisce record, tendine e schede
     *
     * con $salva il record si scrive prima con controller() in UPDATE, come per il POST di un form web
     * ( <tabella>[__method__]=update ): l'INSERT ... ON DUPLICATE KEY UPDATE aggiorna solo i campi mandati,
     * senza id inserisce; dopo la scrittura controller() rilegge il record, e il form torna gia' aggiornato
     *
     * con $elimina il record si cancella con controller() in DELETE ( le sottotabelle seguono le chiavi
     * esterne del database ), e il form torna vuoto
     *
     * i tools restano fuori
     */
    function cliPagina( $id, $view, $record = array(), $salva = NULL, $elimina = false ) {

        // namespace globale: le macro lavorano su questi
        global $cf, $ct;

        // la pagina deve esistere e l'utente deve poterla vedere
        if( ! isset( $cf['contents']['pages'][ $id ] ) ) {
            http_response_code( 404 );
            return array( 'status' => 'KO', 'err' => 'pagina inesistente' );
        }
        if( getPagePermission( $id ) !== true ) {
            http_response_code( 403 );
            return array( 'status' => 'KO', 'err' => 'permessi insufficienti' );
        }

        // solo viste e form
        $schema = $cf['contents']['pages'][ $id ]['template']['schema'] ?? '';
        $form = ( substr( $schema, -10 ) === '.form.twig' || strpos( $schema, '.form.' ) !== false );
        if( substr( $schema, -10 ) !== '.view.twig' && ! $form ) {
            return array( 'status' => 'KO', 'err' => 'schema non ancora gestito', 'schema' => $schema );
        }

        // form: il record si legge prima delle macro, che lo trovano in $_REQUEST[ <tabella> ] come nel web
        $tabella = ( $form && ! empty( $record['tabella'] ) ) ? preg_replace( '/[^a-z0-9_]/', '', (string) $record['tabella'] ) : NULL;
        $errRecord = array();
        $esito = $eliminato = NULL;
        if( $tabella !== NULL && $elimina && ! empty( $record['id'] ) ) {
            $_REQUEST[ $tabella ] = array( 'id' => (int) $record['id'] );
            $infoRecord = $pi = $ci = array();
            $eliminato = controller( $cf['mysql']['connection'], $cf['memcache']['connection'], $_REQUEST[ $tabella ], $tabella,
                METHOD_DELETE, NULL, $errRecord, $infoRecord, $pi, $ci, $cf['speed'] );
        } elseif( $tabella !== NULL && is_array( $salva ) ) {
            // i campi speciali ( __firma__, __table__... ) non passano da qui; una sottotabella ( "mail": [ {riga}, ... ] )
            // passa riga per riga coi soli valori semplici, e controller() la scrive in ricorsione dopo il padre,
            // con "__parent_id__" al posto dell'id del padre come nel form web
            $_REQUEST[ $tabella ] = array();
            foreach( $salva as $k => $vv ) {
                if( substr( (string) $k, 0, 2 ) === '__' ) {
                    continue;
                }
                if( is_array( $vv ) ) {
                    $sub = preg_replace( '/[^a-z0-9_]/', '', (string) $k );
                    $righe = array();
                    foreach( $vv as $riga ) {
                        $r = array();
                        foreach( ( is_array( $riga ) ? $riga : array() ) as $rk => $rv ) {
                            if( substr( (string) $rk, 0, 2 ) !== '__' && ! is_array( $rv ) ) {
                                $r[ $rk ] = $rv;
                            }
                        }
                        if( $r ) {
                            $righe[] = $r;
                        }
                    }
                    if( $sub !== '' && $righe ) {
                        $_REQUEST[ $tabella ][ $sub ] = $righe;
                    }
                } else {
                    $_REQUEST[ $tabella ][ $k ] = $vv;
                }
            }
            if( ! empty( $record['id'] ) ) {
                $_REQUEST[ $tabella ]['id'] = (int) $record['id'];
            }
            $infoRecord = $pi = $ci = array();
            $esito = controller( $cf['mysql']['connection'], $cf['memcache']['connection'], $_REQUEST[ $tabella ], $tabella,
                METHOD_UPDATE, NULL, $errRecord, $infoRecord, $pi, $ci, $cf['speed'] );
            // righe di sottotabella da togliere: "__elimina__": {"mail": [ <id>, ... ]}; solo quelle del record
            // ( id_<tabella> = id del record ), cosi' da qui non si cancella una riga di un altro
            if( ! empty( $record['id'] ) && ! empty( $salva['__elimina__'] ) && is_array( $salva['__elimina__'] ) ) {
                foreach( $salva['__elimina__'] as $sub => $ids ) {
                    $sub = preg_replace( '/[^a-z0-9_]/', '', (string) $sub );
                    foreach( (array) $ids as $sid ) {
                        $tuo = mysqlSelectValue( $cf['mysql']['connection'],
                            'SELECT id FROM ' . $sub . ' WHERE id = ? AND id_' . $tabella . ' = ?',
                            array( array( 's' => (int) $sid ), array( 's' => (int) $record['id'] ) ) );
                        if( empty( $tuo ) ) {
                            $errRecord['__elimina__'][ $sub ][ (int) $sid ] = 'riga non del record';
                            continue;
                        }
                        $rr = array( 'id' => (int) $sid );
                        $er = $ir = $p2 = $c2 = array();
                        $x = controller( $cf['mysql']['connection'], $cf['memcache']['connection'], $rr, $sub,
                            METHOD_DELETE, NULL, $er, $ir, $p2, $c2, $cf['speed'] );
                        if( ! ( is_int( $x ) && $x >= 200 && $x < 300 ) ) {
                            $errRecord['__elimina__'][ $sub ][ (int) $sid ] = $x;
                        }
                    }
                }
                // la vista statica del padre si e' aggiornata quando e' stato scritto, prima di queste cancellazioni:
                // senza riallinearla un flag calcolato dalle righe tolte resta ( p.es. se_cliente da una categoria
                // tolta, che lascia la scheda cliente fra le schede ); se la statica non c'e' non fa niente
                refreshStaticView( $cf['mysql']['connection'], $tabella, (int) $record['id'] );
                // il record in $_REQUEST e' quello riletto dall'UPDATE, prima delle cancellazioni: si rilegge
                $_REQUEST[ $tabella ] = array( 'id' => (int) $record['id'] );
                $ig = $pg = $cg = array();
                controller( $cf['mysql']['connection'], $cf['memcache']['connection'], $_REQUEST[ $tabella ], $tabella,
                    METHOD_GET, NULL, $errRecord, $ig, $pg, $cg, $cf['speed'] );
            }
        } elseif( $tabella !== NULL && ! empty( $record['id'] ) ) {
            $_REQUEST[ $tabella ] = array( 'id' => (int) $record['id'] );
            $infoRecord = $pi = $ci = array();
            controller( $cf['mysql']['connection'], $cf['memcache']['connection'], $_REQUEST[ $tabella ], $tabella,
                METHOD_GET, NULL, $errRecord, $infoRecord, $pi, $ci, $cf['speed'] );
        }

        // $ct['page'] e' un riferimento alla pagina del parser: si stacca prima, se no la si sovrascrive
        unset( $ct['page'] );
        $ct['page'] = $cf['contents']['pages'][ $id ];

        // _default.view.php usa il sito corrente nell'id della vista: via API la sessione non ce l'ha
        if( ! isset( $_SESSION['__view__']['__site__'] ) ) {
            $_SESSION['__view__']['__site__'] = SITE_CURRENT;
        }

        // filtri e paginazione chiesti dal client: si fondono come in _715.session.php, perche'
        // $_REQUEST['__view__'] e' un riferimento a $_SESSION['__view__'] e assegnarlo intero cancellerebbe
        // __site__ e __lang__
        foreach( ( is_array( $view ) ? $view : array() ) as $k => $vv ) {
            $_REQUEST['__view__'][ $k ] = $vv;
        }

        // macro di pagina, con le stesse varianti di _pages.php ( .alt e custom ); l'output delle macro non si manda
        ob_start();
        foreach( (array) ( $ct['page']['macro'] ?? array() ) as $macro ) {
            $alt = path2custom( str_replace( '.php', '.alt.php', $macro ) );
            $loc = path2custom( $macro );
            if( file_exists( fullPath( $alt ) ) ) {
                require fullPath( $alt );
            } elseif( file_exists( fullPath( $loc ) ) && $macro !== $loc ) {
                require fullPath( $loc );
            } elseif( file_exists( fullPath( $macro ) ) ) {
                require fullPath( $macro );
            }
        }
        $rumore = ob_get_clean();
        $rumore = ( trim( $rumore ) !== '' ) ? substr( strip_tags( $rumore ), 0, 500 ) : NULL;

        // la vista, di una pagina vista o dentro un form ( p.es. anagrafica.form.lavoro: le attivita del record );
        // per quella dentro un form anche la pagina dove si inserisce e il campo che lega la riga al record
        $v = $ct['view'] ?? array();
        $vid = $v['id'] ?? NULL;
        $vista = array(
            'id'     => $vid,
            'table'  => $v['table'] ?? NULL,
            'open'   => $v['open']['page'] ?? NULL,
            'insert' => $v['insert']['page'] ?? NULL,
            'preset' => $v['open']['preset']['field'] ?? NULL,
            'cols'   => $v['cols'] ?? array(),
            'class'  => $v['class'] ?? array(),
            'data'   => array_values( (array) ( $v['data'] ?? array() ) ),
            'pager'  => ( $vid !== NULL ) ? ( $_REQUEST['__view__'][ $vid ]['__pager__'] ?? NULL ) : NULL
        );

        // il form: tabella e metodo dalla macro, il record com'e' dopo le macro, le tendine
        if( $form ) {
            $t = $ct['form']['table'] ?? $tabella;
            return array(
                'status' => 'OK',
                'pagina' => $id,
                'schema' => $schema,
                'tabs'   => array_values( (array) ( $ct['page']['etc']['tabs'] ?? array() ) ),
                'form'   => array(
                    'table'    => $t,
                    'method'   => $ct['form']['method'] ?? NULL,
                    'activity' => $ct['form']['activity'] ?? NULL,
                    'record'   => ( $t !== NULL ) ? ( $_REQUEST[ $t ] ?? array() ) : array(),
                    // le colonne della tabella: un record nuovo e' vuoto, e senza di loro il client non sa che campi mostrare
                    'colonne'  => ( $t !== NULL && preg_match( '/^[a-z0-9_]+$/', $t ) )
                        ? array_column( (array) mysqlQuery( $cf['mysql']['connection'], 'SHOW COLUMNS FROM `' . $t . '`' ), 'Field' ) : array(),
                    'select'   => $ct['etc']['select'] ?? array(),
                    'err'      => $errRecord,
                    'salvato'  => $esito,
                    'eliminato' => $eliminato
                ),
                'view'   => $v ? $vista : NULL,
                'rumore' => $rumore
            );
        }

        return array(
            'status' => 'OK',
            'pagina' => $id,
            'schema' => $schema,
            'tabs'   => $ct['page']['etc']['tabs'] ?? array(),
            'view'   => $vista,
            'rumore' => $rumore
        );

    }
