<?php

/**
     *
     * @todo documentare
     *
     */

    // STEP 1 - se esiste un pacchetto dati per __carrello__

    // verifico se è presente una richiesta per il modulo ecommerce
        if( isset( $_REQUEST['__carrello__'] ) && is_array( $_REQUEST['__carrello__'] ) ) {

            // STEP 2 - se non esiste $_SESSION['carrello'] lo creo
                if( ! isset( $_SESSION['carrello']['id'] ) ) {

                    // TODO qui inizializzo TUTTI i valori del carrello

                } else {

                    // TODO qui aggiorno la timestamp_aggiornamento del carrello

                }

            // STEP 3 - aggiorno i dati del carrello

            // STEP 4 - gestione acquisto singolo articolo

            // STEP 5 - aggiorno gli articoli

            // modifica articoli
                if( isset( $_REQUEST['__carrello__']['__articoli__'] ) && is_array( $_REQUEST['__carrello__']['__articoli__'] ) ) {

                    // ciclo sugli articoli
                        foreach( $_REQUEST['__carrello__']['__articoli__'] as $articolo => $dati ) {

                            // TODO aggiornare le righe degli articoli

                        }

                }

            // STEP 6 - calcolo coupon

            // STEP 7 - calcoli finali

            // STEP 8 - scrittura di $_SESSION['carrello'] su carrelli e di $_SESSION['carrello']['articoli'] su carrelli_articoli

            // STEP 9 - salvataggio copia di sicurezza del carrello

            // salvataggio di sicurezza del carrello
            $f = DIR_VAR_SPOOL_CART . sprintf( '%08d', $_SESSION['carrello']['id'] ) . '.log';
            writeToFile( print_r( $_SESSION['carrello'], true ), $f );            

    }
