<?php

    // NOTA
    // la logica è la seguente, al corso (progetto) è associato un prodotto, gli articoli rappresentano le varie modalità e periodi di iscrizione al corso stesso; l'anagrafica iscritta
    // la ricavo da destinatario_id_anagrafica e i dettagli dell'iscrizione dai metadati dell'articolo

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
            'SELECT carrelli_articoli.*, concat( prodotti.nome, " ", articoli.nome ) AS descrizione '.
            'FROM carrelli_articoli '.
            'LEFT JOIN articoli ON articoli.id = carrelli_articoli.id_articolo '.
            'LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto '.
            'WHERE id_carrello = ? ',
            array(
                array( 's' => $idCarrello )
            )
        );

        // debug
        // print_r( $carrello );
        // print_r( $articoli );

        // aggiungo gli articoli al carrello
        $carrello['articoli'] = $articoli;

        // debug
        // die( '<pre>' . print_r( $_SESSION['carrello'], true ) . '<pre>' );
        // die( '<pre>' . print_r( $carrello, true ) . '<pre>' );

        // conversione GA4
        ga4purchase(
            $cf['google']['profile']['analytics']['ua'],
            $cf['google']['profile']['analytics']['mp']['secret'],
            $carrello
        );
    
        // TODO conversione Facebook
        // ...

        // dati da inviare via mail
        $carrelloMail = carrello2mail( $carrello );

        // debug
        // die( '<pre>' . print_r( $carrelloMail, true ) . '<pre>' );

        // invio della mail di notifica interna
        if( ! empty( $cf['mail']['tpl']['DEFAULT_NOTIFICA_INTERNA_ACQUISTO']['it-IT']['from'] ) ) {

            if( ! empty( $cf['mail']['tpl']['DEFAULT_NOTIFICA_INTERNA_ACQUISTO']['it-IT']['from'] ) ) {

                $idMailInterna = queueMailFromTemplate(
                    $cf['mysql']['connection'],
                    $cf['mail']['tpl']['DEFAULT_NOTIFICA_INTERNA_ACQUISTO'],
                    array(
                        'dt' => $carrelloMail,
                        'ct' => $ct,
                        '__exclude__' => array(
                            'intestazione_id_tipologia_anagrafica',
                            'fatturazione_id_tipologia_documento',
                            'fatturazione_sezionale',
                            'fatturazione_strategia',
                            'provider_checkout',
                            'timestamp_evasione',
                            'id_account_evasione',
                            'note_evasione',
                            'spam_score',
                            'spam_check',
                            'timestamp_aggiornamento'
                        )
                    ),
                    strtotime( '-1 minute' ),
                    $cf['mail']['tpl']['DEFAULT_NOTIFICA_INTERNA_ACQUISTO']['it-IT']['to'],
                    'it-IT'
                );

            }

        }

        // ...
        $linguaMail = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT lingue.ietf FROM lingue
            INNER JOIN stati_lingue ON stati_lingue.id_lingua = lingue.id
            WHERE stati_lingue.id_stato = ?',
            array(
                array( 's' => $carrello['intestazione_id_stato'] )
            )
        );

        // ...
        if( empty( $linguaMail ) ) {
            $linguaMail = 'en-GB';
        }

        // ...
        if( ! in_array( $linguaMail, array_keys( $cf['site']['name'] ) ) ) {
            $linguaMail = 'it-IT';
        }

        // invio della mail di notifica esterna
        if( ! empty( $cf['mail']['tpl']['DEFAULT_NOTIFICA_ESTERNA_ACQUISTO'][ $linguaMail ]['from'] ) ) {

            $idMailEsterna = queueMailFromTemplate(
                $cf['mysql']['connection'],
                $cf['mail']['tpl']['DEFAULT_NOTIFICA_ESTERNA_ACQUISTO'],
                array(
                    'dt' => $carrelloMail,
                    'ct' => $ct
                ),
                strtotime( '-1 minute' ),
                array(
                    implode( ' ', $carrello['intestazione_nome'], $carrello['intestazione_cognome'], $carrello['intestazione_denominazione'] ) => $carrello['intestazione_mail']
                ),
                $linguaMail
            );

        }

        // debug
        // die( '<pre>' . print_r( $carrelloMail, true ) . '<pre>' );

    } else {

        // debug
        // die('nessun carrello trovato!');

    }
