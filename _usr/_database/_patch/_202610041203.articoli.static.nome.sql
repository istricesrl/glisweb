-- 2026-10-04 — articoli_view_static.nome da char(128) a varchar(512)
--
-- nome nella vista e' prodotto + articolo e supera i 128 caratteri: su polmasi prod il ripopolamento della
-- statica ( _202610041200, blocco 1202 ) e' fallito con 1406 su 8 articoli. Si allarga la colonna e si ripopola.

-- | 202610041203

ALTER TABLE `articoli_view_static` MODIFY `nome` varchar(512) DEFAULT NULL;

-- | 202610041204

REPLACE INTO `articoli_view_static` ( `id_tipologia_pubblicazione`, `pubblicazione`, `tipologia_listino`, `id`, `codice`, `id_prodotto`, `prodotto`, `ordine`, `ean`, `isbn`, `id_reparto`, `id_taglia`, `id_colore`, `id_periodicita`, `periodicita`, `id_tipologia_rinnovo`, `tipologia_rinnovo`, `larghezza`, `lunghezza`, `altezza`, `id_udm_dimensioni`, `udm_dimensioni`, `peso`, `id_udm_peso`, `udm_peso`, `volume`, `id_udm_volume`, `udm_volume`, `capacita`, `id_udm_capacita`, `udm_capacita`, `durata`, `id_udm_durata`, `udm_durata`, `nome`, `id_categorie`, `categorie`, `prezzi`, `data_archiviazione`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`, `__label__` )
	SELECT `id_tipologia_pubblicazione`, `pubblicazione`, `tipologia_listino`, `id`, `codice`, `id_prodotto`, `prodotto`, `ordine`, `ean`, `isbn`, `id_reparto`, `id_taglia`, `id_colore`, `id_periodicita`, `periodicita`, `id_tipologia_rinnovo`, `tipologia_rinnovo`, `larghezza`, `lunghezza`, `altezza`, `id_udm_dimensioni`, `udm_dimensioni`, `peso`, `id_udm_peso`, `udm_peso`, `volume`, `id_udm_volume`, `udm_volume`, `capacita`, `id_udm_capacita`, `udm_capacita`, `durata`, `id_udm_durata`, `udm_durata`, `nome`, `id_categorie`, `categorie`, `prezzi`, `data_archiviazione`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`, `__label__` FROM `articoli_view`;

-- | FINE
