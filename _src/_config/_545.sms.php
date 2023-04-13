<?php

    /**
     * server e profili SMS
     *
     *
     *
     *
     *
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // link al profilo corrente
	$cf['sms']['profile']			= &$cf['sms']['profiles'][ $cf['site']['status'] ];

    // link al server corrente
	if( isset( $cf['sms']['profile']['servers'] ) && is_array( $cf['sms']['profile']['servers'] ) ) {
	    $cf['sms']['server']		= &$cf['sms']['servers'][ current( $cf['sms']['profile']['servers'] ) ];
	}

	// recupero dei template dal database
	$tpls = mysqlCachedIndexedQuery(
		$cf['memcache']['index'],
		$cf['memcache']['connection'],
		$cf['mysql']['connection'],
		'SELECT * FROM template WHERE se_sms = 1'
	);

    // se ci sono template
	if( is_array( $tpls ) ) {

	    // ciclo sui template trovati e li inserisco in $cf['sms']['tpl']
		foreach( $tpls as $tpl ) {

		    // inizializzo l'oggetto
			$cf['sms']['tpl'][ $tpl['ruolo'] ] = array(
			    'type' => $tpl['tipo'],
			    'nome' => $tpl['nome']
			);

		    // prelevo i contenuti
			$cnts = mysqlCachedQuery(
				$cf['memcache']['connection'],
				$cf['mysql']['connection'],
				'SELECT contenuti.*,lingue.ietf FROM contenuti '.
				'INNER JOIN lingue ON lingue.id = contenuti.id_lingua '.
				'WHERE contenuti.id_template = ?',
			    array( array( 's' => $tpl['id'] ) )
			);

			/* TODO sistemare perché la struttura è sbagliata
		    // ciclo sui contenuti
			foreach( $cnts as $cnt ) {
			    $cf['sms']['tpl'][ $tpl['ruolo'] ][ $cnt['ietf'] ] = array(
					'type' => 'twig',
                    'from' => array( $cnt['mittente_nome'] => $cnt['mittente_numero'] ),
                    'to' => $cnt['destinatario_numero'],
                    'testo' => $cnt['testo']
			    );
			}
			*/

		}

	}

    // debug
    // echo 'OUTPUT';
