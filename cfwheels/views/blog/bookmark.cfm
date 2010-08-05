<cfoutput>
	<h1>#label# Link</h1>
	
	<cfif flashKeyExists("message")>
		<p style="font-weight:bold;">#flash("message")#</p>
	</cfif>
	
	#startFormTag(action="saveBookmark")#
		<input type="hidden" name="id" value="#bookmark.id#" />
		<label>Name<br />
		<input name="name" type="text" value="#bookmark.name#" />
		</label>
		<label>Url<br />
		<input name="url" type="text" value="#bookmark.url#" />
		</label>
		<input type="submit" name="submit" value="#label#" class="adminbutton" />
	#endFormTag()#
</cfoutput>