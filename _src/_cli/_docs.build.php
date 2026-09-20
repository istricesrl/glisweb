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

        $attivi = array();

        // 1. l'elenco esplicito nella configurazione
        if( $f = docsBuildPath( 'src/config.json' ) ) {

            $cx = json_decode( file_get_contents( $f ), true );

            if( isset( $cx['mods']['active']['array'] ) && is_array( $cx['mods']['active']['array'] ) ) {
                $attivi = $cx['mods']['active']['array'];
            }

        }

        // 2. l'auto-discovery delle cartelle di mod/
        //
        // Il framework usa TUTT'E DUE le strategie ( _src/_config.php ), e creare la cartella e' il
        // modo che la quickstart insegna. Guardare il solo elenco esplicito lasciava senza capitolo
        // i moduli di ogni deploy che non lo compila, in silenzio.
        foreach( glob( DOCS_BASE . 'mod/*', GLOB_ONLYDIR ) as $d ) {
            $attivi[] = basename( $d );
        }

        return array_values( array_unique( $attivi ) );

    }

    /**
     * elenca TUTTI i moduli presenti nell'albero, attivi o no
     *
     * La documentazione di un modulo si genera anche quando il modulo e' spento, perche' per
     * decidere se accenderlo bisogna prima sapere cosa fa: un capitolo che compare solo dopo
     * l'attivazione non serve a chi deve ancora scegliere. Quelli spenti lo dichiarano, nel titolo
     * del capitolo e in testa alla pagina, cosi' nessuno cerca nell'applicazione una maschera che
     * non c'e'.
     *
     * @return  array                       nomi dei moduli senza l'underscore iniziale
     *
     */
    function docsBuildModuli() {

        $moduli = array();

        foreach( array( '_mod/_*', 'mod/*' ) as $p ) {
            foreach( glob( DOCS_BASE . $p, GLOB_ONLYDIR ) as $d ) {
                $moduli[ preg_replace( '/^_/', '', basename( $d ) ) ] = 1;
            }
        }

        $moduli = array_keys( $moduli );

        sort( $moduli );

        return $moduli;

    }

    /**
     * compone l'elenco dei capitoli di un manuale
     *
     * Il primo capitolo e' l'introduzione, che nasce dal documento di deploy: prima la versione
     * standard, poi quella del progetto, che si aggiunge invece di sostituire perche' descrive
     * personalizzazioni e non alternative. Seguono i capitoli dei moduli attivi, uno per modulo, dove
     * invece la versione custom sostituisce la standard secondo la regola dell'underscore.
     *
     * Con $standard vero si prendono i SOLI sorgenti dello standard, e il manuale che ne esce
     * descrive il framework e non l'installazione: e' la versione pubblica, quella che il link del
     * template mostra a chiunque, e proprio per questo non deve contenere niente di un singolo
     * cliente. I manuali di progetto restano la somma dei due, e restano protetti da Basic auth.
     *
     * @param   string      $tipo           READ per il manuale sviluppatore, USER per quello utente
     * @param   bool        $standard       se vero ignora la meta' custom e documenta il solo standard
     *
     * @return  array                       capitoli, ciascuno con chiave, titolo e file sorgente
     *
     */
    function docsBuildCapitoli( $tipo, $standard = false ) {

        $capitoli = array();

        $introduzione = array();

        $sorgenti = array( '_usr/_docs/' . $tipo . '.md' );

        if( ! $standard ) {
            $sorgenti[] = 'usr/docs/' . $tipo . '.md';
        }

        foreach( $sorgenti as $p ) {
            if( $f = docsBuildPath( $p ) ) {
                $introduzione[] = $f;
            }
        }

        if( $introduzione ) {
            $capitoli[] = array( 'chiave' => 'introduzione', 'titolo' => 'introduzione', 'file' => $introduzione );
        }

        // capitoli aggiuntivi: uno per file, in ordine di nome. E' la sede della documentazione
        // che non appartiene a un modulo ne' e' introduttiva — la reference delle tabelle, quella
        // delle variabili, le guide pratiche. La coppia standard/custom segue la solita regola.
        $extra = strtolower( $tipo );

        $cartelle = array( '_usr/_docs/_' . $extra );

        if( ! $standard ) {
            $cartelle[] = 'usr/docs/' . $extra;
        }

        foreach( $cartelle as $d ) {

            if( ! $dir = docsBuildPath( $d ) ) {
                continue;
            }

            foreach( glob( $dir . '/*.md' ) as $f ) {

                $nome = basename( $f, '.md' );

                // il numero in testa serve solo a ordinare, non e' parte del titolo
                $titolo = preg_replace( '/^[0-9]+[.-]\s*/', '', $nome );

                $capitoli[] = array(
                    'chiave' => str_replace( '.', '-', $nome ),
                    'titolo' => str_replace( '.', ' ', $titolo ),
                    'file'   => array( $f )
                );

            }

        }

        // i template: la loro documentazione vive NEL template, accanto al codice, e non in un
        // capitolo del manuale che la ripeterebbe. Perche' sia raggiungibile deve pero' entrare nel
        // manuale come capitolo, altrimenti resta un file che nessuno apre.
        foreach( docsBuildTemplate() as $t ) {

            // la versione custom del template sostituisce quella standard
            $f = ( $standard ) ? false : docsBuildPath( 'src/tpl/' . $t . '/' . $tipo . '.md' );

            if( $f === false ) {
                $f = docsBuildPath( '_src/_tpl/_' . $t . '/' . $tipo . '.md' );
            }

            if( $f === false ) {
                continue;
            }

            $capitoli[] = array( 'chiave' => 'tpl-' . $t, 'titolo' => 'template ' . $t, 'file' => array( $f ) );

        }

        $attivi = docsBuildModuliAttivi();

        foreach( docsBuildModuli() as $m ) {

            // la versione custom del modulo sostituisce quella standard
            $f = ( $standard ) ? false : docsBuildPath( 'mod/' . $m . '/' . $tipo . '.md' );

            if( $f === false ) {
                $f = docsBuildPath( '_mod/_' . $m . '/' . $tipo . '.md' );
            }

            if( $f === false ) {
                continue;
            }

            // in un manuale dello standard l'attivazione non c'entra niente: e' una proprieta'
            // della singola installazione, e li' si documenta il framework
            $acceso = ( $standard ) ? true : in_array( $m, $attivi, true );

            $capitoli[] = array(
                'chiave' => $m,
                'titolo' => 'modulo ' . $m . ( $acceso ? '' : ' ( non attivo )' ),
                'file'   => array( $f ),
                'spento' => ! $acceso
            );

        }

        return $capitoli;

    }

    /**
     * elenca gli altri documenti del deploy, con il link per arrivarci
     *
     * I sei documenti — i due manuali dello standard, i due del progetto e le due quickstart — sono alberi separati, ciascuno col
     * suo indice. Senza un rimando esplicito da uno all'altro chi legge deve sapere a memoria che
     * esistono e a che indirizzo stanno, cioe' deve uscire dalla documentazione per continuare a
     * leggerla: e' esattamente cio' che questa funzione evita.
     *
     * L'esistenza di un documento si decide dai SORGENTI e non dalle pagine gia' scritte: in un giro
     * completo i quattro si generano in sequenza, e guardando l'output i primi non vedrebbero mai gli
     * ultimi.
     *
     * I link sono relativi, non assoluti dalla radice: un deploy puo' stare in una sottocartella, e
     * `/manual/read/` sarebbe sbagliato. Si risolvono rispetto all'URL riscritto dal `.htaccess`
     * ( `usr/pages/` e `_usr/_pages/` non compaiono nell'indirizzo ), quindi valgono via HTTP e non
     * aprendo i file dal filesystem — che e' il modo in cui la documentazione va letta, visto che e'
     * protetta da Basic auth.
     *
     * @param   string      $destinazione   cartella del documento corrente, relativa alla document root
     *
     * @return  array                       voci con titolo e href, senza il documento corrente
     *
     */
    function docsBuildAltrove( $destinazione ) {

        // i documenti dello standard esistono solo dove la generazione e' stata chiesta, cioe' dove
        // c'e' var/docs.build.conf: i sorgenti ci sono su ogni deploy, le pagine no, e senza questa
        // condizione il rimando sarebbe un 404 su tutti i deploy cliente
        $std = ( docsBuildPath( 'var/docs.build.conf' ) !== false );

        // da un documento PUBBLICO si rimanda ai soli documenti pubblici: i manuali di progetto
        // stanno dietro Basic auth, e un lettore arrivato dal punto interrogativo dell'applicazione
        // si troverebbe davanti una richiesta di password — cioe' esattamente il difetto per cui
        // questi documenti sono stati resi pubblici
        $qui_std = ( strpos( $destinazione, '_usr/_pages/' ) === 0 );

        $documenti = array(
            array( 'dir' => '_usr/_pages/_manual/read', 'titolo' => 'manuale dello sviluppatore',              'c' => 'READ', 'std' => true ),
            array( 'dir' => '_usr/_pages/_manual/user', 'titolo' => 'manuale utente',                          'c' => 'USER', 'std' => true ),
            array( 'dir' => '_usr/_pages/_quickstart',  'titolo' => 'guide introduttive',                      'q' => '_usr/_docs/_quickstart', 'std' => true ),
            array( 'dir' => 'usr/pages/manual/read',    'titolo' => 'manuale dello sviluppatore del progetto', 'c' => 'READ' ),
            array( 'dir' => 'usr/pages/manual/user',    'titolo' => 'manuale utente del progetto',             'c' => 'USER' ),
            array( 'dir' => 'usr/pages/quickstart',     'titolo' => 'guide introduttive del progetto',         'q' => 'usr/docs/quickstart' )
        );

        // dalla cartella di destinazione all'indirizzo: i due prefissi delle cartelle ad accesso
        // diretto non compaiono nell'URL, perche' e' il .htaccess a rimetterceli
        $url = function( $d ) {
            foreach( array( '_usr/_pages/', 'usr/pages/' ) as $p ) {
                if( strpos( $d, $p ) === 0 ) {
                    return substr( $d, strlen( $p ) );
                }
            }
            return $d;
        };

        $qui   = $url( $destinazione );
        $su    = str_repeat( '../', count( explode( '/', $qui ) ) );
        $voci  = array();

        foreach( $documenti as $d ) {

            if( $d['dir'] === $destinazione ) {
                continue;
            }

            if( ! empty( $d['std'] ) && ! $std ) {
                continue;
            }

            if( empty( $d['std'] ) && $qui_std ) {
                continue;
            }

            if( isset( $d['c'] ) && ! docsBuildCapitoli( $d['c'], ! empty( $d['std'] ) ) ) {
                continue;
            }

            if( isset( $d['q'] ) ) {

                $dir = docsBuildPath( $d['q'] );

                if( $dir === false || ! glob( $dir . '/*.md' ) ) {
                    continue;
                }

            }

            $voci[] = array( 'titolo' => $d['titolo'], 'href' => $su . $url( $d['dir'] ) . '/index.html' );

        }

        return $voci;

    }

    /**
     * elenca i template del deploy corrente
     *
     * Si elencano TUTTI i template presenti, non solo quelli in uso: a differenza dei moduli, che
     * hanno nella cartella senza underscore un interruttore esplicito, un template e' in uso o no a
     * seconda di cosa dicono le singole pagine, e un template standard resta documentazione utile
     * anche dove nessuna pagina lo usa. Quelli custom si aggiungono in coda.
     *
     * @return  array                       nomi dei template senza underscore, in ordine
     *
     */
    function docsBuildTemplate() {

        $template = array();

        foreach( array( '_src/_tpl', 'src/tpl' ) as $d ) {

            if( ! $dir = docsBuildPath( $d ) ) {
                continue;
            }

            foreach( glob( $dir . '/*', GLOB_ONLYDIR ) as $t ) {

                $nome = ltrim( basename( $t ), '_' );

                if( ! in_array( $nome, $template ) ) {
                    $template[] = $nome;
                }

            }

        }

        return $template;

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
     * copia gli screenshot accanto alle pagine generate
     *
     * Prima quelli dello standard, poi quelli del progetto: a parita' di nome vince il progetto,
     * cosi' un'installazione puo' sostituire la figura di una maschera che ha personalizzato. Nel
     * manuale dello standard, che e' pubblico, gli scatti del progetto non entrano: mostrerebbero
     * le maschere personalizzate di un cliente a chiunque apra il link.
     *
     * @param   string      $destinazione   cartella delle pagine, relativa alla document root
     * @param   bool        $standard       se vero copia i soli scatti dello standard
     *
     * @return  int                         numero di immagini copiate
     *
     */
    function docsBuildScreenshot( $destinazione, $standard = false ) {

        $dest = DOCS_BASE . $destinazione . '/shot';
        $n    = 0;

        $cartelle = array( '_usr/_docs/_shot' );

        if( ! $standard ) {
            $cartelle[] = 'usr/docs/shot';
        }

        foreach( $cartelle as $d ) {

            if( ! $dir = docsBuildPath( $d ) ) {
                continue;
            }

            foreach( glob( $dir . '/*.png' ) as $f ) {

                if( ! is_dir( $dest ) ) {
                    mkdir( $dest, 0750, true );
                }

                copy( $f, $dest . '/' . basename( $f ) );
                $n++;

            }

        }

        return $n;

    }

    /**
     * toglie dalla cartella le pagine che non corrispondono piu' a nessun capitolo
     *
     * La generazione scriveva e basta: un capitolo rinominato, tolto o diventato inattivo lasciava
     * la sua pagina dov'era, raggiungibile via HTTP e ferma a com'era prima. Nessuno se ne accorge,
     * perche' l'indice non la linka piu' e quindi non la si incontra navigando: la si incontra da
     * un segnalibro o da un motore di ricerca, che e' il modo peggiore.
     *
     * @param   string      $destinazione   cartella delle pagine, relativa alla document root
     * @param   array       $chiavi         chiavi dei capitoli vivi, come indice dell'array
     * @param   bool        $secco          se vero dice cosa toglierebbe e non tocca niente
     *
     * @return  int                         numero di pagine tolte
     *
     */
    function docsBuildPota( $destinazione, $chiavi, $secco ) {

        $tolte = 0;

        // si guardano i soli .html della cartella: il .htaccess che la protegge e la sottocartella
        // shot/ degli screenshot non sono pagine e non si toccano
        foreach( glob( DOCS_BASE . $destinazione . '/*.html' ) as $p ) {

            $k = basename( $p, '.html' );

            if( isset( $chiavi[ $k ] ) ) {
                continue;
            }

            if( $secco ) {
                echo "  [prova] tolgo $destinazione/$k.html, non corrisponde a nessun capitolo\n";
            } else if( unlink( $p ) ) {
                echo "  tolto $destinazione/$k.html, non corrisponde a nessun capitolo\n";
            } else {
                fwrite( STDERR, "  NON tolto $destinazione/$k.html: cancellazione fallita\n" );
                continue;
            }

            $tolte++;

        }

        return $tolte;

    }

    /**
     * compone le pagine di un manuale
     *
     * @param   string      $tipo           READ o USER
     * @param   string      $destinazione   cartella delle pagine, relativa alla document root
     * @param   array       $opzioni        pubblico, linea, titolo, secco, standard
     *
     * @return  int                         pagine scritte
     *
     */
    function docsBuildManuale( $tipo, $destinazione, $opzioni ) {

        $standard = ! empty( $opzioni['standard'] );

        $capitoli = docsBuildCapitoli( $tipo, $standard );

        if( ! $capitoli ) {
            echo "  nessun sorgente $tipo.md trovato, salto\n";
            return 0;
        }

        $css   = ( $f = docsBuildPath( '_usr/_docs/_etc/_page.css' ) ) ? file_get_contents( $f ) : '';
        $fatte = 0;
        $indice = array();

        // gli altri documenti del deploy, per non lasciare la pagina senza uscite
        $altrove = docsBuildAltrove( $destinazione );

        // il manuale utente e quello sviluppatore hanno cartelle distinte: con la stessa
        // destinazione si sovrascriverebbero l'indice e l'introduzione a vicenda
        if( ! is_dir( DOCS_BASE . $destinazione ) ) {
            mkdir( DOCS_BASE . $destinazione, 0750, true );
        }

        // gli screenshot vanno accanto alle pagine: nel markdown sono citati con un percorso
        // relativo ( shot/<id>.png ), che dalla pagina generata deve risolvere
        docsBuildScreenshot( $destinazione, $standard );

        // PRIMA PASSATA: si compone il corpo di ogni capitolo e si raccoglie l'indice. Le pagine si
        // scrivono solo dopo, perche' ognuna porta in barra laterale l'elenco degli altri capitoli e
        // in fondo il precedente e il successivo: quell'elenco non e' noto finche' non si sa quali
        // capitoli sopravvivono al filtro delle sezioni.
        $corpi = array();

        foreach( $capitoli as $c ) {

            $md = '';

            // un modulo spento lo dichiara in testa, oltre che nel titolo del capitolo: il titolo
            // si vede dall'indice, questo si vede da chi e' arrivato alla pagina da un link
            if( ! empty( $c['spento'] ) ) {
                $md .= "> **nota** — questo modulo non è attivo su questa installazione: il capitolo c'è\n"
                     . "> lo stesso, perché per decidere se accenderlo bisogna prima sapere cosa fa. Quello\n"
                     . "> che descrive non si trova nell'applicazione finché il modulo non viene attivato.\n\n";
            }

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

            $corpi[] = array( 'chiave' => $c['chiave'], 'titolo' => $c['titolo'], 'html' => $html, 'toc' => $toc );

            $indice[] = array( 'chiave' => $c['chiave'], 'titolo' => $c['titolo'] );

        }

        // SECONDA PASSATA: le pagine, ciascuna con l'indice completo attorno
        foreach( $corpi as $c ) {

            $pagina = docsRenderPage( $c['html'], $c['toc'], array(
                'titolo'      => $opzioni['titolo'] . ' — ' . $c['titolo'],
                'descrizione' => $opzioni['titolo'] . ', capitolo ' . $c['titolo'],
                'kicker'      => $opzioni['titolo'],
                'sottotitolo' => $c['titolo'],
                'css'         => $css,
                'capitoli'    => $indice,
                'corrente'    => $c['chiave'],
                'altrove'     => $altrove
            ) );

            $file = $destinazione . '/' . $c['chiave'] . '.html';

            if( $opzioni['secco'] ) {
                echo "  [prova] $file (" . number_format( strlen( $pagina ) ) . " byte)\n";
            } else if( file_put_contents( DOCS_BASE . $file, $pagina ) === false ) {
                fwrite( STDERR, "  NON generato $file: scrittura fallita\n" );
                continue;
            } else {
                echo "  generato $file (" . number_format( strlen( $pagina ) ) . " byte)\n";
            }

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
            'css'         => $css,
            'capitoli'    => $indice,
            'altrove'     => $altrove
        ) );

        if( $opzioni['secco'] ) {
            echo "  [prova] $destinazione/index.html\n";
        } else {
            file_put_contents( DOCS_BASE . $destinazione . '/index.html', $pagina );
            echo "  generato $destinazione/index.html\n";
        }

        $chiavi = array( 'index' => 1 );

        foreach( $indice as $i ) {
            $chiavi[ $i['chiave'] ] = 1;
        }

        docsBuildPota( $destinazione, $chiavi, $opzioni['secco'] );

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

        // gli altri documenti del deploy, per non lasciare la pagina senza uscite
        $altrove = docsBuildAltrove( $destinazione );

        // la cartella di destinazione va creata, come fa gia' docsBuildManuale(). Mancava, e
        // siccome piu' sotto non si guardava l'esito della scrittura, la generazione diceva
        // "generato" per ogni pagina mentre file_put_contents falliva a ogni giro.
        if( ! $opzioni['secco'] && ! is_dir( DOCS_BASE . $destinazione ) ) {
            mkdir( DOCS_BASE . $destinazione, 0750, true );
        }

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
                'css'         => $css,
                'altrove'     => $altrove
            ) );

            $file = $destinazione . '/' . $nome . '.html';

            if( $opzioni['secco'] ) {
                echo "  [prova] $file (" . number_format( strlen( $pagina ) ) . " byte)\n";
            } else if( file_put_contents( DOCS_BASE . $file, $pagina ) === false ) {
                fwrite( STDERR, "  NON generato $file: scrittura fallita\n" );
                continue;
            } else {
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
                'css'         => $css,
                'altrove'     => $altrove
            ) );

            if( $opzioni['secco'] ) {
                echo "  [prova] $destinazione/index.html\n";
            } else if( file_put_contents( DOCS_BASE . $destinazione . '/index.html', $pagina ) === false ) {
                fwrite( STDERR, "  NON generato $destinazione/index.html: scrittura fallita\n" );
            } else {
                echo "  generato $destinazione/index.html\n";
            }

            $chiavi = array( 'index' => 1 );

            foreach( $indice as $i ) {
                $chiavi[ $i['nome'] ] = 1;
            }

            docsBuildPota( $destinazione, $chiavi, $opzioni['secco'] );

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
    //
    // il file_exists() resta ed e' voluto: senza il vendor questo require sarebbe un fatal, e
    // l'entry point deve poter girare lo stesso perche' viene chiamato da _gw.upgrade.sh. Chi non
    // trova la libreria non genera pagine, e lo dice — e' la stessa scelta di docsMarkdown2Html(),
    // che ritorna false invece di morire.
    //
    // c'era qui una variabile d'ambiente DOCS_AUTOLOAD per puntare a un vendor diverso: serviva
    // quando league/commonmark non era installato e bisognava pescarlo altrove. Dal 15/09/2026 la
    // libreria e' nel vendor del framework, e la variabile era una strada che non prendeva nessuno
    // su nessuno dei sei deploy: un ramo che non si percorre e' un ramo che non si collauda.
    $autoload = DOCS_BASE . '_src/_lib/_ext/autoload.php';

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
    //
    // ⚠ i tre documenti dello standard sono PUBBLICI, e non per dimenticanza: descrivono il
    // framework e non un cliente, e il punto interrogativo dell'applicazione lo premono gli utenti,
    // che la password dell'utente `docs` non ce l'hanno. Per questo qui non si chiama
    // docsBuildProtezione() e per questo stanno sotto _usr/_pages/, che _usr/_docs/.htaccess lascia
    // aperta di proposito. Quello che va protetto e' il manuale DEL PROGETTO, qui sopra.
    if( ( $tutto || isset( $opt['standard'] ) ) && docsBuildPath( 'var/docs.build.conf' ) ) {

        echo "documentazione dello standard:\n";

        docsBuildQuickstart( '_usr/_docs/_quickstart', '_usr/_pages/_quickstart', array( 'pubblico' => NULL, 'linea' => $linea, 'secco' => $secco ) );

        docsBuildManuale( 'USER', '_usr/_pages/_manual/user', array(
            'pubblico' => array( 'operatore', 'amministratore' ),
            'linea'    => $linea,
            'titolo'   => 'manuale utente',
            'standard' => true,
            'secco'    => $secco
        ) );

        docsBuildManuale( 'READ', '_usr/_pages/_manual/read', array(
            'pubblico' => array( 'sviluppatore', 'amministratore' ),
            'linea'    => $linea,
            'titolo'   => 'manuale sviluppatore',
            'standard' => true,
            'secco'    => $secco
        ) );

    }

    exit( 0 );
