<?php

    function scontaCarrello( &$carrello ) {

        global $cf;

        // contatore degli sconti applicati
        $count = 0;

        if( isset( $carrello['articoli']) ){

            // logiche di sconto
        }

        return $count;
    }

/*
    function aggiornaCarrelloEarticoli() {

        global $cf;

        $_SESSION['carrello']['prezzo_netto_totale']        = 0;
        $_SESSION['carrello']['prezzo_lordo_totale']        = 0;
        $_SESSION['carrello']['prezzo_netto_finale']        = 0;
        $_SESSION['carrello']['prezzo_lordo_finale']        = 0;

        // pulisco eventuali sconti applicati
        $_SESSION['carrello']['sconto_percentuale'] = NULL;
        $_SESSION['carrello']['note'] = NULL;

        // ricalcolo i totali aggiornando ogni riga
        foreach( $_SESSION['carrello']['articoli'] as $dati ) {

            mysqlInsertRow(
                $cf['mysql']['connection'],
                array(
                    'id_carrello'               => $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['id_carrello'],
                    'id_articolo'               => $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['id_articolo'],
                    'id_iva'                    => $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['id_iva'],
                    'quantita'                  => $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['quantita'],
                    'prezzo_netto_unitario'     => $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['prezzo_netto_unitario'],
                    'prezzo_lordo_unitario'     => $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['prezzo_lordo_unitario'],
                    'prezzo_netto_totale'       => $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['prezzo_netto_totale'],
                    'prezzo_lordo_totale'       => $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['prezzo_lordo_totale'],
                    'prezzo_netto_finale'       => $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['prezzo_netto_finale'],
                    'prezzo_lordo_finale'       => $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['prezzo_lordo_finale'],
                    'sconto_percentuale'        => ( isset($_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['sconto_percentuale']) ? $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['sconto_percentuale'] : NULL ),
                    'note'                      => ( isset($_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['note']) ? $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['note'] : NULL ),
                ),
                'carrelli_articoli'
            );
            
            // aggiorno i totali
            $_SESSION['carrello']['prezzo_netto_totale'] += $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['prezzo_netto_totale'];
            $_SESSION['carrello']['prezzo_lordo_totale'] += $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['prezzo_lordo_totale'];
            $_SESSION['carrello']['prezzo_netto_finale'] += $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['prezzo_netto_finale'];
            $_SESSION['carrello']['prezzo_lordo_finale'] += $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['prezzo_lordo_finale'];

        }

    }
*/

    function aggiornaFlagCarrelloSeLogin( &$carrello ) {

        global $cf;
    
        $ids = array_keys( $carrello['articoli'] );
        $par = array();

        // die( print_r( $ids ) );
        // die( 'SELECT max( testo ) FROM metadati WHERE nome = "se_login" AND id_articolo IN (' . implode( ',', array_fill( 0, count( $ids ), '?' ) ) . ')' );

        foreach( $ids as $id ) {
            $par[] = array( 's' => $id );
        }

        $carrello['se_login'] = ( empty( $ids ) ) ? NULL : mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT max( testo ) FROM metadati WHERE nome = "se_login" AND id_articolo IN (' . implode( ',', array_fill( 0, count( $ids ), '?' ) ) . ')',
            $par
        );

        // die( $carrello['se_login'] );

    }

    function aggiornaFlagCarrelloSeArrotondamento( &$carrello ) {

        global $cf;
    
        $ids = array_keys( $carrello['articoli'] );
        $par = array();

        // debug
        // die( print_r( $ids, true ) );
        // die( 'SELECT max( testo ) FROM metadati WHERE nome = "arrotonda_prezzo_finale" AND id_articolo IN (' . implode( ',', array_fill( 0, count( $ids ), '?' ) ) . ')' );

        foreach( $ids as $id ) {
            $par[] = array( 's' => $id );
        }

        // debug
        // die( print_r( $par, true ) );

        $carrello['arrotonda_prezzo_finale'] = ( empty( $ids ) ) ? NULL : mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT max( testo ) FROM metadati_articoli WHERE nome = "arrotonda_prezzo_finale" AND id_articolo IN (' . implode( ',', array_fill( 0, count( $ids ), '?' ) ) . ')',
            $par
        );

        // debug
        // die( $carrello['arrotonda_prezzo_finale'] );

    }

    function checkArrotondamento( $articolo) {

        global $cf;

        return mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT max( testo ) FROM metadati_articoli WHERE nome = "arrotonda_prezzo_finale" AND id_articolo = ?',
            array(
                array( 's' => $articolo )
            )
        );

    }

    /**
     * verifica antispam di una richiesta sul carrello
     *
     * Politica: si blocca SOLO quando c'è una prova positiva di bot, cioè quando Google ha
     * risposto e ha bocciato la richiesta. In tutti gli altri casi si passa, perché il carrello
     * viene modificato anche da richieste che non passano da un form protetto ( aggiunta di un
     * articolo, cambio quantità, svuotamento ) e bloccarle interrompe l'acquisto di un utente
     * vero. È la stessa politica fail-open già applicata alla validazione Emailable e a
     * reCaptchaVerifyFormV3(), che passa quando reCAPTCHA non è configurato.
     *
     * La versione precedente restituiva check = false in assenza di token o di chiave: sui
     * carrelli EBHC di produzione questo bocciava la maggioranza degli acquisti reali ( 97
     * ordini pagati su 123 nel 2026 avevano spam_check NULL, cioè erano stati respinti qui ),
     * ed è il motivo per cui il gate a valle era stato neutralizzato con un `if( true )`.
     *
     * @param   array   carrelloRequest     il pacchetto $_REQUEST['__carrello__']
     *
     * @return  array( 'score' => float|NULL, 'check' => bool, 'status' => string )
     */
    function verificaSpam($carrelloRequest) {

        global $cf;

        // gli operatori abilitati a scrivere sui carrelli non sono soggetti al controllo
        if (getAclPermission('carrelli', METHOD_POST)) {
            return ['score' => 1, 'check' => true, 'status' => 'utente autorizzato'];
        }

        $token = $carrelloRequest['__recaptcha_token__'] ?? null;
        $key = $cf['google']['profile']['recaptcha']['keys']['private'] ?? null;

        // reCAPTCHA non configurato su questo sito: non c'è nulla da verificare
        if (empty($key)) {
            return ['score' => NULL, 'check' => true, 'status' => 'reCAPTCHA non configurato'];
        }

        // richiesta senza token: di per sé non è una prova di bot, è una richiesta che non arriva
        // da un form protetto ( vedi sopra ), quindi di default passa e viene solo registrata.
        // Quando lo snippet _inc/_recaptcha.carrello garantisce il token su tutti i form si può
        // alzare l'asticella con $cf['ecommerce']['antispam']['richiedi_token'] = true e allora
        // l'assenza del token diventa motivo di scarto
        if (empty($token)) {

            $richiesto = ! empty($cf['ecommerce']['antispam']['richiedi_token']);

            return [
                'score'  => NULL,
                'check'  => ! $richiesto,
                'status' => $richiesto ? 'token non ricevuto (richiesto)' : 'token non ricevuto'
            ];

        }

        // verifica presso Google
        $esito = NULL;
        $score = reCaptchaVerifyV3($token, $key, $esito);

        switch ($esito) {

            // Google ha risposto con un punteggio: è l'unico caso in cui il punteggio decide
            case 'score':
                return ['score' => $score, 'check' => $score > 0.3, 'status' => 'verificato'];

            // token assente, malformato o contraffatto: prova positiva di manomissione, blocco
            case 'token rifiutato':
                return ['score' => 0, 'check' => false, 'status' => 'token rifiutato'];

            // token scaduto o già consumato ( timeout-or-duplicate ): capita all'utente vero che
            // compila con calma o che ritenta dopo un errore di validazione; non è un bot
            case 'token scaduto':
                return ['score' => NULL, 'check' => true, 'status' => 'token scaduto'];

            // token valido ma chiave non v3, oppure servizio non raggiungibile: non valutabile,
            // non blocco l'utente per un disservizio di un terzo
            default:
                return ['score' => NULL, 'check' => true, 'status' => $esito ?? 'non valutabile'];

        }

    }

    /**
     * verifica di validità di un coupon rispetto al carrello corrente
     *
     * Il controller del carrello applicava il coupon senza verificare nulla ( il gate era un
     * `$couponOk = true` ): un coupon scaduto restava spendibile a tempo indeterminato e un
     * codice inesistente veniva comunque salvato su carrelli.id_coupon.
     *
     * Regole applicate, nell'ordine:
     * -# il codice deve esistere in tabella coupon
     * -# la validità non deve essere ancora iniziata ( timestamp_inizio, NULL = nessun limite )
     * -# la validità non deve essere terminata ( timestamp_fine, NULL = nessun limite )
     * -# se se_multiuso = 0 il coupon è utilizzabile una sola volta *dalla stessa persona*, ma
     *    resta utilizzabile da persone diverse; l'identità è destinatario_mail oppure
     *    destinatario_codice_fiscale
     * -# se se_vincolato = 1 il carrello deve contenere almeno un articolo per ogni gruppo di
     *    alternative censito in coupon_articoli; se non ci sono vincoli censiti il coupon resta
     *    utilizzabile
     *
     * @param   resource    connessione     connessione mysql
     * @param   array       coupon          riga della tabella coupon ( vuota se non esiste )
     * @param   string      codice          codice inserito dall'utente
     * @param   array       carrello        $_SESSION['carrello']
     *
     * @return  array( 'ok' => bool, 'errore' => 'inesistente' | 'non_ancora_valido' | 'scaduto'
     *          | 'gia_usato' | 'articoli_mancanti' | NULL )
     */
    if( ! function_exists( 'verificaValiditaCoupon' ) ) {
        function verificaValiditaCoupon( $connessione, $coupon, $codice, $carrello ) {

            // il codice inserito non corrisponde ad alcun coupon
            if( empty( $coupon ) || empty( $coupon['id'] ) ) {
                return array( 'ok' => false, 'errore' => 'inesistente' );
            }

            // istante di validazione
            $adesso = time();

            // validità non ancora iniziata ( NULL = nessun limite inferiore )
            if( isset( $coupon['timestamp_inizio'] ) && $coupon['timestamp_inizio'] !== NULL && $coupon['timestamp_inizio'] !== ''
                && $adesso < (int) $coupon['timestamp_inizio'] ) {
                return array( 'ok' => false, 'errore' => 'non_ancora_valido' );
            }

            // validità terminata ( NULL = nessun limite superiore )
            if( isset( $coupon['timestamp_fine'] ) && $coupon['timestamp_fine'] !== NULL && $coupon['timestamp_fine'] !== ''
                && $adesso > (int) $coupon['timestamp_fine'] ) {
                return array( 'ok' => false, 'errore' => 'scaduto' );
            }

            // coupon non multiuso: una sola volta per persona
            if( isset( $coupon['se_multiuso'] ) && $coupon['se_multiuso'] == 0 ) {

                $mail = isset( $carrello['destinatario_mail'] ) ? trim( (string) $carrello['destinatario_mail'] ) : '';
                $cfis = isset( $carrello['destinatario_codice_fiscale'] ) ? trim( (string) $carrello['destinatario_codice_fiscale'] ) : '';

                // senza identità l'utilizzo non è attribuibile: non blocco
                if( $mail !== '' || $cfis !== '' ) {

                    // un carrello conta come utilizzo se il pagamento è andato a buon fine oppure
                    // se è un pagamento offline arrivato al checkout: i provider offline non
                    // valorizzano mai status_pagamento
                    $utilizzi = mysqlSelectValue(
                        $connessione,
                        "SELECT COUNT(*) FROM carrelli
                        WHERE id <> ?
                        AND id_coupon = ?
                        AND ( ( ? <> '' AND LOWER( destinatario_mail ) = LOWER( ? ) )
                           OR ( ? <> '' AND destinatario_codice_fiscale = ? ) )
                        AND ( UPPER( status_pagamento ) IN ( 'OK', 'COMPLETED', 'APPROVED' )
                           OR ( provider_pagamento = 'contanti' AND timestamp_checkout IS NOT NULL ) )",
                        array(
                            array( 's' => isset( $carrello['id'] ) ? $carrello['id'] : 0 ),
                            array( 's' => $codice ),
                            array( 's' => $mail ),
                            array( 's' => $mail ),
                            array( 's' => $cfis ),
                            array( 's' => $cfis )
                        )
                    );

                    if( ! empty( $utilizzi ) ) {
                        return array( 'ok' => false, 'errore' => 'gia_usato' );
                    }

                }

            }

            // coupon vincolato ad articoli specifici
            if( isset( $coupon['se_vincolato'] ) && $coupon['se_vincolato'] == 1 ) {

                $vincoli = mysqlQuery(
                    $connessione,
                    'SELECT id_articolo, gruppo_alternative FROM coupon_articoli WHERE id_coupon = ?',
                    array( array( 's' => $codice ) )
                );

                // nessun vincolo censito: il coupon resta utilizzabile
                if( ! empty( $vincoli ) && is_array( $vincoli ) ) {

                    // articoli effettivamente presenti nel carrello
                    $inCarrello = array();
                    if( isset( $carrello['articoli'] ) && is_array( $carrello['articoli'] ) ) {
                        foreach( $carrello['articoli'] as $articolo ) {
                            if( ! empty( $articolo['quantita'] ) ) {
                                $inCarrello[ (string) $articolo['id_articolo'] ] = true;
                            }
                        }
                    }

                    // raggruppo i vincoli per gruppo di alternative
                    $gruppi = array();
                    foreach( $vincoli as $vincolo ) {
                        $gruppi[ (string) $vincolo['gruppo_alternative'] ][] = (string) $vincolo['id_articolo'];
                    }

                    // ogni gruppo deve avere almeno un membro nel carrello
                    foreach( $gruppi as $alternative ) {
                        $soddisfatto = false;
                        foreach( $alternative as $idArticolo ) {
                            if( isset( $inCarrello[ $idArticolo ] ) ) {
                                $soddisfatto = true;
                                break;
                            }
                        }
                        if( ! $soddisfatto ) {
                            return array( 'ok' => false, 'errore' => 'articoli_mancanti' );
                        }
                    }

                }

            }

            // coupon utilizzabile
            return array( 'ok' => true, 'errore' => NULL );

        }
    }

    function checkRigaCarrelloPerFlagNonScontabile( $riga ) {

        global $cf;

        // i tesseramenti non sono mai scontabili
        $idTesseramento = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT tipologie_rinnovi.id FROM tipologie_rinnovi
                LEFT JOIN articoli ON articoli.id_tipologia_rinnovo = tipologie_rinnovi.id
                WHERE articoli.id = ? AND tipologie_rinnovi.se_tesseramenti IS NOT NULL',
            array(
                array( 's' => $riga['id_articolo'] )
            )
        );

        if( ! empty( $idTesseramento ) ) {
            return true;
        }

        return mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT max( testo ) FROM metadati_articoli WHERE nome = "non_applicare_sconti" AND id_articolo = ?',
            array(
                array( 's' => $riga['id_articolo'] )
            )
        );

    }

    function checkRigaCarrelloPerQuadrimestraleCompleto( $riga ) {

        global $cf;

        $rinnovo = trovaDettagliRinnovo($riga['id_rinnovo']);

        if(isset($rinnovo['id_periodicita']) && $rinnovo['id_periodicita'] != 6) {
            return false;
        } else {
            return true;
        }

    }

    function checkScontoApplicatoSuRigaCarrello( $riga ) {

        // print_r( $riga );

        $sconto = $riga['sconto_percentuale'] ?? null;

        return !empty($sconto);

    }
