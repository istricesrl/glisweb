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

L'elenco mostra tutti i documenti la cui tipologia è un tipo di **fattura** — la fattura, la
fattura accompagnatoria, gli acconti, le integrazioni, le parcelle, le note di debito… — cioè gli
stessi tipi che propone la tendina della scheda: una fattura salvata da qui ricompare sempre qui.
Le linguette **righe** e **pagamenti** seguono lo stesso criterio, sulla tipologia del documento a
cui la riga o il pagamento appartengono.

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
| dati fiscali | il bollo virtuale, le ritenute e i contributi alle casse previdenziali della fattura elettronica, come nella scheda dei documenti |
| relazioni | i legami con altri documenti: la nota di credito che la storna, il DDT da cui nasce |
| archiviazione | la data di archiviazione e le note |
| stampe | per ora **senza riquadri** |
| azioni | per ora **senza riquadri** |

Se l'installazione gestisce le pianificazioni, compare anche la linguetta **pianificazioni**, per le
fatture che si ripetono — un canone, un abbonamento.

La linguetta **dati fiscali** e le relazioni *fattura collegata* e *DDT collegato* sono descritte nel
capitolo dei documenti: una fattura differita *TD24* va legata ai suoi DDT, altrimenti la fattura
elettronica si vede e si scarica ma non si può inviare allo SDI.

Nelle linguette **righe** e **pagamenti**, sia della scheda sia dell'elenco, il clic su una riga e
il più per aggiungerne una aprono la **scheda della riga** e la **scheda del pagamento** dei
documenti, descritte nel capitolo di quel modulo: righe e pagamenti di una fattura sono quelli di un
documento qualsiasi, e si gestiscono con le stesse maschere.

## quello che questo capitolo non dice ancora

- le fatture **ricevute**, del ciclo passivo, che questo modulo non mostra;
- la **numerazione** delle fatture e i sezionali;
- le **stampe** della fattura, quando saranno configurate.
