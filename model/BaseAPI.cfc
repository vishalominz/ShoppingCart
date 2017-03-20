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
			Data = "",
			url = ""
			} />

	<!--- Return the empty response object --->
	<cfreturn LOCAL.Response />

</cffunction>
</cfcomponent>