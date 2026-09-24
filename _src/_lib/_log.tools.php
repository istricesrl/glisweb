<?php

    /**
     * libreria per l'invio dei log a servizi esterni
     *
     * Questa libreria contiene le funzioni per inviare messaggi di log a servizi esterni al server su cui gira il
     * framework; al momento l'unico servizio supportato è Google Cloud Logging.
     *
     * introduzione
     * ============
     * Il framework scrive normalmente i propri log su file tramite logger() e logWrite(); questa libreria affianca a
     * quel meccanismo la possibilità di spedire un messaggio a un servizio di logging remoto, utile quando i log
     * devono essere raccolti e consultati centralmente. Nessuna parte del framework chiama per ora queste funzioni:
     * sono a disposizione del codice di progetto.
     *
     * La libreria è di tipo tools e non dipende dall'array $cf: tutti i dati necessari (progetto, nome del log,
     * livello) vengono passati come parametri.
     *
     * costanti
     * ========
     * Questa libreria non definisce costanti.
     *
     * funzioni
     * ========
     * Le funzioni di questa libreria sono divise in gruppi in base al lavoro che svolgono; nei paragrafi successivi le
     * analizzeremo nel dettaglio.
     *
     * funzioni per Google Cloud Logging
     * ---------------------------------
     * Le funzioni in questo gruppo servono per inviare messaggi di log a Google Cloud Logging.
     *
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * log2google()                     | invia un messaggio di log a Google Cloud Logging
     *
     * dipendenze
     * ==========
     * Questa libreria non richiede funzioni di altre librerie del framework, ma richiede la classe esterna
     * Google\Cloud\Logging\LoggingClient del pacchetto composer google/cloud-logging, che NON è fra le dipendenze
     * dichiarate nel composer.json del framework e va quindi aggiunta dal progetto che vuole usare log2google();
     * senza di essa l'inclusione della libreria non dà errori (l'istruzione use non carica la classe) ma la
     * chiamata a log2google() termina con un errore fatale di classe non trovata.
     *
     * classe                           | libreria di appartenenza
     * ---------------------------------|---------------------------------------------------------------
     * LoggingClient                    | google/cloud-logging (composer, esterna)
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
     * @file
     *
     */

    // namespace
	use Google\Cloud\Logging\LoggingClient;

    /**
     * FUNZIONI PER GOOGLE CLOUD LOGGING
     */

    /**
     * invia un messaggio di log a Google Cloud Logging
     *
     * Questa funzione crea un client di Google Cloud Logging per il progetto indicato, ne ricava un logger PSR-3 per
     * il log con il nome dato e vi scrive il messaggio con la severità corrispondente al livello passato. I livelli
     * sono quelli di syslog, gli stessi delle costanti PHP LOG_EMERG (0) ... LOG_DEBUG (7) usate da logger(): 0
     * emergency, 1 alert, 2 critical, 3 error, 4 warning, 5 notice, 6 info, 7 debug. Un livello fuori dall'intervallo
     * 0-7 non produce alcun messaggio e non segnala errori. Le credenziali non vengono passate: il client le cerca
     * nell'ambiente secondo le regole della libreria Google (per i dettagli si veda
     * https://cloud.google.com/logging/docs/setup/php).
     *
     * La funzione non intercetta le eccezioni del client: un errore di autenticazione o di rete, così come
     * l'assenza della libreria google/cloud-logging, si propaga al chiamante.
     *
     * @param       int         $l      il livello di severità del messaggio, da 0 (emergency) a 7 (debug)
     * @param       string      $f      il nome del log su Google Cloud Logging
     * @param       string      $p      l'id del progetto Google Cloud
     * @param       string      $m      il messaggio da scrivere
     * @param       array       $r      il contesto PSR-3 del messaggio (array associativo di dati aggiuntivi)
     *
     * @return      void
     *
     */
    function log2google( $l, $f, $p, $m, $r ) {

	// logger di test
	    $logging = new LoggingClient([
		'projectId' => $p
	    ]);

	// logger PSR
	    $logger = $logging->psrLogger( $f );

	// messaggi di test
	    switch( $l ) {
		case 0:
		    $logger->emergency( $m, $r );
		break;
		case 1:
		    $logger->alert( $m, $r );
		break;
		case 2:
		    $logger->critical( $m, $r );
		break;
		case 3:
		    $logger->error( $m, $r );
		break;
		case 4:
		    $logger->warning( $m, $r );
		break;
		case 5:
		    $logger->notice( $m, $r );
		break;
		case 6:
		    $logger->info( $m, $r );
		break;
		case 7:
		    $logger->debug( $m, $r );
		break;
	    }

    }
