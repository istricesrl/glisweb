<?php

    /**
     *
     *
     *
     *
     *
     *
     *
     *
     * @todo documentare
     * @file
     *
     */

    /**
     *
     * @todo documentare
     * 
     */
    function archiviumGetListaAziende( $limit = NULL, $order = NULL, $wildcard = NULL, $params = NULL ) {

        // inizializzazione variabili
        $s      = NULL;

        // globalizzazione di $cf
        global $cf;

        // autenticazione per la chiamata
        $a      = $cf['archivium']['profile']['id'] . '/' . $cf['archivium']['profile']['apikey'];

        // endpoint per la chiamata
        $e      = 'Admin/' . $a . '/Enterprises/list';

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
     * {orderby}: definisce il criterio di ordinamento deve essere inserito il nome di un metadato (si veda servizio Metadata) seguito da = ed uno dei valori
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
     *
     * NOTA qui il parametro $idAzienda fa riferimento all'ID Archivium dell'azienda
     * 
     * @todo documentare
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
     *
     * NOTA il parametro $id qui fa riferimento all'ID dell'azienda nel database
     * 
     * @todo documentare
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

        // TODO salvo l'ID SDI dell'anagrafica
        if( $r['esito'] == 200 ) {

            mysqlQuery(
                $cf['mysql']['connection'],
                'UPDATE anagrafica SET codice_archivium = ?',
                array( array( 's' => $r['IDAzienda'] ) )
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
     *
     * NOTA il parametro $id qui fa riferimento all'ID dell'azienda nel database
     * mentre $idAzienda fa riferimento all'ID Archivium dell'azienda
     * 
     * @todo documentare
     * 
     */
    function archiviumPostAggiornamentoAzienda( $id, $idAzienda ) {
    }

    /**
     *
     * @todo documentare
     * 
     */
    function archiviumGetListaFeAttive( $idAzienda, $limit = NULL, $order = NULL, $wildcard = NULL, $params = NULL  ) {

        // inizializzazione variabili
        $s      = NULL;

        // globalizzazione di $cf
        global $cf;

        // autenticazione per la chiamata
        $a      = $cf['archivium']['profile']['id'] . '/' . $cf['archivium']['profile']['apikey'];

        // endpoint per la chiamata
        $e      = 'ISC/' . $a . '/FEAttive/' . $idAzienda . '/list';

        // URL per la chiamata
        $u      = $cf['archivium']['profile']['url'] . $e;

        // TODO fare la chiamata

        // TODO restituire il risultato

    }

    /**
     *
     * @todo documentare
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
     *
     * @todo documentare
     * 
     */
    function archiviumPostInvioFeAttiva( $idAzienda, $xmlFattura, $tipo = 'XML', $mail = NULL  ) {

        // inizializzazione variabili
        $s      = NULL;

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
        if( $r['esito'] == 200 ) {
            mysqlQuery(
                $cf['mysql']['connection'],
                'UPDATE documenti SET codice_archivium = ?',
                array( array( 's' => $r['IDArchivium'] ) )
            );
        }

        /**
         * NOTA
         * Array ( [esito] => 200 [message] => FE attiva presa in carico correttamente [ID] => 1 [IDArchivium] => 7OF8J-61cddbffd8dea [NomeFileSDI] => IT09468600011_CJWFX.xml.p7m [NomeFileCaricato] => IT1234568790_1.xml )
         */

        // TODO restituire il risultato
        return $r['esito'];

    }

    /**
     *
     * @todo documentare
     * 
     */
    function archiviumGetListaFePassive( $idAzienda, $limit = NULL, $order = NULL, $wildcard = NULL, $params = NULL  ) {

        // inizializzazione variabili
        $s      = NULL;

        // globalizzazione di $cf
        global $cf;

        // autenticazione per la chiamata
        $a      = $cf['archivium']['profile']['id'] . '/' . $cf['archivium']['profile']['apikey'];

        // endpoint per la chiamata
        $e      = 'ISC/' . $a . '/FEPassive/' . $idAzienda . '/list';

        // URL per la chiamata
        $u      = $cf['archivium']['profile']['url'] . $e;

        // TODO fare la chiamata

        // TODO restituire il risultato

    }

    /**
     *
     * @todo documentare
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

        // TODO fare la chiamata

        // TODO restituire il risultato

    }

    /**
     *
     * @todo documentare
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
        $e      = 'ISC/' . $a . '/FEPassive/' . $idAzienda . '/Download/' . $idFattura . '/' . $index . '/' . $type;

        // URL per la chiamata
        $u      = $cf['archivium']['profile']['url'] . $e;

        // TODO fare la chiamata

        // TODO restituire il risultato

    }
