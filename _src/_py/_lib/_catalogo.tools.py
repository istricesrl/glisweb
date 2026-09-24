#!/usr/bin/env python3
# -*- coding: utf-8 -*-

##  classificazione delle tabelle del database di supporto
#
#   Le tabelle si dividono in tre categorie secondo la politica di aggiornamento dei dati,
#   come descritto in _usr/_docs/_read/300.database.md:
#
#   - **standard**: contengono dati che *sono* il framework ( lingue, comuni, unità di
#     misura, aliquote IVA, ruoli ). Modificarle equivale a fare un aggiornamento del
#     framework, e per questo motivo questo strumento non ci scrive **mai**: né per
#     inserire, né per svuotare;
#   - **assistite**: contengono dati standard per comodità dell'utente ma sono gestibili
#     dalle interfacce ( tipologie, categorie dell'anagrafica, listini, reparti ). Questo
#     strumento le **legge** per pescare tipologie e categorie coerenti, ma non ci scrive:
#     un deploy che ha già le sue tipologie non deve trovarsene altre inventate;
#   - **gestite**: sono vuote su un'installazione nuova e accolgono i dati degli utenti.
#     Sono le uniche in cui questo strumento scrive.
#
#   L'elenco è quello della documentazione e va tenuto allineato a quella: se una tabella
#   non compare in nessuna delle tre liste viene trattata come **sconosciuta**, cioè come
#   non scrivibile. È voluto — sui deploy cliente esistono tabelle di progetto ( immobili,
#   corsi, iscrizioni ) che questo strumento non sa come popolare in modo sensato, e
#   riempirle a caso sarebbe peggio che lasciarle vuote.

STANDARD = frozenset( (
    'colori', 'comuni', 'condizioni_pagamento', 'continenti', 'embed', 'iva', 'lingue',
    'modalita_pagamento', 'periodicita', 'provincie', 'regimi', 'regioni',
    'ruoli_anagrafica', 'ruoli_articoli', 'ruoli_audio', 'ruoli_file', 'ruoli_immagini',
    'ruoli_indirizzi', 'ruoli_mail', 'ruoli_matricole', 'ruoli_prodotti', 'ruoli_video',
    'settori', 'stati', 'stati_lingue', 'udm', 'valute',
) )

ASSISTITE = frozenset( (
    'categorie_anagrafica', 'certificazioni', 'listini', 'ranking', 'reparti', 'task',
    'tipologie_anagrafica', 'tipologie_attivita', 'tipologie_chiavi', 'tipologie_contatti',
    'tipologie_contratti', 'tipologie_documenti', 'tipologie_documenti_articoli',
    'tipologie_indirizzi', 'tipologie_licenze', 'tipologie_luoghi', 'tipologie_mastri',
    'tipologie_notizie', 'tipologie_pagamenti', 'tipologie_popup', 'tipologie_prodotti',
    'tipologie_progetti', 'tipologie_pubblicazioni', 'tipologie_risorse',
    'tipologie_telefoni', 'tipologie_todo', 'tipologie_url',
) )

GESTITE = frozenset( (
    'account', 'account_gruppi', 'account_gruppi_attribuzione', 'anagrafica',
    'anagrafica_categorie', 'anagrafica_certificazioni', 'anagrafica_cittadinanze',
    'anagrafica_consensi', 'anagrafica_indirizzi', 'anagrafica_settori', 'articoli',
    'articoli_caratteristiche', 'attivita', 'audio', 'banner', 'banner_azioni',
    'banner_pagine', 'banner_zone', 'caratteristiche', 'carrelli', 'carrelli_articoli',
    'carrelli_consensi', 'carrelli_documenti', 'categorie_notizie', 'categorie_prodotti',
    'categorie_progetti', 'categorie_risorse', 'causali', 'chiavi', 'colli', 'consensi',
    'consensi_moduli', 'contatti', 'contenuti', 'contratti', 'coupon',
    'coupon_categorie_prodotti', 'coupon_listini', 'coupon_marchi', 'coupon_prodotti',
    'documenti', 'documenti_articoli', 'file', 'gruppi', 'iban', 'immagini', 'indirizzi',
    'job', 'licenze', 'licenze_software', 'liste', 'liste_mail', 'listini_clienti',
    'luoghi', 'macro', 'mail', 'mail_out', 'mail_sent', 'mailing', 'mailing_liste',
    'mailing_mail', 'marchi', 'mastri', 'matricole', 'menu', 'metadati', 'notizie',
    'notizie_categorie', 'organizzazioni', 'pagamenti', 'pagine', 'pianificazioni',
    'popup', 'popup_pagine', 'prezzi', 'prodotti', 'prodotti_caratteristiche',
    'prodotti_categorie', 'progetti', 'progetti_anagrafica', 'progetti_articoli',
    'progetti_categorie', 'progetti_certificazioni', 'progetti_matricole',
    'pubblicazioni', 'redirect', 'relazioni_anagrafica', 'relazioni_documenti',
    'relazioni_documenti_articoli', 'relazioni_pagamenti', 'relazioni_progetti',
    'relazioni_software', 'rinnovi', 'rinnovi_documenti_articoli', 'risorse',
    'risorse_account', 'risorse_anagrafica', 'risorse_categorie', 'sms_out', 'sms_sent',
    'software', 'telefoni', 'template', 'testate', 'todo', 'todo_matricole', 'url',
    'video',
) )


##  tabelle gestite che questo strumento non tocca comunque, mai, nemmeno con --svuota
#
#   Sono gestite a tutti gli effetti, ma il loro contenuto non è "dati di lavoro": è la
#   configurazione del deploy, e cancellarla significa spegnere il sito. Il caso che ha
#   fatto nascere questa lista è account: anagrafica.id -> account.id_anagrafica è una
#   CASCADE, quindi un banale DELETE FROM anagrafica porterebbe via tutti gli account e
#   con loro la possibilità di fare il login. Le anagrafiche collegate a un account
#   vengono infatti risparmiate dallo svuotamento ( vedi _schema.tools.py ).
PROTETTE = frozenset( (
    'account',
    'account_gruppi',
    'account_gruppi_attribuzione',
    'gruppi',
    'job',
    'macro',
    'menu',
    'pagine',
    'pianificazioni',
    'redirect',
    'task',
    'template',
) )


##  le viste materializzate
#
#   `<entita>_view_static` non è né standard né gestita: è una **copia** di `<entita>_view`,
#   tenuta ferma su disco perché alimenta le tendine grosse senza rifare il join a ogni
#   richiesta. Non contiene dati propri — il suo contenuto si ricalcola per intero dalla
#   vista — quindi riscriverla non è "scrivere dati", è rimettere in pari una cache. Per
#   questo sta fuori dalle tre categorie e ha una funzione sua.
#
#   L'elenco canonico delle statiche di un deploy è in
#   `_usr/_database/_patch/_080000999999.static.sql`; qui si guarda il database, che è la
#   cosa che si sta per toccare.
SUFFISSO_VISTA_STATICA = '_view_static'


def vista_statica( tabella ):

    ##  \brief vero se la tabella è una vista materializzata

    return tabella.endswith( SUFFISSO_VISTA_STATICA )


##  categorie, in ordine di severità decrescente
SCONOSCIUTA = 'sconosciuta'
STANDARD_ETICHETTA = 'standard'
ASSISTITA = 'assistita'
GESTITA = 'gestita'
PROTETTA = 'protetta'


def classifica( tabella ):

    ##  \brief ritorna la categoria di una tabella

    if tabella in PROTETTE:
        return PROTETTA

    if tabella in STANDARD:
        return STANDARD_ETICHETTA

    if tabella in ASSISTITE:
        return ASSISTITA

    if tabella in GESTITE:
        return GESTITA

    return SCONOSCIUTA


def scrivibile( tabella ):

    ##  \brief vero se lo strumento può inserire righe in questa tabella

    return classifica( tabella ) == GESTITA


def leggibile_per_lookup( tabella ):

    ##  \brief vero se lo strumento può pescare da questa tabella valori di riferimento

    return classifica( tabella ) in ( STANDARD_ETICHETTA, ASSISTITA, GESTITA )


def verifica_scrivibili( tabelle ):

    ##  \brief controlla che tutte le tabelle di un piano siano scrivibili
    #   \return una lista di messaggi di errore, vuota se è tutto a posto

    problemi = []

    for tabella in tabelle:

        categoria = classifica( tabella )

        if categoria == GESTITA:
            continue

        if categoria == STANDARD_ETICHETTA:
            problemi.append( '%s è una tabella STANDARD: contiene dati del framework e non si tocca' % tabella )
        elif categoria == ASSISTITA:
            problemi.append( '%s è una tabella ASSISTITA: si legge per prendere tipologie e categorie, non si riempie' % tabella )
        elif categoria == PROTETTA:
            problemi.append( '%s è una tabella PROTETTA: contiene la configurazione del deploy' % tabella )
        else:
            problemi.append( '%s non è classificata: aggiungila a _catalogo.tools.py prima di usarla' % tabella )

    return problemi
