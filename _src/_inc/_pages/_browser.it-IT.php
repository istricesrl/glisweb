<?php

    /**
     * definizione delle pagine generali del CMS per la lingua italiana
     *
     *
     *
     * TODO commentare
     *
     *
     */

    // lingua di questo file
    $l = 'it-IT';

    /**
     * pagine di servizio
     * ==================
     * 
     * 
     * 
     */

    // file browser
    $p['browser'] = array(
        'sitemap'       => false,
        'title'         => array( $l        => 'file browser' ),
        'h1'            => array( $l        => 'file browser' ),
        'template'      => array( 'path'    => '_src/_templates/_athena/', 'schema' => 'browser.html' ),
        'contents'      => array( 'modals'  => array(
                                                'browser'   => array(
                                                                array('id'=>'crea_cartella','schema'=>'inc/browser.modal.mkdir.html'),
                                                                array('id'=>'carica_file','schema'=>'inc/browser.modal.upload.html'),
                                                                array('id'=>'cancella_file','schema'=>'inc/browser.modal.unlink.html'),
                                                                array('id'=>'sposta_file','schema'=>'inc/browser.modal.mvfile.html'),
                                                                array('id'=>'sposta_file','schema'=>'inc/browser.modal.mvfolder.html'),
                                                                array('id'=>'sposta_file','schema'=>'inc/browser.modal.rmfolder.html')
                                                            )
                                            )
                        ),
        'parent'        => array( 'id'      => NULL ),
        'macro'         => array( '_src/_inc/_macro/_browser.php' ),
        'auth'          => array( 'groups'  => array( 'roots' ) )
    );
