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
			returntype="query"
			access="public">

		<cfargument
				name="productCategoryId"
				required="true"
				type="numeric">
			
			<cftry>
				<cfinvoke
					component="Database"
					method="retrieveProductSubCategory"
					returnvariable="productSubCategory">

					<cfinvokeargument
						name="productCategoryId"
						value="#ARGUMENTS.productCategoryId#">
				</cfinvoke>
				<cfset message = "Successfully retrieved Product Sub Category List" />
				<cfset THIS.log("SUCCESS","Product",getFunctionCalledName(),message) />
				<cfcatch type="database">
					<cfset message = "Failed to retrieve Product Sub Category List" />
					<cfset THIS.log("ERROR","Product",getFunctionCalledName(),message) />
				</cfcatch>
			</cftry>
			
			<cfreturn productSubCategory/>
	</cffunction>

<!--- retrieveProductCategory from database --->
	<cffunction	name="retrieveProductCategory"
			returnformat="json"
			returntype="any"
			access="public">

			<cftry>
				<cfinvoke
					component="Database"
					method="retrieveProductCategory"
					returnvariable="productCategory">
				</cfinvoke>
				<cfset message = "Successfully retrieved Product Category List" />
				<cfset THIS.log("SUCCESS","Product",getFunctionCalledName(),message) />
				<cfcatch type="database">
					<cfset message = "Failed to retrieve Product Category List" />
					<cfset THIS.log("ERROR","Product",getFunctionCalledName(),message) />
				</cfcatch>
			</cftry>
			<cfreturn productCategory />
	</cffunction>

<!--- retrieveProductBySubCategory --->
	<cffunction	name="retrieveProductBySubCategory"
			returntype="any"
			returnformat="json"
			access="public">

			<cfargument	name="productSubCategoryId"
						type="numeric"
						required="true" />

			<cftry>			
				<cfinvoke component="Database"
						method="retrieveProductBySubCategory"
						returnvariable="productBySubCategory">

					<cfinvokeargument name="productSubCategoryId"
									value="#ARGUMENTS.productSubCategoryId#">

				</cfinvoke>
					<cfset message = "Successfully Retrieved Products by Sub Category." />
					<cfset THIS.log("SUCCESS","Product",getFunctionCalledName(),message) />
				<cfcatch type="database">
					<cfset message = "Failed to retrieve Product By Sub Category." />
					<cfset THIS.log("ERROR","Product",getFunctionCalledName(),message) />
				</cfcatch>
			</cftry>
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

				<cftry>
					<cfinvoke
						component="Database"
						method = "retrieveProductDetail"
						returnvariable="productDetail">

						<cfinvokeargument
							name="productId"
							value="#ARGUMENTS.productId#">
					</cfinvoke>
					<cfset message = "Product details for Product Id = #ARGUMENTS.productId#" />
					<cfset THIS.log("SUCCESS","Product",getFunctionCalledName(),message) />
					<cfcatch type="database">
						<cfset message = "Failed to retrieve product Detail of product =  #ARGUMENTS.productId#"/>
						<cfset THIS.log("ERROR","Product",getFunctionCalledName(),message) />
					</cfcatch>
				</cftry>
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
			<cfargument name="brandList" 
					required="true"/>
			<cfargument name="minPrice" 
					required="true" />
			<cfargument name="maxPrice" 
					required="true" />
			<cfset session.Product= brandList />
		<!--- Get a new API response --->
			<cfset var LOCAL = {} />
		<!--- Get a new API response --->
			<cfset LOCAL.Response = THIS.GetNewResponse() />

			<cfif NOT len(searchItem)>
				<cfset ArrayAppend(LOCAL.Response.Errors,
					"Search value is null") />
			</cfif>

			<cfif NOT ArrayLen(LOCAL.Response.Errors)>
				<cftry>
					<cfinvoke
						component="Database"
						method="searchProduct"
						returnvariable="searchItems">

						<cfinvokeargument name="searchItem"
								value="#ARGUMENTS.searchItem#" />
						<cfinvokeargument name="brandList"
							value="#ARGUMENTS.brandList#" />
						<cfinvokeargument name="minPrice"
							value="#ARGUMENTS.minPrice#" />
						<cfinvokeargument name="maxPrice"
							value="#ARGUMENTS.maxPrice#" />
					</cfinvoke>
					<cfset message = "Product searched by name like %#ARGUMENTS.searchItem#%" />
					<cfset THIS.log("SUCCESS","Product",getFunctionCalledName(),message) />
					<cfcatch type="database">
						<cfset message = "Failed to search product by name like %#ARGUMENTS.searchItem#%" />
						<cfset THIS.log("ERROR","Product",getFunctionCalledName(),message) />
					</cfcatch>
				</cftry>
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
			returntype="struct"
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
				<cftry>
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
					<cfset message = "Product retrieved by #session.user.username#[#session.user.userId#]
									 from Inventory" />
					<cfset THIS.log("SUCCESS","Product",getFunctionCalledName(),message) />
					<cfcatch type="database">
						<cfset message = "Failed to retrieve product by #session.user.username#[#session.user.userId#]
										 from Inventory" />
						<cfset THIS.log("ERROR","Product",getFunctionCalledName(),message) />
					</cfcatch>
				</cftry>

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
				<cftry>
					<cfinvoke
						component="Database"
						method="insertOrder"
						returnvariable="orderId">

						<cfinvokeargument
							name="customerId"
							value="#SESSION.user.userId#" />
					</cfinvoke>
					<cfset message = "Order inserted by #session.user.username#[#session.user.userId#]
									" />
					<cfset THIS.log("SUCCESS","Product",getFunctionCalledName(),message) />
					<cfcatch type="database">
						<cfset message = "Failed to insert order by #session.user.username#[#session.user.userId#]" />
						<cfset THIS.log("ERROR","Product",getFunctionCalledName(),message) />
					</cfcatch>
				</cftry>
			
				<cfparam name="orderId" default="" />

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
					<cftry>
						<cfinvoke
							component="Database"
							method="insertOrderDetail"
							argumentcollection="#orderDetail#"
							returnvariable="orderDetail">
						</cfinvoke>
						<cfset message = "Inserted Order Details for #session.user.username#[#session.user.userId#]" />
						<cfset THIS.log("SUCCESS","Product",getFunctionCalledName(),message) />
						<cfcatch type="database">
							<cfset message = "Failed to insert orfer for #session.user.username#[#session.user.userId#]" />
							<cfset THIS.log("ERROR","Product",getFunctionCalledName(),message) />
						</cfcatch>
					</cftry>

				<!--- update availableQuantity for each product in inventory --->
					<cftry>
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
						<cfset message = "Avilable Quantity of product update by #session.user.username#[#session.user.userId#]" />
						<cfset THIS.log("SUCCESS","Product",getFunctionCalledName(),message) />
						<cfcatch type="database">
							<cfset message = "Failed to update available quantity by #session.user.username#[#session.user.userId#]" />
							<cfset THIS.log("ERROR","Product",getFunctionCalledName(),message) />
						</cfcatch>
					</cftry>
				</cfloop>
			<!--- reseting variables --->
				<cfset SESSION.cart=[] />
				<cfset SESSION.address={} />
				<cfset LOCAL.Response.Data = orderId />
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
				returntype="query">

			<cfset sellingCompanyId="#session.user.SellingCompanyId#"/>
			<cftry>
				<cfinvoke component="Database"
							method="retrieveProductFromInventoryByCompany"
							returnvariable="inventoryProducts">
						<cfinvokeargument name="sellingCompanyId"
											value="#sellingCompanyId#" />
				</cfinvoke>
				<cfset message = "Product retrieved by #session.user.username#[#session.user.userId#]
									of Selling Company ID = #sellingCompanyId#" />
				<cfset THIS.log("SUCCESS","Product",getFunctionCalledName(),message) />
				<cfcatch type="database">
					<cfset message = "Failed to retrieve product by #session.user.username#[#session.user.userId#]
									of Selling Company ID = #sellingCompanyId#" />
					<cfset THIS.log("ERROR","Product",getFunctionCalledName(),message) />
				</cfcatch>
			</cftry>
			<cfreturn inventoryProducts />
	</cffunction>

<!---- retrieveBrandNames --->
	<cffunction name="retrieveBrandNames"
				access="public"
				returnformat="json"
				returntype="query">
			<cftry>
				<cfinvoke component="Database"
							method="retrieveBrandNames"
							returnvariable="brands">
				</cfinvoke>
				<cfset message = "Brand Names retrieved successfully" />
				<cfset THIS.log("SUCCESS","Product",getFunctionCalledName(),message) />
				<cfcatch type="database">
					<cfset message = "Failed to retrive Brand Names" />
					<cfset THIS.log("ERROR","Product",getFunctionCalledName(),message) />
				</cfcatch>
			</cftry>
			<cfreturn brands />				
	</cffunction>

<!--- insertProductSubCategory --->
	<cffunction name = "insertProductSubCategory"
			access = "public"
			returntype="void"
			returnformat = "json">
		<cfargument name = "categoryName"
					required = true />
		<cfargument name = "subCategoryName"	
					required = true />
		<cftry>
			<cfinvoke component = "Database"
						method = "insertProductSubCategory">
					<cfinvokeargument name="categoryName"
									value="#ARGUMENTS.categoryName#" />
					<cfinvokeargument name="subCategoryName"
									value="#ARGUMENTS.subCategoryName#" />
			</cfinvoke>
			<cfset message = "Product Sub Category inserted in database by #session.user.username#[#session.user.userId#]" />
			<cfset THIS.log("SUCCESS","Product",getFunctionCalledName(),message) />
			<cfcatch type="database">
				<cfset message = "Failed to inset product sub category in database by #session.user.username#[#session.user.userId#]" />
				<cfset THIS.log("ERROR","Product",getFunctionCalledName(),message) />
			</cfcatch>
		</cftry>
	</cffunction>

<!--- retrieveProductByOtherSeller --->

</cfcomponent>