<cfparam name="params.isAdmin" default="false" />
<cfparam name="framework.action" default="" />

<cfsilent>
	<cfset local.fullDateString = "dddd, mmmm dd, yyyy" />
	<cfset local.shortDateString = "mmm/dd/yyyy" />
	<cfset local.timeString = "h:mm tt" />
	<cfparam name="params.message" default="" />
</cfsilent>

<!--- main entries page --->

<cfoutput>
	
	<cfif params.isAdmin>
	<script type="text/javascript">
		function deleteEntry(entryID) {
			if(confirm("Are you sure you want to delete this entry?")) {
				location.href = "?#framework.action#=blog.deleteEntry&entryID=" + entryID;
			}
		}
	</script>
	
	<div align="right">
		#linkTo(text="#imageTag(source="add_icon.gif", border="0", title="Add Entry")#", controller="account", action="entry")#
		#linkTo(text="Add Entry", controller="blog", action="entry")#
	</div>
	</cfif>
	
	<cfif len(params.message)>
		<p><strong>#params.message#</strong></p>
	</cfif>
	
	<cfif entries.recordcount EQ 0>
		<em>no entries</em>
	<cfelse>
		<cfloop from="1" to="#ArrayLen(params.entries)#" index="local.i">
			<cfset local.entry = params.entries[local.i] />
			
			<h1>#local.entry.getTitle()#</h1>
			<p class="author">Posted by #local.entry.getPostedBy()#, 
				#dateFormat(local.entry.getEntryDate(), local.shortDateString)# @ 
				#timeFormat(local.entry.getEntryDate(), local.timeString)#</p>
			<p>#ParagraphFormat(local.entry.getBody())#</p
			
			<!-- footer at the bottom of every post -->
			<div class="postfooter">
				<span>
					#linkTo(text="#imageTag(source="comment_icon.gif", border="0", title="Comments")#", controller="blog", action="comments", key=id)#
					
					#linkTo(text="Comments (#local.entry.getNumComments()#)", controller="blog", action="comments", key=id)#
				</span>
				<span class="right">
					<cfif local.entry.getCategoryID() neq 0>
						#linkTo(text="Filed under #local.entry.getCategory()#", controller="blog", action="main", key=local.entry.getCategoryID())#
					<cfelse>
						Unfiled
					</cfif>
					<cfif params.isAdmin>
						#linkTo(text="#imageTag(source="edit_icon.gif", border="0", title="Edit Entry")#", controller="blog", action="entry", key=id)#
						
						#linkTo(text="#imageTag(source="delete_icon.gif", border="0", title="Delete Entry")#", controller="blog", action="entry", key=id, confirm="delete")#
					</cfif>
				</span>
			</div>
		</cfloop>
	</cfif>

</cfoutput>

