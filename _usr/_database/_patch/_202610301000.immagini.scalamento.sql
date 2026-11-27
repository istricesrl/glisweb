-- 2026-10-30 — coda di scalamento delle immagini: sblocco, tentativi, file non scalabili, task nel modulo IM000
--
-- Ordine di WEB03 del 29/10/2026, approvato da Fabio. Il task di scalamento marca la riga con un token e lo toglie a
-- fine giro: un giro morto a metà lasciava la riga marcata e fuori dalla coda per sempre ( 59 righe su bernispa ), e
-- i file che il task non sa lavorare ( SVG, PDF ) restavano in coda e ci girava sopra a ogni giro.
--
-- 202610301000: le colonne per lo sblocco, come in mail_out: tentativi conta i giri abbandonati,
-- timestamp_elaborazione e' l'ora della marcatura. Il task sblocca le righe marcate da piu' di
-- $cf['image']['minuti_sblocco'] minuti, e quelle senza timestamp_elaborazione, marcate prima di questa patch.
--
-- 202610301001: marca col token di stato NON_SCALABILE le righe libere il cui percorso non e' un JPEG, un PNG o un
-- WebP, con lo stesso criterio di imageScalabile(); da qui in avanti lo fa il controller di immagini in scrittura.
--
-- 202610301002: la riga del task punta all'unica copia rimasta, quella del modulo _IM000.immagini: la copia del core
-- _src/_api/_task/_images.resize.php, tolta oggi, calcolava l'orientamento opposto uguale a quello dell'immagine. Le
-- iterazioni salgono a 20 con 2 secondi di pausa, come la coda mail; un valore piu' alto messo dal deploy resta.
--
-- IDEMPOTENTE: IF NOT EXISTS sulle colonne ( MariaDB 10.3 ), gli UPDATE non trovano piu' niente al secondo giro.

-- | 202610301000

ALTER TABLE `immagini`
	ADD COLUMN IF NOT EXISTS `tentativi` int(11) DEFAULT 0 AFTER `token`,
	ADD COLUMN IF NOT EXISTS `timestamp_elaborazione` int(11) DEFAULT NULL AFTER `tentativi`;

-- | 202610301001

UPDATE `immagini` SET `token` = 'NON_SCALABILE'
	WHERE `token` IS NULL
	AND ( `path` IS NULL OR lower( substring_index( `path`, '.', -1 ) ) NOT IN ( 'jpg', 'jpeg', 'png', 'webp' ) );

-- | 202610301002

UPDATE `task` SET
	`task` = '_mod/_IM000.immagini/_src/_api/_task/_images.resize.php',
	`iterazioni` = greatest( coalesce( `iterazioni`, 0 ), 20 ),
	`delay` = coalesce( `delay`, 2 )
	WHERE `task` = '_src/_api/_task/_images.resize.php';

-- | FINE
