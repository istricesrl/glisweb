# GHSA-c2pc-g5qf-rfrf — commonmark: denial of service per complessita' polinomiale del parser

| | |
|---|---|
| componente | `league/commonmark` ( Composer ), parser del core |
| gravita' | alta, CVSS 3.1 7.5 ( `AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:N/A:H` ) |
| versioni affette | precedenti a 2.6.0 |
| versioni corrette | 2.6.0 |
| pubblicata | 2024-12-09 |
| valutata | 2026-10-27 |
| esito | affetta la versione installata, ma non esposto: commonmark converte solo la documentazione scritta dagli sviluppatori, da riga di comando |

riferimenti ufficiali
=====================
- advisory di commonmark: <https://github.com/thephpleague/commonmark/security/advisories/GHSA-c2pc-g5qf-rfrf>
- GitHub Advisory Database: <https://github.com/advisories/GHSA-c2pc-g5qf-rfrf>, segnalata da Dependabot
  sui repository `glisdev` e `glisweb`

effetti
=======
Esaurimento delle risorse con input costruito per raggiungere il caso peggiore del parser; piu'
richieste in parallelo occupano CPU e processi PHP. Solo disponibilita'.

come si sfrutta
===============
Diversi percorsi del parser hanno complessita' polinomiale, gli stessi trovati in altri parser
markdown ( commonmark.js, cmark-gfm ): un input costruito apposta li porta al caso peggiore.
L'advisory indica come mitigazioni, per chi non puo' aggiornare, limiti bassi di memoria e tempo,
limiti alla lunghezza delle righe e l'uso della libreria solo con utenti fidati.

esposizione del framework
=========================
La versione installata e' la 1.6.7 ( `"league/commonmark": "^1.6"` ), dentro l'intervallo. Delle
mitigazioni indicate dall'advisory vale la piu' forte: la libreria la usano solo utenti fidati.

Il framework usa commonmark in un punto solo: `docsMarkdown2Html()` ( `_src/_lib/_docs.tools.php` ),
chiamata da `_src/_cli/_docs.build.php`, cioe' dalla generazione dei manuali da riga di comando
( `_src/_sh/_docs.build.sh` ). **Nessuna richiesta HTTP converte markdown**: i manuali si servono gia'
generati. Il markdown convertito e' quello dei sorgenti della documentazione ( `_usr/_docs/`,
`usr/docs/`, i `READ.md` e `USER.md` dei moduli ), scritto dagli sviluppatori e versionato: nessun
utente puo' far arrivare il suo testo al convertitore.

Il convertitore e' `GithubFlavoredMarkdownConverter`, senza estensioni aggiunte: oltre al core ci sono
solo quelle del GFM ( autolink, tabelle, barrato, liste di attivita', HTML non consentito ).

come ci siamo protetti
======================
**Nessuna modifica al framework**: commonmark non riceve input che non sia degli sviluppatori.

La versione corretta arriva col passaggio a PHP 8: il branch `php8` di glisweb dichiara gia'
`"league/commonmark": "^2.10"`. Se un giorno il framework convertisse markdown scritto dagli utenti,
andra' fatto **dopo** quel passaggio, o con un limite alla lunghezza dell'input.

storia
======
- 2026-10-27: prima valutazione; affetta la versione installata, ma non esposto: commonmark converte
  solo la documentazione scritta dagli sviluppatori, da riga di comando
