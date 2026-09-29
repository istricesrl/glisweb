-- 2026-09-30 — i dati standard che il riallineamento del 02/03/2026 aveva tolto dai file di base
--
-- Contesto: il riallineamento d975b4a15 ha tolto dal file dei dati le righe standard di caratteristiche,
-- categorie_progetti, ruoli_mail, step, taglie, task, tipologie_contratti, tipologie_pagamenti, tipologie_progetti,
-- tipologie_rinnovi e tipologie_todo: un deploy installato dopo marzo ha quelle tabelle vuote. Non sono dettagli:
-- il modulo _0920.corsi cerca le lezioni con todo.id_tipologia IN ( 14, 15 ), cioe' "recupero lezione" e "lezione"
-- di tipologie_todo, e i tre task ( ridimensionamento delle immagini, code di mail e SMS ) sono quelli che il cron
-- esegue. I file di base le hanno di nuovo, con gli stessi id di prima di marzo; caratteristiche e' adattata alle
-- colonne di oggi ( se_prodotto e se_articolo sono diventate se_prodotti e se_articoli ).
--
-- COSA FA. Inserisce le righe che mancano, e solo quelle: una riga non entra se sul deploy c'e' gia' una riga con lo
-- stesso id o con lo stesso nome ( per task, con lo stesso percorso ), quindi le righe che i deploy hanno modificato
-- o rinumerato restano come sono. Negli alberi le righe figlie entrano solo se il genitore con quell'id c'e' e ha il
-- nome atteso, e si inseriscono dopo le radici, un livello per blocco; le taglie solo se tipologie_prodotti 12 e 13
-- sono "maglieria" e "caschi", come nei file di base.
--
-- Le istruzioni passano da una procedura che, se falliscono ( una tabella con colonne di un'altra epoca ), lo
-- annotano in @dati_standard_note invece di fermare il task: il task delle patch non esegue PREPARE ed EXECUTE,
-- vedi _202609301100.chiavi.esterne.sql.
--
-- ATTENZIONE: su un deploy che non aveva nessun task, le tre righe di task li mettono in esecuzione dal primo giro
-- di cron; chi non li vuole li deve disattivare dopo la patch.
--
-- IDEMPOTENTE.

-- | 202609301000

-- la procedura che prova un'istruzione e, se fallisce, lo annota invece di fermare il task
CREATE OR REPLACE PROCEDURE `__patch_dati_standard__`( IN istruzione LONGTEXT, IN oggetto VARCHAR(64) )
BEGIN

    DECLARE messaggio TEXT DEFAULT NULL;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1 messaggio = MESSAGE_TEXT;
        END;

    SET @dati_standard_sql = istruzione;
    PREPARE prova FROM @dati_standard_sql;
    IF messaggio IS NULL THEN
        EXECUTE prova;
        DEALLOCATE PREPARE prova;
    END IF;

    IF messaggio IS NOT NULL THEN
        SET @dati_standard_note = CONCAT_WS( '\n', @dati_standard_note, CONCAT( oggetto, ': ', messaggio ) );
    END IF;

END;

-- | 202609301001

-- caratteristiche
CALL `__patch_dati_standard__`( '
INSERT IGNORE INTO `caratteristiche` ( `id`, `nome`, `font_awesome`, `html_entity`, `se_prodotti`, `se_articoli`, `se_immobili`, `se_categorie_prodotti`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento` )
    SELECT v.`id`, v.`nome`, v.`font_awesome`, v.`html_entity`, v.`se_prodotti`, v.`se_articoli`, v.`se_immobili`, v.`se_categorie_prodotti`, v.`id_account_inserimento`, v.`timestamp_inserimento`, v.`id_account_aggiornamento`, v.`timestamp_aggiornamento` FROM (
        SELECT 1 AS `id`, ''peso indicativo'' AS `nome`, NULL AS `font_awesome`, NULL AS `html_entity`, 1 AS `se_prodotti`, 1 AS `se_articoli`, NULL AS `se_immobili`, NULL AS `se_categorie_prodotti`, NULL AS `id_account_inserimento`, NULL AS `timestamp_inserimento`, NULL AS `id_account_aggiornamento`, NULL AS `timestamp_aggiornamento`
        UNION ALL SELECT 2, ''standard tecnici'', NULL, NULL, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL
        UNION ALL SELECT 3, ''unità di vendita'', NULL, NULL, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL
        UNION ALL SELECT 4, ''normativa FSC'', NULL, NULL, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL
    ) AS v
    WHERE NOT EXISTS ( SELECT 1 FROM `caratteristiche` AS e WHERE e.id = v.id OR e.`nome` = v.`nome` )
', 'caratteristiche' );

-- | 202609301002

-- categorie_progetti
CALL `__patch_dati_standard__`( '
INSERT IGNORE INTO `categorie_progetti` ( `id`, `id_genitore`, `ordine`, `nome`, `se_ordinario`, `se_straordinario`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento` )
    SELECT v.`id`, v.`id_genitore`, v.`ordine`, v.`nome`, v.`se_ordinario`, v.`se_straordinario`, v.`id_account_inserimento`, v.`timestamp_inserimento`, v.`id_account_aggiornamento`, v.`timestamp_aggiornamento` FROM (
        SELECT 1 AS `id`, NULL AS `id_genitore`, NULL AS `ordine`, ''ordinario'' AS `nome`, 1 AS `se_ordinario`, NULL AS `se_straordinario`, NULL AS `id_account_inserimento`, NULL AS `timestamp_inserimento`, NULL AS `id_account_aggiornamento`, NULL AS `timestamp_aggiornamento`
        UNION ALL SELECT 2, NULL, NULL, ''straordinario'', NULL, 1, NULL, NULL, NULL, NULL
    ) AS v
    WHERE NOT EXISTS ( SELECT 1 FROM `categorie_progetti` AS e WHERE e.id = v.id OR e.`nome` = v.`nome` )
', 'categorie_progetti' );

-- | 202609301003

-- ruoli_mail
CALL `__patch_dati_standard__`( '
INSERT IGNORE INTO `ruoli_mail` ( `id`, `id_genitore`, `nome`, `html_entity`, `font_awesome`, `se_xml`, `se_commerciale`, `se_produzione`, `se_amministrazione`, `se_acquisti`, `se_ordini`, `se_helpdesk` )
    SELECT v.`id`, v.`id_genitore`, v.`nome`, v.`html_entity`, v.`font_awesome`, v.`se_xml`, v.`se_commerciale`, v.`se_produzione`, v.`se_amministrazione`, v.`se_acquisti`, v.`se_ordini`, v.`se_helpdesk` FROM (
        SELECT 1 AS `id`, NULL AS `id_genitore`, ''generica'' AS `nome`, NULL AS `html_entity`, NULL AS `font_awesome`, NULL AS `se_xml`, 1 AS `se_commerciale`, 1 AS `se_produzione`, 1 AS `se_amministrazione`, 1 AS `se_acquisti`, 1 AS `se_ordini`, 1 AS `se_helpdesk`
        UNION ALL SELECT 2, NULL, ''commerciale'', NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL
        UNION ALL SELECT 3, NULL, ''produzione'', NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL
        UNION ALL SELECT 4, NULL, ''amministrazione'', NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL
        UNION ALL SELECT 5, NULL, ''acquisti'', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL
        UNION ALL SELECT 6, NULL, ''ordini'', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL
        UNION ALL SELECT 7, NULL, ''helpdesk'', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1
    ) AS v
    WHERE NOT EXISTS ( SELECT 1 FROM `ruoli_mail` AS e WHERE e.id = v.id OR e.`nome` = v.`nome` )
', 'ruoli_mail' );

-- | 202609301004

-- step
CALL `__patch_dati_standard__`( '
INSERT IGNORE INTO `step` ( `id`, `id_funnel`, `ordine`, `nome`, `note` )
    SELECT v.`id`, v.`id_funnel`, v.`ordine`, v.`nome`, v.`note` FROM (
        SELECT 1 AS `id`, NULL AS `id_funnel`, NULL AS `ordine`, ''apertura'' AS `nome`, NULL AS `note`
        UNION ALL SELECT 2, NULL, NULL, ''in corso'', NULL
        UNION ALL SELECT 3, NULL, NULL, ''esito positivo'', NULL
        UNION ALL SELECT 4, NULL, NULL, ''esito negativo'', NULL
    ) AS v
    WHERE NOT EXISTS ( SELECT 1 FROM `step` AS e WHERE e.id = v.id OR e.`nome` = v.`nome` )
', 'step' );

-- | 202609301005

-- taglie
CALL `__patch_dati_standard__`( '
INSERT IGNORE INTO `taglie` ( `id`, `id_tipologia_prodotti`, `nome`, `sesso`, `taglia_internazionale`, `circonferenza_testa_min`, `circonferenza_testa_max` )
    SELECT v.`id`, v.`id_tipologia_prodotti`, v.`nome`, v.`sesso`, v.`taglia_internazionale`, v.`circonferenza_testa_min`, v.`circonferenza_testa_max` FROM (
        SELECT 1 AS `id`, 12 AS `id_tipologia_prodotti`, ''abbigliamento XXXS uomo'' AS `nome`, ''M'' AS `sesso`, ''XXXS'' AS `taglia_internazionale`, NULL AS `circonferenza_testa_min`, NULL AS `circonferenza_testa_max`
        UNION ALL SELECT 2, 12, ''abbigliamento XXS uomo'', ''M'', ''XXS'', NULL, NULL
        UNION ALL SELECT 3, 12, ''abbigliamento XS uomo'', ''M'', ''XS'', NULL, NULL
        UNION ALL SELECT 4, 12, ''abbigliamento S uomo'', ''M'', ''S'', NULL, NULL
        UNION ALL SELECT 5, 12, ''abbigliamento M uomo'', ''M'', ''M'', NULL, NULL
        UNION ALL SELECT 6, 12, ''abbigliamento L uomo'', ''M'', ''L'', NULL, NULL
        UNION ALL SELECT 7, 12, ''abbigliamento XL uomo'', ''M'', ''XL'', NULL, NULL
        UNION ALL SELECT 8, 12, ''abbigliamento XXL uomo'', ''M'', ''XXL'', NULL, NULL
        UNION ALL SELECT 9, 12, ''abbigliamento XXXL uomo'', ''M'', ''XXXL'', NULL, NULL
        UNION ALL SELECT 10, 12, ''abbigliamento 4XL uomo'', ''M'', ''4XL'', NULL, NULL
        UNION ALL SELECT 11, 12, ''abbigliamento XXS donna'', ''F'', ''XXXS'', NULL, NULL
        UNION ALL SELECT 12, 12, ''abbigliamento XS donna'', ''F'', ''XXS'', NULL, NULL
        UNION ALL SELECT 13, 12, ''abbigliamento S donna'', ''F'', ''XS'', NULL, NULL
        UNION ALL SELECT 14, 12, ''abbigliamento M donna'', ''F'', ''S'', NULL, NULL
        UNION ALL SELECT 15, 12, ''abbigliamento L donna'', ''F'', ''M'', NULL, NULL
        UNION ALL SELECT 16, 12, ''abbigliamento XL donna'', ''F'', ''L'', NULL, NULL
        UNION ALL SELECT 17, 12, ''abbigliamento XXL donna'', ''F'', ''XL'', NULL, NULL
        UNION ALL SELECT 18, 12, ''abbigliamento XXXL donna'', ''F'', ''XXL'', NULL, NULL
        UNION ALL SELECT 19, 13, ''caschi XXS'', NULL, ''XXS'', 510, 529
        UNION ALL SELECT 20, 13, ''caschi XS'', NULL, ''XS'', 530, 549
        UNION ALL SELECT 21, 13, ''caschi S'', NULL, ''S'', 550, 569
        UNION ALL SELECT 22, 13, ''caschi M'', NULL, ''M'', 570, 589
        UNION ALL SELECT 23, 13, ''caschi L'', NULL, ''L'', 590, 609
        UNION ALL SELECT 24, 13, ''caschi XL'', NULL, ''XL'', 610, 629
        UNION ALL SELECT 25, 13, ''caschi XXL'', NULL, ''XXL'', 630, 649
        UNION ALL SELECT 26, 13, ''caschi taglia unica'', NULL, ''UNICA'', NULL, NULL
    ) AS v
    WHERE NOT EXISTS ( SELECT 1 FROM `taglie` AS e WHERE e.id = v.id OR e.`nome` = v.`nome` ) AND EXISTS ( SELECT 1 FROM `tipologie_prodotti` AS g WHERE g.id = v.`id_tipologia_prodotti` AND g.nome = CASE v.`id_tipologia_prodotti` WHEN 12 THEN ''maglieria'' WHEN 13 THEN ''caschi'' END )
', 'taglie' );

-- | 202609301006

-- task
CALL `__patch_dati_standard__`( '
INSERT IGNORE INTO `task` ( `id`, `minuto`, `ora`, `giorno_del_mese`, `mese`, `giorno_della_settimana`, `settimana`, `task`, `iterazioni`, `delay`, `token`, `timestamp_esecuzione`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento` )
    SELECT v.`id`, v.`minuto`, v.`ora`, v.`giorno_del_mese`, v.`mese`, v.`giorno_della_settimana`, v.`settimana`, v.`task`, v.`iterazioni`, v.`delay`, v.`token`, v.`timestamp_esecuzione`, v.`id_account_inserimento`, v.`timestamp_inserimento`, v.`id_account_aggiornamento`, v.`timestamp_aggiornamento` FROM (
        SELECT 1 AS `id`, NULL AS `minuto`, NULL AS `ora`, NULL AS `giorno_del_mese`, NULL AS `mese`, NULL AS `giorno_della_settimana`, NULL AS `settimana`, ''_src/_api/_task/_images.resize.php'' AS `task`, 1 AS `iterazioni`, NULL AS `delay`, NULL AS `token`, NULL AS `timestamp_esecuzione`, NULL AS `id_account_inserimento`, NULL AS `timestamp_inserimento`, NULL AS `id_account_aggiornamento`, NULL AS `timestamp_aggiornamento`
        UNION ALL SELECT 2, NULL, NULL, NULL, NULL, NULL, NULL, ''_src/_api/_task/_mail.queue.send.php'', 20, 2, NULL, NULL, NULL, NULL, NULL, NULL
        UNION ALL SELECT 3, NULL, NULL, NULL, NULL, NULL, NULL, ''_src/_api/_task/_sms.queue.send.php'', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL
    ) AS v
    WHERE NOT EXISTS ( SELECT 1 FROM `task` AS e WHERE e.id = v.id OR e.`task` = v.`task` )
', 'task' );

-- | 202609301007

-- tipologie_contratti
CALL `__patch_dati_standard__`( '
INSERT IGNORE INTO `tipologie_contratti` ( `id`, `ordine`, `nome`, `html_entity`, `font_awesome`, `se_tesseramento`, `se_abbonamento`, `se_iscrizione`, `se_affiliazione`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento` )
    SELECT v.`id`, v.`ordine`, v.`nome`, v.`html_entity`, v.`font_awesome`, v.`se_tesseramento`, v.`se_abbonamento`, v.`se_iscrizione`, v.`se_affiliazione`, v.`id_account_inserimento`, v.`timestamp_inserimento`, v.`id_account_aggiornamento`, v.`timestamp_aggiornamento` FROM (
        SELECT 1 AS `id`, NULL AS `ordine`, ''vendita'' AS `nome`, NULL AS `html_entity`, NULL AS `font_awesome`, NULL AS `se_tesseramento`, NULL AS `se_abbonamento`, NULL AS `se_iscrizione`, NULL AS `se_affiliazione`, NULL AS `id_account_inserimento`, NULL AS `timestamp_inserimento`, NULL AS `id_account_aggiornamento`, NULL AS `timestamp_aggiornamento`
        UNION ALL SELECT 2, NULL, ''locazione'', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
        UNION ALL SELECT 3, NULL, ''tesseramento'', NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL
        UNION ALL SELECT 4, NULL, ''abbonamento'', NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL
        UNION ALL SELECT 5, NULL, ''iscrizione'', NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL
        UNION ALL SELECT 6, NULL, ''affiliazione'', NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL
        UNION ALL SELECT 7, NULL, ''servizi'', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
    ) AS v
    WHERE NOT EXISTS ( SELECT 1 FROM `tipologie_contratti` AS e WHERE e.id = v.id OR e.`nome` = v.`nome` )
', 'tipologie_contratti' );

-- | 202609301008

-- tipologie_pagamenti
CALL `__patch_dati_standard__`( '
INSERT IGNORE INTO `tipologie_pagamenti` ( `id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento` )
    SELECT v.`id`, v.`id_genitore`, v.`ordine`, v.`nome`, v.`html_entity`, v.`font_awesome`, v.`id_account_inserimento`, v.`timestamp_inserimento`, v.`id_account_aggiornamento`, v.`timestamp_aggiornamento` FROM (
        SELECT 1 AS `id`, NULL AS `id_genitore`, NULL AS `ordine`, ''acconto'' AS `nome`, NULL AS `html_entity`, NULL AS `font_awesome`, NULL AS `id_account_inserimento`, NULL AS `timestamp_inserimento`, NULL AS `id_account_aggiornamento`, NULL AS `timestamp_aggiornamento`
        UNION ALL SELECT 2, NULL, NULL, ''saldo'', NULL, NULL, NULL, NULL, NULL, NULL
        UNION ALL SELECT 3, NULL, NULL, ''soluzione unica'', NULL, NULL, NULL, NULL, NULL, NULL
    ) AS v
    WHERE NOT EXISTS ( SELECT 1 FROM `tipologie_pagamenti` AS e WHERE e.id = v.id OR e.`nome` = v.`nome` )
', 'tipologie_pagamenti' );

-- | 202609301009

-- tipologie_progetti
CALL `__patch_dati_standard__`( '
INSERT IGNORE INTO `tipologie_progetti` ( `id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`, `se_produzione`, `se_contratto`, `se_pacchetto`, `se_progetto`, `se_consuntivo`, `se_forfait`, `se_didattica`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento` )
    SELECT v.`id`, v.`id_genitore`, v.`ordine`, v.`nome`, v.`html_entity`, v.`font_awesome`, v.`se_produzione`, v.`se_contratto`, v.`se_pacchetto`, v.`se_progetto`, v.`se_consuntivo`, v.`se_forfait`, v.`se_didattica`, v.`id_account_inserimento`, v.`timestamp_inserimento`, v.`id_account_aggiornamento`, v.`timestamp_aggiornamento` FROM (
        SELECT 1 AS `id`, NULL AS `id_genitore`, NULL AS `ordine`, ''contratto'' AS `nome`, NULL AS `html_entity`, NULL AS `font_awesome`, 1 AS `se_produzione`, 1 AS `se_contratto`, NULL AS `se_pacchetto`, NULL AS `se_progetto`, NULL AS `se_consuntivo`, NULL AS `se_forfait`, NULL AS `se_didattica`, NULL AS `id_account_inserimento`, NULL AS `timestamp_inserimento`, NULL AS `id_account_aggiornamento`, NULL AS `timestamp_aggiornamento`
        UNION ALL SELECT 2, NULL, NULL, ''pacchetto'', NULL, NULL, 1, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
        UNION ALL SELECT 3, NULL, NULL, ''progetto'', NULL, NULL, 1, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL
        UNION ALL SELECT 4, NULL, NULL, ''consuntivo'', NULL, NULL, 1, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL
        UNION ALL SELECT 5, NULL, NULL, ''forfait'', NULL, NULL, 1, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL
        UNION ALL SELECT 6, NULL, NULL, ''corso'', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL
    ) AS v
    WHERE NOT EXISTS ( SELECT 1 FROM `tipologie_progetti` AS e WHERE e.id = v.id OR e.`nome` = v.`nome` )
', 'tipologie_progetti' );

-- | 202609301010

-- tipologie_rinnovi
CALL `__patch_dati_standard__`( '
INSERT IGNORE INTO `tipologie_rinnovi` ( `id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`, `se_tesseramenti`, `se_iscrizioni`, `se_abbonamenti`, `se_licenze`, `se_contratti`, `se_progetti`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento` )
    SELECT v.`id`, v.`id_genitore`, v.`ordine`, v.`nome`, v.`html_entity`, v.`font_awesome`, v.`se_tesseramenti`, v.`se_iscrizioni`, v.`se_abbonamenti`, v.`se_licenze`, v.`se_contratti`, v.`se_progetti`, v.`id_account_inserimento`, v.`timestamp_inserimento`, v.`id_account_aggiornamento`, v.`timestamp_aggiornamento` FROM (
        SELECT 1 AS `id`, NULL AS `id_genitore`, NULL AS `ordine`, ''ordinario'' AS `nome`, NULL AS `html_entity`, NULL AS `font_awesome`, 1 AS `se_tesseramenti`, 1 AS `se_iscrizioni`, 1 AS `se_abbonamenti`, 1 AS `se_licenze`, 1 AS `se_contratti`, 1 AS `se_progetti`, NULL AS `id_account_inserimento`, NULL AS `timestamp_inserimento`, NULL AS `id_account_aggiornamento`, NULL AS `timestamp_aggiornamento`
        UNION ALL SELECT 2, NULL, NULL, ''straordinario'', NULL, NULL, 1, 1, 1, 1, 1, 1, NULL, NULL, NULL, NULL
        UNION ALL SELECT 3, NULL, NULL, ''ridotto'', NULL, NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL
    ) AS v
    WHERE NOT EXISTS ( SELECT 1 FROM `tipologie_rinnovi` AS e WHERE e.id = v.id OR e.`nome` = v.`nome` )
', 'tipologie_rinnovi' );

-- | 202609301011

-- tipologie_todo, livello 0
CALL `__patch_dati_standard__`( '
INSERT IGNORE INTO `tipologie_todo` ( `id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`, `se_agenda`, `se_ticket`, `se_ordinaria`, `se_straordinaria`, `se_commerciale`, `se_produzione`, `se_amministrazione`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento` )
    SELECT v.`id`, v.`id_genitore`, v.`ordine`, v.`nome`, v.`html_entity`, v.`font_awesome`, v.`se_agenda`, v.`se_ticket`, v.`se_ordinaria`, v.`se_straordinaria`, v.`se_commerciale`, v.`se_produzione`, v.`se_amministrazione`, v.`id_account_inserimento`, v.`timestamp_inserimento`, v.`id_account_aggiornamento`, v.`timestamp_aggiornamento` FROM (
        SELECT 1 AS `id`, NULL AS `id_genitore`, NULL AS `ordine`, ''produzione'' AS `nome`, NULL AS `html_entity`, NULL AS `font_awesome`, 1 AS `se_agenda`, NULL AS `se_ticket`, NULL AS `se_ordinaria`, NULL AS `se_straordinaria`, NULL AS `se_commerciale`, 1 AS `se_produzione`, NULL AS `se_amministrazione`, NULL AS `id_account_inserimento`, NULL AS `timestamp_inserimento`, NULL AS `id_account_aggiornamento`, NULL AS `timestamp_aggiornamento`
        UNION ALL SELECT 2, NULL, NULL, ''commerciale'', NULL, NULL, 1, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL
        UNION ALL SELECT 3, NULL, NULL, ''amministrazione'', NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL
        UNION ALL SELECT 16, NULL, NULL, ''risorse umane'', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
        UNION ALL SELECT 20, NULL, NULL, ''logistica'', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
    ) AS v
    WHERE NOT EXISTS ( SELECT 1 FROM `tipologie_todo` AS e WHERE e.id = v.id OR e.`nome` = v.`nome` )
', 'tipologie_todo' );

-- | 202609301012

-- tipologie_todo, livello 1
CALL `__patch_dati_standard__`( '
INSERT IGNORE INTO `tipologie_todo` ( `id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`, `se_agenda`, `se_ticket`, `se_ordinaria`, `se_straordinaria`, `se_commerciale`, `se_produzione`, `se_amministrazione`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento` )
    SELECT v.`id`, v.`id_genitore`, v.`ordine`, v.`nome`, v.`html_entity`, v.`font_awesome`, v.`se_agenda`, v.`se_ticket`, v.`se_ordinaria`, v.`se_straordinaria`, v.`se_commerciale`, v.`se_produzione`, v.`se_amministrazione`, v.`id_account_inserimento`, v.`timestamp_inserimento`, v.`id_account_aggiornamento`, v.`timestamp_aggiornamento` FROM (
        SELECT 4 AS `id`, 1 AS `id_genitore`, NULL AS `ordine`, ''sviluppo'' AS `nome`, NULL AS `html_entity`, NULL AS `font_awesome`, NULL AS `se_agenda`, NULL AS `se_ticket`, NULL AS `se_ordinaria`, NULL AS `se_straordinaria`, NULL AS `se_commerciale`, 1 AS `se_produzione`, NULL AS `se_amministrazione`, NULL AS `id_account_inserimento`, NULL AS `timestamp_inserimento`, NULL AS `id_account_aggiornamento`, NULL AS `timestamp_aggiornamento`
        UNION ALL SELECT 5, 1, NULL, ''assistenza'', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL
        UNION ALL SELECT 6, 1, NULL, ''formazione'', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL
        UNION ALL SELECT 7, 1, NULL, ''consulenza'', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL
        UNION ALL SELECT 8, 1, NULL, ''fornitura'', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL
        UNION ALL SELECT 9, 1, NULL, ''ticket'', NULL, NULL, NULL, 1, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL
        UNION ALL SELECT 10, 2, NULL, ''ricerca clienti'', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL
        UNION ALL SELECT 11, 2, NULL, ''customer care'', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL
        UNION ALL SELECT 12, 2, NULL, ''preventivazione'', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL
    ) AS v
    WHERE NOT EXISTS ( SELECT 1 FROM `tipologie_todo` AS e WHERE e.id = v.id OR e.`nome` = v.`nome` ) AND EXISTS ( SELECT 1 FROM `tipologie_todo` AS g WHERE g.id = v.id_genitore AND g.nome = CASE v.id_genitore WHEN 1 THEN ''produzione'' WHEN 2 THEN ''commerciale'' END )
', 'tipologie_todo' );

-- | 202609301013

-- tipologie_todo, livello 2
CALL `__patch_dati_standard__`( '
INSERT IGNORE INTO `tipologie_todo` ( `id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`, `se_agenda`, `se_ticket`, `se_ordinaria`, `se_straordinaria`, `se_commerciale`, `se_produzione`, `se_amministrazione`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento` )
    SELECT v.`id`, v.`id_genitore`, v.`ordine`, v.`nome`, v.`html_entity`, v.`font_awesome`, v.`se_agenda`, v.`se_ticket`, v.`se_ordinaria`, v.`se_straordinaria`, v.`se_commerciale`, v.`se_produzione`, v.`se_amministrazione`, v.`id_account_inserimento`, v.`timestamp_inserimento`, v.`id_account_aggiornamento`, v.`timestamp_aggiornamento` FROM (
        SELECT 14 AS `id`, 6 AS `id_genitore`, NULL AS `ordine`, ''recupero lezione'' AS `nome`, NULL AS `html_entity`, NULL AS `font_awesome`, NULL AS `se_agenda`, NULL AS `se_ticket`, NULL AS `se_ordinaria`, 1 AS `se_straordinaria`, NULL AS `se_commerciale`, NULL AS `se_produzione`, NULL AS `se_amministrazione`, NULL AS `id_account_inserimento`, NULL AS `timestamp_inserimento`, NULL AS `id_account_aggiornamento`, NULL AS `timestamp_aggiornamento`
        UNION ALL SELECT 15, 6, NULL, ''lezione'', NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
        UNION ALL SELECT 17, 6, NULL, ''lezione annullata'', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
        UNION ALL SELECT 18, 6, NULL, ''lezione di prova'', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
        UNION ALL SELECT 19, 6, NULL, ''open day'', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
    ) AS v
    WHERE NOT EXISTS ( SELECT 1 FROM `tipologie_todo` AS e WHERE e.id = v.id OR e.`nome` = v.`nome` ) AND EXISTS ( SELECT 1 FROM `tipologie_todo` AS g WHERE g.id = v.id_genitore AND g.nome = CASE v.id_genitore WHEN 6 THEN ''formazione'' END )
', 'tipologie_todo' );

-- | 202609301014

-- le righe non inserite perche' l'istruzione e' fallita: lo legge chi applica la patch a mano
SELECT @dati_standard_note AS nota;

-- | 202609301015

-- si libera la procedura
DROP PROCEDURE IF EXISTS `__patch_dati_standard__`;

-- | FINE FILE
