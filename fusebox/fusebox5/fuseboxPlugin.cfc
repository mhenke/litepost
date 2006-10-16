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
<cfcomponent output="false" hint="I represent a plugin declaration.">

	<cffunction name="init" returntype="fuseboxPlugin" access="public" output="false" 
				hint="I am the constructor.">
		<cfargument name="phase" type="string" required="true" 
					hint="I am the phase with which this plugin is associated." />
		<cfargument name="pluginXML" type="any" required="true" 
					hint="I am the XML representation of this plugin's declaration." />
		<cfargument name="fbApp" type="fuseboxApplication" required="true" 
					hint="I am the fusebox application object." />
	
		<cfset var i = 0 />
		<cfset var n = arrayLen(arguments.pluginXML.xmlChildren) />
		<cfset var attr = 0 />
		<cfset var nAttrs = 2 />
		<cfset var verbChildren = arrayNew(1) />
		<cfset var factory = arguments.fbApp.getFuseactionFactory() />
		<cfset var ext = "." & arguments.fbApp.scriptFileDelimiter />
		
		<cfif not structKeyExists(arguments.pluginXML.xmlAttributes,"name")>
			<cfthrow type="fusebox.badGrammar.requiredAttributeMissing"
					message="Required attribute is missing"
					detail="The attribute 'name' is required, for a '#arguments.phase#' plugin declaration in fusebox.xml." />
		</cfif>
		
		<cfset variables.name = arguments.pluginXML.xmlAttributes.name />
		<cfset variables.fuseboxApplication = arguments.fbApp />

		<cfif not structKeyExists(arguments.pluginXML.xmlAttributes,"template")>
			<cfthrow type="fusebox.badGrammar.requiredAttributeMissing"
					message="Required attribute is missing"
					detail="The attribute 'template' is required, for the '#getName()#' plugin declaration in fusebox.xml." />
		</cfif>

		<cfset variables.phase = arguments.phase />
		<cfif arguments.pluginXML.xmlName is "plugin">
			<cfset this.path = arguments.fbApp.getPluginsPath() />
			<cfif structKeyExists(arguments.pluginXML.xmlAttributes,"path")>
				<cfset this.path = this.path & replace(arguments.pluginXML.xmlAttributes.path,"\","/","all") />
				<cfset nAttrs = 3 />
			</cfif>
			<cfif right(this.path,1) is not "/">
				<cfset this.path = this.path & "/" />
			</cfif>
			<cfset variables.template = arguments.pluginXML.xmlAttributes.template />
			<cfif len(variables.template) lt 4 or right(variables.template,4) is not ext>
				<cfset variables.template = variables.template & ext />
			</cfif>
			<cfset this.rootpath =
					arguments.fbApp.relativePath(arguments.fbApp.getApplicationRoot() &
													this.path,arguments.fbApp.getApplicationRoot()) />
			<!--- remove pairs of directory/../ to form canonical path: --->
			<cfloop condition="find('/../',this.rootpath) gt 0">
				<cfset this.rootpath = REreplace(this.rootpath,"[^\.:/]*/\.\./","") />
			</cfloop>
			<cfif arguments.fbApp.strictMode and structCount(arguments.pluginXML.xmlAttributes) neq nAttrs>
				<cfthrow type="fusebox.badGrammar.unexpectedAttributes"
						message="Unexpected attributes"
						detail="Unexpected attributes were found in the '#getName()#' plugin declaration in fusebox.xml." />
			</cfif>
			<cfset variables.parameters = arguments.pluginXML.xmlChildren />
			<cfset variables.paramVerbs = structNew() />
			<cfloop from="1" to="#n#" index="i">
				<cfif not structKeyExists(variables.parameters[i].xmlAttributes,"name")>
					<cfthrow type="fusebox.badGrammar.requiredAttributeMissing"
							message="Required attribute is missing"
							detail="The attribute 'name' is required, for a 'parameter' to the '#getName()#' plugin declaration in fusebox.xml." />
				</cfif>
				<cfif not structKeyExists(variables.parameters[i].xmlAttributes,"value")>
					<cfthrow type="fusebox.badGrammar.requiredAttributeMissing"
							message="Required attribute is missing"
							detail="The attribute 'value' is required, for a 'parameter' to the '#getName()#' plugin declaration in fusebox.xml." />
				</cfif>
				<cfif arguments.fbApp.strictMode and structCount(variables.parameters[i].xmlAttributes) neq 2>
					<cfthrow type="fusebox.badGrammar.unexpectedAttributes"
							message="Unexpected attributes"
							detail="Unexpected attributes were found in the '#variables.parameters[i].xmlAttributes.name#' parameter of the '#getName()#' plugin declaration in fusebox.xml." />
				</cfif>
				<cfset attr = structNew() />
				<cfset attr.name = "myFusebox.plugins.#getName()#.parameters." & variables.parameters[i].xmlAttributes.name />
				<cfset attr.value = variables.parameters[i].xmlAttributes.value />
				<cfset variables.paramVerbs[i] = factory.create("set",this,attr,verbChildren) />
			</cfloop>
		<cfelse>
			<cfthrow type="fusebox.badGrammar.illegalDeclaration" 
					message="Illegal declaration" 
					detail="The XML entity '#arguments.pluginXML.xmlName#' was found where a plugin declaration was expected in fusebox.xml." />
		</cfif>
	
		<cfreturn this />
		
	</cffunction>
	
	<cffunction name="compile" returntype="void" access="public" output="false" 
				hint="I compile this plugin object.">
		<cfargument name="writer" type="any" required="false" 
					hint="I am the parsed file writer object. I am required but it's faster to specify that I am not required." />
		
		<cfset var i = 0 />
		<cfset var n = structCount(variables.paramVerbs) />
		<cfset var file = "" />
		<cfset var p = "" />
		
		<cfif request.__fusebox.SuppressPlugins>
			<cfreturn />
		</cfif>
		<cfswitch expression="#variables.phase#">
		<cfcase value="processError,fuseactionException">
			<cffile action="read" file="#variables.fuseboxApplication.getApplicationRoot()##this.path##variables.template#"
					variable="file"
					charset="#variables.fuseboxApplication.characterEncoding#" />
			<cfset arguments.writer.rawPrintln(file) />
		</cfcase>
		<cfdefaultcase>
			<cfloop from="1" to="#n#" index="i">
				<cfset variables.paramVerbs[i].compile(arguments.writer) />
			</cfloop>
			<cfset p = arguments.writer.setPhase(variables.phase) />
			<cfset arguments.writer.println('<cfset myFusebox.thisPlugin = "#getName()#"/>') />
			<cfset arguments.writer.print('<' & 'cfoutput><' & 'cfinclude template=') />
			<cfset arguments.writer.print('"#variables.fuseboxApplication.parseRootPath##this.path##variables.template#"') />
			<cfset arguments.writer.println('/><' & '/cfoutput>') />
			<cfset arguments.writer.setPhase(p) />
		</cfdefaultcase>
		</cfswitch>

	</cffunction>
	
	<cffunction name="getName" returntype="string" access="public" output="false" 
				hint="I return the name of the plugin.">
		
		<cfreturn variables.name />
		
	</cffunction>

	<cffunction name="getCircuit" returntype="any" access="public" output="false" 
				hint="I return the enclosing application object. This is an edge case to allow code that works with fuseactions to work with plugins too.">
	
		<cfreturn variables.fuseboxApplication />
	
	</cffunction>
	
</cfcomponent>
