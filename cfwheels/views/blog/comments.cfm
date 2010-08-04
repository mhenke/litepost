<cfparam name="params.isAdmin" default="false" />
<cfparam name="framework.action" default="" />

<cfsilent>
	<cfparam name="params.message" default="" />
	<cfset local.fullDateString = "dddd, mmmm dd, yyyy" />
	<cfset local.shortDateString = "mmm dd, yyyy" />
	<cfset local.timeString = "h:mm tt" />
	<cfset params.title = 'LitePost Blog - #params.entry.getTitle()#' />
</cfsilent>

<!--- entry with comments page --->
<cfoutput>
	
	<!--- output entry --->
	<h1>#params.entry.getTitle()#</h1>
	<p class="author">Posted by #params.entry.getPostedBy()#, #dateFormat(params.entry.getEntryDate(), local.shortDateString)# @ #timeFormat(params.entry.getEntryDate(), local.timeString)#</p>
	<p>#ParagraphFormat(params.entry.getBody())#</p
	
	<!-- footer at the bottom of every post -->
	<div class="postfooter">
		<span>
			#linkTo(text="#imageTag(source="comment_icon.gif", border="0", title="Comments")#", controller="blog", action="comments",key=id)#
			#linkTo(text="Comments (#params.entry.getNumComments()#)", controller="blog", action="comments", key=id)#
		</span>
		<span class="right">
			<cfif params.entry.getCategoryID() neq 0>
				#linkTo(text="Filed under #params.entry.getCategory()#", controller="blog", action="main", key=params.entry.getCategoryID())#
			<cfelse>
				Unfiled
			</cfif>
			<cfif isAdmin>
				<br />
				#linkTo(text="#imageTag(source="edit_icon.gif", border="0", title="Edit Entry")#", controller="blog", action="entry", key=entry.id)#
				#linkTo(text="#imageTag(source="delete_icon.gif", border="0", title="Delete Entry")#", controller="blog", action="deleteEntry", confirm="delete entry",key=entry.id)#
			</cfif>
		</span>
	</div>
	
	<!--- output comments --->
	<a name="comments"></a>
	<h2>Comments</h2>
	
	<cfset local.comments = params.entry.getComments() />
	
	<cfif arrayLen(local.comments) gt 0>
		<cfloop index="local.i" from="1" to="#arrayLen(local.comments)#">
			<cfset local.comment = local.comments[local.i] />
			<div class="comment">
				<p>
					<strong>
						<cfif local.comment.getUrl() is not "">
						<a href="#local.comment.getUrl()#" target="_blank">
						</cfif>
						#local.comment.getName()#
						<cfif local.comment.getUrl() is not ""></a></cfif>
					</strong> 
					- <em>#dateFormat(local.comment.getDateCreated(), "mm/dd/yyyy")#</em></p>
				<p>#local.comment.getName()# says ... #ParagraphFormat(local.comment.getComment())#</p>
		 	</div>
			<p>
				#linkTo(anchor="##content", title="#imageTag(source="top_icon.gif", border="0", title="top")#")#
				
				#linkTo(anchor="##content", title="top")#
			</p>
		</cfloop>
	<cfelse>
		<p>No comments yet. Be the first to add a comment!</p>
	</cfif>
	
	<cfif len(params.message)>
		<p><strong>#params.message#</strong></p>
	</cfif>
	
	<h2>Add A Comment </h2>
	<form id="comment" name="comment" action="?#framework.action#=blog.saveComment" method="post">
		<input type="hidden" name="entryID" value="#id#" />
		<label>Your Name<br/>
		<input type="text" name="name" value="#comment.getName()#" />
		</label>
		<label>Email (not shared with anyone)<br/>
		<input type="text" name="email" value="#comment.getEmail()#" />
		</label>
		<label>URL (linked in your post)<br/>
		<input type="text" name="url" value="#comment.getUrl()#" />
		</label>
		<label>Comment<br/>
		<textarea name="comment" class="comment">#comment.getComment()#</textarea>
		</label>
		<input type="submit" name="submit" value="Submit" class="adminbutton" />
	</form>
  <p>&nbsp;</p>
	
</cfoutput>
