<?php

    /**
     * dichiarazione dei template per gli SMS
     *
     *
     *
     *
     *
     *
     *
     * TODO documentare
     *
     *
     */

    /**
     * DICHIARAZIONE DEI TEMPLATE SMS
     * ==============================
     * 
     * 
     * 
     */

    // array dei template SMS di test
    $cf['sms']['tpl']['SMS_TEST_TEMPLATE'] = array(
        'type' => 'twig',
        'it-IT' => array(
            'from' => array( 'GLISWEB' => '+39 329 00 00 000' ),
            'testo' => 'SMS di test'
        )
    );

    /**
     * PRELIEVO DEI TEMPLATE SMS DAL DATABASE
     * ======================================
     * 
     * 
     * 
     * 
     */

    // recupero dei template dal database
    $tpls = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT * FROM template WHERE se_sms = 1'
    );

    // se ci sono template
    if( is_array( $tpls ) ) {

        // ciclo sui template trovati e li inserisco in $cf['sms']['tpl']
        foreach( $tpls as $tpl ) {

            // inizializzo l'oggetto
            $cf['sms']['tpl'][ $tpl['ruolo'] ] = array(
                'type' => $tpl['tipo'],
                'nome' => $tpl['nome']
            );

            // prelevo i contenuti
            $cnts = mysqlCachedQuery(
                $cf['memcache']['connection'],
                $cf['mysql']['connection'],
                'SELECT contenuti.*,lingue.ietf FROM contenuti '.
                'INNER JOIN lingue ON lingue.id = contenuti.id_lingua '.
                'WHERE contenuti.id_template = ?',
                array( array( 's' => $tpl['id'] ) )
            );

            // ciclo sui contenuti
            // NOTA fino al 2026-09-30 questo ciclo era commentato, e leggeva destinatario_numero invece di destinatari_numero:
            // i testi salvati nella linguetta contenuti dei template SMS non arrivavano a queueSmsFromTemplate(); il tipo del
            // template sta al primo livello, come per le mail in _350.mail.php, e non dentro la lingua
            foreach( $cnts as $cnt ) {
                $cf['sms']['tpl'][ $tpl['ruolo'] ][ $cnt['ietf'] ] = array(
                    'from' => array( $cnt['mittente_nome'] ?? '' => $cnt['mittente_numero'] ?? '' ),
                    'to' => $cnt['destinatari_numero'] ?? '',
                    'testo' => $cnt['testo']
                );
            }

        }

    }

    // debug
    // echo 'OUTPUT';
