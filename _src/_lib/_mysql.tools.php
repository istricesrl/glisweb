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
     * cleanStaticView()                        | toglie da una vista statica le righe che non esistono piu' nella tabella
     * syncStaticView()                         | riallinea a lotti una vista statica con la tabella da cui nasce
     * getStaticViewExtension()                 | restituisce il suffisso da usare per leggere una tabella dalla sua vista
     *
     * funzioni per le patch del database
     * ----------------------------------
     * Le funzioni in questo gruppo leggono i file di _usr/_database/_patch/ ( e di usr/database/patch/ ) e li applicano al
     * database. Sono l'unica implementazione delle regole delle patch: le chiamano il task _src/_api/_task/_mysql.patch.php
     * con la connessione del framework, e gli script _src/_sh/_mysql.upgrade.sh e _src/_sh/_database.rebuild.check.sh
     * ( quest'ultimo tramite _src/_cli/_mysql.patch.php ) con una connessione mysqli aperta da loro, senza il bootstrap.
     * Per questo non usano nessun'altra funzione del framework, né costanti, né $cf: si possono includere da sole.
     *
     * funzione                                 | descrizione
     * -----------------------------------------|---------------------------------------------------------------
     * mysqlPatchFiles()                        | restituisce i file di patch, standard e custom, nell'ordine di applicazione
     * mysqlPatchLevel()                        | restituisce il livello di patch del database
     * mysqlPatchRead()                         | legge dai file le patch da applicare sopra un livello
     * mysqlPatchApply()                        | applica le patch e le registra in __patch__, fermandosi al primo errore
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
     * timerNow()                       | core ( _src/_config.php )
     * timerDiff()                      | core ( _src/_config.php )
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
     * 2026-09-29       | Fabio Mosti          | funzioni per le patch del database, prima duplicate nel task e in due script
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
     * TTL di default; se è false viene forzata la lettura dal database come descritto per mysqlCachedQuery().
     *
     * @param       array       $i      l'indice della cache ( di solito $cf['memcache']['index'] ), modificato sul posto
     * @param       object      $m      la connessione a memcache
     * @param       object      $c      la connessione mysqli
     * @param       string      $q      la query da eseguire
     * @param       mixed       $p      i parametri del prepared statement, o false per una query semplice
     * @param       int         $t      il TTL in secondi della chiave di cache ( 0 per il default, false per forzare la lettura dal database )
     * @param       array       $e      l'array in cui accumulare gli errori, modificato sul posto
     *
     * @return      mixed               il risultato della query come per mysqlQuery()
     *
     */
    function mysqlCachedIndexedQuery(&$i, $m, $c, $q, $p = false, $t = 0, &$e = array()) {

        // false va passato così com'è a mysqlCachedQuery(), per cui vuol dire forzare la lettura dal database
        if (defined('MEMCACHE_DEFAULT_TTL') && $t !== false && $t == 0) {
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
     * Passando $t === false la cache non viene letta: la query viene eseguita sul database e il risultato viene riscritto
     * in cache con il TTL di default, così che anche le letture successive vedano il valore aggiornato.
     *
     * NOTA chiamata direttamente ( e non tramite mysqlCachedIndexedQuery() ) questa funzione scrive l'indice in un array
     * locale che va perso, quindi la query non viene invalidata dalle scritture sulle sue tabelle e scade solo per TTL.
     *
     * @param       object      $m      la connessione a memcache
     * @param       object      $c      la connessione mysqli
     * @param       string      $q      la query da eseguire
     * @param       mixed       $p      i parametri del prepared statement, o false per una query semplice
     * @param       int         $t      il TTL in secondi della chiave di cache ( 0 per il default, false per forzare la lettura dal database )
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

        // NOTA il confronto $t == 0 da solo è vero anche per $t === false, che veniva così sostituito dal TTL di default
        // prima di arrivare al controllo qui sotto, e la lettura forzata dal database non scattava mai ( 2026-09-24 )
        if (defined('MEMCACHE_DEFAULT_TTL') && $t !== false && $t == 0) {
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

                // con $t === false il risultato letto dal database aggiorna la cache con il TTL di default, perché
                // memcacheWrite() con false scriverebbe una chiave senza scadenza
                memcacheWrite($m, $k, $d, (($t === false) ? ((defined('MEMCACHE_DEFAULT_TTL')) ? MEMCACHE_DEFAULT_TTL : 0) : $t));

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
     * Questa funzione cerca il risultato della query nel file var/cache/mysql/<md5 di query e parametri>; se il file esiste
     * ed è stato scritto da meno di $t secondi ne restituisce il contenuto, altrimenti esegue la query con mysqlQuery() e ne
     * scrive il risultato serializzato nel file. Come per mysqlCachedQuery() un TTL zero vuol dire MEMCACHE_DEFAULT_TTL,
     * se è definita, e un TTL che resta zero vuol dire nessuna scadenza; passando $t === false la query viene eseguita
     * comunque e il file riscritto. Il risultato di una query fallita non viene scritto su disco. Al momento non viene
     * chiamata da nessuna parte del framework.
     *
     * NOTA il parametro $i è accettato ma ignorato: il file di cache non viene invalidato dalle scritture sulle tabelle
     * lette dalla query, perché memcacheCleanFromIndex() cancella chiavi di memcache e non file, e scade solo per TTL.
     *
     * @param       object      $c      la connessione mysqli
     * @param       string      $q      la query da eseguire
     * @param       mixed       $p      i parametri del prepared statement, o false per una query semplice
     * @param       int         $t      il TTL in secondi della cache ( 0 per il default, false per forzare la lettura dal database )
     * @param       array       $e      l'array in cui accumulare gli errori, modificato sul posto
     * @param       array       $i      l'indice della cache ( non usato )
     *
     * @return      mixed               il risultato della query come per mysqlQuery(), dal database o dal disco
     *
     */
    //    function mysqlDiskQuery( $c, $q, $p = false, $t = MEMCACHE_DEFAULT_TTL, &$e = array() ) {
    function mysqlDiskQuery($c, $q, $p = false, $t = 0, &$e = array(), &$i = array())
    {

        // TTL di default, come per mysqlCachedQuery()
        if (defined('MEMCACHE_DEFAULT_TTL') && $t !== false && $t == 0) {
            $t = MEMCACHE_DEFAULT_TTL;
        }

        // calcolo la chiave della query
        $k = md5($q . serialize($p));

        // cerco il valore in cache
        #        $r = memcacheRead( $m, $k );

        // NOTA la scadenza si legge dall'ora di modifica del file ( TTL zero vuol dire nessuna scadenza, come su memcache ),
        // e un file che contiene false ( una query fallita, scritta prima del 2026-09-24 ) vale come assente
        $r = false;
        if ($t !== false && file_exists(DIR_BASE . 'var/cache/mysql/' . $k) && (empty($t) || filemtime(DIR_BASE . 'var/cache/mysql/' . $k) > time() - $t)) {
            // NOTA writeToFile() aggiunge un a capo in fondo, che da PHP 8.3 fa emettere a unserialize() un avviso di dati in
            // eccesso; un dato serializzato non finisce mai con uno spazio, quindi toglierlo è sicuro ( 2026-09-24 )
            $r = unserialize(rtrim(file_get_contents(DIR_BASE . 'var/cache/mysql/' . $k)));
        }

        if ($r === false) {

            $r = mysqlQuery($c, $q, $p, $e);

            //    $h = fopen( DIR_BASE . 'var/cache/mysql/' . $k, 'w+' );
            //    fwrite( $h, serialize( $r ) );

            // una query fallita non si scrive su disco, altrimenti il false verrebbe restituito da lì in poi
            if ($r !== false) {
                writeToFile(serialize($r), DIR_BASE . 'var/cache/mysql/' . $k);
            }

        } else {

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
     * errore MySQL l'errore viene loggato, aggiunto all'array $e sotto il suo codice e la funzione restituisce false,
     * anche quando mysqli lo segnala con un'eccezione ( il comportamento di default da PHP 8.1 ); un'eccezione senza codice
     * di errore sulla connessione viene loggata e la funzione restituisce false senza toccare $e.
     *
     * Per le query con parametri $e viene passato a mysqlPreparedQuery(), che lo valorizza nella stessa forma.
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

                    // NOTA le patch del database mettono dentro PREPARE le operazioni che dipendono dallo schema ( SET della
                    // query guardata da information_schema, PREPARE, EXECUTE, DEALLOCATE ); fino al 29/09/2026 queste tre
                    // cadevano nel default, non venivano eseguite e _mysql.patch.php registrava comunque la patch come fatta;
                    // dallo stesso giorno le patch non passano più di qui ma da mysqlPatchApply(), che usa mysqli direttamente
                    case 'PREPARE':
                    case 'EXECUTE':
                    case 'DEALLOCATE':
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

                // NOTA da PHP 8.1 mysqli solleva per default mysqli_sql_exception sugli errori SQL ( il framework non chiama
                // mysqli_report() ), e uscendo da qui con return false l'errore non arrivava mai in $e: chi lo usa per
                // accorgersi del fallimento, come mysqlSelectLabel(), non se ne accorgeva; se la connessione ha un codice
                // di errore si prosegue verso la gestione errore qui sotto, come su PHP 7 ( 2026-09-24 )
                if (mysqli_errno($c)) {
                    $r = false;
                } else {
                    logger(__FUNCTION__ . '() errore ' . mysqli_error($c) . ' durante l\'esecuzione della query: ' . $q, 'mysql', LOG_ERR);
                    logger(__FUNCTION__ . '() errore ' . mysqli_error($c) . ' durante l\'esecuzione della query: ' . $q . ((! empty($p)) ? '§dati -> ' . print_l($p) : ''), 'details/mysql/query', LOG_ERR);
                    return false;
                }

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
     * Se invece fallisce l'esecuzione senza eccezione ( mysqli_report() disattivato, o PHP precedente alla 8.1 ) l'errore
     * viene loggato ma il valore restituito non cambia ( vedi la nota nel corpo ): per una INSERT fallita si ottiene quindi
     * l'ID passato nei parametri, se c'è.
     *
     * In tutti i casi di errore MySQL, eccezione compresa, l'errore viene aggiunto all'array $e sotto il suo codice nella
     * stessa forma di mysqlQuery() ( 1062 e 1054 con un messaggio fisso, gli altri con il messaggio di MySQL ); una
     * connessione vuota o un'eccezione senza codice di errore non toccano $e.
     *
     * @param       object      $c          la connessione mysqli
     * @param       string      $q          la query da eseguire, con i segnaposto ?
     * @param       array       $params     i parametri da legare ai segnaposto, nell'ordine
     * @param       array       $e          l'array in cui accumulare gli errori, indicizzato per codice di errore, modificato sul posto
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

            // codice e messaggio dell'eventuale errore MySQL
            $errno = 0;
            $error = NULL;

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
                    // Qui si logga, senza cambiare il valore di ritorno: cambiarlo
                    // vorrebbe dire toccare il comportamento di ogni chiamante del framework, e
                    // non e' una decisione da prendere dentro questa funzione. L'errore adesso
                    // pero' si vede, ed e' il minimo perche' sia diagnosticabile; dal 2026-09-24
                    // finisce anche in $e, come gli errori sollevati con un'eccezione.
                    //
                    // Si usa logger() e non logWrite(): questa e' una libreria "tools", che per
                    // convenzione non dipende da $cf, mentre logWrite() sta in _log.utils.php.
                    // Tutto il resto del file logga cosi'.
                    if ($xStatement === false) {

                        $errno = mysqli_stmt_errno($pq);
                        $error = mysqli_stmt_error($pq);

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
                            $r = mysqlFetchPreparedResult($pq);
                            break;

                        case 'INSERT':
                            $id = mysqli_stmt_insert_id($pq);
                            $r = ((! empty($id)) ? $id : ((isset($params['id']['s'])) ? $params['id']['s'] : NULL));
                            break;

                        case 'REPLACE':
                        case 'UPDATE':
                        case 'DELETE':
                        case 'TRUNCATE':
                        default:
                            $r = mysqli_stmt_affected_rows($pq);
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

                    $errno = mysqli_errno($c);
                    $error = mysqli_error($c);

                    // restituisco false
                    $r = false;
                }

            } catch (Exception $ex) {

                // NOTA da PHP 8.1 mysqli solleva per default mysqli_sql_exception anche sugli errori di esecuzione dello
                // statement ( il framework non chiama mysqli_report() ), e quindi quasi tutti gli errori delle query con
                // parametri arrivano qui; il codice di errore MySQL è il codice dell'eccezione ( 2026-09-24 )
                if ($ex instanceof mysqli_sql_exception) {
                    $errno = $ex->getCode();
                    $error = $ex->getMessage();
                } else {
                    $errno = mysqli_errno($c);
                    $error = mysqli_error($c);
                }

                logger(__FUNCTION__ . '() errore ' . mysqli_error($c) . ' durante la preparazione della query: ' . $q, 'mysql', LOG_ERR);
                logger(__FUNCTION__ . '() errore ' . mysqli_error($c) . ' durante la preparazione della query: ' . $q . ((! empty($params)) ? '§dati -> ' . print_l($params) : ''), 'details/mysql/query', LOG_ERR);
                $r = false;
            }

            // gestione specifici errori, come in mysqlQuery(): controller() legge $e per rispondere 409 sui dati duplicati
            // e 400 sulle colonne errate, e le sue scritture passano tutte da qui ( 2026-09-24 )
            if ($errno) {

                switch ($errno) {

                    case 1062:
                        $e['1062'][] = 'errore MySQL 1062, dati dupilcati';
                        break;

                    case 1054:
                        $e['1054'][] = 'errore MySQL 1054, nome colonna errato';
                        break;

                    default:
                        $e[$errno][] = $error;
                        break;
                }

            }

            // restituisco il risultato
            return $r;

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
     * r                | array di condizioni SQL aggiuntive per la ricerca delle righe figlie, messe in AND ( es. 'id_genitore IS NULL' )
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
     * NOTA la ricerca delle righe figlie scrive $o direttamente nella query, fra virgolette, invece di usare un parametro.
     *
     * @param       object      $c      la connessione mysqli
     * @param       string      $t      il nome della tabella in cui si trova il record principale da duplicare
     * @param       string      $o      l'ID dell'oggetto da duplicare
     * @param       string      $n      l'ID da dare all'oggetto duplicato, NULL per usare l'AUTO_INCREMENT
     * @param       array       $x      l'array delle tabelle e delle sostituzioni descritto qui sopra, modificato sul posto
     *                                  ( la funzione vi aggiunge i default e i campi di collegamento delle tabelle figlie )
     * @param       array       $y      l'array in cui viene scritta la riga duplicata, modificato sul posto; le righe
     *                                  figlie finiscono sotto la chiave col nome della loro tabella, come elenco
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
                // NOTA ogni riga figlia duplicata si aggiunge in fondo all'elenco della sua tabella; passando
                // $y[<tabella>] ogni chiamata lo sovrascriveva e restava solo l'ultima ( 2026-09-24 )
                mysqlDuplicateRowRecursive($c, $ksr['TABLE_NAME'], $rl['id'], NULL, $x['t'][$t], $y[$ksr['TABLE_NAME']][]);
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
     * restituisce l'ID con cui la riga è stata scritta, cioè $x['id'] se era stato passato, altrimenti $n, oppure NULL se
     * non c'è né l'uno né l'altro, e in quel caso $y è un array vuoto.
     *
     * NOTA essendo una INSERT IGNORE, se l'ID passato esiste già la riga non viene inserita ma la funzione restituisce
     * comunque quell'ID, e in $y finisce la riga che c'era già.
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

        // salvo l'id che avrà la nuova riga: $x['id'] se passato, altrimenti $n ( così lo scrive array_merge() qui sotto )
        $id = isset($x['id']) ? $x['id'] : $n;

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

        // NOTA i ruoli di $id e $n sono stati scambiati avanti e indietro: nel 2023 ( 6843f62bf, duplicazione del catalogo )
        // il ripiego era $n, poi è tornato $x['id'] e $n è stato perso, per cui duplicaProdotto() e duplicaArticolo(), che
        // passano $n per tabelle senza AUTO_INCREMENT, ricevevano NULL e collegavano le righe figlie a NULL; ora il ripiego
        // è l'ID effettivamente scritto nella nuova riga, $x['id'] o $n ( 2026-09-24 )

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
     * NOTA la funzione assume che ogni tabella coinvolta abbia la colonna id: la usa per cancellare la riga e per scendere
     * nelle righe figlie.
     *
     * @param       object      $m      la connessione a memcache
     * @param       object      $c      la connessione mysqli
     * @param       string      $t      il nome della tabella
     * @param       string      $d      l'ID del record da eliminare
     *
     * @return      mixed               il numero di righe eliminate dalla DELETE della riga richiesta, false se la query fallisce
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
                'INNER JOIN information_schema.referential_constraints ON ( information_schema.referential_constraints.CONSTRAINT_SCHEMA = information_schema.key_column_usage.CONSTRAINT_SCHEMA ' .
                'AND information_schema.referential_constraints.CONSTRAINT_NAME = information_schema.key_column_usage.CONSTRAINT_NAME ' .
                'AND information_schema.referential_constraints.REFERENCED_TABLE_NAME = information_schema.key_column_usage.REFERENCED_TABLE_NAME ' .
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
                // NOTA l'ID della riga figlia è la sua colonna id, la stessa che usa la DELETE qui sotto; prima si passava
                // $r1[ $l1 ], che coincide solo perché tutte le chiavi esterne dello schema puntano a id ( 2026-09-24 )
                mysqlDeleteRowRecursive($m, $c, $t1, $r1['id']);
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
        // restituisco l'esito della cancellazione ( _todo.delete.php lo mette in $status, e fino al 2026-09-24 riceveva NULL )
        return $r;

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
     * 'id' per restituire l'ID di una INSERT che non ne genera uno. Tutti i valori sono legati come stringhe. Le stringhe
     * che sono un numero con la virgola decimale ( es. '10,5' o '-0,25', con una sola virgola e nient'altro che cifre )
     * vengono convertite con il punto; tutte le altre, compresi elenchi come '1,2,3' e testi con delle virgole, restano
     * invariate.
     *
     * NOTA una stringa come '1,5' viene convertita anche se nelle intenzioni era un elenco di due valori. L'unico chiamante,
     * mysqlInsertRow(), passa i valori già normalizzati da string2num(), che converte le stesse stringhe ( e altre ), per cui
     * lì la conversione non cambia niente.
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

            // NOTA is_numeric() su una stringa con la virgola ( es. '10,5' ) restituisce false, quindi la sostituzione non
            // avveniva mai; si convertono solo le stringhe fatte di cifre con una sola virgola decimale, così un elenco
            // come '1,2,3' o un testo con delle virgole restano come sono; is_numeric() resta perché trasforma in stringa
            // i numeri passati come int o float, come ha sempre fatto ( 2026-09-24 )
            if (is_numeric($v) || (is_string($v) && preg_match('/^-?[0-9]+,[0-9]+$/', trim($v)))) {
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
            // alimentano tendine grosse ( anagrafica, articoli, attivita', offerte, todo ),
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
     * toglie da una vista materializzata le righe che non esistono piu' nella tabella
     *
     * refreshStaticView() riscrive con REPLACE le righe che la vista restituisce, quindi non tocca quelle
     * cancellate dalla tabella: chi cancella in blocco ( i task di pulizia delle pianificazioni, di eliminazione
     * di eventi e progetti ) chiama questa funzione prima di refreshStaticView(). Se la statica non esiste sul
     * deploy non fa niente.
     *
     * Le statiche il cui nome non coincide con una tabella ( offerte_view_static nasce da documenti ) passano
     * la tabella base in $b e la condizione che ne seleziona le righe in $w, come a syncStaticView(): in quel
     * caso si tolgono anche le righe la cui riga base esiste ma non soddisfa piu' la condizione ( un documento
     * che ha cambiato tipologia e non e' piu' un'offerta ).
     *
     * @param mysqli $c  connessione
     * @param string $t  nome della tabella ( senza suffissi: 'attivita', non 'attivita_view_static' )
     * @param string $b  tabella base, se diversa da $t
     * @param string $w  condizione SQL sulla tabella base che seleziona le righe della vista
     *
     * @return bool true se la pulizia e' andata a buon fine o non serviva
     */
    function cleanStaticView($c, $t, $b = null, $w = null)
    {

        if (empty($b)) {
            $b = $t;
        }

        if (! preg_match('/^[a-z0-9_]+$/', $t) || ! preg_match('/^[a-z0-9_]+$/', $b)) {
            return false;
        }

        $static = $t . '_view_static';

        $esiste = mysqlSelectValue(
            $c,
            'SELECT count(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = ?',
            array(array('s' => $static))
        );

        if (empty($esiste)) {
            return true;
        }

        mysqlQuery(
            $c,
            'DELETE `' . $static . '` FROM `' . $static . '` LEFT JOIN `' . $b . '` ON `' . $b . '`.id = `' . $static . '`.id'
                . ((! empty($w)) ? ' AND ( ' . $w . ' )' : '')
                . ' WHERE `' . $b . '`.id IS NULL'
        );

        return empty(mysqli_errno($c));
    }

    /**
     * riallinea a lotti una vista materializzata con la tabella da cui nasce
     *
     * E' la rete di sicurezza delle viste statiche: i controller finally e le scritture via PHP le
     * aggiornano da soli, ma importatori, travasi, script SQL e qualunque scrittura diretta possono
     * lasciarle indietro. Questa funzione cerca fino a $lotto righe rimaste indietro e le rigenera con
     * refreshStaticView(); i task *.view.static.popolazione sono wrapper su di lei, e chiamandola in
     * ciclo ( a mano con lws, o da una pianificazione ) la statica si rimette in pari un lotto alla volta.
     *
     * Una riga e' indietro quando nella statica manca, oppure ha timestamp_inserimento o
     * timestamp_aggiornamento NULL o piu' vecchi di quelli della tabella base: e' lo stesso criterio
     * dei vecchi task di popolazione, che pero' lavoravano UNA riga per chiamata. Per le tabelle
     * $correlate ( quelle che portano id_<entita> e che la vista legge, come anagrafica_categorie per
     * anagrafica ) e' indietro anche la riga la cui correlata e' piu' recente della statica.
     *
     * Dopo la rigenerazione i timestamp rimasti NULL si timbrano con l'ora corrente, come facevano i
     * task; quello di aggiornamento si porta anche all'ultima modifica delle correlate, altrimenti una
     * riga rigenerata per una correlata resterebbe "indietro" per sempre ( la vista copia il
     * timestamp della base, che puo' essere piu' vecchio ) e il ciclo non finirebbe mai.
     *
     * NIENTE RICALCOLO COMPLETO: si lavora solo a lotti. Il ricalcolo completo di una statica e' per le
     * emergenze ( task di svuotamento e poi popolazione ), mai una pianificazione.
     *
     * Le statiche il cui nome non coincide con una tabella ( offerte_view_static nasce da documenti )
     * passano la tabella base in $b e la condizione che ne seleziona le righe in $w, scritta sulla
     * tabella base per nome ( es. 'documenti.id_tipologia IN ( SELECT id FROM tipologie_documenti WHERE
     * se_offerta IS NOT NULL )' ): senza condizione, le righe della base che la vista non restituisce
     * risulterebbero mancanti a ogni giro. La stessa coppia va passata a cleanStaticView().
     *
     * Una statica senza le colonne dei timestamp ( todo_view_static, a oggi ) viene riallineata solo
     * per le righe mancanti, e lo si scrive nel log.
     *
     * @param mysqli $c  connessione
     * @param string $t  nome della vista senza suffissi ( 'anagrafica', non 'anagrafica_view_static' )
     * @param int    $l  quante righe riallineare al massimo in questa chiamata
     * @param array  $r  tabelle correlate: 'tabella' ( colonna id_<t> ) oppure 'tabella' => 'colonna'
     * @param string $b  tabella base, se diversa da $t
     * @param string $w  condizione SQL sulla tabella base che seleziona le righe della vista
     *
     * @return mixed     quante righe sono state riallineate, false se la rigenerazione e' fallita
     */
    function syncStaticView($c, $t, $l = 100, $r = array(), $b = null, $w = null)
    {

        // le colonne dei timestamp della statica cambiano solo con una migrazione
        static $colonne = array();

        if (empty($b)) {
            $b = $t;
        }

        if (! preg_match('/^[a-z0-9_]+$/', $t) || ! preg_match('/^[a-z0-9_]+$/', $b)) {
            return false;
        }

        $static = $t . '_view_static';
        $l      = max(1, (int) $l);

        if (! isset($colonne[$t])) {
            $colonne[$t] = mysqlSelectColumn(
                'COLUMN_NAME',
                $c,
                'SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = ?',
                array(array('s' => $static))
            );
        }

        // la statica che non c'e' non e' un errore, come in refreshStaticView()
        if (empty($colonne[$t])) {
            return 0;
        }

        $timestamp = in_array('timestamp_inserimento', $colonne[$t]) && in_array('timestamp_aggiornamento', $colonne[$t]);

        // condizione sulle righe della base
        $dove = (! empty($w)) ? '( ' . $w . ' ) AND ' : '';

        // righe mancanti o con i timestamp indietro
        if ($timestamp) {
            $indietro = '( `' . $static . '`.timestamp_inserimento IS NULL OR `' . $b . '`.timestamp_inserimento > `' . $static . '`.timestamp_inserimento )'
                . ' OR ( `' . $static . '`.timestamp_aggiornamento IS NULL OR `' . $b . '`.timestamp_aggiornamento > `' . $static . '`.timestamp_aggiornamento )';
        } else {
            logger('la vista materializzata ' . $static . ' non ha i timestamp: si riallineano solo le righe mancanti', 'static', LOG_WARNING);
            $indietro = '`' . $static . '`.id IS NULL';
        }

        $ids = mysqlSelectColumn(
            'id',
            $c,
            'SELECT `' . $b . '`.id FROM `' . $b . '` '
                . 'LEFT JOIN `' . $static . '` ON `' . $static . '`.id = `' . $b . '`.id '
                . 'WHERE ' . $dove . '( ' . $indietro . ' ) '
                . 'ORDER BY `' . $b . '`.id DESC '
                . 'LIMIT ' . $l
        );

        if (! is_array($ids)) {
            $ids = array();
        }

        // tabelle correlate: righe la cui correlata e' piu' recente della statica
        $correlate = array();
        foreach ($r as $k => $v) {
            if (is_int($k)) {
                $correlate[$v] = 'id_' . $t;
            } else {
                $correlate[$k] = $v;
            }
        }

        if ($timestamp) {
            foreach ($correlate as $tc => $fk) {

                if (count($ids) >= $l) {
                    break;
                }

                if (! preg_match('/^[a-z0-9_]+$/', $tc) || ! preg_match('/^[a-z0-9_]+$/', $fk)) {
                    continue;
                }

                $altri = mysqlSelectColumn(
                    'id',
                    $c,
                    'SELECT DISTINCT `' . $tc . '`.`' . $fk . '` AS id FROM `' . $tc . '` '
                        . 'INNER JOIN `' . $b . '` ON `' . $b . '`.id = `' . $tc . '`.`' . $fk . '` '
                        . 'LEFT JOIN `' . $static . '` ON `' . $static . '`.id = `' . $tc . '`.`' . $fk . '` '
                        . 'WHERE ' . $dove . '( `' . $static . '`.timestamp_aggiornamento IS NULL '
                        . 'OR coalesce( `' . $tc . '`.timestamp_aggiornamento, `' . $tc . '`.timestamp_inserimento, 0 ) > `' . $static . '`.timestamp_aggiornamento ) '
                        . 'ORDER BY `' . $tc . '`.`' . $fk . '` DESC '
                        . 'LIMIT ' . ($l - count($ids))
                );

                if (is_array($altri)) {
                    $ids = array_values(array_unique(array_merge($ids, $altri)));
                }

            }
        }

        if (empty($ids)) {
            return 0;
        }

        // rigenerazione
        if (! refreshStaticView($c, $t, $ids)) {
            logger('riallineamento di ' . $static . ' non riuscito per ' . count($ids) . ' righe', 'static', LOG_ERR);
            return false;
        }

        // timestamp, come li mettevano i task di popolazione
        if ($timestamp) {

            $segnaposto = implode(', ', array_fill(0, count($ids), '?'));
            $args       = array();
            foreach ($ids as $id) {
                $args[] = array('s' => $id);
            }

            foreach (array('timestamp_inserimento', 'timestamp_aggiornamento') as $ts) {
                mysqlQuery(
                    $c,
                    'UPDATE `' . $static . '` SET ' . $ts . ' = unix_timestamp() WHERE id IN ( ' . $segnaposto . ' ) AND ' . $ts . ' IS NULL',
                    $args
                );
            }

            foreach ($correlate as $tc => $fk) {
                if (! preg_match('/^[a-z0-9_]+$/', $tc) || ! preg_match('/^[a-z0-9_]+$/', $fk)) {
                    continue;
                }
                mysqlQuery(
                    $c,
                    'UPDATE `' . $static . '` SET timestamp_aggiornamento = greatest( timestamp_aggiornamento, coalesce( ( '
                        . 'SELECT max( coalesce( `' . $tc . '`.timestamp_aggiornamento, `' . $tc . '`.timestamp_inserimento, 0 ) ) '
                        . 'FROM `' . $tc . '` WHERE `' . $tc . '`.`' . $fk . '` = `' . $static . '`.id ), 0 ) ) '
                        . 'WHERE id IN ( ' . $segnaposto . ' )',
                    $args
                );
            }

        }

        // le righe che la vista non restituisce tornerebbero a ogni giro: si segnalano
        $mancanti = count($ids) - (int) mysqlSelectValue(
            $c,
            'SELECT count(*) FROM `' . $static . '` WHERE id IN ( ' . implode(', ', array_fill(0, count($ids), '?')) . ' )',
            array_map(function ($id) {
                return array('s' => $id);
            }, $ids)
        );

        if ($mancanti > 0) {
            logger(
                $mancanti . ' righe di ' . $b . ' non sono arrivate in ' . $static . ' dopo la rigenerazione: la vista non le restituisce, '
                . 'e senza una condizione sulla tabella base verranno riprese a ogni giro',
                'static',
                LOG_WARNING
            );
        }

        logger('riallineate ' . count($ids) . ' righe di ' . $static, 'static');

        return count($ids);
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

    /**
     * FUNZIONI PER LE PATCH DEL DATABASE
     */

    /**
     * restituisce i file di patch, standard e custom, nell'ordine di applicazione
     *
     * Questa funzione cerca i file _*.*.sql di _usr/_database/_patch/ e i file *.*.sql di usr/database/patch/ sotto la
     * cartella $b e li restituisce con il percorso assoluto, senza duplicati e ordinati: prima tutti quelli dello standard,
     * poi quelli del progetto, ciascun gruppo in ordine di nome e quindi di livello. Il percorso di ricerca è quello che
     * glob2custom() ricava da DIR_USR_DATABASE_PATCH . '_*.*.sql', cioè ogni underscore sostituito da {,_}, ma la
     * sostituzione si fa solo sulla parte dopo $b: glob2custom() sta in _src/_config.php, che gli script da riga di comando
     * non includono, e così un underscore nel percorso della document root non viene toccato.
     *
     * @param       string      $b      la document root, con la barra finale ( nel framework DIR_BASE )
     *
     * @return      array               l'elenco dei file, eventualmente vuoto
     *
     */
    function mysqlPatchFiles($b)
    {

        // percorso di ricerca, standard e custom
        $p = $b . str_replace('_', '{,_}', '_usr/_database/_patch/_*.*.sql');

        // elenco dei file
        $f = array();
        foreach (glob($p, GLOB_BRACE) as $t) {
            if (is_file($t)) {
                $f[] = $t;
            }
        }

        // il pattern trova due volte i file dello standard ( con e senza il primo underscore del nome )
        $f = array_values(array_unique($f));

        // ordino per percorso: _usr viene prima di usr, quindi lo standard prima del progetto
        sort($f);

        // restituisco l'elenco
        return $f;
    }

    /**
     * restituisce il livello di patch del database
     *
     * Questa funzione legge dalla tabella __patch__ l'id più alto registrato. Se la tabella non esiste o è vuota il
     * database non ha ancora ricevuto patch e la funzione restituisce '000000000000', cioè "tutte da applicare"; per
     * qualsiasi altro errore restituisce false, e il chiamante deve fermarsi: scambiare una connessione caduta per un
     * database vuoto vorrebbe dire rieseguire da capo tutte le patch su un database in esercizio.
     *
     * @param       object      $c      la connessione mysqli
     *
     * @return      mixed               il livello di patch, '000000000000' per un database senza patch, false in caso di errore
     *
     */
    function mysqlPatchLevel($c)
    {

        // leggo l'ultima patch registrata
        try {
            $r = mysqli_query($c, 'SELECT id FROM __patch__ ORDER BY id DESC LIMIT 1');
            $n = mysqli_errno($c);
        } catch (mysqli_sql_exception $x) {
            $r = false;
            $n = $x->getCode();
        }

        // la tabella __patch__ non esiste ancora ( 1146 ): database da creare
        if ($r === false) {
            return ($n == 1146) ? '000000000000' : false;
        }

        // livello di patch, o nessuna patch registrata
        $l = mysqli_fetch_row($r);
        return (empty($l[0])) ? '000000000000' : $l[0];
    }

    /**
     * legge dai file le patch da applicare sopra un livello
     *
     * Questa funzione legge i file di patch nell'ordine ricevuto e restituisce le patch con id maggiore di $l, ciascuna come
     * array( 'file' => percorso, 'id' => id, 'query' => testo ). Le regole di lettura sono queste:
     *
     * - un file il cui livello ricavato dal nome ( tolti gli underscore, le prime dodici cifre ) non è maggiore del
     *   livello raggiunto fin lì si legge lo stesso, per riprendere un'applicazione fermata a metà file, ma il suo id
     *   segnaposto `------------` non si applica;
     * - una riga che, tolti gli spazi, comincia con `-- |` è un marcatore: chiude la patch che si stava leggendo e ne apre
     *   una nuova con l'id scritto dopo il marcatore, dodici caratteri;
     * - l'id `------------` vale la data e l'ora correnti nel formato YmdHi ( dodici cifre come la colonna __patch__.id );
     * - le altre righe che cominciano con `--` sono commenti e si scartano; tutte le altre si accumulano nella patch così
     *   come sono, e la patch è UNA query, che si esegue senza spezzarla ai punti e virgola ( per questo i file non hanno
     *   DELIMITER );
     * - una patch vuota o fatta di soli commenti non si applica e non si registra;
     * - una patch si applica se il suo id è maggiore del livello raggiunto fin lì, che avanza a ogni patch presa: una patch
     *   con id non crescente fra quelle da applicare non girerebbe mai, e va in $w;
     * - una patch si chiude solo con il marcatore successivo: l'SQL dopo l'ultimo marcatore del file non si applica e va in
     *   $w, per questo ogni file finisce con `-- | FINE`;
     * - un marcatore con un id che non è di dodici cifre ( es. `-- | FINE FILE` ) chiude la patch precedente e basta: l'SQL
     *   che lo segue, come quello prima del primo marcatore, non si applica e va in $w.
     *
     * Le patch con id non maggiore di $l sono quelle che il database ha già e si saltano senza segnalarle.
     *
     * @param       array       $f      i file di patch, nell'ordine di mysqlPatchFiles()
     * @param       string      $l      il livello di patch del database, di mysqlPatchLevel()
     * @param       array       $w      l'array in cui accumulare le segnalazioni, modificato sul posto
     *
     * @return      array               le patch da applicare, nell'ordine, eventualmente vuoto
     *
     */
    function mysqlPatchRead($f, $l, &$w = array())
    {

        // patch da applicare
        $r = array();

        // livello raggiunto leggendo
        $s = $l;

        // processo un file alla volta
        foreach ($f as $pFile) {

            // livello del file dal nome
            $pFileLevel = substr(str_replace('_', '', basename($pFile)), 0, 12);

            // un file che non supera il livello raggiunto si legge lo stesso, perche' un'applicazione fermata a meta'
            // ( livello 202609301916 dentro _202609301900.id.numerici.sql ) deve riprendere dal blocco dopo: fino al
            // 01/10/2026 lo si saltava per intero, e il resto del file non veniva applicato mai, senza avviso; vale
            // solo per gli id espliciti, non per il segnaposto ( vedi sotto )
            $pFileSotto = ($pFileLevel <= $s);

            // patch corrente; $pId false vuol dire nessun marcatore valido aperto
            $pId = false;
            $pQuery = '';
            $pRow = 1;

            // leggo le righe, e una riga NULL in fondo per accorgermi dell'SQL dopo l'ultimo marcatore
            $rows = file($pFile, FILE_IGNORE_NEW_LINES);
            $rows[] = NULL;

            foreach ($rows as $i => $row) {

                // la riga di chiusura o un marcatore chiudono la patch corrente
                if ($row === NULL || substr(trim($row), 0, 4) == '-- |') {

                    if (trim($pQuery) !== '') {

                        if ($row === NULL) {

                            // SQL dopo l'ultimo marcatore: una patch si chiude solo con il marcatore successivo
                            $w[] = basename($pFile) . ' riga ' . $pRow . ': SQL dopo l\'ultimo marcatore, non applicato ( manca il marcatore di chiusura -- | FINE )';

                        } elseif ($pId === false) {

                            // SQL fuori da una patch: prima del primo marcatore o dopo un marcatore senza id
                            $w[] = basename($pFile) . ' riga ' . $pRow . ': SQL fuori da una patch, non applicato';

                        } elseif ($pId > $s) {

                            // patch da applicare
                            $r[] = array('file' => $pFile, 'id' => $pId, 'query' => $pQuery);
                            $s = $pId;

                        } elseif ($pId > $l) {

                            // né già applicata né applicabile: l'id non è crescente
                            $w[] = basename($pFile) . ' riga ' . $pRow . ': patch ' . $pId . ' non crescente rispetto a ' . $s . ', non applicata';

                        }

                    }

                    // fine del file
                    if ($row === NULL) {
                        break;
                    }

                    // id della nuova patch
                    $pId = substr(trim($row), 5, 12);

                    // l'id segnaposto vale la data corrente, nel formato della colonna __patch__.id
                    // in un file sotto il livello il segnaposto non si applica: vale il livello del database, e il blocco si
                    // salta in silenzio come quelli gia' applicati ( altrimenti _120000999999.patch.sql ripartirebbe a ogni giro )
                    if ($pId == '------------') {
                        $pId = ($pFileSotto) ? $l : date('YmdHi');
                    } elseif (! preg_match('/^[0-9]{12}$/', $pId)) {
                        $pId = false;
                    }

                    // svuoto la query per ricominciare ad aggiungere righe
                    $pQuery = '';
                    $pRow = $i + 2;

                } elseif (substr(trim($row), 0, 2) == '--') {

                    // commento, si scarta

                } else {

                    // aggiungo la riga alla patch corrente
                    $pQuery .= rtrim($row, "\r") . PHP_EOL;

                }

            }

        }

        // restituisco le patch da applicare
        return $r;
    }

    /**
     * dice se il server della connessione è MariaDB, e prepara la sessione MySQL alle patch
     *
     * Le patch del framework sono scritte per MariaDB; su MySQL ( la PROD di gimbe su Azure, 8.4 ) vanno tradotte da
     * mysqlPatchTranslate(). Questa funzione legge VERSION() una volta per connessione e, la prima volta che trova MySQL,
     * spegne in sessione sql_generate_invisible_primary_key: con la chiave primaria invisibile ( my_row_id ) che Azure
     * aggiunge alle tabelle create senza, un ADD PRIMARY KEY successivo fallisce. Se la variabile non esiste ( MySQL prima
     * della 8.0.30 ) l'errore si ignora.
     *
     * @param       object      $c      la connessione mysqli
     *
     * @return      bool                true se il server è MariaDB, false se è MySQL
     *
     */
    function mysqlPatchMariaDB($c)
    {

        // risultato per connessione
        static $m = array();

        // chiave della connessione
        $k = spl_object_hash($c);

        // leggo la versione la prima volta
        if (! isset($m[$k])) {
            $r = mysqli_query($c, 'SELECT VERSION()');
            $v = ($r) ? mysqli_fetch_row($r) : array('');
            $m[$k] = (stripos($v[0], 'mariadb') !== false);
            if (! $m[$k]) {
                try {
                    @mysqli_query($c, 'SET SESSION sql_generate_invisible_primary_key = 0');
                } catch (mysqli_sql_exception $x) {
                }
            }
        }

        // restituisco il risultato
        return $m[$k];
    }

    /**
     * dice se nello schema corrente esiste un oggetto, per mysqlPatchTranslate()
     *
     * @param       object      $c      la connessione mysqli
     * @param       string      $o      il tipo di oggetto: 'colonna', 'indice', 'fk', 'vista', 'pk_invisibile'
     * @param       string      $t      la tabella ( o la vista )
     * @param       string      $x      la colonna, l'indice o la chiave esterna; per vista e pk_invisibile non serve
     *
     * @return      bool                true se l'oggetto esiste
     *
     */
    function mysqlPatchSchemaHas($c, $o, $t, $x = NULL)
    {

        // valori della query
        $t = mysqli_real_escape_string($c, $t);
        $x = mysqli_real_escape_string($c, (string) $x);

        // query per tipo di oggetto
        switch ($o) {
            case 'colonna':
                $q = "SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = '$t' AND column_name = '$x'";
                break;
            case 'indice':
                $q = "SELECT 1 FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = '$t' AND index_name = '$x' LIMIT 1";
                break;
            case 'fk':
                $q = "SELECT 1 FROM information_schema.table_constraints WHERE table_schema = DATABASE() AND table_name = '$t' AND constraint_name = '$x' AND constraint_type = 'FOREIGN KEY'";
                break;
            case 'vista':
                $q = "SELECT 1 FROM information_schema.views WHERE table_schema = DATABASE() AND table_name = '$t'";
                break;
            case 'pk_invisibile':
                $q = "SELECT 1 FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = '$t' AND index_name = 'PRIMARY' AND column_name = 'my_row_id'";
                break;
            default:
                return false;
        }

        // eseguo la query
        $r = mysqli_query($c, $q);

        // restituisco il risultato
        return ($r && mysqli_fetch_row($r));
    }

    /**
     * restituisce tipo e nullabilità di una colonna nello schema corrente, per mysqlPatchTranslate()
     *
     * @param       object      $c      la connessione mysqli
     * @param       string      $t      la tabella
     * @param       string      $x      la colonna
     *
     * @return      mixed               array( COLUMN_TYPE, IS_NULLABLE ), o false se la colonna non c'è
     *
     */
    function mysqlPatchColumnType($c, $t, $x)
    {

        // leggo la colonna
        $r = mysqli_query($c, "SELECT COLUMN_TYPE, IS_NULLABLE FROM information_schema.columns WHERE table_schema = DATABASE() "
            . "AND table_name = '" . mysqli_real_escape_string($c, $t) . "' AND column_name = '" . mysqli_real_escape_string($c, $x) . "'");

        // restituisco il risultato
        return ($r) ? (mysqli_fetch_row($r) ?: false) : false;
    }

    /**
     * divide le clausole di un ALTER TABLE al primo livello, fuori da parentesi e apici, per mysqlPatchTranslate()
     *
     * @param       string      $s      il testo dopo ALTER TABLE <tabella>
     *
     * @return      array               le clausole, senza spazi attorno
     *
     */
    function mysqlPatchAlterClauses($s)
    {

        // clausole, clausola corrente, livello di parentesi, apice aperto
        $o = array();
        $b = '';
        $l = 0;
        $a = NULL;

        // scorro un carattere alla volta
        for ($i = 0; $i < strlen($s); $i++) {
            $h = $s[$i];
            if ($a !== NULL) {
                $b .= $h;
                if ($h === '\\' && $a !== '`') {
                    $b .= $s[++$i] ?? '';
                    continue;
                }
                if ($h === $a) {
                    $a = NULL;
                }
                continue;
            }
            if ($h === "'" || $h === '"' || $h === '`') {
                $a = $h;
                $b .= $h;
                continue;
            }
            if ($h === '(') {
                $l++;
            }
            if ($h === ')') {
                $l--;
            }
            if ($h === ',' && $l === 0) {
                $o[] = trim($b);
                $b = '';
                continue;
            }
            $b .= $h;
        }

        // ultima clausola
        if (trim($b) !== '') {
            $o[] = trim($b);
        }

        // restituisco le clausole
        return $o;
    }

    /**
     * traduce per MySQL un ALTER TABLE scritto per MariaDB, per mysqlPatchTranslate()
     *
     * Le clausole condizionali ( ADD COLUMN / KEY / UNIQUE KEY / PRIMARY KEY / CONSTRAINT FOREIGN KEY IF NOT EXISTS, DROP
     * FOREIGN KEY / INDEX / KEY IF EXISTS ), che MySQL non conosce, si risolvono leggendo lo schema: la clausola si toglie
     * se l'oggetto c'è già ( o non c'è, per le DROP ), altrimenti si toglie solo l'IF. Poi due casi che su MySQL fallirebbero
     * anche con la sintassi giusta:
     *
     * - una chiave esterna fra colonne di tipo diverso ( 3780 ): sui deploy vecchi gli id sono int e le colonne nuove delle
     *   patch nascono bigint, su MariaDB passa e su MySQL no; la colonna che fa riferimento prende il tipo della colonna
     *   referenziata, cambiando la definizione se la aggiunge lo stesso ALTER o con un MODIFY prima, se c'è già;
     * - un ADD PRIMARY KEY su una tabella con la chiave primaria invisibile di Azure ( my_row_id ): prima la si toglie,
     *   colonna compresa.
     *
     * @param       object      $c      la connessione mysqli
     * @param       string      $q      l'ALTER TABLE, senza commenti
     * @param       array       $n      l'array in cui accumulare le note, modificato sul posto
     *
     * @return      mixed               le query da eseguire ( vuoto se non resta niente da fare ), o false se non traducibile
     *
     */
    function mysqlPatchTranslateAlter($c, $q, &$n = array())
    {

        // tabella e clausole
        if (! preg_match('/^ALTER\s+TABLE\s+`?([a-z0-9_]+)`?\s+(.*?);?\s*$/is', $q, $m)) {
            return array($q);
        }
        $t = $m[1];

        // clausole tenute, colonne aggiunte dallo stesso ALTER, ADD PRIMARY KEY presente
        $k = array();
        $a = array();
        $p = false;

        // risolvo le clausole condizionali
        foreach (mysqlPatchAlterClauses($m[2]) as $x) {

            if (preg_match('/^ADD\s+COLUMN\s+IF\s+NOT\s+EXISTS\s+`?([a-z0-9_]+)`?(.*)$/is', $x, $y)) {
                if (mysqlPatchSchemaHas($c, 'colonna', $t, $y[1])) {
                    $n[] = $t . '.' . $y[1] . ' c\'è già';
                    continue;
                }
                $x = 'ADD COLUMN `' . $y[1] . '`' . $y[2];
            } elseif (preg_match('/^ADD\s+(UNIQUE\s+)?(KEY|INDEX)\s+IF\s+NOT\s+EXISTS\s+`?([a-z0-9_]+)`?(.*)$/is', $x, $y)) {
                if (mysqlPatchSchemaHas($c, 'indice', $t, $y[3])) {
                    $n[] = $t . ' indice ' . $y[3] . ' c\'è già';
                    continue;
                }
                $x = 'ADD ' . $y[1] . $y[2] . ' `' . $y[3] . '`' . $y[4];
            } elseif (preg_match('/^ADD\s+CONSTRAINT\s+`?([a-z0-9_]+)`?\s+FOREIGN\s+KEY\s+IF\s+NOT\s+EXISTS\s*(.*)$/is', $x, $y)) {
                if (mysqlPatchSchemaHas($c, 'fk', $t, $y[1])) {
                    $n[] = $t . ' fk ' . $y[1] . ' c\'è già';
                    continue;
                }
                $x = 'ADD CONSTRAINT `' . $y[1] . '` FOREIGN KEY ' . $y[2];
            } elseif (preg_match('/^DROP\s+FOREIGN\s+KEY\s+IF\s+EXISTS\s+`?([a-z0-9_]+)`?\s*$/is', $x, $y)) {
                if (! mysqlPatchSchemaHas($c, 'fk', $t, $y[1])) {
                    $n[] = $t . ' fk ' . $y[1] . ' non c\'è';
                    continue;
                }
                $x = 'DROP FOREIGN KEY `' . $y[1] . '`';
            } elseif (preg_match('/^DROP\s+(INDEX|KEY)\s+IF\s+EXISTS\s+`?([a-z0-9_]+)`?\s*$/is', $x, $y)) {
                if (! mysqlPatchSchemaHas($c, 'indice', $t, $y[2])) {
                    $n[] = $t . ' indice ' . $y[2] . ' non c\'è';
                    continue;
                }
                $x = 'DROP INDEX `' . $y[2] . '`';
            } elseif (preg_match('/^DROP\s+COLUMN\s+IF\s+EXISTS\s+`?([a-z0-9_]+)`?\s*$/is', $x, $y)) {
                if (! mysqlPatchSchemaHas($c, 'colonna', $t, $y[1])) {
                    $n[] = $t . '.' . $y[1] . ' non c\'è';
                    continue;
                }
                $x = 'DROP COLUMN `' . $y[1] . '`';
            } elseif (preg_match('/^ADD\s+PRIMARY\s+KEY\s+IF\s+NOT\s+EXISTS\s*(.*)$/is', $x, $y)) {
                if (mysqlPatchSchemaHas($c, 'indice', $t, 'PRIMARY') && ! mysqlPatchSchemaHas($c, 'pk_invisibile', $t)) {
                    $n[] = $t . ' chiave primaria c\'è già';
                    continue;
                }
                $x = 'ADD PRIMARY KEY ' . $y[1];
                $p = true;
            } elseif (preg_match('/^ADD\s+PRIMARY\s+KEY/is', $x)) {
                $p = true;
            } elseif (preg_match('/\bIF\s+(NOT\s+)?EXISTS\b/i', $x)) {
                $n[] = 'clausola non tradotta: ' . $x;
                return false;
            }

            // colonna aggiunta da questo ALTER
            if (preg_match('/^ADD\s+COLUMN\s+`?([a-z0-9_]+)`?/is', $x, $y)) {
                $a[$y[1]] = count($k);
            }

            $k[] = $x;
        }

        // non resta niente da fare
        if (empty($k)) {
            return array();
        }

        // query da eseguire prima dell'ALTER
        $prima = array();

        // chiavi esterne fra colonne di tipo diverso
        foreach ($k as $x) {
            if (preg_match('/^ADD\s+CONSTRAINT\s+`?[a-z0-9_]+`?\s+FOREIGN\s+KEY\s*\(\s*`?([a-z0-9_]+)`?\s*\)\s*REFERENCES\s+`?([a-z0-9_]+)`?\s*\(\s*`?([a-z0-9_]+)`?\s*\)/is', $x, $y)) {
                $r = mysqlPatchColumnType($c, $y[2], $y[3]);
                if (! $r) {
                    continue;
                }
                if (isset($a[$y[1]])) {
                    // la colonna la aggiunge questo stesso ALTER: cambio il tipo nella definizione
                    $i = $a[$y[1]];
                    $z = preg_replace('/^(ADD\s+COLUMN\s+`?' . $y[1] . '`?\s+)(tiny|small|medium|big)?int(\(\d+\))?(\s+unsigned)?/is', '${1}' . $r[0], $k[$i], 1);
                    if ($z !== $k[$i]) {
                        $k[$i] = $z;
                        $n[] = $t . '.' . $y[1] . ' aggiunta come ' . $r[0] . ', il tipo di ' . $y[2] . '.' . $y[3];
                    }
                } else {
                    // la colonna c'è già: se il tipo è diverso la porto a quello della colonna referenziata
                    $f = mysqlPatchColumnType($c, $t, $y[1]);
                    if ($f && strtolower($f[0]) !== strtolower($r[0])) {
                        $prima[] = 'ALTER TABLE `' . $t . '` MODIFY `' . $y[1] . '` ' . $r[0] . (($f[1] === 'NO') ? ' NOT NULL' : ' DEFAULT NULL');
                        $n[] = $t . '.' . $y[1] . ' da ' . $f[0] . ' a ' . $r[0] . ', il tipo di ' . $y[2] . '.' . $y[3];
                    }
                }
            }
        }

        // chiave primaria invisibile di Azure da togliere, colonna compresa, nello stesso ALTER che aggiunge quella vera
        if ($p && mysqlPatchSchemaHas($c, 'pk_invisibile', $t)) {
            array_unshift($k, 'DROP PRIMARY KEY', 'DROP COLUMN `my_row_id`');
            $n[] = $t . ': tolta la chiave primaria invisibile';
        }

        // restituisco le query
        return array_merge($prima, array('ALTER TABLE `' . $t . '` ' . implode(', ', $k)));
    }

    /**
     * traduce per MySQL gli ALTER TABLE con IF [NOT] EXISTS scritti nel corpo di una procedura, per mysqlPatchTranslate()
     *
     * Nel corpo di una procedura lo schema non si può leggere prima: la procedura gira dopo, e le sue istruzioni precedenti
     * possono averlo cambiato. Ogni clausola condizionale diventa quindi un ALTER a sé dentro un blocco IF [NOT] EXISTS(
     * SELECT 1 FROM information_schema … ) THEN … END IF, che decide quando la procedura gira; le clausole senza IF restano
     * ALTER a sé, nello stesso ordine. Le stringhe letterali del corpo non si toccano: si mascherano prima e si rimettono
     * dopo, così un messaggio che cita un ALTER resta com'è.
     *
     * @param       string      $b      il corpo della procedura
     * @param       array       $n      l'array in cui accumulare le note, modificato sul posto
     *
     * @return      string              il corpo tradotto
     *
     */
    function mysqlPatchTranslateRoutine($b, &$n = array())
    {

        // maschero le stringhe letterali
        $s = array();
        $b = preg_replace_callback("/'(?:[^'\\\\]|\\\\.|'')*'/s", function ($m) use (&$s) {
            $s[] = $m[0];
            return "\x01" . (count($s) - 1) . "\x01";
        }, $b);

        // condizioni sullo schema, per tipo di clausola
        $w = function ($o, $t, $x) {
            $t = "table_schema = DATABASE() AND table_name = '" . $t . "'";
            switch ($o) {
                case 'colonna':
                    return "SELECT 1 FROM information_schema.columns WHERE " . $t . " AND column_name = '" . $x . "'";
                case 'indice':
                    return "SELECT 1 FROM information_schema.statistics WHERE " . $t . " AND index_name = '" . $x . "'";
                default:
                    return "SELECT 1 FROM information_schema.table_constraints WHERE " . $t . " AND constraint_name = '" . $x . "' AND constraint_type = 'FOREIGN KEY'";
            }
        };

        // riscrivo gli ALTER con clausole condizionali
        $b = preg_replace_callback('/ALTER\s+TABLE\s+`?([a-z0-9_]+)`?\s+([^;]*?\bIF\s+(?:NOT\s+)?EXISTS\b[^;]*);/is', function ($m) use ($w, &$n) {
            $t = $m[1];
            $o = array();
            foreach (mysqlPatchAlterClauses($m[2]) as $x) {
                if (preg_match('/^ADD\s+COLUMN\s+IF\s+NOT\s+EXISTS\s+`?([a-z0-9_]+)`?(.*)$/is', $x, $y)) {
                    $o[] = 'IF NOT EXISTS( ' . $w('colonna', $t, $y[1]) . ' ) THEN ALTER TABLE `' . $t . '` ADD COLUMN `' . $y[1] . '`' . $y[2] . '; END IF;';
                } elseif (preg_match('/^ADD\s+(UNIQUE\s+)?(KEY|INDEX)\s+IF\s+NOT\s+EXISTS\s+`?([a-z0-9_]+)`?(.*)$/is', $x, $y)) {
                    $o[] = 'IF NOT EXISTS( ' . $w('indice', $t, $y[3]) . ' ) THEN ALTER TABLE `' . $t . '` ADD ' . $y[1] . $y[2] . ' `' . $y[3] . '`' . $y[4] . '; END IF;';
                } elseif (preg_match('/^ADD\s+CONSTRAINT\s+`?([a-z0-9_]+)`?\s+FOREIGN\s+KEY\s+IF\s+NOT\s+EXISTS\s*(.*)$/is', $x, $y)) {
                    $o[] = 'IF NOT EXISTS( ' . $w('fk', $t, $y[1]) . ' ) THEN ALTER TABLE `' . $t . '` ADD CONSTRAINT `' . $y[1] . '` FOREIGN KEY ' . $y[2] . '; END IF;';
                } elseif (preg_match('/^DROP\s+FOREIGN\s+KEY\s+IF\s+EXISTS\s+`?([a-z0-9_]+)`?\s*$/is', $x, $y)) {
                    $o[] = 'IF EXISTS( ' . $w('fk', $t, $y[1]) . ' ) THEN ALTER TABLE `' . $t . '` DROP FOREIGN KEY `' . $y[1] . '`; END IF;';
                } elseif (preg_match('/^DROP\s+(INDEX|KEY)\s+IF\s+EXISTS\s+`?([a-z0-9_]+)`?\s*$/is', $x, $y)) {
                    $o[] = 'IF EXISTS( ' . $w('indice', $t, $y[2]) . ' ) THEN ALTER TABLE `' . $t . '` DROP INDEX `' . $y[2] . '`; END IF;';
                } elseif (preg_match('/^DROP\s+COLUMN\s+IF\s+EXISTS\s+`?([a-z0-9_]+)`?\s*$/is', $x, $y)) {
                    $o[] = 'IF EXISTS( ' . $w('colonna', $t, $y[1]) . ' ) THEN ALTER TABLE `' . $t . '` DROP COLUMN `' . $y[1] . '`; END IF;';
                } else {
                    $o[] = 'ALTER TABLE `' . $t . '` ' . $x . ';';
                }
            }
            $n[] = 'procedura: ALTER su ' . $t . ' in ' . count($o) . ' passi condizionali';
            return implode(PHP_EOL, $o);
        }, $b);

        // rimetto le stringhe letterali
        return preg_replace_callback("/\x01(\d+)\x01/", function ($m) use ($s) {
            return $s[$m[1]];
        }, $b);
    }

    /**
     * traduce una patch per il server della connessione: su MariaDB la lascia com'è, su MySQL la riscrive
     *
     * Le patch del framework sono scritte per MariaDB. Su MySQL ( 8.4 sulla PROD di gimbe, su Azure ) alcune forme non
     * esistono o si comportano diversamente, e questa funzione le riscrive prima che mysqlPatchApply() le esegua:
     *
     * - ALTER TABLE con clausole IF [NOT] EXISTS, anche dentro una stringa poi eseguita con PREPARE: vedi
     *   mysqlPatchTranslateAlter();
     * - CREATE OR REPLACE PROCEDURE / FUNCTION: diventa DROP ... IF EXISTS più CREATE;
     * - CREATE VIEW IF NOT EXISTS: se la vista c'è già non resta niente da fare, altrimenti si toglie l'IF;
     * - CALL di una procedura con ALTER in stringa ( colonne.tabelle.viste ): si decide prima, leggendo lo schema;
     * - i confronti con information_schema: su MySQL 8 i nomi lì sono utf8mb3_tolower_ci, e un COLLATE utf8_general_ci
     *   dall'altra parte dà 1267 ( Illegal mix of collations ). Contro REFERENCED_TABLE_NAME e
     *   REFERENTIAL_CONSTRAINTS.TABLE_NAME lo dà anche una variabile senza COLLATE, quindi il lato che non è
     *   information_schema si converte con CONVERT( ... USING utf8mb3 ) COLLATE utf8mb3_tolower_ci, che su MariaDB non
     *   esiste ed è per questo che si fa qui e non nelle patch.
     *
     * Una forma IF [NOT] EXISTS che non sa tradurre la segnala in $n e restituisce false: la patch non va eseguita.
     * La logica viene dall'esecutore con cui il 01/10/2026 la PROD di gimbe è stata portata da 202609261003 a 202610011822.
     *
     * @param       object      $c      la connessione mysqli
     * @param       string      $q      la patch, come la restituisce mysqlPatchRead()
     * @param       array       $n      l'array in cui accumulare le note sulla traduzione, modificato sul posto
     *
     * @return      mixed               le query da eseguire nell'ordine ( vuoto se non resta niente da fare ), o false
     *
     */
    function mysqlPatchTranslate($c, $q, &$n = array())
    {

        // su MariaDB la patch resta com'è
        if (mysqlPatchMariaDB($c)) {
            return array($q);
        }

        // testo senza i commenti di riga, e com'era prima di tradurlo
        $s = trim(preg_replace('/^\s*--.*$/m', '', $q));
        $o = $s;

        // COLLATE utf8_general_ci nei confronti fra colonne di information_schema e colonne di una tabella
        $s = preg_replace('/(\b[a-z_]+\.(?:table_name|column_name|table_schema|constraint_name|index_name)\s*=\s*[a-z_]+\.`?[a-z_]+`?)\s+COLLATE\s+utf8_general_ci/i', '$1', $s, -1, $i);
        if ($i) {
            $n[] = $i . ' COLLATE tolti nei confronti con information_schema';
        }

        // il lato che non è information_schema dei confronti sui nomi ( = e LIKE ), in utf8mb3_tolower_ci: con
        // lower_case_table_names=1 ( Azure ) le colonne di information_schema sono utf8mb3_tolower_ci e il LIKE con una
        // variabile nella collation del DB da' 1267
        $s = preg_replace(
            '/(?<!BINARY )(\b(?:[a-z_]+\.)?(?:TABLE_NAME|COLUMN_NAME|REFERENCED_TABLE_NAME|REFERENCED_COLUMN_NAME|CONSTRAINT_NAME|INDEX_NAME))(\s*=\s*|\s+(?:NOT\s+)?LIKE\s+)(?!BINARY\b)((?:[a-z_]+\.)?`?[a-z_][a-z0-9_]*`?)(?!\s*\(|[a-z0-9_.`]|\s+COLLATE)/i',
            '$1$2CONVERT( $3 USING utf8mb3 ) COLLATE utf8mb3_tolower_ci', $s, -1, $i);
        if ($i) {
            $n[] = $i . ' confronti con information_schema in utf8mb3_tolower_ci';
        }

        // "la tabella ha la chiave primaria?": quella invisibile di Azure ( my_row_id ) non conta, altrimenti la patch salta
        // l'ADD PRIMARY KEY della chiave vera, e con lei gli indici e la conversione degli id che le vengono dietro
        $s = preg_replace(
            "/(TABLE_NAME\s*=\s*'([a-z0-9_]+)'\s+AND\s+CONSTRAINT_TYPE\s*=\s*'PRIMARY KEY')/i",
            "\$1 AND NOT EXISTS ( SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = '\$2' AND COLUMN_NAME = 'my_row_id' )",
            $s, -1, $i);
        if ($i) {
            $n[] = $i . ' controlli sulla chiave primaria senza quella invisibile';
        }

        // CREATE VIEW IF NOT EXISTS, da sola o in una stringa passata a una procedura
        if (preg_match('/CREATE\s+VIEW\s+IF\s+NOT\s+EXISTS\s+`?([a-z0-9_]+)`?/i', $s, $m)) {
            if (preg_match_all('/CREATE\s+VIEW\s+IF\s+NOT\s+EXISTS/i', $s) > 1) {
                $n[] = 'più di un CREATE VIEW IF NOT EXISTS nella stessa patch';
                return false;
            }
            if (mysqlPatchSchemaHas($c, 'vista', $m[1])) {
                $n[] = 'vista ' . $m[1] . ' c\'è già';
                return array();
            }
            $s = preg_replace('/CREATE\s+VIEW\s+IF\s+NOT\s+EXISTS/i', 'CREATE VIEW', $s);
            $n[] = 'vista ' . $m[1] . ': tolto IF NOT EXISTS';
        }

        // CREATE OR REPLACE PROCEDURE / FUNCTION
        if (preg_match('/^CREATE\s+OR\s+REPLACE\s+(PROCEDURE|FUNCTION)\s+(`?[a-z0-9_]+`?)/is', $s, $m)) {
            $b = preg_replace('/^CREATE\s+OR\s+REPLACE\s+/is', 'CREATE ', $s);
            // l'ALTER dinamico delle procedure di colonne.base e colonne.riallineamento parte solo per le colonne che
            // information_schema dice mancanti: l'IF NOT EXISTS è ridondante
            $b = preg_replace('/ADD COLUMN IF NOT EXISTS/i', 'ADD COLUMN', $b, -1, $i);
            if ($i) {
                $n[] = $i . ' ADD COLUMN IF NOT EXISTS dinamici resi ADD COLUMN';
            }
            // gli ALTER condizionali scritti nel corpo
            $b = mysqlPatchTranslateRoutine($b, $n);
            // quello che resta, fuori dalle stringhe letterali, non lo so tradurre
            $r = preg_replace("/'(?:[^'\\\\]|\\\\.|'')*'/s", "''", $b);
            if (preg_match('/\bIF\s+(NOT\s+)?EXISTS\b(?!\s*\()/i', preg_replace('/(DROP|CREATE)\s+(TABLE|TEMPORARY TABLE|VIEW|PROCEDURE|FUNCTION|TRIGGER)\s+IF\s+(NOT\s+)?EXISTS/i', '', $r))) {
                $n[] = 'IF EXISTS rimasto nel corpo della procedura';
                return false;
            }
            return array('DROP ' . strtoupper($m[1]) . ' IF EXISTS ' . $m[2], $b);
        }

        // ALTER TABLE al primo livello
        if (preg_match('/^ALTER\s+TABLE\b/i', $s)) {
            $r = mysqlPatchTranslateAlter($c, $s, $n);
            if (is_array($r) && empty($n) && $r !== array($s)) {
                $n[] = 'tolti gli IF [NOT] EXISTS';
            }
            return $r;
        }

        // ALTER passati come stringa a una procedura ( colonne.tabelle.viste ): si decide prima, leggendo lo schema
        if (preg_match('/^CALL\b/i', $s) && preg_match('/\bIF\s+(NOT\s+)?EXISTS\b/i', $s)) {
            if (! preg_match("/'\\s*ALTER TABLE `([a-z0-9_]+)`/i", $s, $m)) {
                $n[] = 'CALL con IF EXISTS senza tabella riconoscibile';
                return false;
            }
            $t = $m[1];
            preg_match_all('/ADD COLUMN IF NOT EXISTS `([a-z0-9_]+)`/i', $s, $cc);
            preg_match_all('/ADD (?:UNIQUE )?KEY IF NOT EXISTS `([a-z0-9_]+)`/i', $s, $kk);
            $e = array();
            $f = array();
            foreach ($cc[1] as $x) {
                if (mysqlPatchSchemaHas($c, 'colonna', $t, $x)) {
                    $e[] = 'colonna ' . $x;
                } else {
                    $f[] = 'colonna ' . $x;
                }
            }
            foreach ($kk[1] as $x) {
                if (mysqlPatchSchemaHas($c, 'indice', $t, $x)) {
                    $e[] = 'indice ' . $x;
                } else {
                    $f[] = 'indice ' . $x;
                }
            }
            if (preg_match('/\bIF\s+(NOT\s+)?EXISTS\b(?!\s*\()/i', preg_replace('/ADD (COLUMN|(UNIQUE )?KEY) IF NOT EXISTS/i', '', $s))) {
                $n[] = 'CALL con forme IF EXISTS non previste';
                return false;
            }
            if (empty($f)) {
                $n[] = $t . ': ' . implode(', ', $e) . ' già presenti';
                return array();
            }
            // colonne già presenti e mancano solo indici: aggiungo gli indici con un ALTER diretto
            if (! empty($e) && ! preg_grep('/^colonna /', $f)) {
                $d = array();
                foreach ($f as $x) {
                    $x = substr($x, 7);
                    if (! preg_match('/ADD ((?:UNIQUE )?KEY) IF NOT EXISTS `' . preg_quote($x, '/') . '` (\([^)]*\))/i', $s, $y)) {
                        $n[] = $t . ': definizione dell\'indice ' . $x . ' non trovata';
                        return false;
                    }
                    $d[] = 'ADD ' . $y[1] . ' `' . $x . '` ' . $y[2];
                }
                $n[] = $t . ': ' . implode(', ', $e) . ' già presenti, aggiunti ' . implode(', ', $f);
                return array('ALTER TABLE `' . $t . '` ' . implode(', ', $d));
            }
            if (! empty($e)) {
                $n[] = $t . ': in parte presenti ( ' . implode(', ', $e) . ' ), in parte no';
                return false;
            }
            $n[] = $t . ': tolti gli IF NOT EXISTS';
            return array(preg_replace('/(ADD (?:COLUMN|(?:UNIQUE )?KEY)) IF NOT EXISTS/i', '$1', $s));
        }

        // ALTER scritti in una stringa letterale ed eseguiti con PREPARE ( report.sottoscorta e simili )
        if (preg_match('/(["\'])\s*ALTER\s+TABLE\s+`[a-z0-9_]+`[^"\']*\bIF\s+(NOT\s+)?EXISTS\b[^"\']*\1/is', $s)) {
            $e = NULL;
            $s = preg_replace_callback('/(["\'])(\s*ALTER\s+TABLE\s+`[a-z0-9_]+`[^"\']*)\1/is', function ($m) use ($c, &$e, &$n) {
                if (! preg_match('/\bIF\s+(NOT\s+)?EXISTS\b/i', $m[2])) {
                    return $m[0];
                }
                $o = mysqlPatchTranslateAlter($c, trim($m[2]), $n);
                if ($o === false || count($o) > 1) {
                    $e = 'ALTER in stringa non traducibile';
                    return $m[0];
                }
                if (empty($o)) {
                    return $m[1] . 'SELECT \'già presente\' AS nota' . $m[1];
                }
                return $m[1] . $o[0] . $m[1];
            }, $s);
            if ($e) {
                $n[] = $e;
                return false;
            }
            $n[] = 'ALTER in stringa: risolti gli IF [NOT] EXISTS';
        }

        // qualunque altro IF [NOT] EXISTS che non sia su CREATE / DROP di tabelle, viste, procedure
        if (preg_match('/\b(ADD|DROP|MODIFY|CHANGE)\b[^;]{0,40}\bIF\s+(NOT\s+)?EXISTS\b(?!\s*\()/i', preg_replace('/(DROP|CREATE)\s+(TABLE|TEMPORARY TABLE|VIEW|PROCEDURE|FUNCTION|TRIGGER)\s+IF\s+(NOT\s+)?EXISTS/i', '', $s))) {
            $n[] = 'forma IF EXISTS non prevista';
            return false;
        }

        // restituisco la patch, tradotta o no
        return array(($s === $o) ? $q : $s);
    }

    /**
     * applica le patch e le registra in __patch__, fermandosi al primo errore
     *
     * Questa funzione crea la tabella __patch__ se non esiste, poi esegue le patch ricevute da mysqlPatchRead() una alla
     * volta con mysqli_query(), ciascuna come una sola query, e registra ognuna in __patch__ con l'ora di esecuzione e la
     * nota 'OK'. Al primo errore, della patch o della sua registrazione, si ferma: le patch successive non si applicano e
     * $e riceve array( 'file', 'id', 'errno', 'error', 'query' ) della patch fallita. Restituisce le patch applicate.
     *
     * Su MySQL ogni patch passa prima da mysqlPatchTranslate(), che può farne più query o nessuna: si eseguono nell'ordine,
     * in __patch__ si registra il testo originale e la nota dice cosa è stato tradotto. Una patch che non si sa tradurre
     * ferma tutto come un errore, con errno -1. Su MariaDB la patch passa così com'è.
     *
     * NOTA le patch passano da mysqli e non da mysqlQuery() di proposito: mysqlQuery() sceglie cosa fare dalla prima parola
     * della query e un comando che non conosce lo scarta senza errore, e fino al 29/09/2026 il task registrava così come
     * fatte le patch con PREPARE, EXECUTE e DEALLOCATE senza eseguirle. Qui ogni patch va al server così com'è: un'istruzione
     * che il server non conosce è un errore di sintassi, che ferma tutto. mysqlQuery() inoltre scrive nei log del framework,
     * che gli script da riga di comando non hanno. Gli errori si leggono sia da mysqli_errno() sia dall'eccezione che mysqli
     * solleva per default da PHP 8.1.
     *
     * @param       object      $c      la connessione mysqli
     * @param       array       $p      le patch da applicare, di mysqlPatchRead()
     * @param       array       $e      l'array in cui scrivere l'errore, vuoto se tutto è andato bene, modificato sul posto
     *
     * @return      array               le patch applicate e registrate, nell'ordine
     *
     */
    function mysqlPatchApply($c, $p, &$e = array())
    {

        // patch applicate
        $r = array();

        // la tabella delle patch, se non c'è; la sua creazione si esegue e fallisce come una patch, prima di tutte, ma
        // non si registra ( id NULL )
        array_unshift($p, array(
            'file' => NULL,
            'id' => NULL,
            'query' => 'CREATE TABLE IF NOT EXISTS `__patch__` (
                `id` char(12) NOT NULL PRIMARY KEY,
                `patch` mediumtext COLLATE utf8_unicode_ci,
                `timestamp_esecuzione` int(11) DEFAULT NULL,
                `token` char(128) DEFAULT NULL,
                `note_esecuzione` text
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8'
        ));

        // il testo di una patch puo' superare i 64 KB di text ( _202609261002 ne ha 215 ): sui database dove __patch__
        // c'era gia' la colonna si allarga, se no la registrazione fallisce con 1406 Data too long e la patch,
        // eseguita ma non registrata, si ripete al giro dopo; anche questa non si registra ( id NULL )
        array_splice($p, 1, 0, array(array(
            'file' => NULL,
            'id' => NULL,
            'query' => 'ALTER TABLE `__patch__` MODIFY `patch` mediumtext COLLATE utf8_unicode_ci'
        )));

        // applico una patch alla volta
        foreach ($p as $patch) {

            // esecuzione della patch e registrazione
            try {

                // traduco la patch per il server: su MariaDB resta com'è, su MySQL può diventare più query o nessuna
                $d = array();
                $q = mysqlPatchTranslate($c, $patch['query'], $d);

                // eseguo la patch, una query alla volta, fermandomi al primo errore
                foreach (($q === false) ? array() : $q as $y) {

                    $x = mysqli_query($c, $y);

                    // una patch che restituisce righe ( SELECT, o CALL di una procedura che ne restituisce ) va letta fino in
                    // fondo, altrimenti la query successiva fallisce con "Commands out of sync"
                    if ($x instanceof mysqli_result) {
                        mysqli_free_result($x);
                    }
                    while (mysqli_more_results($c) && mysqli_next_result($c)) {
                        if ($x = mysqli_store_result($c)) {
                            mysqli_free_result($x);
                        }
                    }

                    if (mysqli_errno($c)) {
                        break;
                    }
                }

                // registro la patch, col testo originale, salvo la creazione della tabella
                if ($q !== false && ! mysqli_errno($c) && $patch['id'] !== NULL) {
                    $t = time();
                    $s = mysqli_prepare($c, 'INSERT INTO `__patch__` ( id, patch, timestamp_esecuzione, note_esecuzione ) VALUES ( ?, ?, ?, ? )');
                    if ($s) {
                        $v = trim($patch['query']);
                        $o = (empty($d)) ? 'OK' : 'OK tradotta per MySQL: ' . implode('; ', $d);
                        mysqli_stmt_bind_param($s, 'ssis', $patch['id'], $v, $t, $o);
                        mysqli_stmt_execute($s);
                        mysqli_stmt_close($s);
                    }
                }

                // codice e testo dell'errore, se c'è; una patch che non si sa tradurre è un errore
                $n = ($q === false) ? -1 : mysqli_errno($c);
                $m = ($q === false) ? 'patch non traducibile per MySQL: ' . implode('; ', $d) : mysqli_error($c);

            } catch (mysqli_sql_exception $x) {

                // mysqli con MYSQLI_REPORT_ERROR solleva l'eccezione invece di restituire false
                $n = $x->getCode();
                $m = $x->getMessage();

            }

            // al primo errore mi fermo
            if (! empty($n)) {
                $e = array(
                    'file' => $patch['file'],
                    'id' => $patch['id'],
                    'errno' => $n,
                    'error' => $m,
                    'query' => $patch['query']
                );
                return $r;
            }

            // patch applicata
            if ($patch['id'] !== NULL) {
                $r[] = $patch;
            }
        }

        // restituisco le patch applicate
        return $r;
    }
