<?php

    /**
     * 
     *  
     * 
     */

    // inizializzo l'array del risultato
	$status = array();

    // lavoro lungo
    set_time_limit( 0 );

    // inclusione del framework
	if( defined( 'CRON_RUNNING' )  || defined( 'JOB_RUNNING' ) ) {

        /**
         * verifiche formali ( questo per gestire il caso di ciclo a vuoto )
         *
         * ATTENZIONE al confronto: si guarda `corrente > totale`, non `corrente >= totale`.
         *
         * "corrente >= totale" vuol dire che l'ultima riga e' stata lavorata, NON che il job sia
         * finito: la chiusura viene dopo. Con `>=` scritto qui, un job la cui chiusura non arriva
         * in fondo finisce in questo ramo a ogni iterazione successiva, dice "gia' completato" e
         * non fa niente: resta fermo a un passo dalla fine per sempre, e non lo sbloccano ne' il
         * browser, ne' il cron, ne' l'azzeramento del token di lock.
         *
         * Con `>` l'iterazione dedicata alla chiusura ( quella in cui corrente diventa totale + 1 )
         * puo' essere rieseguita finche' non riesce, perche' `corrente` viene salvato a database
         * soltanto nel ramo del lavoro. Vedi la sezione "Job in background" di
         * _etc/_claude/_claude.framework.md.
         */
        if( isset( $job['corrente'] ) && $job['corrente'] > $job['totale'] ) {

            // status
            $status['info'][] = 'iterazione a vuoto su job completato';

        } 
        elseif( !isset(  $job['workspace']['mese'] ) || !isset(  $job['workspace']['anno'] ) ){
            $status['err'][] = 'mese o anno non settati';
        }
        else {

            // attività di avvio
            if( empty( $job['corrente'] ) ) {

                // rimuovo le eventuali righe di report già esistenti legate ad altri job
                $del = mysqlQuery(
                    $cf['mysql']['connection'],
                    'DELETE FROM __report_ore_progetti_tipologie_mastri__ WHERE mese = ? AND anno = ?',
                    array(
                        array( 's' => $job['workspace']['mese'] ),
                        array( 's' => $job['workspace']['anno'] )
                    )
                );

                $status['result'] = mysqlSelectColumn(
				    'id',
                    $cf['mysql']['connection'],
                    'SELECT id FROM progetti_produzione_view'
                );
                             
                // creo la lista dei progetti da lavorare
                $job['workspace']['list'] = $status['result'];

                // segno il totale dei progetti da lavorare
                $job['totale'] = count( $job['workspace']['list'] );

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

                // mando un messaggio su Slack
                slackTxtMsg( $cf['slack']['profile']['webhooks']['default'], 'avviata ' . $job['nome'] );

            } else {

                // incremento l'indice di lavoro
                $job['corrente']++;

            }

            /**
             * operazioni di chiusura
             *
             * La chiusura sta in un ramo ALTERNATIVO al lavoro, e non in coda al lavoro: e'
             * un'iterazione tutta sua, quella in cui `corrente` diventa `totale` + 1. Il motivo
             * e' che `corrente` viene salvato a database solo in fondo al ramo del lavoro, quindi
             * se la chiusura non arriva in fondo a database resta l'avanzamento precedente e
             * l'iterazione successiva la ritenta da capo. Chiudere in coda al lavoro, dopo aver
             * gia' salvato l'avanzamento, rende invece il job irrecuperabile.
             *
             * La condizione era `corrente == totale`, che oltre al difetto di cui sopra non
             * chiude piu' niente se per qualunque motivo il contatore scavalca il totale: un
             * uguale non e' una guardia, e' una coincidenza.
             *
             * Il codice che sta qui dentro dev'essere idempotente ( puo' essere eseguito piu'
             * volte ) e breve: il lavoro pesante va spalmato sulle iterazioni, altrimenti la
             * chiusura viene uccisa a meta' ogni volta e il job non finisce mai.
             */
            if( empty( $job['totale'] ) || $job['corrente'] > $job['totale'] ) {

                // scrivo la timestamp di completamento
                $jobs = mysqlQuery(
                    $cf['mysql']['connection'],
                    'UPDATE job SET timestamp_completamento = ? WHERE id = ?',
                    array(
                    array( 's' => time() ),
                    array( 's' => $job['id'] )
                    )
                );
				
                // mando un messaggio su Slack
                slackTxtMsg( $cf['slack']['profile']['webhooks']['default'], 'completata ' . $job['nome'] );

            } else {

                // aggiusto l'indice di lavoro (gli array partono da zero)
                $widx = $job['corrente'] - 1;

                // ricavo l'ID del progetto corrente
                $cid = $job['workspace']['list'][ $widx ];
			
    			// logiche di calcolo e scrittura nel report
                $mese = $job['workspace']['mese'];
                $anno = $job['workspace']['anno'];

                // calcolo le ore di todo peviste
                $ore_previste = mysqlQuery(
                    $cf['mysql']['connection'],
                    'SELECT id_tipologia, id_mastro_attivita_default as id_mastro, sum(ore_previste) as tot_ore FROM todo '
                    .'WHERE month(data_programmazione) = ? AND year(data_programmazione) = ? AND id_progetto = ? '
                    .'GROUP BY id_tipologia, id_mastro_attivita_default',
                    array(
                        array( 's' => $mese ),
                        array( 's' => $anno ),
                        array( 's' => $cid )
                    )
                );

                if( !empty( $ore_previste ) ){
                    foreach( $ore_previste as $op ){
                        $ore[$op['id_tipologia']][$op['id_mastro']]['ore_previste'] = $op['tot_ore'];
                    }
                }
            
                // calcolo le ore di attività fatte
                $ore_fatte = mysqlQuery(
                    $cf['mysql']['connection'],
                    'SELECT id_tipologia, id_mastro_provenienza as id_mastro, sum(ore) as tot_ore FROM attivita AS a '
                    .'LEFT JOIN tipologie_attivita_inps AS t ON a.id_tipologia_inps = t.id '
                    .'WHERE month(a.data_attivita) = ? AND year(a.data_attivita) = ? AND id_progetto = ? AND t.se_quadratura = 1 '
                    .'GROUP BY id_tipologia, id_mastro_provenienza',
                    array(
                        array( 's' => $mese ),
                        array( 's' => $anno ),
                        array( 's' => $cid )
                    )
                );

                if( !empty( $ore_fatte ) ){
                     foreach( $ore_fatte as $of ){
                        $ore[$of['id_tipologia']][$of['id_mastro']]['ore_fatte'] = $of['tot_ore'];
                    }
                }

                if( isset( $ore ) && !empty( $ore ) ){
                    foreach( $ore as $kt => $t ){
                        foreach( $t as $km => $m){
                            $insert = mysqlQuery(
                                $cf['mysql']['connection'],
                                'INSERT INTO __report_ore_progetti_tipologie_mastri__ ( mese, anno, id_job, id_progetto, id_tipologia_attivita, id_mastro, ore_previste, ore_fatte) VALUES ( ?, ?, ?, ?, ?, ?, ?, ? )',
                                array(
                                    array( 's' => $mese ),
                                    array( 's' => $anno ),
                                    array( 's' => $job['id'] ),
                                    array( 's' => $cid ),
                                    array( 's' => $kt ),
                                    array( 's' => $km ),
                                    array( 's' => ( empty( $m['ore_previste'] ) ) ? 0 : str_replace(',', '.', $m['ore_previste'] ) ),
                                    array( 's' => ( empty( $m['ore_fatte'] ) ) ? 0 : str_replace(',', '.', $m['ore_fatte'] ) )
                                )
                            ); 
                        }
                    }
                }
          

                // status
                $status['info'][] = 'ho lavorato la riga: ' . $cid;

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

            }

        }

    } else {

        // status
		$status['error'][] = 'questo job non può essere lanciato fuori dal cron';

        // output
        buildJson( $status );

    }
