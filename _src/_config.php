<?php

    /**
     * file di base del framework
     *
     * questo file costituisce la struttura portante del framework GlisWeb. Le operazioni svolte qui sono:
     *
     * -# dichiarazione delle funzioni di base
     * -# dichiarazione delle costanti di base
     * -# inizializzazione del generatore di numeri casuali
     * -# avvio dell'output buffering
     * -# lettura dei file di configurazione Json/Yaml
     * -# individuazione dei moduli attivi
     * -# inclusione dei file di libreria
     * -# inclusione dei file di configurazione
     *
     * architettura del framework
     * ==========================
     * Il framework GlisWeb è strutturato in una griglia formata dall'intersezione di due suddivisioni, una verticale (i moduli)
     * e una orizzontale (i livelli); i primi rappresentano gruppi indipendenti di funzionalità e caratteristiche che possono
     * essere attivati alla bisogna, i secondi rappresentano i passi di esecuzione del framework; l'ordine in cui il codice viene
     * eseguito è progressivo in questa griglia partendo dal livello più basso del modulo base, per finire al livello più alto
     * dell'ultimo modulo. Ogni livello viene eseguito per ogni modulo attivo prima di passare al successivo, e la controparte
     * custom di ogni blocco di codice viene eseguita subito dopo alla versione standard in modo da poterne aggiustare il
     * comportamento. Prima di questa esecuzione a griglia vengono inclusi i file di libreria con una logica di customizzazione
     * leggermente diversa (vedi sotto). Infine l'esecuzione passa al file che ha incluso il framework, e questo segna la
     * transizione dal framework space allo user space. Nel caso lo user space usi un motore di rendering come Twig per produrre
     * l'output finale, l'invocazione di questo motore segna un ulteriore passaggio dallo user space all'output space.
     *
     * gestione delle chiamate HTTP
     * ----------------------------
     * Le chiamate alla cartella dove è installato il framework vengono smistate tramite il file .htaccess in diversi modi; il
     * più semplice è l'accesso diretto a un file nel caso che questo esista. In secondo luogo la chiamata può essere indirizzata
     * a una delle API del framework. Infine, la chiamata può essere rifiutata per diverse ragioni. Un esame del file .htaccess
     * chiarirà immediatamente questi aspetti, molto più di qualsiasi spiegazione.
     *
     * organizzazione del framework
     * ============================
     * Il framework presenta due tipi di file e cartelle, facilmente distinguibili per la presenza (oppure l'assenza) del carattere
     * underscore iniziale nel nome. Le cartelle che iniziano per underscore sono anche chiamate cartelle «standard» del framework
     * e non dovrebbero essere modificate se non in fase di sviluppo. Ogni aspetto del framework può essere modificato, sovrascritto
     * o esteso tramite le corrispettive cartelle locali (senza underscore), e questo è quello che dovrebbero fare gli sviluppatori
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
     * L'argomento più in dettaglio è affrontato nel \ref cartelle "capitolo relativo alle cartelle" della documentazione tecnica.
     *
     * le cartelle standard
     * --------------------
     * Le cartelle standard rappresentano la struttura del framework e vengono sovrascritte dagli aggiornamenti.
     *
     * cartella                  | descrizione
     * --------------------------|---------------------------------------------------------------------------------------
     * _etc/                     | contiene i file di informazione e dettaglio del framework
     * _mod/                     | contiene i moduli del framework
     * _src/                     | contiene i file sorgenti che fanno parte dell'esecuzione principale del framework
     * _usr/                     | contiene i file sorgenti che non fanno parte dell'esecuzione principale
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
     * tmp/                      | contiene i file temporanei
     * var/                      | contiene i file che cambiano nel tempo, come cache, log e file caricati dagli utenti
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
     * file di configurazione Json/Yaml
     * ================================
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
     * moduli dipendenti e moduli correlati
     * ------------------------------------
     * Si noterà che i codici numerici dei moduli sono raggruppati per migliaia, da zero a nove; questo simbolegga
     * i rapporti di dipendenza che ci sono fra i moduli individuati dalle migliaia e quelli con codice maggiore
     * all'interno della stessa migliaia. Quando i codici di due moduli si trovano in questa situazione, si dice
     * che il maggiore è dipendente dal minore; questo può significare che nel minore sono per esempio definite
     * entità che sono richieste al minore per funzionare, oppure sono dichiarate funzioni necessarie all'esecuzione
     * del codice del minore, e così via.
     *
     * La migliaia zero fa eccezione in questo senso, e i moduli che le appartengono non si trovano in rapporto
     * di dipendenza gli uni dagli altri.
     *
     * Al di là di questo rapporto di dipendenza, è possibile che alcuni moduli siano correlati fra loro, ovverosia
     * che la presenza di un modulo può modificare il comportamento dell'altro ma non ne è un prerequisito, e
     * ovviamente viceversa.
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
     * 700         | configurazioni relative all'importazione, all'elaborazione e all'esportazione dei dati
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
	// die( print_r( $_REQUEST, true ) );
    // die( $_SERVER['REDIRECT_URL'] );
    // die( $_SERVER['REQUEST_URI'] );

    /**
     *
     * questa funzione restiuisce la versione custum di un path standard
     * 
     * @todo documentare
     *
     */
    function path2custom( $p, $s = '' ) {
        $p = str_replace( $_SERVER['DOCUMENT_ROOT'], '§', $p );
        $p = str_replace(  '_', $s, $p );
        $p = str_replace( '§', $_SERVER['DOCUMENT_ROOT'], $p );
        return $p;
    }

    /**
     *
     * @todo documentare
     *
     */
	function glob2custom( $p ) {
        return path2custom( $p, '{,_}' );
	}

    /**
     *
     * @todo documentare
     *
     */
	function scandir2array( $p ) {
	    return array_values( array_diff( scandir( $p ), array( '..', '.' ) ) );
	}

    /**
     *
     * @todo documentare
     *
     */
	function array2censored( &$a ) {
	    array_walk_recursive(
		$a,
		function( &$v, $k ) {
		    if( in_array( $k, array( 'password', 'private', 'key', 'secret', 'sa', 'sb', 'sc', 'token' ), true ) ) {
			    $v = '***';
		    }
		}
	    );
	}

    // controllo performances
	define( 'START_TIME'			, microtime( true ) );

    // directory base
	define( 'DIR_BASE'			, str_replace( '_src' , NULL , dirname( __FILE__ ) ) );

    // directory standard
	define( 'DIR_ETC'			, DIR_BASE . '_etc/' );
	define( 'DIR_ETC_LOC'			, DIR_BASE . '_etc/_loc/' );
	define( 'DIR_MOD'			, DIR_BASE . '_mod/' );
	define( 'DIR_SRC'			, DIR_BASE . '_src/' );
	define( 'DIR_SRC_API'			, DIR_BASE . '_src/_api/' );
    define( 'DIR_SRC_API_JOB'		, DIR_BASE . '_src/_api/_job/' );
    define( 'DIR_SRC_API_REPORT'		, DIR_BASE . '_src/_api/_report/' );
    define( 'DIR_SRC_API_TASK'		, DIR_BASE . '_src/_api/_task/' );
	define( 'DIR_SRC_CONFIG'		, DIR_BASE . '_src/_config/' );
	define( 'DIR_SRC_CONFIG_EXT'		, DIR_BASE . '_src/_config/_ext/' );
	define( 'DIR_SRC_HTML'			, DIR_BASE . '_src/_html/' );
	define( 'DIR_SRC_INC'			, DIR_BASE . '_src/_inc/' );
	define( 'DIR_SRC_INC_CONTENTS'		, DIR_BASE . '_src/_inc/_contents/' );
	define( 'DIR_SRC_INC_CONTROLLERS'	, DIR_BASE . '_src/_inc/_controllers/' );
	define( 'DIR_SRC_INC_MACRO'		, DIR_BASE . '_src/_inc/_macro/' );
	define( 'DIR_SRC_LIB'			, DIR_BASE . '_src/_lib/' );
	define( 'DIR_SRC_LIB_EXT'		, DIR_BASE . '_src/_lib/_ext/' );
	define( 'DIR_USR'			, DIR_BASE . '_usr/' );
    define( 'DIR_USR_DATABASE'      , DIR_USR . '_database/');
    define( 'DIR_USR_DATABASE_PATCH'      , DIR_USR_DATABASE . '_patch/');
	define( 'DIR_USR_DOCS'			, DIR_BASE . '_usr/_docs/' );
	define( 'DIR_USR_DOCS_BUILD'		, DIR_BASE . '_usr/_docs/build/' );
	define( 'DIR_USR_DOCS_BUILD_HTML'	, DIR_BASE . '_usr/_docs/build/html/' );
	define( 'DIR_USR_DOCS_BUILD_LATEX'	, DIR_BASE . '_usr/_docs/build/latex/' );

    // directory solo custom
	define( 'DIR_ETC_SITEMAP'		, DIR_BASE . 'etc/sitemap/' );
	define( 'DIR_TMP'			, DIR_BASE . 'tmp/' );
	define( 'DIR_VAR'			, DIR_BASE . 'var/' );
	define( 'DIR_VAR_CACHE'			, DIR_BASE . 'var/cache/' );
	define( 'DIR_VAR_CACHE_PAGES'		, DIR_BASE . 'var/cache/pages/' );
	define( 'DIR_VAR_CACHE_TWIG'		, DIR_BASE . 'var/cache/twig/' );
	define( 'DIR_VAR_CONTENUTI'		, DIR_BASE . 'var/contenuti/' );
	define( 'DIR_VAR_IMMAGINI'		, DIR_BASE . 'var/immagini/' );
    define( 'DIR_VAR_LOG'			, DIR_BASE . 'var/log/' );
    define( 'DIR_VAR_LOG_CRON'   , DIR_VAR_LOG . 'cron/' );
    define( 'DIR_VAR_LOG_JOB'   , DIR_VAR_LOG . 'job/' );
    define( 'DIR_VAR_LOG_MYSQL'   , DIR_VAR_LOG . 'mysql/' );
    define( 'DIR_VAR_LOG_MYSQL_PATCH'   , DIR_VAR_LOG_MYSQL . 'patch/' );
    define( 'DIR_VAR_LOG_PIANIFICAZIONI'   , DIR_VAR_LOG . 'pianificazioni/' );
	define( 'DIR_VAR_LOG_LATEST'		, DIR_BASE . 'var/log/latest/' );
	define( 'DIR_VAR_LOG_SLOW'		, DIR_BASE . 'var/log/slow/' );
    define( 'DIR_VAR_SPOOL'			, DIR_BASE . 'var/spool/' );
    define( 'DIR_VAR_SPOOL_CART'			, DIR_BASE . 'var/spool/cart/' );
    define( 'DIR_VAR_SPOOL_DOCS'			, DIR_BASE . 'var/spool/docs/' );
    define( 'DIR_VAR_SPOOL_EXPORT'			, DIR_BASE . 'var/spool/export/' );
    define( 'DIR_VAR_SPOOL_IMPORT'			, DIR_BASE . 'var/spool/import/' );
    define( 'DIR_VAR_SPOOL_MAIL'			, DIR_BASE . 'var/spool/mail/' );
    define( 'DIR_VAR_SPOOL_PAYMENT'			, DIR_BASE . 'var/spool/payment/' );
    define( 'DIR_VAR_SPOOL_PRINT'			, DIR_BASE . 'var/spool/print/' );

    // file
    define( 'FILE_AUTOLOAD'         ,  DIR_SRC_LIB_EXT . 'autoload.php' );
	define( 'FILE_CURRENT_RELEASE'		, DIR_ETC . '_current.release.conf' );
	define( 'FILE_CURRENT_VERSION'		, DIR_ETC . '_current.version.conf' );
	define( 'FILE_LATEST_RUN'		, DIR_VAR_LOG_LATEST . 'run.latest.log');
	define( 'FILE_LATEST_CRON'		, DIR_VAR_LOG_LATEST . 'cron.latest.log');
	define( 'FILE_LATEST_MYSQL'		, DIR_VAR_LOG_LATEST . 'mysql.latest.log');
	define( 'FILE_LATEST_SITEMAP'		, DIR_VAR_LOG_LATEST . 'sitemap.latest.log');
	define( 'FILE_LATEST_RELEASE'		, path2custom( DIR_ETC ) . 'latest.release.conf' );
	define( 'FILE_LATEST_VERSION'		, path2custom( DIR_ETC ) . 'latest.version.conf' );
	define( 'FILE_LICENSE'			, path2custom( DIR_ETC ) . 'license.conf' );
	define( 'FILE_LOREM'			, DIR_ETC . '_lorem.conf' );
	define( 'FILE_MANUAL_HTML'		, DIR_USR_DOCS_BUILD_HTML . 'index.html' );
    define( 'FILE_MANUAL_PDF'		, DIR_USR_DOCS_BUILD_LATEX . 'refman.pdf' );
    define( 'FILE_MYSQL_PATCH'      , DIR_USR_DATABASE . 'mysql.schema.version');
	define( 'FILE_REDIRECT'			, path2custom( DIR_ETC ) . 'redirect.csv' );
	define( 'FILE_STATUS'			, path2custom( DIR_ETC ) . 'status.conf' );

    // livelli di controllo
	define( 'CONTROL_FILTERED'		, 'FILTERED' );
	define( 'CONTROL_FULL'			, 'FULL' );

    // azioni
	define( 'METHOD_DELETE'			, 'DELETE' );       // cancellazione
	define( 'METHOD_GET'			, 'GET' );          // lettura
	define( 'METHOD_PATCH'			, 'PATCH' );        // aggiornamento
	define( 'METHOD_POST'			, 'POST' );         // inserimento
	define( 'METHOD_PUT'			, 'PUT' );          // modifica
	define( 'METHOD_REPLACE'		, 'REPLACE' );      // rimpiazzo
	define( 'METHOD_UPDATE'			, 'UPDATE' );       // aggiornamento

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

    // costanti per il contenuto
	define( 'MIME_APPLICATION_JSON'		, 'application/json' );
	define( 'MIME_APPLICATION_XML'		, 'application/xml' );
	define( 'MIME_MULTIPART_FORM_DATA'	, 'multipart/form-data' );
	define( 'MIME_TEXT_PLAIN'		, 'text/plain' );
	define( 'MIME_TEXT_HTML'		, 'text/html' );
    define( 'MIME_X_WWW_FORM_URLENCODED',   'application/x-www-form-urlencoded' );

    // costanti per la visualizzazione
    define( 'SHOW_ALWAYS'               , 'SHOW_ALWAYS' );

    // costanti per l'encoding
	define( 'ENCODING_UTF8'			, 'utf-8' );

    // filtro di sicurezza
    require DIR_SRC_INC_MACRO . '_security.php';

    // controllo scrittura
    if( ! is_writeable( DIR_BASE ) ) {
        die( 'la cartella di installazione non è scrivibile, lanciare _lamp.permissions.reset.sh' );
    }

    // inizializzazione motore numeri casuali
	mt_srand( ( double ) microtime() * 1000000 );

    // avvio dell'output buffer con compressione gzip se possibile, senza altrimenti
	if( ob_start( 'ob_gzhandler' ) ) {
	    $cf['ob']['status']			= OB_ATTIVO_CON_GZIP;
	} elseif( ob_start() ) {
	    $cf['ob']['status']			= OB_ATTIVO;
	} else {
	    $cf['ob']['status']			= OB_NON_ATTIVO;
	}

    // NOTA il file src/config/external/config.yaml è stato posizionato lì in modo che sia possibile
    // montare la cartella src/config/external/ come ConfigMap in Kubernetes - questo spiega anche
    // perché src/config/external/config.yaml ha la priorità su src/config/config.yaml

    // NOTA visto che in caso di configurazione tramite mount di partizione su Kubernetes non dovrebbero
    // essere presenti altri file di configurazione non si può semplificare src/config/external/ in
    // src/config/ e montare quella?

    // file di configurazione da considerare nell'ordine
	$cf['config']['files']['yaml'][]	= path2custom( DIR_SRC_CONFIG_EXT . 'config.yaml' );
	$cf['config']['files']['yaml'][]	= path2custom( DIR_SRC . 'config.yaml' );
	$cf['config']['files']['json'][]	= path2custom( DIR_SRC_CONFIG_EXT . 'config.json' );
	$cf['config']['files']['json'][]	= path2custom( DIR_SRC . 'config.json' );

    // lettura del file di configurazione aggiuntivi YAML o JSON
	foreach( $cf['config']['files'] as $type => $files ) {
	    foreach( $files as $file ) {
            if( file_exists( $file ) ) {
                $cf['config']['file']	= $file;
                switch( $type ) {
                    case 'yaml':
                        $cx			= yaml_parse( file_get_contents( $file ) );
                    break;
                    case 'json':
                        $cx			= json_decode( file_get_contents( $file ), true );
                    break;
                }
                if( empty( $cx ) ) {
                    die( 'file di configurazione ' . $file . ' danneggiato' );
                }
            }
	    }
	}

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
	// var_dump( $cx );

    // array dei moduli attivi
	if( isset( $cx['mods']['active']['array'] ) ) {
	    $cf['mods']['active']['array']	= $cx['mods']['active']['array'];
	} elseif( file_exists( path2custom( DIR_MOD ) ) ) {
	    $cf['mods']['active']['array']	= scandir2array( path2custom( DIR_MOD ) );
	} else {
	    $cf['mods']['active']['array']	= array();
	}

    // stringa dei moduli attivi
	$cf['mods']['active']['string']		= implode( ',', $cf['mods']['active']['array'] );

    // NOTA fra i tre alberi ci dev'essere corrispondenza completa nella struttura (al netto del fatto che ci sono informazioni
    // in $cx/$cf che non vanno ribaltate su $ct in modo da evitare confusioni e dubbi sulla posizione dei dati, specialmente in
    // fase di reperimento delle informazioni dal template manager

    // NOTA la lettura dei moduli attivi dalle variabili d'ambiente è obsoleta

    // moduli attivi
	define( 'MODULI_ATTIVI'			        	    , $cf['mods']['active']['string'] );
	define( 'DIR_MOD_ATTIVI'			            , DIR_MOD . '_{' . MODULI_ATTIVI . '}/' );
	define( 'DIR_MOD_ATTIVI_SRC_API_JOB'	        , DIR_MOD_ATTIVI . '_src/_api/_job/' );
	define( 'DIR_MOD_ATTIVI_SRC_INC_CONTROLLERS'	, DIR_MOD_ATTIVI . '_src/_inc/_controllers/' );
	define( 'DIR_MOD_ATTIVI_SRC_INC_MACRO'	        , DIR_MOD_ATTIVI . '_src/_inc/_macro/' );
	define( 'DIR_MOD_ATTIVI_SRC_LIB'		        , DIR_MOD_ATTIVI . '_src/_lib/' );
	define( 'DIR_MOD_ATTIVI_ETC_LOC'		        , DIR_MOD_ATTIVI . '_etc/_loc/' );

    // collego $ct
	$ct['mods']				= &$cf['mods'];

    // ricerca dei files di libreria
	$arrayLibrerieBase			= glob( DIR_SRC_LIB . '_*.*.php' );
	$arrayLibrerieModuli			= glob( DIR_MOD_ATTIVI_SRC_LIB . '_*.*.php', GLOB_BRACE );
	$arrayLibrerie				= array_unique( array_merge( $arrayLibrerieBase , $arrayLibrerieModuli ) );

    /**
     *
     * @todo implementare la possibilità di saltare delle librerie
     *
     * TODO come è possibile saltare dei runlevel, dovrebbe essere possibile saltare delle librerie, sia con
     * una specificazione inclusiva (tipo "voglio solo queste librerie") sia esclusiva (tipo "includi tutte le librerie
     * tranne queste") in modo da alleggerire l'esecuzione del framework in caso non sia necessario includere tutte le
     * librerie
     *
     * NOTA la strategia inclusiva andrebbe creata anche per i runlevel, che attualmente hanno solo quella esclusiva
     *
     */

    // inclusione dei files di libreria
	foreach( $arrayLibrerie as $libreria ) {
        $locale = path2custom( $libreria );
        $aggiuntiva = str_replace( '.php', '.add.php', $locale );
	    if( file_exists( $locale ) ) {
		require $locale;
	    } else {
		require $libreria;
        }
        if( file_exists( $aggiuntiva ) ) {
        require $aggiuntiva;
        }
	}

    // debug
	// die( print_r( get_included_files(), true ) );
	// die( 'LIBRARY CONFIG DONE' );

    /**
     *
     * @todo bloccare l'esecuzione se non esistono le funzioni writeToFile() e logWrite()?
     *
     */

    // inclusione delle librerie esterne
    if( file_exists( FILE_AUTOLOAD ) ) {
        require FILE_AUTOLOAD;
        timerCheck( $cf['speed'], FILE_AUTOLOAD );
    } else {
        die( 'autoload mancante, eseguire composer update' );
    }

    // debug
	// die( 'EXTERNAL LIBRARY CONFIG DONE' );

    // richiesta esplicita di esecuzione runlevel
    if( isset( $cf['runlevels']['run'] ) ) {
        $lvls2run = '{' . implode( ',', $cf['runlevels']['run'] ) . '}*';
    } else {
        $lvls2run = '*';
    }

    // ricerca dei files di configurazione standard
	$arrayConfig				= glob( DIR_SRC_CONFIG . '_' . $lvls2run . '.*.php', GLOB_BRACE );

    // ordinamento dei file trovati
	sort( $arrayConfig );

    // NOTA in alcuni casi non tutti i runlevel sono necessari, quindi è possibile per uno specifico file richiedere
    // che alcuni di essi vengano saltati; questo migliora le prestazioni del framework e riduce lo spreco di risorse

    // CHIAVI DI CONFIGURAZIONE
    // $cf['lvls']				contiene informazioni sui runlevel
    // $cf['lvls']['skip']			contiene l'array dei runlevel da saltare

    // filtri per runlevels
	if( ! isset( $cf['lvls']['skip'] ) ) { $cf['lvls']['skip'] = array(); }

    // NOTA le funzioni che hanno "to" nel nome per omogeneità con le altre dovrebbero diventare "2" ad esempio
    // writeToFile() dovrebbe diventare write2file()

    // log
	writeToFile( date( 'Y-m-d H:i:s' ) . ' ' . ( isset( $_SERVER['REDIRECT_URL'] ) ? $_SERVER['REDIRECT_URL'] : $_SERVER['REQUEST_URI'] ) . PHP_EOL, FILE_LATEST_RUN );
	appendToFile( 'inizio esecuzione runlevel' . PHP_EOL, FILE_LATEST_RUN );

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
	// die( 'INIZIO ESECUZIONE RUNLEVEL' );

    // inclusione dei files di configurazione
    // NOTA questa è l'esecuzione della griglia moduli/livelli
	foreach( $arrayConfig as $configFile ) {

	    // debug
		// echo $configFile . PHP_EOL;

	    // controparte locale
		$configFileLocale = path2custom( $configFile );

	    // calcolo runlevel
		$runLvlArray = explode( '.', basename( $configFileLocale ) );
		$runLvlString = array_shift( $runLvlArray );

	    // salto i runlevel specificati
		if( ! in_array( $runLvlString, $cf['lvls']['skip'] ) ) {

		    // inclusione file standard
			require $configFile;
			timerCheck( $cf['speed'], $configFile );
			appendToFile( 'eseguito runlevel -> ' . $configFile . PHP_EOL, FILE_LATEST_RUN );

		    // inclusione file locale
			if( file_exists( $configFileLocale ) ) {
			    require $configFileLocale;
			    timerCheck( $cf['speed'], $configFileLocale );
			    appendToFile( 'eseguito runlevel -> ' . $configFileLocale . PHP_EOL, FILE_LATEST_RUN );
			}

		    // debug
			// echo str_replace( DIR_BASE, DIR_MOD_ATTIVI, $configFile ) . PHP_EOL;

		    // controparte moduli
			$arrayConfigModuli = glob( str_replace( DIR_BASE, DIR_MOD_ATTIVI, $configFile ), GLOB_BRACE );
			foreach( $arrayConfigModuli as $configFileModuli ) {

			    // debug
				// echo $configFileModuli . PHP_EOL;

			    // inclusione file di modulo
				require $configFileModuli;
				timerCheck( $cf['speed'], $configFileModuli );
				appendToFile( 'eseguito runlevel -> ' . $configFileModuli . PHP_EOL, FILE_LATEST_RUN );

			    // controparte modulo locale
				$configFileModuliLocale = path2custom( $configFileModuli );
				if( file_exists( $configFileModuliLocale ) ) {
				    require $configFileModuliLocale;
				    timerCheck( $cf['speed'], $configFileModuliLocale );
				    appendToFile( 'eseguito runlevel -> ' . $configFileModuliLocale . PHP_EOL, FILE_LATEST_RUN );
				}

			}

		} else {

		    logWrite( 'saltato runlevel: ' . $runLvlString, 'speed', LOG_DEBUG );

		}

	}

    // debug
    appendToFile( 'fine esecuzione runlevel' . PHP_EOL, FILE_LATEST_RUN );

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
