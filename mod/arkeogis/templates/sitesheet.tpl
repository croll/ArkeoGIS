<div id="sitesheet">
	<div class="datesauthor">{t d='arkeogis' m='Date de création de la fiche'} : {$infos.creation}{if ($infos.creation != $infos.modification)}  |  {t d='arkeogis' m='Date de modification de la fiche'} : {$infos.modification} {/if}  |  {t d='arkeogis' m='Base'} : {$infos.database}  |  {t d='arkeogis' m='Identifiant'} : {$infos.code}  |  {t d='arkeogis' m='Auteur'} : {if !empty($infos.author)}{$infos.author}{else}ArkeoGIS{/if}</div>

	<div class="geoinfos">
		{if $infos.city.name}
		<div>{t d='arkeogis' m='Nom de la commune'} : {$infos.city.name}  {if $infos.city.code} &nbsp;&nbsp; {t d='arkeogis' m='Code commune'} : {$infos.city.code}{/if}</div>
		{/if}
		
		<div>{t d='arkeogis' m='Coordonnées'} : {t d='arkeogis' m='Long'} : {$infos.geom[0]} &nbsp;&nbsp; {t d='arkeogis' m='Lat'} : {$infos.geom[1]}
		{if ($infos.geom[2] != -999)} 
		  &nbsp;&nbsp;{t d='arkeogis' m='Altitude'} : {$infos.geom[2]}
		{/if}
		</div>
	</div>

	<div class="bluebackground">{t d='arkeogis' m='Centroïde de la commune'}</div>
	<div class="floatleft">{if ($infos.centroid == 1)}{t d='arkeogis' m='Oui'}{else}{t d='arkeogis' m='Non'}{/if}</div>
	

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
				<span style="text-transform: uppercase">
				{if ($periodCharacteristics.datas.knowledge == 'unknown')}
					{t d='arkeogis' m='Inconnue'}
				{else if ($periodCharacteristics.datas.knowledge == 'literature')}
					{t d='arkeogis' m='Littérature / Prospection'}
				{else if ($periodCharacteristics.datas.knowledge == 'surveyed')}
					{t d='arkeogis' m='Sondé'}
				{else if ($periodCharacteristics.datas.knowledge == 'excavated')}
					{t d='arkeogis' m='Fouillé'}
				{/if}
				</span>
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

		{/foreach}

		{if sizeof($periodCharacteristics.datas.comment) > 0}
			<div class="title">{t d='arkeogis' m='Commentaires'}</div>
			<div class="blockcharac">
				<div class="charac">
					<div class="limiter">
						{$periodCharacteristics.datas.comment|nl2br}
					</div>
				</div>
				<div class="clearfix"></div>
			</div>
		{/if}

		{if isset($periodCharacteristics.datas.bibliography)}
			<div class="title">{t d='arkeogis' m='Bibliographie'}</div>
			<div class="blockcharac">
				<div class="charac">
					<div class="limiter">
						{$periodCharacteristics.datas.bibliography|nl2br}
					</div>
				</div>
				<div class="clearfix"></div>
			</div>
		{/if}
		{/foreach}
		</div>
	{/foreach}

</div>
