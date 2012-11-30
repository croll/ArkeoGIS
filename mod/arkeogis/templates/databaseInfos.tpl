<div class="databaseInfos">

	<div><span>{t d='arkeogis' m="Type de base"}: </span>
		{if $infos.type == 'inventory'}
			{t d="arkeogis" m="Inventaire"}
		{else}
			{t d="arkeogis" m="Recherche"}
		{/if}
	</div> 

	<div><span>{t d='arkeogis' m="Échelle de résolution des points"}:</span> 
	{if $infos.type == 'watershed'}
		{t d="arkeogis" m="Bassin versant"}
	{elseif $infos.type == 'micro-region'}
		{t d="arkeogis" m="Micro-région"}
	{elseif $infos.type == 'region'}
		{t d="arkeogis" m="Région"}
	{elseif $infos.type == 'country'}
		{t d="arkeogis" m="Pays"}
	{elseif $infos.type == 'europe'}
		{t d="arkeogis" m="Europe"}
	{else}
		{t d="arkeogis" m="Site"}
	{/if}
	</div>

	{if $infos.geographical_limit}
	<div>
	<span>{t d='arkeogis' m="Limite géographique d'emprise de la base"}:</span> {$infos.geographical_limit|nl2br}
	</div>
	{/if}

	{if !empty($infos.declared_modification)}
	<div>
	<span>{t d='arkeogis' m="Dernière mise à jour"}:</span> {$infos.declared_modification}
	</div>
	{/if}

	{if !empty($infos.description) && $currentLang == 'fr_FR'}
	<div><span>{t d='arkeogis' m="Description de la base FR"}:</span> <br />
		{$infos.description|nl2br}
	</div>
	{/if}

	{if !empty($infos.description_de) && $currentLang == 'de_DE'}
	<div><span>{t d='arkeogis' m="Description de la base DE"}:</span> <br />
		{$infos.description_de|nl2br}
	</div>
	{/if}

</div>
