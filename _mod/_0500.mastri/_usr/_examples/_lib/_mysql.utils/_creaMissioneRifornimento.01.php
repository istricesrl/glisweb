<?php

    /**
     * esempio di creaMissioneRifornimento()
     *
     * L'output e' controllato da _mod/_0500.mastri/_usr/_test/_tests/unit/mastriUtilsCest.php: la missione nasce, di
     * tipologia 36, legata alla richiesta col ruolo 4, e le sue righe ci sono davvero nel database. Il conteggio lo fa
     * una query, non il campo righe restituito dalla funzione: fino al 23/11/2026 le righe portavano la tipologia del
     * documento in documenti_articoli.id_tipologia, l'INSERT IGNORE le scartava per la chiave esterna e la funzione le
     * contava lo stesso, quindi le missioni di rifornimento nascevano vuote senza che niente lo dicesse.
     *
     * L'esempio scrive nel database e non legge niente di quello che c'e' gia', cosi' gira su qualunque deploy: crea col
     * prefisso di test un prodotto con due articoli, due mastri ( il bulk e la destinazione ), un'anagrafica con un
     * indirizzo che fa da magazzino e la richiesta, la passa alla funzione e alla fine toglie tutto, prima righe,
     * missione e richiesta ( le relazioni cadono in cascata ), poi i dati di appoggio ( l'indirizzo cade con
     * l'anagrafica ). In produzione non fa niente.
     *
     */

    require '../../../../../../_src/_config.php';

    header( 'Content-type: text/plain;' );

    // in produzione l'esempio non scrive
    if( substr( SITE_STATUS, 0, strlen( PRODUCTION ) ) == PRODUCTION ) {
        die( 'esempio disattivato in produzione' );
    }

    $c = $cf['mysql']['connection'];

    // i dati di appoggio, col prefisso di test: un prodotto con due articoli, due mastri, un magazzino
    $n = 'TEST-E2E-mastri-' . uniqid();
    $prodotto = mysqlInsertRow( $c, array( 'nome' => $n ), 'prodotti', false );
    $articoli = $mastri = array();
    for( $i = 1; $i <= 2; $i++ ) {
        $articoli[] = array( 'id' => mysqlInsertRow( $c, array( 'id_prodotto' => $prodotto, 'codice' => $n . '-' . $i, 'nome' => $n ), 'articoli', false ), 'codice' => $n . '-' . $i );
        $mastri[] = array( 'id' => mysqlInsertRow( $c, array( 'codice' => $n . '-' . $i, 'nome' => $n ), 'mastri', false ) );
    }
    $anagrafica = mysqlInsertRow( $c, array( 'denominazione' => $n ), 'anagrafica', false );
    $magazzino = array( 'id_anagrafica' => $anagrafica, 'id_indirizzo' => mysqlInsertRow( $c, array( 'id_anagrafica' => $anagrafica, 'indirizzo' => $n ), 'anagrafica_indirizzi', false ) );

    // la richiesta, col prefisso di test
    $codiceRichiesta = 'TEST-E2E-R' . substr( time(), -6 );
    $idRichiesta = mysqlInsertRow( $c, array( 'codice' => $codiceRichiesta, 'id_tipologia' => 7, 'data' => date( 'Y-m-d' ) ), 'documenti', false );

    // le righe, gia' valutate come le passa il task
    $righe = array();
    foreach( $articoli as $i => $a ) {
        $righe[] = array( 'id_articolo' => $a['id'], 'articolo' => $a['codice'], 'quantita_richiesta' => $i + 2, 'id_mastro_bulk' => $mastri[0]['id'] );
    }

    $esito = creaMissioneRifornimento( $c, $idRichiesta, $codiceRichiesta, $magazzino, $mastri[1]['id'], $righe );

    echo 'errore ' . var_export( $esito['errore'], true ) . PHP_EOL;
    echo 'tipologia ' . mysqlSelectValue( $c, 'SELECT id_tipologia FROM documenti WHERE id = ?', array( array( 's' => $esito['id'] ) ) ) . PHP_EOL;
    echo 'relazioni ' . mysqlSelectValue( $c, 'SELECT count(*) FROM relazioni_documenti WHERE id_documento = ? AND id_documento_collegato = ? AND id_ruolo = 4', array( array( 's' => $esito['id'] ), array( 's' => $idRichiesta ) ) ) . PHP_EOL;
    echo 'righe in missione ' . mysqlSelectValue( $c, 'SELECT count(*) FROM documenti_articoli WHERE id_missione = ? AND id_documento = ?', array( array( 's' => $esito['id'] ), array( 's' => $idRichiesta ) ) ) . ' su ' . count( $righe ) . PHP_EOL;
    echo 'quantita ' . mysqlSelectValue( $c, 'SELECT sum( quantita ) FROM documenti_articoli WHERE id_missione = ?', array( array( 's' => $esito['id'] ) ) ) . PHP_EOL;

    // pulizia: prima le righe ( id_documento e' NO ACTION ), poi i documenti
    mysqlQuery( $c, 'DELETE FROM documenti_articoli WHERE id_documento = ? OR id_missione = ?', array( array( 's' => $idRichiesta ), array( 's' => $esito['id'] ) ) );
    mysqlQuery( $c, 'DELETE FROM documenti WHERE id IN ( ?, ? )', array( array( 's' => $idRichiesta ), array( 's' => $esito['id'] ) ) );
    echo 'pulizia ' . mysqlSelectValue( $c, 'SELECT count(*) FROM documenti WHERE codice LIKE ?', array( array( 's' => '%' . $codiceRichiesta . '%' ) ) ) . PHP_EOL;

    // pulizia dei dati di appoggio: articoli prima del prodotto, mastri prima dell'anagrafica ( id_anagrafica_indirizzi e'
    // NO ACTION ), l'indirizzo cade in cascata con l'anagrafica
    mysqlQuery( $c, 'DELETE FROM articoli WHERE nome = ?', array( array( 's' => $n ) ) );
    mysqlQuery( $c, 'DELETE FROM prodotti WHERE nome = ?', array( array( 's' => $n ) ) );
    mysqlQuery( $c, 'DELETE FROM mastri WHERE nome = ?', array( array( 's' => $n ) ) );
    mysqlQuery( $c, 'DELETE FROM anagrafica WHERE denominazione = ?', array( array( 's' => $n ) ) );
    echo 'pulizia appoggio ' . mysqlSelectValue( $c, 'SELECT ( SELECT count(*) FROM articoli WHERE nome = ? ) + ( SELECT count(*) FROM prodotti WHERE nome = ? ) + ( SELECT count(*) FROM mastri WHERE nome = ? ) + ( SELECT count(*) FROM anagrafica_indirizzi WHERE indirizzo = ? )', array( array( 's' => $n ), array( 's' => $n ), array( 's' => $n ), array( 's' => $n ) ) ) . PHP_EOL;
