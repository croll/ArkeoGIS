<div id="sitesheet">
	<div class="datesauthor"> {t d='arkeogis' m='Auteur'} : {$infos.author}  {if $infos.declared_modification_str}| {t d='arkeogis' m='Date de dernière mise à jour'} : {$infos.declared_modification_str}{/if} </div>

	<div class="geoinfos">
		{if $infos.issn}
		<div style="margin-bottom:10px">{t d='arkeogis' m='Numéro ISSN'} : {$infos.issn}</div>
		{/if}
		
		<div>{t d='arkeogis' m='Type de base'} : {$infos.type}</div>
	</div>

	<div class="bluebackground">{t d='arkeogis' m='Nombre de sites'}</div>
	<div class="floatleft">{$infos.sites}</div>	

	<div class="bluebackground">{t d='arkeogis' m='Nombre de lignes'}</div>
	<div class="floatleft">{$infos.lines}</div>	

	<div class="bluebackground">{t d='arkeogis' m='Publiée'}</div>
	<div class="floatleft">{if ($infos.published == 't')}{t d='arkeogis' m='Oui'}{else}{t d='arkeogis' m='Non'}{/if}</div>
		
	<div class="clearfix"></div>
	
	<div class="periodcharacs">

		{if $infos.period_start || $infos.period_end}
			<div class="title">{t d='arkeogis' m='Période'}</div>

			{if $infos.period_start}
			<div class="periodstart">
				<div class="lib">{t d='arkeogis' m='Début'}: </div>
					<div class="period">{$infos.period_start}</div>
				<div class="clearfix"></div>
			</div>
			{/if}

			{if $infos.period_end}
			<div class="periodend">
				<div class="lib">{t d='arkeogis' m='Fin'}: </div>
					<div class="period">{$infos.period_end}</div>
				<div class="clearfix"></div>
			</div>
			{/if}
		{/if}

		{if $infos.geographical_limit}
		<div class="title">{t d='arkeogis' m='Limite géographique'}</div>
		<div class="blockcharac">
			<div class="charac">{$infos.geographical_limit}</div>
			<div class="clearfix"></div>
		</div>
		{/if}

		{if $infos.scale_resolution}
		<div class="title">{t d='arkeogis' m='Echelle'}</div>
		<div class="blockcharac">
			<div class="charac">{$infos.scale_resolution}</div>
			<div class="clearfix"></div>
		</div>
		{/if}

		{if $infos.description}
		<div class="title">{t d='arkeogis' m='Description'}</div>
		<div class="blockcharac">
			<div class="charac">{$infos.description|nl2br}</div>
			<div class="clearfix"></div>
		</div>
		{/if}

	</div>

</div>
