<?php

    /**
     * libreria per l'integrazione con il servizio di fatturazione elettronica Archivium
     *
     * Questa libreria contiene le funzioni che dialogano con le API REST di Archivium, l'intermediario usato dal
     * framework per l'invio delle fatture elettroniche attive allo SDI e per lo scarico delle fatture passive e
     * delle notifiche, e quelle che registrano nel database i dati scaricati.
     *
     * introduzione
     * ============
     * Tutte le chiamate usano il profilo Archivium attivo per lo stato corrente del sito, $cf['archivium']['profile'],
     * dichiarato in _src/_config/_560.archivium.php e collegato al profilo corrente in _src/_config/_565.archivium.php;
     * del profilo vengono usate le chiavi:
     *
     * chiave           | dettagli
     * -----------------|-----------------------------------------------------------------------
     * url              | l'URL base delle API Archivium, a cui viene accodato l'endpoint
     * id               | l'identificativo dell'account Archivium
     * apikey           | la chiave API dell'account
     *
     * L'autenticazione non passa per header ma è incorporata nel percorso dell'endpoint, nella forma
     * <url>Admin/<id>/<apikey>/... per le funzioni di amministrazione delle aziende e <url>ISC/<id>/<apikey>/... per
     * quelle di fatturazione. Le chiamate sono eseguite con restCall() e la risposta JSON viene restituita decodificata
     * in array associativo; nessuna funzione verifica che il profilo esista, per cui senza configurazione le chiamate
     * partono verso un URL incompleto e falliscono.
     *
     * Sulle aziende va tenuta presente la distinzione fra i due identificativi: l'ID Archivium dell'azienda (il codice
     * assegnato da Archivium, salvato in anagrafica.codice_archivium) e l'ID dell'anagrafica nel database del framework.
     * Allo stesso modo documenti.codice_archivium conserva l'ID Archivium delle fatture e attivita.codice_archivium
     * quello delle notifiche. I parametri di ciascuna funzione dicono quale dei due si aspetta.
     *
     * Le funzioni sono chiamate dai task e dai job del framework e del modulo 0400.documenti, ad esempio
     * _src/_api/_task/_anagrafica.attivazione.archivium.php, _mod/_0400.documenti/_src/_api/_task/_fattura.invia.sdi.php,
     * _mod/_0400.documenti/_src/_api/_job/_download.fe.passive.php e _mod/_0400.documenti/_src/_api/_job/_download.note.attive.php.
     *
     * i parametri di ricerca delle liste
     * ----------------------------------
     * Gli endpoint list di Archivium accettano quattro parametri di ricerca posizionali, accodati al percorso
     * separati da slash nell'ordine limit/orderby/wildcard/params; il loro significato è descritto nella NOTA che
     * segue archiviumGetListaAziende(). Le funzioni di lista li ricevono come argomenti $limit, $order, $wildcard e
     * $params e li accodano all'endpoint nello stesso modo.
     *
     * costanti
     * ========
     * Questa libreria non definisce costanti.
     *
     * funzioni
     * ========
     * Le funzioni di questa libreria sono divise in gruppi in base al lavoro che svolgono; nei paragrafi successivi le
     * analizzeremo nel dettaglio.
     *
     * funzioni per la gestione delle aziende
     * --------------------------------------
     * Le funzioni in questo gruppo servono per gestire le aziende registrate sull'account Archivium.
     *
     * funzione                             | descrizione
     * -------------------------------------|---------------------------------------------------------------
     * archiviumGetListaAziende()           | restituisce l'elenco delle aziende registrate su Archivium
     * archiviumGetDettagliAzienda()        | restituisce i dettagli di un'azienda registrata su Archivium
     * archiviumPostInsertAzienda()         | registra su Archivium un'anagrafica del database come nuova azienda
     * archiviumPostAggiornamentoAzienda()  | aggiorna su Archivium i dati di un'azienda (non implementata)
     *
     * funzioni per le fatture elettroniche attive
     * -------------------------------------------
     * Le funzioni in questo gruppo servono per inviare le fatture emesse e consultarne lo stato.
     *
     * funzione                             | descrizione
     * -------------------------------------|---------------------------------------------------------------
     * archiviumGetListaFeAttive()          | restituisce l'elenco delle fatture attive di un'azienda
     * archiviumGetInfoFeAttiva()           | recupera le informazioni su una fattura attiva (non implementata)
     * archiviumPostInvioFeAttiva()         | invia una fattura elettronica attiva ad Archivium
     *
     * funzioni per le fatture elettroniche passive
     * --------------------------------------------
     * Le funzioni in questo gruppo servono per scaricare le fatture ricevute e registrarle nel database.
     *
     * funzione                             | descrizione
     * -------------------------------------|---------------------------------------------------------------
     * archiviumGetListaFePassive()         | restituisce l'elenco delle fatture passive di un'azienda
     * archiviumGetInfoFePassiva()          | restituisce le informazioni su una fattura passiva
     * archiviumGetDownloadFePassiva()      | scarica il contenuto di una fattura passiva
     * archiviumRegistraFePassive()         | registra nel database le fatture passive di un mese
     * archiviumRegistraFePassiva()         | registra nel database una fattura passiva
     *
     * funzioni per le notifiche SDI
     * -----------------------------
     * Le funzioni in questo gruppo servono per scaricare le notifiche dello SDI relative alle fatture attive (che
     * Archivium chiama note attive) e registrarle come attività sui documenti.
     *
     * funzione                             | descrizione
     * -------------------------------------|---------------------------------------------------------------
     * archiviumGetListaNoteAttive()        | restituisce l'elenco delle notifiche SDI delle fatture attive di un'azienda
     * archiviumRegistraNoteAttive()        | registra nel database le notifiche SDI di un mese
     * archiviumRegistraNotaAttiva()        | registra nel database una notifica SDI come attività
     * archiviumGetInfoNotaAttiva()         | restituisce le informazioni su una notifica SDI
     *
     * dipendenze
     * ==========
     * Questa libreria ha alcune dipendenze che devono essere soddisfatte per funzionare correttamente. In particolare
     * sono richieste le seguenti funzioni:
     *
     * funzione                             | libreria di appartenenza
     * -------------------------------------|---------------------------------------------------------------
     * restCall()                           | _src/_lib/_rest.tools.php
     * mysqlQuery()                         | _src/_lib/_mysql.tools.php
     * mysqlSelectRow()                     | _src/_lib/_mysql.tools.php
     * mysqlSelectValue()                   | _src/_lib/_mysql.tools.php
     * mysqlSelectColumn()                  | _src/_lib/_mysql.tools.php
     * mysqlInsertRow()                     | _src/_lib/_mysql.tools.php
     * is_associative_array()               | _src/_lib/_array.tools.php
     * dieText()                            | _src/_lib/_output.tools.php
     * logWrite()                           | _src/_lib/_log.utils.php
     * updateAnagraficaViewStatic()         | modulo anagrafica (_mod/_0010.anagrafica o _mod/_AN000.anagrafica)
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
     * @file
     *
     */

    /**
     * FUNZIONI PER LA GESTIONE DELLE AZIENDE
     */

    /**
     * restituisce l'elenco delle aziende registrate su Archivium
     *
     * Questa funzione chiama l'endpoint Admin/.../Enterprises/list, accodando i parametri di ricerca non vuoti uniti
     * da slash come fa archiviumGetListaFePassive() ( si veda il suo docblock per i casi limite ), e restituisce la
     * risposta decodificata, cioè l'elenco delle aziende registrate sull'account Archivium del profilo corrente. Se
     * tutti i parametri sono vuoti l'endpoint viene chiamato senza filtri. In caso di errore della chiamata
     * restituisce quello che restCall() ottiene decodificando la risposta, tipicamente NULL.
     *
     * @param       int         $limit      il numero massimo di record
     * @param       string      $order      il criterio di ordinamento, ad es. Data=DESC
     * @param       string      $wildcard   il tipo di ricerca, LEFT, RIGHT, BOTH o NONE
     * @param       string      $params     il criterio di ricerca colonna=valore
     *
     * @return      mixed                   l'array delle aziende restituito da Archivium, o NULL in caso di errore
     *
     */
    function archiviumGetListaAziende( $limit = NULL, $order = NULL, $wildcard = NULL, $params = NULL ) {

        // inizializzazione variabili
        $s      = NULL;

        // globalizzazione di $cf
        global $cf;

        // autenticazione per la chiamata
        $a      = $cf['archivium']['profile']['id'] . '/' . $cf['archivium']['profile']['apikey'];

        // parametri di ricerca
        $p      = trim( implode( '/', array( $limit, $order, $wildcard, $params ) ), '/' );

        // endpoint per la chiamata
        $e      = 'Admin/' . $a . '/Enterprises/list' . ( ( ! empty( $p ) ) ? '/' . $p : NULL );

        // URL per la chiamata
        $u      = $cf['archivium']['profile']['url'] . $e;

        // eseguo la chiamata
        $l      = restCall( $u, METHOD_GET, NULL, MIME_APPLICATION_JSON, MIME_APPLICATION_JSON, $s );

        // debug
        // var_dump( $u );
        // var_dump( $s );
        // print_r( $l );

        // restituisco il risultato
        return $l;

    }

    /**
     * NOTA i parametri opzionali per la chiamata a /Enterprises/list sono:
     * 
     * {limit}: definisce il numero massimo di record da far visualizzare, può andare da 1 a 10000 oltre questo valore la chiamata è considerata incorretta (404);
     * 
     * {orderby}: definisce il criterio di ordinamento deve essere inserito il nome di un metadato (si veda servizio metadati) seguito da = ed uno dei valori
     * tra ASC (per ordine ascendente) o DESC (per ordine discendente) ES. Data=DESC errori di formattazione portano a 404;
     * 
     * {wildcard}: parametro complementare del successivo {params} definisce il tipo di ricerca che si effettuerà sui valori di param e può assumere i seguenti valori:
     *   LEFT: significa ricerca per colonna che termina con valore immesso
     *   RIGHT: significa ricerca per colonna che incomincia con valore immesso
     *   BOTH: significa ricerca per colonna che contiene il valore immesso
     *   NONE: significa ricerca per colonna che contiene esattamente valore immesso
     * La wildcard scelta si applica a tutti i params
     * 
     * {params}: è un campo che può essere ripetuto n volte ogni volta si ripete '/colonna=valore/'* ogni istanza
     * definisce un criterio addizionale alla ricerca rendendola sempre più particolareggiata.
     * 
     */

    /**
     * restituisce i dettagli di un'azienda registrata su Archivium
     *
     * Questa funzione chiama l'endpoint Admin/.../Enterprises/view/<idAzienda> e restituisce la risposta
     * decodificata con i dati dell'azienda. Il valore di $idAzienda non viene verificato: se è vuoto la chiamata
     * parte comunque verso un endpoint incompleto. In caso di errore restituisce quello che restCall() ottiene
     * decodificando la risposta, tipicamente NULL.
     *
     * NOTA qui il parametro $idAzienda fa riferimento all'ID Archivium dell'azienda
     *
     * @param       string      $idAzienda  l'ID Archivium dell'azienda (non l'ID dell'anagrafica nel database)
     *
     * @return      mixed                   l'array con i dettagli dell'azienda, o NULL in caso di errore
     *
     */
    function archiviumGetDettagliAzienda( $idAzienda ) {

        // inizializzazione variabili
        $s      = NULL;

        // globalizzazione di $cf
        global $cf;

        // autenticazione per la chiamata
        $a      = $cf['archivium']['profile']['id'] . '/' . $cf['archivium']['profile']['apikey'];

        // endpoint per la chiamata
        $e      = 'Admin/' . $a . '/Enterprises/view/' . $idAzienda;

        // URL per la chiamata
        $u      = $cf['archivium']['profile']['url'] . $e;

        // eseguo la chiamata
        $l      = restCall( $u, METHOD_GET, NULL, MIME_APPLICATION_JSON, MIME_APPLICATION_JSON, $s );

        // debug
        // var_dump( $u );
        // var_dump( $s );
        // print_r( $l );

        // restituisco il risultato
        return $l;

    }

    /**
     * registra su Archivium un'anagrafica del database come nuova azienda
     *
     * Questa funzione legge dal database l'anagrafica indicata, la sua tipologia, l'indirizzo con ruolo di sede
     * legale (il primo trovato), il comune con provincia e stato, la mail PEC e la prima mail non PEC, compone con
     * questi dati il modulo richiesto da Archivium (i campi sono descritti nella NOTA che segue la funzione) e lo
     * invia in POST all'endpoint Admin/.../Enterprises/insert. Il tipo giuridico è F se la tipologia
     * dell'anagrafica è una persona fisica e G altrimenti: il valore E (ente pubblico) non viene mai inviato. Se
     * l'anagrafica non ha sede legale, PEC o mail i campi corrispondenti vengono inviati vuoti.
     *
     * Se Archivium risponde con esito 200, l'IDAzienda restituito viene salvato in anagrafica.codice_archivium;
     * altrimenti il database non viene toccato e la risposta non viene loggata.
     *
     * NOTA il parametro $id qui fa riferimento all'ID dell'azienda nel database
     *
     * @param       int         $id         l'ID dell'anagrafica nel database (non l'ID Archivium)
     *
     * @return      mixed                   l'esito restituito da Archivium (200 in caso di successo), o NULL se la
     *                                      risposta non è decodificabile
     *
     */
    function archiviumPostInsertAzienda( $id ) {

        // inizializzazione variabili
        $s      = NULL;

        // globalizzazione di $cf
        global $cf;

        // autenticazione per la chiamata
        $a      = $cf['archivium']['profile']['id'] . '/' . $cf['archivium']['profile']['apikey'];

        // endpoint per la chiamata
        $e      = 'Admin/' . $a . '/Enterprises/insert';

        // URL per la chiamata
        $u      = $cf['archivium']['profile']['url'] . $e;

        // prelevo i dati dall'anagrafica
        $da     = mysqlSelectRow( $cf['mysql']['connection'], 'SELECT * FROM anagrafica WHERE id = ?', array( array( 's' => $id ) ) );
        $dy     = mysqlSelectRow( $cf['mysql']['connection'], 'SELECT * FROM tipologie_anagrafica WHERE id = ?', array( array( 's' => $da['id_tipologia'] ) ) );
        $di     = mysqlSelectRow( $cf['mysql']['connection'], 'SELECT indirizzi.*, tipologie_indirizzi.nome AS tipologia FROM indirizzi INNER JOIN anagrafica_indirizzi ON anagrafica_indirizzi.id_indirizzo = indirizzi.id INNER JOIN ruoli_indirizzi ON ruoli_indirizzi.id = anagrafica_indirizzi.id_ruolo INNER JOIN tipologie_indirizzi ON tipologie_indirizzi.id = indirizzi.id_tipologia WHERE anagrafica_indirizzi.id_anagrafica = ? AND ruoli_indirizzi.se_sede_legale = 1 LIMIT 1', array( array( 's' => $id ) ) );
        $dc     = mysqlSelectRow( $cf['mysql']['connection'], 'SELECT comuni.nome, provincie.sigla, provincie.id_regione FROM comuni INNER JOIN provincie ON provincie.id = comuni.id_provincia WHERE comuni.id = ?', array( array( 's' => $di['id_comune'] ) ) );
        $ds     = mysqlSelectRow( $cf['mysql']['connection'], 'SELECT stati.iso31661alpha2 FROM regioni INNER JOIN stati ON stati.id = regioni.id_stato WHERE regioni.id = ?', array( array( 's' => $dc['id_regione'] ) ) );
        $dp     = mysqlSelectRow( $cf['mysql']['connection'], 'SELECT mail.indirizzo FROM mail WHERE mail.id_anagrafica = ? AND mail.se_pec = 1', array( array( 's' => $id ) ) );
        $dm     = mysqlSelectRow( $cf['mysql']['connection'], 'SELECT mail.indirizzo FROM mail WHERE mail.id_anagrafica = ? AND mail.se_pec IS NULL', array( array( 's' => $id ) ) );

        // dati da inviare
        $d['TipoGiuridico']     = ( ! empty( $dy['se_persona_fisica'] ) ) ? 'F' : 'G';
        $d['CodiceFiscale']     = $da['codice_fiscale'];
        $d['PartitaIva']        = $da['partita_iva'];
        if( $d['TipoGiuridico'] == 'G' ) {
            $d['RagioneSociale']    = $da['denominazione'];
        } else {
            $d['Cognome']           = $da['cognome'];
            $d['Nome']              = $da['nome'];
        }
        $d['Indirizzo']         = $di['tipologia'] . ' ' . $di['indirizzo'];
        $d['NumeroCivico']      = $di['civico'];
        $d['ZipCode']           = $di['cap'];
        $d['Localita']          = $dc['nome'];
        $d['Provincia']         = $dc['sigla'];
        $d['Stato']             = $ds['iso31661alpha2'];
        $d['Pec']               = $dp['indirizzo'];
        $d['Mail']              = $dm['indirizzo'];
        $d['ExtID']             = $da['id'];
        $d['IDISC']             = 3;

        // debug
        // print_r( $d );

        // eseguo la chiamata
        $r      = restCall( $u, METHOD_POST, $d, MIME_MULTIPART_FORM_DATA, MIME_APPLICATION_JSON, $s );

        // debug
        // var_dump( $u );
        // var_dump( $s );
        // print_r( $r );

        // TODO loggare $r

        // salvo l'ID SDI dell'anagrafica
        if( $r['esito'] == 200 ) {

            mysqlQuery(
                $cf['mysql']['connection'],
                'UPDATE anagrafica SET codice_archivium = ? WHERE id = ?',
                array(
                    array( 's' => $r['IDAzienda'] ),
                    array( 's' => $da['id'] )
                )
            );

        }

        // TODO restituire il risultato
        return $r['esito'];

    }

    /**
     * NOTA sui campi da inviare per l'inserimento di una nuova azienda
     * 
     * "TipoGiuridico": [Tipo giuridico dell'azienda, può assumere i valori:G (persona giuridica), F (Persona Fisica), E (Ente pubblico)],
     * "CodiceFiscale": [codice fiscale],
     * "PartitaIva": [partita IVA],
     * "RagioneSociale": [Ragione sociale, da compilare solo se il Tipo giuridico è G o E],
     * "Cognome": [Cognome, da compilare solo se il Tipo giuridico è F],
     * "Nome": [Nome, da compilare solo se il Tipo giuridico è F],
     * "Indirizzo": [indirizzo sede azienda],
     * "NumeroCivico": [numero civico],
     * "ZipCode": [CAP],
     * "Localita": [Città ],
     * "Provincia": [Provincia in sigla di 2 lettere maiuscole],
     * "Stato": [Nazione in sigla di due lettere maiuscole],
     * "Pec": [pec azienda],
     * "Mail": [mail azienda],
     * "ExtID": [identificativo esterno dell'azienda, elemento facoltativo],
     * "IDISC": [identificativo del servizio di fatturazione elettronica, da valorizzare obbligatoriamente con il numero 3]
     * 
     * NOTA in caso di inserimento effettuato con successo il webservice restituisce un Json del tipo
     * Array ( [esito] => 200 [message] => Azienda creata correttamente [IDAzienda] => XXXXX )
     * 
     */

    /**
     * aggiorna su Archivium i dati di un'azienda (non implementata)
     *
     * Questa funzione è predisposta per inviare ad Archivium i dati aggiornati di un'azienda già registrata, ma il
     * suo corpo è vuoto: non fa nessuna chiamata e restituisce sempre NULL.
     *
     * NOTA il parametro $id qui fa riferimento all'ID dell'azienda nel database
     * mentre $idAzienda fa riferimento all'ID Archivium dell'azienda
     *
     * @todo implementare la funzione
     *
     * @param       int         $id         l'ID dell'anagrafica nel database
     * @param       string      $idAzienda  l'ID Archivium dell'azienda
     *
     * @return      void
     *
     */
    function archiviumPostAggiornamentoAzienda( $id, $idAzienda ) {
    }

    /**
     * FUNZIONI PER LE FATTURE ELETTRONICHE ATTIVE
     */

    /**
     * restituisce l'elenco delle fatture attive di un'azienda
     *
     * Questa funzione chiama l'endpoint ISC/.../FEAttive/<idAzienda>/list, accodando i parametri di ricerca non vuoti
     * uniti da slash come fa archiviumGetListaFePassive(), e restituisce l'elenco delle fatture attive dell'azienda,
     * aggiungendo a ciascun elemento la chiave IDArchiviumAzienda con l'ID Archivium dell'azienda, così che
     * l'elemento resti identificabile anche fuori dal contesto della chiamata. Se la chiamata
     * fallisce e la risposta non è un array il ciclo di arricchimento genera un warning e la funzione restituisce
     * il valore ricevuto, tipicamente NULL.
     *
     * @param       string      $idAzienda  l'ID Archivium dell'azienda
     * @param       int         $limit      il numero massimo di record
     * @param       string      $order      il criterio di ordinamento, ad es. ID=ASC
     * @param       string      $wildcard   il tipo di ricerca, LEFT, RIGHT, BOTH o NONE
     * @param       string      $params     il criterio di ricerca colonna=valore
     *
     * @return      mixed                   l'array delle fatture attive, o NULL in caso di errore
     *
     */
    function archiviumGetListaFeAttive( $idAzienda, $limit = NULL, $order = NULL, $wildcard = NULL, $params = NULL  ) {

        // inizializzazione variabili
        $s      = NULL;

        // globalizzazione di $cf
        global $cf;

        // autenticazione per la chiamata
        $a      = $cf['archivium']['profile']['id'] . '/' . $cf['archivium']['profile']['apikey'];

        // parametri di ricerca
        $p      = trim( implode( '/', array( $limit, $order, $wildcard, $params ) ), '/' );

        // endpoint per la chiamata
        $e      = 'ISC/' . $a . '/FEAttive/' . $idAzienda . '/list' . ( ( ! empty( $p ) ) ? '/' . $p : NULL );

        // URL per la chiamata
        $u      = $cf['archivium']['profile']['url'] . $e;

        // effettuo la chiamata
        $l      = restCall( $u, METHOD_GET, NULL, MIME_APPLICATION_JSON, MIME_APPLICATION_JSON, $s );

        // aggiungo l'azienda a ogni elemento dell'array
        foreach( $l as &$e ) {
            $e['IDArchiviumAzienda'] = $idAzienda;
        }

        // debug
        // var_dump( $u );
        // var_dump( $s );
        // print_r( $l );

        // restituisco il risultato
        return $l;

    }

    /**
     * recupera le informazioni su una fattura attiva (non implementata)
     *
     * Questa funzione è predisposta per chiamare l'endpoint ISC/.../FEAttive/<idAzienda>/info/<idFattura>/<index>,
     * ma si ferma alla composizione dell'URL: la chiamata non viene fatta e la funzione restituisce sempre NULL (si
     * vedano i TODO nel corpo). Per la versione funzionante sulle fatture passive si veda archiviumGetInfoFePassiva().
     *
     * @param       string      $idAzienda  l'ID Archivium dell'azienda
     * @param       string      $idFattura  l'identificativo della fattura, del tipo indicato da $index
     * @param       string      $index      il tipo di identificativo passato in $idFattura (default IDArchivium)
     *
     * @return      void
     *
     */
    function archiviumGetInfoFeAttiva( $idAzienda, $idFattura, $index = 'IDArchivium'  ) {

        // inizializzazione variabili
        $s      = NULL;

        // globalizzazione di $cf
        global $cf;

        // autenticazione per la chiamata
        $a      = $cf['archivium']['profile']['id'] . '/' . $cf['archivium']['profile']['apikey'];

        // endpoint per la chiamata
        $e      = 'ISC/' . $a . '/FEAttive/' . $idAzienda . '/info/' . $idFattura . '/' . $index;

        // URL per la chiamata
        $u      = $cf['archivium']['profile']['url'] . $e;

        // TODO fare la chiamata

        // TODO restituire il risultato

    }

    /**
     * invia una fattura elettronica attiva ad Archivium
     *
     * Questa funzione invia in POST all'endpoint ISC/.../FEAttive/<idAzienda>/Send/<tipo> il file XML della fattura,
     * accompagnato dal suo hash SHA-256 (campo File_Hash). Se $idAzienda è vuoto la funzione interrompe l'esecuzione
     * con dieText(). Se Archivium risponde con esito 200, l'IDArchivium assegnato alla fattura viene salvato in
     * documenti.codice_archivium per il documento $idFattura; in ogni altro caso la risposta viene scritta nel log
     * archivium con livello LOG_ERR e la funzione restituisce false. La forma della risposta di successo è riportata
     * nella NOTA dentro la funzione.
     *
     * @param       string      $idAzienda  l'ID Archivium dell'azienda che emette la fattura
     * @param       int         $idFattura  l'ID del documento nel database, dove salvare il codice Archivium
     * @param       string      $xmlFattura il percorso del file XML della fattura da inviare
     * @param       string      $tipo       il tipo di invio accodato all'endpoint (default XML)
     * @param       string      $mail       non utilizzato
     *
     * @return      mixed                   200 se l'invio è andato a buon fine, false altrimenti
     *
     */
    function archiviumPostInvioFeAttiva( $idAzienda, $idFattura, $xmlFattura, $tipo = 'XML', $mail = NULL  ) {

        // inizializzazione variabili
        $s      = NULL;

        // verifiche formali
        if( empty( $idAzienda ) ) { dieText( 'identificativo azienda vuoto' ); }

        // globalizzazione di $cf
        global $cf;

        // autenticazione per la chiamata
        $a      = $cf['archivium']['profile']['id'] . '/' . $cf['archivium']['profile']['apikey'];

        // endpoint per la chiamata
        $e      = 'ISC/' . $a . '/FEAttive/' . $idAzienda . '/Send/' . $tipo;

        // URL per la chiamata
        $u      = $cf['archivium']['profile']['url'] . $e;

        // dati
        $d['File_Hash'] = hash_file( 'sha256', $xmlFattura );
        $d['file'] = curl_file_create( $xmlFattura, 'application/xml' );

        // eseguo la chiamata
        $r      = restCall( $u, METHOD_POST, $d, MIME_MULTIPART_FORM_DATA, MIME_APPLICATION_JSON, $s );

        // debug
        // print_r( $d );
        // var_dump( $u );
        // var_dump( $s );
        // print_r( $r );

        // TODO salvo l'ID
        if( isset( $r['esito'] ) && $r['esito'] == 200 ) {
            mysqlQuery(
                $cf['mysql']['connection'],
                'UPDATE documenti SET codice_archivium = ? '.
                'WHERE id = ?',
                array(
                    array( 's' => $r['IDArchivium'] ),
                    array( 's' => $idFattura )
                )
            );
        } else {
            logWrite( print_r( $r, true ), 'archivium', LOG_ERR );
            $r['esito'] = false;
        }

        /**
         * NOTA
         * Array ( [esito] => 200 [message] => FE attiva presa in carico correttamente [ID] => 1 [IDArchivium] => 7OF8J-61cddbffd8dea [NomeFileSDI] => IT09468600011_CJWFX.xml.p7m [NomeFileCaricato] => IT1234568790_1.xml )
         */

        // TODO restituire il risultato
        return $r['esito'];

    }

    /**
     * FUNZIONI PER LE FATTURE ELETTRONICHE PASSIVE
     */

    /**
     * restituisce l'elenco delle fatture passive di un'azienda
     *
     * Questa funzione chiama l'endpoint ISC/.../FEPassive/<idAzienda>/list, accodando i parametri di ricerca non
     * vuoti uniti da slash, e restituisce l'elenco delle fatture passive dell'azienda aggiungendo a ciascun elemento
     * la chiave IDArchiviumAzienda con l'ID Archivium dell'azienda. Se tutti i parametri sono vuoti l'endpoint viene
     * chiamato senza filtri. I chiamanti usano la forma archiviumGetListaFePassive( $azienda, 0, 'ID=ASC', 'RIGHT',
     * 'DataFattura=' . $anno ), cioè le fatture con data che comincia per l'anno (o per il mese Y-m) indicato.
     *
     * NB: i parametri sono posizionali ma i valori vuoti vengono tolti solo in testa e in coda (trim degli slash),
     * per cui omettere un parametro intermedio produce un doppio slash; il valore 0 di $limit invece viene
     * accodato. Se la chiamata fallisce e la risposta non è un array il ciclo di arricchimento genera un warning e
     * la funzione restituisce il valore ricevuto, tipicamente NULL.
     *
     * @param       string      $idAzienda  l'ID Archivium dell'azienda
     * @param       int         $limit      il numero massimo di record
     * @param       string      $order      il criterio di ordinamento, ad es. ID=ASC
     * @param       string      $wildcard   il tipo di ricerca, LEFT, RIGHT, BOTH o NONE
     * @param       string      $params     il criterio di ricerca colonna=valore
     *
     * @return      mixed                   l'array delle fatture passive, o NULL in caso di errore
     *
     */
    function archiviumGetListaFePassive( $idAzienda, $limit = NULL, $order = NULL, $wildcard = NULL, $params = NULL  ) {

        // inizializzazione variabili
        $s      = NULL;

        // globalizzazione di $cf
        global $cf;

        // autenticazione per la chiamata
        $a      = $cf['archivium']['profile']['id'] . '/' . $cf['archivium']['profile']['apikey'];

        // parametri di ricerca
        $p      = trim( implode( '/', array( $limit, $order, $wildcard, $params ) ), '/' );

        // endpoint per la chiamata
        $e      = 'ISC/' . $a . '/FEPassive/' . $idAzienda . '/list' . ( ( ! empty( $p ) ) ? '/' . $p : NULL );

        // URL per la chiamata
        $u      = $cf['archivium']['profile']['url'] . $e;

        // effettuo la chiamata
        $l      = restCall( $u, METHOD_GET, NULL, MIME_APPLICATION_JSON, MIME_APPLICATION_JSON, $s );

        // aggiungo l'azienda a ogni elemento dell'array
        foreach( $l as &$e ) {
            $e['IDArchiviumAzienda'] = $idAzienda;
        }

        // debug
        // var_dump( $u );
        // var_dump( $s );
        // print_r( $l );

        // restituisco il risultato
        return $l;

    }

    /**
     * restituisce le informazioni su una fattura passiva
     *
     * Questa funzione chiama l'endpoint ISC/.../FEPassive/<idAzienda>/info/<idFattura>/<index> e restituisce la
     * risposta decodificata con i metadati della fattura (fra cui l'IDArchivium). In caso di errore restituisce
     * quello che restCall() ottiene decodificando la risposta, tipicamente NULL.
     *
     * @param       string      $idAzienda  l'ID Archivium dell'azienda destinataria
     * @param       string      $idFattura  l'identificativo della fattura, del tipo indicato da $index
     * @param       string      $index      il tipo di identificativo passato in $idFattura (default IDArchivium)
     *
     * @return      mixed                   l'array con le informazioni sulla fattura, o NULL in caso di errore
     *
     */
    function archiviumGetInfoFePassiva( $idAzienda, $idFattura, $index = 'IDArchivium'  ) {

        // inizializzazione variabili
        $s      = NULL;

        // globalizzazione di $cf
        global $cf;

        // autenticazione per la chiamata
        $a      = $cf['archivium']['profile']['id'] . '/' . $cf['archivium']['profile']['apikey'];

        // endpoint per la chiamata
        $e      = 'ISC/' . $a . '/FEPassive/' . $idAzienda . '/info/' . $idFattura . '/' . $index;

        // URL per la chiamata
        $u      = $cf['archivium']['profile']['url'] . $e;

        // effettuo la chiamata
        $r      = restCall( $u, METHOD_GET, NULL, MIME_APPLICATION_JSON, MIME_APPLICATION_JSON, $s );

        // debug
        // var_dump( $u );
        // var_dump( $s );
        // print_r( $r );

        // restituisco il risultato
        return $r;

    }

    /**
     * scarica il contenuto di una fattura passiva
     *
     * Questa funzione chiama l'endpoint ISC/.../FEPassive/<idAzienda>/Download/<idFattura>/<index>/<type>, che
     * restituisce l'XML della fattura; la risposta viene convertita in array da restCall() tramite xml2array() e
     * conservata anche grezza. Il ciclo di pulizia serve a ricondurre la radice del documento, che nell'XML può avere
     * un prefisso di namespace (ad es. p:FatturaElettronica), alla chiave FatturaElettronica: viene presa la chiave il
     * cui nome contiene FatturaElettronica. Se la risposta è vuota, non è un array o non ha una chiave del genere, la
     * chiave FatturaElettronica del risultato vale NULL.
     *
     * @param       string      $idAzienda  l'ID Archivium dell'azienda destinataria
     * @param       string      $idFattura  l'identificativo della fattura, del tipo indicato da $index
     * @param       string      $index      il tipo di identificativo passato in $idFattura (default IDArchivium)
     * @param       string      $type       il formato da scaricare (default XML)
     *
     * @return      array                   un array con la chiave FatturaElettronica (la fattura convertita in array)
     *                                      e la chiave xml (l'XML grezzo ricevuto)
     *
     */
    function archiviumGetDownloadFePassiva( $idAzienda, $idFattura, $index = 'IDArchivium', $type = 'XML'  ) {

        // inizializzazione variabili
        $s      = NULL;

        // globalizzazione di $cf
        global $cf;

        // autenticazione per la chiamata
        $a      = $cf['archivium']['profile']['id'] . '/' . $cf['archivium']['profile']['apikey'];

        // endpoint per la chiamata
        $e      = 'ISC/' . $a . '/FEPassive/' . $idAzienda . 
                    '/Download/' . $idFattura . '/' . $index . '/' . $type;

        // URL per la chiamata
        $u      = $cf['archivium']['profile']['url'] . $e;

        // effettuo la chiamata
        $r      = restCall( $u, METHOD_GET, NULL, MIME_APPLICATION_JSON, MIME_APPLICATION_XML, $s, array(), NULL, NULL, $error, NULL, NULL, $raw );

        // debug
        // var_dump( $u );
        // var_dump( $s );
        // var_dump( $r );

        // inizializzazione variabili
        $fe     = NULL;

        // pulizia chiave FatturaElettronica
        if( is_array( $r ) ) {
            foreach( $r as $k => $v ) {

                if( strpos( $k, 'FatturaElettronica' ) !== false ) {
                    $fe = $v;
                }
            }
        }

        // restituisco il risultato
        return array( 'FatturaElettronica' => $fe, 'xml' => $raw );

    }

    /**
     * registra nel database le fatture passive di un mese
     *
     * Questa funzione scarica con archiviumGetListaFePassive() l'elenco delle fatture passive dell'azienda la cui
     * DataFattura comincia per $data, e registra ciascuna fattura con archiviumRegistraFePassiva(), unendo a ogni
     * elemento dell'elenco il risultato della registrazione. Se $data è vuota viene usato il mese corrente. Se la
     * lista non è un array (errore della chiamata) il ciclo genera un warning e non viene registrato niente.
     *
     * @param       string      $idAzienda  l'ID Archivium dell'azienda destinataria
     * @param       string      $data       il prefisso della data delle fatture, nel formato Y-m o Y (default il mese
     *                                      corrente)
     *
     * @return      mixed                   l'elenco delle fatture arricchito con i dati della registrazione, o NULL
     *                                      in caso di errore
     *
     */
    function archiviumRegistraFePassive( $idAzienda, $data = NULL ) {

        // valori di default per $dataInizio e $dataFine periodo di download
        $data = ( empty( $data ) ) ? date( 'Y-m' ) : $data;

        // scarico l'elenco 
        $l = archiviumGetListaFePassive( $idAzienda, 0, 'ID=ASC', 'RIGHT', 'DataFattura=' . $data );

        // debug
        // print_r( $l );

        // TODO registro le fatture scaricate
        foreach( $l as &$f ) {

            $f = array_replace_recursive( $f, archiviumRegistraFePassiva( $idAzienda, $f['IDArchivium'] ) );

        }

        // restituisco il risultato
        return $l;

    }

    /**
     * NOTA le tipologie di documento
     * TD01 - Fattura
     * TD02 - Acconto/anticipo su fattura
     * TD03 - Acconto/anticipo su parcella
     * TD05 - Nota di debito
     * TD06 - Parcella
     * TD16 - Integrazione fattura reverse charge interno
     * TD17 - Integrazione/autofattura per acquisto servizi da estero (ex art. 17 c.2 Dpr 633/72)
     * TD18 - Integrazione per acquisto beni intracomunitari (art. 46 DL 331/93)
     * TD19 - Integrazione/autofattura per acquisto beni (ex art.17 co.2 DPR 633/72)
     * TD20 - Autofattura denuncia (per regolarizzazione e integrazione delle fatture - art.6 c.8 d.lgs.471/97 o art.46 c.5 D.L.331/93)
     * TD21 - Autofattura per splafonamento
     * TD22 - Estrazione beni da Deposito IVA
     * TD23 - Estrazione beni da Deposito IVA con versamento IVA
     * TD24 - Fattura differita - art.21 c.4 lett. a (ovvero fattura differita di beni collegati a DDT o di servizi collegati a idonea documentazione di prova dell'effettuazione per le prestazioni di servizio)
     * TD25 - Fattura differita - art.21 c.4 terzo periodo lett. b (triangolari interne, ossia cessione di beni effettuata dal cessionario verso un terzo per il tramite del cedente)
     * TD26 - Cessione di beni ammortizzabili e per passaggi interni - art.36 DPR 633/72
     * TD27 - Fattura per autoconsumo o per cessioni gratuite senza rivalsa
     */

    /**
     * registra nel database una fattura passiva
     *
     * Questa funzione scarica metadati (archiviumGetInfoFePassiva()) e contenuto (archiviumGetDownloadFePassiva())
     * della fattura e, se sia il cessionario/committente sia il cedente/prestatore hanno una denominazione o un nome e
     * cognome, la registra nel database:
     *
     * -# inserisce l'anagrafica del cessionario/committente (l'azienda gestita, $i['idCliente']) e le associa la
     *    prima categoria con se_gestita = 1;
     * -# inserisce l'anagrafica del cedente/prestatore (il fornitore, $i['idFornitore']), le associa la prima
     *    categoria con se_fornitore = 1 e ne aggiorna la vista statica con updateAnagraficaViewStatic();
     * -# se i metadati contengono l'IDArchivium, inserisce il documento (tipologia ricavata dal TipoDocumento, numero
     *    e sezionale ricavati dal Numero separato da slash, XML grezzo) e poi le righe in documenti_articoli e i
     *    pagamenti in pagamenti, riusando nell'ordine gli ID delle righe e dei pagamenti già presenti sul documento;
     *    per ogni riga il reparto viene cercato in base all'aliquota IVA e creato se manca, con il nome "REPARTO IVA
     *    <aliquota>%" e l'aliquota senza zeri decimali superflui ( 10.00 diventa 10, 5.50 diventa 5.5 ), per ogni
     *    pagamento con IBAN l'IBAN viene inserito sul fornitore.
     *
     * Tutti gli inserimenti passano per mysqlInsertRow() con id NULL, quindi con INSERT ... ON DUPLICATE KEY UPDATE:
     * un'anagrafica, un documento o un IBAN già esistenti vengono riconosciuti solo se i dati violano un indice
     * univoco della tabella, altrimenti viene creata una riga nuova. Se il controllo su una delle due anagrafiche
     * fallisce la funzione non scrive niente nel database.
     *
     * TODO partita_iva e codice_fiscale delle anagrafiche vengono entrambi valorizzati con IdFiscaleIVA/IdCodice, mentre
     * l'XML ha un campo CodiceFiscale distinto; per una persona fisica senza partita IVA il codice fiscale resta vuoto.
     * La correzione ovvia ( CodiceFiscale se presente, altrimenti IdCodice ) non è stata fatta perché l'anagrafica
     * esistente viene riconosciuta solo dagli indici univoci unica_aziende, unica_persone e unica_professionisti, che
     * contengono codice_fiscale: per ogni fornitore con codice fiscale diverso dalla partita IVA ( tutte le ditte
     * individuali, parte delle società ) la prima fattura dopo la correzione creerebbe un doppione dell'anagrafica
     * già registrata con codice_fiscale = partita IVA. Va corretta insieme a una patch che sistemi le anagrafiche già
     * importate, o cercando l'anagrafica per partita IVA prima di inserirla ( 2026-09-24 )
     *
     * @param       string      $idAzienda  l'ID Archivium dell'azienda destinataria
     * @param       string      $idFattura  l'IDArchivium della fattura passiva
     *
     * @return      array                   i dati della fattura (metadati uniti al contenuto scaricato) con in più la
     *                                      chiave __info__ che contiene gli ID creati (idCliente, idFornitore,
     *                                      numero, idDocumento), vuota se la fattura non è stata registrata
     *
     */
    function archiviumRegistraFePassiva( $idAzienda, $idFattura ) {

        // globalizzazione di $cf
        global $cf;

        // inizializzo l'array delle informazioni
        $i = array();

        // scarico i dettagli della fattura
        $d = archiviumGetInfoFePassiva( $idAzienda, $idFattura );

        // scarico il contenuto della fattura
        $f = archiviumGetDownloadFePassiva( $idAzienda, $idFattura );

        // unisco gli array
        // SE DÀ ERRORI LA RIGA SOTTO USARE $d['FatturaElettronica'] = $f['FatturaElettronica'];
        $d = array_replace_recursive( $d, $f );

        // debug
        // print_r( $d );
        // print_r( $f );

        // verifico la validità delle anagrafiche
        // NB: nella fattura passiva il fornitore è il cedente/prestatore e il cliente ( l'azienda gestita ) è il
        // cessionario/committente; prima si controllava solo il cessionario, chiamandolo fornitore, mentre la
        // funzione inserisce tutti e due e il tracciato FatturaPA li rende entrambi obbligatori ( 2026-09-24 )
        $cliente = $d['FatturaElettronica']['FatturaElettronicaHeader']['CessionarioCommittente']['DatiAnagrafici']['Anagrafica'];
        $fornitore = $d['FatturaElettronica']['FatturaElettronicaHeader']['CedentePrestatore']['DatiAnagrafici']['Anagrafica'];

        // controllo formale
        if( ( ( isset( $cliente['Denominazione']['#'] ) && ! empty( $cliente['Denominazione']['#'] ) ) || ( isset( $cliente['Nome']['#'] ) && isset( $cliente['Cognome']['#'] ) && ! empty( $cliente['Nome']['#'] . $cliente['Cognome']['#'] ) ) ) &&
            ( ( isset( $fornitore['Denominazione']['#'] ) && ! empty( $fornitore['Denominazione']['#'] ) ) || ( isset( $fornitore['Nome']['#'] ) && isset( $fornitore['Cognome']['#'] ) && ! empty( $fornitore['Nome']['#'] . $fornitore['Cognome']['#'] ) ) ) ) {

            // cerco o creo il cliente
            if( isset( $d['FatturaElettronica']['FatturaElettronicaHeader']['CessionarioCommittente']['DatiAnagrafici']['Anagrafica']['Denominazione']['#'] ) ) {
                $i['idCliente'] = mysqlInsertRow(
                    $cf['mysql']['connection'],
                    array(
                        'id' => NULL,
                        'denominazione' => $d['FatturaElettronica']['FatturaElettronicaHeader']['CessionarioCommittente']['DatiAnagrafici']['Anagrafica']['Denominazione']['#'],
                        'partita_iva' => $d['FatturaElettronica']['FatturaElettronicaHeader']['CessionarioCommittente']['DatiAnagrafici']['IdFiscaleIVA']['IdCodice']['#'],
                        'codice_fiscale' => $d['FatturaElettronica']['FatturaElettronicaHeader']['CessionarioCommittente']['DatiAnagrafici']['IdFiscaleIVA']['IdCodice']['#']
                    ),
                    'anagrafica'
                );
            } else {
                $i['idCliente'] = mysqlInsertRow(
                    $cf['mysql']['connection'],
                    array(
                        'id' => NULL,
                        'nome' => $d['FatturaElettronica']['FatturaElettronicaHeader']['CessionarioCommittente']['DatiAnagrafici']['Anagrafica']['Nome']['#'],
                        'cognome' => $d['FatturaElettronica']['FatturaElettronicaHeader']['CessionarioCommittente']['DatiAnagrafici']['Anagrafica']['Cognome']['#'],
                        'partita_iva' => $d['FatturaElettronica']['FatturaElettronicaHeader']['CessionarioCommittente']['DatiAnagrafici']['IdFiscaleIVA']['IdCodice']['#'],
                        'codice_fiscale' => $d['FatturaElettronica']['FatturaElettronicaHeader']['CessionarioCommittente']['DatiAnagrafici']['IdFiscaleIVA']['IdCodice']['#']
                    ),
                    'anagrafica'
                );
            }

            // TODO
            // aggiungere la categoria azienda gestita al cliente
            mysqlInsertRow(
                $cf['mysql']['connection'],
                array(
                    'id' => NULL,
                    'id_anagrafica' => $i['idCliente'],
                    'id_categoria' => mysqlSelectValue( $cf['mysql']['connection'], 'SELECT id FROM categorie_anagrafica WHERE se_gestita = 1 LIMIT 1')
                ),
                'anagrafica_categorie'
            );

            // cerco o creo il fornitore
            if( isset( $d['FatturaElettronica']['FatturaElettronicaHeader']['CedentePrestatore']['DatiAnagrafici']['Anagrafica']['Denominazione']['#'] ) ) {
                $i['idFornitore'] = mysqlInsertRow(
                    $cf['mysql']['connection'],
                    array(
                        'id' => NULL,
                        'denominazione' => $d['FatturaElettronica']['FatturaElettronicaHeader']['CedentePrestatore']['DatiAnagrafici']['Anagrafica']['Denominazione']['#'],
                        'partita_iva' => $d['FatturaElettronica']['FatturaElettronicaHeader']['CedentePrestatore']['DatiAnagrafici']['IdFiscaleIVA']['IdCodice']['#'],
                        'codice_fiscale' => $d['FatturaElettronica']['FatturaElettronicaHeader']['CedentePrestatore']['DatiAnagrafici']['IdFiscaleIVA']['IdCodice']['#']
                    ),
                    'anagrafica'
                );
            } else {
                $i['idFornitore'] = mysqlInsertRow(
                    $cf['mysql']['connection'],
                    array(
                        'id' => NULL,
                        'nome' => $d['FatturaElettronica']['FatturaElettronicaHeader']['CedentePrestatore']['DatiAnagrafici']['Anagrafica']['Nome']['#'],
                        'cognome' => $d['FatturaElettronica']['FatturaElettronicaHeader']['CedentePrestatore']['DatiAnagrafici']['Anagrafica']['Cognome']['#'],
                        'partita_iva' => $d['FatturaElettronica']['FatturaElettronicaHeader']['CedentePrestatore']['DatiAnagrafici']['IdFiscaleIVA']['IdCodice']['#'],
                        'codice_fiscale' => $d['FatturaElettronica']['FatturaElettronicaHeader']['CedentePrestatore']['DatiAnagrafici']['IdFiscaleIVA']['IdCodice']['#']
                    ),
                    'anagrafica'
                );
            }

            // TODO
            // aggiungere la categoria fornitore al fornitore
            mysqlInsertRow(
                $cf['mysql']['connection'],
                array(
                    'id' => NULL,
                    'id_anagrafica' => $i['idFornitore'],
                    'id_categoria' => mysqlSelectValue( $cf['mysql']['connection'], 'SELECT id FROM categorie_anagrafica WHERE se_fornitore = 1 LIMIT 1')
                ),
                'anagrafica_categorie'
            );

            // aggiornamento view statica
            // mysqlQuery( $cf['mysql']['connection'], 'CALL anagrafica_view_static( ? )', array( array( 's' => $i['idFornitore'] ) ) );
            // mysqlQuery( $cf['mysql']['connection'], 'REPLACE INTO anagrafica_view_static SELECT * FROM anagrafica_view WHERE id = ?', array( array( 's' => $i['idFornitore'] ) ) );
            // mysqlQuery( $cf['mysql']['connection'], 'REPLACE INTO anagrafica_archiviati_view_static SELECT * FROM anagrafica_archiviati_view WHERE id = ?', array( array( 's' => $i['idFornitore'] ) ) );
            // mysqlQuery( $cf['mysql']['connection'], 'REPLACE INTO anagrafica_attivi_view_static SELECT * FROM anagrafica_attivi_view WHERE id = ?', array( array( 's' => $i['idFornitore'] ) ) );
            updateAnagraficaViewStatic( $i['idFornitore'] );

            // pre elaborazione dati
            $i['numero'] = explode( '/', $d['FatturaElettronica']['FatturaElettronicaBody']['DatiGenerali']['DatiGeneraliDocumento']['Numero']['#'] );

            // se è presente il codice Archivium
            if( isset( $d['IDArchivium'] ) && ! empty( $d['IDArchivium'] ) ) {

                // TODO inserisco la riga nella tabella documenti
                $i['idDocumento'] = mysqlInsertRow(
                    $cf['mysql']['connection'],
                    array(
                        'id' => NULL,
                        'id_tipologia' => mysqlSelectValue( $cf['mysql']['connection'], 'SELECT id FROM tipologie_documenti WHERE codice = ?', array( array( 's' => $d['FatturaElettronica']['FatturaElettronicaBody']['DatiGenerali']['DatiGeneraliDocumento']['TipoDocumento']['#'] ) ) ),
                        'data' => $d['FatturaElettronica']['FatturaElettronicaBody']['DatiGenerali']['DatiGeneraliDocumento']['Data']['#'],
                        'numero' => $i['numero'][0],
                        'sezionale' => ( isset( $i['numero'][1] ) ? $i['numero'][1] : NULL ),
                        'codice_archivium' => $d['IDArchivium'],
                        'id_emittente' => $i['idFornitore'],
                        'id_destinatario' => $i['idCliente'],
                        'xml' => $f['xml']
                    ),
                    'documenti'
                );

                // recupero le righe esistenti
                $idRighe = mysqlSelectColumn(
                    'id',
                    $cf['mysql']['connection'],
                    'SELECT id FROM documenti_articoli WHERE id_documento = ?',
                    array( array( 's' => $i['idDocumento'] ) )
                );

                // se è presente l'oggetto righe
                if( ! empty( $d['FatturaElettronica']['FatturaElettronicaBody']['DatiBeniServizi']['DettaglioLinee'] ) ) {

                    // gestisco le righe multiple
                    $arrayRighe = ( is_associative_array( $d['FatturaElettronica']['FatturaElettronicaBody']['DatiBeniServizi']['DettaglioLinee'] ) )
                        ? array( $d['FatturaElettronica']['FatturaElettronicaBody']['DatiBeniServizi']['DettaglioLinee'] )
                        : $d['FatturaElettronica']['FatturaElettronicaBody']['DatiBeniServizi']['DettaglioLinee'];

                    // TODO inserisco le righe nella tabella documenti_articoli
                    foreach( $arrayRighe as $row ) {

                        // debug
                        // print_r( $row );

                        // trovo il reparto in base all'aliquota
                        $idReparto = mysqlSelectValue(
                            $cf['mysql']['connection'],
                            'SELECT reparti.id FROM reparti INNER JOIN iva ON iva.id = reparti.id_iva WHERE iva.aliquota = ?',
                            array( array( 's' => $row['AliquotaIVA']['#'] ) )
                        );

                        // se il reparto non esiste, lo creo
                        if( empty( $idReparto ) ) {

                            $idIva = mysqlSelectValue(
                                $cf['mysql']['connection'],
                                'SELECT id FROM iva WHERE iva.aliquota = ?',
                                array( array( 's' => $row['AliquotaIVA']['#'] ) )
                            );

                            // NB: floatval() toglie gli zeri decimali superflui ( 10.00 -> 10, 5.50 -> 5.5, 0.00 -> 0 ); il
                            // rtrim( $aliquota, '.0' ) usato prima toglieva anche quelli della parte intera ( 2026-09-24 )
                            $idReparto = mysqlInsertRow(
                                $cf['mysql']['connection'],
                                array(
                                    'id' => NULL,
                                    'nome' => 'REPARTO IVA ' . floatval( $row['AliquotaIVA']['#'] ) . '%',
                                    'id_iva' => $idIva
                                ),
                                'reparti'
                            );

                        }

                        // inserisco la riga
                        mysqlInsertRow(
                            $cf['mysql']['connection'],
                            array(
                                'id' => array_shift( $idRighe ),
                                'ordine' => $row['NumeroLinea']['#'],
                                'nome' => $row['Descrizione']['#'],
                                'id_documento' => $i['idDocumento'],
                                'importo_netto_totale' => $row['PrezzoTotale']['#'],
                                'id_reparto' => $idReparto
                            ),
                            'documenti_articoli'
                        );

                    }

                }

                // recupero i pagamenti esistenti
                $idPagamenti = mysqlSelectColumn(
                    'id',
                    $cf['mysql']['connection'],
                    'SELECT id FROM pagamenti WHERE id_documento = ?',
                    array( array( 's' => $i['idDocumento'] ) )
                );

                // se è presente l'oggetto righe
                if( ! empty( $d['FatturaElettronica']['FatturaElettronicaBody']['DatiPagamento']['DettaglioPagamento'] ) ) {

                    // gestisco i pagamenti multipli
                    $arrayPagamenti = ( is_associative_array( $d['FatturaElettronica']['FatturaElettronicaBody']['DatiPagamento']['DettaglioPagamento'] ) )
                        ? array( $d['FatturaElettronica']['FatturaElettronicaBody']['DatiPagamento']['DettaglioPagamento'] )
                        : $d['FatturaElettronica']['FatturaElettronicaBody']['DatiPagamento']['DettaglioPagamento'];

                    // TODO inserisco le righe nella tabella pagamenti
                    foreach( $arrayPagamenti as $row ) {

                        // debug
                        // print_r( $row );

                        // recupero la modalità di pagamento
                        $idModalita = mysqlSelectValue(
                            $cf['mysql']['connection'],
                            'SELECT id FROM modalita_pagamento WHERE codice = ?',
                            array( array( 's' => $row['ModalitaPagamento']['#'] ) )
                        );

                        // cerco iban nel database
                        if( ! empty( $row['IBAN']['#'] ) ){

                            $idIban = mysqlInsertRow($cf['mysql']['connection'],
                            array(
                                'id' => NULL,
                                'id_anagrafica' => $i['idFornitore'],
                                'iban' => $row['IBAN']['#']
                            ),
                            'iban'
                        );

                        } else {
                            $idIban = NULL;
                        }

                        // inserisco il pagamento
                        mysqlInsertRow(
                            $cf['mysql']['connection'],
                            array(
                                'id' => array_shift( $idPagamenti ),
                                'id_documento' => $i['idDocumento'],
                                'id_modalita_pagamento' => $idModalita,
                                'importo_lordo_finale' => $row['ImportoPagamento']['#'],
                                'data_scadenza' =>( isset($row['DataScadenzaPagamento']) ? date( 'Y-m-d', strtotime( $row['DataScadenzaPagamento']['#'] ) ) : NULL ),
                                'id_iban' =>  $idIban
                            ),
                            'pagamenti'
                        );

                    }

                }

            }

        }

        // restituisco il risultato
        return array_replace_recursive( $d, array( '__info__' => $i ) );

    }

    /**
     * FUNZIONI PER LE NOTIFICHE SDI
     */

    /**
     * restituisce l'elenco delle notifiche SDI delle fatture attive di un'azienda
     *
     * Questa funzione chiama l'endpoint ISC/.../NOTAttive/<idAzienda>/list, con i parametri di ricerca accodati come
     * in archiviumGetListaFePassive() (valgono le stesse avvertenze), e restituisce l'elenco delle notifiche ricevute
     * dallo SDI per le fatture attive dell'azienda, aggiungendo a ciascun elemento la chiave IDArchiviumAzienda.
     * Parametri e risposta vengono scritti nel log archivium. I chiamanti filtrano per data di inserimento
     * (DataIns=<anno>) o per fattura (IDArchiviumFE=<codice>). Se la chiamata fallisce e la risposta non è un array
     * il ciclo di arricchimento genera un warning e la funzione restituisce il valore ricevuto, tipicamente NULL.
     *
     * @param       string      $idAzienda  l'ID Archivium dell'azienda
     * @param       int         $limit      il numero massimo di record
     * @param       string      $order      il criterio di ordinamento, ad es. ID=ASC
     * @param       string      $wildcard   il tipo di ricerca, LEFT, RIGHT, BOTH o NONE
     * @param       string      $params     il criterio di ricerca colonna=valore
     *
     * @return      mixed                   l'array delle notifiche, o NULL in caso di errore
     *
     */
    function archiviumGetListaNoteAttive( $idAzienda, $limit = NULL, $order = NULL, $wildcard = NULL, $params = NULL  ) {

        // inizializzazione variabili
        $s      = NULL;

        // globalizzazione di $cf
        global $cf;

        // autenticazione per la chiamata
        $a      = $cf['archivium']['profile']['id'] . '/' . $cf['archivium']['profile']['apikey'];

        // parametri di ricerca
        $p      = trim( implode( '/', array( $limit, $order, $wildcard, $params ) ), '/' );

        // endpoint per la chiamata
        $e      = 'ISC/' . $a . '/NOTAttive/' . $idAzienda . '/list' . ( ( ! empty( $p ) ) ? '/' . $p : NULL );

        // URL per la chiamata
        $u      = $cf['archivium']['profile']['url'] . $e;

        // effettuo la chiamata
        $l      = restCall( $u, METHOD_GET, NULL, MIME_APPLICATION_JSON, MIME_APPLICATION_JSON, $s );

        // aggiungo l'azienda a ogni elemento dell'array
        foreach( $l as &$e ) {
            $e['IDArchiviumAzienda'] = $idAzienda;
        }

        // debug
        // var_dump( $u );
        // var_dump( $s );
        // print_r( $l );

        // log
        logWrite( $idAzienda . ' ' . $limit . ' ' . $order . ' ' . $wildcard . ' ' . $params, 'archivium' );
        logWrite( print_r( $l, true ), 'archivium' );

        // restituisco il risultato
        return $l;

    }

    /**
     * registra nel database le notifiche SDI di un mese
     *
     * Questa funzione scarica con archiviumGetListaNoteAttive() l'elenco delle notifiche la cui DataIns comincia per
     * $data e registra ciascuna notifica con archiviumRegistraNotaAttiva(), unendo a ogni elemento dell'elenco il
     * risultato della registrazione. Se $data è vuota viene usato il mese corrente. Se la lista non è un array
     * (errore della chiamata) il ciclo genera un warning e non viene registrato niente.
     *
     * @param       string      $idAzienda  l'ID Archivium dell'azienda
     * @param       string      $data       il prefisso della data di inserimento delle notifiche, nel formato Y-m o
     *                                      Y (default il mese corrente)
     *
     * @return      mixed                   l'elenco delle notifiche arricchito con i dati della registrazione, o NULL
     *                                      in caso di errore
     *
     */
    function archiviumRegistraNoteAttive( $idAzienda, $data = NULL ) {

        // valori di default per $dataInizio e $dataFine periodo di download
        $data = ( empty( $data ) ) ? date( 'Y-m' ) : $data;

        // scarico l'elenco 
        $l = archiviumGetListaNoteAttive( $idAzienda, 0, 'ID=ASC', 'RIGHT', 'DataIns=' . $data );

        // debug
        // print_r( $l );

        // TODO registro le note scaricate
        foreach( $l as &$f ) {

            $f = array_replace_recursive( $f, archiviumRegistraNotaAttiva( $idAzienda, $f ) );

            // print_r( $f );

        }

        // restituisco il risultato
        return $l;

    }

    /**
     * registra nel database una notifica SDI come attività
     *
     * Questa funzione completa la notifica ricevuta dall'elenco con le informazioni di archiviumGetInfoNotaAttiva(),
     * cerca la tipologia di attività il cui codice è uguale al TipoNotifica (i valori possibili sono nella NOTA che
     * segue la funzione) e il documento il cui codice_archivium è uguale a IDArchiviumFE, e se trova entrambi
     * inserisce un'attività sul documento con data e ora di DataIns, il nome composto da EsitoNotifica e
     * DescrizioneEsito e il codice_archivium della notifica. Se la tipologia o il documento mancano la notifica non
     * viene registrata e non viene segnalato niente, a parte il log archivium della notifica ricevuta.
     *
     * @param       string      $idAzienda  l'ID Archivium dell'azienda
     * @param       array       $nota       l'elemento dell'elenco restituito da archiviumGetListaNoteAttive(), che deve
     *                                      contenere almeno la chiave IDArchivium
     *
     * @return      array                   i dati della notifica con in più la chiave __info__, che contiene l'ID
     *                                      dell'attività inserita oppure un array vuoto se non è stata registrata
     *
     */
    function archiviumRegistraNotaAttiva( $idAzienda, $nota ) {

        // globalizzazione di $cf
        global $cf;

        // inizializzo l'array delle informazioni
        $i = array();

        // scarico i dettagli della fattura
        $d = array_replace_recursive(
            $nota,
            archiviumGetInfoNotaAttiva( $idAzienda, $nota['IDArchivium'] )
        );

        // debug
        // print_r( $d );
        // print_r( $f );

        // log
        logWrite( print_r( $nota, true ), 'archivium' );

        // recupero l'ID tipologia attività dal codice (TipoNotifica e EsitoNotifica)
        $idTipologiaAttivita = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT id FROM tipologie_attivita WHERE codice = ?',
            array( array( 's' => $d['TipoNotifica'] ) )
        );

        // recupero l'ID fattura dal codice_archivium (IDArchiviumFE)
        $idFattura = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT id FROM documenti WHERE codice_archivium = ?',
            array( array( 's' => $d['IDArchiviumFE'] ) )
        );

        // se ho tutti i dati che mi servono
        if( ! empty( $idTipologiaAttivita ) && ! empty( $idFattura ) ) {

            // inserisco l'attività
            $i = mysqlInsertRow(
                $cf['mysql']['connection'],
                array(
                    'id' => NULL,
                    'id_tipologia' => $idTipologiaAttivita,
                    'data_attivita' => date( 'Y-m-d', strtotime( $d['DataIns'] ) ),
                    'ora_inizio' => date( 'H:i:s', strtotime( $d['DataIns'] ) ),
                    'ora_fine' => date( 'H:i:s', strtotime( $d['DataIns'] ) ),
                    'nome' => 'notifica di sistema SDI ' . $d['EsitoNotifica'] . ' ' . $d['DescrizioneEsito'],
                    'id_documento' => $idFattura,
                    'codice_archivium' => $d['IDArchivium']
                ),
                'attivita'
            );

        }

        // restituisco il risultato
        return array_replace_recursive( $d, array( '__info__' => $i ) );

    }

    /**
     * NOTA valori del campo TipoNotifica
     * 
     * RC Ricevuta di Consegna
     * MC Mancata Consegna
     * NS Notifica di Scarto
     * AT Attestato di presa in carico ma di impossibilità di recapito
     * DT Decorrenza Termini
     * EC Notifica di Esito Committente
     * NE Notifica di Esito
     * MT Notifica Metadati per FE passiva
     * 
     * valori del campo EsitoNotifica
     * 
     * EC01/NE01 Notifica di Esito o Esito Committente di accettazione FE
     * EC02/NE02 Notifica di Esito o Esito Committente di rifiuto FE
     * 
     */

    /**
     * restituisce le informazioni su una notifica SDI
     *
     * Questa funzione chiama l'endpoint ISC/.../NOTAttive/<idAzienda>/info/<idNota>/<index> e restituisce la
     * risposta decodificata con i dettagli della notifica, fra cui TipoNotifica, EsitoNotifica, DescrizioneEsito e
     * IDArchiviumFE; la risposta viene anche scritta nel log archivium. In caso di errore restituisce quello che
     * restCall() ottiene decodificando la risposta, tipicamente NULL.
     *
     * @param       string      $idAzienda  l'ID Archivium dell'azienda
     * @param       string      $idNota     l'identificativo della notifica, del tipo indicato da $index
     * @param       string      $index      il tipo di identificativo passato in $idNota (default IDArchivium)
     *
     * @return      mixed                   l'array con le informazioni sulla notifica, o NULL in caso di errore
     *
     */
    function archiviumGetInfoNotaAttiva( $idAzienda, $idNota, $index = 'IDArchivium'  ) {

        // inizializzazione variabili
        $s      = NULL;

        // globalizzazione di $cf
        global $cf;

        // autenticazione per la chiamata
        $a      = $cf['archivium']['profile']['id'] . '/' . $cf['archivium']['profile']['apikey'];

        // endpoint per la chiamata
        $e      = 'ISC/' . $a . '/NOTAttive/' . $idAzienda . '/info/' . $idNota . '/' . $index;

        // URL per la chiamata
        $u      = $cf['archivium']['profile']['url'] . $e;

        // effettuo la chiamata
        $r      = restCall( $u, METHOD_GET, NULL, MIME_APPLICATION_JSON, MIME_APPLICATION_JSON, $s );

        // debug
        // var_dump( $u );
        // var_dump( $s );
        // print_r( $r );

        // log
        logWrite( $idAzienda . ' ' . $idNota . ' ' . print_r( $r, true ), 'archivium' );

        // restituisco il risultato
        return $r;

    }
