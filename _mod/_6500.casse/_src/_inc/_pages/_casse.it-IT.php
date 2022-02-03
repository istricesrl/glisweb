<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_6500.casse/';

    // dashboard del modulo
	$p['casse'] = array(
	    'sitemap'	=> false,
	    'title'		=> array( $l		=> 'casse' ),
	    'h1'		=> array( $l		=> 'casse' ),
	    'template'	=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'casse.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_casse.php' ),
	    'parent'	=> array( 'id'		=> NULL ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff'  ) ),
	    'etc'		=> array( 'tabs'	=> array(	'casse', 'casse.documenti.view', 'casse.contatti.view','casse.tools', 'casse.stampe' ) ),
		'menu'		=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'casse' ),
									'priority'	=> '650' ) ) )
	);

	// stampe cassa
	$p['casse.stampe'] = array(
	    'sitemap'	=> false,
		'icon'		=> '<i class="fa fa-print" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'stampe' ),
	    'h1'		=> array( $l		=> 'stampe' ),
	    'parent'	=> array( 'id'		=> 'casse' ),
	    'template'	=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_casse.stampe.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['casse']['etc']['tabs'] )
	);

    // view scontrini
	$p['casse.documenti.view'] = array(
	    'sitemap'	=> false,
	    'title'		=> array( $l		=> 'documenti' ),
	    'h1'		=> array( $l		=> 'documenti' ),
	    'template'	=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'		=> array( DIR_MOD . '_0400.documenti/_src/_inc/_macro/_documenti.view.php'  ),
	    'parent'	=> array( 'id'		=> 'casse' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['casse']['etc']['tabs'] )
	);

	$p['casse.contatti.view'] = array(
	    'sitemap'	=> false,
	    'title'		=> array( $l		=> 'contatti' ),
	    'h1'		=> array( $l		=> 'contatti' ),
	    'template'	=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'		=> array( DIR_MOD . '_0300.contatti/_src/_inc/_macro/_contatti.view.php' ),
	    'parent'	=> array( 'id'		=> 'casse' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['casse']['etc']['tabs'] )
	);

    // strumenti casse
	$p['casse.tools'] = array(
	    'sitemap'	=> false,
		'icon'		=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'strumenti casse' ),
	    'h1'		=> array( $l		=> 'strumenti casse' ),
	    'template'	=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_casse.tools.php' ),
	    'parent'	=> array( 'id'		=> NULL ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['casse']['etc']['tabs'] )
	);
	
	// contatti
	$p['contatti'] = array(
	    'sitemap'	=> false,
	    'title'		=> array( $l		=> 'contatti_terminale' ),
	    'h1'		=> array( $l		=> 'contatti' ),
	    'template'	=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'contatti.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_contatti.php' ),
	    'parent'	=> array( 'id'		=> 'casse' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff'  ) ),
		'etc'		=> array( 'sheets' => array( 'agenda.cassa', 'todo.cassa','contatti', 'terminale' , 'assistenza', 'fornitura', 'ritiro.hardware', 'consegna.hardware', 'coupon.cassa' ) ), 
		'menu'		=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'terminale' ),
									'priority'	=> '100' ) ) )
	);

    // terminale della casse
	$p['terminale'] = array(
	    'sitemap'	=> false,
	    'title'		=> array( $l		=> 'terminale' ),
	    'h1'		=> array( $l		=> 'terminale' ),
	    'template'	=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'terminale.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_terminale.php' ),
		'parser'	=> array( $m . '_src/_inc/_parser/_terminale.php' ),
	    'parent'	=> array( 'id'		=> 'casse' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff'  ) ),
		'etc'		=> array( 'sheets'	=>  $p['contatti']['etc']['sheets'] )
	);
	
	// terminale della casse
	$p['anteprima.documento'] = array(
			'sitemap'	=> false,
			'title'		=> array( $l		=> 'anteprima' ),
			'h1'		=> array( $l		=> 'anteprima' ),
			'template'	=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'anteprima.documento.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_anteprima.documento.php' ),
			'parent'	=> array( 'id'		=> 'casse' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff'  ) ),
			'etc'		=> array( 'sheets' => array( 'anteprima.documento') )
		);

	// assistenza
	$p['assistenza'] = array(
	    'sitemap'	=> false,
	    'title'		=> array( $l		=> 'assistenza' ),
	    'h1'		=> array( $l		=> 'assistenza' ),
	    'template'	=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'assistenza.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_assistenza.php' ),
	    'parent'	=> array( 'id'		=> 'casse' ),
	    'auth'		=> array( 'groups'	=> array( 'roots', 'staff'  ) ),
		'etc'		=> array( 'sheets'	=>  $p['contatti']['etc']['sheets'] )
	);

	// fornitura
	$p['fornitura'] = array(
	    'sitemap'	=> false,
	    'title'		=> array( $l		=> 'fornitura' ),
	    'h1'		=> array( $l		=> 'fornitura' ),
	    'template'	=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'fornitura.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_fornitura.php' ),
	    'parent'	=> array( 'id'		=> 'casse' ),
	    'auth'		=> array( 'groups'	=> array( 'roots', 'staff'  ) ),
		'etc'		=> array( 'sheets'	=>  $p['contatti']['etc']['sheets'] )
	);

	// agenda
	$p['agenda.cassa'] = array(
	    'sitemap'	=> false,
	    'title'		=> array( $l		=> 'agenda' ),
	    'h1'		=> array( $l		=> 'agenda' ),
	    'template'	=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'agenda.cassa.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_agenda.php' ),
	    'parent'	=> array( 'id'		=> 'casse' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff'  ) ),
		'etc'		=> array( 'sheets'	=>  $p['contatti']['etc']['sheets'] )
	);

	// todo
	$p['todo.cassa'] = array(
	    'sitemap'	=> false,
	    'title'		=> array( $l		=> 'lavori' ),
	    'h1'		=> array( $l		=> 'lavori' ),
	    'template'	=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'todo.cassa.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_todo.cassa.php' ),
	    'parent'	=> array( 'id'		=> 'casse' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff'  ) ),
		'etc'		=> array( 'sheets'	=>  $p['contatti']['etc']['sheets'] )
	);

	
	// ritiro hardware
	$p['ritiro.hardware'] = array(
	    'sitemap'	=> false,
	    'title'		=> array( $l		=> 'ritiro hardware' ),
	    'h1'		=> array( $l		=> 'ritiro hardware' ),
	    'template'	=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'ritiro.hardware.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_ritiro.hardware.php' ),
	    'parent'	=> array( 'id'		=> 'casse' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'		=> array( 'sheets'	=>  $p['contatti']['etc']['sheets'] )
	);

	// ritiro hardware
	$p['consegna.hardware'] = array(
	    'sitemap'	=> false,
	    'title'		=> array( $l		=> 'consegna hardware' ),
	    'h1'		=> array( $l		=> 'consegna hardware' ),
	    'template'	=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'consegna.hardware.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_consegna.hardware.php' ),
	    'parent'	=> array( 'id'		=> 'casse' ),
	    'auth'		=> array( 'groups'	=> array('roots', 'staff'  ) ),
		'etc'		=> array( 'sheets'	=>  $p['contatti']['etc']['sheets'] )
	);

	// ritiro hardware
	$p['coupon.cassa'] = array(
	    'sitemap'	=> false,
	    'title'		=> array( $l		=> 'coupon' ),
	    'h1'		=> array( $l		=> 'coupon' ),
	    'template'	=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'coupon.cassa.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_coupon.cassa.php' ),
	    'parent'	=> array( 'id'		=> 'casse' ),
	    'auth'		=> array( 'groups'	=> array('roots', 'staff'  ) ),
		'etc'		=> array( 'sheets'	=>  $p['contatti']['etc']['sheets'] )
	);

    // debug
	// die( print_r( $p ) );
