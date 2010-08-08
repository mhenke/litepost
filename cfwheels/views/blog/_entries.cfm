<cfoutput>
	
	<cfif isAdmin>
	
	<div align="right">
		#linkTo(text="#imageTag(source="add_icon.gif", border="0", title="Add Entry")#", controller="blog", action="entry")#
		#linkTo(text="Add Entry", controller="blog", action="entry")#
	</div>
	</cfif>
	
	<cfif flashKeyExists("message")>
		<p style="font-weight:bold;">#flash("message")#</p>
	</cfif>
	
	<cfif entries.recordcount EQ 0>
		<em>no entries</em>
	<cfelse>
		<cfloop query="entries">
			<h1>#entries.title#</h1>
			<p class="author">Posted by #entries.fullname#, 
				#dateFormat(entries.dateLastUpdated, 'full')# @ 
				#timeFormat(entries.dateLastUpdated, 'short')#</p>
			<p>#ParagraphFormat(entries.body)#</p
			
			<!-- footer at the bottom of every post -->
			<div class="postfooter">
				<span>
					#linkTo(text="#imageTag(source="comment_icon.gif", border="0", title="Comments")#", controller="blog", action="comments", key=id)#
					
					#linkTo(text="Comments (#entries.commentCount#)", controller="blog", action="comments", params="entryID=#entries.id#")#
				</span>
				<span class="right">
					<cfif entries.CategoryID neq 0>
						#linkTo(text="Filed under #entries.category#", controller="blog", action="main", params="categoryID=#entries.CategoryID#")#
					<cfelse>
						Unfiled
					</cfif>
					<cfif isAdmin>
						#linkTo(text="#imageTag(source="edit_icon.gif", border="0", title="Edit Entry")#", controller="blog", action="entry", key=id)#
						
						#linkTo(text="#imageTag(source="delete_icon.gif", border="0", title="Delete Entry")#", controller="blog", action="deleteEntry", key=id, confirm="Are you sure you want to delete this entry?")#
					</cfif>
				</span>
			</div>
		</cfloop>
	</cfif>

</cfoutput>

