<cfoutput>
	<cfif flashKeyExists("message")>
		<p style="font-weight:bold;">#flash("message")#</p>
	</cfif>
	
	#errorMessagesFor("comment")#

	<h2>Add A Comment </h2>
	#startFormTag(action="saveComment")#
		#hiddenFieldTag(name="comment[entryID]", value=entry.id)#
		#textField(label="Your Name", objectName="comment", property="name")#
		#textField(label="Email (not shared with anyone)", objectName="comment", property="email")#
		#textField(label="URL (linked in your post)", objectName="comment", property="url")#
		#textArea(label="Comment", objectName="comment", property="comment",class="comment")#
		#submitTag(value="Submit", class="adminbutton")#
	#endFormTag()#
  <p>&nbsp;</p>
</cfoutput>