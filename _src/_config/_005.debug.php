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
     *
     * @todo documentare questo paragrafo e rimandare al capitolo sulle costanti della documentazione tecnica
     *
     *
     * verifica delle cartelle dei log
     * -------------------------------
     *
     * @todo documentare questa parte
     *
     *
     * @todo finire di documentare
     *
     * @file
     *
     */

    // verifico la cartella temporanea
	checkFolder( DIR_TMP );

    // debug
	// error_reporting( E_ALL );
	// ini_set( 'display_errors', TRUE );

?>
