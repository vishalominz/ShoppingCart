<!---
  --- Product
  --- -------
  ---
  --- author: mindfire
  --- date:   3/13/17
  --->
<cfcomponent extends="BaseAPI"
	accessors="true" output="false" persistent="false">

<!--- retrieveProductSubCategory from database --->
	<cffunction	name="retrieveProductSubCategory"
			returnformat="json"
			returntype="any"
			access="public">

		<cfargument
				name="productCategoryId"
				required="true"
				type="numeric">
			<cfinvoke
				component="Database"
				method="retrieveProductSubCategory"
				returnvariable="productSubCategory">

				<cfinvokeargument
					name="productCategoryId"
					value="#ARGUMENTS.productCategoryId#">
			</cfinvoke>

			<cfreturn productSubCategory/>
	</cffunction>

<!--- retrieveProductCategory from database --->
	<cffunction	name="retrieveProductCategory"
			returnformat="json"
			returntype="any"
			access="public">

			<cfinvoke
				component="Database"
				method="retrieveProductCategory"
				returnvariable="productCategory">
			</cfinvoke>

			<cfreturn productCategory />
	</cffunction>

<!--- retrieveProductBySubCategory --->
	<cffunction	name="retrieveProductBySubCategory"
			returntype="any"
			returnformat="json"
			access="public">

			<cfargument
					name="productSubCategoryId"
					type="numeric"
					required="true" />

			<cfinvoke
				component="Database"
				method="retrieveProductBySubCategory"
				returnvariable="productBySubCategory">

				<cfinvokeargument
						name="productSubCategoryId"
						value="#ARGUMENTS.productSubCategoryId#">

			</cfinvoke>

			<cfreturn productBySubCategory />
	</cffunction>

<!--- retrieveProductDetail --->
	<cffunction	name="retrieveProductDetail"
			access="public"
			returnformat="json"
			returntype="Any">

			<cfargument
				name="productId"
				type="numeric"
				required="true">

			<cfinvoke
				component="Database"
				method = "retrieveProductDetail"
				returnvariable="productDetail">

				<cfinvokeargument
					name="productId"
					value="#ARGUMENTS.productId#">
			</cfinvoke>

			<cfreturn productDetail/>
	</cffunction>

<!--- searchSuggestion --->
	<cffunction	name="searchSuggestion"
			access="public"
			returntype="any"
			returnformat="json">

			<cfargument
				name="searchItem"
				required="true" />

		<!--- Get a new API response --->
			<cfset var LOCAL = {} />
		<!--- Get a new API response --->
			<cfset LOCAL.Response = THIS.GetNewResponse() />

			<cfif NOT len(searchItem)>
				<cfset ArrayAppend(LOCAL.Response.Errors,
					"Search value is null") />
			</cfif>

			<cfif NOT ArrayLen(LOCAL.Response.Errors)>

				<cfinvoke
					component="Database"
					method="searchProduct"
					returnvariable="searchItems">

					<cfinvokeargument
							name="searchItem"
							value="#ARGUMENTS.searchItem#" />
				</cfinvoke>
				<cfset LOCAL.Data = [] />
				<cfif searchItems.recordCount gt 0>
					<cfloop query="#searchItems#">
						<cfset Item = {
							productId = #productId#,
							productName = #ProductName#,
							productBrand = #ProductBrand#,
							productImageLocation = #ProductImageLocation#,
							productSellingPrice = #SellingPrice#,
							discountPercent = #DiscountPercent#,
							discountPrice = #DiscountPrice#
							}>

						<cfset arrayAppend(LOCAL.Data,
								Item) />
					</cfloop>
					<cfset LOCAL.Response.Data = LOCAL.Data />
				<cfelse>
					<cfset arrayAppend(LOCAL.Response.Errors,
						"No suggestion") />
				</cfif>
			</cfif>

			<cfif ArrayLen(LOCAL.Response.Errors)>
				<cfset LOCAL.Response.Success = false />
			</cfif>
			<cfreturn LOCAL.Response />
	</cffunction>


<!--- insertOrderDetail() function --->
	<cffunction	name="insertOrderDetail"
			access="remote"
			returntype="Any"
			returnformat="json">

		<!--- Get a new API response --->
			<cfset var LOCAL = {} />
		<!--- Get a new API response --->
			<cfset LOCAL.Response = THIS.GetNewResponse() />
			<cfset cartDetail = session.cart />
		<!--- place a lock on inventory table --->
		<!--- check in inventory if all items are available --->
		<!--- if not unlock inventory table and then input error --->
		<!--- set cartDetails as argument collection --->

			<cfparam name="isPresent" default="false" />
		<!--- check if cart items are still available in inventory --->
			<cfloop
				from="1"
				to="#Arraylen(cartDetail)#"
				index="location" >
				<cfset currentItem = "#cartDetail[location]#" />
				<cfset isPresent = "false" />
				<cfinvoke
						component="Database"
						method="retrieveFromInventory"
						returnvariable="inventoryItems">

						<cfinvokeargument
								name="productId"
								value="#cartDetail[location].productId#">
						<cfinvokeargument
								name="quantity"
								value="#cartDetail[location].productCount#">
				</cfinvoke>

				<cfloop query="inventoryItems">
					<cfif InventoryId eq currentItem.inventoryId>
						<cfset isPresent = "true" />
					 	<cfset currentItem.maxCount = availableQuantity />
					</cfif>
				</cfloop>
			<!--- if item is not present append its location to error --->
				<cfif !isPresent>
					<cfset cartItemInfo = {
								location = "#location#",
								productId = "#currentItem.productId#"
								} />
					<cfset ArrayAppend(LOCAL.Response.Errors,
								cartItemInfo) />
				</cfif>
			</cfloop>

		<!--- check if error is present --->
			<cfif NOT ArrayLen(LOCAL.Response.Errors)>
			<!--- create a order id in database --->
				<cfinvoke
					component="Database"
					method="insertOrder"
					returnvariable="order">

					<cfinvokeargument
						name="customerId"
						value="#SESSION.user.userId#" />
				</cfinvoke>

			<!--- get order id --->
				<cfinvoke
					component="Database"
					method="retrieveOrderId"
					returnvariable="order">

					<cfinvokeargument
						name="customerId"
						value="#SESSION.user.userId#">
				</cfinvoke>

				<cfparam name="orderId" default="" />

				<cfloop query="order">
					<cfset orderId = "#OrderId#" />
					<cfbreak />
				</cfloop>

			<!--- write each item in cart to database --->
					<cfloop
					from="1"
					to="#Arraylen(cartDetail)#"
					index="location">

					<cfset orderDetail = {
						orderId = "#orderId#",
						productId = "#cartDetail[location].productId#",
						orderQuantity = "#cartDetail[location].productCount#",
						shippingAddressId = "#SESSION.address.addressId#",
						sellingCompanyId = "#cartDetail[location].sellingCompanyId#",
						unitprice ="#cartDetail[location].price#",
						discountPercent = "#cartDetail[location].discount#"
						} />

				<!--- write order details--->
					<cfinvoke
						component="Database"
						method="insertOrderDetail"
						argumentcollection="#orderDetail#"
						returnvariable="orderDetail">
					</cfinvoke>

				<!--- update availableQuantity for each product in inventory --->
						<cfinvoke
							component="Database"
							method="updateAvailableQuantity">

							<cfinvokeargument
								name="availableQuantity"
								value="#cartDetail[location].maxCount - cartDetail[location].productCount#" />
							<cfinvokeargument
								name="sellingCompanyId"
								value="#cartDetail[location].sellingCompanyId#" />
							<cfinvokeargument
								name="productId"
								value="#cartDetail[location].productId#" />
						</cfinvoke>
				</cfloop>
				<cfset SESSION.cart=[] />
				<cfset SESSION.address={} />
			</cfif>
			<cfif Arraylen(LOCAL.Response.Errors)>
				<cfset LOCAL.Response.Success = "false" />
			</cfif>
		<cfreturn LOCAL.Response />
	</cffunction>

<!--- retrieveProductFromInventory --->
	<cffunction name="retrieveProductFromInventoryByCompany"
				access="public"
				returnformat="json"
				returntype="any">

			<cfset sellingCompanyId="#session.user.SellingCompanyId#"/>

			<cfinvoke component="Database"
						method="retrieveProductFromInventoryByCompany"
						returnvariable="inventoryProducts">
					<cfinvokeargument name="sellingCompanyId"
										value="#sellingCompanyId#" />
			</cfinvoke>
			<cfreturn inventoryProducts />
	</cffunction>

</cfcomponent>