<?php

    /**
     * API per l'erogazione delle tele OpenStreetMap
     * 
     * questo script fa da proxy/cache per le tele OSM in modo da non sovraccaricare i server OSM
     * 
     * 
     * TODO documentare
     * 
     * 
     */

    // definizione della directory di base
    define('DIR_BASE', str_replace('_src/_api', NULL, dirname(__FILE__)));

    // funzione per la creazione ricorsiva delle directory
    function checkPath($p, $r = 0775) {
        return (is_dir($p)) ? true : mkdir($p, $r, true);
    }

    // funzione di log
    function logger($m, $f = 'core', $l = LOG_DEBUG) {
        if (! defined('LOG_CURRENT_LEVEL') || $l <= LOG_CURRENT_LEVEL) {
            checkPath(dirname(DIR_VAR_LOG . $f));
            $lvl = array(0 => 'emerg', 1 => 'alert', 2 => 'crit', 3 => 'err', 4 => 'warning', 5 => 'notice', 6 => 'info', 7 => 'debug');
            $h = fopen(DIR_VAR_LOG . $f . '.' . $lvl[$l] . '.' . date('Ym') . '.log', 'a+');
            fwrite($h, date('Y-m-d H:i:s') . ' (' . $l . ') ' . str_replace('§', PHP_EOL . "\t\t\t\t\t--> ", $m) . PHP_EOL);
            fclose($h);
        }
    }

    // debug
    // die( __FILE__ );
    // die( DIR_BASE );

    // timeout della cache
    $ttl = 86400;

    // coordinate richieste
    $x = intval($_GET['x']);
    $y = intval($_GET['y']);
    $z = intval($_GET['z']);

    // tipo di mappa
    $r = 'mapnik';

    // nome del file della tela richiesta
    $file = DIR_BASE . "var/cache/osm/tiles/$r/" . $z . "_" . $x . "_" . $y . ".png";

    // controllo della cartella
    checkPath(DIR_BASE . "/var/cache/osm/tiles/$r/");

    // se il file non esiste o è scaduto lo scarico
    if (!is_file($file) || filemtime($file) < time() - (86400 * 30) || filesize($file) == 0) {
        $server = array();
        switch ($r) {
            case 'mapnik':
                $server[] = 'a.tile.openstreetmap.org';
                $server[] = 'b.tile.openstreetmap.org';
                $server[] = 'c.tile.openstreetmap.org';

                $url = 'https://' . $server[array_rand($server)];
                $url .= "/" . $z . "/" . $x . "/" . $y . ".png";
                break;

            case 'osma':
            default:
                $server[] = 'a.tah.openstreetmap.org';
                $server[] = 'b.tah.openstreetmap.org';
                $server[] = 'c.tah.openstreetmap.org';

                $url = 'https://' . $server[array_rand($server)] . '/Tiles/tile.php';
                $url .= "/" . $z . "/" . $x . "/" . $y . ".png";
                break;
        }
        $ch = curl_init($url);
        $fp = fopen($file, "wb");
        curl_setopt($ch, CURLOPT_VERBOSE, 1);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
        curl_setopt($ch, CURLOPT_USERAGENT, 'GlisWeb/2020.1 contact produzione@istricesrl.it');
        $e = curl_exec($ch);
        curl_close($ch);
        fwrite($fp, $e);
        fclose($fp);
    }

    // validità del file
    $exp_gmt = gmdate("D, d M Y H:i:s", time() + $ttl * 60) . " GMT";
    $mod_gmt = gmdate("D, d M Y H:i:s", filemtime($file)) . " GMT";

    // invio del file
    $im = imagecreatefrompng($file);
    header('Expires: ' . $exp_gmt);
    header('Last-Modified: ' . $mod_gmt);
    header('Cache-Control: public, max-age=' . $ttl * 60);
    header('Content-Type: image/png');
    imagepng($im);
