<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE circuit>
<circuit name="category" access="public">

	<!--
	
	PUBLIC
	
	-->
	
	<fuseaction name="form">
		<xfa name="submit" value="create" />
		<include template="dsp_categoryForm.cfm" contentvariable="REQUEST.content.body" />
	</fuseaction>
	
	<fuseaction name="add">
		<if condition="NOT structKeyExists(FORM, 'fieldnames')">
			<true>
				<relocate url="#REQUEST.myself##XFA.home#" />
			</true>
		</if>
		<do action="create" />
		<do action="home.message">
			<parameter name="title" value="Category Added" />
			<parameter name="message" value="Your category has been added" />
			<parameter name="forward" value="entry.recent" />
		</do>
	</fuseaction>
	
	<!--
	
	PUBLIC
	
	-->
	
	<fuseaction name="get" access="internal">
		<include template="qry_getCategories" />
	</fuseaction>
	
	<fuseaction name="create" access="internal" roles="admin">
		<include template="act_createCategory" />
	</fuseaction>
	
	<fuseaction name="delete" access="internal" roles="admin">
		<set name="categoryID" value="0" overwrite="false" />
		<include template="act_deleteCategory" />
	</fuseaction>
	
	
</circuit>
