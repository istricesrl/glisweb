#!/usr/bin/env python3
# -*- coding: utf-8 -*-

##  lettura della configurazione del framework dai file JSON e YAML
#
#   Replica l'ordine di caricamento del bootstrap ( _src/_config.php ): prima i YAML e poi
#   i JSON, dentro ciascun gruppo prima ext/ e poi src/, prima config.* e poi shadow.*, con
#   fusione ricorsiva in cui l'ultimo file letto vince. È lo stesso ordine documentato in
#   _etc/_claude/_claude.framework.md, e va tenuto allineato a quello: le credenziali di un
#   deploy in produzione stanno nei file shadow, che non sono versionati.
#
#   Il modulo PyYAML non è richiesto: se manca e un file YAML esiste davvero, lo si segnala
#   invece di ignorarlo in silenzio, perché ignorarlo significherebbe collegarsi al server
#   sbagliato senza accorgersene.

import json
import os


##  ordine di lettura, dal meno al più prioritario
ORDINE_CONFIGURAZIONE = (
    'src/config/ext/config.yaml',
    'src/config/ext/shadow.yaml',
    'src/config.yaml',
    'src/shadow.yaml',
    'src/config/ext/config.json',
    'src/config/ext/shadow.json',
    'src/config.json',
    'src/shadow.json',
)


def radice_document_root( percorso_modulo ):

    ##  \brief risale dalla posizione di questa libreria alla document root del deploy
    #
    #   _src/_py/_lib/_config.tools.py -> tre livelli sopra

    return os.path.normpath( os.path.join( os.path.dirname( os.path.abspath( percorso_modulo ) ), '..', '..', '..' ) )


def fondi( destinazione, sorgente ):

    ##  \brief equivalente di array_replace_recursive() di PHP

    for chiave, valore in sorgente.items():

        if ( chiave in destinazione
                and isinstance( destinazione[ chiave ], dict )
                and isinstance( valore, dict ) ):
            fondi( destinazione[ chiave ], valore )
        else:
            destinazione[ chiave ] = valore

    return destinazione


def carica( radice ):

    ##  \brief legge e fonde tutti i file di configurazione presenti
    #   \return una tupla ( configurazione, file letti, avvisi )

    configurazione = {}
    letti = []
    avvisi = []

    for relativo in ORDINE_CONFIGURAZIONE:

        percorso = os.path.join( radice, relativo )

        if not os.path.isfile( percorso ):
            continue

        if percorso.endswith( '.yaml' ):

            try:
                import yaml
            except ImportError:
                avvisi.append( 'il file %s esiste ma PyYAML non è installato: NON è stato letto' % relativo )
                continue

            with open( percorso, 'r', encoding = 'utf-8' ) as gestore:
                contenuto = yaml.safe_load( gestore ) or {}

        else:

            with open( percorso, 'r', encoding = 'utf-8' ) as gestore:
                contenuto = json.load( gestore ) or {}

        if not isinstance( contenuto, dict ):
            avvisi.append( 'il file %s non contiene un oggetto: ignorato' % relativo )
            continue

        fondi( configurazione, contenuto )
        letti.append( relativo )

    return configurazione, letti, avvisi


def parametri_mysql( configurazione, profilo = 'DEV', server = None ):

    ##  \brief estrae i parametri di connessione di un server MySQL
    #   \param profilo DEV, TEST o PROD
    #   \param server nome del server; se assente si prende il primo del profilo

    mysql = configurazione.get( 'mysql' ) or {}
    servers = mysql.get( 'servers' ) or {}
    profiles = mysql.get( 'profiles' ) or {}

    if not servers:
        raise ValueError( 'nessun server MySQL configurato' )

    if server is None:

        elenco = ( profiles.get( profilo ) or {} ).get( 'servers' ) or []

        if not elenco:
            raise ValueError( 'il profilo %s non elenca nessun server MySQL' % profilo )

        server = elenco[ 0 ]

    if server not in servers:
        raise ValueError( 'il server MySQL "%s" non è configurato ( disponibili: %s )'
                          % ( server, ', '.join( sorted( servers ) ) ) )

    parametri = dict( servers[ server ] )
    parametri[ 'nome' ] = server

    for obbligatoria in ( 'address', 'username', 'db' ):
        if not parametri.get( obbligatoria ):
            raise ValueError( 'al server MySQL "%s" manca la chiave %s' % ( server, obbligatoria ) )

    parametri.setdefault( 'port', '3306' )
    parametri.setdefault( 'password', '' )

    return parametri
