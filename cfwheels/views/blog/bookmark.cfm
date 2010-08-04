<cfparam name="params.isAdmin" default="false" />
<cfparam name="framework.action" default="" />

<cfsilent>
	<cfparam name="params.message" default="" />
	
	<cfif bookmark.getBookmarkID() gt 0>
		<cfset local.label="Update" />
	<cfelse>
		<cfset local.label="Create" />
	</cfif>
	<cfset params.title = 'LitePost Blog - #local.label# Link' />
</cfsilent>

<cfoutput>
	<h1>#local.label# Link</h1>
	
	<cfif len(params.message)>
		<p><strong>#params.message#</strong></p>
	</cfif>
	
	<form id="editBookmark" name="editBookmark" method="post" action="?#framework.action#=blog.saveBookmark">
		<input type="hidden" name="bookmarkID" value="#bookmark.getBookmarkID()#" />
		<label>Name<br />
		<input name="name" type="text" value="#bookmark.getName()#" />
		</label>
		<label>Url<br />
		<input name="url" type="text" value="#bookmark.getUrl()#" />
		</label>
		<input type="submit" name="submit" value="#local.label#" class="adminbutton" />
	</form>
</cfoutput>