<?php

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../_src/_config.php';
	}

    // ...
    // TODO bisogna proprio specificare il nome dell'API così esplicito? come facciamo negli altri posti?
    if( isset( $_REQUEST['__id__'] ) ) {
        $result = mysqlQuery(
            $cf['mysql']['connection'],
#            'SELECT id, __label__ FROM __report_giacenza_magazzini__ WHERE __label__ LIKE ? AND se_foglia = 1 AND totale > 0',
            'SELECT id_mastro, nome FROM __report_giacenza_magazzini__ WHERE id_articolo = ? AND se_foglia = 1',
            array(
                array( 's' => $_REQUEST['__id__'] )
            )
        );
    }

    // ...
    buildJson(
        $result
    );
