<cfoutput>
<cfdump var="#bookmark#">
	<h1>#label# Entry</h1>
	
	<cfif flashKeyExists("message")>
		<p style="font-weight:bold;">#flash("message")#</p>
	</cfif>
	#startFormTag(action="saveEntry")#
		<input type="hidden" name="entryID" value="#entry.id#" />
		<label>Title<br />
		<input name="title" type="text" value="#entry.title#" />
		</label>
		<label>Category<br />
		<cfset currCatID = entry.CategoryID />
		<select name="categoryID">
			<option value="-1" selected>- Select -</option>
			<option value="0" <cfif currCatID EQ 0>selected</cfif>>- None -</option>
			<cfloop query="categories">
				<option value="#categories.id#"<cfif categories.id eq entry.CategoryID> selected</cfif>>#categories.category#</option>
			</cfloop>
		</select>
		</label>
		<label>Entry<br />
		<textarea name="body" class="entry" cols="" rows="">#entry.body#</textarea>
		</label>
		<input type="submit" name="submit" value="#label# Entry" class="adminbutton" />
	#endFormTag()#
	
</cfoutput>