<?php

    /**
     * consensi del form di iscrizione alla newsletter
     *
     * Dichiara il modulo privacy `newsletter`, che il form pubblico mostra con `prv.checkConsensi()`: il consenso
     * INVIO_COMUNICAZIONI_MARKETING è obbligatorio, perché senza non c'è niente da iscrivere, e la controller
     * `_newsletter.php` lo registra sull'indirizzo con mailingRegistraConsenso().
     *
     * Testi e richieste si cambiano per deploy come quelli del modulo `default`: da configurazione ( chiave
     * `privacy.moduli.newsletter`, fusa da `_065.privacy.php` ) o dal database ( tabella `consensi_moduli`, letta
     * da `_180.privacy.php` ).
     *
     * @file
     *
     */

    // modulo di iscrizione alla newsletter
    $cf['privacy']['moduli']['newsletter'] = array(
        'titolo' => array(
            'it-IT' => 'modulo di iscrizione alla newsletter',
            'en-GB' => 'newsletter subscription form'
        ),
        'descrizione' => array(
            'it-IT' => 'Questo modulo può essere utilizzato dagli utenti per iscriversi alla newsletter.',
            'en-GB' => 'This form can be used by users to subscribe to the newsletter.'
        ),
        'consensi' => array(
            'PRIVACY_POLICY' => array(
                'informativa' => array(
                    'it-IT' => 'richiesta di iscrizione alla newsletter',
                    'en-GB' => 'request to subscribe to the newsletter'
                ),
                'label' => array(
                    'it-IT' => 'la privacy e cookie policy del sito',
                    'en-GB' => 'privacy and cookie policy of the site'
                ),
                'action' => 'letto_e_accetto',
                'page' => 'privacy',
                'required' => true
            ),
            'INVIO_COMUNICAZIONI_MARKETING' => array(
                'informativa' => array(
                    'it-IT' => 'invio della newsletter e di comunicazioni commerciali',
                    'en-GB' => 'sending of the newsletter and of commercial communications'
                ),
                'label' => array(
                    'it-IT' => 'l\'invio della newsletter all\'indirizzo indicato',
                    'en-GB' => 'the sending of the newsletter to the given address'
                ),
                'action' => 'letto_e_accetto',
                'page' => 'privacy',
                'required' => true
            )
        )
    );
