# modulo modula

Il modulo collega il framework al **WMS Modula** ( i magazzini verticali automatici ) con il
protocollo **WebService 1.11** del WMS. Il WMS è configurato in **modalità server** e il framework fa
da client:

- manda gli ordini al job di import, in `POST`;
- scarica gli esiti dal job di export, in `GET`, un pacchetto alla volta;
- conferma ogni pacchetto con l'ack, che lo toglie dalla coda del WMS.

Per ora il modulo porta il **client** e un **server finto** per collaudarlo. Le maschere, i task di
invio e di ritorno e le tabelle di appoggio arriveranno con le fasi successive dell'integrazione.

## configurazione

La configurazione ha un profilo per ambiente, come `mysql` o `teamsystem`, e il codice legge
sempre da `$cf['modula']['profile']`. I default stanno in `_src/_config/_030.common.php`, tutti a
`NULL` tranne nomi dei job, tipo di autenticazione e timeout. In `_035.common.php` il ramo
`modula` di `config.json` si fonde sopra i default e il profilo si aggancia a `SITE_STATUS`.

Nel `config.json` del progetto vanno l'indirizzo e i job:

```json
"modula": {
    "profiles": {
        "PROD": {
            "url": "http://<indirizzo del WMS>:<porta>",
            "auth": "bearer",
            "jobs": { "import": "CFG-IMP-ORDINI", "export": "CFG-EXP-ORDINI" }
        }
    }
}
```

Utente e password vanno nello `shadow.json`, mai nel `config.json`:

```json
"modula": { "profiles": { "PROD": { "username": "...", "password": "..." } } }
```

| chiave | cosa | default |
|---|---|---|
| `url` | indirizzo di base del WMS, senza la barra finale; vuoto = modulo spento | `NULL` |
| `auth` | `bearer`, con token da `/token`, oppure `basic` | `bearer` |
| `username`, `password` | credenziali del WMS, nello shadow | `NULL` |
| `jobs.import`, `jobs.export` | nomi dei job configurati sul WMS | `CFG-IMP-ORDINI`, `CFG-EXP-ORDINI` |
| `timeout` | secondi di attesa di ogni chiamata | `30` |

Con `url` vuoto ogni chiamata scrive un `WARNING` nel log e restituisce `NULL`, quindi gli ambienti
senza Modula non devono fare niente.

## le funzioni

Stanno in `_src/_lib/_modula.utils.php`.

| funzione | cosa fa |
|---|---|
| `modulaQta2Testo( $q )` | numero → testo per il WMS, con la virgola e tre decimali ( `12.5` → `"12,500"` ) |
| `modulaTesto2Qta( $t )` | testo del WMS → numero |
| `modulaToken( $rinnova )` | token Bearer, tenuto in memcache sotto `MODULA_TOKEN`; con `$rinnova` ne chiede uno nuovo |
| `modulaChiamata( $percorso, $metodo, $dati, &$status, &$raw )` | chiamata generica; il percorso comincia con `/`; in Bearer, su un `401` rinnova il token e riprova una volta |
| `modulaImport( $ordini, $righe, $job, &$errore )` | manda `IMP_ORDINI` e `IMP_ORDINI_RIGHE`; `true` se il WMS risponde `200`, altrimenti `false` con `"<status> <risposta>"` in `$errore` |
| `modulaExport( $job, &$status )` | il prossimo pacchetto di esiti, con `GUID`, `TransactionStatus` ( `CHUNK` o `END` ) e `DATA`; `NULL` quando non c'è niente ( `204` ) o in caso di errore |
| `modulaAck( $guid, $job )` | conferma il pacchetto; finché non lo si conferma, l'export restituisce sempre lo stesso |

⚠ Le quantità vanno al WMS **come testo** ( `"1,000"` ): un numero JSON viene rifiutato con `400`.
Per questo passano sempre da `modulaQta2Testo()` e `modulaTesto2Qta()`.

## il server finto

`_usr/_test/_fake/_wms.php` risponde come il WMS: token, import, export a pacchetti con l'ack,
`401` senza credenziali. Ha due comportamenti per i test:

- le righe dell'articolo `MANCA` tornano evase a `"0,000"`;
- il job `ERR-503` risponde sempre `503`.

Le credenziali sono `modula` / `fake`, e `POST /reset` svuota lo stato.

Il file **non fa il bootstrap** del framework, così le credenziali finte non finiscono nel log degli
accessi falliti. Lo stato sta in `var/spool/modula/fake/`. Il server risponde solo se il file
`var/test/modula.fake.on` ha meno di dieci minuti, altrimenti dà `404`. Gli esempi lo creano da
soli; per usarlo a mano basta un `touch`.

## i test

Ogni funzione ha il suo esempio in `_usr/_examples/_lib/_modula.utils/`: punta il profilo sul
server finto e stampa l'esito. `_usr/_test/_tests/unit/modulaUtilsCest.php` ne controlla l'output.
I test girano solo col modulo attivo:

    sudo _src/_sh/_codeception.run.sh unit I0200.modula/modulaUtilsCest.php

## i file del modulo

### /_mod/_I0200.modula/_src/_config/_030.common.php
In questo file vengono dichiarati i default dei profili del modulo modula.

### /_mod/_I0200.modula/_src/_config/_035.common.php
In questo file la configurazione del modulo modula viene fusa con quella del progetto e collegata al profilo corrente.

### /_mod/_I0200.modula/_src/_lib/_modula.utils.php
Questa è la libreria del client REST verso il WMS Modula.

### /_mod/_I0200.modula/_usr/_examples/_lib/_modula.utils/
Gli esempi delle funzioni della libreria, usati dai test unitari.

### /_mod/_I0200.modula/_usr/_test/_fake/_wms.php
Questo è il server finto del WMS Modula, per i test.

### /_mod/_I0200.modula/_usr/_test/_tests/unit/modulaUtilsCest.php
Questi sono i test unitari della libreria del modulo modula.
