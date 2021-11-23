<?php

    function mailGetTemplateByRuolo( $ruolo ) {

        global $cf;

        // recupero dei template dal database
        $tpl = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT * FROM template_mail WHERE ruolo = ?',
            array( array( 's' => $ruolo ) )
        );

        // se individuo il template
        if( ! empty( $tpl ) ) {

                // inizializzo l'oggetto
               $template = array(
                    'type' => $tpl['type'],
                    'nome' => $tpl['nome']
                );

                // prelevo i contenuti
                $cnts = mysqlCachedQuery(
                    $cf['memcache']['connection'],
                    $cf['mysql']['connection'],
                    'SELECT contenuti.*,lingue.ietf FROM contenuti '.
                    'INNER JOIN lingue ON lingue.id = contenuti.id_lingua '.
                    'WHERE contenuti.id_template_mail = ?',
                    array( array( 's' => $tpl['id'] ) )
                );

                // ciclo sui contenuti
                foreach( $cnts as $cnt ) {
                   $template[ $cnt['ietf'] ] = array(
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
                    'WHERE file.id_template_mail = ?',
                    array( array( 's' => $tpl['id'] ) )
                );

                // ciclo sugli allegati
                foreach( $files as $file ) {
                   $template[ $file['ietf'] ]['attach'][ basename( $file['path'] ) ] = DIRECTORY_BASE . $file['path'];
                }

        } else {
             
            $template = $cf['mail']['tpl']['DEFAULT'];

        }

        return $template;

    }