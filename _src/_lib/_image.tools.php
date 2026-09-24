<?php

    /**
     * libreria per la gestione e la manipolazione delle immagini
     *
     * Questa libreria contiene alcune funzioni per leggere le dimensioni delle immagini, ridimensionarle, ritagliarle e
     * convertirle da un formato all'altro utilizzando l'estensione GD di PHP.
     *
     * introduzione
     * ============
     * Il framework usa questa libreria soprattutto nel task _src/_api/_task/_images.resize.php ( e nel suo gemello del modulo
     * immagini ), che per ogni immagine caricata genera le versioni scalate e tagliate nei formati dichiarati in
     * $cf['image']['formats'], più la versione WebP di ciascuna; la usa inoltre la macro _immagini.form.php del modulo archivio
     * per mostrare le dimensioni dell'immagine.
     *
     * I formati supportati sono JPEG, PNG e WebP; il GIF non è supportato. Tutti i percorsi accettati dalle funzioni possono
     * essere relativi a DIR_BASE o assoluti, perché vengono risolti con fullPath().
     *
     * costanti
     * ========
     * Questa libreria non definisce costanti.
     *
     * funzioni
     * ========
     * Le funzioni di questa libreria sono divise in gruppi in base al lavoro che svolgono; nei paragrafi successivi le analizzeremo nel dettaglio.
     *
     * funzioni di lettura
     * -------------------
     * Le funzioni in questo gruppo servono per leggere le immagini e le loro caratteristiche.
     *
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * imageSize()                      | legge le dimensioni e l'orientamento di un'immagine
     * imageOpen()                      | apre un'immagine in memoria
     *
     * funzioni di elaborazione
     * ------------------------
     * Le funzioni in questo gruppo servono per trasformare le immagini e scriverle su file.
     *
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * imageCut()                       | ritaglia un'immagine lungo il lato maggiore
     * imageWrite()                     | scrive un'immagine su file
     * imageConvert()                   | converte un'immagine in un altro formato
     * imageResize()                    | ridimensiona un'immagine in proporzione
     *
     * funzioni di retrocompatibilità
     * ------------------------------
     * Le funzioni in questo gruppo sostituiscono funzioni di PHP che mancano nelle versioni più vecchie.
     *
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * imagecrop()                      | ritaglia un'immagine, se GD non la fornisce
     *
     * dipendenze
     * ==========
     * Questa libreria ha alcune dipendenze che devono essere soddisfatte per funzionare correttamente. In particolare
     * sono richieste le seguenti funzioni:
     *
     * funzione                         | libreria di appartenenza
     * ---------------------------------|---------------------------------------------------------------
     * fullPath()                       | _src/_lib/_filesystem.tools.php
     * checkFolder()                    | _src/_lib/_filesystem.tools.php
     * getFileExtension()               | _src/_lib/_filesystem.tools.php
     * logWrite()                       | _src/_lib/_log.utils.php
     *
     * Sono richieste inoltre le estensioni GD ( con il supporto WebP ) ed EXIF di PHP.
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
     * FUNZIONI DI LETTURA
     */

    /**
     * legge le dimensioni e l'orientamento di un'immagine
     *
     * Questa funzione legge le dimensioni dell'immagine indicata con getimagesize() e ne ricava orientamento, lato maggiore,
     * lato minore e rapporto fra i due; il percorso può essere relativo a DIR_BASE o assoluto. Un'immagine quadrata viene
     * considerata orizzontale. Se il file non esiste o non si può leggere la funzione restituisce false.
     *
     * L'array restituito ha le seguenti chiavi:
     *
     * chiave   | dettagli
     * ---------|-----------------------------------------------------------------------
     * h        | l'altezza dell'immagine in pixel
     * w        | la larghezza dell'immagine in pixel
     * r        | il rapporto fra il lato maggiore e il lato minore
     * o        | l'orientamento dell'immagine, l per orizzontale ( landscape ) e p per verticale ( portrait )
     * g        | il lato maggiore dell'immagine
     * l        | il lato minore dell'immagine
     *
     * TODO se il file esiste ma non è un'immagine getimagesize() restituisce false e le dimensioni valgono NULL, quindi il
     * calcolo del rapporto divide per zero: da PHP 8 è un DivisionByZeroError e non un false.
     *
     * @param       string      $f      il percorso dell'immagine
     *
     * @return      mixed               l'array con dimensioni e orientamento, oppure false se il file non è leggibile
     *
     */
    function imageSize( $f ) {

    // inizializzazione variabili
        fullPath( $f );

    // se il file da processare esiste
        if( file_exists( $f ) && is_readable( $f ) ) {

        // debug
            // echo $f . PHP_EOL;

        // prelevo le dimensioni del file
            $d = getimagesize( $f );

            $w = $d[0];
            $h = $d[1];

            $o = ( $w >= $h ) ? 'l' : 'p';
            $g = ( $w >= $h ) ? $w : $h;
            $l = ( $w >= $h ) ? $h : $w;

            $r = ( $o == 'l' ) ? ( $w / $h ) : ( $h / $w );

        // restituzione del risultato
            return array(
            "h" => $h    // altezza dell'immagine
            ,
            "w" => $w    // larghezza dell'immagine
            ,
            "r" => $r    // rapporto lato maggiore / lato minore
            ,
            "o" => $o    // orientamento dell'immagine
            ,
            "g" => $g    // lato maggiore dell'immagine
            ,
            "l" => $l    // lato minore dell'immagine
            );

        } else {

        // errore
            return false;

        }

    }

    /**
     * apre un'immagine in memoria
     *
     * Questa funzione apre l'immagine indicata con la funzione GD adatta al suo tipo, riconosciuto dal contenuto con
     * exif_imagetype() e non dall'estensione; i tipi supportati sono JPEG, PNG e WebP. Il percorso può essere relativo a
     * DIR_BASE o assoluto; la cartella che contiene il file viene creata se non esiste, come in imageWrite(). Se il tipo non è
     * supportato, o se il file non esiste ( nel qual caso PHP segnala anche un warning ), la funzione restituisce false.
     *
     * @param       string      $f      il percorso dell'immagine
     *
     * @return      mixed               l'immagine GD aperta, oppure false se il tipo non è supportato
     *
     */
    function imageOpen( $f ) {

    fullPath( $f );
    checkfolder( dirname( $f ) );

    switch( exif_imagetype( $f ) ) {
        case IMAGETYPE_JPEG:
        return imagecreatefromjpeg( $f );
        break;
        case IMAGETYPE_PNG:
        return imagecreatefrompng( $f );
        break;
        case IMAGETYPE_WEBP:
        return imagecreatefromwebp( $f );
        break;
        default:
        return false;
        break;
    }

    }

    /**
     * FUNZIONI DI ELABORAZIONE
     */

    /**
     * ritaglia un'immagine lungo il lato maggiore
     *
     * Questa funzione ritaglia l'immagine sorgente lungo il suo lato maggiore, portandolo a $d pixel e lasciando invariato il
     * lato minore: un'immagine orizzontale ( o quadrata ) viene tagliata in larghezza, una verticale in altezza. Il parametro $b
     * dice quale parte tenere: START tiene l'inizio ( sinistra o alto ), MIDDLE il centro, qualsiasi altro valore la fine. Il
     * risultato viene scritto in $fd con imageWrite(), nel formato indicato dall'estensione di $fd; per i PNG viene conservata
     * la trasparenza. Il task _src/_api/_task/_images.resize.php la usa dopo imageResize() per ottenere i formati tagliati.
     *
     * Il caso in cui $d è maggiore del lato da tagliare non è gestito: l'origine del taglio diventa negativa e il risultato
     * dipende da imagecrop().
     *
     * @param       string      $fs     il percorso dell'immagine sorgente
     * @param       int         $d      la misura in pixel a cui portare il lato maggiore ( default 1024 )
     * @param       string      $fd     il percorso dell'immagine di destinazione ( di fatto obbligatorio, il default false non funziona )
     * @param       string      $b      la parte da tenere, START, MIDDLE o END ( default MIDDLE )
     *
     * @return      void
     *
     */
    function imageCut( $fs, $d = 1024, $fd = false, $b = 'MIDDLE' ) {

    // handler dell'immagine sorgente
        $is = imageOpen( $fs );

    // dimensioni dell'immagine
        $dim = imageSize( $fs );

    // orientamento dell'immagine
        if( $dim['o'] == 'l' ) {

        // se l'immagine è orizzontale, tengo bloccata l'altezza e croppo la larghezza
            $ch = $dim['h'];
            $cw = $d;
            $x = ( $b == 'START' ) ? 0 : ( ( $b == 'MIDDLE' ) ? round( ( $dim['w'] - $d ) / 2 ) : ( $dim['w'] - $d ) );
            $y = 0;

        } else {

        // se l'immagine è verticale, tengo bloccata la larghezza e croppo l'altezza
            $ch = $d;
            $cw = $dim['w'];
            $x = 0;
            $y = ( $b == 'START' ) ? 0 : ( ( $b == 'MIDDLE' ) ? round( ( $dim['h'] - $d ) / 2 ) : ( $dim['h'] - $d ) );

        }

    // crop
        $id = imagecrop( $is, array( 'x' => $x, 'y' => $y, 'width' => $cw, 'height' => $ch ) );

    // palette e canale alfa
        if( strtolower( getFileExtension( $fd ) ) == 'png' ) {
        imagealphablending( $id, false );
        imagesavealpha( $id, true );
        imagepalettecopy( $is, $id );
        }

    // debug
        // imagestring( $id, 5, 5, 30, $cw . 'x' . $ch, imagecolorallocate( $id, 255, 0, 0 ) );

    // scrivo l'immagine
        imageWrite( $id, $fd );

    }

    /**
     * scrive un'immagine su file
     *
     * Questa funzione scrive su file un'immagine GD aperta in memoria, nel formato indicato da $t oppure, se $t non è
     * specificato, dall'estensione del file di destinazione; $t può essere un'estensione ( jpg, jpeg, png, webp ) o una delle
     * costanti IMAGETYPE_JPEG, IMAGETYPE_PNG e IMAGETYPE_WEBP. Il percorso può essere relativo a DIR_BASE o assoluto, e la
     * cartella di destinazione viene creata se non esiste. Per i PNG viene conservata la trasparenza.
     *
     * @param       object      $id     l'immagine GD da scrivere
     * @param       string      $f      il percorso del file di destinazione
     * @param       mixed       $t      il formato di destinazione ( default NULL, ricavato dall'estensione di $f )
     *
     * @return      mixed               false se il formato non è supportato, altrimenti NULL ( l'esito della scrittura non viene restituito )
     *
     */
    function imageWrite( $id, $f, $t = NULL ) {

    fullPath( $f );
    checkfolder( dirname( $f ) );

    if( $t === NULL ) {
        $t = strtolower( getFileExtension( $f ) );
    }

    switch( $t ) {
        case 'jpg':
        case 'jpeg':
        case IMAGETYPE_JPEG:
        imagejpeg( $id, $f );
        break;
        case 'png':
        case IMAGETYPE_PNG:
        imagealphablending( $id, false );
        imagesavealpha( $id, true );
        imagepng( $id, $f );
        break;
        case 'webp':
        case IMAGETYPE_WEBP:
        imagewebp( $id, $f );
        break;
        default:
        return false;
        break;
    }

    }

    /**
     * converte un'immagine in un altro formato
     *
     * Questa funzione apre l'immagine sorgente con imageOpen() e la riscrive con imageWrite() nel formato $td; se non viene
     * indicato un file di destinazione, questo si ottiene dal nome del sorgente sostituendo l'estensione con $td ( es. da
     * foto.jpg a foto.webp ), oppure aggiungendo $td se il sorgente non ha estensione. Il formato effettivo della scrittura
     * dipende dall'estensione del file di destinazione, quindi passando $fd conviene che la sua estensione corrisponda a $td.
     *
     * NOTA la sostituzione dell'estensione è una str_replace() su tutto il percorso: se la stessa sequenza compare anche prima
     * ( es. una cartella di nome foto.jpg ) viene sostituita anche lì.
     *
     * @param       string      $fs     il percorso dell'immagine sorgente
     * @param       string      $td     il formato di destinazione, come estensione ( es. webp )
     * @param       string      $fd     il percorso del file di destinazione ( default NULL, ricavato dal sorgente )
     *
     * @return      string              il percorso del file di destinazione, restituito anche se la scrittura non è riuscita
     *
     */
    function imageConvert( $fs, $td, $fd = NULL ) {

    // apro l'immagine sorgente
        $id = imageOpen( $fs );

    // file di destinazione
        if( $fd === NULL ) {
        // NB: per un sorgente senza estensione getFileExtension() restituisce una stringa vuota, e la str_replace() di
        // un punto solo toccherebbe tutti i punti del percorso: in quel caso l'estensione si aggiunge ( 2026-09-24 )
        if( getFileExtension( $fs ) == '' ) {
            $fd = $fs . '.' . $td;
        } else {
            $fd = str_replace( '.'.getFileExtension($fs), '.'.$td, $fs );
        }
        }

    // debug
        // echo $fd . PHP_EOL;

    // scrivo l'immagine
        imageWrite( $id, $fd );

        return $fd;

    }

    /**
     * ridimensiona un'immagine in proporzione
     *
     * Questa funzione ridimensiona in proporzione l'immagine sorgente in modo che il suo lato maggiore misuri $d pixel e scrive
     * il risultato in $fd; se $fd non è specificato l'immagine sorgente viene sovrascritta. Con $o uguale a l è sempre la
     * larghezza a misurare $d, anche per le immagini verticali. L'immagine viene anche ingrandita, se è più piccola di $d. I
     * formati supportati sono JPEG, PNG e WebP, riconosciuti dall'estensione del sorgente, e il file di destinazione viene
     * scritto nello stesso formato del sorgente qualunque sia la sua estensione; per i PNG viene conservata la trasparenza.
     *
     * Se $d è vuoto o zero l'immagine viene copiata senza scalarla e la funzione restituisce true, senza controllare l'esito
     * della copia. Se il sorgente non esiste, se il formato non è supportato, se l'immagine ha dimensioni nulle ( file
     * danneggiato ) o se la lettura, la scalatura o la scrittura falliscono, la funzione restituisce false; gli errori vengono
     * loggati nel canale image.
     *
     * @param       string      $fs     il percorso dell'immagine sorgente
     * @param       int         $d      la misura in pixel del lato maggiore ( default 1024; vuoto per copiare senza scalare )
     * @param       string      $fd     il percorso dell'immagine di destinazione ( default false, sovrascrive il sorgente )
     * @param       string      $o      l per forzare il ridimensionamento sulla larghezza ( default NULL )
     *
     * @return      bool                true se l'immagine è stata scritta, false altrimenti
     *
     */
    function imageResize( $fs, $d = 1024, $fd = false, $o = NULL ) {

    // estensioni supportate
        $ext = array( 'jpg', 'jpeg', 'png', 'webp' );

    // se non viene specificato un file di destinazione, assume che sia uguale al sorgente
        if( $fd == false ) {
        $fd = $fs;
        }

    // creo i full path
        fullPath( $fs );
        fullPath( $fd );

    // controllo il path di destinazione
        checkFolder( dirname( $fd ) );

    // estensione
        $x = strtolower( getFileExtension( $fs ) );

    // controllo che la dimensione max sia diversa da 0 altrimenti copio l'immagine senza scalarla
        if( empty( $d ) ) {

        // copio l'immagine
            copy( $fs, $fd );

        // restituisco true
            return true;

        } elseif( file_exists( $fs ) && in_array( $x, $ext ) ) {

        // prende in entrata le dimensioni dell'immagine originale
            $dimensioni = getimagesize( $fs );

            $altezza = $dimensioni[1];        // l'altezza dell'immagine
            $larghezza = $dimensioni[0];    // la larghezza dell'immagine

        // se l'immagine ha dimensioni nulle, allora il file è danneggiato
            if( empty( $altezza ) || empty( $larghezza ) ) {

            // log
                logWrite( 'file danneggiato: ' . $fs, 'image', LOG_ERR );

            // restituisco false
                return false;

            } else {

            // nel caso l'immagine sia piu' alta che larga...
                if( $altezza > $larghezza && $o != 'l' ) {

                // ...viene ridimensionata a partire dalla larghezza e l'altezza viene scalata proporzionalmente
                    $valore_riferimento = $larghezza; 
                    $valore_secondario = $altezza;

                // scalatura proporzionale della dimensione secondaria
                    $alpha_dim = round( ( $d * $valore_riferimento ) / $valore_secondario );
                    $beta_dim = $d;

                } else {

                // ...altrimenti viene ridimensionata a partire dall'altezza e la larghezza viene scalata proporzionalmente
                    $valore_riferimento = $altezza;
                    $valore_secondario = $larghezza;

                // dimensione principale valorizzata al massimo consentito
                    $alpha_dim = $d;

                // scalatura proporzionale della dimensione secondaria
                    $beta_dim = round( ( $d * $valore_riferimento ) / $valore_secondario );

                }

            // creazione dell'immagine di destinazione
                $identificatore_destinazione = imagecreatetruecolor( $alpha_dim , $beta_dim );

            // TODO questa cosa andrebbe fatta con
            // $identificatore_provenienza = imageOpen( $fs );

            // a seconda del tipo di file viene creato un file immagine differente
                switch( $x ) {
                case 'jpg':
                case 'jpeg':
                    $identificatore_provenienza = imagecreatefromjpeg( $fs );
                break;
                case 'png':
                    imagealphablending( $identificatore_destinazione , false );
                    imagesavealpha( $identificatore_destinazione , true );
                    $identificatore_provenienza = imagecreatefrompng( $fs );
                break;
                case 'webp':
                    $identificatore_provenienza = imagecreatefromwebp( $fs );
                break;
                case 'gif':
                default:
                    $exit_message = 'formato non supportato: ' . $x;
                break;
                }

            // controllo che l'immagine sia valida
                if( empty( $identificatore_provenienza ) ) {

                // log
                    logWrite( 'impossibile leggere: ' . $fs, 'image', LOG_DEBUG );

                // restituisco false
                    return false;

                } else {

                // log
                    logWrite( 'lettura ok: ' . $fs, 'image', LOG_DEBUG );

                // trasferimento della palette dall'immagine creata in memoria al file di destinazione
                    imagepalettecopy( $identificatore_provenienza , $identificatore_destinazione );

                // copiatura dell'immagine creata in memoria sul file
                    $cont = imagecopyresampled(
                    $identificatore_destinazione,
                    $identificatore_provenienza,
                    0,0,0,0,
                    $alpha_dim,
                    $beta_dim,
                    $larghezza,
                    $altezza
                    );

                // esito dell'operazione
                    if( $cont ) {

                    logWrite( 'scalamento corretto a ' . $d . 'px di: ' . $fs, 'image' , LOG_DEBUG );
                    $exit_message = 'file creato con successo';

                    } else {

                    logWrite( 'impossibile scalare a ' . $d . 'px: ' . $fs, 'image' , LOG_DEBUG );
                    $exit_message = 'impossibile creare il file ' . $fd;

                    // output
                        return false;

                    }

                // debug
                    // imagestring( $identificatore_destinazione, 5, 5, 5, $alpha_dim . 'x' . $beta_dim, imagecolorallocate( $identificatore_destinazione, 255, 0, 0 ) );

                // scrittura del file
                    switch( $x ) {

                    case 'jpg':
                    case 'jpeg':
                        $cont = imagejpeg( $identificatore_destinazione , $fd );
                    break;

                    case 'png':
                        $cont = imagepng( $identificatore_destinazione , $fd );
                    break;

                    case 'webp':
                        $cont = imagewebp( $identificatore_destinazione , $fd );
                    break;

                    case 'gif':
                    default:
                        logWrite( 'formato ' . $x . ' non supportato' , 'image' , LOG_DEBUG );
                    break;

                    }

                // esito dell'operazione
                    if( $cont ) {

                    logWrite( 'scrittura corretta: ' . $fd, 'image' , LOG_DEBUG );
                    $exit_message = 'file creato con successo';

                    // output
                        return true;

                    } else {

                    logWrite( 'impossibile scrivere: ' . $fd, 'image' , LOG_DEBUG );
                    $exit_message = 'impossibile creare il file ' . $fd;

                    // output
                        return false;

                    }

                }

            }

        } else {

        // output
            return false;

        }

    }

    /**
     * FUNZIONI DI RETROCOMPATIBILITÀ
     */

    /**
     * ritaglia un'immagine, se GD non la fornisce
     *
     * Questa funzione viene definita solo se GD non fornisce già imagecrop() ( che esiste da PHP 5.5 ) e ne riproduce il
     * comportamento essenziale: copia in una nuova immagine il rettangolo indicato dalle chiavi x, y, width e height di $rect.
     * A differenza dell'originale non restituisce mai false.
     *
     * @param       object      $src    l'immagine GD da ritagliare
     * @param       array       $rect   il rettangolo da ritagliare, con le chiavi x, y, width e height
     *
     * @return      object              l'immagine ritagliata
     *
     */
    if( ! function_exists( 'imagecrop' ) ) {
    function imagecrop( $src, array $rect ) {
        $dest = imagecreatetruecolor( $rect['width'], $rect['height'] );
        imagecopyresampled(
            $dest,
            $src,
            0,
            0,
            $rect['x'],
            $rect['y'],
            $rect['width'],
            $rect['height'],
            $rect['width'],
            $rect['height']
        );
        return $dest;
    }
    }
