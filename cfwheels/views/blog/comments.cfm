<!--- entry with comments page --->
<cfoutput>
	
	#includepartial("entry")#
	
	<!--- output comments --->
	<a name="comments"></a>
	<h2>Comments</h2>
	
	<cfif comments.recordcount gt 0>
		<cfloop query="comments">
			<div class="comment">
				<p>
					<strong>
						<cfif comments.url is not "">
						<a href="#comments.url#" target="_blank">
						</cfif>
						#comments.name#
						<cfif comments.url is not ""></a></cfif>
					</strong> 
					- <em>#dateFormat(comments.DATECREATED, "mm/dd/yyyy")#</em></p>
				<p>#comments.name# says ... #ParagraphFormat(comments.comment)#</p>
		 	</div>
			<p><a href="##content">#imageTag(source="top_icon.gif", border="0", alt="top")#</a> <a href="##content">top</a></p>
		</cfloop>
	<cfelse>
		<p>No comments yet. Be the first to add a comment!</p>
	</cfif>
	
	#includepartial("addcomment")#
	
</cfoutput>
