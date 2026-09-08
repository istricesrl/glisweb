<?php

    /**
     * generatore delle pagine statiche della documentazione
     *
     * Questo file e' l'entry point PHP di _src/_sh/_docs.build.sh e non va lanciato direttamente.
     *
     * introduzione
     * ============
     * Compone i sorgenti markdown della documentazione e ne produce le pagine HTML statiche. La
     * composizione segue la regola dell'underscore: per ogni documento esiste una versione standard e
     * una custom allo stesso percorso, e la custom vince.
     *
     * dipendenze
     * ==========
     * NON esegue il bootstrap del framework. Da riga di comando _src/_config.php trascinerebbe
     * sessione, header, memcache e MySQL, e un errore in un runlevel bloccherebbe la generazione
     * proprio mentre gira dentro _gw.upgrade.sh. Qui servono solo l'autoload di composer, la libreria
     * _src/_lib/_docs.tools.php e la lettura di src/config.json.
     *
     * licenza
     * =======
     * Questo file fa parte del progetto GlisWeb (https://github.com/istricesrl/glisweb) ed e'
     * distribuita sotto licenza Open Source.
     *
     */

    // la document root e' la cartella da cui lo script wrapper ha gia' fatto cd
    define( 'DOCS_BASE', rtrim( getcwd(), '/' ) . '/' );

    /**
     * verifica che un percorso resti dentro la document root
     *
     * Guardia deliberata e non ridondante: un livello sopra la document root vive il READ.md del
     * deploy, che contiene le credenziali del progetto. Nessun percorso di documentazione puo'
     * risolvere fuori da qui, e se ci prova la generazione si ferma invece di proseguire.
     *
     * @param   string      $percorso       percorso relativo alla document root
     *
     * @return  string|bool                 percorso assoluto verificato, false se non esiste
     *
     */
    function docsBuildPath( $percorso ) {

        $assoluto = realpath( DOCS_BASE . $percorso );

        if( $assoluto === false ) {
            return false;
        }

        if( strpos( $assoluto . '/', DOCS_BASE ) !== 0 ) {
            fwrite( STDERR, "percorso fuori dalla document root, mi fermo: $percorso\n" );
            exit( 2 );
        }

        return $assoluto;

    }

    /**
     * ricava la linea del deploy corrente
     *
     * Serve a filtrare le sezioni marcate con \@linea. Si legge da var/docs.linea.conf se dichiarata,
     * altrimenti dal remote git: solo i deploy del repository glisdev sono sulla linea di sviluppo,
     * tutti gli altri seguono il ramo di glisweb.
     *
     * @return  string                      stable oppure unstable
     *
     */
    function docsBuildLinea() {

        if( $f = docsBuildPath( 'var/docs.linea.conf' ) ) {

            $l = trim( file_get_contents( $f ) );

            if( in_array( $l, DOCS_LINEA_VOCABOLARIO ) ) {
                return $l;
            }

        }

        $remote = trim( (string) shell_exec( 'git -C ' . escapeshellarg( DOCS_BASE ) . ' config --get remote.origin.url 2>/dev/null' ) );

        return ( strpos( $remote, 'glisdev' ) !== false ) ? 'unstable' : 'stable';

    }

    /**
     * elenca i moduli attivi del progetto
     *
     * @return  array                       identificativi dei moduli, nell'ordine di attivazione
     *
     */
    function docsBuildModuliAttivi() {

        if( ! $f = docsBuildPath( 'src/config.json' ) ) {
            return array();
        }

        $cx = json_decode( file_get_contents( $f ), true );

        if( ! isset( $cx['mods']['active']['array'] ) || ! is_array( $cx['mods']['active']['array'] ) ) {
            return array();
        }

        return $cx['mods']['active']['array'];

    }

    /**
     * compone l'elenco dei capitoli di un manuale
     *
     * Il primo capitolo e' l'introduzione, che nasce dal documento di deploy: prima la versione
     * standard, poi quella del progetto, che si aggiunge invece di sostituire perche' descrive
     * personalizzazioni e non alternative. Seguono i capitoli dei moduli attivi, uno per modulo, dove
     * invece la versione custom sostituisce la standard secondo la regola dell'underscore.
     *
     * @param   string      $tipo           READ per il manuale sviluppatore, USER per quello utente
     *
     * @return  array                       capitoli, ciascuno con chiave, titolo e file sorgente
     *
     */
    function docsBuildCapitoli( $tipo ) {

        $capitoli = array();

        $introduzione = array();

        foreach( array( '_usr/_docs/' . $tipo . '.md', 'usr/docs/' . $tipo . '.md' ) as $p ) {
            if( $f = docsBuildPath( $p ) ) {
                $introduzione[] = $f;
            }
        }

        if( $introduzione ) {
            $capitoli[] = array( 'chiave' => 'introduzione', 'titolo' => 'introduzione', 'file' => $introduzione );
        }

        foreach( docsBuildModuliAttivi() as $m ) {

            // la versione custom del modulo sostituisce quella standard
            $f = docsBuildPath( 'mod/' . $m . '/' . $tipo . '.md' );

            if( $f === false ) {
                $f = docsBuildPath( '_mod/_' . $m . '/' . $tipo . '.md' );
            }

            if( $f === false ) {
                continue;
            }

            $capitoli[] = array( 'chiave' => $m, 'titolo' => $m, 'file' => array( $f ) );

        }

        return $capitoli;

    }

    /**
     * garantisce la protezione della cartella di un manuale di progetto
     *
     * Il manuale di progetto descrive le personalizzazioni del cliente e non puo' essere pubblico. La
     * protezione e' Basic auth di Apache, e va garantita QUI e non a mano per due motivi che sono
     * entrambi difetti nel caso contrario:
     *
     * - AuthUserFile vuole un percorso ASSOLUTO, che cambia fra DEV, TEST e PROD: un .htaccess
     *   deployato tale e quale punterebbe a un file inesistente e Apache risponderebbe 500;
     * - un target su cui il .htaccess non e' mai arrivato servirebbe il manuale in chiaro, in silenzio.
     *
     * Percio' la funzione e' fail-closed: senza il file delle password non si genera nulla, e la riga
     * AuthUserFile viene riscritta se punta fuori dalla document root corrente. Il resto del file, se
     * l'operatore ci ha aggiunto qualcosa, viene conservato.
     *
     * @param   string      $cartella       cartella da proteggere, relativa alla document root
     * @param   string      $nome            testo mostrato dal browser nella richiesta di accesso
     *
     * @return  bool                        true se la cartella e' protetta e si puo' generare
     *
     */
    function docsBuildProtezione( $cartella, $nome = 'documentazione' ) {

        $passwd = DOCS_BASE . 'etc/secret/.htpasswd';

        if( ! file_exists( $passwd ) ) {
            echo "  la documentazione di progetto descrive le personalizzazioni del cliente e non puo' essere pubblica.\n";
            echo "  manca il file delle password, non genero niente. Per crearlo:\n";
            echo "    mkdir -p etc/secret && htpasswd -c etc/secret/.htpasswd <utente>\n";
            return false;
        }

        if( ! is_dir( DOCS_BASE . $cartella ) ) {
            mkdir( DOCS_BASE . $cartella, 0750, true );
        }

        $file  = DOCS_BASE . $cartella . '/.htaccess';
        $riga  = 'AuthUserFile ' . $passwd;
        $testo = ( file_exists( $file ) ) ? file_get_contents( $file ) : '';

        if( $testo === '' ) {

            $testo = "# protezione della documentazione di progetto\n"
                   . "#\n"
                   . "# scritta da _src/_sh/_docs.build.sh: la riga AuthUserFile porta un percorso assoluto,\n"
                   . "# che cambia da un ambiente all'altro e viene ricalcolata a ogni generazione. Il resto\n"
                   . "# del file non viene mai toccato.\n"
                   . "\n"
                   . "AuthType Basic\n"
                   . 'AuthName "' . $nome . '"' . "\n"
                   . $riga . "\n"
                   . "Require valid-user\n";

        } elseif( strpos( $testo, $riga ) === false ) {

            // il file arriva da un altro ambiente: si riallinea la sola riga del percorso
            $testo = preg_replace( '/^\s*AuthUserFile\s+.*$/m', $riga, $testo, 1, $n );

            if( ! $n ) {
                $testo .= "\n" . $riga . "\n";
            }

            echo "  riallineato AuthUserFile in $cartella/.htaccess\n";

        } else {

            return true;

        }

        file_put_contents( $file, $testo );
        chmod( $file, 0640 );

        echo "  protezione garantita in $cartella/.htaccess\n";

        return true;

    }

    /**
     * genera le pagine di un manuale
     *
     * @param   string      $tipo           READ oppure USER
     * @param   string      $destinazione   cartella di destinazione, relativa alla document root
     * @param   array       $opzioni        chiavi pubblico, linea, titolo, secco
     *
     * @return  int                         numero di pagine generate
     *
     */
    function docsBuildManuale( $tipo, $destinazione, $opzioni ) {

        $capitoli = docsBuildCapitoli( $tipo );

        if( ! $capitoli ) {
            echo "  nessun sorgente $tipo.md trovato, salto\n";
            return 0;
        }

        $css   = ( $f = docsBuildPath( '_usr/_docs/_etc/_page.css' ) ) ? file_get_contents( $f ) : '';
        $fatte = 0;
        $indice = array();

        // il manuale utente e quello sviluppatore hanno cartelle distinte: con la stessa
        // destinazione si sovrascriverebbero l'indice e l'introduzione a vicenda
        if( ! is_dir( DOCS_BASE . $destinazione ) ) {
            mkdir( DOCS_BASE . $destinazione, 0750, true );
        }

        foreach( $capitoli as $c ) {

            $md = '';

            foreach( $c['file'] as $f ) {
                $md .= file_get_contents( $f ) . "\n\n";
            }

            $sezioni = docsParseSections( $md );
            $sezioni = docsFilterSections( $sezioni, array( 'pubblico' => $opzioni['pubblico'], 'linea' => $opzioni['linea'] ) );

            // un capitolo che il filtro ha svuotato non produce una pagina vuota
            if( ! trim( docsRenderSections( $sezioni ) ) ) {
                continue;
            }

            $html = docsMarkdown2Html( docsRenderSections( $sezioni ) );

            if( $html === false ) {
                fwrite( STDERR, "league/commonmark non disponibile: nessuna pagina generata\n" );
                return 0;
            }

            $toc  = array();
            $html = docsAnchorHeadings( $html, $toc );
            $html = docsFixFragments( $html );
            $html = docsWrapTables( $html );
            $html = docsRenderCallouts( $html );
            $html = docsStripMarkers( $html );

            $pagina = docsRenderPage( $html, $toc, array(
                'titolo'      => $opzioni['titolo'] . ' — ' . $c['titolo'],
                'descrizione' => $opzioni['titolo'] . ', capitolo ' . $c['titolo'],
                'kicker'      => $opzioni['titolo'],
                'sottotitolo' => $c['titolo'],
                'css'         => $css
            ) );

            $file = $destinazione . '/' . $c['chiave'] . '.html';

            if( $opzioni['secco'] ) {
                echo "  [prova] $file (" . number_format( strlen( $pagina ) ) . " byte)\n";
            } else {
                file_put_contents( DOCS_BASE . $file, $pagina );
                echo "  generato $file (" . number_format( strlen( $pagina ) ) . " byte)\n";
            }

            $indice[] = array( 'chiave' => $c['chiave'], 'titolo' => $c['titolo'] );
            $fatte++;

        }

        // indice del manuale
        $voci = '';

        foreach( $indice as $i ) {
            $voci .= '- [' . $i['titolo'] . '](' . $i['chiave'] . '.html)' . "\n";
        }

        $html = docsMarkdown2Html( '# ' . $opzioni['titolo'] . "\n\n## indice\n\n" . $voci );
        $toc  = array();
        $html = docsAnchorHeadings( $html, $toc );

        $pagina = docsRenderPage( $html, array(), array(
            'titolo'      => $opzioni['titolo'],
            'descrizione' => $opzioni['titolo'],
            'kicker'      => 'documentazione',
            'sottotitolo' => $opzioni['titolo'],
            'css'         => $css
        ) );

        if( $opzioni['secco'] ) {
            echo "  [prova] $destinazione/index.html\n";
        } else {
            file_put_contents( DOCS_BASE . $destinazione . '/index.html', $pagina );
            echo "  generato $destinazione/index.html\n";
        }

        return $fatte;

    }

    /**
     * genera le pagine delle quickstart
     *
     * Le quickstart non confluiscono nei manuali: hanno scopo introduttivo e non esaustivo, e per
     * questo hanno una collocazione propria a ogni livello, sorgente, output e URL.
     *
     * @param   string      $sorgente       cartella dei sorgenti, relativa alla document root
     * @param   string      $destinazione   cartella di destinazione, relativa alla document root
     * @param   array       $opzioni        chiavi pubblico, linea, secco
     *
     * @return  int                         numero di pagine generate
     *
     */
    function docsBuildQuickstart( $sorgente, $destinazione, $opzioni ) {

        if( ! $dir = docsBuildPath( $sorgente ) ) {
            return 0;
        }

        $css    = ( $f = docsBuildPath( '_usr/_docs/_etc/_page.css' ) ) ? file_get_contents( $f ) : '';
        $fatte  = 0;
        $indice = array();

        foreach( glob( $dir . '/*.md' ) as $f ) {

            $md      = file_get_contents( $f );
            $sezioni = docsFilterSections(
                docsParseSections( $md ),
                array( 'pubblico' => $opzioni['pubblico'], 'linea' => $opzioni['linea'] )
            );

            $html = docsMarkdown2Html( docsRenderSections( $sezioni ) );

            if( $html === false ) {
                fwrite( STDERR, "league/commonmark non disponibile: nessuna pagina generata\n" );
                return 0;
            }

            $toc  = array();
            $html = docsAnchorHeadings( $html, $toc );
            $html = docsFixFragments( $html );
            $html = docsWrapTables( $html );
            $html = docsRenderCallouts( $html );
            $html = docsStripMarkers( $html );

            // il titolo della pagina e' il primo titolo di primo livello del sorgente
            $titolo = ( preg_match( '/^#\s+(.*)$/m', $md, $mm ) ) ? trim( $mm[1] ) : basename( $f, '.md' );

            // il nome del file diventa parte dell'URL: niente underscore, niente punti interni
            $nome = str_replace( '.', '-', trim( basename( $f, '.md' ), '_' ) );

            $pagina = docsRenderPage( $html, $toc, array(
                'titolo'      => $titolo,
                'descrizione' => $titolo,
                'kicker'      => 'quickstart',
                'sottotitolo' => $titolo,
                'css'         => $css
            ) );

            $file = $destinazione . '/' . $nome . '.html';

            if( $opzioni['secco'] ) {
                echo "  [prova] $file (" . number_format( strlen( $pagina ) ) . " byte)\n";
            } else {
                file_put_contents( DOCS_BASE . $file, $pagina );
                echo "  generato $file (" . number_format( strlen( $pagina ) ) . " byte)\n";
            }

            $indice[] = array( 'nome' => $nome, 'titolo' => $titolo );
            $fatte++;

        }

        // indice delle quickstart: serve un URL stabile da linkare dal template, che non
        // dipenda da come si chiamano i file di questo progetto
        if( $fatte ) {

            $voci = '';

            foreach( $indice as $i ) {
                $voci .= '- [' . $i['titolo'] . '](' . $i['nome'] . '.html)' . "\n";
            }

            $toc  = array();
            $html = docsAnchorHeadings( docsMarkdown2Html( "# guide introduttive\n\n" . $voci ), $toc );

            $pagina = docsRenderPage( $html, array(), array(
                'titolo'      => 'guide introduttive',
                'descrizione' => 'guide introduttive',
                'kicker'      => 'quickstart',
                'sottotitolo' => 'indice',
                'css'         => $css
            ) );

            if( $opzioni['secco'] ) {
                echo "  [prova] $destinazione/index.html\n";
            } else {
                file_put_contents( DOCS_BASE . $destinazione . '/index.html', $pagina );
                echo "  generato $destinazione/index.html\n";
            }

        }

        return $fatte;

    }

    // ------------------------------------------------------------------ esecuzione

    $opt = getopt( '', array( 'user', 'dev', 'quickstart', 'standard', 'all', 'dry-run' ) );

    if( ! $opt ) {
        fwrite( STDERR, "uso: _docs.build.sh [--user] [--dev] [--quickstart] [--standard] [--all] [--dry-run]\n" );
        exit( 1 );
    }

    $tutto = isset( $opt['all'] );
    $secco = isset( $opt['dry-run'] );

    // autoload di composer e libreria di conversione: prima di qualunque uso, perche' e' la libreria
    // a definire i vocabolari su cui si appoggia il resto
    $autoload = getenv( 'DOCS_AUTOLOAD' ) ?: DOCS_BASE . '_src/_lib/_ext/autoload.php';

    if( file_exists( $autoload ) ) {
        require_once $autoload;
    }

    require_once DOCS_BASE . '_src/_lib/_docs.tools.php';

    $linea = docsBuildLinea();

    echo "linea: $linea" . ( $secco ? ' (prova, non scrivo)' : '' ) . "\n";

    // anche il quickstart di progetto descrive le personalizzazioni del cliente: stessa protezione del
    // manuale, e stesso account. Quello dello standard piu' sotto resta invece pubblico, perche' e'
    // l'introduzione generica al framework e non contiene nulla di un singolo cliente
    if( $tutto || isset( $opt['quickstart'] ) ) {
        echo "quickstart del progetto:\n";
        if( docsBuildProtezione( 'usr/pages/quickstart', 'quickstart' ) )
        docsBuildQuickstart( 'usr/docs/quickstart', 'usr/pages/quickstart', array( 'pubblico' => NULL, 'linea' => $linea, 'secco' => $secco ) );
    }

    if( $tutto || isset( $opt['user'] ) ) {
        echo "manuale utente del progetto:\n";
        if( docsBuildProtezione( 'usr/pages/manual', 'manuale' ) )
        docsBuildManuale( 'USER', 'usr/pages/manual/user', array(
            'pubblico' => array( 'operatore', 'amministratore' ),
            'linea'    => $linea,
            'titolo'   => 'manuale utente',
            'secco'    => $secco
        ) );
    }

    if( $tutto || isset( $opt['dev'] ) ) {
        echo "manuale sviluppatore del progetto:\n";
        if( docsBuildProtezione( 'usr/pages/manual', 'manuale' ) )
        docsBuildManuale( 'READ', 'usr/pages/manual/read', array(
            'pubblico' => array( 'sviluppatore', 'amministratore' ),
            'linea'    => $linea,
            'titolo'   => 'manuale sviluppatore',
            'secco'    => $secco
        ) );
    }

    // la documentazione dello standard si genera solo dove e' stata richiesta esplicitamente: sui
    // deploy cliente non serve, e finirebbe fra i disallineamenti raccolti ogni notte da _gw.upgrade.sh.
    //
    // Il marcatore sta in var/ e non in etc/ perche' e' una proprieta' della SINGOLA installazione:
    // etc/ viene deployato, quindi un marcatore creato su DEV accenderebbe la generazione anche su
    // TEST e PROD. var/ e' escluso dal deploy e ignorato da git, come i cutoff delle automazioni.
    if( ( $tutto || isset( $opt['standard'] ) ) && docsBuildPath( 'var/docs.build.conf' ) ) {
        echo "documentazione dello standard:\n";
        docsBuildQuickstart( '_usr/_docs/_quickstart', '_usr/_pages/_quickstart', array( 'pubblico' => NULL, 'linea' => $linea, 'secco' => $secco ) );
    }

    exit( 0 );
