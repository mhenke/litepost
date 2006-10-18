<!-----------------------------

Error message

------------------------------>
<cfsavecontent variable="REQUEST.content.body">
<cfoutput>
	<div id="error">
		<h3>#CFCATCH.message#</h3>
		<p>#CFCATCH.detail# (#CFCATCH.type#)</p>
	</div>
	<button tyle="button" onclick="window.history.go(-1);">Back</button>
</cfoutput>
</cfsavecontent>

<cfinclude template="../layouts/lay_main.cfm" />

<cfabort/>