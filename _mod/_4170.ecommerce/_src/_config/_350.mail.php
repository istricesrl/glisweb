<?php

    /**
     * configurazioni generali della posta
     *
     *
     *
     *
     *
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

# TODO il from va specificato per forza, perché dichiarato in questo modo non è "sovrascritto" dalla configurazione custom
#            'from' => array( 'GlisWeb' => 'noreply@glisweb.videoarts.eu' ),

    // array dei template mail
	$cf['mail']['tpl']['DEFAULT_NOTIFICA_INTERNA_ACQUISTO'] = array(
	    'type' => 'twig',
	    'it-IT' => array(
            'oggetto' => 'ricevuto ordine: #{{ dt.id }}',
            'testo' => '
                <ul>{% for k,v in dt %}
                    {% if v is not empty and k not in __exclude__ %}
                        <li><b>{{ k }}:</b>
                            {% if v is iterable %}
                                <ul>
                                    {% for kk,vv in v %}
                                        {# if vv is not empty and kk not in __exclude__ #}
                                            <li><b>{{ kk }}:</b>
                                                {% if vv is iterable %}
                                                    <ul>
                                                        {% for kkk,vvv in vv %}
                                                        <li><b>{{ kkk }}:</b> {{ vvv }}</li>
                                                        {% endfor %}
                                                    </ul>
                                                {% else %}
                                                    {{ vv }}
                                                {% endif %}
                                            </li>
                                        {# endif #}
                                    {% endfor %}
                                </ul>
                            {% else %}
                                {{ v }}
                            {% endif %}
                        </li>
                    {% endif %}
                    {% endfor %}
                </ul>
            '
	    )
	);

	$cf['mail']['tpl']['DEFAULT_NOTIFICA_ESTERNA_ACQUISTO'] = array(
	    'type' => 'twig',
	    'it-IT' => array(
            'oggetto' => 'conferma d\'ordine #{{ dt.id }}',
            'testo' => 'caro {{ dt.nome }}, il tuo ordine è stato ricevuto!'
	    )
	);

# TODO specificare nello status se i from non sono specificati?
