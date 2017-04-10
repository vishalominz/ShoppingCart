<!--- Cart :
	  AddToCart()
	  DeleteFromCart()
	  GetCartItems()
  --- author: mindfire
  --- date:   3/10/17
  --->
<cfcomponent
	extends="BaseAPI"
	accessors="true"
	output="true"
	persistent="false"
	hint="Public API for Cart.">

<!--- add function for cart --->
	<cffunction	name="AddToCart"
		access="public"
		returntype="struct"
		returnformat="json"
		output="false"
		hint="Add Product to Cart">

		<!--- Define arguments. --->
		<cfargument
			name="productId"
			type="string"
			required="true"
			hint="Product Id of the Product"
			/>
		 <cfargument
			name="productName"
			type="string"
			required="true"
			hint="Name of the product"
			/>
		<cfargument
			name="productDescription"
			type="string"
			required="true"
			hint="Description of the product"
			/>
		<cfargument
			name="productBrand"
			type="string"
			required="true"
			hint="Brand of the product"
			/>
		<cfargument
			name="InventoryId"
			type="string"
			required="true"
			hint="Inventory Id"
			/>
		<cfargument
			name="productImageLocation"
			type="string"
			required="true"
			hint="Image of the product"
			/>
		<cfargument
			name="orderQuantity"
			type="numeric"
			required="false"
			default="1"
			hint="No of items being ordered">

		<!--- Get a new API response --->
		<cfset var LOCAL = {} />

		<!--- Get a new API response --->
		<cfset LOCAL.Response = THIS.GetNewResponse() />

		<!--- Check to see if all the data is defined. --->
		<cfif NOT Len(ARGUMENTS.productId)>
			<cfset ArrayAppend(
				LOCAL.Response.Errors,
				"No Product ID Found"
				) />
		</cfif>

		<cfif NOT Len(ARGUMENTS.inventoryId)>
			<cfset ArrayAppend(
				LOCAL.Response.Errors,
				"No Inventory ID Found"
				) />
		</cfif>

		<!--- Check if any error is present --->
		<cfif NOT ArrayLen( LOCAL.Response.Errors)>
			<!--- setting default variables --->
			<cfparam name="isItemPresent" default=false />
			<cfparam name="itemIndex" default=1 />
			<cfset LOCAL.Item = {} />

			<!--- Check if item is already present in session.cart --->
			<cfloop from="1" to="#ArrayLen(SESSION.cart)#" index="item">
				<cfif session.cart[item].InventoryId eq ARGUMENTS.InventoryId>
					<cfset isItemPresent = true />
					<cfset itemIndex = "#item#" />
				</cfif>
			</cfloop>

			<!--- retrieve inventory from database --->
			<cftry>
				<cfinvoke component="database" method="retrieveFromInventory"  returnvariable="inventoryItem">
					<cfinvokeargument name="productId" value="#ARGUMENTS.ProductId#" />
					<cfinvokeargument name="quantity" value="#ARGUMENTS.orderQuantity#" />
					<cfinvokeargument name="inventoryId" value="#ARGUMENTS.inventoryId#" />
					<cfif isItemPresent eq true>
						<cfinvokeargument name="quantity" value="#Session.cart[itemIndex].productCount + orderQuantity#" />
					</cfif>
				</cfinvoke>
				<cfset message= "Data succesfully retrieved from inventory of database." />
				<cfset THIS.log("SUCCESS","Cart",getFunctionCalledName(),message) />
				<cfcatch type="database">
					<cfset message = "Data retrieval failed from Inventory of database" />
					<cfset THIS.log("ERROR","Cart",getFunctionCalledName(),message) />
				</cfcatch>
			</cftry>

			<!--- check if item is present in the Inventory of database --->
			<cfif inventoryItem.recordcount gt 0>

				<!--- Creat a new item --->
				<cfset LOCAL.Item={
					ProductId = ARGUMENTS.ProductId,
					ProductName= ARGUMENTS.ProductName,
					ProductBrand= ARGUMENTS.ProductBrand,
					ProductDescription = ARGUMENTS.ProductDescription,
					ProductImageLocation= ARGUMENTS.ProductImageLocation,
					ProductCount = 0
					} />

				<!---query through inventory items from different sellers --->
				<cfloop query="#inventoryItem#">
					<cfset LOCAL.Item.InventoryId = #InventoryId# />
					<cfset LOCAL.Item.Price = #DiscountPrice# />
					<cfset LOCAL.Item.Discount = #DiscountPercent# />
					<cfset LOCAL.Item.MaxCount = #AvailableQuantity# />
					<cfset LOCAL.Item.SellingCompanyId = #SellingCompanyId# />
					<cfbreak/>
				</cfloop>


				<!--- if present updates else adds --->
				<cfif isItemPresent eq true>
					<cfset SESSION.cart[itemIndex].ProductCount = "#SESSION.cart[itemIndex].ProductCount + 1#" />
					LOCAL.Item.ProductCount = session.cart[itemIndex].ProcductCount;
				<cfelse>
					<!--- Set Product Count --->
					<cfset LOCAL.Item.ProductCount = 1 />
					<!--- Add item to the session --->
					<cfset ArrayAppend(
						SESSION.cart,
						LOCAL.Item) />
					<cfset isItemPresent=true />
				</cfif>
			<cfelse>

				<!---if item is present in cart but no more item is available in inventory --->
				<cfif isItemPresent eq true >
					<cfset LOCAL.Item={
							ProductId = ARGUMENTS.ProductId,
							ProductName= ARGUMENTS.ProductName,
							ProductBrand= ARGUMENTS.ProductBrand,
							ProductDescription = ARGUMENTS.ProductDescription,
							ProductImageLocation= ARGUMENTS.ProductImageLocation,
							ProductCount = SESSION.cart[itemIndex].ProductCount
						} />
				</cfif>

				<!--- since no more item is available in inventory, set isItemPresent false --->
				<cfset isItemPresent=false />

			</cfif>

			<!--- count total number of products in cart --->
			<cfparam name="cartItemCount" default=0 />
			<cfif ArrayLen(Session.cart) gt 0>
				<cfoutput>
				<cfloop from="1" to="#ArrayLen(SESSION.cart)#" index="loc">
					<cfset cartItemCount = cartItemCount + Session.cart[loc].ProductCount />
				
				</cfloop>
				</cfoutput>
			</cfif>
				
			<!--- Set return data as array --->
			<cfset LOCAL.Response.Data = [LOCAL.Item,cartItemCount,isItemPresent] />
		</cfif>

		<!--- Check to see if any error is present. --->
		<cfif ArrayLen( LOCAL.Response.Errors)>

			<!--- if error is present , set request as not succesful --->
			<cfset LOCAL.Response.Success = false />
		</cfif>
		<cfset message = "Product added to cart" />
		<cfset THIS.log("Success","Cart",getFunctionCalledName(),message) />
		<!--- Returnt the response. --->
		<cfreturn LOCAL.Response />
	</cffunction>

<!---- Delete function for cart --->
	<cffunction	name="DeleteFromCart"
		access="public"
		returntype="struct"
		returnformat="json"
		output="false"
		hint="Deletes item fro the cart with given Product ID">

		<!--- Define Arguments --->
		<cfargument
			name="productId"
			type="string"
			required="true"
			hint="Product ID of product to delete">

			<!--- Define the local Scope --->
			<cfset var LOCAL = {} />

			<!--- Get a new API response --->
			<cfset LOCAL.Response = THIS.GetNewResponse() />

			<!--- Set a default Product Index --->
			<cfset LOCAL.ProductIndex = 0 />

			<!--- Loop to find the given Product in session.cart --->
			<cfloop
				index="LOCAL.index"
				from="1"
				to="#ArrayLen(SESSION.cart)#"
				step="1">

				<!--- Check the Product ID --->
				<cfif (SESSION.cart[LOCAL.index].ProductId) EQ ARGUMENTS.ProductId >

					<!--- Store this index as the target index --->
					<cfset LOCAL.ProductIndex = LOCAL.Index />
				</cfif>
			</cfloop>

			<!--- Check to see if Product was found --->
			<cfif NOT LOCAL.ProductIndex>
				<cfset Array.Append(
					LOCAL.Response.Errors,
					"The given Product could not be found."
					) />
			</cfif>

			<!--- Check if any errors are present, if none, then Process the API request --->
			<cfif NOT ArrayLen(LOCAL.Response.Errors)>
				<!--- Get the Product Item--->
				<cfset LOCAL.Item = Session.cart[LOCAL.ProductIndex] />

				<!--- Delet the Product Item --->
				<cfset ArrayDeleteAt(
					Session.cart,
					LOCAL.ProductIndex
					) />

			<!--- write log after success --->
				<cfset message = "Product #LOCAL.Item.ProductName#[#LOCAL.Item.ProductId#] removed from cart" />
				<cfset THIS.log("ERROR","Seller",getFunctionCalledName(),message) />

				<!--- Set the Product Item as the return data --->
				<cfset LOCAL.Response.Data = Session.cart />

			</cfif>

			<!--- Check to see if any error is present --->
			<cfif ArrayLen(LOCAL.Response.Errors)>
				<!--- If error is present, set request flag as not successfull --->
				<cfset LOCAL.Response.Success = false />
			</cfif>

			<!--- Return the response --->
			<cfreturn LOCAL.Response />
		</cffunction>

<!--- Get items for cart function --->
		<cffunction	name="GetCartItems"
			access="public"
			reutrntype="struct"
			returnformat="json"
			output = "false"
			hint="Returns collection of Cart Items">

			<!--- Define the local scope --->
			<cfset var LOCAL = {} />

			<!--- Get a new API response --->
			<cfset LOCAL.Response = THIS.GetNewResponse() />

			<!--- Get a new API Response --->
			<cfset LOCAL.Response.Data = Session.cart />

			<!--- Retuen the response --->
			<cfreturn LOCAL.Response />
		</cffunction>

<!---- Update cart count --->
		<cffunction name="UpdateCartItem"
				access="public"
				returnformat="json"
				returntype="struct"
				hint="Update cart count">

			<cfargument name="countValue"
						required="true" />
			<cfargument name="productId"
						required="true" />
			<cfargument name="inventoryId"
						required="true" />
			<!--- Define the local scope --->
			<cfset var LOCAL = {} />

			<!--- Get a new API response --->
			<cfset LOCAL.Response = THIS.GetNewResponse() />
			<cfparam name="cartItemCount" default=0 />
			<cfloop from="1" to="#arrayLen(Session.cart)#" index="item">
					<cfif Session.cart[item].productId eq ARGUMENTS.productId
							AND Session.cart[item].InventoryId eq ARGUMENTS.inventoryId>
						<cfif ARGUMENTS.countValue gt Session.cart[item].maxcount
								OR ARGUMENTS.countValue lte 0>
							<cfset LOCAL.Response.Success = false />
							<cfset LOCAL.Response.Data = Session.cart[item].maxcount />
						<cfelse>
							<cfset Session.cart[item].productCount = ARGUMENTS.countValue />
						</cfif>
						<cfset LOCAL.Item = SEssion.cart[item] />
					</cfif>
					<cfset cartItemCount = cartItemCount + Session.cart[item].productCount />
			</cfloop>

		<!--- write log after success --->
			<cfset message = "Product #LOCAL.Item.ProductName#[#LOCAL.Item.ProductId#] count updated to #LOCAL.Item.ProductCount#" />
			<cfset THIS.log("ERROR","Seller",getFunctionCalledName(),message) />

			<cfset LOCAL.Response.Data = cartItemCount />
		<!--- Retuen the response --->
			<cfreturn LOCAL.Response />
		</cffunction>
</cfcomponent>