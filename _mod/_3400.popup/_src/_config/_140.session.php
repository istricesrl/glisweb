<?php

    /**
     *
     *
     * Rilegge in sessione i popup che l'utente ha chiuso, salvati in un cookie da _940.session.php.
     *
     * NOTA sul nome del file, che risponde a un dubbio lasciato qui in precedenza ( "ho dovuto
     * metterlo in standard se no non lo leggeva, non so perché" ): il file si chiamava
     * _145.session.php e non veniva MAI incluso. Il loop dei runlevel in _src/_config.php elenca i
     * file da eseguire guardando solo dentro _src/_config/, e per ognuno cerca la controparte nei
     * moduli con uno str_replace del percorso: un file di modulo viene quindi caricato solo se
     * nella base ne esiste uno con LO STESSO NOME. Nella base non c'è nessun _145, quindi questo
     * file era codice morto e i popup chiusi tornavano ad aprirsi a ogni sessione nuova.
     * Rinominato in _140.session.php il 30/08/2026, che nella base c'è e fa lo stesso tipo di
     * lavoro ( raccoglie dati della richiesta e li mette in sessione ).
     *
     * @todo finire di documentare
     *
     * @file
     *
     */

     // recupero i popup chiusi
	if( isset( $_COOKIE['popup'] ) ) {
		if( !isset( $_SESSION['popup']['chiusi'] ) ){
			$_SESSION['popup']['chiusi'] = array();
		}
	    $_SESSION['popup']['chiusi'] = array_replace_recursive( unserialize( $_COOKIE['popup'] ), $_SESSION['popup']['chiusi'] );
	}
