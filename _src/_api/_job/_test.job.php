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

        // CUSTOM verifiche formali
        if( isset( $job['corrente'] ) && $job['corrente'] >= $job['totale'] ) {

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
            $jobs = mysqlQuery(
                $cf['mysql']['connection'],
                'UPDATE job SET totale = ?, corrente = ? WHERE id = ?',
                array(
                array( 's' => $job['totale'] ),
                array( 's' => $job['corrente'] ),
                array( 's' => $job['id'] )
                )
            );

            // operazioni di chiusura
            if( $job['corrente'] >= $job['totale'] ) {

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

            }

        }

    }
