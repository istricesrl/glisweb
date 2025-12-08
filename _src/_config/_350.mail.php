<?php

    /**
     * dichiarazione dei template per la posta
     *
     *
     *
     *
     *
     *
     *
     * TODO documentare
     *
     * NOTA per convenzione passare sempre al template mail le seguenti chiavi 'ct' => $ct e 'dt' => <datiDellaMail>
     *
     */

    /**
     * DICHIARAZIONE DEI TEMPLATE MAIL
     * ===============================
     * 
     * 
     * 
     */

    // array del template mail di default
    $cf['mail']['tpl']['DEFAULT'] = array(
        'type' => 'twig',
        'it-IT' => array(
            'from' => array( '{{ ct.site.name[ ct.localization.language.ietf ] }}' => 'noreply@{{ ct.site.fqdn }}' ),
            'oggetto' => 'template di default',
            'testo' => 'template di default'
        )
    );

    // array dei template mail di test
    $cf['mail']['tpl']['MAIL_TEST_TEMPLATE'] = array(
        'type' => 'twig',
        'it-IT' => array(
            'from' => array( 'GlisWeb' => 'noreply@{{ ct.site.fqdn }}' ),
            'oggetto' => 'prova sistema di template per le mail',
            'testo' => '<p>caro {{ destinatario.nome }} {{ destinatario.cognome }},</p><ul>{% for k,v in dt %}<li><b>{{ k }}:</b> {{ v }}</li>{% endfor %}</ul>',
            'attach' => array( 'sitemap' => DIR_ETC . '_current.conf' )
        )
    );

    // array dei template mail
    $cf['mail']['tpl']['DEFAULT_NUOVO_ACCOUNT_ATTIVO'] = array(
        'type' => 'twig',
        'it-IT' => array(
            'from' => array( '{{ ct.site.name[ ct.localization.language.ietf ] }}' => 'noreply@{{ ct.site.fqdn }}' ),
            'oggetto' => 'creazione nuovo account per {{ dt.nome }}',
            'testo' => '<p>Gentile {{ dt.nome }}, il suo account è stato creato e attivato, utilizzi i seguenti dati per effettuare l\'accesso:</p><ul><li><strong>username:</strong> {{ dt.username }}</li><li><strong>password:</strong> {{ dt.password }}</li></ul><p>Buona giornata!</p>'
        )
    );

    // array del template mail per notifica attivazione account
    $cf['mail']['tpl']['DEFAULT_ATTIVAZIONE_ACCOUNT'] = array(
        'type' => 'twig',
        'it-IT' => array(
            'from' => array( '{{ ct.site.name[ ct.localization.language.ietf ] }}' => 'noreply@{{ ct.site.fqdn }}' ),
            'oggetto' => 'Attivazione account',
            'testo' => '<p>Gentile utente, il suo account è stato attivato dagli amministratori. Utilizzi questo link per effettuare il login:<br/>{{ ct.pages.dashboard.url[ ct.localization.language.ietf ] }}?tk={{ dt.tk }}</p>'
        )
    );

    // array del template mail per notifica disattivazione account
    $cf['mail']['tpl']['DEFAULT_DISATTIVAZIONE_ACCOUNT'] = array(
        'type' => 'twig',
        'it-IT' => array(
            'from' => array( '{{ ct.site.name[ ct.localization.language.ietf ] }}' => 'noreply@{{ ct.site.fqdn }}' ),
            'oggetto' => 'Disattivazione account',
            'testo' => '<p>Gentile utente, il suo account è stato disattivato dagli amministratori. Non le sarà più possibile effettuare l\'accesso a <br/>{{ ct.pages.dashboard.url[ ct.localization.language.ietf ] }}</p>'
        )
    );

    // array dei template mail
    $cf['mail']['tpl']['DEFAULT_REIMPOSTAZIONE_PASSWORD'] = array(
        'type' => 'twig',
        'it-IT' => array(
            'from' => array( '{{ ct.site.name[ ct.localization.language.ietf ] }}' => 'noreply@{{ ct.site.fqdn }}' ),
            'oggetto' => 'reimpostazione password',
            'testo' => '<p>Gentile utente, utilizzi questo link per reimpostare la sua password:<br>{{ ct.pages[ dt.pg ].url[ ct.localization.language.ietf ] }}?tk={{ dt.tk }}</p>'
        ),
        'en-GB' => array(
            'from' => array( '{{ ct.site.name[ ct.localization.language.ietf ] }}' => 'noreply@{{ ct.site.fqdn }}' ),
            'oggetto' => 'password reset',
            'testo' => '<p>Dear user, use this link to reset your password:<br>{{ ct.pages[ dt.pg ].url[ ct.localization.language.ietf ] }}?tk={{ dt.tk }}</p>'
        )
    );

    // array dei template mail di test
    $cf['mail']['tpl']['NOTIFICA_NUOVO_ACCOUNT'] = array(
        'type' => 'twig',
        'it-IT' => array(
            'from' => array( 'GlisWeb' => 'noreply@{{ ct.site.fqdn }}' ),
            'oggetto' => 'nuovo account per il sito {{ ct.site.fqdn }}',
            'testo' => '<p>caro {{ dt.nome }} {{ dt.cognome }},</p><p>siamo lieti di informarla che il suo account per accedere al sito è attivo; può effettuare il login utilizzando i seguenti parametri:</p>'.
                '<ul>{% if dt.url %}<li>indirizzo: {{ dt.url }}</li>{% endif %}<li>username: {{ dt.username }}</li><li>password: {{ dt.password }}</li></ul><p>Cordiali saluti.</p>',
//            'attach' => array( 'sitemap' => DIR_ETC . '_current.conf' )
        )
    );

    // array dei template mail di test
    $cf['mail']['tpl']['NOTIFICA_RESET_PASSWORD'] = array(
        'type' => 'twig',
        'it-IT' => array(
            'from' => array( 'GlisWeb' => 'noreply@{{ ct.site.fqdn }}' ),
            'oggetto' => 'password reimpostata per il sito {{ ct.site.fqdn }}',
            'testo' => '<p>caro {{ dt.nome }} {{ dt.cognome }},</p><p>siamo lieti di informarla che è stata reimpostata la password del suo account per accedere al sito; può effettuare il login utilizzando i seguenti parametri:</p>'.
                '<ul>{% if dt.url %}<li>indirizzo: {{ dt.url }}</li>{% endif %}<li>username: {{ dt.username }}</li><li>password: {{ dt.password }}</li></ul><p>Cordiali saluti.</p>',
//            'attach' => array( 'sitemap' => DIR_ETC . '_current.conf' )
        )
    );

    /**
     * PRELIEVO DEI TEMPLATE MAIL DAL DATABASE
     * =======================================
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
        'SELECT * FROM template WHERE se_mail = 1'
    );

    // se ci sono template
    if( is_array( $tpls ) ) {

        // ciclo sui template trovati e li inserisco in $cf['mail']['tpl']
        foreach( $tpls as $tpl ) {

            // inizializzo l'oggetto
            $cf['mail']['tpl'][ $tpl['ruolo'] ] = array(
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
            foreach( $cnts as $cnt ) {
                $cf['mail']['tpl'][ $tpl['ruolo'] ][ $cnt['ietf'] ] = array(
                'from' => array( $cnt['mittente_nome'] => $cnt['mittente_mail'] ), // unserialize( $cnt['mittente_mail'] ),
                'to' => array( $cnt['destinatario_nome'] => $cnt['destinatario_mail'] ), // unserialize( $cnt['destinatario_mail'] ),
                'to_cc' => array( $cnt['destinatario_cc_nome'] => $cnt['destinatario_cc_mail'] ), // unserialize( $cnt['destinatario_cc_mail'] ),
                'to_bcc' => array( $cnt['destinatario_ccn_nome'] => $cnt['destinatario_ccn_mail'] ), // unserialize( $cnt['destinatario_ccn_mail'] ),
                'oggetto' => $cnt['cappello'],
                'testo' => $cnt['testo']
                );
            }

            // prelevo gli allegati
            $files = mysqlCachedQuery(
                $cf['memcache']['connection'],
                $cf['mysql']['connection'],
                'SELECT file.*,lingue.ietf FROM file '.
                'INNER JOIN lingue ON lingue.id = file.id_lingua '.
                'WHERE file.id_template = ?',
                array( array( 's' => $tpl['id'] ) )
            );

            // ciclo sugli allegati
            foreach( $files as $file ) {
                $cf['mail']['tpl'][ $tpl['ruolo'] ][ $file['ietf'] ]['attach'][ basename( $file['path'] ) ] = DIR_BASE . $file['path'];
            }

        }

    }

    // debug
    // print_r( $cf['mail']['tpl'] );
    // print_r( $ct['contatti'] );

    /**
     * TODO questa cosa dei template mail è fatta così per ora perché si suppone che i template non siano mai tanti,
     * e quindi per ora è gestibile anche così; se i template mail gestiti dovessero essere molti bisogna cambiare
     * approccio e considerare di implementare qui lo stesso approccio visto per le pagine, oltre a considerare il fatto
     * che caricandoli qui in pratica lo facciamo per tutte le pagine e non solo per quelle dove effettivamente
     * i template mail sono proprio necessari
     */
