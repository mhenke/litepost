<cfparam name="params.isAdmin" default="false" />
<cfparam name="framework.action" default="" />

<cfsilent>
	<cfparam name="params.message" default="" />
	
	<cfif category.getCategoryID() gt 0>
		<cfset local.label="Update" />
	<cfelse>
		<cfset local.label="Create" />
	</cfif>
	<cfset params.title = 'LitePost Blog - #local.label# Category' />
</cfsilent>

<cfoutput>
	<h1>#local.label# Category</h1>
	
	<cfif len(params.message)>
		<p><strong>#params.message#</strong></p>
	</cfif>
	
	<form id="editCategory" name="editCategory" method="post" action="?#framework.action#=blog.saveCategory">
		<input type="hidden" name="categoryID" value="#category.getCategoryID()#" />
		<label>Category<br />
		<input name="category" type="text" value="#category.getCategory()#" />
		</label>
		<input type="submit" name="submit" value="#local.label#" class="adminbutton" />
	</form>
</cfoutput>