<?php

    /**
     * file di base del framework
     *
     * questo file costituisce la struttura portante del framework GlisWeb.
     * 
     * introduzione
     * ============
     * La struttura di questo file è lineare, ma complessa; per orientarsi al suo interno conviene tenere presente a grandi
     * linee la sequenza delle operazioni che vengono svolte qui, e che sono:
     *
     * -# dichiarazione delle funzioni di base
     * -# dichiarazione delle costanti di base
     * -# inizializzazione dei log latest
     * -# inizializzazione dell'array di configurazione principale
     * -# inizializzazione dell'array dei tempi di esecuzione
     * -# verifica dei requisiti dell'ambiente
     * -# inizializzazione dell'array di configurazione per il template manager
     * -# inclusione del firewall applicativo
     * -# inizializzazione del generatore di numeri casuali
     * -# avvio dell'output buffering
     * -# lettura dei file di configurazione Json/Yaml
     * -# individuazione dei moduli attivi
     * -# inclusione dei file di libreria
     * -# inclusione dei file di libreria esterni
     * -# inclusione dei file dei runlevel
     * 
     * Nei prossimi paragrafi vedremo a grandi linee la struttura del framework e il modo in cui è organizzata la sua
     * esecuzione. Più avanti, all'inizio di ogni sezione del file, troverete una trattazione più approfondita di ciò che
     * viene fatto in quella specifica sezione.
     *
     * personalizzazione del framework
     * ===============================
     * La prima cosa importante da comprendere quando ci si approccia al framework GlisWeb è la sua logica di customizzazione;
     * essa infatti è parte integrante dell'architettura del framework, che nasce per poter essere completamente customizzato
     * nella maniere più facile possibile. Osservando le cartelle del framework, noterete che alcune iniziano con underscore;
     * questo indica che si tratta di cartelle standard, il cui contenuto e la cui struttura non devono essere modificate.
     * 
     * Per customizzare un qualsiasi file del framework sarà sufficiente crearne un'altra versione priva degli underscore nel
     * percorso; ad esempio se volete customizzare il comportamento di un file che si chiama, poniamo, _src/_esempio.php non
     * dovrete fare altro che creare nella document root del sito un file chiamato src/esempio.php e questo verrà eseguito di
     * seguito alla sua controparte standard.
     * 
     * Se volete che il file custom venga eseguito in alternativa a quello standard, dovete apporre l'estensione aggiuntiva
     * .alt.php al nome del file (quindi ad esempio src/esempio.alt.php verrà eseguito IN SOSTITUZIONE DI e non DI SEGUITO A
     * _src/_esempio.php). Questo comportamento è quello di default per alcuni tipi di file, come le librerie, che contenendo
     * dichiarazioni di funzioni potrebbero causare conflitti se venissero eseguiti insieme alla controparte custom. Se volete
     * cambiare questo comportamento è sufficiente utilizzare l'estensione .add.php (ad esempio src/lib/esempio.add.php verrà
     * eseguito DI SEGUITO A e non IN SOSTITUZIONE DI _src/_lib/_esempio.php).
     * 
     * sequenza di esecuzione del framework
     * ====================================
     * Il framework GlisWeb è strutturato in una griglia formata dall'intersezione di due suddivisioni, una verticale (i moduli)
     * e una orizzontale (i runlevel); i primi rappresentano gruppi indipendenti di funzionalità e caratteristiche che possono
     * essere attivati alla bisogna, i secondi rappresentano i passi di esecuzione del framework; l'ordine in cui il codice viene
     * eseguito è progressivo in questa griglia partendo dal livello più basso del modulo base, per finire al livello più alto
     * dell'ultimo modulo. Ogni livello viene eseguito per ogni modulo attivo prima di passare al successivo, e la controparte
     * custom di ogni blocco di codice viene eseguita subito dopo alla versione standard in modo da poterne aggiustare il
     * comportamento.
     * 
     * Prima di questa esecuzione a griglia vengono inclusi i file di libreria con una logica di customizzazione
     * leggermente diversa (vedi sotto). Infine l'esecuzione passa al file che ha incluso il framework, e questo segna la
     * transizione dal framework space allo user space. Nel caso lo user space usi un motore di rendering come Twig per produrre
     * l'output finale, l'invocazione di questo motore segna un ulteriore passaggio dallo user space all'output space.
     * 
     * Il seguente schema riassume il funzionamento interno del file _src/_config.php evidenziando i loop di inclusione delle
     * librerie e dei runlevel:
     * 
     *                           ============================ per ogni singola libreria ======================================
     *  +------------------+     +-------------------+     +-----------------+     +------------------+     +----------------+
     *  | _src/_config.php | --> | lib standard base | --> | lib custom base | --> | lib standard mod | --> | lib custom mod |
     *  +------------------+     +-------------------+     +-----------------+     +------------------+     +----------------+
     *                                                                                                               |
     *  +------------------------------------------------------------------------------------------------------------+
     *  |
     *  |    =========================================== per ogni singolo runlevel =================================
     *  |    +-------------------+     +----------------------+     +------------------+     +---------------------+
     *  +--> | runlevel std base | --> | runlevel custom base | --> | runlevel std mod | --> | runlevel custom mod |
     *       +-------------------+     +----------------------+     +------------------+     +---------------------+
     *                                                                                                  |
     *                                                                                                  v
     *                                                                                         +------------------+
     *                                                                                         | _src/_config.php |
     *                                                                                         +------------------+
     * 
     * Per comprendere meglio il funzionamento di questo file si consiglia di leggerne il codice con questo schema a portata
     * di mano.
     * 
     * il file .htaccess e la gestione delle chiamate HTTP
     * ---------------------------------------------------
     * Le chiamate alla cartella dove è installato il framework vengono smistate tramite il file .htaccess in diversi modi; il
     * più semplice è l'accesso diretto a un file nel caso che questo esista. Ad esempio se è presente il file prova.html nella
     * document root sarà possibile utilizzare un URL del tipo:
     * 
     * /prova.html
     * 
     * per raggiungerlo; in questo caso dato che il file esiste il famework vi darà accesso diretto ad esso.
     * 
     * In secondo luogo la chiamata può essere indirizzata a una delle API del framework. Infine, la chiamata può essere rifiutata
     * per diverse ragioni. Un esame del file .htaccess chiarirà immediatamente questi aspetti, molto più di qualsiasi spiegazione.
     * Ad esempio chiamare il seguente URL:
     * 
     * /esempio/prova.html
     * 
     * se il file /esempio/prova.html non esiste vi rimanderà a _src/_api/_pages.php?__rw__=esempio/prova&__lg__=html. La lettura
     * del file .htaccess chiarirà ulteriormente questo punto. Il meccanismo è riassunto da questo schema:
     *
     *  +-----------+      +-----------+      +-----+                  +------------------+
     *  | richiesta | ---> | .htaccess | ---> |     | -- (include) --> | _src/_config.php | <--> (librerie, runlevels, ecc.)
     *  +-----------+      +-----------+      |  A  |                  +------------------+
     *                                        |  P  |                            |
     *         +--------+      +-------+      |  I  | <--------------------------+
     *         | output | <--- | macro | <--- |     |
     *         +--------+      +-------+      +-----+
     *                            ^ |           ^ |
     *                            | v           | v
     *                   +---------------------------------+
     *                   | template o factory di rendering |
     *                   +---------------------------------+
     * 
     * TODO documentare relativamente al file .htaccess anche il file _etc/_robots/_robots.txt e in generale il ruolo del file robots.txt
     * 
     * TODO documentare la parte dopo il _config.php (API, macro di pagina, inclusione template, rendering, output)
     * 
     * organizzazione del filesystem del framework
     * ===========================================
     * Come si è detto, Il framework presenta due tipi di file e cartelle, facilmente distinguibili per la presenza (oppure l'assenza)
     * del carattere underscore iniziale nel nome. Le cartelle che iniziano per underscore sono anche chiamate cartelle «standard»
     * del framework e non dovrebbero essere modificate per nessun motivo.
     *
     * L'organizzazione delle cartelle del framework ubbidisce a una logica piuttosto ferrea, che consente di trovare a colpo sicuro
     * ciò che si sta cercando una volta che la si è compresa a pieno. L'argomento più in dettaglio è affrontato nella documentazione
     * e nei commenti ai vari file; qui si dà una veloce panoramica finalizzata a rendere più agevole la lettura dei paragrafi sevuenti.
     *
     * le cartelle standard
     * --------------------
     * Le cartelle standard rappresentano la struttura del framework e vengono sovrascritte dagli aggiornamenti. Per ulteriori dettagli
     * sul contenuto e sul ruolo di ogni cartella si veda il file _usr/_docs/_cartelle.dox.
     *
     * le cartelle custom
     * ------------------
     * Le cartelle custom rappresentano lo spazio in cui gli sviluppatori che utilizzano il framework per creare le proprie applicazioni
     * possono scrivere codice che non viene sovrascritto dagli aggiornamenti.
     *
     * moduli del framework
     * ====================
     * I moduli sono parti di codice opzionali che possono essere aggiunti al framework per incrementarne
     * le funzionalità. Il framework standard comprende tutti i moduli, ma vengono considerati attivi
     * solo quelli che hanno una corrispondente sottocartella nella cartella mods/.
     *
     */

    // debug
    // die( 'CONFIG INIT' );
    // die( print_r( $_REQUEST, true ) );
    // die( $_SERVER['REDIRECT_URL'] );
    // die( $_SERVER['$_SERVER['REQUEST_URI']'] );

    /**
     * dichiarazione delle funzioni di base
     * ====================================
     * Alcune funzioni sono necessarie al caricamento e all'avvio del framework; devono pertanto essere dichiarate subito
     * per poter proseguire con l'esecuzione.
     * 
     */

    /**
     * restiuisce la versione custum di un path standard
     * 
     * Questa funzione prende in input una stringa e la restituisce in versione custom (senza underscore); per
     * evitare di rimuovere involontariamente eventuali underscore presenti nel path per la document root (ad
     * esempio se la document root si trova in una cartella tipo /var/www/public_html/ che verrebbe erroneamente
     * riscritta in /var/www/publichtml/ rendendo di fatto irraggiungibile il framework) la funzione sostituisce
     * temporaneamente $_SERVER['DOCUMENT_ROOT'] con il carattere § per poi ripristinarla dopo aver sostituito
     * underscore con stringa vuota.
     * 
     * @param   string    $p        contiene il percorso da riscrivere
     * @param   string    $s        contiene il carattere da usare per indicare i percorsi custom (default stringa vuota)
     * 
     * @return  string              il percorso riscritto, ad es. da _prova/_test/ a prova/test/
     * 
     */
    function path2custom( $p, $s = '' ) {
        $p = str_replace( $_SERVER['DOCUMENT_ROOT'], '§', $p );
        $p = str_replace(  '_', $s, $p );
        $p = str_replace( '§', $_SERVER['DOCUMENT_ROOT'], $p );
        return $p;
    }

    /**
     * restituisce un path standard con gli underscore sostituiti da {,_}
     * 
     * Questa funzione crea una versione di un path standard che può essere data in pasto alla funzione glob()
     * per trovare sia la versione custom che la versione standard dei file. Questo viene fatto sostituendo
     * l'underscore con la formulazione {,_} che nel linguaggio di glob() significa "presente o no l'underscore".
     * 
     * @param   string  $p          il path da elaborare
     * 
     * @return  string              il path elaborato
     * 
     */
    function glob2custom( $p ) {
        return path2custom( $p, '{,_}' );
    }

    /**
     * restituisce il contenuto di una cartella al netto delle directory punto
     * 
     * Questa funzione utilizza scandir() per leggere il contenuto di una cartella e array_diff() per
     * rimuovere le cartelle punto (ossia '..' e '.') dall'elenco.
     * 
     * @param   string  $p          il percorso della cartella di cui si vuole il contenuto
     * 
     * @return  array               un array contenente gli elementi contenuti nella cartella specificata
     * 
     */
    function scandir2array( $p ) {
        return array_values( array_diff( scandir( $p ), array( '..', '.' ) ) );
    }

    /**
     * questa funzione restituisce un array censurando con asterischi i valori potenzialmente sensibili
     * 
     * Questa funzione attraversa ricorsivamente un array associativo e rimpiazza con '***' i valori delle
     * chiavi che corrispondono a un elenco di parole potenzialmente sensibili; in questo modo non si rischia
     * anche involontariamente di esporre dati sensibili sul web.
     * 
     * @param   array   &$a         l'array da censurare
     * 
     * @return  array               l'array censurato
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
        return $a;
    }

    /**
     * questa funzione verifica che un hash non sia presente nell'elenco delle password banali
     * 
     * Questa funzione viene utilizzata per verificare se una password è presente nell'elenco delle password banali.
     * 
     * @param   string  $p          la password da verificare codificata in md5
     * 
     * @return  bool                true se la password è banale, false altrimenti
     * 
     */
    function bruteForceHash( $p ) {
        $pwds = file( FILE_COMMON_PASSWORDS, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES );
        foreach( $pwds as $h ) {
            if( md5( $h ) == $p ) {
                return true;
            }
        }
        return false;
    }

    /**
     * questa funzione restituisce true se tutti i caratteri presenti in un array sono presenti in una stringa data
     * 
     * Questa funzione cerca in una stringa un elenco di caratteri dati e restituisce true se li trova tutti, false
     * altrimenti; è stata scritta per il WAF (_src/_inc/_macro/_security.php).
     * 
     * @param   string  $s          la stringa in cui cercare i caratteri
     * @param   array   $a          l'array dei caratteri da cercare
     * 
     * @return  bool                true se tutti i caratteri sono stati trovati, false altrimenti
     * 
     */
    function findChars( $s, $a ) {
        $matches = 0;
        foreach( $a as $c ) {
            if( stripos( $s, $c ) !== false ) {
                $matches++;
            }
        }
        return ( $matches == count( $a ) ) ? true : false;
    }

    /**
     * questa funzione crea un path se non esiste
     * 
     * Utilizzando la funzione mkdir() con il flag ricorsivo, questa funzione si assicura che un dato path
     * esista.
     * 
     * @param       string      $p      il path da verificare
     * 
     * @return      boolean             true in caso di successo, false altrimenti
     * 
     */
    function checkPath( $p, $r = 0775 ) {
        return ( is_dir( $p ) ) ? true : mkdir( $p, $r, true );
    }

    /**
     * questa funzione scrive un messaggio di log
     * 
     * La funzione logger() effettua una semplice scrittura su file di log. Si noti che la funzione logga soltanto i messaggi di gravità
     * uguale o superiore a quella corrente, che è definita dalla costante LOG_CURRENT_LEVEL; se questa non è definita, tutti i messaggi
     * vengono loggati.
     * 
     * Per impostare il livello di log si faccia riferimento al codice del file _src/_config/_000.debug.php; per impostare il livello di
     * gravità è possibile intervenire sulla versione custom di questo file oppure sul file di configurazione JSON/YAML.
     * 
     * @param       string      $m      il messaggio da scrivere
     * @param       string      $f      il percorso e il nome (senza estensione) del file di log da scrivere rispetto alla cartella dei log
     * @param       int         $l      il livello di gravità del messaggio
     * 
     * @return      void
     * 
     */
    function logger( $m, $f = 'core', $l = LOG_DEBUG ) {
        if( ! defined( 'LOG_CURRENT_LEVEL' ) || $l <= LOG_CURRENT_LEVEL ) {
            checkPath( dirname( DIR_VAR_LOG . $f ) );
            $lvl = array( 0 => 'emerg', 1 => 'alert', 2 => 'crit', 3 => 'err', 4 => 'warning', 5 => 'notice', 6 => 'info', 7 => 'debug' );
            $h = fopen( DIR_VAR_LOG . $f . '.' . $lvl[ $l ] . '.' . date( 'Ym' ) . '.log', 'a+' );
            fwrite( $h, date( 'Y-m-d H:i:s' ) . ' (' . $l . ') ' . str_replace( '§', PHP_EOL . "\t\t\t\t\t--> ", $m ) . PHP_EOL );
            fclose( $h );
        }
    }

    /**
     * questa funzione scrive un messaggio sul latest log
     * 
     * Il latest log è il log dettagliato dell'ultima esecuzione del framework, può essere anche molto verboso perché viene
     * sovrascritto ogni volta e quindi non rischia di diventare troppo grande e quindi illeggibile oltre agli ovvi rischi
     * di saturare il disco.
     * 
     * @param       string      $m      il messaggio da scrivere
     * 
     * @return      void
     * 
     */
    function loggerLatest( $m, $l = FILE_LATEST_RUN, $w = 'a+' ) {
        checkPath( dirname( $l ) );
        $h = fopen( $l, $w );
        fwrite( $h, ( ( $w == 'a+' ) ? sprintf( '%01.4f', microtime( true ) ) . ' ' : '' ) . $m . PHP_EOL );
        fclose( $h );
    }

    /**
     * questa funzione restituisce la timestamp corrente in microsecondi
     * 
     * La misurazione dei tempi del framework richiede una maggiore precisione rispetto alla semplice timestamp in secondi,
     * per questo viene utilizzata la funzione microtime() con il flag true per ottenere la timestamp in microsecondi.
     * 
     * @return      float       la timestamp corrente in microsecondi
     *
     */
    function timerNow() {
        return microtime( true );
    }
    
    /**
     * questa funzione restituisce la differenza in microsecondi fra due timestamp
     * 
     * Molto semplicemente, questa funzione restituisce la differenza in microsecondi fra due timestamp; se il secondo
     * parametro è null viene considerato il momento corrente. È molto utile per ottenere rapidamente un delta tempi
     * rispetto a un tempo dato.
     * 
     * @param       float       $s      la timestamp del momento iniziale rispetto al quale calcolare l'intervallo
     * @param       float       $n      la timestamp corrente
     * 
     * @return      float               la differenza in microsecondi fra $s e $n
     *
     */
    function timerDiff( $s = START_TIME, $n = NULL ) {
        $n = ( $n === NULL ) ? timerNow() : $n;
        return $n - $s;
    }

    /**
     * questa funzione aggiunge un evento a un array di eventi
     * 
     * Questa funzione è pensata per cronometrare le cose, si aspetta in input un array di stringhe che rispettano un formato prestabilito
     * in modo da poter ricavare l'ultimo tempo agevolmente; il formato delle righe è il seguente:
     * 
     *    [T00.000000000000000000000] =>   0.000    (+0.000 XX)    -------N mb → descrizione dell'evento
     * 
     * Da questo formato la funzione è in grado di ricavare il tempo dell'ultimo evento e calcolare il delta con il tempo corrente. Alla
     * fine dopo aver aggiunto i vari tempi si otterrà una cronologia con precisione al millesimo di secondo degli eventi cronometrati. La
     * funzione avvia da sé l'array se non è già stato inizializzato assumendo come zero il momento iniziale.
     * 
     * @param       array       &$a     l'array al quale va aggiunto l'evento
     * @param       string      $c      la descrizione dell'evento
     * 
     * @return      void
     *
     */
    function timerCheck( &$a, $c ) {
        $units = array('b','kb','mb','gb','tb','pb');
        $curTime = timerDiff();
        $lastTime = (( ! empty( $a ) ) ? round( floatval( str_replace( ',', '.', substr( key( array_slice( $a, -1, 1, true ) ), 1 ) ) ), 5 ) : 0.0 );
        $curDelta = ( round( $curTime, 5 ) - $lastTime );
        $curCheck = ( $curDelta < 0.1 ) ? 'OK' : 'NO';
        $curDelta = str_replace(',','.',sprintf( '%0.3f', $curDelta ));
        $curMemory = str_pad( ( @round(memory_get_usage(true)/pow(1024,($i=floor(log(memory_get_usage(true),1024)))),2).' '.$units[$i] ), 11, '-', STR_PAD_LEFT );
        $a[ 'T'.str_replace(',','.',sprintf('%024.21f',$curTime )) ] = 
        str_pad( str_replace(',','.',sprintf( '%0.3f', $curTime )), 7, ' ', STR_PAD_LEFT ) .
        str_pad( '(+' . $curDelta . ' ' . $curCheck . ')', 15, ' ', STR_PAD_LEFT ) .
        str_pad( $curMemory, 15, ' ', STR_PAD_LEFT ) . ' → ' . str_replace( '->', '→', $c );
    }
    
    /**
     * dichiarazione delle costanti di base
     * ====================================
     * Queste costanti sono condivise e utilizzate in tutto il framewor, per questo vengono dichiarate
     * qui; tutte le librerie e il codice del framework presuppone che esse siano presenti per il proprio
     * funzionamento.
     * 
     * nota su DIR_BASE
     * ----------------
     * La costante DIR_BASE viene ricavata sottraendo '_src' dal percorso del file corrente (__DIR__); siccome
     * il file _config.php si trova in _src/ con questa sottrazione otterremo il percorso della document root.
     * 
     * nota su START_TIME
     * ------------------
     * La costante START_TIME contiene il momento di inizio dell'elaborazione; viene utilizzata per calcolare
     * i tempi di esecuzione e per verificare le performances del framework.
     * 
     */

    // questa costante contiene l'istante di inizio dell'elaborazione per controllo performances
    define( 'START_TIME'                                , timerNow() );

    // percorso assoluto della document root del sito
    define( 'DIR_BASE'                                    , str_replace( '_src', '', __DIR__ ) );

    // debug
    // var_dump( __DIR__ );
    // var_dump( DIR_BASE );

    // la directory _etc/ contiene file informativi, liste e dizionari
    define( 'DIR_ETC'                                   , DIR_BASE . '_etc/' );
    define( 'DIR_ETC_COMMON'                            , DIR_BASE . '_etc/_common/' );
    define( 'DIR_ETC_DICTIONARIES'                      , DIR_BASE . '_etc/_dictionaries/' );
    define( 'DIR_ETC_SECURITY'                          , DIR_BASE . '_etc/_security/' );

    // la directory _mod/ contiene i moduli del framework
    define( 'DIR_MOD'                                   , DIR_BASE . '_mod/' );

    // la directory _src/ contiene i sorgenti del framework
    define( 'DIR_SRC'                                   , DIR_BASE . '_src/' );
    define( 'DIR_SRC_API'                               , DIR_BASE . '_src/_api/' );
    define( 'DIR_SRC_API_JOB'                           , DIR_BASE . '_src/_api/_job/' );
    define( 'DIR_SRC_API_PRINT'                         , DIR_BASE . '_src/_api/_print/' );
    define( 'DIR_SRC_API_STATUS'                        , DIR_BASE . '_src/_api/_status/' );
    define( 'DIR_SRC_API_TASK'                          , DIR_BASE . '_src/_api/_task/' );
    define( 'DIR_SRC_API_TASK_REPORT'                   , DIR_BASE . '_src/_api/_task/_report/' );
    define( 'DIR_SRC_API_TASK_STATIC'                   , DIR_BASE . '_src/_api/_task/_static/' );
    define( 'DIR_SRC_CONFIG'                            , DIR_BASE . '_src/_config/' );
    define( 'DIR_SRC_CONFIG_EXT'                        , DIR_BASE . '_src/_config/_ext/' );
    define( 'DIR_SRC_CSS'                               , DIR_BASE . '_src/_css/' );
    define( 'DIR_SRC_HTML'                              , DIR_BASE . '_src/_html/' );
    define( 'DIR_SRC_HTML_BIN'                          , DIR_BASE . '_src/_html/_bin/' );
    define( 'DIR_SRC_HTML_INC'                          , DIR_BASE . '_src/_html/_inc/' );
    define( 'DIR_SRC_IMG'                               , DIR_BASE . '_src/_img/' );
    define( 'DIR_SRC_IMG_BKG'                           , DIR_BASE . '_src/_img/_bkg/' );
    define( 'DIR_SRC_IMG_IT'                            , DIR_BASE . '_src/_img/_it/' );
    define( 'DIR_SRC_IMG_LOGO'                          , DIR_BASE . '_src/_img/_logo/' );
    define( 'DIR_SRC_INC'                               , DIR_BASE . '_src/_inc/' );
    define( 'DIR_SRC_INC_CONTENTS'                      , DIR_BASE . '_src/_inc/_contents/' );
    define( 'DIR_SRC_INC_CONTROLLERS'                   , DIR_BASE . '_src/_inc/_controllers/' );
    define( 'DIR_SRC_INC_MACRO'                         , DIR_BASE . '_src/_inc/_macro/' );
    define( 'DIR_SRC_INC_PAGES'                         , DIR_BASE . '_src/_inc/_pages/' );
    define( 'DIR_SRC_JS'                                , DIR_BASE . '_src/_js/' );
    define( 'DIR_SRC_JS_LIB'                            , DIR_BASE . '_src/_js/_lib/' );
    define( 'DIR_SRC_JS_LIB_EXT'                        , DIR_BASE . '_src/_js/_lib/_ext/' );
    define( 'DIR_SRC_LIB'                               , DIR_BASE . '_src/_lib/' );
    define( 'DIR_SRC_LIB_EXT'                           , DIR_BASE . '_src/_lib/_ext/' );
    define( 'DIR_SRC_SH'                                , DIR_BASE . '_src/_sh/' );
    define( 'DIR_SRC_TEMPLATES'                         , DIR_BASE . '_src/_templates/' );
    define( 'DIR_SRC_TWIG'                              , DIR_BASE . '_src/_twig/' );
    define( 'DIR_SRC_TWIG_BIN'                          , DIR_BASE . '_src/_twig/_lilb/' );
    define( 'DIR_SRC_TWIG_INC'                          , DIR_BASE . '_src/_twig/_inc/' );
    define( 'DIR_SRC_XSL'                               , DIR_BASE . '_src/_xsl/' );

    // la directory _usr/ contiene codice aggiuntivo del framework che non fa parte dell'esecuzione principale
    define( 'DIR_USR'                                   , DIR_BASE . '_usr/' );
    define( 'DIR_USR_DATABASE'                          , DIR_BASE . '_usr/_database/');
    define( 'DIR_USR_DATABASE_PATCH'                    , DIR_BASE . '_usr/_database/_patch/');
    define( 'DIR_USR_DEPLOY'                            , DIR_BASE . '_usr/_deploy/');
    define( 'DIR_USR_DEPLOY_GIT'                        , DIR_BASE . '_usr/_deploy/_git/');
    define( 'DIR_USR_DEPLOY_PHING'                      , DIR_BASE . '_usr/_deploy/_phing/');
    define( 'DIR_USR_DOCS'                              , DIR_BASE . '_usr/_docs/' );
    define( 'DIR_USR_DOCS_BUILD'                        , DIR_BASE . '_usr/_docs/build/' );
    define( 'DIR_USR_DOCS_BUILD_HTML'                    , DIR_BASE . '_usr/_docs/build/html/' );
    define( 'DIR_USR_DOCS_BUILD_LATEX'                    , DIR_BASE . '_usr/_docs/build/latex/' );
    define( 'DIR_USR_DOCS_ETC'                          , DIR_BASE . '_usr/_docs/_etc/' );
    define( 'DIR_USR_DOCS_IMG'                          , DIR_BASE . '_usr/_docs/_img/' );
    define( 'DIR_USR_EXAMPLES'                          , DIR_BASE . '_usr/_examples/' );
    define( 'DIR_USR_EXAMPLES_CONFIG'                   , DIR_BASE . '_usr/_examples/_config/' );
    define( 'DIR_USR_EXAMPLES_CONFIG_APACHE2'           , DIR_BASE . '_usr/_examples/_config/_apache2/' );
    define( 'DIR_USR_EXAMPLES_CONFIG_GIT'               , DIR_BASE . '_usr/_examples/_config/_git/' );
    define( 'DIR_USR_EXAMPLES_CONFIG_JSON'              , DIR_BASE . '_usr/_examples/_config/_json/' );
    define( 'DIR_USR_EXAMPLES_CONFIG_JSON_EXAMPLES'     , DIR_BASE . '_usr/_examples/_config/_json/_examples/' );
    define( 'DIR_USR_EXAMPLES_CONFIG_JSON_TEMPLATES'    , DIR_BASE . '_usr/_examples/_config/_json/_templates/' );
    define( 'DIR_USR_EXAMPLES_CONFIG_PHING'             , DIR_BASE . '_usr/_examples/_config/_phing/' );

    // la directory tmp/ contiene i file temporanei ed è solo custom
    define( 'DIR_TMP'                                    , DIR_BASE . 'tmp/' );

    // la directory var/ e le sue sottocartelle contengono tutti i dati che cambiano nel tempo (log, upload utente, ecc.); è solo custom
    define( 'DIR_VAR'                                    , DIR_BASE . 'var/' );
    define( 'DIR_VAR_CACHE'                                , DIR_BASE . 'var/cache/' );
    define( 'DIR_VAR_CACHE_PAGES'                        , DIR_BASE . 'var/cache/pages/' );
    define( 'DIR_VAR_CACHE_TWIG'                        , DIR_BASE . 'var/cache/twig/' );
    define( 'DIR_VAR_CONTENUTI'                            , DIR_BASE . 'var/contenuti/' );
    define( 'DIR_VAR_IMMAGINI'                            , DIR_BASE . 'var/immagini/' );
    define( 'DIR_VAR_LOG'                                , DIR_BASE . 'var/log/' );
    define( 'DIR_VAR_LOG_CRON'                          , DIR_BASE . 'var/log/cron/' );
    define( 'DIR_VAR_LOG_CSV'                           , DIR_BASE . 'var/log/csv/' );
    define( 'DIR_VAR_LOG_JOB'                           , DIR_BASE . 'var/log/job/' );
    define( 'DIR_VAR_LOG_MYSQL'                         , DIR_BASE . 'var/log/mysql/' );
    define( 'DIR_VAR_LOG_LATEST'                        , DIR_BASE . 'var/log/latest/' );
    define( 'DIR_VAR_LOG_SLOW'                            , DIR_BASE . 'var/log/slow/' );
    define( 'DIR_VAR_LOG_TASK'                          , DIR_BASE . 'var/log/task/' );
    define( 'DIR_VAR_SITEMAP'                            , DIR_BASE . 'var/sitemap/' );
    define( 'DIR_VAR_SPOOL'                                , DIR_BASE . 'var/spool/' );
    define( 'DIR_VAR_SPOOL_CART'                        , DIR_BASE . 'var/spool/cart/' );
    define( 'DIR_VAR_SPOOL_DOCS'                        , DIR_BASE . 'var/spool/docs/' );
    define( 'DIR_VAR_SPOOL_EXPORT'                        , DIR_BASE . 'var/spool/export/' );
    define( 'DIR_VAR_SPOOL_IMPORT'                        , DIR_BASE . 'var/spool/import/' );
    define( 'DIR_VAR_SPOOL_IMPORT_DONE'                    , DIR_BASE . 'var/spool/import/done/' );
    define( 'DIR_VAR_SPOOL_MAIL'                        , DIR_BASE . 'var/spool/mail/' );
    define( 'DIR_VAR_SPOOL_PAYMENT'                        , DIR_BASE . 'var/spool/payment/' );
    define( 'DIR_VAR_SPOOL_PRINT'                        , DIR_BASE . 'var/spool/print/' );
    define( 'DIR_VAR_SPOOL_SECURITY'                    , DIR_BASE . 'var/spool/security/' );
    define( 'DIR_VAR_SPOOL_SIGNUP'                        , DIR_BASE . 'var/spool/signup/' );

    // file autoload per caricare le librerie con composer
    define( 'FILE_AUTOLOAD'                             , DIR_SRC_LIB_EXT . 'autoload.php' );

    // file per le parole e gli hosts bloccati
    define( 'FILE_BANNED_WORDS'                         , DIR_ETC_SECURITY . '_banned.words.conf' );
    define( 'FILE_COMMON_PASSWORDS'                     , DIR_ETC_SECURITY . '_common.passwords.conf' );
    define( 'FILE_BANNED_HOSTS'                         , DIR_VAR_SPOOL_SECURITY . 'banned.hosts.conf' );

    // file che contengono la release e la versione corrente del framework
    define( 'FILE_CURRENT_RELEASE'                        , DIR_ETC . '_current.release' );
    define( 'FILE_CURRENT_VERSION'                        , DIR_ETC . '_current.version' );

    // file di log per l'ultima esecuzione
    define( 'FILE_LATEST_CRON'                            , DIR_VAR_LOG_LATEST . 'cron.latest.log');
    define( 'FILE_LATEST_MYSQL'                            , DIR_VAR_LOG_LATEST . 'mysql.latest.log');
    define( 'FILE_LATEST_RUN'                            , DIR_VAR_LOG_LATEST . 'run.latest.log');
    define( 'FILE_LATEST_SITEMAP'                        , DIR_VAR_LOG_LATEST . 'sitemap.latest.log');

    // file per il controllo dell'aggiornamento
    define( 'FILE_LATEST_RELEASE'                        , path2custom( DIR_VAR ) . 'latest.release.conf' );
    define( 'FILE_LATEST_UPGRADE'                       , path2custom( DIR_VAR ) . 'latest.upgrade.conf' );
    define( 'FILE_LATEST_VERSION'                        , path2custom( DIR_VAR ) . 'latest.version.conf' );

    // file licenza
    define( 'FILE_LICENSE'                                , DIR_BASE . 'LICENSE.md' );

    // file per testo di prova
    define( 'FILE_LOREM'                                , DIR_ETC_COMMON . '_lorem.conf' );

    // file della documentazione
    define( 'FILE_MANUAL_HTML'                            , DIR_USR_DOCS_BUILD_HTML . 'index.html' );
    define( 'FILE_MANUAL_PDF'                            , DIR_USR_DOCS_BUILD_LATEX . 'refman.pdf' );

    // configurazioni aggiuntive
    define( 'FILE_REDIRECT'                                , path2custom( DIR_ETC ) . 'redirect.csv' );

    // stato del login
    define( 'LOGIN_ERR_NO_DATA'                         , 'NODATA' );
    define( 'LOGIN_ERR_NO_CONNECTION'                   , 'NOCONNECTION' );
    define( 'LOGIN_ERR_NO_USER'                         , 'NOUSER' );
    define( 'LOGIN_ERR_WRONG_PW'                        , 'WRONGPW' );
    define( 'LOGIN_ERR_INACTIVE'                        , 'USERDOWN' );
    define( 'LOGIN_SUCCESS'                             , 'SUCCESS' );
    define( 'LOGIN_LOGGED'                              , 'LOGGED' );
    define( 'LOGIN_LOGOUT'                              , 'LOGOUT' );

    // livelli di controllo
    define( 'CONTROL_FILTERED'                            , 'FILTERED' );
    define( 'CONTROL_FULL'                                , 'FULL' );

    // azioni
    define( 'METHOD_DELETE'                                , 'DELETE' );       // cancellazione
    define( 'METHOD_GET'                                , 'GET' );          // lettura
    define( 'METHOD_PATCH'                                , 'PATCH' );        // aggiornamento
    define( 'METHOD_POST'                                , 'POST' );         // inserimento
    define( 'METHOD_PUT'                                , 'PUT' );          // modifica
    define( 'METHOD_REPLACE'                            , 'REPLACE' );      // rimpiazzo
    define( 'METHOD_UPDATE'                                , 'UPDATE' );       // aggiornamento

    // costanti per l'identificazione dei database
    define( 'DB_MYSQL'                                    , 'MYSQL' );
    define( 'DB_POSTGRESQL'                                , 'PGSQL' );
    define( 'DB_MSSQL'                                    , 'MSSQL' );

    // costanti che descrivono lo stato dell'output buffering
    define( 'OB_NON_ATTIVO'                                , 'NOOB'  );
    define( 'OB_ATTIVO'                                    , 'OB' );
    define( 'OB_ATTIVO_CON_GZIP'                        , 'OBGZ' );

    // costanti che descrivono il backend per le sessioni
    define( 'SESSION_APACHE'                            , 'SESS_APACHE'  );
    define( 'SESSION_FILESYSTEM'                        , 'SESS_FS'  );
    define( 'SESSION_REDIS'                                , 'SESS_REDIS' );
    define( 'SESSION_MEMCACHE'                            , 'SESS_MEMCACHE' );

    // costanti per il contenuto
    define( 'MIME_APPLICATION_JSON'                        , 'application/json' );
    define( 'MIME_APPLICATION_XML'                        , 'application/xml' );
    define( 'MIME_MULTIPART_FORM_DATA'                    , 'multipart/form-data' );
    define( 'MIME_TEXT_PLAIN'                            , 'text/plain' );
    define( 'MIME_TEXT_HTML'                            , 'text/html' );
    define( 'MIME_X_WWW_FORM_URLENCODED'                , 'application/x-www-form-urlencoded' );

    // costanti per la visualizzazione
    define( 'SHOW_ALWAYS'                               , 'SHOW_ALWAYS' );

    // costanti per l'encoding
    define( 'ENCODING_UTF8'                                , 'utf-8' );

    // costanti per l'I/O
    define( 'PHP_INPUT'                                 , 'php://input' );

    /**
     * inizializzazione dei log latest
     * ===============================
     * I file di log latest sono file di testo che contengono tutti i messaggi importanti relativi all'ultima esecuzione;
     * sono più dettagliati dei file di log normali e vengono utilizzati per il debug di fino dell'esecuzione del framework.
     * I file latest principali sono:
     * 
     * - var/log/latest/cron.latest.log
     * - var/log/latest/run.latest.log
     * - var/log/latest/mysql.latest.log
     * - var/log/latest/sitemap.latest.log
     * 
     * Per ulteriori dettagli sui latest log si veda la descrizione della funzione loggerLatest().
     * 
     */

    // stringa di inizializzazione
    $latestLogHeader = date( 'Y-m-d H:i:s' ) . ' ' . $_SERVER['REMOTE_ADDR'] . ' ' . $_SERVER['REDIRECT_URL'] . ' -> ' .$_SERVER['REQUEST_URI'] . PHP_EOL;

    // inizializzazione del file cron.latest.log
    loggerLatest( $latestLogHeader, FILE_LATEST_CRON, 'w+' );

    // inizializzazione del file run.latest.log
    loggerLatest( $latestLogHeader, FILE_LATEST_RUN, 'w+' );

    // inizializzazione del file mysql.latest.log
    loggerLatest( $latestLogHeader, FILE_LATEST_MYSQL, 'w+' );

    // inizializzazione del file sitemap.latest.log
    loggerLatest( $latestLogHeader, FILE_LATEST_SITEMAP, 'w+' );

    /**
     * registrazione dell'accesso
     * ==========================
     * 
     * 
     */

    // registrazione dell'accesso al framework con PID di Apache
    logger( 'PID: ' . getmypid() . ' da ' . $_SERVER['REMOTE_ADDR'] . ' ' . $_SERVER['REDIRECT_URL'] . ' -> ' . $_SERVER['REQUEST_URI'], 'access' );

    /**
     * inizializzazione dell'array di configurazione principale
     * ========================================================
     * Tutte le informazioni di configurazione e di lavoro del framework sono contenute nell'array associativo multidimensionale $cf.
     * Questo array viene popolato in due modi:
     * 
     * - file PHP standard (_scr/_config/_<stage>.<factory>.php) e controparte moduli (_mod/_<modulo>/_src/_config/_<stage>.<factory>.php)
     * - file PHP custom (src/config/<stage>.<factory>.php) e controparte moduli (mod/<modulo>/src/config/<stage>.<factory>.php)
     * 
     */

    // inizializzazione dell'array $cf
    if( ! isset( $cf ) ) {
        $cf = array();
    }

    /**
     * inizializzazione dell'array dei tempi di esecuzione
     * ===================================================
     * Questo array contiene tutti i tempi di esecuzione del framework, per scopo di debug e controllo performance. Per ulteriori
     * informazioni sul formato delle stringhe contenute nell'array si veda la documentazione della funzione timerCheck().
     * 
     */

    // inizializzazione dell'array $cf['speed']
    $cf['speed'] = array();

    /**
     * verifica dei requisiti dell'ambiente
     * ====================================
     * In questa sezione viene controllato che l'ambiente sia configurato correttamente e che tutti i requisiti minimi per il
     * funzionamento del framework siano soddisfatti.
     * 
     * inizializzazione dell'array dei requisiti dell'ambiente
     * -------------------------------------------------------
     * Questo array contiene i moduli di PHP necessari all'esecuzione del framework. Si tenga presente che GlisWeb dipende fortemente
     * da Composer, quindi oltre a sincerarsi di avere l'ambiente correttamente configurato è anche importante assicurarsi che
     * le librerie esterne siano installate e aggiornate. Sostanzialmente è sufficiente eseguire nella document root del deploy
     * i seguenti comandi:
     * 
     * ```
     * composer update
     * composer suggests | xargs -i composer require {}
     * ```
     * 
     * versioni di Debian
     * ------------------
     * Raccomandiamo di installare GlisWeb su Debian stable, per garantiere la massima compatibilità e sicurezza; tutti gli script di
     * amministrazione sono pensati per Debian e Ubuntu, quindi è possibile che su altre distribuzioni Linux o sistemi operativi non
     * funzionino correttamente - anche se si tratta di una funzionalità aggiuntiva, può semplificare parecchio la manutenzione quindi
     * consigliamo di non sottovalutarla.
     * 
     * versione | nome          | architetture              | supporto                  | tipo di supporto
     * ---------|---------------|---------------------------|---------------------------|-----------------------
     * 6        | Squeeze       | i386, amd64               | 02/06/2014 - 29/02/2016   | EOL
     * 7        | Wheezy        | i386, amd64, armel, armhf | 26/04/2016 - 31/05/2018   | EOL
     * 8        | Jessie        | i386, amd64, armel, armhf | 17/06/2018 - 30/06/2020   | EOL
     * 9        | Stretch       | i386, amd64, armel, armhf | 06/07/2020 - 30/06/2022   | EOL
     * 10       | Buster        | i386, amd64, armhf, arm64 | 01/08/2022 - 30/06/2024   | LTS
     * 11       | Bullseye      | i386, amd64, armhf, arm64 | 15/08/2024 - 30/06/2026   | future LTS
     * 12       | Bookworm      | i386, amd64, armhf, arm64 | 11/06/2026 - 30/06/2028   | future LTS
     * 
     * Vedi https://wiki.debian.org/LTS.
     * 
     * versioni di PHP
     * ---------------
     * Il framework cerca di mantenere la massima retrocompatibilità possibile, entro i limiti concessi dalla necessità di garantire
     * la sicurezza delle applicazioni.
     * 
     * versione | rilascio          | fine supporto         | supporto da GlisWeb
     * ---------|-------------------|-----------------------|-----------------------------------
     * 7.0      | 3 dicembre 2015   | 3 dicembre 2018       | deprecata
     * 7.1      | 1 dicembre 2016   | 1 dicembre 2019       | deprecata
     * 7.2      | 30 novembre 2017  | 30 novembre 2020      | deprecata
     * 7.3      | 6 dicembre 2018   | 6 dicembre 2021       | deprecata
     * 7.4      | 28 novembre 2019  | 28 novembre 2022      | deprecata
     * 8.0      | 26 novembre 2020  | 26 novembre 2023      | supportata
     * 8.1      | 25 novembre 2021  | 25 novembre 2024      | supportata
     * 8.2      | 8 dicembre 2022   | 8 dicembre 2025       | supportata
     * 8.3      | 23 novembre 2023  | 23 novembre 2026      | non testata
     * 
     * Vedi https://www.php.net/supported-versions.php.
     * 
     */

    // versione di PHP richiesta
    $cf['php']['required']['version'] = '7.0.0';       // rilasciata il 26 settembre 2019, fine supporto il 28 novembre 2022

    // versione di PHP suggerita
    $cf['php']['preferred']['version'] = '8.2.0';       // rilasciata l'8 dicembre 2022

    // moduli di PHP richiesti
    $cf['php']['required']['extensions'] = array(
        'curl',                                         // necessario per le chiamate REST
        'fileinfo',                                     // necessario per il recupero delle informazioni sui file
        'gd',                                           // necessario per la manipolazione delle immagini
        'json',                                         // necessario per la gestione dei dati in formato JSON
        'mysqli',                                       // necessario per la connessione ai database MySQL
        'redis',                                        // necessario per la connessione ai cache server Redis
        'tidy',                                         // necessario per la pulizia del codice HTML
        'yaml',                                         // necessario per la gestione dei dati in formato YAML
        'zip',                                          // necessario per la gestione dei file compressi in formato ZIP
        'memcached'                                     // necessario per la connessione ai cache server Memcached
    );

    // moduli di Apache2 richiesti
    $cf['apache']['required']['modules'] = array(
        'core',                                         // modulo core
        'mod_deflate',                                  // necessario per la compressione gzip
        'mod_expires',                                  // necessario per la gestione della cache lato client
        'mod_headers',                                  // necessario per la gestione degli header HTTP
        'mod_rewrite',                                  // necessario per il rewrite degli URL
        'mod_ssl'                                       // necessario per la gestione delle connessioni sicure
    );

    /**
     * esecuzione delle verifiche
     * --------------------------
     * Verifico che tutti i requisiti minimi per il funzionamento del framework siano soddisfatti.
     * 
     */

    // controllo che la versione di PHP installata sia uguale o superiore a quella richiesta
    if( version_compare( PHP_VERSION, $cf['php']['required']['version'], '<' ) ) {
        die( 'la versione di PHP installata ('.PHP_VERSION.') è inferiore a quella richiesta ('.$cf['php']['required']['version'].')' );
    }

    // controllo che tutti i moduli di PHP necessari siano installati
    $cf['php']['required']['differences'] = array_diff( $cf['php']['required']['extensions'], get_loaded_extensions() );
    if( count( $cf['php']['required']['differences'] ) > 0 ) {
        die( 'alcuni moduli di PHP necessari non sono installati ('.implode( ', ', $cf['php']['required']['differences'] ).'), lanciare _lamp.setup.sh' );
    }

    // controllo che tutti i moduli di Apache necessari siano installati e attivi
    $cf['apache']['required']['differences'] = array_diff( $cf['apache']['required']['modules'], apache_get_modules() );
    if( count( $cf['apache']['required']['differences'] ) > 0 ) {
        die( 'alcuni moduli di PHP necessari non sono installati ('.implode( ', ', $cf['apache']['required']['differences'] ).'), lanciare _lamp.setup.sh' );
    }

    // controllo che le cartelle necessarie al funzionamento del framework esistano
    foreach( array( DIR_VAR, DIR_VAR_LOG, DIR_VAR_SITEMAP, DIR_TMP ) as $folder ) {
        if( checkPath( $folder ) == false ) {
            die( 'impossibile creare la cartella ' . $folder . ', lanciare _lamp.permissions.open.sh' );
        }
    }

    // controllo che il framework possa scrivere sulle cartelle necessarie al suo funzionamento
    foreach( array( DIR_VAR, DIR_VAR_LOG, DIR_VAR_SITEMAP, DIR_TMP ) as $folder ) {
        if( ! is_writeable( $folder ) ) {
            die( 'la cartella ' . $folder . ' non è scrivibile, lanciare _lamp.permissions.secure.sh' );
        }
    }

    // controllo che la document root NON sia scrivibile
    if( is_writeable( DIR_BASE ) ) {
        die( 'la cartella di installazione è scrivibile, lanciare _lamp.permissions.secure.sh' );
    }

    // timer
    timerCheck( $cf['speed'], 'fine verifica requisiti ambiente' );

    // debug
    // die( print_r( apache_get_modules(), true ) );

    /**
     * inizializzazione dell'array di configurazione per il template manager
     * =====================================================================
     * Per evitare che dati importanti contenuti in $cf vengano esposti tramite il template manager, passiamo a quest'ultimo un sotto
     * insieme delle chiavi presenti in $cf; questo sotto insieme è l'array $ct-
     * 
     */

    // inizializzazione dell'array $ct
    if( ! isset( $ct ) ) {
        $ct = array();
    }

    /**
     * inclusione del firewall applicativo
     * ===================================
     * GlisWeb dispone di un basilare firewall applicativo (WAF) che filtra la $_REQUEST bloccando determinati indirizzi IP
     * e determinate parole; per ulteriori dettagli si veda la documentazione del file _src/_inc/_macro/_security.php
     * 
     */

    // filtro di sicurezza
    require DIR_SRC_INC_MACRO . '_security.php';

    // timer
    timerCheck( $cf['speed'], 'fine esecuzione firewall applicativo' );

    /**
     * inizializzazione del generatore di numeri casuali
     * =================================================
     * il motore di numeri casuali va inizializzato con un numero in modo da produrre risultati il più possibile casuali
     * vedi https://www.php.net/manual/en/function.mt-srand.php
     * 
     */

    // inizializzazione motore numeri casuali
    mt_srand( ( double ) microtime() * 1000000 );

    // timer
    timerCheck( $cf['speed'], 'fine inizializzazione motore numeri casuali' );

    /**
     * avvio dell'output buffering
     * ===========================
     * L'output buffering è una tecnica per cui l'output viene stoccato in un buffer per poi essere
     * inviato tutto in una volta, eventualmente compresso, al client. Per ulteriori informazioni
     * si veda https://www.php.net/outcontrol
     *
     */

    // avvio dell'output buffer con compressione gzip se possibile, senza altrimenti
    if( ob_start( 'ob_gzhandler' ) ) {
        $cf['ob']['status']            = OB_ATTIVO_CON_GZIP;
    } elseif( ob_start() ) {
        $cf['ob']['status']            = OB_ATTIVO;
    } else {
        $cf['ob']['status']            = OB_NON_ATTIVO;
    }

    // timer
    timerCheck( $cf['speed'], 'fine avvio output buffering' );

    /** 
     * lettura dei file di configurazione Json/Yaml
     * ============================================
     * Esistono due livelli di configurazione tramite JSON/YAML, il secondo pensato per la configurazione dinamica
     * in ambiente containerizzato:
     *
     * - file di configurazione JSON/YAML (src/config.json o src/config.yaml)
     * - file di configurazione esterno JSON/YAML (src/config/ext/config.json o src/config/ext/config.yaml)
     * 
     * NOTA l'attuale strategia per unire il contenuto di più file di configurazione è array_replace_recursive() ma
     * in precedenza era array_merge_recursive(); è stata cambiata perché array_merge_recursive() non gestisce la
     * sovrapposizione delle chiavi numeriche, e il problema è che questo comportamento a volte è quello voluto e a
     * volte no; per ora teniamo array_replace_recursive() ma in caso di comportamenti anomali delle chiavi
     * numeriche bisogna tenere conto che il problema potrebbe essere qui.
     * 
     * protezione di username, password e altri dati sensibili
     * -------------------------------------------------------
     * Per evitare che password e altri dati sensibili vengano pubblicati sui repository, il framework prevede la
     * possibilità di creare oltre ai file config.json e config.yaml anche i file shadow.json e shadow.yaml; questi
     * file sono esclusi tramite .gitignore e vengono letti in aggiunta ai file di configurazione standard
     * sovrascrivendo i valori corrispondenti.
     * 
     */

    /** 
     * inizializzazione dell'array di configurazione esteso
     * ----------------------------------------------------
     * L'array $cx ha una struttura analoga e sovrapponibile all'array $cf (vedi sotto), e viene ricavato dai file
     * JSON o YAML di configurazione, per poi essere sovrapposto alle analoghe strutture dell'array $cf; in pratica
     * rende possibile la configurazione del framework tramite file di configurazione JSON/YAML.
     * 
     */

    // inizializzazione dell'array $cx
    if( ! isset( $cx ) ) {
        $cx = array();
    }

    /**
     * lettura dei file di configurazione
     * ----------------------------------
     * A questo punto il contenuto dei file di configurazione aggiuntivi viene letto e aggiunto all'array $cx.
     * 
     */

    // file di configurazione da considerare nell'ordine
    $cf['config']['files']['yaml'][]    = path2custom( DIR_SRC_CONFIG_EXT . 'config.yaml' );
    $cf['config']['files']['yaml'][]    = path2custom( DIR_SRC_CONFIG_EXT . 'shadow.yaml' );
    $cf['config']['files']['yaml'][]    = path2custom( DIR_SRC . 'config.yaml' );
    $cf['config']['files']['yaml'][]    = path2custom( DIR_SRC . 'shadow.yaml' );
    $cf['config']['files']['json'][]    = path2custom( DIR_SRC_CONFIG_EXT . 'config.json' );
    $cf['config']['files']['json'][]    = path2custom( DIR_SRC_CONFIG_EXT . 'shadow.json' );
    $cf['config']['files']['json'][]    = path2custom( DIR_SRC . 'config.json' );
    $cf['config']['files']['json'][]    = path2custom( DIR_SRC . 'shadow.json' );

    // lettura del file di configurazione aggiuntivi YAML o JSON
    foreach( $cf['config']['files'] as $type => $files ) {
        foreach( $files as $file ) {
            if( file_exists( $file ) ) {
                switch( $type ) {
                    case 'yaml':
                        $cj = yaml_parse( file_get_contents( $file ) );
                    break;
                    case 'json':
                        $cj = json_decode( file_get_contents( $file ), true );
                    break;
                }
                if( empty( $cj ) ) {
                    die( 'file di configurazione ' . $file . ' danneggiato' );
                } else {
                    $cx = array_replace_recursive( $cx, $cj );
                }
            }
        }
    }

    // timer
    timerCheck( $cf['speed'], 'fine parsing dei file di configurazione' );

    /**
     * individuazione dei moduli attivi
     * ================================
     * I moduli attivi vengono individuati tramite due strategie mutuamente esclusive:
     * 
     * - dichiarazione esplicita di mods->active->array nei file di configurazione JSON/YAML
     * - presenza di una sotto cartella con il nome del modulo nella cartella mod/
     * 
     * L'elenco dei moduli attivi si viene alla fine a trovare in $cf['mods']['active']['array'] e
     * a partire da questo array viene poi creato l'elenco statico $cf['mods']['active']['string']
     * 
     */

    // array dei moduli attivi
    if( isset( $cx['mods']['active']['array'] ) ) {
        $cf['mods']['active']['array']    = $cx['mods']['active']['array'];
    } elseif( file_exists( path2custom( DIR_MOD ) ) ) {
        $cf['mods']['active']['array']    = scandir2array( path2custom( DIR_MOD ) );
    } else {
        $cf['mods']['active']['array']    = array();
    }

    // stringa dei moduli attivi
    $cf['mods']['active']['string']                    = implode( ',', $cf['mods']['active']['array'] );

    // moduli attivi
    define( 'MODULI_ATTIVI'                            , $cf['mods']['active']['string'] );
    define( 'DIR_MOD_ATTIVI'                        , DIR_MOD . '_{' . MODULI_ATTIVI . '}/' );
    define( 'DIR_MOD_ATTIVI_SRC_API_JOB'            , DIR_MOD_ATTIVI . '_src/_api/_job/' );
    define( 'DIR_MOD_ATTIVI_SRC_API_TASK'            , DIR_MOD_ATTIVI . '_src/_api/_task/' );
    define( 'DIR_MOD_ATTIVI_SRC_INC_CONTROLLERS'    , DIR_MOD_ATTIVI . '_src/_inc/_controllers/' );
    define( 'DIR_MOD_ATTIVI_SRC_INC_MACRO'            , DIR_MOD_ATTIVI . '_src/_inc/_macro/' );
    define( 'DIR_MOD_ATTIVI_SRC_LIB'                , DIR_MOD_ATTIVI . '_src/_lib/' );
    define( 'DIR_MOD_ATTIVI_ETC_DICTIONARIES'       , DIR_MOD_ATTIVI . '_etc/_dictionaries/' );

    // collego $ct
    $ct['mods']                                        = &$cf['mods'];

    // timer
    timerCheck( $cf['speed'], 'fine scansione dei moduli attivi' );

    /**
     * inclusione dei file di libreria
     * ===============================
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
     */

    // ricerca dei file di libreria
    $arrayLibrerieBase          = glob( DIR_SRC_LIB . '_*.*.php' );
    $arrayLibrerieModuli        = glob( DIR_MOD_ATTIVI_SRC_LIB . '_*.*.php', GLOB_BRACE );
    $cf['library']['files']     = array_unique( array_merge( $arrayLibrerieBase , $arrayLibrerieModuli ) );

    // inclusione dei files di libreria
    foreach( $cf['library']['files'] as $libreria ) {
        $locale = path2custom( $libreria );
        $aggiuntiva = str_replace( '.php', '.add.php', $locale );
        if( file_exists( $locale ) ) {
            require $locale;
            timerCheck( $cf['speed'], $locale );
        } else {
            require $libreria;
            timerCheck( $cf['speed'], $libreria );
        }
        if( file_exists( $aggiuntiva ) ) {
            require $aggiuntiva;
            timerCheck( $cf['speed'], $aggiuntiva );
        }
    }

    // timer
    timerCheck( $cf['speed'], 'fine inclusione files di libreria' );

    /**
     * inclusione dei file di libreria esterni
     * =======================================
     * Il framework gestisce le librerie esterne tramite composer; le librerie vengono installate
     * nella sottocartella _src/_lib/_external/ che sostituisce la classica cartella vendor/ di
     * composer in modo da semplificarne la distribuzione tramite FTP.
     * 
     * librerie esterne utilizzate dal framework
     * -----------------------------------------
     * 
     * TODO documentare con una tabella le librerie esterne (vedi composer.json)
     * 
     */

    // inclusione delle librerie esterne
    if( file_exists( FILE_AUTOLOAD ) ) {
        require FILE_AUTOLOAD;
        timerCheck( $cf['speed'], FILE_AUTOLOAD );
    } else {
        die( 'autoload mancante, eseguire composer update' );
    }

    /**
     * inclusione dei files dei runlevel
     * =================================
     * Per l'inclusione dei files dei runlevels viene utilizzata una strategia differente rispetto
     * a quella utilizzata per le librerie; se il file locale è presente, questo viene incluso dopo
     * il file standard.
     *
     * Questo significa che se si desidera modificare il valore di una o più variabili presenti in
     * un file dei runlevels standard non è necessario copiare in locale tutte le variabili presenti
     * in standard, ma soltanto quelle modificate. Non è ovviamente possibile ridefinire in questo
     * modo le costanti.
     *
     * La struttura dei file dei runlevels costituisce l'impalcatura del framework; vengono cercati
     * tutti i file presenti nella sottocartella _src/_config/ e nella sua controparte custom src/config/
     * in ordine per nome di file; per questa ragione i file dei runlevels iniziano con un numero,
     * per garantirne l'esecuzione in ordine controllato.
     *
     * Il framework utilizza due array principali per archiviare la configurazione. L'array $cf contiene
     * i dati visibili soltanto al framework, mentre l'array $ct condiene una copia di parte dell'array $cf
     * e viene passato a eventuali template manager per la costruzione delle pagine. Questo argomento
     * viene approfondito più avanti.
     *
     * organizzazione dei file dei runlevel
     * ------------------------------------
     * I files dei runlevels del framework sono suddivisi in sezioni (runlevels) identificate dalla cifra delle
     * centinaia, come si vede nella seguente tabella:
     *
     * sezione     | descrizione
     * ------------|---------------------------------------------------------------------------------------------
     * 000         | configurazioni iniziali del framework e del deploy corrente
     * 100         | configurazioni delle sorgenti dati (database, ecc.)
     * 200         | configurazioni relative al login agli utenti, all'utente corrente e ai permessi
     * 300         | configurazioni relative alle pagine del sito
     * 400         | configurazioni relative all'URL rewriting
     * 500         | configurazioni relative alla comunicazione con i servizi esterni (posta, ecc.)
     * 600         | configurazioni relative a piattaforme di terze parti
     * 700         | configurazioni relative all'importazione, all'elaborazione e all'esportazione dei dati
     * 800         | -
     * 900         | configurazioni varie (sitemap, privacy, debug...)
     *
     * factory dei file dei runlevel
     * -----------------------------
     * I file dei runlevels sono raggruppati, oltre che in runlevel, in factory che ne determinano il ruolo:
     * 
     * factory      | descrizione
     * -------------|---------------------------------------------------------------------------------------
     * debug        | configurazioni relative al debug e allo sviluppo
     * site         | configurazioni relative ai siti e al sito corrente
     * 
     * ordine di inclusione dei files dei runlevel
     * -------------------------------------------
     * I file dei runlevels vengono inclusi nell'ordine indicato dal nome, con precedenza ai file
     * standard in modo da dare la possibilità ai file custom di ridefinire i valori standard, e con
     * priorità al modulo base rispetto ai moduli aggiuntivi per dare la possibilità ai moduli aggiuntivi
     * di ridefinire i valori base. Ricapitolando l'ordine è:
     * 
     * - file standard base
     * - file custom base
     * - file standard moduli
     * - file custom moduli
     * 
     * Comprendere l'ordine in cui vengono inclusi i file è essenziale per poter customizzare il framework,
     * quindi si consiglia di prestare particolare attenzione a questa sezione.
     *
     */

    // richiesta esplicita di esecuzione runlevel
    if( isset( $cf['runlevels']['run'] ) ) {
        $lvls2run = '{' . implode( ',', $cf['runlevels']['run'] ) . '}*';
    } else {
        $lvls2run = '*';
    }

    // filtri per runlevels
    if( ! isset( $cf['lvls']['skip'] ) ) {
        $cf['lvls']['skip'] = array();
    }

    // ricerca dei files dei runlevels standard
    $cf['runlevel']['files'] = glob( DIR_SRC_CONFIG . '_' . $lvls2run . '.*.php', GLOB_BRACE );

    // ordinamento dei file trovati
    sort( $cf['runlevel']['files'] );

    // inclusione dei files dei runlevels
    foreach( $cf['runlevel']['files'] as $file ) {

        // controparte locale
        $locale = path2custom( $file );

        // calcolo runlevel
        $lvls = explode( '.', basename( $locale ) );
        $lvl = array_shift( $lvls );

        // salto i runlevel specificati
        if( ! in_array( $lvl, $cf['lvls']['skip'] ) ) {

            // inclusione file standard
            require $file;
            timerCheck( $cf['speed'], $file );
            loggerLatest( 'completato: ' . $file );

            // inclusione file locale
            if( file_exists( $locale ) ) {
                require $locale;
                timerCheck( $cf['speed'], $locale );
                loggerLatest( 'completato: ' . $locale );
            }

            // controparte moduli
            $moduli = glob( str_replace( DIR_BASE, DIR_MOD_ATTIVI, $file ), GLOB_BRACE );

            // inclusione controparte moduli
            foreach( $moduli as $modulo ) {

                // inclusione file di modulo
                require $modulo;
                timerCheck( $cf['speed'], $modulo );
                loggerLatest( 'completato: ' . $modulo );

                // controparte modulo locale
                $locale = path2custom( $modulo );

                // inclusione controparte modulo locale
                if( file_exists( $locale ) ) {
                    require $locale;
                    timerCheck( $cf['speed'], $locale );
                    loggerLatest( 'completato: ' . $locale );
                }

            }

        }

    }

    // timer
    timerCheck( $cf['speed'], 'fine inclusione dei file dei runlevel' );
