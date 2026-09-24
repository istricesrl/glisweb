<?php

    /**
     * scheda di gestione del carrello
     *
     * @file
     *
     */

    // tabella gestita
	$ct['form']['table'] = 'carrelli';

	$ct['etc']['select']['articoli'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT id, __label__ FROM articoli_view' );

	// tendina dei siti gestiti dall'installazione, per poter attribuire un sito ai carrelli creati dal backend
	$ct['etc']['select']['siti'] = array();

	foreach( $cf['sites'] as $idSito => $sito ) {
		$ct['etc']['select']['siti'][] = array(
			'id'		=> $idSito,
			'__label__'	=> ( ! empty( $sito['__label__'] ) ) ? $sito['__label__'] : $idSito
		);
	}

	// carrello in scheda
	$idCarrello = ( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) ) ? $_REQUEST[ $ct['form']['table'] ]['id'] : NULL;

	// link per il recupero del carrello
	$ct['etc']['timestamp_inserimento'] = NULL;
	$ct['etc']['recupero'] = array( 'url' => NULL, 'motivo' => NULL );

	if( empty( $idCarrello ) ) {

		$ct['etc']['recupero']['motivo'] = 'il carrello non è ancora stato salvato';

	} else {

		// il timestamp di inserimento è la chiave di verifica del link di recupero al runlevel 710: se il
		// carrello ne è sprovvisto - tipicamente perché creato dal backend, dove non passa dalla controller
		// del front end - il link non potrebbe funzionare, quindi lo si valorizza alla prima apertura della
		// scheda; l'aggiornamento è idempotente perché tocca solo le righe con il campo ancora vuoto
		mysqlQuery(
			$cf['mysql']['connection'],
			'UPDATE carrelli SET timestamp_inserimento = coalesce( timestamp_pagamento, unix_timestamp( now() ) ) WHERE id = ? AND timestamp_inserimento IS NULL',
			array( array( 's' => $idCarrello ) )
		);

		$carrello = mysqlSelectRow(
			$cf['mysql']['connection'],
			'SELECT id_sito, timestamp_inserimento FROM carrelli WHERE id = ?',
			array( array( 's' => $idCarrello ) )
		);

		$ct['etc']['timestamp_inserimento'] = ( isset( $carrello['timestamp_inserimento'] ) ) ? $carrello['timestamp_inserimento'] : NULL;

		// 1 - pagina di provenienza registrata fra i metadati del carrello
		$pagina = NULL;

		if( ! empty( $cf['ecommerce']['recovery']['metadata'] ) ) {
			$pagina = mysqlSelectValue(
				$cf['mysql']['connection'],
				"SELECT testo FROM metadati WHERE id_carrello = ? AND nome = ? AND testo <> '' ORDER BY id DESC LIMIT 1",
				array(
					array( 's' => $idCarrello ),
					array( 's' => $cf['ecommerce']['recovery']['metadata'] )
				)
			);
		}

		// 2 - pagina configurata per il sito del carrello, montata sull'URL che quel sito ha nell'ambiente corrente
		if( empty( $pagina ) && ! empty( $carrello['id_sito'] ) && isset( $cf['sites'][ $carrello['id_sito'] ] ) && ! empty( $cf['ecommerce']['recovery']['pages'][ $carrello['id_sito'] ] ) ) {

			$sito = $cf['sites'][ $carrello['id_sito'] ];

			$pagina =
				$sito['protocols'][ SITE_STATUS ] . '://' .
				(
					( ! empty( $sito['hosts'][ SITE_STATUS ] ) )
					? $sito['hosts'][ SITE_STATUS ] . ( ( ! empty( $sito['domains'][ SITE_STATUS ] ) ) ? '.' : NULL )
					: NULL
				) .
				$sito['domains'][ SITE_STATUS ] . '/' .
				( ( ! empty( $sito['folders'][ SITE_STATUS ] ) ) ? $sito['folders'][ SITE_STATUS ] : NULL ) .
				$cf['ecommerce']['recovery']['pages'][ $carrello['id_sito'] ];

		}

		// composizione del link
		if( empty( $ct['etc']['timestamp_inserimento'] ) ) {

			$ct['etc']['recupero']['motivo'] = 'il carrello non ha un timestamp di inserimento';

		} elseif( empty( $pagina ) ) {

			$ct['etc']['recupero']['motivo'] =
				( empty( $carrello['id_sito'] ) )
				? 'il carrello non è associato ad alcun sito'
				: 'nessuna pagina di recupero configurata per il sito ' . $carrello['id_sito'];

		} else {

			$ct['etc']['recupero']['url'] =
				$pagina .
				( ( strpos( $pagina, '?' ) === false ) ? '?' : '&' ) .
				$cf['ecommerce']['recovery']['parameters']['cart'] . '=' . rawurlencode( $idCarrello ) . '&' .
				$cf['ecommerce']['recovery']['parameters']['timestamp'] . '=' . rawurlencode( $ct['etc']['timestamp_inserimento'] );

		}

	}

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
