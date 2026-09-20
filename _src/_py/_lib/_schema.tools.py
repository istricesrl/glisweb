#!/usr/bin/env python3
# -*- coding: utf-8 -*-

##  introspezione dello schema e pianificazione dello svuotamento
#
#   Legge information_schema una volta sola e tiene in memoria colonne, chiavi primarie e
#   chiavi esterne. Serve a tre cose:
#
#   1. sapere quali colonne esistono davvero, perché una ricetta scritta per un deploy non
#      deve rompersi su un deploy che ha una colonna in meno ( le migrazioni non sono
#      allineate fra tutti i progetti );
#   2. assegnare gli id a mano invece di leggere LAST_INSERT_ID() dopo ogni riga: l'intero
#      grafo degli oggetti viene così costruito in memoria e scritto in un unico script SQL
#      dentro una sola transazione. È anche quello che rende possibile il --secco;
#   3. cancellare i dati esistenti senza lasciare orfani e senza portarsi via quello che
#      non deve sparire.
#
#   Sul punto tre vale la pena spendere due righe, perché è la parte che può fare danno.
#   Un DELETE FROM anagrafica, su questo schema, è una bomba: account.id_anagrafica ha una
#   ON DELETE CASCADE, quindi cancellando le anagrafiche si cancellano gli account e il
#   deploy resta senza login. Lo svuotamento quindi non è un TRUNCATE: è un DELETE mirato
#   che ( a ) risparmia le righe a cui è agganciata una tabella protetta e ( b ) scende
#   lungo le chiavi esterne cancellando solo le righe che resterebbero orfane, in ordine
#   dai figli ai padri e con i controlli di integrità ACCESI, così se il piano è sbagliato
#   il database lo dice invece di lasciar passare il guasto.

from _catalogo_tools import scrivibile


class Schema( object ):

    def __init__( self, mysql ):

        self.mysql = mysql
        self.colonne = {}
        self.chiavi_primarie = {}
        self.figli = {}
        self.esterne = {}
        self._contatori = {}

        self._carica()

    ## -----------------------------------------------------------------------------------
    ##  caricamento
    ## -----------------------------------------------------------------------------------

    def _carica( self ):

        for riga in self.mysql.seleziona(
            "SELECT table_name AS tabella, column_name AS colonna, data_type AS tipo,"
            " is_nullable AS nullabile, character_maximum_length AS lunghezza,"
            " column_key AS chiave, extra AS extra"
            " FROM information_schema.columns"
            " WHERE table_schema = DATABASE()"
            " ORDER BY table_name, ordinal_position" ):

            tabella = riga[ 'tabella' ]

            self.colonne.setdefault( tabella, {} )[ riga[ 'colonna' ] ] = {
                'tipo': riga[ 'tipo' ],
                'nullabile': riga[ 'nullabile' ] == 'YES',
                'lunghezza': int( riga[ 'lunghezza' ] ) if riga[ 'lunghezza' ] else None,
                'automatica': 'auto_increment' in ( riga[ 'extra' ] or '' ),
            }

            if riga[ 'chiave' ] == 'PRI' and tabella not in self.chiavi_primarie:
                self.chiavi_primarie[ tabella ] = riga[ 'colonna' ]

        for riga in self.mysql.seleziona(
            "SELECT k.table_name AS tabella, k.column_name AS colonna,"
            " k.referenced_table_name AS tabella_riferita, k.referenced_column_name AS colonna_riferita,"
            " r.delete_rule AS regola"
            " FROM information_schema.key_column_usage k"
            " JOIN information_schema.referential_constraints r"
            " ON r.constraint_schema = k.constraint_schema AND r.constraint_name = k.constraint_name"
            " WHERE k.table_schema = DATABASE() AND k.referenced_table_name IS NOT NULL" ):

            riferimento = {
                'tabella': riga[ 'tabella' ],
                'colonna': riga[ 'colonna' ],
                'tabella_riferita': riga[ 'tabella_riferita' ],
                'colonna_riferita': riga[ 'colonna_riferita' ],
                'regola': riga[ 'regola' ],
            }

            self.figli.setdefault( riga[ 'tabella_riferita' ], [] ).append( riferimento )
            self.esterne.setdefault( riga[ 'tabella' ], [] ).append( riferimento )

    ## -----------------------------------------------------------------------------------
    ##  interrogazione
    ## -----------------------------------------------------------------------------------

    def esiste( self, tabella ):

        return tabella in self.colonne

    def ha_colonna( self, tabella, colonna ):

        return colonna in self.colonne.get( tabella, {} )

    def chiave_primaria( self, tabella ):

        return self.chiavi_primarie.get( tabella, 'id' )

    def filtra( self, tabella, riga ):

        ##  \brief toglie da un dizionario le colonne che questa tabella non ha
        #
        #   Le ricette sono scritte sullo schema dello standard; un deploy può averne una
        #   versione più vecchia. Meglio inserire una riga con un campo in meno che far
        #   fallire tutto il giro per una colonna aggiunta l'anno scorso.

        conosciute = self.colonne.get( tabella, {} )

        return dict( ( chiave, valore ) for chiave, valore in riga.items() if chiave in conosciute )

    def tronca( self, tabella, colonna, valore ):

        ##  \brief accorcia un testo alla lunghezza dichiarata dalla colonna

        if valore is None:
            return None

        definizione = self.colonne.get( tabella, {} ).get( colonna )

        if not definizione or not definizione[ 'lunghezza' ]:
            return valore

        testo = str( valore )
        limite = definizione[ 'lunghezza' ]

        return testo if len( testo ) <= limite else testo[ : limite ]

    ## -----------------------------------------------------------------------------------
    ##  assegnazione degli identificativi
    ## -----------------------------------------------------------------------------------

    def prossimo_id( self, tabella ):

        ##  \brief ritorna il prossimo identificativo numerico libero
        #
        #   Il valore di partenza si legge una volta sola; da lì in avanti il contatore
        #   vive in memoria. Vuol dire che due giri di questo strumento lanciati insieme
        #   sullo stesso database collidono: è uno strumento da demo e da collaudo, non lo
        #   si lancia in due.

        if tabella not in self._contatori:

            chiave = self.chiave_primaria( tabella )
            massimo = self.mysql.valore(
                'SELECT COALESCE( MAX( %s ), 0 ) FROM `%s`' % ( chiave, tabella ) )

            self._contatori[ tabella ] = int( massimo or 0 ) + 1

        valore = self._contatori[ tabella ]
        self._contatori[ tabella ] += 1

        return valore

    def azzera_contatori( self ):

        self._contatori = {}

    ## -----------------------------------------------------------------------------------
    ##  ordine di inserimento
    ## -----------------------------------------------------------------------------------

    def ordine_inserimento( self, inserimenti ):

        ##  \brief ordina le tabelle di un piano in modo che i padri arrivino prima dei figli
        #   \param inserimenti dizionario ordinato { tabella: righe }
        #
        #   L'ordine in cui le ricette riempiono il piano è quello in cui gli oggetti
        #   nascono, e di solito è già giusto — ma non sempre: contenuti viene toccata dal
        #   catalogo ( id_prodotto ) e poi dalle notizie ( id_notizia ), e se si scrivesse
        #   nell'ordine di prima apparizione si cercherebbe di agganciare una notizia che
        #   non esiste ancora.
        #
        #   Le dipendenze si calcolano sulle **colonne davvero valorizzate**, non sulle
        #   chiavi esterne dichiarate. È quello che scioglie il nodo fra anagrafica e mail,
        #   che si riferiscono a vicenda: la PEC ( anagrafica.id_pec_sdi ) non viene scritta
        #   nella INSERT ma in un UPDATE in coda, quindi in fase di inserimento anagrafica
        #   non dipende da mail e l'ordine giusto esiste.

        tabelle = list( inserimenti.keys() )
        dipendenze = {}

        for tabella in tabelle:

            richieste = set()

            for riferimento in self.esterne.get( tabella, [] ):

                padre = riferimento[ 'tabella_riferita' ]

                if padre == tabella or padre not in inserimenti:
                    continue

                colonna = riferimento[ 'colonna' ]

                for riga in inserimenti[ tabella ]:
                    if riga.get( colonna ) is not None:
                        richieste.add( padre )
                        break

            dipendenze[ tabella ] = richieste

        ordine = []
        emesse = set()
        rimaste = list( tabelle )

        while rimaste:

            scelta = None

            for tabella in rimaste:
                if dipendenze[ tabella ] <= emesse:
                    scelta = tabella
                    break

            ##  se nessuna è pronta c'è un anello vero: si tiene l'ordine di nascita, che
            ##  è comunque l'ipotesi migliore che si ha
            if scelta is None:
                scelta = rimaste[ 0 ]

            rimaste.remove( scelta )
            emesse.add( scelta )
            ordine.append( scelta )

        return ordine

    ## -----------------------------------------------------------------------------------
    ##  svuotamento
    ## -----------------------------------------------------------------------------------

    def piano_svuotamento( self, obiettivi, protette ):

        ##  \brief costruisce l'elenco ordinato delle istruzioni di cancellazione
        #   \param obiettivi tabelle da svuotare
        #   \param protette tabelle il cui contenuto va salvato ( e con lui i suoi padri )
        #   \return una lista di dizionari { tabella, dove, sql, preparazione }

        obiettivi = [ tabella for tabella in obiettivi if self.esiste( tabella ) ]

        ##  passo 1: quali tabelle sono coinvolte
        coinvolte = self._chiusura( obiettivi )

        ##  passo 2: in che ordine si visitano, dai padri ai figli
        ordine = self._ordine_topologico( coinvolte )

        ##  passo 3: la condizione di ciascuna, calcolata dopo quella dei suoi padri
        condizioni = {}

        for tabella in ordine:

            if tabella in obiettivi:
                condizioni[ tabella ] = self._condizione_obiettivo( tabella, protette )
            else:
                condizioni[ tabella ] = self._condizione_figlio( tabella, condizioni )

        ##  passo 4: si cancella al contrario, dai figli ai padri
        piano = []

        for tabella in reversed( ordine ):

            dove = condizioni.get( tabella )

            if dove is None:
                continue

            preparazione = self._preparazione_ricorsiva( tabella, dove )

            piano.append( {
                'tabella': tabella,
                'dove': dove,
                'preparazione': preparazione,
                'sql': 'DELETE FROM `%s`%s' % ( tabella, '' if dove == '1' else ' WHERE %s' % dove ),
            } )

        return piano

    def _chiusura( self, obiettivi ):

        coinvolte = set( obiettivi )
        coda = list( obiettivi )

        while coda:

            padre = coda.pop( 0 )

            for riferimento in self.figli.get( padre, [] ):

                figlio = riferimento[ 'tabella' ]

                ##  non si esce mai dalle tabelle gestite: standard, assistite e protette
                ##  restano intatte, e le anagrafiche a cui sono agganciate pure
                if figlio in coinvolte or not scrivibile( figlio ):
                    continue

                coinvolte.add( figlio )
                coda.append( figlio )

        return coinvolte

    def _ordine_topologico( self, coinvolte ):

        ordine = []
        stato = {}

        def visita( tabella ):

            if stato.get( tabella ) == 'fatta':
                return

            ##  un ciclo fra tabelle ( p.es. documenti e le loro relazioni ) non è un
            ##  errore: si interrompe la discesa e si lascia che l'ordine lo decida il
            ##  ramo che ci è arrivato per primo
            if stato.get( tabella ) == 'in corso':
                return

            stato[ tabella ] = 'in corso'

            for riferimento in self.figli.get( tabella, [] ):

                figlio = riferimento[ 'tabella' ]

                if figlio in coinvolte and figlio != tabella:
                    visita( figlio )

            stato[ tabella ] = 'fatta'
            ordine.append( tabella )

        for tabella in sorted( coinvolte ):
            visita( tabella )

        ##  la post-visita mette prima i figli: qui serve l'opposto
        ordine.reverse()

        return ordine

    def _condizione_obiettivo( self, tabella, protette ):

        ##  \brief le righe di una tabella obiettivo, meno quelle che servono alle protette

        chiave = self.chiave_primaria( tabella )
        clausole = []

        for riferimento in self.figli.get( tabella, [] ):

            if riferimento[ 'tabella' ] not in protette:
                continue

            clausole.append( '`%s` NOT IN ( SELECT `%s` FROM `%s` WHERE `%s` IS NOT NULL )'
                             % ( chiave, riferimento[ 'colonna' ], riferimento[ 'tabella' ],
                                 riferimento[ 'colonna' ] ) )

        if not clausole:
            return '1'

        return ' AND '.join( clausole )

    def _condizione_figlio( self, tabella, condizioni ):

        ##  \brief le righe che resterebbero orfane dopo la cancellazione dei padri

        clausole = []

        for riferimento in self.esterne.get( tabella, [] ):

            padre = riferimento[ 'tabella_riferita' ]

            if padre == tabella or padre not in condizioni:
                continue

            condizione_padre = condizioni[ padre ]
            selezione = 'SELECT `%s` FROM `%s`' % ( riferimento[ 'colonna_riferita' ], padre )

            if condizione_padre != '1':
                selezione += ' WHERE %s' % condizione_padre

            clausole.append( '`%s` IN ( %s )' % ( riferimento[ 'colonna' ], selezione ) )

        if not clausole:
            return None

        return ' OR '.join( '( %s )' % clausola for clausola in clausole )

    def _preparazione_ricorsiva( self, tabella, dove ):

        ##  \brief scollega gli autoriferimenti prima di cancellare
        #
        #   Una tabella ricorsiva ( categorie, tipologie, l'anagrafica stessa con l'agente
        #   e il responsabile operativo ) non si può cancellare in blocco finché le sue
        #   righe si puntano a vicenda: si azzerano prima le colonne che rimandano a sé
        #   stessa, dove il vincolo lo consente.

        istruzioni = []

        for riferimento in self.esterne.get( tabella, [] ):

            if riferimento[ 'tabella_riferita' ] != tabella:
                continue

            definizione = self.colonne.get( tabella, {} ).get( riferimento[ 'colonna' ] )

            if not definizione or not definizione[ 'nullabile' ]:
                continue

            istruzioni.append( 'UPDATE `%s` SET `%s` = NULL%s'
                               % ( tabella, riferimento[ 'colonna' ],
                                   '' if dove == '1' else ' WHERE %s' % dove ) )

        return istruzioni
