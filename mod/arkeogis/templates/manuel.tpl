{extends tplextends('arkeogis/public')}

{block name='arkeogis_content'}

<div id="manual" class="content">
	<ul id="manual-menu" class="tabs">
		<li class="tab {if $tab eq 'requetes'}active{/if}"><a class="primary selected" href="{\mod\page\Main::getTranslated('manuel_requetes', $lang)}">{t d='arkeogis' m='Requêtes'}</a></li>
		<li class="tab {if $tab eq 'cartes'}active{/if}"><a class="primary" href="{\mod\page\Main::getTranslated('manuel_cartes', $lang)}">{t d='arkeogis' m='Cartes'}</a></li>
		<li class="tab {if $tab eq 'fiches'}active{/if}"><a class="primary" href="{\mod\page\Main::getTranslated('manuel_fiches', $lang)}">{t d='arkeogis' m='Fiches'}</a></li>
		<li class="tab {if $tab eq 'import'}active{/if}"><a class="primary" href="{\mod\page\Main::getTranslated('manuel_import', $lang)}">{t d='arkeogis' m='Import'}</a></li>
		<li class="tab {if $tab eq 'chronologie'}active{/if}"><a class="primary" href="{\mod\page\Main::getTranslated('chronologie', $lang)}">{t d='arkeogis' m='Chronologie'}</a></li>
		<li class="tab {if $tab eq 'immobiliers'}active{/if}"><a class="primary" href="{\mod\page\Main::getTranslated('immobiliers', $lang)}">{t d='arkeogis' m='Immobiliers'}</a></li>
		<li class="tab {if $tab eq 'mobiliers'}active{/if}"><a class="primary" href="{\mod\page\Main::getTranslated('mobiliers', $lang)}">{t d='arkeogis' m='Mobiliers'}</a></li>
		<li class="tab {if $tab eq 'productions'}active{/if}"><a class="primary" href="{\mod\page\Main::getTranslated('productions', $lang)}">{t d='arkeogis' m='Production'}</a></li>
		<li class="tab {if $tab eq 'faq'}active{/if}"><a class="primary" href="{\mod\page\Main::getTranslated('faq', $lang)}">{t d='arkeogis' m='FAQ'}</a></li>
	</ul>
	<div id="content"></div>
</div>
{literal}
<script>
 var myman= new Manual({updateElement: 'manual-menu'});
</script>
{/literal}
{/block}
