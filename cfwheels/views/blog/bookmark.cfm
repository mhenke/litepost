


<cfsilent>
	
	
	<cfif bookmark.getBookmarkID() gt 0>
		<cfset local.label="Update" />
	<cfelse>
		<cfset local.label="Create" />
	</cfif>
	<cfset params.title = 'LitePost Blog - #local.label# Link' />
</cfsilent>

<cfoutput>
	<h1>#local.label# Link</h1>
	
	<cfif flashKeyExists("message")>
		<p style="font-weight:bold;">#flash("message")#</p>
	</cfif>
	
	#startFormTag(action="saveBookmark")#
		<input type="hidden" name="bookmarkID" value="#bookmark.getBookmarkID()#" />
		<label>Name<br />
		<input name="name" type="text" value="#bookmark.getName()#" />
		</label>
		<label>Url<br />
		<input name="url" type="text" value="#bookmark.getUrl()#" />
		</label>
		<input type="submit" name="submit" value="#local.label#" class="adminbutton" />
	#endFormTag()#
</cfoutput>