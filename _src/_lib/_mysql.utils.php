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

        aggiungiDati( $p, $f, $id, 'immagini', $r );

    }

    function aggiungiVideo( &$p, $f, $id, $r = null ) {

        aggiungiDati( $p, $f, $id, 'video', $r );

    }

    function aggiungiFile( &$p, $f, $id, $r = null ) {

        aggiungiDati( $p, $f, $id, 'file', $r );

    }

    function aggiungiDati( &$p, $f, $id, $t, $r = null ) {

        global $cf;

        switch( $t ) {
            case 'immagini':
                $tc = 'immagini.orientamento, immagini.taglio, immagini.anno FROM immagini ';
                $tf = 'id_immagine';
                $tk = 'images';
            break;
            case 'video':
                $tc = 'video.id_tipologia_embed, video.codice_embed FROM video ';
                $tf = 'id_video';
                $tk = 'video';
            break;
            case 'file':
                $tc = 'file.url, main_lingue.ietf AS main_ietf FROM file LEFT JOIN lingue AS main_lingue ON main_lingue.id = file.id_lingua ';
                $tf = 'id_file';
                $tk = 'files';
            break;
        }

        $cnt = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT contenuti.title, contenuti.h1, contenuti.h2, contenuti.h3, '.
            'contenuti.testo, contenuti.cappello, lingue.ietf, '.
            'metadati.nome AS meta_nome, metadati.testo AS meta_testo, meta_lingue.ietf AS meta_ietf, '.
            'ruoli_'.$t.'.nome AS ruolo, '.$t.'.id, '.$t.'.ordine, '.$t.'.nome, '.$t.'.path, '.$tc.
            'LEFT JOIN ruoli_'.$t.' ON ruoli_'.$t.'.id = '.$t.'.id_ruolo '.
            'LEFT JOIN contenuti ON contenuti.'.$tf.' = '.$t.'.id '.
            'LEFT JOIN lingue ON lingue.id = contenuti.id_lingua '.
            'LEFT JOIN metadati ON metadati.'.$tf.' = '.$t.'.id '.
            'LEFT JOIN lingue AS meta_lingue ON meta_lingue.id = metadati.id_lingua '.
            'WHERE '.$t.'.' . $f . ' = ? '.
            ( ( $r !== null ) ? 'AND ruoli_'.$t.'.id IN (' . implode( ',', $r ) . ')' : null ),
            array(
                array( 's' => $id )
            )
        );

        foreach( $cnt as $cn ) {

            $im = array(
                'id'                => $cn['id'],
                'nome'              => $cn['nome'],
                'path'              => $cn['path'],
                'mimetype'          => findFileType( $cn['path'] ),
                'title'		        => array( $cn['ietf']	=> $cn['title'] ),
                'h1'		        => array( $cn['ietf']	=> $cn['h1'] ),
                'h2'		        => array( $cn['ietf']	=> $cn['h2'] ),
                'h3'		        => array( $cn['ietf']	=> $cn['h3'] ),
                'testo'		        => array( $cn['ietf']	=> $cn['testo'] ),
                'cappello'		    => array( $cn['ietf']	=> $cn['cappello'] ),
                'metadati'          => (
                    ( empty( $cn['meta_ietf'] ) ) ?
                    array( $cn['meta_nome'] => $cn['meta_testo'] ) :
                    array( $cn['meta_nome'] => array( $cn['meta_ietf'] => $cn['meta_testo'] ) )
                )
            );

            if( ! empty( $cn['main_ietf'] ) ) {
                $im = array( $cn['main_ietf'] => $im );
            }

            switch( $t ) {
                case 'immagini':
                    $im = array_replace_recursive( $im, array(
                        'taglio'            => $cn['taglio'],
                        'orientamento'      => $cn['orientamento'],
                        'anno'              => $cn['anno']
                    ) );
                break;
            }
            
            if( isset( $p['contents'][ $tk ][ $cn['ruolo'] ][ $cn['ordine'] ] ) ) {
                $p['contents'][ $tk ][ $cn['ruolo'] ][ $cn['ordine'] ] = array_replace_recursive(
                    $p['contents'][ $tk ][ $cn['ruolo'] ][ $cn['ordine'] ], $im
                );    
            } else {
                $p['contents'][ $tk ][ $cn['ruolo'] ][ $cn['ordine'] ] = $im;
            }
        }

    }
