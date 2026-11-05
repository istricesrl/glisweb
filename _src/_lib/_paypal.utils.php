<?php

    /**
     * libreria per la quadratura dei pagamenti PayPal
     *
     * Questa libreria contiene le funzioni che le API _paypal.advanced.order.php e _paypal.advanced.capture.php del modulo
     * _F030.pagamenti usano per tenere allineato quello che PayPal incassa con quello che il gestionale registra. Sta nel core
     * e non nel modulo perché quelle API si raggiungono da /api/F030.pagamenti/ anche dove il modulo non è attivo, e lì le
     * librerie del modulo non vengono caricate; dipende da $cf, quindi è una utils, accanto a _paypal.tools.php.
     *
     * introduzione
     * ============
     * Il "paga insieme" crea un pagamento master e gli appende come figli ( id_genitore ) i pagamenti da saldare. PayPal incassa
     * la cifra fissata quando nasce l'ordine, mentre la cattura registra i figli: fra i due istanti chi paga può metterci tutto
     * il tempo che vuole, e i figli possono cambiare ( importi rifatti, figli spostati su un altro master, buoni applicati
     * dopo, pagamenti chiusi altrove ). Dal 2026-11-05 l'ordine scrive sul master l'importo mandato a PayPal
     * ( importo_pagamento ) e marca i figli con l'ID dell'ordine ( ordine_pagamento ); la cattura, prima di muovere i soldi,
     * verifica che i figli marcati e ancora aperti valgano esattamente quella cifra. Su polmasi fra settembre e il
     * 2026-11-01 nove incassi non tornavano con la registrazione, per 988 EUR ( analisi di polmasi,
     * var/20261105-paypal-differenze/analisi.md, par. 3.1 ).
     *
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * verificaFigliOrdinePaypal()      | confronta l'importo dell'ordine PayPal con i pagamenti che la cattura registrerà
     *
     * licenza
     * =======
     * Questa libreria fa parte del progetto GlisWeb (https://github.com/istricesrl/glisweb) ed è distribuita
     * sotto licenza Open Source. Fare riferimento alla pagina GitHub del progetto per i dettagli.
     *
     */

    /**
     * confronta l'importo dell'ordine PayPal con i pagamenti che la cattura registrerà
     *
     * Questa funzione legge il pagamento $idMaster e i suoi figli. Se il pagamento non ha figli, confronta l'importo mandato a
     * PayPal ( importo_pagamento, scritto dall'API dell'ordine ) con il suo importo_lordo_finale di adesso; se ha figli, lo
     * confronta con la somma dei figli marcati con l'ordine $ordine e non ancora pagati, che sono i soli che la cattura deve
     * registrare. I figli aggiunti dopo l'ordine, spostati altrove o già pagati non entrano nella somma, quindi un cambiamento
     * qualunque fra l'ordine e la cattura si vede come una differenza.
     *
     * Un ordine senza importo_pagamento ( creato prima di questa verifica ) non passa: meglio un pagamento da rifare che soldi
     * incassati e non registrati.
     *
     * @param       int         $idMaster   l'ID del pagamento che ha ricevuto l'ordine PayPal
     * @param       string      $ordine     l'ID dell'ordine PayPal
     *
     * @return      array                   'ok' ( bool ), 'atteso' e 'trovato' ( importi ), 'totali' ( figli del master ) e
     *                                      'figli' ( le righe da registrare, vuoto se il pagamento non ha figli )
     *
     */
    function verificaFigliOrdinePaypal( $idMaster, $ordine ) {

        global $cf;

        $esito = array( 'ok' => false, 'atteso' => null, 'trovato' => 0, 'totali' => 0, 'figli' => array() );

        $master = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT id, importo_lordo_finale, importo_pagamento FROM pagamenti WHERE id = ?',
            array( array( 's' => $idMaster ) )
        );

        if( empty( $master['id'] ) ) {
            return $esito;
        }

        $esito['atteso'] = $master['importo_pagamento'];

        $esito['totali'] = (int) mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT count( id ) FROM pagamenti WHERE id_genitore = ?',
            array( array( 's' => $idMaster ) )
        );

        if( empty( $esito['totali'] ) ) {

            $esito['trovato'] = $master['importo_lordo_finale'];

        } else {

            $figli = mysqlQuery(
                $cf['mysql']['connection'],
                'SELECT * FROM pagamenti WHERE id_genitore = ? AND ordine_pagamento = ? AND timestamp_pagamento IS NULL ORDER BY id',
                array( array( 's' => $idMaster ), array( 's' => $ordine ) )
            );

            $esito['figli'] = ( is_array( $figli ) ) ? $figli : array();

            foreach( $esito['figli'] as $figlio ) {
                $esito['trovato'] += $figlio['importo_lordo_finale'];
            }

            // con dei figli, almeno uno deve essere stato marcato dall'ordine
            if( empty( $esito['figli'] ) ) {
                return $esito;
            }

        }

        $esito['ok'] = ( $esito['atteso'] !== null && round( (float) $esito['atteso'], 2 ) > 0
            && round( (float) $esito['atteso'], 2 ) == round( (float) $esito['trovato'], 2 ) );

        return $esito;

    }
