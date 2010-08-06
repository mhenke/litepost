<cfoutput>
	<h1>#label# Link</h1>
	
	<cfif flashKeyExists("message")>
		<p style="font-weight:bold;">#flash("message")#</p>
	</cfif>
	
	#errorMessagesFor("bookmark")#
	
	#startFormTag(action="saveBookmark")#
		#hiddenField(objectName="bookmark", property="id")#
		#textField(label="Name", objectName="bookmark", property="name")#
		#textField(label="Url", objectName="bookmark", property="url")#
		<!---<label>Name<br />
		<input name="name" type="text" value="#bookmark.name#" />
		</label>--->
		#submitTag(value="#label#", class="adminbutton")#
	#endFormTag()#
</cfoutput>