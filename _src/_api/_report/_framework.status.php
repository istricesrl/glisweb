<?php

    /* tool per l'analisi del funzionamento del framework */

    // inclusione del framework
	require '../../_config.php';

    // header
	header( 'Content-type: text/plain' );

    // output
	echo 'STATUS DEL FRAMEWORK' . PHP_EOL . PHP_EOL;

    // versione di PHP
	if( ( version_compare( PHP_VERSION, '7.0.0' ) >= 0 ) ) {
	    echo '[ OK ] versione di PHP (' . PHP_VERSION . ') supportata: ' . PHP_VERSION . PHP_EOL;
	} else {
	    die( '[FAIL] versione di PHP (' . PHP_VERSION . ') non supportata: ' . PHP_VERSION . PHP_EOL );
	}

    // release del framework
	if( version_compare( RELEASE_CURRENT, RELEASE_LATEST ) == 0 ) {
	    echo '[ OK ] framework aggiornato alla release stable (' . RELEASE_CURRENT . ')' . PHP_EOL;
	} elseif( version_compare( RELEASE_CURRENT, RELEASE_LATEST ) == -1 ) {
	    echo '[WARN] stai usando una release obsoleta (' . RELEASE_CURRENT . ') rispetto alla stable ' . RELEASE_LATEST . PHP_EOL;
	} else {
	    echo '[INFO] stai usando una release di sviluppo (' . RELEASE_CURRENT . ') superiore alla stable ' . RELEASE_LATEST . PHP_EOL;
	}

    // versione del framework
	if( VERSION_CURRENT == VERSION_LATEST ) {
	    echo '[ OK ] framework aggiornato (' . VERSION_CURRENT . ')' . PHP_EOL;
	} elseif( VERSION_CURRENT < VERSION_LATEST ) {
	    echo '[WARN] stai usando una versione obsoleta (' . VERSION_CURRENT . ') rispetto a ' . VERSION_LATEST . PHP_EOL;
	} else {
	    echo '[INFO] stai usando una versione di sviluppo (' . VERSION_CURRENT . ') superiore a ' . VERSION_LATEST . PHP_EOL;
	}

	// output
	echo PHP_EOL;

    // directory base
	if( ! defined( 'DIR_BASE' ) ) {
	    die( '[FAIL] costante DIR_BASE non definita' . PHP_EOL );
	} else {
	    echo '[ -- ] directory base: ' . DIR_BASE . PHP_EOL;
	}

    // permessi di scrittura
	foreach( array_keys( $cf['debug']['fs']['folders'] ) as $dir ) {
	    if( is_dir( $dir ) && is_writeable( $dir ) ) {
		echo '[ OK ] posso scrivere su ' . shortPath( $dir ) . PHP_EOL;
	    } else {
		die( '[FAIL] non posso scrivere su ' . shortPath( $dir ) . PHP_EOL );
	    }
	}

    // permessi di scrittura
	foreach( array_keys( $cf['debug']['fs']['files'] ) as $file ) {
	    if( is_writeable( $file ) ) {
		echo '[ OK ] posso scrivere su ' . shortPath( $file ) . PHP_EOL;
	    } else {
		die( '[FAIL] non posso scrivere su ' . shortPath( $file ) . PHP_EOL );
	    }
	}

	// file di configurazione JSON
	if( ! file_exists( DIR_BASE . 'src/config/external/config.json' ) ) {
	    echo '[ -- ] file src/config/external/config.json non trovato' . PHP_EOL;
	    if( ! file_exists( DIR_BASE . 'src/config.json' ) ) {
		echo '[ -- ] file src/config.json non trovato' . PHP_EOL;
	    } else {
		echo '[ -- ] file src/config.json trovato' . PHP_EOL;
		if( jsonCheck( readFromFile( 'src/config.json', FILE_READ_AS_STRING ) ) ) {
		    echo '[ OK ] file src/config.json sintatticamente corretto' . PHP_EOL;
		} else {
		    die( '[FAIL] file src/config.json corrotto o malformato' . PHP_EOL );
		}
	    }
	} else {
	    echo '[ -- ] file src/config.json ignorato' . PHP_EOL;
	    echo '[ -- ] file src/config/external/config.json trovato' . PHP_EOL;
	    if( jsonCheck( readFromFile( 'src/config/external/config.json', FILE_READ_AS_STRING ) ) ) {
		echo '[ OK ] file src/config/external/config.json sintatticamente corretto' . PHP_EOL;
	    } else {
		die( '[FAIL] file src/config/external/config.json corrotto o malformato' . PHP_EOL );
	    }
	}

    // output
	echo PHP_EOL;

    // password di root
	if( ! isset( $cf['auth']['accounts']['root']['password'] ) ) {
	    echo '[ -- ] utente root non attivo' . PHP_EOL;
	} elseif( $cf['auth']['accounts']['root']['password'] == md5( 'test' ) || $cf['auth']['accounts']['root']['password'] == md5( 'root' ) ) {
	    die( '[FAIL] password di root troppo debole' . PHP_EOL );
	} else {
	    echo '[ OK ] utente root attivo con password non banale' . PHP_EOL;
	}

    // status del framework
	if( isset( $cf['site']['status'] ) ) {
	    echo '[ -- ] status del framework: ' . $cf['site']['status'] . PHP_EOL;
	} else {
	    die( '[FAIL] status del framework non impostato' . PHP_EOL );
	}

    // controllo del livello di log
	echo '[ -- ] livello di log: ' . logLvl2string( LOG_CURRENT_LEVEL ) . ' (' . LOG_CURRENT_LEVEL . ')' . PHP_EOL;
	if( $cf['site']['status'] == 'PROD' ) {
	    if( LOG_CURRENT_LEVEL > LOG_WARNING ) {
		echo '[WARN] livello di log alto per un ambiente di produzione, un I/O disco eccessivo può rallentare il framework' . PHP_EOL;
	    }
	}

    // dominio del framework
	if( isset( $cf['site']['fqdn'] ) && ! empty( $cf['site']['fqdn'] ) ) {
	    echo '[ -- ] FQDN del framework: ' . $cf['site']['fqdn'] . PHP_EOL;
	    if( checkdnsrr( $cf['site']['fqdn'], 'A' ) ) {
		echo '[ OK ] FQDN risolvibile correttamente (record A)' . PHP_EOL;
	    } elseif( checkdnsrr( $cf['site']['fqdn'], 'CNAME' ) ) {
		echo '[ OK ] FQDN risolvibile correttamente (record CNAME)' . PHP_EOL;
	    } else {
		echo '[WARN] FQDN non risolvibile' . PHP_EOL;
	    }
	} else {
	    echo '[WARN] FQDN del framework non impostato' . PHP_EOL;
	}

    // multisito
	if( isset( $cf['site']['id'] ) ) {
	    echo '[ -- ] #id multisito corrente: ' . $cf['site']['id'] . PHP_EOL;
	}

    // pagina home
	if( empty( $cf['site']['home'] ) ) {
	    echo '[WARN] #id home corrente non impostato' . PHP_EOL;
	} else {
	    echo '[ OK ] #id home corrente: ' . $cf['site']['home'] . PHP_EOL;
	}

    // aggiornamento della sitemap
	if( empty( $cf['sitemap']['updated'] ) ) {
	    echo '[WARN] sitemap non presente' . PHP_EOL;
	} else {
	    echo '[ -- ] ultimo aggiornamento della sitemap: ' . date( 'Y-m-d H:i:s', $cf['sitemap']['updated'] ) . PHP_EOL;
	}

    // aggiornamento delle pagine
	if( empty( $cf['contents']['updated'] ) ) {
	    echo '[WARN] data di aggiornamento dei contenuti non disponibile' . PHP_EOL;
	} else {
	    echo '[ -- ] ultimo aggiornamento dei contenuti: ' . date( 'Y-m-d H:i:s', $cf['contents']['updated'] ) . PHP_EOL;
	}

    // output
	echo PHP_EOL;

    // controllo SMTP
    // NOTA vedi https://github.com/PHPMailer/PHPMailer/blob/master/examples/smtp_check.phps
	if( ! empty( $cf['smtp']['profiles'][ $cf['site']['status'] ]['servers'] ) ) {

		echo '[ -- ] SMTP configurato' . PHP_EOL;

		foreach( $cf['smtp']['profiles'][ $cf['site']['status'] ]['servers'] as $server ) {
			echo '[ -- ] test del server: ' . $cf['smtp']['servers'][ $server ]['address'] . PHP_EOL;
			$smtp = new PHPMailer\PHPMailer\SMTP;
			$smtp->Timeout = 5;
			// $smtp->do_debug = SMTP::DEBUG_CONNECTION;
			$c = $smtp->connect( $cf['smtp']['servers'][ $server ]['address'], $cf['smtp']['servers'][ $server ]['port'] );
			if( empty( $c ) ) {
				echo '[FAIL] impossibile connettersi ' . $smtp->getError()['error'] . PHP_EOL;
			} else {
				echo '[ OK ] connessione effettuata' . PHP_EOL;
				$e = $smtp->getServerExtList();
				if( !$smtp->hello( gethostname() ) ) {
					echo '[WARN] HELO fallito ' . $smtp->getError()['error'] . PHP_EOL;
				} else {
					echo '[ OK ] HELO ' . gethostname() . PHP_EOL;
				}
				if( is_array( $e ) && array_key_exists( 'STARTTLS', $e ) ) {
					echo '[ -- ] tento TLS...' . PHP_EOL;
					$tlsok = $smtp->startTLS();
					if( !$tlsok ) {
						echo '[WARN] TLS fallito ' . $smtp->getError()['error'] . PHP_EOL;
					}
					if( !$smtp->hello( gethostname() ) ) {
						echo '[WARN] HELO (2) fallito ' . $smtp->getError()['error'] . PHP_EOL;
					}
					$e = $smtp->getServerExtList();
				} else {
					echo '[INFO] TLS non rilevato' . PHP_EOL;
				}
				if( is_array( $e ) && array_key_exists( 'AUTH', $e ) ) {
					echo '[ -- ] tento AUTH...' . PHP_EOL;
					if( isset( $cf['smtp']['servers'][ $server ]['username'] ) ) {
						if( $smtp->authenticate( $cf['smtp']['servers'][ $server ]['username'], $cf['smtp']['servers'][ $server ]['password'] ) ) {
							echo '[ OK ] autenticazione effettuata' . PHP_EOL;
						} else {
							echo '[FAIL] impossibile autenticarsi' . $smtp->getError()['error'] . PHP_EOL;
						}
					}
				} else {
				echo '[INFO] AUTH non rilevato' . PHP_EOL;
				}
			}
	    }
	} else {
	    echo '[ -- ] SMTP non configurato' . PHP_EOL;
	}

    // output
	echo PHP_EOL;

    // controllo MySQL
	if( ! empty( $cf['mysql']['profiles'][ $cf['site']['status'] ]['servers'] ) ) {
	    echo '[ -- ] backend MySQL attivato' . PHP_EOL;
	    echo '[ -- ] server MySQL (' . $cf['site']['status'] . '): ' . implode( ', ', $cf['mysql']['profiles'][ $cf['site']['status'] ]['servers'] ) . PHP_EOL;
	    if( ! empty( $cf['mysql']['connection'] ) ) {
			echo '[ OK ] connessione MySQL su ' . $cf['mysql']['server']['address'] . ':' . $cf['mysql']['server']['port'] . ' presente' . PHP_EOL;
			echo '[ -- ] versione del server MySQL: ' . $cf['mysql']['server']['version'] . PHP_EOL;
			echo '[ -- ] database selezionato: ' . $cf['mysql']['server']['db'] . PHP_EOL;
/*
			echo '[ -- ] livello di patch: ' . $cf['mysql']['profile']['patch']['current'] . PHP_EOL;
			if( $cf['mysql']['profile']['patch']['current'] == $cf['mysql']['profile']['patch']['latest'] ) {
				echo '[ OK ] database aggiornato alla patch: ' . $cf['mysql']['profile']['patch']['latest'] . PHP_EOL;
			} elseif( $cf['mysql']['profile']['patch']['current'] < $cf['mysql']['profile']['patch']['latest'] ) {
				echo '[WARN] database non aggiornato alla patch: ' . $cf['mysql']['profile']['patch']['latest'] . PHP_EOL;
			} else {
				echo '[INFO] database successivo alla patch: ' . $cf['mysql']['profile']['patch']['latest'] . PHP_EOL;
			}
			$fails = glob( DIR_VAR_LOG . 'mysql/patch/fail/*.sql' );
			foreach( $fails as $fail ) {
				echo '[WARN] applicare manualmente la patch: ' . basename( $fail ) . PHP_EOL;
			}
*/
		} else {
			echo( '[FAIL] connessione assente' . PHP_EOL );
	    }
	} else {
	    echo '[ -- ] backend MySQL non attivato' . PHP_EOL;
	}

    // output
	echo PHP_EOL;

    // controllo memcache
	if( ! empty( $cf['memcache']['profiles'][ $cf['site']['status'] ]['servers'] ) ) {
	    echo '[ -- ] backend memcache attivato' . PHP_EOL;
	    if( ! empty( $cf['memcache']['connection'] ) ) {
		echo '[ OK ] connessione memcache su ' . $cf['memcache']['server']['address'] . ':' . $cf['memcache']['server']['port'] . ' presente' . PHP_EOL;
		if( ! empty( $cf['memcache']['stat']['hits'] ) ) {
			echo '[ -- ] utilizzati ' . $cf['memcache']['stat']['usage'] . ' (' . $cf['memcache']['stat']['percent'] . ')' . PHP_EOL;
			echo '[ -- ] ' . $cf['memcache']['stat']['hits'] . ' (hit rate ' . $cf['memcache']['stat']['hitrate'] . ' ' . ( ( floatval( $cf['memcache']['stat']['hitrate'] ) > 90.0 ) ? 'OK' : 'NO' ) . ')' . PHP_EOL;
		} else {
			die( '[FAIL] statistiche di memcache non ancora raccolte' . PHP_EOL );
		}
	    } else {
		die( '[FAIL] connessione memcache su ' . $cf['memcache']['server']['address'] . ':' . $cf['memcache']['server']['port'] . ' assente' . PHP_EOL );
	    }
	} else {
	    echo '[ -- ] backend memcache non attivato' . PHP_EOL;
	}

    // output
	echo PHP_EOL;

    // controllo redis
	if( ! empty( $cf['redis']['profiles'][ $cf['site']['status'] ]['servers'] ) ) {
	    echo '[ -- ] backend redis attivato' . PHP_EOL;
	    if( ! empty( $cf['redis']['connection'] ) ) {
		echo '[ OK ] connessione redis su ' . $cf['redis']['server']['address'] . ':' . $cf['redis']['server']['port'] . ' presente' . PHP_EOL;
	    } else {
		die( '[FAIL] connessione redis su ' . $cf['redis']['server']['address'] . ':' . $cf['redis']['server']['port'] . ' assente' . PHP_EOL );
	    }
	} else {
	    echo '[ -- ] backend redis non attivato' . PHP_EOL;
	}

    // output
	echo PHP_EOL;

    // controllo Twig
	if( isset( $cf['twig']['profile']['cache'] ) ) {
	    echo '[ -- ] cache Twig attiva' . PHP_EOL;
	} else {
	    echo '[ -- ] cache Twig non attiva' . PHP_EOL;
	}

    // output
	echo PHP_EOL;

    // pixel di Facebook
	if( ! isset( $cf['facebook']['pixel']['id'] ) || empty( $cf['facebook']['pixel']['id'] ) ) {
	    echo '[ -- ] pixel di Facebook non settato' . PHP_EOL;
	} else {
	    echo '[ OK ] pixel di Facebook: ' . $cf['facebook']['pixel']['id'] . PHP_EOL;
	}

    // output
	echo PHP_EOL;

    // controllo moduli
	foreach( $cf['mods']['active']['array'] as $mod ) {

	    // output
		echo '[ -- ] modulo ' . $mod . ' attivo' . PHP_EOL;

		// report del modulo
		$reportMod = DIR_MOD . '_' . $mod . '/_src/_api/_report/_framework.status.php';

		// report del modulo
		if( file_exists( $reportMod ) ) {
			require $reportMod;
		} else {
			echo '[INFO] report per il modulo ' . $mod . ' non trovato' . PHP_EOL;
		}

	    // output
		echo PHP_EOL;

	}

    // output
	echo 'FINE REPORT' . PHP_EOL . PHP_EOL;
