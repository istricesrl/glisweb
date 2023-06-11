<?php

    /**
     * configurazioni relative al debug del sistema
     *
     * debug, monitoraggio e troubleshooting
     * =====================================
     * Il framework GlisWeb mette a disposizione degli sviluppatori e degli utenti un completo e potente ventaglio di
     * strumenti per il debug, il monitoraggio del funzionamento, la risoluzione dei problemi. Fra tutti, il sistema di
     * log è sicuramente il più importante, ed è fondamentale comprenderne il funzionamento per poter utilizzare
     * il framework al massimo del suo potenziale. La colonna portante del sistema di log è la funzione logWrite()
     * della libreria _log.utils.php, e il suo funzionamento si basa sui dati impostati un questo file e nella sua
     * controparte custom.
     *
     * livelli di log
     * --------------
     * Il livello di log della piattaforma determina quali eventi vengono salvati in /var/log/*
     * e quali no. Per il livello di log si utilizzano le costanti standard di PHP
     * (http://it2.php.net/manual/en/function.syslog.php):
     *
     * costante         | valore | dettagli
     * -----------------|--------|--------------------------------------------------------------
     * LOG_EMERG        |   0    | il sistema è inutilizzabile
     * LOG_ALERT        |   1    | è richiesto un intervento immediato
     * LOG_CRIT         |   2    | situazione critica
     * LOG_ERR          |   3    | errore
     * LOG_WARNING      |   4    | avviso
     * LOG_NOTICE       |   5    | situazione notevole
     * LOG_INFO         |   6    | informazione
     * LOG_DEBUG        |   7    | debug
     *
     * gravità degli eventi
     * --------------------
     * Il livello di gravità degli eventi ne indica l'importanza relativamente al funzionamento
     * del framework. Per il livello di gravità degli errori si utilizzano le costanti standard
     * di php (http://it2.php.net/manual/en/errorfunc.constants.php):
     *
     * costante              | valore   | dettagli
     * ----------------------|----------|-------------------------------------------------------
     * E_ERROR               |   1      | errore fatale, l'esecuzione viene terminata
     * E_WARNING             |   2      | errore non fatale, l'esecuzione prosegue ma può dare risultati imprevisti
     * E_PARSE               |   4      | errore di parsing durante la compilazione; questo livello è riservato al parser
     * E_NOTICE              |   8      | evento notevole, ma non necessariamente un errore
     * E_CORE_ERROR          |   16     | errore fatale PHP; riservato al core PHP
     * E_CORE_WARNING        |   32     | errore non fatale PHP; riservato al core PHP
     * E_COMPILE_ERROR       |   64     | errore fatale di compilazione; riservato allo Zend Scripting Engine
     * E_COMPILE_WARNING     |   128    | errore non fatale di compilazione; riservato allo Zend Scripting Engine
     * E_USER_ERROR          |   256    | errore generato tramite la funzione trigger_error()
     * E_USER_WARNING        |   512    | avviso generato tramite la funzione trigger_error()
     * E_USER_NOTICE         |   1024   | evento notevole segnalato tramite la funzione trigger_error()
     * E_STRICT              |   2048   | violazione formale
     * E_RECOVERABLE_ERROR   |   4096   | errore fatale ma gestibile, non pregiudica il funzionamento del core PHP
     * E_DEPRECATED          |   8192   | errore di obsolescenza
     * E_USER_DEPRECATED     |   16384  | errore di obsolescenza generato tramite la funzione trigger_error()
     * E_ALL                 |   32767  | tutti i messaggi di errore
     *
     *
     *
     * @todo scrivere un paragrafo per tutti gli stati di funzionamento del framework
     * @todo scrivere un paragrafo per spiegare il senso delle chiavi di $cf['debug']['lvl']
     * @todo suddividere le configurazioni di log e debug fra test e produzione
     *
     * @file
     *
     */

    // costanti che descrivono lo stato di funzionamento del framework
	define( 'DEVELOPEMENT'					, 'DEV' );
	define( 'TESTING'				    	, 'TEST' );
	define( 'PRODUCTION'					, 'PROD' );

    // costanti che definiscono le destinazioni possibili di log
	define( 'LOG_TO_FILE'					, 'LOG2FILE' );
	define( 'LOG_TO_SYSLOG'					, 'LOG2SYS' );
	define( 'LOG_TO_GOOGLE'					, 'LOG2GCE' );
	define( 'LOG_TO_MAIL'					, 'LOG2MAIL' );
	define( 'LOG_TO_SMS'					, 'LOG2SMS' );
	define( 'LOG_TO_MYSQL'					, 'LOG2MYSQL' );

    /*
     * @todo alcuni di questi metodi di log sono ancora da implementare e credo sia importante farlo
     * per migliorare la reattività nella risposta a determinati eventi problematici o addirittura critici
     */

    // livello di errori dei log
	$cf['debug'][ DEVELOPEMENT ]['*']['log']['lvl']		        = LOG_DEBUG;

    // frequenza di rotazione dei log
	$cf['debug'][ DEVELOPEMENT ]['*']['log']['rotation']		= 'Ym';

    // livello di PHP error_reporting()
	$cf['debug'][ DEVELOPEMENT ]['*']['report']['lvl']		    = E_USER_WARNING;

    // destinazione dei log
	$cf['debug'][ DEVELOPEMENT ]['*']['target']['*']		    = array( LOG_TO_FILE => true );

    // impostazioni aggiuntive per TESTING
	$cf['debug'][ TESTING ]				                        = $cf['debug'][ DEVELOPEMENT ];
	$cf['debug'][ TESTING ]['*']['log']['lvl']		            = LOG_NOTICE;
	$cf['debug'][ TESTING ]['*']['report']['lvl']		        = E_USER_WARNING;

    // impostazioni aggiuntive per PRODUCTION
	$cf['debug'][ PRODUCTION ]				                    = $cf['debug'][ DEVELOPEMENT ];
	$cf['debug'][ PRODUCTION ]['*']['log']['lvl']		        = LOG_ERR;
	$cf['debug'][ PRODUCTION ]['*']['report']['lvl']	        = E_USER_WARNING;

    // debug utilizzo memoria
	$cf['debug']['mem']					                        = array();

    // configurazione extra
	if( isset( $cx['debug'] ) ) {
	    $cf['debug'] = array_replace_recursive( $cf['debug'], $cx['debug'] );
	}

    // collegamento a $ct
	$ct['debug']						                        = &$cf['debug'];

    // debug
    // echo 'OUTPUT';
    // var_dump( setcookie( 'stocazzo', 'prova cookie' ) );
    setcookie( 'stocazzo', 'prova cookie' );
