<?php

    /**
     * stampa PDF: documento di trasporto
     *
     * Endpoint sottile: il PDF lo genera generaDocumentoPdf() ( _src/_lib/_pdf.tools.add.php del modulo ), che legge i
     * dati con generaContenutiDocumento(), sceglie il modello dalla colonna stampa_pdf della tipologia del documento
     * ( e in mancanza usa 'ddt' ), salva il file in var/spool/docs/ddt/pdf/ e annota l'attivita' di stampa.
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

    /**
     * Controllo autorizzazioni
     * ========================
     *
     * Fix 2026-09-15: questo endpoint rispondeva 200 a chiunque, senza sessione. Non aveva
     * nemmeno il segnaposto `if( true )` dei quattro del core: non aveva proprio niente.
     *
     * Non passa da `controller()` — ha una query sua — quindi l'ACL per tabella non lo vede
     * e non basta essere autenticati per ereditare un permesso: il documento stampato contiene i dati del cliente e le righe dell'ordine.
     * `GESTIONE_DOCUMENTI` e' attribuito a `roots` e a `staff`, quindi chi emette i documenti
     * non se ne accorge; `users` non ce l'ha.
     *
     *
     * POLICY, decisa il 15/09/2026: nello standard i documenti li stampa lo STAFF. Chi ha
     * bisogno di farli stampare anche ai clienti amplia la regola in custom, sotto
     * mod/<modulo>/src/api/print/, che il .htaccess prova prima dello standard.
     *
     * Due conseguenze che chi arriva dopo non ricostruisce da solo:
     *
     * - su un deploy dove i clienti scaricano i propri documenti dall'area riservata, questo
     *   endpoint da solo NON basta e il custom serve. Non e' una regressione: e' il contratto.
     *   Chi aggiorna un deploy cosi' senza portarsi dietro il custom vede i clienti smettere
     *   di stampare, e la causa non e' qui;
     * - _documento.default.php e' l'eccezione consapevole: li' la regola larga ( destinatario,
     *   familiari, token ) sta nello standard, perche' quel file e' il modello per l'area
     *   riservata e non un endpoint di backoffice.
     * Stesso meccanismo degli endpoint `/task/` e dei sei di `/print/` chiusi lo stesso
     * giorno: verifica, log nel canale `security` a LOG_ERR, 403, exit.
     */
    checkTaskPrivilege( 'GESTIONE_DOCUMENTI' );

    // configurazioni specifiche
    $cnf['estensione'] = 'pdf';
    $cnf['cartella'] = 'ddt';
    $cnf['predefinito'] = 'ddt';
    $cnf['attivita'] = false;

    // inclusione dei dati base
    require DIR_BASE . '_mod/_0400.documenti/_src/_api/_print/_documento.default.php';

    // generazione, salvataggio e uscita
    require DIR_BASE . '_mod/_0400.documenti/_src/_api/_print/_documento.output.php';
