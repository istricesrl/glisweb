<?php

    /**
     *
     *
     *
     *
     * @file
     *
     */

	 // gruppi di controlli
	 $ct['page']['contents']['metros'] = array(
		 'general' => array(
		 'label' => 'stampe generali'
		 )
	 );
 
	 $ct['page']['contents']['metro']['general'][] = array(
	    'modal' => array( 'id' => 'report_commerciale', 'include' => 'inc/commerciale.stampe.modal.report.html' ),
		 'target' => '_blank' ,
//		 'url' => '/print/2000.commerciale/report.gestione.commerciale.pdf',
		 'icon' => NULL,
		 'fa' => 'fa-file-pdf-o',
		 'title' => 'rapporto gestione commerciale',
		 'text' => 'stampa un rapporto sulla gestione di clienti e contatti'
		 );
 
     // categorie anagrafica
     $ct['etc']['select']['categorie_anagrafica'] = mysqlCachedQuery(
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM categorie_anagrafica_view'
	);
	 
	 // macro di default
	 require DIR_SRC_INC_MACRO . '_default.tools.php';
 