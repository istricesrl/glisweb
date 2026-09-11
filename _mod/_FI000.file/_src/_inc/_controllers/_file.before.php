<?php

    /**
     *
     *
     *
     *
     *
     *
     * TODO come agire nei controller after
     * TODO documentare
     *
     * 
     *
     */

    // log
	logWrite( "controller finally per $t/$a", 'controller' );

    // elaborazioni di default dei dati
	switch( strtoupper( $a ) ) {

        case METHOD_DELETE:

            $id_mail = mysqlSelectValue( $c, 'SELECT id_mail_out FROM file WHERE id = ?', array( array( 's' => $d['id'] ) ) );
            if( !empty( $id_mail ) ) {
                $file = mysqlSelectColumn( 'path', $c, 'SELECT path FROM file WHERE id_mail_out = ? AND id <> ?', array( array( 's' => $id_mail ), array( 's' => $d['id'] ) ) );
                 mysqlQuery( $c, 'UPDATE mail_out SET allegati = ? WHERE id = ?', array( array( 's' => serialize( $file ) ), array( 's' => $id_mail ) ) );
            }

        break;

	}

    // controllo validità del pacchetto dati
	switch( strtoupper( $a ) ) {

        case METHOD_POST:

            // in inserimento il file è sempre obbligatorio
            if( empty( $d['path'] ) ) {

                logWrite( "inserimento di $t bloccato: campo path assente o vuoto", 'controller', LOG_ERR );

                $i['__status__'] = 422;
                $a = NULL;

            }

        break;

        case METHOD_UPDATE:

            // in aggiornamento il controllo vale solo se la maschera che ha inviato i dati contiene
            // davvero il campo path: le altre schede del form file (collegamenti, immagini) non lo
            // hanno e non devono essere bloccate
            if( array_key_exists( 'path', $d ) && empty( $d['path'] ) ) {

                logWrite( "aggiornamento di $t bloccato: campo path svuotato", 'controller', LOG_ERR );

                $i['__status__'] = 422;
                $a = NULL;

            }

        break;

	}
