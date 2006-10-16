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
<cfscript>
	if (fb_.verbInfo.executionMode is "start") {
		// validate attributes
		fb_.nAttrs = 0;
		// there are five different forms of the <loop> verb:
		// 1. condition - string - required
		// 2. query - string - required
		// 3. from - string - required
		//    to - string - required
		//    index - string - required
		//    step - string - optional
		// 4. collection - string - required
		//    item - string - required
		// 5. list - string - required
		//    index - index - required
		// the last two are new in Fusebox 5
		if (structKeyExists(fb_.verbInfo.attributes,"condition")) {
			
			fb_.nAttrs = 1;
			
			fb_appendLine('<cfloop condition="#fb_.verbInfo.attributes.condition#">');
			
		} else if (structKeyExists(fb_.verbInfo.attributes,"query")) {
			
			fb_.nAttrs = 1;
			
			fb_appendLine('<cfloop query="#fb_.verbInfo.attributes.query#">');
		
		} else if (structKeyExists(fb_.verbInfo.attributes,"from") or structKeyExists(fb_.verbInfo.attributes,"to")) {
		
			fb_.nAttrs = 3;		// from/to/index required
			
			if (not structKeyExists(fb_.verbInfo.attributes,"from") or
					not structKeyExists(fb_.verbInfo.attributes,"to") or 
					not structKeyExists(fb_.verbInfo.attributes,"index")) {
				fb_throw("fusebox.badGrammar.requiredAttributeMissing",
							"Required attribute is missing",
							"The attributes 'from', 'to' and 'index' are both required, for a 'loop' verb in fuseaction #fb_.verbInfo.circuit#.#fb_.verbInfo.fuseaction#.");
			} else {
				fb_appendSegment('<' & 'cfloop from="#fb_.verbInfo.attributes.from#"' &
									' to="#fb_.verbInfo.attributes.to#"' &
									' index="#fb_.verbInfo.attributes.index#"');
				if (structKeyExists(fb_.verbInfo.attributes,"step")) {
					
					fb_.nAttrs = fb_.nAttrs + 1;	// step optional

					fb_appendSegment(' step="#fb_.verbInfo.attributes.step#"');
				}
				fb_appendLine('>');
			}
		
		} else if (structKeyExists(fb_.verbInfo.attributes,"collection")) {
			
			fb_.nAttrs = 2;		// collection/item required
			
			if (not structKeyExists(fb_.verbInfo.attributes,"item")) {
				fb_throw("fusebox.badGrammar.requiredAttributeMissing",
							"Required attribute is missing",
							"The attribute 'item' is required, for a 'loop' verb with a 'collection' attribute in fuseaction #fb_.verbInfo.circuit#.#fb_.verbInfo.fuseaction#.");
			} else {
				fb_appendLine('<cfloop collection="#fb_.verbInfo.attributes.collection#" item="#fb_.verbInfo.attributes.item#">');
			}
			
		} else if (structKeyExists(fb_.verbInfo.attributes,"list")) {
			
			fb_.nAttrs = 2;		// list/index required
			
			if (not structKeyExists(fb_.verbInfo.attributes,"index")) {
				fb_throw("fusebox.badGrammar.requiredAttributeMissing",
							"Required attribute is missing",
							"The attribute 'index' is required, for a 'loop' verb with a 'list' attribute in fuseaction #fb_.verbInfo.circuit#.#fb_.verbInfo.fuseaction#.");
			} else {
				fb_appendLine('<cfloop list="#fb_.verbInfo.attributes.list#" index="#fb_.verbInfo.attributes.index#">');
			}
			
		} else {
			// illegal attributes
			fb_throw("fusebox.badGrammar.requiredAttributeMissing",
						"Required attribute is missing",
						"One of 'condition', 'query', 'from'/'to', 'collection' or 'list' is required, for a 'loop' verb in fuseaction #fb_.verbInfo.circuit#.#fb_.verbInfo.fuseaction#.");
		}
		// strict mode - check attribute count:
		if (fb_.verbInfo.action.getCircuit().getApplication().strictMode) {
			if (structCount(fb_.verbInfo.attributes) neq fb_.nAttrs) {
				fb_throw("fusebox.badGrammar.unexpectedAttributes",
							"Unexpected attributes",
							"Unexpected attributes were found in a 'loop' verb in fuseaction #fb_.verbInfo.circuit#.#fb_.verbInfo.fuseaction#.");
			}
		}
	}

	// compile </loop>
	if (fb_.verbInfo.executionMode is "end") {
		fb_appendLine("</cfloop>");
	}
</cfscript>
