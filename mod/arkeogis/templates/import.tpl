{extends tplextends('arkeogis/layout')}

{block name='arkeogis_content'}

	<!--
	{form mod="arkeogis" id="dbUpload" file="templates/dbUpload.json"}
		<div>Sep: {$dbUpload.separator}</div>
		{$dbUpload.select_carriagereturn}
		{$dbUpload.select_encoding}
		{$dbUpload.dbfile}
		{$dbUpload.submit}
	{/form}
	-->

	{if isset($result)}

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

	{/if}

{/block}
