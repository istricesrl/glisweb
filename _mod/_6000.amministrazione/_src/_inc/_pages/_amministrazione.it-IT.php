<?php

	// lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_6000.amministrazione/';
	$m_d = DIR_MOD . '_6200.documenti/';

	// dashboard amministrazione
	$p['amministrazione'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'amministrazione' ),
	    'h1'			=> array( $l		=> 'amministrazione' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'amministrazione.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_amministrazione.php' ),
		'etc'			=> array( 'tabs'	=> array(	'amministrazione' ) ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'amministrazione' ),
														'priority'	=> '320' ) ) )
	);

   // vista proforma
   $p['proforma.amministrazione.view'] = array(
	'sitemap'		=> false,
	'title'			=> array( $l		=> 'proforma' ),
	'h1'			=> array( $l		=> 'proforma' ),
	'parent'		=> array( 'id'		=> 'amministrazione' ),
	'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	'macro'			=> array( $m . '_src/_inc/_macro/_proforma.amministrazione.view.php' ),
	'etc'			=> array( 'tabs'	=> array(   'proforma.amministrazione.view' , 'righe.proforma.amministrazione.view') ),
	'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'proforma' ),
													'priority'	=> '040' ) ) )	
	);

	// vista righe proforma
   $p['righe.proforma.amministrazione.view'] = array(
	'sitemap'		=> false,
	'title'			=> array( $l		=> 'righe' ),
	'h1'			=> array( $l		=> 'righe' ),
	'parent'		=> array( 'id'		=> 'proforma.amministrazione.view' ),
	'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	'macro'			=> array( $m . '_src/_inc/_macro/_righe.proforma.amministrazione.view.php' ),
	'etc'			=> array( 'tabs'	=> $p['proforma.amministrazione.view']['etc']['tabs'] ),
	'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) )
   );


	// gestione proforma
	$p['proforma.amministrazione.form'] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'gestione' ),
		'h1'			=> array( $l		=> 'gestione' ),
		'parent'		=> array( 'id'		=> 'proforma.amministrazione.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'proforma.amministrazione.form.html' ),
		'macro'			=> array( $m.'_src/_inc/_macro/_proforma.amministrazione.form.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'proforma.amministrazione.form',
														'proforma.amministrazione.form.righe',
														'proforma.amministrazione.form.pagamenti',
														'proforma.amministrazione.form.stampe',
														'proforma.amministrazione.form.tools' ) )
	);

	// gestione righe proforma
	$p['proforma.amministrazione.form.righe'] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'righe_fatture' ),
		'h1'			=> array( $l		=> 'righe' ),
		'parent'		=> array( 'id'		=> 'proforma.amministrazione.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'proforma.amministrazione.form.righe.html' ),
		'macro'			=> array( $m.'_src/_inc/_macro/_proforma.amministrazione.form.righe.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> $p['proforma.amministrazione.form']['etc']['tabs'] )
	);

	// gestione pagamenti fatture
	$p['proforma.amministrazione.form.pagamenti'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'pagamenti' ),
	    'h1'			=> array( $l		=> 'pagamenti' ),
	    'parent'		=> array( 'id'		=> 'proforma.amministrazione.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'documenti.form.pagamenti.html' ),
	    'macro'			=> array( $m_d.'_src/_inc/_macro/_documenti.form.pagamenti.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> $p['proforma.amministrazione.form']['etc']['tabs'] )
	);

	// gestione proforma_righe
	$p['proforma.amministrazione.righe.form'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'gestione righe' ),
	    'h1'			=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'righe.proforma.amministrazione.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'proforma.amministrazione.righe.form.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_proforma.amministrazione.righe.form.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'proforma.amministrazione.righe.form', 'proforma.amministrazione.righe.form.aggregate' ) )
	);

	// gestione 
	$p['proforma.amministrazione.righe.form.aggregate'] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'righe aggregate' ),
		'h1'			=> array( $l		=> 'righe aggregate' ),
		'parent'		=> array( 'id'		=> 'righe.proforma.amministrazione.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'documenti.articoli.form.aggregate.html' ),
		'macro'			=> array( $m_d.'_src/_inc/_macro/_documenti.articoli.form.aggregate.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> $p['proforma.amministrazione.righe.form']['etc']['tabs'] )
	);

	// gestione tools proforma
	$p['proforma.amministrazione.form.tools'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'			=> array( $l		=> 'azioni documenti' ),
	    'h1'			=> array( $l		=> 'azioni documenti' ),
	    'parent'		=> array( 'id'		=> 'proforma.amministrazione.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_proforma.amministrazione.form.tools.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> $p['proforma.amministrazione.form']['etc']['tabs'] )
	);

	// gestione anagrafica stampe
	$p['proforma.amministrazione.form.stampe'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-print" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'stampe' ),
	    'h1'		=> array( $l		=> 'stampe' ),
	    'parent'		=> array( 'id'		=> 'proforma.amministrazione.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'		=> array( $m.'_src/_inc/_macro/_proforma.amministrazione.form.stampe.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['proforma.amministrazione.form']['etc']['tabs'] )
	);

	// vista fatture
	$p['fatture.amministrazione.view'] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'fatture' ),
		'h1'			=> array( $l		=> 'fatture' ),
		'parent'		=> array( 'id'		=> 'amministrazione' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_fatture.amministrazione.view.php' ),
		'etc'			=> array( 'tabs'	=> array(   'fatture.amministrazione.view', 'righe.fatture.amministrazione.view' ) ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'fatture' ),
														'priority'	=> '050' ) ) )	
	);

	// vista righe proforma
	$p['righe.fatture.amministrazione.view'] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'righe' ),
		'h1'			=> array( $l		=> 'righe' ),
		'parent'		=> array( 'id'		=> 'fatture.amministrazione.view' ),
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
		'js'			=> array( 'internal' => array( '_mod/_6200.documenti/_src/_templates/_athena/src/js/documenti.js' ) ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'fatture.amministrazione.form',
														'fatture.amministrazione.form.righe',
														'fatture.amministrazione.form.pagamenti',
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

	// gestione anagrafica stampe
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