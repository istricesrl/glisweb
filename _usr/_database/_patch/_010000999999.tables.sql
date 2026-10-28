--
-- TABELLE
-- =======
-- questo file contiene le query per la creazione delle tabelle; si noti che non devono essere inseriti qui i valori
-- di auto increment, mentre vanno specificati per tabella il CHARSET ma non il COLLATE.
--
-- LEGENDA DEI COMMENTI ALLE TABELLE
-- =================================
-- in questa sezione viene fornita una semplice legenda per interpretare i commenti che si trovano prima di ogni tabella.
--
-- funzionamento del sistema di patch
-- ----------------------------------
-- ogni tabella ha un ID univoco di 12 caratteri che la identifica e la posiziona all'interno del sistema di patch del
-- database del framework; le prime due cifre indicano la tipologia di patch:
--
-- 01xxxxxxxxxx -> tabelle                _010000999999.tables.sql
-- 03xxxxxxxxxx -> indici                 _030000999999.indexes.sql
-- 04xxxxxxxxxx -> acl                    _040000999999.acl.sql
-- 05xxxxxxxxxx -> dati                   _050000999999.data.sql
-- 06xxxxxxxxxx -> chiavi esterne         _060000999999.constraints.sql
-- 07xxxxxxxxxx -> procedure e funzioni   _070000999999.procedures.sql
-- 08xxxxxxxxxx -> viste statiche         _080000999999.static.sql
-- 09xxxxxxxxxx -> viste                  _090000999999.views.sql
-- 10xxxxxxxxxx -> report                 _100000999999.reports.sql
--
-- le regole dello schema ( tipi, coda standard, chiavi esterne, indici, viste ) sono in _usr/_docs/_read/300.database.md,
-- quelle del motore che applica le patch in _src/_lib/_mysql.tools.php ( funzioni mysqlPatch...() ).
-- 
-- classificazione in base all'utilizzo da parte dell'utente
-- ---------------------------------------------------------
-- in base alle possibilità che l'utente ha di interagire con la tabella, questa può essere:
--
-- - gestita
-- - assistita
-- - standard
--
-- le tabelle gestite partono vuote e il loro contenuto può essere gestito tramite l'interfaccia del CMS; le tabelle
-- assistite partono con dei dati di default ma il loro contenuto può essere comunque gestito tramite l'interfaccia del CMS;
-- infine le tabelle standard contengono dati fissi che non possono essere modificati tramite l'interfaccia del CMS.
--
-- classificazione in base alla gerarchia dei dati (rango)
-- -------------------------------------------------------
-- le tabelle possono contenere dati di vario rango, dove per rango si intende l'indipendenza dei dati stessi rispetto ad altri
-- contenuti in tabelle diverse; in base a questo criterio, le tabelle possono essere:
--
-- - principali
-- - secondarie
-- - di relazione
-- - di specifica
--
-- le tabelle principali contengono dati indipendenti, ossia che hanno senso in sé, indipendentemente da altri dati contenuti
-- in tabelle diverse; le tabelle principali, come anagrafica, gruppi, file, eccetera, rappresentano normalmente le entità del
-- framework.
--
-- le tabelle secondarie contengono dati che dipendono da una tabella principale, e che quindi non hanno senso in sé; ad esempio
-- la tabella telefoni dipende dalla tabella anagrafica, e un numero di telefono non collegato a una persona non ha senso di
-- esistere in sé.
--
-- le tabelle di relazione collegano fra loro due entità principali o secondarie, dunque hanno senso solo in funzione dell'esistenza
-- delle entità che collegano, e dell'esistenza del collegamento stesso; ad esempio la tabella account_gruppi collega gli account ai gruppi,
-- e i dati che contiene cessano di avere senso quando il gruppo o l'account collegati non esistono più.
--
-- le tabelle di specifica contengono dati che specificano o dettagliano i dati di una tabella principale o secondaria, e che quindi
-- hanno senso nella misura in cui sono applicati alle relative entità; ad esempio la tabella tipologie_anagrafica specifica la
-- tipologia di un'anagrafica.
--
-- classificazione in base alla struttura della tabella
-- ----------------------------------------------------
-- questa classificazione riguarda la struttura della tabella relativamente alle colonne che la compongono e ai relativi tipi di dato,
-- nonché alle relazioni che la tabella stabilisce con sé stessa e con altre tabelle; da questo punto di vista, le tabelle possono essere:
--
-- - base
-- - ricorsive
--
-- le tabelle base sono tabelle che non presentano particolari caratteristiche strutturali, e sono tipicamente costruite a partire da
-- un campo ID intero auto incrementale che funge da chiave primaria. Solitamente una tabella base presenta al minimo i seguenti campi:
--
-- - id
-- - id_tipologia
-- - nome
-- - note
-- - id_account_inserimento
-- - timestamp_inserimento
-- - id_account_aggiornamento
-- - timestamp_aggiornamento
--
-- le tabelle ricorsive sono tabelle che presentano una relazione con sé stesse, tipicamente tramite un campo id_genitore che fa riferimento
-- al campo id della stessa tabella; in questo modo si possono creare strutture ad albero, molto potenti e flessibili; tuttavia questo
-- approccio espone il database al rischio di creare cicli infiniti, e pertanto va usato con cautela. Solitamente le tabelle ricorsive
-- presentano oltre ai campi di minima visti sopra anche il campo id_genitore, posizionato subito dopo il campo id.
--
-- TODO
-- ====
-- in futuro ragionare se aggiungere le colonne id_gruppo_inserimento e id_gruppo_aggiornamento per tenere traccia del gruppo che ha
-- inserito o aggiornato la riga e anche per implementare un sistema di permessi più stile Linux rispetto a quello attuale delle ACL
-- 

-- | 010000000010

-- __mappatura_id__
-- tipologia: tabella di sistema
-- funzione: la corrispondenza fra un vecchio id testuale e il suo id numerico
--
-- la scrive _202609301900.id.numerici.sql quando porta articoli, prodotti, progetti, coupon e consensi all'id numerico,
-- e il framework non la legge: serve per tradurre i riferimenti fuori dal database ( URL, nomi di file, log, sistemi
-- esterni ) o per tornare indietro; la chiave e' naturale, ( tabella, vecchio_id ), e non c'e' la colonna id
--
CREATE TABLE IF NOT EXISTS `__mappatura_id__` (
  `tabella` char(64) NOT NULL,                                 -- la tabella convertita
  `vecchio_id` char(64) NOT NULL,                              -- l'id testuale di prima
  `nuovo_id` bigint(20) NOT NULL,                              -- l'id numerico assegnato
  `timestamp_conversione` int(11) DEFAULT NULL                 -- quando
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000000020

-- __mappatura_id_orfani__
-- tipologia: tabella di sistema
-- funzione: i valori che durante la conversione all'id numerico non citavano nessuna riga della tabella madre
--
-- id_riga e' l'id della riga che conteneva il valore, in una tabella qualsiasi e scritto come testo: non e' una chiave
--
CREATE TABLE IF NOT EXISTS `__mappatura_id_orfani__` (
  `id` bigint(20) NOT NULL,                                    -- id della riga
  `tabella` char(64) NOT NULL,                                 -- la tabella che conteneva il valore
  `colonna` char(64) NOT NULL,                                 -- la colonna che conteneva il valore
  `riferimento` char(64) NOT NULL,                             -- la tabella madre che il valore avrebbe dovuto citare
  `id_riga` char(64) DEFAULT NULL,                             -- l'id della riga che conteneva il valore
  `valore` char(64) DEFAULT NULL,                              -- il valore orfano
  `azione` char(16) DEFAULT NULL,                              -- annullata ( la colonna e' diventata NULL ) o cancellata
  `timestamp_conversione` int(11) DEFAULT NULL                 -- quando
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000000100

-- account
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene gli account degli utenti
-- entità: questa tabella corrisponde all'entità account
--
-- il framework supporta diverse modalità di accesso, tra cui l'accesso tramite account registrati nel
-- database e gestiti tramite CMS; i dettagli degli account non vengono letti tutti, ma solo quelli
-- relativi all'account corrente al momento del login
--
CREATE TABLE IF NOT EXISTS `account` (                        -- 
  `id` bigint(20) NOT NULL,                                      -- chiave primaria
  `id_anagrafica` bigint(20) DEFAULT NULL,                       -- chiave esterna per l'anagrafica dell'utente cui appartiene l'account
  `id_mail` bigint(20) DEFAULT NULL,                             -- chiave esterna per la mail collegata all'account
  `id_affiliazione` bigint(20) DEFAULT NULL,                     -- chiave esterna (contratti) che associa un dato account a un contratto di affiliazione
  `id_url` bigint(20) DEFAULT NULL,                              -- chiave esterna (url) che associa un dato account a un URL
  `id_organizzazione` bigint(20) DEFAULT NULL,                   -- chiave esterna per il nodo dell'organizzazione a cui appartiene l'account
  `username` char(64) DEFAULT NULL,                           -- nome utente per il login
  `password` char(128) DEFAULT NULL,                          -- password (hash) per il login
  `se_attivo` tinyint(1) DEFAULT NULL,                        -- flag che indica se l'account è attivo o meno
  `token` char(128) DEFAULT NULL,                             -- token per il recupero password
  `timestamp_login` int(11) DEFAULT NULL,                     -- timestamp dell'ultimo login
  `timestamp_cambio_password` int(11) DEFAULT NULL,           -- timestamp dell'ultimo cambio password
  `id_account_inserimento` bigint(20) DEFAULT NULL,              -- chiave esterna per l'account che ha inserito l'account
  `timestamp_inserimento` int(11) DEFAULT NULL,               -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,            -- chiave esterna per l'account che ha aggiornato l'account
  `timestamp_aggiornamento` int(11) DEFAULT NULL              -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- NOTA la timestamp di cambio password non viene attualmente utilizzata ma è stata mantenuta per eventuali sviluppi futuri
--
-- NOTA la password si salva con password_hash() ( passwordHash() in _src/_lib/_cryptography.tools.php ); i vecchi hash MD5
-- restano validi e vengono ricalcolati al primo login riuscito
--
-- NOTA id_organizzazione colloca l'account in un nodo di organizzazioni, come gruppi.id_organizzazione per i gruppi:
-- serve a segmentare gli accessi per parti dell'organizzazione; non e' ancora letta dal codice ( decisione del 20/10/2026 )

-- | 010000000120

-- account_gruppi
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: mette in relazione gli account e i gruppi a cui appartengono
-- funzioni: associa molti a molti gli account ai gruppi
--
-- questa tabella contiene le associazioni molti a molti tra gli account e i gruppi
--
CREATE TABLE IF NOT EXISTS `account_gruppi` (                 --
  `id` bigint(20) NOT NULL,                                      -- chiave primaria
  `id_account` bigint(20) DEFAULT NULL,                          -- chiave esterna per l'account
  `id_gruppo` bigint(20) DEFAULT NULL,                           -- chiave esterna per il gruppo
  `ordine` int(11) DEFAULT NULL,                              -- ordine di visualizzazione
  `se_amministratore` tinyint(1) DEFAULT NULL,                -- flag per indicare se l'account è amministratore del gruppo associato
  `id_account_inserimento` bigint(20) DEFAULT NULL,              -- chiave esterna per l'account che ha inserito l'associazione
  `timestamp_inserimento` int(11) DEFAULT NULL,               -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,            -- chiave esterna per l'account che ha aggiornato l'associazione
  `timestamp_aggiornamento` int(11) DEFAULT NULL              -- timestamp di aggiornamento
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8;                       --

-- | 010000000130

-- account_gruppi_attribuzione
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: le righe di questa tabella innescano una logica applicativa di associazione fra un account, un gruppo e un'entità data
--
-- per vari casi d'uso può essere necessario che una riga creata da un determinato account venga automaticamente associata a un
-- altro gruppo su una tabella di ACL; ad esempio un account membro del gruppo commerciale italia potrebbe creare un cliente che deve
-- essere associato anche al gruppo commerciale mondo del quale l'account non fa parte (ad esempio per motivi di controllo)
--
CREATE TABLE IF NOT EXISTS `account_gruppi_attribuzione` (    --
  `id` bigint(20) NOT NULL,                                      -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                              -- ordine di visualizzazione
  `id_account` bigint(20) DEFAULT NULL,                          -- chiave esterna per l'account
  `id_gruppo` bigint(20) DEFAULT NULL,                           -- chiave esterna per il gruppo
  `entita` char(64) DEFAULT NULL,                             -- entità per la quale si innesca l'associazione
  `note` text DEFAULT NULL,                                   -- note
  `id_account_inserimento` bigint(20) DEFAULT NULL,              -- chiave esterna per l'account che ha inserito l'associazione
  `timestamp_inserimento` int(11) DEFAULT NULL,               -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,            -- chiave esterna per l'account che ha aggiornato l'associazione
  `timestamp_aggiornamento` int(11) DEFAULT NULL              -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- TODO documentare meglio questa tabella con riferimenti al codice
--

-- | 010000000400

-- anagrafica
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene le anagrafiche di persone e aziende
-- 
-- questa tabella contiene le anagrafiche di persone e aziende, con le informazioni principali
--
CREATE TABLE IF NOT EXISTS `anagrafica` (                     --
  `id` bigint(20) NOT NULL,                                      -- chiave primaria
  `id_tipologia` bigint(20) DEFAULT NULL,                        -- chiave esterna per la tipologia di anagrafica
  `id_badge` bigint(20) DEFAULT NULL,                            -- chiave esterna per il badge associato all'anagrafica
  `codice` char(32) DEFAULT NULL,                             -- codice dell'anagrafica
  `riferimento` char(255) DEFAULT NULL,                       -- riferimento interno per l'anagrafica
  `nome` char(64) DEFAULT NULL,                               -- nome della persona
  `cognome` char(255) DEFAULT NULL,                           -- cognome della persona
  `denominazione` char(255) DEFAULT NULL,                     -- denominazione dell'azienda
  `soprannome` char(128) DEFAULT NULL,                        -- soprannome o nome commerciale
  `sesso` enum('M','F','-') DEFAULT NULL,                     -- sesso della persona
  `stato_civile` char(128) DEFAULT NULL,                      -- stato civile della persona
  `codice_fiscale` char(32) DEFAULT NULL,                     -- codice fiscale della persona o dell'azienda
  `partita_iva` char(32) DEFAULT NULL,                        -- partita IVA della persona o dell'azienda
  `codice_sdi` char(32) DEFAULT NULL,                         -- codice SDI per la fatturazione elettronica
  `id_pec_sdi` bigint(20) DEFAULT NULL,                          -- chiave esterna per la PEC associata al codice SDI
  `codice_ipa` char(32) DEFAULT NULL,                         -- codice IPA per la fatturazione elettronica verso la pubblica amministrazione
  `codice_archivium` char(16) DEFAULT NULL,                   -- codice per l'integrazione con Archivium
  `id_regime` bigint(20) DEFAULT NULL,                           -- chiave esterna per il regime fiscale
  `rea_ufficio` char(2) DEFAULT NULL,                         -- sigla della provincia dell'ufficio del registro imprese ( IscrizioneREA )
  `rea_numero` char(20) DEFAULT NULL,                         -- numero di iscrizione al REA
  `capitale_sociale` decimal(16,2) DEFAULT NULL,              -- capitale sociale versato, per le società di capitali
  `socio_unico` enum('SU','SM') DEFAULT NULL,                 -- società a socio unico ( SU ) o a più soci ( SM )
  `stato_liquidazione` enum('LS','LN') DEFAULT NULL,          -- in liquidazione ( LS ) o no ( LN )
  `id_rappresentante_fiscale` bigint(20) DEFAULT NULL,           -- chiave esterna per l'anagrafica del rappresentante fiscale in Italia
  `note_amministrative` text DEFAULT NULL,                    -- note amministrative
  `note_collaborazione` text DEFAULT NULL,                    -- note di collaborazione
  `luogo_nascita` char(128) DEFAULT NULL,                     -- luogo di nascita
  `stato_nascita` char(128) DEFAULT NULL,                     -- stato di nascita
  `id_stato_nascita` bigint(20) DEFAULT NULL,                    -- chiave esterna per lo stato di nascita
  `comune_nascita` char(128) DEFAULT NULL,                    -- comune di nascita
  `id_comune_nascita` bigint(20) DEFAULT NULL,                   -- chiave esterna per il comune di nascita
  `giorno_nascita` int(2) DEFAULT NULL,                       -- giorno di nascita
  `mese_nascita` int(2) DEFAULT NULL,                         -- mese di nascita
  `anno_nascita` int(4) DEFAULT NULL,                         -- anno di nascita
  `id_ranking` bigint(20) DEFAULT NULL,                          -- chiave esterna per il ranking
  `id_agente` bigint(20) DEFAULT NULL,                           -- chiave esterna per l'agente
  `id_responsabile_operativo` bigint(20) DEFAULT NULL,           -- chiave esterna per il responsabile operativo
  `note_commerciali` text DEFAULT NULL,                       -- note commerciali
  `condizioni_vendita` text DEFAULT NULL,                     -- condizioni di vendita
  `condizioni_acquisto` text DEFAULT NULL,                    -- condizioni di acquisto
  `note` text DEFAULT NULL,                                   -- note
  `data_archiviazione` date DEFAULT NULL,                     -- data di archiviazione
  `note_archiviazione` text DEFAULT NULL,                     -- note di archiviazione
  `recapiti` text DEFAULT NULL,                               -- recapiti
  `token` char(255) DEFAULT NULL,                             -- token
  `se_importata` tinyint(1) DEFAULT NULL,                     -- flag per importazione
  `se_stampa_privacy` tinyint(1) DEFAULT NULL,                -- flag per stampa privacy
  `id_account_inserimento` bigint(20) DEFAULT NULL,              -- chiave esterna per l'account di inserimento
  `timestamp_inserimento` int(11) DEFAULT NULL,               -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,            -- chiave esterna per l'account di aggiornamento
  `timestamp_aggiornamento` int(11) DEFAULT NULL              -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000000500

-- anagrafica_categorie
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: associa molti a molti le anagrafiche alle categorie
--
-- questa tabella contiene le associazioni molti a molti tra le anagrafiche e le categorie
-- 
CREATE TABLE IF NOT EXISTS `anagrafica_categorie` (           --
  `id` bigint(20) NOT NULL,                                      -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                              -- ordine di visualizzazione
  `id_anagrafica` bigint(20) DEFAULT NULL,                       -- chiave esterna per l'anagrafica
  `id_categoria` bigint(20) DEFAULT NULL,                        -- chiave esterna per la categoria
  `id_account_inserimento` bigint(20) DEFAULT NULL,              -- chiave esterna per l'account che ha inserito l'associazione
  `timestamp_inserimento` int(11) DEFAULT NULL,               -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,            -- chiave esterna per l'account che ha aggiornato l'associazione
  `timestamp_aggiornamento` int(11) DEFAULT NULL              -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000000600

-- anagrafica_certificazioni
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene i anagrafica certificazioni
--
CREATE TABLE IF NOT EXISTS `anagrafica_certificazioni` (
  `id` bigint(20) NOT NULL,
  `id_anagrafica` bigint(20) DEFAULT NULL,
  `id_certificazione` bigint(20) DEFAULT NULL,
  `id_emittente` bigint(20) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `data_emissione` date DEFAULT NULL,
  `data_scadenza` date DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000000700

-- anagrafica_cittadinanze
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: mette in relazione anagrafica e cittadinanze
--
CREATE TABLE IF NOT EXISTS `anagrafica_cittadinanze` (
  `id` bigint(20) NOT NULL,
  `id_anagrafica` bigint(20) DEFAULT NULL,
  `id_stato` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `data_inizio` date DEFAULT NULL,
  `data_fine` date DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000000800

-- anagrafica_consensi
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: mette in relazione anagrafica e consensi
--
CREATE TABLE IF NOT EXISTS `anagrafica_consensi` (
  `id` bigint(20) NOT NULL,
  `id_account` bigint(20) DEFAULT NULL,
  `id_anagrafica` bigint(20) DEFAULT NULL,
  `id_mail` bigint(20) DEFAULT NULL,
  `id_consenso` bigint(20) DEFAULT NULL,
  `se_prestato` tinyint(1) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `timestamp_consenso` int(11) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000000900

-- anagrafica_indirizzi
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: associa molti a molti le anagrafiche agli indirizzi
--
-- questa tabella contiene le associazioni molti a molti tra le anagrafiche e gli indirizzi
--
CREATE TABLE IF NOT EXISTS `anagrafica_indirizzi` (           --
  `id` bigint(20) NOT NULL,                                      -- chiave primaria
  `id_tipologia` bigint(20) DEFAULT NULL,                        -- chiave esterna per la tipologia di indirizzo
  `ordine` int(11) DEFAULT NULL,                              -- ordine di visualizzazione
  `codice` char(32) DEFAULT NULL,                             -- codice dell'indirizzo
  `id_anagrafica` bigint(20) DEFAULT NULL,                       -- chiave esterna per l'anagrafica
  `id_indirizzo` bigint(20) DEFAULT NULL,                        -- chiave esterna per l'indirizzo
  `id_ruolo` bigint(20) DEFAULT NULL,                            -- chiave esterna per il ruolo dell'indirizzo
  `interno` char(8) DEFAULT NULL,                             -- interno dell'indirizzo
  `indirizzo` char(255) DEFAULT NULL,                         -- indirizzo
  `civico` char(16) DEFAULT NULL,                             -- civico dell'indirizzo
  `id_comune` bigint(20) DEFAULT NULL,                           -- chiave esterna per il comune
  `localita` char(128) DEFAULT NULL,                          -- località
  `cap` char(11) DEFAULT NULL,                                -- CAP
  `note` text DEFAULT NULL,                                   -- note sull'indirizzo
  `latitudine` decimal(11,7) DEFAULT NULL,                    -- latitudine
  `longitudine` decimal(11,7) DEFAULT NULL,                   -- longitudine
  `token` char(128) DEFAULT NULL,                             -- token per geolocalizzazione
  `timestamp_geolocalizzazione` int(11) DEFAULT NULL,         -- timestamp dell'ultima geolocalizzazione
  `timestamp_elaborazione` int(11) DEFAULT NULL,              -- timestamp dell'ultima elaborazione
  `note_elaborazione` text DEFAULT NULL,                      -- note sull'ultima elaborazione
  `id_account_inserimento` bigint(20) DEFAULT NULL,              -- chiave esterna per l'account che ha inserito l'associazione
  `timestamp_inserimento` int(11) DEFAULT NULL,               -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,            -- chiave esterna per l'account che ha aggiornato l'associazione
  `timestamp_aggiornamento` int(11) DEFAULT NULL              -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000000920

-- anagrafica_organizzazioni
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: collega le anagrafiche ai nodi delle organizzazioni, con un ruolo
--
-- questa tabella dice chi sta in quale nodo di una struttura organizzata ( organizzazioni ) e con quale ruolo
-- ( titolare, direttore, dipendente, referente... ); i ruoli proponibili sono quelli con
-- ruoli_anagrafica.se_organizzazioni; insieme a organizzazioni descrive l'organigramma
--
-- NOTA la chiave unica e' ( id_anagrafica, id_organizzazione, id_ruolo ): la stessa anagrafica puo' avere piu'
-- ruoli nello stesso nodo; le note precisano il ruolo nel caso specifico ( decisione del 20/10/2026 )
--
CREATE TABLE IF NOT EXISTS `anagrafica_organizzazioni` (        --
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                -- ordine di visualizzazione
  `id_anagrafica` bigint(20) DEFAULT NULL,                      -- chiave esterna per l'anagrafica
  `id_organizzazione` bigint(20) DEFAULT NULL,                  -- chiave esterna per il nodo dell'organizzazione
  `id_ruolo` bigint(20) DEFAULT NULL,                           -- chiave esterna per il ruolo ( ruoli_anagrafica )
  `note` text DEFAULT NULL,                                     -- note che precisano il ruolo
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha aggiornato la riga
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                           --

-- | 010000000940

-- anagrafica_progetti
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: mette in relazione anagrafica e progetti, con un ruolo
--
-- nata per assegnare le persone ai progetti ( project manager, sviluppatori, tecnici ), si è estesa alla
-- didattica ( insegnanti, alunni, sostituti ) e ad altre associazioni come la lista d'attesa ( se_attesa );
-- id_todo dovrebbe limitare l'associazione a un singolo compito del progetto ( p.es. il sostituto per una
-- lezione ), ma nessun modulo lo usa e lo scopo originale non è documentato
--
CREATE TABLE IF NOT EXISTS `anagrafica_progetti` (
  `id` bigint(20) NOT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `id_anagrafica` bigint(20) DEFAULT NULL,
  `id_progetto` bigint(20) DEFAULT NULL,
  `id_ruolo` bigint(20) DEFAULT NULL,
  `id_todo` bigint(20) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `se_attesa` tinyint(1) DEFAULT NULL,
  `se_sostituto` tinyint(1) DEFAULT NULL,
  `id_account_archiviazione` bigint(20) DEFAULT NULL,
  `timestamp_archiviazione` int(11) DEFAULT NULL,
  `note_archiviazione` text NULL,
  `note_inserimento` text NULL,
  `note_aggiornamento` text NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000001200

-- anagrafica_settori
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: mette in relazione anagrafica e settori
--
-- associa a un'anagrafica i suoi settori di attività, cioè i codici ATECO della tabella settori; un'anagrafica
-- può averne più di uno, e ordine li mette in sequenza
--
CREATE TABLE IF NOT EXISTS `anagrafica_settori` (
  `id` bigint(20) NOT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_anagrafica` bigint(20) DEFAULT NULL,
  `id_settore` bigint(20) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000001250

-- annunci
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene gli annunci di un portale offro/cerco
--
-- nata per il portale offro/cerco di Cucine Popolari, come sviluppo sperimentale; un annuncio ha una pagina propria
-- ( template, schema, tema, sitemap, cache ), può riferirsi a una categoria di prodotti, a un prodotto o a un articolo,
-- con una quantità, e ha un periodo di validità; le categorie stanno in annunci_categorie, le tipologie in
-- tipologie_annunci; la tabella resta in vista del modulo annunci della linea latest
--
CREATE TABLE IF NOT EXISTS `annunci` (
  `id` bigint(20) NOT NULL,
  `id_tipologia` bigint(20) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `id_categoria_prodotti` bigint(20) DEFAULT NULL,
  `id_prodotto` bigint(20) DEFAULT NULL,
  `id_articolo` bigint(20) DEFAULT NULL,
  `id_udm` bigint(20) DEFAULT NULL,
  `id_sito` bigint(20) DEFAULT NULL,
  `quantita` decimal(9,2) DEFAULT NULL,
  `testo` text DEFAULT NULL,
  `note` text DEFAULT NULL,
  `template` char(255) DEFAULT NULL,
  `schema_html` char(128) DEFAULT NULL,
  `tema_css` char(128) DEFAULT NULL,
  `se_sitemap` tinyint(1) DEFAULT NULL,
  `se_cacheable` tinyint(1) DEFAULT NULL,
  `data_inizio_validita` date DEFAULT NULL,
  `ora_inizio_validita` time DEFAULT NULL,
  `note_inizio_validita` text DEFAULT NULL,
  `data_fine_validita` date DEFAULT NULL,
  `ora_fine_validita` time DEFAULT NULL,
  `note_fine_validita` text DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000001270

-- annunci_categorie
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: associa molti a molti gli annunci alle categorie degli annunci
--
-- questa tabella contiene le associazioni molti a molti tra gli annunci e le categorie_annunci; le categorie fanno
-- parte della scheda dell'annuncio, quindi la chiave verso annunci si segue; appartiene alla famiglia annunci, che
-- resta in vista del modulo annunci della linea latest
--
CREATE TABLE IF NOT EXISTS `annunci_categorie` (              --
  `id` bigint(20) NOT NULL,                                      -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                              -- ordine di visualizzazione
  `id_annuncio` bigint(20) DEFAULT NULL,                         -- chiave esterna per l'annuncio
  `id_categoria` bigint(20) DEFAULT NULL,                        -- chiave esterna per la categoria
  `id_account_inserimento` bigint(20) DEFAULT NULL,              -- chiave esterna per l'account che ha inserito l'associazione
  `timestamp_inserimento` int(11) DEFAULT NULL,               -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,            -- chiave esterna per l'account che ha aggiornato l'associazione
  `timestamp_aggiornamento` int(11) DEFAULT NULL              -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000001300

-- articoli
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene gli articoli, cioè le varianti vendibili e movimentabili dei prodotti
--
-- questa tabella contiene gli articoli: un articolo è la variante concreta di un prodotto, quella che ha un codice,
-- un barcode, delle misure e un prezzo, e che finisce nelle righe dei documenti, nei carrelli e nei listini; un
-- prodotto può avere più articoli ( p.es. per taglia, colore o formato ), e ordine li mette in sequenza dentro il
-- prodotto; il riferimento al prodotto è facoltativo ( esistono articoli senza prodotto ) e cancellare il prodotto
-- non cancella i suoi articoli
--
-- NOTA il nome dell'articolo è solo la parte che lo distingue dagli altri articoli dello stesso prodotto: il nome
-- completo lo compone articoli_view, unendo nome del prodotto, nome dell'articolo e misure
-- NOTA ogni misura è un blocco col suo valore seguito dalla sua unità di misura ( larghezza, lunghezza e altezza
-- condividono id_udm_dimensioni )
-- NOTA id_periodicita e id_tipologia_rinnovo servono agli articoli che si vendono come abbonamenti, tesseramenti o
-- rinnovi; note_codifica raccoglie le annotazioni su come è stato assegnato il codice
--
CREATE TABLE IF NOT EXISTS `articoli` (
  `id` bigint(20) NOT NULL,
  `ordine` int(11) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `id_prodotto` bigint(20) DEFAULT NULL,
  `id_reparto` bigint(20) DEFAULT NULL,
  `id_taglia` bigint(20) DEFAULT NULL,
  `id_colore` bigint(20) DEFAULT NULL,
  `id_periodicita` bigint(20) DEFAULT NULL,
  `id_tipologia_rinnovo` bigint(20) DEFAULT NULL,
  `ean` char(32) DEFAULT NULL,
  `isbn` char(32) DEFAULT NULL,
  `codice_produttore` char(64) DEFAULT NULL,
  `larghezza` decimal(12,5) DEFAULT NULL,
  `lunghezza` decimal(12,5) DEFAULT NULL,
  `altezza` decimal(12,5) DEFAULT NULL,
  `id_udm_dimensioni` bigint(20) DEFAULT NULL,
  `peso` decimal(12,5) DEFAULT NULL,
  `id_udm_peso` bigint(20) DEFAULT NULL,
  `volume` decimal(12,5) DEFAULT NULL,
  `id_udm_volume` bigint(20) DEFAULT NULL,
  `capacita` decimal(12,5) DEFAULT NULL,
  `id_udm_capacita` bigint(20) DEFAULT NULL,
  `durata` decimal(12,5) DEFAULT NULL,
  `id_udm_durata` bigint(20) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `note_codifica` text DEFAULT NULL,
  `data_archiviazione` date DEFAULT NULL,
  `note_archiviazione` text DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000001400

-- articoli_caratteristiche
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: collega un articolo alle sue caratteristiche
--
-- questa tabella collega un articolo all'albero delle caratteristiche ( caratteristiche )
-- e ne porta il valore. E' la gemella di prodotti_caratteristiche, con in piu' la colonna
-- se_assente, che serve alle voci di listino per dire che una caratteristica su quella voce non
-- c'e' invece di non dire niente.
--
-- NOTA: fino all'08/09/2026 questa tabella e caratteristiche_prodotti e prodotti_caratteristiche
-- vivevano solo nei database, senza nessuna patch che le creasse. Sono state portate qui insieme
-- alla correzione di valore, che era decimal(5,2) e non poteva quindi contenere una scheda tecnica.
--
-- NOTA: il valore e' per lingua, quindi la stessa caratteristica puo' comparire su un articolo una
-- volta per ogni lingua; per questo id_lingua fa parte della chiave unica ( decisione del 06/10/2026 ).
-- Le righe con id_lingua a NULL non sono protette dalla chiave unica, perche' MySQL non considera
-- uguali due NULL.
--
CREATE TABLE IF NOT EXISTS `articoli_caratteristiche` (
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                -- ordine di visualizzazione
  `id_articolo` bigint(20) DEFAULT NULL,                        -- chiave esterna per l'articolo
  `id_caratteristica` bigint(20) DEFAULT NULL,                  -- chiave esterna per la caratteristica
  `id_lingua` bigint(20) DEFAULT NULL,                          -- chiave esterna per la lingua del valore
  `valore` text DEFAULT NULL,                                   -- valore della caratteristica
  `note` text DEFAULT NULL,                                     -- note
  `se_assente` tinyint(1) DEFAULT NULL,                         -- la caratteristica e' dichiarata assente
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account di inserimento
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account di aggiornamento
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000001700

-- asset
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella ricorsiva
-- funzione: contiene gli asset, cioè gli oggetti fisici o logici gestiti o catalogati tramite il framework
-- entità: questa tabella corrisponde all'entità asset
--
-- questa tabella descrive in astratto oggetti di vario tipo ( cespiti, macchinari, attrezzature... ) che possono essere
-- utilizzati, gestiti o anche semplicemente catalogati tramite il framework; il tipo di oggetto lo dice id_tipologia, che
-- punta a tipologie_asset; la tabella è ricorsiva perché un asset può contenerne altri ( ad esempio un modulo di un
-- macchinario ), e id_genitore punta all'asset che lo contiene
--
-- NOTA hostname e ip_address servono per gli asset informatici e per le macchine collegate in rete; cespite è il codice
-- che l'asset ha nel registro dei beni ammortizzabili, quando ne fa parte
--
CREATE TABLE IF NOT EXISTS `asset` (                            --
  `id` bigint(20) NOT NULL,                                        -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                           -- chiave esterna per l'asset che contiene questo
  `id_tipologia` bigint(20) DEFAULT NULL,                          -- chiave esterna per la tipologia di asset
  `id_condizione` bigint(20) DEFAULT NULL,                         -- chiave esterna per la condizione dell'asset
  `codice` char(32) DEFAULT NULL,                               -- codice dell'asset
  `nome` char(128) DEFAULT NULL,                                -- nome dell'asset
  `hostname` char(128) DEFAULT NULL,                            -- hostname dell'asset
  `ip_address` char(32) DEFAULT NULL,                           -- indirizzo IP dell'asset
  `cespite` char(32) DEFAULT NULL,                              -- codice cespite dell'asset
  `note` text DEFAULT NULL,                                     -- note sull'asset
  `id_account_inserimento` bigint(20) DEFAULT NULL,                -- chiave esterna per l'account che ha inserito l'asset
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,              -- chiave esterna per l'account che ha aggiornato l'asset
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                          --

-- | 010000001800

-- attivita
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella ricorsiva
-- funzione: contiene le attività, cioè tutto ciò che qualcuno fa
-- entità: questa tabella corrisponde all'entità attività
--
-- questa tabella descrive l'ampio insieme dei casi in cui qualcuno fa qualcosa, ed è usata per scopi molto diversi
-- ( interventi, ore di lavoro, appuntamenti, telefonate, invii di mailing, passi di un todo... ); un'attività può
-- essere scadenzata, programmata e svolta, e ognuna di queste fasi ha il suo blocco di colonne; la tabella è ricorsiva
-- perché un'attività può essere parte di un'altra, e id_genitore punta all'attività che la contiene
--
-- NOTA le attività valorizzano i mastri di tipo tempo, tramite id_mastro_provenienza, id_mastro_destinazione e ore,
-- così come i pagamenti valorizzano i mastri di tipo denaro e le righe dei documenti quelli di tipo magazzino
--
-- NOTA id_asset è l'asset su cui si svolge l'attività, che è uno solo; gli asset con cui la si svolge, che possono
-- essere più d'uno, stanno nella tabella di relazione attivita_asset
--
CREATE TABLE IF NOT EXISTS `attivita` (                         --
  `id` bigint(20) NOT NULL,                                       -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                          -- chiave esterna per l'attività genitore
  `id_tipologia` bigint(20) DEFAULT NULL,                         -- chiave esterna per la tipologia di attività
  `codice` char(32) DEFAULT NULL,                                 -- codice dell'attività
  `nome` char(255) DEFAULT NULL,                                  -- nome dell'attività
  `id_anagrafica` bigint(20) DEFAULT NULL,                        -- chiave esterna per l'anagrafica collegata all'attività
  `id_mail` bigint(20) DEFAULT NULL,                              -- chiave esterna per la mail collegata all'attività
  `id_account` bigint(20) DEFAULT NULL,                           -- chiave esterna per l'account collegato all'attività
  `id_cliente` bigint(20) DEFAULT NULL,                           -- chiave esterna per il cliente collegato all'attività
  `id_contatto` bigint(20) DEFAULT NULL,                          -- chiave esterna per il contatto collegato all'attività
  `id_indirizzo` bigint(20) DEFAULT NULL,                         -- chiave esterna per l'indirizzo collegato all'attività
  `id_luogo` bigint(20) DEFAULT NULL,                             -- chiave esterna per il luogo collegato all'attività
  `id_asset` bigint(20) DEFAULT NULL,                             -- chiave esterna per l'asset su cui si svolge l'attività
  `id_progetto` bigint(20) DEFAULT NULL,                          -- chiave esterna per il progetto collegato all'attività
  `id_contratto` bigint(20) DEFAULT NULL,                         -- chiave esterna per il contratto collegato all'attività
  `id_todo` bigint(20) DEFAULT NULL,                              -- chiave esterna per il todo collegato all'attività
  `id_step` bigint(20) DEFAULT NULL,                              -- chiave esterna per lo step collegato all'attività
  `id_pianificazione` bigint(20) DEFAULT NULL,                    -- chiave esterna per la pianificazione collegata all'attività
  `id_matricola` bigint(20) DEFAULT NULL,                         -- chiave esterna per la matricola collegata all'attività
  `id_immobile` bigint(20) DEFAULT NULL,                          -- chiave esterna per l'immobile collegato all'attività
  `id_messaggio` bigint(20) DEFAULT NULL,                         -- chiave esterna per il messaggio collegato all'attività
  `id_mailing` bigint(20) DEFAULT NULL,                           -- chiave esterna per il mailing collegato all'attività
  `id_banner` bigint(20) DEFAULT NULL,                            -- chiave esterna per il banner visualizzato o cliccato
  `id_pubblicazione` bigint(20) DEFAULT NULL,                     -- chiave esterna per la collocazione che ha servito il banner
  `id_redirect` bigint(20) DEFAULT NULL,                          -- chiave esterna per il redirect eseguito
  `id_documento` bigint(20) DEFAULT NULL,                         -- chiave esterna per il documento collegato all'attività
  `id_corrispondenza` bigint(20) DEFAULT NULL,                    -- chiave esterna per la corrispondenza collegata all'attività
  `id_pagamento` bigint(20) DEFAULT NULL,                         -- chiave esterna per il pagamento collegato all'attività
  `id_mastro_provenienza` bigint(20) DEFAULT NULL,                -- chiave esterna per il mastro di provenienza
  `id_mastro_destinazione` bigint(20) DEFAULT NULL,               -- chiave esterna per il mastro di destinazione
  `id_oggetto` bigint(20) DEFAULT NULL,                           -- esce dal canone ( revisione del 06/10/2026 ), si toglie con le patch di allineamento
  `referenti` char(255) DEFAULT NULL,                             -- referenti dell'attività
  `ore` decimal(5,2) DEFAULT NULL,                                -- ore effettive dell'attività
  `codice_archivium` char(32) DEFAULT NULL,                       -- codice per l'integrazione con Archivium
  `token` char(128) DEFAULT NULL,                                 -- token per geolocalizzazione
  `note` text DEFAULT NULL,                                       -- note sull'attività
  `note_cliente` text DEFAULT NULL,                               -- note per il cliente
  `se_confermata` tinyint(1) DEFAULT NULL,                        -- flag che indica se l'attività è confermata
  `data_scadenza` date DEFAULT NULL,                              -- data di scadenza
  `ora_scadenza` time DEFAULT NULL,                               -- ora di scadenza
  `note_scadenza` text DEFAULT NULL,                              -- note sulla scadenza
  `id_anagrafica_programmazione` bigint(20) DEFAULT NULL,         -- chiave esterna per l'anagrafica di programmazione
  `data_programmazione` date DEFAULT NULL,                        -- data di programmazione
  `ora_inizio_programmazione` time DEFAULT NULL,                  -- ora di inizio programmazione
  `ora_fine_programmazione` time DEFAULT NULL,                    -- ora di fine programmazione
  `ore_programmazione` decimal(5,2) DEFAULT NULL,                 -- ore di programmazione
  `note_programmazione` text DEFAULT NULL,                        -- note sulla programmazione
  `data_attivita` date DEFAULT NULL,                              -- data dell'attività
  `ora_inizio` time DEFAULT NULL,                                 -- ora di inizio dell'attività
  `latitudine_ora_inizio` decimal(11,7) DEFAULT NULL,             -- latitudine al momento dell'inizio dell'attività
  `longitudine_ora_inizio` decimal(11,7) DEFAULT NULL,            -- longitudine al momento dell'inizio dell'attività
  `data_fine` date DEFAULT NULL,                                  -- data di fine dell'attività
  `ora_fine` time DEFAULT NULL,                                   -- ora di fine dell'attività
  `latitudine_ora_fine` decimal(11,7) DEFAULT NULL,               -- latitudine al momento della fine dell'attività
  `longitudine_ora_fine` decimal(11,7) DEFAULT NULL,              -- longitudine al momento della fine dell'attività
  `timestamp_calcolo_sostituti` int(11) DEFAULT NULL,             -- timestamp dell'ultimo calcolo dei sostituti
  `id_account_archiviazione` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha archiviato l'attività
  `data_archiviazione` date DEFAULT NULL,                         -- data di archiviazione
  `note_archiviazione` text DEFAULT NULL,                         -- note di archiviazione
  `id_account_inserimento` bigint(20) DEFAULT NULL,               -- chiave esterna per l'account che ha inserito l'attività
  `timestamp_inserimento` int(11) DEFAULT NULL,                   -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha aggiornato l'attività
  `timestamp_aggiornamento` int(11) DEFAULT NULL                  -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                           --

-- | 010000001900

-- attivita_asset
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: associa molti a molti le attività agli asset con cui vengono svolte
--
-- questa tabella contiene gli asset con cui si svolge un'attività ( attrezzi, mezzi, strumenti... ), che possono essere
-- più d'uno; l'asset su cui si svolge l'attività, che è uno solo, sta invece in attivita.id_asset
--
CREATE TABLE IF NOT EXISTS `attivita_asset` (                   --
  `id` bigint(20) NOT NULL,                                       -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                  -- ordine di visualizzazione
  `id_attivita` bigint(20) DEFAULT NULL,                          -- chiave esterna per l'attività
  `id_asset` bigint(20) DEFAULT NULL,                             -- chiave esterna per l'asset con cui si svolge l'attività
  `id_account_inserimento` bigint(20) DEFAULT NULL,               -- chiave esterna per l'account che ha inserito l'associazione
  `timestamp_inserimento` int(11) DEFAULT NULL,                   -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha aggiornato l'associazione
  `timestamp_aggiornamento` int(11) DEFAULT NULL                  -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                           --

-- | 010000002100

-- audio
-- tipologia: tabella gestita
-- rango: tabella secondaria
-- struttura: tabella base
-- funzione: contiene gli audio collegati agli oggetti delle tabelle principali
--
-- questa tabella fa parte del gruppo delle tabelle dei media ( audio, video, immagini, file ), che collegano un
-- media a un oggetto di una tabella principale; ogni riga descrive un oggetto solo, indicato da una delle chiavi
-- esterne id_*, ed è qualificata dalla lingua e dal ruolo che il media ha per quell'oggetto; lo stesso file può
-- descrivere più oggetti, e per questo le chiavi uniche sono una per oggetto e non una globale sul path
--
-- NOTA questa tabella è la gemella di video e ne ha le stesse colonne di collegamento, tranne orientamento e ratio
-- che per un audio non hanno senso; era sparita nel riallineamento del 2026-03-02 ed è stata rimessa il 2026-09-25
-- insieme a ruoli_audio, perché aggiungiAudio() e i form dei moduli la usano
--
-- NOTA un media può appartenere a ciascuno degli altri tre ( matrice dei media, decisa il 2026-10-16 ): per questo
-- l'audio ha id_file, id_video e id_immagine; la colonna sta sempre sul media che appartiene e punta a quello a cui
-- appartiene
--
-- NOTA le chiavi esterne verso gli oggetti descritti sono CASCADE: un audio non ha senso senza il suo oggetto, e
-- se l'oggetto viene cancellato le sue righe se ne vanno con lui
--
CREATE TABLE IF NOT EXISTS `audio` (                            --
  `id` bigint(20) NOT NULL,                                       -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                  -- ordine di visualizzazione dell'audio
  `nome` char(255) DEFAULT NULL,                                  -- nome dell'audio
  `id_anagrafica` bigint(20) DEFAULT NULL,                        -- chiave esterna per l'anagrafica descritta
  `id_annuncio` bigint(20) DEFAULT NULL,                          -- chiave esterna per l'annuncio descritto
  `id_prodotto` bigint(20) DEFAULT NULL,                          -- chiave esterna per il prodotto descritto
  `id_articolo` bigint(20) DEFAULT NULL,                          -- chiave esterna per l'articolo descritto
  `id_lingua` bigint(20) DEFAULT NULL,                            -- chiave esterna per la lingua dell'audio
  `id_indirizzo` bigint(20) DEFAULT NULL,                         -- chiave esterna per l'indirizzo descritto
  `id_progetto` bigint(20) DEFAULT NULL,                          -- chiave esterna per il progetto descritto
  `id_immobile` bigint(20) DEFAULT NULL,                          -- chiave esterna per l'immobile descritto
  `id_pagina` bigint(20) DEFAULT NULL,                            -- chiave esterna per la pagina descritta
  `id_file` bigint(20) DEFAULT NULL,                              -- chiave esterna per il file descritto
  `id_categoria_prodotti` bigint(20) DEFAULT NULL,                -- chiave esterna per la categoria prodotti descritta
  `id_marchio` bigint(20) DEFAULT NULL,                           -- chiave esterna per il marchio descritto
  `id_categoria_marchi` bigint(20) DEFAULT NULL,                  -- chiave esterna per la categoria di marchi descritta
  `id_risorsa` bigint(20) DEFAULT NULL,                           -- chiave esterna per la risorsa descritta
  `id_categoria_risorse` bigint(20) DEFAULT NULL,                 -- chiave esterna per la categoria risorse descritta
  `id_notizia` bigint(20) DEFAULT NULL,                           -- chiave esterna per la notizia descritta
  `id_categoria_notizie` bigint(20) DEFAULT NULL,                 -- chiave esterna per la categoria notizie descritta
  `id_categoria_annunci` bigint(20) DEFAULT NULL,                 -- chiave esterna per la categoria annunci descritta
  `id_categoria_progetti` bigint(20) DEFAULT NULL,                -- chiave esterna per la categoria progetti descritta
  `id_edificio` bigint(20) DEFAULT NULL,                          -- chiave esterna per l'edificio descritto
  `id_valutazione` bigint(20) DEFAULT NULL,                       -- chiave esterna per la valutazione descritta
  `id_video` bigint(20) DEFAULT NULL,                             -- chiave esterna per il video descritto
  `id_immagine` bigint(20) DEFAULT NULL,                          -- chiave esterna per l'immagine descritta
  `id_vano` bigint(20) DEFAULT NULL,                            -- chiave esterna per il vano descritto
  `id_ruolo` bigint(20) DEFAULT NULL,                             -- chiave esterna per il ruolo dell'audio
  `path` char(255) DEFAULT NULL,                                  -- percorso del file audio
  `embed` enum('html5','vimeo','youtube') DEFAULT NULL,           -- piattaforma dell'audio incorporato
  `codice_embed` char(128) DEFAULT NULL,                          -- codice dell'audio sulla piattaforma
  `embed_custom` char(128) DEFAULT NULL,                          -- codice di incorporamento personalizzato
  `target` char(255) DEFAULT NULL,                                -- destinazione del collegamento
  `note` text DEFAULT NULL,                                       -- note
  `id_account_inserimento` bigint(20) DEFAULT NULL,               -- account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                   -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,             -- account che ha aggiornato la riga per ultimo
  `timestamp_aggiornamento` int(11) DEFAULT NULL                  -- timestamp dell'ultimo aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000002250

-- badge
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene i badge, cioè i dispositivi di identificazione ( tesserini, chiavette RFID e simili )
--
-- un badge è un dispositivo, fisico o digitale, che identifica chi lo porta; si gestisce col modulo dei badge e
-- serve per i controlli di accesso e per gli scenari di automazione e domotica; il tipo di dispositivo è indicato
-- dalla tipologia, da tipologie_badge
--
-- NOTA un'anagrafica può essere titolare di più badge, e a un contratto possono essere associati più badge: per
-- questo il legame sta qui, nelle chiavi esterne id_*, come per le tabelle dei media, e non in una colonna id_badge
-- delle tabelle collegate; anagrafica.id_badge esce con la revisione dello schema canonico, contratti.id_badge e' gia' uscita
--
-- NOTA le chiavi esterne verso anagrafica e contratti sono SET NULL e non CASCADE come per i media: il badge è un
-- oggetto a sé, e se il titolare o il contratto vengono cancellati resta, non assegnato
--
CREATE TABLE IF NOT EXISTS `badge` (                            --
  `id` bigint(20) NOT NULL,                                       -- chiave primaria
  `id_tipologia` bigint(20) DEFAULT NULL,                         -- chiave esterna per la tipologia del badge
  `codice` char(32) DEFAULT NULL,                                 -- codice del badge, unico per tipologia
  `nome` char(255) DEFAULT NULL,                                  -- nome del badge
  `id_anagrafica` bigint(20) DEFAULT NULL,                        -- chiave esterna per l'anagrafica titolare del badge
  `id_contratto` bigint(20) DEFAULT NULL,                         -- chiave esterna per il contratto a cui è associato il badge
  `rfid` char(32) DEFAULT NULL,                                   -- codice RFID del badge, unico
  `note` text DEFAULT NULL,                                       -- note
  `id_account_inserimento` bigint(20) DEFAULT NULL,               -- account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                   -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,             -- account che ha aggiornato la riga per ultimo
  `timestamp_aggiornamento` int(11) DEFAULT NULL                  -- timestamp dell'ultimo aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000002300

-- banner
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene i banner, pubblicitari o informativi, da mostrare sui siti e sulle app
--
-- un banner è un elemento pubblicitario o informativo che si mostra sui siti e sulle app mobile; si gestisce col
-- modulo dei banner, che ne cura la generazione, la rotazione, la collocazione negli spazi e il tracciamento delle
-- visualizzazioni e dei click ( in banner_azioni ); il tipo di banner è indicato dalla tipologia, da tipologie_banner;
-- l'immagine e il testo del banner stanno nelle tabelle dei media, collegate con id_banner
--
-- un banner può essere legato a un contratto di affiliazione, per tracciare o alimentare i link affiliati: i click
-- sul banner vengono attribuiti a quel contratto, come per account.id_affiliazione
--
-- NOTA dove e quando il banner appare non sta qui ma in pubblicazioni, collegata con id_banner: ogni pubblicazione
-- è una collocazione, col sito o l'app, lo spazio, l'ordine e il periodo di validità
--
CREATE TABLE IF NOT EXISTS `banner` (                           --
  `id` bigint(20) NOT NULL,                                       -- chiave primaria
  `id_tipologia` bigint(20) DEFAULT NULL,                         -- chiave esterna per la tipologia del banner
  `ordine` int(11) DEFAULT NULL,                                  -- ordine di visualizzazione
  `nome` char(255) DEFAULT NULL,                                  -- nome del banner
  `id_inserzionista` bigint(20) DEFAULT NULL,                     -- chiave esterna per l'anagrafica inserzionista
  `id_affiliazione` bigint(20) DEFAULT NULL,                      -- chiave esterna per il contratto di affiliazione a cui vanno i click
  `larghezza` int(11) DEFAULT NULL,                               -- larghezza del banner in pixel
  `altezza` int(11) DEFAULT NULL,                                 -- altezza del banner in pixel
  `note` text DEFAULT NULL,                                       -- note
  `id_account_inserimento` bigint(20) DEFAULT NULL,               -- account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                   -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,             -- account che ha aggiornato la riga per ultimo
  `timestamp_aggiornamento` int(11) DEFAULT NULL                  -- timestamp dell'ultimo aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000002400

-- banner_azioni
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: mette in relazione banner e azioni
--
CREATE TABLE IF NOT EXISTS `banner_azioni` (
  `id` bigint(20) NOT NULL,
  `id_pagina` bigint(20) DEFAULT NULL,
  `id_banner` bigint(20) DEFAULT NULL,
  `azione` enum('visualizzazione','click') DEFAULT NULL,
  `timestamp_azione` int(11) DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000002500

-- banner_pagine
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: mette in relazione banner e pagine
--
CREATE TABLE IF NOT EXISTS `banner_pagine` (
  `id` bigint(20) NOT NULL,
  `id_pagina` bigint(20) DEFAULT NULL,
  `id_banner` bigint(20) DEFAULT NULL,
  `se_presente` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000002600

-- banner_zone
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: associa molti a molti i banner alle zone geografiche in cui devono comparire
--
-- è il targeting geografico del banner; le zone sono aree geografiche di rilevanza commerciale, logistica o
-- organizzativa che non coincidono con l'albero della geografia, e un banner associato a una zona compare
-- anche nelle zone figlie
--
-- NOTA vale la regola del framework "default ampio, specifiche a restringere": un banner senza righe qui compare
-- ovunque, un banner con righe compare solo in quelle zone; l'esclusione esplicita non c'è
--
-- NOTA questa tabella dice dove il banner può comparire geograficamente, non dove è collocato: la collocazione
-- ( sito o app, pagina, spazio, periodo ) sta in pubblicazioni, collegata con id_banner
--
CREATE TABLE IF NOT EXISTS `banner_zone` (                      --
  `id` bigint(20) NOT NULL,                                       -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                  -- ordine di visualizzazione
  `id_banner` bigint(20) DEFAULT NULL,                            -- chiave esterna per il banner
  `id_zona` bigint(20) DEFAULT NULL,                              -- chiave esterna per la zona
  `id_account_inserimento` bigint(20) DEFAULT NULL,               -- account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                   -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,             -- account che ha aggiornato la riga per ultimo
  `timestamp_aggiornamento` int(11) DEFAULT NULL                  -- timestamp dell'ultimo aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                             --

-- | 010000002700

-- campagne
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella ricorsiva
-- funzione: contiene le campagne, cioè i contenitori delle iniziative che avvengono per step ( funnel di marketing, DEM... )
--
-- una campagna è un contenitore per un'iniziativa che si svolge a step, come un funnel di marketing o una DEM; ha
-- un proprio budget e un periodo di svolgimento, e le si attribuiscono i contatti e i carrelli che ha portato
-- ( contatti.id_campagna, carrelli.id_campagna ); le campagne si possono annidare con id_genitore, per esempio
-- una campagna annuale che contiene le campagne stagionali; il tipo di campagna è indicato dalla tipologia, da
-- tipologie_campagne
--
-- il codice è l'identificativo interno della campagna, distinto dai tag UTM: questi ultimi sono quelli con cui la
-- campagna si presenta all'esterno, e sono gli stessi che contatti registra all'arrivo del contatto
--
-- NOTA gli step della campagna non sono campagne figlie: stanno nella tabella step
--
-- NOTA i risultati della campagna non sono colonne: si calcolano nella vista, dai contatti e dai carrelli attribuiti
--
CREATE TABLE IF NOT EXISTS `campagne` (                         --
  `id` bigint(20) NOT NULL,                                       -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                          -- chiave esterna per la campagna genitore
  `id_tipologia` bigint(20) DEFAULT NULL,                         -- chiave esterna per la tipologia della campagna
  `ordine` int(11) DEFAULT NULL,                                  -- ordine di visualizzazione
  `codice` char(32) DEFAULT NULL,                                 -- codice interno della campagna, distinto dai tag UTM
  `nome` char(128) DEFAULT NULL,                                  -- nome della campagna
  `id_valuta` bigint(20) DEFAULT NULL,                            -- chiave esterna per la valuta del budget
  `testo` text DEFAULT NULL,                                      -- testo della campagna
  `note` text DEFAULT NULL,                                       -- note
  `budget` decimal(16,2) DEFAULT NULL,                            -- budget della campagna
  `utm_id` char(128) DEFAULT NULL,                                -- UTM id
  `utm_source` char(128) DEFAULT NULL,                            -- UTM source
  `utm_medium` char(128) DEFAULT NULL,                            -- UTM medium
  `utm_campaign` char(128) DEFAULT NULL,                          -- UTM campaign
  `utm_term` char(128) DEFAULT NULL,                              -- UTM term
  `utm_content` char(128) DEFAULT NULL,                           -- UTM content
  `data_inizio` date DEFAULT NULL,                                -- data di inizio della campagna
  `data_fine` date DEFAULT NULL,                                  -- data di fine della campagna
  `id_account_inserimento` bigint(20) DEFAULT NULL,               -- account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                   -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,             -- account che ha aggiornato la riga per ultimo
  `timestamp_aggiornamento` int(11) DEFAULT NULL                  -- timestamp dell'ultimo aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                             --

-- | 010000002900

-- caratteristiche
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella ricorsiva
-- funzione: contiene l albero delle caratteristiche di prodotti, articoli, immobili, edifici e indirizzi
--
-- i nodi di primo livello sono i gruppi ( "Linea mandrino", "Capacita'" ) e i figli le caratteristiche; i flag se_*
-- dicono a quali oggetti si applica un nodo, e i form li usano per mostrare nelle tendine solo le caratteristiche
-- pertinenti; il codice e' la chiave stabile per gli import da gestionale, che altrimenti agganciano per nome. Fino al 01/10/2026 l'albero dei prodotti stava in una tabella a parte,
-- caratteristiche_prodotti, che ora e' una vista su questa con i nomi di colonna di allora ( vedi la patch
-- _202610011700.caratteristiche.albero.sql ).
--
-- ATTENZIONE all'indice unico ( nome, id_genitore ): in MySQL i NULL non fanno mai conflitto su un indice unico, quindi
-- NON protegge i nodi di radice, che id_genitore ce l'hanno NULL. Chi scrive qui deve passare la chiave di ricerca
-- esplicita a mysqlInsertRow(), altrimenti a ogni importazione nasce una radice nuova.
CREATE TABLE IF NOT EXISTS `caratteristiche` (                  --
  `id` bigint(20) NOT NULL,                                       -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                          -- chiave esterna per il gruppo genitore
  `ordine` int(11) DEFAULT NULL,                                  -- ordine di visualizzazione
  `codice` char(32) DEFAULT NULL,                                 -- codice della caratteristica, chiave per gli import
  `nome` char(64) DEFAULT NULL,                                   -- nome della caratteristica
  `font_awesome` char(24) DEFAULT NULL,                           -- icona Font Awesome
  `html_entity` char(8) DEFAULT NULL,                             -- icona come entità HTML
  `se_prodotti` tinyint(1) DEFAULT NULL,                          -- flag per le caratteristiche assegnabili ai prodotti
  `se_articoli` tinyint(1) DEFAULT NULL,                          -- flag per le caratteristiche assegnabili agli articoli
  `se_immobili` tinyint(1) DEFAULT NULL,                          -- flag per le caratteristiche assegnabili agli immobili
  `se_edifici` tinyint(1) DEFAULT NULL,                           -- flag per le caratteristiche assegnabili agli edifici
  `se_indirizzi` tinyint(1) DEFAULT NULL,                         -- flag per le caratteristiche assegnabili agli indirizzi
  `se_vani` tinyint(1) DEFAULT NULL,                            -- flag per le caratteristiche assegnabili ai vani
  `id_account_inserimento` bigint(20) DEFAULT NULL,               -- account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                   -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,             -- account che ha aggiornato la riga per ultimo
  `timestamp_aggiornamento` int(11) DEFAULT NULL                  -- timestamp dell'ultimo aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                             --

-- | 010000002920

-- prodotti_caratteristiche
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: collega un prodotto alle sue caratteristiche
--
-- questa tabella collega un prodotto all'albero delle caratteristiche ( caratteristiche ) e ne
-- porta il valore. E' la gemella di articoli_caratteristiche, senza la colonna se_assente, che
-- serve solo alle voci di listino.
--
-- NOTA: il valore e' per lingua, quindi la stessa caratteristica puo' comparire su un prodotto una
-- volta per ogni lingua; per questo id_lingua fa parte della chiave unica ( decisione del 12/10/2026,
-- come per articoli_caratteristiche ). Le righe con id_lingua a NULL non sono protette dalla chiave
-- unica, perche' MySQL non considera uguali due NULL.
--
CREATE TABLE IF NOT EXISTS `prodotti_caratteristiche` (
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                -- ordine di visualizzazione
  `id_prodotto` bigint(20) DEFAULT NULL,                        -- chiave esterna per il prodotto
  `id_caratteristica` bigint(20) DEFAULT NULL,                  -- chiave esterna per la caratteristica
  `id_lingua` bigint(20) DEFAULT NULL,                          -- chiave esterna per la lingua del valore
  `valore` text DEFAULT NULL,                                   -- valore della caratteristica
  `note` text DEFAULT NULL,                                     -- note
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account di inserimento
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account di aggiornamento
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000003050

-- carrelli_articoli
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: contiene le righe dei carrelli
--
-- questa tabella contiene le righe di un carrello: l'articolo acquistato, i prezzi, gli sconti e il coupon
-- applicati, e i dati per l'evasione della singola riga.
--
-- NOTA: le colonne destinatario_* ripetono quelle della testata ( carrelli ) perche' un ordine puo' essere fatto
-- per piu' persone diverse: il carrello porta l'ordinante, l'intestatario e il destinatario "master", e ogni riga
-- puo' avere il suo destinatario ( un genitore che iscrive i figli ai corsi, un primario che iscrive i
-- collaboratori a corsi ECM diversi ). Per questo il destinatario fa parte della chiave unica: lo stesso
-- articolo puo' stare nel carrello una volta per destinatario. Le righe senza destinatario ( NULL ) non sono
-- protette dalla chiave unica, perche' MySQL non considera uguali due NULL.
--
CREATE TABLE IF NOT EXISTS `carrelli_articoli` (
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                -- ordine di visualizzazione
  `id_carrello` bigint(20) DEFAULT NULL,                        -- chiave esterna per il carrello
  `id_articolo` bigint(20) DEFAULT NULL,                        -- chiave esterna per l'articolo
  `id_listino` bigint(20) DEFAULT NULL,                         -- chiave esterna per il listino da cui viene il prezzo
  `id_iva` bigint(20) DEFAULT NULL,                             -- chiave esterna per l'aliquota IVA
  `id_pagamento` bigint(20) DEFAULT NULL,                       -- chiave esterna per il pagamento della riga
  `id_rinnovo` bigint(20) DEFAULT NULL,                         -- chiave esterna per il rinnovo generato dalla riga
  `id_mastro_provenienza` bigint(20) DEFAULT NULL,              -- chiave esterna per il mastro da cui esce la merce
  `categorie` char(255) DEFAULT NULL,                           -- categorie dell'articolo al momento dell'acquisto
  `prodotto` char(255) DEFAULT NULL,                            -- prodotto dell'articolo al momento dell'acquisto
  `descrizione` char(255) DEFAULT NULL,                         -- descrizione della riga
  `prezzo_netto_unitario` decimal(16,5) DEFAULT NULL,           -- prezzo unitario netto
  `prezzo_lordo_unitario` decimal(16,5) DEFAULT NULL,           -- prezzo unitario lordo
  `quantita` int(11) DEFAULT NULL,                              -- quantità
  `prezzo_netto_totale` decimal(16,5) DEFAULT NULL,             -- prezzo netto per la quantità
  `prezzo_lordo_totale` decimal(16,5) DEFAULT NULL,             -- prezzo lordo per la quantità
  `costo_spedizione_netto` decimal(16,5) DEFAULT NULL,          -- costo di spedizione netto
  `costo_spedizione_lordo` decimal(16,5) DEFAULT NULL,          -- costo di spedizione lordo
  `sconto_percentuale` decimal(16,5) DEFAULT NULL,              -- sconto in percentuale
  `sconto_valore` decimal(16,5) DEFAULT NULL,                   -- sconto in valore
  `id_coupon` bigint(20) DEFAULT NULL,                          -- chiave esterna per il coupon applicato
  `coupon_percentuale` decimal(16,5) DEFAULT NULL,              -- sconto del coupon in percentuale
  `coupon_valore` decimal(16,5) DEFAULT NULL,                   -- sconto del coupon in valore
  `prezzo_netto_finale` decimal(16,5) DEFAULT NULL,             -- prezzo netto finale, scontato e con la spedizione
  `prezzo_lordo_finale` decimal(16,5) DEFAULT NULL,             -- prezzo lordo finale, scontato e con la spedizione
  `note` text DEFAULT NULL,                                     -- note
  `destinatario_nome` char(255) DEFAULT NULL,                   -- nome del destinatario della riga
  `destinatario_cognome` char(255) DEFAULT NULL,                -- cognome del destinatario
  `destinatario_denominazione` char(255) DEFAULT NULL,          -- denominazione del destinatario
  `destinatario_id_tipologia_anagrafica` bigint(20) DEFAULT NULL,-- chiave esterna per la tipologia anagrafica del destinatario
  `destinatario_id_anagrafica` bigint(20) DEFAULT NULL,         -- chiave esterna per l'anagrafica del destinatario
  `destinatario_id_account` bigint(20) DEFAULT NULL,            -- chiave esterna per l'account del destinatario
  `destinatario_indirizzo` char(255) DEFAULT NULL,              -- indirizzo del destinatario
  `destinatario_cap` char(16) DEFAULT NULL,                     -- CAP del destinatario
  `destinatario_citta` char(255) DEFAULT NULL,                  -- città del destinatario
  `destinatario_id_comune` bigint(20) DEFAULT NULL,             -- chiave esterna per il comune del destinatario
  `destinatario_id_provincia` bigint(20) DEFAULT NULL,          -- chiave esterna per la provincia del destinatario
  `destinatario_id_stato` bigint(20) DEFAULT NULL,              -- chiave esterna per lo stato del destinatario
  `destinatario_telefono` char(255) DEFAULT NULL,               -- telefono del destinatario
  `destinatario_mobile` char(255) DEFAULT NULL,                 -- cellulare del destinatario
  `destinatario_fax` char(255) DEFAULT NULL,                    -- fax del destinatario
  `destinatario_mail` char(255) DEFAULT NULL,                   -- mail del destinatario
  `destinatario_codice_fiscale` char(255) DEFAULT NULL,         -- codice fiscale del destinatario
  `destinatario_partita_iva` char(255) DEFAULT NULL,            -- partita IVA del destinatario
  `destinatario_id_comune_nascita` bigint(20) DEFAULT NULL,     -- chiave esterna per il comune di nascita del destinatario
  `destinatario_id_provincia_nascita` bigint(20) DEFAULT NULL,  -- chiave esterna per la provincia di nascita del destinatario
  `destinatario_id_stato_nascita` bigint(20) DEFAULT NULL,      -- chiave esterna per lo stato di nascita del destinatario
  `destinatario_giorno_nascita` int(2) DEFAULT NULL,            -- giorno di nascita del destinatario
  `destinatario_mese_nascita` int(2) DEFAULT NULL,              -- mese di nascita del destinatario
  `destinatario_anno_nascita` int(4) DEFAULT NULL,              -- anno di nascita del destinatario
  `id_account_evasione` bigint(20) DEFAULT NULL,                -- chiave esterna per l'account che ha evaso la riga
  `timestamp_evasione` int(11) DEFAULT NULL,                    -- timestamp di evasione
  `note_evasione` text DEFAULT NULL,                            -- note di evasione
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account di inserimento
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account di aggiornamento
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000003060

-- carrelli_consensi
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: registra i consensi prestati al momento del checkout
--
-- questa tabella registra, per ogni carrello, i consensi ( privacy, condizioni di vendita, marketing... ) che
-- l'intestatario ha prestato o negato al momento del checkout; e' la prova legale del consenso, quindi le righe
-- si scrivono sempre e non si cancellano a mano.
--
-- NOTA: id_anagrafica e id_account fotografano l'intestatario del carrello al momento del consenso ( i campi
-- intestazione_* di carrelli ); la chiave unica ( id_carrello, id_consenso ) fa si' che una nuova prestazione
-- dello stesso consenso sullo stesso carrello aggiorni la riga invece di duplicarla.
--
CREATE TABLE IF NOT EXISTS `carrelli_consensi` (
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                -- ordine di visualizzazione
  `id_carrello` bigint(20) DEFAULT NULL,                        -- chiave esterna per il carrello in cui e' stato prestato il consenso
  `id_anagrafica` bigint(20) DEFAULT NULL,                      -- chiave esterna per l'anagrafica intestataria del carrello
  `id_account` bigint(20) DEFAULT NULL,                         -- chiave esterna per l'account intestatario del carrello
  `id_consenso` bigint(20) DEFAULT NULL,                        -- chiave esterna per il consenso
  `note` text DEFAULT NULL,                                     -- descrizione del consenso ( data, ora e carrello )
  `se_prestato` tinyint(1) DEFAULT NULL,                        -- flag consenso prestato
  `timestamp_consenso` int(11) DEFAULT NULL,                    -- timestamp di prestazione del consenso
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account di inserimento
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account di aggiornamento
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000003065

-- distinta
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: contiene la distinta base degli articoli
--
-- questa tabella dice di quali componenti, e in che quantita', e' fatto un articolo: id_articolo e' il composto,
-- id_componente l'articolo che ne fa parte; le righe si compilano dalla scheda distinta dell'articolo composto
--
-- NOTA id_componente non segue la cascata: un articolo che compare nella distinta di un altro non si puo' cancellare
-- finche' non lo si toglie dalla distinta, altrimenti la distinta del composto resterebbe incompleta senza avviso
--
CREATE TABLE IF NOT EXISTS `distinta` (
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                -- ordine di visualizzazione
  `id_articolo` bigint(20) DEFAULT NULL,                        -- chiave esterna per l'articolo composto
  `id_componente` bigint(20) DEFAULT NULL,                      -- chiave esterna per l'articolo che entra nella composizione
  `quantita` decimal(16,5) DEFAULT NULL,                        -- quantita' del componente nell'articolo composto
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account di inserimento
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account di aggiornamento
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000003070

-- carrelli_documenti
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: mette in relazione carrelli e documenti
--
CREATE TABLE IF NOT EXISTS `carrelli_documenti` (
  `id` bigint(20) NOT NULL,
  `id_carrello` bigint(20) DEFAULT NULL,
  `id_documento` bigint(20) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000003080

-- casse_previdenziali
-- tipologia: tabella standard
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene le casse previdenziali della fattura elettronica
--
-- le casse di previdenza delle categorie professionali, col codice TipoCassa ( TC01 - TC22 ) che la fattura
-- elettronica scrive nel blocco DatiCassaPrevidenziale; la tabella si usa per scegliere la cassa nei dati fiscali
-- dei documenti, attraverso documenti_casse_previdenziali.
--
-- NOTA: l'elenco e' quello chiuso delle specifiche tecniche, e lo carica il 050 con le descrizioni dell'enumerazione
-- TipoCassaType dello schema XSD; quando le specifiche cambiano si aggiorna con una patch, non a mano. Le righe
-- usate da un documento non si cancellano ( documenti_casse_previdenziali punta qui con NO ACTION ).
CREATE TABLE IF NOT EXISTS `casse_previdenziali` (              --
  `id` bigint(20) NOT NULL,                                       -- chiave primaria
  `codice` char(32) DEFAULT NULL,                                 -- codice TipoCassa della fattura elettronica
  `nome` char(255) DEFAULT NULL                                   -- nome della cassa previdenziale
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                             --

-- | 010000003100

-- categorie_anagrafica
-- tipologia: tabella assistita
-- rango: tabella principale
-- struttura: tabella ricorsiva
-- funzione: contiene l albero delle categorie delle anagrafiche
--
-- le anagrafiche si associano alle categorie tramite anagrafica_categorie, anche a piu' d'una; i flag di un'anagrafica
-- sono il massimo dei flag delle sue categorie, propagato in anagrafica_view_static. I flag se_* sono di due famiglie:
-- i flag di ruolo dicono cosa e' l'anagrafica per l'azienda ( lead, prospect, cliente, fornitore, partner... ) e in
-- quale segmento dell'organigramma sta ( amministrazione, produzione, commerciale, logistica, simmetrici a ruoli_mastri );
-- i flag di associabilita' ( da se_annunci a se_risorse ) dicono a quali oggetti l'anagrafica puo' essere associata,
-- cioe' in quali tendine compare: p.es. gli autori delle notizie o delle risorse, gli inquilini degli immobili. Sono lo
-- specchio dei flag di ruoli_anagrafica: il ruolo dice a che titolo un'anagrafica e' associata, la categoria chi puo'
-- esserlo.
--
-- NOTA se_interno e se_esterno dicono se un collaboratore fa parte dell'organigramma; se e' un dipendente non lo dice
-- la categoria, lo dice il contratto ( tabella contratti ). se_produzione qui e' un segmento dell'organigramma, mentre
-- l'omonimo flag di ruoli_anagrafica e' di associabilita'.
--
-- ATTENZIONE all'indice unico ( id_genitore, nome ): in MySQL i NULL non fanno mai conflitto su un indice unico, quindi
-- NON protegge le categorie di radice, che id_genitore ce l'hanno NULL. Chi scrive qui deve passare la chiave di ricerca
-- esplicita a mysqlInsertRow(), altrimenti a ogni importazione nasce una radice nuova.
CREATE TABLE IF NOT EXISTS `categorie_anagrafica` (               --
  `id` bigint(20) NOT NULL,                                       -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                          -- chiave esterna per la categoria genitore
  `ordine` int(11) DEFAULT NULL,                                  -- ordine di visualizzazione
  `codice` char(32) DEFAULT NULL,                                 -- codice della categoria, chiave stabile per gli import
  `nome` char(255) DEFAULT NULL,                                  -- nome della categoria
  `note` text DEFAULT NULL,                                       -- note sulla categoria
  `se_lead` tinyint(1) DEFAULT NULL,                              -- contatto identificato ma non ancora lavorato commercialmente
  `se_prospect` tinyint(1) DEFAULT NULL,                          -- contatto lavorato commercialmente che non ha ancora acquistato
  `se_cliente` tinyint(1) DEFAULT NULL,                           -- ha acquistato almeno una volta
  `se_fornitore` tinyint(1) DEFAULT NULL,                         -- fornisce beni o servizi all'azienda
  `se_produttore` tinyint(1) DEFAULT NULL,                        -- produce i beni ( il marchio ), distinto da chi li vende
  `se_corriere` tinyint(1) DEFAULT NULL,                          -- fornisce servizi di spedizione, vettore nei documenti di trasporto
  `se_collaboratore` tinyint(1) DEFAULT NULL,                     -- persona che collabora con l'azienda a qualsiasi titolo
  `se_interno` tinyint(1) DEFAULT NULL,                           -- fa parte dell'organigramma
  `se_esterno` tinyint(1) DEFAULT NULL,                           -- collaboratore che non fa parte dell'organigramma
  `se_concorrente` tinyint(1) DEFAULT NULL,                       -- concorrente sullo stesso mercato
  `se_partner` tinyint(1) DEFAULT NULL,                           -- azienda con cui si collabora alla pari, contrario di concorrente
  `se_gestita` tinyint(1) DEFAULT NULL,                           -- azienda per cui il gestionale emette documenti e tiene la contabilita'
  `se_amministrazione` tinyint(1) DEFAULT NULL,                   -- segmento amministrazione dell'organigramma
  `se_produzione` tinyint(1) DEFAULT NULL,                        -- segmento produzione dell'organigramma
  `se_commerciale` tinyint(1) DEFAULT NULL,                       -- segmento commerciale dell'organigramma
  `se_logistica` tinyint(1) DEFAULT NULL,                         -- segmento logistica dell'organigramma
  `se_annunci` tinyint(1) DEFAULT NULL,                           -- associabile agli annunci
  `se_contratti` tinyint(1) DEFAULT NULL,                         -- associabile ai contratti
  `se_didattica` tinyint(1) DEFAULT NULL,                         -- associabile ai corsi e alla didattica
  `se_immobili` tinyint(1) DEFAULT NULL,                          -- associabile agli immobili ( p.es. inquilini, proprietari )
  `se_notizie` tinyint(1) DEFAULT NULL,                           -- associabile alle notizie ( p.es. autori )
  `se_organizzazioni` tinyint(1) DEFAULT NULL,                    -- associabile alle organizzazioni
  `se_progetti` tinyint(1) DEFAULT NULL,                          -- associabile ai progetti
  `se_relazioni` tinyint(1) DEFAULT NULL,                         -- associabile alle relazioni fra anagrafiche
  `se_risorse` tinyint(1) DEFAULT NULL,                           -- associabile alle risorse ( p.es. autori )
  `id_account_inserimento` bigint(20) DEFAULT NULL,               -- account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                   -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,             -- account che ha aggiornato la riga per ultimo
  `timestamp_aggiornamento` int(11) DEFAULT NULL                  -- timestamp dell'ultimo aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                             --

-- | 010000003300

-- categorie_annunci
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella ricorsiva
-- funzione: contiene l albero delle categorie degli annunci
--
-- gli annunci si associano alle categorie tramite annunci_categorie, anche a piu' d'una. Ogni categoria genera una
-- pagina del sito, quindi porta il blocco web ( template, schema_html, tema_css, se_sitemap, se_cacheable, id_sito,
-- id_pagina ) ed e' una delle sei tabelle categorie_* che seguono lo stesso modello ( annunci, marchi, notizie, prodotti,
-- progetti, risorse: stesse colonne, indici, chiavi esterne, funzioni _path e vista ).
--
-- NOTA id_pagina e' la pagina sotto cui si appende la categoria nell'albero del sito; id_sito non ha chiave esterna
-- perche' i siti sono definiti nella configurazione, non nel database.
--
-- ATTENZIONE all'indice unico ( id_genitore, nome ): in MySQL i NULL non fanno mai conflitto su un indice unico, quindi
-- NON protegge le categorie di radice, che id_genitore ce l'hanno NULL.
CREATE TABLE IF NOT EXISTS `categorie_annunci` (                  --
  `id` bigint(20) NOT NULL,                                       -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                          -- chiave esterna per la categoria genitore
  `ordine` int(11) DEFAULT NULL,                                  -- ordine di visualizzazione
  `codice` char(32) DEFAULT NULL,                                 -- codice della categoria, chiave stabile per gli import
  `nome` char(255) DEFAULT NULL,                                  -- nome della categoria
  `note` text DEFAULT NULL,                                       -- note sulla categoria
  `template` char(255) DEFAULT NULL,                              -- template con cui si mostra la pagina della categoria
  `schema_html` char(128) DEFAULT NULL,                           -- schema HTML del template
  `tema_css` char(128) DEFAULT NULL,                              -- tema CSS del template
  `se_sitemap` tinyint(1) DEFAULT NULL,                           -- la pagina della categoria va nella sitemap
  `se_cacheable` tinyint(1) DEFAULT NULL,                         -- la pagina della categoria si puo' mettere in cache
  `id_sito` bigint(20) DEFAULT NULL,                              -- sito della configurazione a cui appartiene la pagina
  `id_pagina` bigint(20) DEFAULT NULL,                            -- chiave esterna per la pagina genitore nell'albero del sito
  `data_archiviazione` date DEFAULT NULL,                         -- data di archiviazione
  `note_archiviazione` text DEFAULT NULL,                         -- note di archiviazione
  `id_account_inserimento` bigint(20) DEFAULT NULL,               -- account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                   -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,             -- account che ha aggiornato la riga per ultimo
  `timestamp_aggiornamento` int(11) DEFAULT NULL                  -- timestamp dell'ultimo aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                             --

-- | 010000003400

-- categorie_conversazioni
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella ricorsiva
-- funzione: contiene l albero delle categorie delle conversazioni
--
-- le conversazioni si associano alle categorie tramite conversazioni_categorie, anche a piu' d'una; l'albero serve a
-- organizzare le conversazioni per argomento, p.es. le sezioni di un forum. E' un classificatore sul modello di
-- categorie_anagrafica, non genera pagine: non ha il blocco web delle sei categorie_* che le generano.
--
-- NOTA se un giorno il forum diventa pubblico, con le pagine delle categorie nel sito, la tabella prende il blocco
-- web e l'archiviazione del modello delle categorie_* che generano pagine; il passaggio e' solo additivo.
--
-- ATTENZIONE all'indice unico ( id_genitore, nome ): in MySQL i NULL non fanno mai conflitto su un indice unico, quindi
-- NON protegge le categorie di radice, che id_genitore ce l'hanno NULL.
CREATE TABLE IF NOT EXISTS `categorie_conversazioni` (           --
  `id` bigint(20) NOT NULL,                                       -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                          -- chiave esterna per la categoria genitore
  `ordine` int(11) DEFAULT NULL,                                  -- ordine di visualizzazione
  `codice` char(32) DEFAULT NULL,                                 -- codice della categoria, chiave stabile per gli import
  `nome` char(255) DEFAULT NULL,                                  -- nome della categoria
  `note` text DEFAULT NULL,                                       -- note sulla categoria
  `id_account_inserimento` bigint(20) DEFAULT NULL,               -- account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                   -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,             -- account che ha aggiornato la riga per ultimo
  `timestamp_aggiornamento` int(11) DEFAULT NULL                  -- timestamp dell'ultimo aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                             --

-- | 010000003500

-- categorie_marchi
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella ricorsiva
-- funzione: contiene l albero delle categorie dei marchi
--
-- i marchi si associano alle categorie tramite marchi_categorie, anche a piu' d'una, e le categorie sono l'albero
-- di navigazione delle pagine dei marchi. Ogni categoria genera una pagina del sito ( modulo prodotti, da scrivere:
-- TODO di glisdev ), quindi porta il blocco web ( template, schema_html, tema_css, se_sitemap, se_cacheable,
-- id_sito, id_pagina ) ed e' una delle sei tabelle categorie_* che seguono lo stesso modello ( annunci, marchi,
-- notizie, prodotti, progetti, risorse: stesse colonne, indici, chiavi esterne, funzioni _path e vista ).
--
-- NOTA id_pagina e' la pagina sotto cui si appende la categoria nell'albero del sito; id_sito non ha chiave esterna
-- perche' i siti sono definiti nella configurazione, non nel database.
--
-- ATTENZIONE all'indice unico ( id_genitore, nome ): in MySQL i NULL non fanno mai conflitto su un indice unico, quindi
-- NON protegge le categorie di radice, che id_genitore ce l'hanno NULL.
CREATE TABLE IF NOT EXISTS `categorie_marchi` (                  --
  `id` bigint(20) NOT NULL,                                       -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                          -- chiave esterna per la categoria genitore
  `ordine` int(11) DEFAULT NULL,                                  -- ordine di visualizzazione
  `codice` char(32) DEFAULT NULL,                                 -- codice della categoria, chiave stabile per gli import
  `nome` char(255) DEFAULT NULL,                                  -- nome della categoria
  `note` text DEFAULT NULL,                                       -- note sulla categoria
  `template` char(255) DEFAULT NULL,                              -- template con cui si mostra la pagina della categoria
  `schema_html` char(128) DEFAULT NULL,                           -- schema HTML del template
  `tema_css` char(128) DEFAULT NULL,                              -- tema CSS del template
  `se_sitemap` tinyint(1) DEFAULT NULL,                           -- la pagina della categoria va nella sitemap
  `se_cacheable` tinyint(1) DEFAULT NULL,                         -- la pagina della categoria si puo' mettere in cache
  `id_sito` bigint(20) DEFAULT NULL,                              -- sito della configurazione a cui appartiene la pagina
  `id_pagina` bigint(20) DEFAULT NULL,                            -- chiave esterna per la pagina genitore nell'albero del sito
  `data_archiviazione` date DEFAULT NULL,                         -- data di archiviazione
  `note_archiviazione` text DEFAULT NULL,                         -- note di archiviazione
  `id_account_inserimento` bigint(20) DEFAULT NULL,               -- account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                   -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,             -- account che ha aggiornato la riga per ultimo
  `timestamp_aggiornamento` int(11) DEFAULT NULL                  -- timestamp dell'ultimo aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                             --

-- | 010000003700

-- categorie_notizie
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella ricorsiva
-- funzione: contiene l albero delle categorie delle notizie
--
-- le notizie si associano alle categorie tramite notizie_categorie, anche a piu' d'una. Ogni categoria genera una
-- pagina del sito ( modulo notizie, _310.pages.php ), quindi porta il blocco web ( template, schema_html, tema_css,
-- se_sitemap, se_cacheable, id_sito, id_pagina ) ed e' una delle sei tabelle categorie_* che seguono lo stesso
-- modello ( annunci, marchi, notizie, prodotti, progetti, risorse: stesse colonne, indici, chiavi esterne, funzioni _path e
-- vista ).
--
-- NOTA id_pagina e' la pagina sotto cui si appende la categoria nell'albero del sito; id_sito non ha chiave esterna
-- perche' i siti sono definiti nella configurazione, non nel database.
--
-- ATTENZIONE all'indice unico ( id_genitore, nome ): in MySQL i NULL non fanno mai conflitto su un indice unico, quindi
-- NON protegge le categorie di radice, che id_genitore ce l'hanno NULL.
CREATE TABLE IF NOT EXISTS `categorie_notizie` (                  --
  `id` bigint(20) NOT NULL,                                       -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                          -- chiave esterna per la categoria genitore
  `ordine` int(11) DEFAULT NULL,                                  -- ordine di visualizzazione
  `codice` char(32) DEFAULT NULL,                                 -- codice della categoria, chiave stabile per gli import
  `nome` char(255) DEFAULT NULL,                                  -- nome della categoria
  `note` text DEFAULT NULL,                                       -- note sulla categoria
  `template` char(255) DEFAULT NULL,                              -- template con cui si mostra la pagina della categoria
  `schema_html` char(128) DEFAULT NULL,                           -- schema HTML del template
  `tema_css` char(128) DEFAULT NULL,                              -- tema CSS del template
  `se_sitemap` tinyint(1) DEFAULT NULL,                           -- la pagina della categoria va nella sitemap
  `se_cacheable` tinyint(1) DEFAULT NULL,                         -- la pagina della categoria si puo' mettere in cache
  `id_sito` bigint(20) DEFAULT NULL,                              -- sito della configurazione a cui appartiene la pagina
  `id_pagina` bigint(20) DEFAULT NULL,                            -- chiave esterna per la pagina genitore nell'albero del sito
  `data_archiviazione` date DEFAULT NULL,                         -- data di archiviazione
  `note_archiviazione` text DEFAULT NULL,                         -- note di archiviazione
  `id_account_inserimento` bigint(20) DEFAULT NULL,               -- account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                   -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,             -- account che ha aggiornato la riga per ultimo
  `timestamp_aggiornamento` int(11) DEFAULT NULL                  -- timestamp dell'ultimo aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                             --

-- | 010000003900

-- categorie_prodotti
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella ricorsiva
-- funzione: contiene l albero delle categorie di prodotti
--
-- i prodotti si associano alle categorie tramite prodotti_categorie, anche a piu' d'una. Ogni categoria genera una
-- pagina del sito ( modulo prodotti, _310.pages.php ), quindi porta il blocco web ( template, schema_html, tema_css,
-- se_sitemap, se_cacheable, id_sito, id_pagina ) ed e' una delle sei tabelle categorie_* che seguono lo stesso
-- modello ( annunci, marchi, notizie, prodotti, progetti, risorse: stesse colonne, indici, chiavi esterne, funzioni _path e
-- vista ).
--
-- NOTA id_pagina e' la pagina sotto cui si appende la categoria nell'albero del sito; id_sito non ha chiave esterna
-- perche' i siti sono definiti nella configurazione, non nel database.
--
-- ATTENZIONE all'indice unico ( id_genitore, nome ): in MySQL i NULL non fanno mai conflitto su un indice unico, quindi
-- NON protegge le categorie di radice, che id_genitore ce l'hanno NULL.
CREATE TABLE IF NOT EXISTS `categorie_prodotti` (                 --
  `id` bigint(20) NOT NULL,                                       -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                          -- chiave esterna per la categoria genitore
  `ordine` int(11) DEFAULT NULL,                                  -- ordine di visualizzazione
  `codice` char(32) DEFAULT NULL,                                 -- codice della categoria, chiave stabile per gli import
  `nome` char(255) DEFAULT NULL,                                  -- nome della categoria
  `note` text DEFAULT NULL,                                       -- note sulla categoria
  `template` char(255) DEFAULT NULL,                              -- template con cui si mostra la pagina della categoria
  `schema_html` char(128) DEFAULT NULL,                           -- schema HTML del template
  `tema_css` char(128) DEFAULT NULL,                              -- tema CSS del template
  `se_sitemap` tinyint(1) DEFAULT NULL,                           -- la pagina della categoria va nella sitemap
  `se_cacheable` tinyint(1) DEFAULT NULL,                         -- la pagina della categoria si puo' mettere in cache
  `id_sito` bigint(20) DEFAULT NULL,                              -- sito della configurazione a cui appartiene la pagina
  `id_pagina` bigint(20) DEFAULT NULL,                            -- chiave esterna per la pagina genitore nell'albero del sito
  `data_archiviazione` date DEFAULT NULL,                         -- data di archiviazione
  `note_archiviazione` text DEFAULT NULL,                         -- note di archiviazione
  `id_account_inserimento` bigint(20) DEFAULT NULL,               -- account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                   -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,             -- account che ha aggiornato la riga per ultimo
  `timestamp_aggiornamento` int(11) DEFAULT NULL                  -- timestamp dell'ultimo aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                             --

-- | 010000004300

-- categorie_progetti
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella ricorsiva
-- funzione: contiene l albero delle categorie di progetti
--
-- i progetti si associano alle categorie tramite progetti_categorie, anche a piu' d'una. Ogni categoria puo' generare
-- una pagina del sito, quindi porta il blocco web ( template, schema_html, tema_css, se_sitemap, se_cacheable, id_sito,
-- id_pagina ) ed e' una delle sei tabelle categorie_* che seguono lo stesso modello ( annunci, marchi, notizie, prodotti,
-- progetti, risorse: stesse colonne, indici, chiavi esterne, funzioni _path e vista ).
--
-- NOTA e' l'unica delle cinque con dei flag di dominio ( se_ordinario, se_straordinario, se_disciplina, se_classe,
-- se_fascia ): servono a distinguere l'attivita' ordinaria da quella straordinaria e, per i corsi, le discipline, le
-- classi e le fasce. Sono un'eccezione scritta al modello.
--
-- NOTA id_pagina e' la pagina sotto cui si appende la categoria nell'albero del sito; id_sito non ha chiave esterna
-- perche' i siti sono definiti nella configurazione, non nel database.
--
-- ATTENZIONE all'indice unico ( id_genitore, nome ): in MySQL i NULL non fanno mai conflitto su un indice unico, quindi
-- NON protegge le categorie di radice, che id_genitore ce l'hanno NULL.
CREATE TABLE IF NOT EXISTS `categorie_progetti` (                --
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                        -- chiave esterna per la categoria genitore
  `ordine` int(11) DEFAULT NULL,                                -- ordine di visualizzazione
  `codice` char(32) DEFAULT NULL,                               -- codice della categoria, chiave stabile per gli import
  `nome` char(255) DEFAULT NULL,                                -- nome della categoria
  `note` text DEFAULT NULL,                                     -- note sulla categoria
  `se_ordinario` tinyint(1) DEFAULT NULL,                       -- la categoria e' di attivita' ordinaria
  `se_straordinario` tinyint(1) DEFAULT NULL,                   -- la categoria e' di attivita' straordinaria
  `se_disciplina` tinyint(1) DEFAULT NULL,                      -- la categoria e' una disciplina ( corsi )
  `se_classe` tinyint(1) DEFAULT NULL,                          -- la categoria e' una classe ( corsi )
  `se_fascia` tinyint(1) DEFAULT NULL,                          -- la categoria e' una fascia ( corsi )
  `template` char(255) DEFAULT NULL,                            -- template con cui si mostra la pagina della categoria
  `schema_html` char(128) DEFAULT NULL,                         -- schema HTML del template
  `tema_css` char(128) DEFAULT NULL,                            -- tema CSS del template
  `se_sitemap` tinyint(1) DEFAULT NULL,                         -- la pagina della categoria va nella sitemap
  `se_cacheable` tinyint(1) DEFAULT NULL,                       -- la pagina della categoria si puo' mettere in cache
  `id_sito` bigint(20) DEFAULT NULL,                            -- sito della configurazione a cui appartiene la pagina
  `id_pagina` bigint(20) DEFAULT NULL,                          -- chiave esterna per la pagina genitore nell'albero del sito
  `data_archiviazione` date DEFAULT NULL,                       -- data di archiviazione
  `note_archiviazione` text DEFAULT NULL,                       -- note di archiviazione
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- account che ha aggiornato la riga per ultimo
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp dell'ultimo aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                            --

-- | 010000004500

-- categorie_risorse
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella ricorsiva
-- funzione: contiene l albero delle categorie delle risorse
--
-- le risorse si associano alle categorie tramite risorse_categorie, anche a piu' d'una. Ogni categoria genera una
-- pagina del sito ( oggi solo il modulo legacy 3500.risorse, _310.pages.php ), quindi porta il blocco web ( template,
-- schema_html, tema_css, se_sitemap, se_cacheable, id_sito, id_pagina ) ed e' una delle sei tabelle categorie_*
-- che seguono lo stesso modello ( annunci, marchi, notizie, prodotti, progetti, risorse: stesse colonne, indici, chiavi
-- esterne, funzioni _path e vista ).
--
-- NOTA id_pagina e' la pagina sotto cui si appende la categoria nell'albero del sito; id_sito non ha chiave esterna
-- perche' i siti sono definiti nella configurazione, non nel database.
--
-- ATTENZIONE all'indice unico ( id_genitore, nome ): in MySQL i NULL non fanno mai conflitto su un indice unico, quindi
-- NON protegge le categorie di radice, che id_genitore ce l'hanno NULL.
CREATE TABLE IF NOT EXISTS `categorie_risorse` (                  --
  `id` bigint(20) NOT NULL,                                       -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                          -- chiave esterna per la categoria genitore
  `ordine` int(11) DEFAULT NULL,                                  -- ordine di visualizzazione
  `codice` char(32) DEFAULT NULL,                                 -- codice della categoria, chiave stabile per gli import
  `nome` char(255) DEFAULT NULL,                                  -- nome della categoria
  `note` text DEFAULT NULL,                                       -- note sulla categoria
  `template` char(255) DEFAULT NULL,                              -- template con cui si mostra la pagina della categoria
  `schema_html` char(128) DEFAULT NULL,                           -- schema HTML del template
  `tema_css` char(128) DEFAULT NULL,                              -- tema CSS del template
  `se_sitemap` tinyint(1) DEFAULT NULL,                           -- la pagina della categoria va nella sitemap
  `se_cacheable` tinyint(1) DEFAULT NULL,                         -- la pagina della categoria si puo' mettere in cache
  `id_sito` bigint(20) DEFAULT NULL,                              -- sito della configurazione a cui appartiene la pagina
  `id_pagina` bigint(20) DEFAULT NULL,                            -- chiave esterna per la pagina genitore nell'albero del sito
  `data_archiviazione` date DEFAULT NULL,                         -- data di archiviazione
  `note_archiviazione` text DEFAULT NULL,                         -- note di archiviazione
  `id_account_inserimento` bigint(20) DEFAULT NULL,               -- account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                   -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,             -- account che ha aggiornato la riga per ultimo
  `timestamp_aggiornamento` int(11) DEFAULT NULL                  -- timestamp dell'ultimo aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                             --

-- | 010000004600

-- causali
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene le causali dei documenti
--
-- le causali dei documenti, cioe' il motivo per cui la merce viaggia o il documento viene emesso ( vendita, reso,
-- conto visione... ); un documento ne cita una in documenti.id_causale, e la fattura accompagnatoria ne scrive il nome
-- nel campo CausaleTrasporto della fattura elettronica.
--
-- NOTA: il 050 carica le causali del trasporto d'uso comune, tutte con se_trasporto; non e' un elenco normativo ( il
-- DPR 472/96 non codifica le causali ), quindi ogni deploy le rinomina, le toglie o ne aggiunge a piacere.
CREATE TABLE IF NOT EXISTS `causali` (                          --
  `id` bigint(20) NOT NULL,                                       -- chiave primaria
  `nome` char(255) NOT NULL,                                      -- nome della causale
  `se_trasporto` tinyint(1) DEFAULT NULL,                         -- flag per le causali dei documenti di trasporto
  `id_account_inserimento` bigint(20) DEFAULT NULL,               -- account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                   -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,             -- account che ha aggiornato la riga per ultimo
  `timestamp_aggiornamento` int(11) DEFAULT NULL                  -- timestamp dell'ultimo aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                             --

-- | 010000004700

-- certificazioni
-- tipologia: tabella assistita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene i tipi di documenti e attestati
--
-- i tipi di documenti e attestati che una persona, un progetto o una valutazione possono possedere o richiedere:
-- documenti di identita', diplomi, certificati medici, certificazioni, attestati eccetera; il possesso di un'anagrafica
-- sta in anagrafica_certificazioni ( con emissione e scadenza ), il requisito di un progetto in progetti_certificazioni.
--
-- NOTA: il 050 carica i tipi d'uso comune; i flag se_* classificano il tipo ( un tipo puo' averne piu' d'uno, p.es.
-- il certificato agonistico e' medico, sportivo e agonistico ), ma oggi nessun codice li legge.
CREATE TABLE IF NOT EXISTS `certificazioni` (                   --
  `id` bigint(20) NOT NULL,                                       -- chiave primaria
  `nome` char(255) DEFAULT NULL,                                  -- nome del tipo di documento o attestato
  `se_identificazione` tinyint(1) DEFAULT NULL,                   -- flag per i documenti adatti a identificare una persona
  `se_medico` tinyint(1) DEFAULT NULL,                            -- flag per i documenti con informazioni mediche su una persona
  `se_sportivo` tinyint(1) DEFAULT NULL,                          -- flag per i certificati sportivi
  `se_agonistico` tinyint(1) DEFAULT NULL,                        -- flag per i certificati di abilitazione agonistica
  `se_didattica` tinyint(1) DEFAULT NULL,                         -- flag per diplomi, certificati di frequenza e simili
  `se_immobili` tinyint(1) DEFAULT NULL,                          -- flag per i certificati applicabili a un immobile
  `id_account_inserimento` bigint(20) DEFAULT NULL,               -- account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                   -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,             -- account che ha aggiornato la riga per ultimo
  `timestamp_aggiornamento` int(11) DEFAULT NULL                  -- timestamp dell'ultimo aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                             --

-- | 010000004800

-- chiavi
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene le chiavi di validazione
--
-- le chiavi che validano l'uso di software, contratti, chiamate API e simili; la catena e' contratti -> licenze -> chiavi,
-- e le licenze si legano ai software tramite licenze_software ( software -> licenze_software -> licenze -> chiavi ).
--
-- NOTA: le chiavi potranno descrivere attivazioni una tantum, a periodo, a consumo eccetera; e' da sviluppare insieme
-- ai moduli software e licenze, oggi nessun codice usa la tabella.
CREATE TABLE IF NOT EXISTS `chiavi` (                             --
  `id` bigint(20) NOT NULL,                                       -- chiave primaria
  `id_tipologia` bigint(20) DEFAULT NULL,                         -- tipologia della chiave
  `codice` char(32) DEFAULT NULL,                                 -- codice della chiave, unico
  `nome` char(255) DEFAULT NULL,                                  -- nome descrittivo della chiave
  `id_licenza` bigint(20) DEFAULT NULL,                           -- licenza a cui appartiene la chiave
  `seriale` char(32) DEFAULT NULL,                                -- seriale legato alla chiave
  `id_account_inserimento` bigint(20) DEFAULT NULL,               -- account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                   -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,             -- account che ha aggiornato la riga per ultimo
  `timestamp_aggiornamento` int(11) DEFAULT NULL                  -- timestamp dell'ultimo aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                             --

-- | 010000005000

-- classi_energetiche
-- tipologia: tabella standard
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene le classi energetiche
--
-- le classi energetiche degli immobili, da G ad A4, con il colore con cui si rappresentano; l'id segue la scala dalla
-- classe peggiore alla migliore. Le classi sono relative all'edificio di riferimento, quindi i file di base non caricano
-- ep_min ed ep_max. La tabella appartiene al dominio immobiliare, insieme a valutazioni.
CREATE TABLE IF NOT EXISTS `classi_energetiche` (             --
  `id` bigint(20) NOT NULL,                                   -- chiave primaria
  `nome` char(255) DEFAULT NULL,                              -- nome della classe, unico
  `ep_min` int(11) DEFAULT NULL,                              -- valore minimo dell'indice di prestazione energetica
  `ep_max` int(11) DEFAULT NULL,                              -- valore massimo dell'indice di prestazione energetica
  `hex` char(8) DEFAULT NULL                                  -- colore della classe in esadecimale
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000005050

-- colli
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella ricorsiva
-- funzione: contiene i colli, contenitori fisici organizzati ad albero
--
-- questa tabella contiene i colli: un collo è un contenitore fisico ( una scatola, un pallet, un container ) e i colli
-- formano un albero, perché un collo può contenerne altri. Il contenuto di un collo, cioè la sua packing list, è fatto
-- dai colli figli e dalle righe di documenti_articoli che puntano al collo con id_collo ( articoli in quantità oppure
-- matricole ); una riga divisa fra due colli diventa due righe. Un collo può essere collegato al documento di
-- trasporto che lo accompagna ( DDT o fattura accompagnatoria ), ma esiste anche senza documento e sopravvive alla sua
-- cancellazione. La tabella appartiene al modulo logistica.
-- NOTA id_mittente e id_destinatario sono le anagrafiche della spedizione, id_anagrafica quella a cui il collo è
-- riferito ( p.es. il cliente per cui lo si prepara ), id_mastro il magazzino in cui si trova
-- NOTA raggruppamento è un'etichetta libera per raggruppare i colli; pezzi è il conteggio dichiarato a mano, che non
-- sostituisce il contenuto ricavato dalle righe
-- NOTA le misure sono a blocchi, ogni grandezza col suo id_udm_*, come in articoli
-- NOTA i blocchi *_chiusura e *_spedizione registrano quando il collo è stato chiuso e quando è partito
CREATE TABLE IF NOT EXISTS `colli` (                          --
  `id` bigint(20) NOT NULL,                                   -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                      -- collo che contiene questo
  `id_tipologia` bigint(20) DEFAULT NULL,                     -- tipologia del collo ( container, pallet, scatola )
  `ordine` int(11) DEFAULT NULL,                              -- posizione fra i colli dello stesso genitore
  `codice` char(32) DEFAULT NULL,                             -- codice parlante del collo, p.es. stampato sull'etichetta
  `nome` char(255) DEFAULT NULL,                              -- nome del collo, a uso interno
  `id_anagrafica` bigint(20) DEFAULT NULL,                    -- anagrafica a cui il collo è riferito
  `id_documento` bigint(20) DEFAULT NULL,                     -- documento di trasporto che accompagna il collo
  `id_mittente` bigint(20) DEFAULT NULL,                      -- anagrafica che spedisce il collo
  `id_destinatario` bigint(20) DEFAULT NULL,                  -- anagrafica a cui il collo è spedito
  `id_mastro` bigint(20) DEFAULT NULL,                        -- mastro ( magazzino ) in cui si trova il collo
  `raggruppamento` char(32) DEFAULT NULL,                     -- etichetta libera per raggruppare i colli
  `larghezza` decimal(7,2) DEFAULT NULL,                      -- larghezza del collo
  `lunghezza` decimal(7,2) DEFAULT NULL,                      -- lunghezza del collo
  `altezza` decimal(7,2) DEFAULT NULL,                        -- altezza del collo
  `id_udm_dimensioni` bigint(20) DEFAULT NULL,                -- unità di misura di larghezza, lunghezza e altezza
  `peso` decimal(7,2) DEFAULT NULL,                           -- peso del collo
  `id_udm_peso` bigint(20) DEFAULT NULL,                      -- unità di misura del peso
  `volume` decimal(7,2) DEFAULT NULL,                         -- volume del collo
  `id_udm_volume` bigint(20) DEFAULT NULL,                    -- unità di misura del volume
  `pezzi` int(11) DEFAULT NULL,                               -- numero di pezzi contenuti, quando lo si dichiara a mano
  `note` text DEFAULT NULL,                                   -- note sul collo
  `timestamp_chiusura` int(11) DEFAULT NULL,                  -- timestamp in cui il collo è stato chiuso
  `note_chiusura` text DEFAULT NULL,                          -- note sulla chiusura
  `timestamp_spedizione` int(11) DEFAULT NULL,                -- timestamp in cui il collo è stato spedito
  `note_spedizione` text DEFAULT NULL,                        -- note sulla spedizione
  `id_account_inserimento` bigint(20) DEFAULT NULL,           -- account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,               -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,         -- account che ha aggiornato la riga per ultimo
  `timestamp_aggiornamento` int(11) DEFAULT NULL              -- timestamp dell'ultimo aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000005100

-- colori
-- tipologia: tabella standard
-- rango: tabella principale
-- struttura: tabella ricorsiva
-- funzione: contiene i colori
--
-- i colori, descritti secondo più codifiche ( esadecimale, RGB, RAL, Pantone, CMYK ) e organizzati ad albero: un
-- colore può avere come figli le sue varianti. È un classificatore, quindi fra fratelli il colore si identifica col
-- nome. Serve soprattutto come variante degli articoli ( articoli.id_colore ), e per associare un colore ad altri
-- oggetti, p.es. ai contenuti o in vista di grafici e infografiche.
-- NOTA css serve per i colori che non si riducono a una tinta ( p.es. un effetto carbonio ) e può stare da solo
CREATE TABLE IF NOT EXISTS `colori` (                         --
  `id` bigint(20) NOT NULL,                                   -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                      -- colore di cui questo è una variante
  `nome` char(255) DEFAULT NULL,                              -- nome del colore, unico fra i fratelli
  `hex` char(8) DEFAULT NULL,                                 -- colore in esadecimale
  `r` int(3) DEFAULT NULL,                                    -- componente rossa in RGB
  `g` int(3) DEFAULT NULL,                                    -- componente verde in RGB
  `b` int(3) DEFAULT NULL,                                    -- componente blu in RGB
  `ral` char(16) DEFAULT NULL,                                -- codice RAL
  `pantone` char(16) DEFAULT NULL,                            -- codice Pantone
  `c` decimal(5,2) DEFAULT NULL,                              -- componente ciano in CMYK
  `m` decimal(5,2) DEFAULT NULL,                              -- componente magenta in CMYK
  `y` decimal(5,2) DEFAULT NULL,                              -- componente gialla in CMYK
  `k` decimal(5,2) DEFAULT NULL,                              -- componente nera in CMYK
  `css` text DEFAULT NULL                                     -- dichiarazioni CSS, per i colori che non sono una tinta sola
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000005300

-- comuni
-- tipologia: tabella standard
-- rango: tabella secondaria
-- struttura: tabella base
-- funzione: contiene i comuni
--
-- i comuni, penultimo livello della geografia ( continenti, stati, regioni, provincie, comuni, indirizzi ). Ogni
-- livello è secondario rispetto a quello che lo contiene: un comune non ha senso senza la sua provincia, quindi una
-- provincia che ha dei comuni non si può cancellare. I file di base non popolano la geografia, la carica
-- un'importazione; dentro l'Italia il comune si identifica col codice ISTAT e col codice catastale.
-- un comune soppresso non si cancella: si archivia con data_archiviazione e note_archiviazione e punta col
-- id_successore al comune che ne ha preso il posto. I valori li scrive l'importazione dall'elenco ISTAT dei comuni
-- soppressi; i riferimenti vivi ( indirizzi ) si spostano sul successore, quelli di storia ( nascita, destinatari ) no.
-- NOTA codice_istat e codice_catasto sono codici esterni e mantengono il loro formato; i comuni esteri non li hanno
CREATE TABLE IF NOT EXISTS `comuni` (                         --
  `id` bigint(20) NOT NULL,                                   -- chiave primaria
  `nome` char(255) DEFAULT NULL,                              -- nome del comune
  `id_provincia` bigint(20) DEFAULT NULL,                     -- provincia che contiene il comune
  `id_successore` bigint(20) DEFAULT NULL,                    -- comune che ha preso il posto di questo dopo l'archiviazione
  `codice_istat` char(12) DEFAULT NULL,                       -- codice ISTAT del comune
  `codice_catasto` char(4) DEFAULT NULL,                      -- codice catastale del comune
  `url_riferimento` char(255) DEFAULT NULL,                   -- URL di riferimento del comune
  `note` text DEFAULT NULL,                                   -- note sul comune
  `data_archiviazione` date DEFAULT NULL,                     -- data di archiviazione del comune
  `note_archiviazione` text DEFAULT NULL                      -- note sull'archiviazione del comune
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000006000

-- condizioni_pagamento
-- tipologia: tabella standard
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene le condizioni di pagamento della fattura elettronica
--
-- le condizioni di pagamento col codice CondizioniPagamento ( TP01 - TP03 ) che la fattura elettronica scrive nel
-- blocco DatiPagamento; un documento ne cita una in documenti.id_condizione_pagamento, e la scelgono da una tendina
-- i form dei documenti, delle fatture, delle offerte e dei modelli di pianificazione.
--
-- NOTA: l'elenco e' quello chiuso delle specifiche tecniche, e lo carica il 050; id e codici non si cambiano, perche'
-- il codice finisce cosi' com'e' nell'XML e alcuni moduli scrivono l'id 2 ( pagamento completo ) nel codice. Quando
-- escono nuove specifiche della fattura elettronica l'elenco va ricontrollato e aggiornato con una patch, non a mano.
CREATE TABLE IF NOT EXISTS `condizioni_pagamento` (             --
  `id` bigint(20) NOT NULL,                                       -- chiave primaria
  `codice` char(32) NOT NULL,                                     -- codice CondizioniPagamento della fattura elettronica
  `nome` char(255) DEFAULT NULL,                                  -- nome della condizione di pagamento
  `note` text DEFAULT NULL                                        -- note
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                             --

-- | 010000006050

-- condizioni
-- tipologia: tabella standard
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene le condizioni dei beni
--
-- le condizioni in cui si trova un bene ( nuovo, usato, da ristrutturare ): è un vocabolario unico, che i flag di
-- ambito segmentano per gli asset, il catalogo e gli immobili, così ogni gestione mostra in tendina solo le condizioni
-- che la riguardano. Vi fanno riferimento valutazioni, matricole e asset.
CREATE TABLE IF NOT EXISTS `condizioni` (                     --
  `id` bigint(20) NOT NULL,                                   -- chiave primaria
  `nome` char(255) DEFAULT NULL,                              -- nome della condizione, unico
  `se_asset` tinyint(1) DEFAULT NULL,                         -- flag che indica se la condizione vale per gli asset
  `se_catalogo` tinyint(1) DEFAULT NULL,                      -- flag che indica se la condizione vale per il catalogo ( matricole )
  `se_immobili` tinyint(1) DEFAULT NULL                       -- flag che indica se la condizione vale per gli immobili
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000006200

-- consensi
-- tipologia: tabella standard
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene i consensi che è possibile prestare all'interno del sito o dell'applicazione
--
-- i consensi ai trattamenti di dati che il sito o l'applicazione chiede nei suoi form; il framework li cerca sempre per
-- codice ( _privacy.utils.php, _180.privacy.php, mailing ) e scrive l'id nelle tabelle che li registrano, cioe'
-- anagrafica_consensi, carrelli_consensi e consensi_contatti, mentre consensi_moduli dice quali chiede ogni modulo.
--
-- NOTA: i tre consensi standard li carica il 050 e i loro codici non si cambiano, perche' il codice li cerca per codice;
-- un progetto aggiunge i propri consensi come righe nuove, con un codice suo.
CREATE TABLE IF NOT EXISTS `consensi` (                       --
  `id` bigint(20) NOT NULL,                                   -- chiave primaria
  `codice` char(32) NOT NULL,                                 -- codice del consenso, con cui il framework lo cerca
  `nome` char(255) DEFAULT NULL,                              -- nome del consenso
  `note` text DEFAULT NULL                                    -- note
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000006300

-- consensi_moduli
-- tipologia: tabella assistita
-- rango: tabella secondaria
-- struttura: tabella base
-- funzione: associa i consensi ai moduli che li chiedono ( contatti, carrello, ecc. ), lingua per lingua
--
-- ogni riga dice che il modulo privacy *modulo* chiede, nella lingua *id_lingua*, il consenso *id_consenso*, con quale
-- testo, in che ordine e se e' obbligatorio; il runlevel _src/_config/_180.privacy.php la legge in join con consensi e
-- la fonde in $cf['privacy']['moduli'][<modulo>]['consensi'][<codice del consenso>], cioe' integra la stessa gerarchia
-- che i moduli dichiarano nei file di configurazione.
--
-- NOTA: il framework non carica righe standard; la tabella si popola nel progetto, per i moduli che vogliono consensi
-- diversi da quelli della configurazione.
CREATE TABLE IF NOT EXISTS `consensi_moduli` (                -- 
  `id` bigint(20) NOT NULL,                                   -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                              -- ordine del consenso nel form
  `nome` char(128) DEFAULT NULL,                              -- testo del consenso
  `id_lingua` bigint(20) DEFAULT NULL,                        -- chiave esterna per la lingua
  `id_consenso` bigint(20) DEFAULT NULL,                      -- chiave esterna per il consenso
  `modulo` char(32) DEFAULT NULL,                             -- modulo privacy che chiede il consenso
  `azione` char(32) DEFAULT NULL,                             -- azione con cui l'utente presta il consenso ( letto_e_accetto, autorizzo )
  `informativa` char(128) DEFAULT NULL,                       -- testo dell'informativa
  `pagina` char(32) DEFAULT NULL,                             -- ID della pagina dell'informativa
  `note` text DEFAULT NULL,                                   -- note
  `se_richiesto` tinyint(1) DEFAULT NULL,                     -- flag che indica se il consenso e' obbligatorio
  `id_account_inserimento` bigint(20) DEFAULT NULL,           -- account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,               -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,         -- account che ha aggiornato la riga per ultimo
  `timestamp_aggiornamento` int(11) DEFAULT NULL              -- timestamp dell'ultimo aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000006500

-- consensi_contatti
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: collega i contatti ( le ricezioni dei moduli contatti ) ai consensi prestati
--
-- questa tabella registra, per ogni contatto ricevuto da un modulo contatti, i consensi ( privacy, marketing... )
-- prestati da chi ha compilato il modulo; e' la prova legale del consenso, quindi le righe si scrivono sempre e non
-- si cancellano a mano. La scrive associazioneConsensiContatto() di _src/_lib/_privacy.utils.php.
--
-- NOTA: modulo e' la chiave del modulo contatti su cui e' stato prestato il consenso, la stessa che finisce in
-- contatti.modulo; la si tiene qui perche' fa parte della prova. La chiave unica ( id_contatto, id_consenso, modulo )
-- impedisce di registrare due volte lo stesso consenso per lo stesso contatto.
--
CREATE TABLE IF NOT EXISTS `consensi_contatti` (
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                -- ordine di visualizzazione
  `id_contatto` bigint(20) DEFAULT NULL,                        -- chiave esterna per il contatto su cui e' stato prestato il consenso
  `id_consenso` bigint(20) DEFAULT NULL,                        -- chiave esterna per il consenso
  `modulo` char(32) DEFAULT NULL,                               -- chiave del modulo contatti su cui e' stato prestato il consenso
  `note` text DEFAULT NULL,                                     -- note sul consenso
  `se_prestato` tinyint(1) DEFAULT NULL,                        -- flag consenso prestato
  `timestamp_consenso` int(11) DEFAULT NULL,                    -- timestamp di prestazione del consenso
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account di inserimento
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account di aggiornamento
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000006700

-- contatti
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene i contatti acquisiti ( le ricezioni dei moduli contatti, e i contatti registrati a mano )
--
-- questa tabella registra un contatto per ogni ricezione di un modulo contatti del sito, piu' quelli inseriti a mano
-- dal back-end; tiene chi ha scritto ( id_anagrafica ), da dove arriva ( campagna, sito, parametri UTM ) e cosa ha
-- scritto ( note, json, yaml ). I consensi prestati insieme al contatto stanno in consensi_contatti.
--
-- NOTA: id_sito non ha chiave esterna, come nelle altre tabelle che lo portano: e' l'id del sito in $cf['sites'],
-- non una riga del database. modulo e' la chiave del modulo contatti che ha generato la riga, la stessa che finisce
-- in consensi_contatti.modulo.
--
CREATE TABLE IF NOT EXISTS `contatti` (
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `id_tipologia` bigint(20) DEFAULT NULL,                       -- chiave esterna per la tipologia di contatto
  `nome` char(255) DEFAULT NULL,                                -- nome del contatto
  `id_anagrafica` bigint(20) DEFAULT NULL,                      -- chiave esterna per l'anagrafica collegata al contatto
  `id_campagna` bigint(20) DEFAULT NULL,                        -- chiave esterna per la campagna che ha portato il contatto
  `id_sito` bigint(20) DEFAULT NULL,                            -- id del sito di acquisizione ( senza chiave esterna )
  `utm_id` char(128) DEFAULT NULL,                              -- UTM id
  `utm_source` char(128) DEFAULT NULL,                          -- UTM source
  `utm_medium` char(128) DEFAULT NULL,                          -- UTM medium
  `utm_campaign` char(128) DEFAULT NULL,                        -- UTM campaign
  `utm_term` char(128) DEFAULT NULL,                            -- UTM term
  `utm_content` char(128) DEFAULT NULL,                         -- UTM content
  `modulo` char(32) DEFAULT NULL,                               -- chiave del modulo contatti di acquisizione
  `note` text DEFAULT NULL,                                     -- note sul contatto
  `json` text DEFAULT NULL,                                     -- campo JSON per informazioni aggiuntive
  `yaml` text DEFAULT NULL,                                     -- campo YAML per informazioni aggiuntive
  `timestamp_contatto` int(11) DEFAULT NULL,                    -- timestamp del contatto
  `id_account_archiviazione` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha archiviato il contatto
  `data_archiviazione` date DEFAULT NULL,                       -- data di archiviazione
  `note_archiviazione` text DEFAULT NULL,                       -- note di archiviazione
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account di inserimento
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account di aggiornamento
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000006900

-- contenuti
-- tipologia: tabella gestita
-- rango: tabella secondaria
-- struttura: tabella base
-- funzione: contiene i testi da pubblicare sul web per gli oggetti delle tabelle principali
--
-- questa tabella fa parte del gruppo delle tabelle dei media ( audio, video, immagini, file, contenuti, metadati ),
-- che collegano qualcosa a un oggetto di una tabella principale; qui sono i testi web ( title, meta tag, Open Graph,
-- h1, testo... ) di pagine, prodotti, articoli, anagrafiche, notizie, annunci, risorse, immagini e degli altri
-- oggetti indicati dalle chiavi esterne id_*, e i campi di mittente e destinatari dei template mail e sms; ogni
-- riga descrive un oggetto solo in una lingua, e per questo le chiavi uniche sono ( id_<oggetto>, id_lingua )
--
-- NOTA le chiavi esterne verso gli oggetti descritti sono CASCADE: un contenuto non ha senso senza il suo oggetto,
-- e se l'oggetto viene cancellato le sue righe se ne vanno con lui
--
-- NOTA mittente_mail e destinatari_*_mail contengono un array nome => indirizzo serializzato con serialize(),
-- che il controller di CO000.contenuti ricava dalla forma "Nome <indirizzo>" scritta nel form; per questo non ci
-- sono colonne per i nomi dei destinatari, mentre mittente_nome resta perché serve agli sms
-- NOTA i destinatari sono text e non char perché un elenco serializzato troncato non si rilegge più, e la
-- mail partirebbe senza destinatari; il mittente è una voce sola e gli basta char(255)
--
CREATE TABLE IF NOT EXISTS `contenuti` (                        --
  `id` bigint(20) NOT NULL,                                        -- chiave primaria
  `id_lingua` bigint(20) DEFAULT NULL,                             -- chiave esterna per la lingua
  `id_anagrafica` bigint(20) DEFAULT NULL,                         -- chiave esterna per l'anagrafica
  `id_prodotto` bigint(20) DEFAULT NULL,                           -- chiave esterna per il prodotto
  `id_articolo` bigint(20) DEFAULT NULL,                           -- chiave esterna per l'articolo
  `id_categoria_prodotti` bigint(20) DEFAULT NULL,                 -- chiave esterna per la categoria dei prodotti
  `id_caratteristica` bigint(20) DEFAULT NULL,                     -- chiave esterna per la caratteristica
  `id_marchio` bigint(20) DEFAULT NULL,                            -- chiave esterna per il marchio
  `id_categoria_marchi` bigint(20) DEFAULT NULL,                   -- chiave esterna per la categoria di marchi
  `id_file` bigint(20) DEFAULT NULL,                               -- chiave esterna per il file
  `id_immagine` bigint(20) DEFAULT NULL,                           -- chiave esterna per l'immagine
  `id_video` bigint(20) DEFAULT NULL,                              -- chiave esterna per il video
  `id_audio` bigint(20) DEFAULT NULL,                              -- chiave esterna per l'audio
  `id_risorsa` bigint(20) DEFAULT NULL,                            -- chiave esterna per la risorsa
  `id_categoria_risorse` bigint(20) DEFAULT NULL,                  -- chiave esterna per la categoria delle risorse
  `id_pagina` bigint(20) DEFAULT NULL,                             -- chiave esterna per la pagina
  `id_popup` bigint(20) DEFAULT NULL,                              -- chiave esterna per il popup
  `id_indirizzo` bigint(20) DEFAULT NULL,                          -- chiave esterna per l'indirizzo
  `id_edificio` bigint(20) DEFAULT NULL,                           -- chiave esterna per l'edificio
  `id_immobile` bigint(20) DEFAULT NULL,                           -- chiave esterna per l'immobile
  `id_notizia` bigint(20) DEFAULT NULL,                            -- chiave esterna per la notizia
  `id_annuncio` bigint(20) DEFAULT NULL,                           -- chiave esterna per l'annuncio
  `id_categoria_notizie` bigint(20) DEFAULT NULL,                  -- chiave esterna per la categoria delle notizie
  `id_categoria_annunci` bigint(20) DEFAULT NULL,                  -- chiave esterna per la categoria degli annunci
  `id_template` bigint(20) DEFAULT NULL,                           -- chiave esterna per il template
  `id_mailing` bigint(20) DEFAULT NULL,                            -- chiave esterna per il mailing
  `id_colore` bigint(20) DEFAULT NULL,                             -- chiave esterna per il colore
  `id_progetto` bigint(20) DEFAULT NULL,                           -- chiave esterna per il progetto
  `id_categoria_progetti` bigint(20) DEFAULT NULL,                 -- chiave esterna per la categoria dei progetti
  `id_banner` bigint(20) DEFAULT NULL,                             -- chiave esterna per il banner
  `id_vano` bigint(20) DEFAULT NULL,                             -- chiave esterna per il vano
  `path_custom` char(255) DEFAULT NULL,                         -- path custom
  `url_custom` char(255) DEFAULT NULL,                          -- URL custom
  `rewrite_custom` char(255) DEFAULT NULL,                      -- rewrite custom
  `title` char(255) DEFAULT NULL,                               -- titolo SEO
  `keywords` text DEFAULT NULL,                                 -- parole chiave SEO
  `description` text DEFAULT NULL,                              -- descrizione SEO
  `robots` text DEFAULT NULL,                                   -- direttive per i motori di ricerca
  `alt` char(255) DEFAULT NULL,                                 -- testo alternativo per immagini
  `og_title` char(255) DEFAULT NULL,                            -- titolo Open Graph
  `og_type` char(255) DEFAULT NULL,                             -- tipo Open Graph
  `og_image` char(255) DEFAULT NULL,                            -- immagine Open Graph
  `og_audio` char(255) DEFAULT NULL,                            -- audio Open Graph
  `og_video` char(255) DEFAULT NULL,                            -- video Open Graph
  `og_determiner` char(255) DEFAULT NULL,                       -- determinante Open Graph
  `og_description` char(255) DEFAULT NULL,                      -- descrizione Open Graph
  `cappello` text DEFAULT NULL,                                 -- cappello
  `h1` char(255) DEFAULT NULL,                                  -- intestazione H1
  `h2` char(255) DEFAULT NULL,                                  -- intestazione H2
  `h3` char(255) DEFAULT NULL,                                  -- intestazione H3
  `abstract` text DEFAULT NULL,                                 -- abstract
  `testo` mediumtext DEFAULT NULL,                                 -- testo
  `applicazioni` text DEFAULT NULL,                             -- applicazioni
  `specifiche` text DEFAULT NULL,                               -- specifiche
  `label_menu` char(255) DEFAULT NULL,                          -- label menu
  `mittente_nome` char(128) DEFAULT NULL,                       -- mittente nome
  `mittente_numero` char(128) DEFAULT NULL,                     -- mittente numero
  `mittente_mail` char(255) DEFAULT NULL,                       -- mittente mail
  `destinatari_numero` char(128) DEFAULT NULL,                  -- destinatario numero
  `destinatari_mail` text DEFAULT NULL,                         -- destinatario mail
  `destinatari_cc_mail` text DEFAULT NULL,                      -- destinatario cc mail
  `destinatari_bcc_mail` text DEFAULT NULL,                     -- destinatario bcc mail
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account di inserimento
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account di aggiornamento
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                           --

-- | 010000007100

-- continenti
-- tipologia: tabella standard
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene i continenti
--
-- i continenti, radice della geografia ( continenti, stati, regioni, provincie, comuni, indirizzi ): è l'unico livello
-- che non è contenuto da un altro, e un continente che ha degli stati non si può cancellare. Sono i sette continenti
-- standard, caricati dai file di base; il nome è in italiano, ad uso interno.
-- NOTA il codice è quello standard a due lettere dei continenti ( AF, AN, AS, EU, NA, OC, SA ), che non va confuso
-- coi codici ISO degli stati; l'America del Nord comprende il Centro America e i Caraibi
CREATE TABLE IF NOT EXISTS `continenti` (                     --
  `id` bigint(20) NOT NULL,                                   -- chiave primaria
  `codice` char(32) DEFAULT NULL,                             -- codice del continente
  `nome` char(255) DEFAULT NULL                               -- nome del continente
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000007200

-- contratti
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene i contratti, cioe' gli accordi fra anagrafiche ( iscrizioni, abbonamenti, tesseramenti, licenze,
-- compravendite, affiliazioni, eccetera )
--
-- questa tabella contiene un contratto per riga; il tipo di accordo lo dice la tipologia. Le parti del contratto
-- stanno in contratti_anagrafica, coi loro ruoli ( proponente, contraente ): in origine erano campi di questa
-- tabella, poi sono state spostate li' per consentire piu' contraenti. La validita' del contratto e' data dai periodi
-- registrati in rinnovi. Un contratto puo' essere citato da una riga di documento, e da un articolo quando gli si
-- vuole dare un prezzo. Il codice e' il numero del contratto ( p.es. il numero di tessera ).
--
-- NOTA: l'archiviazione non e' la chiusura del contratto. Un contratto che si attiva a periodi ( p.es. un
-- abbonamento in palestra ) resta non archiviato finche' non lo si disdice del tutto, cosi' gli si aggiungono
-- facilmente altri rinnovi; lo si archivia quando non lo si vuole piu' fra quelli in uso. I contratti di
-- affiliazione si citano con la loro chiave ( account.id_affiliazione, banner.id_affiliazione,
-- carrelli.id_affiliazione ), e il loro codice pubblico e' il codice del contratto.
--
CREATE TABLE IF NOT EXISTS `contratti` (
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `id_tipologia` bigint(20) DEFAULT NULL,                       -- chiave esterna per la tipologia di contratto
  `codice` char(32) DEFAULT NULL,                               -- codice del contratto
  `nome` char(255) DEFAULT NULL,                                -- nome del contratto
  `id_immobile` bigint(20) DEFAULT NULL,                        -- chiave esterna per l'immobile oggetto del contratto
  `id_progetto` bigint(20) DEFAULT NULL,                        -- chiave esterna per il progetto oggetto del contratto
  `note` text DEFAULT NULL,                                     -- note sul contratto
  `note_cliente` text DEFAULT NULL,                             -- note per il cliente
  `id_account_archiviazione` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha archiviato il contratto
  `data_archiviazione` date DEFAULT NULL,                       -- data di archiviazione
  `note_archiviazione` text DEFAULT NULL,                       -- note di archiviazione
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account di inserimento
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account di aggiornamento
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000007400

-- contratti_progetti
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: mette in relazione contratti e progetti
--
CREATE TABLE IF NOT EXISTS `contratti_progetti` (
  `id` bigint(20) NOT NULL,
  `id_contratto` bigint(20) DEFAULT NULL,
  `id_progetto` bigint(20) DEFAULT NULL,
  `id_ruolo` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `note_inserimento` text NULL,
  `note_aggiornamento` text NULL,
  `timestamp_archiviazione` int(11) DEFAULT NULL,
  `id_account_archiviazione` bigint(20) DEFAULT NULL,
  `note_archiviazione` text NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000007500

-- conversazioni
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene le conversazioni, cioe' i contenitori dei messaggi
--
-- questa tabella contiene una conversazione per riga. La conversazione e' il contenitore dei messaggi, che stanno in
-- messaggi, mentre i partecipanti stanno in conversazioni_account; collegandola ad altri oggetti se ne fanno chat uno
-- a uno, chat di gruppo, forum, eccetera. Con id_annuncio la conversazione si lega all'annuncio da cui nasce ( p.es.
-- la risposta di un utente a un annuncio ). Apertura e chiusura delimitano la vita della conversazione.
--
CREATE TABLE IF NOT EXISTS `conversazioni` (
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `codice` char(32) DEFAULT NULL,                               -- codice della conversazione
  `nome` char(255) DEFAULT NULL,                                -- nome della conversazione
  `id_annuncio` bigint(20) DEFAULT NULL,                        -- chiave esterna per l'annuncio a cui si riferisce la conversazione
  `note` text DEFAULT NULL,                                     -- note sulla conversazione
  `timestamp_apertura` int(11) DEFAULT NULL,                    -- timestamp di apertura della conversazione
  `timestamp_chiusura` int(11) DEFAULT NULL,                    -- timestamp di chiusura della conversazione
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento della riga
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha aggiornato la riga
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento della riga
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000007600

-- conversazioni_account
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: contiene i partecipanti alle conversazioni, cioe' chi partecipa a una conversazione e con che ruolo
--
-- questa tabella mette in relazione conversazioni e account: ogni riga e' un account che partecipa a una conversazione,
-- con il suo ruolo preso da ruoli_conversazioni ( spettatore, membro, moderatore, amministratore, proprietario ).
-- Entrata e uscita delimitano la partecipazione, la lettura segna l'ultima volta che il partecipante ha letto.
--
CREATE TABLE IF NOT EXISTS `conversazioni_account` (
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                -- ordine di visualizzazione
  `id_conversazione` bigint(20) DEFAULT NULL,                   -- chiave esterna per la conversazione
  `id_account` bigint(20) DEFAULT NULL,                         -- chiave esterna per l'account che partecipa alla conversazione
  `id_ruolo` bigint(20) DEFAULT NULL,                           -- chiave esterna per il ruolo dell'account nella conversazione
  `timestamp_lettura` int(11) DEFAULT NULL,                     -- timestamp dell'ultima lettura della conversazione
  `timestamp_entrata` int(11) DEFAULT NULL,                     -- timestamp di entrata nella conversazione
  `timestamp_uscita` int(11) DEFAULT NULL,                      -- timestamp di uscita dalla conversazione
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento della riga
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha aggiornato la riga
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento della riga
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000007700

-- conversazioni_categorie
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: associa molti a molti le conversazioni alle categorie delle conversazioni
--
-- questa tabella contiene le associazioni molti a molti tra le conversazioni e le categorie_conversazioni, p.es. le
-- discussioni di un forum e le sezioni in cui stanno; un solo classificatore, quindi la chiave verso la categoria ha il
-- nome generico id_categoria. Come le altre tabelle della famiglia, nessun form la legge come sotto-elenco.
--
CREATE TABLE IF NOT EXISTS `conversazioni_categorie` (        --
  `id` bigint(20) NOT NULL,                                   -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                              -- ordine di visualizzazione
  `id_conversazione` bigint(20) DEFAULT NULL,                 -- chiave esterna per la conversazione
  `id_categoria` bigint(20) DEFAULT NULL,                     -- chiave esterna per la categoria
  `id_account_inserimento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha inserito l'associazione
  `timestamp_inserimento` int(11) DEFAULT NULL,               -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,         -- chiave esterna per l'account che ha aggiornato l'associazione
  `timestamp_aggiornamento` int(11) DEFAULT NULL              -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000007800

-- corrispondenza
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene la corrispondenza cartacea in uscita
--
-- questa tabella contiene la corrispondenza cartacea spedita: una riga può essere un singolo invio ( forma
-- dettagliata, col destinatario compilato ) oppure un blocco di invii uguali ( forma aggregata, con quantita e senza
-- destinatario ). La tipologia dice di che spedizione si tratta ( posta ordinaria, raccomandata, atto, con o senza
-- ricevuta di ritorno ), il formato e lo scaglione di peso dicono come si tariffa. La tabella appartiene al modulo
-- corrispondenza.
-- NOTA il destinatario si scrive per esteso nei campi destinatario_*, perché la corrispondenza parte anche verso chi
-- non è in anagrafica; destinatario_id_anagrafica lo collega quando c'è
-- NOTA id_peso è lo scaglione della tariffa ( pesi_tipologie_corrispondenza ), peso e id_udm_peso il peso effettivo
-- NOTA id_distinta_spedizione è la distinta con cui la corrispondenza viene consegnata all'ufficio postale; la tabella
-- delle distinte di spedizione non esiste ancora, quindi la colonna non ha chiave esterna
-- NOTA il blocco *_consegna registra l'esito della consegna al destinatario
CREATE TABLE IF NOT EXISTS `corrispondenza` (                 --
  `id` bigint(20) NOT NULL,                                   -- chiave primaria
  `id_tipologia` bigint(20) DEFAULT NULL,                     -- tipologia della corrispondenza
  `codice` char(32) DEFAULT NULL,                             -- codice della corrispondenza, p.es. il numero della raccomandata
  `nome` char(255) DEFAULT NULL,                              -- nome della corrispondenza, a uso interno
  `id_mittente` bigint(20) DEFAULT NULL,                      -- anagrafica che spedisce la corrispondenza
  `id_organizzazione_mittente` bigint(20) DEFAULT NULL,       -- organizzazione ( ufficio ) che spedisce la corrispondenza
  `id_commesso` bigint(20) DEFAULT NULL,                      -- anagrafica del commesso che ha in carico la corrispondenza
  `destinatario_id_anagrafica` bigint(20) DEFAULT NULL,       -- anagrafica del destinatario, se esiste
  `destinatario_id_tipologia_anagrafica` bigint(20) DEFAULT NULL,  -- tipologia di anagrafica del destinatario
  `destinatario_nome` char(255) DEFAULT NULL,                 -- nome del destinatario
  `destinatario_cognome` char(255) DEFAULT NULL,              -- cognome del destinatario
  `destinatario_denominazione` char(255) DEFAULT NULL,        -- denominazione del destinatario
  `destinatario_codice_fiscale` char(32) DEFAULT NULL,        -- codice fiscale del destinatario
  `destinatario_partita_iva` char(32) DEFAULT NULL,           -- partita IVA del destinatario
  `destinatario_indirizzo` char(255) DEFAULT NULL,            -- indirizzo del destinatario
  `destinatario_civico` char(16) DEFAULT NULL,                -- numero civico del destinatario
  `destinatario_cap` char(16) DEFAULT NULL,                   -- CAP del destinatario
  `destinatario_citta` char(255) DEFAULT NULL,                -- città del destinatario, come scritta sulla busta
  `destinatario_id_comune` bigint(20) DEFAULT NULL,           -- comune del destinatario
  `destinatario_id_provincia` bigint(20) DEFAULT NULL,        -- provincia del destinatario
  `destinatario_id_stato` bigint(20) DEFAULT NULL,            -- stato del destinatario
  `id_formato` bigint(20) DEFAULT NULL,                       -- formato della busta o del plico
  `id_peso` bigint(20) DEFAULT NULL,                          -- scaglione di peso della tariffa
  `peso` decimal(7,2) DEFAULT NULL,                           -- peso effettivo della corrispondenza
  `id_udm_peso` bigint(20) DEFAULT NULL,                      -- unità di misura del peso
  `quantita` int(11) DEFAULT NULL,                            -- numero di pezzi, per la corrispondenza aggregata
  `id_distinta_spedizione` bigint(20) DEFAULT NULL,           -- distinta di spedizione in cui è consegnata all'ufficio postale
  `numero_certificazione_consegna` char(255) DEFAULT NULL,    -- numero della certificazione di consegna ( p.es. della ricevuta di ritorno )
  `nome_consegna` char(255) DEFAULT NULL,                     -- nome di chi ha ricevuto la corrispondenza
  `cognome_consegna` char(255) DEFAULT NULL,                  -- cognome di chi ha ricevuto la corrispondenza
  `timestamp_consegna` int(11) DEFAULT NULL,                  -- timestamp della consegna
  `requisiti_consegna` text DEFAULT NULL,                     -- requisiti per la consegna
  `note_consegna` text DEFAULT NULL,                          -- note sulla consegna
  `timestamp_elaborazione` int(11) DEFAULT NULL,              -- timestamp dell'ultima elaborazione
  `note_elaborazione` text DEFAULT NULL,                      -- note sull'ultima elaborazione
  `timestamp_gestione` int(11) DEFAULT NULL,                  -- timestamp dell'ultima gestione
  `note_gestione` text DEFAULT NULL,                          -- note sull'ultima gestione
  `id_account_inserimento` bigint(20) DEFAULT NULL,           -- account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,               -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,         -- account che ha aggiornato la riga per ultimo
  `timestamp_aggiornamento` int(11) DEFAULT NULL              -- timestamp dell'ultimo aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000007900

-- costi_contratti
-- tipologia: tabella gestita
-- rango: tabella secondaria
-- struttura: tabella base
-- funzione: contiene i costi orari di un contratto di lavoro per tipologia di attivita' INPS
--
-- questa tabella contiene un costo orario per riga, uno per ogni coppia di contratto e tipologia di attivita' INPS
-- ( tipologie_attivita_inps ). Le fasce di orari_contratti, cioe' i turni di lavoro e di disponibilita' del
-- contratto, rimandano a un costo, ed e' da li' che si ricava il costo delle ore lavorate per i cartellini e per il
-- calcolo delle ore di produzione. Fa parte della gestione del personale, che oggi vive nei moduli legacy
-- _0600.contratti, _1000.produzione e _8100.cartellini e passera' al modulo risorse umane di latest.
--
-- NOTA: e' tornata il 2026-09-30 dallo schema del 2021 ( _usr/_database/mysql.schema.sql, 0e99bca51 ), dove era
-- int; qui e' portata a bigint come il resto del canone.
--
CREATE TABLE IF NOT EXISTS `costi_contratti` (
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `id_tipologia` bigint(20) DEFAULT NULL,                       -- chiave esterna per la tipologia di attivita' INPS
  `id_contratto` bigint(20) DEFAULT NULL,                       -- chiave esterna per il contratto
  `costo_orario` decimal(16,5) DEFAULT NULL,                    -- costo orario
  `note` text DEFAULT NULL,                                     -- note sul costo
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account di inserimento
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account di aggiornamento
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000008000

-- coupon
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene i coupon, cioe' i buoni che attivano uno sconto
--
-- questa tabella contiene un coupon per riga: il codice che il cliente digita ( univoco ), uno sconto percentuale o
-- fisso, il periodo di validita' e tre flag che dicono come si usa ( piu' volte, sull'intero carrello, solo per
-- l'anagrafica indicata ). A quali articoli, categorie, listini, marchi e prodotti si applica lo dicono le tabelle
-- di relazione coupon_*, e chi lo ha usato lo dicono carrelli, carrelli_articoli, documenti e pagamenti. La causale
-- spiega perche' il coupon esiste e, quando nasce da un contratto o da un suo rinnovo ( p.es. un credito per un
-- ritiro o un rimborso ), lo collega a quel contratto e a quel rinnovo. E' gestita dal modulo coupon.
--
-- NOTA: id e' numerico dal riallineamento del 02/03/2026, e il codice che il cliente digita sta in codice ( prima
-- di marzo era l'id ).
--
CREATE TABLE IF NOT EXISTS `coupon` (
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `codice` char(32) DEFAULT NULL,                               -- codice del coupon, quello che il cliente digita
  `nome` char(255) DEFAULT NULL,                                -- nome del coupon
  `id_anagrafica` bigint(20) DEFAULT NULL,                      -- chiave esterna per l'anagrafica intestataria
  `causale_id_contratto` bigint(20) DEFAULT NULL,               -- chiave esterna per il contratto che ha generato il coupon
  `causale_id_rinnovo` bigint(20) DEFAULT NULL,                 -- chiave esterna per il rinnovo che ha generato il coupon
  `sconto_percentuale` decimal(5,2) DEFAULT NULL,               -- sconto in percentuale
  `sconto_fisso` decimal(15,2) DEFAULT NULL,                    -- sconto a importo fisso
  `causale` text DEFAULT NULL,                                  -- motivo per cui il coupon e' stato emesso
  `note` text DEFAULT NULL,                                     -- note sul coupon
  `se_multiuso` tinyint(1) DEFAULT NULL,                        -- flag per il coupon utilizzabile piu' volte
  `se_globale` tinyint(1) DEFAULT NULL,                         -- flag per il coupon che si applica all'intero carrello
  `se_vincolato` tinyint(1) DEFAULT NULL,                       -- flag per il coupon utilizzabile solo dall'anagrafica intestataria
  `timestamp_inizio` int(11) DEFAULT NULL,                      -- timestamp di inizio validita'
  `timestamp_fine` int(11) DEFAULT NULL,                        -- timestamp di fine validita'
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account di inserimento
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account di aggiornamento
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000008100

-- coupon_articoli
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: dice a quali articoli e' vincolato un coupon
--
-- questa tabella elenca gli articoli che il carrello deve contenere perche' un coupon vincolato ( coupon.se_vincolato
-- a 1 ) sia valido; e' una delle tabelle di applicazione del coupon, come quelle omologhe degli sconti. La compila la
-- gestione coupon e la legge verificaValiditaCoupon() del modulo ecommerce.
--
-- NOTA: gruppo_alternative raggruppa gli articoli: per ogni gruppo basta che nel carrello ci sia uno dei suoi articoli,
-- e i gruppi diversi sono tutti richiesti; gli articoli senza gruppo ( NULL ) fanno un gruppo solo, alternativi fra loro.
--
CREATE TABLE IF NOT EXISTS `coupon_articoli` (
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                -- ordine di visualizzazione
  `id_coupon` bigint(20) DEFAULT NULL,                          -- chiave esterna per il coupon
  `id_articolo` bigint(20) DEFAULT NULL,                        -- chiave esterna per l'articolo richiesto dal coupon
  `gruppo_alternative` char(32) DEFAULT NULL,                   -- gruppo di articoli alternativi fra loro
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account di inserimento
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account di aggiornamento
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000008200

-- coupon_categorie_prodotti
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: dice a quali categorie di prodotti si applica un coupon
--
-- questa tabella elenca le categorie di prodotti a cui si applica un coupon; e' una delle tabelle di applicazione del
-- coupon, come quelle omologhe degli sconti. La compila la gestione coupon; verificaValiditaCoupon() del modulo
-- ecommerce oggi non la legge ( guarda solo coupon_articoli ).
--
-- NOTA: la colonna si chiama id_categoria e non id_categoria_prodotti perche' il tipo di categoria e' gia' nel nome
-- della tabella, come in prodotti_categorie.
--
CREATE TABLE IF NOT EXISTS `coupon_categorie_prodotti` (
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                -- ordine di visualizzazione
  `id_coupon` bigint(20) DEFAULT NULL,                          -- chiave esterna per il coupon
  `id_categoria` bigint(20) DEFAULT NULL,                       -- chiave esterna per la categoria di prodotti
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account di inserimento
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account di aggiornamento
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000008400

-- coupon_listini
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: dice per quali listini e' valido un coupon
--
-- questa tabella elenca i listini per i quali e' valido un coupon, cioe' limita il coupon ai clienti ( e ai carrelli )
-- che stanno su quei listini; e' una delle tabelle di applicazione del coupon e, come tutte le tabelle coupon_*, ha
-- la sua gemella negli sconti ( sconti_listini ). Oggi nessuna parte del framework la compila ne' la legge:
-- verificaValiditaCoupon() del modulo ecommerce guarda solo coupon_articoli.
--
CREATE TABLE IF NOT EXISTS `coupon_listini` (
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                -- ordine di visualizzazione
  `id_coupon` bigint(20) DEFAULT NULL,                          -- chiave esterna per il coupon
  `id_listino` bigint(20) DEFAULT NULL,                         -- chiave esterna per il listino
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account di inserimento
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account di aggiornamento
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000008600

-- coupon_marchi
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: dice per quali marchi e' valido un coupon
--
-- questa tabella elenca i marchi per i quali e' valido un coupon, cioe' limita il coupon ai prodotti di quei marchi;
-- e' una delle tabelle di applicazione del coupon ( con coupon_articoli, coupon_prodotti e coupon_categorie_prodotti )
-- e, come tutte le tabelle coupon_*, va affiancata dalla sua gemella negli sconti ( sconti_marchi, che il canone non
-- ha ancora ). Nel framework latest nessuna parte la legge; in oldstable la legge calcolaCoupon() del modulo prodotti,
-- come ultimo controllo dopo articolo, prodotto e categoria.
--
CREATE TABLE IF NOT EXISTS `coupon_marchi` (
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                -- ordine di visualizzazione
  `id_coupon` bigint(20) DEFAULT NULL,                          -- chiave esterna per il coupon
  `id_marchio` bigint(20) DEFAULT NULL,                         -- chiave esterna per il marchio
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account di inserimento
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account di aggiornamento
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000008800

-- coupon_prodotti
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: dice per quali prodotti e' valido un coupon
--
-- questa tabella elenca i prodotti per i quali e' valido un coupon, cioe' limita il coupon agli articoli di quei
-- prodotti; e' una delle tabelle di applicazione del coupon ( con coupon_articoli, coupon_categorie_prodotti e
-- coupon_marchi ) e, come tutte le tabelle coupon_*, va affiancata dalla sua gemella negli sconti ( sconti_prodotti,
-- che il canone non ha ancora ). Nel framework latest nessuna parte la legge; in oldstable la legge calcolaCoupon()
-- del modulo prodotti, come secondo controllo dopo l'articolo.
--
CREATE TABLE IF NOT EXISTS `coupon_prodotti` (
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                -- ordine di visualizzazione
  `id_coupon` bigint(20) DEFAULT NULL,                          -- chiave esterna per il coupon
  `id_prodotto` bigint(20) DEFAULT NULL,                        -- chiave esterna per il prodotto
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account di inserimento
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account di aggiornamento
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000008900

-- crediti
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: registra i movimenti dei crediti, la valuta interna del framework
--
-- questa tabella registra un movimento di crediti per riga: una quantita' che esce dal mastro di provenienza ed entra
-- in quello di destinazione, in una data, fra un account emittente e uno destinatario. I crediti sono una valuta
-- interna al framework, pensata per giochi, applicazioni con acquisti in-app, annunci e simili ( non sono crediti
-- contabili verso clienti ): vivono nei mastri di tipologia crediti ( se_credito ), come le merci nei mastri di
-- magazzino e le ore nei registri, e come loro hanno i report di giacenza e di movimentazione
-- ( __report_giacenza_crediti__, __report_movimenti_crediti__ ). Quando il movimento nasce da un acquisto e' legato
-- alla riga di documento che lo ha generato. E' gestita dal modulo crediti, costruito sul modulo mastri; in oldstable
-- la scrivono i checkout di 0530.crediti e di altri moduli che vendono crediti.
--
CREATE TABLE IF NOT EXISTS `crediti` (
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `nome` char(255) DEFAULT NULL,                                -- descrizione del movimento
  `id_pianificazione` bigint(20) DEFAULT NULL,                  -- chiave esterna per la pianificazione collegata
  `id_documenti_articolo` bigint(20) DEFAULT NULL,              -- chiave esterna per la riga di documento che ha generato il movimento
  `id_account_emittente` bigint(20) DEFAULT NULL,               -- chiave esterna per l'account che cede i crediti
  `id_account_destinatario` bigint(20) DEFAULT NULL,            -- chiave esterna per l'account che riceve i crediti
  `id_mastro_provenienza` bigint(20) DEFAULT NULL,              -- chiave esterna per il mastro da cui escono i crediti
  `id_mastro_destinazione` bigint(20) DEFAULT NULL,             -- chiave esterna per il mastro in cui entrano i crediti
  `quantita` decimal(9,2) DEFAULT NULL,                         -- quantita' di crediti movimentata
  `note` text DEFAULT NULL,                                     -- note sul movimento
  `data` date DEFAULT NULL,                                     -- data del movimento
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account di inserimento
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account di aggiornamento
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000008950

-- dichiarazioni_intento
-- tipologia: tabella gestita
-- rango: tabella secondaria
-- struttura: tabella base
-- funzione: registra le dichiarazioni d'intento ricevute dagli esportatori abituali
--
-- questa tabella registra, per ogni cliente esportatore abituale, le dichiarazioni d'intento che ha presentato
-- all'Agenzia delle Entrate per acquistare senza IVA entro il suo plafond: il protocollo e la data della ricevuta
-- telematica, l'anno o il periodo di validita' e l'importo fino a concorrenza del quale vale. Non e' una codifica
-- ufficiale da sincronizzare: le dichiarazioni le comunica il cliente e si registrano a mano nella sua anagrafica.
-- La fattura elettronica cita la dichiarazione valida alla data del documento nelle righe con natura N3.5
-- ( AltriDatiGestionali, TipoDato INTENTO ). Il protocollo identifica la dichiarazione, da cui l'unicita' su
-- anagrafica e protocollo. E' gestita dalla scheda cliente dell'anagrafica; in oldstable la legge 0400.documenti.
--
CREATE TABLE IF NOT EXISTS `dichiarazioni_intento` (
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `id_anagrafica` bigint(20) DEFAULT NULL,                      -- chiave esterna per l'esportatore abituale che ha presentato la dichiarazione
  `protocollo` char(32) DEFAULT NULL,                           -- protocollo della ricevuta telematica ( 17 cifre, trattino, 6 cifre )
  `data_protocollo` date DEFAULT NULL,                          -- data della ricevuta telematica
  `anno` int(4) DEFAULT NULL,                                   -- anno per cui vale la dichiarazione, se ne indica uno
  `data_inizio` date DEFAULT NULL,                              -- inizio del periodo di validita', se la dichiarazione ne indica uno
  `data_fine` date DEFAULT NULL,                                -- fine del periodo di validita'
  `importo` decimal(16,2) DEFAULT NULL,                         -- importo fino a concorrenza del quale vale la dichiarazione
  `note` text DEFAULT NULL,                                     -- note sulla dichiarazione
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account di inserimento
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account di aggiornamento
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000009000

-- disponibilita
-- tipologia: tabella standard
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene le disponibilità degli oggetti
--
-- la disponibilità di un oggetto ( immobili, articoli del catalogo, risorse e simili: disponibile, in riassortimento,
-- occupato ): è un vocabolario unico, che i flag di ambito segmentano per tipo di oggetto, così ogni gestione mostra in
-- tendina solo le disponibilità che la riguardano. Vi fa riferimento valutazioni.
CREATE TABLE IF NOT EXISTS `disponibilita` (                  --
  `id` bigint(20) NOT NULL,                                   -- chiave primaria
  `nome` char(255) DEFAULT NULL,                              -- nome della disponibilità, unico
  `se_catalogo` tinyint(1) DEFAULT NULL,                      -- flag che indica se la disponibilità vale per il catalogo
  `se_immobili` tinyint(1) DEFAULT NULL                       -- flag che indica se la disponibilità vale per gli immobili
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000009800

-- documenti
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene tutti i documenti gestiti dal framework
-- entità: questa tabella corrisponde all'entità documento
--
-- questa tabella è una delle più importanti del framework, perché descrive tutti i documenti che vengono gestiti,
-- emessi o ricevuti ( fatture, note di credito, ricevute, DDT, offerte, ordini... ); il tipo di documento lo dice
-- id_tipologia, che punta a tipologie_documenti; le righe stanno in documenti_articoli e hanno implicazioni importanti
-- per molti moduli ( magazzino, crediti, ore, vendite, pianificazioni ), quindi ogni modifica a questa tabella o alle
-- sue righe va valutata anche dal loro punto di vista
--
-- le colonne sono raggruppate per funzione, nell'ordine in cui compaiono:
-- - testata: id_tipologia, codice, numero, sezionale, data, nome
-- - anagrafiche e sedi: emittente col suo referente e la sua sede, destinatario con la sua sede, destinatario e sede
--   della spedizione, note_spedizione
-- - dati fiscali: id_condizione_pagamento, esigibilita, se_bollo_virtuale, importo_bollo, cig, cup, riferimento
-- - fattura elettronica: codice_sdi, codice_archivium, progressivo_invio, timestamp_invio, note_invio, xml,
--   data_consegna, token
-- - commercio: id_coupon, id_carrello, id_carrelli_articoli
-- - magazzino: id_mastro_provenienza, id_mastro_destinazione
-- - trasporto: id_causale, id_trasportatore, porto
-- - collegamenti: id_pianificazione, id_progetto
-- - note: note, note_consegna, note_cliente
-- - chiusura: timestamp_chiusura, note_chiusura
-- - archiviazione e audit
--
-- NOTA il legame col carrello si scrive solo dal lato del documento: id_carrello per il carrello, id_carrelli_articoli
-- per la singola riga di carrello; se un documento ha id_carrelli_articoli, il suo id_carrello è il carrello di quella
-- riga ( regola applicativa, non imposta dal database )
--
-- NOTA i mastri di tipo magazzino li valorizzano le righe del documento, che hanno i loro mastri di provenienza e di
-- destinazione; quelli della testata sono solo il default delle righe che vi si aggiungono
--
CREATE TABLE IF NOT EXISTS `documenti` (                        --
  `id` bigint(20) NOT NULL,                                       -- chiave primaria
  `id_tipologia` bigint(20) DEFAULT NULL,                         -- chiave esterna per la tipologia di documento
  `codice` char(32) DEFAULT NULL,                                 -- codice del documento
  `numero` char(32) DEFAULT NULL,                                 -- numero del documento
  `sezionale` char(32) DEFAULT NULL,                              -- sezionale del documento
  `data` date DEFAULT NULL,                                       -- data del documento
  `nome` char(255) DEFAULT NULL,                                  -- nome del documento
  `id_emittente` bigint(20) DEFAULT NULL,                         -- chiave esterna per l'anagrafica emittente
  `id_referente_emittente` bigint(20) DEFAULT NULL,               -- chiave esterna per il referente dell'anagrafica emittente
  `id_sede_emittente` bigint(20) DEFAULT NULL,                    -- chiave esterna per la sede dell'anagrafica emittente
  `id_destinatario` bigint(20) DEFAULT NULL,                      -- chiave esterna per l'anagrafica destinataria
  `id_sede_destinatario` bigint(20) DEFAULT NULL,                 -- chiave esterna per la sede dell'anagrafica destinataria
  `id_destinatario_spedizione` bigint(20) DEFAULT NULL,           -- chiave esterna per l'anagrafica destinataria della spedizione
  `id_sede_destinatario_spedizione` bigint(20) DEFAULT NULL,      -- chiave esterna per la sede della spedizione
  `note_spedizione` text DEFAULT NULL,                            -- note per la spedizione
  `id_condizione_pagamento` bigint(20) DEFAULT NULL,              -- chiave esterna per la condizione di pagamento
  `esigibilita` enum('I','D','S') DEFAULT NULL,                   -- esigibilità dell'IVA ( immediata, differita, split payment )
  `se_bollo_virtuale` tinyint(1) DEFAULT NULL,                    -- se l'imposta di bollo è assolta in modo virtuale
  `importo_bollo` decimal(16,2) DEFAULT NULL,                     -- importo dell'imposta di bollo
  `cig` char(16) DEFAULT NULL,                                    -- codice identificativo di gara
  `cup` char(16) DEFAULT NULL,                                    -- codice unico di progetto
  `riferimento` char(255) DEFAULT NULL,                           -- riferimento del documento
  `codice_sdi` char(64) DEFAULT NULL,                             -- identificativo assegnato dal Sistema di Interscambio
  `codice_archivium` char(64) DEFAULT NULL,                       -- codice per la conservazione in Archivium
  `progressivo_invio` char(5) DEFAULT NULL,                       -- progressivo di invio della fattura elettronica
  `timestamp_invio` int(11) DEFAULT NULL,                         -- timestamp di invio della fattura elettronica
  `note_invio` text DEFAULT NULL,                                 -- note sull'invio della fattura elettronica
  `xml` longtext DEFAULT NULL,                                    -- XML della fattura elettronica
  `data_consegna` date DEFAULT NULL,                              -- data di consegna della fattura elettronica
  `token` char(128) DEFAULT NULL,                                 -- token per la gestione della fattura elettronica
  `id_coupon` bigint(20) DEFAULT NULL,                            -- chiave esterna per il coupon usato nel documento
  `id_carrello` bigint(20) DEFAULT NULL,                          -- chiave esterna per il carrello da cui nasce il documento
  `id_carrelli_articoli` bigint(20) DEFAULT NULL,                 -- chiave esterna per la riga di carrello da cui nasce il documento
  `id_mastro_provenienza` bigint(20) DEFAULT NULL,                -- chiave esterna per il mastro di provenienza
  `id_mastro_destinazione` bigint(20) DEFAULT NULL,               -- chiave esterna per il mastro di destinazione
  `id_causale` bigint(20) DEFAULT NULL,                           -- chiave esterna per la causale del trasporto
  `id_trasportatore` bigint(20) DEFAULT NULL,                     -- chiave esterna per l'anagrafica del trasportatore
  `porto` enum('franco','assegnato','-') DEFAULT NULL,            -- porto del trasporto
  `id_pianificazione` bigint(20) DEFAULT NULL,                    -- chiave esterna per la pianificazione che ha generato il documento
  `id_progetto` bigint(20) DEFAULT NULL,                          -- chiave esterna per il progetto collegato al documento
  `note` text DEFAULT NULL,                                       -- note sul documento
  `note_consegna` text DEFAULT NULL,                              -- note sulla consegna
  `note_cliente` text DEFAULT NULL,                               -- note per il cliente
  `timestamp_chiusura` int(11) DEFAULT NULL,                      -- timestamp di chiusura del documento
  `note_chiusura` text DEFAULT NULL,                              -- note di chiusura
  `id_account_archiviazione` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha archiviato il documento
  `data_archiviazione` date DEFAULT NULL,                         -- data di archiviazione
  `note_archiviazione` text DEFAULT NULL,                         -- note di archiviazione
  `id_account_inserimento` bigint(20) DEFAULT NULL,               -- chiave esterna per l'account che ha inserito il documento
  `timestamp_inserimento` int(11) DEFAULT NULL,                   -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha aggiornato il documento
  `timestamp_aggiornamento` int(11) DEFAULT NULL                  -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                           --

-- | 010000010000

-- documenti_articoli
-- tipologia: tabella gestita
-- rango: tabella secondaria
-- struttura: tabella ricorsiva
-- funzione: contiene le righe dei documenti, cioè i movimenti di articoli, quantità e importi
--
-- questa tabella è una delle più critiche del framework: ogni riga è un movimento, e da queste righe si calcolano
-- giacenze, crediti, ore e vendite; il calcolo dei mastri è comune a tutti questi casi e appartiene al modulo mastri,
-- quindi ogni modifica a questa tabella va valutata dal punto di vista di tutti i moduli che la leggono
--
-- le colonne sono raggruppate per funzione, nell'ordine in cui compaiono:
-- - testata: id_genitore, id_tipologia, id_tipologia_documento, ordine, codice, nome
-- - documenti: id_documento, data, id_missione, id_packing_list
-- - anagrafiche: id_emittente, id_destinatario
-- - articolo: id_articolo, id_prodotto, id_lotto, id_matricola, id_udm, quantita_prevista, quantita
-- - magazzino: id_mastro_provenienza, id_mastro_destinazione, id_collo
-- - importi: id_listino, costi, prezzi, importi, sconti, se_ritenuta
-- - commercio: id_carrello, id_carrelli_articoli, id_rinnovo
-- - collegamenti: id_reparto, id_progetto, id_todo, id_attivita, id_pianificazione, id_immobile
-- - testo: specifiche, note
-- - consegna: data_consegna, note_consegna
-- - audit
--
-- NOTA il movimento lo fa la riga: i mastri di provenienza e di destinazione della testata del documento sono solo il
-- default delle righe che vi si aggiungono, e la giacenza si calcola per mastro, articolo, lotto e matricola
--
-- NOTA una riga ha un solo lotto e una sola matricola; se ha la matricola, id_lotto è quello della matricola
--
-- NOTA una riga può esistere senza documento, e il documento le si può assegnare dopo; id_tipologia_documento dice il
-- tipo di documento atteso dalla riga, e le viste usano coalesce( id_tipologia_documento, documenti.id_tipologia )
--
-- NOTA una riga può stare su più documenti, che ne rappresentano aspetti diversi: la fattura del bullone
-- ( id_documento ), la missione che lo preleva ( id_missione ), la packing list che lo spedisce ( id_packing_list );
-- le aggregazioni e le evasioni ( un ordine evaso da più documenti, a loro volta fatturati in più fatture ) stanno
-- invece in relazioni_documenti_articoli
--
-- NOTA le righe figlie ( id_genitore ) sono di raggruppamento, di dettaglio o di evasione, secondo i flag se_dettaglio
-- e se_evasione della loro tipologia; un prodotto può essere evaso da articoli di taglio diverso, convertendo peso e
-- unità di misura ( vedi __report_evasione_righe_ordini__ )
--
-- NOTA la chiave esterna id_documento è ON DELETE NO ACTION ON UPDATE CASCADE: un documento si cancella solo dopo
-- averne tolto le righe, cosa che fanno i controller ricalcolando la giacenza
--
CREATE TABLE IF NOT EXISTS `documenti_articoli` (               --
  `id` bigint(20) NOT NULL,                                       -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                          -- chiave esterna per la riga genitore ( raggruppamento, dettaglio o evasione )
  `id_tipologia` bigint(20) DEFAULT NULL,                         -- chiave esterna per la tipologia della riga ( tipologie_documenti_articoli )
  `id_tipologia_documento` bigint(20) DEFAULT NULL,               -- chiave esterna per il tipo di documento atteso dalla riga, fino al 2026-09-15 si chiamava id_tipologia
  `ordine` int(11) DEFAULT NULL,                                  -- ordine di visualizzazione
  `codice` char(32) DEFAULT NULL,                                 -- codice della riga
  `nome` char(255) DEFAULT NULL,                                  -- descrizione della riga
  `id_documento` bigint(20) DEFAULT NULL,                         -- chiave esterna per il documento di appartenenza, si può assegnare dopo
  `data` date DEFAULT NULL,                                       -- data della riga, se diversa da quella del documento
  `id_missione` bigint(20) DEFAULT NULL,                          -- chiave esterna per il documento della missione ( prelievo, deposito ) che movimenta la riga
  `id_packing_list` bigint(20) DEFAULT NULL,                      -- chiave esterna per il documento della packing list che spedisce la riga
  `id_emittente` bigint(20) DEFAULT NULL,                         -- chiave esterna per l'anagrafica emittente, se diversa da quella del documento
  `id_destinatario` bigint(20) DEFAULT NULL,                      -- chiave esterna per l'anagrafica destinataria, se diversa da quella del documento
  `id_articolo` bigint(20) DEFAULT NULL,                          -- chiave esterna per l'articolo
  `id_prodotto` bigint(20) DEFAULT NULL,                          -- chiave esterna per il prodotto, per le righe che non indicano l'articolo
  `id_lotto` bigint(20) DEFAULT NULL,                             -- chiave esterna per il lotto ( la giacenza si calcola per mastro, articolo, lotto e matricola )
  `id_matricola` bigint(20) DEFAULT NULL,                         -- chiave esterna per la matricola
  `id_udm` bigint(20) DEFAULT NULL,                               -- chiave esterna per l'unità di misura
  `quantita_prevista` decimal(9,2) DEFAULT NULL,                  -- quantità prevista
  `quantita` decimal(9,2) DEFAULT NULL,                           -- quantità movimentata
  `id_mastro_provenienza` bigint(20) DEFAULT NULL,                -- chiave esterna per il mastro di provenienza
  `id_mastro_destinazione` bigint(20) DEFAULT NULL,               -- chiave esterna per il mastro di destinazione
  `id_collo` bigint(20) DEFAULT NULL,                             -- chiave esterna per il collo che contiene la riga
  `id_listino` bigint(20) DEFAULT NULL,                           -- chiave esterna per il listino applicato
  `costo_netto_unitario` decimal(16,2) DEFAULT NULL,              -- costo netto unitario
  `costo_netto_totale` decimal(16,2) DEFAULT NULL,                -- costo netto totale
  `note_costi` text DEFAULT NULL,                                 -- note sui costi
  `prezzo_netto_unitario` decimal(16,2) DEFAULT NULL,             -- prezzo netto unitario
  `prezzo_netto_totale` decimal(16,2) DEFAULT NULL,               -- prezzo netto totale
  `importo_netto_totale` decimal(16,2) DEFAULT NULL,              -- importo netto totale
  `importo_lordo_totale` decimal(16,2) DEFAULT NULL,              -- importo lordo totale
  `sconto_percentuale` decimal(9,2) DEFAULT NULL,                 -- sconto percentuale
  `sconto_valore` decimal(9,2) DEFAULT NULL,                      -- sconto in valore assoluto
  `importo_lordo_finale` decimal(16,2) DEFAULT NULL,              -- importo lordo finale
  `se_ritenuta` tinyint(1) DEFAULT NULL,                          -- se la riga è soggetta a ritenuta ( Ritenuta della fattura elettronica )
  `id_carrello` bigint(20) DEFAULT NULL,                          -- chiave esterna per il carrello da cui viene la riga
  `id_carrelli_articoli` bigint(20) DEFAULT NULL,                 -- chiave esterna per la riga di carrello da cui viene la riga
  `id_rinnovo` bigint(20) DEFAULT NULL,                           -- chiave esterna per il rinnovo
  `id_reparto` bigint(20) DEFAULT NULL,                           -- chiave esterna per il reparto
  `id_progetto` bigint(20) DEFAULT NULL,                          -- chiave esterna per il progetto
  `id_todo` bigint(20) DEFAULT NULL,                              -- chiave esterna per la todo
  `id_attivita` bigint(20) DEFAULT NULL,                          -- chiave esterna per l'attività
  `id_pianificazione` bigint(20) DEFAULT NULL,                    -- chiave esterna per la pianificazione che ha generato la riga
  `id_immobile` bigint(20) DEFAULT NULL,                          -- chiave esterna per l'immobile
  `specifiche` text DEFAULT NULL,                                 -- specifiche della riga
  `note` text DEFAULT NULL,                                       -- note sulla riga
  `data_consegna` date DEFAULT NULL,                              -- data di consegna
  `note_consegna` text DEFAULT NULL,                              -- note sulla consegna
  `id_account_inserimento` bigint(20) DEFAULT NULL,               -- chiave esterna per l'account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                   -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha aggiornato la riga
  `timestamp_aggiornamento` int(11) DEFAULT NULL                  -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                           --

-- | 010000010050

-- documenti_casse_previdenziali
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: associa ai documenti i contributi alle casse previdenziali
--
-- questa tabella contiene i contributi alle casse di previdenza addebitati in un documento, con i dati del blocco
-- DatiCassaPrevidenziale della fattura elettronica; imponibile e importo, se vuoti, li calcola generaContenutiDocumento()
--
-- il contributo è quello integrativo ( o la rivalsa INPS ) che il professionista addebita al cliente e versa alla
-- cassa, non quello trattenuto dal cliente ( ENASARCO, quota INPS dei collaboratori ), che sta in documenti_ritenute;
-- un documento può avere più casse, e la stessa cassa due volte con IVA diversa ( compenso in parte imponibile e in
-- parte esente ), per questo la chiave unica comprende id_iva; ordine dà la sequenza dei blocchi nell'XML
--
CREATE TABLE IF NOT EXISTS `documenti_casse_previdenziali` (    --
  `id` bigint(20) NOT NULL,                                        -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                   -- ordine dei blocchi DatiCassaPrevidenziale nel documento
  `id_documento` bigint(20) DEFAULT NULL,                          -- chiave esterna per il documento
  `id_cassa_previdenziale` bigint(20) DEFAULT NULL,                -- chiave esterna per la cassa previdenziale ( TipoCassa )
  `aliquota` decimal(5,2) DEFAULT NULL,                            -- aliquota del contributo ( AlCassa )
  `imponibile` decimal(16,2) DEFAULT NULL,                         -- importo su cui si calcola il contributo, se diverso dal totale delle righe ( ImponibileCassa )
  `importo` decimal(16,2) DEFAULT NULL,                            -- importo del contributo, se diverso da quello calcolato ( ImportoContributoCassa )
  `id_iva` bigint(20) DEFAULT NULL,                                -- chiave esterna per l'aliquota IVA del contributo ( AliquotaIVA e Natura )
  `se_ritenuta` tinyint(1) DEFAULT NULL,                           -- se il contributo è soggetto a ritenuta ( Ritenuta )
  `riferimento_amministrazione` char(20) DEFAULT NULL,             -- riferimento contabile del cedente ( RiferimentoAmministrazione )
  `id_account_inserimento` bigint(20) DEFAULT NULL,                -- chiave esterna per l'account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                    -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,              -- chiave esterna per l'account che ha aggiornato la riga
  `timestamp_aggiornamento` int(11) DEFAULT NULL                   -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                           --

-- | 010000010100

-- documenti_ritenute
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: associa ai documenti le ritenute
--
-- questa tabella contiene le ritenute applicate a un documento, con i dati del blocco DatiRitenuta della fattura
-- elettronica; l'importo, se vuoto, lo calcola generaContenutiDocumento() sulle righe soggette a ritenuta
--
-- la ritenuta è quella che il cliente trattiene e versa al posto del cedente ( d'acconto, ENASARCO, quota INPS dei
-- collaboratori ), non il contributo che il cedente addebita, che sta in documenti_casse_previdenziali; lo schema
-- ammette un blocco per tipo di ritenuta, per questo la chiave unica è ( id_documento, id_ritenuta ); ordine dà la
-- sequenza dei blocchi nell'XML
--
CREATE TABLE IF NOT EXISTS `documenti_ritenute` (               --
  `id` bigint(20) NOT NULL,                                        -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                   -- ordine dei blocchi DatiRitenuta nel documento
  `id_documento` bigint(20) DEFAULT NULL,                          -- chiave esterna per il documento
  `id_ritenuta` bigint(20) DEFAULT NULL,                           -- chiave esterna per il tipo di ritenuta ( TipoRitenuta )
  `aliquota` decimal(5,2) DEFAULT NULL,                            -- aliquota della ritenuta ( AliquotaRitenuta )
  `causale_pagamento` char(2) DEFAULT NULL,                        -- causale del pagamento, codice della Certificazione Unica ( CausalePagamento )
  `importo` decimal(16,2) DEFAULT NULL,                            -- importo della ritenuta, se diverso da quello calcolato ( ImportoRitenuta )
  `id_account_inserimento` bigint(20) DEFAULT NULL,                -- chiave esterna per l'account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                    -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,              -- chiave esterna per l'account che ha aggiornato la riga
  `timestamp_aggiornamento` int(11) DEFAULT NULL                   -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                           --

-- | 010000012000

-- edifici
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella ricorsiva
-- funzione: contiene gli edifici, e i complessi di edifici che li contengono
-- entità: questa tabella corrisponde all'entità edificio
--
-- questa tabella è un livello della catena della geografia fisica, che va dall'indirizzo ai vani passando per edifici
-- e immobili; è ricorsiva perché i complessi più articolati ( un polo industriale coi suoi capannoni, un campus coi
-- suoi padiglioni ) si descrivono come edifici genitori di altri edifici, su quanti livelli servono, e id_genitore
-- punta all'edificio o al complesso che contiene questo; l'indirizzo è facoltativo sui figli, che ereditano quello
-- del complesso, e se lo si cancella l'edificio resta; un mastro di magazzino può essere collocato a uno qualsiasi
-- dei livelli della catena ( indirizzo, edificio, immobile, vano )
--
CREATE TABLE IF NOT EXISTS `edifici` (                          --
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                        -- chiave esterna per l'edificio o il complesso che contiene questo
  `id_tipologia` bigint(20) DEFAULT NULL,                       -- chiave esterna per la tipologia di edificio
  `codice` char(32) DEFAULT NULL,                               -- codice dell'edificio
  `nome` char(255) DEFAULT NULL,                                -- nome dell'edificio
  `id_indirizzo` bigint(20) DEFAULT NULL,                       -- chiave esterna per l'indirizzo dell'edificio
  `piani` int(11) DEFAULT NULL,                                 -- numero di piani
  `note` text DEFAULT NULL,                                     -- note sull'edificio
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha inserito l'edificio
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha aggiornato l'edificio
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                          --

-- | 010000012010

-- edifici_anagrafica
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: collega un edificio alle anagrafiche che hanno un ruolo su di esso
--
-- questa tabella collega un edificio alle anagrafiche che vi hanno un ruolo ( l'amministratore condominiale,
-- la guardia di un deposito...; un complesso di edifici e' un edificio genitore, perche' edifici e' ricorsiva );
-- e' gemella di immobili_anagrafica e vani_anagrafica ( decisione del 16/10/2026 ): le anagrafiche si
-- assegnano a tutti i livelli degli immobili; i ruoli proponibili sono quelli con ruoli_anagrafica.se_immobili
--
-- NOTA la chiave unica e' ( id_edificio, id_anagrafica, id_ruolo ): la stessa anagrafica puo' avere piu' ruoli
--
CREATE TABLE IF NOT EXISTS `edifici_anagrafica` (               --
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                -- ordine di visualizzazione
  `id_edificio` bigint(20) DEFAULT NULL,                        -- chiave esterna per l'edificio
  `id_anagrafica` bigint(20) DEFAULT NULL,                      -- chiave esterna per l'anagrafica
  `id_ruolo` bigint(20) DEFAULT NULL,                           -- chiave esterna per il ruolo ( ruoli_anagrafica )
  `note` text DEFAULT NULL,                                     -- note
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha aggiornato la riga
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                           --

-- | 010000012050

-- edifici_caratteristiche
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: collega un edificio alle sue caratteristiche
--
-- questa tabella collega un edificio all'albero delle caratteristiche ( caratteristiche ) e ne porta
-- il valore. E' gemella di articoli_caratteristiche, come immobili_caratteristiche e indirizzi_caratteristiche ( decisione
-- del 15/10/2026: prima era un si'/no con se_presente ): il valore e' per lingua, quindi id_lingua
-- fa parte della chiave unica, e se_assente dichiara che la caratteristica non c'e'. Le caratteristiche
-- proponibili sono quelle con caratteristiche.se_edifici.
--
CREATE TABLE IF NOT EXISTS `edifici_caratteristiche` (
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                -- ordine di visualizzazione
  `id_edificio` bigint(20) DEFAULT NULL,                        -- chiave esterna per l'edificio
  `id_caratteristica` bigint(20) DEFAULT NULL,                  -- chiave esterna per la caratteristica
  `id_lingua` bigint(20) DEFAULT NULL,                          -- chiave esterna per la lingua del valore
  `valore` text DEFAULT NULL,                                   -- valore della caratteristica
  `note` text DEFAULT NULL,                                     -- note
  `se_assente` tinyint(1) DEFAULT NULL,                         -- la caratteristica e' dichiarata assente
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account di inserimento
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account di aggiornamento
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000015000

-- file
-- tipologia: tabella gestita
-- rango: tabella secondaria
-- struttura: tabella base
-- funzione: contiene i file collegati agli oggetti delle tabelle principali
--
-- questa tabella fa parte del gruppo delle tabelle dei media ( audio, video, immagini, file ), che collegano un
-- media a un oggetto di una tabella principale; ogni riga descrive un oggetto solo, indicato da una delle chiavi
-- esterne id_*, ed è qualificata dalla lingua e dal ruolo che il media ha per quell'oggetto; lo stesso file può
-- descrivere più oggetti, e per questo le chiavi uniche sono una per oggetto e non una globale sul path
--
-- NOTA è la tabella del gruppo con più oggetti collegati, e per stare sotto il limite di 64 indici secondari di
-- InnoDB non ha le chiavi semplici sulle colonne id_* che fanno da prima colonna di una chiave unica: la chiave
-- unica fa da indice della colonna anche per la chiave esterna; la regola vale per tutto il gruppo dei media
-- ( decisione del 2026-10-15 )
--
-- NOTA le chiavi esterne verso gli oggetti descritti sono CASCADE: un file non ha senso senza il suo oggetto, e
-- se l'oggetto viene cancellato le sue righe se ne vanno con lui; fanno eccezione id_mail_out e id_mail_sent, che
-- restano SET NULL perché la coda della posta sposta gli allegati dalla mail in uscita a quella inviata ( e
-- viceversa al reinvio ) prima di cancellare la mail di partenza
--
CREATE TABLE IF NOT EXISTS `file` (                             --
  `id` bigint(20) NOT NULL,                                       -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                  -- ordine di visualizzazione del file
  `nome` char(255) DEFAULT NULL,                                  -- nome del file
  `id_anagrafica` bigint(20) DEFAULT NULL,                        -- chiave esterna per l'anagrafica descritta
  `id_annuncio` bigint(20) DEFAULT NULL,                          -- chiave esterna per l'annuncio descritto
  `id_prodotto` bigint(20) DEFAULT NULL,                          -- chiave esterna per il prodotto descritto
  `id_articolo` bigint(20) DEFAULT NULL,                          -- chiave esterna per l'articolo descritto
  `id_lingua` bigint(20) DEFAULT NULL,                            -- chiave esterna per la lingua del file
  `id_indirizzo` bigint(20) DEFAULT NULL,                         -- chiave esterna per l'indirizzo descritto
  `id_progetto` bigint(20) DEFAULT NULL,                          -- chiave esterna per il progetto descritto
  `id_contratto` bigint(20) DEFAULT NULL,                         -- chiave esterna per il contratto descritto
  `id_todo` bigint(20) DEFAULT NULL,                              -- chiave esterna per la todo descritta
  `id_immobile` bigint(20) DEFAULT NULL,                          -- chiave esterna per l'immobile descritto
  `id_mailing` bigint(20) DEFAULT NULL,                           -- chiave esterna per la mailing descritta
  `id_documento` bigint(20) DEFAULT NULL,                         -- chiave esterna per il documento descritto
  `id_pagina` bigint(20) DEFAULT NULL,                            -- chiave esterna per la pagina descritta
  `id_categoria_prodotti` bigint(20) DEFAULT NULL,                -- chiave esterna per la categoria prodotti descritta
  `id_marchio` bigint(20) DEFAULT NULL,                           -- chiave esterna per il marchio descritto
  `id_categoria_marchi` bigint(20) DEFAULT NULL,                  -- chiave esterna per la categoria di marchi descritta
  `id_risorsa` bigint(20) DEFAULT NULL,                           -- chiave esterna per la risorsa descritta
  `id_categoria_risorse` bigint(20) DEFAULT NULL,                 -- chiave esterna per la categoria risorse descritta
  `id_notizia` bigint(20) DEFAULT NULL,                           -- chiave esterna per la notizia descritta
  `id_categoria_notizie` bigint(20) DEFAULT NULL,                 -- chiave esterna per la categoria notizie descritta
  `id_categoria_annunci` bigint(20) DEFAULT NULL,                 -- chiave esterna per la categoria annunci descritta
  `id_categoria_progetti` bigint(20) DEFAULT NULL,                -- chiave esterna per la categoria progetti descritta
  `id_edificio` bigint(20) DEFAULT NULL,                          -- chiave esterna per l'edificio descritto
  `id_valutazione` bigint(20) DEFAULT NULL,                       -- chiave esterna per la valutazione descritta
  `id_licenza` bigint(20) DEFAULT NULL,                           -- chiave esterna per la licenza descritta
  `id_anagrafica_certificazioni` bigint(20) DEFAULT NULL,         -- chiave esterna per la certificazione dell'anagrafica descritta
  `id_template` bigint(20) DEFAULT NULL,                          -- chiave esterna per il template descritto
  `id_rinnovo` bigint(20) DEFAULT NULL,                           -- chiave esterna per il rinnovo descritto
  `id_valutazione_certificazioni` bigint(20) DEFAULT NULL,        -- chiave esterna per la certificazione della valutazione descritta
  `id_mail_out` bigint(20) DEFAULT NULL,                          -- chiave esterna per la mail in uscita a cui il file è allegato
  `id_mail_sent` bigint(20) DEFAULT NULL,                         -- chiave esterna per la mail inviata a cui il file è allegato
  `id_attivita` bigint(20) DEFAULT NULL,                          -- chiave esterna per l'attività descritta
  `id_audio` bigint(20) DEFAULT NULL,                             -- chiave esterna per l'audio descritto
  `id_video` bigint(20) DEFAULT NULL,                             -- chiave esterna per il video descritto
  `id_immagine` bigint(20) DEFAULT NULL,                          -- chiave esterna per l'immagine descritta
  `id_vano` bigint(20) DEFAULT NULL,                            -- chiave esterna per il vano descritto
  `id_ruolo` bigint(20) DEFAULT NULL,                             -- chiave esterna per il ruolo del file
  `path` char(255) DEFAULT NULL,                                  -- percorso del file
  `url` char(255) DEFAULT NULL,                                   -- URL del file
  `note` text DEFAULT NULL,                                       -- note
  `id_account_inserimento` bigint(20) DEFAULT NULL,               -- account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                   -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,             -- account che ha aggiornato la riga per ultimo
  `timestamp_aggiornamento` int(11) DEFAULT NULL                  -- timestamp dell'ultimo aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000015100

-- formati_tipologie_corrispondenza
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene i formati ammessi per ogni tipologia di corrispondenza
--
-- questa tabella contiene i formati della corrispondenza cartacea ( p.es. piccolo, medio ed extra per la posta
-- ordinaria ): ogni formato appartiene a una tipologia e ha le dimensioni minime e massime della busta o del plico, da
-- cui dipende la tariffa. La tabella appartiene al modulo corrispondenza.
-- NOTA le dimensioni sono un blocco con la sua id_udm_dimensioni, come in colli; dimensioni a zero o nulle vogliono
-- dire che il formato non pone limiti
--
CREATE TABLE IF NOT EXISTS `formati_tipologie_corrispondenza` (--
  `id` bigint(20) NOT NULL,                                   -- chiave primaria
  `id_tipologia` bigint(20) DEFAULT NULL,                     -- tipologia di corrispondenza a cui il formato appartiene
  `nome` char(255) DEFAULT NULL,                              -- nome del formato
  `altezza_min` decimal(7,2) DEFAULT NULL,                    -- altezza minima
  `larghezza_min` decimal(7,2) DEFAULT NULL,                  -- larghezza minima
  `spessore_min` decimal(7,2) DEFAULT NULL,                   -- spessore minimo
  `altezza_max` decimal(7,2) DEFAULT NULL,                    -- altezza massima
  `larghezza_max` decimal(7,2) DEFAULT NULL,                  -- larghezza massima
  `spessore_max` decimal(7,2) DEFAULT NULL,                   -- spessore massimo
  `id_udm_dimensioni` bigint(20) DEFAULT NULL,                -- unità di misura delle dimensioni
  `id_account_inserimento` bigint(20) DEFAULT NULL,           -- account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,               -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,         -- account che ha aggiornato la riga per ultimo
  `timestamp_aggiornamento` int(11) DEFAULT NULL              -- timestamp dell'ultimo aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000015150

-- giorni
-- tipologia: tabella standard
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene i giorni della settimana
--
-- i giorni della settimana, da lunedì a domenica, caricati dai file di base; il nome è in italiano, ad uso interno.
-- La tabella fa parte del framework col suo contenuto: non si modifica dalle interfacce, e per questo non ha la coda
-- di audit.
-- NOTA l'id è il numero del giorno secondo ISO-8601, lo stesso di date( 'N' ) in PHP e di WEEKDAY() + 1 in MySQL
-- ( 1 lunedì … 7 domenica; non DAYOFWEEK(), che parte dalla domenica ): il codice lo confronta con le date, quindi
-- gli id non si cambiano
CREATE TABLE IF NOT EXISTS `giorni` (                         --
  `id` bigint(20) NOT NULL,                                   -- chiave primaria, numero ISO-8601 del giorno
  `nome` char(255) DEFAULT NULL                               -- nome del giorno
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000015200

-- gruppi
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella ricorsiva
-- funzione: contiene i gruppi del framework
--
-- questa tabella contiene i gruppi degli utenti del framework, ed è in relazione molti a molti con la tabella account
-- tramite la tabella di relazione account_gruppi
--
CREATE TABLE IF NOT EXISTS `gruppi` (                         --
  `id` bigint(20) NOT NULL,                                      -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                         -- chiave esterna ricorsiva per il gruppo genitore
  `id_organizzazione` bigint(20) DEFAULT NULL,                   -- chiave esterna per l'organizzazione a cui appartiene il gruppo
  `nome` char(32) DEFAULT NULL,                               -- nome del gruppo
  `id_account_inserimento` bigint(20) DEFAULT NULL,              -- chiave esterna per l'account che ha inserito il gruppo
  `timestamp_inserimento` int(11) DEFAULT NULL,               -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,            -- chiave esterna per l'account che ha aggiornato il gruppo
  `timestamp_aggiornamento` int(11) DEFAULT NULL              -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000015400

-- iban
-- tipologia: tabella gestita
-- rango: tabella secondaria
-- struttura: tabella base
-- funzione: contiene i conti correnti ( IBAN ) delle anagrafiche
--
-- questa tabella contiene i conti correnti di un'anagrafica, una riga per conto, con l'intestazione del conto;
-- i conti si usano per dire su quale conto si paga o si incassa un pagamento ( pagamenti.id_iban ) e per
-- precompilarlo nel modello di una pianificazione ( pianificazioni.model_id_iban ), e finiscono nella fattura
-- elettronica
--
-- NOTA la colonna iban è lunga 34 caratteri, il massimo dello standard ISO 13616: un IBAN italiano ne ha 27, ma
-- quelli esteri arrivano a 34 ( decisione del 2026-10-15 )
--
-- NOTA la chiave esterna verso l'anagrafica è CASCADE: un conto non ha senso senza la sua anagrafica; lo stesso
-- conto non si registra due volte sulla stessa anagrafica ( chiave unica su id_anagrafica e iban )
--
-- NOTA il conto di default di un'anagrafica è il primo nell'ordine ( ORDER BY ordine IS NULL, ordine, id ),
-- decisione del 2026-10-19 comune ai recapiti dell'anagrafica ( mail, telefoni, iban )
--
CREATE TABLE IF NOT EXISTS `iban` (                             --
  `id` bigint(20) NOT NULL,                                       -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                  -- ordine del conto fra quelli dell'anagrafica, il primo è quello di default
  `id_anagrafica` bigint(20) DEFAULT NULL,                        -- chiave esterna per l'anagrafica titolare del conto
  `intestazione` char(255) DEFAULT NULL,                          -- intestazione del conto
  `iban` char(34) DEFAULT NULL,                                   -- codice IBAN del conto
  `note` text DEFAULT NULL,                                       -- note sul conto
  `id_account_inserimento` bigint(20) DEFAULT NULL,               -- chiave esterna per l'account che ha inserito il conto
  `timestamp_inserimento` int(11) DEFAULT NULL,                   -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha aggiornato il conto
  `timestamp_aggiornamento` int(11) DEFAULT NULL                  -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                           --

-- | 010000015600

-- immagini
-- tipologia: tabella gestita
-- rango: tabella secondaria
-- struttura: tabella base
-- funzione: contiene le immagini collegate agli oggetti delle tabelle principali
--
-- questa tabella fa parte del gruppo delle tabelle dei media ( audio, video, immagini, file ), che collegano un
-- media a un oggetto di una tabella principale; ogni riga descrive un oggetto solo, indicato da una delle chiavi
-- esterne id_*, ed è qualificata dalla lingua e dal ruolo che il media ha per quell'oggetto; lo stesso file può
-- descrivere più oggetti, e per questo le chiavi uniche sono una per oggetto e non una globale sul path
--
-- NOTA un media può appartenere a ciascuno degli altri tre ( matrice dei media, decisa il 2026-10-16 ): per questo
-- l'immagine ha id_file, id_audio e id_video ( la copertina di un audio o di un video, l'anteprima di un file ); la
-- colonna sta sempre sul media che appartiene e punta a quello a cui appartiene
--
-- NOTA path_alternativo, orientamento, taglio, token e timestamp_scalamento sono colonne proprie delle immagini: le
-- usano lo scalamento ( _images.resize.php del modulo _IM000.immagini ) e aggiungiDati() in _mysql.utils.php
--
-- NOTA le chiavi esterne verso gli oggetti descritti sono CASCADE: un'immagine non ha senso senza il suo oggetto, e
-- se l'oggetto viene cancellato le sue righe se ne vanno con lui
--
CREATE TABLE IF NOT EXISTS `immagini` (                         --
  `id` bigint(20) NOT NULL,                                       -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                  -- ordine di visualizzazione dell'immagine
  `nome` char(255) DEFAULT NULL,                                  -- nome dell'immagine
  `id_anagrafica` bigint(20) DEFAULT NULL,                        -- chiave esterna per l'anagrafica descritta
  `id_annuncio` bigint(20) DEFAULT NULL,                          -- chiave esterna per l'annuncio descritto
  `id_prodotto` bigint(20) DEFAULT NULL,                          -- chiave esterna per il prodotto descritto
  `id_articolo` bigint(20) DEFAULT NULL,                          -- chiave esterna per l'articolo descritto
  `id_lingua` bigint(20) DEFAULT NULL,                            -- chiave esterna per la lingua dell'immagine
  `id_contatto` bigint(20) DEFAULT NULL,                          -- chiave esterna per il contatto descritto
  `id_indirizzo` bigint(20) DEFAULT NULL,                         -- chiave esterna per l'indirizzo descritto
  `id_progetto` bigint(20) DEFAULT NULL,                          -- chiave esterna per il progetto descritto
  `id_contratto` bigint(20) DEFAULT NULL,                         -- chiave esterna per il contratto descritto
  `id_immobile` bigint(20) DEFAULT NULL,                          -- chiave esterna per l'immobile descritto
  `id_pagina` bigint(20) DEFAULT NULL,                            -- chiave esterna per la pagina descritta
  `id_file` bigint(20) DEFAULT NULL,                              -- chiave esterna per il file descritto
  `id_categoria_prodotti` bigint(20) DEFAULT NULL,                -- chiave esterna per la categoria prodotti descritta
  `id_marchio` bigint(20) DEFAULT NULL,                           -- chiave esterna per il marchio descritto
  `id_categoria_marchi` bigint(20) DEFAULT NULL,                  -- chiave esterna per la categoria di marchi descritta
  `id_risorsa` bigint(20) DEFAULT NULL,                           -- chiave esterna per la risorsa descritta
  `id_categoria_risorse` bigint(20) DEFAULT NULL,                 -- chiave esterna per la categoria risorse descritta
  `id_notizia` bigint(20) DEFAULT NULL,                           -- chiave esterna per la notizia descritta
  `id_categoria_notizie` bigint(20) DEFAULT NULL,                 -- chiave esterna per la categoria notizie descritta
  `id_categoria_annunci` bigint(20) DEFAULT NULL,                 -- chiave esterna per la categoria annunci descritta
  `id_categoria_progetti` bigint(20) DEFAULT NULL,                -- chiave esterna per la categoria progetti descritta
  `id_edificio` bigint(20) DEFAULT NULL,                          -- chiave esterna per l'edificio descritto
  `id_valutazione` bigint(20) DEFAULT NULL,                       -- chiave esterna per la valutazione descritta
  `id_rinnovo` bigint(20) DEFAULT NULL,                           -- chiave esterna per il rinnovo descritto
  `id_banner` bigint(20) DEFAULT NULL,                            -- chiave esterna per il banner descritto
  `id_audio` bigint(20) DEFAULT NULL,                             -- chiave esterna per l'audio descritto
  `id_video` bigint(20) DEFAULT NULL,                             -- chiave esterna per il video descritto
  `id_vano` bigint(20) DEFAULT NULL,                            -- chiave esterna per il vano descritto
  `id_ruolo` bigint(20) DEFAULT NULL,                             -- chiave esterna per il ruolo dell'immagine
  `token` char(128) DEFAULT NULL,                                 -- token per il lock dell'immagine durante lo scalamento
  `path` char(255) DEFAULT NULL,                                  -- percorso dell'immagine
  `path_alternativo` char(255) DEFAULT NULL,                      -- percorso alternativo dell'immagine
  `orientamento` enum('L','P','S') DEFAULT NULL,                  -- orientamento: L=landscape, P=portrait, S=square
  `taglio` char(64) DEFAULT NULL,                                 -- taglio dell'immagine
  `timestamp_scalamento` int(11) DEFAULT NULL,                    -- timestamp dell'ultimo scalamento
  `id_account_inserimento` bigint(20) DEFAULT NULL,               -- account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                   -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,             -- account che ha aggiornato la riga per ultimo
  `timestamp_aggiornamento` int(11) DEFAULT NULL                  -- timestamp dell'ultimo aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000015700

-- immobili
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene gli immobili, cioè le unità ( appartamenti, uffici, negozi, magazzini ) dentro gli edifici
-- entità: questa tabella corrisponde all'entità immobile
--
-- questa tabella è un livello della catena della geografia fisica, che va dall'indirizzo ai vani passando per edifici
-- e immobili; un immobile sta in un edificio, che non si può cancellare finché contiene immobili ( NO ACTION ), e
-- scala, piano, interno e campanello lo collocano al suo interno; i campi catasto_* ne portano i dati catastali; un
-- immobile si divide in vani ( vani ), e un mastro di magazzino può essere collocato a uno qualsiasi dei livelli
-- della catena ( indirizzo, edificio, immobile, vano )
--
CREATE TABLE IF NOT EXISTS `immobili` (                         --
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `id_tipologia` bigint(20) DEFAULT NULL,                       -- chiave esterna per la tipologia di immobile
  `codice` char(32) DEFAULT NULL,                               -- codice dell'immobile
  `nome` char(255) DEFAULT NULL,                                -- nome dell'immobile
  `id_edificio` bigint(20) DEFAULT NULL,                        -- chiave esterna per l'edificio che contiene l'immobile
  `scala` char(32) DEFAULT NULL,                                -- scala
  `piano` char(64) DEFAULT NULL,                                -- piano
  `interno` char(8) DEFAULT NULL,                               -- interno
  `campanello` char(128) DEFAULT NULL,                          -- nome sul campanello
  `catasto_foglio` char(255) DEFAULT NULL,                      -- foglio catastale
  `catasto_particella` char(255) DEFAULT NULL,                  -- particella catastale
  `catasto_sub` char(255) DEFAULT NULL,                         -- subalterno catastale
  `catasto_categoria` char(255) DEFAULT NULL,                   -- categoria catastale
  `catasto_classe` char(255) DEFAULT NULL,                      -- classe catastale
  `catasto_consistenza` char(255) DEFAULT NULL,                 -- consistenza catastale
  `catasto_superficie` char(255) DEFAULT NULL,                  -- superficie catastale
  `catasto_rendita` char(255) DEFAULT NULL,                     -- rendita catastale
  `note` text DEFAULT NULL,                                     -- note sull'immobile
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha aggiornato la riga
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                           --

-- | 010000015710

-- immobili_anagrafica
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: collega un immobile alle anagrafiche che hanno un ruolo su di esso
--
-- questa tabella collega un immobile alle anagrafiche che vi hanno un ruolo ( professionisti per le riparazioni,
-- amministratore, inquilini o proprietari quando non si passa dai contratti... );
-- e' gemella di edifici_anagrafica e vani_anagrafica ( decisione del 16/10/2026 ): le anagrafiche si
-- assegnano a tutti i livelli degli immobili; i ruoli proponibili sono quelli con ruoli_anagrafica.se_immobili
--
-- NOTA la chiave unica e' ( id_immobile, id_anagrafica, id_ruolo ): la stessa anagrafica puo' avere piu' ruoli
--
CREATE TABLE IF NOT EXISTS `immobili_anagrafica` (              --
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                -- ordine di visualizzazione
  `id_immobile` bigint(20) DEFAULT NULL,                        -- chiave esterna per l'immobile
  `id_anagrafica` bigint(20) DEFAULT NULL,                      -- chiave esterna per l'anagrafica
  `id_ruolo` bigint(20) DEFAULT NULL,                           -- chiave esterna per il ruolo ( ruoli_anagrafica )
  `note` text DEFAULT NULL,                                     -- note
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha aggiornato la riga
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                           --

-- | 010000015750

-- immobili_caratteristiche
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: collega un immobile alle sue caratteristiche
--
-- questa tabella collega un immobile all'albero delle caratteristiche ( caratteristiche ) e ne porta
-- il valore. E' gemella di articoli_caratteristiche, come edifici_caratteristiche e indirizzi_caratteristiche ( decisione
-- del 15/10/2026: prima era un si'/no con se_presente ): il valore e' per lingua, quindi id_lingua
-- fa parte della chiave unica, e se_assente dichiara che la caratteristica non c'e'. Le caratteristiche
-- proponibili sono quelle con caratteristiche.se_immobili.
--
CREATE TABLE IF NOT EXISTS `immobili_caratteristiche` (
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                -- ordine di visualizzazione
  `id_immobile` bigint(20) DEFAULT NULL,                        -- chiave esterna per l'immobile
  `id_caratteristica` bigint(20) DEFAULT NULL,                  -- chiave esterna per la caratteristica
  `id_lingua` bigint(20) DEFAULT NULL,                          -- chiave esterna per la lingua del valore
  `valore` text DEFAULT NULL,                                   -- valore della caratteristica
  `note` text DEFAULT NULL,                                     -- note
  `se_assente` tinyint(1) DEFAULT NULL,                         -- la caratteristica e' dichiarata assente
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account di inserimento
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account di aggiornamento
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000015800

-- indirizzi
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene i luoghi, cioè gli indirizzi come posti fisici
--
-- questa tabella è l'ultimo livello della geografia ( stati, regioni, provincie, comuni ) e la testa della catena
-- delle costruzioni ( edifici, immobili, vani ); è il luogo, mentre il recapito di un'anagrafica sta in
-- anagrafica_indirizzi, che può puntare qui con id_indirizzo; il blocco dell'indirizzo e quello della
-- geolocalizzazione hanno lo stesso ordine e gli stessi tipi del recapito, e la geolocalizzazione la fa il modulo
-- _GE000.geolocalizzazione
--
-- NOTA la chiave unica ( id_comune, indirizzo, civico, cap ) non protegge dai doppioni quando una colonna è NULL,
-- e il civico spesso sta dentro indirizzo
--
CREATE TABLE IF NOT EXISTS `indirizzi` (
  `id` bigint(20) NOT NULL,                                   -- chiave primaria
  `id_tipologia` bigint(20) DEFAULT NULL,                     -- chiave esterna per la tipologia dell'indirizzo
  `indirizzo` char(255) DEFAULT NULL,                         -- indirizzo
  `civico` char(16) DEFAULT NULL,                             -- civico
  `id_comune` bigint(20) DEFAULT NULL,                        -- chiave esterna per il comune
  `localita` char(128) DEFAULT NULL,                          -- località
  `cap` char(11) DEFAULT NULL,                                -- CAP
  `note` text DEFAULT NULL,                                   -- note sull'indirizzo
  `latitudine` decimal(11,7) DEFAULT NULL,                    -- latitudine
  `longitudine` decimal(11,7) DEFAULT NULL,                   -- longitudine
  `token` char(128) DEFAULT NULL,                             -- token per il lock della riga durante la geolocalizzazione
  `timestamp_geolocalizzazione` int(11) DEFAULT NULL,         -- timestamp dell'ultima geolocalizzazione
  `note_geolocalizzazione` text DEFAULT NULL,                 -- note sulla geolocalizzazione dell'indirizzo
  `id_zona` bigint(20) DEFAULT NULL,                          -- chiave esterna per la zona, assegnata dal CAP ( zone_cap )
  `id_account_inserimento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha inserito l'indirizzo
  `timestamp_inserimento` int(11) DEFAULT NULL,               -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,         -- chiave esterna per l'account che ha aggiornato l'indirizzo
  `timestamp_aggiornamento` int(11) DEFAULT NULL              -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000015850

-- indirizzi_caratteristiche
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: collega un indirizzo alle sue caratteristiche
--
-- questa tabella collega un indirizzo all'albero delle caratteristiche ( caratteristiche ) e ne porta
-- il valore. E' gemella di articoli_caratteristiche, come edifici_caratteristiche e immobili_caratteristiche ( decisione
-- del 15/10/2026: prima era un si'/no con se_presente ): il valore e' per lingua, quindi id_lingua
-- fa parte della chiave unica, e se_assente dichiara che la caratteristica non c'e'. Le caratteristiche
-- proponibili sono quelle con caratteristiche.se_indirizzi.
--
CREATE TABLE IF NOT EXISTS `indirizzi_caratteristiche` (
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                -- ordine di visualizzazione
  `id_indirizzo` bigint(20) DEFAULT NULL,                       -- chiave esterna per l'indirizzo
  `id_caratteristica` bigint(20) DEFAULT NULL,                  -- chiave esterna per la caratteristica
  `id_lingua` bigint(20) DEFAULT NULL,                          -- chiave esterna per la lingua del valore
  `valore` text DEFAULT NULL,                                   -- valore della caratteristica
  `note` text DEFAULT NULL,                                     -- note
  `se_assente` tinyint(1) DEFAULT NULL,                         -- la caratteristica e' dichiarata assente
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account di inserimento
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account di aggiornamento
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000016000

-- iva
-- tipologia: tabella standard
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene le aliquote IVA
--
-- questa tabella contiene le aliquote IVA che documenti, prezzi, reparti, carrelli e spedizioni citano; per le aliquote
-- a zero il codice è la natura dell'operazione della fattura elettronica ( N1 … N7 con le sottovoci ), per le altre è
-- vuoto
--
-- il contenuto ha un vincolo normativo forte: le righe sono quelle dei dati di base del framework, che si tengono
-- allineate alle specifiche della fattura elettronica e si aggiornano periodicamente sui deploy; un'aliquota che la
-- norma non ammette più non si cancella, perché la citano i documenti già emessi: si archivia con data_archiviazione
-- e note_archiviazione, e le tendine dei documenti smettono di proporla
CREATE TABLE IF NOT EXISTS `iva` (                            --
  `id` bigint(20) NOT NULL,                                      -- chiave primaria
  `codice` char(32) DEFAULT NULL,                             -- natura dell'operazione per la fattura elettronica
  `nome` char(255) DEFAULT NULL,                              -- nome dell'aliquota
  `aliquota` decimal(5,2) NOT NULL,                           -- percentuale dell'aliquota
  `descrizione` text DEFAULT NULL,                            -- descrizione estesa dell'aliquota, col riferimento normativo
  `data_archiviazione` date DEFAULT NULL,                      -- data di archiviazione dell'aliquota
  `note_archiviazione` text DEFAULT NULL                       -- motivo dell'archiviazione dell'aliquota
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000016200

-- job
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene i job di sistema
--
-- questa tabella contiene i job di sistema, per maggiori informazioni si veda la documentazione relativa ai file
-- /_src/_api/_cron.php e /_src/_api/_job.php
-- 
CREATE TABLE IF NOT EXISTS `job` (                            --
  `id` bigint(20) NOT NULL,                                      -- chiave primaria
  `nome` char(255) DEFAULT NULL,                              -- nome del job
  `job` char(255) DEFAULT NULL,                                   -- percorso del file del job
  `timestamp_apertura` int(11) DEFAULT NULL,                  -- timestamp di apertura del job
  `totale` int(11) DEFAULT NULL,                              -- totale elementi da processare
  `corrente` int(11) DEFAULT NULL,                            -- elemento corrente
  `iterazioni` int(11) DEFAULT NULL,                          -- numero di iterazioni per ogni esecuzione del job
  `delay` int(11) DEFAULT NULL,                               -- delay in secondi tra un'esecuzione e l'altra del job
  `workspace` longtext DEFAULT NULL,                          -- workspace JSON del job
  `se_foreground` tinyint(1) DEFAULT NULL,                    -- flag che indica se il job è in foreground
  `token` char(254) DEFAULT NULL,                             -- token di lock del job
  `timestamp_esecuzione` int(11) DEFAULT NULL,                -- timestamp dell'ultima esecuzione del job
  `timestamp_completamento` int(11) DEFAULT NULL,             -- timestamp del completamento del job
  `id_account_inserimento` bigint(20) DEFAULT NULL,              -- chiave esterna per l'account che ha inserito il job
  `timestamp_inserimento` int(11) DEFAULT NULL,               -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,            -- chiave esterna per l'account che ha aggiornato il job
  `timestamp_aggiornamento` int(11) DEFAULT NULL              -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000016700

-- licenze_software
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: dice a quali software si applica una licenza
--
-- questa tabella mette in relazione molti a molti licenze e software, ed e' l'anello centrale della catena
-- software -> licenze_software -> licenze -> chiavi: un software puo' essere coperto da piu' licenze e una licenza
-- puo' coprire piu' software, mentre le chiavi appartengono alla licenza. Nel framework latest nessuna parte la legge;
-- in oldstable la scrive il form delle licenze del modulo V900.software. Il gruppo software va rivisto per intero
-- quando si crea il modulo software di latest.
--
CREATE TABLE IF NOT EXISTS `licenze_software` (
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                -- ordine di visualizzazione
  `id_licenza` bigint(20) DEFAULT NULL,                         -- chiave esterna per la licenza
  `id_software` bigint(20) DEFAULT NULL,                        -- chiave esterna per il software
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account di inserimento
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account di aggiornamento
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000016800

-- lingue
-- tipologia: tabella standard
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene le lingue del sistema
-- famiglia: iso
--
-- questa tabella contiene le lingue che il framework supporta, ciascuna nella variante di un paese, coi codici ISO
-- 639-1, ISO 639-3 e il tag IETF BCP 47; il tag IETF è la chiave funzionale, quella con cui la localizzazione, le
-- mail e gli SMS trovano la lingua
--
-- è una tabella standard ad aggiornamento centralizzato, famiglia iso: le righe sono un sottoinsieme scelto dal
-- framework, i codici e i nomi si allineano alle fonti istituzionali sul database canonico e arrivano ai deploy dal
-- dataserver; i deploy le importano e non le modificano
CREATE TABLE IF NOT EXISTS `lingue` (                         --
  `id` bigint(20) NOT NULL,                                      -- chiave primaria
  `nome` char(255) DEFAULT NULL,                              -- nome comune della lingua, in italiano
  `note` char(128) DEFAULT NULL,                              -- nome esteso della variante, con il paese
  `iso6391alpha2` char(2) DEFAULT NULL,                       -- codice ISO 639-1 a due lettere
  `iso6393alpha3` char(3) DEFAULT NULL,                       -- codice ISO 639-3 a tre lettere
  `ietf` char(36) DEFAULT NULL                                 -- tag IETF BCP 47 della lingua con il paese
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000017000

-- liste
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene le liste di iscritti a cui si spediscono i mailing
-- entità: questa tabella corrisponde all'entità lista
--
-- una lista raccoglie indirizzi mail ( liste_mail ) e un mailing si spedisce a una o più liste ( mailing_liste );
-- le liste nascono dal form di iscrizione alla newsletter e dai job di importazione degli iscritti, che le cercano
-- per nome e le creano se mancano, per cui il nome è unico; il codice serve a riferire la lista indipendentemente
-- dal nome
--
CREATE TABLE IF NOT EXISTS `liste` (                            --
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `codice` char(32) DEFAULT NULL,                               -- codice della lista
  `nome` char(255) DEFAULT NULL,                                -- nome della lista
  `note` text DEFAULT NULL,                                     -- note sulla lista
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha aggiornato la riga
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                           --

-- | 010000017100

-- liste_mail
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: contiene le iscrizioni degli indirizzi mail alle liste
--
-- ogni riga iscrive un indirizzo ( mail ) a una lista ( liste ); le iscrizioni nascono dal form di iscrizione alla
-- newsletter, dai job di importazione degli iscritti, dal task che popola una lista da una categoria di anagrafica e
-- dai form della lista e della mail, tutti con INSERT IGNORE: la chiave unica su lista e indirizzo fa sì che iscrivere
-- due volte lo stesso indirizzo non crei doppioni
--
CREATE TABLE IF NOT EXISTS `liste_mail` (                       --
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                -- ordine di visualizzazione
  `id_lista` bigint(20) DEFAULT NULL,                           -- chiave esterna per la lista
  `id_mail` bigint(20) DEFAULT NULL,                            -- chiave esterna per l'indirizzo mail iscritto
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha aggiornato la riga
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                           --

-- | 010000017200

-- listini
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella ricorsiva
-- funzione: contiene i listini prezzi
-- entità: questa tabella corrisponde all'entità listino
--
-- il listino fa da mediatore fra gli articoli e i prezzi: un prezzo ( prezzi ) esiste solo dentro un listino, e i
-- listini collegano i prezzi agli articoli secondo una serie di regole ( gruppo o account connesso, zona,
-- anagrafica e così via ); un listino può contenerne altri, e vale il principio di specificità: se un prezzo è
-- presente sul listino figlio vale quello, altrimenti vale il prezzo corrispondente del listino padre, e così via
-- risalendo l'albero; fra listini possono valere regole, per esempio una scontistica ( sconto_su_genitore: il
-- listino figlio costa il 20% in meno del genitore ); il listino è di acquisto se ha un emittente esterno alle
-- aziende gestite, altrimenti è di vendita; il codice è unico perché i listini sono oggetti riferiti anche dai
-- gestionali esterni, il nome è unico per valuta
--
CREATE TABLE IF NOT EXISTS `listini` (                          --
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                        -- chiave esterna ricorsiva per il listino genitore
  `id_tipologia` bigint(20) DEFAULT NULL,                       -- chiave esterna per la tipologia del listino
  `codice` char(32) DEFAULT NULL,                               -- codice del listino
  `nome` char(255) DEFAULT NULL,                                -- nome del listino
  `id_emittente` bigint(20) DEFAULT NULL,                       -- chiave esterna per l'anagrafica che emette il listino
  `id_valuta` bigint(20) DEFAULT NULL,                          -- chiave esterna per la valuta del listino
  `sconto_su_genitore` decimal(5,2) DEFAULT NULL,               -- sconto percentuale rispetto al listino genitore
  `note` text DEFAULT NULL,                                     -- note sul listino
  `se_default_su_genitore` tinyint(1) DEFAULT NULL,             -- flag per il listino di default fra i figli del genitore
  `data_archiviazione` date DEFAULT NULL,                       -- data di archiviazione
  `note_archiviazione` text DEFAULT NULL,                       -- note di archiviazione
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha aggiornato la riga
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                           --

-- | 010000017400

-- listini_clienti
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: dice a quali clienti si applica un listino
--
-- ogni riga applica un listino ( listini ) a un cliente ( anagrafica ); è una delle regole con cui i listini collegano
-- i prezzi agli articoli, accanto a quella per zona ( listini_zone ): quando il listino di un carrello si sceglie in
-- automatico, il listino del cliente intestatario ( o dell'anagrafica dell'account collegato ) vince su quello della
-- zona e sul default; se un cliente ha più listini vale il primo per ordine
--
CREATE TABLE IF NOT EXISTS `listini_clienti` (                  --
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                -- priorità del listino fra quelli dello stesso cliente
  `id_listino` bigint(20) DEFAULT NULL,                         -- chiave esterna per il listino
  `id_cliente` bigint(20) DEFAULT NULL,                         -- chiave esterna per l'anagrafica del cliente
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha aggiornato la riga
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                           --

-- | 010000017490

-- listini_zone
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: dice in quali zone si applica un listino
--
-- ogni riga applica un listino ( listini ) a una zona ( zone ); è una delle regole con cui i listini collegano i
-- prezzi agli articoli, accanto a quella per cliente ( listini_clienti ), ed è particolarmente rilevante per gli
-- e-commerce internazionali: quando il listino di un carrello si sceglie in automatico, il listino del cliente vince,
-- poi vale quello della zona del carrello, poi il default; se una zona ha più listini vale il primo per ordine
--
CREATE TABLE IF NOT EXISTS `listini_zone` (                     --
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                -- priorità del listino fra quelli della stessa zona
  `id_listino` bigint(20) DEFAULT NULL,                         -- chiave esterna per il listino
  `id_zona` bigint(20) DEFAULT NULL,                            -- chiave esterna per la zona
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha aggiornato la riga
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                           --

-- | 010000017800

-- lotti
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene i lotti degli articoli, cioè gli insiemi di pezzi prodotti insieme con lo stesso codice
-- entità: questa tabella corrisponde all'entità lotto
--
-- un lotto è un insieme di pezzi dello stesso articolo prodotti o confezionati insieme, riconosciuto dal codice che gli
-- dà il produttore ( quello stampato in etichetta ), unico per articolo, con le sue date di produzione e di scadenza;
-- le righe di documento lo dichiarano con id_lotto, una riga un lotto ( una consegna presa da due lotti sono due
-- righe ), e la giacenza e i movimenti si calcolano per mastro, articolo, lotto e matricola: così si sa dove è andato
-- un lotto e quanto ne resta in ogni mastro, p.es. per un richiamo; un pezzo con numero di serie può appartenere a un
-- lotto ( matricole.id_lotto ), e allora la riga che lo movimenta porta il lotto della matricola; l'articolo dice
-- cos'è il lotto, quindi non si cancella un articolo che ha lotti
--
-- NOTA nei moduli legacy i lotti sono ancora matricole automatiche per articolo e scadenza ( vedi matricole )
--
CREATE TABLE IF NOT EXISTS `lotti` (                            --
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `codice` char(32) DEFAULT NULL,                               -- codice del lotto assegnato dal produttore, unico per articolo
  `nome` char(255) DEFAULT NULL,                                -- nome del lotto
  `id_articolo` bigint(20) DEFAULT NULL,                        -- chiave esterna per l'articolo del lotto
  `id_produttore` bigint(20) DEFAULT NULL,                      -- chiave esterna per l'anagrafica del produttore, se diverso da quello del prodotto
  `note` text DEFAULT NULL,                                     -- note sul lotto
  `data_produzione` date DEFAULT NULL,                          -- data di produzione o di confezionamento del lotto
  `data_scadenza` date DEFAULT NULL,                            -- data di scadenza del lotto
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha inserito il lotto
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha aggiornato il lotto
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                          --

-- | 010000018000

-- luoghi
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella ricorsiva
-- funzione: contiene i luoghi, cioè gli spazi dove si svolgono attività e todo
-- entità: questa tabella corrisponde all'entità luogo
--
-- un luogo è uno spazio con un nome, così come lo intende chi organizza il lavoro ( una palestra, un'aula, una sala
-- riunioni, un'area esterna ): è il "dove" di attivita, todo e pianificazioni, che lo puntano con id_luogo; la
-- tabella è ricorsiva perché gli spazi si organizzano ad albero ( una palestra con le sue sale ), e id_genitore
-- punta al luogo che contiene questo; il nome è unico fra i fratelli, perché due luoghi con lo stesso nome sotto lo
-- stesso genitore sarebbero un doppione; un luogo può essere collocato su uno qualsiasi dei livelli della catena
-- della geografia fisica ( indirizzo, edificio, immobile, vano ), tutti facoltativi, e se il livello puntato viene
-- cancellato il luogo resta
--
-- NOTA la colonna url serve ai luoghi che non sono fisici ( p.es. la tipologia "online" ): contiene il link della
-- stanza virtuale dove si svolge l'attività
--
CREATE TABLE IF NOT EXISTS `luoghi` (                           --
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                        -- chiave esterna per il luogo che contiene questo
  `id_tipologia` bigint(20) DEFAULT NULL,                       -- chiave esterna per la tipologia di luogo
  `nome` char(255) DEFAULT NULL,                                -- nome del luogo
  `id_indirizzo` bigint(20) DEFAULT NULL,                       -- chiave esterna per l'indirizzo dove si trova il luogo
  `id_edificio` bigint(20) DEFAULT NULL,                        -- chiave esterna per l'edificio dove si trova il luogo
  `id_immobile` bigint(20) DEFAULT NULL,                        -- chiave esterna per l'immobile dove si trova il luogo
  `id_vano` bigint(20) DEFAULT NULL,                            -- chiave esterna per il vano dove si trova il luogo
  `url` char(255) DEFAULT NULL,                                 -- link del luogo virtuale
  `note` text DEFAULT NULL,                                     -- note sul luogo
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha inserito il luogo
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha aggiornato il luogo
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                          --

-- | 010000018200

-- macro
-- tipologia: tabella gestita
-- rango: tabella secondaria
-- struttura: tabella base
-- funzione: associa script PHP ( macro ) alle pagine generate dagli oggetti
--
-- ogni riga associa a un oggetto in grado di generare una pagina il percorso di una macro PHP, che viene eseguita
-- quando la pagina si apre; è il modo di dare una macro a una pagina che nasce dal database invece che da un file
-- di _inc/_pages/; gli oggetti sono le entità pubblicabili ( pagine, prodotti, articoli, marchi, notizie, annunci,
-- risorse, progetti ) e le loro categorie, più le pianificazioni; un oggetto può avere più macro, nell'ordine dato
-- da ordine, e la stessa macro una volta sola
--
-- NOTA le chiavi esterne verso gli oggetti sono CASCADE: una macro non ha senso senza la pagina del suo oggetto, e
-- se l'oggetto viene cancellato le sue righe se ne vanno con lui
-- NOTA oggi a runtime le macro si leggono solo per le pagine ( aggiungiMacro() con id_pagina, dal modulo PA000 ); la
-- lettura per gli altri oggetti arriverà con le loro pagine
--
CREATE TABLE IF NOT EXISTS `macro` (                            --
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                -- ordine di esecuzione fra le macro dello stesso oggetto
  `id_pagina` bigint(20) DEFAULT NULL,                          -- chiave esterna per la pagina
  `id_prodotto` bigint(20) DEFAULT NULL,                        -- chiave esterna per il prodotto
  `id_articolo` bigint(20) DEFAULT NULL,                        -- chiave esterna per l'articolo
  `id_categoria_prodotti` bigint(20) DEFAULT NULL,              -- chiave esterna per la categoria dei prodotti
  `id_marchio` bigint(20) DEFAULT NULL,                         -- chiave esterna per il marchio
  `id_categoria_marchi` bigint(20) DEFAULT NULL,                -- chiave esterna per la categoria di marchi
  `id_notizia` bigint(20) DEFAULT NULL,                         -- chiave esterna per la notizia
  `id_annuncio` bigint(20) DEFAULT NULL,                        -- chiave esterna per l'annuncio
  `id_categoria_notizie` bigint(20) DEFAULT NULL,               -- chiave esterna per la categoria delle notizie
  `id_categoria_annunci` bigint(20) DEFAULT NULL,               -- chiave esterna per la categoria degli annunci
  `id_risorsa` bigint(20) DEFAULT NULL,                         -- chiave esterna per la risorsa
  `id_categoria_risorse` bigint(20) DEFAULT NULL,               -- chiave esterna per la categoria delle risorse
  `id_progetto` bigint(20) DEFAULT NULL,                        -- chiave esterna per il progetto
  `id_categoria_progetti` bigint(20) DEFAULT NULL,              -- chiave esterna per la categoria dei progetti
  `id_pianificazione` bigint(20) DEFAULT NULL,                  -- chiave esterna per la pianificazione
  `macro` char(255) DEFAULT NULL,                               -- percorso della macro PHP, relativo a DIR_BASE ( es. src/inc/macro/home.php )
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha aggiornato la riga
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                           --

-- | 010000018600

-- mail
-- tipologia: tabella gestita
-- rango: tabella secondaria
-- struttura: tabella base
-- funzione: contiene gli indirizzi mail delle anagrafiche
--
-- questa tabella contiene gli indirizzi mail di un'anagrafica, una riga per indirizzo, col ruolo dell'indirizzo
-- ( ruoli_mail ) e i flag per le notifiche e la PEC; è il recapito a cui fanno riferimento l'account ( account.id_mail ),
-- la PEC per lo SDI ( anagrafica.id_pec_sdi ), i consensi e il mailing
--
-- NOTA una mail può non avere anagrafica: gli iscritti alla newsletter dal sito o importati entrano come solo
-- indirizzo; la chiave unica su id_anagrafica e indirizzo non li protegge dai doppioni, perché due NULL per MySQL
-- non sono uguali
--
-- NOTA la mail di default di un'anagrafica è la prima nell'ordine ( ORDER BY ordine IS NULL, ordine, id ); lo stesso
-- vale dentro un filtro: la PEC di default è la prima fra quelle con se_pec, e così per le notifiche ( decisione del
-- 2026-10-19, comune ai recapiti dell'anagrafica: mail, telefoni, iban )
--
-- NOTA la colonna server è il server SMTP da usare per spedire da questo indirizzo, pensato per la posta interna;
-- l'invio dal server della casella è ancora da implementare
--
-- NOTA la chiave esterna verso l'anagrafica è CASCADE: una mail non ha senso senza la sua anagrafica
--
CREATE TABLE IF NOT EXISTS `mail` (                             --
  `id` bigint(20) NOT NULL,                                       -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                  -- ordine dell'indirizzo fra quelli dell'anagrafica, il primo è quello di default
  `id_anagrafica` bigint(20) DEFAULT NULL,                        -- chiave esterna per l'anagrafica a cui appartiene l'indirizzo
  `id_ruolo` bigint(20) DEFAULT NULL,                             -- chiave esterna per il ruolo dell'indirizzo ( generica, amministrazione… )
  `indirizzo` char(255) DEFAULT NULL,                             -- indirizzo mail
  `server` char(128) DEFAULT NULL,                                -- server SMTP da usare per spedire da questo indirizzo
  `note` char(128) DEFAULT NULL,                                  -- note sull'indirizzo
  `se_notifiche` tinyint(1) DEFAULT NULL,                         -- se l'indirizzo riceve le notifiche
  `se_pec` tinyint(1) DEFAULT NULL,                               -- se l'indirizzo è una PEC
  `id_account_inserimento` bigint(20) DEFAULT NULL,               -- chiave esterna per l'account che ha inserito l'indirizzo
  `timestamp_inserimento` int(11) DEFAULT NULL,                   -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha aggiornato l'indirizzo
  `timestamp_aggiornamento` int(11) DEFAULT NULL                  -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                           --

-- | 010000018800

-- mail_out
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene la coda delle mail da inviare
--
-- questa tabella è la coda della posta in uscita: ci scrive queueMail() ( _src/_lib/_mail.tools.php ), e il form di
-- back-end del modulo MA000.mail; il task mail.queue.send prende una riga alla volta marcandola col token, la invia
-- e la sposta in mail_sent; se l'invio fallisce conta il tentativo e la riprogramma un'ora per tentativo più avanti
--
-- NOTA mail_out e mail_sent devono avere le stesse colonne nello stesso ordine: lo spostamento è un
-- REPLACE INTO mail_sent SELECT * FROM mail_out ( e il resend un INSERT INTO mail_out SELECT * FROM mail_sent ), quindi
-- ogni modifica di schema si fa identica e insieme sulle due tabelle
--
-- NOTA il token, oltre al lock del task, porta due stati: COPIA_FALLITA ( la mail è partita ma la copia in mail_sent
-- non è riuscita, va sistemata a mano ) e TROPPI_TENTATIVI ( raggiunto $cf['mail']['tentativi_massimi'] )
--
-- NOTA le credenziali SMTP non stanno qui: server è la chiave della configurazione; le colonne host, port, user,
-- password e id_mail sono uscite dal canone il 2026-10-19 ( mai scritte né lette ); il doppio invio di un mailing
-- lo impedisce mailing_mail, non questa tabella
--
CREATE TABLE IF NOT EXISTS `mail_out` (                         --
  `id` bigint(20) NOT NULL,                                       -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                  -- priorità di invio: NULL prima ( transazionali ), poi in ordine crescente ( il mailing scrive 10 )
  `id_mailing` bigint(20) DEFAULT NULL,                           -- chiave esterna per il mailing da cui viene la mail
  `mittente` char(254) DEFAULT NULL,                              -- mittente, serializzato ( array indirizzo => nome )
  `destinatari` text DEFAULT NULL,                                -- destinatari, serializzati ( array indirizzo => nome )
  `destinatari_cc` text DEFAULT NULL,                             -- destinatari in copia, serializzati
  `destinatari_bcc` text DEFAULT NULL,                            -- destinatari in copia nascosta, serializzati
  `oggetto` char(254) DEFAULT NULL,                               -- oggetto della mail
  `corpo` text DEFAULT NULL,                                      -- corpo della mail ( HTML )
  `allegati` text DEFAULT NULL,                                   -- allegati, serializzati ( array nome => percorso )
  `headers` text DEFAULT NULL,                                    -- header aggiuntivi, serializzati
  `server` char(128) DEFAULT NULL,                                -- chiave del server SMTP in $cf['smtp']['servers'], NULL per il server del profilo
  `tentativi` int(11) DEFAULT 0,                                  -- tentativi di invio falliti
  `token` char(128) DEFAULT NULL,                                 -- token di lock del task di invio, o stato COPIA_FALLITA / TROPPI_TENTATIVI
  `timestamp_elaborazione` int(11) DEFAULT NULL,                  -- timestamp della marcatura con il token
  `timestamp_composizione` int(11) DEFAULT NULL,                  -- timestamp di composizione della mail
  `timestamp_invio` int(11) DEFAULT NULL,                         -- timestamp di invio: invio previsto; NULL vuol dire appena possibile
  `id_account_inserimento` bigint(20) DEFAULT NULL,               -- chiave esterna per l'account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                   -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha aggiornato la riga
  `timestamp_aggiornamento` int(11) DEFAULT NULL                  -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                           --

-- | 010000018900

-- mail_sent
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene le mail inviate
--
-- questa tabella è l'archivio delle mail inviate: ci arrivano dal task mail.queue.send, che le sposta da mail_out
-- dopo l'invio; mail.queue.resend fa il percorso inverso per rispedirle
--
-- NOTA mail_out e mail_sent devono avere le stesse colonne nello stesso ordine: lo spostamento è un
-- REPLACE INTO mail_sent SELECT * FROM mail_out ( e il resend un INSERT INTO mail_out SELECT * FROM mail_sent ), quindi
-- ogni modifica di schema si fa identica e insieme sulle due tabelle
--
-- NOTA il token, oltre al lock del task, porta due stati: COPIA_FALLITA ( la mail è partita ma la copia in mail_sent
-- non è riuscita, va sistemata a mano ) e TROPPI_TENTATIVI ( raggiunto $cf['mail']['tentativi_massimi'] )
--
-- NOTA le credenziali SMTP non stanno qui: server è la chiave della configurazione; le colonne host, port, user,
-- password e id_mail sono uscite dal canone il 2026-10-19 ( mai scritte né lette ); il doppio invio di un mailing
-- lo impedisce mailing_mail, non questa tabella
--
CREATE TABLE IF NOT EXISTS `mail_sent` (                        --
  `id` bigint(20) NOT NULL,                                       -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                  -- priorità di invio: NULL prima ( transazionali ), poi in ordine crescente ( il mailing scrive 10 )
  `id_mailing` bigint(20) DEFAULT NULL,                           -- chiave esterna per il mailing da cui viene la mail
  `mittente` char(254) DEFAULT NULL,                              -- mittente, serializzato ( array indirizzo => nome )
  `destinatari` text DEFAULT NULL,                                -- destinatari, serializzati ( array indirizzo => nome )
  `destinatari_cc` text DEFAULT NULL,                             -- destinatari in copia, serializzati
  `destinatari_bcc` text DEFAULT NULL,                            -- destinatari in copia nascosta, serializzati
  `oggetto` char(254) DEFAULT NULL,                               -- oggetto della mail
  `corpo` text DEFAULT NULL,                                      -- corpo della mail ( HTML )
  `allegati` text DEFAULT NULL,                                   -- allegati, serializzati ( array nome => percorso )
  `headers` text DEFAULT NULL,                                    -- header aggiuntivi, serializzati
  `server` char(128) DEFAULT NULL,                                -- chiave del server SMTP in $cf['smtp']['servers'], NULL per il server del profilo
  `tentativi` int(11) DEFAULT 0,                                  -- tentativi di invio falliti
  `token` char(128) DEFAULT NULL,                                 -- token di lock del task di invio, o stato COPIA_FALLITA / TROPPI_TENTATIVI
  `timestamp_elaborazione` int(11) DEFAULT NULL,                  -- timestamp della marcatura con il token
  `timestamp_composizione` int(11) DEFAULT NULL,                  -- timestamp di composizione della mail
  `timestamp_invio` int(11) DEFAULT NULL,                         -- timestamp di invio: invio effettivo
  `id_account_inserimento` bigint(20) DEFAULT NULL,               -- chiave esterna per l'account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                   -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha aggiornato la riga
  `timestamp_aggiornamento` int(11) DEFAULT NULL                  -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                           --

-- | 010000018950

-- mail_status
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene i verdetti di verifica degli indirizzi mail
--
-- questa tabella e' la cache dei verdetti di verifica degli indirizzi mail ( Emailable ), chiavata
-- sull'indirizzo e non sull'anagrafica: lo stesso indirizzo ha un verdetto solo, chiunque lo usi,
-- e una verifica si paga una volta per tutta la durata della cache; la scrivono e la leggono le
-- funzioni di _src/_lib/_emailable.utils.php
--
-- NOTA la tabella la scrive il server e non un utente, quindi id_account_inserimento e
-- id_account_aggiornamento restano NULL; la scala dei verdetti sta in tipologie_mail_status
--
CREATE TABLE IF NOT EXISTS `mail_status` (                    --
  `id` bigint(20) NOT NULL,                                   -- chiave primaria
  `id_tipologia` bigint(20) DEFAULT NULL,                     -- chiave esterna per lo stato dell'indirizzo (tipologie_mail_status)
  `indirizzo` char(255) DEFAULT NULL,                         -- indirizzo mail verificato, normalizzato in minuscolo (chiave logica)
  `dominio` char(255) DEFAULT NULL,                           -- dominio dell'indirizzo, per le statistiche per dominio
  `stato` char(32) DEFAULT NULL,                              -- stato grezzo restituito dal servizio di verifica (state)
  `motivo` char(64) DEFAULT NULL,                             -- motivo grezzo restituito dal servizio di verifica (reason)
  `punteggio` int(11) DEFAULT NULL,                           -- punteggio restituito dal servizio di verifica (score, da 0 a 100)
  `tentativi` int(11) DEFAULT 0,                              -- numero di verifiche tentate sull'indirizzo
  `note` text DEFAULT NULL,                                   -- note sulla verifica
  `se_accept_all` tinyint(1) DEFAULT NULL,                    -- flag che indica se il server accetta qualunque indirizzo
  `se_ruolo` tinyint(1) DEFAULT NULL,                         -- flag che indica se e' un indirizzo di ruolo (info@, ufficio@)
  `se_temporanea` tinyint(1) DEFAULT NULL,                    -- flag che indica se e' una casella usa e getta
  `se_gratuita` tinyint(1) DEFAULT NULL,                      -- flag che indica se e' una casella su dominio gratuito
  `timestamp_verifica` int(11) DEFAULT NULL,                  -- timestamp dell'ultima verifica andata a buon fine, regola la scadenza della cache
  `id_account_inserimento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,               -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,         -- chiave esterna per l'account che ha aggiornato la riga
  `timestamp_aggiornamento` int(11) DEFAULT NULL              -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000019000

-- mailing
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene gli invii dei mailing
--
-- questa tabella contiene la testata di ogni invio di newsletter: il nome, la data prevista e le note;
-- le liste a cui va stanno in mailing_liste, i destinatari generati in mailing_mail, il testo e gli
-- allegati in contenuti e file; la gestisce il modulo ML000.mailing, e i task _genera.elenco.destinatari.php
-- e _genera.mail.php la trasformano in mail accodate in mail_out
--
-- NOTA timestamp_invio e' l'invio previsto, da cui parte la coda; l'invio effettivo di ogni destinatario
-- sta in mailing_mail.timestamp_invio
--
-- NOTA i follow-up commerciali generati da un mailing ( le colonne promemoria_*, uscite il 19/10/2026 )
-- sono da riprogettare, vedi il TODO.md di glisdev
--
CREATE TABLE IF NOT EXISTS `mailing` (                        --
  `id` bigint(20) NOT NULL,                                   -- chiave primaria
  `nome` char(255) DEFAULT NULL,                              -- nome del mailing
  `note` text DEFAULT NULL,                                   -- note sul mailing
  `timestamp_invio` int(11) DEFAULT NULL,                     -- timestamp dell'invio previsto
  `id_account_inserimento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,               -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,         -- chiave esterna per l'account che ha aggiornato la riga
  `timestamp_aggiornamento` int(11) DEFAULT NULL              -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000019050

-- mailing_liste
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: contiene le liste a cui va un mailing
--
-- ogni riga dice che un mailing ( mailing ) va a una lista ( liste ); le righe nascono dal form del mailing, dove le
-- liste si aggiungono come sotto-elenco, e il task che genera l'elenco dei destinatari le legge per trascrivere in
-- mailing_mail gli iscritti di tutte le liste del mailing, un indirizzo una volta sola anche se sta in più liste
--
CREATE TABLE IF NOT EXISTS `mailing_liste` (                    --
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                -- ordine di visualizzazione
  `id_lista` bigint(20) DEFAULT NULL,                           -- chiave esterna per la lista
  `id_mailing` bigint(20) DEFAULT NULL,                         -- chiave esterna per il mailing
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha aggiornato la riga
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                           --

-- | 010000019100

-- mailing_mail
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: contiene i destinatari di un mailing e lo stato della loro mail
--
-- ogni riga dice che un mailing ( mailing ) va a un indirizzo ( mail ) e ne segue la mail: il task che genera l'elenco
-- dei destinatari la scrive dagli iscritti alle liste del mailing ( mailing_liste ), un indirizzo una volta sola; il
-- task che genera le mail la blocca col token, compone la mail, la accoda e scrive timestamp_generazione e id_mail_out;
-- la coda, a invio riuscito, scrive timestamp_invio e sposta la riga dalla mail in coda a quella inviata
--
-- NOTA lo stato della mail si legge dalle due chiavi: id_mail_out valorizzata è una mail in coda, id_mail_sent
-- valorizzata una mail inviata, tutte e due vuote una mail ancora da generare; la coda ripunta la riga prima di
-- togliere la mail da mail_out, come fa per i file, e il reinvio fa il passaggio inverso
--
-- NOTA il doppio invio di un mailing allo stesso indirizzo lo impedisce questa tabella, con la chiave unica
-- ( id_mailing, id_mail ) e il controllo sull'indirizzo del task che genera l'elenco
--
CREATE TABLE IF NOT EXISTS `mailing_mail` (                     --
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                -- ordine di visualizzazione
  `id_mail` bigint(20) DEFAULT NULL,                            -- chiave esterna per l'indirizzo del destinatario
  `id_mailing` bigint(20) DEFAULT NULL,                         -- chiave esterna per il mailing
  `id_mail_out` bigint(20) DEFAULT NULL,                        -- chiave esterna per la mail in coda, finché non parte
  `id_mail_sent` bigint(20) DEFAULT NULL,                       -- chiave esterna per la mail inviata
  `token` char(128) DEFAULT NULL,                               -- token per il lock della riga durante la generazione
  `timestamp_generazione` int(11) DEFAULT NULL,                 -- timestamp della generazione della mail
  `timestamp_invio` int(11) DEFAULT NULL,                       -- timestamp dell'invio della mail
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha aggiornato la riga
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                           --

-- | 010000020200

-- marchi
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene i marchi dei prodotti
--
-- un marchio raccoglie i prodotti che lo portano ( prodotti.id_marchio ) e puo' indicare il produttore in anagrafica.
-- Ogni marchio genera una pagina del sito, e le pagine dei marchi si organizzano nell'albero di navigazione delle
-- categorie_marchi tramite marchi_categorie; per questo il marchio porta il blocco web ( template, schema_html,
-- tema_css, se_sitemap, se_cacheable, id_sito, id_pagina ) come le altre entita' che generano pagine.
--
-- NOTA id_pagina e' la pagina sotto cui si appende il marchio nell'albero del sito; id_sito non ha chiave esterna
-- perche' i siti sono definiti nella configurazione, non nel database.
--
-- NOTA oggi nessun modulo genera le pagine dei marchi: lo schema c'e', il codice ( _310.pages.php del modulo
-- prodotti e la gestione delle categorie dei marchi ) e' nel TODO di glisdev.
CREATE TABLE IF NOT EXISTS `marchi` (                             --
  `id` bigint(20) NOT NULL,                                       -- chiave primaria
  `nome` char(255) DEFAULT NULL,                                  -- nome del marchio
  `id_produttore` bigint(20) DEFAULT NULL,                        -- chiave esterna per l'anagrafica del produttore
  `note` text DEFAULT NULL,                                       -- note sul marchio
  `template` char(255) DEFAULT NULL,                              -- template con cui si mostra la pagina del marchio
  `schema_html` char(128) DEFAULT NULL,                           -- schema HTML del template
  `tema_css` char(128) DEFAULT NULL,                              -- tema CSS del template
  `se_sitemap` tinyint(1) DEFAULT NULL,                           -- la pagina del marchio va nella sitemap
  `se_cacheable` tinyint(1) DEFAULT NULL,                         -- la pagina del marchio si puo' mettere in cache
  `id_sito` bigint(20) DEFAULT NULL,                              -- sito della configurazione a cui appartiene la pagina
  `id_pagina` bigint(20) DEFAULT NULL,                            -- chiave esterna per la pagina genitore nell'albero del sito
  `data_archiviazione` date DEFAULT NULL,                         -- data di archiviazione
  `note_archiviazione` text DEFAULT NULL,                         -- note di archiviazione
  `id_account_inserimento` bigint(20) DEFAULT NULL,               -- account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                   -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,             -- account che ha aggiornato la riga per ultimo
  `timestamp_aggiornamento` int(11) DEFAULT NULL                  -- timestamp dell'ultimo aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                             --

-- | 010000020400

-- marchi_categorie
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: associa molti a molti i marchi alle categorie dei marchi
--
-- questa tabella contiene le associazioni molti a molti tra i marchi e le categorie_marchi, cioe' l'albero di
-- navigazione in cui si organizzano le pagine dei marchi; le categorie fanno parte della scheda del marchio, quindi
-- la chiave verso marchi si segue
--
CREATE TABLE IF NOT EXISTS `marchi_categorie` (               --
  `id` bigint(20) NOT NULL,                                   -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                              -- ordine di visualizzazione
  `id_marchio` bigint(20) DEFAULT NULL,                       -- chiave esterna per il marchio
  `id_categoria` bigint(20) DEFAULT NULL,                     -- chiave esterna per la categoria
  `id_account_inserimento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha inserito l'associazione
  `timestamp_inserimento` int(11) DEFAULT NULL,               -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,         -- chiave esterna per l'account che ha aggiornato l'associazione
  `timestamp_aggiornamento` int(11) DEFAULT NULL              -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000020600

-- mastri
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella ricorsiva
-- funzione: contiene i mastri e i conti, cioè i contenitori di tutto ciò che il framework conta
-- entità: questa tabella corrisponde all'entità mastro
--
-- un mastro è un contenitore in cui si conta qualcosa: articoli in un magazzino, ore in un registro, denaro in un
-- conto, crediti in un borsellino; cosa si conta lo dice la tipologia ( tipologie_mastri, coi flag se_magazzino,
-- se_registro, se_conto, se_credito ), e i movimenti stanno nelle tabelle che spostano quantità da un mastro di
-- provenienza a uno di destinazione ( le righe dei documenti, attivita, pagamenti, crediti ); la tabella è ricorsiva
-- perché i mastri si articolano ad albero anche molto profondo ( un magazzino con le sue aree, scaffali e ripiani,
-- un piano dei conti ), e le giacenze di un mastro comprendono quelle dei suoi discendenti; l'identità di un mastro
-- è il codice, unico in tutta la tabella, mentre il nome è libero e può ripetersi fra fratelli ( p.es. quando
-- descrive la tipologia merceologica di uno scaffale ); un mastro può appartenere a un'anagrafica, a un account o
-- a un progetto ( il registro ore di una persona, il borsellino di crediti di un account, il magazzino di una
-- commessa ), e un magazzino può essere collocato nello spazio; un mastro dismesso si archivia e non si cancella,
-- perché i movimenti che lo puntano devono restare leggibili
--
-- NOTA è forse la tabella più legata all'applicazione di tutto il framework: giacenze, movimentazioni, report e
-- viste statiche dipendono dalla sua struttura, e la logica di calcolo è comune a tutte le tipologie e appartiene
-- al modulo dei mastri; ogni modifica va pensata per tutte le famiglie insieme
--
-- NOTA un magazzino si colloca in due modi: id_anagrafica_indirizzi lo mette nella sede di un'anagrafica ( il
-- recapito, che non si può cancellare finché un mastro lo usa ), mentre id_indirizzo, id_edificio, id_immobile e
-- id_vano lo collocano su un livello della catena della geografia fisica, fino alla stanza ( p.es. lo scaffale di
-- una biblioteca ); i mastri che non sono magazzini di solito non hanno collocazione
--
-- NOTA prefisso_modula e codice_modula sono i codici del mastro nel magazzino verticale Modula, letti dal modulo
-- standard di integrazione con Modula; hanno la lunghezza dei codici di quel sistema
--
CREATE TABLE IF NOT EXISTS `mastri` (                           --
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                        -- chiave esterna per il mastro che contiene questo
  `id_tipologia` bigint(20) DEFAULT NULL,                       -- chiave esterna per la tipologia del mastro
  `codice` char(32) DEFAULT NULL,                               -- codice del mastro, unico
  `nome` char(255) DEFAULT NULL,                                -- nome del mastro
  `id_anagrafica` bigint(20) DEFAULT NULL,                      -- chiave esterna per l'anagrafica a cui appartiene il mastro
  `id_account` bigint(20) DEFAULT NULL,                         -- chiave esterna per l'account a cui appartiene il mastro
  `id_progetto` bigint(20) DEFAULT NULL,                        -- chiave esterna per il progetto a cui appartiene il mastro
  `id_anagrafica_indirizzi` bigint(20) DEFAULT NULL,            -- chiave esterna per la sede dell'anagrafica dove si trova il mastro
  `id_indirizzo` bigint(20) DEFAULT NULL,                       -- chiave esterna per l'indirizzo dove si trova il mastro
  `id_edificio` bigint(20) DEFAULT NULL,                        -- chiave esterna per l'edificio dove si trova il mastro
  `id_immobile` bigint(20) DEFAULT NULL,                        -- chiave esterna per l'immobile dove si trova il mastro
  `id_vano` bigint(20) DEFAULT NULL,                            -- chiave esterna per il vano dove si trova il mastro
  `prefisso_modula` char(64) DEFAULT NULL,                      -- prefisso del mastro nel magazzino Modula
  `codice_modula` char(64) DEFAULT NULL,                        -- codice del mastro nel magazzino Modula
  `note` text DEFAULT NULL,                                     -- note sul mastro
  `data_archiviazione` date DEFAULT NULL,                       -- data di archiviazione
  `note_archiviazione` text DEFAULT NULL,                       -- note di archiviazione
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha inserito il mastro
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha aggiornato il mastro
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                          --

-- | 010000020700

-- mastri_articoli
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: collega gli articoli ai mastri di magazzino, col ruolo della collocazione e le soglie di scorta
--
-- questa tabella dice in quali ubicazioni di magazzino sta un articolo e che parte fa ciascuna per lui:
-- il ruolo ( ruoli_mastri ) distingue p.es. il mastro in cui l'articolo va collocato di preferenza, quello
-- di prelievo preferenziale e quello di stoccaggio preferenziale; quando l'articolo si vende lo si preleva
-- normalmente dal mastro di prelievo, e quando questo va sotto scorta lo si riassortisce trasferendo merce
-- dal mastro di stoccaggio; se l'ubicazione e' sorvegliata, scorta_minima dice sotto quale giacenza va
-- rifornita e scorta_massima fin dove si riempie, nell'unita' id_udm o, dove id_udm e' vuoto, nell'unita'
-- inventariale dell'articolo; una coppia mastro / articolo compare una volta sola
--
-- NOTA il ruolo si cerca per nome e non per id ( trovaUbicazioneBulk() del modulo 0500.mastri cerca
-- 'stoccaggio' ), perche' i file di base non caricano righe in ruoli_mastri e gli id cambiano fra deploy;
-- le soglie le legge il task _mod/_0500.mastri/_src/_api/_task/_rifornimenti.da.sottoscorta.php
--
CREATE TABLE IF NOT EXISTS `mastri_articoli` (                  --
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                -- ordine della collocazione fra quelle dell'articolo
  `codice` char(32) DEFAULT NULL,                               -- codice della collocazione
  `id_mastro` bigint(20) DEFAULT NULL,                          -- chiave esterna per il mastro ( l'ubicazione )
  `id_articolo` bigint(20) DEFAULT NULL,                        -- chiave esterna per l'articolo
  `id_ruolo` bigint(20) DEFAULT NULL,                           -- chiave esterna per il ruolo della collocazione ( ruoli_mastri )
  `scorta_minima` decimal(21,2) DEFAULT NULL,                   -- sotto questa giacenza l'ubicazione va rifornita; NULL = nessuna soglia
  `scorta_massima` decimal(21,2) DEFAULT NULL,                  -- fin qui si riempie rifornendo; NULL = fino alla scorta minima
  `id_udm` bigint(20) DEFAULT NULL,                             -- chiave esterna per l'unita' di misura in cui sono scritte le soglie
  `note` text DEFAULT NULL,                                     -- note sulla collocazione
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha inserito la collocazione
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha aggiornato la collocazione
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                           --

-- | 010000020800

-- mastri_tipologie_veicoli
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: contiene la relazione molti a molti tra mastri e tipologie di veicoli
--
-- questa tabella dice con quali tipi di mezzo si raggiunge un mastro di magazzino ( p.es. una collocazione servita
-- dal macchinino o dalla gabbia ): associa a un mastro una TIPOLOGIA di veicolo, non un veicolo; la leggono la
-- scheda veicoli dei magazzini e i report di giacenza, per dire con che mezzi si arriva a una collocazione. Una
-- coppia mastro / tipologia compare una volta sola
-- NOTA qui id_tipologia non e' la tipologia della riga ma una chiave della relazione, verso l'unico classificatore
-- che la tabella collega: per questo ha il nome generico, sta dopo ordine ed e' CASCADE, come id_categoria in
-- coupon_categorie_prodotti e nelle tabelle *_categorie
--
CREATE TABLE IF NOT EXISTS `mastri_tipologie_veicoli` (         --
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                -- ordine della tipologia fra quelle del mastro
  `id_mastro` bigint(20) DEFAULT NULL,                          -- chiave esterna per il mastro
  `id_tipologia` bigint(20) DEFAULT NULL,                       -- chiave esterna per la tipologia di veicolo ( tipologie_veicoli )
  `note` text DEFAULT NULL,                                     -- note sull'associazione
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha inserito l'associazione
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha aggiornato l'associazione
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000021000

-- matricole
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene le matricole, cioè i singoli pezzi di un articolo riconosciuti dal numero di serie
-- entità: questa tabella corrisponde all'entità matricola
--
-- una matricola è un esemplare fisico preciso di un articolo, riconosciuto dal suo numero di serie ( matricola, unico
-- per articolo ): serve a seguire il percorso di quel pezzo fra i mastri ( la giacenza e i movimenti si calcolano per
-- mastro, articolo, lotto e matricola ) e a collegarlo ad attività, progetti, todo e valutazioni; l'articolo dice
-- cos'è la matricola, quindi non si cancella un articolo che ha matricole; un pezzo può venire da un lotto
-- ( id_lotto ), e allora la riga di documento che lo movimenta porta il lotto della matricola e non un altro; marchio
-- e produttore servono quando sono diversi da quelli del prodotto ( p.es. un pezzo OEM ), la condizione è lo stato di
-- quel pezzo, la scadenza quella del pezzo ( garanzia, revisione )
--
-- NOTA la UNIQUE unica_scadenza ( id_articolo, data_scadenza ) è dei moduli legacy: con matricole.scadenze acceso le
-- righe di documento creano una "matricola automatica" per articolo e scadenza, che fa da lotto, e la ritrovano grazie
-- a questa chiave; resta finché quei moduli sono vivi, poi i lotti stanno solo in lotti e la chiave cade
--
CREATE TABLE IF NOT EXISTS `matricole` (                        --
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `matricola` char(128) DEFAULT NULL,                           -- numero di serie, unico per articolo
  `nome` char(255) DEFAULT NULL,                                -- nome della matricola
  `id_articolo` bigint(20) DEFAULT NULL,                        -- chiave esterna per l'articolo di cui la matricola è un esemplare
  `id_lotto` bigint(20) DEFAULT NULL,                           -- chiave esterna per il lotto da cui viene la matricola
  `id_marchio` bigint(20) DEFAULT NULL,                         -- chiave esterna per il marchio, se diverso da quello del prodotto
  `id_produttore` bigint(20) DEFAULT NULL,                      -- chiave esterna per l'anagrafica del produttore, se diverso da quello del prodotto
  `id_condizione` bigint(20) DEFAULT NULL,                      -- chiave esterna per la condizione del pezzo
  `note` text DEFAULT NULL,                                     -- note sulla matricola
  `data_scadenza` date DEFAULT NULL,                            -- data di scadenza del pezzo ( garanzia, revisione )
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha inserito la matricola
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha aggiornato la matricola
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                          --

-- | 010000021600

-- menu
-- tipologia: tabella gestita
-- rango: tabella secondaria
-- struttura: tabella base
-- funzione: contiene le voci di menu dei siti
--
-- ogni riga è una voce di menu: lega un oggetto in grado di generare una pagina a uno dei menu dichiarati dal
-- template ( colonna menu ), con l'etichetta nella lingua della voce, la posizione, l'ancora, il target e la
-- strategia per le sottopagine; gli oggetti sono le entità pubblicabili ( pagine, prodotti, marchi, notizie,
-- annunci, risorse, progetti ) e le loro categorie; le voci si leggono con aggiungiMenu() e diventano navigazione
-- con buildMenu(); in GlisWeb la voce di menu è un attributo della pagina, non il contrario
--
-- NOTA le chiavi esterne verso gli oggetti sono CASCADE: una voce di menu non ha senso senza la pagina del suo
-- oggetto, e se l'oggetto viene cancellato le sue voci se ne vanno con lui
-- NOTA sottopagine vale SHOW_IF_ACTIVE ( default, anche NULL: le sottovoci si espandono quando la voce è nel
-- percorso della pagina attiva ), NEVER_SHOW ( mai ) o ALWAYS_SHOW ( sempre ); conta solo per le pagine con figli
-- NOTA oggi a runtime le voci si leggono per pagine, categorie di prodotti e categorie di notizie; la lettura per
-- gli altri oggetti arriverà con le loro pagine
--
CREATE TABLE IF NOT EXISTS `menu` (                             --
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                -- ordine della voce nel suo menu
  `nome` char(255) DEFAULT NULL,                                -- etichetta della voce di menu, nella lingua della voce
  `id_pagina` bigint(20) DEFAULT NULL,                          -- chiave esterna per la pagina collegata alla voce di menu
  `id_prodotto` bigint(20) DEFAULT NULL,                        -- chiave esterna per il prodotto collegato alla voce di menu
  `id_categoria_prodotti` bigint(20) DEFAULT NULL,              -- chiave esterna per la categoria di prodotti collegata alla voce di menu
  `id_marchio` bigint(20) DEFAULT NULL,                         -- chiave esterna per il marchio collegato alla voce di menu
  `id_categoria_marchi` bigint(20) DEFAULT NULL,                -- chiave esterna per la categoria di marchi collegata alla voce di menu
  `id_notizia` bigint(20) DEFAULT NULL,                         -- chiave esterna per la notizia collegata alla voce di menu
  `id_annuncio` bigint(20) DEFAULT NULL,                        -- chiave esterna per l'annuncio collegato alla voce di menu
  `id_categoria_notizie` bigint(20) DEFAULT NULL,               -- chiave esterna per la categoria di notizie collegata alla voce di menu
  `id_categoria_annunci` bigint(20) DEFAULT NULL,               -- chiave esterna per la categoria di annunci collegata alla voce di menu
  `id_risorsa` bigint(20) DEFAULT NULL,                         -- chiave esterna per la risorsa collegata alla voce di menu
  `id_categoria_risorse` bigint(20) DEFAULT NULL,               -- chiave esterna per la categoria di risorse collegata alla voce di menu
  `id_progetto` bigint(20) DEFAULT NULL,                        -- chiave esterna per il progetto collegato alla voce di menu
  `id_categoria_progetti` bigint(20) DEFAULT NULL,              -- chiave esterna per la categoria di progetti collegata alla voce di menu
  `id_lingua` bigint(20) DEFAULT NULL,                          -- chiave esterna per la lingua della voce di menu
  `menu` char(32) DEFAULT NULL,                                 -- nome del menu del template a cui appartiene la voce
  `ancora` char(64) DEFAULT NULL,                               -- ancora aggiunta al link della voce
  `target` char(16) DEFAULT NULL,                               -- attributo target del link della voce ( _blank )
  `sottopagine` char(32) DEFAULT NULL,                          -- strategia per le sottopagine: SHOW_IF_ACTIVE, NEVER_SHOW, ALWAYS_SHOW
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha inserito la voce di menu
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha aggiornato la voce di menu
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                           --

-- | 010000021700

-- messaggi
-- tipologia: tabella gestita
-- rango: tabella secondaria
-- struttura: tabella base
-- funzione: contiene i messaggi delle conversazioni
--
-- questa tabella contiene un messaggio per riga. Il messaggio appartiene alla conversazione ( conversazioni ) e muore
-- con lei; id_account e' l'autore, che non coincide per forza con l'account di inserimento ( un import, un
-- amministratore ). La lettura non sta qui ma in messaggi_account, una riga per ogni account che ha letto il messaggio,
-- cosi' il modello regge la chat uno a uno come la chat di gruppo e il forum.
--
-- NOTA: la chiave verso conversazioni e' CASCADE ( il messaggio non ha senso senza la conversazione ), quella verso
-- l'autore SET NULL ( cancellare un account non deve portarsi via la storia della conversazione ).
--
CREATE TABLE IF NOT EXISTS `messaggi` (
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `id_conversazione` bigint(20) DEFAULT NULL,                   -- chiave esterna per la conversazione a cui appartiene il messaggio
  `id_account` bigint(20) DEFAULT NULL,                         -- chiave esterna per l'account autore del messaggio
  `testo` text DEFAULT NULL,                                    -- testo del messaggio
  `timestamp_invio` int(11) DEFAULT NULL,                       -- timestamp di invio del messaggio
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento della riga
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha aggiornato la riga
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento della riga
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000021750

-- messaggi_account
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: contiene le letture dei messaggi, cioe' quale account ha letto quale messaggio e quando
--
-- questa tabella mette in relazione messaggi e account: ogni riga e' un account che ha letto un messaggio, con il
-- momento della lettura. In una chat di gruppo o in un forum ogni partecipante ha la sua riga, quindi lo stato di
-- lettura e' per partecipante e non per messaggio.
--
CREATE TABLE IF NOT EXISTS `messaggi_account` (
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                -- ordine di visualizzazione
  `id_account` bigint(20) DEFAULT NULL,                         -- chiave esterna per l'account che ha letto il messaggio
  `id_messaggio` bigint(20) DEFAULT NULL,                       -- chiave esterna per il messaggio letto
  `timestamp_lettura` int(11) DEFAULT NULL,                     -- timestamp di lettura del messaggio
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento della riga
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha aggiornato la riga
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento della riga
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000021800

-- metadati
-- tipologia: tabella gestita
-- rango: tabella secondaria
-- struttura: tabella base
-- funzione: contiene i metadati ( coppie nome/valore ) degli oggetti delle tabelle principali
--
-- questa tabella fa parte del gruppo delle tabelle dei media ( audio, video, immagini, file, contenuti, metadati ),
-- che collegano qualcosa a un oggetto di una tabella principale; qui sono dati liberi nella forma nome => valore,
-- per le informazioni che non hanno una colonna loro: parametri di pagine e template, impostazioni di corsi,
-- prodotti e carrelli, dati di integrazione; ogni riga è un metadato di un oggetto solo, indicato dalla sua
-- chiave esterna id_*, eventualmente in una lingua; aggiungiMetadati() li legge e metadati2associativeArray() li
-- trasforma in array, usando il carattere | nel nome per i livelli ( p.es. abbonamento|discipline )
--
-- NOTA le chiavi esterne verso gli oggetti sono CASCADE: un metadato non ha senso senza il suo oggetto
-- NOTA le chiavi uniche sono ( id_<oggetto>, id_lingua, nome ) e proteggono solo i metadati in lingua: con
-- id_lingua NULL, che è il caso normale, due righe con lo stesso nome non collidono; alcune chiavi usano
-- di proposito più righe con lo stesso nome per un elenco di valori, e chi scrive un valore singolo deve
-- aggiornare la riga esistente invece di aggiungerne una
--
CREATE TABLE IF NOT EXISTS `metadati` (                         --
  `id` bigint(20) NOT NULL,                                        -- chiave primaria
  `id_lingua` bigint(20) DEFAULT NULL,                             -- chiave esterna per la lingua del metadato, NULL se non dipende dalla lingua
  `id_anagrafica` bigint(20) DEFAULT NULL,                         -- chiave esterna per l'anagrafica
  `id_account` bigint(20) DEFAULT NULL,                            -- chiave esterna per l'account
  `id_pagina` bigint(20) DEFAULT NULL,                             -- chiave esterna per la pagina
  `id_prodotto` bigint(20) DEFAULT NULL,                           -- chiave esterna per il prodotto
  `id_articolo` bigint(20) DEFAULT NULL,                           -- chiave esterna per l'articolo
  `id_categoria_prodotti` bigint(20) DEFAULT NULL,                 -- chiave esterna per la categoria dei prodotti
  `id_marchio` bigint(20) DEFAULT NULL,                            -- chiave esterna per il marchio
  `id_categoria_marchi` bigint(20) DEFAULT NULL,                   -- chiave esterna per la categoria di marchi
  `id_notizia` bigint(20) DEFAULT NULL,                            -- chiave esterna per la notizia
  `id_annuncio` bigint(20) DEFAULT NULL,                           -- chiave esterna per l'annuncio
  `id_categoria_notizie` bigint(20) DEFAULT NULL,                  -- chiave esterna per la categoria delle notizie
  `id_categoria_annunci` bigint(20) DEFAULT NULL,                  -- chiave esterna per la categoria degli annunci
  `id_risorsa` bigint(20) DEFAULT NULL,                            -- chiave esterna per la risorsa
  `id_categoria_risorse` bigint(20) DEFAULT NULL,                  -- chiave esterna per la categoria delle risorse
  `id_immagine` bigint(20) DEFAULT NULL,                           -- chiave esterna per l'immagine
  `id_video` bigint(20) DEFAULT NULL,                              -- chiave esterna per il video
  `id_audio` bigint(20) DEFAULT NULL,                              -- chiave esterna per l'audio
  `id_file` bigint(20) DEFAULT NULL,                               -- chiave esterna per il file
  `id_documento` bigint(20) DEFAULT NULL,                          -- chiave esterna per il documento
  `id_documenti_articoli` bigint(20) DEFAULT NULL,                 -- chiave esterna per la riga di documento
  `id_asset` bigint(20) DEFAULT NULL,                              -- chiave esterna per l'asset
  `id_progetto` bigint(20) DEFAULT NULL,                           -- chiave esterna per il progetto
  `id_categoria_progetti` bigint(20) DEFAULT NULL,                 -- chiave esterna per la categoria dei progetti
  `id_indirizzo` bigint(20) DEFAULT NULL,                          -- chiave esterna per l'indirizzo
  `id_edificio` bigint(20) DEFAULT NULL,                           -- chiave esterna per l'edificio
  `id_immobile` bigint(20) DEFAULT NULL,                           -- chiave esterna per l'immobile
  `id_vano` bigint(20) DEFAULT NULL,                               -- chiave esterna per il vano
  `id_contratto` bigint(20) DEFAULT NULL,                          -- chiave esterna per il contratto
  `id_valutazione` bigint(20) DEFAULT NULL,                        -- chiave esterna per la valutazione
  `id_rinnovo` bigint(20) DEFAULT NULL,                            -- chiave esterna per il rinnovo
  `id_attivita` bigint(20) DEFAULT NULL,                           -- chiave esterna per l'attività
  `id_tipologia_attivita` bigint(20) DEFAULT NULL,                 -- chiave esterna per la tipologia di attività
  `id_banner` bigint(20) DEFAULT NULL,                             -- chiave esterna per il banner
  `id_pianificazione` bigint(20) DEFAULT NULL,                     -- chiave esterna per la pianificazione
  `id_todo` bigint(20) DEFAULT NULL,                               -- chiave esterna per il todo
  `id_tipologia_todo` bigint(20) DEFAULT NULL,                     -- chiave esterna per la tipologia di todo
  `id_tipologia_contratti` bigint(20) DEFAULT NULL,                -- chiave esterna per la tipologia di contratti
  `id_carrello` bigint(20) DEFAULT NULL,                           -- chiave esterna per il carrello
  `id_tipologia_corrispondenza` bigint(20) DEFAULT NULL,           -- chiave esterna per la tipologia di corrispondenza
  `id_peso_tipologie_corrispondenza` bigint(20) DEFAULT NULL,      -- chiave esterna per il peso della tipologia di corrispondenza
  `nome` char(255) DEFAULT NULL,                                   -- nome del metadato, con | per i livelli
  `testo` text DEFAULT NULL,                                       -- valore del metadato
  `id_account_inserimento` bigint(20) DEFAULT NULL,                -- chiave esterna per l'account che ha inserito il metadato
  `timestamp_inserimento` int(11) DEFAULT NULL,                    -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,              -- chiave esterna per l'account che ha aggiornato il metadato
  `timestamp_aggiornamento` int(11) DEFAULT NULL                   -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000021810

-- metadati_articoli
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene i metadati articoli
--
CREATE TABLE IF NOT EXISTS `metadati_articoli` (
  `id` bigint(20) NOT NULL,
  `id_lingua` bigint(20) DEFAULT NULL,
  `id_articolo` bigint(20) DEFAULT NULL,
  `nome` char(128) DEFAULT NULL,
  `testo` text DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000021820

-- metadati_prodotti
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene i metadati prodotti
--
CREATE TABLE IF NOT EXISTS `metadati_prodotti` (
  `id` bigint(20) NOT NULL,
  `id_lingua` bigint(20) DEFAULT NULL,
  `id_prodotto` bigint(20) DEFAULT NULL,
  `nome` char(128) DEFAULT NULL,
  `testo` text DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000021900

-- modalita_pagamento
-- tipologia: tabella standard
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene le modalita' di pagamento della fattura elettronica
--
-- le modalita' con cui si paga un documento, ognuna col codice ModalitaPagamento ( MP01 - MP23 ) che la fattura
-- elettronica scrive nel blocco DatiPagamento; la cita una riga di pagamento in pagamenti.id_modalita_pagamento e il
-- modello di una pianificazione in pianificazioni.model_id_modalita_pagamento, e la scelgono da una tendina i form dei
-- pagamenti, dell'anagrafica e dei modelli di pianificazione.
--
-- NOTA: le righe sono modalita' operative, piu' fini del codice SdI: carta di credito, bancomat e paypal sono tutte
-- MP08, quindi codice_sdi si ripete e la chiave e' il nome. L'elenco lo carica il 050 con id fissi, e gli id non si
-- cambiano perche' alcuni moduli li scrivono nel codice ( 1 contanti, 5 bonifico, 23 bancomat, 24 paypal ). Il legame
-- fra un provider di pagamento e la sua modalita' sta nella configurazione ( ecommerce.profile.provider.<nome>.modalita ),
-- non qui. Quando escono nuove specifiche della fattura elettronica l'elenco va ricontrollato e aggiornato con una patch.
CREATE TABLE IF NOT EXISTS `modalita_pagamento` (               --
  `id` bigint(20) NOT NULL,                                       -- chiave primaria
  `nome` char(255) NOT NULL,                                      -- nome della modalita' di pagamento
  `codice_sdi` char(32) NOT NULL                                  -- codice ModalitaPagamento della fattura elettronica
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                             --

-- | 010000021950

-- modalita_spedizione
-- tipologia: tabella assistita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene i costi e i tempi di spedizione per zona e, se serve, per categoria, prodotto o articolo
--
-- ogni riga è una regola di spedizione per una zona ( zone ): senza categoria, prodotto né articolo vale per tutta la
-- zona, con uno dei tre si restringe a quell'oggetto, e per un articolo vale la regola più specifica che c'è, nell'ordine
-- articolo, prodotto, categoria del prodotto, zona; l'importo vale per un lotto di lotto_spedizione pezzi, e il carrello
-- ( carrelli.costo_spedizione_* ) lo somma riga per riga o una volta per ordine, secondo la politica dell'e-commerce
--
-- NOTA id_tipologia ( tipologie_spedizioni ) è previsto per distinguere più modalità sulla stessa zona, p.es. standard
-- ed espressa, da scegliere nel carrello; oggi nessun codice la legge
-- NOTA le chiavi verso zona, categoria, prodotto e articolo sono CASCADE: la riga è una regola di quell'oggetto, e con
-- SET NULL la regola di un articolo cancellato diventerebbe in silenzio una regola di tutta la zona
--
CREATE TABLE IF NOT EXISTS `modalita_spedizione` (                --
  `id` bigint(20) NOT NULL,                                       -- chiave primaria
  `id_tipologia` bigint(20) DEFAULT NULL,                         -- chiave esterna per la tipologia di spedizione
  `id_zona` bigint(20) DEFAULT NULL,                              -- chiave esterna per la zona di destinazione
  `id_valuta` bigint(20) DEFAULT NULL,                            -- chiave esterna per la valuta dell'importo
  `id_prodotto` bigint(20) DEFAULT NULL,                          -- chiave esterna per il prodotto a cui si limita la regola
  `id_articolo` bigint(20) DEFAULT NULL,                          -- chiave esterna per l'articolo a cui si limita la regola
  `id_iva` bigint(20) DEFAULT NULL,                               -- chiave esterna per l'aliquota IVA della spedizione
  `id_categoria_prodotti` bigint(20) DEFAULT NULL,                -- chiave esterna per la categoria di prodotti a cui si limita la regola
  `lotto_spedizione` int(11) DEFAULT NULL,                        -- pezzi che viaggiano con un solo importo di spedizione
  `importo_netto` decimal(16,2) DEFAULT NULL,                     -- importo netto della spedizione di un lotto
  `giorni_spedizione` int(11) DEFAULT NULL,                       -- giorni per la spedizione ( TTS )
  `giorni_consegna` int(11) DEFAULT NULL,                         -- giorni per la consegna ( TTC )
  `id_account_inserimento` bigint(20) DEFAULT NULL,               -- chiave esterna per l'account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                   -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha aggiornato la riga
  `timestamp_aggiornamento` int(11) DEFAULT NULL                  -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                             --

-- | 010000022000

-- notizie
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene le notizie del sito
--
-- una notizia e' un contenuto collocato e delimitato nel tempo di pubblicazione: non solo le notizie in senso stretto
-- ma tutti i contenuti a tempo ( post di blog, comunicati e simili ). Il testo e gli altri contenuti stanno in
-- contenuti ( contenuti.id_notizia ), la finestra di uscita in pubblicazioni ( pubblicazioni.id_notizia ), e le
-- categorie in notizie_categorie. Ogni notizia genera una pagina del sito sotto ciascuna delle sue categorie, e la
-- prima categoria da' il canonical ( _310.pages.php del modulo notizie ); per questo porta il blocco web ( template,
-- schema_html, tema_css, se_sitemap, se_cacheable, id_sito, id_pagina ) come le altre entita' che generano pagine.
--
-- NOTA id_pagina e' la pagina sotto cui si appende la notizia nell'albero del sito quando non e' sotto una
-- categoria; id_sito non ha chiave esterna perche' i siti sono definiti nella configurazione, non nel database.
--
-- NOTA oggi il modulo notizie genera le pagine solo sotto le categorie: la lettura di id_pagina per le notizie senza
-- categoria e' nel TODO di glisdev.
CREATE TABLE IF NOT EXISTS `notizie` (                            --
  `id` bigint(20) NOT NULL,                                       -- chiave primaria
  `id_tipologia` bigint(20) DEFAULT NULL,                         -- chiave esterna per la tipologia della notizia
  `nome` char(255) DEFAULT NULL,                                  -- titolo della notizia
  `note` text DEFAULT NULL,                                       -- note sulla notizia
  `template` char(255) DEFAULT NULL,                              -- template con cui si mostra la pagina della notizia
  `schema_html` char(128) DEFAULT NULL,                           -- schema HTML del template
  `tema_css` char(128) DEFAULT NULL,                              -- tema CSS del template
  `se_sitemap` tinyint(1) DEFAULT NULL,                           -- la pagina della notizia va nella sitemap
  `se_cacheable` tinyint(1) DEFAULT NULL,                         -- la pagina della notizia si puo' mettere in cache
  `id_sito` bigint(20) DEFAULT NULL,                              -- sito della configurazione a cui appartiene la pagina
  `id_pagina` bigint(20) DEFAULT NULL,                            -- chiave esterna per la pagina genitore nell'albero del sito
  `data_archiviazione` date DEFAULT NULL,                         -- data di archiviazione
  `note_archiviazione` text DEFAULT NULL,                         -- note di archiviazione
  `id_account_inserimento` bigint(20) DEFAULT NULL,               -- account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                   -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,             -- account che ha aggiornato la riga per ultimo
  `timestamp_aggiornamento` int(11) DEFAULT NULL                  -- timestamp dell'ultimo aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                             --

-- | 010000022100

-- notizie_anagrafica
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: collega una notizia alle anagrafiche che vi hanno un ruolo
--
-- questa tabella collega una notizia alle anagrafiche che vi hanno avuto un ruolo ( autore, traduttore, redattore,
-- intervistatore, intervistato... ); i ruoli proponibili sono quelli con ruoli_anagrafica.se_notizie
--
-- NOTA la chiave unica e' ( id_notizia, id_anagrafica, id_ruolo ): la stessa anagrafica puo' avere piu' ruoli;
-- le note precisano il ruolo nel caso specifico ( decisione del 20/10/2026 )
--
CREATE TABLE IF NOT EXISTS `notizie_anagrafica` (               --
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                -- ordine di visualizzazione
  `id_notizia` bigint(20) DEFAULT NULL,                         -- chiave esterna per la notizia
  `id_anagrafica` bigint(20) DEFAULT NULL,                      -- chiave esterna per l'anagrafica
  `id_ruolo` bigint(20) DEFAULT NULL,                           -- chiave esterna per il ruolo ( ruoli_anagrafica )
  `note` text DEFAULT NULL,                                     -- note che precisano il ruolo
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha aggiornato la riga
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                           --

-- | 010000022200

-- notizie_categorie
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: associa molti a molti le notizie alle categorie delle notizie
--
-- questa tabella contiene le associazioni molti a molti tra le notizie e le categorie_notizie; una notizia può
-- stare in più categorie, e ordine ne stabilisce la sequenza; le categorie fanno parte della scheda della notizia,
-- quindi la chiave verso notizie si segue ( il form del modulo notizie le legge come sotto-elenco ), mentre quella
-- verso categorie_notizie no; è il modello di annunci_categorie
--
-- NOTA fino al 2026-10-20 la tabella aveva anche id_annuncio, residuo di quando notizie e annunci condividevano la
-- stessa tabella di categorie; gli annunci hanno annunci_categorie, e la colonna è uscita dal canone
--
CREATE TABLE IF NOT EXISTS `notizie_categorie` (              --
  `id` bigint(20) NOT NULL,                                      -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                              -- ordine di visualizzazione
  `id_notizia` bigint(20) DEFAULT NULL,                          -- chiave esterna per la notizia
  `id_categoria` bigint(20) DEFAULT NULL,                        -- chiave esterna per la categoria
  `id_account_inserimento` bigint(20) DEFAULT NULL,              -- chiave esterna per l'account che ha inserito l'associazione
  `timestamp_inserimento` int(11) DEFAULT NULL,               -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,            -- chiave esterna per l'account che ha aggiornato l'associazione
  `timestamp_aggiornamento` int(11) DEFAULT NULL              -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000022300

-- orari
-- tipologia: tabella gestita
-- rango: tabella secondaria
-- struttura: tabella base
-- funzione: contiene le fasce orarie di validità di un oggetto, oggi delle tipologie di contratto
--
-- questa tabella contiene le fasce orarie in cui vale una tipologia di contratto, tipicamente un abbonamento; ogni
-- riga è un giorno della settimana ( id_giorno, dalla tabella giorni ) con l'ora di inizio e l'ora di fine, e una
-- tipologia ha tante righe quante sono le sue fasce; le righe appartengono alla tipologia, quindi la chiave verso
-- tipologie_contratti si segue ( la scheda della tipologia le legge come sotto-elenco ) e le cancella con lei
--
-- NOTA orari è per le ore quello che periodi è per le date: oggi le fasce sono solo delle tipologie di contratto, ma
-- la tabella può essere associata anche ad altri oggetti, con una colonna per ogni oggetto, e per questo il nome
-- resta generico; id_periodicita oggi vale sempre settimanale, ed è la colonna che permette fasce non settimanali
--
CREATE TABLE IF NOT EXISTS `orari` (                          --
  `id` bigint(20) NOT NULL,                                      -- chiave primaria
  `nome` char(255) DEFAULT NULL,                              -- nome facoltativo della fascia oraria
  `id_tipologia_contratti` bigint(20) DEFAULT NULL,              -- chiave esterna per la tipologia di contratto a cui vale la fascia
  `id_periodicita` bigint(20) DEFAULT NULL,                      -- chiave esterna per la periodicità con cui la fascia si ripete
  `id_giorno` bigint(20) DEFAULT NULL,                           -- chiave esterna per il giorno della settimana
  `ora_inizio` time NULL,                                     -- ora di inizio della fascia
  `ora_fine` time NULL,                                       -- ora di fine della fascia
  `note` text NULL,                                           -- note sulla fascia oraria
  `id_account_inserimento` bigint(20) DEFAULT NULL,              -- chiave esterna per l'account che ha inserito la fascia
  `timestamp_inserimento` int(11) DEFAULT NULL,               -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,            -- chiave esterna per l'account che ha aggiornato la fascia
  `timestamp_aggiornamento` int(11) DEFAULT NULL              -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000022400

-- orari_contratti
-- tipologia: tabella gestita
-- rango: tabella secondaria
-- struttura: tabella base
-- funzione: contiene i turni di lavoro e di disponibilita' di un contratto di lavoro
--
-- questa tabella contiene i turni settimanali di un contratto di lavoro, una fascia oraria per riga: per ogni turno e
-- giorno della settimana le fasce di lavoro ( se_lavoro ), ciascuna legata a un costo orario del contratto
-- ( costi_contratti ), e quelle di disponibilita' ( se_disponibile ), in cui la persona puo' essere chiamata. Insieme a
-- costi_contratti definisce il perimetro dei contratti di lavoro: dalle fasce di lavoro e dai loro costi si ricavano le
-- ore teoriche dei cartellini e la quadratura delle ore di produzione. Fa parte della gestione del personale, che oggi
-- vive nei moduli legacy _0600.contratti, _1000.produzione, _8100.cartellini e _0200.attivita e passera' al modulo
-- risorse umane di latest. Non e' la tabella orari, che contiene le fasce di validita' delle tipologie di contratto.
--
-- NOTA: turno numera le settimane di una rotazione ( 1 se il contratto ha un turno solo ); id_giorno vuoto vuol dire
-- tutti i giorni, ed e' cosi' che _1000.produzione legge le fasce di disponibilita'. Un costo usato da qualche fascia
-- non si puo' cancellare ( ibfk_02_nofollow NO ACTION ): prima si spostano le fasce su un altro costo.
--
-- NOTA: ripristinata il 2026-09-30 dallo schema del 2021 ( _usr/_database/mysql.schema.sql, 0e99bca51 ), dove era
-- int; qui e' portata a bigint come il resto del canone.
--
CREATE TABLE IF NOT EXISTS `orari_contratti` (
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `id_contratto` bigint(20) DEFAULT NULL,                       -- chiave esterna per il contratto
  `turno` int(11) DEFAULT '1',                                  -- numero del turno nella rotazione
  `id_giorno` bigint(20) DEFAULT NULL,                          -- chiave esterna per il giorno della settimana ( vuoto = tutti )
  `ora_inizio` time DEFAULT NULL,                               -- ora di inizio della fascia
  `ora_fine` time DEFAULT NULL,                                 -- ora di fine della fascia
  `id_costo` bigint(20) DEFAULT NULL,                           -- chiave esterna per il costo orario del contratto
  `se_lavoro` tinyint(1) DEFAULT '1',                           -- flag fascia di lavoro
  `se_disponibile` tinyint(1) DEFAULT NULL,                     -- flag fascia di disponibilita'
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account di inserimento
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account di aggiornamento
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000022800

-- organizzazioni
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella ricorsiva
-- funzione: descrive una struttura organizzata come un albero di nodi
--
-- ogni riga e' un nodo di una struttura organizzata qualsiasi ( un'azienda coi suoi reparti e uffici, un ente, una
-- rete di sedi, un'associazione ) e id_genitore la appende al nodo che la contiene; e' una delle basi del CRM
-- strutturato, perche' permette di mappare anche strutture complesse, e serve anche a descrivere l'organigramma
-- interno dell'azienda coi suoi ruoli, reparti e uffici; le persone si associano ai nodi con un ruolo tramite
-- anagrafica_organizzazioni, gli account e i gruppi tramite account.id_organizzazione e gruppi.id_organizzazione,
-- che servono a segmentare gli accessi per parti dell'organizzazione; la corrispondenza registra l'ufficio che
-- spedisce ( corrispondenza.id_organizzazione_mittente )
--
-- NOTA id_anagrafica e' facoltativa e indica l'ente che il nodo rappresenta ( la societa' alla radice, una
-- controllata ), non chi ci lavora; e' una ricorsiva della famiglia dei classificatori, quindi il nome e' unico
-- fra i figli dello stesso genitore ( decisione del 20/10/2026 )
--
CREATE TABLE IF NOT EXISTS `organizzazioni` (                   --
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                        -- chiave esterna ricorsiva per il nodo che contiene questo
  `ordine` int(11) DEFAULT NULL,                                -- ordine di visualizzazione fra i nodi fratelli
  `nome` char(255) DEFAULT NULL,                                -- nome del nodo ( reparto, ufficio, sede, ente )
  `id_anagrafica` bigint(20) DEFAULT NULL,                      -- chiave esterna per l'ente che il nodo rappresenta, se c'e'
  `note` text DEFAULT NULL,                                     -- note sul nodo
  `id_account_inserimento` bigint(20) DEFAULT NULL,                -- chiave esterna per l'account che ha inserito l'organizzazione
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,              -- chiave esterna per l'account che ha aggiornato l'organizzazione
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                           --

-- | 010000023100

-- pagamenti
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene i pagamenti
--
-- questa tabella contiene i pagamenti, con le informazioni principali
--
CREATE TABLE IF NOT EXISTS `pagamenti` (
  `id` bigint(20) NOT NULL,
  `id_tipologia` bigint(20) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `id_modalita_pagamento` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `data_scadenza` date DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `note_pagamento` text DEFAULT NULL,
  `id_documento` bigint(20) DEFAULT NULL,
  `id_rinnovo` bigint(20) DEFAULT NULL,
  `id_carrello` bigint(20) DEFAULT NULL,
  `id_carrelli_articoli` bigint(20) DEFAULT NULL,
  `id_creditore` bigint(20) DEFAULT NULL,
  `id_debitore` bigint(20) DEFAULT NULL,
  `id_mastro_provenienza` bigint(20) DEFAULT NULL,
  `id_mastro_destinazione` bigint(20) DEFAULT NULL,
  `id_iban` bigint(20) DEFAULT NULL,
  `importo_lordo_totale` decimal(9,2) DEFAULT NULL,
  `id_coupon` bigint(20) DEFAULT NULL,
  `coupon_valore` decimal(9,2) DEFAULT NULL,
  `importo_lordo_finale` decimal(9,2) DEFAULT NULL,
  `id_listino` bigint(20) DEFAULT NULL,
  `id_pianificazione` bigint(20) DEFAULT NULL, 
  `data_ripetizione` date DEFAULT NULL,
  `provider_pagamento` char(128) DEFAULT NULL,
  `timestamp_pagamento` int(11) DEFAULT NULL,
  `token_pagamento` char(128) DEFAULT NULL,
  `ordine_pagamento` char(128) DEFAULT NULL,
  `codice_pagamento` char(128) DEFAULT NULL,
  `status_pagamento` char(128) DEFAULT NULL,
  `importo_pagamento` decimal(16,5) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000023200

-- pagine
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella ricorsiva
-- funzione: contiene l albero delle pagine dei siti
--
-- e' la tabella principale del CMS: ogni riga e' una pagina pubblicata su uno dei siti del deploy, e le pagine formano
-- un albero ( id_genitore ) che e' lo scheletro del sito. Le altre tabelle che generano pagine ( le sei categorie_*,
-- prodotti, marchi, notizie, annunci, risorse, progetti ) si appendono a questo albero con id_pagina e ne copiano il
-- modello: stessa testa ricorsiva, stesso blocco web ( template, schema_html, tema_css, se_sitemap, se_cacheable,
-- id_sito ), stesso trio di funzioni _path. Il testo della pagina sta in contenuti ( una riga per lingua, id_pagina ),
-- la pubblicazione e la sua finestra temporale in pubblicazioni, i permessi in __acl_pagine__; la legge il modulo
-- pagine ( _310.pages.php per l'albero, _420.pages.php per contenuti, media e javascript ).
--
-- NOTA ordine e' l'ordine predefinito della pagina fra le sorelle; la pubblicazione ha un suo ordine, che vince quando
-- c'e' ( COALESCE( pubblicazioni.ordine, pagine.ordine ) ). Oggi il codice legge solo pubblicazioni.ordine.
--
-- NOTA id_pagina_contenuti serve a non copiare a mano testi identici fra piu' pagine ( p.es. la pagina contatti comune
-- ai siti di un multisito ): se e' valorizzata, la pagina prende i contenuti dalla pagina indicata, in tutte le lingue,
-- e chi li aggiorna li aggiorna una volta sola. Punta a una pagina e non a una riga di contenuti perche' i contenuti
-- sono una riga per lingua. La chiave esterna blocca la cancellazione della pagina sorgente finche' qualcuno la usa.
-- Il supporto nel codice ( _420.pages.php ) e' da scrivere.
--
-- NOTA javascript contiene lo script proprio della pagina, che il template emette nel suo blocco javascript: sta qui e
-- non dentro i contenuti perche' chi scrive i testi non lo tocchi per sbaglio.
--
-- NOTA id_sito non ha chiave esterna perche' i siti sono definiti nella configurazione, non nel database.
--
-- ATTENZIONE all'indice unico ( id_genitore, nome ): in MySQL i NULL non fanno mai conflitto su un indice unico, quindi
-- NON protegge le pagine di radice, che id_genitore ce l'hanno NULL.
CREATE TABLE IF NOT EXISTS `pagine` (                             --
  `id` bigint(20) NOT NULL,                                       -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                          -- chiave esterna per la pagina genitore
  `ordine` int(11) DEFAULT NULL,                                  -- ordine predefinito fra le pagine sorelle
  `codice` char(32) DEFAULT NULL,                                 -- codice della pagina, chiave stabile per gli import
  `nome` char(255) DEFAULT NULL,                                  -- nome della pagina
  `note` text DEFAULT NULL,                                       -- note sulla pagina
  `id_pagina_contenuti` bigint(20) DEFAULT NULL,                  -- chiave esterna per la pagina da cui prendere i contenuti
  `javascript` text DEFAULT NULL,                                 -- script proprio della pagina
  `template` char(255) DEFAULT NULL,                              -- template con cui si mostra la pagina
  `schema_html` char(128) DEFAULT NULL,                           -- schema HTML del template
  `tema_css` char(128) DEFAULT NULL,                              -- tema CSS del template
  `se_sitemap` tinyint(1) DEFAULT NULL,                           -- la pagina va nella sitemap
  `se_cacheable` tinyint(1) DEFAULT NULL,                         -- la pagina si puo' mettere in cache
  `id_sito` bigint(20) DEFAULT NULL,                              -- sito della configurazione a cui appartiene la pagina
  `data_archiviazione` date DEFAULT NULL,                         -- data di archiviazione
  `note_archiviazione` text DEFAULT NULL,                         -- note di archiviazione
  `id_account_inserimento` bigint(20) DEFAULT NULL,               -- account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                   -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,             -- account che ha aggiornato la riga per ultimo
  `timestamp_aggiornamento` int(11) DEFAULT NULL                  -- timestamp dell'ultimo aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                             --

-- | 010000023500

-- periodi
-- tipologia: tabella di supporto
-- rango: tabella principale
-- struttura: tabella ricorsiva
-- funzione: contiene intervalli di date con un nome e una tipologia
--
-- questa tabella contiene periodi di qualsiasi tipo, ognuno con una data di inizio, una data di fine e una tipologia
-- ( dalla tabella tipologie_periodi ) che dice cos'è; oggi i periodi servono come anno di riferimento degli oggetti
-- ( l'anno sportivo a cui appartengono i corsi, progetti.id_periodo ), come chiusure da saltare quando si generano
-- date ( feste, ferie, sospensioni ) e come sospensioni di un contratto; i periodi si possono appendere a un periodo
-- che li contiene ( p.es. le feste al loro anno sportivo ), e la tabella è ricorsiva per questo
--
-- NOTA la tabella è volutamente generica: un periodo è qualsiasi intervallo di date che abbia un significato per
-- l'applicazione ( le repliche di uno spettacolo, la validità di un'offerta, una finestra di gioco ), e i nuovi usi
-- si aggiungono con una tipologia e, se il periodo appartiene a un oggetto, con una colonna per quell'oggetto, come
-- id_contratto per le sospensioni dei contratti
--
CREATE TABLE IF NOT EXISTS `periodi` (                         --
  `id` bigint(20) NOT NULL,                                      -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                         -- chiave esterna per il periodo che contiene questo
  `id_tipologia` bigint(20) DEFAULT NULL,                        -- chiave esterna per la tipologia del periodo
  `nome` char(255) DEFAULT NULL,                              -- nome del periodo
  `id_contratto` bigint(20) DEFAULT NULL,                        -- chiave esterna per il contratto a cui appartiene il periodo ( p.es. una sospensione )
  `data_inizio` date DEFAULT NULL,                            -- data di inizio del periodo, compresa
  `data_fine` date DEFAULT NULL,                              -- data di fine del periodo, compresa
  `note` text DEFAULT NULL,                                   -- note sul periodo
  `id_account_inserimento` bigint(20) DEFAULT NULL,              -- chiave esterna per l'account che ha inserito il periodo
  `timestamp_inserimento` int(11) DEFAULT NULL,               -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,            -- chiave esterna per l'account che ha aggiornato il periodo
  `timestamp_aggiornamento` int(11) DEFAULT NULL              -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000023600

-- periodicita
-- tipologia: tabella standard
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene le periodicità con cui si ripetono pianificazioni, abbonamenti, rinnovi e orari
--
-- le cadenze, da giornaliera ad annuale, caricate dai file di base; dicono ogni quanto si ripete una cosa e le usano
-- le pianificazioni, gli articoli venduti come abbonamento o tesseramento, i rinnovi, gli orari e i progetti. La
-- tabella fa parte del framework col suo contenuto: non si modifica dalle interfacce, e per questo non ha la coda
-- di audit.
-- NOTA gli id non sono arbitrari: creazionePianificazione() di _src/_lib/_cron.utils.php ci fa sopra uno switch
-- ( 1 giorni, 2 settimane, 3-8 mesi con la mappa $mesi, 8 l'unica annuale ) e i form delle pianificazioni li
-- confrontano direttamente, quindi gli id non si cambiano
CREATE TABLE IF NOT EXISTS `periodicita` (                    --
  `id` bigint(20) NOT NULL,                                   -- chiave primaria, cablata nel motore delle pianificazioni
  `nome` char(255) DEFAULT NULL,                              -- nome della periodicità
  `giorni` int(11) DEFAULT NULL                               -- durata indicativa in giorni, usata per ordinarle
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000023700

-- pesi_tipologie_corrispondenza
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene gli scaglioni di peso per ogni tipologia di corrispondenza
--
-- questa tabella contiene gli scaglioni di peso della corrispondenza cartacea ( p.es. fino a 20 grammi, da 21 a 50 ):
-- ogni scaglione appartiene a una tipologia e, insieme al formato, determina la tariffa. La tabella appartiene al
-- modulo corrispondenza.
-- NOTA gli estremi dello scaglione sono in grammi, come dice il nome delle colonne; grammi_max NULL vuol dire senza
-- limite superiore ( p.es. "oltre 2kg" ), mai 0. Il nome dello scaglione è unico dentro la sua tipologia
--
CREATE TABLE IF NOT EXISTS `pesi_tipologie_corrispondenza` (  --
  `id` bigint(20) NOT NULL,                                   -- chiave primaria
  `id_tipologia` bigint(20) DEFAULT NULL,                     -- tipologia di corrispondenza a cui lo scaglione appartiene
  `nome` char(255) DEFAULT NULL,                              -- nome dello scaglione
  `grammi_min` decimal(8,2) DEFAULT NULL,                     -- peso minimo dello scaglione, in grammi
  `grammi_max` decimal(8,2) DEFAULT NULL,                     -- peso massimo dello scaglione, in grammi
  `id_account_inserimento` bigint(20) DEFAULT NULL,           -- account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,               -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,         -- account che ha aggiornato la riga per ultimo
  `timestamp_aggiornamento` int(11) DEFAULT NULL              -- timestamp dell'ultimo aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000023800

-- pianificazioni
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella ricorsiva
-- funzione: contiene le pianificazioni, cioè le regole con cui generare oggetti ricorrenti a partire da un modello
--
-- questa tabella dice ogni quanto ( id_periodicita, cadenza, se_lunedi ... se_domenica ) e fino a quando generare
-- oggetti della tabella indicata in entita, copiandoli dalle colonne model_* oppure dall'oggetto collegato; le righe
-- figlie ( id_genitore ) generano gli oggetti collegati a quello del genitore, ad esempio le righe e i pagamenti di
-- una fattura ricorrente. Gli oggetti li crea il cron attraverso il modulo _PI000.pianificazioni. Il blocco
-- iterazioni, delay, token e timestamp_elaborazione è quello comune alle automazioni ( job, task, pianificazioni ),
-- e i collegamenti id_progetto, id_todo, id_attivita, id_contratto e id_anagrafica dicono a chi appartiene la
-- pianificazione, che muore con lui
-- NOTA le colonne model_* di testo ( model_codice, model_importo_*, model_nome… ) possono contenere espressioni Twig
-- rese alla creazione dell'oggetto, per questo model_codice è più largo del codice e gli importi sono char
CREATE TABLE IF NOT EXISTS `pianificazioni` (                 --
  `id` bigint(20) NOT NULL,                                   -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                      -- chiave esterna per la pianificazione genitore ( righe e pagamenti del documento )
  `id_progetto` bigint(20) DEFAULT NULL,                      -- chiave esterna per il progetto proprietario
  `id_todo` bigint(20) DEFAULT NULL,                          -- chiave esterna per la todo proprietaria
  `id_attivita` bigint(20) DEFAULT NULL,                      -- chiave esterna per l'attività proprietaria
  `id_contratto` bigint(20) DEFAULT NULL,                     -- chiave esterna per il contratto proprietario
  `id_anagrafica` bigint(20) DEFAULT NULL,                    -- chiave esterna per l'anagrafica collegata
  `nome` char(255) DEFAULT NULL,                              -- nome della pianificazione
  `note` text DEFAULT NULL,                                   -- note sulla pianificazione
  `id_periodicita` bigint(20) DEFAULT NULL,                   -- chiave esterna per la periodicità di ripetizione
  `cadenza` int(11) DEFAULT NULL,                             -- ogni quante unità della periodicità ( default 1 )
  `se_lunedi` tinyint(1) DEFAULT NULL,                        -- flag del lunedì per la periodicità settimanale
  `se_martedi` tinyint(1) DEFAULT NULL,                       -- flag del martedì per la periodicità settimanale
  `se_mercoledi` tinyint(1) DEFAULT NULL,                     -- flag del mercoledì per la periodicità settimanale
  `se_giovedi` tinyint(1) DEFAULT NULL,                       -- flag del giovedì per la periodicità settimanale
  `se_venerdi` tinyint(1) DEFAULT NULL,                       -- flag del venerdì per la periodicità settimanale
  `se_sabato` tinyint(1) DEFAULT NULL,                        -- flag del sabato per la periodicità settimanale
  `se_domenica` tinyint(1) DEFAULT NULL,                      -- flag del domenica per la periodicità settimanale
  `schema_ripetizione` int(11) DEFAULT NULL,                  -- 1 giorno esatto, 2 posizione del giorno nel periodo
  `data_avvio` date DEFAULT NULL,                             -- da quando il cron la elabora
  `data_inizio` date DEFAULT NULL,                            -- data del primo oggetto
  `data_elaborazione` date DEFAULT NULL,                      -- data di lavoro dell'ultima elaborazione completa
  `timestamp_elaborazione` int(11) DEFAULT NULL,              -- ultima presa in carico, è il timestamp_esecuzione
  `data_ultimo_oggetto` date DEFAULT NULL,                    -- data dell'ultimo oggetto creato
  `giorni_elaborazione` int(11) DEFAULT NULL,                 -- giorni di anticipo con cui si creano gli oggetti
  `giorni_estensione` int(11) DEFAULT NULL,                   -- giorni di allungamento della data di fine
  `data_fine` date DEFAULT NULL,                              -- ultima data in cui creare oggetti, compresa
  `entita` enum('todo','attivita','rinnovi','documenti','documenti_articoli','pagamenti') DEFAULT NULL,-- tabella degli oggetti creati
  `model_id_anagrafica` bigint(20) DEFAULT NULL,              -- modello per la colonna id_anagrafica dell'oggetto creato
  `model_id_anagrafica_programmazione` bigint(20) DEFAULT NULL,-- modello per la colonna id_anagrafica_programmazione dell'oggetto creato
  `model_id_articolo` bigint(20) DEFAULT NULL,                -- modello per la colonna id_articolo dell'oggetto creato
  `model_id_attivita` bigint(20) DEFAULT NULL,                -- modello per la colonna id_attivita dell'oggetto creato
  `model_id_causale` bigint(20) DEFAULT NULL,                 -- modello per la colonna id_causale dell'oggetto creato
  `model_id_cliente` bigint(20) DEFAULT NULL,                 -- modello per la colonna id_cliente dell'oggetto creato
  `model_id_collo` bigint(20) DEFAULT NULL,                   -- modello per la colonna id_collo dell'oggetto creato
  `model_id_condizione_pagamento` bigint(20) DEFAULT NULL,    -- modello per la colonna id_condizione_pagamento dell'oggetto creato
  `model_id_contatto` bigint(20) DEFAULT NULL,                -- modello per la colonna id_contatto dell'oggetto creato
  `model_id_coupon` bigint(20) DEFAULT NULL,                  -- modello per la colonna id_coupon dell'oggetto creato
  `model_id_destinatario` bigint(20) DEFAULT NULL,            -- modello per la colonna id_destinatario dell'oggetto creato
  `model_id_documento` bigint(20) DEFAULT NULL,               -- modello per la colonna id_documento dell'oggetto creato
  `model_id_emittente` bigint(20) DEFAULT NULL,               -- modello per la colonna id_emittente dell'oggetto creato
  `model_id_genitore` bigint(20) DEFAULT NULL,                -- modello per la colonna id_genitore dell'oggetto creato
  `model_id_iban` bigint(20) DEFAULT NULL,                    -- modello per la colonna id_iban dell'oggetto creato
  `model_id_indirizzo` bigint(20) DEFAULT NULL,               -- modello per la colonna id_indirizzo dell'oggetto creato
  `model_id_immobile` bigint(20) DEFAULT NULL,                -- modello per la colonna id_immobile dell'oggetto creato
  `model_id_licenza` bigint(20) DEFAULT NULL,                 -- modello per la colonna id_licenza dell'oggetto creato
  `model_id_listino` bigint(20) DEFAULT NULL,                 -- modello per la colonna id_listino dell'oggetto creato
  `model_id_luogo` bigint(20) DEFAULT NULL,                   -- modello per la colonna id_luogo dell'oggetto creato
  `model_id_mastro_destinazione` bigint(20) DEFAULT NULL,     -- modello per la colonna id_mastro_destinazione dell'oggetto creato
  `model_id_mastro_provenienza` bigint(20) DEFAULT NULL,      -- modello per la colonna id_mastro_provenienza dell'oggetto creato
  `model_id_matricola` bigint(20) DEFAULT NULL,               -- modello per la colonna id_matricola dell'oggetto creato
  `model_id_modalita_pagamento` bigint(20) DEFAULT NULL,      -- modello per la colonna id_modalita_pagamento dell'oggetto creato
  `model_id_prodotto` bigint(20) DEFAULT NULL,                -- modello per la colonna id_prodotto dell'oggetto creato
  `model_id_progetto` bigint(20) DEFAULT NULL,                -- modello per la colonna id_progetto dell'oggetto creato
  `model_id_reparto` bigint(20) DEFAULT NULL,                 -- modello per la colonna id_reparto dell'oggetto creato
  `model_id_sede_destinatario` bigint(20) DEFAULT NULL,       -- modello per la colonna id_sede_destinatario dell'oggetto creato
  `model_id_sede_emittente` bigint(20) DEFAULT NULL,          -- modello per la colonna id_sede_emittente dell'oggetto creato
  `model_id_tipologia` bigint(20) DEFAULT NULL,               -- modello per la colonna id_tipologia dell'oggetto creato
  `model_id_todo` bigint(20) DEFAULT NULL,                    -- modello per la colonna id_todo dell'oggetto creato
  `model_id_trasportatore` bigint(20) DEFAULT NULL,           -- modello per la colonna id_trasportatore dell'oggetto creato
  `model_id_udm` bigint(20) DEFAULT NULL,                     -- modello per la colonna id_udm dell'oggetto creato
  `model_anno_programmazione` year(4) DEFAULT NULL,           -- modello per la colonna anno_programmazione dell'oggetto creato
  `model_codice` char(64) DEFAULT NULL,                       -- modello per la colonna codice dell'oggetto creato
  `model_data` date DEFAULT NULL,                             -- modello per la colonna data dell'oggetto creato
  `model_data_fine` date DEFAULT NULL,                        -- modello per la colonna data_fine dell'oggetto creato
  `model_data_inizio` date DEFAULT NULL,                      -- modello per la colonna data_inizio dell'oggetto creato
  `model_data_programmazione` date DEFAULT NULL,              -- modello per la colonna data_programmazione dell'oggetto creato
  `model_esigibilita` enum('I','D','S') DEFAULT NULL,         -- modello per la colonna esigibilita dell'oggetto creato
  `model_importo_netto_totale` char(32) DEFAULT NULL,         -- modello per la colonna importo_netto_totale dell'oggetto creato
  `model_importo_lordo_totale` char(32) DEFAULT NULL,         -- modello per la colonna importo_lordo_totale dell'oggetto creato
  `model_importo_lordo_finale` char(32) DEFAULT NULL,         -- modello per la colonna importo_lordo_finale dell'oggetto creato
  `model_nome` char(255) DEFAULT NULL,                        -- modello per la colonna nome dell'oggetto creato
  `model_note` text DEFAULT NULL,                             -- modello per la colonna note dell'oggetto creato
  `model_note_cliente` text DEFAULT NULL,                     -- modello per la colonna note_cliente dell'oggetto creato
  `model_note_programmazione` text DEFAULT NULL,              -- modello per la colonna note_programmazione dell'oggetto creato
  `model_numero` char(32) DEFAULT NULL,                       -- modello per la colonna numero dell'oggetto creato
  `model_ora_inizio_programmazione` time DEFAULT NULL,        -- modello per la colonna ora_inizio_programmazione dell'oggetto creato
  `model_ora_fine_programmazione` time DEFAULT NULL,          -- modello per la colonna ora_fine_programmazione dell'oggetto creato
  `model_ore_programmazione` decimal(5,2) DEFAULT NULL,       -- modello per la colonna ore_programmazione dell'oggetto creato
  `model_porto` enum('franco','assegnato','-') DEFAULT NULL,  -- modello per la colonna porto dell'oggetto creato
  `model_quantita` decimal(9,2) DEFAULT NULL,                 -- modello per la colonna quantita dell'oggetto creato
  `model_riferimento` char(255) DEFAULT NULL,                 -- modello per la colonna riferimento dell'oggetto creato
  `model_sconto_percentuale` decimal(9,2) DEFAULT NULL,       -- modello per la colonna sconto_percentuale dell'oggetto creato
  `model_sconto_valore` decimal(9,2) DEFAULT NULL,            -- modello per la colonna sconto_valore dell'oggetto creato
  `model_se_automatico` tinyint(1) DEFAULT NULL,              -- modello per la colonna se_automatico dell'oggetto creato
  `model_sezionale` char(32) DEFAULT NULL,                    -- modello per la colonna sezionale dell'oggetto creato
  `model_settimana_programmazione` int(11) DEFAULT NULL,      -- modello per la colonna settimana_programmazione dell'oggetto creato
  `model_specifiche` text DEFAULT NULL,                       -- modello per la colonna specifiche dell'oggetto creato
  `model_data_scadenza` date DEFAULT NULL,                    -- modello per la colonna data_scadenza dell'oggetto creato
  `offset_giorni` int(11) DEFAULT NULL,                       -- per i pagamenti, giorni di differimento della scadenza
  `offset_fine_mese` int(1) DEFAULT NULL,                     -- per i pagamenti, scadenza a fine mese
  `iterazioni` int(11) DEFAULT NULL,                          -- oggetti per passata, NULL vuol dire 1
  `delay` int(11) DEFAULT NULL,                               -- secondi minimi fra due iterazioni
  `token` char(254) DEFAULT NULL,                             -- token di lock della passata in corso
  `id_account_inserimento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,               -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,         -- chiave esterna per l'account che ha aggiornato la riga
  `timestamp_aggiornamento` int(11) DEFAULT NULL              -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000024000

-- popup
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene i popup, finestre modali pubblicitarie o informative da mostrare sui siti e sulle app
--
-- un popup è un elemento pubblicitario o informativo che compare sopra la pagina, in una finestra modale; si gestisce
-- col modulo dei popup ed è in tutto simmetrico ai banner: cambia solo il modo in cui si manifesta all'utente; il
-- momento in cui compare è indicato dalla tipologia, da tipologie_popup ( all'apertura della pagina, alla chiusura,
-- dopo n_secondi, dopo n_scroll per cento di scorrimento ); titoli e testo del popup stanno in contenuti, collegati
-- con id_popup
--
-- quando l'utente chiude un popup la chiusura viene ricordata per html_id, che è anche l'id dell'elemento HTML,
-- e il popup non gli viene più mostrato
--
-- NOTA dove e quando il popup appare non sta qui ma in pubblicazioni, collegata con id_popup: ogni pubblicazione
-- è una collocazione, col sito o l'app, la pagina ( senza pagina, ovunque ), l'ordine e il periodo di validità
--
-- NOTA template e schema_html sono il template delle pagine su cui il popup compare e lo schema Twig della finestra;
-- non sono il blocco web delle tabelle che generano pagine ( il popup non genera pagine ), e seguono la decisione
-- sul blocco web nelle pubblicazioni ( schema canonico, punto 6e )
--
-- NOTA id_sito e se_ovunque sono deprecate ( 26/10/2026 ): la collocazione sta in pubblicazioni, e restano solo
-- perche' il modulo legacy dei popup le legge ancora; si tolgono quando tutti i legacy che le usano sono dismessi
--
CREATE TABLE IF NOT EXISTS `popup` (                            --
  `id` bigint(20) NOT NULL,                                       -- chiave primaria
  `id_tipologia` bigint(20) DEFAULT NULL,                         -- chiave esterna per la tipologia del popup ( quando compare )
  `nome` char(255) DEFAULT NULL,                                  -- nome del popup
  `html_id` char(128) DEFAULT NULL,                               -- id dell'elemento HTML, chiave con cui si ricorda la chiusura
  `n_secondi` int(11) DEFAULT NULL,                               -- secondi dopo i quali compare, per la tipologia dopo secondi
  `n_scroll` int(11) DEFAULT NULL,                                -- percentuale di scorrimento a cui compare, per la tipologia dopo scroll
  `note` text DEFAULT NULL,                                       -- note
  `template` char(128) DEFAULT NULL,                              -- template delle pagine su cui il popup compare
  `schema_html` char(128) DEFAULT NULL,                           -- schema Twig della finestra del popup
  `id_sito` bigint(20) DEFAULT NULL,                              -- sito su cui compare il popup ( deprecato )
  `se_ovunque` tinyint(1) DEFAULT NULL,                           -- il popup compare su tutte le pagine ( deprecato )
  `id_account_inserimento` bigint(20) DEFAULT NULL,               -- account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                   -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,             -- account che ha aggiornato la riga per ultimo
  `timestamp_aggiornamento` int(11) DEFAULT NULL                  -- timestamp dell'ultimo aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000024200

-- popup_pagine
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: mette in relazione popup e pagine
--
CREATE TABLE IF NOT EXISTS `popup_pagine` (
  `id` bigint(20) NOT NULL,
  `id_pagina` bigint(20) DEFAULT NULL,
  `id_popup` bigint(20) DEFAULT NULL,
  `se_presente` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000025000

-- prezzi
-- tipologia: tabella gestita
-- rango: tabella secondaria
-- struttura: tabella base
-- funzione: contiene i prezzi di prodotti e articoli, per listino, scaglione di quantità e periodo di validità
--
-- un prezzo non ha senso al di fuori di un listino: ogni riga appartiene a un listino ( listini ), che ne dà la
-- valuta, e si riferisce a un articolo o a un prodotto ( in quel caso vale per tutti i suoi articoli ); il prezzo è
-- netto e l'aliquota è in id_iva; per lo stesso listino e oggetto ci possono essere più righe, una per scaglione
-- ( qta_min, qta_max ) e per periodo ( data_inizio, data_fine ): il prezzo che vale è quello della riga con l'inizio
-- più recente e lo scaglione più alto fra quelle che comprendono data e quantità, e lo storico si tiene chiudendo le
-- righe superate con data_fine; la chiave unica è listino, oggetto, qta_min, data_inizio; se un listino non ha il
-- prezzo vale quello del listino genitore ( specificità lungo l'albero, vedi listini )
--
-- NOTA le provvigioni sono per riga di listino; provvigioni per cliente o per categoria non sono ancora previste
--
CREATE TABLE IF NOT EXISTS `prezzi` (                           --
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `id_listino` bigint(20) DEFAULT NULL,                         -- chiave esterna per il listino a cui appartiene il prezzo, obbligatoria
  `id_prodotto` bigint(20) DEFAULT NULL,                        -- chiave esterna per il prodotto, se il prezzo vale per tutti i suoi articoli
  `id_articolo` bigint(20) DEFAULT NULL,                        -- chiave esterna per l'articolo a cui si riferisce il prezzo
  `qta_min` int(11) DEFAULT NULL,                               -- quantità minima da cui vale il prezzo ( scaglione ), NULL = nessun minimo
  `qta_max` int(11) DEFAULT NULL,                               -- quantità massima fino a cui vale il prezzo, NULL = nessun massimo
  `data_inizio` date DEFAULT NULL,                              -- data da cui vale il prezzo, NULL = da sempre
  `data_fine` date DEFAULT NULL,                                -- data fino a cui vale il prezzo, compresa, NULL = senza scadenza
  `fascia` char(32) DEFAULT NULL,                               -- fascia di prezzo, etichetta libera per raggruppare i prezzi
  `prefisso` char(64) DEFAULT NULL,                             -- testo mostrato prima del prezzo ( p.es. "da" )
  `prezzo` decimal(16,5) DEFAULT NULL,                          -- prezzo netto, nella valuta del listino
  `suffisso` char(64) DEFAULT NULL,                             -- testo mostrato dopo il prezzo ( p.es. "al mese" )
  `id_iva` bigint(20) DEFAULT NULL,                             -- chiave esterna per l'aliquota IVA del prezzo
  `sconto_articoli` decimal(16,5) DEFAULT NULL,                 -- sconto percentuale sugli articoli di un prodotto composto ( paniere )
  `provvigione_percentuale` decimal(16,5) DEFAULT NULL,         -- provvigione percentuale sul prezzo
  `provvigione_fissa` decimal(16,5) DEFAULT NULL,               -- provvigione fissa, nella valuta del listino
  `id_reparto` bigint(20) DEFAULT NULL,                         -- chiave esterna per il reparto di cassa del prezzo
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha inserito il prezzo
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha aggiornato il prezzo
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                           --

-- | 010000026000

-- prodotti
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene i prodotti, cioè le schede commerciali che raggruppano gli articoli
--
-- un prodotto è l'oggetto teorico che raggruppa uno o più articoli con le stesse caratteristiche di base: il prodotto
-- porta nome, marchio, produttore e tipologia, gli articoli ( articoli.id_prodotto ) sono le sue varianti concrete, con
-- codice, misure e prezzo. Ogni prodotto genera una pagina del sito sotto ciascuna delle sue categorie
-- ( prodotti_categorie ), la canonical sotto la prima; per questo porta il blocco web ( template, schema_html,
-- tema_css, se_sitemap, se_cacheable, id_sito, id_pagina ) come le altre entità che generano pagine.
--
-- NOTA il blocco web è deprecato su questa tabella ( punto 6e, 22/10/2026 ): sta sulle pubblicazioni, una per sito, e
-- qui resta per i moduli legacy di oldstable; il codice latest legge quello di pubblicazioni
-- NOTA id_pagina è la pagina sotto cui si appende il prodotto senza categoria; id_sito non ha chiave esterna perché
-- i siti sono definiti nella configurazione, non nel database
-- NOTA il marchio non possiede il prodotto: cancellare un marchio lascia i suoi prodotti senza marchio
--
CREATE TABLE IF NOT EXISTS `prodotti` (                           --
  `id` bigint(20) NOT NULL,                                       -- chiave primaria
  `id_tipologia` bigint(20) DEFAULT NULL,                         -- chiave esterna per la tipologia del prodotto
  `codice` char(32) DEFAULT NULL,                                 -- codice del prodotto
  `nome` char(255) DEFAULT NULL,                                  -- nome del prodotto
  `id_marchio` bigint(20) DEFAULT NULL,                           -- chiave esterna per il marchio del prodotto
  `id_produttore` bigint(20) DEFAULT NULL,                        -- chiave esterna per l'anagrafica del produttore
  `codice_produttore` char(64) DEFAULT NULL,                      -- codice assegnato al prodotto dal produttore
  `note` text DEFAULT NULL,                                       -- note sul prodotto
  `note_codifica` text DEFAULT NULL,                              -- annotazioni su come è stato assegnato il codice
  `template` char(255) DEFAULT NULL,                              -- template con cui si mostra la pagina del prodotto ( deprecato )
  `schema_html` char(128) DEFAULT NULL,                           -- schema HTML del template ( deprecato )
  `tema_css` char(128) DEFAULT NULL,                              -- tema CSS del template ( deprecato )
  `se_sitemap` tinyint(1) DEFAULT NULL,                           -- la pagina del prodotto va nella sitemap ( deprecato )
  `se_cacheable` tinyint(1) DEFAULT NULL,                         -- la pagina del prodotto si può mettere in cache ( deprecato )
  `id_sito` bigint(20) DEFAULT NULL,                              -- sito della configurazione a cui appartiene la pagina ( deprecato )
  `id_pagina` bigint(20) DEFAULT NULL,                            -- chiave esterna per la pagina genitore nell'albero del sito
  `data_archiviazione` date DEFAULT NULL,                         -- data di archiviazione
  `note_archiviazione` text DEFAULT NULL,                         -- note di archiviazione
  `id_account_inserimento` bigint(20) DEFAULT NULL,               -- account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                   -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,             -- account che ha aggiornato la riga per ultimo
  `timestamp_aggiornamento` int(11) DEFAULT NULL                  -- timestamp dell'ultimo aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                             --

-- | 010000026400

-- prodotti_categorie
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: associa molti a molti i prodotti alle categorie dei prodotti
--
-- questa tabella contiene le associazioni molti a molti tra i prodotti e le categorie_prodotti, cioe' l'albero di
-- navigazione del catalogo: un prodotto genera una pagina sotto ogni categoria a cui appartiene; le categorie fanno
-- parte della scheda del prodotto, quindi la chiave verso prodotti si segue
--
-- NOTA la categoria principale di un prodotto e' la prima nell'ordine ( ORDER BY ordine, id ), ed e' quella sotto
-- cui sta la canonical della sua pagina; i prodotti "speciali" di una categoria ( p.es. in evidenza ) non si
-- marcano qui ma con una pubblicazione ( pubblicazioni )
--
CREATE TABLE IF NOT EXISTS `prodotti_categorie` (             --
  `id` bigint(20) NOT NULL,                                   -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                              -- ordine di visualizzazione, la prima e' la principale
  `id_prodotto` bigint(20) DEFAULT NULL,                      -- chiave esterna per il prodotto
  `id_categoria` bigint(20) DEFAULT NULL,                     -- chiave esterna per la categoria
  `id_account_inserimento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha inserito l'associazione
  `timestamp_inserimento` int(11) DEFAULT NULL,               -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,         -- chiave esterna per l'account che ha aggiornato l'associazione
  `timestamp_aggiornamento` int(11) DEFAULT NULL              -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000027000

-- progetti
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene i progetti, cioè le commesse e le iniziative con un ciclo di vita
--
-- un progetto è un lavoro con un inizio e una fine che aggrega cose da fare ( todo ) e attività ( attivita.id_progetto ),
-- e le persone che ci lavorano ( progetti_anagrafica, con ruolo ). Il suo ciclo di vita si legge dai blocchi di colonne,
-- nell'ordine in cui si riempiono: previsioni ( entrate, ore e uscite stimate ), accettazione del cliente, apertura
-- dei lavori, consegna, chiusura e consuntivo ( totali ); le viste virtuali progetti_commerciale, progetti_produzione e
-- le loro sorelle selezionano i progetti in base a quali date sono valorizzate. Un progetto può essere l'istanza di un
-- prodotto in un periodo, come l'edizione di un corso ( id_prodotto, id_periodo ). Come le altre entità che generano
-- pagine porta il blocco web ( template, schema_html, tema_css, se_sitemap, se_cacheable, id_sito, id_pagina ) e si
-- appende sotto le sue categorie ( progetti_categorie ).
--
-- NOTA il blocco web è deprecato su questa tabella ( punto 6e, 22/10/2026 ): sta sulle pubblicazioni, una per sito, e
-- qui resta per i moduli legacy di oldstable; il codice latest legge quello di pubblicazioni
-- NOTA id_pagina è la pagina sotto cui si appende il progetto senza categoria; id_sito non ha chiave esterna perché
-- i siti sono definiti nella configurazione, non nel database
-- NOTA entrate, ore e uscite hanno lo stesso nome in previsione e a consuntivo ( entrate_previste / entrate_totali,
-- uscite_previste / uscite_totali ); uscite_previste si chiamava costi_previsti fino al 22/10/2026
--
CREATE TABLE IF NOT EXISTS `progetti` (                           --
  `id` bigint(20) NOT NULL,                                       -- chiave primaria
  `id_tipologia` bigint(20) DEFAULT NULL,                         -- chiave esterna per la tipologia del progetto
  `codice` char(32) DEFAULT NULL,                                 -- codice del progetto
  `nome` char(255) DEFAULT NULL,                                  -- nome del progetto
  `id_prodotto` bigint(20) DEFAULT NULL,                          -- chiave esterna per il prodotto di cui il progetto è un'istanza ( p.es. il corso )
  `id_articolo` bigint(20) DEFAULT NULL,                          -- chiave esterna per l'articolo con cui il progetto si vende
  `id_periodo` bigint(20) DEFAULT NULL,                           -- chiave esterna per il periodo in cui si svolge il progetto ( p.es. l'edizione )
  `id_cliente` bigint(20) DEFAULT NULL,                           -- chiave esterna per l'anagrafica del cliente
  `id_indirizzo` bigint(20) DEFAULT NULL,                         -- chiave esterna per l'indirizzo dove si svolge il progetto
  `id_pianificazione` bigint(20) DEFAULT NULL,                    -- chiave esterna per la pianificazione che ha generato il progetto
  `note` text DEFAULT NULL,                                       -- note sul progetto
  `entrate_previste` decimal(16,2) DEFAULT NULL,                  -- entrate previste
  `ore_previste` decimal(16,2) DEFAULT NULL,                      -- ore di lavoro previste
  `uscite_previste` decimal(16,2) DEFAULT NULL,                   -- uscite previste ( fino al 22/10/2026 costi_previsti )
  `id_periodicita_prevista` bigint(20) DEFAULT NULL,              -- chiave esterna per la periodicità a cui si riferiscono le previsioni
  `note_previsioni` text DEFAULT NULL,                            -- note sulle previsioni
  `data_accettazione` date DEFAULT NULL,                          -- data in cui il cliente ha accettato il progetto
  `entrate_accettazione` decimal(16,2) DEFAULT NULL,              -- entrate concordate all'accettazione
  `id_periodicita_accettazione` bigint(20) DEFAULT NULL,          -- chiave esterna per la periodicità a cui si riferiscono le entrate concordate
  `note_accettazione` text DEFAULT NULL,                          -- note sull'accettazione
  `data_apertura` date DEFAULT NULL,                              -- data di apertura dei lavori
  `note_apertura` text DEFAULT NULL,                              -- note sull'apertura
  `data_consegna` date DEFAULT NULL,                              -- data di consegna prevista
  `note_consegna` text DEFAULT NULL,                              -- note sulla consegna
  `data_chiusura` date DEFAULT NULL,                              -- data di chiusura dei lavori
  `note_chiusura` text DEFAULT NULL,                              -- note sulla chiusura
  `entrate_totali` decimal(16,2) DEFAULT NULL,                    -- entrate a consuntivo
  `ore_totali` decimal(16,2) DEFAULT NULL,                        -- ore di lavoro a consuntivo
  `uscite_totali` decimal(16,2) DEFAULT NULL,                     -- uscite a consuntivo
  `note_totali` text DEFAULT NULL,                                -- note sul consuntivo
  `template` char(255) DEFAULT NULL,                              -- template con cui si mostra la pagina del progetto ( deprecato )
  `schema_html` char(128) DEFAULT NULL,                           -- schema HTML del template ( deprecato )
  `tema_css` char(128) DEFAULT NULL,                              -- tema CSS del template ( deprecato )
  `se_sitemap` tinyint(1) DEFAULT NULL,                           -- la pagina del progetto va nella sitemap ( deprecato )
  `se_cacheable` tinyint(1) DEFAULT NULL,                         -- la pagina del progetto si può mettere in cache ( deprecato )
  `id_sito` bigint(20) DEFAULT NULL,                              -- sito della configurazione a cui appartiene la pagina ( deprecato )
  `id_pagina` bigint(20) DEFAULT NULL,                            -- chiave esterna per la pagina genitore nell'albero del sito
  `data_archiviazione` date DEFAULT NULL,                         -- data di archiviazione
  `note_archiviazione` text DEFAULT NULL,                         -- note di archiviazione
  `id_account_inserimento` bigint(20) DEFAULT NULL,               -- account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                   -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,             -- account che ha aggiornato la riga per ultimo
  `timestamp_aggiornamento` int(11) DEFAULT NULL                  -- timestamp dell'ultimo aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                             --

-- | 010000027200

-- progetti_anagrafica
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: collega un progetto alle anagrafiche che vi hanno un ruolo
--
-- questa tabella collega un progetto alle anagrafiche che vi hanno un ruolo ( cliente, referente, coordinatore,
-- docente, istruttore... ); i ruoli proponibili sono quelli con ruoli_anagrafica.se_progetti
--
-- NOTA la chiave unica e' ( id_progetto, id_anagrafica, id_ruolo ): la stessa anagrafica puo' avere piu' ruoli;
-- le note precisano il ruolo nel caso specifico; fra le righe con lo stesso ruolo quella di default e' la prima
-- nell'ordine ( p.es. il cliente principale )
--
-- NOTA se_sostituto e' deprecata: la usano i moduli legacy 0900, 1000 e 1200 e resta finche' la usano; i moduli
-- nuovi non la devono usare, il sostituto e' un ruolo ( ruoli_anagrafica.se_sostituto, decisione del 22/10/2026 )
--
CREATE TABLE IF NOT EXISTS `progetti_anagrafica` (              --
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                -- ordine di visualizzazione
  `id_progetto` bigint(20) DEFAULT NULL,                        -- chiave esterna per il progetto
  `id_anagrafica` bigint(20) DEFAULT NULL,                      -- chiave esterna per l'anagrafica
  `id_ruolo` bigint(20) DEFAULT NULL,                           -- chiave esterna per il ruolo ( ruoli_anagrafica )
  `note` text DEFAULT NULL,                                     -- note che precisano il ruolo
  `se_sostituto` tinyint(1) DEFAULT NULL,                       -- deprecata: flag di sostituto per i moduli legacy
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha aggiornato la riga
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                           --

-- | 010000027300

-- progetti_articoli
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: mette in relazione progetti e articoli
--
CREATE TABLE IF NOT EXISTS `progetti_articoli` (
  `id` bigint(20) NOT NULL,
  `id_progetto` bigint(20) DEFAULT NULL,
  `id_articolo` bigint(20) DEFAULT NULL,
  `id_ruolo` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000027400

-- progetti_categorie
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: associa molti a molti i progetti alle categorie dei progetti
--
-- questa tabella contiene le associazioni molti a molti tra i progetti e le categorie_progetti, cioe' l'albero di
-- navigazione dei progetti: un progetto genera una pagina sotto ogni categoria a cui appartiene; le categorie fanno
-- parte della scheda del progetto, quindi la chiave verso progetti si segue
--
-- NOTA la categoria principale di un progetto e' la prima nell'ordine ( ORDER BY ordine, id ), ed e' quella sotto
-- cui sta la canonical della sua pagina; le categorie di dimensioni diverse ( p.es. disciplina, classe e fascia di
-- un corso ) non si distinguono qui ma coi flag di categorie_progetti ( se_disciplina, se_classe, se_fascia... )
--
CREATE TABLE IF NOT EXISTS `progetti_categorie` (             --
  `id` bigint(20) NOT NULL,                                   -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                              -- ordine di visualizzazione, la prima e' la principale
  `id_progetto` bigint(20) DEFAULT NULL,                      -- chiave esterna per il progetto
  `id_categoria` bigint(20) DEFAULT NULL,                     -- chiave esterna per la categoria
  `id_account_inserimento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha inserito l'associazione
  `timestamp_inserimento` int(11) DEFAULT NULL,               -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,         -- chiave esterna per l'account che ha aggiornato l'associazione
  `timestamp_aggiornamento` int(11) DEFAULT NULL              -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000027600

-- progetti_certificazioni
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: collega un progetto ai documenti e attestati che richiede o che rilascia
--
-- questa tabella collega un progetto alle certificazioni in due sensi, distinti dal ruolo ( ruoli_certificazioni ):
-- quelle richieste per partecipare ( il certificato medico sportivo per un corso di nuoto, l'abilitazione a un
-- macchinario per un lavoro che lo usa ) e quelle che il progetto rilascia ( l'attestato di frequenza di un corso,
-- l'abilitazione a un macchinario ); il possesso di un'anagrafica sta in anagrafica_certificazioni
--
-- NOTA la chiave unica e' ( id_progetto, id_certificazione, id_ruolo ): un corso di aggiornamento che richiede
-- un'abilitazione e la rinnova ha due righe, una per ruolo; le note precisano il requisito ( p.es. in corso di
-- validita' all'iscrizione )
--
-- NOTA nome e se_richiesta sono deprecate: le scrivono i moduli legacy 0920 e 6700 e l'import di polmasi, e restano
-- finche' li usano; i moduli nuovi non le devono usare, l'obbligatorieta' e' un ruolo ( decisione del 23/10/2026 )
--
CREATE TABLE IF NOT EXISTS `progetti_certificazioni` (          --
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                -- ordine di visualizzazione
  `id_progetto` bigint(20) DEFAULT NULL,                        -- chiave esterna per il progetto
  `id_certificazione` bigint(20) DEFAULT NULL,                  -- chiave esterna per la certificazione
  `id_ruolo` bigint(20) DEFAULT NULL,                           -- chiave esterna per il ruolo ( ruoli_certificazioni )
  `note` text DEFAULT NULL,                                     -- note che precisano il requisito o il rilascio
  `nome` char(1) DEFAULT NULL,                                  -- deprecata: dettagli del form dei moduli legacy
  `se_richiesta` tinyint(1) DEFAULT NULL,                       -- deprecata: flag di obbligatorieta' per i moduli legacy
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha aggiornato la riga
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                           --

-- | 010000027800

-- progetti_matricole
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: collega un progetto ai singoli pezzi con matricola che vi hanno un ruolo
--
-- questa tabella collega un progetto ai singoli pezzi con matricola che vi hanno un ruolo ( ruoli_matricole ):
-- l'attrezzatura usata nel progetto, il prodotto realizzato o consegnato; il pezzo e' una riga di matricole, il lotto
-- da cui viene sta in matricole.id_lotto
--
-- NOTA la chiave unica e' ( id_progetto, id_matricola, id_ruolo ): lo stesso pezzo puo' avere piu' ruoli; le note
-- precisano il ruolo nel caso specifico
--
CREATE TABLE IF NOT EXISTS `progetti_matricole` (               --
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                -- ordine di visualizzazione
  `id_progetto` bigint(20) DEFAULT NULL,                        -- chiave esterna per il progetto
  `id_matricola` bigint(20) DEFAULT NULL,                       -- chiave esterna per la matricola
  `id_ruolo` bigint(20) DEFAULT NULL,                           -- chiave esterna per il ruolo ( ruoli_matricole )
  `note` text DEFAULT NULL,                                     -- note che precisano il ruolo
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha aggiornato la riga
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                           --

-- | 010000028000

-- provincie
-- tipologia: tabella standard
-- rango: tabella secondaria
-- struttura: tabella base
-- funzione: contiene le provincie
--
-- le provincie, livello intermedio della geografia ( continenti, stati, regioni, provincie, comuni, indirizzi ) fra la
-- regione che le contiene e i comuni che contengono, per qualsiasi stato. Ogni livello è secondario rispetto a quello
-- che lo contiene: una provincia non ha senso senza la sua regione, quindi una regione che ha delle provincie non si
-- può cancellare. I file di base non popolano la geografia, la carica un'importazione; dentro l'Italia la provincia si
-- identifica con la sigla e col codice ISTAT.
-- una provincia soppressa o fusa non si cancella: si archivia con data_archiviazione e note_archiviazione e punta col
-- id_successore alla provincia che ne ha preso il posto. I valori li scrive l'importazione della geografia; i
-- riferimenti vivi si spostano sul successore, quelli di storia ( nascita, destinatari ) no.
-- NOTA sigla e codice_istat sono codici esterni e mantengono il loro formato; le provincie estere di solito non li hanno
CREATE TABLE IF NOT EXISTS `provincie` (                      --
  `id` bigint(20) NOT NULL,                                   -- chiave primaria
  `nome` char(255) DEFAULT NULL,                              -- nome della provincia
  `id_regione` bigint(20) DEFAULT NULL,                       -- regione che contiene la provincia
  `id_successore` bigint(20) DEFAULT NULL,                    -- provincia che ha preso il posto di questa dopo l'archiviazione
  `sigla` char(8) DEFAULT NULL,                               -- sigla della provincia
  `codice_istat` char(3) DEFAULT NULL,                        -- codice ISTAT della provincia
  `url_riferimento` char(255) DEFAULT NULL,                   -- URL di riferimento della provincia
  `note` text DEFAULT NULL,                                   -- note sulla provincia
  `data_archiviazione` date DEFAULT NULL,                     -- data di archiviazione della provincia
  `note_archiviazione` text DEFAULT NULL                      -- note sull'archiviazione della provincia
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000028400

-- pubblicazioni
-- tipologia: tabella gestita
-- rango: tabella secondaria
-- struttura: tabella base
-- funzione: dice dove, quando, in che stato e come sono pubblicati gli oggetti dei siti
--
-- ogni riga è la pubblicazione di un oggetto, e di uno solo: una colonna id_* valorizzata dice di quale oggetto si
-- tratta ( una pagina, una delle entità che generano pagine e le loro categorie, un articolo, un banner o un popup );
-- la riga dice su quale sito vale ( id_sito, NULL = tutti ), in che periodo ( timestamp_inizio e timestamp_fine, NULL
-- = senza limite ), in che stato ( la tipologia, da tipologie_pubblicazioni: bozza, pubblicato, in evidenza,
-- anteprima ) e, per gli oggetti che generano pagine, come si mostrano su quel sito ( il blocco web: template,
-- schema_html, tema_css, se_sitemap, se_cacheable ); un oggetto può avere più pubblicazioni, per siti o periodi diversi
--
-- id_pagina ha due sensi: da sola è la pubblicazione della pagina; accanto a id_banner o id_popup è la pagina dove il
-- banner o il popup appare ( senza pagina, ovunque ); per i banner spazio è l'id HTML dello spazio della pagina
-- in cui il banner compare
--
-- NOTA il blocco web si legge a catena: la pubblicazione, poi la configurazione del modulo ( $cf[<modulo>]['pages'] );
-- fra più pubblicazioni attive dello stesso oggetto sullo stesso sito vince la prima nell'ordine ( ORDER BY ordine IS
-- NULL, ordine, id ); sulle tabelle che generano pagine le stesse colonne sono deprecate e restano per i moduli legacy
-- di oldstable ( schema canonico, punto 6e, 22/10/2026 )
--
-- NOTA l'albero delle pagine ( id_genitore sull'entità ) è lo stesso su tutti i siti, per scelta: un nodo compare su un
-- sito se è pubblicato lì, e se il suo genitore non lo è si aggancia alla id_pagina dell'entità, altrimenti non compare
--
-- NOTA spazio entra per il modulo dei banner nuovo, che ne fisserà i dettagli ( schema canonico, riga 140, 26/10/2026 )
--
CREATE TABLE IF NOT EXISTS `pubblicazioni` (                     --
  `id` bigint(20) NOT NULL,                                      -- chiave primaria
  `id_tipologia` bigint(20) DEFAULT NULL,                        -- stato della pubblicazione ( bozza, pubblicato, in evidenza, anteprima )
  `ordine` int(11) DEFAULT NULL,                                 -- ordine fra le pubblicazioni dello stesso oggetto: vince la prima
  `id_pagina` bigint(20) DEFAULT NULL,                           -- pagina pubblicata, o pagina dove appare il banner o il popup
  `id_popup` bigint(20) DEFAULT NULL,                            -- pubblicazione del popup
  `id_banner` bigint(20) DEFAULT NULL,                           -- pubblicazione del banner
  `spazio` char(128) DEFAULT NULL,                               -- id HTML dello spazio in cui appare il banner, NULL = qualunque
  `id_prodotto` bigint(20) DEFAULT NULL,                         -- pubblicazione del prodotto
  `id_articolo` bigint(20) DEFAULT NULL,                         -- pubblicazione dell'articolo
  `id_categoria_prodotti` bigint(20) DEFAULT NULL,               -- pubblicazione della categoria di prodotti
  `id_marchio` bigint(20) DEFAULT NULL,                          -- pubblicazione del marchio
  `id_categoria_marchi` bigint(20) DEFAULT NULL,                 -- pubblicazione della categoria di marchi
  `id_notizia` bigint(20) DEFAULT NULL,                          -- pubblicazione della notizia
  `id_categoria_notizie` bigint(20) DEFAULT NULL,                -- pubblicazione della categoria di notizie
  `id_annuncio` bigint(20) DEFAULT NULL,                         -- pubblicazione dell'annuncio
  `id_categoria_annunci` bigint(20) DEFAULT NULL,                -- pubblicazione della categoria di annunci
  `id_risorsa` bigint(20) DEFAULT NULL,                          -- pubblicazione della risorsa
  `id_categoria_risorse` bigint(20) DEFAULT NULL,                -- pubblicazione della categoria di risorse
  `id_progetto` bigint(20) DEFAULT NULL,                         -- pubblicazione del progetto
  `id_categoria_progetti` bigint(20) DEFAULT NULL,               -- pubblicazione della categoria di progetti
  `note` text DEFAULT NULL,                                      -- note sulla pubblicazione
  `id_sito` bigint(20) DEFAULT NULL,                             -- sito della configurazione su cui vale la pubblicazione, NULL = tutti
  `template` char(255) DEFAULT NULL,                             -- template con cui si mostra l'oggetto su questo sito
  `schema_html` char(128) DEFAULT NULL,                          -- schema HTML del template
  `tema_css` char(128) DEFAULT NULL,                             -- tema CSS del template
  `se_sitemap` tinyint(1) DEFAULT NULL,                          -- l'oggetto va nella sitemap del sito
  `se_cacheable` tinyint(1) DEFAULT NULL,                        -- la pagina dell'oggetto si puo' mettere in cache
  `timestamp_inizio` int(11) DEFAULT NULL,                       -- inizio della finestra di pubblicazione, NULL = da sempre
  `timestamp_fine` int(11) DEFAULT NULL,                         -- fine della finestra di pubblicazione, NULL = per sempre
  `id_account_inserimento` bigint(20) DEFAULT NULL,              -- account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                  -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,            -- account che ha aggiornato la riga per ultimo
  `timestamp_aggiornamento` int(11) DEFAULT NULL                 -- timestamp dell'ultimo aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                            --

-- | 010000028600

-- ranking
-- tipologia: tabella assistita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene le fasce in cui si dividono le anagrafiche per tipo di rapporto
--
-- le fasce ( p.es. PLATINUM, GOLD, SILVER, BRONZE ) in cui si dividono le anagrafiche di un certo tipo di rapporto:
-- clienti, fornitori, produttori, corrieri, collaboratori, partner; l'anagrafica ha la sua fascia in anagrafica.id_ranking.
-- A ogni fascia si legano determinate caratteristiche ( p.es. lo SLA per i clienti, i benefit per i collaboratori ).
--
-- NOTA: i flag se_* dicono a quali tipi di rapporto si applica la fascia, con gli stessi nomi dei flag di
-- categorie_anagrafica, e servono a far comparire nella tendina di ogni scheda solo le fasce di quel rapporto; una fascia
-- puo' averne piu' d'uno. Lead e prospect usano le fasce dei clienti ( se_cliente ), cosi' quando diventano clienti si
-- portano dietro la loro fascia. Il ranking di un progetto e' quello del suo cliente ( progetti_view ).
CREATE TABLE IF NOT EXISTS `ranking` (                            --
  `id` bigint(20) NOT NULL,                                       -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                  -- ordine delle fasce, dalla piu' alta
  `nome` char(255) DEFAULT NULL,                                  -- nome della fascia
  `note` text DEFAULT NULL,                                       -- note sulla fascia ( p.es. le caratteristiche che porta )
  `se_cliente` tinyint(1) DEFAULT NULL,                           -- fascia per i clienti, e per lead e prospect
  `se_fornitore` tinyint(1) DEFAULT NULL,                         -- fascia per i fornitori
  `se_produttore` tinyint(1) DEFAULT NULL,                        -- fascia per i produttori
  `se_corriere` tinyint(1) DEFAULT NULL,                          -- fascia per i corrieri
  `se_collaboratore` tinyint(1) DEFAULT NULL,                     -- fascia per i collaboratori
  `se_partner` tinyint(1) DEFAULT NULL,                           -- fascia per i partner
  `id_account_inserimento` bigint(20) DEFAULT NULL,               -- account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                   -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,             -- account che ha aggiornato la riga per ultimo
  `timestamp_aggiornamento` int(11) DEFAULT NULL                  -- timestamp dell'ultimo aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                             --

-- | 010000028900

-- recensioni
-- tipologia: tabella gestita
-- rango: tabella secondaria
-- struttura: tabella base
-- funzione: contiene le recensioni degli oggetti che generano pagine
--
-- questa tabella contiene le recensioni lasciate sugli oggetti che generano una pagina: le pagine, le entita' pubblicabili
-- ( prodotti, articoli, marchi, risorse, notizie, annunci, progetti ) e le loro categorie; ha una colonna per ognuno di
-- questi oggetti e ogni riga ne valorizza una sola. La recensione appartiene al suo oggetto e muore con lui. Il framework
-- aggiunge alla pagina di un oggetto le sue recensioni approvate nella lingua corrente ( aggiungiRecensioni(), chiamata
-- dal runlevel 420 del modulo pagine ).
--
-- NOTA l'autore si salva sempre: quando la recensione la scrive un utente riconosciuto, id_account va valorizzato con il
-- suo account ( autore resta il nome con cui la recensione viene pubblicata ); le recensioni importate o inserite a mano
-- per conto di altri hanno solo autore. La scala di valutazione non e' fissata dal framework.
CREATE TABLE IF NOT EXISTS `recensioni` (                         --
  `id` bigint(20) NOT NULL,                                       -- chiave primaria
  `id_account` bigint(20) DEFAULT NULL,                           -- chiave esterna per l'account dell'autore
  `id_annuncio` bigint(20) DEFAULT NULL,                          -- chiave esterna per l'annuncio recensito
  `id_prodotto` bigint(20) DEFAULT NULL,                          -- chiave esterna per il prodotto recensito
  `id_articolo` bigint(20) DEFAULT NULL,                          -- chiave esterna per l'articolo recensito
  `id_lingua` bigint(20) DEFAULT NULL,                            -- chiave esterna per la lingua della recensione
  `id_progetto` bigint(20) DEFAULT NULL,                          -- chiave esterna per il progetto recensito
  `id_pagina` bigint(20) DEFAULT NULL,                            -- chiave esterna per la pagina recensita
  `id_categoria_prodotti` bigint(20) DEFAULT NULL,                -- chiave esterna per la categoria prodotti recensita
  `id_marchio` bigint(20) DEFAULT NULL,                           -- chiave esterna per il marchio recensito
  `id_categoria_marchi` bigint(20) DEFAULT NULL,                  -- chiave esterna per la categoria di marchi recensita
  `id_risorsa` bigint(20) DEFAULT NULL,                           -- chiave esterna per la risorsa recensita
  `id_categoria_risorse` bigint(20) DEFAULT NULL,                 -- chiave esterna per la categoria risorse recensita
  `id_notizia` bigint(20) DEFAULT NULL,                           -- chiave esterna per la notizia recensita
  `id_categoria_notizie` bigint(20) DEFAULT NULL,                 -- chiave esterna per la categoria notizie recensita
  `id_categoria_annunci` bigint(20) DEFAULT NULL,                 -- chiave esterna per la categoria annunci recensita
  `id_categoria_progetti` bigint(20) DEFAULT NULL,                -- chiave esterna per la categoria progetti recensita
  `autore` char(128) DEFAULT NULL,                                -- nome dell'autore, come viene pubblicato
  `valutazione` int(11) DEFAULT NULL,                             -- voto dato dall'autore
  `titolo` char(255) DEFAULT NULL,                                -- titolo della recensione
  `testo` text DEFAULT NULL,                                      -- testo della recensione
  `se_approvata` tinyint(1) DEFAULT NULL,                         -- recensione approvata, e quindi pubblicata
  `data` date DEFAULT NULL,                                       -- data della recensione
  `id_account_inserimento` bigint(20) DEFAULT NULL,               -- account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                   -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,             -- account che ha aggiornato la riga per ultimo
  `timestamp_aggiornamento` int(11) DEFAULT NULL                  -- timestamp dell'ultimo aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                             --

-- | 010000029000

-- redirect
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene i redirect HTTP dei siti del deploy
-- entità: questa tabella corrisponde all'entità redirect
--
-- questa tabella contiene i redirect HTTP: quando la richiesta arriva a un percorso che corrisponde alla sorgente di
-- un redirect del sito corrente, il framework risponde col codice di stato HTTP indicato e manda alla destinazione,
-- prima di caricare qualsiasi pagina ( runlevel 130 e 135 ). Ai redirect della tabella si sommano quelli del file
-- etc/redirect.csv, che ha le stesse colonne; per il funzionamento si vedano il codice e i commenti dei file
-- _src/_config/_130.redirect.php e _src/_config/_135.redirect.php
--
-- NOTA la sorgente e' il percorso della richiesta al netto della query string, relativo e con la barra iniziale
-- ( /vecchia/pagina.html ), e il confronto e' esatto: una sorgente con il dominio o con la query string non scatta
-- mai; la destinazione puo' essere relativa o assoluta. Con se_query_string la query string della richiesta viene
-- riportata sulla destinazione. id_sito e' l'ID di un sito della configurazione ( $cf['sites'] ), non di una tabella,
-- quindi non ha chiave esterna; NULL vuol dire tutti i siti, come per le pubblicazioni, e a parita' di sorgente il
-- redirect del sito corrente vince su quello senza sito.
CREATE TABLE IF NOT EXISTS `redirect` (                       --
  `id` bigint(20) NOT NULL,                                      -- chiave primaria
  `id_sito` bigint(20) DEFAULT NULL,                             -- ID del sito del redirect ( NULL per tutti i siti )
  `codice_stato_http` int(11) DEFAULT NULL,                   -- codice di stato HTTP della risposta ( 301, 302… )
  `sorgente` char(255) DEFAULT NULL,                          -- percorso che fa scattare il redirect, senza query string
  `destinazione` char(255) DEFAULT NULL,                      -- URL verso cui si manda la richiesta, relativo o assoluto
  `se_query_string` tinyint(1) DEFAULT NULL,                  -- riporta la query string della richiesta sulla destinazione
  `id_account_inserimento` bigint(20) DEFAULT NULL,              -- chiave esterna per l'account che ha inserito il redirect
  `timestamp_inserimento` int(11) DEFAULT NULL,               -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,            -- chiave esterna per l'account che ha aggiornato il redirect
  `timestamp_aggiornamento` int(11) DEFAULT NULL              -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000029460

-- redirect_azioni
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene i redirect azioni
--
CREATE TABLE IF NOT EXISTS `redirect_azioni` (
  `id` bigint(20) NOT NULL ,
  `id_redirect` bigint(20) DEFAULT NULL,
  `referral` text DEFAULT NULL,
  `azione` enum('redirect') DEFAULT NULL,
  `timestamp_azione` int(11) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000029800

-- regimi
-- tipologia: tabella standard
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene i regimi fiscali della fattura elettronica
--
-- i regimi fiscali, ognuno col codice RegimeFiscale ( RF01 - RF20 ) che la fattura elettronica scrive nei dati del
-- cedente; li cita un'anagrafica in anagrafica.id_regime, e ne fanno la tendina i form dell'anagrafica.
--
-- NOTA: la riga 1 privato non e' un regime fiscale e non ha codice_sdi: e' il valore che i form legacy, dove la tendina
-- e' obbligatoria, fanno scegliere per un'anagrafica senza partita IVA; come cedente in fattura vale quanto un regime
-- vuoto. Per questo codice_sdi ammette NULL, ma e' unico. L'elenco lo carica il 050 con id fissi, e gli id non si
-- cambiano. Quando escono nuove specifiche della fattura elettronica l'elenco va ricontrollato e aggiornato con una patch.
CREATE TABLE IF NOT EXISTS `regimi` (                           --
  `id` bigint(20) NOT NULL,                                       -- chiave primaria
  `nome` char(255) NOT NULL,                                      -- nome del regime fiscale
  `codice_sdi` char(32) DEFAULT NULL                              -- codice RegimeFiscale della fattura elettronica
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                             --

-- | 010000030200

-- regioni
-- tipologia: tabella standard
-- rango: tabella secondaria
-- struttura: tabella base
-- funzione: contiene le regioni
--
-- le regioni, livello della geografia ( continenti, stati, regioni, provincie, comuni, indirizzi ) fra lo stato che
-- le contiene e le provincie che contengono, per qualsiasi stato. Ogni livello è secondario rispetto a quello che lo
-- contiene: una regione non ha senso senza il suo stato, quindi uno stato che ha delle regioni non si può cancellare.
-- I file di base non popolano la geografia, la carica un'importazione; dentro l'Italia la regione si identifica col
-- codice ISTAT.
-- una regione soppressa o fusa non si cancella: si archivia con data_archiviazione e note_archiviazione e punta col
-- id_successore alla regione che ne ha preso il posto. I valori li scrive l'importazione della geografia; i
-- riferimenti vivi si spostano sul successore, quelli di storia no.
-- NOTA codice_istat è un codice esterno e mantiene il suo formato; le regioni estere di solito non lo hanno
CREATE TABLE IF NOT EXISTS `regioni` (                        --
  `id` bigint(20) NOT NULL,                                   -- chiave primaria
  `nome` char(255) DEFAULT NULL,                              -- nome della regione
  `id_stato` bigint(20) DEFAULT NULL,                         -- stato che contiene la regione
  `id_successore` bigint(20) DEFAULT NULL,                    -- regione che ha preso il posto di questa dopo l'archiviazione
  `codice_istat` char(2) DEFAULT NULL,                        -- codice ISTAT della regione
  `url_riferimento` char(255) DEFAULT NULL,                   -- URL di riferimento della regione
  `note` text DEFAULT NULL,                                    -- note sulla regione
  `data_archiviazione` date DEFAULT NULL,                      -- data di archiviazione della regione
  `note_archiviazione` text DEFAULT NULL                       -- note sull'archiviazione della regione
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000030300

-- relazioni_anagrafica
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: mette in relazione due anagrafiche, con il ruolo che le lega
--
-- questa tabella collega due anagrafiche col ruolo che le lega ( genitore, fratello, tutore, coniuge, collega,
-- titolare, socio, dipendente... ); i ruoli proponibili sono quelli con ruoli_anagrafica.se_relazioni
--
-- NOTA la relazione ha un verso: id_anagrafica e' il <ruolo> di id_anagrafica_collegata ( il genitore a sinistra,
-- il figlio a destra ); si registra una volta sola e si legge nei due versi ( _210.auth.php ), quindi i ruoli
-- simmetrici ( fratello, coniuge, collega ) non si duplicano a versi invertiti; le note precisano il ruolo nel
-- caso specifico ( decisione del 26/10/2026 )
--
CREATE TABLE IF NOT EXISTS `relazioni_anagrafica` (            --
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                -- ordine di visualizzazione
  `id_anagrafica` bigint(20) DEFAULT NULL,                      -- chiave esterna per l'anagrafica che ha il ruolo
  `id_anagrafica_collegata` bigint(20) DEFAULT NULL,            -- chiave esterna per l'anagrafica rispetto a cui lo ha
  `id_ruolo` bigint(20) DEFAULT NULL,                           -- chiave esterna per il ruolo ( ruoli_anagrafica )
  `note` text DEFAULT NULL,                                     -- note che precisano il ruolo
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha aggiornato la riga
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                           --

-- | 010000030320

-- relazioni_articoli
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: collega un articolo a un altro articolo o a un prodotto, con il ruolo che li lega
--
-- questa tabella collega un articolo a un articolo o a un prodotto col ruolo che li lega ( il prodotto di bundle
-- di cui l'articolo fa parte, il modello dell'articolo, l'accessorio, il consumabile, il suggerito... ); i ruoli
-- proponibili sono quelli con ruoli_articoli.se_relazioni
--
-- NOTA la relazione ha un verso, ed e' il contrario di quello delle altre relazioni_*: il collegato e' il <ruolo>
-- dell'articolo ( il prodotto collegato e' il bundle, o il modello, di id_articolo ), perche' quando il collegato
-- e' un prodotto a sinistra sta per forza l'articolo; ogni riga ha un solo estremo collegato, l'articolo oppure il
-- prodotto, e ciascuno ha la sua chiave unica; le note precisano il ruolo nel caso specifico ( decisione del
-- 26/10/2026 )
--
CREATE TABLE IF NOT EXISTS `relazioni_articoli` (              --
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                -- ordine di visualizzazione
  `id_articolo` bigint(20) DEFAULT NULL,                        -- chiave esterna per l'articolo
  `id_articolo_collegato` bigint(20) DEFAULT NULL,              -- chiave esterna per l'articolo collegato, se il collegato e' un articolo
  `id_prodotto_collegato` bigint(20) DEFAULT NULL,              -- chiave esterna per il prodotto collegato, se il collegato e' un prodotto
  `id_ruolo` bigint(20) DEFAULT NULL,                           -- chiave esterna per il ruolo del collegato ( ruoli_articoli )
  `note` text DEFAULT NULL,                                     -- note che precisano il ruolo
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha aggiornato la riga
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                           --

-- | 010000030350

-- relazioni_categorie_progetti
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: mette in relazione due categorie progetti, con il ruolo che le lega
--
-- questa tabella collega due categorie progetti col ruolo che le lega; l'uso tipico e' fra discipline, per dire
-- in quali altre discipline si puo' recuperare una lezione persa ( ruolo accetta recuperi da ); i ruoli proponibili
-- sono quelli con ruoli_categorie_progetti.se_relazioni, e le loro qualita' sono gli altri flag ( se_recuperi )
--
-- NOTA la relazione ha un verso: id_categoria e' il <ruolo> di id_categoria_collegata ( la disciplina che accetta
-- i recuperi a sinistra, quella da cui vengono a destra ); si registra una volta sola, e chi la legge decide se
-- leggerla anche nell'altro verso; le note precisano il ruolo nel caso specifico ( decisione del 26/10/2026 )
--
CREATE TABLE IF NOT EXISTS `relazioni_categorie_progetti` (    --
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                -- ordine di visualizzazione
  `id_categoria` bigint(20) DEFAULT NULL,                       -- chiave esterna per la categoria che ha il ruolo
  `id_categoria_collegata` bigint(20) DEFAULT NULL,             -- chiave esterna per la categoria rispetto a cui lo ha
  `id_ruolo` bigint(20) DEFAULT NULL,                           -- chiave esterna per il ruolo ( ruoli_categorie_progetti )
  `note` text DEFAULT NULL,                                     -- note che precisano il ruolo
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha aggiornato la riga
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                           --

-- | 010000030400

-- relazioni_documenti
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: mette in relazione due documenti, con il ruolo che li lega
--
-- questa tabella collega due documenti col ruolo che li lega ( il DDT che evade un ordine, la missione di un
-- ordine, la fattura collegata... ); i ruoli proponibili sono quelli con ruoli_documenti.se_relazioni;
-- documenti_view ne ricava i documenti antecedenti e successivi
--
-- NOTA la relazione ha un verso: id_documento e' il <ruolo> di id_documento_collegato ( il DDT a sinistra e'
-- l'evasione dell'ordine a destra ), quindi il documento derivato sta a sinistra e quello da cui deriva a destra;
-- si registra una volta sola e si legge nei due versi; le note precisano il ruolo nel caso specifico ( decisione
-- del 26/10/2026 )
--
CREATE TABLE IF NOT EXISTS `relazioni_documenti` (              --
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                -- ordine di visualizzazione
  `id_documento` bigint(20) DEFAULT NULL,                       -- chiave esterna per il documento che ha il ruolo
  `id_documento_collegato` bigint(20) DEFAULT NULL,             -- chiave esterna per il documento rispetto a cui lo ha
  `id_ruolo` bigint(20) DEFAULT NULL,                           -- chiave esterna per il ruolo ( ruoli_documenti )
  `note` text DEFAULT NULL,                                     -- note che precisano il ruolo
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha aggiornato la riga
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                           --

-- | 010000030410

-- relazioni_documenti_articoli
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: mette in relazione due righe di documento, con il ruolo che le lega
--
-- questa tabella collega due righe di documento col ruolo che le lega ( la riga del DDT che evade la riga
-- dell'ordine, la riga della fattura collegata... ), con i ruoli di ruoli_documenti; la fattura elettronica la
-- legge per riferire le righe ai documenti collegati
--
-- NOTA la relazione ha il verso di relazioni_documenti: id_documenti_articolo e' il <ruolo> di
-- id_documenti_articolo_collegato, la riga derivata a sinistra e quella da cui deriva a destra; si registra una
-- volta sola e si legge nei due versi; le note precisano il ruolo nel caso specifico ( decisione del 26/10/2026 )
--
CREATE TABLE IF NOT EXISTS `relazioni_documenti_articoli` (     --
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                -- ordine di visualizzazione
  `id_documenti_articolo` bigint(20) DEFAULT NULL,              -- chiave esterna per la riga che ha il ruolo
  `id_documenti_articolo_collegato` bigint(20) DEFAULT NULL,    -- chiave esterna per la riga rispetto a cui lo ha
  `id_ruolo` bigint(20) DEFAULT NULL,                           -- chiave esterna per il ruolo ( ruoli_documenti )
  `note` text DEFAULT NULL,                                     -- note che precisano il ruolo
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha aggiornato la riga
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                           --

-- | 010000030440

-- relazioni_pagamenti
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: mette in relazione due pagamenti, con il ruolo che li lega
--
-- questa tabella collega due movimenti autonomi, ognuno valido da solo, col ruolo che li lega ( lo storno di un
-- incasso, la contropartita intercompany, la compensazione, la ripresentazione di un insoluto... ); i ruoli
-- proponibili sono quelli con ruoli_pagamenti.se_relazioni
--
-- NOTA la relazione ha un verso: id_pagamento e' il <ruolo> di id_pagamento_collegato ( il rimborso a sinistra e'
-- lo storno dell'incasso a destra ); si registra una volta sola e si legge nei due versi; le note precisano il ruolo
-- nel caso specifico; le righe che nascono da un'altra e muoiono con lei ( rate, catture, differenze cambio ) non
-- stanno qui ma in pagamenti.id_genitore ( decisioni del 21/10 e del 27/10/2026 )
--
CREATE TABLE IF NOT EXISTS `relazioni_pagamenti` (               --
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                -- ordine di visualizzazione
  `id_pagamento` bigint(20) DEFAULT NULL,                       -- chiave esterna per il pagamento che ha il ruolo
  `id_pagamento_collegato` bigint(20) DEFAULT NULL,             -- chiave esterna per il pagamento rispetto a cui lo ha
  `id_ruolo` bigint(20) DEFAULT NULL,                           -- chiave esterna per il ruolo ( ruoli_pagamenti )
  `note` text DEFAULT NULL,                                     -- note che precisano il ruolo
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha aggiornato la riga
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                           --

-- | 010000030470

-- relazioni_prodotti
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: collega un prodotto a un altro prodotto o a un articolo, con il ruolo che li lega
--
-- questa tabella collega un prodotto a un prodotto o a un articolo col ruolo che li lega ( l'accessorio, il
-- suggerito, il consumabile... ); le pagine prodotto ne elencano accessori e suggeriti; i ruoli proponibili sono
-- quelli con ruoli_prodotti.se_relazioni
--
-- NOTA la relazione ha il verso di relazioni_articoli, il contrario delle altre relazioni_*: il collegato e' il
-- <ruolo> del prodotto ( il prodotto collegato e' l'accessorio, o il suggerito, di id_prodotto ), perche' quando
-- il collegato e' un articolo a sinistra sta per forza il prodotto; ogni riga ha un solo estremo collegato, il
-- prodotto oppure l'articolo, e ciascuno ha la sua chiave unica; le note precisano il ruolo nel caso specifico
-- ( decisione del 26/10/2026 )
--
CREATE TABLE IF NOT EXISTS `relazioni_prodotti` (               --
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                -- ordine di visualizzazione
  `id_prodotto` bigint(20) DEFAULT NULL,                        -- chiave esterna per il prodotto
  `id_prodotto_collegato` bigint(20) DEFAULT NULL,              -- chiave esterna per il prodotto collegato, se il collegato e' un prodotto
  `id_articolo_collegato` bigint(20) DEFAULT NULL,              -- chiave esterna per l'articolo collegato, se il collegato e' un articolo
  `id_ruolo` bigint(20) DEFAULT NULL,                           -- chiave esterna per il ruolo del collegato ( ruoli_prodotti )
  `note` text DEFAULT NULL,                                     -- note che precisano il ruolo
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha aggiornato la riga
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                           --

-- | 010000030490

-- relazioni_progetti
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: mette in relazione due progetti, con il ruolo che li lega
--
-- questa tabella collega due progetti col ruolo che li lega ( il corso che prosegue un altro, il bundle dei
-- corsi che lo compongono, l'attesa... ); i ruoli proponibili sono quelli con ruoli_progetti.se_relazioni
--
-- NOTA la relazione ha un verso: id_progetto e' il <ruolo> di id_progetto_collegato ( il corso nuovo a sinistra e'
-- il proseguimento del corso vecchio a destra, il bundle a sinistra e' il bundle del corso a destra ); si registra
-- una volta sola e si legge nei due versi; senza ruolo la chiave unica non protegge ( due NULL non sono uguali ),
-- quindi il ruolo va sempre scritto; le note precisano il ruolo nel caso specifico ( decisione del 26/10/2026 )
--
CREATE TABLE IF NOT EXISTS `relazioni_progetti` (               --
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                -- ordine di visualizzazione
  `id_progetto` bigint(20) DEFAULT NULL,                        -- chiave esterna per il progetto che ha il ruolo
  `id_progetto_collegato` bigint(20) DEFAULT NULL,              -- chiave esterna per il progetto rispetto a cui lo ha
  `id_ruolo` bigint(20) DEFAULT NULL,                           -- chiave esterna per il ruolo ( ruoli_progetti )
  `note` text DEFAULT NULL,                                     -- note che precisano il ruolo
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha aggiornato la riga
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                           --

-- | 010000030500

-- relazioni_software
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: mette in relazione due software, con il ruolo che li lega
--
-- questa tabella collega due software col ruolo che li lega ( l'aggiornamento di un altro software, il plugin di
-- un altro software... ); i ruoli proponibili sono quelli con ruoli_software.se_relazioni
--
-- NOTA la relazione ha un verso: id_software e' il <ruolo> di id_software_collegato ( il plugin a sinistra e' il
-- plugin del software a destra ); si registra una volta sola e si legge nei due versi; le note precisano il ruolo
-- nel caso specifico ( decisione del 26/10/2026 )
--
CREATE TABLE IF NOT EXISTS `relazioni_software` (               --
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                -- ordine di visualizzazione
  `id_software` bigint(20) DEFAULT NULL,                        -- chiave esterna per il software che ha il ruolo
  `id_software_collegato` bigint(20) DEFAULT NULL,              -- chiave esterna per il software rispetto a cui lo ha
  `id_ruolo` bigint(20) DEFAULT NULL,                           -- chiave esterna per il ruolo ( ruoli_software )
  `note` text DEFAULT NULL,                                     -- note che precisano il ruolo
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha aggiornato la riga
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                           --

-- | 010000030800

-- reparti
-- tipologia: tabella assistita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene i reparti di cassa, ognuno con la sua aliquota IVA
--
-- i reparti sono i reparti di cassa, cioè i tasti del registratore telematico, e insieme le divisioni contabili
-- delle vendite: l'aliquota IVA del reparto decide l'IVA delle righe ( articoli, righe dei documenti, prezzi ) che
-- lo usano, quindi un reparto senza aliquota non ha senso e un'aliquota usata da un reparto non si cancella ( si
-- archivia ). L'id del reparto è il numero del reparto sul registratore, per questo i file di base lo popolano a id
-- fissi; i reparti con un'aliquota archiviata non vengono proposti nelle tendine.
-- NOTA id_iva è obbligatoria per l'applicazione ma DEFAULT NULL come ogni id_*; la chiave esterna NO ACTION impedisce
-- di cancellare un'aliquota usata da un reparto
-- NOTA id_settore è il settore ATECO dell'attività a cui il reparto si riferisce, per chi ne esercita più di una;
-- oggi non è valorizzato su nessun deploy
CREATE TABLE IF NOT EXISTS `reparti` (                        --
  `id` bigint(20) NOT NULL,                                   -- chiave primaria
  `nome` char(255) DEFAULT NULL,                              -- nome del reparto
  `id_iva` bigint(20) DEFAULT NULL,                           -- chiave esterna per l'aliquota IVA del reparto ( obbligatoria )
  `id_settore` bigint(20) DEFAULT NULL,                       -- chiave esterna per il settore ATECO del reparto
  `note` text DEFAULT NULL,                                   -- note sul reparto
  `id_account_inserimento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,               -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,         -- chiave esterna per l'account che ha aggiornato la riga
  `timestamp_aggiornamento` int(11) DEFAULT NULL              -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000031550

-- rinnovi_documenti_articoli
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: mette in relazione rinnovi e documenti articoli
--
CREATE TABLE IF NOT EXISTS `rinnovi_documenti_articoli` (
`id` bigint(20) NOT NULL,
  `id_rinnovo` bigint(20) DEFAULT NULL,
  `id_documenti_articolo` bigint(20) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000032000

-- risorse
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene le risorse documentali, cioè i documenti d'archivio catalogati e consultabili dal sito
--
-- una risorsa è un documento, o una parte di documento, di qualsiasi natura ( testo, audio, multimedia ), catalogato
-- con un suo codice e identificabile singolarmente: un articolo di giornale, un saggio, una registrazione. Porta la
-- testata su cui è uscito ( id_testata ) e la data di pubblicazione originale in tre colonne, perché di un documento
-- storico spesso si conoscono solo l'anno o il mese; non va confusa con la finestra di uscita sul sito, che sta in
-- pubblicazioni ( pubblicazioni.id_risorsa ). Il testo e gli altri contenuti stanno in contenuti e nei media, le
-- categorie in risorse_categorie. L'accesso a una risorsa si può vendere: id_prodotto e id_articolo dicono con cosa
-- si compra, come per progetti e tipologie_contratti, e chi l'ha comprata sta in risorse_account. Come le altre
-- entità che generano pagine porta il blocco web ( template, schema_html, tema_css, se_sitemap, se_cacheable, id_sito,
-- id_pagina ) e si appende sotto ciascuna delle sue categorie.
--
-- NOTA il blocco web è deprecato su questa tabella ( punto 6e, 22/10/2026 ): sta sulle pubblicazioni, una per sito, e
-- qui resta per i moduli legacy di oldstable; il codice latest legge quello di pubblicazioni
-- NOTA id_pagina è la pagina sotto cui si appende la risorsa senza categoria; id_sito non ha chiave esterna perché
-- i siti sono definiti nella configurazione, non nel database
-- NOTA id_prodotto vuol dire che l'accesso lo dà qualunque articolo del prodotto ( p.es. le varianti di durata ),
-- id_articolo che lo dà solo quell'articolo; il modulo legacy 3500.risorse lo legge ancora dal metadato
-- risorse|acquisto dell'articolo, e il modulo risorse latest leggerà queste colonne
--
CREATE TABLE IF NOT EXISTS `risorse` (                            --
  `id` bigint(20) NOT NULL,                                       -- chiave primaria
  `id_tipologia` bigint(20) DEFAULT NULL,                         -- chiave esterna per la tipologia della risorsa
  `codice` char(32) DEFAULT NULL,                                 -- codice di catalogo della risorsa
  `nome` char(255) DEFAULT NULL,                                  -- titolo della risorsa
  `id_prodotto` bigint(20) DEFAULT NULL,                          -- chiave esterna per il prodotto i cui articoli danno accesso alla risorsa
  `id_articolo` bigint(20) DEFAULT NULL,                          -- chiave esterna per l'articolo con cui si compra l'accesso alla risorsa
  `id_testata` bigint(20) DEFAULT NULL,                           -- chiave esterna per la testata su cui è uscita la risorsa
  `note` text DEFAULT NULL,                                       -- note sulla risorsa
  `giorno_pubblicazione` int(2) DEFAULT NULL,                     -- giorno della pubblicazione originale, se noto
  `mese_pubblicazione` int(2) DEFAULT NULL,                       -- mese della pubblicazione originale, se noto
  `anno_pubblicazione` int(4) DEFAULT NULL,                       -- anno della pubblicazione originale
  `template` char(255) DEFAULT NULL,                              -- template con cui si mostra la pagina della risorsa ( deprecato )
  `schema_html` char(128) DEFAULT NULL,                           -- schema HTML del template ( deprecato )
  `tema_css` char(128) DEFAULT NULL,                              -- tema CSS del template ( deprecato )
  `se_sitemap` tinyint(1) DEFAULT NULL,                           -- la pagina della risorsa va nella sitemap ( deprecato )
  `se_cacheable` tinyint(1) DEFAULT NULL,                         -- la pagina della risorsa si può mettere in cache ( deprecato )
  `id_sito` bigint(20) DEFAULT NULL,                              -- sito della configurazione a cui appartiene la pagina ( deprecato )
  `id_pagina` bigint(20) DEFAULT NULL,                            -- chiave esterna per la pagina genitore nell'albero del sito
  `data_archiviazione` date DEFAULT NULL,                         -- data di archiviazione
  `note_archiviazione` text DEFAULT NULL,                         -- note di archiviazione
  `id_account_inserimento` bigint(20) DEFAULT NULL,               -- account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                   -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,             -- account che ha aggiornato la riga per ultimo
  `timestamp_aggiornamento` int(11) DEFAULT NULL                  -- timestamp dell'ultimo aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                             --

-- | 010000032100

-- risorse_account
-- tipologia: tabella di supporto
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: dice quali account hanno accesso a quali risorse
--
-- questa tabella mette in relazione risorse e account: ogni riga e' un account che ha accesso a una risorsa. La scrive
-- il checkout quando si compra un articolo che da' accesso alla risorsa ( risorse.id_prodotto / risorse.id_articolo ),
-- e in quel caso id_carrelli_articoli dice da quale riga di carrello viene l'accesso, come per documenti_articoli;
-- un accesso dato a mano da un operatore la lascia vuota.
--
-- NOTA note e' deprecata ( punto 6, riga 159, 27/10/2026 ): la relazione non ha ruolo, e la nota la scrive solo il
-- checkout del modulo legacy 3500.risorse per annotare la provenienza; il modulo risorse latest scrive
-- id_carrelli_articoli e non la usa
--
CREATE TABLE IF NOT EXISTS `risorse_account` (                  --
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                -- ordine di visualizzazione
  `id_risorsa` bigint(20) DEFAULT NULL,                         -- chiave esterna per la risorsa
  `id_account` bigint(20) DEFAULT NULL,                         -- chiave esterna per l'account che ha accesso alla risorsa
  `id_carrelli_articoli` bigint(20) DEFAULT NULL,               -- chiave esterna per la riga di carrello da cui viene l'accesso
  `note` text DEFAULT NULL,                                     -- note sul collegamento ( deprecato )
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento della riga
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha aggiornato la riga
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento della riga
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                           --

-- | 010000032200

-- risorse_anagrafica
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: collega una risorsa alle anagrafiche che vi hanno un ruolo
--
-- questa tabella collega una risorsa alle anagrafiche che vi hanno avuto un ruolo ( autore, curatore, traduttore,
-- intervistato... ); i ruoli proponibili sono quelli con ruoli_anagrafica.se_risorse
--
-- NOTA la chiave unica e' ( id_risorsa, id_anagrafica, id_ruolo ): la stessa anagrafica puo' avere piu' ruoli;
-- le note precisano il ruolo nel caso specifico ( decisione del 20/10/2026 )
--
CREATE TABLE IF NOT EXISTS `risorse_anagrafica` (               --
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                -- ordine di visualizzazione
  `id_risorsa` bigint(20) DEFAULT NULL,                         -- chiave esterna per la risorsa
  `id_anagrafica` bigint(20) DEFAULT NULL,                      -- chiave esterna per l'anagrafica
  `id_ruolo` bigint(20) DEFAULT NULL,                           -- chiave esterna per il ruolo ( ruoli_anagrafica )
  `note` text DEFAULT NULL,                                     -- note che precisano il ruolo
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha aggiornato la riga
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                           --

-- | 010000032400

-- risorse_categorie
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: associa molti a molti le risorse alle categorie delle risorse
--
-- questa tabella contiene le associazioni molti a molti tra le risorse e le categorie_risorse, cioe' l'albero di
-- navigazione sotto cui si appendono le pagine delle risorse: una risorsa genera una pagina sotto ogni categoria a cui
-- appartiene; le categorie fanno parte della scheda della risorsa, quindi la chiave verso risorse si segue, mentre
-- quella verso categorie_risorse no; e' ricalcata su prodotti_categorie
--
-- NOTA la categoria principale di una risorsa e' la prima nell'ordine ( ORDER BY ordine, id ), ed e' quella sotto
-- cui sta la canonical della sua pagina
--
CREATE TABLE IF NOT EXISTS `risorse_categorie` (              --
  `id` bigint(20) NOT NULL,                                   -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                              -- ordine di visualizzazione, la prima e' la principale
  `id_risorsa` bigint(20) DEFAULT NULL,                       -- chiave esterna per la risorsa
  `id_categoria` bigint(20) DEFAULT NULL,                     -- chiave esterna per la categoria
  `id_account_inserimento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha inserito l'associazione
  `timestamp_inserimento` int(11) DEFAULT NULL,               -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,         -- chiave esterna per l'account che ha aggiornato l'associazione
  `timestamp_aggiornamento` int(11) DEFAULT NULL              -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000032500

-- risorse_organizzazioni
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: collega una risorsa ai nodi delle organizzazioni, con un ruolo
--
-- questa tabella collega una risorsa ai nodi di una struttura organizzata ( organizzazioni ) e dice cosa la risorsa
-- e' per il nodo ( prodotta, custodita, destinata... ) con un ruolo preso da ruoli_risorse; i ruoli proponibili sono
-- quelli con ruoli_risorse.se_organizzazioni ( punto 6d, 21/10/2026, e riga 160, 28/10/2026 )
--
-- NOTA la chiave unica e' ( id_risorsa, id_organizzazione, id_ruolo ): la stessa risorsa puo' stare nello stesso
-- nodo con piu' ruoli; le note precisano il ruolo nel caso specifico
--
CREATE TABLE IF NOT EXISTS `risorse_organizzazioni` (           --
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                -- ordine di visualizzazione
  `id_risorsa` bigint(20) DEFAULT NULL,                         -- chiave esterna per la risorsa
  `id_organizzazione` bigint(20) DEFAULT NULL,                  -- chiave esterna per il nodo dell'organizzazione
  `id_ruolo` bigint(20) DEFAULT NULL,                           -- chiave esterna per il ruolo ( ruoli_risorse )
  `note` text DEFAULT NULL,                                     -- note che precisano il ruolo
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha aggiornato la riga
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                           --

-- | 010000033000

-- ritenute
-- tipologia: tabella standard
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene i tipi di ritenuta della fattura elettronica
--
-- i tipi di ritenuta e di contributo previdenziale trattenuto, ognuno col codice TipoRitenuta ( RT01 - RT06 ) che la
-- fattura elettronica scrive nel blocco DatiRitenuta; li cita una ritenuta di un documento in documenti_ritenute, e ne
-- fanno la tendina i form dei dati fiscali dei documenti.
--
-- NOTA: l'elenco e' quello chiuso delle specifiche tecniche, e lo carica il 050 con id fissi e le descrizioni della
-- rappresentazione tabellare; gli id non si cambiano. Quando le specifiche cambiano si aggiorna con una patch, non a
-- mano. Le righe usate da un documento non si cancellano ( documenti_ritenute punta qui con NO ACTION ).
CREATE TABLE IF NOT EXISTS `ritenute` (                         --
  `id` bigint(20) NOT NULL,                                       -- chiave primaria
  `nome` char(255) NOT NULL,                                      -- nome del tipo di ritenuta
  `codice_sdi` char(32) NOT NULL                                  -- codice TipoRitenuta della fattura elettronica
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                             --

-- | 010000034000

-- ruoli_anagrafica
-- tipologia: tabella standard
-- rango: tabella secondaria
-- struttura: tabella ricorsiva
-- funzione: contiene i ruoli che le anagrafiche possono svolgere
--
-- questa tabella contiene i ruoli che un'anagrafica svolge rispetto a un altro oggetto ( titolare, dipendente, autore,
-- docente, proprietario, contraente... ); la leggono gli id_ruolo delle relazioni con l'anagrafica ( anagrafica_organizzazioni,
-- relazioni_anagrafica, notizie_anagrafica, risorse_anagrafica, progetti_anagrafica, contratti_anagrafica e le relazioni
-- degli immobili ); i flag dicono in quale relazione il ruolo e' proponibile, in quale tipologia di progetto, o una
-- qualita' del ruolo
--
-- NOTA: se_produzione e se_didattica sono sottoinsiemi di se_progetti per tipologia di progetto, gemelli dei flag di
-- tipologie_progetti: la tendina dei ruoli di un progetto filtra sul flag della sua tipologia ( decisione del 28/10/2026 );
-- se_proponente, se_contraente e se_sostituto sono qualita' del ruolo, non della relazione ( decisione del 22/10/2026 )
--
CREATE TABLE IF NOT EXISTS `ruoli_anagrafica` (
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                        -- chiave esterna per il ruolo genitore
  `nome` char(255) DEFAULT NULL,                                -- nome del ruolo
  `html_entity` char(8) DEFAULT NULL,                           -- entita' HTML che rappresenta il ruolo
  `font_awesome` char(16) DEFAULT NULL,                         -- classe Font Awesome dell'icona del ruolo
  `se_organizzazioni` tinyint(1) DEFAULT NULL,                  -- flag per i ruoli proponibili in anagrafica_organizzazioni
  `se_relazioni` tinyint(1) DEFAULT NULL,                       -- flag per i ruoli proponibili in relazioni_anagrafica
  `se_notizie` tinyint(1) DEFAULT NULL,                         -- flag per i ruoli proponibili in notizie_anagrafica
  `se_risorse` tinyint(1) DEFAULT NULL,                         -- flag per i ruoli proponibili in risorse_anagrafica
  `se_progetti` tinyint(1) DEFAULT NULL,                        -- flag per i ruoli proponibili in progetti_anagrafica
  `se_immobili` tinyint(1) DEFAULT NULL,                        -- flag per i ruoli proponibili nelle relazioni degli immobili
  `se_contratti` tinyint(1) DEFAULT NULL,                       -- flag per i ruoli proponibili in contratti_anagrafica
  `se_produzione` tinyint(1) DEFAULT NULL,                      -- flag per i ruoli dei progetti con tipologia se_produzione
  `se_didattica` tinyint(1) DEFAULT NULL,                       -- flag per i ruoli dei progetti con tipologia se_didattica
  `se_proponente` tinyint(1) DEFAULT NULL,                      -- flag per il ruolo di chi propone un contratto
  `se_contraente` tinyint(1) DEFAULT NULL,                      -- flag per il ruolo di chi sottoscrive un contratto
  `se_sostituto` tinyint(1) DEFAULT NULL                        -- flag per il ruolo di un sostituto ( p.es. docente sostituto )
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000034100

-- ruoli_articoli
-- tipologia: tabella standard
-- rango: tabella secondaria
-- struttura: tabella ricorsiva
-- funzione: contiene i ruoli con cui un articolo o un prodotto e' collegato a un articolo
--
-- questa tabella contiene i ruoli che il collegato svolge rispetto all'articolo ( prodotto, principale, suggerito,
-- accessorio, consumabile, bundle ); la legge relazioni_articoli.id_ruolo, e i ruoli proponibili sono quelli con
-- se_relazioni ( decisione del 26/10/2026 )
--
-- NOTA: i flag se_progetti, se_risorse, se_acquisto e se_rinnovo sono usciti dal canone il 28/10/2026: le loro
-- relazioni non ci sono piu' ( progetti_articoli, rinnovi_documenti_articoli ) o non sono mai esistite, e l'acquisto
-- passa da id_prodotto / id_articolo dell'oggetto venduto ( decisione del 27/10/2026 )
--
CREATE TABLE IF NOT EXISTS `ruoli_articoli` (
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                        -- chiave esterna per il ruolo genitore
  `nome` char(255) DEFAULT NULL,                                -- nome del ruolo
  `html_entity` char(8) DEFAULT NULL,                           -- entita' HTML che rappresenta il ruolo
  `font_awesome` char(16) DEFAULT NULL,                         -- classe Font Awesome dell'icona del ruolo
  `se_relazioni` tinyint(1) DEFAULT NULL                        -- flag per i ruoli proponibili in relazioni_articoli
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000034200

-- ruoli_audio
-- tipologia: tabella standard
-- rango: tabella secondaria
-- struttura: tabella ricorsiva
-- funzione: contiene i ruoli che un audio svolge rispetto all'oggetto a cui appartiene
--
-- questa tabella contiene i ruoli di un audio ( audio, commento... ); la legge audio.id_ruolo, e la tendina del
-- form audio di un oggetto propone i ruoli col flag se_<oggetto> di quell'oggetto: c'e' un flag per ogni chiave
-- oggetto di audio, nello stesso ordine ( decisione del 28/10/2026 ), compresi se_file, se_immagini e se_video
-- della matrice dei media ( decisione del 16/10/2026 )
--
CREATE TABLE IF NOT EXISTS `ruoli_audio` (
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                        -- chiave esterna per il ruolo genitore
  `nome` char(255) DEFAULT NULL,                                -- nome del ruolo
  `html_entity` char(8) DEFAULT NULL,                           -- entita' HTML che rappresenta il ruolo
  `font_awesome` char(16) DEFAULT NULL,                         -- classe Font Awesome dell'icona del ruolo
  `se_anagrafica` tinyint(1) DEFAULT NULL,                      -- flag per i ruoli proponibili negli audio dell'anagrafica
  `se_annunci` tinyint(1) DEFAULT NULL,                         -- flag per i ruoli proponibili negli audio degli annunci
  `se_prodotti` tinyint(1) DEFAULT NULL,                        -- flag per i ruoli proponibili negli audio dei prodotti
  `se_articoli` tinyint(1) DEFAULT NULL,                        -- flag per i ruoli proponibili negli audio degli articoli
  `se_indirizzi` tinyint(1) DEFAULT NULL,                       -- flag per i ruoli proponibili negli audio degli indirizzi
  `se_progetti` tinyint(1) DEFAULT NULL,                        -- flag per i ruoli proponibili negli audio dei progetti
  `se_immobili` tinyint(1) DEFAULT NULL,                        -- flag per i ruoli proponibili negli audio degli immobili
  `se_pagine` tinyint(1) DEFAULT NULL,                          -- flag per i ruoli proponibili negli audio delle pagine
  `se_file` tinyint(1) DEFAULT NULL,                            -- flag per i ruoli proponibili negli audio dei file
  `se_categorie_prodotti` tinyint(1) DEFAULT NULL,              -- flag per i ruoli proponibili negli audio delle categorie di prodotti
  `se_marchi` tinyint(1) DEFAULT NULL,                          -- flag per i ruoli proponibili negli audio dei marchi
  `se_categorie_marchi` tinyint(1) DEFAULT NULL,                -- flag per i ruoli proponibili negli audio delle categorie di marchi
  `se_risorse` tinyint(1) DEFAULT NULL,                         -- flag per i ruoli proponibili negli audio delle risorse
  `se_categorie_risorse` tinyint(1) DEFAULT NULL,               -- flag per i ruoli proponibili negli audio delle categorie di risorse
  `se_notizie` tinyint(1) DEFAULT NULL,                         -- flag per i ruoli proponibili negli audio delle notizie
  `se_categorie_notizie` tinyint(1) DEFAULT NULL,               -- flag per i ruoli proponibili negli audio delle categorie di notizie
  `se_categorie_annunci` tinyint(1) DEFAULT NULL,               -- flag per i ruoli proponibili negli audio delle categorie di annunci
  `se_categorie_progetti` tinyint(1) DEFAULT NULL,              -- flag per i ruoli proponibili negli audio delle categorie di progetti
  `se_edifici` tinyint(1) DEFAULT NULL,                         -- flag per i ruoli proponibili negli audio degli edifici
  `se_valutazioni` tinyint(1) DEFAULT NULL,                     -- flag per i ruoli proponibili negli audio delle valutazioni
  `se_video` tinyint(1) DEFAULT NULL,                           -- flag per i ruoli proponibili negli audio dei video
  `se_immagini` tinyint(1) DEFAULT NULL,                        -- flag per i ruoli proponibili negli audio delle immagini
  `se_vani` tinyint(1) DEFAULT NULL                             -- flag per i ruoli proponibili negli audio dei vani
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000034250

-- ruoli_categorie_progetti
-- tipologia: tabella standard
-- rango: tabella secondaria
-- struttura: tabella ricorsiva
-- funzione: contiene i ruoli che legano due categorie progetti
--
-- questa tabella contiene i ruoli con cui una categoria progetti e' collegata a un'altra ( accetta recuperi da... );
-- la legge relazioni_categorie_progetti.id_ruolo, e i ruoli proponibili sono quelli con se_relazioni; gli altri flag
-- sono qualita' del ruolo: se_recuperi dice che le lezioni perse in una disciplina si recuperano nell'altra
-- ( decisione del 28/10/2026 )
--
CREATE TABLE IF NOT EXISTS `ruoli_categorie_progetti` (
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                        -- chiave esterna per il ruolo genitore
  `nome` char(255) DEFAULT NULL,                                -- nome del ruolo
  `html_entity` char(8) DEFAULT NULL,                           -- entita' HTML che rappresenta il ruolo
  `font_awesome` char(16) DEFAULT NULL,                         -- classe Font Awesome dell'icona del ruolo
  `se_relazioni` tinyint(1) DEFAULT NULL,                       -- flag per i ruoli proponibili in relazioni_categorie_progetti
  `se_recuperi` tinyint(1) DEFAULT NULL                         -- flag per i ruoli che indicano dove si recuperano le lezioni
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000034272

-- ruoli_certificazioni
-- tipologia: tabella standard
-- rango: tabella secondaria
-- struttura: tabella ricorsiva
-- funzione: contiene i ruoli delle certificazioni nei progetti
--
-- questa tabella contiene i ruoli con cui una certificazione e' collegata a un progetto ( requisito obbligatorio,
-- requisito facoltativo, rilasciata ); la legge progetti_certificazioni.id_ruolo
--
CREATE TABLE IF NOT EXISTS `ruoli_certificazioni` (
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                        -- chiave esterna per il ruolo genitore
  `nome` char(255) DEFAULT NULL,                                -- nome del ruolo
  `html_entity` char(8) DEFAULT NULL,                           -- entita' HTML che rappresenta il ruolo
  `font_awesome` char(16) DEFAULT NULL                          -- classe Font Awesome dell'icona del ruolo
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000034280

-- ruoli_conversazioni
-- tipologia: tabella standard
-- rango: tabella secondaria
-- struttura: tabella ricorsiva
-- funzione: contiene i ruoli dei partecipanti alle conversazioni
--
-- questa tabella contiene i ruoli con cui un account partecipa a una conversazione ( spettatore, membro, moderatore,
-- amministratore, proprietario ); la legge conversazioni_account.id_ruolo
--
CREATE TABLE IF NOT EXISTS `ruoli_conversazioni` (
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                        -- chiave esterna per il ruolo genitore
  `nome` char(255) DEFAULT NULL,                                -- nome del ruolo
  `html_entity` char(8) DEFAULT NULL,                           -- entita' HTML che rappresenta il ruolo
  `font_awesome` char(16) DEFAULT NULL                          -- classe Font Awesome dell'icona del ruolo
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000034300

-- ruoli_documenti
-- tipologia: tabella standard
-- rango: tabella secondaria
-- struttura: tabella ricorsiva
-- funzione: contiene i ruoli che legano due documenti, o due righe di documento
--
-- questa tabella contiene i ruoli che il documento derivato svolge rispetto a quello da cui deriva ( conferma,
-- consuntivo, evasione, missione, fattura collegata, DDT collegato ); la leggono relazioni_documenti.id_ruolo e
-- relazioni_documenti_articoli.id_ruolo, e i ruoli proponibili sono quelli con se_relazioni e con
-- se_documenti_articoli rispettivamente; se_xml dice che il documento collegato va riportato nella fattura
-- elettronica ( DatiFattureCollegate, DatiDDT )
--
-- NOTA: gli id dei ruoli sono canonici e il codice li usa scritti a mano ( 3 evasione, 4 missione ); i flag
-- se_documenti, se_conferma, se_consuntivo e se_evasione sono usciti dal canone il 28/10/2026: il primo doppiava
-- se_relazioni, gli altri valevano solo per la riga omonima e nessuno li leggeva
--
CREATE TABLE IF NOT EXISTS `ruoli_documenti` (
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                        -- chiave esterna per il ruolo genitore
  `nome` char(255) DEFAULT NULL,                                -- nome del ruolo
  `html_entity` char(8) DEFAULT NULL,                           -- entita' HTML che rappresenta il ruolo
  `font_awesome` char(16) DEFAULT NULL,                         -- classe Font Awesome dell'icona del ruolo
  `se_xml` tinyint(1) DEFAULT NULL,                             -- flag per i ruoli il cui collegato va nella fattura elettronica
  `se_documenti_articoli` tinyint(1) DEFAULT NULL,              -- flag per i ruoli proponibili in relazioni_documenti_articoli
  `se_relazioni` tinyint(1) DEFAULT NULL                        -- flag per i ruoli proponibili in relazioni_documenti
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000034400

-- ruoli_file
-- tipologia: tabella standard
-- rango: tabella secondaria
-- struttura: tabella ricorsiva
-- funzione: contiene i ruoli che un file svolge rispetto all'oggetto a cui appartiene
--
-- questa tabella contiene i ruoli di un file ( allegato, brochure, scansione... ); la legge file.id_ruolo, e la tendina
-- del form file di un oggetto propone i ruoli col flag se_<oggetto> di quell'oggetto: c'e' un flag per ogni chiave
-- oggetto di file, nello stesso ordine ( decisione del 28/10/2026 ), compresi se_audio, se_immagini e se_video
-- della matrice dei media ( decisione del 16/10/2026 )
--
-- NOTA se_mail vale per le due colonne della coda di invio, file.id_mail_out e file.id_mail_sent: le due tabelle di
-- una coda sono lo stesso oggetto che si sposta, e il ruolo di un allegato non cambia quando la mail parte
-- ( decisione del 28/10/2026 )
--
CREATE TABLE IF NOT EXISTS `ruoli_file` (
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                        -- chiave esterna per il ruolo genitore
  `nome` char(255) DEFAULT NULL,                                -- nome del ruolo
  `html_entity` char(8) DEFAULT NULL,                           -- entita' HTML che rappresenta il ruolo
  `font_awesome` char(16) DEFAULT NULL,                         -- classe Font Awesome dell'icona del ruolo
  `se_anagrafica` tinyint(1) DEFAULT NULL,                      -- flag per i ruoli proponibili nei file dell'anagrafica
  `se_annunci` tinyint(1) DEFAULT NULL,                         -- flag per i ruoli proponibili nei file degli annunci
  `se_prodotti` tinyint(1) DEFAULT NULL,                        -- flag per i ruoli proponibili nei file dei prodotti
  `se_articoli` tinyint(1) DEFAULT NULL,                        -- flag per i ruoli proponibili nei file degli articoli
  `se_indirizzi` tinyint(1) DEFAULT NULL,                       -- flag per i ruoli proponibili nei file degli indirizzi
  `se_progetti` tinyint(1) DEFAULT NULL,                        -- flag per i ruoli proponibili nei file dei progetti
  `se_contratti` tinyint(1) DEFAULT NULL,                       -- flag per i ruoli proponibili nei file dei contratti
  `se_todo` tinyint(1) DEFAULT NULL,                            -- flag per i ruoli proponibili nei file delle cose da fare
  `se_immobili` tinyint(1) DEFAULT NULL,                        -- flag per i ruoli proponibili nei file degli immobili
  `se_mailing` tinyint(1) DEFAULT NULL,                         -- flag per i ruoli proponibili nei file dei mailing
  `se_documenti` tinyint(1) DEFAULT NULL,                       -- flag per i ruoli proponibili nei file dei documenti
  `se_pagine` tinyint(1) DEFAULT NULL,                          -- flag per i ruoli proponibili nei file delle pagine
  `se_categorie_prodotti` tinyint(1) DEFAULT NULL,              -- flag per i ruoli proponibili nei file delle categorie di prodotti
  `se_marchi` tinyint(1) DEFAULT NULL,                          -- flag per i ruoli proponibili nei file dei marchi
  `se_categorie_marchi` tinyint(1) DEFAULT NULL,                -- flag per i ruoli proponibili nei file delle categorie di marchi
  `se_risorse` tinyint(1) DEFAULT NULL,                         -- flag per i ruoli proponibili nei file delle risorse
  `se_categorie_risorse` tinyint(1) DEFAULT NULL,               -- flag per i ruoli proponibili nei file delle categorie di risorse
  `se_notizie` tinyint(1) DEFAULT NULL,                         -- flag per i ruoli proponibili nei file delle notizie
  `se_categorie_notizie` tinyint(1) DEFAULT NULL,               -- flag per i ruoli proponibili nei file delle categorie di notizie
  `se_categorie_annunci` tinyint(1) DEFAULT NULL,               -- flag per i ruoli proponibili nei file delle categorie di annunci
  `se_categorie_progetti` tinyint(1) DEFAULT NULL,              -- flag per i ruoli proponibili nei file delle categorie di progetti
  `se_edifici` tinyint(1) DEFAULT NULL,                         -- flag per i ruoli proponibili nei file degli edifici
  `se_valutazioni` tinyint(1) DEFAULT NULL,                     -- flag per i ruoli proponibili nei file delle valutazioni
  `se_licenze` tinyint(1) DEFAULT NULL,                         -- flag per i ruoli proponibili nei file delle licenze
  `se_anagrafica_certificazioni` tinyint(1) DEFAULT NULL,       -- flag per i ruoli proponibili nei file delle certificazioni dell'anagrafica
  `se_template` tinyint(1) DEFAULT NULL,                        -- flag per i ruoli proponibili nei file dei template
  `se_rinnovi` tinyint(1) DEFAULT NULL,                         -- flag per i ruoli proponibili nei file dei rinnovi
  `se_valutazioni_certificazioni` tinyint(1) DEFAULT NULL,      -- flag per i ruoli proponibili nei file delle certificazioni delle valutazioni
  `se_mail` tinyint(1) DEFAULT NULL,                            -- flag per i ruoli proponibili nei file delle mail della coda di invio
  `se_attivita` tinyint(1) DEFAULT NULL,                        -- flag per i ruoli proponibili nei file delle attivita'
  `se_audio` tinyint(1) DEFAULT NULL,                           -- flag per i ruoli proponibili nei file degli audio
  `se_video` tinyint(1) DEFAULT NULL,                           -- flag per i ruoli proponibili nei file dei video
  `se_immagini` tinyint(1) DEFAULT NULL,                        -- flag per i ruoli proponibili nei file delle immagini
  `se_vani` tinyint(1) DEFAULT NULL                             -- flag per i ruoli proponibili nei file dei vani
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000034600

-- ruoli_immagini
-- tipologia: tabella standard
-- rango: tabella secondaria
-- struttura: tabella ricorsiva
-- funzione: contiene i ruoli che un'immagine svolge rispetto all'oggetto a cui appartiene
--
-- questa tabella contiene i ruoli di un'immagine ( immagine, gallery, card, copertina, logo... ); la legge immagini.id_ruolo,
-- e la tendina del form immagini di un oggetto propone i ruoli col flag se_<oggetto> di quell'oggetto: c'e' un flag per ogni
-- chiave oggetto di immagini, nello stesso ordine ( decisione del 28/10/2026 ), compresi se_audio, se_file e se_video
-- della matrice dei media ( decisione del 16/10/2026 )
--
-- NOTA la priorita' dello scalamento automatico per ruolo non sta qui ( la colonna ordine_scalamento e' uscita dal canone
-- il 28/10/2026 ): se serve, la si definisce nella configurazione delle immagini ( $cf['image'] ), per nome del ruolo
--
CREATE TABLE IF NOT EXISTS `ruoli_immagini` (
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                        -- chiave esterna per il ruolo genitore
  `nome` char(255) DEFAULT NULL,                                -- nome del ruolo
  `html_entity` char(8) DEFAULT NULL,                           -- entita' HTML che rappresenta il ruolo
  `font_awesome` char(16) DEFAULT NULL,                         -- classe Font Awesome dell'icona del ruolo
  `se_anagrafica` tinyint(1) DEFAULT NULL,                      -- flag per i ruoli proponibili nelle immagini dell'anagrafica
  `se_annunci` tinyint(1) DEFAULT NULL,                         -- flag per i ruoli proponibili nelle immagini degli annunci
  `se_prodotti` tinyint(1) DEFAULT NULL,                        -- flag per i ruoli proponibili nelle immagini dei prodotti
  `se_articoli` tinyint(1) DEFAULT NULL,                        -- flag per i ruoli proponibili nelle immagini degli articoli
  `se_contatti` tinyint(1) DEFAULT NULL,                        -- flag per i ruoli proponibili nelle immagini dei contatti
  `se_indirizzi` tinyint(1) DEFAULT NULL,                       -- flag per i ruoli proponibili nelle immagini degli indirizzi
  `se_progetti` tinyint(1) DEFAULT NULL,                        -- flag per i ruoli proponibili nelle immagini dei progetti
  `se_contratti` tinyint(1) DEFAULT NULL,                       -- flag per i ruoli proponibili nelle immagini dei contratti
  `se_immobili` tinyint(1) DEFAULT NULL,                        -- flag per i ruoli proponibili nelle immagini degli immobili
  `se_pagine` tinyint(1) DEFAULT NULL,                          -- flag per i ruoli proponibili nelle immagini delle pagine
  `se_file` tinyint(1) DEFAULT NULL,                            -- flag per i ruoli proponibili nelle immagini dei file
  `se_categorie_prodotti` tinyint(1) DEFAULT NULL,              -- flag per i ruoli proponibili nelle immagini delle categorie di prodotti
  `se_marchi` tinyint(1) DEFAULT NULL,                          -- flag per i ruoli proponibili nelle immagini dei marchi
  `se_categorie_marchi` tinyint(1) DEFAULT NULL,                -- flag per i ruoli proponibili nelle immagini delle categorie di marchi
  `se_risorse` tinyint(1) DEFAULT NULL,                         -- flag per i ruoli proponibili nelle immagini delle risorse
  `se_categorie_risorse` tinyint(1) DEFAULT NULL,               -- flag per i ruoli proponibili nelle immagini delle categorie di risorse
  `se_notizie` tinyint(1) DEFAULT NULL,                         -- flag per i ruoli proponibili nelle immagini delle notizie
  `se_categorie_notizie` tinyint(1) DEFAULT NULL,               -- flag per i ruoli proponibili nelle immagini delle categorie di notizie
  `se_categorie_annunci` tinyint(1) DEFAULT NULL,               -- flag per i ruoli proponibili nelle immagini delle categorie di annunci
  `se_categorie_progetti` tinyint(1) DEFAULT NULL,              -- flag per i ruoli proponibili nelle immagini delle categorie di progetti
  `se_edifici` tinyint(1) DEFAULT NULL,                         -- flag per i ruoli proponibili nelle immagini degli edifici
  `se_valutazioni` tinyint(1) DEFAULT NULL,                     -- flag per i ruoli proponibili nelle immagini delle valutazioni
  `se_rinnovi` tinyint(1) DEFAULT NULL,                         -- flag per i ruoli proponibili nelle immagini dei rinnovi
  `se_banner` tinyint(1) DEFAULT NULL,                          -- flag per i ruoli proponibili nelle immagini dei banner
  `se_audio` tinyint(1) DEFAULT NULL,                           -- flag per i ruoli proponibili nelle immagini degli audio
  `se_video` tinyint(1) DEFAULT NULL,                           -- flag per i ruoli proponibili nelle immagini dei video
  `se_vani` tinyint(1) DEFAULT NULL                             -- flag per i ruoli proponibili nelle immagini dei vani
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000034800

-- ruoli_indirizzi
-- tipologia: tabella standard
-- rango: tabella secondaria
-- struttura: tabella ricorsiva
-- funzione: contiene i ruoli che un indirizzo svolge per l'anagrafica a cui appartiene
--
-- questa tabella contiene i ruoli di un indirizzo ( sede legale, sede operativa, casa, residenza, domicilio ); la legge
-- anagrafica_indirizzi.id_ruolo, l'unica relazione che la usa, quindi i flag non dicono dove il ruolo e' proponibile ma
-- la qualita' giuridica dell'indirizzo: sede legale e sede operativa per le aziende, residenza e domicilio per le persone
-- ( decisione del 28/10/2026 ); un ruolo senza flag, come casa, e' un indirizzo senza qualita' giuridica
--
-- NOTA se_sede_legale e' letto dal core ( la sede legale dell'anagrafica in mysql.utils.php ) e dai moduli anagrafica e
-- documenti, che mettono per primo l'indirizzo di sede legale
--
CREATE TABLE IF NOT EXISTS `ruoli_indirizzi` (
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                        -- chiave esterna per il ruolo genitore
  `nome` char(255) DEFAULT NULL,                                -- nome del ruolo
  `html_entity` char(8) DEFAULT NULL,                           -- entita' HTML che rappresenta il ruolo
  `font_awesome` char(16) DEFAULT NULL,                         -- classe Font Awesome dell'icona del ruolo
  `se_sede_legale` tinyint(1) DEFAULT NULL,                     -- flag per i ruoli che sono una sede legale
  `se_sede_operativa` tinyint(1) DEFAULT NULL,                  -- flag per i ruoli che sono una sede operativa
  `se_residenza` tinyint(1) DEFAULT NULL,                       -- flag per i ruoli che sono una residenza
  `se_domicilio` tinyint(1) DEFAULT NULL                        -- flag per i ruoli che sono un domicilio
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000034850

-- ruoli_mail
-- tipologia: tabella standard
-- rango: tabella secondaria
-- struttura: tabella ricorsiva
-- funzione: contiene i ruoli che un indirizzo mail svolge per il suo proprietario
--
-- questa tabella contiene i ruoli di un indirizzo mail ( generica, commerciale, produzione, amministrazione, acquisti,
-- ordini, helpdesk ); la legge mail.id_ruolo, l'unica chiave che la usa, quindi i flag non dicono dove il ruolo e'
-- proponibile ma a quale funzione aziendale l'indirizzo serve; generica le serve tutte ( decisione del 28/10/2026 )
--
-- NOTA i flag servono a chi deve scegliere a quale indirizzo scrivere per una funzione ( un ordine, un ticket, una
-- comunicazione amministrativa ): si cerca la mail col flag e fra quelle si prende la prima nell'ordine; il destinatario
-- delle fatture elettroniche non e' un ruolo, lo dicono mail.se_pec e anagrafica.id_pec_sdi
--
CREATE TABLE IF NOT EXISTS `ruoli_mail` (                     --
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                        -- chiave esterna per il ruolo genitore
  `nome` char(255) DEFAULT NULL,                                -- nome del ruolo
  `html_entity` char(8) DEFAULT NULL,                           -- entita' HTML che rappresenta il ruolo
  `font_awesome` char(16) DEFAULT NULL,                         -- classe Font Awesome dell'icona del ruolo
  `se_commerciale` tinyint(1) DEFAULT NULL,                     -- flag per i ruoli che servono alla funzione commerciale
  `se_produzione` tinyint(1) DEFAULT NULL,                      -- flag per i ruoli che servono alla produzione
  `se_amministrazione` tinyint(1) DEFAULT NULL,                 -- flag per i ruoli che servono all'amministrazione
  `se_acquisti` tinyint(1) DEFAULT NULL,                        -- flag per i ruoli che servono agli acquisti
  `se_ordini` tinyint(1) DEFAULT NULL,                          -- flag per i ruoli che servono agli ordini
  `se_helpdesk` tinyint(1) DEFAULT NULL                         -- flag per i ruoli che servono all'helpdesk
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000034870

-- ruoli_mastri
-- tipologia: tabella standard
-- rango: tabella secondaria
-- struttura: tabella ricorsiva
-- funzione: contiene i ruoli dei mastri
--
-- questa tabella contiene i ruoli dei mastri, con le icone e i flag che dicono in quali ambiti il ruolo
-- si usa
--
CREATE TABLE IF NOT EXISTS `ruoli_mastri` (
  `id` bigint(20) NOT NULL,
  `id_genitore` bigint(20) DEFAULT NULL,
  `nome` char(128) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_xml` tinyint(1) DEFAULT NULL,
  `se_commerciale` tinyint(1) DEFAULT NULL,
  `se_produzione` tinyint(1) DEFAULT NULL,
  `se_amministrazione` tinyint(1) DEFAULT NULL,
  `se_acquisti` tinyint(1) DEFAULT NULL,
  `se_ordini` tinyint(1) DEFAULT NULL,
  `se_logistica` tinyint(1) DEFAULT NULL,
  `se_helpdesk` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000034900

-- ruoli_matricole
-- tipologia: tabella standard
-- rango: tabella secondaria
-- struttura: tabella ricorsiva
-- funzione: contiene i ruoli matricole
--
CREATE TABLE IF NOT EXISTS `ruoli_matricole` (
  `id` bigint(20) NOT NULL,
  `id_genitore` bigint(20) DEFAULT NULL,
  `nome` char(32) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000034950

-- ruoli_pagamenti
-- tipologia: tabella standard
-- rango: tabella secondaria
-- struttura: tabella ricorsiva
-- funzione: contiene i ruoli che legano due pagamenti
--
-- questa tabella contiene i ruoli con cui un pagamento e' collegato a un altro ( storno, contropartita,
-- compensazione, ripresentazione... ); la legge relazioni_pagamenti.id_ruolo, e i ruoli proponibili sono quelli
-- con se_relazioni ( decisione del 27/10/2026 )
--
CREATE TABLE IF NOT EXISTS `ruoli_pagamenti` (
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                        -- chiave esterna per il ruolo genitore
  `nome` char(255) DEFAULT NULL,                                -- nome del ruolo
  `html_entity` char(8) DEFAULT NULL,                           -- entita' HTML che rappresenta il ruolo
  `font_awesome` char(16) DEFAULT NULL,                         -- classe Font Awesome dell'icona del ruolo
  `se_relazioni` tinyint(1) DEFAULT NULL                        -- flag per i ruoli proponibili in relazioni_pagamenti
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000035000

-- ruoli_prodotti
-- tipologia: tabella standard
-- rango: tabella secondaria
-- struttura: tabella ricorsiva
-- funzione: contiene i ruoli dei prodotti
--
-- questa tabella contiene i ruoli dei prodotti, con le informazioni relative al nome, alle entità HTML
-- e Font Awesome associate e ai vari tipi di prodotto
-- 
CREATE TABLE IF NOT EXISTS `ruoli_prodotti` (
  `id` bigint(20) NOT NULL,
  `id_genitore` bigint(20) DEFAULT NULL,
  `nome` char(32) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_relazioni` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000035100

-- ruoli_progetti
-- tipologia: tabella standard
-- rango: tabella secondaria
-- struttura: tabella ricorsiva
-- funzione: contiene i ruoli progetti
--
CREATE TABLE IF NOT EXISTS `ruoli_progetti` (
  `id` bigint(20) NOT NULL,
  `id_genitore` bigint(20) DEFAULT NULL,
  `nome` char(128) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_sottoprogetto` tinyint(1) DEFAULT NULL,
  `se_proseguimento` tinyint(1) DEFAULT NULL,
  `se_sostituto` tinyint(1) DEFAULT NULL,
  `se_attesa` tinyint(1) DEFAULT NULL,
  `se_relazioni` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000035120

-- ruoli_risorse
-- tipologia: tabella standard
-- rango: tabella secondaria
-- struttura: tabella ricorsiva
-- funzione: contiene i ruoli che legano una risorsa a un nodo organizzativo
--
-- questa tabella contiene i ruoli con cui una risorsa e' collegata a un nodo di un'organizzazione ( prodotta,
-- custodita, destinata... ); la legge risorse_organizzazioni.id_ruolo, e i ruoli proponibili sono quelli con
-- se_organizzazioni ( decisione del 28/10/2026 )
--
CREATE TABLE IF NOT EXISTS `ruoli_risorse` (
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                        -- chiave esterna per il ruolo genitore
  `nome` char(255) DEFAULT NULL,                                -- nome del ruolo
  `html_entity` char(8) DEFAULT NULL,                           -- entita' HTML che rappresenta il ruolo
  `font_awesome` char(16) DEFAULT NULL,                         -- classe Font Awesome dell'icona del ruolo
  `se_organizzazioni` tinyint(1) DEFAULT NULL                   -- flag per i ruoli proponibili in risorse_organizzazioni
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000035150

-- ruoli_software
-- tipologia: tabella standard
-- rango: tabella secondaria
-- struttura: tabella ricorsiva
-- funzione: contiene i ruoli che legano due software
--
-- questa tabella contiene i ruoli con cui un software e' collegato a un altro ( aggiornamento, plugin... ); la
-- legge relazioni_software.id_ruolo, e i ruoli proponibili sono quelli con se_relazioni ( decisione del 26/10/2026 )
--
CREATE TABLE IF NOT EXISTS `ruoli_software` (
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                        -- chiave esterna per il ruolo genitore
  `nome` char(255) DEFAULT NULL,                                -- nome del ruolo
  `html_entity` char(8) DEFAULT NULL,                           -- entita' HTML che rappresenta il ruolo
  `font_awesome` char(16) DEFAULT NULL,                         -- classe Font Awesome dell'icona del ruolo
  `se_relazioni` tinyint(1) DEFAULT NULL                        -- flag per i ruoli proponibili in relazioni_software
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000035200

-- ruoli_video
-- tipologia: tabella standard
-- rango: tabella secondaria
-- struttura: tabella ricorsiva
-- funzione: contiene i ruoli dei video
--
-- questa tabella contiene i ruoli dei video, con le informazioni relative al nome, alle
-- entità HTML e Font Awesome associate e ai vari tipi di video (promozionale, tutorial, informativo);
-- i ruoli dei video qualificano il ruolo di un video rispetto a una data anagrafica
--
CREATE TABLE IF NOT EXISTS `ruoli_video` (
  `id` bigint(20) NOT NULL,
  `id_genitore` bigint(20) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_anagrafica` tinyint(1) DEFAULT NULL,
  `se_pagine` tinyint(1) DEFAULT NULL,
  `se_prodotti` tinyint(1) DEFAULT NULL,
  `se_articoli` tinyint(1) DEFAULT NULL,
  `se_categorie_prodotti` tinyint(1) DEFAULT NULL,
  `se_marchi` tinyint(1) DEFAULT NULL,
  `se_categorie_marchi` tinyint(1) DEFAULT NULL,
  `se_notizie` tinyint(1) DEFAULT NULL,
  `se_categorie_notizie` tinyint(1) DEFAULT NULL,
  `se_annunci` tinyint(1) DEFAULT NULL,
  `se_categorie_annunci` tinyint(1) DEFAULT NULL,
  `se_risorse` tinyint(1) DEFAULT NULL,
  `se_categorie_risorse` tinyint(1) DEFAULT NULL,
  `se_immobili` tinyint(1) DEFAULT NULL,
  `se_audio` tinyint(1) DEFAULT NULL,
  `se_file` tinyint(1) DEFAULT NULL,
  `se_immagini` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000036000

-- sconti
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene gli sconti
--
-- questa tabella contiene gli sconti, percentuali o fissi, con la quantita' minima e il periodo di validita'
--
CREATE TABLE IF NOT EXISTS `sconti` (
  `id` bigint(20) NOT NULL,
  `id_tipologia` bigint(20) DEFAULT NULL,
  `nome` varchar(255) DEFAULT NULL,
  `sconto_percentuale` decimal(5,2) DEFAULT NULL,
  `sconto_fisso` decimal(5,2) DEFAULT NULL,
  `qta_min` int(11) DEFAULT NULL,
  `id_valuta` bigint(20) DEFAULT NULL,
  `timestamp_inizio` int(11) DEFAULT NULL,
  `timestamp_fine` int(11) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000036200

-- sconti_articoli
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: collega gli sconti agli articoli a cui si applicano
--
-- questa tabella contiene l'associazione molti a molti fra sconti e articoli
--
CREATE TABLE IF NOT EXISTS `sconti_articoli` (
  `id` bigint(20) NOT NULL,
  `id_sconto` bigint(20) DEFAULT NULL,
  `id_articolo` bigint(20) NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000036400

-- sconti_listini
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: collega gli sconti ai listini a cui si applicano
--
-- questa tabella contiene l'associazione molti a molti fra sconti e listini
--
CREATE TABLE IF NOT EXISTS `sconti_listini` (
  `id` bigint(20) NOT NULL,
  `id_sconto` bigint(20) DEFAULT NULL,
  `id_listino` bigint(20) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000037000

-- settori
-- tipologia: tabella standard
-- rango: tabella principale
-- struttura: tabella ricorsiva
-- funzione: contiene i settori aziendali
--
-- questa tabella contiene i settori di attività ATECO, con le informazioni relative al nome, al soprannome
-- e al codice ATECO
--
CREATE TABLE IF NOT EXISTS `settori` (
  `id` bigint(20) NOT NULL,
  `id_genitore` bigint(20) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `soprannome` char(64) DEFAULT NULL,
  `ateco` char(32) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000041000

-- sms_out
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene gli SMS in uscita
--
-- questa tabella contiene gli SMS in uscita, con le informazioni relative al mittente, ai destinatari,
-- al corpo, al server di invio e allo stato di invio; ha le stesse colonne, nello stesso ordine, di
-- sms_sent, perche' il task di invio sposta le righe con REPLACE INTO sms_sent SELECT * FROM sms_out
--
CREATE TABLE IF NOT EXISTS `sms_out` (
  `id` bigint(20) NOT NULL,
  `id_telefono` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `timestamp_composizione` int(11) DEFAULT NULL,
  `mittente` char(254) DEFAULT NULL,
  `destinatari` text DEFAULT NULL,
  `corpo` text DEFAULT NULL,
  `server` char(128) DEFAULT NULL,
  `host` char(254) DEFAULT NULL,
  `port` char(6) DEFAULT NULL,
  `user` char(254) DEFAULT NULL,
  `password` char(254) DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
  `timestamp_elaborazione` int(11) DEFAULT NULL,
  `tentativi` int(11) DEFAULT 0,
  `timestamp_invio` int(11) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000041200

-- sms_sent
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene gli SMS inviati
--
-- questa tabella contiene gli SMS inviati, con le informazioni relative al mittente, ai destinatari,
-- al corpo, al server di invio e alla data di invio; ha le stesse colonne, nello stesso ordine, di
-- sms_out
--
CREATE TABLE IF NOT EXISTS `sms_sent` (
  `id` bigint(20) NOT NULL,
  `id_telefono` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `timestamp_composizione` int(11) DEFAULT NULL,
  `mittente` char(254) DEFAULT NULL,
  `destinatari` text DEFAULT NULL,
  `corpo` text DEFAULT NULL,
  `server` char(128) DEFAULT NULL,
  `host` char(254) DEFAULT NULL,
  `port` char(6) DEFAULT NULL,
  `user` char(254) DEFAULT NULL,
  `password` char(254) DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
  `timestamp_elaborazione` int(11) DEFAULT NULL,
  `tentativi` int(11) DEFAULT 0,
  `timestamp_invio` int(11) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000041400

-- software
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella ricorsiva
-- funzione: contiene i software
--
CREATE TABLE IF NOT EXISTS `software` (
  `id` bigint(20) NOT NULL,
  `id_genitore` bigint(20) DEFAULT NULL,
  `id_articolo` bigint(20) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `json` text DEFAULT NULL, 
  `nome` char(128) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000042000

-- stati
-- tipologia: tabella standard
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene gli stati del mondo
-- 
-- questa tabella contiene gli stati del mondo, con le informazioni relative al continente di appartenenza, al nome,
-- ai codici ISO e ISTAT, all'URL di riferimento e alle note
--
-- uno stato che cessa di esistere non si cancella: si archivia con data_archiviazione e note_archiviazione e punta
-- col id_successore allo stato che ne ha preso il posto; questi campi si valorizzano a mano
CREATE TABLE IF NOT EXISTS `stati` (                          --
  `id` bigint(20) NOT NULL,                                      -- chiave primaria
  `id_continente` bigint(20) DEFAULT NULL,                       -- chiave esterna per il continente di appartenenza
  `id_successore` bigint(20) DEFAULT NULL,                       -- stato che ha preso il posto di questo dopo l'archiviazione
  `nome` char(128) DEFAULT NULL,                              -- nome dello stato
  `nome_esteso` char(128) DEFAULT NULL,                       -- nome esteso dello stato
  `url_riferimento` char(255) DEFAULT NULL,                   -- URL di riferimento dello stato
  `note` text DEFAULT NULL,                                   -- note sullo stato
  `iso31661alpha2` char(2) DEFAULT NULL,                      -- codice ISO 3166-1 alpha-2 dello stato
  `iso31661alpha3` char(3) DEFAULT NULL,                      -- codice ISO 3166-1 alpha-3 dello stato
  `codice_istat` char(4) DEFAULT NULL,                        -- codice ISTAT dello stato
  `data_archiviazione` date DEFAULT NULL,                      -- data di archiviazione dello stato
  `note_archiviazione` text DEFAULT NULL                       -- note sull'archiviazione dello stato
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000042200

-- stati_lingue
-- tipologia: tabella standard
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: mette in relazione stati e lingue
--
CREATE TABLE IF NOT EXISTS `stati_lingue` (
  `id` bigint(20) NOT NULL,
  `id_stato` bigint(20) DEFAULT NULL,
  `id_lingua` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000042500

-- step
-- tipologia: tabella gestita
-- rango: tabella secondaria
-- struttura: tabella base
-- funzione: contiene gli step dei funnel
--
-- questa tabella contiene gli step dei funnel, con le informazioni relative al funnel di appartenenza, all'ordine,
-- al nome e alle note
--
CREATE TABLE IF NOT EXISTS `step` (                                         --
  `id` bigint(20) NOT NULL,                                      -- chiave primaria
  `id_funnel` bigint(20) DEFAULT NULL,                           -- chiave esterna per il funnel di appartenenza
  `ordine` char(32) DEFAULT NULL,                             -- ordine dello step nel funnel
  `nome` char(128) DEFAULT NULL,                              -- nome dello step
  `note` text DEFAULT NULL,                                    -- note sullo step
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000043000

-- task
-- tipologia: tabella assistita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene i task pianificati del sistema
--
-- questa tabella contiene i task pianificati del sistema, per maggiori informazioni si veda la documentazione relativa ai file
-- /_src/_api/_cron.php e /_src/_api/_job.php
-- 
CREATE TABLE IF NOT EXISTS `task` (                           --
  `id` bigint(20) NOT NULL,                                      -- chiave primaria
  `minuto` int(11) DEFAULT NULL,                              -- minuto di esecuzione (0-59, NULL sta per ogni minuto)
  `ora` int(11) DEFAULT NULL,                                 -- ora di esecuzione (0-23, NULL sta per ogni ora)
  `giorno_del_mese` int(11) DEFAULT NULL,                     -- giorno del mese di esecuzione (1-31, NULL sta per ogni giorno del mese)
  `mese` int(11) DEFAULT NULL,                                -- mese di esecuzione (1-12, NULL sta per ogni mese)
  `giorno_della_settimana` int(11) DEFAULT NULL,              -- giorno della settimana di esecuzione (1-7, 1 lunedì e 7 domenica come date( 'N' ), NULL sta per ogni giorno della settimana)
  `settimana` int(11) DEFAULT NULL,                           -- settimana di esecuzione (1-53, NULL sta per ogni settimana)
  `task` char(255) DEFAULT NULL,                              -- percorso del file del task
  `iterazioni` int(11) DEFAULT NULL,                          -- numero di iterazioni del task per ogni esecuzione
  `delay` int(11) DEFAULT NULL,                               -- delay in secondi tra un'esecuzione e l'altra del task
  `token` char(254) DEFAULT NULL,                             -- token di lock del task
  `timestamp_esecuzione` int(11) DEFAULT NULL,                -- timestamp dell'ultima esecuzione del task
  `id_account_inserimento` bigint(20) DEFAULT NULL,              -- chiave esterna per l'account che ha inserito il task
  `timestamp_inserimento` int(11) DEFAULT NULL,               -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,            -- chiave esterna per l'account che ha aggiornato il task
  `timestamp_aggiornamento` int(11) DEFAULT NULL              -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000043600

-- telefoni
-- tipologia: tabella gestita
-- rango: tabella secondaria
-- struttura: tabella base
-- funzione: contiene i numeri di telefono delle anagrafiche
--
-- questa tabella contiene i numeri di telefono delle anagrafiche, con le informazioni relative alla tipologia,
-- al numero, alle notifiche e alle anagrafiche a cui sono associati
--
CREATE TABLE IF NOT EXISTS `telefoni` (                                     --
  `id` bigint(20) NOT NULL,                                      -- chiave primaria
  `id_anagrafica` bigint(20) DEFAULT NULL,                       -- chiave esterna per l'anagrafica a cui è associato il numero di telefono
  `id_tipologia` bigint(20) DEFAULT NULL,                        -- chiave esterna per la tipologia del numero di telefono
  `numero` char(32) DEFAULT NULL,                             -- numero di telefono
  `note` text DEFAULT NULL,                                   -- note sul numero di telefono
  `se_notifiche` tinyint(1) DEFAULT NULL,                     -- flag che indica se il numero di telefono è abilitato alle notifiche
  `id_account_inserimento` bigint(20) DEFAULT NULL,              -- chiave esterna per l'account che ha inserito il numero di telefono
  `timestamp_inserimento` int(11) DEFAULT NULL,               -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,            -- chiave esterna per l'account che ha aggiornato il numero di telefono
  `timestamp_aggiornamento` int(11) DEFAULT NULL              -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000044000

-- template
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene i template per le comunicazioni automatiche
--
-- questa tabella contiene i template per mail e sms
-- 
CREATE TABLE IF NOT EXISTS `template` (                       --
  `id` bigint(20) NOT NULL,                                      -- chiave primaria
  `nome` char(128) DEFAULT NULL,                              -- nome del template
  `ruolo` char(32) DEFAULT NULL,                              -- ruolo del template
  `tipo` char(32) DEFAULT NULL,                               -- tipo di template
  `note` text DEFAULT NULL,                                   -- note sul template
  `latenza_invio` int(11) DEFAULT NULL,                       -- latenza in secondi per l'invio del template
  `se_mail` tinyint(1) DEFAULT NULL,                          -- flag che indica se il template è per le mail
  `se_sms` tinyint(1) DEFAULT NULL,                           -- flag che indica se il template è per gli SMS
  `id_account_inserimento` bigint(20) DEFAULT NULL,              -- chiave esterna per l'account che ha inserito il template
  `timestamp_inserimento` int(11) DEFAULT NULL,               -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,            -- chiave esterna per l'account che ha aggiornato il template
  `timestamp_aggiornamento` int(11) DEFAULT NULL              -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000045000

-- testate
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene i testate
--
CREATE TABLE IF NOT EXISTS `testate` (
  `id` bigint(20) NOT NULL,
  `nome` char(128) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000050000

-- tipologie_anagrafica
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella ricorsiva
-- funzione: contiene le tipologie di anagrafica
--
-- questa tabella contiene le tipologie di anagrafica, con le informazioni relative al nome, alla sigla e alle
-- funzionalità associate
--
CREATE TABLE IF NOT EXISTS `tipologie_anagrafica` (           --
  `id` bigint(20) NOT NULL,                                      -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                         -- chiave esterna per la tipologia genitore
  `ordine` int(11) DEFAULT NULL,                              -- ordine di visualizzazione
  `nome` char(64) DEFAULT NULL,                               -- nome della tipologia
  `note` text DEFAULT NULL,                                   -- note della tipologia
  `sigla` char(32) DEFAULT NULL,                              -- sigla della tipologia
  `html_entity` char(8) DEFAULT NULL,                         -- entità HTML per l'icona della tipologia
  `font_awesome` char(16) DEFAULT NULL,                       -- icona Font Awesome per la tipologia
  `se_persona_fisica` tinyint(1) DEFAULT NULL,                -- flag che indica se la tipologia rappresenta persone fisiche
  `se_persona_giuridica` tinyint(1) DEFAULT NULL,             -- flag che indica se la tipologia rappresenta persone giuridiche
  `se_pubblica_amministrazione` tinyint(1) DEFAULT NULL,      -- flag che indica se la tipologia rappresenta pubbliche amministrazioni
  `se_ecommerce` tinyint(1) DEFAULT NULL,                     -- flag che indica se la tipologia è associabile all'e-commerce
  `id_account_inserimento` bigint(20) DEFAULT NULL,              -- chiave esterna per l'account che ha inserito la tipologia
  `timestamp_inserimento` int(11) DEFAULT NULL,               -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,            -- chiave esterna per l'account che ha aggiornato la tipologia
  `timestamp_aggiornamento` int(11) DEFAULT NULL              -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000050100

-- tipologie_annunci
-- tipologia: tabella standard
-- rango: tabella secondaria
-- struttura: tabella ricorsiva
-- funzione: contiene i tipologie annunci
--
CREATE TABLE IF NOT EXISTS `tipologie_annunci` (
  `id` bigint(20) NOT NULL,
  `id_genitore` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `sigla` char(32) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000050200

-- tipologie_asset
-- tipologia: tabella assistita
-- rango: tabella principale
-- struttura: tabella ricorsiva
-- funzione: contiene le tipologie di asset
--
-- questa tabella contiene le tipologie di asset, cioè dice di che genere è l'oggetto descritto da una riga di asset
-- ( un cespite, un macchinario, un'attrezzatura, un modulo di un macchinario... ); è ricorsiva perché le tipologie
-- si possono organizzare ad albero
--
CREATE TABLE IF NOT EXISTS `tipologie_asset` (             --
  `id` bigint(20) NOT NULL,                                      -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                         -- chiave esterna per la tipologia genitore
  `ordine` int(11) DEFAULT NULL,                              -- ordine di visualizzazione
  `nome` char(64) DEFAULT NULL,                               -- nome della tipologia
  `html_entity` char(8) DEFAULT NULL,                         -- entità HTML per l'icona della tipologia
  `font_awesome` char(16) DEFAULT NULL,                       -- icona Font Awesome per la tipologia
  `id_account_inserimento` bigint(20) DEFAULT NULL,              -- chiave esterna per l'account che ha inserito la tipologia
  `timestamp_inserimento` int(11) DEFAULT NULL,               -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,            -- chiave esterna per l'account che ha aggiornato la tipologia
  `timestamp_aggiornamento` int(11) DEFAULT NULL              -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000050400

-- tipologie_attivita
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella ricorsiva
-- funzione: contiene le tipologie di attività
-- 
-- questa tabella contiene le tipologie di attività, con le informazioni relative al nome, al codice e alle
-- funzionalità associate
--
CREATE TABLE IF NOT EXISTS `tipologie_attivita` (             --
  `id` bigint(20) NOT NULL,                                      -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                         -- chiave esterna per la tipologia genitore
  `ordine` int(11) DEFAULT NULL,                              -- ordine di visualizzazione
  `codice` char(32) DEFAULT NULL,                             -- codice della tipologia
  `nome` char(64) DEFAULT NULL,                               -- nome della tipologia
  `html_entity` char(8) DEFAULT NULL,                         -- entità HTML per l'icona della tipologia
  `font_awesome` char(16) DEFAULT NULL,                       -- icona Font Awesome per la tipologia
  `se_anagrafica` tinyint(1) DEFAULT NULL,                    -- flag che indica se la tipologia è associabile alle anagrafiche
  `se_agenda` tinyint(1) DEFAULT NULL,                        -- flag che indica se la tipologia è associabile all'agenda
  `se_sistema` tinyint(1) DEFAULT NULL,                       -- flag che indica se la tipologia è una tipologia di sistema
  `se_stampa` tinyint(1) DEFAULT NULL,                        -- flag che indica se la tipologia è associabile alle stampe
  `se_cartellini` tinyint(1) DEFAULT NULL,                    -- flag che indica se la tipologia è associabile ai cartellini
  `se_corsi` tinyint(1) DEFAULT NULL,                         -- flag che indica se la tipologia è associabile ai corsi
  `se_accesso` tinyint(1) DEFAULT NULL,                       -- flag che indica se la tipologia è associabile agli accessi
  `id_account_inserimento` bigint(20) DEFAULT NULL,              -- chiave esterna per l'account che ha inserito la tipologia
  `timestamp_inserimento` int(11) DEFAULT NULL,               -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,            -- chiave esterna per l'account che ha aggiornato la tipologia
  `timestamp_aggiornamento` int(11) DEFAULT NULL              -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000050430

-- tipologie_attivita_inps
-- tipologia: tabella assistita
-- rango: tabella secondaria
-- struttura: tabella ricorsiva
-- funzione: contiene le tipologie di attivita' ai fini INPS, a cui si legano i costi dei contratti
--
-- ripristinata il 2026-09-30 dallo schema del 2021 ( _usr/_database/mysql.schema.sql, 0e99bca51 ), portata a
-- bigint: la usano i moduli _0600.contratti, _1000.produzione e _0920.corsi
--
CREATE TABLE IF NOT EXISTS `tipologie_attivita_inps` (
  `id` bigint(20) NOT NULL,
  `id_genitore` bigint(20) DEFAULT NULL,
  `nome` char(255) NOT NULL,
  `codice` char(32) DEFAULT NULL,
  `se_quadratura` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000050450

-- tipologie_badge
-- tipologia: tabella assistita
-- rango: tabella secondaria
-- struttura: tabella ricorsiva
-- funzione: contiene i tipologie badge
--
CREATE TABLE IF NOT EXISTS `tipologie_badge` (
  `id` bigint(20) NOT NULL,
  `id_genitore` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000050500

-- tipologie_banner
-- tipologia: tabella assistita
-- rango: tabella secondaria
-- struttura: tabella ricorsiva
-- funzione: contiene i tipologie banner
--
CREATE TABLE IF NOT EXISTS `tipologie_banner` (
  `id` bigint(20) NOT NULL,
  `id_genitore` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000050550

-- tipologie_campagne
-- tipologia: tabella assistita
-- rango: tabella secondaria
-- struttura: tabella ricorsiva
-- funzione: contiene le tipologie delle campagne
--
CREATE TABLE IF NOT EXISTS `tipologie_campagne` (
  `id` bigint(20) NOT NULL,
  `id_genitore` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000050600

-- tipologie_chiavi
-- tipologia: tabella gestita
-- rango: tabella secondaria
-- struttura: tabella ricorsiva
-- funzione: contiene i tipologie chiavi
--
CREATE TABLE IF NOT EXISTS `tipologie_chiavi` (
  `id` bigint(20) NOT NULL,
  `id_genitore` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(32) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000050700

-- tipologie_colli
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella ricorsiva
-- funzione: contiene l albero delle tipologie di collo, con dimensioni e peso
CREATE TABLE IF NOT EXISTS `tipologie_colli` (
  `id` bigint(20) NOT NULL,
  `id_genitore` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `larghezza` decimal(7,2) DEFAULT NULL,
  `lunghezza` decimal(7,2) DEFAULT NULL,
  `altezza` decimal(7,2) DEFAULT NULL,
  `id_udm_dimensioni` bigint(20) DEFAULT NULL,
  `peso` decimal(7,2) DEFAULT NULL,
  `id_udm_peso` bigint(20) DEFAULT NULL,
  `sigla` char(32) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000050800

-- tipologie_contatti
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella ricorsiva
-- funzione: contiene le tipologie di contatti
--
-- questa tabella contiene le tipologie di contatti, con le informazioni relative al nome e alle icone associate
--
CREATE TABLE IF NOT EXISTS `tipologie_contatti` (
  `id` bigint(20) NOT NULL,
  `id_genitore` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(32) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000050900

-- tipologie_contratti
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella ricorsiva
-- funzione: contiene le tipologie di contratti
--
-- questa tabella contiene le tipologie di contratti, con le informazioni relative al nome, al prodotto collegato
-- e alle funzionalità associate (tesseramento, abbonamento, iscrizione, immobili, acquisto, locazione, libero, prenotazione, scalare,
-- affiliazione, online)
--
CREATE TABLE IF NOT EXISTS `tipologie_contratti` (                          --
  `id` bigint(20) NOT NULL,                                      -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                         -- chiave esterna per la tipologia genitore
  `ordine` int(11) DEFAULT NULL,                              -- ordine di visualizzazione
  `nome` char(64) DEFAULT NULL,                               -- nome della tipologia
  `id_prodotto` bigint(20) DEFAULT NULL,                        -- chiave esterna per il prodotto collegato
  `id_progetto` bigint(20) DEFAULT NULL,                        -- chiave esterna per il progetto collegato
  `id_categoria_progetti` bigint(20) DEFAULT NULL,               -- chiave esterna per la categoria di progetti collegata
  `html_entity` char(8) DEFAULT NULL,                         -- entità HTML per l'icona della tipologia
  `font_awesome` char(16) DEFAULT NULL,                       -- icona Font Awesome per la tipologia
  `se_tesseramento` tinyint(1) DEFAULT NULL,                  -- se tesseramento
  `se_abbonamento` tinyint(1) DEFAULT NULL,                   -- se abbonamento
  `se_iscrizione` tinyint(1) DEFAULT NULL,                    -- se iscrizione
  `se_immobili` tinyint(1) DEFAULT NULL,                      -- se immobili
  `se_acquisto` tinyint(1) DEFAULT NULL,                      -- se acquisto
  `se_locazione` tinyint(1) DEFAULT NULL,                     -- se locazione
  `se_libero` tinyint(1) DEFAULT NULL,                        -- se libero
	`se_prenotazione` tinyint(1) DEFAULT NULL,                -- se prenotazione
	`se_scalare` tinyint(1) DEFAULT NULL,                     -- se scalare
  `se_affiliazione` tinyint(1) DEFAULT NULL,                  -- se affiliazione
  `se_online` tinyint(1) DEFAULT NULL,                        -- se online
  `id_account_inserimento` bigint(20) DEFAULT NULL,              -- chiave esterna per l'account che ha inserito la tipologia
  `timestamp_inserimento` int(11) DEFAULT NULL,               -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,            -- chiave esterna per l'account che ha aggiornato la tipologia
  `timestamp_aggiornamento` int(11) DEFAULT NULL              -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000051000

-- tipologie_corrispondenza
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella ricorsiva
-- funzione: contiene le tipologie di corrispondenza
--
-- questa tabella contiene le tipologie della corrispondenza cartacea ( posta ordinaria, raccomandata, atto giudiziario
-- e così via ), organizzate ad albero; i flag dicono come si comporta la corrispondenza della tipologia. La tabella
-- appartiene al modulo corrispondenza.
-- NOTA se_corrispondenza marca le tipologie che compaiono in corrispondenza_view
-- NOTA se_massivo vuol dire che la tipologia si spedisce in forma aggregata, se_pesata che va pesata, se_atto che è un
-- atto giudiziario, se_ricevuta_ritorno che prevede la ricevuta di ritorno
--
CREATE TABLE IF NOT EXISTS `tipologie_corrispondenza` (       --
  `id` bigint(20) NOT NULL,                                   -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                      -- tipologia genitore
  `nome` char(255) DEFAULT NULL,                              -- nome della tipologia
  `se_massivo` tinyint(1) DEFAULT NULL,                       -- se la tipologia si spedisce in forma aggregata
  `se_corrispondenza` tinyint(1) DEFAULT NULL,                -- se la tipologia compare fra la corrispondenza
  `se_pesata` tinyint(1) DEFAULT NULL,                        -- se la corrispondenza va pesata
  `se_atto` tinyint(1) DEFAULT NULL,                          -- se è un atto giudiziario
  `se_ricevuta_ritorno` tinyint(1) DEFAULT NULL,              -- se prevede la ricevuta di ritorno
  `id_account_inserimento` bigint(20) DEFAULT NULL,           -- account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,               -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,         -- account che ha aggiornato la riga per ultimo
  `timestamp_aggiornamento` int(11) DEFAULT NULL              -- timestamp dell'ultimo aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000052600

-- tipologie_documenti
-- tipologia: tabella di supporto
-- rango: tabella principale
-- struttura: tabella ricorsiva
-- funzione: contiene le tipologie di documenti
--
-- questa tabella contiene le tipologie di documenti, con le informazioni relative al nome,
-- al codice, alle funzionalità associate e ai modelli di stampa
--
CREATE TABLE IF NOT EXISTS `tipologie_documenti` (            --
  `id` bigint(20) NOT NULL,                                      -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                         -- chiave esterna per la tipologia genitore
  `ordine` int(11) DEFAULT NULL,                              -- ordine di visualizzazione
  `codice` char(32) DEFAULT NULL,                             -- codice della tipologia
  `numerazione` char(1) DEFAULT NULL,                         -- tipo di numerazione (A=automatica, M=manuale, N=nessuna)
  `nome` char(255) DEFAULT NULL,                              -- nome della tipologia
  `sigla` char(16) DEFAULT NULL,                              -- sigla della tipologia
  `html_entity` char(8) DEFAULT NULL,                         -- entità HTML per l'icona della tipologia
  `font_awesome` char(16) DEFAULT NULL,                       -- icona Font Awesome per la tipologia
  `se_fattura` tinyint(1) DEFAULT NULL,                       -- se fattura
  `se_nota_credito` tinyint(1) DEFAULT NULL,                  -- se nota di credito
  `se_nota_debito` tinyint(1) DEFAULT NULL,                   -- se nota di debito
  `se_trasporto` tinyint(1) DEFAULT NULL,                     -- se trasporto
  `se_pro_forma` tinyint(1) DEFAULT NULL,                     -- se pro forma
  `se_offerta` tinyint(1) DEFAULT NULL,                       -- se offerta
  `se_ordine` tinyint(1) DEFAULT NULL,                        -- se ordine
  `se_missione` tinyint(1) DEFAULT NULL,                      -- se missione
  `se_ricevuta` tinyint(1) DEFAULT NULL,                      -- se ricevuta
  `se_ecommerce` tinyint(1) DEFAULT NULL,                     -- se e-commerce
  `stampa_xml` char(255) DEFAULT NULL,                        -- modello di stampa XML
  `stampa_pdf` char(255) DEFAULT NULL,                        -- modello di stampa PDF
  `id_account_inserimento` bigint(20) DEFAULT NULL,              -- chiave esterna per l'account che ha inserito la tipologia
  `timestamp_inserimento` int(11) DEFAULT NULL,               -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,            -- chiave esterna per l'account che ha aggiornato la tipologia
  `timestamp_aggiornamento` int(11) DEFAULT NULL              -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000052700

-- tipologie_documenti_articoli
-- tipologia: tabella assistita
-- rango: tabella principale
-- struttura: tabella ricorsiva
-- funzione: contiene le tipologie delle righe dei documenti
--
-- questa tabella qualifica la singola RIGA di un documento, non il documento che la contiene:
-- serve a marcare le righe che sono un raggruppamento, quelle che concorrono al totale e quelle
-- che descrivono un'alternativa. La tipologia del documento sta in tipologie_documenti ed e'
-- riferita da documenti.id_tipologia e da documenti_articoli.id_tipologia_documento
--
-- una riga figlia di un'altra ( documenti_articoli.id_genitore ) ha uno di tre ruoli, e la tipologia lo dice con un
-- flag perche' il codice legga il comportamento e non un id: raggruppamento ( se_raggruppamento, con se_somma o
-- se_alternativa, tipologie 1 e 2 ), dettaglio ( se_dettaglio, tipologia 5: la figlia ripartisce la madre, p.es. per
-- ubicazione ) ed evasione ( se_evasione, tipologia 6: la figlia evade la madre in tutto o in parte ). Decisione di
-- Fabio del 13/10/2026
--
CREATE TABLE IF NOT EXISTS `tipologie_documenti_articoli` (   --
  `id` bigint(20) NOT NULL,                                      -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                         -- chiave esterna per la tipologia genitore
  `ordine` int(11) DEFAULT NULL,                                -- ordine di visualizzazione
  `nome` char(255) DEFAULT NULL,                                -- nome della tipologia
  `sigla` char(16) DEFAULT NULL,                                -- sigla della tipologia
  `html_entity` char(8) DEFAULT NULL,                           -- entità HTML per l'icona della tipologia
  `font_awesome` char(16) DEFAULT NULL,                         -- icona Font Awesome per la tipologia
  `se_raggruppamento` tinyint(1) DEFAULT NULL,                  -- se la riga raggruppa le righe figlie invece di essere una riga a sé
  `se_somma` tinyint(1) DEFAULT NULL,                           -- se le righe raggruppate concorrono al totale del documento
  `se_alternativa` tinyint(1) DEFAULT NULL,                     -- se le righe raggruppate sono alternative fra loro e non si sommano
  `se_dettaglio` tinyint(1) DEFAULT NULL,                       -- se la riga dettaglia la riga genitore ( p.es. la ripartisce per ubicazione )
  `se_evasione` tinyint(1) DEFAULT NULL,                        -- se la riga evade in tutto o in parte la riga genitore
  `id_account_inserimento` bigint(20) DEFAULT NULL,                -- chiave esterna per l'account che ha inserito la tipologia
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,              -- chiave esterna per l'account che ha aggiornato la tipologia
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000052800

-- tipologie_edifici
-- tipologia: tabella di supporto
-- rango: tabella secondaria
-- struttura: tabella ricorsiva
-- funzione: contiene i tipologie edifici
--
CREATE TABLE IF NOT EXISTS `tipologie_edifici` (
  `id` bigint(20) NOT NULL,
  `id_genitore` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(32) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000052900

-- tipologie_immobili
-- tipologia: tabella di supporto
-- rango: tabella secondaria
-- struttura: tabella ricorsiva
-- funzione: contiene i tipologie immobili
--
CREATE TABLE IF NOT EXISTS `tipologie_immobili` (
  `id` bigint(20) NOT NULL,
  `id_genitore` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(32) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_residenziale` tinyint(1) DEFAULT NULL,
  `se_industriale` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000053000

-- tipologie_indirizzi
-- tipologia: tabella standard
-- rango: tabella principale
-- struttura: tabella ricorsiva
-- funzione: contiene le tipologie di indirizzi
--
-- questa tabella contiene le tipologie di indirizzi, con le informazioni relative al nome e alle icone associate
--
CREATE TABLE IF NOT EXISTS `tipologie_indirizzi` (            --
  `id` bigint(20) NOT NULL,                                      -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                         -- chiave esterna per la tipologia genitore
  `ordine` int(11) DEFAULT NULL,                              -- ordine di visualizzazione
  `nome` char(32) DEFAULT NULL,                               -- nome della tipologia
  `html_entity` char(8) DEFAULT NULL,                         -- entità HTML per l'icona della tipologia
  `font_awesome` char(16) DEFAULT NULL                        -- icona Font Awesome per la tipologia
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000053200

-- tipologie_licenze
-- tipologia: tabella assistita
-- rango: tabella secondaria
-- struttura: tabella ricorsiva
-- funzione: contiene i tipologie licenze
--
CREATE TABLE IF NOT EXISTS `tipologie_licenze` (
  `id` bigint(20) NOT NULL,
  `id_genitore` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(32) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000053300

-- tipologie_luoghi
-- tipologia: tabella assistita
-- rango: tabella secondaria
-- struttura: tabella ricorsiva
-- funzione: contiene i tipologie luoghi
--
CREATE TABLE IF NOT EXISTS `tipologie_luoghi` (
  `id` bigint(20) NOT NULL,
  `id_genitore` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000053400

-- tipologie_mastri
-- tipologia: tabella assistita
-- rango: tabella secondaria
-- struttura: tabella ricorsiva
-- funzione: contiene i tipologie mastri
--
CREATE TABLE IF NOT EXISTS `tipologie_mastri` (
  `id` bigint(20) NOT NULL,
  `id_genitore` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_magazzino` tinyint(1) DEFAULT NULL,
  `se_conto` tinyint(1) DEFAULT NULL,
  `se_registro` tinyint(1) DEFAULT NULL,
  `se_credito` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000053600

-- tipologie_listini
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella ricorsiva
-- funzione: contiene le tipologie di listini
--
-- questa tabella contiene le tipologie di listini, con le informazioni relative al nome e alle icone associate
--
CREATE TABLE IF NOT EXISTS `tipologie_listini` (
  `id` bigint(20) NOT NULL,
  `id_genitore` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(32) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000053700

-- tipologie_mail_status
-- tipologia: tabella standard
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene gli stati di verifica degli indirizzi mail
--
-- questa tabella contiene la scala degli stati di verifica di un indirizzo mail ( Rating A+/A/B/D/F
-- piu' gli stati dei servizi di mailing ); se_recapitabile codifica la regola del framework per cui
-- si boccia solo sulla prova esplicita di non recapitabilita'
--
CREATE TABLE IF NOT EXISTS `tipologie_mail_status` (          --
  `id` bigint(20) NOT NULL,                                   -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                              -- ordine di visualizzazione
  `codice` char(32) DEFAULT NULL,                             -- codice della tipologia
  `nome` char(64) DEFAULT NULL,                               -- nome della tipologia
  `note` text DEFAULT NULL,                                   -- descrizione estesa della tipologia
  `se_recapitabile` tinyint(1) DEFAULT NULL,                  -- flag che indica se a un indirizzo in questo stato si puo' spedire
  `se_sistema` tinyint(1) DEFAULT NULL                        -- flag che indica se la tipologia e' una tipologia di sistema
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000053800

-- tipologie_notizie
-- tipologia: tabella assistita
-- rango: tabella principale
-- struttura: tabella ricorsiva
-- funzione: contiene le tipologie di notizie
--
-- questa tabella contiene le tipologie di notizie, con le informazioni relative al nome e alle icone associate
--
CREATE TABLE IF NOT EXISTS `tipologie_notizie` (
  `id` bigint(20) NOT NULL,
  `id_genitore` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000054000

-- tipologie_pagamenti
-- tipologia: tabella assistita
-- rango: tabella principale
-- struttura: tabella ricorsiva
-- funzione: contiene l albero delle tipologie di pagamento
-- verifica: 2021-11-15 11:00 Chiara GDL
CREATE TABLE IF NOT EXISTS `tipologie_pagamenti` (
  `id` bigint(20) NOT NULL,
  `id_genitore` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(32) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000054100

-- tipologie_periodi
-- tipologia: tabella gestita
-- rango: tabella secondaria
-- struttura: tabella ricorsiva
-- funzione: contiene i tipologie periodi
--
CREATE TABLE IF NOT EXISTS `tipologie_periodi` (
  `id` bigint(20) NOT NULL,
  `id_genitore` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_corsi` tinyint(1) DEFAULT NULL,
  `se_tesseramenti` tinyint(1) DEFAULT NULL,
  `se_abbonamenti` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000054200

-- tipologie_popup
-- tipologia: tabella di supporto
-- rango: tabella secondaria
-- struttura: tabella ricorsiva
-- funzione: contiene i tipologie popup
--
CREATE TABLE IF NOT EXISTS `tipologie_popup` (
  `id` bigint(20) NOT NULL,
  `id_genitore` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000054600

-- tipologie_prodotti
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella ricorsiva
-- funzione: contiene l albero delle tipologie di prodotto e le caratteristiche che abilitano
CREATE TABLE IF NOT EXISTS `tipologie_prodotti` (
  `id` bigint(20) NOT NULL,
  `id_genitore` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_colori` tinyint(1) DEFAULT NULL,
  `se_taglie` tinyint(1) DEFAULT NULL,
  `se_periodicita` tinyint(1) DEFAULT NULL,
  `se_tipologia_rinnovo` tinyint(1) DEFAULT NULL,
  `se_dimensioni` tinyint(1) DEFAULT NULL,
  `se_volume` tinyint(1) DEFAULT NULL,
  `se_capacita` tinyint(1) DEFAULT NULL,
  `se_peso` tinyint(1) DEFAULT NULL,
  `se_imballo` tinyint(1) DEFAULT NULL,
  `se_spedizione` tinyint(1) DEFAULT NULL,
  `se_trasporto` tinyint(1) DEFAULT NULL,
  `se_prodotto` tinyint(1) DEFAULT NULL,
  `se_servizio` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000055000

-- tipologie_progetti
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella ricorsiva
-- funzione: contiene l albero delle tipologie di progetto e le modalita che abilitano
CREATE TABLE IF NOT EXISTS `tipologie_progetti` (
  `id` bigint(20) NOT NULL,
  `id_genitore` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_produzione` tinyint(1) DEFAULT NULL,
  `se_contratto` tinyint(1) DEFAULT NULL,
  `se_pacchetto` tinyint(1) DEFAULT NULL,
  `se_progetto` tinyint(1) DEFAULT NULL,
  `se_consuntivo` tinyint(1) DEFAULT NULL,
  `se_forfait` tinyint(1) DEFAULT NULL,
  `se_didattica` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000055400

-- tipologie_pubblicazioni
-- tipologia: tabella di supporto
-- rango: tabella principale
-- struttura: tabella ricorsiva
-- funzione: contiene le tipologie di pubblicazioni
--
-- questa tabella contiene le tipologie di pubblicazioni, con le informazioni relative al nome, alle icone associate
-- e ai vari stati di pubblicazione (bozza, pubblicato, evidenza)
--
CREATE TABLE IF NOT EXISTS `tipologie_pubblicazioni` (          --
  `id` bigint(20) NOT NULL,                                        -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                           -- chiave esterna per la tipologia genitore
  `ordine` int(11) DEFAULT NULL,                                -- ordine di visualizzazione
  `nome` char(32) DEFAULT NULL,                                 -- nome della tipologia
  `html_entity` char(8) DEFAULT NULL,                           -- entità HTML per l'icona della tipologia
  `font_awesome` char(16) DEFAULT NULL,                         -- icona Font Awesome per la tipologia
  `se_bozza` tinyint(1) DEFAULT NULL,                           -- se bozza
  `se_pubblicato` tinyint(1) DEFAULT NULL,                      -- se pubblicato
  `se_evidenza` tinyint(1) DEFAULT NULL,                        -- se evidenza
  `se_anteprima` tinyint(1) DEFAULT NULL,                       -- se anteprima, visibile solo al gruppo anteprima
  `id_account_inserimento` bigint(20) DEFAULT NULL,                -- chiave esterna per l'account che ha inserito la tipologia
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,              -- chiave esterna per l'account che ha aggiornato la tipologia
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                           --

-- | 010000055700

-- tipologie_rinnovi
-- tipologia: tabella di supporto
-- rango: tabella principale
-- struttura: tabella ricorsiva
-- funzione: contiene l albero delle tipologie di rinnovo e gli ambiti che abilitano
CREATE TABLE IF NOT EXISTS `tipologie_rinnovi` (
  `id` bigint(20) NOT NULL,
  `id_genitore` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_tesseramenti` tinyint(1) DEFAULT NULL,
  `se_iscrizioni` tinyint(1) DEFAULT NULL,
  `se_abbonamenti` tinyint(1) DEFAULT NULL,
  `se_licenze` tinyint(1) DEFAULT NULL,
  `se_contratti` tinyint(1) DEFAULT NULL,
  `se_progetti` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000055800

-- tipologie_risorse
-- tipologia: tabella di supporto
-- rango: tabella secondaria
-- struttura: tabella ricorsiva
-- funzione: contiene i tipologie risorse
--
CREATE TABLE IF NOT EXISTS `tipologie_risorse` (
  `id` bigint(20) NOT NULL,
  `id_genitore` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000055900

-- tipologie_sconti
-- tipologia: tabella standard
-- rango: tabella secondaria
-- struttura: tabella ricorsiva
-- funzione: contiene le tipologie di sconti
--
-- questa tabella contiene le tipologie di sconti
--
CREATE TABLE IF NOT EXISTS `tipologie_sconti` (
  `id` bigint(20) NOT NULL,
  `id_genitore` bigint(20) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000056000

-- tipologie_spedizioni
-- tipologia: tabella standard
-- rango: tabella secondaria
-- struttura: tabella ricorsiva
-- funzione: contiene i tipologie spedizioni
--
CREATE TABLE IF NOT EXISTS `tipologie_spedizioni` (
  `id` bigint(20) NOT NULL,
  `id_genitore` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000056200

-- tipologie_telefoni
-- tipologia: tabella assistita
-- rango: tabella principale
-- struttura: tabella ricorsiva
-- funzione: contiene le tipologie di telefoni
-- 
-- questa tabella contiene le tipologie di telefoni, con le informazioni relative al nome e alle icone associate
--
CREATE TABLE IF NOT EXISTS `tipologie_telefoni` (                           --
  `id` bigint(20) NOT NULL,                                      -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                         -- chiave esterna per la tipologia genitore
  `ordine` int(11) DEFAULT NULL,                              -- ordine di visualizzazione
  `nome` char(32) DEFAULT NULL,                               -- nome della tipologia
  `html_entity` char(8) DEFAULT NULL,                         -- entità HTML per l'icona della tipologia
  `font_awesome` char(16) DEFAULT NULL,                       -- icona Font Awesome per la tipologia
  `id_account_inserimento` bigint(20) DEFAULT NULL,              -- chiave esterna per l'account che ha inserito la tipologia
  `timestamp_inserimento` int(11) DEFAULT NULL,               -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,            -- chiave esterna per l'account che ha aggiornato la tipologia
  `timestamp_aggiornamento` int(11) DEFAULT NULL              -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000056600

-- tipologie_todo
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella ricorsiva
-- funzione: contiene le tipologie di todo
--
-- questa tabella contiene le tipologie di todo, con le informazioni relative al nome, alle icone associate
-- e ai vari ambiti di utilizzo (agenda, ticket, ordinaria, straordinaria, commerciale, produzione, amministrazione, corsi)
--
CREATE TABLE IF NOT EXISTS `tipologie_todo` (                   --
  `id` bigint(20) NOT NULL,                                        -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                           -- chiave esterna per la tipologia genitore
  `ordine` int(11) DEFAULT NULL,                                -- ordine di visualizzazione
  `nome` char(64) DEFAULT NULL,                                 -- nome della tipologia
  `html_entity` char(8) DEFAULT NULL,                           -- entità HTML per l'icona della tipologia
  `font_awesome` char(16) DEFAULT NULL,                         -- icona Font Awesome per la tipologia
  `se_agenda` tinyint(1) DEFAULT NULL,                          -- se agenda
  `se_ticket` tinyint(1) DEFAULT NULL,                          -- se ticket
  `se_ordinaria` tinyint(1) DEFAULT NULL,                       -- se ordinaria
  `se_straordinaria` tinyint(1) DEFAULT NULL,                   -- se straordinaria
  `se_commerciale` tinyint(1) DEFAULT NULL,                     -- se commerciale
  `se_produzione` tinyint(1) DEFAULT NULL,                      -- se produzione
  `se_amministrazione` tinyint(1) DEFAULT NULL,                 -- se amministrazione
  `se_corsi` tinyint(1) DEFAULT NULL,                           -- se corsi
  `id_account_inserimento` bigint(20) DEFAULT NULL,                -- chiave esterna per l'account che ha inserito la tipologia
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,              -- chiave esterna per l'account che ha aggiornato la tipologia
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                           --

-- | 010000056800

-- tipologie_url
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella ricorsiva
-- funzione: contiene le tipologie di URL
-- 
-- questa tabella contiene le tipologie di URL, con le informazioni relative al nome e alle icone associate
--
CREATE TABLE IF NOT EXISTS `tipologie_url` (                  --
  `id` bigint(20) NOT NULL,                                      -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                         -- chiave esterna per la tipologia genitore
  `ordine` int(11) DEFAULT NULL,                              -- ordine di visualizzazione
  `nome` char(64) DEFAULT NULL,                               -- nome della tipologia
  `html_entity` char(8) DEFAULT NULL,                         -- entità HTML per l'icona della tipologia
  `font_awesome` char(16) DEFAULT NULL,                       -- icona Font Awesome per la tipologia
  `id_account_inserimento` bigint(20) DEFAULT NULL,              -- chiave esterna per l'account che ha inserito la tipologia
  `timestamp_inserimento` int(11) DEFAULT NULL,               -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,            -- chiave esterna per l'account che ha aggiornato la tipologia
  `timestamp_aggiornamento` int(11) DEFAULT NULL              -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000056850

-- tipologie_vani
-- tipologia: tabella assistita
-- rango: tabella principale
-- struttura: tabella ricorsiva
-- funzione: contiene le tipologie di vani
--
-- questa tabella contiene le tipologie di vani
--
CREATE TABLE IF NOT EXISTS `tipologie_vani` (             --
  `id` bigint(20) NOT NULL,                                      -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                         -- chiave esterna per la tipologia genitore
  `ordine` int(11) DEFAULT NULL,                              -- ordine di visualizzazione
  `nome` char(64) DEFAULT NULL,                               -- nome della tipologia
  `html_entity` char(8) DEFAULT NULL,                         -- entità HTML per l'icona della tipologia
  `font_awesome` char(16) DEFAULT NULL,                       -- icona Font Awesome per la tipologia
  `id_account_inserimento` bigint(20) DEFAULT NULL,              -- chiave esterna per l'account che ha inserito la tipologia
  `timestamp_inserimento` int(11) DEFAULT NULL,               -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,            -- chiave esterna per l'account che ha aggiornato la tipologia
  `timestamp_aggiornamento` int(11) DEFAULT NULL              -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000056900

-- tipologie_veicoli
-- tipologia: tabella assistita
-- rango: tabella principale
-- struttura: tabella ricorsiva
-- funzione: contiene le tipologie di veicoli
--
-- questa tabella contiene le tipologie di veicoli
--
CREATE TABLE IF NOT EXISTS `tipologie_veicoli` (             --
  `id` bigint(20) NOT NULL,                                      -- chiave primaria
  `id_genitore` bigint(20) DEFAULT NULL,                         -- chiave esterna per la tipologia genitore
  `ordine` int(11) DEFAULT NULL,                              -- ordine di visualizzazione
  `nome` char(64) DEFAULT NULL,                               -- nome della tipologia
  `html_entity` char(8) DEFAULT NULL,                         -- entità HTML per l'icona della tipologia
  `font_awesome` char(16) DEFAULT NULL,                       -- icona Font Awesome per la tipologia
  `id_account_inserimento` bigint(20) DEFAULT NULL,              -- chiave esterna per l'account che ha inserito la tipologia
  `timestamp_inserimento` int(11) DEFAULT NULL,               -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,            -- chiave esterna per l'account che ha aggiornato la tipologia
  `timestamp_aggiornamento` int(11) DEFAULT NULL              -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000056950

-- tipologie_zone
-- tipologia: tabella standard
-- rango: tabella secondaria
-- struttura: tabella ricorsiva
-- funzione: contiene le tipologie di zone
--
-- questa tabella contiene le tipologie di zone, con i flag che dicono in quali ambiti si usano
--
CREATE TABLE IF NOT EXISTS `tipologie_zone` (
  `id` bigint(20) NOT NULL,
  `id_genitore` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_ecommerce` tinyint(1) DEFAULT NULL,
  `se_commerciale` tinyint(1) DEFAULT NULL,
  `se_immobiliare` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000060000

-- todo
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene i todo del sistema
--
-- questa tabella contiene i todo del sistema, con le informazioni relative alla tipologia, al codice, all'anagrafica,
-- al cliente, all'indirizzo, al luogo, alla data di apertura, alla scadenza, alla programmazione, alla chiusura,
-- al nome, al testo, al contatto, al progetto, al documento, all'istruzione, alla pianificazione, all'immobile,
-- all'archiviazione, alle note e agli account di inserimento e aggiornamento
--
CREATE TABLE IF NOT EXISTS `todo` (                           --
  `id` bigint(20) NOT NULL,                                      -- chiave primaria
  `id_tipologia` bigint(20) DEFAULT NULL,                        -- chiave esterna per la tipologia del todo
  `codice` char(32) DEFAULT NULL,                             -- codice univoco del todo
  `id_anagrafica` bigint(20) DEFAULT NULL,                       -- chiave esterna per l'anagrafica associata al todo
  `id_cliente` bigint(20) DEFAULT NULL,                          -- chiave esterna per il cliente associato al todo
  `id_indirizzo` bigint(20) DEFAULT NULL,                        -- chiave esterna per l'indirizzo associato al todo
  `id_luogo` bigint(20) DEFAULT NULL,                            -- chiave esterna per il luogo associato al todo
  `timestamp_apertura` int(11) DEFAULT NULL,                  -- timestamp di apertura del todo
  `data_scadenza` date DEFAULT NULL,                          -- data di scadenza del todo
  `ora_scadenza` time DEFAULT NULL,                           -- ora di scadenza del todo
  `note_scadenza` text DEFAULT NULL,                          -- note sulla scadenza del todo
  `data_programmazione` date DEFAULT NULL,                    -- data di programmazione del todo
  `ora_inizio_programmazione` time DEFAULT NULL,              -- ora di inizio della programmazione del todo
  `ora_fine_programmazione` time DEFAULT NULL,                -- ora di fine della programmazione del todo
  `anno_programmazione` year(4) DEFAULT NULL,                 -- anno di programmazione del todo
  `settimana_programmazione` int(11) DEFAULT NULL,            -- settimana di programmazione del todo
  `ore_programmazione` decimal(5,2) DEFAULT NULL,             -- ore di programmazione del todo
  `note_programmazione` text DEFAULT NULL,                    -- note sulla programmazione del todo
  `data_chiusura` date DEFAULT NULL,                          -- data di chiusura del todo
  `note_chiusura` text DEFAULT NULL,                          -- note sulla chiusura del todo
  `nome` char(255) DEFAULT NULL,                              -- nome del todo 
  `testo` text DEFAULT NULL,                                  -- testo del todo
  `id_contatto` bigint(20) DEFAULT NULL,                         -- chiave esterna per il contatto associato al todo
  `id_progetto` bigint(20) DEFAULT NULL,                        -- chiave esterna per il progetto associato al todo
  `id_documento` bigint(20) DEFAULT NULL,                        -- chiave esterna per il documento associato al todo
  `id_documenti_articoli` bigint(20) DEFAULT NULL,               -- chiave esterna per l'articolo del documento associato al todo
  `id_istruzione` bigint(20) DEFAULT NULL,                       -- chiave esterna per l'istruzione associata al todo
  `id_pianificazione` bigint(20) DEFAULT NULL,                   -- chiave esterna per la pianificazione associata al todo
  `id_immobile` bigint(20) DEFAULT NULL,                         -- chiave esterna per l'immobile associato al todo
  `note_pianificazione` text DEFAULT NULL,                    -- note sulla pianificazione del todo
  `data_archiviazione` date DEFAULT NULL,                     -- data di archiviazione del todo
  `note_archiviazione` text DEFAULT NULL,                     -- note sull'archiviazione del todo
  `id_account_inserimento` bigint(20) DEFAULT NULL,              -- chiave esterna per l'account che ha inserito il todo
  `timestamp_inserimento` int(11) DEFAULT NULL,               -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,            -- chiave esterna per l'account che ha aggiornato il todo
  `timestamp_aggiornamento` int(11) DEFAULT NULL              -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000060100

-- todo_matricole
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: mette in relazione todo e matricole
--
CREATE TABLE IF NOT EXISTS `todo_matricole` (
  `id` bigint(20) NOT NULL,
  `id_todo` bigint(20) DEFAULT NULL,
  `id_matricola` bigint(20) DEFAULT NULL,
  `id_ruolo` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000062000

-- udm
-- tipologia: tabella standard
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene le unita di misura, con la conversione verso la propria base
CREATE TABLE IF NOT EXISTS `udm` (
  `id` bigint(20) NOT NULL,
  `id_base` bigint(20) DEFAULT NULL,
  `conversione` float DEFAULT NULL,
  `nome` char(32) DEFAULT NULL,
  `sigla` char(8) DEFAULT NULL,
  `url_riferimento` char(255) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `se_lunghezza` tinyint(1) DEFAULT NULL,
  `se_volume` tinyint(1) DEFAULT NULL,
  `se_peso` tinyint(1) DEFAULT NULL,
  `se_tempo` tinyint(1) DEFAULT NULL,
  `se_quantita` tinyint(1) DEFAULT NULL,
  `se_area` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000062600

-- url
-- tipologia: tabella gestita
-- rango: tabella secondaria
-- struttura: tabella base
-- funzione: contiene gli URL delle anagrafiche
--
-- questa tabella contiene gli URL delle anagrafiche, con le informazioni relative alla tipologia, al nome,
-- al nome utente e alla password, oltre che all'URL vero e proprio
--
CREATE TABLE IF NOT EXISTS `url` (                            --
  `id` bigint(20) NOT NULL,                                      -- chiave primaria
  `id_tipologia` bigint(20) DEFAULT NULL,                        -- chiave esterna per la tipologia dell'URL
  `id_anagrafica` bigint(20) DEFAULT NULL,                       -- chiave esterna per l'anagrafica a cui è associato l'URL
  `url` char(255) DEFAULT NULL,                               -- URL
  `nome` char(128) DEFAULT NULL,                              -- nome dell'URL
  `username` char(128) DEFAULT NULL,                          -- nome utente per l'accesso all'URL
  `password` char(128) DEFAULT NULL,                          -- password per l'accesso all'URL
  `note` text DEFAULT NULL,                                   -- note sull'URL
  `id_account_inserimento` bigint(20) DEFAULT NULL,              -- chiave esterna per l'account che ha inserito l'URL
  `timestamp_inserimento` int(11) DEFAULT NULL,               -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,            -- chiave esterna per l'account che ha aggiornato l'URL
  `timestamp_aggiornamento` int(11) DEFAULT NULL              -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000062900

-- valutazioni
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: mette in relazione valutazioni e 
--
CREATE TABLE IF NOT EXISTS `valutazioni` (
  `id` bigint(20) NOT NULL,
  `id_anagrafica` bigint(20) DEFAULT NULL,
  `id_matricola` bigint(20) DEFAULT NULL,
  `id_immobile` bigint(20) DEFAULT NULL,
  `mq_commerciali` decimal(15,2) DEFAULT NULL,
  `mq_calpestabili` decimal(15,2) DEFAULT NULL,
  `id_condizione` bigint(20) DEFAULT NULL,
  `id_disponibilita` bigint(20) DEFAULT NULL,
  `id_classe_energetica` bigint(20) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `timestamp_valutazione` int(11) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000062950

-- valutazioni_certificazioni
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene i valutazioni certificazioni
--
CREATE TABLE IF NOT EXISTS `valutazioni_certificazioni` (
  `id` bigint(20) NOT NULL,
  `id_valutazione` bigint(20) DEFAULT NULL,
  `id_certificazione` bigint(20) DEFAULT NULL,
  `id_emittente` bigint(20) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `data_emissione` date DEFAULT NULL,
  `data_scadenza` date DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000063000

-- valute
-- tipologia: tabella standard
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene le valute utilizzate nel sistema
--
-- questa tabella contiene le valute utilizzate nel sistema, con le informazioni relative al codice ISO 4217,
-- all'entità HTML, e ai caratteri UTF-8 associati
--
CREATE TABLE IF NOT EXISTS `valute` (
  `id` bigint(20) NOT NULL,
  `iso4217` char(3) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `utf8` char(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000063200

-- vani
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene i vani degli immobili ( stanze, locali, aree )
-- entità: questa tabella corrisponde all'entità vano
--
-- questa tabella è l'ultimo livello della catena della geografia fisica, che va dall'indirizzo ai vani passando per
-- edifici e immobili ( decisione del 16/10/2026 ); un vano appartiene a un immobile e sparisce con lui ( CASCADE ), e
-- la sua tipologia viene da tipologie_vani; un mastro di magazzino o un luogo possono essere collocati in un vano, e se
-- il vano viene cancellato restano senza collocazione ( SET NULL ) invece di sparire
--
CREATE TABLE IF NOT EXISTS `vani` (                             --
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `id_tipologia` bigint(20) DEFAULT NULL,                       -- chiave esterna per la tipologia di vano
  `codice` char(32) DEFAULT NULL,                               -- codice del vano
  `nome` char(255) DEFAULT NULL,                                -- nome del vano
  `id_immobile` bigint(20) DEFAULT NULL,                        -- chiave esterna per l'immobile che contiene il vano
  `superficie` decimal(16,2) DEFAULT NULL,                      -- superficie del vano in metri quadrati
  `note` text DEFAULT NULL,                                     -- note sul vano
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha aggiornato la riga
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                           --

-- | 010000063210

-- vani_anagrafica
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: collega un vano alle anagrafiche che hanno un ruolo su di esso
--
-- questa tabella collega un vano alle anagrafiche che vi hanno un ruolo ( la guardia di un deposito,
-- un professionista per un locale tecnico... );
-- e' gemella di edifici_anagrafica e immobili_anagrafica ( decisione del 16/10/2026 ): le anagrafiche si
-- assegnano a tutti i livelli degli immobili; i ruoli proponibili sono quelli con ruoli_anagrafica.se_immobili
--
-- NOTA la chiave unica e' ( id_vano, id_anagrafica, id_ruolo ): la stessa anagrafica puo' avere piu' ruoli
--
CREATE TABLE IF NOT EXISTS `vani_anagrafica` (                  --
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                -- ordine di visualizzazione
  `id_vano` bigint(20) DEFAULT NULL,                            -- chiave esterna per il vano
  `id_anagrafica` bigint(20) DEFAULT NULL,                      -- chiave esterna per l'anagrafica
  `id_ruolo` bigint(20) DEFAULT NULL,                           -- chiave esterna per il ruolo ( ruoli_anagrafica )
  `note` text DEFAULT NULL,                                     -- note
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha aggiornato la riga
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                           --

-- | 010000063250

-- vani_caratteristiche
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: collega un vano alle sue caratteristiche
--
-- questa tabella collega un vano all'albero delle caratteristiche ( caratteristiche ) e ne porta il valore; è gemella
-- di immobili_caratteristiche ( decisione del 16/10/2026 ): il valore è per lingua, quindi id_lingua fa parte della
-- chiave unica, e se_assente dichiara che la caratteristica non c'è; le caratteristiche proponibili sono quelle con
-- caratteristiche.se_vani
--
CREATE TABLE IF NOT EXISTS `vani_caratteristiche` (             --
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `ordine` int(11) DEFAULT NULL,                                -- ordine di visualizzazione
  `id_vano` bigint(20) DEFAULT NULL,                            -- chiave esterna per il vano
  `id_caratteristica` bigint(20) DEFAULT NULL,                  -- chiave esterna per la caratteristica
  `id_lingua` bigint(20) DEFAULT NULL,                          -- chiave esterna per la lingua del valore
  `valore` text DEFAULT NULL,                                   -- valore della caratteristica
  `note` text DEFAULT NULL,                                     -- note
  `se_assente` tinyint(1) DEFAULT NULL,                         -- la caratteristica e' dichiarata assente
  `id_account_inserimento` bigint(20) DEFAULT NULL,             -- chiave esterna per l'account che ha inserito la riga
  `timestamp_inserimento` int(11) DEFAULT NULL,                 -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,           -- chiave esterna per l'account che ha aggiornato la riga
  `timestamp_aggiornamento` int(11) DEFAULT NULL                -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                           --

-- | 010000063500

-- taglie
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: le taglie degli articoli
--
-- articoli.id_taglia punta qui, e _mod/_4100.prodotti/_src/_inc/_macro/_articoli.form.php popola
-- la sua tendina da taglie_view. La tabella pero' non era mai stata scritta in queste patch: sui
-- database dove non c'era, la scheda articolo faceva fallire quella query a ogni apertura.
-- Aggiunta l'08/09/2026 nella forma che ha sui deploy dove esiste.
--
CREATE TABLE IF NOT EXISTS `taglie` (
  `id` bigint(20) NOT NULL,                                     -- chiave primaria
  `id_tipologia_prodotti` bigint(20) DEFAULT NULL,              -- chiave esterna per la tipologia di prodotto
  `nome` char(64) DEFAULT NULL,                                 -- nome della taglia
  `sesso` enum('M','F','-') DEFAULT NULL,                       -- sesso a cui la taglia si riferisce
  `taglia_internazionale` char(8) DEFAULT NULL,                 -- corrispondenza internazionale
  `circonferenza_testa_min` int(11) DEFAULT NULL,               -- per i capi che si misurano sulla testa
  `circonferenza_testa_max` int(11) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
-- | 010000064000

-- veicoli
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene i veicoli del sistema
--
-- questa tabella contiene i veicoli del sistema, con le informazioni relative alla targa, alla marca, al modello, 
-- al nome e alla descrizione del veicolo
--
CREATE TABLE IF NOT EXISTS `veicoli` (
  `id` bigint(20) NOT NULL,
  `id_tipologia` bigint(20) DEFAULT NULL,
  `targa` char(16) DEFAULT NULL,
  `modello` char(64) DEFAULT NULL,
  `id_costruttore` bigint(20) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `descrizione` text DEFAULT NULL,
  `data_archiviazione` date DEFAULT NULL,
  `note_archiviazione` text DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000065000

-- video
-- tipologia: tabella gestita
-- rango: tabella secondaria
-- struttura: tabella base
-- funzione: contiene i video collegati a varie entità del sistema
--
-- questa tabella contiene i video collegati a varie entità del sistema, con le informazioni relative
-- all'anagrafica, alla pagina, al file, al prodotto, all'articolo,
-- alla categoria prodotti, alla risorsa, alla categoria risorse, alla notizia, all'annuncio,
-- alla categoria notizie, alla categoria annunci, alla lingua, al ruolo, al progetto,
-- alla categoria progetti, all'indirizzo, all'edificio, all'immobile, alla valutazione, oltre che ai dati specifici del video come
-- l'ordine, il nome, il path, l'ID embed, il codice embed, l'embed custom, il target, l'orientamento, il ratio,
-- e agli account di inserimento e aggiornamento
--
CREATE TABLE IF NOT EXISTS `video` (
  `id` bigint(20) NOT NULL,
  `id_anagrafica` bigint(20) DEFAULT NULL,
  `id_pagina` bigint(20) DEFAULT NULL,
  `id_file` bigint(20) DEFAULT NULL,
  `id_prodotto` bigint(20) DEFAULT NULL,
  `id_articolo` bigint(20) DEFAULT NULL,
  `id_categoria_prodotti` bigint(20) DEFAULT NULL,
  `id_marchio` bigint(20) DEFAULT NULL,
  `id_categoria_marchi` bigint(20) DEFAULT NULL,
  `id_risorsa` bigint(20) DEFAULT NULL,
  `id_categoria_risorse` bigint(20) DEFAULT NULL,
  `id_notizia` bigint(20) DEFAULT NULL,
  `id_annuncio` bigint(20) DEFAULT NULL,
  `id_categoria_notizie` bigint(20) DEFAULT NULL,
  `id_categoria_annunci` bigint(20) DEFAULT NULL,
  `id_lingua` bigint(20) DEFAULT NULL,
  `id_ruolo` bigint(20) DEFAULT NULL,
  `id_progetto` bigint(20) DEFAULT NULL,
  `id_categoria_progetti` bigint(20) DEFAULT NULL,
  `id_indirizzo` bigint(20) DEFAULT NULL,
  `id_edificio` bigint(20) DEFAULT NULL,
  `id_immobile` bigint(20) DEFAULT NULL,
  `id_valutazione` bigint(20) DEFAULT NULL,
  `id_audio` bigint(20) DEFAULT NULL,
  `id_immagine` bigint(20) DEFAULT NULL,
  `id_vano` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `path` char(255) DEFAULT NULL,
  `embed` enum('html5','vimeo','youtube') DEFAULT NULL,
  `codice_embed` char(128) DEFAULT NULL,
  `embed_custom` char(128) DEFAULT NULL,
  `target` char(255) DEFAULT NULL,
  `orientamento` enum('L','P','S') DEFAULT NULL,
  `ratio` char(8) DEFAULT NULL,
  `note` text DEFAULT NULL,                                  
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000100000

-- zone
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella ricorsiva
-- funzione: contiene le zone geografiche e commerciali
--
-- questa tabella contiene le zone a cui si legano listini, modalita' di spedizione e indirizzi
--
CREATE TABLE IF NOT EXISTS `zone` (
`id` bigint(20) NOT NULL,
  `id_genitore` bigint(20) DEFAULT NULL,
  `id_tipologia` bigint(20) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000100100

-- zone_cap
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene i zone cap
--
CREATE TABLE IF NOT EXISTS `zone_cap` (
  `id` bigint(20) NOT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_zona` bigint(20) DEFAULT NULL,
  `cap` char(8) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000100200

-- zone_indirizzi
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: mette in relazione zone e indirizzi
--
CREATE TABLE IF NOT EXISTS `zone_indirizzi` (
  `id` bigint(20) NOT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_zona` bigint(20) DEFAULT NULL,
  `id_indirizzo` bigint(20) DEFAULT NULL,  
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000100400

-- zone_stati
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: mette in relazione zone e stati
--
CREATE TABLE IF NOT EXISTS `zone_stati` (
  `id` bigint(20) NOT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_zona` bigint(20) DEFAULT NULL,
  `id_stato` bigint(20) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000999000

-- test
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: test del database
-- entità: questa tabella corrisponde all'entità test
--
-- questa tabella viene utilizzata per testare la creazione di tabelle e la loro struttura; non è una tabella di produzione
--
CREATE TABLE IF NOT EXISTS `test` (                           --
  `id` bigint(20) NOT NULL,                                      -- chiave primaria
  `codice` char(32) DEFAULT NULL,                             -- codice univoco
  `nome` char(255) DEFAULT NULL,                               -- dato di test
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 010000999001

-- carrelli
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene i carrelli, con i dati del destinatario e della spedizione
CREATE TABLE IF NOT EXISTS `carrelli` (
  `id` bigint(20) NOT NULL,
  `codice` char(32) DEFAULT NULL,
  `session` char(32) DEFAULT NULL,
  `destinatario_nome` char(255) DEFAULT NULL,
  `destinatario_cognome` char(255) DEFAULT NULL,
  `destinatario_denominazione` char(255) DEFAULT NULL,
  `destinatario_id_tipologia_anagrafica` bigint(20) DEFAULT NULL,
  `destinatario_id_anagrafica` bigint(20) DEFAULT NULL,
  `destinatario_id_account` bigint(20) DEFAULT NULL,
  `destinatario_indirizzo` char(255) DEFAULT NULL,
  `destinatario_cap` char(16) DEFAULT NULL,
  `destinatario_citta` char(255) DEFAULT NULL,
  `destinatario_id_comune` bigint(20) DEFAULT NULL,
  `destinatario_id_provincia` bigint(20) DEFAULT NULL,
  `destinatario_id_stato` bigint(20) DEFAULT NULL,
  `destinatario_telefono` char(255) DEFAULT NULL,
  `destinatario_mobile` char(255) DEFAULT NULL,
  `destinatario_fax` char(255) DEFAULT NULL,
  `destinatario_mail` char(255) DEFAULT NULL,
  `destinatario_codice_fiscale` char(255) DEFAULT NULL,
  `destinatario_partita_iva` char(255) DEFAULT NULL,
  `destinatario_id_comune_nascita` bigint(20) DEFAULT NULL,
  `destinatario_id_provincia_nascita` bigint(20) DEFAULT NULL,
  `destinatario_id_stato_nascita` bigint(20) DEFAULT NULL,
  `destinatario_giorno_nascita` int(11) DEFAULT NULL,
  `destinatario_mese_nascita` int(11) DEFAULT NULL,
  `destinatario_anno_nascita` int(11) DEFAULT NULL,
  `intestazione_nome` char(255) DEFAULT NULL,
  `intestazione_cognome` char(255) DEFAULT NULL,
  `intestazione_denominazione` char(255) DEFAULT NULL,
  `intestazione_id_tipologia_anagrafica` bigint(20) DEFAULT NULL,
  `intestazione_id_anagrafica` bigint(20) DEFAULT NULL,
  `intestazione_id_account` bigint(20) DEFAULT NULL,
  `intestazione_indirizzo` char(255) DEFAULT NULL,
  `intestazione_cap` char(16) DEFAULT NULL,
  `intestazione_citta` char(255) DEFAULT NULL,
  `intestazione_id_comune` bigint(20) DEFAULT NULL,
  `intestazione_id_provincia` bigint(20) DEFAULT NULL,
  `intestazione_id_stato` bigint(20) DEFAULT NULL,
  `intestazione_telefono` char(255) DEFAULT NULL,
  `intestazione_mobile` char(255) DEFAULT NULL,
  `intestazione_fax` char(255) DEFAULT NULL,
  `intestazione_mail` char(255) DEFAULT NULL,
  `intestazione_codice_fiscale` char(255) DEFAULT NULL,
  `intestazione_partita_iva` char(255) DEFAULT NULL,
  `intestazione_sdi` char(32) DEFAULT NULL,
  `intestazione_pec` char(255) DEFAULT NULL,
  `intestazione_id_comune_nascita` bigint(20) DEFAULT NULL,
  `intestazione_id_provincia_nascita` bigint(20) DEFAULT NULL,
  `intestazione_id_stato_nascita` bigint(20) DEFAULT NULL,
  `intestazione_giorno_nascita` int(11) DEFAULT NULL,
  `intestazione_mese_nascita` int(11) DEFAULT NULL,
  `intestazione_anno_nascita` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `id_listino` bigint(20) DEFAULT NULL,
  `id_zona` bigint(20) DEFAULT NULL,
  `id_documento` bigint(20) DEFAULT NULL,
  `id_campagna` bigint(20) DEFAULT NULL,
  `fatturazione_id_tipologia_documento` bigint(20) DEFAULT NULL,
  `fatturazione_sezionale` char(16) DEFAULT NULL,
  `fatturazione_strategia` enum('SINGOLA','MULTIPLA') DEFAULT NULL,
  `prezzo_netto_totale` decimal(16,5) DEFAULT NULL,
  `prezzo_lordo_totale` decimal(16,5) DEFAULT NULL,
  `id_coupon` bigint(20) DEFAULT NULL,
  `codice_coupon` char(32) DEFAULT NULL,
  `sconto_percentuale_coupon` decimal(16,5) DEFAULT NULL,
  `sconto_valore_coupon` decimal(16,5) DEFAULT NULL,
  `sconto_percentuale` decimal(16,5) DEFAULT NULL,
  `sconto_valore` decimal(16,5) DEFAULT NULL,
  `costo_spedizione_netto` decimal(16,5) DEFAULT NULL,
  `costo_spedizione_lordo` decimal(16,5) DEFAULT NULL,
  `prezzo_netto_finale` decimal(16,5) DEFAULT NULL,
  `prezzo_lordo_finale` decimal(16,5) DEFAULT NULL,
  `provider_checkout` char(128) DEFAULT NULL,
  `timestamp_checkout` int(11) DEFAULT NULL,
  `provider_pagamento` char(64) DEFAULT NULL,
  `timestamp_pagamento` int(11) DEFAULT NULL,
  `codice_pagamento` char(128) DEFAULT NULL,
  `ordine_pagamento` char(128) DEFAULT NULL,
  `status_pagamento` char(128) DEFAULT NULL,
  `importo_pagamento` decimal(16,5) DEFAULT NULL,
  `utm_id` char(128) DEFAULT NULL,
  `utm_source` char(128) DEFAULT NULL,
  `utm_medium` char(128) DEFAULT NULL,
  `utm_campaign` char(128) DEFAULT NULL,
  `utm_term` char(128) DEFAULT NULL,
  `utm_content` char(128) DEFAULT NULL,
  `spam_score` decimal(8,2) DEFAULT NULL,
  `spam_check` int(1) DEFAULT NULL,
  `id_reseller` bigint(20) DEFAULT NULL,
  `id_affiliato` bigint(20) DEFAULT NULL,
  `id_affiliazione` bigint(20) DEFAULT NULL,
  `id_account_evasione` bigint(20) DEFAULT NULL,
  `timestamp_evasione` int(11) DEFAULT NULL,
  `note_evasione` text DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  `id_sito` bigint(20) DEFAULT NULL                               -- sito di provenienza del carrello ( id dei config.siti )
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000999002

-- rinnovi
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene i rinnovi di contratti, licenze, progetti e pianificazioni
CREATE TABLE IF NOT EXISTS `rinnovi` (
  `id` bigint(20) NOT NULL,
  `id_tipologia` bigint(20) DEFAULT NULL,
  `id_periodicita` bigint(20) DEFAULT NULL,
  `id_contratto` bigint(20) DEFAULT NULL,
  `id_licenza` bigint(20) DEFAULT NULL,
  `id_progetto` bigint(20) DEFAULT NULL,
  `id_tipologia_contratto` bigint(20) DEFAULT NULL,
  `id_categoria_progetti` bigint(20) DEFAULT NULL,
  `id_pianificazione` bigint(20) DEFAULT NULL,
  `data_inizio` date DEFAULT NULL,
  `data_fine` date DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `se_automatico` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000999003

-- contratti_anagrafica
-- tipologia: tabella gestita
-- rango: tabella di relazione
-- struttura: tabella base
-- funzione: mette in relazione i contratti e le anagrafiche, con il ruolo di ciascuna
CREATE TABLE IF NOT EXISTS `contratti_anagrafica` (
  `id` bigint(20) NOT NULL,
  `id_contratto` bigint(20) DEFAULT NULL,
  `id_anagrafica` bigint(20) DEFAULT NULL,
  `id_ruolo` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000999004

-- licenze
-- tipologia: tabella gestita
-- rango: tabella principale
-- struttura: tabella base
-- funzione: contiene le licenze distribuite, con validita, rinnovo e postazioni
CREATE TABLE IF NOT EXISTS `licenze` (
  `id` bigint(20) NOT NULL,
  `id_tipologia` bigint(20) DEFAULT NULL,
  `id_anagrafica` bigint(20) DEFAULT NULL,
  `id_rivenditore` bigint(20) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `postazioni` int(11) DEFAULT NULL,
  `nome` char(32) DEFAULT NULL,
  `note` char(254) DEFAULT NULL,
  `testo` text DEFAULT NULL,
  `giorni_validita` int(11) DEFAULT NULL,
  `giorni_rinnovo` int(11) DEFAULT NULL,
  `timestamp_distribuzione` int(11) DEFAULT NULL,
  `timestamp_inizio` int(11) DEFAULT NULL,
  `timestamp_fine` int(11) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000999020

-- istruzioni
-- tipologia: tabella gestita
-- rango: tabella secondaria
-- struttura: tabella base
-- funzione: contiene le istruzioni associate a un prodotto o a un articolo
-- Istruzioni di lavorazione, usate dal modulo produzione e citate da todo_view.
-- Sta nei patch base come tutto il resto: il database non e' partizionato per modulo, perche'
-- ci sono tabelle che afferirebbero a piu' moduli e separarle genererebbe confusione o ridondanza.
CREATE TABLE IF NOT EXISTS `istruzioni` (
  `id` bigint(20) NOT NULL,                                    -- chiave primaria
  `id_tipologia` bigint(20) DEFAULT NULL,                      -- chiave esterna per la tipologia
  `id_prodotto` bigint(20) DEFAULT NULL,                       -- chiave esterna per il prodotto
  `id_articolo` bigint(20) DEFAULT NULL,                       -- chiave esterna per l'articolo
  `nome` char(128) DEFAULT NULL,                               -- nome dell'istruzione
  `id_account_inserimento` bigint(20) DEFAULT NULL,            -- chiave esterna per l'account che ha inserito
  `timestamp_inserimento` int(11) DEFAULT NULL,                -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,          -- chiave esterna per l'account che ha aggiornato
  `timestamp_aggiornamento` int(11) DEFAULT NULL               -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | FINE FILE
