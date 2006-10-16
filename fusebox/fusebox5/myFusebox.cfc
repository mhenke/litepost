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
<cfcomponent hint="I provide the per-request myFusebox data structure and some convenience methods.">
	<cfscript>
	this.version.runtime     = "unknown";
	this.version.loader      = "unknown";
	this.version.transformer = "unknown";
	this.version.parser      = "unknown";
	  
	this.version.runtime     = "5.0.0";
	  
	this.thisCircuit = "";
	this.thisFuseaction =  "";
	this.thisPlugin = "";
	this.thisPhase = "";
	this.plugins = structNew();
	this.parameters = structNew();
	
	// the basic default is development-full-load mode:
	this.parameters.load = true;
	this.parameters.parse = true;
	this.parameters.execute = true;
	// FB5: new execution parameters:
	this.parameters.clean = false;	 	// don't delete parsed files by default
	this.parameters.parseall = false;	// don't compile all fuseactions by default
	  
	this.parameters.userProvidedLoadParameter = false;
	this.parameters.userProvidedCleanParameter = false;
	this.parameters.userProvidedParseParameter = false;
	this.parameters.userProvidedParseAllParameter = false;
	this.parameters.userProvidedExecuteParameter = false;
	
	// stack frame for do/include parameters:
	this.stack = structNew();
	</cfscript>
	
	<cffunction name="init" returntype="myFusebox" access="public" output="false" 
				hint="I am the constructor.">
		<cfargument name="appKey" type="string" required="true" 
					hint="I am FUSEBOX_APPLICATION_KEY." />
		<cfargument name="attributes" type="struct" required="true" 
					hint="I am the attributes (URL and form variables) structure." />
		
		<cfset var theFusebox = structNew() />
		
		<cfset variables.created = getTickCount() />
		<cfset variables.log = arrayNew(1) />
		<cfset variables.occurrence = structNew() />

		<cfset variables.appKey = arguments.appKey />
		<cfset variables.attributes = arguments.attributes />
		
		<!--- we can't guarantee the fusebox exists in application scope yet... --->
		<cfif structKeyExists(application,variables.appKey)>
			<cfset theFusebox = application[variables.appKey] />
		</cfif>
		
		<!--- default myFusebox.parameters depending on "mode" of the application set in fusebox.xml --->
		<cfif structKeyExists(theFusebox,"mode")>
			<cfswitch expression="#theFusebox.mode#">
			<!--- FB41 backward compatibility - now deprecated --->
			<cfcase value="development">
				<cfif structKeyExists(theFusebox,"strictMode") and theFusebox.strictMode>
					<!--- since we don't load fusebox.xml if we throw an exception, we must fixup the value for the next run --->
					<cfset theFusebox.mode = "development-full-load" />
					<cfthrow type="fusebox.badGrammar.deprecated" 
							message="Deprecated feature"
							detail="'development' is a deprecated execution mode - use 'development-full-load' instead." />
				</cfif>
				<cfset this.parameters.load = true />
				<cfset this.parameters.parse = true />
				<cfset this.parameters.execute = true />
			</cfcase>
			<!--- FB5: replacement for old development mode --->
			<cfcase value="development-full-load">
				<cfset this.parameters.load = true />
				<cfset this.parameters.parse = true />
				<cfset this.parameters.execute = true />
			</cfcase>
			<!--- FB5: new option - does not load fusebox.xml and therefore does not (re-)load fuseboxApplication object --->
			<cfcase value="development-circuit-load">
				<cfset this.parameters.load = false />
				<cfset this.parameters.parse = true />
				<cfset this.parameters.execute = true />
			</cfcase>
			<cfcase value="production">
				<cfset this.parameters.load = false />
				<cfset this.parameters.parse = false />
				<cfset this.parameters.execute = true />
			</cfcase>
			<cfdefaultcase>
				<!--- since we don't load fusebox.xml if we throw an exception, we must fixup the value for the next run --->
				<cfset theFusebox.mode = "development-full-load" />
				<cfthrow type="fusebox.badGrammar.invalidParameterValue" 
						message="Parameter has invalid value" 
						detail="The parameter 'mode' must be one of 'development-full-load', 'development-circuit-load' or 'production' in the fusebox.xml file." />
			</cfdefaultcase>
			</cfswitch>
		</cfif>

		<!--- did the user pass in any special "fuseboxDOT" parameters for this request? --->
		<!--- If so, process them --->
		<!--- note: only if attributes.fusebox.password matches the application password --->
		<cfif not structKeyExists(variables.attributes,"fusebox.password")>
			<cfset variables.attributes["fusebox.password"] = "" />
		</cfif>
		<cfif structKeyExists(theFusebox,"password") and
				theFusebox.password is variables.attributes['fusebox.password']>
			<!--- FB5: does a load and wipes the parsed files out --->
			<cfif structKeyExists(variables.attributes,'fusebox.loadclean') and isBoolean(variables.attributes['fusebox.loadclean'])>
				<cfset this.parameters.load = variables.attributes['fusebox.loadclean'] />
				<cfset this.parameters.clean = variables.attributes['fusebox.loadclean'] />
				<cfset this.parameters.userProvidedLoadParameter = true />
				<cfset this.parameters.userProvidedCleanParameter = true />
			</cfif>
			<cfif structKeyExists(variables.attributes,'fusebox.load') and isBoolean(variables.attributes['fusebox.load'])>
				<cfset this.parameters.load = variables.attributes['fusebox.load'] />
				<cfset this.parameters.userProvidedLoadParameter = true />
			</cfif>
			<cfif structKeyExists(variables.attributes,'fusebox.parseall') and isBoolean(variables.attributes['fusebox.parseall'])>
				<cfset this.parameters.parse = variables.attributes['fusebox.parseall'] />
				<cfset this.parameters.parseall = variables.attributes['fusebox.parseall'] />
				<cfif this.parameters.parseall>
					<cfset this.parameters.load = true />
				</cfif>
				<cfset this.parameters.userProvidedParseParameter = true />
				<cfset this.parameters.userProvidedParseAllParameter = true />
			</cfif>
			<cfif structKeyExists(variables.attributes,'fusebox.parse') and isBoolean(variables.attributes['fusebox.parse'])>
				<cfset this.parameters.parse = variables.attributes['fusebox.parse'] />
				<cfset this.parameters.userProvidedParseParameter = true />
			</cfif>
			<cfif structKeyExists(variables.attributes,'fusebox.execute') and isBoolean(variables.attributes['fusebox.execute'])>
				<cfset this.parameters.execute = variables.attributes['fusebox.execute'] />
				<cfset this.parameters.userProvidedExecuteParameter = true />
			</cfif>
		</cfif>
		
		<!---
			force a load if the runtime and core versions differ: this allows a new
			version to be dropped in and the framework will automatically reload!
			note: that we must *force* a load, by pretending this is user-provided!
		--->
		<cfif structKeyExists(theFusebox,"getVersion") and
				isCustomFunction(theFusebox.getVersion)>
			<cfif this.version.runtime is not theFusebox.getVersion()>
				<cfset this.parameters.userProvidedLoadParameter = true />
				<cfset this.parameters.load = true />
			</cfif>
		<cfelse>
			<!--- hmm, doesn't look like the core is present (or it's not FB5 Alpha 2 or higher) --->
			<cfset this.parameters.userProvidedLoadParameter = true />
			<cfset this.parameters.load = true />
		</cfif>

		<!--- if the fusebox doesn't already exist we definitely want to reload --->
		<cfif structKeyExists(theFusebox,"isFullyLoaded") and
				theFusebox.isFullyLoaded>
			<!--- if fully loaded, leave the load parameter alone --->
		<cfelse>
			<cfset this.parameters.load = true />
		</cfif>
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getApplication" returntype="any" access="public" output="false" 
				hint="I am a convenience method to return the fuseboxApplication object without needing to know reference application scope or the FUSEBOX_APPLICATION_KEY variable.">
	
		<!---
			this is a bit of a hack since we're accessing application scope directly 
			but it's probably cleaner than exposing a method to allow fuseboxApplication
			to inject itself back into myFusebox during compileRequest()...
		--->
		<cfreturn application[variables.appKey] />
	
	</cffunction>
	
	<cffunction name="getCurrentCircuit" returntype="any" access="public" output="false" 
				hint="I am a convenience method to return the current Fusebox circuit object.">
	
		<cfreturn getApplication().circuits[this.thisCircuit] />
	
	</cffunction>
	
	<cffunction name="getCurrentFuseaction" returntype="any" access="public" output="false" 
				hint="I am a convenience method to return the current fuseboxAction (fuseaction) object.">
	
		<cfreturn getCurrentCircuit().fuseactions[this.thisFuseaction] />
	
	</cffunction>
	
	<cffunction name="enterStackFrame" returntype="void" access="public" output="false" 
				hint="I create a new stack frame (for scoped parameters to do/include).">
		
		<cfset var frame = structNew() />
		
		<cfset frame.__fuseboxStack = this.stack />
		<cfset this.stack = frame />
		
	</cffunction>
	
	<cffunction name="leaveStackFrame" returntype="void" access="public" output="false" 
				hint="I pop the last stack frame (for scoped parameters to do/include).">
		
		<cfset this.stack = this.stack.__fuseboxStack />
		
	</cffunction>
	
	<cffunction name="trace" returntype="void" access="public" output="false" 
				hint="I add a line to the execution trace log.">
		<cfargument name="type" hint="I am the type of trace (Fusebox, Compiler, Runtime are used by the framework)." />
		<cfargument name="message" hint="I am the message to put in the execution trace." />
		
		<cfset addTrace(getTickCount() - variables.created,arguments.type,arguments.message) />
		
	</cffunction>

	<cffunction name="addTrace" returntype="void" access="private" output="false" 
				hint="I add a detailed line to the execution trace log.">
		<cfargument name="time" hint="I am the time taken to get to this point in the request." />
		<cfargument name="type" hint="I am the type of trace." />
		<cfargument name="message" hint="I am the trace message." />
		<cfargument name="occurrence" default="0" hint="I am a placeholder for part of the struct that is added to the log." />
		
		<cfif structKeyExists(variables.occurrence,arguments.message)>
			<cfset variables.occurrence[arguments.message] = 1 + variables.occurrence[arguments.message] />
		<cfelse>
			<cfset variables.occurrence[arguments.message] = 1 />
		</cfif>
		<cfset arguments.occurrence = variables.occurrence[arguments.message] />
		<cfset arrayAppend(variables.log,arguments) />
		
	</cffunction>
	
	<cffunction name="renderTrace" returntype="string" access="public" output="false" hint="I render the trace log as HTML.">
		
		<cfset var result = "" />
		<cfset var i = 0 />
		
		<cfsavecontent variable="result">
			<br />
			<div style="clear:both;padding-top:10px;border-bottom:1px Solid #CCC;font-family:verdana;font-size:16px;font-weight:bold">Fusebox debugging:</div>
			<br />
			<table cellpadding="2" cellspacing="0" width="100%" style="border:1px Solid ##CCC;font-family:verdana;font-size:11pt;">
				<tr style="background:##EAEAEA">
					<td style="border-bottom:1px Solid ##CCC;font-family:verdana;font-size:11pt;"><strong>Time</strong></td>
					<td style="border-bottom:1px Solid ##CCC;font-family:verdana;font-size:11pt;"><strong>Category</strong></td>
					<td style="border-bottom:1px Solid ##CCC;font-family:verdana;font-size:11pt;"><strong>Message</strong></td>
					<td style="border-bottom:1px Solid ##CCC;font-family:verdana;font-size:11pt;"><strong>Count</strong></td>
				</tr>
				<cfloop index="i" from="1" to="#arrayLen(variables.log)#">
					<cfoutput>
						<cfif i mod 2>
							<tr style="background:##F9F9F9">
						<cfelse>
							<tr style="background:##FFFFFF">
						</cfif>
						<td valign="top" style="font-size:10pt;border-bottom:1px Solid ##CCC;font-family:verdana;">#variables.log[i].time#ms</td>
						<td valign="top" style="font-size:10pt;border-bottom:1px Solid ##CCC;font-family:verdana;">#variables.log[i].type#</td>
						<td valign="top" style="font-size:10pt;border-bottom:1px Solid ##CCC;font-family:verdana;">#variables.log[i].message#</td>
						<td valign="top" align="center" style="font-size:10pt;border-bottom:1px Solid ##CCC;font-family:verdana;">#variables.log[i].occurrence#</td>
					</tr></cfoutput>
				</cfloop>
			</table>
		</cfsavecontent>
		
		<cfreturn result />
		
	</cffunction>

</cfcomponent>
