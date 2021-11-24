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
                        'contenuti' => array(
                            'f' => array(
                                'h1' => $p['h1'] . ' - pagina duplicata'
                            )
                        ),
                        'immagini' => array(
                            't' => array(
                                'contenuti' => array(
                                    't' => array(),
                                    'f' => array(
                                        'h1' => $p['h1'] . ' - immagine duplicata'
                                    )
                                )
                            ),
                            'f' => array()
                        ),
                        'metadati' => array()
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