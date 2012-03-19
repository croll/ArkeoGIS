{extends tplextends('arkeogis/public')}

{block name='arkeogis_content'}

<div id="manual" class="content">
	<ul id="manual-menu" class="tabs">
		<li class="tab active"><a class="primary selected" href="manuel_requetes">{t d='arkeogis' m='Requêtes'}</a></li>
		<li class="tab"><a class="primary" href="manuel_cartes">{t d='arkeogis' m='Cartes'}</a></li>
		<li class="tab"><a class="primary" href="manuel_fiches">{t d='arkeogis' m='Fiches'}</a></li>
		<li class="tab"><a class="primary" href="manuel_import">{t d='arkeogis' m='Import'}</a></li>
		<li class="tab"><a class="primary" href="chronologie">{t d='arkeogis' m='Chronologie'}</a></li>
		<li class="tab"><a class="primary" href="immobiliers">{t d='arkeogis' m='Immobiliers'}</a></li>
		<li class="tab"><a class="primary" href="mobiliers">{t d='arkeogis' m='Mobiliers'}</a></li>
		<li class="tab"><a class="primary" href="productions">{t d='arkeogis' m='Production'}</a></li>
		<li class="tab"><a class="primary" href="faq">{t d='arkeogis' m='FAQ'}</a></li>
	</ul>
	<div id="content"></div>
</div>
{literal}
<script>
 var myman= new Manual({updateElement: 'manual-menu'});
</script>
{/literal}
{/block}
