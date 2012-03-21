<div id="sitesheet">

	<div class="datesauthor">{t d='arkeogis' m='Date de création de la fiche'} : {$infos.creation}{if ($infos.creation != $infos.modification)} | {t d='arkeogis' m='Date de modification de la fiche'} : {$infos.modification} {/if} | Auteur : {if !empty($infos.author)}{$infos.author}{else}ArkeoGIS{/if}</div>

	<div class="geoinfos">
		{if $infos.city.name}
		<div>{t d='arkeogis' m='Nom de la commune'} : {$infos.city.name}</div>
		{/if}
		{if $infos.city.code}
		<div>{t d='arkeogis' m='Code commune'} : {$infos.city.code}</div>
		{/if}
		<div>{t d='arkeogis' m='Coordonnées'} : {$infos.geom[0]} {$infos.geom[1]} {if ($infos.geom[3]) != -999} {$infos.geom[3]}{/if} </div>
	</div>

	{if ($infos.centroid == 1)}
		<div class="bluebackground">{t d='arkeogis' m='Centroïde de la commune'}</div>
		<div class="floatleft">{t d='arkeogis' m='Oui'}</div>
	{/if}

	<div class="bluebackground">{t d='arkeogis' m='Etat des connaissances'}</div>
	<div class="floatleft">{$infos.knowledge}</div>

	<div class="bluebackground">{t d='arkeogis' m='Occupation du site'}</div>
	<div class="floatleft">{$infos.occupation}</div>

	<div class="clearfix"></div>
	

	<div class="periodcharacs">
		{foreach $infos.characteristics as $charac}
			<div id="title">{t d='arkeogis' m='Période'}</div>
			<div id="periostart">
			{foreach $charac.start as $name}
				<div class="period">{$name}</div>
			{/foreach}
			</div>
			<div id="perioend">
			{foreach $charac.end as $name}
				<div class="period">{$name}</div>
			{/foreach}
			</div>

			{if isset($charac.realestate)}
				<div class="title {if ($charac.furniture_exp)}exceptional{/if}">{t d='arkeogis' m='Immobilier'}</div>
				{foreach $charac.realestate as $name}
					<div class="charac">{$name}</div>
				{/foreach}
				<div class="clearfix"></div>
			{/if}

			{if isset($charac.furniture)}
				<div class="title {if ($charac.furniture_exp)}exceptional{/if}">{t d='arkeogis' m='Immobilier'}</div>
				{foreach $charac.furniture as $name}
					<div class="charac">{$name}</div>
				{/foreach}
				<div class="clearfix"></div>
			{/if}

			{if isset($charac.production)}
				<div class="title {if ($charac.production_exp)}exceptional{/if}">{t d='arkeogis' m='Production'}</div>
				{foreach $charac.production as $name}
					<div class="charac">{$name}</div>
				{/foreach}
				<div class="clearfix"></div>
			{/if}

		{/foreach}
	</div>

</div>
