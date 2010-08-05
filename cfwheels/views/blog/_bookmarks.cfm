<cfoutput>
	
<div>
	<h2>
		Links
		<cfif params.isAdmin>
			#linkTo(text="#imageTag(source="add_icon.gif", border="0", title="Add Link")#", controller="blog", action="bookmark")#
		</cfif>
	</h2>
</div>

<ul>
	
	<cfif bookmarks.recordcount eq 0>
		<li><em>no links</em></li>
	<cfelse>

		<cfoutput query="bookmarks">
			<cfset linkUrl = 0 />
			<cfif Left(linkUrl,7) NEQ "http://">
				<cfset linkUrl = "http://" & linkUrl />
			</cfif>
			
			<li>

				#linkTo(text="bookmark.getName()", controller="blog", action="bookmark", target="_blank")#

				<cfif params.isAdmin>
					&nbsp;
					#linkTo(text="Edit Link", controller="blog", action="bookmark")#
						#imageTag(source="edit_icon.gif", border="0", title="Edit Link")#
					#linkTo(text="Delete Link", controller="blog", action="deleteBookmark",  confirm="Are you sure you want to delete this bookmark?", key=bkmkID)#
						#imageTag(source="delete_icon.gif", border="0", title="Delete Link")#
				</cfif>
			</li>
		</cfoutput>
		
	</cfif>

</ul>

</cfoutput>