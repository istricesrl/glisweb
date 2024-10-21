<?php

    /**
     * dichiarazione dei siti gestiti
     *
     * in questo file vengono dichiarati i siti gestiti dall'installazione corrente del framework
     *
     * il concetto di sito e l'approccio multisito
     * ===========================================
     * Una sola installazione fisica del framework è in grado di gestire più siti, intesi come diversi insiemi
     * di pagine, configurazioni e risorse multimediali. Questo risulta particolarmente comodo quando si devono
     * creare e gestire gruppi di siti fortemente interconnessi, magari con contenuti condivisi fra essi.
     *
     * In uno scenario multisito è possibile gestire, ad esempio, tutti i siti da un solo pannello di controllo,
     * il che rappresenta di per sé già una notevole comodità. Tutti i siti attivi nell'installazione corrente
     * sono definiti come sotto array dell'array $cf['sites'] e sono identificati da un ID che è anche la
     * chiave di $cf['sites'].
     *
     * struttura dell'array sito
     * -------------------------
     * Ogni sotto array di $cf['sites'] rappresenta un sito gestito dalla piattaforma, e come tale possiede
     * chiavi e sotto array che lo definiscono. Per una trattazione completa della struttura del sotto array sito
     * si rimanda alla \ref variabili "pagina del manuale che tratta le variabili del framework". In questa sede
     * è sufficiente evidenziare il ruolo svolto da $cf['sites']. L'installazione base del framework prevede
     * un solo sito, di default, a scopo principalmente dimostrativo; volendo utilizzare GlisWeb come piattaforma
     * per pubblicare contenuti sul web, la prima cosa da fare dovrebbe essere personalizzare in custom
     * (src/config/010.site.php) il sito di default.
     *
     * installazione del framework in una sottocartella
     * ------------------------------------------------
     * La variabile $cf['site']['basefolders'] consente alla piattaforma di essere
     * installata anche in una sottocartella della root del sito senza che si verifichino
     * problemi. In altre parole la piattaforma GlisWeb non necessita di essere collocata
     * nella radice dello spazio web per funzionare, ma può lavorare anche in una
     * sottocartella come ad esempio <protocollo>://<url>/[path/].
     *
     * lingue disponibili per il sito
     * ------------------------------
     * Il framework ricava le lingue disponibili dalle chiavi dell'array $cf['site']['name'];
     * in pratica, se si dà un nome al sito in una lingua, il framework suppone che si desideri
     * rendere l'intero sito disponibile in quella lingua. Pertanto nella redazione del file
     * scr/config/010.site.php si presti particolare attenzione a questo aspetto; inoltre,
     * visto che il framework prevede già un titolo di default per l'italiano è importante
     * sovrascriverlo oppure, se non si desidera rendere il sito disponibile in italiano,
     * eliminarlo tramite la funzione unset.
     *
     *
     *
     * TODO documentare
     *
     *
     *
     */

    /**
     * configurazione del sito di default
     * ==================================
     * 
     * 
     */

    // l'etichetta del sito
    $cf['sites']['1']['__label__']                              = 'default';

    // il titolo del sito
    $cf['sites']['1']['name']['it-IT']                          = NULL;

    // i protocolli del sito
    $cf['sites']['1']['protocols'][ DEVELOPEMENT ]              =
    $cf['sites']['1']['protocols'][ TESTING ]                   =
    $cf['sites']['1']['protocols'][ PRODUCTION ]                = 'http';

    // gli host del sito
    $cf['sites']['1']['hosts'][ DEVELOPEMENT ]                  =
    $cf['sites']['1']['hosts'][ TESTING ]                       =
    $cf['sites']['1']['hosts'][ PRODUCTION ]                    = $_SERVER['HTTP_HOST'];

    // i domini del sito
    $cf['sites']['1']['domains'][ DEVELOPEMENT ]                =
    $cf['sites']['1']['domains'][ TESTING ]                     =
    $cf['sites']['1']['domains'][ PRODUCTION ]                  = NULL;

    // gli alias degli host del sito
    $cf['sites']['1']['alias']['hosts'][ DEVELOPEMENT ]         =
    $cf['sites']['1']['alias']['hosts'][ TESTING ]              =
    $cf['sites']['1']['alias']['hosts'][ PRODUCTION ]           = array();

    // gli alias dei domini del sito
    $cf['sites']['1']['alias']['domains'][ DEVELOPEMENT ]       =
    $cf['sites']['1']['alias']['domains'][ TESTING ]            =
    $cf['sites']['1']['alias']['domains'][ PRODUCTION ]         = array();

    // le cartelle base del sito
    $cf['sites']['1']['folders'][ DEVELOPEMENT ]                =
    $cf['sites']['1']['folders'][ TESTING ]                     =
    $cf['sites']['1']['folders'][ PRODUCTION ]                  = NULL;

    // id pagina home
    $cf['sites']['1']['homes'][ DEVELOPEMENT ]                  =
    $cf['sites']['1']['homes'][ TESTING ]                       =
    $cf['sites']['1']['homes'][ PRODUCTION ]                    = NULL;

    /**
     * debug del runlevel
     * ==================
     * 
     * 
     */

    // debug
    // echo 'OUTPUT';
    // die( print_r( $cf['sites'], true ) );
