{extends tplextends('arkeogis/layout')}

{block name='webpage_head' append}
  {js file="/mod/arkeogis/ext/MooDatePicker/js/MooDatePicker.js"}
  {css file="/mod/arkeogis/ext/MooDatePicker/css/MooDatePicker.css"} 
{/block}

{block name='arkeogis_content'}

	<script>
		function validateTerms(el) {
			if ($('terms').get('checked')) {
				$('submit').set('disabled', false);
			} else {
				$('submit').set('disabled', true);
			}
		}
    window.addEvent('domready', function() {
	    var myMooDatePicker = new MooDatePicker(document.getElement('input[name=declared_modification]'), {
	      onPick: function(date){
	        this.element.set('value', date.format('%e/%m/%Y'));
	      }
	    });
    });
  </script>
	{if !isset($result)}

		{form mod="arkeogis" file="templates/dbUpload.json"}
			<div>
				<div class="alert alert-warn">
				{t d='arkeogis' m="Les données de la base importée dans le service ArkéoGIS sont librement consultables par des personnes identifiées par le service Arkeogis, ces données sont exportables à des fins de recherche par des personnes identifiées par le service Arkeogis comme chercheurs ou Administrateur du service."}
				<div style="margin-top:10px;font-weight:bold">{t d='arkeogis' m="J'accepte ces conditions"}&nbsp;<input id="terms" type="checkbox" onchange="validateTerms()" /></div>
				</div>
			</div>
				
			<fieldset>
				<legend>{t d='arkeogis' m="Import d'une base"}</legend>
				<div class="control-group">
					<label class="control-label">{t d='arkeogis' m="Type de base"}</label>
					<div class="controls">
						<select name="select_type">
							<option value="inventory">{t d="arkeogis" m="Inventaire"}</option>
							<option value="research">{t d="arkeogis" m="Recherche"}</option>
						</select>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">{t d='arkeogis' m="Dernière mise à jour"}</label>
					<div class="controls">
						{$dbUpload.declared_modification}
					<p class="help-block">{t d='arkeogis' m="Date de la dernière mise à jour de la base ou du dernier export (base inventaire)"}</p>	
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">{t d='arkeogis' m="Limite géographique d'emprise de la base"}</label>
					<div class="controls">
					{$dbUpload.geographical_limit}
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">{t d='arkeogis' m="Échelle de résolution des points"}</label>
					<div class="controls">
						<select name="select_scale_resolution">
							<option value="site">{t d="arkeogis" m="Site"}</option>
							<option value="watershed">{t d="arkeogis" m="Bassin versant"}</option>
							<option value="micro-region">{t d="arkeogis" m="Micro-région"}</option>
							<option value="region">{t d="arkeogis" m="Région"}</option>
							<option value="country">{t d="arkeogis" m="Pays"}</option>
							<option value="europe">{t d="arkeogis" m="Europe"}</option>
						</select>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">{t d='arkeogis' m="Description de la base FR"}</label>
					<div class="controls">
					{$dbUpload.description}
					<p class="help-block">{t d='arkeogis' m="Merci de présenter en quelques lignes votre base de données (dans la champ de saisie ci-dessus) en langue française, nous pouvons assurer cette traduction pour vous. Merci d'utiliser le formulaire de contact d'ArkeoGIS (sujet : demande de traduction) pour faire votre demande"}</p>	
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">{t d='arkeogis' m="Description de la base DE"}</label>
					<div class="controls">
					{$dbUpload.description_de}
					<p class="help-block">{t d='arkeogis' m="Merci de présenter en quelques lignes votre base de données (dans la champ de saisie ci-dessus) en langue allemande, nous pouvons assurer cette traduction pour vous. Merci d'utiliser le formulaire de contact d'ArkeoGIS (sujet : demande de traduction) pour faire votre demande"}</p>	
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">{t d='arkeogis' m="Séparateur"}</label>
					<div class="controls">
					{$dbUpload.separator}
					<p class="help-block">{t d='arkeogis' m="Utilisez"} \t {t d='arkeogis' m="pour une tabulation"}</p>	
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">{t d='arkeogis' m="Lignes à ignorer"}</label>
					<div class="controls">
						{$dbUpload.skipline}
					<p class="help-block">{t d='arkeogis' m="Nombre de ligne en début de fichier à ne pas traiter"}</p>	
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">{t d='arkeogis' m="Caractère d'échappement"}</label>
					<div class="controls">
						{$dbUpload.enclosure}
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">{t d='arkeogis' m="Langue"}</label>
					<div class="controls">
						<select name="select_lang">
							<option value="fr">{t d="arkeogis" m="Français"}</option>
							<option value="de">{t d="arkeogis" m="Allemand"}</option>
						</select>
					<p class="help-block">{t d='arkeogis' m="Langue utilisée pour caractériser les périodes/mobilier/immobilier"}</p>	
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">{t d='arkeogis' m="Fichier à analyser"}</label>
					<div class="controls">
						{$dbUpload.dbfile}
					</div>
				</div>
				<div class="form-actions">
						{$dbUpload.submit}
				</div>
			</fieldset>
		{/form}

	{else}
		<a href="/import/">{t d="arkeogis" m="Effectuer un autre import"}</a>
		<div style="width: 100%; margin: 0px auto 10px auto">
			<div style="padding:3px"><i class="icon-align-justify" style="margin-right: 3px"></i><b>{$result.total}</b> {t d='arkeogis' m="lignes traitées"}.</div>
			<div style="padding:3px"><i class="icon-ok" style="margin-right: 3px"></i><b>{$result.processed}</b>  {t d='arkeogis' m="sites importés"}.</div>
			<div style="padding:3px"><i class="icon-exclamation-sign" style="margin-right: 3px"></i><b>{$result.errors|sizeof}</b>  {t d='arkeogis' m="erreurs (voir ci dessous)"}</div>
		</div>	

		<table class="table table-striped table-bordered table-condensed" style="width: 1200px; margin: 0px auto 50px auto">
			<thead>
				<tr>
					<th>Code</th>
					<th>Error</th>
				</tr>
			</thead>
			<tbody>
			{foreach $result.errors as $item}
				{foreach $item as $it}
						<tr>
							<td>{$item@key}</td>
							<td>
								{foreach $it.msg as $msg}
									{$msg}<br />
								{/foreach}
							</td>
						</tr>
				{/foreach}
			{/foreach}
			</tbody>
		</table>

		{if is_array($result.processingErrors) && sizeof($result.processingErrors) > 0}
		<div style="font-weight: bold">Debug</div>
		<table class="table table-striped table-bordered table-condensed" style="width: 1200px; margin: 0px auto 50px auto">
			<thead>
				<tr>
					<th>Code</th>
					<th>Error</th>
				</tr>
			</thead>
			<tbody>
			{foreach $result.processingErrors as $item}
				{foreach $item as $it}
						<tr>
							<td>{$item@key}</td>
							<td>
								{foreach $it.msg as $msg}
									{$msg}<br />
								{/foreach}
							</td>
						</tr>
				{/foreach}
			{/foreach}
			</tbody>
		</table>
		{/if}

	{/if}

{/block}
