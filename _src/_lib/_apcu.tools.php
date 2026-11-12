<?php

    /**
     * libreria per l'utilizzo di APCU
     *
     * Questa libreria è un wrapper per le funzioni di APCU, che permette di utilizzare questa cache in modo coerente alle altre cache
     * supportate dal framework. In questo modo utilizzare una cache piuttosto che un'altra è abbastanza semplice una volta capita
     * la logica generale con cui sono strutturate le librerie di caching del framework.
     * 
     * introduzione
     * ============
     * La cache APCU (https://www.php.net/manual/en/book.apcu.php) è una cache di tipo key-value, che permette di memorizzare dati in
     * modo facile e veloce, senza dover ricorrere a database o file system. La cache APCU è gestita direttamente dal PHP, quindi non
     * necessita di una connessione esplicita a un server.
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
     * cache APCU.
     * 
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * apcuUniqueKey()                  | aggiunge un seme univoco alla chiave, per evitare collisioni fra siti diversi
     * apcuAddKeyAgeSuffix()            | aggiunge il suffisso _AGE alla chiave, per memorizzare l'età della chiave
     * apcuGetKeyAge()                  | legge l'età di una chiave in cache
     * 
     * funzioni per la scrittura dei dati
     * ----------------------------------
     * Queste funzioni riguardano specificamente le operazioni di scrittura e cancellazione dei dati in cache.
     * 
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * apcuWrite()                      | scrive un dato in cache
     * apcuAdd()                        | scrive un dato in cache solo se la chiave non c'è ( per i lock )
     * apcuDelete()                     | cancella un dato dalla cache
     * apcuFlush()                      | cancella dalla cache i dati di un sito
     * 
     * funzioni per la lettura dei dati
     * --------------------------------
     * Queste funzioni riguardano la lettura dei dati in cache.
     * 
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * apcuRead()                       | legge un dato dalla cache
     * 
     * dipendenze
     * ==========
     * Questa libreria richiede alcune costanti che possono essere utilizzate per configurare il comportamento della cache APCU.
     * In particolare sono richieste le seguenti:
     * 
     * costante                 | spiegazione
     * -------------------------|--------------------------------------------------------------
     * APCU_UNIQUE_SEED         | un seme univoco per la chiave, che permette di evitare collisioni fra siti diversi
     * APCU_DEFAULT_TTL         | il tempo di vita di default di una chiave in cache, in secondi
     * 
     * changelog
     * =========
     * Questa sezione riporta la storia delle modifiche più significative apportate alla libreria.
     *
     * data             | autore               | descrizione
     * -----------------|----------------------|---------------------------------------------------------------
     * 2024-02-05       | Fabio Mosti          | refactoring completo della libreria
     * 2026-11-05       | Fabio Mosti          | apcuFlush() per sito: l'APCU di mod_php è una sola per tutti i deploy del server
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
     * Questa funzione aggiunge un seme univoco alla chiave, per evitare collisioni fra siti diversi. In questo modo è possibile
     * 
     * @param       string          $k      la chiave da modificare
     * @param       string|null     $site   il sito per cui modificare la chiave (opzionale, se non specificato si usa il sito corrente)
     * 
     * @return      string                  la chiave modificata
     * 
     */
    function apcuUniqueKey( &$k, $site = null ) {

        $prefix = ( isset( $site ) && !empty( $site ) ) ? strtoupper( str_replace( '.', '_', $site ) ) . '_' : APCU_UNIQUE_SEED;

        if( strpos( $k, $prefix ) !== 0 ) {
            $k = $prefix . $k;
        }

        return $k;

    }

    /**
     * aggiunge il suffisso _AGE alla chiave, per memorizzare l'età della chiave
     * 
     * Questa funzione aggiunge il suffisso _AGE alla chiave, per memorizzare l'età della chiave. In questo modo è possibile
     * generare una chiave che memorizzi l'età di un'altra chiave facilmente associabile alla chiave originale..
     * 
     * @param       string      $k      la chiave da modificare
     * 
     * @return      string               la chiave modificata
     *
     */
    function apcuAddKeyAgeSuffix( $k ) {

        if( substr( $k, -4 ) != '_AGE' ) {
            $k .= '_AGE';
        }

        return $k;

    }

    /**
     * legge l'età di una chiave in cache
     * 
     * Questa funzione legge l'età di una chiave in cache. In particolare, legge il valore associato alla chiave con il suffisso
     * _AGE, che è stato generato con la funzione apcuAddKeyAgeSuffix().
     * 
     * @param       string          $key      la chiave di cui leggere l'età
     * @param       string|null     $site     il sito della chiave (opzionale, se non specificato si usa il sito corrente)
     * 
     * @return      mixed                     il valore associato alla chiave, oppure false se la chiave non esiste
     *
     */
    function apcuGetKeyAge( $key, $site = null ) {

        return apcuRead( apcuAddKeyAgeSuffix( $key ), $site );

    }

    /**
     * FUNZIONI PER LA SCRITTURA DEI DATI
     */

    /**
     * scrive un dato in cache
     * 
     * Questa funzione scrive un dato in cache. In particolare, serializza il dato e lo scrive in cache con la chiave specificata.
     * 
     * @param       string          $key        la chiave con cui scrivere il dato
     * @param       mixed           $data       il dato da scrivere
     * @param       int             $ttl        il tempo di vita della chiave in cache, in secondi (default: APCU_DEFAULT_TTL)
     * @param       string|null     $site       il sito per cui scrivere il dato (opzionale, se non specificato si usa il sito corrente)
     * 
     * @return      bool                        true se il dato è stato scritto correttamente, false altrimenti
     *
     */
    function apcuWrite( $key, $data, $ttl = APCU_DEFAULT_TTL, $site = null ) {

        apcuUniqueKey( $key, $site );

        if( function_exists( 'apcu_store' ) ) {

            $r = apcu_store( $key, serialize( $data ), $ttl );
            apcu_store( apcuAddKeyAgeSuffix( $key ), serialize( time() ) );

            return $r;

        }

        return false;

    }

    /**
     * scrive un dato in cache solo se la chiave non c'è
     *
     * Questa funzione scrive il dato come apcuWrite(), ma con apcu_add(), che è atomica: se la chiave c'è già non scrive
     * niente e restituisce false. Serve per i lock ( vedi CONTENTS_PAGES_LOCK in _src/_config/_300.pages.php ), quindi non
     * scrive la chiave _AGE.
     *
     * @param       string          $key        la chiave con cui scrivere il dato
     * @param       mixed           $data       il dato da scrivere
     * @param       int             $ttl        il tempo di vita della chiave in cache, in secondi (default: APCU_DEFAULT_TTL)
     * @param       string|null     $site       il sito per cui scrivere il dato (opzionale, se non specificato si usa il sito corrente)
     *
     * @return      bool                        true se il dato è stato scritto, false se la chiave c'era già o se la scrittura non è riuscita
     *
     */
    function apcuAdd( $key, $data, $ttl = APCU_DEFAULT_TTL, $site = null ) {

        apcuUniqueKey( $key, $site );

        if( function_exists( 'apcu_add' ) ) {
            return apcu_add( $key, serialize( $data ), $ttl );
        }

        return false;

    }

    /**
     * cancella un dato dalla cache
     * 
     * Questa funzione cancella un dato dalla cache. In particolare, cancella la chiave specificata dalla cache, insieme
     * alla chiave che ne memorizza l'età.
     * 
     * @param       string          $key      la chiave da cancellare
     * @param       string|null     $site     il sito della chiave (opzionale, se non specificato si usa il sito corrente)
     * 
     * @return      bool                      true se la chiave è stata cancellata, false altrimenti
     *
     */
    function apcuDelete( $key, $site = null ) {

        apcuUniqueKey( $key, $site );

        if( function_exists( 'apcu_delete' ) ) {

            apcu_delete( apcuAddKeyAgeSuffix( $key ) );

            return apcu_delete( $key );

        }

        return false;

    }

    /**
     * cancella dalla cache i dati di un sito
     * 
     * Questa funzione cancella dalla cache le chiavi che cominciano con il seme del sito indicato, o del sito corrente se
     * non se ne indica uno. Non usa apcu_clear_cache(): con PHP in mod_php l'APCU è una sola per tutto il server, e svuotarla
     * vorrebbe dire svuotare la cache di tutti i deploy, non solo di questo ( fino al 2026-11-05 faceva così ). Come per
     * memcacheFlush(), per pulire tutti i siti del deploy si chiama la funzione per ciascuno ( vedi
     * _src/_api/_task/_memcache.clean.php ).
     * 
     * NOTA da riga di comando l'APCU è un'altra da quella di Apache ( e con apc.enable_cli a Off non c'è proprio ): un
     * flush lanciato da cron non svuota la cache vista dalle pagine
     * 
     * @param       string|null     $site     il sito da svuotare (opzionale, se non specificato si usa il sito corrente)
     * @param       array           $tieni    le chiavi da non cancellare, senza il seme ( p.es. il lock CONTENTS_PAGES_LOCK )
     * 
     * @return      bool                      true se le chiavi del sito sono state cancellate, false altrimenti
     *
     */
    function apcuFlush( $site = null, $tieni = array() ) {

        if( function_exists( 'apcu_enabled' ) && apcu_enabled() && class_exists( 'APCUIterator' ) ) {

            $prefix = '';
            apcuUniqueKey( $prefix, $site );

            $salve = array();
            foreach( $tieni as $s ) {
                apcuUniqueKey( $s, $site );
                $salve[] = $s;
            }

            $r = true;

            foreach( new APCUIterator( '/^' . preg_quote( $prefix, '/' ) . '/', APC_ITER_KEY ) as $k => $v ) {
                if( in_array( $k, $salve ) ) {
                    continue;
                }
                if( ! apcu_delete( $k ) && apcu_exists( $k ) ) {
                    $r = false;
                }
            }

            return $r;

        }

        return false;

    }

    /**
     * FUNZIONI PER LA LETTURA DEI DATI
     */

    /**
     * legge un dato dalla cache
     * 
     * Questa funzione legge un dato dalla cache in base alla chiave specificata e lo deserializza.
     * 
     * @param       string          $key      la chiave da cui leggere il dato
     * @param       string|null     $site     il sito per cui leggere il dato (opzionale, se non specificato si usa il sito corrente)
     * 
     * @return      mixed                     il dato letto, oppure false se la chiave non esiste
     *
     */
    function apcuRead( $key, $site = null ) {

        apcuUniqueKey( $key, $site );

        if( function_exists( 'apcu_fetch' ) ) {

            return unserialize( apcu_fetch( $key ) );

        }

        return false;

    }
