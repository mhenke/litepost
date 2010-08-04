<cfparam name="params.isAdmin" default="false" />
<cfparam name="framework.action" default="" />

<cfsilent>
	<cfparam name="params.message" default="" />
	<cfparam name="framework.action" default="" />
	
	<cfif entries.id GT 0>
		<cfset local.label = "Update" />
	<cfelse>
		<cfset local.label = "Add" />
	</cfif>
	<cfset params.title = 'LitePost Blog - #local.label# Entry' />
</cfsilent>

<cfoutput>

	<h1>#local.label# Entry</h1>
	
	<cfif len(params.message)>
		<p><strong>#params.message#</strong></p>
	</cfif>
	
	<form id="editEntry" name="editEntry" action="?#framework.action#=blog.saveEntry" method="post">
		<input type="hidden" name="entryID" value="#entries.id#" />
		<label>Title<br />
		<input name="title" type="text" value="#entries.title#" />
		</label>
		<label>Category<br />
		<cfset local.currCatID = entries.CategoryID />
		<select name="categoryID">
			<option value="-1" selected>- Select -</option>
			<option value="0" <cfif local.currCatID EQ 0>selected</cfif>>- None -</option>
			<cfloop query="categories">
				<option value="#categories.id#"<cfif categories.id eq entries.CategoryID> selected</cfif>>#categories.title #</option>
			</cfloop>
		</select>
		</label>
		<label>Entry<br />
		<textarea name="body" class="entry" cols="" rows="">#entries.body#</textarea>
		</label>
		<input type="submit" name="submit" value="#local.label# Entry" class="adminbutton" />
	</form>
	
</cfoutput>