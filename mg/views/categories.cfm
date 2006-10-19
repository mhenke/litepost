
<!--- categories sidebar --->
<cfsilent>
	<cfset categories = viewState.getValue("categories") />
	<cfset isAdmin = viewState.getValue("isAdmin") />
	<cfset myself = viewState.getValue("myself") />
</cfsilent>

<b>Categories</b>

<p>
<cfoutput>
	<cfloop from="1" to="#ArrayLen(categories)#" index="i">
		<cfset category = categories[i] />
		<cfset catID = category.getCategoryID() />
		<a href="#myself#home&categoryID=#catID#">#category.getCategory()# (#category.getNumPosts()#)</a><br />
	</cfloop>
</cfoutput>
</p>