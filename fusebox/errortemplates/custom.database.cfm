<cfsavecontent variable="REQUEST.content.body">
	<cfoutput>
		<h1>A error has occured!</h1>
		<p><cfif myFuseBox.getApplication().debug>#CFCATCH.detail#<cfelse>#CFCATCH.message#</cfif></p>
	</cfoutput>
</cfsavecontent>

<cfinclude template="../layout/lay_main.cfm" />

<cfabort />