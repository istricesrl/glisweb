--
-- LIMITI
-- questo file contiene le query per l'inserimento dei limiti nelle tabelle
--
-- CRITERI DI VERIFICA
-- una definizione di constraint si può dire verificata se:
-- - non si riferisce a tabelle deprecate e non contiene colonne deprecate né punta a tabelle o colonne deprecate
-- - le colonne vengono nominate nello stesso ordine in cui appaiono nella tabella
-- - tutte le colonne della tabella che rappresentano una chiave esterna sono nominate
-- - il comportamento di ogni constraint (SET NULL / NO ACTION / CASCADE) è stato verificato e approvato
-- - i nomi dei constraint sono numerati in maniera ascendente e univoca
-- - i nomi dei constraint contengono il suffisso _nofollow a meno che non sia strettamente necessario ometterlo
-- - ogni constraint è correttamente documentato con il giusto nome, in ordine, nel relativo file dox
--

-- | 060000000100

-- account
-- tipologia: tabella gestita
-- verifica: 2021-05-20 14:31 Fabio Mosti
ALTER TABLE `account`
    ADD CONSTRAINT `account_ibfk_01_nofollow` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `account_ibfk_02_nofollow` FOREIGN KEY (`id_mail`) REFERENCES `mail` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `account_ibfk_03_nofollow` FOREIGN KEY (`id_affiliazione`) REFERENCES `contratti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `account_ibfk_04`          FOREIGN KEY (`id_url`) REFERENCES `url` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `account_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `account_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000000200

-- account_gruppi
-- tipologia: tabella gestita
-- verifica: 2021-05-20 16:07 Fabio Mosti
ALTER TABLE `account_gruppi`
    ADD CONSTRAINT `account_gruppi_ibfk_01`             FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `account_gruppi_ibfk_02_nofollow`    FOREIGN KEY (`id_gruppo`) REFERENCES `gruppi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `account_gruppi_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `account_gruppi_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 060000000300

-- account_gruppi_attribuzione
-- tipologia: tabella gestita
-- verifica: 2021-05-20 17:11 Fabio Mosti
ALTER TABLE `account_gruppi_attribuzione`
    ADD CONSTRAINT `account_gruppi_attribuzione_ibfk_01`            FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `account_gruppi_attribuzione_ibfk_02_nofollow`   FOREIGN KEY (`id_gruppo`) REFERENCES `gruppi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `account_gruppi_attribuzione_ibfk_98_nofollow`   FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `account_gruppi_attribuzione_ibfk_99_nofollow`   FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000000400

-- anagrafica
-- tipologia: tabella gestita
-- verifica: 2021-05-20 19:33 Fabio Mosti
ALTER TABLE `anagrafica`	
    ADD CONSTRAINT `anagrafica_ibfk_01_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_ibfk_02_nofollow` FOREIGN KEY (`id_badge`) REFERENCES `badge` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_ibfk_03_nofollow` FOREIGN KEY (`id_pec_sdi`) REFERENCES `mail` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_ibfk_04_nofollow` FOREIGN KEY (`id_regime`) REFERENCES `regimi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `anagrafica_ibfk_05_nofollow` FOREIGN KEY (`id_stato_nascita`) REFERENCES `stati` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `anagrafica_ibfk_06_nofollow` FOREIGN KEY (`id_comune_nascita`) REFERENCES `comuni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `anagrafica_ibfk_07_nofollow` FOREIGN KEY (`id_ranking`) REFERENCES `ranking` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `anagrafica_ibfk_08_nofollow` FOREIGN KEY (`id_agente`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `anagrafica_ibfk_09_nofollow` FOREIGN KEY (`id_responsabile_operativo`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `anagrafica_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `anagrafica_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000000500

-- anagrafica_categorie
-- tipologia: tabella gestita
-- verifica: 2021-05-20 19:33 Fabio Mosti
ALTER TABLE `anagrafica_categorie`
    ADD CONSTRAINT `anagrafica_categorie_ibfk_01`           FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_categorie_ibfk_02_nofollow`  FOREIGN KEY (`id_categoria`) REFERENCES `categorie_anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_categorie_ibfk_98_nofollow`  FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `anagrafica_categorie_ibfk_99_nofollow`  FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000000600

-- anagrafica_certificazioni
-- tipologia: tabella gestita
-- verifica: 2022-02-03 11:12 Chiara GDL
ALTER TABLE `anagrafica_certificazioni`
    ADD CONSTRAINT `anagrafica_certificazioni_ibfk_01`               FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_certificazioni_ibfk_02_nofollow`      FOREIGN KEY (`id_certificazione`) REFERENCES `certificazioni` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_certificazioni_ibfk_03_nofollow`      FOREIGN KEY (`id_emittente`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_certificazioni_ibfk_98_nofollow`      FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `anagrafica_certificazioni_ibfk_99_nofollow`      FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000000700

-- anagrafica_cittadinanze
-- tipologia: tabella gestita
-- verifica: 2021-05-20 21:27 Fabio Mosti
ALTER TABLE `anagrafica_cittadinanze` -- relazione anagrafica - stati? 
    ADD CONSTRAINT `anagrafica_cittadinanze_ibfk_01`            FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_cittadinanze_ibfk_02_nofollow`   FOREIGN KEY (`id_stato`) REFERENCES `stati` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `anagrafica_cittadinanze_ibfk_98_nofollow`   FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `anagrafica_cittadinanze_ibfk_99_nofollow`   FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000000800

-- anagrafica_consensi
-- tipologia: tabella gestita
-- verifica: 2022-08-23 11:12 Chiara GDL
ALTER TABLE `anagrafica_consensi`
    ADD CONSTRAINT `anagrafica_consensi_ibfk_01_nofollow`	FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `anagrafica_consensi_ibfk_02`  			FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_consensi_ibfk_03_nofollow`  FOREIGN KEY (`id_consenso`) REFERENCES `consensi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `anagrafica_consensi_ibfk_98_nofollow`  FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `anagrafica_consensi_ibfk_99_nofollow`  FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000000900

-- anagrafica_indirizzi
-- tipologia: tabella gestita
-- verifica: 2021-05-21 16:36 Fabio Mosti
ALTER TABLE `anagrafica_indirizzi`
    ADD CONSTRAINT `anagrafica_indirizzi_ibfk_01`               FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_indirizzi_ibfk_02_nofollow`      FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_indirizzi_ibfk_03_nofollow`      FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_indirizzi` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_indirizzi_ibfk_98_nofollow`      FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `anagrafica_indirizzi_ibfk_99_nofollow`      FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 010000000920

-- anagrafica_organizzazioni
ALTER TABLE `anagrafica_organizzazioni`
    ADD CONSTRAINT `anagrafica_organizzazioni_ibfk_01`          FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_organizzazioni_ibfk_02_nofollow` FOREIGN KEY (`id_organizzazione`) REFERENCES `organizzazioni` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_organizzazioni_ibfk_03_nofollow` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_organizzazioni_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `anagrafica_organizzazioni_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000000940

-- anagrafica_progetti
ALTER TABLE `anagrafica_progetti`
    ADD CONSTRAINT `anagrafica_progetti_ibfk_01`            FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_progetti_ibfk_02_nofollow`   FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_progetti_ibfk_03_nofollow`   FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_progetti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_progetti_ibfk_98_nofollow`   FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `anagrafica_progetti_ibfk_99_nofollow`   FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000001200

-- anagrafica_settori
-- tipologia: tabella gestita
-- verifica: 2021-05-23 15:31 Fabio Mosti
ALTER TABLE `anagrafica_settori`
    ADD CONSTRAINT `anagrafica_settori_ibfk_01`             FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_settori_ibfk_02_nofollow`    FOREIGN KEY (`id_settore`) REFERENCES `settori` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_settori_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `anagrafica_settori_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000001250

-- annunci
ALTER TABLE `annunci`
    -- ADD CONSTRAINT `anagrafica_settori_ibfk_01_nofollow`    FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie` (`id`) ON DELETE ... ON UPDATE ...,
    ADD CONSTRAINT `anagrafica_settori_ibfk_02_nofollow`    FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `anagrafica_settori_ibfk_03_nofollow`    FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `anagrafica_settori_ibfk_04_nofollow`    FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_settori_ibfk_05_nofollow`    FOREIGN KEY (`id_udm`) REFERENCES `udm` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `anagrafica_settori_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `anagrafica_settori_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000001270

-- annunci
ALTER TABLE `annunci_categorie`
    ADD CONSTRAINT `anagrafica_settori_ibfk_01_nofollow`    FOREIGN KEY (`id_annuncio`) REFERENCES `annunci` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_settori_ibfk_02_nofollow`    FOREIGN KEY (`id_categoria`) REFERENCES `categorie_annunci` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `anagrafica_settori_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `anagrafica_settori_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000001300

-- articoli
-- tipologia: tabella gestita
-- verifica: 2021-05-25 10:47 Fabio Mosti
ALTER TABLE `articoli`
    ADD CONSTRAINT `articoli_ibfk_01_nofollow` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `articoli_ibfk_02_nofollow` FOREIGN KEY (`id_reparto`) REFERENCES `reparti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL, 
    ADD CONSTRAINT `articoli_ibfk_03_nofollow` FOREIGN KEY (`id_colore`) REFERENCES `colori` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `articoli_ibfk_04_nofollow` FOREIGN KEY (`id_periodicita`) REFERENCES `periodicita` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `articoli_ibfk_05_nofollow` FOREIGN KEY (`id_tipologia_rinnovo`) REFERENCES `tipologie_rinnovi` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `articoli_ibfk_06_nofollow` FOREIGN KEY (`id_udm_dimensioni`) REFERENCES `udm` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `articoli_ibfk_07_nofollow` FOREIGN KEY (`id_udm_peso`) REFERENCES `udm` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `articoli_ibfk_08_nofollow` FOREIGN KEY (`id_udm_volume`) REFERENCES `udm` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `articoli_ibfk_09_nofollow` FOREIGN KEY (`id_udm_capacita`) REFERENCES `udm` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `articoli_ibfk_10_nofollow` FOREIGN KEY (`id_udm_durata`) REFERENCES `udm` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `articoli_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `articoli_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000001600

-- articoli_caratteristiche
-- tipologia: tabella gestita
-- verifica: 2021-05-25 12:05 Fabio Mosti
ALTER TABLE `articoli_caratteristiche`
    ADD CONSTRAINT `articoli_caratteristiche_ibfk_01`           FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `articoli_caratteristiche_ibfk_02_nofollow`  FOREIGN KEY (`id_caratteristica`) REFERENCES `caratteristiche` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 060000001800

-- attivita
-- tipologia: tabella gestita
-- verifica: 2021-05-27 15:31 Fabio Mosti
ALTER TABLE `attivita`
    ADD CONSTRAINT `attivita_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `attivita` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `attivita_ibfk_02_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_attivita` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `attivita_ibfk_03_nofollow` FOREIGN KEY (`id_cliente`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `attivita_ibfk_04_nofollow` FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `attivita_ibfk_05_nofollow` FOREIGN KEY (`id_luogo`) REFERENCES `luoghi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `attivita_ibfk_06_nofollow` FOREIGN KEY (`id_anagrafica_programmazione`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `attivita_ibfk_07_nofollow` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `attivita_ibfk_08_nofollow` FOREIGN KEY (`id_mailing`) REFERENCES `mailing` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `attivita_ibfk_09_nofollow` FOREIGN KEY (`id_mail`) REFERENCES `mail` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `attivita_ibfk_10_nofollow` FOREIGN KEY (`id_documento`) REFERENCES `documenti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `attivita_ibfk_11_nofollow` FOREIGN KEY (`id_pagamento`) REFERENCES `pagamenti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `attivita_ibfk_12_nofollow` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `attivita_ibfk_12_nofollow` FOREIGN KEY (`id_contratto`) REFERENCES `contratti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `attivita_ibfk_13_nofollow` FOREIGN KEY (`id_todo`) REFERENCES `todo` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `attivita_ibfk_14_nofollow` FOREIGN KEY (`id_mastro_provenienza`) REFERENCES `mastri` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `attivita_ibfk_15_nofollow` FOREIGN KEY (`id_mastro_destinazione`) REFERENCES `mastri` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `attivita_ibfk_16_nofollow` FOREIGN KEY (`id_matricola`) REFERENCES `matricole` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `attivita_ibfk_17_nofollow` FOREIGN KEY (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `attivita_ibfk_18_nofollow` FOREIGN KEY (`id_pianificazione`) REFERENCES `pianificazioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `attivita_ibfk_19_nofollow` FOREIGN KEY (`id_contatto`) REFERENCES `contatti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `attivita_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `attivita_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000002100

-- audio
-- tipologia: tabella gestita
-- verifica: 2021-05-28 16:18 Fabio Mosti
ALTER TABLE `audio`
    ADD CONSTRAINT `audio_ibfk_01_nofollow` FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `audio_ibfk_02_nofollow` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_audio` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `audio_ibfk_03_nofollow` FOREIGN KEY (`id_embed`) REFERENCES `embed` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `audio_ibfk_03`          FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `audio_ibfk_04`          FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `audio_ibfk_05`          FOREIGN KEY (`id_file`) REFERENCES `file` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `audio_ibfk_06`          FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `audio_ibfk_07`          FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `audio_ibfk_08`          FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `audio_ibfk_09`          FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `audio_ibfk_10`          FOREIGN KEY (`id_annuncio`) REFERENCES `annunci` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `audio_ibfk_11`          FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `audio_ibfk_12`          FOREIGN KEY (`id_categorie_annunci`) REFERENCES `categorie_annunci` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `audio_ibfk_13`          FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `audio_ibfk_14`          FOREIGN KEY (`id_categoria_progetti`) REFERENCES `categorie_progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `audio_ibfk_15`          FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `audio_ibfk_16`          FOREIGN KEY (`id_edificio`) REFERENCES `edifici` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `audio_ibfk_17`          FOREIGN KEY (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `audio_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `audio_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000002250

-- badge
-- tipologia: tabella gestita
ALTER TABLE `badge`
	ADD CONSTRAINT `badge_ibfk_01` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_badge` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
   	ADD CONSTRAINT `badge_ibfk_02` FOREIGN KEY (`id_contratto`) REFERENCES `contratti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `badge_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
   	ADD CONSTRAINT `badge_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000002300

-- banner
-- tipologia: tabella gestita
-- verifica: 2022-07-20 17:22 Chiara GDL
ALTER TABLE `banner`
	ADD CONSTRAINT `banner_ibfk_01` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_banner` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
   	ADD CONSTRAINT `banner_ibfk_02_nofollow` FOREIGN KEY (`id_inserzionista`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `banner_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
   	ADD CONSTRAINT `banner_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000002400

-- banner_azioni
-- tipologia: tabella gestita
-- verifica: 2022-07-21 10:22 Chiara GDL
ALTER TABLE `banner_azioni`
    ADD CONSTRAINT `banner_azioni_ibfk_01`               FOREIGN KEY (`id_banner`) REFERENCES `banner` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `banner_azioni_ibfk_02_nofollow`      FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `banner_azioni_ibfk_98_nofollow`      FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `banner_azioni_ibfk_99_nofollow`      FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000002500

-- banner_pagine
-- tipologia: tabella gestita
-- verifica: 2022-07-21 10:22 Chiara GDL
ALTER TABLE `banner_pagine`
    ADD CONSTRAINT `banner_pagine_ibfk_01`               FOREIGN KEY (`id_banner`) REFERENCES `banner` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `banner_pagine_ibfk_02_nofollow`      FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `banner_pagine_ibfk_98_nofollow`      FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `banner_pagine_ibfk_99_nofollow`      FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000002600

-- banner_zone
-- tipologia: tabella gestita
-- verifica: 2022-08-04 10:22 Chiara GDL
ALTER TABLE `banner_zone`
    ADD CONSTRAINT `banner_zone_ibfk_01`               FOREIGN KEY (`id_banner`) REFERENCES `banner` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `banner_zone_ibfk_02_nofollow`      FOREIGN KEY (`id_zona`) REFERENCES `zone` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `banner_zone_ibfk_98_nofollow`      FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `banner_zone_ibfk_99_nofollow`      FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000002900

-- caratteristiche
-- tipologia: tabella gestita
-- verifica: 2021-05-28 18:30 Fabio Mosti
ALTER TABLE `caratteristiche`
    ADD CONSTRAINT `caratteristiche_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `caratteristiche_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000003000

-- carrelli
-- tipologia: tabella gestita
-- verifica: 2022-07-12 14:45 Chiara GDL
ALTER TABLE `carrelli`
    ADD CONSTRAINT `carrelli_ibfk_01`          FOREIGN KEY (`destinatario_id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `carrelli_ibfk_02_nofollow` FOREIGN KEY (`destinatario_id_provincia`) REFERENCES `provincie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `carrelli_ibfk_03_nofollow` FOREIGN KEY (`destinatario_id_stato`) REFERENCES `stati` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `carrelli_ibfk_04`          FOREIGN KEY (`intestazione_id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `carrelli_ibfk_05_nofollow` FOREIGN KEY (`intestazione_id_comune`) REFERENCES `comuni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `carrelli_ibfk_06_nofollow` FOREIGN KEY (`intestazione_id_provincia`) REFERENCES `provincie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `carrelli_ibfk_07_nofollow` FOREIGN KEY (`intestazione_id_stato`) REFERENCES `stati` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `carrelli_ibfk_08_nofollow` FOREIGN KEY (`id_listino`) REFERENCES `listini` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `carrelli_ibfk_09_nofollow` FOREIGN KEY (`id_reseller`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `carrelli_ibfk_10_nofollow` FOREIGN KEY (`id_affiliato`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `carrelli_ibfk_11_nofollow` FOREIGN KEY (`intestazione_id_account`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `carrelli_ibfk_12_nofollow` FOREIGN KEY (`destinatario_id_account`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `carrelli_ibfk_13_nofollow` FOREIGN KEY (`fatturazione_id_tipologia_documento`) REFERENCES `tipologie_documenti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `carrelli_ibfk_14_nofollow` FOREIGN KEY (`intestazione_id_tipologia_anagrafica`) REFERENCES `tipologie_anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `carrelli_ibfk_15_nofollow` FOREIGN KEY (`destinatario_id_tipologia_anagrafica`) REFERENCES `tipologie_anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `carrelli_ibfk_16_nofollow` FOREIGN KEY (`id_affiliazione`) REFERENCES `contratti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `carrelli_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `carrelli_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000003050

-- carrelli_articoli
-- tipologia: tabella gestita
-- verifica: 2022-07-12 14:45 Chiara GDL
ALTER TABLE `carrelli_articoli`
    ADD CONSTRAINT `carrelli_articoli_ibfk_01`             FOREIGN KEY (`id_carrello`) REFERENCES `carrelli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `carrelli_articoli_ibfk_02_nofollow`    FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `carrelli_articoli_ibfk_03_nofollow`    FOREIGN KEY (`id_iva`) REFERENCES `iva` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `carrelli_articoli_ibfk_04_nofollow`    FOREIGN KEY (`id_pagamento`) REFERENCES `pagamenti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `carrelli_articoli_ibfk_05_nofollow`    FOREIGN KEY (`destinatario_id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `carrelli_articoli_ibfk_06_nofollow`    FOREIGN KEY (`id_rinnovo`) REFERENCES `rinnovi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `carrelli_articoli_ibfk_98_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `carrelli_articoli_ibfk_99_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000003060

-- carrelli_consensi
-- tipologia: tabella gestita
-- verifica: 2022-08-23 11:12 Chiara GDL
ALTER TABLE `carrelli_consensi`
    ADD CONSTRAINT `carrelli_consensi_ibfk_01_nofollow`	    FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `carrelli_consensi_ibfk_02_nofollow`     FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `carrelli_consensi_ibfk_03`  		    FOREIGN KEY (`id_carrello`) REFERENCES `carrelli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `carrelli_consensi_ibfk_04_nofollow`     FOREIGN KEY (`id_consenso`) REFERENCES `consensi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `carrelli_consensi_ibfk_98_nofollow`     FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `carrelli_consensi_ibfk_99_nofollow`     FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000003070

-- carrelli_documenti
-- tipologia: tabella gestita
-- verifica: 2022-08-22 11:45 Chiara GDL
ALTER TABLE `carrelli_documenti`
    ADD CONSTRAINT `carrelli_documenti_ibfk_01`             FOREIGN KEY (`id_carrello`) REFERENCES `carrelli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `carrelli_documenti_ibfk_02_nofollow`    FOREIGN KEY (`id_documento`) REFERENCES `documenti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `carrelli_documenti_ibfk_98_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `carrelli_documenti_ibfk_99_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000003100

-- categorie_anagrafica
-- tipologia: tabella assistita
-- verifica: 2021-05-28 20:07 Fabio Mosti
ALTER TABLE `categorie_anagrafica`
    ADD CONSTRAINT `categorie_anagrafica_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `categorie_anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `categorie_anagrafica_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `categorie_anagrafica_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000003300

-- categorie_annunci
ALTER TABLE `categorie_annunci`
    ADD CONSTRAINT `categorie_notizie_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `categorie_annunci` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `categorie_notizie_ibfk_02_nofollow` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `categorie_notizie_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `categorie_notizie_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000003700

-- categorie_notizie
-- tipologia: tabella gestita
-- verifica: 2021-06-01 18:29 Fabio Mosti
ALTER TABLE `categorie_notizie`
    ADD CONSTRAINT `categorie_notizie_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `categorie_notizie` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `categorie_notizie_ibfk_02_nofollow` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `categorie_notizie_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `categorie_notizie_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000003900

-- categorie_prodotti
-- tipologia: tabella gestita
-- verifica: 2021-06-01 19:50 Fabio Mosti
ALTER TABLE `categorie_prodotti`
    ADD CONSTRAINT `categorie_prodotti_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `categorie_prodotti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `categorie_prodotti_ibfk_02_nofollow` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `categorie_prodotti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `categorie_prodotti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000004300

-- categorie_progetti
-- tipologia: tabella gestita
-- verifica: 2021-06-02 19:45 Fabio Mosti
ALTER TABLE `categorie_progetti`
    ADD CONSTRAINT `categorie_progetti_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `categorie_progetti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `categorie_progetti_ibfk_02` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `categorie_progetti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `categorie_progetti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000004500

-- categorie_risorse
-- tipologia: tabella gestita
-- verifica: 2021-06-02 20:14 Fabio Mosti
ALTER TABLE `categorie_risorse`
    ADD CONSTRAINT `categorie_risorse_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `categorie_risorse` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `categorie_risorse_ibfk_02_nofollow` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `categorie_risorse_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `categorie_risorse_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000004600

-- causali
-- tipologia: tabella gestita
-- verifica: 2022-04-26 11:12 Chiara GDL
ALTER TABLE `causali`
    ADD CONSTRAINT `causali_ibfk_98_nofollow`  FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `causali_ibfk_99_nofollow`  FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000004700

-- certificazioni
-- tipologia: tabella assistita
-- verifica: 2022-02-03 11:12 Chiara GDL
ALTER TABLE `certificazioni`
    ADD CONSTRAINT `certificazioni_ibfk_98_nofollow`  FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `certificazioni_ibfk_99_nofollow`  FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000004800

-- chiavi
-- tipologia: tabella di supporto
-- verifica: 2021-11-15 11:58 Chiara GDL
ALTER TABLE `chiavi`
    ADD CONSTRAINT `chiavi_ibfk_01_nofollow` FOREIGN KEY (`id_licenza`) REFERENCES `licenze` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `chiavi_ibfk_02_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_chiavi` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `chiavi_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `chiavi_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;


-- | 060000005050

-- colli
-- tipologia: tabella standard
-- verifica: 2022-05-04 22:22 Chiara GDL
ALTER TABLE `colli`
    ADD CONSTRAINT `colli_ibfk_01_nofollow` FOREIGN KEY (`id_documento`) REFERENCES `documenti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `colli_ibfk_02_nofollow` FOREIGN KEY (`id_udm_dimensioni`) REFERENCES `udm` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `colli_ibfk_03_nofollow` FOREIGN KEY (`id_udm_peso`) REFERENCES `udm` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `colli_ibfk_04_nofollow` FOREIGN KEY (`id_udm_volume`) REFERENCES `udm` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `colli_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `colli_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000005100

-- colori
-- tipologia: tabella di supporto
-- verifica: 2021-06-02 22:33 Fabio Mosti
ALTER TABLE `colori`
    ADD CONSTRAINT `colori_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `colori` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 060000005300

-- comuni
-- tipologia: tabella di supporto
-- verifica: 2021-06-03 20:26 Fabio Mosti
ALTER TABLE `comuni`
    ADD CONSTRAINT `comuni_ibfk_01_nofollow` FOREIGN KEY (`id_provincia`) REFERENCES `provincie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000006400

-- consensi
-- tipologia: tabella standard
-- verifica: 2022-08-23 11:12 Chiara GDL
ALTER TABLE `consensi`
    ADD CONSTRAINT `consensi_ibfk_98_nofollow`       FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `consensi_ibfk_99_nofollow`       FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000006500

-- consensi_moduli
-- tipologia: tabella assistita
-- verifica: 2022-08-23 11:12 Chiara GDL
ALTER TABLE `consensi_moduli`
    ADD CONSTRAINT `consensi_moduli_ibfk_01_nofollow`       FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `consensi_moduli_ibfk_02_nofollow`       FOREIGN KEY (`id_consenso`) REFERENCES `consensi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `consensi_moduli_ibfk_98_nofollow`       FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `consensi_moduli_ibfk_99_nofollow`       FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;
    
-- | 060000006700

-- contatti
-- tipologia: tabella gestita
-- verifica: 2021-06-04 15:04 Fabio Mosti
ALTER TABLE `contatti`
    ADD CONSTRAINT `contatti_ibfk_01_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_contatti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `contatti_ibfk_02_nofollow` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contatti_ibfk_03_nofollow` FOREIGN KEY (`id_inviante`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contatti_ibfk_04_nofollow` FOREIGN KEY (`id_ranking`) REFERENCES `ranking` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contatti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contatti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000006900

-- contenuti
-- tipologia: tabella gestita
-- verifica: 2021-06-07 17:38 Fabio Mosti
ALTER TABLE `contenuti`
    ADD CONSTRAINT `contenuti_ibfk_01_nofollow` FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contenuti_ibfk_02`          FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contenuti_ibfk_03`          FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contenuti_ibfk_04`          FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contenuti_ibfk_05`          FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contenuti_ibfk_06`          FOREIGN KEY (`id_caratteristica`) REFERENCES `caratteristiche` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contenuti_ibfk_07`          FOREIGN KEY (`id_marchio`) REFERENCES `marchi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contenuti_ibfk_08`          FOREIGN KEY (`id_file`) REFERENCES `file` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contenuti_ibfk_09`          FOREIGN KEY (`id_immagine`) REFERENCES `immagini` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contenuti_ibfk_10`          FOREIGN KEY (`id_video`) REFERENCES `video` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contenuti_ibfk_11`          FOREIGN KEY (`id_audio`) REFERENCES `audio` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contenuti_ibfk_12`          FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contenuti_ibfk_13`          FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contenuti_ibfk_14`          FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contenuti_ibfk_15`          FOREIGN KEY (`id_popup`) REFERENCES `popup` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contenuti_ibfk_16`          FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contenuti_ibfk_17`          FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contenuti_ibfk_18`          FOREIGN KEY (`id_annuncio`) REFERENCES `annunci` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contenuti_ibfk_19`          FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contenuti_ibfk_20`          FOREIGN KEY (`id_categorie_annunci`) REFERENCES `categorie_annunci` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contenuti_ibfk_21`          FOREIGN KEY (`id_template`) REFERENCES `template` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contenuti_ibfk_22`          FOREIGN KEY (`id_mailing`) REFERENCES `mailing` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contenuti_ibfk_23`          FOREIGN KEY (`id_colore`) REFERENCES `colori` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contenuti_ibfk_24`          FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contenuti_ibfk_25`          FOREIGN KEY (`id_categoria_progetti`) REFERENCES `categorie_progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contenuti_ibfk_26`          FOREIGN KEY (`id_edificio`) REFERENCES `edifici` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contenuti_ibfk_27`          FOREIGN KEY (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contenuti_ibfk_28`          FOREIGN KEY (`id_banner`) REFERENCES `banner` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contenuti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contenuti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000007200

-- contratti
-- tipologia: tabella gestita
-- verifica: 2022-02-21 11:50 Chiara GDL
ALTER TABLE `contratti` 
    ADD CONSTRAINT `contratti_ibfk_01_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_contratti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `contratti_ibfk_04_nofollow` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contratti_ibfk_05_nofollow` FOREIGN KEY (`id_categoria_progetti`) REFERENCES `categorie_progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contratti_ibfk_06_nofollow` FOREIGN KEY (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contratti_ibfk_07_nofollow` FOREIGN KEY (`id_badge`) REFERENCES `badge` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contratti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contratti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000007300

-- contratti_anagrafica
-- tipologia: tabella gestita
-- verifica: 2022-02-21 11:50 Chiara GDL
ALTER TABLE `contratti_anagrafica`
    ADD CONSTRAINT `contratti_anagrafica_ibfk_01`            FOREIGN KEY (`id_contratto`) REFERENCES `contratti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `contratti_anagrafica_ibfk_02_nofollow`   FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `contratti_anagrafica_ibfk_03_nofollow`   FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `contratti_anagrafica_ibfk_98_nofollow`   FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contratti_anagrafica_ibfk_99_nofollow`   FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;
    
-- | 060000007400

-- contratti_progetti
ALTER TABLE `contratti_progetti`
    ADD CONSTRAINT `contratti_progetti_ibfk_01`             FOREIGN KEY (`id_contratto`) REFERENCES `contratti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `contratti_progetti_ibfk_02_nofollow`    FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `contratti_progetti_ibfk_03_nofollow`    FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `contratti_progetti_ibfk_97_nofollow`    FOREIGN KEY (`id_account_archiviazione`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contratti_progetti_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contratti_progetti_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000007500

-- conversazioni
-- tipologia: tabella gestita
-- verifica: 2022-08-31 11:50 Chiara GDL
ALTER TABLE `conversazioni`
    ADD CONSTRAINT `conversazioni_ibfk_01_nofollow`    FOREIGN KEY (`id_annuncio`) REFERENCES `annunci` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `conversazioni_ibfk_02_nofollow`    FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 060000007600

-- conversazioni_account
-- tipologia: tabella gestita
-- verifica: 2022-08-31 11:50 Chiara GDL
ALTER TABLE `conversazioni_account`
    ADD CONSTRAINT `conversazioni_account_ibfk_01_nofollow`    FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `conversazioni_account_ibfk_02_nofollow`    FOREIGN KEY (`id_conversazione`) REFERENCES `conversazioni` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 060000007800

-- corrispondenza
ALTER TABLE `corrispondenza`
    ADD CONSTRAINT `corrispondenza_ibfk_01_nofollow`    FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_corrispondenza` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `corrispondenza_ibfk_02_nofollow`    FOREIGN KEY (`id_peso`) REFERENCES `pesi_tipologie_corrispondenza` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `corrispondenza_ibfk_03_nofollow`    FOREIGN KEY (`id_formato`) REFERENCES `formati_tipologie_corrispondenza` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `corrispondenza_ibfk_04_nofollow`    FOREIGN KEY (`id_mittente`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `corrispondenza_ibfk_05_nofollow`    FOREIGN KEY (`id_organizzazione_mittente`) REFERENCES `organizzazioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `corrispondenza_ibfk_06_nofollow`    FOREIGN KEY (`id_commesso`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `corrispondenza_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `corrispondenza_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000008000

-- coupon
-- tipologia: tabella gestita
-- verifica: 2021-06-29 16:08 Fabio Mosti
ALTER TABLE `coupon`
    ADD CONSTRAINT `coupon_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `coupon_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000008200

-- coupon_categorie_prodotti
-- tipologia: tabella gestita
-- verifica: 2021-06-29 16:08 Fabio Mosti
ALTER TABLE `coupon_categorie_prodotti`
    ADD CONSTRAINT `coupon_categorie_prodotti_ibfk_01`              FOREIGN KEY (`id_coupon`) REFERENCES `coupon` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `coupon_categorie_prodotti_ibfk_02_nofollow`     FOREIGN KEY (`id_categoria`) REFERENCES `categorie_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `coupon_categorie_prodotti_ibfk_98_nofollow`     FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `coupon_categorie_prodotti_ibfk_99_nofollow`     FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000008400

-- coupon_listini
-- tipologia: tabella gestita
-- verifica: 2021-06-29 16:38 Fabio Mosti
ALTER TABLE `coupon_listini`
    ADD CONSTRAINT `coupon_listini_ibfk_01`             FOREIGN KEY (`id_coupon`) REFERENCES `coupon` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `coupon_listini_ibfk_02_nofollow`    FOREIGN KEY (`id_listino`) REFERENCES `listini` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `coupon_listini_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `coupon_listini_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000008600

-- coupon_marchi
-- tipologia: tabella gestita
-- verifica: 2021-06-29 16:38 Fabio Mosti
ALTER TABLE `coupon_marchi`
    ADD CONSTRAINT `coupon_marchi_ibfk_01`              FOREIGN KEY (`id_coupon`) REFERENCES `coupon` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `coupon_marchi_ibfk_02_nofollow`     FOREIGN KEY (`id_marchio`) REFERENCES `marchi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `coupon_marchi_ibfk_98_nofollow`     FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `coupon_marchi_ibfk_99_nofollow`     FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000008800

-- coupon_prodotti
-- tipologia: tabella gestita
-- verifica: 2021-06-29 16:57 Fabio Mosti
ALTER TABLE `coupon_prodotti`
    ADD CONSTRAINT `coupon_prodotti_ibfk_01`            FOREIGN KEY (`id_coupon`) REFERENCES `coupon` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `coupon_prodotti_ibfk_02_nofollow`   FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `coupon_prodotti_ibfk_98_nofollow`   FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `coupon_prodotti_ibfk_99_nofollow`   FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000008900

-- crediti
-- tipologia: tabella gestita
-- verifica: 2022-07-15 11:56 Chiara GDL
ALTER TABLE `crediti`
    ADD CONSTRAINT `crediti_ibfk_03_nofollow`    FOREIGN KEY (`id_documenti_articolo`) REFERENCES `documenti_articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `crediti_ibfk_04_nofollow`    FOREIGN KEY (`id_account_emittente`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `crediti_ibfk_05_nofollow`    FOREIGN KEY (`id_account_destinatario`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `crediti_ibfk_06_nofollow`    FOREIGN KEY (`id_mastro_provenienza`) REFERENCES `mastri` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `crediti_ibfk_07_nofollow`    FOREIGN KEY (`id_mastro_destinazione`) REFERENCES `mastri` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `crediti_ibfk_08_nofollow`    FOREIGN KEY (`id_pianificazione`) REFERENCES `pianificazioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `crediti_ibfk_98_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `crediti_ibfk_99_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000009800

-- documenti
-- tipologia: tabella gestita
-- verifica: 2021-09-03 17:18 Fabio Mosti
ALTER TABLE `documenti`
    ADD CONSTRAINT `documenti_ibfk_01_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_documenti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `documenti_ibfk_02_nofollow` FOREIGN KEY (`id_emittente`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `documenti_ibfk_03_nofollow` FOREIGN KEY (`id_sede_emittente`) REFERENCES `indirizzi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `documenti_ibfk_04_nofollow` FOREIGN KEY (`id_destinatario`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `documenti_ibfk_05_nofollow` FOREIGN KEY (`id_sede_destinatario`) REFERENCES `indirizzi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `documenti_ibfk_06_nofollow` FOREIGN KEY (`id_coupon`) REFERENCES `coupon` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `documenti_ibfk_07_nofollow` FOREIGN KEY (`id_condizione_pagamento`) REFERENCES `condizioni_pagamento` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `documenti_ibfk_08_nofollow` FOREIGN KEY (`id_mastro_provenienza`) REFERENCES `mastri` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `documenti_ibfk_09_nofollow` FOREIGN KEY (`id_mastro_destinazione`) REFERENCES `mastri` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `documenti_ibfk_10_nofollow` FOREIGN KEY (`id_causale`) REFERENCES `causali` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `documenti_ibfk_11_nofollow` FOREIGN KEY (`id_trasportatore`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `documenti_ibfk_12_nofollow` FOREIGN KEY (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `documenti_ibfk_13_nofollow` FOREIGN KEY (`id_pianificazione`) REFERENCES `pianificazioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `documenti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `documenti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- NOTA id_sede_emittente e id_sede_destinatario non dovrebbero referenziare la tabella anagrafica_indirizzi?
-- NOTA la colonna id_listino non dovrebbe essere nel documento e comandare sull'id_listino delle voci?

-- | 060000010000

-- documenti_articoli
-- tipologia: tabella gestita
-- verifica: 2021-09-10 12:48 Fabio Mosti
ALTER TABLE `documenti_articoli`
    ADD CONSTRAINT `documenti_articoli_ibfk_01`             FOREIGN KEY (`id_genitore`) REFERENCES `documenti_articoli` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `documenti_articoli_ibfk_02_nofollow`    FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_documenti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `documenti_articoli_ibfk_03_nofollow`    FOREIGN KEY (`id_documento`) REFERENCES `documenti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `documenti_articoli_ibfk_04_nofollow`    FOREIGN KEY (`id_emittente`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `documenti_articoli_ibfk_05_nofollow`    FOREIGN KEY (`id_destinatario`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `documenti_articoli_ibfk_06_nofollow`    FOREIGN KEY (`id_reparto`) REFERENCES `reparti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `documenti_articoli_ibfk_07_nofollow`    FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `documenti_articoli_ibfk_08_nofollow`    FOREIGN KEY (`id_todo`) REFERENCES `todo` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `documenti_articoli_ibfk_09_nofollow`    FOREIGN KEY (`id_attivita`) REFERENCES `attivita` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `documenti_articoli_ibfk_10_nofollow`    FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `documenti_articoli_ibfk_11_nofollow`    FOREIGN KEY (`id_mastro_provenienza`) REFERENCES `mastri` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `documenti_articoli_ibfk_12_nofollow`    FOREIGN KEY (`id_mastro_destinazione`) REFERENCES `mastri` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `documenti_articoli_ibfk_13_nofollow`    FOREIGN KEY (`id_udm`) REFERENCES `udm` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `documenti_articoli_ibfk_14_nofollow`    FOREIGN KEY (`id_listino`) REFERENCES `listini` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `documenti_articoli_ibfk_15_nofollow`    FOREIGN KEY (`id_matricola`) REFERENCES `matricole` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `documenti_articoli_ibfk_16_nofollow`    FOREIGN KEY (`id_rinnovo`) REFERENCES `rinnovi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `documenti_articoli_ibfk_17_nofollow`    FOREIGN KEY (`id_collo`) REFERENCES `colli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `documenti_articoli_ibfk_18_nofollow`    FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
 	ADD CONSTRAINT `documenti_articoli_ibfk_19_nofollow`    FOREIGN KEY (`id_pianificazione`) REFERENCES `pianificazioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `documenti_articoli_ibfk_98_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `documenti_articoli_ibfk_99_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000012000

-- edifici
-- tipologia: tabella gestita
-- verifica: 2022-04-27 16:56 Chiara GDL
ALTER TABLE `edifici`
    ADD CONSTRAINT `edifici_ibfk_01_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_edifici` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `edifici_ibfk_02_nofollow` FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `edifici_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `edifici_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000012050

-- edifici_caratteristiche
-- tipologia: tabella gestita
-- verifica: 2022-04-27 16:56 Chiara GDL
ALTER TABLE `edifici_caratteristiche`
    ADD CONSTRAINT `edifici_caratteristiche_ibfk_01`           FOREIGN KEY (`id_edificio`) REFERENCES `edifici` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `edifici_caratteristiche_ibfk_02_nofollow`  FOREIGN KEY (`id_caratteristica`) REFERENCES `caratteristiche` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `edifici_caratteristiche_ibfk_98_nofollow`  FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `edifici_caratteristiche_ibfk_99_nofollow`  FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000015000

-- file
-- tipologia: tabella gestita
-- verifica: 2021-09-10 16:39 Fabio Mosti
ALTER TABLE `file`
    ADD CONSTRAINT `file_ibfk_01_nofollow`  FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_file` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `file_ibfk_02`           FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_03`           FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL, 
    ADD CONSTRAINT `file_ibfk_04`           FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_05`           FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_06`           FOREIGN KEY (`id_todo`) REFERENCES `todo` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_07`           FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_08`           FOREIGN KEY (`id_template`) REFERENCES `template` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_09`           FOREIGN KEY (`id_mailing`) REFERENCES `mailing` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_10`           FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_11`           FOREIGN KEY (`id_annuncio`) REFERENCES `annunci` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_12`           FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_13`           FOREIGN KEY (`id_categorie_annunci`) REFERENCES `categorie_annunci` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_14`           FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_15`           FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_16_nofollow`  FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_17`           FOREIGN KEY (`id_mail_out`) REFERENCES `mail_out` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_18`           FOREIGN KEY (`id_mail_sent`) REFERENCES `mail_sent` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_19`           FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_20`           FOREIGN KEY (`id_categoria_progetti`) REFERENCES `categorie_progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_21`           FOREIGN KEY (`id_documento`) REFERENCES `documenti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_22`           FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_23`           FOREIGN KEY (`id_edificio`) REFERENCES `edifici` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_24`           FOREIGN KEY (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_25`           FOREIGN KEY (`id_contratto`) REFERENCES `contratti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_26`           FOREIGN KEY (`id_valutazione`) REFERENCES `valutazioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_27`           FOREIGN KEY (`id_rinnovo`) REFERENCES `rinnovi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_28`           FOREIGN KEY (`id_anagrafica_certificazioni`) REFERENCES `anagrafica_certificazioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_29`           FOREIGN KEY (`id_valutazione_certificazioni`) REFERENCES `valutazioni_certificazioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_30`           FOREIGN KEY (`id_licenza`) REFERENCES `licenze` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_31`           FOREIGN KEY (`id_attivita`) REFERENCES `attivita` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_98_nofollow`  FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_99_nofollow`  FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000015050

-- formati_tipologie_corrispondenza
ALTER TABLE `formati_tipologie_corrispondenza`
    ADD CONSTRAINT `formati_tipologie_corrispondenza_ibfk_01_nofollow`  FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_corrispondenza` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- | 060000015200

-- gruppi
-- tipologia: tabella gestita
-- verifica: 2021-09-10 18:05 Fabio Mosti
ALTER TABLE `gruppi`
    ADD CONSTRAINT `gruppi_ibfk_01`             FOREIGN KEY (`id_genitore`) REFERENCES `gruppi` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `gruppi_ibfk_02`             FOREIGN KEY (`id_organizzazione`) REFERENCES `organizzazioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `gruppi_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `gruppi_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000015400

-- iban
-- tipologia: tabella gestita
-- verifica: 2021-09-22 11:59 Fabio Mosti
ALTER TABLE `iban`
    ADD CONSTRAINT `iban_ibfk_01`               FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `iban_ibfk_98_nofollow`      FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `iban_ibfk_99_nofollow`      FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000015600

-- immagini
-- tipologia: tabella gestita
-- verifica: 2021-09-22 12:34 Fabio Mosti
ALTER TABLE `immagini`
    ADD CONSTRAINT `immagini_ibfk_01`           FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `immagini_ibfk_02`           FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `immagini_ibfk_03`           FOREIGN KEY (`id_file`) REFERENCES `file` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `immagini_ibfk_04`           FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `immagini_ibfk_05`           FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `immagini_ibfk_06`           FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `immagini_ibfk_07`           FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `immagini_ibfk_08`           FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `immagini_ibfk_09`           FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `immagini_ibfk_10`           FOREIGN KEY (`id_annunci`) REFERENCES `annunci` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `immagini_ibfk_11`           FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `immagini_ibfk_12`           FOREIGN KEY (`id_categorie_annunci`) REFERENCES `categorie_annunci` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `immagini_ibfk_13`           FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL, 
    ADD CONSTRAINT `immagini_ibfk_14_nofollow`  FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `immagini_ibfk_15_nofollow`  FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_immagini` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `immagini_ibfk_16`           FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `immagini_ibfk_17`           FOREIGN KEY (`id_categoria_progetti`) REFERENCES `categorie_progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `immagini_ibfk_18`           FOREIGN KEY (`id_edificio`) REFERENCES `edifici` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `immagini_ibfk_19`           FOREIGN KEY (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `immagini_ibfk_20`           FOREIGN KEY (`id_contratto`) REFERENCES `contratti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `immagini_ibfk_21`           FOREIGN KEY (`id_valutazione`) REFERENCES `valutazioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `immagini_ibfk_22`           FOREIGN KEY (`id_rinnovo`) REFERENCES `rinnovi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `immagini_ibfk_23`           FOREIGN KEY (`id_banner`) REFERENCES `banner` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `immagini_ibfk_98_nofollow`  FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `immagini_ibfk_99_nofollow`  FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000015700

-- immobili
-- tipologia: tabella gestita
-- verifica: 2022-04-27 12:20 Chiara GDL
ALTER TABLE `immobili`
    ADD CONSTRAINT `immobili_ibfk_01_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_immobili` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `immobili_ifbk_02_nofollow` FOREIGN KEY (`id_edificio`) REFERENCES `edifici` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `immobili_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `immobili_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000015710

-- immobili_anagrafica
-- tipologia: tabella gestita
-- verifica: 2022-04-28 12:20 Chiara GDL
ALTER TABLE `immobili_anagrafica`
    ADD CONSTRAINT `immobili_anagrafica_ibfk_01`            FOREIGN KEY (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `immobili_anagrafica_ibfk_02_nofollow`   FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `immobili_anagrafica_ibfk_03_nofollow`   FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `immobili_anagrafica_ibfk_98_nofollow`   FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `immobili_anagrafica_ibfk_99_nofollow`   FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000015750

-- immobili_caratteristiche
-- tipologia: tabella gestita
-- verifica: 2022-04-28 12:20 Chiara GDL
ALTER TABLE `immobili_caratteristiche`
    ADD CONSTRAINT `immobili_caratteristiche_ibfk_01`           FOREIGN KEY (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `immobili_caratteristiche_ibfk_02_nofollow`  FOREIGN KEY (`id_caratteristica`) REFERENCES `caratteristiche` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `immobili_caratteristiche_ibfk_98_nofollow`  FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `immobili_caratteristiche_ibfk_99_nofollow`  FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000015800

-- indirizzi
-- tipologia: tabella gestita
-- verifica: 2021-09-23 16:08 Fabio Mosti
ALTER TABLE `indirizzi`
    ADD CONSTRAINT `indirizzi_ibfk_01_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_indirizzi` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `indirizzi_ibfk_02_nofollow` FOREIGN KEY (`id_comune`) REFERENCES `comuni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `indirizzi_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `indirizzi_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000015850

-- indirizzi_caratteristiche
-- tipologia: tabella gestita
-- verifica: 2022-05-03 15:21 Chiara GDL
ALTER TABLE `indirizzi_caratteristiche`
    ADD CONSTRAINT `indirizzi_caratteristiche_ibfk_01`           FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `indirizzi_caratteristiche_ibfk_02_nofollow`  FOREIGN KEY (`id_caratteristica`) REFERENCES `caratteristiche` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `indirizzi_caratteristiche_ibfk_98_nofollow`  FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `indirizzi_caratteristiche_ibfk_99_nofollow`  FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000016600

-- licenze
-- tipologia: tabella gestita
-- verifica: 2021-11-15 12:44 Chiara GDL
ALTER TABLE `licenze`
    ADD CONSTRAINT `licenze_ibfk_01_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_licenze` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `licenze_ibfk_02_nofollow` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `licenze_ibfk_03_nofollow` FOREIGN KEY (`id_rivenditore`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `licenze_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `licenze_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000016700

-- licenze_software
-- tipologia: tabella gestita
-- verifica: 2021-11-16 15:30 Chiara GDL
ALTER TABLE `licenze_software`
    ADD CONSTRAINT `licenze_software_ibfk_01` FOREIGN KEY (`id_licenza`) REFERENCES `licenze` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `licenze_software_ibfk_02` FOREIGN KEY (`id_software`) REFERENCES `software` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `licenze_software_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `licenze_software_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000017000

-- liste
-- tipolgia: tabella gestita
-- verifica: 2022-02-07 15:47 Chiara GDL
ALTER TABLE `liste`
    ADD CONSTRAINT `liste_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `liste_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000017100

-- liste_mail
-- tipolgia: tabella gestita
-- verifica: 2022-02-07 15:47 Chiara GDL
ALTER TABLE `liste_mail`
ADD CONSTRAINT `liste_mail_ibfk_01_nofollow` FOREIGN KEY (`id_lista`) REFERENCES `liste` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `liste_mail_ibfk_02` FOREIGN KEY (`id_mail`) REFERENCES `mail` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `liste_mail_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `liste_mail_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000017200

-- listini
-- tipologia: tabella gestita
-- verifica: 2021-09-24 17:55 Fabio Mosti
ALTER TABLE `listini`
    ADD CONSTRAINT `listini_ibfk_01_nofollow`   FOREIGN KEY (`id_valuta`) REFERENCES `valute` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `listini_ibfk_98_nofollow`   FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `listini_ibfk_99_nofollow`   FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000017400

-- listini_clienti
-- tipologia: tabella gestita
-- verifica: 2021-09-24 18:17 Fabio Mosti
ALTER TABLE `listini_clienti`
    ADD CONSTRAINT `listini_clienti_ibfk_01_nofollow`   FOREIGN KEY (`id_listino`) REFERENCES `listini` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `listini_clienti_ibfk_02_nofollow`   FOREIGN KEY (`id_cliente`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `listini_clienti_ibfk_98_nofollow`   FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `listini_clienti_ibfk_99_nofollow`   FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000018000

-- luoghi
-- tipologia: tabella gestita
-- verifica: 2021-09-24 18:42 Fabio Mosti
ALTER TABLE `luoghi`
    ADD CONSTRAINT `luoghi_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `luoghi` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `luoghi_ibfk_02_nofollow` FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `luoghi_ibfk_03_nofollow` FOREIGN KEY (`id_edificio`) REFERENCES `edifici` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `luoghi_ibfk_04_nofollow` FOREIGN KEY (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `luoghi_ibfk_05_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_luoghi`(`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `luoghi_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `luoghi_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000018200

-- macro
-- tipologia: tabella gestita
-- verifica: 2021-09-24 19:36 Fabio Mosti
ALTER TABLE `macro`
    ADD CONSTRAINT `macro_ibfk_01`          FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `macro_ibfk_02`          FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `macro_ibfk_03`          FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `macro_ibfk_04`          FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `macro_ibfk_05`          FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `macro_ibfk_06`          FOREIGN KEY (`id_annunci`) REFERENCES `annunci` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `macro_ibfk_07`          FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `macro_ibfk_08`          FOREIGN KEY (`id_categorie_annunci`) REFERENCES `categorie_annunci` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `macro_ibfk_09`          FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `macro_ibfk_10`          FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `macro_ibfk_11`          FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `macro_ibfk_12`          FOREIGN KEY (`id_categoria_progetti`) REFERENCES `categorie_progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `macro_ibfk_13`          FOREIGN KEY (`id_pianificazione`) REFERENCES `pianificazioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `macro_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `macro_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000018600

-- mail
-- tipologia: tabella gestita
-- verifica: 2021-09-27 18:35 Fabio Mosti
ALTER TABLE `mail`
    ADD CONSTRAINT `mail_ibfk_01`           FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_mail` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `mail_ibfk_02`           FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `mail_ibfk_98_nofollow`  FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `mail_ibfk_99_nofollow`  FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000018800

-- mail_out
-- tipolgia: tabella gestita
-- verifica: 2021-09-28 15:35 Fabio Mosti
ALTER TABLE `mail_out`
    ADD CONSTRAINT `mail_out_ibfk_01_nofollow`  FOREIGN KEY (`id_mail`) REFERENCES `mail` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `mail_out_ibfk_98_nofollow`  FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `mail_out_ibfk_99_nofollow`  FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000018900

-- mail_sent
-- tipolgia: tabella gestita
-- verifica: 2021-09-28 15:35 Fabio Mosti
ALTER TABLE `mail_sent`
    ADD CONSTRAINT `mail_sent_ibfk_01_nofollow`     FOREIGN KEY (`id_mail`) REFERENCES `mail` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `mail_sent_ibfk_98_nofollow`     FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `mail_sent_ibfk_99_nofollow`     FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000019000

-- mailing
-- tipolgia: tabella gestita
-- verifica: 2022-02-07 15:47 Chiara GDL
ALTER TABLE `mailing`
    ADD CONSTRAINT `mailing_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `mailing_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000019050

-- mailing_liste
-- tipolgia: tabella gestita
-- verifica: 2022-02-07 15:47 Chiara GDL
ALTER TABLE `mailing_liste`
ADD CONSTRAINT `mailing_liste_ibfk_01_nofollow` FOREIGN KEY (`id_lista`) REFERENCES `liste` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `mailing_liste_ibfk_02` FOREIGN KEY (`id_mailing`) REFERENCES `mailing` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `mailing_liste_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `mailing_liste_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000019100

-- mailing_mail
-- tipolgia: tabella gestita
-- verifica: 2022-02-07 15:47 Chiara GDL	
ALTER TABLE `mailing_mail`
    ADD CONSTRAINT `mailing_mail_ibfk_01_nofollow`     FOREIGN KEY (`id_mailing`) REFERENCES `mailing` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `mailing_mail_ibfk_02_nofollow`     FOREIGN KEY (`id_mail`) REFERENCES `mail` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `mailing_mail_ibfk_03_nofollow`     FOREIGN KEY (`id_mail_out`) REFERENCES `mail_out` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `mailing_mail_ibfk_98_nofollow`     FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `mailing_mail_ibfk_99_nofollow`     FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000020200

-- marchi
-- tipologia: tabella gestita
-- verifica: 2021-09-28 16:54 Fabio Mosti
ALTER TABLE `marchi`
    ADD CONSTRAINT `marchi_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `marchi_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000020600

-- mastri
-- tipologia: tabella gestita
-- verifica: 2021-09-29 11:35 Fabio Mosti
ALTER TABLE `mastri`
    ADD CONSTRAINT `mastri_ibfk_01_nofollow`    FOREIGN KEY (`id_genitore`) REFERENCES `mastri` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `mastri_ibfk_02_nofollow`    FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_mastri` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `mastri_ibfk_03_nofollow`    FOREIGN KEY (`id_anagrafica_indirizzi`) REFERENCES `anagrafica_indirizzi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `mastri_ibfk_04_nofollow`    FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `mastri_ibfk_05_nofollow`    FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `mastri_ibfk_06_nofollow`    FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `mastri_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `mastri_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000021000

-- matricole
-- tipologia: tabella gestita
-- verifica: 2021-12-28 16:20 Chiara GDL
ALTER TABLE `matricole`
    ADD CONSTRAINT `matricole_ibfk_01_nofollow` FOREIGN KEY (`id_marchio`) REFERENCES `marchi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `matricole_ibfk_02_nofollow` FOREIGN KEY (`id_produttore`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `matricole_ibfk_03_nofollow` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `matricole_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `matricole_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000021600

-- menu
-- tipologia: tabella gestita
-- verifica: 2021-10-01 09:32 Fabio Mosti
ALTER TABLE `menu`
    ADD CONSTRAINT `menu_ibfk_01_nofollow`      FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `menu_ibfk_02`               FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `menu_ibfk_03`               FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `menu_ibfk_04`               FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `menu_ibfk_05`               FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `menu_ibfk_06`               FOREIGN KEY (`id_categoria_progetti`) REFERENCES `categorie_progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `menu_ibfk_98_nofollow`      FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `menu_ibfk_99_nofollow`      FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000021700

-- messaggi
-- tipologia: tabella gestita
-- verifica: 2022-04-26 17:32 Chiara GDL
ALTER TABLE `messaggi` 
    ADD CONSTRAINT `messaggi_ibfk_01_nofollow` FOREIGN KEY (`id_conversazione`) REFERENCES `conversazioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `messaggi_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `messaggi_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000021750

-- messaggi_account
-- tipologia: tabella gestita
-- verifica: 2022-04-26 17:32 Chiara GDL
ALTER TABLE `messaggi_account` 
    ADD CONSTRAINT `messaggi_ibfk_01_nofollow` FOREIGN KEY (`id_messaggio`) REFERENCES `messaggi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `messaggi_ibfk_02_nofollow` FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `messaggi_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `messaggi_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000021800

-- metadati
-- tipologia: tabella gestita
-- verifica: 2021-10-01 10:33 Fabio Mosti
ALTER TABLE `metadati`
    ADD CONSTRAINT `metadati_ibfk_01_nofollow`  FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `metadati_ibfk_02`           FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `metadati_ibfk_03`           FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `metadati_ibfk_04`           FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `metadati_ibfk_05`           FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `metadati_ibfk_06`           FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `metadati_ibfk_07`           FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `metadati_ibfk_08`           FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `metadati_ibfk_09`           FOREIGN KEY (`id_annunci`) REFERENCES `annunci` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `metadati_ibfk_10`           FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `metadati_ibfk_11`           FOREIGN KEY (`id_categorie_annunci`) REFERENCES `categorie_annunci` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `metadati_ibfk_12`           FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `metadati_ibfk_13`           FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `metadati_ibfk_14`           FOREIGN KEY (`id_immagine`) REFERENCES `immagini` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `metadati_ibfk_15`           FOREIGN KEY (`id_video`) REFERENCES `video` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `metadati_ibfk_16`           FOREIGN KEY (`id_audio`) REFERENCES `audio` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `metadati_ibfk_17`           FOREIGN KEY (`id_file`) REFERENCES `file` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `metadati_ibfk_17`           FOREIGN KEY (`id_documento`) REFERENCES `documenti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `metadati_ibfk_17`           FOREIGN KEY (`id_documenti_articoli`) REFERENCES `documenti_articoli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `metadati_ibfk_18`           FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `metadati_ibfk_19`           FOREIGN KEY (`id_categoria_progetti`) REFERENCES `categorie_progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `metadati_ibfk_20`           FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `metadati_ibfk_21`           FOREIGN KEY (`id_edificio`) REFERENCES `edifici` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `metadati_ibfk_22`           FOREIGN KEY (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `metadati_ibfk_23`           FOREIGN KEY (`id_contratto`) REFERENCES `contratti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `metadati_ibfk_24`           FOREIGN KEY (`id_valutazione`) REFERENCES `valutazioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `metadati_ibfk_25`           FOREIGN KEY (`id_rinnovo`) REFERENCES `rinnovi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `metadati_ibfk_26`           FOREIGN KEY (`id_attivita`) REFERENCES `attivita` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `metadati_ibfk_27`           FOREIGN KEY (`id_tipologia_attivita`) REFERENCES `tipologie_attivita` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `metadati_ibfk_28`           FOREIGN KEY (`id_banner`) REFERENCES `banner` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `metadati_ibfk_29`           FOREIGN KEY (`id_pianificazione`) REFERENCES `pianificazioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `metadati_ibfk_30`           FOREIGN KEY (`id_todo`) REFERENCES `todo` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `metadati_ibfk_31`           FOREIGN KEY (`id_tipologia_todo`) REFERENCES `tipologie_todo` (`id`)  ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `metadati_ibfk_32`           FOREIGN KEY (`id_tipologia_contratti`) REFERENCES `tipologie_contratti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `metadati_ibfk_33`           FOREIGN KEY (`id_carrello`) REFERENCES `carrelli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `metadati_ibfk_98_nofollow`  FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `metadati_ibfk_99_nofollow`  FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000022000

-- notizie
-- tipologia: tabella gestita
-- verifica: 2021-10-01 12:09 Fabio Mosti
ALTER TABLE `notizie`
    ADD CONSTRAINT `notizie_ibfk_01_nofollow`   FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_notizie` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `notizie_ibfk_98_nofollow`   FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `notizie_ibfk_99_nofollow`   FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000022200

-- notizie_categorie
-- tipologia: tabella gestita
-- verifica: 2021-10-01 12:36 Fabio Mosti
ALTER TABLE `notizie_categorie`
    ADD CONSTRAINT `notizie_categorie_ibfk_01`              FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `notizie_categorie_ibfk_02`              FOREIGN KEY (`id_categoria`) REFERENCES `categorie_notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `notizie_categorie_ibfk_98_nofollow`     FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `notizie_categorie_ibfk_99_nofollow`     FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000022300

-- orari
ALTER TABLE `orari`
    ADD CONSTRAINT `orari_ibfk_01`              FOREIGN KEY (`id_tipologia_contratti`) REFERENCES `tipologie_contratti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `orari_ibfk_02`              FOREIGN KEY (`id_periodicita`) REFERENCES `periodicita` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `orari_ibfk_03_nofollow`     FOREIGN KEY (`id_giorno`) REFERENCES `giorni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `orari_ibfk_98_nofollow`     FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `orari_ibfk_99_nofollow`     FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;


-- | 060000022800

-- organizzazioni
-- tipologia: tabella gestita
-- verifica: 2021-10-04 11:37 Fabio Mosti
ALTER TABLE `organizzazioni`
    ADD CONSTRAINT `organizzazioni_ibfk_01_nofollow`    FOREIGN KEY (`id_genitore`) REFERENCES `organizzazioni` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `organizzazioni_ibfk_02`             FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `organizzazioni_ibfk_03_nofollow`    FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `organizzazioni_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `organizzazioni_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000023100

-- pagamenti
-- tipologia: tabella gestita
-- verifica: 2021-11-12 16:00 Chiara GDL
ALTER TABLE `pagamenti`
    ADD CONSTRAINT `pagamenti_ibfk_01_nofollow`    FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_pagamenti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `pagamenti_ibfk_02`             FOREIGN KEY (`id_documento`) REFERENCES `documenti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pagamenti_ibfk_03_nofollow`    FOREIGN KEY (`id_carrelli_articoli`) REFERENCES `carrelli_articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `pagamenti_ibfk_04_nofollow`    FOREIGN KEY (`id_creditore`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pagamenti_ibfk_05_nofollow`    FOREIGN KEY (`id_debitore`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pagamenti_ibfk_06_nofollow`    FOREIGN KEY (`id_mastro_provenienza`) REFERENCES `mastri` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pagamenti_ibfk_07_nofollow`    FOREIGN KEY (`id_mastro_destinazione`) REFERENCES `mastri` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pagamenti_ibfk_08_nofollow`    FOREIGN KEY (`id_iban`) REFERENCES `iban` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `pagamenti_ibfk_09_nofollow`    FOREIGN KEY (`id_listino`) REFERENCES `listini` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pagamenti_ibfk_10_nofollow`    FOREIGN KEY (`id_modalita_pagamento`) REFERENCES `modalita_pagamento` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pagamenti_ibfk_11_nofollow`    FOREIGN KEY (`id_pianificazione`) REFERENCES `pianificazioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pagamenti_ibfk_98_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pagamenti_ibfk_99_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000023200

-- pagine
-- tipologia: tabella gestita
-- verifica: 2021-10-04 11:37 Fabio Mosti
ALTER TABLE `pagine`
    ADD CONSTRAINT `pagine_ibfk_01_nofollow`    FOREIGN KEY (`id_genitore`) REFERENCES `pagine` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `pagine_ibfk_02_nofollow`    FOREIGN KEY (`id_contenuti`) REFERENCES `contenuti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pagine_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pagine_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000023700

-- pesi_tipologie_corrispondenza
ALTER TABLE `pesi_tipologie_corrispondenza`
    ADD CONSTRAINT `pesi_tipologie_corrispondenza_ibfk_01_nofollow`  FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_corrispondenza` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- | 060000023500

-- periodi
-- tipologia: tabella di supporto
-- verifica: 2022-05-24 12:57 Chiara GDL
ALTER TABLE `periodi`
    ADD CONSTRAINT `periodi_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `periodi` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	ADD CONSTRAINT `periodi_ibfk_02`          FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_periodi` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
   	ADD CONSTRAINT `periodi_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
   	ADD CONSTRAINT `periodi_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000023600

-- pianificazioni
-- tipologia: tabella gestita
-- verifica: 2021-10-05 17:29 Fabio Mosti
-- TODO vanno fatti tutti i constraints per i vari campi model_id_*?
ALTER TABLE `pianificazioni`
    ADD CONSTRAINT `pianificazioni_ibfk_00`             FOREIGN KEY (`id_genitore`) REFERENCES `pianificazioni` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `pianificazioni_ibfk_01`             FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pianificazioni_ibfk_02`             FOREIGN KEY (`id_todo`) REFERENCES `todo` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pianificazioni_ibfk_03`             FOREIGN KEY (`id_attivita`) REFERENCES `attivita` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pianificazioni_ibfk_04_nofollow`    FOREIGN KEY (`id_periodicita`) REFERENCES `periodicita` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pianificazioni_ibfk_05`             FOREIGN KEY (`id_contratto`) REFERENCES `contratti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pianificazioni_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pianificazioni_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000024000

-- popup
-- tipologia: tabella gestita
-- verifica: 2021-10-04 16:36 Fabio Mosti
ALTER TABLE `popup`
    ADD CONSTRAINT `popup_ibfk_01_nofollow`     FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_popup` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `popup_ibfk_98_nofollow`     FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `popup_ibfk_99_nofollow`     FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000024200

-- popup_pagine
-- tipologia: tabella gestita
-- verifica: 2021-10-04 16:37 Fabio Mosti
ALTER TABLE `popup_pagine`
    ADD CONSTRAINT `popup_pagine_ibfk_01`               FOREIGN KEY (`id_popup`) REFERENCES `popup` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `popup_pagine_ibfk_02_nofollow`      FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `popup_pagine_ibfk_98_nofollow`      FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `popup_pagine_ibfk_99_nofollow`      FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000025000

-- prezzi
-- tipologia: tabella gestita
-- verifica: 2021-10-08 14:08 Fabio Mosti
ALTER TABLE `prezzi`
    ADD CONSTRAINT `prezzi_ibfk_01`             FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `prezzi_ibfk_02`             FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `prezzi_ibfk_03_nofollow`    FOREIGN KEY (`id_listino`) REFERENCES `listini` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `prezzi_ibfk_04_nofollow`    FOREIGN KEY (`id_iva`) REFERENCES `iva` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `prezzi_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `prezzi_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000026000

-- prodotti
-- tipologia: tabella gestita
-- verifica: 2021-10-08 14:08 Fabio Mosti
ALTER TABLE `prodotti`
    ADD CONSTRAINT `prodotti_ibfk_01_nofollow`  FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_prodotti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `prodotti_ibfk_02_nofollow`  FOREIGN KEY (`id_marchio`) REFERENCES `marchi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `prodotti_ibfk_03_nofollow`  FOREIGN KEY (`id_produttore`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `prodotti_ibfk_98_nofollow`  FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `prodotti_ibfk_99_nofollow`  FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000026200

-- prodotti_caratteristiche
-- tipologia: tabella gestita
-- verifica: 2021-10-08 14:08 Fabio Mosti
ALTER TABLE `prodotti_caratteristiche`
    ADD CONSTRAINT `prodotti_caratteristiche_ibfk_01`           FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `prodotti_caratteristiche_ibfk_02_nofollow`  FOREIGN KEY (`id_caratteristica`) REFERENCES `caratteristiche` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `prodotti_caratteristiche_ibfk_03_nofollow`  FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `prodotti_caratteristiche_ibfk_98_nofollow`  FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `prodotti_caratteristiche_ibfk_99_nofollow`  FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000026400

-- prodotti_categorie
-- tipologia: tabella gestita
-- verifica: 2021-10-08 14:08 Fabio Mosti
ALTER TABLE `prodotti_categorie`
    ADD CONSTRAINT `prodotti_categorie_ibfk_01`             FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `prodotti_categorie_ibfk_02_nofollow`    FOREIGN KEY (`id_categoria`) REFERENCES `categorie_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `prodotti_categorie_ibfk_03_nofollow`    FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_prodotti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `prodotti_categorie_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `prodotti_categorie_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000027000

-- progetti
-- tipologia: tabella gestita
-- verifica: 2021-10-08 14:08 Fabio Mosti
ALTER TABLE `progetti`
    ADD CONSTRAINT `progetti_ibfk_01_nofollow`  FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_progetti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `progetti_ibfk_02_nofollow`  FOREIGN KEY (`id_pianificazione`) REFERENCES `pianificazioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `progetti_ibfk_03_nofollow`  FOREIGN KEY (`id_cliente`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `progetti_ibfk_04_nofollow`  FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `progetti_ibfk_05_nofollow`  FOREIGN KEY (`id_ranking`) REFERENCES `ranking` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `progetti_ibfk_06_nofollow`  FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `progetti_ibfk_07_nofollow`  FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `progetti_ibfk_08_nofollow`  FOREIGN KEY (`id_periodo`) REFERENCES `periodi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `progetti_ibfk_98_nofollow`  FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `progetti_ibfk_99_nofollow`  FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000027200

-- progetti_anagrafica
-- tipologia: tabella gestita
-- verifica: 2021-10-08 15:05 Fabio Mosti
ALTER TABLE `progetti_anagrafica`
    ADD CONSTRAINT `progetti_anagrafica_ibfk_01`            FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `progetti_anagrafica_ibfk_02_nofollow`   FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `progetti_anagrafica_ibfk_03_nofollow`   FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `progetti_anagrafica_ibfk_98_nofollow`   FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `progetti_anagrafica_ibfk_99_nofollow`   FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000027300

-- progetti_articoli
-- tipologia: tabella gestita
-- verifica: 2021-04-14 14:58 Chiara GDL
ALTER TABLE `progetti_articoli`
    ADD CONSTRAINT `progetti_articoli_ibfk_01` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `progetti_articoli_ibfk_02` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `progetti_articoli_ibfk_03_nofollow` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_articoli` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `progetti_articoli_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `progetti_articoli_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;
------------------------------
-- | 060000027400

-- progetti_categorie
-- tipologia: tabella gestita
-- verifica: 2021-10-08 15:05 Fabio Mosti
ALTER TABLE `progetti_categorie`
    ADD CONSTRAINT `progetti_categorie_ibfk_01`             FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `progetti_categorie_ibfk_02_nofollow`    FOREIGN KEY (`id_categoria`) REFERENCES `categorie_progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `progetti_categorie_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `progetti_categorie_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000027600

-- progetti_certificazioni
-- tipologia: tabella gestita
-- verifica: 2022-02-03 11:12 Chiara GDL
ALTER TABLE `progetti_certificazioni`
    ADD CONSTRAINT `progetti_certificazioni_ibfk_01`             FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `progetti_certificazioni_ibfk_02_nofollow`    FOREIGN KEY (`id_certificazione`) REFERENCES `certificazioni` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `progetti_certificazioni_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `progetti_certificazioni_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000027800

-- progetti_matricole
-- tipologia: tabella gestita
-- verifica: 2021-10-08 15:05 Fabio Mosti
ALTER TABLE `progetti_matricole`
    ADD CONSTRAINT `progetti_matricole_ibfk_01`             FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `progetti_matricole_ibfk_02_nofollow`    FOREIGN KEY (`id_matricola`) REFERENCES `matricole` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `progetti_matricole_ibfk_03_nofollow`    FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_matricole` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `progetti_matricole_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `progetti_matricole_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000028000

-- provincie
-- tipologia: tabella di supporto
-- verifica: 2021-10-08 15:05 Fabio Mosti
ALTER TABLE `provincie`
    ADD CONSTRAINT `provincie_ibfk_01_nofollow`     FOREIGN KEY (`id_regione`) REFERENCES `regioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000028400

-- pubblicazioni
-- tipologia: tabella gestita
-- verifica: 2021-10-08 17:44 Fabio Mosti
ALTER TABLE `pubblicazioni`
    ADD CONSTRAINT `pubblicazioni_ibfk_01_nofollow`         FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_pubblicazioni` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `pubblicazioni_ibfk_02`                  FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pubblicazioni_ibfk_03`                  FOREIGN KEY (`id_popup`) REFERENCES `popup` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pubblicazioni_ibfk_04`                  FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pubblicazioni_ibfk_05`                  FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pubblicazioni_ibfk_06`                  FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pubblicazioni_ibfk_07`                  FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pubblicazioni_ibfk_08`                  FOREIGN KEY (`id_annunci`) REFERENCES `annunci` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pubblicazioni_ibfk_09`                  FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pubblicazioni_ibfk_10`                  FOREIGN KEY (`id_categorie_annunci`) REFERENCES `categorie_annunci` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pubblicazioni_ibfk_11`                  FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pubblicazioni_ibfk_12`                  FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pubblicazioni_ibfk_13`                  FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pubblicazioni_ibfk_14`                  FOREIGN KEY (`id_categoria_progetti`) REFERENCES `categorie_progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pubblicazioni_ibfk_15`                  FOREIGN KEY (`id_banner`) REFERENCES `banner` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pubblicazioni_ibfk_98_nofollow`         FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pubblicazioni_ibfk_99_nofollow`         FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000028600

-- ranking
-- tipologia: tabella assistita
-- verifica: 2021-10-11 17:53 Fabio Mosti
ALTER TABLE `ranking`
    ADD CONSTRAINT `ranking_ibfk_98_nofollow`   FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `ranking_ibfk_99_nofollow`   FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000029400

-- redirect
-- tipologia: tabella gestita
-- verifica: 2021-10-09 14:43 Fabio Mosti
ALTER TABLE `redirect`
    ADD CONSTRAINT `redirect_ibfk_98_nofollow`  FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `redirect_ibfk_99_nofollow`  FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000030200

-- regioni
-- tipologia: tabella di supporto
-- verifica: 2021-10-09 15:26 Fabio Mosti
ALTER TABLE `regioni`
    ADD CONSTRAINT `regioni_ibfk_01_nofollow`   FOREIGN KEY (`id_stato`) REFERENCES `stati` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000030300

-- relazioni_anagrafica
-- tipologia: tabella relazione
-- verifica: 2022-02-03 11:12 Chiara GDL
ALTER TABLE `relazioni_anagrafica`
    ADD CONSTRAINT `relazioni_anagrafica_ibfk_01` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `relazioni_anagrafica_ibfk_02` FOREIGN KEY (`id_anagrafica_collegata`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `relazioni_anagrafica_ibfk_03_nofollow` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `relazioni_anagrafica_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `relazioni_anagrafica_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000030350

-- relazioni_categorie_progetti
-- tipologia: tabella relazione
-- verifica: 2022-02-03 11:12 Chiara GDL
ALTER TABLE `relazioni_categorie_progetti`
    ADD CONSTRAINT `relazioni_categorie_progetti_ibfk_01` FOREIGN KEY (`id_categoria`) REFERENCES `categorie_progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `relazioni_categorie_progetti_ibfk_02` FOREIGN KEY (`id_categoria_collegata`) REFERENCES `categorie_progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `relazioni_categorie_progetti_ibfk_03_nofollow` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_progetti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `relazioni_categorie_progetti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `relazioni_categorie_progetti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;


-- | 060000030400

-- relazioni_documenti
-- tipologia: tabella relazione
-- verifica: 2022-01-17 16:12 Chiara GDL
ALTER TABLE `relazioni_documenti`
    ADD CONSTRAINT `relazioni_documenti_ibfk_01` FOREIGN KEY (`id_documento`) REFERENCES `documenti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `relazioni_documenti_ibfk_02` FOREIGN KEY (`id_documento_collegato`) REFERENCES `documenti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `relazioni_documenti_ibfk_03`     FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_documenti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `relazioni_documenti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `relazioni_documenti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000030410

-- relazioni_documenti_articoli
-- tipologia: tabella relazione
-- verifica: 2022-01-17 16:12 Chiara GDL
ALTER TABLE `relazioni_documenti_articoli`
    ADD CONSTRAINT `relazioni_documenti_articoli_ibfk_01` FOREIGN KEY (`id_documenti_articolo`) REFERENCES `documenti_articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `relazioni_documenti_articoli_ibfk_02` FOREIGN KEY (`id_documenti_articolo_collegato`) REFERENCES `documenti_articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `relazioni_documenti_articoli_ibfk_03`     FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_documenti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `relazioni_documenti_articoli_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `relazioni_documenti_articoli_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000030440

-- relazioni_pagamenti
-- tipologia: tabella relazione
-- verifica: 2022-01-17 16:12 Chiara GDL
ALTER TABLE `relazioni_pagamenti`
    ADD CONSTRAINT `relazioni_pagamenti_ibfk_01` FOREIGN KEY (`id_pagamento`) REFERENCES `pagamenti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `relazioni_pagamenti_ibfk_02` FOREIGN KEY (`id_pagamento_collegato`) REFERENCES `pagamenti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `relazioni_pagamenti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `relazioni_pagamenti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000030490

-- relazioni_progetti
-- tipologia: tabella relazione
-- verifica: 2022-01-17 16:12 Chiara GDL
ALTER TABLE `relazioni_progetti`
    ADD CONSTRAINT `relazioni_progetti_ibfk_01` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `relazioni_progetti_ibfk_02` FOREIGN KEY (`id_progetto_collegato`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `relazioni_progetti_ibfk_03_nofollow` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_progetti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `relazioni_progetti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `relazioni_progetti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000030500

-- relazioni_software
-- tipologia: tabella relazione
-- verifica: 2022-01-17 16:12 Chiara GDL
ALTER TABLE `relazioni_software`
    ADD CONSTRAINT `relazioni_software_ibfk_01` FOREIGN KEY (`id_software`) REFERENCES `software` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `relazioni_software_ibfk_02` FOREIGN KEY (`id_software_collegato`) REFERENCES `software` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `relazioni_software_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `relazioni_software_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000030800

-- reparti
-- tipologia: tabella assistita
-- verifica: 2021-12-27 10:42 Fabio Mosti
ALTER TABLE `reparti`
    ADD CONSTRAINT `reparti_ibfk_01_nofollow`   FOREIGN KEY (`id_iva`) REFERENCES `iva` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `reparti_ibfk_02_nofollow`   FOREIGN KEY (`id_settore`) REFERENCES `settori` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `reparti_ibfk_98_nofollow`   FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `reparti_ibfk_99_nofollow`   FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000031500

-- rinnovi
-- tipologia: tabella gestita
-- verifica: 2022-02-21 12:59 Chiara GDL
ALTER TABLE `rinnovi`
    ADD CONSTRAINT `rinnovi_ibfk_01` FOREIGN KEY (`id_contratto`) REFERENCES `contratti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `rinnovi_ibfk_02` FOREIGN KEY (`id_licenza`) REFERENCES `licenze` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `rinnovi_ibfk_03` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `rinnovi_ibfk_04` FOREIGN KEY (`id_tipologia_contratto`) REFERENCES `tipologie_contratti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `rinnovi_ibfk_05` FOREIGN KEY (`id_categoria_progetti`) REFERENCES `categorie_progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `rinnovi_ibfk_06` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_rinnovi` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `rinnovi_ibfk_07` FOREIGN KEY (`id_periodicita`) REFERENCES `periodicita` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `rinnovi_ibfk_08_nofollow` FOREIGN KEY (`id_pianificazione`) REFERENCES `pianificazioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `rinnovi_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `rinnovi_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000031550

-- rinnovi_documenti_articoli
-- tipologia: tabella gestita
-- verifica: 2022-03-08 15:59 Chiara GDL
ALTER TABLE `rinnovi_documenti_articoli`
    ADD CONSTRAINT `rinnovi_documenti_articoli_ibfk_01` FOREIGN KEY (`id_rinnovo`) REFERENCES `rinnovi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `rinnovi_documenti_articoli_ibfk_02` FOREIGN KEY (`id_documenti_articolo`) REFERENCES `documenti_articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `rinnovi_documenti_articoli_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `rinnovi_documenti_articoli_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000032000

-- risorse
-- tipologia: tabella gestita
-- verifica: 2021-10-09 15:57 Fabio Mosti
ALTER TABLE `risorse`
    ADD CONSTRAINT `risorse_ibfk_01_nofollow`   FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_risorse` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `risorse_ibfk_02_nofollow`   FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `risorse_ibfk_03_nofollow`   FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `risorse_ibfk_98_nofollow`   FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `risorse_ibfk_99_nofollow`   FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000032100

-- risorse_account
-- tipologia: tabella di supporto
-- verifica: 2022-08-02 12:07 Chiara GDL
ALTER TABLE `risorse_account`
    ADD CONSTRAINT `risorse_account_ibfk_01`             FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `risorse_account_ibfk_02_nofollow`    FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `risorse_account_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `risorse_account_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000032200

-- risorse_anagrafica
-- tipologia: tabella di supporto
-- verifica: 2021-10-09 16:10 Fabio Mosti
ALTER TABLE `risorse_anagrafica`
    ADD CONSTRAINT `risorse_anagrafica_ibfk_01`             FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `risorse_anagrafica_ibfk_02_nofollow`    FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `risorse_anagrafica_ibfk_03_nofollow`    FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `risorse_anagrafica_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `risorse_anagrafica_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000032400

-- risorse_categorie
-- tipologia: tabella di supporto
-- verifica: 2021-10-09 17:59 Fabio Mosti
ALTER TABLE `risorse_categorie`
    ADD CONSTRAINT `risorse_categorie_ibfk_01`              FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `risorse_categorie_ibfk_02_nofollow`     FOREIGN KEY (`id_categoria`) REFERENCES `categorie_risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `risorse_categorie_ibfk_98_nofollow`     FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `risorse_categorie_ibfk_99_nofollow`     FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000034000

-- ruoli_anagrafica
-- tipologia: tabella di supporto
-- verifica: 2021-10-09 18:14 Fabio Mosti
ALTER TABLE `ruoli_anagrafica`
    ADD CONSTRAINT `ruoli_anagrafica_ibfk_01`   FOREIGN KEY (`id_genitore`) REFERENCES `ruoli_anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 060000034100

-- ruoli_articoli
-- tipologia: tabella di supporto
-- verifica: 2021-10-09 18:14 Fabio Mosti
ALTER TABLE `ruoli_articoli`
    ADD CONSTRAINT `ruoli_articoli_ibfk_01`   FOREIGN KEY (`id_genitore`) REFERENCES `ruoli_articoli` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;
    
-- | 060000034200

-- ruoli_audio
-- tipologia: tabella di supporto
-- verifica: 2021-10-09 18:36 Fabio Mosti
ALTER TABLE `ruoli_audio`
    ADD CONSTRAINT `ruoli_audio_ibfk_01`   FOREIGN KEY (`id_genitore`) REFERENCES `ruoli_audio` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 060000034250

-- ruoli_categorie_progetti
-- tipologia: tabella di supporto
-- verifica: 2021-10-09 18:36 Fabio Mosti
ALTER TABLE `ruoli_categorie_progetti`
    ADD CONSTRAINT `ruoli_categorie_progetti_ibfk_01`   FOREIGN KEY (`id_genitore`) REFERENCES `ruoli_categorie_progetti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;


-- | 060000034300

-- ruoli_documenti
-- tipologia: tabella di supporto
-- verifica: 2022-06-09 16:21 Chiara GDL
ALTER TABLE `ruoli_documenti`
    ADD CONSTRAINT `ruoli_documenti_ibfk_01`     FOREIGN KEY (`id_genitore`) REFERENCES `ruoli_documenti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 060000034400

-- ruoli_file
-- tipologia: tabella di supporto
-- verifica: 2021-10-11 18:25 Fabio Mosti
ALTER TABLE `ruoli_file`
    ADD CONSTRAINT `ruoli_file_ibfk_01`     FOREIGN KEY (`id_genitore`) REFERENCES `ruoli_file` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 060000034600

-- ruoli_immagini
-- tipologia: tabella di supporto
-- verifica: 2021-10-11 18:25 Fabio Mosti
ALTER TABLE `ruoli_immagini`
    ADD CONSTRAINT `ruoli_immagini_ibfk_01`     FOREIGN KEY (`id_genitore`) REFERENCES `ruoli_immagini` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 060000034800

-- ruoli_indirizzi
-- tipologia: tabella di supporto
-- verifica: 2021-10-12 10:57 Fabio Mosti
ALTER TABLE `ruoli_indirizzi`
    ADD CONSTRAINT `ruoli_indirizzi_ibfk_01`    FOREIGN KEY (`id_genitore`) REFERENCES `ruoli_indirizzi` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 060000034900

-- ruoli_matricole
-- tipologia: tabella di supporto
-- verifica: 2021-10-12 10:57 Fabio Mosti
ALTER TABLE `ruoli_matricole`
    ADD CONSTRAINT `ruoli_matricole_ibfk_01`    FOREIGN KEY (`id_genitore`) REFERENCES `ruoli_matricole` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 060000035000

-- ruoli_prodotti
-- tipologia: tabella di supporto
-- verifica: 2021-10-12 10:57 Fabio Mosti
ALTER TABLE `ruoli_prodotti`
    ADD CONSTRAINT `ruoli_prodotti_ibfk_01`     FOREIGN KEY (`id_genitore`) REFERENCES `ruoli_prodotti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 060000035200

-- ruoli_video
-- tipologia: tabella di supporto
-- verifica: 2021-10-12 10:57 Fabio Mosti
ALTER TABLE `ruoli_video`
    ADD CONSTRAINT `ruoli_video_ibfk_01`        FOREIGN KEY (`id_genitore`) REFERENCES `ruoli_video` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 060000037000

-- settori
-- tipologia: tabella di supporto
-- verifica: 2021-10-12 10:57 Fabio Mosti
ALTER TABLE `settori`
    ADD CONSTRAINT `settori_ibfk_01`            FOREIGN KEY (`id_genitore`) REFERENCES `settori` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 060000041000

-- sms_out
-- tipolgia: tabella gestita
-- verifica: 2021-10-12 12:03 Fabio Mosti
ALTER TABLE `sms_out`
    ADD CONSTRAINT `sms_out_ibfk_01_nofollow`   FOREIGN KEY (`id_telefono`) REFERENCES `telefoni` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `sms_out_ibfk_98_nofollow`   FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `sms_out_ibfk_99_nofollow`   FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000041200

-- sms_sent
-- tipolgia: tabella gestita
-- verifica: 2021-10-12 12:03 Fabio Mosti
ALTER TABLE `sms_sent`
    ADD CONSTRAINT `sms_sent_ibfk_01_nofollow`  FOREIGN KEY (`id_telefono`) REFERENCES `telefoni` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `sms_sent_ibfk_98_nofollow`  FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `sms_sent_ibfk_99_nofollow`  FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000041400

-- software
-- tipologia: tabella gestita
-- verifica: 2021-11-16 10:39 Chiara GDL
ALTER TABLE `software`
    ADD CONSTRAINT `software_ibfk_01_nofollow`   FOREIGN KEY (`id_genitore`) REFERENCES `software` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `software_ibfk_02_nofollow`   FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `software_ibfk_98_nofollow`   FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `software_ibfk_99_nofollow`   FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000042000

-- stati
-- tipologia: tabella di supporto
-- verifica: 2021-10-12 12:03 Fabio Mosti
ALTER TABLE `stati`
    ADD CONSTRAINT `stati_ibfk_01_nofollow`     FOREIGN KEY (`id_continente`) REFERENCES `continenti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000042200

-- stati_lingue
-- tipologia: tabella di supporto
-- verifica: 2021-10-12 15:30 Fabio Mosti
ALTER TABLE `stati_lingue`
    ADD CONSTRAINT `stati_lingue_ibfk_01_nofollow`  FOREIGN KEY (`id_stato`) REFERENCES `stati` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `stati_lingue_ibfk_02_nofollow`  FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 060000042500

-- step
ALTER TABLE `step`
    ADD CONSTRAINT `step_ibfk_01` FOREIGN KEY (`id_funnel`) REFERENCES `funnel` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000043000

-- task
-- tipologia: tabella gestita
-- verifica: 2021-10-15 10:42 Fabio Mosti
ALTER TABLE `task`
    ADD CONSTRAINT `task_ibfk_98_nofollow`      FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `task_ibfk_99_nofollow`      FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000043600

-- telefoni
-- tipologia: tabella gestita
-- verifica: 2021-10-15 10:51 Fabio Mosti
ALTER TABLE `telefoni`
    ADD CONSTRAINT `telefoni_ibfk_01`               FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `telefoni_ibfk_02_nofollow`      FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_telefoni` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `telefoni_ibfk_98_nofollow`      FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `telefoni_ibfk_99_nofollow`      FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000044000

-- template
-- tipologia: tabella gestita
-- verifica: 2021-10-15 12:41 Fabio Mosti
ALTER TABLE `template`
    ADD CONSTRAINT `template_ibfk_98_nofollow`      FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `template_ibfk_99_nofollow`      FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000045000

-- testate
-- tipologia: tabella gestita
-- verifica: 2021-10-15 12:41 Fabio Mosti
ALTER TABLE `testate`
    ADD CONSTRAINT `testate_ibfk_98_nofollow`       FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `testate_ibfk_99_nofollow`       FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000050000

-- tipologie_anagrafica
-- tipologia: tabella assistita
-- verifica: 2021-10-15 18:10 Fabio Mosti
ALTER TABLE `tipologie_anagrafica`
    ADD CONSTRAINT `tipologie_anagrafica_ibfk_01_nofollow`      FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `tipologie_anagrafica_ibfk_98_nofollow`      FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_anagrafica_ibfk_99_nofollow`      FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000050400

-- tipologie_attivita
-- tipologia: tabella assistita
-- verifica: 2021-10-15 18:10 Fabio Mosti
ALTER TABLE `tipologie_attivita`
    ADD CONSTRAINT `tipologie_attivita_ibfk_01_nofollow`        FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_attivita` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `tipologie_attivita_ibfk_98_nofollow`        FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_attivita_ibfk_99_nofollow`        FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000050450

-- tipologie_badge
-- tipologia: tabella assistita
-- verifica: 2022-07-20 17:22 Chiara GDL
ALTER TABLE `tipologie_badge`
    ADD CONSTRAINT `tipologie_badge_ibfk_01_nofollow`          FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_badge` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `tipologie_badge_ibfk_98_nofollow`          FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_badge_ibfk_99_nofollow`          FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000050500

-- tipologie_banner
-- tipologia: tabella assistita
-- verifica: 2022-07-20 17:22 Chiara GDL
ALTER TABLE `tipologie_banner`
    ADD CONSTRAINT `tipologie_banner_ibfk_01_nofollow`          FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_banner` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `tipologie_banner_ibfk_98_nofollow`          FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_banner_ibfk_99_nofollow`          FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000050600

-- tipologie_chiavi
-- tipologia: tabella assistita
-- verifica: 2021-11-15 11:10 Chiara GDL
ALTER TABLE `tipologie_chiavi`
    ADD CONSTRAINT `tipologie_chiavi_ibfk_01_nofollow`        FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_chiavi` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `tipologie_chiavi_ibfk_98_nofollow`        FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_chiavi_ibfk_99_nofollow`        FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000050800

-- tipologie_contatti
-- tipologia: tabella assistita
-- verifica: 2021-10-15 18:10 Fabio Mosti
ALTER TABLE `tipologie_contatti`
    ADD CONSTRAINT `tipologie_contatti_ibfk_01_nofollow`        FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_contatti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `tipologie_contatti_ibfk_98_nofollow`        FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_contatti_ibfk_99_nofollow`        FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000050900

-- tipologie_contratti
-- tipologia: tabella gestita
-- verifica: 2022-02-21 11:47 Chiara GDL
ALTER TABLE `tipologie_contratti`
    ADD CONSTRAINT `tipologie_contratti_ibfk_01_nofollow`        FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_contratti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `tipologie_contratti_ibfk_02_nofollow`        FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_contratti_ibfk_03_nofollow`        FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_contratti_ibfk_04_nofollow`        FOREIGN KEY (`id_categoria_progetti`) REFERENCES `categorie_progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_contratti_ibfk_98_nofollow`        FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_contratti_ibfk_99_nofollow`        FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000051000

-- tipologie_corrispondenza
ALTER TABLE `tipologie_corrispondenza`
    ADD CONSTRAINT `tipologie_corrispondenza_ibfk_01_nofollow`       FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_corrispondenza` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `tipologie_corrispondenza_ibfk_98_nofollow`       FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_corrispondenza_ibfk_99_nofollow`       FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000052600

-- tipologie_documenti
-- tipologia: tabella assistita
-- verifica: 2021-10-15 18:10 Fabio Mosti
ALTER TABLE `tipologie_documenti`
    ADD CONSTRAINT `tipologie_documenti_ibfk_01_nofollow`       FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_documenti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `tipologie_documenti_ibfk_98_nofollow`       FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_documenti_ibfk_99_nofollow`       FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000052800

-- tipologie_edifici
-- tipologia: tabella di supporto
-- verifica: 2022-04-27 17:00 Chiara GDL
ALTER TABLE `tipologie_edifici`
  ADD CONSTRAINT `tipologie_edifici_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_edifici` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `tipologie_edifici_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  ADD CONSTRAINT `tipologie_edifici_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000052900

-- tipologie_immobili
-- tipologia: tabella di supporto
-- verifica: 2022-04-27 17:00 Chiara GDL
ALTER TABLE `tipologie_immobili`
  ADD CONSTRAINT `tipologie_immobili_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_immobili` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `tipologie_immobili_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  ADD CONSTRAINT `tipologie_immobili_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;
  
-- | 060000053000

-- tipologie_indirizzi
-- tipologia: tabella assistita
-- verifica: 2021-10-15 18:10 Fabio Mosti
ALTER TABLE `tipologie_indirizzi`
    ADD CONSTRAINT `tipologie_indirizzi_ibfk_01_nofollow`       FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_indirizzi` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `tipologie_indirizzi_ibfk_98_nofollow`       FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_indirizzi_ibfk_99_nofollow`       FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000053200

-- tipologie_licenze
-- tipologia: tabella assistita
-- verifica: 2021-11-15 11:10 Chiara GDL
ALTER TABLE `tipologie_licenze`
    ADD CONSTRAINT `tipologie_licenze_ibfk_01_nofollow`        FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_licenze` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `tipologie_licenze_ibfk_98_nofollow`        FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_licenze_ibfk_99_nofollow`        FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000053300

-- tipologie_luoghi
-- tipologia: tabella gestita
-- verifica: 2022-02-21 15:30 Chiara GDL
ALTER TABLE `tipologie_luoghi`
    ADD CONSTRAINT `tipologie_luoghi_ibfk_01_nofollow`          FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_mastri` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `tipologie_luoghi_ibfk_98_nofollow`          FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_luoghi_ibfk_99_nofollow`          FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000053400

-- tipologie_mastri
-- tipologia: tabella assistita
-- verifica: 2021-10-15 18:10 Fabio Mosti
ALTER TABLE `tipologie_mastri`
    ADD CONSTRAINT `tipologie_mastri_ibfk_01_nofollow`          FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_mastri` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `tipologie_mastri_ibfk_98_nofollow`          FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_mastri_ibfk_99_nofollow`          FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000053800

-- tipologie_notizie
-- tipologia: tabella assistita
-- verifica: 2021-10-15 18:10 Fabio Mosti
ALTER TABLE `tipologie_notizie`
    ADD CONSTRAINT `tipologie_notizie_ibfk_01_nofollow`         FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_notizie` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `tipologie_notizie_ibfk_98_nofollow`         FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_notizie_ibfk_99_nofollow`         FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000054000

-- tipologie_pagamenti
-- tipologia: tabella assistita
-- verifica: 2021-11-15 11:10 Chiara GDL
ALTER TABLE `tipologie_pagamenti`
    ADD CONSTRAINT `tipologie_pagamenti_ibfk_01_nofollow`        FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_pagamenti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `tipologie_pagamenti_ibfk_98_nofollow`        FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_pagamenti_ibfk_99_nofollow`        FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000054100

-- tipologie_periodi
-- tipologia: tabella gestita
-- verifica: 2022-05-24 11:00 Chiara GDL
ALTER TABLE `tipologie_periodi`
    ADD CONSTRAINT `tipologie_periodi_ibfk_01_nofollow`           FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_periodi` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `tipologie_periodi_ibfk_98_nofollow`           FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_periodi_ibfk_99_nofollow`           FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000054200

-- tipologie_popup
-- tipologia: tabella assistita
-- verifica: 2021-10-15 18:10 Fabio Mosti
ALTER TABLE `tipologie_popup`
    ADD CONSTRAINT `tipologie_popup_ibfk_01_nofollow`           FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_popup` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `tipologie_popup_ibfk_98_nofollow`           FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_popup_ibfk_99_nofollow`           FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000054600

-- tipologie_prodotti
-- tipologia: tabella assistita
-- verifica: 2021-10-15 18:10 Fabio Mosti
ALTER TABLE `tipologie_prodotti`
    ADD CONSTRAINT `tipologie_prodotti_ibfk_01_nofollow`        FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_prodotti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `tipologie_prodotti_ibfk_98_nofollow`        FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_prodotti_ibfk_99_nofollow`        FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000055000

-- tipologie_progetti
-- tipologia: tabella assistita
-- verifica: 2021-10-15 18:10 Fabio Mosti
ALTER TABLE `tipologie_progetti`
    ADD CONSTRAINT `tipologie_progetti_ibfk_01_nofollow`        FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_progetti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `tipologie_progetti_ibfk_98_nofollow`        FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_progetti_ibfk_99_nofollow`        FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000055400

-- tipologie_pubblicazioni
-- tipologia: tabella assistita
-- verifica: 2021-10-15 18:10 Fabio Mosti
ALTER TABLE `tipologie_pubblicazioni`
    ADD CONSTRAINT `tipologie_pubblicazioni_ibfk_01_nofollow`   FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_pubblicazioni` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `tipologie_pubblicazioni_ibfk_98_nofollow`   FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_pubblicazioni_ibfk_99_nofollow`   FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000055800

-- tipologie_risorse
-- tipologia: tabella assistita
-- verifica: 2021-10-15 18:10 Fabio Mosti
ALTER TABLE `tipologie_risorse`
    ADD CONSTRAINT `tipologie_risorse_ibfk_01_nofollow`         FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_risorse` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `tipologie_risorse_ibfk_98_nofollow`         FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_risorse_ibfk_99_nofollow`         FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000056200

-- tipologie_telefoni
-- tipologia: tabella assistita
-- verifica: 2021-10-15 18:10 Fabio Mosti
ALTER TABLE `tipologie_telefoni`
    ADD CONSTRAINT `tipologie_telefoni_ibfk_01_nofollow`        FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_telefoni` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 060000056600

-- tipologie_todo
-- tipologia: tabella assistita
-- verifica: 2021-10-15 18:10 Fabio Mosti
ALTER TABLE `tipologie_todo`
    ADD CONSTRAINT `tipologie_todo_ibfk_01_nofollow`            FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_todo` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `tipologie_todo_ibfk_98_nofollow`            FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_todo_ibfk_99_nofollow`            FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000056800

-- tipologie_url
-- tipologia: tabella assistita
-- verifica: 2021-11-09 12:45 Chiara GDL
ALTER TABLE `tipologie_url`
    ADD CONSTRAINT `tipologie_url_ibfk_01_nofollow`            FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_url` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `tipologie_url_ibfk_98_nofollow`            FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_url_ibfk_99_nofollow`            FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000056900

-- tipologie_zone
-- tipologia: tabella gestita
-- verifica: 2022-06-16 16:40 Chiara GDL
ALTER TABLE `tipologie_zone`
    ADD CONSTRAINT `tipologie_zone_ibfk_01_nofollow`            FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_zone` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `tipologie_zone_ibfk_98_nofollow`            FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_zone_ibfk_99_nofollow`            FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000060000

-- todo
-- tipologia: tabella gestita
-- verifica: 2021-10-18 17:57 Fabio Mosti
ALTER TABLE `todo`
    ADD CONSTRAINT `todo_ibfk_01_nofollow`      FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_todo`(`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `todo_ibfk_02_nofollow`      FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `todo_ibfk_03_nofollow`      FOREIGN KEY (`id_cliente`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `todo_ibfk_04_nofollow`      FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `todo_ibfk_05_nofollow`      FOREIGN KEY (`id_luogo`) REFERENCES `luoghi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `todo_ibfk_06_nofollow`      FOREIGN KEY (`id_contatto`) REFERENCES `contatti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `todo_ibfk_07_nofollow`      FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `todo_ibfk_08_nofollow`      FOREIGN KEY (`id_pianificazione`) REFERENCES `pianificazioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `todo_ibfk_09_nofollow`      FOREIGN KEY (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `todo_ibfk_98_nofollow`      FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `todo_ibfk_99_nofollow`      FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000060100

-- todo_matricole
-- tipologia: tabella gestita
-- verifica: 2022-04-27 15:05 Chiara GDL
ALTER TABLE `todo_matricole`
    ADD CONSTRAINT `todo_matricole_ibfk_01`             FOREIGN KEY (`id_todo`) REFERENCES `todo` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `todo_matricole_ibfk_02_nofollow`    FOREIGN KEY (`id_matricola`) REFERENCES `matricole` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `todo_matricole_ibfk_03_nofollow`    FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_matricole` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `todo_matricole_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `todo_matricole_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000062000

-- udm
-- tipologia: tabella di supporto
-- verifica: 2021-10-19 13:06 Fabio Mosti
ALTER TABLE `udm`
    ADD CONSTRAINT `udm_ibfk_01_nofollow`       FOREIGN KEY (`id_base`) REFERENCES `udm` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000062600

-- url
-- tipologia: tabella gestita
-- verifica: 2021-10-18 17:57 Fabio Mosti
ALTER TABLE `url`
    ADD CONSTRAINT `url_ibfk_01_nofollow`       FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_url`(`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `url_ibfk_02_nofollow`       FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `url_ibfk_98_nofollow`       FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `url_ibfk_99_nofollow`       FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000062900

-- valutazioni
-- tipologia: tabella gestita
-- verifica: 2022-04-28 Chiara GDL
ALTER TABLE `valutazioni`
    ADD CONSTRAINT `valutazioni_ibfk_01_nofollow`       FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `valutazioni_ibfk_02_nofollow`       FOREIGN KEY (`id_matricola`) REFERENCES `matricole` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `valutazioni_ibfk_03_nofollow`       FOREIGN KEY (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `valutazioni_ibfk_04_nofollow`       FOREIGN KEY (`id_condizione`) REFERENCES `condizioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `valutazioni_ibfk_05_nofollow`       FOREIGN KEY (`id_disponibilita`) REFERENCES `disponibilita` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `valutazioni_ibfk_06_nofollow`       FOREIGN KEY (`id_classe_energetica`) REFERENCES `classi_energetiche` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `valutazioni_ibfk_98_nofollow`       FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `valutazioni_ibfk_99_nofollow`       FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000062950

-- valutazioni_certificazioni
-- tipologia: tabella gestita
-- verifica: 2022-05-23 Chiara GDL
ALTER TABLE `valutazioni_certificazioni`
    ADD CONSTRAINT `valutazioni_certificazioni_ibfk_01`               FOREIGN KEY (`id_valutazione`) REFERENCES `valutazioni` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `valutazioni_certificazioni_ibfk_02_nofollow`      FOREIGN KEY (`id_certificazione`) REFERENCES `certificazioni` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `valutazioni_certificazioni_ibfk_03_nofollow`      FOREIGN KEY (`id_emittente`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `valutazioni_certificazioni_ibfk_98_nofollow`      FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `valutazioni_certificazioni_ibfk_99_nofollow`      FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000065000

-- video
-- tipologia: tabella gestita
-- verifica: 2021-09-22 12:34 Fabio Mosti
ALTER TABLE `video`
    ADD CONSTRAINT `video_ibfk_01`              FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `video_ibfk_02`              FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `video_ibfk_03`              FOREIGN KEY (`id_file`) REFERENCES `file` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `video_ibfk_04`              FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `video_ibfk_05`              FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `video_ibfk_06`              FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `video_ibfk_07`              FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `video_ibfk_08`              FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `video_ibfk_09`              FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `video_ibfk_10`              FOREIGN KEY (`id_annunci`) REFERENCES `annunci` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `video_ibfk_11`              FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `video_ibfk_12`              FOREIGN KEY (`id_categorie_annunci`) REFERENCES `categorie_annunci` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `video_ibfk_13_nofollow`     FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `video_ibfk_14_nofollow`     FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_video` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `video_ibfk_15_nofollow`     FOREIGN KEY (`id_embed`) REFERENCES `embed` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `video_ibfk_16`              FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `video_ibfk_17`              FOREIGN KEY (`id_categoria_progetti`) REFERENCES `categorie_progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `video_ibfk_18`              FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `video_ibfk_19`              FOREIGN KEY (`id_edificio`) REFERENCES `edifici` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `video_ibfk_20`              FOREIGN KEY (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `video_ibfk_21`              FOREIGN KEY (`id_valutazione`) REFERENCES `valutazioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `video_ibfk_98_nofollow`     FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `video_ibfk_99_nofollow`     FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000100000

-- zone
-- tipologia: tabella gestita
-- verifica: 2022-06-16 13:16 Chiara GDL
ALTER TABLE `zone`
    ADD CONSTRAINT `zone_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `zone` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `zone_ibfk_02_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_zone` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `zone_ibfk_98_nofollow`   FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `zone_ibfk_99_nofollow`   FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000100100

-- zone_cap
-- tipologia: tabella gestita
-- verifica: 2022-06-16 13:16 Chiara GDL
ALTER TABLE `zone_cap`
	ADD CONSTRAINT `zone_cap_ibfk_01` FOREIGN KEY (`id_zona`) REFERENCES `zone` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
 	ADD CONSTRAINT `zone_cap_ibfk_98_nofollow`   FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `zone_cap_ibfk_99_nofollow`   FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;
    
-- | 060000100200

-- zone_indirizzi
-- tipologia: tabella gestita
-- verifica: 2022-06-16 13:16 Chiara GDL
ALTER TABLE `zone_indirizzi`
    ADD CONSTRAINT `zone_indirizzi_ibfk_01` FOREIGN KEY (`id_zona`) REFERENCES `zone` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `zone_indirizzi_ibfk_02` FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `zone_indirizzi_ibfk_98_nofollow`   FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `zone_indirizzi_ibfk_99_nofollow`   FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000100300

-- zone_provincie
-- tipologia: tabella gestita
-- verifica: 2022-06-16 13:16 Chiara GDL
ALTER TABLE `zone_provincie`
    ADD CONSTRAINT `zone_provincie_ibfk_01` FOREIGN KEY (`id_zona`) REFERENCES `zone` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `zone_provincie_ibfk_02_nofollow` FOREIGN KEY (`id_provincia`) REFERENCES `provincie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `zone_provincie_ibfk_98_nofollow`   FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `zone_provincie_ibfk_99_nofollow`   FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000100400

-- zone_stati
-- tipologia: tabella gestita
-- verifica: 2022-06-16 13:16 Chiara GDL
ALTER TABLE `zone_stati`
    ADD CONSTRAINT `zone_stati_ibfk_01` FOREIGN KEY (`id_zona`) REFERENCES `zone` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `zone_stati_ibfk_02_nofollow` FOREIGN KEY (`id_stato`) REFERENCES `stati` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `zone_stati_ibfk_98_nofollow`   FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `zone_stati_ibfk_99_nofollow`   FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | FINE FILE
