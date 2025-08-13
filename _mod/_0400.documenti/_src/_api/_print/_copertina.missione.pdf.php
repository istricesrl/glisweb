<?php

    /**
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // inclusione del framework
	require_once '../../../../../_src/_config.php';

    // configurazioni specifiche
    $cnf['estensione'] = 'pdf';
    $cnf['cartella'] = 'fatture';

    // inclusione dei dati base
	require DIR_BASE . '_mod/_0400.documenti/_src/_api/_print/_documento.default.php';

    // debug
	// header( 'Content-type: text/plain;' );
	// die( print_r( $doc, true ) );
	// die( print_r( $src, true ) );
	// die( print_r( $dst, true ) );

    // creazione del PDF
	$pdf = new TCPDF( 'P', 'mm', 'A4' );						// portrait, millimetri, A4 (x->210 y->297)

    // ...
    generaCopertinaMissionePdf( $pdf, $dati );

    // oggetto del documento
    $dobj = str_replace( ' ', '_' , $dati['doc']['oggetto'] );

    // output
	if( isset( $_REQUEST['d'] ) ) {
	    $pdf->Output($dobj.'.pdf' , 'D' );					// invia l'output al browser per il download diretto
	} elseif( isset( $_REQUEST['f'] ) ) {
	    $pdf->Output( $dobj.'.pdf','F' );				// salva il file localmente
	} elseif( isset( $_REQUEST['fi'] ) ) {
	    $pdf->Output( $dobj.'.pdf', 'FI' );				// salva il file localmente e invia l'output al browser
	} else {
	    $pdf->Output($dobj.'.pdf');								// invia l'output al browser
	}
