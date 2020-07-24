<?php

    /**
     * file di base del framework
     *
     * questo file costituisce la struttura portante del framework GlisWeb. Le operazioni svolte qui sono:
     *
     * -# dichiarazione delle funzioni di base
     * -# dichiarazione delle costanti di base
     * -# avvio dell'output buffering
     * -# lettura dei file di configurazione aggiuntivi
     * -# individuazione dei moduli attivi
     * -# inclusione dei files di libreria
     * -# inclusione dei files di configurazione
     *
     * architettura del framework
     * ==========================
     * Il framework presenta due tipi di cartelle, facilmente distinguibili per la presenza (oppure l'assenza) del carattere
     * underscore iniziale nel nome. Le cartelle che iniziano per underscore sono anche chiamate cartelle «standard» del framework
     * e non dovrebbero essere modificate se non in fase di sviluppo. Ogni aspetto del framework può essere modificato, sovrascritto o
     * esteso tramite le corrispettive cartelle locali (senza underscore), e questo è quello che dovrebbero fare gli sviluppatori
     * che utilizzano il framework per realizzare le proprie applicazioni.
     *
     * GlisWeb implementa un meccanismo molto semplice di personalizzazione, basato sui nomi dei files. Se per esempio volete
     * modificare un valore presente in _src/_config/_010.site.php non dovete far altro che creare una copia "locale" del file,
     * eliminando tutti gli underscore dal percorso (quindi in questo caso ad esempio src/config/010.site.php) e al suo interno
     * dichiarare nuovamente le variabili delle quali intendete modificare il valore di default. Al momento dell'esecuzione,
     * il framework si accorgerà dei files "locali" e li leggerà subito dopo ai corrispondenti "standard", sovrascrivendo in
     * questo modo i valori di default.
     *
     * Personalizzare il framework è quindi molto semplice; partite dai file presenti nella cartella _src/_config ed esaminate
     * attentamente la documentazione presente in ognuno di essi, prendendo nota dei valori che dovete modificare per adattare
     * il framework alla vostra situazione; create le necessarie copie "custom" dei file e modificate i valori che vi siete
     * annotati; a questo punto avrete completato la personalizzazione iniziale del framework e sarete pronti per utilizzarlo
     * al pieno delle sue potenzialità.
     *
     * le cartelle standard
     * --------------------
     * Le cartelle standard rappresentano la struttura del framework e vengono sovrascritte dagli aggiornamenti.
     *
     * cartella                  | descrizione
     * --------------------------|---------------------------------------------------------------------------------------
     * _etc/                     | contiene file di configurazione
     * _etc/_dictionaries/       | contiene file dei dizionari per la traduzione
     * _mod/                     | contiene i moduli del framework
     * _src/                     | contiene i file sorgenti del framework
     * _src/_api/                | contiene le API standard del framework
     * _src/_config/             | contiene i file di configurazione del framework
     * _src/_img/                | contiene le immagini standard del framework
     * _src/_img/_flags/         | contiene le bandiere degli stati
     * _src/_inc/                | contiene gli script inclusi del framework
     * _src/_inc/_pages/         | contiene le definizioni delle pagine
     * _src/_lib/                | contiene i file di libreria
     * _src/_lib/_external/      | contiene i file di libreria di terze parti
     * _src/_test/               | contiene i file per i test
     * _src/_test/_framework/    | contiene i file per i test delle funzionalità del framework
     * _usr/                     | contiene files di vario tipo, che non fanno parte del codice sorgente del framework
     * _usr/_database/           | contiene gli schemi e i dati di default per i database del framework
     * _usr/_docs/               | contiene le pagine DOX della documentazione
     * _usr/_docs/_build/        | contiene la documentazione compilata
     * _usr/_docs/_etc/          | contiene i file di configurazione di Doxygen
     *
     * le cartelle locali
     * ------------------
     * Le cartelle locali o custom rappresentano lo spazio in cui gli sviluppatori che utilizzano il framework per
     * creare le proprie applicazioni possono scrivere codice che non viene sovrascritto dagli aggiornamenti.
     *
     * Vediamo qui di seguito le cartelle che esistono solo in locale o che hanno in locale una valenza particolare
     * rispetto alla loro controparte standard; la creazione delle cartelle locali necessarie al funzionamento del
     * framework viene fatta automaticamente alla bisogna.
     *
     * cartella                  | descrizione
     * --------------------------|---------------------------------------------------------------------------------------
     * tmp/                      | cartella per i file temporanei
     * var/cache/                | cartella per lo stoccaggio dei files di cache
     * var/cache/twig/           | cartella per la cache della libreria Twig
     * var/log/                  | contiene i log del framework
     *
     * dichiarazione delle costanti
     * ============================
     * Queste costanti sono condivise e utilizzate in tutto il framewor, per questo vengono dichiarate
     * qui; tutte le librerie e il codice del framework presuppone che esse siano presenti per il proprio
     * funzionamento.
     *
     * output buffering
     * ================
     * L'output buffering è una tecnica per cui l'output viene stoccato in un buffer per poi essere
     * inviato tutto in una volta, eventualmente compresso, al client. Per ulteriori informazioni
     * si veda https://www.php.net/outcontrol
     *
     * file di configurazione aggiuntivi
     * =================================
     * Il framework supporta la configurazione tramite file JSON o YAML (vedi sotto), le informazioni contenute
     * nei file JSON e YAML vengono lette prima delle altre e poi sovrapposte a quelle standard, di conseguenza
     * è possibile ridefinirle tramite i file di configurazione PHP, anche se nella maggior parte dei casi
     * questo non ha molto senso, a meno che non si desideri bloccare alcuni valori rendendoli non
     * definibili tramite JSON o YAML.
     *
     * l'array $cx
     * -----------
     * L'array $cx ha una struttura analoga e sovrapponibile all'array $cf (vedi sotto), e viene ricavato dai file
     * JSON o YAML di configurazione, per poi essere sovrapposto alle analoghe strutture dell'array $cf; in pratica
     * rende possibile la configurazione del framework tramite file di configurazione JSON. Esistono due livelli di
     * configurazione tramite JSON/YAML, il secondo pensato per la configurazione dinamica in ambiente containerizzato.
     *
     * moduli del framework
     * ====================
     * I moduli sono parti di codice opzionali che possono essere aggiunti al framework per incrementarne
     * le funzionalità. Il framework standard comprende tutti i moduli, ma vengono considerati attivi
     * solo quelli che hanno una corrispondente sottocartella nella cartella mods/.
     *
     * I file di libreria dei moduli attivi vengono inclusi con la stessa logica standard/custom già
     * vista per le librerie principali, mentre i file di configurazione vengono inclusi, sempre con la
     * logica standard/custom vista sopra, solo se presenti nel modulo base.
     *
     * inclusione dei files di libreria
     * ================================
     * La strategia di inclusione dei files di libreria (contenenti costanti e funzioni) è molto
     * semplice. Per prima cosa viene generato un elenco dei files di libreria presenti nella parte
     * standard del framework, dopodiché per ognuno di essi viene verificata l'eventuale esistenza
     * di un corrispondente file locale. Se il file locale esiste, è incluso; diversamente, viene
     * incluso il file standard.
     *
     * Questo significa che, se si desidera riscrivere una specifica funzione del framework standard,
     * è necessario copiare comunque l'intera libreria in locale altrimenti le altre funzioni non
     * verrebbero trovate.
     *
     * Le librerie del framework sono divise in tools e utils. Le librerie di tipo tools sono
     * utilizzabili indipendentemente dal framework stesso, mentre le librerie di tipo utils sono
     * legate alle logiche interne del framework (tipicamente all'array $cf) e pertanto non possono
     * essere utilizzate indipendentemente da esso.
     *
     * librerie esterne
     * ----------------
     * Il framework gestisce le librerie esterne tramite composer; le librerie vengono installate
     * nella sottocartella _src/_lib/_external/ che sostituisce la classica cartella vendor/ di
     * composer in modo da semplificarne la distribuzione tramite FTP.
     *
     * inclusione dei files di configurazione
     * ======================================
     * Per l'inclusione dei files di configurazione viene utilizzata una strategia differente rispetto
     * a quella utilizzata per le librerie; se il file locale è presente, questo viene incluso dopo
     * il file standard.
     *
     * Questo significa che se si desidera modificare il valore di una o più variabili presenti in
     * un file di configurazione standard non è necessario copiare in locale tutte le variabili presenti
     * in standard, ma soltanto quelle modificate. Non è ovviamente possibile ridefinire in questo
     * modo le costanti.
     *
     * La struttura dei file di configurazione costituisce l'impalcatura del framework; vengono cercati
     * tutti i file presenti nella sottocartella _src/_config/ e nella sua controparte custom src/config/
     * in ordine per nome di file; per questa ragione i file di configurazione iniziano con un numero,
     * per garantirne l'esecuzione in ordine controllato.
     *
     * Il framework utilizza due array principali per archiviare la configurazione. L'array $cf contiene
     * i dati visibili soltanto al framework, mentre l'array $ct condiene una copia di parte dell'array $cf
     * e viene passato a eventuali template manager per la costruzione delle pagine. Questo argomento
     * viene approfondito più avanti.
     *
     * organizzazione dei file di configurazione
     * -----------------------------------------
     * I files di configurazione del framework sono suddivisi in sezioni identificate dalla cifra delle
     * centinaia, come si vede nella seguente tabella:
     *
     * sezione     | descrizione
     * ------------|---------------------------------------------------------------------------------------------
     * 000         | configurazioni iniziali del framework e del deploy corrente
     * 100         | configurazioni delle sorgenti dati (database, ecc.)
     * 200         | configurazioni relative al login agli utenti, all'utente corrente e ai permessi
     * 300         | configurazioni relative alle pagine del sito
     * 400         | configurazioni relative all'URL rewriting
     * 500         | configurazioni relative alla posta
     * 600         | integrazioni con piattaforme di terze parti
     * 700         | configurazioni relative all'importazione e all'esportazione dei dati
     * 800         | -
     * 900         | operazioni finali
     *
     * ordine di inclusione dei files di configurazione
     * ------------------------------------------------
     * I file di configurazione vengono inclusi nell'ordine indicato dal nome, con precedenza ai file
     * standard in modo da dare la possibilità ai file custom di ridefinire i valori standard, e con
     * priorità al modulo base rispetto ai moduli aggiuntivi per dare la possibilità ai moduli aggiuntivi
     * di ridefinire i valori base.
     *
     * l'array $cf
     * -----------
     * L'array $cf contiene la struttura dati portante del framework. Tutte le variabile importanti per
     * l'esecuzione si trovano qui, ordinate in una struttura ad albero.
     *
     * l'array $ct
     * -----------
     * L'array $ct è un sottoinsieme dell'array $cf e ne rispecchia la struttura; contiene tutti e soli i dati
     * che vengono passati al template manager per la rappresentazione in output; questo viene fatto per
     * ragioni di sicurezza, per prevenire che dati sensibili vengano accidentalmente esposti in output.
     *
     *
     *
     * @todo finire di documentare
     * @todo verificare, correggere e completare la sezione sulle cartelle
     * @todo $cf['mods']['active']['string'] è un inutile doppione di MODULI_ATTIVI
     * @todo $cf['mods']['active']['array'] potrebbe diventare $cf['mods']['active']
     *
     * @file
     *
     */

    // debug
	// die( 'CONFIG INIT' );

    // TODO documentare
	function path2custom( $p ) {
	    return str_replace( '_', NULL, $p );
	}

    // REFACTORING le costanti DIRECTORY_* dovrebbero diventare per brevità DIR_* inoltre il nome dovrebbe rappresentare
    // il percorso (ad es. per DIRECTORY_LOG e DIRECTORY_LOG_LATEST dovrebbero diventare DIR_VAR_LOG e DIR_VAR_LOG_LATEST)
    // inoltre i percorsi dovrebbero essere composti concatenando le cartelle (ad es. DIR_VAR_LOG_LATEST = DIR_VAR_LOG . 'latest/')
    // infine le cartelle figlie di DIR_BASE dovrebbero includere DIR_BASE (ad es. DIR_VAR = DIR_BASE . 'var/' e di conseguenza
    // DIR_VAR_LOG = DIR_VAR . 'log/) questo per semplificare l'uso delle costanti di directory e ridurre il ricorso
    // in concatenazione a DIR_BASE)

    // REFACTORING conseguentemente dove possibile i nomi delle cartelle andrebbero ridotti a tre lettere (ad es. _src/_lib/_external
    // può divnetare _src/_lib/_ext/ e _src/_inc/_controllers può diventare _src/_inc/_cnt/ e così via) lasciando come eccezione
    // le cartelle custom che non esistono in standard (ad es. var/cache/ può rimanere così) anche se preferibilmente per i nomi
    // delle cartelle andrebbe usato l'inglese (ad es. var/immagini/ dovrebbe essere var/images/)

    // controllo performances
	define( 'START_TIME'			, microtime( true ) );

    // directory base
	define( 'DIRECTORY_BASE'		, str_replace( '_src' , NULL , dirname( __FILE__ ) ) );

    // directory
	define( 'DIRECTORY_ETC'			, '_etc/' );
	define( 'DIRECTORY_DIZIONARI'		, '_etc/_dictionaries/' );
	define( 'DIRECTORY_MODULI'		, '_mod/' );
	define( 'DIRECTORY_SRC'			, '_src/' );
	define( 'DIRECTORY_CONFIGURAZIONE'	, '_src/_config/' );
	define( 'DIRECTORY_INCLUSIONI'		, '_src/_inc/' );
	define( 'DIRECTORY_CONTROLLER'		, '_src/_inc/_controllers/' );
	define( 'DIRECTORY_LIBRERIE'		, '_src/_lib/' );
	define( 'DIRECTORY_LIBRERIE_EX'		, '_src/_lib/_external/' );
	define( 'DIRECTORY_TEMPORANEA'		, 'tmp/' );
	define( 'DIRECTORY_VAR'			, 'var/' );
	define( 'DIRECTORY_CACHE'		, 'var/cache/' );
	define( 'DIRECTORY_IMMAGINI'		, 'var/immagini/' );
	define( 'DIRECTORY_LOG'			, 'var/log/' );
	define( 'DIRECTORY_LOG_LATEST'		, 'var/log/latest/' );

    // file
	define( 'FILE_LATEST_RUN'		,  DIRECTORY_BASE . DIRECTORY_LOG_LATEST . 'run.latest.log');
	define( 'FILE_LATEST_CRON'		,  DIRECTORY_BASE . DIRECTORY_LOG_LATEST . 'cron.latest.log');

    // livelli di controllo
	define( 'FILTERED_CONTROL'		, 'FILTERED' );
	define( 'FULL_CONTROL'			, 'FULL' );

    // azioni
	define( 'METHOD_DELETE'			, 'DELETE' );
	define( 'METHOD_GET'			, 'GET' );
	define( 'METHOD_PATCH'			, 'PATCH' );
	define( 'METHOD_POST'			, 'POST' );
	define( 'METHOD_PUT'			, 'PUT' );
	define( 'METHOD_REPLACE'		, 'REPLACE' );
	define( 'METHOD_UPDATE'			, 'UPDATE' );

    // costanti per l'identificazione dei database
	define( 'DB_MYSQL'			, 'MYSQL' );
	define( 'DB_POSTGRESQL'			, 'PGSQL' );
	define( 'DB_MSSQL'			, 'MSSQL' );

    // costanti che descrivono lo stato dell'output buffering
	define( 'OB_NON_ATTIVO'			, 'NOOB'  );
	define( 'OB_ATTIVO'			, 'OB' );
	define( 'OB_ATTIVO_CON_GZIP'		, 'OBGZ' );

    // costanti che descrivono il backend per le sessioni
	define( 'SESSION_APACHE'		, 'SESS_APACHE'  );
	define( 'SESSION_FILESYSTEM'		, 'SESS_FS'  );
	define( 'SESSION_REDIS'			, 'SESS_REDIS' );
	define( 'SESSION_MEMCACHE'		, 'SESS_MEMCACHE' );

    // avvio dell'output buffer con compressione gzip se possibile, senza altrimenti
	if( ob_start( 'ob_gzhandler' ) ) {
	    $cf['ob']['status']			= OB_ATTIVO_CON_GZIP;
	} elseif( ob_start() ) {
	    $cf['ob']['status']			= OB_ATTIVO;
	} else {
	    $cf['ob']['status']			= OB_NON_ATTIVO;
	}

    // CHIAVI DI CONFIGURAZIONE
    // $cf['ob']				contiene le informazioni relative all'output buffering
    // $cf['ob']['status']			contiene lo stato dell'output buffering

    // NOTA il file src/config/external/config.yaml è stato posizionato lì in modo che sia possibile
    // montare la cartella src/config/external/ come ConfigMap in Kubernetes - questo spiega anche
    // perché src/config/external/config.yaml ha la priorità su src/config/config.yaml

    // NOTA visto che in caso di configurazione tramite mount di partizione su Kubernetes non dovrebbero
    // essere presenti altri file di configurazione non si può semplificare src/config/external/ in
    // src/config/ e montare quella?

    // NOTA si può usare path2custom() per i nomi dei file da includere

    // lettura del file di configurazione aggiuntivi YAML o JSON
	if( file_exists( DIRECTORY_BASE . 'src/config/external/config.yaml' ) ) {
	    $cx = yaml_parse( file_get_contents( DIRECTORY_BASE . 'src/config/external/config.yaml' ) );
	    $cf['config']['file']		= DIRECTORY_BASE . 'src/config/external/config.yaml';
	} elseif( file_exists( DIRECTORY_BASE . 'src/config.yaml' ) ) {
	    $cx = yaml_parse( file_get_contents( DIRECTORY_BASE . 'src/config.yaml' ) );
	    $cf['config']['file']		= DIRECTORY_BASE . 'src/config.yaml';
	} elseif( file_exists( DIRECTORY_BASE . 'src/config/external/config.json' ) ) {
	    $cx = json_decode( file_get_contents( DIRECTORY_BASE . 'src/config/external/config.json' ), true );
	    $cf['config']['file']		= DIRECTORY_BASE . 'src/config/external/config.json';
	} elseif( file_exists( DIRECTORY_BASE . 'src/config.json' ) ) {
	    $cx = json_decode( file_get_contents( DIRECTORY_BASE . 'src/config.json' ), true );
	    $cf['config']['file']		= DIRECTORY_BASE . 'src/config.json';
	}

    // CHIAVI DI CONFIGURAZIONE
    // $cf['config']				contiene informazioni generali sulla configurazione del framework
    // $cf['config']['file']			contiene il percorso del file di configurazione aggiuntiva corrente

    // REFACTORING
    // sarebbe bello poter ricavare implicitamente i moduli attivi dalla struttura dell'array $cx/$cf senza doverli dichiarare
    // esplicitamente in $cf['mods']['active']['array'] cosa che a volte ci si dimentica di fare causando poi errori piuttosto
    // antipatici da debuggare

    // NOTA si potrebbe sfruttare i numeri dei moduli per questo, in maniera simile a quello che già facciamo per i runlevel?
    // c'è il problema che differentemente dai runlevel qui si tratta di fare dei glob() sul filesystem quindi serve in realtà
    // il nome completo della cartella

    // debug
	// echo $cf['config']['file'] . PHP_EOL;
	// print_r( $cx );
	// die( 'EXTERNAL CONFIG DONE' );

    // array dei moduli attivi
	if( isset( $cx['mods']['active']['array'] ) ) {
	    $cf['mods']['active']['array']	= $cx['mods']['active']['array'];
	    $cf['mods']['active']['string']	= implode( ',', $cf['mods']['active']['array'] );
	} elseif( file_exists( str_replace( '_', '', DIRECTORY_BASE . DIRECTORY_MODULI ) ) ) {
	    $cf['mods']['active']['array']	= array_values( array_diff( scandir( str_replace( '_', '', DIRECTORY_BASE . DIRECTORY_MODULI ) ) , array( '..' , '.' ) ) );
	    $cf['mods']['active']['string']	= implode( ',', $cf['mods']['active']['array'] );
#	} elseif( ! empty( $_ENV['ACTIVE_MODULES'] ) ) {
#	    $cf['mods']['active']['array']	= explode( ',', $_ENV['ACTIVE_MODULES'] );
#	    $cf['mods']['active']['string']	= getenv( 'ACTIVE_MODULES' );
	} else {
	    $cf['mods']['active']['array']	= array();
	    $cf['mods']['active']['string']	= NULL;
	}

    // NOTA fra i tre alberi ci dev'essere corrispondenza completa nella struttura (al netto del fatto che ci sono informazioni
    // in $cx/$cf che non vanno ribaltate su $ct in modo da evitare confusioni e dubbi sulla posizione dei dati, specialmente in
    // fase di reperimento delle informazioni dal template manager

    // CHIAVI DI CONFIGURAZIONE
    // $cf['mods']				contiene informazioni sui moduli
    // $cf['mods']['active']			contiene l'elenco dei moduli attivi
    // $cf['mods']['active']['array']		contiene l'elenco dei moduli attivi in forma di array
    // $cf['mods']['active']['string']		contiene l'elenco dei moduli attivi in forma di stringa separata da virgole

    // NOTA la lettura dei moduli attivi dalle variabili d'ambiente è obsoleta

    // moduli attivi
	define( 'MODULI_ATTIVI'			, $cf['mods']['active']['string'] );

    // collego $ct
	$ct['mods']				= &$cf['mods'];

    // ricerca dei files di libreria
	$arrayLibrerieBase			= glob( DIRECTORY_BASE . DIRECTORY_LIBRERIE . '_*.*.php' );
	$arrayLibrerieModuli			= glob( DIRECTORY_BASE . DIRECTORY_MODULI . '_{' . MODULI_ATTIVI . '}/' . DIRECTORY_LIBRERIE . '_*.*.php', GLOB_BRACE );
	$arrayLibrerie				= array_merge( $arrayLibrerieBase , $arrayLibrerieModuli );

    // TODO come è possibile saltare dei runlevel, dovrebbe essere possibile saltare delle librerie, sia con
    // una specificazione inclusiva (tipo "voglio solo queste librerie") sia esclusiva (tipo "includi tutte le librerie
    // tranne queste") in modo da alleggerire l'esecuzione del framework in caso non sia necessario includere tutte le
    // librerie

    // NOTA la strategia inclusiva andrebbe creata anche per i runlevel, che attualmente hanno solo quella esclusiva

    // inclusione dei files di libreria
	foreach( $arrayLibrerie as $libreria ) {
	    $locale = str_replace( '_' , '' , $libreria );
	    if( file_exists( $locale ) ) {
		require $locale;
	    } else {
		require $libreria;
	    }
	}

    // debug
	// die( print_r( get_included_files(), true ) );
	// die( 'LIBRARY CONFIG DONE' );

    // inclusione delle librerie esterne
	require DIRECTORY_BASE . DIRECTORY_LIBRERIE . '_external/autoload.php';

    // debug
	// die( 'EXTERNAL LIBRARY CONFIG DONE' );

    // ricerca dei files di configurazione standard
	$arrayConfig				= glob( DIRECTORY_BASE . DIRECTORY_CONFIGURAZIONE . '_*.*.php' );

    // ordinamento dei file trovati
	sort( $arrayConfig );

    // NOTA in alcuni casi non tutti i runlevel sono necessari, quindi è possibile per uno specifico file richiedere
    // che alcuni di essi vengano saltati; questo migliora le prestazioni del framework e riduce lo spreco di risorse

    // CHIAVI DI CONFIGURAZIONE
    // $cf['runlevels']				contiene informazioni sui runlevel
    // $cf['runlevels']['skip']			contiene l'array dei runlevel da saltare

    // REFACTORING $cf['runlevels'] dovrebbe diventare $cf['lvls'] per analogia con $cf['mods']

    // filtro per runlevels
	if( ! isset( $cf['runlevels']['skip'] ) ) { $cf['runlevels']['skip'] = array(); }

    // NOTA le funzioni che hanno "to" nel nome per omogeneità con le altre dovrebbero diventare "2" ad esempio
    // writeToFile() dovrebbe diventare write2file()

    // log
	writeToFile( 'inizio esecuzione runlevels' . PHP_EOL, FILE_LATEST_RUN );

    // NOTA il framework prevede alcuni file di log speciali, utili soprattutto per il debug; questi file vengono scritti
    // a parte, direttamente con appendToFile(), senza passare dalla factory di log principale logWrite() per ridurre le
    // possibilità che un problema di esecuzione ne pregiudichi l'integrità
    //
    // FILE_LATEST_RUN				contiene il tracciato dell'ultima esecuzione del framework, utile per capire
    //						dove si trova il problema in caso di esecuzione parziale che termina con errore
    // FILE_LATEST_CRON				contiene il tracciato dell'ultima esecuzione dei task e dei job pianificati
    //						con cron, utile per verificare che cron stia girando e per monitorare il suo
    //						output, altrimenti difficile da catturare in altra maniera

    // debug
	// die( 'INIZIO ESECUZIONE RUNLEVELS' );

    // inclusione dei files di configurazione
	foreach( $arrayConfig as $configFile ) {

	    // debug
		// echo $configFile . PHP_EOL;

	    // controparte locale
		$configFileLocale = str_replace( '_', '', $configFile );

	    // calcolo runlevel
		$runLvlArray = explode( '.', basename( $configFileLocale ) );
		$runLvlString = array_shift( $runLvlArray );

	    // salto i runlevel specificati
		if( ! in_array( $runLvlString, $cf['runlevels']['skip'] ) ) {

		    // inclusione file standard
			require $configFile;
			timerCheck( $cf['speed'], $configFile );
			appendToFile( 'esecuzione runlevel -> ' . $configFile . PHP_EOL, FILE_LATEST_RUN );

		    // inclusione file locale
			if( file_exists( $configFileLocale ) ) {
			    require $configFileLocale;
			    timerCheck( $cf['speed'], $configFileLocale );
			    appendToFile( 'esecuzione runlevel -> ' . $configFileLocale . PHP_EOL, FILE_LATEST_RUN );
			}

		    // controparte moduli
			$arrayConfigModuli = glob( str_replace( DIRECTORY_BASE, DIRECTORY_BASE . DIRECTORY_MODULI . '_{' . MODULI_ATTIVI . '}/', $configFile ), GLOB_BRACE );
			foreach( $arrayConfigModuli as $configFileModuli ) {

			    // debug
				// echo $configFileModuli . PHP_EOL;

			    // inclusione file di modulo
				require $configFileModuli;
				timerCheck( $cf['speed'], $configFileModuli );
				appendToFile( 'esecuzione runlevel -> ' . $configFileModuli . PHP_EOL, FILE_LATEST_RUN );

			    // controparte modulo locale
				$configFileModuliLocale = str_replace( '_', '', $configFileModuli );
				if( file_exists( $configFileModuliLocale ) ) {
				    require $configFileModuliLocale;
				    timerCheck( $cf['speed'], $configFileModuliLocale );
				    appendToFile( 'esecuzione runlevel -> ' . $configFileModuliLocale . PHP_EOL, FILE_LATEST_RUN );
				}

			}

		} else {

		    logWrite( 'saltato runlevel: ' . $runLvlString, 'speed', LOG_DEBUG );

		}

	}

    // CHIAVI DI CONFIGURAZIONE
    // $cf['speed']				contiene informazioni sulla velocità e sulle performance del framework

    // debug
	// die( 'CONFIG END' );

    // NOTA le costanti e gli array $cx/$cf/$ct dovrebbero essere gli unici ad avere visibilità su file diversi; per evitare
    // confusioni e collisioni le variabili dovrebbero sempre avere il loro ciclo di vita limitato al file in cui vengono
    // dichiarate

    // debug
	// print_r( get_included_files() );
	// print_r( $cf );
	// print_r( $ct );
	// print_r( $cx );

?>
