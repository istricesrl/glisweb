<?php

    /**
     * individuazione del sito corrente
     *
     * questo file si occupa di determinare il sito corrente fra quelli gestiti dall'installazione corrente
     * a partire dall'URL
     *
     * strategie di individuazione del sito
     * ====================================
     * Il sito corrente viene determinato a partire dall'URL corrente, che viene confrontato con i domini, gli host,
     * i protocolli e gli alias dichiarati nell'array $cf['sites']. Se non viene trovata alcuna corrispondenza, il
     * sito corrente rimane quello di default (vedi sotto) impostato in _src/_config/_010.site.php, eventualmente
     * customizzato.
     *
     * la costante SITE_DEFAULT
     * ------------------------
     * Questa costante contiene l'ID del sito di default, che viene utilizzato nel caso non venga riscontrata alcuna
     * corrispondenza fra l'URL corrente e i dati dichiarati in $cf['sites'].
     *
     * la costante SITE_CURRENT
     * ------------------------
     * Questa costante contiene l'ID del sito corrente, così come identificato tramite l'analisi dell'URL, oppure
     * viene valorizzata a SITE_DEFAULT se l'analisi dell'URL non ha dato corrispondenze con i dati contenuti in $cf['sites'].
     *
     * l'array $cf['site']
     * ===================
     * Le variabili del ramo 'site' definiscono in generale il sito corrente. Si veda la
     * \ref variabili "sezione della documentazione dedicata alle variabili" per il dettaglio delle chiavi di $cf['site'],
     * in questa sede è solo necessario sottolineare che questo array contiene tutti i dati di configurazione del
     * sito corrente.
     *
     *
     *
     * TODO visto che la licenza è per deploy (non per sito) dovrebbe essere $cf['license'] e non $cf['site']['license']
     * TODO verificare se dietro proxy serve di considerare X-FORWARDED-FOR anziché HTTP_HOST https://stackoverflow.com/questions/11452938/how-to-use-http-x-forwarded-for-properly
     * TODO documentare FILE_STATUS
     * TODO documentare
     *
     *
     *
     */

    // debug
    // print_r( $cf['sites'] );
    // die( print_r( $cx['sites'], true ) );

    // configurazione extra
    if( isset( $cx['sites'] ) ) {
        $cf['sites'] = array_replace_recursive( $cf['sites'], $cx['sites'] );
    }

    // collegamento a $ct
    $ct['sites'] = &$cf['sites'];

    /**
     * ricerca del sito corrente
     * =========================
     * 
     * 
     */

    // debug
    // die( print_r( $cf['sites'], true ) );

    // cerco di ricavare il sito corrente dal dominio
    foreach( $cf['sites'] as $id => &$site ) {

        // assegno l'id del sito corrente alla chiave 'id'
        $site['id'] = $id;

        // ciclo sugli stati del sito
        foreach( $site['domains'] as $status => $domain ) {

            // debug
            // echo $status . '->' . $id . PHP_EOL;
            // echo $status . '->' . $domain . PHP_EOL;
            // echo $domain .' -> ' . $_SERVER['HTTP_HOST'] . PHP_EOL;

            // se c'è un dominio per questo status
            if( ! empty( $domain ) ) {

                // inizializzazioni
                $hosts = $domains = array();

                // per lo stato corrente, verifico se c'è un host specificato
                if( isset( $site['hosts'][ $status ] ) ) {
                    $hosts[] = $site['hosts'][ $status ];
                }

                // per lo stato corrente, verifico se ci sono degli alias di host
                if( isset( $site['alias']['hosts'][ $status ] ) ) {
                    $hosts = array_merge( $hosts, $site['alias']['hosts'][ $status ] );
                }

                // per lo stato corrente, aggiungo il domain
                $domains[] = $site['domains'][ $status ];

                // per lo stato corrente, verifico se ci sono degli alias di domain
                if( isset( $site['alias']['domains'][ $status ] ) ) {
                    $domains = array_merge( $domains, $site['alias']['domains'][ $status ] );
                }

                // numeratore host in base a www
                if( in_array( 'www', $hosts ) ) {
                    $numerator = '{0,1}';
                } else {
                    $numerator = '{1}';
                }

                // regola di match per i domini
                $drule = str_replace( '.', '\.', implode( '|', $domains ) );

                // regola di match per gli host
                $hrule = implode( '|', $hosts );

                // composizione dell'espressione regolare
                $regex = '/^(?:' . $hrule . ')' . $numerator . '(?:\.)*(' . $drule . '){1}/';

                // debug
                // echo $regex .' -> ' . $_SERVER['HTTP_HOST'] . PHP_EOL;
                $site['regexp'] = $regex;

                // espressione regolare
                if( preg_match( $regex, $_SERVER['HTTP_HOST'] ) === 1 ) {
                    if( ! defined( 'SITE_CURRENT' ) ) {
                        define( 'SITE_CURRENT', $id ); 
                        $cStatus = $status;
                    }
                }

            }

        }

    }

    // multisito corrente
    if( ! defined( 'SITE_CURRENT' ) ) {
        die( 'sito non trovato per ' . $_SERVER['HTTP_HOST'] . ' (' . DIR_BASE . ') verificare che il file config.json sia nella posizione giusta oppure i dati in 010.site.php' );
    }

    /**
     * sito di default
     * ===============
     * 
     * 
     */

    // sito di default
    if( ! defined( 'SITE_DEFAULT' ) ) {
        define( 'SITE_DEFAULT', array_key_first( $cf['sites'] ) );
    }

    /**
     * configurazioni che dipendono dal sito corrente
     * ==============================================
     * 
     * 
     * 
     */

    // link al sito corrente
    $cf['site'] = &$cf['sites'][ SITE_CURRENT ];

    // status del sito
    if( isset( $cStatus ) ) {
        $cf['site']['status'] = $cStatus;
    } else {
        $cf['site']['status'] = DEVELOPEMENT;
    }

    // status del sito
    define( 'SITE_STATUS', $cf['site']['status'] );

    // debug
    // die( 'host: ' . $_SERVER['HTTP_HOST'] );
    // print_r( $cf['site'] );
    // echo 'OUTPUT';
