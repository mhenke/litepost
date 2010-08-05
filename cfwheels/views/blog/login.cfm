


<cfsilent>
	<cfset params.title = "LitePost - Login" />
</cfsilent>

<cfoutput>
	<h1>Please Log In</h1>
		
	<cfif flashKeyExists("message")>
		<p style="color:red;font-weight:bold;" align="center">#flash("message")#</p>
	</cfif>
	
	#startFormTag(action="doLogin")#
	  	<label>Username<br />
	  	<input name="userName" type="text" maxlength="30" />
		</label>
		<label>Password<br />
		<input name="password" type="password" maxlength="30" />
		</label>
		<input type="submit" name="submit" value="Log In" class="adminbutton" />
	#endFormTag()#
</cfoutput>