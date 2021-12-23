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

--| 060000000100

-- account
-- tipologia: tabella gestita
-- verifica: 2021-05-20 14:31 Fabio Mosti
ALTER TABLE `account`
    ADD CONSTRAINT `account_ibfk_01_nofollow` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `account_ibfk_02_nofollow` FOREIGN KEY (`id_mail`) REFERENCES `mail` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `account_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `account_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000000200

-- account_gruppi
-- tipologia: tabella gestita
-- verifica: 2021-05-20 16:07 Fabio Mosti
ALTER TABLE `account_gruppi`
    ADD CONSTRAINT `account_gruppi_ibfk_01`             FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `account_gruppi_ibfk_02_nofollow`    FOREIGN KEY (`id_gruppo`) REFERENCES `gruppi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `account_gruppi_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
    ADD CONSTRAINT `account_gruppi_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--| 060000000300

-- account_gruppi_attribuzione
-- tipologia: tabella gestita
-- verifica: 2021-05-20 17:11 Fabio Mosti
ALTER TABLE `account_gruppi_attribuzione`
    ADD CONSTRAINT `account_gruppi_attribuzione_ibfk_01`            FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `account_gruppi_attribuzione_ibfk_02_nofollow`   FOREIGN KEY (`id_gruppo`) REFERENCES `gruppi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `account_gruppi_attribuzione_ibfk_98_nofollow`   FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
    ADD CONSTRAINT `account_gruppi_attribuzione_ibfk_99_nofollow`   FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--| 060000000400

-- anagrafica
-- tipologia: tabella gestita
-- verifica: 2021-05-20 19:33 Fabio Mosti
ALTER TABLE `anagrafica`	
    ADD CONSTRAINT `anagrafica_ibfk_01_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `anagrafica_ibfk_02_nofollow` FOREIGN KEY (`id_pec_sdi`) REFERENCES `mail` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `anagrafica_ibfk_03_nofollow` FOREIGN KEY (`id_regime`) REFERENCES `regimi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `anagrafica_ibfk_04_nofollow` FOREIGN KEY (`id_stato_nascita`) REFERENCES `stati` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `anagrafica_ibfk_05_nofollow` FOREIGN KEY (`id_comune_nascita`) REFERENCES `comuni` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `anagrafica_ibfk_06_nofollow` FOREIGN KEY (`id_ranking`) REFERENCES `ranking` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `anagrafica_ibfk_07_nofollow` FOREIGN KEY (`id_agente`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `anagrafica_ibfk_08_nofollow` FOREIGN KEY (`id_responsabile_operativo`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `anagrafica_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `anagrafica_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000000500

-- anagrafica_categorie
-- tipologia: tabella gestita
-- verifica: 2021-05-20 19:33 Fabio Mosti
ALTER TABLE `anagrafica_categorie`
    ADD CONSTRAINT `anagrafica_categorie_ibfk_01`           FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_categorie_ibfk_02_nofollow`  FOREIGN KEY (`id_categoria`) REFERENCES `categorie_anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `anagrafica_categorie_ibfk_98_nofollow`  FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `anagrafica_categorie_ibfk_99_nofollow`  FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000000700

-- anagrafica_cittadinanze
-- tipologia: tabella gestita
-- verifica: 2021-05-20 21:27 Fabio Mosti
ALTER TABLE `anagrafica_cittadinanze`
    ADD CONSTRAINT `anagrafica_cittadinanze_ibfk_01`            FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_cittadinanze_ibfk_02_nofollow`   FOREIGN KEY (`id_stato`) REFERENCES `stati` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `anagrafica_cittadinanze_ibfk_98_nofollow`   FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `anagrafica_cittadinanze_ibfk_99_nofollow`   FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000000900

-- anagrafica_indirizzi
-- tipologia: tabella gestita
-- verifica: 2021-05-21 16:36 Fabio Mosti
ALTER TABLE `anagrafica_indirizzi`
    ADD CONSTRAINT `anagrafica_indirizzi_ibfk_01`               FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_indirizzi_ibfk_02_nofollow`      FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `anagrafica_indirizzi_ibfk_03_nofollow`      FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_indirizzi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `anagrafica_indirizzi_ibfk_98_nofollow`      FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `anagrafica_indirizzi_ibfk_99_nofollow`      FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000001200

-- anagrafica_settori
-- tipologia: tabella gestita
-- verifica: 2021-05-23 15:31 Fabio Mosti
ALTER TABLE `anagrafica_settori`
    ADD CONSTRAINT `anagrafica_settori_ibfk_01`             FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `anagrafica_settori_ibfk_02_nofollow`    FOREIGN KEY (`id_settore`) REFERENCES `settori` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `anagrafica_settori_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `anagrafica_settori_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000001300

-- articoli
-- tipologia: tabella gestita
-- verifica: 2021-05-25 10:47 Fabio Mosti
ALTER TABLE `articoli`
    ADD CONSTRAINT `articoli_ibfk_01_nofollow` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `articoli_ibfk_02_nofollow` FOREIGN KEY (`id_reparto`) REFERENCES `reparti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `articoli_ibfk_03_nofollow` FOREIGN KEY (`id_colore`) REFERENCES `colori` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `articoli_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `articoli_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000001600

-- articoli_caratteristiche
-- tipologia: tabella gestita
-- verifica: 2021-05-25 12:05 Fabio Mosti
ALTER TABLE `articoli_caratteristiche`
    ADD CONSTRAINT `articoli_caratteristiche_ibfk_01`           FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `articoli_caratteristiche_ibfk_02_nofollow`  FOREIGN KEY (`id_caratteristica`) REFERENCES `caratteristiche_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 060000001800

-- attivita
-- tipologia: tabella gestita
-- verifica: 2021-05-27 15:31 Fabio Mosti
ALTER TABLE `attivita`
    ADD CONSTRAINT `attivita_ibfk_01_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_attivita` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `attivita_ibfk_02_nofollow` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `attivita_ibfk_03_nofollow` FOREIGN KEY (`id_cliente`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `attivita_ibfk_04_nofollow` FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `attivita_ibfk_05_nofollow` FOREIGN KEY (`id_luogo`) REFERENCES `luoghi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `attivita_ibfk_06_nofollow` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `attivita_ibfk_07_nofollow` FOREIGN KEY (`id_todo`) REFERENCES `todo` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `attivita_ibfk_08_nofollow` FOREIGN KEY (`id_mastro_provenienza`) REFERENCES `mastri` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `attivita_ibfk_09_nofollow` FOREIGN KEY (`id_mastro_destinazione`) REFERENCES `mastri` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `attivita_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `attivita_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000002100

-- audio
-- tipologia: tabella gestita
-- verifica: 2021-05-28 16:18 Fabio Mosti
ALTER TABLE `audio`
    ADD CONSTRAINT `audio_ibfk_01_nofollow` FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `audio_ibfk_02_nofollow` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_audio` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `audio_ibfk_03`          FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `audio_ibfk_04`          FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `audio_ibfk_05`          FOREIGN KEY (`id_file`) REFERENCES `file` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `audio_ibfk_06`          FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `audio_ibfk_07`          FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `audio_ibfk_08`          FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `audio_ibfk_09`          FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `audio_ibfk_10`          FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `audio_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `audio_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000002900

-- caratteristiche_prodotti
-- tipologia: tabella gestita
-- verifica: 2021-05-28 18:30 Fabio Mosti
ALTER TABLE `caratteristiche_prodotti`
    ADD CONSTRAINT `caratteristiche_prodotti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `caratteristiche_prodotti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000003100

-- categorie_anagrafica
-- tipologia: tabella assistita
-- verifica: 2021-05-28 20:07 Fabio Mosti
ALTER TABLE `categorie_anagrafica`
    ADD CONSTRAINT `categorie_anagrafica_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `categorie_anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `categorie_anagrafica_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `categorie_anagrafica_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000003700

-- categorie_notizie
-- tipologia: tabella gestita
-- verifica: 2021-06-01 18:29 Fabio Mosti
ALTER TABLE `categorie_notizie`
    ADD CONSTRAINT `categorie_notizie_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `categorie_notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `categorie_notizie_ibfk_02_nofollow` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `categorie_notizie_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `categorie_notizie_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000003900

-- categorie_prodotti
-- tipologia: tabella gestita
-- verifica: 2021-06-01 19:50 Fabio Mosti
ALTER TABLE `categorie_prodotti`
    ADD CONSTRAINT `categorie_prodotti_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `categorie_prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `categorie_prodotti_ibfk_02_nofollow` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `categorie_prodotti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `categorie_prodotti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000004300

-- categorie_progetti
-- tipologia: tabella gestita
-- verifica: 2021-06-02 19:45 Fabio Mosti
ALTER TABLE `categorie_progetti`
    ADD CONSTRAINT `categorie_progetti_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `categorie_progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `categorie_progetti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `categorie_progetti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000004500

-- categorie_risorse
-- tipologia: tabella gestita
-- verifica: 2021-06-02 20:14 Fabio Mosti
ALTER TABLE `categorie_risorse`
    ADD CONSTRAINT `categorie_risorse_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `categorie_risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `categorie_risorse_ibfk_02_nofollow` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `categorie_risorse_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `categorie_risorse_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000004800

-- chiavi
-- tipologia: tabella di supporto
-- verifica: 2021-11-15 11:58 Chiara GDL
ALTER TABLE `chiavi`
    ADD CONSTRAINT `chiavi_ibfk_01_nofollow` FOREIGN KEY (`id_licenza`) REFERENCES `licenze` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `chiavi_ibfk_02_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_chiavi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `chiavi_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `chiavi_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000005100

-- colori
-- tipologia: tabella di supporto
-- verifica: 2021-06-02 22:33 Fabio Mosti
ALTER TABLE `colori`
    ADD CONSTRAINT `colori_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `colori` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000005300

-- comuni
-- tipologia: tabella di supporto
-- verifica: 2021-06-03 20:26 Fabio Mosti
ALTER TABLE `comuni`
    ADD CONSTRAINT `comuni_ibfk_01_nofollow` FOREIGN KEY (`id_provincia`) REFERENCES `provincie` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--| 060000006700

-- contatti
-- tipologia: tabella gestita
-- verifica: 2021-06-04 15:04 Fabio Mosti
ALTER TABLE `contatti`
    ADD CONSTRAINT `contatti_ibfk_01_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_contatti` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `contatti_ibfk_02_nofollow` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contatti_ibfk_03_nofollow` FOREIGN KEY (`id_inviante`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contatti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contatti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000006900

-- contenuti
-- tipologia: tabella gestita
-- verifica: 2021-06-07 17:38 Fabio Mosti
ALTER TABLE `contenuti`
    ADD CONSTRAINT `contenuti_ibfk_01_nofollow` FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `contenuti_ibfk_02`          FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contenuti_ibfk_03`          FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contenuti_ibfk_04`          FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contenuti_ibfk_05`          FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contenuti_ibfk_06`          FOREIGN KEY (`id_caratteristica_prodotti`) REFERENCES `caratteristiche_prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
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
    ADD CONSTRAINT `contenuti_ibfk_18`          FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contenuti_ibfk_20`          FOREIGN KEY (`id_template`) REFERENCES `template` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contenuti_ibfk_21`          FOREIGN KEY (`id_colore`) REFERENCES `colori` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contenuti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contenuti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000008000

-- coupon
-- tipologia: tabella gestita
-- verifica: 2021-06-29 16:08 Fabio Mosti
ALTER TABLE `coupon`
    ADD CONSTRAINT `coupon_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `coupon_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000008200

-- coupon_categorie_prodotti
-- tipologia: tabella gestita
-- verifica: 2021-06-29 16:08 Fabio Mosti
ALTER TABLE `coupon_categorie_prodotti`
    ADD CONSTRAINT `coupon_categorie_prodotti_ibfk_01`              FOREIGN KEY (`id_coupon`) REFERENCES `coupon` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `coupon_categorie_prodotti_ibfk_02_nofollow`     FOREIGN KEY (`id_categoria`) REFERENCES `categorie_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `coupon_categorie_prodotti_ibfk_98_nofollow`     FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `coupon_categorie_prodotti_ibfk_99_nofollow`     FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000008400

-- coupon_listini
-- tipologia: tabella gestita
-- verifica: 2021-06-29 16:38 Fabio Mosti
ALTER TABLE `coupon_listini`
    ADD CONSTRAINT `coupon_listini_ibfk_01`             FOREIGN KEY (`id_coupon`) REFERENCES `coupon` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `coupon_listini_ibfk_02_nofollow`    FOREIGN KEY (`id_listino`) REFERENCES `listini` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `coupon_listini_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `coupon_listini_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000008600

-- coupon_marchi
-- tipologia: tabella gestita
-- verifica: 2021-06-29 16:38 Fabio Mosti
ALTER TABLE `coupon_marchi`
    ADD CONSTRAINT `coupon_marchi_ibfk_01`              FOREIGN KEY (`id_coupon`) REFERENCES `coupon` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `coupon_marchi_ibfk_02_nofollow`     FOREIGN KEY (`id_marchio`) REFERENCES `marchi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `coupon_marchi_ibfk_98_nofollow`     FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `coupon_marchi_ibfk_99_nofollow`     FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000008800

-- coupon_prodotti
-- tipologia: tabella gestita
-- verifica: 2021-06-29 16:57 Fabio Mosti
ALTER TABLE `coupon_prodotti`
    ADD CONSTRAINT `coupon_prodotti_ibfk_01`            FOREIGN KEY (`id_coupon`) REFERENCES `coupon` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `coupon_prodotti_ibfk_02_nofollow`   FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `coupon_prodotti_ibfk_98_nofollow`   FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `coupon_prodotti_ibfk_99_nofollow`   FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000009800

-- documenti
-- tipologia: tabella gestita
-- verifica: 2021-09-03 17:18 Fabio Mosti
ALTER TABLE `documenti`
    ADD CONSTRAINT `documenti_ibfk_01_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_documenti` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `documenti_ibfk_02_nofollow` FOREIGN KEY (`id_emittente`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `documenti_ibfk_03_nofollow` FOREIGN KEY (`id_sede_emittente`) REFERENCES `indirizzi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `documenti_ibfk_04_nofollow` FOREIGN KEY (`id_destinatario`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `documenti_ibfk_05_nofollow` FOREIGN KEY (`id_sede_destinatario`) REFERENCES `indirizzi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `documenti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `documenti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000010000

-- documenti_articoli
-- tipologia: tabella gestita
-- verifica: 2021-09-10 12:48 Fabio Mosti
ALTER TABLE `documenti_articoli`
    ADD CONSTRAINT `documenti_articoli_ibfk_01`             FOREIGN KEY (`id_genitore`) REFERENCES `documenti_articoli` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `documenti_articoli_ibfk_02_nofollow`    FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_documenti` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `documenti_articoli_ibfk_03`             FOREIGN KEY (`id_documento`) REFERENCES `documenti` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `documenti_articoli_ibfk_04_nofollow`    FOREIGN KEY (`id_emittente`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `documenti_articoli_ibfk_05_nofollow`    FOREIGN KEY (`id_destinatario`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `documenti_articoli_ibfk_06_nofollow`    FOREIGN KEY (`id_reparto`) REFERENCES `reparti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `documenti_articoli_ibfk_07_nofollow`    FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `documenti_articoli_ibfk_08_nofollow`    FOREIGN KEY (`id_todo`) REFERENCES `todo` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `documenti_articoli_ibfk_09_nofollow`    FOREIGN KEY (`id_attivita`) REFERENCES `attivita` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `documenti_articoli_ibfk_10_nofollow`    FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `documenti_articoli_ibfk_11_nofollow`    FOREIGN KEY (`id_mastro_provenienza`) REFERENCES `mastri` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `documenti_articoli_ibfk_12_nofollow`    FOREIGN KEY (`id_mastro_destinazione`) REFERENCES `mastri` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `documenti_articoli_ibfk_13_nofollow`    FOREIGN KEY (`id_udm`) REFERENCES `udm` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `documenti_articoli_ibfk_14_nofollow`    FOREIGN KEY (`id_listino`) REFERENCES `listini` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `documenti_articoli_ibfk_15_nofollow`    FOREIGN KEY (`id_iva`) REFERENCES `iva` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `documenti_articoli_ibfk_98_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `documenti_articoli_ibfk_99_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000015000

-- file
-- tipologia: tabella gestita
-- verifica: 2021-09-10 16:39 Fabio Mosti
ALTER TABLE `file`
    ADD CONSTRAINT `file_ibfk_01_nofollow`  FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_file` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `file_ibfk_02`           FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_03`           FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_04`           FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_05`           FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_06`           FOREIGN KEY (`id_todo`) REFERENCES `todo` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_07`           FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_08`           FOREIGN KEY (`id_template`) REFERENCES `template` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_09`           FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_10`           FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_11`           FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_12`           FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_13_nofollow`  FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `file_ibfk_14`           FOREIGN KEY (`id_mail_out`) REFERENCES `mail_out` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_15`           FOREIGN KEY (`id_mail_sent`) REFERENCES `mail_sent` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_98_nofollow`  FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_99_nofollow`  FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000015200

-- gruppi
-- tipologia: tabella gestita
-- verifica: 2021-09-10 18:05 Fabio Mosti
ALTER TABLE `gruppi`
    ADD CONSTRAINT `gruppi_ibfk_01`             FOREIGN KEY (`id_genitore`) REFERENCES `gruppi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `gruppi_ibfk_02`             FOREIGN KEY (`id_organizzazione`) REFERENCES `organizzazioni` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `gruppi_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `gruppi_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000015400

-- iban
-- tipologia: tabella gestita
-- verifica: 2021-09-22 11:59 Fabio Mosti
ALTER TABLE `iban`
    ADD CONSTRAINT `iban_ibfk_01`               FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `iban_ibfk_98_nofollow`      FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `iban_ibfk_99_nofollow`      FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000015600

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
    ADD CONSTRAINT `immagini_ibfk_10`           FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `immagini_ibfk_11`           FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `immagini_ibfk_12_nofollow`  FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `immagini_ibfk_13_nofollow`  FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_immagini` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `immagini_ibfk_98_nofollow`  FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `immagini_ibfk_99_nofollow`  FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000015800

-- indirizzi
-- tipologia: tabella gestita
-- verifica: 2021-09-23 16:08 Fabio Mosti
ALTER TABLE `indirizzi`
    ADD CONSTRAINT `indirizzi_ibfk_01_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_indirizzi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `indirizzi_ibfk_02_nofollow` FOREIGN KEY (`id_comune`) REFERENCES `comuni` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `indirizzi_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `indirizzi_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000016600

-- licenze
-- tipologia: tabella gestita
-- verifica: 2021-11-15 12:44 Chiara GDL
ALTER TABLE `licenze`
    ADD CONSTRAINT `licenze_ibfk_01_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_licenze` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `licenze_ibfk_02_nofollow` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `licenze_ibfk_03_nofollow` FOREIGN KEY (`id_rivenditore`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `licenze_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `licenze_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000016700

-- licenze_software
-- tipologia: tabella gestita
-- verifica: 2021-11-16 15:30 Chiara GDL
ALTER TABLE `licenze_software`
    ADD CONSTRAINT `licenze_software_ibfk_01_nofollow` FOREIGN KEY (`id_licenza`) REFERENCES `licenze` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `licenze_software_ibfk_02_nofollow` FOREIGN KEY (`id_software`) REFERENCES `software` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `licenze_software_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `licenze_software_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000017200

-- listini
-- tipologia: tabella gestita
-- verifica: 2021-09-24 17:55 Fabio Mosti
ALTER TABLE `listini`
    ADD CONSTRAINT `listini_ibfk_01_nofollow`   FOREIGN KEY (`id_valuta`) REFERENCES `valute` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `listini_ibfk_98_nofollow`   FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `listini_ibfk_99_nofollow`   FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000017400

-- listini_clienti
-- tipologia: tabella gestita
-- verifica: 2021-09-24 18:17 Fabio Mosti
ALTER TABLE `listini_clienti`
    ADD CONSTRAINT `listini_clienti_ibfk_01_nofollow`   FOREIGN KEY (`id_listino`) REFERENCES `listini` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `listini_clienti_ibfk_02_nofollow`   FOREIGN KEY (`id_cliente`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `listini_clienti_ibfk_98_nofollow`   FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `listini_clienti_ibfk_99_nofollow`   FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000018000

-- luoghi
-- tipologia: tabella gestita
-- verifica: 2021-09-24 18:42 Fabio Mosti
ALTER TABLE `luoghi`
    ADD CONSTRAINT `luoghi_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `luoghi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `luoghi_ibfk_02_nofollow` FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `luoghi_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `luoghi_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000018200

-- macro
-- tipologia: tabella gestita
-- verifica: 2021-09-24 19:36 Fabio Mosti
ALTER TABLE `macro`
    ADD CONSTRAINT `macro_ibfk_01`          FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `macro_ibfk_02`          FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `macro_ibfk_03`          FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `macro_ibfk_04`          FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `macro_ibfk_05`          FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `macro_ibfk_06`          FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `macro_ibfk_07`          FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `macro_ibfk_08`          FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `macro_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `macro_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000018600

-- mail
-- tipologia: tabella gestita
-- verifica: 2021-09-27 18:35 Fabio Mosti
ALTER TABLE `mail`
    ADD CONSTRAINT `mail_ibfk_01`           FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `mail_ibfk_98_nofollow`  FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `mail_ibfk_99_nofollow`  FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000018800

-- mail_out
-- tipolgia: tabella gestita
-- verifica: 2021-09-28 15:35 Fabio Mosti
ALTER TABLE `mail_out`
    ADD CONSTRAINT `mail_out_ibfk_01_nofollow`  FOREIGN KEY (`id_mail`) REFERENCES `mail` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `mail_out_ibfk_98_nofollow`  FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `mail_out_ibfk_99_nofollow`  FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000018900

-- mail_sent
-- tipolgia: tabella gestita
-- verifica: 2021-09-28 15:35 Fabio Mosti
ALTER TABLE `mail_sent`
    ADD CONSTRAINT `mail_sent_ibfk_01_nofollow`     FOREIGN KEY (`id_mail`) REFERENCES `mail` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `mail_sent_ibfk_98_nofollow`     FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `mail_sent_ibfk_99_nofollow`     FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000020200

-- marchi
-- tipologia: tabella gestita
-- verifica: 2021-09-28 16:54 Fabio Mosti
ALTER TABLE `marchi`
    ADD CONSTRAINT `marchi_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `marchi_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000020600

-- mastri
-- tipologia: tabella gestita
-- verifica: 2021-09-29 11:35 Fabio Mosti
ALTER TABLE `mastri`
    ADD CONSTRAINT `mastri_ibfk_01_nofollow`    FOREIGN KEY (`id_genitore`) REFERENCES `mastri` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `mastri_ibfk_02_nofollow`    FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_mastri` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `mastri_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `mastri_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000021600

-- menu
-- tipologia: tabella gestita
-- verifica: 2021-10-01 09:32 Fabio Mosti
ALTER TABLE `menu`
    ADD CONSTRAINT `menu_ibfk_01_nofollow`      FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `menu_ibfk_02`               FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `menu_ibfk_03`               FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `menu_ibfk_04`               FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `menu_ibfk_05`               FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `menu_ibfk_98_nofollow`      FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `menu_ibfk_99_nofollow`      FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000021800

-- metadati
-- tipologia: tabella gestita
-- verifica: 2021-10-01 10:33 Fabio Mosti
ALTER TABLE `metadati`
    ADD CONSTRAINT `metadati_ibfk_01_nofollow`  FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `metadati_ibfk_02`           FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `metadati_ibfk_03`           FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `metadati_ibfk_04`           FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `metadati_ibfk_05`           FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `metadati_ibfk_06`           FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `metadati_ibfk_07`           FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `metadati_ibfk_08`           FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `metadati_ibfk_09`           FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `metadati_ibfk_10`           FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `metadati_ibfk_11`           FOREIGN KEY (`id_immagine`) REFERENCES `immagini` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `metadati_ibfk_12`           FOREIGN KEY (`id_video`) REFERENCES `video` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `metadati_ibfk_13`           FOREIGN KEY (`id_audio`) REFERENCES `audio` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `metadati_ibfk_14`           FOREIGN KEY (`id_file`) REFERENCES `file` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `metadati_ibfk_98_nofollow`  FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `metadati_ibfk_99_nofollow`  FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000022000

-- notizie
-- tipologia: tabella gestita
-- verifica: 2021-10-01 12:09 Fabio Mosti
ALTER TABLE `notizie`
    ADD CONSTRAINT `notizie_ibfk_01_nofollow`   FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_notizie` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `notizie_ibfk_98_nofollow`   FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `notizie_ibfk_99_nofollow`   FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000022200

-- notizie_categorie
-- tipologia: tabella gestita
-- verifica: 2021-10-01 12:36 Fabio Mosti
ALTER TABLE `notizie_categorie`
    ADD CONSTRAINT `notizie_categorie_ibfk_01`              FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `notizie_categorie_ibfk_02`              FOREIGN KEY (`id_categoria`) REFERENCES `categorie_notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `notizie_categorie_ibfk_98_nofollow`     FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `notizie_categorie_ibfk_99_nofollow`     FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000022800

-- organizzazioni
-- tipologia: tabella gestita
-- verifica: 2021-10-04 11:37 Fabio Mosti
ALTER TABLE `organizzazioni`
    ADD CONSTRAINT `organizzazioni_ibfk_01_nofollow`    FOREIGN KEY (`id_genitore`) REFERENCES `organizzazioni` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `organizzazioni_ibfk_02`             FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `organizzazioni_ibfk_03_nofollow`    FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `organizzazioni_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `organizzazioni_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000023100

-- pagamenti
-- tipologia: tabella gestita
-- verifica: 2021-11-12 16:00 Chiara GDL
ALTER TABLE `pagamenti`
    ADD CONSTRAINT `pagamenti_ibfk_01_nofollow`    FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_pagamenti` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `pagamenti_ibfk_02`             FOREIGN KEY (`id_documento`) REFERENCES `documenti` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `pagamenti_ibfk_03_nofollow`    FOREIGN KEY (`id_mastro_provenienza`) REFERENCES `mastri` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `pagamenti_ibfk_04_nofollow`    FOREIGN KEY (`id_mastro_destinazione`) REFERENCES `mastri` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `pagamenti_ibfk_05_nofollow`    FOREIGN KEY (`id_iban`) REFERENCES `iban` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pagamenti_ibfk_06_nofollow`    FOREIGN KEY (`id_listino`) REFERENCES `listini` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `pagamenti_ibfk_07_nofollow`    FOREIGN KEY (`id_iva`) REFERENCES `iva` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `pagamenti_ibfk_98_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pagamenti_ibfk_99_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000023200

-- pagine
-- tipologia: tabella gestita
-- verifica: 2021-10-04 11:37 Fabio Mosti
ALTER TABLE `pagine`
    ADD CONSTRAINT `pagine_ibfk_01_nofollow`    FOREIGN KEY (`id_genitore`) REFERENCES `pagine` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `pagine_ibfk_02_nofollow`    FOREIGN KEY (`id_contenuti`) REFERENCES `contenuti` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `pagine_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `pagine_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--| 060000023600

-- pianificazioni
-- tipologia: tabella gestita
-- verifica: 2021-10-05 17:29 Fabio Mosti
ALTER TABLE `pianificazioni`
    ADD CONSTRAINT `pianificazioni_ibfk_01`             FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `pianificazioni_ibfk_02`             FOREIGN KEY (`id_todo`) REFERENCES `todo` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `pianificazioni_ibfk_03`             FOREIGN KEY (`id_attivita`) REFERENCES `attivita` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `pianificazioni_ibfk_04_nofollow`    FOREIGN KEY (`id_periodicita`) REFERENCES `periodicita` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--| 060000024000

-- popup
-- tipologia: tabella gestita
-- verifica: 2021-10-04 16:36 Fabio Mosti
ALTER TABLE `popup`
    ADD CONSTRAINT `popup_ibfk_01_nofollow`     FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_popup` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `popup_ibfk_98_nofollow`     FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `popup_ibfk_99_nofollow`     FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--| 060000024200

-- popup_pagine
-- tipologia: tabella gestita
-- verifica: 2021-10-04 16:37 Fabio Mosti
ALTER TABLE `popup_pagine`
    ADD CONSTRAINT `popup_pagine_ibfk_01`               FOREIGN KEY (`id_popup`) REFERENCES `popup` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `popup_pagine_ibfk_02_nofollow`      FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `popup_pagine_ibfk_98_nofollow`      FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `popup_pagine_ibfk_99_nofollow`      FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--| 060000025000

-- prezzi
-- tipologia: tabella gestita
-- verifica: 2021-10-08 14:08 Fabio Mosti
ALTER TABLE `prezzi`
    ADD CONSTRAINT `prezzi_ibfk_01`             FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `prezzi_ibfk_02`             FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `prezzi_ibfk_03_nofollow`    FOREIGN KEY (`id_listino`) REFERENCES `listini` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `prezzi_ibfk_04_nofollow`    FOREIGN KEY (`id_iva`) REFERENCES `iva` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `prezzi_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `prezzi_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--| 060000026000

-- prodotti
-- tipologia: tabella gestita
-- verifica: 2021-10-08 14:08 Fabio Mosti
ALTER TABLE `prodotti`
    ADD CONSTRAINT `prodotti_ibfk_01_nofollow`  FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_prodotti` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `prodotti_ibfk_02_nofollow`  FOREIGN KEY (`id_marchio`) REFERENCES `marchi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `prodotti_ibfk_03_nofollow`  FOREIGN KEY (`id_produttore`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `prodotti_ibfk_98_nofollow`  FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `prodotti_ibfk_99_nofollow`  FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000026200

-- prodotti_caratteristiche
-- tipologia: tabella gestita
-- verifica: 2021-10-08 14:08 Fabio Mosti
ALTER TABLE `prodotti_caratteristiche`
    ADD CONSTRAINT `prodotti_caratteristiche_ibfk_01`           FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `prodotti_caratteristiche_ibfk_02_nofollow`  FOREIGN KEY (`id_caratteristica`) REFERENCES `caratteristiche_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `prodotti_caratteristiche_ibfk_98_nofollow`  FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `prodotti_caratteristiche_ibfk_99_nofollow`  FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000026400

-- prodotti_categorie
-- tipologia: tabella gestita
-- verifica: 2021-10-08 14:08 Fabio Mosti
ALTER TABLE `prodotti_categorie`
    ADD CONSTRAINT `prodotti_categorie_ibfk_01`             FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `prodotti_categorie_ibfk_02_nofollow`    FOREIGN KEY (`id_categoria`) REFERENCES `categorie_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `prodotti_categorie_ibfk_03_nofollow`    FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_prodotti` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `prodotti_categorie_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `prodotti_categorie_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000027000

-- progetti
-- tipologia: tabella gestita
-- verifica: 2021-10-08 14:08 Fabio Mosti
ALTER TABLE `progetti`
    ADD CONSTRAINT `progetti_ibfk_01_nofollow`  FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_progetti` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `progetti_ibfk_02_nofollow`  FOREIGN KEY (`id_pianificazione`) REFERENCES `pianificazioni` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `progetti_ibfk_03_nofollow`  FOREIGN KEY (`id_cliente`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `progetti_ibfk_04_nofollow`  FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `progetti_ibfk_98_nofollow`  FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `progetti_ibfk_99_nofollow`  FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000027200

-- progetti_anagrafica
-- tipologia: tabella gestita
-- verifica: 2021-10-08 15:05 Fabio Mosti
ALTER TABLE `progetti_anagrafica`
    ADD CONSTRAINT `progetti_anagrafica_ibfk_01`            FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `progetti_anagrafica_ibfk_02_nofollow`   FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `progetti_anagrafica_ibfk_03_nofollow`   FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `progetti_anagrafica_ibfk_98_nofollow`   FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `progetti_anagrafica_ibfk_99_nofollow`   FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000027400

-- progetti_categorie
-- tipologia: tabella gestita
-- verifica: 2021-10-08 15:05 Fabio Mosti
ALTER TABLE `progetti_categorie`
    ADD CONSTRAINT `progetti_categorie_ibfk_01`             FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `progetti_categorie_ibfk_02_nofollow`    FOREIGN KEY (`id_categoria`) REFERENCES `categorie_progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `progetti_categorie_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `progetti_categorie_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000028000

-- provincie
-- tipologia: tabella di supporto
-- verifica: 2021-10-08 15:05 Fabio Mosti
ALTER TABLE `provincie`
    ADD CONSTRAINT `provincie_ibfk_01_nofollow`     FOREIGN KEY (`id_regione`) REFERENCES `regioni` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--| 060000028400

-- pubblicazioni
-- tipologia: tabella gestita
-- verifica: 2021-10-08 17:44 Fabio Mosti
ALTER TABLE `pubblicazioni`
    ADD CONSTRAINT `pubblicazioni_ibfk_01_nofollow`         FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_pubblicazioni` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `pubblicazioni_ibfk_02`                  FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `pubblicazioni_ibfk_03`                  FOREIGN KEY (`id_popup`) REFERENCES `popup` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `pubblicazioni_ibfk_04`                  FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `pubblicazioni_ibfk_05`                  FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `pubblicazioni_ibfk_06`                  FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `pubblicazioni_ibfk_07`                  FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `pubblicazioni_ibfk_08`                  FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `pubblicazioni_ibfk_09`                  FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `pubblicazioni_ibfk_98_nofollow`         FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `pubblicazioni_ibfk_99_nofollow`         FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000028600

-- ranking
-- tipologia: tabella assistita
-- verifica: 2021-10-11 17:53 Fabio Mosti
ALTER TABLE `ranking`
    ADD CONSTRAINT `ranking_ibfk_98_nofollow`   FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `ranking_ibfk_99_nofollow`   FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000029400

-- redirect
-- tipologia: tabella gestita
-- verifica: 2021-10-09 14:43 Fabio Mosti
ALTER TABLE `redirect`
    ADD CONSTRAINT `redirect_ibfk_98_nofollow`  FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `redirect_ibfk_99_nofollow`  FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000030200

-- regioni
-- tipologia: tabella di supporto
-- verifica: 2021-10-09 15:26 Fabio Mosti
ALTER TABLE `regioni`
    ADD CONSTRAINT `regioni_ibfk_01_nofollow`   FOREIGN KEY (`id_stato`) REFERENCES `stati` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--| 060000030800

-- reparti
-- tipologia: tabella gestita
ALTER TABLE `reparti`
    ADD CONSTRAINT `reparti_ibfk_01_nofollow`   FOREIGN KEY (`id_iva`) REFERENCES `iva` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `reparti_ibfk_02_nofollow`   FOREIGN KEY (`id_settore`) REFERENCES `settori` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `reparti_ibfk_98_nofollow`   FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `reparti_ibfk_99_nofollow`   FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000032000

-- risorse
-- tipologia: tabella gestita
-- verifica: 2021-10-09 15:57 Fabio Mosti
ALTER TABLE `risorse`
    ADD CONSTRAINT `risorse_ibfk_01_nofollow`   FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_risorse` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `risorse_ibfk_98_nofollow`   FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `risorse_ibfk_99_nofollow`   FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000032200

-- risorse_anagrafica
-- tipologia: tabella di supporto
-- verifica: 2021-10-09 16:10 Fabio Mosti
ALTER TABLE `risorse_anagrafica`
    ADD CONSTRAINT `risorse_anagrafica_ibfk_01`             FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `risorse_anagrafica_ibfk_02_nofollow`    FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `risorse_anagrafica_ibfk_03_nofollow`    FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `risorse_anagrafica_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `risorse_anagrafica_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000032400

-- risorse_categorie
-- tipologia: tabella di supporto
-- verifica: 2021-10-09 17:59 Fabio Mosti
ALTER TABLE `risorse_categorie`
    ADD CONSTRAINT `risorse_categorie_ibfk_01`              FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `risorse_categorie_ibfk_02_nofollow`     FOREIGN KEY (`id_categoria`) REFERENCES `categorie_risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `risorse_categorie_ibfk_98_nofollow`     FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `risorse_categorie_ibfk_99_nofollow`     FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000034000

-- ruoli_anagrafica
-- tipologia: tabella di supporto
-- verifica: 2021-10-09 18:14 Fabio Mosti
ALTER TABLE `ruoli_anagrafica`
    ADD CONSTRAINT `ruoli_anagrafica_ibfk_01`   FOREIGN KEY (`id_genitore`) REFERENCES `ruoli_anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000034200

-- ruoli_audio
-- tipologia: tabella di supporto
-- verifica: 2021-10-09 18:36 Fabio Mosti
ALTER TABLE `ruoli_audio`
    ADD CONSTRAINT `ruoli_audio_ibfk_01`   FOREIGN KEY (`id_genitore`) REFERENCES `ruoli_audio` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000034400

-- ruoli_file
-- tipologia: tabella di supporto
-- verifica: 2021-10-11 18:25 Fabio Mosti
ALTER TABLE `ruoli_file`
    ADD CONSTRAINT `ruoli_file_ibfk_01`     FOREIGN KEY (`id_genitore`) REFERENCES `ruoli_file` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000034600

-- ruoli_immagini
-- tipologia: tabella di supporto
-- verifica: 2021-10-11 18:25 Fabio Mosti
ALTER TABLE `ruoli_immagini`
    ADD CONSTRAINT `ruoli_immagini_ibfk_01`     FOREIGN KEY (`id_genitore`) REFERENCES `ruoli_immagini` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000034800

-- ruoli_indirizzi
-- tipologia: tabella di supporto
-- verifica: 2021-10-12 10:57 Fabio Mosti
ALTER TABLE `ruoli_indirizzi`
    ADD CONSTRAINT `ruoli_indirizzi_ibfk_01`    FOREIGN KEY (`id_genitore`) REFERENCES `ruoli_indirizzi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000035000

-- ruoli_prodotti
-- tipologia: tabella di supporto
-- verifica: 2021-10-12 10:57 Fabio Mosti
ALTER TABLE `ruoli_prodotti`
    ADD CONSTRAINT `ruoli_prodotti_ibfk_01`     FOREIGN KEY (`id_genitore`) REFERENCES `ruoli_prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000035200

-- ruoli_video
-- tipologia: tabella di supporto
-- verifica: 2021-10-12 10:57 Fabio Mosti
ALTER TABLE `ruoli_video`
    ADD CONSTRAINT `ruoli_video_ibfk_01`        FOREIGN KEY (`id_genitore`) REFERENCES `ruoli_video` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000037000

-- settori
-- tipologia: tabella di supporto
-- verifica: 2021-10-12 10:57 Fabio Mosti
ALTER TABLE `settori`
    ADD CONSTRAINT `settori_ibfk_01`            FOREIGN KEY (`id_genitore`) REFERENCES `settori` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000041000

-- sms_out
-- tipolgia: tabella gestita
-- verifica: 2021-10-12 12:03 Fabio Mosti
ALTER TABLE `sms_out`
    ADD CONSTRAINT `sms_out_ibfk_01_nofollow`   FOREIGN KEY (`id_telefono`) REFERENCES `telefoni` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `sms_out_ibfk_98_nofollow`   FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `sms_out_ibfk_99_nofollow`   FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000041200

-- sms_sent
-- tipolgia: tabella gestita
-- verifica: 2021-10-12 12:03 Fabio Mosti
ALTER TABLE `sms_sent`
    ADD CONSTRAINT `sms_sent_ibfk_01_nofollow`  FOREIGN KEY (`id_telefono`) REFERENCES `telefoni` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `sms_sent_ibfk_98_nofollow`  FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `sms_sent_ibfk_99_nofollow`  FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000041400

-- software
-- tipologia: tabella gestita
-- verifica: 2021-11-16 10:39 Chiara GDL
ALTER TABLE `software`
    ADD CONSTRAINT `software_ibfk_01_nofollow`   FOREIGN KEY (`id_genitore`) REFERENCES `software` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `software_ibfk_02_nofollow`   FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `software_ibfk_98_nofollow`   FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `software_ibfk_99_nofollow`   FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000042000

-- stati
-- tipologia: tabella di supporto
-- verifica: 2021-10-12 12:03 Fabio Mosti
ALTER TABLE `stati`
    ADD CONSTRAINT `stati_ibfk_01_nofollow`     FOREIGN KEY (`id_continente`) REFERENCES `continenti` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--| 060000042200

-- stati_lingue
-- tipologia: tabella di supporto
-- verifica: 2021-10-12 15:30 Fabio Mosti
ALTER TABLE `stati_lingue`
    ADD CONSTRAINT `stati_lingue_ibfk_01_nofollow`  FOREIGN KEY (`id_stato`) REFERENCES `stati` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `stati_lingue_ibfk_02_nofollow`  FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--| 060000043000

-- task
-- tipologia: tabella gestita
-- verifica: 2021-10-15 10:42 Fabio Mosti
ALTER TABLE `task`
    ADD CONSTRAINT `task_ibfk_98_nofollow`      FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `task_ibfk_99_nofollow`      FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000043600

-- telefoni
-- tipologia: tabella gestita
-- verifica: 2021-10-15 10:51 Fabio Mosti
ALTER TABLE `telefoni`
    ADD CONSTRAINT `telefoni_ibfk_01`               FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `telefoni_ibfk_02_nofollow`      FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_telefoni` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `telefoni_ibfk_98_nofollow`      FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `telefoni_ibfk_99_nofollow`      FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000044000

-- template
-- tipologia: tabella gestita
-- verifica: 2021-10-15 12:41 Fabio Mosti
ALTER TABLE `template`
    ADD CONSTRAINT `template_ibfk_98_nofollow`      FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `template_ibfk_99_nofollow`      FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000045000

-- testate
-- tipologia: tabella gestita
-- verifica: 2021-10-15 12:41 Fabio Mosti
ALTER TABLE `testate`
    ADD CONSTRAINT `testate_ibfk_98_nofollow`       FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `testate_ibfk_99_nofollow`       FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000050000

-- tipologie_anagrafica
-- tipologia: tabella assistita
-- verifica: 2021-10-15 18:10 Fabio Mosti
ALTER TABLE `tipologie_anagrafica`
    ADD CONSTRAINT `tipologie_anagrafica_ibfk_01_nofollow`      FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_anagrafica_ibfk_98_nofollow`      FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_anagrafica_ibfk_99_nofollow`      FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000050400

-- tipologie_attivita
-- tipologia: tabella assistita
-- verifica: 2021-10-15 18:10 Fabio Mosti
ALTER TABLE `tipologie_attivita`
    ADD CONSTRAINT `tipologie_attivita_ibfk_01_nofollow`        FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_attivita` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_attivita_ibfk_98_nofollow`        FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_attivita_ibfk_99_nofollow`        FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000050600

-- tipologie_chiavi
-- tipologia: tabella assistita
-- verifica: 2021-11-15 11:10 Chiara GDL
ALTER TABLE `tipologie_chiavi`
    ADD CONSTRAINT `tipologie_chiavi_ibfk_01_nofollow`        FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_chiavi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_chiavi_ibfk_98_nofollow`        FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_chiavi_ibfk_99_nofollow`        FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000050800

-- tipologie_contatti
-- tipologia: tabella assistita
-- verifica: 2021-10-15 18:10 Fabio Mosti
ALTER TABLE `tipologie_contatti`
    ADD CONSTRAINT `tipologie_contatti_ibfk_01_nofollow`        FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_contatti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_contatti_ibfk_98_nofollow`        FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_contatti_ibfk_99_nofollow`        FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000052600

-- tipologie_documenti
-- tipologia: tabella assistita
-- verifica: 2021-10-15 18:10 Fabio Mosti
ALTER TABLE `tipologie_documenti`
    ADD CONSTRAINT `tipologie_documenti_ibfk_01_nofollow`       FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_documenti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_documenti_ibfk_98_nofollow`       FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_documenti_ibfk_99_nofollow`       FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000053000

-- tipologie_indirizzi
-- tipologia: tabella assistita
-- verifica: 2021-10-15 18:10 Fabio Mosti
ALTER TABLE `tipologie_indirizzi`
    ADD CONSTRAINT `tipologie_indirizzi_ibfk_01_nofollow`       FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_indirizzi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_indirizzi_ibfk_98_nofollow`       FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_indirizzi_ibfk_99_nofollow`       FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000053200

-- tipologie_licenze
-- tipologia: tabella assistita
-- verifica: 2021-11-15 11:10 Chiara GDL
ALTER TABLE `tipologie_licenze`
    ADD CONSTRAINT `tipologie_licenze_ibfk_01_nofollow`        FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_licenze` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_licenze_ibfk_98_nofollow`        FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_licenze_ibfk_99_nofollow`        FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000053400

-- tipologie_mastri
-- tipologia: tabella assistita
-- verifica: 2021-10-15 18:10 Fabio Mosti
ALTER TABLE `tipologie_mastri`
    ADD CONSTRAINT `tipologie_mastri_ibfk_01_nofollow`          FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_mastri` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_mastri_ibfk_98_nofollow`          FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_mastri_ibfk_99_nofollow`          FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000053800

-- tipologie_notizie
-- tipologia: tabella assistita
-- verifica: 2021-10-15 18:10 Fabio Mosti
ALTER TABLE `tipologie_notizie`
    ADD CONSTRAINT `tipologie_notizie_ibfk_01_nofollow`         FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_notizie_ibfk_98_nofollow`         FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_notizie_ibfk_99_nofollow`         FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000054000

-- tipologie_pagamenti
-- tipologia: tabella assistita
-- verifica: 2021-11-15 11:10 Chiara GDL
ALTER TABLE `tipologie_pagamenti`
    ADD CONSTRAINT `tipologie_pagamenti_ibfk_01_nofollow`        FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_pagamenti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_pagamenti_ibfk_98_nofollow`        FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_pagamenti_ibfk_99_nofollow`        FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000054200

-- tipologie_popup
-- tipologia: tabella assistita
-- verifica: 2021-10-15 18:10 Fabio Mosti
ALTER TABLE `tipologie_popup`
    ADD CONSTRAINT `tipologie_popup_ibfk_01_nofollow`           FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_popup` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_popup_ibfk_98_nofollow`           FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_popup_ibfk_99_nofollow`           FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000054600

-- tipologie_prodotti
-- tipologia: tabella assistita
-- verifica: 2021-10-15 18:10 Fabio Mosti
ALTER TABLE `tipologie_prodotti`
    ADD CONSTRAINT `tipologie_prodotti_ibfk_01_nofollow`        FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_prodotti_ibfk_98_nofollow`        FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_prodotti_ibfk_99_nofollow`        FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000055000

-- tipologie_progetti
-- tipologia: tabella assistita
-- verifica: 2021-10-15 18:10 Fabio Mosti
ALTER TABLE `tipologie_progetti`
    ADD CONSTRAINT `tipologie_progetti_ibfk_01_nofollow`        FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_progetti_ibfk_98_nofollow`        FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_progetti_ibfk_99_nofollow`        FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000055400

-- tipologie_pubblicazioni
-- tipologia: tabella assistita
-- verifica: 2021-10-15 18:10 Fabio Mosti
ALTER TABLE `tipologie_pubblicazioni`
    ADD CONSTRAINT `tipologie_pubblicazioni_ibfk_01_nofollow`   FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_pubblicazioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_pubblicazioni_ibfk_98_nofollow`   FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_pubblicazioni_ibfk_99_nofollow`   FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000055800

-- tipologie_risorse
-- tipologia: tabella assistita
-- verifica: 2021-10-15 18:10 Fabio Mosti
ALTER TABLE `tipologie_risorse`
    ADD CONSTRAINT `tipologie_risorse_ibfk_01_nofollow`         FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_risorse_ibfk_98_nofollow`         FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_risorse_ibfk_99_nofollow`         FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000056200

-- tipologie_telefoni
-- tipologia: tabella assistita
-- verifica: 2021-10-15 18:10 Fabio Mosti
ALTER TABLE `tipologie_telefoni`
    ADD CONSTRAINT `tipologie_telefoni_ibfk_01_nofollow`        FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_telefoni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000056600

-- tipologie_todo
-- tipologia: tabella assistita
-- verifica: 2021-10-15 18:10 Fabio Mosti
ALTER TABLE `tipologie_todo`
    ADD CONSTRAINT `tipologie_todo_ibfk_01_nofollow`            FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_todo` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_todo_ibfk_98_nofollow`            FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_todo_ibfk_99_nofollow`            FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000056800

-- tipologie_url
-- tipologia: tabella assistita
-- verifica: 2021-11-09 12:45 Chiara GDL
ALTER TABLE `tipologie_url`
    ADD CONSTRAINT `tipologie_url_ibfk_01_nofollow`            FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_url` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_url_ibfk_98_nofollow`            FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_url_ibfk_99_nofollow`            FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000060000

-- todo
-- tipologia: tabella gestita
-- verifica: 2021-10-18 17:57 Fabio Mosti
ALTER TABLE `todo`
    ADD CONSTRAINT `todo_ibfk_01_nofollow`      FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_todo`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `todo_ibfk_02_nofollow`      FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `todo_ibfk_03_nofollow`      FOREIGN KEY (`id_cliente`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `todo_ibfk_04_nofollow`      FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `todo_ibfk_05_nofollow`      FOREIGN KEY (`id_luogo`) REFERENCES `luoghi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `todo_ibfk_06_nofollow`      FOREIGN KEY (`id_contatto`) REFERENCES `contatti` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `todo_ibfk_07_nofollow`      FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `todo_ibfk_08_nofollow`      FOREIGN KEY (`id_pianificazione`) REFERENCES `pianificazioni` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `todo_ibfk_98_nofollow`      FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `todo_ibfk_99_nofollow`      FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000062000

-- udm
-- tipologia: tabella di supporto
-- verifica: 2021-10-19 13:06 Fabio Mosti
ALTER TABLE `udm`
    ADD CONSTRAINT `udm_ibfk_01_nofollow`       FOREIGN KEY (`id_genitore`) REFERENCES `udm` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--| 060000062600

-- url
-- tipologia: tabella gestita
-- verifica: 2021-10-18 17:57 Fabio Mosti
ALTER TABLE `url`
    ADD CONSTRAINT `url_ibfk_01_nofollow`       FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_url`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `url_ibfk_02_nofollow`       FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `url_ibfk_98_nofollow`       FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `url_ibfk_99_nofollow`       FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 060000065000

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
    ADD CONSTRAINT `video_ibfk_10`              FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `video_ibfk_11_nofollow`     FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `video_ibfk_12_nofollow`     FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_video` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `video_ibfk_13_nofollow`     FOREIGN KEY (`id_embed`) REFERENCES `embed` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `video_ibfk_98_nofollow`     FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `video_ibfk_99_nofollow`     FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| FINE FILE