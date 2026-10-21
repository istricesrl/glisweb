-- 2026-10-21 — indice su documenti_articoli.timestamp_aggiornamento
--
-- Il task _0500.mastri report.movimenti.magazzini.popolazione ( glisweb 0e80696ab ) cerca le righe da riscrivere
-- in __report_movimenti_magazzini__ dal marcatore in poi, con documenti_articoli.timestamp_aggiornamento >= ?:
-- con l'indice e' un range ( 0,0008 s su bernispa ), senza resta una scansione di tutta la tabella. Su bernispa
-- DEV l'indice c'e' solo perche' l'ha creato a mano BERNI il 21/10/2026, e una ricostruzione del database lo
-- perderebbe in silenzio: per questo, su ordine di Fabio, si anticipa con questa patch invece di aspettare il
-- punto 11 del canone ( la KEY entra in _030000999999.indexes.sql con lo stesso nome, concordato con GLISDEV ).
--
-- Il nome della chiave e' quello della colonna, come per le altre chiavi su un timestamp del canone.
--
-- NOTA l'indice su __report_movimenti_magazzini__.timestamp_aggiornamento, che servirebbe al max() del marcatore,
-- non sta qui: la tabella non e' nel canone e manca su quasi tutti i deploy, e l'ALTER fallirebbe fermando
-- mysqlPatchApply() al primo errore. Entra al punto 9 del canone, con gli altri __report_*.
--
-- IDEMPOTENTE: IF NOT EXISTS sulla chiave ( MariaDB 10.3 ), non fallisce dove l'indice c'e' gia'.

-- | 202610211200

ALTER TABLE `documenti_articoli` ADD KEY IF NOT EXISTS `timestamp_aggiornamento` (`timestamp_aggiornamento`);

-- | FINE
