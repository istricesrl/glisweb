<?php

    // imposta timezone coerente
    date_default_timezone_set('Europe/Rome');

    // funzione per sanificare testo ICS
    function icsEscape(string $value): string {
        $value = str_replace("\\", "\\\\", $value);
        $value = str_replace(";", "\;", $value);
        $value = str_replace(",", "\,", $value);
        $value = str_replace(["\r\n", "\r", "\n"], "\\n", $value);
        return $value;
    }

    // recupero dati da GET
    $titolo = $_GET['titolo'] ?? 'Evento';
    $descrizione = $_GET['descrizione'] ?? '';
    $luogo = $_GET['luogo'] ?? '';
    $inizio = $_GET['inizio'] ?? '';
    $fine = $_GET['fine'] ?? '';

    // validazione minima
    if (!$inizio || !$fine) {
        http_response_code(400);
        echo 'Parametri mancanti';
        exit;
    }

    $dtStart = strtotime($inizio);
    $dtEnd   = strtotime($fine);

    if (!$dtStart || !$dtEnd) {
        http_response_code(400);
        echo 'Date non valide';
        exit;
    }

    // formato ICS: UTC oppure local time.
    // Qui uso UTC per compatibilità massima.
    $dtStamp = gmdate('Ymd\THis\Z');
    $dtStartIcs = gmdate('Ymd\THis\Z', $dtStart);
    $dtEndIcs   = gmdate('Ymd\THis\Z', $dtEnd);

    $uid = uniqid('evento-', true) . '@tuodominio.it';

    $ics = "BEGIN:VCALENDAR\r\n";
    $ics .= "VERSION:2.0\r\n";
    $ics .= "PRODID:-//TuoProgetto//IT\r\n";
    $ics .= "CALSCALE:GREGORIAN\r\n";
    $ics .= "METHOD:PUBLISH\r\n";
    $ics .= "BEGIN:VEVENT\r\n";
    $ics .= "UID:" . $uid . "\r\n";
    $ics .= "DTSTAMP:" . $dtStamp . "\r\n";
    $ics .= "DTSTART:" . $dtStartIcs . "\r\n";
    $ics .= "DTEND:" . $dtEndIcs . "\r\n";
    $ics .= "SUMMARY:" . icsEscape($titolo) . "\r\n";
    $ics .= "DESCRIPTION:" . icsEscape($descrizione) . "\r\n";
    $ics .= "LOCATION:" . icsEscape($luogo) . "\r\n";
    $ics .= "END:VEVENT\r\n";
    $ics .= "END:VCALENDAR\r\n";

    // nome file
    $filename = 'evento.ics';

    // output
    header('Content-Type: text/calendar; charset=utf-8');
    header('Content-Disposition: attachment; filename="' . $filename . '"');
    header('Content-Length: ' . strlen($ics));

    echo $ics;
    exit;
