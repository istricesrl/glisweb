<?php

    /**
     * controller before per la tabella file
     *
     * Su DELETE, se il file è un allegato di una mail in coda ( file.id_mail_out ), riscrive mail_out.allegati con i
     * percorsi degli altri allegati, così la mail non parte con un file che non c'è più; lo fa qui e non in un finally
     * perché dopo la cancellazione la riga non dice più a quale mail apparteneva. Su POST e UPDATE rifiuta una riga
     * senza path: mette 422 in $i['__status__'] e azzera $a, e controller() non esegue la query.
     *
     * NOTA fino al 2026-09-29 la riga di log diceva "controller finally", copiata da un altro controller.
     *
     * @file
     *
     */

    // log
	logWrite( "controller before per $t/$a", 'controller' );

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
