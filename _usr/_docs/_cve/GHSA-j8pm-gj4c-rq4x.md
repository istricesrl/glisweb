# GHSA-j8pm-gj4c-rq4x — commonmark: denial of service con code fence, reference link ed enfasi costruiti apposta

| | |
|---|---|
| componente | `league/commonmark` ( Composer ), parser del core |
| gravita' | alta, CVSS 3.1 7.5 ( `AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:N/A:H` ) |
| versioni affette | da 0.6.0 a prima della 2.9.1 ( l'unione di tre percorsi: code fence e reference link dalla 0.6.0, delimitatori di enfasi dalla 2.6.0 ) |
| versioni corrette | 2.9.1 |
| pubblicata | 2026-09-01 |
| valutata | 2026-10-27 |
| esito | affetta la versione installata, ma non esposto: commonmark converte solo la documentazione scritta dagli sviluppatori, da riga di comando |

riferimenti ufficiali
=====================
- advisory di commonmark: <https://github.com/thephpleague/commonmark/security/advisories/GHSA-j8pm-gj4c-rq4x>
- GitHub Advisory Database: <https://github.com/advisories/GHSA-j8pm-gj4c-rq4x>, segnalata da Dependabot
  sui repository `glisdev` e `glisweb`

effetti
=======
Consumo di CPU super-lineare: una singola riga di qualche centinaio di KB impegna il convertitore
per decine di secondi. Solo disponibilita'. Il percorso si raggiunge con la configurazione di
default, senza estensioni: basta poter far convertire il proprio markdown.

come si sfrutta
===============
Tre percorsi indipendenti del parser fanno lavoro super-lineare. Nel riconoscimento dei code fence
l'espressione regolare che verifica l'assenza di backtick nell'info string non e' atomica, e su una
riga lunga riprova il controllo a ogni lunghezza possibile del fence. La ricerca delle etichette dei
reference link e la gestione dei delimitatori di enfasi ( dalla 2.6.0 ) hanno costi analoghi.

esposizione del framework
=========================
La versione installata e' la 1.6.7 ( `"league/commonmark": "^1.6"` ): i percorsi dei code fence e
dei reference link ci sono, quello dei delimitatori di enfasi no ( dalla 2.6.0 ).

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
- 2026-10-27: prima valutazione; affetta la versione installata, ma non esposto: commonmark converte
  solo la documentazione scritta dagli sviluppatori, da riga di comando
