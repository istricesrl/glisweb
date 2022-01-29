<?php

    /**
     * dichiarazione dei template per la posta
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

    // configurazione extra
	if( isset( $cx['mail'] ) ) {
	    $cf['mail'] = array_replace_recursive( $cf['mail'], $cx['mail'] );
	}

    // recupero dei template dal database
	$tpls = mysqlCachedIndexedQuery(
		$cf['memcache']['index'],
		$cf['memcache']['connection'],
		$cf['mysql']['connection'],
		'SELECT * FROM template WHERE se_mail = 1'
	);

    // se ci sono template
	if( is_array( $tpls ) ) {

	    // ciclo sui template trovati e li inserisco in $cf['mail']['tpl']
		foreach( $tpls as $tpl ) {

		    // inizializzo l'oggetto
			$cf['mail']['tpl'][ $tpl['ruolo'] ] = array(
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

		    // ciclo sui contenuti
			foreach( $cnts as $cnt ) {
			    $cf['mail']['tpl'][ $tpl['ruolo'] ][ $cnt['ietf'] ] = array(
				'from' => array( $cnt['mittente_nome'] => $cnt['mittente_mail'] ),
				'to' => array( $cnt['destinatario_nome'] => $cnt['destinatario_mail'] ),
				'to_cc' => array( $cnt['destinatario_cc_nome'] => $cnt['destinatario_cc_mail'] ),
				'to_bcc' => array( $cnt['destinatario_ccn_nome'] => $cnt['destinatario_ccn_mail'] ),
				'oggetto' => $cnt['cappello'],
				'testo' => $cnt['testo']
			    );
			}

		    // prelevo gli allegati
			$files = mysqlCachedQuery(
				$cf['memcache']['connection'],
				$cf['mysql']['connection'],
				'SELECT file.*,lingue.ietf FROM file '.
				'INNER JOIN lingue ON lingue.id = file.id_lingua '.
				'WHERE file.id_template = ?',
			    array( array( 's' => $tpl['id'] ) )
			);

		    // ciclo sugli allegati
			foreach( $files as $file ) {
			    $cf['mail']['tpl'][ $tpl['ruolo'] ][ $file['ietf'] ]['attach'][ basename( $file['path'] ) ] = DIRECTORY_BASE . $file['path'];
			}

		}

	}

    // debug
	// print_r( $cf['mail']['tpl'] );
	// print_r( $ct['contatti'] );

	/**
	 * NOTA questa cosa dei template mail è fatta così per ora perché si suppone che i template non siano mai tanti,
	 * e quindi per ora è gestibile anche così; se i template mail gestiti dovessero essere molti bisogna cambiare
	 * approccio e considerare di implementare qui lo stesso approccio visto per le pagine, oltre a considerare il fatto
	 * che caricandoli qui in pratica lo facciamo per tutte le pagine e non solo per quelle dove effettivamente
	 * i template mail sono proprio necessari
	 */
