<?php

    function mailGetTemplateByRuolo( $ruolo ) {

        global $cf;

        // recupero dei template dal database
        $tpl = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT * FROM template WHERE ruolo = ?',
            array( array( 's' => $ruolo ) )
        );

        // se ci sono template
        if( ! empty( $tpl ) ) {

                // inizializzo l'oggetto
                $cf['mail']['tpl'][ $tpl['ruolo'] ] = array(
                    'type' => $tpl['type'],
                    'nome' => $tpl['nome']
                );

                // prelevo i contenuti
                $cnts = mysqlCachedQuery(
                    $cf['memcache']['connection'],
                    $cf['mysql']['connection'],
                    'SELECT contenuti.*,lingue.ietf FROM contenuti '.
                    'INNER JOIN lingue ON lingue.id = contenuti.id_lingua '.
                    'WHERE contenuti.id_template = ?',
                    array( array( 's' => $tpl['id'] ) )
                );

                // ciclo sui contenuti
                foreach( $cnts as $cnt ) {
                    $cf['mail']['tpl'][ $tpl['ruolo'] ][ $cnt['ietf'] ] = array(
                    'from' => array( $cnt['mittente_nome'] => $cnt['mittente_mail'] ),
                    'to' => array( $cnt['destinatario_nome'] => $cnt['destinatario_mail'] ),
                    'to_cc' => array( $cnt['destinatario_cc_nome'] => $cnt['destinatario_cc_mail'] ),
                    'to_bcc' => array( $cnt['destinatario_ccn_nome'] => $cnt['destinatario_ccn_mail'] ),
                    'oggetto' => $cnt['cappello'],
                    'testo' => $cnt['testo']
                    );
                }

                // prelevo gli allegati
                $files = mysqlCachedQuery(
                    $cf['memcache']['connection'],
                    $cf['mysql']['connection'],
                    'SELECT file.*,lingue.ietf FROM file '.
                    'INNER JOIN lingue ON lingue.id = file.id_lingua '.
                    'WHERE file.id_template = ?',
                    array( array( 's' => $tpl['id'] ) )
                );

                // ciclo sugli allegati
                foreach( $files as $file ) {
                    $cf['mail']['tpl'][ $tpl['ruolo'] ][ $file['ietf'] ]['attach'][ basename( $file['path'] ) ] = DIRECTORY_BASE . $file['path'];
                }

        } else {

        }

    }