<?php

    /**
     * libreria per il controllo di uptime dei siti
     *
     * Questa libreria contiene le funzioni del controllo di uptime che ha preso il posto di Site24x7 ( 04/11/2026 ).
     *
     * introduzione
     * ============
     * Ogni server del cluster controlla una volta al minuto tutti i siti glisweb di produzione del cluster, i propri e
     * quelli che gli altri server pubblicano, più i siti esterni elencati nella configurazione del cluster, e pubblica a
     * sua volta quello che vede. Di produzione vuol dire un host a cui il deploy dà un profilo che comincia per PROD. Un sito è giù quando un server lo trova giù
     * per UPTIME_DEFAULT['soglia'] controlli consecutivi e almeno un altro server lo vede giù: il server che non
     * raggiunge niente ha un problema suo, non del sito. Se nessun altro server risponde, il sito è giù ma non
     * confermato, e l'avviso va solo a noi.
     *
     * Il giro lo fa _src/_cli/_uptime.check.php, lanciato da un timer systemd ( _src/_sh/_uptime.install.sh ); la
     * configurazione del cluster sta in /etc/glisweb/uptime.yaml, quella del singolo sito in etc/uptime/<host>.yaml
     * del suo deploy. Il dettaglio è nel capitolo 125.uptime del manuale sviluppatore.
     *
     * Le funzioni da uptimeAggiorna() a uptimeDowntime() sono pure, e le prova l'esempio
     * _usr/_examples/_lib/_uptime.tools/_uptime.01.php; le altre toccano la rete o il filesystem.
     *
     * costanti
     * ========
     * costante                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * UPTIME_DEFAULT                   | i default di un sito, sovrascritti da etc/uptime/<host>.yaml
     *
     * funzioni
     * ========
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * uptimeVhost()                    | legge gli host HTTPS dei virtual host di Apache e nginx
 * uptimePubblico()                 | dice se un host si risolve nel DNS pubblico verso un IP pubblico
 * uptimeConfig()                   | legge la configurazione di un deploy come la legge il bootstrap
 * uptimeProfilo()                  | ricava il profilo ( DEV, TEST, PROD... ) che un deploy dà a un host
 * uptimeSiti()                     | raccoglie i siti glisweb di produzione dei deploy del server
 * uptimeEsterni()                  | prepara i siti esterni della configurazione del cluster
     * uptimeControlla()                | controlla in parallelo un elenco di siti
     * uptimeVista()                    | legge la vista pubblicata da un altro server
     * uptimeAggiorna()                 | applica l'isteresi agli esiti di un giro
     * uptimeConsenso()                 | decide lo stato di un sito confrontando la vista locale con quelle degli altri
     * uptimeTransizione()              | ricava l'evento del registro dal cambio di stato di un sito
     * uptimeDowntime()                 | genera il DOWNTIME.md di un deploy dal registro
     * uptimeAvvisa()                   | manda un avviso via SMTP diretto
     *
     * dipendenze
     * ==========
     * funzione                         | libreria di appartenenza
     * ---------------------------------|---------------------------------------------------------------
     * sendMail()                       | _src/_lib/_mail.tools.php
     *
     * Servono le estensioni curl e yaml; non legge $cf e non richiede il bootstrap del framework.
     *
     * licenza
     * =======
     * Questo file fa parte del progetto GlisWeb (https://github.com/istricesrl/glisweb) ed è distribuito
     * sotto licenza Open Source. Fare riferimento alla pagina GitHub del progetto per i dettagli.
     *
     */

    /**
     * i default di un sito
     *
     * percorso     il percorso controllato, se il deploy ha /status/uptime; senza, si controlla la home
     * testo        il testo che la risposta deve contenere ( NULL: nessuno )
     * codice       il codice HTTP atteso ( NULL: qualunque risposta sotto il 500 )
     * timeout      secondi oltre i quali il controllo fallisce
     * lento        secondi oltre i quali la risposta è lenta per soglia giri di fila: va nel registro, non è un
     *              fallimento e non manda mail
     * certificato  giorni di validità residua sotto i quali si avvisa noi
     * soglia       fallimenti consecutivi dopo i quali il sito è giù
     * ritardo      minuti di down confermato dopo i quali si avvisa il referente, se abilitato
     */
    define( 'UPTIME_DEFAULT', array(
        'percorso'      => '/status/uptime',
        'testo'         => 'OK',
        'codice'        => 200,
        'timeout'       => 10,
        'lento'         => 3,
        'certificato'   => 14,
        'soglia'        => 3,
        'ritardo'       => 10
    ) );

    /**
     * legge gli host HTTPS dei virtual host di Apache e nginx
     *
     * Per ogni virtual host in ascolto sulla 443 prende il ServerName ( server_name in nginx, il primo ) e la
     * DocumentRoot ( root ); gli alias restano fuori, perché di solito sono le varianti col www dello stesso sito.
     *
     * @param   array       $cartelle       le cartelle dei virtual host abilitati
     *
     * @return  array                       per document root, senza barra finale, gli host
     *
     */
    function uptimeVhost( $cartelle = array( '/etc/apache2/sites-enabled/', '/etc/nginx/sites-enabled/' ) ) {

        $vhost = array();

        foreach( $cartelle as $cartella ) {
            foreach( (array) glob( rtrim( $cartella, '/' ) . '/*' ) as $file ) {
                $testo = file_get_contents( $file );
                preg_match_all( '/<VirtualHost[^>]*:443>(.*?)<\/VirtualHost>/si', $testo, $apache );
                preg_match_all( '/server\s*\{((?:[^{}]|\{[^{}]*\})*)\}/si', $testo, $nginx );
                foreach( array_merge( $apache[1], $nginx[1] ) as $blocco ) {
                    if( preg_match( '/^\s*(?:ServerName|server_name)\s+([^\s;]+)/mi', $blocco, $n )
                        && preg_match( '/^\s*(?:DocumentRoot|root)\s+"?([^\s";]+)/mi', $blocco, $r )
                        && ( stripos( $blocco, 'ServerName' ) !== false || preg_match( '/listen\s+[^;]*443/i', $blocco ) ) ) {
                        $vhost[ rtrim( $r[1], '/' ) ][] = $n[1];
                    }
                }
            }
        }

        return array_map( 'array_unique', $vhost );

    }

    /**
     * dice se un host si risolve nel DNS pubblico verso un IP pubblico
     *
     * Usa dns_get_record(), che interroga il DNS e non legge /etc/hosts: un vhost di prova puntato a 127.0.0.1 solo
     * su questo server non è un sito che qualcuno visita. Un IP privato o riservato vale come non pubblico.
     *
     * @param   string      $host           il nome, o un IP
     *
     * @return  bool                        true se almeno un indirizzo è pubblico
     *
     */
    function uptimePubblico( $host ) {

        $ip = ( filter_var( $host, FILTER_VALIDATE_IP ) ) ? array( $host ) : array_column( (array) @dns_get_record( $host, DNS_A ), 'ip' );

        foreach( $ip as $i ) {
            if( filter_var( $i, FILTER_VALIDATE_IP, FILTER_FLAG_NO_PRIV_RANGE | FILTER_FLAG_NO_RES_RANGE ) ) {
                return true;
            }
        }

        return false;

    }

    /**
     * legge la configurazione di un deploy come la legge il bootstrap
     *
     * Fonde nello stesso ordine di _src/_config.php, dal meno al più importante, i file YAML e poi quelli JSON, prima
     * src/config/ext/ poi src/, prima config.* poi shadow.*. Serve a uptimeProfilo(), che ha bisogno dei siti.
     *
     * @param   string      $dev            la document root del deploy, con la barra finale
     *
     * @return  array                       la configurazione fusa
     *
     */
    function uptimeConfig( $dev ) {

        $config = array();

        foreach( array( 'src/config/ext/config.yaml', 'src/config/ext/shadow.yaml', 'src/config.yaml', 'src/shadow.yaml',
            'src/config/ext/config.json', 'src/config/ext/shadow.json', 'src/config.json', 'src/shadow.json' ) as $file ) {
            if( ! is_readable( $dev . $file ) ) {
                continue;
            }
            if( substr( $file, -5 ) === '.yaml' ) {
                $parte = function_exists( 'yaml_parse_file' ) ? @yaml_parse_file( $dev . $file ) : false;
            } else {
                $parte = json_decode( file_get_contents( $dev . $file ), true );
            }
            if( is_array( $parte ) ) {
                $config = array_replace_recursive( $config, $parte );
            }
        }

        return $config;

    }

    /**
     * ricava il profilo ( DEV, TEST, PROD... ) che un deploy dà a un host
     *
     * È la stessa regola con cui _src/_config/_015.site.php decide SITE_STATUS dall'HTTP_HOST: per ogni sito e per
     * ogni stato un'espressione regolare su host, domini e loro alias, e vince la prima che fa match. Se si cambia
     * lì va cambiata anche qui.
     *
     * @param   string      $host           l'host
     * @param   array       $sites          la chiave sites della configurazione del deploy
     *
     * @return  string|null                 il profilo, NULL se nessun sito del deploy risponde a quell'host
     *
     */
    function uptimeProfilo( $host, $sites ) {

        foreach( (array) $sites as $site ) {

            if( empty( $site['domains'] ) || ! is_array( $site['domains'] ) ) {
                continue;
            }

            foreach( $site['domains'] as $status => $domain ) {

                if( empty( $domain ) ) {
                    continue;
                }

                $hosts = isset( $site['hosts'][ $status ] ) ? array( $site['hosts'][ $status ] ) : array();
                if( isset( $site['alias']['hosts'][ $status ] ) ) {
                    $hosts = array_merge( $hosts, (array) $site['alias']['hosts'][ $status ] );
                }

                $domains = array( $domain );
                if( isset( $site['alias']['domains'][ $status ] ) ) {
                    $domains = array_merge( $domains, (array) $site['alias']['domains'][ $status ] );
                }

                $numerator = ( in_array( 'www', $hosts ) ) ? '{0,1}' : '{1}';
                $regex = '/^(?:' . implode( '|', $hosts ) . ')' . $numerator . '(?:\.)*(' . str_replace( '.', '\.', implode( '|', $domains ) ) . '){1}/i';

                if( preg_match( $regex, $host ) === 1 ) {
                    return $status;
                }

            }

        }

        return NULL;

    }

    /**
     * raccoglie i siti glisweb di produzione dei deploy del server
     *
     * Un deploy glisweb è una document root <radice>/<progetto>/<cartella> con _src/_config.php, dove la cartella è
     * dev, stable o test: la produzione di solito sta in stable ( crm.trbitaly.com, 04/11/2026 ). I suoi siti sono
     * gli host HTTPS che il server web associa a quella document root ( vedi uptimeVhost() ), più i file
     * etc/uptime/<host>.yaml, che sovrascrivono i default del sito con lo stesso host o ne aggiungono uno; un file
     * con attivo: false toglie il sito dal controllo. I siti che non stanno su un server del cluster sono esterni
     * ( vedi uptimeEsterni() ). A parità di host vince il primo deploy in
     * ordine alfabetico, a meno che l'host abbia un file in etc/uptime/ in un altro deploy.
     *
     * Si controllano solo i siti di produzione: un host entra se il deploy gli dà un profilo che comincia per PROD
     * ( PROD, PRODWMS... ), con la regola di uptimeProfilo(); gli ambienti DEV e TEST non sono siti che qualcuno usa
     * ( decisione di Fabio del 04/11/2026 ).
     *
     * Restano fuori anche gli host di $escludi e quelli che non si risolvono nel DNS pubblico ( uptimePubblico() ): i
     * vhost di prova solo locali, in /etc/hosts verso 127.0.0.1 col certificato snakeoil, davano un falso down
     * ( salviamossn e sostienigimbe sul dev di gimbe, 04/11/2026 ), e gli altri server non li raggiungerebbero.
     *
     * Gli host vengono dai virtual host e non dai domini della configurazione, che decidono solo il profilo: un
     * dominio PROD può stare su un altro server ( il 04/11/2026 il PROD di glisweb era glisweb.it, che web03 non
     * serve ).
     *
     * @param   string      $radice         la cartella dei deploy
     * @param   array       $vhost          gli host per document root, di solito uptimeVhost()
     * @param   array       $escludi        gli host da non controllare
     * @param   array       $scartati       riceve gli host scartati, col motivo: profilo o dns
     *
     * @return  array                       i siti, indicizzati per host
     *
     */
    function uptimeSiti( $radice = '/var/www/', $vhost = array(), $escludi = array(), &$scartati = array() ) {

        $siti = array();

        foreach( glob( rtrim( $radice, '/' ) . '/*/*/_src/_config.php' ) as $bootstrap ) {

            $dev = dirname( $bootstrap, 2 ) . '/';

            // un deploy non ancora aggiornato non ha /status/uptime: si controlla la home, che può anche rispondere con un
            // redirect al login o con un 404 se il deploy è un gestionale, quindi senza testo e senza codice atteso
            $base = UPTIME_DEFAULT;
            if( ! file_exists( $dev . '_src/_api/_status/_uptime.php' ) ) {
                $base['percorso'] = '/';
                $base['testo'] = NULL;
                $base['codice'] = NULL;
            }

            // i siti del deploy, per il profilo degli host
            $sites = uptimeConfig( $dev );
            $sites = isset( $sites['sites'] ) ? $sites['sites'] : array();

            // gli host HTTPS che il server web associa al deploy
            $host = array();
            if( isset( $vhost[ rtrim( $dev, '/' ) ] ) ) {
                foreach( $vhost[ rtrim( $dev, '/' ) ] as $h ) {
                    $host[ $h ] = array();
                }
            }

            // i file del deploy sovrascrivono o aggiungono
            $propri = array();
            foreach( glob( $dev . 'etc/uptime/*.yaml' ) as $file ) {
                $h = basename( $file, '.yaml' );
                $host[ $h ] = (array) @yaml_parse_file( $file );
                $propri[ $h ] = true;
            }

            foreach( $host as $h => $override ) {
                if( isset( $siti[ $h ] ) && ( empty( $propri[ $h ] ) || ! empty( $siti[ $h ]['dichiarato'] ) ) ) {
                    continue;
                }
                $sito = array_replace( $base, $override );
                if( ( isset( $sito['attivo'] ) && $sito['attivo'] === false ) || in_array( $h, $escludi ) ) {
                    unset( $siti[ $h ] );
                    continue;
                }
                if( empty( $sito['url'] ) ) {
                    $sito['url'] = 'https://' . $h . $sito['percorso'];
                }
                $profilo = uptimeProfilo( $h, $sites );
                if( $profilo === NULL || strpos( $profilo, 'PROD' ) !== 0 ) {
                    $scartati[ $h ] = 'profilo ' . ( ( $profilo === NULL ) ? 'nessuno' : $profilo );
                    continue;
                }
                if( ! uptimePubblico( parse_url( $sito['url'], PHP_URL_HOST ) ) ) {
                    $scartati[ $h ] = 'dns';
                    continue;
                }
                $sito['deploy'] = $dev;
                $sito['dichiarato'] = ! empty( $propri[ $h ] );
                $siti[ $h ] = $sito;
            }

        }

        ksort( $siti );

        return $siti;

    }

    /**
     * prepara i siti esterni della configurazione del cluster
     *
     * I siti esterni sono quelli che non stanno su un server del cluster ( la produzione GIMBE su Azure, 04/11/2026 ):
     * li elenca la sezione esterni: di /etc/glisweb/uptime.yaml, uguale su tutti i server, così li controllano tutti e
     * vale il consenso come per gli altri. Non hanno /status/uptime: si guarda la pagina indicata da url:, col codice
     * 200 e, se c'è, il testo atteso. Un sito senza url: si scarta.
     *
     * @param   array       $esterni        la sezione esterni:, indicizzata per host
     *
     * @return  array                       i siti, indicizzati per host, come quelli di uptimeSiti() ma senza deploy
     *
     */
    function uptimeEsterni( $esterni ) {

        $siti = array();

        foreach( (array) $esterni as $h => $sito ) {
            if( empty( $sito['url'] ) ) {
                continue;
            }
            $siti[ $h ] = array_replace( UPTIME_DEFAULT, array( 'testo' => NULL, 'codice' => 200 ), (array) $sito, array( 'deploy' => NULL, 'esterno' => true ) );
        }

        return $siti;

    }

    /**
     * controlla in parallelo un elenco di siti
     *
     * Un controllo riesce se la risposta arriva entro il timeout, col codice atteso e, se il sito ne dichiara uno,
     * col testo atteso; un sito senza codice atteso è su con qualunque risposta sotto il 500. Tempo di risposta e
     * scadenza del certificato si riportano ma non fanno fallire il controllo.
     *
     * I controlli contemporanei sono al massimo $paralleli, e uno nuovo parte appena uno finisce: lanciati tutti
     * insieme, venti siti dello stesso server rispondevano in 8-10 secondi invece che in meno di uno ( 04/11/2026 ).
     *
     * @param   array       $siti           i siti, indicizzati per host ( vedi uptimeSiti() )
     * @param   int         $paralleli      i controlli contemporanei
     *
     * @return  array                       per host: ok, codice, tempo, certificato ( giorni, NULL se ignoto ), errore
     *
     */
    function uptimeControlla( $siti, $paralleli = 4 ) {

        $multi = curl_multi_init();
        $coda = array_keys( $siti );
        $handle = array();
        $risultati = array();
        $esiti = array();

        do {

            // si riempie la finestra
            while( count( $handle ) - count( $risultati ) < $paralleli && ! empty( $coda ) ) {
                $h = array_shift( $coda );
                $handle[ $h ] = curl_init( $siti[ $h ]['url'] );
                curl_setopt_array( $handle[ $h ], array(
                    CURLOPT_RETURNTRANSFER  => true,
                    CURLOPT_FOLLOWLOCATION  => true,
                    CURLOPT_MAXREDIRS       => 3,
                    CURLOPT_CONNECTTIMEOUT  => $siti[ $h ]['timeout'],
                    CURLOPT_TIMEOUT         => $siti[ $h ]['timeout'],
                    CURLOPT_CERTINFO        => true,
                    CURLOPT_USERAGENT       => 'glisweb-uptime'
                ) );
                curl_multi_add_handle( $multi, $handle[ $h ] );
            }

            curl_multi_exec( $multi, $attivi );
            if( $attivi ) {
                curl_multi_select( $multi, 1 );
            }

            // in curl_multi l'errore di un trasferimento non arriva da curl_error(), ma da qui
            while( $info = curl_multi_info_read( $multi ) ) {
                $h = array_search( $info['handle'], $handle, true );
                $risultati[ $h ] = $info['result'];
            }

        } while( $attivi || ! empty( $coda ) || count( $risultati ) < count( $handle ) );

        foreach( $handle as $h => $ch ) {

            $corpo = curl_multi_getcontent( $ch );
            $codice = curl_getinfo( $ch, CURLINFO_HTTP_CODE );
            $errore = ( $risultati[ $h ] !== CURLE_OK ) ? curl_strerror( $risultati[ $h ] ) : '';

            // la scadenza è quella del primo certificato della catena, cioè quello del sito
            $certificato = NULL;
            $catena = curl_getinfo( $ch, CURLINFO_CERTINFO );
            if( ! empty( $catena[0]['Expire date'] ) ) {
                $certificato = floor( ( strtotime( $catena[0]['Expire date'] ) - time() ) / 86400 );
            }

            if( empty( $errore ) && ( ( $siti[ $h ]['codice'] === NULL && $codice >= 500 ) || ( $siti[ $h ]['codice'] !== NULL && $codice != $siti[ $h ]['codice'] ) ) ) {
                $errore = 'codice ' . $codice;
            } elseif( empty( $errore ) && ! empty( $siti[ $h ]['testo'] ) && strpos( $corpo, $siti[ $h ]['testo'] ) === false ) {
                $errore = 'testo atteso assente';
            }

            $esiti[ $h ] = array(
                'ok'            => empty( $errore ),
                'codice'        => $codice,
                'tempo'         => round( curl_getinfo( $ch, CURLINFO_TOTAL_TIME ), 2 ),
                'certificato'   => $certificato,
                'errore'        => $errore
            );

            curl_multi_remove_handle( $multi, $ch );
            curl_close( $ch );

        }

        curl_multi_close( $multi );

        return $esiti;

    }

    /**
     * legge la vista pubblicata da un altro server
     *
     * La vista è il var/uptime/stato.json del server, servito da /status/uptime a chi presenta il token del cluster.
     *
     * @param   string      $url            l'indirizzo di /status/uptime sull'altro server
     * @param   string      $token          il token condiviso del cluster
     * @param   int         $timeout        secondi di attesa
     *
     * @return  array|null                  la vista, NULL se il server non risponde o non la dà
     *
     */
    function uptimeVista( $url, $token, $timeout = 5 ) {

        $ch = curl_init( $url );
        curl_setopt_array( $ch, array(
            CURLOPT_RETURNTRANSFER  => true,
            CURLOPT_CONNECTTIMEOUT  => $timeout,
            CURLOPT_TIMEOUT         => $timeout,
            CURLOPT_HTTPHEADER      => array( 'X-Glisweb-Uptime: ' . $token ),
            CURLOPT_USERAGENT       => 'glisweb-uptime'
        ) );
        $corpo = curl_exec( $ch );
        $codice = curl_getinfo( $ch, CURLINFO_HTTP_CODE );
        curl_close( $ch );

        if( $codice != 200 ) {
            return NULL;
        }

        $vista = json_decode( $corpo, true );

        return ( is_array( $vista ) && isset( $vista['siti'] ) ) ? $vista : NULL;

    }

    /**
     * applica l'isteresi agli esiti di un giro
     *
     * Il sito passa giù in locale al fallimento numero $soglia, e torna su al primo controllo riuscito. Allo stesso
     * modo è lento quando risponde oltre $lento secondi per $soglia giri di fila, e smette al primo giro sotto: una
     * prova sola non basta, perché un deploy DEV senza memcache risponde in 6-7 secondi alla prima richiesta a
     * freddo e in due alle successive ( gimbe, 04/11/2026 ). I siti che non sono fra gli esiti escono dallo stato.
     *
     * @param   array       $stato          lo stato del giro prima, per host
     * @param   array       $esiti          gli esiti di uptimeControlla()
     * @param   int|array   $soglia         i giri consecutivi per dire giù o lento, uno solo o per host
     * @param   int|array   $lento          i secondi oltre i quali la risposta è lenta, uno solo o per host
     *
     * @return  array                       lo stato nuovo, per host: fallimenti, locale ( su|giu ), lenti, lento più l'esito
     *
     */
    function uptimeAggiorna( $stato, $esiti, $soglia = UPTIME_DEFAULT['soglia'], $lento = UPTIME_DEFAULT['lento'] ) {

        $nuovo = array();

        foreach( $esiti as $h => $esito ) {
            $prima = array_replace( array( 'fallimenti' => 0, 'locale' => 'su', 'lenti' => 0 ), isset( $stato[ $h ] ) ? $stato[ $h ] : array() );
            $s = ( is_array( $soglia ) ) ? $soglia[ $h ] : $soglia;
            $l = ( is_array( $lento ) ) ? $lento[ $h ] : $lento;
            $fallimenti = ( $esito['ok'] ) ? 0 : $prima['fallimenti'] + 1;
            $lenti = ( $esito['ok'] && $esito['tempo'] > $l ) ? $prima['lenti'] + 1 : 0;
            $nuovo[ $h ] = array_replace( $prima, $esito, array(
                'fallimenti'    => $fallimenti,
                'locale'        => ( $fallimenti >= $s ) ? 'giu' : 'su',
                'lenti'         => $lenti,
                'lento'         => ( $lenti >= $s )
            ) );
        }

        return $nuovo;

    }

    /**
     * decide lo stato di un sito confrontando la vista locale con quelle degli altri server
     *
     * stato            quando
     * -----------------|------------------------------------------------------------------
     * su               il server lo vede su, o lo vede giù ma un altro server che lo controlla lo vede su
     * giu              il server lo vede giù e almeno un altro server lo vede giù
     * nonconfermato    il server lo vede giù e nessun altro server lo controlla o risponde
     *
     * Avvisa uno solo dei server che lo vedono giù, il primo in ordine alfabetico, perché le mail non arrivino doppie.
     *
     * @param   string      $server         il nome di questo server
     * @param   string      $locale         lo stato locale del sito ( su|giu )
     * @param   array       $viste          per server, lo stato locale che quel server dà al sito; NULL se non risponde
     *                                      o non controlla il sito
     *
     * @return  array                       stato, giu ( i server che lo vedono giù ) e mittente ( true se avvisa questo server )
     *
     */
    function uptimeConsenso( $server, $locale, $viste ) {

        $giu = array();
        $su = 0;

        foreach( $viste as $altro => $vista ) {
            if( $vista === 'giu' ) {
                $giu[] = $altro;
            } elseif( $vista === 'su' ) {
                $su++;
            }
        }

        if( $locale !== 'giu' ) {
            $stato = 'su';
        } elseif( ! empty( $giu ) ) {
            $stato = 'giu';
        } elseif( $su > 0 ) {
            $stato = 'su';
        } else {
            $stato = 'nonconfermato';
        }

        if( $locale === 'giu' ) {
            $giu[] = $server;
        }
        sort( $giu );

        return array(
            'stato'     => $stato,
            'giu'       => $giu,
            'mittente'  => ( $stato !== 'su' && reset( $giu ) === $server )
        );

    }

    /**
     * ricava l'evento del registro dal cambio di stato di un sito
     *
     * Un periodo di down comincia quando il sito passa da su a giu o nonconfermato e finisce quando torna su; se
     * durante il periodo il down viene confermato, la fine lo riporta. Il periodo aperto vive in $sito['dal'].
     *
     * @param   string      $host           il sito
     * @param   array       $sito           lo stato del sito prima del giro ( globale, dal, confermato, errore )
     * @param   string      $stato          lo stato deciso da uptimeConsenso()
     * @param   int         $ora            il timestamp del giro
     * @param   array       $giu            i server che lo vedono giù
     *
     * @return  array                       il sito aggiornato e l'evento ( NULL se non è cambiato niente )
     *
     */
    function uptimeTransizione( $host, $sito, $stato, $ora, $giu = array() ) {

        $prima = isset( $sito['globale'] ) ? $sito['globale'] : 'su';
        $evento = NULL;

        if( $prima === 'su' && $stato !== 'su' ) {
            $sito['dal'] = $ora;
            $sito['confermato'] = ( $stato === 'giu' );
            $evento = array(
                'evento'        => 'inizio',
                'sito'          => $host,
                'ora'           => date( 'c', $ora ),
                'server'        => $giu,
                'confermato'    => $sito['confermato'],
                'errore'        => isset( $sito['errore'] ) ? $sito['errore'] : NULL
            );
        } elseif( $prima !== 'su' && $stato === 'su' ) {
            $evento = array(
                'evento'        => 'fine',
                'sito'          => $host,
                'ora'           => date( 'c', $ora ),
                'inizio'        => date( 'c', $sito['dal'] ),
                'durata'        => $ora - $sito['dal'],
                'confermato'    => ! empty( $sito['confermato'] )
            );
            unset( $sito['dal'], $sito['confermato'], $sito['avvisato'], $sito['referente'] );
        } elseif( $stato === 'giu' ) {
            $sito['confermato'] = true;
        }

        $sito['globale'] = $stato;

        return array( $sito, $evento );

    }

    /**
     * genera il DOWNTIME.md di un deploy dal registro
     *
     * Una riga per periodo di down, dal più recente; un periodo aperto risulta in corso. Il file è generato e non
     * si modifica a mano: il registro, var/uptime/registro.jsonl, è la fonte.
     *
     * @param   array       $eventi         gli eventi del registro, in ordine di scrittura
     * @param   array       $host           i siti del deploy
     *
     * @return  string                      il markdown
     *
     */
    function uptimeDowntime( $eventi, $host ) {

        $periodi = array();
        $aperti = array();

        foreach( $eventi as $e ) {
            if( ! in_array( $e['sito'], $host ) ) {
                continue;
            }
            if( $e['evento'] === 'inizio' ) {
                $aperti[ $e['sito'] ] = count( $periodi );
                $periodi[] = array( 'sito' => $e['sito'], 'inizio' => $e['ora'], 'fine' => NULL, 'durata' => NULL, 'confermato' => $e['confermato'], 'errore' => $e['errore'] );
            } elseif( $e['evento'] === 'fine' && isset( $aperti[ $e['sito'] ] ) ) {
                $i = $aperti[ $e['sito'] ];
                $periodi[ $i ]['fine'] = $e['ora'];
                $periodi[ $i ]['durata'] = $e['durata'];
                $periodi[ $i ]['confermato'] = $e['confermato'];
                unset( $aperti[ $e['sito'] ] );
            }
        }

        $md = '# DOWNTIME' . PHP_EOL . PHP_EOL
            . 'Generato da _src/_cli/_uptime.check.php dal registro var/uptime/registro.jsonl: non si modifica a mano.' . PHP_EOL
            . 'Un periodo non confermato è stato visto giù da un server solo, mentre gli altri non rispondevano.' . PHP_EOL . PHP_EOL
            . '| inizio | fine | durata | sito | confermato | motivo |' . PHP_EOL
            . '|---|---|---|---|---|---|' . PHP_EOL;

        foreach( array_reverse( $periodi ) as $p ) {
            $md .= '| ' . date( 'Y-m-d H:i', strtotime( $p['inizio'] ) )
                . ' | ' . ( ( $p['fine'] === NULL ) ? 'in corso' : date( 'Y-m-d H:i', strtotime( $p['fine'] ) ) )
                . ' | ' . ( ( $p['durata'] === NULL ) ? '' : ceil( $p['durata'] / 60 ) . ' min' )
                . ' | ' . $p['sito']
                . ' | ' . ( ( $p['confermato'] ) ? 'sì' : 'no' )
                . ' | ' . str_replace( '|', '/', (string) $p['errore'] )
                . ' |' . PHP_EOL;
        }

        return $md;

    }

    /**
     * manda un avviso via SMTP diretto
     *
     * Non passa dalla coda delle mail, che vive nel database di un sito: proprio quello che potrebbe essere giù.
     *
     * @param   array       $smtp           host, port, user, pasw, from della sezione smtp di /etc/glisweb/uptime.yaml
     * @param   array       $a              gli indirizzi
     * @param   string      $oggetto        l'oggetto
     * @param   string      $corpo          il corpo, in testo semplice
     *
     * @return  bool                        l'esito dell'invio
     *
     */
    function uptimeAvvisa( $smtp, $a, $oggetto, $corpo ) {

        if( empty( $a ) ) {
            return false;
        }

        $destinatari = array();
        foreach( (array) $a as $indirizzo ) {
            $destinatari[ $indirizzo ] = $indirizzo;
        }

        return (bool) sendMail(
            isset( $smtp['host'] ) ? $smtp['host'] : 'localhost',
            array( 'glisweb uptime' => $smtp['from'] ),
            $destinatari,
            $oggetto,
            nl2br( htmlspecialchars( $corpo ) ),
            array(), array(), array(), array(),
            isset( $smtp['user'] ) ? $smtp['user'] : NULL,
            isset( $smtp['pasw'] ) ? $smtp['pasw'] : NULL,
            isset( $smtp['port'] ) ? $smtp['port'] : 25
        );

    }
