{extends tplextends('map/googlemaps')}

{block name='webpage_head' append}
	{css file="/mod/arkeogis/css/map.css"}
{/block}

{block name='webpage_body'}
  <style type="text/css">
     #map_canvas { width: 500px; height: 400px; border:1px solid #000}
  </style>
	<div id="map_canvas"></div>
	<script type="text/javascript">
		document.addEvent('domready', function() {
			var map = new Map('map_canvas', [43.60,3.88], { zoom: 12 });
		});
	</script>
{/block}
