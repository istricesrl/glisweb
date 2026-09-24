<?php

    /**
     * libreria per l'invio di mail tramite PhpMailer
     *
     * Questa libreria contiene alcune funzioni utili per l'invio di mail tramite phpmailer.
     *
     * introduzione
     * ============
     * Nel framework le mail non si inviano quasi mai direttamente: si accodano nella tabella mail_out con queueMail() o, più
     * spesso, con queueMailFromTemplate(), e il task _src/_api/_task/_mail.queue.send.php le preleva una alla volta, le invia
     * con sendMail() e le sposta nella tabella mail_sent. In questo modo la pagina che genera la mail non aspetta il server SMTP,
     * e una mail che non parte resta in coda invece di andare persa.
     *
     * Mittente e destinatari viaggiano sempre come array nel formato 'nome' => 'indirizzo'; nella coda sono salvati serializzati,
     * e le funzioni di conversione permettono di trasformarli in stringhe leggibili e viceversa per mostrarli e modificarli nei
     * form del modulo della posta.
     *
     * costanti
     * ========
     * Questa libreria non definisce costanti.
     *
     * funzioni
     * ========
     * Le funzioni di questa libreria sono divise in gruppi in base al lavoro che svolgono; nei paragrafi successivi le analizzeremo nel dettaglio.
     *
     * funzioni di invio
     * -----------------
     * Le funzioni in questo gruppo servono per inviare effettivamente le mail.
     *
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * sendMail()                       | invia una mail
     *
     * funzioni di accodamento
     * -----------------------
     * Le funzioni in questo gruppo servono per inserire le mail nella coda di uscita.
     *
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * queueMailFromTemplate()          | accoda una mail utilizzando un template
     * queueMail()                      | accoda una mail
     *
     * funzioni di conversione
     * -----------------------
     * Le funzioni in questo gruppo servono per convertire gli elenchi di indirizzi fra la forma array e la forma stringa.
     *
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * mailString2array()               | converte una stringa di indirizzi in un array
     * array2mailString()               | converte un array di indirizzi in una stringa
     *
     * dipendenze
     * ==========
     * Questa libreria ha alcune dipendenze che devono essere soddisfatte per funzionare correttamente. In particolare
     * sono richieste le seguenti funzioni e classi:
     *
     * funzione                         | libreria di appartenenza
     * ---------------------------------|---------------------------------------------------------------
     * logWrite()                       | _src/_lib/_log.utils.php
     * fullPath()                       | _src/_lib/_filesystem.tools.php
     * readStringFromFile()             | _src/_lib/_filesystem.tools.php
     * path2url()                       | _src/_lib/_filesystem.utils.php
     * mysqlQuery()                     | _src/_lib/_mysql.tools.php
     * PHPMailer\PHPMailer\PHPMailer    | phpmailer/phpmailer ( Composer )
     * Html2Text\Html2Text              | html2text/html2text ( Composer )
     * Twig\Environment                 | twig/twig ( Composer )
     *
     * changelog
     * =========
     * Questa sezione riporta la storia delle modifiche più significative apportate alla libreria.
     *
     * data             | autore               | descrizione
     * -----------------|----------------------|---------------------------------------------------------------
     * 2026-09-24       | Fabio Mosti          | documentazione
     *
     * licenza
     * =======
     * Questa libreria fa parte del progetto GlisWeb (https://github.com/istricesrl/glisweb) ed è distribuita
     * sotto licenza Open Source. Fare riferimento alla pagina GitHub del progetto per i dettagli.
     *
     */

    /**
     * FUNZIONI DI INVIO
     */

    /**
     * invia una mail
     *
     * Questa funzione invia immediatamente una mail via SMTP con PHPMailer, senza passare dalla coda; nel framework la chiama
     * solo il task che evade la coda ( _src/_api/_task/_mail.queue.send.php ), che le passa i campi di una riga di mail_out dopo
     * averli deserializzati. Il corpo è HTML, e ne viene generata automaticamente la versione testuale con Html2Text.
     *
     * La cifratura dipende dalla porta: TLS sulla 587, SSL sulla 465, nessuna sulle altre; l'autenticazione SMTP si attiva solo
     * se $user non è vuoto. I destinatari CC e BCC con indirizzo vuoto vengono saltati, gli allegati che non esistono o non si
     * possono leggere vengono saltati e loggati a LOG_CRIT, e i parametri che non sono array ( la coda contiene davvero valori
     * NULL serializzati ) vengono ignorati. Il mittente è invece obbligatorio: se il suo indirizzo non è valido la mail non
     * viene inviata e la funzione restituisce false.
     *
     * La firma DKIM viene applicata se esiste il file etc/secret/\<dominio\>/dkim.private.pem, con il selettore fisso glisweb;
     * il dominio è $dkim_domain se non è vuoto, altrimenti quello del mittente, e con lo stesso dominio si firma ( DKIM_domain ).
     * La passphrase si legge da etc/secret/\<dominio\>/dkim.password.key se c'è ( come stringa, senza gli spazi e l'a capo
     * finali ), altrimenti si usa $dkim_pasw.
     *
     * PHPMailer viene creato senza eccezioni: se l'invio fallisce l'errore di PHPMailer viene loggato a LOG_CRIT nel canale mail
     * e la funzione restituisce false, e il task della coda rimanda la mail con un tentativo in più; un destinatario, un allegato
     * o un header che PHPMailer rifiuta viene saltato senza interrompere l'invio.
     *
     * Nel canale mail la password SMTP compare solo come impostata o non impostata. La trascrizione del dialogo SMTP va nel
     * canale details/phpmailer/send, a LOG_DEBUG e solo se il sito logga a quel livello; le credenziali non vi compaiono.
     *
     * @param       string      $host           l'indirizzo del server SMTP
     * @param       array       $from           il mittente, nel formato 'nome' => 'indirizzo' ( si usa il primo elemento )
     * @param       array       $to             i destinatari, nel formato 'nome' => 'indirizzo'
     * @param       string      $oggetto        l'oggetto della mail
     * @param       string      $corpo          il corpo della mail in HTML
     * @param       array       $cc             i destinatari in copia, nel formato 'nome' => 'indirizzo' ( default nessuno )
     * @param       array       $bcc            i destinatari in copia nascosta, nel formato 'nome' => 'indirizzo' ( default nessuno )
     * @param       array       $attach         i percorsi dei file da allegare, relativi a DIR_BASE o assoluti ( default nessuno )
     * @param       array       $headers        gli header aggiuntivi, nel formato 'nome' => 'valore' ( default nessuno )
     * @param       string      $user           lo username SMTP ( default NULL, nessuna autenticazione )
     * @param       string      $pasw           la password SMTP ( default NULL )
     * @param       int         $port           la porta del server SMTP ( default 25 )
     * @param       string      $dkim_domain    il dominio per la firma DKIM ( default NULL, il dominio del mittente )
     * @param       string      $dkim_pasw      la passphrase della chiave DKIM, se non c'è il file dkim.password.key ( default NULL )
     *
     * @return      bool                        true se la mail è stata inviata, false se il mittente non è valido o l'invio fallisce
     *
     */
    function sendMail($host, $from, $to, $oggetto, $corpo, $cc = array(), $bcc = array(), $attach = array(), $headers = array(), $user = NULL, $pasw = NULL, $port = 25, $dkim_domain = NULL, $dkim_pasw = NULL)
    {

        // debug
        // ini_set('display_errors', 1);
        // ini_set('display_startup_errors', 1);
        // error_reporting(E_ALL);

        // log
        logWrite(
            'sending: '    . $oggetto            . ' ' .
                'to: '        . print_r($to, true)        . ' ' .
                'cc: '        . print_r($cc, true)        . ' ' .
                'bcc: '        . print_r($bcc, true)    . ' ' .
                'attach: '    . print_r($attach, true)    . ' ',
            'mail',
            LOG_DEBUG
        );

        // esito dell'operazione
        $status                = true;

        // creazione dell'oggetto mail
        // NOTA senza eccezioni Send() restituisce false e l'errore resta in ErrorInfo, che il ramo di log qui sotto scrive a
        // LOG_CRIT; con le eccezioni attive la mail restava in mail_out con il token del task e non veniva più ripresa ( 2026-09-24 )
        $mail                = new PHPMailer\PHPMailer\PHPMailer(false);

        // configurazione dell'oggetto mail
        $mail->IsSMTP();
        $mail->Host                    = $host;
        $mail->Port                    = $port;
        // NOTA il livello di debug di PHPMailer ( 1 client, 2 server ) veniva passato a logWrite() come livello di log, per cui la
        // trascrizione SMTP finiva a LOG_ALERT e LOG_CRIT e si scriveva anche in produzione; ora la trascrizione si attiva solo
        // quando il sito logga a LOG_DEBUG e si scrive a LOG_DEBUG. Sotto DEBUG_LOWLEVEL PHPMailer non trascrive le credenziali
        // inviate con AUTH ( [credentials hidden] ), che quindi non vanno mai nel log ( 2026-09-24 ).
        $mail->SMTPDebug            = ( defined('LOG_CURRENT_LEVEL') && LOG_CURRENT_LEVEL >= LOG_DEBUG ) ? PHPMailer\PHPMailer\SMTP::DEBUG_SERVER : PHPMailer\PHPMailer\SMTP::DEBUG_OFF;
        $mail->Debugoutput            = function ($str, $level) {
            logWrite('(' . $level . ') ' . $str, 'details/phpmailer/send', LOG_DEBUG);
        };

        // log
        logWrite(
            'server: '    . $host        . ' ' .
                'port: '    . $port        . ' ' .
                'user: '    . $user        . ' ' .
                'pass: '    . ( empty( $pasw ) ? 'non impostata' : 'impostata' ),
            'mail',
            LOG_DEBUG
        );

        // autenticazione
        if (! empty($user)) {
            $mail->SMTPAuth            = true;
            $mail->Username            = $user;
            $mail->Password            = $pasw;
        } else {
            $mail->SMTPAuth            = false;
        }

        // TLS
        if ($port == '587') {
            $mail->SMTPSecure        = 'tls';
        }

        // SSL
        if ($port == '465') {
            $mail->SMTPSecure        = 'ssl';
        }

        // configurazione dell'oggetto mail
        // $mail->IsHTML			= true;
        $mail->CharSet            = 'UTF-8';
        $mail->Encoding            = 'base64';

        // mittente della mail
        // NOTA come per i destinatari piu' sotto, $from arriva da unserialize() di una colonna
        // della coda e puo' non essere un array: senza guardia array_keys()/current() sollevano
        // un warning. Con la guardia $fromMail resta vuoto e il filter_var() qui sotto scarta la
        // mail, che e' gia' il comportamento previsto.
        $fromName               = is_array($from) ? current(array_keys($from)) : '';
        $fromMail               = is_array($from) ? current($from) : '';

        // se la mail mittente è un indirizzo e-mail corretto
        if (filter_var($fromMail, FILTER_VALIDATE_EMAIL)) {

            $expDomain              = explode('@', $fromMail);
            $fromDomain             = end($expDomain);

            // mittente
            $mail->SetFrom($fromMail, $fromName);
            $mail->AddReplyTo($fromMail, $fromName);
            $mail->Sender = $fromMail;

            // oggetto
            $mail->Subject            = $oggetto;

            // creo il testo in plain text
            $text = new \Html2Text\Html2Text($corpo);

            // corpo alternativo
            $mail->AltBody            = wordwrap($text->getText());

            // corpo del messaggio
            $mail->MsgHTML($corpo);

            // destinatari
            // NOTA il chiamante (_src/_api/_task/_mail.queue.send.php) passa qui il risultato di
            // unserialize() su una colonna della coda: quando il valore serializzato non e' un
            // array il foreach solleva "Invalid argument supplied for foreach()". In coda si
            // trovano davvero valori 'N;' (NULL serializzato) su destinatari_bcc. Gli allegati e
            // gli header erano gia' protetti da is_array(): qui si allinea il resto.
            if (is_array($to)) {
                foreach ($to as $destName => $destAddress) {
                    $mail->AddAddress(trim($destAddress), trim($destName));
                }
            }

            // destinatari CC
            if (is_array($cc)) {
                foreach ($cc as $destName => $destAddress) {
                    if (! empty($destAddress)) {
                        $mail->AddCC(trim($destAddress), trim($destName));
                    }
                }
            }

            // destinatari BCC
            if (is_array($bcc)) {
                foreach ($bcc as $destName => $destAddress) {
                    if (! empty($destAddress)) {
                        $mail->AddBCC(trim($destAddress), trim($destName));
                    }
                }
            }

            // allegati
            if (is_array($attach)) {
                foreach ($attach as $vAtch) {
                    fullPath($vAtch);
                    if (file_exists($vAtch) && is_readable($vAtch)) {
                        $mail->AddAttachment($vAtch, basename($vAtch));
                    } else {
                        logWrite('impossibile allegare ' . $vAtch . ' (file non trovato o non leggibile)', 'mail', LOG_CRIT);
                    }
                }
            }

            // headers
            if (is_array($headers)) {
                foreach ($headers as $hKey => $hVal) {
                    $mail->addCustomHeader($hKey, $hVal);
                }
            }

            // DKIM
            // NOTA il dominio della firma è $dkim_domain se il chiamante lo passa, altrimenti quello del mittente; la chiave si
            // cerca sotto etc/secret/ con lo stesso dominio. Perché la firma valga per DMARC i due domini devono essere allineati
            // ( lo stesso dominio o lo stesso dominio organizzativo ): il task della coda passa sempre il dominio del mittente ( 2026-09-24 )
            $dkimDomain = ( ! empty($dkim_domain) ) ? $dkim_domain : $fromDomain;
            if (! empty($dkimDomain)) {
                if (file_exists(DIR_BASE . 'etc/secret/' . $dkimDomain . '/dkim.private.pem')) {
                    $dkimPassw = (file_exists(DIR_BASE . 'etc/secret/' . $dkimDomain . '/dkim.password.key')) ? readStringFromFile(DIR_BASE . 'etc/secret/' . $dkimDomain . '/dkim.password.key', true) : $dkim_pasw;
                    $mail->DKIM_domain = $dkimDomain;
                    $mail->DKIM_private = DIR_BASE . 'etc/secret/' . $dkimDomain . '/dkim.private.pem';
                    $mail->DKIM_selector = 'glisweb';
                    $mail->DKIM_passphrase = $dkimPassw;
                    $mail->DKIM_identity = $mail->From;
                    logWrite('DKIM: ' . $dkimDomain . ' : passphrase ' . ( empty( $dkimPassw ) ? 'non impostata' : 'impostata' ), 'dkim', LOG_DEBUG);
                    logWrite('DKIM: ' . print_r($from, true) . ' -> ' . $fromName . ' -> ' . $fromDomain . ' -> ' . $dkimDomain . ' non impostato', 'dkim', LOG_DEBUG);
                    logWrite('DKIM: ' . $mail->DKIM_domain . ' ' . $mail->DKIM_selector . ' ' . $mail->DKIM_identity, 'dkim', LOG_DEBUG);
                    logWrite('DKIM: chiave ' . $mail->DKIM_private . ' ' . ( is_readable( $mail->DKIM_private ) ? 'sha256=' . hash_file( 'sha256', $mail->DKIM_private ) : 'NON LEGGIBILE' ), 'dkim', LOG_DEBUG);
                } else {
                    logWrite('DKIM: ' . print_r($from, true) . ' -> ' . $fromName . ' -> ' . $fromDomain . ' -> ' . $dkimDomain . ' non impostato', 'dkim', LOG_NOTICE);
                    logWrite('DKIM: ' . $dkimDomain . ' file etc/secret/' . $dkimDomain . '/dkim.private.pem non trovato', 'dkim', LOG_NOTICE);
                }
            } else {
                logWrite('DKIM: ' . print_r($from, true) . ' -> ' . $fromName . ' -> ' . $fromDomain . ' -> ' . $dkimDomain . ' non impostato', 'dkim', LOG_ERR);
            }

            // invio
            $status = $mail->Send();

            // log
            if ($status == false) {
                logWrite(
                    'errore phpmailer, status: ' . $status . ' ' .
                        $mail->ErrorInfo . ' sending: ' . $oggetto . ' via: ' . $host . ':' . $port .
                        ' to: ' . serialize($to),
                    'mail',
                    LOG_CRIT
                );
            } else {
                logWrite(
                    'messaggio inviato con successo, phpmailer status: ' . $status . ' ' .
                        $mail->ErrorInfo . ' sending: ' . $oggetto . ' from: ' . $fromName . ' ' . $fromMail .
                        ' via: ' . $host . ':' . $port . ' to: ' . serialize($to),
                    'mail'
                );
            }

            // restituzione risultato
            return $status;

        } else {

            logWrite('indirizzo mail mittente non valido: ' . $fromMail, 'mail', LOG_CRIT);
            return false;

        }

    }

    /**
     * FUNZIONI DI ACCODAMENTO
     */

    /**
     * accoda una mail utilizzando un template
     *
     * Questa funzione compone una mail a partire da un template, tipicamente uno di quelli dichiarati in $cf['mail']['tpl']
     * ( _src/_config/_350.mail.php ), e la accoda con queueMail(). Il template è un array con la chiave type, che per ora può
     * valere solo twig, e una chiave per ogni lingua ( es. it-IT ) con le seguenti sotto chiavi:
     *
     * chiave           | dettagli
     * -----------------|-----------------------------------------------------------------------
     * from             | il mittente, 'nome' => 'indirizzo' oppure solo l'indirizzo ( obbligatorio )
     * oggetto          | l'oggetto della mail
     * testo            | il corpo della mail in HTML
     * attach           | i file da allegare ( facoltativo )
     * to               | destinatari da aggiungere a quelli passati ( facoltativo )
     * to_cc            | destinatari in copia da aggiungere a quelli passati ( facoltativo )
     * to_bcc           | destinatari in copia nascosta da aggiungere a quelli passati ( facoltativo )
     *
     * Mittente, oggetto, testo e nomi e indirizzi di tutti i destinatari passano da Twig con i dati $d, per cui possono contenere
     * dei placeholder; per convenzione $d contiene 'ct' => $ct e 'dt' => \<i dati della mail\>. Le chiavi to, to_cc e to_bcc
     * del template vengono considerate solo se il loro primo elemento non è vuoto. In coda vanno solo i destinatari elaborati,
     * mai la forma con i placeholder. Dopo il rendering vengono scartati i destinatari con indirizzo vuoto, e nel corpo i
     * percorsi assoluti degli attributi src vengono trasformati in URL completi con path2url().
     *
     * Se il template non ha il mittente per la lingua richiesta ( anche perché la lingua manca del tutto ), oppure se Twig
     * solleva un'eccezione, la funzione interrompe l'esecuzione con die(). Se il tipo del template non è supportato l'errore
     * viene loggato e, non essendoci destinatari, la funzione restituisce null.
     *
     * @param       object      $c                  la connessione al database
     * @param       array       $t                  il template della mail
     * @param       array       $d                  i dati da passare a Twig, con le chiavi ct e dt
     * @param       int         $timestamp_invio    il timestamp a partire dal quale la mail può essere inviata
     * @param       array       $to                 i destinatari, nel formato 'nome' => 'indirizzo'
     * @param       string      $l                  la lingua del template da usare in formato IETF ( default it-IT )
     * @param       array       $to_cc              i destinatari in copia, nel formato 'nome' => 'indirizzo' ( default nessuno )
     * @param       array       $to_bcc             i destinatari in copia nascosta, nel formato 'nome' => 'indirizzo' ( default nessuno )
     * @param       array       $attach             allegati aggiuntivi per lingua, nel formato 'it-IT' => array( ... ) ( default nessuno )
     * @param       array       $headers            gli header aggiuntivi, nel formato 'nome' => 'valore' ( default nessuno )
     * @param       string      $server             la chiave del server SMTP in $cf['smtp']['servers'] ( default NULL, il server di default )
     *
     * @return      int                             l'ID della mail in mail_out, oppure null se non ci sono destinatari validi
     *
     */
    function queueMailFromTemplate($c, $t, $d, $timestamp_invio, $to, $l = 'it-IT', $to_cc = array(), $to_bcc = array(), $attach = array(), $headers = array(), $server = NULL)
    {

        // NOTA $d deve contenere 'ct' => $ct e 'dt' => <i dati che volete incorporare nella mail>

        // debug
        logWrite('richiesto accodamento di una mail con template', 'mail');

        // valuto il template manager
        switch ($t['type']) {

            case 'twig':
                //print_r( $t );
                //print_r( $d['ct'] );

                // TODO verificare che la struttura di $t sia corretta e contenga tutti i campi necessari (ad es. from) per evitare che Twig vada in banana dopo

                /*
    $loader = new \Twig\Loader\ArrayLoader([
        'index.html' => 'Hello {{ name }}!',
    ]);
    $twig = new \Twig\Environment($loader);

    echo $twig->render('index.html', ['name' => 'Fabien']);
    */

                // die( print_r( $t, true ) );

                if (empty($t[$l]['from'])) {
                    die('mittente non settato, impossibile accodare la mail (template ' . print_r($t, true) . ')');
                }

                try {

                    // retrocompatibilità
                    if (! is_array($t[$l]['from'])) {
                        $t[$l]['from'] = array($t[$l]['from'] => $t[$l]['from']);
                    }


                    // avvio di Twig
                    $twig = new \Twig\Environment(new Twig\Loader\ArrayLoader($t[$l]));
                    $from = new \Twig\Environment(new Twig\Loader\ArrayLoader(array('nome' => array_key_first($t[$l]['from']), 'mail' => reset($t[$l]['from']))));
                    #			$to = new Twig_Environment( new Twig_Loader_Array( array( 'nome' => array_key_first( $t[ $l ]['to'] ), 'mail' => reset( $t[ $l ]['to'] ) ) ) );

                    // die( print_r( $t, true ) );

                    // variabili da passare a queueMail()
                    $mittente    = array($from->render('nome', $d) => $from->render('mail', $d));
                    // die( print_r( $t, true ) );
                    $oggetto    = $twig->render('oggetto', $d);
                    $corpo        = $twig->render('testo', $d);
                    $allegati    = ((isset($t[$l]['attach'])) ? $t[$l]['attach'] : array());
                    $allegati    = array_merge($allegati, ((isset($attach[$l])) ? $attach[$l] : array()));

                    // NOTA i destinatari partono vuoti e si riempiono solo con le versioni elaborate da Twig qui sotto: copiando
                    // $to, $to_cc e $to_bcc in coda finiva anche la forma con i placeholder ( 2026-09-24 )
                    $destinatari = array();
                    $destinatari_cc = array();
                    $destinatari_bcc = array();

                    #print_r($corpo );
                    // se è definito nel template imposto il destinatario
                    if (array_key_exists('to', $t[$l]) && is_array($t[$l]['to']) && ! empty($t[$l]['to'][array_key_first($t[$l]['to'])])) {
                        #print_r( $t[$l] );
                        //$to = array_replace_recursive( $to, $t[ $l ]['to'] );
                        #print_r( $to );
                        // QUESTA ANDAVA ma non inviava a più destinatari
                        // $destinatari[ array_key_first( $t[ $l ]['to'] ) ] = $t[ $l ]['to'][ array_key_first( $t[ $l ]['to'] ) ];
                        $to = array_replace_recursive($to, $t[$l]['to']);
                    }

                    // die( print_r( $t, true ) );

                    // elaboro i placeholder nei destinatari
                    if (isset($to)) {
                        foreach ($to as $k => $v) {
                            $tm = array('nome' => $k, 'mail' => $v);
                            $tw = new \Twig\Environment(new \Twig\Loader\ArrayLoader($tm), array('cache' => false));
                            $destinatari[$tw->render('nome', $d)] = $tw->render('mail', $d);
                        }
                    }

                    // se è definito nel template imposto il destinatario
                    if (array_key_exists('to_cc', $t[$l]) && is_array($t[$l]['to_cc']) && ! empty($t[$l]['to_cc'][array_key_first($t[$l]['to_cc'])])) {
                        #print_r( $t[$l] );
                        //$to = array_replace_recursive( $to, $t[ $l ]['to'] );
                        #print_r( $to );
                        // QUESTA ANDAVA ma non inviava a più destinatari
                        // $destinatari_cc[ array_key_first( $t[ $l ]['to_cc'] ) ] = $t[ $l ]['to_cc'][ array_key_first( $t[ $l ]['to_cc'] ) ];
                        $to_cc = array_replace_recursive($to_cc, $t[$l]['to_cc']);
                    }

                    // die( print_r( $t, true ) );

                    // elaboro i placeholder nei destinatari
                    if (isset($to_cc)) {
                        foreach ($to_cc as $k => $v) {
                            $tm = array('nome' => $k, 'mail' => $v);
                            $tw = new \Twig\Environment(new \Twig\Loader\ArrayLoader($tm), array('cache' => false));
                            $destinatari_cc[$tw->render('nome', $d)] = $tw->render('mail', $d);
                        }
                    }


                    // se è definito nel template imposto il destinatario
                    if (array_key_exists('to_bcc', $t[$l]) && is_array($t[$l]['to_bcc']) && ! empty($t[$l]['to_bcc'][array_key_first($t[$l]['to_bcc'])])) {
                        #print_r( $t[$l] );
                        //$to = array_replace_recursive( $to, $t[ $l ]['to'] );
                        #print_r( $to );
                        // QUESTA ANDAVA ma non inviava a più destinatari
                        // $destinatari_bcc[ array_key_first( $t[ $l ]['to_bcc'] ) ] = $t[ $l ]['to_bcc'][ array_key_first( $t[ $l ]['to_bcc'] ) ];
                        $to_bcc = array_replace_recursive($to_bcc, $t[$l]['to_bcc']);
                    }

                    // die( print_r( $t, true ) );

                    // elaboro i placeholder nei destinatari
                    if (isset($to_bcc)) {
                        foreach ($to_bcc as $k => $v) {
                            $tm = array('nome' => $k, 'mail' => $v);
                            $tw = new \Twig\Environment(new \Twig\Loader\ArrayLoader($tm), array('cache' => false));
                            $destinatari_bcc[$tw->render('nome', $d)] = $tw->render('mail', $d);
                        }
                    }

                    // TODO anche i nomi degli allegati dovrebbero passare da Twig in modo da poter inserire dati
                    // variabili (ad es. una ricevuta generata ad hoc che abbia l'ID della transazione nel nome)
                    // TODO

                } catch (\Exception $e) {
                    echo '<pre>' . print_r($t, true) . '</pre>';
                    die($e->getMessage());
                }


                break;

            default:

                // debug
                logWrite('tipo di template non supportato: ' . $t['type'], 'mail', LOG_ERR);

                break;
        }

        // die( $corpo );

        // rimuovo destinatari con indirizzo vuoto/non valido
        $destinatari = array_filter((array)$destinatari, function($email) { return !empty(trim((string)$email)); });

        if (empty($destinatari)) {
            $bt = array_map(
                function($f) { return ($f['file'] ?? '?') . ':' . ($f['line'] ?? '?') . ' ' . ($f['function'] ?? '?'); },
                debug_backtrace(DEBUG_BACKTRACE_IGNORE_ARGS, 8)
            );
            logWrite(
                'mail scartata: destinatari vuoti dopo elaborazione template.'
                . ' to_originale=' . json_encode($to)
                . ' template_type=' . ($t['type'] ?? '?')
                . ' oggetto=' . ($oggetto ?? '')
                . ' backtrace=' . implode(' | ', $bt),
                'mail', LOG_ERR
            );
            return null;
        }

        // ...
        $corpo = path2url($corpo);

        // accodo la mail
        $id = queueMail(
            $c,
            $timestamp_invio,
            $mittente,
            $destinatari,
            $oggetto,
            $corpo,
            $destinatari_cc,
            $destinatari_bcc,
            $allegati,
            $headers,
            $server
        );

        // debug
        logWrite('mail accodata via template con id #' . $id, 'mail');

        // ritorno
        return $id;
    }

    /**
     * accoda una mail
     *
     * Questa funzione inserisce una mail nella coda di uscita, la tabella mail_out, da cui la preleva il task
     * _src/_api/_task/_mail.queue.send.php per inviarla con sendMail() quando è arrivato il momento. Mittente, destinatari,
     * allegati e header vengono salvati serializzati; il server viene salvato così com'è e il task lo cerca in
     * $cf['smtp']['servers'], usando $cf['smtp']['server'] se è vuoto.
     *
     * Se fra i destinatari non ce n'è nessuno con l'indirizzo non vuoto la mail non viene accodata, l'errore viene loggato con
     * il backtrace del chiamante e la funzione restituisce null; i destinatari CC e BCC non vengono controllati.
     *
     * @param       object      $c                  la connessione al database
     * @param       int         $timestamp_invio    il timestamp a partire dal quale la mail può essere inviata
     * @param       array       $mittente           il mittente, nel formato 'nome' => 'indirizzo'
     * @param       array       $destinatari        i destinatari, nel formato 'nome' => 'indirizzo'
     * @param       string      $oggetto            l'oggetto della mail
     * @param       string      $corpo              il corpo della mail in HTML
     * @param       array       $destinatari_cc     i destinatari in copia, nel formato 'nome' => 'indirizzo' ( default nessuno )
     * @param       array       $destinatari_bcc    i destinatari in copia nascosta, nel formato 'nome' => 'indirizzo' ( default nessuno )
     * @param       array       $allegati           i percorsi dei file da allegare ( default nessuno )
     * @param       array       $headers            gli header aggiuntivi, nel formato 'nome' => 'valore' ( default nessuno )
     * @param       string      $server             la chiave del server SMTP in $cf['smtp']['servers'] ( default NULL, il server di default )
     *
     * @return      int                             l'ID della mail in mail_out, null se non ci sono destinatari validi, false in caso di errore del database
     *
     */
    function queueMail($c, $timestamp_invio, $mittente, $destinatari, $oggetto, $corpo, $destinatari_cc = array(), $destinatari_bcc = array(), $allegati = array(), $headers = array(), $server = NULL)
    {

        // guard: blocco accodamento se nessun destinatario valido
        $destinatari_validi = array_filter((array)$destinatari, function($email) { return !empty(trim((string)$email)); });
        if (empty($destinatari_validi)) {
            $bt = array_map(
                function($f) { return ($f['file'] ?? '?') . ':' . ($f['line'] ?? '?') . ' ' . ($f['function'] ?? '?'); },
                debug_backtrace(DEBUG_BACKTRACE_IGNORE_ARGS, 8)
            );
            logWrite(
                'queueMail bloccata: nessun destinatario valido.'
                . ' destinatari=' . json_encode($destinatari)
                . ' mittente=' . json_encode($mittente)
                . ' oggetto=' . $oggetto
                . ' backtrace=' . implode(' | ', $bt),
                'mail', LOG_ERR
            );
            return null;
        }

        // inserimento della mail in coda
        $id = mysqlQuery(
            $c,
            "INSERT INTO mail_out (
                        timestamp_composizione
                        ,
                        timestamp_invio
                        ,
                        server
                        ,
                        mittente
                        ,
                        destinatari
                        ,
                        destinatari_cc
                        ,
                        destinatari_bcc
                        ,
                        oggetto
                        ,
                        corpo
                        ,
                        allegati
                        ,
                        headers
                    ) VALUES (
                        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?
                    )",
            array(
                array('s' => time()),
                array('s' => $timestamp_invio),
                array('s' => $server),
                array('s' => serialize($mittente)),
                array('s' => serialize($destinatari)),
                array('s' => serialize($destinatari_cc)),
                array('s' => serialize($destinatari_bcc)),
                array('s' => $oggetto),
                array('s' => $corpo),
                array('s' => serialize($allegati)),
                array('s' => serialize($headers))
            )
        );

        // unlock delle tabelle
        // mysqlQuery( $c, 'UNLOCK TABLES' );

        // valore di ritorno
        return $id;
    }

    /**
     * FUNZIONI DI CONVERSIONE
     */

    /**
     * converte una stringa di indirizzi in un array
     *
     * Questa funzione converte una stringa di indirizzi separati da virgola o punto e virgola, come quelle che si scrivono nei
     * campi dei form, in un array nel formato 'nome' => 'indirizzo' usato da queueMail() e sendMail(). Un elemento che è un
     * indirizzo valido diventa 'indirizzo' => 'indirizzo'; un elemento nella forma Nome Cognome \<indirizzo\> diventa
     * 'Nome Cognome' => 'indirizzo'. Gli elementi vengono ripuliti dagli spazi prima del controllo, per cui "a@b.it, c@d.it"
     * dà due indirizzi. Gli elementi che non corrispondono a nessuna delle due forme, compresi quelli in cui dopo il nome non
     * c'è un indirizzo valido ( "Mario Rossi" ), vengono scartati; una stringa vuota o NULL restituisce un array vuoto. È
     * l'inversa di array2mailString().
     *
     * @param       string      $t      la stringa degli indirizzi
     *
     * @return      array               gli indirizzi nel formato 'nome' => 'indirizzo'
     *
     */
    function mailString2array($t)
    {

        $ar0 = array();

        $t = str_replace(',', ';', $t ?? '');
        $ar1 = explode(';', $t ?? '');

        foreach ($ar1 as $ds) {

            $ds = trim($ds);

            if (filter_var($ds, FILTER_VALIDATE_EMAIL)) {

                $ar0[$ds] = $ds;
            } else {

                $dsa = array();

                $r = preg_match('/([\S\s]+)\s([<]{0,1}[\S\@\.]+[>]{0,1})/', $ds, $dsa);

                if (! empty($r) && filter_var(trim($dsa[2], '<>'), FILTER_VALIDATE_EMAIL)) {
                    $ar0[trim($dsa[1])] = trim($dsa[2], '<>');
                }
            }
        }

        return $ar0;
    }

    /**
     * converte un array di indirizzi in una stringa
     *
     * Questa funzione converte un array nel formato 'nome' => 'indirizzo' in una stringa nella forma
     * "nome <indirizzo>, nome <indirizzo>", adatta a essere mostrata o modificata in un campo di testo; i moduli della posta
     * la usano sulle colonne serializzate di mail_out e mail_sent. Se $a non è un array viene restituito così com'è ( convertito
     * in stringa ), quindi un valore NULL diventa una stringa vuota. È l'inversa di mailString2array().
     *
     * @param       array       $a      l'array degli indirizzi nel formato 'nome' => 'indirizzo'
     *
     * @return      string              la stringa degli indirizzi
     *
     */
    function array2mailString($a)
    {

        $ar = array();

        if (is_array($a)) {
            foreach ($a as $k => $m) {

                $ar[] = $k . ' <' . $m . '>';
            }
        } else {
            $ar[] = $a;
        }

        return implode(', ', $ar);

    }
