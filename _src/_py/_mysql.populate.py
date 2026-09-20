#!/usr/bin/env python3
# -*- coding: utf-8 -*-

##  \file _mysql.populate.py
#   \brief popolamento del database con dati casuali verosimili, per le demo e i collaudi
#
#   Versione Python di _src/_sh/_mysql.populate.sh, che sapeva fare le anagrafiche e aveva
#   un ramo "catalogo" vuoto. Rispetto a quello:
#
#   - le credenziali si leggono dalla configurazione del deploy invece di chiederle a mano,
#     e non passano mai dalla riga di comando;
#   - si generano **entità**, non righe: un'anagrafica esce con i suoi recapiti, un prodotto
#     con i suoi articoli e i suoi prezzi, un documento con le sue righe e il suo pagamento.
#     Quello che rende una riga utilizzabile è marcato *obbligatorio* e non si toglie per
#     sbaglio;
#   - si scrive **solo** nelle tabelle gestite. Le tabelle standard ( comuni, lingue, IVA,
#     unità di misura, ruoli ) e quelle assistite ( tipologie, categorie, listini ) si
#     leggono per pescare valori coerenti, e non si toccano mai: il loro contenuto è parte
#     del framework o della configurazione del deploy;
#   - tutto il giro è una transazione sola, e con --secco si vede l'SQL senza eseguirlo.
#
#   \code
#   _src/_py/_mysql.populate.py --elenco
#   _src/_py/_mysql.populate.py anagrafica --quantita 200
#   _src/_py/_mysql.populate.py anagrafica catalogo documenti --svuota
#   _src/_py/_mysql.populate.py anagrafica --con iban,url --senza contatti --secco
#   \endcode

import argparse
import datetime
import importlib.util
import os
import sys


## ---------------------------------------------------------------------------------------
##  caricamento delle librerie di appoggio
## ---------------------------------------------------------------------------------------

##  le librerie seguono la convenzione di nome del framework ( _<nome>.<tipo>.py ), che non
##  è un nome di modulo Python valido: si caricano quindi a mano e si registrano in
##  sys.modules con il punto sostituito dal trattino basso, così possono importarsi fra loro
LIBRERIE = (
    '_casuali.tools.py',
    '_config.tools.py',
    '_mysql.tools.py',
    '_catalogo.tools.py',
    '_schema.tools.py',
    '_ricette.utils.py',
)


def _carica_librerie():

    ##  niente __pycache__: queste librerie stanno sotto la document root, e un file
    ##  generato lì dentro finisce fra i disallineamenti che _gw.upgrade.sh raccoglie ogni
    ##  notte ( e prima o poi nel suo rm -rf ./_* )
    sys.dont_write_bytecode = True

    cartella = os.path.join( os.path.dirname( os.path.abspath( __file__ ) ), '_lib' )
    moduli = {}

    for nome_file in LIBRERIE:

        percorso = os.path.join( cartella, nome_file )

        if not os.path.isfile( percorso ):
            raise SystemExit( 'manca la libreria %s' % percorso )

        nome_modulo = nome_file[ : -3 ].replace( '.', '_' )
        specifica = importlib.util.spec_from_file_location( nome_modulo, percorso )
        modulo = importlib.util.module_from_spec( specifica )

        sys.modules[ nome_modulo ] = modulo
        specifica.loader.exec_module( modulo )

        moduli[ nome_modulo ] = modulo

    return moduli


_moduli = _carica_librerie()

casuali_tools = _moduli[ '_casuali_tools' ]
config_tools = _moduli[ '_config_tools' ]
mysql_tools = _moduli[ '_mysql_tools' ]
catalogo_tools = _moduli[ '_catalogo_tools' ]
schema_tools = _moduli[ '_schema_tools' ]
ricette = _moduli[ '_ricette_utils' ]


## ---------------------------------------------------------------------------------------
##  riga di comando
## ---------------------------------------------------------------------------------------

def analizza_argomenti():

    analizzatore = argparse.ArgumentParser(
        prog = '_mysql.populate.py',
        formatter_class = argparse.RawDescriptionHelpFormatter,
        description = 'popola le tabelle gestite del database con dati casuali verosimili.',
        epilog = (
            'esempi:\n'
            '  %(prog)s --elenco\n'
            '  %(prog)s anagrafica --quantita 200\n'
            '  %(prog)s anagrafica catalogo documenti --svuota\n'
            '  %(prog)s anagrafica --con iban,url --senza contatti --secco\n'
            '  %(prog)s catalogo --quantita catalogo=120 --seme 7\n'
        ) )

    analizzatore.add_argument( 'entita', nargs = '*',
        help = 'entità da popolare; senza argomenti non fa niente e mostra l\'elenco' )

    analizzatore.add_argument( '--elenco', action = 'store_true',
        help = 'mostra entità, componenti e tabelle toccate, con la loro classificazione' )

    analizzatore.add_argument( '--quantita', default = None,
        help = 'quante entità principali: un numero per tutte, oppure nome=N separati da virgola' )

    analizzatore.add_argument( '--con', default = '',
        help = 'componenti opzionali da accendere ( nome oppure entita:nome, separati da virgola )' )

    analizzatore.add_argument( '--senza', default = '',
        help = 'componenti da spegnere ( gli obbligatori solo con --forza )' )

    analizzatore.add_argument( '--forza', action = 'store_true',
        help = 'consente di spegnere anche i componenti obbligatori' )

    analizzatore.add_argument( '--svuota', action = 'store_true',
        help = 'cancella prima i dati esistenti delle entità selezionate' )

    analizzatore.add_argument( '--secco', action = 'store_true',
        help = 'non scrive niente: stampa l\'SQL che eseguirebbe' )

    analizzatore.add_argument( '--sql', default = None, metavar = 'FILE',
        help = 'salva in un file l\'SQL generato' )

    analizzatore.add_argument( '--seme', type = int, default = None,
        help = 'seme del generatore casuale, per avere giri riproducibili' )

    analizzatore.add_argument( '--profilo', default = 'DEV', choices = ( 'DEV', 'TEST', 'PROD' ),
        help = 'profilo di configurazione da cui prendere il server ( default: DEV )' )

    analizzatore.add_argument( '--server', default = None,
        help = 'nome del server MySQL, se il profilo ne elenca più di uno' )

    analizzatore.add_argument( '--account', type = int, default = None,
        help = 'id dell\'account da scrivere in id_account_inserimento' )

    analizzatore.add_argument( '--si', action = 'store_true',
        help = 'non chiede conferma' )

    analizzatore.add_argument( '--radice', default = None,
        help = 'document root del deploy ( default: quella che contiene questo script )' )

    return analizzatore.parse_args(), analizzatore


def analizza_quantita( grezzo ):

    ##  \brief accetta sia "100" sia "anagrafica=100,catalogo=20"

    if not grezzo:
        return None, {}

    generale = None
    per_entita = {}

    for pezzo in grezzo.split( ',' ):

        pezzo = pezzo.strip()

        if not pezzo:
            continue

        if '=' in pezzo:
            nome, valore = pezzo.split( '=', 1 )
            per_entita[ nome.strip() ] = int( valore )
        else:
            generale = int( pezzo )

    return generale, per_entita


def analizza_componenti( grezzo ):

    ##  \brief accetta sia "iban" sia "anagrafica:iban"
    #   \return un dizionario { entità o None: insieme di nomi }

    selezione = {}

    for pezzo in ( grezzo or '' ).split( ',' ):

        pezzo = pezzo.strip()

        if not pezzo:
            continue

        if ':' in pezzo:
            entita, nome = pezzo.split( ':', 1 )
            selezione.setdefault( entita.strip(), set() ).add( nome.strip() )
        else:
            selezione.setdefault( None, set() ).add( pezzo )

    return selezione


def componenti_attivi( entita, con, senza, forza, problemi ):

    ##  \brief decide quali componenti di un'entità sono accesi

    attivi = entita.predefiniti()

    accesi = set( con.get( None, set() ) ) | set( con.get( entita.nome, set() ) )
    spenti = set( senza.get( None, set() ) ) | set( senza.get( entita.nome, set() ) )

    for nome in accesi:

        if nome in entita.componenti:
            attivi.add( nome )
        elif nome not in _tutti_i_componenti():
            problemi.append( 'il componente "%s" non esiste' % nome )

    for nome in spenti:

        if nome not in entita.componenti:
            if nome not in _tutti_i_componenti():
                problemi.append( 'il componente "%s" non esiste' % nome )
            continue

        componente = entita.componenti[ nome ]

        if componente.politica == ricette.OBBLIGATORIO and not forza:
            problemi.append(
                '%s:%s è obbligatorio — %s. Per toglierlo lo stesso serve --forza'
                % ( entita.nome, nome, componente.descrizione ) )
            continue

        attivi.discard( nome )

    return attivi


def _tutti_i_componenti():

    nomi = set()

    for entita in ricette.ENTITA.values():
        nomi |= set( entita.componenti.keys() )

    return nomi


## ---------------------------------------------------------------------------------------
##  presentazione
## ---------------------------------------------------------------------------------------

_SIMBOLI = {
    ricette.OBBLIGATORIO: '!',
    ricette.CONSIGLIATO: '+',
    ricette.OPZIONALE: '-',
}


def stampa_elenco():

    print( 'entità popolabili\n' )
    print( '  ! obbligatorio    + acceso di suo    - da chiedere con --con\n' )

    for entita in ricette.ENTITA.values():

        print( '  %-12s %s' % ( entita.nome, entita.descrizione ) )
        print( '  %-12s tabella principale: %s ( %s ), default %d'
               % ( '', entita.tabella, catalogo_tools.classifica( entita.tabella ),
                   entita.quantita_predefinita ) )

        if entita.dipende_da:
            print( '  %-12s vuole prima: %s' % ( '', ', '.join( entita.dipende_da ) ) )

        if entita.richiede:
            print( '  %-12s legge: %s' % ( '', ', '.join( entita.richiede ) ) )

        for componente in entita.componenti.values():

            print( '  %-12s   %s %-22s %s'
                   % ( '', _SIMBOLI[ componente.politica ], componente.nome, componente.descrizione ) )
            print( '  %-12s     %s' % ( '', ', '.join(
                '%s (%s)' % ( tabella, catalogo_tools.classifica( tabella ) )
                for tabella in componente.tabelle ) ) )

        print( '' )

    print( 'le tabelle standard e assistite si leggono per pescare tipologie, categorie e' )
    print( 'ruoli coerenti: questo strumento non ci scrive mai.' )


def stampa_riepilogo( piano, conteggi_svuotamento ):

    if conteggi_svuotamento:

        print( '\ncancellazione:' )

        for tabella, quante in conteggi_svuotamento:
            if quante:
                print( '  - %-32s %8d righe' % ( tabella, quante ) )

        if not any( quante for _, quante in conteggi_svuotamento ):
            print( '  ( niente da cancellare )' )

    print( '\ninserimento:' )

    totale = 0

    for tabella, quante in piano.conteggi().items():
        print( '  + %-32s %8d righe   (%s)' % ( tabella, quante, catalogo_tools.classifica( tabella ) ) )
        totale += quante

    if piano.aggiornamenti:
        print( '  ~ %-32s %8d istruzioni' % ( 'aggiornamenti di collegamento', len( piano.aggiornamenti ) ) )

    print( '  %-34s %8d righe in totale' % ( '', totale ) )


## ---------------------------------------------------------------------------------------
##  costruzione dell'SQL
## ---------------------------------------------------------------------------------------

def costruisci_sql( piano, passi_svuotamento, schema ):

    pezzi = [
        '-- generato da _src/_py/_mysql.populate.py il %s'
        % datetime.datetime.now().strftime( '%Y-%m-%d %H:%M:%S' ),
        'SET autocommit = 0;',
        'START TRANSACTION;',
    ]

    for passo in passi_svuotamento:

        for preparazione in passo[ 'preparazione' ]:
            pezzi.append( '%s;' % preparazione )

        pezzi.append( '%s;' % passo[ 'sql' ] )

    for tabella in schema.ordine_inserimento( piano.inserimenti ):

        for istruzione in mysql_tools.inserimento( tabella, piano.inserimenti[ tabella ] ):
            pezzi.append( '%s;' % istruzione )

    for aggiornamento in piano.aggiornamenti:
        pezzi.append( '%s;' % aggiornamento )

    pezzi.append( 'COMMIT;' )

    return '\n'.join( pezzi ) + '\n'


## ---------------------------------------------------------------------------------------
##  programma
## ---------------------------------------------------------------------------------------

def principale():

    opzioni, analizzatore = analizza_argomenti()

    if opzioni.elenco or not opzioni.entita:

        stampa_elenco()

        if not opzioni.entita and not opzioni.elenco:
            print( '\nnessuna entità indicata: non è stato fatto niente.' )
            analizzatore.print_usage()

        return 0

    ## -----------------------------------------------------------------------------------
    ##  entità richieste
    ## -----------------------------------------------------------------------------------

    sconosciute = [ nome for nome in opzioni.entita if nome not in ricette.ENTITA ]

    if sconosciute:
        print( 'entità sconosciute: %s' % ', '.join( sconosciute ), file = sys.stderr )
        print( 'quelle disponibili sono: %s' % ', '.join( ricette.ENTITA ), file = sys.stderr )
        return 2

    ##  si rispetta l'ordine del registro, non quello della riga di comando: le anagrafiche
    ##  devono esistere prima dei documenti che le usano
    selezionate = [ entita for nome, entita in ricette.ENTITA.items() if nome in opzioni.entita ]

    generale, per_entita = analizza_quantita( opzioni.quantita )
    con = analizza_componenti( opzioni.con )
    senza = analizza_componenti( opzioni.senza )

    problemi = []
    attivi_per_entita = {}

    for entita in selezionate:
        attivi_per_entita[ entita.nome ] = componenti_attivi( entita, con, senza, opzioni.forza, problemi )

    if problemi:
        for problema in problemi:
            print( 'errore: %s' % problema, file = sys.stderr )
        return 2

    ##  avvisi sulle dipendenze non selezionate: non è un errore, il generatore pesca
    ##  quello che trova già sul database, ma è bene dirlo
    for entita in selezionate:
        for dipendenza in entita.dipende_da:
            if dipendenza not in opzioni.entita:
                print( 'nota: %s si aggancerà a quello che trova già sul database per "%s"'
                       % ( entita.nome, dipendenza ) )

    ## -----------------------------------------------------------------------------------
    ##  configurazione e connessione
    ## -----------------------------------------------------------------------------------

    radice = opzioni.radice or config_tools.radice_document_root(
        os.path.join( os.path.dirname( os.path.abspath( __file__ ) ), '_lib', 'x' ) )

    configurazione, letti, avvisi = config_tools.carica( radice )

    for avviso in avvisi:
        print( 'attenzione: %s' % avviso, file = sys.stderr )

    if not letti:
        print( 'nessun file di configurazione trovato sotto %s' % radice, file = sys.stderr )
        return 2

    try:
        parametri = config_tools.parametri_mysql( configurazione, opzioni.profilo, opzioni.server )
    except ValueError as errore:
        print( 'errore: %s' % errore, file = sys.stderr )
        return 2

    print( 'deploy:  %s' % radice )
    print( 'config:  %s' % ', '.join( letti ) )
    print( 'server:  %s@%s:%s -> %s ( profilo %s )'
           % ( parametri[ 'username' ], parametri[ 'address' ], parametri[ 'port' ],
               parametri[ 'db' ], opzioni.profilo ) )

    mysql = mysql_tools.Mysql( parametri )

    try:
        return _lavora( opzioni, selezionate, attivi_per_entita, generale, per_entita, mysql )
    finally:
        mysql.chiudi()


def _lavora( opzioni, selezionate, attivi_per_entita, generale, per_entita, mysql ):

    try:
        schema = schema_tools.Schema( mysql )
    except mysql_tools.ErroreMysql as errore:
        print( 'errore leggendo lo schema: %s' % errore, file = sys.stderr )
        return 1

    casuali = casuali_tools.Casuali( opzioni.seme )

    id_account = opzioni.account

    if id_account is None:
        id_account = mysql.valore( 'SELECT MIN( id ) FROM account' )
        id_account = int( id_account ) if id_account is not None else None

    contesto = ricette.Contesto( mysql, schema, casuali, id_account )

    ## -----------------------------------------------------------------------------------
    ##  svuotamento: si pianifica prima di generare, perché gli id nuovi si contano dopo
    ## -----------------------------------------------------------------------------------

    passi_svuotamento = []
    conteggi_svuotamento = []

    if opzioni.svuota:

        obiettivi = [ entita.tabella for entita in selezionate ]
        passi_svuotamento = schema.piano_svuotamento( obiettivi, catalogo_tools.PROTETTE )

        for passo in passi_svuotamento:

            quante = mysql.valore( 'SELECT COUNT(*) FROM `%s`%s'
                                   % ( passo[ 'tabella' ],
                                       '' if passo[ 'dove' ] == '1' else ' WHERE %s' % passo[ 'dove' ] ) )

            conteggi_svuotamento.append( ( passo[ 'tabella' ], int( quante or 0 ) ) )

        ##  quello che sta per essere cancellato non si può più usare come riferimento
        contesto.tabelle_svuotate = set( passo[ 'tabella' ] for passo in passi_svuotamento )

        problemi = catalogo_tools.verifica_scrivibili( [ passo[ 'tabella' ] for passo in passi_svuotamento ] )

        if problemi:
            for problema in problemi:
                print( 'errore nello svuotamento: %s' % problema, file = sys.stderr )
            return 1

    ## -----------------------------------------------------------------------------------
    ##  generazione
    ## -----------------------------------------------------------------------------------

    ##  se si svuota, i contatori degli id vanno ricalcolati sul database svuotato: qui non
    ##  lo si può fare ( la cancellazione non è ancora avvenuta ), quindi si continua dagli
    ##  id attuali. Non è un problema, sono AUTO_INCREMENT e i buchi non danno fastidio.

    for entita in selezionate:

        quanti = per_entita.get( entita.nome, generale )

        if quanti is None:
            quanti = entita.quantita_predefinita

        contesto.attivi = attivi_per_entita[ entita.nome ]

        print( '\ngenero %s: %d %s con %s'
               % ( entita.nome, quanti, entita.tabella,
                   ', '.join( sorted( contesto.attivi ) ) or 'nessun componente' ) )

        try:
            entita.generatore( contesto, quanti )
        except mysql_tools.ErroreMysql as errore:
            print( 'errore interrogando il database: %s' % errore, file = sys.stderr )
            return 1

    for avviso in contesto.avvisi:
        print( 'attenzione: %s' % avviso, file = sys.stderr )

    piano = contesto.piano

    if piano.vuoto() and not passi_svuotamento:
        print( '\nnon c\'è niente da fare.' )
        return 0

    ## -----------------------------------------------------------------------------------
    ##  controllo di sicurezza: si scrive solo nelle tabelle gestite
    ## -----------------------------------------------------------------------------------

    problemi = catalogo_tools.verifica_scrivibili( piano.tabelle() )

    if problemi:
        print( '', file = sys.stderr )
        for problema in problemi:
            print( 'errore: %s' % problema, file = sys.stderr )
        return 1

    ## -----------------------------------------------------------------------------------
    ##  esecuzione
    ## -----------------------------------------------------------------------------------

    sql = costruisci_sql( piano, passi_svuotamento, schema )

    stampa_riepilogo( piano, conteggi_svuotamento )

    if opzioni.sql:

        with open( opzioni.sql, 'w', encoding = 'utf-8' ) as file_sql:
            file_sql.write( sql )

        print( '\nSQL salvato in %s ( %d KB )' % ( opzioni.sql, len( sql ) // 1024 ) )

    if opzioni.secco:
        print( '\n--secco: non è stato scritto niente.' )
        if not opzioni.sql:
            print( '\n%s' % sql )
        return 0

    if not opzioni.si:

        print( '' )

        try:
            risposta = input( 'procedo a scrivere sul database %s? (s/N) ' % mysql.database )
        except ( EOFError, KeyboardInterrupt ):
            print( '' )
            risposta = ''

        if risposta.strip().lower() not in ( 's', 'si', 'sì' ):
            print( 'annullato.' )
            return 1

    try:
        mysql.esegui_script( sql )
    except mysql_tools.ErroreMysql as errore:
        print( '\nerrore: %s' % errore, file = sys.stderr )
        print( 'la transazione non è stata confermata: il database non è stato modificato.',
               file = sys.stderr )
        return 1

    print( '\nfatto.' )

    return 0


if __name__ == '__main__':
    sys.exit( principale() )
