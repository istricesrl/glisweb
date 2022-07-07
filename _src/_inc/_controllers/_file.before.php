<?php

    /**
     *
     *
     *
     *
     *
     *
     * @todo come agire nei controller after
     * @todo documentare
     *
     * @file
     *
     */

    // log
	logWrite( "controller finally per ${t}/${a}", 'controller' );

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
        case METHOD_UPDATE:

            if( empty( $d['path'] ) ) {

                $i['__status__'] = 422;
                $a = NULL;

            }

        break;

	}
