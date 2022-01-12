<?php

    /**
     *
     *
     *
     *
     * @file
     *
     */

    // tabella gestita
	$ct['form']['table'] = 'mail_sent';

    if( !empty( $_REQUEST[$ct['form']['table']]['id'] ) ){
        $_REQUEST['mail_sent']['mittente'] = implode(',', unserialize( $_REQUEST[$ct['form']['table']]['mittente']));
        $_REQUEST['mail_sent']['destinatari'] = implode(',', unserialize($_REQUEST[$ct['form']['table']]['destinatari']));
        $_REQUEST['mail_sent']['destinatari_cc'] = implode(',', unserialize($_REQUEST[$ct['form']['table']]['destinatari_cc']));
        $_REQUEST['mail_sent']['destinatari_bcc'] = implode(',', unserialize($_REQUEST[$ct['form']['table']]['destinatari_bcc']));
    }

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
