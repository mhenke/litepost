<cfsilent>
	<cfset entries = event.getArg("entries") />
	<cfset isAdmin = event.getArg("isAdmin") />
	<cfset fullDateString = "dddd, mmmm dd, yyyy" />
	<cfset shortDateString = "mmm dd, yyyy" />
	<cfset timeString = "h:mm tt" />
</cfsilent>

<!--- main entries page --->
<cfoutput>
	<cfif arrayLen(entries) gt 0>
		<cfloop from="1" to="#ArrayLen(entries)#" index="i">
			<cfset entry = entries[i] />
			
			<h1>#entry.getTitle()#</h1>
			<p class="author">Posted by NAME HERE, #entry.getEntryDate()#</p>
			<p>#entry.getBody()#</p>

			<!-- footer at the bottom of every post-->
			<div class="postfooter">
				<span>
					<a href="postDetail.html"><img src="../assets/images/comment_icon.gif" alt="Comment" border="0" /></a> 
					<a href="postDetail.html##comments">Comments (#entry.getNumComments()#)</a>
				</span>
				<span class="right">
					<cfif entry.getCategoryID() neq 0><a href="index.cfm?#getProperty('eventParameter')#=showHome&categoryID=#entry.getCategoryID()#">Filed under #entry.getCategory()#</a><cfelse>Unfiled</cfif>
				</span>
			</div>
		</cfloop>
	<cfelse>
		- no entries -
	</cfif>

</cfoutput>
