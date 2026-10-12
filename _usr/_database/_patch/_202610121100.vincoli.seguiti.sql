-- 2026-10-12 — vincoli riportati a "seguiti" dopo il canone del 02/10
--
-- Il canone dei vincoli ( glisweb 018c9d827, 02/10/2026 ) ha rinominato in _nofollow anche vincoli che i form usano
-- per caricare le sottorighe: controller() ( _src/_lib/_controller.tools.php ) in GET legge da information_schema le
-- tabelle figlie escludendo i vincoli che finiscono in _nofollow, quindi la sottotabella del form arriva vuota senza
-- nessun errore. Criterio di Fabio del 06/10/2026: _nofollow non e' una regola generale, un vincolo resta seguito se
-- un modulo carica le sottorighe di quella tabella dal form della tabella padre.
--
-- Verificati i 29 vincoli seguiti prima del canone e _nofollow dopo: solo due hanno un form che ne carica le sottorighe
--   mastri_articoli_ibfk_02           articoli.form.logistica ( sub.mastri, collocazioni dell'articolo )
--   mastri_tipologie_veicoli_ibfk_01  magazzini.form.veicoli ( sub.tipologie_veicoli, form sulla tabella mastri )
-- Gli altri restano _nofollow: le autoreferenze id_genitore farebbero scendere controller() lungo l'albero, e
-- relazioni_articoli_ibfk_02 ( id_articolo_collegato ) mischierebbe le relazioni inverse in quelle dell'articolo.
--
-- Dopo l'esecuzione va svuotata la cache della query dei vincoli di controller() ( /task/memcache.clean ).
--
-- Nata su bernispa il 09/10 come _202610091200, promossa il 12/10 con un id nuovo: 202610091200 era gia' stato
-- registrato in __patch__ dalla patch documenti_articoli, e mysqlPatchRead() applica solo gli id maggiori del livello.
--
-- Un ALTER per marcatore: mysqlPatchRead() passa il blocco fra due marcatori come una query sola, e con i quattro ALTER
-- sotto lo stesso marcatore su MySQL la traduzione si fermava ( clausola non tradotta ) e su MariaDB mysqli_query()
-- li rifiutava insieme.
--
-- IDEMPOTENTE.

-- | 202610121100

ALTER TABLE `mastri_articoli` DROP FOREIGN KEY IF EXISTS `mastri_articoli_ibfk_02_nofollow`;

-- | 202610121101

ALTER TABLE `mastri_articoli` ADD CONSTRAINT `mastri_articoli_ibfk_02` FOREIGN KEY IF NOT EXISTS (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202610121102

ALTER TABLE `mastri_tipologie_veicoli` DROP FOREIGN KEY IF EXISTS `mastri_tipologie_veicoli_ibfk_01_nofollow`;

-- | 202610121103

ALTER TABLE `mastri_tipologie_veicoli` ADD CONSTRAINT `mastri_tipologie_veicoli_ibfk_01` FOREIGN KEY IF NOT EXISTS (`id_mastro`) REFERENCES `mastri` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | FINE
