<?php

    // lingua di questo file
	$l = 'it-IT';

    // pagina degli strumenti
	$p['strumenti'] 	= array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'strumenti' ),
	    'h1'			=> array( $l		=> 'strumenti' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'strumenti.html' ),
	    'macro'			=> array( '_src/_inc/_macro/_strumenti.php' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'auth'			=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'			=> array( 'tabs'	=> array(	'strumenti' ) ),
		'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'strumenti' ),
									'priority'	=> '950' ) ) )
	);

    // vista mail in uscita
	$p['mail.out.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'mail in uscita' ),
	    'h1'			=> array( $l		=> 'in uscita' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'			=> array( '_src/_inc/_macro/_mail.out.view.php' ),
	    'parent'		=> array( 'id'		=> 'strumenti' ),
	    'auth'			=> array( 'groups'	=> array(	'roots' ) ),
		'etc'			=> array( 'tabs'	=> array(	'mail.out.view',
													'mail.sent.view',
													'template.mail.view',
													'mail.tools'
												 ) ),
		'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'mail' ),
								'priority'	=> '950' ) ) )
	);

    // gestione mail in uscita
	$p['mail.out.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'mail.out.form.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_mail.out.form.php' ),
	    'parent'		=> array( 'id'		=> 'mail.out.view' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> array(	'mail.out.form',
													'mail.out.form.file',
													'mail.out.form.tools'
												 ) ),
	);

	// gestione file mail in uscita
	$p['mail.out.form.file'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-folder-open-o" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'file' ),
		'h1'		=> array( $l		=> 'file' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'mail.out.form.file.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_mail.out.form.file.php' ),
	    'parent'		=> array( 'id'		=> 'mail.out.view' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['mail.out.form']['etc']['tabs'] )
	);

    // gestione strumenti mail in uscita
	$p['mail.out.form.tools'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'strumenti code mail' ),
	    'h1'		=> array( $l		=> 'strumenti' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_mail.out.form.tools.php' ),
	    'parent'		=> array( 'id'		=> 'mail.out.view' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['mail.out.form']['etc']['tabs'] )
	);

    // vista mail inviate
	$p['mail.sent.view'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'mail inviate' ),
	    'h1'		=> array( $l		=> 'inviate' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_mail.sent.view.php' ),
	    'parent'		=> array( 'id'		=> 'strumenti' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['mail.out.view']['etc']['tabs'] )
	);

    // gestione mail inviate
	$p['mail.sent.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'mail.sent.form.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_mail.sent.form.php' ),
	    'parent'		=> array( 'id'		=> 'mail.sent.view' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> array(	'mail.sent.form',
													'mail.sent.form.tools'
												 ) ),
	);

	// strumenti mail
	$p['mail.tools'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'strumenti mail' ),
		'h1'		=> array( $l		=> 'strumenti mail' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
		'macro'		=> array( '_src/_inc/_macro/_mail.tools.php' ),
		'parent'		=> array( 'id'		=> 'strumenti' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['mail.out.view']['etc']['tabs'] )
	);

    // vista template mail
	$p['template.mail.view'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'template mail' ),
		'h1'		=> array( $l		=> 'template' ),
	    'template'	=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_template.mail.view.php' ),
		'parent'	=> array( 'id'		=> 'strumenti' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['mail.out.view']['etc']['tabs'] )
	);

	// gestione template mail
	$p['template.mail.form'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'gestione' ),
		'h1'		=> array( $l		=> 'gestione' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'template.mail.form.html' ),
		'macro'		=> array( '_src/_inc/_macro/_template.mail.form.php' ),
		'parent'		=> array( 'id'		=> 'template.mail.view' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> array(	'template.mail.form',
												'template.mail.form.testo',
												'template.mail.form.file' ) ),
	);

	// form template mail testo
	$p['template.mail.form.testo'] = array(
	    'sitemap'		=> false,
		'icon'			=> '<i class="fa fa-file-text-o" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'testo' ),
	    'h1'		=> array( $l		=> 'testo' ),
	    'parent'		=> array( 'id'		=> 'template.mail.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'template.mail.form.testo.html' ),
		'macro'		=> array( '_src/_inc/_macro/_template.mail.form.testo.php' ),
		'etc'		=> array( 'tabs'	=> $p['template.mail.form']['etc']['tabs'] ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) )
	);

	// gestione template file
	$p['template.mail.form.file'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-folder-open-o" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'file' ),
		'h1'		=> array( $l		=> 'file' ),
		'parent'		=> array( 'id'		=> 'template.mail.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'template.mail.form.file.html' ),
		'macro'		=> array( '_src/_inc/_macro/_template.mail.form.file.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['template.mail.form']['etc']['tabs'] )
	);

	// vista job
	$p['job.view'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'job' ),
		'h1'		=> array( $l		=> 'job' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'		=> array( '_src/_inc/_macro/_job.view.php' ),
		'parent'		=> array( 'id'		=> 'strumenti' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> array(	'job.view', 'job.tools' ) ),
		'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'job' ),
																		'priority'	=> '960' ) ) )
		);

    // tools job
	$p['job.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'job.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'				=> array( '_src/_inc/_macro/_job.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['job.view']['etc']['tabs'] )
	);

	// gestione job
	$p['job.form'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'gestione' ),
		'h1'		=> array( $l		=> 'gestione' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'job.form.html' ),
		'macro'		=> array( '_src/_inc/_macro/_job.form.php' ),
		'parent'		=> array( 'id'		=> 'job.view' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> array(	'job.form',

													) ),
	);
		
	// vista task
	$p['task.view'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'task' ),
		'h1'		=> array( $l		=> 'task' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'		=> array( '_src/_inc/_macro/_task.view.php' ),
		'parent'		=> array( 'id'		=> 'strumenti' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> array(	'task.view',) ),
		'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'task' ),
																		'priority'	=> '970' ) ) )
		);

	// gestione job
	$p['task.form'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'gestione' ),
		'h1'		=> array( $l		=> 'gestione' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'task.form.html' ),
		'macro'		=> array( '_src/_inc/_macro/_task.form.php' ),
		'parent'		=> array( 'id'		=> 'task.view' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> array(	'task.form',
													'task.form.tools'
													) ),
	);

    // gestione strumenti mail in uscita
	$p['task.form.tools'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'strumenti task' ),
	    'h1'		=> array( $l		=> 'strumenti' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_task.form.tools.php' ),
	    'parent'		=> array( 'id'		=> 'task.view' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['task.form']['etc']['tabs'] )
	);

/*
    // pagina gestione cron
	$p['cron'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'cron' ),
	    'h1'		=> array( $l		=> 'cron' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'view.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_cron.view.php' ),
	    'parent'		=> array( 'id'		=> 'strumenti' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'menu'		=> array( 'admin'	=> array(	'label'		=> array( $l => 'gestione cron' ),
									'priority'	=> 50 ) )
	);

    // pagina gestione cron
	$p['cron_gestione'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'cron.gestione.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_cron.gestione.php' ),
	    'parent'		=> array( 'id'		=> 'cron' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'cron_gestione' ) )
	);

    // pagina gestione job
	$p['job'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'job' ),
	    'h1'		=> array( $l		=> 'job' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'view.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_job.view.php' ),
	    'parent'		=> array( 'id'		=> 'strumenti' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'menu'		=> array( 'admin'	=> array(	'label'		=> array( $l => 'gestione job' ),
									'priority'	=> 100 ) )
	);

    // pagina gestione singolo job
	$p['job_gestione'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'job.gestione.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_job.gestione.php' ),
	    'parent'		=> array( 'id'		=> 'job' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) )
	);

    // coda mail in uscita
	$p['mail_out'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'mail in uscita' ),
	    'h1'		=> array( $l		=> 'mail in uscita' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'view.html' ),
	    'parent'		=> array( 'id'		=> 'strumenti' ),
	    'macro'		=> array( '_src/_inc/_macro/_mail.out.view.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'menu'		=> array( 'admin'	=> array(	'label'		=> array( $l => 'gestione mail' ),
									'priority'	=> 100 ) ),
	    'etc'		=> array( 'tabs'	=> array(	'mail_out',
									'mail_sent',
									'template' ) )
	);

    // gestione mail in uscita
	$p['mail_out_gestione'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'mail.out.gestione.html' ),
	    'parent'		=> array( 'id'		=> 'mail_out' ),
	    'macro'		=> array( '_src/_inc/_macro/_mail.out.gestione.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) )
	);

    // coda mail inviate
	$p['mail_sent'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'mail inviate' ),
	    'h1'		=> array( $l		=> 'mail inviate' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'view.html' ),
	    'parent'		=> array( 'id'		=> 'strumenti' ),
	    'macro'		=> array( '_src/_inc/_macro/_mail.sent.view.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> $p['mail_out']['etc']['tabs'] )
	);

    // gestione mail inviate
	$p['mail_sent_gestione'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'mail.sent.gestione.html' ),
	    'parent'		=> array( 'id'		=> 'mail_sent' ),
	    'macro'		=> array( '_src/_inc/_macro/_mail.sent.gestione.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) )
	);

    // vista template mail
	$p['template'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'template' ),
	    'h1'		=> array( $l		=> 'template' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'view.html' ),
	    'parent'		=> array( 'id'		=> 'strumenti' ),
	    'macro'		=> array( '_src/_inc/_macro/_template.mail.view.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> $p['mail_out']['etc']['tabs'] )
	);

    // gestione template mail
	$p['template_gestione'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'template.mail.gestione.html' ),
	    'parent'		=> array( 'id'		=> 'template' ),
	    'macro'		=> array( '_src/_inc/_macro/_template.mail.gestione.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'template_gestione',
									'template_gestione_contenuti',
									'template_gestione_allegati' ) )
	);

    // gestione contenuti template mail
	$p['template_gestione_contenuti'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'testo' ),
	    'h1'		=> array( $l		=> 'testo' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'template.mail.gestione.contenuti.html' ),
	    'parent'		=> array( 'id'		=> 'template' ),
	    'macro'		=> array( '_src/_inc/_macro/_template.mail.gestione.php', '_src/_inc/_macro/_template.mail.gestione.contenuti.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> $p['template_gestione']['etc']['tabs'] )
	);

    // gestione allegati template mail
	$p['template_gestione_allegati'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'allegati' ),
	    'h1'		=> array( $l		=> 'allegati' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'template.mail.gestione.allegati.html' ),
	    'parent'		=> array( 'id'		=> 'template' ),
	    'macro'		=> array( '_src/_inc/_macro/_template.mail.gestione.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> $p['template_gestione']['etc']['tabs'] )
	);

    // coda SMS in uscita
	$p['sms_out'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'SMS in uscita' ),
	    'h1'		=> array( $l		=> 'SMS in uscita' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'view.html' ),
	    'parent'		=> array( 'id'		=> 'strumenti' ),
	    'macro'		=> array( '_src/_inc/_macro/_sms.out.view.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'menu'		=> array( 'admin'	=> array(	'label'		=> array( $l => 'gestione SMS' ),
									'priority'	=> 100 ) ),
	    'etc'		=> array( 'tabs'	=> array(	'sms_out',
									'sms_sent' ) )
	);

    // gestione SMS in uscita
	$p['sms_out_gestione'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'sms.out.gestione.html' ),
	    'parent'		=> array( 'id'		=> 'sms_out' ),
	    'macro'		=> array( '_src/_inc/_macro/_sms.out.gestione.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) )
	);

    // coda SMS inviati
	$p['sms_sent'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'SMS inviati' ),
	    'h1'		=> array( $l		=> 'SMS inviati' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'view.html' ),
	    'parent'		=> array( 'id'		=> 'strumenti' ),
	    'macro'		=> array( '_src/_inc/_macro/_sms.sent.view.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> $p['sms_out']['etc']['tabs'] )
	);

    // gestione SMS inviati
	$p['sms_sent_gestione'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'sms.sent.gestione.html' ),
	    'parent'		=> array( 'id'		=> 'sms_sent' ),
	    'macro'		=> array( '_src/_inc/_macro/_sms.sent.gestione.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) )
	);

    // visualizzazione log
	$p['log'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'log' ),
	    'h1'		=> array( $l		=> 'log' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'view.html' ),
	    'parent'		=> array( 'id'		=> 'strumenti' ),
	    'macro'		=> array( '_src/_inc/_macro/_log.view.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'menu'		=> array( 'admin'	=> array(	'label'		=> array( $l => 'gestione log' ),
									'priority'	=> 850 ) )
	);

    // gestione mail in uscita
	$p['log_gestione'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'log.gestione.html' ),
	    'parent'		=> array( 'id'		=> 'log' ),
	    'macro'		=> array( '_src/_inc/_macro/_log.gestione.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) )
	);

    // gestione configurazione
	if( ! file_exists( DIR_BASE . 'src/config/external/config.json' ) ) {
	    $p['configurazione'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'configurazione' ),
		'h1'		=> array( $l		=> 'configurazione' ),
		'template'	=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'configurazione.gestione.html' ),
		'parent'	=> array( 'id'		=> 'strumenti' ),
		'macro'		=> array( '_src/_inc/_macro/_configurazione.gestione.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> array(	'configurazione' ) ),
		'menu'		=> array( 'admin'	=> array(	'label'		=> array( $l => 'configurazione' ),
									'priority'	=> 900 ) )
	    );
	}
*/
