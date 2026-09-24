window.addEventListener('DOMContentLoaded', function() {

        CodeMirror.defineMode('twig-htmlmixed', function(config) {
            const htmlmixed = CodeMirror.getMode(config, 'htmlmixed');

            const twigOverlay = {
                token: function(stream) {
                    // commenti Twig {# ... #}
                    if (stream.match('{#')) {
                        while (!stream.eol()) {
                            if (stream.match('#}')) {
                                return 'comment';
                            }
                            stream.next();
                        }
                        return 'comment';
                    }

                    // output Twig {{ ... }}
                    if (stream.match('{{')) {
                        while (!stream.eol()) {
                            if (stream.match('}}')) {
                                return 'meta';
                            }
                            stream.next();
                        }
                        return 'meta';
                    }

                    // tag Twig {% ... %}
                    if (stream.match('{%')) {
                        while (!stream.eol()) {
                            if (stream.match('%}')) {
                                return 'keyword';
                            }
                            stream.next();
                        }
                        return 'keyword';
                    }

                    while (stream.next() != null) {
                        if (
                            stream.match('{#', false) ||
                            stream.match('{{', false) ||
                            stream.match('{%', false)
                        ) {
                            break;
                        }
                    }

                    return null;
                }
            };

            return CodeMirror.overlayMode(htmlmixed, twigOverlay);
        });

    document.querySelectorAll('textarea.CodeMirror').forEach(function(textarea) {

        CodeMirror.fromTextArea(textarea, {
            lineNumbers: true,
            mode: 'twig-htmlmixed',
            theme: 'default',
            tabSize: 4,
            indentUnit: 4,
            indentWithTabs: false,
            lineWrapping: true,
            matchBrackets: true,
            autoCloseBrackets: true,
            autoCloseTags: true,
            foldGutter: true,
            gutters: ['CodeMirror-linenumbers', 'CodeMirror-foldgutter'],
            extraKeys: {
                'Ctrl-Space': 'autocomplete'
            }
        });

    });

});
