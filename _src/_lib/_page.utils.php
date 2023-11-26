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
	function duplicaPagina( $o ) {

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

    // ...
	function duplicaCatalogo( $o ) {

        global $cf;

        // estraggo i dati della pagina
        $p = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT * FROM categorie_prodotti WHERE id = ?',
            array( array( 's' =>  $o ) )
        );

        // array delle tabelle da coinvolgere nella duplicazione
        $tbls = array(
            't' => array(
                'categorie_prodotti' => array(
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
                        'pubblicazione' => array()

                    ),
                    'f' => array(
                        'nome' => $p['nome'] . ' - duplicata'
                    )
                )
            )
        );

        mysqlDuplicateRowRecursive(
            $cf['mysql']['connection'],
            'categorie_prodotti',
            $o,
            NULL,
            $tbls
        );

    }

    // ...
	function duplicaProdotto( $o, $n ) {

        global $cf;

        // estraggo i dati della pagina
        $p = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT * FROM prodotti WHERE id = ?',
            array( array( 's' =>  $o ) )
        );

        // array delle tabelle da coinvolgere nella duplicazione
        $tbls = array(
            't' => array(
                'prodotti' => array(
                    't' => array(
                        'contenuti' => array(),
                        'prezzi' => array(),
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
                        'pubblicazione' => array()

                    ),
                    'f' => array(
                        'nome' => $p['nome'] . ' - duplicata'
                    )
                )
            )
        );

        mysqlDuplicateRowRecursive(
            $cf['mysql']['connection'],
            'prodotti',
            $o,
            $n,
            $tbls
        );

    }

    // ...
	function duplicaArticolo( $o, $n, $d ) {

        global $cf;

        // estraggo i dati della pagina
        $p = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT * FROM articoli WHERE id = ?',
            array( array( 's' =>  $o ) )
        );

        // array delle tabelle da coinvolgere nella duplicazione
        $tbls = array(
            't' => array(
                'articoli' => array(
                    't' => array(
                        'contenuti' => array(),
                        'prezzi' => array(),
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
                        'pubblicazione' => array()

                    ),
                    'f' => array(
                        'id_prodotto' => $d,
                        'nome' => $p['nome'] . ' - duplicata'
                    )
                )
            )
        );

        mysqlDuplicateRowRecursive(
            $cf['mysql']['connection'],
            'articoli',
            $o,
            $n,
            $tbls
        );

    }
