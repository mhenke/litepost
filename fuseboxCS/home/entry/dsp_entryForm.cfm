<!---- set default values ---->
<cfparam name="ATTRIBUTES.title" default="" type="string" />
<cfparam name="ATTRIBUTES.body" default="" type="string" />
<cfparam name="ATTRIBUTES.categoryID" default="0" type="string" />
<cfparam name="ATTRIBUTES.entryID" default="0" type="string" />

<cfoutput>
<!---- dsp_entryForm ---->
<h1>Add/Edit Entry</h1>

<form id="editEntry" name="editEntry" action="#REQUEST.myself##XFA.submit#" method="post" id="entryForm">
  	<label>Title<br /><input name="title" type="text" value="#ATTRIBUTES.title#" /></label>
	<label>Entry<br /><textarea name="body" class="entry" cols="" rows="">#ATTRIBUTES.body#</textarea></label>
	<label>Category<br />
		<select name="categoryID">
			<option value="0">None</option>
			<cfloop from="1" to="#arrayLen(REQUEST.categories)#" index="c">
				<option value="#REQUEST.categories[c].getCategoryID()#" #iif(ATTRIBUTES.categoryID EQ REQUEST.categories[c].getCategoryID(), DE('selected'), DE(''))#>#REQUEST.categories[c].getCategory()#</option>
			</cfloop>
		</select>
	</label>
	<button name="submit">Submit</button>
	<input type="hidden" name="entryID" value="#ATTRIBUTES.entryID#" />
</form>

</cfoutput>