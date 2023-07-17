<?php

    /**
     *
     *
     *
     * @todo finire di documentare
     *
     * @file
     *
     */

    /**
     *
     *
     * @todo documentare
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
     *
     *
     * @todo documentare
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

    function getAvailableCryptographyMethod() {


    }

    function getAvailableHashMethod() {

        $available = hash_algos();
        $preferred = array( 'sha3-512', 'sha512', 'md5' );

        $candidate = array_shift( array_intersect( $preferred, $available ) );

        return $candidate;

    }
