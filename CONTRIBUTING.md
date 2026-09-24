# come contribuire
Il nostro progetto è in continua crescita, e ogni aiuto è il benvenuto! In particolare, apprezzeremmo una mano nella gestione dei seguenti compiti:

- traduzione e localizzazione
- refactoring e debug
- segnalazione di bug
- implementazione di nuove feature
- richiesta di nuove feature
- documentazione

## segnalazioni e richieste
Se utilizzate il nostro framework e desiderate contribuire, potete farlo anche semplicemente segnalandoci qualsiasi anomalia riscontrate, o richiedendo caratteristiche che possono esservi utili - con ogni probabilità lo saranno anche per altri! Bug e richieste si aprono come issue su GitHub, nel repository della linea che state usando: [glisweb](https://github.com/istricesrl/glisweb/issues) per la stable, [glisdev](https://github.com/istricesrl/glisdev/issues) per la unstable.

Le vulnerabilità di sicurezza invece **non** vanno segnalate con una issue: seguite la [security policy](SECURITY.md).

## contribuire con il codice
Se siete sviluppatori, e desiderate contribuire con il vostro codice, potete creare delle pull request e verranno senz'altro apprezzate! Qualche indicazione per farle arrivare in fondo:

- lo sviluppo avviene su [glisdev](https://github.com/istricesrl/glisdev), la linea unstable, sul ramo `develop`: le pull request vanno aperte lì;
- dopo aver clonato il repository attivate una volta sola i git hook di sviluppo con `sudo _src/_sh/_githooks.install.sh`, come spiegato nella [guida all'installazione](https://github.com/istricesrl/glisweb/blob/develop/_usr/_docs/_quickstart/020.installazione.md); da quel momento ogni commit aggiorna la versione del framework;
- la prima riga del messaggio di commit si divide sul carattere § in titolo e testo, che finiscono nel changelog: `titolo della modifica § descrizione estesa della modifica`;
- **non inventate niente se nel framework esiste già qualcosa di simile**: la coerenza è la caratteristica su cui il framework si regge, quindi un runlevel, una libreria, un modulo o uno script nuovi si scrivono a partire da due o tre esempi dello stesso tipo, copiandone nomi, forma e stile. Le regole complete sono in [`_etc/_claude/_claude.framework.md`](https://github.com/istricesrl/glisweb/blob/develop/_etc/_claude/_claude.framework.md), che vale per le persone quanto per gli assistenti AI;
- la documentazione fa parte della modifica: i manuali stanno in `_usr/_docs/`, e ogni modulo e template ha il suo `READ.md`. Codice, commenti e documentazione sono in italiano.

## la community
Se desiderate partecipare alla nostra community, per fare domande, chiedere aiuto o discutere del framework, unitevi al nostro [server Discord](https://discord.gg/2nynQcXAWf). Chi partecipa si impegna a rispettare il nostro [codice di condotta](CODE_OF_CONDUCT.md).

## supporto economico
Se non siete in grado di contribuire tecnicamente, potete sempre darci un supporto economico, anche minimo, seguendo le istruzioni per gli sponsor: https://github.com/sponsors/istricesrl
