<?php

    /**
     * libreria per la misurazione del tempo
     * 
     * Questa libreria conteneva le funzioni per cronometrare l'esecuzione del framework; oggi è vuota perché le
     * funzioni sono state spostate in _src/_config.php e qui ne resta soltanto la versione precedente, commentata.
     * 
     * introduzione
     * ============
     * Le funzioni timerNow(), timerDiff() e timerCheck() servono al framework fin dalle primissime righe di
     * _src/_config.php (per esempio per riempire $cf['speed'] con i tempi dei runlevel), cioè prima che le librerie
     * di _src/_lib/ vengano incluse; per questo motivo sono definite direttamente in _src/_config.php, dove si trovano
     * anche i loro docblock aggiornati. Il codice che segue è la vecchia versione delle stesse funzioni, lasciata
     * commentata come riferimento: NON va decommentata, perché ridichiarare le funzioni già definite in
     * _src/_config.php produrrebbe un errore fatale. La vecchia timerCheck() usava writeByte() di
     * _src/_lib/_string.tools.php per formattare la memoria, mentre quella attuale fa il calcolo da sé proprio perché
     * al momento in cui viene chiamata le librerie non sono ancora disponibili.
     * 
     * costanti
     * ========
     * Questa libreria non definisce costanti; le funzioni commentate usano START_TIME, definita in _src/_config.php.
     * 
     * funzioni
     * ========
     * Le funzioni di questa libreria sono divise in gruppi in base al lavoro che svolgono; nei paragrafi successivi le analizzeremo nel dettaglio.
     * 
     * funzioni di misurazione (disattivate)
     * -------------------------------------
     * Le funzioni in questo gruppo servivano per misurare i tempi di esecuzione; sono commentate e le versioni
     * attive si trovano in _src/_config.php.
     * 
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * timerNow()                       | restituisce la timestamp corrente in microsecondi
     * timerDiff()                      | restituisce il tempo trascorso fra due timestamp
     * timerCheck()                     | aggiunge un evento cronometrato a un array di eventi
     * 
     * dipendenze
     * ==========
     * Le funzioni commentate richiedevano le seguenti funzioni:
     * 
     * funzione                         | libreria di appartenenza
     * ---------------------------------|---------------------------------------------------------------
     * writeByte()                      | _src/_lib/_string.tools.php
     * 
     * changelog
     * =========
     * Questa sezione riporta la storia delle modifiche più significative apportate alla libreria.
     *
     * data             | autore               | descrizione
     * -----------------|----------------------|---------------------------------------------------------------
     * 2026-09-24       | Fabio Mosti          | documentazione
     * 
     * licenza
     * =======
     * Questa libreria fa parte del progetto GlisWeb (https://github.com/istricesrl/glisweb) ed è distribuita
     * sotto licenza Open Source. Fare riferimento alla pagina GitHub del progetto per i dettagli.
     * 
     */

    /**
     * FUNZIONI DI MISURAZIONE (DISATTIVATE)
     */

    /**
     * restituisce la timestamp corrente in microsecondi
     * 
     * Questa funzione, commentata, restituiva il risultato di microtime( true ), cioè la timestamp corrente in secondi
     * con la parte decimale fino ai microsecondi. La versione attiva è in _src/_config.php.
     * 
     * @return      float               la timestamp corrente in secondi, con i microsecondi come parte decimale
     * 
     */
    /*
    function timerNow() {

	return microtime( true );

    }
    */

    /**
     * restituisce il tempo trascorso fra due timestamp
     * 
     * Questa funzione, commentata, restituiva la differenza fra $now e $start; se $now è NULL viene usato il momento
     * corrente, se $start è omesso viene usato START_TIME, cioè l'avvio del framework. La versione attiva è in
     * _src/_config.php.
     * 
     * @param       float       $start      la timestamp di partenza (default START_TIME)
     * @param       float       $now        la timestamp di arrivo (default NULL, cioè adesso)
     * 
     * @return      float                   la differenza in secondi fra $now e $start
     * 
     */
    /*
    function timerDiff( $start = START_TIME, $now = NULL ) {

	if( $now === NULL ) { $now = microtime( true ); }

	return $now - $start;

    }
    */

    /**
     * aggiunge un evento cronometrato a un array di eventi
     * 
     * Questa funzione, commentata, aggiungeva all'array $a una riga con il tempo trascorso dall'avvio del framework,
     * il delta rispetto all'evento precedente (marcato OK se inferiore a un decimo di secondo, NO altrimenti), la
     * memoria in uso e la descrizione dell'evento, con le frecce -> sostituite da →. La chiave della riga è il tempo
     * preceduto da T, ed è da lì che la chiamata successiva ricava il tempo dell'ultimo evento; se l'array è vuoto
     * il tempo precedente vale zero. Per il formato delle righe si veda il docblock della versione attiva in
     * _src/_config.php.
     * 
     * @param       array       $a      l'array degli eventi, modificato per riferimento
     * @param       string      $c      la descrizione dell'evento
     * 
     * @return      void
     * 
     */
    /*
    function timerCheck( &$a, $c ) {

	$curTime = timerDiff();

	$lastTime = (
	    ( ! empty( $a ) )
		? round(
		    floatval( str_replace( ',', '.', substr( key( array_slice( $a, -1, 1, true ) ), 1 ) ) ), 5
		)
		: 0.0
	);

	$curDelta = ( round( $curTime, 5 ) - $lastTime );
	$curCheck = ( $curDelta < 0.1 ) ? 'OK' : 'NO';
	$curDelta = str_replace(',','.',sprintf( '%0.3f', $curDelta ));

	$curMemory = str_pad( writeByte( memory_get_usage( true ) ), 11, '-', STR_PAD_LEFT );

	$a[ 'T'.str_replace(',','.',sprintf('%024.21f',$curTime )) ] = 
	    str_pad( str_replace(',','.',sprintf( '%0.3f', $curTime )), 7, ' ', STR_PAD_LEFT ) .
	    str_pad( '(+' . $curDelta . ' ' . $curCheck . ')', 15, ' ', STR_PAD_LEFT ) .
	    str_pad( $curMemory, 15, ' ', STR_PAD_LEFT ) . ' → ' . str_replace( '->', '→', $c );

    }
    */
