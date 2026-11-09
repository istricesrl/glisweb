-- 2026-11-09 — tipologie_mail_status: codici del framework, nomi unici, via se_sistema dalla vista, indici del modello
--
-- Schema canonico, punto 6, riga 211, decisione di Fabio del 09/11/2026 ( opzione A ): la tabella resta una scala piatta
-- ( niente id_genitore né icone, è una scala chiusa e non un albero ) e per il resto segue il modello delle tipologie_*.
-- È una tabella standard: le nove righe hanno gli stessi id su tutti i database misurati ( 11, identici ), e gli id sono
-- quelli del gestionale di mailing di gimbe ( MC_mail_status_tipo ), quindi non si toccano.
--
-- Cosa fa:
-- - porta codice al formato del framework ( maiuscolo con trattino basso: RATING_A_PLUS, MAILCHIMP_CLEANED... ) e dà un
--   nome alle due righe che avevano '-' ( 10, 20 ), riconoscendo le righe per id;
-- - riscrive le note in italiano;
-- - allarga nome a char(255);
-- - sposta la UNIQUE da codice ( unica ) a nome ( unica ), mette la UNIQUE codice e la KEY ordine, ricrea indice;
-- - ricrea la vista senza se_sistema e con note.
--
-- Cosa NON fa, e perché: non toglie se_sistema ( 1 su ogni riga, nessun lettore ) né la coda di audit, che escono dal
-- canone ma restano sui database fino al punto 12. Gli id non cambiano: l'unico lettore del codice era un test di gimbe
-- ( stampeExportContattiRegioneXlsxCest ), avvisato prima di questa patch; la libreria Emailable legge per id e continua
-- a funzionare.
--
-- IDEMPOTENTE: gli UPDATE riscrivono sempre gli stessi valori, le chiavi si tolgono con IF EXISTS e si ricreano, la
-- vista è CREATE OR REPLACE.

-- | 202611091600

-- tipologie_mail_status: codici, nomi e note per id
UPDATE `tipologie_mail_status` SET `codice` = 'RATING_A_PLUS', `nome` = 'Deliverable +', `note` = 'Rating A+: indirizzo recapitabile e con una storia di aperture o clic; si può sempre spedire.' WHERE `id` = 1;
UPDATE `tipologie_mail_status` SET `codice` = 'RATING_A', `nome` = 'Deliverable', `note` = 'Rating A: indirizzo recapitabile; si può sempre spedire.' WHERE `id` = 2;
UPDATE `tipologie_mail_status` SET `codice` = 'RATING_B', `nome` = 'Accepts All', `note` = 'Rating B: il server accetta qualunque indirizzo e può rimbalzare la mail dopo averla accettata; va segmentato finché non è confermato valido.' WHERE `id` = 3;
UPDATE `tipologie_mail_status` SET `codice` = 'RATING_D', `nome` = 'Indeterminate', `note` = 'Rating D: la verifica non ha potuto concludere; va segmentato.' WHERE `id` = 4;
UPDATE `tipologie_mail_status` SET `codice` = 'RATING_F', `nome` = 'Undeliverable', `note` = 'Rating F: indirizzo non recapitabile o non valido; non si spedisce.' WHERE `id` = 5;
UPDATE `tipologie_mail_status` SET `codice` = 'MAILCHIMP_CLEANED', `nome` = 'Puliti da MailChimp / Hard Bounce', `note` = 'indirizzo tolto da MailChimp dopo un rimbalzo permanente; non si spedisce.' WHERE `id` = 8;
UPDATE `tipologie_mail_status` SET `codice` = 'MAILCHIMP_BLACKLISTED', `nome` = 'Cancellati su MChimp / Blacklisted', `note` = 'indirizzo cancellato su MailChimp o in lista nera; non si spedisce.' WHERE `id` = 9;
UPDATE `tipologie_mail_status` SET `codice` = 'NON_IMPORTABILE', `nome` = 'Non importabile', `note` = 'stato del gestionale di mailing di gimbe ( MC_mail_status_tipo ), senza descrizione nel gestionale; non si spedisce.' WHERE `id` = 10;
UPDATE `tipologie_mail_status` SET `codice` = 'OK', `nome` = 'OK', `note` = 'stato del gestionale di mailing di gimbe ( MC_mail_status_tipo ), senza descrizione nel gestionale; si può spedire.' WHERE `id` = 20;

-- | 202611091601

-- tipologie_mail_status: nome a char(255), chiavi del modello
ALTER TABLE `tipologie_mail_status`
	MODIFY `nome` char(255) DEFAULT NULL,
	DROP INDEX IF EXISTS `unica`,
	DROP INDEX IF EXISTS `codice`,
	DROP INDEX IF EXISTS `ordine`,
	DROP INDEX IF EXISTS `indice`;

-- | 202611091602

-- tipologie_mail_status: chiavi ricreate
ALTER TABLE `tipologie_mail_status`
	ADD UNIQUE KEY `unica` (`nome`),
	ADD UNIQUE KEY `codice` (`codice`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `indice` (`id`,`ordine`,`codice`,`nome`,`se_recapitabile`);

-- | 202611091603

-- tipologie_mail_status_view
CREATE OR REPLACE VIEW `tipologie_mail_status_view` AS
	SELECT
		tipologie_mail_status.id,
		tipologie_mail_status.ordine,
		tipologie_mail_status.codice,
		tipologie_mail_status.nome,
		tipologie_mail_status.note,
		tipologie_mail_status.se_recapitabile,
		tipologie_mail_status.nome AS __label__
	FROM tipologie_mail_status
;
