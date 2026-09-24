<?php

    /**
     * libreria di funzioni di supporto per MySQL
     *
     * Questa libreria contiene le funzioni con cui il framework parla con il database: l'esecuzione delle query, semplici o
     * preparate, la loro cache su memcache, le scorciatoie per leggere un valore, una riga o una colonna, e alcune operazioni
     * composte sui record ( inserimento, duplicazione e cancellazione ricorsiva ) e sulle viste statiche.
     *
     * introduzione
     * ============
     * Tutto l'accesso al database del framework passa di qui: le funzioni ricevono la connessione mysqli come parametro ( di
     * solito $cf['mysql']['connection'] ) e non leggono la configurazione globale, con le sole eccezioni di
     * memcacheCleanFromIndex() chiamata da mysqlInsertRow() e della chiave $cf['controller']['no_id_inline'] usata da
     * refreshStaticView(). Il punto d'ingresso è mysqlQuery(), che in base al primo comando della query decide cosa
     * restituire ( le righe per una SELECT, l'ID per una INSERT, il numero di righe coinvolte per UPDATE e DELETE ) e
     * restituisce false in caso di errore; tutte le altre funzioni sono costruite sopra di essa.
     *
     * Come di consueto le funzioni della libreria sono raggruppate per area tematica.
     *
     * prepared statements
     * -------------------
     * Se a mysqlQuery() viene passato un array di parametri non vuoto la query viene eseguita come prepared statement da
     * mysqlPreparedQuery(). I parametri sono un array di array, ciascuno con una sola chiave che indica il tipo mysqli del
     * valore ( 's' per stringa, 'i' per intero, 'd' per decimale, 'b' per blob ) e il valore stesso, nell'ordine dei
     * segnaposto ? della query:
     *
     * ```
     * mysqlQuery(
     *     $cf['mysql']['connection'],
     *     'SELECT * FROM anagrafica WHERE id = ? AND nome = ?',
     *     array(
     *         array( 's' => $id ),
     *         array( 's' => $nome )
     *     )
     * );
     * ```
     *
     * In pratica il framework usa quasi sempre il tipo 's' anche per i numeri, lasciando a MySQL la conversione. Le chiavi
     * dell'array esterno non contano per il bind ma possono contare per il valore di ritorno: array2mysqlStatementParameters()
     * le usa per i nomi delle colonne, e per una INSERT senza ID generato mysqlPreparedQuery() restituisce il valore della
     * chiave 'id'.
     *
     * cache delle query
     * -----------------
     * Le funzioni con Cached nel nome prendono come primo parametro la connessione a memcache e cercano il risultato in cache
     * prima di interrogare il database; la chiave di cache è 'MYSQL_' seguito dall'MD5 della query e dei parametri. Se si
     * usa mysqlCachedIndexedQuery() la chiave viene anche registrata nell'indice delle tabelle coinvolte nella query
     * ( $cf['memcache']['index'] ), che mysqlInsertRow() usa tramite memcacheCleanFromIndex() per invalidare le query in
     * cache quando una tabella viene scritta; le query messe in cache senza indice scadono solo per TTL. Esiste anche una
     * cache su disco, mysqlDiskQuery(), che al momento non viene usata da nessuna parte del framework.
     *
     * costanti
     * ========
     * Questa libreria non definisce costanti; usa quelle definite altrove nel framework e riportate nella seguente tabella.
     *
     * costante                     | spiegazione
     * -----------------------------|--------------------------------------------------------------
     * MEMCACHE_DEFAULT_TTL         | durata di default delle chiavi in cache ( _src/_config/_045.cache.php )
     * FILE_LATEST_MYSQL            | file in cui loggerLatest() scrive l'ultima query eseguita
     * DIR_BASE                     | radice del deploy, usata da mysqlDiskQuery() per la cache su disco
     *
     * funzioni
     * ========
     * Le funzioni di questa libreria sono divise in gruppi in base al lavoro che svolgono; nei paragrafi successivi le
     * analizzeremo nel dettaglio.
     *
     * funzioni per la cache delle query
     * ---------------------------------
     * Le funzioni in questo gruppo eseguono le query passando per la cache, su memcache o su disco.
     *
     * funzione                                 | descrizione
     * -----------------------------------------|---------------------------------------------------------------
     * mysqlGetQueryTables()                    | restituisce le tabelle coinvolte in una query
     * mysqlCachedIndexedQuery()                | esegue una query con cache su memcache registrandola nell'indice delle tabelle
     * mysqlCachedQuery()                       | esegue una query con cache su memcache
     * mysqlDiskQuery()                         | esegue una query con cache su disco
     *
     * funzioni di esecuzione delle query
     * ----------------------------------
     * Le funzioni in questo gruppo eseguono le query sul database e ne raccolgono il risultato.
     *
     * funzione                                 | descrizione
     * -----------------------------------------|---------------------------------------------------------------
     * mysqlQuery()                             | esegue una query sul database
     * mysqlFetchResult()                       | trasforma il risultato di una query semplice in un array di righe
     * mysqlPreparedQuery()                     | esegue una query come prepared statement
     * mysqlFetchPreparedResult()               | trasforma il risultato di un prepared statement in un array di righe
     *
     * funzioni di selezione
     * ---------------------
     * Le funzioni in questo gruppo sono scorciatoie per leggere dal database un valore, una riga o una colonna.
     *
     * funzione                                 | descrizione
     * -----------------------------------------|---------------------------------------------------------------
     * mysqlSelectValue()                       | restituisce il primo valore della prima riga di una query
     * mysqlSelectColumn()                      | restituisce una colonna del risultato di una query
     * mysqlSelectCachedColumn()                | restituisce una colonna del risultato di una query, con cache
     * mysqlSelectRow()                         | restituisce la prima riga del risultato di una query
     * mysqlSelectCachedValue()                 | restituisce il primo valore della prima riga di una query, con cache
     * mysqlSelectCachedRow()                   | restituisce la prima riga del risultato di una query, con cache
     *
     * funzioni di manipolazione dei record
     * ------------------------------------
     * Le funzioni in questo gruppo inseriscono, duplicano e cancellano record, anche seguendo le chiavi esterne.
     *
     * funzione                                 | descrizione
     * -----------------------------------------|---------------------------------------------------------------
     * mysqlDuplicateRowRecursive()             | effettua la duplicazione ricorsiva di un oggetto e degli eventuali oggetti figli nelle tabelle correlate
     * mysqlDuplicateRow()                      | duplica una riga di una tabella
     * mysqlDeleteRowRecursive()                | cancella una riga e, a cascata, le righe che la referenziano
     * mysqlInsertRow()                         | inserisce o aggiorna una riga a partire da un array associativo
     *
     * funzioni per la composizione delle query
     * ----------------------------------------
     * Le funzioni in questo gruppo servono a costruire pezzi di query a partire da array associativi, o a spezzare testo SQL.
     *
     * funzione                                 | descrizione
     * -----------------------------------------|---------------------------------------------------------------
     * array2mysqlFieldnames()                  | restituisce l'elenco dei nomi di colonna per una query a partire dalle chiavi di un array
     * array2mysqlPlaceholders()                | restituisce l'elenco dei segnaposto per una query a partire da un array
     * array2mysqlDuplicateKeyUpdateValues()    | restituisce la clausola di aggiornamento per ON DUPLICATE KEY UPDATE
     * array2mysqlStatementParameters()         | trasforma un array associativo in parametri per un prepared statement
     * split_sql()                              | divide un testo SQL nelle singole istruzioni
     *
     * funzioni per le viste statiche
     * ------------------------------
     * Le funzioni in questo gruppo gestiscono le viste statiche ( materializzate ) <tabella>_view_static.
     *
     * funzione                                 | descrizione
     * -----------------------------------------|---------------------------------------------------------------
     * getStaticView()                          | restituisce il nome della vista statica di una tabella, se esiste
     * refreshStaticView()                      | aggiorna una vista statica dalla vista che la alimenta
     * getStaticViewExtension()                 | restituisce il suffisso da usare per leggere una tabella dalla sua vista
     *
     * dipendenze
     * ==========
     * Questa libreria ha alcune dipendenze che devono essere soddisfatte per funzionare correttamente. In particolare
     * sono richieste le seguenti funzioni:
     *
     * funzione                         | libreria di appartenenza
     * ---------------------------------|---------------------------------------------------------------
     * logger()                         | core
     * loggerLatest()                   | core
     * array2censored()                 | core
     * timerNow()                       | core ( o _src/_lib/_timer.tools.php )
     * timerDiff()                      | core ( o _src/_lib/_timer.tools.php )
     * print_l()                        | _src/_lib/_array.tools.php
     * addStr2arrayElements()           | _src/_lib/_array.tools.php
     * empty2null()                     | _src/_lib/_string.tools.php
     * string2num()                     | _src/_lib/_string.tools.php
     * writeToFile()                    | _src/_lib/_filesystem.tools.php
     * memcacheRead()                   | _src/_lib/_memcache.tools.php
     * memcacheWrite()                  | _src/_lib/_memcache.tools.php
     * memcacheUniqueKey()              | _src/_lib/_memcache.tools.php
     * memcacheCleanFromIndex()         | _src/_lib/_memcache.utils.php
     * update<VistaStatica>()           | la libreria del modulo che definisce la vista statica ( es. updateAnagraficaViewStatic() )
     *
     * changelog
     * =========
     * Questa sezione riporta la storia delle modifiche più significative apportate alla libreria.
     *
     * data             | autore               | descrizione
     * -----------------|----------------------|---------------------------------------------------------------
     * 2026-09-24       | Fabio Mosti          | documentazione
     *
     * licenza
     * =======
     * Questa libreria fa parte del progetto GlisWeb (https://github.com/istricesrl/glisweb) ed è distribuita
     * sotto licenza Open Source. Fare riferimento alla pagina GitHub del progetto per i dettagli.
     *
     * TODO raggruppare in una funzione mysqlHandleError() il codice per la gestione degli errori che è duplicato in mysqlQuery() e in mysqlPreparedQuery()
     *
     */

    /**
     * FUNZIONI PER LA CACHE DELLE QUERY
     */

    /**
     * restituisce le tabelle coinvolte in una query
     *
     * Questa funzione cerca nel testo della query i nomi che seguono FROM e JOIN e li restituisce, senza duplicati, dopo
     * aver tolto da ciascuno la stringa '_view'; serve a mysqlCachedQuery() per registrare la query nell'indice della cache
     * sotto ogni tabella che legge, così che una scrittura su quella tabella possa invalidarla. Se non trova niente
     * restituisce un array vuoto.
     *
     * NOTA la ricerca è fatta con una espressione regolare semplice: FROM e JOIN vanno scritti in maiuscolo e il nome
     * della tabella è riconosciuto solo se fatto di lettere minuscole e underscore, quindi un nome fra backtick o con cifre
     * non viene riconosciuto ( o viene troncato alla prima cifra ). Togliendo '_view' una vista statica come
     * anagrafica_view_static diventa anagrafica_static, che è la chiave che mysqlInsertRow() ripulisce accanto ad anagrafica.
     *
     * @param       string      $q      la query da analizzare
     *
     * @return      array               l'elenco delle tabelle trovate, eventualmente vuoto
     *
     */
    function mysqlGetQueryTables($q) {

        $r = array();

        if (preg_match_all('/((FROM|JOIN) ([a-z_]+))/', $q, $m)) {
            $r = array_unique($m[3]);
            array_walk($r, function (&$v, $k) {
                $v = str_replace('_view', '', $v);
            });
        }

        return $r;
    }

    /**
     * esegue una query con cache su memcache registrandola nell'indice delle tabelle
     *
     * Questa funzione è mysqlCachedQuery() con l'indice della cache come primo parametro: dopo aver letto il risultato dal
     * database e averlo scritto in cache registra la chiave nell'indice $i sotto ogni tabella letta dalla query, così che
     * mysqlInsertRow() possa invalidarla quando la tabella viene scritta. È la forma da usare per le tendine e per tutte le
     * letture che devono vedere subito le modifiche. Se il TTL è zero e MEMCACHE_DEFAULT_TTL è definita viene usato il
     * TTL di default.
     *
     * @param       array       $i      l'indice della cache ( di solito $cf['memcache']['index'] ), modificato sul posto
     * @param       object      $m      la connessione a memcache
     * @param       object      $c      la connessione mysqli
     * @param       string      $q      la query da eseguire
     * @param       mixed       $p      i parametri del prepared statement, o false per una query semplice
     * @param       int         $t      il TTL in secondi della chiave di cache ( 0 per il default )
     * @param       array       $e      l'array in cui accumulare gli errori, modificato sul posto
     *
     * @return      mixed               il risultato della query come per mysqlQuery()
     *
     */
    function mysqlCachedIndexedQuery(&$i, $m, $c, $q, $p = false, $t = 0, &$e = array()) {

        if (defined('MEMCACHE_DEFAULT_TTL') && $t == 0) {
            $t = MEMCACHE_DEFAULT_TTL;
        }

        return mysqlCachedQuery($m, $c, $q, $p, $t, $e, $i);
    }

    /**
     * esegue una query con cache su memcache
     *
     * Questa funzione calcola la chiave di cache della query ( 'MYSQL_' seguito dall'MD5 di query e parametri serializzati )
     * e la cerca su memcache; se la trova restituisce il valore in cache, altrimenti esegue la query con mysqlQuery() e, se
     * la connessione a memcache non è vuota, scrive il risultato in cache per $t secondi e registra la chiave nell'indice
     * $i sotto ogni tabella restituita da mysqlGetQueryTables(). Se la connessione a memcache è vuota la query viene
     * semplicemente eseguita ogni volta. Anche un risultato false ( query fallita ) viene scritto in cache, ma alla lettura
     * successiva è indistinguibile da una chiave assente e la query viene rieseguita.
     *
     * Passando $t === false si dovrebbe forzare la lettura dal database; vedi però la nota qui sotto.
     *
     * TODO con MEMCACHE_DEFAULT_TTL definita ( cioè sempre, dal runlevel _045.cache.php ) il confronto $t == 0 è vero anche
     * per $t === false, che viene quindi sostituito dal TTL di default prima di arrivare al controllo $t === false: il
     * bypass della cache previsto qui sotto non scatta mai.
     *
     * NOTA chiamata direttamente ( e non tramite mysqlCachedIndexedQuery() ) questa funzione scrive l'indice in un array
     * locale che va perso, quindi la query non viene invalidata dalle scritture sulle sue tabelle e scade solo per TTL.
     *
     * @param       object      $m      la connessione a memcache
     * @param       object      $c      la connessione mysqli
     * @param       string      $q      la query da eseguire
     * @param       mixed       $p      i parametri del prepared statement, o false per una query semplice
     * @param       int         $t      il TTL in secondi della chiave di cache ( 0 per il default )
     * @param       array       $e      l'array in cui accumulare gli errori, modificato sul posto
     * @param       array       $i      l'indice della cache, modificato sul posto
     *
     * @return      mixed               il risultato della query come per mysqlQuery(), dal database o dalla cache
     *
     */
    function mysqlCachedQuery($m, $c, $q, $p = false, $t = 0, &$e = array(), &$i = array()) {

        // debug
        // var_dump( $q );
        // die();

        if (defined('MEMCACHE_DEFAULT_TTL') && $t == 0) {
            $t = MEMCACHE_DEFAULT_TTL;
        }

        // calcolo la chiave della query
        $k = 'MYSQL_' . md5( $q . serialize($p));

        // cerco il valore in cache
        $r = memcacheRead($m, $k);

        // debug
        // var_dump( $r );
        // var_dump( $q );
        // var_dump( $k );
        // die();

        // se il valore non è stato trovato
        if ($r === false || $t === false) {

            $d = mysqlQuery($c, $q, $p, $e);

            if (! empty($m)) {

                memcacheWrite($m, $k, $d, $t);

                logger('query ' . $k . ' non presente in cache', 'speed');

                foreach (mysqlGetQueryTables($q) as $j) {
                    $i[$j]['query'][memcacheUniqueKey($k)] = time();
                }
            }

            return $d;

        } else {

            logger('query ' . $k . ' letta dalla cache', 'speed');
        }

        // restituisco il risultato
        return $r;
    }

    /**
     * esegue una query con cache su disco
     *
     * Questa funzione cerca il risultato della query nel file var/cache/mysql/<md5 di query e parametri>; se il file non
     * esiste esegue la query con mysqlQuery() e ne scrive il risultato serializzato nel file, altrimenti restituisce il
     * contenuto del file. Al momento non viene chiamata da nessuna parte del framework.
     *
     * TODO i parametri $t e $i sono accettati ma ignorati: il file di cache non scade mai e non viene invalidato dalle
     * scritture, e anche il false di una query fallita viene scritto su disco e restituito da lì in poi.
     *
     * @param       object      $c      la connessione mysqli
     * @param       string      $q      la query da eseguire
     * @param       mixed       $p      i parametri del prepared statement, o false per una query semplice
     * @param       int         $t      il TTL della cache ( non usato )
     * @param       array       $e      l'array in cui accumulare gli errori, modificato sul posto
     * @param       array       $i      l'indice della cache ( non usato )
     *
     * @return      mixed               il risultato della query come per mysqlQuery(), dal database o dal disco
     *
     */
    //    function mysqlDiskQuery( $c, $q, $p = false, $t = MEMCACHE_DEFAULT_TTL, &$e = array() ) {
    function mysqlDiskQuery($c, $q, $p = false, $t = 0, &$e = array(), &$i = array())
    {

        // calcolo la chiave della query
        $k = md5($q . serialize($p));

        // cerco il valore in cache
        #        $r = memcacheRead( $m, $k );

        if (! file_exists(DIR_BASE . 'var/cache/mysql/' . $k)) {

            $r = mysqlQuery($c, $q, $p, $e);

            //    $h = fopen( DIR_BASE . 'var/cache/mysql/' . $k, 'w+' );
            //    fwrite( $h, serialize( $r ) );

            writeToFile(serialize($r), DIR_BASE . 'var/cache/mysql/' . $k);
        } else {

            $r = unserialize(file_get_contents(DIR_BASE . 'var/cache/mysql/' . $k));

            #}


            #if( empty( $m ) ) {
            #die( 'memcache non connesso' );
            #}

            // se il valore non è stato trovato
            #        if( empty( $r ) || $t === false ) {
            #        memcacheWrite( $m, $k, $r, $t );
        }

        // restituisco il risultato
        return $r;
    }

    /**
     * 
     * TODO implementare una funzione mysqlSmartQuery() che faccia da sola lo switch fra le varie cache?
     * nel caso andrebbe in mysql utils
     * 
     * 
     */


    /**
     * FUNZIONI DI ESECUZIONE DELLE QUERY
     */

    /**
     * esegue una query sul database
     *
     * Questa funzione è il punto d'ingresso di tutte le query del framework. Scrive la query nel log mysql e nel file
     * dell'ultima query eseguita; se la connessione è vuota logga l'errore e restituisce false, se l'array dei parametri
     * non è vuoto passa la query a mysqlPreparedQuery() e ne restituisce il risultato, altrimenti la esegue direttamente.
     * In questo caso il valore restituito dipende dalla prima parola della query:
     *
     * comando                              | valore restituito
     * -------------------------------------|---------------------------------------------------------------
     * SELECT, SHOW                         | l'array delle righe, eventualmente vuoto
     * CALL, SET, LOCK, UNLOCK              | il valore restituito da mysqli_query()
     * ALTER, CREATE, DROP, OPTIMIZE        | il valore restituito da mysqli_query()
     * BEGIN, START, ROLLBACK, COMMIT       | l'esito dell'operazione sulla transazione
     * INSERT                               | l'ID generato dall'inserimento ( 0 se la tabella non ha AUTO_INCREMENT )
     * REPLACE, UPDATE, DELETE, TRUNCATE    | il numero di righe coinvolte
     *
     * Il riconoscimento del comando distingue maiuscole e minuscole: un comando scritto in minuscolo, o uno che non è in
     * tabella ( es. WITH, EXPLAIN, DESCRIBE ), viene loggato come sconosciuto e la funzione restituisce false senza eseguire
     * niente. Le query che impiegano più di mezzo secondo vengono registrate nei log speed e slow/mysql/query. In caso di
     * errore MySQL l'errore viene loggato, aggiunto all'array $e sotto il suo codice e la funzione restituisce false;
     * se mysqli solleva un'eccezione l'errore viene loggato e la funzione restituisce false senza toccare $e.
     *
     * TODO verificare: da PHP 8.1 mysqli solleva per default eccezioni sugli errori ( e il framework non chiama
     * mysqli_report() ), quindi nel ramo delle query semplici un errore finisce nel catch e $e resta vuoto; chi si basa su
     * $e per accorgersi del fallimento, come mysqlSelectLabel(), su PHP 8.1+ potrebbe non accorgersene.
     *
     * @param       object      $c      la connessione mysqli
     * @param       string      $q      la query da eseguire
     * @param       mixed       $p      i parametri del prepared statement ( vedi l'introduzione ), o false per una query semplice
     * @param       array       $e      l'array in cui accumulare gli errori, indicizzato per codice di errore, modificato sul posto
     *
     * @return      mixed               il risultato della query secondo la tabella qui sopra, o false in caso di errore
     *
     */
    function mysqlQuery($c, $q, $p = false, &$e = array())
    {

        // ID della query
        $queryId = md5(microtime() . $q);

        // log
        logger('query ID: ' . $queryId . ' -> ' . $q, 'mysql');

        // log
        loggerLatest($q, FILE_LATEST_MYSQL);

        // verifico se c'è connessione e se la query è preparata o meno
        if (empty($c)) {

            // log
            logger('chiamata a mysqlQuery() con connessione assente per eseguire -> ' . $q, 'mysql', LOG_ERR);

            // restituisco false
            return false;

            #        } elseif( $p !== false ) {
        } elseif (! empty($p)) {

            // passo alla funzione con prepared statement
            return mysqlPreparedQuery($c, $q, $p, $e);
        } else {

            // cronometro
            $tStart = timerNow();

            // debug
            // echo $q . PHP_EOL;

            // in base al tipo di comando eseguo la query
            try {

                switch (current(explode(' ', str_replace("\n", ' ', trim($q))))) {

                    case 'SELECT':
                    case 'SHOW':
                        $r = mysqlFetchResult(mysqli_query($c, $q));
                        break;

                    case 'CALL':
                        $r = mysqli_query($c, $q);
                        break;

                    case 'SET':
                        $r = mysqli_query($c, $q);
                        break;

                    case 'BEGIN':
                    case 'START':
                        $r = mysqli_begin_transaction($c);
                        break;

                    case 'ROLLBACK':
                        $r = mysqli_rollback($c);
                        break;

                    case 'COMMIT':
                        $r = mysqli_commit($c);
                        break;

                    case 'LOCK':
                    case 'UNLOCK':
                        $r = mysqli_query($c, $q);
                        break;

                    case 'ALTER':
                    case 'CREATE':
                    case 'DROP':
                    case 'OPTIMIZE':
                        $r = mysqli_query($c, $q);
                        break;

                    case 'INSERT':
                        mysqli_query($c, $q);
                        $r = mysqli_insert_id($c);
                        break;

                    case 'REPLACE':
                    case 'UPDATE':
                    case 'DELETE':
                    case 'TRUNCATE':
                        mysqli_query($c, $q);
                        $r = mysqli_affected_rows($c);
                        break;

                    default:
                        logger('comando MySQL sconosciuto: ' . current(explode(' ', str_replace("\n", ' ', $q))), 'mysql', LOG_ERR);
                        return false;
                        break;
                }

            } catch (Exception $ex) {
                logger(__FUNCTION__ . '() errore ' . mysqli_error($c) . ' durante l\'esecuzione della query: ' . $q, 'mysql', LOG_ERR);
                logger(__FUNCTION__ . '() errore ' . mysqli_error($c) . ' durante l\'esecuzione della query: ' . $q . ((! empty($p)) ? '§dati -> ' . print_l($p) : ''), 'details/mysql/query', LOG_ERR);
                return false;
            }

            // cronometro
            $tElapsed = sprintf('%0.11f', timerDiff($tStart));

            // log
            if ($tElapsed > 0.5) {
                logger($q . ' -> TEMPO ' . str_pad($tElapsed, 21, ' ', STR_PAD_LEFT) . ' secondi', 'speed', LOG_ERR);
                logger(str_pad($tElapsed, 21, ' ', STR_PAD_LEFT) . ' secondi -> ' . $q . PHP_EOL, 'slow/mysql/query');
            }

            // debug
            // var_dump( mysqli_errno( $c ) );
            // var_dump( $r );

            // gestione errore
            if (mysqli_errno($c)) {

                // log
                logger(__FUNCTION__ . '() query ID: ' . $queryId . ' -> ERRORE ' . mysqli_errno($c) . ' ' . mysqli_error($c) . '§query -> ' . $q, 'mysql', LOG_ERR);
                logger(__FUNCTION__ . '() query ID: ' . $queryId . ' -> ERRORE ' . mysqli_errno($c) . ' ' . mysqli_error($c) . '§query -> ' . $q . ((! empty($p)) ? '§dati -> ' . print_l($p) : ''), 'details/mysql', LOG_ERR);

                // gestione specifici errori
                switch (mysqli_errno($c)) {

                    case 1062:
                        $e['1062'][] = 'errore MySQL 1062, dati dupilcati';
                        break;

                    case 1054:
                        $e['1054'][] = 'errore MySQL 1054, nome colonna errato';
                        break;

                    default:
                        $e[mysqli_errno($c)][] = mysqli_error($c);
                        break;
                }

                // restituisco false per indicare il fallimento della query
                return false;
            } else {

                // log
                logger('query ID: ' . $queryId . ' -> OK', 'mysql');

                // restituisco il risultato
                return $r;
            }
        }

        // restituisco false di default
        return false;
    }

    /**
     * trasforma il risultato di una query semplice in un array di righe
     *
     * Questa funzione legge tutte le righe di un risultato mysqli come array associativi e le restituisce in un array. Gli
     * errori di mysqli_fetch_assoc() sono soppressi, quindi se la query è fallita e $r vale false la funzione restituisce
     * un array vuoto ( su PHP 8 però passare false a mysqli_fetch_assoc() solleva un TypeError, che la soppressione non
     * ferma ).
     *
     * @param       object      $r      il risultato restituito da mysqli_query()
     *
     * @return      array               l'array delle righe, eventualmente vuoto
     *
     */
    function mysqlFetchResult($r)
    {

        // array del risultato
        $rs = array();

        // archivio il risultato in un array
        // TODO controllare che sia un object result mysql
        #        if( ( is_resource( $r ) ? get_resource_type( $r ) : gettype( $r ) ) == 'mysql' ) {
        while ($row = @mysqli_fetch_assoc($r)) {
            $rs[] = $row;
        }
        #        }

        // restituisco il risultato
        return $rs;
    }

    /**
     * esegue una query come prepared statement
     *
     * Questa funzione prepara la query, lega i parametri ( nel formato descritto nell'introduzione ) e la esegue; di solito
     * non la si chiama direttamente ma attraverso mysqlQuery() passando i parametri. I valori di tipo 'i' o 'd' vuoti
     * ( compreso lo zero, per via di empty() ) vengono legati come NULL; un valore che è a sua volta un array interrompe lo
     * script con die(). Le esecuzioni che impiegano più di mezzo secondo vengono registrate nei log speed e
     * slow/mysql/query. Il valore restituito dipende dalla prima parola della query:
     *
     * comando                              | valore restituito
     * -------------------------------------|---------------------------------------------------------------
     * SELECT                               | l'array delle righe, eventualmente vuoto
     * INSERT                               | l'ID generato, o se è vuoto il valore del parametro con chiave 'id', o NULL
     * tutti gli altri                      | il numero di righe coinvolte
     *
     * Quindi anche una SHOW o una CALL eseguite con parametri restituiscono un numero e non delle righe. Se la connessione è
     * vuota, se la preparazione fallisce o se viene sollevata un'eccezione la funzione logga l'errore e restituisce false.
     * Se invece fallisce l'esecuzione l'errore viene loggato ma il valore restituito non cambia ( vedi la nota nel corpo ):
     * per una INSERT fallita si ottiene quindi l'ID passato nei parametri, se c'è.
     *
     * NOTA a differenza di mysqlQuery() questa funzione non scrive mai niente nell'array $e, che è accettato solo per
     * simmetria di firma.
     *
     * @param       object      $c          la connessione mysqli
     * @param       string      $q          la query da eseguire, con i segnaposto ?
     * @param       array       $params     i parametri da legare ai segnaposto, nell'ordine
     * @param       array       $e          l'array degli errori ( non usato )
     *
     * @return      mixed                   il risultato della query secondo la tabella qui sopra, o false in caso di errore
     *
     */
    function mysqlPreparedQuery($c, $q, $params = array(), &$e = array())
    {

        // log
        logger(md5($q) . ' PREPARED ' . $q, 'mysql');

        // verifico se c'è connessione
        if (empty($c)) {

            // log
            logger('chiamata a mysqlPreparedQuery() con connessione assente', 'mysql', LOG_ERR);

            // restituisco false
            return false;

        } else {

            try {

                // cronometro
                $tStart = timerNow();

                // preparo la query...
                $pq = mysqli_prepare($c, $q);

                // se la preparazione dello statement è andata a buon fine...
                if ($pq !== false) {

                    // se ci sono dei parametri da bindare...
                    if (is_array($params) && count($params)) {

                        // preparazione dei parametri per il bind
                        $aParams[0] = $pq;
                        $aParams[1] = '';
                        foreach ($params as $key => $val) {
                            $type = current(array_keys($val));
                            $aParams[1] .= $type;
                            $aParams[] = &$params[$key][$type];
                            if (($type == 'i' || $type == 'd') && empty($params[$key][$type])) {
                                $params[$key][$type] = NULL;
                            }
                            if (is_array($params[$key][$type])) {
                                die('passare solo stringhe come parametri della query: ' . PHP_EOL . $q . PHP_EOL . PHP_EOL . 'oggetto malformato: ' . print_r($val, true));
                            }
                        }

                        // bind dei parametri
                        call_user_func_array('mysqli_stmt_bind_param', $aParams);
                    }

                    // esecuzione dello statement
                    $xStatement = mysqli_stmt_execute($pq);

                    // cronometro
                    $tElapsed = sprintf('%0.11f', timerDiff($tStart));

                    // log
                    if ($tElapsed > 0.5) {
                        logger($q . ' -> TEMPO ' . str_pad($tElapsed, 21, ' ', STR_PAD_LEFT) . ' secondi', 'speed', LOG_ERR);
                        logger(str_pad($tElapsed, 21, ' ', STR_PAD_LEFT) . ' secondi -> ' . $q . PHP_EOL, 'slow/mysql/query');
                    }

                    // ESITO DELL'ESECUZIONE
                    //
                    // mysqli_stmt_execute() restituisce false quando la query non e' andata, ma
                    // fino a qui il valore veniva raccolto in $xStatement e mai guardato: si
                    // scriveva "-> OK" nel log anche su una scrittura fallita, e il chiamante si
                    // ritrovava un insert_id che valeva 0 senza nessun modo di accorgersene. Da
                    // qui nascono i guasti piu' difficili da diagnosticare del framework: una
                    // colonna che manca, un valore che il tipo non accetta, una chiave unica che
                    // scatta, e la pagina risponde 200 con il log che dice che e' filato tutto
                    // liscio mentre in archivio non c'e' niente.
                    //
                    // Qui si logga e basta, senza cambiare il valore di ritorno: cambiarlo
                    // vorrebbe dire toccare il comportamento di ogni chiamante del framework, e
                    // non e' una decisione da prendere dentro questa funzione. L'errore adesso
                    // pero' si vede, ed e' il minimo perche' sia diagnosticabile.
                    //
                    // Si usa logger() e non logWrite(): questa e' una libreria "tools", che per
                    // convenzione non dipende da $cf, mentre logWrite() sta in _log.utils.php.
                    // Tutto il resto del file logga cosi'.
                    if ($xStatement === false) {

                        logger(
                            $q . PHP_EOL
                            . 'parametri: ' . print_r($params, true) . PHP_EOL
                            . 'errore (' . mysqli_stmt_errno($pq) . ') ' . mysqli_stmt_error($pq),
                            'mysql',
                            LOG_ERR
                        );

                    } else {

                        // log
                        logger(md5($q) . ' -> OK', 'mysql');

                    }

                    // valore di ritorno a seconda del tipo di query
                    switch (current(explode(' ', str_replace("\n", ' ', trim($q))))) {

                        case 'SELECT':
                            return mysqlFetchPreparedResult($pq);
                            break;

                        case 'INSERT':
                            $id = mysqli_stmt_insert_id($pq);
                            return ((! empty($id)) ? $id : ((isset($params['id']['s'])) ? $params['id']['s'] : NULL));
                            break;

                        case 'REPLACE':
                        case 'UPDATE':
                        case 'DELETE':
                        case 'TRUNCATE':
                        default:
                            return mysqli_stmt_affected_rows($pq);
                            break;

                    }

                } else {

                    /**
                     * Fix 2026-09-01: nel log ci va anche l'errore di MySQL.
                     *
                     * Quando mysqli_prepare() torna false senza sollevare eccezione questo ramo
                     * scriveva solo il testo della query, e il motivo del rifiuto restava ignoto:
                     * per scoprire che una query era un 1064 (errore di sintassi) bisognava
                     * riprodurla a mano fuori dal framework. Siccome mysqlSelectRow() e
                     * mysqlSelectValue() non distinguono "query fallita" da "nessuna riga", una
                     * query malformata si traveste da dato mancante e il log è l'unico posto in cui
                     * la differenza si vede: senza il codice di errore non serve a niente.
                     * Il ramo catch() qui sotto lo faceva già, questo no.
                     *
                     * Rimessa il 2026-09-09: era stata promossa upstream il 02/09 e sepolta da un
                     * riallineamento successivo di un altro deploy.
                     */
                    logger(__FUNCTION__ . '() errore ' . mysqli_errno($c) . ' ' . mysqli_error($c) . ' nella preparazione della query: ' . $q, 'mysql', LOG_ERR);

                    // restituisco false
                    return false;
                }

            } catch (Exception $ex) {
                logger(__FUNCTION__ . '() errore ' . mysqli_error($c) . ' durante la preparazione della query: ' . $q, 'mysql', LOG_ERR);
                logger(__FUNCTION__ . '() errore ' . mysqli_error($c) . ' durante la preparazione della query: ' . $q . ((! empty($params)) ? '§dati -> ' . print_l($params) : ''), 'details/mysql/query', LOG_ERR);
                return false;
            }

        }

        // restituisco false di default
        return false;
    }

    /**
     * trasforma il risultato di un prepared statement in un array di righe
     *
     * Questa funzione estrae il risultato da uno statement già eseguito e ne legge tutte le righe come array associativi;
     * se lo statement non ha prodotto righe restituisce un array vuoto. Se l'esecuzione dello statement è fallita
     * mysqli_stmt_get_result() restituisce false e anche in questo caso la funzione restituisce un array vuoto, come fa
     * mysqlFetchResult(); l'errore è già stato loggato da mysqlPreparedQuery().
     *
     * @param       object      $pq     lo statement mysqli eseguito
     *
     * @return      array               l'array delle righe, eventualmente vuoto
     *
     */
    function mysqlFetchPreparedResult($pq)
    {

        // array del risultato
        $arRs = array();

        // estraggo il resultset dallo statement
        $r = mysqli_stmt_get_result($pq);

        // NOTA su un'esecuzione fallita $r vale false, e da PHP 8 mysqli_fetch_assoc( false ) solleva un TypeError, che è
        // un Error e non una Exception e quindi passa attraverso il catch() di mysqlPreparedQuery() ( 2026-09-24 )
        if ($r === false) {
            return $arRs;
        }

        // fetch del risultato
        while ($row = mysqli_fetch_assoc($r)) {
            $arRs[] = $row;
        }

        // restituisco il risultato
        return $arRs;
    }

    /**
     * FUNZIONI DI SELEZIONE
     */

    /**
     * restituisce il primo valore della prima riga di una query
     *
     * Questa funzione esegue la query con mysqlSelectRow() e restituisce il valore della prima colonna della prima riga; è
     * la forma da usare per leggere un singolo dato ( un ID, un conteggio, un nome ). Se la query non restituisce righe, o
     * se fallisce, restituisce NULL: i due casi non sono distinguibili dal valore di ritorno, e solo il log ( o l'array
     * $e, nei limiti descritti per mysqlQuery() ) dice quale dei due si è verificato.
     *
     * @param       object      $c      la connessione mysqli
     * @param       string      $q      la query da eseguire
     * @param       mixed       $p      i parametri del prepared statement, o false per una query semplice
     * @param       array       $e      l'array in cui accumulare gli errori, modificato sul posto
     *
     * @return      mixed               il primo valore della prima riga, o NULL se non ci sono righe
     *
     */
    function mysqlSelectValue($c, $q, $p = false, &$e = array())
    {

        // valore di ritorno
        $v = NULL;

        // risultato
        $r = mysqlSelectRow($c, $q, $p, $e);

        // controllo che ci siano righe
        if (is_array($r) && count($r) > 0) {
            $v = array_shift($r);
        }

        // ritorno
        return $v;
    }

    /**
     * restituisce una colonna del risultato di una query
     *
     * Questa funzione esegue la query con mysqlQuery() e restituisce i valori della colonna $f di tutte le righe; se la
     * query fallisce o non restituisce righe restituisce un array vuoto, e le righe in cui la colonna manca vengono saltate.
     *
     * @param       string      $f      il nome della colonna da estrarre
     * @param       object      $c      la connessione mysqli
     * @param       string      $q      la query da eseguire
     * @param       mixed       $p      i parametri del prepared statement, o false per una query semplice
     * @param       array       $e      l'array in cui accumulare gli errori, modificato sul posto
     *
     * @return      array               i valori della colonna, eventualmente vuoto
     *
     */
    function mysqlSelectColumn($f, $c, $q, $p = false, &$e = array())
    {

        // valore di ritorno
        $r = array();

        // prelevo il risultato
        $rs = mysqlQuery($c, $q, $p, $e);

        // risultato
        if (is_array($rs)) {
            $r = array_column($rs, $f);
        }

        // ritorno
        return $r;
    }

    /**
     * restituisce una colonna del risultato di una query, con cache
     *
     * Questa funzione fa lo stesso lavoro di mysqlSelectColumn() ma esegue la query con mysqlCachedQuery(), quindi il
     * risultato può arrivare da memcache; la query non viene registrata nell'indice della cache e scade solo per TTL.
     *
     * @param       object      $m      la connessione a memcache
     * @param       string      $f      il nome della colonna da estrarre
     * @param       object      $c      la connessione mysqli
     * @param       string      $q      la query da eseguire
     * @param       mixed       $p      i parametri del prepared statement, o false per una query semplice
     * @param       int         $t      il TTL in secondi della chiave di cache ( 0 per il default )
     * @param       array       $e      l'array in cui accumulare gli errori, modificato sul posto
     *
     * @return      array               i valori della colonna, eventualmente vuoto
     *
     */
    function mysqlSelectCachedColumn($m, $f, $c, $q, $p = false, $t = 0, &$e = array())
    {

        // valore di ritorno
        $r = array();

        // prelevo il risultato
        $rs = mysqlCachedQuery($m, $c, $q, $p, $t, $e);

        // risultato
        if (is_array($rs)) {
            $r = array_column($rs, $f);
        }

        // ritorno
        return $r;
    }

    /**
     * restituisce la prima riga del risultato di una query
     *
     * Questa funzione esegue la query con mysqlQuery() e restituisce la prima riga come array associativo; se la query non
     * restituisce righe, o fallisce, scrive una riga nel log mysql e restituisce un array vuoto, quindi anche qui una query
     * sbagliata e un dato assente danno lo stesso valore di ritorno.
     *
     * @param       object      $c      la connessione mysqli
     * @param       string      $q      la query da eseguire
     * @param       mixed       $p      i parametri del prepared statement, o false per una query semplice
     * @param       array       $e      l'array in cui accumulare gli errori, modificato sul posto
     *
     * @return      array               la prima riga del risultato, o un array vuoto se non ci sono righe
     *
     */
    function mysqlSelectRow($c, $q, $p = false, &$e = array())
    {

        // valore di ritorno
        $v = array();

        // risultato
        $r = mysqlQuery($c, $q, $p, $e);

        // controllo che ci siano righe
        if (is_array($r) && count($r) > 0) {
            $v = array_shift($r);
        } else {
            logger('nessuna riga trovata nel risultato', 'mysql');
        }

        // ritorno
        return $v;
    }

    /**
     * restituisce il primo valore della prima riga di una query, con cache
     *
     * Questa funzione fa lo stesso lavoro di mysqlSelectValue() ma passa per mysqlSelectCachedRow(), quindi il risultato
     * può arrivare da memcache; la query non viene registrata nell'indice della cache e scade solo per TTL. Se la query non
     * restituisce righe restituisce NULL.
     *
     * @param       object      $m      la connessione a memcache
     * @param       object      $c      la connessione mysqli
     * @param       string      $q      la query da eseguire
     * @param       mixed       $p      i parametri del prepared statement, o false per una query semplice
     * @param       int         $t      il TTL in secondi della chiave di cache ( default MEMCACHE_DEFAULT_TTL )
     * @param       array       $e      l'array in cui accumulare gli errori, modificato sul posto
     *
     * @return      mixed               il primo valore della prima riga, o NULL se non ci sono righe
     *
     */
    function mysqlSelectCachedValue($m, $c, $q, $p = false, $t = MEMCACHE_DEFAULT_TTL, &$e = array())
    {

        // valore di ritorno
        $v = NULL;

        // risultato
        $r = mysqlSelectCachedRow($m, $c, $q, $p, $t, $e);

        // controllo che ci siano righe
        if (is_array($r) && count($r) > 0) {
            $v = array_shift($r);
        }

        // ritorno
        return $v;
    }

    /**
     * restituisce la prima riga del risultato di una query, con cache
     *
     * Questa funzione fa lo stesso lavoro di mysqlSelectRow() ma esegue la query con mysqlCachedQuery(), quindi il
     * risultato può arrivare da memcache; la query non viene registrata nell'indice della cache e scade solo per TTL. Se
     * la query non restituisce righe restituisce un array vuoto, senza scrivere niente nel log.
     *
     * @param       object      $m      la connessione a memcache
     * @param       object      $c      la connessione mysqli
     * @param       string      $q      la query da eseguire
     * @param       mixed       $p      i parametri del prepared statement, o false per una query semplice
     * @param       int         $t      il TTL in secondi della chiave di cache ( default MEMCACHE_DEFAULT_TTL )
     * @param       array       $e      l'array in cui accumulare gli errori, modificato sul posto
     *
     * @return      array               la prima riga del risultato, o un array vuoto se non ci sono righe
     *
     */
    function mysqlSelectCachedRow($m, $c, $q, $p = false, $t = MEMCACHE_DEFAULT_TTL, &$e = array())
    {

        // valore di ritorno
        $v = array();

        // risultato
        $r = mysqlCachedQuery($m, $c, $q, $p, $t, $e);

        // controllo che ci siano righe
        if (is_array($r) && count($r) > 0) {
            $v = array_shift($r);
        }

        // ritorno
        return $v;
    }

    /**
     * FUNZIONI DI MANIPOLAZIONE DEI RECORD
     */

    /**
     * effettua la duplicazione ricorsiva di un oggetto e degli eventuali oggetti figli nelle tabelle correlate
     *
     * Questa funzione duplica con mysqlDuplicateRow() la riga $o della tabella $t, applicando le sostituzioni dichiarate
     * in $x['t'][$t]['f'], dopodiché cerca in information_schema le chiavi esterne che puntano a $t e, per ogni riga
     * collegata alla riga originale, chiama sé stessa sulla tabella figlia impostando la colonna di collegamento al nuovo
     * ID. Le tabelle figlie seguite sono quelle elencate in $x['t'][$t]['t']; se l'elenco è vuoto vengono seguite TUTTE
     * le tabelle che referenziano $t ( è il caso delle foglie dell'esempio qui sotto, come 'contenuti' => array() ), sempre
     * escludendo le chiavi di $t verso sé stessa. Se $o è vuoto lo script viene interrotto con die().
     *
     * L'array $x ha per ogni tabella queste chiavi:
     *
     * chiave           | dettagli
     * -----------------|-----------------------------------------------------------------------
     * t                | array delle tabelle figlie da duplicare, ciascuna con la stessa struttura
     * f                | valori da impostare nel nuovo record, con in chiave il nome del campo e in valore il valore
     * r                | condizioni aggiuntive per la ricerca delle righe figlie ( vedi il TODO qui sotto )
     *
     * esempio di array per la duplicazione di una pagina con relativi contenuti e immagini, e dei contenuti associati alle
     * immagini ( lo stesso schema è usato dalle funzioni di duplicazione in _src/_lib/_page.utils.php ):
     *
     * ```
     * $tbls = array(
     *      't' => array(
     *          'pagine' => array(
     *               't' => array(
     *                   'contenuti' => array(),
     *                   'immagini' => array(
     *                       't' => array(
     *                           'contenuti' => array()
     *                       )
     *                   )
     *               ),
     *               'f' => array(
     *                   'nome' => $p['nome'] . ' - duplicata'
     *               )
     *           )
     *      )
     * );
     * ```
     *
     * La funzione non restituisce niente: l'ID del nuovo oggetto principale lo si trova in $y['id'].
     *
     * TODO se per una tabella figlia è presente la chiave 'r' la funzione compone la condizione e poi esegue die( $whr ),
     * cioè interrompe lo script: le condizioni aggiuntive di fatto non sono utilizzabili.
     *
     * TODO $y[<tabella figlia>] viene sovrascritto a ogni riga figlia duplicata, quindi alla fine contiene solo l'ultima.
     *
     * NOTA la ricerca delle righe figlie scrive $o direttamente nella query, fra virgolette, invece di usare un parametro.
     *
     * @param       object      $c      la connessione mysqli
     * @param       string      $t      il nome della tabella in cui si trova il record principale da duplicare
     * @param       string      $o      l'ID dell'oggetto da duplicare
     * @param       string      $n      l'ID da dare all'oggetto duplicato, NULL per usare l'AUTO_INCREMENT
     * @param       array       $x      l'array delle tabelle e delle sostituzioni descritto qui sopra, modificato sul posto
     *                                  ( la funzione vi aggiunge i default e i campi di collegamento delle tabelle figlie )
     * @param       array       $y      l'array in cui viene scritta la riga duplicata, modificato sul posto; le righe
     *                                  figlie finiscono sotto la chiave col nome della loro tabella
     *
     * @return      void
     *
     */
    function mysqlDuplicateRowRecursive($c, $t, $o, $n = NULL, &$x = array(), &$y = array())
    {

        // debug
        #    echo "chiamata mysqlDuplicateRowRecursive per array x" . PHP_EOL;
        #    print_r($x);
        #    echo "tabella principale: " . $t . " - stampo x[" . $t . "]" . PHP_EOL;
        #    print_r( $x['t'][ $t ] );
        #    var_dump( $n );

        // defaults
        if (! isset($x['t'][$t]['f'])) {
            $x['t'][$t]['f'] = array();
        }
        if (! isset($x['t'][$t]['t'])) {
            $x['t'][$t]['t'] = array();
        }

        // se non ho un ID di partenza
        if (empty($o)) {
            die('ID da duplicare non passato');
        }

        // defaults
        if (! isset($x['t'][$t]['f'])) {
            $x['t'][$t]['f'] = array();
        }
        if (! isset($x['t'][$t]['t'])) {
            $x['t'][$t]['t'] = array();
        }

        // duplico la riga
        $id = mysqlDuplicateRow($c, $t, $o, $n, $x['t'][$t]['f'], $y);

        // debug
        #     echo 'ID riga duplicata = ' . $id . PHP_EOL;

        // creo i placeholder per le tabelle richieste
        $pholders = array();
        $values = array(array('s' => $t));
        foreach (array_keys($x['t'][$t]['t']) as $rt) {
            $pholders[] = '?';
            $values[] = array('s' => $rt);
        }
        $values[] = array('s' => $t);

        // cerco le tabelle collegate
        $ks = mysqlQuery(
            $c,
            'SELECT * FROM information_schema.key_column_usage ' .
                'WHERE referenced_table_name = ? ' .
                #            'AND ( constraint_name NOT LIKE "%_nofollow" OR '.
                #            'table_name IN ( ' . implode( ',', $pholders ) . ' ) ) '.
                ((is_array($pholders) && count($pholders) > 0) ? 'AND table_name IN ( ' . implode(',', $pholders) . ' ) ' : NULL) .
                'AND table_name != ? ' .
                'AND table_schema = database() ',
            $values
        );

        // debug
        #    echo "tabelle collegate". PHP_EOL;
        #    print_r( $ks );

        #    echo "per ogni relazione... ". PHP_EOL;
        // per ogni relazione
        foreach ($ks as $ksr) {

            #    echo "tabella " . $ksr['TABLE_NAME'] . PHP_EOL;

            #    echo "aggiungo il campo di relazione alle sostituzioni" . PHP_EOL;

            // aggiungo il campo di relazione alle sostituzioni
            $x['t'][$t]['t'][$ksr['TABLE_NAME']]['f'][$ksr['COLUMN_NAME']] = $id;

            if (isset($x['t'][$t]['t'][$ksr['TABLE_NAME']]['r'])) {
                $whr = ' AND ' . implode(' AND ', $x['t'][$t]['t'][$ksr['TABLE_NAME']]['r']);
                die($whr);
            } else {
                $whr = NULL;
            }

            #    echo "valore attuale di x". PHP_EOL;
            #    print_r($x);

            // compongo la query di ricerca relazioni
            $q = 'SELECT * FROM ' . $ksr['TABLE_NAME'] . ' WHERE ' . $ksr['COLUMN_NAME'] . ' = "' . $o . '" ' . $whr;

            // trovo le righe collegate
            $rls = mysqlQuery($c, $q);

            // debug
            #    echo "query di ricerca relazioni" . PHP_EOL;
            #     var_dump( $q );

            #     echo "righe collegate" . PHP_EOL;
            #     print_r( $rls );

            #     echo "per ogni riga di relazione... ". PHP_EOL;
            // per ogni riga della relazione
            foreach ($rls as $rl) {

                #    echo "stampo la riga di relazione". PHP_EOL;
                // debug
                #     print_r( $rl );

                #     echo "chiamo mysqlDuplicateRowRecursive". PHP_EOL;
                // chiamo mysqlDuplicateRowRecursive() per ogni tabella collegata
                mysqlDuplicateRowRecursive($c, $ksr['TABLE_NAME'], $rl['id'], NULL, $x['t'][$t], $y[$ksr['TABLE_NAME']]);
            }
        }
    }

    /**
     * duplica una riga di una tabella
     *
     * Questa funzione legge da information_schema le colonne della tabella $t e copia la riga con ID $o in una nuova riga
     * con una INSERT IGNORE ... SELECT: le colonne presenti in $x prendono il valore indicato lì, la colonna id prende $n
     * ( o $x['id'] se presente ), tutte le altre vengono copiate dalla riga originale. Dopo l'inserimento legge la nuova
     * riga e la scrive in $y. Essendo una INSERT IGNORE, un inserimento che viola una chiave unica non dà errore e non
     * inserisce niente.
     *
     * Restituisce l'ID generato dall'inserimento; se è vuoto ( riga non inserita, o tabella senza AUTO_INCREMENT )
     * restituisce $x['id'] se era stato passato, altrimenti NULL, e in quel caso $y è un array vuoto.
     *
     * TODO passando $n per una tabella senza AUTO_INCREMENT la riga viene inserita con quell'ID, ma senza $x['id'] la
     * funzione restituisce NULL invece di $n: è la domanda lasciata aperta dalla NOTA nel corpo.
     *
     * TODO: creare un meccanismo di sostituzione intelligente dei valori dei campi (oltre al settaggio manuale)
     *
     * @param       object      $c      la connessione mysqli
     * @param       string      $t      il nome della tabella
     * @param       string      $o      l'ID del record da duplicare
     * @param       string      $n      l'ID del nuovo record, NULL per usare l'AUTO_INCREMENT
     * @param       array       $x      i valori da impostare nel nuovo record, con in chiave i nomi delle colonne
     * @param       array       $y      l'array in cui viene scritta la nuova riga, modificato sul posto
     *
     * @return      mixed               l'ID del nuovo record, o NULL se non è stato possibile determinarlo
     *
     */
    function mysqlDuplicateRow($c, $t, $o, $n = NULL, $x = array(), &$y = array())
    {

        // salvo l'id
        $id = isset($x['id']) ? $x['id'] : null;

        // campi da modificare
        $x = array_merge(array('id' => $n), $x);

        // debug
        // print_r( $x );

        // campi della tabella
        $fields = mysqlSelectColumn('COLUMN_NAME', $c, 'SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ?', array(array('s' => $t)));
        $fieldsChanged = array_keys($x);
        $fieldsCopied = array_diff($fields, $fieldsChanged);
        $fieldsInsert = array_merge($fieldsChanged, $fieldsCopied);

        // valori da sostituire
        $values = array();
        foreach ($x as $xv) {
            $values[] = array('s' => $xv);
        }
        $values[] = array('s' => $o);

        // composizione della query
        $q = 'INSERT IGNORE INTO ' . $t . ' (' . implode(',', $fieldsInsert) . ') SELECT ' . str_repeat('?,', count($fieldsChanged)) . implode(',', $fieldsCopied) . ' FROM ' . $t . ' WHERE id = ?';

        // NOTA perché sono stati scambiati $id e $n? è corretto o andava bene prima?

        // esecuzione della query
        // $id = mysqlQuery( $c, $q, $values );
        $n = mysqlQuery($c, $q, $values);

        /*
            if( empty( $id ) ){
                $id = $n;
            }
    */

        if (empty($n)) {
            $n = $id;
        }

        // popolo l'oggetto
        $y = mysqlSelectRow(
            $c,
            'SELECT * FROM ' . $t . ' WHERE id = ?',
            //            array( array( 's' => $id ) )
            array(array('s' => $n))
        );

        // debug
        // echo $q . PHP_EOL;
        // print_r( $values );
        // var_dump( $n );
        // print_r( $fields );

        // ritorno l'id nel nuovo record inserito
        //        return $id;
        return $n;
    }

    /**
     * cancella una riga e, a cascata, le righe che la referenziano
     *
     * Questa funzione effettua l'eliminazione ricorsiva di un oggetto e, a cascata, di tutti gli oggetti collegati da
     * vincoli di chiave con regola di cancellazione "NO ACTION", cioè quelli che impedirebbero la DELETE della riga
     * principale; i vincoli con le altre regole ( CASCADE, SET NULL, RESTRICT ) non vengono seguiti. Per ogni
     * vincolo trovato cerca nella tabella figlia le righe con la colonna di collegamento uguale a $d e chiama sé stessa su
     * ciascuna, dopodiché cancella la riga $d di $t. È usata dai task di cancellazione dei moduli ( documenti, contratti,
     * progetti ). Gli esiti delle DELETE non vengono controllati.
     *
     * NOTA: poiché la funzione legge i vincoli attraverso memcache, se si apportano modifiche alle tipologia dei vincoli di
     * chiave tra le tabelle del database, svuotare sempre memcache
     *
     * TODO la chiamata ricorsiva passa come ID della riga figlia $r1[ REFERENCED_COLUMN_NAME ], cioè il valore della
     * colonna che ha lo stesso nome della colonna referenziata nella tabella padre; funziona perché la colonna
     * referenziata è sempre id, ma non è l'ID della riga figlia in generale. Inoltre la join fra key_column_usage e
     * referential_constraints è fatta solo sui nomi delle tabelle e non sul nome del vincolo, quindi con più vincoli fra
     * le stesse due tabelle le righe si moltiplicano.
     *
     * @param       object      $m      la connessione a memcache
     * @param       object      $c      la connessione mysqli
     * @param       string      $t      il nome della tabella
     * @param       string      $d      l'ID del record da eliminare
     *
     * @return      void
     *
     */
    function mysqlDeleteRowRecursive($m, $c, $t, $d)
    {

        // debug
        #    echo 'chiamata funzione cancellazione ricorsiva' . PHP_EOL;
        #    echo "richiesta la cancellazione della riga #$d dalla tabella {$t}" . PHP_EOL;

        // cerco i vincoli di chiave esterna per l'entità $t
        // NOTA mi interessano TABLE_NAME, COLUMN_NAME, REFERENCED_COLUMN_NAME
        $x = mysqlCachedQuery(
            $m,
            $c,
            'SELECT information_schema.key_column_usage.TABLE_NAME, information_schema.key_column_usage.COLUMN_NAME, information_schema.key_column_usage.REFERENCED_COLUMN_NAME, information_schema.key_column_usage.REFERENCED_TABLE_NAME, ' .
                'information_schema.referential_constraints.DELETE_RULE ' .
                'FROM information_schema.key_column_usage ' .
                'INNER JOIN information_schema.referential_constraints ON ( information_schema.referential_constraints.REFERENCED_TABLE_NAME = information_schema.key_column_usage.REFERENCED_TABLE_NAME ' .
                'AND information_schema.referential_constraints.TABLE_NAME = information_schema.key_column_usage.TABLE_NAME ) ' .
                'WHERE information_schema.key_column_usage.REFERENCED_TABLE_NAME = ? AND table_schema = database() AND information_schema.referential_constraints.DELETE_RULE = ? ',
            array(
                array('s' => $t),
                array('s' => 'NO ACTION')
            )
        );

        // dati prelevati
        foreach ($x as $x1) {

            // debug
            #    print_r( $x1 );

            // variabili in uso
            $t1 = $x1['TABLE_NAME'];
            $f1 = $x1['COLUMN_NAME'];
            $l1 = $x1['REFERENCED_COLUMN_NAME'];

            // debug
            #    echo "SELECT * FROM $t1 WHERE $t1.$f1 = ?" . PHP_EOL;
            #    echo "cerco le righe di $t1 che hanno $t1.$f1 uguale a $d" . PHP_EOL;

            // prelevo le righe referenziate
            $r = mysqlQuery(
                $c,
                "SELECT * FROM $t1 WHERE $t1.$f1 = ?",
                array(
                    array('s' => $d)
                )
            );

            // debug
            #    print_r( $r );

            // per ogni riga delle tabelle referenziate chiamo ricorsivamente
            foreach ($r as $r1) {

                // chiamata ricorsiva
                mysqlDeleteRowRecursive($m, $c, $t1, $r1[$l1]);
            }
        }

        // debug
        # echo "elimino la riga #$d dalla tabella $t" . PHP_EOL;

        // cancello l'oggetto richiesto
        $r = mysqlQuery(
            $c,
            "DELETE FROM $t WHERE $t.id = ?",
            array(
                array('s' => $d)
            )
        );
    }

    /**
     * inserisce o aggiorna una riga a partire da un array associativo
     *
     * Questa funzione scrive nella tabella $t la riga $r, con i nomi delle colonne in chiave. Con $d a true ( il default )
     * la query è una INSERT ... ON DUPLICATE KEY UPDATE, quindi se la riga esiste già ( stesso ID o stessa chiave unica )
     * viene aggiornata; con $d a false è una INSERT IGNORE, che in caso di duplicato non fa niente. Prima della scrittura:
     *
     * -# se $u non è vuoto cerca una riga esistente con gli stessi valori nelle colonne elencate in $u ( un valore vuoto
     *    viene cercato come IS NULL ) e ne usa l'ID, o NULL se non la trova;
     * -# converte in NULL i valori vuoti con empty2null(), quindi anche 0 e '0' diventano NULL;
     * -# normalizza i numeri scritti con la virgola con string2num();
     * -# se la riga non ha la chiave id e $n è false aggiunge id a NULL, così che venga usato l'AUTO_INCREMENT.
     *
     * Dopo la scrittura invalida con memcacheCleanFromIndex() le query in cache che leggono $t e la sua vista statica e,
     * se la tabella ha una vista statica <t>_view_static e la funzione update<VistaStatica>() corrispondente esiste
     * ( es. updateAnagraficaViewStatic() ), la chiama con l'ID scritto. Ogni passaggio viene loggato nei file
     * mysql/insertrow.<tabella>, con i valori sensibili censurati da array2censored().
     *
     * NOTA la query di ricerca per $u scrive i valori direttamente nel testo SQL, fra virgolette, invece di usare i
     * parametri ( c'è un TODO nel corpo ); la query di scrittura invece è un prepared statement.
     *
     * NOTA il primo log va in mysql/insertrow/<tabella> e gli altri in mysql/insertrow.<tabella>, e la query composta viene
     * loggata a livello LOG_ERR anche quando non c'è nessun errore.
     *
     * @param       object      $c      la connessione mysqli
     * @param       array       $r      la riga da scrivere, con in chiave i nomi delle colonne
     * @param       string      $t      il nome della tabella
     * @param       bool        $d      true per aggiornare la riga se esiste già, false per ignorare il duplicato
     * @param       bool        $n      true per non aggiungere la colonna id a NULL quando la riga non la contiene
     * @param       array       $u      l'elenco delle colonne con cui cercare una riga esistente
     *
     * @return      mixed               l'ID della riga scritta come restituito da mysqlQuery(), o false in caso di errore
     *
     */
    function mysqlInsertRow($c, $r, $t, $d = true, $n = false, $u = array())
    {

        // nel log i valori sensibili ( password, token, ... ) vanno censurati, sulla copia e non sulla riga da scrivere
        $l = $r;
        logger($t . PHP_EOL . print_r(array2censored($l), true), 'mysql/insertrow/' . $t);

        if (! empty($u)) {

            $uQuery = 'SELECT id FROM ' . $t . ' WHERE ';

            foreach ($u as $uFld) {
                $uConds[] = ' ' . $uFld . ((! isset($r[$uFld]) || empty($r[$uFld])) ? ' IS NULL' : ' = "' . $r[$uFld] . '" ');
            }

            // TODO migliorare questa query con i parametri posizionali
            $r['id'] = mysqlSelectValue($c, $uQuery . implode(' AND ', $uConds));

            // debug
            // var_dump( $uQuery . implode(' AND ', $uConds) );
            // var_dump( $r['id'] );

            $l = $r;
            logger($t . '( dopo controllo di unicità )' . PHP_EOL . print_r(array2censored($l), true), 'mysql/insertrow.' . $t);

        }

        $r = array_map('empty2null', $r);

        $l = $r;
        logger($t . '( dopo array_map )' . PHP_EOL . print_r(array2censored($l), true), 'mysql/insertrow.' . $t);

        $r = array_map('string2num', $r);

        $l = $r;
        logger($t . '( dopo string2num )' . PHP_EOL . print_r(array2censored($l), true), 'mysql/insertrow.' . $t);

        if (! array_key_exists('id', $r) && $n == false) {
            $r['id'] = NULL;
        }

        $q = 'INSERT ' . (($d === true) ? NULL : 'IGNORE') . ' INTO ' . $t . ' ( ' . array2mysqlFieldnames($r) . ' ) '
            . 'VALUES ( ' . array2mysqlPlaceholders($r) . ' ) '
            . (($d === true) ? 'ON DUPLICATE KEY UPDATE ' . array2mysqlDuplicateKeyUpdateValues($r) : NULL);

        logger($t . PHP_EOL . $q, 'mysql/insertrow.' . $t, LOG_ERR);

        $a = array2mysqlStatementParameters($r);

        $l = $r;
        logger($t . PHP_EOL . print_r(array2mysqlStatementParameters(array2censored($l)), true), 'mysql/insertrow.' . $t);

        $i = mysqlQuery($c, $q, $a);

        // var_dump( $t . '/' . $i );

        // TODO qui bisogna trovare una soluzione più robusta
        memcacheCleanFromIndex($t);
        memcacheCleanFromIndex($t . '_static');

        $static = getStaticView(NULL, $c, $t);

        if (! empty($static)) {

            $function = 'update' . implode('', array_map('ucfirst', explode('_', $static)));

            if (function_exists($function)) {

                $function($i);

                logger('aggiornata view statica ' . $t . ' per id #' . $i, 'static');
            }

            // mysqlQuery( $c, 'REPLACE INTO ' . $static . ' SELECT * FROM ' . $t . '_view WHERE id = ?', array( array( 's' => $i ) ) );
            // logger( 'aggiornata view statica ' . $t . ' per id #' . $d['id'], 'static' );

        }

        return $i;
    }

    /**
     * FUNZIONI PER LA COMPOSIZIONE DELLE QUERY
     */

    /**
     * restituisce l'elenco dei nomi di colonna per una query a partire dalle chiavi di un array
     *
     * Questa funzione prende le chiavi dell'array, le racchiude fra backtick e le unisce separate da virgola, pronte per
     * la lista delle colonne di una INSERT; con un array vuoto restituisce una stringa vuota.
     *
     * @param       array       $a      l'array associativo con i nomi delle colonne in chiave
     *
     * @return      string              l'elenco delle colonne, es. `id`, `nome`
     *
     */
    function array2mysqlFieldnames($a)
    {

        return implode(', ', addStr2arrayElements(array_keys($a), '`', '`'));
    }

    /**
     * restituisce l'elenco dei segnaposto per una query a partire da un array
     *
     * Questa funzione restituisce tanti segnaposto ? separati da virgola quanti sono gli elementi dell'array, pronti per la
     * clausola VALUES di un prepared statement; con un array vuoto restituisce una stringa vuota.
     *
     * @param       array       $a      l'array dei valori
     *
     * @return      string              l'elenco dei segnaposto, es. ?, ?, ?
     *
     */
    function array2mysqlPlaceholders($a)
    {

        return implode(', ', array_fill(0, count($a), '?'));
    }

    /**
     * restituisce la clausola di aggiornamento per ON DUPLICATE KEY UPDATE
     *
     * Questa funzione restituisce, per ogni chiave dell'array, l'assegnamento `colonna` = VALUES( `colonna` ), cioè
     * l'aggiornamento della riga esistente con i valori che si stavano inserendo. Per la colonna id vuota usa invece
     * LAST_INSERT_ID( `id` ): in questo modo, quando la INSERT trova un duplicato su una chiave unica e aggiorna la riga
     * esistente, l'ID restituito da MySQL è quello della riga esistente e non zero, e mysqlInsertRow() può restituirlo.
     *
     * @param       array       $a      l'array associativo della riga, con i nomi delle colonne in chiave
     *
     * @return      string              la clausola di aggiornamento, senza le parole ON DUPLICATE KEY UPDATE
     *
     */
    function array2mysqlDuplicateKeyUpdateValues($a)
    {

        $r = array();

        foreach (array_keys($a) as $k) {

            //        $r[] = '`' . $k . '` = ' . ( ( $k == 'id' ) ? 'LAST_INSERT_ID' : 'VALUES' ) . '( `' . $k . '` )';
            $r[] = '`' . $k . '` = ' . (($k == 'id' && empty($a[$k])) ? 'LAST_INSERT_ID' : 'VALUES') . '( `' . $k . '` )';
        }

        return implode(', ', $r);
    }

    /**
     * trasforma un array associativo in parametri per un prepared statement
     *
     * Questa funzione trasforma ogni valore dell'array nel formato array( 's' => valore ) atteso da mysqlQuery(),
     * conservando le chiavi: il risultato è quindi indicizzato per nome di colonna, e mysqlPreparedQuery() usa la chiave
     * 'id' per restituire l'ID di una INSERT che non ne genera uno. Tutti i valori sono legati come stringhe.
     *
     * TODO la sostituzione della virgola decimale con il punto è condizionata a is_numeric(), che su una stringa con la
     * virgola ( es. '10,5' ) restituisce false: la sostituzione quindi non avviene mai. In mysqlInsertRow() il lavoro lo fa
     * già string2num().
     *
     * @param       array       $a      l'array associativo dei valori
     *
     * @return      array               l'array dei parametri, con le stesse chiavi
     *
     */
    function array2mysqlStatementParameters($a)
    {

        $r = array();

        // OK foreach( $a as $v ) {
        foreach ($a as $k => $v) {

            if (is_numeric($v)) {
                $v = str_replace(',', '.', $v);
            }

            // OK $r[] = array( 's' => $v );
            $r[$k] = array('s' => $v);
        }

        return $r;
    }

    /**
     * divide un testo SQL nelle singole istruzioni
     *
     * Questa funzione divide un testo SQL in istruzioni terminate da punto e virgola, senza farsi ingannare dai punti e
     * virgola che stanno dentro stringhe fra apici singoli o doppi e dentro i commenti; gli spazi iniziali di ogni
     * istruzione vengono scartati, il punto e virgola finale resta. I commenti non vengono tolti: fanno parte
     * dell'istruzione che li contiene. Se il testo non contiene istruzioni restituisce un array vuoto. Al momento non viene
     * chiamata da nessuna parte del framework.
     *
     * @param       string      $sql_text   il testo SQL da dividere
     *
     * @return      array                   l'elenco delle istruzioni, eventualmente vuoto
     *
     */
    function split_sql($sql_text)
    {
        // Return array of ; terminated SQL statements in $sql_text.
        $re_split_sql = '%(?#!php/x re_split_sql Rev:20170816_0600)
                # Match an SQL record ending with ";"
                \s*                                     # Discard leading whitespace.
                (                                       # $1: Trimmed non-empty SQL record.
                (?:                                   # Group for content alternatives.
                    \'[^\'\\\\]*(?:\\\\.[^\'\\\\]*)*\'  # Either a single quoted string,
                | "[^"\\\\]*(?:\\\\.[^"\\\\]*)*"      # or a double quoted string,
                | /\*[^*]*\*+(?:[^*/][^*]*\*+)*/      # or a multi-line comment,
                | \#.*                                # or a # single line comment,
                | --.*                                # or a -- single line comment,
                | [^"\';#]                            # or one non-["\';#-]
                )+                                    # One or more content alternatives
                (?:;|$)                               # Record end is a ; or string end.
                )                                       # End $1: Trimmed SQL record.
                %x';  // End $re_split_sql.
        if (preg_match_all($re_split_sql, $sql_text, $matches)) {
            return $matches[1];
        }
        return array();
    }

    /**
     * FUNZIONI PER LE VISTE STATICHE
     */

    /**
     * restituisce il nome della vista statica di una tabella, se esiste
     *
     * Questa funzione cerca in information_schema la tabella <t>_view_static, con la cache su memcache se $m non è vuoto,
     * e ne restituisce il nome se esiste, altrimenti false. È usata da mysqlInsertRow() per sapere se dopo una scrittura
     * deve aggiornare la vista statica.
     *
     * NOTA la ricerca non filtra su TABLE_SCHEMA, quindi trova la vista statica anche se esiste in un altro database dello
     * stesso server; lo stesso vale per getStaticViewExtension().
     *
     * @param       object      $m      la connessione a memcache ( NULL per non usare la cache )
     * @param       object      $c      la connessione mysqli
     * @param       string      $t      il nome della tabella, senza suffissi
     *
     * @return      mixed               il nome della vista statica, o false se non esiste
     *
     */
    function getStaticView($m, $c, $t)
    {

        // verifico se esiste la view statica
        $stv = mysqlSelectCachedValue(
            $m,
            $c,
            'SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = ?',
            array(array('s' => $t . '_view_static'))
        );

        // se esiste la vista statica...
        if (! empty($stv)) {
            return $t . '_view_static';
        } else {
            return false;
        }
    }

    /**
     * aggiorna una vista statica dalla vista che la alimenta
     *
     * Le viste statiche sono tabelle materializzate: si tengono aggiornate ricopiandoci dentro
     * la vista omonima. Storicamente lo si faceva con
     *
     *     REPLACE INTO <t>_view_static SELECT * FROM <t>_view WHERE id = ?
     *
     * che ha due difetti gravi, entrambi gia' costati incidenti in produzione:
     *
     * 1. SELECT * accoppia le colonne PER POSIZIONE, quindi appena vista e statica divergono di
     *    una colonna la query fallisce con ERROR 1136 ( Column count doesn't match value count );
     * 2. nessuno ne controllava l'esito, quindi il fallimento era MUTO: la riga finiva nella
     *    tabella di partenza e non nella statica, e siccome ogni elenco legge la statica quando
     *    esiste ( vedi getStaticView ), il sintomo era "l'elenco non si aggiorna piu'" - senza
     *    alcun errore da nessuna parte, e a giorni di distanza dalla migrazione che l'aveva causato.
     *
     * Questa funzione elenca le colonne esplicitamente e usa solo quelle presenti da entrambe le
     * parti: una colonna aggiunta alla vista e non ancora alla statica smette di essere un guasto
     * e diventa un avviso nel log. L'esito viene controllato.
     *
     * @param mysqli $c  connessione
     * @param string $t  nome della tabella ( senza suffissi: 'anagrafica', non 'anagrafica_view' )
     * @param mixed  $i  id della riga da aggiornare, un array di id, oppure NULL per l'intera vista
     *
     * @return bool true se l'aggiornamento e' andato a buon fine
     */
    function refreshStaticView($c, $t, $i = null)
    {

        // le colonne di vista e statica cambiano solo con una migrazione: si leggono una volta
        // per richiesta e si tengono qui
        static $colonne = array();

        $view   = $t . '_view';
        $static = $t . '_view_static';

        if (! isset($colonne[$t])) {

            $cols = array();
            foreach (array($view, $static) as $oggetto) {
                $cols[$oggetto] = mysqlSelectColumn(
                    'COLUMN_NAME',
                    $c,
                    'SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = ? ORDER BY ORDINAL_POSITION',
                    array(array('s' => $oggetto))
                );
            }

            // LA STATICA CHE NON C'E' NON E' UN ERRORE ( 2026-09-14 )
            //
            // Non tutte le tabelle hanno una vista materializzata: ne hanno una quelle che
            // alimentano tendine grosse ( anagrafica, articoli, attivita', offerte_attive, todo ),
            // e l'elenco canonico sta in _usr/_database/_patch/_080000999999.static.sql. I
            // controller finally pero' chiamano questa funzione senza chiedersi se la statica
            // esista: _documenti.articoli.finally.php la chiama per `documenti_articoli`, che una
            // statica non ce l'ha in nessun deploy.
            //
            // Il risultato era una riga a LOG_ERR in var/log/mysql.err a OGNI salvataggio di riga
            // documento, con scritto "nessuna colonna in comune" - che descrive male anche il
            // fatto, perche' le colonne non sono incompatibili, la tabella proprio non esiste.
            // Log a livello di errore che non segnalano un errore sono il modo piu' sicuro per
            // insegnare a non guardare i log.
            //
            // Resta LOG_ERR il caso vero: statica che esiste e non ha nulla da spartire con la
            // vista, che vuol dire migrazione a meta'.
            if (empty($cols[$static])) {
                logger(
                    'la vista materializzata ' . $static . ' non esiste su questo deploy: niente da aggiornare',
                    'mysql',
                    LOG_INFO
                );
                $colonne[$t] = array();
                return false;
            }

            // solo le colonne che esistono da entrambe le parti
            $comuni = array_values(array_intersect($cols[$view], $cols[$static]));
            $manca  = array_diff($cols[$view], $cols[$static]);

            if (! empty($manca)) {
                logger(
                    'la vista ' . $view . ' ha colonne che ' . $static . ' non ha ( ' . implode(', ', $manca) . ' ): '
                    . 'la statica va allineata, per ora quelle colonne non vengono copiate',
                    'mysql',
                    LOG_WARNING
                );
            }

            $colonne[$t] = $comuni;
        }

        if (empty($colonne[$t])) {
            logger('impossibile aggiornare ' . $static . ': nessuna colonna in comune con ' . $view, 'mysql', LOG_ERR);
            return false;
        }

        $campi = '`' . implode('`, `', $colonne[$t]) . '`';
        $sql   = 'REPLACE INTO `' . $static . '` ( ' . $campi . ' ) SELECT ' . $campi . ' FROM `' . $view . '`';
        $args  = array();

        /**
         * Gli id interi vanno scritti DENTRO la query, non legati come parametri.
         *
         * Stessa ragione della lettura per id nel controller: MariaDB 10.3 non spinge la
         * condizione dentro una vista con GROUP BY quando il valore arriva da un segnaposto, e la
         * vista viene materializzata per intero e poi filtrata. Su un deploy con 5.400 contratti,
         * `SELECT * FROM iscrizioni_view WHERE id = ?` costa 0,636 s contro 0,013 s della stessa
         * query col valore scritto — e questa funzione la chiamano i controller `finally` a ogni
         * salvataggio, anche piu' volte.
         *
         * Si scrivono nella query solo gli id fatti di sole cifre e senza zeri iniziali
         * ( `(string) $u === (string) (int) $u` ), passati per `(int)`: il valore che finisce nel
         * testo SQL e' identico a quello che si sarebbe legato, mai una sua reinterpretazione, e
         * niente che arrivi da fuori puo' raggiungere la query. Gli id non interi ( es. quelli degli
         * articoli, `1784825140.7973` ) restano sul prepared statement.
         *
         * ⚠ La rete sotto e la sua chiave di configurazione sono le stesse del controller, e per lo
         * stesso motivo: sulle viste che raggruppano su due colonne `id` di tabelle diverse il
         * valore scritto fa fallire la query con `ERRORE 1052 ... in order clause is ambiguous`. Un
         * deploy che le conosce le dichiara in `$cf['controller']['no_id_inline'][ <tabella> ]`;
         * se una scappa, la query si rifa' col segnaposto e la tabella si segna per il resto della
         * richiesta, cosi' l'unico costo e' un giro in piu' e mai il risultato.
         */
        $intero = function ($u) {
            return ctype_digit((string) $u) && (string) $u === (string) (int) $u;
        };

        $dove       = '';
        $doveInline = '';

        if (is_array($i)) {

            // elenco di id: un segnaposto per ciascuno
            $i = array_values(array_filter($i, 'strlen'));
            if (empty($i)) {
                return true;
            }
            $dove = ' WHERE id IN ( ' . implode(', ', array_fill(0, count($i), '?')) . ' )';
            foreach ($i as $uno) {
                $args[] = array('s' => $uno);
            }
            if (count(array_filter($i, $intero)) === count($i)) {
                $doveInline = ' WHERE id IN ( ' . implode(', ', array_map('intval', $i)) . ' )';
            }

        } elseif (! is_null($i)) {
            $dove = ' WHERE id = ?';
            $args = array(array('s' => $i));
            if ($intero($i)) {
                $doveInline = ' WHERE id = ' . (int) $i;
            }
        }

        // viste dichiarate ambigue in configurazione, o gia' scoperte tali in questa richiesta
        if (! empty($GLOBALS['cf']['controller']['no_id_inline'][$t])) {
            $doveInline = '';
        }

        $esito = false;

        if (! empty($doveInline)) {

            $esito = mysqlQuery($c, $sql . $doveInline);

            if (! empty(mysqli_errno($c))) {
                $GLOBALS['cf']['controller']['no_id_inline'][$t] = true;
                logger(
                    'aggiornamento di ' . $static . ' con id nella query non riuscito ( ' . mysqli_error($c) . ' ): '
                    . 'si riprova con il parametro, e per il resto della richiesta si usa il parametro',
                    'mysql',
                    LOG_WARNING
                );
                $esito = mysqlQuery($c, $sql . $dove, $args);
            }

        } else {
            $esito = mysqlQuery($c, $sql . $dove, $args);
        }

        if (! empty(mysqli_errno($c))) {
            logger(
                'aggiornamento di ' . $static . ' fallito: ' . mysqli_error($c),
                'mysql',
                LOG_ERR
            );
            return false;
        }

        return (bool) $esito;
    }

    /**
     * restituisce il suffisso da usare per leggere una tabella dalla sua vista
     *
     * Questa funzione fa la stessa ricerca di getStaticView() e restituisce '_view_static' se la tabella ha una vista
     * statica, '_view' altrimenti; il chiamante la accoda al nome della tabella per ottenere l'oggetto da cui leggere
     * ( es. in controller() e nel titolo delle schede tramite mysqlSelectLabel() ).
     *
     * @param       object      $m      la connessione a memcache
     * @param       object      $c      la connessione mysqli
     * @param       string      $t      il nome della tabella, senza suffissi
     *
     * @return      string              '_view_static' oppure '_view'
     *
     */
    function getStaticViewExtension($m, $c, $t)
    {

        // verifico se esiste la view statica
        $stv = mysqlSelectCachedValue(
            $m,
            $c,
            'SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = ?',
            array(array('s' => $t . '_view_static'))
        );

        // se esiste la vista statica...
        if (! empty($stv)) {
            return '_view_static';
        } else {
            return '_view';
        }
    }
