
<!--- categories sidebar --->
<cfsilent>
	<cfset categories = event.getArg("categories") />
</cfsilent>

<h2>Categories</h2>

<ul>
<cfoutput>
	<cfif arrayLen(categories) gt 0>
		<cfloop from="1" to="#ArrayLen(categories)#" index="i">
			<cfset category = categories[i] />
			<li><a href="index.cfm?#getProperty('eventParameter')#=showHome&categoryID=#category.getCategoryID()#">#category.getCategory()# (#category.getNumPosts()#)</a><br /></li>
		</cfloop>
	<cfelse>
		<li><em>no categories</em></li>
	</cfif>
</cfoutput>
</ul>
