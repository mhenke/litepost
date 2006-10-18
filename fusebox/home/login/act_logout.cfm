	<cflock scope="SESSION" type="exclusive" throwontimeout="true" timeout="2">
		<cfset SESSION.user.structNew() />
		<cfset SESSION.user.isLoggedIn = "false" />
	</cflock>
	<cftrace type="information" category="security" text="Logout success." />