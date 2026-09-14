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
     * - `--istat` allinea la tabella `comuni` del database all'elenco ufficiale ISTAT;
     * - `--export` rigenera i quattro CSV che i deploy scaricano da dataserver.istricesrl.com.
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

    // colonne del file ISTAT che servono qui, per posizione
    // il tracciato completo e' documentato in _src/_api/_task/_comuni.importazione.start.php
    define( 'GEO_ISTAT_ISTAT',   4 );    // E    codice comune alfanumerico
    define( 'GEO_ISTAT_NOME',   6 );     // G    denominazione in italiano
    define( 'GEO_ISTAT_SIGLA', 14 );     // O    sigla automobilistica della provincia
    define( 'GEO_ISTAT_CAT',   20 );     // T    codice catastale

    // le quattro tabelle pubblicate, con le colonne nell'ordine dei CSV storici
    $GEO_TABELLE = array(
        '01.update.stati'     => array( 'stati',     'id,id_continente,nome,nome_esteso,url_riferimento,note,iso31661alpha2,iso31661alpha3,codice_istat,data_archiviazione' ),
        '02.update.regioni'   => array( 'regioni',   'id,id_stato,nome,codice_istat,url_riferimento,note' ),
        '03.update.provincie' => array( 'provincie', 'id,id_regione,nome,sigla,codice_istat,url_riferimento,note' ),
        '04.update.comuni'    => array( 'comuni',    'id,id_provincia,nome,codice_istat,codice_catasto,url_riferimento,note' )
    );

    /**
     * apre la connessione al database leggendo src/config.json
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

        $cx = json_decode( file_get_contents( $f ), true );

        if( ! isset( $cx['mysql']['servers'] ) || ! is_array( $cx['mysql']['servers'] ) ) {
            echo 'nessun server MySQL dichiarato in src/config.json' . "\n";
            return false;
        }

        $s = $cx['mysql']['servers'];
        $k = array_key_first( $s );

        $c = @mysqli_connect( $s[$k]['address'], $s[$k]['username'], $s[$k]['password'], $s[$k]['db'] );

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
     *
     * @return  int                         righe scritte
     *
     */
    function geoCsvScrivi( $c, $f, $tabella, $cols ) {

        $h = fopen( $f, 'w' );

        fwrite( $h, str_replace( ',', ';', $cols ) . "\n" );

        $r = mysqli_query( $c, 'SELECT ' . $cols . ' FROM ' . $tabella . ' ORDER BY id' );
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

    $opt = getopt( '', array( 'istat', 'export', 'all', 'dry-run' ) );

    if( ! $opt ) {
        fwrite( STDERR, "uso: _geografia.build.sh [--istat] [--export] [--all] [--dry-run]\n" );
        exit( 1 );
    }

    $tutto = isset( $opt['all'] );
    $secco = isset( $opt['dry-run'] );

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

                echo "  niente da allineare\n";

            } elseif( geoIstatApplica( $c, $e['sql'] ) ) {

                printf( "  applicate: %d aggiornati, %d inseriti\n", $e['aggiornati'], $e['inseriti'] );

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

        if( $secco ) {
            echo "  prova: confrontare i .prova.csv con i file pubblicati, quelli delle tabelle non\n";
            echo "  toccate devono venire identici byte per byte\n";
        } else {
            echo "  pubblicati: il dataserver se li viene a prendere col suo cron\n";
        }

    }

    exit( 0 );
