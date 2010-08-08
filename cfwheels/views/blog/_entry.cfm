<cfoutput>

<!--- output entry --->
	<h1>#entry.title#</h1>
	<p class="author">Posted by #entry.fullname#, #dateFormat(entry.DATECREATED, shortDateString)# @ #timeFormat(entry.DATECREATED, timeString)#</p>
	<p>#ParagraphFormat(entry.body)#</p
	
	<!-- footer at the bottom of every post -->
	<div class="postfooter">
		<span>
			#linkTo(text="#imageTag(source="comment_icon.gif", border="0", title="Comments")#", controller="blog", action="comments",key=entry.id)#
			#linkTo(text="Comments (#entry.commentcount#)", controller="blog", action="comments", key=entry.id)#
		</span>
		<span class="right">
			<cfif entry.categoryid neq 0>
				#linkTo(text="Filed under #entry.category#", controller="blog", action="main", key=entry.categoryid)#
			<cfelse>
				Unfiled
			</cfif>
			<cfif isAdmin>
				<br />
				#linkTo(text="#imageTag(source="edit_icon.gif", border="0", title="Edit Entry")#", controller="blog", action="entry", key=entry.id)#
				#linkTo(text="#imageTag(source="delete_icon.gif", border="0", title="Delete Entry")#", controller="blog", action="deleteEntry", confirm="Are you sure you want to delete this entry?",key=entry.id)#
			</cfif>
		</span>
	</div>

</cfoutput>