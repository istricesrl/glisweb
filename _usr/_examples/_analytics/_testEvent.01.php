<?php

    require '../../../_src/_config.php';

    if (!isset($_COOKIE['_cid']) || empty($_COOKIE['_cid'])) {
        setcookie('_cid', vsprintf('%s%s-%s-%s-%s-%s%s%s', str_split(bin2hex(random_bytes(16)), 4, '/; SameSite=strict')));
    }
    $data = '{"client_id":"'.$_COOKIE['_cid'].'","events":[{"name":"custom_event_02","params":{"page_location":"https://glisweb.istricesrl.it/_usr/_examples/_analytics/"}}]}';

    $url = 'https://www.google-analytics.com/mp/collect?api_secret='.$cf['google']['profile']['analytics']['mp']['secret'].'&measurement_id='.$cf['google']['profile']['analytics']['ua'];
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_USERAGENT, $_SERVER['HTTP_USER_AGENT']);
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json']);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    $response = curl_exec($ch);
    $errors = curl_error($ch);
    $status = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);
    echo $response;
    var_dump($errors);
    var_dump($status);
