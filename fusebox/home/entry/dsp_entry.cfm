<cfoutput>

<!---- display entry ---->
<!-- post -->
<h1>#REQUEST.qryEntry.title[1]#</h1>
<p class="author">Posted #dateFormat(REQUEST.qryEntry.entryDate[1])#
<p>#paragraphFormat(REQUEST.qryEntry.body[1])#</p>
<a href="#REQUEST.myself##XFA.view#&entryID=#REQUEST.qryEntry.entryID[1]#">More</a>

<!-- footer at the bottom of every post-->
<div class="postfooter">
	<span>
		<cfif SESSION.user.role IS 'admin'>
			<a href="#REQUEST.myself##XFA.edit#&entryID=#REQUEST.qryEntry.entryID[1]#">Edit</a>
			| <a href="#REQUEST.myself##XFA.remove#&entryID=#REQUEST.qryEntry.entryID[1]#">Remove</a>
		</cfif>
	</span>
	<span class="right">
		<a href="##">Filed under #REQUEST.qryEntry.category[1]#</a>
	</span>
</div>

<!-- comments -->
<a name="comments"></a>
<h2>Comments</h2>
<cfloop from="1" to="#REQUEST.qryComment.recordCount#" index="c">
	<div class="comment">
		<p><strong><a href="#REQUEST.qryComment.url[c]#" target="_blank">#REQUEST.qryComment.name[c]#</a></strong> - <em>#dateFormat(REQUEST.qryComment.dateCreated[c])#</em></p>
		<p>#paragraphFormat(REQUEST.qryComment.comment[c])#</p>
	</div>
	<p><a href="##content"><img src="assets/images/top_icon.gif" alt="top" /></a><a href="##content">top</a></p>
</cfloop>

<!-- comment form -->
<h2>Add A Comment </h2>
<form id="comment" name="comment" method="post" action="#REQUEST.myself##XFA.submit#">
	<label>Your Name<input type="text" name="name" /></label>
	<label>Email (not shared with anyone)<input type="text" name="email" /></label>
	<label>URL (linked in your post)<input type="text" name="url" /></label>
	<label>Comment<textarea name="comment" class="comment"></textarea></label>
	<button name="submit">Submit</button>
	<input type="hidden" name="entryID" value="#REQUEST.qryEntry.entryID[1]#" />
</form>

</cfoutput>