<?php

    /**
     * libreria di funzioni per la crittografia
     * 
     * Questa libreria contiene alcune funzioni utili per crittografare e decrittare file e stringhe.
     * 
     * introduzione
     * ============
     * Questa libreria è stata creata per semplificare le operazioni più comnuni relative alla crittografia di file
     * e stringhe. Inoltre incapsulando le specifiche funzioni crittografiche di PHP, consente di mantenere il codice
     * aggiornato facilmente ogni volta che le conoscenze in materia di crittografia si evolvono.
     * 
     * costanti
     * ========
     * Questa libreria non definisce alcuna costante.
     * 
     * funzioni
     * ========
     * Questa libreria è molto semplice e le sue funzioni non sono divise in gruppi.
     * 
     * funzione                     | descrizione
     * -----------------------------|---------------------------------------------------------------
     * encryptString()              | crittografa una stringa
     * decryptString()              | decrittografa una stringa
     * getAvailableHashMethods()    | restituisce un array dei metodi di crittografia disponibili
     * getAvailableHashMethod()     | trova un metodo di crittografia disponibile
     * passwordHash()               | calcola l'hash di una password da salvare
     * passwordVerify()             | verifica una password contro l'hash salvato, anche in formato MD5
     * passwordNeedsRehash()        | dice se l'hash salvato va ricalcolato con l'algoritmo corrente
     * passwordIsMd5()              | dice se un hash è nel vecchio formato MD5
     * 
     * le password
     * ===========
     * Fino al 24/09/2026 le password venivano salvate come md5() della password in chiaro, senza salt: un
     * hash che si inverte in pochi secondi con una tabella precalcolata. Da allora si salvano con
     * password_hash() e l'algoritmo di default di PHP ( bcrypt ), che produce un hash di 60 caratteri con il
     * salt incorporato; la colonna account.password è char(128) e ha spazio anche per argon2.
     * 
     * Gli hash MD5 già salvati continuano a funzionare: passwordVerify() li riconosce dalla forma ( 32 cifre
     * esadecimali, che un hash di password_hash() non ha mai ) e li confronta come prima. Al primo login
     * riuscito di un account su database, _210.auth.php ricalcola l'hash con l'algoritmo nuovo e lo salva,
     * quindi il vecchio formato sparisce da solo man mano che gli utenti entrano. Gli account dei file di
     * configurazione non si possono riscrivere da qui: la pagina di status segnala se la password di root è
     * ancora in MD5, e il nuovo hash si genera con _src/_sh/_password.hash.sh.
     * 
     * 
     */

    /**
     * questa funzione crittografa una stringa
     * 
     * Questa funzione crittografa una stringa tramite una chiave di crittografia data, utilizzando la libreria OpenSSL.
     * 
     * @param       string      $s      la stringa da crittografare
     * @param       string      $k      la chiave di crittografia
     * 
     * @return      string              la stringa crittografata
     * 
     */
    function encryptString( $s, $k ) {

        // debug
        // echo "stringa di partenza: " . $s . PHP_EOL;

        // metodo di cifratura
        $crypt = "AES-128-CTR";

        // ...
        $ivl = openssl_cipher_iv_length( $crypt );

        // opzioni
        $options = 0;

        // ...
        $eiv = '1234567891011121';

        // cifratura della stringa
        $se = openssl_encrypt( $s, $crypt, $k, $options, $eiv );

        // debug
        // echo "stringa cifrata: " . $se . PHP_EOL;

        // restituisco la stringa cifrata
        return $se;

    }

    /**
     * questa funzione decrittografa una stringa
     * 
     * Questa funzione decrittografa una stringa crittografata tramite una chiave di crittografia data, utilizzando la libreria OpenSSL.
     * 
     * @param       string      $s      la stringa da decrittografare
     * @param       string      $k      la chiave di crittografia
     * 
     * @return      string              la stringa decrittografata
     * 
     */
    function decryptString( $s, $k ) {

        // debug
        // echo "stringa cifrata: " . $s . PHP_EOL;

        // metodo di cifratura
        $crypt = "AES-128-CTR";

        // ...
        $ivl = openssl_cipher_iv_length( $crypt );

        // opzioni
        $options = 0;

        // ...
        $div = '1234567891011121';

        // decifratura della stringa
        $ds = openssl_decrypt( $s, $crypt, $k, $options, $div );

        // debug
        // echo "stringa decifrata: " . $ds . PHP_EOL;

        // restituisco la stringa decifrata
        return $ds;

    }

    /**
     * questa funzione restituisce un array dei metodi di crittografia disponibili
     * 
     * Questa funzione restituisce un array contenente i metodi di crittografia disponibili tra quelli indicati come preferiti.
     * 
     * @return      array       l'array dei metodi di crittografia disponibili
     * 
     */
    function getAvailableHashMethods() {

        $available = hash_algos();
        $preferred = array( 'sha3-512', 'sha512', 'md5' );
        
        return array_intersect( $preferred, $available );

    }

    /**
     * questa funzione trova un metodo di crittografia disponibile
     * 
     * Questa funzione restituisce il primo metodo di crittografia disponibile tra quelli indicati come preferiti.
     * 
     * @return      string      il metodo di crittografia disponibile
     * 
     */
    function getAvailableHashMethod() {

        $algorithms = getAvailableHashMethods();
        $candidate = array_shift( $algorithms );

        return $candidate;

    }

    /**
     * questa funzione calcola l'hash di una password da salvare
     * 
     * Questa funzione restituisce l'hash di una password in chiaro, calcolato con l'algoritmo di default di PHP;
     * è l'unica funzione da usare quando si scrive una password nel database o nei file di configurazione.
     * 
     * @param       string      $p      la password in chiaro
     * 
     * @return      string              l'hash della password
     * 
     */
    function passwordHash( $p ) {

        return password_hash( (string) $p, PASSWORD_DEFAULT );

    }

    /**
     * questa funzione dice se un hash è nel vecchio formato MD5
     * 
     * Questa funzione restituisce true se l'hash passato è di 32 cifre esadecimali, cioè nel formato usato dal
     * framework per le password fino al 24/09/2026; un hash prodotto da passwordHash() non ha mai questa forma.
     * 
     * @param       string      $h      l'hash da esaminare
     * 
     * @return      bool                true se l'hash è in formato MD5, false altrimenti
     * 
     */
    function passwordIsMd5( $h ) {

        return is_string( $h ) && preg_match( '/^[a-f0-9]{32}$/i', $h ) === 1;

    }

    /**
     * questa funzione verifica una password contro l'hash salvato
     * 
     * Questa funzione confronta una password in chiaro con l'hash salvato, sia che l'hash sia stato prodotto da
     * passwordHash() sia che sia nel vecchio formato MD5; il confronto è sempre a tempo costante.
     * 
     * @param       string      $p      la password in chiaro
     * @param       string      $h      l'hash salvato
     * 
     * @return      bool                true se la password corrisponde all'hash, false altrimenti
     * 
     */
    function passwordVerify( $p, $h ) {

        // un hash vuoto non corrisponde a nessuna password
        if( ! is_string( $h ) || $h === '' ) {
            return false;
        }

        // vecchio formato MD5
        if( passwordIsMd5( $h ) ) {
            return hash_equals( strtolower( $h ), md5( (string) $p ) );
        }

        // formato di password_hash()
        return password_verify( (string) $p, $h );

    }

    /**
     * questa funzione dice se l'hash salvato va ricalcolato con l'algoritmo corrente
     * 
     * Questa funzione restituisce true se l'hash è nel vecchio formato MD5 oppure se è stato calcolato con un
     * algoritmo o un costo diversi da quelli correnti di PHP.
     * 
     * @param       string      $h      l'hash salvato
     * 
     * @return      bool                true se l'hash va ricalcolato, false altrimenti
     * 
     */
    function passwordNeedsRehash( $h ) {

        return passwordIsMd5( $h ) || password_needs_rehash( (string) $h, PASSWORD_DEFAULT );

    }

