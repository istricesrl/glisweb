# offerte

Il modulo offerte è destinato alle **offerte commerciali**: i preventivi che si mandano a un cliente
prima che diventi un ordine o una fattura. Nella famiglia dei documenti ha il posto che le fatture
hanno nell'amministrazione: un'offerta è un documento come gli altri, con le sue righe, e qui si
trovano la stessa scheda, con le sole voci che servono a un'offerta, e gli elenchi filtrati sulle
offerte.

Nel menu si arriva da *commerciale*, voce **ciclo attivo**, sotto-voce **offerte**.

## l'elenco delle offerte
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: commerciale.ciclo.attivo.offerte.view -->

Le offerte non archiviate, le più recenti in cima, con le stesse colonne dell'archivio dei
documenti: codice, tipologia, data, numero e sezionale, nome, emittente, destinatario. Compaiono
tutti i documenti la cui tipologia è un tipo di **offerta**, gli stessi che propone la tendina della
scheda.

| linguetta | cosa ci sta |
|---|---|
| offerte | l'elenco qui sopra |
| righe | le righe di tutte le offerte |
| archiviate | le offerte archiviate |
| azioni | per ora **senza riquadri** |

## la scheda di un'offerta
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: commerciale.ciclo.attivo.offerte.form -->

La linguetta *gestione* è la testata dell'offerta:

| riquadro | campi |
|---|---|
| dati generali | tipologia, data, numero, sezionale, codice, nome, note |
| condizioni di pagamento | le condizioni di pagamento proposte |
| dati emittente | emittente e sua sede |
| dati destinatario | destinatario e sua sede |

La tendina della **tipologia** propone solo i tipi di documento che sono offerte. Come nei
documenti, le tendine delle **sedi** si riempiono dopo aver scelto il contatto e salvato.

| linguetta | cosa ci sta |
|---|---|
| righe | il sotto-elenco delle righe dell'offerta |
| archiviazione | la data di archiviazione e le note |
| stampe | per ora **senza riquadri** |
| azioni | per ora **senza riquadri** |

Nella linguetta **righe**, sia della scheda sia dell'elenco, il clic su una riga e il più per
aggiungerne una aprono la **scheda della riga** dei documenti, descritta nel capitolo di quel
modulo.

Un'offerta che non serve più — accettata e trasformata, o rifiutata — si **archivia** dalla sua
linguetta: esce dall'elenco e resta leggibile fra le *archiviate*.

## quello che questo capitolo non dice ancora

- il passaggio da un'offerta accettata all'ordine o alla fattura, che per ora si fa a mano creando
  il nuovo documento;
- le **stampe** dell'offerta, quando saranno configurate.
