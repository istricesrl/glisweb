<?php
    /**
     *
     *
     *
     *
     * @todo implementare
     * @todo documentare
     *
     * @file
     *
     */

    // gruppi di controlli
	$ct['page']['contents']['metros'] = array(
	    '01.esportazioni' => array(
			'label' => 'esportazioni'
		),
	    '02.importazioni' => array(
			'label' => 'importazioni'
		),
	    '03.elaborazioni' => array(
			'label' => 'elaborazioni'
		),
	    '04.automazioni' => array(
			'label' => 'elaborazioni'
		),
	    '05.static' => array(
			'label' => 'viste statiche'
		)
	);

    // esportazione contatti anagrafica
	$ct['page']['contents']['metro']['04.automazioni'][] = array(
	    'modal' => array( 'id' => 'crea_ddt_carico', 'include' => 'inc/logistica.documenti.passivi.tools.modal.ddt.carico.html' ),
	    'icon' => NULL,
	    'fa' => 'fa-file-o',
	    'title' => 'generazione DDT di carico',
	    'text' => 'genera al volo un DDT di carico per il rifornimento del magazzino'
	);

    // ...
    $ct['etc']['id_azienda'] = trovaIdAziendaGestita();

    // macro per l'apertura dei modal
    require DIR_SRC_INC_MACRO . '_default.tools.php';
