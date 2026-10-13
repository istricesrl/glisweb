<?php

    /**
     * allineamento e pubblicazione dei dati geografici standard
     *
     * Questo file e' l'entry point PHP di _src/_sh/_geografia.build.sh e non va lanciato direttamente.
     *
     * introduzione
     * ============
     * Fa due lavori distinti, che si chiedono con due opzioni diverse perche' hanno rischi diversi:
     *
     * - `--istat` allinea la tabella `comuni` del database all'elenco ufficiale ISTAT, poi archivia i
     *   comuni soppressi secondo l'elenco ISTAT dei soppressi ( data_archiviazione, note_archiviazione,
     *   id_successore ) e segnala le province italiane che l'ISTAT non elenca piu';
     * - `--export` rigenera i quattro CSV che i deploy scaricano da dataserver.istricesrl.com, e i
     *   quattro dell'archiviazione ( solo le righe archiviate ) per le tabelle che hanno le colonne.
     *
     * Il successore e' quello diretto: un comune soppresso in uno a sua volta soppresso punta al
     * secondo, e la catena la segue chi rimappa i riferimenti ( _geografia.importazione.php ). Un
     * comune diviso fra piu' successori si archivia senza successore. Per province, regioni e stati
     * l'ISTAT non da' un elenco dei soppressi: si archiviano a mano, e l'export li pubblica lo stesso.
     *
     * `comuni`, `provincie`, `regioni` e `stati` sono TABELLE STANDARD: il loro contenuto e' parte
     * del framework e i deploy non possono modificarlo, quindi questo script gira solo dove il
     * framework si sviluppa e il suo prodotto si distribuisce da li'.
     *
     * dipendenze
     * ==========
     * NON esegue il bootstrap del framework, per lo stesso motivo di _docs.build.php: da riga di
     * comando _src/_config.php trascinerebbe sessione, header, memcache e MySQL. Qui servono solo
     * l'autoload di composer ( per PhpSpreadsheet, che legge il file ISTAT ), la lettura di
     * src/config.json e una connessione mysqli sua.
     *
     * licenza
     * =======
     * Questo file fa parte del progetto GlisWeb (https://github.com/istricesrl/glisweb) ed e'
     * distribuito sotto licenza Open Source.
     *
     */

    // la document root e' la cartella da cui lo script wrapper ha gia' fatto cd
    define( 'GEO_BASE', rtrim( getcwd(), '/' ) . '/' );

    // elenco ufficiale dei comuni italiani
    //
    // NOTA l'URL storico e' .xls e risponde 301 verso .xlsx: file_get_contents segue il redirect
    // da solo e non serve correggerlo. Serve invece un trust store aggiornato, perche' la catena
    // di istat.it finisce su una root del 2021 che i bundle piu' vecchi non hanno: senza, il
    // download fallisce ritornando false e basta
    define( 'GEO_ISTAT_URL', 'https://www.istat.it/storage/codici-unita-amministrative/Elenco-comuni-italiani.xls' );

    // quanti comuni deve avere l'elenco ISTAT perche' sia credibile
    //
    // I comuni italiani sono circa 7.900 e calano di qualche decina l'anno per fusione. Un file
    // con molti meno non e' un aggiornamento, e' un guasto: una pagina di errore, un download
    // troncato, un cambio di tracciato. Applicarlo non toglierebbe niente — i comuni che qui non
    // ci sono non vengono cancellati — ma vorrebbe dire lavorare su un file che non e' quello.
    define( 'GEO_ISTAT_MINIMO', 7000 );

    // quante righe puo' cambiare un allineamento automatico prima di fermarsi e chiedere
    //
    // A regime l'ISTAT pubblica variazioni un paio di volte l'anno e sono manciate di fusioni:
    // un giro mensile che ne cambia piu' di cosi' sta facendo qualcosa che nessuno si aspetta, e
    // tocca la fonte autorevole di TUTTI i deploy. Si ferma e lo dice; per applicarlo lo stesso
    // c'e' --forza, che e' un modo di far dire a una persona "si', lo so".
    define( 'GEO_SOGLIA_AUTOMATICA', 200 );

    // marcatore dell'ultimo allineamento riuscito, per accorgersi se il giro mensile si e' fermato
    define( 'GEO_MARCATORE', 'var/geografia.latest.conf' );

    // colonne del file ISTAT che servono qui, per posizione
    // il tracciato completo e' documentato in _src/_api/_task/_comuni.importazione.start.php
    define( 'GEO_ISTAT_ISTAT',   4 );    // E    codice comune alfanumerico
    define( 'GEO_ISTAT_NOME',   6 );     // G    denominazione in italiano
    define( 'GEO_ISTAT_SIGLA', 14 );     // O    sigla automobilistica della provincia
    define( 'GEO_ISTAT_CAT',   20 );     // T    codice catastale

    // elenco ufficiale dei comuni soppressi
    //
    // E' uno zip con dentro lo stesso elenco in .csv e in .xls: si legge il .csv, che e' in
    // latin1 col punto e virgola, perche' non ha bisogno di PhpSpreadsheet. Una riga per evento,
    // quindi un comune soppresso per scorporo in piu' successori ha piu' righe con la stessa data
    define( 'GEO_SOPPRESSI_URL', 'https://www.istat.it/storage/codici-unita-amministrative/Elenco-comuni-soppressi.zip' );

    // colonne del file dei soppressi che servono qui, per posizione
    define( 'GEO_SOPPRESSI_SIGLA',      1 );    // sigla automobilistica al momento della soppressione
    define( 'GEO_SOPPRESSI_ISTAT',      3 );    // codice del comune soppresso
    define( 'GEO_SOPPRESSI_NOME',       4 );    // denominazione del comune soppresso
    define( 'GEO_SOPPRESSI_SCORPORO',   5 );    // valorizzata se il comune e' stato diviso
    define( 'GEO_SOPPRESSI_DATA',       6 );    // data dell'evento, gg/mm/aaaa
    define( 'GEO_SOPPRESSI_SUCC',       7 );    // codice del comune in cui e' confluito
    define( 'GEO_SOPPRESSI_SUCC_NOME',  8 );    // denominazione del comune in cui e' confluito

    // le quattro tabelle pubblicate, con le colonne nell'ordine dei CSV storici
    $GEO_TABELLE = array(
        '01.update.stati'     => array( 'stati',     'id,id_continente,nome,nome_esteso,url_riferimento,note,iso31661alpha2,iso31661alpha3,codice_istat,data_archiviazione' ),
        '02.update.regioni'   => array( 'regioni',   'id,id_stato,nome,codice_istat,url_riferimento,note' ),
        '03.update.provincie' => array( 'provincie', 'id,id_regione,nome,sigla,codice_istat,url_riferimento,note' ),
        '04.update.comuni'    => array( 'comuni',    'id,id_provincia,nome,codice_istat,codice_catasto,url_riferimento,note' )
    );

    // l'archiviazione delle quattro tabelle, pubblicata in file a parte
    //
    // Non sta nei quattro file storici perche' l'importazione generica ( _740.controller.php )
    // manda all'UPDATE tutte le colonne del CSV, e un deploy il cui schema non ha ancora queste
    // colonne risponderebbe 1054 su OGNI riga, perdendo anche l'aggiornamento di nomi e codici.
    // Separati, li scarica solo chi ha le colonne ( _src/_api/_task/_geografia.importazione.php ),
    // e vengono dopo i quattro storici, cosi' il successore c'e' gia' quando l'archiviato lo
    // punta. Si pubblicano solo le righe archiviate: le altre non hanno niente da dire.
    $GEO_ARCHIVIAZIONE = array(
        '05.update.stati.archiviazione'     => 'stati',
        '06.update.regioni.archiviazione'   => 'regioni',
        '07.update.provincie.archiviazione' => 'provincie',
        '08.update.comuni.archiviazione'    => 'comuni'
    );

    // colonne dell'archiviazione, le stesse per le quattro tabelle
    define( 'GEO_ARCHIVIAZIONE_COLONNE', 'id,data_archiviazione,note_archiviazione,id_successore' );

    /**
     * apre la connessione al database leggendo src/config.json e src/shadow.json
     *
     * Le credenziali stanno in src/shadow.json ( è lì che le scrive _gw.config.sh ), il resto in
     * src/config.json: si fondono come fa il framework, con shadow che vince su config. La porta è
     * facoltativa, come in _src/_config/_125.mysql.php: senza, il client usa la sua di default.
     *
     * @return  mysqli|bool                 la connessione, false se non si apre
     *
     */
    function geoConnessione() {

        $f = GEO_BASE . 'src/config.json';

        if( ! is_readable( $f ) ) {
            echo 'src/config.json non leggibile' . "\n";
            return false;
        }

        $cx = json_decode( file_get_contents( $f ), true ) ?: array();

        // shadow vince su config
        if( is_readable( GEO_BASE . 'src/shadow.json' ) ) {
            $cx = array_replace_recursive( $cx, json_decode( file_get_contents( GEO_BASE . 'src/shadow.json' ), true ) ?: array() );
        }

        if( ! isset( $cx['mysql']['servers'] ) || ! is_array( $cx['mysql']['servers'] ) ) {
            echo 'nessun server MySQL dichiarato in src/config.json o src/shadow.json' . "\n";
            return false;
        }

        $s = $cx['mysql']['servers'];
        $k = array_key_first( $s );

        $c = @mysqli_connect( $s[$k]['address'], $s[$k]['username'], $s[$k]['password'], $s[$k]['db'], ( ( ! empty( $s[$k]['port'] ) ) ? (int) $s[$k]['port'] : NULL ) );

        if( ! $c ) {
            echo 'connessione al database fallita' . "\n";
            return false;
        }

        mysqli_set_charset( $c, 'utf8mb4' );

        return $c;

    }

    /**
     * normalizza un nome di comune per il confronto
     *
     * @param   string      $x              il nome
     *
     * @return  string                      il nome normalizzato
     *
     */
    function geoNormalizza( $x ) {

        return strtolower( trim( preg_replace( '/\s+/', ' ', (string)$x ) ) );

    }

    /**
     * scarica l'elenco ISTAT e lo restituisce come array di righe
     *
     * @return  array|bool                  le righe, intestazione esclusa, false se non si scarica
     *
     */
    function geoIstatScarica() {

        $d = @file_get_contents( GEO_ISTAT_URL );

        if( $d === false || strlen( $d ) < 100000 ) {
            echo 'scaricamento dell\'elenco ISTAT fallito' . "\n";
            echo 'se il file non arriva, controllare il trust store: la catena di istat.it finisce' . "\n";
            echo 'su una root del 2021 e i bundle piu\' vecchi non la conoscono' . "\n";
            return false;
        }

        $t = GEO_BASE . 'var/tmp/comuni.istat.xlsx';

        if( ! is_dir( dirname( $t ) ) ) {
            mkdir( dirname( $t ), 0750, true );
        }

        file_put_contents( $t, $d );

        $xls = \PhpOffice\PhpSpreadsheet\IOFactory::load( $t );
        $arr = $xls->getActiveSheet()->toArray();

        array_shift( $arr );

        unlink( $t );

        // un elenco troppo corto non e' un aggiornamento, e' un guasto: si ferma qui invece di
        // lavorare su un file che non e' quello che dice di essere
        if( count( $arr ) < GEO_ISTAT_MINIMO ) {
            printf( "l'elenco ISTAT ha %d righe, meno del minimo credibile di %d: non lo uso\n", count( $arr ), GEO_ISTAT_MINIMO );
            return false;
        }

        return $arr;

    }

    /**
     * confronta l'elenco ISTAT con la tabella comuni e ne ricava le query di allineamento
     *
     * Tre casi, e sono quelli che il collaudo del 2026-09-14 ha trovato uno per uno:
     *
     * - il codice ISTAT c'e' gia': niente da fare;
     * - il NOME esiste gia' in quella provincia: si AGGIORNA quella riga, non se ne crea una
     *   seconda. La tabella ha un indice unico su ( id_provincia, nome ) che comunque non lo
     *   permetterebbe, ma soprattutto sarebbe sbagliato: capita quando un comune era stato
     *   inserito senza codice, e quando una fusione ricodifica un comune lasciandogli il nome
     *   ( Sovizzo + Gambugliano -> Sovizzo, codice da 024103 a 024128 ). In tutt'e due i casi il
     *   posto e' lo stesso e gli indirizzi che ci puntano restano validi;
     * - altrimenti si INSERISCE.
     *
     * I comuni che stanno da noi e non nell'ISTAT NON si toccano: sono i soppressi per fusione, e
     * ci sono indirizzi storici che li referenziano.
     *
     * @param   mysqli      $c              la connessione
     * @param   array       $arr            le righe dell'elenco ISTAT
     *
     * @return  array                       array con le chiavi 'sql', 'aggiornati', 'inseriti', 'presenti', 'orfani'
     *
     */
    function geoIstatConfronta( $c, $arr ) {

        // province italiane per sigla
        $prov = array();
        $r = mysqli_query( $c, 'SELECT p.id, p.sigla FROM provincie p
            JOIN regioni g ON g.id = p.id_regione
            JOIN stati t ON t.id = g.id_stato
            WHERE t.nome LIKE "Ital%"' );

        while( $w = mysqli_fetch_assoc( $r ) ) {
            $prov[ strtoupper( trim( $w['sigla'] ) ) ] = $w['id'];
        }

        // l'ISTAT elenca le unita' sovracomunali della Sardegna, che per lo Stato stanno tutte
        // dentro Sud Sardegna: senza questa riga cinquantadue comuni non aggancerebbero niente
        if( isset( $prov['SU'] ) ) {
            $prov['VS'] = $prov['SU'];
            $prov['CI'] = $prov['SU'];
        }

        // i nostri comuni italiani, indicizzati nei due modi che servono
        $perIstat = array();
        $perNome  = array();
        $r = mysqli_query( $c, 'SELECT c.id, c.nome, c.codice_istat, p.sigla FROM comuni c
            JOIN provincie p ON p.id = c.id_provincia
            JOIN regioni g ON g.id = p.id_regione
            JOIN stati t ON t.id = g.id_stato
            WHERE t.nome LIKE "Ital%"' );

        while( $w = mysqli_fetch_assoc( $r ) ) {
            if( $w['codice_istat'] !== NULL && $w['codice_istat'] !== '' ) {
                $perIstat[ $w['codice_istat'] ] = $w;
            }
            $perNome[ geoNormalizza( $w['nome'] ) . '|' . strtoupper( trim( $w['sigla'] ) ) ] = $w;
        }

        // l'ISTAT usa i nomi ufficiali, noi in un caso ne avevamo uno abbreviato
        $alias = array( 'reggio di calabria|RC' => 'reggio calabria|RC' );

        $sql = array();
        $upd = 0;
        $ins = 0;
        $gia = 0;
        $orf = array();

        foreach( $arr as $riga ) {

            $istat = trim( (string)$riga[ GEO_ISTAT_ISTAT ] );

            if( $istat === '' ) {
                continue;
            }

            if( isset( $perIstat[ $istat ] ) ) {
                $gia++;
                continue;
            }

            $nome  = trim( (string)$riga[ GEO_ISTAT_NOME ] );
            $sigla = strtoupper( trim( (string)$riga[ GEO_ISTAT_SIGLA ] ) );
            $cat   = trim( (string)$riga[ GEO_ISTAT_CAT ] );

            if( ! isset( $prov[ $sigla ] ) ) {
                $orf[ $sigla ][] = $nome;
                continue;
            }

            $chiave = geoNormalizza( $nome ) . '|' . $sigla;

            if( isset( $alias[ $chiave ] ) && isset( $perNome[ $alias[ $chiave ] ] ) ) {
                $chiave = $alias[ $chiave ];
            }

            if( isset( $perNome[ $chiave ] ) ) {

                $sql[] = sprintf(
                    "UPDATE comuni SET nome = '%s', codice_istat = '%s', codice_catasto = '%s' WHERE id = %d;",
                    mysqli_real_escape_string( $c, $nome ),
                    mysqli_real_escape_string( $c, $istat ),
                    mysqli_real_escape_string( $c, $cat ),
                    $perNome[ $chiave ]['id']
                );
                $upd++;

            } else {

                $sql[] = sprintf(
                    "INSERT INTO comuni ( id_provincia, nome, codice_istat, codice_catasto ) VALUES ( %d, '%s', '%s', '%s' );",
                    $prov[ $sigla ],
                    mysqli_real_escape_string( $c, $nome ),
                    mysqli_real_escape_string( $c, $istat ),
                    mysqli_real_escape_string( $c, $cat )
                );
                $ins++;

            }

        }

        return array( 'sql' => $sql, 'aggiornati' => $upd, 'inseriti' => $ins, 'presenti' => $gia, 'orfani' => $orf );

    }

    /**
     * dice se una tabella geografica ha le colonne dell'archiviazione
     *
     * Le colonne entrano nello schema canonico con una patch, e questo script puo' girare prima
     * che la patch sia arrivata: senza le colonne il confronto si fa lo stesso, perche' in prova
     * serve sapere cosa cambierebbe, ma non si applica e non si pubblica niente.
     *
     * @param   mysqli      $c              la connessione
     * @param   string      $tabella        nome della tabella
     *
     * @return  bool                        true se ci sono tutte e tre
     *
     */
    function geoArchiviazionePresente( $c, $tabella ) {

        $r = mysqli_query( $c, "SHOW COLUMNS FROM " . $tabella . " WHERE Field IN ( 'data_archiviazione', 'note_archiviazione', 'id_successore' )" );

        return $r && mysqli_num_rows( $r ) == 3;

    }

    /**
     * scarica l'elenco ISTAT dei comuni soppressi e lo restituisce come array di righe
     *
     * @return  array|bool                  le righe, intestazione esclusa, false se non si scarica
     *
     */
    function geoSoppressiScarica() {

        $d = @file_get_contents( GEO_SOPPRESSI_URL );

        if( $d === false || strlen( $d ) < 10000 ) {
            echo 'scaricamento dell\'elenco ISTAT dei soppressi fallito' . "\n";
            return false;
        }

        $t = GEO_BASE . 'var/tmp/comuni.soppressi.zip';

        if( ! is_dir( dirname( $t ) ) ) {
            mkdir( dirname( $t ), 0750, true );
        }

        file_put_contents( $t, $d );

        // il nome del .csv dentro lo zip cambia con le edizioni: si prende quello che c'e'
        $csv = false;
        $z = new ZipArchive;

        if( $z->open( $t ) === true ) {
            for( $i = 0; $i < $z->numFiles; $i++ ) {
                if( strtolower( pathinfo( $z->getNameIndex( $i ), PATHINFO_EXTENSION ) ) == 'csv' ) {
                    $csv = $z->getFromIndex( $i );
                    break;
                }
            }
            $z->close();
        }

        unlink( $t );

        if( $csv === false ) {
            echo 'lo zip dei soppressi non contiene un .csv: il tracciato e\' cambiato' . "\n";
            return false;
        }

        $arr = array();

        foreach( preg_split( '/\r\n|\n|\r/', iconv( 'ISO-8859-1', 'UTF-8', $csv ) ) as $l ) {
            if( trim( $l ) !== '' ) {
                $arr[] = str_getcsv( $l, ';' );
            }
        }

        array_shift( $arr );

        return $arr;

    }

    /**
     * confronta l'elenco dei soppressi con la tabella comuni e ne ricava l'archiviazione
     *
     * Per ogni comune soppresso conta solo l'ULTIMO evento, e da quello si ricavano:
     *
     * - data_archiviazione, la data dell'evento;
     * - id_successore, il comune in cui e' confluito, cercato per codice ISTAT. Puo' essere a sua
     *   volta archiviato ( A in B, poi B in C ): si punta il successore DIRETTO, e chi rimappa i
     *   riferimenti segue la catena fino al comune attivo. Resta NULL se il comune e' stato diviso
     *   fra piu' successori, perche' non c'e' un posto solo in cui mandare i suoi indirizzi;
     * - note_archiviazione, che si scrive solo se e' vuota, per non perdere quella messa a mano.
     *
     * Il comune si cerca per codice ISTAT, e se non c'e' per nome nella provincia. Si salta se il
     * suo codice e' nell'elenco dei comuni ATTIVI, e se il successore e' lui stesso: e' il caso
     * delle fusioni che ricodificano un comune lasciandogli il nome ( Sovizzo, da 024103 a 024128 ),
     * che geoIstatConfronta() ha gia' aggiornato al codice nuovo e che e' vivo.
     *
     * @param   mysqli      $c              la connessione
     * @param   array       $arr            le righe dell'elenco dei soppressi
     * @param   array       $attivi         i codici ISTAT dell'elenco dei comuni attivi, come chiavi
     * @param   bool        $colonne        se la tabella ha gia' le colonne dell'archiviazione
     *
     * @return  array                       array con le chiavi 'sql', 'archiviati', 'presenti', 'assenti', 'divisi', 'senza_successore'
     *
     */
    function geoSoppressiConfronta( $c, $arr, $attivi, $colonne ) {

        // i nostri comuni italiani, indicizzati come in geoIstatConfronta()
        $perIstat = array();
        $perNome  = array();
        $r = mysqli_query( $c, 'SELECT c.id, c.nome, c.codice_istat, p.sigla, '
            . ( $colonne ? 'c.data_archiviazione, c.note_archiviazione, c.id_successore' : 'NULL AS data_archiviazione, NULL AS note_archiviazione, NULL AS id_successore' ) . '
            FROM comuni c
            JOIN provincie p ON p.id = c.id_provincia
            JOIN regioni g ON g.id = p.id_regione
            JOIN stati t ON t.id = g.id_stato
            WHERE t.nome LIKE "Ital%"' );

        while( $w = mysqli_fetch_assoc( $r ) ) {
            if( $w['codice_istat'] !== NULL && $w['codice_istat'] !== '' ) {
                $perIstat[ $w['codice_istat'] ] = $w;
            }
            $perNome[ geoNormalizza( $w['nome'] ) . '|' . strtoupper( trim( $w['sigla'] ) ) ] = $w;
        }

        // per ogni comune soppresso, le righe del suo ultimo evento
        $eventi = array();

        foreach( $arr as $riga ) {

            $istat = trim( (string)$riga[ GEO_SOPPRESSI_ISTAT ] );
            $data  = DateTime::createFromFormat( '!d/m/Y', trim( (string)$riga[ GEO_SOPPRESSI_DATA ] ) );

            if( $istat === '' || ! $data ) {
                continue;
            }

            $riga['data'] = $data->format( 'Y-m-d' );

            if( ! isset( $eventi[ $istat ] ) || $riga['data'] > $eventi[ $istat ][0]['data'] ) {
                $eventi[ $istat ] = array( $riga );
            } elseif( $riga['data'] == $eventi[ $istat ][0]['data'] ) {
                $eventi[ $istat ][] = $riga;
            }

        }

        $sql = array();
        $arc = 0;
        $gia = 0;
        $ass = 0;
        $div = 0;
        $sen = 0;

        foreach( $eventi as $istat => $righe ) {

            // ancora attivo con questo codice: e' una ricodifica, non una soppressione
            if( isset( $attivi[ $istat ] ) ) {
                continue;
            }

            $nome  = trim( (string)$righe[0][ GEO_SOPPRESSI_NOME ] );
            $sigla = strtoupper( trim( (string)$righe[0][ GEO_SOPPRESSI_SIGLA ] ) );

            if( isset( $perIstat[ $istat ] ) ) {
                $noi = $perIstat[ $istat ];
            } elseif( isset( $perNome[ geoNormalizza( $nome ) . '|' . $sigla ] ) ) {
                $noi = $perNome[ geoNormalizza( $nome ) . '|' . $sigla ];
                // trovato per nome, ma e' un comune attivo che si chiama allo stesso modo
                if( isset( $attivi[ $noi['codice_istat'] ] ) ) {
                    continue;
                }
            } else {
                // soppresso prima che la tabella lo conoscesse: niente da archiviare
                $ass++;
                continue;
            }

            // i successori dell'ultimo evento, senza ripetizioni
            $succ = array();
            foreach( $righe as $riga ) {
                $s = trim( (string)$riga[ GEO_SOPPRESSI_SUCC ] );
                if( $s !== '' ) {
                    $succ[ $s ] = trim( (string)$riga[ GEO_SOPPRESSI_SUCC_NOME ] );
                }
            }

            $id = NULL;

            if( count( $succ ) == 1 ) {
                $s = key( $succ );
                if( isset( $perIstat[ $s ] ) ) {
                    $id = $perIstat[ $s ]['id'];
                } else {
                    $sen++;
                }
            } elseif( count( $succ ) > 1 ) {
                $div++;
            }

            // il successore e' lui stesso: ricodificato e ancora vivo
            if( $id !== NULL && $id == $noi['id'] ) {
                continue;
            }

            $elenco = array();
            foreach( $succ as $s => $n ) {
                $elenco[] = $n . ' ( ' . $s . ' )';
            }

            $nota = 'soppresso il ' . date( 'd/m/Y', strtotime( $righe[0]['data'] ) )
                . ( count( $succ ) > 1 || trim( (string)$righe[0][ GEO_SOPPRESSI_SCORPORO ] ) !== '' ? ', diviso fra ' : ', confluito in ' )
                . implode( ', ', $elenco )
                . ' ( fonte ISTAT, elenco dei comuni soppressi )';

            $set = array();

            if( $noi['data_archiviazione'] != $righe[0]['data'] ) {
                $set[] = "data_archiviazione = '" . $righe[0]['data'] . "'";
            }

            if( $noi['id_successore'] != $id ) {
                $set[] = 'id_successore = ' . ( $id === NULL ? 'NULL' : (int)$id );
            }

            if( $noi['note_archiviazione'] === NULL || $noi['note_archiviazione'] === '' ) {
                $set[] = "note_archiviazione = '" . mysqli_real_escape_string( $c, $nota ) . "'";
            }

            if( ! $set ) {
                $gia++;
                continue;
            }

            $sql[] = 'UPDATE comuni SET ' . implode( ', ', $set ) . ' WHERE id = ' . (int)$noi['id'] . ';';
            $arc++;

        }

        return array( 'sql' => $sql, 'archiviati' => $arc, 'presenti' => $gia, 'assenti' => $ass, 'divisi' => $div, 'senza_successore' => $sen );

    }

    /**
     * applica le query di allineamento in una transazione sola
     *
     * O passano tutte o non ne passa nessuna: un indice unico che scatta a meta' lascerebbe la
     * tabella in uno stato che nessuno sa descrivere. E' successo davvero al primo giro, con
     * Sovizzo, ed e' il motivo per cui questa funzione non fa niente riga per riga.
     *
     * @param   mysqli      $c              la connessione
     * @param   array       $sql            le query
     *
     * @return  bool                        true se il commit e' andato
     *
     */
    function geoIstatApplica( $c, $sql ) {

        mysqli_autocommit( $c, false );

        $err = 0;

        foreach( $sql as $q ) {
            if( ! mysqli_query( $c, $q ) ) {
                if( $err < 3 ) {
                    echo '  ERRORE: ' . mysqli_error( $c ) . "\n";
                    echo '    ' . substr( $q, 0, 100 ) . "\n";
                }
                $err++;
            }
        }

        if( $err ) {
            mysqli_rollback( $c );
            echo '  ' . $err . ' errori: ROLLBACK, non e\' stato scritto niente' . "\n";
            return false;
        }

        mysqli_commit( $c );

        return true;

    }

    /**
     * scrive un CSV nel formato che il framework rilegge
     *
     * Il formato non e' negoziabile e non e' quello che verrebbe spontaneo: csvFile2array() chiama
     * str_getcsv( $t, $s, $c, $e ) con $e uguale alla BARRA ROVESCIA, quindi
     *
     * - separatore ";", delimitatore le virgolette, intestazione coi nomi delle colonne;
     * - i NULL si scrivono come campo vuoto SENZA virgolette, le stringhe vuote CON;
     * - gli a capo dentro un campo si appiattiscono a spazio, cosi' resta una riga per record;
     * - le virgolette interne si sfuggono con la barra rovescia, NON raddoppiandole.
     *
     * E' il formato di SELECT ... INTO OUTFILE, che e' con ogni probabilita' come furono generati
     * gli originali. La verifica che conta e' in _geografia.build.sh --export --dry-run: rigenerando
     * una tabella che non si e' toccata il file deve venire IDENTICO BYTE PER BYTE al precedente.
     *
     * @param   mysqli      $c              la connessione
     * @param   string      $f              percorso del file da scrivere
     * @param   string      $tabella        nome della tabella
     * @param   string      $cols           colonne separate da virgola
     * @param   string      $where          condizione sulle righe da scrivere, facoltativa
     *
     * @return  int                         righe scritte
     *
     */
    function geoCsvScrivi( $c, $f, $tabella, $cols, $where = NULL ) {

        $h = fopen( $f, 'w' );

        fwrite( $h, str_replace( ',', ';', $cols ) . "\n" );

        $r = mysqli_query( $c, 'SELECT ' . $cols . ' FROM ' . $tabella . ( $where ? ' WHERE ' . $where : '' ) . ' ORDER BY id' );
        $n = 0;

        while( $w = mysqli_fetch_row( $r ) ) {

            $out = array();

            foreach( $w as $v ) {

                if( $v === NULL ) {
                    $out[] = '';
                    continue;
                }

                $v = str_replace( array( "\r\n", "\n", "\r" ), ' ', $v );
                $v = str_replace( array( '\\', '"' ), array( '\\\\', '\\"' ), $v );

                $out[] = '"' . $v . '"';

            }

            fwrite( $h, implode( ';', $out ) . "\n" );
            $n++;

        }

        fclose( $h );

        return $n;

    }

    // ------------------------------------------------------------------ esecuzione

    $opt = getopt( '', array( 'istat', 'export', 'all', 'dry-run', 'forza' ) );

    if( ! $opt ) {
        fwrite( STDERR, "uso: _geografia.build.sh [--istat] [--export] [--all] [--dry-run] [--forza]\n" );
        exit( 1 );
    }

    $tutto = isset( $opt['all'] );
    $secco = isset( $opt['dry-run'] );
    $forza = isset( $opt['forza'] );

    // autoload di composer: serve PhpSpreadsheet per leggere il file ISTAT
    $autoload = GEO_BASE . '_src/_lib/_ext/autoload.php';

    if( file_exists( $autoload ) ) {
        require_once $autoload;
    }

    if( ! $c = geoConnessione() ) {
        exit( 1 );
    }

    // ------------------------------------------------------------------ allineamento all'ISTAT

    if( $tutto || isset( $opt['istat'] ) ) {

        echo "allineamento dei comuni all'elenco ISTAT:\n";

        if( ! class_exists( '\PhpOffice\PhpSpreadsheet\IOFactory' ) ) {

            echo "  PhpSpreadsheet non disponibile: lanciare composer update\n";
            exit( 1 );

        } elseif( ! $arr = geoIstatScarica() ) {

            exit( 1 );

        } else {

            $e = geoIstatConfronta( $c, $arr );

            printf( "  righe ISTAT                    %d\n", count( $arr ) );
            printf( "  gia' presenti per codice       %d\n", $e['presenti'] );
            printf( "  da aggiornare                  %d\n", $e['aggiornati'] );
            printf( "  da inserire                    %d\n", $e['inseriti'] );

            foreach( $e['orfani'] as $sigla => $nomi ) {
                printf( "  ATTENZIONE: sigla %s non agganciata, %d comuni\n", $sigla, count( $nomi ) );
            }

            if( $secco ) {

                // il SQL si scrive e non si esegue: si legge prima di applicarlo. La copia resta in
                // var/ perche' e' materiale di lavoro di questa installazione e non va distribuito
                $f = GEO_BASE . 'var/geografia/comuni.' . date( 'YmdHis' ) . '.sql';

                if( ! is_dir( dirname( $f ) ) ) {
                    mkdir( dirname( $f ), 0750, true );
                }

                file_put_contents( $f, implode( "\n", $e['sql'] ) . "\n" );

                printf( "  prova: %d query scritte in %s, nessuna eseguita\n", count( $e['sql'] ), $f );

            } elseif( ! $e['sql'] ) {

                // niente da fare: si aggiorna comunque il marcatore, perche' il giro E' andato a
                // buon fine. E' la differenza fra "non c'era niente da cambiare" e "non ha girato
                // nessuno", che senza marcatore non si distinguono
                file_put_contents( GEO_BASE . GEO_MARCATORE, date( 'Y-m-d H:i:s' ) . "\n" );
                echo "  niente da allineare\n";

            } elseif( count( $e['sql'] ) > GEO_SOGLIA_AUTOMATICA && ! $forza ) {

                // la fonte autorevole di tutti i deploy non si riscrive in blocco senza che una
                // persona lo sappia: a regime le variazioni ISTAT sono manciate di fusioni
                printf( "  FERMO: %d righe da cambiare, oltre la soglia di %d per un giro automatico\n", count( $e['sql'] ), GEO_SOGLIA_AUTOMATICA );
                echo "  guardare cosa cambierebbe con --istat --dry-run, poi --istat --forza per applicare\n";
                exit( 1 );

            } elseif( geoIstatApplica( $c, $e['sql'] ) ) {

                file_put_contents( GEO_BASE . GEO_MARCATORE, date( 'Y-m-d H:i:s' ) . "\n" );
                printf( "  applicate: %d aggiornati, %d inseriti\n", $e['aggiornati'], $e['inseriti'] );

            } else {

                exit( 1 );

            }

        }

        // ------------------------------------------------------------------ archiviazione dei soppressi

        echo "archiviazione dei comuni soppressi:\n";

        // i codici dell'elenco dei comuni attivi: un soppresso che ha il codice di un attivo e'
        // stato ricodificato, non soppresso
        $attivi = array();
        foreach( $arr as $riga ) {
            $attivi[ trim( (string)$riga[ GEO_ISTAT_ISTAT ] ) ] = true;
        }

        // le province italiane che l'ISTAT non elenca piu', perche' qualcuno le archivi a mano: il
        // file dei soppressi riguarda solo i comuni, e le province cambiano una volta ogni dieci
        // anni ( le sarde VS e CI sono confluite in SU nel 2016 )
        $sigle = array();
        foreach( $arr as $riga ) {
            $sigle[ strtoupper( trim( (string)$riga[ GEO_ISTAT_SIGLA ] ) ) ] = true;
        }

        $r = mysqli_query( $c, 'SELECT p.sigla FROM provincie p
            JOIN regioni g ON g.id = p.id_regione
            JOIN stati t ON t.id = g.id_stato
            WHERE t.nome LIKE "Ital%"' . ( geoArchiviazionePresente( $c, 'provincie' ) ? ' AND p.data_archiviazione IS NULL' : '' ) );

        while( $w = mysqli_fetch_assoc( $r ) ) {
            if( ! isset( $sigle[ strtoupper( trim( $w['sigla'] ) ) ] ) ) {
                printf( "  ATTENZIONE: la provincia %s non e' piu' nell'elenco ISTAT e non e' archiviata\n", $w['sigla'] );
            }
        }

        $colonne = geoArchiviazionePresente( $c, 'comuni' );

        if( ! $sop = geoSoppressiScarica() ) {

            exit( 1 );

        } else {

            $e = geoSoppressiConfronta( $c, $sop, $attivi, $colonne );

            printf( "  righe dei soppressi            %d\n", count( $sop ) );
            printf( "  gia' archiviati                %d\n", $e['presenti'] );
            printf( "  da archiviare o correggere     %d\n", $e['archiviati'] );
            printf( "  soppressi che non abbiamo      %d\n", $e['assenti'] );
            printf( "  divisi fra piu' successori     %d\n", $e['divisi'] );
            printf( "  successore che non abbiamo     %d\n", $e['senza_successore'] );

            if( $secco || ! $colonne ) {

                // senza le colonne lo schema non e' ancora arrivato: si fa vedere cosa
                // cambierebbe, come in prova, e non si tocca niente
                $f = GEO_BASE . 'var/geografia/soppressi.' . date( 'YmdHis' ) . '.sql';

                if( ! is_dir( dirname( $f ) ) ) {
                    mkdir( dirname( $f ), 0750, true );
                }

                file_put_contents( $f, implode( "\n", $e['sql'] ) . "\n" );

                if( ! $colonne ) {
                    echo "  la tabella comuni non ha ancora le colonne dell'archiviazione\n";
                }

                printf( "  prova: %d query scritte in %s, nessuna eseguita\n", count( $e['sql'] ), $f );

            } elseif( ! $e['sql'] ) {

                echo "  niente da archiviare\n";

            } elseif( count( $e['sql'] ) > GEO_SOGLIA_AUTOMATICA && ! $forza ) {

                // la prima volta archivia trent'anni di fusioni e supera la soglia di sicuro: e'
                // giusto che a farlo sia una persona che ha guardato il dry-run
                printf( "  FERMO: %d comuni da archiviare, oltre la soglia di %d per un giro automatico\n", count( $e['sql'] ), GEO_SOGLIA_AUTOMATICA );
                echo "  guardare cosa cambierebbe con --istat --dry-run, poi --istat --forza per applicare\n";
                exit( 1 );

            } elseif( geoIstatApplica( $c, $e['sql'] ) ) {

                printf( "  applicate: %d comuni archiviati o corretti\n", $e['archiviati'] );

            } else {

                exit( 1 );

            }

        }

    }

    // ------------------------------------------------------------------ pubblicazione dei CSV

    if( $tutto || isset( $opt['export'] ) ) {

        echo "CSV dei dati geografici:\n";

        // si scrive sotto usr/pages/, che il .htaccess serve ad accesso diretto: da li' i file
        // sono raggiungibili via HTTP ed e' IL DATASERVER a venirseli a prendere, invece di essere
        // questa macchina a spingerli sulla sua.
        //
        // La direzione non e' un dettaglio. Se fosse il framework a spingere dovrebbe portarsi
        // dentro l'indirizzo e una chiave di accesso di un'altra macchina, e pubblicare
        // diventerebbe l'effetto collaterale di una rigenerazione invece che una decisione di chi
        // pubblica. Cosi' qui non c'e' nessuna credenziale, e i dati sono pubblici per definizione
        // visto che il dataserver li serve pubblicamente da sempre.
        $d = GEO_BASE . 'usr/pages/geografia/';

        if( ! is_dir( $d ) ) {
            mkdir( $d, 0750, true );
        }

        foreach( $GEO_TABELLE as $nome => $t ) {

            list( $tabella, $cols ) = $t;

            // in prova si scrive accanto, col suffisso, cosi' si puo' fare il diff con il file
            // pubblicato senza sovrascriverlo: e' la verifica che dice se il generatore e' fedele
            $f = $d . $nome . ( $secco ? '.prova' : '' ) . '.csv';

            printf( "  %-22s %6d righe -> %s\n", $nome, geoCsvScrivi( $c, $f, $tabella, $cols ), $f );

        }

        foreach( $GEO_ARCHIVIAZIONE as $nome => $tabella ) {

            // finche' lo schema non ha le colonne non c'e' niente da pubblicare
            if( ! geoArchiviazionePresente( $c, $tabella ) ) {
                printf( "  %-34s saltato, %s non ha le colonne dell'archiviazione\n", $nome, $tabella );
                continue;
            }

            $f = $d . $nome . ( $secco ? '.prova' : '' ) . '.csv';

            printf( "  %-34s %6d righe -> %s\n", $nome, geoCsvScrivi( $c, $f, $tabella, GEO_ARCHIVIAZIONE_COLONNE, 'data_archiviazione IS NOT NULL' ), $f );

        }

        if( $secco ) {
            echo "  prova: confrontare i .prova.csv con i file pubblicati, quelli delle tabelle non\n";
            echo "  toccate devono venire identici byte per byte\n";
        } else {
            echo "  pubblicati: il dataserver se li viene a prendere col suo cron\n";
        }

    }

    exit( 0 );
