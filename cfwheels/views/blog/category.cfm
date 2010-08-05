


<cfsilent>
	
	
	<cfif category.getCategoryID() gt 0>
		<cfset local.label="Update" />
	<cfelse>
		<cfset local.label="Create" />
	</cfif>
	<cfset params.title = 'LitePost Blog - #local.label# Category' />
</cfsilent>

<cfoutput>
	<h1>#local.label# Category</h1>
	
	<cfif flashKeyExists("message")>
		<p style="font-weight:bold;">#flash("message")#</p>
	</cfif>
	
	#startFormTag(action="saveCategory")#
		<input type="hidden" name="categoryID" value="#category.getCategoryID()#" />
		<label>Category<br />
		<input name="category" type="text" value="#category.getCategory()#" />
		</label>
		<input type="submit" name="submit" value="#local.label#" class="adminbutton" />
	#endFormTag()#
</cfoutput>