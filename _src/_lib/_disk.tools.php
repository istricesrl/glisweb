<?php

    /**
     * libreria per la cache chiave-valore su disco
     *
     * Questa libreria implementa una cache chiave-valore su file, con la stessa interfaccia delle librerie per APCU, Memcache e
     * Redis, così da poter essere usata come ultima riserva quando nessuna delle cache in memoria è disponibile. In questo modo
     * utilizzare una cache piuttosto che un'altra è abbastanza semplice una volta capita la logica generale con cui sono
     * strutturate le librerie di caching del framework.
     *
     * introduzione
     * ============
     * Ogni chiave è un file nella cartella DIR_VAR_SPOOL_CACHE ( var/spool/cache/ ), il cui nome è la chiave codificata con
     * rawurlencode(), quindi leggibile e senza collisioni. La cartella sta sotto var/spool/, che il .htaccess del framework chiude
     * in lettura via HTTP: la cache può contenere dati riservati ( p.es. i gruppi autorizzati a vedere le pagine ) e non deve
     * essere scaricabile. Non va confusa con la cache su disco delle pagine generate, delle query e di Twig ( var/cache/ ), che
     * è un'altra cosa e ha i suoi profili in $cf['cache'].
     *
     * La scrittura è atomica: il dato viene scritto in un file temporaneo nella stessa cartella e poi rinominato, così che una
     * lettura concorrente trovi sempre o il dato vecchio o quello nuovo, mai un file scritto a metà. Il file contiene il dato
     * serializzato insieme alla sua scadenza, che viene controllata in lettura; come per APCU, un TTL di 0 vuol dire che la chiave
     * non scade.
     *
     * costanti
     * ========
     * Questa libreria non definisce costanti proprie, ma richiede alcune costanti che devono essere definite in fase di configurazione
     * (vedi più avanti).
     *
     * funzioni
     * ========
     * Le funzioni di questa libreria sono divise in tre gruppi, le funzioni di utilità generale, quelle per la scrittura e quelle per
     * la lettura.
     *
     * funzioni di utilità generale
     * ----------------------------
     * Queste funzioni consentono di semplificare alcune operazioni generali necessarie per il modo in cui il framework utilizza la
     * cache su disco.
     *
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * diskUniqueKey()                  | aggiunge un seme univoco alla chiave, per evitare collisioni fra siti diversi
     * diskAddKeyAgeSuffix()            | aggiunge il suffisso _AGE alla chiave, per memorizzare l'età della chiave
     * diskGetKeyAge()                  | legge l'età di una chiave in cache
     * diskKeyPath()                    | restituisce il percorso del file che contiene una chiave
     *
     * funzioni per la scrittura dei dati
     * ----------------------------------
     * Queste funzioni riguardano specificamente le operazioni di scrittura e cancellazione dei dati in cache.
     *
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * diskWrite()                      | scrive un dato in cache
     * diskWriteFile()                  | scrive in modo atomico il contenuto di un file della cache
     * diskAdd()                        | scrive un dato in cache solo se la chiave non c'è ( per i lock )
     * diskDelete()                    | cancella un dato dalla cache
     * diskFlush()                      | cancella dalla cache i dati di un sito
     *
     * funzioni per la lettura dei dati
     * --------------------------------
     * Queste funzioni riguardano la lettura dei dati in cache.
     *
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * diskRead()                       | legge un dato dalla cache
     *
     * dipendenze
     * ==========
     * Questa libreria richiede alcune costanti che possono essere utilizzate per configurare il comportamento della cache su disco.
     * In particolare sono richieste le seguenti:
     *
     * costante                 | spiegazione
     * -------------------------|--------------------------------------------------------------
     * DIR_VAR_SPOOL_CACHE      | la cartella in cui vengono scritti i file della cache ( _src/_config.php )
     * DISK_UNIQUE_SEED         | un seme univoco per la chiave, che permette di evitare collisioni fra siti diversi ( _040.cache.php )
     * DISK_DEFAULT_TTL         | il tempo di vita di default di una chiave in cache, in secondi ( _045.cache.php, da $cf['disk']['ttl'] )
     *
     * changelog
     * =========
     * Questa sezione riporta la storia delle modifiche più significative apportate alla libreria.
     *
     * data             | autore               | descrizione
     * -----------------|----------------------|---------------------------------------------------------------
     * 2026-11-05       | Fabio Mosti          | prima versione, riserva della cache delle pagine quando manca memcache
     *
     * licenza
     * =======
     * Questa libreria fa parte del progetto GlisWeb (https://github.com/istricesrl/glisweb) ed è distribuita
     * sotto licenza Open Source. Fare riferimento alla pagina GitHub del progetto per i dettagli.
     *
     */

    /**
     * FUNZIONI DI UTILITÀ GENERALE
     */

    /**
     * aggiunge un seme univoco alla chiave, per evitare collisioni fra siti diversi
     *
     * Questa funzione aggiunge un seme univoco alla chiave, per evitare collisioni fra siti diversi dello stesso deploy, che
     * condividono la cartella della cache. Se viene indicato un sito si usa il seme di quel sito, altrimenti quello del sito corrente.
     *
     * @param       string          $k      la chiave da modificare
     * @param       string|null     $site   il sito per cui modificare la chiave (opzionale, se non specificato si usa il sito corrente)
     *
     * @return      string                  la chiave modificata
     *
     */
    function diskUniqueKey( &$k, $site = null ) {

        $prefix = ( isset( $site ) && !empty( $site ) ) ? strtoupper( str_replace( '.', '_', $site ) ) . '_' : DISK_UNIQUE_SEED;

        if( strpos( $k, $prefix ) !== 0 ) {
            $k = $prefix . $k;
        }

        return $k;

    }

    /**
     * aggiunge il suffisso _AGE alla chiave, per memorizzare l'età della chiave
     *
     * Questa funzione aggiunge il suffisso _AGE alla chiave, per memorizzare l'età della chiave. In questo modo è possibile
     * generare una chiave che memorizzi l'età di un'altra chiave facilmente associabile alla chiave originale.
     *
     * @param       string      $k      la chiave da modificare
     *
     * @return      string               la chiave modificata
     *
     */
    function diskAddKeyAgeSuffix( $k ) {

        if( substr( $k, -4 ) != '_AGE' ) {
            $k .= '_AGE';
        }

        return $k;

    }

    /**
     * legge l'età di una chiave in cache
     *
     * Questa funzione legge l'età di una chiave in cache. In particolare, legge il valore associato alla chiave con il suffisso
     * _AGE, che viene scritto da diskWrite() insieme al dato.
     *
     * @param       string          $key      la chiave di cui leggere l'età
     * @param       string|null     $site     il sito per cui leggere l'età (opzionale, se non specificato si usa il sito corrente)
     *
     * @return      mixed                     il timestamp della scrittura, oppure false se la chiave non esiste
     *
     */
    function diskGetKeyAge( $key, $site = null ) {

        return diskRead( diskAddKeyAgeSuffix( $key ), $site );

    }

    /**
     * restituisce il percorso del file che contiene una chiave
     *
     * Questa funzione restituisce il percorso del file in cui viene salvata una chiave, che deve già contenere il seme univoco.
     * La chiave viene codificata con rawurlencode(), quindi non può contenere barre o altri caratteri che escano dalla cartella.
     *
     * @param       string      $key      la chiave, già completa del seme univoco
     *
     * @return      string                il percorso assoluto del file
     *
     */
    function diskKeyPath( $key ) {

        return DIR_VAR_SPOOL_CACHE . rawurlencode( $key );

    }

    /**
     * FUNZIONI PER LA SCRITTURA DEI DATI
     */

    /**
     * scrive un dato in cache
     *
     * Questa funzione scrive un dato in cache. In particolare, serializza il dato insieme alla sua scadenza, lo scrive in un file
     * temporaneo e lo rinomina sul file della chiave, poi scrive allo stesso modo la chiave _AGE con il momento della scrittura.
     *
     * @param       string          $key        la chiave con cui scrivere il dato
     * @param       mixed           $data       il dato da scrivere
     * @param       int             $ttl        il tempo di vita della chiave in cache, in secondi (default: DISK_DEFAULT_TTL)
     * @param       string|null     $site       il sito per cui scrivere il dato (opzionale, se non specificato si usa il sito corrente)
     *
     * @return      bool                        true se il dato è stato scritto correttamente, false altrimenti
     *
     */
    function diskWrite( $key, $data, $ttl = DISK_DEFAULT_TTL, $site = null ) {

        diskUniqueKey( $key, $site );

        if( ! checkFolder( DIR_VAR_SPOOL_CACHE ) ) {
            logger( 'impossibile creare la cartella della cache su disco: ' . DIR_VAR_SPOOL_CACHE, 'disk' );
            return false;
        }

        $scadenza = ( $ttl > 0 ) ? time() + $ttl : 0;

        $r = diskWriteFile( diskKeyPath( $key ), serialize( array( 'scadenza' => $scadenza, 'dati' => $data ) ) );
        diskWriteFile( diskKeyPath( diskAddKeyAgeSuffix( $key ) ), serialize( array( 'scadenza' => $scadenza, 'dati' => time() ) ) );

        return $r;

    }

    /**
     * scrive in modo atomico il contenuto di un file della cache
     *
     * Questa funzione scrive il contenuto in un file temporaneo nella stessa cartella e lo rinomina sul file di destinazione:
     * rename() sullo stesso filesystem è atomica, quindi chi legge non trova mai un file scritto a metà. I permessi vengono
     * allargati al gruppo perché la cache può essere scritta dalla riga di comando e letta da Apache, o viceversa.
     *
     * @param       string      $f      il percorso del file da scrivere
     * @param       string      $t      il contenuto da scrivere
     *
     * @return      bool                true se il file è stato scritto, false altrimenti
     *
     */
    function diskWriteFile( $f, $t ) {

        $tmp = $f . '.' . getmypid() . '.' . mt_rand() . '.tmp';

        if( @file_put_contents( $tmp, $t ) === false ) {
            logger( 'impossibile scrivere il file temporaneo della cache su disco: ' . $tmp, 'disk' );
            return false;
        }

        @chmod( $tmp, 0664 );

        if( ! @rename( $tmp, $f ) ) {
            @unlink( $tmp );
            logger( 'impossibile rinominare il file temporaneo della cache su disco: ' . $f, 'disk' );
            return false;
        }

        return true;

    }

    /**
     * scrive un dato in cache solo se la chiave non c'è
     *
     * Questa funzione scrive il dato come diskWrite(), ma apre il file con fopen( 'x' ), che è atomica: se il file c'è già
     * non scrive niente e restituisce false; una chiave scaduta la toglie prima diskRead(). Serve per i lock ( vedi
     * CONTENTS_PAGES_LOCK in _src/_config/_300.pages.php ), quindi non scrive la chiave _AGE.
     *
     * @param       string          $key        la chiave con cui scrivere il dato
     * @param       mixed           $data       il dato da scrivere
     * @param       int             $ttl        il tempo di vita della chiave in cache, in secondi (default: DISK_DEFAULT_TTL)
     * @param       string|null     $site       il sito per cui scrivere il dato (opzionale, se non specificato si usa il sito corrente)
     *
     * @return      bool                        true se il dato è stato scritto, false se la chiave c'era già o se la scrittura non è riuscita
     *
     */
    function diskAdd( $key, $data, $ttl = DISK_DEFAULT_TTL, $site = null ) {

        if( diskRead( $key, $site ) !== false ) {
            return false;
        }

        diskUniqueKey( $key, $site );

        if( ! checkFolder( DIR_VAR_SPOOL_CACHE ) ) {
            logger( 'impossibile creare la cartella della cache su disco: ' . DIR_VAR_SPOOL_CACHE, 'disk' );
            return false;
        }

        $scadenza = ( $ttl > 0 ) ? time() + $ttl : 0;

        $h = @fopen( diskKeyPath( $key ), 'x' );

        if( $h === false ) {
            return false;
        }

        $r = ( fwrite( $h, serialize( array( 'scadenza' => $scadenza, 'dati' => $data ) ) ) !== false );
        fclose( $h );

        @chmod( diskKeyPath( $key ), 0664 );

        return $r;

    }

    /**
     * cancella un dato dalla cache
     *
     * Questa funzione cancella un dato dalla cache, insieme alla chiave _AGE che ne registra l'età.
     *
     * @param       string          $key      la chiave da cancellare
     * @param       string|null     $site     il sito per cui cancellare il dato (opzionale, se non specificato si usa il sito corrente)
     *
     * @return      bool                      true se la chiave è stata cancellata, false altrimenti
     *
     */
    function diskDelete( $key, $site = null ) {

        diskUniqueKey( $key, $site );

        @unlink( diskKeyPath( diskAddKeyAgeSuffix( $key ) ) );

        return @unlink( diskKeyPath( $key ) );

    }

    /**
     * cancella dalla cache i dati di un sito
     *
     * Questa funzione cancella i file della cartella della cache le cui chiavi cominciano con il seme del sito indicato, o del
     * sito corrente se non se ne indica uno, compresi i temporanei di una scrittura interrotta; come apcuFlush() e
     * memcacheFlush(), per pulire tutti i siti del deploy si chiama la funzione per ciascuno.
     *
     * @param       string|null     $site     il sito da svuotare (opzionale, se non specificato si usa il sito corrente)
     * @param       array           $tieni    le chiavi da non cancellare, senza il seme ( p.es. il lock CONTENTS_PAGES_LOCK )
     *
     * @return      bool                      true se la cache del sito è stata svuotata, false altrimenti
     *
     */
    function diskFlush( $site = null, $tieni = array() ) {

        if( ! is_dir( DIR_VAR_SPOOL_CACHE ) ) {
            return true;
        }

        $prefix = '';
        diskUniqueKey( $prefix, $site );
        $prefix = rawurlencode( $prefix );

        $salve = array();
        foreach( $tieni as $s ) {
            diskUniqueKey( $s, $site );
            $salve[] = rawurlencode( $s );
        }

        $r = true;

        foreach( glob( DIR_VAR_SPOOL_CACHE . '*' ) as $f ) {
            if( in_array( basename( $f ), $salve ) ) {
                continue;
            }
            if( strpos( basename( $f ), $prefix ) === 0 && is_file( $f ) && ! @unlink( $f ) ) {
                $r = false;
            }
        }

        return $r;

    }

    /**
     * FUNZIONI PER LA LETTURA DEI DATI
     */

    /**
     * legge un dato dalla cache
     *
     * Questa funzione legge un dato dalla cache in base alla chiave specificata e lo deserializza; se la chiave è scaduta il file
     * viene cancellato e la funzione si comporta come se la chiave non esistesse.
     *
     * @param       string          $key      la chiave da cui leggere il dato
     * @param       string|null     $site     il sito per cui leggere il dato (opzionale, se non specificato si usa il sito corrente)
     *
     * @return      mixed                     il dato letto, oppure false se la chiave non esiste o è scaduta
     *
     */
    function diskRead( $key, $site = null ) {

        diskUniqueKey( $key, $site );

        $f = diskKeyPath( $key );

        if( ! is_file( $f ) ) {
            return false;
        }

        $c = @unserialize( @file_get_contents( $f ) );

        if( ! is_array( $c ) || ! array_key_exists( 'dati', $c ) ) {
            return false;
        }

        if( ! empty( $c['scadenza'] ) && $c['scadenza'] < time() ) {
            @unlink( $f );
            return false;
        }

        return $c['dati'];

    }
