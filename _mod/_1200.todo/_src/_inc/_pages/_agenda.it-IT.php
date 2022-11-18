<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_1200.todo/';
/*
	// RELAZIONI CON IL MODULO PRODUZIONE
	if( in_array( "9000.agenda", $cf['mods']['active']['array'] ) ) {

    // dashboard contenuti
        $p['agenda.todo.view'] = array(
            'sitemap'	=> false,
            'title'		=> array( $l		=> 'todo' ),
            'h1'		=> array( $l		=> 'todo' ),
            'template'	=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
            'macro'		=> array( $m . '_src/_inc/_macro/_agenda.todo.view.php' ),
            'parent'	=> array( 'id'		=> 'agenda' ),
            'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
            'etc'		=> array( 'tabs'	=> array(	'todo' ) ),
            'menu'		=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'todo' ),
                                        'priority'	=> '040' ) ) )	
        );
*/
        // gestione attivita
        $p['agenda.todo.form'] = array(
            'sitemap'		=> false,
            'title'			=> array( $l		=> 'gestione todo' ),
            'h1'			=> array( $l		=> 'gestione todo' ),
            'parent'		=> array( 'id'		=> 'agenda' ),
            'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'agenda.todo.form.html' ),
            'macro'			=> array( $m.'_src/_inc/_macro/_agenda.todo.form.php' ),
            'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
            'etc'			=> array( 'tabs'	=> array(	'agenda.todo.form',
                                                            'agenda.todo.form.attivita',
                                                            'agenda.todo.form.chiusura',
                                                            'agenda.todo.form.archiviazione',
                                                            'agenda.todo.form.stampe',
                                                            'agenda.todo.form.tools' ) )
        );

        $p['agenda.todo.form.attivita'] = array(
            'sitemap'		=> false,
            'title'			=> array( $l		=> 'attivita' ),
            'icon'			=> '<i class="fa fa-pencil-square-o" aria-hidden="true"></i>',
            'h1'			=> array( $l		=> 'attivita' ),
            'parent'		=> array( 'id'		=> 'agenda' ),
            'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'agenda.todo.form.attivita.html' ),
            'macro'			=> array( $m.'_src/_inc/_macro/_agenda.todo.form.attivita.php' ),
            'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
            'etc'			=> array( 'tabs'	=> $p['agenda.todo.form']['etc']['tabs'] )
        );

        // gestione todo tools
        $p['agenda.todo.form.tools'] = array(
            'sitemap'		=> false,
            'icon'			=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
            'title'			=> array( $l		=> 'azioni' ),
            'h1'			=> array( $l		=> 'azioni' ),
            'parent'		=> array( 'id'		=> 'agenda' ),
            'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
            'macro'			=> array( $m . '_src/_inc/_macro/_agenda.todo.form.tools.php' ),
            'etc'			=> array( 'tabs'	=> $p['agenda.todo.form']['etc']['tabs'] ),
            'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) )
        );

        // gestione anagrafica stampe
        $p['agenda.todo.form.stampe'] = array(
            'sitemap'		=> false,
            'icon'		=> '<i class="fa fa-print" aria-hidden="true"></i>',
            'title'		=> array( $l		=> 'stampe' ),
            'h1'		=> array( $l		=> 'stampe' ),
            'parent'		=> array( 'id'		=> 'agenda' ),
            'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
            'macro'		=> array( $m . '_src/_inc/_macro/_agenda.todo.form.stampe.php' ),
            'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
            'etc'		=> array( 'tabs'	=> $p['agenda.todo.form']['etc']['tabs'] )
        );

        // gestione progetti chiusura
        $p['agenda.todo.form.chiusura'] = array(
            'sitemap'		=> false,
            'icon'		=> '<i class="fa fa-check-square-o" aria-hidden="true"></i>',
            'title'			=> array( $l		=> 'chiusura' ),
            'h1'			=> array( $l		=> 'chiusura' ),
            'parent'		=> array( 'id'		=> 'agenda' ),
            'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'agenda.todo.form.chiusura.html' ),
            'macro'			=> array( $m.'_src/_inc/_macro/_agenda.todo.form.chiusura.php' ),
            'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
            'etc'			=> array( 'tabs'	=> $p['agenda.todo.form']['etc']['tabs'] )
        );

        // gestione todo archiviazione
        $p['agenda.todo.form.archiviazione'] = array(
            'sitemap'		=> false,
            'icon'		=> '<i class="fa fa-archive" aria-hidden="true"></i>',
            'title'		=> array( $l		=> 'archiviazione' ),
            'h1'		=> array( $l		=> 'archiviazione' ),
            'parent'		=> array( 'id'		=> 'agenda' ),
            'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'agenda.todo.form.archiviazione.html' ),
            'macro'		=> array( $m . '_src/_inc/_macro/_agenda.todo.form.archiviazione.php' ),
            'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
            'etc'		=> array( 'tabs'	=> $p['agenda.todo.form']['etc']['tabs'] )
        );
/*
    }
*/