<?php

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../_src/_config.php';
	}

    // ...
    // TODO bisogna proprio specificare il nome dell'API così esplicito? come facciamo negli altri posti?
    if( isset( $_REQUEST['__info__']['0500.mastri/magazzini.giacenza.attivi']['__search__'] ) ) {
        $result = mysqlQuery(
            $cf['mysql']['connection'],
#            'SELECT id, __label__ FROM __report_giacenza_magazzini__ WHERE __label__ LIKE ? AND se_foglia = 1 AND totale > 0',
            'SELECT id, __label__ FROM __report_giacenza_magazzini__ WHERE __label__ LIKE ? AND totale_proprio > 0',
            array(
                array( 's' => '%' . $_REQUEST['__info__']['0500.mastri/magazzini.giacenza.attivi']['__search__'] . '%' )
            )
        );
    } else {
        $result = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT id, totale FROM __report_giacenza_magazzini__ WHERE id = ? AND se_foglia = 1 AND totale > 0',
            array(
                array( 's' => $_REQUEST['__id__'] )
            )
        );
    }

    // ...
    buildJson(
        $result
    );
