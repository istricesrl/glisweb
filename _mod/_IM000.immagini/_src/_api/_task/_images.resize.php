<?php

    /**
     * scalamento delle immagini
     *
     * Questo task scala un'immagine della tabella `immagini` a ogni chiamata: marca una riga con il proprio token, produce
     * sotto `DIR_VAR_IMMAGINI` i formati di `$cf['image']['formats']` per il suo orientamento, i tagli per l'orientamento
     * opposto e le versioni WebP, poi toglie il token e scrive `timestamp_scalamento`. Usa `_src/_lib/_image.tools.php`;
     * la coda si guarda con il report `/status/images.resize.status` ( `_src/_api/_status/_images.resize.status.php` ), che
     * legge le righe con la stessa condizione, imageCondizioneCoda(). Richiede il privilegio `GESTIONE_SISTEMA` ed è
     * pensato per il cron ogni minuto con più iterazioni: quando la coda è vuota interrompe le iterazioni residue.
     *
     * Fino al 2026-10-30 il task esisteva in due copie, questa e `_src/_api/_task/_images.resize.php`, che era quella
     * nella tabella `task` e calcolava l'orientamento opposto uguale a quello dell'immagine: i tagli sovrascrivevano i
     * formati e le versioni dell'altro orientamento non nascevano. Ora c'è solo questa, e la riga 1 di `task` punta qui
     * ( `_202610301000.immagini.scalamento.sql` per i database installati ).
     *
     * modalità di scalamento
     * ======================
     * parametro        | comportamento
     * -----------------|------------------------------------------------------------------------------------------
     * id=<id>          | scala l'immagine indicata anche se non è in coda, togliendo qualsiasi token e azzerando i tentativi
     * nessuno          | scala la prima immagine in coda per `timestamp_scalamento` e `ordine`
     *
     * righe marcate e mai rilasciate
     * ==============================
     * Il task scrive in `timestamp_elaborazione` l'ora della marcatura, nello stesso UPDATE del token. Se il processo
     * muore a metà ( un'immagine troppo grande per la memoria, un timeout ) la riga resterebbe marcata e fuori dalla coda
     * per sempre: per questo all'inizio di ogni giro il task toglie il token alle righe marcate da più di
     * `$cf['image']['minuti_sblocco']` minuti ( default 60, in `_src/_config/_360.image.php` ) e conta il giro
     * abbandonato in `tentativi`. Le righe marcate prima del 2026-10-30 non hanno `timestamp_elaborazione` e si sbloccano
     * al primo giro. È lo stesso recupero del task della coda mail ( `_src/_api/_task/_mail.queue.send.php` ).
     *
     * token di stato
     * ==============
     * Due token tolgono una riga dalla coda e dallo sblocco senza che nessun processo la stia lavorando:
     *
     * token            | significato
     * -----------------|------------------------------------------------------------------------------------------
     * NON_SCALABILE    | il file non è un JPEG, un PNG o un WebP ( un SVG, un PDF ), o non è un'immagine leggibile; lo mette il controller di `immagini` in scrittura, o questo task se la riga è stata scritta senza controller, e lo toglie il controller quando il percorso torna scalabile
     * TROPPI_TENTATIVI | i giri abbandonati sono arrivati a `$cf['image']['tentativi_massimi']` ( default 3, con 0 il limite non c'è ); l'errore va nel log `image` a livello LOG_ERR, e la riga la fa ripartire `id=<id>`, cioè lo scalamento forzato dalla scheda dell'immagine
     *
     * @file
     *
     */

    // inclusione del framework
    if( ! defined( 'CRON_RUNNING' ) ) {
        if( ! defined( 'INCLUDE_SUBDIR' ) ) {
            require '../../../../../_src/_config.php';
        } else {
            require INCLUDE_SUBDIR . '_config.php';
        }
    }

    // verifica dei privilegi
    checkTaskPrivilege( 'GESTIONE_SISTEMA' );

    // inizializzo l'array del risultato
    $status = array();

    // status
    $status['info'][] = 'inizio operazioni di scalatura';

    // chiave di lock
    if( ! isset( $status['token'] ) ) {
        $status['token'] = getToken( __FILE__ );
    }

    // sblocco delle immagini marcate e mai rilasciate
    // NOTA restano fuori le righe con i token di stato; una marcatura senza timestamp_elaborazione è di prima del 2026-10-30
    $status['sbloccate'] = mysqlQuery(
        $cf['mysql']['connection'],
        'UPDATE immagini SET token = NULL, timestamp_elaborazione = NULL, tentativi = coalesce( tentativi, 0 ) + 1 '.
        'WHERE token IS NOT NULL AND token NOT IN ( ?, ? ) AND ( timestamp_elaborazione IS NULL OR timestamp_elaborazione < ? )',
        array(
            array( 's' => 'NON_SCALABILE' ),
            array( 's' => 'TROPPI_TENTATIVI' ),
            array( 's' => strtotime( '-' . $cf['image']['minuti_sblocco'] . ' minutes' ) )
        )
    );

    // log
    if( ! empty( $status['sbloccate'] ) ) {
        logWrite( 'sbloccate ' . $status['sbloccate'] . ' immagini marcate da più di ' . $cf['image']['minuti_sblocco'] . ' minuti', 'image', LOG_WARNING );
    }

    // fermo le immagini che hanno abbandonato troppi giri
    if( ! empty( $cf['image']['tentativi_massimi'] ) ) {

        // token di stato
        $status['ferme'] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE immagini SET token = ? WHERE token IS NULL AND tentativi >= ?',
            array(
                array( 's' => 'TROPPI_TENTATIVI' ),
                array( 's' => $cf['image']['tentativi_massimi'] )
            )
        );

        // log
        if( ! empty( $status['ferme'] ) ) {
            logWrite( 'fermate ' . $status['ferme'] . ' immagini dopo ' . $cf['image']['tentativi_massimi'] . ' giri abbandonati, le riparte lo scalamento forzato', 'image', LOG_ERR );
        }

    }

    // se è specificato un ID, forzo la richiesta
    if( isset( $_REQUEST['id'] ) ) {

        // token della riga
        // NOTA azzera i tentativi: è l'unico modo di far ripartire una riga ferma per troppi tentativi
        $status['id'] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE immagini SET token = ?, timestamp_elaborazione = ?, tentativi = 0 WHERE id = ?',
            array(
                array( 's' => $status['token'] ),
                array( 's' => time() ),
                array( 's' => $_REQUEST['id'] )
            )
        );

    } else {

        // token della riga
        $status['id'] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE immagini SET token = ?, timestamp_elaborazione = ? WHERE ' . imageCondizioneCoda() . ' '.
            'ORDER BY immagini.timestamp_scalamento ASC, immagini.ordine ASC LIMIT 1',
            array(
                array( 's' => $status['token'] ),
                array( 's' => time() )
            )
        );

    }

    // prelevo un'immagine dalla coda
    $im = mysqlSelectRow(
        $cf['mysql']['connection'],
        'SELECT immagini.*
        FROM immagini
        WHERE token = ? ',
        array( array( 's' => $status['token'] ) )
    );

    // se c'è almeno un'immagine da scalare'
    if( ! empty( $im ) ) {

        // imposto i path
        $im1 = $im['path'];
        $im2 = ( ! empty( $im['path_alternativo'] ) ) ? $im['path_alternativo'] : ( ( empty( $im['orientamento'] ) ) ? $im['path'] : NULL );
        $wgh = $im['taglio'];

        // completo i path
        fullPath( $im1 );
        fullPath( $im2 );

        // controllo che il file sia scalabile
        // NOTA serve per le righe scritte senza passare dal controller di immagini, che il token lo mette da sé
        if( ! imageScalabile( (string) $im['path'] ) || ( file_exists( $im1 ) && imageSize( $im1 ) === false ) ) {

            // token di stato
            mysqlQuery(
                $cf['mysql']['connection'],
                'UPDATE immagini SET token = ?, timestamp_elaborazione = NULL WHERE token = ?',
                array(
                    array( 's' => 'NON_SCALABILE' ),
                    array( 's' => $status['token'] )
                )
            );

            // status
            $status['err'][] = 'immagine non scalabile ' . $im1;

            // log
            logWrite( 'immagine non scalabile #' . $im['id'] . ' ' . $im1, 'image', LOG_WARNING );

        } elseif( file_exists( $im1 ) ) {

            // se l'immagine non è nella cartella immagini, la copio
            if( ! file_exists( DIR_VAR_IMMAGINI . basename( $im1 ) ) ) {
                copyFile( $im1, DIR_VAR_IMMAGINI . basename( $im1 ) );
            }

            // determino le dimensioni dell'immagine
            $dm = imageSize( $im1 );

            // prelevo l'orientamento dell'immagine
            $j = $dm['o'];

            // orientamento opposto, per i tagli e le scalature alternative
            $k = ( $j == 'l' ) ? 'p' : ( ( ( $j == 'p' ) ) ? 'l' : 's' );

            // array dei formati
            $ks = array_flip( $cf['image']['formats'][ $j ] );

            // creo la versione webp
            imageConvert( $im1, 'webp' );

            // scalo e taglio l'immagine per i vari formati
            foreach( $cf['image']['formats'][ $j ] as $d1 => $d1a ) {

                $dst = DIR_VAR_IMMAGINI . $d1 . $j . '/' . basename( $im1 );
                imageResize( $im1, $d1, $dst );

                $webp = imageConvert( $dst, 'webp' );
                copyFile( $webp, DIR_VAR_IMMAGINI . basename( $webp ) );

            }

            // scalo e taglio l'immagine per formati alternativi
            // TODO non va bene ! empty() usare file_exists o qualcosa del genere perché $im2 contiene il path base se è vuota
            if( ! empty( $im2 ) ) {

                foreach( $cf['image']['formats'][ $k ] as $d1 => $d1a ) {

                    if( ! empty( $im['path_alternativo'] ) ) {

                        $dst = DIR_VAR_IMMAGINI . $d1 . $k . '/' . basename( $im1 );
                        imageResize( $im2, $d1, $dst );
                        imageConvert( $dst, 'webp' );

                        $status[ $im1 ]['scalature'][ $k ][ $d1a ] = $dst;

                    } else {

                        if( isset( $ks[ $d1a ] ) ) {

                            $dst = DIR_VAR_IMMAGINI . $d1 . $k . '/' . basename( $im1 );
                            imageResize( $im2, $d1a, $dst );

                            imageCut(
                                $dst,
                                $d1,
                                $dst,
                                $wgh
                            );
                            imageConvert( $dst, 'webp' );

                            $status[ $im1 ]['tagli'][ $k ][ $d1 ] = $dst;

                        }

                    }

                }

            }

            // risultato
            $status = array_replace_recursive(
                mysqlSelectRow( $cf['mysql']['connection'], 'SELECT * FROM __report_immagini_scalate__' )
                ,
                $status
            );

            // log
            logWrite( 'scalamento di ' . $im1 . ' completato', 'image' );

        } else {

            // status
            $status['err'][] = 'immagine inesistente ' . $im1;

            // log
            logWrite( 'immagine inesistente ' . $im1, 'image', LOG_WARNING );

        }

        // aggiornamento database
        // NOTA non tocca una riga appena marcata NON_SCALABILE, che non ha più il token di questo giro
        mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE immagini SET token = NULL, timestamp_elaborazione = NULL, tentativi = 0, timestamp_scalamento = unix_timestamp(), '.
            'timestamp_aggiornamento = unix_timestamp() WHERE token = ?',
            array(
                array( 's' => $status['token'] )
            )
        );

    } else {

        // chiudo il ciclo
        $iter = $task['iterazioni'] ?? 0;

        // status
        $status['info'][] = 'nessuna immagine da scalare';

        // log
        logWrite( 'nessuna immagine in coda da scalare', 'image' );

    }

    // output
    if( ! defined( 'CRON_RUNNING' ) ) {
        buildJson( $status );
    }
