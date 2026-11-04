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

    }
