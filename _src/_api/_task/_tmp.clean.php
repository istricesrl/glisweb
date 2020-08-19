<?php

    /**
     *
     *
     *
     *
     * @todo commentare
     *
     * @file
     *
     */

    // runlevel da saltare
	$cf['lvls']['skip'] = array(
	    '300', '310', '320', '330', '345',
	    '400', '420',
	    '950', '980'
	);

    // inclusione del framework
	require_once '../../_config.php';

    // inizializzo l'array del risultato
	$status = array();

    // svuoto la cartella temporanea
	recursiveDelete( DIR_TMP, false );

?>
