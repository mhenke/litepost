<cfoutput>
	<h1>#label# Category</h1>
	
	<cfif flashKeyExists("message")>
		<p style="font-weight:bold;">#flash("message")#</p>
	</cfif>
	
	#errorMessagesFor("category")#
	
	#startFormTag(action="saveCategory")#
		#hiddenField(objectName="category", property="id")#
		#textField(label="Category", objectName="category", property="category")#
		#submitTag(value="#label#", class="adminbutton")#
	#endFormTag()#
</cfoutput>