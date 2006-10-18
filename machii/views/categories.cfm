
<!--- categories sidebar --->
<cfsilent>
	<cfset categories = event.getArg("categories") />
</cfsilent>

<b>Categories</b>

<p>
<cfoutput>
	<cfif arrayLen(categories) gt 0>
		<cfloop from="1" to="#ArrayLen(categories)#" index="i">
			<cfset category = categories[i] />
			<cfset catID = category.getCategoryID() />
			<a href="">#category.getCategory()# (#category.getNumPosts()#)</a><br />
		</cfloop>
	<cfelse>
		- no categories -
	</cfif>
</cfoutput>
</p>