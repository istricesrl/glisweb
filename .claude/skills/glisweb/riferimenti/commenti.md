# Commenti al codice: come si documenta il framework

Guida ricavata dai file che il framework ha già documentati bene. **Va letta prima di commentare un
file del framework o di un modulo**, e prima di sciogliere un `TODO documentare`. È la regola d'oro
applicata ai commenti: un commento che non somiglia a quelli dei vicini è un commento sbagliato,
anche se dice cose giuste.

I modelli da aprire, per tipo di file:

| tipo | modello |
|---|---|
| libreria | `_src/_lib/_array.tools.php` ( testata, tabelle, docblock di funzione ) |
| runlevel di dichiarazione | `_src/_config/_010.site.php`, `_src/_config/_120.mysql.php` |
| runlevel di attivazione | `_src/_config/_115.google.php`, `_src/_config/_015.site.php` |
| API | `_src/_api/_cron.php` |
| task | `_src/_api/_task/_database.frammentazione.check.php` |
| macro di pagina | `_mod/_0400.documenti/_src/_inc/_macro/_offerte.commerciale.form.tools.php` |
| script di shell | `_src/_sh/_docs.shots.sh` ( lungo ), `_src/_sh/_files.minimize.sh` ( corto ) |
| macro Twig | `_src/_twig/_lib/_privacy.twig` |

## 1. Le regole di fondo

- **Si scrive in italiano**, in prosa, con le frasi intere. Niente elenchi telegrafici dove serve un
  ragionamento.
- **Il commento dice perché, non ripete il codice.** `// tendina lingue` sopra la query che popola la
  tendina delle lingue va bene: è un'etichetta, serve a scorrere il file. Una frase che parafrasa riga
  per riga quello che si legge già nel codice no. Quello che vale la pena scrivere per esteso è **ciò che
  il codice non può dire**: perché si fa così e non nel modo ovvio, cosa succede se si cambia, da quale
  caso reale nasce la scelta, quale trappola si evita.
- **Si documenta quello che il codice fa, non quello che dovrebbe fare.** Il commento si scrive leggendo
  il codice, i chiamanti ( `grep` ) e la storia ( `git log -p`, `git blame` ). Se il comportamento è
  sbagliato **non lo si descrive come giusto**: lo si descrive com'è e si aggiunge una riga `TODO` o
  `NOTA` che dice cosa non torna. Mai inventare parametri, chiavi o casi d'uso che il codice non ha.
- **Il caso reale vale più dell'esempio astratto.** I commenti migliori del framework citano la data e
  il fatto che ha motivato la scelta ( *"Osservato il 2026-09-10 su un deploy in esercizio: …"* ), i
  numeri misurati, il file dove sta il pattern gemello. Quando la scelta ha una storia, la si racconta.
- **Si rimanda invece di ripetere.** Se un concetto è spiegato altrove ( un runlevel gemello, una
  libreria, un capitolo del manuale ) si scrive *"per ulteriori dettagli si vedano i commenti al file
  `_src/_config/_110.google.php`"* e non lo si ricopia: due copie divergono.
- **Il commento si aggiorna con il codice.** Cambiando il comportamento di una funzione, il suo docblock
  cambia nello stesso commit.
- **Commentare non tocca il codice.** Un commit di documentazione non cambia una sola istruzione: se
  leggendo si trova un bug, lo si segnala ( `TODO` nel commento, e a Fabio ) e lo si corregge in un
  commit a parte. Così il diff di documentazione si rilegge in fretta e non nasconde niente.
- **Stile tipografico**: si seguono accenti e apostrofi del file che si sta commentando. I docblock
  Doxygen usano le lettere accentate ( `è`, `più` ); le note lunghe più recenti in alcuni file usano
  l'apostrofo ( `e'`, `piu'` ). Dentro lo stesso file non si mescolano.

## 2. I marcatori

| marcatore | significato |
|---|---|
| `TODO <cosa>` | qualcosa da fare, detto in modo che chi legge sappia cosa |
| `TODO documentare` | il blocco non è documentato: **si toglie** quando il blocco viene documentato |
| `@todo <cosa>` | stesso significato dentro un docblock Doxygen ( lo raccoglie la reference ) |
| `NOTA <cosa>` / `NB:` | un'avvertenza su un comportamento non ovvio |
| `⚠` | la trappola: una cosa che si sbaglia senza che niente lo segnali |
| `// debug` | apre un gruppo di righe commentate che servono al debug e restano nel file |
| `// ...` | etichetta ancora da scrivere: va sostituita con quella giusta |

Documentando un blocco si toglie il suo `TODO documentare` ( o `@todo documentare`, o `TODO DOCUMENTARE`
in Twig ) e **si lasciano gli altri `TODO`**, che sono lavoro ancora da fare e non c'entrano. Se il
blocco è documentato solo in parte si scrive `@todo finire di documentare`, che è la forma già in uso.

## 3. PHP: la testata del file

Ogni file PHP apre con un docblock `/** … */` indentato di quattro spazi, subito dopo `<?php` e una riga
vuota. La forma:

```php
<?php

    /**
     * titolo breve in minuscolo, senza punto finale
     *
     * Una o due frasi che dicono cosa fa il file, con la maiuscola e il punto.
     *
     * introduzione
     * ============
     * La trattazione, in paragrafi.
     *
     * sottoargomento
     * --------------
     * Un paragrafo per sottoargomento.
     *
     */
```

- **La prima riga è il titolo**: minuscolo, corto, niente punto ( *"libreria per la gestione e la
  manipolazione degli array"*, *"dichiarazione dei siti gestiti"*, *"server e profili MySQL"* ).
- Poi una riga vuota ( ` * ` ) e il sommario in prosa, **con la maiuscola**.
- Le sezioni hanno il titolo **in minuscolo sottolineato**: `=` per il primo livello, `-` per il secondo,
  lunga quanto il titolo. È Markdown, e Doxygen lo rende.
- Le tabelle sono in Markdown, con le colonne allineate a spazi:

```php
     * chiave           | dettagli
     * -----------------|-----------------------------------------------------------------------
     * address          | l'indirizzo (nome host o IP) del server
     * port             | la porta del server (default 3306)
```

- Gli esempi di configurazione stanno fra tre backtick; nomi di file, chiavi e funzioni fra backtick
  singoli nei commenti nuovi, oppure nudi come `$cf['sites']` nei vecchi ( si segue il file ).
- Le righe si tengono entro 120-130 colonne circa, andando a capo come nel resto del file.
- La testata si chiude con ` * ` vuota e ` */`.

### Le librerie ( `_src/_lib/_<nome>.<tools|utils>.php` )

La testata di una libreria ha sempre queste sezioni, in quest'ordine ( modello:
`_src/_lib/_array.tools.php` ):

1. titolo e sommario;
2. `introduzione` — a cosa serve la libreria e quando la si usa;
3. `costanti` — tabella `costante | spiegazione` di quelle definite dalla libreria;
4. `funzioni` — una frase, poi un paragrafo di secondo livello per **gruppo** di funzioni ( *funzioni di
   conversione*, *funzioni di ricerca*… ) con la tabella `funzione | descrizione`. Il nome è seguito da
   `()`, la descrizione è la prima riga del docblock della funzione;
5. `dipendenze` — tabella `funzione | libreria di appartenenza` delle funzioni esterne richieste;
6. `changelog` — tabella `data | autore | descrizione` delle modifiche significative;
7. `licenza` — il paragrafo standard, identico in tutte le librerie:

```php
     * licenza
     * =======
     * Questa libreria fa parte del progetto GlisWeb (https://github.com/istricesrl/glisweb) ed è distribuita
     * sotto licenza Open Source. Fare riferimento alla pagina GitHub del progetto per i dettagli.
```

Le sezioni vuote non si lasciano vuote: una sezione `costanti` in una libreria che non ne definisce
dice *"Questa libreria non definisce costanti."*. Nel `changelog` si aggiunge una riga solo per una
modifica significativa; il refactoring della documentazione lo è ( *"2024-08-13 | Sara Tullini |
documentazione"* ), con l'autore che firma il commit.

Nel corpo, i gruppi di funzioni sono separati da un docblock col nome del gruppo **in maiuscolo**:

```php
    /**
     * FUNZIONI DI CONVERSIONE
     */
```

### Il docblock di funzione

```php
    /**
     * converte una stringa in un array
     *
     * Questa funzione prende in input una stringa e la converte in array; se la stringa passata è vuota
     * restituisce un array vuoto. Se non viene passato un separatore specifico, viene utilizzato il
     * separatore di default.
     *
     * @param       string      $s      la stringa da convertire
     * @param       string      $c      il separatore da utilizzare per la conversione
     *
     * @return      array               l'array ottenuto dalla conversione
     *
     */
    function string2array( &$s, $c = ARRAY_SEPARATOR ) {
```

- **Prima riga**: cosa fa, all'indicativo, in minuscolo, senza punto — è quella che finisce nella
  tabella della testata;
- **descrizione**: comincia con *"Questa funzione…"* e dice il comportamento, **compresi i casi limite**
  ( input vuoto, valore assente, cosa restituisce in caso di errore, cosa modifica per riferimento );
- `@param` e `@return` hanno **le colonne allineate a spazi**: tag, tipo, nome, descrizione. Un `@param`
  per parametro nell'ordine della firma, e anche quelli facoltativi ( dicendo il default e cosa succede
  se lo si omette ). Tipi: `string`, `int`, `float`, `bool`, `array`, `mixed`, `object`, `resource`;
- una funzione che non restituisce niente ha `@return      void`;
- un parametro passato per riferimento lo si dice nella descrizione ( *"l'array da ordinare, modificato
  sul posto"* );
- il docblock si chiude con ` * ` vuota e ` */`, attaccato alla firma.

Le note lunghe **dentro il corpo** della funzione, quelle che spiegano una scelta non ovvia, stanno in
un blocco di `//` subito sopra la riga che spiegano, cominciando con `NB:` o `NOTA` quando avvertono di
qualcosa ( modello: il commento dentro `arraySortBy()` ).

### I runlevel ( `_src/_config/_NNN.<nome>.php` )

- **Titolo**: cosa dichiara o attiva il runlevel ( *"server e profili MySQL"* );
- **sommario**: per un `N0` *"In questo file sono impostati…"*, per un `N5` *"In questo file vengono
  integrati i dati dichiarati al runlevel N0 con quelli presenti nei file di configurazione JSON/YAML
  dopodiché…"*, secondo la coppia dichiarazione/attivazione;
- le sezioni spiegano **la struttura dell'array** che il runlevel dichiara ( tabelle `chiave | dettagli` ),
  come lo si personalizza in custom ( `src/config/NNN.<nome>.php` o `src/config.yaml`, con l'esempio
  JSON/YAML ) e i rimandi ai runlevel gemelli;
- nel corpo ogni gruppo di assegnazioni ha la sua etichetta `//` in minuscolo, e i blocchi grandi un
  docblock con titolo sottolineato ( *"configurazione del sito di default"* );
- il file finisce col blocco di debug canonico:

```php
    /**
     * debug del runlevel
     * ==================
     * Questa sezione contiene alcune righe commentate utili per il debug del runlevel.
     *
     */

    // debug
    // die( print_r( $cf['sites'], true ) );
```

### API, task e job ( `_src/_api/` )

Stessa testata. Le API spiegano il **meccanismo** ( chi le chiama, con quali parametri, cosa restituiscono,
dove loggano: modello `_src/_api/_cron.php` ). I task spiegano **cosa fanno a ogni chiamata**, cosa non
fanno e perché, le soglie e da dove si regolano ( modello
`_src/_api/_task/_database.frammentazione.check.php` ); per i job vale in più
`riferimenti/job.md`. Nei task e nelle note lunghe la frase in **maiuscolo** marca il punto che non va
frainteso ( *"QUESTO TASK NON RECUPERA NIENTE, E NON DEVE."* ).

### Le macro di pagina ( `_src/_inc/_macro/`, `_mod/<modulo>/_src/_inc/_macro/` )

La testata di una macro è corta e **chiude con `@file`**, che dice a Doxygen di documentare il file:

```php
<?php

    /**
     * macro degli strumenti delle offerte
     *
     * Cosa mostra la pagina che usa questa macro, cosa prepara per il template e, se c'è, perché è
     * fatta così e qual è il pattern gemello da cui è copiata.
     *
     * -# dichiarazione della tabella gestita
     * -# popolazione delle tendine
     * -# macro di default
     *
     * @file
     *
     */
```

- titolo *"macro …"* in minuscolo ( *"macro della vista anagrafica"*, *"macro del form todo, scheda
  strumenti"* );
- la descrizione dice **quale pagina** la usa ( l'id della pagina in `_src/_inc/_pages/` ), cosa mette in
  `$ct` per il template, e le particolarità: filtri speciali, colonne variabili, preset, tendine filtrate;
- la lista `-#` elenca **i passi nell'ordine in cui compaiono nel file**, uno per etichetta `//`, ed è
  facoltativa per le macro brevi;
- nel corpo si usano le **etichette canoniche**, identiche fra tutte le macro, così scorrendo un file si
  riconoscono i blocchi a colpo d'occhio:

| etichetta | blocco |
|---|---|
| `// tabella gestita` | `$ct['form']['table'] = …` |
| `// sotto tabella gestita` | `$ct['form']['subtable'] = …` |
| `// tabella della vista` | `$ct['view']['table'] = …` |
| `// id della vista` | `$ct['view']['id'] = …` |
| `// pagina per la gestione degli oggetti esistenti` | `$ct['view']['open']…` |
| `// campi della vista` | `$ct['view']['cols'] = …` |
| `// stili della vista` | `$ct['view']['class'] = …` |
| `// javascript della vista` | `$ct['view']['onclick'] = …` |
| `// inclusione filtri speciali` | `$ct['view']['__filters__'] …` |
| `// gruppi di controlli` | `$ct['page']['contents']['metros'] = …` |
| `// tendina <cosa>` | `$ct['etc']['select'][…] = mysqlCachedIndexedQuery( … )` |
| `// macro di default` | `require DIR_SRC_INC_MACRO . '_default.<view\|form>.php';` |
| `// debug` | righe commentate di debug |

Un blocco che ha un perché riceve, al posto della sola etichetta, un docblock con titolo **in maiuscolo**
e la spiegazione ( modello: *"RIPOPOLAMENTO DELLA VISTA STATICA DELLE OFFERTE"* in
`_offerte.commerciale.form.tools.php` ).

### Le definizioni di pagina ( `_src/_inc/_pages/` )

Le etichette sono fisse: `// lingua di questo file`, `// modulo di questo file`, `// pagina principale`
o il nome della pagina ( `// vista indirizzi`, `// gestione indirizzi` ). Una
pagina con qualcosa di particolare ( gruppi di accesso insoliti, un template diverso, un menu nascosto )
ha una riga di commento che lo dice.

## 4. Shell ( `_src/_sh/*.sh` )

```bash
#!/bin/bash

## SCRIPT PER LA CATTURA DEGLI SCREENSHOT DELLA DOCUMENTAZIONE
#
# questo script rigenera le immagini delle maschere citate nei sorgenti della documentazione
#
#   _docs.shots.sh                 rigenera solo gli scatti scaduti
#   _docs.shots.sh --force         rigenera tutto
#
# ambiente:
#   DOCS_USER, DOCS_PASS   credenziali dell'utente con cui fotografare le maschere
#
```

- la testata comincia con `## ` e il titolo **in maiuscolo**, poi righe `#` con cosa fa lo script, **come
  si lancia** ( una riga per variante, allineate ), le variabili d'ambiente e gli argomenti;
- le sezioni della testata hanno il titolo in maiuscolo su una riga `#` ( *"COME SI DICHIARA UNO
  SCATTO"*, *"PERCHE' NON C'E' UN ENDPOINT DI AUTOLOGIN"* );
- nel corpo **ogni passo ha la sua etichetta `## ` in minuscolo**, con i nomi canonici: `## livelli per
  la root del sito`, `## directory corrente`, `## informazioni`, `## pulizia schermo`, `## verifica
  utente root`, `## funzioni`, `## fine elaborazione`;
- una riga `#` singola ( non `##` ) è un commento a una riga di codice o una riga disattivata.

## 5. Twig ( `_src/_twig/`, `_src/_tpl/`, template di modulo )

```twig
{# MACRO PER LA GESTIONE DELLA PRIVACY
    Questo file contiene macro utili per … È consigliabile per mantenere la consistenza fra le pagine
    di importarlo sempre come 'prv' #}

{# checkConsensi() - genera le checkbox per i consensi relativi a un modulo dato
    Questa macro genera le checkbox … I consensi da generare devono essere passati alla macro
    attraverso la variabile items che deve avere la sotto chiave consensi #}
{% macro checkConsensi( key, modulo, items, ietf, tr, pages, class, rclass ) %}
<!-- macro {{ _self }}::checkConsensi() -->
```

- la libreria di macro apre con `{# ` e il titolo **in maiuscolo**, poi la descrizione indentata di
  quattro spazi e il prefisso con cui la si importa;
- ogni macro è preceduta da `{# nome() - cosa fa` e, indentata, la descrizione con **gli argomenti e le
  chiavi che si aspetta** ( quando la macro accetta un array `options`, le sue chiavi si elencano tutte );
- il commento Twig `{# #}` è per chi legge il sorgente; il commento HTML `<!-- macro … -->` è il
  marcatore che finisce nell'output per ritrovare la macro dalla pagina renderizzata, e c'è già: non si
  aggiunge né si toglie.

## 6. SQL ( `_usr/_database/_patch/` )

La patch apre con la testatina commentata in forma libera che dice cosa fa e perché, come spiegato in
`_usr/_docs/_read/405.howto.database.md`. Una patch che corregge dati spiega quali e da dove sono
venuti.

## 7. Come si lavora

1. **si apre il modello** del tipo di file ( tabella in cima ) e un vicino già documentato;
2. si legge il file intero, i chiamanti ( `grep -rn "<funzione>(" _src _mod` ) e, se qualcosa non torna,
   la storia ( `git log --follow -p <file>` );
3. si scrivono testata, docblock ed etichette, togliendo i `TODO documentare` sciolti;
4. **si verifica che il codice non sia cambiato**: per PHP, `php -l` e il confronto dei token al netto di
   commenti e spazi fra la versione di prima e quella di dopo ( `token_get_all()` scartando `T_COMMENT`,
   `T_DOC_COMMENT` e `T_WHITESPACE`: le due sequenze devono essere identiche );
5. un commit per gruppo omogeneo ( una libreria, un modulo, un gruppo di runlevel ), col messaggio nella
   forma solita del repository: *"documentazione di `_src/_lib/_mysql.tools.php` § …"*;
6. sui due repository upstream il file è quasi sempre condiviso ( vedi *"Perché glisweb e glisdev
   condividono gli inode"* nello `SKILL.md` ): **il commit va fatto su tutti e due**.
