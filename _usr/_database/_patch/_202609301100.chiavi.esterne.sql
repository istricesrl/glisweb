-- 2026-09-30 — le chiavi esterne tolte dal riallineamento del 02/03/2026
--
-- Contesto: il riallineamento d975b4a15 ha tolto dai file di base circa cinquecento chiavi esterne di tabelle
-- che esistono ancora ( account, anagrafica, articoli, attivita, documenti, documenti_articoli, pagamenti,
-- progetti, todo, i contenuti, le tipologie e i ruoli, e altre ). Non sono solo integrita': controller() trova
-- le sottotabelle di una scheda seguendo le chiavi esterne che puntano alla tabella ( tranne le _nofollow ), e
-- mysqlDeleteRowRecursive() cancella a cascata seguendo quelle ON DELETE NO ACTION ( _src/_lib ). I file di base
-- le hanno di nuovo, secondo il canone scritto in _usr/_docs/_read/300.database.md ( "chiavi esterne" ); qui le
-- si porta ai deploy che non le hanno.
--
-- COSA FA. Per ogni vincolo della lista aggiunge la chiave esterna dei file di base, con lo stesso nome e le
-- stesse regole, solo se:
--
-- -# su quella colonna non c'e' gia' una chiave esterna, con qualunque nome e verso qualunque tabella: i deploy
--    installati prima di marzo le hanno con la numerazione e le regole di allora, e non si toccano;
-- -# tabella, colonna e tabella di riferimento esistono, e id della tabella di riferimento e' una chiave;
-- -# la colonna e id della tabella di riferimento hanno lo stesso tipo: sui deploy col modello di prima di marzo
--    articoli, prodotti, progetti, coupon e consensi hanno id testuali, e dove una delle due parti e' gia'
--    passata al modello numerico e l'altra no la ALTER fallirebbe;
-- -# non ci sono righe con un valore che nella tabella di riferimento non esiste, perche' la ALTER verificherebbe
--    i dati e fallirebbe: le righe orfane sono un problema del dato, e questa patch non e' il posto per decidere
--    cosa farne;
-- -# per documenti.id_sede_emittente e id_sede_destinatario, anagrafica_indirizzi ha le colonne inline della
--    migrazione delle sedi del 2026-07-10: prima di quella le due colonne contengono indirizzi.id.
--
-- Corregge poi sette vincoli presenti che violano il canone ( 98 e 99 di account_gruppi in CASCADE, che
-- cancellavano le appartenenze ai gruppi insieme all'account che le aveva scritte; le tipologie di annunci, pesi
-- della corrispondenza e url con regole diverse da NO ACTION / CASCADE; il ruolo di notizie_anagrafica in SET
-- NULL; url_ibfk_02 col nome pieno di spazi ), solo dove sono ancora esattamente quelli di prima, per nome e
-- regole: si toglie il vecchio e si mette il nuovo, e se il nuovo non entra si rimette il vecchio.
--
-- Negli altri casi non fa niente e lo scrive: la lista dei vincoli non aggiunti, col motivo, e' nella variabile
-- @chiavi_esterne_note, che il blocco dopo la CALL restituisce a chi applica la patch a mano.
--
-- PERCHE' UNA PROCEDURA E NON UN PREPARE PER VINCOLO, come _202609251500.pianificazioni.genitore.sql. I vincoli
-- sono cinquecento e i marcatori di una patch sono minuti: quattro blocchi per vincolo non ci stanno. E il task
-- delle patch esegue un blocco con mysqlQuery(), che smista la query sulla prima parola e non conosce PREPARE,
-- EXECUTE e DEALLOCATE: quei blocchi, dal task, non vengono eseguiti ( la funzione torna false senza errore ). La
-- procedura invece si crea con CREATE, si chiama con CALL e si toglie con DROP, tre comandi che mysqlQuery()
-- esegue; dentro, i controlli e le ALTER sono PREPARE eseguiti dal server. Non restituisce righe, perche' una CALL
-- che restituisce un risultato lascia la connessione fuori sincrono per la query successiva, che nel task e'
-- la scrittura su __patch__.
--
-- La lista di lavoro sta in una tabella vera, non temporanea, perche' se il task si interrompe fra un blocco e
-- l'altro riprende su un'altra connessione; si toglie alla fine. Ogni blocco resta sotto i 16 KB perche' il task
-- ne scrive il testo in __patch__.patch, che e' text.
--
-- La ALTER si esegue con foreign_key_checks a 0, dopo aver verificato da se' le righe orfane: cosi' MariaDB
-- aggiunge il vincolo senza ricopiare la tabella, cosa che su tabelle grandi con venti vincoli da aggiungere
-- farebbe venti copie. Se la colonna non ha un indice che la abbia come prima colonna, lo si aggiunge con il nome
-- della colonna, come nei file di base.
--
-- La patch viene dopo _202609300900.colonne.tabelle.viste.sql e _202609301030.coupon.sql, perche' porta anche le
-- chiavi delle colonne e delle tabelle che quelle aggiungono o convertono ( contatti.id_campagna, indirizzi.id_zona,
-- costi_contratti, orari_contratti, tipologie_attivita_inps, le colonne id_coupon ).
--
-- IDEMPOTENTE: una seconda esecuzione trova le chiavi presenti e non fa niente.

-- | 202609301100

-- la lista di lavoro: una riga per vincolo, con l'esito che la procedura scrive accanto
CREATE TABLE IF NOT EXISTS `__patch_chiavi_esterne__` (
  `tabella` char(64) NOT NULL,
  `vincolo` char(64) NOT NULL,
  `colonna` char(64) NOT NULL,
  `riferimento` char(64) NOT NULL,
  `cancellazione` char(16) NOT NULL,
  `aggiornamento` char(16) NOT NULL,
  `condizione` char(128) DEFAULT NULL,
  `vecchio_nome` varchar(64) DEFAULT NULL,
  `vecchia_cancellazione` char(16) DEFAULT NULL,
  `vecchio_aggiornamento` char(16) DEFAULT NULL,
  `esito` char(255) DEFAULT NULL,
  PRIMARY KEY (`tabella`,`vincolo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- | 202609301101

-- i vincoli da account a carrelli_articoli
INSERT IGNORE INTO `__patch_chiavi_esterne__` ( `tabella`, `vincolo`, `colonna`, `riferimento`, `cancellazione`, `aggiornamento`, `condizione` ) VALUES
( 'account', 'account_ibfk_01_nofollow', 'id_anagrafica', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'account', 'account_ibfk_02_nofollow', 'id_mail', 'mail', 'SET NULL', 'SET NULL', NULL ),
( 'account', 'account_ibfk_03_nofollow', 'id_affiliazione', 'contratti', 'SET NULL', 'SET NULL', NULL ),
( 'account', 'account_ibfk_04', 'id_url', 'url', 'SET NULL', 'SET NULL', NULL ),
( 'account', 'account_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'account', 'account_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'account_gruppi_attribuzione', 'account_gruppi_attribuzione_ibfk_01', 'id_account', 'account', 'CASCADE', 'CASCADE', NULL ),
( 'account_gruppi_attribuzione', 'account_gruppi_attribuzione_ibfk_02_nofollow', 'id_gruppo', 'gruppi', 'CASCADE', 'CASCADE', NULL ),
( 'account_gruppi_attribuzione', 'account_gruppi_attribuzione_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'account_gruppi_attribuzione', 'account_gruppi_attribuzione_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'anagrafica', 'anagrafica_ibfk_01_nofollow', 'id_tipologia', 'tipologie_anagrafica', 'NO ACTION', 'CASCADE', NULL ),
( 'anagrafica', 'anagrafica_ibfk_02_nofollow', 'id_badge', 'badge', 'SET NULL', 'SET NULL', NULL ),
( 'anagrafica', 'anagrafica_ibfk_03_nofollow', 'id_pec_sdi', 'mail', 'SET NULL', 'SET NULL', NULL ),
( 'anagrafica', 'anagrafica_ibfk_04_nofollow', 'id_regime', 'regimi', 'SET NULL', 'SET NULL', NULL ),
( 'anagrafica', 'anagrafica_ibfk_07_nofollow', 'id_ranking', 'ranking', 'SET NULL', 'SET NULL', NULL ),
( 'anagrafica', 'anagrafica_ibfk_08_nofollow', 'id_agente', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'anagrafica', 'anagrafica_ibfk_09_nofollow', 'id_responsabile_operativo', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'anagrafica', 'anagrafica_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'anagrafica', 'anagrafica_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'articoli', 'articoli_ibfk_01_nofollow', 'id_prodotto', 'prodotti', 'SET NULL', 'SET NULL', NULL ),
( 'articoli', 'articoli_ibfk_02_nofollow', 'id_reparto', 'reparti', 'SET NULL', 'SET NULL', NULL ),
( 'articoli', 'articoli_ibfk_03_nofollow', 'id_colore', 'colori', 'SET NULL', 'SET NULL', NULL ),
( 'articoli', 'articoli_ibfk_04_nofollow', 'id_periodicita', 'periodicita', 'SET NULL', 'SET NULL', NULL ),
( 'articoli', 'articoli_ibfk_05_nofollow', 'id_tipologia_rinnovo', 'tipologie_rinnovi', 'NO ACTION', 'CASCADE', NULL ),
( 'articoli', 'articoli_ibfk_06_nofollow', 'id_udm_dimensioni', 'udm', 'SET NULL', 'SET NULL', NULL ),
( 'articoli', 'articoli_ibfk_07_nofollow', 'id_udm_peso', 'udm', 'SET NULL', 'SET NULL', NULL ),
( 'articoli', 'articoli_ibfk_08_nofollow', 'id_udm_volume', 'udm', 'SET NULL', 'SET NULL', NULL ),
( 'articoli', 'articoli_ibfk_09_nofollow', 'id_udm_capacita', 'udm', 'SET NULL', 'SET NULL', NULL ),
( 'articoli', 'articoli_ibfk_10_nofollow', 'id_udm_durata', 'udm', 'SET NULL', 'SET NULL', NULL ),
( 'articoli', 'articoli_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'articoli', 'articoli_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'articoli_caratteristiche', 'articoli_caratteristiche_ibfk_01', 'id_articolo', 'articoli', 'CASCADE', 'CASCADE', NULL ),
( 'articoli_caratteristiche', 'articoli_caratteristiche_ibfk_02_nofollow', 'id_caratteristica', 'caratteristiche', 'CASCADE', 'CASCADE', NULL ),
( 'attivita', 'attivita_ibfk_01_nofollow', 'id_genitore', 'attivita', 'NO ACTION', 'CASCADE', NULL ),
( 'attivita', 'attivita_ibfk_02_nofollow', 'id_tipologia', 'tipologie_attivita', 'NO ACTION', 'CASCADE', NULL ),
( 'attivita', 'attivita_ibfk_03_nofollow', 'id_cliente', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'attivita', 'attivita_ibfk_04_nofollow', 'id_indirizzo', 'indirizzi', 'SET NULL', 'SET NULL', NULL ),
( 'attivita', 'attivita_ibfk_05_nofollow', 'id_luogo', 'luoghi', 'SET NULL', 'SET NULL', NULL ),
( 'attivita', 'attivita_ibfk_06_nofollow', 'id_oggetto', 'asset', 'SET NULL', 'SET NULL', NULL ),
( 'attivita', 'attivita_ibfk_07_nofollow', 'id_anagrafica_programmazione', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'attivita', 'attivita_ibfk_08_nofollow', 'id_anagrafica', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'attivita', 'attivita_ibfk_09_nofollow', 'id_asset', 'asset', 'SET NULL', 'SET NULL', NULL ),
( 'attivita', 'attivita_ibfk_10_nofollow', 'id_mailing', 'mailing', 'SET NULL', 'SET NULL', NULL ),
( 'attivita', 'attivita_ibfk_11_nofollow', 'id_mail', 'mail', 'SET NULL', 'SET NULL', NULL ),
( 'attivita', 'attivita_ibfk_12_nofollow', 'id_documento', 'documenti', 'SET NULL', 'SET NULL', NULL ),
( 'attivita', 'attivita_ibfk_13_nofollow', 'id_corrispondenza', 'corrispondenza', 'SET NULL', 'SET NULL', NULL ),
( 'attivita', 'attivita_ibfk_14_nofollow', 'id_pagamento', 'pagamenti', 'SET NULL', 'SET NULL', NULL ),
( 'attivita', 'attivita_ibfk_15_nofollow', 'id_progetto', 'progetti', 'SET NULL', 'SET NULL', NULL ),
( 'attivita', 'attivita_ibfk_16_nofollow', 'id_contratto', 'contratti', 'SET NULL', 'SET NULL', NULL ),
( 'attivita', 'attivita_ibfk_17_nofollow', 'id_todo', 'todo', 'SET NULL', 'SET NULL', NULL ),
( 'attivita', 'attivita_ibfk_18_nofollow', 'id_mastro_provenienza', 'mastri', 'SET NULL', 'SET NULL', NULL ),
( 'attivita', 'attivita_ibfk_19_nofollow', 'id_mastro_destinazione', 'mastri', 'SET NULL', 'SET NULL', NULL ),
( 'attivita', 'attivita_ibfk_20_nofollow', 'id_matricola', 'matricole', 'SET NULL', 'SET NULL', NULL ),
( 'attivita', 'attivita_ibfk_21_nofollow', 'id_immobile', 'immobili', 'SET NULL', 'SET NULL', NULL ),
( 'attivita', 'attivita_ibfk_22_nofollow', 'id_pianificazione', 'pianificazioni', 'SET NULL', 'SET NULL', NULL ),
( 'attivita', 'attivita_ibfk_23_nofollow', 'id_contatto', 'contatti', 'SET NULL', 'SET NULL', NULL ),
( 'attivita', 'attivita_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'attivita', 'attivita_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'audio', 'audio_ibfk_03', 'id_file', 'file', 'SET NULL', 'SET NULL', NULL ),
( 'audio', 'audio_ibfk_07', 'id_risorsa', 'risorse', 'SET NULL', 'SET NULL', NULL ),
( 'audio', 'audio_ibfk_11', 'id_annuncio', 'annunci', 'SET NULL', 'SET NULL', NULL ),
( 'audio', 'audio_ibfk_12', 'id_categoria_annunci', 'categorie_annunci', 'SET NULL', 'SET NULL', NULL ),
( 'audio', 'audio_ibfk_13_nofollow', 'id_lingua', 'lingue', 'SET NULL', 'SET NULL', NULL ),
( 'audio', 'audio_ibfk_14_nofollow', 'id_ruolo', 'ruoli_audio', 'NO ACTION', 'CASCADE', NULL ),
( 'audio', 'audio_ibfk_16', 'id_progetto', 'progetti', 'SET NULL', 'SET NULL', NULL ),
( 'audio', 'audio_ibfk_17', 'id_categoria_progetti', 'categorie_progetti', 'SET NULL', 'SET NULL', NULL ),
( 'audio', 'audio_ibfk_18', 'id_indirizzo', 'indirizzi', 'SET NULL', 'SET NULL', NULL ),
( 'audio', 'audio_ibfk_19', 'id_edificio', 'edifici', 'SET NULL', 'SET NULL', NULL ),
( 'audio', 'audio_ibfk_20', 'id_immobile', 'immobili', 'SET NULL', 'SET NULL', NULL ),
( 'caratteristiche', 'caratteristiche_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'caratteristiche', 'caratteristiche_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli', 'carrelli_ibfk_01', 'destinatario_id_anagrafica', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli', 'carrelli_ibfk_08', 'intestazione_id_anagrafica', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli', 'carrelli_ibfk_15_nofollow', 'id_listino', 'listini', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli', 'carrelli_ibfk_16_nofollow', 'id_documento', 'documenti', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli', 'carrelli_ibfk_17_nofollow', 'id_coupon', 'coupon', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli', 'carrelli_ibfk_18_nofollow', 'id_campagna', 'campagne', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli', 'carrelli_ibfk_19_nofollow', 'id_reseller', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli', 'carrelli_ibfk_20_nofollow', 'id_affiliato', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli', 'carrelli_ibfk_21_nofollow', 'intestazione_id_account', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli', 'carrelli_ibfk_22_nofollow', 'destinatario_id_account', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli', 'carrelli_ibfk_23_nofollow', 'fatturazione_id_tipologia_documento', 'tipologie_documenti', 'NO ACTION', 'CASCADE', NULL ),
( 'carrelli', 'carrelli_ibfk_25_nofollow', 'intestazione_id_tipologia_anagrafica', 'tipologie_anagrafica', 'NO ACTION', 'CASCADE', NULL ),
( 'carrelli', 'carrelli_ibfk_26_nofollow', 'destinatario_id_tipologia_anagrafica', 'tipologie_anagrafica', 'NO ACTION', 'CASCADE', NULL ),
( 'carrelli', 'carrelli_ibfk_27_nofollow', 'id_affiliazione', 'contratti', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli', 'carrelli_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli', 'carrelli_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli_articoli', 'carrelli_articoli_ibfk_01', 'id_carrello', 'carrelli', 'CASCADE', 'CASCADE', NULL ),
( 'carrelli_articoli', 'carrelli_articoli_ibfk_02_nofollow', 'id_articolo', 'articoli', 'CASCADE', 'CASCADE', NULL ),
( 'carrelli_articoli', 'carrelli_articoli_ibfk_03_nofollow', 'id_iva', 'iva', 'SET NULL', 'SET NULL', NULL );

-- | 202609301102

-- i vincoli da carrelli_articoli a documenti
INSERT IGNORE INTO `__patch_chiavi_esterne__` ( `tabella`, `vincolo`, `colonna`, `riferimento`, `cancellazione`, `aggiornamento`, `condizione` ) VALUES
( 'carrelli_articoli', 'carrelli_articoli_ibfk_04_nofollow', 'id_pagamento', 'pagamenti', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli_articoli', 'carrelli_articoli_ibfk_05', 'destinatario_id_anagrafica', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli_articoli', 'carrelli_articoli_ibfk_12_nofollow', 'id_rinnovo', 'rinnovi', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli_articoli', 'carrelli_articoli_ibfk_13_nofollow', 'id_coupon', 'coupon', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli_articoli', 'carrelli_articoli_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'carrelli_articoli', 'carrelli_articoli_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'categorie_anagrafica', 'categorie_anagrafica_ibfk_01_nofollow', 'id_genitore', 'categorie_anagrafica', 'NO ACTION', 'CASCADE', NULL ),
( 'categorie_anagrafica', 'categorie_anagrafica_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'categorie_anagrafica', 'categorie_anagrafica_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'categorie_notizie', 'categorie_notizie_ibfk_01_nofollow', 'id_genitore', 'categorie_notizie', 'NO ACTION', 'CASCADE', NULL ),
( 'categorie_notizie', 'categorie_notizie_ibfk_02_nofollow', 'id_pagina', 'pagine', 'SET NULL', 'SET NULL', NULL ),
( 'categorie_notizie', 'categorie_notizie_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'categorie_notizie', 'categorie_notizie_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'categorie_prodotti', 'categorie_prodotti_ibfk_01_nofollow', 'id_genitore', 'categorie_prodotti', 'NO ACTION', 'CASCADE', NULL ),
( 'categorie_prodotti', 'categorie_prodotti_ibfk_02_nofollow', 'id_pagina', 'pagine', 'SET NULL', 'SET NULL', NULL ),
( 'categorie_prodotti', 'categorie_prodotti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'categorie_prodotti', 'categorie_prodotti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'categorie_progetti', 'categorie_progetti_ibfk_01_nofollow', 'id_genitore', 'categorie_progetti', 'NO ACTION', 'CASCADE', NULL ),
( 'categorie_progetti', 'categorie_progetti_ibfk_02_nofollow', 'id_pagina', 'pagine', 'SET NULL', 'SET NULL', NULL ),
( 'categorie_progetti', 'categorie_progetti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'categorie_progetti', 'categorie_progetti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'colli', 'colli_ibfk_01_nofollow', 'id_documento', 'documenti', 'SET NULL', 'SET NULL', NULL ),
( 'colli', 'colli_ibfk_02_nofollow', 'id_udm_dimensioni', 'udm', 'SET NULL', 'SET NULL', NULL ),
( 'colli', 'colli_ibfk_03_nofollow', 'id_udm_peso', 'udm', 'SET NULL', 'SET NULL', NULL ),
( 'colli', 'colli_ibfk_04_nofollow', 'id_udm_volume', 'udm', 'SET NULL', 'SET NULL', NULL ),
( 'colli', 'colli_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'colli', 'colli_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'consensi', 'consensi_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'consensi', 'consensi_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'consensi_moduli', 'consensi_moduli_ibfk_01_nofollow', 'id_lingua', 'lingue', 'SET NULL', 'SET NULL', NULL ),
( 'consensi_moduli', 'consensi_moduli_ibfk_02_nofollow', 'id_consenso', 'consensi', 'SET NULL', 'SET NULL', NULL ),
( 'consensi_moduli', 'consensi_moduli_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'consensi_moduli', 'consensi_moduli_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'contatti', 'contatti_ibfk_01_nofollow', 'id_tipologia', 'tipologie_contatti', 'NO ACTION', 'CASCADE', NULL ),
( 'contatti', 'contatti_ibfk_02_nofollow', 'id_anagrafica', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'contatti', 'contatti_ibfk_03_nofollow', 'id_inviante', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'contatti', 'contatti_ibfk_04_nofollow', 'id_ranking', 'ranking', 'SET NULL', 'SET NULL', NULL ),
( 'contatti', 'contatti_ibfk_05_nofollow', 'id_campagna', 'campagne', 'SET NULL', 'SET NULL', NULL ),
( 'contatti', 'contatti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'contatti', 'contatti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_06', 'id_caratteristica', 'caratteristiche', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_07', 'id_marchio', 'marchi', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_08', 'id_file', 'file', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_09', 'id_immagine', 'immagini', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_10', 'id_video', 'video', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_11', 'id_audio', 'audio', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_12', 'id_risorsa', 'risorse', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_13', 'id_categoria_risorse', 'categorie_risorse', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_15', 'id_popup', 'popup', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_16', 'id_indirizzo', 'indirizzi', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_18', 'id_annuncio', 'annunci', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_19', 'id_categoria_notizie', 'categorie_notizie', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_20', 'id_categoria_annunci', 'categorie_annunci', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_21', 'id_template', 'template', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_22', 'id_mailing', 'mailing', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_23', 'id_colore', 'colori', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_24', 'id_progetto', 'progetti', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_25', 'id_categoria_progetti', 'categorie_progetti', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_26', 'id_edificio', 'edifici', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_27', 'id_immobile', 'immobili', 'SET NULL', 'SET NULL', NULL ),
( 'contenuti', 'contenuti_ibfk_28', 'id_banner', 'banner', 'SET NULL', 'SET NULL', NULL ),
( 'contratti', 'contratti_ibfk_01_nofollow', 'id_tipologia', 'tipologie_contratti', 'NO ACTION', 'CASCADE', NULL ),
( 'contratti', 'contratti_ibfk_04_nofollow', 'id_progetto', 'progetti', 'SET NULL', 'SET NULL', NULL ),
( 'contratti', 'contratti_ibfk_05_nofollow', 'id_categoria_progetti', 'categorie_progetti', 'SET NULL', 'SET NULL', NULL ),
( 'contratti', 'contratti_ibfk_06_nofollow', 'id_immobile', 'immobili', 'SET NULL', 'SET NULL', NULL ),
( 'contratti', 'contratti_ibfk_07_nofollow', 'id_badge', 'badge', 'SET NULL', 'SET NULL', NULL ),
( 'contratti', 'contratti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'contratti', 'contratti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'contratti_anagrafica', 'contratti_anagrafica_ibfk_01', 'id_contratto', 'contratti', 'CASCADE', 'CASCADE', NULL ),
( 'contratti_anagrafica', 'contratti_anagrafica_ibfk_02_nofollow', 'id_anagrafica', 'anagrafica', 'CASCADE', 'CASCADE', NULL ),
( 'contratti_anagrafica', 'contratti_anagrafica_ibfk_03_nofollow', 'id_ruolo', 'ruoli_anagrafica', 'NO ACTION', 'CASCADE', NULL ),
( 'contratti_anagrafica', 'contratti_anagrafica_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'contratti_anagrafica', 'contratti_anagrafica_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'corrispondenza', 'corrispondenza_ibfk_01_nofollow', 'id_tipologia', 'tipologie_corrispondenza', 'NO ACTION', 'CASCADE', NULL ),
( 'corrispondenza', 'corrispondenza_ibfk_02_nofollow', 'id_peso', 'pesi_tipologie_corrispondenza', 'SET NULL', 'SET NULL', NULL ),
( 'corrispondenza', 'corrispondenza_ibfk_04_nofollow', 'id_mittente', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'corrispondenza', 'corrispondenza_ibfk_05_nofollow', 'id_organizzazione_mittente', 'organizzazioni', 'SET NULL', 'SET NULL', NULL ),
( 'corrispondenza', 'corrispondenza_ibfk_06_nofollow', 'id_commesso', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'corrispondenza', 'corrispondenza_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'corrispondenza', 'corrispondenza_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'costi_contratti', 'costi_contratti_ibfk_01', 'id_contratto', 'contratti', 'CASCADE', 'CASCADE', NULL ),
( 'costi_contratti', 'costi_contratti_ibfk_02_nofollow', 'id_tipologia', 'tipologie_attivita_inps', 'NO ACTION', 'CASCADE', NULL ),
( 'coupon', 'coupon_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'coupon', 'coupon_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'documenti', 'documenti_ibfk_01_nofollow', 'id_tipologia', 'tipologie_documenti', 'NO ACTION', 'CASCADE', NULL ),
( 'documenti', 'documenti_ibfk_02_nofollow', 'id_emittente', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'documenti', 'documenti_ibfk_03_nofollow', 'id_sede_emittente', 'anagrafica_indirizzi', 'SET NULL', 'SET NULL', 'anagrafica_indirizzi.id_comune' ),
( 'documenti', 'documenti_ibfk_04_nofollow', 'id_destinatario', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'documenti', 'documenti_ibfk_05_nofollow', 'id_sede_destinatario', 'anagrafica_indirizzi', 'SET NULL', 'SET NULL', 'anagrafica_indirizzi.id_comune' ),
( 'documenti', 'documenti_ibfk_06_nofollow', 'id_coupon', 'coupon', 'SET NULL', 'SET NULL', NULL );

-- | 202609301103

-- i vincoli da documenti a macro
INSERT IGNORE INTO `__patch_chiavi_esterne__` ( `tabella`, `vincolo`, `colonna`, `riferimento`, `cancellazione`, `aggiornamento`, `condizione` ) VALUES
( 'documenti', 'documenti_ibfk_07_nofollow', 'id_condizione_pagamento', 'condizioni_pagamento', 'SET NULL', 'SET NULL', NULL ),
( 'documenti', 'documenti_ibfk_08_nofollow', 'id_mastro_provenienza', 'mastri', 'SET NULL', 'SET NULL', NULL ),
( 'documenti', 'documenti_ibfk_09_nofollow', 'id_mastro_destinazione', 'mastri', 'SET NULL', 'SET NULL', NULL ),
( 'documenti', 'documenti_ibfk_10_nofollow', 'id_causale', 'causali', 'SET NULL', 'SET NULL', NULL ),
( 'documenti', 'documenti_ibfk_11_nofollow', 'id_trasportatore', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'documenti', 'documenti_ibfk_12_nofollow', 'id_immobile', 'immobili', 'SET NULL', 'SET NULL', NULL ),
( 'documenti', 'documenti_ibfk_13_nofollow', 'id_pianificazione', 'pianificazioni', 'SET NULL', 'SET NULL', NULL ),
( 'documenti', 'documenti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'documenti', 'documenti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'documenti_articoli', 'documenti_articoli_ibfk_01_nofollow', 'id_genitore', 'documenti_articoli', 'NO ACTION', 'CASCADE', NULL ),
( 'documenti_articoli', 'documenti_articoli_ibfk_02_nofollow', 'id_tipologia', 'tipologie_documenti', 'NO ACTION', 'CASCADE', NULL ),
( 'documenti_articoli', 'documenti_articoli_ibfk_03_nofollow', 'id_documento', 'documenti', 'SET NULL', 'SET NULL', NULL ),
( 'documenti_articoli', 'documenti_articoli_ibfk_04_nofollow', 'id_emittente', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'documenti_articoli', 'documenti_articoli_ibfk_05_nofollow', 'id_destinatario', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'documenti_articoli', 'documenti_articoli_ibfk_06_nofollow', 'id_reparto', 'reparti', 'SET NULL', 'SET NULL', NULL ),
( 'documenti_articoli', 'documenti_articoli_ibfk_07_nofollow', 'id_progetto', 'progetti', 'SET NULL', 'SET NULL', NULL ),
( 'documenti_articoli', 'documenti_articoli_ibfk_08_nofollow', 'id_todo', 'todo', 'SET NULL', 'SET NULL', NULL ),
( 'documenti_articoli', 'documenti_articoli_ibfk_09_nofollow', 'id_attivita', 'attivita', 'SET NULL', 'SET NULL', NULL ),
( 'documenti_articoli', 'documenti_articoli_ibfk_10_nofollow', 'id_articolo', 'articoli', 'SET NULL', 'SET NULL', NULL ),
( 'documenti_articoli', 'documenti_articoli_ibfk_11_nofollow', 'id_mastro_provenienza', 'mastri', 'SET NULL', 'SET NULL', NULL ),
( 'documenti_articoli', 'documenti_articoli_ibfk_12_nofollow', 'id_mastro_destinazione', 'mastri', 'SET NULL', 'SET NULL', NULL ),
( 'documenti_articoli', 'documenti_articoli_ibfk_13_nofollow', 'id_udm', 'udm', 'SET NULL', 'SET NULL', NULL ),
( 'documenti_articoli', 'documenti_articoli_ibfk_14_nofollow', 'id_listino', 'listini', 'SET NULL', 'SET NULL', NULL ),
( 'documenti_articoli', 'documenti_articoli_ibfk_15_nofollow', 'id_matricola', 'matricole', 'SET NULL', 'SET NULL', NULL ),
( 'documenti_articoli', 'documenti_articoli_ibfk_16_nofollow', 'id_rinnovo', 'rinnovi', 'SET NULL', 'SET NULL', NULL ),
( 'documenti_articoli', 'documenti_articoli_ibfk_17_nofollow', 'id_collo', 'colli', 'SET NULL', 'SET NULL', NULL ),
( 'documenti_articoli', 'documenti_articoli_ibfk_18_nofollow', 'id_prodotto', 'prodotti', 'SET NULL', 'SET NULL', NULL ),
( 'documenti_articoli', 'documenti_articoli_ibfk_19_nofollow', 'id_pianificazione', 'pianificazioni', 'SET NULL', 'SET NULL', NULL ),
( 'documenti_articoli', 'documenti_articoli_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'documenti_articoli', 'documenti_articoli_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_01_nofollow', 'id_ruolo', 'ruoli_file', 'NO ACTION', 'CASCADE', NULL ),
( 'file', 'file_ibfk_06', 'id_todo', 'todo', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_09', 'id_mailing', 'mailing', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_11', 'id_annuncio', 'annunci', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_13', 'id_categoria_annunci', 'categorie_annunci', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_14', 'id_risorsa', 'risorse', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_15', 'id_categoria_risorse', 'categorie_risorse', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_19', 'id_progetto', 'progetti', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_20', 'id_categoria_progetti', 'categorie_progetti', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_21', 'id_documento', 'documenti', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_22', 'id_indirizzo', 'indirizzi', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_23', 'id_edificio', 'edifici', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_24', 'id_immobile', 'immobili', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_25', 'id_contratto', 'contratti', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_26', 'id_valutazione', 'valutazioni', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_27', 'id_rinnovo', 'rinnovi', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_28', 'id_anagrafica_certificazioni', 'anagrafica_certificazioni', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_29', 'id_valutazione_certificazioni', 'valutazioni_certificazioni', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_30', 'id_licenza', 'licenze', 'SET NULL', 'SET NULL', NULL ),
( 'file', 'file_ibfk_31', 'id_attivita', 'attivita', 'SET NULL', 'SET NULL', NULL ),
( 'gruppi', 'gruppi_ibfk_01_nofollow', 'id_genitore', 'gruppi', 'NO ACTION', 'CASCADE', NULL ),
( 'gruppi', 'gruppi_ibfk_02', 'id_organizzazione', 'organizzazioni', 'SET NULL', 'SET NULL', NULL ),
( 'gruppi', 'gruppi_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'gruppi', 'gruppi_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'iban', 'iban_ibfk_01', 'id_anagrafica', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'iban', 'iban_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'iban', 'iban_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'immagini', 'immagini_ibfk_07', 'id_risorsa', 'risorse', 'SET NULL', 'SET NULL', NULL ),
( 'immagini', 'immagini_ibfk_08', 'id_categoria_risorse', 'categorie_risorse', 'SET NULL', 'SET NULL', NULL ),
( 'immagini', 'immagini_ibfk_10', 'id_annuncio', 'annunci', 'SET NULL', 'SET NULL', NULL ),
( 'immagini', 'immagini_ibfk_11', 'id_categoria_notizie', 'categorie_notizie', 'SET NULL', 'SET NULL', NULL ),
( 'immagini', 'immagini_ibfk_12', 'id_categoria_annunci', 'categorie_annunci', 'SET NULL', 'SET NULL', NULL ),
( 'immagini', 'immagini_ibfk_13', 'id_indirizzo', 'indirizzi', 'SET NULL', 'SET NULL', NULL ),
( 'immagini', 'immagini_ibfk_14_nofollow', 'id_lingua', 'lingue', 'SET NULL', 'SET NULL', NULL ),
( 'immagini', 'immagini_ibfk_15_nofollow', 'id_ruolo', 'ruoli_immagini', 'NO ACTION', 'CASCADE', NULL ),
( 'immagini', 'immagini_ibfk_16', 'id_progetto', 'progetti', 'SET NULL', 'SET NULL', NULL ),
( 'immagini', 'immagini_ibfk_17', 'id_categoria_progetti', 'categorie_progetti', 'SET NULL', 'SET NULL', NULL ),
( 'immagini', 'immagini_ibfk_18', 'id_edificio', 'edifici', 'SET NULL', 'SET NULL', NULL ),
( 'immagini', 'immagini_ibfk_19', 'id_immobile', 'immobili', 'SET NULL', 'SET NULL', NULL ),
( 'immagini', 'immagini_ibfk_20', 'id_contratto', 'contratti', 'SET NULL', 'SET NULL', NULL ),
( 'immagini', 'immagini_ibfk_21', 'id_valutazione', 'valutazioni', 'SET NULL', 'SET NULL', NULL ),
( 'immagini', 'immagini_ibfk_22', 'id_rinnovo', 'rinnovi', 'SET NULL', 'SET NULL', NULL ),
( 'immagini', 'immagini_ibfk_23', 'id_banner', 'banner', 'SET NULL', 'SET NULL', NULL ),
( 'indirizzi', 'indirizzi_ibfk_01_nofollow', 'id_tipologia', 'tipologie_indirizzi', 'NO ACTION', 'CASCADE', NULL ),
( 'indirizzi', 'indirizzi_ibfk_03_nofollow', 'id_zona', 'zone', 'SET NULL', 'SET NULL', NULL ),
( 'indirizzi', 'indirizzi_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'indirizzi', 'indirizzi_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'istruzioni', 'istruzioni_ibfk_02', 'id_prodotto', 'prodotti', 'SET NULL', 'SET NULL', NULL ),
( 'istruzioni', 'istruzioni_ibfk_03', 'id_articolo', 'articoli', 'CASCADE', 'CASCADE', NULL ),
( 'istruzioni', 'istruzioni_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'istruzioni', 'istruzioni_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'licenze', 'licenze_ibfk_01_nofollow', 'id_tipologia', 'tipologie_licenze', 'NO ACTION', 'CASCADE', NULL ),
( 'licenze', 'licenze_ibfk_02_nofollow', 'id_anagrafica', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'licenze', 'licenze_ibfk_03_nofollow', 'id_rivenditore', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'licenze', 'licenze_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'licenze', 'licenze_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'listini', 'listini_ibfk_01_nofollow', 'id_valuta', 'valute', 'SET NULL', 'SET NULL', NULL ),
( 'listini', 'listini_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'listini', 'listini_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'macro', 'macro_ibfk_01', 'id_pagina', 'pagine', 'SET NULL', 'SET NULL', NULL );

-- | 202609301104

-- i vincoli da macro a pagamenti
INSERT IGNORE INTO `__patch_chiavi_esterne__` ( `tabella`, `vincolo`, `colonna`, `riferimento`, `cancellazione`, `aggiornamento`, `condizione` ) VALUES
( 'macro', 'macro_ibfk_02', 'id_prodotto', 'prodotti', 'SET NULL', 'SET NULL', NULL ),
( 'macro', 'macro_ibfk_03', 'id_articolo', 'articoli', 'SET NULL', 'SET NULL', NULL ),
( 'macro', 'macro_ibfk_04', 'id_categoria_prodotti', 'categorie_prodotti', 'SET NULL', 'SET NULL', NULL ),
( 'macro', 'macro_ibfk_05', 'id_notizia', 'notizie', 'SET NULL', 'SET NULL', NULL ),
( 'macro', 'macro_ibfk_06', 'id_annuncio', 'annunci', 'SET NULL', 'SET NULL', NULL ),
( 'macro', 'macro_ibfk_07', 'id_categoria_notizie', 'categorie_notizie', 'SET NULL', 'SET NULL', NULL ),
( 'macro', 'macro_ibfk_08', 'id_categoria_annunci', 'categorie_annunci', 'SET NULL', 'SET NULL', NULL ),
( 'macro', 'macro_ibfk_09', 'id_risorsa', 'risorse', 'SET NULL', 'SET NULL', NULL ),
( 'macro', 'macro_ibfk_10', 'id_categoria_risorse', 'categorie_risorse', 'SET NULL', 'SET NULL', NULL ),
( 'macro', 'macro_ibfk_11', 'id_progetto', 'progetti', 'SET NULL', 'SET NULL', NULL ),
( 'macro', 'macro_ibfk_12', 'id_categoria_progetti', 'categorie_progetti', 'SET NULL', 'SET NULL', NULL ),
( 'macro', 'macro_ibfk_13', 'id_pianificazione', 'pianificazioni', 'SET NULL', 'SET NULL', NULL ),
( 'macro', 'macro_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'macro', 'macro_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'mail_out', 'mail_out_ibfk_01_nofollow', 'id_mail', 'mail', 'SET NULL', 'SET NULL', NULL ),
( 'mail_out', 'mail_out_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'mail_out', 'mail_out_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'mail_sent', 'mail_sent_ibfk_01_nofollow', 'id_mail', 'mail', 'SET NULL', 'SET NULL', NULL ),
( 'mail_sent', 'mail_sent_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'mail_sent', 'mail_sent_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'marchi', 'marchi_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'marchi', 'marchi_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'mastri', 'mastri_ibfk_01_nofollow', 'id_genitore', 'mastri', 'NO ACTION', 'CASCADE', NULL ),
( 'mastri', 'mastri_ibfk_02_nofollow', 'id_tipologia', 'tipologie_mastri', 'NO ACTION', 'CASCADE', NULL ),
( 'mastri', 'mastri_ibfk_03_nofollow', 'id_anagrafica_indirizzi', 'anagrafica_indirizzi', 'SET NULL', 'SET NULL', NULL ),
( 'mastri', 'mastri_ibfk_04_nofollow', 'id_anagrafica', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'mastri', 'mastri_ibfk_05_nofollow', 'id_account', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'mastri', 'mastri_ibfk_06_nofollow', 'id_progetto', 'progetti', 'SET NULL', 'SET NULL', NULL ),
( 'mastri', 'mastri_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'mastri', 'mastri_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'matricole', 'matricole_ibfk_01_nofollow', 'id_marchio', 'marchi', 'SET NULL', 'SET NULL', NULL ),
( 'matricole', 'matricole_ibfk_02_nofollow', 'id_produttore', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'matricole', 'matricole_ibfk_03_nofollow', 'id_articolo', 'articoli', 'SET NULL', 'SET NULL', NULL ),
( 'matricole', 'matricole_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'matricole', 'matricole_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'menu', 'menu_ibfk_05', 'id_categoria_risorse', 'categorie_risorse', 'SET NULL', 'SET NULL', NULL ),
( 'menu', 'menu_ibfk_06', 'id_categoria_progetti', 'categorie_progetti', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_02', 'id_pagina', 'pagine', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_03', 'id_categoria_prodotti', 'categorie_prodotti', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_05', 'id_categoria_risorse', 'categorie_risorse', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_06', 'id_categoria_progetti', 'categorie_progetti', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_09', 'id_anagrafica', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_10', 'id_account', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_11', 'id_prodotto', 'prodotti', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_12', 'id_annuncio', 'annunci', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_13', 'id_categoria_annunci', 'categorie_annunci', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_14', 'id_risorsa', 'risorse', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_15', 'id_immagine', 'immagini', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_16', 'id_video', 'video', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_17', 'id_audio', 'audio', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_18', 'id_file', 'file', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_19', 'id_documento', 'documenti', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_20', 'id_documenti_articoli', 'documenti_articoli', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_21', 'id_progetto', 'progetti', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_22', 'id_indirizzo', 'indirizzi', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_23', 'id_edificio', 'edifici', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_24', 'id_immobile', 'immobili', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_25', 'id_contratto', 'contratti', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_26', 'id_valutazione', 'valutazioni', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_27', 'id_rinnovo', 'rinnovi', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_28', 'id_attivita', 'attivita', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_29', 'id_tipologia_attivita', 'tipologie_attivita', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_30', 'id_banner', 'banner', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_31', 'id_pianificazione', 'pianificazioni', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_32', 'id_todo', 'todo', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_33', 'id_tipologia_todo', 'tipologie_todo', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_34', 'id_tipologia_contratti', 'tipologie_contratti', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_35', 'id_carrello', 'carrelli', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_36', 'id_tipologia_corrispondenza', 'tipologie_corrispondenza', 'SET NULL', 'SET NULL', NULL ),
( 'metadati', 'metadati_ibfk_37', 'id_peso_tipologie_corrispondenza', 'pesi_tipologie_corrispondenza', 'SET NULL', 'SET NULL', NULL ),
( 'notizie', 'notizie_ibfk_01_nofollow', 'id_tipologia', 'tipologie_notizie', 'NO ACTION', 'CASCADE', NULL ),
( 'notizie', 'notizie_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'notizie', 'notizie_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'notizie_categorie', 'notizie_categorie_ibfk_01', 'id_notizia', 'notizie', 'CASCADE', 'CASCADE', NULL ),
( 'notizie_categorie', 'notizie_categorie_ibfk_02_nofollow', 'id_categoria', 'categorie_notizie', 'CASCADE', 'CASCADE', NULL ),
( 'notizie_categorie', 'notizie_categorie_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'notizie_categorie', 'notizie_categorie_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'orari_contratti', 'orari_contratti_ibfk_01', 'id_contratto', 'contratti', 'CASCADE', 'CASCADE', NULL ),
( 'orari_contratti', 'orari_contratti_ibfk_02_nofollow', 'id_costo', 'costi_contratti', 'CASCADE', 'CASCADE', NULL ),
( 'organizzazioni', 'organizzazioni_ibfk_01_nofollow', 'id_genitore', 'organizzazioni', 'NO ACTION', 'CASCADE', NULL ),
( 'organizzazioni', 'organizzazioni_ibfk_02', 'id_anagrafica', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'organizzazioni', 'organizzazioni_ibfk_03_nofollow', 'id_ruolo', 'ruoli_anagrafica', 'NO ACTION', 'CASCADE', NULL ),
( 'organizzazioni', 'organizzazioni_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'organizzazioni', 'organizzazioni_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'pagamenti', 'pagamenti_ibfk_01_nofollow', 'id_tipologia', 'tipologie_pagamenti', 'NO ACTION', 'CASCADE', NULL ),
( 'pagamenti', 'pagamenti_ibfk_02', 'id_documento', 'documenti', 'SET NULL', 'SET NULL', NULL ),
( 'pagamenti', 'pagamenti_ibfk_03_nofollow', 'id_carrelli_articoli', 'carrelli_articoli', 'SET NULL', 'SET NULL', NULL ),
( 'pagamenti', 'pagamenti_ibfk_04_nofollow', 'id_creditore', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'pagamenti', 'pagamenti_ibfk_05_nofollow', 'id_debitore', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'pagamenti', 'pagamenti_ibfk_06_nofollow', 'id_mastro_provenienza', 'mastri', 'SET NULL', 'SET NULL', NULL );

-- | 202609301105

-- i vincoli da pagamenti a tipologie_attivita
INSERT IGNORE INTO `__patch_chiavi_esterne__` ( `tabella`, `vincolo`, `colonna`, `riferimento`, `cancellazione`, `aggiornamento`, `condizione` ) VALUES
( 'pagamenti', 'pagamenti_ibfk_07_nofollow', 'id_mastro_destinazione', 'mastri', 'SET NULL', 'SET NULL', NULL ),
( 'pagamenti', 'pagamenti_ibfk_08_nofollow', 'id_iban', 'iban', 'SET NULL', 'SET NULL', NULL ),
( 'pagamenti', 'pagamenti_ibfk_09_nofollow', 'id_listino', 'listini', 'SET NULL', 'SET NULL', NULL ),
( 'pagamenti', 'pagamenti_ibfk_10_nofollow', 'id_modalita_pagamento', 'modalita_pagamento', 'SET NULL', 'SET NULL', NULL ),
( 'pagamenti', 'pagamenti_ibfk_11_nofollow', 'id_pianificazione', 'pianificazioni', 'SET NULL', 'SET NULL', NULL ),
( 'pagamenti', 'pagamenti_ibfk_12_nofollow', 'id_coupon', 'coupon', 'SET NULL', 'SET NULL', NULL ),
( 'pagamenti', 'pagamenti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'pagamenti', 'pagamenti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'prodotti', 'prodotti_ibfk_03_nofollow', 'id_produttore', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'prodotti', 'prodotti_ibfk_04_nofollow', 'id_tipologia', 'tipologie_prodotti', 'NO ACTION', 'CASCADE', NULL ),
( 'prodotti_caratteristiche', 'prodotti_caratteristiche_ibfk_01', 'id_prodotto', 'prodotti', 'CASCADE', 'CASCADE', NULL ),
( 'prodotti_caratteristiche', 'prodotti_caratteristiche_ibfk_02_nofollow', 'id_caratteristica', 'caratteristiche', 'CASCADE', 'CASCADE', NULL ),
( 'prodotti_caratteristiche', 'prodotti_caratteristiche_ibfk_03_nofollow', 'id_lingua', 'lingue', 'SET NULL', 'SET NULL', NULL ),
( 'prodotti_caratteristiche', 'prodotti_caratteristiche_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'prodotti_caratteristiche', 'prodotti_caratteristiche_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'prodotti_categorie', 'prodotti_categorie_ibfk_03_nofollow', 'id_ruolo', 'ruoli_prodotti', 'NO ACTION', 'CASCADE', NULL ),
( 'progetti', 'progetti_ibfk_01_nofollow', 'id_tipologia', 'tipologie_progetti', 'NO ACTION', 'CASCADE', NULL ),
( 'progetti', 'progetti_ibfk_02_nofollow', 'id_pianificazione', 'pianificazioni', 'SET NULL', 'SET NULL', NULL ),
( 'progetti', 'progetti_ibfk_03_nofollow', 'id_cliente', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'progetti', 'progetti_ibfk_04_nofollow', 'id_indirizzo', 'indirizzi', 'SET NULL', 'SET NULL', NULL ),
( 'progetti', 'progetti_ibfk_05_nofollow', 'id_ranking', 'ranking', 'SET NULL', 'SET NULL', NULL ),
( 'progetti', 'progetti_ibfk_06_nofollow', 'id_articolo', 'articoli', 'SET NULL', 'SET NULL', NULL ),
( 'progetti', 'progetti_ibfk_07_nofollow', 'id_prodotto', 'prodotti', 'SET NULL', 'SET NULL', NULL ),
( 'progetti', 'progetti_ibfk_08_nofollow', 'id_periodo', 'periodi', 'SET NULL', 'SET NULL', NULL ),
( 'progetti', 'progetti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'progetti', 'progetti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'progetti_categorie', 'progetti_categorie_ibfk_01', 'id_progetto', 'progetti', 'CASCADE', 'CASCADE', NULL ),
( 'progetti_categorie', 'progetti_categorie_ibfk_02_nofollow', 'id_categoria', 'categorie_progetti', 'CASCADE', 'CASCADE', NULL ),
( 'progetti_categorie', 'progetti_categorie_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'progetti_categorie', 'progetti_categorie_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'pubblicazioni', 'pubblicazioni_ibfk_03', 'id_popup', 'popup', 'SET NULL', 'SET NULL', NULL ),
( 'pubblicazioni', 'pubblicazioni_ibfk_08', 'id_annuncio', 'annunci', 'SET NULL', 'SET NULL', NULL ),
( 'pubblicazioni', 'pubblicazioni_ibfk_10', 'id_categoria_annunci', 'categorie_annunci', 'SET NULL', 'SET NULL', NULL ),
( 'pubblicazioni', 'pubblicazioni_ibfk_11', 'id_risorsa', 'risorse', 'SET NULL', 'SET NULL', NULL ),
( 'pubblicazioni', 'pubblicazioni_ibfk_12', 'id_categoria_risorse', 'categorie_risorse', 'SET NULL', 'SET NULL', NULL ),
( 'pubblicazioni', 'pubblicazioni_ibfk_13', 'id_progetto', 'progetti', 'SET NULL', 'SET NULL', NULL ),
( 'pubblicazioni', 'pubblicazioni_ibfk_14', 'id_categoria_progetti', 'categorie_progetti', 'SET NULL', 'SET NULL', NULL ),
( 'pubblicazioni', 'pubblicazioni_ibfk_15', 'id_banner', 'banner', 'SET NULL', 'SET NULL', NULL ),
( 'ranking', 'ranking_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'ranking', 'ranking_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'redirect', 'redirect_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'redirect', 'redirect_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'relazioni_anagrafica', 'relazioni_anagrafica_ibfk_01', 'id_anagrafica', 'anagrafica', 'CASCADE', 'CASCADE', NULL ),
( 'relazioni_anagrafica', 'relazioni_anagrafica_ibfk_02', 'id_anagrafica_collegata', 'anagrafica', 'CASCADE', 'CASCADE', NULL ),
( 'relazioni_anagrafica', 'relazioni_anagrafica_ibfk_03_nofollow', 'id_ruolo', 'ruoli_anagrafica', 'NO ACTION', 'CASCADE', NULL ),
( 'relazioni_anagrafica', 'relazioni_anagrafica_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'relazioni_anagrafica', 'relazioni_anagrafica_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'relazioni_documenti', 'relazioni_documenti_ibfk_01', 'id_documento', 'documenti', 'CASCADE', 'CASCADE', NULL ),
( 'relazioni_documenti', 'relazioni_documenti_ibfk_02', 'id_documento_collegato', 'documenti', 'CASCADE', 'CASCADE', NULL ),
( 'relazioni_documenti', 'relazioni_documenti_ibfk_03_nofollow', 'id_ruolo', 'ruoli_documenti', 'NO ACTION', 'CASCADE', NULL ),
( 'relazioni_documenti', 'relazioni_documenti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'relazioni_documenti', 'relazioni_documenti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'reparti', 'reparti_ibfk_01_nofollow', 'id_iva', 'iva', 'SET NULL', 'SET NULL', NULL ),
( 'reparti', 'reparti_ibfk_02_nofollow', 'id_settore', 'settori', 'SET NULL', 'SET NULL', NULL ),
( 'reparti', 'reparti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'reparti', 'reparti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'rinnovi', 'rinnovi_ibfk_01', 'id_contratto', 'contratti', 'SET NULL', 'SET NULL', NULL ),
( 'rinnovi', 'rinnovi_ibfk_02', 'id_licenza', 'licenze', 'SET NULL', 'SET NULL', NULL ),
( 'rinnovi', 'rinnovi_ibfk_03', 'id_progetto', 'progetti', 'SET NULL', 'SET NULL', NULL ),
( 'rinnovi', 'rinnovi_ibfk_04_nofollow', 'id_tipologia_contratto', 'tipologie_contratti', 'NO ACTION', 'CASCADE', NULL ),
( 'rinnovi', 'rinnovi_ibfk_05_nofollow', 'id_categoria_progetti', 'categorie_progetti', 'SET NULL', 'SET NULL', NULL ),
( 'rinnovi', 'rinnovi_ibfk_06_nofollow', 'id_tipologia', 'tipologie_rinnovi', 'NO ACTION', 'CASCADE', NULL ),
( 'rinnovi', 'rinnovi_ibfk_07_nofollow', 'id_periodicita', 'periodicita', 'SET NULL', 'SET NULL', NULL ),
( 'rinnovi', 'rinnovi_ibfk_08_nofollow', 'id_pianificazione', 'pianificazioni', 'SET NULL', 'SET NULL', NULL ),
( 'rinnovi', 'rinnovi_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'rinnovi', 'rinnovi_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'ruoli_anagrafica', 'ruoli_anagrafica_ibfk_01_nofollow', 'id_genitore', 'ruoli_anagrafica', 'NO ACTION', 'CASCADE', NULL ),
( 'ruoli_audio', 'ruoli_audio_ibfk_01_nofollow', 'id_genitore', 'ruoli_audio', 'NO ACTION', 'CASCADE', NULL ),
( 'ruoli_documenti', 'ruoli_documenti_ibfk_01_nofollow', 'id_genitore', 'ruoli_documenti', 'NO ACTION', 'CASCADE', NULL ),
( 'ruoli_file', 'ruoli_file_ibfk_01_nofollow', 'id_genitore', 'ruoli_file', 'NO ACTION', 'CASCADE', NULL ),
( 'ruoli_immagini', 'ruoli_immagini_ibfk_01_nofollow', 'id_genitore', 'ruoli_immagini', 'NO ACTION', 'CASCADE', NULL ),
( 'ruoli_indirizzi', 'ruoli_indirizzi_ibfk_01_nofollow', 'id_genitore', 'ruoli_indirizzi', 'NO ACTION', 'CASCADE', NULL ),
( 'ruoli_prodotti', 'ruoli_prodotti_ibfk_01_nofollow', 'id_genitore', 'ruoli_prodotti', 'NO ACTION', 'CASCADE', NULL ),
( 'ruoli_video', 'ruoli_video_ibfk_01_nofollow', 'id_genitore', 'ruoli_video', 'NO ACTION', 'CASCADE', NULL ),
( 'settori', 'settori_ibfk_01_nofollow', 'id_genitore', 'settori', 'NO ACTION', 'CASCADE', NULL ),
( 'sms_out', 'sms_out_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'sms_out', 'sms_out_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'sms_sent', 'sms_sent_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'sms_sent', 'sms_sent_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'stati', 'stati_ibfk_01_nofollow', 'id_continente', 'continenti', 'SET NULL', 'SET NULL', NULL ),
( 'task', 'task_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'task', 'task_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'template', 'template_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'template', 'template_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_anagrafica', 'tipologie_anagrafica_ibfk_01_nofollow', 'id_genitore', 'tipologie_anagrafica', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_anagrafica', 'tipologie_anagrafica_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_anagrafica', 'tipologie_anagrafica_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_attivita', 'tipologie_attivita_ibfk_01_nofollow', 'id_genitore', 'tipologie_attivita', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_attivita', 'tipologie_attivita_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_attivita', 'tipologie_attivita_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL );

-- | 202609301106

-- i vincoli da tipologie_attivita_inps a video
INSERT IGNORE INTO `__patch_chiavi_esterne__` ( `tabella`, `vincolo`, `colonna`, `riferimento`, `cancellazione`, `aggiornamento`, `condizione` ) VALUES
( 'tipologie_attivita_inps', 'tipologie_attivita_inps_ibfk_01_nofollow', 'id_genitore', 'tipologie_attivita_inps', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_contatti', 'tipologie_contatti_ibfk_01_nofollow', 'id_genitore', 'tipologie_contatti', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_contatti', 'tipologie_contatti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_contatti', 'tipologie_contatti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_contratti', 'tipologie_contratti_ibfk_01_nofollow', 'id_genitore', 'tipologie_contratti', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_contratti', 'tipologie_contratti_ibfk_02_nofollow', 'id_prodotto', 'prodotti', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_contratti', 'tipologie_contratti_ibfk_03_nofollow', 'id_progetto', 'progetti', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_contratti', 'tipologie_contratti_ibfk_04_nofollow', 'id_categoria_progetti', 'categorie_progetti', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_contratti', 'tipologie_contratti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_contratti', 'tipologie_contratti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_corrispondenza', 'tipologie_corrispondenza_ibfk_01_nofollow', 'id_genitore', 'tipologie_corrispondenza', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_corrispondenza', 'tipologie_corrispondenza_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_corrispondenza', 'tipologie_corrispondenza_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_documenti', 'tipologie_documenti_ibfk_01_nofollow', 'id_genitore', 'tipologie_documenti', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_documenti', 'tipologie_documenti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_documenti', 'tipologie_documenti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_indirizzi', 'tipologie_indirizzi_ibfk_01_nofollow', 'id_genitore', 'tipologie_indirizzi', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_indirizzi', 'tipologie_indirizzi_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_indirizzi', 'tipologie_indirizzi_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_notizie', 'tipologie_notizie_ibfk_01_nofollow', 'id_genitore', 'tipologie_notizie', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_notizie', 'tipologie_notizie_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_notizie', 'tipologie_notizie_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_pagamenti', 'tipologie_pagamenti_ibfk_01_nofollow', 'id_genitore', 'tipologie_pagamenti', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_pagamenti', 'tipologie_pagamenti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_pagamenti', 'tipologie_pagamenti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_prodotti', 'tipologie_prodotti_ibfk_01_nofollow', 'id_genitore', 'tipologie_prodotti', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_prodotti', 'tipologie_prodotti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_prodotti', 'tipologie_prodotti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_progetti', 'tipologie_progetti_ibfk_01_nofollow', 'id_genitore', 'tipologie_progetti', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_progetti', 'tipologie_progetti_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_progetti', 'tipologie_progetti_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_pubblicazioni', 'tipologie_pubblicazioni_ibfk_01_nofollow', 'id_genitore', 'tipologie_pubblicazioni', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_pubblicazioni', 'tipologie_pubblicazioni_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_pubblicazioni', 'tipologie_pubblicazioni_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_todo', 'tipologie_todo_ibfk_01_nofollow', 'id_genitore', 'tipologie_todo', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_todo', 'tipologie_todo_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_todo', 'tipologie_todo_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_url', 'tipologie_url_ibfk_01_nofollow', 'id_genitore', 'tipologie_url', 'NO ACTION', 'CASCADE', NULL ),
( 'tipologie_url', 'tipologie_url_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'tipologie_url', 'tipologie_url_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'todo', 'todo_ibfk_01_nofollow', 'id_tipologia', 'tipologie_todo', 'NO ACTION', 'CASCADE', NULL ),
( 'todo', 'todo_ibfk_02_nofollow', 'id_anagrafica', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'todo', 'todo_ibfk_03_nofollow', 'id_cliente', 'anagrafica', 'SET NULL', 'SET NULL', NULL ),
( 'todo', 'todo_ibfk_04_nofollow', 'id_indirizzo', 'indirizzi', 'SET NULL', 'SET NULL', NULL ),
( 'todo', 'todo_ibfk_05_nofollow', 'id_luogo', 'luoghi', 'SET NULL', 'SET NULL', NULL ),
( 'todo', 'todo_ibfk_06_nofollow', 'id_contatto', 'contatti', 'SET NULL', 'SET NULL', NULL ),
( 'todo', 'todo_ibfk_07_nofollow', 'id_progetto', 'progetti', 'SET NULL', 'SET NULL', NULL ),
( 'todo', 'todo_ibfk_08_nofollow', 'id_documento', 'documenti', 'SET NULL', 'SET NULL', NULL ),
( 'todo', 'todo_ibfk_09_nofollow', 'id_documenti_articoli', 'documenti_articoli', 'SET NULL', 'SET NULL', NULL ),
( 'todo', 'todo_ibfk_10_nofollow', 'id_istruzione', 'istruzioni', 'SET NULL', 'SET NULL', NULL ),
( 'todo', 'todo_ibfk_11_nofollow', 'id_pianificazione', 'pianificazioni', 'SET NULL', 'SET NULL', NULL ),
( 'todo', 'todo_ibfk_12_nofollow', 'id_immobile', 'immobili', 'SET NULL', 'SET NULL', NULL ),
( 'todo', 'todo_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'todo', 'todo_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', NULL ),
( 'udm', 'udm_ibfk_01_nofollow', 'id_base', 'udm', 'SET NULL', 'SET NULL', NULL ),
( 'video', 'video_ibfk_03', 'id_file', 'file', 'SET NULL', 'SET NULL', NULL ),
( 'video', 'video_ibfk_07', 'id_risorsa', 'risorse', 'SET NULL', 'SET NULL', NULL ),
( 'video', 'video_ibfk_08', 'id_categoria_risorse', 'categorie_risorse', 'SET NULL', 'SET NULL', NULL ),
( 'video', 'video_ibfk_11', 'id_annuncio', 'annunci', 'SET NULL', 'SET NULL', NULL ),
( 'video', 'video_ibfk_12', 'id_categoria_annunci', 'categorie_annunci', 'SET NULL', 'SET NULL', NULL ),
( 'video', 'video_ibfk_13_nofollow', 'id_lingua', 'lingue', 'SET NULL', 'SET NULL', NULL ),
( 'video', 'video_ibfk_14_nofollow', 'id_ruolo', 'ruoli_video', 'NO ACTION', 'CASCADE', NULL ),
( 'video', 'video_ibfk_16', 'id_progetto', 'progetti', 'SET NULL', 'SET NULL', NULL ),
( 'video', 'video_ibfk_17', 'id_categoria_progetti', 'categorie_progetti', 'SET NULL', 'SET NULL', NULL ),
( 'video', 'video_ibfk_18', 'id_indirizzo', 'indirizzi', 'SET NULL', 'SET NULL', NULL ),
( 'video', 'video_ibfk_19', 'id_edificio', 'edifici', 'SET NULL', 'SET NULL', NULL ),
( 'video', 'video_ibfk_20', 'id_immobile', 'immobili', 'SET NULL', 'SET NULL', NULL ),
( 'video', 'video_ibfk_21', 'id_valutazione', 'valutazioni', 'SET NULL', 'SET NULL', NULL );

-- | 202609301107

-- i vincoli presenti da correggere, perche' violano il canone: si correggono solo dove sono ancora quelli di prima
INSERT IGNORE INTO `__patch_chiavi_esterne__` ( `tabella`, `vincolo`, `colonna`, `riferimento`, `cancellazione`, `aggiornamento`, `vecchio_nome`, `vecchia_cancellazione`, `vecchio_aggiornamento` ) VALUES
( 'account_gruppi', 'account_gruppi_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL', 'account_gruppi_ibfk_98_nofollow', 'CASCADE', 'CASCADE' ),
( 'account_gruppi', 'account_gruppi_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL', 'account_gruppi_ibfk_99_nofollow', 'CASCADE', 'CASCADE' ),
( 'annunci', 'annunci_ibfk_01_nofollow', 'id_tipologia', 'tipologie_annunci', 'NO ACTION', 'CASCADE', 'annunci_ibfk_01_nofollow', 'NO ACTION', 'NO ACTION' ),
( 'notizie_anagrafica', 'notizie_anagrafica_ibfk_03_nofollow', 'id_ruolo', 'ruoli_anagrafica', 'NO ACTION', 'CASCADE', 'notizie_anagrafica_ibfk_03_nofollow', 'SET NULL', 'SET NULL' ),
( 'pesi_tipologie_corrispondenza', 'pesi_tipologie_corrispondenza_ibfk_01_nofollow', 'id_tipologia', 'tipologie_corrispondenza', 'NO ACTION', 'CASCADE', 'pesi_tipologie_corrispondenza_ibfk_01_nofollow', 'NO ACTION', 'NO ACTION' ),
( 'url', 'url_ibfk_01_nofollow', 'id_tipologia', 'tipologie_url', 'NO ACTION', 'CASCADE', 'url_ibfk_01_nofollow', 'CASCADE', 'CASCADE' ),
( 'url', 'url_ibfk_02', 'id_anagrafica', 'anagrafica', 'CASCADE', 'CASCADE', 'url_ibfk_02       ', 'CASCADE', 'CASCADE' );

-- | 202609301108

-- la procedura che scorre la lista e aggiunge i vincoli che si possono aggiungere
CREATE OR REPLACE PROCEDURE `__patch_chiavi_esterne__`()
BEGIN

    DECLARE fine INT DEFAULT 0;
    DECLARE errore INT DEFAULT 0;
    DECLARE messaggio TEXT DEFAULT NULL;
    DECLARE v_tabella, v_vincolo, v_colonna, v_riferimento CHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci;
    DECLARE v_cancellazione, v_aggiornamento CHAR(16) CHARACTER SET utf8 COLLATE utf8_general_ci;
    DECLARE v_condizione CHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci;
    DECLARE v_tipo_figlia, v_tipo_padre, v_nullabile CHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci;
    DECLARE v_esito CHAR(255) CHARACTER SET utf8 COLLATE utf8_general_ci;
    DECLARE v_indice TEXT DEFAULT NULL;
    DECLARE v_vecchio_nome VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci;
    DECLARE v_vecchia_cancellazione, v_vecchio_aggiornamento CHAR(16) CHARACTER SET utf8 COLLATE utf8_general_ci;
    DECLARE v_da_correggere VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci;

    DECLARE lista CURSOR FOR
        SELECT `tabella`, `vincolo`, `colonna`, `riferimento`, `cancellazione`, `aggiornamento`, `condizione`,
            `vecchio_nome`, `vecchia_cancellazione`, `vecchio_aggiornamento`
        FROM `__patch_chiavi_esterne__`
        WHERE `esito` IS NULL
        ORDER BY `tabella`, `vincolo`;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fine = 1;

    SET @chiavi_esterne_controlli = @@foreign_key_checks;
    SET @chiavi_esterne_aggiunte = 0;
    SET @chiavi_esterne_corrette = 0;
    SET @chiavi_esterne_note = NULL;

    OPEN lista;

    ciclo: LOOP

        FETCH lista INTO v_tabella, v_vincolo, v_colonna, v_riferimento, v_cancellazione, v_aggiornamento, v_condizione,
            v_vecchio_nome, v_vecchia_cancellazione, v_vecchio_aggiornamento;
        IF fine = 1 THEN
            LEAVE ciclo;
        END IF;

        SET v_esito = NULL, v_tipo_figlia = NULL, v_tipo_padre = NULL, v_nullabile = NULL, v_indice = NULL, v_da_correggere = NULL;

        -- i vincoli da correggere: si correggono solo se sul deploy sono ancora esattamente quelli di prima
        IF v_vecchio_nome IS NOT NULL THEN
            SELECT k.CONSTRAINT_NAME INTO v_da_correggere
                FROM information_schema.KEY_COLUMN_USAGE AS k
                INNER JOIN information_schema.REFERENTIAL_CONSTRAINTS AS r
                    ON r.CONSTRAINT_SCHEMA = k.CONSTRAINT_SCHEMA AND r.CONSTRAINT_NAME = k.CONSTRAINT_NAME AND r.TABLE_NAME = k.TABLE_NAME
                WHERE k.TABLE_SCHEMA = database() AND k.TABLE_NAME = v_tabella AND k.COLUMN_NAME = v_colonna
                  AND k.REFERENCED_TABLE_NAME = v_riferimento
                  AND BINARY k.CONSTRAINT_NAME = BINARY v_vecchio_nome
                  AND r.DELETE_RULE = v_vecchia_cancellazione AND r.UPDATE_RULE = v_vecchio_aggiornamento
                LIMIT 1;
        END IF;

        SELECT COLUMN_TYPE, IS_NULLABLE INTO v_tipo_figlia, v_nullabile
            FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = database() AND TABLE_NAME = v_tabella AND COLUMN_NAME = v_colonna
            LIMIT 1;

        SELECT COLUMN_TYPE INTO v_tipo_padre
            FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = database() AND TABLE_NAME = v_riferimento AND COLUMN_NAME = 'id'
            LIMIT 1;

        -- fine si alza anche quando una delle due SELECT qui sopra non trova niente
        SET fine = 0;

        IF v_da_correggere IS NOT NULL THEN
            BEGIN
                DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
                    BEGIN
                        GET DIAGNOSTICS CONDITION 1 messaggio = MESSAGE_TEXT;
                        SET errore = 1;
                    END;
                SET errore = 0;
                SET foreign_key_checks = 0;
                SET @chiavi_esterne_sql = CONCAT( 'ALTER TABLE `', v_tabella, '` DROP FOREIGN KEY `', v_da_correggere, '`' );
                PREPARE togli FROM @chiavi_esterne_sql;
                EXECUTE togli;
                DEALLOCATE PREPARE togli;
                IF errore = 0 THEN
                    SET @chiavi_esterne_sql = CONCAT(
                        'ALTER TABLE `', v_tabella, '` ADD CONSTRAINT `', v_vincolo, '` FOREIGN KEY (`', v_colonna, '`) ',
                        'REFERENCES `', v_riferimento, '` (`id`) ON DELETE ', v_cancellazione, ' ON UPDATE ', v_aggiornamento
                    );
                    PREPARE metti FROM @chiavi_esterne_sql;
                    EXECUTE metti;
                    DEALLOCATE PREPARE metti;
                    IF errore = 1 THEN
                        -- se la nuova non entra si rimette la vecchia, cosi' la colonna non resta senza vincolo
                        SET @chiavi_esterne_sql = CONCAT(
                            'ALTER TABLE `', v_tabella, '` ADD CONSTRAINT `', v_da_correggere, '` FOREIGN KEY (`', v_colonna, '`) ',
                            'REFERENCES `', v_riferimento, '` (`id`) ON DELETE ', v_vecchia_cancellazione, ' ON UPDATE ', v_vecchio_aggiornamento
                        );
                        PREPARE metti FROM @chiavi_esterne_sql;
                        EXECUTE metti;
                        DEALLOCATE PREPARE metti;
                        SET v_esito = LEFT( CONCAT( 'correzione fallita, rimesso il vincolo di prima: ', messaggio ), 255 );
                    ELSE
                        SET v_esito = 'corretto', @chiavi_esterne_corrette = @chiavi_esterne_corrette + 1;
                    END IF;
                ELSE
                    SET v_esito = LEFT( CONCAT( 'correzione fallita: ', messaggio ), 255 );
                END IF;
                SET foreign_key_checks = @chiavi_esterne_controlli;
            END;
        ELSEIF v_tipo_figlia IS NULL THEN
            SET v_esito = CONCAT( 'non esiste ', v_tabella, '.', v_colonna );
        ELSEIF v_tipo_padre IS NULL THEN
            SET v_esito = CONCAT( 'non esiste ', v_riferimento, '.id' );
        ELSEIF EXISTS (
            SELECT 1 FROM information_schema.KEY_COLUMN_USAGE
            WHERE TABLE_SCHEMA = database() AND TABLE_NAME = v_tabella AND COLUMN_NAME = v_colonna
              AND REFERENCED_TABLE_NAME IS NOT NULL
        ) THEN
            SET v_esito = 'presente';
        ELSEIF v_condizione IS NOT NULL AND NOT EXISTS (
            SELECT 1 FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = database()
              AND TABLE_NAME = SUBSTRING_INDEX( v_condizione, '.', 1 )
              AND COLUMN_NAME = SUBSTRING_INDEX( v_condizione, '.', -1 )
        ) THEN
            SET v_esito = CONCAT( 'manca ', v_condizione, ', da cui il vincolo dipende' );
        ELSEIF EXISTS (
            SELECT 1 FROM information_schema.TABLE_CONSTRAINTS
            WHERE CONSTRAINT_SCHEMA = database() AND CONSTRAINT_NAME = v_vincolo
        ) THEN
            SET v_esito = 'il nome e'' gia'' usato da un altro vincolo';
        ELSEIF NOT EXISTS (
            SELECT 1 FROM information_schema.STATISTICS
            WHERE TABLE_SCHEMA = database() AND TABLE_NAME = v_riferimento AND COLUMN_NAME = 'id'
              AND SEQ_IN_INDEX = 1 AND NON_UNIQUE = 0
        ) THEN
            SET v_esito = CONCAT( v_riferimento, '.id non e'' una chiave' );
        ELSEIF v_tipo_figlia <> v_tipo_padre THEN
            SET v_esito = CONCAT( 'tipi diversi, ', v_tabella, '.', v_colonna, ' ', v_tipo_figlia, ' e ', v_riferimento, '.id ', v_tipo_padre );
        ELSEIF v_cancellazione = 'SET NULL' AND v_nullabile = 'NO' THEN
            SET v_esito = CONCAT( v_tabella, '.', v_colonna, ' e'' NOT NULL e il vincolo e'' ON DELETE SET NULL' );
        END IF;

        -- righe orfane
        IF v_esito IS NULL THEN
            BEGIN
                DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
                    BEGIN
                        GET DIAGNOSTICS CONDITION 1 messaggio = MESSAGE_TEXT;
                        SET errore = 1;
                    END;
                SET errore = 0, @chiavi_esterne_orfani = NULL;
                SET @chiavi_esterne_sql = CONCAT(
                    'SELECT count(*) INTO @chiavi_esterne_orfani FROM `', v_tabella, '` AS figlie ',
                    'LEFT JOIN `', v_riferimento, '` AS padri ON padri.id = figlie.`', v_colonna, '` ',
                    'WHERE figlie.`', v_colonna, '` IS NOT NULL AND padri.id IS NULL'
                );
                PREPARE controllo FROM @chiavi_esterne_sql;
                EXECUTE controllo;
                DEALLOCATE PREPARE controllo;
                IF errore = 1 THEN
                    SET v_esito = LEFT( CONCAT( 'controllo delle righe orfane fallito: ', messaggio ), 255 );
                ELSEIF @chiavi_esterne_orfani > 0 THEN
                    SET v_esito = CONCAT( @chiavi_esterne_orfani, ' righe di ', v_tabella, ' con un ', v_colonna, ' che non esiste in ', v_riferimento );
                END IF;
            END;
        END IF;

        -- il vincolo, con il suo indice se la colonna non ne ha uno
        IF v_esito IS NULL THEN
            IF NOT EXISTS (
                SELECT 1 FROM information_schema.STATISTICS
                WHERE TABLE_SCHEMA = database() AND TABLE_NAME = v_tabella AND COLUMN_NAME = v_colonna AND SEQ_IN_INDEX = 1
            ) AND NOT EXISTS (
                SELECT 1 FROM information_schema.STATISTICS
                WHERE TABLE_SCHEMA = database() AND TABLE_NAME = v_tabella AND INDEX_NAME = v_colonna
            ) THEN
                SET v_indice = CONCAT( 'ADD KEY `', v_colonna, '` (`', v_colonna, '`), ' );
            END IF;
            BEGIN
                DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
                    BEGIN
                        GET DIAGNOSTICS CONDITION 1 messaggio = MESSAGE_TEXT;
                        SET errore = 1;
                    END;
                SET errore = 0;
                SET @chiavi_esterne_sql = CONCAT(
                    'ALTER TABLE `', v_tabella, '` ', IFNULL( v_indice, '' ),
                    'ADD CONSTRAINT `', v_vincolo, '` FOREIGN KEY (`', v_colonna, '`) REFERENCES `', v_riferimento, '` (`id`) ',
                    'ON DELETE ', v_cancellazione, ' ON UPDATE ', v_aggiornamento
                );
                SET foreign_key_checks = 0;
                PREPARE aggiunta FROM @chiavi_esterne_sql;
                EXECUTE aggiunta;
                DEALLOCATE PREPARE aggiunta;
                SET foreign_key_checks = @chiavi_esterne_controlli;
                IF errore = 1 THEN
                    SET v_esito = LEFT( CONCAT( 'ALTER TABLE fallita: ', messaggio ), 255 );
                ELSE
                    SET v_esito = 'aggiunto', @chiavi_esterne_aggiunte = @chiavi_esterne_aggiunte + 1;
                END IF;
            END;
        END IF;

        UPDATE `__patch_chiavi_esterne__` SET `esito` = v_esito
            WHERE `tabella` = v_tabella AND `vincolo` = v_vincolo;

        IF v_esito NOT IN ( 'presente', 'aggiunto', 'corretto' ) THEN
            SET @chiavi_esterne_note = CONCAT_WS( '\n', @chiavi_esterne_note, CONCAT( v_vincolo, ': ', v_esito ) );
        END IF;

    END LOOP;

    CLOSE lista;

    SET foreign_key_checks = @chiavi_esterne_controlli;

END;

-- | 202609301109

-- si esegue
CALL `__patch_chiavi_esterne__`();

-- | 202609301110

-- quello che non e' stato aggiunto, e perche': lo legge chi applica la patch a mano
SELECT @chiavi_esterne_aggiunte AS aggiunte, @chiavi_esterne_corrette AS corrette, @chiavi_esterne_note AS nota;

-- | 202609301111

-- si libera la procedura
DROP PROCEDURE IF EXISTS `__patch_chiavi_esterne__`;

-- | 202609301112

-- e la lista di lavoro
DROP TABLE IF EXISTS `__patch_chiavi_esterne__`;

-- | FINE FILE
