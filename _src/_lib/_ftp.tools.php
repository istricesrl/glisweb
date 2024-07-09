<?php

    /**
     * libreria per la gestione del protocollo FTP
     * 
     * TODO documentare
     * TODO implementare
     * 
     * 
     * 
     */

    /**
     * FUNZIONI PER LA CONNESSIONE AL SERVER
     */

    /**
     * effettua la connessione a un server FTP
     * 
     * Questa funzione crea una connessione a un server FTP e imposta la modalità passiva (di default) oppure attiva.
     * Restituisce un oggetto connessione che può essere utilizzato per dare comandi, caricare e scaricare file, elencare
     * il contenuto del server, e così via.
     * 
     */
    function ftpConnect() {
        // TODO implementare
    }

    /**
     * chiude la connessione al server FTP
     * 
     * Questa funzione chiude la connessione al server FTP e rilascia le risorse utilizzate.
     * 
     */
    function ftpClose() {
        // TODO implementare
    }

    /**
     * FUNZIONI PER L'UPLOAD E IL DOWNLOAD
     */

    /**
     * carica un file su un server FTP
     * 
     * Questa funzione carica un file su un server FTP.
     * 
     */
    function ftpPutFile() {
        // TODO implementare
    }

    /**
     * scarica un file da un server FTP
     * 
     * Questa funzione scarica un file da un server FTP.
     * 
     */
    function ftpGetFile() {
        // TODO implementare
    }

    /**
     * restituisce il tipo di trasferimento da utilizzare per un file
     * 
     * Questa funzione restituisce il tipo di trasferimento da utilizzare per un file.
     * 
     * TODO serve anche per il download 'sta cosa? nel caso come si fa a sapere se un file remoto è binario oppure no?
     * 
     */
    function ftpGetUploadTypeByFile( $f ) {

        fullpath( $f );

        if( isBinaryFile( $f ) ) {
            return FTP_BINARY;
        } else {
            return FTP_ASCII;
        }

    }

    /**
     * FUNZIONI PER IL BROWSING DEL SERVER
     */

