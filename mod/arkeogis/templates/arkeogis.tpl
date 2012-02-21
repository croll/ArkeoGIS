{extends tplextends('arkeogis/layout')}

{block name='webpage_head' append}
	{js file="/mod/cssjs/js/multiselect.js"}
	{js file="/mod/arkeogis/js/plusminusmenu.js"}
	{js file="/mod/arkeogis/js/page_mapquery.js"}
	{js file="/mod/map/js/MooGooMaps/Source/Class.SubObjectMapping.js"}
	{js file="/mod/map/js/MooGooMaps/Source/Map.js"}
	{js file="/mod/map/js/MooGooMaps/Source/Map.Extras.js"}
	{js file="/mod/map/js/MooGooMaps/Source/Map.Marker.js"}
	<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false" ></script>
{/block}

{block name='arkeogis_content'}
	<div class="clearfix">
		<div id="map_area">


				<div id="map_menu">
					<table class='map-query' border='0' cellspacing='0' cellpadding='0'>

					 <tr class="menu_archives">
						<td colspan='2'>
						 <select>
							<option>{t d='arkeogis' m="Requêtes archivées"}</option>
						 </select>
						</td>
					 </tr>

					 <tr class="troistrucs">
						<td colspan='2'>
						 <div id='button-centroid' style='position: relative'></div>
						 <div id='button-knowledge' style='position: relative'>

							 <table style='width: 100%'>
								<tr>
									<td style='text-align: center'>
										<div id='menu-centroid-button' class='menu-centroconnoccup-button'>CENTROÏDE</div>
										<div id='menu-centroid-content' class='menu-centroconnoccup-content' style='display: none'>
										 <div class='chooseme' multivalue='1'>{t d='arkeogis' m='Oui'}</div>
										 <div class='chooseme' multivalue='0'>{t d='arkeogis' m='Non'}</div>
										</div>
								 </td>
				 

								<td style='text-align: center'>
									<div id='menu-knowledge-button' class='menu-centroconnoccup-button'>CONNAISSANCE</div>
									<div id='menu-knowledge-content' class='menu-centroconnoccup-content' style='display: none'>
									 <div class='chooseme' multivalue='unknown'>{t d='arkeogis' m='Non renseigné'}</div>
									 <div class='chooseme' multivalue='literature'>{t d='arkeogis' m='Littérature, prospecté'}</div>
									 <div class='chooseme' multivalue='surveyed'>{t d='arkeogis' m='Sondé'}</div>
									 <div class='chooseme' multivalue='excavated'>{t d='arkeogis' m='Fouillé'}</div>
									</div>
								</td>

								 <td style='text-align: center'>
									<div id='menu-occupation-button' class='menu-centroconnoccup-button'>OCCUPATION</div>
									<div id='menu-occupation-content' class='menu-centroconnoccup-content' style='display: none'>
									 <div class='chooseme' multivalue='unknown'>{t d='arkeogis' m='Non-renseigné'}</div>
									 <div class='chooseme' multivalue='uniq'>{t d='arkeogis' m='Unique'}</div>
									 <div class='chooseme' multivalue='continuous'>{t d='arkeogis' m='Continue'}</div>
									 <div class='chooseme' multivalue='multiple'>{t d='arkeogis' m='Multiple'}</div>
									</div>
								 </td>

								</tr>
							</table>

						 </div>
						 <div id='button-occupation' style='position: relative'></div>
						</td>
					 </tr>

					 <tr class="menu_period">
						<td colspan='2'><div id='menu_period' style='position: relative'></div></td>
					 </tr>

					 <tr class="title_caracterisation">
						<td></td>
						<td>{t d='arkeogis' m="Caractérisation :"}</td>
					 </tr>

					 <tr class="title_exceptionnels">
						<td></td>
						<td>{t d='arkeogis' m="Sites exceptionnels"}</td>
					 </tr>

					 <tr class="menu_realestate">
						<td class='exceptionnel'><div><input type='checkbox' name='ex_realestate' value='1'/></div></td>
						<td><div id='menu_realestate' style='position: relative'></div></td>
					 </tr>
					 <tr class="menu_furniture">
						<td class='exceptionnel'><div><input type='checkbox' name='ex_furniture' value='1'/></div></td>
						<td><div id='menu_furniture' style='position: relative'></div></td>
					 </tr>
					 <tr class="menu_production">
						<td class='exceptionnel'><div><input type='checkbox' name='ex_production' value='1'/></div></td>
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
				 </table>
				</div>

			<!-- end of map menu -->
			<div id="map_canvas">
			</div>

			<script type="text/javascript">
				document.addEvent('domready', function() {
					var map = new Map('map_canvas', [43.60,3.88], { 
						zoom: 12, 
						disableDefaultUI: true,
					  mapTypeControl: true,
						mapTypeControlOptions: {
							style: google.maps.MapTypeControlStyle.HORIZONTAL_BAR,
							position: google.maps.ControlPosition.TOP_RIGHT
						},
						zoomControl: true,
						zoomControlOptions: {
							style: google.maps.ZoomControlStyle.SMALL,
							position: google.maps.ControlPosition.RIGHT_TOP
						},
					  panControl: true,
						panControlOptions: {
							style: google.maps.ZoomControlStyle.SMALL,
							position: google.maps.ControlPosition.RIGHT_TOP
						},
						scaleControl: true,
						scaleControlOptions: {
							position: google.maps.ControlPosition.BOTTOM_LEFT
						}
					});
				});
			</script>
			<img src="{$image}" />
		</div>
	</div>
{/block}
