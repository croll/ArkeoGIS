{extends tplextends('arkeogis/layout')}

{block name='webpage_head' append}
	{js file="/pmmenus"}
	{js file="/mod/arkeogis/js/plusminusmenu.js"}
	{js file="/mod/arkeogis/js/sheet.js"}
	{js file="/mod/arkeogis/js/page_mapquery.js"}
	<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false" ></script>
{/block}

{block name='arkeogis_content'}
	<div id="map_container">

		<div id="map_area">

			<!-- end of map menu -->
			<div id="map_canvas">
			</div>

			        <div id="onglet">
				</div>
				<div id="map_menu">
					<table class='map-query' border='0' cellspacing='0' cellpadding='0'>

					 <tr class="menu_archives">
						<td colspan='2'>
						 <select id='select-savedqueries'>
							<option>{t d='arkeogis' m="Requêtes archivées"}</option>
						 </select>
						</td>
					 </tr>

					 <tr class="troistrucs">
					   <td colspan='2'>
					     <table style='width: 100%'>
					       <tr>
						 <td style='text-align: center'>
						   <div id='menu-centroid' style='position: relative'></div>
						 </td><td>
						   <div id='menu-knowledge' style='position: relative'></div>
						 </td><td>
						   <div id='menu-occupation' style='position: relative'></div>
						 </td>
					       </tr>
					     </table>
					   </td>
					 </tr>

					 <tr class="menu_db">
						<td colspan='2'><div id='menu_db' style='position: relative'></div></td>
					 </tr>

					 <tr class="menu_period">
						<td colspan='2'><div id='menu_period' style='position: relative'></div></td>
					 </tr>

					 <tr class="title_caracterisation">
						<td></td>
						<td>{t d='arkeogis' m="Caractérisation :"}</td>
					 </tr>

					 <tr class="title_exceptionnels">
						<td class="fleche_exceptionnels"></td>
						<td>{t d='arkeogis' m="Sites exceptionnels"}</td>
					 </tr>

					 <tr class="menu_realestate">
						<td class='exceptionnel'><div><input type='checkbox' id='ex_realestate' value='1'/></div></td>
						<td><div id='menu_realestate' style='position: relative'></div></td>
					 </tr>
					 <tr class="menu_furniture">
						<td class='exceptionnel'><div><input type='checkbox' id='ex_furniture' value='1'/></div></td>
						<td><div id='menu_furniture' style='position: relative'></div></td>
					 </tr>
					 <tr class="menu_production">
						<td class='exceptionnel'><div><input type='checkbox' id='ex_production' value='1'/></div></td>
						<td><div id='menu_production' style='position: relative'></div></td>
					 </tr>

					 <tr class="buttons">
						<td colspan='2' class="validations">
						 <button id='btn-show-the-map' class='btn-success btn-display-map'>{t d='arkeogis' m="Afficher<br/>la carte"}</button>
						 <button id='btn-show-the-table' class='btn-success btn-display-sheet'>{t d='arkeogis' m="Afficher<br/>le tableur"}</button>
						</td>
					 </tr>
					 <tr class="buttons">
						<td colspan='2' class="reinit">
						 <button class='btn btn-reinit'>{t d='arkeogis' m="Réinitialiser la requête"}</button>
						</td>
					 </tr>
					 <tr class="buttons">
						<td colspan='2' class="querydelete">
						 <button class='btn btn-querydelete'>{t d='arkeogis' m="Supprimer de l'archivage cette requête"}</button>
						</td>
					 </tr>
				 </table>
			</div>
			<div id="map_sheet" class='sheetovermap' style='display: none'></div>
		</div>
	</div>

	{* where the querys will be displayed *}
	<div id='querys'></div>

	{* model used to fill the displayed querys *}
	<div id='query-display' class='query-display' style='display: none'>
                <div class='query-header'>
		  <div class='query-header-title'>Récapitulatif de la requête : <span class='query_num'>1</span></div>
                  <div class='query-header-save'>
			<input id='input-save-query' class='input-save-query' type='text' value='' placeholder='{t d='arkeogis' m='Nom de la requête'}'/>
			<button id='btn-save-query' class='btn btn-save-query'>{t d='arkeogis' m='Archiver la requête'}</button>
                  </div>
		  <div class='query-header-buttons'>
			<button class='btn-success btn-print'>{t d='arkeogis' m='Imprimer'}</button>
			<button class='btn-success btn-export'>{t d='arkeogis' m='Exporter'}</button>
		  </div>
                </div>
		<div class='query-filters-border'>
		     <div class='query-filters'>
		     </div>
		</div>
	</div>

	{* model part used to fill the displayed querys *}
	<div id='query-filter' class='query-filter' style='display: none'>
		<div class='filtername'><span></span> <span class='icon-fleche-bas'></span></div>
	</div>
{/block}
