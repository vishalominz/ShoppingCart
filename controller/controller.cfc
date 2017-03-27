<!---
  --- controller
  --- ----------
  ---
  --- author: mindfire
  --- date:   3/10/17
  --->
<cfcomponent accessors="true" output="false" persistent="false">

<!--- switchUser controller --->
	<cffunction name="switchUser"
				access="remote"
				returntype="any"
				returnformat="json">

			<cfinvoke component="model.User"
					method="switchUser"
					returnvariable="responseObj">
			</cfinvoke>

			<cfreturn responseObj />
	</cffunction>


<!--- login controller --->
	<cffunction name="logIn"
			access="remote"
			returntype="Any"
			returnformat="json">

	<!--- arguments defination --->
		<cfargument	name="email"
		 	required="true" />
		<cfargument	name="password"
			required="true" />
		<cfargument
			name="company"
			required="false"
			default="">
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
			<cfif session.isSeller>
				<cfinvokeargument
					name="company"
					value="#ARGUMENTS.company#" />
			</cfif>
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


<!--- removeAddress --->
	<cffunction name="removeAddress"
				access="remote"
				returntype="any"
				returnformat="json">

			<cfargument name="addressId"
						required="true" />
			<cfinvoke component="model.user"
						method="removeAddress"
						returnvariable="responseObject">
					<cfinvokeargument name="addressId"
									value="ARGUMENTS.addressId"/>
			</cfinvoke>
			<cfreturn responseObject />
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

<!--- retrieveOrderHistory --->
	<cffunction name="retrieveOrderHistory"
				access="remote"
				returnformat="json"
				returntype="any">

			<cfinvoke component="model.User"
						method="retrieveOrderHistory"
						returnvariable="orderHistory">
			</cfinvoke>

			<cfreturn orderHistory />
	</cffunction>

<!--- retrieveOrderHistoryDetail --->
	<cffunction name="retrieveOrderHistoryDetail"
				access="remote"
				returntype="any"
				returnformat="json">

			<cfargument name="orderId"
						required="true" />

			<cfinvoke component="model.User"
					method="retrieveOrderHistoryDetail"
					returnvariable="orderItems">
					<cfinvokeargument name="orderId"
							value="#ARGUMENTS.orderId#">
			</cfinvoke>

			<cfreturn orderItems />
	</cffunction>

<!--- retieveUserInformation --->
	<cffunction name="retrieveUserInformation"
				access="remote"
				returnformat="json"
				returntype="any">
			<cfinvoke component="model.User"
						method="retrieveUserInformation"
						returnvariable="userInformation">
			</cfinvoke>
			<cfreturn userInformation />
	</cffunction>


<!--- updateUserProfilePicture --->
	<cffunction name="updateUserProfilePicture"
				access="remote"
				returnformat="json"
				returntype="any"
				output="true">
			<cfargument name="formData"
						required="false"
						default=""/>
			<cfoutput>
				<cfdump var="#form#"/>
				<cfset session.formvalue="#form#"/>
			</cfoutput>
			<cfset session.controller = "#formData#" />
			<cfinvoke component="model.User"
						method="updateUserProfilePicture"
						returnvariable="ResponseObject">
					<cfinvokeargument name="formData"
									value="#ARGUMENTS.formData#">
			</cfinvoke>

			<cfreturn ResponseObject>
	</cffunction>

</cfcomponent>