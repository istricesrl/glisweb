#!/usr/bin/env python3
# -*- coding: utf-8 -*-

##  le ricette: cosa vuol dire "popolare" ciascuna entità
#
#   Questa libreria è "utils" e non "tools" perché dipende dal contesto: per scrivere
#   un'anagrafica verosimile bisogna sapere quali tipologie, categorie e ruoli esistono
#   davvero su *questo* deploy, e quelli stanno nelle tabelle assistite e standard.
#
#   L'idea di fondo è che un'entità non è una tabella: è una tabella principale più il
#   corredo senza cui quella riga non vuol dire niente. Un'anagrafica senza un recapito non
#   è un'anagrafica, è una riga; un prodotto senza articoli non si può vendere; un
#   documento senza righe non si può stampare. Per questo ogni componente ha una politica:
#
#   - **obbligatorio**: senza, l'entità sarebbe monca. Si può togliere solo con --forza, e
#     lo strumento lo dice a voce alta;
#   - **consigliato**: attivo se non lo si toglie. È quello che serve perché una demo
#     sembri una demo e non un database vuoto con dentro dei nomi;
#   - **opzionale**: spento se non lo si chiede. Roba che in un archivio vero c'è su una
#     minoranza delle righe ( IBAN, cittadinanze, seconde sedi ), e che messa su tutte fa
#     sembrare i dati finti, che è esattamente il difetto da evitare.

import collections
import datetime


OBBLIGATORIO = 'obbligatorio'
CONSIGLIATO = 'consigliato'
OPZIONALE = 'opzionale'

##  quota di anagrafiche che sono persone giuridiche
QUOTA_AZIENDE = 0.35


## ---------------------------------------------------------------------------------------
##  strutture
## ---------------------------------------------------------------------------------------

class Componente( object ):

    def __init__( self, nome, politica, tabelle, descrizione ):

        self.nome = nome
        self.politica = politica
        self.tabelle = tuple( tabelle )
        self.descrizione = descrizione


class Entita( object ):

    def __init__( self, nome, descrizione, tabella, quantita_predefinita, componenti,
                  richiede = (), dipende_da = (), generatore = None ):

        self.nome = nome
        self.descrizione = descrizione
        self.tabella = tabella
        self.quantita_predefinita = quantita_predefinita
        self.componenti = collections.OrderedDict( ( c.nome, c ) for c in componenti )
        self.richiede = tuple( richiede )
        self.dipende_da = tuple( dipende_da )
        self.generatore = generatore

    def tabelle( self ):

        elenco = [ self.tabella ]

        for componente in self.componenti.values():
            for tabella in componente.tabelle:
                if tabella not in elenco:
                    elenco.append( tabella )

        return elenco

    def predefiniti( self ):

        return set( nome for nome, componente in self.componenti.items()
                    if componente.politica in ( OBBLIGATORIO, CONSIGLIATO ) )


class Piano( object ):

    ##  \brief l'insieme delle righe da scrivere, in ordine di dipendenza

    def __init__( self ):

        self.inserimenti = collections.OrderedDict()
        self.aggiornamenti = []

    def aggiungi( self, tabella, riga ):

        self.inserimenti.setdefault( tabella, [] ).append( riga )

        return riga

    def aggiorna( self, sql ):

        self.aggiornamenti.append( sql )

    def tabelle( self ):

        return list( self.inserimenti.keys() )

    def conteggi( self ):

        return collections.OrderedDict(
            ( tabella, len( righe ) ) for tabella, righe in self.inserimenti.items() )

    def vuoto( self ):

        return not self.inserimenti and not self.aggiornamenti


class Contesto( object ):

    ##  \brief quello che una ricetta ha bisogno di sapere mentre genera

    def __init__( self, mysql, schema, casuali, id_account = None, ora = None ):

        self.mysql = mysql
        self.schema = schema
        self.casuali = casuali
        self.id_account = id_account
        self.ora = ora or int( datetime.datetime.now().timestamp() )
        self.piano = Piano()
        self.attivi = set()
        self.memoria = {}
        self.avvisi = []
        self.tabelle_svuotate = set()
        self._cache = {}

    ## -----------------------------------------------------------------------------------
    ##  componenti
    ## -----------------------------------------------------------------------------------

    def attivo( self, nome ):

        return nome in self.attivi

    def da_database( self, tabella ):

        ##  \brief vero se le righe già presenti in questa tabella si possono ancora usare
        #
        #   Con --svuota non si possono: stanno per essere cancellate nella stessa
        #   transazione, e agganciarci una riga nuova vorrebbe dire scrivere un
        #   riferimento a qualcosa che un'istruzione più su non esiste più. È il difetto
        #   che faceva iscrivere alle liste i centoquaranta indirizzi in partenza.

        return tabella not in self.tabelle_svuotate

    ## -----------------------------------------------------------------------------------
    ##  letture di riferimento
    ## -----------------------------------------------------------------------------------

    def righe( self, chiave, sql ):

        ##  \brief esegue una query una volta sola e ne tiene il risultato

        if chiave not in self._cache:
            self._cache[ chiave ] = self.mysql.seleziona( sql )

        return self._cache[ chiave ]

    def identificativi( self, tabella, dove = None, limite = 5000 ):

        chiave = 'ids:%s:%s' % ( tabella, dove or '' )
        sql = 'SELECT `%s` AS id FROM `%s`%s LIMIT %d' % (
            self.schema.chiave_primaria( tabella ), tabella,
            ' WHERE %s' % dove if dove else '', limite )

        return [ _numerico( riga[ 'id' ] ) for riga in self.righe( chiave, sql ) ]

    def per_nome( self, tabella, nome, colonna = 'nome' ):

        ##  \brief identificativo di una riga cercata per nome, None se non c'è

        chiave = 'nome:%s:%s:%s' % ( tabella, colonna, nome )
        sql = "SELECT `%s` AS id FROM `%s` WHERE `%s` = %s LIMIT 1" % (
            self.schema.chiave_primaria( tabella ), tabella, colonna, _virgoletta( nome ) )

        righe = self.righe( chiave, sql )

        return _numerico( righe[ 0 ][ 'id' ] ) if righe else None

    def primo_per_nome( self, tabella, nomi, ripiego_qualunque = True ):

        ##  \brief il primo dei nomi indicati che esiste davvero
        #
        #   Serve perché i deploy non hanno tutti le stesse tipologie: si prova con quelle
        #   che lo standard installa e, se non ce n'è nessuna, si ripiega su una qualunque
        #   riga della tabella invece di lasciare il campo vuoto.

        for nome in nomi:

            identificativo = self.per_nome( tabella, nome )

            if identificativo is not None:
                return identificativo

        if ripiego_qualunque:

            identificativi = self.identificativi( tabella, limite = 1 )

            if identificativi:
                return identificativi[ 0 ]

        return None

    def conta( self, tabella ):

        return int( self.mysql.valore( 'SELECT COUNT(*) FROM `%s`' % tabella ) or 0 )

    ## -----------------------------------------------------------------------------------
    ##  tempo
    ## -----------------------------------------------------------------------------------

    def timestamp_recente( self, giorni_indietro_massimi = 730 ):

        return self.ora - self.casuali.intero( 0, giorni_indietro_massimi ) * 86400 \
                        - self.casuali.intero( 0, 86399 )

    def data_da_timestamp( self, timestamp ):

        return datetime.date.fromtimestamp( timestamp )

    def tracce( self, timestamp = None ):

        ##  \brief le colonne di servizio che tutte le tabelle del framework hanno

        timestamp = timestamp if timestamp is not None else self.timestamp_recente()

        return {
            'id_account_inserimento': self.id_account,
            'timestamp_inserimento': timestamp,
        }

    ## -----------------------------------------------------------------------------------
    ##  scrittura nel piano
    ## -----------------------------------------------------------------------------------

    def inserisci( self, tabella, riga ):

        ##  \brief mette una riga nel piano, filtrando le colonne che non esistono

        pulita = self.schema.filtra( tabella, riga )

        for colonna, valore in list( pulita.items() ):
            if isinstance( valore, str ):
                pulita[ colonna ] = self.schema.tronca( tabella, colonna, valore )

        return self.piano.aggiungi( tabella, pulita )


def _numerico( valore ):

    ##  \brief riporta a intero gli identificativi, che il client mysql ritorna come testo

    if valore is None or isinstance( valore, int ):
        return valore

    try:
        return int( valore )
    except ( TypeError, ValueError ):
        return valore


def _virgoletta( testo ):

    return "'%s'" % str( testo ).replace( '\\', '\\\\' ).replace( "'", "\\'" )


## ---------------------------------------------------------------------------------------
##  anagrafica
## ---------------------------------------------------------------------------------------

def genera_anagrafica( contesto, quantita ):

    casuali = contesto.casuali
    schema = contesto.schema

    ##  riferimenti: tutto quello che si pesca dalle tabelle standard e assistite
    tipologia_fisica = contesto.primo_per_nome( 'tipologie_anagrafica', ( 'persone fisiche', ), False )
    tipologia_giuridica = contesto.primo_per_nome( 'tipologie_anagrafica', ( 'persone giuridiche', ), False )

    tipologia_telefono = contesto.primo_per_nome( 'tipologie_telefoni', ( 'telefono', ), False )
    tipologia_mobile = contesto.primo_per_nome( 'tipologie_telefoni', ( 'mobile', ), False )
    tipologia_fax = contesto.primo_per_nome( 'tipologie_telefoni', ( 'fax', ), False )

    ruolo_mail_generica = contesto.primo_per_nome( 'ruoli_mail', ( 'generica', ), False )
    ruolo_mail_amministrazione = contesto.primo_per_nome( 'ruoli_mail', ( 'amministrazione', ), False )

    ruolo_sede_legale = contesto.primo_per_nome( 'ruoli_indirizzi', ( 'sede legale', ), False )
    ruolo_residenza = contesto.primo_per_nome( 'ruoli_indirizzi', ( 'residenza', 'casa' ), False )

    tipologia_sito = contesto.primo_per_nome( 'tipologie_url', ( 'sito web', ), False )

    categorie = contesto.identificativi( 'categorie_anagrafica' )
    regimi = contesto.identificativi( 'regimi' )
    ranking = contesto.identificativi( 'ranking' )
    settori = contesto.identificativi( 'settori', limite = 500 )
    ruoli_anagrafica = contesto.identificativi( 'ruoli_anagrafica' )
    stato_italia = contesto.per_nome( 'stati', 'IT', 'iso31661alpha2' )

    comuni = contesto.righe(
        'comuni:campione',
        'SELECT id, nome, codice_catasto FROM comuni'
        ' WHERE codice_catasto IS NOT NULL ORDER BY RAND() LIMIT 400' )

    tipologie_strada = contesto.righe(
        'tipologie_indirizzi:tutte', 'SELECT id, nome FROM tipologie_indirizzi' )
    strade_per_nome = dict( ( riga[ 'nome' ], riga[ 'id' ] ) for riga in tipologie_strada )

    if not comuni:
        contesto.avvisi.append( 'la tabella comuni è vuota: niente comune di nascita e niente codice fiscale' )

    persone = []
    aziende = []
    indirizzi_visti = set()

    for _ in range( quantita ):

        giuridica = casuali.forse( QUOTA_AZIENDE )
        id_anagrafica = schema.prossimo_id( 'anagrafica' )
        inserimento = contesto.timestamp_recente()

        riga = {
            'id': id_anagrafica,
            'codice': 'DEMO.%06d' % id_anagrafica,
            'note': casuali.frase(),
            'se_stampa_privacy': 1,
        }

        riga.update( contesto.tracce( inserimento ) )

        if ranking and casuali.forse( 0.4 ):
            riga[ 'id_ranking' ] = casuali.scegli( ranking )

        if giuridica:

            denominazione = casuali.denominazione()
            partita_iva = casuali.partita_iva()

            riga.update( {
                'id_tipologia': tipologia_giuridica,
                'denominazione': denominazione,
                'partita_iva': partita_iva,
                'codice_fiscale': partita_iva,
                'codice_sdi': casuali.codice_sdi(),
                'riferimento': '%s %s' % ( casuali.nome( casuali.sesso() ), casuali.cognome() ),
                'note_commerciali': casuali.frase(),
            } )

            if regimi:
                riga[ 'id_regime' ] = casuali.scegli( regimi )

            etichetta = denominazione
            dominio = casuali.dominio( denominazione.split()[ 0 ] )

        else:

            sesso = casuali.sesso()
            nome = casuali.nome( sesso )
            cognome = casuali.cognome()
            giorno, mese, anno = casuali.data_nascita()
            comune = casuali.scegli( comuni ) if comuni else None

            riga.update( {
                'id_tipologia': tipologia_fisica,
                'nome': nome,
                'cognome': cognome,
                'sesso': sesso,
                'giorno_nascita': giorno,
                'mese_nascita': mese,
                'anno_nascita': anno,
            } )

            if comune:
                riga[ 'comune_nascita' ] = comune[ 'nome' ]
                riga[ 'id_comune_nascita' ] = comune[ 'id' ]
                riga[ 'id_stato_nascita' ] = stato_italia
                riga[ 'codice_fiscale' ] = casuali.codice_fiscale(
                    nome, cognome, giorno, mese, anno, sesso, comune[ 'codice_catasto' ] )

            etichetta = '%s %s' % ( nome, cognome )
            dominio = None

        contesto.inserisci( 'anagrafica', riga )

        scheda = {
            'id': id_anagrafica,
            'giuridica': giuridica,
            'etichetta': etichetta,
            'dominio': dominio,
            'timestamp': inserimento,
        }

        ( aziende if giuridica else persone ).append( scheda )

        ## -------------------------------------------------------------------------------
        ##  mail: obbligatorio, un'anagrafica senza recapito non serve a niente
        ## -------------------------------------------------------------------------------

        if contesto.attivo( 'mail' ):

            if giuridica:

                indirizzo = casuali.mail_ufficio( dominio, 'info' )
                id_mail = schema.prossimo_id( 'mail' )

                riga_mail = {
                    'id': id_mail,
                    'id_anagrafica': id_anagrafica,
                    'id_ruolo': ruolo_mail_generica,
                    'indirizzo': indirizzo,
                    'se_notifiche': 1,
                }
                riga_mail.update( contesto.tracce( inserimento ) )
                contesto.inserisci( 'mail', riga_mail )
                scheda[ 'id_mail' ] = id_mail

                if casuali.forse( 0.5 ):

                    riga_mail = {
                        'id': schema.prossimo_id( 'mail' ),
                        'id_anagrafica': id_anagrafica,
                        'id_ruolo': ruolo_mail_amministrazione,
                        'indirizzo': casuali.mail_ufficio( dominio, 'amministrazione' ),
                    }
                    riga_mail.update( contesto.tracce( inserimento ) )
                    contesto.inserisci( 'mail', riga_mail )

                if casuali.forse( 0.45 ):

                    ##  la PEC è anche l'indirizzo per lo SDI: la si aggancia all'anagrafica
                    ##  con un UPDATE in coda, perché i due riferimenti sono incrociati
                    id_pec = schema.prossimo_id( 'mail' )

                    riga_mail = {
                        'id': id_pec,
                        'id_anagrafica': id_anagrafica,
                        'indirizzo': casuali.mail_ufficio( dominio, 'pec' ),
                        'se_pec': 1,
                    }
                    riga_mail.update( contesto.tracce( inserimento ) )
                    contesto.inserisci( 'mail', riga_mail )
                    contesto.piano.aggiorna(
                        'UPDATE `anagrafica` SET `id_pec_sdi` = %d WHERE `id` = %d' % ( id_pec, id_anagrafica ) )

            else:

                id_mail = schema.prossimo_id( 'mail' )

                riga_mail = {
                    'id': id_mail,
                    'id_anagrafica': id_anagrafica,
                    'id_ruolo': ruolo_mail_generica,
                    'indirizzo': casuali.mail_persona( riga[ 'nome' ], riga[ 'cognome' ] ),
                    'se_notifiche': 1,
                }
                riga_mail.update( contesto.tracce( inserimento ) )
                contesto.inserisci( 'mail', riga_mail )
                scheda[ 'id_mail' ] = id_mail

        ## -------------------------------------------------------------------------------
        ##  telefoni: obbligatorio, per lo stesso motivo
        ## -------------------------------------------------------------------------------

        if contesto.attivo( 'telefoni' ):

            numeri = [ ( casuali.telefono_fisso(), tipologia_telefono ) ]

            if casuali.forse( 0.75 ):
                numeri.append( ( casuali.telefono_mobile(), tipologia_mobile ) )

            if giuridica and casuali.forse( 0.3 ):
                numeri.append( ( casuali.telefono_fisso(), tipologia_fax ) )

            for numero, tipologia in numeri:

                riga_telefono = {
                    'id': schema.prossimo_id( 'telefoni' ),
                    'id_anagrafica': id_anagrafica,
                    'id_tipologia': tipologia,
                    'numero': numero,
                    'se_notifiche': 1 if tipologia == tipologia_mobile else 0,
                }
                riga_telefono.update( contesto.tracce( inserimento ) )
                contesto.inserisci( 'telefoni', riga_telefono )

        ## -------------------------------------------------------------------------------
        ##  indirizzi
        ## -------------------------------------------------------------------------------

        if contesto.attivo( 'indirizzi' ) and comuni:

            comune = casuali.scegli( comuni )
            parola_strada = casuali.tipologia_strada()
            toponimo = casuali.toponimo()
            civico = casuali.civico()
            cap = casuali.cap()

            impronta = ( comune[ 'id' ], toponimo, civico, cap )

            if impronta not in indirizzi_visti:

                indirizzi_visti.add( impronta )
                id_indirizzo = schema.prossimo_id( 'indirizzi' )

                riga_indirizzo = {
                    'id': id_indirizzo,
                    'id_tipologia': strade_per_nome.get( parola_strada ),
                    'id_comune': comune[ 'id' ],
                    'localita': comune[ 'nome' ],
                    'indirizzo': toponimo,
                    'civico': civico,
                    'cap': cap,
                }
                riga_indirizzo.update( contesto.tracce( inserimento ) )
                contesto.inserisci( 'indirizzi', riga_indirizzo )

                riga_relazione = {
                    'id': schema.prossimo_id( 'anagrafica_indirizzi' ),
                    'id_anagrafica': id_anagrafica,
                    'id_indirizzo': id_indirizzo,
                    'id_ruolo': ruolo_sede_legale if giuridica else ruolo_residenza,
                    'indirizzo': '%s %s %s, %s %s' % ( parola_strada, toponimo, civico, cap, comune[ 'nome' ] ),
                }
                riga_relazione.update( contesto.tracce( inserimento ) )
                contesto.inserisci( 'anagrafica_indirizzi', riga_relazione )

                scheda[ 'id_indirizzo' ] = id_indirizzo

        ## -------------------------------------------------------------------------------
        ##  categorie
        ## -------------------------------------------------------------------------------

        if contesto.attivo( 'categorie' ) and categorie:

            for ordine, id_categoria in enumerate( casuali.scegli_molti( categorie, 1, 2 ) ):

                riga_categoria = {
                    'id': schema.prossimo_id( 'anagrafica_categorie' ),
                    'id_anagrafica': id_anagrafica,
                    'id_categoria': id_categoria,
                    'ordine': ordine + 1,
                }
                riga_categoria.update( contesto.tracce( inserimento ) )
                contesto.inserisci( 'anagrafica_categorie', riga_categoria )

        ## -------------------------------------------------------------------------------
        ##  componenti opzionali
        ## -------------------------------------------------------------------------------

        if contesto.attivo( 'url' ) and giuridica and tipologia_sito:

            riga_url = {
                'id': schema.prossimo_id( 'url' ),
                'id_tipologia': tipologia_sito,
                'id_anagrafica': id_anagrafica,
                'url': casuali.url_sito( dominio ),
                'nome': 'sito istituzionale',
            }
            riga_url.update( contesto.tracce( inserimento ) )
            contesto.inserisci( 'url', riga_url )

        if contesto.attivo( 'iban' ) and casuali.forse( 0.6 ):

            riga_iban = {
                'id': schema.prossimo_id( 'iban' ),
                'id_anagrafica': id_anagrafica,
                'intestazione': etichetta,
                'iban': casuali.iban_italiano(),
            }
            riga_iban.update( contesto.tracce( inserimento ) )
            contesto.inserisci( 'iban', riga_iban )

        if contesto.attivo( 'settori' ) and giuridica and settori:

            riga_settore = {
                'id': schema.prossimo_id( 'anagrafica_settori' ),
                'id_anagrafica': id_anagrafica,
                'id_settore': casuali.scegli( settori ),
                'ordine': 1,
            }
            riga_settore.update( contesto.tracce( inserimento ) )
            contesto.inserisci( 'anagrafica_settori', riga_settore )

        if contesto.attivo( 'cittadinanze' ) and not giuridica and stato_italia:

            riga_cittadinanza = {
                'id': schema.prossimo_id( 'anagrafica_cittadinanze' ),
                'id_anagrafica': id_anagrafica,
                'id_stato': stato_italia,
                'ordine': 1,
            }
            riga_cittadinanza.update( contesto.tracce( inserimento ) )
            contesto.inserisci( 'anagrafica_cittadinanze', riga_cittadinanza )

    ## -----------------------------------------------------------------------------------
    ##  relazioni fra persone e aziende: si fanno alla fine, quando ci sono tutte
    ## -----------------------------------------------------------------------------------

    if contesto.attivo( 'relazioni' ) and persone and aziende and ruoli_anagrafica:

        ruolo_dipendente = contesto.primo_per_nome( 'ruoli_anagrafica', ( 'dipendente', 'collega' ) )

        for persona in persone:

            if not casuali.forse( 0.45 ):
                continue

            azienda = casuali.scegli( aziende )

            riga_relazione = {
                'id': schema.prossimo_id( 'relazioni_anagrafica' ),
                'id_anagrafica': azienda[ 'id' ],
                'id_anagrafica_collegata': persona[ 'id' ],
                'id_ruolo': ruolo_dipendente,
            }
            riga_relazione.update( contesto.tracce() )
            contesto.inserisci( 'relazioni_anagrafica', riga_relazione )

    ## -----------------------------------------------------------------------------------
    ##  contatti
    ## -----------------------------------------------------------------------------------

    if contesto.attivo( 'contatti' ):

        tipologia_contatto = contesto.primo_per_nome( 'tipologie_contatti', ( 'richiesta di informazioni', 'contatto' ) )

        for scheda in persone + aziende:

            if not casuali.forse( 0.3 ):
                continue

            momento = contesto.timestamp_recente( 365 )

            riga_contatto = {
                'id': schema.prossimo_id( 'contatti' ),
                'id_tipologia': tipologia_contatto,
                'id_anagrafica': scheda[ 'id' ],
                'nome': 'richiesta da %s' % scheda[ 'etichetta' ],
                'note': casuali.paragrafo(),
                'timestamp_contatto': momento,
                'utm_source': casuali.scegli( ( 'google', 'newsletter', 'diretto', 'facebook' ) ),
                'utm_medium': casuali.scegli( ( 'organic', 'cpc', 'email', 'referral' ) ),
            }
            riga_contatto.update( contesto.tracce( momento ) )
            contesto.inserisci( 'contatti', riga_contatto )

    contesto.memoria[ 'anagrafica' ] = persone + aziende
    contesto.memoria[ 'aziende' ] = aziende
    contesto.memoria[ 'persone' ] = persone


## ---------------------------------------------------------------------------------------
##  catalogo
## ---------------------------------------------------------------------------------------

def genera_catalogo( contesto, quantita ):

    casuali = contesto.casuali
    schema = contesto.schema

    tipologie_prodotto = contesto.identificativi( 'tipologie_prodotti' )
    id_listino = contesto.primo_per_nome( 'listini', ( 'DEFAULT', ) )
    id_iva = contesto.primo_per_nome( 'iva', ( 'IVA 22%', ) )
    id_lingua = contesto.per_nome( 'lingue', 'it-IT', 'ietf' ) or contesto.per_nome( 'lingue', 'italiano' )
    id_reparto = contesto.identificativi( 'reparti', limite = 1 )
    id_reparto = id_reparto[ 0 ] if id_reparto else None
    id_udm = contesto.primo_per_nome( 'udm', ( 'pezzo', 'unità', 'numero' ) )

    aliquota = contesto.mysql.valore(
        'SELECT aliquota FROM iva WHERE id = %s' % ( id_iva if id_iva else 0 ) ) or 22

    try:
        aliquota = float( aliquota )
    except ( TypeError, ValueError ):
        aliquota = 22.0

    if id_listino is None:
        contesto.avvisi.append( 'nessun listino: i prezzi non verranno generati' )

    ## -----------------------------------------------------------------------------------
    ##  marchi
    ## -----------------------------------------------------------------------------------

    marchi = contesto.identificativi( 'marchi' )

    ##  i dati di riferimento si creano solo se mancano: due giri di seguito non devono
    ##  lasciare due alberi di categorie e dodici marchi
    if contesto.attivo( 'marchi' ) and not marchi:

        esistenti = set( riga[ 'nome' ] for riga in
                         contesto.righe( 'marchi:nomi', 'SELECT nome FROM marchi' ) )

        for _ in range( 6 ):

            nome = casuali.nome_marchio()

            if nome in esistenti:
                continue

            esistenti.add( nome )
            id_marchio = schema.prossimo_id( 'marchi' )

            riga_marchio = { 'id': id_marchio, 'nome': nome, 'note': casuali.frase() }
            riga_marchio.update( contesto.tracce() )
            contesto.inserisci( 'marchi', riga_marchio )
            marchi.append( id_marchio )

    ## -----------------------------------------------------------------------------------
    ##  categorie
    ## -----------------------------------------------------------------------------------

    categorie = contesto.identificativi( 'categorie_prodotti' )

    if contesto.attivo( 'categorie' ) and not categorie:

        for radice in ( 'componenti', 'attrezzature', 'ricambi' ):

            id_radice = schema.prossimo_id( 'categorie_prodotti' )

            riga_categoria = {
                'id': id_radice,
                'codice': 'demo-%s' % radice,
                'nome': radice,
                'ordine': 1,
                'se_sitemap': 1,
                'se_cacheable': 1,
                'note': casuali.frase(),
            }
            riga_categoria.update( contesto.tracce() )
            contesto.inserisci( 'categorie_prodotti', riga_categoria )
            categorie.append( id_radice )

            for ordine in range( casuali.intero( 2, 3 ) ):

                id_figlia = schema.prossimo_id( 'categorie_prodotti' )
                nome_figlia = '%s %s' % ( radice, casuali.scegli( ( 'in acciaio', 'in alluminio',
                                                                    'su misura', 'a catalogo',
                                                                    'per esterni' ) ) )

                riga_figlia = {
                    'id': id_figlia,
                    'id_genitore': id_radice,
                    'codice': 'demo-%s-%d' % ( radice, ordine + 1 ),
                    'nome': nome_figlia,
                    'ordine': ordine + 1,
                    'se_sitemap': 1,
                    'se_cacheable': 1,
                }
                riga_figlia.update( contesto.tracce() )
                contesto.inserisci( 'categorie_prodotti', riga_figlia )
                categorie.append( id_figlia )

    ## -----------------------------------------------------------------------------------
    ##  caratteristiche
    ## -----------------------------------------------------------------------------------

    caratteristiche = []

    if contesto.attivo( 'caratteristiche' ):

        esistenti = set( riga[ 'nome' ] for riga in
                         contesto.righe( 'caratteristiche:nomi', 'SELECT nome FROM caratteristiche' ) )

        for nome in ( 'materiale', 'finitura', 'grado di protezione', 'temperatura di esercizio' ):

            if nome in esistenti:
                continue

            id_caratteristica = schema.prossimo_id( 'caratteristiche' )

            riga_caratteristica = { 'id': id_caratteristica, 'nome': nome, 'se_prodotto': 1 }
            riga_caratteristica.update( contesto.tracce() )
            contesto.inserisci( 'caratteristiche', riga_caratteristica )
            caratteristiche.append( id_caratteristica )

        caratteristiche += contesto.identificativi( 'caratteristiche', 'se_prodotto = 1' )

    ## -----------------------------------------------------------------------------------
    ##  prodotti, articoli, prezzi
    ## -----------------------------------------------------------------------------------

    progressivo_prodotto = contesto.conta( 'prodotti' )
    progressivo_articolo = contesto.conta( 'articoli' )
    articoli_generati = []

    tipologia_pubblicata = contesto.primo_per_nome( 'tipologie_pubblicazioni', ( 'pubblicato', ) )

    for _ in range( quantita ):

        progressivo_prodotto += 1
        id_prodotto = 'DEMO.PRD.%05d' % progressivo_prodotto
        inserimento = contesto.timestamp_recente()
        nome_prodotto = casuali.nome_prodotto()

        riga_prodotto = {
            'id': id_prodotto,
            'id_tipologia': casuali.scegli( tipologie_prodotto ) if tipologie_prodotto else None,
            'nome': nome_prodotto,
            'note': casuali.paragrafo(),
            'se_sitemap': 1,
            'se_cacheable': 1,
            'id_marchio': casuali.scegli( marchi ) if marchi else None,
            'codice_produttore': 'P%06d' % casuali.intero( 1, 999999 ),
        }
        riga_prodotto.update( contesto.tracce( inserimento ) )
        contesto.inserisci( 'prodotti', riga_prodotto )

        ##  categorie: obbligatorio, un prodotto fuori dall'albero non si trova
        if contesto.attivo( 'assegnazione_categorie' ) and categorie:

            for ordine, id_categoria in enumerate( casuali.scegli_molti( categorie, 1, 2 ) ):

                riga_assegnazione = {
                    'id': schema.prossimo_id( 'prodotti_categorie' ),
                    'id_prodotto': id_prodotto,
                    'id_categoria': id_categoria,
                    'ordine': ordine + 1,
                }
                riga_assegnazione.update( contesto.tracce( inserimento ) )
                contesto.inserisci( 'prodotti_categorie', riga_assegnazione )

        ##  articoli: obbligatorio, il prodotto è la scheda, l'articolo è quello che si vende
        if contesto.attivo( 'articoli' ):

            for ordine in range( casuali.intero( 1, 3 ) ):

                progressivo_articolo += 1
                id_articolo = 'DEMO.ART.%06d' % progressivo_articolo
                prezzo = casuali.decimale( 4, 1800, 2 )

                riga_articolo = {
                    'id': id_articolo,
                    'id_prodotto': id_prodotto,
                    'ordine': ordine + 1,
                    'nome': casuali.nome_articolo(),
                    'ean': '80%011d' % casuali.intero( 0, 99999999999 ),
                    'id_reparto': id_reparto,
                    'peso': casuali.decimale( 0.05, 45, 3 ),
                    'larghezza': casuali.decimale( 1, 120, 1 ),
                    'lunghezza': casuali.decimale( 1, 180, 1 ),
                    'altezza': casuali.decimale( 1, 90, 1 ),
                    'note': casuali.frase(),
                }
                riga_articolo.update( contesto.tracce( inserimento ) )
                contesto.inserisci( 'articoli', riga_articolo )

                articoli_generati.append( {
                    'id': id_articolo,
                    'id_prodotto': id_prodotto,
                    'nome': '%s %s' % ( nome_prodotto, riga_articolo[ 'nome' ] ),
                    'prezzo': prezzo,
                    'id_listino': id_listino,
                    'id_iva': id_iva,
                    'aliquota': aliquota,
                } )

                ##  prezzi: obbligatorio, un articolo senza prezzo non è ordinabile
                if contesto.attivo( 'prezzi' ) and id_listino is not None:

                    riga_prezzo = {
                        'id': schema.prossimo_id( 'prezzi' ),
                        'id_prodotto': id_prodotto,
                        'id_articolo': id_articolo,
                        'qta_min': 1,
                        'prezzo': prezzo,
                        'id_listino': id_listino,
                        'id_iva': id_iva,
                        'data_inizio': contesto.data_da_timestamp( inserimento ),
                    }
                    riga_prezzo.update( contesto.tracce( inserimento ) )
                    contesto.inserisci( 'prezzi', riga_prezzo )

                    ##  seconda fascia di quantità, ogni tanto
                    if casuali.forse( 0.3 ):

                        riga_scaglione = dict( riga_prezzo )
                        riga_scaglione[ 'id' ] = schema.prossimo_id( 'prezzi' )
                        riga_scaglione[ 'qta_min' ] = 10
                        riga_scaglione[ 'prezzo' ] = round( prezzo * 0.9, 2 )
                        contesto.inserisci( 'prezzi', riga_scaglione )

        ##  contenuti: il testo della scheda
        if contesto.attivo( 'contenuti' ) and id_lingua:

            riga_contenuto = {
                'id': schema.prossimo_id( 'contenuti' ),
                'id_lingua': id_lingua,
                'id_prodotto': id_prodotto,
                'title': nome_prodotto,
                'h1': nome_prodotto,
                'description': casuali.frase(),
                'abstract': casuali.paragrafo(),
                'testo': casuali.testo(),
                'label_menu': nome_prodotto,
            }
            riga_contenuto.update( contesto.tracce( inserimento ) )
            contesto.inserisci( 'contenuti', riga_contenuto )

        ##  caratteristiche del prodotto
        if contesto.attivo( 'caratteristiche' ) and caratteristiche and id_lingua:

            for ordine, id_caratteristica in enumerate( casuali.scegli_molti( caratteristiche, 1, 3 ) ):

                riga_valore = {
                    'id': schema.prossimo_id( 'prodotti_caratteristiche' ),
                    'id_prodotto': id_prodotto,
                    'id_caratteristica': id_caratteristica,
                    'id_lingua': id_lingua,
                    'valore': casuali.scegli( ( 'acciaio inox AISI 304', 'alluminio anodizzato',
                                                'IP65', 'IP54', 'da -10 a +60 °C', 'verniciato',
                                                'galvanizzato' ) ),
                    'ordine': ordine + 1,
                }
                riga_valore.update( contesto.tracce( inserimento ) )
                contesto.inserisci( 'prodotti_caratteristiche', riga_valore )

        ##  pubblicazione
        if contesto.attivo( 'pubblicazioni' ) and tipologia_pubblicata:

            riga_pubblicazione = {
                'id': schema.prossimo_id( 'pubblicazioni' ),
                'id_tipologia': tipologia_pubblicata,
                'id_prodotto': id_prodotto,
                'ordine': 1,
                'timestamp_inizio': inserimento,
            }
            riga_pubblicazione.update( contesto.tracce( inserimento ) )
            contesto.inserisci( 'pubblicazioni', riga_pubblicazione )

    ## -----------------------------------------------------------------------------------
    ##  matricole
    ## -----------------------------------------------------------------------------------

    if contesto.attivo( 'matricole' ) and articoli_generati:

        for articolo in articoli_generati:

            if not casuali.forse( 0.25 ):
                continue

            riga_matricola = {
                'id': schema.prossimo_id( 'matricole' ),
                'id_articolo': articolo[ 'id' ],
                'matricola': 'SN%08d' % casuali.intero( 1, 99999999 ),
                'nome': articolo[ 'nome' ],
                'note': casuali.frase(),
            }
            riga_matricola.update( contesto.tracce() )
            contesto.inserisci( 'matricole', riga_matricola )

    contesto.memoria[ 'articoli' ] = articoli_generati


## ---------------------------------------------------------------------------------------
##  documenti
## ---------------------------------------------------------------------------------------

def _articoli_vendibili( contesto ):

    ##  \brief articoli con un prezzo, presi dal database e da quelli appena generati
    #
    #   Un documento con dentro un articolo senza prezzo è un documento con un totale a
    #   zero: è il motivo per cui questa funzione non guarda la tabella articoli ma la
    #   giunzione con i prezzi.

    elenco = list( contesto.memoria.get( 'articoli' ) or [] )

    if not contesto.da_database( 'articoli' ):
        return elenco

    righe = contesto.righe( 'articoli:vendibili',
        "SELECT a.id AS id, a.id_prodotto AS id_prodotto,"
        " CONCAT( COALESCE( p.nome, '' ), ' ', COALESCE( a.nome, '' ) ) AS nome,"
        " MIN( z.prezzo ) AS prezzo, MIN( z.id_listino ) AS id_listino, MIN( z.id_iva ) AS id_iva,"
        " MIN( COALESCE( v.aliquota, 22 ) ) AS aliquota"
        " FROM articoli a"
        " JOIN prezzi z ON z.id_articolo = a.id AND z.prezzo IS NOT NULL"
        " LEFT JOIN prodotti p ON p.id = a.id_prodotto"
        " LEFT JOIN iva v ON v.id = z.id_iva"
        " GROUP BY a.id, a.id_prodotto, nome LIMIT 2000" )

    visti = set( articolo[ 'id' ] for articolo in elenco )

    for riga in righe:

        if riga[ 'id' ] in visti:
            continue

        elenco.append( {
            'id': riga[ 'id' ],
            'id_prodotto': riga[ 'id_prodotto' ],
            'nome': ( riga[ 'nome' ] or '' ).strip() or riga[ 'id' ],
            'prezzo': float( riga[ 'prezzo' ] or 0 ),
            'id_listino': riga[ 'id_listino' ],
            'id_iva': riga[ 'id_iva' ],
            'aliquota': float( riga[ 'aliquota' ] or 22 ),
        } )

    return elenco


def _anagrafiche_disponibili( contesto, solo_aziende = False ):

    chiave = 'anagrafica:aziende' if solo_aziende else 'anagrafica:tutte'
    elenco = list( contesto.memoria.get( 'aziende' if solo_aziende else 'anagrafica' ) or [] )

    if solo_aziende:
        dove = " WHERE denominazione IS NOT NULL AND denominazione <> ''"
    else:
        dove = ''

    if not contesto.da_database( 'anagrafica' ):
        return elenco

    for riga in contesto.righe( chiave,
        "SELECT id, COALESCE( denominazione, CONCAT_WS( ' ', nome, cognome ) ) AS etichetta"
        " FROM anagrafica%s LIMIT 5000" % dove ):

        elenco.append( { 'id': riga[ 'id' ], 'etichetta': riga[ 'etichetta' ] or str( riga[ 'id' ] ) } )

    ##  gli id possono ripetersi fra memoria e database solo se il giro è stato scritto,
    ##  e in quel caso il contenuto è lo stesso: si tiene la prima occorrenza
    visti = set()
    unici = []

    for scheda in elenco:

        if scheda[ 'id' ] in visti:
            continue

        visti.add( scheda[ 'id' ] )
        unici.append( scheda )

    return unici


def genera_documenti( contesto, quantita ):

    casuali = contesto.casuali
    schema = contesto.schema

    articoli = _articoli_vendibili( contesto )
    anagrafiche = _anagrafiche_disponibili( contesto )
    aziende = _anagrafiche_disponibili( contesto, True )

    if not articoli:
        contesto.avvisi.append( 'nessun articolo con prezzo: i documenti non sono stati generati'
                                ' ( popola prima il catalogo )' )
        return

    if len( anagrafiche ) < 2:
        contesto.avvisi.append( 'servono almeno due anagrafiche per emettere un documento:'
                                ' i documenti non sono stati generati' )
        return

    emittente = ( aziende or anagrafiche )[ 0 ]
    destinatari = [ scheda for scheda in anagrafiche if scheda[ 'id' ] != emittente[ 'id' ] ]

    tipologia_fattura = contesto.primo_per_nome( 'tipologie_documenti', ( 'fattura', ) )
    condizioni = contesto.identificativi( 'condizioni_pagamento' )
    modalita = contesto.identificativi( 'modalita_pagamento' )
    tipologie_pagamento = contesto.identificativi( 'tipologie_pagamenti' )
    id_udm = contesto.primo_per_nome( 'udm', ( 'pezzo', 'unità', 'numero' ) )

    progressivo = contesto.conta( 'documenti' )

    for _ in range( quantita ):

        progressivo += 1
        inserimento = contesto.timestamp_recente( 540 )
        data = contesto.data_da_timestamp( inserimento )
        destinatario = casuali.scegli( destinatari )
        id_documento = schema.prossimo_id( 'documenti' )

        riga_documento = {
            'id': id_documento,
            'id_tipologia': tipologia_fattura,
            'codice': 'DEMO.DOC.%06d' % id_documento,
            'numero': '%d' % progressivo,
            'sezionale': 'DEMO',
            'data': data,
            'nome': 'fattura %d/%d' % ( progressivo, data.year ),
            'id_emittente': emittente[ 'id' ],
            'id_destinatario': destinatario[ 'id' ],
            'id_condizione_pagamento': casuali.scegli( condizioni ) if condizioni else None,
            'note': casuali.frase(),
        }
        riga_documento.update( contesto.tracce( inserimento ) )
        contesto.inserisci( 'documenti', riga_documento )

        totale_netto = 0.0
        totale_lordo = 0.0

        ##  righe: obbligatorio, un documento senza righe non si stampa e non si totalizza
        if contesto.attivo( 'righe' ):

            for ordine, articolo in enumerate( casuali.scegli_molti( articoli, 1, 5 ) ):

                quantita_riga = casuali.intero( 1, 12 )
                sconto = casuali.scegli( ( 0, 0, 0, 5, 10 ) )
                netto = round( articolo[ 'prezzo' ] * quantita_riga * ( 1 - sconto / 100.0 ), 2 )
                lordo = round( netto * ( 1 + articolo[ 'aliquota' ] / 100.0 ), 2 )

                totale_netto += netto
                totale_lordo += lordo

                riga_articolo = {
                    'id': schema.prossimo_id( 'documenti_articoli' ),
                    'id_documento': id_documento,
                    'ordine': ordine + 1,
                    'data': data,
                    'id_articolo': articolo[ 'id' ],
                    'id_prodotto': articolo[ 'id_prodotto' ],
                    'id_listino': articolo[ 'id_listino' ],
                    'id_udm': id_udm,
                    'id_emittente': emittente[ 'id' ],
                    'id_destinatario': destinatario[ 'id' ],
                    'quantita': quantita_riga,
                    'sconto_percentuale': sconto,
                    'importo_netto_totale': netto,
                    'importo_lordo_totale': lordo,
                    'nome': articolo[ 'nome' ],
                }
                riga_articolo.update( contesto.tracce( inserimento ) )
                contesto.inserisci( 'documenti_articoli', riga_articolo )

        ##  pagamento
        if contesto.attivo( 'pagamenti' ) and totale_lordo > 0:

            scadenza = data + datetime.timedelta( days = casuali.scegli( ( 30, 60, 90 ) ) )
            pagato = casuali.forse( 0.65 )

            riga_pagamento = {
                'id': schema.prossimo_id( 'pagamenti' ),
                'id_tipologia': casuali.scegli( tipologie_pagamento ) if tipologie_pagamento else None,
                'id_modalita_pagamento': casuali.scegli( modalita ) if modalita else None,
                'ordine': 1,
                'data_scadenza': scadenza,
                'nome': 'saldo %s' % riga_documento[ 'nome' ],
                'id_documento': id_documento,
                'id_creditore': emittente[ 'id' ],
                'id_debitore': destinatario[ 'id' ],
                'importo_lordo_totale': round( totale_lordo, 2 ),
                'importo_lordo_finale': round( totale_lordo, 2 ),
                'timestamp_pagamento': int( datetime.datetime(
                    scadenza.year, scadenza.month, scadenza.day ).timestamp() ) if pagato else None,
            }
            riga_pagamento.update( contesto.tracce( inserimento ) )
            contesto.inserisci( 'pagamenti', riga_pagamento )


## ---------------------------------------------------------------------------------------
##  progetti
## ---------------------------------------------------------------------------------------

def genera_progetti( contesto, quantita ):

    casuali = contesto.casuali
    schema = contesto.schema

    anagrafiche = _anagrafiche_disponibili( contesto )

    if not anagrafiche:
        contesto.avvisi.append( 'nessuna anagrafica: i progetti non sono stati generati' )
        return

    tipologie = contesto.identificativi( 'tipologie_progetti' )
    ruolo_cliente = contesto.primo_per_nome( 'ruoli_anagrafica', ( 'cliente', ) )
    ruolo_referente = contesto.primo_per_nome( 'ruoli_anagrafica', ( 'referente', 'coordinatore', 'assistente' ) )
    tipologie_todo = contesto.identificativi( 'tipologie_todo' )
    tipologie_attivita = contesto.identificativi( 'tipologie_attivita' )

    ##  categorie: se il componente è attivo e non ce ne sono, se ne creano
    categorie = contesto.identificativi( 'categorie_progetti' )

    if contesto.attivo( 'categorie' ) and not categorie:

        for nome in ( 'assistenza', 'forniture', 'sviluppo' ):

            id_categoria = schema.prossimo_id( 'categorie_progetti' )
            riga_categoria = { 'id': id_categoria, 'nome': nome, 'ordine': 1 }
            riga_categoria.update( contesto.tracce() )
            contesto.inserisci( 'categorie_progetti', riga_categoria )
            categorie.append( id_categoria )

    progressivo = contesto.conta( 'progetti' )

    for _ in range( quantita ):

        progressivo += 1
        id_progetto = 'DEMO.PRG.%05d' % progressivo
        inserimento = contesto.timestamp_recente( 540 )
        apertura = contesto.data_da_timestamp( inserimento )
        cliente = casuali.scegli( anagrafiche )
        entrate = casuali.decimale( 800, 90000, 2 )
        chiuso = casuali.forse( 0.4 )

        riga_progetto = {
            'id': id_progetto,
            'id_tipologia': casuali.scegli( tipologie ) if tipologie else None,
            'id_cliente': cliente[ 'id' ],
            'nome': '%s per %s' % ( casuali.tema_progetto(), cliente[ 'etichetta' ] ),
            'note': casuali.paragrafo(),
            'data_apertura': apertura,
            'entrate_previste': entrate,
            'ore_previste': casuali.decimale( 4, 400, 1 ),
            'costi_previsti': round( entrate * casuali.decimale( 0.3, 0.7, 2 ), 2 ),
            'se_sitemap': 0,
            'se_cacheable': 1,
        }

        if chiuso:
            riga_progetto[ 'data_chiusura' ] = apertura + datetime.timedelta( days = casuali.intero( 20, 300 ) )
            riga_progetto[ 'entrate_totali' ] = round( entrate * casuali.decimale( 0.8, 1.2, 2 ), 2 )
            riga_progetto[ 'note_chiusura' ] = casuali.frase()

        riga_progetto.update( contesto.tracce( inserimento ) )
        contesto.inserisci( 'progetti', riga_progetto )

        ##  il cliente sul progetto: obbligatorio, è la ragione per cui il progetto esiste
        if contesto.attivo( 'anagrafica' ):

            riga_cliente = {
                'id': schema.prossimo_id( 'progetti_anagrafica' ),
                'id_progetto': id_progetto,
                'id_anagrafica': cliente[ 'id' ],
                'id_ruolo': ruolo_cliente,
                'ordine': 1,
            }
            riga_cliente.update( contesto.tracce( inserimento ) )
            contesto.inserisci( 'progetti_anagrafica', riga_cliente )

            altri = [ scheda for scheda in anagrafiche if scheda[ 'id' ] != cliente[ 'id' ] ]

            if altri and casuali.forse( 0.6 ):

                riga_referente = {
                    'id': schema.prossimo_id( 'progetti_anagrafica' ),
                    'id_progetto': id_progetto,
                    'id_anagrafica': casuali.scegli( altri )[ 'id' ],
                    'id_ruolo': ruolo_referente,
                    'ordine': 2,
                }
                riga_referente.update( contesto.tracce( inserimento ) )
                contesto.inserisci( 'progetti_anagrafica', riga_referente )

        if contesto.attivo( 'categorie' ) and categorie:

            riga_categoria = {
                'id': schema.prossimo_id( 'progetti_categorie' ),
                'id_progetto': id_progetto,
                'id_categoria': casuali.scegli( categorie ),
                'ordine': 1,
            }
            riga_categoria.update( contesto.tracce( inserimento ) )
            contesto.inserisci( 'progetti_categorie', riga_categoria )

        ##  todo
        if contesto.attivo( 'todo' ):

            for _voce in range( casuali.intero( 0, 3 ) ):

                apertura_todo = contesto.timestamp_recente( 200 )
                scadenza = contesto.data_da_timestamp( apertura_todo ) + datetime.timedelta(
                    days = casuali.intero( 1, 45 ) )

                riga_todo = {
                    'id': schema.prossimo_id( 'todo' ),
                    'id_tipologia': casuali.scegli( tipologie_todo ) if tipologie_todo else None,
                    'codice': 'DEMO.TODO.%05d' % casuali.intero( 1, 99999 ),
                    'id_cliente': cliente[ 'id' ],
                    'id_progetto': id_progetto,
                    'timestamp_apertura': apertura_todo,
                    'data_scadenza': scadenza,
                    'nome': casuali.tema_attivita(),
                    'testo': casuali.paragrafo(),
                }

                if casuali.forse( 0.5 ):
                    riga_todo[ 'data_chiusura' ] = scadenza
                    riga_todo[ 'note_chiusura' ] = casuali.frase()

                riga_todo.update( contesto.tracce( apertura_todo ) )
                contesto.inserisci( 'todo', riga_todo )

        ##  attività
        if contesto.attivo( 'attivita' ):

            for _voce in range( casuali.intero( 0, 4 ) ):

                momento = contesto.timestamp_recente( 200 )
                giorno = contesto.data_da_timestamp( momento )
                ora_inizio = casuali.intero( 8, 16 )
                durata = casuali.intero( 1, 4 )

                riga_attivita = {
                    'id': schema.prossimo_id( 'attivita' ),
                    'id_tipologia': casuali.scegli( tipologie_attivita ) if tipologie_attivita else None,
                    'id_cliente': cliente[ 'id' ],
                    'id_progetto': id_progetto,
                    'data_attivita': giorno,
                    'ora_inizio': '%02d:00:00' % ora_inizio,
                    'ora_fine': '%02d:00:00' % ( ora_inizio + durata ),
                    'ore': durata,
                    'nome': casuali.tema_attivita(),
                    'note': casuali.frase(),
                }
                riga_attivita.update( contesto.tracce( momento ) )
                contesto.inserisci( 'attivita', riga_attivita )


## ---------------------------------------------------------------------------------------
##  notizie
## ---------------------------------------------------------------------------------------

def genera_notizie( contesto, quantita ):

    casuali = contesto.casuali
    schema = contesto.schema

    id_lingua = contesto.per_nome( 'lingue', 'it-IT', 'ietf' ) or contesto.per_nome( 'lingue', 'italiano' )

    if not id_lingua:
        contesto.avvisi.append( 'nessuna lingua configurata: le notizie non sono state generate' )
        return

    tipologia = contesto.primo_per_nome( 'tipologie_notizie', ( 'notizia', ) )
    tipologia_pubblicata = contesto.primo_per_nome( 'tipologie_pubblicazioni', ( 'pubblicato', ) )

    categorie = contesto.identificativi( 'categorie_notizie' )

    if contesto.attivo( 'categorie' ) and not categorie:

        for nome in ( 'dall\'azienda', 'prodotti', 'eventi' ):

            id_categoria = schema.prossimo_id( 'categorie_notizie' )
            riga_categoria = { 'id': id_categoria, 'nome': nome, 'ordine': 1, 'se_sitemap': 1 }
            riga_categoria.update( contesto.tracce() )
            contesto.inserisci( 'categorie_notizie', riga_categoria )
            categorie.append( id_categoria )

    for _ in range( quantita ):

        inserimento = contesto.timestamp_recente( 400 )
        id_notizia = schema.prossimo_id( 'notizie' )
        titolo = casuali.tema_notizia()

        riga_notizia = {
            'id': id_notizia,
            'id_tipologia': tipologia,
            'nome': titolo,
            'note': casuali.frase(),
            'se_sitemap': 1,
            'se_cacheable': 1,
        }
        riga_notizia.update( contesto.tracce( inserimento ) )
        contesto.inserisci( 'notizie', riga_notizia )

        ##  testo: obbligatorio, una notizia senza testo è una riga vuota
        if contesto.attivo( 'contenuti' ):

            riga_contenuto = {
                'id': schema.prossimo_id( 'contenuti' ),
                'id_lingua': id_lingua,
                'id_notizia': id_notizia,
                'title': titolo,
                'h1': titolo,
                'description': casuali.frase(),
                'cappello': casuali.frase(),
                'abstract': casuali.paragrafo(),
                'testo': casuali.testo( 3, 6 ),
                'label_menu': titolo,
            }
            riga_contenuto.update( contesto.tracce( inserimento ) )
            contesto.inserisci( 'contenuti', riga_contenuto )

        if contesto.attivo( 'categorie' ) and categorie:

            riga_categoria = {
                'id': schema.prossimo_id( 'notizie_categorie' ),
                'id_notizia': id_notizia,
                'id_categoria': casuali.scegli( categorie ),
                'ordine': 1,
            }
            riga_categoria.update( contesto.tracce( inserimento ) )
            contesto.inserisci( 'notizie_categorie', riga_categoria )

        if contesto.attivo( 'pubblicazioni' ) and tipologia_pubblicata:

            riga_pubblicazione = {
                'id': schema.prossimo_id( 'pubblicazioni' ),
                'id_tipologia': tipologia_pubblicata,
                'id_notizia': id_notizia,
                'ordine': 1,
                'timestamp_inizio': inserimento,
            }
            riga_pubblicazione.update( contesto.tracce( inserimento ) )
            contesto.inserisci( 'pubblicazioni', riga_pubblicazione )


## ---------------------------------------------------------------------------------------
##  liste di distribuzione
## ---------------------------------------------------------------------------------------

def genera_mailing( contesto, quantita ):

    casuali = contesto.casuali
    schema = contesto.schema

    ##  gli indirizzi appena generati non sono ancora sul database: si prendono dal piano
    indirizzi = [ riga[ 'id' ] for riga in contesto.piano.inserimenti.get( 'mail', [] ) ]

    if contesto.da_database( 'mail' ):
        indirizzi += contesto.identificativi( 'mail', limite = 5000 )

    if not indirizzi:
        contesto.avvisi.append( 'nessun indirizzo di posta: le liste non sono state generate'
                                ' ( popola prima l\'anagrafica )' )
        return

    for numero in range( quantita ):

        id_lista = schema.prossimo_id( 'liste' )

        riga_lista = {
            'id': id_lista,
            'nome': 'lista demo %d — %s' % ( numero + 1, casuali.titolo( 2, 3 ) ),
            'note': casuali.frase(),
        }
        riga_lista.update( contesto.tracce() )
        contesto.inserisci( 'liste', riga_lista )

        ##  iscritti: obbligatorio, una lista vuota non si può provare
        if contesto.attivo( 'iscritti' ):

            quanti = min( len( indirizzi ), casuali.intero( 5, max( 5, len( indirizzi ) // 2 ) ) )

            for id_mail in casuali.scegli_molti( indirizzi, quanti, quanti ):

                riga_iscritto = {
                    'id': schema.prossimo_id( 'liste_mail' ),
                    'id_lista': id_lista,
                    'id_mail': id_mail,
                }
                riga_iscritto.update( contesto.tracce() )
                contesto.inserisci( 'liste_mail', riga_iscritto )


## ---------------------------------------------------------------------------------------
##  il registro delle entità
## ---------------------------------------------------------------------------------------

ENTITA = collections.OrderedDict()


def _registra( entita ):

    ENTITA[ entita.nome ] = entita


_registra( Entita(
    nome = 'anagrafica',
    descrizione = 'persone fisiche e giuridiche con i loro recapiti',
    tabella = 'anagrafica',
    quantita_predefinita = 50,
    richiede = ( 'tipologie_anagrafica', 'tipologie_telefoni', 'categorie_anagrafica' ),
    componenti = (
        Componente( 'mail', OBBLIGATORIO, ( 'mail', ),
                    'almeno un indirizzo di posta, PEC per le aziende' ),
        Componente( 'telefoni', OBBLIGATORIO, ( 'telefoni', ),
                    'almeno un numero, spesso anche il mobile' ),
        Componente( 'indirizzi', CONSIGLIATO, ( 'indirizzi', 'anagrafica_indirizzi' ),
                    'sede legale o residenza, su un comune vero' ),
        Componente( 'categorie', CONSIGLIATO, ( 'anagrafica_categorie', ),
                    'clienti, fornitori, lead: le categorie già presenti nel deploy' ),
        Componente( 'relazioni', CONSIGLIATO, ( 'relazioni_anagrafica', ),
                    'le persone collegate alle aziende' ),
        Componente( 'url', OPZIONALE, ( 'url', ), 'il sito web delle aziende' ),
        Componente( 'iban', OPZIONALE, ( 'iban', ), 'coordinate bancarie valide' ),
        Componente( 'settori', OPZIONALE, ( 'anagrafica_settori', ), 'settore ATECO delle aziende' ),
        Componente( 'cittadinanze', OPZIONALE, ( 'anagrafica_cittadinanze', ),
                    'cittadinanza delle persone fisiche' ),
        Componente( 'contatti', OPZIONALE, ( 'contatti', ),
                    'richieste arrivate dal sito, con i parametri UTM' ),
    ),
    generatore = genera_anagrafica,
) )


_registra( Entita(
    nome = 'catalogo',
    descrizione = 'prodotti, articoli e prezzi',
    tabella = 'prodotti',
    quantita_predefinita = 30,
    richiede = ( 'tipologie_prodotti', 'listini', 'iva', 'lingue' ),
    componenti = (
        Componente( 'articoli', OBBLIGATORIO, ( 'articoli', ),
                    'da uno a tre articoli per prodotto: è l\'articolo che si vende' ),
        Componente( 'prezzi', OBBLIGATORIO, ( 'prezzi', ),
                    'almeno un prezzo di listino per articolo, con scaglioni di quantità' ),
        Componente( 'assegnazione_categorie', OBBLIGATORIO, ( 'prodotti_categorie', ),
                    'ogni prodotto appeso all\'albero delle categorie' ),
        Componente( 'categorie', CONSIGLIATO, ( 'categorie_prodotti', ),
                    'un albero di categorie su due livelli' ),
        Componente( 'marchi', CONSIGLIATO, ( 'marchi', ), 'qualche marchio' ),
        Componente( 'contenuti', CONSIGLIATO, ( 'contenuti', ),
                    'testi e metadati della scheda prodotto' ),
        Componente( 'pubblicazioni', CONSIGLIATO, ( 'pubblicazioni', ),
                    'i prodotti pubblicati, altrimenti non si vedono sul sito' ),
        Componente( 'caratteristiche', OPZIONALE, ( 'caratteristiche', 'prodotti_caratteristiche' ),
                    'scheda tecnica a coppie nome/valore' ),
        Componente( 'matricole', OPZIONALE, ( 'matricole', ),
                    'numeri di serie su una parte degli articoli' ),
    ),
    generatore = genera_catalogo,
) )


_registra( Entita(
    nome = 'documenti',
    descrizione = 'fatture con righe e pagamenti',
    tabella = 'documenti',
    quantita_predefinita = 40,
    richiede = ( 'tipologie_documenti', 'condizioni_pagamento', 'modalita_pagamento' ),
    dipende_da = ( 'anagrafica', 'catalogo' ),
    componenti = (
        Componente( 'righe', OBBLIGATORIO, ( 'documenti_articoli', ),
                    'da una a cinque righe, con quantità, sconto e totali coerenti' ),
        Componente( 'pagamenti', CONSIGLIATO, ( 'pagamenti', ),
                    'la scadenza del documento, pagata o no' ),
    ),
    generatore = genera_documenti,
) )


_registra( Entita(
    nome = 'progetti',
    descrizione = 'commesse con clienti, todo e attività',
    tabella = 'progetti',
    quantita_predefinita = 20,
    richiede = ( 'tipologie_progetti', 'ruoli_anagrafica' ),
    dipende_da = ( 'anagrafica', ),
    componenti = (
        Componente( 'anagrafica', OBBLIGATORIO, ( 'progetti_anagrafica', ),
                    'il cliente e il referente: senza, il progetto non è di nessuno' ),
        Componente( 'categorie', CONSIGLIATO, ( 'categorie_progetti', 'progetti_categorie' ),
                    'le categorie di progetto' ),
        Componente( 'todo', OPZIONALE, ( 'todo', ), 'cose da fare agganciate al progetto' ),
        Componente( 'attivita', OPZIONALE, ( 'attivita', ), 'ore lavorate sul progetto' ),
    ),
    generatore = genera_progetti,
) )


_registra( Entita(
    nome = 'notizie',
    descrizione = 'notizie pubblicate con il loro testo',
    tabella = 'notizie',
    quantita_predefinita = 15,
    richiede = ( 'tipologie_notizie', 'lingue' ),
    componenti = (
        Componente( 'contenuti', OBBLIGATORIO, ( 'contenuti', ),
                    'titolo, cappello e testo: una notizia senza testo non è niente' ),
        Componente( 'categorie', CONSIGLIATO, ( 'categorie_notizie', 'notizie_categorie' ),
                    'le categorie delle notizie' ),
        Componente( 'pubblicazioni', CONSIGLIATO, ( 'pubblicazioni', ),
                    'la pubblicazione, altrimenti la notizia non compare' ),
    ),
    generatore = genera_notizie,
) )


_registra( Entita(
    nome = 'mailing',
    descrizione = 'liste di distribuzione con i loro iscritti',
    tabella = 'liste',
    quantita_predefinita = 3,
    dipende_da = ( 'anagrafica', ),
    componenti = (
        Componente( 'iscritti', OBBLIGATORIO, ( 'liste_mail', ),
                    'gli indirizzi iscritti: una lista vuota non si può provare' ),
    ),
    generatore = genera_mailing,
) )
