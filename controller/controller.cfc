<!---
  --- controller
  --- ----------
  ---
  --- author: mindfire
  --- date:   3/10/17
  --->
<cfcomponent accessors = "true" output = "true" persistent = "false">
<!--- switchUser controller --->
	<cffunction name = "switchUser"
				access = "remote"
				returntype = "any"
				returnformat = "json">

			<cfinvoke component = "model.User"
					method = "switchUser"
					returnvariable = "responseObj">
			</cfinvoke>

			<cfreturn responseObj />
	</cffunction>


<!--- login controller --->
	<cffunction name = "logIn"
			access = "remote"
			returntype = "Any"
			returnformat = "json">

	<!--- arguments defination --->
		<cfargument	name = "email"
		 	required = "true" />
		<cfargument	name = "password"
			required = "true" />
		<cfargument
			name = "company"
			required = "false"
			default = "">
	<!--- call login function from model.user --->
		<cfinvoke
			component = "model.User"
			method = "logIn"
			returnvariable = "logInInfo" >

			<cfinvokeargument
				name = "email"
				value = "#ARGUMENTS.email#" />
			<cfinvokeargument
				name = "password"
				value = "#HASH(ARGUMENTS.password)#" />
			<cfif session.isSeller>
				<cfinvokeargument
					name = "company"
					value = "#ARGUMENTS.company#" />
			</cfif>
		</cfinvoke>
		<cfreturn logInInfo />
	</cffunction>

<!--- logout controller --->
	<cffunction	name = "logOut"
			access = "remote"
			returntype = "Any"
			returnformat = "json">

	<!--- call logout function from model.user --->
		<cfinvoke
			component = "model.User"
			method = "logOut"
			returnvariable = "response"
			>
		</cfinvoke>
		<cfreturn response />
	</cffunction>


<!--- call the registerUser() function --->
	<cffunction	name = "registerUser"
			access = "remote"
			returntype = "Any"
			returnformat  = "json">

	<!--- argument defination --->
		<cfargument
			name = "email"
			type = "string"
			required = "true" />

		<cfargument
			name = "password"
			type = "string"
			required = "true" />

		<cfargument
			name = "name"
			type = "string"
			required = "true" />

		<cfargument
			name = "mobileNumber"
			type = "numeric"
			required = "true" />
		<cfargument
			name = "company"
			type="string"
			required="true" />

	<!--- set argument collection to pass --->
		<cfset userInfo  =  {
				email  =  "#ARGUMENTS.email#",
				password  =  "#HASH(ARGUMENTS.password)#",
				name  =  "#ARGUMENTS.name#",
				mobileNumber  =  "#ARGUMENTS.mobileNumber#",
				company = "#ARGUMENTS.company#"
			} />

	<!---call register function from model.User --->
		<cfinvoke
			component = "model.User"
			method = "registerUser"
			returnvariable = "registerInfo"
			argumentcollection = "#userInfo#">
		</cfinvoke>
		<cfreturn registerInfo />
	</cffunction>

<!--- retrieveProductCategory controller --->
	<cffunction	name = "retrieveProductCategory"
			returnformat = "json"
			returntype = "any"
			access = "remote">

			<cfinvoke
				component = "model.Product"
				method = "retrieveProductCategory"
				returnvariable = "productCategory">
			</cfinvoke>

			<cfreturn productCategory />
	</cffunction>

<!--- retrieveProductFromInventoryByCompany ---->
	<cffunction name = "retrieveProductFromInventoryByCompany"
				access = "remote"
				returnformat = "json"
				returntype = "any">
			<cfinvoke component = "model.Product"
						method = "retrieveProductFromInventoryByCompany"
						returnvariable = "inventoryProducts">
			</cfinvoke>
			<cfreturn inventoryProducts />
	</cffunction>

<!--- retrieveProductSubCategory controller --->
	<cffunction	name = "retrieveProductSubCategory"
			returnformat = "json"
			returntype = "any"
			access = "remote">

		<cfargument
				name = "productCategoryId"
				required = "true"
				type = "numeric">
			<cfinvoke
				component = "model.Product"
				method = "retrieveProductSubCategory"
				returnvariable = "productSubCategory">

				<cfinvokeargument
					name = "productCategoryId"
					value = "#ARGUMENTS.productCategoryId#">
			</cfinvoke>

			<cfreturn productSubCategory/>
	</cffunction>
	
<!--- retriveProductBySubCategory --->
	<cffunction	name = "retrieveProductBySubCategory"
			access = "remote"
			returntype = "any"
			returnformat = "json">

			<cfargument
					name = "productSubCategoryId"
					required = "true"
					type = "numeric" />

			<cfinvoke
				component = "model.Product"
				method = "retrieveProductBySubCategory"
				returnvariable = "productBySubCategory">
				<cfinvokeargument
					name = "productSubCategoryId"
					value = "#ARGUMENTS.productSubCategoryId#">
			</cfinvoke>

			<cfreturn productBySubCategory/>
	</cffunction>

<!--- retrieveProductDetail --->
	<cffunction	name = "retrieveProductDetail"
			access = "remote"
			returnformat = "json"
			returntype = "Any">

			<cfargument
				name = "productId"
				type = "numeric"
				required = "true">

			<cfinvoke
				component = "model.Product"
				method  =  "retrieveProductDetail"
				returnvariable = "productDetail">

				<cfinvokeargument
					name = "productId"
					value = "#ARGUMENTS.productId#">
			</cfinvoke>

			<cfreturn productDetail/>
	</cffunction>

<!--- addAddress ---->
	<cffunction name = "insertAddress"
		access = "remote"
		returntype = "Any"
		returnformat = "json">

		<cfargument
			name = "addressLine1"
			required = "true" />
		<cfargument
			name = "addressLine2"
			required = "false"
			default = "" />
		<cfargument
			name = "city"
			required = "true" />
		<cfargument
			name = "state"
			required = "true" />
		<cfargument
			name = "addressType"
			required = "true"/>
		<cfargument
			name = "pincode"
			required = "true" />

		<cfset addressDetail  =  {
				customerId  =  "#SESSION.user.userId#",
				addressLine1  =  "#ARGUMENTS.addressLine1#",
				addressLine2  =  "#ARGUMENTS.addressLine2#",
				city  =  "#ARGUMENTS.city#",
				state  =  "#ARGUMENTS.state#",
				addressType  =  "#ARGUMENTS.addressType#",
				pincode  =  "#ARGUMENTS.pincode#"
				} />
		<cfinvoke
			component = "model.User"
			method = "insertAddress"
			argumentcollection = "#addressDetail#"
			returnvariable = "addressDetail"
			>
		</cfinvoke>

		<cfreturn addressDetail />
	</cffunction>

<!--- updateAddress --->
	<cffunction name = "updateAddress"
				access = "remote"
				returnformat = "json"
				returntype = "any">
		<cfargument 
			name = "addressId"
			required = "true"	/>		
		<cfargument
			name = "addressLine1"
			required = "true" />
		<cfargument
			name = "addressLine2"
			required = "false"
			default = "" />
		<cfargument
			name = "city"
			required = "true" />
		<cfargument
			name = "state"
			required = "true" />
		<cfargument
			name = "addressType"
			required = "true"/>
		<cfargument
			name = "pincode"
			required = "true" />

		<cfset addressDetail  =  {
				addressId  =  "#ARGUMENTS.addressId#",
				customerId  =  "#SESSION.user.userId#",
				addressLine1  =  "#ARGUMENTS.addressLine1#",
				addressLine2  =  "#ARGUMENTS.addressLine2#",
				city  =  "#ARGUMENTS.city#",
				state  =  "#ARGUMENTS.state#",
				addressType  =  "#ARGUMENTS.addressType#",
				pincode  =  "#ARGUMENTS.pincode#"
				} />
		<cfinvoke
			component = "model.User"
			method = "updateAddress"
			argumentcollection = "#addressDetail#"
			returnvariable = "addressDetail"
			>
		</cfinvoke>

		<cfreturn addressDetail />

	</cffunction>

<!--- insertOrderDetail --->
	<cffunction	name = "insertOrderDetail"
		access = "remote"
		returntype = "Any"
		returnformat = "json" >
		<cfinvoke
			component = "model.Product"
			method = "insertOrderDetail"
			returnvariable = "orderDetail">
		</cfinvoke>
		<cfreturn orderDetail />
	</cffunction>

<!--- searchSuggestion --->
	<cffunction name = "searchSuggestion"
			access = "remote"
			returnformat = "json"
			returntype = "any">

		<cfargument name = "searchItem"
					required = "true" />
		<cfargument name = "brandList" 
					required = "false" default = ""/>
		<cfargument name = "minPrice" 
					required = "false" default = 0 />
		<cfargument name = "maxPrice" 
					required = "false" default = 100000 />
		<cfinvoke component = "model.Product"
					method = "searchSuggestion"
					returnvariable = "searchResponse">
				<cfinvokeargument name = "searchItem"
						value = "#ARGUMENTS.searchItem#" />
				<cfinvokeargument name = "brandList"
						value = "#ARGUMENTS.brandList#" />
				<cfinvokeargument name = "minPrice"
						value = "#ARGUMENTS.minPrice#" />
				<cfinvokeargument name = "maxPrice"
						value = "#ARGUMENTS.maxPrice#" />
		</cfinvoke>
		<cfreturn searchResponse />
	</cffunction>

<!--- retrieveAddresses --->
	<cffunction name = "retrieveAddress"
			access = "remote"
			returntype = "any"
			returnformat = "json">

			<cfinvoke
				component = "model.User"
				method = "retrieveAddress"
				returnvariable = "address">
			</cfinvoke>

			<cfreturn address />
	</cffunction>

<!--- removeAddress --->
	<cffunction name = "removeAddress"
				access = "remote"
				returntype = "any"
				returnformat = "json">

			<cfargument name = "addressId"
						required = "true" />
			<cfinvoke component = "model.user"
						method = "removeAddress"
						returnvariable = "responseObject">
					<cfinvokeargument name = "addressId"
									value = "#ARGUMENTS.addressId#"/>
			</cfinvoke>
			<cfreturn responseObject />
	</cffunction>

<!--- retrieveOrderDetails --->
	<cffunction name = "retrieveOrderDetails"
			access = "remote"
			returnformat = "json"
			returntype = "any">
		<cfargument name = "orderId"
					required = "true" />
		<cfinvoke component = "model.User"
				method = "retrieveOrderDetails"
				returnvariable = "orderDetails">
				<cfinvokeargument name = "orderId"
								value = "#ARGUMENTS.orderId#" />
		</cfinvoke>
		<cfreturn orderDetails />
	</cffunction>

<!--- retrieveOrderHistory --->
	<cffunction name = "retrieveOrderHistory"
				access = "remote"
				returnformat = "json"
				returntype = "any">

			<cfinvoke component = "model.User"
						method = "retrieveOrderHistory"
						returnvariable = "orderHistory">
			</cfinvoke>

			<cfreturn orderHistory />
	</cffunction>

<!--- retrieveOrderHistoryDetail --->
	<cffunction name = "retrieveOrderHistoryDetail"
				access = "remote"
				returntype = "any"
				returnformat = "json">

			<cfargument name = "orderId"
						required = "true" />

			<cfinvoke component = "model.User"
					method = "retrieveOrderHistoryDetail"
					returnvariable = "orderItems">
					<cfinvokeargument name = "orderId"
							value = "#ARGUMENTS.orderId#">
			</cfinvoke>

			<cfreturn orderItems />
	</cffunction>

<!--- retieveUserInformation --->
	<cffunction name = "retrieveUserInformation"
				access = "remote"
				returnformat = "json"
				returntype = "any">
			<cfinvoke component = "model.User"
						method = "retrieveUserInformation"
						returnvariable = "userInformation">
			</cfinvoke>
			<cfreturn userInformation />
	</cffunction>

<!--- updateUserProfilePicture --->
	<cffunction name = "updateUserProfilePicture"
				access = "remote"
				returnformat = "json"
				returntype = "any"
				output = "true">
			<cfargument name = "formData"
						required = "true">
			<cfinvoke component = "model.User"
						method = "updateUserProfilePicture"
						returnvariable = "ResponseObject">
					<cfinvokeargument name = "formData"
									value = "#ARGUMENTS.formData#">
			</cfinvoke>

			<cfreturn ResponseObject>
	</cffunction>

<!--- insertProduct --->
	<cffunction name = "insertProduct"
				access = "public"
				returnformat = "json"
				returntype = "any"
				hint = "Seller insert's a product">
			<cfargument name = "productName"
						required = "true" />
			<cfargument name = "productBrand"
						required = "true" />
			<cfargument name = "leastPrice"
						required = "true" />
			<cfargument name =  "productDescription"
						required = "true" />
			<cfargument name =  "productCategory"
						required = "true" />
			<cfargument name =  "productSubCategory"
						required = "true" />

			<cfset productDetail  =  {
					productName  =  ARGUMENTS.productName,
					productBrand  =  ARGUMENTS.productBrand,
				    leastPrice  =  ARGUMENTS.leastPrice,
				    productDescription  =  ARGUMENTS.productDescription,
				    productCategoryId  =  form.productCategory,
					productSubCategoryId  =  form.productSubCategory } />

			<cfinvoke component = "model.Seller"
						method = "insertProduct"
						returnvariable = "productInfo"
						argumentcollection = "#productDetail#">

			</cfinvoke>
			<cfreturn productInfo />
	</cffunction>

<!--- deleteProductFromInventory --->
	<cffunction name = "deleteProductFromInventory"
				access = "remote"
				returnformat = "json"
				returntype = "any">
			
			<cfargument name = "inventoryId"
						required = "true"/>
			<cfinvoke component = "model.Seller"
						method = "deleteProductFromInventory"
						returnvariable = "responseObject">
					<cfinvokeargument name = "inventoryId"
									value = "#ARGUMENTS.inventoryId#" />
			</cfinvoke>
			<cfreturn responseObject />
	</cffunction>

<!--- updateProductInInventory --->
	<cffunction name = "updateProductInInventory"
				access = "remote"
				returntype = "any"
				returnformat = "json">
			<cfargument name = "sellingPrice"
						required = "true" />
			<cfargument name = "quantity"
						required = "true" />
			<cfargument name = "discount"
						required = "true" />
			<cfargument name = "inventoryId"
						required = "true" />
			<cfinvoke component = "model.Seller"
						method = "updateProductInInventory"
						returnvariable = "responseObject">
					<cfinvokeargument name = "inventoryId"
										value = "#ARGUMENTS.inventoryId#" />
					<cfinvokeargument name = "sellingPrice"
										value = "#ARGUMENTS.sellingPrice#" />
					<cfinvokeargument name = "quantity"
										value = "#ARGUMENTS.quantity#" />
					<cfinvokeargument name = "discount"
										value = "#ARGUMENTS.discount#" />
			</cfinvoke>				
			<cfreturn responseObject />
	</cffunction>

<cffunction name = "insertProductInInventory"
			access = "public"
			returnformat = "json"
			returntype = "any">
		<cfargument name = "productId"
					required = "true" />
		<cfargument name = "availableQuantity"
					required = "true" />
		<cfargument name = "sellingPrice"
					required = "true" />
		<cfargument name = "discount"
					required = "true" />
		<cfset args  =  {
			productId  =  ARGUMENTS.productId,
			availableQuantity  =  ARGUMENTS.availableQuantity,
			sellingPrice  =  ARGUMENTS.sellingPrice,
			discount  =  ARGUMENTS.discount
		} />
		<cfinvoke component = "model.Seller"
					method = "insertProductInInventory"
					returnvariable = "insertedItem"
					argumentcollection = "#args#">	
		</cfinvoke>
		<cfreturn insertedItem />
</cffunction>


	<cffunction name = "insertProductCategory"
				access = "remote"
				returnformat = "json"
				returntype = "any">
			<cfargument name = "categoryName"
						required = "true" />

			<cfinvoke component = "model.Seller"
						method = "insertProductCategory"
						returnvariable = "ResponseObject">
					<cfinvokeargument name = "categoryName"
							value = "#ARGUMENTS.categoryName#" />	
			</cfinvoke>		
			<cfreturn ResponseObject />
	</cffunction>


<!--- sellerSearchProducts--->
	<cffunction name = "sellerSearchProducts"
				access = "remote"
				returnformat = "json"
				returntype = "any">
			<cfargument name = "searchValue"
					required = "true" />
			
			<cfinvoke component = "model.Seller"
					method = "sellerSearchProducts"
					returnvariable = "products">
				<cfinvokeargument name = "searchValue"
							value = "#ARGUMENTS.searchValue#" />	
			</cfinvoke>
			<cfreturn products />					

	</cffunction>

<!--- retrieveBrandNames --->
	<cffunction name = "retrieveBrandNames"
				access = "remote"
				returntype = "any"
				returnformat = "json">
					
			<cfinvoke component = "model.Product"
						method = "retrieveBrandNames"
						returnvariable = "brands">
			</cfinvoke>

			<cfreturn brands />
	</cffunction>
	
<!--- retrieveMostSoldProducts --->
	<cffunction name = "retrieveMostSoldProducts"
			access = "remote"
			returntype = "any"
			returnformat = "json">
		<cfargument name = "sellingCompanyId"
					required = "true" />
		<cfinvoke component = "model.Database"
					method = "retrieveMostSoldProducts"
					returnvariable = "mostSoldProducts">
				<cfinvokeargument name = "sellingCompanyId"
					value = "#arguments.sellingCompanyId#" />
		</cfinvoke>
		<cfreturn mostSoldProducts />
	</cffunction>


<!--- insertProductSubCategory --->
	<cffunction name = "insertProductSubCategory"
			access = "remote"
			returntype = "any"
			returnformat = "json">
		<cfargument name = "categoryName"
					required = true />
		<cfargument name = "subCategoryName"	
					required = true />
		<cfinvoke component = "model.Seller"
					method = "insertProductSubCategory"
					returnvariable="responseObject">
				<cfinvokeargument name="categoryName"
								value="#ARGUMENTS.categoryName#" />
				<cfinvokeargument name="subCategoryName"
								value="#ARGUMENTS.subCategoryName#" />
		</cfinvoke>
		<cfreturn responseObject />
	</cffunction>	


<!---- add to cart --->
	<cffunction name="AddToCart"
				access="remote"
				returntype="struct"
				returnformat="json" 
				hint="Redirects to Add to Cart function">
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
				name="InventoryId"
				type="string"
				required="true"
				hint="Inventory Id"
				/>
			<cfargument
				name="orderQuantity"
				type="numeric"
				required="false"
				default="1"
				hint="No of items being ordered">
			
			<cfset LOCAL.productInfo = {
					productId = ARGUMENTS.productId,
					productName = ARGUMENTS.productName,
					productDescription = ARGUMENTS.productDescription,
					productBrand = ARGUMENTS.productBrand,
					productImageLocation = ARGUMENTS.productImageLocation,
					orderQuantity = ARGUMENTS.orderQuantity,
					inventoryId = ARGUMENTS.inventoryId
			  } />
			<cfinvoke component = "model.Cart"
					method="AddToCart"
					returnvariable="ResponseObject"
					argumentcollection="#LOCAL.productInfo#">
			</cfinvoke>
			<cfreturn ResponseObject />
	</cffunction>

<!--- Delete from Cart --->
	<cffunction	name="DeleteFromCart"
			access="remote"
			returntype="struct"
			returnformat="json"
			hint="Redirects to Delete Item from cart function" >
				
			<cfargument
				name="productId"
				type="string"
				required="true"
				hint="Product ID of product to delete">

			<cfinvoke component="model.Cart"
						method="DeleteFromCart"
						returnvariable="ResponseObject" >
					<cfinvokeargument name="productId"
									value="#ARGUMENTS.productId#" />
			</cfinvoke>	
			<cfreturn ResponseObject />
	</cffunction>

<!--- Get Cart Items --->
	<cffunction	name="GetCartItems"
			access="public"
			reutrntype="struct"
			returnformat="json"
			output = "false"
			hint="Redirects to Get Cart Items function">

			<cfinvoke component="model.Cart"
					method="GetCartItems"
					returnvariable="ResponseObject" >
			</cfinvoke>
			<cfreturn ResponseObject />
	</cffunction>				

<!--- Update Cart Item Count --->
	<cffunction name="UpdateCartItem"
				access="remote"
				returnformat="json"
				returntype="struct"
				hint="Redirects to Update Cart function">

			<cfargument name="countValue"
						required="true" />
			<cfargument name="productId"
						required="true" />
			<cfargument name="inventoryId"
						required="true" />
			<cfset LOCAL.productCountInfo = {
					countValue = ARGUMENTS.countValue,
					productId = ARGUMENTS.productId,
					inventoryId = ARGUMENTS.inventoryId
					} />
			<cfinvoke component="model.Cart"
					method="UpdateCartItem"
					returnvariable="ResponseObject"
					argumentcollection="#LOCAL.productCountInfo#">
			</cfinvoke>
			<cfreturn ResponseObject />
	</cffunction>

</cfcomponent>