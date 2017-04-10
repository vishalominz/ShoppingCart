<cfif session.loggedIn>
	<cfset lastPage = "#CGI.HTTP_REFERER#" />
	<cfset currentDirectory = "D:\Projects\shoppingCart\assets\images\Profile" />
	<cfinvoke component="controller.controller"
				method ="updateUserProfilePicture"
				returnvariable="responseObj" >
			<cfinvokeargument name="formData"
							value="assets/images/Profile/pic#session.user.userId#.jpg" />
	</cfinvoke>	
	<cfdump var="#form#" />
	<cfif len(trim(form.file))>
		<cffile action="upload"
			destination = "#currentDirectory#\pic#session.user.userId#.jpg"
			fileField = "file"
			nameconflict="overwrite">
	</cfif>
	<script>
		document.getElementById("profilePicture").src='assets/images/Profile/pic#session.user.userId#.jpg';	
	</script>
	<cflocation url="/view/Profile.cfm" addtoken="false"/>
<cfelse>
	<cflocation url="/view/login.cfm" addtoken="false"/>
</cfif>