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
<cfcomponent output="false" 
			hint="I represent a fuseaction within a circuit.">

	<cffunction name="init" returntype="any" access="public" output="false" 
				hint="I am the constructor.">
		<cfargument name="circuit" type="any" required="false" 
					hint="I am the circuit to which this fuseaction belongs. I am required but it's faster to specify that I am not required." />
		<cfargument name="name" type="any" required="false" 
					hint="I am the name of the fuseaction. I am required but it's faster to specify that I am not required." />
		<cfargument name="access" type="any" required="false" 
					hint="I am the access criteria for the fuseaction. I am required but it's faster to specify that I am not required." />
		<cfargument name="children" type="any" required="false" 
					hint="I am the verbs for this fuseaction. I am required but it's faster to specify that I am not required." />
		<cfargument name="global" type="any" default="false" 
					hint="I indicate whether or not this is a globalfuseaction in fusebox.xml." />
		<cfargument name="customAttribs" type="any" default="#structNew()#" 
					hint="I hold the custom (namespace-qualified) attributes in the fuseaction tag." />
		
		<cfset var i = 0 />
		<cfset var verb = "" />
		<cfset var factory = arguments.circuit.getApplication().getFuseactionFactory() />

		<cfset variables.circuit = arguments.circuit />
		<cfset variables.name = arguments.name />
		<cfset variables.customAttributes = arguments.customAttribs />
		<cfset variables.nChildren = arrayLen(arguments.children) />
		<cfset variables.actions = structNew() />
		
		<cfset this.access = arguments.access />
		
		<cfloop from="1" to="#variables.nChildren#" index="i">
			<cfset variables.actions[i] = factory.create(arguments.children[i].xmlName,
					this,arguments.children[i].xmlAttributes,arguments.children[i].xmlChildren,
						arguments.global) />
		</cfloop>
		
		<cfreturn this />
		
	</cffunction>
	
	<cffunction name="compile" returntype="void" access="public" output="false" 
				hint="I compile this fuseaction.">
		<cfargument name="writer" type="any" required="false" 
					hint="I am the writer object to which the compiled code should be written. I am required but it's faster to specify that I am not required." />
	
		<cfset var i = 0 />
		<cfset var n = 0 />
		
		<cfloop from="1" to="#variables.nChildren#" index="i">
			<cfset variables.actions[i].compile(arguments.writer) />
		</cfloop>
		
	</cffunction>
	
	<cffunction name="getName" returntype="string" access="public" output="false" 
				hint="I return the name of the fuseaction.">
		
		<cfreturn variables.name />
		
	</cffunction>

	<cffunction name="getCircuit" returntype="any" access="public" output="false" 
				hint="I return the enclosing circuit object.">
	
		<cfreturn variables.circuit />
	
	</cffunction>
	
	<cffunction name="getAccess" returntype="string" access="public" output="false" 
				hint="I am a convenience method to return this fuseaction's access attribute value.">
	
		<cfreturn this.access />
	
	</cffunction>
	
	<cffunction name="getPermissions" returntype="string" access="public" output="false" 
				hint="I return the aggregated permissions for this fuseaction.">
		<cfargument name="inheritFromCircuit" type="boolean" default="true" 
					hint="I indicate whether or not the circuit's permissions should be returned if this fuseaction has no permissions specified." />
		<cfargument name="useCircuitTrace" type="boolean" default="false" 
					hint="I indicate whether or not to inherit the parent circuit's permissions if this fuseaction's circuit has no permissions specified." />
	
		<cfif this.permissions is "" and arguments.inheritFromCircuit>
			<cfreturn getCircuit().getPermissions(arguments.useCircuitTrace) />
		<cfelse>
			<cfreturn this.permissions />
		</cfif>
	
	</cffunction>
	
	<cffunction name="getCustomAttributes" returntype="struct" access="public" output="false" 
				hint="I return the custom (namespace-qualified) attributes for this fuseaction tag.">
		<cfargument name="ns" type="string" required="true" 
					hint="I am the namespace prefix whose attributes should be returned." />
		
		<cfif structKeyExists(variables.customAttributes,arguments.ns)>
			<!--- we structCopy() this so folks can't poke values back into the metadata! --->
			<cfreturn structCopy(variables.customAttributes[arguments.ns]) />
		<cfelse>
			<cfreturn structNew() />
		</cfif>
		
	</cffunction>
	
</cfcomponent>
