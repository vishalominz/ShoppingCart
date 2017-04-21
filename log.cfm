
<cfdump var="#session#" />

<cfdump var="#Arraylen(session.cart)#">
<cfloop  index="index" from="1" to="#Arraylen(session.cart)#">
	<cfoutput>#index#</cfoutput>
</cfloop>

<cfdump var="#cgi#" />

<cfset password = hash("abcdEF123##") />

<cfdump var = "#password#" />