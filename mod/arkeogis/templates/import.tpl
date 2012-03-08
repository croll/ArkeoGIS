{extends tplextends('arkeogis/layout')}

{block name='arkeogis_content'}

	{if !isset($result)}

		{form mod="arkeogis" file="templates/dbUpload.json"}
			<fieldset>
				<legend>{t d='arkeogis' m="Import d'une base"}</legend>
				<div class="control-group">
					<label class="control-label">{t d='arkeogis' m="Séparateur"}</label>
					<div class="controls">
					{$dbUpload.separator}
					<p class="help-block">{t d='arkeogis' m="Utilisez \\t pour une tabulation"}</p>	
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
					<label class="control-label">Langue</label>
					<div class="controls">
						{$dbUpload.select_lang}
					<p class="help-block">{t d='arkeogis' m="Langue utilisée pour caractériser les périodes/mobilier/immobilier"}</p>	
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Fichier à analyser</label>
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
			<div style="padding:3px"><i class="icon-align-justify" style="margin-right: 3px"></i><b>{$result.total}</b> sites processed.</div>
			<div style="padding:3px"><i class="icon-ok" style="margin-right: 3px"></i><b>{$result.processed}</b> sites imported.</div>
			<div style="padding:3px"><i class="icon-exclamation-sign" style="margin-right: 3px"></i><b>{$result.errors|sizeof}</b> Errors (see below)</div>
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
