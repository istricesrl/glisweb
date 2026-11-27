<?php

    /**
     * libreria del modulo listini, aggiunta a _src/_lib/_mysql.utils.php
     *
     * prezzo di listino di un articolo
     * ================================
     * Il prezzo di listino di oggi serve a chi copia o ricalcola righe di documento senza passare dalla
     * scheda: la duplicazione dei documenti ( _mod/_0400.documenti/_src/_api/_task/_documenti.duplica.php,
     * con prezzi=attuali ) e i controller di progetto che agganciano il prezzo alla riga. Sta in questo
     * modulo perche' la tabella prezzi esiste solo dove il modulo e' attivo: chi la usa da fuori controlla
     * prima che il modulo ci sia ( in_array( '4120.listini', $cf['mods']['active']['array'] ) ).
     *
     * @file
     *
     */

    /**
     * cerca a listino il prezzo di un articolo
     *
     * Con il listino indicato si prende il prezzo di quel listino. Senza, si accetta il prezzo solo se
     * per quell'articolo ce n'e' uno solo: sceglierne uno a caso fra piu' listini darebbe documenti
     * diversi a ogni salvataggio.
     *
     * @param $c                la connessione al database
     * @param $idArticolo       l'articolo della riga
     * @param $idListino        il listino della riga, o NULL
     * @return                  prezzo ( arrotondato a due decimali come sulla riga ), id_iva, id_listino e
     *                          aliquota, o NULL se il prezzo non si trova o non e' univoco
     */
    if( ! function_exists( 'prezzoListinoArticolo' ) ) {
        function prezzoListinoArticolo( $c, $idArticolo, $idListino = NULL ) {

            if( empty( $idArticolo ) ) {
                return NULL;
            }

            if( ! empty( $idListino ) ) {

                $riga = mysqlSelectRow(
                    $c,
                    'SELECT prezzi.prezzo, prezzi.id_iva, prezzi.id_listino, iva.aliquota FROM prezzi LEFT JOIN iva ON iva.id = prezzi.id_iva WHERE prezzi.id_articolo = ? AND prezzi.id_listino = ? LIMIT 1',
                    array(
                        array( 's' => $idArticolo ),
                        array( 's' => $idListino )
                    )
                );

            } else {

                $prezzi = mysqlQuery(
                    $c,
                    'SELECT prezzi.prezzo, prezzi.id_iva, prezzi.id_listino, iva.aliquota FROM prezzi LEFT JOIN iva ON iva.id = prezzi.id_iva WHERE prezzi.id_articolo = ?',
                    array( array( 's' => $idArticolo ) )
                );

                $riga = ( count( $prezzi ) == 1 ) ? reset( $prezzi ) : NULL;

                if( count( $prezzi ) > 1 ) {
                    logWrite( 'prezzo non agganciato: l\'articolo ' . $idArticolo . ' e\' presente su ' . count( $prezzi ) . ' listini e la riga non ne indica nessuno', 'controller', LOG_WARNING );
                }

            }

            if( empty( $riga ) ) {
                return NULL;
            }

            // i prezzi sono decimal(16,5) a listino e decimal(16,2) sulla riga: si arrotonda qui invece di
            // lasciarlo fare a MySQL, cosi' il valore usato nei calcoli e' lo stesso che finisce in archivio
            $riga['prezzo'] = round( $riga['prezzo'], 2 );

            return $riga;

        }
    }
