<cfoutput>

<div>
	<h2>
		Categories
		<cfif params.isAdmin>
			#linkTo(text="#imageTag(source="add_icon.gif", border="0", title="Add Category")#", controller="blog", action="category")#
		</cfif>
	</h2>
</div>

<ul>
	<cfif categories.recordcount EQ 0>
		<li><em>no categories</em></li>
	<cfelse>
	<cfabort>
		<cfoutput query="categories">
			
			<li>
				#linkTo(text="#title#", controller="blog", action="main", key=id)# (number of posts)
				
				#linkTo(text="rss", controller="blog", action="rss", params="categoryID=#id#&categoryName=#title#")#
				
				<cfif params.isAdmin>
					&nbsp;
					#linkTo(text="#imageTag(source="edit_icon.gif", border="0", title="Edit Category")#", controller="blog", action="entry",key=id)#
					#linkTo(text="#imageTag(source="delete_icon.gif", border="0", title="Delete Category")#", controller="blog", action="deleteCategory",confirm="Are you sure you want to delete this category?",key=id)#
				</cfif>
			</li>
			
		</cfoutput>
		
	</cfif>

</ul>

</cfoutput>