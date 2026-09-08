<?php

    /**
     * libreria di funzioni per la generazione della documentazione
     *
     * Questa libreria contiene le funzioni che trasformano i sorgenti markdown della documentazione
     * ( READ.md, USER.md, le quickstart e i loro corrispettivi di modulo ) nelle pagine HTML statiche
     * pubblicate sotto _usr/_pages/ e usr/pages/.
     *
     * introduzione
     * ============
     * La documentazione del framework segue la stessa legge del codice: standard e custom allo stesso
     * percorso, al netto degli underscore. Quello che si documenta e' di due tipi:
     *
     * ambito              | standard                          | custom
     * --------------------|-----------------------------------|----------------------------------
     * il deploy           | _usr/_docs/READ.md e USER.md      | usr/docs/READ.md e USER.md
     * un componente       | _mod/_NOME/READ.md e USER.md     | mod/NOME/READ.md e USER.md
     * le quickstart       | i .md in _usr/_docs/_quickstart/       | i .md in usr/docs/quickstart/
     *
     * I sorgenti portano due tipi di marcatore, entrambi markdown valido: un metadato di sezione, che
     * e' un commento HTML sulla riga successiva al titolo e serve a filtrare, e un callout inline, che
     * e' una citazione con un vocabolo in grassetto in testa e serve al lettore.
     *
     * costanti
     * ========
     * La libreria definisce le seguenti costanti
     *
     * costante                 | spiegazione
     * -------------------------|--------------------------------------------------------------
     * DOCS_META_VOCABOLARIO    | chiavi ammesse nei metadati di sezione
     * DOCS_PUBBLICO_VOCABOLARIO| valori ammessi per il metadato \@pubblico
     * DOCS_LINEA_VOCABOLARIO   | valori ammessi per il metadato \@linea
     * DOCS_CALLOUT_VOCABOLARIO | vocaboli ammessi in testa a un callout
     *
     * funzioni
     * ========
     * La libreria e' divisa in tre gruppi: conversione ( docsMarkdown2Html, docsSlugify,
     * docsAnchorHeadings, docsFixFragments, docsWrapTables ), marcatori ( docsParseSections,
     * docsFilterSections, docsRenderCallouts, docsCollectShots ) e impaginazione ( docsRenderPage ).
     *
     * dipendenze
     * ==========
     * La sola conversione da markdown a HTML dipende da league/commonmark, che vive in
     * _src/_lib/_ext. La dipendenza e' verificata a runtime e non in inclusione: se la libreria manca,
     * docsMarkdown2Html() ritorna false invece di provocare un errore fatale. Serve perche' la
     * generazione viene invocata anche da _src/_sh/_docs.build.sh, che gira dentro _gw.upgrade.sh:
     * un fatal la' dentro fermerebbe l'aggiornamento notturno dello standard.
     *
     * changelog
     * =========
     * Questa sezione riporta la storia delle modifiche piu' significative apportate alla libreria.
     *
     * data             | autore               | descrizione
     * -----------------|----------------------|---------------------------------------------------------------
     * 2026-09-08       | Fabio Mosti          | prima stesura, promozione del convertitore di doc-build
     *
     * licenza
     * =======
     * Questa libreria fa parte del progetto GlisWeb (https://github.com/istricesrl/glisweb) ed e' distribuita
     * sotto licenza Open Source. Fare riferimento alla pagina GitHub del progetto per i dettagli.
     *
     */

    // costanti
    define( 'DOCS_META_VOCABOLARIO'         , array( 'pubblico', 'linea', 'pagina', 'modulo' ) );
    define( 'DOCS_PUBBLICO_VOCABOLARIO'     , array( 'operatore', 'amministratore', 'sviluppatore' ) );
    define( 'DOCS_LINEA_VOCABOLARIO'        , array( 'stable', 'unstable' ) );
    define( 'DOCS_CALLOUT_VOCABOLARIO'      , array(
        'solo stable'           => 'stable',
        'solo unstable'         => 'unstable',
        'solo operatori'        => 'operatore',
        'solo amministratori'   => 'amministratore',
        'solo sviluppatori'     => 'sviluppatore',
        'nota'                  => 'nota',
        'attenzione'            => 'attenzione',
        'esempio'               => 'esempio'
    ) );

    /**
     * genera lo slug di un titolo secondo la convenzione GitHub
     *
     * Minuscolo, rimozione di tutto cio' che non e' lettera, cifra, spazio o trattino, spazi in
     * trattini. Gli spazi multipli NON vengono collassati: e' quello che fa GitHub, ed e' cio' che
     * rende validi i link degli indici gia' scritti nei sorgenti markdown.
     *
     * @param   string      $titolo         testo del titolo
     *
     * @return  string                      slug utilizzabile come id e come frammento
     *
     */
    function docsSlugify( $titolo ) {

        $t = mb_strtolower( $titolo, 'UTF-8' );
        $t = preg_replace( '/[^\p{L}\p{N} \-]/u', '', $t );
        $t = trim( $t );

        return str_replace( ' ', '-', $t );

    }

    /**
     * converte un testo markdown in HTML
     *
     * Utilizza league/commonmark con l'estensione GitHub Flavored Markdown, che aggiunge tabelle,
     * strikethrough e autolink. La presenza della libreria e' verificata a runtime: in sua assenza la
     * funzione ritorna false senza provocare un errore fatale, perche' viene invocata anche da
     * contesti in cui un fatal fermerebbe l'aggiornamento dello standard.
     *
     * @param   string      $md             sorgente markdown
     *
     * @return  string|bool                 HTML generato, oppure false se la libreria non e' disponibile
     *
     */
    function docsMarkdown2Html( $md ) {

        if( ! class_exists( 'League\CommonMark\CommonMarkConverter' ) ) {
            return false;
        }

        $environment = League\CommonMark\Environment::createCommonMarkEnvironment();
        $environment->addExtension( new League\CommonMark\Extension\GithubFlavoredMarkdownExtension() );

        $converter = new League\CommonMark\MarkdownConverter( $environment );

        return (string) $converter->convertToHtml( $md );

    }

    /**
     * aggancia gli id ai titoli e raccoglie l'indice
     *
     * A ogni titolo viene assegnato l'id ricavato con docsSlugify() e viene anteposta un'ancora
     * cliccabile. I titoli del livello richiesto vengono raccolti in $toc, che la funzione popola per
     * riferimento.
     *
     * @param   string      $html           HTML generato dalla conversione
     * @param   array       $toc            indice, popolato per riferimento
     * @param   int         $livello        livello dei titoli da raccogliere nell'indice
     *
     * @return  string                      HTML con id e ancore
     *
     */
    function docsAnchorHeadings( $html, &$toc, $livello = 2 ) {

        $toc = array();

        return preg_replace_callback(
            '#<h([1-6])>(.*?)</h\1>#s',
            function( $m ) use ( &$toc, $livello ) {

                $lvl  = (int) $m[1];
                $text = html_entity_decode( strip_tags( $m[2] ), ENT_QUOTES, 'UTF-8' );
                $id   = docsSlugify( $text );

                if( $lvl === $livello ) {
                    $toc[] = array( 'id' => $id, 'label' => $text );
                }

                return '<h' . $lvl . ' id="' . htmlspecialchars( $id, ENT_QUOTES, 'UTF-8' ) . '">'
                     . '<a class="anchor" href="#' . htmlspecialchars( $id, ENT_QUOTES, 'UTF-8' ) . '" aria-hidden="true">#</a>'
                     . $m[2] . '</h' . $lvl . '>';

            },
            $html
        );

    }

    /**
     * riporta a UTF-8 i frammenti percent-codificati
     *
     * CommonMark percent-codifica i frammenti non ASCII ( #1-cos%C3%A8-... ), mentre gli id dei titoli
     * restano leggibili: senza questa correzione i link interni degli indici non combaciano.
     *
     * @param   string      $html           HTML con i frammenti codificati
     *
     * @return  string                      HTML con i frammenti in chiaro
     *
     */
    function docsFixFragments( $html ) {

        return preg_replace_callback(
            '/href="#([^"]*)"/',
            function( $m ) {
                return 'href="#' . htmlspecialchars( rawurldecode( $m[1] ), ENT_QUOTES, 'UTF-8' ) . '"';
            },
            $html
        );

    }

    /**
     * avvolge le tabelle in un contenitore scrollabile
     *
     * La documentazione contiene tabelle larghe che, senza contenitore, farebbero scorrere in
     * orizzontale l'intera pagina invece della sola tabella.
     *
     * @param   string      $html           HTML da trattare
     *
     * @return  string                      HTML con le tabelle avvolte
     *
     */
    function docsWrapTables( $html ) {

        $html = str_replace( '<table>', '<div class="tw"><table>', $html );
        $html = str_replace( '</table>', '</table></div>', $html );

        return $html;

    }

    /**
     * rende i callout come riquadri
     *
     * Un callout e' una citazione markdown il cui primo elemento e' un vocabolo in grassetto preso dal
     * vocabolario chiuso DOCS_CALLOUT_VOCABOLARIO. E' il meccanismo con cui si segnalano le divergenze
     * fra la linea stable e la linea unstable senza duplicare il documento. Un vocabolo fuori
     * vocabolario NON viene trasformato: resta una citazione leggibile, e _docs.check.sh lo segnala.
     *
     * @param   string      $html           HTML da trattare
     *
     * @return  string                      HTML con i callout resi come riquadri
     *
     */
    function docsRenderCallouts( $html ) {

        // l'apertura e la chiusura vanno sostituite nello stesso passaggio: trattandole separatamente,
        // una citazione normale interposta fra due callout si prenderebbe la chiusura del primo
        $vocabolario = implode( '|', array_map(
            function( $v ) { return preg_quote( $v, '#' ); },
            array_keys( DOCS_CALLOUT_VOCABOLARIO )
        ) );

        return preg_replace_callback(
            '#<blockquote>\s*<p><strong>(' . $vocabolario . ')</strong>(.*?)</blockquote>#is',
            function( $m ) {

                $classe = DOCS_CALLOUT_VOCABOLARIO[ mb_strtolower( $m[1], 'UTF-8' ) ];

                return '<div class="callout callout-' . $classe . '">'
                     . '<p><strong>' . $m[1] . '</strong>' . $m[2] . '</div>';

            },
            $html
        );

    }

    /**
     * rimuove dall'HTML i marcatori interni
     *
     * I metadati di sezione e le dichiarazioni di screenshot sono commenti HTML e sopravvivono alla
     * conversione: sono marcatori di lavorazione e non hanno ragione di finire nella pagina pubblicata.
     *
     * @param   string      $html           HTML da ripulire
     *
     * @return  string                      HTML senza marcatori
     *
     */
    function docsStripMarkers( $html ) {

        return preg_replace( '/^<!--\s*@[a-z]+:.*?-->\s*$\n?/m', '', $html );

    }

    /**
     * scompone un sorgente markdown in sezioni
     *
     * Ogni sezione parte da un titolo e arriva al titolo successivo. I metadati sono i commenti HTML
     * nella forma <!-- @chiave: valore --> collocati subito sotto il titolo: sono markdown valido,
     * invisibili in qualunque renderer, e non interferiscono ne' con il conteggio delle sezioni di
     * _docs.check.sh ( che cerca ^### ) ne' con il burndown ( che cerca ^- [ ).
     *
     * @param   string      $md             sorgente markdown
     *
     * @return  array                       elenco di array con chiavi livello, titolo, meta, corpo
     *
     */
    function docsParseSections( $md ) {

        $sezioni = array();
        $righe   = preg_split( '/\R/', $md );

        // tutto cio' che precede il primo titolo e' il cappello del documento
        $corrente = array( 'livello' => 0, 'titolo' => '', 'meta' => array(), 'corpo' => array() );

        // i marcatori dentro un blocco recintato sono codice di esempio, non metadati
        $recinto = false;

        foreach( $righe as $riga ) {

            if( preg_match( '/^\s*```/', $riga ) ) {
                $recinto = ! $recinto;
            }

            if( ! $recinto && preg_match( '/^(#{1,6})\s+(.*)$/', $riga, $m ) ) {

                $sezioni[] = $corrente;
                $corrente  = array(
                    'livello' => strlen( $m[1] ),
                    'titolo'  => trim( $m[2] ),
                    'meta'    => array(),
                    'corpo'   => array()
                );

                continue;

            }

            // i metadati valgono solo se stanno prima di qualunque contenuto della sezione
            if( ! $recinto
                && empty( array_filter( $corrente['corpo'], 'strlen' ) )
                && preg_match( '/^<!--\s*@([a-z]+):\s*(.*?)\s*-->\s*$/', $riga, $m ) ) {

                $corrente['meta'][ $m[1] ] = array_map( 'trim', explode( ',', $m[2] ) );

                continue;

            }

            $corrente['corpo'][] = $riga;

        }

        $sezioni[] = $corrente;

        return $sezioni;

    }

    /**
     * filtra le sezioni per pubblico e per linea
     *
     * Una sezione senza il metadato corrispondente e' sempre buona: si dichiara solo cio' che
     * restringe. Quando una sezione viene scartata vengono scartate anche le sue sottosezioni, cioe'
     * tutte quelle di livello maggiore che la seguono fino al primo titolo di pari o minore livello:
     * senza questa regola un capitolo escluso lascerebbe orfani i suoi paragrafi.
     *
     * @param   array       $sezioni        sezioni prodotte da docsParseSections()
     * @param   array       $filtri         filtri nella forma array( 'pubblico' => array(), 'linea' => '' )
     *
     * @return  array                       sezioni superstiti
     *
     */
    function docsFilterSections( $sezioni, $filtri ) {

        $superstiti = array();
        $scartaFino = NULL;

        foreach( $sezioni as $s ) {

            // sottosezione di una sezione gia' scartata
            if( $scartaFino !== NULL ) {

                if( $s['livello'] > $scartaFino ) {
                    continue;
                }

                $scartaFino = NULL;

            }

            $tieni = true;

            if( isset( $filtri['pubblico'] ) && ! empty( $s['meta']['pubblico'] ) ) {
                $tieni = (bool) array_intersect( (array) $filtri['pubblico'], $s['meta']['pubblico'] );
            }

            if( $tieni && isset( $filtri['linea'] ) && ! empty( $s['meta']['linea'] ) ) {
                $tieni = in_array( $filtri['linea'], $s['meta']['linea'] );
            }

            if( ! $tieni ) {
                $scartaFino = $s['livello'];
                continue;
            }

            $superstiti[] = $s;

        }

        return $superstiti;

    }

    /**
     * ricompone un sorgente markdown a partire dalle sezioni
     *
     * @param   array       $sezioni        sezioni prodotte da docsParseSections() o da docsFilterSections()
     * @param   int         $spostamento    livelli da aggiungere a ogni titolo, per annidare un documento in un altro
     *
     * @return  string                      sorgente markdown
     *
     */
    function docsRenderSections( $sezioni, $spostamento = 0 ) {

        $out = '';

        foreach( $sezioni as $s ) {

            if( $s['livello'] > 0 ) {
                $lvl  = min( 6, $s['livello'] + $spostamento );
                $out .= str_repeat( '#', $lvl ) . ' ' . $s['titolo'] . "\n";
            }

            $out .= implode( "\n", $s['corpo'] ) . "\n";

        }

        return $out;

    }

    /**
     * raccoglie le dichiarazioni di screenshot presenti in un sorgente
     *
     * Uno screenshot si dichiara accanto all'immagine che lo mostra, nella forma
     * <!-- @shot: id | percorso | larghezzaXaltezza | selettore | attesa -->. Tenere la dichiarazione
     * accanto all'uso e' cio' che rende impossibile uno scatto dichiarato e mai mostrato, o mostrato e
     * mai dichiarato.
     *
     * @param   string      $md             sorgente markdown
     *
     * @return  array                       elenco di array con chiavi id, percorso, larghezza, altezza, selettore, attesa
     *
     */
    function docsCollectShots( $md ) {

        $scatti = array();

        if( ! preg_match_all( '/^<!--\s*@shot:\s*(.*?)\s*-->\s*$/m', $md, $mm ) ) {
            return $scatti;
        }

        foreach( $mm[1] as $riga ) {

            $c = array_map( 'trim', explode( '|', $riga ) );

            if( count( $c ) < 3 ) {
                continue;
            }

            $dim = preg_split( '/[xX]/', $c[2] );

            $scatti[] = array(
                'id'         => $c[0],
                'percorso'   => $c[1],
                'larghezza'  => ( isset( $dim[0] ) ) ? (int) $dim[0] : 1440,
                'altezza'    => ( isset( $dim[1] ) ) ? (int) $dim[1] : 900,
                'selettore'  => ( isset( $c[3] ) && $c[3] !== '' ) ? $c[3] : NULL,
                'attesa'     => ( isset( $c[4] ) ) ? (int) $c[4] : 3000
            );

        }

        return $scatti;

    }

    /**
     * impagina un corpo HTML in una pagina autoconsistente
     *
     * La pagina non ha dipendenze esterne: il CSS viene incorporato, cosi' il documento resta
     * leggibile anche copiato altrove. Il markup e' quello del template della documentazione, con
     * l'indice laterale a sinistra.
     *
     * @param   string      $body           corpo della pagina
     * @param   array       $toc            indice raccolto da docsAnchorHeadings()
     * @param   array       $meta           chiavi titolo, descrizione, nome, sottotitolo, css, data
     *
     * @return  string                      pagina HTML completa
     *
     */
    function docsRenderPage( $body, $toc, $meta ) {

        $d = array(
            'titolo'        => 'documentazione',
            'descrizione'   => '',
            'kicker'        => 'documentazione',
            'nome'          => 'GlisWeb',
            'sottotitolo'   => '',
            'css'           => '',
            'data'          => date( 'Y-m-d' )
        );

        $meta = array_replace( $d, $meta );

        $nav = '';

        foreach( $toc as $v ) {

            // l'indice ripetuto nel corpo non serve anche nella barra laterale
            if( mb_strtolower( $v['label'], 'UTF-8' ) === 'indice' ) {
                continue;
            }

            $nav .= '<a href="#' . htmlspecialchars( $v['id'], ENT_QUOTES, 'UTF-8' ) . '">'
                  . htmlspecialchars( $v['label'], ENT_QUOTES, 'UTF-8' ) . '</a>';

        }

        $titolo      = htmlspecialchars( $meta['titolo'], ENT_QUOTES, 'UTF-8' );
        $descrizione = htmlspecialchars( $meta['descrizione'], ENT_QUOTES, 'UTF-8' );
        $kicker      = htmlspecialchars( $meta['kicker'], ENT_QUOTES, 'UTF-8' );
        $nome        = htmlspecialchars( $meta['nome'], ENT_QUOTES, 'UTF-8' );
        $sottotitolo = htmlspecialchars( $meta['sottotitolo'], ENT_QUOTES, 'UTF-8' );
        $css         = $meta['css'];
        $generato    = $meta['data'];

        return <<<HTML
<!DOCTYPE html>
<html lang="it-IT">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{$titolo}</title>
<meta name="description" content="{$descrizione}">
<meta name="robots" content="noindex, nofollow">
<style>
{$css}
</style>
</head>
<body>

<a class="skip" href="#contenuto">vai al contenuto</a>

<div class="layout">

    <nav class="sidebar" aria-label="indice del documento">
        <div class="sidebar-head">
            <span class="kicker">{$kicker}</span>
            <strong>{$nome}</strong>
            <span class="sub">{$sottotitolo}</span>
        </div>
        <div class="sidebar-nav">
{$nav}
        </div>
        <div class="sidebar-foot">aggiornata il {$generato}</div>
    </nav>

    <main id="contenuto" class="content">
{$body}
    </main>

</div>

</body>
</html>
HTML;

    }
