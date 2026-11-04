<?php

    /**
     * controller before per la tabella anagrafica_certificazioni
     *
     * Su DELETE cancella i file allegati alla certificazione: la riga di file, e il file su disco lo sposta nel cestino con
     * trashFile(), da dove emptyTrash() lo toglie dopo i giorni di common.garbage.giorni. Senza questo controller
     * il file resta sul disco anche dove la FK file.id_anagrafica_certificazioni è ON DELETE CASCADE ( lo standard ), e
     * dove è SET NULL restano anche le righe, senza padrone: su un certificato medico sono dati sanitari orfani. Lo fa
     * qui e non in un finally perché dopo la cancellazione le righe di file non dicono più a quale certificazione
     * appartenevano. Un percorso usato anche da un'altra riga di file non si cancella dal disco. Niente $f o $file
     * come variabili: $f è il ciclo di controller() che include questo file.
     *
     * @file
     *
     */

    // log
	logWrite( "controller before per $t/$a", 'controller' );

    // elaborazioni di default dei dati
	switch( strtoupper( $a ) ) {

        case METHOD_DELETE:

            if( ! empty( $d['id'] ) ) {

                $allegati = mysqlQuery( $c, 'SELECT id, path FROM file WHERE id_anagrafica_certificazioni = ?', array( array( 's' => $d['id'] ) ) );

                foreach( $allegati as $allegato ) {

                    mysqlQuery( $c, 'DELETE FROM file WHERE id = ?', array( array( 's' => $allegato['id'] ) ) );

                    if( ! empty( $allegato['path'] ) && ! mysqlSelectValue( $c, 'SELECT count(*) FROM file WHERE path = ?', array( array( 's' => $allegato['path'] ) ) ) ) {
                        if( ! trashFile( $allegato['path'] ) ) {
                            logWrite( 'impossibile spostare nel cestino ' . $allegato['path'] . ' della certificazione #' . $d['id'], 'certificazioni', LOG_ERR );
                        }
                    }

                }

            }

        break;

	}
