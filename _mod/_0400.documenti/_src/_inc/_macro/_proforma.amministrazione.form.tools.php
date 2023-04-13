<?php

    /**
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     * @todo finire di documentare
     *
     * @file
     *
     */

    // tabella della vista
    $ct['form']['table'] = 'documenti';

    // percorsi
    $base = '_mod/_0400.documenti/_src/_api/_task/';

    // NOTA la variabile $base causa problemi nel multi sito fatta in questo modo, per cui ho commentato tutto

    // gruppi di controlli
	$ct['page']['contents']['metros'] = array(
	    'amministrazione' => array(
		'label' => 'operazioni amministrative'
	    )
	);

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

    // macro per l'apertura dei modal
    require DIR_SRC_INC_MACRO . '_default.tools.php';

    // amministrazione documento
    if( empty( $_REQUEST[ $ct['form']['table'] ]['timestamp_chiusura'] ) ){

        // chiusura documento
        $ct['page']['contents']['metro']['amministrazione'][] = array(
            'host' => $ct['site']['url'],
            'ws' => $base . '_chiusura.documento.php?id='.$_REQUEST[ $ct['form']['table'] ]['id'],
            'callback' => 'function(){location.reload();}',
            'icon' => NULL,
            'fa' => 'fa-check-square-o',
            'title' => 'chiudi documento',
            'text' => 'chiudi con data e ora attuale il documento'
        );

        // aggregazione righe
        $ct['page']['contents']['metro']['amministrazione'][] = array(
            'host' => $ct['site']['url'],
            'ws' => $base . '_documenti.aggrega.righe.php?id='.$_REQUEST[ $ct['form']['table'] ]['id'],
            'icon' => NULL,
            'fa' => 'fa-compress',
            'title' => 'aggrega righe',
            'text' => 'aggrega a questo documento tutte le righe non associate'
        );

    } else {

        // documento collegato
        $id_documento = mysqlSelectValue( 
            $cf['mysql']['connection'], 
            'SELECT id_documento_collegato FROM relazioni_documenti '.
            'LEFT JOIN documenti ON documenti.id = relazioni_documenti.id_documento_collegato '.
            'WHERE relazioni_documenti.id_documento = ? AND documenti.id_tipologia = 1',
            array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ) )
        );
        
        if( empty( $id_documento ) ){
            
            $righe = mysqlQuery( 
                $cf['mysql']['connection'], 
                'SELECT DISTINCT righe.id_documento FROM relazioni_documenti_articoli INNER JOIN documenti_articoli ON documenti_articoli.id = relazioni_documenti_articoli.id_documenti_articolo AND documenti_articoli.id_documento = ? LEFT join documenti_articoli AS righe  on righe.id = relazioni_documenti_articoli.id_documenti_articolo_collegato AND righe.id_documento IS NOT NULL',
                array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ) )
            );

            if( count( $righe ) == 1 ){
                
                $id_documento = $righe[0]['id_documento'];
            }
        }

        if( ! empty( $id_documento ) ){
        
            // TODO basarsi sui flag e non sull'id_tipologia
            $ct['page']['contents']['metro']['amministrazione'][] = array(
                'url' => $cf['contents']['pages']['fatture.amministrazione.form']['url'][ $cf['localization']['language']['ietf'] ].'?documenti[id]='.$id_documento.'&__backurl__='.$ct['page']['backurl'][ LINGUA_CORRENTE ],
                'icon' => NULL,
                'fa' => 'fa-external-link',
                'title' => 'apri la fattura #'.$id_documento,
                'text' => 'apri la fattura corrispondente a questa proforma'
            );

        } else {

            // TODO basarsi sui flag e non sull'id_tipologia
            $ct['page']['contents']['metro']['amministrazione'][] = array(
                'host' => $ct['site']['url'],
                'ws' => $base . '_fattura.da.proforma.php?id='.$_REQUEST[ $ct['form']['table'] ]['id'],
                'callback' => 'function(){location.reload();}',
                'icon' => NULL,
                'fa' => 'fa-eur',
                'title' => 'crea fattura',
                'text' => 'crea la fattura corrispondente a questa proforma'
            );
        }

    }
