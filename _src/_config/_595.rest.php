<?php

    /**
     * chiamate REST in uscita
     *
     * introduzione
     * ============
     * Questo runlevel integra la configurazione delle chiamate REST letta dai file Json/Yaml e, durante i test
     * automatici, accende il finto REST ( vedi _590.rest.php ).
     *
     * finto REST acceso
     * -----------------
     * _src/_sh/_codeception.run.sh avvia il finto REST su 127.0.0.1 e ne scrive la porta in var/test/rest.mock; finche'
     * il file c'e' qui si definiscono REST_MOCK_URL e REST_MOCK_HOSTS, che restCall() legge a ogni chiamata. Come per
     * var/test/recaptcha.off ( _115.google.php ) non vale in produzione, e il file scade dopo un'ora, cosi' un giro di
     * test interrotto non lascia il sito a parlare con un servizio che non c'e' piu'; lo script lo ritocca prima di
     * ogni suite.
     *
     * Mentre il finto REST e' acceso tutto il sito DEV lo usa per gli host elencati, non solo il browser dei test.
     *
     */

    /**
     * integrazione della configurazione da file Json/Yaml
     * ===================================================
     *
     *
     */

    // configurazione extra
    if( isset( $cx['rest'] ) ) {
        $cf['rest'] = array_replace_recursive( $cf['rest'], $cx['rest'] );
    }

    // configurazione extra per sito
    if( isset( $cf['site']['rest'] ) ) {
        $cf['rest'] = array_replace_recursive( $cf['rest'], $cf['site']['rest'] );
    }

    /**
     * finto REST per i test
     * =====================
     *
     *
     */

    // deviazione delle chiamate verso il finto REST durante i test
    if( substr( SITE_STATUS, 0, strlen( PRODUCTION ) ) != PRODUCTION && file_exists( DIR_VAR . 'test/rest.mock' ) && filemtime( DIR_VAR . 'test/rest.mock' ) > time() - 3600 ) {
        define( 'REST_MOCK_URL', 'http://127.0.0.1:' . (int) file_get_contents( DIR_VAR . 'test/rest.mock' ) );
        define( 'REST_MOCK_HOSTS', array_merge( array( 'esempio.test' ), $cf['rest']['mock']['hosts'] ) );
    }
