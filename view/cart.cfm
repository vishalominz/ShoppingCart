<cfinclude template="header.cfm"/>
<cfinclude template="menubar.cfm"/>
<cfinvoke component="controller.controller" method="getCartItems" returnvariable="cartItems">
</cfinvoke>
<cfparam name="buyNow" default=false />
<cfparam name="selectedProduct" default={} />
<cfparam name="isItemPresent" default=true />

<div class="row">
	<div class="col-md-2">
	</div>
	<div class="col-md-8" id="cartContent">
		<form id="itemsToBuy">
		<cfloop from="1" to="#arrayLen(cartItems.data)#" index="location">
			<cfoutput>
			<div class="productItem" id="#CartItems.data[location].productId#">
				<img class="productImage  img-responsive" src="\assets\#cartItems.data[location].productImageLocation#" />
				<div class="product">
					<span class="productName">#CartItems.data[location].productName#</span>
					<span class="productBrand">#CartItems.data[location].productBrand#</span>
					<span class="productDescription">#CartItems.data[location].productDescription#</span>
				</div>
				<span class="error productError"></span>
					<input class="inventoryId" type="hidden" value="#CartItems.data[location].inventoryId#">
					<input class="productCount" type="number" value="#CartItems.data[location].productCount#" maxlength="#CartItems.data[location].maxCount#" />
					<button class="updateButton">Update Item Count</button>
					<button type="button" class="btn btn-lg btn-primary removeItem" value="#CartItems.data[location].productId#">Remove Item</button>
			</div>
			</cfoutput>
		</cfloop>
		<cfif  SESSION.loggedIN eq true>
			<cfif isItemPresent eq true && Arraylen(session.cart) gt 0 >
				<input type="button" id="orderProducts" value="Place Order" class="btn btn-lg btn-primary">
			<cfelse>
				<cfoutput>
				<span class="alert alert-info">No Item Present in cart.	 </span>
				 </cfoutput>
			</cfif>
		<cfelse>
				<span class="alert alert-info"> Please Log In to Purchase </span>
		</cfif>

		</form>
	</div>
	<div class="col-md-2">
	</div>
</div>

<cfinclude template="footer.cfm"/>
