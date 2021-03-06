<!---
  --- BaseAPI
  --- -------
  ---
  --- author: mindfire
  --- date:   3/6/17
  --->
<cfcomponent accessors="true" output="false" persistent="false">

<cffunction
	name="GetNewResponse"
	access="public"
	returntype="struct"
	output="false"
	hint="Returns a new API response struct">

	<!--- define the local scope. --->
	<cfset var LOCAL = {} />

	<!--- Create new API response. --->
	<cfset LOCAL.response = {
			Success = true,
			Errors = [],
			Data = [],
			url = ""
			} />

	<!--- Return the empty response object --->
	<cfreturn LOCAL.Response />

</cffunction>

<cffunction name = "log"
			access="public"
			returnformat="json"
			returntype="void"
			output="false"
			hint="Writes log in shopsWorld.log file">
				
		<cfargument name="status"
					required="true" />
		<cfargument name="objectName"
					required="true" />
		<cfargument name="functionName"
					required="true" />
		<cfargument name="message"
					required="true" />

		<cflog file="shopsWorld"
				application="false"
				text = "#status# - #objectName#:#functionName# - #message#" />
</cffunction>
</cfcomponent>