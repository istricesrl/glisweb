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
     *
     * @todo finire di documentare
     *
     * @file
     *
     */


    if( isset( $cf['contents']['page']['metadati']['id_categoria_progetti'] )
    && ! isset( $cf['contents']['page']['metadati']['id_progetto'] ) ) {

      $rCnt = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT testo, abstract, keywords, description, applicazioni, specifiche FROM contenuti WHERE id_categoria_progetti = ? AND id_lingua = ?',
            array(
                array( 's' => $cf['contents']['page']['metadati']['id_categoria_progetti'] ),
                array( 's' => $cf['localization']['language']['id'] )
            )
            );
            
    $cf['contents']['page']['content'][ $cf['localization']['language']['ietf'] ] = $rCnt['testo'];
    $cf['contents']['page']['keywords'][ $cf['localization']['language']['ietf'] ] = $rCnt['keywords'];
    $cf['contents']['page']['description'][ $cf['localization']['language']['ietf'] ] = $rCnt['description'];
    $cf['contents']['page']['contents']['abstract'][ $cf['localization']['language']['ietf'] ] = $rCnt['abstract'];
    $cf['contents']['page']['contents']['applicazioni'][ $cf['localization']['language']['ietf'] ] = $rCnt['applicazioni'];
    $cf['contents']['page']['contents']['specifiche'][ $cf['localization']['language']['ietf'] ] = $rCnt['specifiche'];


    }
/* aggiungere che se sono in una categoria di prodotto devo caricare i prodotti di quella categoria e informazioni basi degli articoli di quei prodotti */ 