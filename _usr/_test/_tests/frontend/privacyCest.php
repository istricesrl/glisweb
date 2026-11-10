<?php

    /**
     * test della privacy e cookie policy
     *
     * il testo della pagina privacy e' un contenuto statico dello standard, uno per lingua
     * ( _src/_inc/_contents/_privacy.<lingua>.html ), e si compila coi dati del titolare letti da privacy.persone.titolare
     * della configurazione; il 2026-11-10 sul sito ufficiale GlisWeb la versione inglese usciva vuota, perche' il testo
     * esisteva solo in italiano, e anche quella italiana restava vuota finche' la configurazione aveva il titolare sotto
     * privacy.titolare, la forma vecchia
     *
     * il test apre la pagina in ogni lingua attiva del sito e verifica che ci sia il testo con la denominazione del titolare;
     * un deploy senza titolare in configurazione mostra la pagina "in fase di aggiornamento", e lo si salta
     *
     */

    class privacyCest {

        // il testo della privacy esiste ed esce compilato in ogni lingua attiva
        public function testoPerLingua( FrontendTester $I, \Codeception\Scenario $scenario ) {

            global $cf;

            if( empty( $cf['privacy']['persone']['titolare']['denominazione'] ) ) {
                $scenario->skip( 'il deploy non ha privacy.persone.titolare in configurazione' );
            }

            $mancanti = array();

            foreach( array_keys( $cf['localization']['languages'] ) as $lingua ) {

                if( ! glob( DIR_BASE . '{,_}src/{,_}inc/{,_}contents/{,_}privacy.' . $lingua . '.{html,twig}', GLOB_BRACE ) ) {
                    $mancanti[] = $lingua;
                    continue;
                }

                $I->amOnPageId( 'privacy', array(), $lingua );

                $I->dontSee( 'Unable to find template' );
                $I->see( $cf['privacy']['persone']['titolare']['denominazione'], 'main' );

            }

            $I->assertEmpty( $mancanti, 'manca il testo della privacy per le lingue: ' . implode( ', ', $mancanti ) );

        }

    }
