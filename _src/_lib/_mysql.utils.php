<?php

    function trovaIdComune( $c, $p = NULL ) {

        global $cf;

        $comuni = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT * FROM comuni WHERE nome = ?',
            array( array( 's' => $c ) )
        );

        if( ! empty( $comuni[0]['id'] ) ) {
            return $comuni[0]['id'];
        } else {
            return NULL;
        }

    }

    function aggiungiImmagini( &$p, $f, $id, $r = null ) {

        global $cf;

        $cnt = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT contenuti.title, contenuti.h1, contenuti.h2, contenuti.h3, '.
            'contenuti.testo, contenuti.cappello, lingue.ietf, '.
            'ruoli_immagini.nome AS ruolo, immagini.id, immagini.ordine, '.
            'immagini.nome, immagini.orientamento, immagini.path, '.
            'immagini.taglio, immagini.anno FROM immagini '.
            'LEFT JOIN ruoli_immagini ON ruoli_immagini.id = immagini.id_ruolo '.
            'LEFT JOIN contenuti ON contenuti.id_immagine = immagini.id '.
            'LEFT JOIN lingue ON lingue.id = contenuti.id_lingua '.
            'WHERE immagini.' . $f . ' = ? '.
            ( ( $r !== null ) ? 'AND ruoli_immagini.id IN (' . implode( ',', $r ) . ')' : null ),
            array(
                array( 's' => $id )
            )
        );

        foreach( $cnt as $cn ) {

            $im = array(
                'anno'              => $cn['anno'],
                'id'                => $cn['id'],
                'nome'              => $cn['nome'],
                'orientamento'      => $cn['orientamento'],
                'path'              => $cn['path'],
                'taglio'            => $cn['taglio'],
                'mimetype'          => findFileType( $cn['path'] ),
                'title'		        => array( $cn['ietf']	=> $cn['title'] ),
                'h1'		        => array( $cn['ietf']	=> $cn['h1'] ),
                'h2'		        => array( $cn['ietf']	=> $cn['h2'] ),
                'h3'		        => array( $cn['ietf']	=> $cn['h3'] ),
                'testo'		        => array( $cn['ietf']	=> $cn['testo'] ),
                'cappello'		    => array( $cn['ietf']	=> $cn['cappello'] )
            );

            if( isset( $p['contents']['images'][ $cn['ruolo'] ][ $cn['ordine'] ] ) ) {
                $p['contents']['images'][ $cn['ruolo'] ][ $cn['ordine'] ] = array_replace_recursive(
                    $p['contents']['images'][ $cn['ruolo'] ][ $cn['ordine'] ], $im
                );    
            } else {
                $p['contents']['images'][ $cn['ruolo'] ][ $cn['ordine'] ] = $im;
            }
        }

    }
