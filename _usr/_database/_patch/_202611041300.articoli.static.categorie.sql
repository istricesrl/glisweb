-- 2026-11-04 — articoli_view_static.categorie da char(255) a text
--
-- categorie nella vista e' l'elenco delle categorie dell'articolo, mediumtext, e con molte categorie supera i 255
-- caratteri: sul dev di utensilerialughese il ripopolamento della statica e' fallito con 1406 su 24 articoli
-- ( mysql.err 2026-11-04 12:00, 88 articoli oltre i 255, il piu' lungo 521 ). Stesso caso di nome il 2026-10-04
-- ( _202610041203 ): si allarga la colonna come in prodotti_view_static, poi si ripopolano le righe troncate.

-- | 202611041300

ALTER TABLE `articoli_view_static` MODIFY `categorie` text DEFAULT NULL;

-- | 202611041301

REPLACE INTO `articoli_view_static` ( `id_tipologia_pubblicazione`, `pubblicazione`, `tipologia_listino`, `id`, `codice`, `id_prodotto`, `prodotto`, `ordine`, `ean`, `isbn`, `id_reparto`, `id_taglia`, `id_colore`, `id_periodicita`, `periodicita`, `id_tipologia_rinnovo`, `tipologia_rinnovo`, `larghezza`, `lunghezza`, `altezza`, `id_udm_dimensioni`, `udm_dimensioni`, `peso`, `id_udm_peso`, `udm_peso`, `volume`, `id_udm_volume`, `udm_volume`, `capacita`, `id_udm_capacita`, `udm_capacita`, `durata`, `id_udm_durata`, `udm_durata`, `nome`, `id_categorie`, `categorie`, `prezzi`, `data_archiviazione`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`, `__label__` )
	SELECT `id_tipologia_pubblicazione`, `pubblicazione`, `tipologia_listino`, `id`, `codice`, `id_prodotto`, `prodotto`, `ordine`, `ean`, `isbn`, `id_reparto`, `id_taglia`, `id_colore`, `id_periodicita`, `periodicita`, `id_tipologia_rinnovo`, `tipologia_rinnovo`, `larghezza`, `lunghezza`, `altezza`, `id_udm_dimensioni`, `udm_dimensioni`, `peso`, `id_udm_peso`, `udm_peso`, `volume`, `id_udm_volume`, `udm_volume`, `capacita`, `id_udm_capacita`, `udm_capacita`, `durata`, `id_udm_durata`, `udm_durata`, `nome`, `id_categorie`, `categorie`, `prezzi`, `data_archiviazione`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`, `__label__` FROM `articoli_view` WHERE char_length( `categorie` ) > 255;

-- | FINE
