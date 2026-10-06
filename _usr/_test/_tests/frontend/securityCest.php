<?php

    /**
     * test del firewall applicativo del nucleo
     *
     * verifica il firewall di _src/_inc/_macro/_security.php: la richiesta malevola bloccata, quella innocua che
     * passa, la regola in osservazione che registra senza bloccare, il bando a gradini in var/spool/security/ban/,
     * gli indirizzi da non bandire ( la macchina stessa, allowed.hosts.conf, i crawler verificati col DNS ) e la
     * pagina di sblocco, l'unica che un IP bandito riesce ad aprire
     *
     * le richieste partono dalla macchina stessa, che il firewall non bandisce mai: le prove sul bando quindi non
     * passano da HTTP, ma chiamano securityBan() e securitySpared() con un REMOTE_ADDR finto preso da 192.0.2.0/24
     * ( TEST-NET-1, RFC 5737, che non esiste in rete ); l'accesso sospeso si prova scrivendo a mano il file del bando
     * per l'indirizzo della macchina, perche' e' Apache che lo legge
     *
     * gli status HTTP il browser non li espone, quindi le richieste passano da restCall(); davanti al firewall applicativo
     * c'e' ModSecurity col Core Rule Set, che respinge con 403 gran parte degli attacchi prima che arrivino a PHP, quindi
     * le richieste di prova usano quello che il CRS lascia passare e il firewall applicativo no ( /wp-login.php, lo user
     * agent di feroxbuster )
     *
     */

    class securityCest {

        // rete finta per le prove sul bando
        const RETE = '192.0.2.';

        // pulizia prima e dopo ogni test
        public function _before( FrontendTester $I ) {
            $this->pulisci( $I );
        }

        public function _after( FrontendTester $I ) {
            $this->pulisci( $I );
        }

        // una richiesta malevola viene bloccata, e la macchina che l'ha fatta non viene bandita
        public function richiestaMalevola( FrontendTester $I ) {

            $marcatore = \Helper\Glisweb::RECORD_PREFIX . uniqid();

            $I->assertEquals( 400, $this->scarica( '/wp-login.php?' . $marcatore . '=1', $raw ) );
            $I->assertStringContainsString( 'richiesta bloccata', $raw );

            // il registro dice perche' la macchina non e' stata bandita, e il file del bando non c'e'
            $ip = $this->sorgente( $marcatore, $riga );
            $I->assertNotEmpty( $ip, 'la richiesta bloccata non e\' nel registro del firewall' );
            $I->assertStringContainsString( 'match per la regola', $riga );
            $I->assertStringContainsString( 'non bandito: indirizzo ammesso', $riga );
            $I->assertFileDoesNotExist( DIR_VAR_SPOOL_SECURITY_BAN . $ip );

        }

        // una richiesta innocua passa
        public function richiestaInnocua( FrontendTester $I ) {

            $I->assertEquals( 200, $this->scarica( '/?' . \Helper\Glisweb::RECORD_PREFIX . uniqid() . '=1', $raw ) );

        }

        // una regola in osservazione registra la richiesta ma non la blocca
        public function regolaInOsservazione( FrontendTester $I ) {

            $marcatore = \Helper\Glisweb::RECORD_PREFIX . uniqid();

            $I->assertEquals( 200, $this->scarica( '/?' . $marcatore . '=1', $raw, array( 'User-Agent' => 'feroxbuster/2.10' ) ) );

            $this->sorgente( $marcatore, $riga );
            $I->assertStringContainsString( 'osservazione per la regola', $riga );

        }

        // il bando sale di gradino alla recidiva, e sotto la soglia non scatta
        public function bandoAGradini( FrontendTester $I ) {

            $_SERVER['REMOTE_ADDR'] = self::RETE . '1';

            $I->assertEquals( 'bandito per ' . SECURITY_BAN_STEPS[0] . ' secondi', securityBan( SECURITY_SCORE_LIMIT, 'TEST-E2E' ) );
            $I->assertFileExists( DIR_VAR_SPOOL_SECURITY_BAN . $_SERVER['REMOTE_ADDR'] );
            $I->assertEqualsWithDelta( time() + SECURITY_BAN_STEPS[0], filemtime( DIR_VAR_SPOOL_SECURITY_BAN . $_SERVER['REMOTE_ADDR'] ), 5 );

            $I->assertEquals( 'bandito per ' . SECURITY_BAN_STEPS[1] . ' secondi', securityBan( SECURITY_SCORE_LIMIT, 'TEST-E2E' ) );
            clearstatcache();
            $I->assertEqualsWithDelta( time() + SECURITY_BAN_STEPS[1], filemtime( DIR_VAR_SPOOL_SECURITY_BAN . $_SERVER['REMOTE_ADDR'] ), 5 );

            $_SERVER['REMOTE_ADDR'] = self::RETE . '2';

            $I->assertEquals( '', securityBan( 1, 'TEST-E2E' ) );
            $I->assertFileDoesNotExist( DIR_VAR_SPOOL_SECURITY_BAN . $_SERVER['REMOTE_ADDR'] );

        }

        // la macchina stessa e gli indirizzi di allowed.hosts.conf non si bandiscono, gli altri si'
        public function indirizziAmmessi( FrontendTester $I ) {

            foreach( array( '127.0.0.1', '::1' ) as $ip ) {
                $_SERVER['REMOTE_ADDR'] = $ip;
                $I->assertStringStartsWith( 'indirizzo ammesso', securitySpared(), $ip . ' non e\' risparmiato' );
            }

            $_SERVER['REMOTE_ADDR'] = self::RETE . '1';
            $I->assertEquals( '', securitySpared() );

            // le righe del deploy, se ce ne sono: allowed.hosts.conf e' del deploy e il test non lo scrive
            foreach( ( file_exists( FILE_ALLOWED_HOSTS ) ) ? file( FILE_ALLOWED_HOSTS, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES ) : array() as $riga ) {
                $net = explode( '/', trim( $riga ) );
                if( @inet_pton( $net[0] ) !== false ) {
                    $_SERVER['REMOTE_ADDR'] = $net[0];
                    $I->assertStringStartsWith( 'indirizzo ammesso', securitySpared(), $net[0] . ' e\' in allowed.hosts.conf ma non e\' risparmiato' );
                }
            }

        }

        // un crawler verificato col DNS inverso e diretto non si bandisce
        public function crawlerVerificato( FrontendTester $I ) {

            $ip = '66.249.66.1';

            if( @gethostbyaddr( $ip ) == $ip ) {
                $I->markTestSkipped( 'il DNS inverso non risponde' );
            }

            $_SERVER['REMOTE_ADDR'] = $ip;
            $I->assertStringStartsWith( 'crawler ', securitySpared() );

        }

        // un IP bandito riceve 429 dappertutto tranne che sulla pagina di sblocco
        public function accessoSospesoESblocco( FrontendTester $I ) {

            $marcatore = \Helper\Glisweb::RECORD_PREFIX . uniqid();

            // l'indirizzo con cui la macchina arriva al sito lo dice il registro del firewall
            $this->scarica( '/wp-login.php?' . $marcatore . '=1', $raw );
            $ip = $this->sorgente( $marcatore, $riga );
            $I->assertNotEmpty( $ip, 'la richiesta bloccata non e\' nel registro del firewall' );

            checkPath( DIR_VAR_SPOOL_SECURITY_BAN );
            file_put_contents( DIR_VAR_SPOOL_SECURITY_BAN . $ip, 'TEST-E2E' . PHP_EOL );
            touch( DIR_VAR_SPOOL_SECURITY_BAN . $ip, time() + 120 );

            try {
                $I->assertEquals( 429, $this->scarica( '/', $raw ) );
                $I->assertEquals( 200, $this->scarica( '/sblocco-accesso.it-IT.html', $raw ) );
            } finally {
                @unlink( DIR_VAR_SPOOL_SECURITY_BAN . $ip );
            }

            $I->assertEquals( 200, $this->scarica( '/', $raw ) );

        }

        /**
         * scarica una pagina senza browser, per averne lo status HTTP
         *
         * @return      int                         lo status HTTP della risposta
         *
         */
        protected function scarica( $pagina, &$raw, $headers = array() ) {

            global $cf;

            $raw = NULL;
            $status = NULL;

            restCall( rtrim( $cf['site']['url'], '/' ) . $pagina, METHOD_GET, NULL, MIME_APPLICATION_JSON, MIME_TEXT_PLAIN, $status, $headers, NULL, NULL, $error, NULL, CURLAUTH_BASIC, $raw );

            return (int) $status;

        }

        /**
         * cerca nel registro del firewall la richiesta col marcatore indicato
         *
         * una richiesta puo' lasciare piu' voci ( il match della regola, il limite superato del canale firewall ), quindi
         * i messaggi si restituiscono tutti
         *
         * @param       string      $marcatore      il marcatore messo nella query string della richiesta
         * @param       string      $riga           i messaggi del registro per quella richiesta, uno per riga
         *
         * @return      string                      l'indirizzo da cui e' arrivata la richiesta, vuoto se non c'e'
         *
         */
        protected function sorgente( $marcatore, &$riga ) {

            $riga = '';
            $ip = '';

            foreach( glob( DIR_VAR_SPOOL_SECURITY . '*.log' ) as $file ) {
                if( preg_match_all( '/^(.*)\nsorgente: (\S+)\nurl: [^\n]*' . preg_quote( $marcatore, '/' ) . '/m', file_get_contents( $file ), $m ) ) {
                    $riga = implode( PHP_EOL, $m[1] );
                    $ip = $m[2][0];
                }
            }

            return $ip;

        }

        /**
         * toglie i file della rete finta, i bandi e le voci di registro dei test e riporta l'indirizzo a quello della macchina
         *
         */
        protected function pulisci( FrontendTester $I ) {

            foreach( glob( DIR_VAR_SPOOL_SECURITY . '*.log' ) as $file ) {
                $registro = file_get_contents( $file );
                if( strpos( $registro, \Helper\Glisweb::RECORD_PREFIX ) !== false ) {
                    file_put_contents( $file, preg_replace( '/^[^\n]*\nsorgente: [^\n]*\nurl: [^\n]*' . preg_quote( \Helper\Glisweb::RECORD_PREFIX, '/' ) . '[^\n]*\n(indizi: [^\n]*\n)?\n/m', '', $registro ), LOCK_EX );
                }
            }

            foreach( array_merge(
                glob( DIR_VAR_SPOOL_SECURITY . self::RETE . '*.log' ),
                glob( DIR_VAR_SPOOL_SECURITY_BAN . self::RETE . '*' ),
                glob( DIR_VAR_SPOOL_SECURITY . 'limiti/*/' . self::RETE . '*.log' )
            ) as $file ) {
                unlink( $file );
            }

            foreach( glob( DIR_VAR_SPOOL_SECURITY_BAN . '*' ) as $file ) {
                if( trim( file_get_contents( $file ) ) == 'TEST-E2E' ) {
                    unlink( $file );
                }
            }

            $_SERVER['REMOTE_ADDR'] = '127.0.0.1';

        }

    }
