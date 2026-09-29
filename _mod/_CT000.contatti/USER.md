# contatti

Un **contatto** è un modulo compilato da un visitatore sul sito: una richiesta di informazioni, una
prenotazione, un'iscrizione alla newsletter. Ogni invio che supera il filtro anti-spam viene
registrato qui, con tutto quello che il visitatore ha scritto, il sito e il modulo da cui è arrivato
e, se c'erano, i dati della campagna pubblicitaria che lo ha portato fin lì.

Registrare l'invio è la parte che fa sempre questo modulo. Quello che succede **dopo** — una mail a
chi deve rispondere, un contatto nuovo in anagrafica, un'iscrizione — dipende da come è stato
configurato quel particolare modulo del sito, e può essere diverso da un modulo all'altro.

Nel menu la voce **contatti** sta nell'area *contenuti*.

## l'elenco dei contatti
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: contenuti.contatti.view -->

Mostra i contatti non archiviati, i più recenti in cima:

| colonna | contenuto |
|---|---|
| tipologia | il tipo di contatto |
| data | quando è arrivato |
| sito | il sito da cui è arrivato; *nessun sito* se l'informazione manca |
| modulo | il modulo del sito che il visitatore ha compilato |

Le linguette dell'area sono **contatti**, **archiviati** ( lo stesso elenco per i contatti già
archiviati ) e **azioni**, che per ora **non contiene riquadri**.

## la scheda di un contatto
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: contenuti.contatti.form -->

La linguetta *gestione* ha due riquadri:

| riquadro | campi |
|---|---|
| dati generali | tipologia, data e ora del contatto, nome, note |
| dati di marketing | i sei parametri **UTM** — ID, source, medium, campaign, term, content — con cui una campagna pubblicitaria marca i link che porta al sito |

I dati di marketing si compilano da soli quando il visitatore arriva da un link di una campagna, e
dicono **da dove** è arrivato il contatto: quale campagna, quale canale, quale annuncio. Sono vuoti
per chi è arrivato al sito da solo.

La linguetta **dati** mostra il **contenuto dell'invio**, cioè tutti i campi del modulo con quello
che il visitatore ci ha scritto, uno per riga nella forma *campo: valore*. È il punto da guardare per
rispondere a una richiesta.

> **attenzione** — il contenuto della linguetta *dati* è modificabile, ma è la **registrazione di
> quello che il visitatore ha mandato**: correggerlo cambia la prova di cosa è stato chiesto. Le
> annotazioni vanno nelle *note* della prima linguetta.

La linguetta **privacy** elenca i **consensi** che il visitatore ha dato o negato con l'invio, uno
per riga: il consenso, il modulo del sito da cui è arrivato e se è stato *prestato* o *non
prestato*. È la stessa forma della linguetta *privacy* della scheda di un'anagrafica, dove si
leggono i consensi di un visitatore riconosciuto; qui si vedono quelli legati a **questo invio**, e
si consultano soltanto.

Le altre linguette sono **archiviazione** ( data e note ) e **azioni**, per ora vuota.

## archiviare i contatti
<!-- @pubblico: operatore, amministratore -->

Un contatto a cui si è risposto **si archivia**, compilando la data nella linguetta *archiviazione*:
esce dall'elenco ordinario, che così resta la lista delle cose da evadere, e si ritrova in
*archiviati*.

## quello che questo capitolo non dice ancora

- quali **moduli** del sito standard registrano contatti, e cosa fa ciascuno dopo l'invio;
- le **tipologie** di contatto e chi le imposta;
- cosa succede agli invii scartati come **spam**, che qui non compaiono.
