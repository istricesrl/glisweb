# listini

Un **listino** è un elenco di prezzi con un nome e una valuta: il *listino al pubblico*, il
*listino rivenditori*, il *listino del fornitore X*. Il listino in sé è solo l'intestazione; i
prezzi che contiene si registrano uno per uno, e l'elenco di tutti i prezzi sta nell'archivio del
catalogo, descritto nel capitolo di quell'area.

Lo stesso oggetto compare in **due aree del menu**, secondo chi lo emette:

| dove | quali listini | a cosa servono |
|---|---|---|
| catalogo → listini | quelli emessi da una delle aziende che l'installazione gestisce, e quelli senza emittente | i prezzi a cui si **vende** |
| acquisti → listini | quelli emessi da chiunque altro | i prezzi a cui si **compra** dai fornitori |

Ogni listino sta quindi in uno solo dei due elenchi, e a deciderlo è il campo **emittente** della
scheda.

La voce compare in un'area solo se quell'area c'è. Tutte le pagine del modulo sono aperte a chi
appartiene allo **staff** o agli **amministratori**.

## i listini di vendita
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: catalogo.listini.vendita.view -->

L'elenco mostra una riga per listino, con il **nome seguito dalla valuta** ( *pubblico EUR* ), in
ordine alfabetico. Un clic su una riga apre la scheda, il più ne apre una nuova.

Le altre linguette sono **archiviati**, **stampe** e **azioni**.

## la scheda di un listino
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: catalogo.listini.vendita.form -->

La linguetta *gestione* ha un solo riquadro, **dati generali**:

| campo | contenuto |
|---|---|
| genitore | il listino da cui questo deriva, se è una variante di un altro |
| tipologia | la tipologia del listino, dall'elenco delle tipologie configurate |
| codice | un codice breve del listino |
| nome | il nome con cui il listino compare nelle tendine e negli elenchi |
| valuta | la valuta in cui sono espressi i prezzi |
| emittente | l'azienda gestita che emette il listino; la tendina propone solo le aziende gestite, e si può lasciare vuota |
| note | annotazioni libere |

Le altre linguette della scheda sono **archiviazione**, **stampe** e **azioni**.

## i listini di acquisto
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: acquisti.listini.acquisto.view -->

È lo stesso elenco visto dall'altra parte: una riga per ogni listino emesso da qualcuno che non è
un'azienda gestita, cioè di norma da un fornitore. Le linguette sono le stesse — **archiviati**,
**stampe** e **azioni**.

### la scheda di un listino di acquisto
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: acquisti.listini.acquisto.form -->

Un clic su una riga, o il più, apre la scheda del listino di acquisto. Ha gli stessi campi della
scheda di vendita, con una differenza: l'**emittente** è **obbligatorio** e si cerca in tutta
l'anagrafica scrivendone il nome, perché è il fornitore che ha emesso il listino. Le linguette sono
**gestione**, **archiviazione** e **azioni**.

> **attenzione** — se come emittente si sceglie una delle aziende gestite, il listino diventa di
> vendita: salvato, sparisce da questo elenco e si ritrova fra i listini del catalogo.

## archiviare un listino
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: catalogo.listini.vendita.form.archiviazione -->

Un listino che non si usa più **si archivia**: nella linguetta *archiviazione* della scheda si
compila la **data** e, se serve, le **note** che spiegano perché. Da quel momento esce dall'elenco
ordinario e passa nella linguetta *archiviati*, e i prezzi che conteneva restano leggibili.

Le due linguette *archiviati*, quella del catalogo e quella degli acquisti, separano i listini
archiviati con lo stesso criterio degli elenchi ordinari, e un clic su una riga apre la scheda del
listino dal lato giusto: di vendita dal catalogo, di acquisto dagli acquisti. Un listino di acquisto
si archivia dalla linguetta *archiviazione* della sua scheda, come uno di vendita.

## stampe e azioni
<!-- @pubblico: operatore, amministratore -->

Le linguette *stampe* e *azioni*, sia sull'elenco sia sulla scheda, hanno la forma di tutte le
pagine di riquadri ( vedi il capitolo *la pagina strumenti* ): le stampe prevedono il gruppo delle
**stampe PDF**, le azioni i gruppi esportazioni, importazioni, elaborazioni e viste statiche.

> **nota** — lo standard prepara i gruppi ma **non ci mette riquadri**: su un'installazione che non
> li ha personalizzati le pagine sono vuote.

## quello che questo capitolo non dice ancora

- a cosa serve il **genitore** di un listino nel calcolo dei prezzi, e come si comportano i prezzi
  di un listino derivato rispetto a quelli del listino da cui deriva;
- le **tipologie** di listino: dove si configurano e che effetto hanno;
- come si **assegna un listino a un cliente**, che è materia dell'anagrafica e dei documenti.
