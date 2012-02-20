{extends tplextends('webpage/webpage_main')}

{block name='webpage_head' append}
	{js file="/mod/cssjs/js/mootools.js"}
	{js file="/mod/cssjs/js/mootools.more.js"}
	{js file="/mod/cssjs/js/multiselect.js"}
	{css file="/mod/cssjs/ext/twitter-bootstrap/css/bootstrap.css"}
	{css file="/mod/cssjs/ext/twitter-bootstrap/css/bootstrap-responsive.css"}

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
       <div id='button-centroide' style='position: relative'></div>
       <div id='button-connaissance' style='position: relative'>

       <table style='width: 100%'>
        <tr>

	 <td style='text-align: center'>
	  <div id='menu-centroide-button' class='menu-centroconnoccup-button'>CENTROÏDE</div>
          <div id='menu-centroide-content' class='menu-centroconnoccup-content' style='display: none'>
           <div class='chooseme'>Oui</div>
           <div class='chooseme'>Non</div>
          </div>
         </td>
 

	 <td style='text-align: center'>
          <div id='menu-connaissance-button' class='menu-centroconnoccup-button'>CONNAISSANCE</div>
          <div id='menu-connaissance-content' class='menu-centroconnoccup-content' style='display: none'>
           <div class='chooseme'>Non renseigné</div>
           <div class='chooseme'>Littérature, prospecté</div>
           <div class='chooseme'>Sondé</div>
           <div class='chooseme'>Fouillé</div>
          </div>
         </td>

	 <td style='text-align: center'>
          <div id='menu-occupation-button' class='menu-centroconnoccup-button'>OCCUPATION</div>
          <div id='menu-occupation-content' class='menu-centroconnoccup-content' style='display: none'>
           <div class='chooseme'>Non-renseigné</div>
           <div class='chooseme'>Unique</div>
           <div class='chooseme'>Continue</div>
           <div class='chooseme'>Multiple</div>
          </div>
         </td>

        </tr>
       </table>

{*
<ul id="menu-connaissance">
     <li>
      <div>
       <span>Info</span>

      </div>
      <ul>
       <li>
        <div>
         <span>Test</span>
        </div>
        <ul>
         <li>

          <div>
           <span>Problem 1</span>
          </div>
         </li>
         <li>
          <div>
           <span>Problem 2</span>
          </div>

         </li>
         <li>
          <div>
           <span>Problem 3</span>
          </div>
         </li>
        </ul>
       </li>

      </ul>
     </li>
    	</ul>
*}




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
