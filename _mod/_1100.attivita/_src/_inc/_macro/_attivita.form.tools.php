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
       
        $ct['etc']['mail_cliente'] = mysqlSelectValue(  $cf['mysql']['connection'], 'SELECT indirizzo FROM mail WHERE id_anagrafica = ? AND se_notifiche = 1 ORDER BY timestamp_inserimento DESC LIMIT 1', array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_cliente'] ) ) );
        $ct['etc']['azienda'] = mysqlSelectRow( $cf['mysql']['connection'],'SELECT * FROM anagrafica_view WHERE se_azienda_gestita = 1');
        if( isset( $ct['etc']['azienda']['id'] ) ){
            $ct['etc']['mail_emittente'] =  mysqlSelectValue(  $cf['mysql']['connection'], 'SELECT indirizzo FROM mail WHERE id_anagrafica = ? AND se_notifiche = 1 ORDER BY timestamp_inserimento DESC LIMIT 1', array( array( 's' =>  $ct['etc']['azienda']['id'] ) ) );
        }

        $ct['etc']['cliente'] = mysqlSelectRow( $cf['mysql']['connection'],'SELECT * FROM anagrafica_view WHERE id = ?', array( array( 's' =>  $_REQUEST[ $ct['form']['table'] ]['id_cliente'] ) ) );
                
     /*   $ct['etc']['corpo'] = '<p>Gentile '.$cliente['__label__'].',</p><p>a seguito della sua richiesta di assistenza le proponiamo la seguente soluzione: </p><p>'.$_REQUEST[ $ct['form']['table']  ]['testo'].'.</p><p>Il tempo stimato per l\'intervento e\' di &nbsp;&nbsp;  ore per un costo stimato di €  .00</p><div class=\"d-flex justify-content-center\">'.
        '<div class=\"col-12 d-flex justify-content-center\"><button onclic=\"window.open(\''.$ct['site']['url'].'acconsenti.html?__a__='.$_REQUEST[ $ct['form']['table'] ]['id'].'\',\'_blank\')\" style=\'margin: auto;  width: 50%; border-left: 20px;  padding: 10px;background-color: #1a639a; color: white; border-color: white;\' type=\'button\' class=\'btn btn-success\'>acconsenti a procedere</button></div>'.
        '<div><span style=\"margin: auto;  width: 100%;  border: 0px solid;  padding: 65px; color:#1a639a;\"><span style=\"font-size:10px;\">fai click qui per rifiutare l\'assistenza</span></span></div></div><p>Cordiali saluti,<br>'.$azienda['__label__'].'</p>';
*/
        // invio mail conferma attività
        $ct['page']['contents']['metro']['mail'][] = array(
        //    'modal' => array('id' => 'send', 'include' => 'inc/mail.modal.html', 'onclick' => '$(\'#_destinatario\').val(\''.$mail_cliente.'\' ); $(\'#_oggetto\').val(\'richiesta di conferma a procedere\'); $(\'#_mittente\').val(\''.$mail_emittente.'\'); CKEDITOR.instances[\'_testo\'].setData("'.$corpo.'"); ' ),
            'modal' => array('id' => 'dettaglio', 'include' => 'inc/attivita.form.tools.modal.mail.html' ),
            'icon' => NULL,
            'fa' => 'fa-envelope-o',
            'title' => 'invia richiesta di conferma',
            'text' => 'invia al cliente una mail per avere la conferma a procedere'
        );

    }

    $ct['page']['contents']['metro']['general'][] = array(
		'modal' => array( 'id' => 'send', 'include' => 'inc/mail.modal.html' )
	);

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.tools.php';

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.form.php';
