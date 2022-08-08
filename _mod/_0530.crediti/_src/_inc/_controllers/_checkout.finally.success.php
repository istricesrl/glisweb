<?php

    // debug
    // die( print_r( $_SESSION['carrello'] ) );

    // se è presente un ID carrello
    if( isset( $idCarrello ) && ! empty( $idCarrello ) ) {

        // recupero il carrello
        $carrello = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT * FROM carrelli WHERE id = ?',
            array(
                array( 's' => $idCarrello )
            )
        );

        // recupero gli articoli
        $articoli = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT * FROM carrelli_articoli WHERE id_carrello = ?',
            array(
                array( 's' => $idCarrello )
            )
        );

        // cerco gli articoli che aggiungono crediti
        foreach( $articoli as $articolo ) {

            // recupero i crediti
            $crediti = mysqlSelectValue(
                $cf['mysql']['connection'],
                'SELECT testo FROM metadati WHERE id_articolo = ? AND nome = "crediti|incremento"',
                array(
                    array( 's' => $articolo['id_articolo'] )
                )
            );

            // se ci sono dei crediti da accreditare
            if( ! empty( $crediti ) ) {

                // recupero il mastro genitore
                $genitore = mysqlSelectValue(
                    $cf['mysql']['connection'],
                    'SELECT testo FROM metadati WHERE id_articolo = ? AND nome = "crediti|mastro"',
                    array(
                        array( 's' => $articolo['id_articolo'] )
                    )
                );

                // recupero il mastro di destinazione
                $mastro = mysqlSelectValue(
                    $cf['mysql']['connection'],
                    'SELECT id FROM mastri WHERE id_account = ? AND id_genitore = ?',
                    array(
                        array( 's' => $carrello['intestazione_id_account'] ),
                        array( 's' => $genitore )
                    )
                );

                // creo il mastro se non è presente
                if( empty( $mastro ) ) {
                    $mastro = mysqlInsertRow(
                        $cf['mysql']['connection'],
                        array(
                            'id' => NULL,
                            'id_genitore' => $genitore,
                            'id_tipologia' => 4,
                            'id_account' => $carrello['intestazione_id_account'],
                            'nome' => 'conto crediti SAAS per accoun #' . $carrello['intestazione_id_account'],
                            'note' => 'creato automaticamente il ' . date('d/m/Y')
                        ),
                        'mastri'
                    );
                }

                // calcolo il valore da incrementare
                $incremento = $crediti * $articolo['quantita'];

                // debug
                // var_dump( $crediti . 'x' . $articolo['quantita'] . '=' . $incremento );

                // registro il movimento
                $movimento = mysqlInsertRow(
                    $cf['mysql']['connection'],
                    array(
                        'id' => NULL,
                        'id_mastro_destinazione' => $mastro,
                        'id_account_destinatario' => $carrello['intestazione_id_account'],
                        'data' => date('Y-m-d'),
                        'nome' => 'acquisto ' . $crediti . 'x' . $articolo['quantita'] . '=' . $incremento . ' crediti con carrello #' . $idCarrello . ' riga #' . $articolo['id'],
                        'quantita' => $incremento,
                        'timestamp_inserimento' => time()
                    ),
                    'crediti'
                );

            }

        }

    }

    // debug
    // die( '<pre>' . print_r( $_SESSION['carrello'], true ) . '<pre>' );
