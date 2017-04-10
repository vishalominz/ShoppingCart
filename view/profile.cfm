<cfif Session.loggedIn>
<cfinvoke component="controller.controller"
			method="retrieveUserInformation"
			returnvariable="UserInformation">
</cfinvoke>

<cfinclude template="header.cfm"/>
<cfinclude template="menubar.cfm"/>

<cfloop query="#UserInformation#">
	<cfoutput>
		<div class="row">
			<div class="row">
				<div class="col-md-3"></div>
				<div class="col-md-3">
					<img id="profilePicture" src="/#ProfilePicture#">
					</img>
					<p id="img-change">
						<a id="imageChangeLink">
							Change Image
						</a>
					</p>

					<form action="profilePicUpload.cfm" id="img-upload" method="post" enctype="multipart/form-data">
						<input type="file" name="file" id="file"/>
						<input type="submit" id="fileUpload" class="btn-md" value="Change Image">
					</form>
				</div>
				<div class="col-md-6">
					<div class="row">
						<div class="col-md-1">
						</div>
						<div class="col-md-8">
							<p>#CustomerName#</p>
							<p>#email#</p>
							<p>#mobileNumber#</p>
						</div>
						<div class="col-md-3">
						</div>
					</div>
				</div>
			</div>
			<div class="row">
			</div>

		</div>

	</cfoutput>
</cfloop>



<cfinclude template="footer.cfm"/>
<cfelse>
	<cflocation url="http://www.shopsworld.net/view/login.cfm">
</cfif>