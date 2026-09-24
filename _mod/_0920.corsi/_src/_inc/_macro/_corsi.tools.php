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

    // base di chiamata dei WS
    $base = '/task/0920.corsi/';

    // gruppi di controlli
	$ct['page']['contents']['metros'] = array(
	    'general' => array(
		'label' => NULL
	    ),
	    'cache' => array(
		'label' => 'gestione delle cache dei corsi'
	    ),
	    'cache_lezioni' => array(
		'label' => 'gestione delle cache delle lezioni'
	    ),
	    'gestione' => array(
		'label' => 'gestione massiva corsi'
		)
	);

    // aggiornamento cache
    $ct['page']['contents']['metro']['gestione'][] = array(
	    'modal' => array( 'id' => 'duplicazione_corsi', 'include' => 'inc/corsi.tools.modal.duplicazione.html' ),
	    'icon' => NULL,
	    'fa' => 'fa-clone',
	    'title' => 'duplicazione massiva corsi',
	    'text' => 'duplica un intervallo di corsi modificando i parametri indicati'
    );

    // aggiornamento cache
    $ct['page']['contents']['metro']['gestione'][] = array(
	    'modal' => array( 'id' => 'modifica_corsi', 'include' => 'inc/corsi.tools.modal.modifica.html' ),
	    'icon' => NULL,
	    'fa' => 'fa-pencil',
	    'title' => 'modifica massiva corsi',
	    'text' => 'modifica un intervallo di corsi secondo i parametri indicati'
    );

    // aggiornamento cache
    $ct['page']['contents']['metro']['cache'][] = array(
        'ws' => $base . 'report.corsi.popolazione.start',
        'callback' => 'location.reload()',
        'icon' => NULL,
        'fa' => 'fa-clock-o',
        'title' => 'aggiornamento report corsi',
        'text' => 'forza l\'avvio dell\'aggiornamento del report corsi'
    );

    // ...
	$ct['page']['contents']['metro']['cache'][] = array(
		'lws' => $base . 'report.corsi.popolazione',
		'icon' => NULL,
		'fa' => 'fa-refresh',
		'title' => 'ripopola report corsi',
		'text' => 'ripopola immediatamente il report dei corsi'
	);

    // aggiornamento cache
    $ct['page']['contents']['metro']['cache_lezioni'][] = array(
        'ws' => $base . 'report.lezioni.corsi.popolazione.start',
        'callback' => 'location.reload()',
        'icon' => NULL,
        'fa' => 'fa-clock-o',
        'title' => 'aggiornamento report lezioni corsi',
        'text' => 'forza l\'aggiornamento del report lezioni corsi'
    );

    // ...
	$ct['page']['contents']['metro']['cache_lezioni'][] = array(
		'lws' => $base . 'report.lezioni.corsi.popolazione',
		'icon' => NULL,
		'fa' => 'fa-refresh',
		'title' => 'ripopola report lezioni corsi',
		'text' => 'ripopola il report delle lezioni dei corsi'
	);

    // tendina anni
    foreach( range( date( 'Y' ) - 1,  date( 'Y' ) + 1 ) as $y ) {
        $ct['etc']['select']['anni'][ $y ] = array( 'id' => $y, '__label__' => $y ) ;
    }

    // tendina periodi
	$ct['etc']['select']['periodi'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT periodi_view.id, periodi_view.__label__ FROM periodi_view LEFT JOIN tipologie_periodi ON tipologie_periodi.id = periodi_view.id_tipologia WHERE tipologie_periodi.se_corsi'
    );

    $ct['etc']['select']['periodi_prezzi'] = array(
        array( 'id' => 'totale', '__label__' => 'totale' ),
        array( 'id' => 'quadrimestrale', '__label__' => 'quadrimestrale' ),
        array( 'id' => 'trimestrale', '__label__' => 'trimestrale' ),
        array( 'id' => 'bimestrale', '__label__' => 'bimestrale' ),
        array( 'id' => 'mensile', '__label__' => 'mensile' ),
        array( 'id' => 'settimanale', '__label__' => 'settimanale' ),
        array( 'id' => 'giornata', '__label__' => 'giornata' )
    );

    $ct['etc']['select']['istruttori'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view_static WHERE se_collaboratore = 1' );

    // tendina categorie progetti
	$ct['etc']['select']['discipline'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM categorie_progetti_view WHERE se_disciplina = 1 ORDER BY __label__'
	);

	$ct['etc']['select']['classi'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM categorie_progetti_view WHERE se_classe = 1 ORDER BY __label__'
	);

	$ct['etc']['select']['fasce'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM categorie_progetti_view WHERE se_fascia = 1 ORDER BY __label__'
	);

    $ct['etc']['select']['tipologie'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_periodi_view'
    );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.tools.php';
