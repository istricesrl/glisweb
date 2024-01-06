<?php

    /**
     * libreria per il log
     *
     * Questa libreria contiene alcune funzioni utili per la scrittura di file di log.
     *
     * costanti
     * ========
     * La libreria non definisce costanti proprie, tuttavia per funzionare correttamente
     * richiede che siano valorizzate le seguenti costanti globali.
     *
     * costante                  | spiegazione
     * --------------------------|--------------------------------------------------------------
     * DIR_VAR_LOG               | il percorso specifico dove scrivere i log (vedi _config.php)
     * LOG_CURRENT_LEVEL         | il livello degli eventi da scrivere (vedi _000.debug.php)
     *
     * dipendenze
     * ==========
     * Questa libreria richiede la libreria _filesystem.tools.php.
     *
     *
     *
     * @todo finire di documentare
     *
     * @file
     *
     */

    /**
     * scrive un messaggio nei log del sito
     *
     * I log del sito sono organizzati in factory e la rotazione avviene in maniera trasparente come nel vecchio standard tramite
     * l'append della data in formato AAMM al nome del file che pertanto risulta essere nomeFactory.AAMM.log la factory di default e' site
     * mentre il livello di gravita' di default e' LOG_NOTICE.
     *
     * @param	string		$m	il messaggio da scrivere
     * @param	string		$f	la factory su cui scrivere
     * @param	string		$d	la directory su cui scrivere
     * @param	int		$l	il livello di gravita' dell'evento (vedi sopra)
     * @param	int		$t	il livello di log corrente del sito
     * @param	int		$s	lo status corrente del sito
     *
     * @return	boolean			restituisce true se la scrittura ha avuto successo, false altrimenti
     *
     *
     *
     * @todo salvare anche l'url rewritato?
     *
     */
    function logWrite( $m, $f = 'site', $l = LOG_DEBUG, $d = DIR_VAR_LOG, $t = LOG_CURRENT_LEVEL, $s = SITE_STATUS ) {

	// globalizzazione di $cf
	    global $cf;

	// verifico se esiste un log level specifico per la factory
	    if( isset( $cf['debug'][ $s ][ $f ]['log']['lvl'] ) ) {
		$t = $cf['debug'][ $s ][ $f ]['log']['lvl'];
	    }

	// se il livello dell'evento e' inferiore o uguale al livello di log impostato correntemente, loggo l'evento
	    if( $l <= $t ) {

		// interrogo il backtrace
		    $r['btr']	= debug_backtrace();

		// tipo di rotazione
		    $r['lrs']	=
			( isset( $cf['debug'][ $s ][ $f ]['log']['rotation'] ) )
			? $cf['debug'][ $s ][ $f ]['log']['rotation']
			: $cf['debug'][ $s ]['*']['log']['rotation'];

		// dati del contesto
		    $r['lrd']	= date( $r['lrs'] );
		    $r['cdt']	= date( 'Y-m-d H:i:s' ) . ' ';
		    $r['lvl']	= logLvl2string( $l );
		    $r['lvs']	= strtolower( str_replace( 'LOG_', '', $r['lvl'] ) );
		    $r['btr']	= shortPath( $r['btr'][0]['file'] ) . ':'. $r['btr'][0]['line'];
		    $r['pid']	= trim( getmypid() );
		    $r['rad']	= trim( getenv( 'REMOTE_ADDR' ) );
		    $r['ref']	= trim( getenv( 'HTTP_REFERER' ) );
		    $r['rwu']	= trim( getenv( 'REDIRECT_URL' ) );
		    $r['sfn']	= trim( getenv( 'SCRIPT_FILENAME' ) . '?' . getenv( 'QUERY_STRING' ) );
		    $r['ses']	= session_id();
			$r['sts']   = $s;

		// compongo il nome del file di log
		    $r['log']	= $d . $f . '.' . $r['lrd'] . '.' . $r['lvs'] . '.log';

		// distanziatore
		    $spacer	= PHP_EOL . str_pad( '', strlen( $r['cdt'] ) );

		// distanziatore forzato
		    // $r['msg']	= str_replace( '§', $spacer, $m );

		// compongo il messaggio in formato testo
		    $msg	= $r['cdt']
				. ( ( ! empty( $r['pid'] ) ) ? 'pid: '				.$r['pid'] : '' )
				. ( ( ! empty( $r['sts'] ) ) ? ' status: '			.$r['sts'] : '' )
				. ( ( ! empty( $r['lvl'] ) ) ? ' level: '			.$r['lvl'] : '' )
				. ( ( ! empty( $r['rad'] ) ) ? ' remote address: '		.$r['rad'] : '' )
				. ( ( ! empty( $r['ses'] ) ) ? ' session: '			.$r['ses'] : '' )
				. ( ( ! empty( $r['ref'] ) ) ? $spacer . 'referer: '		.$r['ref'] : '' )
				. ( ( ! empty( $r['rwu'] ) ) ? $spacer . 'address: '		.$r['rwu'] : '' )
				. ( ( ! empty( $r['sfn'] ) ) ? $spacer . 'script: '		.$r['sfn'] : '' )
				. ( ( ! empty( $r['btr'] ) ) ? $spacer . 'file: '		.$r['btr'] : '' )
				. $spacer . str_replace( '§', $spacer, $m ) . PHP_EOL;

		// compongo il messaggio in formato Json
		    $jsn	= json_encode( $r );

		// verifico su quali target scrivere
		    if( isset(		$cf['debug'][ $s ][ $f ]['target'][ $l ] ) ) {
			$target	=	$cf['debug'][ $s ][ $f ]['target'][ $l ];
		    } elseif( isset(	$cf['debug'][ $s ][ $f ]['target']['*'] ) ) {
			$target	=	$cf['debug'][ $s ][ $f ]['target']['*'];
		    } elseif( isset(	$cf['debug'][ $s ]['*']['target'][ $l ] ) ) {
			$target	=	$cf['debug'][ $s ]['*']['target'][ $l ];
		    } else {
			$target	=	$cf['debug'][ $s ]['*']['target']['*'];
		    }

		// per ogni target
		    foreach( $target as $trg => $spc ) {

			// tipo di target
			    switch( $trg ) {

				case LOG_TO_FILE:
				    $x = appendToFile( $msg, $r['log'] );
				break;

				case LOG_TO_GOOGLE:
				    $x = log2google(
					$l,
					$cf['site']['fqdn'] . '.' . strtolower( $cf['site']['status'] ) . '.' . $f,
					$spc['pid'],
					str_replace( '§', "\n", $m ),
					$r
				    );
				break;

			    }

		    }

#		// se qualcosa va storto...
#		    if( $r === false ) {
#			error_log( $msg );
#		    }

	    }

	// debug
	    // echo $l . '/' . $t . ' -> ' . $m . PHP_EOL;

    }

	// TODO ma questa funzione non viene usata da nessuna parte?
	function logMsg( $m, &$o = NULL, &$a = array(), &$t = NULL ) {

		$o .= $m;

		$a[] = strip_tags( $m );

		if( $t !== NULL ) {
			timerCheck( $t, strip_tags( $m ) );
		}

	}
