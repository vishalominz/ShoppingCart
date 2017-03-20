<cfif cgi.REQUEST_METHOD IS "post" AND structkeyExists(form,"login")>
	<cfinvoke
		component="controller.controller"
		method="logIn"
		returnvariable = "loggedIn">
		<cfinvokeargument name="email" value="#FORM.email#"/>
		<cfinvokeargument name="password" value="#HASH(FORM.password)#" />
	</cfinvoke>

</cfif>
