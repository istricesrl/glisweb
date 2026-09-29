-- 2026-09-30 — l'ora della marcatura nelle code di mail e SMS
--
-- Contesto: i task di invio ( _src/_api/_task/_mail.queue.send.php, _sms.queue.send.php e le loro copie
-- nei moduli MA000.mail e SM000.sms ) marcano con il proprio token la riga che stanno inviando e lo
-- tolgono alla fine del giro. Se il processo muore a meta' la riga resta marcata, e nessuna modalita'
-- di evasione la prende piu': restava bloccata per sempre. Da oggi il task scrive l'ora della
-- marcatura in timestamp_elaborazione, nello stesso UPDATE che mette il token, e all'inizio di ogni
-- giro toglie il token alle righe marcate da piu' di $cf['mail']['minuti_sblocco'] ( o
-- $cf['sms']['minuti_sblocco'] ) minuti, come _src/_api/_cron.php fa su task, job e pianificazioni con
-- timestamp_esecuzione e timestamp_elaborazione. Restano fuori le righe col token COPIA_FALLITA, che il
-- task lascia apposta quando la copia fra le inviate fallisce dopo un invio riuscito.
--
-- COSA FA. Aggiunge timestamp_elaborazione subito dopo token alle quattro tabelle mail_out, mail_sent,
-- sms_out e sms_sent: le tabelle delle inviate la devono avere nella stessa posizione, perche' i task
-- spostano le righe con REPLACE INTO ... SELECT * e INSERT INTO ... SELECT *, che vogliono le stesse
-- colonne nello stesso ordine. I file di base sono stati aggiornati nello stesso giro. Le righe gia'
-- marcate prima di oggi restano senza ora di marcatura, e quindi lo sblocco non le tocca: fra loro ci possono
-- essere righe bloccate apposta dal task del 29/09/2026 dopo una copia fallita, cioe' mail o SMS gia' partiti,
-- che non si distinguono dalle righe di un giro morto e sbloccate verrebbero spediti una seconda volta. La
-- patch le conta e lo dice; vanno guardate a mano ( nel log mail o sms una riga LOG_CRIT dice quali sono state
-- inviate e non copiate ), togliendo il token a quelle da rispedire.
--
-- GUARDIE. Ogni passo sta in un PREPARE guardato da information_schema, come in
-- _202609291500.chiavi.primarie.sql: la colonna si aggiunge solo se la tabella esiste e ha la colonna
-- token, le righe si datano solo se la colonna c'e'; altrimenti il passo non fa niente e lo dice con
-- un SELECT. ADD COLUMN IF NOT EXISTS e' di MariaDB, come in _202609151300.documenti.articoli.colonne.sql,
-- e rende la patch rieseguibile.

-- | 202609301600

-- mail_out, la colonna
SET @code = IF(
    EXISTS (
        SELECT 1 FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'mail_out' AND COLUMN_NAME = 'token'
    ),
    "ALTER TABLE `mail_out` ADD COLUMN IF NOT EXISTS `timestamp_elaborazione` int(11) DEFAULT NULL AFTER `token`",
    "SELECT 'mail_out non esiste o non ha la colonna token: niente da fare' AS nota"
);

-- | 202609301601

PREPARE code FROM @code;

-- | 202609301602

EXECUTE code;

-- | 202609301603

DEALLOCATE PREPARE code;

-- | 202609301604

-- mail_sent, la colonna
SET @code = IF(
    EXISTS (
        SELECT 1 FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'mail_sent' AND COLUMN_NAME = 'token'
    ),
    "ALTER TABLE `mail_sent` ADD COLUMN IF NOT EXISTS `timestamp_elaborazione` int(11) DEFAULT NULL AFTER `token`",
    "SELECT 'mail_sent non esiste o non ha la colonna token: niente da fare' AS nota"
);

-- | 202609301605

PREPARE code FROM @code;

-- | 202609301606

EXECUTE code;

-- | 202609301607

DEALLOCATE PREPARE code;

-- | 202609301608

-- sms_out, la colonna
SET @code = IF(
    EXISTS (
        SELECT 1 FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'sms_out' AND COLUMN_NAME = 'token'
    ),
    "ALTER TABLE `sms_out` ADD COLUMN IF NOT EXISTS `timestamp_elaborazione` int(11) DEFAULT NULL AFTER `token`",
    "SELECT 'sms_out non esiste o non ha la colonna token: niente da fare' AS nota"
);

-- | 202609301609

PREPARE code FROM @code;

-- | 202609301610

EXECUTE code;

-- | 202609301611

DEALLOCATE PREPARE code;

-- | 202609301612

-- sms_sent, la colonna
SET @code = IF(
    EXISTS (
        SELECT 1 FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'sms_sent' AND COLUMN_NAME = 'token'
    ),
    "ALTER TABLE `sms_sent` ADD COLUMN IF NOT EXISTS `timestamp_elaborazione` int(11) DEFAULT NULL AFTER `token`",
    "SELECT 'sms_sent non esiste o non ha la colonna token: niente da fare' AS nota"
);

-- | 202609301613

PREPARE code FROM @code;

-- | 202609301614

EXECUTE code;

-- | 202609301615

DEALLOCATE PREPARE code;

-- | 202609301616

-- mail_out, le righe gia' marcate: si contano, non si sbloccano
SET @code = IF(
    EXISTS (
        SELECT 1 FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'mail_out' AND COLUMN_NAME = 'timestamp_elaborazione'
    ),
    "SELECT count(*) AS righe_bloccate_da_controllare FROM `mail_out` WHERE `token` IS NOT NULL AND `timestamp_elaborazione` IS NULL",
    "SELECT 'mail_out non ha la colonna timestamp_elaborazione: niente da fare' AS nota"
);

-- | 202609301617

PREPARE code FROM @code;

-- | 202609301618

EXECUTE code;

-- | 202609301619

DEALLOCATE PREPARE code;

-- | 202609301620

-- sms_out, le righe gia' marcate: si contano, non si sbloccano
SET @code = IF(
    EXISTS (
        SELECT 1 FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'sms_out' AND COLUMN_NAME = 'timestamp_elaborazione'
    ),
    "SELECT count(*) AS righe_bloccate_da_controllare FROM `sms_out` WHERE `token` IS NOT NULL AND `timestamp_elaborazione` IS NULL",
    "SELECT 'sms_out non ha la colonna timestamp_elaborazione: niente da fare' AS nota"
);

-- | 202609301621

PREPARE code FROM @code;

-- | 202609301622

EXECUTE code;

-- | 202609301623

DEALLOCATE PREPARE code;

-- | FINE FILE
