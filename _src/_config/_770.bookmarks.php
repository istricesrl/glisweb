<?php

    /**
     * configurazione della memoria di lavoro volatile del sito
     * 
     * introduzione
     * ============
     * Il framework supporta una memoria di lavoro volatile collegata alla sessione per "portarsi dietro" un oggetto
     * da una schermata all'altra. Ad esempio, è possibile "pinnare" un'anagrafica per poi ritrovarsela nel campo
     * cliente quando si va a creare una fattura.
     * 
     * Questo meccanismo funziona grazie all'API bookmarks che si occupa di gestire l'inserimento e la rimozione degli
     * oggetti dalla memoria di lavoro, insieme ai file _770.bookmarks.php e _775.bookmarks.php. Per aggiungere un
     * oggetto, ad esempio un'anagrafica, alla memoria di lavoro si può utilizzare una chiamata come questa:
     * 
     * ```
     * https://glisweb.istricesrl.it/api/bookmarks?__work__[anagrafica][items][1][id]=1&__work__[anagrafica][items][1][label]=Fabio%20Mosti
     * 
     * ```
     * 
     * Questo produrrà nella memoria di lavoro il salvataggio dell'oggetto indicato; di conseguenza la memoria di lavoro risulterà:
     * 
     * ```
     * {
     *     "anagrafica": {
     *         "items": {
     *         "1": {
     *             "id": "1",
     *             "label": "Fabio Zorro La Volpe Mosti"
     *         }
     *         },
     *         "label": "anagrafica"
     *     }
     * }
     * ```
     * 
     * Reinviare un oggetto già presente nella memoria di lavoro ne provocherà la rimozione.
     * 
     * utilizzo nel template athena
     * ============================
     * Il template athena utilizza il meccanismo dei bookmarks per portare gli oggetti da una schermata all'altra. In molte viste è disponibile
     * un'icona che utilizza la funzione metroWs() per inviare al backend l'oggetto da salvare, e utilizza come callback la funzione aggiornaBookmarks()
     * che si occupa di aggiornare la visualizzazione dei bookmarks in tempo reale. Per quanto riguarda le chiamate sincrone, i bookmarks vengono
     * rappresentati insieme agli altri widget in /_src/_templates/_athena/inc/header.html.
     * 
     * 
     * 
     * 
     * 
     */

    /**
     * configurazione dei bookmarks
     * ============================
     * 
     * 
     */

    // definisco i gruppi funzionali per cui possono essere aggiunti bookmarks
    $cf['bookmarks'] = array(
        'anagrafica' => array(
            'label' => 'anagrafica'
        ),
        'documenti' => array(
            'label' => 'documenti',
            'actions' => array(
                'mailattach' => array(
                    'label' => 'vai alla creazione della mail',
                    'url' => $cf['contents']['pages']['mail.out.form']['url'][ LINGUA_CORRENTE ]
                )
            )
        )
    );

    /**
     * debug del runlevel
     * ==================
     * 
     * 
     */

    // debug
    // die( print_r( $cf['bookmarks'], true ) );
