--
-- LIMITI
-- questo file contiene le query per l'inserimento dei limiti nelle tabelle
-- 
-- TODO documentare
--

-- | 060000000200

-- account_gruppi
ALTER TABLE `account_gruppi`
    ADD CONSTRAINT `account_gruppi_ibfk_01`                     FOREIGN KEY (`id_account`) REFERENCES `account` (`id`)                                  ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `account_gruppi_ibfk_02_nofollow`            FOREIGN KEY (`id_gruppo`) REFERENCES `gruppi` (`id`)                                    ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `account_gruppi_ibfk_98_nofollow`            FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`)                      ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `account_gruppi_ibfk_99_nofollow`            FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`)                    ON DELETE CASCADE ON UPDATE CASCADE;

-- | 060000000500

-- anagrafica_categorie
ALTER TABLE `anagrafica_categorie`
    ADD CONSTRAINT `anagrafica_categorie_ibfk_01`               FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`)                            ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_categorie_ibfk_02_nofollow`      FOREIGN KEY (`id_categoria`) REFERENCES `categorie_anagrafica` (`id`)                   ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_categorie_ibfk_98_nofollow`      FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`)                      ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `anagrafica_categorie_ibfk_99_nofollow`      FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`)                    ON DELETE SET NULL ON UPDATE SET NULL;

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
ALTER TABLE `anagrafica_indirizzi`
    ADD CONSTRAINT `anagrafica_indirizzi_ibfk_01`               FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`)                            ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_indirizzi_ibfk_02_nofollow`      FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`)                              ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_indirizzi_ibfk_03_nofollow`      FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_indirizzi` (`id`)                            ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_indirizzi_ibfk_98_nofollow`      FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`)                      ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `anagrafica_indirizzi_ibfk_99_nofollow`      FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`)                    ON DELETE SET NULL ON UPDATE SET NULL;

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
    ADD CONSTRAINT `annunci_ibfk_01_nofollow`               FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_annunci` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `annunci_ibfk_02_nofollow`               FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `annunci_ibfk_03_nofollow`               FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `annunci_ibfk_04_nofollow`               FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `annunci_ibfk_05_nofollow`               FOREIGN KEY (`id_udm`) REFERENCES `udm` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `annunci_ibfk_98_nofollow`               FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `annunci_ibfk_99_nofollow`               FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000001270

-- annunci_categorie
ALTER TABLE `annunci_categorie`
    ADD CONSTRAINT `annunci_categorie_ibfk_01_nofollow`     FOREIGN KEY (`id_annuncio`) REFERENCES `annunci` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `annunci_categorie_ibfk_02_nofollow`     FOREIGN KEY (`id_categoria`) REFERENCES `categorie_annunci` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `annunci_categorie_ibfk_98_nofollow`     FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `annunci_categorie_ibfk_99_nofollow`     FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000002100

-- audio
ALTER TABLE `audio`
    ADD CONSTRAINT `audio_ibfk_01`              FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `audio_ibfk_02`              FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `audio_ibfk_03`              FOREIGN KEY (`id_file`) REFERENCES `file` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `audio_ibfk_04`              FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `audio_ibfk_05`              FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `audio_ibfk_06`              FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `audio_ibfk_07`              FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `audio_ibfk_08`              FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `audio_ibfk_09`              FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `audio_ibfk_10`              FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `audio_ibfk_11`              FOREIGN KEY (`id_annuncio`) REFERENCES `annunci` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `audio_ibfk_12`              FOREIGN KEY (`id_categoria_annunci`) REFERENCES `categorie_annunci` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `audio_ibfk_13_nofollow`     FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `audio_ibfk_14_nofollow`     FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_audio` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    -- ADD CONSTRAINT `audio_ibfk_16`              FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `audio_ibfk_17`              FOREIGN KEY (`id_categoria_progetti`) REFERENCES `categorie_progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `audio_ibfk_18`              FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `audio_ibfk_19`              FOREIGN KEY (`id_edificio`) REFERENCES `edifici` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `audio_ibfk_20`              FOREIGN KEY (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `audio_ibfk_21`              FOREIGN KEY (`id_valutazione`) REFERENCES `valutazioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `audio_ibfk_22`              FOREIGN KEY (`id_marchio`) REFERENCES `marchi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `audio_ibfk_98_nofollow`     FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `audio_ibfk_99_nofollow`     FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

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

-- | 060000002700

-- campagne
ALTER TABLE `campagne`
    ADD CONSTRAINT `campagne_ibfk_98_nofollow`      FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `campagne_ibfk_99_nofollow`      FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

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

-- | 060000003300

-- categorie_annunci
ALTER TABLE `categorie_annunci`
    ADD CONSTRAINT `categorie_annunci_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `categorie_annunci` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `categorie_annunci_ibfk_02_nofollow` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `categorie_annunci_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `categorie_annunci_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

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

-- | 060000005100

-- colori
-- tipologia: tabella di supporto
-- verifica: 2021-06-02 22:33 Fabio Mosti
ALTER TABLE `colori`
    ADD CONSTRAINT `colori_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `colori` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 060000006900

-- contenuti
ALTER TABLE `contenuti`
    ADD CONSTRAINT `contenuti_ibfk_01_nofollow` FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contenuti_ibfk_02`          FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contenuti_ibfk_03`          FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contenuti_ibfk_04`          FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contenuti_ibfk_05`          FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `contenuti_ibfk_06`          FOREIGN KEY (`id_caratteristica`) REFERENCES `caratteristiche` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `contenuti_ibfk_07`          FOREIGN KEY (`id_marchio`) REFERENCES `marchi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `contenuti_ibfk_08`          FOREIGN KEY (`id_file`) REFERENCES `file` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `contenuti_ibfk_09`          FOREIGN KEY (`id_immagine`) REFERENCES `immagini` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `contenuti_ibfk_10`          FOREIGN KEY (`id_video`) REFERENCES `video` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `contenuti_ibfk_11`          FOREIGN KEY (`id_audio`) REFERENCES `audio` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `contenuti_ibfk_12`          FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `contenuti_ibfk_13`          FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contenuti_ibfk_14`          FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `contenuti_ibfk_15`          FOREIGN KEY (`id_popup`) REFERENCES `popup` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `contenuti_ibfk_16`          FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contenuti_ibfk_17`          FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `contenuti_ibfk_18`          FOREIGN KEY (`id_annuncio`) REFERENCES `annunci` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `contenuti_ibfk_19`          FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `contenuti_ibfk_20`          FOREIGN KEY (`id_categoria_annunci`) REFERENCES `categorie_annunci` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `contenuti_ibfk_21`          FOREIGN KEY (`id_template`) REFERENCES `template` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `contenuti_ibfk_22`          FOREIGN KEY (`id_mailing`) REFERENCES `mailing` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `contenuti_ibfk_23`          FOREIGN KEY (`id_colore`) REFERENCES `colori` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `contenuti_ibfk_24`          FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `contenuti_ibfk_25`          FOREIGN KEY (`id_categoria_progetti`) REFERENCES `categorie_progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `contenuti_ibfk_26`          FOREIGN KEY (`id_edificio`) REFERENCES `edifici` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `contenuti_ibfk_27`          FOREIGN KEY (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `contenuti_ibfk_28`          FOREIGN KEY (`id_banner`) REFERENCES `banner` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contenuti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contenuti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

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
ALTER TABLE `file`
    -- ADD CONSTRAINT `file_ibfk_01_nofollow`  FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_file` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `file_ibfk_02`           FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_03`           FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL, 
    ADD CONSTRAINT `file_ibfk_04`           FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_05`           FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `file_ibfk_06`           FOREIGN KEY (`id_todo`) REFERENCES `todo` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_07`           FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_08`           FOREIGN KEY (`id_template`) REFERENCES `template` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `file_ibfk_09`           FOREIGN KEY (`id_mailing`) REFERENCES `mailing` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_10`           FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `file_ibfk_11`           FOREIGN KEY (`id_annuncio`) REFERENCES `annunci` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_12`           FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `file_ibfk_13`           FOREIGN KEY (`id_categoria_annunci`) REFERENCES `categorie_annunci` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `file_ibfk_14`           FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `file_ibfk_15`           FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_16_nofollow`  FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_17`           FOREIGN KEY (`id_mail_out`) REFERENCES `mail_out` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_18`           FOREIGN KEY (`id_mail_sent`) REFERENCES `mail_sent` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `file_ibfk_19`           FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `file_ibfk_20`           FOREIGN KEY (`id_categoria_progetti`) REFERENCES `categorie_progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `file_ibfk_21`           FOREIGN KEY (`id_documento`) REFERENCES `documenti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `file_ibfk_22`           FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `file_ibfk_23`           FOREIGN KEY (`id_edificio`) REFERENCES `edifici` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `file_ibfk_24`           FOREIGN KEY (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `file_ibfk_25`           FOREIGN KEY (`id_contratto`) REFERENCES `contratti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `file_ibfk_26`           FOREIGN KEY (`id_valutazione`) REFERENCES `valutazioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `file_ibfk_27`           FOREIGN KEY (`id_rinnovo`) REFERENCES `rinnovi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `file_ibfk_28`           FOREIGN KEY (`id_anagrafica_certificazioni`) REFERENCES `anagrafica_certificazioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `file_ibfk_29`           FOREIGN KEY (`id_valutazione_certificazioni`) REFERENCES `valutazioni_certificazioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `file_ibfk_30`           FOREIGN KEY (`id_licenza`) REFERENCES `licenze` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `file_ibfk_31`           FOREIGN KEY (`id_attivita`) REFERENCES `attivita` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_32`           FOREIGN KEY (`id_marchio`) REFERENCES `marchi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_98_nofollow`  FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_99_nofollow`  FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000015600

-- immagini
ALTER TABLE `immagini`
    ADD CONSTRAINT `immagini_ibfk_01`           FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `immagini_ibfk_02`           FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `immagini_ibfk_03`           FOREIGN KEY (`id_file`) REFERENCES `file` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `immagini_ibfk_04`           FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `immagini_ibfk_05`           FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `immagini_ibfk_06`           FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
--    ADD CONSTRAINT `immagini_ibfk_07`           FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
--    ADD CONSTRAINT `immagini_ibfk_08`           FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `immagini_ibfk_09`           FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
--    ADD CONSTRAINT `immagini_ibfk_10`           FOREIGN KEY (`id_annuncio`) REFERENCES `annunci` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
--    ADD CONSTRAINT `immagini_ibfk_11`           FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
--    ADD CONSTRAINT `immagini_ibfk_12`           FOREIGN KEY (`id_categoria_annunci`) REFERENCES `categorie_annunci` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
--    ADD CONSTRAINT `immagini_ibfk_13`           FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL, 
--    ADD CONSTRAINT `immagini_ibfk_14_nofollow`  FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
--    ADD CONSTRAINT `immagini_ibfk_15_nofollow`  FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_immagini` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
--    ADD CONSTRAINT `immagini_ibfk_16`           FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
--    ADD CONSTRAINT `immagini_ibfk_17`           FOREIGN KEY (`id_categoria_progetti`) REFERENCES `categorie_progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
--    ADD CONSTRAINT `immagini_ibfk_18`           FOREIGN KEY (`id_edificio`) REFERENCES `edifici` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
--    ADD CONSTRAINT `immagini_ibfk_19`           FOREIGN KEY (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
--    ADD CONSTRAINT `immagini_ibfk_20`           FOREIGN KEY (`id_contratto`) REFERENCES `contratti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
--    ADD CONSTRAINT `immagini_ibfk_21`           FOREIGN KEY (`id_valutazione`) REFERENCES `valutazioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
--    ADD CONSTRAINT `immagini_ibfk_22`           FOREIGN KEY (`id_rinnovo`) REFERENCES `rinnovi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
--    ADD CONSTRAINT `immagini_ibfk_23`           FOREIGN KEY (`id_banner`) REFERENCES `banner` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `immagini_ibfk_24`           FOREIGN KEY (`id_marchio`) REFERENCES `marchi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `immagini_ibfk_25`           FOREIGN KEY (`id_video`) REFERENCES `video` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
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

-- | 060000015850

-- indirizzi_caratteristiche
-- tipologia: tabella gestita
-- verifica: 2022-05-03 15:21 Chiara GDL
ALTER TABLE `indirizzi_caratteristiche`
    ADD CONSTRAINT `indirizzi_caratteristiche_ibfk_01`           FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `indirizzi_caratteristiche_ibfk_02_nofollow`  FOREIGN KEY (`id_caratteristica`) REFERENCES `caratteristiche` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `indirizzi_caratteristiche_ibfk_98_nofollow`  FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `indirizzi_caratteristiche_ibfk_99_nofollow`  FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

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

-- | 060000018600

-- mail
ALTER TABLE `mail`
    ADD CONSTRAINT `mail_ibfk_01`                               FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_mail` (`id`)                                 ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `mail_ibfk_02`                               FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`)                            ON DELETE SET NULL  ON UPDATE SET NULL,
    ADD CONSTRAINT `mail_ibfk_98_nofollow`                      FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`)                      ON DELETE SET NULL  ON UPDATE SET NULL,
    ADD CONSTRAINT `mail_ibfk_99_nofollow`                      FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`)                    ON DELETE SET NULL  ON UPDATE SET NULL;

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

-- | 060000021600

-- menu
ALTER TABLE `menu`
    ADD CONSTRAINT `menu_ibfk_01_nofollow`      FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `menu_ibfk_02`               FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `menu_ibfk_03`               FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `menu_ibfk_04`               FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `menu_ibfk_05`               FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `menu_ibfk_06`               FOREIGN KEY (`id_categoria_progetti`) REFERENCES `categorie_progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
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

-- | 060000021800

-- metadati
ALTER TABLE `metadati`
    ADD CONSTRAINT `metadati_ibfk_01_nofollow`      FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `metadati_ibfk_02`               FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `metadati_ibfk_03`               FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `metadati_ibfk_04`               FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `metadati_ibfk_05`               FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `metadati_ibfk_06`               FOREIGN KEY (`id_categoria_progetti`) REFERENCES `categorie_progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `metadati_ibfk_07`           FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `metadati_ibfk_08`           FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `metadati_ibfk_98_nofollow`      FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `metadati_ibfk_99_nofollow`      FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000021810

-- metadati_articoli
-- tipologia: tabella gestita
-- verifica: 2021-10-01 10:33 Fabio Mosti
ALTER TABLE `metadati_articoli`
    ADD CONSTRAINT `metadati_articoli_ibfk_01_nofollow`  FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `metadati_articoli_ibfk_02`           FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `metadati_articoli_ibfk_98_nofollow`   FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `metadati_articoli_ibfk_99_nofollow`   FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000021820

-- metadati_prodotti
-- tipologia: tabella gestita
-- verifica: 2021-10-01 10:33 Fabio Mosti
ALTER TABLE `metadati_prodotti`
    ADD CONSTRAINT `metadati_prodotti_ibfk_01_nofollow`  FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `metadati_prodotti_ibfk_02`           FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `metadati_prodotti_ibfk_98_nofollow`   FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `metadati_prodotti_ibfk_99_nofollow`   FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000021950

-- modalita_spedizione
ALTER TABLE `modalita_spedizione`
    ADD CONSTRAINT `modalita_spedizione_ibfk_01`            FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_spedizioni` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `modalita_spedizione_ibfk_02`            FOREIGN KEY (`id_zona`) REFERENCES `zone` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `modalita_spedizione_ibfk_03`            FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `modalita_spedizione_ibfk_04`            FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `modalita_spedizione_ibfk_05`            FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `modalita_spedizione_ibfk_06`            FOREIGN KEY (`id_valuta`) REFERENCES `valute` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `modalita_spedizione_ibfk_07`            FOREIGN KEY (`id_iva`) REFERENCES `iva` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `modalita_spedizione_ibfk_98_nofollow`   FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `modalita_spedizione_ibfk_99_nofollow`   FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000022100

-- notizie_anagrafica
ALTER TABLE `notizie_anagrafica`
    ADD CONSTRAINT `notizie_anagrafica_ibfk_01_nofollow`    FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `notizie_anagrafica_ibfk_02_nofollow`    FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `notizie_anagrafica_ibfk_03_nofollow`    FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `notizie_anagrafica_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `notizie_anagrafica_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000022300

-- orari
ALTER TABLE `orari`
    ADD CONSTRAINT `orari_ibfk_01`              FOREIGN KEY (`id_tipologia_contratti`) REFERENCES `tipologie_contratti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `orari_ibfk_02`              FOREIGN KEY (`id_periodicita`) REFERENCES `periodicita` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `orari_ibfk_03_nofollow`     FOREIGN KEY (`id_giorno`) REFERENCES `giorni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `orari_ibfk_98_nofollow`     FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `orari_ibfk_99_nofollow`     FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000023200

-- pagine
ALTER TABLE `pagine`
    ADD CONSTRAINT `pagine_ibfk_01_nofollow`    FOREIGN KEY (`id_genitore`) REFERENCES `pagine` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `pagine_ibfk_02_nofollow`    FOREIGN KEY (`id_contenuti`) REFERENCES `contenuti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pagine_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pagine_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

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
ALTER TABLE `pianificazioni`
    ADD CONSTRAINT `pianificazioni_ibfk_00`             FOREIGN KEY (`id_genitore`) REFERENCES `pianificazioni` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `pianificazioni_ibfk_01`             FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pianificazioni_ibfk_02`             FOREIGN KEY (`id_todo`) REFERENCES `todo` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pianificazioni_ibfk_03`             FOREIGN KEY (`id_attivita`) REFERENCES `attivita` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pianificazioni_ibfk_04_nofollow`    FOREIGN KEY (`id_periodicita`) REFERENCES `periodicita` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pianificazioni_ibfk_05`             FOREIGN KEY (`id_contratto`) REFERENCES `contratti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pianificazioni_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pianificazioni_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000023700

-- pesi_tipologie_corrispondenza
ALTER TABLE `pesi_tipologie_corrispondenza`
    ADD CONSTRAINT `pesi_tipologie_corrispondenza_ibfk_01_nofollow`  FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_corrispondenza` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

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
ALTER TABLE `prezzi`
    ADD CONSTRAINT `prezzi_ibfk_01`    FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `prezzi_ibfk_02`    FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `prezzi_ibfk_03`    FOREIGN KEY (`id_listino`) REFERENCES `listini` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `prezzi_ibfk_04`    FOREIGN KEY (`id_iva`) REFERENCES `iva` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `prezzi_ibfk_05`    FOREIGN KEY (`id_reparto`) REFERENCES `reparti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `prezzi_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `prezzi_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000026000

-- prodotti
ALTER TABLE `prodotti`
    ADD CONSTRAINT `prodotti_ibfk_01`    FOREIGN KEY (`id_marchio`) REFERENCES `marchi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `prodotti_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `prodotti_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;


-- | 060000026400

-- prodotti_categorie
ALTER TABLE `prodotti_categorie`
    ADD CONSTRAINT `prodotti_categorie_ibfk_01`    FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `prodotti_categorie_ibfk_02`    FOREIGN KEY (`id_categoria`) REFERENCES `categorie_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `prodotti_categorie_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `prodotti_categorie_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

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

-- | 060000028400

-- pubblicazioni
ALTER TABLE `pubblicazioni`
    ADD CONSTRAINT `pubblicazioni_ibfk_01_nofollow`         FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_pubblicazioni` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `pubblicazioni_ibfk_02`                  FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `pubblicazioni_ibfk_03`                  FOREIGN KEY (`id_popup`) REFERENCES `popup` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pubblicazioni_ibfk_04`                  FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pubblicazioni_ibfk_05`                  FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pubblicazioni_ibfk_06`                  FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pubblicazioni_ibfk_07`                  FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `pubblicazioni_ibfk_08`                  FOREIGN KEY (`id_annuncio`) REFERENCES `annunci` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pubblicazioni_ibfk_09`                  FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `pubblicazioni_ibfk_10`                  FOREIGN KEY (`id_categoria_annunci`) REFERENCES `categorie_annunci` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `pubblicazioni_ibfk_11`                  FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `pubblicazioni_ibfk_12`                  FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `pubblicazioni_ibfk_13`                  FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `pubblicazioni_ibfk_14`                  FOREIGN KEY (`id_categoria_progetti`) REFERENCES `categorie_progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `pubblicazioni_ibfk_15`                  FOREIGN KEY (`id_banner`) REFERENCES `banner` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pubblicazioni_ibfk_98_nofollow`         FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pubblicazioni_ibfk_99_nofollow`         FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000030320

-- relazioni_articoli
ALTER TABLE `relazioni_articoli`
    ADD CONSTRAINT `relazioni_articoli_ibfk_01`             FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `relazioni_articoli_ibfk_02`             FOREIGN KEY (`id_articolo_collegato`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `relazioni_articoli_ibfk_03_nofollow`    FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_articoli` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `relazioni_articoli_ibfk_04`             FOREIGN KEY (`id_prodotto_collegato`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `relazioni_articoli_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `relazioni_articoli_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000030350

-- relazioni_categorie_progetti
-- tipologia: tabella gestita
-- verifica: 2022-02-03 11:12 Chiara GDL
ALTER TABLE `relazioni_categorie_progetti`
    ADD CONSTRAINT `relazioni_categorie_progetti_ibfk_01` FOREIGN KEY (`id_categoria`) REFERENCES `categorie_progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `relazioni_categorie_progetti_ibfk_02` FOREIGN KEY (`id_categoria_collegata`) REFERENCES `categorie_progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `relazioni_categorie_progetti_ibfk_03_nofollow` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_progetti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `relazioni_categorie_progetti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `relazioni_categorie_progetti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000030410

-- relazioni_documenti_articoli
-- tipologia: tabella gestita
-- verifica: 2022-01-17 16:12 Chiara GDL
ALTER TABLE `relazioni_documenti_articoli`
    ADD CONSTRAINT `relazioni_documenti_articoli_ibfk_01` FOREIGN KEY (`id_documenti_articolo`) REFERENCES `documenti_articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `relazioni_documenti_articoli_ibfk_02` FOREIGN KEY (`id_documenti_articolo_collegato`) REFERENCES `documenti_articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `relazioni_documenti_articoli_ibfk_03`     FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_documenti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `relazioni_documenti_articoli_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `relazioni_documenti_articoli_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000030440

-- relazioni_pagamenti
-- tipologia: tabella gestita
-- verifica: 2022-01-17 16:12 Chiara GDL
ALTER TABLE `relazioni_pagamenti`
    ADD CONSTRAINT `relazioni_pagamenti_ibfk_01` FOREIGN KEY (`id_pagamento`) REFERENCES `pagamenti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `relazioni_pagamenti_ibfk_02` FOREIGN KEY (`id_pagamento_collegato`) REFERENCES `pagamenti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `relazioni_pagamenti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `relazioni_pagamenti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000030470

-- relazioni_prodotti
ALTER TABLE `relazioni_prodotti`
    ADD CONSTRAINT `relazioni_prodotti_ibfk_01` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `relazioni_prodotti_ibfk_02` FOREIGN KEY (`id_prodotto_collegato`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `relazioni_prodotti_ibfk_03_nofollow` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_prodotti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `relazioni_prodotti_ibfk_04_nofollow` FOREIGN KEY (`id_articolo_collegato`) REFERENCES `articoli` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `relazioni_prodotti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `relazioni_prodotti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000030490

-- relazioni_progetti
-- tipologia: tabella gestita
-- verifica: 2022-01-17 16:12 Chiara GDL
ALTER TABLE `relazioni_progetti`
    ADD CONSTRAINT `relazioni_progetti_ibfk_01` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `relazioni_progetti_ibfk_02` FOREIGN KEY (`id_progetto_collegato`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `relazioni_progetti_ibfk_03_nofollow` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_progetti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `relazioni_progetti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `relazioni_progetti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000030500

-- relazioni_software
-- tipologia: tabella gestita
-- verifica: 2022-01-17 16:12 Chiara GDL
ALTER TABLE `relazioni_software`
    ADD CONSTRAINT `relazioni_software_ibfk_01` FOREIGN KEY (`id_software`) REFERENCES `software` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `relazioni_software_ibfk_02` FOREIGN KEY (`id_software_collegato`) REFERENCES `software` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `relazioni_software_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `relazioni_software_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

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

-- | 060000034100

-- ruoli_articoli
-- tipologia: tabella di supporto
-- verifica: 2021-10-09 18:14 Fabio Mosti
ALTER TABLE `ruoli_articoli`
    ADD CONSTRAINT `ruoli_articoli_ibfk_01`   FOREIGN KEY (`id_genitore`) REFERENCES `ruoli_articoli` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;
    

-- | 060000034250

-- ruoli_categorie_progetti
-- tipologia: tabella di supporto
-- verifica: 2021-10-09 18:36 Fabio Mosti
ALTER TABLE `ruoli_categorie_progetti`
    ADD CONSTRAINT `ruoli_categorie_progetti_ibfk_01`   FOREIGN KEY (`id_genitore`) REFERENCES `ruoli_categorie_progetti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 060000034900

-- ruoli_matricole
-- tipologia: tabella di supporto
-- verifica: 2021-10-12 10:57 Fabio Mosti
ALTER TABLE `ruoli_matricole`
    ADD CONSTRAINT `ruoli_matricole_ibfk_01`    FOREIGN KEY (`id_genitore`) REFERENCES `ruoli_matricole` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 060000036000

-- sconti
ALTER TABLE `sconti`
    ADD CONSTRAINT `sconti_ibfk_01`             FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_sconti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `sconti_ibfk_02`             FOREIGN KEY (`id_valuta`) REFERENCES `valute` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `sconti_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `sconti_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000036200

-- sconti_articoli
ALTER TABLE `sconti_articoli`
    ADD CONSTRAINT `sconti_articoli_ibfk_01`            FOREIGN KEY (`id_sconto`) REFERENCES `sconti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `sconti_articoli_ibfk_02`            FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `sconti_articoli_ibfk_98_nofollow`   FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `sconti_articoli_ibfk_99_nofollow`   FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000036400

-- sconti_listini
ALTER TABLE `sconti_listini`
    ADD CONSTRAINT `sconti_listini_ibfk_01`             FOREIGN KEY (`id_sconto`) REFERENCES `sconti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `sconti_listini_ibfk_02`             FOREIGN KEY (`id_listino`) REFERENCES `listini` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `sconti_listini_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `sconti_listini_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000041400

-- software
-- tipologia: tabella gestita
-- verifica: 2021-11-16 10:39 Chiara GDL
ALTER TABLE `software`
    ADD CONSTRAINT `software_ibfk_01_nofollow`   FOREIGN KEY (`id_genitore`) REFERENCES `software` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `software_ibfk_02_nofollow`   FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `software_ibfk_98_nofollow`   FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `software_ibfk_99_nofollow`   FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000042200

-- stati_lingue
-- tipologia: tabella di supporto
-- verifica: 2021-10-12 15:30 Fabio Mosti
ALTER TABLE `stati_lingue`
    ADD CONSTRAINT `stati_lingue_ibfk_02_nofollow`  FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 060000043600

-- telefoni
ALTER TABLE `telefoni`
    ADD CONSTRAINT `telefoni_ibfk_01`                           FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`)                            ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `telefoni_ibfk_02_nofollow`                  FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_telefoni` (`id`)                     ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `telefoni_ibfk_98_nofollow`                  FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`)                      ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `telefoni_ibfk_99_nofollow`                  FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`)                    ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000045000

-- testate
-- tipologia: tabella gestita
-- verifica: 2021-10-15 12:41 Fabio Mosti
ALTER TABLE `testate`
    ADD CONSTRAINT `testate_ibfk_98_nofollow`       FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `testate_ibfk_99_nofollow`       FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

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

-- | 060000056000

-- tipologie_spedizioni
ALTER TABLE `tipologie_spedizioni`
    ADD CONSTRAINT `tipologie_spedizioni_ibfk_01_nofollow`   FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_spedizioni` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `tipologie_spedizioni_ibfk_98_nofollow`   FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_spedizioni_ibfk_99_nofollow`   FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000056100

-- tipologie_risorse
-- tipologia: tabella assistita
-- verifica: 2021-10-15 18:10 Fabio Mosti
ALTER TABLE `tipologie_risorse`
    ADD CONSTRAINT `tipologie_risorse_ibfk_01_nofollow`         FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_risorse` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `tipologie_risorse_ibfk_98_nofollow`         FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_risorse_ibfk_99_nofollow`         FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000056200

-- tipologie_telefoni
ALTER TABLE `tipologie_telefoni`
    ADD CONSTRAINT `tipologie_telefoni_ibfk_01_nofollow`        FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_telefoni` (`id`)                      ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 060000056900

-- tipologie_zone
-- tipologia: tabella gestita
-- verifica: 2022-06-16 16:40 Chiara GDL
ALTER TABLE `tipologie_zone`
    ADD CONSTRAINT `tipologie_zone_ibfk_01_nofollow`            FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_zone` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `tipologie_zone_ibfk_98_nofollow`            FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_zone_ibfk_99_nofollow`            FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

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

-- | 060000062600

-- url
ALTER TABLE `url`
    ADD CONSTRAINT `url_ibfk_01_nofollow`                       FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_url`(`id`)                           ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `url_ibfk_02       `                         FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`)                            ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `url_ibfk_98_nofollow`                       FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`)                      ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `url_ibfk_99_nofollow`                       FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`)                    ON DELETE SET NULL ON UPDATE SET NULL;

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
ALTER TABLE `video`
    ADD CONSTRAINT `video_ibfk_01`              FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `video_ibfk_02`              FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `video_ibfk_03`              FOREIGN KEY (`id_file`) REFERENCES `file` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `video_ibfk_04`              FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `video_ibfk_05`              FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `video_ibfk_06`              FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `video_ibfk_07`              FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `video_ibfk_08`              FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `video_ibfk_09`              FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `video_ibfk_10`              FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `video_ibfk_11`              FOREIGN KEY (`id_annuncio`) REFERENCES `annunci` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `video_ibfk_12`              FOREIGN KEY (`id_categoria_annunci`) REFERENCES `categorie_annunci` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `video_ibfk_13_nofollow`     FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `video_ibfk_14_nofollow`     FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_video` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    -- ADD CONSTRAINT `video_ibfk_16`              FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `video_ibfk_17`              FOREIGN KEY (`id_categoria_progetti`) REFERENCES `categorie_progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `video_ibfk_18`              FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `video_ibfk_19`              FOREIGN KEY (`id_edificio`) REFERENCES `edifici` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `video_ibfk_20`              FOREIGN KEY (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `video_ibfk_21`              FOREIGN KEY (`id_valutazione`) REFERENCES `valutazioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `video_ibfk_22`              FOREIGN KEY (`id_marchio`) REFERENCES `marchi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
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
