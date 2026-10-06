<?php

    /**
     * helper Codeception per il framework
     *
     * introduzione
     * ============
     * Questo modulo collega i test al deploy: usa il framework avviato da _usr/_test/_bootstrap.php ( quindi $cf,
     * la connessione al database e le librerie ) per preparare e ripulire i dati dei test e per fare il login
     * nel back-end. Si abilita nei file .suite.yml, **prima** di WebDriver.
     *
     * account di test
     * ---------------
     * All'inizio di ogni suite l'helper crea un account per ognuno dei gruppi elencati nella configurazione
     * gruppi ( di default roots ), chiamato test-<gruppo> e con una password casuale diversa a ogni giro, e alla
     * fine della suite li cancella. Gli account test-* rimasti da un giro interrotto vengono tolti anche
     * all'inizio, prima di crearne di nuovi. Nei test ci si entra con $I->amLoggedInAs( '<gruppo>' ).
     *
     * Il login non passa dal form, perche' il reCAPTCHA v3 da' punteggio zero al browser headless: si usa il
     * login con token JWT del framework, quindi il deploy deve avere auth.jwt.secret nel proprio shadow.
     *
     * record di test
     * --------------
     * I record creati dai test vanno marcati col prefisso TEST-E2E- in un campo di testo ( nome, codice,
     * denominazione... ), cosi' si riconoscono e si tolgono con $I->deleteTestRecords( '<tabella>', '<campo>' ),
     * da chiamare nel metodo _after() del Cest. La pulizia si fa anche prima del test, per lo stesso motivo
     * degli account.
     *
     * I dati che servono al test si preparano con $I->haveInDatabase( '<tabella>', $riga ), che restituisce l'id
     * della riga, e si modificano con $I->updateInDatabase( '<tabella>', $riga ), con l'id nella riga; il prefisso
     * TEST-E2E- in un campo di testo resta a carico del test, perche' e' quello che permette di toglierli.
     *
     * operatore
     * ---------
     * Molte maschere lavorano sull'anagrafica dell'operatore collegato ( presenze, attivita', magazzino ): con
     * anagrafica: true l'helper crea per ogni account di test un'anagrafica test-<gruppo> e la collega
     * all'account; il test ne legge l'id con $I->grabTestAnagrafica( '<gruppo>' ). L'anagrafica non porta il
     * prefisso TEST-E2E-, cosi' la pulizia dei record dei test non la tocca, e se ne va insieme all'account.
     *
     * reCAPTCHA
     * ---------
     * Il reCAPTCHA v3 da' punteggio zero al browser headless, quindi per la durata della suite l'helper crea il
     * file var/test/recaptcha.off, che _src/_config/_115.google.php legge per togliere la chiave privata: i form
     * protetti ( contatti, login ) accettano quello che il test invia. Fuori produzione e per un'ora al massimo;
     * il file si toglie alla fine della suite. Con recaptcha: true nella configurazione il reCAPTCHA resta attivo.
     *
     * pagine
     * ------
     * I percorsi delle pagine si ricavano dai titoli e cambiano da un deploy all'altro: nei test di back-end le
     * pagine si aprono per id con $I->amOnPageId( '<id>' ), p.es. amOnPageId( 'anagrafica.form' ). Il banner dei
     * cookie, che intercetta i click, si chiude con $I->rifiutaCookie().
     *
     * configurazione
     * --------------
     * - gruppi: i gruppi per cui creare un account di test, p.es. [ roots, staff ]; [] per non crearne
     * - recaptcha: true per lasciare attivo il reCAPTCHA durante la suite, di default false
     * - anagrafica: true per collegare a ogni account di test un'anagrafica dell'operatore, di default false
     * - login: la pagina di login, di default /admin.it-IT.html, la dashboard, che a chi non e' loggato mostra il form;
     *   la dashboard e' riservata allo staff, quindi per i gruppi operativi va puntata su una pagina che il gruppo
     *   puo' aprire ( p.es. login: '/app.it-IT.html' ), altrimenti il login col token riesce ma la pagina e' negata
     *
     */

    namespace Helper;

    class Glisweb extends \Codeception\Module {

        /**
         * prefisso degli account di test
         */
        const ACCOUNT_PREFIX = 'test-';

        /**
         * prefisso dei record di test
         */
        const RECORD_PREFIX = 'TEST-E2E-';

        /**
         * configurazione di default
         */
        protected $config = array(
            'gruppi'    => array( 'roots' ),
            'recaptcha' => false,
            'anagrafica'    => false,
            'login'     => '/admin.it-IT.html'
        );

        /**
         * account creati per questo giro, per gruppo
         */
        protected $accounts = array();

        /**
         * preparazione della suite
         *
         * toglie gli account test-* rimasti e crea quelli del giro
         *
         * @param       array       $settings       configurazione della suite
         *
         */
        public function _beforeSuite( $settings = array() ) {

            $this->rimuoviAccountTest();

            foreach( $this->config['gruppi'] as $gruppo ) {
                $this->creaAccountTest( $gruppo );
            }

            // reCAPTCHA spento per la durata della suite, vedi _src/_config/_115.google.php
            if( ! $this->config['recaptcha'] ) {
                touch( DIR_VAR . 'test/recaptcha.off' );
            }

        }

        /**
         * chiusura della suite
         *
         * toglie gli account del giro e riaccende il reCAPTCHA
         *
         */
        public function _afterSuite() {

            $this->rimuoviAccountTest();

            if( file_exists( DIR_VAR . 'test/recaptcha.off' ) ) {
                unlink( DIR_VAR . 'test/recaptcha.off' );
            }

        }

        /**
         * login nel back-end con l'account di test di un gruppo
         *
         * @param       string      $gruppo         il gruppo dell'account, fra quelli della configurazione gruppi
         *
         */
        public function amLoggedInAs( $gruppo = 'roots' ) {

            if( ! isset( $this->accounts[ $gruppo ] ) ) {
                $this->fail( 'nessun account di test per il gruppo ' . $gruppo . ', va aggiunto alla configurazione gruppi della suite' );
            }

            $browser = $this->getModule( 'WebDriver' );

            // la sessione salvata dal primo login evita di rifarlo a ogni test
            if( $browser->loadSessionSnapshot( self::ACCOUNT_PREFIX . $gruppo ) ) {
                return;
            }

            // il login dal form non si puo' usare: il reCAPTCHA v3 da' punteggio zero al browser headless e il
            // framework rifiuta l'accesso come spam; si entra quindi col token JWT, per cui il controllo anti spam
            // e' saltato di proposito, e la sessione aperta resta nel browser per le richieste successive
            $browser->amOnPage( $this->config['login'] . '?j=' . $this->accounts[ $gruppo ]['jwt'] );
            $browser->dontSeeElement( '#formLogin' );
            $this->rifiutaCookie();

            $browser->saveSessionSnapshot( self::ACCOUNT_PREFIX . $gruppo );

        }

        /**
         * apre una pagina del sito a partire dal suo id
         *
         * i percorsi delle pagine si ricavano dai titoli e cambiano da un deploy all'altro, quindi i test non li
         * scrivono a mano ma li chiedono al framework
         *
         * @param       string      $id             l'id della pagina, p.es. anagrafica.form
         * @param       array       $parametri      i parametri della query string, p.es. array( 'anagrafica' => array( 'id' => 1 ) )
         * @param       string      $lingua         la lingua, di default quella corrente
         *
         */
        public function amOnPageId( $id, $parametri = array(), $lingua = NULL ) {

            global $cf;

            $lingua = ( $lingua ) ? $lingua : $cf['localization']['language']['ietf'];

            if( empty( $cf['contents']['pages'][ $id ]['path'][ $lingua ] ) ) {
                $this->fail( 'la pagina ' . $id . ' non esiste in ' . $lingua . ', o il suo modulo non e\' attivo' );
            }

            $this->getModule( 'WebDriver' )->amOnPage(
                $cf['contents']['pages'][ $id ]['path'][ $lingua ] . ( ( $parametri ) ? '?' . http_build_query( $parametri ) : '' )
            );

        }

        /**
         * chiude il banner dei cookie, se c'e', rifiutando tutti i consensi
         *
         * il banner copre la pagina e intercetta i click; il form del banner rimanda alla home, quindi dopo si
         * torna alla pagina di partenza
         *
         */
        public function rifiutaCookie() {

            $browser = $this->getModule( 'WebDriver' );

            $bottoni = $browser->_findElements( '#cookieForm input[value="RIFIUTA TUTTI"]' );

            if( $bottoni && $bottoni[0]->isDisplayed() ) {
                $pagina = $browser->grabFromCurrentUrl();
                $bottoni[0]->click();
                $browser->waitForElementNotVisible( '#cookieForm', 10 );
                $browser->amOnPage( $pagina );
            }

        }

        /**
         * svuota la cache del sito
         *
         * da usare quando il test dipende da qualcosa che il framework tiene in memcache, come l'array delle
         * pagine; fa la stessa pulizia del task /task/memcache.clean per il sito corrente
         *
         */
        public function clearGliswebCache() {

            global $cf;

            memcacheFlush( $cf['memcache']['connection'], $cf['sites']['1']['domains'][ SITE_STATUS ] );

        }

        /**
         * restituisce il prefisso con cui marcare un record di test, seguito da un suffisso univoco
         *
         * @param       string      $nome           una parte leggibile, p.es. il nome del test
         *
         * @return      string                      p.es. TEST-E2E-anagrafica-1759750000
         *
         */
        public function grabTestName( $nome = '' ) {

            return self::RECORD_PREFIX . ( ( $nome ) ? $nome . '-' : '' ) . uniqid();

        }

        /**
         * cancella i record di test di una tabella
         *
         * @param       string      $tabella        la tabella
         * @param       string      $campo          il campo che porta il prefisso TEST-E2E-
         * @param       boolean     $ovunque        true se il prefisso puo' stare in mezzo al campo, p.es. dentro un YAML
         *
         */
        public function deleteTestRecords( $tabella, $campo, $ovunque = false ) {

            global $cf;

            mysqlQuery(
                $cf['mysql']['connection'],
                'DELETE FROM ' . $tabella . ' WHERE ' . $campo . ' LIKE ?',
                array( array( 's' => ( ( $ovunque ) ? '%' : '' ) . self::RECORD_PREFIX . '%' ) )
            );

        }

        /**
         * scrive una riga nel database
         *
         * @param       string      $tabella        la tabella
         * @param       array       $riga           coppie campo => valore; il prefisso TEST-E2E- va messo dal test
         *
         * @return      integer                     l'id della riga scritta
         *
         */
        public function haveInDatabase( $tabella, $riga ) {

            global $cf;

            $id = mysqlInsertRow( $cf['mysql']['connection'], $riga, $tabella, false );

            if( empty( $id ) ) {
                $this->fail( 'riga non scritta in ' . $tabella . ' per ' . json_encode( $riga ) . ', vedi var/log/mysql.err' );
            }

            return $id;

        }

        /**
         * modifica una riga del database
         *
         * @param       string      $tabella        la tabella
         * @param       array       $riga           coppie campo => valore, con l'id della riga da modificare
         *
         */
        public function updateInDatabase( $tabella, $riga ) {

            global $cf;

            if( empty( $riga['id'] ) ) {
                $this->fail( 'per modificare una riga di ' . $tabella . ' serve il suo id' );
            }

            $id = $riga['id'];
            unset( $riga['id'] );

            $set = array();
            foreach( array_keys( $riga ) as $campo ) {
                $set[] = $campo . ' = ?';
            }

            mysqlQuery(
                $cf['mysql']['connection'],
                'UPDATE ' . $tabella . ' SET ' . implode( ', ', $set ) . ' WHERE id = ?',
                $this->parametri( array_merge( array_values( $riga ), array( $id ) ) )
            );

        }

        /**
         * restituisce l'id dell'anagrafica collegata all'account di test di un gruppo
         *
         * @param       string      $gruppo         il gruppo dell'account, fra quelli della configurazione gruppi
         *
         * @return      integer                     l'id dell'anagrafica
         *
         */
        public function grabTestAnagrafica( $gruppo = 'roots' ) {

            if( empty( $this->accounts[ $gruppo ]['id_anagrafica'] ) ) {
                $this->fail( 'l\'account test-' . $gruppo . ' non ha un\'anagrafica: serve anagrafica: true nella configurazione dell\'helper' );
            }

            return $this->accounts[ $gruppo ]['id_anagrafica'];

        }

        /**
         * legge un valore dal database
         *
         * @param       string      $query          la query, con eventuali parametri posizionali
         * @param       array       $parametri      i valori dei parametri, nell'ordine
         *
         * @return      mixed                       il primo campo della prima riga
         *
         */
        public function grabFromDatabase( $query, $parametri = array() ) {

            global $cf;

            return mysqlSelectValue( $cf['mysql']['connection'], $query, $this->parametri( $parametri ) );

        }

        /**
         * verifica che nel database esista almeno una riga che soddisfa la condizione
         *
         * @param       string      $tabella        la tabella
         * @param       array       $condizioni     coppie campo => valore, in AND
         *
         */
        public function seeInDatabase( $tabella, $condizioni ) {

            $this->assertGreaterThan( 0, $this->contaRighe( $tabella, $condizioni ), 'nessuna riga in ' . $tabella . ' per ' . json_encode( $condizioni ) );

        }

        /**
         * verifica che nel database non esista nessuna riga che soddisfa la condizione
         *
         * @param       string      $tabella        la tabella
         * @param       array       $condizioni     coppie campo => valore, in AND
         *
         */
        public function dontSeeInDatabase( $tabella, $condizioni ) {

            $this->assertEquals( 0, $this->contaRighe( $tabella, $condizioni ), 'righe trovate in ' . $tabella . ' per ' . json_encode( $condizioni ) );

        }

        /**
         * conta le righe di una tabella che soddisfano la condizione
         *
         */
        protected function contaRighe( $tabella, $condizioni ) {

            $where = array();
            foreach( array_keys( $condizioni ) as $campo ) {
                $where[] = $campo . ' = ?';
            }

            return (int) $this->grabFromDatabase(
                'SELECT count(*) FROM ' . $tabella . ( ( $where ) ? ' WHERE ' . implode( ' AND ', $where ) : '' ),
                array_values( $condizioni )
            );

        }

        /**
         * trasforma un elenco di valori nei parametri posizionali delle funzioni mysql*()
         *
         */
        protected function parametri( $valori ) {

            $parametri = array();
            foreach( $valori as $valore ) {
                $parametri[] = array( 's' => $valore );
            }

            return ( $parametri ) ? $parametri : false;

        }

        /**
         * crea l'account di test di un gruppo, con una password casuale
         *
         */
        protected function creaAccountTest( $gruppo ) {

            global $cf;

            if( empty( $cf['auth']['jwt']['secret'] ) ) {
                $this->fail( 'per il login dei test serve auth.jwt.secret nello shadow del deploy ( src/shadow.json o src/shadow.yaml )' );
            }

            $idGruppo = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT id FROM gruppi WHERE nome = ?', array( array( 's' => $gruppo ) ) );

            if( empty( $idGruppo ) ) {
                $this->fail( 'il gruppo ' . $gruppo . ' non esiste nel database' );
            }

            $account = array(
                'username'  => self::ACCOUNT_PREFIX . $gruppo,
                'password'  => bin2hex( random_bytes( 16 ) ),
                'id_anagrafica' => NULL
            );

            // anagrafica dell'operatore, per le maschere che lavorano su di lui
            if( $this->config['anagrafica'] ) {
                $account['id_anagrafica'] = mysqlInsertRow(
                    $cf['mysql']['connection'],
                    array(
                        'id'                        => NULL,
                        'nome'                      => $account['username'],
                        'cognome'                   => 'account di test',
                        'timestamp_inserimento'     => time()
                    ),
                    'anagrafica'
                );
            }

            $idAccount = mysqlInsertRow(
                $cf['mysql']['connection'],
                array(
                    'id'                        => NULL,
                    'id_anagrafica'             => $account['id_anagrafica'],
                    'username'                  => $account['username'],
                    'password'                  => passwordHash( $account['password'] ),
                    'se_attivo'                 => 1,
                    'timestamp_inserimento'     => time()
                ),
                'account'
            );

            mysqlInsertRow(
                $cf['mysql']['connection'],
                array(
                    'id'                        => NULL,
                    'id_account'                => $idAccount,
                    'id_gruppo'                 => $idGruppo,
                    'timestamp_inserimento'     => time()
                ),
                'account_gruppi'
            );

            // token JWT per il login
            $account['jwt'] = getJwt(
                array(
                    'id' => $idAccount,
                    'user' => $account['username']
                ),
                $cf['auth']['jwt']['secret']
            );

            $this->accounts[ $gruppo ] = $account;

            $this->debugSection( 'Glisweb', 'creato l\'account ' . $account['username'] . ' ( #' . $idAccount . ' )' );

        }

        /**
         * cancella tutti gli account di test, compresi quelli rimasti da giri interrotti
         *
         * le righe di account_gruppi se ne vanno in cascata; le anagrafiche degli operatori di test si tolgono prima,
         * riconoscendole dal collegamento con l'account e dal nome
         *
         */
        protected function rimuoviAccountTest() {

            global $cf;

            mysqlQuery(
                $cf['mysql']['connection'],
                'DELETE FROM anagrafica WHERE nome LIKE ? AND id IN ( SELECT id_anagrafica FROM account WHERE username LIKE ? )',
                array( array( 's' => self::ACCOUNT_PREFIX . '%' ), array( 's' => self::ACCOUNT_PREFIX . '%' ) )
            );

            mysqlQuery(
                $cf['mysql']['connection'],
                'DELETE FROM account WHERE username LIKE ?',
                array( array( 's' => self::ACCOUNT_PREFIX . '%' ) )
            );

            $this->accounts = array();

        }

    }
