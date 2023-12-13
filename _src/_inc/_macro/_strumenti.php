<?php

    /**
     *
     *
     *
     *
     * @file
     *
     */

    // TODO il framework dovrebbe poter funzionare anche su porte diverse dalla :80

    // TODO prelevare l'URL del sito correntemente gestito ($_SESSION['__view__']['__site__'])
    // TODO provvisorio; a tendere bisognerebbe che ogni elemento di $cf['sites'] venisse processato
    // e avesse quindi il suo URL calcolato, quindi poi $cf['site'] dovrebbe far riferimento all'elemento
    // appropriato di $cf['sites']
#	if( isset( $cf['sites'] ) && count( $cf['sites'] ) ) {
#	    $base = $cf['sites'][ $_SESSION['__view__']['__site__'] ]['protocols'][ $cf['site']['status'] ] . '://' .
#		( ( ! empty( $cf['sites'][ $_SESSION['__view__']['__site__'] ]['hosts'][ $cf['site']['status'] ] ) ) ? $cf['sites'][ $_SESSION['__view__']['__site__'] ]['hosts'][ $cf['site']['status'] ] . ((!empty($cf['sites'][ $_SESSION['__view__']['__site__'] ]['domains'][ $cf['site']['status'] ]))?'.':NULL) : NULL ).
#		$cf['sites'][ $_SESSION['__view__']['__site__'] ]['domains'][ $cf['site']['status'] ] . '/' .
#		( ( isset( $cf['sites'][ $_SESSION['__view__']['__site__'] ]['folders'][ $cf['site']['status'] ] ) ) ? $cf['sites'][ $_SESSION['__view__']['__site__'] ]['folders'][ $cf['site']['status'] ] : NULL );
#	} else {
	    $base = '/task/';
#	}

    // NOTA la variabile $base causa problemi nel multi sito fatta in questo modo, per cui ho commentato tutto

    // gruppi di controlli
	$ct['page']['contents']['metros'] = array(
	    'general' => array(
		'label' => NULL
	    ),
	    'cache' => array(
		'label' => 'gestione delle cache'
	    ),
	    'mail' => array(
		'label' => 'gestione delle mail'
	    ),
	    'sms' => array(
		'label' => 'gestione degli SMS'
	    ),
	    'log' => array(
		'label' => 'gestione di log e storage'
	    ),
		'static' => array(
			'label' => 'gestione delle viste statiche'
		)
	);

    // aggiornamento cache
	if( isset( $cf['memcache']['connection'] ) ) {
	    $ct['page']['contents']['metro']['cache'][] = array(
		'ws' => $base . 'memcache.clean',
		'icon' => NULL,
		'fa' => 'fa-clock-o',
		'title' => 'aggiornamento memcache',
		'text' => 'forza il flush della cache dati'
	    );
	    timerCheck( $cf['speed'], '-> memcache' );
	}

	if( file_exists( DIR_VAR_CACHE_TWIG ) ) {
	    $ct['page']['contents']['metro']['cache'][] = array(
		'ws' => $base . 'twig.cache.clean',
		'icon' => NULL,
		'fa' => 'fa-recycle',
		'title' => 'aggiornamento cache di Twig',
		'text' => 'cancella la cache dei template'
	    );
	    timerCheck( $cf['speed'], '-> cache Twig' );
	}

	if( file_exists( DIR_VAR_CACHE_PAGES ) ) {
	    $ct['page']['contents']['metro']['cache'][] = array(
		'ws' => $base . 'pages.cache.clean',
		'icon' => NULL,
		'fa' => 'fa-eraser',
		'title' => 'aggiornamento cache pagine',
		'text' => 'cancella la cache statica delle pagine'
	    );
	    timerCheck( $cf['speed'], '-> cache Twig' );
	}
/*
	if( mysqlSelectValue( $cf['mysql']['connection'], 'SELECT count( id ) FROM sms_sent LIMIT 1' ) > 0 ) {
	    $ct['page']['contents']['metro']['sms'][] = array(
		'ws' => $base . 'sms.queue.clean.sent',
		'icon' => NULL,
		'fa' => 'fa-trash-o',
		'title' => 'svuotamento coda SMS inviati',
		'text' => 'cancella la coda degli SMS inviati'
	    );
	    timerCheck( $cf['speed'], '-> SMS in uscita' );
	}

	if( mysqlSelectValue( $cf['mysql']['connection'], 'SELECT count( id ) FROM sms_out LIMIT 1' ) > 0 ) {
	    $ct['page']['contents']['metro']['sms'][] = array(
		'ws' => $base . 'sms.queue.clean.out',
		'icon' => NULL,
		'fa' => 'fa-trash',
		'title' => 'svuotamento coda SMS in uscita',
		'text' => 'cancella la coda degli SMS in uscita'
	    );
	    timerCheck( $cf['speed'], '-> SMS inviati' );
	}
*/
	if( count( glob( DIR_VAR_LOG . '{*/,}*.log', GLOB_BRACE ) ) > 0 ) {
	    $ct['page']['contents']['metro']['log'][] = array(
			'ws' => $base . 'log.clean',
			'icon' => NULL,
			'fa' => 'fa-trash-o',
			'title' => 'pulizia dei log',
			'text' => 'cancella i log base del framework'
	    );
	    $ct['page']['contents']['metro']['log'][] = array(
			'ws' => $base . 'log.clean?hard=1',
			'confirm' => true,
			'icon' => NULL,
			'fa' => 'fa-trash',
			'title' => 'pulizia totale dei log',
			'text' => 'cancella tutti i log del framework'
			);
		timerCheck( $cf['speed'], '-> controllo log' );
	}

	if( count( glob( DIR_TMP . '*' ) ) > 0 ) {
	    $ct['page']['contents']['metro']['log'][] = array(
		'ws' => $base . 'tmp.clean',
		'confirm' => true,
		'icon' => NULL,
		'fa' => 'fa-hourglass-end',
		'title' => 'pulizia dei file temporanei',
		'text' => 'svuota la cartella dei file temporanei'
	    );
	    timerCheck( $cf['speed'], '-> controllo file temporanei' );
	}

	if( count( glob( DIR_VAR_SITEMAP . 'sitemap.*.{xml,csv}', GLOB_BRACE ) ) > 0 ) {
	    $ct['page']['contents']['metro']['cache'][] = array(
			'ws' => $base . 'sitemap.clean',
			'icon' => NULL,
			'fa' => 'fa-file-code-o',
			'title' => 'pulizia delle sitemap',
			'text' => 'forza la cancellazione delle sitemap'
	    );
	}
/*
	$ct['page']['contents']['metro']['static'][] = array(
		'modal' => array('id' => 'refresh', 'include' => 'bin/refresh.view.static.html', 'onclick' => 'updateButton();'),
		'icon' => NULL,
		'fa' => 'fa-refresh',
		'title' => 'ripopola view static',
		'text' => 'ripopola una o tutte le view static presenti nel database'
	    );

	// elenco delle view statiche
	$ct['etc']['static_view'] = mysqlCachedQuery(	   
		$cf['memcache']['connection'], 
		$cf['mysql']['connection'], 
		'SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME LIKE "%_static" AND table_schema = database()');	
*/

	$ct['page']['contents']['metro']['static'][] = array(
		'lws' => $base . 'anagrafica.view.static.popolazione',
		'icon' => NULL,
		'fa' => 'fa-refresh',
		'title' => 'ripopola anagrafica view static',
		'text' => 'ripopola la view static dell\'anagrafica'
	);


    // debug
	// print_r( $_SESSION );
	// echo DIRECTORY_CACHE . 'twig';

	// macro di default
    require DIR_SRC_INC_MACRO . '_default.tools.php';