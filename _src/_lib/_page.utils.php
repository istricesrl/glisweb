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

        // il codice della copia, se c'e', dev'essere libero: prodotti.codice e' UNIQUE e la INSERT IGNORE di
        // mysqlDuplicateRow() non scriverebbe niente, collegando le righe figlie a un id vuoto
        $n = ( trim( (string) $n ) === '' ) ? NULL : trim( (string) $n );
        if( empty( $p ) || ( $n !== NULL && mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT id FROM prodotti WHERE codice = ?',
            array( array( 's' => $n ) )
        ) ) ) {
            return false;
        }

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
                        'codice' => $n,
                        'nome' => $p['nome'] . ' - duplicata'
                    )
                )
            )
        );

        // NOTA $o e' l'id del prodotto da duplicare, $n il codice della copia: l'id della copia lo da'
        // l'AUTO_INCREMENT, perche' dal 02/03/2026 prodotti.id e' numerico e il codice sta in prodotti.codice
        mysqlDuplicateRowRecursive(
            $cf['mysql']['connection'],
            'prodotti',
            $o,
            NULL,
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

        // il codice della copia, se c'e', dev'essere libero: articoli.codice e' UNIQUE e la INSERT IGNORE di
        // mysqlDuplicateRow() non scriverebbe niente, collegando le righe figlie a un id vuoto
        $n = ( trim( (string) $n ) === '' ) ? NULL : trim( (string) $n );
        if( empty( $p ) || ( $n !== NULL && mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT id FROM articoli WHERE codice = ?',
            array( array( 's' => $n ) )
        ) ) ) {
            return false;
        }

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
                        'codice' => $n,
                        'id_prodotto' => $d,
                        'nome' => $p['nome'] . ' - duplicata'
                    )
                )
            )
        );

        // NOTA $o e' l'id dell'articolo da duplicare, $n il codice della copia, $d l'id del prodotto: come per
        // duplicaProdotto() l'id della copia lo da' l'AUTO_INCREMENT
        mysqlDuplicateRowRecursive(
            $cf['mysql']['connection'],
            'articoli',
            $o,
            NULL,
            $tbls
        );

    }

    /**
     * cambia il codice di un prodotto o di un articolo
     *
     * DAL 02/03/2026 IL CODICE NON E' PIU' L'ID
     * =========================================
     *
     * Fino al riallineamento del 02/03/2026 prodotti.id e articoli.id erano il codice, char( 32 ), e
     * cambiarlo voleva dire creare la riga nuova, ripuntare dal vecchio al nuovo tutte le righe figlie
     * lette dalle chiavi esterne, e solo alla fine cancellare la vecchia, dentro una transazione: un
     * UPDATE dell'id staccava in silenzio foto e allegati ( ON UPDATE SET NULL ) o era rifiutato dalle
     * righe di documento. Adesso l'id e' numerico e non cambia mai, le righe figlie citano l'id, e il
     * codice sta in prodotti.codice e articoli.codice ( UNIQUE ): cambiarlo e' un UPDATE di una colonna.
     * Sui deploy installati prima di marzo ci arriva _usr/_database/_patch/_202609301900.id.numerici.sql.
     *
     * @param   string  $t      la tabella, 'prodotti' o 'articoli'
     * @param   string  $o      l'id della riga, o il suo codice attuale
     * @param   string  $n      il codice nuovo
     *
     * @return  array           esito
     *
     */
    function rinominaEntita( $t, $o, $n ) {

        global $cf;

        $c = $cf['mysql']['connection'];

        $r = array( 'tabella' => $t, 'vecchio' => $o, 'nuovo' => $n, 'err' => array() );

        // solo le due tabelle del catalogo
        if( ! in_array( $t, array( 'prodotti', 'articoli' ) ) ) {
            $r['err'][] = 'tabella non gestita: ' . $t;
            return $r;
        }

        $o = trim( (string) $o );
        $n = trim( (string) $n );

        if( $o === '' || $n === '' ) {
            $r['err'][] = 'riga di partenza o codice di arrivo mancante';
            return $r;
        }

        // prodotti.codice e articoli.codice sono char(32)
        if( mb_strlen( $n ) > 32 ) {
            $r['err'][] = 'il codice nuovo supera i 32 caratteri';
            return $r;
        }

        // la riga: per id se $o e' un numero ( le schede passano request[table].id ), altrimenti per codice
        $riga = ( ctype_digit( $o ) ) ? mysqlSelectRow( $c, 'SELECT id, codice FROM ' . $t . ' WHERE id = ?', array( array( 's' => $o ) ) ) : NULL;
        if( empty( $riga ) ) {
            $riga = mysqlSelectRow( $c, 'SELECT id, codice FROM ' . $t . ' WHERE codice = ?', array( array( 's' => $o ) ) );
        }

        if( empty( $riga ) ) {
            $r['err'][] = $o . ' non esiste in ' . $t;
            return $r;
        }

        $r['id'] = $riga['id'];
        $r['vecchio'] = $riga['codice'];

        if( $riga['codice'] === $n ) {
            $r['err'][] = 'il codice nuovo e quello vecchio sono lo stesso';
            return $r;
        }

        $esiste = mysqlSelectValue( $c, 'SELECT id FROM ' . $t . ' WHERE codice = ? AND id <> ?', array( array( 's' => $n ), array( 's' => $riga['id'] ) ) );

        if( ! empty( $esiste ) ) {
            $r['err'][] = 'il codice ' . $n . ' e\' gia\' in uso: un cambio codice non fonde due schede';
            return $r;
        }

        // il codice nuovo; l'id, e con lui ogni riga che lo cita, resta quello
        mysqlQuery( $c, 'UPDATE ' . $t . ' SET codice = ? WHERE id = ?', array( array( 's' => $n ), array( 's' => $riga['id'] ) ) );

        $r['fatto'] = true;

        // debug
        logWrite( 'cambio codice ' . $t . ' #' . $riga['id'] . ': ' . $riga['codice'] . ' -> ' . $n, 'task', LOG_INFO );

        return $r;

    }

    // ...
    function rinominaProdotto( $o, $n ) {
        return rinominaEntita( 'prodotti', $o, $n );
    }

    // ...
    function rinominaArticolo( $o, $n ) {
        return rinominaEntita( 'articoli', $o, $n );
    }
