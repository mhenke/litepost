<cfquery name="REQUEST.qryCategory" datasource="#APPLICATION.settings.dsn.name#" username="#APPLICATION.settings.dsn.username#" password="#APPLICATION.settings.dsn.password#">
	SELECT	categoryID, category
	FROM	categories
	ORDER BY category
</cfquery>