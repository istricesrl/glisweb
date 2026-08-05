<?php

    /**
     * dichiarazione dell'etichetta dei colli
     *
     * L'etichetta stampata da _mod/_5600.colli/_src/_api/_print/_etichette.colli.php porta il nome della
     * tipologia di collo e il barcode del codice; le misure che seguono sono quelle storiche, calibrate sul
     * formato 57 x 32 mm.
     *
     * Un progetto che monta un rotolo diverso ridefinisce nel proprio config.json il solo formato:
     *
     *     "etichette": { "colli": { "formato": [ 65, 56 ] } }
     *
     * e il contenuto viene riscalato di conseguenza. Vedi _src/_config/_370.etichette.php per la convenzione
     * e scalaEtichetta() in _src/_lib/_pdf.tools.php per il calcolo.
     *
     * @file
     *
     */

    // etichetta dei colli
    // NB: massimo non è una misura, è il tetto di etichette per stampa: oltre quel numero l'API si ferma
    // e chiede di restringere i criteri, invece di mandare in stampa un PDF di dimensioni impreviste
    $cf['etichette']['colli'] = array(
        'formato'       => array( 57, 32 ),
        'allineamento'  => 'alto',
        'massimo'       => 500,
        'riferimento'   => array(
            'formato'       => array( 57, 32 ),
            'verticali'     => array(
                'margine'       => 2,
                'interlinea'    => 1,
                'barcode'       => 18
            ),
            'caratteri'     => array(
                'tipologia'     => 10,
                'barcode'       => 8
            )
        )
    );

    // debug
    // dieText( print_r( $cf['etichette']['colli'], true ) );
