<?php

    /**
     * template mail del modulo contatti
     * =================================
     *
     * I due template usati da _mod/_CT000.contatti/_src/_inc/_controllers/_form/_mail.php: l'avviso interno con
     * tutti i campi del modulo compilato e il ringraziamento a chi l'ha compilato. Sono gli stessi di
     * _mod/_0300.contatti/_src/_config/_350.mail.php, che con _0300 spento non li dichiara più nessuno.
     *
     * Il testo del ringraziamento è un segnaposto: un progetto che usa la controller mail lo riscrive, insieme al
     * mittente, in mod/CT000.contatti/src/config/350.mail.php, che si carica dopo questo file.
     *
     * @file
     *
     */

    // avviso interno per ogni modulo compilato sul sito
    $cf['mail']['tpl']['DEFAULT_CONTATTI'] = array(
        'type' => 'twig',
        'it-IT' => array(
            'oggetto' => 'invio modulo: {{ dt.modulo }}',
            'testo' => '<ul>{% for k,v in dt %}<li><b>{{ k }}:</b> {% if v is iterable %}<ul>'.
                '{% for kk,vv in v %}<li><b>{{ kk }}:</b> {{ vv }}</li>{% endfor %}</ul>'.
                '{% else %}{{ v }}{% endif %}</li>{% endfor %}</ul>'
        )
    );

    // ringraziamento a chi compila un modulo sul sito
    $cf['mail']['tpl']['DEFAULT_RINGRAZIAMENTO_CONTATTI'] = array(
        'type' => 'twig',
        'it-IT' => array(
            'oggetto' => 'grazie {{ dt.nome }}!',
            'testo' => 'caro {{ dt.nome }}, grazie per averci contattati!'
        )
    );
