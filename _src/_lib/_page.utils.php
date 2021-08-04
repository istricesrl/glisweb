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
            'pagine' => array(
                'nome' => $p['nome'] . ' - duplicata'
            ),
            'contenuti' => array(),
            'file' => array(),
            'metadati' => array(),
            'immagini' => array(),
            'audio' => array(),
            'video' => array(),
            'menu' => array(),
            'macro' => array(),
            'pagine_gruppi' => array(),
            'pubblicazione' => array()
        );

        mysqlDuplicateRowRecursive(
            $cf['mysql']['connection'],
            'pagine',
            $o,
            NULL,
            $tbls
        );

	}