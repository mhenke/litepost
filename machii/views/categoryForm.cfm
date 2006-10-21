<cfsilent>
	<cfset category = event.getArg("category") />
	<cfif not category.getCategoryID() eq 0>
		<cfset label="Update" />
	<cfelse>
		<cfset label="Add" />
	</cfif>
</cfsilent>

<cfoutput>
	<h1>#label# Category </h1>
	
	<form id="editCategory" name="editCategory" method="post" action="index.cfm?#getProperty('eventParameter')#=processCategoryForm">
		<label>Category<br />
		<input name="category" type="text" value="#category.getCategory()#" />
		</label>
		<!--- <button name="submit">Submit</button> --->
		<input type="submit" name="submit" value="#label# Category" class="adminbutton" />
	</form>
</cfoutput>