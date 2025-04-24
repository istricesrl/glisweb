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
	$base = '/_mod/_0400.documenti/_src/_api/_task/';
	$print = '/_mod/_0400.documenti/_src/_api/_print/';

    // gruppi di controlli
	$ct['page']['contents']['metros'] = array(
	    'logistica' => array(
		    'label' => 'operazioni logistiche'
	    )
	);

    if( empty( $_REQUEST[ $ct['form']['table'] ]['timestamp_chiusura'] ) ) {

        // chiusura documento
        $ct['page']['contents']['metro']['logistica'][] = array(
            'host' => $ct['site']['url'],
            'callback' => 'function(){window.open(\''.$ct['page']['path'][ LINGUA_CORRENTE ].'?'.$ct['form']['table'].'[id]='.$_REQUEST[ $ct['form']['table'] ]['id'].'\',\'_self\');}',
            'ws' => $base . '_chiusura.documento.php?id='.$_REQUEST[ $ct['form']['table'] ]['id'],
            'icon' => NULL,
            'fa' => 'fa-check-square-o',
            'title' => 'chiudi documento',
            'text' => 'chiudi con data e ora attuale il documento'
        );

    } else {

        // documento collegato
        $id_documento = mysqlSelectValue( 
            $cf['mysql']['connection'], 
            'SELECT id_documento_collegato FROM relazioni_documenti 
            LEFT JOIN documenti ON documenti.id = relazioni_documenti.id_documento_collegato 
            WHERE relazioni_documenti.id_documento = ? AND documenti.id_tipologia = 4',
            array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ) )
        );

        /* a cosa serve questo?
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
        */

        if( ! empty( $id_documento ) ){
        
            // TODO basarsi sui flag e non sull'id_tipologia
            $ct['page']['contents']['metro']['logistica'][] = array(
                'url' => $cf['contents']['pages']['ddt.magazzini.form']['url'][ $cf['localization']['language']['ietf'] ].'?documenti[id]='.$id_documento.'&__backurl__='.$ct['page']['backurl'][ LINGUA_CORRENTE ],
                'icon' => NULL,
                'fa' => 'fa-external-link',
                'title' => 'apri il DDT #'.$id_documento,
                'text' => 'apri il DDT di evasione per questo ordine'
            );

        } else {

            // TODO basarsi sui flag e non sull'id_tipologia
            $ct['page']['contents']['metro']['logistica'][] = array(
                'host' => $ct['site']['url'],
                'ws' => $base . '_ddt.da.ordine.php?id='.$_REQUEST[ $ct['form']['table'] ]['id'],
                'callback' => 'function(){location.reload();}',
                'icon' => NULL,
                'fa' => 'fa-clipboard',
                'title' => 'crea DDT',
                'text' => 'crea il DDT per l\'evasione di questo ordine'
            );
        }

    }


/*
    // TODO dare l'opzione solo se c'è l'XML da scaricare
    if( true ) {

        $ct['page']['contents']['metro']['logistica'][] = array(
            'url' => $print . '',
            'icon' => NULL,
            'fa' => 'fa-clipboard',
            'title' => 'evadi ordine',
            'text' => 'crea un DDT per l\'evasione dell\'ordine'
        );

    }
*/

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.tools.php';
