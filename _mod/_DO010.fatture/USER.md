# fatture

Il modulo fatture mostra le **fatture emesse** — il ciclo attivo — separate dagli altri documenti.
Una fattura è un documento come gli altri, con le sue righe e i suoi pagamenti, e la sua forma è
descritta nel capitolo dei **documenti**: qui si trova la stessa scheda, con le sole voci che servono
a una fattura, e gli elenchi filtrati sulle fatture.

Nel menu si arriva da *amministrazione*, voce **ciclo attivo**, sotto-voce **fatture**.

## l'elenco delle fatture
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: amministrazione.ciclo.attivo.fatture.view -->

Le fatture non archiviate, le più recenti in cima, con le stesse colonne dell'archivio dei
documenti: codice, tipologia, data, numero e sezionale, nome, emittente, destinatario.

| linguetta | cosa ci sta |
|---|---|
| fatture | l'elenco qui sopra |
| righe | le righe delle fatture |
| pagamenti | i pagamenti delle fatture |
| archiviate | le fatture archiviate |
| azioni | per ora **senza riquadri** |

> **attenzione** — l'elenco mostra le sole tipologie **fattura** e **fattura accompagnatoria**,
> mentre la tendina della scheda propone tutti i tipi di fattura ( acconti, integrazioni… ). Una
> fattura d'acconto salvata da qui **non ricompare** in questo elenco: la si ritrova nell'archivio
> dei documenti.

## la scheda di una fattura
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: amministrazione.ciclo.attivo.fatture.form -->

La linguetta *gestione* è la testata della fattura:

| riquadro | campi |
|---|---|
| dati generali | tipologia, data, numero, sezionale, codice, nome, note |
| riferimenti di fatturazione | condizioni di pagamento, esigibilità dell'IVA |
| riferimenti per la pubblica amministrazione | CIG, CUP, documento di riferimento |
| dati emittente | emittente e sua sede |
| dati destinatario | destinatario e sua sede |

La tendina della **tipologia** propone solo i tipi di documento che sono fatture. Come nei documenti,
le tendine delle **sedi** si riempiono dopo aver scelto il contatto e salvato.

| linguetta | cosa ci sta |
|---|---|
| righe | il sotto-elenco delle righe della fattura |
| pagamenti | il sotto-elenco delle scadenze della fattura |
| relazioni | i legami con altri documenti: la nota di credito che la storna, il DDT da cui nasce |
| archiviazione | la data di archiviazione e le note |
| stampe | per ora **senza riquadri** |
| azioni | per ora **senza riquadri** |

Se l'installazione gestisce le pianificazioni, compare anche la linguetta **pianificazioni**, per le
fatture che si ripetono — un canone, un abbonamento.

> **attenzione** — nelle linguette **righe** e **pagamenti**, sia della scheda sia dell'elenco, il
> clic su una riga e il più per aggiungerne una portano a pagine che l'applicazione **non ha**.
> Finché non viene sistemato, righe e pagamenti di una fattura si inseriscono e si correggono
> dall'archivio dei **documenti**, nell'area *amministrazione*, dove la stessa fattura si apre con
> tutte le sue linguette funzionanti.

## quello che questo capitolo non dice ancora

- le fatture **ricevute**, del ciclo passivo, che questo modulo non mostra;
- quali righe e quali pagamenti compaiono nelle linguette **righe** e **pagamenti** dell'elenco, che
  sono filtrate con un criterio da verificare;
- la **numerazione** delle fatture e i sezionali;
- le **stampe** della fattura, quando saranno configurate.
