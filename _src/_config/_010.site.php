<?php

    /**
     * dichiarazione dei siti gestiti
     *
     * in questo file vengono dichiarati i siti gestiti dall'installazione corrente del framework
     *
     * il concetto di sito
     * ===================
     * Una sola installazione fisica del framework è in grado di gestire più siti, intesi come diversi insiemi
     * di pagine, configurazioni e risorse multimediali. Questo risulta particolarmente comodo quando si devono
     * creare e gestire gruppi di siti fortemente interconnessi, magari con contenuti condivisi fra essi.
     *
     * In uno scenario multisito è possibile gestire, ad esempio, tutti i siti da un solo pannello di controllo,
     * il che rappresenta di per sé già una notevole comodità. Tutti i siti attivi nell'installazione corrente
     * sono definiti come sotto array dell'array $cf['sites'] e sono identificati da un ID che è anche la
     * chiave di $cf['sites'].
     *
     * struttura dell'array sito
     * -------------------------
     * Ogni sotto array di $cf['sites'] rappresenta un sito gestito dalla piattaforma, e come tale possiede
     * chiavi e sotto array che lo definiscono. Per una trattazione completa della struttura del sotto array sito
     * si rimanda alla \ref variabili "pagina del manuale che tratta le variabili del framework". In questa sede
     * è sufficiente evidenziare il ruolo svolto da $cf['sites']. L'installazione base del framework prevede
     * un solo sito, di default, a scopo principalmente dimostrativo; volendo utilizzare GlisWeb come piattaforma
     * per pubblicare contenuti sul web, la prima cosa da fare dovrebbe essere personalizzare in custom
     * (src/config/010.site.php) il sito di default.
     *
     *
     *
     * @todo finire di documentare
     *
     * @file
     *
     */

    /*
     * TODO per supportare l'identificazione della lingua corrente tramite sottodominio, dominio e cartella,
     * le chiavi protocols, hosts, domains, e folders dovrebbero avere un ulteriore livello per la lingua:
     *
     * $cf['sites'][ 1 ]['domains']['it-IT'][ TESTING ]				= NULL;
     *
     * le modifiche al codice necessarie per gestire questa chiave in più sono tutte già pronte e commentate
     * nel file _015.site.php tuttavia bisogna considerare anche le modifiche necessarie al file 320.pages.php
     * relativamente alla generazione dei vari URL della pagina per le diverse lingue MA SOPRATTUTTO le modifiche
     * da fare al file _025.site.php per la definizione dei parametri correnti del site, che non devono avere
     * la lingua specificata ma necessitano della lingua per prelevare i valori corretti da sites
     *
     * prima di procedere, valutare attentamente le indicazioni di https://support.google.com/webmasters/answer/182192?hl=it
     * e valutare anche di rimuovere il suffisso della lingua nel caso il sito abbia una sola lingua (oppure sempre,
     * magari pensare a un'opzione per questo)
     *
     * NOTA attualmente questa modifica è in sospeso, in quanto è possibile gestire il multilingua per dominio
     * o sotto dominio anche tramite il multisito, creando un sito separato per le varie lingue; in questo caso però
     * il selettore a bandiere standard non funzionerà e andrà creato custom
     *
     */

    // l'id del sito
	$cf['sites'][ 1 ]['id']							= 1;

    // l'etichetta del sito
	$cf['sites'][ 1 ]['__label__']						= 'default';

    // il titolo del sito
	$cf['sites'][ 1 ]['name']['it-IT']					= NULL;

    // i protocolli del sito
	$cf['sites'][ 1 ]['protocols'][ DEVELOPEMENT ]				=
	$cf['sites'][ 1 ]['protocols'][ TESTING ]				=
	$cf['sites'][ 1 ]['protocols'][ PRODUCTION ]				= 'http';

    // gli host del sito
	$cf['sites'][ 1 ]['hosts'][ DEVELOPEMENT ]				=
	$cf['sites'][ 1 ]['hosts'][ TESTING ]					=
	$cf['sites'][ 1 ]['hosts'][ PRODUCTION ]				= $_SERVER['HTTP_HOST'];

    // i domini del sito
	$cf['sites'][ 1 ]['domains'][ DEVELOPEMENT ]				=
	$cf['sites'][ 1 ]['domains'][ TESTING ]					=
	$cf['sites'][ 1 ]['domains'][ PRODUCTION ]				= NULL;

    // gli alias degli host del sito
	$cf['sites'][ 1 ]['alias']['hosts'][ DEVELOPEMENT ]			=
	$cf['sites'][ 1 ]['alias']['hosts'][ TESTING ]				=
	$cf['sites'][ 1 ]['alias']['hosts'][ PRODUCTION ]			=

    // gli alias dei domini del sito
	$cf['sites'][ 1 ]['alias']['domains'][ DEVELOPEMENT ]			=
	$cf['sites'][ 1 ]['alias']['domains'][ TESTING ]			=
	$cf['sites'][ 1 ]['alias']['domains'][ PRODUCTION ]			= array();

    // le cartelle base del sito
	$cf['sites'][ 1 ]['folders'][ DEVELOPEMENT ]				=
	$cf['sites'][ 1 ]['folders'][ TESTING ]					=
	$cf['sites'][ 1 ]['folders'][ PRODUCTION ]				= NULL;

    // id pagina home
	$cf['sites'][ 1 ]['homes'][ DEVELOPEMENT ]				=
	$cf['sites'][ 1 ]['homes'][ TESTING ]					=
	$cf['sites'][ 1 ]['homes'][ PRODUCTION ]				= NULL;

    // configurazione extra
	if( isset( $cx['sites'] ) ) {
	    $cf['sites'] = array_replace_recursive( $cf['sites'], $cx['sites'] );
	}

    // link al multisito
	$ct['sites'] = &$cf['sites'];

?>
