-- 2026-11-04 — recupero del canone, fase 2: indici, UNIQUE, vincoli e dati delle colonne rinominate
--
-- Seguito di _202611042000.recupero.canone.sql, che ai database creati prima del 04/10/2026 ha portato tabelle,
-- colonne e gli indici e i vincoli delle colonne nuove, ma con IF NOT EXISTS sul nome: dove il nome c'era gia' con
-- la definizione vecchia e' rimasta la vecchia. Sui DB vecchi i UNIQUE sono quelli di prima del canone e il codice
-- quello di dopo: un UNIQUE piu' stretto rifiuta inserimenti validi ( articoli_caratteristiche.unica senza la
-- lingua da' Duplicate entry alla seconda lingua ), e una colonna rinominata e' arrivata vuota accanto alla vecchia.
-- Decisa da Fabio il 04/11/2026 sera ( piano-punto-3.md ); fasi 1-2 di GLISDEV ( rinomine.md e
-- indici-classificati.md in var/20261104-colonne-canone/ del deploy glisdev ), fasi 3-4 di GLISWEB ( misura dei
-- doppioni e generatore genera-fase2.py in var/20261104-colonne-canone-fase3/ del deploy glisweb ).
--
-- Cosa fa:
-- - copia i dati delle 9 rinomine, delle 4 trasformazioni ( se_presente -> se_assente col valore NEGATO,
--   iva.timestamp_archiviazione -> data_archiviazione ) e di 2 travasi ( banner.id_sito sulle sue pubblicazioni,
--   documenti.id_immobile sulle righe ), solo dove la colonna nuova e' NULL. Con la procedura che prova e annota
--   ( il modello e' la 202609300900 ): sui DB creati dopo il 04/10 le colonne vecchie non ci sono, e l'UPDATE che
--   fallisce lo dice nella nota invece di fermare la coda. Le colonne vecchie NON si cancellano: decisione di Fabio,
--   dopo il rilascio, con un dump, in una patch a parte;
-- - con la stessa procedura porta metadati.id_asset a bigint: su crmtrb e' int( 11 ), e il vincolo verso asset non
--   si creerebbe ( errno 150 );
-- - per tabella, tre ALTER: via i vincoli che cambiano ( col nome della base e coi nomi che lo stesso vincolo ha sui
--   deploy misurati: la numerazione <tabella>_ibfk_N diverge ), poi gli indici, poi i vincoli nella forma del
--   canone. Gli indici sono DROP INDEX IF EXISTS e ADD senza IF NOT EXISTS nello stesso ALTER: un ADD ... IF NOT
--   EXISTS vedrebbe il nome vecchio ancora presente e salterebbe, lasciando l'indice tolto. Rilanciata da' lo stesso
--   stato, e sui DB gia' al canone rifa' gli stessi indici. Prima i DROP e poi gli ADD nello stesso ALTER regge
--   anche file, immagini e pianificazioni, vicine al limite di 64 indici di InnoDB.
--
-- Cosa NON fa ( fase 6 del piano, per deploy, con chi conosce i dati ):
-- - i UNIQUE con doppioni e i vincoli con righe orfane su almeno un DB misurato il 04/11 ( utensilerialughese,
--   gimbe dev, polmasi PROD e dev, bernispa dev, glisdev, glisweb ): prezzi.unica_articolo e unica_prodotto,
--   indirizzi_ibfk_02_nofollow ( id_comune ), documenti_articoli_ibfk_02_nofollow ( id_tipologia ). Un ADD che
--   fallisce fermerebbe la coda delle patch;
-- - il travaso di organizzazioni.id_ruolo in anagrafica_organizzazioni: id_anagrafica del nodo ha cambiato
--   significato, e su nessun DB misurato c'e' una riga di organizzazioni da guardare;
-- - banner_zone.se_presente: nessuna riga a 0 sui DB misurati, la colonna esce senza dati da salvare.
--
-- Dopo l'esecuzione va svuotata la cache della query dei vincoli di controller() ( /task/memcache.clean ).
--
-- IDEMPOTENTE.

-- | 202611042330

-- la procedura che prova un'istruzione e, se fallisce, lo annota invece di fermare la coda
CREATE OR REPLACE PROCEDURE `__patch_recupero_canone_indici__`( IN istruzione LONGTEXT, IN oggetto VARCHAR(64) )
BEGIN

    DECLARE messaggio TEXT DEFAULT NULL;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1 messaggio = MESSAGE_TEXT;
        END;

    SET @recupero_canone_indici_sql = istruzione;
    PREPARE prova FROM @recupero_canone_indici_sql;
    IF messaggio IS NULL THEN
        EXECUTE prova;
        DEALLOCATE PREPARE prova;
    END IF;

    IF messaggio IS NOT NULL THEN
        SET @recupero_canone_indici_note = CONCAT_WS( '\n', @recupero_canone_indici_note, CONCAT( oggetto, ': ', messaggio ) );
    END IF;

END;

-- | 202611042331

-- banner.altezza
CALL `__patch_recupero_canone_indici__`( 'UPDATE `banner` SET `altezza` = `altezza_modulo` WHERE `altezza` IS NULL', 'banner.altezza' );

-- | 202611042332

-- banner.larghezza
CALL `__patch_recupero_canone_indici__`( 'UPDATE `banner` SET `larghezza` = `larghezza_modulo` WHERE `larghezza` IS NULL', 'banner.larghezza' );

-- | 202611042333

-- classi_energetiche.hex
CALL `__patch_recupero_canone_indici__`( 'UPDATE `classi_energetiche` SET `hex` = `rgb` WHERE `hex` IS NULL', 'classi_energetiche.hex' );

-- | 202611042334

-- consensi_contatti.se_prestato
CALL `__patch_recupero_canone_indici__`( 'UPDATE `consensi_contatti` SET `se_prestato` = `valore` WHERE `se_prestato` IS NULL', 'consensi_contatti.se_prestato' );

-- | 202611042335

-- corrispondenza.id_distinta_spedizione
CALL `__patch_recupero_canone_indici__`( 'UPDATE `corrispondenza` SET `id_distinta_spedizione` = `id_distinta` WHERE `id_distinta_spedizione` IS NULL', 'corrispondenza.id_distinta_spedizione' );

-- | 202611042336

-- modalita_pagamento.codice_sdi
CALL `__patch_recupero_canone_indici__`( 'UPDATE `modalita_pagamento` SET `codice_sdi` = `codice` WHERE `codice_sdi` IS NULL', 'modalita_pagamento.codice_sdi' );

-- | 202611042337

-- progetti.uscite_previste
CALL `__patch_recupero_canone_indici__`( 'UPDATE `progetti` SET `uscite_previste` = `costi_previsti` WHERE `uscite_previste` IS NULL', 'progetti.uscite_previste' );

-- | 202611042338

-- regimi.codice_sdi
CALL `__patch_recupero_canone_indici__`( 'UPDATE `regimi` SET `codice_sdi` = `codice` WHERE `codice_sdi` IS NULL', 'regimi.codice_sdi' );

-- | 202611042339

-- ritenute.codice_sdi
CALL `__patch_recupero_canone_indici__`( 'UPDATE `ritenute` SET `codice_sdi` = `codice` WHERE `codice_sdi` IS NULL', 'ritenute.codice_sdi' );

-- | 202611042340

-- edifici_caratteristiche.se_assente
CALL `__patch_recupero_canone_indici__`( 'UPDATE `edifici_caratteristiche` SET `se_assente` = IF( `se_presente` = 1, NULL, 1 ) WHERE `se_assente` IS NULL', 'edifici_caratteristiche.se_assente' );

-- | 202611042341

-- immobili_caratteristiche.se_assente
CALL `__patch_recupero_canone_indici__`( 'UPDATE `immobili_caratteristiche` SET `se_assente` = IF( `se_presente` = 1, NULL, 1 ) WHERE `se_assente` IS NULL', 'immobili_caratteristiche.se_assente' );

-- | 202611042342

-- indirizzi_caratteristiche.se_assente
CALL `__patch_recupero_canone_indici__`( 'UPDATE `indirizzi_caratteristiche` SET `se_assente` = IF( `se_presente` = 1, NULL, 1 ) WHERE `se_assente` IS NULL', 'indirizzi_caratteristiche.se_assente' );

-- | 202611042343

-- iva.data_archiviazione
CALL `__patch_recupero_canone_indici__`( 'UPDATE `iva` SET `data_archiviazione` = DATE( FROM_UNIXTIME( `timestamp_archiviazione` ) ) WHERE `data_archiviazione` IS NULL AND `timestamp_archiviazione` IS NOT NULL', 'iva.data_archiviazione' );

-- | 202611042344

-- pubblicazioni.id_sito
CALL `__patch_recupero_canone_indici__`( 'UPDATE `pubblicazioni` INNER JOIN `banner` ON `banner`.`id` = `pubblicazioni`.`id_banner` SET `pubblicazioni`.`id_sito` = `banner`.`id_sito` WHERE `pubblicazioni`.`id_sito` IS NULL AND `banner`.`id_sito` IS NOT NULL', 'pubblicazioni.id_sito' );

-- | 202611042345

-- documenti_articoli.id_immobile
CALL `__patch_recupero_canone_indici__`( 'UPDATE `documenti_articoli` INNER JOIN `documenti` ON `documenti`.`id` = `documenti_articoli`.`id_documento` SET `documenti_articoli`.`id_immobile` = `documenti`.`id_immobile` WHERE `documenti_articoli`.`id_immobile` IS NULL AND `documenti`.`id_immobile` IS NOT NULL', 'documenti_articoli.id_immobile' );

-- | 202611042346

-- metadati.id_asset
CALL `__patch_recupero_canone_indici__`( 'ALTER TABLE `metadati` MODIFY `id_asset` bigint(20) DEFAULT NULL', 'metadati.id_asset' );

-- | 202611042347

-- quello che non si e' potuto fare, e perche': sui DB creati dopo il 04/10 le colonne vecchie non ci sono
SELECT @recupero_canone_indici_note AS nota;

-- | 202611042348

-- si libera la procedura
DROP PROCEDURE IF EXISTS `__patch_recupero_canone_indici__`;

-- | 202611042349

-- account: indici nella forma del canone
ALTER TABLE `account`
	DROP INDEX IF EXISTS `id_organizzazione`,
	ADD KEY `id_organizzazione` (`id_organizzazione`);

-- | 202611042350

-- anagrafica_consensi: via i vincoli che cambiano
ALTER TABLE `anagrafica_consensi`
	DROP FOREIGN KEY IF EXISTS `anagrafica_consensi_ibfk_03_nofollow`;

-- | 202611042351

-- anagrafica_consensi: vincoli nella forma del canone
ALTER TABLE `anagrafica_consensi`
	ADD CONSTRAINT `anagrafica_consensi_ibfk_03_nofollow` FOREIGN KEY (`id_consenso`) REFERENCES `consensi` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042352

-- anagrafica_organizzazioni: via i vincoli che cambiano
ALTER TABLE `anagrafica_organizzazioni`
	DROP FOREIGN KEY IF EXISTS `anagrafica_organizzazioni_ibfk_01`,
	DROP FOREIGN KEY IF EXISTS `anagrafica_organizzazioni_ibfk_02_nofollow`,
	DROP FOREIGN KEY IF EXISTS `anagrafica_organizzazioni_ibfk_03_nofollow`,
	DROP FOREIGN KEY IF EXISTS `anagrafica_organizzazioni_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `anagrafica_organizzazioni_ibfk_99_nofollow`;

-- | 202611042353

-- anagrafica_organizzazioni: indici nella forma del canone
ALTER TABLE `anagrafica_organizzazioni`
	DROP INDEX IF EXISTS `id_account_aggiornamento`,
	DROP INDEX IF EXISTS `id_account_inserimento`,
	DROP INDEX IF EXISTS `id_anagrafica`,
	DROP INDEX IF EXISTS `id_organizzazione`,
	DROP INDEX IF EXISTS `id_ruolo`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_anagrafica` (`id_anagrafica`),
	ADD KEY `id_organizzazione` (`id_organizzazione`),
	ADD KEY `id_ruolo` (`id_ruolo`),
	ADD KEY `indice` (`id`,`ordine`,`id_anagrafica`,`id_organizzazione`,`id_ruolo`),
	ADD KEY `ordine` (`ordine`);

-- | 202611042354

-- anagrafica_organizzazioni: vincoli nella forma del canone
ALTER TABLE `anagrafica_organizzazioni`
	ADD CONSTRAINT `anagrafica_organizzazioni_ibfk_01` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `anagrafica_organizzazioni_ibfk_02_nofollow` FOREIGN KEY (`id_organizzazione`) REFERENCES `organizzazioni` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `anagrafica_organizzazioni_ibfk_03_nofollow` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `anagrafica_organizzazioni_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `anagrafica_organizzazioni_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042355

-- annunci: via i vincoli che cambiano
ALTER TABLE `annunci`
	DROP FOREIGN KEY IF EXISTS `annunci_ibfk_04_nofollow`;

-- | 202611042356

-- annunci: vincoli nella forma del canone
ALTER TABLE `annunci`
	ADD CONSTRAINT `annunci_ibfk_04_nofollow` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042357

-- annunci_categorie: via i vincoli che cambiano
ALTER TABLE `annunci_categorie`
	DROP FOREIGN KEY IF EXISTS `annunci_categorie_ibfk_01`,
	DROP FOREIGN KEY IF EXISTS `annunci_categorie_ibfk_01_nofollow`,
	DROP FOREIGN KEY IF EXISTS `annunci_categorie_ibfk_02_nofollow`;

-- | 202611042358

-- annunci_categorie: indici nella forma del canone
ALTER TABLE `annunci_categorie`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `unica`,
	ADD KEY `indice` (`id`,`id_annuncio`,`id_categoria`,`ordine`),
	ADD UNIQUE KEY `unica` (`id_annuncio`,`id_categoria`);

-- | 202611042359

-- annunci_categorie: vincoli nella forma del canone
ALTER TABLE `annunci_categorie`
	ADD CONSTRAINT `annunci_categorie_ibfk_01` FOREIGN KEY (`id_annuncio`) REFERENCES `annunci` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `annunci_categorie_ibfk_02_nofollow` FOREIGN KEY (`id_categoria`) REFERENCES `categorie_annunci` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042360

-- articoli: via i vincoli che cambiano
ALTER TABLE `articoli`
	DROP FOREIGN KEY IF EXISTS `articoli_ibfk_03_nofollow`,
	DROP FOREIGN KEY IF EXISTS `articoli_ibfk_04_nofollow`,
	DROP FOREIGN KEY IF EXISTS `articoli_ibfk_05_nofollow`,
	DROP FOREIGN KEY IF EXISTS `articoli_ibfk_06_nofollow`,
	DROP FOREIGN KEY IF EXISTS `articoli_ibfk_07_nofollow`,
	DROP FOREIGN KEY IF EXISTS `articoli_ibfk_08_nofollow`,
	DROP FOREIGN KEY IF EXISTS `articoli_ibfk_09_nofollow`,
	DROP FOREIGN KEY IF EXISTS `articoli_ibfk_10_nofollow`,
	DROP FOREIGN KEY IF EXISTS `articoli_ibfk_11_nofollow`;

-- | 202611042361

-- articoli: indici nella forma del canone
ALTER TABLE `articoli`
	DROP INDEX IF EXISTS `ordine`,
	ADD KEY `ordine` (`ordine`);

-- | 202611042362

-- articoli: vincoli nella forma del canone
ALTER TABLE `articoli`
	ADD CONSTRAINT `articoli_ibfk_03_nofollow` FOREIGN KEY (`id_taglia`) REFERENCES `taglie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `articoli_ibfk_04_nofollow` FOREIGN KEY (`id_colore`) REFERENCES `colori` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `articoli_ibfk_05_nofollow` FOREIGN KEY (`id_periodicita`) REFERENCES `periodicita` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `articoli_ibfk_06_nofollow` FOREIGN KEY (`id_tipologia_rinnovo`) REFERENCES `tipologie_rinnovi` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `articoli_ibfk_07_nofollow` FOREIGN KEY (`id_udm_dimensioni`) REFERENCES `udm` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `articoli_ibfk_08_nofollow` FOREIGN KEY (`id_udm_peso`) REFERENCES `udm` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `articoli_ibfk_09_nofollow` FOREIGN KEY (`id_udm_volume`) REFERENCES `udm` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `articoli_ibfk_10_nofollow` FOREIGN KEY (`id_udm_capacita`) REFERENCES `udm` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `articoli_ibfk_11_nofollow` FOREIGN KEY (`id_udm_durata`) REFERENCES `udm` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042363

-- articoli_caratteristiche: indici nella forma del canone
ALTER TABLE `articoli_caratteristiche`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	DROP INDEX IF EXISTS `unica`,
	ADD KEY `indice` (`id`,`ordine`,`id_articolo`,`id_caratteristica`,`id_lingua`,`se_assente`),
	ADD KEY `ordine` (`ordine`),
	ADD UNIQUE KEY `unica` (`id_articolo`,`id_caratteristica`,`id_lingua`);

-- | 202611042364

-- asset: via i vincoli che cambiano
ALTER TABLE `asset`
	DROP FOREIGN KEY IF EXISTS `asset_ibfk_01_nofollow`,
	DROP FOREIGN KEY IF EXISTS `asset_ibfk_02_nofollow`;

-- | 202611042365

-- asset: indici nella forma del canone
ALTER TABLE `asset`
	DROP INDEX IF EXISTS `id_condizione`,
	DROP INDEX IF EXISTS `id_genitore`,
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `id_condizione` (`id_condizione`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `indice` (`id`,`id_genitore`,`id_tipologia`,`codice`);

-- | 202611042366

-- asset: vincoli nella forma del canone
ALTER TABLE `asset`
	ADD CONSTRAINT `asset_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `asset` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `asset_ibfk_02_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_asset` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042367

-- attivita: via i vincoli che cambiano
ALTER TABLE `attivita`
	DROP FOREIGN KEY IF EXISTS `attivita_ibfk_03_nofollow`,
	DROP FOREIGN KEY IF EXISTS `attivita_ibfk_04_nofollow`,
	DROP FOREIGN KEY IF EXISTS `attivita_ibfk_05_nofollow`,
	DROP FOREIGN KEY IF EXISTS `attivita_ibfk_06_nofollow`,
	DROP FOREIGN KEY IF EXISTS `attivita_ibfk_07_nofollow`,
	DROP FOREIGN KEY IF EXISTS `attivita_ibfk_08_nofollow`,
	DROP FOREIGN KEY IF EXISTS `attivita_ibfk_09_nofollow`,
	DROP FOREIGN KEY IF EXISTS `attivita_ibfk_10_nofollow`,
	DROP FOREIGN KEY IF EXISTS `attivita_ibfk_12_nofollow`,
	DROP FOREIGN KEY IF EXISTS `attivita_ibfk_13_nofollow`,
	DROP FOREIGN KEY IF EXISTS `attivita_ibfk_14_nofollow`,
	DROP FOREIGN KEY IF EXISTS `attivita_ibfk_16_nofollow`,
	DROP FOREIGN KEY IF EXISTS `attivita_ibfk_17_nofollow`,
	DROP FOREIGN KEY IF EXISTS `attivita_ibfk_18_nofollow`,
	DROP FOREIGN KEY IF EXISTS `attivita_ibfk_19_nofollow`,
	DROP FOREIGN KEY IF EXISTS `attivita_ibfk_20_nofollow`,
	DROP FOREIGN KEY IF EXISTS `attivita_ibfk_21_nofollow`,
	DROP FOREIGN KEY IF EXISTS `attivita_ibfk_22_nofollow`,
	DROP FOREIGN KEY IF EXISTS `attivita_ibfk_23_nofollow`,
	DROP FOREIGN KEY IF EXISTS `attivita_ibfk_24_nofollow`,
	DROP FOREIGN KEY IF EXISTS `attivita_ibfk_25_nofollow`,
	DROP FOREIGN KEY IF EXISTS `attivita_ibfk_26_nofollow`;

-- | 202611042368

-- attivita: indici nella forma del canone
ALTER TABLE `attivita`
	DROP INDEX IF EXISTS `codice`,
	DROP INDEX IF EXISTS `codice_archivium`,
	DROP INDEX IF EXISTS `id_banner`,
	DROP INDEX IF EXISTS `id_pubblicazione`,
	DROP INDEX IF EXISTS `id_redirect`,
	DROP INDEX IF EXISTS `unica_codice`,
	ADD KEY `id_banner` (`id_banner`),
	ADD KEY `id_pubblicazione` (`id_pubblicazione`),
	ADD KEY `id_redirect` (`id_redirect`),
	ADD UNIQUE KEY `unica_codice` (`codice`);

-- | 202611042369

-- attivita: vincoli nella forma del canone
ALTER TABLE `attivita`
	ADD CONSTRAINT `attivita_ibfk_03_nofollow` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `attivita_ibfk_04_nofollow` FOREIGN KEY (`id_mail`) REFERENCES `mail` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `attivita_ibfk_05_nofollow` FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `attivita_ibfk_06_nofollow` FOREIGN KEY (`id_cliente`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `attivita_ibfk_07_nofollow` FOREIGN KEY (`id_contatto`) REFERENCES `contatti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `attivita_ibfk_08_nofollow` FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `attivita_ibfk_09_nofollow` FOREIGN KEY (`id_luogo`) REFERENCES `luoghi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `attivita_ibfk_10_nofollow` FOREIGN KEY (`id_asset`) REFERENCES `asset` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `attivita_ibfk_12_nofollow` FOREIGN KEY (`id_contratto`) REFERENCES `contratti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `attivita_ibfk_13_nofollow` FOREIGN KEY (`id_todo`) REFERENCES `todo` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `attivita_ibfk_14_nofollow` FOREIGN KEY (`id_step`) REFERENCES `step` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `attivita_ibfk_16_nofollow` FOREIGN KEY (`id_matricola`) REFERENCES `matricole` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `attivita_ibfk_17_nofollow` FOREIGN KEY (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `attivita_ibfk_18_nofollow` FOREIGN KEY (`id_messaggio`) REFERENCES `messaggi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `attivita_ibfk_19_nofollow` FOREIGN KEY (`id_mailing`) REFERENCES `mailing` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `attivita_ibfk_20_nofollow` FOREIGN KEY (`id_documento`) REFERENCES `documenti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `attivita_ibfk_21_nofollow` FOREIGN KEY (`id_corrispondenza`) REFERENCES `corrispondenza` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `attivita_ibfk_22_nofollow` FOREIGN KEY (`id_pagamento`) REFERENCES `pagamenti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `attivita_ibfk_23_nofollow` FOREIGN KEY (`id_mastro_provenienza`) REFERENCES `mastri` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `attivita_ibfk_24_nofollow` FOREIGN KEY (`id_mastro_destinazione`) REFERENCES `mastri` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `attivita_ibfk_25_nofollow` FOREIGN KEY (`id_oggetto`) REFERENCES `asset` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `attivita_ibfk_26_nofollow` FOREIGN KEY (`id_anagrafica_programmazione`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042370

-- attivita_asset: via i vincoli che cambiano
ALTER TABLE `attivita_asset`
	DROP FOREIGN KEY IF EXISTS `attivita_asset_ibfk_01`,
	DROP FOREIGN KEY IF EXISTS `attivita_asset_ibfk_02_nofollow`,
	DROP FOREIGN KEY IF EXISTS `attivita_asset_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `attivita_asset_ibfk_99_nofollow`;

-- | 202611042371

-- attivita_asset: indici nella forma del canone
ALTER TABLE `attivita_asset`
	DROP INDEX IF EXISTS `id_account_aggiornamento`,
	DROP INDEX IF EXISTS `id_account_inserimento`,
	DROP INDEX IF EXISTS `id_asset`,
	DROP INDEX IF EXISTS `id_attivita`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_asset` (`id_asset`),
	ADD KEY `id_attivita` (`id_attivita`),
	ADD KEY `indice` (`id`,`ordine`,`id_attivita`,`id_asset`),
	ADD KEY `ordine` (`ordine`);

-- | 202611042372

-- attivita_asset: vincoli nella forma del canone
ALTER TABLE `attivita_asset`
	ADD CONSTRAINT `attivita_asset_ibfk_01` FOREIGN KEY (`id_attivita`) REFERENCES `attivita` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `attivita_asset_ibfk_02_nofollow` FOREIGN KEY (`id_asset`) REFERENCES `asset` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `attivita_asset_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `attivita_asset_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042373

-- audio: via i vincoli che cambiano
ALTER TABLE `audio`
	DROP FOREIGN KEY IF EXISTS `audio_ibfk_01`,
	DROP FOREIGN KEY IF EXISTS `audio_ibfk_02`,
	DROP FOREIGN KEY IF EXISTS `audio_ibfk_03`,
	DROP FOREIGN KEY IF EXISTS `audio_ibfk_04`,
	DROP FOREIGN KEY IF EXISTS `audio_ibfk_05`,
	DROP FOREIGN KEY IF EXISTS `audio_ibfk_05_nofollow`,
	DROP FOREIGN KEY IF EXISTS `audio_ibfk_06`,
	DROP FOREIGN KEY IF EXISTS `audio_ibfk_07`,
	DROP FOREIGN KEY IF EXISTS `audio_ibfk_08`,
	DROP FOREIGN KEY IF EXISTS `audio_ibfk_09`,
	DROP FOREIGN KEY IF EXISTS `audio_ibfk_10`,
	DROP FOREIGN KEY IF EXISTS `audio_ibfk_11`,
	DROP FOREIGN KEY IF EXISTS `audio_ibfk_12`,
	DROP FOREIGN KEY IF EXISTS `audio_ibfk_13_nofollow`,
	DROP FOREIGN KEY IF EXISTS `audio_ibfk_14`,
	DROP FOREIGN KEY IF EXISTS `audio_ibfk_14_nofollow`,
	DROP FOREIGN KEY IF EXISTS `audio_ibfk_15`,
	DROP FOREIGN KEY IF EXISTS `audio_ibfk_16`,
	DROP FOREIGN KEY IF EXISTS `audio_ibfk_17`,
	DROP FOREIGN KEY IF EXISTS `audio_ibfk_18`,
	DROP FOREIGN KEY IF EXISTS `audio_ibfk_19`,
	DROP FOREIGN KEY IF EXISTS `audio_ibfk_20`,
	DROP FOREIGN KEY IF EXISTS `audio_ibfk_21`,
	DROP FOREIGN KEY IF EXISTS `audio_ibfk_22`,
	DROP FOREIGN KEY IF EXISTS `audio_ibfk_25_nofollow`;

-- | 202611042374

-- audio: indici nella forma del canone
ALTER TABLE `audio`
	DROP INDEX IF EXISTS `id_anagrafica`,
	DROP INDEX IF EXISTS `id_annuncio`,
	DROP INDEX IF EXISTS `id_articolo`,
	DROP INDEX IF EXISTS `id_categoria_annunci`,
	DROP INDEX IF EXISTS `id_categoria_notizie`,
	DROP INDEX IF EXISTS `id_categoria_prodotti`,
	DROP INDEX IF EXISTS `id_categoria_progetti`,
	DROP INDEX IF EXISTS `id_categoria_risorse`,
	DROP INDEX IF EXISTS `id_edificio`,
	DROP INDEX IF EXISTS `id_file`,
	DROP INDEX IF EXISTS `id_immobile`,
	DROP INDEX IF EXISTS `id_indirizzo`,
	DROP INDEX IF EXISTS `id_marchio`,
	DROP INDEX IF EXISTS `id_notizia`,
	DROP INDEX IF EXISTS `id_pagina`,
	DROP INDEX IF EXISTS `id_prodotto`,
	DROP INDEX IF EXISTS `id_progetto`,
	DROP INDEX IF EXISTS `id_risorsa`,
	DROP INDEX IF EXISTS `id_valutazione`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	DROP INDEX IF EXISTS `unica`,
	DROP INDEX IF EXISTS `unica_anagrafica`,
	DROP INDEX IF EXISTS `unica_annuncio`,
	DROP INDEX IF EXISTS `unica_articolo`,
	DROP INDEX IF EXISTS `unica_categoria_annunci`,
	DROP INDEX IF EXISTS `unica_categoria_marchi`,
	DROP INDEX IF EXISTS `unica_categoria_notizie`,
	DROP INDEX IF EXISTS `unica_categoria_prodotti`,
	DROP INDEX IF EXISTS `unica_categoria_progetti`,
	DROP INDEX IF EXISTS `unica_categoria_risorse`,
	DROP INDEX IF EXISTS `unica_codice_embed`,
	DROP INDEX IF EXISTS `unica_edificio`,
	DROP INDEX IF EXISTS `unica_file`,
	DROP INDEX IF EXISTS `unica_immagine`,
	DROP INDEX IF EXISTS `unica_immobile`,
	DROP INDEX IF EXISTS `unica_indirizzo`,
	DROP INDEX IF EXISTS `unica_marchio`,
	DROP INDEX IF EXISTS `unica_notizia`,
	DROP INDEX IF EXISTS `unica_pagina`,
	DROP INDEX IF EXISTS `unica_prodotto`,
	DROP INDEX IF EXISTS `unica_progetto`,
	DROP INDEX IF EXISTS `unica_risorsa`,
	DROP INDEX IF EXISTS `unica_valutazione`,
	DROP INDEX IF EXISTS `unica_vano`,
	DROP INDEX IF EXISTS `unica_video`,
	ADD KEY `indice` (`id`,`ordine`,`nome`,`id_lingua`,`id_ruolo`,`path`),
	ADD KEY `ordine` (`ordine`),
	ADD UNIQUE KEY `unica_anagrafica` (`id_anagrafica`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_annuncio` (`id_annuncio`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_articolo` (`id_articolo`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_categoria_annunci` (`id_categoria_annunci`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_categoria_marchi` (`id_categoria_marchi`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_categoria_notizie` (`id_categoria_notizie`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_categoria_prodotti` (`id_categoria_prodotti`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_categoria_progetti` (`id_categoria_progetti`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_categoria_risorse` (`id_categoria_risorse`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_edificio` (`id_edificio`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_file` (`id_file`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_immagine` (`id_immagine`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_immobile` (`id_immobile`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_indirizzo` (`id_indirizzo`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_marchio` (`id_marchio`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_notizia` (`id_notizia`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_pagina` (`id_pagina`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_prodotto` (`id_prodotto`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_progetto` (`id_progetto`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_risorsa` (`id_risorsa`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_valutazione` (`id_valutazione`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_vano` (`id_vano`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_video` (`id_video`,`id_ruolo`,`id_lingua`,`path`);

-- | 202611042375

-- audio: vincoli nella forma del canone
ALTER TABLE `audio`
	ADD CONSTRAINT `audio_ibfk_01` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `audio_ibfk_02` FOREIGN KEY (`id_annuncio`) REFERENCES `annunci` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `audio_ibfk_03` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `audio_ibfk_04` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `audio_ibfk_05_nofollow` FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `audio_ibfk_06` FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `audio_ibfk_07` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `audio_ibfk_08` FOREIGN KEY (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `audio_ibfk_09` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `audio_ibfk_10` FOREIGN KEY (`id_file`) REFERENCES `file` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `audio_ibfk_11` FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `audio_ibfk_12` FOREIGN KEY (`id_marchio`) REFERENCES `marchi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `audio_ibfk_14` FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `audio_ibfk_15` FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `audio_ibfk_16` FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `audio_ibfk_17` FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `audio_ibfk_18` FOREIGN KEY (`id_categoria_annunci`) REFERENCES `categorie_annunci` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `audio_ibfk_19` FOREIGN KEY (`id_categoria_progetti`) REFERENCES `categorie_progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `audio_ibfk_20` FOREIGN KEY (`id_edificio`) REFERENCES `edifici` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `audio_ibfk_21` FOREIGN KEY (`id_valutazione`) REFERENCES `valutazioni` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `audio_ibfk_22` FOREIGN KEY (`id_video`) REFERENCES `video` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `audio_ibfk_25_nofollow` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_audio` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042376

-- badge: via i vincoli che cambiano
ALTER TABLE `badge`
	DROP FOREIGN KEY IF EXISTS `badge_ibfk_02`,
	DROP FOREIGN KEY IF EXISTS `badge_ibfk_03`;

-- | 202611042377

-- badge: indici nella forma del canone
ALTER TABLE `badge`
	DROP INDEX IF EXISTS `codice`,
	DROP INDEX IF EXISTS `id_anagrafica`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `indice_codice`,
	DROP INDEX IF EXISTS `unica_codice`,
	ADD KEY `codice` (`codice`),
	ADD KEY `id_anagrafica` (`id_anagrafica`),
	ADD KEY `indice` (`id`,`id_tipologia`,`codice`,`nome`,`id_anagrafica`,`id_contratto`,`rfid`),
	ADD UNIQUE KEY `unica_codice` (`id_tipologia`,`codice`);

-- | 202611042378

-- badge: vincoli nella forma del canone
ALTER TABLE `badge`
	ADD CONSTRAINT `badge_ibfk_02` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `badge_ibfk_03` FOREIGN KEY (`id_contratto`) REFERENCES `contratti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042379

-- banner: indici nella forma del canone
ALTER TABLE `banner`
	DROP INDEX IF EXISTS `altezza`,
	DROP INDEX IF EXISTS `id_affiliazione`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `larghezza`,
	ADD KEY `altezza` (`altezza`),
	ADD KEY `id_affiliazione` (`id_affiliazione`),
	ADD KEY `indice` (`id`,`id_tipologia`,`ordine`,`nome`,`id_inserzionista`,`id_affiliazione`,`larghezza`,`altezza`),
	ADD KEY `larghezza` (`larghezza`);

-- | 202611042380

-- banner_zone: indici nella forma del canone
ALTER TABLE `banner_zone`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	DROP INDEX IF EXISTS `unica`,
	ADD KEY `indice` (`id`,`ordine`,`id_banner`,`id_zona`),
	ADD KEY `ordine` (`ordine`),
	ADD UNIQUE KEY `unica` (`id_banner`,`id_zona`);

-- | 202611042381

-- campagne: indici nella forma del canone
ALTER TABLE `campagne`
	DROP INDEX IF EXISTS `budget`,
	DROP INDEX IF EXISTS `codice`,
	DROP INDEX IF EXISTS `data_fine`,
	DROP INDEX IF EXISTS `data_inizio`,
	DROP INDEX IF EXISTS `id_genitore`,
	DROP INDEX IF EXISTS `id_tipologia`,
	DROP INDEX IF EXISTS `id_valuta`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	DROP INDEX IF EXISTS `utm_campaign`,
	ADD KEY `budget` (`budget`),
	ADD UNIQUE KEY `codice` (`codice`),
	ADD KEY `data_fine` (`data_fine`),
	ADD KEY `data_inizio` (`data_inizio`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `id_tipologia` (`id_tipologia`),
	ADD KEY `id_valuta` (`id_valuta`),
	ADD KEY `indice` (`id`,`id_genitore`,`id_tipologia`,`ordine`,`codice`,`nome`,`id_valuta`,`budget`,`data_inizio`,`data_fine`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `utm_campaign` (`utm_campaign`);

-- | 202611042382

-- caratteristiche: indici nella forma del canone
ALTER TABLE `caratteristiche`
	DROP INDEX IF EXISTS `codice`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `ordine`,
	DROP INDEX IF EXISTS `se_articoli`,
	DROP INDEX IF EXISTS `se_prodotti`,
	ADD UNIQUE KEY `codice` (`codice`),
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`codice`,`nome`,`se_prodotti`,`se_articoli`,`se_immobili`,`se_edifici`,`se_indirizzi`,`se_vani`),
	ADD KEY `nome` (`nome`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `se_articoli` (`se_articoli`),
	ADD KEY `se_prodotti` (`se_prodotti`);

-- | 202611042383

-- carrelli_articoli: via i vincoli che cambiano
ALTER TABLE `carrelli_articoli`
	DROP FOREIGN KEY IF EXISTS `carrelli_articoli_ibfk_03_nofollow`,
	DROP FOREIGN KEY IF EXISTS `carrelli_articoli_ibfk_04_nofollow`,
	DROP FOREIGN KEY IF EXISTS `carrelli_articoli_ibfk_05`,
	DROP FOREIGN KEY IF EXISTS `carrelli_articoli_ibfk_05_nofollow`,
	DROP FOREIGN KEY IF EXISTS `carrelli_articoli_ibfk_06_nofollow`,
	DROP FOREIGN KEY IF EXISTS `carrelli_articoli_ibfk_07_nofollow`,
	DROP FOREIGN KEY IF EXISTS `carrelli_articoli_ibfk_08_nofollow`,
	DROP FOREIGN KEY IF EXISTS `carrelli_articoli_ibfk_09_nofollow`,
	DROP FOREIGN KEY IF EXISTS `carrelli_articoli_ibfk_10_nofollow`,
	DROP FOREIGN KEY IF EXISTS `carrelli_articoli_ibfk_11_nofollow`,
	DROP FOREIGN KEY IF EXISTS `carrelli_articoli_ibfk_12_nofollow`,
	DROP FOREIGN KEY IF EXISTS `carrelli_articoli_ibfk_13_nofollow`,
	DROP FOREIGN KEY IF EXISTS `carrelli_articoli_ibfk_14_nofollow`,
	DROP FOREIGN KEY IF EXISTS `carrelli_articoli_ibfk_15_nofollow`,
	DROP FOREIGN KEY IF EXISTS `carrelli_articoli_ibfk_16_nofollow`,
	DROP FOREIGN KEY IF EXISTS `carrelli_articoli_ibfk_17_nofollow`,
	DROP FOREIGN KEY IF EXISTS `carrelli_articoli_ibfk_18_nofollow`;

-- | 202611042384

-- carrelli_articoli: indici nella forma del canone
ALTER TABLE `carrelli_articoli`
	DROP INDEX IF EXISTS `destinatario_id_account`,
	DROP INDEX IF EXISTS `destinatario_id_comune`,
	DROP INDEX IF EXISTS `destinatario_id_comune_nascita`,
	DROP INDEX IF EXISTS `destinatario_id_provincia`,
	DROP INDEX IF EXISTS `destinatario_id_provincia_nascita`,
	DROP INDEX IF EXISTS `destinatario_id_stato`,
	DROP INDEX IF EXISTS `destinatario_id_stato_nascita`,
	DROP INDEX IF EXISTS `destinatario_id_tipologia_anagrafica`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	ADD KEY `destinatario_id_account` (`destinatario_id_account`),
	ADD KEY `destinatario_id_comune` (`destinatario_id_comune`),
	ADD KEY `destinatario_id_comune_nascita` (`destinatario_id_comune_nascita`),
	ADD KEY `destinatario_id_provincia` (`destinatario_id_provincia`),
	ADD KEY `destinatario_id_provincia_nascita` (`destinatario_id_provincia_nascita`),
	ADD KEY `destinatario_id_stato` (`destinatario_id_stato`),
	ADD KEY `destinatario_id_stato_nascita` (`destinatario_id_stato_nascita`),
	ADD KEY `destinatario_id_tipologia_anagrafica` (`destinatario_id_tipologia_anagrafica`),
	ADD KEY `indice` (`id`,`ordine`,`id_carrello`,`id_articolo`,`destinatario_id_anagrafica`),
	ADD KEY `ordine` (`ordine`);

-- | 202611042385

-- carrelli_articoli: vincoli nella forma del canone
ALTER TABLE `carrelli_articoli`
	ADD CONSTRAINT `carrelli_articoli_ibfk_03_nofollow` FOREIGN KEY (`id_listino`) REFERENCES `listini` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `carrelli_articoli_ibfk_04_nofollow` FOREIGN KEY (`id_iva`) REFERENCES `iva` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `carrelli_articoli_ibfk_05_nofollow` FOREIGN KEY (`id_pagamento`) REFERENCES `pagamenti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `carrelli_articoli_ibfk_06_nofollow` FOREIGN KEY (`id_rinnovo`) REFERENCES `rinnovi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `carrelli_articoli_ibfk_07_nofollow` FOREIGN KEY (`id_mastro_provenienza`) REFERENCES `mastri` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `carrelli_articoli_ibfk_08_nofollow` FOREIGN KEY (`id_coupon`) REFERENCES `coupon` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `carrelli_articoli_ibfk_09_nofollow` FOREIGN KEY (`destinatario_id_tipologia_anagrafica`) REFERENCES `tipologie_anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `carrelli_articoli_ibfk_10_nofollow` FOREIGN KEY (`destinatario_id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `carrelli_articoli_ibfk_11_nofollow` FOREIGN KEY (`destinatario_id_account`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `carrelli_articoli_ibfk_12_nofollow` FOREIGN KEY (`destinatario_id_comune`) REFERENCES `comuni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `carrelli_articoli_ibfk_13_nofollow` FOREIGN KEY (`destinatario_id_provincia`) REFERENCES `provincie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `carrelli_articoli_ibfk_14_nofollow` FOREIGN KEY (`destinatario_id_stato`) REFERENCES `stati` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `carrelli_articoli_ibfk_15_nofollow` FOREIGN KEY (`destinatario_id_comune_nascita`) REFERENCES `comuni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `carrelli_articoli_ibfk_16_nofollow` FOREIGN KEY (`destinatario_id_provincia_nascita`) REFERENCES `provincie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `carrelli_articoli_ibfk_17_nofollow` FOREIGN KEY (`destinatario_id_stato_nascita`) REFERENCES `stati` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `carrelli_articoli_ibfk_18_nofollow` FOREIGN KEY (`id_account_evasione`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042386

-- carrelli_consensi: indici nella forma del canone
ALTER TABLE `carrelli_consensi`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	ADD KEY `indice` (`id`,`ordine`,`id_carrello`,`id_anagrafica`,`id_account`,`id_consenso`,`se_prestato`),
	ADD KEY `ordine` (`ordine`);

-- | 202611042387

-- casse_previdenziali: via i vincoli che cambiano
ALTER TABLE `casse_previdenziali`
	DROP FOREIGN KEY IF EXISTS `casse_previdenziali_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `casse_previdenziali_ibfk_99_nofollow`;

-- | 202611042388

-- casse_previdenziali: indici nella forma del canone
ALTER TABLE `casse_previdenziali`
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `indice` (`id`,`codice`,`nome`);

-- | 202611042389

-- categorie_anagrafica: indici nella forma del canone
ALTER TABLE `categorie_anagrafica`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `se_annunci`,
	DROP INDEX IF EXISTS `se_contratti`,
	DROP INDEX IF EXISTS `se_didattica`,
	DROP INDEX IF EXISTS `se_immobili`,
	DROP INDEX IF EXISTS `se_logistica`,
	DROP INDEX IF EXISTS `se_organizzazioni`,
	DROP INDEX IF EXISTS `se_partner`,
	DROP INDEX IF EXISTS `se_produzione`,
	DROP INDEX IF EXISTS `se_progetti`,
	DROP INDEX IF EXISTS `se_relazioni`,
	DROP INDEX IF EXISTS `se_risorse`,
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`codice`,`nome`,`se_lead`,`se_prospect`,`se_cliente`,`se_fornitore`,`se_produttore`,`se_corriere`,`se_collaboratore`,`se_interno`,`se_esterno`,`se_concorrente`,`se_partner`),
	ADD KEY `se_annunci` (`se_annunci`),
	ADD KEY `se_contratti` (`se_contratti`),
	ADD KEY `se_didattica` (`se_didattica`),
	ADD KEY `se_immobili` (`se_immobili`),
	ADD KEY `se_logistica` (`se_logistica`),
	ADD KEY `se_organizzazioni` (`se_organizzazioni`),
	ADD KEY `se_partner` (`se_partner`),
	ADD KEY `se_produzione` (`se_produzione`),
	ADD KEY `se_progetti` (`se_progetti`),
	ADD KEY `se_relazioni` (`se_relazioni`),
	ADD KEY `se_risorse` (`se_risorse`);

-- | 202611042390

-- categorie_annunci: indici nella forma del canone
ALTER TABLE `categorie_annunci`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`codice`,`nome`,`id_sito`,`id_pagina`),
	ADD KEY `ordine` (`ordine`);

-- | 202611042391

-- categorie_conversazioni: via i vincoli che cambiano
ALTER TABLE `categorie_conversazioni`
	DROP FOREIGN KEY IF EXISTS `categorie_conversazioni_ibfk_01_nofollow`,
	DROP FOREIGN KEY IF EXISTS `categorie_conversazioni_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `categorie_conversazioni_ibfk_99_nofollow`;

-- | 202611042392

-- categorie_conversazioni: indici nella forma del canone
ALTER TABLE `categorie_conversazioni`
	DROP INDEX IF EXISTS `id_account_aggiornamento`,
	DROP INDEX IF EXISTS `id_account_inserimento`,
	DROP INDEX IF EXISTS `id_genitore`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`codice`,`nome`),
	ADD KEY `ordine` (`ordine`);

-- | 202611042393

-- categorie_conversazioni: vincoli nella forma del canone
ALTER TABLE `categorie_conversazioni`
	ADD CONSTRAINT `categorie_conversazioni_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `categorie_conversazioni` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `categorie_conversazioni_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `categorie_conversazioni_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042394

-- categorie_marchi: via i vincoli che cambiano
ALTER TABLE `categorie_marchi`
	DROP FOREIGN KEY IF EXISTS `categorie_marchi_ibfk_01_nofollow`,
	DROP FOREIGN KEY IF EXISTS `categorie_marchi_ibfk_02_nofollow`,
	DROP FOREIGN KEY IF EXISTS `categorie_marchi_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `categorie_marchi_ibfk_99_nofollow`;

-- | 202611042395

-- categorie_marchi: indici nella forma del canone
ALTER TABLE `categorie_marchi`
	DROP INDEX IF EXISTS `id_account_aggiornamento`,
	DROP INDEX IF EXISTS `id_account_inserimento`,
	DROP INDEX IF EXISTS `id_genitore`,
	DROP INDEX IF EXISTS `id_pagina`,
	DROP INDEX IF EXISTS `id_sito`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `id_pagina` (`id_pagina`),
	ADD KEY `id_sito` (`id_sito`),
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`codice`,`nome`,`id_sito`,`id_pagina`),
	ADD KEY `ordine` (`ordine`);

-- | 202611042396

-- categorie_marchi: vincoli nella forma del canone
ALTER TABLE `categorie_marchi`
	ADD CONSTRAINT `categorie_marchi_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `categorie_marchi` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `categorie_marchi_ibfk_02_nofollow` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `categorie_marchi_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `categorie_marchi_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042397

-- categorie_notizie: indici nella forma del canone
ALTER TABLE `categorie_notizie`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`codice`,`nome`,`id_sito`,`id_pagina`),
	ADD KEY `ordine` (`ordine`);

-- | 202611042398

-- categorie_prodotti: indici nella forma del canone
ALTER TABLE `categorie_prodotti`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`codice`,`nome`,`id_sito`,`id_pagina`),
	ADD KEY `ordine` (`ordine`);

-- | 202611042399

-- categorie_progetti: indici nella forma del canone
ALTER TABLE `categorie_progetti`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	DROP INDEX IF EXISTS `se_cacheable`,
	DROP INDEX IF EXISTS `se_sitemap`,
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`codice`,`nome`,`id_sito`,`id_pagina`),
	ADD KEY `ordine` (`ordine`);

-- | 202611042400

-- categorie_risorse: indici nella forma del canone
ALTER TABLE `categorie_risorse`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`codice`,`nome`,`id_sito`,`id_pagina`),
	ADD KEY `ordine` (`ordine`);

-- | 202611042401

-- causali: indici nella forma del canone
ALTER TABLE `causali`
	DROP INDEX IF EXISTS `nome`;

-- | 202611042402

-- chiavi: via i vincoli che cambiano
ALTER TABLE `chiavi`
	DROP FOREIGN KEY IF EXISTS `chiavi_ibfk_01`,
	DROP FOREIGN KEY IF EXISTS `chiavi_ibfk_01_nofollow`;

-- | 202611042403

-- chiavi: indici nella forma del canone
ALTER TABLE `chiavi`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `unica`,
	ADD KEY `indice` (`id`,`id_tipologia`,`codice`,`nome`,`id_licenza`,`seriale`);

-- | 202611042404

-- chiavi: vincoli nella forma del canone
ALTER TABLE `chiavi`
	ADD CONSTRAINT `chiavi_ibfk_01` FOREIGN KEY (`id_licenza`) REFERENCES `licenze` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042405

-- classi_energetiche: via i vincoli che cambiano
ALTER TABLE `classi_energetiche`
	DROP FOREIGN KEY IF EXISTS `classi_energetiche_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `classi_energetiche_ibfk_99_nofollow`;

-- | 202611042406

-- classi_energetiche: indici nella forma del canone
ALTER TABLE `classi_energetiche`
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `indice` (`id`,`nome`,`ep_min`,`ep_max`,`hex`);

-- | 202611042407

-- colli: indici nella forma del canone
ALTER TABLE `colli`
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `indice` (`id`,`id_genitore`,`id_tipologia`,`ordine`,`codice`,`nome`);

-- | 202611042408

-- colori: via i vincoli che cambiano
ALTER TABLE `colori`
	DROP FOREIGN KEY IF EXISTS `colori_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `colori_ibfk_99_nofollow`;

-- | 202611042409

-- colori: indici nella forma del canone
ALTER TABLE `colori`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `indice_cmyk`,
	DROP INDEX IF EXISTS `indice_pantone`,
	DROP INDEX IF EXISTS `indice_ral`,
	DROP INDEX IF EXISTS `unica`,
	DROP INDEX IF EXISTS `unica_cmyk`,
	DROP INDEX IF EXISTS `unica_hex`,
	DROP INDEX IF EXISTS `unica_pantone`,
	DROP INDEX IF EXISTS `unica_ral`,
	DROP INDEX IF EXISTS `unica_rgb`,
	ADD KEY `indice` (`id`,`id_genitore`,`nome`,`hex`),
	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`);

-- | 202611042410

-- comuni: via i vincoli che cambiano
ALTER TABLE `comuni`
	DROP FOREIGN KEY IF EXISTS `comuni_ibfk_01_nofollow`,
	DROP FOREIGN KEY IF EXISTS `comuni_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `comuni_ibfk_99_nofollow`;

-- | 202611042411

-- comuni: indici nella forma del canone
ALTER TABLE `comuni`
	DROP INDEX IF EXISTS `data_archiviazione`,
	DROP INDEX IF EXISTS `id_successore`,
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `data_archiviazione` (`data_archiviazione`),
	ADD KEY `id_successore` (`id_successore`),
	ADD KEY `indice` (`id`,`nome`,`id_provincia`,`codice_istat`,`codice_catasto`);

-- | 202611042412

-- comuni: vincoli nella forma del canone
ALTER TABLE `comuni`
	ADD CONSTRAINT `comuni_ibfk_01_nofollow` FOREIGN KEY (`id_provincia`) REFERENCES `provincie` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042413

-- condizioni: via i vincoli che cambiano
ALTER TABLE `condizioni`
	DROP FOREIGN KEY IF EXISTS `condizioni_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `condizioni_ibfk_99_nofollow`;

-- | 202611042414

-- condizioni: indici nella forma del canone
ALTER TABLE `condizioni`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `se_asset`,
	DROP INDEX IF EXISTS `unica`,
	DROP INDEX IF EXISTS `unico`,
	ADD KEY `indice` (`id`,`nome`,`se_asset`,`se_catalogo`,`se_immobili`),
	ADD KEY `se_asset` (`se_asset`),
	ADD UNIQUE KEY `unica` (`nome`);

-- | 202611042415

-- condizioni_pagamento: via i vincoli che cambiano
ALTER TABLE `condizioni_pagamento`
	DROP FOREIGN KEY IF EXISTS `condizioni_pagamento_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `condizioni_pagamento_ibfk_99_nofollow`;

-- | 202611042416

-- condizioni_pagamento: indici nella forma del canone
ALTER TABLE `condizioni_pagamento`
	DROP INDEX IF EXISTS `codice`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `unico`,
	ADD UNIQUE KEY `codice` (`codice`),
	ADD KEY `indice` (`id`,`codice`,`nome`);

-- | 202611042417

-- consensi: via i vincoli che cambiano
ALTER TABLE `consensi`
	DROP FOREIGN KEY IF EXISTS `consensi_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `consensi_ibfk_99_nofollow`;

-- | 202611042418

-- consensi: indici nella forma del canone
ALTER TABLE `consensi`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `nome`,
	ADD KEY `indice` (`id`,`codice`,`nome`);

-- | 202611042419

-- consensi_contatti: via i vincoli che cambiano
ALTER TABLE `consensi_contatti`
	DROP FOREIGN KEY IF EXISTS `consensi_contatti_ibfk_01_nofollow`;

-- | 202611042420

-- consensi_contatti: indici nella forma del canone
ALTER TABLE `consensi_contatti`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	DROP INDEX IF EXISTS `se_prestato`,
	DROP INDEX IF EXISTS `unica`,
	ADD KEY `indice` (`id`,`ordine`,`id_contatto`,`id_consenso`,`modulo`,`se_prestato`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `se_prestato` (`se_prestato`),
	ADD UNIQUE KEY `unica` (`id_contatto`,`id_consenso`,`modulo`);

-- | 202611042421

-- consensi_contatti: vincoli nella forma del canone
ALTER TABLE `consensi_contatti`
	ADD CONSTRAINT `consensi_contatti_ibfk_01_nofollow` FOREIGN KEY (`id_consenso`) REFERENCES `consensi` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042422

-- consensi_moduli: via i vincoli che cambiano
ALTER TABLE `consensi_moduli`
	DROP FOREIGN KEY IF EXISTS `consensi_moduli_ibfk_02_nofollow`;

-- | 202611042423

-- consensi_moduli: indici nella forma del canone
ALTER TABLE `consensi_moduli`
	DROP INDEX IF EXISTS `azione`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `informativa`,
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `pagina`,
	DROP INDEX IF EXISTS `se_richiesto`,
	ADD KEY `indice` (`id`,`ordine`,`nome`,`id_lingua`,`id_consenso`,`modulo`);

-- | 202611042424

-- consensi_moduli: vincoli nella forma del canone
ALTER TABLE `consensi_moduli`
	ADD CONSTRAINT `consensi_moduli_ibfk_02_nofollow` FOREIGN KEY (`id_consenso`) REFERENCES `consensi` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042425

-- contatti: via i vincoli che cambiano
ALTER TABLE `contatti`
	DROP FOREIGN KEY IF EXISTS `contatti_ibfk_03_nofollow`,
	DROP FOREIGN KEY IF EXISTS `contatti_ibfk_04_nofollow`;

-- | 202611042426

-- contatti: indici nella forma del canone
ALTER TABLE `contatti`
	DROP INDEX IF EXISTS `data_archiviazione`,
	DROP INDEX IF EXISTS `id_account_archiviazione`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `modulo`,
	DROP INDEX IF EXISTS `nome`,
	ADD KEY `data_archiviazione` (`data_archiviazione`),
	ADD KEY `id_account_archiviazione` (`id_account_archiviazione`),
	ADD KEY `indice` (`id`, `id_tipologia`, `nome`, `id_anagrafica`, `id_campagna`, `id_sito`, `modulo`, `timestamp_contatto`),
	ADD KEY `modulo` (`modulo`),
	ADD KEY `nome` (`nome`);

-- | 202611042427

-- contenuti: via i vincoli che cambiano
ALTER TABLE `contenuti`
	DROP FOREIGN KEY IF EXISTS `contenuti_ibfk_02`,
	DROP FOREIGN KEY IF EXISTS `contenuti_ibfk_04`,
	DROP FOREIGN KEY IF EXISTS `contenuti_ibfk_05`,
	DROP FOREIGN KEY IF EXISTS `contenuti_ibfk_06`,
	DROP FOREIGN KEY IF EXISTS `contenuti_ibfk_07`,
	DROP FOREIGN KEY IF EXISTS `contenuti_ibfk_08`,
	DROP FOREIGN KEY IF EXISTS `contenuti_ibfk_09`,
	DROP FOREIGN KEY IF EXISTS `contenuti_ibfk_10`,
	DROP FOREIGN KEY IF EXISTS `contenuti_ibfk_11`,
	DROP FOREIGN KEY IF EXISTS `contenuti_ibfk_12`,
	DROP FOREIGN KEY IF EXISTS `contenuti_ibfk_13`,
	DROP FOREIGN KEY IF EXISTS `contenuti_ibfk_14`,
	DROP FOREIGN KEY IF EXISTS `contenuti_ibfk_15`,
	DROP FOREIGN KEY IF EXISTS `contenuti_ibfk_16`,
	DROP FOREIGN KEY IF EXISTS `contenuti_ibfk_17`,
	DROP FOREIGN KEY IF EXISTS `contenuti_ibfk_18`,
	DROP FOREIGN KEY IF EXISTS `contenuti_ibfk_19`,
	DROP FOREIGN KEY IF EXISTS `contenuti_ibfk_20`,
	DROP FOREIGN KEY IF EXISTS `contenuti_ibfk_21`,
	DROP FOREIGN KEY IF EXISTS `contenuti_ibfk_22`,
	DROP FOREIGN KEY IF EXISTS `contenuti_ibfk_23`,
	DROP FOREIGN KEY IF EXISTS `contenuti_ibfk_24`,
	DROP FOREIGN KEY IF EXISTS `contenuti_ibfk_25`,
	DROP FOREIGN KEY IF EXISTS `contenuti_ibfk_26`,
	DROP FOREIGN KEY IF EXISTS `contenuti_ibfk_27`,
	DROP FOREIGN KEY IF EXISTS `contenuti_ibfk_28`,
	DROP FOREIGN KEY IF EXISTS `contenuti_ibfk_29`;

-- | 202611042428

-- contenuti: indici nella forma del canone
ALTER TABLE `contenuti`
	DROP INDEX IF EXISTS `id_anagrafica`,
	DROP INDEX IF EXISTS `id_annuncio`,
	DROP INDEX IF EXISTS `id_articolo`,
	DROP INDEX IF EXISTS `id_audio`,
	DROP INDEX IF EXISTS `id_banner`,
	DROP INDEX IF EXISTS `id_caratteristica`,
	DROP INDEX IF EXISTS `id_categoria_annunci`,
	DROP INDEX IF EXISTS `id_categoria_notizie`,
	DROP INDEX IF EXISTS `id_categoria_prodotti`,
	DROP INDEX IF EXISTS `id_categoria_progetti`,
	DROP INDEX IF EXISTS `id_categoria_risorse`,
	DROP INDEX IF EXISTS `id_colore`,
	DROP INDEX IF EXISTS `id_edificio`,
	DROP INDEX IF EXISTS `id_file`,
	DROP INDEX IF EXISTS `id_immagine`,
	DROP INDEX IF EXISTS `id_immobile`,
	DROP INDEX IF EXISTS `id_indirizzo`,
	DROP INDEX IF EXISTS `id_mailing`,
	DROP INDEX IF EXISTS `id_marchio`,
	DROP INDEX IF EXISTS `id_notizia`,
	DROP INDEX IF EXISTS `id_pagina`,
	DROP INDEX IF EXISTS `id_popup`,
	DROP INDEX IF EXISTS `id_prodotto`,
	DROP INDEX IF EXISTS `id_progetto`,
	DROP INDEX IF EXISTS `id_risorsa`,
	DROP INDEX IF EXISTS `id_template`,
	DROP INDEX IF EXISTS `id_video`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `unica_annuncio`,
	DROP INDEX IF EXISTS `unica_categoria_annunci`,
	DROP INDEX IF EXISTS `unica_categoria_marchi`,
	DROP INDEX IF EXISTS `unica_categoria_progetti`,
	DROP INDEX IF EXISTS `unica_edificio`,
	DROP INDEX IF EXISTS `unica_immobile`,
	DROP INDEX IF EXISTS `unica_mailing`,
	DROP INDEX IF EXISTS `unica_progetto`,
	DROP INDEX IF EXISTS `unica_vano`,
	ADD KEY `indice` (`id`,`id_lingua`,`title`,`h1`),
	ADD UNIQUE KEY `unica_annuncio` (`id_annuncio`,`id_lingua`),
	ADD UNIQUE KEY `unica_categoria_annunci` (`id_categoria_annunci`,`id_lingua`),
	ADD UNIQUE KEY `unica_categoria_marchi` (`id_categoria_marchi`,`id_lingua`),
	ADD UNIQUE KEY `unica_categoria_progetti` (`id_categoria_progetti`,`id_lingua`),
	ADD UNIQUE KEY `unica_edificio` (`id_edificio`,`id_lingua`),
	ADD UNIQUE KEY `unica_immobile` (`id_immobile`,`id_lingua`),
	ADD UNIQUE KEY `unica_mailing` (`id_mailing`,`id_lingua`),
	ADD UNIQUE KEY `unica_progetto` (`id_progetto`,`id_lingua`),
	ADD UNIQUE KEY `unica_vano` (`id_vano`,`id_lingua`);

-- | 202611042429

-- contenuti: vincoli nella forma del canone
ALTER TABLE `contenuti`
	ADD CONSTRAINT `contenuti_ibfk_02` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `contenuti_ibfk_04` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `contenuti_ibfk_05` FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `contenuti_ibfk_06` FOREIGN KEY (`id_caratteristica`) REFERENCES `caratteristiche` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `contenuti_ibfk_07` FOREIGN KEY (`id_marchio`) REFERENCES `marchi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `contenuti_ibfk_08` FOREIGN KEY (`id_categoria_marchi`) REFERENCES `categorie_marchi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `contenuti_ibfk_09` FOREIGN KEY (`id_file`) REFERENCES `file` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `contenuti_ibfk_10` FOREIGN KEY (`id_immagine`) REFERENCES `immagini` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `contenuti_ibfk_11` FOREIGN KEY (`id_video`) REFERENCES `video` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `contenuti_ibfk_12` FOREIGN KEY (`id_audio`) REFERENCES `audio` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `contenuti_ibfk_13` FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `contenuti_ibfk_14` FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `contenuti_ibfk_15` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `contenuti_ibfk_16` FOREIGN KEY (`id_popup`) REFERENCES `popup` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `contenuti_ibfk_17` FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `contenuti_ibfk_18` FOREIGN KEY (`id_edificio`) REFERENCES `edifici` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `contenuti_ibfk_19` FOREIGN KEY (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `contenuti_ibfk_20` FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `contenuti_ibfk_21` FOREIGN KEY (`id_annuncio`) REFERENCES `annunci` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `contenuti_ibfk_22` FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `contenuti_ibfk_23` FOREIGN KEY (`id_categoria_annunci`) REFERENCES `categorie_annunci` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `contenuti_ibfk_24` FOREIGN KEY (`id_template`) REFERENCES `template` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `contenuti_ibfk_25` FOREIGN KEY (`id_mailing`) REFERENCES `mailing` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `contenuti_ibfk_26` FOREIGN KEY (`id_colore`) REFERENCES `colori` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `contenuti_ibfk_27` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `contenuti_ibfk_28` FOREIGN KEY (`id_categoria_progetti`) REFERENCES `categorie_progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `contenuti_ibfk_29` FOREIGN KEY (`id_banner`) REFERENCES `banner` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042430

-- continenti: via i vincoli che cambiano
ALTER TABLE `continenti`
	DROP FOREIGN KEY IF EXISTS `continenti_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `continenti_ibfk_99_nofollow`;

-- | 202611042431

-- contratti: via i vincoli che cambiano
ALTER TABLE `contratti`
	DROP FOREIGN KEY IF EXISTS `contratti_ibfk_05_nofollow`,
	DROP FOREIGN KEY IF EXISTS `contratti_ibfk_07_nofollow`;

-- | 202611042432

-- contratti: indici nella forma del canone
ALTER TABLE `contratti`
	DROP INDEX IF EXISTS `data_archiviazione`,
	DROP INDEX IF EXISTS `id_account_archiviazione`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `nome`,
	ADD KEY `data_archiviazione` (`data_archiviazione`),
	ADD KEY `id_account_archiviazione` (`id_account_archiviazione`),
	ADD KEY `indice` ( `id`, `id_tipologia`, `codice`, `nome`, `id_immobile`, `id_progetto`, `data_archiviazione` ),
	ADD KEY `nome` (`nome`);

-- | 202611042433

-- conversazioni: via i vincoli che cambiano
ALTER TABLE `conversazioni`
	DROP FOREIGN KEY IF EXISTS `conversazioni_ibfk_02_nofollow`;

-- | 202611042434

-- conversazioni: indici nella forma del canone
ALTER TABLE `conversazioni`
	DROP INDEX IF EXISTS `codice`,
	DROP INDEX IF EXISTS `indice`,
	ADD UNIQUE KEY `codice` ( `codice` ),
	ADD KEY `indice` ( `id`, `codice`, `nome`, `id_annuncio`, `timestamp_apertura`, `timestamp_chiusura` );

-- | 202611042435

-- conversazioni_account: via i vincoli che cambiano
ALTER TABLE `conversazioni_account`
	DROP FOREIGN KEY IF EXISTS `conversazioni_account_ibfk_03_nofollow`;

-- | 202611042436

-- conversazioni_account: indici nella forma del canone
ALTER TABLE `conversazioni_account`
	DROP INDEX IF EXISTS `id_ruolo`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	ADD KEY `id_ruolo` (`id_ruolo`),
	ADD KEY `indice` (`id`,`ordine`,`id_conversazione`,`id_account`,`id_ruolo`,`timestamp_lettura`,`timestamp_entrata`,`timestamp_uscita`),
	ADD KEY `ordine` (`ordine`);

-- | 202611042437

-- conversazioni_account: vincoli nella forma del canone
ALTER TABLE `conversazioni_account`
	ADD CONSTRAINT `conversazioni_account_ibfk_03_nofollow` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_conversazioni` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042438

-- conversazioni_categorie: via i vincoli che cambiano
ALTER TABLE `conversazioni_categorie`
	DROP FOREIGN KEY IF EXISTS `conversazioni_categorie_ibfk_01_nofollow`,
	DROP FOREIGN KEY IF EXISTS `conversazioni_categorie_ibfk_02_nofollow`,
	DROP FOREIGN KEY IF EXISTS `conversazioni_categorie_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `conversazioni_categorie_ibfk_99_nofollow`;

-- | 202611042439

-- conversazioni_categorie: indici nella forma del canone
ALTER TABLE `conversazioni_categorie`
	DROP INDEX IF EXISTS `id_account_aggiornamento`,
	DROP INDEX IF EXISTS `id_account_inserimento`,
	DROP INDEX IF EXISTS `id_categoria`,
	DROP INDEX IF EXISTS `id_conversazione`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_categoria` (`id_categoria`),
	ADD KEY `id_conversazione` (`id_conversazione`),
	ADD KEY `indice` (`id`,`ordine`,`id_conversazione`,`id_categoria`),
	ADD KEY `ordine` (`ordine`);

-- | 202611042440

-- conversazioni_categorie: vincoli nella forma del canone
ALTER TABLE `conversazioni_categorie`
	ADD CONSTRAINT `conversazioni_categorie_ibfk_01_nofollow` FOREIGN KEY (`id_conversazione`) REFERENCES `conversazioni` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `conversazioni_categorie_ibfk_02_nofollow` FOREIGN KEY (`id_categoria`) REFERENCES `categorie_conversazioni` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `conversazioni_categorie_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `conversazioni_categorie_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042441

-- corrispondenza: via i vincoli che cambiano
ALTER TABLE `corrispondenza`
	DROP FOREIGN KEY IF EXISTS `corrispondenza_ibfk_02_nofollow`,
	DROP FOREIGN KEY IF EXISTS `corrispondenza_ibfk_03_nofollow`,
	DROP FOREIGN KEY IF EXISTS `corrispondenza_ibfk_04_nofollow`,
	DROP FOREIGN KEY IF EXISTS `corrispondenza_ibfk_05_nofollow`,
	DROP FOREIGN KEY IF EXISTS `corrispondenza_ibfk_06_nofollow`,
	DROP FOREIGN KEY IF EXISTS `corrispondenza_ibfk_07_nofollow`,
	DROP FOREIGN KEY IF EXISTS `corrispondenza_ibfk_08_nofollow`,
	DROP FOREIGN KEY IF EXISTS `corrispondenza_ibfk_09_nofollow`,
	DROP FOREIGN KEY IF EXISTS `corrispondenza_ibfk_10_nofollow`,
	DROP FOREIGN KEY IF EXISTS `corrispondenza_ibfk_11_nofollow`;

-- | 202611042442

-- corrispondenza: indici nella forma del canone
ALTER TABLE `corrispondenza`
	DROP INDEX IF EXISTS `destinatario_id_anagrafica`,
	DROP INDEX IF EXISTS `destinatario_id_comune`,
	DROP INDEX IF EXISTS `destinatario_id_provincia`,
	DROP INDEX IF EXISTS `destinatario_id_stato`,
	DROP INDEX IF EXISTS `destinatario_id_tipologia_anagrafica`,
	DROP INDEX IF EXISTS `id_distinta_spedizione`,
	DROP INDEX IF EXISTS `id_udm_peso`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `unica`,
	ADD KEY `destinatario_id_anagrafica` (`destinatario_id_anagrafica`),
	ADD KEY `destinatario_id_comune` (`destinatario_id_comune`),
	ADD KEY `destinatario_id_provincia` (`destinatario_id_provincia`),
	ADD KEY `destinatario_id_stato` (`destinatario_id_stato`),
	ADD KEY `destinatario_id_tipologia_anagrafica` (`destinatario_id_tipologia_anagrafica`),
	ADD KEY `id_distinta_spedizione` (`id_distinta_spedizione`),
	ADD KEY `id_udm_peso` (`id_udm_peso`),
	ADD KEY `indice` (`id`,`id_tipologia`,`codice`,`nome`);

-- | 202611042443

-- corrispondenza: vincoli nella forma del canone
ALTER TABLE `corrispondenza`
	ADD CONSTRAINT `corrispondenza_ibfk_02_nofollow` FOREIGN KEY (`id_mittente`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `corrispondenza_ibfk_03_nofollow` FOREIGN KEY (`id_organizzazione_mittente`) REFERENCES `organizzazioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `corrispondenza_ibfk_04_nofollow` FOREIGN KEY (`id_commesso`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `corrispondenza_ibfk_05_nofollow` FOREIGN KEY (`destinatario_id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `corrispondenza_ibfk_06_nofollow` FOREIGN KEY (`destinatario_id_tipologia_anagrafica`) REFERENCES `tipologie_anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `corrispondenza_ibfk_07_nofollow` FOREIGN KEY (`destinatario_id_comune`) REFERENCES `comuni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `corrispondenza_ibfk_08_nofollow` FOREIGN KEY (`destinatario_id_provincia`) REFERENCES `provincie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `corrispondenza_ibfk_09_nofollow` FOREIGN KEY (`destinatario_id_stato`) REFERENCES `stati` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `corrispondenza_ibfk_10_nofollow` FOREIGN KEY (`id_formato`) REFERENCES `formati_tipologie_corrispondenza` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `corrispondenza_ibfk_11_nofollow` FOREIGN KEY (`id_peso`) REFERENCES `pesi_tipologie_corrispondenza` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042444

-- costi_contratti: indici nella forma del canone
ALTER TABLE `costi_contratti`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `unica`,
	DROP INDEX IF EXISTS `unico`,
	ADD KEY `indice` (`id`,`id_tipologia`,`id_contratto`,`costo_orario`),
	ADD UNIQUE KEY `unica` (`id_contratto`,`id_tipologia`);

-- | 202611042445

-- coupon: via i vincoli che cambiano
ALTER TABLE `coupon`
	DROP FOREIGN KEY IF EXISTS `coupon_ibfk_02_nofollow`,
	DROP FOREIGN KEY IF EXISTS `coupon_ibfk_03_nofollow`;

-- | 202611042446

-- coupon: indici nella forma del canone
ALTER TABLE `coupon`
	DROP INDEX IF EXISTS `causale_id_contratto`,
	DROP INDEX IF EXISTS `causale_id_rinnovo`,
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `causale_id_contratto` (`causale_id_contratto`),
	ADD KEY `causale_id_rinnovo` (`causale_id_rinnovo`),
	ADD KEY `indice` (`id`,`codice`,`nome`,`id_anagrafica`,`sconto_percentuale`,`sconto_fisso`,`se_multiuso`,`se_globale`,`se_vincolato`,`timestamp_inizio`,`timestamp_fine`);

-- | 202611042447

-- coupon: vincoli nella forma del canone
ALTER TABLE `coupon`
	ADD CONSTRAINT `coupon_ibfk_02_nofollow` FOREIGN KEY (`causale_id_contratto`) REFERENCES `contratti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `coupon_ibfk_03_nofollow` FOREIGN KEY (`causale_id_rinnovo`) REFERENCES `rinnovi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042448

-- coupon_articoli: via i vincoli che cambiano
ALTER TABLE `coupon_articoli`
	DROP FOREIGN KEY IF EXISTS `coupon_articoli_ibfk_01`,
	DROP FOREIGN KEY IF EXISTS `coupon_articoli_ibfk_01_nofollow`;

-- | 202611042449

-- coupon_articoli: indici nella forma del canone
ALTER TABLE `coupon_articoli`
	DROP INDEX IF EXISTS `gruppo_alternative`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	ADD KEY `gruppo_alternative` (`gruppo_alternative`),
	ADD KEY `indice` (`id`,`ordine`,`id_coupon`,`id_articolo`,`gruppo_alternative`),
	ADD KEY `ordine` (`ordine`);

-- | 202611042450

-- coupon_articoli: vincoli nella forma del canone
ALTER TABLE `coupon_articoli`
	ADD CONSTRAINT `coupon_articoli_ibfk_01` FOREIGN KEY (`id_coupon`) REFERENCES `coupon` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042451

-- coupon_categorie_prodotti: indici nella forma del canone
ALTER TABLE `coupon_categorie_prodotti`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	ADD KEY `indice` (`id`,`ordine`,`id_coupon`,`id_categoria`),
	ADD KEY `ordine` (`ordine`);

-- | 202611042452

-- coupon_listini: indici nella forma del canone
ALTER TABLE `coupon_listini`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	ADD KEY `indice` (`id`,`ordine`,`id_coupon`,`id_listino`),
	ADD KEY `ordine` (`ordine`);

-- | 202611042453

-- coupon_marchi: indici nella forma del canone
ALTER TABLE `coupon_marchi`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	ADD KEY `indice` (`id`,`ordine`,`id_coupon`,`id_marchio`),
	ADD KEY `ordine` (`ordine`);

-- | 202611042454

-- coupon_prodotti: indici nella forma del canone
ALTER TABLE `coupon_prodotti`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	ADD KEY `indice` (`id`,`ordine`,`id_coupon`,`id_prodotto`),
	ADD KEY `ordine` (`ordine`);

-- | 202611042455

-- crediti: via i vincoli che cambiano
ALTER TABLE `crediti`
	DROP FOREIGN KEY IF EXISTS `crediti_ibfk_01_nofollow`,
	DROP FOREIGN KEY IF EXISTS `crediti_ibfk_02_nofollow`,
	DROP FOREIGN KEY IF EXISTS `crediti_ibfk_03_nofollow`,
	DROP FOREIGN KEY IF EXISTS `crediti_ibfk_04_nofollow`,
	DROP FOREIGN KEY IF EXISTS `crediti_ibfk_05_nofollow`,
	DROP FOREIGN KEY IF EXISTS `crediti_ibfk_06_nofollow`,
	DROP FOREIGN KEY IF EXISTS `crediti_ibfk_07_nofollow`,
	DROP FOREIGN KEY IF EXISTS `crediti_ibfk_08_nofollow`;

-- | 202611042456

-- crediti: indici nella forma del canone
ALTER TABLE `crediti`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `quantita`,
	DROP INDEX IF EXISTS `unica`,
	ADD KEY `indice` (`id`,`nome`,`id_pianificazione`,`id_documenti_articolo`,`id_account_emittente`,`id_account_destinatario`,`id_mastro_provenienza`,`id_mastro_destinazione`,`quantita`,`data`);

-- | 202611042457

-- crediti: vincoli nella forma del canone
ALTER TABLE `crediti`
	ADD CONSTRAINT `crediti_ibfk_01_nofollow` FOREIGN KEY (`id_pianificazione`) REFERENCES `pianificazioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `crediti_ibfk_02_nofollow` FOREIGN KEY (`id_documenti_articolo`) REFERENCES `documenti_articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `crediti_ibfk_03_nofollow` FOREIGN KEY (`id_account_emittente`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `crediti_ibfk_04_nofollow` FOREIGN KEY (`id_account_destinatario`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `crediti_ibfk_05_nofollow` FOREIGN KEY (`id_mastro_provenienza`) REFERENCES `mastri` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `crediti_ibfk_06_nofollow` FOREIGN KEY (`id_mastro_destinazione`) REFERENCES `mastri` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042458

-- dichiarazioni_intento: indici nella forma del canone
ALTER TABLE `dichiarazioni_intento`
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `indice` (`id`,`id_anagrafica`,`protocollo`,`data_protocollo`,`anno`,`data_inizio`,`data_fine`,`importo`);

-- | 202611042459

-- disponibilita: via i vincoli che cambiano
ALTER TABLE `disponibilita`
	DROP FOREIGN KEY IF EXISTS `disponibilita_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `disponibilita_ibfk_99_nofollow`;

-- | 202611042460

-- disponibilita: indici nella forma del canone
ALTER TABLE `disponibilita`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `unica`,
	DROP INDEX IF EXISTS `unico`,
	ADD KEY `indice` (`id`,`nome`,`se_catalogo`,`se_immobili`),
	ADD UNIQUE KEY `unica` (`nome`);

-- | 202611042461

-- distinta: via i vincoli che cambiano
ALTER TABLE `distinta`
	DROP FOREIGN KEY IF EXISTS `distinta_ibfk_02_nofollow`;

-- | 202611042462

-- distinta: indici nella forma del canone
ALTER TABLE `distinta`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	ADD KEY `indice` (`id`,`ordine`,`id_articolo`,`id_componente`,`quantita`),
	ADD KEY `ordine` (`ordine`);

-- | 202611042463

-- distinta: vincoli nella forma del canone
ALTER TABLE `distinta`
	ADD CONSTRAINT `distinta_ibfk_02_nofollow` FOREIGN KEY (`id_componente`) REFERENCES `articoli` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042464

-- documenti: via i vincoli che cambiano
ALTER TABLE `documenti`
	DROP FOREIGN KEY IF EXISTS `documenti_ibfk_03_nofollow`,
	DROP FOREIGN KEY IF EXISTS `documenti_ibfk_12_nofollow`;

-- | 202611042465

-- documenti: indici nella forma del canone
ALTER TABLE `documenti`
	DROP INDEX IF EXISTS `data_archiviazione`,
	DROP INDEX IF EXISTS `id_account_archiviazione`,
	DROP INDEX IF EXISTS `id_carrelli_articoli`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `nome`,
	ADD KEY `data_archiviazione` (`data_archiviazione`),
	ADD KEY `id_account_archiviazione` (`id_account_archiviazione`),
	ADD KEY `id_carrelli_articoli` (`id_carrelli_articoli`),
	ADD KEY `indice` (`id`,`id_tipologia`,`numero`,`sezionale`,`data`,`id_emittente`,`id_sede_emittente`,`id_destinatario`,`id_sede_destinatario`,`id_coupon`,`id_carrelli_articoli`),
	ADD KEY `nome` (`nome`);

-- | 202611042466

-- documenti: vincoli nella forma del canone
ALTER TABLE `documenti`
	ADD CONSTRAINT `documenti_ibfk_03_nofollow` FOREIGN KEY (`id_sede_emittente`) REFERENCES `anagrafica_indirizzi` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042467

-- documenti_articoli: via i vincoli che cambiano
ALTER TABLE `documenti_articoli`
	DROP FOREIGN KEY IF EXISTS `documenti_articoli_ibfk_03_nofollow`,
	DROP FOREIGN KEY IF EXISTS `documenti_articoli_ibfk_22_nofollow`,
	DROP FOREIGN KEY IF EXISTS `documenti_articoli_ibfk_23_nofollow`;

-- | 202611042468

-- documenti_articoli: indici nella forma del canone
ALTER TABLE `documenti_articoli`
	DROP INDEX IF EXISTS `id_carrello`,
	DROP INDEX IF EXISTS `id_immobile`,
	DROP INDEX IF EXISTS `id_lotto`,
	DROP INDEX IF EXISTS `id_packing_list`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	DROP INDEX IF EXISTS `unico_codice`,
	ADD KEY `id_carrello` (`id_carrello`),
	ADD KEY `id_immobile` (`id_immobile`),
	ADD KEY `id_lotto` (`id_lotto`),
	ADD KEY `id_packing_list` (`id_packing_list`),
	ADD KEY `indice` (`id`,`id_genitore`,`id_tipologia_documento`,`ordine`,`id_documento`,`data`,`id_emittente`,`id_destinatario`,`id_reparto`,`id_progetto`,`id_todo`,`id_attivita`,`id_articolo`,`id_mastro_provenienza`,`id_mastro_destinazione`,`id_carrello`),
	ADD KEY `ordine` (`ordine`);

-- | 202611042469

-- documenti_articoli: vincoli nella forma del canone
ALTER TABLE `documenti_articoli`
	ADD CONSTRAINT `documenti_articoli_ibfk_03_nofollow` FOREIGN KEY (`id_documento`) REFERENCES `documenti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `documenti_articoli_ibfk_22_nofollow` FOREIGN KEY (`id_missione`) REFERENCES `documenti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `documenti_articoli_ibfk_23_nofollow` FOREIGN KEY (`id_packing_list`) REFERENCES `documenti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042470

-- documenti_casse_previdenziali: indici nella forma del canone
ALTER TABLE `documenti_casse_previdenziali`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	DROP INDEX IF EXISTS `unica`,
	ADD KEY `indice` (`id`,`ordine`,`id_documento`,`id_cassa_previdenziale`,`aliquota`,`imponibile`,`importo`,`id_iva`,`se_ritenuta`),
	ADD KEY `ordine` (`ordine`),
	ADD UNIQUE KEY `unica` (`id_documento`,`id_cassa_previdenziale`,`id_iva`);

-- | 202611042471

-- documenti_ritenute: indici nella forma del canone
ALTER TABLE `documenti_ritenute`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	ADD KEY `indice` (`id`,`ordine`,`id_documento`,`id_ritenuta`,`aliquota`,`causale_pagamento`,`importo`),
	ADD KEY `ordine` (`ordine`);

-- | 202611042472

-- edifici: via i vincoli che cambiano
ALTER TABLE `edifici`
	DROP FOREIGN KEY IF EXISTS `edifici_ibfk_01_nofollow`,
	DROP FOREIGN KEY IF EXISTS `edifici_ibfk_02_nofollow`,
	DROP FOREIGN KEY IF EXISTS `edifici_ibfk_03_nofollow`;

-- | 202611042473

-- edifici: indici nella forma del canone
ALTER TABLE `edifici`
	DROP INDEX IF EXISTS `id_genitore`,
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `indice` (`id`, `id_genitore`, `id_tipologia`, `codice`, `nome`, `id_indirizzo`);

-- | 202611042474

-- edifici: vincoli nella forma del canone
ALTER TABLE `edifici`
	ADD CONSTRAINT `edifici_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `edifici` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `edifici_ibfk_02_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_edifici` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `edifici_ibfk_03_nofollow` FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042475

-- edifici_anagrafica: via i vincoli che cambiano
ALTER TABLE `edifici_anagrafica`
	DROP FOREIGN KEY IF EXISTS `edifici_anagrafica_ibfk_01`,
	DROP FOREIGN KEY IF EXISTS `edifici_anagrafica_ibfk_02_nofollow`,
	DROP FOREIGN KEY IF EXISTS `edifici_anagrafica_ibfk_03_nofollow`,
	DROP FOREIGN KEY IF EXISTS `edifici_anagrafica_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `edifici_anagrafica_ibfk_99_nofollow`;

-- | 202611042476

-- edifici_anagrafica: indici nella forma del canone
ALTER TABLE `edifici_anagrafica`
	DROP INDEX IF EXISTS `id_account_aggiornamento`,
	DROP INDEX IF EXISTS `id_account_inserimento`,
	DROP INDEX IF EXISTS `id_anagrafica`,
	DROP INDEX IF EXISTS `id_edificio`,
	DROP INDEX IF EXISTS `id_ruolo`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_anagrafica` (`id_anagrafica`),
	ADD KEY `id_edificio` (`id_edificio`),
	ADD KEY `id_ruolo` (`id_ruolo`),
	ADD KEY `indice` (`id`,`ordine`,`id_edificio`,`id_anagrafica`,`id_ruolo`),
	ADD KEY `ordine` (`ordine`);

-- | 202611042477

-- edifici_anagrafica: vincoli nella forma del canone
ALTER TABLE `edifici_anagrafica`
	ADD CONSTRAINT `edifici_anagrafica_ibfk_01` FOREIGN KEY (`id_edificio`) REFERENCES `edifici` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `edifici_anagrafica_ibfk_02_nofollow` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `edifici_anagrafica_ibfk_03_nofollow` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `edifici_anagrafica_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `edifici_anagrafica_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042478

-- edifici_caratteristiche: indici nella forma del canone
ALTER TABLE `edifici_caratteristiche`
	DROP INDEX IF EXISTS `id_lingua`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `unica`,
	ADD KEY `id_lingua` (`id_lingua`),
	ADD KEY `indice` (`id`,`ordine`,`id_edificio`,`id_caratteristica`,`id_lingua`,`se_assente`),
	ADD UNIQUE KEY `unica` (`id_edificio`,`id_caratteristica`,`id_lingua`);

-- | 202611042479

-- file: via i vincoli che cambiano
ALTER TABLE `file`
	DROP FOREIGN KEY IF EXISTS `file_ibfk_01`,
	DROP FOREIGN KEY IF EXISTS `file_ibfk_01_nofollow`,
	DROP FOREIGN KEY IF EXISTS `file_ibfk_02`,
	DROP FOREIGN KEY IF EXISTS `file_ibfk_03`,
	DROP FOREIGN KEY IF EXISTS `file_ibfk_04`,
	DROP FOREIGN KEY IF EXISTS `file_ibfk_05`,
	DROP FOREIGN KEY IF EXISTS `file_ibfk_05_nofollow`,
	DROP FOREIGN KEY IF EXISTS `file_ibfk_06`,
	DROP FOREIGN KEY IF EXISTS `file_ibfk_07`,
	DROP FOREIGN KEY IF EXISTS `file_ibfk_08`,
	DROP FOREIGN KEY IF EXISTS `file_ibfk_09`,
	DROP FOREIGN KEY IF EXISTS `file_ibfk_10`,
	DROP FOREIGN KEY IF EXISTS `file_ibfk_11`,
	DROP FOREIGN KEY IF EXISTS `file_ibfk_12`,
	DROP FOREIGN KEY IF EXISTS `file_ibfk_13`,
	DROP FOREIGN KEY IF EXISTS `file_ibfk_14`,
	DROP FOREIGN KEY IF EXISTS `file_ibfk_15`,
	DROP FOREIGN KEY IF EXISTS `file_ibfk_16`,
	DROP FOREIGN KEY IF EXISTS `file_ibfk_16_nofollow`,
	DROP FOREIGN KEY IF EXISTS `file_ibfk_17`,
	DROP FOREIGN KEY IF EXISTS `file_ibfk_18`,
	DROP FOREIGN KEY IF EXISTS `file_ibfk_19`,
	DROP FOREIGN KEY IF EXISTS `file_ibfk_20`,
	DROP FOREIGN KEY IF EXISTS `file_ibfk_21`,
	DROP FOREIGN KEY IF EXISTS `file_ibfk_22`,
	DROP FOREIGN KEY IF EXISTS `file_ibfk_23`,
	DROP FOREIGN KEY IF EXISTS `file_ibfk_24`,
	DROP FOREIGN KEY IF EXISTS `file_ibfk_25`,
	DROP FOREIGN KEY IF EXISTS `file_ibfk_26`,
	DROP FOREIGN KEY IF EXISTS `file_ibfk_27`,
	DROP FOREIGN KEY IF EXISTS `file_ibfk_28`,
	DROP FOREIGN KEY IF EXISTS `file_ibfk_29`,
	DROP FOREIGN KEY IF EXISTS `file_ibfk_30`,
	DROP FOREIGN KEY IF EXISTS `file_ibfk_31`,
	DROP FOREIGN KEY IF EXISTS `file_ibfk_32`,
	DROP FOREIGN KEY IF EXISTS `file_ibfk_33`,
	DROP FOREIGN KEY IF EXISTS `file_ibfk_34`,
	DROP FOREIGN KEY IF EXISTS `file_ibfk_35`,
	DROP FOREIGN KEY IF EXISTS `file_ibfk_36`,
	DROP FOREIGN KEY IF EXISTS `file_ibfk_37_nofollow`;

-- | 202611042480

-- file: indici nella forma del canone
ALTER TABLE `file`
	DROP INDEX IF EXISTS `id_anagrafica`,
	DROP INDEX IF EXISTS `id_anagrafica_certificazioni`,
	DROP INDEX IF EXISTS `id_annuncio`,
	DROP INDEX IF EXISTS `id_articolo`,
	DROP INDEX IF EXISTS `id_attivita`,
	DROP INDEX IF EXISTS `id_categoria_annunci`,
	DROP INDEX IF EXISTS `id_categoria_notizie`,
	DROP INDEX IF EXISTS `id_categoria_prodotti`,
	DROP INDEX IF EXISTS `id_categoria_progetti`,
	DROP INDEX IF EXISTS `id_categoria_risorse`,
	DROP INDEX IF EXISTS `id_contratto`,
	DROP INDEX IF EXISTS `id_documento`,
	DROP INDEX IF EXISTS `id_edificio`,
	DROP INDEX IF EXISTS `id_immobile`,
	DROP INDEX IF EXISTS `id_indirizzo`,
	DROP INDEX IF EXISTS `id_licenza`,
	DROP INDEX IF EXISTS `id_mail_out`,
	DROP INDEX IF EXISTS `id_mail_sent`,
	DROP INDEX IF EXISTS `id_mailing`,
	DROP INDEX IF EXISTS `id_marchio`,
	DROP INDEX IF EXISTS `id_notizia`,
	DROP INDEX IF EXISTS `id_pagina`,
	DROP INDEX IF EXISTS `id_prodotto`,
	DROP INDEX IF EXISTS `id_progetto`,
	DROP INDEX IF EXISTS `id_rinnovo`,
	DROP INDEX IF EXISTS `id_risorsa`,
	DROP INDEX IF EXISTS `id_template`,
	DROP INDEX IF EXISTS `id_todo`,
	DROP INDEX IF EXISTS `id_valutazione`,
	DROP INDEX IF EXISTS `id_valutazione_certificazioni`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	DROP INDEX IF EXISTS `unica_anagrafica`,
	DROP INDEX IF EXISTS `unica_anagrafica_certificazioni`,
	DROP INDEX IF EXISTS `unica_annuncio`,
	DROP INDEX IF EXISTS `unica_articolo`,
	DROP INDEX IF EXISTS `unica_attivita`,
	DROP INDEX IF EXISTS `unica_audio`,
	DROP INDEX IF EXISTS `unica_categoria_annunci`,
	DROP INDEX IF EXISTS `unica_categoria_marchi`,
	DROP INDEX IF EXISTS `unica_categoria_notizie`,
	DROP INDEX IF EXISTS `unica_categoria_prodotti`,
	DROP INDEX IF EXISTS `unica_categoria_progetti`,
	DROP INDEX IF EXISTS `unica_categoria_risorse`,
	DROP INDEX IF EXISTS `unica_contratto`,
	DROP INDEX IF EXISTS `unica_documento`,
	DROP INDEX IF EXISTS `unica_edificio`,
	DROP INDEX IF EXISTS `unica_immagine`,
	DROP INDEX IF EXISTS `unica_immobile`,
	DROP INDEX IF EXISTS `unica_indirizzo`,
	DROP INDEX IF EXISTS `unica_licenza`,
	DROP INDEX IF EXISTS `unica_mail_out`,
	DROP INDEX IF EXISTS `unica_mail_sent`,
	DROP INDEX IF EXISTS `unica_mailing`,
	DROP INDEX IF EXISTS `unica_marchio`,
	DROP INDEX IF EXISTS `unica_notizia`,
	DROP INDEX IF EXISTS `unica_pagina`,
	DROP INDEX IF EXISTS `unica_prodotto`,
	DROP INDEX IF EXISTS `unica_progetto`,
	DROP INDEX IF EXISTS `unica_rinnovo`,
	DROP INDEX IF EXISTS `unica_risorsa`,
	DROP INDEX IF EXISTS `unica_template`,
	DROP INDEX IF EXISTS `unica_todo`,
	DROP INDEX IF EXISTS `unica_valutazione`,
	DROP INDEX IF EXISTS `unica_valutazione_certificazioni`,
	DROP INDEX IF EXISTS `unica_vano`,
	DROP INDEX IF EXISTS `unica_video`,
	ADD KEY `indice` (`id`,`ordine`,`nome`,`id_lingua`,`id_ruolo`,`path`,`url`),
	ADD KEY `ordine` (`ordine`),
	ADD UNIQUE KEY `unica_anagrafica` (`id_anagrafica`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_anagrafica_certificazioni` (`id_anagrafica_certificazioni`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_annuncio` (`id_annuncio`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_articolo` (`id_articolo`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_attivita` (`id_attivita`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_audio` (`id_audio`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_categoria_annunci` (`id_categoria_annunci`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_categoria_marchi` (`id_categoria_marchi`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_categoria_notizie` (`id_categoria_notizie`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_categoria_prodotti` (`id_categoria_prodotti`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_categoria_progetti` (`id_categoria_progetti`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_categoria_risorse` (`id_categoria_risorse`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_contratto` (`id_contratto`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_documento` (`id_documento`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_edificio` (`id_edificio`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_immagine` (`id_immagine`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_immobile` (`id_immobile`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_indirizzo` (`id_indirizzo`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_licenza` (`id_licenza`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_mail_out` (`id_mail_out`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_mail_sent` (`id_mail_sent`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_mailing` (`id_mailing`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_marchio` (`id_marchio`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_notizia` (`id_notizia`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_pagina` (`id_pagina`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_prodotto` (`id_prodotto`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_progetto` (`id_progetto`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_rinnovo` (`id_rinnovo`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_risorsa` (`id_risorsa`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_template` (`id_template`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_todo` (`id_todo`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_valutazione` (`id_valutazione`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_valutazione_certificazioni` (`id_valutazione_certificazioni`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_vano` (`id_vano`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_video` (`id_video`,`id_ruolo`,`id_lingua`,`path`);

-- | 202611042481

-- file: vincoli nella forma del canone
ALTER TABLE `file`
	ADD CONSTRAINT `file_ibfk_01` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `file_ibfk_02` FOREIGN KEY (`id_annuncio`) REFERENCES `annunci` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `file_ibfk_03` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `file_ibfk_04` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `file_ibfk_05_nofollow` FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `file_ibfk_06` FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `file_ibfk_07` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `file_ibfk_08` FOREIGN KEY (`id_contratto`) REFERENCES `contratti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `file_ibfk_09` FOREIGN KEY (`id_todo`) REFERENCES `todo` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `file_ibfk_10` FOREIGN KEY (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `file_ibfk_11` FOREIGN KEY (`id_mailing`) REFERENCES `mailing` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `file_ibfk_12` FOREIGN KEY (`id_documento`) REFERENCES `documenti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `file_ibfk_13` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `file_ibfk_14` FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `file_ibfk_15` FOREIGN KEY (`id_marchio`) REFERENCES `marchi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `file_ibfk_16` FOREIGN KEY (`id_categoria_marchi`) REFERENCES `categorie_marchi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `file_ibfk_17` FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `file_ibfk_18` FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `file_ibfk_19` FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `file_ibfk_20` FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `file_ibfk_21` FOREIGN KEY (`id_categoria_annunci`) REFERENCES `categorie_annunci` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `file_ibfk_22` FOREIGN KEY (`id_categoria_progetti`) REFERENCES `categorie_progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `file_ibfk_23` FOREIGN KEY (`id_edificio`) REFERENCES `edifici` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `file_ibfk_24` FOREIGN KEY (`id_valutazione`) REFERENCES `valutazioni` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `file_ibfk_25` FOREIGN KEY (`id_licenza`) REFERENCES `licenze` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `file_ibfk_26` FOREIGN KEY (`id_anagrafica_certificazioni`) REFERENCES `anagrafica_certificazioni` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `file_ibfk_27` FOREIGN KEY (`id_template`) REFERENCES `template` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `file_ibfk_28` FOREIGN KEY (`id_rinnovo`) REFERENCES `rinnovi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `file_ibfk_29` FOREIGN KEY (`id_valutazione_certificazioni`) REFERENCES `valutazioni_certificazioni` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `file_ibfk_30` FOREIGN KEY (`id_mail_out`) REFERENCES `mail_out` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `file_ibfk_31` FOREIGN KEY (`id_mail_sent`) REFERENCES `mail_sent` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `file_ibfk_32` FOREIGN KEY (`id_attivita`) REFERENCES `attivita` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `file_ibfk_33` FOREIGN KEY (`id_audio`) REFERENCES `audio` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `file_ibfk_34` FOREIGN KEY (`id_video`) REFERENCES `video` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `file_ibfk_35` FOREIGN KEY (`id_immagine`) REFERENCES `immagini` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `file_ibfk_36` FOREIGN KEY (`id_vano`) REFERENCES `vani` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `file_ibfk_37_nofollow` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_file` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042482

-- formati_tipologie_corrispondenza: via i vincoli che cambiano
ALTER TABLE `formati_tipologie_corrispondenza`
	DROP FOREIGN KEY IF EXISTS `formati_tipologie_corrispondenza_ibfk_01_nofollow`,
	DROP FOREIGN KEY IF EXISTS `formati_tipologie_corrispondenza_ibfk_02_nofollow`,
	DROP FOREIGN KEY IF EXISTS `formati_tipologie_corrispondenza_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `formati_tipologie_corrispondenza_ibfk_99_nofollow`;

-- | 202611042483

-- formati_tipologie_corrispondenza: indici nella forma del canone
ALTER TABLE `formati_tipologie_corrispondenza`
	DROP INDEX IF EXISTS `id_account_aggiornamento`,
	DROP INDEX IF EXISTS `id_account_inserimento`,
	DROP INDEX IF EXISTS `id_tipologia`,
	DROP INDEX IF EXISTS `id_udm_dimensioni`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `nome`,
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_tipologia` (`id_tipologia`),
	ADD KEY `id_udm_dimensioni` (`id_udm_dimensioni`),
	ADD KEY `indice` (`id`,`id_tipologia`,`nome`),
	ADD KEY `nome` (`nome`);

-- | 202611042484

-- formati_tipologie_corrispondenza: vincoli nella forma del canone
ALTER TABLE `formati_tipologie_corrispondenza`
	ADD CONSTRAINT `formati_tipologie_corrispondenza_ibfk_01_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_corrispondenza` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `formati_tipologie_corrispondenza_ibfk_02_nofollow` FOREIGN KEY (`id_udm_dimensioni`) REFERENCES `udm` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `formati_tipologie_corrispondenza_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `formati_tipologie_corrispondenza_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042485

-- funnel: via i vincoli che cambiano
ALTER TABLE `funnel`
	DROP FOREIGN KEY IF EXISTS `funnel_ibfk_01_nofollow`,
	DROP FOREIGN KEY IF EXISTS `funnel_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `funnel_ibfk_99_nofollow`;

-- | 202611042486

-- funnel: indici nella forma del canone
ALTER TABLE `funnel`
	DROP INDEX IF EXISTS `id_account_aggiornamento`,
	DROP INDEX IF EXISTS `id_account_inserimento`,
	DROP INDEX IF EXISTS `id_campagna`,
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_campagna` (`id_campagna`),
	ADD KEY `indice` (`id`,`nome`,`id_campagna`);

-- | 202611042487

-- funnel: vincoli nella forma del canone
ALTER TABLE `funnel`
	ADD CONSTRAINT `funnel_ibfk_01_nofollow` FOREIGN KEY (`id_campagna`) REFERENCES `campagne` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `funnel_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `funnel_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042488

-- giorni: via i vincoli che cambiano
ALTER TABLE `giorni`
	DROP FOREIGN KEY IF EXISTS `giorni_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `giorni_ibfk_99_nofollow`;

-- | 202611042489

-- giorni: indici nella forma del canone
ALTER TABLE `giorni`
	DROP INDEX IF EXISTS `nome`;

-- | 202611042490

-- iban: via i vincoli che cambiano
ALTER TABLE `iban`
	DROP FOREIGN KEY IF EXISTS `iban_ibfk_01`;

-- | 202611042491

-- iban: indici nella forma del canone
ALTER TABLE `iban`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	DROP INDEX IF EXISTS `unica`,
	ADD KEY `indice` (`id`,`ordine`,`id_anagrafica`,`intestazione`,`iban`),
	ADD KEY `ordine` (`ordine`),
	ADD UNIQUE KEY `unica` (`id_anagrafica`,`iban`);

-- | 202611042492

-- iban: vincoli nella forma del canone
ALTER TABLE `iban`
	ADD CONSTRAINT `iban_ibfk_01` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042493

-- immagini: via i vincoli che cambiano
ALTER TABLE `immagini`
	DROP FOREIGN KEY IF EXISTS `immagini_ibfk_01`,
	DROP FOREIGN KEY IF EXISTS `immagini_ibfk_02`,
	DROP FOREIGN KEY IF EXISTS `immagini_ibfk_03`,
	DROP FOREIGN KEY IF EXISTS `immagini_ibfk_04`,
	DROP FOREIGN KEY IF EXISTS `immagini_ibfk_05`,
	DROP FOREIGN KEY IF EXISTS `immagini_ibfk_05_nofollow`,
	DROP FOREIGN KEY IF EXISTS `immagini_ibfk_06`,
	DROP FOREIGN KEY IF EXISTS `immagini_ibfk_07`,
	DROP FOREIGN KEY IF EXISTS `immagini_ibfk_08`,
	DROP FOREIGN KEY IF EXISTS `immagini_ibfk_09`,
	DROP FOREIGN KEY IF EXISTS `immagini_ibfk_10`,
	DROP FOREIGN KEY IF EXISTS `immagini_ibfk_11`,
	DROP FOREIGN KEY IF EXISTS `immagini_ibfk_12`,
	DROP FOREIGN KEY IF EXISTS `immagini_ibfk_13`,
	DROP FOREIGN KEY IF EXISTS `immagini_ibfk_14`,
	DROP FOREIGN KEY IF EXISTS `immagini_ibfk_14_nofollow`,
	DROP FOREIGN KEY IF EXISTS `immagini_ibfk_15`,
	DROP FOREIGN KEY IF EXISTS `immagini_ibfk_15_nofollow`,
	DROP FOREIGN KEY IF EXISTS `immagini_ibfk_16`,
	DROP FOREIGN KEY IF EXISTS `immagini_ibfk_17`,
	DROP FOREIGN KEY IF EXISTS `immagini_ibfk_18`,
	DROP FOREIGN KEY IF EXISTS `immagini_ibfk_19`,
	DROP FOREIGN KEY IF EXISTS `immagini_ibfk_20`,
	DROP FOREIGN KEY IF EXISTS `immagini_ibfk_21`,
	DROP FOREIGN KEY IF EXISTS `immagini_ibfk_22`,
	DROP FOREIGN KEY IF EXISTS `immagini_ibfk_23`,
	DROP FOREIGN KEY IF EXISTS `immagini_ibfk_24`,
	DROP FOREIGN KEY IF EXISTS `immagini_ibfk_25`,
	DROP FOREIGN KEY IF EXISTS `immagini_ibfk_26`,
	DROP FOREIGN KEY IF EXISTS `immagini_ibfk_26_nofollow`,
	DROP FOREIGN KEY IF EXISTS `immagini_ibfk_27`,
	DROP FOREIGN KEY IF EXISTS `immagini_ibfk_28`,
	DROP FOREIGN KEY IF EXISTS `immagini_ibfk_29_nofollow`;

-- | 202611042494

-- immagini: indici nella forma del canone
ALTER TABLE `immagini`
	DROP INDEX IF EXISTS `id_anagrafica`,
	DROP INDEX IF EXISTS `id_annuncio`,
	DROP INDEX IF EXISTS `id_articolo`,
	DROP INDEX IF EXISTS `id_banner`,
	DROP INDEX IF EXISTS `id_categoria_annunci`,
	DROP INDEX IF EXISTS `id_categoria_notizie`,
	DROP INDEX IF EXISTS `id_categoria_prodotti`,
	DROP INDEX IF EXISTS `id_categoria_progetti`,
	DROP INDEX IF EXISTS `id_categoria_risorse`,
	DROP INDEX IF EXISTS `id_contatto`,
	DROP INDEX IF EXISTS `id_contratto`,
	DROP INDEX IF EXISTS `id_edificio`,
	DROP INDEX IF EXISTS `id_file`,
	DROP INDEX IF EXISTS `id_immobile`,
	DROP INDEX IF EXISTS `id_indirizzo`,
	DROP INDEX IF EXISTS `id_marchio`,
	DROP INDEX IF EXISTS `id_notizia`,
	DROP INDEX IF EXISTS `id_pagina`,
	DROP INDEX IF EXISTS `id_prodotto`,
	DROP INDEX IF EXISTS `id_progetto`,
	DROP INDEX IF EXISTS `id_rinnovo`,
	DROP INDEX IF EXISTS `id_risorsa`,
	DROP INDEX IF EXISTS `id_valutazione`,
	DROP INDEX IF EXISTS `id_video`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `indice_anagrafica`,
	DROP INDEX IF EXISTS `indice_articoli`,
	DROP INDEX IF EXISTS `indice_categorie_notizie`,
	DROP INDEX IF EXISTS `indice_categorie_prodotti`,
	DROP INDEX IF EXISTS `indice_categorie_risorse`,
	DROP INDEX IF EXISTS `indice_file`,
	DROP INDEX IF EXISTS `indice_indirizzi`,
	DROP INDEX IF EXISTS `indice_notizie`,
	DROP INDEX IF EXISTS `indice_pagine`,
	DROP INDEX IF EXISTS `indice_prodotti`,
	DROP INDEX IF EXISTS `indice_risorse`,
	DROP INDEX IF EXISTS `ordine`,
	DROP INDEX IF EXISTS `unica_annuncio`,
	DROP INDEX IF EXISTS `unica_audio`,
	DROP INDEX IF EXISTS `unica_categoria_annunci`,
	DROP INDEX IF EXISTS `unica_categoria_marchi`,
	DROP INDEX IF EXISTS `unica_categoria_progetti`,
	DROP INDEX IF EXISTS `unica_contatto`,
	DROP INDEX IF EXISTS `unica_contratto`,
	DROP INDEX IF EXISTS `unica_edificio`,
	DROP INDEX IF EXISTS `unica_immobile`,
	DROP INDEX IF EXISTS `unica_indirizzi`,
	DROP INDEX IF EXISTS `unica_indirizzo`,
	DROP INDEX IF EXISTS `unica_marchio`,
	DROP INDEX IF EXISTS `unica_notizia`,
	DROP INDEX IF EXISTS `unica_notizie`,
	DROP INDEX IF EXISTS `unica_progetto`,
	DROP INDEX IF EXISTS `unica_rinnovo`,
	DROP INDEX IF EXISTS `unica_risorsa`,
	DROP INDEX IF EXISTS `unica_risorse`,
	DROP INDEX IF EXISTS `unica_valutazione`,
	DROP INDEX IF EXISTS `unica_vano`,
	DROP INDEX IF EXISTS `unica_video`,
	ADD KEY `indice` (`id`,`ordine`,`nome`,`id_lingua`,`id_ruolo`,`path`,`path_alternativo`,`token`,`timestamp_scalamento`),
	ADD KEY `ordine` (`ordine`),
	ADD UNIQUE KEY `unica_annuncio` (`id_annuncio`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_audio` (`id_audio`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_categoria_annunci` (`id_categoria_annunci`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_categoria_marchi` (`id_categoria_marchi`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_categoria_progetti` (`id_categoria_progetti`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_contatto` (`id_contatto`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_contratto` (`id_contratto`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_edificio` (`id_edificio`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_immobile` (`id_immobile`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_indirizzo` (`id_indirizzo`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_marchio` (`id_marchio`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_notizia` (`id_notizia`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_progetto` (`id_progetto`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_rinnovo` (`id_rinnovo`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_risorsa` (`id_risorsa`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_valutazione` (`id_valutazione`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_vano` (`id_vano`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_video` (`id_video`,`id_ruolo`,`id_lingua`,`path`);

-- | 202611042495

-- immagini: vincoli nella forma del canone
ALTER TABLE `immagini`
	ADD CONSTRAINT `immagini_ibfk_01` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `immagini_ibfk_02` FOREIGN KEY (`id_annuncio`) REFERENCES `annunci` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `immagini_ibfk_03` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `immagini_ibfk_04` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `immagini_ibfk_05_nofollow` FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `immagini_ibfk_06` FOREIGN KEY (`id_contatto`) REFERENCES `contatti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `immagini_ibfk_07` FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `immagini_ibfk_08` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `immagini_ibfk_09` FOREIGN KEY (`id_contratto`) REFERENCES `contratti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `immagini_ibfk_10` FOREIGN KEY (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `immagini_ibfk_11` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `immagini_ibfk_12` FOREIGN KEY (`id_file`) REFERENCES `file` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `immagini_ibfk_13` FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `immagini_ibfk_14` FOREIGN KEY (`id_marchio`) REFERENCES `marchi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `immagini_ibfk_15` FOREIGN KEY (`id_categoria_marchi`) REFERENCES `categorie_marchi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `immagini_ibfk_16` FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `immagini_ibfk_17` FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `immagini_ibfk_18` FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `immagini_ibfk_19` FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `immagini_ibfk_20` FOREIGN KEY (`id_categoria_annunci`) REFERENCES `categorie_annunci` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `immagini_ibfk_21` FOREIGN KEY (`id_categoria_progetti`) REFERENCES `categorie_progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `immagini_ibfk_22` FOREIGN KEY (`id_edificio`) REFERENCES `edifici` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `immagini_ibfk_23` FOREIGN KEY (`id_valutazione`) REFERENCES `valutazioni` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `immagini_ibfk_24` FOREIGN KEY (`id_rinnovo`) REFERENCES `rinnovi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `immagini_ibfk_25` FOREIGN KEY (`id_banner`) REFERENCES `banner` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `immagini_ibfk_26` FOREIGN KEY (`id_audio`) REFERENCES `audio` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `immagini_ibfk_27` FOREIGN KEY (`id_video`) REFERENCES `video` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `immagini_ibfk_28` FOREIGN KEY (`id_vano`) REFERENCES `vani` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `immagini_ibfk_29_nofollow` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_immagini` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042496

-- immobili: via i vincoli che cambiano
ALTER TABLE `immobili`
	DROP FOREIGN KEY IF EXISTS `immobili_ibfk_02_nofollow`;

-- | 202611042497

-- immobili: indici nella forma del canone
ALTER TABLE `immobili`
	DROP INDEX IF EXISTS `catasto_categoria`,
	DROP INDEX IF EXISTS `catasto_classe`,
	DROP INDEX IF EXISTS `catasto_consistenza`,
	DROP INDEX IF EXISTS `catasto_rendita`,
	DROP INDEX IF EXISTS `catasto_superficie`,
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `indice` (`id`,`id_tipologia`,`codice`,`nome`,`id_edificio`);

-- | 202611042498

-- immobili: vincoli nella forma del canone
ALTER TABLE `immobili`
	ADD CONSTRAINT `immobili_ibfk_02_nofollow` FOREIGN KEY (`id_edificio`) REFERENCES `edifici` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042499

-- immobili_anagrafica: indici nella forma del canone
ALTER TABLE `immobili_anagrafica`
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `indice` (`id`,`ordine`,`id_immobile`,`id_anagrafica`,`id_ruolo`);

-- | 202611042500

-- immobili_caratteristiche: indici nella forma del canone
ALTER TABLE `immobili_caratteristiche`
	DROP INDEX IF EXISTS `id_lingua`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `unica`,
	ADD KEY `id_lingua` (`id_lingua`),
	ADD KEY `indice` (`id`,`ordine`,`id_immobile`,`id_caratteristica`,`id_lingua`,`se_assente`),
	ADD UNIQUE KEY `unica` (`id_immobile`,`id_caratteristica`,`id_lingua`);

-- | 202611042501

-- indirizzi_caratteristiche: indici nella forma del canone
ALTER TABLE `indirizzi_caratteristiche`
	DROP INDEX IF EXISTS `id_lingua`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `unica`,
	ADD KEY `id_lingua` (`id_lingua`),
	ADD KEY `indice` (`id`,`ordine`,`id_indirizzo`,`id_caratteristica`,`id_lingua`,`se_assente`),
	ADD UNIQUE KEY `unica` (`id_indirizzo`,`id_caratteristica`,`id_lingua`);

-- | 202611042502

-- iva: via i vincoli che cambiano
ALTER TABLE `iva`
	DROP FOREIGN KEY IF EXISTS `iva_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `iva_ibfk_99_nofollow`;

-- | 202611042503

-- iva: indici nella forma del canone
ALTER TABLE `iva`
	DROP INDEX IF EXISTS `data_archiviazione`,
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `data_archiviazione` (`data_archiviazione`),
	ADD KEY `indice` (`id`,`codice`,`nome`,`aliquota`,`data_archiviazione`);

-- | 202611042504

-- licenze_software: indici nella forma del canone
ALTER TABLE `licenze_software`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	ADD KEY `indice` (`id`,`ordine`,`id_licenza`,`id_software`),
	ADD KEY `ordine` (`ordine`);

-- | 202611042505

-- lingue: via i vincoli che cambiano
ALTER TABLE `lingue`
	DROP FOREIGN KEY IF EXISTS `lingue_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `lingue_ibfk_99_nofollow`;

-- | 202611042506

-- liste: indici nella forma del canone
ALTER TABLE `liste`
	DROP INDEX IF EXISTS `codice`,
	DROP INDEX IF EXISTS `indice`,
	ADD UNIQUE KEY `codice` (`codice`),
	ADD KEY `indice` (`id`,`codice`,`nome`);

-- | 202611042507

-- liste_mail: indici nella forma del canone
ALTER TABLE `liste_mail`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	ADD KEY `indice` (`id`,`ordine`,`id_lista`,`id_mail`),
	ADD KEY `ordine` (`ordine`);

-- | 202611042508

-- listini: via i vincoli che cambiano
ALTER TABLE `listini`
	DROP FOREIGN KEY IF EXISTS `listini_ibfk_01_nofollow`,
	DROP FOREIGN KEY IF EXISTS `listini_ibfk_02_nofollow`,
	DROP FOREIGN KEY IF EXISTS `listini_ibfk_03_nofollow`,
	DROP FOREIGN KEY IF EXISTS `listini_ibfk_04_nofollow`;

-- | 202611042509

-- listini: indici nella forma del canone
ALTER TABLE `listini`
	DROP INDEX IF EXISTS `codice`,
	DROP INDEX IF EXISTS `indice`,
	ADD UNIQUE KEY `codice` (`codice`),
	ADD KEY `indice` (`id`,`id_genitore`,`id_tipologia`,`codice`,`nome`);

-- | 202611042510

-- listini: vincoli nella forma del canone
ALTER TABLE `listini`
	ADD CONSTRAINT `listini_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `listini` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `listini_ibfk_02_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_listini` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `listini_ibfk_03_nofollow` FOREIGN KEY (`id_emittente`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `listini_ibfk_04_nofollow` FOREIGN KEY (`id_valuta`) REFERENCES `valute` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042511

-- listini_clienti: indici nella forma del canone
ALTER TABLE `listini_clienti`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	ADD KEY `indice` (`id`,`ordine`,`id_listino`,`id_cliente`),
	ADD KEY `ordine` (`ordine`);

-- | 202611042512

-- listini_zone: indici nella forma del canone
ALTER TABLE `listini_zone`
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `indice` (`id`,`ordine`,`id_listino`,`id_zona`);

-- | 202611042513

-- lotti: via i vincoli che cambiano
ALTER TABLE `lotti`
	DROP FOREIGN KEY IF EXISTS `lotti_ibfk_01_nofollow`,
	DROP FOREIGN KEY IF EXISTS `lotti_ibfk_02_nofollow`,
	DROP FOREIGN KEY IF EXISTS `lotti_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `lotti_ibfk_99_nofollow`;

-- | 202611042514

-- lotti: indici nella forma del canone
ALTER TABLE `lotti`
	DROP INDEX IF EXISTS `codice`,
	DROP INDEX IF EXISTS `data_scadenza`,
	DROP INDEX IF EXISTS `id_account_aggiornamento`,
	DROP INDEX IF EXISTS `id_account_inserimento`,
	DROP INDEX IF EXISTS `id_articolo`,
	DROP INDEX IF EXISTS `id_produttore`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `nome`,
	ADD KEY `codice` (`codice`),
	ADD KEY `data_scadenza` (`data_scadenza`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_articolo` (`id_articolo`),
	ADD KEY `id_produttore` (`id_produttore`),
	ADD KEY `indice` (`id`,`codice`,`nome`,`id_articolo`,`id_produttore`,`data_scadenza`),
	ADD KEY `nome` (`nome`);

-- | 202611042515

-- lotti: vincoli nella forma del canone
ALTER TABLE `lotti`
	ADD CONSTRAINT `lotti_ibfk_01_nofollow` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `lotti_ibfk_02_nofollow` FOREIGN KEY (`id_produttore`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `lotti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `lotti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042516

-- luoghi: via i vincoli che cambiano
ALTER TABLE `luoghi`
	DROP FOREIGN KEY IF EXISTS `luoghi_ibfk_02_nofollow`,
	DROP FOREIGN KEY IF EXISTS `luoghi_ibfk_03_nofollow`,
	DROP FOREIGN KEY IF EXISTS `luoghi_ibfk_04_nofollow`,
	DROP FOREIGN KEY IF EXISTS `luoghi_ibfk_05_nofollow`;

-- | 202611042517

-- luoghi: indici nella forma del canone
ALTER TABLE `luoghi`
	DROP INDEX IF EXISTS `id_vano`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `nome`,
	ADD KEY `id_vano` (`id_vano`),
	ADD KEY `indice` (`id`, `id_genitore`, `id_tipologia`, `nome`, `id_indirizzo`, `id_edificio`, `id_immobile`, `id_vano`),
	ADD KEY `nome` (`nome`);

-- | 202611042518

-- luoghi: vincoli nella forma del canone
ALTER TABLE `luoghi`
	ADD CONSTRAINT `luoghi_ibfk_02_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_luoghi` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `luoghi_ibfk_03_nofollow` FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `luoghi_ibfk_04_nofollow` FOREIGN KEY (`id_edificio`) REFERENCES `edifici` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `luoghi_ibfk_05_nofollow` FOREIGN KEY (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042519

-- macro: via i vincoli che cambiano
ALTER TABLE `macro`
	DROP FOREIGN KEY IF EXISTS `macro_ibfk_01`,
	DROP FOREIGN KEY IF EXISTS `macro_ibfk_02`,
	DROP FOREIGN KEY IF EXISTS `macro_ibfk_03`,
	DROP FOREIGN KEY IF EXISTS `macro_ibfk_04`,
	DROP FOREIGN KEY IF EXISTS `macro_ibfk_05`,
	DROP FOREIGN KEY IF EXISTS `macro_ibfk_06`,
	DROP FOREIGN KEY IF EXISTS `macro_ibfk_07`,
	DROP FOREIGN KEY IF EXISTS `macro_ibfk_08`,
	DROP FOREIGN KEY IF EXISTS `macro_ibfk_09`,
	DROP FOREIGN KEY IF EXISTS `macro_ibfk_10`,
	DROP FOREIGN KEY IF EXISTS `macro_ibfk_11`,
	DROP FOREIGN KEY IF EXISTS `macro_ibfk_12`,
	DROP FOREIGN KEY IF EXISTS `macro_ibfk_13`,
	DROP FOREIGN KEY IF EXISTS `macro_ibfk_14`,
	DROP FOREIGN KEY IF EXISTS `macro_ibfk_15`;

-- | 202611042520

-- macro: indici nella forma del canone
ALTER TABLE `macro`
	DROP INDEX IF EXISTS `id_annuncio`,
	DROP INDEX IF EXISTS `id_articolo`,
	DROP INDEX IF EXISTS `id_categoria_annunci`,
	DROP INDEX IF EXISTS `id_categoria_notizie`,
	DROP INDEX IF EXISTS `id_categoria_prodotti`,
	DROP INDEX IF EXISTS `id_categoria_progetti`,
	DROP INDEX IF EXISTS `id_categoria_risorse`,
	DROP INDEX IF EXISTS `id_notizia`,
	DROP INDEX IF EXISTS `id_pagina`,
	DROP INDEX IF EXISTS `id_pianificazione`,
	DROP INDEX IF EXISTS `id_prodotto`,
	DROP INDEX IF EXISTS `id_progetto`,
	DROP INDEX IF EXISTS `id_risorsa`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `macro`,
	DROP INDEX IF EXISTS `ordine`,
	DROP INDEX IF EXISTS `unica_annuncio`,
	DROP INDEX IF EXISTS `unica_categoria_annunci`,
	DROP INDEX IF EXISTS `unica_categoria_marchi`,
	DROP INDEX IF EXISTS `unica_marchio`,
	DROP INDEX IF EXISTS `unica_pianificazione`,
	ADD KEY `indice` (`id`,`ordine`,`macro`),
	ADD KEY `macro` (`macro`),
	ADD KEY `ordine` (`ordine`),
	ADD UNIQUE KEY `unica_annuncio` (`id_annuncio`,`macro`),
	ADD UNIQUE KEY `unica_categoria_annunci` (`id_categoria_annunci`,`macro`),
	ADD UNIQUE KEY `unica_categoria_marchi` (`id_categoria_marchi`,`macro`),
	ADD UNIQUE KEY `unica_marchio` (`id_marchio`,`macro`),
	ADD UNIQUE KEY `unica_pianificazione` (`id_pianificazione`,`macro`);

-- | 202611042521

-- macro: vincoli nella forma del canone
ALTER TABLE `macro`
	ADD CONSTRAINT `macro_ibfk_01` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `macro_ibfk_02` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `macro_ibfk_03` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `macro_ibfk_04` FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `macro_ibfk_05` FOREIGN KEY (`id_marchio`) REFERENCES `marchi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `macro_ibfk_06` FOREIGN KEY (`id_categoria_marchi`) REFERENCES `categorie_marchi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `macro_ibfk_07` FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `macro_ibfk_08` FOREIGN KEY (`id_annuncio`) REFERENCES `annunci` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `macro_ibfk_09` FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `macro_ibfk_10` FOREIGN KEY (`id_categoria_annunci`) REFERENCES `categorie_annunci` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `macro_ibfk_11` FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `macro_ibfk_12` FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `macro_ibfk_13` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `macro_ibfk_14` FOREIGN KEY (`id_categoria_progetti`) REFERENCES `categorie_progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `macro_ibfk_15` FOREIGN KEY (`id_pianificazione`) REFERENCES `pianificazioni` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042522

-- mail: via i vincoli che cambiano
ALTER TABLE `mail`
	DROP FOREIGN KEY IF EXISTS `mail_ibfk_01`,
	DROP FOREIGN KEY IF EXISTS `mail_ibfk_01_nofollow`,
	DROP FOREIGN KEY IF EXISTS `mail_ibfk_02`,
	DROP FOREIGN KEY IF EXISTS `mail_ibfk_02_nofollow`;

-- | 202611042523

-- mail: indici nella forma del canone
ALTER TABLE `mail`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	ADD KEY `indice` (`id`,`ordine`,`id_anagrafica`,`id_ruolo`,`indirizzo`,`se_notifiche`,`se_pec`),
	ADD KEY `ordine` (`ordine`);

-- | 202611042524

-- mail: vincoli nella forma del canone
ALTER TABLE `mail`
	ADD CONSTRAINT `mail_ibfk_01` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `mail_ibfk_02_nofollow` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_mail` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042525

-- mail_out: via i vincoli che cambiano
ALTER TABLE `mail_out`
	DROP FOREIGN KEY IF EXISTS `mail_out_ibfk_01_nofollow`,
	DROP FOREIGN KEY IF EXISTS `mail_out_ibfk_02_nofollow`;

-- | 202611042526

-- mail_out: indici nella forma del canone
ALTER TABLE `mail_out`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	DROP INDEX IF EXISTS `timestamp_invio`,
	DROP INDEX IF EXISTS `token`,
	DROP INDEX IF EXISTS `unica`,
	ADD KEY `indice` (`id`,`ordine`,`id_mailing`,`tentativi`,`token`,`timestamp_invio`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `timestamp_invio` (`timestamp_invio`),
	ADD KEY `token` (`token`);

-- | 202611042527

-- mail_out: vincoli nella forma del canone
ALTER TABLE `mail_out`
	ADD CONSTRAINT `mail_out_ibfk_01_nofollow` FOREIGN KEY (`id_mailing`) REFERENCES `mailing` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042528

-- mail_sent: via i vincoli che cambiano
ALTER TABLE `mail_sent`
	DROP FOREIGN KEY IF EXISTS `mail_sent_ibfk_01_nofollow`,
	DROP FOREIGN KEY IF EXISTS `mail_sent_ibfk_02_nofollow`;

-- | 202611042529

-- mail_sent: indici nella forma del canone
ALTER TABLE `mail_sent`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	DROP INDEX IF EXISTS `timestamp_invio`,
	DROP INDEX IF EXISTS `token`,
	DROP INDEX IF EXISTS `unica`,
	ADD KEY `indice` (`id`,`ordine`,`id_mailing`,`tentativi`,`token`,`timestamp_invio`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `timestamp_invio` (`timestamp_invio`),
	ADD KEY `token` (`token`);

-- | 202611042530

-- mail_sent: vincoli nella forma del canone
ALTER TABLE `mail_sent`
	ADD CONSTRAINT `mail_sent_ibfk_01_nofollow` FOREIGN KEY (`id_mailing`) REFERENCES `mailing` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042531

-- mailing: indici nella forma del canone
ALTER TABLE `mailing`
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `indice` (`id`,`nome`,`timestamp_invio`);

-- | 202611042532

-- mailing_liste: indici nella forma del canone
ALTER TABLE `mailing_liste`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	ADD KEY `indice` (`id`,`ordine`,`id_lista`,`id_mailing`),
	ADD KEY `ordine` (`ordine`);

-- | 202611042533

-- mailing_mail: indici nella forma del canone
ALTER TABLE `mailing_mail`
	DROP INDEX IF EXISTS `id_mail_sent`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	DROP INDEX IF EXISTS `unica_mail`,
	ADD KEY `id_mail_sent` (`id_mail_sent`),
	ADD KEY `indice` (`id`,`ordine`,`id_mail`,`id_mailing`,`id_mail_out`,`id_mail_sent`,`token`),
	ADD KEY `ordine` (`ordine`),
	ADD UNIQUE KEY `unica_mail` (`id_mailing`,`id_mail`);

-- | 202611042534

-- marchi: indici nella forma del canone
ALTER TABLE `marchi`
	DROP INDEX IF EXISTS `id_pagina`,
	DROP INDEX IF EXISTS `id_sito`,
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `id_pagina` (`id_pagina`),
	ADD KEY `id_sito` (`id_sito`),
	ADD KEY `indice` (`id`,`nome`,`id_produttore`,`id_sito`,`id_pagina`);

-- | 202611042535

-- marchi_categorie: via i vincoli che cambiano
ALTER TABLE `marchi_categorie`
	DROP FOREIGN KEY IF EXISTS `marchi_categorie_ibfk_01`,
	DROP FOREIGN KEY IF EXISTS `marchi_categorie_ibfk_02_nofollow`,
	DROP FOREIGN KEY IF EXISTS `marchi_categorie_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `marchi_categorie_ibfk_99_nofollow`;

-- | 202611042536

-- marchi_categorie: indici nella forma del canone
ALTER TABLE `marchi_categorie`
	DROP INDEX IF EXISTS `id_account_aggiornamento`,
	DROP INDEX IF EXISTS `id_account_inserimento`,
	DROP INDEX IF EXISTS `id_categoria`,
	DROP INDEX IF EXISTS `id_marchio`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_categoria` (`id_categoria`),
	ADD KEY `id_marchio` (`id_marchio`),
	ADD KEY `indice` (`id`,`id_marchio`,`id_categoria`,`ordine`),
	ADD KEY `ordine` (`ordine`);

-- | 202611042537

-- marchi_categorie: vincoli nella forma del canone
ALTER TABLE `marchi_categorie`
	ADD CONSTRAINT `marchi_categorie_ibfk_01` FOREIGN KEY (`id_marchio`) REFERENCES `marchi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `marchi_categorie_ibfk_02_nofollow` FOREIGN KEY (`id_categoria`) REFERENCES `categorie_marchi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `marchi_categorie_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `marchi_categorie_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042538

-- mastri: via i vincoli che cambiano
ALTER TABLE `mastri`
	DROP FOREIGN KEY IF EXISTS `mastri_ibfk_03_nofollow`,
	DROP FOREIGN KEY IF EXISTS `mastri_ibfk_04_nofollow`,
	DROP FOREIGN KEY IF EXISTS `mastri_ibfk_05_nofollow`,
	DROP FOREIGN KEY IF EXISTS `mastri_ibfk_06_nofollow`;

-- | 202611042539

-- mastri: indici nella forma del canone
ALTER TABLE `mastri`
	DROP INDEX IF EXISTS `codice`,
	DROP INDEX IF EXISTS `id_edificio`,
	DROP INDEX IF EXISTS `id_immobile`,
	DROP INDEX IF EXISTS `id_indirizzo`,
	DROP INDEX IF EXISTS `id_vano`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `unica`,
	ADD UNIQUE KEY `codice` (`codice`),
	ADD KEY `id_edificio` (`id_edificio`),
	ADD KEY `id_immobile` (`id_immobile`),
	ADD KEY `id_indirizzo` (`id_indirizzo`),
	ADD KEY `id_vano` (`id_vano`),
	ADD KEY `indice` (`id`,`id_genitore`,`id_tipologia`,`codice`,`nome`),
	ADD KEY `nome` (`nome`);

-- | 202611042540

-- mastri: vincoli nella forma del canone
ALTER TABLE `mastri`
	ADD CONSTRAINT `mastri_ibfk_03_nofollow` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `mastri_ibfk_04_nofollow` FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `mastri_ibfk_05_nofollow` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `mastri_ibfk_06_nofollow` FOREIGN KEY (`id_anagrafica_indirizzi`) REFERENCES `anagrafica_indirizzi` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042541

-- mastri_articoli: via i vincoli che cambiano
ALTER TABLE `mastri_articoli`
	DROP FOREIGN KEY IF EXISTS `mastri_articoli_ibfk_02`,
	DROP FOREIGN KEY IF EXISTS `mastri_articoli_ibfk_02_nofollow`,
	DROP FOREIGN KEY IF EXISTS `mastri_articoli_ibfk_03_nofollow`,
	DROP FOREIGN KEY IF EXISTS `mastri_articoli_ibfk_04_nofollow`;

-- | 202611042542

-- mastri_articoli: indici nella forma del canone
ALTER TABLE `mastri_articoli`
	DROP INDEX IF EXISTS `codice`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `unica`,
	ADD UNIQUE KEY `codice` (`codice`),
	ADD KEY `indice` (`id`,`ordine`,`codice`,`id_mastro`,`id_articolo`,`id_ruolo`),
	ADD UNIQUE KEY `unica` (`id_mastro`,`id_articolo`);

-- | 202611042543

-- mastri_articoli: vincoli nella forma del canone
ALTER TABLE `mastri_articoli`
	ADD CONSTRAINT `mastri_articoli_ibfk_02` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `mastri_articoli_ibfk_03_nofollow` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_mastri` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `mastri_articoli_ibfk_04_nofollow` FOREIGN KEY (`id_udm`) REFERENCES `udm` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042544

-- mastri_tipologie_veicoli: via i vincoli che cambiano
ALTER TABLE `mastri_tipologie_veicoli`
	DROP FOREIGN KEY IF EXISTS `mastri_tipologie_veicoli_ibfk_01`,
	DROP FOREIGN KEY IF EXISTS `mastri_tipologie_veicoli_ibfk_01_nofollow`;

-- | 202611042545

-- mastri_tipologie_veicoli: indici nella forma del canone
ALTER TABLE `mastri_tipologie_veicoli`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	ADD KEY `indice` (`id`,`ordine`,`id_mastro`,`id_tipologia`),
	ADD KEY `ordine` (`ordine`);

-- | 202611042546

-- mastri_tipologie_veicoli: vincoli nella forma del canone
ALTER TABLE `mastri_tipologie_veicoli`
	ADD CONSTRAINT `mastri_tipologie_veicoli_ibfk_01` FOREIGN KEY (`id_mastro`) REFERENCES `mastri` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042547

-- matricole: via i vincoli che cambiano
ALTER TABLE `matricole`
	DROP FOREIGN KEY IF EXISTS `matricole_ibfk_02_nofollow`,
	DROP FOREIGN KEY IF EXISTS `matricole_ibfk_04_nofollow`;

-- | 202611042548

-- matricole: indici nella forma del canone
ALTER TABLE `matricole`
	DROP INDEX IF EXISTS `id_condizione`,
	DROP INDEX IF EXISTS `id_lotto`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `matricola`,
	DROP INDEX IF EXISTS `unica`,
	ADD KEY `id_condizione` (`id_condizione`),
	ADD KEY `id_lotto` (`id_lotto`),
	ADD KEY `indice` (`id`,`matricola`,`nome`,`id_articolo`,`id_lotto`,`id_marchio`,`id_produttore`),
	ADD KEY `matricola` (`matricola`),
	ADD UNIQUE KEY `unica` (`id_articolo`,`matricola`);

-- | 202611042549

-- matricole: vincoli nella forma del canone
ALTER TABLE `matricole`
	ADD CONSTRAINT `matricole_ibfk_02_nofollow` FOREIGN KEY (`id_lotto`) REFERENCES `lotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `matricole_ibfk_04_nofollow` FOREIGN KEY (`id_produttore`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042550

-- menu: via i vincoli che cambiano
ALTER TABLE `menu`
	DROP FOREIGN KEY IF EXISTS `menu_ibfk_01`,
	DROP FOREIGN KEY IF EXISTS `menu_ibfk_01_nofollow`,
	DROP FOREIGN KEY IF EXISTS `menu_ibfk_02`,
	DROP FOREIGN KEY IF EXISTS `menu_ibfk_03`,
	DROP FOREIGN KEY IF EXISTS `menu_ibfk_04`,
	DROP FOREIGN KEY IF EXISTS `menu_ibfk_05`,
	DROP FOREIGN KEY IF EXISTS `menu_ibfk_06`,
	DROP FOREIGN KEY IF EXISTS `menu_ibfk_07`,
	DROP FOREIGN KEY IF EXISTS `menu_ibfk_07_nofollow`,
	DROP FOREIGN KEY IF EXISTS `menu_ibfk_08`,
	DROP FOREIGN KEY IF EXISTS `menu_ibfk_09`,
	DROP FOREIGN KEY IF EXISTS `menu_ibfk_11`,
	DROP FOREIGN KEY IF EXISTS `menu_ibfk_13`,
	DROP FOREIGN KEY IF EXISTS `menu_ibfk_14_nofollow`;

-- | 202611042551

-- menu: indici nella forma del canone
ALTER TABLE `menu`
	DROP INDEX IF EXISTS `id_categoria_annunci`,
	DROP INDEX IF EXISTS `id_categoria_notizie`,
	DROP INDEX IF EXISTS `id_categoria_prodotti`,
	DROP INDEX IF EXISTS `id_categoria_progetti`,
	DROP INDEX IF EXISTS `id_categoria_risorse`,
	DROP INDEX IF EXISTS `id_pagina`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `menu`,
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `ordine`,
	DROP INDEX IF EXISTS `unica`,
	DROP INDEX IF EXISTS `unica_annuncio`,
	DROP INDEX IF EXISTS `unica_categoria_annunci`,
	DROP INDEX IF EXISTS `unica_categoria_marchi`,
	DROP INDEX IF EXISTS `unica_marchio`,
	DROP INDEX IF EXISTS `unica_notizia`,
	DROP INDEX IF EXISTS `unica_pagina`,
	DROP INDEX IF EXISTS `unica_prodotto`,
	DROP INDEX IF EXISTS `unica_progetto`,
	DROP INDEX IF EXISTS `unica_risorsa`,
	ADD KEY `indice` (`id`,`ordine`,`nome`,`id_lingua`,`menu`),
	ADD KEY `menu` (`menu`),
	ADD KEY `nome` (`nome`),
	ADD KEY `ordine` (`ordine`),
	ADD UNIQUE KEY `unica_annuncio` (`id_annuncio`,`id_lingua`,`menu`,`nome`,`ancora`),
	ADD UNIQUE KEY `unica_categoria_annunci` (`id_categoria_annunci`,`id_lingua`,`menu`,`nome`,`ancora`),
	ADD UNIQUE KEY `unica_categoria_marchi` (`id_categoria_marchi`,`id_lingua`,`menu`,`nome`,`ancora`),
	ADD UNIQUE KEY `unica_marchio` (`id_marchio`,`id_lingua`,`menu`,`nome`,`ancora`),
	ADD UNIQUE KEY `unica_notizia` (`id_notizia`,`id_lingua`,`menu`,`nome`,`ancora`),
	ADD UNIQUE KEY `unica_pagina` (`id_pagina`,`id_lingua`,`menu`,`nome`,`ancora`),
	ADD UNIQUE KEY `unica_prodotto` (`id_prodotto`,`id_lingua`,`menu`,`nome`,`ancora`),
	ADD UNIQUE KEY `unica_progetto` (`id_progetto`,`id_lingua`,`menu`,`nome`,`ancora`),
	ADD UNIQUE KEY `unica_risorsa` (`id_risorsa`,`id_lingua`,`menu`,`nome`,`ancora`);

-- | 202611042552

-- menu: vincoli nella forma del canone
ALTER TABLE `menu`
	ADD CONSTRAINT `menu_ibfk_01` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `menu_ibfk_02` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `menu_ibfk_03` FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `menu_ibfk_04` FOREIGN KEY (`id_marchio`) REFERENCES `marchi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `menu_ibfk_05` FOREIGN KEY (`id_categoria_marchi`) REFERENCES `categorie_marchi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `menu_ibfk_06` FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `menu_ibfk_07` FOREIGN KEY (`id_annuncio`) REFERENCES `annunci` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `menu_ibfk_08` FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `menu_ibfk_09` FOREIGN KEY (`id_categoria_annunci`) REFERENCES `categorie_annunci` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `menu_ibfk_11` FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `menu_ibfk_13` FOREIGN KEY (`id_categoria_progetti`) REFERENCES `categorie_progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `menu_ibfk_14_nofollow` FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042553

-- messaggi: via i vincoli che cambiano
ALTER TABLE `messaggi`
	DROP FOREIGN KEY IF EXISTS `messaggi_ibfk_01_nofollow`;

-- | 202611042554

-- messaggi: indici nella forma del canone
ALTER TABLE `messaggi`
	DROP INDEX IF EXISTS `id_account`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `timestamp_invio`,
	ADD KEY `id_account` (`id_account`),
	ADD KEY `indice` (`id`,`id_conversazione`,`id_account`,`timestamp_invio`),
	ADD KEY `timestamp_invio` (`timestamp_invio`);

-- | 202611042555

-- messaggi: vincoli nella forma del canone
ALTER TABLE `messaggi`
	ADD CONSTRAINT `messaggi_ibfk_01_nofollow` FOREIGN KEY (`id_conversazione`) REFERENCES `conversazioni` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042556

-- messaggi_account: via i vincoli che cambiano
ALTER TABLE `messaggi_account`
	DROP FOREIGN KEY IF EXISTS `messaggi_account_ibfk_01_nofollow`,
	DROP FOREIGN KEY IF EXISTS `messaggi_account_ibfk_02_nofollow`,
	DROP FOREIGN KEY IF EXISTS `messaggi_account_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `messaggi_account_ibfk_99_nofollow`;

-- | 202611042557

-- messaggi_account: indici nella forma del canone
ALTER TABLE `messaggi_account`
	DROP INDEX IF EXISTS `id_account`,
	DROP INDEX IF EXISTS `id_account_aggiornamento`,
	DROP INDEX IF EXISTS `id_account_inserimento`,
	DROP INDEX IF EXISTS `id_messaggio`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	DROP INDEX IF EXISTS `timestamp_lettura`,
	ADD KEY `id_account` (`id_account`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_messaggio` (`id_messaggio`),
	ADD KEY `indice` (`id`,`ordine`,`id_account`,`id_messaggio`,`timestamp_lettura`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `timestamp_lettura` (`timestamp_lettura`);

-- | 202611042558

-- messaggi_account: vincoli nella forma del canone
ALTER TABLE `messaggi_account`
	ADD CONSTRAINT `messaggi_account_ibfk_01_nofollow` FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `messaggi_account_ibfk_02_nofollow` FOREIGN KEY (`id_messaggio`) REFERENCES `messaggi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `messaggi_account_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `messaggi_account_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042559

-- metadati: via i vincoli che cambiano
ALTER TABLE `metadati`
	DROP FOREIGN KEY IF EXISTS `metadati_ibfk_02`,
	DROP FOREIGN KEY IF EXISTS `metadati_ibfk_03`,
	DROP FOREIGN KEY IF EXISTS `metadati_ibfk_04`,
	DROP FOREIGN KEY IF EXISTS `metadati_ibfk_05`,
	DROP FOREIGN KEY IF EXISTS `metadati_ibfk_06`,
	DROP FOREIGN KEY IF EXISTS `metadati_ibfk_07`,
	DROP FOREIGN KEY IF EXISTS `metadati_ibfk_08`,
	DROP FOREIGN KEY IF EXISTS `metadati_ibfk_09`,
	DROP FOREIGN KEY IF EXISTS `metadati_ibfk_10`,
	DROP FOREIGN KEY IF EXISTS `metadati_ibfk_11`,
	DROP FOREIGN KEY IF EXISTS `metadati_ibfk_12`,
	DROP FOREIGN KEY IF EXISTS `metadati_ibfk_15`,
	DROP FOREIGN KEY IF EXISTS `metadati_ibfk_16`,
	DROP FOREIGN KEY IF EXISTS `metadati_ibfk_17`,
	DROP FOREIGN KEY IF EXISTS `metadati_ibfk_18`,
	DROP FOREIGN KEY IF EXISTS `metadati_ibfk_19`,
	DROP FOREIGN KEY IF EXISTS `metadati_ibfk_20`,
	DROP FOREIGN KEY IF EXISTS `metadati_ibfk_21`,
	DROP FOREIGN KEY IF EXISTS `metadati_ibfk_22`,
	DROP FOREIGN KEY IF EXISTS `metadati_ibfk_23`,
	DROP FOREIGN KEY IF EXISTS `metadati_ibfk_24`,
	DROP FOREIGN KEY IF EXISTS `metadati_ibfk_25`,
	DROP FOREIGN KEY IF EXISTS `metadati_ibfk_26`,
	DROP FOREIGN KEY IF EXISTS `metadati_ibfk_27`,
	DROP FOREIGN KEY IF EXISTS `metadati_ibfk_28`,
	DROP FOREIGN KEY IF EXISTS `metadati_ibfk_29`,
	DROP FOREIGN KEY IF EXISTS `metadati_ibfk_30`,
	DROP FOREIGN KEY IF EXISTS `metadati_ibfk_31`,
	DROP FOREIGN KEY IF EXISTS `metadati_ibfk_32`,
	DROP FOREIGN KEY IF EXISTS `metadati_ibfk_33`,
	DROP FOREIGN KEY IF EXISTS `metadati_ibfk_34`,
	DROP FOREIGN KEY IF EXISTS `metadati_ibfk_35`,
	DROP FOREIGN KEY IF EXISTS `metadati_ibfk_36`,
	DROP FOREIGN KEY IF EXISTS `metadati_ibfk_37`,
	DROP FOREIGN KEY IF EXISTS `metadati_ibfk_38`,
	DROP FOREIGN KEY IF EXISTS `metadati_ibfk_39`,
	DROP FOREIGN KEY IF EXISTS `metadati_ibfk_40`,
	DROP FOREIGN KEY IF EXISTS `metadati_ibfk_41`;

-- | 202611042560

-- metadati: indici nella forma del canone
ALTER TABLE `metadati`
	DROP INDEX IF EXISTS `id_annuncio`,
	DROP INDEX IF EXISTS `id_attivita`,
	DROP INDEX IF EXISTS `id_categoria_annunci`,
	DROP INDEX IF EXISTS `id_documenti_articoli`,
	DROP INDEX IF EXISTS `id_documento`,
	DROP INDEX IF EXISTS `id_peso_tipologie_corrispondenza`,
	DROP INDEX IF EXISTS `id_tipologia_corrispondenza`,
	DROP INDEX IF EXISTS `id_todo`,
	DROP INDEX IF EXISTS `id_valutazione`,
	DROP INDEX IF EXISTS `unica_annuncio`,
	DROP INDEX IF EXISTS `unica_asset`,
	DROP INDEX IF EXISTS `unica_attivita`,
	DROP INDEX IF EXISTS `unica_categoria_annunci`,
	DROP INDEX IF EXISTS `unica_categoria_marchi`,
	DROP INDEX IF EXISTS `unica_categoria_progetti`,
	DROP INDEX IF EXISTS `unica_categoria_progetto`,
	DROP INDEX IF EXISTS `unica_documenti_articoli`,
	DROP INDEX IF EXISTS `unica_documento`,
	DROP INDEX IF EXISTS `unica_marchio`,
	DROP INDEX IF EXISTS `unica_peso_tipologie_corrispondenza`,
	DROP INDEX IF EXISTS `unica_tipologia_corrispondenza`,
	DROP INDEX IF EXISTS `unica_todo`,
	DROP INDEX IF EXISTS `unica_valutazione`,
	DROP INDEX IF EXISTS `unica_vano`,
	ADD UNIQUE KEY `unica_annuncio` (`id_annuncio`,`id_lingua`,`nome`),
	ADD UNIQUE KEY `unica_asset` (`id_asset`,`id_lingua`,`nome`),
	ADD UNIQUE KEY `unica_attivita` (`id_attivita`,`id_lingua`,`nome`),
	ADD UNIQUE KEY `unica_categoria_annunci` (`id_categoria_annunci`,`id_lingua`,`nome`),
	ADD UNIQUE KEY `unica_categoria_marchi` (`id_categoria_marchi`,`id_lingua`,`nome`),
	ADD UNIQUE KEY `unica_categoria_progetti` (`id_categoria_progetti`,`id_lingua`,`nome`),
	ADD UNIQUE KEY `unica_documenti_articoli` (`id_documenti_articoli`,`id_lingua`,`nome`),
	ADD UNIQUE KEY `unica_documento` (`id_documento`,`id_lingua`,`nome`),
	ADD UNIQUE KEY `unica_marchio` (`id_marchio`,`id_lingua`,`nome`),
	ADD UNIQUE KEY `unica_peso_tipologie_corrispondenza` (`id_peso_tipologie_corrispondenza`,`id_lingua`,`nome`),
	ADD UNIQUE KEY `unica_tipologia_corrispondenza` (`id_tipologia_corrispondenza`,`id_lingua`,`nome`),
	ADD UNIQUE KEY `unica_todo` (`id_todo`,`id_lingua`,`nome`),
	ADD UNIQUE KEY `unica_valutazione` (`id_valutazione`,`id_lingua`,`nome`),
	ADD UNIQUE KEY `unica_vano` (`id_vano`,`id_lingua`,`nome`);

-- | 202611042561

-- metadati: vincoli nella forma del canone
ALTER TABLE `metadati`
	ADD CONSTRAINT `metadati_ibfk_02` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `metadati_ibfk_03` FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `metadati_ibfk_04` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `metadati_ibfk_05` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `metadati_ibfk_06` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `metadati_ibfk_07` FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `metadati_ibfk_08` FOREIGN KEY (`id_marchio`) REFERENCES `marchi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `metadati_ibfk_09` FOREIGN KEY (`id_categoria_marchi`) REFERENCES `categorie_marchi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `metadati_ibfk_10` FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `metadati_ibfk_11` FOREIGN KEY (`id_annuncio`) REFERENCES `annunci` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `metadati_ibfk_12` FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `metadati_ibfk_15` FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `metadati_ibfk_16` FOREIGN KEY (`id_immagine`) REFERENCES `immagini` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `metadati_ibfk_17` FOREIGN KEY (`id_video`) REFERENCES `video` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `metadati_ibfk_18` FOREIGN KEY (`id_audio`) REFERENCES `audio` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `metadati_ibfk_19` FOREIGN KEY (`id_file`) REFERENCES `file` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `metadati_ibfk_20` FOREIGN KEY (`id_documento`) REFERENCES `documenti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `metadati_ibfk_21` FOREIGN KEY (`id_documenti_articoli`) REFERENCES `documenti_articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `metadati_ibfk_22` FOREIGN KEY (`id_asset`) REFERENCES `asset` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `metadati_ibfk_23` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `metadati_ibfk_24` FOREIGN KEY (`id_categoria_progetti`) REFERENCES `categorie_progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `metadati_ibfk_25` FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `metadati_ibfk_26` FOREIGN KEY (`id_edificio`) REFERENCES `edifici` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `metadati_ibfk_27` FOREIGN KEY (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `metadati_ibfk_28` FOREIGN KEY (`id_vano`) REFERENCES `vani` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `metadati_ibfk_29` FOREIGN KEY (`id_contratto`) REFERENCES `contratti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `metadati_ibfk_30` FOREIGN KEY (`id_valutazione`) REFERENCES `valutazioni` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `metadati_ibfk_31` FOREIGN KEY (`id_rinnovo`) REFERENCES `rinnovi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `metadati_ibfk_32` FOREIGN KEY (`id_attivita`) REFERENCES `attivita` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `metadati_ibfk_33` FOREIGN KEY (`id_tipologia_attivita`) REFERENCES `tipologie_attivita` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `metadati_ibfk_34` FOREIGN KEY (`id_banner`) REFERENCES `banner` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `metadati_ibfk_35` FOREIGN KEY (`id_pianificazione`) REFERENCES `pianificazioni` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `metadati_ibfk_36` FOREIGN KEY (`id_todo`) REFERENCES `todo` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `metadati_ibfk_37` FOREIGN KEY (`id_tipologia_todo`) REFERENCES `tipologie_todo` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `metadati_ibfk_38` FOREIGN KEY (`id_tipologia_contratti`) REFERENCES `tipologie_contratti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `metadati_ibfk_39` FOREIGN KEY (`id_carrello`) REFERENCES `carrelli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `metadati_ibfk_40` FOREIGN KEY (`id_tipologia_corrispondenza`) REFERENCES `tipologie_corrispondenza` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `metadati_ibfk_41` FOREIGN KEY (`id_peso_tipologie_corrispondenza`) REFERENCES `pesi_tipologie_corrispondenza` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042562

-- modalita_pagamento: via i vincoli che cambiano
ALTER TABLE `modalita_pagamento`
	DROP FOREIGN KEY IF EXISTS `modalita_pagamento_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `modalita_pagamento_ibfk_99_nofollow`;

-- | 202611042563

-- modalita_pagamento: indici nella forma del canone
ALTER TABLE `modalita_pagamento`
	DROP INDEX IF EXISTS `codice_sdi`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `nome`,
	ADD KEY `codice_sdi` (`codice_sdi`),
	ADD KEY `indice` (`id`,`nome`,`codice_sdi`),
	ADD UNIQUE KEY `nome` (`nome`);

-- | 202611042564

-- modalita_spedizione: via i vincoli che cambiano
ALTER TABLE `modalita_spedizione`
	DROP FOREIGN KEY IF EXISTS `modalita_spedizione_ibfk_02`,
	DROP FOREIGN KEY IF EXISTS `modalita_spedizione_ibfk_02_nofollow`,
	DROP FOREIGN KEY IF EXISTS `modalita_spedizione_ibfk_03`,
	DROP FOREIGN KEY IF EXISTS `modalita_spedizione_ibfk_03_nofollow`,
	DROP FOREIGN KEY IF EXISTS `modalita_spedizione_ibfk_04`,
	DROP FOREIGN KEY IF EXISTS `modalita_spedizione_ibfk_04_nofollow`,
	DROP FOREIGN KEY IF EXISTS `modalita_spedizione_ibfk_05`,
	DROP FOREIGN KEY IF EXISTS `modalita_spedizione_ibfk_05_nofollow`;

-- | 202611042565

-- modalita_spedizione: indici nella forma del canone
ALTER TABLE `modalita_spedizione`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `unica`,
	ADD KEY `indice` (`id`,`id_tipologia`,`id_zona`,`id_prodotto`,`id_articolo`,`id_categoria_prodotti`,`importo_netto`),
	ADD UNIQUE KEY `unica` (`id_tipologia`,`id_zona`,`id_prodotto`,`id_articolo`,`id_categoria_prodotti`);

-- | 202611042566

-- modalita_spedizione: vincoli nella forma del canone
ALTER TABLE `modalita_spedizione`
	ADD CONSTRAINT `modalita_spedizione_ibfk_02_nofollow` FOREIGN KEY (`id_zona`) REFERENCES `zone` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `modalita_spedizione_ibfk_03_nofollow` FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `modalita_spedizione_ibfk_04_nofollow` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `modalita_spedizione_ibfk_05_nofollow` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042567

-- notizie: indici nella forma del canone
ALTER TABLE `notizie`
	DROP INDEX IF EXISTS `id_pagina`,
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `id_pagina` (`id_pagina`),
	ADD KEY `indice` (`id`,`id_tipologia`,`nome`,`id_sito`,`id_pagina`);

-- | 202611042568

-- notizie_anagrafica: via i vincoli che cambiano
ALTER TABLE `notizie_anagrafica`
	DROP FOREIGN KEY IF EXISTS `notizie_anagrafica_ibfk_01`,
	DROP FOREIGN KEY IF EXISTS `notizie_anagrafica_ibfk_01_nofollow`;

-- | 202611042569

-- notizie_anagrafica: indici nella forma del canone
ALTER TABLE `notizie_anagrafica`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	ADD KEY `indice` (`id`,`ordine`,`id_notizia`,`id_anagrafica`,`id_ruolo`),
	ADD KEY `ordine` (`ordine`);

-- | 202611042570

-- notizie_anagrafica: vincoli nella forma del canone
ALTER TABLE `notizie_anagrafica`
	ADD CONSTRAINT `notizie_anagrafica_ibfk_01` FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042571

-- notizie_categorie: via i vincoli che cambiano
ALTER TABLE `notizie_categorie`
	DROP FOREIGN KEY IF EXISTS `notizie_categorie_ibfk_03_nofollow`;

-- | 202611042572

-- notizie_categorie: indici nella forma del canone
ALTER TABLE `notizie_categorie`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	ADD KEY `indice` (`id`,`id_notizia`,`id_categoria`,`ordine`),
	ADD KEY `ordine` (`ordine`);

-- | 202611042573

-- orari_contratti: via i vincoli che cambiano
ALTER TABLE `orari_contratti`
	DROP FOREIGN KEY IF EXISTS `orari_contratti_ibfk_02_nofollow`;

-- | 202611042574

-- orari_contratti: indici nella forma del canone
ALTER TABLE `orari_contratti`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `unica_disponibile`,
	DROP INDEX IF EXISTS `unica_lavoro`,
	DROP INDEX IF EXISTS `unico_disponibile`,
	DROP INDEX IF EXISTS `unico_lavoro`,
	ADD KEY `indice` (`id`,`id_contratto`,`turno`,`id_giorno`,`ora_inizio`,`ora_fine`,`id_costo`,`se_lavoro`,`se_disponibile`),
	ADD UNIQUE KEY `unica_disponibile` (`id_contratto`,`turno`,`id_giorno`,`ora_inizio`,`ora_fine`,`se_disponibile`),
	ADD UNIQUE KEY `unica_lavoro` (`id_contratto`,`turno`,`id_giorno`,`ora_inizio`,`ora_fine`,`se_lavoro`);

-- | 202611042575

-- orari_contratti: vincoli nella forma del canone
ALTER TABLE `orari_contratti`
	ADD CONSTRAINT `orari_contratti_ibfk_02_nofollow` FOREIGN KEY (`id_costo`) REFERENCES `costi_contratti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042576

-- organizzazioni: via i vincoli che cambiano
ALTER TABLE `organizzazioni`
	DROP FOREIGN KEY IF EXISTS `organizzazioni_ibfk_03_nofollow`;

-- | 202611042577

-- organizzazioni: indici nella forma del canone
ALTER TABLE `organizzazioni`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `unica`,
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`id_anagrafica`),
	ADD KEY `nome` (`nome`),
	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`);

-- | 202611042578

-- pagine: via i vincoli che cambiano
ALTER TABLE `pagine`
	DROP FOREIGN KEY IF EXISTS `pagine_ibfk_02_nofollow`;

-- | 202611042579

-- pagine: indici nella forma del canone
ALTER TABLE `pagine`
	DROP INDEX IF EXISTS `codice`,
	DROP INDEX IF EXISTS `id_pagina_contenuti`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	DROP INDEX IF EXISTS `unica`,
	ADD UNIQUE KEY `codice` (`codice`),
	ADD KEY `id_pagina_contenuti` (`id_pagina_contenuti`),
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`codice`,`nome`,`id_sito`),
	ADD KEY `ordine` (`ordine`),
	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`);

-- | 202611042580

-- pagine: vincoli nella forma del canone
ALTER TABLE `pagine`
	ADD CONSTRAINT `pagine_ibfk_02_nofollow` FOREIGN KEY (`id_pagina_contenuti`) REFERENCES `pagine` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042581

-- periodi: via i vincoli che cambiano
ALTER TABLE `periodi`
	DROP FOREIGN KEY IF EXISTS `periodi_ibfk_03`,
	DROP FOREIGN KEY IF EXISTS `periodi_ibfk_03_nofollow`;

-- | 202611042582

-- periodi: indici nella forma del canone
ALTER TABLE `periodi`
	DROP INDEX IF EXISTS `data_fine`,
	DROP INDEX IF EXISTS `data_inizio`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `unica`,
	ADD KEY `data_fine` (`data_fine`),
	ADD KEY `data_inizio` (`data_inizio`),
	ADD KEY `indice` (`id`,`id_genitore`,`id_tipologia`,`nome`,`id_contratto`,`data_inizio`,`data_fine`);

-- | 202611042583

-- periodi: vincoli nella forma del canone
ALTER TABLE `periodi`
	ADD CONSTRAINT `periodi_ibfk_03` FOREIGN KEY (`id_contratto`) REFERENCES `contratti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042584

-- periodicita: via i vincoli che cambiano
ALTER TABLE `periodicita`
	DROP FOREIGN KEY IF EXISTS `periodicita_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `periodicita_ibfk_99_nofollow`;

-- | 202611042585

-- periodicita: indici nella forma del canone
ALTER TABLE `periodicita`
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `indice` (`id`,`nome`,`giorni`);

-- | 202611042586

-- pesi_tipologie_corrispondenza: indici nella forma del canone
ALTER TABLE `pesi_tipologie_corrispondenza`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `unica`,
	ADD KEY `indice` (`id`,`id_tipologia`,`nome`,`grammi_min`,`grammi_max`),
	ADD KEY `nome` (`nome`),
	ADD UNIQUE KEY `unica` (`id_tipologia`,`nome`);

-- | 202611042587

-- pianificazioni: via i vincoli che cambiano
ALTER TABLE `pianificazioni`
	DROP FOREIGN KEY IF EXISTS `pianificazioni_ibfk_01`,
	DROP FOREIGN KEY IF EXISTS `pianificazioni_ibfk_02`,
	DROP FOREIGN KEY IF EXISTS `pianificazioni_ibfk_03`,
	DROP FOREIGN KEY IF EXISTS `pianificazioni_ibfk_05`,
	DROP FOREIGN KEY IF EXISTS `pianificazioni_ibfk_06_nofollow`;

-- | 202611042588

-- pianificazioni: indici nella forma del canone
ALTER TABLE `pianificazioni`
	DROP INDEX IF EXISTS `model_anno_programmazione`,
	DROP INDEX IF EXISTS `model_codice`,
	DROP INDEX IF EXISTS `model_data`,
	DROP INDEX IF EXISTS `model_data_fine`,
	DROP INDEX IF EXISTS `model_data_inizio`,
	DROP INDEX IF EXISTS `model_data_programmazione`,
	DROP INDEX IF EXISTS `model_data_scadenza`,
	DROP INDEX IF EXISTS `model_id_causale`,
	DROP INDEX IF EXISTS `model_id_collo`,
	DROP INDEX IF EXISTS `model_id_sede_destinatario`,
	DROP INDEX IF EXISTS `model_id_sede_emittente`,
	DROP INDEX IF EXISTS `model_importo_netto_totale`,
	DROP INDEX IF EXISTS `model_nome`,
	DROP INDEX IF EXISTS `model_ore_programmazione`,
	DROP INDEX IF EXISTS `model_quantita`,
	DROP INDEX IF EXISTS `model_sconto_percentuale`,
	DROP INDEX IF EXISTS `model_sconto_valore`,
	DROP INDEX IF EXISTS `model_se_automatico`,
	DROP INDEX IF EXISTS `model_settimana_programmazione`,
	DROP INDEX IF EXISTS `model_sezionale`,
	ADD KEY `model_id_causale` (`model_id_causale`),
	ADD KEY `model_id_collo` (`model_id_collo`),
	ADD KEY `model_id_sede_destinatario` (`model_id_sede_destinatario`),
	ADD KEY `model_id_sede_emittente` (`model_id_sede_emittente`);

-- | 202611042589

-- pianificazioni: vincoli nella forma del canone
ALTER TABLE `pianificazioni`
	ADD CONSTRAINT `pianificazioni_ibfk_01` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `pianificazioni_ibfk_02` FOREIGN KEY (`id_todo`) REFERENCES `todo` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `pianificazioni_ibfk_03` FOREIGN KEY (`id_attivita`) REFERENCES `attivita` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `pianificazioni_ibfk_05` FOREIGN KEY (`id_contratto`) REFERENCES `contratti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `pianificazioni_ibfk_06_nofollow` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042590

-- popup: indici nella forma del canone
ALTER TABLE `popup`
	DROP INDEX IF EXISTS `html_id`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `se_ovunque`,
	DROP INDEX IF EXISTS `template`,
	ADD KEY `html_id` (`html_id`),
	ADD KEY `indice` (`id`,`id_tipologia`,`nome`,`html_id`,`n_secondi`,`n_scroll`,`template`,`schema_html`),
	ADD KEY `nome` (`nome`),
	ADD KEY `se_ovunque` (`se_ovunque`),
	ADD KEY `template` (`template`);

-- | 202611042591

-- prezzi: via i vincoli che cambiano
ALTER TABLE `prezzi`
	DROP FOREIGN KEY IF EXISTS `prezzi_ibfk_03_nofollow`,
	DROP FOREIGN KEY IF EXISTS `prezzi_ibfk_04_nofollow`,
	DROP FOREIGN KEY IF EXISTS `prezzi_ibfk_05_nofollow`;

-- | 202611042592

-- prezzi: indici nella forma del canone
ALTER TABLE `prezzi`
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `indice` (`id`,`id_listino`,`id_prodotto`,`id_articolo`,`qta_min`,`qta_max`,`data_inizio`,`data_fine`,`prezzo`,`id_iva`);

-- | 202611042593

-- prezzi: vincoli nella forma del canone
ALTER TABLE `prezzi`
	ADD CONSTRAINT `prezzi_ibfk_03_nofollow` FOREIGN KEY (`id_listino`) REFERENCES `listini` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `prezzi_ibfk_04_nofollow` FOREIGN KEY (`id_iva`) REFERENCES `iva` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `prezzi_ibfk_05_nofollow` FOREIGN KEY (`id_reparto`) REFERENCES `reparti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042594

-- prodotti: via i vincoli che cambiano
ALTER TABLE `prodotti`
	DROP FOREIGN KEY IF EXISTS `prodotti_ibfk_01`,
	DROP FOREIGN KEY IF EXISTS `prodotti_ibfk_01_nofollow`;

-- | 202611042595

-- prodotti: indici nella forma del canone
ALTER TABLE `prodotti`
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `indice` (`id`,`id_tipologia`,`codice`,`nome`,`id_marchio`,`id_sito`,`id_pagina`);

-- | 202611042596

-- prodotti: vincoli nella forma del canone
ALTER TABLE `prodotti`
	ADD CONSTRAINT `prodotti_ibfk_01_nofollow` FOREIGN KEY (`id_marchio`) REFERENCES `marchi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042597

-- prodotti_caratteristiche: indici nella forma del canone
ALTER TABLE `prodotti_caratteristiche`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `unica`,
	ADD KEY `indice` (`id`,`ordine`,`id_prodotto`,`id_caratteristica`,`id_lingua`),
	ADD UNIQUE KEY `unica` (`id_prodotto`,`id_caratteristica`,`id_lingua`);

-- | 202611042598

-- prodotti_categorie: via i vincoli che cambiano
ALTER TABLE `prodotti_categorie`
	DROP FOREIGN KEY IF EXISTS `prodotti_categorie_ibfk_03_nofollow`;

-- | 202611042599

-- prodotti_categorie: indici nella forma del canone
ALTER TABLE `prodotti_categorie`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	ADD KEY `indice` (`id`,`id_prodotto`,`id_categoria`,`ordine`),
	ADD KEY `ordine` (`ordine`);

-- | 202611042600

-- progetti: via i vincoli che cambiano
ALTER TABLE `progetti`
	DROP FOREIGN KEY IF EXISTS `progetti_ibfk_05_nofollow`;

-- | 202611042601

-- progetti: indici nella forma del canone
ALTER TABLE `progetti`
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `indice` (`id`,`id_tipologia`,`codice`,`nome`,`id_cliente`,`id_sito`,`id_pagina`,`data_accettazione`,`data_apertura`,`data_chiusura`,`data_archiviazione`);

-- | 202611042602

-- progetti_anagrafica: indici nella forma del canone
ALTER TABLE `progetti_anagrafica`
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `indice` (`id`,`ordine`,`id_progetto`,`id_anagrafica`,`id_ruolo`);

-- | 202611042603

-- progetti_certificazioni: indici nella forma del canone
ALTER TABLE `progetti_certificazioni`
	DROP INDEX IF EXISTS `id_ruolo`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `unica`,
	ADD KEY `id_ruolo` (`id_ruolo`),
	ADD KEY `indice` (`id`,`ordine`,`id_progetto`,`id_certificazione`,`id_ruolo`),
	ADD UNIQUE KEY `unica` (`id_progetto`,`id_certificazione`,`id_ruolo`);

-- | 202611042604

-- progetti_matricole: indici nella forma del canone
ALTER TABLE `progetti_matricole`
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `indice` (`id`,`ordine`,`id_progetto`,`id_matricola`,`id_ruolo`);

-- | 202611042605

-- provincie: via i vincoli che cambiano
ALTER TABLE `provincie`
	DROP FOREIGN KEY IF EXISTS `provincie_ibfk_01_nofollow`,
	DROP FOREIGN KEY IF EXISTS `provincie_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `provincie_ibfk_99_nofollow`;

-- | 202611042606

-- provincie: indici nella forma del canone
ALTER TABLE `provincie`
	DROP INDEX IF EXISTS `codice_istat`,
	DROP INDEX IF EXISTS `data_archiviazione`,
	DROP INDEX IF EXISTS `id_successore`,
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `data_archiviazione` (`data_archiviazione`),
	ADD KEY `id_successore` (`id_successore`),
	ADD KEY `indice` (`id`,`nome`,`id_regione`,`sigla`,`codice_istat`);

-- | 202611042607

-- provincie: vincoli nella forma del canone
ALTER TABLE `provincie`
	ADD CONSTRAINT `provincie_ibfk_01_nofollow` FOREIGN KEY (`id_regione`) REFERENCES `regioni` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042608

-- pubblicazioni: via i vincoli che cambiano
ALTER TABLE `pubblicazioni`
	DROP FOREIGN KEY IF EXISTS `pubblicazioni_ibfk_02`,
	DROP FOREIGN KEY IF EXISTS `pubblicazioni_ibfk_03`,
	DROP FOREIGN KEY IF EXISTS `pubblicazioni_ibfk_06`,
	DROP FOREIGN KEY IF EXISTS `pubblicazioni_ibfk_07`,
	DROP FOREIGN KEY IF EXISTS `pubblicazioni_ibfk_08`,
	DROP FOREIGN KEY IF EXISTS `pubblicazioni_ibfk_09`,
	DROP FOREIGN KEY IF EXISTS `pubblicazioni_ibfk_10`,
	DROP FOREIGN KEY IF EXISTS `pubblicazioni_ibfk_11`,
	DROP FOREIGN KEY IF EXISTS `pubblicazioni_ibfk_12`,
	DROP FOREIGN KEY IF EXISTS `pubblicazioni_ibfk_13`,
	DROP FOREIGN KEY IF EXISTS `pubblicazioni_ibfk_14`,
	DROP FOREIGN KEY IF EXISTS `pubblicazioni_ibfk_15`,
	DROP FOREIGN KEY IF EXISTS `pubblicazioni_ibfk_16`,
	DROP FOREIGN KEY IF EXISTS `pubblicazioni_ibfk_17`;

-- | 202611042609

-- pubblicazioni: indici nella forma del canone
ALTER TABLE `pubblicazioni`
	DROP INDEX IF EXISTS `id_categoria_marchi`,
	DROP INDEX IF EXISTS `id_sito`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	DROP INDEX IF EXISTS `spazio`,
	DROP INDEX IF EXISTS `template`,
	DROP INDEX IF EXISTS `timestamp_fine`,
	DROP INDEX IF EXISTS `timestamp_inizio`,
	ADD KEY `id_categoria_marchi` (`id_categoria_marchi`),
	ADD KEY `id_sito` (`id_sito`),
	ADD KEY `indice` (`id`,`id_tipologia`,`ordine`,`id_sito`,`timestamp_inizio`,`timestamp_fine`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `spazio` (`spazio`),
	ADD KEY `template` (`template`),
	ADD KEY `timestamp_fine` (`timestamp_fine`),
	ADD KEY `timestamp_inizio` (`timestamp_inizio`);

-- | 202611042610

-- pubblicazioni: vincoli nella forma del canone
ALTER TABLE `pubblicazioni`
	ADD CONSTRAINT `pubblicazioni_ibfk_02` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `pubblicazioni_ibfk_03` FOREIGN KEY (`id_popup`) REFERENCES `popup` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `pubblicazioni_ibfk_06` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `pubblicazioni_ibfk_07` FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `pubblicazioni_ibfk_08` FOREIGN KEY (`id_marchio`) REFERENCES `marchi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `pubblicazioni_ibfk_09` FOREIGN KEY (`id_categoria_marchi`) REFERENCES `categorie_marchi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `pubblicazioni_ibfk_10` FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `pubblicazioni_ibfk_11` FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `pubblicazioni_ibfk_12` FOREIGN KEY (`id_annuncio`) REFERENCES `annunci` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `pubblicazioni_ibfk_13` FOREIGN KEY (`id_categoria_annunci`) REFERENCES `categorie_annunci` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `pubblicazioni_ibfk_14` FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `pubblicazioni_ibfk_15` FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `pubblicazioni_ibfk_16` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `pubblicazioni_ibfk_17` FOREIGN KEY (`id_categoria_progetti`) REFERENCES `categorie_progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042611

-- ranking: indici nella forma del canone
ALTER TABLE `ranking`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `se_collaboratore`,
	DROP INDEX IF EXISTS `se_corriere`,
	DROP INDEX IF EXISTS `se_partner`,
	DROP INDEX IF EXISTS `se_produttore`,
	ADD KEY `indice` (`id`,`ordine`,`nome`,`se_cliente`,`se_fornitore`,`se_produttore`,`se_corriere`,`se_collaboratore`,`se_partner`),
	ADD KEY `se_collaboratore` (`se_collaboratore`),
	ADD KEY `se_corriere` (`se_corriere`),
	ADD KEY `se_partner` (`se_partner`),
	ADD KEY `se_produttore` (`se_produttore`);

-- | 202611042612

-- recensioni: via i vincoli che cambiano
ALTER TABLE `recensioni`
	DROP FOREIGN KEY IF EXISTS `recensioni_ibfk_01_nofollow`,
	DROP FOREIGN KEY IF EXISTS `recensioni_ibfk_02_nofollow`,
	DROP FOREIGN KEY IF EXISTS `recensioni_ibfk_03`,
	DROP FOREIGN KEY IF EXISTS `recensioni_ibfk_03_nofollow`,
	DROP FOREIGN KEY IF EXISTS `recensioni_ibfk_04`,
	DROP FOREIGN KEY IF EXISTS `recensioni_ibfk_04_nofollow`,
	DROP FOREIGN KEY IF EXISTS `recensioni_ibfk_05_nofollow`,
	DROP FOREIGN KEY IF EXISTS `recensioni_ibfk_06_nofollow`,
	DROP FOREIGN KEY IF EXISTS `recensioni_ibfk_07`,
	DROP FOREIGN KEY IF EXISTS `recensioni_ibfk_07_nofollow`,
	DROP FOREIGN KEY IF EXISTS `recensioni_ibfk_08`,
	DROP FOREIGN KEY IF EXISTS `recensioni_ibfk_08_nofollow`,
	DROP FOREIGN KEY IF EXISTS `recensioni_ibfk_11`,
	DROP FOREIGN KEY IF EXISTS `recensioni_ibfk_13`,
	DROP FOREIGN KEY IF EXISTS `recensioni_ibfk_14`;

-- | 202611042613

-- recensioni: indici nella forma del canone
ALTER TABLE `recensioni`
	DROP INDEX IF EXISTS `id_account`,
	DROP INDEX IF EXISTS `id_annuncio`,
	DROP INDEX IF EXISTS `id_categoria_annunci`,
	DROP INDEX IF EXISTS `id_categoria_marchi`,
	DROP INDEX IF EXISTS `id_categoria_progetti`,
	DROP INDEX IF EXISTS `id_categoria_risorse`,
	DROP INDEX IF EXISTS `id_marchio`,
	DROP INDEX IF EXISTS `id_progetto`,
	DROP INDEX IF EXISTS `se_approvata`,
	ADD KEY `id_account` (`id_account`),
	ADD KEY `id_annuncio` (`id_annuncio`),
	ADD KEY `id_categoria_annunci` (`id_categoria_annunci`),
	ADD KEY `id_categoria_marchi` (`id_categoria_marchi`),
	ADD KEY `id_categoria_progetti` (`id_categoria_progetti`),
	ADD KEY `id_categoria_risorse` (`id_categoria_risorse`),
	ADD KEY `id_marchio` (`id_marchio`),
	ADD KEY `id_progetto` (`id_progetto`),
	ADD KEY `se_approvata` (`se_approvata`);

-- | 202611042614

-- recensioni: vincoli nella forma del canone
ALTER TABLE `recensioni`
	ADD CONSTRAINT `recensioni_ibfk_01_nofollow` FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `recensioni_ibfk_03` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `recensioni_ibfk_04` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `recensioni_ibfk_05_nofollow` FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `recensioni_ibfk_07` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `recensioni_ibfk_08` FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `recensioni_ibfk_11` FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `recensioni_ibfk_13` FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `recensioni_ibfk_14` FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042615

-- redirect: indici nella forma del canone
ALTER TABLE `redirect`
	DROP INDEX IF EXISTS `id_sito`;

-- | 202611042616

-- regimi: via i vincoli che cambiano
ALTER TABLE `regimi`
	DROP FOREIGN KEY IF EXISTS `regimi_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `regimi_ibfk_99_nofollow`;

-- | 202611042617

-- regimi: indici nella forma del canone
ALTER TABLE `regimi`
	DROP INDEX IF EXISTS `codice_sdi`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `unica`,
	ADD UNIQUE KEY `codice_sdi` (`codice_sdi`),
	ADD KEY `indice` (`id`,`nome`,`codice_sdi`),
	ADD UNIQUE KEY `nome` (`nome`);

-- | 202611042618

-- regioni: via i vincoli che cambiano
ALTER TABLE `regioni`
	DROP FOREIGN KEY IF EXISTS `regioni_ibfk_01_nofollow`,
	DROP FOREIGN KEY IF EXISTS `regioni_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `regioni_ibfk_99_nofollow`;

-- | 202611042619

-- regioni: indici nella forma del canone
ALTER TABLE `regioni`
	DROP INDEX IF EXISTS `data_archiviazione`,
	DROP INDEX IF EXISTS `id_successore`,
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `data_archiviazione` (`data_archiviazione`),
	ADD KEY `id_successore` (`id_successore`),
	ADD KEY `indice` (`id`,`nome`,`id_stato`,`codice_istat`);

-- | 202611042620

-- regioni: vincoli nella forma del canone
ALTER TABLE `regioni`
	ADD CONSTRAINT `regioni_ibfk_01_nofollow` FOREIGN KEY (`id_stato`) REFERENCES `stati` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042621

-- relazioni_anagrafica: indici nella forma del canone
ALTER TABLE `relazioni_anagrafica`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	DROP INDEX IF EXISTS `unica`,
	DROP INDEX IF EXISTS `unico`,
	ADD KEY `indice` (`id`,`ordine`,`id_anagrafica`,`id_anagrafica_collegata`,`id_ruolo`),
	ADD KEY `ordine` (`ordine`),
	ADD UNIQUE KEY `unica` (`id_anagrafica`,`id_anagrafica_collegata`,`id_ruolo`);

-- | 202611042622

-- relazioni_articoli: via i vincoli che cambiano
ALTER TABLE `relazioni_articoli`
	DROP FOREIGN KEY IF EXISTS `relazioni_articoli_ibfk_04`;

-- | 202611042623

-- relazioni_articoli: indici nella forma del canone
ALTER TABLE `relazioni_articoli`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	DROP INDEX IF EXISTS `unica_articolo`,
	DROP INDEX IF EXISTS `unica_prodotto`,
	DROP INDEX IF EXISTS `unico`,
	ADD KEY `indice` (`id`,`ordine`,`id_articolo`,`id_articolo_collegato`,`id_prodotto_collegato`,`id_ruolo`),
	ADD KEY `ordine` (`ordine`),
	ADD UNIQUE KEY `unica_articolo` (`id_articolo`,`id_articolo_collegato`,`id_ruolo`),
	ADD UNIQUE KEY `unica_prodotto` (`id_articolo`,`id_prodotto_collegato`,`id_ruolo`);

-- | 202611042624

-- relazioni_articoli: vincoli nella forma del canone
ALTER TABLE `relazioni_articoli`
	ADD CONSTRAINT `relazioni_articoli_ibfk_04` FOREIGN KEY (`id_prodotto_collegato`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042625

-- relazioni_categorie_progetti: via i vincoli che cambiano
ALTER TABLE `relazioni_categorie_progetti`
	DROP FOREIGN KEY IF EXISTS `relazioni_categorie_progetti_ibfk_03_nofollow`;

-- | 202611042626

-- relazioni_categorie_progetti: indici nella forma del canone
ALTER TABLE `relazioni_categorie_progetti`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	DROP INDEX IF EXISTS `unica`,
	DROP INDEX IF EXISTS `unico`,
	ADD KEY `indice` (`id`,`ordine`,`id_categoria`,`id_categoria_collegata`,`id_ruolo`),
	ADD KEY `ordine` (`ordine`),
	ADD UNIQUE KEY `unica` (`id_categoria`,`id_categoria_collegata`,`id_ruolo`);

-- | 202611042627

-- relazioni_categorie_progetti: vincoli nella forma del canone
ALTER TABLE `relazioni_categorie_progetti`
	ADD CONSTRAINT `relazioni_categorie_progetti_ibfk_03_nofollow` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_categorie_progetti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042628

-- relazioni_documenti: indici nella forma del canone
ALTER TABLE `relazioni_documenti`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	ADD KEY `indice` (`id`,`ordine`,`id_documento`,`id_documento_collegato`,`id_ruolo`),
	ADD KEY `ordine` (`ordine`);

-- | 202611042629

-- relazioni_documenti_articoli: indici nella forma del canone
ALTER TABLE `relazioni_documenti_articoli`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	DROP INDEX IF EXISTS `unica`,
	DROP INDEX IF EXISTS `unico`,
	ADD KEY `indice` (`id`,`ordine`,`id_documenti_articolo`,`id_documenti_articolo_collegato`,`id_ruolo`),
	ADD KEY `ordine` (`ordine`),
	ADD UNIQUE KEY `unica` (`id_documenti_articolo`,`id_documenti_articolo_collegato`,`id_ruolo`);

-- | 202611042630

-- relazioni_pagamenti: indici nella forma del canone
ALTER TABLE `relazioni_pagamenti`
	DROP INDEX IF EXISTS `id_ruolo`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	DROP INDEX IF EXISTS `unica`,
	DROP INDEX IF EXISTS `unico`,
	ADD KEY `id_ruolo` (`id_ruolo`),
	ADD KEY `indice` (`id`,`ordine`,`id_pagamento`,`id_pagamento_collegato`,`id_ruolo`),
	ADD KEY `ordine` (`ordine`),
	ADD UNIQUE KEY `unica` (`id_pagamento`,`id_pagamento_collegato`,`id_ruolo`);

-- | 202611042631

-- relazioni_prodotti: via i vincoli che cambiano
ALTER TABLE `relazioni_prodotti`
	DROP FOREIGN KEY IF EXISTS `relazioni_prodotti_ibfk_04_nofollow`;

-- | 202611042632

-- relazioni_prodotti: indici nella forma del canone
ALTER TABLE `relazioni_prodotti`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	DROP INDEX IF EXISTS `unica_articolo`,
	DROP INDEX IF EXISTS `unica_prodotto`,
	DROP INDEX IF EXISTS `unico`,
	ADD KEY `indice` (`id`,`ordine`,`id_prodotto`,`id_prodotto_collegato`,`id_articolo_collegato`,`id_ruolo`),
	ADD KEY `ordine` (`ordine`),
	ADD UNIQUE KEY `unica_articolo` (`id_prodotto`,`id_articolo_collegato`,`id_ruolo`),
	ADD UNIQUE KEY `unica_prodotto` (`id_prodotto`,`id_prodotto_collegato`,`id_ruolo`);

-- | 202611042633

-- relazioni_prodotti: vincoli nella forma del canone
ALTER TABLE `relazioni_prodotti`
	ADD CONSTRAINT `relazioni_prodotti_ibfk_04_nofollow` FOREIGN KEY (`id_articolo_collegato`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042634

-- relazioni_progetti: indici nella forma del canone
ALTER TABLE `relazioni_progetti`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	DROP INDEX IF EXISTS `unica`,
	DROP INDEX IF EXISTS `unico`,
	ADD KEY `indice` (`id`,`ordine`,`id_progetto`,`id_progetto_collegato`,`id_ruolo`),
	ADD KEY `ordine` (`ordine`),
	ADD UNIQUE KEY `unica` (`id_progetto`,`id_progetto_collegato`,`id_ruolo`);

-- | 202611042635

-- relazioni_software: indici nella forma del canone
ALTER TABLE `relazioni_software`
	DROP INDEX IF EXISTS `id_ruolo`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	DROP INDEX IF EXISTS `unica`,
	DROP INDEX IF EXISTS `unico`,
	ADD KEY `id_ruolo` (`id_ruolo`),
	ADD KEY `indice` (`id`,`ordine`,`id_software`,`id_software_collegato`,`id_ruolo`),
	ADD KEY `ordine` (`ordine`),
	ADD UNIQUE KEY `unica` (`id_software`,`id_software_collegato`,`id_ruolo`);

-- | 202611042636

-- relazioni_step: via i vincoli che cambiano
ALTER TABLE `relazioni_step`
	DROP FOREIGN KEY IF EXISTS `relazioni_step_ibfk_01`,
	DROP FOREIGN KEY IF EXISTS `relazioni_step_ibfk_02`,
	DROP FOREIGN KEY IF EXISTS `relazioni_step_ibfk_03_nofollow`,
	DROP FOREIGN KEY IF EXISTS `relazioni_step_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `relazioni_step_ibfk_99_nofollow`;

-- | 202611042637

-- relazioni_step: indici nella forma del canone
ALTER TABLE `relazioni_step`
	DROP INDEX IF EXISTS `id_account_aggiornamento`,
	DROP INDEX IF EXISTS `id_account_inserimento`,
	DROP INDEX IF EXISTS `id_ruolo`,
	DROP INDEX IF EXISTS `id_step`,
	DROP INDEX IF EXISTS `id_step_collegato`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_ruolo` (`id_ruolo`),
	ADD KEY `id_step` (`id_step`),
	ADD KEY `id_step_collegato` (`id_step_collegato`),
	ADD KEY `indice` (`id`,`ordine`,`id_step`,`id_step_collegato`,`id_ruolo`),
	ADD KEY `ordine` (`ordine`);

-- | 202611042638

-- relazioni_step: vincoli nella forma del canone
ALTER TABLE `relazioni_step`
	ADD CONSTRAINT `relazioni_step_ibfk_01` FOREIGN KEY (`id_step`) REFERENCES `step` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `relazioni_step_ibfk_02` FOREIGN KEY (`id_step_collegato`) REFERENCES `step` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `relazioni_step_ibfk_03_nofollow` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_step` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `relazioni_step_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `relazioni_step_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042639

-- reparti: via i vincoli che cambiano
ALTER TABLE `reparti`
	DROP FOREIGN KEY IF EXISTS `reparti_ibfk_01_nofollow`;

-- | 202611042640

-- reparti: indici nella forma del canone
ALTER TABLE `reparti`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `unica`,
	ADD KEY `indice` (`id`,`nome`,`id_iva`,`id_settore`),
	ADD UNIQUE KEY `unica` (`nome`);

-- | 202611042641

-- reparti: vincoli nella forma del canone
ALTER TABLE `reparti`
	ADD CONSTRAINT `reparti_ibfk_01_nofollow` FOREIGN KEY (`id_iva`) REFERENCES `iva` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042642

-- risorse: via i vincoli che cambiano
ALTER TABLE `risorse`
	DROP FOREIGN KEY IF EXISTS `risorse_ibfk_02_nofollow`,
	DROP FOREIGN KEY IF EXISTS `risorse_ibfk_03_nofollow`;

-- | 202611042643

-- risorse: indici nella forma del canone
ALTER TABLE `risorse`
	DROP INDEX IF EXISTS `data_archiviazione`,
	DROP INDEX IF EXISTS `id_pagina`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `nome`,
	ADD KEY `data_archiviazione` (`data_archiviazione`),
	ADD KEY `id_pagina` (`id_pagina`),
	ADD KEY `indice` (`id`,`id_tipologia`,`codice`,`nome`,`id_testata`,`anno_pubblicazione`,`id_sito`,`id_pagina`,`data_archiviazione`),
	ADD KEY `nome` (`nome`);

-- | 202611042644

-- risorse: vincoli nella forma del canone
ALTER TABLE `risorse`
	ADD CONSTRAINT `risorse_ibfk_02_nofollow` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `risorse_ibfk_03_nofollow` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042645

-- risorse_account: indici nella forma del canone
ALTER TABLE `risorse_account`
	DROP INDEX IF EXISTS `id_carrelli_articoli`,
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `id_carrelli_articoli` (`id_carrelli_articoli`),
	ADD KEY `indice` (`id`,`ordine`,`id_risorsa`,`id_account`,`id_carrelli_articoli`);

-- | 202611042646

-- risorse_anagrafica: indici nella forma del canone
ALTER TABLE `risorse_anagrafica`
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `indice` (`id`,`ordine`,`id_risorsa`,`id_anagrafica`,`id_ruolo`);

-- | 202611042647

-- risorse_categorie: indici nella forma del canone
ALTER TABLE `risorse_categorie`
	DROP INDEX IF EXISTS `unica`,
	ADD UNIQUE KEY `unica` (`id_risorsa`,`id_categoria`);

-- | 202611042648

-- risorse_organizzazioni: via i vincoli che cambiano
ALTER TABLE `risorse_organizzazioni`
	DROP FOREIGN KEY IF EXISTS `risorse_organizzazioni_ibfk_01`,
	DROP FOREIGN KEY IF EXISTS `risorse_organizzazioni_ibfk_02_nofollow`,
	DROP FOREIGN KEY IF EXISTS `risorse_organizzazioni_ibfk_03_nofollow`,
	DROP FOREIGN KEY IF EXISTS `risorse_organizzazioni_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `risorse_organizzazioni_ibfk_99_nofollow`;

-- | 202611042649

-- risorse_organizzazioni: indici nella forma del canone
ALTER TABLE `risorse_organizzazioni`
	DROP INDEX IF EXISTS `id_account_aggiornamento`,
	DROP INDEX IF EXISTS `id_account_inserimento`,
	DROP INDEX IF EXISTS `id_organizzazione`,
	DROP INDEX IF EXISTS `id_risorsa`,
	DROP INDEX IF EXISTS `id_ruolo`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_organizzazione` (`id_organizzazione`),
	ADD KEY `id_risorsa` (`id_risorsa`),
	ADD KEY `id_ruolo` (`id_ruolo`),
	ADD KEY `indice` (`id`,`ordine`,`id_risorsa`,`id_organizzazione`,`id_ruolo`),
	ADD KEY `ordine` (`ordine`);

-- | 202611042650

-- risorse_organizzazioni: vincoli nella forma del canone
ALTER TABLE `risorse_organizzazioni`
	ADD CONSTRAINT `risorse_organizzazioni_ibfk_01` FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `risorse_organizzazioni_ibfk_02_nofollow` FOREIGN KEY (`id_organizzazione`) REFERENCES `organizzazioni` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `risorse_organizzazioni_ibfk_03_nofollow` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_risorse` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `risorse_organizzazioni_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `risorse_organizzazioni_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042651

-- ritenute: via i vincoli che cambiano
ALTER TABLE `ritenute`
	DROP FOREIGN KEY IF EXISTS `ritenute_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `ritenute_ibfk_99_nofollow`;

-- | 202611042652

-- ritenute: indici nella forma del canone
ALTER TABLE `ritenute`
	DROP INDEX IF EXISTS `codice`,
	DROP INDEX IF EXISTS `codice_sdi`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `nome`,
	ADD UNIQUE KEY `codice_sdi` (`codice_sdi`),
	ADD KEY `indice` (`id`,`nome`,`codice_sdi`),
	ADD UNIQUE KEY `nome` (`nome`);

-- | 202611042653

-- ruoli_anagrafica: via i vincoli che cambiano
ALTER TABLE `ruoli_anagrafica`
	DROP FOREIGN KEY IF EXISTS `ruoli_anagrafica_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `ruoli_anagrafica_ibfk_99_nofollow`;

-- | 202611042654

-- ruoli_anagrafica: indici nella forma del canone
ALTER TABLE `ruoli_anagrafica`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `unica`,
	ADD KEY `indice` (`id`,`id_genitore`,`nome`,`html_entity`,`font_awesome`),
	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`);

-- | 202611042655

-- ruoli_articoli: via i vincoli che cambiano
ALTER TABLE `ruoli_articoli`
	DROP FOREIGN KEY IF EXISTS `ruoli_articoli_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `ruoli_articoli_ibfk_99_nofollow`;

-- | 202611042656

-- ruoli_articoli: indici nella forma del canone
ALTER TABLE `ruoli_articoli`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `unica`,
	ADD KEY `indice` (`id`,`id_genitore`,`nome`,`html_entity`,`font_awesome`),
	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`);

-- | 202611042657

-- ruoli_audio: via i vincoli che cambiano
ALTER TABLE `ruoli_audio`
	DROP FOREIGN KEY IF EXISTS `ruoli_audio_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `ruoli_audio_ibfk_99_nofollow`;

-- | 202611042658

-- ruoli_audio: indici nella forma del canone
ALTER TABLE `ruoli_audio`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `unica`,
	ADD KEY `indice` (`id`,`id_genitore`,`nome`,`html_entity`,`font_awesome`),
	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`);

-- | 202611042659

-- ruoli_categorie_progetti: via i vincoli che cambiano
ALTER TABLE `ruoli_categorie_progetti`
	DROP FOREIGN KEY IF EXISTS `ruoli_categorie_progetti_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `ruoli_categorie_progetti_ibfk_99_nofollow`;

-- | 202611042660

-- ruoli_categorie_progetti: indici nella forma del canone
ALTER TABLE `ruoli_categorie_progetti`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `se_recuperi`,
	DROP INDEX IF EXISTS `unica`,
	ADD KEY `indice` (`id`,`id_genitore`,`nome`,`html_entity`,`font_awesome`),
	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`);

-- | 202611042661

-- ruoli_certificazioni: via i vincoli che cambiano
ALTER TABLE `ruoli_certificazioni`
	DROP FOREIGN KEY IF EXISTS `ruoli_certificazioni_ibfk_01_nofollow`;

-- | 202611042662

-- ruoli_certificazioni: indici nella forma del canone
ALTER TABLE `ruoli_certificazioni`
	DROP INDEX IF EXISTS `id_genitore`,
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `indice` (`id`,`id_genitore`,`nome`,`html_entity`,`font_awesome`);

-- | 202611042663

-- ruoli_certificazioni: vincoli nella forma del canone
ALTER TABLE `ruoli_certificazioni`
	ADD CONSTRAINT `ruoli_certificazioni_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `ruoli_certificazioni` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042664

-- ruoli_conversazioni: via i vincoli che cambiano
ALTER TABLE `ruoli_conversazioni`
	DROP FOREIGN KEY IF EXISTS `ruoli_conversazioni_ibfk_01_nofollow`;

-- | 202611042665

-- ruoli_conversazioni: indici nella forma del canone
ALTER TABLE `ruoli_conversazioni`
	DROP INDEX IF EXISTS `id_genitore`,
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `indice` (`id`,`id_genitore`,`nome`,`html_entity`,`font_awesome`);

-- | 202611042666

-- ruoli_conversazioni: vincoli nella forma del canone
ALTER TABLE `ruoli_conversazioni`
	ADD CONSTRAINT `ruoli_conversazioni_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `ruoli_conversazioni` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042667

-- ruoli_documenti: via i vincoli che cambiano
ALTER TABLE `ruoli_documenti`
	DROP FOREIGN KEY IF EXISTS `ruoli_documenti_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `ruoli_documenti_ibfk_99_nofollow`;

-- | 202611042668

-- ruoli_documenti: indici nella forma del canone
ALTER TABLE `ruoli_documenti`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `unica`,
	ADD KEY `indice` (`id`,`id_genitore`,`nome`,`html_entity`,`font_awesome`),
	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`);

-- | 202611042669

-- ruoli_file: via i vincoli che cambiano
ALTER TABLE `ruoli_file`
	DROP FOREIGN KEY IF EXISTS `ruoli_file_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `ruoli_file_ibfk_99_nofollow`;

-- | 202611042670

-- ruoli_file: indici nella forma del canone
ALTER TABLE `ruoli_file`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `unica`,
	ADD KEY `indice` (`id`,`id_genitore`,`nome`,`html_entity`,`font_awesome`),
	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`);

-- | 202611042671

-- ruoli_immagini: via i vincoli che cambiano
ALTER TABLE `ruoli_immagini`
	DROP FOREIGN KEY IF EXISTS `ruoli_immagini_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `ruoli_immagini_ibfk_99_nofollow`;

-- | 202611042672

-- ruoli_immagini: indici nella forma del canone
ALTER TABLE `ruoli_immagini`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `unica`,
	ADD KEY `indice` (`id`,`id_genitore`,`nome`,`html_entity`,`font_awesome`),
	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`);

-- | 202611042673

-- ruoli_indirizzi: via i vincoli che cambiano
ALTER TABLE `ruoli_indirizzi`
	DROP FOREIGN KEY IF EXISTS `ruoli_indirizzi_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `ruoli_indirizzi_ibfk_99_nofollow`;

-- | 202611042674

-- ruoli_indirizzi: indici nella forma del canone
ALTER TABLE `ruoli_indirizzi`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `se_domicilio`,
	DROP INDEX IF EXISTS `se_residenza`,
	DROP INDEX IF EXISTS `se_sede_legale`,
	DROP INDEX IF EXISTS `se_sede_operativa`,
	DROP INDEX IF EXISTS `unica`,
	ADD KEY `indice` (`id`,`id_genitore`,`nome`,`html_entity`,`font_awesome`),
	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`);

-- | 202611042675

-- ruoli_mail: via i vincoli che cambiano
ALTER TABLE `ruoli_mail`
	DROP FOREIGN KEY IF EXISTS `ruoli_mail_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `ruoli_mail_ibfk_99_nofollow`;

-- | 202611042676

-- ruoli_mail: indici nella forma del canone
ALTER TABLE `ruoli_mail`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `unica`,
	ADD KEY `indice` (`id`,`id_genitore`,`nome`,`html_entity`,`font_awesome`),
	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`);

-- | 202611042677

-- ruoli_mastri: via i vincoli che cambiano
ALTER TABLE `ruoli_mastri`
	DROP FOREIGN KEY IF EXISTS `ruoli_mastri_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `ruoli_mastri_ibfk_99_nofollow`;

-- | 202611042678

-- ruoli_mastri: indici nella forma del canone
ALTER TABLE `ruoli_mastri`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `unica`,
	ADD KEY `indice` (`id`,`id_genitore`,`nome`,`html_entity`,`font_awesome`),
	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`);

-- | 202611042679

-- ruoli_matricole: via i vincoli che cambiano
ALTER TABLE `ruoli_matricole`
	DROP FOREIGN KEY IF EXISTS `ruoli_matricole_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `ruoli_matricole_ibfk_99_nofollow`;

-- | 202611042680

-- ruoli_matricole: indici nella forma del canone
ALTER TABLE `ruoli_matricole`
	DROP INDEX IF EXISTS `unica`,
	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`);

-- | 202611042681

-- ruoli_pagamenti: via i vincoli che cambiano
ALTER TABLE `ruoli_pagamenti`
	DROP FOREIGN KEY IF EXISTS `ruoli_pagamenti_ibfk_01_nofollow`;

-- | 202611042682

-- ruoli_pagamenti: indici nella forma del canone
ALTER TABLE `ruoli_pagamenti`
	DROP INDEX IF EXISTS `id_genitore`,
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `indice` (`id`,`id_genitore`,`nome`,`html_entity`,`font_awesome`);

-- | 202611042683

-- ruoli_pagamenti: vincoli nella forma del canone
ALTER TABLE `ruoli_pagamenti`
	ADD CONSTRAINT `ruoli_pagamenti_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `ruoli_pagamenti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042684

-- ruoli_prodotti: via i vincoli che cambiano
ALTER TABLE `ruoli_prodotti`
	DROP FOREIGN KEY IF EXISTS `ruoli_prodotti_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `ruoli_prodotti_ibfk_99_nofollow`;

-- | 202611042685

-- ruoli_prodotti: indici nella forma del canone
ALTER TABLE `ruoli_prodotti`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `unica`,
	ADD KEY `indice` (`id`,`id_genitore`,`nome`,`html_entity`,`font_awesome`),
	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`);

-- | 202611042686

-- ruoli_progetti: via i vincoli che cambiano
ALTER TABLE `ruoli_progetti`
	DROP FOREIGN KEY IF EXISTS `ruoli_progetti_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `ruoli_progetti_ibfk_99_nofollow`;

-- | 202611042687

-- ruoli_progetti: indici nella forma del canone
ALTER TABLE `ruoli_progetti`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `se_attesa`,
	DROP INDEX IF EXISTS `se_proseguimento`,
	DROP INDEX IF EXISTS `se_sottoprogetto`,
	DROP INDEX IF EXISTS `unica`,
	ADD KEY `indice` (`id`,`id_genitore`,`nome`,`html_entity`,`font_awesome`),
	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`);

-- | 202611042688

-- ruoli_risorse: via i vincoli che cambiano
ALTER TABLE `ruoli_risorse`
	DROP FOREIGN KEY IF EXISTS `ruoli_risorse_ibfk_01_nofollow`;

-- | 202611042689

-- ruoli_risorse: indici nella forma del canone
ALTER TABLE `ruoli_risorse`
	DROP INDEX IF EXISTS `id_genitore`,
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `indice` (`id`,`id_genitore`,`nome`,`html_entity`,`font_awesome`);

-- | 202611042690

-- ruoli_risorse: vincoli nella forma del canone
ALTER TABLE `ruoli_risorse`
	ADD CONSTRAINT `ruoli_risorse_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `ruoli_risorse` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042691

-- ruoli_software: via i vincoli che cambiano
ALTER TABLE `ruoli_software`
	DROP FOREIGN KEY IF EXISTS `ruoli_software_ibfk_01_nofollow`;

-- | 202611042692

-- ruoli_software: indici nella forma del canone
ALTER TABLE `ruoli_software`
	DROP INDEX IF EXISTS `id_genitore`,
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `indice` (`id`,`id_genitore`,`nome`,`html_entity`,`font_awesome`);

-- | 202611042693

-- ruoli_software: vincoli nella forma del canone
ALTER TABLE `ruoli_software`
	ADD CONSTRAINT `ruoli_software_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `ruoli_software` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042694

-- ruoli_step: via i vincoli che cambiano
ALTER TABLE `ruoli_step`
	DROP FOREIGN KEY IF EXISTS `ruoli_step_ibfk_01_nofollow`;

-- | 202611042695

-- ruoli_step: indici nella forma del canone
ALTER TABLE `ruoli_step`
	DROP INDEX IF EXISTS `id_genitore`,
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `indice` (`id`,`id_genitore`,`nome`,`html_entity`,`font_awesome`);

-- | 202611042696

-- ruoli_step: vincoli nella forma del canone
ALTER TABLE `ruoli_step`
	ADD CONSTRAINT `ruoli_step_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `ruoli_step` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042697

-- ruoli_video: via i vincoli che cambiano
ALTER TABLE `ruoli_video`
	DROP FOREIGN KEY IF EXISTS `ruoli_video_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `ruoli_video_ibfk_99_nofollow`;

-- | 202611042698

-- ruoli_video: indici nella forma del canone
ALTER TABLE `ruoli_video`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `unica`,
	ADD KEY `indice` (`id`,`id_genitore`,`nome`,`html_entity`,`font_awesome`),
	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`);

-- | 202611042699

-- sconti: via i vincoli che cambiano
ALTER TABLE `sconti`
	DROP FOREIGN KEY IF EXISTS `sconti_ibfk_02`,
	DROP FOREIGN KEY IF EXISTS `sconti_ibfk_02_nofollow`;

-- | 202611042700

-- sconti: indici nella forma del canone
ALTER TABLE `sconti`
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `indice` (`id`,`id_tipologia`,`nome`,`id_valuta`,`sconto_percentuale`,`sconto_fisso`,`qta_min`,`timestamp_inizio`,`timestamp_fine`);

-- | 202611042701

-- sconti: vincoli nella forma del canone
ALTER TABLE `sconti`
	ADD CONSTRAINT `sconti_ibfk_02_nofollow` FOREIGN KEY (`id_valuta`) REFERENCES `valute` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042702

-- sconti_articoli: via i vincoli che cambiano
ALTER TABLE `sconti_articoli`
	DROP FOREIGN KEY IF EXISTS `sconti_articoli_ibfk_02`,
	DROP FOREIGN KEY IF EXISTS `sconti_articoli_ibfk_02_nofollow`;

-- | 202611042703

-- sconti_articoli: indici nella forma del canone
ALTER TABLE `sconti_articoli`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	ADD KEY `indice` (`id`,`ordine`,`id_sconto`,`id_articolo`),
	ADD KEY `ordine` (`ordine`);

-- | 202611042704

-- sconti_articoli: vincoli nella forma del canone
ALTER TABLE `sconti_articoli`
	ADD CONSTRAINT `sconti_articoli_ibfk_02_nofollow` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042705

-- sconti_categorie_prodotti: via i vincoli che cambiano
ALTER TABLE `sconti_categorie_prodotti`
	DROP FOREIGN KEY IF EXISTS `sconti_categorie_prodotti_ibfk_01`,
	DROP FOREIGN KEY IF EXISTS `sconti_categorie_prodotti_ibfk_02_nofollow`,
	DROP FOREIGN KEY IF EXISTS `sconti_categorie_prodotti_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `sconti_categorie_prodotti_ibfk_99_nofollow`;

-- | 202611042706

-- sconti_categorie_prodotti: indici nella forma del canone
ALTER TABLE `sconti_categorie_prodotti`
	DROP INDEX IF EXISTS `id_account_aggiornamento`,
	DROP INDEX IF EXISTS `id_account_inserimento`,
	DROP INDEX IF EXISTS `id_categoria`,
	DROP INDEX IF EXISTS `id_sconto`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_categoria` (`id_categoria`),
	ADD KEY `id_sconto` (`id_sconto`),
	ADD KEY `indice` (`id`,`ordine`,`id_sconto`,`id_categoria`),
	ADD KEY `ordine` (`ordine`);

-- | 202611042707

-- sconti_categorie_prodotti: vincoli nella forma del canone
ALTER TABLE `sconti_categorie_prodotti`
	ADD CONSTRAINT `sconti_categorie_prodotti_ibfk_01` FOREIGN KEY (`id_sconto`) REFERENCES `sconti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `sconti_categorie_prodotti_ibfk_02_nofollow` FOREIGN KEY (`id_categoria`) REFERENCES `categorie_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `sconti_categorie_prodotti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `sconti_categorie_prodotti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042708

-- sconti_listini: via i vincoli che cambiano
ALTER TABLE `sconti_listini`
	DROP FOREIGN KEY IF EXISTS `sconti_listini_ibfk_02`,
	DROP FOREIGN KEY IF EXISTS `sconti_listini_ibfk_02_nofollow`;

-- | 202611042709

-- sconti_listini: indici nella forma del canone
ALTER TABLE `sconti_listini`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	ADD KEY `indice` (`id`,`ordine`,`id_sconto`,`id_listino`),
	ADD KEY `ordine` (`ordine`);

-- | 202611042710

-- sconti_listini: vincoli nella forma del canone
ALTER TABLE `sconti_listini`
	ADD CONSTRAINT `sconti_listini_ibfk_02_nofollow` FOREIGN KEY (`id_listino`) REFERENCES `listini` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042711

-- sconti_marchi: via i vincoli che cambiano
ALTER TABLE `sconti_marchi`
	DROP FOREIGN KEY IF EXISTS `sconti_marchi_ibfk_01`,
	DROP FOREIGN KEY IF EXISTS `sconti_marchi_ibfk_02_nofollow`,
	DROP FOREIGN KEY IF EXISTS `sconti_marchi_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `sconti_marchi_ibfk_99_nofollow`;

-- | 202611042712

-- sconti_marchi: indici nella forma del canone
ALTER TABLE `sconti_marchi`
	DROP INDEX IF EXISTS `id_account_aggiornamento`,
	DROP INDEX IF EXISTS `id_account_inserimento`,
	DROP INDEX IF EXISTS `id_marchio`,
	DROP INDEX IF EXISTS `id_sconto`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_marchio` (`id_marchio`),
	ADD KEY `id_sconto` (`id_sconto`),
	ADD KEY `indice` (`id`,`ordine`,`id_sconto`,`id_marchio`),
	ADD KEY `ordine` (`ordine`);

-- | 202611042713

-- sconti_marchi: vincoli nella forma del canone
ALTER TABLE `sconti_marchi`
	ADD CONSTRAINT `sconti_marchi_ibfk_01` FOREIGN KEY (`id_sconto`) REFERENCES `sconti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `sconti_marchi_ibfk_02_nofollow` FOREIGN KEY (`id_marchio`) REFERENCES `marchi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `sconti_marchi_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `sconti_marchi_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042714

-- sconti_prodotti: via i vincoli che cambiano
ALTER TABLE `sconti_prodotti`
	DROP FOREIGN KEY IF EXISTS `sconti_prodotti_ibfk_01`,
	DROP FOREIGN KEY IF EXISTS `sconti_prodotti_ibfk_02_nofollow`,
	DROP FOREIGN KEY IF EXISTS `sconti_prodotti_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `sconti_prodotti_ibfk_99_nofollow`;

-- | 202611042715

-- sconti_prodotti: indici nella forma del canone
ALTER TABLE `sconti_prodotti`
	DROP INDEX IF EXISTS `id_account_aggiornamento`,
	DROP INDEX IF EXISTS `id_account_inserimento`,
	DROP INDEX IF EXISTS `id_prodotto`,
	DROP INDEX IF EXISTS `id_sconto`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_prodotto` (`id_prodotto`),
	ADD KEY `id_sconto` (`id_sconto`),
	ADD KEY `indice` (`id`,`ordine`,`id_sconto`,`id_prodotto`),
	ADD KEY `ordine` (`ordine`);

-- | 202611042716

-- sconti_prodotti: vincoli nella forma del canone
ALTER TABLE `sconti_prodotti`
	ADD CONSTRAINT `sconti_prodotti_ibfk_01` FOREIGN KEY (`id_sconto`) REFERENCES `sconti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `sconti_prodotti_ibfk_02_nofollow` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `sconti_prodotti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `sconti_prodotti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042717

-- settori: via i vincoli che cambiano
ALTER TABLE `settori`
	DROP FOREIGN KEY IF EXISTS `settori_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `settori_ibfk_99_nofollow`;

-- | 202611042718

-- settori: indici nella forma del canone
ALTER TABLE `settori`
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `indice` (`id`,`id_genitore`,`ateco`,`soprannome`);

-- | 202611042719

-- sms_out: indici nella forma del canone
ALTER TABLE `sms_out`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	DROP INDEX IF EXISTS `timestamp_invio`,
	DROP INDEX IF EXISTS `token`,
	ADD KEY `indice` (`id`,`ordine`,`tentativi`,`token`,`timestamp_invio`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `timestamp_invio` (`timestamp_invio`),
	ADD KEY `token` (`token`);

-- | 202611042720

-- sms_sent: indici nella forma del canone
ALTER TABLE `sms_sent`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	DROP INDEX IF EXISTS `timestamp_invio`,
	DROP INDEX IF EXISTS `token`,
	ADD KEY `indice` (`id`,`ordine`,`tentativi`,`token`,`timestamp_invio`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `timestamp_invio` (`timestamp_invio`),
	ADD KEY `token` (`token`);

-- | 202611042721

-- software: via i vincoli che cambiano
ALTER TABLE `software`
	DROP FOREIGN KEY IF EXISTS `software_ibfk_02_nofollow`,
	DROP FOREIGN KEY IF EXISTS `software_ibfk_03_nofollow`;

-- | 202611042722

-- software: indici nella forma del canone
ALTER TABLE `software`
	DROP INDEX IF EXISTS `id_prodotto`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `json`,
	DROP INDEX IF EXISTS `unica`,
	ADD KEY `id_prodotto` (`id_prodotto`),
	ADD KEY `indice` (`id`,`id_genitore`,`codice`,`nome`,`id_prodotto`,`id_articolo`);

-- | 202611042723

-- software: vincoli nella forma del canone
ALTER TABLE `software`
	ADD CONSTRAINT `software_ibfk_02_nofollow` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `software_ibfk_03_nofollow` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042724

-- stati: via i vincoli che cambiano
ALTER TABLE `stati`
	DROP FOREIGN KEY IF EXISTS `stati_ibfk_01_nofollow`,
	DROP FOREIGN KEY IF EXISTS `stati_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `stati_ibfk_99_nofollow`;

-- | 202611042725

-- stati: indici nella forma del canone
ALTER TABLE `stati`
	DROP INDEX IF EXISTS `data_archiviazione`,
	DROP INDEX IF EXISTS `id_successore`,
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `data_archiviazione` (`data_archiviazione`),
	ADD KEY `id_successore` (`id_successore`),
	ADD KEY `indice` (`id`,`nome`,`id_continente`,`iso31661alpha2`,`iso31661alpha3`,`codice_istat`);

-- | 202611042726

-- stati: vincoli nella forma del canone
ALTER TABLE `stati`
	ADD CONSTRAINT `stati_ibfk_01_nofollow` FOREIGN KEY (`id_continente`) REFERENCES `continenti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042727

-- stati_lingue: via i vincoli che cambiano
ALTER TABLE `stati_lingue`
	DROP FOREIGN KEY IF EXISTS `stati_lingue_ibfk_01_nofollow`,
	DROP FOREIGN KEY IF EXISTS `stati_lingue_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `stati_lingue_ibfk_99_nofollow`;

-- | 202611042728

-- stati_lingue: vincoli nella forma del canone
ALTER TABLE `stati_lingue`
	ADD CONSTRAINT `stati_lingue_ibfk_01_nofollow` FOREIGN KEY (`id_stato`) REFERENCES `stati` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042729

-- step: via i vincoli che cambiano
ALTER TABLE `step`
	DROP FOREIGN KEY IF EXISTS `step_ibfk_01`;

-- | 202611042730

-- step: indici nella forma del canone
ALTER TABLE `step`
	DROP INDEX IF EXISTS `ordine`,
	ADD KEY `ordine` (`ordine`);

-- | 202611042731

-- step: vincoli nella forma del canone
ALTER TABLE `step`
	ADD CONSTRAINT `step_ibfk_01` FOREIGN KEY (`id_funnel`) REFERENCES `funnel` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042732

-- tipologie_annunci: via i vincoli che cambiano
ALTER TABLE `tipologie_annunci`
	DROP FOREIGN KEY IF EXISTS `tipologie_annunci_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `tipologie_annunci_ibfk_99_nofollow`;

-- | 202611042733

-- tipologie_asset: via i vincoli che cambiano
ALTER TABLE `tipologie_asset`
	DROP FOREIGN KEY IF EXISTS `tipologie_asset_ibfk_01_nofollow`,
	DROP FOREIGN KEY IF EXISTS `tipologie_asset_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `tipologie_asset_ibfk_99_nofollow`;

-- | 202611042734

-- tipologie_asset: indici nella forma del canone
ALTER TABLE `tipologie_asset`
	DROP INDEX IF EXISTS `id_account_aggiornamento`,
	DROP INDEX IF EXISTS `id_account_inserimento`,
	DROP INDEX IF EXISTS `id_genitore`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `ordine`,
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`),
	ADD KEY `nome` (`nome`),
	ADD KEY `ordine` (`ordine`);

-- | 202611042735

-- tipologie_asset: vincoli nella forma del canone
ALTER TABLE `tipologie_asset`
	ADD CONSTRAINT `tipologie_asset_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_asset` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `tipologie_asset_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `tipologie_asset_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042736

-- tipologie_campagne: via i vincoli che cambiano
ALTER TABLE `tipologie_campagne`
	DROP FOREIGN KEY IF EXISTS `tipologie_campagne_ibfk_01_nofollow`,
	DROP FOREIGN KEY IF EXISTS `tipologie_campagne_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `tipologie_campagne_ibfk_99_nofollow`;

-- | 202611042737

-- tipologie_campagne: indici nella forma del canone
ALTER TABLE `tipologie_campagne`
	DROP INDEX IF EXISTS `id_account_aggiornamento`,
	DROP INDEX IF EXISTS `id_account_inserimento`,
	DROP INDEX IF EXISTS `id_genitore`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `ordine`,
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`),
	ADD KEY `nome` (`nome`),
	ADD KEY `ordine` (`ordine`);

-- | 202611042738

-- tipologie_campagne: vincoli nella forma del canone
ALTER TABLE `tipologie_campagne`
	ADD CONSTRAINT `tipologie_campagne_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_campagne` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `tipologie_campagne_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `tipologie_campagne_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042739

-- tipologie_documenti_articoli: indici nella forma del canone
ALTER TABLE `tipologie_documenti_articoli`
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `se_dettaglio`,
	DROP INDEX IF EXISTS `se_evasione`,
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`sigla`,`se_raggruppamento`,`se_somma`,`se_alternativa`,`se_dettaglio`,`se_evasione`),
	ADD KEY `se_dettaglio` (`se_dettaglio`),
	ADD KEY `se_evasione` (`se_evasione`);

-- | 202611042740

-- tipologie_indirizzi: via i vincoli che cambiano
ALTER TABLE `tipologie_indirizzi`
	DROP FOREIGN KEY IF EXISTS `tipologie_indirizzi_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `tipologie_indirizzi_ibfk_99_nofollow`;

-- | 202611042741

-- tipologie_mail_status: via i vincoli che cambiano
ALTER TABLE `tipologie_mail_status`
	DROP FOREIGN KEY IF EXISTS `tipologie_mail_status_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `tipologie_mail_status_ibfk_99_nofollow`;

-- | 202611042742

-- tipologie_sconti: via i vincoli che cambiano
ALTER TABLE `tipologie_sconti`
	DROP FOREIGN KEY IF EXISTS `tipologie_sconti_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `tipologie_sconti_ibfk_99_nofollow`;

-- | 202611042743

-- tipologie_spedizioni: via i vincoli che cambiano
ALTER TABLE `tipologie_spedizioni`
	DROP FOREIGN KEY IF EXISTS `tipologie_spedizioni_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `tipologie_spedizioni_ibfk_99_nofollow`;

-- | 202611042744

-- tipologie_vani: via i vincoli che cambiano
ALTER TABLE `tipologie_vani`
	DROP FOREIGN KEY IF EXISTS `tipologie_vani_ibfk_01_nofollow`,
	DROP FOREIGN KEY IF EXISTS `tipologie_vani_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `tipologie_vani_ibfk_99_nofollow`;

-- | 202611042745

-- tipologie_vani: indici nella forma del canone
ALTER TABLE `tipologie_vani`
	DROP INDEX IF EXISTS `id_account_aggiornamento`,
	DROP INDEX IF EXISTS `id_account_inserimento`,
	DROP INDEX IF EXISTS `id_genitore`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `ordine`,
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`),
	ADD KEY `nome` (`nome`),
	ADD KEY `ordine` (`ordine`);

-- | 202611042746

-- tipologie_vani: vincoli nella forma del canone
ALTER TABLE `tipologie_vani`
	ADD CONSTRAINT `tipologie_vani_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_vani` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `tipologie_vani_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `tipologie_vani_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042747

-- tipologie_zone: via i vincoli che cambiano
ALTER TABLE `tipologie_zone`
	DROP FOREIGN KEY IF EXISTS `tipologie_zone_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `tipologie_zone_ibfk_99_nofollow`;

-- | 202611042748

-- udm: via i vincoli che cambiano
ALTER TABLE `udm`
	DROP FOREIGN KEY IF EXISTS `udm_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `udm_ibfk_99_nofollow`;

-- | 202611042749

-- valute: via i vincoli che cambiano
ALTER TABLE `valute`
	DROP FOREIGN KEY IF EXISTS `valute_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `valute_ibfk_99_nofollow`;

-- | 202611042750

-- vani: via i vincoli che cambiano
ALTER TABLE `vani`
	DROP FOREIGN KEY IF EXISTS `vani_ibfk_01`,
	DROP FOREIGN KEY IF EXISTS `vani_ibfk_02_nofollow`,
	DROP FOREIGN KEY IF EXISTS `vani_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `vani_ibfk_99_nofollow`;

-- | 202611042751

-- vani: indici nella forma del canone
ALTER TABLE `vani`
	DROP INDEX IF EXISTS `id_account_aggiornamento`,
	DROP INDEX IF EXISTS `id_account_inserimento`,
	DROP INDEX IF EXISTS `id_immobile`,
	DROP INDEX IF EXISTS `id_tipologia`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `nome`,
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_immobile` (`id_immobile`),
	ADD KEY `id_tipologia` (`id_tipologia`),
	ADD KEY `indice` (`id`,`id_tipologia`,`codice`,`nome`,`id_immobile`),
	ADD KEY `nome` (`nome`);

-- | 202611042752

-- vani: vincoli nella forma del canone
ALTER TABLE `vani`
	ADD CONSTRAINT `vani_ibfk_01` FOREIGN KEY (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `vani_ibfk_02_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_vani` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `vani_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `vani_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042753

-- vani_anagrafica: via i vincoli che cambiano
ALTER TABLE `vani_anagrafica`
	DROP FOREIGN KEY IF EXISTS `vani_anagrafica_ibfk_01`,
	DROP FOREIGN KEY IF EXISTS `vani_anagrafica_ibfk_02_nofollow`,
	DROP FOREIGN KEY IF EXISTS `vani_anagrafica_ibfk_03_nofollow`,
	DROP FOREIGN KEY IF EXISTS `vani_anagrafica_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `vani_anagrafica_ibfk_99_nofollow`;

-- | 202611042754

-- vani_anagrafica: indici nella forma del canone
ALTER TABLE `vani_anagrafica`
	DROP INDEX IF EXISTS `id_account_aggiornamento`,
	DROP INDEX IF EXISTS `id_account_inserimento`,
	DROP INDEX IF EXISTS `id_anagrafica`,
	DROP INDEX IF EXISTS `id_ruolo`,
	DROP INDEX IF EXISTS `id_vano`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_anagrafica` (`id_anagrafica`),
	ADD KEY `id_ruolo` (`id_ruolo`),
	ADD KEY `id_vano` (`id_vano`),
	ADD KEY `indice` (`id`,`ordine`,`id_vano`,`id_anagrafica`,`id_ruolo`),
	ADD KEY `ordine` (`ordine`);

-- | 202611042755

-- vani_anagrafica: vincoli nella forma del canone
ALTER TABLE `vani_anagrafica`
	ADD CONSTRAINT `vani_anagrafica_ibfk_01` FOREIGN KEY (`id_vano`) REFERENCES `vani` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `vani_anagrafica_ibfk_02_nofollow` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `vani_anagrafica_ibfk_03_nofollow` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `vani_anagrafica_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `vani_anagrafica_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042756

-- vani_caratteristiche: via i vincoli che cambiano
ALTER TABLE `vani_caratteristiche`
	DROP FOREIGN KEY IF EXISTS `vani_caratteristiche_ibfk_01`,
	DROP FOREIGN KEY IF EXISTS `vani_caratteristiche_ibfk_02_nofollow`,
	DROP FOREIGN KEY IF EXISTS `vani_caratteristiche_ibfk_03_nofollow`,
	DROP FOREIGN KEY IF EXISTS `vani_caratteristiche_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `vani_caratteristiche_ibfk_99_nofollow`;

-- | 202611042757

-- vani_caratteristiche: indici nella forma del canone
ALTER TABLE `vani_caratteristiche`
	DROP INDEX IF EXISTS `id_account_aggiornamento`,
	DROP INDEX IF EXISTS `id_account_inserimento`,
	DROP INDEX IF EXISTS `id_caratteristica`,
	DROP INDEX IF EXISTS `id_lingua`,
	DROP INDEX IF EXISTS `id_vano`,
	DROP INDEX IF EXISTS `indice`,
	DROP INDEX IF EXISTS `ordine`,
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_caratteristica` (`id_caratteristica`),
	ADD KEY `id_lingua` (`id_lingua`),
	ADD KEY `id_vano` (`id_vano`),
	ADD KEY `indice` (`id`,`ordine`,`id_vano`,`id_caratteristica`,`id_lingua`,`se_assente`),
	ADD KEY `ordine` (`ordine`);

-- | 202611042758

-- vani_caratteristiche: vincoli nella forma del canone
ALTER TABLE `vani_caratteristiche`
	ADD CONSTRAINT `vani_caratteristiche_ibfk_01` FOREIGN KEY (`id_vano`) REFERENCES `vani` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `vani_caratteristiche_ibfk_02_nofollow` FOREIGN KEY (`id_caratteristica`) REFERENCES `caratteristiche` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `vani_caratteristiche_ibfk_03_nofollow` FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `vani_caratteristiche_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `vani_caratteristiche_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042759

-- video: via i vincoli che cambiano
ALTER TABLE `video`
	DROP FOREIGN KEY IF EXISTS `video_ibfk_19`,
	DROP FOREIGN KEY IF EXISTS `video_ibfk_20`;

-- | 202611042760

-- video: indici nella forma del canone
ALTER TABLE `video`
	DROP INDEX IF EXISTS `id_anagrafica`,
	DROP INDEX IF EXISTS `id_articolo`,
	DROP INDEX IF EXISTS `id_categoria_marchi`,
	DROP INDEX IF EXISTS `id_categoria_notizie`,
	DROP INDEX IF EXISTS `id_categoria_prodotti`,
	DROP INDEX IF EXISTS `id_categoria_risorse`,
	DROP INDEX IF EXISTS `id_file`,
	DROP INDEX IF EXISTS `id_notizia`,
	DROP INDEX IF EXISTS `id_pagina`,
	DROP INDEX IF EXISTS `id_prodotto`,
	DROP INDEX IF EXISTS `id_risorsa`,
	DROP INDEX IF EXISTS `id_vano`,
	DROP INDEX IF EXISTS `unica_audio`,
	DROP INDEX IF EXISTS `unica_immagine`,
	ADD KEY `id_categoria_marchi` (`id_categoria_marchi`),
	ADD KEY `id_vano` (`id_vano`),
	ADD UNIQUE KEY `unica_audio` (`id_audio`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY `unica_immagine` (`id_immagine`,`id_ruolo`,`id_lingua`,`path`);

-- | 202611042761

-- video: vincoli nella forma del canone
ALTER TABLE `video`
	ADD CONSTRAINT `video_ibfk_19` FOREIGN KEY (`id_edificio`) REFERENCES `edifici` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `video_ibfk_20` FOREIGN KEY (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | FINE
