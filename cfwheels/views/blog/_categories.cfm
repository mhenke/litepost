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
		<cfloop query="categories">
			
			<li>
				#linkTo(text="#categories.category#", controller="blog", action="main", params="categoryId=#categories.id#")# (#categories.categoriesCount#)
				
				#linkTo(text="rss", controller="blog", action="rss", params="categoryID=#id#&categoryName=#title#")#
				
				<cfif params.isAdmin>
					&nbsp;
					#linkTo(text="#imageTag(source="edit_icon.gif", border="0", title="Edit Category")#", controller="blog", action="category",key=categories.id)#
					#linkTo(text="#imageTag(source="delete_icon.gif", border="0", title="Delete Category")#", controller="blog", action="deleteCategory",confirm="Are you sure you want to delete this category?",key=categories.id)#
				</cfif>
			</li>
			
		</cfloop>
		
	</cfif>

</ul>

</cfoutput>