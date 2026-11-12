<?php

    /**
     * test statico dei template dei moduli
     *
     * il loader Twig aggiunge le cartelle dei template di un modulo solo se il modulo e' attivo, quindi un template
     * che importa una libreria di macro di un altro modulo ( {% import 'lib/<libreria>.twig' as <alias> %} ) si
     * ferma su Unable to find template in ogni deploy dove quell'altro modulo manca; fino al 2026-11-04 diciotto
     * template di _CT000, _CO000, _AT000, _IM000, _PA000 e _03000 importavano cosi' librerie che poi non usavano,
     * e su utensilerialughese ( _CT000 senza _NO000 e _PA000 ) la scheda dei contatti non si apriva
     *
     * il test legge i sorgenti e non li esegue; una libreria che non sta ne' nel template di base ne' nel modulo
     * stesso e' ammessa solo se il template ne usa davvero una macro, e allora la dipendenza fra i moduli e' voluta
     *
     */

    class staticoTemplateCest {

        // import di librerie di altri moduli: ammessi solo se usati
        public function importDiAltriModuli( UnitTester $I ) {

            $template = (array) glob( DIR_BASE . '_mod/*/_src/_tpl/*/{,*/,*/*/}*.twig', GLOB_BRACE );

            $I->assertNotEmpty( $template, 'nessun template trovato: il test non prova niente' );

            $inutili = array();

            foreach( $template as $file ) {

                // _mod/<modulo>/_src/_tpl/<template>/...
                $parti = explode( '/', str_replace( DIR_BASE, '', $file ) );
                $modulo = $parti[1];
                $tpl = $parti[4];

                $codice = file_get_contents( $file );

                preg_match_all( '/\{%\s*import\s+\'lib\/([^\']+)\'\s+as\s+(\w+)\s*%\}/', $codice, $import, PREG_SET_ORDER );

                foreach( $import as $m ) {

                    // libreria del template di base o del modulo stesso
                    if( is_file( DIR_BASE . '_src/_tpl/' . $tpl . '/lib/' . $m[1] ) || is_file( DIR_BASE . '_mod/' . $modulo . '/_src/_tpl/' . $tpl . '/lib/' . $m[1] ) ) {
                        continue;
                    }

                    // libreria di un altro modulo, usata davvero
                    if( preg_match( '/(?<![\w.])' . $m[2] . '\.\w+\s*\(/', $codice ) ) {
                        continue;
                    }

                    $inutili[] = str_replace( DIR_BASE, '', $file ) . ' ( lib/' . $m[1] . ' )';

                }

            }

            $I->assertEmpty( $inutili, 'import inutili di librerie di altri moduli: ' . implode( ', ', $inutili ) );

        }

        // template su Bootstrap 5: niente classi e attributi di Bootstrap 4
        //
        // la versione di Bootstrap la dichiara ogni template in etc/template.yaml, e una classe BS4 rimasta in un
        // template BS5 non da' errore: semplicemente non corrisponde a nessuna regola ( ml-auto non allinea piu',
        // data-toggle non apre piu' il menu, order-12 non ordina piu' ); il test guarda solo i file del template,
        // non il livello condiviso di _src/_twig/, che resta congelato finche' esiste un template di pagina su BS4,
        // e lascia stare form-row, che nel markup sta sempre accanto a row e a cui i CSS di progetto si agganciano, e
        // jumbotron, che in BS5 non ha piu' regole ma resta come aggancio dei CSS di template ( _lydia/css/main.css )
        public function classiBs4NeiTemplateBs5( UnitTester $I ) {

            $morti = '/\b(?:data-(?:toggle|target|dismiss|ride|slide|slide-to|interval|parent|placement)=|'
                . '(?<=["\s])(?:m[lr]-(?:sm-|md-|lg-|xl-)?(?:auto|[0-5])|p[lr]-(?:sm-|md-|lg-|xl-)?[0-5]|text-(?:left|right)|'
                . 'float-(?:left|right)|no-gutters|font-weight-\w+|sr-only|input-group-(?:append|prepend)|btn-block|'
                . 'order-(?:[6-9]|1[012])|badge-(?:primary|secondary|success|danger|warning|info|light|dark))(?=["\s]))/';

            $controllati = 0;
            $trovati = array();

            foreach( (array) glob( DIR_BASE . '_src/_tpl/*/etc/template.yaml' ) as $yaml ) {

                if( strpos( file_get_contents( $yaml ), 'bootstrap@5' ) === false ) {
                    continue;
                }

                $controllati++;

                foreach( (array) glob( dirname( dirname( $yaml ) ) . '/{,*/,*/*/}*.twig', GLOB_BRACE ) as $file ) {

                    // i commenti Twig si svuotano tenendo gli a capo, cosi' i numeri di riga restano quelli del file
                    $codice = preg_replace_callback( '/\{#.*?#\}/s', function( $c ) { return preg_replace( '/[^\n]/', ' ', $c[0] ); }, file_get_contents( $file ) );

                    foreach( explode( "\n", $codice ) as $n => $riga ) {
                        if( preg_match( $morti, $riga, $m ) ) {
                            $trovati[] = str_replace( DIR_BASE, '', $file ) . ':' . ( $n + 1 ) . ' ( ' . $m[0] . ' )';
                        }
                    }
                }

            }

            $I->assertGreaterThan( 0, $controllati, 'nessun template su Bootstrap 5 trovato: il test non prova niente' );

            $I->assertEmpty( $trovati, 'classi o attributi BS4 in template BS5: ' . implode( ', ', $trovati ) );

        }

        // la barra delle categorie si disegna solo se il menu c'e', come la navbar di _cassandra e _aurora: senza la guardia
        // un sito senza categorie mostra una barra vuota e, su mobile, un hamburger che non apre niente ( glisweb.it, 12/11/2026 )
        public function barraCategorieSoloColMenu( UnitTester $I ) {

            $barre = (array) glob( DIR_BASE . '_src/_tpl/*/inc/categorie.twig' );

            $I->assertNotEmpty( $barre, 'nessuna barra delle categorie trovata: il test non prova niente' );

            $senzaGuardia = array();

            foreach( $barre as $file ) {
                if( strpos( file_get_contents( $file ), '{% if page.template.menu.categorie %}' ) === false ) {
                    $senzaGuardia[] = str_replace( DIR_BASE, '', $file );
                }
            }

            $I->assertEmpty( $senzaGuardia, 'barra delle categorie senza guardia sul menu: ' . implode( ', ', $senzaGuardia ) );

        }

        // il cambio lingua di _lydia: inc/flags.twig chiama la macro standard nav.flags() ed e' incluso nella testata; fino
        // al 12/11/2026 era un segnaposto vuoto mai incluso, e da www.glisweb.it non si arrivava alle pagine inglesi
        public function cambioLinguaLydia( UnitTester $I ) {

            $I->assertStringContainsString( 'nav.flags( page, localization.language.ietf, site )', file_get_contents( DIR_BASE . '_src/_tpl/_lydia/inc/flags.twig' ) );
            $I->assertStringContainsString( "{% include 'inc/flags.twig' %}", file_get_contents( DIR_BASE . '_src/_tpl/_lydia/inc/navbar.twig' ) );
            $I->assertFileExists( DIR_BASE . '_src/_img/_flags/_webp/_gb.webp' );
            $I->assertFileExists( DIR_BASE . '_src/_img/_flags/_webp/_it.webp' );

        }

        // in _lydia il margine generale di .form-control staccava il campo di ricerca dal suo pulsante nell'input-group
        public function ricercaLydiaSenzaMargine( UnitTester $I ) {

            $css = file_get_contents( DIR_BASE . '_src/_tpl/_lydia/css/main.css' );

            $I->assertMatchesRegularExpression( '/div\.search-box \.form-control\s*\{\s*margin-bottom:\s*0(em)?;/', $css );

        }

    }
