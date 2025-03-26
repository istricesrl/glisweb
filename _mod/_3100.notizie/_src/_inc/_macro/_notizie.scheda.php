<?php

		    // ...
		    $ct['page']['contents']['categorie'] = mysqlQuery(
				$cf['mysql']['connection'],
				'SELECT categorie_notizie.id, contenuti.h1
				FROM notizie_categorie
				INNER JOIN categorie_notizie ON categorie_notizie.id = notizie_categorie.id_categoria
				INNER JOIN contenuti ON contenuti.id_categoria_notizie = categorie_notizie.id AND contenuti.id_lingua = ?
				WHERE notizie_categorie.id_notizia = ?',
				array(
					array( 's' => $cf['localization']['language']['id'] ),							
					array( 's' => $ct['page']['metadati']['id_notizia'] ) )
		    );

			// ...
			$ct['page']['contents']['persone'] = mysqlQuery(
				$cf['mysql']['connection'],
				'SELECT anagrafica.id, anagrafica.nome, anagrafica.cognome, ruoli_anagrafica.id, ruoli_anagrafica.nome AS ruolo
				FROM notizie_anagrafica
				INNER JOIN anagrafica ON anagrafica.id = notizie_anagrafica.id_anagrafica
				INNER JOIN ruoli_anagrafica ON ruoli_anagrafica.id = notizie_anagrafica.id_ruolo
				WHERE notizie_anagrafica.id_notizia = ?',
                array(
					array( 's' => $ct['page']['metadati']['id_notizia'] )
            )
                );
