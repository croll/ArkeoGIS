{extends tplextends('arkeogis/layout')}

{block name='webpage_head' append}
	{js file="/mod/cssjs/js/ckeditor/ckeditor.js"}
	{js file="/mod/cssjs/js/chwysiwyg.js"}
{/block}
{block name='page_menu' append}
		{if isset($page.pid) && $page.pid !=0} 
		<li><a  href="/page/{$page.sysname}"><i class="icon-eye-open glyph-white"></i>  View</a></li>
		{/if}
{/block}
{block name='arkeogis_content'}
	
	{if isset($page.pid) && $page.pid !=0} 
	<div class="page-header" id="page_title">
		<h1>{$page.name}</h1>
		<small>
			Created  {$page.created|date_format: '%d %b %Y'} by {$page.full_name} : last updated - {$page.updated|date_format: '%d %b %Y'}
		</small>
	</div>
	{/if}
	<div id="pageForm" class="row">
	<fieldset>
		<form id="page_edit" method="POST" action="">
			<input type="hidden" name="field_fieldform_id" value="page_edit">
			<input type="hidden" name="pid" value="{$page.pid}" >
			<input type="hidden" name="sysname" value="{$page.sysname}" >
			<input type="hidden" name="authorId" value="{$page.authorId}" >
			<input type="hidden" name="created" value="{$page.created}" >
			<input type="hidden" name="updated" value="{$page.updated}" >

			<div class="row">
				<a class="btn btn-primary float" href="#" onclick="$('page-trans').toggleClass('hidden');";> Translations</a>
				<div id="page-trans" class="hidden float">
					<div class="row">
					<label for="lang"><span>Lang:</span></label>
					<select name="lang" onchange="mypage.listIdLangReference('{$page.sysname}', this.value, 'page_reference');">
						<option value=""> Untranslated</option>	
						<option value="fr_FR" {if $page.lang == "fr_FR"} selected="selected"{/if}>French</option>	
						<option value="de_DE" {if $page.lang == "de_DE"} selected="selected"{/if}>Deutch</option>	
					</select>
					</div>
					<div class="row">
					<label for="lang"><span>Is translation of:</span></label>
					<select id="page_reference" name="id_lang_reference">
						<option value="">None</option>	
						<option value="1" {if $page.id_lang_reference == "1"} selected="selected"{/if}>Blah </option>	
						<option value="2" {if $page.id_lang_reference == "2"} selected="selected"{/if}>...</option>	
					</select>
					</div>
				</div>
				<label for="name"><span>Page title:</span></label><input class="xlarge" title="name" type="text" name="name" value="{$page.name}" ></div>
			<div class="row">
				<textarea cols="100" id="editor1" name="content" rows="10" style="visibility: hidden; display: none; ">{$page.content}</textarea>	
			</div>
			<div class="row"><label for="published"><span>Publish:</span><input onclick="var c=this.get('value'); if (c==0) this.set('value', 1); else this.set('value', 0);" class="checkbox" title="published" type="checkbox" name="published" {if $page.published == 1} checked ="checked" {/if} value="{$page.published}" ></label></div>

			<div class="action">
				<input class="btn primary" id='page_edit_submit'  type="submit" name="submit" value="Save changes">
				<button type="reset" class="btn">Cancel</button>
			</div>
		
		</form>
</fieldset>
	<div>
	{*
	<br />
		<div><a href="#" class="ajaxLink btn" onclick="$('eButtons').toggle();">Wysiwyg Editor Examples for developers</a></div>
		<div id="eButtons" style='display: none'>
			<a href="http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.plugins.html">Full Api documlentation</a>
			<input onclick="myeditor.insertHTML();" type="button" value="Insert HTML" />
			<input onclick="myeditor.setContents();" type="button" value="Set Editor Contents" />
			<input onclick="myeditor.getContents();" type="button" value="Get Editor Contents (XHTML)" />
			<br />
			<textarea cols="100" id="htmlArea" rows="3">&lt;h2&gt;Test&lt;/h2&gt;&lt;p&gt;This is some &lt;a href="/Test1.html"&gt;sample&lt;/a&gt; HTML code.&lt;/p&gt;</textarea>
			<br />
			<br />
			<input onclick="myeditor.insertText();" type="button" value="Insert Text" />
			<br />
			<textarea cols="100" id="txtArea" rows="3">   First line with some leading whitespaces.

Second line of text preceded by two line breaks.</textarea>
			<br />
			<input onclick="myeditor.executeCommand('bold');" type="button" value="Execute &quot;bold&quot; Command" />
			<input onclick="myeditor.executeCommand('link');" type="button" value="Execute &quot;link&quot; Command" />
			<br />
			<br />
			<input onclick="myeditor.checkDirty();" type="button" value="checkDirty()" />
			<input onclick="myeditor.resetDirty();" type="button" value="resetDirty()" />
		</div>

	*}
<script>
	var myeditor = new CHWysiwyg({ 'contentElement' : 'editor1',});
	var mypage = new Page();
	mypage.listIdLangReference('{$page.sysname}','{$page.lang}', 'page_reference');
	$('page_edit_submit').addEvent('click', function(event){
		event.stop(); //Prevents the browser from following the link.
		var content = myeditor.prepareToSave();
		 
		$('editor1').set('value', content);
		var params = $('page_edit'); 
		mypage.postForm('/ajax/call/page/savePage', 'page_edit', params);
	});
</script>
{/block}

