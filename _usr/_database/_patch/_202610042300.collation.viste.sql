-- 2026-10-04 — viste e __patch__ in utf8_general_ci
--
-- Decisione di Fabio del 04/10/2026: il canone e' tutto utf8_general_ci, anche le colonne delle viste. Una vista prende
-- charset e collation della sessione che la crea per le colonne fatte solo di letterali, numeri o funzioni su date
-- ( i __label__ con concat_ws, i group_concat di id, le date formattate ): il framework si connette in utf8mb4
-- ( _src/_config/_125.mysql.php ), quindi le viste create dal task delle patch avevano quelle colonne in
-- utf8mb4_general_ci. Il censimento del 04/10/2026 sui deploy di web03 ne ha trovate 51, 17 delle quali in viste del
-- canone: sono le viste che questa patch ricrea, copiate da _090000999999.views.sql e _100000999999.reports.sql.
--
-- Da questa patch mysqlPatchApply() esegue le patch con SET NAMES utf8 COLLATE utf8_general_ci e poi rimette la
-- connessione com'era, quindi le viste future nascono gia' nel canone; il primo blocco lo fa anche qui, per gli
-- applicatori che non lo fanno ancora. coupon_view.id_aree era latin1_swedish_ci anche cosi' ( group_concat di soli
-- numeri, senza letterali ): nel canone adesso ha un convert() esplicito.
--
-- __patch__.patch era utf8_unicode_ci: la creavano cosi' mysqlPatchApply() e patch-db.py, ora utf8_general_ci.
--
-- IDEMPOTENTE.

-- | 202610042300

SET NAMES utf8 COLLATE utf8_general_ci;

-- | 202610042301

ALTER TABLE `__patch__` CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;

-- | 202610042302

-- vuota dal 26/10/2026: ricreava una vista copiandola dal base, e la copia restava indietro quando il canone andava
-- avanti; le viste vivono solo nei file base e ai deploy arrivano con le migrazioni del canone ( 300.database.md )

-- | 202610042303

-- vuota dal 26/10/2026: ricreava una vista copiandola dal base, e la copia restava indietro quando il canone andava
-- avanti; le viste vivono solo nei file base e ai deploy arrivano con le migrazioni del canone ( 300.database.md )

-- | 202610042304

-- vuota dal 26/10/2026: ricreava una vista copiandola dal base, e la copia restava indietro quando il canone andava
-- avanti; le viste vivono solo nei file base e ai deploy arrivano con le migrazioni del canone ( 300.database.md )

-- | 202610042305

-- vuota dal 26/10/2026: ricreava una vista copiandola dal base, e la copia restava indietro quando il canone andava
-- avanti; le viste vivono solo nei file base e ai deploy arrivano con le migrazioni del canone ( 300.database.md )

-- | 202610042306

-- vuota dal 26/10/2026: ricreava una vista copiandola dal base, e la copia restava indietro quando il canone andava
-- avanti; le viste vivono solo nei file base e ai deploy arrivano con le migrazioni del canone ( 300.database.md )

-- | 202610042307

-- vuota dal 26/10/2026: ricreava una vista copiandola dal base, e la copia restava indietro quando il canone andava
-- avanti; le viste vivono solo nei file base e ai deploy arrivano con le migrazioni del canone ( 300.database.md )

-- | 202610042308

-- vuota dal 26/10/2026: ricreava una vista copiandola dal base, e la copia restava indietro quando il canone andava
-- avanti; le viste vivono solo nei file base e ai deploy arrivano con le migrazioni del canone ( 300.database.md )

-- | 202610042309

-- vuota dal 26/10/2026: ricreava una vista copiandola dal base, e la copia restava indietro quando il canone andava
-- avanti; le viste vivono solo nei file base e ai deploy arrivano con le migrazioni del canone ( 300.database.md )

-- | 202610042310

-- vuota dal 26/10/2026: ricreava una vista copiandola dal base, e la copia restava indietro quando il canone andava
-- avanti; le viste vivono solo nei file base e ai deploy arrivano con le migrazioni del canone ( 300.database.md )

-- | 202610042311

-- vuota dal 26/10/2026: ricreava una vista copiandola dal base, e la copia restava indietro quando il canone andava
-- avanti; le viste vivono solo nei file base e ai deploy arrivano con le migrazioni del canone ( 300.database.md )

-- | 202610042312

-- vuota dal 26/10/2026: ricreava una vista copiandola dal base, e la copia restava indietro quando il canone andava
-- avanti; le viste vivono solo nei file base e ai deploy arrivano con le migrazioni del canone ( 300.database.md )

-- | 202610042313

-- vuota dal 26/10/2026: ricreava una vista copiandola dal base, e la copia restava indietro quando il canone andava
-- avanti; le viste vivono solo nei file base e ai deploy arrivano con le migrazioni del canone ( 300.database.md )

-- | 202610042314

-- vuota dal 26/10/2026: ricreava una vista copiandola dal base, e la copia restava indietro quando il canone andava
-- avanti; le viste vivono solo nei file base e ai deploy arrivano con le migrazioni del canone ( 300.database.md )

-- | 202610042315

-- vuota dal 26/10/2026: ricreava una vista copiandola dal base, e la copia restava indietro quando il canone andava
-- avanti; le viste vivono solo nei file base e ai deploy arrivano con le migrazioni del canone ( 300.database.md )

-- | 202610042316

-- vuota dal 26/10/2026: ricreava una vista copiandola dal base, e la copia restava indietro quando il canone andava
-- avanti; le viste vivono solo nei file base e ai deploy arrivano con le migrazioni del canone ( 300.database.md )

-- | 202610042317

-- vuota dal 26/10/2026: ricreava una vista copiandola dal base, e la copia restava indietro quando il canone andava
-- avanti; le viste vivono solo nei file base e ai deploy arrivano con le migrazioni del canone ( 300.database.md )

-- | FINE
