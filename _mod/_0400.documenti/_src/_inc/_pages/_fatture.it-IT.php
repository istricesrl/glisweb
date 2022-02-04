<?php

	// lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_0400.documenti/';

	// vista fatture
	$p['fatture.amministrazione.view'] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'fatture attive' ),
		'h1'			=> array( $l		=> 'fatture attive' ),
		'parent'		=> array( 'id'		=> 'amministrazione' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_fatture.amministrazione.view.php' ),
		'etc'			=> array( 'tabs'	=> array(   'fatture.amministrazione.view',
														'fatture.passive.amministrazione.view',
														'righe.fatture.amministrazione.view',
														'righe.fatture.passive.amministrazione.view' ) ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'fatture' ),
														'priority'	=> '050' ) ) )	
	);

	// vista righe proforma
	$p['righe.fatture.amministrazione.view'] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'righe attive' ),
		'h1'			=> array( $l		=> 'righe attive' ),
		'parent'		=> array( 'id'		=> 'amministrazione' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_righe.fatture.amministrazione.view.php' ),
		'etc'			=> array( 'tabs'	=> $p['fatture.amministrazione.view']['etc']['tabs'] ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) )
	   );

	// gestione fatture
	$p['fatture.amministrazione.form'] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'gestione' ),
		'h1'			=> array( $l		=> 'gestione' ),
		'parent'		=> array( 'id'		=> 'fatture.amministrazione.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'fatture.amministrazione.form.html' ),
		'macro'			=> array( $m.'_src/_inc/_macro/_fatture.amministrazione.form.php' ),
		'js'			=> array( 'internal' => array( '_mod/_0400.documenti/_src/_templates/_athena/src/js/documenti.js' ) ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'fatture.amministrazione.form',
														'fatture.amministrazione.form.righe',
														'fatture.amministrazione.form.pagamenti',
														'fatture.amministrazione.form.chiusura',
														'fatture.amministrazione.form.stampe',
														'fatture.amministrazione.form.tools' ) )
	);

	// gestione righe fatture
	$p['fatture.amministrazione.form.righe'] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'righe_fatture' ),
		'h1'			=> array( $l		=> 'righe' ),
		'parent'		=> array( 'id'		=> 'fatture.amministrazione.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'fatture.amministrazione.form.righe.html' ),
		'macro'			=> array( $m.'_src/_inc/_macro/_fatture.amministrazione.form.righe.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> $p['fatture.amministrazione.form']['etc']['tabs'] )
	);

	// gestione pagamenti fatture
	$p['fatture.amministrazione.form.pagamenti'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'pagamenti' ),
	    'h1'			=> array( $l		=> 'pagamenti' ),
	    'parent'		=> array( 'id'		=> 'fatture.amministrazione.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'documenti.form.pagamenti.html' ),
	    'macro'			=> array( $m_d.'_src/_inc/_macro/_documenti.form.pagamenti.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> $p['fatture.amministrazione.form']['etc']['tabs'] )
	);

	// gestione fatture_righe
	$p['fatture.amministrazione.righe.form'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'gestione righe' ),
	    'h1'			=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'righe.fatture.amministrazione.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'fatture.amministrazione.righe.form.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_fatture.amministrazione.righe.form.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'fatture.amministrazione.righe.form', 'fatture.amministrazione.righe.form.aggregate' ) )
	);

	// gestione tools documenti_articoli - attivita
	$p['fatture.amministrazione.righe.form.aggregate'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'righe aggregate' ),
			'h1'			=> array( $l		=> 'righe aggregate' ),
			'parent'		=> array( 'id'		=> 'righe.fatture.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'documenti.articoli.form.aggregate.html' ),
			'macro'			=> array( $m_d.'_src/_inc/_macro/_documenti.articoli.form.aggregate.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['fatture.amministrazione.righe.form']['etc']['tabs'] )
	);

	// gestione tools proforma
	$p['fatture.amministrazione.form.chiusura'] = array(
	    'sitemap'		=> false,
        'icon'		=> '<i class="fa fa-check-square-o" aria-hidden="true"></i>',
	    'title'			=> array( $l		=> 'chiusura' ),
	    'h1'			=> array( $l		=> 'chiusura' ),
	    'parent'		=> array( 'id'		=> 'fatture.amministrazione.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'fatture.amministrazione.form.chiusura.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_fatture.amministrazione.form.tools.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> $p['fatture.amministrazione.form']['etc']['tabs'] )
	);

	// gestione tools fatture
	$p['fatture.amministrazione.form.tools'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
		'title'			=> array( $l		=> 'azioni documenti' ),
		'h1'			=> array( $l		=> 'azioni documenti' ),
		'parent'		=> array( 'id'		=> 'fatture.amministrazione.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
		'macro'			=> array( $m.'_src/_inc/_macro/_fatture.amministrazione.form.tools.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> $p['fatture.amministrazione.form']['etc']['tabs'] )
	);

	// gestione stampe fatture
	$p['fatture.amministrazione.form.stampe'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-print" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'stampe' ),
		'h1'		=> array( $l		=> 'stampe' ),
		'parent'		=> array( 'id'		=> 'fatture.amministrazione.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
		'macro'		=> array( $m.'_src/_inc/_macro/_fatture.amministrazione.form.stampe.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'		=> array( 'tabs'	=> $p['fatture.amministrazione.form']['etc']['tabs'] )
	);

   // vista fatture passive
   $p['fatture.passive.amministrazione.view'] = array(
	'sitemap'		=> false,
	'title'			=> array( $l		=> 'fatture passive' ),
	'h1'			=> array( $l		=> 'fatture passive' ),
	'parent'		=> array( 'id'		=> 'amministrazione' ),
	'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	'macro'			=> array( $m . '_src/_inc/_macro/_fatture.passive.amministrazione.view.php' ),
	'etc'			=> array( 'tabs'	=> $p['fatture.amministrazione.view']['etc']['tabs'] ),
	'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) )
#	'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'fatture passive' ),
#													'priority'	=> '060' ) ) )	
	);

	// vista righe fatture.passive
   $p['righe.fatture.passive.amministrazione.view'] = array(
	'sitemap'		=> false,
	'title'			=> array( $l		=> 'righe passive' ),
	'h1'			=> array( $l		=> 'righe passive' ),
	'parent'		=> array( 'id'		=> 'fatture.passive.amministrazione.view' ),
	'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	'macro'			=> array( $m . '_src/_inc/_macro/_righe.fatture.passive.amministrazione.view.php' ),
	'etc'			=> array( 'tabs'	=> $p['fatture.amministrazione.view']['etc']['tabs'] ),
	'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) )
   );

	// gestione fatture passive
	$p['fatture.passive.amministrazione.form'] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'gestione' ),
		'h1'			=> array( $l		=> 'gestione' ),
		'parent'		=> array( 'id'		=> 'fatture.passive.amministrazione.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'fatture.passive.amministrazione.form.html' ),
		'macro'			=> array( $m.'_src/_inc/_macro/_fatture.passive.amministrazione.form.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'fatture.passive.amministrazione.form',
														'fatture.passive.amministrazione.form.righe',
														'fatture.passive.amministrazione.form.pagamenti',
														'fatture.passive.amministrazione.form.stampe',
														'fatture.passive.amministrazione.form.tools' ) )
	);

	// gestione righe fatture passive
	$p['fatture.passive.amministrazione.form.righe'] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'righe_fatture' ),
		'h1'			=> array( $l		=> 'righe' ),
		'parent'		=> array( 'id'		=> 'fatture.passive.amministrazione.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'fatture.passive.amministrazione.form.righe.html' ),
		'macro'			=> array( $m.'_src/_inc/_macro/_fatture.passive.amministrazione.form.righe.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> $p['fatture.passive.amministrazione.form']['etc']['tabs'] )
	);

	// gestione pagamenti fatture passive
	$p['fatture.passive.amministrazione.form.pagamenti'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'pagamenti' ),
	    'h1'			=> array( $l		=> 'pagamenti' ),
	    'parent'		=> array( 'id'		=> 'fatture.passive.amministrazione.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'documenti.form.pagamenti.html' ),
	    'macro'			=> array( $m_d.'_src/_inc/_macro/_documenti.form.pagamenti.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> $p['fatture.passive.amministrazione.form']['etc']['tabs'] )
	);

	// gestione righe fatture passive
	$p['fatture.passive.amministrazione.righe.form'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'gestione righe' ),
	    'h1'			=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'righe.fatture.passive.amministrazione.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'fatture.passive.amministrazione.righe.form.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_fatture.passive.amministrazione.righe.form.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'fatture.passive.amministrazione.righe.form', 'fatture.passive.amministrazione.righe.form.aggregate' ) )
	);

	// gestione 
	$p['fatture.passive.amministrazione.righe.form.aggregate'] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'righe aggregate' ),
		'h1'			=> array( $l		=> 'righe aggregate' ),
		'parent'		=> array( 'id'		=> 'righe.fatture.passive.amministrazione.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'documenti.articoli.form.aggregate.html' ),
		'macro'			=> array( $m_d.'_src/_inc/_macro/_documenti.articoli.form.aggregate.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> $p['fatture.passive.amministrazione.righe.form']['etc']['tabs'] )
	);

	// gestione tools fatture passive
	$p['fatture.passive.amministrazione.form.tools'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'			=> array( $l		=> 'azioni documenti' ),
	    'h1'			=> array( $l		=> 'azioni documenti' ),
	    'parent'		=> array( 'id'		=> 'fatture.passive.amministrazione.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_fatture.passive.amministrazione.form.tools.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> $p['fatture.passive.amministrazione.form']['etc']['tabs'] )
	);

	// gestione stampe fatture passive
	$p['fatture.passive.amministrazione.form.stampe'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-print" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'stampe' ),
	    'h1'		=> array( $l		=> 'stampe' ),
	    'parent'		=> array( 'id'		=> 'fatture.passive.amministrazione.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'		=> array( $m.'_src/_inc/_macro/_fatture.passive.amministrazione.form.stampe.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['fatture.passive.amministrazione.form']['etc']['tabs'] )
	);

