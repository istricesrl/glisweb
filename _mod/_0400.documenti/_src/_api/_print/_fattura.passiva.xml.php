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
	require '../../../../../_src/_config.php';

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
