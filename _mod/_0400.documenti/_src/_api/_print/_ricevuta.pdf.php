<?php

    /**
     * stampa PDF: ricevuta
     *
     * Endpoint sottile: il PDF lo genera generaDocumentoPdf() ( _src/_lib/_pdf.tools.add.php del modulo ), che legge i
     * dati con generaContenutiDocumento(), sceglie il modello dalla colonna stampa_pdf della tipologia del documento
     * ( e in mancanza usa 'ricevuta' ), salva il file in var/spool/docs/ricevute/pdf/ e annota l'attivita' di stampa.
     * L'uscita verso il browser e i parametri d, f, fi sono descritti in _documento.output.php.
     *
     * Per cambiare l'impaginazione in un deploy non si copia questo file: si scrive un modello custom e lo si
     * dichiara in tipologie_documenti.stampa_pdf, oppure si forza $cnf['modello'] in un endpoint custom.
     *
     * @file
     *
     */

    // inclusione del framework
    require_once '../../../../../_src/_config.php';

    // configurazioni specifiche
    $cnf['estensione'] = 'pdf';
    $cnf['cartella'] = 'ricevute';
    $cnf['predefinito'] = 'ricevuta';
    $cnf['attivita'] = false;

    // inclusione dei dati base
    require DIR_BASE . '_mod/_0400.documenti/_src/_api/_print/_documento.default.php';

    // generazione, salvataggio e uscita
    require DIR_BASE . '_mod/_0400.documenti/_src/_api/_print/_documento.output.php';
