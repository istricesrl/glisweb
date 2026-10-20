<?php

    // inclusione del framework
    if( ! defined( 'CRON_RUNNING' ) ) {
        if( ! defined( 'INCLUDE_SUBDIR' ) ) {
            require '../../_config.php';
        } else {
            require INCLUDE_SUBDIR . '_config.php';
        }
    }

    // verifica dei privilegi
    checkTaskPrivilege( 'GESTIONE_ANAGRAFICA' );

    // inizializzo l'array del risultato
    $status = array();

    // file da copiare
    $status['files'] = array(
        'https://dataserver.istricesrl.com/geografia/01.update.stati.csv',
        'https://dataserver.istricesrl.com/geografia/02.update.regioni.csv',
        'https://dataserver.istricesrl.com/geografia/03.update.provincie.csv',
        'https://dataserver.istricesrl.com/geografia/04.update.comuni.csv'
    );

    // tabelle geografiche, ciascuna col file della sua archiviazione
    $geografia = array(
        'stati'     => 'https://dataserver.istricesrl.com/geografia/05.update.stati.archiviazione.csv',
        'regioni'   => 'https://dataserver.istricesrl.com/geografia/06.update.regioni.archiviazione.csv',
        'provincie' => 'https://dataserver.istricesrl.com/geografia/07.update.provincie.archiviazione.csv',
        'comuni'    => 'https://dataserver.istricesrl.com/geografia/08.update.comuni.archiviazione.csv'
    );

    // tabelle che hanno le colonne dell'archiviazione
    // NOTA un deploy che non ha ancora lo schema nuovo non scarica i file dell'archiviazione: l'importazione
    // fallirebbe riga per riga sulle colonne che non conosce
    $archiviabili = mysqlSelectColumn(
        'TABLE_NAME',
        $cf['mysql']['connection'],
        'SELECT TABLE_NAME FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = database() AND COLUMN_NAME IN ( "data_archiviazione", "note_archiviazione", "id_successore" )
        AND TABLE_NAME IN ( "' . implode( '", "', array_keys( $geografia ) ) . '" )
        GROUP BY TABLE_NAME HAVING count( * ) = 3'
    );

    foreach( $geografia as $tabella => $file ) {
        if( in_array( $tabella, (array) $archiviabili ) ) {
            $status['files'][] = $file;
        } else {
            $status['saltati'][] = $file;
        }
    }

    // scarico i CSV
    foreach( $status['files'] as $file ) {
        if( ! copyFile( $file, DIR_VAR_SPOOL_IMPORT . '/' . basename( $file ) ) ) {
            $status['err'][] = 'impossibile scaricare ' . $file;
        }
    }

    // rimappaggio dei riferimenti ai luoghi archiviati
    // NOTA si spostano sul successore solo i riferimenti vivi ( la residenza, la cittadinanza, la zona ); restano
    // dove sono i campi che fotografano un fatto avvenuto: il luogo di nascita, i dati del destinatario e
    // dell'intestatario di carrelli e corrispondenza, l'emittente dei documenti; restano fuori anche le tabelle
    // geografiche, la cui gerarchia la tiene l'allineamento all'ISTAT, le viste statiche, che si rigenerano, e
    // metadati.id_stato, che non e' un luogo
    // NOTA il rimappaggio lavora sullo stato del database: i CSV appena scaricati li importa il cron al giro
    // successivo, e il rimappaggio di quei dati lo fa il task la volta dopo
    if( ! empty( $archiviabili ) ) {

        // colonne che puntano alle tabelle geografiche archiviabili
        $colonne = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT TABLE_NAME AS tabella, COLUMN_NAME AS colonna, REFERENCED_TABLE_NAME AS geografia
            FROM information_schema.KEY_COLUMN_USAGE
            WHERE TABLE_SCHEMA = database()
            AND REFERENCED_TABLE_NAME IN ( "' . implode( '", "', $archiviabili ) . '" )
            AND TABLE_NAME NOT IN ( "stati", "regioni", "provincie", "comuni", "metadati" )
            AND TABLE_NAME NOT LIKE "%\\_view\\_static" AND TABLE_NAME NOT LIKE "\\_\\_%"
            AND COLUMN_NAME NOT LIKE "%\\_nascita"
            AND COLUMN_NAME NOT LIKE "destinatario\\_%" AND COLUMN_NAME NOT LIKE "intestazione\\_%" AND COLUMN_NAME NOT LIKE "emittente\\_%"'
        );

        // NOTA anagrafica_indirizzi.id_comune non ha la chiave esterna, quindi information_schema non la elenca
        if( in_array( 'comuni', $archiviabili ) && mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT count( * ) FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = database() AND TABLE_NAME = "anagrafica_indirizzi" AND COLUMN_NAME = "id_comune"'
        ) ) {
            $colonne[] = array( 'tabella' => 'anagrafica_indirizzi', 'colonna' => 'id_comune', 'geografia' => 'comuni' );
        }

        foreach( (array) $colonne as $rif ) {

            $chiave = $rif['tabella'] . '.' . $rif['colonna'];
            $status['rimappati'][ $chiave ] = 0;

            // NOTA un luogo puo' essere confluito in un altro poi archiviato a sua volta: si ripete finche' la
            // catena si esaurisce, con un tetto contro i cicli
            for( $giro = 0; $giro < 5; $giro++ ) {

                $n = mysqlQuery(
                    $cf['mysql']['connection'],
                    'UPDATE ' . $rif['tabella'] . ' AS t INNER JOIN ' . $rif['geografia'] . ' AS g ON g.id = t.' . $rif['colonna'] . '
                    SET t.' . $rif['colonna'] . ' = g.id_successore
                    WHERE g.id_successore IS NOT NULL'
                );

                if( empty( $n ) ) {
                    break;
                }

                $status['rimappati'][ $chiave ] += $n;

            }

        }

    }

    // output
    if( ! defined( 'CRON_RUNNING' ) ) {
        buildJson( $status );
    }
