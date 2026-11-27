-- 2026-11-05 — template: ruolo diventa codice, via latenza_invio
--
-- Schema canonico, punto 6, riga 189, decisione di Fabio del 05/11/2026 ( opzione B ): la colonna ruolo di template non
-- e' un ruolo ( nel canone un ruolo e' id_ruolo verso una ruoli_* ) ma la chiave con cui l'applicazione chiama il
-- template, cioe' quello che il canone chiama codice char(32) UNIQUE. latenza_invio esce: aggiunta il 2021-12-10, non
-- l'ha mai letta nessun codice e non e' valorizzata su nessun database.
--
-- Cosa fa: toglie gli indici vecchi, rinomina ruolo in codice, toglie latenza_invio, allarga nome a char(255), mette le
-- colonne nell'ordine del canone e ricrea la UNIQUE codice e indice. La vista template_view sta nel file base.
--
-- Cosa NON fa: non tocca i dati. Il codice che legge la colonna ( _340.sms.php, _350.mail.php, le schede di
-- _TE000.template ) e' passato a codice nello stesso commit; _340 e _350 leggono anche ruolo finche' la patch non e'
-- su tutti i database.
--
-- IDEMPOTENTE: CHANGE COLUMN IF EXISTS non fa niente dove ruolo non c'e' piu', e il nome vecchio non viene riusato.

-- | 202611051200

-- template: via gli indici vecchi
ALTER TABLE `template`
	DROP INDEX IF EXISTS `unica`,
	DROP INDEX IF EXISTS `codice`,
	DROP INDEX IF EXISTS `indice`;

-- | 202611051201

-- template: ruolo diventa codice
ALTER TABLE `template`
	CHANGE COLUMN IF EXISTS `ruolo` `codice` char(32) DEFAULT NULL AFTER `id`;

-- | 202611051202

-- template: via latenza_invio, colonne nell'ordine del canone
ALTER TABLE `template`
	DROP COLUMN IF EXISTS `latenza_invio`,
	MODIFY `codice` char(32) DEFAULT NULL AFTER `id`,
	MODIFY `nome` char(255) DEFAULT NULL AFTER `codice`,
	MODIFY `tipo` char(32) DEFAULT NULL AFTER `nome`,
	MODIFY `note` text DEFAULT NULL AFTER `tipo`,
	MODIFY `se_mail` tinyint(1) DEFAULT NULL AFTER `note`,
	MODIFY `se_sms` tinyint(1) DEFAULT NULL AFTER `se_mail`;

-- | 202611051203

-- template: indici nella forma del canone
ALTER TABLE `template`
	ADD UNIQUE KEY `codice` (`codice`),
	ADD KEY `indice` (`id`,`codice`,`nome`,`tipo`,`se_mail`,`se_sms`);

-- | FINE
