<?php

    /**
     * macro anagrafica form privacy
     *
     * La linguetta privacy della scheda anagrafica: i consensi della persona, una riga di `anagrafica_consensi` per
     * consenso, che qui si prestano e si revocano. Sotto, in sola lettura, i consensi registrati sui singoli
     * indirizzi mail della persona ( `anagrafica_consensi.id_mail` ), che scrivono p.es. il form di iscrizione alla
     * newsletter e il link di disiscrizione di `_ML000.mailing`.
     *
     * Una revoca si salva come NULL e non come zero, perché il salvataggio passa da empty2null(): qui il NULL si
     * riporta a zero, perché la tendina mostri "revocato" e non un campo vuoto.
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'anagrafica';

    // tendina consensi
    $ct['etc']['select']['consensi'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM consensi_view'
    );

    // tendina stato del consenso
    $ct['etc']['select']['se_prestato'] = tendinaSePrestato();

    // macro di default per l'entità anagrafica
    require DIR_MOD . '_AN000.anagrafica/_src/_inc/_macro/_anagrafica.form.default.php';

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';

    // una revoca salvata come NULL si mostra come revoca
    if( isset( $_REQUEST[ $ct['form']['table'] ]['anagrafica_consensi'] ) && is_array( $_REQUEST[ $ct['form']['table'] ]['anagrafica_consensi'] ) ) {
        foreach( $_REQUEST[ $ct['form']['table'] ]['anagrafica_consensi'] as &$consenso ) {
            if( is_array( $consenso ) && ! empty( $consenso['id'] ) && empty( $consenso['se_prestato'] ) ) {
                $consenso['se_prestato'] = 0;
            }
        }
        unset( $consenso );
    }

    // consensi registrati sui singoli indirizzi della persona
    if( ! empty( $_REQUEST[ $ct['form']['table'] ]['id'] ) ) {
        $ct['etc']['consensi_indirizzi'] = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT mail.indirizzo, consensi.nome AS consenso, anagrafica_consensi.se_prestato, anagrafica_consensi.note, '.
            'from_unixtime( coalesce( anagrafica_consensi.timestamp_consenso, anagrafica_consensi.timestamp_inserimento ), \'%d/%m/%Y %H:%i\' ) AS data_consenso '.
            'FROM anagrafica_consensi '.
            'INNER JOIN mail ON mail.id = anagrafica_consensi.id_mail '.
            'INNER JOIN consensi ON consensi.id = anagrafica_consensi.id_consenso '.
            'WHERE mail.indirizzo IN ( SELECT indirizzo FROM mail WHERE id_anagrafica = ? ) '.
            'ORDER BY mail.indirizzo, consensi.nome',
            array(
                array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] )
            )
        );
    }
