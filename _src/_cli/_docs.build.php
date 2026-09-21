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
     * le famiglie di componenti che nel manuale stanno in un sottomenu
     *
     * Sono i due insiemi di cui il manuale raccoglie la documentazione un pezzo per volta: i
     * template e i moduli. Il nome vale tre volte — e' la chiave del gruppo, il nome del capitolo
     * che ne fa da testata e la voce del menu — e per questo e' un vocabolario chiuso: chiamare la
     * testata in un altro modo la lascia in fila con gli altri capitoli, senza errori e senza
     * segnali.
     */
    define( 'DOCS_FAMIGLIE', array( 'template', 'moduli' ) );

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
     * elenca TUTTI i moduli presenti nell'albero, attivi o no
     *
     * La documentazione di un modulo si genera anche quando il modulo e' spento, perche' per
     * decidere se accenderlo bisogna prima sapere cosa fa: un capitolo che compare solo dopo
     * l'attivazione non serve a chi deve ancora scegliere.
     *
     * L'attivazione non compare pero' da nessuna parte nel capitolo, ne' nel titolo ne' in testa
     * alla pagina: e' una proprieta' della singola INSTALLAZIONE e non del modulo, mentre qui si
     * documenta il framework. Scritta nel manuale sarebbe sbagliata su ogni altro deploy, e
     * irrilevante per chi il framework lo sta studiando.
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
     * I due manuali non sono due versioni dello stesso documento: sono due documenti con due
     * perimetri. Quello dello STANDARD nasce dai soli sorgenti `_*` e descrive il framework — e'
     * pubblico, ed e' il link che l'applicazione mostra ai suoi utenti. Quello del PROGETTO nasce
     * dai soli sorgenti custom e descrive che cosa in questo deploy e' diverso.
     *
     * ⚠ La documentazione di progetto non e' MAI ridondante rispetto a quella del framework: e'
     * soltanto CORRETTIVA, SOSTITUTIVA o ADDITIVA. Regola data da Fabio il 21/09/2026. Fino a quel
     * giorno il manuale di progetto era la somma dei due, cioe' portava dentro una copia integrale
     * del manuale del framework: due copie della stessa pagina da tenere allineate a mano, che si
     * scoprono divergenti mesi dopo. Il manuale dello standard e' pubblico e ogni pagina di quello
     * di progetto ci rimanda dalla barra laterale, quindi non c'e' niente da ricopiare.
     *
     * Il primo capitolo e' l'introduzione, che nasce dal documento di deploy del proprio piano.
     * Seguono i capitoli numerati e le due sezioni dei template e dei moduli, dove in un manuale di
     * progetto entrano i soli componenti che quel deploy documenta per conto suo.
     *
     * @param   string      $tipo           READ per il manuale sviluppatore, USER per quello utente
     * @param   bool        $standard       se vero documenta lo standard, se falso il solo progetto
     *
     * @return  array                       capitoli, ciascuno con chiave, titolo e file sorgente
     *
     */
    function docsBuildCapitoli( $tipo, $standard = false ) {

        $capitoli = array();

        $introduzione = array();

        // la radice dei sorgenti dice tutto: `_usr/_docs/` per lo standard, `usr/docs/` per il
        // progetto, e nessuno dei due legge i file dell'altro
        if( $f = docsBuildPath( ( ( $standard ) ? '_usr/_docs/' : 'usr/docs/' ) . $tipo . '.md' ) ) {
            $introduzione[] = $f;
        }

        if( $introduzione ) {
            $capitoli[] = array( 'chiave' => 'introduzione', 'titolo' => 'introduzione', 'file' => $introduzione );
        }

        // capitoli aggiuntivi: uno per file, in ordine di nome. E' la sede della documentazione
        // che non appartiene a un modulo ne' e' introduttiva — la reference delle tabelle, quella
        // delle variabili, le guide pratiche. Lo standard legge le proprie, il progetto le proprie.
        //
        // Fra questi c'e' la TESTATA delle due famiglie: il capitolo che porta il nome di una
        // famiglia ( template, moduli ) non resta in fila con gli altri ma diventa la voce da cui
        // si apre il sottomenu dei suoi. E' la documentazione generale di quella famiglia, e il suo
        // posto e' in cima ai capitoli che generalizza, non a meta' dell'elenco dove la porterebbe
        // il numero d'ordine.
        $testate = array();
        $extra   = strtolower( $tipo );

        $cartelle = array( ( $standard ) ? '_usr/_docs/_' . $extra : 'usr/docs/' . $extra );

        foreach( $cartelle as $d ) {

            if( ! $dir = docsBuildPath( $d ) ) {
                continue;
            }

            foreach( glob( $dir . '/*.md' ) as $f ) {

                $nome = basename( $f, '.md' );

                // il numero in testa serve solo a ordinare, non e' parte del titolo
                $titolo = preg_replace( '/^[0-9]+[.-]\s*/', '', $nome );

                if( in_array( $titolo, DOCS_FAMIGLIE, true ) ) {

                    if( ! isset( $testate[ $titolo ] ) ) {
                        $testate[ $titolo ] = array( 'chiave' => $titolo, 'titolo' => $titolo, 'file' => array(), 'testata' => true );
                    }

                    $testate[ $titolo ]['file'][] = $f;

                    continue;

                }

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
        //
        // I template sono tanti: stanno sotto la testata della famiglia, che e' il capitolo della
        // loro documentazione generale, e nel menu si aprono da li'.
        $gruppo = false;

        if( isset( $testate['template'] ) ) {
            $capitoli[] = $testate['template'];
            $gruppo     = 'template';
        }

        foreach( docsBuildTemplate() as $t ) {

            // nel manuale di progetto entrano i soli template che quel deploy documenta per conto
            // suo: il template standard e' gia' descritto nel manuale dello standard, e ricopiarlo
            // qui vorrebbe dire tenere allineate due copie della stessa pagina
            $f = ( $standard )
               ? docsBuildPath( '_src/_tpl/_' . $t . '/' . $tipo . '.md' )
               : docsBuildPath( 'src/tpl/' . $t . '/' . $tipo . '.md' );

            if( $f === false ) {
                continue;
            }

            $capitoli[] = array(
                'chiave' => 'tpl-' . $t,
                'titolo' => 'template ' . $t,
                'breve'  => $t,
                'file'   => array( $f ),
                'gruppo' => $gruppo
            );

        }

        // i moduli, con la stessa struttura dei template
        $gruppo = false;

        if( isset( $testate['moduli'] ) ) {
            $capitoli[] = $testate['moduli'];
            $gruppo     = 'moduli';
        }

        foreach( docsBuildModuli() as $m ) {

            // come i template: nel manuale di progetto entrano i soli moduli che questo deploy
            // documenta per conto suo
            $f = ( $standard )
               ? docsBuildPath( '_mod/_' . $m . '/' . $tipo . '.md' )
               : docsBuildPath( 'mod/' . $m . '/' . $tipo . '.md' );

            if( $f === false ) {
                continue;
            }

            $capitoli[] = array(
                'chiave' => $m,
                'titolo' => 'modulo ' . $m,
                'breve'  => $m,
                'file'   => array( $f ),
                'gruppo' => $gruppo
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
     * Le voci escono divise in due SEZIONI, che sono i due piani della documentazione: quella del
     * progetto descrive questo deploy e sta dietro Basic auth, quella del framework descrive lo
     * standard ed e' pubblica. Tenerle in un elenco unico obbligava a distinguerle dal titolo, e il
     * titolo di un documento non e' il posto dove dire a chi appartiene.
     *
     * Il documento CORRENTE resta nell'elenco, segnato: una sezione che elenca i due manuali del
     * progetto e ne mostra uno solo — l'altro — non dice a chi legge dove si trova, e la sezione
     * cambia forma da una pagina all'altra.
     *
     * Con $tutti la funzione cambia mestiere: non e' piu' la barra laterale di un documento, ma
     * l'elenco completo per la pagina di disimpegno. Allora entrano anche i documenti di PROGETTO,
     * che stanno dietro Basic auth, e la REFERENCE del codice, che una barra laterale non nomina
     * mai. Deciso da Fabio il 21/09/2026: quella pagina e' l'unico indirizzo da mandare a chi deve
     * documentarsi, e un indice che tace tre documenti su sette obbliga a mandarne altri tre.
     *
     * @param   string      $destinazione   cartella o file del documento corrente, relativo alla document root
     * @param   bool        $tutti          elenco completo, per la pagina di disimpegno
     *
     * @return  array                       voci con titolo, nota, href, sezione e il segno del corrente
     *
     */
    function docsBuildAltrove( $destinazione, $tutti = false ) {

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
            array( 'dir' => 'usr/pages/manual/user',    'titolo' => 'documentazione utente',         'c' => 'USER', 'sez' => 'documentazione progetto',
                   'nota' => 'come si usa questa applicazione, dove è diversa dallo standard' ),
            array( 'dir' => 'usr/pages/manual/read',    'titolo' => 'documentazione sviluppatore',   'c' => 'READ', 'sez' => 'documentazione progetto',
                   'nota' => 'le personalizzazioni di questo deploy, per chi ci mette mano' ),
            array( 'dir' => 'usr/pages/quickstart',     'titolo' => 'guide introduttive',            'q' => 'usr/docs/quickstart', 'sez' => 'documentazione progetto',
                   'nota' => 'i percorsi per cominciare, su questo progetto' ),
            array( 'dir' => '_usr/_pages/_manual/user', 'titolo' => 'manuale utente',                'c' => 'USER', 'std' => true, 'sez' => 'documentazione framework',
                   'nota' => 'le maschere del framework, per chi le usa tutti i giorni' ),
            array( 'dir' => '_usr/_pages/_manual/read', 'titolo' => 'manuale sviluppatore',          'c' => 'READ', 'std' => true, 'sez' => 'documentazione framework',
                   'nota' => 'architettura, runlevel, moduli e template: il manuale di riferimento' ),
            array( 'dir' => '_usr/_pages/_quickstart',  'titolo' => 'guide introduttive',            'q' => '_usr/_docs/_quickstart', 'std' => true, 'sez' => 'documentazione framework',
                   'nota' => 'da dove si comincia: installare il framework e farci il primo sito' ),
            array( 'ref' => 'docs/',    'file' => '_usr/_docs/_html/index.html', 'titolo' => 'reference API',        'sez' => 'reference del codice',
                   'nota' => 'generata dai commenti nel codice: ogni file, ogni funzione, ogni parametro' ),
            array( 'ref' => 'docs/pdf', 'file' => '_usr/_docs/_pdf/refman.pdf',  'titolo' => 'reference API in PDF', 'sez' => 'reference del codice',
                   'nota' => 'la stessa, in un documento solo da portarsi via' )
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

        // la destinazione e' una CARTELLA per i documenti, che sono alberi di pagine, e un FILE per
        // la pagina di disimpegno, che sta al primo livello di _usr/_pages/: i livelli da risalire
        // si contano sulla cartella che contiene la pagina e non sul nome del file, altrimenti la
        // pagina di disimpegno rimanderebbe un livello sopra la document root
        $qui   = $url( $destinazione );
        $dove  = ( substr( $qui, -5 ) === '.html' ) ? dirname( $qui ) : $qui;
        $su    = ( $dove === '.' || $dove === '' ) ? '' : str_repeat( '../', count( explode( '/', $dove ) ) );
        $voci  = array();

        foreach( $documenti as $d ) {

            // la reference del codice compare SOLO nella pagina di disimpegno, e solo dove e'
            // davvero raggiungibile: _usr/_docs/.htaccess la apre dove esiste var/docs.public.conf,
            // quindi senza questa condizione il rimando sarebbe un 403 — lo stesso difetto corretto
            // il 16/09/2026 nel pannello informazioni di athena, che offriva un link chiuso
            if( isset( $d['ref'] ) ) {

                if( ! $tutti
                 || docsBuildPath( 'var/docs.public.conf' ) === false
                 || docsBuildPath( $d['file'] ) === false ) {
                    continue;
                }

                $voci[] = array(
                    'titolo'   => $d['titolo'],
                    'nota'     => $d['nota'],
                    'href'     => $su . $d['ref'],
                    'sezione'  => $d['sez'],
                    'corrente' => false
                );

                continue;

            }

            if( ! empty( $d['std'] ) && ! $std ) {
                continue;
            }

            // dalla pagina di disimpegno si rimanda anche ai documenti di progetto: e' un indice e
            // non un documento, e chi ci arriva senza la password vede comunque che esistono
            if( empty( $d['std'] ) && $qui_std && ! $tutti ) {
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

            $voci[] = array(
                'titolo'   => $d['titolo'],
                'nota'     => $d['nota'],
                'href'     => $su . $url( $d['dir'] ) . '/index.html',
                'sezione'  => $d['sez'],
                'corrente' => ( $d['dir'] === $destinazione )
            );

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
     * compone la versione in pagina unica di un manuale e ne ricava il PDF
     *
     * Un manuale spezzato in capitoli si consulta bene e si stampa male: chi lo vuole su carta, o
     * lo vuole leggere dove la rete non c'e', dovrebbe stampare centoquattro pagine una per una.
     * La versione unica raccoglie tutti i capitoli in un documento solo, nello stesso ordine
     * dell'indice, e da quella nasce il PDF.
     *
     * Il PDF lo produce **chromium**, che e' lo stesso strumento con cui il framework fotografa le
     * maschere della documentazione ( `_src/_sh/_docs.shots.sh` ): niente libreria nuova, niente
     * conversione a mano del markup, e il risultato usa il CSS di stampa che le pagine hanno gia'.
     * Dove chromium non c'e' — i deploy cliente, di norma — resta la pagina unica, che il browser
     * stampa lo stesso: la generazione non si ferma, perche' gira dentro `_gw.upgrade.sh`.
     *
     * @param   string      $destinazione   cartella delle pagine, relativa alla document root
     * @param   array       $capitoli       capitoli gia' resi, con chiave, titolo e html
     * @param   array       $opzioni        titolo, css, pdf ( nome del file ), secco
     *
     * @return  bool                        true se il PDF e' stato prodotto
     *
     */
    function docsBuildUnica( $destinazione, $capitoli, $opzioni ) {

        $corpo = '<h1 id="documento">' . htmlspecialchars( $opzioni['titolo'], ENT_QUOTES, 'UTF-8' ) . '</h1>'
               . '<p>Versione in pagina unica, da leggere di seguito e da stampare. I capitoli sono'
               . ' quelli dell\'<a href="index.html">indice del manuale</a>, nello stesso ordine.</p>'
               . '<h2 id="indice">indice</h2><ul>';

        foreach( $capitoli as $c ) {

            $corpo .= '<li><a href="#' . htmlspecialchars( $c['chiave'], ENT_QUOTES, 'UTF-8' ) . '">'
                    . htmlspecialchars( $c['titolo'], ENT_QUOTES, 'UTF-8' ) . '</a></li>';

        }

        $corpo .= '</ul>';

        foreach( $capitoli as $c ) {
            $corpo .= '<section id="' . htmlspecialchars( $c['chiave'], ENT_QUOTES, 'UTF-8' ) . '">' . $c['html'] . '</section>';
        }

        $pagina = docsRenderPage( $corpo, array(), array(
            'titolo'      => $opzioni['titolo'] . ' — versione stampabile',
            'descrizione' => $opzioni['titolo'] . ', tutti i capitoli in una pagina sola',
            'kicker'      => $opzioni['titolo'],
            'sottotitolo' => 'versione stampabile',
            'css'         => $opzioni['css'],
            'classe'      => 'unica'
        ) );

        $html = $destinazione . '/tutto.html';
        $pdf  = $destinazione . '/' . $opzioni['pdf'];

        if( $opzioni['secco'] ) {
            echo "  [prova] $html (" . number_format( strlen( $pagina ) ) . " byte) e $pdf\n";
            return false;
        }

        if( file_put_contents( DOCS_BASE . $html, $pagina ) === false ) {
            fwrite( STDERR, "  NON generato $html: scrittura fallita\n" );
            return false;
        }

        echo "  generato $html (" . number_format( strlen( $pagina ) ) . " byte)\n";

        return docsBuildPdf( $html, $pdf );

    }

    /**
     * converte una pagina gia' scritta nel suo PDF
     *
     * Si converte il file GIA' PUBBLICATO e non una copia temporanea, perche' la pagina cita gli
     * screenshot con un percorso relativo ( `shot/<id>.png` ): convertita da un'altra cartella
     * uscirebbe senza figure, e nessuno se ne accorgerebbe guardando il solo esito del comando.
     *
     * @param   string      $sorgente       pagina da convertire, relativa alla document root
     * @param   string      $destinazione   PDF da scrivere, relativo alla document root
     *
     * @return  bool                        true se il PDF esiste e non e' vuoto
     *
     */
    function docsBuildPdf( $sorgente, $destinazione ) {

        $chrome = '';

        foreach( array( 'chromium', 'chromium-browser', 'google-chrome' ) as $c ) {
            if( trim( (string) shell_exec( 'command -v ' . escapeshellarg( $c ) . ' 2>/dev/null' ) ) !== '' ) {
                $chrome = $c;
                break;
            }
        }

        if( $chrome === '' ) {
            echo "  chromium non installato: niente PDF, resta la pagina unica\n";
            return false;
        }

        // il profilo usa-e-getta e' obbligatorio per chromium headless, e var/tmp e' la stessa
        // cartella di appoggio che usa _docs.shots.sh
        $tmp = DOCS_BASE . 'var/tmp/docs-pdf-' . getmypid();

        if( ! is_dir( DOCS_BASE . 'var/tmp' ) ) {
            mkdir( DOCS_BASE . 'var/tmp', 0750, true );
        }

        @unlink( DOCS_BASE . $destinazione );

        // le due grafie del "niente intestazione": la prima e' quella di chromium fino alla 111,
        // la seconda quella delle versioni nuove. Senza, in testa a ogni foglio finiscono la data
        // e l'indirizzo file:// del server, che non e' un'informazione da stampare.
        //
        // il timeout non e' pignoleria: questo gira dentro _gw.upgrade.sh, di notte, e un chromium
        // che non torna piu' bloccherebbe l'aggiornamento invece della sola documentazione
        $comando = 'timeout 300 ' . escapeshellarg( $chrome )
                 . ' --headless=new --disable-gpu --no-sandbox'
                 . ' --user-data-dir=' . escapeshellarg( $tmp )
                 . ' --print-to-pdf-no-header --no-pdf-header-footer'
                 . ' --print-to-pdf=' . escapeshellarg( DOCS_BASE . $destinazione )
                 . ' ' . escapeshellarg( 'file://' . DOCS_BASE . $sorgente )
                 . ' > /dev/null 2>&1';

        exec( $comando, $uscita, $esito );

        exec( 'rm -rf ' . escapeshellarg( $tmp ) );

        if( ! file_exists( DOCS_BASE . $destinazione ) || filesize( DOCS_BASE . $destinazione ) === 0 ) {
            fwrite( STDERR, "  NON generato $destinazione: chromium non ha prodotto il PDF ( codice $esito )\n" );
            return false;
        }

        chmod( DOCS_BASE . $destinazione, 0640 );

        echo "  generato $destinazione (" . number_format( filesize( DOCS_BASE . $destinazione ) ) . " byte)\n";

        return true;

    }

    /**
     * toglie le pagine di un manuale che non ha piu' niente da dire
     *
     * Un manuale di progetto vuoto e' la condizione NORMALE di un deploy senza personalizzazioni da
     * documentare, e il framework la regge gia' da solo: il link al manuale compare soltanto se la
     * pagina esiste ( _src/_config/_030.common.php ). Quello che non regge e' lasciare sul posto le
     * pagine di un giro precedente, che continuerebbero a essere servite ferme a com'erano — e per
     * un manuale di progetto vorrebbe dire servire per sempre la copia del manuale del framework
     * che fino al 21/09/2026 ci finiva dentro.
     *
     * @param   string      $destinazione   cartella delle pagine, relativa alla document root
     * @param   bool        $secco          se vero dice cosa toglierebbe e non tocca niente
     *
     * @return  void
     *
     */
    function docsBuildVuoto( $destinazione, $secco ) {

        if( ! is_dir( DOCS_BASE . $destinazione ) ) {
            return;
        }

        docsBuildPota( $destinazione, array(), $secco );

        // la versione stampabile non e' un capitolo e docsBuildPota() non la vede: resterebbe
        // l'unico pezzo del manuale ancora servito, per giunta quello che li contiene tutti
        foreach( glob( DOCS_BASE . $destinazione . '/*.pdf' ) as $f ) {

            if( $secco ) {
                echo "  [prova] tolgo $destinazione/" . basename( $f ) . "\n";
            } else {
                unlink( $f );
            }

        }

        // gli screenshot copiati accanto alle pagine non servono piu' a nessuno: la cartella e'
        // generata da docsBuildScreenshot() e non contiene altro
        foreach( glob( DOCS_BASE . $destinazione . '/shot/*.png' ) as $f ) {

            if( $secco ) {
                echo "  [prova] tolgo $destinazione/shot/" . basename( $f ) . "\n";
            } else {
                unlink( $f );
            }

        }

        if( ! $secco && is_dir( DOCS_BASE . $destinazione . '/shot' ) ) {
            @rmdir( DOCS_BASE . $destinazione . '/shot' );
        }

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

            echo "  nessun sorgente $tipo.md, niente da documentare\n";

            docsBuildVuoto( $destinazione, $opzioni['secco'] );

            return 0;

        }

        $css   = ( $f = docsBuildPath( '_usr/_docs/_etc/_page.css' ) ) ? file_get_contents( $f ) : '';
        $fatte = 0;
        $indice = array();

        // gli altri documenti del deploy, per non lasciare la pagina senza uscite
        $altrove = docsBuildAltrove( $destinazione );

        // PRIMA PASSATA: si compone e si filtra il markdown di ogni capitolo, per sapere quali
        // sopravvivono. Le pagine si scrivono solo dopo, perche' ognuna porta in barra laterale
        // l'elenco degli altri capitoli e in fondo il precedente e il successivo: quell'elenco non
        // e' noto finche' non si sa quali capitoli il filtro delle sezioni lascia in piedi.
        $vivi = array();

        foreach( $capitoli as $c ) {

            $md = '';

            foreach( $c['file'] as $f ) {
                $md .= file_get_contents( $f ) . "\n\n";
            }

            $sezioni = docsParseSections( $md );
            $sezioni = docsFilterSections( $sezioni, array( 'pubblico' => $opzioni['pubblico'], 'linea' => $opzioni['linea'] ) );

            $md = docsRenderSections( $sezioni );

            // un capitolo che il filtro ha svuotato non produce una pagina vuota
            if( ! trim( $md ) ) {
                continue;
            }

            $c['md'] = $md;

            $vivi[ $c['chiave'] ] = $c;

        }

        // un capitolo la cui testata non e' sopravvissuta al filtro torna in fila con gli altri:
        // appeso a una voce di menu che non esiste non lo raggiungerebbe nessuno
        foreach( $vivi as $k => $c ) {

            if( ! empty( $c['gruppo'] ) && ! isset( $vivi[ $c['gruppo'] ] ) ) {
                $vivi[ $k ]['gruppo'] = false;
            }

        }

        // l'indice del manuale, quello che ogni pagina si porta in barra laterale
        foreach( $vivi as $c ) {

            $indice[] = array(
                'chiave'  => $c['chiave'],
                'titolo'  => $c['titolo'],
                'breve'   => ( ! empty( $c['breve'] ) ) ? $c['breve'] : $c['titolo'],
                'gruppo'  => ( ! empty( $c['gruppo'] ) ) ? $c['gruppo'] : '',
                'testata' => ! empty( $c['testata'] )
            );

        }

        // la testata di un gruppo elenca i suoi capitoli: e' la pagina che si apre cliccando
        // "template" o "moduli", e senza l'elenco sarebbe l'unico punto della documentazione da cui
        // i capitoli del gruppo non si raggiungono
        foreach( $vivi as $k => $c ) {

            if( empty( $c['testata'] ) ) {
                continue;
            }

            $voci = '';

            foreach( $indice as $i ) {
                if( $i['gruppo'] === $k ) {
                    $voci .= '- [' . $i['breve'] . '](' . $i['chiave'] . '.html)' . "\n";
                }
            }

            if( $voci !== '' ) {
                $vivi[ $k ]['md'] .= "\n\n## i capitoli di questa sezione\n\n" . $voci;
            }

        }

        // un manuale i cui capitoli sono tutti caduti nel filtro non e' diverso da un manuale
        // senza sorgenti: non si scrive nemmeno l'indice, che sarebbe un elenco vuoto
        if( ! $indice ) {

            echo "  nessun capitolo sopravvive al filtro, niente da documentare\n";

            docsBuildVuoto( $destinazione, $opzioni['secco'] );

            return 0;

        }

        // il manuale utente e quello sviluppatore hanno cartelle distinte: con la stessa
        // destinazione si sovrascriverebbero l'indice e l'introduzione a vicenda
        if( ! $opzioni['secco'] && ! is_dir( DOCS_BASE . $destinazione ) ) {
            mkdir( DOCS_BASE . $destinazione, 0750, true );
        }

        // gli screenshot vanno accanto alle pagine: nel markdown sono citati con un percorso
        // relativo ( shot/<id>.png ), che dalla pagina generata deve risolvere
        if( ! $opzioni['secco'] ) {
            docsBuildScreenshot( $destinazione, $standard );
        }

        // SECONDA PASSATA: da markdown a HTML, e basta. I corpi si tengono da parte perche' servono
        // due volte — alla pagina del capitolo e alla versione stampabile, che li rimette in fila in
        // un documento solo — e convertirli una seconda volta sarebbe lavoro doppio e, il giorno che
        // una delle due conversioni cambia, due documenti che non dicono la stessa cosa.
        $corpi = array();

        foreach( $vivi as $c ) {

            $html = docsMarkdown2Html( $c['md'] );

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

            $corpi[] = array(
                'chiave' => $c['chiave'],
                'titolo' => $c['titolo'],
                'gruppo' => ( ! empty( $c['gruppo'] ) ) ? $c['gruppo'] : '',
                'html'   => $html,
                'toc'    => $toc
            );

        }

        // la versione stampabile: tutti i capitoli in una pagina sola, e il PDF che ne esce
        $pdf = docsSlugify( $opzioni['titolo'] ) . '.pdf';

        $stampato = docsBuildUnica( $destinazione, $corpi, array(
            'titolo' => $opzioni['titolo'],
            'css'    => $css,
            'pdf'    => $pdf,
            'secco'  => $opzioni['secco']
        ) );

        // TERZA PASSATA: le pagine, ciascuna con l'indice completo attorno
        foreach( $corpi as $c ) {

            $pagina = docsRenderPage( $c['html'], $c['toc'], array(
                'titolo'      => $opzioni['titolo'] . ' — ' . $c['titolo'],
                'descrizione' => $opzioni['titolo'] . ', capitolo ' . $c['titolo'],
                'kicker'      => $opzioni['titolo'],
                'sottotitolo' => $c['titolo'],
                'css'         => $css,
                'capitoli'    => $indice,
                'corrente'    => $c['chiave'],
                'gruppo'      => $c['gruppo'],
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

        // indice del manuale: i capitoli di un gruppo rientrano sotto la loro testata, come nel menu
        $voci = '';

        foreach( $indice as $i ) {

            if( $i['gruppo'] !== '' ) {
                continue;
            }

            $voci .= '- [' . $i['titolo'] . '](' . $i['chiave'] . '.html)' . "\n";

            foreach( $indice as $j ) {
                if( $j['gruppo'] === $i['chiave'] ) {
                    $voci .= '    - [' . $j['breve'] . '](' . $j['chiave'] . '.html)' . "\n";
                }
            }

        }

        // un manuale di progetto porta le sole differenze, e chi lo apre deve sapere che quello e'
        // tutto: senza questa riga un indice di tre voci sembra un manuale scritto a meta'
        $premessa = ( $standard ) ? '' : "> **nota** — questo manuale raccoglie **soltanto** ciò che in questo deploy è diverso\n"
                                       . "> dallo standard: non è una copia del manuale del framework, ne è la correzione. Tutto\n"
                                       . "> il resto è nel manuale del framework, qui a fianco sotto *documentazione framework*.\n\n";

        // la versione stampabile si annuncia SOLO qui: l'indice e' la pagina da cui si comincia ed e'
        // dove uno cerca il documento intero da portarsi via, mentre in barra laterale sarebbe una
        // voce riletta a ogni pagina per una cosa che si prende una volta sola
        $stampa = 'Tutto il manuale in un documento solo: [versione stampabile](tutto.html)'
                . ( ( $stampato ) ? ', oppure il [PDF](' . $pdf . ').' : '.' ) . "\n\n";

        $html = docsMarkdown2Html( '# ' . $opzioni['titolo'] . "\n\n" . $premessa . $stampa . "## indice\n\n" . $voci );
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

        // 'tutto' non e' un capitolo ma e' una pagina viva: senza questa riga la potatura la
        // toglierebbe a ogni giro, subito dopo averla scritta
        $chiavi = array( 'index' => 1, 'tutto' => 1 );

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

    /**
     * genera la pagina di disimpegno della documentazione
     *
     * E' l'unico indirizzo da dare a chi deve documentarsi: una pagina sola che elenca TUTTI i
     * documenti del deploy — le guide introduttive, i due manuali, la reference del codice, per il
     * progetto e per lo standard — invece dei sei indirizzi che bisognava mandare uno per uno.
     * Chiesta da Fabio il 21/09/2026.
     *
     * Non e' un documento e non ha capitoli: e' l'elenco che docsBuildAltrove() calcola gia' per la
     * barra laterale, reso come pagina. Per questo non ha un sorgente in _usr/_docs/ e non passa dal
     * filtro delle sezioni — quello che dice lo sa gia' la generazione, ed e' quali documenti questo
     * deploy ha davvero.
     *
     * ⚠ Sta sotto _usr/_pages/ come gli altri documenti dello standard, quindi si genera SOLO dove
     * esiste var/docs.build.conf: su un deploy cliente un file scritto sotto _* finirebbe fra i
     * disallineamenti che _gw.upgrade.sh raccoglie ogni notte, e il suo rm -rf ./_* se lo
     * porterebbe via lo stesso.
     *
     * L'indirizzo breve /doc lo fa il .htaccess, nella sezione SCORCIATOIE insieme a /docs/, /cf e
     * /status. La pagina sta in un FILE al primo livello di _usr/_pages/ e non in una cartella
     * perche' i suoi rimandi sono relativi: cosi' /doc e /_doc.html hanno la stessa base e i link
     * valgono da tutt'e due, mentre da dentro una cartella varrebbero solo dall'indirizzo lungo.
     *
     * @param   string      $destinazione   file da scrivere, relativo alla document root
     * @param   array       $opzioni        chiavi secco
     *
     * @return  int                         numero di pagine generate
     *
     */
    function docsBuildDisimpegno( $destinazione, $opzioni ) {

        $voci = docsBuildAltrove( $destinazione, true );

        // nessun documento generato: un indirizzo che risponde con un elenco di niente e' peggio di
        // uno che non risponde, e la pagina di un giro precedente mentirebbe
        if( ! $voci ) {

            echo "  nessun documento da elencare\n";

            if( ! $opzioni['secco'] && file_exists( DOCS_BASE . $destinazione ) ) {
                unlink( DOCS_BASE . $destinazione );
                echo "  tolta $destinazione\n";
            }

            return 0;

        }

        $css = ( $f = docsBuildPath( '_usr/_docs/_etc/_page.css' ) ) ? file_get_contents( $f ) : '';

        $md      = "# documentazione GlisWeb\n\nTutti i documenti di questo deploy, in un indirizzo solo.\n\n";
        $sezione = '';

        foreach( $voci as $v ) {

            if( $v['sezione'] !== $sezione ) {

                $md     .= '## ' . $v['sezione'] . "\n\n";
                $sezione = $v['sezione'];

                // chi riceve questo indirizzo non ha la password del manuale di progetto: dirglielo
                // qui costa una riga, fargliela scoprire dalla finestra del browser costa una mail
                if( $sezione === 'documentazione progetto' ) {
                    $md .= "> **nota** — i documenti di progetto descrivono le personalizzazioni di questo\n"
                         . "> deploy e chiedono una password. Quelli del framework, più sotto, sono aperti.\n\n";
                }

            }

            $md .= '- [' . $v['titolo'] . '](' . $v['href'] . ')'
                 . ( ( ! empty( $v['nota'] ) ) ? ' — ' . $v['nota'] : '' ) . "\n";

        }

        $html = docsMarkdown2Html( $md );

        if( $html === false ) {
            fwrite( STDERR, "league/commonmark non disponibile: nessuna pagina generata\n" );
            return 0;
        }

        $toc  = array();
        $html = docsAnchorHeadings( $html, $toc );
        $html = docsRenderCallouts( $html );
        $html = docsStripMarkers( $html );

        // in barra laterale ci va il solo indice delle sezioni e NON l'elenco dei documenti: qui i
        // documenti sono il contenuto della pagina, e un menu identico al corpo ripete la stessa
        // cosa a due dita di distanza
        $pagina = docsRenderPage( $html, $toc, array(
            'titolo'      => 'documentazione GlisWeb',
            'descrizione' => 'tutti i manuali e le guide di questo deploy, in un indirizzo solo',
            'kicker'      => 'documentazione',
            'sottotitolo' => 'da dove si comincia',
            'css'         => $css
        ) );

        if( $opzioni['secco'] ) {
            echo "  [prova] $destinazione (" . number_format( strlen( $pagina ) ) . " byte)\n";
            return 1;
        }

        if( file_put_contents( DOCS_BASE . $destinazione, $pagina ) === false ) {
            fwrite( STDERR, "  NON generato $destinazione: scrittura fallita\n" );
            return 0;
        }

        echo "  generato $destinazione (" . number_format( strlen( $pagina ) ) . " byte)\n";

        return 1;

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

    // la pagina di disimpegno: un indirizzo solo — /doc — da mandare a chi deve documentarsi,
    // invece dei sei dei singoli documenti.
    //
    // Si rifa' a ogni giro qualunque sia il bersaglio, e non solo con --standard, perche' quello che
    // dice e' quali documenti ESISTONO: l'elenco cambia proprio quando se ne genera uno. Vale pero'
    // la stessa condizione dei documenti dello standard, e per lo stesso motivo — scrive sotto _*.
    if( docsBuildPath( 'var/docs.build.conf' ) ) {

        echo "pagina di disimpegno:\n";

        docsBuildDisimpegno( '_usr/_pages/_doc.html', array( 'secco' => $secco ) );

    }

    exit( 0 );
