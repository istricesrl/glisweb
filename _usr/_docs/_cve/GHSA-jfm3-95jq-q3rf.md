# GHSA-jfm3-95jq-q3rf — commonmark: denial of service con definizioni di footnote duplicate

| | |
|---|---|
| componente | `league/commonmark` ( Composer ), estensione `FootnoteExtension` |
| gravita' | alta, CVSS 3.1 7.5 ( `AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:N/A:H` ) |
| versioni affette | da 1.5.0 a prima della 2.9.0 |
| versioni corrette | 2.9.0 |
| pubblicata | 2026-08-06 |
| valutata | 2026-10-27 |
| esito | non esposto: l'estensione Footnote non e' registrata, e commonmark non riceve input degli utenti |

riferimenti ufficiali
=====================
- advisory di commonmark: <https://github.com/thephpleague/commonmark/security/advisories/GHSA-jfm3-95jq-q3rf>
- GitHub Advisory Database: <https://github.com/advisories/GHSA-jfm3-95jq-q3rf>, segnalata da Dependabot
  sui repository `glisdev` e `glisweb`

effetti
=======
Amplificazione quadratica di output, CPU e memoria: pochi KB di input producono decine di MB di HTML
e centinaia di MB di memoria, abbastanza per far terminare un processo PHP col `memory_limit` di
default. Solo disponibilita'. Precondizione: l'applicazione registra `FootnoteExtension` e converte
markdown scritto da altri.

come si sfrutta
===============
L'estensione registra un rimando per ogni riferimento a una nota e poi aggiunge l'intero elenco dei
rimandi a **ogni** blocco di definizione, senza togliere le definizioni ripetute della stessa
etichetta: N riferimenti e N definizioni duplicate producono N × N nodi.

esposizione del framework
=========================
La versione installata e' la 1.6.7 ( `"league/commonmark": "^1.6"` ), dentro l'intervallo, ma il
percorso vulnerabile e' solo nell'estensione Footnote, che il framework non registra.

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

La versione corretta arriva col passaggio a PHP 8: il `composer.json` ammette
`"league/commonmark": "^1.6 || ^2.10"`, e su PHP 8 si installa la 2.10. Se un giorno il framework convertisse markdown scritto dagli utenti,
andra' fatto **dopo** quel passaggio, o con un limite alla lunghezza dell'input.

storia
======
- 2026-10-27: prima valutazione; non esposto: l'estensione Footnote non e' registrata, e commonmark
  non riceve input degli utenti
