<?php

	// lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_6000.amministrazione/';

	if( in_array( "1000.produzione", $cf['mods']['active']['array'] ) ) {
	// vista progetti
	$p['progetti.amministrazione.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'progetti' ),
	    'h1'			=> array( $l		=> 'progetti' ),
	    'parent'		=> array( 'id'		=> 'amministrazione' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_progetti.amministrazione.view.php' ),
		'etc'			=> array( 'tabs'	=> array( 'progetti.amministrazione.view', 'progetti.amministrazione.archivio.view', 'progetti.amministrazione.tools' ) ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'progetti' ),
																		'priority'	=> '010' ) ) )									
	);

	// vista progetti 
	$p['progetti.amministrazione.archivio.view'] = array(
	    'sitemap'		=> false,
	    'icon'			=> '<i class="fa fa-archive" aria-hidden="true"></i>',
		'title'			=> array( $l		=> 'archivio' ),
	    'h1'			=> array( $l		=> 'archivio' ),
	    'parent'		=> array( 'id'		=> 'amministrazione' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_progetti.amministrazione.archivio.view.php' ),
		'etc'			=> array( 'tabs'	=> $p['progetti.amministrazione.view']['etc']['tabs'] ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) )
	);

	// progetti tools
	$p['progetti.amministrazione.tools'] = array(
	    'sitemap'		=> false,
	    'icon'			=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
		'title'			=> array( $l		=> 'azioni' ),
	    'h1'			=> array( $l		=> 'azioni' ),
	    'parent'		=> array( 'id'		=> 'amministrazione' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_progetti.amministrazione.tools.php' ),
		'etc'			=> array( 'tabs'	=> $p['progetti.amministrazione.view']['etc']['tabs'] ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) )
	);

	// gestione progetti
	$p['progetti.amministrazione.form'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'gestione' ),
	    'h1'			=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'progetti.amministrazione.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.amministrazione.form.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_progetti.amministrazione.form.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'progetti.amministrazione.form',
														'progetti.amministrazione.form.archiviazione',
														'progetti.amministrazione.form.tools' ) )
	);

	// RELAZIONI CON IL MODULO ATTIVITA
	if( in_array( "1100.attivita", $cf['mods']['active']['array'] ) ) {
		arrayInsertSeq( 'progetti.amministrazione.form', $p['progetti.amministrazione.form']['etc']['tabs'], 'progetti.amministrazione.form.attivita' );
	}

	// RELAZIONI CON IL MODULO TODO
	if( in_array( "1200.todo", $cf['mods']['active']['array'] ) ) {
		arrayInsertSeq( 'progetti.amministrazione.form', $p['progetti.amministrazione.form']['etc']['tabs'], 'progetti.amministrazione.form.todo' );
	}

    // RELAZIONI CON IL MODULO COMMERCIALE
	if( in_array( "2000.commerciale", $cf['mods']['active']['array'] ) ) {
		arrayInsertBefore( 'progetti.amministrazione.form.archiviazione', $p['progetti.amministrazione.form']['etc']['tabs'], 'progetti.amministrazione.form.accettazione' );
	}

    // RELAZIONI CON IL MODULO PRODUZIONE
	if( in_array( "1000.produzione", $cf['mods']['active']['array'] ) ) {
		arrayInsertBefore( 'progetti.amministrazione.form.archiviazione', $p['progetti.amministrazione.form']['etc']['tabs'], 'progetti.amministrazione.form.chiusura' );
	}

	// gestione todo progetti
	// in relazione con il modulo todo
	// TODO spostare con la sua macro e il suo schema nel modulo todo
	$p['progetti.amministrazione.form.todo'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'todo' ),
	    'h1'			=> array( $l		=> 'to-do' ),
	    'parent'		=> array( 'id'		=> 'progetti.amministrazione.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.amministrazione.form.todo.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_progetti.amministrazione.form.todo.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> $p['progetti.amministrazione.form']['etc']['tabs'] )
	);

	// gestione attività progetti
	// in relazione con il modulo attivita
	// TODO spostare con la sua macro e il suo schema nel modulo attivita
	$p['progetti.amministrazione.form.attivita'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'attivita' ),
	    'h1'			=> array( $l		=> 'attività' ),
	    'parent'		=> array( 'id'		=> 'progetti.amministrazione.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.amministrazione.form.attivita.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_progetti.amministrazione.form.attivita.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> $p['progetti.amministrazione.form']['etc']['tabs'] )
	);

    // gestione progetti accettazione
	// in relazione con il modulo commerciale
	// TODO spostare con la sua macro e il suo schema nel modulo commerciale
    $p['progetti.amministrazione.form.accettazione'] = array(
        'sitemap'		=> false,
        'icon'		=> '<i class="fa fa-handshake-o" aria-hidden="true"></i>',
        'title'			=> array( $l		=> 'accettazione' ),
        'h1'			=> array( $l		=> 'accettazione' ),
        'parent'		=> array( 'id'		=> 'progetti.amministrazione.view' ),
        'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.amministrazione.form.accettazione.html' ),
        'macro'			=> array( $m.'_src/_inc/_macro/_progetti.amministrazione.form.accettazione.php' ),
        'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
        'etc'			=> array( 'tabs'	=> $p['progetti.amministrazione.form']['etc']['tabs'] )
    );

    // gestione progetti chiusura
    $p['progetti.amministrazione.form.chiusura'] = array(
        'sitemap'		=> false,
        'icon'		=> '<i class="fa fa-check-square-o" aria-hidden="true"></i>',
        'title'			=> array( $l		=> 'chiusura' ),
        'h1'			=> array( $l		=> 'chiusura' ),
        'parent'		=> array( 'id'		=> 'progetti.amministrazione.view' ),
        'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.amministrazione.form.chiusura.html' ),
        'macro'			=> array( $m.'_src/_inc/_macro/_progetti.amministrazione.form.chiusura.php' ),
        'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
        'etc'			=> array( 'tabs'	=> $p['progetti.amministrazione.form']['etc']['tabs'] )
    );

    // gestione progetti archiviazione
    $p['progetti.amministrazione.form.archiviazione'] = array(
        'sitemap'		=> false,
        'icon'		=> '<i class="fa fa-archive" aria-hidden="true"></i>',
        'title'			=> array( $l		=> 'archiviazione' ),
        'h1'			=> array( $l		=> 'archiviazione' ),
        'parent'		=> array( 'id'		=> 'progetti.amministrazione.view' ),
        'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.amministrazione.form.archiviazione.html' ),
        'macro'			=> array( $m.'_src/_inc/_macro/_progetti.amministrazione.form.archiviazione.php' ),
        'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
        'etc'			=> array( 'tabs'	=> $p['progetti.amministrazione.form']['etc']['tabs'] )
    );

    // gestione progetti tools
    $p['progetti.amministrazione.form.tools'] = array(
        'sitemap'		=> false,
        'icon'			=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'			=> array( $l		=> 'azioni' ),
        'h1'			=> array( $l		=> 'azioni' ),
        'parent'		=> array( 'id'		=> 'progetti.amministrazione.view' ),
        'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
        'macro'			=> array( $m . '_src/_inc/_macro/_progetti.amministrazione.form.tools.php' ),
        'etc'			=> array( 'tabs'	=> $p['progetti.amministrazione.form']['etc']['tabs'] ),
        'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) )
    );
	}