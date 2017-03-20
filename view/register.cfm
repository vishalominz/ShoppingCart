<cfif !session.loggedIn>
	<cfinclude template="header.cfm" />
	<cfinclude template="menubar.cfm" />
<form method="post" id="registerUser" name="registerUser" >
	<fieldset>
	<legend><p class="legend">Registration Form</p></legend>
	<div class="form-group">
		<label class="formLabel"> Name </label>
		<input class="inputfield" name="name" id="name" type="text" />
		<span class="error" id="name">Required</span>
	</div>
	<div class="form-group">
		<label class="formLabel"> Email </label>
		<input class="inputfield" name="email" id="email" type="text" />
		<span class="error" id="email">Required</span>
	</div>
	<div class="form-group">
		<label class="formLabel"> Mobile</label>
		<input class="inputfield" name="mobileNumber" id="mobileNumber" type="text" maxlength="10"/>
		<span class="error" id="mobileNumber">Required</span>
	</div>
	<div class="form-group">
		<label class="formLabel">Password</label>
		<input class="inputfield" name="password" id="password" type="password" />
		<span class="error" id="password">Required</span>
	</div>
	<div class="form-group">
		<input type="submit" name="register" id="register" class="btn btn-primary" value="Register">
		<input type="reset" name="reset" id="reset" class="btn" value="Reset">
	</div>
	</fieldset>
</form>
	<cfinclude template="footer.cfm"/>
<cfelse>
	<cflocation url="/index.cfm" addtoken="false" />
</cfif>
<script src="/assets/script/user.js"></script>