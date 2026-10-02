-- 2026-10-02 — via gli indici che il canone non vuole
--
-- lingue: i file di base dichiaravano unici iso6391alpha2 e iso6393alpha3, ma i loro stessi dati hanno inglese
-- ( en-GB ) e americano ( en-US ) entrambi en / eng: su un database con i dati di base i due unici non si possono
-- creare. Decisione di Fabio del 02/10/2026: indici semplici col nome della colonna, che aggiunge
-- _202610021400.indici.canone.sql; a distinguere le lingue resta unica_ietf. Qui si tolgono i due unici vecchi.
--
-- consensi_contatti: id_consenso_id_contatto è un unico su ( id_consenso, id_contatto ) che nessun file di base ha
-- mai dichiarato, più stretto della chiave unica del canone, che comprende anche modulo. Decisione di Fabio del
-- 02/10/2026: si toglie. La chiave esterna su id_consenso resta servita dall'indice id_consenso del canone.
--
-- Va dopo _202610021400.indici.canone.sql, che crea gli indici sostitutivi. IDEMPOTENTE: DROP ... IF EXISTS.

-- | 202610021430

ALTER TABLE `lingue` DROP INDEX IF EXISTS `unica_iso6391alpha2`, DROP INDEX IF EXISTS `unica_iso6393alpha3`;

-- | 202610021431

ALTER TABLE `consensi_contatti` DROP INDEX IF EXISTS `id_consenso_id_contatto`;

-- | FINE
