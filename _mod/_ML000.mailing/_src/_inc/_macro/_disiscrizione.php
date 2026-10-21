<?php

    /**
     * disiscrizione dalla newsletter
     *
     * La pagina a cui portano il link in fondo alle mail e l'header `List-Unsubscribe` scritti da
     * `_genera.mail.php`. Riceve l'id dell'indirizzo ( `isc` ) e il token ( `mtk`, l'md5 dell'id seguito
     * dall'indirizzo ) e revoca il consenso con mailingRegistraConsenso().
     *
     * perché due passi
     * ----------------
     * La revoca la fa solo una richiesta POST. Con un GET la pagina chiede conferma con un bottone: i link delle
     * mail vengono aperti anche dai filtri antivirus e antispam dei server di posta aziendali, e se bastasse
     * aprirli per disiscriversi la newsletter perderebbe iscritti che non hanno mai cliccato niente. La POST è
     * anche quella che manda il client di posta per la disiscrizione con un clic ( `List-Unsubscribe-Post:
     * List-Unsubscribe=One-Click`, RFC 8058 ).
     *
     * Il modulo `_7000.mailing` aveva la stessa pagina, ma controllava il token e rispondeva "disiscrizione
     * effettuata con successo" senza modificare niente.
     *
     */

    // stato della pagina
    $ct['etc']['disiscrizione'] = array(
        'stato' => 'errore',
        'mtk' => $_REQUEST['mtk'] ?? NULL,
        'isc' => $_REQUEST['isc'] ?? NULL
    );

    // se sono stati forniti i dati
    if( ! empty( $_REQUEST['mtk'] ) && ! empty( $_REQUEST['isc'] ) ) {

        // indirizzo da disiscrivere
        $row = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT * FROM mail WHERE id = ?',
            array(
                array( 's' => $_REQUEST['isc'] )
            )
        );

        // controllo del token
        if( ! empty( $row ) && hash_equals( md5( $row['id'] . $row['indirizzo'] ), (string) $_REQUEST['mtk'] ) ) {

            // indirizzo
            $ct['etc']['disiscrizione']['indirizzo'] = $row['indirizzo'];

            // la revoca la fa solo la POST
            if( $_SERVER['REQUEST_METHOD'] == 'POST' ) {

                // revoca del consenso
                mailingRegistraConsenso( $row['id'], false, 'disiscrizione dal link della newsletter' );

                // stato
                $ct['etc']['disiscrizione']['stato'] = 'fatto';

                // h1
                $ct['page']['h1']['it-IT'] = 'disiscrizione dalla newsletter';

                // contenuto
                $ct['page']['content']['it-IT'] = 'l\'indirizzo ' . $row['indirizzo'] . ' non riceverà più la newsletter';

            } else {

                // stato
                $ct['etc']['disiscrizione']['stato'] = 'conferma';

                // h1
                $ct['page']['h1']['it-IT'] = 'disiscrizione dalla newsletter';

                // contenuto
                $ct['page']['content']['it-IT'] = 'confermi di non voler più ricevere la newsletter all\'indirizzo ' . $row['indirizzo'] . '?';

            }

        } else {

            // h1
            $ct['page']['h1']['it-IT'] = 'disiscrizione dalla newsletter fallita';

            // contenuto
            $ct['page']['content']['it-IT'] = 'impossibile effettuare la disiscrizione dalla newsletter con i dati forniti, contattare il supporto tecnico per risolvere il problema';

        }

    } else {

        // h1
        $ct['page']['h1']['it-IT'] = 'disiscrizione dalla newsletter impossibile';

        // contenuto
        $ct['page']['content']['it-IT'] = 'dati forniti insufficienti per procedere con la disiscrizione';

    }
