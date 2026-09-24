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
	$ct['form']['table'] = 'contratti';
/*	
    // percorsi
	$base = $ct['site']['url'] . '/_mod/_0600.contratti/_src/_api/_task/';

	// tendina giorni
    $ct['etc']['select']['giorni'] = array( 
        array( 'id' => '1', '__label__' => 'lunedi' ),
        array( 'id' => '2', '__label__' => 'martedi' ),
        array( 'id' => '3', '__label__' => 'mercoledi' ),
        array( 'id' => '4', '__label__' => 'giovedi' ),
        array( 'id' => '5', '__label__' => 'venerdi' ),
        array( 'id' => '6', '__label__' => 'sabato' ),
        array( 'id' => '7', '__label__' => 'domenica' )
    );

	// tendina tipologia dell'attività da creare
	$ct['etc']['select']['tipologie_attivita'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM tipologie_attivita_view WHERE se_contratto = 1' );

    // tendina turni
	foreach( range( 1, 9 ) as $turno ) {
	    $ct['etc']['select']['turni'][] =  array( 'id' => $turno, '__label__' => $turno );
	}

    // gruppi di controlli
	$ct['page']['contents']['metros'] = array(
	    'orari' => array(
			'label' => 'orari'
		),
		'contratto' => array(
			'label' => 'contratto'
		)
	);

    // modal per la conferma di duplicazione contratto
	$ct['page']['contents']['metro']['contratto'][] = array(
		'modal' => array('id' => 'duplica-contratto', 'include' => 'inc/contratti.form.tools.modal.duplica.contratto.html' ),
	    'icon' => NULL,
	    'fa' => 'fa-files-o',
	    'title' => 'variazione contratto',
	    'text' => 'crea un duplicato del contratto per inserire variazioni'
	);

	// modal per la conferma di eliminazione contratto
    $ct['page']['contents']['metro']['contratto'][] = array(
        'modal' => array('id' => 'elimina-contratto', 'include' => 'inc/contratti.form.tools.modal.elimina.contratto.html' ),
        'icon' => NULL,
	    'fa' => 'fa-trash',
	    'title' => 'eliminazione contratto',
	    'text' => 'elimina il contratto e gli orari e turni collegati'
    );

	// modal per la proroga del contratto
    $ct['page']['contents']['metro']['contratto'][] = array(
        'modal' => array('id' => 'proroga', 'include' => 'inc/contratti.form.tools.modal.proroga.contratto.html' ),
        'icon' => NULL,
	    'fa' => 'fa-calendar',
	    'title' => 'proroga contratto',
	    'text' => 'aggiorna la data di fine del contratto e inserisce un\'attività di proroga'
    );

	// modal per la conferma di duplicazione orari giorno
	$ct['page']['contents']['metro']['orari'][] = array(
		'modal' => array('id' => 'duplica-giorno', 'include' => 'inc/contratti.form.tools.modal.duplica.giorno.html' ),
		'icon' => NULL,
		'fa' => 'fa-files-o',
		'title' => 'duplicazione giorno',
		'text' => 'duplica gli orari di un determinato giorno e turno di lavoro'
	);

	// modal per la conferma di duplicazione orari turno
	$ct['page']['contents']['metro']['orari'][] = array(
		'modal' => array('id' => 'duplica-turno', 'include' => 'inc/contratti.form.tools.modal.duplica.turno.html' ),
		'icon' => NULL,
		'fa' => 'fa-files-o',
		'title' => 'duplicazione turno',
		'text' => 'duplica gli orari di un determinato turno di lavoro in un nuovo turno'
	);

	// modal per la conferma di eliminazione turno
    $ct['page']['contents']['metro']['orari'][] = array(
        'modal' => array('id' => 'elimina-turno', 'include' => 'inc/contratti.form.tools.modal.elimina.turno.html' ),
        'icon' => NULL,
	    'fa' => 'fa-trash',
	    'title' => 'eliminazione turno',
	    'text' => 'elimina gli orari di un determinato turno di lavoro'
    );

	// modal per la conferma di eliminazione orari
    $ct['page']['contents']['metro']['orari'][] = array(
        'modal' => array('id' => 'elimina-orari', 'include' => 'inc/contratti.form.tools.modal.elimina.orari.html' ),
        'icon' => NULL,
	    'fa' => 'fa-trash',
	    'title' => 'eliminazione orari',
	    'text' => 'elimina gli orari di lavoro del contratto'
    );

	// macro di default per l'entità contratti
	require '_contratti.form.default.php';
*/
	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

	require DIR_SRC_INC_MACRO . '_default.tools.php';
