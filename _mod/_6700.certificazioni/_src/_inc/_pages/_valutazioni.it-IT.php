<?php

    // modulo di questo file
    $m_v = DIR_MOD . '_0800.valutazioni/';
    // modulo di questo file
	$m = DIR_MOD . '_6700.certificazioni/';

    // RELAZIONI CON IL MODULO IMMOBILIARI
    if( in_array( "0800.valutazioni", $cf['mods']['active']['array'] ) ) {

        arrayInsertSeq( 'valutazioni.form', $p['valutazioni.form']['etc']['tabs'],'valutazioni.form.certificazioni');
        

        	    
        // form valutazioni immagini
		$p['valutazioni.form.certificazioni'] = array(
			'sitemap'		=> false,
			'title'		=> array( $l		=> 'certificazioni' ),
			'h1'		=> array( $l		=> 'certificazioni' ),
			'parent'		=> array( 'id'		=> 'valutazioni.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'valutazioni.form.certificazioni.html' ),
			'macro'		=> array( $m_v . '_src/_inc/_macro/_valutazioni.form.certificazioni.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> 'valutazioni.form' )
		);
		
        foreach( $p['valutazioni.form']['etc']['tabs'] as $t ){
            $p[ $t ]['etc']['tabs'] = $p['valutazioni.form']['etc']['tabs'];
        }

        arrayInsertSeq( 'anagrafica.certificazioni.view', $p['certificazioni.view']['etc']['tabs'],'valutazioni.certificazioni.view');
        
        foreach( $p['certificazioni.view']['etc']['tabs'] as $t ){
            $p[ $t ]['etc']['tabs'] = $p['certificazioni.view']['etc']['tabs'];
        }

       
        // vista scadenze certificazioni
        $p['valutazioni.certificazioni.view'] = array(
            'sitemap'		=> false,
            'title'		=> array( $l		=> 'scadenze valutazioni' ),
            'h1'		=> array( $l		=> 'scadenze valutazioni' ),
            'parent'		=> array( 'id'		=> 'certificazioni.view' ),
            'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
            'macro'		=> array( $m . '_src/_inc/_macro/_valutazioni.certificazioni.view.php' ),
            'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
            'etc'		=> array( 'tabs'	=> $p['certificazioni.view']['etc']['tabs'] )
        );

        // gestione anagrafica.certificazioni
        $p['valutazioni.certificazioni.form'] = array(
            'sitemap'		=> false,
            'title'		=> array( $l		=> 'gestione' ),
            'h1'		=> array( $l		=> 'gestione' ),
            'parent'		=> array( 'id'		=> 'valutazioni.certificazioni.view' ),
            'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'valutazioni.certificazioni.form.html' ),
            'macro'		=> array(  $m . '_src/_inc/_macro/_valutazioni.certificazioni.form.php' ),
            'auth'		=> array( 'groups'	=> array(	'roots', 'staff'  ) ),
            'etc'		=> array( 'tabs'	=> array( 
                                                    'valutazioni.certificazioni.form',
        #												'anagrafica.certificazioni.form.immagini',
                                                    'valutazioni.certificazioni.form.file'
                                                    ) )	
        );

        $p['valutazioni.certificazioni.form.file'] = array(
            'sitemap'		=> false,
            'icon'		=> '<i class="fa fa-folder-open-o" aria-hidden="true"></i>',
            'title'		=> array( $l		=> 'file' ),
            'h1'		=> array( $l		=> 'file' ),
            'parent'		=> array( 'id'		=> 'valutazioni.certificazioni.view' ),
            'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'valutazioni.certificazioni.form.file.html' ),
            'macro'		=> array( $m . '_src/_inc/_macro/_valutazioni.certificazioni.form.file.php' ),
            'auth'		=> array( 'groups'	=> array(	'roots' ) ),
            'etc'		=> array( 'tabs'	=> $p['valutazioni.certificazioni.form']['etc']['tabs'] )
        );

    }
