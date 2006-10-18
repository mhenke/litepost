<html>
	<head>
		<title>Litepost - Login</title>
	</head>
	<body>
	<cfoutput>
		<h3>Litepost - Login</h3>
		
		<form action="index.cfm?#getProperty('eventParameter')#=processLogin" method="post">
		<table border="0" width="500" cellpadding="2" cellspacing="1">
			<tr>
				<td align="right">User Name:</td>
				<td><input type="text" name="userName" size="30" maxlength="30" /></td>
			</tr>
			<tr>
				<td align="right">Password:</td>
				<td><input type="password" name="password" size="30" maxlength="30" /></td>
			</tr>
			<tr>
				<td align="center" colspan="2"><input type="submit" name="submit" value="Login" /></td>
			</tr>
		</table>
		</form>
	</cfoutput>
	</body>
</html>