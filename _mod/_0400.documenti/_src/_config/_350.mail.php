<?php

    /**
     * dichiarazione dei template per la posta
     *
     *
     *
     *
     *
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // NOTA per convenzione passare sempre al template mail le seguenti chiavi 'ct' => $ct e 'dt' => <datiDellaMail>

    // array del template mail di default
	$cf['mail']['tpl']['INVIO_DOC_MAIL'] = array(
	    'type' => 'twig',
	    'it-IT' => array(
			'from' => array( '{{ ct.site.name[ ct.localization.language.ietf ] }}' => 'noreply@{{ ct.site.fqdn }}' ),
			'oggetto' => 'invio documento',
			'testo' => '<p>spett. {{ dt.documento.destinatario }},</p>
			<p>inviamo il documento in oggetto.</p>			
			<p>cordiali saluti,</p>
			<p>Team Glisweb</p>
			<p><a href="https://glisweb.istricesrl.it">glisweb.istricesrl.it</a></p>'
	    )
	);
