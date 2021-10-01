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

    function aggiungiImmagini( &$p, $id, $f, $r = null ) {

        aggiungiDati( $p, $id, $f, 'immagini', $r );

    }

    function aggiungiVideo( &$p, $id, $f, $r = null ) {

        aggiungiDati( $p, $id, $f, 'video', $r );

    }

    function aggiungiAudio( &$p, $id, $f, $r = null ) {

        aggiungiDati( $p, $id, $f, 'audio', $r );

    }

    function aggiungiFile( &$p, $id, $f, $r = null ) {

        aggiungiDati( $p, $id, $f, 'file', $r );

    }

    function aggiungiRecensioni( &$p, $id, $f, $r = null ) {

        aggiungiDati( $p, $id, $f, 'recensioni', $r );

    }

    function aggiungiDati( &$p, $id, $f, $t, $r = null ) {

        global $cf;

        switch( $t ) {
            case 'immagini':
                $tc = 'immagini.orientamento, immagini.taglio, immagini.anno, immagini.path_alternativo FROM immagini ';
                $tf = 'id_immagine';
                $tk = 'images';
            break;
            case 'video':
                $tc = 'video.id_tipologia_embed, video.codice_embed FROM video ';
                $tf = 'id_video';
                $tk = 'video';
            break;
            case 'audio':
                // TODO
            break;
            case 'recensioni':
                // TODO
            break;
            case 'file':
                $tc = 'file.url FROM file ';
                $tf = 'id_file';
                $tk = 'files';
            break;
        }

        $cnt = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT contenuti.title, contenuti.h1, contenuti.h2, contenuti.h3, '.
            'contenuti.testo, contenuti.cappello, lingue.ietf, main_lingue.ietf AS main_ietf, '.
            'metadati.nome AS meta_nome, metadati.testo AS meta_testo, meta_lingue.ietf AS meta_ietf, '.
            'ruoli_'.$t.'.nome AS ruolo, '.$t.'.id, '.$t.'.ordine, '.$t.'.nome, '.$t.'.path, '.$tc.
            'LEFT JOIN ruoli_'.$t.' ON ruoli_'.$t.'.id = '.$t.'.id_ruolo '.
            'LEFT JOIN contenuti ON contenuti.'.$tf.' = '.$t.'.id '.
            'LEFT JOIN lingue ON lingue.id = contenuti.id_lingua '.
            'LEFT JOIN lingue AS main_lingue ON main_lingue.id = '.$t.'.id_lingua '.
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
                'path'              => ( empty( $cn['main_ietf'] ) ) ? $cn['path'] : array( $cn['main_ietf'] => $cn['path'] ),
            #    'mimetype'          => findFileType( ( empty( $cn['main_ietf'] ) ) ? $cn['path'] : array( $cn['main_ietf'] => $cn['path'] ) ),     // commentata questa riga, sostituita con la seguente
                'mimetype'          => ( empty( $cn['main_ietf'] ) ) ? findFileType( $cn['path'] ) : array( $cn['main_ietf'] => findFileType( $cn['path'] ) ),      // vedere issue #419
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

            switch( $t ) {
                case 'immagini':
                    $im = array_replace_recursive( $im, array(
                        'taglio'            => $cn['taglio'],
                        'path_alternativo'  => ( empty( $cn['main_ietf'] ) ) ? $cn['path_alternativo'] : array( $cn['main_ietf'] => $cn['path_alternativo'] ),
                    #    'mimetype'          => findFileType( ( empty( $cn['main_ietf'] ) ) ? $cn['path_alternativo'] : array( $cn['main_ietf'] => $cn['path_alternativo'] ) ),     // commentata questa riga, sostituita con la seguente
                        'mimetype'          => ( empty( $cn['main_ietf'] ) ) ? findFileType( $cn['path_alternativo'] ) : array( $cn['main_ietf'] => findFileType( $cn['path_alternativo'] ) ),      // vedere issue #419
                        'orientamento'      => $cn['orientamento'],
                        'anno'              => $cn['anno']
                    ) );
                break;
                case 'video':
                    $im = array_replace_recursive( $im, array(
                        'codice_embed'            => $cn['codice_embed']
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

    function aggiungiMenu(  &$p, $id, $f  ) {

        global $cf;
        
        $mnu = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT menu.*, lingue.ietf FROM menu '.
            'INNER JOIN lingue ON lingue.id = menu.id_lingua '.
            'WHERE ' . $f . ' = ?',
            array(
                array( 's' => $id )
            )
        );
        
        foreach( $mnu as $mn ) {
            $p = array_replace_recursive( $p,
                array(
                    'menu'	=> array( $mn['menu']	=> array(
                        $mn['ancora'] => array(
                            'label'		=> array( $mn['ietf'] => $mn['nome'] ),
                            'subpages'	=> $mn['sottopagine'],
                            'ancora'    => ( isset( $mn['ancora'] ) ) ? $mn['ancora'] : NULL,
                            'target'	=> ( isset( $mn['target'] ) ) ? $mn['target'] : NULL,
                            'priority'	=> $mn['ordine'] )
                        )
                    )
                )
            );
        }

    }

    function aggiungiMacro( &$p, $id, $f ) {

        global $cf;
        
        $p['macro'] = array_merge(
            mysqlSelectColumn(
                'macro',
                $cf['mysql']['connection'],
                'SELECT macro FROM macro '.
                'WHERE ' . $f . ' = ?',
                array(
                    array( 's' => $id )
                )
            ),
            ( ( isset( $p['macro'] ) ) ?  $p['macro'] : array() )
        );

    }

    function aggiungiMetadati( &$p, $id, $f ) {

        global $cf;
        
        $meta = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT metadati.*, lingue.ietf FROM metadati '.
            'LEFT JOIN lingue ON lingue.id = metadati.id_lingua '.
            'WHERE ' . $f . ' = ?',
            array(
                array( 's' => $id )
            )
        );

        foreach( $meta as $mta ) {
            if( empty( $mta['ietf'] ) ) {
                $p['metadati'][ $mta['nome'] ] = $mta['testo'];
            } else {
                $p['metadati'][ $mta['nome'] ][ $mta['ietf'] ] = $mta['testo'];
            }
        }

    }

    function aggiungiGruppi( &$p, $id, $f = 'id_pagina', $t = 'pagine_gruppi' ) {

        // TODO l'assetto dei gruppi cambierà, probabilmente per usare le ACL

        global $cf;

        $groups = mysqlSelectColumn(
            'nome',
            $cf['mysql']['connection'],
            'SELECT gruppi.nome FROM gruppi '.
            'INNER JOIN pagine_gruppi ON gruppi.id = pagine_gruppi.id_gruppo '.
            'WHERE pagine_gruppi.id_pagina = ?',
            array(
                array( 's' => $id )
            )
        );				

        if( ! empty( $groups ) ) {
            $p['auth']['groups']	= $groups;
        }

    }

    function aggiungiContenuti( &$p, $id, $f ) {

        global $cf;

        $cnt = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT contenuti.*, lingue.ietf FROM contenuti '.
            'INNER JOIN lingue ON lingue.id = contenuti.id_lingua '.
            'WHERE ' . $f . ' = ?',
            array(
                array( 's' => $id )
            )
        );

        foreach( $cnt as $cn ) {
            $p = array_replace_recursive( $p,
                array(
                    'short'             => array( $cn['ietf']	=> $cn['path_custom'] ),
                    'forced'	        => array( $cn['ietf']	=> $cn['url_custom'] ),
                    'custom'	        => array( $cn['ietf']	=> $cn['rewrite_custom'] ),
                    'title'	            => array( $cn['ietf']	=> $cn['title'] ),
                    'h1'	            => array( $cn['ietf']	=> $cn['h1'] ),
                    'h2'	            => array( $cn['ietf']	=> $cn['h2'] ),
                    'h3'	            => array( $cn['ietf']	=> $cn['h3'] ),
                    'og_type'	        => array( $cn['ietf']	=> $cn['og_type'] ),
                    'og_title'	        => array( $cn['ietf']	=> $cn['og_title'] ),
                    'og_image'	        => array( $cn['ietf']	=> $cn['og_image'] ),
                    'og_audio'	        => array( $cn['ietf']	=> $cn['og_audio'] ),
                    'og_video'	        => array( $cn['ietf']	=> $cn['og_video'] ),
                    'og_description'	=> array( $cn['ietf']	=> $cn['og_description'] ),
                    'og_determiner'     => array( $cn['ietf']	=> $cn['og_determiner'] )
                )
            );
        }

    }

    function triggerOff( $entita, $task = NULL ){

        global $cf;

        logWrite( 'richiesto spegnimento trigger per ' . $entita . ' da task ' . $task , 'cron' );

    #    logWrite( 'spengo i trigger per ' . $entita, 'cron' );

        $troff = mysqlQuery(
			$cf['mysql']['connection'],
            'SET @TRIGGER_LAZY_' . strtoupper( $entita ) . ' = 1'
		);
    }

    function triggerOn( $entita ){
        
        global $cf;

        logWrite( 'accendo i trigger per ' . $entita, 'cron' );

        $tron = mysqlQuery(
			$cf['mysql']['connection'],
			'SET @TRIGGER_LAZY_' . strtoupper( $entita ) . ' = NULL'
		);
    }
