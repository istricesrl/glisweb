# GHSA-g2gp-3wwq-f4ph — commonmark: denial of service con blocchi di attributi inline adiacenti ( Attributes )

| | |
|---|---|
| componente | `league/commonmark` ( Composer ), estensione `AttributesExtension` |
| gravita' | alta, CVSS 3.1 7.5 ( `AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:N/A:H` ) |
| versioni affette | da 1.5.0 a prima della 2.9.0 |
| versioni corrette | 2.9.0 |
| pubblicata | 2026-08-06 |
| valutata | 2026-10-27 |
| esito | non esposto: l'estensione Attributes non e' registrata, e commonmark non riceve input degli utenti |

riferimenti ufficiali
=====================
- advisory di commonmark: <https://github.com/thephpleague/commonmark/security/advisories/GHSA-g2gp-3wwq-f4ph>
- GitHub Advisory Database: <https://github.com/advisories/GHSA-g2gp-3wwq-f4ph>, segnalata da Dependabot
  sui repository `glisdev` e `glisweb`

effetti
=======
Consumo di CPU quadratico: qualche decina di KB di input impegna il convertitore per secondi. Solo
disponibilita'. Precondizione: l'applicazione registra `AttributesExtension` e converte markdown
scritto da altri.

come si sfrutta
===============
Per trovare il nodo a cui si applica un blocco di attributi, l'estensione scorre i fratelli del nodo
verso destra fino in fondo. Con una serie di N blocchi adiacenti all'inizio di un blocco, ognuno
scorre l'intera serie prima di ripiegare sul padre: Θ(N) a blocco, Θ(N²) in tutto. Il percorso non
dipende dall'allow-list degli attributi ne' dalle altre opzioni di sicurezza.

esposizione del framework
=========================
La versione installata e' la 1.6.7 ( `"league/commonmark": "^1.6"` ), dentro l'intervallo, ma il
percorso vulnerabile e' solo nell'estensione Attributes, che il framework non registra.

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
- 2026-10-27: prima valutazione; non esposto: l'estensione Attributes non e' registrata, e
  commonmark non riceve input degli utenti
