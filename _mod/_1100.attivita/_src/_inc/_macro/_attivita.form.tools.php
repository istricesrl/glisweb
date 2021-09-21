<?php

    /**
     * macro form anagrafica
     *
     *
     *
     * -# definizione della tabella del modulo
     * -# popolazione delle tendine
     *
     *
     *
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // tabella gestita
	$ct['form']['table'] = 'attivita';

    // gruppi di controlli
	$ct['page']['contents']['metros'] = array(
        'mail' => array(
            'label' => 'mail'
        )
	);

    if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) && ! empty( $_REQUEST[ $ct['form']['table'] ]['id_cliente'] )  ){
       
        $mail_cliente = mysqlSelectValue(  $cf['mysql']['connection'], 'SELECT indirizzo FROM mail WHERE id_anagrafica = ? AND se_notifiche = 1 ORDER BY timestamp_inserimento DESC LIMIT 1', array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_cliente'] ) ) );
        $azienda = mysqlSelectRow( $cf['mysql']['connection'],'SELECT * FROM anagrafica_view WHERE se_azienda_gestita = 1');
        if( isset( $azienda['id'] ) ){
            $mail_emittente =  mysqlSelectValue(  $cf['mysql']['connection'], 'SELECT indirizzo FROM mail WHERE id_anagrafica = ? AND se_notifiche = 1 ORDER BY timestamp_inserimento DESC LIMIT 1', array( array( 's' => $azienda['id'] ) ) );
        }

        $cliente = mysqlSelectRow( $cf['mysql']['connection'],'SELECT * FROM anagrafica_view WHERE id = ?', array( array( 's' =>  $_REQUEST[ $ct['form']['table'] ]['id_cliente'] ) ) );
                
        $corpo = '<p>Gentile '.$cliente['__label__'].'</p><p>a seguito della sua richiesta di assistenza le proponiamo la seguente soluzione: </p><p>'.$_REQUEST[ $ct['form']['table']  ]['testo'].'.</p><p>Il tempo stimato per l\'intervento e\' di   ore per un costo stimato di €  .00</p><button type=\"button\">acconsenti a procedere</button><p>Cordiali saluti,<br>'.$azienda['__label__'].'</p>';

        // invio mail conferma attività
        $ct['page']['contents']['metro']['mail'][] = array(
            'modal' => array('id' => 'send', 'include' => 'inc/mail.modal.html', 'onclick' => '$(\'#_destinatario\').val(\''.$mail_cliente.'\' ); $(\'#_oggetto\').val(\'richiesta di conferma a procedere\'); $(\'#_mittente\').val(\''.$mail_emittente.'\'); CKEDITOR.instances[\'_testo\'].setData("'.$corpo.'"); ' ),
            'icon' => NULL,
            'fa' => 'fa-envelope-o',
            'title' => 'invia richiesta di conferma',
            'text' => 'invia al cliente una mail per avere la conferma a procedere'
        );

    }


    // gestione default
	require DIR_SRC_INC_MACRO . '_default.tools.php';

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.form.php';
