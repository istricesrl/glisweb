<?php

    /* CODICE PRINCIPALE DEL JOB */

    // verifiche formali
    if( ! defined( 'CRON_RUNNING' ) && ! defined( 'JOB_RUNNING' ) ) {

        // status
        $job['workspace']['status']['error'][] = 'questo job non supporta la modalità standalone';

        // output
        buildJson( $job['workspace']['status'] );

    } elseif( empty( $job['id'] ) ) {

        // status
        $job['workspace']['status']['error'][] = 'ID job non trovato';

    } elseif( isset( $job['corrente'] ) && $job['corrente'] > $job['totale'] ) {

        // status
        $job['workspace']['status']['info'][] = 'iterazione a vuoto su job completato';

    } else {

        // attività di avvio
        if( empty( $job['corrente'] ) ) {

            // lista
            $arr = $job['workspace']['lista'];

            // segno il totale delle cose da fare
            $job['totale'] = count( $arr );

            // avvio il contatore
            $job['corrente'] = 1;

            // timestamp di avvio
            if( empty( $job['timestamp_apertura'] ) ) {
                mysqlQuery(
                    $cf['mysql']['connection'],
                    'UPDATE job SET totale = ?, timestamp_apertura = ? WHERE id = ?',
                    array(
                        array( 's' => $job['totale'] ),
                        array( 's' => time() ),
                        array( 's' => $job['id'] )
                    )
                );
            }

            // status
            $job['workspace']['status']['info'][] = 'requisiti formali soddisfatti, inizializzo il job';
            $job['workspace']['status']['info'][] = 'righe trovate: ' . $job['totale'];

        } else {

            // leggo la lista
            $arr = $job['workspace']['lista'];

            // incremento l'indice di lavoro
            $job['corrente']++;

        }

        // operazioni di chiusura
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

        } else {

            // aggiusto l'indice di lavoro (gli array partono da zero)
            $widx = $job['corrente'] - 1;

            // prelevo la riga da lavorare
            $job['riga'] = $arr[ $widx ];

            // vecchio corso
            $job['corso'] = mysqlSelectRow(
                $cf['mysql']['connection'],
                'SELECT * FROM progetti WHERE id = ?',
                array( array( 's' => $job['riga'] ) )
            );

            // modifico l'ID
            $job['corso']['id'] = date( 'YmdHis' );

            // applico la regola sul riferimento
            if( ! empty( $job['workspace']['sostituzioni']['riferimento'] ) ) {
                // TODO valutare se il riferimento contiene un'espressione regolare di sostituzione
                $job['corso']['nome'] = $job['workspace']['sostituzioni']['riferimento'];
            }

            // applico la regola sul periodo
            $job['corso']['id_periodo'] = $job['workspace']['sostituzioni']['periodo_destinazione'];

            // ...
            if( empty( $job['workspace']['sostituzioni']['calendario_dal'] ) ) {
                $job['workspace']['sostituzioni']['calendario_dal'] = mysqlSelectValue(
                    $cf['mysql']['connection'],
                    'SELECT data_inizio FROM periodi WHERE id = ?',
                    array( array( 's' => $job['corso']['id_periodo'] ) )
                );
            }

            // ...
            if( empty( $job['workspace']['sostituzioni']['calendario_al'] ) ) {
                $job['workspace']['sostituzioni']['calendario_al'] = mysqlSelectValue(
                    $cf['mysql']['connection'],
                    'SELECT data_fine FROM periodi WHERE id = ?',
                    array( array( 's' => $job['corso']['id_periodo'] ) )
                );
            }

            // applico la regola sulla data di inizio
            $job['corso']['data_accettazione'] = $job['workspace']['sostituzioni']['calendario_dal'];

            // applico la regola sulla data di inizio
            $job['corso']['data_chiusura'] = $job['workspace']['sostituzioni']['calendario_al'];

            // recupero il prodotto
            if( ! empty( $job['corso']['id_prodotto'] ) ) {

                // prelevo i dettagli del prodotto
                $prodotto = mysqlSelectRow(
                    $cf['mysql']['connection'],
                    'SELECT * FROM prodotti WHERE id = ?',
                    array( array( 's' => $job['corso']['id_prodotto'] ) )
                );

                // prelevo gli articoli
                $articoli = mysqlQuery(
                    $cf['mysql']['connection'],
                    'SELECT * FROM articoli WHERE id_prodotto = ?',
                    array( array( 's' => $job['corso']['id_prodotto'] ) )
                );

                // trasformo l'ID
                $prodotto['id'] = $job['corso']['id'];

                // trasformo il nome
                $prodotto['nome'] = $job['corso']['nome'];

                // inserisco il prodotto
                mysqlInsertRow(
                    $cf['mysql']['connection'],
                    $prodotto,
                    'prodotti'
                );

                // elaboro gli articoli
                foreach( $articoli as $articolo ) {

                    // prelevo i prezzi
                    $prezzi = mysqlQuery(
                        $cf['mysql']['connection'],
                        'SELECT * FROM prezzi WHERE id_articolo = ?',
                        array( array( 's' => $articolo['id'] ) )
                    );

                    // prelevo i metadati
                    $metadati = mysqlQuery(
                        $cf['mysql']['connection'],
                        'SELECT * FROM metadati WHERE id_articolo = ?',
                        array( array( 's' => $articolo['id'] ) )
                    );

                    // trasformo l'ID
                    $articolo['id'] = microtime( true );
                    $articolo['id_prodotto'] = $prodotto['id'];

                    // inserisco l'articolo
                    mysqlInsertRow(
                        $cf['mysql']['connection'],
                        $articolo,
                        'articoli'
                    );

                    // ...
                    foreach( $prezzi as $prezzo ) {

                        // trasformo l'ID
                        $prezzo['id'] = NULL;
                        $prezzo['id_articolo'] = $articolo['id'];

                        // applico la regola sul prezzo
                        if( ! empty( $job['workspace']['sostituzioni']['prezzo'] ) ) {
                            $prezzo['prezzo'] = $job['workspace']['sostituzioni']['prezzo'];
                        }

                        // inserisco il prezzo
                        mysqlInsertRow(
                            $cf['mysql']['connection'],
                            $prezzo,
                            'prezzi'
                        );
    
                    }

                    // ...
                    foreach( $metadati as $metadato ) {

                        // trasformo l'ID
                        $metadato['id'] = NULL;
                        $metadato['id_articolo'] = $articolo['id'];

                        // inserisco il metadato
                        mysqlInsertRow(
                            $cf['mysql']['connection'],
                            $metadato,
                            'metadati'
                        );

                    }

                }

                // resetto l'ID prodotto
                $job['corso']['id_prodotto'] = $prodotto['id'];

            }

            // duplico il corso
            mysqlInsertRow(
                $cf['mysql']['connection'],
                $job['corso'],
                'progetti'
            );

            // vecchi metadati
            $job['corso']['metadati'] = mysqlQuery(
                $cf['mysql']['connection'],
                'SELECT * FROM metadati WHERE id_progetto = ?',
                array( array( 's' => $job['riga'] ) )
            );

            // elaboro i metadati
            foreach( $job['corso']['metadati'] as &$metadato ) {

                // azzero l'ID
                $metadato['id'] = NULL;

                // trasformo il riferimento
                $metadato['id_progetto'] = $job['corso']['id'];

                // applico la regola sul numero massimo di iscritti
                if( $metadato['nome'] == 'iscritti_max' && ! empty( $job['workspace']['sostituzioni']['iscritti_max'] ) ) {
                    $metadato['testo'] = $job['workspace']['sostituzioni']['iscritti_max'];
                }

                // inserisco il metadato
                $metadato['id'] = mysqlInsertRow(
                    $cf['mysql']['connection'],
                    $metadato,
                    'metadati'
                );

            }

            // vecchie categorie
            $job['corso']['categorie'] = mysqlQuery(
                $cf['mysql']['connection'],
                'SELECT * FROM progetti_categorie WHERE id_progetto = ?',
                array( array( 's' => $job['riga'] ) )
            );

            // elaboro le categorie
            foreach( $job['corso']['categorie'] as &$categoria ) {

                // azzero l'ID
                $categoria['id'] = NULL;

                // trasformo il riferimento
                $categoria['id_progetto'] = $job['corso']['id'];

                // ...
                $dettagli = mysqlSelectCachedRow(
                    $cf['memcache']['connection'],
                    $cf['mysql']['connection'],
                    'SELECT * FROM categorie_progetti WHERE id = ?',
                    array( array( 's' => $categoria['id_categoria'] ) )
                );

                // applico la regola sulla fascia di età
                if( ! empty( $dettagli['se_fascia'] ) && ! empty( $job['workspace']['sostituzioni']['fascia_eta'] ) ) {
                    $categoria['id_categoria'] = $job['workspace']['sostituzioni']['fascia_eta'];
                }

                $categoria['id'] = mysqlInsertRow(
                    $cf['mysql']['connection'],
                    $categoria,
                    'progetti_categorie'
                );

                $categoria['dettagli'] = $dettagli;

            }

            // metto il nuovo corso in relazione col vecchio
            mysqlInsertRow(
                $cf['mysql']['connection'],
                array(
                    'id_progetto' => $job['corso']['id'],
                    'id_progetto_collegato' => $job['riga'],
                    'id_ruolo' => 1
                ),
                'relazioni_progetti'
            );

            // array delle date di chiusura
            $dateSalt = array();

            // calcolo le chiusure
            $chiusure = mysqlQuery(
                $cf['mysql']['connection'], 
                'SELECT data_inizio, data_fine FROM periodi WHERE id_tipologia IN (1, 2)'
            );

            // calcolo le date di chiusura
            foreach( $chiusure as $c ){
                $range = createDateRangeArray($c['data_inizio'], $c['data_fine']);
                $dateSalt = array_merge( $dateSalt, $range );
            }

            // duplicazione calendario
            $lezioni = mysqlQuery(
                $cf['mysql']['connection'],
                'SELECT * FROM todo WHERE id_progetto = ? AND id_tipologia IN ( 15, 17 ) ORDER BY data_programmazione',
                array( array( 's' => $job['riga'] ) )
            );

            // trovo il giorno della settimana della prima lezione
            $dowPrimaLezione = date( 'l', strtotime( $lezioni[0]['data_programmazione'] ) );

            // salvo il valore della data della lezione nel vecchio corso
            $vecchiaDataLezione = $lezioni[0]['data_programmazione'];

            // trovo il primo giorno di lezione
            $dataPrimaLezione = date( 'Y-m-d', strtotime( $job['corso']['data_accettazione'] . ' next ' . $dowPrimaLezione ) );

            // inizio dalla data della prima lezione
            $dataLezione = $dataPrimaLezione;

            // intervalli
            $intervalli = array();

            // elaboro le lezioni
            foreach( $lezioni as $lezione ) {

                // giorni di differenza fra la data di questa lezione e la data della lezione precedente nel vecchio calendario
                $deltaGiorni = daysBetweenDates( $vecchiaDataLezione, $lezione['data_programmazione'] );

                // registro l'intervallo
                if( $vecchiaDataLezione != $lezioni[0]['data_programmazione'] ) {
                    $intervalli[] = array(
                        'data' => $vecchiaDataLezione,
                        'dow' => date( 'l', strtotime( $vecchiaDataLezione ) ), 
                        'delta' => $deltaGiorni
                    );
                }

                // incremento la data della lezione
                $dataLezione = date( 'Y-m-d', strtotime( '+' . $deltaGiorni . ' days', strtotime( $dataLezione ) ) );

                // aggiorno la vecchia data lezione
                $vecchiaDataLezione = $lezione['data_programmazione'];

                // se sono ancora nel range...
                if( $dataLezione <= $job['corso']['data_chiusura'] ) {

                    // valuto se la lezione è annullata
                    if( in_array( $dataLezione, $dateSalt ) ) {
                        $idTipo = 17;
                    } else {
                        $idTipo = 15;
                    }

                    // inserisco la lezione
                    mysqlInsertRow(
                        $cf['mysql']['connection'],
                        array(
                            'id_progetto' => $job['corso']['id'],
                            'id_tipologia' => $idTipo,
                            'data_programmazione' => $dataLezione,
                            'id_luogo' => $lezione['id_luogo'],
                            'ora_inizio_programmazione' => $lezione['ora_inizio_programmazione'],
                            'ora_fine_programmazione' => $lezione['ora_fine_programmazione'],
                            'id_anagrafica' => NULL
                        ),
                        'todo'
                    );

                }

            }

            // se ci sono da aggiungere delle lezioni...
            while( $dataLezione <= $job['corso']['data_chiusura'] ) {

                // ...
                // TODO cercare di iniiare dal giorno della settimana corrispondente all'intervallo
                $dettagli = current( $intervalli );

                // ...
                if( next( $intervalli ) === false ) {
                    reset( $intervalli );
                }

                // incremento la data della lezione
                $dataLezione = date( 'Y-m-d', strtotime( '+' . $dettagli['delta'] . ' days', strtotime( $dataLezione ) ) );

                // se sono ancora nel range...
                if( $dataLezione <= $job['corso']['data_chiusura'] ) {

                    // valuto se la lezione è annullata
                    if( in_array( $dataLezione, $dateSalt ) ) {
                        $idTipo = 17;
                    } else {
                        $idTipo = 15;
                    }

                    // inserisco la lezione
                    mysqlInsertRow(
                        $cf['mysql']['connection'],
                        array(
                            'id_progetto' => $job['corso']['id'],
                            'id_tipologia' => $idTipo,
                            'data_programmazione' => $dataLezione,
                            'id_luogo' => $lezione['id_luogo'],
                            'ora_inizio_programmazione' => $lezione['ora_inizio_programmazione'],
                            'ora_fine_programmazione' => $lezione['ora_fine_programmazione'],
                            'id_anagrafica' => NULL
                        ),
                        'todo'
                    );

                }

            }

            // scrivo la riga
            updateReportCorsi( $job['corso']['id'] );

            // aggiorno i valori di visualizzazione avanzamento
            $jobs = mysqlQuery(
                $cf['mysql']['connection'],
                'UPDATE job SET corrente = ? WHERE id = ?',
                array(
                    array( 's' => $job['corrente'] ),
                    array( 's' => $job['id'] )
                )
            );

        }

    }

    /* FINE CODICE PRINCIPALE DEL JOB */
