<?php

    /**
     * utilita' per i job in background
     *
     * Queste funzioni risolvono un problema solo, ma che si ripresenta in ogni job che lavora su
     * un dataset: dove tenere il dataset fra un'iterazione e l'altra.
     *
     * Un job viene incluso da capo a ogni iterazione, quindi l'elenco su cui lavora va ricaricato
     * ogni volta. Lo schema storico e' memcache, con il ripiego di rileggere il file di partenza
     * quando la cache non risponde. Il ripiego pero' costa quanto tutto il file, a ogni
     * iterazione: su un dataset grande vuol dire riparsare lo stesso file migliaia di volte.
     *
     * IL 12/09/2026 QUESTO HA RIEMPITO UN FILESYSTEM DA 246 GB. L'importazione di 14.522
     * anagrafiche non entrava in memcache - 7,13 MB serializzati contro il limite da 1 MB per
     * elemento, set() rifiutata con MEMCACHED_E2BIG - e il job ha riletto e riparsato il CSV a
     * ogni iterazione, dodicimila volte. Con il livello di log a LOG_DEBUG, che e' il default in
     * DEV, ogni parsing scriveva il dataset intero nel log: 122 GB in un file solo.
     *
     * Il fallimento della cache ERA scritto, a LOG_ERR, in var/log/memcache.err.AAAAMM.log, alle
     * 00:13:02, cioe' nell'istante in cui il job si apriva. Una riga in un file che nessuno apre
     * non e' un allarme: per questo jobDatasetScrivi() restituisce l'esito a chi la chiama,
     * perche' finisca nel workspace del job, che e' quello che l'operatore guarda davvero.
     *
     * @file
     *
     */

    /**
     * scrive il dataset di un job dove potra' ritrovarlo alle iterazioni successive
     *
     * Prova prima memcache, che e' la strada veloce; se la cache rifiuta - tipicamente perche' il
     * dataset supera il limite per elemento - ripiega su un file di spool dedicato al job. Il file
     * costa un unserialize() per iterazione invece di un parsing completo, e non ha limiti di
     * dimensione.
     *
     * Scrive anche, UNA VOLTA SOLA, una copia leggibile del dataset sotto var/log/job/ID/ : e' il
     * debug di cosa si stava importando, tenuto accanto agli altri log di quel job invece che
     * spalmato nel canale mensile condiviso, dove le copie di lavorazioni diverse si accavallano
     * e non si distinguono.
     *
     * @param       array       $job    la riga del job, serve l'id
     * @param       array       $arr    il dataset
     * @return      array               array( 'dove' => 'cache'|'file'|'nessuno', 'nota' => ... )
     */
    function jobDatasetScrivi( $job, $arr ) {

        global $cf;

        $esito = array( 'dove' => 'nessuno', 'nota' => '' );

        if( empty( $job['id'] ) ) {
            $esito['nota'] = 'job senza id: il dataset non e\' stato salvato';
            return $esito;
        }

        // la copia leggibile, una volta sola, accanto agli altri log del job
        writeToFile(
            print_r( $arr, true ),
            DIR_VAR_LOG_JOB . $job['id'] . '/dataset.log',
            FILE_WRITE_OVERWRITE
        );

        // strada veloce
        if( ! empty( $cf['memcache']['connection'] ) ) {

            $e = memcacheWrite( $cf['memcache']['connection'], 'JOB_' . $job['id'] . '_DATA', $arr );

            if( ! empty( $e ) ) {
                $esito['dove'] = 'cache';
                $esito['nota'] = 'dataset salvato in cache';
                return $esito;
            }

        }

        // ripiego: un file di spool dedicato al job
        if( writeToFile( serialize( $arr ), jobDatasetFile( $job ), FILE_WRITE_OVERWRITE ) ) {

            $esito['dove'] = 'file';
            $esito['nota'] = 'dataset NON salvato in cache ( troppo grande o cache assente ): '
                           . 'ripiego sul file ' . jobDatasetFile( $job );

        } else {

            $esito['nota'] = 'dataset non salvato ne\' in cache ne\' su file: ogni iterazione '
                           . 'dovra\' rileggere il file di partenza da capo';

        }

        return $esito;

    }

    /**
     * rilegge il dataset di un job salvato da jobDatasetScrivi()
     *
     * @param       array       $job    la riga del job, serve l'id
     * @return      array|false         il dataset, oppure false se non lo si e' trovato
     */
    function jobDatasetLeggi( $job ) {

        global $cf;

        if( empty( $job['id'] ) ) {
            return false;
        }

        if( ! empty( $cf['memcache']['connection'] ) ) {

            $arr = memcacheRead( $cf['memcache']['connection'], 'JOB_' . $job['id'] . '_DATA' );

            if( ! empty( $arr ) ) {
                return $arr;
            }

        }

        $f = jobDatasetFile( $job );

        if( file_exists( getFullPath( $f ) ) ) {

            $arr = unserialize( trim( readFromFile( $f, FILE_READ_AS_STRING ) ) );

            if( is_array( $arr ) ) {
                return $arr;
            }

        }

        return false;

    }

    /**
     * cancella il file di spool del dataset, se c'e'
     *
     * Da chiamare nella chiusura del job: il file puo' pesare parecchio e non serve piu' a niente
     * una volta che il lavoro e' finito.
     *
     * @param       array       $job    la riga del job, serve l'id
     */
    function jobDatasetPulisci( $job ) {

        if( empty( $job['id'] ) ) {
            return;
        }

        $f = getFullPath( jobDatasetFile( $job ) );

        if( file_exists( $f ) ) {
            @unlink( $f );
        }

    }

    /**
     * percorso del file di spool del dataset di un job
     *
     * @param       array       $job    la riga del job, serve l'id
     * @return      string
     */
    function jobDatasetFile( $job ) {

        return DIR_VAR_SPOOL . 'job/' . $job['id'] . '.dataset';

    }
