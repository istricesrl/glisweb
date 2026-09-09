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

    /**
     * cambia il codice di un prodotto o di un articolo portandosi dietro tutto
     *
     * PERCHE' NON BASTA UN UPDATE
     * ===========================
     *
     * prodotti.id e articoli.id sono id naturali, e sono referenziati da una trentina di chiavi
     * esterne. Solo una parte e' in ON UPDATE CASCADE: le altre sono
     *
     *  - ON UPDATE SET NULL  ( contenuti, immagini, file, video, audio, risorse, progetti,
     *                          matricole, software, tipologie_contratti )
     *  - NO ACTION           ( documenti_articoli, carrelli_articoli )
     *
     * Un "UPDATE prodotti SET id = ..." quindi STACCA IN SILENZIO foto, allegati, testi e URL della
     * scheda, e viene rifiutato del tutto se quel codice compare in una riga di documento. Su un
     * archivio con 50.207 righe di preventivo e' un danno che non si vede il giorno stesso.
     *
     * COME FUNZIONA INVECE QUESTA
     * ===========================
     *
     * Nell'ordine, dentro una transazione:
     *
     *  1. crea la riga nuova, copia di quella vecchia con il codice nuovo;
     *  2. ripunta TUTTE le righe figlie, tabella per tabella, dal codice vecchio al nuovo;
     *  3. solo alla fine cancella la riga vecchia, che a quel punto non e' piu' referenziata da
     *     nessuno e quindi non si porta via niente in cascata.
     *
     * E' la regola gia' scritta nel TODO del progetto Lughese: prima si ripunta tutto al
     * superstite, poi si cancella.
     *
     * L'elenco delle tabelle figlie si legge da INFORMATION_SCHEMA e non si scrive a mano: cosi'
     * una chiave esterna aggiunta domani viene coperta da sola, invece di essere dimenticata.
     *
     * @param   string  $t      la tabella, 'prodotti' o 'articoli'
     * @param   string  $o      il codice attuale
     * @param   string  $n      il codice nuovo
     *
     * @return  array           esito, con il conteggio delle righe spostate per tabella
     *
     */
    function rinominaEntita( $t, $o, $n ) {

        global $cf;

        $c = $cf['mysql']['connection'];

        $r = array( 'tabella' => $t, 'vecchio' => $o, 'nuovo' => $n, 'spostate' => array(), 'err' => array() );

        // solo le due tabelle a id naturale del catalogo
        if( ! in_array( $t, array( 'prodotti', 'articoli' ) ) ) {
            $r['err'][] = 'tabella non gestita: ' . $t;
            return $r;
        }

        $o = trim( (string) $o );
        $n = trim( (string) $n );

        if( $o === '' || $n === '' ) {
            $r['err'][] = 'codice di partenza o di arrivo mancante';
            return $r;
        }

        if( $o === $n ) {
            $r['err'][] = 'il codice nuovo e quello vecchio sono lo stesso';
            return $r;
        }

        // prodotti.id e articoli.id sono char(32)
        if( mb_strlen( $n ) > 32 ) {
            $r['err'][] = 'il codice nuovo supera i 32 caratteri';
            return $r;
        }

        $vecchia = mysqlSelectRow( $c, 'SELECT * FROM ' . $t . ' WHERE id = ?', array( array( 's' => $o ) ) );

        if( empty( $vecchia ) ) {
            $r['err'][] = 'il codice ' . $o . ' non esiste in ' . $t;
            return $r;
        }

        $esiste = mysqlSelectValue( $c, 'SELECT id FROM ' . $t . ' WHERE id = ?', array( array( 's' => $n ) ) );

        if( ! empty( $esiste ) ) {
            $r['err'][] = 'il codice ' . $n . ' e\' gia\' in uso: un cambio codice non fonde due schede';
            return $r;
        }

        // le tabelle figlie, lette dalle chiavi esterne
        $figlie = mysqlQuery(
            $c,
            'SELECT TABLE_NAME, COLUMN_NAME FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE '.
            'WHERE TABLE_SCHEMA = DATABASE() AND REFERENCED_TABLE_NAME = ? '.
            'ORDER BY TABLE_NAME, COLUMN_NAME',
            array( array( 's' => $t ) )
        );

        // transazione: o si sposta tutto, o non si sposta niente
        mysqli_begin_transaction( $c );

        try {

            // 1. la riga nuova, copia della vecchia
            $nuova = $vecchia;
            $nuova['id'] = $n;

            mysqlInsertRow( $c, $nuova, $t );

            // 2. tutte le righe figlie, una tabella per volta
            foreach( $figlie as $f ) {

                // su UPDATE mysqlQuery() restituisce gia' le righe toccate
                // ( mysqli_stmt_affected_rows, _src/_lib/_mysql.tools.php riga 483 ): chiedere
                // mysqli_affected_rows alla CONNESSIONE dopo uno statement preparato torna zero
                $spostate = mysqlQuery(
                    $c,
                    'UPDATE ' . $f['TABLE_NAME'] . ' SET ' . $f['COLUMN_NAME'] . ' = ? WHERE ' . $f['COLUMN_NAME'] . ' = ?',
                    array( array( 's' => $n ), array( 's' => $o ) )
                );

                if( $spostate > 0 ) {
                    $r['spostate'][ $f['TABLE_NAME'] . '.' . $f['COLUMN_NAME'] ] = $spostate;
                }

            }

            // 3. la riga vecchia, che ormai non e' piu' referenziata da nessuno
            mysqlQuery( $c, 'DELETE FROM ' . $t . ' WHERE id = ?', array( array( 's' => $o ) ) );

            mysqli_commit( $c );

            $r['fatto'] = true;

        } catch( Exception $e ) {

            mysqli_rollback( $c );
            $r['err'][] = 'cambio codice annullato: ' . $e->getMessage();

        }

        // debug
        logWrite( 'cambio codice ' . $t . ': ' . $o . ' -> ' . $n . ' ' . print_r( $r, true ), 'task', ( empty( $r['err'] ) ) ? LOG_INFO : LOG_ERR );

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
