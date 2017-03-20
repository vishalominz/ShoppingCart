<cfinclude template="header.cfm"/>
<body>
	<cfinclude template="menubar.cfm"/>
	<div class="container-fluid">
		<fieldset>
		<legend class="legend">Payment Method</legend>
		<form method="post" action="generateInvoice.cfc">
			 <input type="radio" name="paymentMethod" id="creditCard" value="creditCard"><span class="radio">Credit Card</span>
 			 <input type="radio" name="paymentMethod" id="cash" value="cash"> <span class="radio">PayByCash </span>
			 	<div class="creditCard" id="creditCard">
				 	<div class="form-group">
					<label class="formLabel"> Card Number </label>
					<input class="inputfield" name="cardNumber" id="cardNumber" type="text" />
					</div>
					<div class="form-group">
						<label class="formLabel"> Holder Name </label>
						<input class="inputfield" name="holderName" id="holderName" type="text" />
					</div>
					<div class="form-group">
						<label class="formLabel">CVV</label>
						<input class="inputfield" name="cvv" id="cvv" type="text" />
					</div>
					<div class="form-group">
						<label class="formLabel">Pin</label>
						<input class="inputfield" name="pin" id="pin" type="text"/>
					</div>
					<div class="form-group">
						<input type="button" name="cardPay" id="cardPay" class="btn btn-primary" value="Proceed To Pay">
						<input type="reset" name="reset" id="reset" class="btn" value="Reset">
					</div>
				</div>
				<div class="cash" id="cash">
					<div class="form-group">
						<input type="button" name="cashPay" id="cashPay" class="btn btn-primary" value="Proceed To Pay">
					</div>
				</div>
		</form>
		</fieldset>
	</div>
</body>
<cfinclude template="footer.cfm"/>