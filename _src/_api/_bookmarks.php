<?php

    /**
     * API per la visualizzazione dei bookmarks attivi
     * 
     * questa API restituisce la situazione corrente del workspace con tutti gli oggetti attivi
     * 
     * introduzione
     * ============
     * Il workspace è un'area di lavoro in sessione dedicata al mantenimento di dati utili ma volatili. La sua natura
     * è prettamente transitoria e il suo scopo è quello di facilitare l'inserimento dati e in generale le operazioni
     * con il CMS.
     * 
     * test dei bookmarks
     * ------------------
     * Per visualizzare la situazione corrente dei bookmarks chiamare l'endpoint /api/bookmarks. Per settare un nuovo
     * bookmark è possibile chiamare l'endpoint /api/bookmarks specificando l'oggetto che si vuole inserire, ad esempio:
     * 
     * ```
     * /api/bookmarks?__work__[anagrafica][items][1][id]=1&__work__[anagrafica][items][1][label]=Mosti%20Zorro
     * ```
     * 
     * Si noti che la chiave sotto __work__ (in questo caso anagrafica) dev'essere fra quelle previste nel file
     * /_src/_config/_770.bookmarks.php, e che le sotto chiavi richieste sono al minimo id e label. La chiamata di esempio
     * qppena fatta creerà quindi la seguente struttura nell'area di lavoro:
     * 
     * ```
     * {
     *  "anagrafica": {
     *      "items": {
     *          "1": {
     *              "id": "1",
     *              "label": "Mosti Zorro"
     *          }
     *      },
     *      "label": "anagrafica"
     *  }
     * }
     * ```
     * 
     * Solitamente per chiarezza si fa coincidere la chiave che identifica l'intero oggetto con il suo ID (in questo caso 1).
     * Chiamare un oggetto già presente nel workspace, anche semplicemente per ID, lo elimina:
     * 
     * ```
     * /api/bookmarks?__work__[anagrafica][items][1][id]=1
     * ```
     * 
     * Questo rimuoverà l'oggetto 1 dall'area di lavoro, che ora risulterà comunque inizializzata, ma vuota:
     * 
     * ```
     * {
     *  "anagrafica": {
     *      "items": [],
     *      "label": "anagrafica"
     *  }
     * }
     * ```
     * 
     * Per ulteriori informazioni su questo meccanismo si veda la documentazione dei file /_src/_config/_710.session.php e
     * /_src/_config/_715.session.php, e dei file /_src/_config/_770.bookmarks.php e /_src/_config/_775.bookmarks.php.
     * 
     */

    // inclusione del framework
    require '../_config.php';

    // output
    buildJson( ( isset( $_SESSION['__work__'] ) ? $_SESSION['__work__'] : array( 'status' => 'nessun bookmark trovato' ) ) );
