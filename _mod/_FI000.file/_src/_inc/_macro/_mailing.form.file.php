<?php

    /**
     * allegati del mailing
     *
     * I file allegati al mailing, per lingua; `_genera.mail.php` di `_ML000.mailing` li aggiunge alle mail della
     * lingua corrispondente. Sul modello di `_mail.template.form.file.php`.
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'mailing';

    // sotto tabella gestita
    $ct['form']['subtable'] = 'file';
    
    // tendina ruolo file
	$ct['etc']['select']['ruoli_file'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM ruoli_file_view WHERE se_mail = 1'
	);

    // tendina lingue
    $ct['etc']['select']['lingue'] = $cf['localization']['languages'];

    // debug
    // print_r( $_SESSION['__work__']['documenti']['items'] );
    // print_r( $_REQUEST );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default/_default.form.php';
