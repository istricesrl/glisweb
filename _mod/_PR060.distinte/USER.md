# distinte

Il modulo *distinte* aggiunge alla scheda dell'**articolo** la linguetta **distinta**: l'elenco degli articoli che
compongono questo, ciascuno con la **quantità** che ne serve. Funziona solo insieme al modulo *prodotti*, che gestisce
gli articoli: senza, la linguetta non compare. È accessibile allo staff e agli amministratori.

Per le schede in generale vedi il capitolo [014 schede](../../_usr/_docs/_user/014.schede.md).

<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: catalogo.articoli.form.distinta -->

## la distinta

| campo | contenuto |
|---|---|
| componente | l'articolo che entra nella composizione; si cerca scrivendo almeno tre lettere del suo nome |
| quantità | quante unità del componente servono per un articolo |

Si aggiunge una riga per ogni componente; la riga vuota in fondo serve per aggiungerne uno nuovo.
