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
     * apcuDelete()                     | cancella un dato dalla cache
     * apcuFlush()                      | cancella tutti i dati dalla cache
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
     * @param       string      $k      la chiave da modificare
     * 
     * @return      string               la chiave modificata
     * 
     */
    function apcuUniqueKey( &$k ) {

        if( strpos( $k, APCU_UNIQUE_SEED ) === false ) {
            $k = APCU_UNIQUE_SEED . $k;
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
     * @param       string      $key      la chiave di cui leggere l'età
     * 
     * @return      mixed                 il valore associato alla chiave, oppure false se la chiave non esiste
     *
     */
    function apcuGetKeyAge( $key ) {

        return apcuRead( apcuAddKeyAgeSuffix( $key ) );

    }

    /**
     * FUNZIONI PER LA SCRITTURA DEI DATI
     */

    /**
     * scrive un dato in cache
     * 
     * Questa funzione scrive un dato in cache. In particolare, serializza il dato e lo scrive in cache con la chiave specificata.
     * 
     * @param       string      $key      la chiave con cui scrivere il dato
     * 
     * @param       mixed       $data     il dato da scrivere
     *
     */
    function apcuWrite( $key, $data, $ttl = APCU_DEFAULT_TTL ) {

        apcuUniqueKey( $key );

        if( function_exists( 'apcu_store' ) ) {

            return apcu_store( $key, serialize( $data ), $ttl );

        }

        return false;

    }

    /**
     * cancella un dato dalla cache
     * 
     * Questa funzione cancella un dato dalla cache. In particolare, cancella la chiave specificata dalla cache.
     * 
     * @param       string      $key      la chiave da cancellare
     * 
     * @return      bool                  true se la chiave è stata cancellata, false altrimenti
     *
     */
    function apcuDelete( $key ) {

        apcuUniqueKey( $key );

        if( function_exists( 'apcu_delete' ) ) {

            return apcu_delete( $key );

        }

        return false;

    }

    /**
     * cancella tutti i dati dalla cache
     * 
     * Questa funzione cancella tutti i dati dalla cache (flush).
     * 
     * @return      bool                  true se la cache è stata svuotata, false altrimenti
     *
     */
    function apcuFlush() {

        if( function_exists( 'apcu_clear_cache' ) ) {

            return apcu_clear_cache();

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
     * @param       string      $key      la chiave da cui leggere il dato
     * 
     * @return      mixed                 il dato letto, oppure false se la chiave non esiste
     *
     */
    function apcuRead( $key ) {

        apcuUniqueKey( $key );

        if( function_exists( 'apcu_fetch' ) ) {

            return unserialize( apcu_fetch( $key ) );

        }

        return false;

    }
