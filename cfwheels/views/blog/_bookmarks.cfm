<cfoutput>
	
<div>
	<h2>
		Links
		<cfif isAdmin>
			#linkTo(text="#imageTag(source="add_icon.gif", border="0", title="Add Link")#", controller="blog", action="bookmark")#
		</cfif>
	</h2>
</div>

<ul>
	
	<cfif bookmarks.recordcount eq 0>
		<li><em>no links</em></li>
	<cfelse>

		<cfloop query="bookmarks">
			<cfset linkUrl = 0 />
			<cfif Left(linkUrl,7) NEQ "http://">
				<cfset linkUrl = "http://" & linkUrl />
			</cfif>
			
			<li>
				<a href="#bookmarks.url#" target="_blank">#bookmarks.name#</a>				
				#linkTo(text="rss", controller="blog", action="rss", params="bookmarkID=#id#&bookmarkName=#bookmarks.name#")#
				
				<cfif isAdmin>
					&nbsp;
					#linkTo(text="#imageTag(source="edit_icon.gif", border="0", title="Edit Link")#", controller="blog", action="bookmark",key=bookmarks.id)#
					#linkTo(text="#imageTag(source="delete_icon.gif", border="0", title="Delete Link")#", controller="blog", action="deletebookmark",confirm="Are you sure you want to delete this link?",key=bookmarks.id)#
				</cfif>
			</li>
		</cfloop>
		
	</cfif>

</ul>

</cfoutput>