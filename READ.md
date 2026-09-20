# GlisWeb — dove trovare la documentazione

Questo file non è la documentazione: è il cartello che dice dov'è. Fino al 16/09/2026 conteneva il
manuale sviluppatore per intero — architettura, quick start, la reference di tutti i file, la FAQ e il
glossario — ed era l'unico posto in cui quel materiale stava. Adesso ognuno di quei pezzi vive dove
appartiene, e questo file rimanda.

## i documenti

La documentazione si genera con `_src/_sh/_docs.build.sh --all` e si legge via HTTP. I sorgenti sono
markdown e stanno nel repository; le pagine no.

⚠ **Quelli dello standard sono pubblici, quelli del progetto no.** I primi descrivono il framework e
si mostrano a chiunque — sono il link che l'applicazione offre ai suoi utenti, che la password del
manuale non ce l'hanno; i secondi descrivono le personalizzazioni del cliente e stanno dietro Basic
auth, con l'utente `docs`.

| documento | sorgente | si legge in | accesso |
|---|---|---|---|
| manuale sviluppatore dello standard | `_usr/_docs/READ.md` e `_usr/_docs/_read/*.md` | `/_manual/read/index.html` | pubblico |
| manuale utente dello standard | `_usr/_docs/USER.md` e `_usr/_docs/_user/*.md` | `/_manual/user/index.html` | pubblico |
| quickstart sviluppatore | `_usr/_docs/_quickstart/*.md` | `/_quickstart/index.html` | pubblico |
| manuale sviluppatore del progetto | i sorgenti dello standard **più** `usr/docs/READ.md` e `usr/docs/read/*.md` | `/manual/read/index.html` | Basic auth |
| manuale utente del progetto | i sorgenti dello standard **più** `usr/docs/USER.md` e `usr/docs/user/*.md` | `/manual/user/index.html` | Basic auth |
| quickstart del progetto | `usr/docs/quickstart/*.md` | `/quickstart/index.html` | Basic auth |
| reference delle API | i docblock nel codice, via Doxygen | `/docs/`, dove esiste `var/docs.public.conf` | pubblico |

I tre dello standard si generano solo dove esiste `var/docs.build.conf`, cioè sui deploy del
framework: un deploy cliente genera i suoi e basta. Ogni documento rimanda agli altri, quindi da uno
qualsiasi si arriva a tutti — e da uno pubblico si arriva ai soli pubblici, per non mandare un
utente a sbattere contro una richiesta di password.

**Chi parte da zero legge la quickstart**, non il manuale: `_usr/_docs/_quickstart/010.da-zero-a-hero.md`
porta un'installazione appena scompattata fino a un sito con pagine, database, CMS e moduli.

## dov'è finito cosa

| cosa stava qui | dove sta adesso |
|---|---|
| architettura generale | `_usr/_docs/READ.md`, l'introduzione del manuale |
| quick start, i sei passi | la quickstart, che li copre tutti e sei più estesamente |
| reference dei file del core | `_usr/_docs/_read/21x.file.*.md`, un capitolo per area dell'albero |
| reference dei file dei moduli | il `READ.md` **dentro ciascun modulo** |
| la domanda sul form di Athena | il `READ.md` **dentro il template** |
| FAQ, le domande che erano procedure | i capitoli `howto` della fascia `4xx`, o il capitolo del loro argomento |
| FAQ, quello che resta | `_usr/_docs/_read/910.faq.md` |
| glossario | `_usr/_docs/_read/950.glossario.md` |

La regola che spiega la seconda metà della tabella: **la documentazione di un componente sta nel
componente**, accanto al codice che descrive. Il manuale la raccoglie come capitolo e la linka, non la
copia — così non esistono due versioni della stessa pagina che divergono al primo aggiornamento.

## la documentazione si controlla

`_src/_sh/_docs.check.sh` verifica che la documentazione non si sia scollata dal codice, e tace se non
c'è niente da segnalare:

```bash
_src/_sh/_docs.check.sh              # i rilievi su cui si può agire
_src/_sh/_docs.check.sh --copertura  # ogni file standard, e dove è documentato
_src/_sh/_docs.check.sh --metriche   # i numeri del debito
_src/_sh/_docs.check.sh --todo       # i rilievi nel formato delle voci di TODO.md
```

Il controllo cerca le sezioni `### /percorso` in **tutti** i sorgenti — i capitoli del manuale, i
`READ.md` dei moduli, quelli dei template — e segnala tre cose: i file che nessuno descrive, le sezioni
che descrivono file che non esistono più, e i file descritti in più di un posto.

## il resto

- le regole operative per lavorare sul framework: `_etc/_claude/_claude.framework.md`
- il bootstrap di un progetto nuovo: la skill `glisweb`, `bash .claude/skills/glisweb/bootstrap.sh`
- la versione e la release correnti: `_etc/_current.version` e `_etc/_current.release`
