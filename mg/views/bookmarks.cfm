
<!--- bookmarks sidebar --->
<cfsilent>
	<cfset bookmarks = viewState.getValue("bookmarks") />
	<cfset isAdmin = viewState.getValue("isAdmin") />
	<cfset myself = viewState.getValue("myself") />
</cfsilent>

<b>Links</b>

<p>
<cfoutput>
	<cfloop from="1" to="#ArrayLen(bookmarks)#" index="i">
		<cfset bookmark = bookmarks[i] />
		<cfset linkUrl = bookmark.getUrl() />
		<cfif Left(linkUrl,7) NEQ "http://">
			<cfset linkUrl = "http://" & linkUrl />
		</cfif>
		<a href="#linkUrl#" target="_blank">#bookmark.getName()#</a><br />
		<cfif isAdmin>
		<div class="postlinks">
			<a href="">edit</a> | 
			<cfif i eq ArrayLen(bookmarks)><a href="">+</a> | </cfif>
			<a href="">-</a>
		</div>
		</cfif>
	</cfloop>
</cfoutput>
</p>