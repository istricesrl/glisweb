#!/usr/bin/env python3
# -*- coding: utf-8 -*-

##  generatori di valori casuali verosimili
#
#   Libreria standalone: non dipende dalla configurazione del framework né dal database,
#   produce soltanto valori. Tutto quello che genera è pensato per essere *plausibile* e
#   *internamente coerente*: il codice fiscale corrisponde al nome, al cognome, alla data
#   di nascita e al comune; l'IBAN ha il CIN e le cifre di controllo giuste; la partita IVA
#   ha il carattere di controllo corretto. Dati falsi, ma non dati rotti: servono per
#   collaudare le interfacce, e un'interfaccia che valida i campi rifiuterebbe la fuffa.
#
#   Convenzione di nome: _<nome>.<tipo>.py, con tipo "tools" per le librerie standalone
#   e "utils" per quelle che dipendono dal contesto, come in _src/_lib/.

import random
import unicodedata


## ---------------------------------------------------------------------------------------
##  vocabolari
## ---------------------------------------------------------------------------------------

NOMI_M = (
    'Alessandro', 'Andrea', 'Antonio', 'Carlo', 'Claudio', 'Daniele', 'Davide', 'Emanuele',
    'Fabio', 'Federico', 'Filippo', 'Francesco', 'Gabriele', 'Giacomo', 'Giorgio', 'Giovanni',
    'Giuseppe', 'Lorenzo', 'Luca', 'Marco', 'Massimo', 'Matteo', 'Maurizio', 'Michele',
    'Nicola', 'Paolo', 'Pietro', 'Riccardo', 'Roberto', 'Salvatore', 'Simone', 'Stefano',
    'Tommaso', 'Umberto', 'Vincenzo', 'Walter',
)

NOMI_F = (
    'Alessandra', 'Alice', 'Anna', 'Annalisa', 'Barbara', 'Beatrice', 'Carla', 'Caterina',
    'Chiara', 'Cristina', 'Daniela', 'Elena', 'Elisa', 'Federica', 'Francesca', 'Giada',
    'Giorgia', 'Giovanna', 'Giulia', 'Ilaria', 'Irene', 'Laura', 'Letizia', 'Lucrezia',
    'Manuela', 'Marta', 'Martina', 'Michela', 'Monica', 'Paola', 'Rossana', 'Sara',
    'Silvia', 'Simona', 'Valentina', 'Veronica',
)

COGNOMI = (
    'Barbieri', 'Bellini', 'Benedetti', 'Bernardi', 'Bianchi', 'Bruno', 'Caputo', 'Carbone',
    'Colombo', 'Conti', 'Costa', 'De Luca', 'De Santis', 'Esposito', 'Fabbri', 'Ferrari',
    'Ferraro', 'Fontana', 'Galli', 'Gallo', 'Gatti', 'Gentile', 'Giordano', 'Greco',
    'Grassi', 'Leone', 'Lombardi', 'Longo', 'Mancini', 'Marchetti', 'Marino', 'Martini',
    'Mazza', 'Messina', 'Monti', 'Montanari', 'Morelli', 'Moretti', 'Neri', 'Pagano',
    'Palumbo', 'Parisi', 'Pellegrini', 'Piras', 'Rinaldi', 'Riva', 'Rizzo', 'Romano',
    'Rossi', 'Ruggiero', 'Russo', 'Sala', 'Sanna', 'Santoro', 'Serra', 'Silvestri',
    'Sorrentino', 'Testa', 'Valentini', 'Villa', 'Vitale', 'Zanetti',
)

##  radici per le denominazioni sociali: volutamente di fantasia, per non incrociare
##  per caso il nome di un'azienda vera in una demo mostrata a un cliente
RADICI_AZIENDA = (
    'Acquaviva', 'Alveare', 'Ampersand', 'Anemone', 'Aquilone', 'Arcadia', 'Basalto',
    'Bottega', 'Calliope', 'Cardine', 'Certosa', 'Cormorano', 'Corniolo', 'Elleboro',
    'Fenice', 'Folaga', 'Fulcro', 'Ginepro', 'Girandola', 'Lanterna', 'Lucciola',
    'Maestrale', 'Meridiana', 'Mirtillo', 'Officina', 'Ombrina', 'Orizzonte', 'Pergola',
    'Pietrasanta', 'Quadrifoglio', 'Rondine', 'Salamandra', 'Sestante', 'Solstizio',
    'Tramontana', 'Ventaglio', 'Verbena', 'Zenit',
)

SUFFISSI_AZIENDA = (
    'Costruzioni', 'Distribuzione', 'Forniture', 'Group', 'Impianti', 'Industria',
    'Logistica', 'Manifattura', 'Servizi', 'Sistemi', 'Tecnologie', 'Trasporti',
)

FORME_GIURIDICHE = ( 's.r.l.', 's.r.l.', 's.r.l.', 's.p.a.', 's.n.c.', 's.a.s.', 'società cooperativa' )

##  tipologie di strada che esistono davvero nella tabella tipologie_indirizzi
TIPOLOGIE_STRADA = ( 'via', 'viale', 'corso', 'piazza', 'largo', 'vicolo', 'strada' )

TOPONIMI = (
    'Aurelia', 'Bellaria', 'Cavour', 'Dante Alighieri', 'del Borgo', 'del Lavoro',
    'della Libertà', 'della Repubblica', 'della Resistenza', 'delle Industrie',
    'delle Rimembranze', 'di Mezzo', 'Emilia', 'Garibaldi', 'Giotto', 'Gramsci',
    'Guglielmo Marconi', 'Leonardo da Vinci', 'Mameli', 'Matteotti', 'Mazzini',
    'Municipio', 'Nazionale', 'Roma', 'San Francesco', 'Sant\'Anna', 'Trieste',
    'Venezia', 'Verdi', 'Vittorio Emanuele', 'XXV Aprile', 'XX Settembre',
)

ESTENSIONI_DOMINIO = ( 'it', 'it', 'it', 'com', 'net', 'eu' )

##  materiale per i testi di riempimento: parole italiane comuni, così un cappello o un
##  abstract generato somiglia a un testo e non a lorem ipsum, che nelle demo si riconosce
PAROLE = (
    'accurato', 'affidabile', 'ambiente', 'analisi', 'assistenza', 'attività', 'azienda',
    'cantiere', 'catalogo', 'cliente', 'collaborazione', 'competenza', 'componente',
    'consegna', 'controllo', 'costruzione', 'cura', 'dettaglio', 'disponibile', 'durata',
    'efficienza', 'esperienza', 'fornitura', 'gestione', 'impianto', 'industriale',
    'installazione', 'lavorazione', 'linea', 'macchina', 'manutenzione', 'materiale',
    'metodo', 'misura', 'montaggio', 'normativa', 'officina', 'operativo', 'percorso',
    'personale', 'precisione', 'preventivo', 'processo', 'produzione', 'progetto',
    'qualità', 'reparto', 'resistente', 'ricambio', 'richiesta', 'risorsa', 'scheda',
    'servizio', 'sicurezza', 'soluzione', 'sopralluogo', 'squadra', 'standard',
    'struttura', 'supporto', 'tempo', 'tecnico', 'verifica',
)

##  nomi di prodotto: aggettivo + oggetto, componibili
OGGETTI = (
    'armadio', 'banco', 'basamento', 'carrello', 'cassetta', 'centralina', 'colonna',
    'contenitore', 'cuscinetto', 'dispositivo', 'elettrovalvola', 'flangia', 'gruppo',
    'guarnizione', 'kit', 'modulo', 'motore', 'pannello', 'piastra', 'pompa', 'quadro',
    'raccordo', 'riduttore', 'scaffale', 'sensore', 'staffa', 'supporto', 'telaio',
    'tubo', 'valvola',
)

QUALIFICHE = (
    'compatto', 'da banco', 'di precisione', 'industriale', 'inox', 'maggiorato',
    'modulare', 'per esterni', 'pesante', 'rinforzato', 'standard', 'universale',
)

##  temi per le notizie
TEMI_NOTIZIA = (
    'apertura della nuova sede', 'certificazione ottenuta', 'chiusura estiva',
    'come scegliere il modello giusto', 'fiera di settore', 'nuova linea di prodotto',
    'nuovo listino in vigore', 'partecipazione alla fiera', 'rinnovo del magazzino',
    'storia di un impianto', 'tre consigli per la manutenzione', 'visita allo stabilimento',
)

##  temi per i progetti
TEMI_PROGETTO = (
    'ampliamento impianto', 'assistenza annuale', 'collaudo linea', 'formazione operatori',
    'fornitura ricambi', 'manutenzione programmata', 'restyling sito', 'revamping macchina',
    'studio di fattibilità', 'trasferimento impianto',
)

##  temi per le attività e le todo
TEMI_ATTIVITA = (
    'chiamata al cliente', 'consegna materiale', 'controllo avanzamento', 'intervento in sede',
    'preparazione preventivo', 'riunione di allineamento', 'sopralluogo', 'verifica collaudo',
)


## ---------------------------------------------------------------------------------------
##  il generatore
## ---------------------------------------------------------------------------------------

class Casuali( object ):

    ##  \brief generatore di valori casuali verosimili
    #   \param seme seme del generatore, per avere giri riproducibili

    def __init__( self, seme = None ):

        self.seme = seme
        self.rnd = random.Random( seme )

    ## -----------------------------------------------------------------------------------
    ##  primitive
    ## -----------------------------------------------------------------------------------

    def scegli( self, sequenza ):

        return self.rnd.choice( tuple( sequenza ) )

    def scegli_molti( self, sequenza, minimo = 1, massimo = 1 ):

        sequenza = list( sequenza )

        if not sequenza:
            return []

        quanti = min( len( sequenza ), self.rnd.randint( minimo, massimo ) )

        return self.rnd.sample( sequenza, quanti )

    def intero( self, minimo, massimo ):

        return self.rnd.randint( minimo, massimo )

    def decimale( self, minimo, massimo, cifre = 2 ):

        return round( self.rnd.uniform( minimo, massimo ), cifre )

    def forse( self, probabilita ):

        ##  \brief vero con la probabilità indicata ( da 0 a 1 )

        return self.rnd.random() < probabilita

    ## -----------------------------------------------------------------------------------
    ##  persone e aziende
    ## -----------------------------------------------------------------------------------

    def sesso( self ):

        return 'M' if self.forse( 0.5 ) else 'F'

    def nome( self, sesso ):

        return self.scegli( NOMI_M if sesso == 'M' else NOMI_F )

    def cognome( self ):

        return self.scegli( COGNOMI )

    def denominazione( self ):

        radice = self.scegli( RADICI_AZIENDA )
        forma = self.scegli( FORME_GIURIDICHE )

        if self.forse( 0.45 ):
            return '%s %s %s' % ( radice, self.scegli( SUFFISSI_AZIENDA ), forma )

        return '%s %s' % ( radice, forma )

    def data_nascita( self, eta_minima = 19, eta_massima = 78, anno_riferimento = 2026 ):

        ##  \brief ritorna una tupla ( giorno, mese, anno ) valida

        anno = anno_riferimento - self.intero( eta_minima, eta_massima )
        mese = self.intero( 1, 12 )

        if mese == 2:
            ultimo = 29 if ( anno % 4 == 0 and ( anno % 100 != 0 or anno % 400 == 0 ) ) else 28
        elif mese in ( 4, 6, 9, 11 ):
            ultimo = 30
        else:
            ultimo = 31

        return ( self.intero( 1, ultimo ), mese, anno )

    ## -----------------------------------------------------------------------------------
    ##  recapiti
    ## -----------------------------------------------------------------------------------

    def dominio( self, base ):

        return '%s.%s' % ( semplifica( base, '' ), self.scegli( ESTENSIONI_DOMINIO ) )

    def mail_persona( self, nome, cognome, dominio = None ):

        if dominio is None:
            dominio = '%s.%s' % ( semplifica( self.scegli( RADICI_AZIENDA ), '' ),
                                  self.scegli( ESTENSIONI_DOMINIO ) )

        return '%s.%s@%s' % ( semplifica( nome, '' ), semplifica( cognome, '' ), dominio )

    def mail_ufficio( self, dominio, casella = None ):

        if casella is None:
            casella = self.scegli( ( 'info', 'commerciale', 'amministrazione', 'ordini', 'acquisti' ) )

        return '%s@%s' % ( casella, dominio )

    def telefono_fisso( self ):

        ##  prefissi realmente assegnati, numero di lunghezza plausibile
        prefisso = self.scegli( ( '011', '02', '030', '040', '045', '049', '051', '055',
                                  '059', '06', '071', '079', '081', '090', '095', '0521',
                                  '0522', '0532', '0541', '0577' ) )

        cifre = 10 - len( prefisso )

        return '%s %s' % ( prefisso, ''.join( str( self.intero( 0, 9 ) ) for _ in range( cifre ) ) )

    def telefono_mobile( self ):

        prefisso = self.scegli( ( '320', '327', '328', '331', '333', '334', '335', '338',
                                  '339', '342', '346', '347', '348', '349', '351', '366',
                                  '380', '388', '389', '391' ) )

        return '%s %s' % ( prefisso, ''.join( str( self.intero( 0, 9 ) ) for _ in range( 7 ) ) )

    def url_sito( self, dominio ):

        return 'https://www.%s/' % dominio

    ## -----------------------------------------------------------------------------------
    ##  indirizzi
    ## -----------------------------------------------------------------------------------

    def tipologia_strada( self ):

        return self.scegli( TIPOLOGIE_STRADA )

    def toponimo( self ):

        return self.scegli( TOPONIMI )

    def civico( self ):

        numero = self.intero( 1, 220 )

        if self.forse( 0.12 ):
            return '%d/%s' % ( numero, self.scegli( 'ABC' ) )

        return str( numero )

    def cap( self ):

        return '%05d' % self.intero( 10, 98999 )

    ## -----------------------------------------------------------------------------------
    ##  testi
    ## -----------------------------------------------------------------------------------

    def frase( self, parole_minime = 6, parole_massime = 14 ):

        parole = [ self.scegli( PAROLE ) for _ in range( self.intero( parole_minime, parole_massime ) ) ]
        testo = ' '.join( parole )

        return testo[ 0 ].upper() + testo[ 1 : ] + '.'

    def paragrafo( self, frasi_minime = 2, frasi_massime = 5 ):

        return ' '.join( self.frase() for _ in range( self.intero( frasi_minime, frasi_massime ) ) )

    def testo( self, paragrafi_minimi = 2, paragrafi_massimi = 4 ):

        return '\n\n'.join( self.paragrafo() for _ in range( self.intero( paragrafi_minimi, paragrafi_massimi ) ) )

    def titolo( self, parole_minime = 3, parole_massime = 7 ):

        parole = [ self.scegli( PAROLE ) for _ in range( self.intero( parole_minime, parole_massime ) ) ]
        testo = ' '.join( parole )

        return testo[ 0 ].upper() + testo[ 1 : ]

    ## -----------------------------------------------------------------------------------
    ##  oggetti del catalogo e del lavoro
    ## -----------------------------------------------------------------------------------

    def nome_prodotto( self ):

        return '%s %s' % ( self.scegli( OGGETTI ), self.scegli( QUALIFICHE ) )

    def nome_articolo( self ):

        return self.scegli( (
            'taglia S', 'taglia M', 'taglia L', 'formato ridotto', 'formato standard',
            'formato maggiorato', 'confezione singola', 'confezione da 6', 'versione base',
            'versione completa', 'ricambio', 'kit di montaggio',
        ) )

    def nome_marchio( self ):

        return self.scegli( RADICI_AZIENDA )

    def tema_notizia( self ):

        return self.scegli( TEMI_NOTIZIA )

    def tema_progetto( self ):

        return self.scegli( TEMI_PROGETTO )

    def tema_attivita( self ):

        return self.scegli( TEMI_ATTIVITA )

    ## -----------------------------------------------------------------------------------
    ##  codici fiscali, partite IVA, IBAN
    ## -----------------------------------------------------------------------------------

    def partita_iva( self ):

        ##  \brief partita IVA italiana con il carattere di controllo corretto

        cifre = [ self.intero( 0, 9 ) for _ in range( 10 ) ]

        ##  le posizioni dispari ( indice pari ) si sommano così come sono, quelle pari
        ##  si raddoppiano e se superano 9 si sottrae 9
        totale = 0

        for indice, cifra in enumerate( cifre ):

            if indice % 2 == 0:
                totale += cifra
            else:
                doppio = cifra * 2
                totale += doppio - 9 if doppio > 9 else doppio

        controllo = ( 10 - ( totale % 10 ) ) % 10

        return ''.join( str( c ) for c in cifre ) + str( controllo )

    def codice_sdi( self ):

        alfabeto = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'

        return ''.join( self.scegli( alfabeto ) for _ in range( 7 ) )

    def iban_italiano( self ):

        ##  \brief IBAN italiano con CIN e cifre di controllo calcolati davvero

        abi = '%05d' % self.intero( 1000, 99999 )
        cab = '%05d' % self.intero( 1000, 99999 )
        conto = '%012d' % self.intero( 0, 999999999999 )

        cin = calcola_cin( abi + cab + conto )
        controllo = calcola_controllo_iban( 'IT', cin + abi + cab + conto )

        return 'IT%s%s%s%s%s' % ( controllo, cin, abi, cab, conto )

    def codice_fiscale( self, nome, cognome, giorno, mese, anno, sesso, codice_catasto ):

        return calcola_codice_fiscale( nome, cognome, giorno, mese, anno, sesso, codice_catasto )


## ---------------------------------------------------------------------------------------
##  funzioni di servizio, usabili anche senza istanziare il generatore
## ---------------------------------------------------------------------------------------

def semplifica( testo, separatore = '-' ):

    ##  \brief riduce una stringa a lettere e cifre ASCII minuscole
    #
    #   Serve per costruire domini, indirizzi di posta e chiavi leggibili a partire da
    #   nomi che possono contenere accenti, apostrofi e spazi.

    if testo is None:
        return ''

    testo = unicodedata.normalize( 'NFKD', str( testo ) )
    testo = ''.join( c for c in testo if not unicodedata.combining( c ) )

    pulito = []
    ultimo_separatore = True

    for carattere in testo.lower():

        if carattere.isalnum() and ord( carattere ) < 128:
            pulito.append( carattere )
            ultimo_separatore = False
        elif not ultimo_separatore:
            pulito.append( separatore )
            ultimo_separatore = True

    risultato = ''.join( pulito )

    if separatore and risultato.endswith( separatore ):
        risultato = risultato[ : -len( separatore ) ]

    return risultato


##  tabelle del codice fiscale

_MESI_CF = 'ABCDEHLMPRST'
_CONTROLLO_CF = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

_DISPARI_CF = {
    '0': 1, '1': 0, '2': 5, '3': 7, '4': 9, '5': 13, '6': 15, '7': 17, '8': 19, '9': 21,
    'A': 1, 'B': 0, 'C': 5, 'D': 7, 'E': 9, 'F': 13, 'G': 15, 'H': 17, 'I': 19, 'J': 21,
    'K': 2, 'L': 4, 'M': 18, 'N': 20, 'O': 11, 'P': 3, 'Q': 6, 'R': 8, 'S': 12, 'T': 14,
    'U': 16, 'V': 10, 'W': 22, 'X': 25, 'Y': 24, 'Z': 23,
}

_PARI_CF = dict( [ ( str( c ), c ) for c in range( 10 ) ] +
                 [ ( chr( 65 + c ), c ) for c in range( 26 ) ] )

_VOCALI = 'AEIOU'


def _consonanti_e_vocali( testo ):

    testo = semplifica( testo, '' ).upper()

    consonanti = [ c for c in testo if c not in _VOCALI ]
    vocali = [ c for c in testo if c in _VOCALI ]

    return consonanti, vocali


def _terna_cognome( cognome ):

    consonanti, vocali = _consonanti_e_vocali( cognome )
    terna = ( consonanti + vocali + [ 'X', 'X', 'X' ] )[ : 3 ]

    return ''.join( terna )


def _terna_nome( nome ):

    consonanti, vocali = _consonanti_e_vocali( nome )

    ##  con quattro o più consonanti si prendono la prima, la terza e la quarta
    if len( consonanti ) >= 4:
        terna = [ consonanti[ 0 ], consonanti[ 2 ], consonanti[ 3 ] ]
    else:
        terna = ( consonanti + vocali + [ 'X', 'X', 'X' ] )[ : 3 ]

    return ''.join( terna )


def calcola_codice_fiscale( nome, cognome, giorno, mese, anno, sesso, codice_catasto ):

    ##  \brief codice fiscale italiano completo di carattere di controllo
    #
    #   Il codice catastale è quello della tabella standard *comuni* ( colonna
    #   codice_catasto ): passandolo si ottiene un codice coerente con il comune di
    #   nascita scritto in anagrafica, che è il motivo per cui questa funzione esiste
    #   invece di sedici caratteri a caso.

    if not codice_catasto:
        codice_catasto = 'Z999'

    parziale = '%s%s%02d%s%02d%s' % (
        _terna_cognome( cognome ),
        _terna_nome( nome ),
        anno % 100,
        _MESI_CF[ mese - 1 ],
        giorno + ( 40 if sesso == 'F' else 0 ),
        str( codice_catasto ).upper(),
    )

    totale = 0

    for indice, carattere in enumerate( parziale ):

        ##  la numerazione delle posizioni è 1-based: l'indice 0 è una posizione dispari
        if indice % 2 == 0:
            totale += _DISPARI_CF.get( carattere, 0 )
        else:
            totale += _PARI_CF.get( carattere, 0 )

    return parziale + _CONTROLLO_CF[ totale % 26 ]


##  tabelle del CIN bancario

_DISPARI_CIN = {
    '0': 1, '1': 0, '2': 5, '3': 7, '4': 9, '5': 13, '6': 15, '7': 17, '8': 19, '9': 21,
    'A': 1, 'B': 0, 'C': 5, 'D': 7, 'E': 9, 'F': 13, 'G': 15, 'H': 17, 'I': 19, 'J': 21,
    'K': 2, 'L': 4, 'M': 18, 'N': 20, 'O': 11, 'P': 3, 'Q': 6, 'R': 8, 'S': 12, 'T': 14,
    'U': 16, 'V': 10, 'W': 22, 'X': 25, 'Y': 24, 'Z': 23,
}

_PARI_CIN = dict( [ ( str( c ), c ) for c in range( 10 ) ] +
                  [ ( chr( 65 + c ), c ) for c in range( 26 ) ] )


def calcola_cin( abi_cab_conto ):

    ##  \brief CIN del BBAN italiano ( i 22 caratteri ABI + CAB + numero di conto )

    totale = 0

    for indice, carattere in enumerate( abi_cab_conto.upper() ):

        if indice % 2 == 0:
            totale += _DISPARI_CIN.get( carattere, 0 )
        else:
            totale += _PARI_CIN.get( carattere, 0 )

    return chr( 65 + ( totale % 26 ) )


def calcola_controllo_iban( paese, bban ):

    ##  \brief cifre di controllo dell'IBAN secondo ISO 13616 ( resto 97 )

    riordinato = ( bban + paese + '00' ).upper()

    numerico = ''

    for carattere in riordinato:
        numerico += carattere if carattere.isdigit() else str( ord( carattere ) - 55 )

    return '%02d' % ( 98 - ( int( numerico ) % 97 ) )
