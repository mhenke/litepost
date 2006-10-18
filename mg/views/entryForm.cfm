<cfsilent>
	<cfset entryBean = viewState.getValue("entryBean") />
	<cfset categories = viewState.getValue("categories") />
	<cfset message = viewState.getValue("message") />
	<cfset isAdmin = viewState.getValue("isAdmin") />
	<cfset myself = viewState.getValue("myself") />
	
	<cfif entryBean.getEntryID() GT 0>
		<cfset label = "Update" />
	<cfelse>
		<cfset label = "Add" />
	</cfif>
</cfsilent>

<cfoutput>

	<h3>#label# Entry</h3>
	
	<!--- entry form --->
	<form action="#myself#saveEntry" method="post">
	<input type="hidden" name="entryID" value="#entryBean.getEntryID()#" />
	 
	#message#
	<p>
	Title:<br />
	<input type="text" name="title" value="#entryBean.getTitle()#"  size="45" maxlength="255" />
	<br />
	<cfset currCatID = entryBean.getCategoryID() />
	Category:<br />
	<select size="1" name="categoryID">
		<option value="-1" selected>- Select -</option>
		<option value="0" <cfif currCatID EQ 0>selected</cfif>>- None -</option>
		<cfloop from="1" to="#ArrayLen(categories)#" index="ix">
			<option value="#categories[ix].getCategoryID()#" <cfif currCatID EQ categories[ix].getCategoryID()>selected</cfif>>#categories[ix].getCategory()#</option>
		</cfloop>
	</select>
	<br />
	Entry:<br />
	<textarea name="body" cols="60" rows="18">#entryBean.getBody()#</textarea>
	</p>
	<p>
	<input type="submit" name="submit" value="#label# Entry" />
	</p>
	
	</form>
</cfoutput>