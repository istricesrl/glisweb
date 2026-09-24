<?php

    /**
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * NOTA i commenti che iniziano con CUSTOM si riferiscono al codice da personalizzare
     * 
     * 
     * 
     * TODO documentare
     * 
     * 
     */

    // inizializzo l'array del risultato
    $status = array();

    // inclusione del framework
    if( defined( 'CRON_RUNNING' ) || defined( 'JOB_RUNNING' ) ) {

        /**
         * CUSTOM verifiche formali
         *
         * ATTENZIONE al confronto: si guarda `corrente > totale`, non `corrente >= totale`.
         *
         * "corrente >= totale" vuol dire che l'ultima riga e' stata lavorata, NON che il job sia
         * finito: la chiusura viene dopo. Chi scrive qui `>=` fa in modo che, se la chiusura non
         * riesce, ogni iterazione successiva finisca in questo ramo a dire "gia' completato"
         * senza fare niente — e il job resta fermo a un passo dalla fine per sempre, senza che
         * lo sblocchi il browser, il cron o l'azzeramento del token di lock.
         *
         * Con `>` invece l'iterazione dedicata alla chiusura ( quella in cui corrente diventa
         * totale + 1 ) puo' essere rieseguita finche' non riesce, perche' `corrente` viene
         * salvato a database soltanto quando si e' lavorato davvero. Vedi la sezione "Job in
         * background" di _etc/_claude/_claude.framework.md.
         */
        if( isset( $job['corrente'] ) && $job['corrente'] > $job['totale'] ) {

            // CUSTOM status
            $status['info'][] = 'iterazione a vuoto su job già completato';

        } elseif( empty( $job['workspace']['file'] ) ) {

            // CUSTOM status
            $status['error'][] = 'questo job richiede un file su cui lavorare';

        } elseif( empty( $job['workspace']['function'] ) ) {

            // CUSTOM status
            $status['error'][] = 'questo job richiede una funzione da eseguire';

        } else {

            // attività di avvio
            if( empty( $job['corrente'] ) ) {

                // CUSTOM apro il file
                $arr = readFromFile( $job['workspace']['file'] );

                // segno il totale delle cose da fare
                $job['totale'] = count( $arr );

                // avvio il contatore
                $job['corrente'] = 1;

                // timestamp di avvio
                if( empty( $job['timestamp_apertura'] ) ) {
                    mysqlQuery(
                        $cf['mysql']['connection'],
                        'UPDATE job SET timestamp_apertura = ? WHERE id = ?',
                        array(
                        array( 's' => time() ),
                        array( 's' => $job['id'] )
                        )
                    );
                }

            } else {

                // CUSTOM apro il file
                // NOTA casomai l'area di lavoro corrente provenisse da un posto diverso rispetto a quella di avvio
                $arr = readFromFile( $job['workspace']['file'] );

                // incremento l'indice di lavoro
                $job['corrente']++;

            }

            /**
             * operazioni di chiusura
             *
             * La chiusura sta in un ramo ALTERNATIVO al lavoro, e non in coda al lavoro: e'
             * un'iterazione tutta sua, quella in cui `corrente` diventa `totale` + 1. Il motivo
             * e' che `corrente` viene salvato a database solo nel ramo del lavoro ( in fondo ),
             * quindi se la chiusura non arriva in fondo a database resta l'avanzamento
             * precedente e l'iterazione dopo la ritenta da capo. Chiudere in coda al lavoro,
             * dopo aver gia' salvato l'avanzamento, rende invece il job irrecuperabile.
             *
             * Da qui due regole per il codice che si mette qui dentro:
             *
             * - dev'essere IDEMPOTENTE, perche' puo' essere eseguito piu' volte;
             * - dev'essere BREVE. Il lavoro pesante va spalmato sulle iterazioni, che e' il
             *   motivo per cui i job esistono. Una chiusura che dura piu' del tempo massimo di
             *   una richiesta viene uccisa a meta' ogni volta, e allora il job non finisce mai.
             *   Se proprio non se ne puo' fare a meno, darle un set_time_limit() suo.
             */
            if( empty( $job['totale'] ) || $job['corrente'] > $job['totale'] ) {

                // CUSTOM link del risultato
                $status['result']['link'] = $job['workspace']['file'];
                $status['result']['label'] = basename( $job['workspace']['file'] );

                // scrivo la timestamp di completamento
                $jobs = mysqlQuery(
                    $cf['mysql']['connection'],
                    'UPDATE job SET timestamp_completamento = ? WHERE id = ?',
                    array(
                    array( 's' => time() ),
                    array( 's' => $job['id'] )
                    )
                );

                // CUSTOM notifiche di fine attività
                    // TODO

            } else {

                // aggiusto l'indice di lavoro (gli array partono da zero)
                $widx = $job['corrente'] - 1;

                // CUSTOM lavoro del job
                switch( $job['workspace']['function'] ) {
                    case 'strtoupper':
                        $arr[ $widx ] = strtoupper( $arr[ $widx ] );
                    break;
                    case 'strtolower':
                        $arr[ $widx ] = strtolower( $arr[ $widx ] );
                    break;
                    default:
                        $status['error'][] = 'è stata specificata una operazione non prevista per questo job';
                    break;
                }

                // CUSTOM salvo il risultato del lavoro
                array2file( $job['workspace']['file'], $arr );

                // CUSTOM status
                $status['info'][] = 'ho lavorato la riga: ' . $arr[ $widx ];

                // aggiorno i valori di visualizzazione avanzamento
                //
                // ULTIMA cosa del ramo: e' la riga che dice "questa iterazione e' andata a buon
                // fine". Anticiparla vuol dire perdere il diritto di rifare l'iterazione.
                $jobs = mysqlQuery(
                    $cf['mysql']['connection'],
                    'UPDATE job SET totale = ?, corrente = ? WHERE id = ?',
                    array(
                    array( 's' => $job['totale'] ),
                    array( 's' => $job['corrente'] ),
                    array( 's' => $job['id'] )
                    )
                );

            }

        }

    }
