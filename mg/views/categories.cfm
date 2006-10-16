
<!--- categories sidebar --->
<cfsilent>
	<cfset categories = viewState.getValue("categories") />
</cfsilent>

<b>Categories</b>

<p>
<cfoutput>
	<cfloop from="1" to="#ArrayLen(categories)#" index="i">
		<cfset category = categories[i] />
		<cfset catID = category.getCategoryID() />
		<a href="">#category.getCategory()# (#category.getNumPosts()#)</a><br />
	</cfloop>
</cfoutput>
</p>