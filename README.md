come installare GlisWeb
=======================
Questa procedura descrive come installare il framework GlisWeb per lo sviluppo di progetti con
il framework; per sviluppare il framework invece leggere la sezione *installare il framework per
contribuire*.

Per iniziare un nuovo progetto che utilizza il framework GlisWeb, accedete via SSH al
vostro server e scaricate lo zip del repository nella document root:

```
wget https://github.com/istricesrl/glisdev/archive/refs/heads/develop.zip
```

una volta scaricato il file, scompattatelo:

```
bsdtar --strip-components=1 -xf develop.zip
rm -f develop.zip
```

Per iniziare a lavorare con il framework è necessario creare un file di configurazione minimale
in */src/config.yaml*; prima di iniziare assicurarsi di avere a portata di mano i dati di connessione
al database e l'hash della password di root (potete generarlo usando */_src/_sh/_password.hash.sh*):

```
sites:
  1:
    __label__: "nome del tuo sito"
    name:
      it-IT: "nome del tuo sito"
    protocols:
      DEV: "https"
    hosts: 
      DEV: "nome host del tuo sito"
    domains:
      DEV: "dominio del tuo sito"
    homes:
      DEV: 1
auth:
  accounts:
    root:
      password: "hash md5 della password di root"
mysql:
  servers:
    default:
      address: "indirizzo del tuo server MySQL"
      port: "porta del tuo server MySQL"
      username: "nome utente per l'accesso al database"
      password: "password per l'accesso al database"
      db: "nome del database"
  profiles:
    DEV:
      servers:
        - "default"
mods:
  active:
    array:
      - "AN000.anagrafica"
      - "03000.contenuti"
      - "PA000.pagine"
      - "CO000.contenuti"
```

A questo punto il framework è raggiungibile tramite web, ma non configurato. Per vedere la situazione
e verificare che sia tutto ok aprite un browser su *http://nomesito/status*; se è andato tutto a buon fine,
vedrete un report sullo stato del framework; altrimenti una serie di errori parlanti vi guiderà
al completamento dell'installazione.

Gli step che saranno più frequentemente richiesti in questa fase sono la sistemazione dei permessi
(per la quale è necessario lanciare */_src/_sh/_lamp.permissions.secure.sh* o */_src/_sh/_nginx.permissions.secure.sh*)
e l'esecuzione di *composer update*. Si noti che l'esecuzione di */_src/_sh/_nginx.permissions.secure.sh*
richiede la presenza, nella cartella che contiene la document root del sito, di un file *nginxuser.conf*
contenente il nome utente al quale assegnare la proprietà del sito.

Quando è tutto in ordine, prima di procedere con il login è opportuno lanciare il task di popolazione del database
accedendo all'indirizzo *http://nomesito/task/mysql.patch*.

Una volta che tutto funziona, è possibile accedere al CMS del framework all'indirizzo *http://nomesito/admin*.

installazione su CloudPanel (https://www.cloudpanel.io/)
--------------------------------------------------------
Per rendere il framework pienamente funzionante su CloudPanel è necessario apportare una modifica al file
di configurazione del Virtual Host di Nginx, in particolare è necessario modificare la sezione server (8080)
come segue:

```
server {
  listen 8080;
  listen [::]:8080;
  server_name www.fabiomosti.it www1.fabiomosti.it;
  {{root}}

  include /etc/nginx/global_settings;

  index index.php;

  location / {
    rewrite ^ /index.php?$query_string last;
  }

  # Esegui solo index.php (opzionale ma consigliato)
  location = /index.php {
    include fastcgi_params;
    fastcgi_intercept_errors on;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    fastcgi_read_timeout 3600;
    fastcgi_send_timeout 3600;
    fastcgi_param HTTPS "on";
    fastcgi_param SERVER_PORT 443;
    fastcgi_pass 127.0.0.1:{{php_fpm_port}};
    fastcgi_param PHP_VALUE "{{php_settings}}";
  }

  # Blocca l’esecuzione di qualsiasi altro .php (consigliato)
  location ~ \.php$ {
    return 404;
  }
}
```

inoltre se la sezione server (80) del sito web contiene un blocco come questo, rimuoverlo:

```
if (-f $request_filename) {
    break;
}
```

in quanto farebbe servire i file statici direttamente senza passare per il front controller.

Infine è necessario aggiungere alla configurazione di Varnish (nel blocco vcl_backend_response)
la seguente configurazione:

```
if (beresp.http.X-GlisWeb-No-Cache == "true") {
    set beresp.ttl = 0s;
    set beresp.uncacheable = true;
    unset beresp.http.Cache-Control;
    unset beresp.http.Expires;
    unset beresp.http.Pragma;
    unset beresp.http.X-Cache-Lifetime;
    unset beresp.http.X-Cache-Tags;
    return (deliver);
}
```

per fare in modo che GlisWeb possa governare la cache di Varnish. Senza questa configurazione, è necessario
disattivare Varnish per assicurarsi un comportamento corretto del framework.

Se si hanno problemi con php8.5 e i moduli, tornare a php8.4 dopo aver lanciato _nginx.setup.sh.

installazione su XAMPP
----------------------
Per installare il framework su XAMPP è sufficiente scaricare lo zip del codice e scompattarlo nella document root; se
viene richiesta l'installazione di moduli di PHP aggiuntivi scaricateli da https://pecl.php.net/packages.php.

installare il framework per contribuire
---------------------------------------
Questa sezione è attualmente in aggiornamento.
