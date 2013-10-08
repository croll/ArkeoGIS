<form id="databaseEditForm" style="margin:0!important">
<table class="databaseedit">
		<tr>
			<td>
				<div class="control-group">
				<label class="control-label">{t d='arkeogis' m="Nom de la base"}</label>
					<div class="controls">
						<input name="name" type="text" value="{$infos.name}" />
					</div>
				</div>
			</td>
			<td>
				{if \mod\user\Main::userBelongsToGroup('Admin')}
				<div class="control-group">
				<label class="control-label">{t d='arkeogis' m="Base attribuée à"}</label>
					<div class="controls">
						<input name="author" id="author" type="text" value="{$infos.author}" onclick="this.value = ''" />
					</div>
				</div>
				{/if}
			</td>
		</tr>
		<tr>
			<td>
				<div class="control-group">
					<label class="control-label">{t d='arkeogis' m="Dernière mise à jour"}</label>
					<div class="controls">
						<input name="declared_modification" id="declared_modification" type="text" value="{$infos.declared_modification_str}" readonly />
					</div>
				</div>
			</td>
			<td>
				<div class="control-group">
					<label class="control-label">{t d='arkeogis' m="Numéro ISSN"}</label>
					<div class="controls">
						<input name="issn" type="text" value="{$infos.issn}"></div>
					</div>
				</div>
			</td>
		</tr>
		<tr>
			<td>
				<div class="control-group">
					<label class="control-label">{t d='arkeogis' m="Échelle de résolution des points"}</label>
					<div class="controls">
						<select name="scale_resolution">
							<option value="site"{if $infos.scale_resolution == 'site'} selected{/if}>{t d="arkeogis" m="Site"}</option>
							<option value="watershed"{if $infos.scale_resolution == 'watershed'} selected{/if}>{t d="arkeogis" m="Bassin versant"}</option>
							<option value="micro-region"{if $infos.scale_resolution == 'micro-region'} selected{/if}>{t d="arkeogis" m="Micro-région"}</option>
							<option value="region"{if $infos.scale_resolution == 'region'} selected{/if}>{t d="arkeogis" m="Région"}</option>
							<option value="country"{if $infos.scale_resolution == 'country'} selected{/if}>{t d="arkeogis" m="Pays"}</option>
							<option value="europe"{if $infos.scale_resolution == 'europe'} selected{/if}>{t d="arkeogis" m="Europe"}</option>
						</select>
					</div>
				</div>	
			</td>
			<td>
				<div class="control-group">
					<label class="control-label">{t d='arkeogis' m="Type de base"}</label>
					<div class="controls">
						<select name="type">
							<option value="research"{if $infos.type == 'research'} selected{/if}>{t d="arkeogis" m="Recherche"}</option>
							<option value="inventory"{if $infos.type == 'inventory'} selected{/if}>{t d="arkeogis" m="Inventaire"}</option>
						</select>
					</div>
				</div>	
			</td>
		</tr>
		</tr>
		<tr>
			<td>
				<div class="control-group">
					<label class="control-label">{t d='arkeogis' m="Limite géographique d'emprise de la base FR"}</label>
					<div class="controls">
						<textarea name="geographical_limit">{$infos.geographical_limit}</textarea>
					</div>
				</div>
			</td>
			<td>

				<div class="control-group">
					<label class="control-label">{t d='arkeogis' m="Limite géographique d'emprise de la base DE"}</label>
					<div class="controls">
						<textarea name="geographical_limit_de">{$infos.geographical_limit_de}</textarea>
					</div>
				</div>
			</td>
		</tr>
		<tr>
			<td>
				<div class="control-group">
					<label class="control-label">{t d='arkeogis' m="Description de la base FR"}</label>
					<div class="controls">
						<textarea name="description" style="height: 120px">{$infos.description}</textarea>
					</div>
				</div>
			</td>
			<td>
				<div class="control-group">
					<label class="control-label">{t d='arkeogis' m="Description de la base DE"}</label>
					<div class="controls">
						<textarea name="description_de" style="height: 120px">{$infos.description_de}</textarea>
					</div>
				</div>
			</td>
		</tr>	
		{if \mod\user\Main::userBelongsToGroup('Admin')}
			<tr>
				<td>
				<div class="control-group">
				<label class="control-label">{t d='arkeogis' m="Mettre en ligne"}</label>
					<div class="controls">
						<select name="published">
							<option value="1"{if $infos.published == '1'} selected{/if}>{t d="arkeogis" m="Publié"}</option>
							<option value="0"{if $infos.published == '0'} selected{/if}>{t d="arkeogis" m="Non publié"}</option>
						</select>	
					</div>
				</div>
				</td>
				<td>
				</td>
			</tr>
		{/if}
</table>
</form>