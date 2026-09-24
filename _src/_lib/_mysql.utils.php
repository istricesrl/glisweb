<?php

    /**
     * libreria di funzioni applicative per MySQL
     *
     * Questa libreria contiene funzioni che leggono e scrivono le tabelle standard del framework ( anagrafica, indirizzi,
     * pagine e contenuti, tendine comuni ) appoggiandosi alle funzioni di base di _src/_lib/_mysql.tools.php.
     *
     * introduzione
     * ============
     * A differenza di _mysql.tools.php, che riceve sempre la connessione come parametro, quasi tutte le funzioni di questa
     * libreria prendono la connessione dalla configurazione globale ( $cf['mysql']['connection'] e, per quelle che usano
     * la cache, $cf['memcache']['connection'] e $cf['memcache']['index'] ), secondo la convenzione per cui le librerie
     * utils possono dipendere da $cf e le tools no. Fanno eccezione trovaRigaDaElaborare() e mysqlSelectLabel(), che
     * ricevono la connessione come parametro. Le funzioni conoscono i nomi delle tabelle e delle colonne dello schema
     * standard, quindi vanno toccate insieme alle patch che lo modificano.
     *
     * Come di consueto le funzioni della libreria sono raggruppate per area tematica.
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
     * funzioni di ricerca degli ID
     * ----------------------------
     * Le funzioni in questo gruppo cercano l'ID di un oggetto a partire da un suo attributo.
     *
     * funzione                                 | descrizione
     * -----------------------------------------|---------------------------------------------------------------
     * trovaidComune()                          | restituisce l'ID di un comune dato il nome
     * trovaIdTipologiaAttivita()               | restituisce l'ID di una tipologia di attività dato il nome
     * trovaIdAnagraficaPerDenominazione()      | restituisce l'ID di un'anagrafica data la denominazione
     * trovaIdMatricola()                       | restituisce l'ID di una matricola dato il suo valore
     * trovaIdAziendaGestita()                  | restituisce l'ID della prima azienda gestita
     * tendinaAziendeGestite()                  | restituisce la tendina delle aziende gestite
     * trovaIdSedeLegale()                      | restituisce l'ID della sede di un'anagrafica da usare nei documenti
     *
     * funzioni per gli indirizzi delle anagrafiche
     * --------------------------------------------
     * Le funzioni in questo gruppo gestiscono il passaggio di anagrafica_indirizzi alla copia inline dell'indirizzo.
     *
     * funzione                                 | descrizione
     * -----------------------------------------|---------------------------------------------------------------
     * anagraficaIndirizziInline()              | verifica se `anagrafica_indirizzi` porta la copia inline dell'indirizzo
     * sincronizzaIndirizzoInline()             | allinea la copia inline dell'indirizzo sulle righe di `anagrafica_indirizzi` che lo collegano
     * tendinaSediAnagrafica()                  | tendina delle sedi di un'anagrafica, nella forma che la colonna di destinazione si aspetta
     *
     * funzioni per il popolamento delle pagine
     * ----------------------------------------
     * Le funzioni in questo gruppo aggiungono all'array di una pagina ( di solito $cf['contents']['pages'][ $pid ] ) i
     * dati collegati letti dal database; le usano i runlevel dei moduli che generano pagine dal database.
     *
     * funzione                                 | descrizione
     * -----------------------------------------|---------------------------------------------------------------
     * aggiungiImmagini()                       | aggiunge a una pagina le immagini collegate a un oggetto
     * aggiungiVideo()                          | aggiunge a una pagina i video collegati a un oggetto
     * aggiungiAudio()                          | aggiunge a una pagina gli audio collegati a un oggetto
     * aggiungiFile()                           | aggiunge a una pagina i file collegati a un oggetto
     * aggiungiRecensioni()                     | aggiunge a una pagina le recensioni approvate di un oggetto
     * aggiungiDati()                           | aggiunge a una pagina i media collegati a un oggetto
     * aggiungiMacro()                          | aggiunge a una pagina le macro collegate a un oggetto
     * aggiungiMenu()                           | aggiunge a una pagina le voci di menu collegate a un oggetto
     * aggiungiCaratteristiche()                | aggiunge a una pagina le caratteristiche di un oggetto
     * aggiungiMetadati()                       | aggiunge a una pagina i metadati collegati a un oggetto
     * aggiungiGruppi()                         | aggiunge a una pagina i gruppi autorizzati a vederla
     * aggiungiContenuti()                      | aggiunge a una pagina i contenuti testuali collegati a un oggetto
     *
     * funzioni di servizio per i task
     * -------------------------------
     * Le funzioni in questo gruppo servono ai task e alle elaborazioni in background.
     *
     * funzione                                 | descrizione
     * -----------------------------------------|---------------------------------------------------------------
     * triggerOff()                             | sospende i trigger lazy di un'entità per la connessione corrente
     * triggerOn()                              | riattiva i trigger lazy di un'entità per la connessione corrente
     * trovaTabellaDestinazioneConstraint()     | restituisce la tabella referenziata da una colonna con chiave esterna
     * trovaRigaDaElaborare()                   | trova la prossima riga di una tabella da elaborare e la marca come elaborata
     *
     * funzioni di inserimento e unione
     * --------------------------------
     * Le funzioni in questo gruppo inseriscono oggetti a partire da dati grezzi o uniscono oggetti duplicati.
     *
     * funzione                                 | descrizione
     * -----------------------------------------|---------------------------------------------------------------
     * inserisciIndirizzo()                     | scompone un indirizzo in forma libera e lo inserisce nella tabella indirizzi
     * unisciAnagrafiche()                      | unisce due anagrafiche duplicate
     * unisciOggetti()                          | unisce due righe duplicate di una tabella spostando su una tutte le referenze dell'altra
     *
     * funzioni per le tendine
     * -----------------------
     * Le funzioni in questo gruppo restituiscono tendine di uso comune, cioè array di righe con le chiavi id e __label__.
     *
     * funzione                                 | descrizione
     * -----------------------------------------|---------------------------------------------------------------
     * tendinaStati()                           | restituisce la tendina degli stati
     * tendinaAnni()                            | restituisce la tendina degli anni
     * tendinaMesi()                            | restituisce la tendina dei mesi
     * tendinaSettimane()                       | restituisce la tendina delle settimane dell'anno
     * tendinaProvincie()                       | restituisce la tendina delle province di uno stato
     * tendinaSiNo()                            | restituisce la tendina sì / no
     *
     * accessori generici dell'anagrafica
     * ----------------------------------
     * Le funzioni in questo gruppo leggono logo, PEC e sede legale di un'anagrafica; la loro storia è spiegata nel commento
     * che apre il gruppo nel corpo della libreria.
     *
     * funzione                                 | descrizione
     * -----------------------------------------|---------------------------------------------------------------
     * anagraficaGetLogo()                      | restituisce il percorso completo del logo di un'anagrafica
     * anagraficaGetSedeLegale()                | restituisce la sede legale di un'anagrafica
     * anagraficaGetIdSedeLegale()              | restituisce l'ID della sede legale di un'anagrafica
     * anagraficaGetPEC()                       | restituisce l'indirizzo PEC di un'anagrafica
     *
     * funzioni di lettura
     * -------------------
     * Le funzioni in questo gruppo leggono singoli valori con accorgimenti per le prestazioni.
     *
     * funzione                                 | descrizione
     * -----------------------------------------|---------------------------------------------------------------
     * mysqlSelectLabel()                       | legge la __label__ di una riga per id, scrivendo l'id nella query quando si puo'
     *
     * dipendenze
     * ==========
     * Questa libreria ha alcune dipendenze che devono essere soddisfatte per funzionare correttamente. In particolare
     * sono richieste le seguenti funzioni:
     *
     * funzione                         | libreria di appartenenza
     * ---------------------------------|---------------------------------------------------------------
     * logger()                         | core
     * logWrite()                       | _src/_lib/_log.utils.php
     * mysqlQuery()                     | _src/_lib/_mysql.tools.php
     * mysqlSelectValue()               | _src/_lib/_mysql.tools.php
     * mysqlSelectRow()                 | _src/_lib/_mysql.tools.php
     * mysqlSelectColumn()              | _src/_lib/_mysql.tools.php
     * mysqlSelectCachedValue()         | _src/_lib/_mysql.tools.php
     * mysqlCachedIndexedQuery()        | _src/_lib/_mysql.tools.php
     * mysqlInsertRow()                 | _src/_lib/_mysql.tools.php
     * metadati2associativeArray()      | _src/_lib/_array.tools.php
     * fullPath()                       | _src/_lib/_filesystem.tools.php
     * findFileType()                   | _src/_lib/_filesystem.tools.php
     * documentoIdSedeStampabile()      | modulo documenti, facoltativa ( se manca trovaIdSedeLegale() usa la query storica )
     * updateAnagraficaViewStatic()     | modulo anagrafica, richiesta da unisciAnagrafiche()
     * cleanAnagraficaViewStatic()      | modulo anagrafica, richiesta da unisciAnagrafiche()
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
     * FUNZIONI DI RICERCA DEGLI ID
     */

    /**
     * restituisce l'ID di un comune dato il nome
     *
     * Questa funzione cerca nella tabella comuni il comune con il nome indicato e ne restituisce l'ID; se non lo trova
     * restituisce NULL. Il nome non è univoco fra province diverse, e in quel caso viene restituito il primo trovato.
     *
     * @param       string      $comune     il nome del comune
     *
     * @return      mixed                   l'ID del comune, o NULL se non esiste
     *
     */
    function trovaidComune($comune)
    {

        // TODO migliorare prevedendo l'ID provincia come elemento di ricerca vedi sotto inserisciIndirizzo()

        global $cf;

        return mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT id FROM comuni WHERE nome = ?',
            array(array('s' => $comune))
        );
    }

    /**
     * restituisce l'ID di una tipologia di attività dato il nome
     *
     * Questa funzione cerca nella tabella tipologie_attivita la tipologia con il nome indicato e ne restituisce l'ID; se
     * non la trova restituisce NULL.
     *
     * @param       string      $attivita   il nome della tipologia di attività
     *
     * @return      mixed                   l'ID della tipologia, o NULL se non esiste
     *
     */
    function trovaIdTipologiaAttivita($attivita)
    {

        global $cf;

        return mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT id FROM tipologie_attivita WHERE nome = ?',
            array(array('s' => $attivita))
        );
    }

    /**
     * restituisce l'ID di un'anagrafica data la denominazione
     *
     * Questa funzione cerca nella tabella anagrafica la riga con la denominazione indicata ( confronto esatto ) e ne
     * restituisce l'ID; se non la trova restituisce NULL, se ce n'è più di una restituisce la prima.
     *
     * @param       string      $denominazione  la denominazione dell'anagrafica
     *
     * @return      mixed                       l'ID dell'anagrafica, o NULL se non esiste
     *
     */
    function trovaIdAnagraficaPerDenominazione($denominazione)
    {

        global $cf;

        return mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT id FROM anagrafica WHERE denominazione = ?',
            array(array('s' => $denominazione))
        );
    }

    /**
     * restituisce l'ID di una matricola dato il suo valore
     *
     * Questa funzione cerca nella tabella matricole la riga con il valore di matricola indicato e ne restituisce l'ID; se
     * non la trova restituisce NULL.
     *
     * @param       string      $matricola  il valore della matricola
     *
     * @return      mixed                   l'ID della matricola, o NULL se non esiste
     *
     */
    function trovaIdMatricola($matricola)
    {

        global $cf;

        return mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT id FROM matricole WHERE matricola = ?',
            array(array('s' => $matricola))
        );
    }

    /**
     * restituisce l'ID della prima azienda gestita
     *
     * Questa funzione restituisce l'ID della prima anagrafica associata alla categoria 5, che nello schema standard è
     * quella delle aziende gestite, cioè le aziende per conto delle quali il deploy emette documenti; se non ce n'è
     * nessuna restituisce NULL. Su un deploy con più aziende gestite la scelta fra queste non è definita ( LIMIT 1 senza
     * ORDER BY ).
     *
     * @return      mixed       l'ID dell'azienda gestita, o NULL se non esiste
     *
     */
    function trovaIdAziendaGestita()
    {

        global $cf;

        return mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT id_anagrafica FROM anagrafica_categorie WHERE id_categoria = ? LIMIT 1',
            array(array('s' => 5))
        );
    }

    /**
     * restituisce la tendina delle aziende gestite
     *
     * Questa funzione restituisce id e __label__ di tutte le anagrafiche della categoria 5 ( aziende gestite ), leggendole
     * da anagrafica_view_static; se non ce ne sono restituisce un array vuoto, se la query fallisce false.
     *
     * NOTA la query legge direttamente la vista statica, quindi su un deploy che non ha anagrafica_view_static fallisce.
     *
     * @return      mixed       l'array delle righe id / __label__, o false in caso di errore
     *
     */
    function tendinaAziendeGestite()
    {

        global $cf;

        return mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT anagrafica_view_static.id, anagrafica_view_static.__label__ 
            FROM anagrafica_view_static 
            INNER JOIN anagrafica_categorie ON anagrafica_view_static.id = anagrafica_categorie.id_anagrafica 
            WHERE anagrafica_categorie.id_categoria = ?',
            array(array('s' => 5))
        );
    }

    /**
     * restituisce l'ID della sede di un'anagrafica da usare nei documenti
     *
     * Questa funzione restituisce l'ID di anagrafica_indirizzi ( non di indirizzi ) da scrivere in
     * documenti.id_sede_emittente o documenti.id_sede_destinatario. Se è disponibile documentoIdSedeStampabile() del
     * modulo documenti usa quella, che garantisce un indirizzo completo e stampabile; altrimenti, o se quella non trova
     * niente, restituisce la prima riga di anagrafica_indirizzi con ruolo 1 o 4, o NULL se non ce ne sono. I dettagli sono
     * nei commenti nel corpo.
     *
     * @param       int         $idAnagrafica   l'ID dell'anagrafica
     *
     * @return      mixed                       l'ID della sede, o NULL se non esiste
     *
     */
    function trovaIdSedeLegale($idAnagrafica)
    {

        global $cf;

        // Fix 2026-07-10: ritorna `anagrafica_indirizzi.id`, non `id_indirizzo`.
        // Il valore alimenta solo `documenti.id_sede_emittente` / `id_sede_destinatario`,
        // che dalla migrazione del 2026-07-10 hanno FK su `anagrafica_indirizzi` (prima
        // su `indirizzi`). Le query di lettura del modulo documenti, dall'upgrade
        // framework del 27/06, filtrano su `anagrafica_indirizzi.id` e leggono
        // l'indirizzo inline da quella tabella.

        // Fix 2026-07-31 (Polisportiva Masi): questa funzione è l'unico punto in cui i vari flussi
        // di emissione (checkout app, cassa, coupon, controller finally dei moduli) risolvono le
        // sedi del documento, quindi è qui che va tolta la causa a monte di "richiesto indirizzo
        // sede destinatario". Il difetto della query storica sotto: guarda SOLO `id_ruolo IN (1,4)`
        // e non verifica che l'indirizzo sia completo di comune, mentre la query di stampa
        // (_mod/_0400.documenti/_src/_lib/_mysql.utils.add.php) pretende la catena comune →
        // provincia → regione → stato. Risultato: o NULL (indirizzo con ruolo diverso) o un
        // puntatore a una riga che la stampa non sa rendere — in entrambi i casi ricevuta bloccata.
        //
        // `documentoIdSedeStampabile()` (mod/0400.documenti/src/lib/pdf.tools.add.php) applica gli
        // stessi INNER JOIN della stampa, preferendo comunque i ruoli 1/4. È in un modulo di
        // progetto, quindi il function_exists() non è cosmetico: se il modulo documenti non è
        // attivo — o se un upgrade del framework fa sparire il placeholder che ne carica la
        // libreria — si torna semplicemente al comportamento storico, senza errori fatali.
        //
        // NB: modifica a un file FRAMEWORK, sarà persa al prossimo `_gw.upgrade.sh`. Perderla
        // rimette i NULL in emissione ma non rompe le stampe: la riparazione al volo vive in
        // `src/config/605.common.php` + `mod/0400.documenti/src/lib/pdf.tools.add.php`, che
        // l'upgrade non tocca.
        if( function_exists( 'documentoIdSedeStampabile' ) ) {

            $idSedeStampabile = documentoIdSedeStampabile( $idAnagrafica );

            if( ! empty( $idSedeStampabile ) ) {
                return $idSedeStampabile;
            }

        }

        return mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT id
                FROM anagrafica_indirizzi
                WHERE id_anagrafica = ?
                AND anagrafica_indirizzi.id_ruolo IN ( 1, 4 )
                LIMIT 1',
            array(array('s' => $idAnagrafica))
        );
    }

    /**
     * FUNZIONI PER GLI INDIRIZZI DELLE ANAGRAFICHE
     */

    /**
     * verifica se `anagrafica_indirizzi` porta la copia inline dell'indirizzo
     *
     * Dalla migrazione del 2026-07-10 `anagrafica_indirizzi` contiene l'indirizzo per esteso
     * ( id_tipologia, indirizzo, civico, id_comune, localita, cap, coordinate ) e diventa la
     * fonte canonica: le query di lettura del modulo documenti filtrano su
     * `anagrafica_indirizzi.id` e leggono l'indirizzo da lì, e `documenti.id_sede_emittente` /
     * `id_sede_destinatario` hanno la chiave esterna su `anagrafica_indirizzi` invece che su
     * `indirizzi`. Le due cose sono lo stesso passaggio e si applicano insieme.
     *
     * `indirizzi` non viene abbandonata: resta la tabella degli indirizzi deduplicati,
     * referenziata da una quindicina di altre tabelle ( luoghi, progetti, edifici, todo,
     * zone_indirizzi, ... ), e `anagrafica_indirizzi.id_indirizzo` continua a collegarla.
     *
     * Non tutti i deploy hanno fatto il passaggio: su quelli fermi allo schema precedente le
     * colonne inline non esistono e qualunque query che le nomini muore con un 1054. Questa
     * funzione dice quale dei due schemi si ha davanti — una volta sola per richiesta — così
     * chi la interroga può ripiegare sulla forma storica invece di rompersi.
     *
     * @return      boolean     vero se lo schema è quello canonico
     */
    function anagraficaIndirizziInline()
    {

        global $cf;

        static $inline = null;

        if ($inline === null) {

            $colonne = mysqlQuery(
                $cf['mysql']['connection'],
                "SHOW COLUMNS FROM anagrafica_indirizzi LIKE 'id_comune'"
            );

            $inline = ! empty($colonne);
        }

        return $inline;
    }

    /**
     * allinea la copia inline dell'indirizzo sulle righe di `anagrafica_indirizzi` che lo collegano
     *
     * Il form dell'anagrafica scrive il sotto-modulo degli indirizzi su `indirizzi`, con
     * `anagrafica_indirizzi.id_indirizzo` come collegamento, mentre le query di lettura e di
     * stampa leggono la copia inline: senza questa propagazione la copia resterebbe ferma
     * all'ultimo allineamento e un documento emesso dopo una correzione mostrerebbe il dato
     * vecchio. Un indirizzo può essere collegato da più righe ( conviventi, sedi condivise ),
     * quindi si aggiornano tutte quelle che lo citano.
     *
     * È la funzione che i punti di chiamata del framework cercano da tempo con
     * `function_exists()`: il job di importazione delle anagrafiche, il finally del checkout e
     * il task di normalizzazione degli indirizzi. Fino al suo ingresso nello standard esisteva
     * come personalizzazione di un solo deploy, e altrove quelle chiamate non facevano niente.
     *
     * Attenzione: `anagrafica_indirizzi` ha la chiave unica ( id_anagrafica, indirizzo ), quindi
     * riempire la copia inline può far collidere due righe della stessa anagrafica che puntano a
     * indirizzi diversi ma con la stessa via. È un problema di qualità del dato e va riconciliato
     * a mano: qui l'UPDATE fallisce e la copia resta indietro, senza toccare nient'altro.
     *
     * @param       integer     $idIndirizzo    chiave di `indirizzi` da propagare
     */
    function sincronizzaIndirizzoInline($idIndirizzo)
    {

        global $cf;

        if (empty($idIndirizzo) || ! anagraficaIndirizziInline()) {
            return;
        }

        mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE anagrafica_indirizzi ai
                INNER JOIN indirizzi i ON i.id = ai.id_indirizzo
                SET ai.id_tipologia                = i.id_tipologia,
                    ai.indirizzo                   = i.indirizzo,
                    ai.civico                      = i.civico,
                    ai.id_comune                   = i.id_comune,
                    ai.localita                    = i.localita,
                    ai.cap                         = i.cap,
                    ai.latitudine                  = i.latitudine,
                    ai.longitudine                 = i.longitudine,
                    ai.token                       = i.token,
                    ai.timestamp_geolocalizzazione = i.timestamp_geolocalizzazione
                WHERE ai.id_indirizzo = ?',
            array(array('s' => $idIndirizzo))
        );
    }

    /**
     * tendina delle sedi di un'anagrafica, nella forma che la colonna di destinazione si aspetta
     *
     * Le tendine `id_sedi_emittente` e `id_sedi_destinatario` delle schede documento alimentano
     * `documenti.id_sede_emittente` e `documenti.id_sede_destinatario`: l'identificativo da
     * proporre è quindi quello che quelle colonne referenziano, e dalla migrazione del 2026-07-10
     * è `anagrafica_indirizzi.id`, non più `indirizzi.id`. Proporre l'altro vuol dire scrivere una
     * sede che la query di stampa non risolve — il documento esce con "richiesto indirizzo sede
     * destinatario" — o violare la chiave esterna.
     *
     * Sui deploy fermi allo schema precedente si ripiega sull'elenco storico, che restituisce
     * `indirizzi.id`, cioè quello che lì la colonna referenzia davvero.
     *
     * @param       integer     $idAnagrafica   anagrafica di cui elencare le sedi
     * @return      array                       righe id / __label__ per la tendina
     */
    function tendinaSediAnagrafica($idAnagrafica)
    {

        global $cf;

        if (empty($idAnagrafica)) {
            return array();
        }

        if (anagraficaIndirizziInline()) {

            return mysqlCachedIndexedQuery(
                $cf['memcache']['index'],
                $cf['memcache']['connection'],
                $cf['mysql']['connection'],
                'SELECT id, __label__ FROM anagrafica_indirizzi_view WHERE id_anagrafica = ?',
                array(array('s' => $idAnagrafica))
            );
        }

        return mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT indirizzi_view.id, __label__ FROM indirizzi_view '.
            'LEFT JOIN anagrafica_indirizzi ON anagrafica_indirizzi.id_indirizzo = indirizzi_view.id '.
            'WHERE anagrafica_indirizzi.id_anagrafica = ?',
            array(array('s' => $idAnagrafica))
        );
    }

    /**
     * FUNZIONI PER IL POPOLAMENTO DELLE PAGINE
     */

    /**
     * aggiunge a una pagina le immagini collegate a un oggetto
     *
     * Questa funzione è una scorciatoia per aggiungiDati() con la tabella immagini: le immagini finiscono in
     * $p['contents']['images'][ ruolo ][ ordine ].
     *
     * @param       array       $p      l'array della pagina, modificato sul posto
     * @param       string      $id     l'ID dell'oggetto a cui sono collegate le immagini
     * @param       string      $f      la colonna di immagini che punta all'oggetto ( es. id_pagina )
     * @param       array       $r      gli ID dei ruoli da includere, o NULL per tutti
     *
     * @return      void
     *
     */
    function aggiungiImmagini(&$p, $id, $f, $r = null)
    {

        aggiungiDati($p, $id, $f, 'immagini', $r);
    }

    /**
     * aggiunge a una pagina i video collegati a un oggetto
     *
     * Questa funzione è una scorciatoia per aggiungiDati() con la tabella video: i video finiscono in
     * $p['contents']['video'][ ruolo ][ ordine ].
     *
     * @param       array       $p      l'array della pagina, modificato sul posto
     * @param       string      $id     l'ID dell'oggetto a cui sono collegati i video
     * @param       string      $f      la colonna di video che punta all'oggetto ( es. id_pagina )
     * @param       array       $r      gli ID dei ruoli da includere, o NULL per tutti
     *
     * @return      void
     *
     */
    function aggiungiVideo(&$p, $id, $f, $r = null)
    {

        aggiungiDati($p, $id, $f, 'video', $r);
    }

    /**
     * aggiunge a una pagina gli audio collegati a un oggetto
     *
     * Questa funzione è una scorciatoia per aggiungiDati() con la tabella audio: gli audio finiscono in
     * $p['contents']['audio'][ ruolo ][ ordine ], che è dove li cerca _src/_html/_bin/_default.html. Non ha chiamanti.
     *
     * NOTA lo schema standard in _usr/_database non crea più le tabelle audio e ruoli_audio ( tolte nel riallineamento
     * d975b4a15 del 2026-03-02 ): la funzione serve sui deploy che le hanno ancora, altrove la query fallisce.
     *
     * @param       array       $p      l'array della pagina, modificato sul posto
     * @param       string      $id     l'ID dell'oggetto a cui sono collegati gli audio
     * @param       string      $f      la colonna di audio che punta all'oggetto ( es. id_pagina )
     * @param       array       $r      gli ID dei ruoli da includere, o NULL per tutti
     *
     * @return      void
     *
     */
    function aggiungiAudio(&$p, $id, $f, $r = null)
    {

        aggiungiDati($p, $id, $f, 'audio', $r);
    }

    /**
     * aggiunge a una pagina i file collegati a un oggetto
     *
     * Questa funzione è una scorciatoia per aggiungiDati() con la tabella file: i file finiscono in
     * $p['contents']['files'][ ruolo ][ ordine ].
     *
     * @param       array       $p      l'array della pagina, modificato sul posto
     * @param       string      $id     l'ID dell'oggetto a cui sono collegati i file
     * @param       string      $f      la colonna di file che punta all'oggetto ( es. id_pagina )
     * @param       array       $r      gli ID dei ruoli da includere, o NULL per tutti
     *
     * @return      void
     *
     */
    function aggiungiFile(&$p, $id, $f, $r = null)
    {

        aggiungiDati($p, $id, $f, 'file', $r);
    }

    /**
     * aggiunge a una pagina le recensioni approvate di un oggetto
     *
     * Questa funzione legge dalla tabella recensioni quelle collegate all'oggetto nella lingua indicata e approvate
     * ( se_approvata non NULL ) e le scrive in $p['contents']['recensioni'], sostituendo quello che c'era. Se non ce ne
     * sono la chiave vale un array vuoto, se la query fallisce false.
     *
     * @param       array       $p      l'array della pagina, modificato sul posto
     * @param       string      $id     l'ID dell'oggetto recensito
     * @param       string      $f      la colonna di recensioni che punta all'oggetto ( es. id_pagina )
     * @param       int         $l      l'ID della lingua delle recensioni ( default 1 )
     *
     * @return      void
     *
     */
    function aggiungiRecensioni(&$p, $id, $f, $l = 1)
    {

        global $cf;

        $p['contents']['recensioni'] = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT recensioni.* FROM recensioni WHERE ' . $f . ' = ? AND id_lingua = ? AND se_approvata IS NOT NULL',
            array(
                array('s' => $id),
                array('s' => $l)
            )
        );
    }

    /**
     * aggiunge a una pagina i media collegati a un oggetto
     *
     * Questa funzione legge dalla tabella $t ( immagini, video, audio o file ) le righe collegate all'oggetto tramite la
     * colonna $f, insieme ai loro contenuti e metadati in tutte le lingue, e le scrive in
     * $p['contents'][ chiave ][ ruolo ][ ordine ], dove la chiave è images, video, audio o files e ruolo è il nome del ruolo
     * del media. Ogni elemento ha id, nome, path, mimetype, i testi ( title, h1, h2, h3, testo, cappello ) indicizzati per
     * lingua e i metadati, più taglio, path_alternativo e orientamento per le immagini e codice_embed e id_embed per video
     * e audio. Siccome la query restituisce una riga per ogni combinazione di contenuto e metadato, le righe dello stesso
     * media vengono fuse con array_replace_recursive(), e lo stesso avviene con un elemento già presente nella pagina nella
     * stessa posizione. Se $r non è NULL vengono inclusi solo i media con uno dei ruoli indicati.
     *
     * NOTA la colonna $f e gli ID dei ruoli in $r vengono scritti direttamente nella query, quindi non devono mai arrivare
     * dall'esterno.
     *
     * @param       array       $p      l'array della pagina, modificato sul posto
     * @param       string      $id     l'ID dell'oggetto a cui sono collegati i media
     * @param       string      $f      la colonna della tabella dei media che punta all'oggetto ( es. id_pagina )
     * @param       string      $t      la tabella dei media: immagini, video, audio o file
     * @param       array       $r      gli ID dei ruoli da includere, o NULL per tutti
     *
     * @return      void
     *
     */
    function aggiungiDati(&$p, $id, $f, $t, $r = null)
    {

        global $cf;

        switch ($t) {
            case 'immagini':
                #                $tc = 'immagini.orientamento, immagini.taglio, immagini.anno, immagini.path_alternativo FROM immagini ';
                $tc = 'immagini.orientamento, immagini.taglio, immagini.path_alternativo FROM immagini ';
                $tf = 'id_immagine';
                $tk = 'images';
                break;
            case 'video':
                $tc = 'video.id_embed, video.codice_embed FROM video ';
                $tf = 'id_video';
                $tk = 'video';
                break;
            case 'audio':
                // sul modello del video: la tabella audio ha le stesse colonne di embed ( 2026-09-24 )
                $tc = 'audio.id_embed, audio.codice_embed FROM audio ';
                $tf = 'id_audio';
                $tk = 'audio';
                break;
            case 'file':
                $tc = 'file.url FROM file ';
                $tf = 'id_file';
                $tk = 'files';
                break;
        }

        $cnt = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT contenuti.title, contenuti.h1, contenuti.h2, contenuti.h3, ' .
                'contenuti.testo, contenuti.cappello, lingue.ietf, main_lingue.ietf AS main_ietf, ' .
                'metadati.nome AS meta_nome, metadati.testo AS meta_testo, meta_lingue.ietf AS meta_ietf, ' .
                'ruoli_' . $t . '.nome AS ruolo, ' . $t . '.id, ' .
                $t . '.ordine, ' . $t . '.nome, ' . $t . '.path, ' . $tc .
                'LEFT JOIN ruoli_' . $t . ' ON ruoli_' . $t . '.id = ' . $t . '.id_ruolo ' .
                'LEFT JOIN contenuti ON contenuti.' . $tf . ' = ' . $t . '.id ' .
                'LEFT JOIN lingue ON lingue.id = contenuti.id_lingua ' .
                'LEFT JOIN lingue AS main_lingue ON main_lingue.id = ' . $t . '.id_lingua ' .
                'LEFT JOIN metadati ON metadati.' . $tf . ' = ' . $t . '.id ' .
                'LEFT JOIN lingue AS meta_lingue ON meta_lingue.id = metadati.id_lingua ' .
                'WHERE ' . $t . '.' . $f . ' = ? ' .
                (($r !== null) ? 'AND ruoli_' . $t . '.id IN (' . implode(',', $r) . ')' : null),
            array(
                array('s' => $id)
            )
        );

        foreach ($cnt as $cn) {

            $im = array(
                'id'                => $cn['id'],
                'nome'              => $cn['nome'],
                'path'              => (empty($cn['main_ietf'])) ? $cn['path'] : array($cn['main_ietf'] => $cn['path']),
                #    'mimetype'          => findFileType( ( empty( $cn['main_ietf'] ) ) ? $cn['path'] : array( $cn['main_ietf'] => $cn['path'] ) ),     // commentata questa riga, sostituita con la seguente
                'mimetype'          => (empty($cn['main_ietf'])) ? findFileType($cn['path']) : array($cn['main_ietf'] => findFileType($cn['path'])),      // vedere issue #419
                'title'                => array($cn['ietf']    => $cn['title']),
                'h1'                => array($cn['ietf']    => $cn['h1']),
                'h2'                => array($cn['ietf']    => $cn['h2']),
                'h3'                => array($cn['ietf']    => $cn['h3']),
                'testo'                => array($cn['ietf']    => $cn['testo']),
                'cappello'            => array($cn['ietf']    => $cn['cappello']),
                'metadati'          => (
                    (empty($cn['meta_ietf'])) ?
                    array($cn['meta_nome'] => $cn['meta_testo']) :
                    array($cn['meta_nome'] => array($cn['meta_ietf'] => $cn['meta_testo']))
                )
            );

            switch ($t) {
                case 'immagini':
                    $im = array_replace_recursive($im, array(
                        'taglio'            => $cn['taglio'],
                        'path_alternativo'  => (empty($cn['main_ietf'])) ? $cn['path_alternativo'] : array($cn['main_ietf'] => $cn['path_alternativo']),
                        #    'mimetype'          => findFileType( ( empty( $cn['main_ietf'] ) ) ? $cn['path_alternativo'] : array( $cn['main_ietf'] => $cn['path_alternativo'] ) ),     // commentata questa riga, sostituita con la seguente
                        // 'mimetype'          => (empty($cn['main_ietf'])) ? findFileType($cn['path_alternativo']) : array($cn['main_ietf'] => findFileType($cn['path_alternativo'])),      // vedere issue #419
                        'orientamento'      => $cn['orientamento']
                        #   'anno'              => $cn['anno']
                    ));
                    break;
                case 'audio':
                case 'video':
                    $im = array_replace_recursive($im, array(
                        'codice_embed'            => $cn['codice_embed'],
                        'id_embed'              => $cn['id_embed']
                    ));
                    break;
            }

            if (isset($p['contents'][$tk][$cn['ruolo']][$cn['ordine']])) {
                $p['contents'][$tk][$cn['ruolo']][$cn['ordine']] = array_replace_recursive(
                    $p['contents'][$tk][$cn['ruolo']][$cn['ordine']],
                    $im
                );
            } else {
                $p['contents'][$tk][$cn['ruolo']][$cn['ordine']] = $im;
            }
        }
    }


    /**
     * aggiunge a una pagina le macro collegate a un oggetto
     *
     * Questa funzione legge dalla tabella macro quelle collegate all'oggetto e le mette in $p['macro'], davanti a quelle
     * eventualmente già presenti.
     *
     * @param       array       $p      l'array della pagina, modificato sul posto
     * @param       string      $id     l'ID dell'oggetto
     * @param       string      $f      la colonna di macro che punta all'oggetto ( es. id_pagina )
     *
     * @return      void
     *
     */
    function aggiungiMacro(&$p, $id, $f)
    {

        global $cf;

        $p['macro'] = array_merge(
            mysqlSelectColumn(
                'macro',
                $cf['mysql']['connection'],
                'SELECT macro FROM macro ' .
                    'WHERE ' . $f . ' = ?',
                array(
                    array('s' => $id)
                )
            ),
            ((isset($p['macro'])) ?  $p['macro'] : array())
        );
    }

    /**
     * aggiunge a una pagina le voci di menu collegate a un oggetto
     *
     * Questa funzione legge dalla tabella menu le voci collegate all'oggetto e le fonde in $p['menu'][ menu ][ ancora ],
     * con l'etichetta indicizzata per lingua, le sottopagine, l'ancora, il target e l'ordine come priority. Righe della
     * stessa voce in lingue diverse vengono fuse.
     *
     * @param       array       $p      l'array della pagina, modificato sul posto
     * @param       string      $id     l'ID dell'oggetto
     * @param       string      $f      la colonna di menu che punta all'oggetto ( es. id_pagina )
     *
     * @return      void
     *
     */
    function aggiungiMenu(&$p, $id, $f)
    {

        global $cf;

        $mnu = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT menu.*, lingue.ietf FROM menu ' .
                'INNER JOIN lingue ON lingue.id = menu.id_lingua ' .
                'WHERE ' . $f . ' = ?',
            array(
                array('s' => $id)
            )
        );

        foreach ($mnu as $mn) {
            $p = array_replace_recursive(
                $p,
                array(
                    'menu'    => array(
                        $mn['menu']    => array(
                            $mn['ancora'] => array(
                                'label'        => array($mn['ietf'] => $mn['nome']),
                                'subpages'    => $mn['sottopagine'],
                                'ancora'    => (isset($mn['ancora'])) ? $mn['ancora'] : NULL,
                                'target'    => (isset($mn['target'])) ? $mn['target'] : NULL,
                                'priority'    => $mn['ordine']
                            )
                        )
                    )
                )
            );
        }
    }

    /**
     * aggiunge a una pagina le caratteristiche di un oggetto
     *
     * Questa funzione legge dalla tabella di relazione $t le caratteristiche dell'oggetto nella lingua indicata e le scrive
     * in $p['contents']['caratteristiche'][ ordine ] come coppia nome => valore; il nome è il testo tradotto della
     * caratteristica nella lingua, o in mancanza il suo nome. Due caratteristiche con lo stesso ordine si sovrascrivono.
     *
     * @param       array       $p      l'array della pagina, modificato sul posto
     * @param       string      $id     l'ID dell'oggetto
     * @param       string      $t      la tabella di relazione ( es. prodotti_caratteristiche )
     * @param       string      $f      la colonna di $t che punta all'oggetto ( es. id_prodotto )
     * @param       int         $l      l'ID della lingua ( default 1 )
     *
     * @return      void
     *
     */
    function aggiungiCaratteristiche(&$p, $id, $t, $f, $l = 1)
    {

        global $cf;

        $caratteristiche = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT ' . $t . '.ordine, coalesce( contenuti.testo, caratteristiche.nome ) AS caratteristica, ' . $t . '.valore FROM ' . $t . ' ' .
                'LEFT JOIN caratteristiche ON caratteristiche.id = ' . $t . '.id_caratteristica ' .
                'LEFT JOIN contenuti ON contenuti.id_caratteristica = caratteristiche.id AND contenuti.id_lingua = ? ' .
                'WHERE ' . $t . '.' . $f . ' = ? AND ' . $t . '.id_lingua = ? ',
            array(
                array('s' => $l),
                array('s' => $id),
                array('s' => $l)
            )
        );

        // print_r( $caratteristiche );

        foreach ($caratteristiche as $caratteristica) {

            $p['contents']['caratteristiche'][$caratteristica['ordine']] = array(
                $caratteristica['caratteristica'] => $caratteristica['valore']
            );
        }
    }

    /**
     * aggiunge a una pagina i metadati collegati a un oggetto
     *
     * Questa funzione legge dalla tabella metadati quelli collegati all'oggetto, li trasforma con
     * metadati2associativeArray() e li fonde in $p['metadati'], creandolo se non c'è.
     *
     * @param       array       $p      l'array della pagina, modificato sul posto
     * @param       string      $id     l'ID dell'oggetto
     * @param       string      $f      la colonna di metadati che punta all'oggetto ( es. id_pagina )
     *
     * @return      void
     *
     */
    function aggiungiMetadati(&$p, $id, $f)
    {

        global $cf;

        $meta = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT metadati.*, lingue.ietf FROM metadati ' .
                'LEFT JOIN lingue ON lingue.id = metadati.id_lingua ' .
                'WHERE ' . $f . ' = ?',
            array(
                array('s' => $id)
            )
        );

        // print_r( $meta );

        #        foreach( $meta as $mta ) {
        /*
                if( empty( $mta['ietf'] ) ) {
                    $p['metadati'][ $mta['nome'] ] = $mta['testo'];
                } else {
                    $p['metadati'][ $mta['nome'] ][ $mta['ietf'] ] = $mta['testo'];
                }
    */
        #                $p['metadati'] = array_replace_recursive(
        #                    $p['metadati'],
        #                    metadati2associativeArray( $mta )
        #                );

        if (isset(($p['metadati'])) && is_array($p['metadati'])) {

            $p['metadati'] = array_replace_recursive(
                $p['metadati'],
                metadati2associativeArray($meta)
            );
        } else {

            $p['metadati'] = metadati2associativeArray($meta);
        }

        #        }

    }

    /**
     * aggiunge a una pagina i gruppi autorizzati a vederla
     *
     * Questa funzione legge dalla tabella delle ACL $t ( di default __acl_pagine__ ) i nomi dei gruppi associati
     * all'oggetto tramite la colonna $f e, se ce ne sono, li scrive in $p['auth']['groups'] sostituendo quelli presenti;
     * se non ce ne sono la pagina resta com'è.
     *
     * NOTA il default di $f era id_pagina, colonna che le tabelle __acl_*__ non hanno: finché $f e $t erano ignorati non
     * contava, ora il default è id_entita, la colonna che la query ha sempre usato ( 2026-09-24 ). La tabella e la colonna
     * vengono scritte direttamente nella query, quindi non devono mai arrivare dall'esterno.
     *
     * @param       array       $p      l'array della pagina, modificato sul posto
     * @param       string      $id     l'ID dell'oggetto
     * @param       string      $f      la colonna di $t che punta all'oggetto ( default id_entita )
     * @param       string      $t      la tabella delle ACL ( default __acl_pagine__ )
     *
     * @return      void
     *
     */
    function aggiungiGruppi(&$p, $id, $f = 'id_entita', $t = '__acl_pagine__')
    {

        // TODO l'assetto dei gruppi cambierà, probabilmente per usare le ACL

        global $cf;

        $groups = mysqlSelectColumn(
            'nome',
            $cf['mysql']['connection'],
            'SELECT gruppi.nome FROM gruppi ' .
                'INNER JOIN ' . $t . ' ON gruppi.id = ' . $t . '.id_gruppo ' .
                'WHERE ' . $t . '.' . $f . ' = ?',
            array(
                array('s' => $id)
            )
        );

        if (! empty($groups)) {
            $p['auth']['groups']    = $groups;
        }
    }

    /**
     * aggiunge a una pagina i contenuti testuali collegati a un oggetto
     *
     * Questa funzione legge dalla tabella contenuti le righe collegate all'oggetto e fonde nella pagina, indicizzati per
     * lingua, i percorsi personalizzati ( short, forced, custom ), i testi ( title, cappello, h1, h2, h3 ) e i dati Open
     * Graph ( og_* ). I valori già presenti nella pagina per la stessa lingua vengono sovrascritti.
     *
     * @param       array       $p      l'array della pagina, modificato sul posto
     * @param       string      $id     l'ID dell'oggetto
     * @param       string      $f      la colonna di contenuti che punta all'oggetto ( es. id_pagina )
     *
     * @return      void
     *
     */
    function aggiungiContenuti(&$p, $id, $f)
    {

        global $cf;

        $cnt = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT contenuti.*, lingue.ietf FROM contenuti ' .
                'INNER JOIN lingue ON lingue.id = contenuti.id_lingua ' .
                'WHERE ' . $f . ' = ?',
            array(
                array('s' => $id)
            )
        );

        foreach ($cnt as $cn) {
            $p = array_replace_recursive(
                $p,
                array(
                    'short'             => array($cn['ietf']    => $cn['path_custom']),
                    'forced'            => array($cn['ietf']    => $cn['url_custom']),
                    'custom'            => array($cn['ietf']    => $cn['rewrite_custom']),
                    'title'                => array($cn['ietf']    => $cn['title']),
                    'cappello'            => array($cn['ietf']    => $cn['cappello']),
                    'h1'                => array($cn['ietf']    => $cn['h1']),
                    'h2'                => array($cn['ietf']    => $cn['h2']),
                    'h3'                => array($cn['ietf']    => $cn['h3']),
                    'og_type'            => array($cn['ietf']    => $cn['og_type']),
                    'og_title'            => array($cn['ietf']    => $cn['og_title']),
                    'og_image'            => array($cn['ietf']    => $cn['og_image']),
                    'og_audio'            => array($cn['ietf']    => $cn['og_audio']),
                    'og_video'            => array($cn['ietf']    => $cn['og_video']),
                    'og_description'    => array($cn['ietf']    => $cn['og_description']),
                    'og_determiner'     => array($cn['ietf']    => $cn['og_determiner'])
                )
            );
        }
    }

    /**
     * FUNZIONI DI SERVIZIO PER I TASK
     */

    /**
     * sospende i trigger lazy di un'entità per la connessione corrente
     *
     * Questa funzione imposta a 1 la variabile di sessione MySQL @TRIGGER_LAZY_<ENTITA>, pensata per essere controllata dai
     * trigger del database così che saltino le elaborazioni pesanti durante le operazioni massive; la variabile vale solo
     * per la connessione corrente. Il task viene usato solo per il log.
     *
     * NOTA al momento la funzione non ha chiamanti nel framework e nessun trigger dello schema standard
     * ( _usr/_database/_patch/ ) legge queste variabili.
     *
     * @param       string      $entita     il nome dell'entità ( viene convertito in maiuscolo )
     * @param       string      $task       il nome del task che chiede lo spegnimento, per il log
     *
     * @return      void
     *
     */
    function triggerOff($entita, $task = NULL)
    {

        global $cf;

        logWrite('richiesto spegnimento trigger per ' . $entita . ' da task ' . $task, 'cron');

        #    logWrite( 'spengo i trigger per ' . $entita, 'cron' );

        $troff = mysqlQuery(
            $cf['mysql']['connection'],
            'SET @TRIGGER_LAZY_' . strtoupper($entita) . ' = 1'
        );
    }

    /**
     * riattiva i trigger lazy di un'entità per la connessione corrente
     *
     * Questa funzione riporta a NULL la variabile di sessione MySQL @TRIGGER_LAZY_<ENTITA> impostata da triggerOff().
     *
     * @param       string      $entita     il nome dell'entità ( viene convertito in maiuscolo )
     *
     * @return      void
     *
     */
    function triggerOn($entita)
    {

        global $cf;

        logWrite('accendo i trigger per ' . $entita, 'cron');

        $tron = mysqlQuery(
            $cf['mysql']['connection'],
            'SET @TRIGGER_LAZY_' . strtoupper($entita) . ' = NULL'
        );
    }

    /**
     * restituisce la tabella referenziata da una colonna con chiave esterna
     *
     * Questa funzione cerca in information_schema la chiave esterna definita sulla colonna $f della tabella $t e
     * restituisce il nome della tabella a cui punta, con la cache su memcache; se non c'è restituisce NULL. L'unico
     * chiamante nel framework è commentato. $t e $f sono passati come parametri del prepared statement ( fino al
     * 2026-09-24 venivano concatenati nella query senza apici, e MySQL li leggeva come nomi di colonna ).
     *
     * @param       string      $t      il nome della tabella
     * @param       string      $f      il nome della colonna
     *
     * @return      mixed               il nome della tabella referenziata, o NULL
     *
     */
    function trovaTabellaDestinazioneConstraint($t, $f)
    {

        global $cf;

        return mysqlSelectCachedValue(
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT referenced_table_name ' .
                'FROM information_schema.key_column_usage ' .
                'WHERE table_name = ? AND table_schema = database() ' .
                'AND referenced_table_name IS NOT NULL AND column_name = ?',
            array(
                array('s' => $t),
                array('s' => $f)
            )
        );
    }

    /**
     * trova la prossima riga di una tabella da elaborare e la marca come elaborata
     *
     * Questa funzione è pensata per i task che elaborano una riga per chiamata ( sincronizzazioni, importazioni ). La riga
     * viene scelta così:
     *
     * -# se $q['id'] è impostato, la riga con quell'ID;
     * -# se $q['f'] è impostato, la riga con il timestamp $f1 più vecchio, qualunque sia;
     * -# altrimenti la riga con il timestamp $f1 più vecchio fra quelle con $f1 NULL, precedente a $f2 ( modificate dopo
     *    l'ultima elaborazione ) o più vecchio di due giorni, applicando anche le condizioni extra $e.
     *
     * Se trova una riga ne imposta $f1 all'ora corrente e la restituisce; in $o accoda un paragrafo HTML che dice quale
     * dei tre casi è stato usato. Se non trova niente restituisce un array vuoto.
     *
     * NOTA il messaggio del terzo caso parla di "un corso da importare", residuo del task da cui la funzione è nata. Non ha
     * chiamanti nel framework.
     *
     * @param       object      $c      la connessione mysqli
     * @param       string      $t      il nome della tabella
     * @param       array       $q      i parametri della richiesta ( di solito $_REQUEST ), di cui si guardano id e f
     * @param       string      $f1     la colonna col timestamp dell'ultima elaborazione ( default timestamp_sincronizzazione )
     * @param       string      $f2     la colonna col timestamp dell'ultima modifica ( default timestamp_aggiornamento )
     * @param       string      $o      la stringa di output a cui accodare il messaggio, modificata sul posto
     * @param       array       $e      le condizioni SQL extra, unite in AND, per il terzo caso
     *
     * @return      array               la riga da elaborare, o un array vuoto se non ce ne sono
     *
     */
    function trovaRigaDaElaborare($c, $t, $q, $f1 = 'timestamp_sincronizzazione', $f2 = 'timestamp_aggiornamento', &$o = NULL, $e = array())
    {

        // default
        $r = NULL;

        // condizioni extra
        if (! empty($e)) {
            $ew = ' AND ' . implode(' AND ', $e);
        } else {
            $ew = NULL;
        }

        // ricerca di un elemento con timestamp_aggiornamento > timestamp_sincronizzazione in ordine di timestamp_aggiornamento
        if (isset($q['id'])) {

            // recupero dati
            $r    = mysqlSelectRow(
                $c,
                'SELECT ' . $t . '.* FROM ' . $t . '
                    WHERE ' . $t . '.id = ?',
                array(
                    array('s' => $q['id'])
                )
            );

            // output
            $o .= '<p>elemento da importare specificato</p>';
        } elseif (isset($q['f'])) {

            // recupero dati
            $r    = mysqlSelectRow(
                $c,
                'SELECT ' . $t . '.* FROM ' . $t . '
                    ORDER BY ' . $t . '.' . $f1 . ' ASC, ' . $t . '.id ASC LIMIT 1'
            );

            // output
            $o .= '<p>ricerca forzata di un elemento da importare</p>';
        } else {

            // recupero dati
            $r    = mysqlSelectRow(
                $c,
                'SELECT ' . $t . '.* FROM ' . $t . '
                    WHERE ( ' . $t . '.' . $f1 . ' < ' . $t . '.' . $f2 . '
                    OR ' . $t . '.' . $f1 . ' < ?
                    OR ' . $t . '.' . $f1 . ' IS NULL ) ' . $ew . '
                    ORDER BY ' . $t . '.' . $f1 . ' ASC, ' . $t . '.id ASC LIMIT 1',
                array(array('s' => strtotime('-2 days')))
            );

            // output
            $o .= '<p>ricerca di un corso da importare</p>';
        }

        // aggiornamento timestamp di importazione
        if (! empty($r['id'])) {
            mysqlQuery(
                $c,
                'UPDATE ' . $t . ' SET ' . $f1 . ' = ? WHERE id = ?',
                array(
                    array('s' => time()),
                    array('s' => $r['id'])
                )
            );
        }

        return $r;
    }

    /**
     * FUNZIONI DI INSERIMENTO E UNIONE
     */

    /**
     * scompone un indirizzo in forma libera e lo inserisce nella tabella indirizzi
     *
     * Questa funzione prende un indirizzo scritto per esteso ( es. "via Roma 12/b" ) e ne ricava la tipologia ( cercando
     * all'inizio uno dei nomi di tipologie_indirizzi ), il civico ( la parte finale che comincia con una cifra ) e la
     * parte nominale, che viene capitalizzata rimettendo in maiuscolo gli eventuali numeri romani. Se l'ID del comune non
     * è passato lo cerca prima dal CAP, fra gli indirizzi già presenti, e poi per nome e provincia; l'ID della provincia,
     * se non passato, viene preso dal comune trovato per CAP o cercato per sigla o nome. Infine inserisce la riga con
     * mysqlInsertRow(), che in caso di duplicato su una chiave unica aggiorna la riga esistente, e ne restituisce l'ID. Se
     * tutti i dati testuali sono vuoti restituisce NULL senza toccare il database.
     *
     * NOTA $stato e $idStato sono accettati ma non usati. Se l'indirizzo non contiene un civico $matches[0] non esiste e
     * il civico vale NULL con un warning. La ricerca per CAP prende il comune del primo indirizzo trovato, quindi con un CAP
     * condiviso da più comuni può scegliere quello sbagliato; i nomi delle tipologie entrano nell'espressione regolare
     * senza preg_quote().
     *
     * @param       string      $indirizzo      l'indirizzo per esteso, con tipologia e civico
     * @param       string      $cap            il CAP
     * @param       string      $comune         il nome del comune
     * @param       string      $provincia      la sigla o il nome della provincia
     * @param       string      $localita       la località ( facoltativa )
     * @param       string      $stato          lo stato ( non usato )
     * @param       int         $idComune       l'ID del comune, se già noto
     * @param       int         $idProvincia    l'ID della provincia, se già noto
     * @param       int         $idStato        l'ID dello stato ( non usato )
     *
     * @return      mixed                       l'ID dell'indirizzo inserito, NULL se i dati sono vuoti, false in caso di errore
     *
     */
    function inserisciIndirizzo($indirizzo, $cap, $comune, $provincia, $localita = NULL, $stato = NULL, $idComune = NULL, $idProvincia = NULL, $idStato = NULL)
    {
        // Fix 2026-05-29: evita strtolower(null)/trim(null) (PHP 8) e righe indirizzi vuote quando manca la residenza
        $indirizzo = (string) $indirizzo;
        $cap       = (string) $cap;
        $comune    = (string) $comune;
        $provincia = (string) $provincia;
        $localita  = (string) $localita;
        $stato     = (string) $stato;
        if( '' === $indirizzo . $cap . $comune . $provincia . $localita . $stato ) return null;


        // dati globali
        global $cf;

        // pulisco gli spazi ai lati
        $indirizzo = trim(strtolower($indirizzo));

        // elenco tipologie
        $regexp = '/^\b(' . implode('|', mysqlSelectColumn('nome', $cf['mysql']['connection'], 'SELECT nome FROM tipologie_indirizzi')) . ')\b/';

        // trovo la tipologia
        preg_match($regexp, $indirizzo, $matches);
        $tipologia = (count($matches) > 0) ? $matches[0] : NULL;

        // debug
        // echo 'tipologia: ' . $tipologia . PHP_EOL;

        // trovo l'ID della tipologia
        $idTipologia = mysqlSelectValue($cf['mysql']['connection'], 'SELECT id FROM tipologie_indirizzi WHERE nome = ?', array(array('s' => $tipologia)));

        // debug
        // echo 'ID tipologia: ' . $idTipologia . PHP_EOL;

        // individuazione civico
        $regexp = '/[0-9]+[0-9a-zA-Z\/]*$/';

        // trovo il civico
        preg_match($regexp, $indirizzo, $matches);
        $civico = $matches[0];

        // debug
        // echo 'civico: ' . $civico . PHP_EOL;

        // trovo la parte nominale
        $nominale = ucwords(trim(str_replace(array($tipologia, $civico), '', $indirizzo)));

        // individuazione numeri romani
        $regexp = '/\b([IVLXCDM]{1,3}[LVCD]{0,1}[IXMC]{0,3})\b/';

        // trovo eventuali numeri romani nella parte nominale
        preg_match_all($regexp, strtoupper($nominale), $matches);

        // rimetto in maiuscolo i numeri romani
        $nominale = str_replace(array_map('ucwords', array_map('strtolower', $matches[0])), array_map('strtoupper', $matches[0]), $nominale);

        // debug
        // echo 'parte nominale: ' . $nominale . PHP_EOL;

        // trovo l'ID del comune e della provincia per CAP
        if (empty($idComune)) {
            $row = mysqlSelectRow(
                $cf['mysql']['connection'],
                'SELECT indirizzi.id_comune, comuni.id_provincia FROM indirizzi INNER JOIN comuni ON comuni.id = indirizzi.id_comune WHERE indirizzi.cap = ?',
                array(array('s' => $cap))
            );
            if (! empty($row)) {
                $idComune = $row['id_comune'];
                if (empty($idProvincia)) {
                    $idProvincia = $row['id_provincia'];
                }
            }
        }

        // trovo l'ID della provincia
        if (empty($idProvincia)) {
            $row = mysqlSelectRow(
                $cf['mysql']['connection'],
                'SELECT provincie.id AS id_provincia, provincie.id_regione, regioni.id_stato AS id_stato FROM provincie INNER JOIN regioni ON regioni.id = provincie.id_regione WHERE provincie.sigla = ? OR provincie.nome = ?',
                array(
                    array('s' => $provincia),
                    array('s' => $provincia)
                )
            );
            if (! empty($row)) {
                $idProvincia = $row['id_provincia'];
            }
        }

        // trovo l'ID del comune
        if (empty($idComune)) {
            $row = mysqlSelectRow(
                $cf['mysql']['connection'],
                'SELECT comuni.id FROM comuni WHERE nome = ? AND id_provincia = ?',
                array(
                    array('s' => $comune),
                    array('s' => $idProvincia)
                )
            );
            if (! empty($row)) {
                $idComune = $row['id'];
            }
        }

        // località
        $localita = ucfirst(strtolower($localita));

        // debug
        // echo 'località: ' . $localita . PHP_EOL;
        // echo 'CAP: ' . $cap . PHP_EOL;
        // echo 'ID comune: ' . $idComune . PHP_EOL;
        // echo 'ID provincia: ' . $idProvincia . PHP_EOL;

        // inserisco l'indirizzo
        $idIndirizzo = mysqlInsertRow(
            $cf['mysql']['connection'],
            array(
                'id_tipologia' => $idTipologia,
                'id_comune' => $idComune,
                'cap' => $cap,
                'localita' => $localita,
                'indirizzo' => $nominale,
                'civico' => $civico
            ),
            'indirizzi'
        );

        // debug
        // echo 'ID indirizzo: ' . $idIndirizzo . PHP_EOL;

        // return
        return $idIndirizzo;
    }

    /**
     * unisce due anagrafiche duplicate
     *
     * Questa funzione chiama unisciOggetti() sulla tabella anagrafica per spostare sull'anagrafica di destinazione tutto
     * quello che punta alla sorgente e cancellare la sorgente, dopodiché aggiorna la vista statica dell'anagrafica di
     * destinazione e ripulisce quella dalle righe che non esistono più. È usata dal task _src/_api/_task/_anagrafica.deduplica.php,
     * che ne restituisce il risultato come JSON: per questo l'esito ha la forma dello $status dei task, con un messaggio
     * sotto 'info' se l'anagrafica sorgente non esiste più ( unione riuscita ) o sotto 'err' se esiste ancora.
     *
     * @param       int         $sorgente       l'ID dell'anagrafica da eliminare
     * @param       int         $destinazione   l'ID dell'anagrafica da conservare
     *
     * @return      array                       l'esito dell'unione, con le chiavi 'info' o 'err'
     *
     */
    function unisciAnagrafiche($sorgente, $destinazione)
    {

        // dati globali
        global $cf;

        // variabili di lavoro
        $tabella = 'anagrafica';
        $colonna = 'id';

        // chiamata a funzione
        unisciOggetti($sorgente, $destinazione, $tabella, $colonna);

        // aggiorno le viste statiche
        updateAnagraficaViewStatic($destinazione);
        cleanAnagraficaViewStatic();

        // mysqlQuery( $cf['mysql']['connection'], 'REPLACE INTO anagrafica_view_static SELECT * FROM anagrafica_view WHERE id = ?', array( array( 's' => $destinazione ) ) );
        // mysqlQuery( $cf['mysql']['connection'], 'DELETE FROM anagrafica_view_static WHERE id = ?', array( array( 's' => $sorgente ) ) );

        // mysqlQuery( $cf['mysql']['connection'], 'REPLACE INTO anagrafica_archiviati_view_static SELECT * FROM anagrafica_archiviati_view WHERE id = ?', array( array( 's' => $destinazione ) ) );
        // mysqlQuery( $cf['mysql']['connection'], 'DELETE FROM anagrafica_archiviati_view_static WHERE id = ?', array( array( 's' => $sorgente ) ) );

        // mysqlQuery( $cf['mysql']['connection'], 'REPLACE INTO anagrafica_attivi_view_static SELECT * FROM anagrafica_attivi_view WHERE id = ?', array( array( 's' => $destinazione ) ) );
        // mysqlQuery( $cf['mysql']['connection'], 'DELETE FROM anagrafica_attivi_view_static WHERE id = ?', array( array( 's' => $sorgente ) ) );

        // esito, nella forma dello $status dei task: unisciOggetti() non segnala i fallimenti, quindi l'unica prova che
        // l'unione è andata è che la sorgente non esista più ( 2026-09-24 )
        $status = array();
        if (mysqlSelectValue($cf['mysql']['connection'], 'SELECT id FROM ' . $tabella . ' WHERE ' . $colonna . ' = ?', array(array('s' => $sorgente)))) {
            $status['err'][] = 'l\'anagrafica #' . $sorgente . ' esiste ancora, unione con #' . $destinazione . ' non riuscita';
        } else {
            $status['info'][] = 'anagrafica #' . $sorgente . ' unita a #' . $destinazione;
        }

        // restituisco l'esito
        return $status;

    }

    /**
     * unisce due righe duplicate di una tabella spostando su una tutte le referenze dell'altra
     *
     * Questa funzione cerca in information_schema tutte le chiavi esterne che puntano a $tabella.$colonna e per ciascuna
     * sposta le referenze dalla riga sorgente alla riga di destinazione; le referenze che non si possono spostare ( di
     * solito perché violerebbero una chiave unica, cioè la destinazione ha già la stessa relazione ) vengono CANCELLATE.
     * Poi legge la riga sorgente, la cancella e copia sulla destinazione, uno per uno, i campi della sorgente che non sono
     * vuoti: dove entrambe le righe hanno un valore, quindi, vince quello della sorgente. La cancellazione avviene prima
     * della copia perché i campi unici ( es. il codice fiscale ) non collidano.
     *
     * NOTA gli errori degli UPDATE vengono controllati ma il ramo che dovrebbe gestirli è vuoto; la funzione non
     * restituisce niente e non segnala in alcun modo un fallimento.
     *
     * @param       mixed       $sorgente       l'ID ( o il valore di $colonna ) della riga da eliminare
     * @param       mixed       $destinazione   l'ID ( o il valore di $colonna ) della riga da conservare
     * @param       string      $tabella        il nome della tabella
     * @param       string      $colonna        la colonna referenziata dalle chiavi esterne ( default id )
     *
     * @return      void
     *
     */
    function unisciOggetti($sorgente, $destinazione, $tabella, $colonna = 'id')
    {

        // dati globali
        global $cf;

        // trovo tutte le referenze a tabella.id
        $chiavi = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT TABLE_NAME,COLUMN_NAME,CONSTRAINT_NAME, REFERENCED_TABLE_NAME,REFERENCED_COLUMN_NAME ' .
                'FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE ' .
                'WHERE ' .
                'REFERENCED_TABLE_SCHEMA = DATABASE() AND ' .
                'REFERENCED_TABLE_NAME = ? AND ' .
                'REFERENCED_COLUMN_NAME = ? ',
            array(
                array('s' => $tabella),
                array('s' => $colonna)
            )
        );

        // debug
        // print_r( $chiavi );

        // per ogni chiave...
        foreach ($chiavi as $chiave) {

            // debug
            // echo 'modifico tutte le referenze di ' . $chiave['TABLE_NAME'] . '.' . $chiave['COLUMN_NAME'] . ' da ' , $sorgente . ' a ' . $destinazione . PHP_EOL;
            logger('modifico tutte le referenze di ' . $chiave['TABLE_NAME'] . '.' . $chiave['COLUMN_NAME'] . ' da ' . $sorgente . ' a ' . $destinazione, 'deduplica');

            // eseguo la migrazione
            mysqlQuery(
                $cf['mysql']['connection'],
                'UPDATE ' . $chiave['TABLE_NAME'] . ' SET ' . $chiave['COLUMN_NAME'] . ' = ? WHERE ' . $chiave['COLUMN_NAME'] . ' = ?',
                array(
                    array('s' => $destinazione),
                    array('s' => $sorgente)
                )
            );

            // se ci sono degli errori...
            if (mysqli_errno($cf['mysql']['connection'])) {

                // debug
                // echo mysqli_errno( $cf['mysql']['connection'] ) . ' ' . mysqli_error( $cf['mysql']['connection'] ) . PHP_EOL;

            }

            // elimino le referenze eventualmente rimaste indietro
            mysqlQuery(
                $cf['mysql']['connection'],
                'DELETE FROM ' . $chiave['TABLE_NAME'] . ' WHERE ' . $chiave['COLUMN_NAME'] . ' = ?',
                array(
                    array('s' => $sorgente)
                )
            );
        }

        // recupero i campi della tabella principale
        $fields = mysqlQuery(
            $cf['mysql']['connection'],
            'SHOW COLUMNS FROM ' . $tabella
        );

        // debug
        // print_r( $fields );

        // prelevo la riga sorgente
        $rigaSorgente = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT * FROM ' . $tabella . ' WHERE ' . $colonna . ' = ?',
            array(
                array('s' => $sorgente)
            )
        );

        // elimino la riga sorgente
        mysqlQuery(
            $cf['mysql']['connection'],
            'DELETE FROM ' . $tabella . ' WHERE ' . $colonna . ' = ?',
            array(
                array('s' => $sorgente)
            )
        );

        // unisco i dati della tabella principale
        foreach ($fields as $field) {
            if ($field['Field'] != $colonna) {
                if (! empty($rigaSorgente[$field['Field']])) {
                    mysqlQuery(
                        $cf['mysql']['connection'],
                        'UPDATE ' . $tabella . ' SET ' . $field['Field'] . ' = ? WHERE ' . $colonna . ' = ? ',
                        array(
                            array('s' => $rigaSorgente[$field['Field']]),
                            array('s' => $destinazione)
                        )
                    );
                }
            }
        }
    }

    /**
     * FUNZIONI PER LE TENDINE
     */

    /**
     * restituisce la tendina degli stati
     *
     * Questa funzione restituisce id e __label__ di tutti gli stati, lette da stati_view in ordine di etichetta con la
     * cache su memcache indicizzata.
     *
     * @return      mixed       l'array delle righe id / __label__, o false in caso di errore
     *
     */
    function tendinaStati() {

        global $cf;

        return mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT id, __label__ FROM stati_view ORDER BY __label__'
        );

    }

    /**
     * restituisce la tendina degli anni
     *
     * Questa funzione restituisce gli anni dal prossimo ( l'anno corrente più uno ) fino a $start, in ordine decrescente,
     * ciascuno con id e __label__ uguali all'anno. Se $start è maggiore del prossimo anno l'ordine diventa crescente.
     *
     * @param       int         $start      il primo anno della tendina ( default 2014 )
     *
     * @return      array                   l'array delle righe id / __label__
     *
     */
    function tendinaAnni( $start = 2014 ) {

        $r = array();

        foreach( range( date( 'Y' ) + 1, $start ) as $y ) {
            $r[] = array( 'id' => $y, '__label__' => $y );
        }

        return $r;

    }

    /**
     * restituisce la tendina dei mesi
     *
     * Questa funzione restituisce i dodici mesi con id da 1 a 12 e __label__ nella forma "01 - Gennaio", con il nome del
     * mese nella lingua della locale corrente.
     *
     * NOTA strftime() è deprecata da PHP 8.1 e produce un avviso di deprecazione a ogni chiamata.
     *
     * @return      array       l'array delle righe id / __label__
     *
     */
    function tendinaMesi() {

        $r = array();

        foreach( range( 1, 12 ) as $m ) {
            $r[] = array( 'id' => $m, '__label__' => str_pad( $m, 2, '0', STR_PAD_LEFT ) . ' - ' . ucfirst( strftime( '%B', mktime( 0, 0, 0, $m, 1 ) ) ) );
        }

        return $r;

    }

    /**
     * restituisce la tendina delle settimane dell'anno
     *
     * Questa funzione restituisce le settimane da 1 a 53 con __label__ a due cifre ( "01", "02", ... ).
     *
     * @return      array       l'array delle righe id / __label__
     *
     */
    function tendinaSettimane() {

        $r = array();

        foreach( range( 1, 53 ) as $s ) {
            $r[] = array( 'id' => $s, '__label__' => str_pad( $s, 2, '0', STR_PAD_LEFT ) );
        }

        return $r;

    }

    /**
     * restituisce la tendina delle province di uno stato
     *
     * Questa funzione restituisce id e __label__ delle province dello stato indicato, lette da provincie_view in ordine di
     * etichetta con la cache su memcache indicizzata; se lo stato non ha province restituisce un array vuoto.
     *
     * @param       int         $idStato    l'ID dello stato ( default 1 )
     *
     * @return      mixed                   l'array delle righe id / __label__, o false in caso di errore
     *
     */
    function tendinaProvincie( $idStato = 1 ) {

        global $cf;

        return mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT id, __label__ FROM provincie_view WHERE id_stato = ? ORDER BY __label__',
            array(
                array( 's' => $idStato )
            )
        );

    }

    /**
     * restituisce la tendina sì / no
     *
     * Questa funzione restituisce le due righe id 0 / __label__ "no" e id 1 / __label__ "si", per i campi booleani.
     *
     * @return      array       l'array delle righe id / __label__
     *
     */
    function tendinaSiNo() {

        return array(
            array( 'id' => 0, '__label__' => 'no' ),
            array( 'id' => 1, '__label__' => 'si' )
        );

    }

    /**
     * ACCESSORI GENERICI DELL'ANAGRAFICA
     * ==================================
     *
     * Logo, PEC e sede legale di un'anagrafica. Stavano in
     * `_mod/_0010.anagrafica/_src/_lib/_anagrafica.utils.php`, cioe' dentro un MODULO, e sono
     * arrivati qui nel core il 15/09/2026 perche' li chiama codice che con quel modulo non
     * c'entra niente: `generaContenutiDocumento()` e undici file di stampa di `_0400.documenti`,
     * e `anagraficaGetIdSedeLegale()` il checkout dell'ecommerce.
     *
     * Su un deploy che monta un'anagrafica diversa - bernispa ha `AN000.anagrafica` e non
     * `0010.anagrafica` - quelle chiamate morivano tutte con "Call to undefined function", dal CMS
     * come da `/print/`, e nessuno se n'era accorto perche' li' i documenti si stampano dal
     * gestionale. Un modulo che dipende dalle funzioni di un altro modulo e' il difetto; la cura
     * e' che quello che leggono tabelle del CORE - `anagrafica`, `immagini`, `ruoli_immagini`,
     * `mail`, `anagrafica_indirizzi`, `ruoli_indirizzi` - stia nel core.
     *
     * Le sei funzioni `*AnagraficaViewStatic*` NON sono venute qui: quelle mantengono la vista
     * materializzata dell'anagrafica, che e' roba del modulo, e su bernispa le definisce
     * `AN000.anagrafica`. Portarle qui le farebbe collidere.
     */
    /**
     * restituisce il percorso completo del logo di un'anagrafica
     *
     * Questa funzione cerca fra le immagini dell'anagrafica la prima con ruolo "logo" e ne restituisce il percorso reso
     * completo da fullPath(); se non c'è restituisce NULL. La usano le stampe per il logo dell'emittente.
     *
     * @param       int         $id     l'ID dell'anagrafica
     *
     * @return      mixed               il percorso completo del logo, o NULL se non c'è
     *
     */
    function anagraficaGetLogo( $id ) {

	// config globale
	    global $cf;

	// debug
	    // die( 'id -> ' . $id );

	// prelevo la riga
	$r = mysqlSelectValue(
		$cf['mysql']['connection'],
		'SELECT path FROM immagini '.
		'INNER JOIN anagrafica ON immagini.id_anagrafica = anagrafica.id '.
		'LEFT JOIN ruoli_immagini ON ruoli_immagini.id = immagini.id_ruolo '.
		'WHERE ruoli_immagini.nome = "logo" '.
		'AND anagrafica.id = ? '.
		'LIMIT 1',
		array(
		    array( 's' => $id )
		)
	    );

	// full path
	if( ! empty( $r ) ) {

	    fullPath( $r );

		}


	// debug
	    // die( 'risultato -> ' . $r );

	// valore di ritorno
	    return $r;

    }


    /**
     * restituisce la sede legale di un'anagrafica
     *
     * Questa funzione prende la riga di anagrafica_indirizzi dell'anagrafica con ruolo di sede legale o, se non c'è, una
     * qualsiasi delle sue righe, e restituisce la riga di indirizzi_view dell'indirizzo collegato, con due aggiunte:
     *
     * chiave           | dettagli
     * -----------------|-----------------------------------------------------------------------
     * id               | l'ID della riga di anagrafica_indirizzi, non di indirizzi ( vedi i commenti nel corpo )
     * linee            | l'indirizzo su due righe per le buste, indirizzo e civico poi CAP, comune e sigla
     *
     * Se manca uno fra indirizzo, civico, CAP, comune e sigla le due linee sono fatte di spazi. Se l'anagrafica non ha
     * indirizzi, o la riga trovata non è collegata a un indirizzo ( id_indirizzo vuoto ), restituisce un array vuoto.
     *
     * @param       int         $id     l'ID dell'anagrafica
     *
     * @return      array               la sede legale, o un array vuoto se non c'è
     *
     */
    function anagraficaGetSedeLegale( $id ) {

		// config globale
			global $cf;

		// debug
			// die( 'id -> ' . $id );
/*
		// prelevo la riga
			$r = mysqlSelectRow(
				$cf['mysql']['connection'],
				'SELECT * FROM indirizzi_view '.
				'INNER JOIN anagrafica_indirizzi ON anagrafica_indirizzi.id_indirizzo = indirizzi_view.id '.
				'INNER JOIN ruoli_indirizzi ON ruoli_indirizzi.id = anagrafica_indirizzi.id_ruolo '.
				'WHERE ruoli_indirizzi.se_sede_legale = 1 '.
				'AND anagrafica_indirizzi.id_anagrafica = ? '.
				'LIMIT 1',
				array(
					array( 's' => $id )
				)
			);
*/

		// prelevo la riga
		// Fix 2026-07-10: alias esplicito su `anagrafica_indirizzi.id`. Con `SELECT *`
		// su un JOIN, la colonna `id` di ruoli_indirizzi sovrascrive quella di
		// anagrafica_indirizzi nell'array associativo: $r['id'] valeva l'id del RUOLO.
		$r = mysqlSelectRow(
			$cf['mysql']['connection'],
			'SELECT anagrafica_indirizzi.*, '.
			'anagrafica_indirizzi.id AS id_anagrafica_indirizzi, '.
			'ruoli_indirizzi.se_sede_legale '.
			'FROM anagrafica_indirizzi '.
			'LEFT JOIN ruoli_indirizzi ON ruoli_indirizzi.id = anagrafica_indirizzi.id_ruolo '.
			'WHERE anagrafica_indirizzi.id_anagrafica = ? '.
			'ORDER BY ruoli_indirizzi.se_sede_legale DESC '.
			'LIMIT 1',
			array(
				array( 's' => $id )
			)
		);

		// Fix 2026-07-10: l'id della sede è quello di `anagrafica_indirizzi`, ed è ciò
		// che anagraficaGetIdSedeLegale() scrive in `documenti.id_sede_*` (FK migrata
		// su anagrafica_indirizzi il 2026-07-10). Va conservato prima che il blocco
		// sottostante rimpiazzi $r con la riga di `indirizzi_view`, che ha un altro id.
		$idSedeAnagraficaIndirizzi = isset( $r['id_anagrafica_indirizzi'] ) ? $r['id_anagrafica_indirizzi'] : null;
/*
		die(print_r($r,true));

		// prelevo la riga
		$r = mysqlSelectRow(
			$cf['mysql']['connection'],
			'SELECT * FROM indirizzi_view '.
			'INNER JOIN anagrafica_indirizzi ON anagrafica_indirizzi.id_indirizzo = indirizzi_view.id '.
			'INNER JOIN ruoli_indirizzi ON ruoli_indirizzi.id = anagrafica_indirizzi.id_ruolo '.
			'WHERE anagrafica_indirizzi.id_anagrafica = ? '.
			'ORDER BY ruoli_indirizzi.se_sede_legale DESC'.
			'LIMIT 1',
			array(
				array( 's' => $id )
			)
		);
*/

		// ...
		if( isset( $r['id_indirizzo'] ) && ! empty( $r['id_indirizzo'] ) ) {

		// ...
		$r = mysqlSelectRow(
			$cf['mysql']['connection'],
			'SELECT * FROM indirizzi_view WHERE id = ?',
			array( array( 's' => $r['id_indirizzo'] ) )
		);

		// Fix 2026-07-10: `indirizzi_view.id` è l'id di `indirizzi`; ripristino l'id
		// della sede (anagrafica_indirizzi) che i chiamanti scrivono in documenti.id_sede_*.
		// I campi indirizzo/civico/cap/comune/sigla restano quelli arricchiti dalla view.
		$r['id'] = $idSedeAnagraficaIndirizzi;

		// riassemblaggio dell'indirizzo per linee (ad es. per le buste)
			if( empty($r['indirizzo']) || empty($r['civico']) || empty($r['cap']) || empty($r['comune']) || empty($r['sigla']) ){
				$r['linee'][0]='              ';
				$r['linee'][1]='              ';
			} else {
				$r['linee'][0] = $r['indirizzo'] . ' ' . $r['civico'];
				$r['linee'][1] = $r['cap'] . ' ' . $r['comune'] . ' ' . $r['sigla'];
			}

		// debug
		 	// die( 'risultato -> ' . print_r( $r, true ) );

		} else {

			$r = array();

		}

		// valore di ritorno
			return $r;

	}

    /**
     * restituisce l'ID della sede legale di un'anagrafica
     *
     * Questa funzione restituisce la chiave id della sede trovata da anagraficaGetSedeLegale(), cioè l'ID di
     * anagrafica_indirizzi da scrivere in documenti.id_sede_*; se la sede non c'è restituisce NULL.
     *
     * @param       int         $id     l'ID dell'anagrafica
     *
     * @return      mixed               l'ID della sede legale, o NULL se non c'è
     *
     */
    function anagraficaGetIdSedeLegale( $id ) {

		$r = anagraficaGetSedeLegale( $id );

		return isset( $r['id'] ) ? $r['id'] : null;

	}

    /**
     * restituisce l'indirizzo PEC di un'anagrafica
     *
     * Questa funzione restituisce il primo indirizzo della tabella mail dell'anagrafica marcato come PEC ( se_pec = 1 );
     * se non ce ne sono restituisce NULL.
     *
     * @param       int         $id     l'ID dell'anagrafica
     *
     * @return      mixed               l'indirizzo PEC, o NULL se non c'è
     *
     */
    function anagraficaGetPEC( $id ) {

	// config globale
	    global $cf;

	// debug
	    // die( 'id -> ' . $id );

	// prelevo la riga
	    $r = mysqlSelectValue(
		$cf['mysql']['connection'],
		'SELECT indirizzo FROM mail '.
		'INNER JOIN anagrafica ON mail.id_anagrafica = anagrafica.id '.
		'WHERE mail.se_pec = 1 '.
		'AND anagrafica.id = ? '.
		'LIMIT 1',
		array(
		    array( 's' => $id )
		)
	    );

	// debug
	    // die( 'risultato -> ' . $r );

	// valore di ritorno
	    return $r;

    }

    /**
     * FUNZIONI DI LETTURA
     */

    /**
     * legge la __label__ di una riga per id, scrivendo l'id nella query quando si puo'
     *
     * ( fix 2026-09-23 ) Il titolo di ogni scheda e l'etichetta della conferma di cancellazione
     * leggono `SELECT __label__ FROM <tabella><estensione> WHERE id = ?`. Quando l'estensione e'
     * `_view`, cioe' la tabella non ha una statica, col segnaposto la condizione non entra nella
     * vista e la vista si materializza per intero: misurato in produzione su polmasi il
     * 23/09/2026, `contratti_view` 1,59 s col segnaposto e 0,017 s con l'id scritto, e quella
     * lettura era la query lenta piu' pesante della giornata ( 206 volte, 441 s ).
     *
     * Stesse regole e stessa rete della lettura "integrazione blocco dati" di controller() e di
     * refreshStaticView(): si scrive nella query solo un id fatto di sole cifre e senza zeri
     * iniziali, passato per (int); le viste dichiarate in `$cf['controller']['no_id_inline']`
     * restano sul segnaposto; se la query con l'id scritto fallisce si rifa' col segnaposto e la
     * tabella si segna per il resto della richiesta.
     *
     * @param   mysqli  $c      connessione
     * @param   string  $t      tabella, senza estensione
     * @param   string  $rm     estensione ( '', '_view', '_view_static' ), da getStaticViewExtension()
     * @param   mixed   $i      id della riga
     * @param   string  $l      coda della query ( es. ' LIMIT 1' )
     *
     * @return  mixed           la __label__, o NULL se la riga non c'e'
     */
    function mysqlSelectLabel($c, $t, $rm, $i, $l = '')
    {

        $q = 'SELECT __label__ FROM ' . $t . $rm . ' WHERE id = ';

        if ($rm === '_view'
            && ctype_digit((string) $i) && (string) $i === (string) (int) $i
            && empty($GLOBALS['cf']['controller']['no_id_inline'][$t])) {

            $e = array();
            $v = mysqlSelectValue($c, $q . (int) $i . $l, false, $e);

            if (empty($e)) {
                return $v;
            }

            $GLOBALS['cf']['controller']['no_id_inline'][$t] = true;
            logger('lettura della __label__ di ' . $t . $rm . ' con id nella query non riuscita, si ripiega sul parametro per il resto della richiesta', 'mysql', LOG_WARNING);

        }

        return mysqlSelectValue($c, $q . '?' . $l, array(array('s' => $i)));
    }
