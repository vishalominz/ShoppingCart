<cfif !session.loggedIn>
	<cfset Session.lastPage = "#CGI.HTTP_REFERER#" />
	<cfinclude template="header.cfm" />
	<cfinclude template="menubar.cfm" />
	<div id="registerMessage"> Succesfully registered. Please Log In to continue. </div>
	<form name="loginUser" id="loginUser" method="post">
		<fieldset>
		<legend class="legend">Log In</legend>
			<span class="error" id="logInError">
				Invalid email or password.
			</span>
			<div class="form-group">
			<label class="formLabel"> Email </label>
			<input class="inputfield"  name="email" id="email" type="text"/>
		</div>
		<div class="form-group">
			<label class="formLabel"> Password </label>
			<input class="inputfield"  name="password" id="password" type="password"/>
		</div>
		<div class="form-group">
			<input type="submit" name="login" id="login" class="btn btn-primary" value="Log In" />
			<input type="button" name="resetPassword" id="resetPassword" class="btn btn-default" value="Forgot Your Password" />

		</div>
		</fieldset>

	<cfinclude template="footer.cfm"/>
	</form>
<cfelse>
	<script>
		alert('Already Logged In');
	</script>
	<cflocation url="/index.cfm" addtoken="false" />
</cfif>
