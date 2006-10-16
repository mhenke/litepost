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
<cfcomponent output="false" hint="I represent a verb that is implemented as part of a lexicon.">
	
	<cffunction name="init" returntype="any" access="public" output="false" 
				hint="I am the constructor.">
		<cfargument name="action" type="any" required="true" 
					hint="I am the enclosing fuseaction object." />
		<cfargument name="customVerb" type="string" required="true" 
					hint="I am the name of this (custom) verb." />
		<cfargument name="attributes" type="struct" required="true" 
					hint="I am the attributes for this verb." />
		<cfargument name="children" type="any" required="true" 
					hint="I am the XML representation of any children this verb has." />
		
		<cfset var ns = listFirst(arguments.customVerb,".:") />
		<cfset var i = 0 />
		<cfset var verb = "" />
		<cfset var factory = arguments.action.getCircuit().getApplication().getFuseactionFactory() />
		
		<cfset variables.action = arguments.action />
		<cfset variables.attributes = arguments.attributes />
		<!--- we will create our children below --->
		<cfset variables.verb = listLast(arguments.customVerb,".:") />
		<cfset variables.children = structNew() />
		
		<cfset variables.factory = factory />
		<cfset variables.nChildren = arrayLen(arguments.children) />
		
		<cfloop from="1" to="#variables.nChildren#" index="i">
			<cfset verb = arguments.children[i].xmlName />
			<cfset variables.children[i] = factory.create(verb,
						variables.action,
							arguments.children[i].xmlAttributes,
								arguments.children[i].xmlChildren) />
		</cfloop>

		<cfset variables.fb41style = listLen(arguments.customVerb,".") eq 2 />
		<cfif variables.fb41style>
			<cfset variables.lexicon = variables.action.getCircuit().getApplication().getLexiconDefinition(ns) />
		<cfelse>
			<cfset variables.lexicon = variables.action.getCircuit().getLexiconDefinition(ns) />
		</cfif>
		
		<cfreturn this />
		
	</cffunction>
	
	<cffunction name="compile" returntype="void" access="public" output="false" 
				hint="I compile a custom lexicon verb. I create the thread-safe context and perform the start and end execution, as well as compiling any children.">
		<cfargument name="writer" type="any" required="false" 
					hint="I am the parsed file writer object. I am required but it's faster to specify that I am not required." />
		<cfargument name="context" type="any" required="false" 
					hint="I am the context in which this verb is compiled. I can be omitted if the verb has no enclosing parent." />

		<!---
			the following is purely a device to allow nested custom verbs:
			we pass the struct reference into the lexicon compiler but then we
			fill in the fields here *afterwards* - relies on pass by reference!
			because we are recursive, we need to create a new lexicon compiler
			on each 'call' of the (static) compiler (i.e., this method)
			trust me! -- sean corfield
		--->
		<cfset var verbInfo = structNew() />
		<cfset var compiler = variables.factory.createLexiconCompiler()
				.init(arguments.writer,verbInfo,variables) />
		<cfset var i = 0 />

		<cfset verbInfo.lexicon = variables.lexicon.namespace />
		<cfset verbInfo.lexiconVerb = variables.verb />
		<cfset verbInfo.attributes = variables.attributes />
		<!---
			change to FB41 lexicons (but needed for FB5):
				circuit - alias of current circuit
				fuseaction - name of current fuseaction
				action - fuseaction object for more complex usage
		--->
		<cfset verbInfo.circuit = variables.action.getCircuit().getAlias() />
		<cfset verbInfo.fuseaction = variables.action.getName() />
		<cfset verbInfo.action = variables.action />
		
		<cfif variables.fb41style>

			<!--- FB41: just compile the lexicon once with no executionMode --->
			<cfset compiler.compile() />

		<cfelse>

			<!---
				FB5 has new fields in verbInfo:
				skipBody - false, can be set to true by start tag to skip compilation of child tags
				hasChildren - true if there are nested tags, else false
				parent - present if we are nested (the verbInfo of the parent tag)
				executionMode - start|inactive|end, just like custom tags
			--->
			<cfset verbInfo.skipBody = false />
			<cfset verbInfo.hasChildren = variables.nChildren neq 0 />

			<cfif structKeyExists(arguments,"context")>
				<cfset verbInfo.parent = arguments.context />
			</cfif>

			<cfset verbInfo.executionMode = "start" />
			<cfset compiler.compile() />

			<cfif structKeyExists(verbInfo,"skipBody") and isBoolean(verbInfo.skipBody) and verbInfo.skipBody>
				<!--- the verb decided not to compile its children --->
			<cfelse>
				<cfif variables.nChildren gt 0>
					<cfset verbInfo.executionMode = "inactive" />
					<cfloop from="1" to="#variables.nChildren#" index="i">
						<cfset variables.children[i].compile(arguments.writer,verbInfo) />
					</cfloop>		
				</cfif>
			</cfif>

			<cfset verbInfo.executionMode = "end" />
			<cfset compiler.compile() />

		</cfif>
		
		<cfset variables.factory.freeLexiconCompiler(compiler) />

	</cffunction>
	
</cfcomponent>
