# documentazione del modulo contatti
Il modulo contatti serve a gestire i dati provenienti dai form esposti sui siti. Consente in modo relativamente
facile e intuitivo la registrazione dei dati inviati, la gestione dei consensi privacy, e l'innesco di meccaniche
specifiche per modulo tramite le relative controller.

# logica generale del modulo
Sui siti vengono esposti dei moduli i cui campi rispettano nel nome il seguente schema:

```
__ct__[<nomeModulo>][<nomeCampo>]
```

In questo modo quando viene fatto il submit il framework riceve un pacchetto dati __ct__ che può essere intercettato
dalla controller /_mod/_CT000.contatti/_src/_config/_750.controller.php. Questa si occupa di verificare il filtro anti
spam, di salvare i dati ricevuti, e di innescare le eventuali controller.

## configurazione delle controller
Le controller associate a ogni modulo vengono dichiarate nella configurazione; a un modulo possono essere associate
anche più controller. Un esempio di configurazione può essere:

```
contatti:
  nomemodulo:
    controller: 
        - "_mod/_CT000.contatti/_src/_inc/_controllers/_form/_nomemodulo.php"
```

## configurazione dei consensi privacy
Anche i consensi privacy associati al modulo vengono specificati nella configurazione. In questo caso le direttive
sono un po' più complesse, ma diventa tutto più chiaro una volta compresa la logica generale:

```
privacy:
    moduli:
        nomemodulo:
            titolo:
                it-IT: titolo del modulo
            descrizione:
                it-IT: descrizione del modulo
            consensi:
                NOMECONSENSO:
                    informativa:
                        it-IT: descrizione del consenso per l'informativa privacy
                    label:
                        it-IT: etichetta del consenso da mettere a fianco della spunta
                    action: chiave per l'azione (da prelevare dai microcontenuti)
                    page: ID della pagina di informativa da linkare
                    required: true o false
```

La generazione delle checkbox per la registrazione dei consensi può essere effettuata automaticamente a partire dalla
configurazione utilizzando la seguente macro:

```
{{ prv.checkConsensi( '__ct__', 'nomemodulo', privacy.moduli.nomemodulo, ietf, tr, pages ) }}
```

Questo genererà una serie di campi il cui nome rispetta questo formato:

```
__ct__[nomemodulo][__privacy__][NOMECONSENSO]
```

Questi campi vengono elaborati sempre nella controller /_mod/_CT000.contatti/_src/_config/_750.controller.php in modo
automatico tramite la funzione associazioneConsensiContatto() che si occupa di registrare sul database i consensi prestati
dall'utente.

Le tabelle coinvolte nel processo sono la consensi_anagrafica e la consensi_contatti, che registrano rispettivamente
i consensi prestati da una specifica anagrafica e quelli prestati tramite un dato modulo contatti. La legenda dei consensi
si trova nella tabella consensi.

## integrazione con reCAPTCHA
Per ridurre lo spam in ingresso, è raccomandabile integrare reCAPTCHA nel flusso di invio dei moduli esposti
pubblicamente sui siti. Il framework prevede già una macro che si occupa di creare il bottone di invio modulo
integrato con il codice di reCAPTCHA:

```
{{ cms.formButton( { 
    'field': { 'text': 'testo da riportare sul bottone' }, 
    'form': { 'id': 'idmodulo', 'table': '__ct__', 'subtable': 'nomemodulo' }, 
    'recaptcha': google.profile.recaptcha 
    } ) 
}}
```

Quando il pacchetto dati __ct__ arriva a /_mod/_CT000.contatti/_src/_config/_750.controller.php viene utilizzata
la funzione reCaptchaVerifyFormV3() per controllare se l'invio è spam o meno; solo se il sistema decide che non
si tratta di spam procede con l'elaborazione del blocco.

## log
Il modulo logga tutti gli invii che riceve, la factory di log principale è "contatti"; inoltre per sicurezza vengono
anche salvati tutti i blocchi dati ricevuti nella cartella /var/spool/contatti.

# gestione del front-end
Ci sono due principali approcci per la gestione lato front-end degli invii di moduli contatti. Il primo è la gestione
combinata in una pagina tutto-in-uno sia del form che del messaggio di thank-you. Il secondo approccio prevede due
pagine, una per il form e una per la thank-you page.

Se si preferisce l'approccio minimale con pagina tutto-in-uno è sufficiente utilizzare Twig per mostrare alternativamente
il modulo o il messaggio di ringraziamento (o eventuali messaggi di errore):

```
{% if request.__ct__.default.__status__ == 'OK' %}
<p>
     modulo ricevuto, tutto ok!
</p>
{% else %}
<form method="post" action="" id="esempioform">
    <input type="text" name="__ct__[default][nome]">
    <input type="text" name="__ct__[default][mail]">
    {{ prv.checkConsensi( '__ct__', 'default', privacy.moduli.default, ietf, tr, pages ) }}
    {{ cms.formButton( { 
        'field': { 'text': 'INVIA' }, 
        'form': { 'id': 'esempioform', 'table': '__ct__', 'subtable': 'default' }, 
        'recaptcha': google.profile.recaptcha 
        } ) 
    }}
</form>
{% endif %}
```

Diversamente, la logica andrà spezzata su due pagine, nella prima il modulo e nella seconda il
messaggio di thank-you; anche in questo caso può giovare l'uso di Twig per intercettare eventuali
errori.
