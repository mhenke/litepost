	<cfoutput>
		<cfif event.isArgDefined("message")>
			<p style="color:red;font-weight:bold;" align="center">#event.getArg("message")#</p>
		</cfif>
		
		<form action="index.cfm?#getProperty('eventParameter')#=processLogin" method="post">
		<table border="0" cellpadding="2" cellspacing="1" align="center" width="100%">
			<tr>
				<td align="right" width="50%">User Name:</td>
				<td width="50%"><input type="text" name="userName" size="30" maxlength="30" /></td>
			</tr>
			<tr>
				<td align="right" width="50%">Password:</td>
				<td width="50%"><input type="password" name="password" size="30" maxlength="30" /></td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td><input type="submit" name="submit" value="Login" /></td>
			</tr>
		</table>
		</form>
	</cfoutput>
