<?php

    /**
     * 
     * funzione che effettua la duplicazione di una pagina e degli oggetti ad essa associati (contenuti, immagini, voci di menu, ecc.)
     * 
     * @param	int     $o      id della pagina da duplicare
     * 
     * 
     */
    
    // TODO: valutare se modificare la funzione per duplicare anche le eventuali pagine figlie
	function duplicaPagina( $o ){

        global $cf;

        // estraggo i dati della pagina
        $p = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT * FROM pagine WHERE id = ?',
            array( array( 's' =>  $o ) )
        );

        // array delle tabelle da coinvolgere nella duplicazione
        $tbls = array(
            't' => array(
                'pagine' => array(
                    't' => array(
                        'contenuti' => array(),
                        'immagini' => array(
                            't' => array(
                                'contenuti' => array()
                            )
                        ),
                        'metadati' => array(),
                        'file' => array(),
                        'audio' => array(
                            't' => array(
                                'contenuti' => array()
                            )
                        ),
                        'video' => array(
                            't' => array(
                                'contenuti' => array()
                            )
                        ),
                        'menu' => array(),
                        'macro' => array(),
                        'pubblicazione' => array(),
                        '__acl_pagine__' => array()

                    ),
                    'f' => array(
                        'nome' => $p['nome'] . ' - duplicata'
                    )
                )
            )
        );


        mysqlDuplicateRowRecursive(
            $cf['mysql']['connection'],
            'pagine',
            $o,
            NULL,
            $tbls
        );

	}