<?php

    /**
     *
     *
     *
     *
     * @file
     *
     */


    // tabella gestita
	$ct['form']['table'] = 'progetti';

    // sotto tabella gestita
	$ct['form']['subtable'] = 'pause_progetti';

     // modal per conferma della rimozione degli eventi già esistenti
     $ct['page']['contents']['metro'][NULL][] = array(
	    'modal' => array('id' => 'pulisci', 'include' => 'inc/progetti.produzione.form.pause.modal.pulisci.html' )
	);

    // macro di default
    require DIR_SRC_INC_MACRO . '_default.form.php';

    require DIR_SRC_INC_MACRO . '_default.tools.php';
    