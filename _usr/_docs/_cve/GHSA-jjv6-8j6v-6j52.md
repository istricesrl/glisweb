# GHSA-jjv6-8j6v-6j52 — commonmark: denial of service nelle estensioni SmartPunct e Attributes

| | |
|---|---|
| componente | `league/commonmark` ( Composer ), estensioni `SmartPunctExtension` e `AttributesExtension` |
| gravita' | alta, CVSS 3.1 7.5 ( `AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:N/A:H` ) |
| versioni affette | da 1.5.0 a prima della 2.9.1 ( SmartPunct dalla 2.0.0 ) |
| versioni corrette | 2.9.1 |
| pubblicata | 2026-09-01 |
| valutata | 2026-10-27 |
| esito | non esposto: nessuna delle due estensioni e' registrata, e commonmark non riceve input degli utenti |

riferimenti ufficiali
=====================
- advisory di commonmark: <https://github.com/thephpleague/commonmark/security/advisories/GHSA-jjv6-8j6v-6j52>
- GitHub Advisory Database: <https://github.com/advisories/GHSA-jjv6-8j6v-6j52>, segnalata da Dependabot
  sui repository `glisdev` e `glisweb`

effetti
=======
Consumo di CPU quadratico: un documento di circa un MB costruito apposta impegna un processo per
decine di secondi. Solo disponibilita'. Precondizione: l'applicazione registra una delle due
estensioni e converte markdown scritto da altri.

come si sfrutta
===============
In `SmartPunctExtension` ogni apice rimasto spaiato viene riconvertito in testo e fuso coi nodi
vicini, e ogni fusione ricopia per intero un nodo di testo che continua a crescere. In
`AttributesExtension` un percorso analogo rielabora piu' volte lo stesso insieme. Nessuna delle due
estensioni e' compresa nei convertitori standard: chi non le registra non e' affetto.

esposizione del framework
=========================
La versione installata e' la 1.6.7 ( `"league/commonmark": "^1.6"` ), dentro l'intervallo per la
parte Attributes; il framework non registra nessuna delle due estensioni.

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
- 2026-10-27: prima valutazione; non esposto: nessuna delle due estensioni e' registrata, e
  commonmark non riceve input degli utenti
