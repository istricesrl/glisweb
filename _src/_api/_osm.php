<?php

    define( 'DIR_BASE', str_replace( '_src/_api' , NULL , dirname( __FILE__ ) ) );

    // die( __FILE__ );
    // die( DIR_BASE );

    require DIR_BASE . '_src/_lib/_filesystem.tools.php';

    $ttl = 86400; // cache timeout in seconds

#    $ttl = 60 * 60 * 24 * ; // cache timeout in seconds

    $x = intval($_GET['x']);
    $y = intval($_GET['y']);
    $z = intval($_GET['z']);
#    $r = strip_tags($_GET['r']);

    appendToFile( 'richiesta tela ' . $z . '/' . $x . '/' . $y . PHP_EOL, 'var/log/osm/cache.' . date( 'Ymd' ) . '.log' );

#    switch ($r)
#    {
#      case 'mapnik':
#      default:
        $r = 'mapnik';
#        break;
#      case 'osma':
#        $r = 'osma';
#        break;
#    }

    $file = DIR_BASE . "var/cache/osm/tiles/$r/${z}_${x}_${y}.png";

    appendToFile( 'file: ' . $file . PHP_EOL, 'var/log/osm/cache.' . date( 'Ymd' ) . '.log' );

    checkFolder( "/var/cache/osm/tiles/$r/" );

    if (!is_file($file) || filemtime($file)<time()-(86400*30) || filesize($file)==0)
    {
      $server = array();
      switch ($r)
      {
        case 'mapnik':
          $server[] = 'a.tile.openstreetmap.org';
          $server[] = 'b.tile.openstreetmap.org';
          $server[] = 'c.tile.openstreetmap.org';

          $url = 'https://'.$server[array_rand($server)];
          $url .= "/".$z."/".$x."/".$y.".png";
          break;

        case 'osma':
        default:
          $server[] = 'a.tah.openstreetmap.org';
          $server[] = 'b.tah.openstreetmap.org';
          $server[] = 'c.tah.openstreetmap.org';

          $url = 'https://'.$server[array_rand($server)].'/Tiles/tile.php';
          $url .= "/".$z."/".$x."/".$y.".png";
          break;
      }
      $ch = curl_init($url);
      $fp = fopen($file, "wb");
#1      curl_setopt($ch, CURLOPT_FILE, $fp);
#1      curl_setopt($ch, CURLOPT_BINARYTRANSFER,1);
#1      curl_setopt($ch, CURLOPT_HEADER, 0);
#1      curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
#1      curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
#1      curl_setopt($ch, CURLOPT_USERAGENT, 'Mozilla/5.0');
#1      curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
curl_setopt($ch, CURLOPT_VERBOSE, 1);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
#curl_setopt($ch, CURLOPT_AUTOREFERER, false);
#curl_setopt($ch, CURLOPT_HTTP_VERSION, CURL_HTTP_VERSION_1_1);
#curl_setopt($ch, CURLOPT_HEADER, 0);
curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0); // <-- don't forget this
curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0); // <-- and this
curl_setopt($ch, CURLOPT_USERAGENT,'GlisWeb/2020.1 contact produzione@istricesrl.it');
      $e = curl_exec($ch);
      if( $e === false ) { appendToFile( 'errore: ' . curl_error( $ch ) . PHP_EOL, 'var/log/osm/cache.' . date( 'Ymd' ) . '.log' ); }
      curl_close($ch);
#1      fflush($fp);
fwrite($fp, $e);
      fclose($fp);
 appendToFile( 'url chiamato: ' . $url . PHP_EOL, 'var/log/osm/cache.' . date( 'Ymd' ) . '.log' );
    }


// phpinfo();

#error_reporting(E_ALL);

    $exp_gmt = gmdate("D, d M Y H:i:s", time() + $ttl * 60) ." GMT";
    $mod_gmt = gmdate("D, d M Y H:i:s", filemtime($file)) ." GMT";
    // for MSIE 5
#    header("Cache-Control: pre-check=" . $ttl * 60, FALSE);  
#    header ('Content-Type: image/png');
#            header("Content-Disposition: attachment; filename=\"".basename($filename)."\";");

#    header('Content-Length: ' . filesize($file));
#    readfile($file);
#    die();

#    ob_flush();

#$handle = fopen($file, "rb");
#$contents = fread($handle, filesize($file));
#fclose($handle);

#echo $contents;

// die( $file );
$im = imagecreatefrompng($file);
header('Expires: ' . $exp_gmt);
header('Last-Modified: ' . $mod_gmt);
header('Cache-Control: public, max-age=' . $ttl * 60);
header('Content-Type: image/png');
#header('Content-Length: ' . filesize($file) );
// header('Content-Disposition: attachment; filename="'.basename($file).'";');
imagepng($im);

#imagedestroy($im);

#$im = imagecreatefromjpeg($file);
#header('Content-Type: image/jpeg');
#imagejpeg($im);
#imagedestroy($im);
