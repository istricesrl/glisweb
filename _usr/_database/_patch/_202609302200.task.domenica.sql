-- 2026-09-30 — i task pianificati per la domenica con 0 partono di nuovo
--
-- COSA SI VEDEVA. task.giorno_della_settimana va da 1 ( lunedi' ) a 7 ( domenica ) perche' /_src/_api/_cron.php lo
-- confronta con date( 'N' ), ed e' lo stesso range della tendina del form dei task
-- ( _mod/_0030.strumenti/_src/_inc/_macro/_task.form.php ). Chi scriveva la riga a mano alla maniera di crontab
-- metteva 0 per la domenica, e quel task non partiva mai: date( 'N' ) non vale mai 0.
--
-- COSA FA. Porta a 7 le righe con giorno_della_settimana = 0: in crontab 0 e 7 sono tutti e due la domenica, quindi
-- la pianificazione voluta e' questa.
--
-- IDEMPOTENTE. Alla seconda esecuzione non trova righe con 0.

-- | 202609302200

-- la domenica e' 7
UPDATE `task` SET `giorno_della_settimana` = 7 WHERE `giorno_della_settimana` = 0;

-- | FINE FILE
