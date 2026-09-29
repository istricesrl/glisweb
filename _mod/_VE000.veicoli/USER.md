# veicoli

Il modulo tiene l'elenco dei **mezzi dell'azienda**: furgoni, auto, camion, carrelli. È il posto
dove si ritrovano targa, modello e costruttore di ogni mezzo senza cercarli nei documenti.

Il modulo sta nell'area **logistica**, alla voce **veicoli**, ed è aperto a chi appartiene allo
**staff** o agli **amministratori**.

## l'elenco dei veicoli
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: logistica.veicoli.view -->

Mostra una riga per veicolo, in ordine alfabetico. Un clic su una riga apre la scheda, il più ne
apre una nuova.

Le altre linguette sono **tipologie** ( i tipi di mezzo, più sotto ), **archiviati** e **azioni**.

## la scheda di un veicolo
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: logistica.veicoli.form -->

La linguetta *gestione* ha tre riquadri:

| riquadro | campi |
|---|---|
| dati generali | **tipologia**, dall'elenco delle tipologie; **targa**; **nome**, il modo in cui il mezzo viene chiamato in azienda ( *il furgone grande* ) |
| costruttore e modello | **costruttore**, scelto fra le anagrafiche che hanno la scheda di produttore; **modello** |
| descrizione | annotazioni libere sul mezzo |

Le altre linguette della scheda sono **archiviazione** e **azioni**.

> **nota** — il **costruttore** si sceglie solo fra le anagrafiche che hanno la scheda di
> *produttore*: se la casa costruttrice non compare nella tendina, va registrata nell'anagrafica e
> compilata quella scheda ( vedi il capitolo dell'anagrafica ).

## le tipologie
<!-- @pubblico: amministratore -->
<!-- @pagina: logistica.tipologie.veicoli.view -->

La linguetta **tipologie** elenca i tipi di mezzo che si possono scegliere nelle schede. Le
tipologie si annidano — *mezzi pesanti → autocarri* — e ognuna ha:

| campo | contenuto |
|---|---|
| genitore | la tipologia che la contiene |
| nome | il nome della tipologia |
| ordine | la posizione nella tendina |
| entità HTML, icona Font Awesome | il simbolo associato alla tipologia, in una delle due forme |

La scheda di una tipologia ha anche la linguetta **azioni**.

> **attenzione** — cambiare una tipologia cambia ciò che vedono **tutti** i veicoli che la usano:
> è un lavoro da fare di rado e con un motivo.

## archiviare invece di cancellare
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: logistica.veicoli.form.archiviazione -->

Un mezzo venduto o rottamato **si archivia**: nella linguetta *archiviazione* si compilano la
**data** e le **note** che spiegano perché. Da quel momento esce dall'elenco ordinario e si trova in
*archiviati*, con tutti i suoi dati.

Le linguette *azioni* hanno la forma di tutte le pagine di riquadri ( vedi il capitolo *la pagina
strumenti* ): sono previsti i gruppi esportazioni, importazioni, elaborazioni e viste statiche, ma
lo standard non ci mette riquadri.

## quello che questo capitolo non dice ancora

- se e dove un veicolo compare fuori da qui: nello standard nessun'altra maschera lo collega a
  consegne, missioni o persone;
- le scadenze di un mezzo — revisione, assicurazione, bollo — che la scheda non tiene.
