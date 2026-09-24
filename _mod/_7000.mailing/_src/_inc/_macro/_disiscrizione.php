<?php

    /**
     *
     *
     *
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // ...
    if( isset( $_REQUEST['mtk'] ) && isset( $_REQUEST['isc'] ) ) {

        // ...
        $row = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT * FROM mail WHERE id = ?',
            array(
                array( 's' => $_REQUEST['isc'] )
            )
        );

        if( $_REQUEST['mtk'] == md5( $_REQUEST['isc'] . $row['indirizzo'] ) ) {

            // ...
            $ct['page']['h1']['it-IT'] = 'disiscrizione dalla newsletter';

            // ...
            $ct['page']['content']['it-IT'] = 'disiscrizione dalla newsletter effettuata con successo';

        } else {

            // ...
            $ct['page']['h1']['it-IT'] = 'disiscrizione dalla newsletter fallita';

            // ...
            $ct['page']['content']['it-IT'] = 'impossibile effettuare la disiscrizione dalla newsletter con i dati forniti ('.$row['indirizzo'].'), contattare il supporto tecnico per risolvere il problema';

        }

    } else {

        // ...
        $ct['page']['h1']['it-IT'] = 'disiscrizione dalla newsletter impossibile';

        // ...
        $ct['page']['content']['it-IT'] = 'dati forniti insufficienti per procedere con la disiscrizione';

    }
