<?php

    /**
     * TODO prende una riga da mailing_mail con strategia di tokenizzazione e genera la mail relativa pianificata per l'invio in base alla timestamp_invio del mailing
     * 
     * 
     */


            // ...
            $idMailing = 

		    // inizializzo il template
			$tpl = array(
			    'type' => $tpl['tipo'],
			    'nome' => $tpl['nome']
			);

		    // prelevo i contenuti
			$cnts = mysqlCachedQuery(
				$cf['memcache']['connection'],
				$cf['mysql']['connection'],
				'SELECT contenuti.*,lingue.ietf FROM contenuti '.
				'INNER JOIN lingue ON lingue.id = contenuti.id_lingua '.
				'WHERE contenuti.id_mailing = ?',
			    array( array( 's' => $idMailing ) )
			);

		    // ciclo sui contenuti
			foreach( $cnts as $cnt ) {
			    $tpl[ $cnt['ietf'] ] = array(
				'from' => array( $cnt['mittente_nome'] => $cnt['mittente_mail'] ),
# prelevare dall'invio				'to' => array( $cnt['destinatario_nome'] => $cnt['destinatario_mail'] ),
# prelevare dall'invio				'to_cc' => array( $cnt['destinatario_cc_nome'] => $cnt['destinatario_cc_mail'] ),
# prelevare dall'invio				'to_bcc' => array( $cnt['destinatario_ccn_nome'] => $cnt['destinatario_ccn_mail'] ),
				'oggetto' => $cnt['cappello'], // è giusto cappello?
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
			    $tpl[ $file['ietf'] ]['attach'][ basename( $file['path'] ) ] = DIR_BASE . $file['path'];
			}

            // invio la mail
            $invio = queueMailFromTemplate(
                $cf['mysql']['connection'],
                $template,
# prelevare i dati dai metadati del mailing                array( 'dt' => array_replace_recursive( $_REQUEST['__profile__'], array( 'tk' => $tk ) ), 'ct' => $ct ),
# mailing.timestamp_invio                strtotime( '+1 minutes' ),
# destinatario da anagrafica                array( $_REQUEST['__profile__']['nome'] . ' ' . $_REQUEST['__profile__']['cognome'] => $_REQUEST['__profile__']['email'] ),
                $cf['localization']['language']['ietf']
            );

		    // ...
			if( $invio ) {

associare la mail in coda alla riga di mailing_mail


            } else {

            }
