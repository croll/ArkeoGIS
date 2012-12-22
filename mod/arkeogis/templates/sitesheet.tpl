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
	
		{foreach $infos.characteristics as $periodHash => $periodCharacteristics}
	
		<div class="periodcharacs">

			{if isset($periodCharacteristics.datas.knowledge) && !empty($periodCharacteristics.datas.knowledge)}
			<div class="title">{t d='arkeogis' m='Etat des connaissances'}: 
				{if ($periodCharacteristics.datas.knowledge == 'unknown')}
					{t d='arkeogis' m='Inconnue'}
				{else if ($periodCharacteristics.datas.knowledge == 'literature')}
					{t d='arkeogis' m='Littérature / Prospection'}
				{else if ($periodCharacteristics.datas.knowledge == 'surveyed')}
					{t d='arkeogis' m='Sondé'}
				{else if ($periodCharacteristics.datas.knowledge == 'excavated')}
					{t d='arkeogis' m='Fouillé'}
				{/if}
			</div>
			{/if}

			<div class="title">{t d='arkeogis' m='Période'}</div>

			<div class="periodstart">
				<div class="lib">{t d='arkeogis' m='Début'}: </div>
				{foreach $periodCharacteristics.datas.start as $name}
					<div class="period">{$name}</div>
					{if !$name@last}
						<div class="sep">&gt;</div>
					{/if}
				{/foreach}
				<div class="clearfix"></div>
			</div>

			<div class="periodend">
				<div class="lib">{t d='arkeogis' m='Fin'}: </div>
				{foreach $periodCharacteristics.datas.end as $name}
					<div class="period">{$name}</div>
					{if !$name@last}
						<div class="sep">&gt;</div>
					{/if}
				{/foreach}
				<div class="clearfix"></div>
			</div>

			{foreach $periodCharacteristics.caracs as $characteristics}
			{foreach $characteristics as $type=>$carac}

			{if $type == 'realestate' && sizeof($carac) > 0}
				<div class="title">{t d='arkeogis' m='Immobilier'}</div>
				{foreach $carac as $realestate}
					<div class="blockcharac{if $realestate[1]} exceptional{/if}">
						{foreach $realestate[0] as $name}
							<div class="charac">{$name}</div>
							{if !$name@last}
								<div class="sep">&gt;</div>
							{/if}
						{/foreach}
						<div class="clearfix"></div>
					</div>
				{/foreach}
			{/if}

			{if $type == 'furniture' && sizeof($carac) > 0}
				<div class="title">{t d='arkeogis' m='Mobilier'}</div>
				{foreach $carac as $furniture}
					<div class="blockcharac{if $furniture[1]} exceptional{/if}">
						{foreach $furniture[0] as $name}
							<div class="charac">{$name}</div>
							{if !$name@last}
								<div class="sep">&gt;</div>
							{/if}
						{/foreach}
						<div class="clearfix"></div>
					</div>
				{/foreach}
			{/if}

			{if $type == 'production' && sizeof($carac) > 0}
				<div class="title">{t d='arkeogis' m='Production'}</div>
				{foreach $carac as $production}
					<div class="blockcharac{if $production[1]} exceptional{/if}">
						{foreach $production[0] as $name}
							<div class="charac">{$name}</div>
							{if !$name@last}
								<div class="sep">&gt;</div>
							{/if}
						{/foreach}
						<div class="clearfix"></div>
					</div>
				{/foreach}
			{/if}

			{if $type == 'landscape' && sizeof($carac) > 0}
				<div class="title">{t d='arkeogis' m='Paysage'}</div>
				{foreach $carac as $landscape}
					<div class="blockcharac{if $landscape[1]} exceptional{/if}">
						{foreach $landscape[0] as $name}
							<div class="charac">{$name}</div>
							{if !$name@last}
								<div class="sep">&gt;</div>
							{/if}
						{/foreach}
						<div class="clearfix"></div>
					</div>
				{/foreach}
			{/if}

			{if sizeof($carac.comment) > 0}
				<div class="title">{t d='arkeogis' m='Commentaires'}</div>
				<div class="blockcharac">
					<div class="charac">{$carac.comment|nl2br}</div>
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

		{/foreach}
		{/foreach}
		</div>
	{/foreach}

</div>
