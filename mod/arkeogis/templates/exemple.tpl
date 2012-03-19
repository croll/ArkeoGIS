{extends tplextends('arkeogis/public')}

{block name='arkeogis_content'}
<div id="exemples" class="content">
	<ul id="slider-menu" class="tabs">
		<li class="tab active"><a data-update="request" class="success" href="page/requetes">{t d='arkeogis' m='Requêtes'}<i></i></a></li>
		<li class="tab" ><a  data-update="maps" class="primary" href="page/cartes">{t d='arkeogis' m='Cartes'}</a></li>
		<li  class="tab" ><a  data-update="fiche" class="primary" href="page/fiche_site">{t d='arkeogis' m='Fiche site'}</a></li>
	</ul>
	<div id="slider-component" >
		<div id="request" class="row selected">
			<h2>{t d='arkeogis' m='Requêtes'}</h2>
			<img src="/mod/arkeogis/img/slide/requete.jpg" />
		</div>
		<div id="maps" class="row">
			<h2>{t d='arkeogis' m='Maps'}</h2>
			<img src="/mod/arkeogis/img/slide/maps.jpg" />
		</div>
		<div id="fiche" class="row">
			<h2>{t d='arkeogis' m='Fiche'}</h2>
			<img src="/mod/arkeogis/img/slide/fiche.jpg" />
		</div>
	</div>
</div>
{literal}
<script>
	var myex= new Example({updateElement: 'slider-menu'});
</script>
{/literal}
{/block}

