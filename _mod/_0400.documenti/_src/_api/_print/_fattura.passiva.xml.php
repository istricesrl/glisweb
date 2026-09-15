<?php

    /**
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // inclusione del framework
	require_once '../../../../../_src/_config.php';

	/**
	 * Controllo autorizzazioni
	 * ========================
	 *
	 * Fix 2026-09-15: questo endpoint rispondeva 200 a chiunque, senza sessione. Non aveva
	 * nemmeno il segnaposto `if( true )` dei quattro del core: non aveva proprio niente.
	 *
	 * Non passa da `controller()` — ha una query sua — quindi l'ACL per tabella non lo vede
	 * e non basta essere autenticati per ereditare un permesso: il documento stampato contiene i dati del cliente e le righe dell'ordine.
     * `GESTIONE_DOCUMENTI` e' attribuito a `roots` e a `staff`, quindi chi emette i documenti
     * non se ne accorge; `users` non ce l'ha.
	 *
	 * Stesso meccanismo degli endpoint `/task/` e dei sei di `/print/` chiusi lo stesso
	 * giorno: verifica, log nel canale `security` a LOG_ERR, 403, exit.
	 */
	checkTaskPrivilege( 'GESTIONE_DOCUMENTI' );

	// se è settato il documento
	if( isset( $_REQUEST['__documento__'] ) ) {

		// recupero l'XML
		$xml = mysqlSelectValue(
			$cf['mysql']['connection'],
			'SELECT xml FROM documenti WHERE id = ?',
			array( array( 's' => $_REQUEST['__documento__'] ) )
		);

		// header
		header('Content-type: text/plain');
		header('Content-Disposition: attachment; filename="fattura.passiva.'.$_REQUEST['__documento__'].'.xml"');

		// output
		echo $xml;

	}
