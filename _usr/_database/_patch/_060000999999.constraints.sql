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

-- | 060000000900

-- anagrafica_indirizzi
ALTER TABLE `anagrafica_indirizzi`
    ADD CONSTRAINT `anagrafica_indirizzi_ibfk_01`               FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`)                            ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_indirizzi_ibfk_02_nofollow`      FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`)                              ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_indirizzi_ibfk_03_nofollow`      FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_indirizzi` (`id`)                            ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_indirizzi_ibfk_98_nofollow`      FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`)                      ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `anagrafica_indirizzi_ibfk_99_nofollow`      FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`)                    ON DELETE SET NULL ON UPDATE SET NULL;

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
    -- ADD CONSTRAINT `file_ibfk_10`           FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `file_ibfk_11`           FOREIGN KEY (`id_annuncio`) REFERENCES `annunci` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `file_ibfk_12`           FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
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
    ADD CONSTRAINT `immagini_ibfk_98_nofollow`  FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `immagini_ibfk_99_nofollow`  FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000018600

-- mail
ALTER TABLE `mail`
    ADD CONSTRAINT `mail_ibfk_01`                               FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_mail` (`id`)                                 ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `mail_ibfk_02`                               FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`)                            ON DELETE SET NULL  ON UPDATE SET NULL,
    ADD CONSTRAINT `mail_ibfk_98_nofollow`                      FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`)                      ON DELETE SET NULL  ON UPDATE SET NULL,
    ADD CONSTRAINT `mail_ibfk_99_nofollow`                      FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`)                    ON DELETE SET NULL  ON UPDATE SET NULL;

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

-- | 060000023200

-- pagine
ALTER TABLE `pagine`
    ADD CONSTRAINT `pagine_ibfk_01_nofollow`    FOREIGN KEY (`id_genitore`) REFERENCES `pagine` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `pagine_ibfk_02_nofollow`    FOREIGN KEY (`id_contenuti`) REFERENCES `contenuti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pagine_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pagine_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000026400

-- prodotti_categorie
ALTER TABLE `prodotti_categorie`
    ADD CONSTRAINT `prodotti_categorie_ibfk_01`    FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `prodotti_categorie_ibfk_02`    FOREIGN KEY (`id_categoria`) REFERENCES `categorie_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `prodotti_categorie_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `prodotti_categorie_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

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

-- | 060000043600

-- telefoni
ALTER TABLE `telefoni`
    ADD CONSTRAINT `telefoni_ibfk_01`                           FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`)                            ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `telefoni_ibfk_02_nofollow`                  FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_telefoni` (`id`)                     ON DELETE NO ACTION ON UPDATE CASCADE,
    ADD CONSTRAINT `telefoni_ibfk_98_nofollow`                  FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`)                      ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `telefoni_ibfk_99_nofollow`                  FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`)                    ON DELETE SET NULL ON UPDATE SET NULL;

-- | 060000056200

-- tipologie_telefoni
ALTER TABLE `tipologie_telefoni`
    ADD CONSTRAINT `tipologie_telefoni_ibfk_01_nofollow`        FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_telefoni` (`id`)                      ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 060000062600

-- url
ALTER TABLE `url`
    ADD CONSTRAINT `url_ibfk_01_nofollow`                       FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_url`(`id`)                           ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `url_ibfk_02       `                         FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`)                            ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `url_ibfk_98_nofollow`                       FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`)                      ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `url_ibfk_99_nofollow`                       FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`)                    ON DELETE SET NULL ON UPDATE SET NULL;

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
    -- ADD CONSTRAINT `video_ibfk_15_nofollow`     FOREIGN KEY (`id_embed`) REFERENCES `embed` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `video_ibfk_16`              FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `video_ibfk_17`              FOREIGN KEY (`id_categoria_progetti`) REFERENCES `categorie_progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `video_ibfk_18`              FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `video_ibfk_19`              FOREIGN KEY (`id_edificio`) REFERENCES `edifici` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `video_ibfk_20`              FOREIGN KEY (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    -- ADD CONSTRAINT `video_ibfk_21`              FOREIGN KEY (`id_valutazione`) REFERENCES `valutazioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `video_ibfk_98_nofollow`     FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `video_ibfk_99_nofollow`     FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | FINE FILE
