#!/usr/bin/env python3
# -*- coding: utf-8 -*-

##  client MySQL minimale costruito sopra il comando mysql
#
#   Sulle macchine del framework Python non ha nessun driver MySQL installato ( né PyMySQL,
#   né MySQLdb, né mysql-connector ) e non c'è pip: installarne uno significherebbe
#   aggiungere una dipendenza a ogni deploy per uno strumento che serve solo alle demo e ai
#   collaudi. Si usa quindi il client mysql da riga di comando, che c'è sempre perché lo
#   usano già tutti gli script di _src/_sh/.
#
#   Rispetto a quegli script la password NON finisce mai sulla riga di comando ( dove
#   sarebbe leggibile da chiunque con un ps ): viene scritta in un file temporaneo con i
#   permessi 600 e passata con --defaults-extra-file, come fa _mysql.install.sh quando
#   trova /etc/mysql.remote.conf.

import datetime
import decimal
import os
import subprocess
import tempfile


class ErroreMysql( Exception ):

    pass


class Mysql( object ):

    ##  \brief connessione al server MySQL tramite il client da riga di comando

    def __init__( self, parametri, eseguibile = 'mysql', verboso = False ):

        self.parametri = parametri
        self.eseguibile = eseguibile
        self.verboso = verboso
        self.database = parametri[ 'db' ]

        gestore, self.file_credenziali = tempfile.mkstemp( prefix = 'glisweb.populate.', suffix = '.cnf' )

        os.close( gestore )
        os.chmod( self.file_credenziali, 0o600 )

        with open( self.file_credenziali, 'w', encoding = 'utf-8' ) as file_cnf:
            file_cnf.write( '[client]\n' )
            file_cnf.write( 'host=%s\n' % parametri[ 'address' ] )
            file_cnf.write( 'port=%s\n' % parametri[ 'port' ] )
            file_cnf.write( 'user=%s\n' % parametri[ 'username' ] )
            file_cnf.write( 'password=%s\n' % parametri[ 'password' ] )

    def chiudi( self ):

        if self.file_credenziali and os.path.exists( self.file_credenziali ):
            os.unlink( self.file_credenziali )
            self.file_credenziali = None

    def __enter__( self ):

        return self

    def __exit__( self, *argomenti ):

        self.chiudi()

    ## -----------------------------------------------------------------------------------
    ##  esecuzione
    ## -----------------------------------------------------------------------------------

    def _esegui( self, sql, argomenti_extra = () ):

        comando = [
            self.eseguibile,
            '--defaults-extra-file=%s' % self.file_credenziali,
            '--default-character-set=utf8',
        ] + list( argomenti_extra ) + [ self.database ]

        processo = subprocess.Popen(
            comando,
            stdin = subprocess.PIPE,
            stdout = subprocess.PIPE,
            stderr = subprocess.PIPE,
        )

        uscita, errore = processo.communicate( sql.encode( 'utf-8' ) )

        ##  gli avvisi sulla password non sono errori e non devono sporcare l'output
        errore = b'\n'.join(
            riga for riga in errore.split( b'\n' )
            if riga.strip() and b'Using a password on the command line' not in riga
        )

        if processo.returncode != 0:
            raise ErroreMysql( errore.decode( 'utf-8', 'replace' ).strip() or
                               'il client mysql è uscito con codice %d' % processo.returncode )

        if errore:
            raise ErroreMysql( errore.decode( 'utf-8', 'replace' ).strip() )

        return uscita.decode( 'utf-8', 'replace' )

    def seleziona( self, sql ):

        ##  \brief esegue una SELECT e ritorna una lista di dizionari

        uscita = self._esegui( sql, ( '--batch', ) )
        righe = uscita.split( '\n' )

        if not righe or not righe[ 0 ]:
            return []

        intestazione = righe[ 0 ].split( '\t' )
        risultato = []

        for riga in righe[ 1 : ]:

            if not riga:
                continue

            valori = riga.split( '\t' )
            record = {}

            for indice, colonna in enumerate( intestazione ):
                valore = valori[ indice ] if indice < len( valori ) else None
                record[ colonna ] = None if valore == 'NULL' else _dissolvi( valore )

            risultato.append( record )

        return risultato

    def valore( self, sql, predefinito = None ):

        ##  \brief esegue una SELECT e ritorna il primo valore della prima riga

        righe = self.seleziona( sql )

        if not righe:
            return predefinito

        prima = righe[ 0 ]

        return prima[ list( prima.keys() )[ 0 ] ]

    def colonna( self, sql ):

        ##  \brief esegue una SELECT e ritorna la prima colonna come lista

        return [ riga[ list( riga.keys() )[ 0 ] ] for riga in self.seleziona( sql ) ]

    def esegui_script( self, sql ):

        ##  \brief esegue uno script SQL completo

        self._esegui( sql )


## ---------------------------------------------------------------------------------------
##  quoting
## ---------------------------------------------------------------------------------------

_FUGHE = (
    ( '\\', '\\\\' ),
    ( "'", "\\'" ),
    ( '"', '\\"' ),
    ( '\n', '\\n' ),
    ( '\r', '\\r' ),
    ( '\t', '\\t' ),
    ( '\x00', '\\0' ),
    ( '\x1a', '\\Z' ),
)


def _dissolvi( valore ):

    ##  \brief annulla le fughe che il client mysql mette in --batch

    if valore is None or '\\' not in valore:
        return valore

    risultato = []
    fuga = False

    for carattere in valore:

        if fuga:
            risultato.append( { '0': '\x00', 'n': '\n', 't': '\t', 'r': '\r' }.get( carattere, carattere ) )
            fuga = False
        elif carattere == '\\':
            fuga = True
        else:
            risultato.append( carattere )

    return ''.join( risultato )


def virgoletta( valore ):

    ##  \brief rende un valore Python utilizzabile dentro una query

    if valore is None:
        return 'NULL'

    if isinstance( valore, bool ):
        return '1' if valore else '0'

    if isinstance( valore, ( int, float, decimal.Decimal ) ):
        return str( valore )

    if isinstance( valore, datetime.datetime ):
        valore = valore.strftime( '%Y-%m-%d %H:%M:%S' )
    elif isinstance( valore, datetime.date ):
        valore = valore.strftime( '%Y-%m-%d' )

    testo = str( valore )

    for carattere, fuga in _FUGHE:
        testo = testo.replace( carattere, fuga )

    return "'%s'" % testo


def nomina( identificatore ):

    ##  \brief racchiude un nome di tabella o di colonna negli apici inversi

    return '`%s`' % str( identificatore ).replace( '`', '``' )


def inserimento( tabella, righe, dimensione_lotto = 200 ):

    ##  \brief genera le INSERT multiriga per un elenco di dizionari omogenei
    #   \return una lista di istruzioni SQL, senza punto e virgola finale
    #
    #   Le righe possono avere chiavi diverse fra loro: vengono raggruppate per insieme di
    #   colonne, perché una INSERT multiriga vuole la stessa lista di colonne per tutte.

    if not righe:
        return []

    ##  le righe si raggruppano per insieme di colonne, non per sequenza: due righe con le
    ##  stesse colonne in ordine diverso finiscono nella stessa INSERT, e le righe che
    ##  hanno un campo opzionale in più fanno gruppo per conto loro. Raggruppare e basta,
    ##  riempiendo di NULL i buchi, sarebbe sbagliato: una colonna NOT NULL con un valore
    ##  predefinito si vedrebbe scrivere NULL invece di lasciar fare al database.
    gruppi = []
    indice_gruppi = {}

    for riga in righe:

        impronta = frozenset( riga.keys() )

        if impronta not in indice_gruppi:
            indice_gruppi[ impronta ] = len( gruppi )
            gruppi.append( ( tuple( riga.keys() ), [] ) )

        gruppi[ indice_gruppi[ impronta ] ][ 1 ].append( riga )

    istruzioni = []

    for chiavi, elenco in gruppi:

        colonne = ', '.join( nomina( chiave ) for chiave in chiavi )

        for inizio in range( 0, len( elenco ), dimensione_lotto ):

            lotto = elenco[ inizio : inizio + dimensione_lotto ]
            valori = ',\n    '.join(
                '( %s )' % ', '.join( virgoletta( riga[ chiave ] ) for chiave in chiavi )
                for riga in lotto
            )

            istruzioni.append( 'INSERT INTO %s ( %s ) VALUES\n    %s'
                               % ( nomina( tabella ), colonne, valori ) )

    return istruzioni
