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

    // tabella gestita
	$ct['form']['table'] = 'documenti';

    // percorsi
	$base = '/_mod/_0400.documenti/_src/_api/_task/';

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
	$ct['page']['contents']['metro']['03.elaborazioni'][] = array(
	    'modal' => array( 'id' => 'importa_intero_ordine', 'include' => 'inc/missioni.form.tools.modal.importa.ordine.html' ),
	    'icon' => NULL,
	    'fa' => 'fa-clipboard',
	    'title' => 'importa intero ordine',
	    'text' => 'assegna tutte le righe libere di un ordine a questa missione'
	);

	$ct['page']['contents']['metro']['03.elaborazioni'][] = array(
		'ws' => $base . '_ddt.da.missione.php?missione=' . $_REQUEST[ $ct['form']['table'] ]['id'],
        'confirm' => true,
		'icon' => NULL,
		'fa' => 'fa-cogs',
		'title' => 'creazione DDT',
		'text' => 'crea i DDT relativi agli ordini associati a questa missione'
	);

    // ...
    if( isset( $_REQUEST['__ordine__'] ) && ! empty( $_REQUEST['__ordine__'] ) ) {

        mysqlQuery( 
            $cf['mysql']['connection'],
            'UPDATE documenti_articoli SET id_missione = ' . $_REQUEST[ $ct['form']['table'] ]['id'] . ' WHERE id_documento = ' . $_REQUEST['__ordine__']
        );

    }

    $ct['etc']['select']['documenti'] = mysqlQuery( 
        $cf['mysql']['connection'],
        'SELECT documenti.*, documenti.codice AS __label__
        FROM documenti 
        INNER JOIN documenti_articoli ON documenti_articoli.id_documento = documenti.id AND documenti_articoli.id_missione IS NULL
        WHERE documenti.id_tipologia = 7 
        AND documenti.timestamp_chiusura IS NULL 
        GROUP BY documenti.id
        ORDER BY documenti.codice ASC 
        ',
    );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

    // macro per l'apertura dei modal
    require DIR_SRC_INC_MACRO . '_default.tools.php';
