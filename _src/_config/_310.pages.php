<?php

    /**
     * definizione delle pagine
     *
     * array delle pagine
     * ==================
     * Il framework contiene un potente meccanismo per la pubblicazione di pagine web; tramite
     * semplici array di configurazione è possibile creare e pubblicare un complesso albero di
     * contenuti; l'organizzazione ad albero delle pagine è di importanza centrale in quanto
     * tutte le logiche del framework che trattano le pagine ragionano su alberi.
     *
     * In pratica è sufficiente definire le pagine che si desidera pubblicare, e le relazioni
     * che le legano fra loro, e il framework provvederà a creare tutta la struttura dati
     * necessaria per la loro pubblicazione.
     *
     * il concetto di pagina
     * ---------------------
     * Una pagina, nel framework, è una singola unità di contenuto che può essere richiesta
     * tramite un URL. Il framework è in grado di interpretare diversi tipi di richieste tramite
     * URL e individurare il contenuto da visualizzare di conseguenza. Tali richieste possono
     * essere effettuate in due modi:
     *
     * - tramite QUERY STRING
     * - tramite URL rewriting
     *
     * Di seguito analizzeremo entrambi questi modi di effettuare le richieste e vedremo che
     * sono strettamente collegati, in quanto le richieste di tipo URL rewriting vengono in
     * effetti convertite in richieste di tipo QUERY STRING. Ne consegue che il framework può,
     * in linea del tutto teorica, funzionare anche in assenza di URL rewriting.
     *
     * formato delle richieste tramite QUERY STRING
     * --------------------------------------------
     * Le richieste tramite QUERY STRING devono essere indirizzate all'API _src/_api/_pages.php;
     * questo reindirizzamento viene fatto dal file .htaccess che si trova nella cartella radice
     * del framework, al quale si rimanda per approfondimenti. Per poter essere gestita, la
     * richiesta deve contenere i seguenti parametri:
     *
     * chiave     | tipo          | dettagli
     * -----------|---------------|------------------------------------------------------------
     * __rp__[]   | obbligatoria  | l'array del percorso delle pagine fino a quella corrente
     * __lg__     | opzionale     | la lingua in cui visualizzare il contenuto in formato IETF
     * __id__     | opzionale     | l'id di un oggetto da unire al contenuto richiesto
     *
     * Se per esempio vogliamo richiedere in italiano la pagina pluto, figlia della pagina
     * topolino, potremo farlo tramite la seguente chiamata:
     *
     * \code
     * GET /_src/_api/_pages.php?__rp__[0]=topolino&__rp__[1]=pluto&__lg__=it
     * \endcode
     *
     * In pratica è necessario specificare il percorso fino al nodo che desideriamo indicando
     * tutti i suoi antenati, in quanto potrebbero esistere più nodi con lo stesso nome in punti
     * diversi dell'albero e l'unico modo di identificarli univocamente è tramite il loro
     * percorso completo a partire dalla radice.
     *
     * \todo verificare che __id__ sia ancora in uso
     * \todo __lg__ dovrebbe contenere una stringa IETF, verificare l'esempio sopra
     *
     * formato delle richieste tramite URL rewriting
     * ---------------------------------------------
     * Grazie a una serie di regole presenti nel file .htaccess che si trova nella radice, il
     * framework è in grado di interpretare richieste molto più semplici da scrivere e da
     * ricordare delle precedenti. Queste richieste hanno la forma di un comune URL, ad esempio
     * riprendendo il caso visto nel paragrafo precedente possiamo richiedere la medesima
     * pagina in questo modo:
     *
     * \code
     * GET /topolino/pluto.it.html
     * \endcode
     *
     * Le regole del file .htaccss trasformeranno per noi questo URL in una richiesta di tipo
     * QUERY STRING simile a quella vista sopra. Le richieste vengono interpretate più avanti,
     * nel file _400.rewrite.php al quale si rimanda per i dettagli; per ora è sufficiente
     * citare la principale differenza fra i due casi, ovvero la presenza, nel secondo, di
     * un'unica stringa con il percorso in $_REQUEST['__rw__'] che viene poi esplosa nell'array
     * $_REQUEST['__rp__'] che già conosciamo all'inizio del file /_src/_api/_pages.php.
     *
     * identificatori di pagina e riferimenti di pagina
     * ------------------------------------------------
     * Al fine di evitare confusioni ed errori, è importante sottolineare la differenza fra
     * riferimenti di pagina e identificatori di pagina, mostrando cosa si intende per essi e
     * come il framework li utilizza.
     *
     * Gli identificatori sono stringhe alfanumeriche arbitrarie univoce tramite le quali il
     * framework può individuare le pagine. Di solito l'utente finale ignora gli identificatori
     * delle pagine che sta visualizzando.
     *
     * I riferimenti di pagina sono invece delle stringhe ricavate dal titolo della pagina,
     * modificato per renderlo compatibile con gli URL, e vengono tradotti in identificatori
     * tramite apposite tabelle di transcodifica; una pagina può avere più riferimenti (ad
     * esempio, ne avrà uno per ogni lingua attiva sul sito, visto che vengono generati a
     * partire dal titolo) ma un solo identificativo.
     *
     * definizione dell'albero dei contenuti
     * -------------------------------------
     * Le pagine vengono definite nell'array associativo $cf['contents']['pages'], nel quale ogni
     * chiave corrisponde a un identificativo di pagina; ogni elemento dell'array definisce
     * quindi il contenuto e le caratteristiche della pagina indicata in chiave. Le chiavi
     * obbligatorie sono:
     *
     * chiave          | dettagli
     * ----------------|------------------------------------------------------------------------
     * parent.*        | l'identificatore della pagina genitore
     * parent.h1.*     | il tag H1 del parent, per lingua
     * parent.id       | l'id del parent
     * parent.title.*  | il tag title del parent, per lingua
     * parent.path.*   | il path per il parent, per lingua
     * template.*      | l'indicazione del template da utilizzare per la pagina
     * template.path   | il percorso per la cartella del template
     * template.schema | il nome dello schema da usare all'interno del template
     * title.*         | il valore del tag title, in chiave la lingua in formato IETF
     *
     * Le chiavi opzionali sono:
     *
     * chiave          | dettagli                                                   | default
     * ----------------|------------------------------------------------------------|-----------
     * auth.groups     | array dei gruppi autorizzati a visualizzare la pagina      | tutti
     * contents.*      | contenuti aggiuntivi, in chiave la lingua in formato IETF  |
     * css.*           | i CSS da includere                                         |
     * h1.*            | il valore del tag H1, in chiave la lingua in formato IETF  | come title
     * headers         | gli headers HTTP da lanciare                               |
     * js.*            | gli script Javascript da includere                         |
     * macro           | le macro da attivare                                       |
     * menu.*          | la posizione della pagina nei menu del sito                |
     * rewrited.*      | rewrite custom, in chiave la lingua in formato IETF        |
     * sitemap         | indica se includere o no la pagina nella sitemap           | true
     *
     * Le chiavi che identificano un template sono:
     *
     * chiave          | dettagli
     * ----------------|------------------------------------------------------------------------
     * parents.*       | array dei genitori della pagina, descrive il percorso verso la pagina
     * path.*          | URL della pagina, in chiave la lingua in formato IETF
     * rewrited.*      | il nome della pagina in formato URL compatibile, per lingua
     * tree.*          | vista parziale dell'albero dei contenuti relativa alla pagina corrente
     *
     * La chiave parents contiene dei sottoarray per id, path, e title, con sottochiavi per le
     * lingue dove necessario.
     *
     * I menu sono identificati in chiave dal nome; le chiavi che identificano un menu sono:
     *
     * chiave          | dettagli
     * ----------------|------------------------------------------------------------------------
     * *.label.*       | l'etichetta, in chiave la lingua in formato IETF
     * *.priority      | il peso della pagina relativamente alle proprie sorelle
     *
     * chiavi aggiunte automaticamente alla configurazione delle pagine
     * ----------------------------------------------------------------
     *
     * Le seguenti chiavi vengono valorizzate solitamente se la pagina è creata a partire dal
     * database:
     *
     * chiave          | dettagli
     * ----------------|------------------------------------------------------------------------
     * id              | l'id della pagina nel database
     *
     * Alcune chiavi, anche se teoricamente potrebbero essere popolate già in fase di
     * configurazione della pagina, sono di solito valorizzate automaticamente dal file di
     * configurazione del template:
     *
     * chiave          | dettagli
     * ----------------|------------------------------------------------------------------------
     * css.external.*  | i fogli di stile CSS esterni aggiuntivi
     * css.template.*  | i fogli di stile CSS del template
     * js.external.*   | gli script Javascript esterni aggiuntivi
     * js.internal.*   | gli script Javascript interni del framework
     *
     * I file inclusi in questo modo, sia che si tratti di CSS, sia che si tratti di script
     * Javascript, sono divisi in gruppi secondo il percorso di inclusione:
     *
     * sottochiave     | dettagli
     * ----------------|------------------------------------------------------------------------
     * external        | non viene aggiunto nessun percorso di inclusione
     * internal        | viene aggiunto solo il percorso per la radice del sito
     * template        | viene aggiunti i percorsi per la radice e per il template
     *
     * inclusione dei file di definizione delle pagine
     * -----------------------------------------------
     * Dal momento che i file di configurazione delle pagine possono diventare piuttosto
     * verbosi, il framework supporta un meccanismo di inclusione che consente di suddividerli
     * per comodità di gestione. La cartella dedicata alla configurazione delle pagine è
     * /_src/_inc/_pages/ e ne esiste una corrispettiva anche nei moduli; entrambe sono
     * sovrascritte da eventuali configurazioni custom.
     *
     * pagine di default e pagine riservate
     * ====================================
     *
     *
     *
     *
     *
     *
     *
     * @todo verificare le tabelle di questo commento, se sono aggiornate oppure no
     * @todo finire di documentare
     *
     * @file
     *
     */

    // cache
	if( $cf['contents']['cached'] === false ) {

	    // log
        if( ! empty( $cf['memcache']['connection'] ) ) {
            logWrite( 'struttura delle pagine NON presente in cache, elaborazione...', 'speed', LOG_ERR );
        }

	    // debug
		// print_r( $cf['localization']['language'] );

	    // array delle pagine
		$cf['contents']['pages']		= array();

	    // ultimo aggiornamento delle pagine, per la generazione della sitemap
		$cf['contents']['updated']		= NULL;

	    // configurazione extra
		if( isset( $cx['contents'] ) ) {
		    $cf['contents'] = array_replace_recursive( $cf['contents'], $cx['contents'] );
		}

	    // variabili di lavoro
		$lingue					= '{' . LINGUE_ATTIVE . '}';
		$folder					= '{,_}src/{,_}inc/{,_}pages/{,_}*';
		$mods					= '{,_}mod/{,_}{' . MODULI_ATTIVI . '}/';

	    // ricerca dei files delle pagine
		$arrayPagineBase			= glob( DIR_BASE . $folder . '.' . $lingue . '.php', GLOB_BRACE );
		$arrayPagineModuli			= glob( DIR_BASE . $mods . $folder . '.' . $lingue . '.php', GLOB_BRACE );

	    // debug
		// echo DIRECTORY_BASE . $folder . '.' . $lingue . '.php' . PHP_EOL;
		// echo DIRECTORY_BASE . $mods . $folder . '.' . $lingue . '.php' . PHP_EOL;
		// print_r( $arrayPagineBase );
		// print_r( $arrayPagineModuli );

	    // ordinamento
		asort( $arrayPagineBase );
		asort( $arrayPagineModuli );

	    // semplificazione
		$arrayPagine				= array_unique( array_merge( $arrayPagineBase , $arrayPagineModuli ) );

	    // inclusione dei files delle pagine
		foreach( $arrayPagine as $pagina ) {
		    $ts = filemtime( $pagina );
		    if( $ts > $cf['contents']['updated'] ) {
			$cf['contents']['updated'] = $ts;
		    }
		    require $pagina;
            if( file_exists( path2custom( $pagina ) ) ) {
                require path2custom( $pagina );
            }
		    $cf['contents']['pages'] = array_replace_recursive( $cf['contents']['pages'], $p );
		}

	    // debug
		// echo $cf['contents']['updated'];

	    // le pagine possono essere scritte in cache
# NOTA questa cosa è obsoleta?
#		$cf['contents']['cacheable']['pages'] = true;
		// TODO? $cf['cache']['todo'][ CONTENTS_PAGES_KEY ] = true;

	    // configurazione extra per sito
		if( isset( $cf['site']['contents'] ) ) {
		    $cf['contents'] = array_replace_recursive(
                $cf['contents'],
                $cf['site']['contents'] );
		}

#11	} else {

	    // non è necessario scrivere le pagine in cache
#11		$cf['contents']['cacheable']['pages'] = false;
		// TODO? $cf['cache']['todo'][ CONTENTS_PAGES_KEY ] = false;

	}

/*
    // TODO questo file non innesca il meccanismo di refresh della cache dei contenuti,
    // vedi _mod/_3000.contenuti/_src/_config/_310.pages.php

    DOVREBBE ESSERE TIPO COSÌ:

    } else {

	    // variabili di lavoro
		$lingue					= '{' . LINGUE_ATTIVE . '}';
		$folder					= '{,_}src/{,_}inc/{,_}pages/{,_}*';
		$mods					= '{,_}mod/{,_}{' . MODULI_ATTIVI . '}/';

	    // ricerca dei files delle pagine
		$arrayPagineBase			= glob( DIR_BASE . $folder . '.' . $lingue . '.php', GLOB_BRACE );
		$arrayPagineModuli			= glob( DIR_BASE . $mods . $folder . '.' . $lingue . '.php', GLOB_BRACE );

	    // semplificazione
		$arrayPagine				= array_unique( array_merge( $arrayPagineBase , $arrayPagineModuli ) );

	    // inclusione dei files delle pagine
		foreach( $arrayPagine as $pagina ) {
		    $ts = filemtime( $pagina );
		    if( $ts > $cf['contents']['updated'] ) {
			$cf['contents']['updated'] = $ts;
		    }
		}

    }

*/


    // debug
	// echo '300 STANDARD' . PHP_EOL;
	// print_r( $cf['contents']['pages'][ NULL ] );

    // debug
	// print_r( $cf['localization']['language'] );
	// print_r( $cf['contents']['pages']['licenza']['content'] );
	// print_r( $arrayPagine );
