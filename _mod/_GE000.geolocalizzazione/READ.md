# modulo geolocalizzazione

Il modulo geolocalizzazione raccoglie tutto quello che serve a dare le coordinate agli indirizzi: la configurazione
del servizio, le librerie di geocoding e di calcolo sulle coordinate e i task che lavorano la coda. Senza il modulo
il framework non geolocalizza nulla; con il modulo attivo ma senza un servizio configurato i task non fanno nulla.

# logica generale del modulo
Ogni riga di `anagrafica_indirizzi` porta in linea i suoi campi e il suo blocco di geolocalizzazione ( `latitudine`,
`longitudine`, `token`, `timestamp_geolocalizzazione`, `note_geolocalizzazione`, `id_zona` ): è quella la verità, e
`id_indirizzo` resta solo come ponte facoltativo verso la geografia ( tabella `indirizzi` ), come deciso il 06/10/2026
nella revisione canonica dello schema. Lo stesso blocco esiste su `indirizzi`, che resta l'ultimo livello della
geografia per i moduli che ne hanno bisogno.

La geolocalizzazione avviene una riga alla volta con lo schema a token: il task marca con il proprio token una riga
senza coordinate ( o modificata dopo l'ultima geolocalizzazione ), la legge con comune, provincia e stato, chiede le
coordinate al servizio e le scrive togliendo il token; se il servizio non risponde scrive solo
`timestamp_geolocalizzazione`, così la riga va in fondo alla coda. Ogni risposta del servizio finisce in un file di
log in `var/log/geocode/`.

## task
- `_src/_api/_task/_anagrafica.indirizzi.geocode.php` geolocalizza le righe di `anagrafica_indirizzi`; il CAP
  restituito dal servizio si scrive solo se la riga non ne ha uno;
- `_src/_api/_task/_indirizzi.geocode.php` geolocalizza le righe di `indirizzi`.

Entrambi accettano `id=<id>` per forzare una riga e richiedono il privilegio `GESTIONE_ANAGRAFICA`.

## librerie
- `_src/_lib/_mapquest.tools.php`: `mapquestGetCoords()` e `mapquestGetCachedCoords()`;
- `_src/_lib/_geocode.tools.php`: distanza fra coordinate, conversioni gradi/decimali, `splitAddress()`.

Le funzioni sono dichiarate dentro `if( ! function_exists() )` perché sulla linea oldstable le stesse librerie
esistono ancora nel core per i moduli legacy: il modulo si può attivare anche lì senza ridichiararle.

## configurazione
I runlevel `_src/_config/_520.mapquest.php` e `_525.mapquest.php` definiscono server e profili Mapquest, integrati
dalla chiave `mapquest` dei file di configurazione; la chiave va nello shadow:

```yaml
mapquest:
  servers:
    mapquest:
      key: "..."
  profiles:
    PROD:
      servers:
        - "mapquest"
```

## dipendenze
`restCall()`, `appendToFile()`, `string2rewrite()`, `logWrite()` e le funzioni memcache del core.
