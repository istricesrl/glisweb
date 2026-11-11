<?php

    /**
     * test dei gruppi che vedono le linguette dei media delle schede pagina, notizia e prodotto
     *
     * le linguette immagini, video, audio e file di pagine.form, notizie.form e prodotti.form sono aperte allo staff:
     * fino al 2026-11-11 quelle di pagine e notizie erano dei soli roots, e un redattore staff che voleva mettere un
     * video poteva solo incollare l'iframe di YouTube nel testo, che scavalca il consenso sui cookie; metadati, macro
     * e gruppi restano dei soli roots
     *
     * il test include i file delle pagine dei moduli e non passa dall'array delle pagine, perche' i moduli possono
     * non essere attivi sul deploy che lo fa girare
     *
     */

    class linguetteMediaStaffCest {

        // file delle pagine e prefisso delle schede
        protected $schede = array(
            '_3000.contenuti/_src/_inc/_pages/_contenuti.it-IT.php' => 'pagine',
            '_3100.notizie/_src/_inc/_pages/_notizie.it-IT.php' => 'notizie',
            '_4100.prodotti/_src/_inc/_pages/_prodotti.it-IT.php' => 'prodotti'
        );

        // legge le definizioni delle pagine di un modulo
        protected function pagine( $file ) {
            global $cf;
            $p = array();
            include DIR_MOD . $file;
            return $p;
        }

        // le linguette dei media sono di roots e staff
        public function mediaAlloStaff( UnitTester $I ) {
            foreach( $this->schede as $file => $scheda ) {
                $p = $this->pagine( $file );
                foreach( array( 'immagini', 'video', 'audio', 'file' ) as $linguetta ) {
                    $id = $scheda . '.form.' . $linguetta;
                    $I->assertArrayHasKey( $id, $p, $id . ' non e\' definita in ' . $file );
                    $I->assertContains( 'staff', $p[ $id ]['auth']['groups'], $id . ' non e\' aperta allo staff' );
                    $I->assertContains( 'roots', $p[ $id ]['auth']['groups'], $id . ' non e\' aperta ai roots' );
                }
            }
        }

        // metadati, macro e gruppi di pagine e notizie restano dei soli roots
        public function restoAiRoots( UnitTester $I ) {
            $chiuse = array(
                'pagine.form.metadati', 'pagine.form.macro', 'pagine.form.gruppi',
                'notizie.form.metadati'
            );
            $p = array_merge(
                $this->pagine( '_3000.contenuti/_src/_inc/_pages/_contenuti.it-IT.php' ),
                $this->pagine( '_3100.notizie/_src/_inc/_pages/_notizie.it-IT.php' )
            );
            foreach( $chiuse as $id ) {
                $I->assertEquals( array( 'roots' ), $p[ $id ]['auth']['groups'], $id . ' non e\' piu\' dei soli roots' );
            }
        }

    }
