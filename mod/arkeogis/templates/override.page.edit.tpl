{extends tplextends('arkeogis/layout')}

{block name='webpage_head' append}
	{js file="/mod/cssjs/js/ckeditor/ckeditor.js"}
	{js file="/mod/cssjs/js/chwysiwyg.js"}
{/block}

{block name='page_menu' append}
		{if $page.pid !=0} 
		<li><a  href="/page/{$page.sysname}"><i class="icon-eye-open glyph-white"></i>  View</a></li>
		{/if}
{/block}

{block name='arkeogis_content'}
	<div class="page-header" id="page_title">
		<h1>{$page.name}</h1>
		<small>
			Created  {$page.created|date_format: '%d %b %Y'} by {$page.full_name} : last updated - {$page.updated|date_format: '%d %b %Y'}
		</small>
	</div>
	<div class="row">
	<fieldset>
		<form id="page_edit" method="POST" action="">
			<input type="hidden" name="field_fieldform_id" value="page_edit">
			<input type="hidden" name="pid" value="{$page.pid}" >
			<input type="hidden" name="sysname" value="{$page.sysname}" >
			<input type="hidden" name="authorId" value="{$page.authorId}" >
			<input type="hidden" name="created" value="{$page.created}" >
			<input type="hidden" name="updated" value="{$page.updated}" >

			<div class="clearfix"><label for="name"><span>Page title:</span></label><input class="xlarge" title="name" type="text" name="name" value="{$page.name}" ></div>
			<div class="clearfix">
				<textarea cols="100" id="editor1" name="content" rows="10" style="visibility: hidden; display: none; ">{$page.content}</textarea>	
			</div>
			<div class="clearfix"><label for="published"><span>Publish:</span><input onclick="var c=this.get('value'); if (c==0) this.set('value', 1); else this.set('value', 0);" class="checkbox" title="published" type="checkbox" name="published" {if $page.published == 1} checked ="checked" {/if} value="{$page.published}" ></label></div>

			<div class="action">
				<input class="btn primary" id='page_edit_submit'  type="submit" name="submit" value="Save changes">
				<button type="reset" class="btn">Cancel</button>
			</div>
		
		</form>
</fieldset>
	<div>

<script>
	var myeditor = new CHWysiwyg({
				'contentElement':'editor1',
			});
	var mypage = new Page();
	$('page_edit_submit').addEvent('click', function(event){
		event.stop(); //Prevents the browser from following the link.
		var content = myeditor.prepareToSave();
		 
		$('editor1').set('value', content);
		var params = $('page_edit'); 
		mypage.postForm('/ajax/call/page/savePage', 'page_edit', params);
	});
</script>
{/block}

