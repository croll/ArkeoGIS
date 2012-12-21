<div id="sitesheet">

	<div class="datesauthor">{t d='arkeogis' m='Date de création de la fiche'} : {$infos.creation}{if ($infos.creation != $infos.modification)} | {t d='arkeogis' m='Date de modification de la fiche'} : {$infos.modification} {/if} | Auteur : {if !empty($infos.author)}{$infos.author}{else}ArkeoGIS{/if}</div>

	<div class="geoinfos">
		{if $infos.city.name}
		<div>{t d='arkeogis' m='Nom de la commune'} : {$infos.city.name}</div>
		{/if}
		{if $infos.city.code}
		<div>{t d='arkeogis' m='Code commune'} : {$infos.city.code}</div>
		{/if}
		<div>{t d='arkeogis' m='Coordonnées'} : {$infos.geom[0]} {$infos.geom[1]} </div>
		{if ($infos.geom[2] != -999)} 
			<div>{t d='arkeogis' m='Altitude'} : {$infos.geom[2]}</div>
		{/if}
	</div>

	{if ($infos.centroid == 1)}
		<div class="bluebackground">{t d='arkeogis' m='Centroïde de la commune'}</div>
		<div class="floatleft">{t d='arkeogis' m='Oui'}</div>
	{/if}

	<div class="bluebackground">{t d='arkeogis' m='Occupation du site'}</div>
	<div class="floatleft">
		{if ($infos.occupation == 'unknown')}
			{t d='arkeogis' m='Inconnue'}
		{else if ($infos.occupation == 'uniq')}
			{t d='arkeogis' m='Unique'}
		{else if ($infos.occupation == 'continuous')}
			{t d='arkeogis' m='Continue'}
		{else if ($infos.occupation == 'multiple')}
			{t d='arkeogis' m='Multiple'}
		{/if}
	</div>

	<div class="clearfix"></div>
	
		{foreach $infos.characteristics as $periodHash => $characteristics}
		{foreach $characteristics as $charac}
	
		<div class="periodcharacs">

			{if isset($charac.knowledge) && !empty($charac.knowledge)}
			<div class="title">{t d='arkeogis' m='Etat des connaissances'}: 
				{if ($charac.knowledge == 'unknown')}
					{t d='arkeogis' m='Inconnue'}
				{else if ($charac.knowledge == 'literature')}
					{t d='arkeogis' m='Littérature / Prospection'}
				{else if ($charac.knowledge == 'surveyed')}
					{t d='arkeogis' m='Sondé'}
				{else if ($charac.knowledge == 'excavated')}
					{t d='arkeogis' m='Fouillé'}
				{/if}
			</div>
			{/if}

			<div class="title">{t d='arkeogis' m='Période'}</div>

			<div class="periodstart">
				<div class="lib">{t d='arkeogis' m='Début'}: </div>
				{foreach $charac.start as $name}
					<div class="period">{$name}</div>
					{if !$name@last}
						<div class="sep">&gt;</div>
					{/if}
				{/foreach}
				<div class="clearfix"></div>
			</div>

			<div class="periodend">
				<div class="lib">{t d='arkeogis' m='Fin'}: </div>
				{foreach $charac.end as $name}
					<div class="period">{$name}</div>
					{if !$name@last}
						<div class="sep">&gt;</div>
					{/if}
				{/foreach}
				<div class="clearfix"></div>
			</div>

			{if isset($charac.realestate)}
				<div class="title {if (isset($charac.realestate_exp) && $charac.realestate_exp)}exceptional{/if}">{t d='arkeogis' m='Immobilier'}</div>
				<div class="blockcharac">
					{foreach $charac.realestate as $name}
						<div class="charac">{$name}</div>
						{if !$name@last}
							<div class="sep">&gt;</div>
						{/if}
					{/foreach}
					<div class="clearfix"></div>
				</div>
			{/if}

			{if isset($charac.furniture)}
				<div class="title {if (isset($charac.furniture_exp) && $charac.furniture_exp)}exceptional{/if}">{t d='arkeogis' m='Mobilier'}</div>
				<div class="blockcharac">
					{foreach $charac.furniture as $name}
						<div class="charac">{$name}</div>
						{if !$name@last}
							<div class="sep">&gt;</div>
						{/if}
					{/foreach}
					<div class="clearfix"></div>
				</div>
			{/if}

			{if isset($charac.production)}
				<div class="title {if (isset($charac.production_exp) && $charac.production_exp)}exceptional{/if}">{t d='arkeogis' m='Production'}</div>
				<div class="blockcharac">
					{foreach $charac.production as $name}
						<div class="charac">{$name}</div>
						{if !$name@last}
							<div class="sep">&gt;</div>
						{/if}
					{/foreach}
					<div class="clearfix"></div>
				</div>
			{/if}

			{if isset($charac.comment)}
				<div class="title">{t d='arkeogis' m='Commentaires'}</div>
				<div class="blockcharac">
					<div class="charac">{$charac.comment|nl2br}</div>
					<div class="clearfix"></div>
				</div>
			{/if}

			{if isset($charac.bibliography)}
				<div class="title">{t d='arkeogis' m='Bibliographie'}</div>
				<div class="blockcharac">
					<div class="charac">{$charac.bibliography|nl2br}</div>
					<div class="clearfix"></div>
				</div>
			{/if}

		</div>
		{/foreach}
		{/foreach}

</div>
