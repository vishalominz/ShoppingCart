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
	output="false"
	persistent="false"
	hint="Public API for Cart.">

<!--- add function for cart --->
	<cffunction
		name="AddToCart"
		access="remote"
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
				"No ID Found"
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
				<cfif session.cart[item].ProductId eq ARGUMENTS.ProductId>
					<cfset isItemPresent = true />
					<cfset itemIndex = "#item#" />
				</cfif>
			</cfloop>

			<!--- retrieve inventory from database --->
			<cfinvoke component="database" method="retrieveFromInventory"  returnvariable="inventoryItem">
				<cfinvokeargument name="productId" value="#ARGUMENTS.ProductId#" />
				<cfinvokeargument name="quantity" value="#orderQuantity#" />
				<cfif isItemPresent eq true>
					<cfinvokeargument name="quantity" value="#Session.cart[itemIndex].productCount + orderQuantity#" />
				</cfif>
			</cfinvoke>


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

			<!--- Set return data as array --->
			<cfset LOCAL.Response.Data = [LOCAL.Item,ArrayLen(session.cart),isItemPresent] />
		</cfif>

		<!--- Check to see if any error is present. --->
		<cfif ArrayLen( LOCAL.Response.Errors)>

			<!--- if error is present , set request as not succesful --->
			<cfset LOCAL.Response.Success = false />
		</cfif>

		<!--- Returnt the response. --->
		<cfreturn LOCAL.Response />
	</cffunction>



<!---- Delete function for cart --->
	<cffunction
		name="DeleteFromCart"
		access="remote"
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

				<!--- Set the Product Item as the return data --->
				<cfset LOCAL.Response.Data = LOCAL.Item />

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
		<cffunction
			name="GetCartItems"
			access="remote"
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

</cfcomponent>