<?php

    /**
     *
     *
     *
     *
     * @file
     *
     */

    // debug
	// print_r( $_REQUEST );

    // innesco la GET
	// $_REQUEST['__view__'][ $ct['view']['id'] ] = array();

    // debug
	// print_r( $ct['page']['backurl'] );
/*
    // costruisco il backurl dall'id della backpage
	if( isset( $ct['view']['backpage'] ) ) {
	    $ct['view']['backurl'] = urlencode( $ct['pages'][ $ct['view']['backpage'] ]['url'][ $cf['localization']['language']['ietf'] ] . '?' . (
		( isset( $ct['etc']['table'] ) ) 
		? $ct['etc']['table'] . '[id]=' . $_REQUEST[ $ct['etc']['table'] ]['id'] . '&' . $ct['etc']['table'] . '[__method__]=get&__backurl__='
		: NULL
	    ) );
	}
*/

	// NOTA verificare che questa cosa non crei conflitti con il backurl generato in _default.form.php nelle sotto viste dei form
	if( isset( $ct['view']['etc']['__force_backurl__'] ) ) {
	    $backurl = $ct['page']['parents']['path'][ max( array_keys( $ct['page']['parents']['path'] ) ) ][ LINGUA_CORRENTE ];
	    $ct['page']['backurl'][ LINGUA_CORRENTE ] = backurlRegistra( $backurl );
	}

    if( ! isset( $ct['view']['extra']['cols'] ) ) {
        $ct['view']['extra']['cols'] = array();
    }

    // contatore per i campi della vista
	$i = 10;

    // campi della vista
	foreach( $ct['view']['cols'] as $field => $label ) {
		$ct['view']['fields'][ $i ] = $field;
	    $i += 10;
	}

    // id della vista
	if( ! isset( $ct['view']['id'] ) || empty( isset( $ct['view']['id'] ) ) ) {
	    $ct['view']['id'] = md5(
			$ct['page']['id'] . $ct['view']['table'] . $_SESSION['__view__']['__site__'] .
			( ( isset( $ct['form']['table'] ) && isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) ) ? $_REQUEST[ $ct['form']['table'] ]['id'] : NULL )
	    );
	}

    /*
    // filtri aggiuntivi
	if( isset( $_REQUEST['__filters__'] )  ) {
		if( isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__'] ) ) {
			$_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__'] = array_replace_recursive(
				$_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__'],
				$_REQUEST['__filters__']
			);
		} else {
			$_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__'] = $_REQUEST['__filters__'];
		}
	}
    */

	// filtri presettati
	if( isset( $ct['view']['__filters__'] ) ) {
        if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__'] ) ) {
			$_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__'] = $ct['view']['__filters__'];
        }
	}

	// report mode
	if( isset( $ct['view']['data']['__report_mode__'] ) ) {
		$_REQUEST['__view__'][ $ct['view']['id'] ]['__report_mode__'] = $ct['view']['data']['__report_mode__'];
	}

	// filesystem mode
	if( isset( $ct['view']['data']['__filesystem_mode__'] ) ) {
		$_REQUEST['__view__'][ $ct['view']['id'] ]['__filesystem_mode__'] = $ct['view']['data']['__filesystem_mode__'];
	}

	// filtri presettati
	if( isset( $ct['view']['__restrict__'] ) ) {
		$_REQUEST['__view__'][ $ct['view']['id'] ]['__restrict__'] = $ct['view']['__restrict__'];
	}

	// ordinamenti presettati
	if( isset( $ct['view']['__sort__'] ) ) {
        if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__sort__'] ) ) {
            foreach( $ct['view']['__sort__'] as $field => $direction ) {
                $_REQUEST['__view__'][ $ct['view']['id'] ]['__sort__'][ $field ] = $direction;
            }
        }
	}

	// paginazione presettata
	if( isset( $ct['view']['__pager__'] ) ) {
		if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__pager__'] ) ) {
			$_REQUEST['__view__'][ $ct['view']['id'] ]['__pager__'] = $ct['view']['__pager__'];
		}
	}

	// modalità di visualizzazione presettata
	if( isset( $ct['view']['__mode__'] ) ) {
		if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__mode__'] ) ) {
			$_REQUEST['__view__'][ $ct['view']['id'] ]['__mode__'] = $ct['view']['__mode__'];
		}
	}

	// die( print_r( $_REQUEST['__view__'][ $ct['view']['id'] ], true ) );

	// aggiungo le colonne da prelevare
	// $_REQUEST['__view__'][ $ct['view']['id'] ]['__fields__'] = array_keys( $ct['view']['cols'] );
	// $ct['view']['data']['__fields__'] = array_keys( $ct['view']['cols'] );
	$_REQUEST['__view__'][ $ct['view']['id'] ]['__fields__'] = arrayTrim( array_diff( array_keys( $ct['view']['cols'] ), $ct['view']['extra']['cols'] ) );

#    // aggiungo i campi di filtro
#	if( isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__'] ) ) {
#	    $ct['view']['data']['__filters__'] = $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__'];
#	}

#    // aggiungo la ricerca
#	if( isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__search__'] ) ) {
#	    $ct['view']['data']['__search__'] = $_REQUEST['__view__'][ $ct['view']['id'] ]['__search__'];
#	}

#    // aggiungo l'ordinamento
#	if( isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__sort__'] ) ) {
#	    $ct['view']['data']['__sort__'] = $_REQUEST['__view__'][ $ct['view']['id'] ]['__sort__'];
#	}

    // imposto la paginazione
	if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__pager__']['page'] ) ) {
	    $_REQUEST['__view__'][ $ct['view']['id'] ]['__pager__']['page'] = 0;
	}
	if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__pager__']['rows'] ) ) {
	    $_REQUEST['__view__'][ $ct['view']['id'] ]['__pager__']['rows'] = 20;
	}

	// TODO risolvere il problema per cui se la pagina corrente non contiene più righe (ad es. dopo una cancellazione) la paginazione non viene aggiornata
	// e ci si trova su una pagina bianca

#    // paginazione
#	$ct['view']['data']['__pager__'] = $_REQUEST['__view__'][ $ct['view']['id'] ]['__pager__'];

    // debug
	// print_r( $_REQUEST[ $ct['etc']['table'] ]['id'] );
	// print_r( $_REQUEST['__view__'][ $ct['view']['id'] ][ $ct['page']['id'] . '_' . $_REQUEST[ $ct['etc']['table'] ]['id'] ] );
/*
    // 
	if( isset( $ct['etc']['table'] ) && isset( $_REQUEST['__view__'][ $ct['view']['id'] ][ $ct['page']['id'] . '_' . $_REQUEST[ $ct['etc']['table'] ]['id'] ] ) ) {
	    $_REQUEST['__view__'][ $ct['view']['id'] ] = array_replace_recursive(
		$_REQUEST['__view__'][ $ct['view']['id'] ],
		$_REQUEST['__view__'][ $ct['view']['id'] ][ $ct['page']['id'] . '_' . $_REQUEST[ $ct['etc']['table'] ]['id'] ]
	    );
	}
*/
    // debug
	// print_r( $filters );
	// print_r( $ct['view']['data'] );
	// echo "stocazzo";
    // echo 'DEBUG';

    // prelevamento dei dati
	// controller( $cf['mysql']['connection'], $_REQUEST['__view__'][ $ct['view']['id'] ], $ct['view']['table'], METHOD_GET, NULL, $_REQUEST['__err__'][ $k ] );
	if( ! isset( $ct['view']['data']['__filesystem_mode__'] ) ) {
		controller(
            $cf['mysql']['connection'],
            $cf['memcache']['connection'],
            $ct['view']['data'],
            $ct['view']['table'],
            METHOD_GET,
            NULL,
            $_REQUEST['__err__'][ $ct['view']['id'] ],
            $_REQUEST['__view__'][ $ct['view']['id'] ]
        );
	}    
    
    // debug
    // echo 'DEBUG';
#print_r( $_REQUEST['__view__'][ $ct['view']['id'] ]);
#print_r( $_REQUEST['__view__'][ $ct['view']['id'] ]);
    // debug
	// echo 'dati: ' .  print_r( $ct['view']['data'], true );


    // campo di gestione di default
	if( ! isset( $ct['view']['open']['field'] ) ) {
	    $ct['view']['open']['field'] = 'id';
	}

    // tabella di gestione di default
	if( ! isset( $ct['view']['open']['table'] ) ) {
	    $ct['view']['open']['table'] = $ct['view']['table'];
	}

    // debug
	// echo $ct['view']['open']['table'] . PHP_EOL;

    // pagina di inserimento
	if( ! isset( $ct['view']['insert']['page'] ) && isset( $ct['view']['open']['page'] ) && ! isset( $ct['form']['table'] ) ) {
	    $ct['view']['insert']['page'] = $ct['view']['open']['page'];
	}

    // percorso della pagina di gestione
	if( isset( $ct['view']['open']['page'] ) && ! empty( $ct['view']['open']['page'] ) ) {
        if( getAclPermission( $ct['view']['table'], METHOD_PUT ) || getAclPermission( $ct['view']['table'], METHOD_GET ) ) {
            if( isset( $cf['contents']['pages'][ $ct['view']['open']['page'] ]['path'][ $cf['localization']['language']['ietf'] ] ) ) {
                $ct['view']['open']['path'] = $cf['contents']['pages'][ $ct['view']['open']['page'] ]['path'][ $cf['localization']['language']['ietf'] ];
            } else {
                die( 'la pagina di gestione ' . $ct['view']['open']['page'] . ' non è stata definita o non è valida' );
            }
        } else {
            // die( 'non hai i permessi per gestire la tabella ' . $ct['view']['table'] );
        }
    } else {
        // die( 'la pagina di gestione non è stata definita' );
    }

    // percorso della pagina di inserimento
	if( isset( $ct['view']['insert']['page'] ) && ! empty( $ct['view']['insert']['page'] ) ) {
        if( getAclPermission( $ct['view']['table'], METHOD_POST ) ) {
            if( isset( $cf['contents']['pages'][ $ct['view']['insert']['page'] ]['path'][ $cf['localization']['language']['ietf'] ] ) ) {
                $ct['view']['insert']['path'] = $cf['contents']['pages'][ $ct['view']['insert']['page'] ]['path'][ $cf['localization']['language']['ietf'] ];
            } else {
                die( 'la pagina di inserimento ' . $ct['view']['insert']['page'] . ' non è stata definita o non è valida' );
            }
        } else {
            // die( 'non hai i permessi per inserire dati nella tabella ' . $ct['view']['table'] );
        }
	} else {
        // die( 'la pagina di inserimento non è stata definita' );
    }

    // debug

    /**
     * IL COLSPAN DELLA RIGA DI TOTALE
     * ==============================
     *
     * Il footer della vista stampa una cella di etichetta larga quanto le colonne che precedono
     * quella totalizzata, e poi il valore: serve a mettere il totale ESATTAMENTE sotto la colonna
     * dei numeri che somma.
     *
     * CORRETTO IL 22/09/2026, ed era sbagliato da sempre. La ricerca girava su
     * `array_values( $ct['view']['cols'] )`, cioe' sulle ETICHETTE delle colonne ( "descrizione",
     * "imponibile" ), mentre $field e' il NOME del campo ( "importo_netto_totale" ): le due cose
     * coincidono solo per caso, quindi array_search() tornava `false` quasi sempre e nel markup
     * usciva `colspan=""`. Un attributo vuoto non e' un numero, e ogni browser decide da se' cosa
     * farne: e' il "in alcuni browser il totale non e' incolonnato" segnalato da Montanari.
     *
     * Va contata la POSIZIONE della colonna, quindi array_keys(); e vanno contate le colonne come
     * le rende il template, che itera su `view.fields` e non su `view.cols` - una colonna presente
     * nei dati ma senza etichetta occupa comunque la sua cella in ogni riga. Con un ripiego su
     * `cols` per le viste che i `fields` non li dichiarano.
     */
	if( isset( $ct['view']['footer']['cols'] ) ) {

		$colonne = ( ( ! empty( $ct['view']['fields'] ) && is_array( $ct['view']['fields'] ) )
			? array_values( $ct['view']['fields'] )
			: array_keys( $ct['view']['cols'] ) );

        // le colonne nascoste non occupano spazio a video: se stanno PRIMA di quella totalizzata e
        // le si conta, il totale scivola a destra di altrettante caselle
		$colonne = array_values( array_filter( $colonne, function( $campo ) use ( $ct ) {
			return ( strpos( (string) ( isset( $ct['view']['class'][ $campo ] ) ? $ct['view']['class'][ $campo ] : '' ), 'd-none' ) === false );
		} ) );

		foreach( $ct['view']['footer']['cols'] as $field => $data ) {

			$posizione = array_search( $field, $colonne );

            // una colonna che non c'e' non puo' dettare un colspan: si lascia 1, che e' il minimo
            // valido, invece di scrivere un attributo vuoto
			$ct['view']['footer']['cols'][ $field ]['colspan'] = ( ( $posizione === false ) ? 1 : max( 1, (int) $posizione ) );

		}

	}

    if( ! empty( $ct['view']['data'] ) && is_array( $ct['view']['data'] ) ) {
		foreach ( $ct['view']['data'] as &$row ) {
			if( ! empty( $row ) && is_array( $row ) ) {
				foreach( $row as $field => $value ) {
					if( isset( $ct['view']['footer']['cols'][ $field ] ) ) {
						switch( $ct['view']['footer']['cols'][ $field ]['function'] ) {
							case 'SUM':
								if( isset( $ct['view']['footer']['cols'][ $field ]['value'] ) ) {
									$ct['view']['footer']['cols'][ $field ]['value'] += $value;
								} else {
									$ct['view']['footer']['cols'][ $field ]['value'] = $value;
								}
							break;
						}
					}
					if( strpos( $field, 'ora_' ) !== FALSE ) {
						if( ! empty( $value ) ) {
							if( preg_match( '/^([0-9]{2}):([0-9]{2}):([0-9]{2})$/', $value ) ) {
								$row[ $field ] = substr( $value, 0, 5 );
							}
						}
					}
                    /*
                     * LE DATE SI LEGGONO ALL'ITALIANA ( segnalazione Stefano Zoli del 22/09/2026 )
                     *
                     * Le viste tornano le date come le scrive MySQL, AAAA-MM-GG, e il template le
                     * stampa cosi' come sono ( {{ row[key]|raw }} in _inc/view.html ): in ogni
                     * elenco e in ogni ricerca si leggeva "2026-09-22". Qui diventano GG/MM/AAAA,
                     * con lo stesso criterio del ramo delle ore qui sopra: si guarda il NOME del
                     * campo e poi si converte solo se il valore ha davvero la forma di una data.
                     *
                     * Il preg_match non e' un di piu'. Un campo che porta "data" nel nome puo'
                     * contenere un timestamp, una data gia' formattata o una stringa vuota, e una
                     * conversione a scatola chiusa le rovinerebbe tutte; l'anno maggiore di zero
                     * scarta le date nulle di MySQL, che altrimenti uscirebbero come 00/00/0000.
                     *
                     * L'ordinamento non passa di qui — lo fa MySQL sulla colonna vera — e la
                     * ricerca per data continua a funzionare perche' _controller.tools.php
                     * riconosce anche i termini scritti all'italiana e li ritraduce in ISO.
                     */
					if( strpos( $field, 'data' ) !== FALSE ) {
						if( ! empty( $value ) ) {
							if( preg_match( '/^([0-9]{4})-([0-9]{2})-([0-9]{2})$/', $value, $data ) && $data[1] > 0 ) {
								$row[ $field ] = $data[3] . '/' . $data[2] . '/' . $data[1];
							}
						}
					}
				}
			}
		}

        // il riferimento va sciolto SUBITO dopo il ciclo
        //
        // $row qui sopra e' preso per riferimento, e in PHP a fine ciclo resta agganciato all'ultimo
        // elemento di $ct['view']['data']. Chiunque piu' avanti riusi il nome $row - una macro di
        // modulo, un custom di progetto, un altro ciclo in questo stesso file - non scrive nella sua
        // variabile ma SOVRASCRIVE L'ULTIMA RIGA DELLA VISTA, e la sostituisce con una copia della
        // penultima. Il sintomo e' un elenco in cui l'ultima riga e' un doppione di quella prima e
        // una riga vera sparisce, senza nessun errore da nessuna parte.
        //
        // Trovato il 04/09/2026 su Lughese: una macro di progetto che riordinava le righe d'offerta
        // con un proprio foreach su $row si e' vista sparire l'ultima riga e comparire due volte la
        // penultima. Il difetto pero' e' qui, non li'.
		unset( $row );

	}	

    // debug
	// print_r( $_REQUEST['__view__'][ $ct['view']['id'] ] );
	// print_r( $_SESSION );
	// print_r( $_REQUEST );
	// var_dump( $ct['view']['table'] );
	// echo 'dati: ' .  print_r( $ct['view']['data'], true );
	// print_r( $_REQUEST['__err__'][ $k ] );
	// print_r( $ct['view']['data'] );
	// print_r( $ct['view']['open'] );
	// print_r( $ct['pages'] );
	// print_r( $ct['view']['footer']['cols'] );
