<?php

    /**
     * macro di default per la gestione delle viste
     *
     *
     *
     * TODO documentare
     *
     */

    /**
     * backurl
     * =======
     * 
     * 
     * 
     */

    // backurl forzato
	// TODO verificare che questa cosa non crei conflitti con il backurl generato in _default.form.php nelle sotto viste dei form
	if( isset( $ct['view']['etc']['__force_backurl__'] ) ) {
	    $backurl = $ct['page']['parents']['path'][ max( array_keys( $ct['page']['parents']['path'] ) ) ][ LINGUA_CORRENTE ];
	    $backmd5 = md5( $backurl );
	    $_SESSION['backurls'][ $backmd5 ] = $backurl;
	    $ct['page']['backurl'][ LINGUA_CORRENTE ] = $backmd5;
	}

    /**
     * pagine correlate
     * ================
     * 
     * 
     * 
     */

    // campo di gestione di default
	if( ! isset( $ct['view']['open']['field'] ) ) {
	    $ct['view']['open']['field'] = 'id';
	}

    // tabella di gestione di default
	if( ! isset( $ct['view']['open']['table'] ) ) {
	    $ct['view']['open']['table'] = $ct['view']['table'];
	}

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
                // die( 'la pagina di gestione ' . $ct['view']['open']['page'] . ' non è stata definita o non è valida' );
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
                // die( 'la pagina di inserimento ' . $ct['view']['insert']['page'] . ' non è stata definita o non è valida' );
            }
        } else {
            // die( 'non hai i permessi per inserire dati nella tabella ' . $ct['view']['table'] );
        }
	} else {
        // die( 'la pagina di inserimento non è stata definita' );
    }

    /**
     * ID della vista
     * ==============
     * 
     * 
     * 
     */

    // generazione ID della vista
	if( ! isset( $ct['view']['id'] ) || empty( isset( $ct['view']['id'] ) ) ) {
	    $ct['view']['id'] = md5(
			$ct['page']['id'] . $ct['view']['table'] . $_SESSION['__view__']['__site__'] .
			( ( isset( $ct['form']['table'] ) && isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) ) 
                ? $_REQUEST[ $ct['form']['table'] ]['id'] 
                : NULL )
	    );
	}

    /**
     * colonne della vista
     * ===================
     * 
     * 
     * 
     */

    // colonne extra
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

    // aggiungo le colonne da prelevare
	$_REQUEST['__view__'][ $ct['view']['id'] ]['__fields__'] = arrayTrim( array_diff( array_keys( $ct['view']['cols'] ), $ct['view']['extra']['cols'] ) );

    /**
     * filtri della vista
     * ==================
     *  
     * 
     *
     */

    // filtri presettati
	if( isset( $ct['view']['__filters__'] ) ) {
        if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__'] ) ) {
			$_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__'] = $ct['view']['__filters__'];
        }
	}

	// filtri presettati
	if( isset( $ct['view']['__restrict__'] ) ) {
		$_REQUEST['__view__'][ $ct['view']['id'] ]['__restrict__'] = $ct['view']['__restrict__'];
	}

    /**
     * modalità report
     * ===============
     * 
     * 
     * 
     */

    // report mode
	if( isset( $ct['view']['data']['__report_mode__'] ) ) {
		$_REQUEST['__view__'][ $ct['view']['id'] ]['__report_mode__'] = $ct['view']['data']['__report_mode__'];
	}

    /**
     * modalità filesystem
     * ===================
     * 
     * 
     * 
     */

    // filesystem mode
	if( isset( $ct['view']['data']['__filesystem_mode__'] ) ) {
		$_REQUEST['__view__'][ $ct['view']['id'] ]['__filesystem_mode__'] = $ct['view']['data']['__filesystem_mode__'];
	}

    /**
     * ordinamenti e paginazione
     * =========================
     * 
     * 
     * 
     */

    // ordinamenti presettati
	if( isset( $ct['view']['__sort__'] ) ) {
        if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__sort__'] ) ) {
            foreach( $ct['view']['__sort__'] as $field => $direction ) {
                $_REQUEST['__view__'][ $ct['view']['id'] ]['__sort__'][ $field ] = $direction;
            }
        }
	}

    // imposto la paginazione
	if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__pager__']['page'] ) ) {
	    $_REQUEST['__view__'][ $ct['view']['id'] ]['__pager__']['page'] = 0;
	}

    // imposto il numero di righe per pagina
    if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__pager__']['rows'] ) ) {
	    $_REQUEST['__view__'][ $ct['view']['id'] ]['__pager__']['rows'] = 20;
	}

    /**
     * prelevamento dei dati
     * =====================
     * 
     * 
     * 
     */

    // prelevamento dei dati
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

    /**
     * footer della vista
     * ==================
     * 
     * 
     * 
     * 
     */

    // gestione footer
	if( isset( $ct['view']['footer']['cols'] ) ) {
		foreach( $ct['view']['footer']['cols'] as $field => $data ) {
			$ct['view']['footer']['cols'][ $field ]['colspan'] = array_search( $field, array_values( $ct['view']['cols'] ) );
		}
	}

    // elaborazione footer
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
				}
			}
		}
	}	

    /**
     * debug della vista
     * =================
     * 
     * 
     * 
     */

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
