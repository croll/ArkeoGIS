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

    <table class='map-query' border='0' cellspacing='0' cellpadding='0'>
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
       <button class='btn-success btn-display-map'>{t d='arkeogis' m="Afficher<br/>la carte"}</button>
       <button class='btn-success btn-display-sheet'>{t d='arkeogis' m="Afficher<br/>le tableur"}</button>
      </td>
     </tr>
     <tr class="buttons">
      <td colspan='2' class="reinit">
       <button class='btn btn-reinit'>{t d='arkeogis' m="Réinitialiser la requête"}</button>
      </td>
     </tr>

{/block}
