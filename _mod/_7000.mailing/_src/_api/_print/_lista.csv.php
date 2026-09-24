<?php

    // inclusione del framework
	require '../../../../../_src/_config.php';

    /**
     * Controllo autorizzazioni
     * ========================
     *
     * ⚠ Fix 2026-09-15: stesso segnaposto `if( true )` degli endpoint di /print/ del core, con
     * il ramo `else` scritto e mai raggiungibile.
     *
     * Qui il lavoro lo fa `controller()` su `liste_mail`, che applica gia' l'ACL per tabella:
     * mancava solo il gradino prima, cioe' pretendere che ci sia qualcuno collegato. Stessa
     * cura di `_src/_api/_print/_default.csv.php`, e per la stessa ragione: sovrapporre un
     * privilegio d'area a un ACL che c'e' gia' taglierebbe fuori usi legittimi senza aggiungere
     * niente. Il modulo non e' attivo su nessun deploy: la correzione e' preventiva.
     */
	checkTaskPrivilege();

    // controllo autorizzazioni
	if( true ) {

		// controllo parametri
		if( empty( $_REQUEST['__lista__'] ) ) {

			// errore
			buildText( 'nessuna lista specificata' );

		} else {

			$lista = array( 'id_lista' => $_REQUEST['__lista__'] );

			controller(
				$cf['mysql']['connection'],
				$cf['memcache']['connection'],
				$lista,
				'liste_mail'
			);

			// print_r( $lista );

			remapArray(
				$lista,
				array(
					'id_anagrafica' => 'id',
					'anagrafica_nome' => 'nome',
					'anagrafica_cognome' => 'cognome',
					'anagrafica_denominazione' => 'denominazione',
					'anagrafica_codice' => 'codice',
					'anagrafica_codice_fiscale' => 'codice_fiscale',
					'mail' => 'mail',
					'lista' => 'lista'
				)
			);

			// print_r( $lista );

			// TODO usare array2csvFile()
            // buildCsv( array2csvString( $lista, ';' ), 'iscritti.csv' );

		}

	} else {

	    // errore
		buildText( 'non autorizzato' );

	}
