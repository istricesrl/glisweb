-- 2026-09-29 — tornano le tabelle sms_out e sms_sent, gemelle di mail_out e mail_sent
--
-- Contesto: le due tabelle della coda degli SMS stavano nei file di base fino al riallineamento del
-- 02/03/2026 ( commit d975b4a15, "riallineamento da Gimbe e Glisdev" ), che le ha perse per strada
-- insieme agli indici, alle chiavi esterne e alle viste sms_out_view e sms_sent_view, come e' successo
-- ad audio e pianificazioni ( _202609251000, _202609251400 ). Il resto del framework ha continuato a
-- usarle: queueSms() in _src/_lib/_sms.tools.php scrive in sms_out, il task
-- _src/_api/_task/_sms.queue.send.php ( e la sua copia nel modulo SM000.sms ) le sposta in sms_sent,
-- le viste del modulo SM000.sms le elencano e i diritti di _src/_config/_250.auth.php le nominano.
-- Su un database installato dopo marzo tutte queste cose falliscono sulla prima query.
--
-- COME SONO FATTE. Le definizioni vengono dalla versione precedente a d975b4a15, portate alla forma
-- che mail_out e mail_sent hanno oggi: bigint( 20 ) invece di int( 11 ) per gli id, la sola chiave
-- primaria piu' le chiavi sulle colonne di collegamento come indici, data_ora_invio e l'etichetta
-- id / testo nelle viste. Le due tabelle hanno le stesse colonne nello stesso ordine, perche' il task
-- di invio le sposta con REPLACE INTO sms_sent SELECT * FROM sms_out: una colonna aggiunta a una sola
-- delle due fa fallire lo spostamento. I file di base sono stati aggiornati nello stesso giro, con i
-- numeri di blocco che le due tabelle avevano prima ( 041000 e 041200 ).
--
-- IDEMPOTENZA. Un deploy installato prima di marzo le tabelle le ha ancora, nella forma vecchia: le
-- CREATE non fanno niente e le viste si ricreano sulle stesse colonne.
--
-- COSA NON C'E' QUI, di proposito: le chiavi esterne. Le tabelle gemelle delle mail non ne hanno, e
-- quelle vecchie degli SMS ( sms_out_ibfk_01_nofollow verso telefoni con ON DELETE CASCADE, e le
-- due verso account ) non sono tornate nemmeno nei file di base: cancellare un telefono non deve
-- cancellare lo storico degli SMS inviati. Dove la tabella vecchia c'e' ancora, i vincoli restano.
--
-- PORTABILITA'. Chiave primaria, AUTO_INCREMENT e indici sono dichiarati INLINE nelle CREATE, per il
-- motivo spiegato in _202609231600.mail.status.sql.

-- | 202609291000

-- sms_out
CREATE TABLE IF NOT EXISTS `sms_out` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_telefono` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `timestamp_composizione` int(11) DEFAULT NULL,
  `mittente` char(254) DEFAULT NULL,
  `destinatari` text DEFAULT NULL,
  `corpo` text DEFAULT NULL,
  `server` char(128) DEFAULT NULL,
  `host` char(254) DEFAULT NULL,
  `port` char(6) DEFAULT NULL,
  `user` char(254) DEFAULT NULL,
  `password` char(254) DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
  `tentativi` int(11) DEFAULT 0,
  `timestamp_invio` int(11) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_telefono` (`id_telefono`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291001

-- sms_sent
CREATE TABLE IF NOT EXISTS `sms_sent` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_telefono` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `timestamp_composizione` int(11) DEFAULT NULL,
  `mittente` char(254) DEFAULT NULL,
  `destinatari` text DEFAULT NULL,
  `corpo` text DEFAULT NULL,
  `server` char(128) DEFAULT NULL,
  `host` char(254) DEFAULT NULL,
  `port` char(6) DEFAULT NULL,
  `user` char(254) DEFAULT NULL,
  `password` char(254) DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
  `tentativi` int(11) DEFAULT 0,
  `timestamp_invio` int(11) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_telefono` (`id_telefono`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291010

-- sms_out_view
CREATE OR REPLACE VIEW `sms_out_view` AS
	SELECT
		sms_out.id,
		sms_out.id_telefono,
		sms_out.ordine,
		sms_out.timestamp_composizione,
		sms_out.mittente,
		sms_out.destinatari,
		sms_out.corpo,
		sms_out.server,
		sms_out.host,
		sms_out.port,
		sms_out.user,
		sms_out.password,
		sms_out.token,
		sms_out.tentativi,
		sms_out.timestamp_invio,
		from_unixtime( sms_out.timestamp_invio, '%Y-%m-%d' ) AS data_ora_invio,
		sms_out.id_account_inserimento,
		sms_out.id_account_aggiornamento,
		concat(
			sms_out.id,
			' / ',
			sms_out.corpo
		) AS __label__
	FROM sms_out
;

-- | 202609291011

-- sms_sent_view
CREATE OR REPLACE VIEW `sms_sent_view` AS
	SELECT
		sms_sent.id,
		sms_sent.id_telefono,
		sms_sent.ordine,
		sms_sent.timestamp_composizione,
		sms_sent.mittente,
		sms_sent.destinatari,
		sms_sent.corpo,
		sms_sent.server,
		sms_sent.host,
		sms_sent.port,
		sms_sent.user,
		sms_sent.password,
		sms_sent.token,
		sms_sent.tentativi,
		sms_sent.timestamp_invio,
		from_unixtime( sms_sent.timestamp_invio, '%Y-%m-%d' ) AS data_ora_invio,
		sms_sent.id_account_inserimento,
		sms_sent.id_account_aggiornamento,
		concat(
			sms_sent.id,
			' / ',
			sms_sent.corpo
		) AS __label__
	FROM sms_sent
;

-- | FINE FILE
