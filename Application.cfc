
<!---
  --- Application
  --- -----------
  ---
  --- author: mindfire
  --- date:   3/1/17
  --->
<cfcomponent accessors="true" output="false" persistent="false">
	<cfset this.name="onlineshop" />
	<cfset this.applicationTimeout = CreateTimeSpan(2,0,0,0) />
	<cfset this.sessionManagement = true />
	<cfset this.seesionTimeout = CreateTimespan(0,0,0,1) />
	<cfset this.datasource = "onlineshop" />

<!--- onSessionStart function ---->
	<cffunction name="onSessionStart" returntype="void">
		<cfset session.user.userName = ""/>
		<cfset session.user.userId = "" />
		<cfset session.user.email = "" />
		<cfset session.user.mobileNumber = "" />
		<cfset session.cart = [] />
		<cfset session.lastpage = "" />
		<cfset session.loggedIn=false />
		<cfset session.address = {} />
	</cffunction>

<!--- onError function --->
	<cffunction name="onError" >
		 <cfargument name="Exception" required=true/>
    	<cfargument type="String" name="EventName" required=true/>
	    <!--- Log all errors. --->
	    <cflog file="#This.Name#" type="error"
	            text="Event Name: #Arguments.Eventname#" >
	    <cflog file="#This.Name#" type="error"
	            text="Message: #Arguments.Exception.message#">
	    <!--- Display an error message if there is a page context. --->
	    <cfif NOT (Arguments.EventName IS "onSessionEnd") OR
	            (Arguments.EventName IS "onApplicationEnd")>
	        <cfoutput>
	            <h2>An unexpected error occurred.</h2>
	            <p>Please provide the following information to technical support:</p>
	            <p>Error Event: #Arguments.EventName#</p>
	            <p>Error details:<br>
	            <cfdump var=#Arguments.Exception#></p>
	        </cfoutput>
	    </cfif>
	</cffunction>

<!--- onSessionEnd function --->
	<cffunction name="onSessionEnd" returntype="void">
	   <cfset structDelete("#SESSION#","user") />
	   <cfset structDelete("#SESSION#","cart") />
	   <cfset structDelete("#SESSION#","address") />
	   <cfset structDelete("#SESSION#","lastpage") />
	   <cfset structDelete("#SESSION#","loggedIn") />
	</cffunction>

</cfcomponent>