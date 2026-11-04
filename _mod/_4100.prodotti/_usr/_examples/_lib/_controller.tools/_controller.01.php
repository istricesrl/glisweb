<?php

    /**
     * file di esempio per la funzione controller(): i controller finally del modulo tengono allineata articoli_view_static
     *
     * Scrive con controller() un prodotto, un suo articolo, una categoria del prodotto e una caratteristica
     * dell'articolo, e dopo ogni scrittura guarda la riga dell'articolo nella vista statica. Per le tabelle che
     * alimentano la vista ( prodotti, prodotti_categorie, articoli_caratteristiche ) la riga della statica viene prima
     * sporcata a mano: se dopo la scrittura è tornata uguale alla vista, il controller l'ha rigenerata. Fino al
     * 04/11/2026 i controller degli articoli stavano in _src/_api/_inc/_controllers/, dove controller() non guarda, e
     * la statica dal back-end non si aggiornava mai ( LUGHESE ).
     *
     * Scrive nel database del deploy e pulisce dopo di sé; i permessi passano dalla firma di importazione.
     *
     * @file
     *
     */

    // inclusione del framework
    require '../../../../../../_src/_config.php';

    // output
    header( 'Content-type: text/plain' );

    // senza il segreto di importazione la firma non si può calcolare
    if( empty( $cf['auth']['import']['secret'] ) ) {
        die( 'segreto di importazione assente' . PHP_EOL );
    }

    // connessioni
    $c = $cf['mysql']['connection'];
    $mc = $cf['memcache']['connection'];

    // senza la statica non c'è niente da allineare
    if( ! getStaticView( $mc, $c, 'articoli' ) ) {
        die( 'vista statica degli articoli assente' . PHP_EOL );
    }

    // dati di lavoro
    $n = 'TEST-E2E-articoli-' . uniqid();
    $f = function( $t ) use ( $cf ) { return hash( getAvailableHashMethod(), $t . $cf['auth']['import']['secret'] ); };

    // controller() prende il blocco dati per riferimento: si passa da una variabile
    $scrivi = function( $t, $d, $m ) use ( $c, $mc, $f ) { $d['__firma__'] = $f( $t ); return controller( $c, $mc, $d, $t, $m ); };

    // la riga dell'articolo nella statica e nella vista
    $statica = function( $k ) use ( $c, &$idArticolo ) { return mysqlSelectValue( $c, 'SELECT ' . $k . ' FROM articoli_view_static WHERE id = ?', array( array( 's' => $idArticolo ) ) ); };
    $vista = function( $k ) use ( $c, &$idArticolo ) { return mysqlSelectValue( $c, 'SELECT ' . $k . ' FROM articoli_view WHERE id = ?', array( array( 's' => $idArticolo ) ) ); };
    $sporca = function() use ( $c, &$idArticolo ) { mysqlQuery( $c, 'UPDATE articoli_view_static SET nome = ?, categorie = ? WHERE id = ?', array( array( 's' => 'sporca' ), array( 's' => 'sporca' ), array( 's' => $idArticolo ) ) ); };

    // prodotto e articolo
    echo 'prodotto: ' . $scrivi( 'prodotti', array( 'nome' => $n ), METHOD_POST ) . PHP_EOL;
    $idProdotto = mysqlSelectValue( $c, 'SELECT id FROM prodotti WHERE nome = ?', array( array( 's' => $n ) ) );
    echo 'articolo: ' . $scrivi( 'articoli', array( 'id_prodotto' => $idProdotto, 'nome' => $n ), METHOD_POST ) . PHP_EOL;
    $idArticolo = mysqlSelectValue( $c, 'SELECT id FROM articoli WHERE id_prodotto = ?', array( array( 's' => $idProdotto ) ) );
    echo 'articolo nella statica: ' . ( ( $statica( 'id' ) == $idArticolo ) ? 'si' : 'no' ) . PHP_EOL;

    // categoria del prodotto
    mysqlQuery( $c, 'INSERT INTO categorie_prodotti ( nome ) VALUES ( ? )', array( array( 's' => $n ) ) );
    $idCategoria = mysqlSelectValue( $c, 'SELECT id FROM categorie_prodotti WHERE nome = ?', array( array( 's' => $n ) ) );
    $sporca();
    echo 'categoria: ' . $scrivi( 'prodotti_categorie', array( 'id_prodotto' => $idProdotto, 'id_categoria' => $idCategoria ), METHOD_POST ) . PHP_EOL;
    echo 'categorie nella statica come nella vista: ' . ( ( $statica( 'categorie' ) === $vista( 'categorie' ) && strpos( $vista( 'categorie' ), $n ) !== false ) ? 'si' : 'no' ) . PHP_EOL;

    // nome del prodotto
    $sporca();
    echo 'prodotto rinominato: ' . $scrivi( 'prodotti', array( 'id' => $idProdotto, 'nome' => $n . '-bis' ), METHOD_UPDATE ) . PHP_EOL;
    echo 'prodotto nella statica come nella vista: ' . ( ( $statica( 'prodotto' ) === $n . '-bis' && $statica( 'nome' ) === $vista( 'nome' ) ) ? 'si' : 'no' ) . PHP_EOL;

    // caratteristica dell'articolo
    $sporca();
    echo 'caratteristica: ' . $scrivi( 'articoli_caratteristiche', array( 'id_articolo' => $idArticolo, 'valore' => $n ), METHOD_POST ) . PHP_EOL;
    echo 'statica rigenerata dalla caratteristica: ' . ( ( $statica( 'nome' ) === $vista( 'nome' ) ) ? 'si' : 'no' ) . PHP_EOL;

    // nome dell'articolo
    echo 'articolo rinominato: ' . $scrivi( 'articoli', array( 'id' => $idArticolo, 'nome' => $n . '-ter' ), METHOD_UPDATE ) . PHP_EOL;
    echo 'nome nella statica come nella vista: ' . ( ( $statica( 'nome' ) === $vista( 'nome' ) && strpos( $statica( 'nome' ), '-ter' ) !== false ) ? 'si' : 'no' ) . PHP_EOL;

    // cancellazione dell'articolo
    echo 'articolo cancellato: ' . $scrivi( 'articoli', array( 'id' => $idArticolo ), METHOD_DELETE ) . PHP_EOL;
    echo 'articolo tolto dalla statica: ' . ( ( $statica( 'id' ) === NULL ) ? 'si' : 'no' ) . PHP_EOL;

    // pulizia
    mysqlQuery( $c, 'DELETE FROM articoli_view_static WHERE id = ?', array( array( 's' => $idArticolo ) ) );
    mysqlQuery( $c, 'DELETE FROM articoli_caratteristiche WHERE valore = ?', array( array( 's' => $n ) ) );
    mysqlQuery( $c, 'DELETE FROM articoli WHERE id = ?', array( array( 's' => $idArticolo ) ) );
    mysqlQuery( $c, 'DELETE FROM prodotti_categorie WHERE id_prodotto = ?', array( array( 's' => $idProdotto ) ) );
    mysqlQuery( $c, 'DELETE FROM categorie_prodotti WHERE id = ?', array( array( 's' => $idCategoria ) ) );
    mysqlQuery( $c, 'DELETE FROM prodotti WHERE id = ?', array( array( 's' => $idProdotto ) ) );
