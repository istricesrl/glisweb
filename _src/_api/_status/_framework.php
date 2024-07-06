<?php

    /**
     * visualizzatore dello stato di funzionamento del framework
     * 
     * 
     * TODO implementare
     * TODO documentare
     * 
     */

    // inclusione del framework
    require '../../_config.php';

    // header
    header( 'Content-type: text/plain' );

    // output
    echo 'STATUS DEL FRAMEWORK ' . date( 'Y-m-d H:i:s' ) . PHP_EOL;
    echo '========================================' . PHP_EOL;

    // output
    echo PHP_EOL;

    // output
    echo 'versioni' . PHP_EOL;
    echo '--------' . PHP_EOL;

    // versione di PHP
    echo '[INFO] versione di PHP trovata: ' . PHP_VERSION . PHP_EOL;

    // release del framework
    if( version_compare( RELEASE_CURRENT, RELEASE_LATEST ) == 0 ) {
        echo '[ OK ] GlisWeb aggiornato alla release stable (' . RELEASE_CURRENT . ')' . PHP_EOL;
    } elseif( version_compare( RELEASE_CURRENT, RELEASE_LATEST ) == -1 ) {
        echo '[WARN] stai usando una release obsoleta di GlisWeb (' . RELEASE_CURRENT . ') rispetto alla stable ' . RELEASE_LATEST . PHP_EOL;
    } else {
        echo '[INFO] stai usando una release di sviluppo di GlisWeb (' . RELEASE_CURRENT . ') superiore alla stable ' . RELEASE_LATEST . PHP_EOL;
    }

    // versione del framework
    if( VERSION_CURRENT == VERSION_LATEST ) {
        echo '[ OK ] GlisWeb aggiornato (' . VERSION_CURRENT . ')' . PHP_EOL;
    } elseif( VERSION_CURRENT < VERSION_LATEST ) {
        echo '[WARN] stai usando una versione obsoleta di GlisWeb (' . VERSION_CURRENT . ') rispetto a ' . VERSION_LATEST . PHP_EOL;
    } else {
        echo '[INFO] stai usando una versione di sviluppo di GlisWeb (' . VERSION_CURRENT . ') superiore a ' . VERSION_LATEST . PHP_EOL;
    }

    // output
    echo PHP_EOL;

    // output
    echo 'informazioni generali' . PHP_EOL;
    echo '---------------------' . PHP_EOL;

    // directory base
    if( ! defined( 'DIR_BASE' ) ) {
        die( '[FAIL] costante DIR_BASE non definita' . PHP_EOL );
    } else {
        echo '[ -- ] directory base: ' . DIR_BASE . PHP_EOL;
    }

    // file di configurazione
    foreach( $cf['config']['files'] as $type => $files ) {
        foreach( $files as $file ) {
            echo '[ -- ] file di configurazione ' . $type . ' trovato: ' . shortPath( $file ) . PHP_EOL;
        }
    }

    // output
    echo PHP_EOL;

    // output
    echo 'sicurezza' . PHP_EOL;
    echo '---------' . PHP_EOL;

    // password di root
    if( ! isset( $cf['auth']['accounts']['root']['password'] ) ) {
        echo '[ -- ] utente root non attivo' . PHP_EOL;
    } elseif( bruteForceHash( $cf['auth']['accounts']['root']['password'] ) ) {
        die( '[FAIL] password di root troppo debole' . PHP_EOL );
    } else {
        echo '[ OK ] utente root attivo con password non banale' . PHP_EOL;
    }

    // output
    echo PHP_EOL;

    // output
    echo 'log e debug' . PHP_EOL;
    echo '-----------' . PHP_EOL;

    // controllo del livello di report
    echo '[ -- ] livello di report: ' . reportLvl2string( REPORT_CURRENT_LEVEL ) . ' (' . REPORT_CURRENT_LEVEL . ')' . PHP_EOL;
    if( $cf['site']['status'] == 'PROD' ) {
        if( REPORT_CURRENT_LEVEL > 2 ) {
            echo '[WARN] livello di report alto per un ambiente di produzione, messaggi superflui possono confondere l\'utente' . PHP_EOL;
        }
    }

    // controllo del livello di log
    echo '[ -- ] livello di log: ' . logLvl2string( LOG_CURRENT_LEVEL ) . ' (' . LOG_CURRENT_LEVEL . ')' . PHP_EOL;
    if( $cf['site']['status'] == 'PROD' ) {
        if( LOG_CURRENT_LEVEL > LOG_WARNING ) {
            echo '[WARN] livello di log alto per un ambiente di produzione, un I/O disco eccessivo può rallentare il framework' . PHP_EOL;
        }
    }

    // output
    echo PHP_EOL;

    // output
    echo 'sito corrente' . PHP_EOL;
    echo '-------------' . PHP_EOL;

    // status del framework
    if( isset( $cf['site']['status'] ) ) {
        echo '[ -- ] status del framework: ' . $cf['site']['status'] . PHP_EOL;
    } else {
        die( '[FAIL] status del framework non impostato' . PHP_EOL );
    }

    // controllo status
    if( in_array( $cf['site']['status'], array_keys( $cf['debug'] ) ) ) {
        echo '[ -- ] status ' . $cf['site']['status'] . ' presente nei profili di debug' . PHP_EOL;
    } else {
        die( '[FAIL] status ' . $cf['site']['status'] . ' non presente nei profili di debug' . PHP_EOL );
    }

    // dominio del framework
    echo '[ -- ] IP del framework: ' . $_SERVER['SERVER_ADDR'] . PHP_EOL;
    if( isset( $cf['site']['fqdn'] ) && ! empty( $cf['site']['fqdn'] ) ) {
        echo '[ -- ] FQDN del framework: ' . $cf['site']['fqdn'] . PHP_EOL;
        if( checkdnsrr( $cf['site']['fqdn'], 'A' ) ) {
            echo '[ OK ] FQDN risolvibile correttamente (record A)' . PHP_EOL;
        } elseif( checkdnsrr( $cf['site']['fqdn'], 'CNAME' ) ) {
            echo '[ OK ] FQDN risolvibile correttamente (record CNAME)' . PHP_EOL;
        } else {
            echo '[WARN] FQDN non risolvibile' . PHP_EOL;
        }
    } else {
        echo '[WARN] FQDN del framework non impostato' . PHP_EOL;
    }

    // multisito
    if( isset( $cf['site']['id'] ) ) {
        echo '[ -- ] #id multisito corrente: ' . $cf['site']['id'] . PHP_EOL;
    }

    // pagina home
    if( empty( $cf['site']['home'] ) ) {
        echo '[WARN] #id home corrente non impostato' . PHP_EOL;
    } else {
        echo '[ OK ] #id home corrente: ' . $cf['site']['home'] . PHP_EOL;
    }

    // aggiornamento della sitemap
    if( empty( $cf['sitemap']['updated'] ) ) {
        echo '[INFO] sitemap non presente' . PHP_EOL;
    } else {
        echo '[ -- ] ultimo aggiornamento della sitemap: ' . date( 'Y-m-d H:i:s', $cf['sitemap']['updated'] ) . PHP_EOL;
    }

    // aggiornamento delle pagine
    if( empty( $cf['contents']['updated'] ) ) {
        echo '[INFO] data di aggiornamento dei contenuti non disponibile' . PHP_EOL;
    } else {
        echo '[ -- ] ultimo aggiornamento dei contenuti: ' . date( 'Y-m-d H:i:s', $cf['contents']['updated'] ) . PHP_EOL;
    }

    // controllo Twig
    if( isset( $cf['twig']['profile']['cache'] ) ) {
        echo '[ -- ] cache Twig attiva' . PHP_EOL;
    } else {
        echo '[ -- ] cache Twig non attiva' . PHP_EOL;
    }

    // output
    echo PHP_EOL;

    // output
    echo 'documentazione e supporto' . PHP_EOL;
    echo '-------------------------' . PHP_EOL;

    // canale Slack
    if( ! isset( $cf['slack']['profile']['channel']['url'] ) ) {
        echo '[INFO] canale Slack di supporto non impostata' . PHP_EOL;
    } else {
        echo '[ -- ] canale Slack di supporto: ' . $cf['slack']['profile']['channel']['url'] . PHP_EOL;
    }

    // output
    echo PHP_EOL;

    // output
    echo 'privacy e normative' . PHP_EOL;
    echo '-------------------' . PHP_EOL;

    // titolare privacy
    if( empty( $cf['privacy']['titolare'] ) ) {
        echo '[FAIL] titolare del trattamento dei dati non impostato' . PHP_EOL;
    } else {
        echo '[ OK ] titolare del trattamento dei dati impostato' . PHP_EOL;
    }

    // controllo cookie
    foreach( $_COOKIE as $k => $v ) {
        if( in_array( $k, array_keys( $cf['cookie']['index'] ) ) || inRegexpArray( $k, array_keys( $cf['cookie']['index'] ) ) ) {
            echo '[ OK ] il cookie ' . $k . ' è correttamente descritto nelle specifiche della privacy' . PHP_EOL;
        } else {
            echo '[FAIL] il cookie ' . $k . ' non è descritto nelle specifiche della privacy' . PHP_EOL;
        }
    }

    // output
    echo PHP_EOL;

    // output
    echo 'connessione SMTP' . PHP_EOL;
    echo '----------------' . PHP_EOL;

    // controllo SMTP
    // NOTA vedi https://github.com/PHPMailer/PHPMailer/blob/master/examples/smtp_check.phps
    if( ! empty( $cf['smtp']['profiles'][ $cf['site']['status'] ]['servers'] ) ) {

        echo '[ -- ] SMTP configurato' . PHP_EOL;

        foreach( $cf['smtp']['profiles'][ $cf['site']['status'] ]['servers'] as $server ) {
            echo '[ -- ] test del server: ' . $cf['smtp']['servers'][ $server ]['address'] . PHP_EOL;
            $smtp = new PHPMailer\PHPMailer\SMTP;
            $smtp->Timeout = 5;
            // $smtp->do_debug = SMTP::DEBUG_CONNECTION;
            $c = $smtp->connect( $cf['smtp']['servers'][ $server ]['address'], $cf['smtp']['servers'][ $server ]['port'] );
            if( empty( $c ) ) {
                echo '[FAIL] impossibile connettersi ' . $smtp->getError()['error'] . PHP_EOL;
            } else {
                echo '[ OK ] connessione effettuata' . PHP_EOL;
                $e = $smtp->getServerExtList();
                if( !$smtp->hello( gethostname() ) ) {
                    echo '[WARN] HELO fallito ' . $smtp->getError()['error'] . PHP_EOL;
                } else {
                    echo '[ OK ] HELO ' . gethostname() . PHP_EOL;
                }
                if( is_array( $e ) && array_key_exists( 'STARTTLS', $e ) ) {
                    echo '[ -- ] tento TLS...' . PHP_EOL;
                    $tlsok = $smtp->startTLS();
                    if( !$tlsok ) {
                        echo '[WARN] TLS fallito ' . $smtp->getError()['error'] . PHP_EOL;
                    }
                    if( !$smtp->hello( gethostname() ) ) {
                        echo '[WARN] HELO (2) fallito ' . $smtp->getError()['error'] . PHP_EOL;
                    }
                    $e = $smtp->getServerExtList();
                } else {
                    echo '[INFO] TLS non rilevato' . PHP_EOL;
                }
                if( is_array( $e ) && array_key_exists( 'AUTH', $e ) ) {
                    echo '[ -- ] tento AUTH...' . PHP_EOL;
                    if( isset( $cf['smtp']['servers'][ $server ]['username'] ) ) {
                        if( $smtp->authenticate( $cf['smtp']['servers'][ $server ]['username'], $cf['smtp']['servers'][ $server ]['password'] ) ) {
                            echo '[ OK ] autenticazione effettuata' . PHP_EOL;
                        } else {
                            echo '[FAIL] impossibile autenticarsi' . $smtp->getError()['error'] . PHP_EOL;
                        }
                    }
                } else {
                echo '[INFO] AUTH non rilevato' . PHP_EOL;
                }
            }
        }
    } else {
        echo '[ -- ] SMTP non configurato' . PHP_EOL;
    }

    // output
    echo PHP_EOL;

    // output
    echo 'connessione MySQL' . PHP_EOL;
    echo '-----------------' . PHP_EOL;

    // controllo MySQL
    if( ! empty( $cf['mysql']['profiles'][ $cf['site']['status'] ]['servers'] ) ) {
        echo '[ -- ] backend MySQL attivato' . PHP_EOL;
        echo '[ -- ] server MySQL (' . $cf['site']['status'] . '): ' . implode( ', ', $cf['mysql']['profiles'][ $cf['site']['status'] ]['servers'] ) . PHP_EOL;
        if( ! empty( $cf['mysql']['connection'] ) ) {
            echo '[ OK ] connessione MySQL su ' . $cf['mysql']['server']['address'] . ':' . $cf['mysql']['server']['port'] . ' presente' . PHP_EOL;
            echo '[ -- ] versione del server MySQL: ' . $cf['mysql']['server']['version'] . PHP_EOL;
            echo '[ -- ] database selezionato: ' . $cf['mysql']['server']['db'] . PHP_EOL;

            /* TODO ripristinare
            echo '[ -- ] livello di patch: ' . $cf['mysql']['profile']['patch']['current'] . PHP_EOL;
            if( $cf['mysql']['profile']['patch']['current'] == $cf['mysql']['profile']['patch']['latest'] ) {
                echo '[ OK ] database aggiornato alla patch: ' . $cf['mysql']['profile']['patch']['latest'] . PHP_EOL;
            } elseif( $cf['mysql']['profile']['patch']['current'] < $cf['mysql']['profile']['patch']['latest'] ) {
                echo '[WARN] database non aggiornato alla patch: ' . $cf['mysql']['profile']['patch']['latest'] . PHP_EOL;
            } else {
                echo '[INFO] database successivo alla patch: ' . $cf['mysql']['profile']['patch']['latest'] . PHP_EOL;
            }
            $fails = glob( DIR_VAR_LOG . 'mysql/patch/fail/*.sql' );
            foreach( $fails as $fail ) {
                echo '[WARN] applicare manualmente la patch: ' . basename( $fail ) . PHP_EOL;
            }
            */

            $myerr = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT count( id ) FROM __patch__ WHERE note_esecuzione != "OK"' );

            if( $myerr > 0 ) {
                echo( '[WARN] errori trovati sulla tabella di patch' . PHP_EOL );
            } else {
                echo( '[ OK ] nessun errore trovato sulla tabella di patch' . PHP_EOL );
            }

        } else {
            echo( '[FAIL] connessione assente' . PHP_EOL );
        }

    } else {
        echo '[ -- ] backend MySQL non attivato' . PHP_EOL;
    }

    // output
    echo PHP_EOL;

    // output
    echo 'connessione memcache' . PHP_EOL;
    echo '--------------------' . PHP_EOL;

    // controllo memcache
    if( ! empty( $cf['memcache']['profiles'][ $cf['site']['status'] ]['servers'] ) ) {
        echo '[ -- ] backend memcache attivato' . PHP_EOL;
        if( ! empty( $cf['memcache']['connection'] ) ) {
        echo '[ OK ] connessione memcache su ' . $cf['memcache']['server']['address'] . ':' . $cf['memcache']['server']['port'] . ' presente' . PHP_EOL;
        if( ! empty( $cf['memcache']['stat']['hits'] ) ) {
            echo '[ -- ] utilizzati ' . $cf['memcache']['stat']['usage'] . ' (' . $cf['memcache']['stat']['percent'] . ')' . PHP_EOL;
            echo '[ -- ] ' . $cf['memcache']['stat']['hits'] . ' (hit rate ' . $cf['memcache']['stat']['hitrate'] . ' ' . ( ( floatval( $cf['memcache']['stat']['hitrate'] ) > 90.0 ) ? 'OK' : 'NO' ) . ')' . PHP_EOL;
        } else {
            die( '[FAIL] statistiche di memcache non ancora raccolte' . PHP_EOL );
        }
        } else {
        die( '[FAIL] connessione memcache su ' . $cf['memcache']['server']['address'] . ':' . $cf['memcache']['server']['port'] . ' assente' . PHP_EOL );
        }
    } else {
        echo '[ -- ] backend memcache non attivato' . PHP_EOL;
    }

    // output
    echo PHP_EOL;

    // output
    echo 'connessione redis' . PHP_EOL;
    echo '-----------------' . PHP_EOL;

    // controllo redis
    if( ! empty( $cf['redis']['profiles'][ $cf['site']['status'] ]['servers'] ) ) {
        echo '[ -- ] backend redis attivato' . PHP_EOL;
        if( ! empty( $cf['redis']['connection'] ) ) {
        echo '[ OK ] connessione redis su ' . $cf['redis']['server']['address'] . ':' . $cf['redis']['server']['port'] . ' presente' . PHP_EOL;
        } else {
        die( '[FAIL] connessione redis su ' . $cf['redis']['server']['address'] . ':' . $cf['redis']['server']['port'] . ' assente' . PHP_EOL );
        }
    } else {
        echo '[ -- ] backend redis non attivato' . PHP_EOL;
    }

    // output
    echo PHP_EOL;

    // output
    echo 'sistema di schedulazione' . PHP_EOL;
    echo '------------------------' . PHP_EOL;

    // cerco l'ultima esecuzione del cron
    $rCronTime = strtotime( '-3 minutes' );
    $lCronTime = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT coalesce( max( timestamp_esecuzione ), 0 ) FROM task' );
    if( $lCronTime == 0 ) {
        echo '[FAIL] cron del framework mai eseguito' . PHP_EOL;
    } else {
        echo '[ -- ] ultima esecuzione del cron del framework: ' . date( 'Y-m-d H:i:s', $lCronTime ) . PHP_EOL;
        if( $lCronTime < $rCronTime ) {
            echo '[FAIL] cron del framework non funzionante' . PHP_EOL;
        } else {
            echo '[ OK ] cron del framework funzionante' . PHP_EOL;
        }
    }
    $pCronTasks = mysqlQuery( $cf['mysql']['connection'], 'SELECT * FROM task WHERE token IS NOT NULL AND timestamp_esecuzione < ?', array( array( 's' => $rCronTime ) ) );
    foreach( $pCronTasks as $pCronTask ) {
        echo '[WARN] task '. $pCronTask['task'] .' bloccato alle ' . date( 'Y-m-d H:i:s', $pCronTask['timestamp_esecuzione'] ) . ' con token ' . $pCronTask['token'] . PHP_EOL;
    }

    // output
    echo PHP_EOL;

    // output
    echo 'servizi esterni' . PHP_EOL;
    echo '---------------' . PHP_EOL;

    // configurazione Google
    if( empty( $cf['google']['profile'] ) ) {
        echo '[INFO] servizi Google non configurati' . PHP_EOL;
    } else {
        echo '[ -- ] profilo Google esistente per lo status ' . $cf['site']['status'] . PHP_EOL;
        if( empty( $cf['google']['profile']['analytics']['ua'] ) ) {
            echo '[INFO] Google Analytics non configurato' . PHP_EOL;
        } else {
            echo '[ -- ] profilo Google Analytics: ' . $cf['google']['profile']['analytics']['ua'] . PHP_EOL;
        }
    }

    // configurazione Facebook
    if( empty( $cf['facebook']['profile'] ) ) {
        echo '[INFO] servizi Facebook non configurati' . PHP_EOL;
    } else {
        echo '[ -- ] profilo Facebook esistente per lo status ' . $cf['site']['status'] . PHP_EOL;
        if( empty( $cf['facebook']['profile']['pixel']['id'] ) ) {
            echo '[INFO] pixel di Facebook non configurato' . PHP_EOL;
        } else {
            echo '[ -- ] pixel di Facebook attivo: ' . $cf['facebook']['profile']['pixel']['id'] . PHP_EOL;
        }
    }

    // controllo moduli
    foreach( $cf['mods']['active']['array'] as $mod ) {

        // output
        echo PHP_EOL;

        // output
        echo $mod . PHP_EOL;
        echo str_pad( '', strlen( $mod ), '-' ) . PHP_EOL;

        // output
        echo '[ -- ] modulo ' . $mod . ' attivo' . PHP_EOL;

        // report del modulo
        $reportMod = DIR_MOD . '_' . $mod . '/_src/_api/_status/_framework.php';

        // report del modulo
        if( file_exists( $reportMod ) ) {
            require $reportMod;
        } else {
            echo '[INFO] report per il modulo ' . $mod . ' non trovato' . PHP_EOL;
        }

    }

    // output
    echo PHP_EOL;

    // output
    echo '===============================' . PHP_EOL;
    echo 'FINE REPORT ' . date( 'Y-m-d H:i:s' ) . PHP_EOL . PHP_EOL;
