<form id="databaseEditForm">
<table class="databaseedit">
		<tr>
			<td>
				<div class="control-group">
					<label class="control-label">{t d='arkeogis' m="Dernière mise à jour"}</label>
					<div class="controls">
						<input name="declared_modification" id="declared_modification" type="text" value="{$infos.declared_modification_str}" readonly />
						<p class="help-block">{t d='arkeogis' m="Date de la dernière mise à jour de la base ou du dernier export (base inventaire)"}</p>	
					</div>
				</div>
			</td>
			<td>
				<div class="control-group">
					<label class="control-label">{t d='arkeogis' m="Numéro ISSN"}</label>
					<div class="controls">
						<input name="issn" type="text" value="{$infos.issn}"></div>
					</div>
					<p class="help-block">&nbsp;</p>
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
		<tr>
			<td colspan="2"><hr /></td>
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
						<p class="help-block">{t d='arkeogis' m="Merci de présenter en quelques lignes votre base de données (dans la champ de saisie ci-dessus) en langue française."}</p>	
					</div>
				</div>
			</td>
			<td>
				<div class="control-group">
					<label class="control-label">{t d='arkeogis' m="Description de la base DE"}</label>
					<div class="controls">
						<textarea name="description_de" style="height: 120px">{$infos.description_de}</textarea>
						<p class="help-block">{t d='arkeogis' m="Merci de présenter en quelques lignes votre base de données (dans la champ de saisie ci-dessus) en langue allemande."}</p>	
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