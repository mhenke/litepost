<cftry><cfsilent> <!--- on one line to avoid leading whitespace --->
<!---
Fusebox Software License
Version 1.0

Copyright (c) 2003, 2004, 2005, 2006 The Fusebox Corporation. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted 
provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions 
   and the following disclaimer.

2. Redistributions in binary form or otherwise encrypted form must reproduce the above copyright 
   notice, this list of conditions and the following disclaimer in the documentation and/or other 
   materials provided with the distribution.

3. The end-user documentation included with the redistribution, if any, must include the following 
   acknowledgment:

   "This product includes software developed by the Fusebox Corporation (http://www.fusebox.org/)."

   Alternately, this acknowledgment may appear in the software itself, if and wherever such 
   third-party acknowledgments normally appear.

4. The names "Fusebox" and "Fusebox Corporation" must not be used to endorse or promote products 
   derived from this software without prior written (non-electronic) permission. For written 
   permission, please contact fusebox@fusebox.org.

5. Products derived from this software may not be called "Fusebox", nor may "Fusebox" appear in 
   their name, without prior written (non-electronic) permission of the Fusebox Corporation. For 
   written permission, please contact fusebox@fusebox.org.

If one or more of the above conditions are violated, then this license is immediately revoked and 
can be re-instated only upon prior written authorization of the Fusebox Corporation.

THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE 
DISCLAIMED. IN NO EVENT SHALL THE FUSEBOX CORPORATION OR ITS CONTRIBUTORS BE LIABLE FOR ANY 
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, 
STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

-------------------------------------------------------------------------------

This software consists of voluntary contributions made by many individuals on behalf of the 
Fusebox Corporation. For more information on Fusebox, please see <http://www.fusebox.org/>.

--->

<!--- FB5: allow "" default - FB41 required this variable: --->
<cfparam name="variables.FUSEBOX_APPLICATION_PATH" type="string" default="" />
<!--- FB5: application key - FB41 always uses 'fusebox': --->
<cfparam name="variables.FUSEBOX_APPLICATION_KEY" type="string" default="fusebox" />

<cfparam name="variables.attributes" type="struct" default="#structNew()#" />
<cfset structAppend(attributes,URL,true) />
<cfset structAppend(attributes,form,true) />

<!--- FB5: myFusebox is an object but has FB41-compatible public properties --->
<cfset myFusebox = createObject("component","myFusebox").init(FUSEBOX_APPLICATION_KEY,attributes) />
<!--- FB5: indicates whether application was started on this request --->
<cfset myFusebox.applicationStart = false />
<!--- FB5: uses request.__fusebox for internal tracking of compiler / runtime operations: --->
<cfset request.__fusebox = structNew() />
<!---
	complex condition allows FB5 to drop into a running FB41 site and force re-init because
	FB41 application.fusebox will not have compileRequest() method - this should make upgrades
	to FB5 easier!
--->
<cfif not structKeyExists(application,FUSEBOX_APPLICATION_KEY) or myFusebox.parameters.load>
	<cflock name="#application.ApplicationName#_fusebox_#FUSEBOX_APPLICATION_KEY#" type="exclusive" timeout="300">
		<cfif not structKeyExists(application,FUSEBOX_APPLICATION_KEY) or myFusebox.parameters.load>
			<!--- if it doesn't exisit or the user explicitly requested a load, it --->
			<cfif not structKeyExists(application,FUSEBOX_APPLICATION_KEY) or myFusebox.parameters.userProvidedLoadParameter>
				<!--- can't be conditional: we don't know the state of the debug flag yet --->
				<cfset myFusebox.trace("Fusebox","Creating Fusebox application object") />
				<cfset _fba = createObject("component","fuseboxApplication") />
				<cfset application[FUSEBOX_APPLICATION_KEY] = _fba.init(FUSEBOX_APPLICATION_KEY,FUSEBOX_APPLICATION_PATH,myFusebox) />
			<cfelse>
				<!--- can't be conditional: we don't know the state of the debug flag yet --->
				<cfset myFusebox.trace("Fusebox","Reloading Fusebox application object") />
				<cfset _fba = application[FUSEBOX_APPLICATION_KEY] />
				<!--- it exists and the load is implicit, not explicit (via user) so just reload XML --->
				<cfset _fba.reload(FUSEBOX_APPLICATION_KEY,FUSEBOX_APPLICATION_PATH,myFusebox) />
			</cfif>
			<!--- fix attributes precedence --->
			<cfif _fba.precedenceFormOrURL is "URL">
				<cfset structAppend(attributes,URL,true) />
			</cfif>
			<!--- set the default fuseaction if necessary --->
			<cfif not structKeyExists(attributes,_fba.fuseactionVariable) or attributes[_fba.fuseactionVariable] is "">
				<cfset attributes[_fba.fuseactionVariable] = _fba.defaultFuseaction />
			</cfif>
			<!--- set this up for fusebox.appinit.cfm --->
			<cfset attributes.fuseaction = attributes[_fba.fuseactionVariable] />
			<!--- flag this as the first request for the application --->
			<cfset myFusebox.applicationStart = true />
			<!--- force parse after reload for consistency in development modes --->
			<cfif _fba.mode is not "production" or myFusebox.parameters.userProvidedLoadParameter>
				<cfset myFusebox.parameters.parse = true />
			</cfif>
			<!--- need all of the above set before we attempt any compiles! --->
			<cfif myFusebox.parameters.parseall>
				<cfset _fba.compileAll(myFusebox) />
			</cfif>
			<!--- FB5: new appinit include file --->
			<cfif _fba.debug>
				<cfset myFusebox.trace("Fusebox","Including fusebox.appinit.cfm") />
			</cfif>
			<cftry>
				<cfinclude template="#_fba.getCoreToAppRootPath()#fusebox.appinit.cfm" />
			<cfcatch type="missinginclude" />
			</cftry>
		<cfelse>
			<cfset _fba = application[FUSEBOX_APPLICATION_KEY] />
			<!--- fix attributes precedence --->
			<cfif _fba.precedenceFormOrURL is "URL">
				<cfset structAppend(attributes,URL,true) />
			</cfif>
			<!--- set the default fuseaction if necessary --->
			<cfif not structKeyExists(attributes,_fba.fuseactionVariable) or attributes[_fba.fuseactionVariable] is "">
				<cfset attributes[_fba.fuseactionVariable] = _fba.defaultFuseaction />
			</cfif>
			<cfset attributes.fuseaction = attributes[_fba.fuseactionVariable] />
		</cfif>
	</cflock>
<cfelse>
	<cfset _fba = application[FUSEBOX_APPLICATION_KEY] />
	<!--- fix attributes precedence --->
	<cfif _fba.precedenceFormOrURL is "URL">
		<cfset structAppend(attributes,URL,true) />
	</cfif>
	<!--- set the default fuseaction if necessary --->
	<cfif not structKeyExists(attributes,_fba.fuseactionVariable) or attributes[_fba.fuseactionVariable] is "">
		<cfset attributes[_fba.fuseactionVariable] = _fba.defaultFuseaction />
	</cfif>
	<cfset attributes.fuseaction = attributes[_fba.fuseactionVariable] />
</cfif>
<!---
	Fusebox 4.1 did not set attributes.fuseaction or default the fuseaction variable until
	*after* fusebox.init.cfm had run. This made it hard for fusebox.init.cfm to do URL
	rewriting. For Fusebox 5, we default the fuseaction variable and set attributes.fuseaction
	before fusebox.init.cfm so it can rely on attributes.fuseaction and rewrite that. However,
	in order to maintain backward compatibility, we need to allow fusebox.init.cfm to set
	attributes[_fba.fuseactionVariable] and still have that reflected in attributes.fuseaction
	and for that to actually be the request that gets processed.
--->
<cfif _fba.debug>
	<cfset myFusebox.trace("Fusebox","Including fusebox.init.cfm") />
</cfif>
<cftry>
	<cfset _fba_attr_fav = attributes[_fba.fuseactionVariable] />
	<cfset _fba_attr_fa = attributes.fuseaction />
	<cfinclude template="#_fba.getCoreToAppRootPath()#fusebox.init.cfm" />
	<cfif attributes.fuseaction is not _fba_attr_fa>
		<cfif attributes.fuseaction is not attributes[_fba.fuseactionVariable]>
			<cfif attributes[_fba.fuseactionVariable] is not _fba_attr_fav>
				<!--- inconsistent modification of both variables?!? --->
				<cfthrow type="fusebox.inconsistentFuseaction"
						message="Inconsistent fuseaction variables"
						detail="Both attributes.fuseaction and attributes[{fusebox}.fuseactionVariable] changed in fusebox.init.cfm so Fusebox doesn't know what to do with the values!" />
			<cfelse>
				<!--- ok, only attributes.fuseaction changed --->
				<cfset attributes[_fba.fuseactionVariable] = attributes.fuseaction />
			</cfif>
		<cfelse>
			<!--- ok, they were both changed and they match --->
		</cfif>
	<cfelse>
		<!--- attributes.fuseaction did not change --->
		<cfif attributes[_fba.fuseactionVariable] is not _fba_attr_fav>
			<!--- make attributes.fuseaction match the other changed variable --->
			<cfset attributes.fuseaction = attributes[_fba.fuseactionVariable] />
		<cfelse>
			<!--- ok, neither variable changed --->
		</cfif>
	</cfif>
<cfcatch type="missinginclude" />
</cftry>
<!---
	must special case development-circuit-load mode since it causes circuits to reload during
	the compile (post-load) phase and therefore must be exclusive
--->
<cfif _fba.debug>
	<cfset myFusebox.trace("Fusebox","Compiling requested fuseaction '#attributes.fuseaction#'") />
</cfif>
<cfif _fba.mode is "development-circuit-load">
	<cflock name="#application.ApplicationName#_fusebox_#FUSEBOX_APPLICATION_KEY#" type="exclusive" timeout="300">
		<cfset _parsedFileData = _fba.compileRequest(attributes.fuseaction,myFusebox) />
	</cflock>
<cfelse>
	<cflock name="#application.ApplicationName#_fusebox_#FUSEBOX_APPLICATION_KEY#" type="readonly" timeout="300">
		<cfset _parsedFileData = _fba.compileRequest(attributes.fuseaction,myFusebox) />
	</cflock>
</cfif>
</cfsilent><cfprocessingdirective suppresswhitespace="true">
<cfif myFusebox.parameters.execute>
	<cfif _fba.debug>
		<cfset myFusebox.trace("Fusebox","Including parsed file for '#attributes.fuseaction#'") />
	</cfif>
	<cftry>
		<!---
			readonly lock protects against including the parsed file while
			another threading is writing it...
		--->
		<cflock name="#_parsedFileData.lockName#" type="readonly" timeout="30">
			<cfinclude template="#_parsedFileData.parsedFile#" />
		</cflock>
	<cfcatch type="missinginclude">
		<cfif right(cfcatch.missingFileName, len(_parsedFileData.parsedName)) is _parsedFileData.parsedName>
			<cfthrow type="fusebox.missingParsedFile" 
					message="Parsed File or Directory not found."
					detail="Attempting to execute the parsed file '#_parsedFileData.parsedName#' threw an error. This can occur if the parsed file does not exist in the parsed directory or if the parsed directory itself is missing." />
		<cfelse>
			<cfrethrow />
		</cfif>
	</cfcatch>
	</cftry>
</cfif>
</cfprocessingdirective>
<cfcatch type="fusebox">
	<cfif isDefined("_fba.debug") and _fba.debug and isDefined("myFusebox")>
		<cfset myFusebox.trace("Fusebox","Caught Fusebox exception '#cfcatch.type#'") />
	</cfif>
	<cfif not isDefined("_fba.errortemplatesPath") or not _fba.handleFuseboxException(cfcatch)>
		<cfrethrow /> 
	</cfif>
</cfcatch>
</cftry>
<cfset myFusebox.trace("Fusebox","Request completed") />
<cfif isDefined("_fba.debug") and _fba.debug and isDefined("myFusebox")>
	<cfoutput>#myFusebox.renderTrace()#</cfoutput>
</cfif>
