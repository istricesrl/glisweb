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
