{extends tplextends('webpage/webpage_main')}

{block name='webpage_head' append}
	{js file="/mod/cssjs/js/mootools.js"}
	{js file="/mod/cssjs/js/mootools.more.js"}
	{css file="/mod/cssjs/twitter-bootstrap/css/bootstrap.css"}
	{css file="/mod/cssjs/twitter-bootstrap/css/bootstrap-responsive.css"}

	{js file="/mod/arkeogis/js/plusminusmenu.js"}
	{js file="/mod/arkeogis/js/page_mapquery.js"}
	{css file="/mod/arkeogis/css/arkeogis.css"}
{/block}

{block name='webpage_body'}
    <div class="navbar navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container">
          <div class="nav-collapse">
            <ul class="nav">
              <li class="active"><a href="#">Cartothèque</a></li>
              <li><a href="#about">Requête SQL</a></li>
              <li><a href="#contact">Manuel utilisateur</a></li>
              <li><a href="#contact">Fiche création site</a></li>
            </ul>
          </div><!--/.nav-collapse -->
        </div>
      </div>
    </div>

    <br/><br/><br/>
    <div class="map-query">
     <select name='menu'>
      <option>{t d='arkeogis' m="Requêtes archivées"}</option>
     </select>
    </div>

    <div id='menutest'></div>

{/block}
