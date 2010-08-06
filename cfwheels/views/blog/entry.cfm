<cfoutput>
	<h1>#label# Entry</h1>
	
	<cfif flashKeyExists("message")>
		<p style="font-weight:bold;">#flash("message")#</p>
	</cfif>
	#errorMessagesFor("entry")#

	#startFormTag(action="saveEntry")#
		#hiddenField(objectName="entry", property="userID")#
		#hiddenField(objectName="entry", property="id")#
		#hiddenField(objectName="entry", property="dateLastUpdated")#

		#textField(label="Title", objectName="entry", property="title")#
		#select(
    		label="Category", objectName="entry", property="categoryID",options=categories,includeBlank="- Select -"
		)#
		#textArea(label="Entry", objectName="entry", property="body",class="entry")#
		#submitTag(value="#label# Entry", class="adminbutton")#
	#endFormTag()#
</cfoutput>