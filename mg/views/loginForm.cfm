<cfsilent>
	<cfset message = viewState.getValue("message") />
	<cfset myself = viewState.getValue("myself") />
	<cfset submitEvent = viewState.getValue("submitEvent") />
</cfsilent>

<cfoutput>
<center>
	<h3>Login</h3>
	
	<!--- entry form --->
	<form action="#myself##submitEvent#" method="post">
	 
	#message#
	<p>
	Username:<br />
	<input type="text" name="username" size="20" maxlength="20" />
	<br />
	password:<br />
	<input type="password" name="password" size="20" maxlength="20" />
	</p>
	<p>
	<input type="submit" name="submit" value="login" />
	</p>
	
	</form>
</center>
</cfoutput>