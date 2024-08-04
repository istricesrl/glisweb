<?php

    /**
     * applicazione dei livelli di debug
     *
     * In questo file vengono applicati i livelli di debug impostati in
     * _src/_config/_000.debug.php e src/config/000.debug.php.
     *
     * applicazione della configurazione
     * =================================
     * Proseguendo nella lettura dei commenti si troverà che spesso i file di configurazione del framework sono
     * organizzati a coppie, il primo file che contiene soprattutto definizioni mentre il secondo che contiene il
     * codice inteso ad applicare i valori definiti dal primo. Questa strategia consente di personalizzare i valori
     * creando una copia custom del primo file, senza necessità di riscrivere le logiche contenute nel secondo.
     *
     * errori visualizzati da Apache
     * -----------------------------
     * Il livello degli errori visualizzati nell'output viene settato utilizzando la funzione ini_set()
     * (http://it1.php.net/manual/it/function.ini-set.php) sulla variabile diaplay_errors alla quale
     * viene assegnato il valore di $cf['debug']['lvl']['report'].
     *
     * la costante LOG_CURRENT_LEVEL
     * -----------------------------
     * TODO documentare questo paragrafo e rimandare al capitolo sulle costanti della documentazione tecnica
     * TODO a tendere questa cosa potrebbe diventare obsoleta
     *
     *
     *
     * TODO documentare
     *
     *
     *
     */

    /**
     * configurazioni generali per il debug
     * ====================================
     * 
     * 
     */

    // tempo massimo di esecuzione
    ini_set( 'max_execution_time', $cf['debug']['run']['timeout'] );

    // timeout dei socket
    ini_set( 'default_socket_timeout', $cf['debug']['socket']['timeout'] );

    /**
     * sezione report
     * ==============
     * 
     * 
     */

    // costante che descrive il livello corrente di report
    define( 'REPORT_CURRENT_LEVEL', $cf['debug'][ SITE_STATUS ]['report']['lvl'] );

    // determina se gli errori vengono mostrati o meno
    ini_set( 'display_errors', $cf['debug'][ SITE_STATUS ]['display'] );

    // determina quali errori vengono mostrati
    error_reporting( REPORT_CURRENT_LEVEL );

    /**
     * sezione log
     * ===========
     * 
     * 
     */

    // costante per     logger() che descrive il livello corrente di log
    define( 'LOG_CURRENT_LEVEL', $cf['debug'][ SITE_STATUS ]['log']['lvl'] );
