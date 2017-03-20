<cfinvoke
		component="controller.Controller"
		method="retrieveAddress"
		returnvariable="address">
</cfinvoke>
<cfinclude template="header.cfm"/>
<body>
	<cfinclude template="menubar.cfm"/>
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-12">
			<form id="addressForm" method="post" action="" >
				<div class="form-group">
					<label class="formLabel"> Address Line 1 </label>
					<textarea name="address1" id="addressLine1"></textarea>
					<span class="error" id="addressLine1">Required/Invalid</span>
				</div>
				<div class="form-group">
					<label class="formLabel"> Address Line 2 </label>
					<textarea name="address2" id="addressLine2"></textarea>
					<span class="error" id="addressLine2">Required/Invalid</span>
				</div>
				<div class="form-group">
					<label class="formLabel">State</label>
					<input class="inputfield" name="state" id="state" type="text" />
					<span class="error" id="state">Required/Invalid</span>
				</div>
				<div class="form-group">
					<label class="formLabel">City</label>
					<input class="inputfield" name="city" id="city" type="text"/>
					<span class="error" id="city">Required/Invalid</span>
				</div>
				<div class="form-group">
					<label class="formLabel">Pincode</label>
					<input class="inputfield" name="pincode" id="pincode" type="text" maxlength="6"/>
					<span class="error" id="pincode">Required/Invalid</span>
				</div>
				<div class="form-group">
					<label class="formLabel">Address Type</label>
					<input class="inputfield" name="adrressType" id="addressType" type="text"/>
					<span class="error" id="addressType">Required/Invalid</span>
				</div>
				<div class="form-group">
					<label class="formLabel"></label>
					<input type="button" name="addressSubmit" id="addressSubmit" class="btn btn-primary" value="Proceed To Pay">
					<input type="reset" name="reset" id="reset" class="btn" value="Reset">
				</div>
			</form>
			</div>
		</div>
	</div>
</body>
<cfinclude template="footer.cfm" />