<cfsilent>
	<cfset entry = viewState.getValue("entry") />
	<cfset commentBean = viewState.getValue("commentBean") />
	<cfset message = viewState.getValue("message") />
	<cfset isAdmin = viewState.getValue("isAdmin") />
	<cfset myself = viewState.getValue("myself") />
	<cfset fullDateString = "dddd, mmmm dd, yyyy" />
	<cfset shortDateString = "mmm dd, yyyy" />
	<cfset timeString = "h:mm tt" />
	
</cfsilent>

<!--- entry with comments page --->

<cfset lastDate = "" />
<cfoutput>
	
	<!--- output entry --->
	<h4>#DateFormat(entry.getDateCreated(), fullDateString)#</h4>
	
	<strong>#entry.getTitle()#</strong>
	<p>#entry.getBody()#</p>
	
	<div class="postlinks">
	posted #TimeFormat(entry.getDateCreated(), timeString)# | 
	<cfif entry.getDateLastUpdated() GT entry.getDateCreated() >updated #DateFormat(entry.getDateCreated(), shortDateString)# #TimeFormat(entry.getDateCreated(), timeString)# | </cfif>
	<cfif entry.getCategoryID() GT 0><a href="#entry.getCategoryID()#">#entry.getCategory()#</a> | </cfif>
	<a href="">#entry.getNumComments()#  comments</a>
	<cfif isAdmin>
		&nbsp;|&nbsp;<a href="#entry.getEntryID()#">edit</a>
	</cfif>
	</div>
	
	<br/>
	
	<!--- output comments --->
	<cfset comments = entry.getComments() />
	<cfloop from="1" to="#ArrayLen(comments)#" index="i">
		<cfset comment = comments[i]/>
		
		<p class="comments">
			#comment.getComment()#
		</p>
		<div class="postlinks">
			by #comment.getName()#, #DateFormat(comment.getDateCreated(), shortDateString)# #TimeFormat(comment.getDateCreated(), timeString)#
		</div>
		
	</cfloop>
	
	<!--- add comments form --->
	<form action="#myself#saveComment" method="post">
	<input type="hidden" name="entryID" value="#entry.getEntryID()#" />
	 
	<h3>Post a comment</h3>
	#message#
	<p>
	Name:<br />
	<input type="text" name="name" value="#commentBean.getName()#"  size="20" maxlength="80" />
	<br />
	Email:<br />
	<input type="text" name="email" value="#commentBean.getEmail()#"  size="20" maxlength="100" />
	<br />
	Website:<br />
	<input type="text" name="url" value="#commentBean.getUrl()#"  size="20" maxlength="150" />
	<br />
	Comment:<br />
	<textarea name="comment" cols="50" rows="6">#commentBean.getComment()#</textarea>
	</p>
	<p>
	<input type="submit" name="submit" value="Add comment" />
	</p>
	
	</form>
	
</cfoutput>
