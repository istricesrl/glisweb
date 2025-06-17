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
     * Questa costante viene utilizzata per rappresentare il livello di log corrente, che influenza il comportamento
     * della funzione logger() definita in _src/_config.php.
     *
     */

    /**
     * applicazione delle configurazioni generali per il debug
     * =======================================================
     * In questa sezione vengono applicate le configurazioni generali per il debug relative ai timeout
     * di esecuzione e di connessione ai socket.
     * 
     * 
     */

    // tempo massimo di esecuzione
    ini_set( 'max_execution_time', $cf['debug']['run']['timeout'] );

    // timeout dei socket
    ini_set( 'default_socket_timeout', $cf['debug']['socket']['timeout'] );

    /**
     * configurazione del report degli errori a video
     * ==============================================
     * In questa sezione viene definito il comportamento del framework rispetto alla visualizzazione
     * degli errori tramite una chiamata a ini_set() sulla variabile display_errors e tramite
     * la funzione error_reporting() che imposta il livello di report degli errori. Vedi anche
     * https://www.php.net/manual/en/function.error-reporting.php.
     * 
     */

    // costante che descrive il livello corrente di report
    define( 'REPORT_CURRENT_LEVEL', $cf['debug'][ SITE_STATUS ]['report']['lvl'] );

    // determina se gli errori vengono mostrati o meno
    ini_set( 'display_errors', $cf['debug'][ SITE_STATUS ]['display'] );

    // determina quali errori vengono mostrati
    error_reporting( REPORT_CURRENT_LEVEL );

    /**
     * configurazione del log su file
     * ==============================
     * La costante LOG_CURRENT_LEVEL viene utilizzata per rappresentare il livello di log corrente,
     * che influenzando il comportamento della funzione logger() impatta sulla verbosità del log.
     * 
     */

    // costante per     logger() che descrive il livello corrente di log
    define( 'LOG_CURRENT_LEVEL', $cf['debug'][ SITE_STATUS ]['log']['lvl'] );

    /**
     * debug del runlevel
     * ==================
     * Questa sezione contiene, commentate, alcune istruzioni di debug per questo runlevel.
     * 
     */

    // debug
    // echo 'OUTPUT';
