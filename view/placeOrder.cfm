<cfif session.loggedIn>
	<cfinvoke
			component="controller.Controller"
			method="retrieveAddress"
			returnvariable="address">
	</cfinvoke>
	<cfinclude template="header.cfm"/>
	<body>
		<cfinclude template="menubar.cfm"/>
			<div class="row">
				<div class="col-lg-1"></div>
				<div class="col-lg-7">
				<form id="addressForm" method="post" action="" >
						<input type="hidden" id="addressId" name="addressId" value=""/>
					<div class="form-group">
						<label class="formLabel"> Address Line 1 </label>
						<textarea class="addressField" name="address1" id="addressLine1"></textarea>
						<span class="error" id="addressLine1">Required/Invalid</span>
					</div>
					<div class="form-group">
						<label class="formLabel"> Address Line 2 </label>
						<textarea class="addressField" name="address2" id="addressLine2"></textarea>
						<span class="error" id="addressLine2">Required/Invalid</span>
					</div>
					<div class="form-group">
						<label class="formLabel">State</label>
						<input class="addressField" name="state" id="state" type="text" />
						<span class="error" id="state">Required/Invalid</span>
					</div>
					<div class="form-group">
						<label class="formLabel">City</label>
						<input class="addressField" name="city" id="city" type="text"/>
						<span class="error" id="city">Required/Invalid</span>
					</div>
					<div class="form-group">
						<label class="formLabel">Pincode</label>
						<input class="addressField" name="pincode" id="pincode" type="text" maxlength="6"/>
						<span class="error" id="pincode">Required/Invalid</span>
					</div>
					<div class="form-group">
						<label class="formLabel">Address Type</label>
						<input class="addressField" name="adrressType" id="addressType" type="text"/>
						<span class="error" id="addressType">Required/Invalid</span>
					</div>
					<div class="form-group">
						<label class="formLabel"></label>
						<input type="button" name="addressSubmit" id="addressSubmit" class="btn btn-primary" value="Proceed To Pay">
						<input type="reset" name="reset" id="reset" class="btn" value="Reset">
					</div>
				</form>
				</div>
				<div class="col-lg-3">
					<div class="row" id="addresses">
						<cfloop query="#address#">
							<cfoutput>
									<div class="row addressBox" id="#AddressId#">
											<p><span class="addressLine1">#AddressLine1#</span></p>
											<p><span class="addressLine2">#AddressLine2#</span></p>
											<p><span class="city">#city#</span> - <span class="pincode">#pincode#</span></p>
											<p><span class="state">#state#</span></p>
											<p><span class="addressId">#AddressId#</span></p>
											<p><span class="addressType">#AddressType#</span></p>
											<button class="selectAddress">Select</button>
											<button class="removeAddress">Remove</button>
									</div>
							</cfoutput>
						</cfloop>
					</div>
				</div>
				<div class="col-lg-1"></div>
			</div>
	</body>
	<cfinclude template="footer.cfm" />
<cfelse>
	<cflocation url="/index.cfm" addtoken="false" />
</cfif>