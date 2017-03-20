<!---
  --- controller
  --- ----------
  ---
  --- author: mindfire
  --- date:   3/10/17
  --->
<cfcomponent accessors="true" output="false" persistent="false">

<!--- login controller --->
	<cffunction name="logIn"
			access="remote"
			returntype="Any"
			returnformat="json">

	<!--- arguments defination --->
		<cfargument	name="email"
		 	required="true" />
		<cfargument
			name="password"
			required="true" />

	<!--- call login function from model.user --->
		<cfinvoke
			component="model.User"
			method="logIn"
			returnvariable="logInInfo" >

			<cfinvokeargument
				name="email"
				value="#ARGUMENTS.email#" />
			<cfinvokeargument
				name="password"
				value="#HASH(ARGUMENTS.password)#" />
		</cfinvoke>
		<cfreturn logInInfo />
	</cffunction>

<!--- logout controller --->
	<cffunction	name="logOut"
			access="remote"
			returntype="Any"
			returnformat="json">

	<!--- call logout function from model.user --->
		<cfinvoke
			component="model.User"
			method="logOut"
			returnvariable="response"
			>
		</cfinvoke>
		<cfreturn response />
	</cffunction>


<!--- call the registerUser() function --->
	<cffunction	name="registerUser"
			access="remote"
			returntype="Any"
			returnformat ="json">

	<!--- argument defination --->
		<cfargument
			name="email"
			type="string"
			required="true" />

		<cfargument
			name="password"
			type="string"
			required="true" />

		<cfargument
			name="name"
			type="string"
			required="true" />

		<cfargument
			name="mobileNumber"
			type="numeric"
			required="true" />
	<!--- set argument collection to pass --->
		<cfset userInfo = {
				email = "#ARGUMENTS.email#",
				password = "#HASH(ARGUMENTS.password)#",
				name = "#ARGUMENTS.name#",
				mobileNumber = "#ARGUMENTS.mobileNumber#"
			} />

	<!---call register function from model.User --->
		<cfinvoke
			component="model.User"
			method="registerUser"
			returnvariable="registerInfo"
			argumentcollection="#userInfo#">
		</cfinvoke>


		<cfreturn registerInfo />
	</cffunction>

<!--- retrieveProductCategory controller --->
	<cffunction	name="retrieveProductCategory"
			returnformat="json"
			returntype="any"
			access="remote">

			<cfinvoke
				component="model.Product"
				method="retrieveProductCategory"
				returnvariable="productCategory">
			</cfinvoke>

			<cfreturn productCategory />
	</cffunction>


<!--- retrieveProductSubCategory controller --->
	<cffunction	name="retrieveProductSubCategory"
			returnformat="json"
			returntype="any"
			access="remote">

		<cfargument
				name="productCategoryId"
				required="true"
				type="numeric">
			<cfinvoke
				component="model.Product"
				method="retrieveProductSubCategory"
				returnvariable="productSubCategory">

				<cfinvokeargument
					name="productCategoryId"
					value="#ARGUMENTS.productCategoryId#">
			</cfinvoke>

			<cfreturn productSubCategory/>
	</cffunction>

<!--- getCartItems --->
	<cffunction	name="getCartItems"
		access="remote"
		returntype= "any">
		<cfinvoke
				component="model.Cart"
				method="getCartItems"
				returnvariable="cartItems">
		</cfinvoke>
		<cfreturn cartItems />
	</cffunction>

<!--- retriveProductBySubCategory --->
	<cffunction	name="retrieveProductBySubCategory"
			access="remote"
			returntype="any"
			returnformat="json">

			<cfargument
					name="productSubCategoryId"
					required="true"
					type="numeric" />

			<cfinvoke
				component="model.Product"
				method="retrieveProductBySubCategory"
				returnvariable="productBySubCategory">
				<cfinvokeargument
					name="productSubCategoryId"
					value="#ARGUMENTS.productSubCategoryId#">
			</cfinvoke>

			<cfreturn productBySubCategory/>
	</cffunction>


<!--- retrieveProductDetail --->
	<cffunction	name="retrieveProductDetail"
			access="remote"
			returnformat="json"
			returntype="Any">

			<cfargument
				name="productId"
				type="numeric"
				required="true">

			<cfinvoke
				component="model.Product"
				method = "retrieveProductDetail"
				returnvariable="productDetail">

				<cfinvokeargument
					name="productId"
					value="#ARGUMENTS.productId#">
			</cfinvoke>

			<cfreturn productDetail/>
	</cffunction>

<!--- addAddress ---->
	<cffunction name="insertAddress"
		access="remote"
		returntype="Any"
		returnformat="json">

		<cfargument
			name="addressLine1"
			required="true" />
		<cfargument
			name="addressLine2"
			required="false"
			default="" />
		<cfargument
			name="city"
			required="true" />
		<cfargument
			name="state"
			required="true" />
		<cfargument
			name="addressType"
			required="true"/>
		<cfargument
			name="pincode"
			required="true" />

		<cfset addressDetail = {
				customerId = "#SESSION.user.userId#",
				addressLine1 = "#ARGUMENTS.addressLine1#",
				addressLine2 = "#ARGUMENTS.addressLine2#",
				city = "#ARGUMENTS.city#",
				state = "#ARGUMENTS.state#",
				addressType = "#ARGUMENTS.addressType#",
				pincode = "#ARGUMENTS.pincode#"
				} />
		<cfinvoke
			component="model.User"
			method="insertAddress"
			argumentcollection="#addressDetail#"
			returnvariable="addressDetail"
			>
		</cfinvoke>

		<cfreturn addressDetail />
	</cffunction>

<!--- insertOrderDetail --->
	<cffunction	name="insertOrderDetail"
		access="remote"
		returntype="Any"
		returnformat="json" >
		<cfinvoke
			component="model.Product"
			method="insertOrderDetail"
			returnvariable="orderDetail">
		</cfinvoke>
		<cfreturn orderDetail />
	</cffunction>

<!--- searchSuggestion --->
	<cffunction name="searchSuggestion"
			access="remote"
			returnformat="json"
			returntype="any">

		<cfargument
				name="searchItem"
				required="true" />

		<cfinvoke component="model.Product"
					method="searchSuggestion"
					returnvariable="searchResponse">
				<cfinvokeargument name="searchItem"
						value="#ARGUMENTS.searchItem#" />
		</cfinvoke>
		<cfreturn searchResponse />
	</cffunction>

<!--- retrieveAddresses --->
	<cffunction name="retrieveAddress"
			access="remote"
			returntype="any"
			returnformat="json">

			<cfinvoke
				component="model.User"
				method="retrieveAddress"
				returnvariable="address">
			</cfinvoke>

			<cfreturn address />
	</cffunction>

<!--- retrieveOrderDetails --->
	<cffunction name="retrieveOrderDetails"
			access="remote"
			returnformat="json"
			returntype="any">
		<cfinvoke component="model.User"
				method="retrieveOrderDetails"
				returnvariable="orderDetails">
		</cfinvoke>
		<cfreturn orderDetails />
	</cffunction>


</cfcomponent>