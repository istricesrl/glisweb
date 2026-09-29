<?php

    /**
     * controller finally per la tabella anagrafica_categorie
     *
     * Dopo ogni scrittura o cancellazione su anagrafica_categorie rigenera la riga dell'anagrafica collegata nella vista statica
     * anagrafica_view_static, perché la vista porta le categorie dell'anagrafica. Il lavoro lo fa updateAnagraficaViewStatic(),
     * definita dal modulo anagrafica attivo ( _0010.anagrafica o _AN000.anagrafica ): senza nessuno dei due la vista
     * statica non c'è e il controller non fa niente.
     *
     * quale anagrafica
     * ================
     * L'anagrafica si ricava da due fonti, perché nessuna delle due c'è sempre:
     *
     * fonte                        | quando c'è
     * -----------------------------|-------------------------------------------------------------------------------
     * $befores['id_anagrafica']    | la riga com'era prima della query: controller() la legge solo per PUT, REPLACE,
     *                              | UPDATE e DELETE di una riga con id, quindi manca su un POST ( riga nuova )
     * $vs['id_anagrafica']['s']    | il valore scritto dalla query, con __parent_id__ già sostituito e l'eventuale
     *                              | codice_anagrafica già convertito dal controller before: manca su un DELETE
     *
     * Se le due fonti danno anagrafiche diverse ( la riga è passata da un'anagrafica a un'altra ) si aggiornano tutte e
     * due, perché quella di prima ha perso la riga e quella di adesso l'ha guadagnata.
     *
     * NOTA fino al 2026-09-29 questo controller guardava solo $befores, e su un POST la vista statica non si
     * aggiornava; chiamava inoltre la funzione parziale della vista ( updateAnagraficaViewStatic<Tabella>() ), che
     * senza la riga da completare scrive nella vista solo l'id e quindi non aggiornava niente nemmeno sulle modifiche.
     * Il modello è quello che _anagrafica.categorie.finally.php usava già, con updateAnagraficaViewStatic().
     *
     * @file
     *
     */

    // log
    logWrite( "controller finally per $t/$a", 'controller' );

    // elaborazioni di default dei dati
    switch( strtoupper( $a ) ) {

        case METHOD_POST:
        case METHOD_PUT:
        case METHOD_REPLACE:
        case METHOD_UPDATE:
        case METHOD_DELETE:

            // anagrafiche toccate dalla scrittura
            $idAnagrafiche = array_unique( array_filter( array(
                ( isset( $befores['id_anagrafica'] ) ) ? $befores['id_anagrafica'] : NULL,
                ( isset( $vs['id_anagrafica']['s'] ) ) ? $vs['id_anagrafica']['s'] : NULL
            ) ) );

            // aggiornamento della vista statica
            if( function_exists( 'updateAnagraficaViewStatic' ) ) {
                foreach( $idAnagrafiche as $idAnagrafica ) {
                    updateAnagraficaViewStatic( $idAnagrafica );
                    logWrite( "controller finally per $t/$a aggiornata la vista statica per l'anagrafica #" . $idAnagrafica, 'controller' );
                }
            }

        break;

    }
