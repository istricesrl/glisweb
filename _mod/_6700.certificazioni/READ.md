# modulo certificazioni

> **attenzione** — di questo modulo è documentato per ora il solo controller. A cosa serve, come si configura e
> come lo si usa sono da scrivere.

## i file del modulo

### /_mod/_6700.certificazioni/_src/_inc/_controllers/_anagrafica.certificazioni.before.php
Controller before della tabella `anagrafica_certificazioni`. Su `DELETE` cancella i file allegati alla
certificazione: la riga di `file` e il file sul disco. La FK `file.id_anagrafica_certificazioni` è `ON DELETE
CASCADE` e toglie le righe, ma non passa da `controller()` e il file restava sul disco: per un certificato medico
sono dati sanitari senza padrone ( polmasi, 04/11/2026: 99 file ). Lo fa nel before perché dopo la cancellazione le
righe di `file` non dicono più a quale certificazione appartenevano. Un percorso usato anche da un'altra riga di
`file` non si cancella dal disco. Test: `_usr/_test/_tests/backend/certificazioniFileCest.php` del modulo.
