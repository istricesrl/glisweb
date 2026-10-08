<?php

    /**
     * uscita comune delle stampe PDF dei documenti
     *
     * Gli endpoint PDF di /print/0400.documenti/ sono tutti uguali: includono il framework, impostano la cartella di
     * spool e il modello, includono _documento.default.php per l'autorizzazione e poi questo file, che genera il PDF con
     * generaDocumentoPdf(), lo salva in var/spool/docs/<cartella>/pdf/ e lo invia al browser. Generazione, scelta del
     * modello, salvataggio e annotazione dell'attivita' di stampa stanno tutti nella funzione, qui resta solo l'uscita.
     *
     * configurazione
     * ==============
     * Il chiamante imposta, prima di includere _documento.default.php:
     *
     * chiave               | contenuto
     * ---------------------|-----------------------------------------------------------------------------------------
     * $cnf['estensione']   | sempre 'pdf'
     * $cnf['cartella']     | la sottocartella di var/spool/docs/ dove salvare il file
     * $cnf['attivita']     | false: l'attivita' la annota generaDocumentoPdf() a file scritto, non _documento.default.php
     * $cnf['predefinito']  | il modello da usare se la tipologia non ne dichiara uno in stampa_pdf
     * $cnf['modello']      | facoltativo, forza il modello anche contro stampa_pdf ( p.es. un endpoint custom )
     *
     * uscita
     * ======
     * Il file si salva sempre, quindi i parametri della richiesta scelgono solo cosa arriva al browser:
     *
     * parametro    | uscita
     * -------------|-----------------------------------------------------------------------------------------------
     * d            | il PDF come allegato da scaricare
     * f            | niente PDF, un JSON col percorso del file salvato
     * fi           | il PDF da visualizzare, come senza parametri ( tenuto per compatibilita' )
     *
     * @file
     *
     */

    // impostazioni passate al modello
    $etcStampa = ( isset( $cnf['pdf'] ) && is_array( $cnf['pdf'] ) ) ? $cnf['pdf'] : array();
    if( ! empty( $cnf['modello'] ) ) {
        $etcStampa['modello'] = $cnf['modello'];
    }
    if( ! empty( $cnf['predefinito'] ) ) {
        $etcStampa['predefinito'] = $cnf['predefinito'];
    }

    // nome del file: l'oggetto del documento senza i caratteri che non possono stare in un nome di file ( p.es. la
    // barra di un numero 12/2026, che finirebbe per indicare una cartella )
    $dobj = trim( preg_replace( '/[^A-Za-z0-9._-]+/', '_', $dati['doc']['oggetto'] ), '._' );
    if( empty( $dobj ) ) {
        $dobj = 'documento.' . $dati['doc']['id'];
    }

    // genero e salvo il PDF
    $filePdf = generaDocumentoPdf( $dati['doc']['id'], DIR_VAR_SPOOL_DOCS . $cnf['cartella'] . '/pdf/' . $dobj . '.pdf', $etcStampa );

    // ...
    if( $filePdf === false ) {
        dieText( 'stampa del documento non generata, vedere il log dei documenti' );
    }

    // uscita
    if( isset( $_REQUEST['f'] ) ) {
        buildJson( array( 'file' => getShortPath( $filePdf ) ) );
    } else {
        build(
            file_get_contents( $filePdf ),
            NULL,
            NULL,
            array(
                'Content-Type' => 'application/pdf',
                'Content-Disposition' => ( ( isset( $_REQUEST['d'] ) ) ? 'attachment' : 'inline' ) . '; filename="' . basename( $filePdf ) . '"',
                'Content-Length' => filesize( $filePdf )
            )
        );
    }
