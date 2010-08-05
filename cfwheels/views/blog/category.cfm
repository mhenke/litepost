<cfoutput>
	<h1>#label# Category</h1>
	
	<cfif flashKeyExists("message")>
		<p style="font-weight:bold;">#flash("message")#</p>
	</cfif>
	
	#startFormTag(action="saveCategory")#
		<input type="hidden" name="id" value="#category.id#" />
		<label>Category<br />
		<input name="category" type="text" value="#category.category#" />
		</label>
		<input type="submit" name="submit" value="#label#" class="adminbutton" />
	#endFormTag()#
</cfoutput>