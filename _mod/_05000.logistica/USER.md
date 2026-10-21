# logistica

La **logistica** è l'area del menu che raccoglie ciò che riguarda la merce che si muove: quella che
esce verso i clienti ( il **ciclo attivo** ), quella che arriva dai fornitori ( il **ciclo
passivo** ) e i mezzi con cui la si sposta. Di suo porta soltanto la cornice — una dashboard con le
azioni, una pagina per ciascuno dei due cicli e un archivio — e il contenuto lo aggiungono gli
altri moduli.

Com'è fatta una dashboard e una pagina di riquadri lo dicono i capitoli *la dashboard e la cornice
dell'applicazione* e *la pagina strumenti*: qui si dice soltanto che cosa c'è in quest'area.

## la dashboard della logistica
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: logistica -->

Si apre dalla voce **logistica** del menu, e ha due linguette: la **dashboard** e le **azioni**,
dove sono previsti i gruppi esportazioni, importazioni ed elaborazioni. A differenza di altre aree
non ha una linguetta di stampe.

> **nota** — lo standard prepara le due pagine ma **non ci mette riquadri**: su un'installazione che
> non le ha personalizzate sono vuote, e in fondo c'è solo il pulsante per tornare indietro.

Tutte le pagine dell'area sono aperte solo a chi appartiene allo **staff** o agli
**amministratori**.

## le voci dell'area
<!-- @pubblico: operatore, amministratore -->

Aperta la voce *logistica*, il menu mostra sotto di lei le sotto-voci dell'area. Quali siano
dipende dai moduli attivi:

| sotto-voce | da dove viene | cosa si trova |
|---|---|---|
| ciclo attivo | questo modulo | la pagina della merce in uscita, qui sotto |
| ciclo passivo | questo modulo | la pagina della merce in entrata, qui sotto |
| veicoli | il modulo dei veicoli | i mezzi dell'azienda, con gli archiviati e le azioni |
| archivio | questo modulo | l'archivio dell'area, in fondo al capitolo |

## il ciclo attivo e il ciclo passivo
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: logistica.ciclo.attivo -->

Ciascuno dei due è una piccola dashboard con la sua linguetta **azioni**, dove sono previsti i
gruppi esportazioni, importazioni, elaborazioni e viste statiche. Sono i posti pensati per le
maschere delle spedizioni verso i clienti e dei ricevimenti dai fornitori.

> **nota** — nello standard nessun modulo aggiunge ancora voci ai due cicli: le pagine ci sono, ma
> sono vuote.

## l'archivio della logistica
<!-- @pubblico: amministratore -->
<!-- @pagina: logistica.archivio -->

È l'ultima voce dell'area, ed è il posto riservato agli elenchi di servizio. Ha due linguette,
**archivio** e **azioni**, con gli stessi gruppi di riquadri dei due cicli; nello standard è vuoto.

## quello che questo capitolo non dice ancora

- quali moduli occuperanno il ciclo attivo e il ciclo passivo, e con quali maschere;
- dove si consultano le **giacenze di magazzino** e come si aggiornano: nello standard l'area non ha
  maschere di magazzino;
- i riquadri che una personalizzazione tipica mette nella dashboard dell'area.
