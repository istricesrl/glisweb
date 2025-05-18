TEMPLATE DEMETRA
================

FILE DEL TEMPLATE
=================

UTILIZZO DEL TEMPLATE
=====================

pagine view
-----------

pagine form
-----------
Le pagine form servono a manipolare una specifica entità e le sue entità collegate, ad esempio un'anagrafica con i suoi
numeri di telefono, le mail, eccetera. Come solito, anche le pagine form sono composte da una macro che setta i parametri
di funzionamento della pagina e un template che li rappresenta all'utente. Nella macro è importante configurare alcuni
aspetti del form, e in particolare:

```php

// tabella gestita
$ct['form']['table'] = '<nomeEntità>';

// pagina di destinazione
$ct['form']['action'] = $ct['page']['url'][ LINGUA_CORRENTE ];

// metodo da utilizzare
$ct['form']['method'] = ( ! empty( $_REQUEST[ $ct['form']['table'] ] ) ) ? 'post' : 'update';

// attività svolta
$ct['form']['activity'] = ( ! empty( $_REQUEST[ $ct['form']['table'] ] ) ) ? 'inserimento' : 'aggiornamento';

```

Si noti che l'unica di queste tre direttive ad essere obbligatoria è la prima, se fra le macro di pagina è inclusa 
anche la _src/_inc/_macro/_default.form.php in quanto le tre successive (action, method e activity) vengono impostate
lì di default.
