<?php

    /**
     * esempio di modulaGiacenze()
     *
     * L'output e' controllato da _mod/_I0200.modula/_usr/_test/_tests/unit/modulaUtilsCest.php: le giacenze tornano
     * per codice, il pacchetto letto e' gia' confermato ( la seconda lettura non trova un pacchetto ripetuto ), e
     * senza giacenze il risultato e' un array vuoto e non un errore.
     *
     */

    require '../../../../../../_src/_config.php';

    // il server finto del WMS, acceso per dieci minuti
    touch( DIR_VAR . 'test/modula.fake.on' );
    $cf['modula']['profile']['url'] = $cf['site']['url'] . '_mod/_I0200.modula/_usr/_test/_fake/_wms.php';
    $cf['modula']['profile']['username'] = 'modula';
    $cf['modula']['profile']['password'] = 'fake';
    $cf['modula']['profile']['auth'] = 'bearer';

    modulaChiamata( '/reset', METHOD_POST );
    modulaChiamata( '/giacenze', METHOD_POST, array( 'A1' => 60, 'A2' => 0 ) );

    $giacenze = modulaGiacenze();
    var_dump( 'A1 giacenza ' . $giacenze['A1']['giacenza'] );
    var_dump( 'articoli ' . count( $giacenze ) );

    $pacchetto = modulaExport( $cf['modula']['profile']['jobs']['giacenze'] );
    var_dump( 'nuovo pacchetto ' . ( ( ! empty( $pacchetto['GUID'] ) ) ? 'si' : 'no' ) );
    modulaAck( $pacchetto['GUID'], $cf['modula']['profile']['jobs']['giacenze'] );

    modulaChiamata( '/giacenze', METHOD_POST, array() );
    var_dump( 'vuote ' . json_encode( modulaGiacenze() ) );
