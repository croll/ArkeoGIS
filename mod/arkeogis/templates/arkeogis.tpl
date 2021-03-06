{extends tplextends('arkeogis/layout')}

{block name='webpage_head' append}
            <script src="http://maps.google.com/maps/api/js?v=3.2&sensor=false"></script>
	{css file="/mod/cssjs/css/Modal.css"}
	{css file="/mod/cssjs/css/message.css"}
	{js file="/mod/cssjs/js/messageclass.js"}
	{js file="/mod/cssjs/js/message.js"}
	{js file="/pmmenus"}
        <script>UI={}</script>
	{js file="/mod/cssjs/ext/mootools_ui_tabs/UI.Tabs.js"}
	{css file="/mod/cssjs/ext/mootools_ui_tabs/tabs.css"}
	{js file="/mod/arkeogis/js/plusminusmenu.js"}
	{js file="/mod/arkeogis/js/sheet.js"}
	{js file="/mod/cssjs/ext/leaflet/leaflet-src.js"}
	{css file="/mod/cssjs/ext/leaflet/leaflet.css"}
	{css file="/mod/cssjs/ext/leaflet.markercluster/MarkerCluster.Default.css"}
	{css file="/mod/cssjs/ext/leaflet.markercluster/MarkerCluster.css"}
	{js file="/mod/cssjs/ext/leaflet.markercluster/leaflet.markercluster.js"}
	{js file="/mod/cssjs/ext/leaflet.label/leaflet.label.js"}
	{css file="/mod/cssjs/ext/leaflet.label/leaflet.label.css"}
           {js file="/mod/cssjs/ext/leaflet.mouseposition/L.Control.MousePosition.js"}
           {css file="/mod/cssjs/ext/leaflet.mouseposition/L.Control.MousePosition.css"}
           {js file="/mod/cssjs/ext/leaflet-modules/Google.js"}

        {css file="/mod/cssjs/ext/Leaflet.draw/dist/leaflet.draw.css"}
        {js file="/mod/cssjs/ext/Leaflet.draw/dist/leaflet.draw.js"}
	<!--[if lte IE 8]>
    		<link rel="stylesheet" href="/mod/cssjs/ext/leaflet/leaflet.ie.css" />
    		<link rel="stylesheet" href="/mod/cssjs/ext/leaflet/leaflet.markercluster/MarkerCluster.Default.ie.css" />
    		<link rel="stylesheet" href="/mod/cssjs/ext/Leaflet.draw/dist/leaflet.draw.ie.css" />
	<![endif]-->
	{js file="/mod/arkeogis/js/page_mapquery.js"}
{/block}

{block name='arkeogis_content'}
	<div id="map_container">

		<div id="map_area">

			<!-- end of map menu -->
			<div id="map_canvas">
			</div>

			  <div id="onglet"><i class="icon icon-chevron-left"></i></div>
				<div id="map_menu">
					<table class='map-query' border='0' cellspacing='0' cellpadding='0'>

					 <tr class="menu_archives">
						<td colspan='2'>
						 <select id='select-savedqueries'></select>
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

					 <tr class="menu_area">
						<td colspan='2'><div id='menu_area' style='position: relative'></div></td>
					 </tr>

					{*
					 <tr class="title_caracterisation">
						<td></td>
						<td>{t d='arkeogis' m="Caractérisation :"}</td>
					 </tr>
					*}

					 <tr class="caracterisation_mode">
						<td colspan='2'>
						 <select id='caracterisation_mode'>
						  <option value='OR'>{t d='arkeogis' m="Au moins une caractérisation"} :</option>
						  <option value='AND'>{t d='arkeogis' m="Toutes les caractérisations"} :</option>
						 </select>
						</td>
					 </tr>

					 <tr class="menu_realestate">
						<td><div id='menu_realestate' style='position: relative'></div></td>
						<td class='exceptionnel'><div><input type='checkbox' id='ex_realestate' value='1'/></div></td>
					 </tr>
					 <tr class="menu_furniture">
						<td><div id='menu_furniture' style='position: relative'></div></td>
						<td class='exceptionnel'><div><input type='checkbox' id='ex_furniture' value='1'/></div></td>
					 </tr>
					 <tr class="menu_production">
						<td><div id='menu_production' style='position: relative'></div></td>
						<td class='exceptionnel'><div><input type='checkbox' id='ex_production' value='1'/></div></td>
					 </tr>
					 <tr class="menu_landscape">
						<td><div id='menu_landscape' style='position: relative'></div></td>
						<td class='exceptionnel'><div><input type='checkbox' id='ex_landscape' value='1'/></div></td>
					 </tr>

					 <tr class="title_exceptionnels">
						<td class="text_exceptionnels">{t d='arkeogis' m="Sites exceptionnels"}</td>
						<td class="fleche_exceptionnels"></td>
					 </tr>

					 <tr class="menu_txtsearch">
					   <td colspan="2">
					     <div id='menu_txtsearch' style='position: relative'>
					       <input type='text' id='txtsearch' name='txtsearch' value='' placeholder='{t d="arkeogis" m="Recherche textuelle"}'/>
					     </div>
                                             <div id='menu_txtsearch_options'></div>
					   </td>
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
				 </table>
			</div>
			<div id="map_sheet" class='sheetovermap' style='display: none'></div>
		</div>
	</div>

	{* where the querys will be displayed *}
        <div class='querys-header-title'>{t d='arkeogis' m="Récapitulatif des requêtes :"}
	<div id='querys' style="height: auto"></div>

	{* model used to fill the displayed querys *}
	<div id='query-display' class='query-display' style='display: none'>
                <div class='query-header'>
                  <div class='query-header-save'>
			<input id='input-save-query' class='input-save-query' type='text' value='' placeholder='{t d='arkeogis' m='Nom de la requête'}'/>
			<button id='btn-save-query' style='display: none' class='btn btn-save-query'>{t d='arkeogis' m='Archiver la requête'}</button>
			<button id='btn-delete-query' style='display: none' class='btn btn-delete-query'>{t d='arkeogis' m='Supprimer des archives'}</button>
                  </div>
		  <div class='query-header-buttons'>
			<button class='btn-success btn-print'>{t d='arkeogis' m='Imprimer'}</button>
			<button class='btn-success btn-export' {if !$canexport}style='display:none'{/if}>{t d='arkeogis' m='Exporter'}</button>
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

	{* model used to ask for coordinates *}
	<div id='win-coord' style='display: none'>
          <h4 class="win-coord-title">{t d='arkeogis' m="Merci de renseigner les coordonnées du centre de votre recherche :"}</h4>
          <br>
          <table class='table-coord'>
            <tr>
              <th colspan='5'>{t d='arkeogis' m="Latitude (exemple Strasbourg : 48° 35'N ou décimaux : 48.583)"}</th>
            </tr>
            <tr>
              <td>{t d='arkeogis' m='degrés'}</td>
              <td>{t d='arkeogis' m='minutes'}</td>
              <td>{t d='arkeogis' m='secondes'}</td>
              <td></td>
              <td>{t d='arkeogis' m="décimaux"}</td>
            </tr>
            <tr class='coord_lat'>
              <td><input type='text' name='txtdeg' value='0' onkeyup="dmsdec('coord_lat')"></td>
              <td><input type='text' name='txtmin' value='0' onkeyup="dmsdec('coord_lat')"></td>
              <td><input type='text' name='txtsec' value='0' onkeyup="dmsdec('coord_lat')"></td>
              <td><select name='orientation' onchange="dmsdec('coord_lat')"><option>N</option><option>S</option></select></td>
              <td><input type='text' name='txtdec' value='0' onkeyup="decdms('coord_lat')"></td>
            </tr>
            <tr>
              <th colspan='5'>{t d='arkeogis' m="Longitude (exemple Strasbourg : 7° 45'N ou décimaux : 7.750)"}</th>
            </tr>
            <tr>
              <td>{t d='arkeogis' m='degrés'}</td>
              <td>{t d='arkeogis' m='minutes'}</td>
              <td>{t d='arkeogis' m='secondes'}</td>
              <td></td>
              <td>{t d='arkeogis' m="décimaux"}</td>
            </tr>
            <tr class='coord_lng'>
              <td><input type='text' name='txtdeg' value='0' onkeyup="dmsdec('coord_lng')"></td>
              <td><input type='text' name='txtmin' value='0' onkeyup="dmsdec('coord_lng')"></td>
              <td><input type='text' name='txtsec' value='0' onkeyup="dmsdec('coord_lng')"></td>
              <td><select name='orientation' onchange="dmsdec('coord_lng')"><option>E</option><option>W</option></select></td>
              <td><input type='text' name='txtdec' value='0' onkeyup="decdms('coord_lng')"></td>
            </tr>
            <tr>
              <th colspan='5'>{t d='arkeogis' m='Distance'}</th>
            </tr>
            <tr class='coord_lng'>
              <td colspan='5'>{t d='arkeogis' m='Dans un rayon de'} <input type='text' name='km' value='0'> {t d='arkeogis' m='km à partir du centre de la recherche.'}</td>
            </tr>
          </table>
          <div class="win-coord-nota">{t d='arkeogis' m="win-coord-nota"}</div>
        </div>


{/block}
