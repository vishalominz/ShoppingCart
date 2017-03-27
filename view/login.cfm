<cfif !session.loggedIn>
	<cfset Session.lastPage = "#CGI.HTTP_REFERER#" />
	<cfinclude template="header.cfm" />
	<cfinclude template="menubar.cfm" />
		<div id="registerMessage"> Succesfully registered. Please Log In to continue. </div>
		<form name="loginUser" id="loginUser" method="post">
			<fieldset>
			<legend class="legend">Log In</legend>
			<span class="error" id="logInError"></span>
			<div class="form-group">
				<label class="formLabel"> Email </label>
				<input class="inputfield"  name="email" id="email" type="text"/>
				<span class="error" id="logInNameError">Invalid</span>
			</div>
			<div class="form-group">
				<label class="formLabel"> Password </label>
				<input class="inputfield"  name="password" id="password" type="password"/>
				<span class="error" id="logInPasswordError">Invalid</span>
			</div>
			<cfif session.isSeller>
				<div class="form-group">
				<label class="formLabel"> Company </label>
				<input class="inputfield"  name="company" id="company" type="text"/>
				<span class="error" id="logInCompanyError">Invalid</span>
			</div>
			</cfif>
			<div class="form-group">
				<input type="submit" name="login" id="login" class="btn btn-primary" value="Log In" />
				<input type="button" name="resetPassword" id="resetPassword" class="btn btn-default" value="Forgot Your Password" />
			</div>
			<cfoutput>
				<input type="hidden" id="sellerValue" name="sellerValue" value="#Session.isSeller#">
			</cfoutput>
			</fieldset>
	</form>
	<cfinclude template="footer.cfm"/>
<cfelse>
	<script>
		alert('Already Logged In');
	</script>
	<cflocation url="/index.cfm" addtoken="false" />
</cfif>
